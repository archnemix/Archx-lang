//! Milestone 9 (`v0.9.0`) — PEP 695 monomorphized generics and zero-heap stack closures.
//!
//! A deterministic AST-to-AST pass that runs before LLVM lowering:
//!
//! 1. **PEP 695 monomorphization.** `class Box[T]:` / `def ident[T](x: T) -> T:` are
//!    specialized per concrete type-argument list. Instantiation is discovered from
//!    explicit `Box[int](...)` / `ident[int](...)` syntax *and* from automatic argument
//!    unification at constructor/call sites. Every specialization becomes an ordinary,
//!    fully-typed `StructDef` / `Func` (`Box__i`), so the backend keeps its 1:1 layout
//!    story — `Box[int]` is a stack value of literally `{ i64 }` with no boxes, no
//!    vtables, and no dynamic dispatch.
//! 2. **Zero-heap closure defunctionalization.** A `lambda` bound to a local name becomes
//!    a private `__ArchxClosure_<id>` function whose leading parameters are the captured
//!    values. Every call of the bound name is rewritten into a direct call of the closure
//!    with the captures threaded in, so LLVM sees one `fastcc` call that always inlines
//!    and never allocates. Captureless closures still take a dummy `__env: bool` so the
//!    IR signature is never empty.
//!
//! Lambdas used *inline* as `key=lambda ...` on `sorted` / `sort` / `min` / `max` are
//! intentionally left alone: those are lowered by inlining the body straight into the
//! generated loop/compare code (see `sort.rs`), which is strictly faster than a call.

use std::collections::{HashMap, HashSet};

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

/// Prefix of every generated closure function.
pub(super) const CLOSURE_PREFIX: &str = "__ArchxClosure_";
/// Name of the synthetic environment parameter of a captureless closure.
pub(super) const ENV_PARAM: &str = "__env";

/// Runs the `v0.9.0` generic + closure pipeline over a type-resolved program.
pub(super) fn expand_generics_and_lambdas(program: &Program) -> Result<Program> {
    let mut m = Monomorphizer::new(program);
    let rewritten = m.rewrite_module(program)?;

    let mut structs = rewritten.structs;
    structs.extend(m.inst_structs.into_values());

    let mut funcs = rewritten.funcs;
    funcs.extend(m.inst_funcs.into_values());
    funcs.extend(m.closures.into_values());

    Ok(Program {
        structs,
        enums: rewritten.enums,
        funcs,
    })
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

struct Monomorphizer<'a> {
    generic_structs: HashMap<String, &'a StructDef>,
    generic_funcs: HashMap<String, &'a Func>,
    inst_structs: HashMap<String, StructDef>,
    inst_funcs: HashMap<String, Func>,
    closures: HashMap<String, Func>,
    struct_queue: Vec<(String, Vec<Type>, Span)>,
    func_queue: Vec<(String, Vec<Type>, Span)>,
    queued_structs: HashSet<String>,
    queued_funcs: HashSet<String>,
    /// Local name -> lifted closure, for the current lexical block chain.
    bound: HashMap<String, Lifted>,
    /// Visible variable types, used to type closure captures and lambda parameters.
    env_types: HashMap<String, Type>,
    /// Closure name -> how to call it (leading capture args).
    call_shapes: HashMap<String, CallShape>,
    /// Lambdas already lifted, keyed by source position.
    lifted_by_span: HashMap<(usize, usize), Lifted>,
    next_id: usize,
}

#[derive(Clone, Debug)]
struct Lifted {
    func: String,
    captures: Vec<String>,
    ret: Option<Type>,
}

#[derive(Clone, Debug)]
struct CallShape {
    /// Capture expressions that must precede the user arguments.
    leading: Vec<String>,
    /// True when the closure takes the synthetic `__env` dummy argument.
    dummy_env: bool,
}

impl<'a> Monomorphizer<'a> {
    fn new(program: &'a Program) -> Self {
        let mut generic_structs = HashMap::new();
        for s in &program.structs {
            if !s.type_params.is_empty() {
                generic_structs.insert(s.name.clone(), s);
            }
        }
        let mut generic_funcs = HashMap::new();
        for f in &program.funcs {
            if !f.type_params.is_empty() {
                generic_funcs.insert(f.name.clone(), f);
            }
        }
        Self {
            generic_structs,
            generic_funcs,
            inst_structs: HashMap::new(),
            inst_funcs: HashMap::new(),
            closures: HashMap::new(),
            struct_queue: Vec::new(),
            func_queue: Vec::new(),
            queued_structs: HashSet::new(),
            queued_funcs: HashSet::new(),
            bound: HashMap::new(),
            env_types: HashMap::new(),
            call_shapes: HashMap::new(),
            lifted_by_span: HashMap::new(),
            next_id: 0,
        }
    }

    // ---------------- Monomorphization ----------------

    fn specialize_struct(&mut self, name: &str, args: &[Type], span: Span) -> Result<String> {
        let Some(def) = self.generic_structs.get(name).copied() else {
            return Err(Diagnostic::new(
                format!("`{name}` is not a generic class/struct"),
                span,
            ));
        };
        if def.type_params.len() != args.len() {
            return Err(Diagnostic::new(
                format!(
                    "generic `{name}` expects {} type argument{}, found {}",
                    def.type_params.len(),
                    if def.type_params.len() == 1 { "" } else { "s" },
                    args.len()
                ),
                span,
            ));
        }
        if args.iter().any(|a| matches!(a, Type::Void)) {
            return Err(Diagnostic::new(
                format!("type argument for `{name}` cannot be `None`"),
                span,
            ));
        }
        let mangled = generic_inst_name(name, args);
        if self.queued_structs.insert(mangled.clone()) {
            self.struct_queue.push((name.to_string(), args.to_vec(), span));
        }
        Ok(mangled)
    }

    /// Resolves a generic function's type parameters from the *static types* of the supplied
    /// arguments: `add(3, 4)` -> `[int]`, `first(["a"])` -> `[str]`. Returns `None` when any type
    /// parameter is not pinned down by a direct argument, so the call falls through and reports
    /// the normal "undefined function" diagnostic instead of guessing.
    fn infer_type_args(&self, name: &str, args: &[Expr]) -> Option<Vec<Type>> {
        let def = self.generic_funcs.get(name)?;
        let mut found: Vec<Option<Type>> = vec![None; def.type_params.len()];
        for (param, arg) in def.params.iter().zip(args.iter()) {
            let Some(arg_ty) = infer_expr_ty(arg, &self.env_types) else {
                continue;
            };
            unify_param(&param.ty, &arg_ty, &def.type_params, &mut found);
        }
        found.into_iter().collect()
    }

