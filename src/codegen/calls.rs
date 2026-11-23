//! User function calls, positional struct constructors, and builtin intrinsics (`print`, `len`, `push`, `pop`).

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

impl Codegen {
    // ---------------- Calls & struct constructors ----------------------------

    pub(super) fn gen_call(
        &mut self,
        name: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if name == "print" {
            return self.gen_builtin_print(args, span, out);
        }
        if name == "len" {
            return self.gen_builtin_len(args, span, out);
        }
        if name == "push" {
            return self.gen_builtin_push(args, span, out);
        }
        if name == "pop" {
            return self.gen_builtin_pop(args, span, out);
        }

        if let Some(fields) = self.structs.get(name).cloned() {
            if args.len() != fields.len() {
                return Err(Diagnostic::new(
                    format!(
                        "struct `{name}` expects {} field{}, but {} {} supplied",
                        fields.len(),
                        if fields.len() == 1 { "" } else { "s" },
                        args.len(),
                        if args.len() == 1 { "was" } else { "were" }
                    ),
                    span,
                ));
            }
            let mut agg = "poison".to_string();
            for (i, arg) in args.iter().enumerate() {
                let fty = &fields[i].ty;
                let (aty, raw_val) = self.eval_expr_typed(arg, Some(fty), out)?;
                if aty != *fty {
                    return Err(Diagnostic::new(
                        format!(
                            "field `{}` of `{name}` expects `{}`, found `{}`",
                            fields[i].name,
                            fty.name(),
                            aty.name()
                        ),
                        arg.span,
                    ));
                }
                let fval = if self.type_needs_drop(fty) {
                    if self.claim_stmt_temp(&raw_val) {
                        raw_val
                    } else {
                        self.emit_clone_value(fty, &raw_val, out)
                    }
                } else {
                    raw_val
                };
                let next_agg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {next_agg} = insertvalue %ArchxStruct_{name} {agg}, {} {fval}, {i}",
                    ir_type(fty)
                );
                agg = next_agg;
            }
            let sty = Type::Struct(name.to_string());
            if self.type_needs_drop(&sty) {
                self.stmt_temps.push(TempDrop {
                    val: agg.clone(),
                    ty: sty.clone(),
                });
            }
            return Ok((sty, agg));
        }

        if name == "main" {
            return Err(Diagnostic::new("`main` cannot be called directly", span));
        }

        let sig = self
            .sigs
            .get(name)
            .cloned()
            .ok_or_else(|| Diagnostic::new(format!("undefined function `{name}`"), span))?;

        if args.len() != sig.params.len() {
            return Err(Diagnostic::new(
                format!(
                    "function `{name}` expects {} argument{}, but {} {} supplied",
                    sig.params.len(),
                    if sig.params.len() == 1 { "" } else { "s" },
                    args.len(),
                    if args.len() == 1 { "was" } else { "were" }
                ),
                span,
            ));
        }

        let mut arg_vals = Vec::new();
        for (i, arg) in args.iter().enumerate() {
            let (ty, val) = self.eval_expr_typed(arg, Some(&sig.params[i]), out)?;
            if ty != sig.params[i] {
                return Err(Diagnostic::new(
                    format!(
                        "argument {} of `{name}` expects `{}`, found `{}`",
                        i + 1,
                        sig.params[i].name(),
                        ty.name()
                    ),
                    arg.span,
                ));
            }
            arg_vals.push((ty, val));
        }

        if sig.ret.is_none() {
            let mut call = format!("  call fastcc void {}(", mangle(name));
            for (i, (ty, val)) in arg_vals.iter().enumerate() {
                if i > 0 {
                    call.push_str(", ");
                }
                let _ = write!(call, "{} {}", ir_type(ty), val);
            }
            call.push_str(")\n");
            out.push_str(&call);
            return Ok((Type::Void, String::new()));
        }

        let reg = self.next_tmp();
        let ret_ir = ir_ret_type(sig.ret.as_ref());
        let mut call = format!("  {reg} = call fastcc {ret_ir} {}(", mangle(name));
        for (i, (ty, val)) in arg_vals.iter().enumerate() {
            if i > 0 {
                call.push_str(", ");
            }
            let _ = write!(call, "{} {}", ir_type(ty), val);
        }
        call.push_str(")\n");
        out.push_str(&call);

