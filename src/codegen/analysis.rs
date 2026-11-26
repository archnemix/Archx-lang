//! Pure AST static analyses: SoA escape detection, monotonic `while` stride verification,
//! Pythonic first-binding vs mutation/return variable collection, adaptive dual-mode type
//! specialization (`Tier 1` static native vs `Tier 2` `%ArchxAny`), and integer constant folding.

use std::collections::{HashMap, HashSet};

use crate::ast::*;

use super::*;

#[derive(Default, Clone)]
pub(super) struct AdaptiveHints {
    /// Variables reassigned to incompatible types across their lifetime (`name = "a"; name = 18`)
    /// or initialized to `None` -> automatically lowered to `%ArchxAny`.
    pub(super) dynamic_vars: HashSet<String>,
    /// Unannotated empty containers (`xs = []`, `d = {}`, `s = set()`) specialized to Tier-1
    /// unboxed native containers whenever all observed operations are type-consistent.
    pub(super) specialized_containers: HashMap<String, Type>,
}

pub(super) fn root_var_of_expr(expr: &Expr) -> Option<&str> {
    match &expr.kind {
        ExprKind::Var(name) => Some(name),
        ExprKind::Index { target, .. } | ExprKind::Field { target, .. } => root_var_of_expr(target),
        _ => None,
    }
}

pub(super) fn var_escapes_soa(
    stmts: &[Stmt],
    var: &str,
    mutating_methods: &HashSet<String>,
) -> bool {
    for s in stmts {
        if stmt_escapes_soa(s, var, mutating_methods) {
            return true;
        }
    }
    false
}

pub(super) fn stmt_escapes_soa(
    stmt: &Stmt,
    var: &str,
    mutating_methods: &HashSet<String>,
) -> bool {
    match &stmt.kind {
        StmtKind::ForElse { body, else_body } => body
            .iter()
            .chain(else_body.iter())
            .any(|s| stmt_escapes_soa(s, var, mutating_methods)),
        StmtKind::Let { value, .. } => expr_escapes_soa(value, var, mutating_methods),
        StmtKind::Assign { target, value, .. } => {
            match target {
                AssignTarget::Var(n) if n == var => return true,
                AssignTarget::Index { target: t, index } => {
                    if !matches!(&t.kind, ExprKind::Var(n) if n == var)
                        && expr_escapes_soa(t, var, mutating_methods)
                    {
                        return true;
                    }
                    if expr_escapes_soa(index, var, mutating_methods) {
                        return true;
                    }
                }
                AssignTarget::Field { target: t, .. } => {
                    if let ExprKind::Index {
                        target: arr,
                        index: idx,
                    } = &t.kind
                    {
                        if !matches!(&arr.kind, ExprKind::Var(n) if n == var)
                            && expr_escapes_soa(arr, var, mutating_methods)
                        {
                            return true;
                        }
                        if expr_escapes_soa(idx, var, mutating_methods) {
                            return true;
                        }
                    } else if expr_escapes_soa(t, var, mutating_methods) {
                        return true;
                    }
                }
                _ => {}
            }
            expr_escapes_soa(value, var, mutating_methods)
        }
        StmtKind::Expr(e) | StmtKind::Return(Some(e)) => expr_escapes_soa(e, var, mutating_methods),
        StmtKind::Assert { cond, msg } => {
            expr_escapes_soa(cond, var, mutating_methods)
                || msg
                    .as_ref()
                    .map_or(false, |m| expr_escapes_soa(m, var, mutating_methods))
        }
        // `del x` frees the value and `global x` only names a module constant; neither lets SoA
        // planes escape.
        StmtKind::Del { .. } | StmtKind::Global { .. } => false,
        StmtKind::Return(None) | StmtKind::Pass | StmtKind::Break | StmtKind::Continue => false,
        StmtKind::If {
            cond,
            then_body,
            else_body,
        } => {
            expr_escapes_soa(cond, var, mutating_methods)
                || var_escapes_soa(then_body, var, mutating_methods)
                || else_body
                    .as_ref()
                    .map_or(false, |b| var_escapes_soa(b, var, mutating_methods))
        }
        StmtKind::While { cond, body } => {
            expr_escapes_soa(cond, var, mutating_methods)
                || var_escapes_soa(body, var, mutating_methods)
        }
        StmtKind::For {
            start,
            end,
            step,
            body,
            else_body,
            ..
        } => {
            expr_escapes_soa(start, var, mutating_methods)
                || expr_escapes_soa(end, var, mutating_methods)
                || step
                    .as_ref()
                    .map_or(false, |se| expr_escapes_soa(se, var, mutating_methods))
                || var_escapes_soa(body, var, mutating_methods)
                || else_body
                    .as_ref()
                    .map_or(false, |b| var_escapes_soa(b, var, mutating_methods))
        }
        StmtKind::ForEach {
            iter,
            body,
            else_body,
            ..
        } => {
            let direct = matches!(&iter.kind, ExprKind::Var(n) if n == var);
            (!direct && expr_escapes_soa(iter, var, mutating_methods))
                || var_escapes_soa(body, var, mutating_methods)
                || else_body
                    .as_ref()
                    .map_or(false, |b| var_escapes_soa(b, var, mutating_methods))
        }
        StmtKind::ForEnumerate {
            iter, start, body, ..
        } => {
            let direct = matches!(&iter.kind, ExprKind::Var(n) if n == var);
            (!direct && expr_escapes_soa(iter, var, mutating_methods))
                || start
                    .as_ref()
                    .map_or(false, |st| expr_escapes_soa(st, var, mutating_methods))
                || var_escapes_soa(body, var, mutating_methods)
        }
        StmtKind::ForDictItems { dict, body, .. } => {
            expr_escapes_soa(dict, var, mutating_methods)
                || var_escapes_soa(body, var, mutating_methods)
        }
        StmtKind::TupleAssign { targets, value } => {
            targets.iter().any(|t| t == var) || expr_escapes_soa(value, var, mutating_methods)
        }
        StmtKind::Match { subject, cases } => {
            expr_escapes_soa(subject, var, mutating_methods)
                || cases.iter().any(|c| {
                    c.guard
                        .as_ref()
                        .map_or(false, |g| expr_escapes_soa(g, var, mutating_methods))
                        || var_escapes_soa(&c.body, var, mutating_methods)
                })
        }
        StmtKind::ForZip { iters, body, .. } => {
            iters
                .iter()
                .any(|i| expr_escapes_soa(i, var, mutating_methods))
                || var_escapes_soa(body, var, mutating_methods)
        }
        StmtKind::ForTupleUnpack { iter, body, .. } => {
            let direct = matches!(&iter.kind, ExprKind::Var(n) if n == var);
            (!direct && expr_escapes_soa(iter, var, mutating_methods))
                || var_escapes_soa(body, var, mutating_methods)
        }
        StmtKind::Region { body } => var_escapes_soa(body, var, mutating_methods),
    }
}

