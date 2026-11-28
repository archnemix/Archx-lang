//! Loop lowering (`while`, `for i in a..b`, `for i in a..b step k`, and `for x in arr`)
//! with preheader range-guard versioning and compile-time bounds-check elision.

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::analysis::*;
use super::*;

/// Bind a `for` loop variable in the *function* scope.
///
/// Python scoping is function-level: `for b in ...` inside another loop's body still leaves `b`
/// visible after both loops end, so the binding cannot live in either loop's block scope.
fn bind_loop_var(cg: &mut Codegen, var: &str, ty: Type, slot: String, region_depth: usize) {
    cg.scopes[0].vars.insert(
        var.to_string(),
        VarEntry {
            ty,
            storage: VarStorage::Slot(slot),
            is_param: false,
            region_depth,
        },
    );
}

/// Insert many loop variables (`enumerate`, `zip`, `dict.items`) at function scope, where Python
/// keeps them.
fn bind_fn_scope(cg: &mut Codegen, name: String, entry: VarEntry) {
    cg.scopes[0].vars.insert(name, entry);
}

impl Codegen {
    // ---------------- Loops --------------------------------------------------

    pub(super) fn gen_while(&mut self, cond: &Expr, body: &[Stmt], out: &mut String) -> Result<()> {
        if let Some(plan) = self.analyze_strided_while(cond, body) {
            let fast_cond = self.fresh_label("while.fast.cond");
            let fast_body = self.fresh_label("while.fast.body");
            let slow_cond = self.fresh_label("while.cond");
            let slow_body = self.fresh_label("while.body");
            let end_label = self.fresh_label("while.end");

            let j0 = self.next_tmp();
            let _ = writeln!(out, "  {j0} = load i64, ptr {}, align 8", plan.idx_slot);
            let j_ok = self.next_tmp();
            let _ = writeln!(out, "  {j_ok} = icmp sge i64 {j0}, 0");

            let bound_val = match &plan.bound {
                WhileBoundKind::Var(bname) => self.load_var_ssa(bname, out),
                WhileBoundKind::LenOf(aname) => self.load_array_len_ssa(aname, out),
            };
            let b_ok = self.next_tmp();
            let _ = writeln!(out, "  {b_ok} = icmp ule i64 {bound_val}, {MAX_ARRAY_LEN}");
            let jb_ok = self.next_tmp();
            let _ = writeln!(out, "  {jb_ok} = and i1 {j_ok}, {b_ok}");

            let all_ok = match &plan.stride {
                StrideVal::Const => jb_ok,
                StrideVal::Var(sname) => {
                    let sv = self.load_var_ssa(sname, out);
                    let sm1 = self.next_tmp();
                    let _ = writeln!(out, "  {sm1} = sub i64 {sv}, 1");
                    let s_ok = self.next_tmp();
                    let _ = writeln!(out, "  {s_ok} = icmp ult i64 {sm1}, {MAX_ARRAY_LEN}");
                    let comb = self.next_tmp();
                    let _ = writeln!(out, "  {comb} = and i1 {jb_ok}, {s_ok}");
                    comb
                }
            };
            self.emit_cond_br(&all_ok, &fast_cond, &slow_cond, out);

            self.start_block(&fast_cond, out);
            let jf = self.next_tmp();
            let _ = writeln!(out, "  {jf} = load i64, ptr {}, align 8", plan.idx_slot);
            let cf = self.next_tmp();
            let _ = writeln!(out, "  {cf} = icmp slt i64 {jf}, {bound_val}");
            self.emit_cond_br(&cf, &fast_body, &end_label, out);

            self.start_block(&fast_body, out);
            let outer_depth = self.scopes.len();
            let outer_rdepth = self.region_stack.len();
            self.push_scope();
            self.loop_bounds.push(plan.proven_bound);
            self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
                break_label: end_label.clone(),
                continue_label: fast_cond.clone(),
                scope_depth: outer_depth,
                region_depth: outer_rdepth,
            });
            self.gen_block(body, out)?;
            self.loop_stack.pop();
            self.loop_bounds.pop();
            self.pop_scope_with_drops(out);
            if !self.terminated {
                self.emit_br(&fast_cond, out);
            }

            self.start_block(&slow_cond, out);
            let cond_val = self.eval_cond_bool(cond, "while", out)?;
            self.flush_stmt_temps(out);
            self.emit_cond_br(&cond_val, &slow_body, &end_label, out);