    fn specialize_func(&mut self, name: &str, args: &[Type], span: Span) -> Result<String> {
        let Some(def) = self.generic_funcs.get(name).copied() else {
            return Err(Diagnostic::new(
                format!("`{name}` is not a generic function"),
                span,
            ));
        };
        if def.type_params.len() != args.len() {
            return Err(Diagnostic::new(
                format!(
                    "generic function `{name}` expects {} type argument{}, found {}",
                    def.type_params.len(),
                    if def.type_params.len() == 1 { "" } else { "s" },
                    args.len()
                ),
                span,
            ));
        }
        let mangled = generic_inst_name(name, args);
        if self.queued_funcs.insert(mangled.clone()) {
            self.func_queue.push((name.to_string(), args.to_vec(), span));
        }
        Ok(mangled)
    }

    fn build_struct(&self, def: &StructDef, args: &[Type]) -> StructDef {
        let mangled = generic_inst_name(&def.name, args);
        let mut subst: HashMap<String, Type> = def
            .type_params
            .iter()
            .cloned()
            .zip(args.iter().cloned())
            .collect();
        // Inside an instance, the template name denotes the instantiation: this is what turns
        // every method's `self: Box` into `self: Box__i`, and keeps a self-referential field
        // (`next: Box[T] | None`) pointing at the specialized layout.
        subst.insert(def.name.clone(), Type::Struct(mangled.clone()));
        StructDef {
            name: mangled.clone(),
            type_params: Vec::new(),
            fields: def
                .fields
                .iter()
                .map(|f| Param {
                    name: f.name.clone(),
                    ty: subst_ty(&f.ty, &subst),
                })
                .collect(),
            methods: def
                .methods
                .iter()
                .map(|m| {
                    let mut sm = subst_func(m, &mangled, &subst);
                    // `subst_func` renames the *function* after the instantiated class; a
                    // method keeps its own name inside the specialized struct.
                    sm.name = m.name.clone();
                    sm
                })
                .collect(),
            span: def.span,
        }
    }

    fn build_func(&self, def: &Func, args: &[Type]) -> Func {
        let subst: HashMap<String, Type> = def
            .type_params
            .iter()
            .cloned()
            .zip(args.iter().cloned())
            .collect();
        subst_func(def, &generic_inst_name(&def.name, args), &subst)
    }

    fn drain_queues(&mut self) -> Result<()> {
        let mut guard = 0usize;
        while !self.struct_queue.is_empty() || !self.func_queue.is_empty() {
            guard += 1;
            if guard > 16_384 {
                return Err(Diagnostic::new(
                    "generic instantiation exceeded the monomorphization budget \
                     (a generic type that instantiates itself with a larger type?)",
                    Span::new(1, 1),
                ));
            }
            if let Some((name, args, _span)) = self.struct_queue.pop() {
                let def = self.generic_structs[&name];
                let inst = self.build_struct(def, &args);
                let key = inst.name.clone();
                let rewritten = self.rewrite_struct_body(&inst)?;
                self.inst_structs.insert(key, rewritten);
                continue;
            }
            let Some((name, args, _span)) = self.func_queue.pop() else {
                continue;
            };
            let def = self.generic_funcs[&name];
            let inst = self.build_func(def, &args);
            let key = inst.name.clone();
            let rewritten = self.rewrite_func(&inst)?;
            self.inst_funcs.insert(key, rewritten);
        }
        Ok(())
    }

    // ---------------- Declaration rewriting ----------------

    fn rewrite_module(&mut self, program: &Program) -> Result<Rewritten> {
        // Structures and functions are rewritten first so instantiation requests raised by
        // their bodies exist before the queue drains; instances discovered *inside* an
        // instance are drained in the same loop.
        let mut structs = Vec::with_capacity(program.structs.len());
        for sdef in &program.structs {
            if sdef.type_params.is_empty() {
                structs.push(self.rewrite_struct_body(sdef)?);
            }
        }
        let mut funcs = Vec::with_capacity(program.funcs.len());
        for f in &program.funcs {
            if f.type_params.is_empty() {
                funcs.push(self.rewrite_func(f)?);
            }
        }
        self.drain_queues()?;
        Ok(Rewritten {
            structs,
            enums: program.enums.clone(),
            funcs,
        })
    }

    fn rewrite_struct_body(&mut self, sdef: &StructDef) -> Result<StructDef> {
        let saved_env = std::mem::take(&mut self.env_types);
        let saved_bound = std::mem::take(&mut self.bound);

        let mut out = StructDef {
            name: sdef.name.clone(),
            type_params: Vec::new(),
            fields: Vec::new(),
            methods: Vec::new(),
            span: sdef.span,
        };
        for f in &sdef.fields {
            let ty = self.rewrite_ty(&f.ty)?;
            self.env_types.insert(f.name.clone(), ty.clone());
            out.fields.push(Param {
                name: f.name.clone(),
                ty,
            });
        }
        // PEP 695: inside a generic template every `self` *is* the instantiation, so the self
        // type is the template name carrying its own type parameters (`Box[T]`). This keeps
        // `self.field` typed as `T` while the body is being rewritten.
        let self_ty = if sdef.type_params.is_empty() {
            Type::Struct(sdef.name.clone())
        } else {
            Type::GenericInst {
                name: sdef.name.clone(),
                args: sdef.type_params.iter().map(|p| Type::Struct(p.clone())).collect(),
            }
        };
        self.env_types.insert("self".to_string(), self_ty);
        for m in &sdef.methods {
            out.methods.push(self.rewrite_func(m)?);
        }

        self.env_types = saved_env;
        self.bound = saved_bound;
        Ok(out)
    }

    fn rewrite_func(&mut self, f: &Func) -> Result<Func> {
        let saved_env = std::mem::take(&mut self.env_types);
        let saved_bound = std::mem::take(&mut self.bound);

        let mut params = Vec::with_capacity(f.params.len());
        for p in &f.params {
            let ty = self.rewrite_ty(&p.ty)?;
            self.env_types.insert(p.name.clone(), ty.clone());
            params.push(Param {
                name: p.name.clone(),
                ty,
            });
        }
        let ret = match &f.ret {
            Some(t) => Some(self.rewrite_ty(t)?),
            None => None,
        };
        let body = self.rewrite_scoped(&f.body)?;

        self.env_types = saved_env;
        self.bound = saved_bound;
        Ok(Func {
            name: f.name.clone(),
            type_params: Vec::new(),
            params,
            ret,
            body,
            span: f.span,
        })
    }