pub(super) fn expr_escapes_soa(
    expr: &Expr,
    var: &str,
    mutating_methods: &HashSet<String>,
) -> bool {
    match &expr.kind {
        ExprKind::Var(n) => n == var,
        ExprKind::CompareChain(operands) => operands
            .iter()
            .any(|(e, _)| expr_escapes_soa(e, var, mutating_methods)),
        ExprKind::PercentFormat { args, .. } => expr_escapes_soa(args, var, mutating_methods),
        ExprKind::Index { target, index } => {
            let direct = matches!(&target.kind, ExprKind::Var(n) if n == var);
            (!direct && expr_escapes_soa(target, var, mutating_methods))
                || expr_escapes_soa(index, var, mutating_methods)
        }
        ExprKind::Slice {
            target,
            start,
            stop,
            step,
        } => {
            expr_escapes_soa(target, var, mutating_methods)
                || start
                    .as_ref()
                    .map_or(false, |e| expr_escapes_soa(e, var, mutating_methods))
                || stop
                    .as_ref()
                    .map_or(false, |e| expr_escapes_soa(e, var, mutating_methods))
                || step
                    .as_ref()
                    .map_or(false, |e| expr_escapes_soa(e, var, mutating_methods))
        }
        ExprKind::Field { target, .. } => expr_escapes_soa(target, var, mutating_methods),
        ExprKind::MethodCall {
            target,
            method,
            args,
        } => {
            if matches!(&target.kind, ExprKind::Index { target: arr, .. } if matches!(&arr.kind, ExprKind::Var(n) if n == var))
                && mutating_methods.contains(method)
            {
                return true;
            }
            expr_escapes_soa(target, var, mutating_methods)
                || args
                    .iter()
                    .any(|a| expr_escapes_soa(a, var, mutating_methods))
        }
        ExprKind::Call { name, args } => {
            if name == "len"
                && args.len() == 1
                && matches!(&args[0].kind, ExprKind::Var(n) if n == var)
            {
                return false;
            }
            args.iter()
                .any(|a| expr_escapes_soa(a, var, mutating_methods))
        }
        ExprKind::CallKw {
            pos_args, kw_args, ..
        } => {
            pos_args
                .iter()
                .any(|a| expr_escapes_soa(a, var, mutating_methods))
                || kw_args
                    .iter()
                    .any(|(_, v, _)| expr_escapes_soa(v, var, mutating_methods))
        }
        ExprKind::FString(parts) => parts.iter().any(|p| match p {
            FStrPart::Lit(_) => false,
            FStrPart::Expr(e) | FStrPart::Spec { expr: e, .. } => {
                expr_escapes_soa(e, var, mutating_methods)
            }
        }),
        ExprKind::IfExpr {
            then_expr,
            cond,
            else_expr,
        } => {
            expr_escapes_soa(then_expr, var, mutating_methods)
                || expr_escapes_soa(cond, var, mutating_methods)
                || expr_escapes_soa(else_expr, var, mutating_methods)
        }
        ExprKind::Unary { expr: inner, .. } => expr_escapes_soa(inner, var, mutating_methods),
        ExprKind::Binary { lhs, rhs, .. } => {
            expr_escapes_soa(lhs, var, mutating_methods)
                || expr_escapes_soa(rhs, var, mutating_methods)
        }
        ExprKind::ArrayLit(es) | ExprKind::SetLit(es) | ExprKind::TupleLit(es) => es
            .iter()
            .any(|e| expr_escapes_soa(e, var, mutating_methods)),
        ExprKind::DictLit(pairs) => pairs.iter().any(|(k, v)| {
            expr_escapes_soa(k, var, mutating_methods)
                || expr_escapes_soa(v, var, mutating_methods)
        }),
        ExprKind::ArrayRepeat { value, count } => {
            expr_escapes_soa(value, var, mutating_methods)
                || expr_escapes_soa(count, var, mutating_methods)
        }
        ExprKind::ListComp { elt, clauses } => {
            expr_escapes_soa(elt, var, mutating_methods)
                || clauses
                    .iter()
                    .any(|c| comp_clause_escapes_soa(c, var, mutating_methods))
        }
        ExprKind::SetComp { elt, clauses } | ExprKind::GenExpr { elt, clauses } => {
            expr_escapes_soa(elt, var, mutating_methods)
                || clauses
                    .iter()
                    .any(|c| comp_clause_escapes_soa(c, var, mutating_methods))
        }
        ExprKind::DictComp { key, val, clauses } => {
            expr_escapes_soa(key, var, mutating_methods)
                || expr_escapes_soa(val, var, mutating_methods)
                || clauses
                    .iter()
                    .any(|c| comp_clause_escapes_soa(c, var, mutating_methods))
        }
        ExprKind::Lambda { params, body } => {
            if params.iter().any(|p| p.name == var) {
                return false;
            }
            expr_escapes_soa(body, var, mutating_methods)
        }
        ExprKind::MethodCallKw {
            target,
            pos_args,
            kw_args,
            ..
        } => {
            expr_escapes_soa(target, var, mutating_methods)
                || pos_args
                    .iter()
                    .any(|a| expr_escapes_soa(a, var, mutating_methods))
                || kw_args
                    .iter()
                    .any(|(_, v, _)| expr_escapes_soa(v, var, mutating_methods))
        }
        ExprKind::CallGeneric {
            pos_args, kw_args, ..
        } => {
            pos_args
                .iter()
                .any(|a| expr_escapes_soa(a, var, mutating_methods))
                || kw_args
                    .iter()
                    .any(|(_, v, _)| expr_escapes_soa(v, var, mutating_methods))
        }
        ExprKind::CallExpr { callee, args } => {
            expr_escapes_soa(callee, var, mutating_methods)
                || args
                    .iter()
                    .any(|a| expr_escapes_soa(a, var, mutating_methods))
        }
        ExprKind::Int(_)
        | ExprKind::Float(_)
        | ExprKind::Bool(_)
        | ExprKind::NoneLit
        | ExprKind::Str(_) => false,
    }
}

pub(super) fn comp_clause_escapes_soa(
    clause: &CompClause,
    var: &str,
    mutating_methods: &HashSet<String>,
) -> bool {
    let shadows = clause.vars.iter().any(|v| v == var);
    expr_escapes_soa(&clause.iter, var, mutating_methods)
        || (!shadows
            && clause
                .conds
                .iter()
                .any(|c| expr_escapes_soa(c, var, mutating_methods)))
}

pub(super) fn check_only_monotone_step(
    stmts: &[Stmt],
    idx: &str,
    full_body: &[Stmt],
    stride_out: &mut Option<StrideVal>,
    cg: &Codegen,
) -> bool {
    for s in stmts {
        match &s.kind {
            StmtKind::Assign { target, op, value } => {
                if let AssignTarget::Var(name) = target {
                    if name == idx {
                        let add_rhs = match op {
                            Some(BinOp::Add) => Some(value),
                            None => match &value.kind {
                                ExprKind::Binary {
                                    op: BinOp::Add,
                                    lhs,
                                    rhs,
                                } => {
                                    if matches!(&lhs.kind, ExprKind::Var(v) if v == idx) {
                                        Some(rhs.as_ref())
                                    } else if matches!(&rhs.kind, ExprKind::Var(v) if v == idx) {
                                        Some(lhs.as_ref())
                                    } else {
                                        None
                                    }
                                }
                                _ => None,
                            },
                            _ => None,
                        };
                        let Some(step_expr) = add_rhs else {
                            return false;
                        };
                        let this_stride = if let Some(c) = eval_const_int(step_expr) {
                            if c <= 0 || c > MAX_ARRAY_LEN {
                                return false;
                            }
                            StrideVal::Const
                        } else if let ExprKind::Var(sname) = &step_expr.kind {
                            if sname == idx || stmts_assign_var(full_body, sname) {
                                return false;
                            }
                            let Some(s_entry) = cg.lookup_var(sname) else {
                                return false;
                            };
                            if s_entry.ty != Type::Int {
                                return false;
                            }
                            StrideVal::Var(sname.clone())
                        } else {
                            return false;
                        };

                        match stride_out {
                            None => *stride_out = Some(this_stride),
                            Some(prev) => match (&prev, &this_stride) {
                                (StrideVal::Const, StrideVal::Const) => {}
                                (StrideVal::Var(a), StrideVal::Var(b)) if a == b => {}
                                _ => return false,
                            },
                        }
                    }
                }
            }
            StmtKind::If {
                then_body,
                else_body,
                ..
            } => {
                if !check_only_monotone_step(then_body, idx, full_body, stride_out, cg) {
                    return false;
                }
                if let Some(eb) = else_body {
                    if !check_only_monotone_step(eb, idx, full_body, stride_out, cg) {
                        return false;
                    }
                }
            }
            StmtKind::Region { body } => {
                if !check_only_monotone_step(body, idx, full_body, stride_out, cg) {
                    return false;
                }
            }
            StmtKind::TupleAssign { targets, .. } if targets.iter().any(|t| t == idx) => {
                return false;
            }
            StmtKind::Match { cases, .. } => {
                for c in cases {
                    if !check_only_monotone_step(&c.body, idx, full_body, stride_out, cg) {
                        return false;
                    }
                }
            }
            StmtKind::While { .. }
            | StmtKind::For { .. }
            | StmtKind::ForEach { .. }
            | StmtKind::ForEnumerate { .. }
            | StmtKind::ForDictItems { .. } => {
                return false;
            }
            _ => {}
        }
    }
    true
}

pub(super) fn stmts_use_region(stmts: &[Stmt]) -> bool {
    stmts.iter().any(|s| match &s.kind {
        StmtKind::Region { .. } => true,
        StmtKind::If {
            then_body,
            else_body,
            ..
        } => {
            stmts_use_region(then_body)
                || else_body.as_ref().map_or(false, |b| stmts_use_region(b))
        }
        StmtKind::While { body, .. }
        | StmtKind::For { body, .. }
        | StmtKind::ForEach { body, .. }
        | StmtKind::ForEnumerate { body, .. }
        | StmtKind::ForDictItems { body, .. } => stmts_use_region(body),
        StmtKind::Match { cases, .. } => cases.iter().any(|c| stmts_use_region(&c.body)),
        _ => false,
    })
}

pub(super) fn stmts_contain_loop(stmts: &[Stmt]) -> bool {
    stmts.iter().any(|s| match &s.kind {
        StmtKind::While { .. }
        | StmtKind::For { .. }
        | StmtKind::ForEach { .. }
        | StmtKind::ForEnumerate { .. }
        | StmtKind::ForDictItems { .. } => true,
        StmtKind::If {
            then_body,
            else_body,
            ..
        } => {
            stmts_contain_loop(then_body)
                || else_body.as_ref().map_or(false, |b| stmts_contain_loop(b))
        }
        StmtKind::Match { cases, .. } => cases.iter().any(|c| stmts_contain_loop(&c.body)),
        StmtKind::Region { body } => stmts_contain_loop(body),
        _ => false,
    })
}

