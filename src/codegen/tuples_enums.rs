//! Milestone 8 (`v0.8.0`): Zero-heap value tuples `(T1, T2, ...)`, inline optionals `T | None`,
//! algebraic `enum` sum types, and Pythonic `match` / `case` structural pattern matching.

use std::collections::{HashMap, HashSet};
use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

#[derive(Clone, Debug)]
pub(crate) struct EnumInfo {
    /// `(variant_name, field_types, field_word_offsets)`
    pub(super) variants: Vec<(String, Vec<Type>, Vec<usize>)>,
    /// Number of 8-byte `i64` payload words (`0` for pure unit enums).
    pub(super) payload_words: usize,
}

pub(super) fn resolve_program_types(raw: &Program, enum_names: &HashSet<String>) -> Program {
    Program {
        structs: raw
            .structs
            .iter()
            .map(|s| StructDef {
                name: s.name.clone(),
                fields: s
                    .fields
                    .iter()
                    .map(|f| Param {
                        name: f.name.clone(),
                        ty: resolve_ty(&f.ty, enum_names),
                    })
                    .collect(),
                methods: s
                    .methods
                    .iter()
                    .map(|m| resolve_func(m, enum_names))
                    .collect(),
                span: s.span,
            })
            .collect(),
        enums: raw
            .enums
            .iter()
            .map(|e| EnumDef {
                name: e.name.clone(),
                variants: e
                    .variants
                    .iter()
                    .map(|v| EnumVariant {
                        name: v.name.clone(),
                        fields: v.fields.iter().map(|t| resolve_ty(t, enum_names)).collect(),
                        span: v.span,
                    })
                    .collect(),
                span: e.span,
            })
            .collect(),
        funcs: raw
            .funcs
            .iter()
            .map(|f| resolve_func(f, enum_names))
            .collect(),
    }
}

fn resolve_func(f: &Func, enum_names: &HashSet<String>) -> Func {
    Func {
        name: f.name.clone(),
        params: f
            .params
            .iter()
            .map(|p| Param {
                name: p.name.clone(),
                ty: resolve_ty(&p.ty, enum_names),
            })
            .collect(),
        ret: f.ret.as_ref().map(|t| resolve_ty(t, enum_names)),
        body: f
            .body
            .iter()
            .map(|s| resolve_stmt(s, enum_names))
            .collect(),
        span: f.span,
    }
}

fn resolve_ty(ty: &Type, enum_names: &HashSet<String>) -> Type {
    match ty {
        Type::Struct(name) if enum_names.contains(name) => Type::Enum(name.clone()),
        Type::Array(inner) => Type::Array(Box::new(resolve_ty(inner, enum_names))),
        Type::Optional(inner) => Type::Optional(Box::new(resolve_ty(inner, enum_names))),
        Type::Tuple(items) => {
            Type::Tuple(items.iter().map(|t| resolve_ty(t, enum_names)).collect())
        }
        Type::Dict(k, v) => Type::Dict(
            Box::new(resolve_ty(k, enum_names)),
            Box::new(resolve_ty(v, enum_names)),
        ),
        Type::Set(inner) => Type::Set(Box::new(resolve_ty(inner, enum_names))),
        other => other.clone(),
    }
}

fn resolve_stmt(stmt: &Stmt, enum_names: &HashSet<String>) -> Stmt {
    let kind = match &stmt.kind {
        StmtKind::Let { name, ty, value } => StmtKind::Let {
            name: name.clone(),
            ty: ty.as_ref().map(|t| resolve_ty(t, enum_names)),
            value: value.clone(),
        },
        StmtKind::If {
            cond,
            then_body,
            else_body,
        } => StmtKind::If {
            cond: cond.clone(),
            then_body: then_body
                .iter()
                .map(|s| resolve_stmt(s, enum_names))
                .collect(),
            else_body: else_body
                .as_ref()
                .map(|b| b.iter().map(|s| resolve_stmt(s, enum_names)).collect()),
        },
        StmtKind::While { cond, body } => StmtKind::While {
            cond: cond.clone(),
            body: body.iter().map(|s| resolve_stmt(s, enum_names)).collect(),
        },
        StmtKind::For {
            var,
            start,
            end,
            step,
            body,
        } => StmtKind::For {
            var: var.clone(),
            start: start.clone(),
            end: end.clone(),
            step: step.clone(),
            body: body.iter().map(|s| resolve_stmt(s, enum_names)).collect(),
        },
        StmtKind::ForEach { var, iter, body } => StmtKind::ForEach {
            var: var.clone(),
            iter: iter.clone(),
            body: body.iter().map(|s| resolve_stmt(s, enum_names)).collect(),
        },
        StmtKind::ForEnumerate {
            idx_var,
            elem_var,
            iter,
            start,
            body,
        } => StmtKind::ForEnumerate {
            idx_var: idx_var.clone(),
            elem_var: elem_var.clone(),
            iter: iter.clone(),
            start: start.clone(),
            body: body.iter().map(|s| resolve_stmt(s, enum_names)).collect(),
        },
        StmtKind::ForDictItems {
            key_var,
            val_var,
            dict,
            body,
        } => StmtKind::ForDictItems {
            key_var: key_var.clone(),
            val_var: val_var.clone(),
            dict: dict.clone(),
            body: body.iter().map(|s| resolve_stmt(s, enum_names)).collect(),
        },
        StmtKind::Region { body } => StmtKind::Region {
            body: body.iter().map(|s| resolve_stmt(s, enum_names)).collect(),
        },
        StmtKind::Match { subject, cases } => StmtKind::Match {
            subject: subject.clone(),
            cases: cases
                .iter()
                .map(|c| MatchCase {
                    pattern: c.pattern.clone(),
                    guard: c.guard.clone(),
                    body: c.body.iter().map(|s| resolve_stmt(s, enum_names)).collect(),
                    span: c.span,
                })
                .collect(),
        },
        other => other.clone(),
    };
    Stmt {
        kind,
        span: stmt.span,
    }
}