    fn rewrite_ty(&mut self, ty: &Type) -> Result<Type> {
        Ok(match ty {
            Type::GenericInst { name, args } => {
                let args: Vec<Type> = args
                    .iter()
                    .map(|a| self.rewrite_ty(a))
                    .collect::<Result<_>>()?;
                if self.generic_structs.contains_key(name) {
                    Type::Struct(self.specialize_struct(name, &args, Span::new(1, 1))?)
                } else {
                    Type::GenericInst {
                        name: name.clone(),
                        args,
                    }
                }
            }
            Type::Array(inner) => Type::Array(Box::new(self.rewrite_ty(inner)?)),
            Type::Optional(inner) => Type::Optional(Box::new(self.rewrite_ty(inner)?)),
            Type::Tuple(items) => {
                Type::Tuple(items.iter().map(|t| self.rewrite_ty(t)).collect::<Result<_>>()?)
            }
            Type::Dict(k, v) => {
                Type::Dict(Box::new(self.rewrite_ty(k)?), Box::new(self.rewrite_ty(v)?))
            }
            Type::Set(inner) => Type::Set(Box::new(self.rewrite_ty(inner)?)),
            other => other.clone(),
        })
    }

    // ---------------- Statements ----------------

    /// Rewrites a nested block, letting lambda bindings escape into the enclosing walk
    /// (used for the top level of a body and for straight-line blocks).
    fn rewrite_scoped(&mut self, stmts: &[Stmt]) -> Result<Vec<Stmt>> {
        let mut out = Vec::with_capacity(stmts.len());
        for s in stmts {
            out.push(self.rewrite_stmt(s)?);
        }
        Ok(out)
    }

    /// Rewrites a nested block without leaking bindings out of it.
    fn rewrite_block(&mut self, stmts: &[Stmt]) -> Result<Vec<Stmt>> {
        let saved = self.bound.clone();
        let out = self.rewrite_scoped(stmts)?;
        self.bound = saved;
        Ok(out)
    }

    fn rewrite_stmt(&mut self, stmt: &Stmt) -> Result<Stmt> {
        let span = stmt.span;
        let kind = match &stmt.kind {
            StmtKind::Let { name, ty, value } => {
                let declared = match ty {
                    Some(t) => Some(self.rewrite_ty(t)?),
                    None => None,
                };
                if let Some(lift) = self.try_lift(value)? {
                    self.bind_closure(name, lift);
                    // The name itself carries no runtime value: it is a compile-time
                    // alias for the lifted closure, so a 1-byte placeholder keeps the
                    // slot layout trivial and fully optimized away.
                    return Ok(Stmt {
                        kind: StmtKind::Let {
                            name: name.clone(),
                            ty: Some(Type::Bool),
                            value: Expr {
                                kind: ExprKind::Bool(false),
                                span,
                            },
                        },
                        span,
                    });
                }
                StmtKind::Let {
                    name: name.clone(),
                    ty: declared,
                    value: self.rewrite_expr(value)?,
                }
            }
            StmtKind::Assign { target, op, value } => {
                if let (AssignTarget::Var(name), None) = (target, op) {
                    if let Some(lift) = self.try_lift(value)? {
                        self.bind_closure(name, lift);
                        return Ok(Stmt {
                            kind: StmtKind::Assign {
                                target: AssignTarget::Var(name.clone()),
                                op: None,
                                value: Expr {
                                    kind: ExprKind::Bool(false),
                                    span,
                                },
                            },
                            span,
                        });
                    }
                }
                // Keep the type environment in sync with plain `name = value` assignments so a
                // later `lambda` can capture the variable and its static type.
                if let (AssignTarget::Var(name), None) = (target, op) {
                    if let Some(t) = infer_expr_ty(value, &self.env_types) {
                        self.env_types.insert(name.clone(), t);
                    }
                }
                StmtKind::Assign {
                    target: self.rewrite_target(target)?,
                    op: *op,
                    value: self.rewrite_expr(value)?,
                }
            }
            StmtKind::Return(v) => StmtKind::Return(match v {
                Some(e) => Some(self.rewrite_expr(e)?),
                None => None,
            }),
            StmtKind::Expr(e) => StmtKind::Expr(self.rewrite_expr(e)?),
            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => StmtKind::If {
                cond: self.rewrite_expr(cond)?,
                then_body: self.rewrite_block(then_body)?,
                else_body: match else_body {
                    Some(b) => Some(self.rewrite_block(b)?),
                    None => None,
                },
            },
            StmtKind::While { cond, body } => StmtKind::While {
                cond: self.rewrite_expr(cond)?,
                body: self.rewrite_block(body)?,
            },
            StmtKind::For {
                var,
                start,
                end,
                step,
                body,
            } => {
                let start = self.rewrite_expr(start)?;
                let end = self.rewrite_expr(end)?;
                let step = match step {
                    Some(s) => Some(self.rewrite_expr(s)?),
                    None => None,
                };
                let saved_env = self.env_types.insert(var.clone(), Type::Int);
                let body = self.rewrite_block(body)?;
                restore_env(&mut self.env_types, var, saved_env);
                StmtKind::For {
                    var: var.clone(),
                    start,
                    end,
                    step,
                    body,
                }
            }
            StmtKind::ForEach { var, iter, body } => {
                let iter = self.rewrite_expr(iter)?;
                let saved_env = match self.infer_iter_elem(&iter) {
                    Some(t) => self.env_types.insert(var.clone(), t),
                    None => None,
                };
                let body = self.rewrite_block(body)?;
                restore_env(&mut self.env_types, var, saved_env);
                StmtKind::ForEach {
                    var: var.clone(),
                    iter,
                    body,
                }
            }
            StmtKind::ForEnumerate {
                idx_var,
                elem_var,
                iter,
                start,
                body,
            } => {
                let iter = self.rewrite_expr(iter)?;
                let start = match start {
                    Some(s) => Some(self.rewrite_expr(s)?),
                    None => None,
                };
                let s1 = self.env_types.insert(idx_var.clone(), Type::Int);
                let s2 = match self.infer_iter_elem(&iter) {
                    Some(t) => self.env_types.insert(elem_var.clone(), t),
                    None => None,
                };
                let body = self.rewrite_block(body)?;
                restore_env(&mut self.env_types, elem_var, s2);
                restore_env(&mut self.env_types, idx_var, s1);
                StmtKind::ForEnumerate {
                    idx_var: idx_var.clone(),
                    elem_var: elem_var.clone(),
                    iter,
                    start,
                    body,
                }
            }
            StmtKind::ForDictItems {
                key_var,
                val_var,
                dict,
                body,
            } => {
                let dict = self.rewrite_expr(dict)?;
                let body = self.rewrite_block(body)?;
                StmtKind::ForDictItems {
                    key_var: key_var.clone(),
                    val_var: val_var.clone(),
                    dict,
                    body,
                }
            }
            StmtKind::ForZip { vars, iters, body } => {
                let iters: Vec<Expr> = iters
                    .iter()
                    .map(|i| self.rewrite_expr(i))
                    .collect::<Result<_>>()?;
                let mut saved = Vec::with_capacity(vars.len());
                for (v, it) in vars.iter().zip(iters.iter()) {
                    let prev = match self.infer_iter_elem(it) {
                        Some(t) => self.env_types.insert(v.clone(), t),
                        None => None,
                    };
                    saved.push((v.clone(), prev));
                }
                let body = self.rewrite_block(body)?;
                for (v, prev) in saved.into_iter().rev() {
                    restore_env(&mut self.env_types, &v, prev);
                }
                StmtKind::ForZip {
                    vars: vars.clone(),
                    iters,
                    body,
                }
            }
            StmtKind::ForTupleUnpack { vars, iter, body } => {
                let iter = self.rewrite_expr(iter)?;
                let body = self.rewrite_block(body)?;
                StmtKind::ForTupleUnpack {
                    vars: vars.clone(),
                    iter,
                    body,
                }
            }
            StmtKind::TupleAssign { targets, value } => StmtKind::TupleAssign {
                targets: targets.clone(),
                value: self.rewrite_expr(value)?,
            },
            StmtKind::Match { subject, cases } => {
                let subject = self.rewrite_expr(subject)?;
                let mut new_cases = Vec::with_capacity(cases.len());
                for c in cases {
                    let saved = self.bound.clone();
                    let guard = match &c.guard {
                        Some(g) => Some(self.rewrite_expr(g)?),
                        None => None,
                    };
                    let body = self.rewrite_scoped(&c.body)?;
                    self.bound = saved;
                    new_cases.push(MatchCase {
                        pattern: c.pattern.clone(),
                        guard,
                        body,
                        span: c.span,
                    });
                }
                StmtKind::Match {
                    subject,
                    cases: new_cases,
                }
            }
            StmtKind::Region { body } => StmtKind::Region {
                body: self.rewrite_block(body)?,
            },
            StmtKind::Assert { cond, msg } => StmtKind::Assert {
                cond: self.rewrite_expr(cond)?,
                msg: match msg {
                    Some(m) => Some(self.rewrite_expr(m)?),
                    None => None,
                },
            },
            StmtKind::Pass => StmtKind::Pass,
            StmtKind::Break => StmtKind::Break,
            StmtKind::Continue => StmtKind::Continue,
        };
        Ok(Stmt { kind, span })
    }