pub(super) fn method_mutates_self(params: &[Param], stmts: &[Stmt]) -> bool {
    let base: HashSet<String> = ["append", "pop", "clear", "add", "remove", "discard"]
        .into_iter()
        .map(String::from)
        .collect();
    collect_mutated_vars(params, stmts, &base).contains("self")
}

pub(super) fn collect_mutated_vars(
    params: &[Param],
    stmts: &[Stmt],
    mutating_methods: &HashSet<String>,
) -> HashSet<String> {
    let mut bound: HashSet<String> = params.iter().map(|p| p.name.clone()).collect();
    let mut mutated = HashSet::new();
    walk_mutations(stmts, &mut bound, &mut mutated, mutating_methods);
    mutated
}

pub(super) fn collect_returned_vars(stmts: &[Stmt]) -> HashSet<String> {
    let mut set = HashSet::new();
    walk_returns(stmts, &mut set);
    set
}

pub(super) fn walk_returns(stmts: &[Stmt], set: &mut HashSet<String>) {
    for stmt in stmts {
        match &stmt.kind {
            StmtKind::Return(Some(expr)) => {
                if let ExprKind::Var(name) = &expr.kind {
                    set.insert(name.clone());
                }
            }
            StmtKind::If {
                then_body,
                else_body,
                ..
            } => {
                walk_returns(then_body, set);
                if let Some(eb) = else_body {
                    walk_returns(eb, set);
                }
            }
            StmtKind::While { body, .. }
            | StmtKind::For { body, .. }
            | StmtKind::ForEach { body, .. }
            | StmtKind::ForEnumerate { body, .. }
            | StmtKind::ForDictItems { body, .. }
            | StmtKind::Region { body } => walk_returns(body, set),
            StmtKind::Match { cases, .. } => {
                for c in cases {
                    walk_returns(&c.body, set);
                }
            }
            _ => {}
        }
    }
}

pub(super) fn collect_pattern_binds(pat: &Pattern, out: &mut Vec<String>) {
    match pat {
        Pattern::Bind(name, _) => out.push(name.clone()),
        Pattern::Tuple(ps, _)
        | Pattern::Or(ps, _)
        | Pattern::EnumVariant { args: ps, .. } => {
            for p in ps {
                collect_pattern_binds(p, out);
            }
        }
        _ => {}
    }
}

pub(super) fn walk_mutations(
    stmts: &[Stmt],
    bound: &mut HashSet<String>,
    mutated: &mut HashSet<String>,
    mutating_methods: &HashSet<String>,
) {
    for stmt in stmts {
        match &stmt.kind {
            StmtKind::Let { name, value, .. } => {
                walk_expr_mutations(value, mutated, mutating_methods);
                bound.insert(name.clone());
            }
            StmtKind::ForElse { body, else_body } => {
                walk_mutations(body, bound, mutated, mutating_methods);
                walk_mutations(else_body, bound, mutated, mutating_methods);
            }
            StmtKind::Assign { target, op, value } => {
                walk_expr_mutations(value, mutated, mutating_methods);
                match target {
                    AssignTarget::Var(name) => {
                        if op.is_some() || bound.contains(name) {
                            mutated.insert(name.clone());
                        } else {
                            bound.insert(name.clone());
                        }
                    }
                    AssignTarget::Field { target: base, .. } => {
                        if let Some(root) = root_var_of_expr(base) {
                            if matches!(&base.kind, ExprKind::Var(_)) {
                                mutated.insert(root.to_string());
                            }
                        }
                        walk_expr_mutations(base, mutated, mutating_methods);
                    }
                    AssignTarget::Index { target: t, index } => {
                        walk_expr_mutations(t, mutated, mutating_methods);
                        walk_expr_mutations(index, mutated, mutating_methods);
                    }
                }
            }
            StmtKind::Expr(e) | StmtKind::Return(Some(e)) => {
                walk_expr_mutations(e, mutated, mutating_methods);
            }
            StmtKind::Assert { cond, msg } => {
                walk_expr_mutations(cond, mutated, mutating_methods);
                if let Some(m) = msg {
                    walk_expr_mutations(m, mutated, mutating_methods);
                }
            }
            StmtKind::Del { name } => {
                bound.remove(name);
            }
            // A module-level constant is never a local mutation target.
            StmtKind::Global { .. } => {}
            StmtKind::Return(None) | StmtKind::Pass | StmtKind::Break | StmtKind::Continue => {}
            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                walk_expr_mutations(cond, mutated, mutating_methods);
                let mut then_bound = bound.clone();
                walk_mutations(then_body, &mut then_bound, mutated, mutating_methods);
                if let Some(eb) = else_body {
                    let mut else_bound = bound.clone();
                    walk_mutations(eb, &mut else_bound, mutated, mutating_methods);
                }
            }
            StmtKind::While { cond, body } => {
                walk_expr_mutations(cond, mutated, mutating_methods);
                let mut inner = bound.clone();
                walk_mutations(body, &mut inner, mutated, mutating_methods);
            }
            StmtKind::For {
                var,
                start,
                end,
                step,
                body,
                else_body,
            } => {
                mutated.insert(var.clone());
                walk_expr_mutations(start, mutated, mutating_methods);
                walk_expr_mutations(end, mutated, mutating_methods);
                if let Some(se) = step {
                    walk_expr_mutations(se, mutated, mutating_methods);
                }
                let mut inner = bound.clone();
                inner.insert(var.clone());
                walk_mutations(body, &mut inner, mutated, mutating_methods);
                if let Some(e) = else_body {
                    let mut eb_bound = inner.clone();
                    walk_mutations(e, &mut eb_bound, mutated, mutating_methods);
                }
            }
            StmtKind::ForEach {
                var,
                iter,
                body,
                else_body,
            } => {
                walk_expr_mutations(iter, mutated, mutating_methods);
                let mut inner = bound.clone();
                // Python loop variables leak out of the loop, so keep them bound afterwards.
                if bound.contains(var) {
                    walk_mutations(body, bound, mutated, mutating_methods);
                } else {
                    inner.insert(var.clone());
                    walk_mutations(body, &mut inner, mutated, mutating_methods);
                }
                if let Some(e) = else_body {
                    let mut eb_bound = inner.clone();
                    walk_mutations(e, &mut eb_bound, mutated, mutating_methods);
                }
            }
            StmtKind::ForEnumerate {
                idx_var,
                elem_var,
                iter,
                start,
                body,
            } => {
                walk_expr_mutations(iter, mutated, mutating_methods);
                if let Some(st) = start {
                    walk_expr_mutations(st, mutated, mutating_methods);
                }
                let mut inner = bound.clone();
                inner.insert(idx_var.clone());
                inner.insert(elem_var.clone());
                walk_mutations(body, &mut inner, mutated, mutating_methods);
            }
            StmtKind::ForDictItems {
                key_var,
                val_var,
                dict,
                body,
            } => {
                walk_expr_mutations(dict, mutated, mutating_methods);
                let mut inner = bound.clone();
                inner.insert(key_var.clone());
                inner.insert(val_var.clone());
                walk_mutations(body, &mut inner, mutated, mutating_methods);
            }
            StmtKind::TupleAssign { targets, value } => {
                walk_expr_mutations(value, mutated, mutating_methods);
                for name in targets {
                    if bound.contains(name) {
                        mutated.insert(name.clone());
                    } else {
                        bound.insert(name.clone());
                    }
                }
            }
            StmtKind::Match { subject, cases } => {
                walk_expr_mutations(subject, mutated, mutating_methods);
                for c in cases {
                    let mut inner = bound.clone();
                    let mut pbinds = Vec::new();
                    collect_pattern_binds(&c.pattern, &mut pbinds);
                    for pb in pbinds {
                        inner.insert(pb);
                    }
                    if let Some(g) = &c.guard {
                        walk_expr_mutations(g, mutated, mutating_methods);
                    }
                    walk_mutations(&c.body, &mut inner, mutated, mutating_methods);
                }
            }
            StmtKind::ForZip {
                vars, iters, body, ..
            } => {
                for it in iters {
                    walk_expr_mutations(it, mutated, mutating_methods);
                }
                let mut inner = bound.clone();
                for v in vars {
                    inner.insert(v.clone());
                }
                walk_mutations(body, &mut inner, mutated, mutating_methods);
            }
            StmtKind::ForTupleUnpack { vars, iter, body } => {
                walk_expr_mutations(iter, mutated, mutating_methods);
                let mut inner = bound.clone();
                for v in vars {
                    inner.insert(v.clone());
                }
                walk_mutations(body, &mut inner, mutated, mutating_methods);
            }
            StmtKind::Region { body } => {
                let mut inner = bound.clone();
                walk_mutations(body, &mut inner, mutated, mutating_methods);
            }
        }
    }
}

