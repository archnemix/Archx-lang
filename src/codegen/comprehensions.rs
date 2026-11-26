//! Milestone 9 (`v0.9.0`) — 1:1 Pythonic comprehensions, generator-expression reductions,
//! and `zip(...)`.
//!
//! Lowering strategy: a comprehension becomes **one** nested loop nest that appends into a
//! single pre-sized output container. No intermediate list is ever built per filter stage,
//! and the loop nest is synthesized as ordinary statements, so it reuses the existing
//! ownership, drop, and growth machinery instead of duplicating it.
//!
//! * `[f(x) for x in xs]` — one allocation sized from the source length, so the append
//!   path never reallocs and never copies.
//! * `[f(x) for x in xs if p(x)]` — the filter becomes a nullary `if` around the append,
//!   which LLVM if-converts into a predicated store (branchless compaction).
//! * `sum`/`any`/`all`/`len` over a generator expression fold into a register accumulator
//!   with a single evaluation of the element expression — no list is allocated at all.
//! * `min`/`max` over a generator materialize once and reuse the existing reduction code.

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

impl Codegen {
    // ---------------- Static typing of synthesized expressions ---------------

    /// Conservative static type of an expression in the current codegen scope, used to
    /// type the synthesized element/accumulator of a comprehension.
    pub(super) fn infer_ty(&mut self, expr: &Expr) -> Option<Type> {
        match &expr.kind {
            ExprKind::Int(_) => Some(Type::Int),
            ExprKind::Float(_) => Some(Type::Float),
            ExprKind::Bool(_) => Some(Type::Bool),
            ExprKind::Str(_) | ExprKind::FString(_) => Some(Type::Str),
            ExprKind::NoneLit => None,
            ExprKind::Var(n) => self.lookup_var(n).map(|e| e.ty.clone()),
            ExprKind::TupleLit(es) => Some(Type::Tuple(
                es.iter()
                    .map(|e| self.infer_ty(e).unwrap_or(Type::Int))
                    .collect(),
            )),
            ExprKind::ArrayLit(es) => {
                if es.is_empty() {
                    return Some(Type::Array(Box::new(Type::Any)));
                }
                let mut tys = Vec::with_capacity(es.len());
                for e in es {
                    tys.push(self.infer_ty(e)?);
                }
                let first = tys[0].clone();
                let elem = if first != Type::Any && tys.iter().all(|t| *t == first) {
                    first
                } else {
                    Type::Any
                };
                Some(Type::Array(Box::new(elem)))
            }
            ExprKind::SetLit(es) => {
                let mut tys = Vec::with_capacity(es.len());
                for e in es {
                    tys.push(self.infer_ty(e)?);
                }
                let mut first = tys.first().cloned().unwrap_or(Type::Any);
                if !first.is_hashable_key() || tys.iter().any(|t| *t != first) {
                    first = Type::Any;
                }
                Some(Type::Set(Box::new(first)))
            }
            ExprKind::DictLit(ps) => {
                if ps.is_empty() {
                    return Some(Type::Dict(Box::new(Type::Any), Box::new(Type::Any)));
                }
                let mut kt = self.infer_ty(&ps[0].0).unwrap_or(Type::Any);
                let mut vt = self.infer_ty(&ps[0].1).unwrap_or(Type::Any);
                if !kt.is_hashable_key() {
                    kt = Type::Any;
                }
                for (ke, ve) in ps.iter().skip(1) {
                    if self.infer_ty(ke).as_ref() != Some(&kt) {
                        kt = Type::Any;
                    }
                    if self.infer_ty(ve).as_ref() != Some(&vt) {
                        vt = Type::Any;
                    }
                }
                Some(Type::Dict(Box::new(kt), Box::new(vt)))
            }
            ExprKind::Index { target, .. } => match self.infer_ty(target)? {
                Type::Array(inner) => Some(*inner),
                Type::Dict(_, v) => Some(*v),
                Type::Str => Some(Type::Str),
                Type::Any => Some(Type::Any),
                _ => None,
            },
            ExprKind::Slice { target, .. } => self.infer_ty(target),
            ExprKind::Field { target, field } => match self.infer_ty(target)? {
                Type::Struct(sname) => self
                    .structs
                    .get(&sname)?
                    .iter()
                    .find(|f| f.name == *field)
                    .map(|f| f.ty.clone()),
                _ => None,
            },
            ExprKind::Call { name, args } => {
                if let Some(sig) = self.sigs.get(name) {
                    return sig.ret.clone();
                }
                if self.structs.contains_key(name) {
                    return Some(Type::Struct(name.clone()));
                }
                match name.as_str() {
                    "len" | "int" | "ord" | "abs" => Some(Type::Int),
                    "float" | "sqrt" => Some(Type::Float),
                    "str" | "input" | "chr" | "type" => Some(Type::Str),
                    "bool" | "isinstance" => Some(Type::Bool),
                    "list" => {
                        if args.len() == 1 {
                            match self.infer_ty(&args[0]) {
                                Some(Type::Array(_)) => self.infer_ty(&args[0]),
                                Some(Type::Str) => Some(Type::Array(Box::new(Type::Str))),
                                other => other,
                            }
                        } else {
                            Some(Type::Array(Box::new(Type::Any)))
                        }
                    }
                    "dict" => Some(Type::Dict(Box::new(Type::Any), Box::new(Type::Any))),
                    "set" => Some(Type::Set(Box::new(Type::Any))),
                    "sorted" | "reversed" if args.len() == 1 => self.infer_ty(&args[0]),
                    "zip" => Some(Type::Array(Box::new(Type::Any))),
                    "map" if args.len() == 2 => self
                        .infer_ty(&args[1])
                        .map(|t| match t {
                            Type::Array(_) | Type::Set(_) | Type::Str | Type::Dict(_, _) => t,
                            _ => Type::Array(Box::new(Type::Any)),
                        }),
                    "filter" if args.len() == 2 => self.infer_ty(&args[1]),
                    "range" | "enumerate" => Some(Type::Array(Box::new(Type::Int))),
                    _ => None,
                }
            }
            ExprKind::MethodCall {
                target,
                method,
                args,
            } => match method.as_str() {
                "split" => Some(Type::Array(Box::new(Type::Str))),
                "keys" => match self.infer_ty(target) {
                    Some(Type::Dict(k, _)) => Some(Type::Array(k)),
                    _ => None,
                },
                "values" => match self.infer_ty(target) {
                    Some(Type::Dict(_, v)) => Some(Type::Array(v)),
                    _ => None,
                },
                "items" => Some(Type::Array(Box::new(Type::Any))),
                "strip" | "upper" | "lower" | "replace" | "join" => Some(Type::Str),
                "find" | "count" | "index" => Some(Type::Int),
                "startswith" | "endswith" | "isdigit" | "isalpha" => Some(Type::Bool),
                "copy" => self.infer_ty(target),
                "pop" if args.is_empty() => match self.infer_ty(target) {
                    Some(Type::Array(inner)) => Some(*inner),
                    _ => None,
                },
                _ => None,
            },
            ExprKind::Unary { op, expr: inner } => {
                if *op == UnOp::Not {
                    Some(Type::Bool)
                } else {
                    self.infer_ty(inner)
                }
            }
            ExprKind::Binary { op, lhs, rhs } => match op {
                BinOp::Eq
                | BinOp::Ne
                | BinOp::Lt
                | BinOp::Gt
                | BinOp::Le
                | BinOp::Ge
                | BinOp::In
                | BinOp::NotIn
                | BinOp::And
                | BinOp::Or => Some(Type::Bool),
                BinOp::Div => Some(Type::Float),
                _ => {
                    let l = self.infer_ty(lhs);
                    let r = self.infer_ty(rhs);
                    match (l, r) {
                        (Some(a), Some(b)) if a == b => Some(a),
                        (Some(Type::Float), _) | (_, Some(Type::Float)) => Some(Type::Float),
                        (Some(Type::Str), Some(_)) | (Some(_), Some(Type::Str)) => Some(Type::Str),
                        (Some(Type::Int), Some(Type::Int)) => Some(Type::Int),
                        _ => None,
                    }
                }
            },
            ExprKind::IfExpr {
                then_expr,
                else_expr,
                ..
            } => match (self.infer_ty(then_expr), self.infer_ty(else_expr)) {
                (Some(a), Some(b)) if a == b => Some(a),
                (Some(Type::Float), _) | (_, Some(Type::Float)) => Some(Type::Float),
                _ => None,
            },
            ExprKind::ListComp { elt, clauses } | ExprKind::GenExpr { elt, clauses } => {
                let elem = self.comp_elem_ty(elt, clauses);
                Some(Type::Array(Box::new(elem)))
            }
            ExprKind::SetComp { elt, clauses } => {
                let mut elem = self.comp_elem_ty(elt, clauses);
                if !elem.is_hashable_key() {
                    elem = Type::Any;
                }
                Some(Type::Set(Box::new(elem)))
            }
            ExprKind::DictComp { key, val, clauses } => {
                let mut kt = self.comp_elem_ty(key, clauses);
                if !kt.is_hashable_key() {
                    kt = Type::Any;
                }
                let vt = self.comp_elem_ty(val, clauses);
                Some(Type::Dict(Box::new(kt), Box::new(vt)))
            }
            _ => None,
        }
    }