pub(super) fn compute_enum_layouts(
    defs: &[EnumDef],
    structs: &HashMap<String, Vec<Param>>,
    enum_defs: &HashMap<String, EnumDef>,
) -> Result<HashMap<String, EnumInfo>> {
    #[derive(Clone, Copy, PartialEq, Eq)]
    enum State {
        Visiting,
        Visited,
    }
    let mut state: HashMap<String, State> = HashMap::new();
    let mut layouts: HashMap<String, EnumInfo> = HashMap::new();

    fn type_slots(
        ty: &Type,
        structs: &HashMap<String, Vec<Param>>,
        enum_defs: &HashMap<String, EnumDef>,
        state: &mut HashMap<String, State>,
        layouts: &mut HashMap<String, EnumInfo>,
        span: Span,
    ) -> Result<usize> {
        match ty {
            Type::Void => Ok(0),
            Type::Bool | Type::Int | Type::Float | Type::Dict(_, _) | Type::Set(_) => Ok(1),
            Type::Str => Ok(2),
            Type::Array(_) | Type::Any => Ok(3),
            Type::Optional(inner) => {
                Ok(1 + type_slots(inner, structs, enum_defs, state, layouts, span)?)
            }
            Type::Tuple(items) => {
                if items.is_empty() {
                    Ok(1)
                } else {
                    let mut sum = 0usize;
                    for t in items {
                        sum += type_slots(t, structs, enum_defs, state, layouts, span)?;
                    }
                    Ok(sum.max(1))
                }
            }
            Type::Struct(sname) => {
                let mut sum = 0usize;
                if let Some(fs) = structs.get(sname) {
                    for f in fs {
                        sum += type_slots(&f.ty, structs, enum_defs, state, layouts, span)?;
                    }
                }
                Ok(sum.max(1))
            }
            Type::Enum(ename) => {
                build_enum(ename, structs, enum_defs, state, layouts)?;
                Ok(1 + layouts[ename].payload_words)
            }
        }
    }

    fn build_enum(
        ename: &str,
        structs: &HashMap<String, Vec<Param>>,
        enum_defs: &HashMap<String, EnumDef>,
        state: &mut HashMap<String, State>,
        layouts: &mut HashMap<String, EnumInfo>,
    ) -> Result<()> {
        match state.get(ename).copied() {
            Some(State::Visited) => return Ok(()),
            Some(State::Visiting) => {
                return Err(Diagnostic::new(
                    format!("recursive enum `{ename}` has infinite size"),
                    enum_defs[ename].span,
                ));
            }
            None => {}
        }
        state.insert(ename.to_string(), State::Visiting);
        let edef = &enum_defs[ename];
        let mut variants = Vec::with_capacity(edef.variants.len());
        let mut max_words = 0usize;
        for v in &edef.variants {
            let mut offsets = Vec::with_capacity(v.fields.len());
            let mut cur = 0usize;
            for fty in &v.fields {
                if *fty == Type::Void {
                    return Err(Diagnostic::new(
                        format!("variant `{}.{}` field cannot be `void`", ename, v.name),
                        v.span,
                    ));
                }
                offsets.push(cur);
                cur += type_slots(fty, structs, enum_defs, state, layouts, v.span)?;
            }
            if cur > max_words {
                max_words = cur;
            }
            variants.push((v.name.clone(), v.fields.clone(), offsets));
        }
        layouts.insert(
            ename.to_string(),
            EnumInfo {
                variants,
                payload_words: max_words,
            },
        );
        state.insert(ename.to_string(), State::Visited);
        Ok(())
    }

    for d in defs {
        build_enum(&d.name, structs, enum_defs, &mut state, &mut layouts)?;
    }
    Ok(layouts)
}

#[derive(Clone, Copy)]
pub(super) enum NarrowingKind {
    /// `x is not None` / `x != None`: `x` is narrowed in `then_body`.
    SomeInThen,
    /// `x is None` / `x == None`: `x` is narrowed in `else_body` (and post-`if` if `then_body` exits).
    NoneInThen,
}

impl Codegen {
    // ---------------- Flow-Sensitive `T | None` Narrowing --------------------

    pub(super) fn is_narrowed_optional(&self, name: &str) -> bool {
        for scope in self.scopes.iter().rev() {
            if scope.narrowed_optionals.contains(name) {
                return true;
            }
            if scope.vars.contains_key(name) {
                return false;
            }
        }
        false
    }

    pub(super) fn clear_narrowed_optional(&mut self, name: &str) {
        for scope in self.scopes.iter_mut().rev() {
            scope.narrowed_optionals.remove(name);
            if scope.vars.contains_key(name) {
                break;
            }
        }
    }

    pub(super) fn detect_optional_narrowing(&self, cond: &Expr) -> Option<(String, NarrowingKind)> {
        match &cond.kind {
            ExprKind::Binary { op, lhs, rhs } if matches!(op, BinOp::Eq | BinOp::Ne) => {
                let vname = match (&lhs.kind, &rhs.kind) {
                    (ExprKind::Var(n), ExprKind::NoneLit) => n,
                    (ExprKind::NoneLit, ExprKind::Var(n)) => n,
                    _ => return None,
                };
                let entry = self.lookup_var(vname)?;
                if !matches!(entry.ty, Type::Optional(_)) {
                    return None;
                }
                let kind = if *op == BinOp::Ne {
                    NarrowingKind::SomeInThen
                } else {
                    NarrowingKind::NoneInThen
                };
                Some((vname.clone(), kind))
            }
            ExprKind::Unary {
                op: UnOp::Not,
                expr: inner,
            } => {
                let (vname, k) = self.detect_optional_narrowing(inner)?;
                let flipped = match k {
                    NarrowingKind::SomeInThen => NarrowingKind::NoneInThen,
                    NarrowingKind::NoneInThen => NarrowingKind::SomeInThen,
                };
                Some((vname, flipped))
            }
            _ => None,
        }
    }