pub(super) fn walk_expr_mutations(
    expr: &Expr,
    set: &mut HashSet<String>,
    mutating_methods: &HashSet<String>,
) {
    match &expr.kind {
        ExprKind::CompareChain(operands) => {
            for (e, _) in operands {
                walk_expr_mutations(e, set, mutating_methods);
            }
        }
        ExprKind::PercentFormat { args, .. } => walk_expr_mutations(args, set, mutating_methods),
        ExprKind::Call { name, args } => {
            if (name == "push" || name == "pop") && !args.is_empty() {
                if let ExprKind::Var(arr_name) = &args[0].kind {
                    set.insert(arr_name.clone());
                }
            }
            for a in args {
                walk_expr_mutations(a, set, mutating_methods);
            }
        }
        ExprKind::CallKw {
            pos_args, kw_args, ..
        } => {
            for a in pos_args {
                walk_expr_mutations(a, set, mutating_methods);
            }
            for (_, v, _) in kw_args {
                walk_expr_mutations(v, set, mutating_methods);
            }
        }
        ExprKind::MethodCall {
            target,
            method,
            args,
        } => {
            if mutating_methods.contains(method) {
                if let ExprKind::Var(vname) = &target.kind {
                    set.insert(vname.clone());
                }
            }
            walk_expr_mutations(target, set, mutating_methods);
            for a in args {
                walk_expr_mutations(a, set, mutating_methods);
            }
        }
        ExprKind::FString(parts) => {
            for p in parts {
                if let FStrPart::Expr(e) = p {
                    walk_expr_mutations(e, set, mutating_methods);
                }
            }
        }
        ExprKind::IfExpr {
            then_expr,
            cond,
            else_expr,
        } => {
            walk_expr_mutations(then_expr, set, mutating_methods);
            walk_expr_mutations(cond, set, mutating_methods);
            walk_expr_mutations(else_expr, set, mutating_methods);
        }
        ExprKind::Unary { expr: inner, .. } | ExprKind::Field { target: inner, .. } => {
            walk_expr_mutations(inner, set, mutating_methods)
        }
        ExprKind::Binary { lhs, rhs, .. } => {
            walk_expr_mutations(lhs, set, mutating_methods);
            walk_expr_mutations(rhs, set, mutating_methods);
        }
        ExprKind::Index { target, index } => {
            walk_expr_mutations(target, set, mutating_methods);
            walk_expr_mutations(index, set, mutating_methods);
        }
        ExprKind::Slice {
            target,
            start,
            stop,
            step,
        } => {
            walk_expr_mutations(target, set, mutating_methods);
            if let Some(s) = start {
                walk_expr_mutations(s, set, mutating_methods);
            }
            if let Some(e) = stop {
                walk_expr_mutations(e, set, mutating_methods);
            }
            if let Some(st) = step {
                walk_expr_mutations(st, set, mutating_methods);
            }
        }
        ExprKind::ArrayLit(elems) | ExprKind::SetLit(elems) | ExprKind::TupleLit(elems) => {
            for e in elems {
                walk_expr_mutations(e, set, mutating_methods);
            }
        }
        ExprKind::DictLit(pairs) => {
            for (k, v) in pairs {
                walk_expr_mutations(k, set, mutating_methods);
                walk_expr_mutations(v, set, mutating_methods);
            }
        }
        ExprKind::ArrayRepeat { value, count } => {
            walk_expr_mutations(value, set, mutating_methods);
            walk_expr_mutations(count, set, mutating_methods);
        }
        ExprKind::MethodCallKw {
            target,
            method,
            pos_args,
            kw_args,
        } => {
            if mutating_methods.contains(method) {
                if let ExprKind::Var(vname) = &target.kind {
                    set.insert(vname.clone());
                }
            }
            walk_expr_mutations(target, set, mutating_methods);
            for a in pos_args {
                walk_expr_mutations(a, set, mutating_methods);
            }
            for (_, v, _) in kw_args {
                walk_expr_mutations(v, set, mutating_methods);
            }
        }
        ExprKind::CallGeneric {
            pos_args, kw_args, ..
        } => {
            for a in pos_args {
                walk_expr_mutations(a, set, mutating_methods);
            }
            for (_, v, _) in kw_args {
                walk_expr_mutations(v, set, mutating_methods);
            }
        }
        ExprKind::CallExpr { callee, args } => {
            walk_expr_mutations(callee, set, mutating_methods);
            for a in args {
                walk_expr_mutations(a, set, mutating_methods);
            }
        }
        ExprKind::ListComp { elt, clauses }
        | ExprKind::SetComp { elt, clauses }
        | ExprKind::GenExpr { elt, clauses } => {
            walk_expr_mutations(elt, set, mutating_methods);
            walk_comp_clause_mutations(clauses, set, mutating_methods);
        }
        ExprKind::DictComp { key, val, clauses } => {
            walk_expr_mutations(key, set, mutating_methods);
            walk_expr_mutations(val, set, mutating_methods);
            walk_comp_clause_mutations(clauses, set, mutating_methods);
        }
        ExprKind::Lambda { body, .. } => walk_expr_mutations(body, set, mutating_methods),
        ExprKind::Int(_)
        | ExprKind::Float(_)
        | ExprKind::Bool(_)
        | ExprKind::NoneLit
        | ExprKind::Str(_)
        | ExprKind::Var(_) => {}
    }
}

pub(super) fn walk_comp_clause_mutations(
    clauses: &[CompClause],
    set: &mut HashSet<String>,
    mutating_methods: &HashSet<String>,
) {
    for c in clauses {
        walk_expr_mutations(&c.iter, set, mutating_methods);
        for cond in &c.conds {
            walk_expr_mutations(cond, set, mutating_methods);
        }
    }
}

pub(super) fn stmts_assign_var(stmts: &[Stmt], name: &str) -> bool {
    stmts.iter().any(|s| match &s.kind {
        StmtKind::Assign {
            target: AssignTarget::Var(v),
            ..
        } => v == name,
        StmtKind::If {
            then_body,
            else_body,
            ..
        } => {
            stmts_assign_var(then_body, name)
                || else_body.as_ref().map_or(false, |b| stmts_assign_var(b, name))
        }
        StmtKind::While { body, .. }
        | StmtKind::For { body, .. }
        | StmtKind::ForEach { body, .. }
        | StmtKind::ForEnumerate { body, .. }
        | StmtKind::ForDictItems { body, .. }
        | StmtKind::ForZip { body, .. }
        | StmtKind::ForTupleUnpack { body, .. }
        | StmtKind::Region { body } => stmts_assign_var(body, name),
        StmtKind::TupleAssign { targets, .. } => targets.iter().any(|t| t == name),
        StmtKind::Match { cases, .. } => cases.iter().any(|c| stmts_assign_var(&c.body, name)),
        _ => false,
    })
}

pub(super) fn stmts_mutate_array_len(
    stmts: &[Stmt],
    arr_name: &str,
    mutating_methods: &HashSet<String>,
) -> bool {
    let mut bound = HashSet::new();
    bound.insert(arr_name.to_string());
    let mut mutated = HashSet::new();
    walk_mutations(stmts, &mut bound, &mut mutated, mutating_methods);
    mutated.contains(arr_name)
}

// ---------------- Adaptive Tiered Type Specialization ------------------------