    /// Element type of a comprehension: binds the clause variables in the current scope to
    /// their iterable element types, infers `elt`, then restores the bindings.
    pub(super) fn comp_elem_ty(&mut self, elt: &Expr, clauses: &[CompClause]) -> Type {
        if clauses.is_empty() {
            return self.infer_ty(elt).unwrap_or(Type::Any);
        }
        let mut saved: Vec<(String, Option<VarEntry>)> = Vec::with_capacity(clauses.len());
        for clause in clauses {
            let elem = match self.infer_ty(&clause.iter) {
                Some(Type::Array(t)) | Some(Type::Set(t)) => *t,
                Some(Type::Dict(k, _)) => *k,
                Some(Type::Str) => Type::Str,
                _ => Type::Any,
            };
            if clause.vars.len() == 1 {
                let prev = self.lookup_var(&clause.vars[0]).cloned();
                saved.push((clause.vars[0].clone(), prev));
                self.scopes.last_mut().unwrap().vars.insert(
                    clause.vars[0].clone(),
                    VarEntry {
                        ty: elem,
                        storage: VarStorage::Imm("0".to_string()),
                        is_param: true,
                        region_depth: 0,
                    },
                );
            } else {
                let parts = match elem {
                    Type::Tuple(ts) if ts.len() == clause.vars.len() => ts,
                    _ => vec![Type::Any; clause.vars.len()],
                };
                for (v, t) in clause.vars.iter().zip(parts.into_iter()) {
                    let prev = self.lookup_var(v).cloned();
                    saved.push((v.clone(), prev));
                    self.scopes.last_mut().unwrap().vars.insert(
                        v.clone(),
                        VarEntry {
                            ty: t,
                            storage: VarStorage::Imm("0".to_string()),
                            is_param: true,
                            region_depth: 0,
                        },
                    );
                }
            }
        }
        let out = self.infer_ty(elt).unwrap_or(Type::Any);
        for (name, prev) in saved.into_iter().rev() {
            match prev {
                Some(e) => {
                    self.scopes.last_mut().unwrap().vars.insert(name, e);
                }
                None => {
                    self.scopes.last_mut().unwrap().vars.remove(&name);
                }
            }
        }
        out
    }

    // ---------------- Public entry points ----------------------------------