        match sig.ret {
            Some(ty) => {
                if self.type_needs_drop(&ty) {
                    self.stmt_temps.push(TempDrop {
                        val: reg.clone(),
                        ty: ty.clone(),
                    });
                }
                Ok((ty, reg))
            }
            None => Ok((Type::Void, String::new())),
        }
    }

    pub(super) fn gen_builtin_print(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new("`print` takes exactly one argument", span));
        }

        if let ExprKind::Str(lit) = &args[0].kind {
            if !lit.as_bytes().contains(&0) {
                let sym = self.strings.intern(lit);
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr {sym})"
                );
                return Ok((Type::Void, reg));
            }
        }

        let (ty, val) = self.eval_expr(&args[0], out)?;
        match ty {
            Type::Str => {
                self.used_str_print = true;
                let _ = writeln!(
                    out,
                    "  call fastcc void @archx_str_print(%ArchxStr {val}, i1 true)"
                );
                Ok((Type::Void, String::new()))
            }
            Type::Int => {
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 {val})"
                );
                Ok((Type::Void, reg))
            }
            Type::Bool => {
                let selected = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {selected} = select i1 {val}, ptr @.str.true, ptr @.str.false"
                );
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr {selected})"
                );
                Ok((Type::Void, reg))
            }
            Type::Array(elem_ty) => {
                if !matches!(*elem_ty, Type::Int | Type::Bool | Type::Str) {
                    return Err(Diagnostic::new(
                        "`print` supports 1D arrays (`[int]`, `[bool]`, `[string]`); print elements in a loop for structs or nested arrays",
                        span,
                    ));
                }
                self.used_array_print = true;
                let open = self.next_tmp();
                let _ = writeln!(out, "  {open} = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)");

                let len = self.next_tmp();
                let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {val}, 0");
                let data = self.next_tmp();
                let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {val}, 2");

                let idx_slot = self.next_slot("print.idx");
                let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
                let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

                let cond_lbl = self.fresh_label("print.cond");
                let body_lbl = self.fresh_label("print.body");
                let sep_lbl = self.fresh_label("print.sep");
                let elem_lbl = self.fresh_label("print.elem");
                let end_lbl = self.fresh_label("print.end");

                self.emit_br(&cond_lbl, out);
                self.start_block(&cond_lbl, out);
                let pi = self.next_tmp();
                let _ = writeln!(out, "  {pi} = load i64, ptr {idx_slot}, align 8");
                let pcmp = self.next_tmp();
                let _ = writeln!(out, "  {pcmp} = icmp slt i64 {pi}, {len}");
                self.emit_cond_br(&pcmp, &body_lbl, &end_lbl, out);

                self.start_block(&body_lbl, out);
                let gt0 = self.next_tmp();
                let _ = writeln!(out, "  {gt0} = icmp sgt i64 {pi}, 0");
                self.emit_cond_br(&gt0, &sep_lbl, &elem_lbl, out);

                self.start_block(&sep_lbl, out);
                let sc = self.next_tmp();
                let _ = writeln!(out, "  {sc} = call i32 (ptr, ...) @printf(ptr @.fmt.sep)");
                self.emit_br(&elem_lbl, out);

                self.start_block(&elem_lbl, out);
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let ep = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {ep} = getelementptr inbounds {mem_ty}, ptr {data}, i64 {pi}"
                );
                let elem_val = self.emit_elem_load(&elem_ty, &ep, out);
                match *elem_ty {
                    Type::Int => {
                        let pc = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {pc} = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 {elem_val})"
                        );
                    }
                    Type::Str => {
                        self.used_str_print = true;
                        let _ = writeln!(
                            out,
                            "  call fastcc void @archx_str_print(%ArchxStr {elem_val}, i1 false)"
                        );
                    }
                    Type::Bool => {
                        let sel = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {sel} = select i1 {elem_val}, ptr @.str.true, ptr @.str.false"
                        );
                        let pc = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {pc} = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr {sel})"
                        );
                    }
                    _ => unreachable!(),
                }
                let pnext = self.next_tmp();
                let _ = writeln!(out, "  {pnext} = add nsw i64 {pi}, 1");
                let _ = writeln!(out, "  store i64 {pnext}, ptr {idx_slot}, align 8");
                self.emit_br(&cond_lbl, out);

                self.start_block(&end_lbl, out);
                let close = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {close} = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack)"
                );
                Ok((Type::Void, close))
            }
            Type::Struct(sname) => Err(Diagnostic::new(
                format!(
                    "`print` does not format struct `{sname}` automatically; print its fields (e.g. `p.x`)"
                ),
                span,
            )),
            Type::Void => Err(Diagnostic::new("`print` cannot print `void`", span)),
        }
    }

    pub(super) fn gen_builtin_len(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new("`len` takes exactly one argument", span));
        }

        if let ExprKind::Str(lit) = &args[0].kind {
            return Ok((Type::Int, (lit.len() as i64).to_string()));
        }

        if let ExprKind::Var(name) = &args[0].kind {
            if let Some(&KnownLen::Const(c)) = self.lookup_known_len(name) {
                if let Some(entry) = self.lookup_var(name) {
                    if entry.ty.is_array() {
                        return Ok((Type::Int, c.to_string()));
                    }
                }
            }
            if let Some(entry) = self.lookup_var(name).cloned() {
                if let VarStorage::Soa { len_val, .. } = entry.storage {
                    return Ok((Type::Int, len_val));
                }
            }
        }

        let (ty, val) = self.eval_expr(&args[0], out)?;
        match ty {
            Type::Array(_) => {
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = extractvalue %ArchxVec {val}, 0");
                Ok((Type::Int, reg))
            }
            Type::Str => {
                let w0 = self.next_tmp();
                let _ = writeln!(out, "  {w0} = extractvalue %ArchxStr {val}, 0");
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = and i64 {w0}, 4294967295");
                Ok((Type::Int, reg))
            }
            other => Err(Diagnostic::new(
                format!(
                    "`len` expects an array or `string`, found `{}`",
                    other.name()
                ),
                args[0].span,
            )),
        }
    }

    pub(super) fn gen_builtin_push(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 2 {
            return Err(Diagnostic::new(
                "`push` takes exactly 2 arguments: `push(array, value)`",
                span,
            ));
        }

        let ExprKind::Var(arr_name) = &args[0].kind else {
            return Err(Diagnostic::new(
                "first argument to `push` must be an array variable",
                args[0].span,
            ));
        };

        let entry = self.lookup_var(arr_name).cloned().ok_or_else(|| {
            Diagnostic::new(format!("undefined variable `{arr_name}`"), args[0].span)
        })?;
        if entry.is_param {
            return Err(Diagnostic::new(
                format!(
                    "cannot `push` onto borrowed parameter `{arr_name}`; assign to a local array first"
                ),
                args[0].span,
            ));
        }
        let Type::Array(elem_ty) = entry.ty.clone() else {
            return Err(Diagnostic::new(
                format!("`push` expects an array, found `{}`", entry.ty.name()),
                args[0].span,
            ));
        };
        self.check_region_escape_target(arr_name, &elem_ty, span)?;

        let VarStorage::Slot(slot_ptr) = entry.storage else {
            return Err(Diagnostic::new(
                format!("internal error: pushed array `{arr_name}` lacked a slot"),
                span,
            ));
        };

        let (val_ty, raw_val) = self.eval_expr_typed(&args[1], Some(&elem_ty), out)?;
        if val_ty != *elem_ty {
            return Err(Diagnostic::new(
                format!(
                    "`push` onto `[{}]` expects `{}`, found `{}`",
                    elem_ty.name(),
                    elem_ty.name(),
                    val_ty.name()
                ),
                args[1].span,
            ));
        }
        let val = if self.type_needs_drop(&elem_ty) {
            if self.claim_stmt_temp(&raw_val) {
                raw_val
            } else {
                self.emit_clone_value(&elem_ty, &raw_val, out)
            }
        } else {
            raw_val
        };

        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
        let cap = self.next_tmp();
        let _ = writeln!(out, "  {cap} = extractvalue %ArchxVec {vec}, 1");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");

        let is_reg = self.next_tmp();
        let _ = writeln!(out, "  {is_reg} = icmp slt i64 {cap}, 0");
        let neg_cap = self.next_tmp();
        let _ = writeln!(out, "  {neg_cap} = sub nsw i64 0, {cap}");
        let eff_cap = self.next_tmp();
        let _ = writeln!(
            out,
            "  {eff_cap} = select i1 {is_reg}, i64 {neg_cap}, i64 {cap}"
        );

        let full = self.next_tmp();
        let _ = writeln!(out, "  {full} = icmp sge i64 {len}, {eff_cap}");
        let grow_lbl = self.fresh_label("push.grow");
        let store_lbl = self.fresh_label("push.store");
        self.emit_cond_br(&full, &grow_lbl, &store_lbl, out);

        self.start_block(&grow_lbl, out);
        let lim = self.next_tmp();
        let _ = writeln!(out, "  {lim} = icmp sge i64 {len}, {MAX_ARRAY_LEN}");
        self.used_oom_fail = true;
        let oom_lbl = self.fresh_label("push.oom");
        let calc_lbl = self.fresh_label("push.calc");
        self.emit_cond_br(&lim, &oom_lbl, &calc_lbl, out);

        self.start_block(&oom_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&calc_lbl, out);
        let zero_cap = self.next_tmp();
        let _ = writeln!(out, "  {zero_cap} = icmp eq i64 {eff_cap}, 0");
        let doubled = self.next_tmp();
        let _ = writeln!(out, "  {doubled} = shl i64 {eff_cap}, 1");
        let cand_cap = self.next_tmp();
        let _ = writeln!(
            out,
            "  {cand_cap} = select i1 {zero_cap}, i64 4, i64 {doubled}"
        );
        let over_max = self.next_tmp();
        let _ = writeln!(out, "  {over_max} = icmp sgt i64 {cand_cap}, {MAX_ARRAY_LEN}");
        let new_cap = self.next_tmp();
        let _ = writeln!(
            out,
            "  {new_cap} = select i1 {over_max}, i64 {MAX_ARRAY_LEN}, i64 {cand_cap}"
        );
        let elem_sz_val = self.emit_elem_sizeof(&elem_ty, out);
        let bytes = self.emit_elem_bytes_val_mul(&new_cap, &elem_sz_val, out);

        let was_reg_lbl = self.fresh_label("push.grow.from_reg");
        let was_heap_lbl = self.fresh_label("push.grow.from_heap");
        self.emit_cond_br(&is_reg, &was_reg_lbl, &was_heap_lbl, out);

        self.start_block(&was_reg_lbl, out);
        let old_bytes = self.emit_elem_bytes_val_mul(&len, &elem_sz_val, out);
        let (reg_new_ptr, reg_new_cap) = if !self.region_stack.is_empty()
            && !self.type_needs_drop(&elem_ty)
        {
            let rslot = self.func_region_slot.clone().unwrap();
            let rp = self.next_tmp();
            let _ = writeln!(
                out,
                "  {rp} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
            );
            let nc = self.next_tmp();
            let _ = writeln!(out, "  {nc} = sub nsw i64 0, {new_cap}");
            (rp, nc)
        } else {
            let hp = self.emit_checked_malloc(&bytes, out);
            (hp, new_cap.clone())
        };
        self.used_memcpy = true;
        let has_old = self.next_tmp();
        let _ = writeln!(out, "  {has_old} = icmp sgt i64 {old_bytes}, 0");
        let cp_lbl = self.fresh_label("push.reg.copy");
        let cp_done_lbl = self.fresh_label("push.reg.copied");
        self.emit_cond_br(&has_old, &cp_lbl, &cp_done_lbl, out);
        self.start_block(&cp_lbl, out);
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {reg_new_ptr}, ptr align 8 {data}, i64 {old_bytes}, i1 false)"
        );
        self.emit_br(&cp_done_lbl, out);
        self.start_block(&cp_done_lbl, out);
        let gvec_reg = self.build_vec_val(&len, &reg_new_cap, &reg_new_ptr, out);
        let _ = writeln!(out, "  store %ArchxVec {gvec_reg}, ptr {slot_ptr}, align 8");
        self.emit_br(&store_lbl, out);

        self.start_block(&was_heap_lbl, out);
        let grown_ptr = self.emit_checked_realloc(&data, &bytes, out);
        let gvec_heap = self.build_vec_val(&len, &new_cap, &grown_ptr, out);
        let _ = writeln!(out, "  store %ArchxVec {gvec_heap}, ptr {slot_ptr}, align 8");
        self.emit_br(&store_lbl, out);

        self.start_block(&store_lbl, out);
        let vec2 = self.next_tmp();
        let _ = writeln!(out, "  {vec2} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let data2 = self.next_tmp();
        let _ = writeln!(out, "  {data2} = extractvalue %ArchxVec {vec2}, 2");
        let mem_ty = elem_mem_ir_type(&elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data2}, i64 {len}"
        );
        self.emit_elem_store(&elem_ty, &val, &ep, out);
        let next_len = self.next_tmp();
        let _ = writeln!(out, "  {next_len} = add nsw i64 {len}, 1");
        let vec3 = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vec3} = insertvalue %ArchxVec {vec2}, i64 {next_len}, 0"
        );
        let _ = writeln!(out, "  store %ArchxVec {vec3}, ptr {slot_ptr}, align 8");

        Ok((Type::Void, String::new()))
    }

    pub(super) fn gen_builtin_pop(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new(
                "`pop` takes exactly 1 argument: `pop(array)`",
                span,
            ));
        }

        let ExprKind::Var(arr_name) = &args[0].kind else {
            return Err(Diagnostic::new(
                "argument to `pop` must be an array variable",
                args[0].span,
            ));
        };

        let entry = self.lookup_var(arr_name).cloned().ok_or_else(|| {
            Diagnostic::new(format!("undefined variable `{arr_name}`"), args[0].span)
        })?;
        if entry.is_param {
            return Err(Diagnostic::new(
                format!(
                    "cannot `pop` from borrowed parameter `{arr_name}`; assign to a local array first"
                ),
                args[0].span,
            ));
        }
        let Type::Array(elem_ty) = entry.ty else {
            return Err(Diagnostic::new(
                format!("`pop` expects an array, found `{}`", entry.ty.name()),
                args[0].span,
            ));
        };
        let VarStorage::Slot(slot_ptr) = entry.storage else {
            return Err(Diagnostic::new(
                format!("internal error: popped array `{arr_name}` lacked a slot"),
                span,
            ));
        };

        self.used_pop_empty_fail = true;
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
        let empty = self.next_tmp();
        let _ = writeln!(out, "  {empty} = icmp sle i64 {len}, 0");
        let ok_lbl = self.fresh_label("pop.ok");
        let fail_lbl = self.fresh_label("pop.empty");
        self.emit_cond_br(&empty, &fail_lbl, &ok_lbl, out);

        self.start_block(&fail_lbl, out);
        let _ = writeln!(out, "  call void @archx_pop_empty_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        let next_len = self.next_tmp();
        let _ = writeln!(out, "  {next_len} = sub nsw i64 {len}, 1");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");
        let mem_ty = elem_mem_ir_type(&elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data}, i64 {next_len}"
        );
        let elem = self.emit_elem_load(&elem_ty, &ep, out);
        let vec2 = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vec2} = insertvalue %ArchxVec {vec}, i64 {next_len}, 0"
        );
        let _ = writeln!(out, "  store %ArchxVec {vec2}, ptr {slot_ptr}, align 8");

        if self.type_needs_drop(&elem_ty) {
            self.stmt_temps.push(TempDrop {
                val: elem.clone(),
                ty: (*elem_ty).clone(),
            });
        }
        Ok((*elem_ty, elem))
    }

}
