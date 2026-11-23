//! Checked heap/slice allocation helpers (`2^47` invariant, `align 16`), element load/store/fill loops,
//! and induction/array bounds-check elision analyses.

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result};

use super::analysis::*;
use super::*;

impl Codegen {
    // ---------------- Array & Memory Helpers ---------------------------------

    pub(super) fn build_vec_val(&mut self, len: &str, cap: &str, data: &str, out: &mut String) -> String {
        let v0 = self.next_tmp();
        let _ = writeln!(out, "  {v0} = insertvalue %ArchxVec poison, i64 {len}, 0");
        let v1 = self.next_tmp();
        let _ = writeln!(out, "  {v1} = insertvalue %ArchxVec {v0}, i64 {cap}, 1");
        let v2 = self.next_tmp();
        let _ = writeln!(out, "  {v2} = insertvalue %ArchxVec {v1}, ptr {data}, 2");
        v2
    }

    pub(super) fn emit_elem_sizeof(&mut self, elem_ty: &Type, out: &mut String) -> String {
        match elem_ty {
            Type::Bool => "1".to_string(),
            Type::Int => "8".to_string(),
            Type::Str => "16".to_string(),
            Type::Array(_) => "24".to_string(),
            Type::Struct(sname) => {
                let gp = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {gp} = getelementptr %ArchxStruct_{sname}, ptr null, i64 1"
                );
                let sz = self.next_tmp();
                let _ = writeln!(out, "  {sz} = ptrtoint ptr {gp} to i64");
                sz
            }
            Type::Void => "0".to_string(),
        }
    }

    pub(super) fn emit_type_bytes_const_mul(&mut self, elem_ty: &Type, count: i64, out: &mut String) -> String {
        if count == 0 {
            return "1".to_string();
        }
        let sz = self.emit_elem_sizeof(elem_ty, out);
        if let Ok(c_sz) = sz.parse::<i64>() {
            return (count * c_sz).to_string();
        }
        self.emit_elem_bytes_val_mul(&count.to_string(), &sz, out)
    }

    pub(super) fn emit_elem_bytes_val_mul(&mut self, count: &str, elem_sz: &str, out: &mut String) -> String {
        if elem_sz == "1" {
            let z = self.next_tmp();
            let _ = writeln!(out, "  {z} = icmp eq i64 {count}, 0");
            let r = self.next_tmp();
            let _ = writeln!(out, "  {r} = select i1 {z}, i64 1, i64 {count}");
            return r;
        }
        self.used_smul_ovf = true;
        self.used_oom_fail = true;
        let pair = self.next_tmp();
        let _ = writeln!(
            out,
            "  {pair} = call {{ i64, i1 }} @llvm.smul.with.overflow.i64(i64 {count}, i64 {elem_sz})"
        );
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = extractvalue {{ i64, i1 }} {pair}, 0");
        let ovf = self.next_tmp();
        let _ = writeln!(out, "  {ovf} = extractvalue {{ i64, i1 }} {pair}, 1");
        let oom_lbl = self.fresh_label("mul.oom");
        let ok_lbl = self.fresh_label("mul.ok");
        self.emit_cond_br(&ovf, &oom_lbl, &ok_lbl, out);

        self.start_block(&oom_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        let z = self.next_tmp();
        let _ = writeln!(out, "  {z} = icmp eq i64 {raw}, 0");
        let r = self.next_tmp();
        let _ = writeln!(out, "  {r} = select i1 {z}, i64 1, i64 {raw}");
        r
    }

    pub(super) fn emit_elem_bytes_mul(&mut self, count: &str, elem_size: i64, out: &mut String) -> String {
        let raw = if elem_size == 1 {
            count.to_string()
        } else {
            let r = self.next_tmp();
            let _ = writeln!(out, "  {r} = mul nuw nsw i64 {count}, {elem_size}");
            r
        };
        let z = self.next_tmp();
        let _ = writeln!(out, "  {z} = icmp eq i64 {raw}, 0");
        let safe = self.next_tmp();
        let _ = writeln!(out, "  {safe} = select i1 {z}, i64 1, i64 {raw}");
        safe
    }

    pub(super) fn emit_checked_malloc(&mut self, bytes: &str, out: &mut String) -> String {
        self.used_malloc = true;
        self.used_oom_fail = true;
        let ptr = self.next_tmp();
        let _ = writeln!(out, "  {ptr} = call noalias align 16 ptr @malloc(i64 {bytes})");
        let is_null = self.next_tmp();
        let _ = writeln!(out, "  {is_null} = icmp eq ptr {ptr}, null");
        let ok_lbl = self.fresh_label("alloc.ok");
        let oom_lbl = self.fresh_label("alloc.oom");
        self.emit_cond_br(&is_null, &oom_lbl, &ok_lbl, out);

        self.start_block(&oom_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        ptr
    }

    pub(super) fn emit_checked_calloc(&mut self, count: &str, elem_size: i64, out: &mut String) -> String {
        self.used_calloc = true;
        self.used_oom_fail = true;
        let safe_count = if count == "0" {
            "1".to_string()
        } else {
            let z = self.next_tmp();
            let _ = writeln!(out, "  {z} = icmp eq i64 {count}, 0");
            let s = self.next_tmp();
            let _ = writeln!(out, "  {s} = select i1 {z}, i64 1, i64 {count}");
            s
        };
        let ptr = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ptr} = call noalias align 16 ptr @calloc(i64 {safe_count}, i64 {elem_size})"
        );
        let is_null = self.next_tmp();
        let _ = writeln!(out, "  {is_null} = icmp eq ptr {ptr}, null");
        let ok_lbl = self.fresh_label("calloc.ok");
        let oom_lbl = self.fresh_label("calloc.oom");
        self.emit_cond_br(&is_null, &oom_lbl, &ok_lbl, out);

        self.start_block(&oom_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        ptr
    }

    pub(super) fn emit_checked_realloc(&mut self, old_ptr: &str, bytes: &str, out: &mut String) -> String {
        self.used_realloc = true;
        self.used_oom_fail = true;
        let ptr = self.next_tmp();
        let _ = writeln!(out, "  {ptr} = call align 16 ptr @realloc(ptr {old_ptr}, i64 {bytes})");
        let is_null = self.next_tmp();
        let _ = writeln!(out, "  {is_null} = icmp eq ptr {ptr}, null");
        let ok_lbl = self.fresh_label("realloc.ok");
        let oom_lbl = self.fresh_label("realloc.oom");
        self.emit_cond_br(&is_null, &oom_lbl, &ok_lbl, out);

        self.start_block(&oom_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        ptr
    }

    pub(super) fn emit_scalar_fill_loop(
        &mut self,
        elem_ty: &Type,
        init_val: &str,
        data_ptr: &str,
        count_val: &str,
        out: &mut String,
    ) {
        if *elem_ty == Type::Bool {
            self.used_memset = true;
            let byte_val = self.next_tmp();
            let _ = writeln!(out, "  {byte_val} = zext i1 {init_val} to i8");
            let _ = writeln!(
                out,
                "  call void @llvm.memset.p0.i64(ptr nonnull align 16 {data_ptr}, i8 {byte_val}, i64 {count_val}, i1 false)"
            );
            return;
        }
        if *elem_ty == Type::Int && init_val == "0" {
            self.used_memset = true;
            let bytes = self.next_tmp();
            let _ = writeln!(out, "  {bytes} = shl nuw nsw i64 {count_val}, 3");
            let _ = writeln!(
                out,
                "  call void @llvm.memset.p0.i64(ptr nonnull align 16 {data_ptr}, i8 0, i64 {bytes}, i1 false)"
            );
            return;
        }

        let pos = self.next_tmp();
        let _ = writeln!(out, "  {pos} = icmp sgt i64 {count_val}, 0");
        let pre_lbl = self.fresh_label("fill.pre");
        let body_lbl = self.fresh_label("fill.body");
        let end_lbl = self.fresh_label("fill.end");
        self.emit_cond_br(&pos, &pre_lbl, &end_lbl, out);

        self.start_block(&pre_lbl, out);
        self.emit_br(&body_lbl, out);

        self.start_block(&body_lbl, out);
        let fi = self.next_tmp();
        let fnext = self.next_tmp();
        let _ = writeln!(
            out,
            "  {fi} = phi i64 [ 0, %{pre_lbl} ], [ {fnext}, %{body_lbl} ]"
        );
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds i64, ptr {data_ptr}, i64 {fi}"
        );
        let _ = writeln!(out, "  store i64 {init_val}, ptr {ep}, align 8");
        let _ = writeln!(out, "  {fnext} = add nuw nsw i64 {fi}, 1");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {fnext}, {count_val}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&end_lbl, out);
    }

    pub(super) fn emit_general_fill_loop(
        &mut self,
        elem_ty: &Type,
        raw_init: &str,
        data_ptr: &str,
        count_val: &str,
        out: &mut String,
    ) {
        if matches!(elem_ty, Type::Int | Type::Bool) {
            self.emit_scalar_fill_loop(elem_ty, raw_init, data_ptr, count_val, out);
            return;
        }

        let needs_drop = self.type_needs_drop(elem_ty);
        let owned_proto = needs_drop && self.claim_stmt_temp(raw_init);

        let pos = self.next_tmp();
        let _ = writeln!(out, "  {pos} = icmp sgt i64 {count_val}, 0");
        let pre_lbl = self.fresh_label("gfill.pre");
        let body_lbl = self.fresh_label("gfill.body");
        let latch_lbl = self.fresh_label("gfill.latch");
        let end_lbl = self.fresh_label("gfill.end");
        self.emit_cond_br(&pos, &pre_lbl, &end_lbl, out);

        self.start_block(&pre_lbl, out);
        self.emit_br(&body_lbl, out);

        self.start_block(&body_lbl, out);
        let fi = self.next_tmp();
        let fnext = self.next_tmp();
        let _ = writeln!(
            out,
            "  {fi} = phi i64 [ 0, %{pre_lbl} ], [ {fnext}, %{latch_lbl} ]"
        );
        let mem_ty = elem_mem_ir_type(elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {fi}"
        );
        let elem_copy = if needs_drop {
            self.emit_clone_value(elem_ty, raw_init, out)
        } else {
            raw_init.to_string()
        };
        self.emit_elem_store(elem_ty, &elem_copy, &ep, out);
        self.emit_br(&latch_lbl, out);

        self.start_block(&latch_lbl, out);
        let _ = writeln!(out, "  {fnext} = add nuw nsw i64 {fi}, 1");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {fnext}, {count_val}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&end_lbl, out);
        if owned_proto {
            self.emit_drop_value(elem_ty, raw_init, out);
        }
    }

    pub(super) fn emit_elem_store(&mut self, elem_ty: &Type, val: &str, ptr: &str, out: &mut String) {
        if *elem_ty == Type::Bool {
            let b = self.next_tmp();
            let _ = writeln!(out, "  {b} = zext i1 {val} to i8");
            let _ = writeln!(out, "  store i8 {b}, ptr {ptr}, align 1");
        } else {
            let _ = writeln!(
                out,
                "  store {} {val}, ptr {ptr}, align {}",
                ir_type(elem_ty),
                ir_align(elem_ty)
            );
        }
    }

    pub(super) fn emit_elem_load(&mut self, elem_ty: &Type, ptr: &str, out: &mut String) -> String {
        if *elem_ty == Type::Bool {
            let b = self.next_tmp();
            let _ = writeln!(out, "  {b} = load i8, ptr {ptr}, align 1");
            let r = self.next_tmp();
            let _ = writeln!(out, "  {r} = trunc i8 {b} to i1");
            r
        } else {
            let r = self.next_tmp();
            let _ = writeln!(
                out,
                "  {r} = load {}, ptr {ptr}, align {}",
                ir_type(elem_ty),
                ir_align(elem_ty)
            );
            r
        }
    }

    pub(super) fn emit_repeat_count_check(
        &mut self,
        count_expr: &Expr,
        count_val: &str,
        out: &mut String,
    ) -> Result<()> {
        if let Some(c) = eval_const_int(count_expr) {
            if c < 0 {
                return Err(Diagnostic::new(
                    format!("array repeat count cannot be negative (`{c}`)"),
                    count_expr.span,
                ));
            }
            if c > MAX_ARRAY_LEN {
                return Err(Diagnostic::new(
                    format!("array repeat count `{c}` exceeds maximum supported size"),
                    count_expr.span,
                ));
            }
            return Ok(());
        }

        if let ExprKind::Call { name, args } = &count_expr.kind {
            if name == "len" && args.len() == 1 {
                return Ok(());
            }
        }

        self.used_neg_len_fail = true;
        let out_of_range = self.next_tmp();
        let _ = writeln!(
            out,
            "  {out_of_range} = icmp ugt i64 {count_val}, {MAX_ARRAY_LEN}"
        );
        let ok_lbl = self.fresh_label("repeat.ok");
        let bad_lbl = self.fresh_label("repeat.bad");
        self.emit_cond_br(&out_of_range, &bad_lbl, &ok_lbl, out);

        self.start_block(&bad_lbl, out);
        let _ = writeln!(out, "  call void @archx_neg_len_fail(i64 {count_val})");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        if let ExprKind::Var(v) = &count_expr.kind {
            if !self.mutated_vars.contains(v) {
                self.scopes.last_mut().unwrap().bounded_vars.insert(v.clone());
            }
        }
        Ok(())
    }

    pub(super) fn is_bounded_var(&self, name: &str) -> bool {
        self.scopes.iter().rev().any(|s| s.bounded_vars.contains(name))
    }

    pub(super) fn emit_bounds_check_if_needed(
        &mut self,
        arr_expr: &Expr,
        idx_expr: &Expr,
        vec_val: &str,
        idx_val: &str,
        out: &mut String,
    ) -> Result<()> {
        if let Some(c) = eval_const_int(idx_expr) {
            if c < 0 {
                return Err(Diagnostic::new(
                    format!("array index cannot be negative (`{c}`)"),
                    idx_expr.span,
                ));
            }
            if let ExprKind::Var(name) = &arr_expr.kind {
                if let Some(&KnownLen::Const(len_c)) = self.lookup_known_len(name) {
                    if c >= len_c {
                        return Err(Diagnostic::new(
                            format!("array index `{c}` is out of bounds for length `{len_c}`"),
                            idx_expr.span,
                        ));
                    }
                    return Ok(());
                }
            }
        }

        if self.can_elide_bounds_check(arr_expr, idx_expr) {
            return Ok(());
        }

        self.used_bounds_fail = true;
        let len_val = self.next_tmp();
        let _ = writeln!(out, "  {len_val} = extractvalue %ArchxVec {vec_val}, 0");
        let oob = self.next_tmp();
        let _ = writeln!(out, "  {oob} = icmp uge i64 {idx_val}, {len_val}");
        let ok_lbl = self.fresh_label("idx.ok");
        let fail_lbl = self.fresh_label("idx.oob");
        self.emit_cond_br(&oob, &fail_lbl, &ok_lbl, out);

        self.start_block(&fail_lbl, out);
        let _ = writeln!(
            out,
            "  call void @archx_bounds_fail(i64 {idx_val}, i64 {len_val})"
        );
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        Ok(())
    }

    pub(super) fn emit_raw_len_bounds_check(
        &mut self,
        arr_expr: &Expr,
        idx_expr: &Expr,
        len_val: &str,
        idx_val: &str,
        out: &mut String,
    ) -> Result<()> {
        if let Some(c) = eval_const_int(idx_expr) {
            if c < 0 {
                return Err(Diagnostic::new(
                    format!("array index cannot be negative (`{c}`)"),
                    idx_expr.span,
                ));
            }
            if let ExprKind::Var(name) = &arr_expr.kind {
                if let Some(&KnownLen::Const(len_c)) = self.lookup_known_len(name) {
                    if c >= len_c {
                        return Err(Diagnostic::new(
                            format!("array index `{c}` is out of bounds for length `{len_c}`"),
                            idx_expr.span,
                        ));
                    }
                    return Ok(());
                }
            }
        }
        if self.can_elide_bounds_check(arr_expr, idx_expr) {
            return Ok(());
        }
        self.used_bounds_fail = true;
        let oob = self.next_tmp();
        let _ = writeln!(out, "  {oob} = icmp uge i64 {idx_val}, {len_val}");
        let ok_lbl = self.fresh_label("idx.ok");
        let fail_lbl = self.fresh_label("idx.oob");
        self.emit_cond_br(&oob, &fail_lbl, &ok_lbl, out);
        self.start_block(&fail_lbl, out);
        let _ = writeln!(
            out,
            "  call void @archx_bounds_fail(i64 {idx_val}, i64 {len_val})"
        );
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;
        self.start_block(&ok_lbl, out);
        Ok(())
    }

    pub(super) fn can_elide_bounds_check(&self, arr_expr: &Expr, idx_expr: &Expr) -> bool {
        let ExprKind::Var(arr_name) = &arr_expr.kind else {
            return false;
        };
        let ExprKind::Var(idx_name) = &idx_expr.kind else {
            return false;
        };

        let known_len = self.lookup_known_len(arr_name);

        for bound in self.loop_bounds.iter().rev() {
            if bound.var != *idx_name {
                continue;
            }
            match (&bound.upper, known_len) {
                (UpperBound::LenOf(a), _) if a == arr_name => return true,
                (UpperBound::Const(n), Some(KnownLen::Const(m))) if *n <= *m => return true,
                (UpperBound::Var(v), Some(KnownLen::SameAsVar(w))) if v == w => return true,
                (UpperBound::LenOf(a), Some(KnownLen::SameAsArray(b))) if a == b => return true,
                _ => {}
            }
        }
        false
    }

    pub(super) fn infer_known_array_len(&self, expr: &Expr) -> Option<KnownLen> {
        match &expr.kind {
            ExprKind::ArrayLit(elems) => Some(KnownLen::Const(elems.len() as i64)),
            ExprKind::ArrayRepeat { count, .. } => {
                if let Some(c) = eval_const_int(count) {
                    if c >= 0 {
                        return Some(KnownLen::Const(c));
                    }
                }
                match &count.kind {
                    ExprKind::Var(v) if !self.mutated_vars.contains(v) => {
                        Some(KnownLen::SameAsVar(v.clone()))
                    }
                    ExprKind::Call { name, args } if name == "len" && args.len() == 1 => {
                        if let ExprKind::Var(arr) = &args[0].kind {
                            if !self.mutated_vars.contains(arr) {
                                return Some(KnownLen::SameAsArray(arr.clone()));
                            }
                        }
                        None
                    }
                    _ => None,
                }
            }
            _ => None,
        }
    }

    pub(super) fn derive_for_bound(
        &self,
        iv: &str,
        start: &Expr,
        end: &Expr,
        body: &[Stmt],
    ) -> Option<InductionBound> {
        let start_const = eval_const_int(start)?;
        if start_const < 0 {
            return None;
        }
        if stmts_assign_var(body, iv) {
            return None;
        }

        if let Some(end_const) = eval_const_int(end) {
            return Some(InductionBound {
                var: iv.to_string(),
                upper: UpperBound::Const(end_const),
            });
        }

        match &end.kind {
            ExprKind::Var(v) if !stmts_assign_var(body, v) => Some(InductionBound {
                var: iv.to_string(),
                upper: UpperBound::Var(v.clone()),
            }),
            ExprKind::Call { name, args } if name == "len" && args.len() == 1 => {
                if let ExprKind::Var(arr_name) = &args[0].kind {
                    if !stmts_mutate_array_len(body, arr_name) {
                        return Some(InductionBound {
                            var: iv.to_string(),
                            upper: UpperBound::LenOf(arr_name.clone()),
                        });
                    }
                }
                None
            }
            _ => None,
        }
    }

    pub(super) fn collect_unchecked_for_arrays(&self, iv: &str, stmts: &[Stmt]) -> Vec<String> {
        let mut out = Vec::new();
        for s in stmts {
            self.scan_stmt_for_iv_arrays(iv, stmts, s, &mut out);
        }
        out
    }

    pub(super) fn scan_stmt_for_iv_arrays(
        &self,
        iv: &str,
        loop_body: &[Stmt],
        stmt: &Stmt,
        out: &mut Vec<String>,
    ) {
        match &stmt.kind {
            StmtKind::Let { value, .. } => self.scan_expr_for_iv_arrays(iv, loop_body, value, out),
            StmtKind::Assign { target, value, .. } => {
                match target {
                    AssignTarget::Index {
                        target: arr,
                        index: idx,
                    } => {
                        self.consider_iv_array(iv, loop_body, arr, idx, out);
                        self.scan_expr_for_iv_arrays(iv, loop_body, arr, out);
                        self.scan_expr_for_iv_arrays(iv, loop_body, idx, out);
                    }
                    AssignTarget::Field { target: base, .. } => {
                        if let ExprKind::Index {
                            target: arr,
                            index: idx,
                        } = &base.kind
                        {
                            self.consider_iv_array(iv, loop_body, arr, idx, out);
                        }
                        self.scan_expr_for_iv_arrays(iv, loop_body, base, out);
                    }
                    AssignTarget::Var(_) => {}
                }
                self.scan_expr_for_iv_arrays(iv, loop_body, value, out);
            }
            StmtKind::Expr(e) => self.scan_expr_for_iv_arrays(iv, loop_body, e, out),
            StmtKind::Return(Some(e)) => self.scan_expr_for_iv_arrays(iv, loop_body, e, out),
            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                self.scan_expr_for_iv_arrays(iv, loop_body, cond, out);
                for inner in then_body {
                    self.scan_stmt_for_iv_arrays(iv, loop_body, inner, out);
                }
                if let Some(eb) = else_body {
                    for inner in eb {
                        self.scan_stmt_for_iv_arrays(iv, loop_body, inner, out);
                    }
                }
            }
            StmtKind::Region { body } => {
                for inner in body {
                    self.scan_stmt_for_iv_arrays(iv, loop_body, inner, out);
                }
            }
            _ => {}
        }
    }

    pub(super) fn scan_expr_for_iv_arrays(
        &self,
        iv: &str,
        loop_body: &[Stmt],
        expr: &Expr,
        out: &mut Vec<String>,
    ) {
        match &expr.kind {
            ExprKind::Index { target, index } => {
                self.consider_iv_array(iv, loop_body, target, index, out);
                self.scan_expr_for_iv_arrays(iv, loop_body, target, out);
                self.scan_expr_for_iv_arrays(iv, loop_body, index, out);
            }
            ExprKind::Field { target, .. } => {
                self.scan_expr_for_iv_arrays(iv, loop_body, target, out);
            }
            ExprKind::Unary { expr: inner, .. } => {
                self.scan_expr_for_iv_arrays(iv, loop_body, inner, out);
            }
            ExprKind::Binary { lhs, rhs, .. } => {
                self.scan_expr_for_iv_arrays(iv, loop_body, lhs, out);
                self.scan_expr_for_iv_arrays(iv, loop_body, rhs, out);
            }
            ExprKind::Call { args, .. } | ExprKind::ArrayLit(args) => {
                for a in args {
                    self.scan_expr_for_iv_arrays(iv, loop_body, a, out);
                }
            }
            ExprKind::ArrayRepeat { value, count } => {
                self.scan_expr_for_iv_arrays(iv, loop_body, value, out);
                self.scan_expr_for_iv_arrays(iv, loop_body, count, out);
            }
            ExprKind::Int(_) | ExprKind::Bool(_) | ExprKind::Str(_) | ExprKind::Var(_) => {}
        }
    }

    pub(super) fn consider_iv_array(
        &self,
        iv: &str,
        loop_body: &[Stmt],
        arr_expr: &Expr,
        idx_expr: &Expr,
        out: &mut Vec<String>,
    ) {
        let ExprKind::Var(idx_name) = &idx_expr.kind else {
            return;
        };
        if idx_name != iv {
            return;
        }
        let ExprKind::Var(arr_name) = &arr_expr.kind else {
            return;
        };
        if self.can_elide_bounds_check(arr_expr, idx_expr) {
            return;
        }
        let Some(entry) = self.lookup_var(arr_name) else {
            return;
        };
        if !entry.ty.is_array() || stmts_mutate_array_len(loop_body, arr_name) {
            return;
        }
        if !out.contains(arr_name) {
            out.push(arr_name.clone());
        }
    }

    pub(super) fn analyze_strided_while(&self, cond: &Expr, body: &[Stmt]) -> Option<StridedWhilePlan> {
        let ExprKind::Binary {
            op: BinOp::Lt,
            lhs,
            rhs,
        } = &cond.kind
        else {
            return None;
        };
        let ExprKind::Var(idx_name) = &lhs.kind else {
            return None;
        };
        if stmts_contain_loop(body) {
            return None;
        }
        let idx_entry = self.lookup_var(idx_name)?;
        if idx_entry.ty != Type::Int {
            return None;
        }
        let VarStorage::Slot(idx_slot) = &idx_entry.storage else {
            return None;
        };

        let (bound_kind, proven_upper) = match &rhs.kind {
            ExprKind::Var(bname) => {
                let b_entry = self.lookup_var(bname)?;
                if b_entry.ty != Type::Int || stmts_assign_var(body, bname) {
                    return None;
                }
                (WhileBoundKind::Var(bname.clone()), UpperBound::Var(bname.clone()))
            }
            ExprKind::Call { name, args } if name == "len" && args.len() == 1 => {
                let ExprKind::Var(aname) = &args[0].kind else {
                    return None;
                };
                let a_entry = self.lookup_var(aname)?;
                if !a_entry.ty.is_array() || stmts_mutate_array_len(body, aname) {
                    return None;
                }
                (
                    WhileBoundKind::LenOf(aname.clone()),
                    UpperBound::LenOf(aname.clone()),
                )
            }
            _ => return None,
        };

        let mut stride: Option<StrideVal> = None;
        if !check_only_monotone_step(body, idx_name, body, &mut stride, self) {
            return None;
        }
        let stride = stride?;

        Some(StridedWhilePlan {
            idx_slot: idx_slot.clone(),
            bound: bound_kind,
            stride,
            proven_bound: InductionBound {
                var: idx_name.clone(),
                upper: proven_upper,
            },
        })
    }

}