    pub(super) fn eval_list_comp(
        &mut self,
        elt: &Expr,
        clauses: &[CompClause],
        expected: Option<&Type>,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let elem_ty = match expected {
            Some(Type::Array(inner)) if **inner != Type::Any => (**inner).clone(),
            _ => self.comp_elem_ty(elt, clauses),
        };
        if elem_ty == Type::Void {
            return Err(Diagnostic::new(
                "a comprehension element cannot be `None`",
                span,
            ));
        }
        self.mark_runtime_type(&elem_ty);
        self.used_vec_type = true;

        let out_slot = self.next_slot("comp.out");
        let _ = writeln!(self.allocas, "  {out_slot} = alloca %ArchxVec, align 8");
        let _ = writeln!(out, "  store %ArchxVec zeroinitializer, ptr {out_slot}, align 8");

        let capacity = match self.probe_len(&clauses[0].iter, out)? {
            Some(l) => l,
            None => "0".to_string(),
        };
        let elem_sz = self.emit_elem_sizeof(&elem_ty, out);
        let bytes = self.emit_elem_bytes_val_mul(&capacity, &elem_sz, out);
        let (data, cap) = if !self.region_stack.is_empty() && !self.type_needs_drop(&elem_ty) {
            let rslot = self.func_region_slot.clone().unwrap();
            let p = self.next_tmp();
            let _ = writeln!(
                out,
                "  {p} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
            );
            let nc = self.next_tmp();
            let _ = writeln!(out, "  {nc} = sub nsw i64 0, {capacity}");
            (p, nc)
        } else {
            (self.emit_checked_malloc(&bytes, out), capacity)
        };
        let v0 = self.build_vec_val("0", &cap, &data, out);
        let _ = writeln!(out, "  store %ArchxVec {v0}, ptr {out_slot}, align 8");
        // The initial `len == 0` means `push` sees a free capacity of `cap` and never grows
        // for the common unfiltered case (filters only shrink the result).

        let hidden = self.fresh_hidden("comp");
        let arr_ty = Type::Array(Box::new(elem_ty));
        self.install_hidden_var(&hidden, arr_ty.clone(), &out_slot);
        self.scopes
            .last_mut()
            .unwrap()
            .owned_buffers
            .push(DropTarget::TypedSlot {
                ptr: out_slot.clone(),
                ty: arr_ty.clone(),
            });

        let append = vec![Stmt {
            kind: StmtKind::Expr(Expr {
                kind: ExprKind::Call {
                    name: "push".to_string(),
                    args: vec![
                        Expr {
                            kind: ExprKind::Var(hidden.clone()),
                            span,
                        },
                        elt.clone(),
                    ],
                },
                span,
            }),
            span,
        }];
        let nest = self.build_comp_nest(clauses, 0, append, span);
        self.gen_stmt(&nest, &[], out)?;
        self.flush_stmt_temps(out);

        self.detach_owned_slot(&out_slot);
        self.scopes.last_mut().unwrap().vars.remove(&hidden);
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {out_slot}, align 8");
        self.stmt_temps.push(TempDrop {
            val: vec.clone(),
            ty: arr_ty.clone(),
        });
        Ok((arr_ty, vec))
    }

    pub(super) fn eval_set_comp(
        &mut self,
        elt: &Expr,
        clauses: &[CompClause],
        expected: Option<&Type>,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let mut elem_ty = match expected {
            Some(Type::Set(inner)) if **inner != Type::Any => (**inner).clone(),
            _ => self.comp_elem_ty(elt, clauses),
        };
        if !elem_ty.is_hashable_key() {
            elem_ty = Type::Any;
        }
        let ty = Type::Set(Box::new(elem_ty.clone()));
        let init = self.emit_new_empty_dict_or_set(&elem_ty, None, out);
        let slot = self.next_slot("comp.set");
        let _ = writeln!(self.allocas, "  {slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 {init}, ptr {slot}, align 8");

        let hidden = self.fresh_hidden("set");
        self.install_hidden_var(&hidden, ty.clone(), &slot);
        self.scopes
            .last_mut()
            .unwrap()
            .owned_buffers
            .push(DropTarget::TypedSlot {
                ptr: slot.clone(),
                ty: ty.clone(),
            });

        let body = vec![Stmt {
            kind: StmtKind::Expr(Expr {
                kind: ExprKind::MethodCall {
                    target: Box::new(Expr {
                        kind: ExprKind::Var(hidden.clone()),
                        span,
                    }),
                    method: "add".to_string(),
                    args: vec![elt.clone()],
                },
                span,
            }),
            span,
        }];
        let nest = self.build_comp_nest(clauses, 0, body, span);
        self.gen_stmt(&nest, &[], out)?;
        self.flush_stmt_temps(out);
        self.detach_owned_slot(&slot);
        self.scopes.last_mut().unwrap().vars.remove(&hidden);

        let v = self.next_tmp();
        let _ = writeln!(out, "  {v} = load i64, ptr {slot}, align 8");
        if expected == Some(&Type::Any) {
            self.mark_runtime_type(&Type::Any);
            self.used_any_rt = true;
            let r = self.next_tmp();
            let _ = writeln!(
                out,
                "  {r} = insertvalue %ArchxAny {{ i64 7, i64 0, i64 0 }}, i64 {v}, 1"
            );
            self.stmt_temps.push(TempDrop {
                val: r.clone(),
                ty: Type::Any,
            });
            return Ok((Type::Any, r));
        }
        self.stmt_temps.push(TempDrop {
            val: v.clone(),
            ty: ty.clone(),
        });
        Ok((ty, v))
    }