            self.start_block(&slow_body, out);
            let outer_depth = self.scopes.len();
            let outer_rdepth = self.region_stack.len();
            self.push_scope();
            self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
                break_label: end_label.clone(),
                continue_label: slow_cond.clone(),
                scope_depth: outer_depth,
                region_depth: outer_rdepth,
            });
            self.gen_block(body, out)?;
            self.loop_stack.pop();
            self.pop_scope_with_drops(out);
            if !self.terminated {
                self.emit_br(&slow_cond, out);
            }

            self.start_block(&end_label, out);
            return Ok(());
        }

        let cond_label = self.fresh_label("while.cond");
        let body_label = self.fresh_label("while.body");
        let end_label = self.fresh_label("while.end");

        self.emit_br(&cond_label, out);

        self.start_block(&cond_label, out);
        let cond_val = self.eval_cond_bool(cond, "while", out)?;
        self.flush_stmt_temps(out);
        self.emit_cond_br(&cond_val, &body_label, &end_label, out);

        self.start_block(&body_label, out);
        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        let breaks_before = self.break_count;
        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_label.clone(),
            continue_label: cond_label.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&cond_label, out);
        }

        let always_true = matches!(&cond.kind, ExprKind::Bool(true));
        let had_break = self.break_count > breaks_before;

        self.start_block(&end_label, out);
        if always_true && !had_break {
            let _ = writeln!(out, "  unreachable");
            self.terminated = true;
        }
        Ok(())
    }

    /// `for ...: ..., else: ...` — the `else` body runs only when the loop completed without a
    /// `break`. The compiled loop is wrapped in a scope whose loop entry carries a `break` flag:
    ///
    /// ```text
    ///   store i1 true, ptr %flag
    ///   <loop>              ; every `break` stores false into %flag
    ///   %ok = load i1, ptr %flag
    ///   br i1 %ok, label %else, label %done
    /// ```
    /// `for x in iterable: ... else: ...` — the `else` body runs only when the loop finished
    /// without a `break`, so the loop's label entry carries a one-shot completion flag.
    pub(super) fn gen_foreach_else(
        &mut self,
        var: &str,
        iter: &Expr,
        body: &[Stmt],
        else_body: &[Stmt],
        out: &mut String,
    ) -> Result<()> {
        let flag = self.next_slot("forelse.flag");
        let _ = writeln!(self.allocas, "  {flag} = alloca i1, align 8");
        let _ = writeln!(out, "  store i1 true, ptr {flag}, align 8");
        self.pending_break_flag = Some(flag.clone());
        self.gen_foreach(var, iter, body, out)?;
        // A `break` already cleared the flag and jumped past the body; anything else flows here.
        let ok = self.next_tmp();
        let _ = writeln!(out, "  {ok} = load i1, ptr {flag}, align 8");
        let else_lbl = self.fresh_label("forelse.then");
        let done_lbl = self.fresh_label("forelse.done");
        self.emit_cond_br(&ok, &else_lbl, &done_lbl, out);
        self.start_block(&else_lbl, out);
        self.gen_block(else_body, out)?;
        if !self.terminated {
            self.emit_br(&done_lbl, out);
        }
        self.start_block(&done_lbl, out);
        Ok(())
    }

    /// `for i in start..end: ... else: ...` — the `else` body runs only when the loop ran to
    /// completion without a `break`.
    #[allow(clippy::too_many_arguments)]
    pub(super) fn gen_for_else(
        &mut self,
        var: &str,
        start: &Expr,
        end: &Expr,
        step: Option<&Expr>,
        body: &[Stmt],
        else_body: &[Stmt],
        out: &mut String,
    ) -> Result<()> {
        let needs_flag = stmts_contain_break(body);
        let flag = if needs_flag {
            let f = self.next_slot("forelse.flag");
            let _ = writeln!(self.allocas, "  {f} = alloca i1, align 8");
            let _ = writeln!(out, "  store i1 true, ptr {f}, align 8");
            self.pending_break_flag = Some(f.clone());
            Some(f)
        } else {
            None
        };
        self.gen_for(var, start, end, step, body, out)?;
        // Every path that reaches here either fell out of the loop's `end` label (the body never
        // breaks, so `end` is a normal-completion point) or is already a loop end.
        match &flag {
            Some(f) => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = load i1, ptr {f}, align 8");
                let else_lbl = self.fresh_label("forelse.then");
                let done_lbl = self.fresh_label("forelse.done");
                self.emit_cond_br(&ok, &else_lbl, &done_lbl, out);
                self.start_block(&else_lbl, out);
                self.gen_block(else_body, out)?;
                if !self.terminated {
                    self.emit_br(&done_lbl, out);
                }
                self.start_block(&done_lbl, out);
            }
            None => {
                self.gen_block(else_body, out)?;
            }
        }
        Ok(())
    }

    pub(super) fn gen_for(
        &mut self,
        var: &str,
        start: &Expr,
        end: &Expr,
        step_opt: Option<&Expr>,
        body: &[Stmt],
        out: &mut String,
    ) -> Result<()> {
        let (start_ty, raw_start) = self.eval_expr(start, out)?;
        let start_val = if start_ty == Type::Int {
            raw_start
        } else if start_ty == Type::Any {
            self.emit_unbox_any(&Type::Int, &raw_start, start.span, out)?
        } else {
            return Err(Diagnostic::new("`for` start must be an `int`", start.span));
        };
        let (end_ty, raw_end) = self.eval_expr(end, out)?;
        let end_val = if end_ty == Type::Int {
            raw_end
        } else if end_ty == Type::Any {
            self.emit_unbox_any(&Type::Int, &raw_end, end.span, out)?
        } else {
            return Err(Diagnostic::new("`for` end must be an `int`", end.span));
        };

        enum StepDir {
            PosConst,
            NegConst,
            Dynamic(String),
        }

        let (step_val, step_dir, step_guaranteed_safe) = if let Some(se) = step_opt {
            let (sty, raw_step) = self.eval_expr(se, out)?;
            let sval = if sty == Type::Int {
                raw_step
            } else if sty == Type::Any {
                self.emit_unbox_any(&Type::Int, &raw_step, se.span, out)?
            } else {
                return Err(Diagnostic::new("`for` step must be an `int`", se.span));
            };
            if let Some(c) = eval_const_int(se) {
                if c == 0 {
                    return Err(Diagnostic::new("`for` / `range()` step cannot be zero", se.span));
                }
                if c > 0 {
                    if c > MAX_ARRAY_LEN {
                        return Err(Diagnostic::new(
                            format!("`for` step `{c}` exceeds maximum range stride"),
                            se.span,
                        ));
                    }
                    (sval, StepDir::PosConst, true)
                } else {
                    (sval, StepDir::NegConst, false)
                }
            } else {
                self.used_zero_step_fail = true;
                let is_zero = self.next_tmp();
                let _ = writeln!(out, "  {is_zero} = icmp eq i64 {sval}, 0");
                let ok_lbl = self.fresh_label("step.ok");
                let bad_lbl = self.fresh_label("step.bad");
                self.emit_cond_br(&is_zero, &bad_lbl, &ok_lbl, out);
                self.start_block(&bad_lbl, out);
                let _ = writeln!(out, "  call void @archx_zero_step_fail()");
                let _ = writeln!(out, "  unreachable");
                self.terminated = true;
                self.start_block(&ok_lbl, out);
                let is_pos = self.next_tmp();
                let _ = writeln!(out, "  {is_pos} = icmp sgt i64 {sval}, 0");
                (sval, StepDir::Dynamic(is_pos), false)
            }
        } else {
            ("1".to_string(), StepDir::PosConst, true)
        };
        self.flush_stmt_temps(out);


        let is_pos_const = matches!(step_dir, StepDir::PosConst);
        let iv_reassigned = stmts_assign_var(body, var);
        let bounded_end = eval_const_int(end).map_or(false, |e| e <= MAX_ARRAY_LEN)
            || matches!(&end.kind, ExprKind::Var(v) if self.is_bounded_var(v) && !stmts_assign_var(body, v))
            || matches!(&end.kind, ExprKind::Call { name, args } if name == "len" && args.len() == 1);
        let can_nsw =
            is_pos_const && !iv_reassigned && (step_val == "1" || (step_guaranteed_safe && bounded_end));
        let proven_bound = if can_nsw {
            self.derive_for_bound(var, start, end, body)
        } else {
            None
        };

        let extra_arrays = if is_pos_const
            && !iv_reassigned
            && step_val == "1"
            && eval_const_int(start).map_or(false, |s| s >= 0)
            && !stmts_contain_loop(body)
        {
            if let Some(b) = &proven_bound {
                self.loop_bounds.push(b.clone());
            }
            let found = self.collect_unchecked_for_arrays(var, body);
            if proven_bound.is_some() {
                self.loop_bounds.pop();
            }
            found
        } else {
            Vec::new()
        };

        let slot = self.next_slot(&format!("for.{var}"));
        let _ = writeln!(self.allocas, "  {slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 {start_val}, ptr {slot}, align 8");
        // Python's loop variable keeps the last value the body *saw*, so the binding reads this
        // slot (written at the top of every iteration) rather than the induction variable, which
        // has already been stepped once the loop exits.
        let last_slot = self.next_slot(&format!("for.last.{var}"));
        let _ = writeln!(self.allocas, "  {last_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 {start_val}, ptr {last_slot}, align 8");

        if !extra_arrays.is_empty() && extra_arrays.len() <= 8 {
            let mut guard: Option<String> = None;
            for arr_name in &extra_arrays {
                let alen = self.load_array_len_ssa(arr_name, out);
                let fit = self.next_tmp();
                let _ = writeln!(out, "  {fit} = icmp ule i64 {end_val}, {alen}");
                guard = Some(match guard {
                    None => fit,
                    Some(prev) => {
                        let both = self.next_tmp();
                        let _ = writeln!(out, "  {both} = and i1 {prev}, {fit}");
                        both
                    }
                });
            }

            let fast_cond = self.fresh_label("for.fast.cond");
            let fast_body = self.fresh_label("for.fast.body");
            let fast_step = self.fresh_label("for.fast.step");
            let slow_cond = self.fresh_label("for.cond");
            let slow_body = self.fresh_label("for.body");
            let slow_step = self.fresh_label("for.step");
            let end_label = self.fresh_label("for.end");

            self.emit_cond_br(&guard.unwrap(), &fast_cond, &slow_cond, out);

            self.start_block(&fast_cond, out);
            let fi = self.next_tmp();
            let _ = writeln!(out, "  {fi} = load i64, ptr {slot}, align 8");
            let fcmp = self.next_tmp();
            let _ = writeln!(out, "  {fcmp} = icmp slt i64 {fi}, {end_val}");
            self.emit_cond_br(&fcmp, &fast_body, &end_label, out);

            self.start_block(&fast_body, out);
            let outer_depth = self.scopes.len();
            let outer_rdepth = self.region_stack.len();
            let _ = writeln!(out, "  store i64 {fi}, ptr {last_slot}, align 8");
            bind_loop_var(self, var, Type::Int, last_slot.clone(), outer_rdepth);
            self.push_scope();
            let mut pushed_bounds = 0usize;
            if let Some(b) = &proven_bound {
                self.loop_bounds.push(b.clone());
                pushed_bounds += 1;
            }
            for arr_name in &extra_arrays {
                self.loop_bounds.push(InductionBound {
                    var: var.to_string(),
                    upper: UpperBound::LenOf(arr_name.clone()),
                });
                pushed_bounds += 1;
            }
            self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
                break_label: end_label.clone(),
                continue_label: fast_step.clone(),
                scope_depth: outer_depth,
                region_depth: outer_rdepth,
            });
            self.gen_block(body, out)?;
            self.loop_stack.pop();
            for _ in 0..pushed_bounds {
                self.loop_bounds.pop();
            }
            self.pop_scope_with_drops(out);
            if !self.terminated {
                self.emit_br(&fast_step, out);
            }

            self.start_block(&fast_step, out);
            let fi2 = self.next_tmp();
            let _ = writeln!(out, "  {fi2} = load i64, ptr {slot}, align 8");
            let fnext = self.next_tmp();
            let _ = writeln!(out, "  {fnext} = add nsw i64 {fi2}, 1");
            let _ = writeln!(out, "  store i64 {fnext}, ptr {slot}, align 8");
            self.emit_br(&fast_cond, out);

            self.start_block(&slow_cond, out);
            let si = self.next_tmp();
            let _ = writeln!(out, "  {si} = load i64, ptr {slot}, align 8");
            let scmp = self.next_tmp();
            let _ = writeln!(out, "  {scmp} = icmp slt i64 {si}, {end_val}");
            self.emit_cond_br(&scmp, &slow_body, &end_label, out);

            self.start_block(&slow_body, out);
            let outer_depth = self.scopes.len();
            let outer_rdepth = self.region_stack.len();
            let _ = writeln!(out, "  store i64 {si}, ptr {last_slot}, align 8");
            // Python keeps the loop variable bound after the loop: bind it at function scope.
            bind_loop_var(self, var, Type::Int, last_slot.clone(), outer_rdepth);
            self.push_scope();
            if let Some(b) = &proven_bound {
                self.loop_bounds.push(b.clone());
            }
            self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
                break_label: end_label.clone(),
                continue_label: slow_step.clone(),
                scope_depth: outer_depth,
                region_depth: outer_rdepth,
            });
            self.gen_block(body, out)?;
            self.loop_stack.pop();
            if proven_bound.is_some() {
                self.loop_bounds.pop();
            }
            self.pop_scope_with_drops(out);
            if !self.terminated {
                self.emit_br(&slow_step, out);
            }

            self.start_block(&slow_step, out);
            let si2 = self.next_tmp();
            let _ = writeln!(out, "  {si2} = load i64, ptr {slot}, align 8");
            let snext = self.next_tmp();
            let _ = writeln!(out, "  {snext} = add nsw i64 {si2}, 1");
            let _ = writeln!(out, "  store i64 {snext}, ptr {slot}, align 8");
            self.emit_br(&slow_cond, out);

            self.start_block(&end_label, out);
            return Ok(());
        }

        let cond_label = self.fresh_label("for.cond");
        let body_label = self.fresh_label("for.body");
        let step_label = self.fresh_label("for.step");
        let end_label = self.fresh_label("for.end");

        self.emit_br(&cond_label, out);

        self.start_block(&cond_label, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {slot}, align 8");
        let cmp = match &step_dir {
            StepDir::PosConst => {
                let c = self.next_tmp();
                let _ = writeln!(out, "  {c} = icmp slt i64 {i}, {end_val}");
                c
            }
            StepDir::NegConst => {
                let c = self.next_tmp();
                let _ = writeln!(out, "  {c} = icmp sgt i64 {i}, {end_val}");
                c
            }
            StepDir::Dynamic(is_pos) => {
                let lt = self.next_tmp();
                let gt = self.next_tmp();
                let c = self.next_tmp();
                let _ = writeln!(out, "  {lt} = icmp slt i64 {i}, {end_val}");
                let _ = writeln!(out, "  {gt} = icmp sgt i64 {i}, {end_val}");
                let _ = writeln!(out, "  {c} = select i1 {is_pos}, i1 {lt}, i1 {gt}");
                c
            }
        };
        self.emit_cond_br(&cmp, &body_label, &end_label, out);

        self.start_block(&body_label, out);
        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        // Python keeps the loop variable bound after the loop (`for i in ...` then `print(i)`),
        // so it lives in the enclosing scope and a fresh `for i` simply rebinds it.
        let _ = writeln!(out, "  store i64 {i}, ptr {last_slot}, align 8");
        bind_loop_var(self, var, Type::Int, last_slot.clone(), outer_rdepth);
        self.push_scope();
        if let Some(bound) = &proven_bound {
            self.loop_bounds.push(bound.clone());
        }
        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_label.clone(),
            continue_label: step_label.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        if proven_bound.is_some() {
            self.loop_bounds.pop();
        }
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_label, out);
        }

        self.start_block(&step_label, out);
        let i2 = self.next_tmp();
        let _ = writeln!(out, "  {i2} = load i64, ptr {slot}, align 8");
        let next = self.next_tmp();
        if can_nsw {
            let _ = writeln!(out, "  {next} = add nsw i64 {i2}, {step_val}");
        } else {
            let _ = writeln!(out, "  {next} = add i64 {i2}, {step_val}");
        }
        let _ = writeln!(out, "  store i64 {next}, ptr {slot}, align 8");
        self.emit_br(&cond_label, out);

        self.start_block(&end_label, out);
        Ok(())
    }

    pub(super) fn gen_foreach(
        &mut self,
        var: &str,
        iter: &Expr,
        body: &[Stmt],
        out: &mut String,
    ) -> Result<()> {

        if let ExprKind::Var(aname) = &iter.kind {
            if let Some(entry) = self.lookup_var(aname).cloned() {
                if let VarStorage::Soa {
                    struct_name,
                    len_val,
                    planes,
                } = entry.storage
                {
                    let idx_slot = self.next_slot("foreach.idx");
                    let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
                    let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

                    let cond_lbl = self.fresh_label("foreach.cond");
                    let body_lbl = self.fresh_label("foreach.body");
                    let step_lbl = self.fresh_label("foreach.step");
                    let end_lbl = self.fresh_label("foreach.end");

                    self.emit_br(&cond_lbl, out);
                    self.start_block(&cond_lbl, out);
                    let cur = self.next_tmp();
                    let _ = writeln!(out, "  {cur} = load i64, ptr {idx_slot}, align 8");
                    let cmp = self.next_tmp();
                    let _ = writeln!(out, "  {cmp} = icmp slt i64 {cur}, {len_val}");
                    self.emit_cond_br(&cmp, &body_lbl, &end_lbl, out);

                    self.start_block(&body_lbl, out);
                    let elem_ty = Type::Struct(struct_name.clone());
                    let elem_val = self.load_soa_struct_at(&struct_name, &planes, &cur, out);

                    let outer_depth = self.scopes.len();
                    let outer_rdepth = self.region_stack.len();
                    self.push_scope();
                    let storage = if self.mutated_vars.contains(var) {
                        let sptr = self.next_slot(&format!("var.{var}"));
                        let ty_ir = ir_type(&elem_ty);
                        let _ = writeln!(self.allocas, "  {sptr} = alloca {ty_ir}, align 8");
                        let _ = writeln!(out, "  store {ty_ir} {elem_val}, ptr {sptr}, align 8");
                        VarStorage::Slot(sptr)
                    } else {
                        VarStorage::Imm(elem_val)
                    };
                    bind_fn_scope(self, 
                        var.to_string(),
                        VarEntry {
                            ty: elem_ty,
                            storage,
                            is_param: false,
                            region_depth: outer_rdepth,
                        },
                    );
                    self.loop_stack.push(LoopLabels {
                        break_flag: self.pending_break_flag.take(),
                        break_label: end_lbl.clone(),
                        continue_label: step_lbl.clone(),
                        scope_depth: outer_depth,
                        region_depth: outer_rdepth,
                    });
                    self.gen_block(body, out)?;
                    self.loop_stack.pop();
                    self.pop_scope_with_drops(out);
                    if !self.terminated {
                        self.emit_br(&step_lbl, out);
                    }

                    self.start_block(&step_lbl, out);
                    let cur2 = self.next_tmp();
                    let _ = writeln!(out, "  {cur2} = load i64, ptr {idx_slot}, align 8");
                    let next = self.next_tmp();
                    let _ = writeln!(out, "  {next} = add nsw i64 {cur2}, 1");
                    let _ = writeln!(out, "  store i64 {next}, ptr {idx_slot}, align 8");
                    self.emit_br(&cond_lbl, out);

                    self.start_block(&end_lbl, out);
                    return Ok(());
                }
            }
        }

        let (iter_ty, iter_val) = self.eval_expr(iter, out)?;
        if iter_ty == Type::Str {
            return self.gen_foreach_str(var, iter, &iter_val, body, out);
        }
        if let Type::Dict(k_ty, _) | Type::Set(k_ty) = &iter_ty {
            return self.gen_foreach_dict_keys(var, &iter_ty, &k_ty.clone(), &iter_val, body, out);
        }
        if iter_ty == Type::Any {
            return self.gen_foreach_any(var, &iter_val, body, out);
        }
        let Type::Array(elem_ty) = iter_ty.clone() else {
            return Err(Diagnostic::new(
                format!(
                    "`for ... in` expects a `list`, `dict`, `set`, or `str`, found `{}`",
                    iter_ty.name()
                ),
                iter.span,
            ));
        };

        let hold_outer_scope = self.claim_stmt_temp(&iter_val);
        self.flush_stmt_temps(out);
        if hold_outer_scope {
            let hslot = self.next_slot("foreach.iter");
            let _ = writeln!(self.allocas, "  {hslot} = alloca %ArchxVec, align 8");
            let _ = writeln!(out, "  store %ArchxVec {iter_val}, ptr {hslot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: hslot,
                    ty: iter_ty,
                });
        }

        let iter_var_mutated = matches!(
            &iter.kind,
            ExprKind::Var(n) if stmts_mutate_array_len(body, n, &self.mutating_method_names)
        );
        if iter_var_mutated {
            return Err(Diagnostic::new(
                "cannot resize array via `push`/`pop`/reassignment while iterating over it",
                iter.span,
            ));
        }

        let len_val = self.next_tmp();
        let _ = writeln!(out, "  {len_val} = extractvalue %ArchxVec {iter_val}, 0");
        let data_ptr = self.next_tmp();
        let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {iter_val}, 2");

        let idx_slot = self.next_slot("foreach.idx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

        // The loop variable lives in the enclosing scope (Python rebinds it there), so its storage
        // outlives a single iteration. Every iteration stores a fresh clone into it, so the previous
        // iteration's payload has to be released first. Initialising to zero makes the first
        // iteration's drop a no-op (`len == 0`, `cap == 0`).
        let loop_var_slot = self.next_slot(&format!("var.{var}"));
        let loop_var_ty_ir = ir_type(&elem_ty);
        let loop_var_align = ir_align(&elem_ty);
        let loop_var_owns = self.type_needs_drop(&elem_ty);
        let _ = writeln!(
            self.allocas,
            "  {loop_var_slot} = alloca {loop_var_ty_ir}, align {loop_var_align}"
        );
        if loop_var_owns {
            let _ = writeln!(
                out,
                "  store {loop_var_ty_ir} zeroinitializer, ptr {loop_var_slot}, align {loop_var_align}"
            );
        }

        let cond_lbl = self.fresh_label("foreach.cond");
        let body_lbl = self.fresh_label("foreach.body");
        let step_lbl = self.fresh_label("foreach.step");
        let end_lbl = self.fresh_label("foreach.end");

        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load i64, ptr {idx_slot}, align 8");
        let cmp = self.next_tmp();
        let _ = writeln!(out, "  {cmp} = icmp slt i64 {cur}, {len_val}");
        self.emit_cond_br(&cmp, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);

        let mem_ty = elem_mem_ir_type(&elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {cur}"
        );
        let raw_elem = self.emit_elem_load(&elem_ty, &ep, out);

        // Python binds the loop variable in the *enclosing* scope (`for x in xs:` then `print(x)`
        // after the loop), so the slot is declared here and registered before the body scope is
        // pushed. `pop_scope_with_drops` then cannot take the binding away.
        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        let slot = loop_var_slot;
        let ty_ir = loop_var_ty_ir;
        let align = loop_var_align;
        if loop_var_owns {
            // Release the payload the previous iteration bound to this variable.
            let prev = self.next_tmp();
            let _ = writeln!(out, "  {prev} = load {ty_ir}, ptr {slot}, align {align}");
            self.emit_drop_value(&elem_ty, &prev, out);
        }
        let init_elem = if loop_var_owns {
            self.emit_clone_value(&elem_ty, &raw_elem, out)
        } else {
            raw_elem
        };
        let _ = writeln!(out, "  store {ty_ir} {init_elem}, ptr {slot}, align {align}");
        let owns = self.type_needs_drop(&elem_ty);
        bind_fn_scope(self, 
            var.to_string(),
            VarEntry {
                ty: (*elem_ty).clone(),
                storage: VarStorage::Slot(slot.clone()),
                is_param: false,
                region_depth: outer_rdepth,
            },
        );
        if owns {
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: slot.clone(),
                    ty: (*elem_ty).clone(),
                });
        }
        self.push_scope();
        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_lbl.clone(),
            continue_label: step_lbl.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_lbl, out);
        }

        self.start_block(&step_lbl, out);
        let cur2 = self.next_tmp();
        let _ = writeln!(out, "  {cur2} = load i64, ptr {idx_slot}, align 8");
        let next = self.next_tmp();
        let _ = writeln!(out, "  {next} = add nsw i64 {cur2}, 1");
        let _ = writeln!(out, "  store i64 {next}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        Ok(())
    }

    pub(super) fn load_var_ssa(&mut self, name: &str, out: &mut String) -> String {
        let entry = self.lookup_var(name).cloned().expect("var exists");
        match entry.storage {
            VarStorage::Imm(val) => val,
            VarStorage::Slot(ptr) => {
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = load {}, ptr {ptr}, align {}",
                    ir_type(&entry.ty),
                    ir_align(&entry.ty)
                );
                reg
            }
            VarStorage::Soa { .. } => unreachable!("SoA has no single SSA aggregate"),
        }
    }

    pub(super) fn load_array_len_ssa(&mut self, name: &str, out: &mut String) -> String {
        let entry = self.lookup_var(name).cloned().expect("array var exists");
        match entry.storage {
            VarStorage::Soa { len_val, .. } => len_val,
            VarStorage::Imm(val) => {
                let l = self.next_tmp();
                let _ = writeln!(out, "  {l} = extractvalue %ArchxVec {val}, 0");
                l
            }
            VarStorage::Slot(ptr) => {
                let v = self.next_tmp();
                let _ = writeln!(out, "  {v} = load %ArchxVec, ptr {ptr}, align 8");
                let l = self.next_tmp();
                let _ = writeln!(out, "  {l} = extractvalue %ArchxVec {v}, 0");
                l
            }
        }
    }

    pub(super) fn gen_foreach_str(
        &mut self,
        var: &str,
        iter: &Expr,
        iter_val: &str,
        body: &[Stmt],
        out: &mut String,
    ) -> Result<()> {
        if matches!(
            &iter.kind,
            ExprKind::Var(n) if stmts_mutate_array_len(body, n, &self.mutating_method_names)
        ) {
            return Err(Diagnostic::new(
                "cannot reassign string variable while iterating over it",
                iter.span,
            ));
        }

        let hold_outer_scope = self.claim_stmt_temp(iter_val);
        self.flush_stmt_temps(out);
        if hold_outer_scope {
            self.push_scope();
            let hslot = self.next_slot("foreach.str");
            let _ = writeln!(self.allocas, "  {hslot} = alloca %ArchxStr, align 8");
            let _ = writeln!(out, "  store %ArchxStr {iter_val}, ptr {hslot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: hslot,
                    ty: Type::Str,
                });
        }

        let w0 = self.next_tmp();
        let _ = writeln!(out, "  {w0} = extractvalue %ArchxStr {iter_val}, 0");
        let len_val = self.next_tmp();
        let _ = writeln!(out, "  {len_val} = and i64 {w0}, 4294967295");

        let idx_slot = self.next_slot("foreach.sidx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

        let cond_lbl = self.fresh_label("foreach.scond");
        let body_lbl = self.fresh_label("foreach.sbody");
        let step_lbl = self.fresh_label("foreach.sstep");
        let end_lbl = self.fresh_label("foreach.send");

        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load i64, ptr {idx_slot}, align 8");
        let cmp = self.next_tmp();
        let _ = writeln!(out, "  {cmp} = icmp slt i64 {cur}, {len_val}");
        self.emit_cond_br(&cmp, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        self.used_str_byte_at = true;
        let ch_val = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ch_val} = call fastcc %ArchxStr @archx_str_byte_at(%ArchxStr {iter_val}, i64 {cur})"
        );

        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        let var_mutated = self.mutated_vars.contains(var);
        let storage = if var_mutated {
            let sptr = self.next_slot(&format!("var.{var}"));
            let _ = writeln!(self.allocas, "  {sptr} = alloca %ArchxStr, align 8");
            let _ = writeln!(out, "  store %ArchxStr {ch_val}, ptr {sptr}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: sptr.clone(),
                    ty: Type::Str,
                });
            VarStorage::Slot(sptr)
        } else {
            VarStorage::Imm(ch_val)
        };
        // Function-scoped like every other loop variable (Python semantics). The character is an
        // SSA value defined inside the loop, so it must live in a slot: binding the value directly
        // would leak a definition that does not dominate the code after the loop.
        let var_slot = match &storage {
            VarStorage::Slot(p) => p.clone(),
            VarStorage::Imm(v) => {
                let sptr = self.next_slot(&format!("var.{var}"));
                let _ = writeln!(self.allocas, "  {sptr} = alloca %ArchxStr, align 8");
                let _ = writeln!(out, "  store %ArchxStr {v}, ptr {sptr}, align 8");
                sptr
            }
            VarStorage::Soa { .. } => unreachable!(),
        };
        self.scopes[0].vars.insert(
            var.to_string(),
            VarEntry {
                ty: Type::Str,
                storage: VarStorage::Slot(var_slot),
                is_param: !var_mutated,
                region_depth: outer_rdepth,
            },
        );
        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_lbl.clone(),
            continue_label: step_lbl.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_lbl, out);
        }

        self.start_block(&step_lbl, out);
        let cur2 = self.next_tmp();
        let _ = writeln!(out, "  {cur2} = load i64, ptr {idx_slot}, align 8");
        let next = self.next_tmp();
        let _ = writeln!(out, "  {next} = add nsw i64 {cur2}, 1");
        let _ = writeln!(out, "  store i64 {next}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        if hold_outer_scope {
            self.pop_scope_with_drops(out);
        }
        Ok(())
    }

    pub(super) fn gen_for_enumerate(
        &mut self,
        idx_var: &str,
        elem_var: &str,
        iter: &Expr,
        start_opt: Option<&Expr>,
        body: &[Stmt],
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if idx_var == elem_var {
            return Err(Diagnostic::new(
                format!("duplicate loop variable `{idx_var}` in `enumerate`"),
                span,
            ));
        }

        let start_val = if let Some(se) = start_opt {
            let (sty, sval) = self.eval_expr(se, out)?;
            if sty != Type::Int {
                return Err(Diagnostic::new(
                    format!("`enumerate` start must be `int`, found `{}`", sty.name()),
                    se.span,
                ));
            }
            sval
        } else {
            "0".to_string()
        };

        if let ExprKind::Var(aname) = &iter.kind {
            if let Some(entry) = self.lookup_var(aname).cloned() {
                if let VarStorage::Soa {
                    struct_name,
                    len_val,
                    planes,
                } = entry.storage
                {
                    let pos_slot = self.next_slot("enum.pos");
                    let _ = writeln!(self.allocas, "  {pos_slot} = alloca i64, align 8");
                    let _ = writeln!(out, "  store i64 0, ptr {pos_slot}, align 8");

                    let cond_lbl = self.fresh_label("enum.cond");
                    let body_lbl = self.fresh_label("enum.body");
                    let step_lbl = self.fresh_label("enum.step");
                    let end_lbl = self.fresh_label("enum.end");

                    self.emit_br(&cond_lbl, out);
                    self.start_block(&cond_lbl, out);
                    let cur = self.next_tmp();
                    let _ = writeln!(out, "  {cur} = load i64, ptr {pos_slot}, align 8");
                    let cmp = self.next_tmp();
                    let _ = writeln!(out, "  {cmp} = icmp slt i64 {cur}, {len_val}");
                    self.emit_cond_br(&cmp, &body_lbl, &end_lbl, out);

                    self.start_block(&body_lbl, out);
                    let user_idx = if start_val == "0" {
                        cur.clone()
                    } else {
                        let sum = self.next_tmp();
                        let _ = writeln!(out, "  {sum} = add i64 {start_val}, {cur}");
                        sum
                    };
                    let elem_ty = Type::Struct(struct_name.clone());
                    let elem_val = self.load_soa_struct_at(&struct_name, &planes, &cur, out);

                    let outer_depth = self.scopes.len();
                    let outer_rdepth = self.region_stack.len();
                    self.push_scope();
                    let idx_storage = if self.mutated_vars.contains(idx_var) {
                        let islot = self.next_slot(&format!("var.{idx_var}"));
                        let _ = writeln!(self.allocas, "  {islot} = alloca i64, align 8");
                        let _ = writeln!(out, "  store i64 {user_idx}, ptr {islot}, align 8");
                        VarStorage::Slot(islot)
                    } else {
                        VarStorage::Imm(user_idx)
                    };
                    let elem_storage = if self.mutated_vars.contains(elem_var) {
                        let eslot = self.next_slot(&format!("var.{elem_var}"));
                        let ty_ir = ir_type(&elem_ty);
                        let _ = writeln!(self.allocas, "  {eslot} = alloca {ty_ir}, align 8");
                        let _ = writeln!(out, "  store {ty_ir} {elem_val}, ptr {eslot}, align 8");
                        VarStorage::Slot(eslot)
                    } else {
                        VarStorage::Imm(elem_val)
                    };
                    bind_fn_scope(self, 
                        idx_var.to_string(),
                        VarEntry {
                            ty: Type::Int,
                            storage: idx_storage,
                            is_param: false,
                            region_depth: outer_rdepth,
                        },
                    );
                    bind_fn_scope(self, 
                        elem_var.to_string(),
                        VarEntry {
                            ty: elem_ty,
                            storage: elem_storage,
                            is_param: false,
                            region_depth: outer_rdepth,
                        },
                    );
                    let pushed_bound = start_opt.is_none() && !stmts_assign_var(body, idx_var);
                    if pushed_bound {
                        self.loop_bounds.push(InductionBound {
                            var: idx_var.to_string(),
                            upper: UpperBound::LenOf(aname.clone()),
                        });
                    }
                    self.loop_stack.push(LoopLabels {
                        break_flag: self.pending_break_flag.take(),
                        break_label: end_lbl.clone(),
                        continue_label: step_lbl.clone(),
                        scope_depth: outer_depth,
                        region_depth: outer_rdepth,
                    });
                    self.gen_block(body, out)?;
                    self.loop_stack.pop();
                    if pushed_bound {
                        self.loop_bounds.pop();
                    }
                    self.pop_scope_with_drops(out);
                    if !self.terminated {
                        self.emit_br(&step_lbl, out);
                    }

                    self.start_block(&step_lbl, out);
                    let cur2 = self.next_tmp();
                    let _ = writeln!(out, "  {cur2} = load i64, ptr {pos_slot}, align 8");
                    let next = self.next_tmp();
                    let _ = writeln!(out, "  {next} = add nsw i64 {cur2}, 1");
                    let _ = writeln!(out, "  store i64 {next}, ptr {pos_slot}, align 8");
                    self.emit_br(&cond_lbl, out);

                    self.start_block(&end_lbl, out);
                    return Ok(());
                }
            }
        }

        let (iter_ty, iter_val) = self.eval_expr(iter, out)?;
        let is_str = iter_ty == Type::Str;
        let elem_ty = match &iter_ty {
            Type::Array(inner) => (**inner).clone(),
            Type::Str => Type::Str,
            _ => {
                return Err(Diagnostic::new(
                    format!(
                        "`enumerate()` expects a `list` or `str`, found `{}`",
                        iter_ty.name()
                    ),
                    iter.span,
                ));
            }
        };

        let hold_outer_scope = self.claim_stmt_temp(&iter_val);
        self.flush_stmt_temps(out);
        if hold_outer_scope {
            self.push_scope();
            let hslot = self.next_slot("enum.iter");
            let ty_ir = ir_type(&iter_ty);
            let _ = writeln!(self.allocas, "  {hslot} = alloca {ty_ir}, align 8");
            let _ = writeln!(out, "  store {ty_ir} {iter_val}, ptr {hslot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: hslot,
                    ty: iter_ty.clone(),
                });
        }

        if matches!(
            &iter.kind,
            ExprKind::Var(n) if stmts_mutate_array_len(body, n, &self.mutating_method_names)
        ) {
            return Err(Diagnostic::new(
                "cannot resize or reassign sequence while iterating over it",
                iter.span,
            ));
        }

        let (len_val, data_ptr) = if is_str {
            let w0 = self.next_tmp();
            let _ = writeln!(out, "  {w0} = extractvalue %ArchxStr {iter_val}, 0");
            let l64 = self.next_tmp();
            let _ = writeln!(out, "  {l64} = and i64 {w0}, 4294967295");
            (l64, String::new())
        } else {
            let lv = self.next_tmp();
            let _ = writeln!(out, "  {lv} = extractvalue %ArchxVec {iter_val}, 0");
            let dp = self.next_tmp();
            let _ = writeln!(out, "  {dp} = extractvalue %ArchxVec {iter_val}, 2");
            (lv, dp)
        };

        let pos_slot = self.next_slot("enum.pos");
        let _ = writeln!(self.allocas, "  {pos_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {pos_slot}, align 8");

        let cond_lbl = self.fresh_label("enum.cond");
        let body_lbl = self.fresh_label("enum.body");
        let step_lbl = self.fresh_label("enum.step");
        let end_lbl = self.fresh_label("enum.end");

        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load i64, ptr {pos_slot}, align 8");
        let cmp = self.next_tmp();
        let _ = writeln!(out, "  {cmp} = icmp slt i64 {cur}, {len_val}");
        self.emit_cond_br(&cmp, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let user_idx = if start_val == "0" {
            cur.clone()
        } else {
            let sum = self.next_tmp();
            let _ = writeln!(out, "  {sum} = add i64 {start_val}, {cur}");
            sum
        };

        let raw_elem = if is_str {
            self.used_str_byte_at = true;
            let ch = self.next_tmp();
            let _ = writeln!(
                out,
                "  {ch} = call fastcc %ArchxStr @archx_str_byte_at(%ArchxStr {iter_val}, i64 {cur})"
            );
            ch
        } else {
            let mem_ty = elem_mem_ir_type(&elem_ty);
            let ep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {ep} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {cur}"
            );
            self.emit_elem_load(&elem_ty, &ep, out)
        };

        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        // The index is always slotted: it is function-scoped, and `user_idx` is defined inside
        // this block, so binding the SSA value directly would not dominate post-loop code.
        let idx_mut = self.mutated_vars.contains(idx_var);
        let islot = self.next_slot(&format!("var.{idx_var}"));
        let _ = writeln!(self.allocas, "  {islot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 {user_idx}, ptr {islot}, align 8");
        let idx_storage = VarStorage::Slot(islot);
        let elem_mut = self.mutated_vars.contains(elem_var);
        let elem_storage = if elem_mut {
            let init_elem = if !is_str && self.type_needs_drop(&elem_ty) {
                self.emit_clone_value(&elem_ty, &raw_elem, out)
            } else {
                raw_elem
            };
            let eslot = self.next_slot(&format!("var.{elem_var}"));
            let ty_ir = ir_type(&elem_ty);
            let align = ir_align(&elem_ty);
            let _ = writeln!(self.allocas, "  {eslot} = alloca {ty_ir}, align {align}");
            let _ = writeln!(out, "  store {ty_ir} {init_elem}, ptr {eslot}, align {align}");
            if self.type_needs_drop(&elem_ty) {
                self.scopes
                    .last_mut()
                    .unwrap()
                    .owned_buffers
                    .push(DropTarget::TypedSlot {
                        ptr: eslot.clone(),
                        ty: elem_ty.clone(),
                    });
            }
            VarStorage::Slot(eslot)
        } else {
            VarStorage::Imm(raw_elem)
        };

        bind_fn_scope(self, 
            idx_var.to_string(),
            VarEntry {
                ty: Type::Int,
                storage: idx_storage,
                is_param: !idx_mut,
                region_depth: outer_rdepth,
            },
        );
        // String elements are SSA values defined inside the loop, so they always need a slot
        // once they are function-scoped (`for i, ch in enumerate(s)` keeps `ch` afterwards).
        let elem_storage = if is_str {
            match elem_storage {
                VarStorage::Imm(v) => {
                    let eslot = self.next_slot(&format!("var.{elem_var}"));
                    let _ = writeln!(self.allocas, "  {eslot} = alloca %ArchxStr, align 8");
                    let _ = writeln!(out, "  store %ArchxStr {v}, ptr {eslot}, align 8");
                    VarStorage::Slot(eslot)
                }
                other => other,
            }
        } else {
            elem_storage
        };
        bind_fn_scope(self, 
            elem_var.to_string(),
            VarEntry {
                ty: elem_ty,
                storage: elem_storage,
                is_param: !elem_mut,
                region_depth: outer_rdepth,
            },
        );

        let pushed_bound = if !is_str
            && start_opt.is_none()
            && !stmts_assign_var(body, idx_var)
            && matches!(&iter.kind, ExprKind::Var(_))
        {
            if let ExprKind::Var(aname) = &iter.kind {
                self.loop_bounds.push(InductionBound {
                    var: idx_var.to_string(),
                    upper: UpperBound::LenOf(aname.clone()),
                });
                true
            } else {
                false
            }
        } else {
            false
        };

        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_lbl.clone(),
            continue_label: step_lbl.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        if pushed_bound {
            self.loop_bounds.pop();
        }
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_lbl, out);
        }

        self.start_block(&step_lbl, out);
        let cur2 = self.next_tmp();
        let _ = writeln!(out, "  {cur2} = load i64, ptr {pos_slot}, align 8");
        let next = self.next_tmp();
        let _ = writeln!(out, "  {next} = add nsw i64 {cur2}, 1");
        let _ = writeln!(out, "  store i64 {next}, ptr {pos_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        if hold_outer_scope {
            self.pop_scope_with_drops(out);
        }
        Ok(())
    }

    pub(super) fn gen_foreach_dict_keys(
        &mut self,
        var: &str,
        iter_ty: &Type,
        k_ty: &Type,
        d_val: &str,
        body: &[Stmt],
        out: &mut String,
    ) -> Result<()> {
        self.used_dict_type = true;
        let hold_outer = self.claim_stmt_temp(d_val);
        self.flush_stmt_temps(out);
        if hold_outer {
            self.push_scope();
            let hslot = self.next_slot("foreach.dict");
            let _ = writeln!(self.allocas, "  {hslot} = alloca i64, align 8");
            let _ = writeln!(out, "  store i64 {d_val}, ptr {hslot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: hslot,
                    ty: iter_ty.clone(),
                });
        }

        let len_val = self.emit_dict_len(d_val, out);
        let idx_slot = self.next_slot("foreach.dk.idx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

        let cond_lbl = self.fresh_label("foreach.dk.cond");
        let body_lbl = self.fresh_label("foreach.dk.body");
        let step_lbl = self.fresh_label("foreach.dk.step");
        let end_lbl = self.fresh_label("foreach.dk.end");

        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load i64, ptr {idx_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {cur}, {len_val}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
        let hdr = self.next_tmp();
        let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
        let kg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {kg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 5"
        );
        let kptr = self.next_tmp();
        let _ = writeln!(out, "  {kptr} = load ptr, ptr {kg}, align 8");
        let kstore = Self::dict_key_storage_ir(k_ty);
        let kep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {kep} = getelementptr inbounds {kstore}, ptr {kptr}, i64 {cur}"
        );
        let kval = self.emit_load_dict_key(k_ty, &kep, out);

        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        self.bind_loop_elem_var(var, k_ty, &kval, outer_rdepth, out);
        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_lbl.clone(),
            continue_label: step_lbl.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_lbl, out);
        }

        self.start_block(&step_lbl, out);
        let c2 = self.next_tmp();
        let _ = writeln!(out, "  {c2} = load i64, ptr {idx_slot}, align 8");
        let nxt = self.next_tmp();
        let _ = writeln!(out, "  {nxt} = add nuw nsw i64 {c2}, 1");
        let _ = writeln!(out, "  store i64 {nxt}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        if hold_outer {
            self.pop_scope_with_drops(out);
        }
        Ok(())
    }

    pub(super) fn gen_foreach_any(
        &mut self,
        var: &str,
        any_val: &str,
        body: &[Stmt],
        out: &mut String,
    ) -> Result<()> {
        self.mark_runtime_type(&Type::Any);
        self.used_any_rt = true;
        let hold_outer = self.claim_stmt_temp(any_val);
        self.flush_stmt_temps(out);
        if hold_outer {
            self.push_scope();
            let hslot = self.next_slot("foreach.any");
            let _ = writeln!(self.allocas, "  {hslot} = alloca %ArchxAny, align 8");
            let _ = writeln!(out, "  store %ArchxAny {any_val}, ptr {hslot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: hslot,
                    ty: Type::Any,
                });
        }

        let len_val = self.next_tmp();
        let _ = writeln!(
            out,
            "  {len_val} = call fastcc i64 @archx_any_len(%ArchxAny {any_val})"
        );
        let idx_slot = self.next_slot("foreach.any.idx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

        let cond_lbl = self.fresh_label("foreach.any.cond");
        let body_lbl = self.fresh_label("foreach.any.body");
        let step_lbl = self.fresh_label("foreach.any.step");
        let end_lbl = self.fresh_label("foreach.any.end");

        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load i64, ptr {idx_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {cur}, {len_val}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let tag = self.next_tmp();
        let _ = writeln!(out, "  {tag} = extractvalue %ArchxAny {any_val}, 0");
        let w1 = self.next_tmp();
        let _ = writeln!(out, "  {w1} = extractvalue %ArchxAny {any_val}, 1");
        let is_ds = self.next_tmp();
        let _ = writeln!(out, "  {is_ds} = icmp uge i64 {tag}, 6");
        let ds_lbl = self.fresh_label("foreach.any.ds");
        let ls_lbl = self.fresh_label("foreach.any.ls");
        let got_lbl = self.fresh_label("foreach.any.got");
        self.emit_cond_br(&is_ds, &ds_lbl, &ls_lbl, out);

        self.start_block(&ds_lbl, out);
        let draw = self.next_tmp();
        let _ = writeln!(out, "  {draw} = and i64 {w1}, -4");
        let dh = self.next_tmp();
        let _ = writeln!(out, "  {dh} = inttoptr i64 {draw} to ptr");
        let kg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {kg} = getelementptr inbounds %ArchxDictHdr, ptr {dh}, i32 0, i32 5"
        );
        let kp = self.next_tmp();
        let _ = writeln!(out, "  {kp} = load ptr, ptr {kg}, align 8");
        let kep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {kep} = getelementptr inbounds %ArchxAny, ptr {kp}, i64 {cur}"
        );
        let kv = self.next_tmp();
        let _ = writeln!(out, "  {kv} = load %ArchxAny, ptr {kep}, align 8");
        let kc = self.next_tmp();
        let _ = writeln!(
            out,
            "  {kc} = call fastcc %ArchxAny @archx_any_clone(%ArchxAny {kv})"
        );
        self.emit_br(&got_lbl, out);

        self.start_block(&ls_lbl, out);
        let idx_a = self.next_tmp();
        let _ = writeln!(
            out,
            "  {idx_a} = insertvalue %ArchxAny {{ i64 2, i64 0, i64 0 }}, i64 {cur}, 1"
        );
        let lv = self.next_tmp();
        let _ = writeln!(
            out,
            "  {lv} = call fastcc %ArchxAny @archx_any_get_idx(%ArchxAny {any_val}, %ArchxAny {idx_a})"
        );
        self.emit_br(&got_lbl, out);

        self.start_block(&got_lbl, out);
        let elem_any = self.next_tmp();
        let _ = writeln!(
            out,
            "  {elem_any} = phi %ArchxAny [ {kc}, %{ds_lbl} ], [ {lv}, %{ls_lbl} ]"
        );

        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        let sptr = self.next_slot(&format!("var.{var}"));
        let _ = writeln!(self.allocas, "  {sptr} = alloca %ArchxAny, align 8");
        let _ = writeln!(out, "  store %ArchxAny {elem_any}, ptr {sptr}, align 8");
        self.scopes
            .last_mut()
            .unwrap()
            .owned_buffers
            .push(DropTarget::TypedSlot {
                ptr: sptr.clone(),
                ty: Type::Any,
            });
        bind_fn_scope(self, 
            var.to_string(),
            VarEntry {
                ty: Type::Any,
                storage: VarStorage::Slot(sptr),
                is_param: false,
                region_depth: outer_rdepth,
            },
        );

        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_lbl.clone(),
            continue_label: step_lbl.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_lbl, out);
        }

        self.start_block(&step_lbl, out);
        let c2 = self.next_tmp();
        let _ = writeln!(out, "  {c2} = load i64, ptr {idx_slot}, align 8");
        let nxt = self.next_tmp();
        let _ = writeln!(out, "  {nxt} = add nuw nsw i64 {c2}, 1");
        let _ = writeln!(out, "  store i64 {nxt}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        if hold_outer {
            self.pop_scope_with_drops(out);
        }
        Ok(())
    }

    pub(super) fn gen_for_dict_items(
        &mut self,
        key_var: &str,
        val_var: &str,
        dict: &Expr,
        body: &[Stmt],
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if key_var == val_var {
            return Err(Diagnostic::new(
                format!("duplicate loop variable `{key_var}` in `for k, v in ...`"),
                span,
            ));
        }

        let (d_ty, raw_d) = self.eval_expr(dict, out)?;
        if let Type::Array(elem_ty) = &d_ty {
            if let Type::Tuple(items) = elem_ty.as_ref() {
                if items.len() == 2 {
                    return self.gen_for_tuple2_list(
                        key_var,
                        val_var,
                        &items[0],
                        &items[1],
                        &raw_d,
                        body,
                        out,
                    );
                }
            }
        }
        let (k_ty, v_ty, d_handle, hold_ty, hold_val) = match &d_ty {
            Type::Dict(k, v) => (
                (**k).clone(),
                (**v).clone(),
                raw_d.clone(),
                d_ty.clone(),
                raw_d,
            ),
            Type::Any => {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let tag = self.next_tmp();
                let _ = writeln!(out, "  {tag} = extractvalue %ArchxAny {raw_d}, 0");
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 6");
                self.emit_type_guard(&ok, "`.items()` requires a `dict` value", out);
                let w1 = self.next_tmp();
                let _ = writeln!(out, "  {w1} = extractvalue %ArchxAny {raw_d}, 1");
                (Type::Any, Type::Any, w1, Type::Any, raw_d)
            }
            _ => {
                return Err(Diagnostic::new(
                    format!("`.items()` requires a `dict`, found `{}`", d_ty.name()),
                    dict.span,
                ))
            }
        };

        self.used_dict_type = true;
        let hold_outer = self.claim_stmt_temp(&hold_val);
        self.flush_stmt_temps(out);
        if hold_outer {
            self.push_scope();
            let hslot = self.next_slot("foritems.dict");
            let hir = ir_type(&hold_ty);
            let _ = writeln!(self.allocas, "  {hslot} = alloca {hir}, align 8");
            let _ = writeln!(out, "  store {hir} {hold_val}, ptr {hslot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: hslot,
                    ty: hold_ty,
                });
        }

        let len_val = self.emit_dict_len(&d_handle, out);
        let idx_slot = self.next_slot("foritems.idx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

        let cond_lbl = self.fresh_label("foritems.cond");
        let body_lbl = self.fresh_label("foritems.body");
        let step_lbl = self.fresh_label("foritems.step");
        let end_lbl = self.fresh_label("foritems.end");

        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load i64, ptr {idx_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {cur}, {len_val}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = and i64 {d_handle}, -4");
        let hdr = self.next_tmp();
        let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
        let kg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {kg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 5"
        );
        let vg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 6"
        );
        let kptr = self.next_tmp();
        let _ = writeln!(out, "  {kptr} = load ptr, ptr {kg}, align 8");
        let vptr = self.next_tmp();
        let _ = writeln!(out, "  {vptr} = load ptr, ptr {vg}, align 8");

        let kstore = Self::dict_key_storage_ir(&k_ty);
        let kep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {kep} = getelementptr inbounds {kstore}, ptr {kptr}, i64 {cur}"
        );
        let kval = self.emit_load_dict_key(&k_ty, &kep, out);

        let vmem = elem_mem_ir_type(&v_ty);
        let vep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vep} = getelementptr inbounds {vmem}, ptr {vptr}, i64 {cur}"
        );
        let vval = self.emit_elem_load(&v_ty, &vep, out);

        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        self.bind_loop_elem_var(key_var, &k_ty, &kval, outer_rdepth, out);
        self.bind_loop_elem_var(val_var, &v_ty, &vval, outer_rdepth, out);

        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_lbl.clone(),
            continue_label: step_lbl.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_lbl, out);
        }

        self.start_block(&step_lbl, out);
        let c2 = self.next_tmp();
        let _ = writeln!(out, "  {c2} = load i64, ptr {idx_slot}, align 8");
        let nxt = self.next_tmp();
        let _ = writeln!(out, "  {nxt} = add nuw nsw i64 {c2}, 1");
        let _ = writeln!(out, "  store i64 {nxt}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        if hold_outer {
            self.pop_scope_with_drops(out);
        }
        Ok(())
    }

    fn bind_loop_elem_var(
        &mut self,
        var: &str,
        ty: &Type,
        loaded_val: &str,
        region_depth: usize,
        out: &mut String,
    ) {
        let is_mut = self.mutated_vars.contains(var) || *ty == Type::Any;
        let storage = if is_mut {
            let sptr = self.next_slot(&format!("var.{var}"));
            let ty_ir = ir_type(ty);
            let align = ir_align(ty);
            let _ = writeln!(self.allocas, "  {sptr} = alloca {ty_ir}, align {align}");
            let init_v = if self.type_needs_drop(ty) {
                let c = self.emit_clone_value(ty, loaded_val, out);
                self.scopes
                    .last_mut()
                    .unwrap()
                    .owned_buffers
                    .push(DropTarget::TypedSlot {
                        ptr: sptr.clone(),
                        ty: ty.clone(),
                    });
                c
            } else {
                loaded_val.to_string()
            };
            let _ = writeln!(out, "  store {ty_ir} {init_v}, ptr {sptr}, align {align}");
            VarStorage::Slot(sptr)
        } else {
            VarStorage::Imm(loaded_val.to_string())
        };
        bind_fn_scope(self, 
            var.to_string(),
            VarEntry {
                ty: ty.clone(),
                storage,
                is_param: false,
                region_depth,
            },
        );
    }