    fn rewrite_target(&mut self, target: &AssignTarget) -> Result<AssignTarget> {
        Ok(match target {
            AssignTarget::Var(n) => AssignTarget::Var(n.clone()),
            AssignTarget::Index { target, index } => AssignTarget::Index {
                target: Box::new(self.rewrite_expr(target)?),
                index: Box::new(self.rewrite_expr(index)?),
            },
            AssignTarget::Field { target, field } => AssignTarget::Field {
                target: Box::new(self.rewrite_expr(target)?),
                field: field.clone(),
            },
        })
    }

    fn infer_iter_elem(&self, iter: &Expr) -> Option<Type> {
        match &iter.kind {
            ExprKind::Var(n) => match self.env_types.get(n) {
                Some(Type::Array(t)) | Some(Type::Set(t)) => Some((**t).clone()),
                Some(Type::Dict(k, _)) => Some((**k).clone()),
                Some(Type::Str) => Some(Type::Str),
                _ => None,
            },
            ExprKind::Call { name, .. } if name == "range" => Some(Type::Int),
            _ => None,
        }
    }

    // ---------------- Closures ----------------

    fn bind_closure(&mut self, name: &str, lift: Lifted) {
        let shape = CallShape {
            leading: lift.captures.clone(),
            dummy_env: lift.captures.is_empty(),
        };
        self.call_shapes.insert(lift.func.clone(), shape);
        if let Some(t) = &lift.ret {
            self.env_types.insert(name.to_string(), t.clone());
        }
        self.bound.insert(name.to_string(), lift);
    }

    fn try_lift(&mut self, expr: &Expr) -> Result<Option<Lifted>> {
        if !is_sort_key_lambda(expr) {
            return Ok(None);
        }
        Ok(Some(self.lift_lambda(expr)?))
    }

    fn lift_lambda(&mut self, expr: &Expr) -> Result<Lifted> {
        let ExprKind::Lambda { params, body } = &expr.kind else {
            unreachable!("lift_lambda on a non-lambda")
        };
        let key = (expr.span.line, expr.span.col);
        if let Some(l) = self.lifted_by_span.get(&key) {
            return Ok(l.clone());
        }

        let free = free_vars_of(body);
        let mut captures: Vec<(String, Type)> = Vec::new();
        for name in free {
            if params.iter().any(|p| p.name == name) {
                continue;
            }
            match self.env_types.get(&name).cloned() {
                Some(ty) => captures.push((name, ty)),
                None => {
                    return Err(Diagnostic::new(
                        format!(
                            "`lambda` captures `{name}`, which is not a local variable of the \
                             enclosing function"
                        ),
                        expr.span,
                    ))
                }
            }
        }

        // Parameter types: explicit Archx Speed annotations win, otherwise they are
        // inferred from the body and finally default to `int` (monomorphic, unboxed).
        let mut lam_params = Vec::with_capacity(params.len());
        for p in params {
            let ty = if p.ty != Type::Any {
                p.ty.clone()
            } else {
                infer_param_ty(&p.name, body, &self.env_types).unwrap_or(Type::Int)
            };
            lam_params.push(Param {
                name: p.name.clone(),
                ty,
            });
        }

        let fname = format!("{CLOSURE_PREFIX}{}", self.next_id);
        self.next_id += 1;

        let mut fn_params: Vec<Param> = captures
            .iter()
            .map(|(n, t)| Param {
                name: n.clone(),
                ty: t.clone(),
            })
            .collect();
        if fn_params.is_empty() {
            fn_params.push(Param {
                name: ENV_PARAM.to_string(),
                ty: Type::Bool,
            });
        }
        fn_params.extend(lam_params.iter().cloned());

        let saved_env = self.env_types.clone();
        let saved_bound = std::mem::take(&mut self.bound);
        for p in &fn_params {
            self.env_types.insert(p.name.clone(), p.ty.clone());
        }
        let new_body = self.rewrite_expr(body)?;
        let ret = infer_expr_ty(&new_body, &self.env_types).unwrap_or(Type::Int);
        self.env_types = saved_env;
        self.bound = saved_bound;

        self.closures.insert(
            fname.clone(),
            Func {
                name: fname.clone(),
                type_params: Vec::new(),
                params: fn_params,
                ret: Some(ret.clone()),
                body: vec![Stmt {
                    kind: StmtKind::Return(Some(new_body)),
                    span: expr.span,
                }],
                span: expr.span,
            },
        );

        let lifted = Lifted {
            func: fname,
            captures: captures.iter().map(|(n, _)| n.clone()).collect(),
            ret: Some(ret),
        };
        self.lifted_by_span.insert(key, lifted.clone());
        Ok(lifted)
    }