    pub(super) fn eval_dict_comp(
        &mut self,
        key: &Expr,
        val: &Expr,
        clauses: &[CompClause],
        expected: Option<&Type>,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let (mut k_ty, mut v_ty) = match expected {
            Some(Type::Dict(k, v)) if **k != Type::Any && **v != Type::Any => {
                ((**k).clone(), (**v).clone())
            }
            _ => (
                self.comp_elem_ty(key, clauses),
                self.comp_elem_ty(val, clauses),
            ),
        };
        if !k_ty.is_hashable_key() {
            k_ty = Type::Any;
        }
        if v_ty == Type::Void {
            v_ty = Type::Any;
        }
        let ty = Type::Dict(Box::new(k_ty.clone()), Box::new(v_ty.clone()));
        let init = self.emit_new_empty_dict_or_set(&k_ty, Some(&v_ty), out);
        let slot = self.next_slot("comp.dict");
        let _ = writeln!(self.allocas, "  {slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 {init}, ptr {slot}, align 8");

        let hidden = self.fresh_hidden("dict");
        self.install_hidden_var(&hidden, ty.clone(), &slot);
        self.scopes
            .last_mut()
            .unwrap()
            .owned_buffers
            .push(DropTarget::TypedSlot {
                ptr: slot.clone(),
                ty: ty.clone(),
            });

        let body = vec![Stmt {
            kind: StmtKind::Assign {
                target: AssignTarget::Index {
                    target: Box::new(Expr {
                        kind: ExprKind::Var(hidden.clone()),
                        span,
                    }),
                    index: Box::new(key.clone()),
                },
                op: None,
                value: val.clone(),
            },
            span,
        }];
        let nest = self.build_comp_nest(clauses, 0, body, span);
        self.gen_stmt(&nest, &[], out)?;
        self.flush_stmt_temps(out);
        self.detach_owned_slot(&slot);
        self.scopes.last_mut().unwrap().vars.remove(&hidden);

        let v = self.next_tmp();
        let _ = writeln!(out, "  {v} = load i64, ptr {slot}, align 8");
        self.mark_runtime_type(&k_ty);
        self.mark_runtime_type(&v_ty);
        if expected == Some(&Type::Any) {
            self.used_any_rt = true;
            let r = self.next_tmp();
            let _ = writeln!(
                out,
                "  {r} = insertvalue %ArchxAny {{ i64 6, i64 0, i64 0 }}, i64 {v}, 1"
            );
            self.stmt_temps.push(TempDrop {
                val: r.clone(),
                ty: Type::Any,
            });
            return Ok((Type::Any, r));
        }
        self.stmt_temps.push(TempDrop {
            val: v.clone(),
            ty: ty.clone(),
        });
        Ok((ty, v))
    }

    /// Value form of a generator expression: materialized once as a list.
    pub(super) fn eval_gen_expr(
        &mut self,
        elt: &Expr,
        clauses: &[CompClause],
        expected: Option<&Type>,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.eval_list_comp(elt, clauses, expected, span, out)
    }

    /// `list(map(f, xs))` / `list(filter(p, xs))` (and `map`/`filter` used directly) lower to a
    /// comprehension over `xs`: the callable becomes the element expression, so a named function
    /// collapses to a direct `fastcc` call and an inline `lambda` is inlined the same way
    /// `key=lambda` is elsewhere. No boxed function values, no allocations beyond the result.
    pub(super) fn eval_map_filter(
        &mut self,
        which: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 2 {
            return Err(Diagnostic::new(
                format!("`{which}()` takes exactly 2 arguments: `{which}(func, iterable)`"),
                span,
            ));
        }
        let src_ty = self.infer_ty(&args[1]).ok_or_else(|| {
            Diagnostic::new(
                format!("cannot infer the element type of the iterable passed to `{which}()`"),
                args[1].span,
            )
        })?;
        let (elem_ty, tuple_vars): (Type, Vec<String>) = match &src_ty {
            Type::Array(t) => (t.as_ref().clone(), Vec::new()),
            Type::Set(t) => (t.as_ref().clone(), Vec::new()),
            Type::Str => (Type::Str, Vec::new()),
            Type::Dict(k, _) => ((**k).clone(), Vec::new()),
            Type::Tuple(items) => {
                let vars: Vec<String> = (0..items.len())
                    .map(|i| format!("__map_t{}", i))
                    .collect();
                (src_ty.clone(), vars)
            }
            other => {
                return Err(Diagnostic::new(
                    format!(
                        "`{which}()` expects a `list`, `set`, `dict` or `str`, found `{}`",
                        other.name()
                    ),
                    args[1].span,
                ))
            }
        };

        // The comprehension's induction variable is either the element itself or, for a tuple
        // element, one variable per component.
        let (elem_var, vars): (Expr, Vec<String>) = if tuple_vars.is_empty() {
            let v = "__map_elem".to_string();
            (Expr { kind: ExprKind::Var(v.clone()), span }, vec![v])
        } else {
            (
                Expr {
                    kind: ExprKind::TupleLit(
                        tuple_vars
                            .iter()
                            .map(|v| Expr {
                                kind: ExprKind::Var(v.clone()),
                                span,
                            })
                            .collect(),
                    ),
                    span,
                },
                tuple_vars.clone(),
            )
        };

        let callable = match &args[0].kind {
            ExprKind::Var(f) => {
                // Soft builtins (`map(str, xs)`, `map(len, words)`) are callable the same way.
                const SOFT_BUILTINS: [&str; 11] = [
                    "str", "int", "float", "bool", "len", "abs", "ord", "chr", "sqrt", "type",
                    "isinstance",
                ];
                match self.sigs.get(f).cloned() {
                    Some(sig) => {
                        if sig.params.len() != 1 {
                            return Err(Diagnostic::new(
                                format!(
                                    "`{which}()` passes 1 element, but `{f}` takes {} parameter(s)",
                                    sig.params.len()
                                ),
                                args[0].span,
                            ));
                        }
                    }
                    None if SOFT_BUILTINS.contains(&f.as_str()) => {}
                    None => {
                        return Err(Diagnostic::new(
                            format!("`{which}()` expects a top-level function name or a `lambda`"),
                            args[0].span,
                        ))
                    }
                }
                Expr {
                    kind: ExprKind::Call {
                        name: f.clone(),
                        args: vec![elem_var.clone()],
                    },
                    span: args[0].span,
                }
            }
            ExprKind::Lambda { params, body } => {
                if params.len() != 1 {
                    return Err(Diagnostic::new(
                        format!("a `lambda` passed to `{which}()` takes exactly 1 parameter"),
                        args[0].span,
                    ));
                }
                // Rename the lambda parameter to the induction variable so the inlined body
                // resolves (`lambda x: x * x` becomes `__map_elem * __map_elem`).
                let mut renamed = (**body).clone();
                rename_var(&mut renamed, &params[0].name, &elem_var);
                renamed
            }
            _ => {
                return Err(Diagnostic::new(
                    format!("`{which}()` expects a top-level function name or a `lambda`"),
                    args[0].span,
                ))
            }
        };

        let mut clauses = vec![CompClause {
            vars,
            iter: args[1].clone(),
            conds: Vec::new(),
            span,
        }];
        match which {
            "map" => self.eval_list_comp(&callable, &clauses, None, span, out),
            _ => {
                // `filter`: keep the element when the predicate holds.
                clauses[0].conds.push(callable);
                self.eval_list_comp(&elem_var, &clauses, None, span, out)
            }
        }
    }

