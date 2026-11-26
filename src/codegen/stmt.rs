//! Statement, `region:` block, transparent AoS-to-SoA declaration, and assignment lowering to LLVM IR.

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::analysis::*;
use super::*;

impl Codegen {
    pub(super) fn gen_block(&mut self, stmts: &[Stmt], out: &mut String) -> Result<()> {
        for (idx, stmt) in stmts.iter().enumerate() {
            self.gen_stmt(stmt, &stmts[idx + 1..], out)?;
        }
        Ok(())
    }

    pub(super) fn gen_stmt(&mut self, stmt: &Stmt, rest_in_block: &[Stmt], out: &mut String) -> Result<()> {
        self.enter_depth(stmt.span)?;
        let res = self.gen_stmt_inner(stmt, rest_in_block, out);
        self.depth -= 1;
        res
    }

    pub(super) fn gen_stmt_inner(
        &mut self,
        stmt: &Stmt,
        rest_in_block: &[Stmt],
        out: &mut String,
    ) -> Result<()> {
        if self.terminated {
            let dead = self.fresh_label("dead");
            self.start_block(&dead, out);
        }

        match &stmt.kind {
            StmtKind::Pass => Ok(()),

            // `for ... else` is carried by `ForEach` now; a bare wrapper cannot be reached.
            StmtKind::ForElse { .. } => Err(Diagnostic::new(
                "internal error: unwrapped `for ... else`",
                stmt.span,
            )),

            StmtKind::Assert { cond, msg } => {
                let cond_val = self.eval_cond_bool(cond, "assert", out)?;
                let ok_lbl = self.fresh_label("assert.ok");
                let fail_lbl = self.fresh_label("assert.fail");
                self.emit_cond_br(&cond_val, &ok_lbl, &fail_lbl, out);

                self.start_block(&fail_lbl, out);
                self.used_assert_fail = true;
                if let Some(mexpr) = msg {
                    let (mty, mval) = self.eval_expr(mexpr, out)?;
                    if mty != Type::Str {
                        return Err(Diagnostic::new(
                            format!("`assert` message must be `str`, found `{}`", mty.name()),
                            mexpr.span,
                        ));
                    }
                    let _ = writeln!(
                        out,
                        "  call void @archx_assert_fail(%ArchxStr {mval}, i1 true, i64 {})",
                        stmt.span.line
                    );
                } else {
                    let _ = writeln!(
                        out,
                        "  call void @archx_assert_fail(%ArchxStr zeroinitializer, i1 false, i64 {})",
                        stmt.span.line
                    );
                }
                let _ = writeln!(out, "  unreachable");
                self.terminated = true;

                self.start_block(&ok_lbl, out);
                self.flush_stmt_temps(out);
                Ok(())
            }

            StmtKind::Let {
                name,
                ty: declared_ty,
                value,
            } => {
                if self.lookup_var(name).is_some() {
                    return Err(Diagnostic::new(
                        format!("variable `{name}` is already defined in this scope"),
                        stmt.span,
                    ));
                }
                self.gen_let_binding(name, declared_ty.as_ref(), value, rest_in_block, stmt.span, out)
            }

            StmtKind::Return(value) => {
                if let Some(expr) = value {
                    let expected_hint = self.current_ret.clone();
                    if let ExprKind::Var(vname) = &expr.kind {
                        if !self.is_narrowed_optional(vname) {
                            if let Some(entry) = self.lookup_var(vname).cloned() {
                                if !entry.is_param
                                    && self.type_needs_drop(&entry.ty)
                                    && matches!(entry.storage, VarStorage::Slot(_))
                                {
                                    if let Some(expected) = &expected_hint {
                                        if *expected != entry.ty
                                            && *expected != Type::Any
                                            && *expected != Type::Optional(Box::new(entry.ty.clone()))
                                        {
                                            return Err(Diagnostic::new(
                                                format!(
                                                    "`return` type mismatch: expected `{}`, found `{}`",
                                                    expected.name(),
                                                    entry.ty.name()
                                                ),
                                                stmt.span,
                                            ));
                                        }
                                    } else if !self.is_main {
                                        return Err(Diagnostic::new(
                                            "this function does not return a value",
                                            stmt.span,
                                        ));
                                    }
                                    if expected_hint.as_ref() == Some(&entry.ty) {
                                        let VarStorage::Slot(slot_ptr) = entry.storage else {
                                            unreachable!()
                                        };
                                        let ty_ir = ir_type(&entry.ty);
                                        let align = ir_align(&entry.ty);
                                        let loaded = self.next_tmp();
                                        let _ = writeln!(
                                            out,
                                            "  {loaded} = load {ty_ir}, ptr {slot_ptr}, align {align}"
                                        );
                                        let final_val = if !self.region_stack.is_empty() {
                                            self.emit_promote_to_heap(&entry.ty, &loaded, out)
                                        } else {
                                            loaded
                                        };
                                        self.flush_stmt_temps(out);
                                        self.emit_func_exit_cleanup(Some(&slot_ptr), out);
                                        let _ = writeln!(out, "  ret {ty_ir} {final_val}");
                                        self.terminated = true;
                                        return Ok(());
                                    }
                                }
                            }
                        }
                    }

                    if expected_hint == Some(Type::Any) && matches!(&expr.kind, ExprKind::NoneLit) {
                        self.mark_runtime_type(&Type::Any);
                        self.used_any_rt = true;
                        self.flush_stmt_temps(out);
                        self.emit_func_exit_cleanup(None, out);
                        out.push_str("  ret %ArchxAny zeroinitializer\n");
                        self.terminated = true;
                        return Ok(());
                    }

                    let (ty, raw_val) = self.eval_expr_typed(expr, expected_hint.as_ref(), out)?;

                    if self.is_main {
                        let main_i = if ty == Type::Any {
                            self.emit_unbox_any(&Type::Int, &raw_val, expr.span, out)?
                        } else if ty == Type::Int {
                            raw_val
                        } else {
                            return Err(Diagnostic::new(
                                "`main` must return an `int`",
                                stmt.span,
                            ));
                        };
                        self.flush_stmt_temps(out);
                        self.emit_func_exit_cleanup(None, out);
                        let truncated = self.next_tmp();
                        let _ = writeln!(out, "  {truncated} = trunc i64 {main_i} to i32");
                        let _ = writeln!(out, "  ret i32 {truncated}");
                        self.terminated = true;
                        return Ok(());
                    }

                    match self.current_ret.clone() {
                        Some(expected) if expected == ty => {
                            let owned_val = if self.type_needs_drop(&ty) {
                                let v = if self.claim_stmt_temp(&raw_val) {
                                    raw_val
                                } else {
                                    self.emit_clone_value(&ty, &raw_val, out)
                                };
                                if !self.region_stack.is_empty() {
                                    self.emit_promote_to_heap(&ty, &v, out)
                                } else {
                                    v
                                }
                            } else {
                                raw_val
                            };
                            self.flush_stmt_temps(out);
                            self.emit_func_exit_cleanup(None, out);
                            let _ = writeln!(out, "  ret {} {}", ir_type(&ty), owned_val);
                        }
                        Some(Type::Any) => {
                            let boxed = self.emit_box_any_owned(&ty, &raw_val, expr.span, out)?;
                            let final_v = if !self.region_stack.is_empty() {
                                self.emit_promote_to_heap(&Type::Any, &boxed, out)
                            } else {
                                boxed
                            };
                            self.flush_stmt_temps(out);
                            self.emit_func_exit_cleanup(None, out);
                            let _ = writeln!(out, "  ret %ArchxAny {final_v}");
                        }
                        Some(expected) if ty == Type::Any => {
                            let unboxed = self.emit_unbox_any(&expected, &raw_val, expr.span, out)?;
                            let owned_val = if self.type_needs_drop(&expected) {
                                let v = if self.claim_stmt_temp(&unboxed) {
                                    unboxed
                                } else {
                                    self.emit_clone_value(&expected, &unboxed, out)
                                };
                                if !self.region_stack.is_empty() {
                                    self.emit_promote_to_heap(&expected, &v, out)
                                } else {
                                    v
                                }
                            } else {
                                unboxed
                            };
                            self.flush_stmt_temps(out);
                            self.emit_func_exit_cleanup(None, out);
                            let _ = writeln!(out, "  ret {} {}", ir_type(&expected), owned_val);
                        }
                        Some(expected) => {
                            return Err(Diagnostic::new(
                                format!(
                                    "`return` type mismatch: expected `{}`, found `{}`",
                                    expected.name(),
                                    ty.name()
                                ),
                                stmt.span,
                            ));
                        }
                        None => {
                            return Err(Diagnostic::new(
                                "this function does not return a value",
                                stmt.span,
                            ));
                        }
                    }
                } else if self.is_main {
                    self.flush_stmt_temps(out);
                    self.emit_func_exit_cleanup(None, out);
                    out.push_str("  ret i32 0\n");
                } else {
                    match &self.current_ret.clone() {
                        Some(Type::Any) => {
                            self.mark_runtime_type(&Type::Any);
                            self.flush_stmt_temps(out);
                            self.emit_func_exit_cleanup(None, out);
                            out.push_str("  ret %ArchxAny zeroinitializer\n");
                        }
                        Some(Type::Optional(inner)) => {
                            let opt_ir = ir_type(&Type::Optional(inner.clone()));
                            self.flush_stmt_temps(out);
                            self.emit_func_exit_cleanup(None, out);
                            let _ = writeln!(out, "  ret {opt_ir} zeroinitializer");
                        }
                        Some(_) => {
                            return Err(Diagnostic::new(
                                "this function must return a value",
                                stmt.span,
                            ));
                        }
                        None => {
                            self.flush_stmt_temps(out);
                            self.emit_func_exit_cleanup(None, out);
                            out.push_str("  ret void\n");
                        }
                    }
                }

                self.terminated = true;
                Ok(())
            }

            StmtKind::Expr(expr) => {
                self.eval_expr(expr, out)?;
                self.flush_stmt_temps(out);
                Ok(())
            }

            StmtKind::Assign { target, op, value } => {
                if op.is_none() {
                    if let AssignTarget::Var(name) = target {
                        if self.lookup_var(name).is_none() {
                            return self.gen_let_binding(
                                name,
                                None,
                                value,
                                rest_in_block,
                                stmt.span,
                                out,
                            );
                        }
                    }
                }
                self.gen_assign(target, *op, value, stmt.span, out)?;
                self.flush_stmt_temps(out);
                Ok(())
            }

            StmtKind::TupleAssign { targets, value } => {
                self.gen_tuple_assign(targets, value, stmt.span, out)
            }

            StmtKind::Match { subject, cases } => self.gen_match(subject, cases, stmt.span, out),

            StmtKind::While { cond, body } => self.gen_while(cond, body, out),

            StmtKind::For {
                var,
                start,
                end,
                step,
                body,
                else_body,
            } => match else_body {
                Some(eb) => {
                    self.gen_for_else(var, start, end, step.as_ref(), body, eb, stmt.span, out)
                }
                None => self.gen_for(var, start, end, step.as_ref(), body, stmt.span, out),
            },

            StmtKind::ForEach {
                var,
                iter,
                body,
                else_body,
            } => {
                let _ = rest_in_block;
                match else_body {
                    Some(eb) => self.gen_foreach_else(var, iter, body, eb, stmt.span, out),
                    None => self.gen_foreach(var, iter, body, stmt.span, out),
                }
            }

            StmtKind::ForEnumerate {
                idx_var,
                elem_var,
                iter,
                start,
                body,
            } => self.gen_for_enumerate(
                idx_var,
                elem_var,
                iter,
                start.as_ref(),
                body,
                stmt.span,
                out,
            ),

            StmtKind::ForDictItems {
                key_var,
                val_var,
                dict,
                body,
            } => self.gen_for_dict_items(key_var, val_var, dict, body, stmt.span, out),

            StmtKind::ForZip { vars, iters, body } => {
                self.gen_for_zip(vars, iters, body, stmt.span, out)
            }

            StmtKind::ForTupleUnpack { vars, iter, body } => {
                self.gen_for_tuple_unpack(vars, iter, body, stmt.span, out)
            }

            StmtKind::Region { body } => self.gen_region(body, out),

            StmtKind::Break => {
                let (label, sdepth, rdepth, flag) = self
                    .loop_stack
                    .last()
                    .map(|l| {
                        (
                            l.break_label.clone(),
                            l.scope_depth,
                            l.region_depth,
                            l.break_flag.clone(),
                        )
                    })
                    .ok_or_else(|| {
                        Diagnostic::new("`break` is only allowed inside a loop", stmt.span)
                    })?;
                if let Some(flag) = &flag {
                    let _ = writeln!(out, "  store i1 false, ptr {flag}, align 8");
                }
                self.emit_drops_down_to(sdepth, None, out);
                self.emit_region_exits_down_to(rdepth, out);
                self.break_count += 1;
                self.emit_br(&label, out);
                Ok(())
            }

            StmtKind::Continue => {
                let (label, sdepth, rdepth) = self
                    .loop_stack
                    .last()
                    .map(|l| (l.continue_label.clone(), l.scope_depth, l.region_depth))
                    .ok_or_else(|| {
                        Diagnostic::new("`continue` is only allowed inside a loop", stmt.span)
                    })?;
                self.emit_drops_down_to(sdepth, None, out);
                self.emit_region_exits_down_to(rdepth, out);
                self.emit_br(&label, out);
                Ok(())
            }

            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                let narrowing = self.detect_optional_narrowing(cond);
                let cond_val = self.eval_cond_bool(cond, "if", out)?;
                self.flush_stmt_temps(out);

                let then_label = self.fresh_label("if.then");
                let else_label = self.fresh_label("if.else");
                let merge_label = self.fresh_label("if.merge");

                self.emit_cond_br(&cond_val, &then_label, &else_label, out);

                self.start_block(&then_label, out);
                self.push_scope();
                if let Some((ref nvar, NarrowingKind::SomeInThen)) = narrowing {
                    self.scopes
                        .last_mut()
                        .unwrap()
                        .narrowed_optionals
                        .insert(nvar.clone());
                }
                self.gen_block(then_body, out)?;
                self.pop_scope_with_drops(out);
                let then_terminated = self.terminated;
                if !then_terminated {
                    self.emit_br(&merge_label, out);
                }

                self.start_block(&else_label, out);
                if let Some(body) = else_body {
                    self.push_scope();
                    if let Some((ref nvar, NarrowingKind::NoneInThen)) = narrowing {
                        self.scopes
                            .last_mut()
                            .unwrap()
                            .narrowed_optionals
                            .insert(nvar.clone());
                    }
                    self.gen_block(body, out)?;
                    self.pop_scope_with_drops(out);
                }
                let else_terminated = self.terminated;
                if !else_terminated {
                    self.emit_br(&merge_label, out);
                }

                self.start_block(&merge_label, out);
                if then_terminated && else_terminated {
                    let _ = writeln!(out, "  unreachable");
                    self.terminated = true;
                } else if then_terminated && !else_terminated {
                    if let Some((nvar, NarrowingKind::NoneInThen)) = narrowing {
                        self.scopes
                            .last_mut()
                            .unwrap()
                            .narrowed_optionals
                            .insert(nvar);
                    }
                } else if else_terminated && !then_terminated {
                    if let Some((nvar, NarrowingKind::SomeInThen)) = narrowing {
                        self.scopes
                            .last_mut()
                            .unwrap()
                            .narrowed_optionals
                            .insert(nvar);
                    }
                }
                Ok(())
            }
        }
    }

    pub(super) fn gen_let_binding(
        &mut self,
        name: &str,
        declared_ty: Option<&Type>,
        value: &Expr,
        rest_in_block: &[Stmt],
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if let Some(t) = declared_ty {
            if *t == Type::Void {
                return Err(Diagnostic::new(
                    "cannot declare a variable of type `void`",
                    span,
                ));
            }
            validate_type(t, &self.structs, &self.enums, span)?;
            self.mark_runtime_type(t);
        }

        // Adaptive Dual-Mode Type Engine:
        // 1. If `name` is rebound to incompatible types later (`name = "a"; name = 18`) or `None`,
        //    promote `name` to `%ArchxAny`.
        // 2. If `name` is an unannotated empty container (`[]`, `{}`, `set()`), specialize it to
        //    Tier-1 native `[T]`/`dict[K, V]`/`set[T]` when usage is homogeneous!
        let adaptive_ty: Option<Type> = if let Some(t) = declared_ty {
            Some(t.clone())
        } else if self.adaptive_hints.dynamic_vars.contains(name)
            || matches!(&value.kind, ExprKind::NoneLit)
        {
            Some(Type::Any)
        } else {
            self.adaptive_hints.specialized_containers.get(name).cloned()
        };

        let is_mutated = self.mutated_vars.contains(name);

        if !is_mutated && self.region_stack.is_empty() && adaptive_ty.as_ref() != Some(&Type::Any) {
            if let Some(soa_storage) =
                self.try_emit_transparent_soa(name, adaptive_ty.as_ref(), value, rest_in_block, out)?
            {
                self.flush_stmt_temps(out);
                let sname = match &soa_storage {
                    VarStorage::Soa { struct_name, .. } => struct_name.clone(),
                    _ => unreachable!(),
                };
                self.scopes.last_mut().unwrap().vars.insert(
                    name.to_string(),
                    VarEntry {
                        ty: Type::Array(Box::new(Type::Struct(sname))),
                        storage: soa_storage,
                        is_param: false,
                        region_depth: self.region_stack.len(),
                    },
                );
                return Ok(());
            }
        }

        let (ty, val) = if let Some(expected) = &adaptive_ty {
            self.mark_runtime_type(expected);
            let owned = self.eval_owned_for_slot(expected, value, out)?;
            (expected.clone(), owned)
        } else {
            let (inferred_ty, raw_val) = self.eval_expr(value, out)?;
            if inferred_ty == Type::Void {
                return Err(Diagnostic::new(
                    "cannot store a `void` / `None` value in a variable",
                    span,
                ));
            }
            self.mark_runtime_type(&inferred_ty);
            let needs_drop = self.type_needs_drop(&inferred_ty);
            let v = if needs_drop && !matches!(&value.kind, ExprKind::Str(_)) {
                if self.claim_stmt_temp(&raw_val) {
                    raw_val
                } else {
                    self.emit_clone_value(&inferred_ty, &raw_val, out)
                }
            } else {
                raw_val
            };
            (inferred_ty, v)
        };

        if !is_mutated && ty.is_array() {
            if let Some(known) = self.infer_known_array_len(value) {
                self.scopes
                    .last_mut()
                    .unwrap()
                    .known_lens
                    .insert(name.to_string(), known);
            }
        }

        let needs_drop = self.type_needs_drop(&ty);
        self.flush_stmt_temps(out);

        let is_returned = self.returned_vars.contains(name);
        let is_1d_pod_array = matches!(
            &ty,
            Type::Array(elem) if matches!(elem.as_ref(), Type::Int | Type::Float | Type::Bool)
        );
        let is_const_safe_str = ty == Type::Str && matches!(&value.kind, ExprKind::Str(_));
        let is_region_pod_vec = !self.region_stack.is_empty()
            && is_1d_pod_array
            && matches!(
                &value.kind,
                ExprKind::ArrayLit(_) | ExprKind::ArrayRepeat { .. }
            );

        let storage =
            if !is_mutated && (!needs_drop || is_const_safe_str || (is_region_pod_vec && !is_returned))
            {
                VarStorage::Imm(val)
            } else if !is_mutated
                && is_1d_pod_array
                && !is_returned
                && self.region_stack.is_empty()
            {
                let is_empty_lit = matches!(&value.kind, ExprKind::ArrayLit(es) if es.is_empty());
                if !is_empty_lit {
                    let data_ptr = self.next_tmp();
                    let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {val}, 2");
                    self.scopes
                        .last_mut()
                        .unwrap()
                        .owned_buffers
                        .push(DropTarget::DataPtr(data_ptr));
                }
                VarStorage::Imm(val)
            } else {
                let ptr = self.next_slot(&format!("var.{name}"));
                let ty_ir = ir_type(&ty);
                let align = ir_align(&ty);
                let _ = writeln!(self.allocas, "  {ptr} = alloca {ty_ir}, align {align}");
                let _ = writeln!(out, "  store {ty_ir} {val}, ptr {ptr}, align {align}");

                if needs_drop && !is_region_pod_vec {
                    self.scopes
                        .last_mut()
                        .unwrap()
                        .owned_buffers
                        .push(DropTarget::TypedSlot {
                            ptr: ptr.clone(),
                            ty: ty.clone(),
                        });
                }
                VarStorage::Slot(ptr)
            };

        self.scopes.last_mut().unwrap().vars.insert(
            name.to_string(),
            VarEntry {
                ty,
                storage,
                is_param: false,
                region_depth: self.region_stack.len(),
            },
        );
        Ok(())
    }

    pub(super) fn gen_region(&mut self, body: &[Stmt], out: &mut String) -> Result<()> {
        let rslot = self.func_region_slot.clone().expect("func_region_slot set");

        let rsave = if self.region_stack.is_empty() {
            RegionSave::Root
        } else {
            let saved_cur = self.next_tmp();
            let _ = writeln!(out, "  {saved_cur} = load ptr, ptr {rslot}, align 8");
            let end_gep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {end_gep} = getelementptr inbounds %ArchxRegion, ptr {rslot}, i32 0, i32 1"
            );
            let saved_end = self.next_tmp();
            let _ = writeln!(out, "  {saved_end} = load ptr, ptr {end_gep}, align 8");
            let tail_gep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {tail_gep} = getelementptr inbounds %ArchxRegion, ptr {rslot}, i32 0, i32 3"
            );
            let saved_tail = self.next_tmp();
            let _ = writeln!(out, "  {saved_tail} = load ptr, ptr {tail_gep}, align 8");
            RegionSave::Nested {
                saved_cur,
                saved_end,
                saved_tail,
            }
        };

        self.push_scope();
        self.region_stack.push(rsave.clone());

        self.gen_block(body, out)?;

        self.region_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_single_region_exit(&rsave, out);
        }
        Ok(())
    }

    pub(super) fn emit_single_region_exit(&mut self, rsave: &RegionSave, out: &mut String) {
        let rslot = self.func_region_slot.clone().unwrap();
        match rsave {
            RegionSave::Root => {
                let _ = writeln!(
                    out,
                    "  call fastcc void @archx_region_rewind_root(ptr {rslot})"
                );
            }
            RegionSave::Nested {
                saved_cur,
                saved_end,
                saved_tail,
            } => {
                let _ = writeln!(out, "  store ptr {saved_cur}, ptr {rslot}, align 8");
                let end_gep = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {end_gep} = getelementptr inbounds %ArchxRegion, ptr {rslot}, i32 0, i32 1"
                );
                let _ = writeln!(out, "  store ptr {saved_end}, ptr {end_gep}, align 8");
                let tail_gep = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {tail_gep} = getelementptr inbounds %ArchxRegion, ptr {rslot}, i32 0, i32 3"
                );
                let _ = writeln!(out, "  store ptr {saved_tail}, ptr {tail_gep}, align 8");
            }
        }
    }

    pub(super) fn emit_region_exits_down_to(&mut self, target_depth: usize, out: &mut String) {
        if let Some(outer) = self.region_stack.get(target_depth).cloned() {
            self.emit_single_region_exit(&outer, out);
        }
    }

    // ---------------- Transparent SoA lowering -------------------------------

    pub(super) fn try_emit_transparent_soa(
        &mut self,
        var_name: &str,
        declared_ty: Option<&Type>,
        value: &Expr,
        rest_in_block: &[Stmt],
        out: &mut String,
    ) -> Result<Option<VarStorage>> {
        let ExprKind::ArrayRepeat {
            value: elem_expr,
            count: count_expr,
        } = &value.kind
        else {
            return Ok(None);
        };
        let ExprKind::Call {
            name: sname,
            args: field_args,
        } = &elem_expr.kind
        else {
            return Ok(None);
        };
        let Some(fields) = self.structs.get(sname).cloned() else {
            return Ok(None);
        };
        if fields.len() < 2
            || !fields
                .iter()
                .all(|f| matches!(f.ty, Type::Int | Type::Float | Type::Bool))
        {
            return Ok(None);
        }
        if let Some(decl) = declared_ty {
            if *decl != Type::Array(Box::new(Type::Struct(sname.clone()))) {
                return Ok(None);
            }
        }
        if var_escapes_soa(rest_in_block, var_name, &self.mutating_method_names) {
            return Ok(None);
        }

        if field_args.len() != fields.len() {
            return Err(Diagnostic::new(
                format!(
                    "struct `{sname}` expects {} field{}, found {}",
                    fields.len(),
                    if fields.len() == 1 { "" } else { "s" },
                    field_args.len()
                ),
                elem_expr.span,
            ));
        }

        let mut init_vals = Vec::with_capacity(fields.len());
        for (i, arg) in field_args.iter().enumerate() {
            let (fty, fval) = self.eval_expr_typed(arg, Some(&fields[i].ty), out)?;
            if fty != fields[i].ty {
                return Err(Diagnostic::new(
                    format!(
                        "field `{}` of `{sname}` expects `{}`, found `{}`",
                        fields[i].name,
                        fields[i].ty.name(),
                        fty.name()
                    ),
                    arg.span,
                ));
            }
            init_vals.push((fty, fval));
        }

        let (count_ty, count_val) = self.eval_expr(count_expr, out)?;
        if count_ty != Type::Int {
            return Err(Diagnostic::new(
                format!(
                    "array repeat count must be `int`, found `{}`",
                    count_ty.name()
                ),
                count_expr.span,
            ));
        }

        self.emit_repeat_count_check(count_expr, &count_val, out)?;

        if let Some(known) = self.infer_known_array_len(value) {
            self.scopes
                .last_mut()
                .unwrap()
                .known_lens
                .insert(var_name.to_string(), known);
        }

        let mut planes = Vec::with_capacity(fields.len());
        for (fty, init_val) in init_vals {
            let elem_size = if fty == Type::Bool { 1 } else { 8 };
            let is_zero = (fty == Type::Int && init_val == "0")
                || (fty == Type::Float && init_val == "0x0000000000000000")
                || (fty == Type::Bool && init_val == "false");
            let plane_ptr = if is_zero {
                self.emit_checked_calloc(&count_val, elem_size, out)
            } else {
                let bytes = self.emit_elem_bytes_mul(&count_val, elem_size, out);
                let p = self.emit_checked_malloc(&bytes, out);
                self.emit_scalar_fill_loop(&fty, &init_val, &p, &count_val, out);
                p
            };
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::DataPtr(plane_ptr.clone()));
            planes.push((fty, plane_ptr));
        }

        Ok(Some(VarStorage::Soa {
            struct_name: sname.clone(),
            len_val: count_val,
            planes,
        }))
    }

    // ---------------- Loops --------------------------------------------------

    // ---------------- Assignments --------------------------------------------

    pub(super) fn check_region_escape_target(&self, root_var: &str, val_ty: &Type, span: Span) -> Result<()> {
        if !self.region_stack.is_empty() && self.type_needs_drop(val_ty) {
            if let Some(entry) = self.lookup_var(root_var) {
                if entry.region_depth < self.region_stack.len() {
                    return Err(Diagnostic::new(
                        format!(
                            "cannot store heap/region value of type `{}` into outer variable `{root_var}` inside `region:`",
                            val_ty.name()
                        ),
                        span,
                    ));
                }
            }
        }
        Ok(())
    }

    pub(super) fn gen_assign(
        &mut self,
        target: &AssignTarget,
        op: Option<BinOp>,
        value: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        match target {
            AssignTarget::Var(name) => {
                let entry = self.lookup_var(name).cloned().ok_or_else(|| {
                    Diagnostic::new(format!("undefined variable `{name}`"), span)
                })?;
                self.check_region_escape_target(name, &entry.ty, span)?;

                if op.is_none() && matches!(&value.kind, ExprKind::Var(v) if v == name) {
                    return Ok(());
                }

                let ptr = match &entry.storage {
                    VarStorage::Slot(p) => p.clone(),
                    _ => {
                        return Err(Diagnostic::new(
                            format!("internal error: mutated variable `{name}` lacked a slot"),
                            span,
                        ));
                    }
                };

                if let Some(bin_op) = op {
                    if entry.ty == Type::Any {
                        let code = match bin_op {
                            BinOp::Add => 0,
                            BinOp::Sub => 1,
                            BinOp::Mul => 2,
                            BinOp::Div => 3,
                            BinOp::FloorDiv => 4,
                            BinOp::Mod => 5,
                            BinOp::Pow => 6,
                            _ => {
                                return Err(Diagnostic::new(
                                    format!("unsupported compound assignment `{}=`", bin_op.symbol()),
                                    span,
                                ))
                            }
                        };
                        let old_val = self.next_tmp();
                        let _ = writeln!(out, "  {old_val} = load %ArchxAny, ptr {ptr}, align 8");
                        let ra = self.eval_expr_as_any(value, out)?;
                        let rarg = self.active_region_arg();
                        let nv = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {nv} = call fastcc %ArchxAny @archx_any_binop(%ArchxAny {old_val}, %ArchxAny {ra}, i64 {code}, ptr {rarg})"
                        );
                        self.emit_drop_value(&Type::Any, &old_val, out);
                        let _ = writeln!(out, "  store %ArchxAny {nv}, ptr {ptr}, align 8");
                        return Ok(());
                    }
                    if entry.ty == Type::Str && bin_op == BinOp::Add {
                        let old_val = self.next_tmp();
                        let _ = writeln!(out, "  {old_val} = load %ArchxStr, ptr {ptr}, align 8");
                        let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
                        if rhs_ty != Type::Str {
                            return Err(Diagnostic::new(
                                format!(
                                    "operator `+=` on `string` requires a `string` right-hand side, found `{}`",
                                    rhs_ty.name()
                                ),
                                value.span,
                            ));
                        }
                        let new_val = self.emit_str_concat_call(&old_val, &rhs_val, out);
                        let _ = self.claim_stmt_temp(&new_val);
                        self.emit_drop_value(&Type::Str, &old_val, out);
                        let _ = writeln!(out, "  store %ArchxStr {new_val}, ptr {ptr}, align 8");
                        return Ok(());
                    }
                    if entry.ty == Type::Float {
                        let old_val = self.next_tmp();
                        let _ = writeln!(out, "  {old_val} = load double, ptr {ptr}, align 8");
                        let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
                        if rhs_ty != Type::Float {
                            return Err(Diagnostic::new(
                                format!(
                                    "operator `{}=` requires a `float` right-hand side, found `{}`",
                                    bin_op.symbol(),
                                    rhs_ty.name()
                                ),
                                value.span,
                            ));
                        }
                        let new_val = self.emit_float_arith(bin_op, &old_val, &rhs_val, out);
                        let _ = writeln!(out, "  store double {new_val}, ptr {ptr}, align 8");
                        return Ok(());
                    }
                    if entry.ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires an `int` or `float` target, found `{}`",
                                bin_op.symbol(),
                                entry.ty.name()
                            ),
                            span,
                        ));
                    }
                    let old_val = self.next_tmp();
                    let _ = writeln!(out, "  {old_val} = load i64, ptr {ptr}, align 8");
                    let (rhs_ty, raw_rhs) = self.eval_expr(value, out)?;
                    // Python: `x += 0.25` on an int variable rebinds `x` to a float. Rewriting it
                    // as `x = x + 0.25` reuses the (now promoting) binary-operator path instead of
                    // rejecting the mix.
                    if rhs_ty == Type::Float {
                        let widened = self.next_tmp();
                        let _ = writeln!(out, "  {widened} = sitofp i64 {old_val} to double");
                        let promoted = self.emit_float_arith(bin_op, &widened, &raw_rhs, out);
                        let slot = self.next_slot(&format!("promote.{name}"));
                        let _ = writeln!(self.allocas, "  {slot} = alloca double, align 8");
                        let _ = writeln!(out, "  store double {promoted}, ptr {slot}, align 8");
                        self.clear_narrowed_optional(name);
                        let replaced = VarEntry {
                            ty: Type::Float,
                            storage: VarStorage::Slot(slot),
                            is_param: false,
                            region_depth: self.region_stack.len(),
                        };
                        if let Some(scope) = self.scopes.last_mut() {
                            scope.vars.insert(name.clone(), replaced);
                        }
                        return Ok(());
                    }
                    let rhs_val = if rhs_ty == Type::Int {
                        raw_rhs
                    } else if rhs_ty == Type::Any {
                        self.emit_unbox_any(&Type::Int, &raw_rhs, value.span, out)?
                    } else {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires an `int` right-hand side, found `{}`",
                                bin_op.symbol(),
                                rhs_ty.name()
                            ),
                            value.span,
                        ));
                    };
                    let new_val = self.emit_int_arith(bin_op, &old_val, &rhs_val, out);
                    let _ = writeln!(out, "  store i64 {new_val}, ptr {ptr}, align 8");
                } else {
                    let needs_drop = self.type_needs_drop(&entry.ty);
                    let new_val = if entry.ty != Type::Any
                        && needs_drop
                        && matches!(&value.kind, ExprKind::Str(_))
                    {
                        let (_, raw_val) = self.eval_expr(value, out)?;
                        raw_val
                    } else {
                        self.eval_owned_for_slot(&entry.ty, value, out)?
                    };
                    self.clear_narrowed_optional(name);
                    if needs_drop {
                        let old_val = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {old_val} = load {}, ptr {ptr}, align {}",
                            ir_type(&entry.ty),
                            ir_align(&entry.ty)
                        );
                        self.emit_drop_value(&entry.ty, &old_val, out);
                    }
                    let _ = writeln!(
                        out,
                        "  store {} {new_val}, ptr {ptr}, align {}",
                        ir_type(&entry.ty),
                        ir_align(&entry.ty)
                    );
                }
                Ok(())
            }

            AssignTarget::Field {
                target: base_expr,
                field,
            } => self.gen_field_assign(base_expr, field, op, value, span, out),

            AssignTarget::Index {
                target: arr_expr,
                index: idx_expr,
            } => {
                if let Some(root) = root_var_of_expr(arr_expr) {
                    if let Some(entry) = self.lookup_var(root).cloned() {
                        if let Type::Array(elem_t) = &entry.ty {
                            self.check_region_escape_target(root, elem_t, span)?;
                        } else if let Type::Dict(_, v_t) = &entry.ty {
                            self.check_region_escape_target(root, v_t, span)?;
                        }
                        if let VarStorage::Soa {
                            struct_name,
                            len_val,
                            planes,
                        } = entry.storage
                        {
                            if op.is_some() {
                                return Err(Diagnostic::new(
                                    "compound assignment is not supported on whole structs",
                                    span,
                                ));
                            }
                            let (idx_ty, idx_val) = self.eval_expr(idx_expr, out)?;
                            if idx_ty != Type::Int {
                                return Err(Diagnostic::new(
                                    format!("array index must be `int`, found `{}`", idx_ty.name()),
                                    idx_expr.span,
                                ));
                            }
                            self.emit_raw_len_bounds_check(
                                arr_expr, idx_expr, &len_val, &idx_val, out,
                            )?;
                            let expected = Type::Struct(struct_name.clone());
                            let (rhs_ty, rhs_val) =
                                self.eval_expr_typed(value, Some(&expected), out)?;
                            if rhs_ty != expected {
                                return Err(Diagnostic::new(
                                    format!(
                                        "cannot assign `{}` to element of `[{struct_name}]`",
                                        rhs_ty.name()
                                    ),
                                    value.span,
                                ));
                            }
                            for (k, (fty, p_ptr)) in planes.iter().enumerate() {
                                let fv = self.next_tmp();
                                let _ = writeln!(
                                    out,
                                    "  {fv} = extractvalue %ArchxStruct_{struct_name} {rhs_val}, {k}"
                                );
                                let mem_ty = elem_mem_ir_type(fty);
                                let ep = self.next_tmp();
                                let _ = writeln!(
                                    out,
                                    "  {ep} = getelementptr inbounds {mem_ty}, ptr {p_ptr}, i64 {idx_val}"
                                );
                                self.emit_elem_store(fty, &fv, &ep, out);
                            }
                            return Ok(());
                        }
                    }
                }

                let (arr_ty, vec_val) = self.eval_expr(arr_expr, out)?;
                if let Type::Dict(k_ty, v_ty) = arr_ty {
                    return self.gen_dict_index_assign(
                        &k_ty, &v_ty, &vec_val, idx_expr, op, value, span, out,
                    );
                }
                if arr_ty == Type::Any {
                    self.mark_runtime_type(&Type::Any);
                    self.used_any_rt = true;
                    let idx_any = self.eval_expr_as_any(idx_expr, out)?;
                    if let Some(bin_op) = op {
                        let code = match bin_op {
                            BinOp::Add => 0,
                            BinOp::Sub => 1,
                            BinOp::Mul => 2,
                            BinOp::Div => 3,
                            BinOp::FloorDiv => 4,
                            BinOp::Mod => 5,
                            BinOp::Pow => 6,
                            _ => {
                                return Err(Diagnostic::new(
                                    format!("unsupported compound assignment `{}=`", bin_op.symbol()),
                                    span,
                                ))
                            }
                        };
                        let cur = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {cur} = call fastcc %ArchxAny @archx_any_get_idx(%ArchxAny {vec_val}, %ArchxAny {idx_any})"
                        );
                        self.stmt_temps.push(TempDrop {
                            val: cur.clone(),
                            ty: Type::Any,
                        });
                        let ra = self.eval_expr_as_any(value, out)?;
                        let rarg = self.active_region_arg();
                        let nv = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {nv} = call fastcc %ArchxAny @archx_any_binop(%ArchxAny {cur}, %ArchxAny {ra}, i64 {code}, ptr {rarg})"
                        );
                        self.stmt_temps.push(TempDrop {
                            val: nv.clone(),
                            ty: Type::Any,
                        });
                        let _ = writeln!(
                            out,
                            "  call fastcc void @archx_any_set_idx(%ArchxAny {vec_val}, %ArchxAny {idx_any}, %ArchxAny {nv})"
                        );
                    } else {
                        let va = self.eval_expr_as_any(value, out)?;
                        let _ = writeln!(
                            out,
                            "  call fastcc void @archx_any_set_idx(%ArchxAny {vec_val}, %ArchxAny {idx_any}, %ArchxAny {va})"
                        );
                    }
                    return Ok(());
                }
                let Type::Array(elem_ty) = arr_ty else {
                    return Err(Diagnostic::new(
                        format!("cannot index into value of type `{}`", arr_ty.name()),
                        arr_expr.span,
                    ));
                };
                let (idx_ty, raw_idx) = self.eval_expr(idx_expr, out)?;
                let idx_val = if idx_ty == Type::Any {
                    self.emit_unbox_any(&Type::Int, &raw_idx, idx_expr.span, out)?
                } else if idx_ty == Type::Int {
                    raw_idx
                } else {
                    return Err(Diagnostic::new(
                        format!("array index must be `int`, found `{}`", idx_ty.name()),
                        idx_expr.span,
                    ));
                };

                let eff_idx = if *elem_ty == Type::Any {
                    self.used_bounds_fail = true;
                    let len = self.next_tmp();
                    let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec_val}, 0");
                    let neg = self.next_tmp();
                    let _ = writeln!(out, "  {neg} = icmp slt i64 {idx_val}, 0");
                    let adj = self.next_tmp();
                    let _ = writeln!(out, "  {adj} = add i64 {idx_val}, {len}");
                    let eff = self.next_tmp();
                    let _ = writeln!(out, "  {eff} = select i1 {neg}, i64 {adj}, i64 {idx_val}");
                    let oob = self.next_tmp();
                    let _ = writeln!(out, "  {oob} = icmp uge i64 {eff}, {len}");
                    let oob_lbl = self.fresh_label("asgn.oob");
                    let ok_lbl = self.fresh_label("asgn.ok");
                    self.emit_cond_br(&oob, &oob_lbl, &ok_lbl, out);
                    self.start_block(&oob_lbl, out);
                    let _ = writeln!(out, "  call void @archx_bounds_fail(i64 {idx_val}, i64 {len})");
                    let _ = writeln!(out, "  unreachable");
                    self.start_block(&ok_lbl, out);
                    eff
                } else if eval_const_int(idx_expr).map_or(false, |c| c < 0) {
                    self.used_bounds_fail = true;
                    let len = self.next_tmp();
                    let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec_val}, 0");
                    let eff = self.next_tmp();
                    let _ = writeln!(out, "  {eff} = add i64 {len}, {idx_val}");
                    let oob = self.next_tmp();
                    let _ = writeln!(out, "  {oob} = icmp uge i64 {eff}, {len}");
                    let oob_lbl = self.fresh_label("nasgn.oob");
                    let ok_lbl = self.fresh_label("nasgn.ok");
                    self.emit_cond_br(&oob, &oob_lbl, &ok_lbl, out);
                    self.start_block(&oob_lbl, out);
                    let _ = writeln!(out, "  call void @archx_bounds_fail(i64 {idx_val}, i64 {len})");
                    let _ = writeln!(out, "  unreachable");
                    self.start_block(&ok_lbl, out);
                    eff
                } else {
                    self.emit_bounds_check_if_needed(arr_expr, idx_expr, &vec_val, &idx_val, out)?;
                    idx_val
                };

                let data_ptr = self.next_tmp();
                let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {vec_val}, 2");
                let elem_ptr = self.next_tmp();
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let _ = writeln!(
                    out,
                    "  {elem_ptr} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {eff_idx}"
                );

                if let Some(bin_op) = op {
                    if *elem_ty == Type::Any {
                        let code = match bin_op {
                            BinOp::Add => 0,
                            BinOp::Sub => 1,
                            BinOp::Mul => 2,
                            BinOp::Div => 3,
                            BinOp::FloorDiv => 4,
                            BinOp::Mod => 5,
                            BinOp::Pow => 6,
                            _ => {
                                return Err(Diagnostic::new(
                                    format!("unsupported compound assignment `{}=`", bin_op.symbol()),
                                    span,
                                ))
                            }
                        };
                        let old_val = self.next_tmp();
                        let _ = writeln!(out, "  {old_val} = load %ArchxAny, ptr {elem_ptr}, align 8");
                        let ra = self.eval_expr_as_any(value, out)?;
                        let rarg = self.active_region_arg();
                        let nv = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {nv} = call fastcc %ArchxAny @archx_any_binop(%ArchxAny {old_val}, %ArchxAny {ra}, i64 {code}, ptr {rarg})"
                        );
                        self.emit_drop_value(&Type::Any, &old_val, out);
                        let _ = writeln!(out, "  store %ArchxAny {nv}, ptr {elem_ptr}, align 8");
                        return Ok(());
                    }
                    if *elem_ty == Type::Float {
                        let old_val = self.next_tmp();
                        let _ = writeln!(out, "  {old_val} = load double, ptr {elem_ptr}, align 8");
                        let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
                        if rhs_ty != Type::Float {
                            return Err(Diagnostic::new(
                                format!(
                                    "operator `{}=` requires a `float` right-hand side, found `{}`",
                                    bin_op.symbol(),
                                    rhs_ty.name()
                                ),
                                value.span,
                            ));
                        }
                        let new_val = self.emit_float_arith(bin_op, &old_val, &rhs_val, out);
                        let _ = writeln!(out, "  store double {new_val}, ptr {elem_ptr}, align 8");
                        return Ok(());
                    }
                    if *elem_ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires `int` or `float` elements, found `{}`",
                                bin_op.symbol(),
                                elem_ty.name()
                            ),
                            span,
                        ));
                    }
                    let old_val = self.next_tmp();
                    let _ = writeln!(out, "  {old_val} = load i64, ptr {elem_ptr}, align 8");
                    let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
                    if rhs_ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires an `int` right-hand side, found `{}`",
                                bin_op.symbol(),
                                rhs_ty.name()
                            ),
                            value.span,
                        ));
                    }
                    let new_val = self.emit_int_arith(bin_op, &old_val, &rhs_val, out);
                    let _ = writeln!(out, "  store i64 {new_val}, ptr {elem_ptr}, align 8");
                } else {
                    let rhs_val = self.eval_owned_for_slot(&elem_ty, value, out)?;
                    if self.type_needs_drop(&elem_ty) {
                        let old_elem = self.emit_elem_load(&elem_ty, &elem_ptr, out);
                        self.emit_drop_value(&elem_ty, &old_elem, out);
                    }
                    self.emit_elem_store(&elem_ty, &rhs_val, &elem_ptr, out);
                }

                Ok(())
            }
        }
    }

    pub(super) fn gen_field_assign(
        &mut self,
        base_expr: &Expr,
        field: &str,
        op: Option<BinOp>,
        value: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if let ExprKind::Index {
            target: arr_expr,
            index: idx_expr,
        } = &base_expr.kind
        {
            if let ExprKind::Var(aname) = &arr_expr.kind {
                if let Some(entry) = self.lookup_var(aname).cloned() {
                    if let VarStorage::Soa {
                        struct_name,
                        len_val,
                        planes,
                    } = entry.storage
                    {
                        let (fidx, fty) = self.lookup_struct_field(&struct_name, field, span)?;
                        let (idx_ty, idx_val) = self.eval_expr(idx_expr, out)?;
                        if idx_ty != Type::Int {
                            return Err(Diagnostic::new(
                                format!("array index must be `int`, found `{}`", idx_ty.name()),
                                idx_expr.span,
                            ));
                        }
                        self.emit_raw_len_bounds_check(
                            arr_expr, idx_expr, &len_val, &idx_val, out,
                        )?;
                        let plane_ptr = &planes[fidx].1;
                        let mem_ty = elem_mem_ir_type(&fty);
                        let ep = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {ep} = getelementptr inbounds {mem_ty}, ptr {plane_ptr}, i64 {idx_val}"
                        );
                        return self
                            .finish_scalar_or_typed_ptr_assign(&fty, &ep, true, op, value, span, out);
                    }
                }
            }

            let (arr_ty, vec_val) = self.eval_expr(arr_expr, out)?;
            let Type::Array(elem_ty) = arr_ty else {
                return Err(Diagnostic::new(
                    format!("cannot index into `{}`", arr_ty.name()),
                    arr_expr.span,
                ));
            };
            let Type::Struct(sname) = *elem_ty else {
                return Err(Diagnostic::new(
                    format!("cannot access field `{field}` on `{}`", elem_ty.name()),
                    span,
                ));
            };
            let (fidx, fty) = self.lookup_struct_field(&sname, field, span)?;
            if let Some(root) = root_var_of_expr(arr_expr) {
                self.check_region_escape_target(root, &fty, span)?;
            }
            let (idx_ty, idx_val) = self.eval_expr(idx_expr, out)?;
            if idx_ty != Type::Int {
                return Err(Diagnostic::new(
                    format!("array index must be `int`, found `{}`", idx_ty.name()),
                    idx_expr.span,
                ));
            }
            self.emit_bounds_check_if_needed(arr_expr, idx_expr, &vec_val, &idx_val, out)?;
            let data_ptr = self.next_tmp();
            let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {vec_val}, 2");
            let fptr = self.next_tmp();
            let _ = writeln!(
                out,
                "  {fptr} = getelementptr inbounds %ArchxStruct_{sname}, ptr {data_ptr}, i64 {idx_val}, i32 {fidx}"
            );
            return self
                .finish_scalar_or_typed_ptr_assign(&fty, &fptr, false, op, value, span, out);
        }

        if let ExprKind::Var(vname) = &base_expr.kind {
            let entry = self.lookup_var(vname).cloned().ok_or_else(|| {
                Diagnostic::new(format!("undefined variable `{vname}`"), base_expr.span)
            })?;
            let Type::Struct(sname) = entry.ty else {
                return Err(Diagnostic::new(
                    format!("cannot access field `{field}` on `{}`", entry.ty.name()),
                    span,
                ));
            };
            let (fidx, fty) = self.lookup_struct_field(&sname, field, span)?;
            self.check_region_escape_target(vname, &fty, span)?;
            let VarStorage::Slot(slot_ptr) = entry.storage else {
                return Err(Diagnostic::new(
                    format!("internal error: mutated struct `{vname}` lacked a slot"),
                    span,
                ));
            };
            let fptr = self.next_tmp();
            let _ = writeln!(
                out,
                "  {fptr} = getelementptr inbounds %ArchxStruct_{sname}, ptr {slot_ptr}, i32 0, i32 {fidx}"
            );
            return self
                .finish_scalar_or_typed_ptr_assign(&fty, &fptr, false, op, value, span, out);
        }

        Err(Diagnostic::new(
            "field assignment requires a struct variable or indexed struct element",
            span,
        ))
    }

    pub(super) fn finish_scalar_or_typed_ptr_assign(
        &mut self,
        fty: &Type,
        fptr: &str,
        bool_as_i8: bool,
        op: Option<BinOp>,
        value: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if let Some(bin_op) = op {
            if *fty == Type::Float {
                let old_val = self.next_tmp();
                let _ = writeln!(out, "  {old_val} = load double, ptr {fptr}, align 8");
                let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
                if rhs_ty != Type::Float {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}=` requires a `float` right-hand side, found `{}`",
                            bin_op.symbol(),
                            rhs_ty.name()
                        ),
                        value.span,
                    ));
                }
                let new_val = self.emit_float_arith(bin_op, &old_val, &rhs_val, out);
                let _ = writeln!(out, "  store double {new_val}, ptr {fptr}, align 8");
                return Ok(());
            }
            if *fty != Type::Int {
                return Err(Diagnostic::new(
                    format!(
                        "operator `{}=` requires an `int` or `float` field, found `{}`",
                        bin_op.symbol(),
                        fty.name()
                    ),
                    span,
                ));
            }
            let old_val = self.next_tmp();
            let _ = writeln!(out, "  {old_val} = load i64, ptr {fptr}, align 8");
            let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
            if rhs_ty != Type::Int {
                return Err(Diagnostic::new(
                    format!(
                        "operator `{}=` requires an `int` right-hand side, found `{}`",
                        bin_op.symbol(),
                        rhs_ty.name()
                    ),
                    value.span,
                ));
            }
            let new_val = self.emit_int_arith(bin_op, &old_val, &rhs_val, out);
            let _ = writeln!(out, "  store i64 {new_val}, ptr {fptr}, align 8");
            return Ok(());
        }

        let (rhs_ty, raw_rhs) = self.eval_expr_typed(value, Some(fty), out)?;
        if rhs_ty != *fty {
            return Err(Diagnostic::new(
                format!("field expects `{}`, found `{}`", fty.name(), rhs_ty.name()),
                value.span,
            ));
        }

        if bool_as_i8 && *fty == Type::Bool {
            self.emit_elem_store(&Type::Bool, &raw_rhs, fptr, out);
            return Ok(());
        }

        let needs_drop = self.type_needs_drop(fty);
        let rhs_val = if needs_drop {
            if self.claim_stmt_temp(&raw_rhs) {
                raw_rhs
            } else {
                self.emit_clone_value(fty, &raw_rhs, out)
            }
        } else {
            raw_rhs
        };
        let ty_ir = ir_type(fty);
        let align = ir_align(fty);
        if needs_drop {
            let old_v = self.next_tmp();
            let _ = writeln!(out, "  {old_v} = load {ty_ir}, ptr {fptr}, align {align}");
            self.emit_drop_value(fty, &old_v, out);
        }
        let _ = writeln!(out, "  store {ty_ir} {rhs_val}, ptr {fptr}, align {align}");
        Ok(())
    }

    pub(super) fn lookup_struct_field(&self, sname: &str, field: &str, span: Span) -> Result<(usize, Type)> {
        let fields = self
            .structs
            .get(sname)
            .ok_or_else(|| Diagnostic::new(format!("unknown struct `{sname}`"), span))?;
        for (i, f) in fields.iter().enumerate() {
            if f.name == field {
                return Ok((i, f.ty.clone()));
            }
        }
        Err(Diagnostic::new(
            format!("struct `{sname}` has no field `{field}`"),
            span,
        ))
    }

}
