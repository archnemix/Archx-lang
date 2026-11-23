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

            StmtKind::Assert { cond, msg } => {
                let (cond_ty, cond_val) = self.eval_expr(cond, out)?;
                if cond_ty != Type::Bool {
                    return Err(Diagnostic::new(
                        format!("`assert` condition must be `bool`, found `{}`", cond_ty.name()),
                        cond.span,
                    ));
                }
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
                        if let Some(entry) = self.lookup_var(vname).cloned() {
                            if !entry.is_param
                                && self.type_needs_drop(&entry.ty)
                                && matches!(entry.storage, VarStorage::Slot(_))
                            {
                                if let Some(expected) = &expected_hint {
                                    if *expected != entry.ty {
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

                    let (ty, raw_val) = self.eval_expr_typed(expr, expected_hint.as_ref(), out)?;

                    if self.is_main {
                        if ty != Type::Int {
                            return Err(Diagnostic::new(
                                "`main` must return an `int`",
                                stmt.span,
                            ));
                        }
                        self.flush_stmt_temps(out);
                        self.emit_func_exit_cleanup(None, out);
                        let truncated = self.next_tmp();
                        let _ = writeln!(out, "  {truncated} = trunc i64 {raw_val} to i32");
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
                    match self.current_ret {
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

            StmtKind::While { cond, body } => self.gen_while(cond, body, out),

            StmtKind::For {
                var,
                start,
                end,
                step,
                body,
            } => self.gen_for(var, start, end, step.as_ref(), body, stmt.span, out),

            StmtKind::ForEach { var, iter, body } => {
                self.gen_foreach(var, iter, body, stmt.span, out)
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

            StmtKind::Region { body } => self.gen_region(body, out),

            StmtKind::Break => {
                let (label, sdepth, rdepth) = self
                    .loop_stack
                    .last()
                    .map(|l| (l.break_label.clone(), l.scope_depth, l.region_depth))
                    .ok_or_else(|| {
                        Diagnostic::new("`break` is only allowed inside a loop", stmt.span)
                    })?;
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
                let (cond_ty, cond_val) = self.eval_expr(cond, out)?;
                if cond_ty != Type::Bool {
                    return Err(Diagnostic::new(
                        "`if` condition must be a `bool`",
                        cond.span,
                    ));
                }
                self.flush_stmt_temps(out);

                let then_label = self.fresh_label("if.then");
                let else_label = self.fresh_label("if.else");
                let merge_label = self.fresh_label("if.merge");

                self.emit_cond_br(&cond_val, &then_label, &else_label, out);

                self.start_block(&then_label, out);
                self.push_scope();
                self.gen_block(then_body, out)?;
                self.pop_scope_with_drops(out);
                let then_terminated = self.terminated;
                if !then_terminated {
                    self.emit_br(&merge_label, out);
                }

                self.start_block(&else_label, out);
                if let Some(body) = else_body {
                    self.push_scope();
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
            validate_type(t, &self.structs, span)?;
            if t.is_array() {
                self.used_vec_type = true;
            }
            if *t == Type::Str {
                self.used_str_type = true;
            }
        }

        let is_mutated = self.mutated_vars.contains(name);

        if !is_mutated && self.region_stack.is_empty() {
            if let Some(soa_storage) =
                self.try_emit_transparent_soa(name, declared_ty, value, rest_in_block, out)?
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

        let (ty, raw_val) = self.eval_expr_typed(value, declared_ty, out)?;
        if ty == Type::Void {
            return Err(Diagnostic::new(
                "cannot store a `void` / `None` value in a variable",
                span,
            ));
        }
        if let Some(expected) = declared_ty {
            if *expected != ty {
                return Err(Diagnostic::new(
                    format!(
                        "type mismatch in `{name}`: expected `{}`, found `{}`",
                        expected.name(),
                        ty.name()
                    ),
                    span,
                ));
            }
        }

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
        let val = if needs_drop && !matches!(&value.kind, ExprKind::Str(_)) {
            if self.claim_stmt_temp(&raw_val) {
                raw_val
            } else {
                self.emit_clone_value(&ty, &raw_val, out)
            }
        } else {
            raw_val
        };
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
                    let _ = writeln!(out, "  store i64 {new_val}, ptr {ptr}, align 8");
                } else {
                    let (val_ty, raw_val) = self.eval_expr_typed(value, Some(&entry.ty), out)?;
                    if val_ty != entry.ty {
                        return Err(Diagnostic::new(
                            format!(
                                "cannot assign `{}` to variable `{}` of type `{}`",
                                val_ty.name(),
                                name,
                                entry.ty.name()
                            ),
                            span,
                        ));
                    }
                    let needs_drop = self.type_needs_drop(&entry.ty);
                    let new_val = if needs_drop && !matches!(&value.kind, ExprKind::Str(_)) {
                        if self.claim_stmt_temp(&raw_val) {
                            raw_val
                        } else {
                            self.emit_clone_value(&entry.ty, &raw_val, out)
                        }
                    } else {
                        raw_val
                    };
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
                let Type::Array(elem_ty) = arr_ty else {
                    return Err(Diagnostic::new(
                        format!("cannot index into value of type `{}`", arr_ty.name()),
                        arr_expr.span,
                    ));
                };
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
                let elem_ptr = self.next_tmp();
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let _ = writeln!(
                    out,
                    "  {elem_ptr} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {idx_val}"
                );

                if let Some(bin_op) = op {
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
                    let (rhs_ty, raw_rhs) = self.eval_expr_typed(value, Some(&elem_ty), out)?;
                    if rhs_ty != *elem_ty {
                        return Err(Diagnostic::new(
                            format!(
                                "cannot assign `{}` to element of `[{}]`",
                                rhs_ty.name(),
                                elem_ty.name()
                            ),
                            value.span,
                        ));
                    }
                    let needs_drop = self.type_needs_drop(&elem_ty);
                    let rhs_val = if needs_drop {
                        if self.claim_stmt_temp(&raw_rhs) {
                            raw_rhs
                        } else {
                            self.emit_clone_value(&elem_ty, &raw_rhs, out)
                        }
                    } else {
                        raw_rhs
                    };
                    if needs_drop {
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