    /// `sorted(xs, key=lambda ...)` / `xs.sort(key=lambda ...)`: the `key=` lambda is
    /// **inlined** by the sort engine in `sort.rs` (one key evaluation per element, folded
    /// straight into the scratch record), so it is not lifted into a standalone function and
    /// is simply carried through untouched.
    fn rewrite_sort_key(&mut self, expr: &Expr) -> Result<Expr> {
        if is_sort_key_lambda(expr) {
            return Ok(expr.clone());
        }
        self.rewrite_expr(expr)
    }

    /// Rewrites a keyword-argument list, treating `key=` specially.
    fn rewrite_kw_args(
        &mut self,
        kw_args: &[(String, Expr, Span)],
    ) -> Result<Vec<(String, Expr, Span)>> {
        let mut out = Vec::with_capacity(kw_args.len());
        for (name, val, sp) in kw_args {
            let v = if name == "key" {
                self.rewrite_sort_key(val)?
            } else {
                self.rewrite_expr(val)?
            };
            out.push((name.clone(), v, *sp));
        }
        Ok(out)
    }

    /// True when `expr` is a `key=lambda ...` value that the sort engine will inline.
    /// Builds the argument list of a direct closure call, prepending the captures.
    fn closure_args(&self, func: &str, args: Vec<Expr>, span: Span) -> Vec<Expr> {
        let shape = self.call_shapes.get(func).cloned();
        let Some(shape) = shape else {
            return args;
        };
        let mut all: Vec<Expr> = shape
            .leading
            .iter()
            .map(|c| Expr {
                kind: ExprKind::Var(c.clone()),
                span,
            })
            .collect();
        if shape.dummy_env {
            all.push(Expr {
                kind: ExprKind::Bool(false),
                span,
            });
        }
        all.extend(args);
        all
    }

    // ---------------- Expressions ----------------