pub(super) fn compute_adaptive_hints(
    params: &[Param],
    stmts: &[Stmt],
    structs: &HashMap<String, Vec<Param>>,
    enums: &HashMap<String, EnumInfo>,
    sigs: &HashMap<String, FuncSig>,
) -> AdaptiveHints {
    let mut env: HashMap<String, Type> = enums
        .keys()
        .map(|ename| (ename.clone(), Type::Enum(ename.clone())))
        .collect();
    for p in params {
        env.insert(p.name.clone(), p.ty.clone());
    }
    let mut explicitly_typed: HashSet<String> = params.iter().map(|p| p.name.clone()).collect();
    let mut dynamic_vars: HashSet<String> = HashSet::new();

    #[derive(Clone, Copy, PartialEq, Eq)]
    enum EmptyKind {
        List,
        Dict,
        Set,
    }
    let mut empty_inits: HashMap<String, EmptyKind> = HashMap::new();
    let mut list_elems: HashMap<String, Vec<Type>> = HashMap::new();
    let mut dict_keys: HashMap<String, Vec<Type>> = HashMap::new();
    let mut dict_vals: HashMap<String, Vec<Type>> = HashMap::new();
    let mut set_elems: HashMap<String, Vec<Type>> = HashMap::new();

    #[allow(clippy::too_many_arguments)]
    fn walk(
        stmts: &[Stmt],
        env: &mut HashMap<String, Type>,
        explicitly_typed: &mut HashSet<String>,
        dynamic_vars: &mut HashSet<String>,
        empty_inits: &mut HashMap<String, EmptyKind>,
        list_elems: &mut HashMap<String, Vec<Type>>,
        dict_keys: &mut HashMap<String, Vec<Type>>,
        dict_vals: &mut HashMap<String, Vec<Type>>,
        set_elems: &mut HashMap<String, Vec<Type>>,
        structs: &HashMap<String, Vec<Param>>,
        sigs: &HashMap<String, FuncSig>,
    ) {
        for s in stmts {
            match &s.kind {
                StmtKind::ForElse { body, else_body } => {
                    // Recurse for hints, then continue with the following statements.
                    walk(
                        body,
                        env,
                        explicitly_typed,
                        dynamic_vars,
                        empty_inits,
                        list_elems,
                        dict_keys,
                        dict_vals,
                        set_elems,
                        structs,
                        sigs,
                    );
                    walk(
                        else_body,
                        env,
                        explicitly_typed,
                        dynamic_vars,
                        empty_inits,
                        list_elems,
                        dict_keys,
                        dict_vals,
                        set_elems,
                        structs,
                        sigs,
                    );
                }
                StmtKind::Let { name, ty, value } => {
                    walk_expr_hints(value, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    if let Some(decl_t) = ty {
                        explicitly_typed.insert(name.clone());
                        env.insert(name.clone(), decl_t.clone());
                    } else {
                        record_var_assign(name, value, env, explicitly_typed, dynamic_vars, empty_inits, structs, sigs);
                    }
                }
                StmtKind::Assign { target, op, value } => {
                    walk_expr_hints(value, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    match target {
                        AssignTarget::Var(name) => {
                            if op.is_none() {
                                record_var_assign(
                                    name,
                                    value,
                                    env,
                                    explicitly_typed,
                                    dynamic_vars,
                                    empty_inits,
                                    structs,
                                    sigs,
                                );
                            }
                        }
                        AssignTarget::Index { target: t, index } => {
                            walk_expr_hints(t, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                            walk_expr_hints(index, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                            if let ExprKind::Var(cname) = &t.kind {
                                if empty_inits.get(cname) == Some(&EmptyKind::Dict) {
                                    let kt = quick_infer(index, env, structs, sigs).unwrap_or(Type::Any);
                                    let vt = quick_infer(value, env, structs, sigs).unwrap_or(Type::Any);
                                    dict_keys.entry(cname.clone()).or_default().push(kt);
                                    dict_vals.entry(cname.clone()).or_default().push(vt);
                                }
                            }
                        }
                        AssignTarget::Field { target: t, .. } => {
                            walk_expr_hints(t, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                        }
                    }
                }
                StmtKind::Expr(e) | StmtKind::Return(Some(e)) => {
                    walk_expr_hints(e, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                StmtKind::Assert { cond, msg } => {
                    walk_expr_hints(cond, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    if let Some(m) = msg {
                        walk_expr_hints(m, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    }
                }
                StmtKind::Del { name } => {
                    env.remove(name);
                    list_elems.remove(name);
                    dict_keys.remove(name);
                    dict_vals.remove(name);
                    set_elems.remove(name);
                }
                // `global` names bind to module constants that carry their own literal type.
                StmtKind::Global { names } => {
                    for name in names {
                        env.remove(name);
                        list_elems.remove(name);
                        dict_keys.remove(name);
                        dict_vals.remove(name);
                        set_elems.remove(name);
                    }
                }
                StmtKind::If {
                    cond,
                    then_body,
                    else_body,
                } => {
                    walk_expr_hints(cond, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    walk(then_body, env, explicitly_typed, dynamic_vars, empty_inits, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    if let Some(eb) = else_body {
                        walk(eb, env, explicitly_typed, dynamic_vars, empty_inits, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    }
                }
                StmtKind::While { cond, body } => {
                    walk_expr_hints(cond, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    walk(body, env, explicitly_typed, dynamic_vars, empty_inits, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                StmtKind::For {
                    var,
                    start,
                    end,
                    step,
                    body,
                    ..
                } => {
                    walk_expr_hints(start, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    walk_expr_hints(end, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    if let Some(se) = step {
                        walk_expr_hints(se, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    }
                    env.insert(var.clone(), Type::Int);
                    walk(body, env, explicitly_typed, dynamic_vars, empty_inits, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                StmtKind::ForEach { var, iter, body, .. } => {
                    walk_expr_hints(iter, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    let et = match quick_infer(iter, env, structs, sigs) {
                        Some(Type::Array(inner)) | Some(Type::Set(inner)) => *inner,
                        Some(Type::Dict(k, _)) => *k,
                        Some(Type::Str) => Type::Str,
                        _ => Type::Any,
                    };
                    env.insert(var.clone(), et);
                    walk(body, env, explicitly_typed, dynamic_vars, empty_inits, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                StmtKind::ForEnumerate {
                    idx_var,
                    elem_var,
                    iter,
                    start,
                    body,
                } => {
                    walk_expr_hints(iter, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    if let Some(st) = start {
                        walk_expr_hints(st, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    }
                    let et = match quick_infer(iter, env, structs, sigs) {
                        Some(Type::Array(inner)) => *inner,
                        Some(Type::Str) => Type::Str,
                        _ => Type::Any,
                    };
                    env.insert(idx_var.clone(), Type::Int);
                    env.insert(elem_var.clone(), et);
                    walk(body, env, explicitly_typed, dynamic_vars, empty_inits, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                StmtKind::ForDictItems {
                    key_var,
                    val_var,
                    dict,
                    body,
                } => {
                    walk_expr_hints(dict, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    let (kt, vt) = match quick_infer(dict, env, structs, sigs) {
                        Some(Type::Dict(k, v)) => (*k, *v),
                        Some(Type::Array(inner)) => match *inner {
                            Type::Tuple(mut ts) if ts.len() == 2 => {
                                let b = ts.pop().unwrap();
                                let a = ts.pop().unwrap();
                                (a, b)
                            }
                            _ => (Type::Any, Type::Any),
                        },
                        _ => (Type::Any, Type::Any),
                    };
                    env.insert(key_var.clone(), kt);
                    env.insert(val_var.clone(), vt);
                    walk(body, env, explicitly_typed, dynamic_vars, empty_inits, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                StmtKind::TupleAssign { targets, value } => {
                    walk_expr_hints(value, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    let elem_tys: Vec<Type> = match quick_infer(value, env, structs, sigs) {
                        Some(Type::Tuple(ts)) if ts.len() == targets.len() => ts,
                        _ => vec![Type::Any; targets.len()],
                    };
                    for (tname, et) in targets.iter().zip(elem_tys.into_iter()) {
                        if explicitly_typed.contains(tname) {
                            continue;
                        }
                        if et == Type::Any {
                            dynamic_vars.insert(tname.clone());
                            env.insert(tname.clone(), Type::Any);
                        } else if let Some(prev) = env.get(tname).cloned() {
                            if prev != et && !compatible_assign(&prev, &et) {
                                dynamic_vars.insert(tname.clone());
                                env.insert(tname.clone(), Type::Any);
                            }
                        } else {
                            env.insert(tname.clone(), et);
                        }
                    }
                }
                StmtKind::Match { subject, cases } => {
                    walk_expr_hints(subject, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    for c in cases {
                        if let Some(g) = &c.guard {
                            walk_expr_hints(g, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                        }
                        walk(&c.body, env, explicitly_typed, dynamic_vars, empty_inits, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    }
                }
                StmtKind::ForZip { vars, iters, body } => {
                    for it in iters {
                        walk_expr_hints(it, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    }
                    let elem_ty = |it: &Expr, env: &HashMap<String, Type>| match quick_infer(it, env, structs, sigs) {
                        Some(Type::Array(inner)) | Some(Type::Set(inner)) => *inner,
                        Some(Type::Str) => Type::Str,
                        _ => Type::Any,
                    };
                    for (v, it) in vars.iter().zip(iters.iter()) {
                        let et = elem_ty(it, env);
                        env.insert(v.clone(), et);
                    }
                    walk(body, env, explicitly_typed, dynamic_vars, empty_inits, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                StmtKind::ForTupleUnpack { vars, iter, body } => {
                    walk_expr_hints(iter, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    let elem_tys: Vec<Type> = match quick_infer(iter, env, structs, sigs) {
                        Some(Type::Array(inner)) => match *inner {
                            Type::Tuple(ts) if ts.len() == vars.len() => ts,
                            other => vec![other; vars.len()],
                        },
                        Some(Type::Str) => vec![Type::Str; vars.len()],
                        _ => vec![Type::Any; vars.len()],
                    };
                    for (v, et) in vars.iter().zip(elem_tys.into_iter()) {
                        if !explicitly_typed.contains(v) && et != Type::Any {
                            env.insert(v.clone(), et);
                        } else {
                            env.insert(v.clone(), Type::Any);
                        }
                    }
                    walk(body, env, explicitly_typed, dynamic_vars, empty_inits, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                StmtKind::Region { body } => {
                    walk(body, env, explicitly_typed, dynamic_vars, empty_inits, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                StmtKind::Return(None) | StmtKind::Pass | StmtKind::Break | StmtKind::Continue => {}
            }
        }
    }

    #[allow(clippy::too_many_arguments)]
    fn record_var_assign(
        name: &str,
        value: &Expr,
        env: &mut HashMap<String, Type>,
        explicitly_typed: &HashSet<String>,
        dynamic_vars: &mut HashSet<String>,
        empty_inits: &mut HashMap<String, EmptyKind>,
        structs: &HashMap<String, Vec<Param>>,
        sigs: &HashMap<String, FuncSig>,
    ) {
        if explicitly_typed.contains(name) {
            return;
        }
        if matches!(&value.kind, ExprKind::NoneLit) {
            if matches!(env.get(name), Some(Type::Optional(_))) {
                return;
            }
            dynamic_vars.insert(name.to_string());
            env.insert(name.to_string(), Type::Any);
            empty_inits.remove(name);
            return;
        }
        if !env.contains_key(name) {
            match &value.kind {
                ExprKind::ArrayLit(es) if es.is_empty() => {
                    empty_inits.insert(name.to_string(), EmptyKind::List);
                }
                ExprKind::DictLit(ps) if ps.is_empty() => {
                    empty_inits.insert(name.to_string(), EmptyKind::Dict);
                }
                ExprKind::Call { name: fn_name, args } if args.is_empty() => match fn_name.as_str()
                {
                    "list" => {
                        empty_inits.insert(name.to_string(), EmptyKind::List);
                    }
                    "dict" => {
                        empty_inits.insert(name.to_string(), EmptyKind::Dict);
                    }
                    "set" => {
                        empty_inits.insert(name.to_string(), EmptyKind::Set);
                    }
                    _ => {}
                },
                _ => {}
            }
        } else {
            empty_inits.remove(name);
        }

        if let Some(new_t) = quick_infer(value, env, structs, sigs) {
            if new_t == Type::Any {
                dynamic_vars.insert(name.to_string());
                env.insert(name.to_string(), Type::Any);
                return;
            }
            if let Some(prev_t) = env.get(name).cloned() {
                if prev_t != new_t && !compatible_assign(&prev_t, &new_t) {
                    dynamic_vars.insert(name.to_string());
                    env.insert(name.to_string(), Type::Any);
                    return;
                }
            } else {
                env.insert(name.to_string(), new_t);
            }
        }
    }

    fn compatible_assign(prev: &Type, next: &Type) -> bool {
        matches!(
            (prev, next),
            (Type::Array(x), Type::Array(_)) if **x == Type::Any
        ) || matches!(
            (prev, next),
            (Type::Dict(k, v), Type::Dict(_, _)) if **k == Type::Any && **v == Type::Any
        ) || matches!(
            (prev, next),
            (Type::Optional(inner), rhs) if **inner == *rhs
        )
    }

    #[allow(clippy::too_many_arguments)]
    fn walk_expr_hints(
        expr: &Expr,
        env: &HashMap<String, Type>,
        list_elems: &mut HashMap<String, Vec<Type>>,
        dict_keys: &mut HashMap<String, Vec<Type>>,
        dict_vals: &mut HashMap<String, Vec<Type>>,
        set_elems: &mut HashMap<String, Vec<Type>>,
        structs: &HashMap<String, Vec<Param>>,
        sigs: &HashMap<String, FuncSig>,
    ) {
        match &expr.kind {
            ExprKind::Call { name, args } => {
                if name == "push" && args.len() == 2 {
                    if let ExprKind::Var(vname) = &args[0].kind {
                        let et = quick_infer(&args[1], env, structs, sigs).unwrap_or(Type::Any);
                        list_elems.entry(vname.clone()).or_default().push(et);
                    }
                }
                for a in args {
                    walk_expr_hints(a, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
            }
            ExprKind::CallKw { pos_args, kw_args, .. } => {
                for a in pos_args {
                    walk_expr_hints(a, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                for (_, v, _) in kw_args {
                    walk_expr_hints(v, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
            }
            ExprKind::MethodCall { target, method, args } => {
                if let ExprKind::Var(vname) = &target.kind {
                    match (method.as_str(), args.len()) {
                        ("append", 1) => {
                            let et = quick_infer(&args[0], env, structs, sigs).unwrap_or(Type::Any);
                            list_elems.entry(vname.clone()).or_default().push(et);
                        }
                        ("add", 1) | ("discard", 1) | ("remove", 1) => {
                            let et = quick_infer(&args[0], env, structs, sigs).unwrap_or(Type::Any);
                            set_elems.entry(vname.clone()).or_default().push(et);
                        }
                        ("get", 1) => {
                            let kt = quick_infer(&args[0], env, structs, sigs).unwrap_or(Type::Any);
                            dict_keys.entry(vname.clone()).or_default().push(kt);
                        }
                        ("get", 2) => {
                            let kt = quick_infer(&args[0], env, structs, sigs).unwrap_or(Type::Any);
                            let vt = quick_infer(&args[1], env, structs, sigs).unwrap_or(Type::Any);
                            dict_keys.entry(vname.clone()).or_default().push(kt);
                            dict_vals.entry(vname.clone()).or_default().push(vt);
                        }
                        _ => {}
                    }
                }
                walk_expr_hints(target, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                for a in args {
                    walk_expr_hints(a, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
            }
            ExprKind::Index { target, index } => {
                if let ExprKind::Var(vname) = &target.kind {
                    let kt = quick_infer(index, env, structs, sigs).unwrap_or(Type::Any);
                    dict_keys.entry(vname.clone()).or_default().push(kt);
                }
                walk_expr_hints(target, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                walk_expr_hints(index, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
            }
            ExprKind::Slice { target, start, stop, step } => {
                walk_expr_hints(target, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                if let Some(s) = start {
                    walk_expr_hints(s, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                if let Some(e) = stop {
                    walk_expr_hints(e, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                if let Some(st) = step {
                    walk_expr_hints(st, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
            }
            ExprKind::Binary { op, lhs, rhs } => {
                if matches!(op, BinOp::In | BinOp::NotIn) {
                    if let ExprKind::Var(vname) = &rhs.kind {
                        let kt = quick_infer(lhs, env, structs, sigs).unwrap_or(Type::Any);
                        dict_keys.entry(vname.clone()).or_default().push(kt.clone());
                        set_elems.entry(vname.clone()).or_default().push(kt);
                    }
                }
                walk_expr_hints(lhs, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                walk_expr_hints(rhs, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
            }
            ExprKind::Unary { expr: inner, .. } | ExprKind::Field { target: inner, .. } => {
                walk_expr_hints(inner, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
            }
            ExprKind::IfExpr { then_expr, cond, else_expr } => {
                walk_expr_hints(then_expr, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                walk_expr_hints(cond, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                walk_expr_hints(else_expr, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
            }
            ExprKind::FString(parts) => {
                for p in parts {
                    if let FStrPart::Expr(e) = p {
                        walk_expr_hints(e, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    }
                }
            }
            ExprKind::ArrayLit(es) | ExprKind::SetLit(es) | ExprKind::TupleLit(es) => {
                for e in es {
                    walk_expr_hints(e, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
            }
            ExprKind::DictLit(ps) => {
                for (k, v) in ps {
                    walk_expr_hints(k, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                    walk_expr_hints(v, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
            }
            ExprKind::ArrayRepeat { value, count } => {
                walk_expr_hints(value, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                walk_expr_hints(count, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
            }
            ExprKind::MethodCallKw { target, method, pos_args, kw_args } => {
                let all_args: Vec<&Expr> = pos_args.iter().collect();
                if let ExprKind::Var(vname) = &target.kind {
                    match (method.as_str(), all_args.len()) {
                        ("extend", 1) => {
                            if let Some(Type::Array(inner)) = quick_infer(all_args[0], env, structs, sigs) {
                                list_elems.entry(vname.clone()).or_default().push(*inner);
                            }
                        }
                        ("append", 1) | ("insert", 2) => {
                            let e = if method == "append" { all_args[0] } else { all_args[1] };
                            let et = quick_infer(e, env, structs, sigs).unwrap_or(Type::Any);
                            list_elems.entry(vname.clone()).or_default().push(et);
                        }
                        _ => {}
                    }
                }
                walk_expr_hints(target, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                for a in pos_args {
                    walk_expr_hints(a, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                for (_, v, _) in kw_args {
                    walk_expr_hints(v, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
            }
            ExprKind::CallGeneric { pos_args, kw_args, .. } => {
                for a in pos_args {
                    walk_expr_hints(a, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
                for (_, v, _) in kw_args {
                    walk_expr_hints(v, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
            }
            ExprKind::CallExpr { callee, args } => {
                walk_expr_hints(callee, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                for a in args {
                    walk_expr_hints(a, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                }
            }
            ExprKind::ListComp { elt, clauses }
            | ExprKind::SetComp { elt, clauses }
            | ExprKind::GenExpr { elt, clauses } => {
                walk_comp_clause_hints(clauses, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                walk_expr_hints(elt, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
            }
            ExprKind::DictComp { key, val, clauses } => {
                walk_comp_clause_hints(clauses, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                walk_expr_hints(key, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
                walk_expr_hints(val, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
            }
            ExprKind::Lambda { body, .. } => {
                walk_expr_hints(body, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
            }
            _ => {}
        }
    }

    #[allow(clippy::too_many_arguments)]
    fn walk_comp_clause_hints(
        clauses: &[CompClause],
        env: &HashMap<String, Type>,
        list_elems: &mut HashMap<String, Vec<Type>>,
        dict_keys: &mut HashMap<String, Vec<Type>>,
        dict_vals: &mut HashMap<String, Vec<Type>>,
        set_elems: &mut HashMap<String, Vec<Type>>,
        structs: &HashMap<String, Vec<Param>>,
        sigs: &HashMap<String, FuncSig>,
    ) {
        for c in clauses {
            walk_expr_hints(&c.iter, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
            for cond in &c.conds {
                walk_expr_hints(cond, env, list_elems, dict_keys, dict_vals, set_elems, structs, sigs);
            }
        }
    }

    walk(
        stmts,
        &mut env,
        &mut explicitly_typed,
        &mut dynamic_vars,
        &mut empty_inits,
        &mut list_elems,
        &mut dict_keys,
        &mut dict_vals,
        &mut set_elems,
        structs,
        sigs,
    );

    let mut specialized_containers = HashMap::new();
    for (name, kind) in empty_inits {
        if dynamic_vars.contains(&name) {
            continue;
        }
        match kind {
            EmptyKind::List => {
                let elem = unify_types(list_elems.get(&name).map_or(&[], Vec::as_slice));
                specialized_containers.insert(name, Type::Array(Box::new(elem)));
            }
            EmptyKind::Dict => {
                let mut k = unify_types(dict_keys.get(&name).map_or(&[], Vec::as_slice));
                if !k.is_hashable_key() {
                    k = Type::Any;
                }
                let v = unify_types(dict_vals.get(&name).map_or(&[], Vec::as_slice));
                specialized_containers.insert(name, Type::Dict(Box::new(k), Box::new(v)));
            }
            EmptyKind::Set => {
                let mut e = unify_types(set_elems.get(&name).map_or(&[], Vec::as_slice));
                if !e.is_hashable_key() {
                    e = Type::Any;
                }
                specialized_containers.insert(name, Type::Set(Box::new(e)));
            }
        }
    }

    AdaptiveHints {
        dynamic_vars,
        specialized_containers,
    }
}

fn bind_comp_vars(
    clauses: &[CompClause],
    scope: &mut HashMap<String, Type>,
    outer: &HashMap<String, Type>,
    structs: &HashMap<String, Vec<Param>>,
    sigs: &HashMap<String, FuncSig>,
) {
    for clause in clauses {
        let elem_ty = match quick_infer(&clause.iter, scope, structs, sigs) {
            Some(Type::Array(inner)) | Some(Type::Set(inner)) => *inner,
            Some(Type::Dict(k, _)) => *k,
            Some(Type::Str) => Type::Str,
            _ => match quick_infer(&clause.iter, outer, structs, sigs) {
                Some(Type::Array(inner)) | Some(Type::Set(inner)) => *inner,
                Some(Type::Str) => Type::Str,
                _ => Type::Any,
            },
        };
        if clause.vars.len() == 1 {
            scope.insert(clause.vars[0].clone(), elem_ty);
        } else {
            let parts: Vec<Type> = match &elem_ty {
                Type::Tuple(ts) if ts.len() == clause.vars.len() => ts.clone(),
                _ => vec![Type::Any; clause.vars.len()],
            };
            for (v, t) in clause.vars.iter().zip(parts.into_iter()) {
                scope.insert(v.clone(), t);
            }
        }
    }
}

fn quick_infer_comp_elt(
    elt: &Expr,
    clauses: &[CompClause],
    env: &HashMap<String, Type>,
    structs: &HashMap<String, Vec<Param>>,
    sigs: &HashMap<String, FuncSig>,
) -> Option<Type> {
    let mut scope = env.clone();
    bind_comp_vars(clauses, &mut scope, env, structs, sigs);
    Some(quick_infer(elt, &scope, structs, sigs).unwrap_or(Type::Any))
}

fn unify_types(tys: &[Type]) -> Type {
    let Some(first) = tys.first() else {
        return Type::Any;
    };
    if *first == Type::Any || *first == Type::Void {
        return Type::Any;
    }
    for t in &tys[1..] {
        if t != first {
            return Type::Any;
        }
    }
    first.clone()
}

fn quick_infer(
    expr: &Expr,
    env: &HashMap<String, Type>,
    structs: &HashMap<String, Vec<Param>>,
    sigs: &HashMap<String, FuncSig>,
) -> Option<Type> {
    match &expr.kind {
        ExprKind::Int(_) => Some(Type::Int),
        ExprKind::Float(_) => Some(Type::Float),
        ExprKind::Bool(_) => Some(Type::Bool),
        ExprKind::NoneLit => Some(Type::Any),
        ExprKind::Str(_) | ExprKind::FString(_) => Some(Type::Str),
        ExprKind::Var(name) => env.get(name).cloned(),
        ExprKind::CompareChain(_) => Some(Type::Bool),
        ExprKind::PercentFormat { .. } => Some(Type::Str),
        ExprKind::ArrayLit(es) => {
            if es.is_empty() {
                Some(Type::Array(Box::new(Type::Any)))
            } else {
                let mut inferred = Vec::with_capacity(es.len());
                for e in es {
                    inferred.push(quick_infer(e, env, structs, sigs)?);
                }
                Some(Type::Array(Box::new(unify_types(&inferred))))
            }
        }
        ExprKind::SetLit(es) => {
            let mut inferred = Vec::with_capacity(es.len());
            for e in es {
                inferred.push(quick_infer(e, env, structs, sigs)?);
            }
            let mut elem = unify_types(&inferred);
            if !elem.is_hashable_key() {
                elem = Type::Any;
            }
            Some(Type::Set(Box::new(elem)))
        }
        ExprKind::TupleLit(es) => {
            let mut ts = Vec::with_capacity(es.len());
            for e in es {
                ts.push(quick_infer(e, env, structs, sigs)?);
            }
            Some(Type::Tuple(ts))
        }
        ExprKind::DictLit(ps) => {
            if ps.is_empty() {
                Some(Type::Dict(Box::new(Type::Any), Box::new(Type::Any)))
            } else {
                let mut ks = Vec::with_capacity(ps.len());
                let mut vs = Vec::with_capacity(ps.len());
                for (k, v) in ps {
                    ks.push(quick_infer(k, env, structs, sigs)?);
                    vs.push(quick_infer(v, env, structs, sigs)?);
                }
                let mut kt = unify_types(&ks);
                if !kt.is_hashable_key() {
                    kt = Type::Any;
                }
                let vt = unify_types(&vs);
                Some(Type::Dict(Box::new(kt), Box::new(vt)))
            }
        }
        ExprKind::ArrayRepeat { value, .. } => {
            let inner = quick_infer(value, env, structs, sigs)?;
            Some(Type::Array(Box::new(inner)))
        }
        ExprKind::ListComp { elt, clauses } => {
            let inner = quick_infer_comp_elt(elt, clauses, env, structs, sigs)?;
            Some(Type::Array(Box::new(inner)))
        }
        ExprKind::GenExpr { elt, clauses } => {
            let inner = quick_infer_comp_elt(elt, clauses, env, structs, sigs)?;
            Some(Type::Array(Box::new(inner)))
        }
        ExprKind::SetComp { elt, clauses } => {
            let mut inner = quick_infer_comp_elt(elt, clauses, env, structs, sigs)?;
            if !inner.is_hashable_key() {
                inner = Type::Any;
            }
            Some(Type::Set(Box::new(inner)))
        }
        ExprKind::DictComp { key, val, clauses } => {
            let mut env2 = env.clone();
            bind_comp_vars(clauses, &mut env2, env, structs, sigs);
            let mut kt = quick_infer(key, &env2, structs, sigs).unwrap_or(Type::Any);
            if !kt.is_hashable_key() {
                kt = Type::Any;
            }
            let vt = quick_infer(val, &env2, structs, sigs).unwrap_or(Type::Any);
            Some(Type::Dict(Box::new(kt), Box::new(vt)))
        }
        ExprKind::Lambda { .. } => Some(Type::Any),
        ExprKind::CallGeneric { name, .. } => {
            if structs.contains_key(name) {
                return Some(Type::Struct(name.clone()));
            }
            sigs.get(name).and_then(|s| s.ret.clone())
        }
        ExprKind::CallExpr { callee, .. } => match quick_infer(callee, env, structs, sigs)? {
            Type::Any => Some(Type::Any),
            _ => None,
        },
        ExprKind::MethodCallKw { target, method, pos_args, kw_args } => {
            let tt = quick_infer(target, env, structs, sigs);
            match method.as_str() {
                "sort" => Some(Type::Void),
                "extend" => tt,
                _ if kw_args.is_empty() => {
                    let _ = pos_args;
                    Some(Type::Any)
                }
                _ => Some(Type::Any),
            }
        }
        ExprKind::Call { name, .. } | ExprKind::CallKw { name, .. } => {
            if let Some(sig) = sigs.get(name) {
                return sig.ret.clone();
            }
            if structs.contains_key(name) {
                return Some(Type::Struct(name.clone()));
            }
            match name.as_str() {
                "int" | "len" | "ord" => Some(Type::Int),
                "float" | "sqrt" => Some(Type::Float),
                "str" | "input" | "chr" | "type" => Some(Type::Str),
                "bool" | "isinstance" => Some(Type::Bool),
                "dict" => Some(Type::Dict(Box::new(Type::Any), Box::new(Type::Any))),
                "set" => Some(Type::Set(Box::new(Type::Any))),
                "list" => Some(Type::Array(Box::new(Type::Any))),
                _ => None,
            }
        }
        ExprKind::Index { target, index } => match quick_infer(target, env, structs, sigs)? {
            Type::Array(inner) => Some(*inner),
            Type::Dict(_, v) => Some(*v),
            Type::Tuple(ts) => {
                let idx = eval_const_int(index)?;
                let adj = if idx < 0 { idx + ts.len() as i64 } else { idx };
                if adj >= 0 && (adj as usize) < ts.len() {
                    Some(ts[adj as usize].clone())
                } else {
                    None
                }
            }
            Type::Str => Some(Type::Str),
            Type::Any => Some(Type::Any),
            _ => None,
        },
        ExprKind::Slice { target, .. } => quick_infer(target, env, structs, sigs),
        ExprKind::Field { target, field } => match quick_infer(target, env, structs, sigs)? {
            Type::Struct(sname) => structs
                .get(&sname)?
                .iter()
                .find(|f| f.name == *field)
                .map(|f| f.ty.clone()),
            Type::Enum(ename) => Some(Type::Enum(ename)),
            _ => None,
        },
        ExprKind::MethodCall { target, method, args } => {
            let tt = quick_infer(target, env, structs, sigs);
            if let Some(Type::Enum(ename)) = tt {
                return Some(Type::Enum(ename));
            }
            match method.as_str() {
                "split" => Some(Type::Array(Box::new(Type::Str))),
                "strip" | "upper" | "lower" | "replace" => Some(Type::Str),
                "startswith" | "endswith" => Some(Type::Bool),
                "find" => Some(Type::Int),
                "get" => match tt {
                    Some(Type::Dict(_, v)) => Some(*v),
                    _ if args.len() == 2 => quick_infer(&args[1], env, structs, sigs),
                    _ => Some(Type::Any),
                },
                "keys" => match tt {
                    Some(Type::Dict(k, _)) => Some(Type::Array(k)),
                    _ => Some(Type::Array(Box::new(Type::Any))),
                },
                "values" => match tt {
                    Some(Type::Dict(_, v)) => Some(Type::Array(v)),
                    _ => Some(Type::Array(Box::new(Type::Any))),
                },
                "pop" => match tt {
                    Some(Type::Array(e)) => Some(*e),
                    Some(Type::Dict(_, v)) => Some(*v),
                    _ => Some(Type::Any),
                },
                _ => None,
            }
        }
        ExprKind::IfExpr {
            then_expr,
            else_expr,
            ..
        } => {
            if matches!(&else_expr.kind, ExprKind::NoneLit)
                && !matches!(&then_expr.kind, ExprKind::NoneLit)
            {
                let t1 = quick_infer(then_expr, env, structs, sigs)?;
                return Some(match t1 {
                    Type::Optional(_) | Type::Any => t1,
                    other => Type::Optional(Box::new(other)),
                });
            }
            if matches!(&then_expr.kind, ExprKind::NoneLit)
                && !matches!(&else_expr.kind, ExprKind::NoneLit)
            {
                let t2 = quick_infer(else_expr, env, structs, sigs)?;
                return Some(match t2 {
                    Type::Optional(_) | Type::Any => t2,
                    other => Type::Optional(Box::new(other)),
                });
            }
            let t1 = quick_infer(then_expr, env, structs, sigs)?;
            let t2 = quick_infer(else_expr, env, structs, sigs)?;
            Some(if t1 == t2 { t1 } else { Type::Any })
        }
        ExprKind::Unary { op, expr: inner } => match op {
            UnOp::Not => Some(Type::Bool),
            UnOp::Neg | UnOp::BitNot => quick_infer(inner, env, structs, sigs),
        },
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
            _ => {
                let lt = quick_infer(lhs, env, structs, sigs)?;
                let rt = quick_infer(rhs, env, structs, sigs)?;
                if lt == Type::Any || rt == Type::Any {
                    Some(Type::Any)
                } else if lt == rt {
                    Some(lt)
                } else if *op == BinOp::Mul && (lt == Type::Str || rt == Type::Str) {
                    Some(Type::Str)
                } else {
                    Some(Type::Any)
                }
            }
        },
    }
}

pub(super) fn eval_const_int(expr: &Expr) -> Option<i64> {
    match &expr.kind {
        ExprKind::Int(v) => Some(*v),
        ExprKind::Unary {
            op: UnOp::Neg,
            expr: inner,
        } => eval_const_int(inner)?.checked_neg(),
        ExprKind::Binary { op, lhs, rhs } => {
            let a = eval_const_int(lhs)?;
            let b = eval_const_int(rhs)?;
            match op {
                BinOp::Add => a.checked_add(b),
                BinOp::Sub => a.checked_sub(b),
                BinOp::Mul => a.checked_mul(b),
                BinOp::Div if b != 0 => a.checked_div(b),
                BinOp::FloorDiv if b != 0 => {
                    let q = a.checked_div(b)?;
                    let r = a.checked_rem(b)?;
                    if r != 0 && (a ^ b) < 0 {
                        q.checked_sub(1)
                    } else {
                        Some(q)
                    }
                }
                BinOp::Pow if b >= 0 && b <= 62 => a.checked_pow(b as u32),
                BinOp::Mod if b != 0 => a.checked_rem(b),
                _ => None,
            }
        }
        _ => None,
    }
}

/// True when the block contains a `break` that would exit the enclosing loop (nested loops are
/// skipped: their `break`s bind to themselves).
pub(super) fn stmts_contain_break(stmts: &[Stmt]) -> bool {
    stmts.iter().any(|s| match &s.kind {
        StmtKind::Break => true,
        StmtKind::If {
            then_body,
            else_body,
            ..
        } => {
            stmts_contain_break(then_body)
                || else_body.as_ref().map_or(false, |b| stmts_contain_break(b))
        }
        StmtKind::For { body, else_body, .. } | StmtKind::ForEach { body, else_body, .. } => {
            else_body.as_ref().map_or(false, |b| stmts_contain_break(b)) && {
                let _ = body;
                false
            }
        }
        StmtKind::While { body, .. }
        | StmtKind::ForEnumerate { body, .. }
        | StmtKind::ForDictItems { body, .. }
        | StmtKind::ForZip { body, .. }
        | StmtKind::ForTupleUnpack { body, .. } => {
            let _ = body;
            false
        }
        StmtKind::Match { cases, .. } => cases.iter().any(|c| stmts_contain_break(&c.body)),
        StmtKind::Region { body } => stmts_contain_break(body),
        _ => false,
    })
}

/// Names that a `del` removes from a function's scope. Codegen never gives a deleted name a slot
/// (or the pointer type would flip between `str` and `list[int]` on rebinding), and `del` is a
/// no-op for them: they exist only to make the name undefined again.
pub(super) fn collect_deleted_vars(stmts: &[Stmt]) -> HashSet<String> {
    let mut out = HashSet::new();
    for s in stmts {
        match &s.kind {
            StmtKind::Del { name } => {
                out.insert(name.clone());
            }
            StmtKind::If {
                then_body,
                else_body,
                ..
            } => {
                out.extend(collect_deleted_vars(then_body));
                if let Some(eb) = else_body {
                    out.extend(collect_deleted_vars(eb));
                }
            }
            StmtKind::ForElse { body, else_body } => {
                out.extend(collect_deleted_vars(body));
                out.extend(collect_deleted_vars(else_body));
            }
            StmtKind::While { body, .. }
            | StmtKind::For { body, .. }
            | StmtKind::ForEach { body, .. }
            | StmtKind::ForEnumerate { body, .. }
            | StmtKind::ForDictItems { body, .. }
            | StmtKind::ForZip { body, .. }
            | StmtKind::ForTupleUnpack { body, .. }
            | StmtKind::Region { body } => out.extend(collect_deleted_vars(body)),
            StmtKind::Match { cases, .. } => {
                for c in cases {
                    out.extend(collect_deleted_vars(&c.body));
                }
            }
            _ => {}
        }
    }
    out
}