    // ---------------- Nested loop nest --------------------------------------

    /// Builds `clauses[i..]` as nested `for` statements ending in `body`.
    fn build_comp_nest(
        &mut self,
        clauses: &[CompClause],
        i: usize,
        body: Vec<Stmt>,
        span: Span,
    ) -> Stmt {
        let clause = &clauses[i];
        let mut inner = body;
        for cond in clause.conds.iter().rev() {
            inner = vec![Stmt {
                kind: StmtKind::If {
                    cond: cond.clone(),
                    then_body: inner,
                    else_body: None,
                },
                span,
            }];
        }
        if i + 1 < clauses.len() {
            let deeper = self.build_comp_nest(clauses, i + 1, inner, span);
            inner = vec![deeper];
        }
        let iter = clause.iter.clone();
        // `range(...)` is not a value in Archx (it is a loop header), so a comprehension over
        // it lowers to the same `for` statement the surface syntax would use — which also
        // reuses the induction-variable and bounds-check analyses.
        if let ExprKind::Call { name, args } = &iter.kind {
            if name == "range" && clause.vars.len() == 1 && !args.is_empty() && args.len() <= 3 {
                let start = if args.len() >= 2 {
                    args[0].clone()
                } else {
                    Expr {
                        kind: ExprKind::Int(0),
                        span: iter.span,
                    }
                };
                let end = if args.len() >= 2 {
                    args[1].clone()
                } else {
                    args[0].clone()
                };
                let step = if args.len() == 3 {
                    Some(args[2].clone())
                } else {
                    None
                };
                return Stmt {
                    kind: StmtKind::For {
                        else_body: None,
                        var: clause.vars[0].clone(),
                        start,
                        end,
                        step,
                        body: inner,
                    },
                    span,
                };
            }
        }
        if clause.vars.len() == 1 {
            Stmt {
                kind: StmtKind::ForEach {
                    else_body: None,
                    var: clause.vars[0].clone(),
                    iter,
                    body: inner,
                },
                span,
            }
        } else {
            Stmt {
                kind: StmtKind::ForTupleUnpack {
                    vars: clause.vars.clone(),
                    iter,
                    body: inner,
                },
                span,
            }
        }
    }

    // ---------------- Length probe for a single allocation ------------------

    /// Returns the exact source length when it can be computed *without* evaluating any
    /// user code (variables, literals, `range`, `len`, `zip`, `sorted`), else `None`.
    ///
    /// This is what makes the unfiltered map a single allocation: the buffer is sized up
    /// front from the source, so the append path never reallocates and never copies.
    fn probe_len(&mut self, expr: &Expr, out: &mut String) -> Result<Option<String>> {
        if !self.probe_is_safe(expr) {
            return Ok(None);
        }
        self.probe_len_inner(expr, out).map(Some)
    }

    fn probe_is_safe(&self, expr: &Expr) -> bool {
        match &expr.kind {
            ExprKind::Var(_) => true,
            ExprKind::Str(_) | ExprKind::Int(_) | ExprKind::Float(_) | ExprKind::Bool(_) => true,
            ExprKind::ArrayLit(es) | ExprKind::SetLit(es) | ExprKind::TupleLit(es) => {
                es.iter().all(|e| self.probe_is_safe(e))
            }
            ExprKind::ArrayRepeat { count, .. } => self.probe_is_safe(count),
            ExprKind::Call { name, args } => match name.as_str() {
                "range" | "zip" | "len" | "sorted" | "list" | "tuple" | "reversed" => {
                    args.iter().all(|a| self.probe_is_safe(a))
                }
                _ => false,
            },
            ExprKind::MethodCall {
                target,
                method,
                args,
            } => {
                matches!(method.as_str(), "keys" | "values" | "items" | "split" | "copy")
                    && args.is_empty()
                    && self.probe_is_safe(target)
            }
            _ => false,
        }
    }