    fn rewrite_expr(&mut self, expr: &Expr) -> Result<Expr> {
        let span = expr.span;
        let kind = match &expr.kind {
            ExprKind::Lambda { .. } => {
                return Err(Diagnostic::new(
                    "a `lambda` must be bound to a name or used as `key=lambda ...` so it can be \
                     monomorphized",
                    span,
                ))
            }
            ExprKind::PercentFormat { template, args } => ExprKind::PercentFormat {
                template: template.clone(),
                args: Box::new(self.rewrite_expr(args)?),
            },
            ExprKind::CompareChain(operands) => {
                // Rebuild the chain with each operand rewritten, so monomorphization reaches them.
                let mut rebuilt = Vec::with_capacity(operands.len());
                for (e, op) in operands {
                    let rewritten = self.rewrite_expr(e)?;
                    rebuilt.push((Box::new(rewritten), *op));
                }
                ExprKind::CompareChain(rebuilt)
            }
            ExprKind::Int(v) => ExprKind::Int(*v),
            ExprKind::Float(v) => ExprKind::Float(*v),
            ExprKind::Bool(v) => ExprKind::Bool(*v),
            ExprKind::NoneLit => ExprKind::NoneLit,
            ExprKind::Str(s) => ExprKind::Str(s.clone()),
            ExprKind::Var(n) => {
                if self.bound.contains_key(n) {
                    return Err(Diagnostic::new(
                        format!(
                            "closure `{n}` can only be called directly (`{n}(...)`); Archx closures \
                             are zero-heap and are never passed by value"
                        ),
                        span,
                    ));
                }
                ExprKind::Var(n.clone())
            }
            ExprKind::FString(parts) => {
                let mut out = Vec::with_capacity(parts.len());
                for p in parts {
                    out.push(match p {
                        FStrPart::Lit(s) => FStrPart::Lit(s.clone()),
                        FStrPart::Expr(e) => FStrPart::Expr(self.rewrite_expr(e)?),
                        FStrPart::Spec { expr, spec } => FStrPart::Spec {
                            expr: self.rewrite_expr(expr)?,
                            spec: spec.clone(),
                        },
                    });
                }
                ExprKind::FString(out)
            }
            ExprKind::ArrayLit(es) => ExprKind::ArrayLit(
                es.iter().map(|e| self.rewrite_expr(e)).collect::<Result<_>>()?,
            ),
            ExprKind::SetLit(es) => ExprKind::SetLit(
                es.iter().map(|e| self.rewrite_expr(e)).collect::<Result<_>>()?,
            ),
            ExprKind::TupleLit(es) => ExprKind::TupleLit(
                es.iter().map(|e| self.rewrite_expr(e)).collect::<Result<_>>()?,
            ),
            ExprKind::ArrayRepeat { value, count } => ExprKind::ArrayRepeat {
                value: Box::new(self.rewrite_expr(value)?),
                count: Box::new(self.rewrite_expr(count)?),
            },
            ExprKind::DictLit(ps) => {
                let mut out = Vec::with_capacity(ps.len());
                for (k, v) in ps {
                    out.push((self.rewrite_expr(k)?, self.rewrite_expr(v)?));
                }
                ExprKind::DictLit(out)
            }
            ExprKind::ListComp { elt, clauses } => ExprKind::ListComp {
                elt: Box::new(self.rewrite_expr(elt)?),
                clauses: self.rewrite_clauses(clauses)?,
            },
            ExprKind::SetComp { elt, clauses } => ExprKind::SetComp {
                elt: Box::new(self.rewrite_expr(elt)?),
                clauses: self.rewrite_clauses(clauses)?,
            },
            ExprKind::GenExpr { elt, clauses } => ExprKind::GenExpr {
                elt: Box::new(self.rewrite_expr(elt)?),
                clauses: self.rewrite_clauses(clauses)?,
            },
            ExprKind::DictComp { key, val, clauses } => ExprKind::DictComp {
                key: Box::new(self.rewrite_expr(key)?),
                val: Box::new(self.rewrite_expr(val)?),
                clauses: self.rewrite_clauses(clauses)?,
            },
            ExprKind::Index { target, index } => ExprKind::Index {
                target: Box::new(self.rewrite_expr(target)?),
                index: Box::new(self.rewrite_expr(index)?),
            },
            ExprKind::Slice {
                target,
                start,
                stop,
                step,
            } => ExprKind::Slice {
                target: Box::new(self.rewrite_expr(target)?),
                start: match start {
                    Some(s) => Some(Box::new(self.rewrite_expr(s)?)),
                    None => None,
                },
                stop: match stop {
                    Some(s) => Some(Box::new(self.rewrite_expr(s)?)),
                    None => None,
                },
                step: match step {
                    Some(s) => Some(Box::new(self.rewrite_expr(s)?)),
                    None => None,
                },
            },
            ExprKind::Field { target, field } => ExprKind::Field {
                target: Box::new(self.rewrite_expr(target)?),
                field: field.clone(),
            },
            ExprKind::MethodCall {
                target,
                method,
                args,
            } => ExprKind::MethodCall {
                target: Box::new(self.rewrite_expr(target)?),
                method: method.clone(),
                args: args
                    .iter()
                    .map(|a| self.rewrite_expr(a))
                    .collect::<Result<_>>()?,
            },
            ExprKind::MethodCallKw {
                target,
                method,
                pos_args,
                kw_args,
            } => ExprKind::MethodCallKw {
                target: Box::new(self.rewrite_expr(target)?),
                method: method.clone(),
                pos_args: pos_args
                    .iter()
                    .map(|a| self.rewrite_expr(a))
                    .collect::<Result<_>>()?,
                kw_args: self.rewrite_kw_args(kw_args)?,
            },
            ExprKind::Call { name, args } => {
                let args: Vec<Expr> = args
                    .iter()
                    .map(|a| self.rewrite_expr(a))
                    .collect::<Result<_>>()?;
                // A call through a name bound to a lifted `lambda` becomes a direct
                // `fastcc` call, with the captured locals prepended as leading arguments.
                if let Some(lift) = self.bound.get(name).cloned() {
                    let all = self.closure_args(&lift.func, args, span);
                    return Ok(Expr {
                        kind: ExprKind::Call {
                            name: lift.func,
                            args: all,
                        },
                        span,
                    });
                }
                // Implicit PEP 695 instantiation: an unannotated `add(3, 4)` call resolves the
                // type arguments from the displayed argument types, so the caller never has to
                // spell `add[int](...)` for the common monomorphic case.
                if !self.bound.contains_key(name) && self.generic_funcs.contains_key(name) {
                    if let Some(targs) = self.infer_type_args(name, &args) {
                        let mangled = self.specialize_func(name, &targs, span)?;
                        return Ok(Expr {
                            kind: ExprKind::Call {
                                name: mangled,
                                args,
                            },
                            span,
                        });
                    }
                }
                ExprKind::Call {
                    name: name.clone(),
                    args,
                }
            }
            ExprKind::CallKw {
                name,
                pos_args,
                kw_args,
            } => ExprKind::CallKw {
                name: name.clone(),
                pos_args: pos_args
                    .iter()
                    .map(|a| self.rewrite_expr(a))
                    .collect::<Result<_>>()?,
                kw_args: self.rewrite_kw_args(kw_args)?,
            },
            ExprKind::CallGeneric {
                name,
                type_args,
                pos_args,
                kw_args,
            } => {
                let mut targs = Vec::with_capacity(type_args.len());
                for t in type_args {
                    targs.push(self.rewrite_ty(t)?);
                }
                let pos_args: Vec<Expr> = pos_args
                    .iter()
                    .map(|a| self.rewrite_expr(a))
                    .collect::<Result<_>>()?;
                let kw_args = kw_args
                    .iter()
                    .map(|(k, v, s)| Ok((k.clone(), self.rewrite_expr(v)?, *s)))
                    .collect::<Result<Vec<_>>>()?;
                if self.generic_structs.contains_key(name) {
                    let mangled = self.specialize_struct(name, &targs, span)?;
                    ExprKind::Call {
                        name: mangled,
                        args: pos_args,
                    }
                } else if self.generic_funcs.contains_key(name) {
                    let mangled = self.specialize_func(name, &targs, span)?;
                    ExprKind::Call {
                        name: mangled,
                        args: pos_args,
                    }
                } else {
                    ExprKind::CallGeneric {
                        name: name.clone(),
                        type_args: targs,
                        pos_args,
                        kw_args,
                    }
                }
            }
            ExprKind::CallExpr { callee, args } => {
                if let ExprKind::Lambda { .. } = &callee.kind {
                    let lifted = self.lift_lambda(callee)?;
                    let args: Vec<Expr> = args
                        .iter()
                        .map(|a| self.rewrite_expr(a))
                        .collect::<Result<_>>()?;
                    let all = self.closure_args(&lifted.func, args, span);
                    return Ok(Expr {
                        kind: ExprKind::Call {
                            name: lifted.func,
                            args: all,
                        },
                        span,
                    });
                }
                if let ExprKind::Var(n) = &callee.kind {
                    if let Some(lift) = self.bound.get(n).cloned() {
                        let args: Vec<Expr> = args
                            .iter()
                            .map(|a| self.rewrite_expr(a))
                            .collect::<Result<_>>()?;
                        let all = self.closure_args(&lift.func, args, span);
                        return Ok(Expr {
                            kind: ExprKind::Call {
                                name: lift.func,
                                args: all,
                            },
                            span,
                        });
                    }
                }
                ExprKind::CallExpr {
                    callee: Box::new(self.rewrite_expr(callee)?),
                    args: args
                        .iter()
                        .map(|a| self.rewrite_expr(a))
                        .collect::<Result<_>>()?,
                }
            }
            ExprKind::IfExpr {
                then_expr,
                cond,
                else_expr,
            } => ExprKind::IfExpr {
                then_expr: Box::new(self.rewrite_expr(then_expr)?),
                cond: Box::new(self.rewrite_expr(cond)?),
                else_expr: Box::new(self.rewrite_expr(else_expr)?),
            },
            ExprKind::Binary { op, lhs, rhs } => ExprKind::Binary {
                op: *op,
                lhs: Box::new(self.rewrite_expr(lhs)?),
                rhs: Box::new(self.rewrite_expr(rhs)?),
            },
            ExprKind::Unary { op, expr: inner } => ExprKind::Unary {
                op: *op,
                expr: Box::new(self.rewrite_expr(inner)?),
            },
        };
        Ok(Expr { kind, span })
    }

    fn rewrite_clauses(&mut self, clauses: &[CompClause]) -> Result<Vec<CompClause>> {
        let saved_bound = self.bound.clone();
        let mut out = Vec::with_capacity(clauses.len());
        let mut added: Vec<(String, Option<Type>)> = Vec::new();
        for c in clauses {
            let iter = self.rewrite_expr(&c.iter)?;
            if c.vars.len() == 1 {
                if let Some(t) = self.infer_iter_elem(&iter) {
                    added.push((c.vars[0].clone(), self.env_types.insert(c.vars[0].clone(), t)));
                }
            }
            let mut conds = Vec::with_capacity(c.conds.len());
            for cond in &c.conds {
                conds.push(self.rewrite_expr(cond)?);
            }
            out.push(CompClause {
                vars: c.vars.clone(),
                iter,
                conds,
                span: c.span,
            });
        }
        for (v, prev) in added.into_iter().rev() {
            restore_env(&mut self.env_types, &v, prev);
        }
        self.bound = saved_bound;
        Ok(out)
    }
}

fn restore_env(env: &mut HashMap<String, Type>, name: &str, prev: Option<Type>) {
    match prev {
        Some(t) => {
            env.insert(name.to_string(), t);
        }
        None => {
            env.remove(name);
        }
    }
}

