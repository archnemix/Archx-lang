//! Loop lowering (`while`, `for i in a..b`, `for i in a..b step k`, and `for x in arr`)
//! with preheader range-guard versioning and compile-time bounds-check elision.

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::analysis::*;
use super::*;

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
            let (cond_ty, cond_val) = self.eval_expr(cond, out)?;
            if cond_ty != Type::Bool {
                return Err(Diagnostic::new(
                    "`while` condition must be a `bool`",
                    cond.span,
                ));
            }
            self.flush_stmt_temps(out);
            self.emit_cond_br(&cond_val, &slow_body, &end_label, out);

            self.start_block(&slow_body, out);
            let outer_depth = self.scopes.len();
            let outer_rdepth = self.region_stack.len();
            self.push_scope();
            self.loop_stack.push(LoopLabels {
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
        let (cond_ty, cond_val) = self.eval_expr(cond, out)?;
        if cond_ty != Type::Bool {
            return Err(Diagnostic::new(
                "`while` condition must be a `bool`",
                cond.span,
            ));
        }
        self.flush_stmt_temps(out);
        self.emit_cond_br(&cond_val, &body_label, &end_label, out);

        self.start_block(&body_label, out);
        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        let breaks_before = self.break_count;
        self.loop_stack.push(LoopLabels {
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

    pub(super) fn gen_for(
        &mut self,
        var: &str,
        start: &Expr,
        end: &Expr,
        step_opt: Option<&Expr>,
        body: &[Stmt],
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        let (start_ty, start_val) = self.eval_expr(start, out)?;
        if start_ty != Type::Int {
            return Err(Diagnostic::new("`for` start must be an `int`", start.span));
        }
        let (end_ty, end_val) = self.eval_expr(end, out)?;
        if end_ty != Type::Int {
            return Err(Diagnostic::new("`for` end must be an `int`", end.span));
        }

        enum StepDir {
            PosConst,
            NegConst,
            Dynamic(String),
        }

        let (step_val, step_dir, step_guaranteed_safe) = if let Some(se) = step_opt {
            let (sty, sval) = self.eval_expr(se, out)?;
            if sty != Type::Int {
                return Err(Diagnostic::new("`for` step must be an `int`", se.span));
            }
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

        if self.lookup_var(var).is_some() {
            return Err(Diagnostic::new(
                format!("loop variable `{var}` is already defined"),
                span,
            ));
        }

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
            self.push_scope();
            self.scopes.last_mut().unwrap().vars.insert(
                var.to_string(),
                VarEntry {
                    ty: Type::Int,
                    storage: VarStorage::Slot(slot.clone()),
                    is_param: false,
                    region_depth: outer_rdepth,
                },
            );
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
            self.push_scope();
            self.scopes.last_mut().unwrap().vars.insert(
                var.to_string(),
                VarEntry {
                    ty: Type::Int,
                    storage: VarStorage::Slot(slot.clone()),
                    is_param: false,
                    region_depth: outer_rdepth,
                },
            );
            if let Some(b) = &proven_bound {
                self.loop_bounds.push(b.clone());
            }
            self.loop_stack.push(LoopLabels {
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
        let cmp = self.next_tmp();
        let _ = writeln!(out, "  {cmp} = icmp slt i64 {i}, {end_val}");
        self.emit_cond_br(&cmp, &body_label, &end_label, out);

        self.start_block(&body_label, out);
        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        self.scopes.last_mut().unwrap().vars.insert(
            var.to_string(),
            VarEntry {
                ty: Type::Int,
                storage: VarStorage::Slot(slot.clone()),
                is_param: false,
                region_depth: outer_rdepth,
            },
        );
        if let Some(bound) = &proven_bound {
            self.loop_bounds.push(bound.clone());
        }
        self.loop_stack.push(LoopLabels {
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
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if self.lookup_var(var).is_some() {
            return Err(Diagnostic::new(
                format!("loop variable `{var}` is already defined"),
                span,
            ));
        }

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
                    self.scopes.last_mut().unwrap().vars.insert(
                        var.to_string(),
                        VarEntry {
                            ty: elem_ty,
                            storage,
                            is_param: false,
                            region_depth: outer_rdepth,
                        },
                    );
                    self.loop_stack.push(LoopLabels {
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
        let Type::Array(elem_ty) = iter_ty.clone() else {
            return Err(Diagnostic::new(
                format!(
                    "`for ... in` expects a `list` or `str`, found `{}`",
                    iter_ty.name()
                ),
                iter.span,
            ));
        };

        let hold_outer_scope = self.claim_stmt_temp(&iter_val);
        self.flush_stmt_temps(out);
        if hold_outer_scope {
            self.push_scope();
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

        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        let var_mutated = self.mutated_vars.contains(var);
        let storage = if var_mutated {
            let init_elem = if self.type_needs_drop(&elem_ty) {
                self.emit_clone_value(&elem_ty, &raw_elem, out)
            } else {
                raw_elem
            };
            let sptr = self.next_slot(&format!("var.{var}"));
            let ty_ir = ir_type(&elem_ty);
            let align = ir_align(&elem_ty);
            let _ = writeln!(self.allocas, "  {sptr} = alloca {ty_ir}, align {align}");
            let _ = writeln!(out, "  store {ty_ir} {init_elem}, ptr {sptr}, align {align}");
            if self.type_needs_drop(&elem_ty) {
                self.scopes
                    .last_mut()
                    .unwrap()
                    .owned_buffers
                    .push(DropTarget::TypedSlot {
                        ptr: sptr.clone(),
                        ty: (*elem_ty).clone(),
                    });
            }
            VarStorage::Slot(sptr)
        } else {
            VarStorage::Imm(raw_elem)
        };
        self.scopes.last_mut().unwrap().vars.insert(
            var.to_string(),
            VarEntry {
                ty: (*elem_ty).clone(),
                storage,
                is_param: !var_mutated,
                region_depth: outer_rdepth,
            },
        );
        self.loop_stack.push(LoopLabels {
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
        self.scopes.last_mut().unwrap().vars.insert(
            var.to_string(),
            VarEntry {
                ty: Type::Str,
                storage,
                is_param: !var_mutated,
                region_depth: outer_rdepth,
            },
        );
        self.loop_stack.push(LoopLabels {
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
        if self.lookup_var(idx_var).is_some() {
            return Err(Diagnostic::new(
                format!("loop variable `{idx_var}` is already defined"),
                span,
            ));
        }
        if self.lookup_var(elem_var).is_some() {
            return Err(Diagnostic::new(
                format!("loop variable `{elem_var}` is already defined"),
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
                    self.scopes.last_mut().unwrap().vars.insert(
                        idx_var.to_string(),
                        VarEntry {
                            ty: Type::Int,
                            storage: idx_storage,
                            is_param: false,
                            region_depth: outer_rdepth,
                        },
                    );
                    self.scopes.last_mut().unwrap().vars.insert(
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
        let idx_mut = self.mutated_vars.contains(idx_var);
        let idx_storage = if idx_mut {
            let islot = self.next_slot(&format!("var.{idx_var}"));
            let _ = writeln!(self.allocas, "  {islot} = alloca i64, align 8");
            let _ = writeln!(out, "  store i64 {user_idx}, ptr {islot}, align 8");
            VarStorage::Slot(islot)
        } else {
            VarStorage::Imm(user_idx)
        };
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

        self.scopes.last_mut().unwrap().vars.insert(
            idx_var.to_string(),
            VarEntry {
                ty: Type::Int,
                storage: idx_storage,
                is_param: !idx_mut,
                region_depth: outer_rdepth,
            },
        );
        self.scopes.last_mut().unwrap().vars.insert(
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

}