    pub(super) fn eval_raw_var_bypass_narrowing(
        &mut self,
        name: &str,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let entry = self
            .lookup_var(name)
            .cloned()
            .ok_or_else(|| Diagnostic::new(format!("undefined variable `{name}`"), span))?;
        match entry.storage {
            VarStorage::Imm(val) => Ok((entry.ty, val)),
            VarStorage::Slot(ptr) => {
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = load {}, ptr {ptr}, align {}",
                    ir_type(&entry.ty),
                    ir_align(&entry.ty)
                );
                Ok((entry.ty, reg))
            }
            VarStorage::Soa { .. } => Err(Diagnostic::new(
                format!("array `{name}` uses local SoA layout and cannot be copied as a whole"),
                span,
            )),
        }
    }

    pub(super) fn wrap_optional_some(
        &mut self,
        inner_ty: &Type,
        val: &str,
        out: &mut String,
    ) -> (Type, String) {
        let opt_ty = Type::Optional(Box::new(inner_ty.clone()));
        let opt_ir = ir_type(&opt_ty);
        let inner_ir = ir_type(inner_ty);
        let was_temp = self.type_needs_drop(inner_ty) && self.claim_stmt_temp(val);
        let s0 = self.next_tmp();
        let _ = writeln!(out, "  {s0} = insertvalue {opt_ir} undef, i1 1, 0");
        let s1 = self.next_tmp();
        let _ = writeln!(
            out,
            "  {s1} = insertvalue {opt_ir} {s0}, {inner_ir} {val}, 1"
        );
        if was_temp {
            self.stmt_temps.push(TempDrop {
                val: s1.clone(),
                ty: opt_ty.clone(),
            });
        }
        (opt_ty, s1)
    }

    pub(super) fn eval_optional_none_cmp(
        &mut self,
        op: BinOp,
        other_expr: &Expr,
        out: &mut String,
    ) -> Result<Option<(Type, String)>> {
        if !matches!(op, BinOp::Eq | BinOp::Ne) {
            return Ok(None);
        }
        if let ExprKind::Var(vname) = &other_expr.kind {
            if let Some(entry) = self.lookup_var(vname).cloned() {
                if let Type::Optional(_) = &entry.ty {
                    let (oty, oval) =
                        self.eval_raw_var_bypass_narrowing(vname, other_expr.span, out)?;
                    let opt_ir = ir_type(&oty);
                    let has = self.next_tmp();
                    let _ = writeln!(out, "  {has} = extractvalue {opt_ir} {oval}, 0");
                    if op == BinOp::Ne {
                        return Ok(Some((Type::Bool, has)));
                    }
                    let is_none = self.next_tmp();
                    let _ = writeln!(out, "  {is_none} = xor i1 {has}, true");
                    return Ok(Some((Type::Bool, is_none)));
                } else if entry.ty != Type::Any {
                    let res = if op == BinOp::Eq { "false" } else { "true" };
                    return Ok(Some((Type::Bool, res.to_string())));
                }
            }
        }
        let (ty, val) = self.eval_expr(other_expr, out)?;
        if let Type::Optional(_) = &ty {
            let opt_ir = ir_type(&ty);
            let has = self.next_tmp();
            let _ = writeln!(out, "  {has} = extractvalue {opt_ir} {val}, 0");
            if op == BinOp::Ne {
                return Ok(Some((Type::Bool, has)));
            }
            let is_none = self.next_tmp();
            let _ = writeln!(out, "  {is_none} = xor i1 {has}, true");
            return Ok(Some((Type::Bool, is_none)));
        }
        if ty != Type::Any {
            let res = if op == BinOp::Eq { "false" } else { "true" };
            return Ok(Some((Type::Bool, res.to_string())));
        }
        let la = self.emit_box_any_owned(&ty, &val, other_expr.span, out)?;
        self.stmt_temps.push(TempDrop {
            val: la.clone(),
            ty: Type::Any,
        });
        self.used_any_rt = true;
        let eq = self.next_tmp();
        let _ = writeln!(
            out,
            "  {eq} = call fastcc i1 @archx_any_eq(%ArchxAny {la}, %ArchxAny zeroinitializer)"
        );
        if op == BinOp::Eq {
            Ok(Some((Type::Bool, eq)))
        } else {
            let inv = self.next_tmp();
            let _ = writeln!(out, "  {inv} = xor i1 {eq}, true");
            Ok(Some((Type::Bool, inv)))
        }
    }

    // ---------------- Value Equality (Scalars, Strings, Tuples, Optionals, Enums) ----

    pub(super) fn emit_structural_eq(
        &mut self,
        ty: &Type,
        lv: &str,
        rv: &str,
        span: Span,
        out: &mut String,
    ) -> Result<String> {
        match ty {
            Type::Int => {
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = icmp eq i64 {lv}, {rv}");
                Ok(r)
            }
            Type::Bool => {
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = icmp eq i1 {lv}, {rv}");
                Ok(r)
            }
            Type::Float => {
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = fcmp oeq double {lv}, {rv}");
                Ok(r)
            }
            Type::Str => {
                self.used_str_eq = true;
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc i1 @archx_str_eq(%ArchxStr {lv}, %ArchxStr {rv})"
                );
                Ok(r)
            }
            Type::Any => {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc i1 @archx_any_eq(%ArchxAny {lv}, %ArchxAny {rv})"
                );
                Ok(r)
            }
            Type::Tuple(items) => {
                if items.is_empty() {
                    return Ok("true".to_string());
                }
                let tup_ir = ir_type(ty);
                let res_slot = self.next_slot("tupeq.res");
                let _ = writeln!(self.allocas, "  {res_slot} = alloca i1, align 1");
                let _ = writeln!(out, "  store i1 false, ptr {res_slot}, align 1");
                let done_lbl = self.fresh_label("tupeq.done");
                for (i, item_ty) in items.iter().enumerate() {
                    let lf = self.next_tmp();
                    let _ = writeln!(out, "  {lf} = extractvalue {tup_ir} {lv}, {i}");
                    let rf = self.next_tmp();
                    let _ = writeln!(out, "  {rf} = extractvalue {tup_ir} {rv}, {i}");
                    let feq = self.emit_structural_eq(item_ty, &lf, &rf, span, out)?;
                    let next_lbl = self.fresh_label("tupeq.next");
                    self.emit_cond_br(&feq, &next_lbl, &done_lbl, out);
                    self.start_block(&next_lbl, out);
                }
                let _ = writeln!(out, "  store i1 true, ptr {res_slot}, align 1");
                self.emit_br(&done_lbl, out);
                self.start_block(&done_lbl, out);
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = load i1, ptr {res_slot}, align 1");
                Ok(r)
            }
            Type::Optional(inner) => {
                let opt_ir = ir_type(ty);
                let lhas = self.next_tmp();
                let _ = writeln!(out, "  {lhas} = extractvalue {opt_ir} {lv}, 0");
                let rhas = self.next_tmp();
                let _ = writeln!(out, "  {rhas} = extractvalue {opt_ir} {rv}, 0");
                let same_has = self.next_tmp();
                let _ = writeln!(out, "  {same_has} = icmp eq i1 {lhas}, {rhas}");
                let res_slot = self.next_slot("opteq.res");
                let _ = writeln!(self.allocas, "  {res_slot} = alloca i1, align 1");
                let _ = writeln!(out, "  store i1 false, ptr {res_slot}, align 1");
                let check_both_lbl = self.fresh_label("opteq.both");
                let some_lbl = self.fresh_label("opteq.some");
                let none_lbl = self.fresh_label("opteq.none");
                let done_lbl = self.fresh_label("opteq.done");
                self.emit_cond_br(&same_has, &check_both_lbl, &done_lbl, out);

                self.start_block(&check_both_lbl, out);
                self.emit_cond_br(&lhas, &some_lbl, &none_lbl, out);

                self.start_block(&none_lbl, out);
                let _ = writeln!(out, "  store i1 true, ptr {res_slot}, align 1");
                self.emit_br(&done_lbl, out);

                self.start_block(&some_lbl, out);
                let li = self.next_tmp();
                let _ = writeln!(out, "  {li} = extractvalue {opt_ir} {lv}, 1");
                let ri = self.next_tmp();
                let _ = writeln!(out, "  {ri} = extractvalue {opt_ir} {rv}, 1");
                let ieq = self.emit_structural_eq(inner, &li, &ri, span, out)?;
                let _ = writeln!(out, "  store i1 {ieq}, ptr {res_slot}, align 1");
                self.emit_br(&done_lbl, out);

                self.start_block(&done_lbl, out);
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = load i1, ptr {res_slot}, align 1");
                Ok(r)
            }
            Type::Enum(ename) => {
                let info = self.enums[ename].clone();
                let enum_ir = format!("%ArchxEnum_{ename}");
                let ltag = self.next_tmp();
                let _ = writeln!(out, "  {ltag} = extractvalue {enum_ir} {lv}, 0");
                let rtag = self.next_tmp();
                let _ = writeln!(out, "  {rtag} = extractvalue {enum_ir} {rv}, 0");
                let teq = self.next_tmp();
                let _ = writeln!(out, "  {teq} = icmp eq i64 {ltag}, {rtag}");
                if info.payload_words == 0 {
                    return Ok(teq);
                }
                let res_slot = self.next_slot("enumeq.res");
                let lslot = self.next_slot("enumeq.l");
                let rslot = self.next_slot("enumeq.r");
                let _ = writeln!(self.allocas, "  {res_slot} = alloca i1, align 1");
                let _ = writeln!(self.allocas, "  {lslot} = alloca {enum_ir}, align 8");
                let _ = writeln!(self.allocas, "  {rslot} = alloca {enum_ir}, align 8");
                let _ = writeln!(out, "  store i1 false, ptr {res_slot}, align 1");
                let sw_lbl = self.fresh_label("enumeq.sw");
                let unit_ok_lbl = self.fresh_label("enumeq.unit");
                let done_lbl = self.fresh_label("enumeq.done");
                self.emit_cond_br(&teq, &sw_lbl, &done_lbl, out);

                self.start_block(&sw_lbl, out);
                let _ = writeln!(out, "  store {enum_ir} {lv}, ptr {lslot}, align 8");
                let _ = writeln!(out, "  store {enum_ir} {rv}, ptr {rslot}, align 8");
                let mut v_lbls = Vec::new();
                for (vidx, (_, fs, offs)) in info.variants.iter().enumerate() {
                    if !fs.is_empty() {
                        v_lbls.push((vidx, self.fresh_label("enumeq.v"), fs.clone(), offs.clone()));
                    }
                }
                let _ = write!(out, "  switch i64 {ltag}, label %{unit_ok_lbl} [");
                for (vidx, lbl, _, _) in &v_lbls {
                    let _ = write!(out, " i64 {vidx}, label %{lbl}");
                }
                let _ = writeln!(out, " ]");
                self.terminated = true;

                self.start_block(&unit_ok_lbl, out);
                let _ = writeln!(out, "  store i1 true, ptr {res_slot}, align 1");
                self.emit_br(&done_lbl, out);

                for (_, lbl, fs, offs) in v_lbls {
                    self.start_block(&lbl, out);
                    for (fty, woff) in fs.iter().zip(offs.iter()) {
                        let lp = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {lp} = getelementptr inbounds {enum_ir}, ptr {lslot}, i32 0, i32 1, i64 {woff}"
                        );
                        let rp = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {rp} = getelementptr inbounds {enum_ir}, ptr {rslot}, i32 0, i32 1, i64 {woff}"
                        );
                        let lf = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {lf} = load {}, ptr {lp}, align {}",
                            ir_type(fty),
                            ir_align(fty)
                        );
                        let rf = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {rf} = load {}, ptr {rp}, align {}",
                            ir_type(fty),
                            ir_align(fty)
                        );
                        let feq = self.emit_structural_eq(fty, &lf, &rf, span, out)?;
                        let next_lbl = self.fresh_label("enumeq.fnext");
                        self.emit_cond_br(&feq, &next_lbl, &done_lbl, out);
                        self.start_block(&next_lbl, out);
                    }
                    let _ = writeln!(out, "  store i1 true, ptr {res_slot}, align 1");
                    self.emit_br(&done_lbl, out);
                }

                self.start_block(&done_lbl, out);
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = load i1, ptr {res_slot}, align 1");
                Ok(r)
            }
            _ => Err(Diagnostic::new(
                format!("equality `==` / `!=` is not supported for `{}`", ty.name()),
                span,
            )),
        }
    }

    // ---------------- Tuples: Literals, Indexing & Unpacking -----------------

    pub(super) fn eval_tuple_lit(
        &mut self,
        elems: &[Expr],
        expected: Option<&Type>,
        _span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if elems.is_empty() {
            return Ok((Type::Tuple(Vec::new()), "zeroinitializer".to_string()));
        }
        let exp_items: Option<&[Type]> = match expected {
            Some(Type::Tuple(ts)) if ts.len() == elems.len() => Some(ts.as_slice()),
            Some(Type::Optional(inner)) => match inner.as_ref() {
                Type::Tuple(ts) if ts.len() == elems.len() => Some(ts.as_slice()),
                _ => None,
            },
            _ => None,
        };

        let mut elem_tys = Vec::with_capacity(elems.len());
        let mut owned_vals = Vec::with_capacity(elems.len());
        for (i, e) in elems.iter().enumerate() {
            let hint = exp_items.map(|ts| &ts[i]);
            if hint.is_none() && matches!(&e.kind, ExprKind::NoneLit) {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                elem_tys.push(Type::Any);
                owned_vals.push("zeroinitializer".to_string());
                continue;
            }
            let (ty, raw_val) = self.eval_expr_typed(e, hint, out)?;
            if ty == Type::Void {
                return Err(Diagnostic::new(
                    "tuple element cannot have type `void`",
                    e.span,
                ));
            }
            self.mark_runtime_type(&ty);
            let final_v = if let Some(ht) = hint {
                if ty == *ht {
                    if self.type_needs_drop(&ty) {
                        if self.claim_stmt_temp(&raw_val) {
                            raw_val
                        } else {
                            self.emit_clone_value(&ty, &raw_val, out)
                        }
                    } else {
                        raw_val
                    }
                } else if *ht == Type::Any {
                    self.emit_box_any_owned(&ty, &raw_val, e.span, out)?
                } else if ty == Type::Any {
                    let unboxed = self.emit_unbox_any(ht, &raw_val, e.span, out)?;
                    if self.type_needs_drop(ht) && !self.claim_stmt_temp(&unboxed) {
                        self.emit_clone_value(ht, &unboxed, out)
                    } else {
                        unboxed
                    }
                } else {
                    return Err(Diagnostic::new(
                        format!(
                            "tuple element {} expects `{}`, found `{}`",
                            i,
                            ht.name(),
                            ty.name()
                        ),
                        e.span,
                    ));
                }
            } else if self.type_needs_drop(&ty) {
                if self.claim_stmt_temp(&raw_val) {
                    raw_val
                } else {
                    self.emit_clone_value(&ty, &raw_val, out)
                }
            } else {
                raw_val
            };
            elem_tys.push(hint.cloned().unwrap_or(ty));
            owned_vals.push(final_v);
        }

        let tup_ty = Type::Tuple(elem_tys.clone());
        let tup_ir = ir_type(&tup_ty);
        let mut agg = "undef".to_string();
        for (i, (ety, v)) in elem_tys.iter().zip(owned_vals.iter()).enumerate() {
            let next_agg = self.next_tmp();
            let _ = writeln!(
                out,
                "  {next_agg} = insertvalue {tup_ir} {agg}, {} {v}, {i}",
                ir_type(ety)
            );
            agg = next_agg;
        }
        if self.type_needs_drop(&tup_ty) {
            self.stmt_temps.push(TempDrop {
                val: agg.clone(),
                ty: tup_ty.clone(),
            });
        }
        Ok((tup_ty, agg))
    }

    pub(super) fn eval_tuple_index(
        &mut self,
        items: &[Type],
        tup_val: &str,
        index: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let n = items.len() as i64;
        let tup_ty = Type::Tuple(items.to_vec());
        let tup_ir = ir_type(&tup_ty);

        if let Some(raw_i) = analysis::eval_const_int(index) {
            let adj = if raw_i < 0 { n + raw_i } else { raw_i };
            if adj < 0 || adj >= n {
                return Err(Diagnostic::new(
                    format!("tuple index {raw_i} out of range for tuple of length {n}"),
                    index.span,
                ));
            }
            let idx = adj as usize;
            let ety = items[idx].clone();
            let extracted = self.next_tmp();
            let _ = writeln!(out, "  {extracted} = extractvalue {tup_ir} {tup_val}, {idx}");
            if self.type_needs_drop(&ety) && self.stmt_temps.iter().any(|t| t.val == tup_val) {
                let cloned = self.emit_clone_value(&ety, &extracted, out);
                self.stmt_temps.push(TempDrop {
                    val: cloned.clone(),
                    ty: ety.clone(),
                });
                return Ok((ety, cloned));
            }
            return Ok((ety, extracted));
        }

        // Dynamic index supported on homogeneous non-empty tuples `(T, T, ...)`:
        if items.is_empty() {
            return Err(Diagnostic::new("cannot index into empty tuple `()`", span));
        }
        let first_ty = &items[0];
        if !items.iter().all(|t| t == first_ty) {
            return Err(Diagnostic::new(
                format!(
                    "heterogeneous tuple `{}` requires a constant integer index",
                    tup_ty.name()
                ),
                index.span,
            ));
        }
        let (idx_ty, raw_idx) = self.eval_expr(index, out)?;
        let idx_val = if idx_ty == Type::Int {
            raw_idx
        } else if idx_ty == Type::Any {
            self.emit_unbox_any(&Type::Int, &raw_idx, index.span, out)?
        } else {
            return Err(Diagnostic::new(
                format!("tuple index must be `int`, found `{}`", idx_ty.name()),
                index.span,
            ));
        };
        self.used_bounds_fail = true;
        let neg = self.next_tmp();
        let _ = writeln!(out, "  {neg} = icmp slt i64 {idx_val}, 0");
        let adj = self.next_tmp();
        let _ = writeln!(out, "  {adj} = add i64 {idx_val}, {n}");
        let eff = self.next_tmp();
        let _ = writeln!(out, "  {eff} = select i1 {neg}, i64 {adj}, i64 {idx_val}");
        let oob = self.next_tmp();
        let _ = writeln!(out, "  {oob} = icmp uge i64 {eff}, {n}");
        let oob_lbl = self.fresh_label("tidx.oob");
        let ok_lbl = self.fresh_label("tidx.ok");
        self.emit_cond_br(&oob, &oob_lbl, &ok_lbl, out);
        self.start_block(&oob_lbl, out);
        let _ = writeln!(out, "  call void @archx_bounds_fail(i64 {idx_val}, i64 {n})");
        let _ = writeln!(out, "  unreachable");
        self.start_block(&ok_lbl, out);

        let res_slot = self.next_slot("tidx.res");
        let ty_ir = ir_type(first_ty);
        let align = ir_align(first_ty);
        let _ = writeln!(self.allocas, "  {res_slot} = alloca {ty_ir}, align {align}");
        let done_lbl = self.fresh_label("tidx.done");
        let mut arm_lbls = Vec::with_capacity(items.len());
        for i in 0..items.len() {
            arm_lbls.push((i, self.fresh_label("tidx.arm")));
        }
        let _ = write!(out, "  switch i64 {eff}, label %{oob_lbl} [");
        for (i, lbl) in &arm_lbls {
            let _ = write!(out, " i64 {i}, label %{lbl}");
        }
        let _ = writeln!(out, " ]");
        self.terminated = true;
        for (i, lbl) in arm_lbls {
            self.start_block(&lbl, out);
            let ex = self.next_tmp();
            let _ = writeln!(out, "  {ex} = extractvalue {tup_ir} {tup_val}, {i}");
            let _ = writeln!(out, "  store {ty_ir} {ex}, ptr {res_slot}, align {align}");
            self.emit_br(&done_lbl, out);
        }
        self.start_block(&done_lbl, out);
        let loaded = self.next_tmp();
        let _ = writeln!(out, "  {loaded} = load {ty_ir}, ptr {res_slot}, align {align}");
        if self.type_needs_drop(first_ty) && self.stmt_temps.iter().any(|t| t.val == tup_val) {
            let cloned = self.emit_clone_value(first_ty, &loaded, out);
            self.stmt_temps.push(TempDrop {
                val: cloned.clone(),
                ty: first_ty.clone(),
            });
            return Ok((first_ty.clone(), cloned));
        }
        Ok((first_ty.clone(), loaded))
    }

    pub(super) fn gen_tuple_assign(
        &mut self,
        targets: &[String],
        value: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
        let count = targets.len();
        let mut extracted_items: Vec<(Type, String, bool)> = Vec::with_capacity(count);

        match rhs_ty {
            Type::Tuple(items) => {
                if items.len() != count {
                    return Err(Diagnostic::new(
                        format!(
                            "cannot unpack tuple of {} element(s) into {} target(s)",
                            items.len(),
                            count
                        ),
                        span,
                    ));
                }
                let tup_ty = Type::Tuple(items.clone());
                let tup_ir = ir_type(&tup_ty);
                let claimed_tup = self.type_needs_drop(&tup_ty) && self.claim_stmt_temp(&rhs_val);
                for (i, ety) in items.into_iter().enumerate() {
                    let ex = self.next_tmp();
                    let _ = writeln!(out, "  {ex} = extractvalue {tup_ir} {rhs_val}, {i}");
                    let is_owned = claimed_tup && self.type_needs_drop(&ety);
                    extracted_items.push((ety, ex, is_owned));
                }
            }
            Type::Array(elem_ty) => {
                self.used_bounds_fail = true;
                let len = self.next_tmp();
                let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {rhs_val}, 0");
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {len}, {count}");
                let ok_lbl = self.fresh_label("unpack.ok");
                let bad_lbl = self.fresh_label("unpack.bad");
                self.emit_cond_br(&ok, &ok_lbl, &bad_lbl, out);
                self.start_block(&bad_lbl, out);
                let _ = writeln!(out, "  call void @archx_bounds_fail(i64 {count}, i64 {len})");
                let _ = writeln!(out, "  unreachable");
                self.start_block(&ok_lbl, out);

                let data = self.next_tmp();
                let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {rhs_val}, 2");
                let mem_ty = elem_mem_ir_type(&elem_ty);
                for i in 0..count {
                    let ep = self.next_tmp();
                    let _ = writeln!(out, "  {ep} = getelementptr inbounds {mem_ty}, ptr {data}, i64 {i}");
                    let ev = self.emit_elem_load(&elem_ty, &ep, out);
                    extracted_items.push(((*elem_ty).clone(), ev, false));
                }
            }
            Type::Any => {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                for i in 0..count {
                    let idx_any = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {idx_any} = insertvalue %ArchxAny {{ i64 2, i64 0, i64 0 }}, i64 {i}, 1"
                    );
                    let ev = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {ev} = call fastcc %ArchxAny @archx_any_get_idx(%ArchxAny {rhs_val}, %ArchxAny {idx_any})"
                    );
                    extracted_items.push((Type::Any, ev, true));
                }
            }
            other => {
                return Err(Diagnostic::new(
                    format!("cannot unpack value of type `{}`", other.name()),
                    span,
                ));
            }
        }

        for (tname, (ety, eval, is_owned)) in targets.iter().zip(extracted_items.into_iter()) {
            if tname == "_" {
                if is_owned {
                    self.emit_drop_value(&ety, &eval, out);
                }
                continue;
            }
            self.store_or_bind_unpacked_var(tname, ety, eval, is_owned, span, out)?;
        }
        self.flush_stmt_temps(out);
        Ok(())
    }

    pub(super) fn store_or_bind_unpacked_var(
        &mut self,
        name: &str,
        val_ty: Type,
        val: String,
        val_is_owned: bool,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if let Some(entry) = self.lookup_var(name).cloned() {
            self.check_region_escape_target(name, &entry.ty, span)?;
            self.clear_narrowed_optional(name);
            let ptr = match &entry.storage {
                VarStorage::Slot(p) => p.clone(),
                _ => {
                    return Err(Diagnostic::new(
                        format!("internal error: mutated variable `{name}` lacked a slot"),
                        span,
                    ));
                }
            };
            let final_v = self.coerce_unpacked_val(&entry.ty, &val_ty, &val, val_is_owned, span, out)?;
            if self.type_needs_drop(&entry.ty) {
                let old_v = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {old_v} = load {}, ptr {ptr}, align {}",
                    ir_type(&entry.ty),
                    ir_align(&entry.ty)
                );
                self.emit_drop_value(&entry.ty, &old_v, out);
            }
            let _ = writeln!(
                out,
                "  store {} {final_v}, ptr {ptr}, align {}",
                ir_type(&entry.ty),
                ir_align(&entry.ty)
            );
            return Ok(());
        }

        let target_ty = if self.adaptive_hints.dynamic_vars.contains(name) {
            Type::Any
        } else {
            val_ty.clone()
        };
        self.mark_runtime_type(&target_ty);
        let owned_v = self.coerce_unpacked_val(&target_ty, &val_ty, &val, val_is_owned, span, out)?;
        let needs_drop = self.type_needs_drop(&target_ty);
        let is_mutated = self.mutated_vars.contains(name);

        let storage = if !is_mutated && !needs_drop {
            VarStorage::Imm(owned_v)
        } else {
            let ptr = self.next_slot(&format!("var.{name}"));
            let ty_ir = ir_type(&target_ty);
            let align = ir_align(&target_ty);
            let _ = writeln!(self.allocas, "  {ptr} = alloca {ty_ir}, align {align}");
            let _ = writeln!(out, "  store {ty_ir} {owned_v}, ptr {ptr}, align {align}");
            if needs_drop {
                self.scopes
                    .last_mut()
                    .unwrap()
                    .owned_buffers
                    .push(DropTarget::TypedSlot {
                        ptr: ptr.clone(),
                        ty: target_ty.clone(),
                    });
            }
            VarStorage::Slot(ptr)
        };
        self.scopes.last_mut().unwrap().vars.insert(
            name.to_string(),
            VarEntry {
                ty: target_ty,
                storage,
                is_param: false,
                region_depth: self.region_stack.len(),
            },
        );
        Ok(())
    }

    fn coerce_unpacked_val(
        &mut self,
        expected: &Type,
        actual_ty: &Type,
        val: &str,
        val_is_owned: bool,
        span: Span,
        out: &mut String,
    ) -> Result<String> {
        if expected == actual_ty {
            if self.type_needs_drop(expected) && !val_is_owned {
                return Ok(self.emit_clone_value(expected, val, out));
            }
            return Ok(val.to_string());
        }
        if let Type::Optional(inner) = expected {
            if **inner == *actual_ty {
                let inner_v = if self.type_needs_drop(actual_ty) && !val_is_owned {
                    self.emit_clone_value(actual_ty, val, out)
                } else {
                    val.to_string()
                };
                let opt_ir = ir_type(expected);
                let s0 = self.next_tmp();
                let _ = writeln!(out, "  {s0} = insertvalue {opt_ir} undef, i1 1, 0");
                let s1 = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {s1} = insertvalue {opt_ir} {s0}, {} {inner_v}, 1",
                    ir_type(actual_ty)
                );
                return Ok(s1);
            }
        }
        if *expected == Type::Any {
            if val_is_owned {
                self.stmt_temps.push(TempDrop {
                    val: val.to_string(),
                    ty: actual_ty.clone(),
                });
            }
            return self.emit_box_any_owned(actual_ty, val, span, out);
        }
        if *actual_ty == Type::Any {
            let unboxed = self.emit_unbox_any(expected, val, span, out)?;
            if val_is_owned {
                self.emit_drop_value(&Type::Any, val, out);
            }
            if self.type_needs_drop(expected) && !self.claim_stmt_temp(&unboxed) {
                return Ok(self.emit_clone_value(expected, &unboxed, out));
            }
            return Ok(unboxed);
        }
        Err(Diagnostic::new(
            format!(
                "unpacking type mismatch: expected `{}`, found `{}`",
                expected.name(),
                actual_ty.name()
            ),
            span,
        ))
    }

    // ---------------- Algebraic Enums: Construction, Drop & Clone ------------

    pub(super) fn gen_enum_unit(
        &mut self,
        ename: &str,
        vname: &str,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let info = self
            .enums
            .get(ename)
            .cloned()
            .ok_or_else(|| Diagnostic::new(format!("unknown enum `{ename}`"), span))?;
        let (vidx, (_, fields, _)) = info
            .variants
            .iter()
            .enumerate()
            .find(|(_, (vn, _, _))| vn == vname)
            .ok_or_else(|| {
                Diagnostic::new(format!("enum `{ename}` has no variant `{vname}`"), span)
            })?;
        if !fields.is_empty() {
            return Err(Diagnostic::new(
                format!(
                    "enum variant `{ename}.{vname}` expects {} argument(s), found 0",
                    fields.len()
                ),
                span,
            ));
        }
        let enum_ty = Type::Enum(ename.to_string());
        let enum_ir = ir_type(&enum_ty);
        let reg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {reg} = insertvalue {enum_ir} zeroinitializer, i64 {vidx}, 0"
        );
        Ok((enum_ty, reg))
    }

    pub(super) fn gen_enum_construct(
        &mut self,
        ename: &str,
        vname: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let info = self
            .enums
            .get(ename)
            .cloned()
            .ok_or_else(|| Diagnostic::new(format!("unknown enum `{ename}`"), span))?;
        let (vidx, (_, fields, offsets)) = info
            .variants
            .iter()
            .enumerate()
            .find(|(_, (vn, _, _))| vn == vname)
            .ok_or_else(|| {
                Diagnostic::new(format!("enum `{ename}` has no variant `{vname}`"), span)
            })?;
        if args.len() != fields.len() {
            return Err(Diagnostic::new(
                format!(
                    "enum variant `{ename}.{vname}` expects {} argument(s), found {}",
                    fields.len(),
                    args.len()
                ),
                span,
            ));
        }
        let enum_ty = Type::Enum(ename.to_string());
        let enum_ir = ir_type(&enum_ty);
        if fields.is_empty() {
            let reg = self.next_tmp();
            let _ = writeln!(
                out,
                "  {reg} = insertvalue {enum_ir} zeroinitializer, i64 {vidx}, 0"
            );
            return Ok((enum_ty, reg));
        }

        let mut fvals = Vec::with_capacity(fields.len());
        for (arg, fty) in args.iter().zip(fields.iter()) {
            let v = self.eval_owned_for_slot(fty, arg, out)?;
            fvals.push(v);
        }

        let eslot = self.next_slot(&format!("enum.{ename}"));
        let _ = writeln!(self.allocas, "  {eslot} = alloca {enum_ir}, align 8");
        let _ = writeln!(out, "  store {enum_ir} zeroinitializer, ptr {eslot}, align 8");
        let _ = writeln!(out, "  store i64 {vidx}, ptr {eslot}, align 8");
        for ((fty, woff), fv) in fields.iter().zip(offsets.iter()).zip(fvals.iter()) {
            let fp = self.next_tmp();
            let _ = writeln!(
                out,
                "  {fp} = getelementptr inbounds {enum_ir}, ptr {eslot}, i32 0, i32 1, i64 {woff}"
            );
            let _ = writeln!(
                out,
                "  store {} {fv}, ptr {fp}, align {}",
                ir_type(fty),
                ir_align(fty)
            );
        }
        let res = self.next_tmp();
        let _ = writeln!(out, "  {res} = load {enum_ir}, ptr {eslot}, align 8");
        if self.type_needs_drop(&enum_ty) {
            self.stmt_temps.push(TempDrop {
                val: res.clone(),
                ty: enum_ty.clone(),
            });
        }
        Ok((enum_ty, res))
    }

    pub(super) fn ensure_enum_drop_helper(&mut self, ename: &str) -> String {
        let sym = format!("@archx_enum_drop_{ename}");
        if self.emitted_enum_drops.contains(ename) {
            return sym;
        }
        self.emitted_enum_drops.insert(ename.to_string());

        let info = self.enums[ename].clone();
        let enum_ir = format!("%ArchxEnum_{ename}");
        let saved_tmp = self.next_tmp;
        let saved_lbl = self.next_label;
        let saved_term = self.terminated;
        self.next_tmp = 0;
        self.next_label = 0;
        self.terminated = false;

        let mut h = String::new();
        let _ = writeln!(h, "define private fastcc void {sym}({enum_ir} %v) nounwind {{");
        let _ = writeln!(h, "entry:");
        let mut drop_arms = Vec::new();
        for (vidx, (_, fs, offs)) in info.variants.iter().enumerate() {
            if fs.iter().any(|t| self.type_needs_drop(t)) {
                drop_arms.push((vidx, format!("v.{vidx}"), fs.clone(), offs.clone()));
            }
        }
        if drop_arms.is_empty() {
            let _ = writeln!(h, "  ret void\n}}\n");
        } else {
            let _ = writeln!(h, "  %slot = alloca {enum_ir}, align 8");
            let _ = writeln!(h, "  store {enum_ir} %v, ptr %slot, align 8");
            let _ = writeln!(h, "  %tag = extractvalue {enum_ir} %v, 0");
            let _ = write!(h, "  switch i64 %tag, label %done [");
            for (vidx, lbl, _, _) in &drop_arms {
                let _ = write!(h, " i64 {vidx}, label %{lbl}");
            }
            let _ = writeln!(h, " ]");
            for (_, lbl, fs, offs) in drop_arms {
                self.start_block(&lbl, &mut h);
                for (fty, woff) in fs.iter().zip(offs.iter()) {
                    if self.type_needs_drop(fty) {
                        let fp = self.next_tmp();
                        let _ = writeln!(
                            h,
                            "  {fp} = getelementptr inbounds {enum_ir}, ptr %slot, i32 0, i32 1, i64 {woff}"
                        );
                        let fv = self.next_tmp();
                        let _ = writeln!(
                            h,
                            "  {fv} = load {}, ptr {fp}, align {}",
                            ir_type(fty),
                            ir_align(fty)
                        );
                        self.emit_drop_value(fty, &fv, &mut h);
                    }
                }
                self.emit_br("done", &mut h);
            }
            self.start_block("done", &mut h);
            let _ = writeln!(h, "  ret void\n}}\n");
        }

        self.extra_helpers.push_str(&h);
        self.next_tmp = saved_tmp;
        self.next_label = saved_lbl;
        self.terminated = saved_term;
        sym
    }

    pub(super) fn ensure_enum_clone_helper(&mut self, ename: &str) -> String {
        let sym = format!("@archx_enum_clone_{ename}");
        if self.emitted_enum_clones.contains(ename) {
            return sym;
        }
        self.emitted_enum_clones.insert(ename.to_string());

        let info = self.enums[ename].clone();
        let enum_ir = format!("%ArchxEnum_{ename}");
        let saved_tmp = self.next_tmp;
        let saved_lbl = self.next_label;
        let saved_term = self.terminated;
        self.next_tmp = 0;
        self.next_label = 0;
        self.terminated = false;

        let mut h = String::new();
        let _ = writeln!(h, "define private fastcc {enum_ir} {sym}({enum_ir} %v) {{");
        let _ = writeln!(h, "entry:");
        let mut clone_arms = Vec::new();
        for (vidx, (_, fs, offs)) in info.variants.iter().enumerate() {
            if fs.iter().any(|t| self.type_needs_drop(t)) {
                clone_arms.push((vidx, format!("v.{vidx}"), fs.clone(), offs.clone()));
            }
        }
        if clone_arms.is_empty() {
            let _ = writeln!(h, "  ret {enum_ir} %v\n}}\n");
        } else {
            let _ = writeln!(h, "  %src = alloca {enum_ir}, align 8");
            let _ = writeln!(h, "  %dst = alloca {enum_ir}, align 8");
            let _ = writeln!(h, "  store {enum_ir} %v, ptr %src, align 8");
            let _ = writeln!(h, "  store {enum_ir} %v, ptr %dst, align 8");
            let _ = writeln!(h, "  %tag = extractvalue {enum_ir} %v, 0");
            let _ = write!(h, "  switch i64 %tag, label %done [");
            for (vidx, lbl, _, _) in &clone_arms {
                let _ = write!(h, " i64 {vidx}, label %{lbl}");
            }
            let _ = writeln!(h, " ]");
            for (_, lbl, fs, offs) in clone_arms {
                self.start_block(&lbl, &mut h);
                for (fty, woff) in fs.iter().zip(offs.iter()) {
                    if self.type_needs_drop(fty) {
                        let sp = self.next_tmp();
                        let _ = writeln!(
                            h,
                            "  {sp} = getelementptr inbounds {enum_ir}, ptr %src, i32 0, i32 1, i64 {woff}"
                        );
                        let dp = self.next_tmp();
                        let _ = writeln!(
                            h,
                            "  {dp} = getelementptr inbounds {enum_ir}, ptr %dst, i32 0, i32 1, i64 {woff}"
                        );
                        let sv = self.next_tmp();
                        let _ = writeln!(
                            h,
                            "  {sv} = load {}, ptr {sp}, align {}",
                            ir_type(fty),
                            ir_align(fty)
                        );
                        let cv = self.emit_clone_value(fty, &sv, &mut h);
                        let _ = writeln!(
                            h,
                            "  store {} {cv}, ptr {dp}, align {}",
                            ir_type(fty),
                            ir_align(fty)
                        );
                    }
                }
                self.emit_br("done", &mut h);
            }
            self.start_block("done", &mut h);
            let _ = writeln!(h, "  %res = load {enum_ir}, ptr %dst, align 8");
            let _ = writeln!(h, "  ret {enum_ir} %res\n}}\n");
        }

        self.extra_helpers.push_str(&h);
        self.next_tmp = saved_tmp;
        self.next_label = saved_lbl;
        self.terminated = saved_term;
        sym
    }

    // ---------------- Printing Tuples, Optionals & Enums ---------------------

    pub(super) fn emit_print_composite_v8(
        &mut self,
        ty: &Type,
        val: &str,
        newline: bool,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        self.used_print_inline = true;
        match ty {
            Type::Optional(inner) => {
                let opt_ir = ir_type(ty);
                let has = self.next_tmp();
                let _ = writeln!(out, "  {has} = extractvalue {opt_ir} {val}, 0");
                let some_lbl = self.fresh_label("prt.opt.some");
                let none_lbl = self.fresh_label("prt.opt.none");
                let done_lbl = self.fresh_label("prt.opt.done");
                self.emit_cond_br(&has, &some_lbl, &none_lbl, out);

                self.start_block(&some_lbl, out);
                let iv = self.next_tmp();
                let _ = writeln!(out, "  {iv} = extractvalue {opt_ir} {val}, 1");
                self.emit_print_inline_val(inner, &iv, span, out)?;
                self.emit_br(&done_lbl, out);

                self.start_block(&none_lbl, out);
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr @.str.none)"
                );
                self.emit_br(&done_lbl, out);

                self.start_block(&done_lbl, out);
            }
            Type::Tuple(items) => {
                self.used_str_print = true;
                let lp = self.next_tmp();
                let _ = writeln!(out, "  {lp} = call i32 @putchar(i32 40)");
                let tup_ir = ir_type(ty);
                for (i, item_ty) in items.iter().enumerate() {
                    if i > 0 {
                        self.used_array_print = true;
                        let sep = self.next_tmp();
                        let _ = writeln!(out, "  {sep} = call i32 (ptr, ...) @printf(ptr @.fmt.sep)");
                    }
                    let fv = self.next_tmp();
                    let _ = writeln!(out, "  {fv} = extractvalue {tup_ir} {val}, {i}");
                    self.emit_print_inline_val(item_ty, &fv, span, out)?;
                }
                if items.len() == 1 {
                    let cm = self.next_tmp();
                    let _ = writeln!(out, "  {cm} = call i32 @putchar(i32 44)");
                }
                let rp = self.next_tmp();
                let _ = writeln!(out, "  {rp} = call i32 @putchar(i32 41)");
            }
            Type::Enum(ename) => {
                self.used_str_print = true;
                let info = self.enums[ename].clone();
                let enum_ir = format!("%ArchxEnum_{ename}");
                let eslot = self.next_slot("prt.enum");
                let _ = writeln!(self.allocas, "  {eslot} = alloca {enum_ir}, align 8");
                let _ = writeln!(out, "  store {enum_ir} {val}, ptr {eslot}, align 8");
                let tag = self.next_tmp();
                let _ = writeln!(out, "  {tag} = extractvalue {enum_ir} {val}, 0");
                let done_lbl = self.fresh_label("prt.enum.done");
                let mut v_lbls = Vec::with_capacity(info.variants.len());
                for (vidx, (vn, fs, offs)) in info.variants.into_iter().enumerate() {
                    v_lbls.push((vidx, self.fresh_label("prt.enum.v"), vn, fs, offs));
                }
                let _ = write!(out, "  switch i64 {tag}, label %{done_lbl} [");
                for (vidx, lbl, _, _, _) in &v_lbls {
                    let _ = write!(out, " i64 {vidx}, label %{lbl}");
                }
                let _ = writeln!(out, " ]");
                self.terminated = true;
                for (_, lbl, vn, fs, offs) in v_lbls {
                    self.start_block(&lbl, out);
                    let prefix = if fs.is_empty() {
                        format!("{ename}.{vn}")
                    } else {
                        format!("{ename}.{vn}(")
                    };
                    let psym = self.strings.intern(&prefix);
                    let pr = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {pr} = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr {psym})"
                    );
                    for (fi, (fty, woff)) in fs.iter().zip(offs.iter()).enumerate() {
                        if fi > 0 {
                            self.used_array_print = true;
                            let sep = self.next_tmp();
                            let _ = writeln!(
                                out,
                                "  {sep} = call i32 (ptr, ...) @printf(ptr @.fmt.sep)"
                            );
                        }
                        let fp = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {fp} = getelementptr inbounds {enum_ir}, ptr {eslot}, i32 0, i32 1, i64 {woff}"
                        );
                        let fv = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {fv} = load {}, ptr {fp}, align {}",
                            ir_type(fty),
                            ir_align(fty)
                        );
                        self.emit_print_inline_val(fty, &fv, span, out)?;
                    }
                    if !fs.is_empty() {
                        let rp = self.next_tmp();
                        let _ = writeln!(out, "  {rp} = call i32 @putchar(i32 41)");
                    }
                    self.emit_br(&done_lbl, out);
                }
                self.start_block(&done_lbl, out);
            }
            _ => unreachable!(),
        }
        if newline {
            self.used_str_print = true;
            let nl = self.next_tmp();
            let _ = writeln!(out, "  {nl} = call i32 @putchar(i32 10)");
        }
        Ok(())
    }

}