struct Rewritten {
    structs: Vec<StructDef>,
    enums: Vec<EnumDef>,
    funcs: Vec<Func>,
}

// ---------------------------------------------------------------------------
// Type substitution
// ---------------------------------------------------------------------------

/// Clones a `Func`, applying `subst` to its signature and renaming it.
fn subst_func(f: &Func, new_name: &str, subst: &HashMap<String, Type>) -> Func {
    Func {
        name: new_name.to_string(),
        type_params: Vec::new(),
        params: f
            .params
            .iter()
            .map(|p| Param {
                name: p.name.clone(),
                ty: subst_ty(&p.ty, subst),
            })
            .collect(),
        ret: f.ret.as_ref().map(|t| subst_ty(t, subst)),
        body: f.body.clone(),
        span: f.span,
    }
}

/// Deep type substitution for PEP 695 type parameters.
pub(super) fn subst_ty(ty: &Type, subst: &HashMap<String, Type>) -> Type {
    match ty {
        // A bare identifier naming a type parameter parses as `Struct`, so both cases are
        // substituted here.
        Type::Struct(name) => match subst.get(name) {
            Some(t) => t.clone(),
            None => ty.clone(),
        },
        Type::Array(inner) => Type::Array(Box::new(subst_ty(inner, subst))),
        Type::Optional(inner) => Type::Optional(Box::new(subst_ty(inner, subst))),
        Type::Tuple(items) => Type::Tuple(items.iter().map(|t| subst_ty(t, subst)).collect()),
        Type::Dict(k, v) => Type::Dict(Box::new(subst_ty(k, subst)), Box::new(subst_ty(v, subst))),
        Type::Set(inner) => Type::Set(Box::new(subst_ty(inner, subst))),
        Type::GenericInst { name, args } => {
            if let Some(t) = subst.get(name) {
                return t.clone();
            }
            Type::GenericInst {
                name: name.clone(),
                args: args.iter().map(|a| subst_ty(a, subst)).collect(),
            }
        }
        other => other.clone(),
    }
}

// ---------------------------------------------------------------------------
// Small local inference helpers
// ---------------------------------------------------------------------------

fn free_vars_of(expr: &Expr) -> Vec<String> {
    let mut out = Vec::new();
    collect_free(expr, &mut out);
    out
}

fn collect_free(expr: &Expr, out: &mut Vec<String>) {
    match &expr.kind {
        ExprKind::CompareChain(operands) => {
            for (e, _) in operands {
                collect_free(e, out);
            }
        }
        ExprKind::PercentFormat { args, .. } => collect_free(args, out),
        ExprKind::Var(n) => {
            if !out.contains(n) {
                out.push(n.clone());
            }
        }
        ExprKind::FString(ps) => {
            for p in ps {
                if let FStrPart::Expr(e) = p {
                    collect_free(e, out);
                }
            }
        }
        ExprKind::ArrayLit(es) | ExprKind::SetLit(es) | ExprKind::TupleLit(es) => {
            for e in es {
                collect_free(e, out);
            }
        }
        ExprKind::DictLit(ps) => {
            for (k, v) in ps {
                collect_free(k, out);
                collect_free(v, out);
            }
        }
        ExprKind::ArrayRepeat { value, count } => {
            collect_free(value, out);
            collect_free(count, out);
        }
        ExprKind::ListComp { elt, clauses }
        | ExprKind::SetComp { elt, clauses }
        | ExprKind::GenExpr { elt, clauses } => {
            collect_comp_free(elt, clauses, out);
        }
        ExprKind::DictComp { key, val, clauses } => {
            collect_comp_free(key, clauses, out);
            collect_comp_free(val, clauses, out);
        }
        ExprKind::Lambda { params, body } => {
            let mut inner = Vec::new();
            collect_free(body, &mut inner);
            for v in inner {
                if !params.iter().any(|p| p.name == v) && !out.contains(&v) {
                    out.push(v);
                }
            }
        }
        ExprKind::Index { target, index } => {
            collect_free(target, out);
            collect_free(index, out);
        }
        ExprKind::Slice {
            target,
            start,
            stop,
            step,
        } => {
            collect_free(target, out);
            for e in [start, stop, step].into_iter().flatten() {
                collect_free(e, out);
            }
        }
        ExprKind::Field { target, .. } => collect_free(target, out),
        ExprKind::MethodCall { target, args, .. } => {
            collect_free(target, out);
            for a in args {
                collect_free(a, out);
            }
        }
        ExprKind::MethodCallKw {
            target,
            pos_args,
            kw_args,
            ..
        } => {
            collect_free(target, out);
            for a in pos_args {
                collect_free(a, out);
            }
            for (_, v, _) in kw_args {
                collect_free(v, out);
            }
        }
        ExprKind::Call { args, .. } => {
            for a in args {
                collect_free(a, out);
            }
        }
        ExprKind::CallKw {
            pos_args, kw_args, ..
        } => {
            for a in pos_args {
                collect_free(a, out);
            }
            for (_, v, _) in kw_args {
                collect_free(v, out);
            }
        }
        ExprKind::CallGeneric {
            pos_args, kw_args, ..
        } => {
            for a in pos_args {
                collect_free(a, out);
            }
            for (_, v, _) in kw_args {
                collect_free(v, out);
            }
        }
        ExprKind::CallExpr { callee, args } => {
            collect_free(callee, out);
            for a in args {
                collect_free(a, out);
            }
        }
        ExprKind::IfExpr {
            then_expr,
            cond,
            else_expr,
        } => {
            collect_free(then_expr, out);
            collect_free(cond, out);
            collect_free(else_expr, out);
        }
        ExprKind::Binary { lhs, rhs, .. } => {
            collect_free(lhs, out);
            collect_free(rhs, out);
        }
        ExprKind::Unary { expr, .. } => collect_free(expr, out),
        ExprKind::Int(_)
        | ExprKind::Float(_)
        | ExprKind::Bool(_)
        | ExprKind::NoneLit
        | ExprKind::Str(_) => {}
    }
}

fn collect_comp_free(elt: &Expr, clauses: &[CompClause], out: &mut Vec<String>) {
    let mut bound = Vec::new();
    for c in clauses {
        collect_free(&c.iter, out);
        for cond in &c.conds {
            collect_free(cond, out);
        }
        bound.extend(c.vars.iter().cloned());
    }
    let mut inner = Vec::new();
    collect_free(elt, &mut inner);
    for v in inner {
        if !bound.contains(&v) && !out.contains(&v) {
            out.push(v);
        }
    }
}

