//! Pure AST static analyses: SoA escape detection, monotonic `while` stride verification,
//! mutation/return variable collection, and compile-time integer constant folding.

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

pub(super) fn var_escapes_soa(stmts: &[Stmt], var: &str) -> bool {
    for s in stmts {
        if stmt_escapes_soa(s, var) {
            return true;
        }
    }
    false
}

pub(super) fn stmt_escapes_soa(stmt: &Stmt, var: &str) -> bool {
    match &stmt.kind {
        StmtKind::Let { value, .. } => expr_escapes_soa(value, var),
        StmtKind::Assign { target, value, .. } => {
            match target {
                AssignTarget::Var(n) if n == var => return true,
                AssignTarget::Index { target: t, index } => {
                    if !matches!(&t.kind, ExprKind::Var(n) if n == var) && expr_escapes_soa(t, var)
                    {
                        return true;
                    }
                    if expr_escapes_soa(index, var) {
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
                            && expr_escapes_soa(arr, var)
                        {
                            return true;
                        }
                        if expr_escapes_soa(idx, var) {
                            return true;
                        }
                    } else if expr_escapes_soa(t, var) {
                        return true;
                    }
                }
                _ => {}
            }
            expr_escapes_soa(value, var)
        }
        StmtKind::Expr(e) => expr_escapes_soa(e, var),
        StmtKind::Return(Some(e)) => expr_escapes_soa(e, var),
        StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => false,
        StmtKind::If {
            cond,
            then_body,
            else_body,
        } => {
            expr_escapes_soa(cond, var)
                || var_escapes_soa(then_body, var)
                || else_body.as_ref().map_or(false, |b| var_escapes_soa(b, var))
        }
        StmtKind::While { cond, body } => expr_escapes_soa(cond, var) || var_escapes_soa(body, var),
        StmtKind::For {
            start,
            end,
            step,
            body,
            ..
        } => {
            expr_escapes_soa(start, var)
                || expr_escapes_soa(end, var)
                || step.as_ref().map_or(false, |se| expr_escapes_soa(se, var))
                || var_escapes_soa(body, var)
        }
        StmtKind::ForEach { iter, body, .. } => {
            let direct = matches!(&iter.kind, ExprKind::Var(n) if n == var);
            (!direct && expr_escapes_soa(iter, var)) || var_escapes_soa(body, var)
        }
        StmtKind::Region { body } => var_escapes_soa(body, var),
    }
}

pub(super) fn expr_escapes_soa(expr: &Expr, var: &str) -> bool {
    match &expr.kind {
        ExprKind::Var(n) => n == var,
        ExprKind::Index { target, index } => {
            let direct = matches!(&target.kind, ExprKind::Var(n) if n == var);
            (!direct && expr_escapes_soa(target, var)) || expr_escapes_soa(index, var)
        }
        ExprKind::Field { target, .. } => expr_escapes_soa(target, var),
        ExprKind::Call { name, args } => {
            if name == "len" && args.len() == 1 && matches!(&args[0].kind, ExprKind::Var(n) if n == var)
            {
                return false;
            }
            args.iter().any(|a| expr_escapes_soa(a, var))
        }
        ExprKind::Unary { expr: inner, .. } => expr_escapes_soa(inner, var),
        ExprKind::Binary { lhs, rhs, .. } => {
            expr_escapes_soa(lhs, var) || expr_escapes_soa(rhs, var)
        }
        ExprKind::ArrayLit(es) => es.iter().any(|e| expr_escapes_soa(e, var)),
        ExprKind::ArrayRepeat { value, count } => {
            expr_escapes_soa(value, var) || expr_escapes_soa(count, var)
        }
        ExprKind::Int(_) | ExprKind::Bool(_) | ExprKind::Str(_) => false,
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
            StmtKind::While { .. } | StmtKind::For { .. } | StmtKind::ForEach { .. } => {
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
        | StmtKind::ForEach { body, .. } => stmts_use_region(body),
        _ => false,
    })
}