    fn probe_len_inner(&mut self, expr: &Expr, out: &mut String) -> Result<String> {
        match &expr.kind {
            ExprKind::Str(s) => Ok(s.chars().count().to_string()),
            ExprKind::ArrayLit(es) | ExprKind::SetLit(es) | ExprKind::TupleLit(es) => {
                Ok(es.len().to_string())
            }
            ExprKind::ArrayRepeat { count, .. } => {
                let (_, c) = self.eval_expr(count, out)?;
                Ok(c)
            }
            ExprKind::Var(n) => {
                let entry = self.lookup_var(n).cloned();
                let Some(entry) = entry else {
                    return Ok("0".to_string());
                };
                match entry.ty {
                    Type::Array(_) => {
                        let vec = match &entry.storage {
                            VarStorage::Slot(ptr) => {
                                let t = self.next_tmp();
                                let _ =
                                    writeln!(out, "  {t} = load %ArchxVec, ptr {ptr}, align 8");
                                t
                            }
                            VarStorage::Imm(v) => v.clone(),
                            VarStorage::Soa { len_val, .. } => return Ok(len_val.clone()),
                        };
                        let l = self.next_tmp();
                        let _ = writeln!(out, "  {l} = extractvalue %ArchxVec {vec}, 0");
                        Ok(l)
                    }
                    Type::Str => {
                        let s = self.load_var_ssa(n, out);
                        let l = self.next_tmp();
                        let _ = writeln!(out, "  {l} = extractvalue %ArchxStr {s}, 0");
                        Ok(l)
                    }
                    Type::Dict(_, _) | Type::Set(_) => {
                        let d = self.load_var_ssa(n, out);
                        Ok(self.emit_dict_len(&d, out))
                    }
                    _ => Ok("0".to_string()),
                }
            }
            ExprKind::Call { name, args } => match name.as_str() {
                "range" => self.probe_range_len(args, out),
                "len" if args.len() == 1 => {
                    let (ty, val) = self.eval_expr(&args[0], out)?;
                    match ty {
                        Type::Array(_) => {
                            let l = self.next_tmp();
                            let _ = writeln!(out, "  {l} = extractvalue %ArchxVec {val}, 0");
                            Ok(l)
                        }
                        Type::Str => {
                            let l = self.next_tmp();
                            let _ = writeln!(out, "  {l} = extractvalue %ArchxStr {val}, 0");
                            Ok(l)
                        }
                        Type::Dict(_, _) | Type::Set(_) => Ok(self.emit_dict_len(&val, out)),
                        _ => Ok("0".to_string()),
                    }
                }
                "zip" => {
                    let mut acc: Option<String> = None;
                    for a in args {
                        let l = self.probe_len_inner(a, out)?;
                        acc = Some(match acc {
                            None => l,
                            Some(prev) => {
                                let c = self.next_tmp();
                                let _ = writeln!(out, "  {c} = icmp slt i64 {l}, {prev}");
                                let m = self.next_tmp();
                                let _ =
                                    writeln!(out, "  {m} = select i1 {c}, i64 {l}, i64 {prev}");
                                m
                            }
                        });
                    }
                    Ok(acc.unwrap_or_else(|| "0".to_string()))
                }
                "sorted" | "list" | "tuple" | "reversed" if args.len() == 1 => {
                    self.probe_len_inner(&args[0], out)
                }
                _ => Ok("0".to_string()),
            },
            ExprKind::MethodCall {
                target, method, ..
            } => match method.as_str() {
                "keys" | "values" | "items" | "copy" => self.probe_len_inner(target, out),
                "split" => {
                    let (_, s) = self.eval_expr(target, out)?;
                    self.used_str_split_ws = true;
                    let r = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {r} = call fastcc %ArchxVec @archx_str_split_ws(%ArchxStr {s}, ptr null)"
                    );
                    let l = self.next_tmp();
                    let _ = writeln!(out, "  {l} = extractvalue %ArchxVec {r}, 0");
                    // The temporary split vector is only used for its length. It is owned by
                    // this statement and dropped by the normal temporary flush.
                    self.stmt_temps.push(TempDrop {
                        val: r.clone(),
                        ty: Type::Array(Box::new(Type::Str)),
                    });
                    Ok(l)
                }
                _ => Ok("0".to_string()),
            },
            _ => Ok("0".to_string()),
        }
    }

    fn probe_range_len(&mut self, args: &[Expr], out: &mut String) -> Result<String> {
        if args.is_empty() || args.len() > 3 {
            return Ok("0".to_string());
        }
        let mut vals = Vec::with_capacity(args.len());
        for a in args {
            let (_, v) = self.eval_expr(a, out)?;
            vals.push(v);
        }
        let (start, stop, step) = match vals.len() {
            1 => ("0".to_string(), vals[0].clone(), "1".to_string()),
            2 => (vals[0].clone(), vals[1].clone(), "1".to_string()),
            _ => (vals[0].clone(), vals[1].clone(), vals[2].clone()),
        };
        let diff = self.next_tmp();
        let _ = writeln!(out, "  {diff} = sub nsw i64 {stop}, {start}");
        let pos = self.next_tmp();
        let _ = writeln!(out, "  {pos} = icmp sgt i64 {diff}, 0");
        let mag = self.next_tmp();
        let _ = writeln!(out, "  {mag} = select i1 {pos}, i64 {diff}, i64 0");
        let st = self.next_tmp();
        let _ = writeln!(out, "  {st} = icmp sgt i64 {step}, 0");
        let abs_step = self.next_tmp();
        let _ = writeln!(out, "  {abs_step} = select i1 {st}, i64 {step}, i64 1");
        let n = self.next_tmp();
        let _ = writeln!(out, "  {n} = udiv i64 {mag}, {abs_step}");
        Ok(n)
    }

    // ---------------- Hidden container plumbing ----------------------------

    fn fresh_hidden(&mut self, hint: &str) -> String {
        let id = self.next_tmp();
        format!("__archx_{hint}_{id}")
    }

    fn install_hidden_var(&mut self, name: &str, ty: Type, slot: &str) {
        let depth = self.region_stack.len();
        self.scopes.last_mut().unwrap().vars.insert(
            name.to_string(),
            VarEntry {
                ty,
                storage: VarStorage::Slot(slot.to_string()),
                is_param: false,
                region_depth: depth,
            },
        );
    }

    /// Removes the drop for a slot whose value is being handed to the caller.
    fn detach_owned_slot(&mut self, slot: &str) {
        let bufs = &mut self.scopes.last_mut().unwrap().owned_buffers;
        if let Some(pos) = bufs.iter().position(|d| match d {
            DropTarget::TypedSlot { ptr, .. } => ptr == slot,
            _ => false,
        }) {
            bufs.remove(pos);
        }
    }

    // ---------------- Generator reductions ---------------------------------

    /// Recognizes `sum(gen)`, `any(gen)`, `all(gen)`, `len(gen)`, `min(gen)`, `max(gen)` and
    /// folds them without materializing a list. Elements are evaluated exactly once.
    pub(super) fn try_gen_reduction(
        &mut self,
        name: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<Option<(Type, String)>> {
        if args.len() != 1 {
            return Ok(None);
        }
        let ExprKind::GenExpr { elt, clauses } = &args[0].kind else {
            return Ok(None);
        };
        match name {
            "sum" => Ok(Some(self.fold_gen(elt, clauses, FoldKind::Sum, span, out)?)),
            "len" => Ok(Some(self.fold_gen(elt, clauses, FoldKind::Count, span, out)?)),
            "any" => Ok(Some(self.fold_gen(elt, clauses, FoldKind::Any, span, out)?)),
            "all" => Ok(Some(self.fold_gen(elt, clauses, FoldKind::All, span, out)?)),
            "min" | "max" => {
                // Materializing once is the only way to keep the element expression evaluated
                // exactly once while reusing the strict single-pass min/max scan.
                let is_min = name == "min";
                let (ty, list) = self.eval_list_comp(elt, clauses, None, span, out)?;
                let Type::Array(elem_ty) = ty else { unreachable!() };
                let v = self.emit_minmax_over_vec(&elem_ty, &list, is_min, span, out)?;
                self.claim_stmt_temp(&list);
                Ok(Some(v))
            }
            _ => Ok(None),
        }
    }

    /// Single-pass `min`/`max` over an already-materialized list, branch-free per element
    /// (`select`) and with no calls. Both `int` and `float` element types are supported.
    fn emit_minmax_over_vec(
        &mut self,
        elem_ty: &Type,
        vec_val: &str,
        is_min: bool,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if !matches!(elem_ty, Type::Int | Type::Float) {
            return Err(Diagnostic::new(
                format!(
                    "`{}` over a generator requires `int` or `float` elements, found `{}`",
                    if is_min { "min" } else { "max" },
                    elem_ty.name()
                ),
                span,
            ));
        }
        self.used_pop_empty_fail = true;
        let len_v = self.next_tmp();
        let _ = writeln!(out, "  {len_v} = extractvalue %ArchxVec {vec_val}, 0");
        let empty = self.next_tmp();
        let _ = writeln!(out, "  {empty} = icmp sle i64 {len_v}, 0");
        let bad_lbl = self.fresh_label("mm.empty");
        let ok_lbl = self.fresh_label("mm.ok");
        self.emit_cond_br(&empty, &bad_lbl, &ok_lbl, out);
        self.start_block(&bad_lbl, out);
        let _ = writeln!(out, "  call void @archx_pop_empty_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;
        self.start_block(&ok_lbl, out);

        let ir = ir_type(elem_ty);
        let data_p = self.next_tmp();
        let _ = writeln!(out, "  {data_p} = extractvalue %ArchxVec {vec_val}, 2");
        let acc_ptr = self.next_tmp();
        let _ = writeln!(out, "  {acc_ptr} = getelementptr inbounds {ir}, ptr {data_p}, i64 0");
        let first = self.next_tmp();
        let _ = writeln!(out, "  {first} = load {ir}, ptr {acc_ptr}, align 8");

        let idx_slot = self.next_slot("mm.idx");
        let acc_slot = self.next_slot("mm.acc");
        let _ = writeln!(self.allocas, "  {acc_slot} = alloca {ir}, align 8");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store {ir} {first}, ptr {acc_slot}, align 8");
        let _ = writeln!(out, "  store i64 1, ptr {idx_slot}, align 8");

        let cond_lbl = self.fresh_label("mm.cond");
        let body_lbl = self.fresh_label("mm.body");
        let end_lbl = self.fresh_label("mm.end");
        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {idx_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len_v}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let ep = self.next_tmp();
        let _ = writeln!(out, "  {ep} = getelementptr inbounds {ir}, ptr {data_p}, i64 {i}");
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load {ir}, ptr {ep}, align 8");
        let prev = self.next_tmp();
        let _ = writeln!(out, "  {prev} = load {ir}, ptr {acc_slot}, align 8");
        let better = self.next_tmp();
        if *elem_ty == Type::Float {
            let pred = if is_min { "olt" } else { "ogt" };
            let _ = writeln!(out, "  {better} = fcmp {pred} double {cur}, {prev}");
        } else {
            let pred = if is_min { "slt" } else { "sgt" };
            let _ = writeln!(out, "  {better} = icmp {pred} i64 {cur}, {prev}");
        }
        let sel = self.next_tmp();
        let _ = writeln!(out, "  {sel} = select i1 {better}, {ir} {cur}, {ir} {prev}");
        let _ = writeln!(out, "  store {ir} {sel}, ptr {acc_slot}, align 8");
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        let res = self.next_tmp();
        let _ = writeln!(out, "  {res} = load {ir}, ptr {acc_slot}, align 8");
        Ok((elem_ty.clone(), res))
    }

    fn fold_gen(
        &mut self,
        elt: &Expr,
        clauses: &[CompClause],
        kind: FoldKind,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let elem_ty = self.comp_elem_ty(elt, clauses);
        let (acc_ty, init) = match kind {
            FoldKind::Sum if elem_ty == Type::Float => (Type::Float, "0.0".to_string()),
            FoldKind::Sum => (Type::Int, "0".to_string()),
            FoldKind::Count => (Type::Int, "0".to_string()),
            FoldKind::Any => (Type::Bool, "false".to_string()),
            FoldKind::All => (Type::Bool, "true".to_string()),
        };
        self.mark_runtime_type(&acc_ty);

        let acc_name = self.fresh_hidden("acc");
        let acc_slot = self.next_slot("acc");
        let (ir, align, init_val) = match acc_ty {
            Type::Float => ("double", 8, format!("0x{:016X}", 0f64.to_bits())),
            Type::Bool => ("i1", 1, init.clone()),
            _ => ("i64", 8, init.clone()),
        };
        let _ = writeln!(self.allocas, "  {acc_slot} = alloca {ir}, align {align}");
        let _ = writeln!(out, "  store {ir} {init_val}, ptr {acc_slot}, align {align}");
        self.install_hidden_var(&acc_name, acc_ty.clone(), &acc_slot);
        self.scopes
            .last_mut()
            .unwrap()
            .owned_buffers
            .push(DropTarget::TypedSlot {
                ptr: acc_slot.clone(),
                ty: acc_ty.clone(),
            });

        let acc_var = Expr {
            kind: ExprKind::Var(acc_name.clone()),
            span,
        };
        let body: Vec<Stmt> = match kind {
            FoldKind::Sum | FoldKind::Count => {
                let term = if matches!(kind, FoldKind::Count) {
                    Expr {
                        kind: ExprKind::Int(1),
                        span,
                    }
                } else {
                    elt.clone()
                };
                vec![Stmt {
                    kind: StmtKind::Assign {
                        target: AssignTarget::Var(acc_name.clone()),
                        op: None,
                        value: Expr {
                            kind: ExprKind::Binary {
                                op: BinOp::Add,
                                lhs: Box::new(acc_var),
                                rhs: Box::new(term),
                            },
                            span,
                        },
                    },
                    span,
                }]
            }
            FoldKind::Any => vec![Stmt {
                kind: StmtKind::If {
                    cond: elt.clone(),
                    then_body: vec![
                        Stmt {
                            kind: StmtKind::Assign {
                                target: AssignTarget::Var(acc_name.clone()),
                                op: None,
                                value: Expr {
                                    kind: ExprKind::Bool(true),
                                    span,
                                },
                            },
                            span,
                        },
                        Stmt {
                            kind: StmtKind::Break,
                            span,
                        },
                    ],
                    else_body: None,
                },
                span,
            }],
            FoldKind::All => vec![Stmt {
                kind: StmtKind::If {
                    cond: Expr {
                        kind: ExprKind::Unary {
                            op: UnOp::Not,
                            expr: Box::new(elt.clone()),
                        },
                        span,
                    },
                    then_body: vec![
                        Stmt {
                            kind: StmtKind::Assign {
                                target: AssignTarget::Var(acc_name.clone()),
                                op: None,
                                value: Expr {
                                    kind: ExprKind::Bool(false),
                                    span,
                                },
                            },
                            span,
                        },
                        Stmt {
                            kind: StmtKind::Break,
                            span,
                        },
                    ],
                    else_body: None,
                },
                span,
            }],
        };
        let nest = self.build_comp_nest(clauses, 0, body, span);
        self.gen_stmt(&nest, &[], out)?;
        self.flush_stmt_temps(out);

        let val = self.load_var_ssa(&acc_name, out);
        self.detach_owned_slot(&acc_slot);
        self.scopes.last_mut().unwrap().vars.remove(&acc_name);
        Ok((acc_ty, val))
    }
}

#[derive(Clone, Copy)]
enum FoldKind {
    Sum,
    Count,
    Any,
    All,
}

/// Clones a clause list so it can be consumed by `eval_list_comp`.
fn clauses_carry(clauses: Vec<CompClause>) -> Vec<CompClause> {
    clauses
}

/// `lambda x: ...` parameter -> the `Expr` naming it inside the inlined body.
fn param_as_expr(param: &Param, span: Span) -> Expr {
    Expr {
        kind: ExprKind::Var(param.name.clone()),
        span,
    }
}

/// Textually renames a variable inside an inlined `lambda` body (no shadowing analysis needed:
/// the body came from a single-parameter lambda).
fn rename_var(expr: &mut Expr, from: &str, to: &Expr) {
    match &mut expr.kind {
        ExprKind::Var(n) if n == from => {
            let span = expr.span;
            *expr = to.clone();
            expr.span = span;
        }
        ExprKind::Var(_)
        | ExprKind::Int(_)
        | ExprKind::Float(_)
        | ExprKind::Bool(_)
        | ExprKind::Str(_)
        | ExprKind::NoneLit => {}
        ExprKind::Binary { lhs, rhs, .. } => {
            rename_var(lhs, from, to);
            rename_var(rhs, from, to);
        }
        ExprKind::Unary { expr: inner, .. } => rename_var(inner, from, to),
        ExprKind::CompareChain(operands) => {
            for (e, _) in operands.iter_mut() {
                rename_var(e, from, to);
            }
        }
        ExprKind::IfExpr {
            then_expr,
            cond,
            else_expr,
        } => {
            rename_var(then_expr, from, to);
            rename_var(cond, from, to);
            rename_var(else_expr, from, to);
        }
        ExprKind::Call { args, .. } => {
            for a in args.iter_mut() {
                rename_var(a, from, to);
            }
        }
        ExprKind::MethodCall { target, args, .. } => {
            rename_var(target, from, to);
            for a in args.iter_mut() {
                rename_var(a, from, to);
            }
        }
        ExprKind::Index { target, index } => {
            rename_var(target, from, to);
            rename_var(index, from, to);
        }
        ExprKind::TupleLit(es) | ExprKind::ArrayLit(es) | ExprKind::SetLit(es) => {
            for e in es.iter_mut() {
                rename_var(e, from, to);
            }
        }
        ExprKind::PercentFormat { args, .. } => rename_var(args, from, to),
        _ => {}
    }
}