/// Infers a lambda parameter type from its use inside the body.
fn infer_param_ty(name: &str, body: &Expr, env: &HashMap<String, Type>) -> Option<Type> {
    match &body.kind {
        ExprKind::Binary { lhs, rhs, .. } => {
            if matches!(&lhs.kind, ExprKind::Var(v) if v == name) {
                return infer_expr_ty(rhs, env);
            }
            if matches!(&rhs.kind, ExprKind::Var(v) if v == name) {
                return infer_expr_ty(lhs, env);
            }
            None
        }
        ExprKind::MethodCall { target, .. } | ExprKind::Field { target, .. } => {
            if matches!(&target.kind, ExprKind::Var(v) if v == name) {
                return Some(Type::Str);
            }
            None
        }
        ExprKind::Index { target, index } => {
            if matches!(&target.kind, ExprKind::Var(v) if v == name) {
                return infer_expr_ty(index, env).map(|t| Type::Array(Box::new(t)));
            }
            None
        }
        ExprKind::Unary { expr, .. } => infer_param_ty(name, expr, env),
        ExprKind::IfExpr {
            then_expr,
            cond,
            else_expr,
        } => infer_param_ty(name, then_expr, env)
            .or_else(|| infer_param_ty(name, cond, env))
            .or_else(|| infer_param_ty(name, else_expr, env)),
        _ => None,
    }
}

/// Conservative local expression type inference for closure return types.
fn infer_expr_ty(expr: &Expr, env: &HashMap<String, Type>) -> Option<Type> {
    match &expr.kind {
        ExprKind::Int(_) => Some(Type::Int),
        ExprKind::Float(_) => Some(Type::Float),
        ExprKind::Bool(_) => Some(Type::Bool),
        ExprKind::Str(_) | ExprKind::FString(_) => Some(Type::Str),
        ExprKind::TupleLit(es) => Some(Type::Tuple(
            es.iter()
                .map(|e| infer_expr_ty(e, env).unwrap_or(Type::Int))
                .collect(),
        )),
        ExprKind::Var(n) => env.get(n).cloned(),
        ExprKind::ArrayLit(es) => {
            // Homogeneous literals pin the element type; mixed ones are the adaptive `any` case.
            let mut elem: Option<Type> = None;
            for e in es {
                let t = infer_expr_ty(e, env)?;
                match &elem {
                    None => elem = Some(t),
                    Some(prev) if *prev == t => {}
                    Some(_) => return None,
                }
            }
            elem.map(|t| Type::Array(Box::new(t)))
        }
        ExprKind::SetLit(es) => {
            let first = es.first()?;
            let t = infer_expr_ty(first, env)?;
            if es.iter().all(|e| infer_expr_ty(e, env).as_ref() == Some(&t)) {
                Some(Type::Set(Box::new(t)))
            } else {
                None
            }
        }
        ExprKind::DictLit(ps) => {
            let (k0, v0) = ps.first()?;
            let kt = infer_expr_ty(k0, env)?;
            let vt = infer_expr_ty(v0, env)?;
            let same = ps.iter().all(|(k, v)| {
                infer_expr_ty(k, env).as_ref() == Some(&kt)
                    && infer_expr_ty(v, env).as_ref() == Some(&vt)
            });
            if same {
                Some(Type::Dict(Box::new(kt), Box::new(vt)))
            } else {
                None
            }
        }
        ExprKind::ArrayRepeat { value, .. } => {
            Some(Type::Array(Box::new(infer_expr_ty(value, env)?)))
        }
        ExprKind::Unary { op, expr } => {
            if *op == UnOp::Not {
                Some(Type::Bool)
            } else {
                infer_expr_ty(expr, env)
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
                let l = infer_expr_ty(lhs, env);
                let r = infer_expr_ty(rhs, env);
                match (l, r) {
                    (Some(a), Some(b)) if a == b => Some(a),
                    (Some(Type::Float), _) | (_, Some(Type::Float)) => Some(Type::Float),
                    (Some(Type::Int), Some(Type::Int)) => Some(Type::Int),
                    _ => None,
                }
            }
        },
        ExprKind::IfExpr {
            then_expr,
            else_expr,
            ..
        } => match (infer_expr_ty(then_expr, env), infer_expr_ty(else_expr, env)) {
            (Some(a), Some(b)) if a == b => Some(a),
            (Some(Type::Float), _) | (_, Some(Type::Float)) => Some(Type::Float),
            _ => None,
        },
        ExprKind::Call { name, .. } => match name.as_str() {
            "len" | "int" | "ord" => Some(Type::Int),
            "str" | "input" | "chr" => Some(Type::Str),
            "float" | "sqrt" => Some(Type::Float),
            "bool" => Some(Type::Bool),
            _ => None,
        },
        ExprKind::MethodCall { method, .. } => match method.as_str() {
            "upper" | "lower" | "strip" | "replace" | "join" => Some(Type::Str),
            "startswith" | "endswith" | "isdigit" | "isalpha" | "isspace" => Some(Type::Bool),
            "find" | "count" | "index" => Some(Type::Int),
            "split" => Some(Type::Array(Box::new(Type::Str))),
            _ => None,
        },
        _ => None,
    }
}

/// `key=` lambdas are inlined by `sort.rs`, so generics rewriting leaves them alone.
fn is_sort_key_lambda(expr: &Expr) -> bool {
    matches!(expr.kind, ExprKind::Lambda { .. })
}

/// Unifies a declared parameter type (`list[T]`, `T`, `dict[str, T]`, ...) against a displayed
/// argument type, recording each type parameter's binding.
fn unify_param(
    declared: &Type,
    actual: &Type,
    type_params: &[String],
    found: &mut [Option<Type>],
) {
    let bind = |name: &str, ty: &Type, found: &mut [Option<Type>]| {
        if let Some(slot) = type_params.iter().position(|p| p == name) {
            if found[slot].is_none() {
                found[slot] = Some(ty.clone());
            }
        }
    };
    match (declared, actual) {
        (Type::Struct(n), _) => bind(n, actual, found),
        (Type::GenericInst { name, args }, Type::GenericInst { args: act, .. }) => {
            bind(name, actual, found);
            for (d, a) in args.iter().zip(act.iter()) {
                unify_param(d, a, type_params, found);
            }
        }
        (Type::Array(d), Type::Array(a)) => unify_param(d, a, type_params, found),
        (Type::Set(d), Type::Set(a)) => unify_param(d, a, type_params, found),
        (Type::Optional(d), Type::Optional(a)) => unify_param(d, a, type_params, found),
        (Type::Dict(dk, dv), Type::Dict(ak, av)) => {
            unify_param(dk, ak, type_params, found);
            unify_param(dv, av, type_params, found);
        }
        (Type::Tuple(ds), Type::Tuple(as_)) => {
            for (d, a) in ds.iter().zip(as_.iter()) {
                unify_param(d, a, type_params, found);
            }
        }
        // A bare container annotation `list[T]` may also arrive as `Type::Array` on one side.
        (Type::Array(d), Type::GenericInst { name, args }) if name == "list" && args.len() == 1 => {
            unify_param(d, &args[0], type_params, found)
        }
        _ => {}
    }
}
