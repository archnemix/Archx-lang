//! Pure AST static analyses: SoA escape detection, monotonic `while` stride verification,
//! Pythonic first-binding vs mutation/return variable collection, and integer constant folding.

use std::collections::HashSet;

use crate::ast::*;

use super::*;

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
            ..
        } => {
            expr_escapes_soa(start, var, mutating_methods)
                || expr_escapes_soa(end, var, mutating_methods)
                || step
                    .as_ref()
                    .map_or(false, |se| expr_escapes_soa(se, var, mutating_methods))
                || var_escapes_soa(body, var, mutating_methods)
        }
        StmtKind::ForEach { iter, body, .. } => {
            let direct = matches!(&iter.kind, ExprKind::Var(n) if n == var);
            (!direct && expr_escapes_soa(iter, var, mutating_methods))
                || var_escapes_soa(body, var, mutating_methods)
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
        ExprKind::Index { target, index } => {
            let direct = matches!(&target.kind, ExprKind::Var(n) if n == var);
            (!direct && expr_escapes_soa(target, var, mutating_methods))
                || expr_escapes_soa(index, var, mutating_methods)
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
            FStrPart::Expr(e) => expr_escapes_soa(e, var, mutating_methods),
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
        ExprKind::ArrayLit(es) => es
            .iter()
            .any(|e| expr_escapes_soa(e, var, mutating_methods)),
        ExprKind::ArrayRepeat { value, count } => {
            expr_escapes_soa(value, var, mutating_methods)
                || expr_escapes_soa(count, var, mutating_methods)
        }
        ExprKind::Int(_)
        | ExprKind::Float(_)
        | ExprKind::Bool(_)
        | ExprKind::NoneLit
        | ExprKind::Str(_) => false,
    }
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
            StmtKind::While { .. }
            | StmtKind::For { .. }
            | StmtKind::ForEach { .. }
            | StmtKind::ForEnumerate { .. } => {
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
        | StmtKind::ForEnumerate { body, .. } => stmts_use_region(body),
        _ => false,
    })
}

pub(super) fn stmts_contain_loop(stmts: &[Stmt]) -> bool {
    stmts.iter().any(|s| match &s.kind {
        StmtKind::While { .. }
        | StmtKind::For { .. }
        | StmtKind::ForEach { .. }
        | StmtKind::ForEnumerate { .. } => true,
        StmtKind::If {
            then_body,
            else_body,
            ..
        } => {
            stmts_contain_loop(then_body)
                || else_body.as_ref().map_or(false, |b| stmts_contain_loop(b))
        }
        StmtKind::Region { body } => stmts_contain_loop(body),
        _ => false,
    })
}

pub(super) fn method_mutates_self(params: &[Param], stmts: &[Stmt]) -> bool {
    let base: HashSet<String> = ["append", "pop", "clear"]
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
            | StmtKind::Region { body } => walk_returns(body, set),
            _ => {}
        }
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
            }
            StmtKind::ForEach { var, iter, body } => {
                walk_expr_mutations(iter, mutated, mutating_methods);
                let mut inner = bound.clone();
                inner.insert(var.clone());
                walk_mutations(body, &mut inner, mutated, mutating_methods);
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
        ExprKind::ArrayLit(elems) => {
            for e in elems {
                walk_expr_mutations(e, set, mutating_methods);
            }
        }
        ExprKind::ArrayRepeat { value, count } => {
            walk_expr_mutations(value, set, mutating_methods);
            walk_expr_mutations(count, set, mutating_methods);
        }
        ExprKind::Int(_)
        | ExprKind::Float(_)
        | ExprKind::Bool(_)
        | ExprKind::NoneLit
        | ExprKind::Str(_)
        | ExprKind::Var(_) => {}
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
        | StmtKind::Region { body } => stmts_assign_var(body, name),
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