pub(super) fn stmts_contain_loop(stmts: &[Stmt]) -> bool {
    stmts.iter().any(|s| match &s.kind {
        StmtKind::While { .. } | StmtKind::For { .. } | StmtKind::ForEach { .. } => true,
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

pub(super) fn collect_mutated_vars(stmts: &[Stmt]) -> HashSet<String> {
    let mut set = HashSet::new();
    walk_mutations(stmts, &mut set);
    set
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
            | StmtKind::Region { body } => walk_returns(body, set),
            _ => {}
        }
    }
}

pub(super) fn walk_mutations(stmts: &[Stmt], set: &mut HashSet<String>) {
    for stmt in stmts {
        match &stmt.kind {
            StmtKind::Assign { target, value, .. } => {
                match target {
                    AssignTarget::Var(name) => {
                        set.insert(name.clone());
                    }
                    AssignTarget::Field { target: base, .. } => {
                        if let ExprKind::Var(vname) = &base.kind {
                            set.insert(vname.clone());
                        }
                        walk_expr_mutations(base, set);
                    }
                    AssignTarget::Index { target: t, index } => {
                        walk_expr_mutations(t, set);
                        walk_expr_mutations(index, set);
                    }
                }
                walk_expr_mutations(value, set);
            }
            StmtKind::Let { value, .. } => walk_expr_mutations(value, set),
            StmtKind::Expr(e) => walk_expr_mutations(e, set),
            StmtKind::Return(Some(e)) => walk_expr_mutations(e, set),
            StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => {}
            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                walk_expr_mutations(cond, set);
                walk_mutations(then_body, set);
                if let Some(eb) = else_body {
                    walk_mutations(eb, set);
                }
            }
            StmtKind::While { cond, body } => {
                walk_expr_mutations(cond, set);
                walk_mutations(body, set);
            }
            StmtKind::For {
                var,
                start,
                end,
                step,
                body,
            } => {
                set.insert(var.clone());
                walk_expr_mutations(start, set);
                walk_expr_mutations(end, set);
                if let Some(se) = step {
                    walk_expr_mutations(se, set);
                }
                walk_mutations(body, set);
            }
            StmtKind::ForEach { iter, body, .. } => {
                walk_expr_mutations(iter, set);
                walk_mutations(body, set);
            }
            StmtKind::Region { body } => walk_mutations(body, set),
        }
    }
}

pub(super) fn walk_expr_mutations(expr: &Expr, set: &mut HashSet<String>) {
    match &expr.kind {
        ExprKind::Call { name, args } => {
            if (name == "push" || name == "pop") && !args.is_empty() {
                if let ExprKind::Var(arr_name) = &args[0].kind {
                    set.insert(arr_name.clone());
                }
            }
            for a in args {
                walk_expr_mutations(a, set);
            }
        }
        ExprKind::Unary { expr: inner, .. } | ExprKind::Field { target: inner, .. } => {
            walk_expr_mutations(inner, set)
        }
        ExprKind::Binary { lhs, rhs, .. } => {
            walk_expr_mutations(lhs, set);
            walk_expr_mutations(rhs, set);
        }
        ExprKind::Index { target, index } => {
            walk_expr_mutations(target, set);
            walk_expr_mutations(index, set);
        }
        ExprKind::ArrayLit(elems) => {
            for e in elems {
                walk_expr_mutations(e, set);
            }
        }
        ExprKind::ArrayRepeat { value, count } => {
            walk_expr_mutations(value, set);
            walk_expr_mutations(count, set);
        }
        ExprKind::Int(_) | ExprKind::Bool(_) | ExprKind::Str(_) | ExprKind::Var(_) => {}
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
        | StmtKind::Region { body } => stmts_assign_var(body, name),
        _ => false,
    })
}

pub(super) fn stmts_mutate_array_len(stmts: &[Stmt], arr_name: &str) -> bool {
    let mut set = HashSet::new();
    walk_mutations(stmts, &mut set);
    set.contains(arr_name)
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
                BinOp::Mod if b != 0 => a.checked_rem(b),
                _ => None,
            }
        }
        _ => None,
    }
}