#[allow(clippy::too_many_arguments)]
    fn gen_for_tuple2_list(
        &mut self,
        var_a: &str,
        var_b: &str,
        ty_a: &Type,
        ty_b: &Type,
        vec_val: &str,
        body: &[Stmt],
        out: &mut String,
    ) -> Result<()> {
        let tup_ty = Type::Tuple(vec![ty_a.clone(), ty_b.clone()]);
        let arr_ty = Type::Array(Box::new(tup_ty.clone()));
        let hold_outer = self.claim_stmt_temp(vec_val);
        self.flush_stmt_temps(out);
        if hold_outer {
            self.push_scope();
            let hslot = self.next_slot("fortup.vec");
            let _ = writeln!(self.allocas, "  {hslot} = alloca %ArchxVec, align 8");
            let _ = writeln!(out, "  store %ArchxVec {vec_val}, ptr {hslot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: hslot,
                    ty: arr_ty,
                });
        }

        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec_val}, 0");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec_val}, 2");

        let islot = self.next_slot("fortup.i");
        let _ = writeln!(self.allocas, "  {islot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {islot}, align 8");

        let cond_lbl = self.fresh_label("fortup.cond");
        let body_lbl = self.fresh_label("fortup.body");
        let step_lbl = self.fresh_label("fortup.step");
        let end_lbl = self.fresh_label("fortup.end");

        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load i64, ptr {islot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {cur}, {len}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let tup_ir = ir_type(&tup_ty);
        let ep = self.next_tmp();
        let _ = writeln!(out, "  {ep} = getelementptr inbounds {tup_ir}, ptr {data}, i64 {cur}");
        let tval = self.emit_elem_load(&tup_ty, &ep, out);
        let va = self.next_tmp();
        let _ = writeln!(out, "  {va} = extractvalue {tup_ir} {tval}, 0");
        let vb = self.next_tmp();
        let _ = writeln!(out, "  {vb} = extractvalue {tup_ir} {tval}, 1");

        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        self.bind_loop_elem_var(var_a, ty_a, &va, outer_rdepth, out);
        self.bind_loop_elem_var(var_b, ty_b, &vb, outer_rdepth, out);
        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_lbl.clone(),
            continue_label: step_lbl.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_lbl, out);
        }

        self.start_block(&step_lbl, out);
        let c2 = self.next_tmp();
        let _ = writeln!(out, "  {c2} = load i64, ptr {islot}, align 8");
        let nxt = self.next_tmp();
        let _ = writeln!(out, "  {nxt} = add nuw nsw i64 {c2}, 1");
        let _ = writeln!(out, "  store i64 {nxt}, ptr {islot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        if hold_outer {
            self.pop_scope_with_drops(out);
        }
        Ok(())
    }
}
