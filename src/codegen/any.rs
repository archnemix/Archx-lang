//! Adaptive Tier-2 `%ArchxAny` value boxing, runtime-checked unboxing, mixed-type binary/unary
//! operations, and compile-time/runtime `type(x)` & `isinstance(x, T)` introspection.

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

impl Codegen {
    pub(super) fn eval_expr_as_any(&mut self, expr: &Expr, out: &mut String) -> Result<String> {
        if matches!(&expr.kind, ExprKind::NoneLit) {
            self.mark_runtime_type(&Type::Any);
            self.used_any_rt = true;
            return Ok("zeroinitializer".to_string());
        }
        let (ty, val) = self.eval_expr_typed(expr, Some(&Type::Any), out)?;
        if ty == Type::Any {
            return Ok(val);
        }
        let owned = self.emit_box_any_owned(&ty, &val, expr.span, out)?;
        self.stmt_temps.push(TempDrop {
            val: owned.clone(),
            ty: Type::Any,
        });
        Ok(owned)
    }

    pub(super) fn emit_box_any_owned(
        &mut self,
        ty: &Type,
        val: &str,
        span: Span,
        out: &mut String,
    ) -> Result<String> {
        self.mark_runtime_type(&Type::Any);
        self.used_any_rt = true;

        if *ty == Type::Any {
            if self.claim_stmt_temp(val) {
                return Ok(val.to_string());
            }
            return Ok(self.emit_clone_value(&Type::Any, val, out));
        }

        let owned_val = if self.type_needs_drop(ty) {
            if self.claim_stmt_temp(val) {
                val.to_string()
            } else {
                self.emit_clone_value(ty, val, out)
            }
        } else {
            val.to_string()
        };

        match ty {
            Type::Void => Ok("zeroinitializer".to_string()),
            Type::Bool => {
                let z = self.next_tmp();
                let _ = writeln!(out, "  {z} = zext i1 {owned_val} to i64");
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = insertvalue %ArchxAny {{ i64 1, i64 0, i64 0 }}, i64 {z}, 1"
                );
                Ok(r)
            }
            Type::Int => {
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = insertvalue %ArchxAny {{ i64 2, i64 0, i64 0 }}, i64 {owned_val}, 1"
                );
                Ok(r)
            }
            Type::Float => {
                let bits = self.next_tmp();
                let _ = writeln!(out, "  {bits} = bitcast double {owned_val} to i64");
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = insertvalue %ArchxAny {{ i64 3, i64 0, i64 0 }}, i64 {bits}, 1"
                );
                Ok(r)
            }
            Type::Str => {
                let w0 = self.next_tmp();
                let _ = writeln!(out, "  {w0} = extractvalue %ArchxStr {owned_val}, 0");
                let w1 = self.next_tmp();
                let _ = writeln!(out, "  {w1} = extractvalue %ArchxStr {owned_val}, 1");
                let r0 = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r0} = insertvalue %ArchxAny {{ i64 4, i64 0, i64 0 }}, i64 {w0}, 1"
                );
                let r1 = self.next_tmp();
                let _ = writeln!(out, "  {r1} = insertvalue %ArchxAny {r0}, i64 {w1}, 2");
                Ok(r1)
            }
            Type::Array(elem_ty) => {
                let any_vec = if **elem_ty == Type::Any {
                    owned_val
                } else {
                    self.emit_convert_typed_vec_to_any_vec(elem_ty, &owned_val, span, out)?
                };
                Ok(self.emit_wrap_any_vec_cell(&any_vec, out))
            }
            Type::Dict(k_ty, v_ty) => {
                let any_d = if **k_ty == Type::Any && **v_ty == Type::Any {
                    owned_val
                } else {
                    self.emit_convert_typed_dict_to_any(k_ty, Some(v_ty), &owned_val, span, out)?
                };
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = insertvalue %ArchxAny {{ i64 6, i64 0, i64 0 }}, i64 {any_d}, 1"
                );
                Ok(r)
            }
            Type::Set(elem_ty) => {
                let any_s = if **elem_ty == Type::Any {
                    owned_val
                } else {
                    self.emit_convert_typed_dict_to_any(elem_ty, None, &owned_val, span, out)?
                };
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = insertvalue %ArchxAny {{ i64 7, i64 0, i64 0 }}, i64 {any_s}, 1"
                );
                Ok(r)
            }
            Type::Struct(sname) => Err(Diagnostic::new(
                format!(
                    "cannot box class/struct `{sname}` into dynamic `any`; keep `{sname}` statically typed"
                ),
                span,
            )),
            Type::Any => unreachable!(),
        }
    }

    pub(super) fn emit_wrap_any_vec_cell(&mut self, any_vec: &str, out: &mut String) -> String {
        let (cell_ptr, alloc_tag) = if !self.region_stack.is_empty() {
            let rslot = self.func_region_slot.clone().unwrap();
            let p = self.next_tmp();
            let _ = writeln!(
                out,
                "  {p} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 24)"
            );
            (p, 2_i64)
        } else {
            let p = self.emit_checked_malloc("24", out);
            (p, 1_i64)
        };
        let _ = writeln!(out, "  store %ArchxVec {any_vec}, ptr {cell_ptr}, align 8");
        let pi = self.next_tmp();
        let _ = writeln!(out, "  {pi} = ptrtoint ptr {cell_ptr} to i64");
        let tagged = self.next_tmp();
        let _ = writeln!(out, "  {tagged} = or i64 {pi}, {alloc_tag}");
        let r = self.next_tmp();
        let _ = writeln!(
            out,
            "  {r} = insertvalue %ArchxAny {{ i64 5, i64 0, i64 0 }}, i64 {tagged}, 1"
        );
        r
    }

    fn emit_convert_typed_vec_to_any_vec(
        &mut self,
        elem_ty: &Type,
        vec_val: &str,
        span: Span,
        out: &mut String,
    ) -> Result<String> {
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec_val}, 0");
        let src_data = self.next_tmp();
        let _ = writeln!(out, "  {src_data} = extractvalue %ArchxVec {vec_val}, 2");

        let bytes = self.emit_elem_bytes_mul(&len, 24, out);
        let (dst_data, cap_val) = if !self.region_stack.is_empty() {
            let rslot = self.func_region_slot.clone().unwrap();
            let p = self.next_tmp();
            let _ = writeln!(
                out,
                "  {p} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
            );
            (p, "-1".to_string())
        } else {
            let p = self.emit_checked_malloc(&bytes, out);
            let z = self.next_tmp();
            let _ = writeln!(out, "  {z} = icmp eq i64 {len}, 0");
            let c = self.next_tmp();
            let _ = writeln!(out, "  {c} = select i1 {z}, i64 1, i64 {len}");
            (p, c)
        };

        let i_slot = self.next_slot("boxvec.i");
        let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
        let cond_lbl = self.fresh_label("boxvec.cond");
        let body_lbl = self.fresh_label("boxvec.body");
        let done_lbl = self.fresh_label("boxvec.done");
        self.emit_br(&cond_lbl, out);

        self.start_block(&cond_lbl, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len}");
        self.emit_cond_br(&more, &body_lbl, &done_lbl, out);

        self.start_block(&body_lbl, out);
        let mem_ty = elem_mem_ir_type(elem_ty);
        let sp = self.next_tmp();
        let _ = writeln!(
            out,
            "  {sp} = getelementptr inbounds {mem_ty}, ptr {src_data}, i64 {i}"
        );
        let ev = self.emit_elem_load(elem_ty, &sp, out);
        let boxed = self.emit_box_any_owned(elem_ty, &ev, span, out)?;
        let dp = self.next_tmp();
        let _ = writeln!(
            out,
            "  {dp} = getelementptr inbounds %ArchxAny, ptr {dst_data}, i64 {i}"
        );
        let _ = writeln!(out, "  store %ArchxAny {boxed}, ptr {dp}, align 8");
        let inext = self.next_tmp();
        let _ = writeln!(out, "  {inext} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {inext}, ptr {i_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&done_lbl, out);
        self.emit_drop_value(&Type::Array(Box::new(elem_ty.clone())), vec_val, out);
        Ok(self.build_vec_val(&len, &cap_val, &dst_data, out))
    }

    fn emit_convert_typed_dict_to_any(
        &mut self,
        k_ty: &Type,
        v_ty: Option<&Type>,
        d_val: &str,
        span: Span,
        out: &mut String,
    ) -> Result<String> {
        let meta = Self::dict_meta_word(&Type::Any, v_ty.map(|_| &Type::Any));
        let rarg = self.active_region_arg();
        let dst = self.next_tmp();
        let _ = writeln!(
            out,
            "  {dst} = call fastcc i64 @archx_dict_new(i64 {meta}, ptr {rarg})"
        );

        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
        let non_z = self.next_tmp();
        let _ = writeln!(out, "  {non_z} = icmp ne i64 {raw}, 0");
        let init_lbl = self.fresh_label("boxd.init");
        let cond_lbl = self.fresh_label("boxd.cond");
        let body_lbl = self.fresh_label("boxd.body");
        let done_lbl = self.fresh_label("boxd.done");
        self.emit_cond_br(&non_z, &init_lbl, &done_lbl, out);

        let i_slot = self.next_slot("boxd.i");
        let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
        let len_slot = self.next_slot("boxd.len");
        let _ = writeln!(self.allocas, "  {len_slot} = alloca i64, align 8");
        let kp_slot = self.next_slot("boxd.kp");
        let _ = writeln!(self.allocas, "  {kp_slot} = alloca ptr, align 8");
        let vp_slot = self.next_slot("boxd.vp");
        let _ = writeln!(self.allocas, "  {vp_slot} = alloca ptr, align 8");

        self.start_block(&init_lbl, out);
        let hdr = self.next_tmp();
        let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = load i64, ptr {hdr}, align 8");
        let kgep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {kgep} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 5"
        );
        let kptr = self.next_tmp();
        let _ = writeln!(out, "  {kptr} = load ptr, ptr {kgep}, align 8");
        let vgep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vgep} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 6"
        );
        let vptr = self.next_tmp();
        let _ = writeln!(out, "  {vptr} = load ptr, ptr {vgep}, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
        let _ = writeln!(out, "  store i64 {len}, ptr {len_slot}, align 8");
        let _ = writeln!(out, "  store ptr {kptr}, ptr {kp_slot}, align 8");
        let _ = writeln!(out, "  store ptr {vptr}, ptr {vp_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&cond_lbl, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
        let lcur = self.next_tmp();
        let _ = writeln!(out, "  {lcur} = load i64, ptr {len_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {lcur}");
        self.emit_cond_br(&more, &body_lbl, &done_lbl, out);

        self.start_block(&body_lbl, out);
        let kp_cur = self.next_tmp();
        let _ = writeln!(out, "  {kp_cur} = load ptr, ptr {kp_slot}, align 8");
        let key_store_ty = Self::dict_key_storage_ir(k_ty);
        let kep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {kep} = getelementptr inbounds {key_store_ty}, ptr {kp_cur}, i64 {i}"
        );
        let kval = self.emit_load_dict_key(k_ty, &kep, out);
        let k_any = self.emit_box_any_owned(k_ty, &kval, span, out)?;
        let up = self.next_tmp();
        let _ = writeln!(
            out,
            "  {up} = call fastcc {{ i64, i1 }} @archx_dict_upsert_any(i64 {dst}, %ArchxAny {k_any})"
        );
        let _ = writeln!(out, "  call fastcc void @archx_any_drop(%ArchxAny {k_any})");
        if let Some(vt) = v_ty {
            let didx = self.next_tmp();
            let _ = writeln!(out, "  {didx} = extractvalue {{ i64, i1 }} {up}, 0");
            let vp_cur = self.next_tmp();
            let _ = writeln!(out, "  {vp_cur} = load ptr, ptr {vp_slot}, align 8");
            let vmem = elem_mem_ir_type(vt);
            let vep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {vep} = getelementptr inbounds {vmem}, ptr {vp_cur}, i64 {i}"
            );
            let vval = self.emit_elem_load(vt, &vep, out);
            let v_any = self.emit_box_any_owned(vt, &vval, span, out)?;
            let draw = self.next_tmp();
            let _ = writeln!(out, "  {draw} = and i64 {dst}, -4");
            let dhdr = self.next_tmp();
            let _ = writeln!(out, "  {dhdr} = inttoptr i64 {draw} to ptr");
            let dvg = self.next_tmp();
            let _ = writeln!(
                out,
                "  {dvg} = getelementptr inbounds %ArchxDictHdr, ptr {dhdr}, i32 0, i32 6"
            );
            let dvp = self.next_tmp();
            let _ = writeln!(out, "  {dvp} = load ptr, ptr {dvg}, align 8");
            let dep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {dep} = getelementptr inbounds %ArchxAny, ptr {dvp}, i64 {didx}"
            );
            let _ = writeln!(out, "  store %ArchxAny {v_any}, ptr {dep}, align 8");
        }
        let inext = self.next_tmp();
        let _ = writeln!(out, "  {inext} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {inext}, ptr {i_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&done_lbl, out);
        let src_ty = match v_ty {
            Some(vt) => Type::Dict(Box::new(k_ty.clone()), Box::new(vt.clone())),
            None => Type::Set(Box::new(k_ty.clone())),
        };
        self.emit_drop_value(&src_ty, d_val, out);
        Ok(dst)
    }

    /// Runtime-checked unboxing from `%ArchxAny` into a statically typed value (`expected`).
    pub(super) fn emit_unbox_any(
        &mut self,
        expected: &Type,
        any_val: &str,
        span: Span,
        out: &mut String,
    ) -> Result<String> {
        self.mark_runtime_type(&Type::Any);
        self.used_any_rt = true;
        self.used_type_fail = true;

        let tag = self.next_tmp();
        let _ = writeln!(out, "  {tag} = extractvalue %ArchxAny {any_val}, 0");
        let w1 = self.next_tmp();
        let _ = writeln!(out, "  {w1} = extractvalue %ArchxAny {any_val}, 1");

        match expected {
            Type::Int => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 2");
                self.emit_type_guard(&ok, "expected `int` from dynamic `any` value", out);
                Ok(w1)
            }
            Type::Bool => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 1");
                self.emit_type_guard(&ok, "expected `bool` from dynamic `any` value", out);
                let b = self.next_tmp();
                let _ = writeln!(out, "  {b} = icmp ne i64 {w1}, 0");
                Ok(b)
            }
            Type::Float => {
                let is_f = self.next_tmp();
                let _ = writeln!(out, "  {is_f} = icmp eq i64 {tag}, 3");
                let is_i = self.next_tmp();
                let _ = writeln!(out, "  {is_i} = icmp eq i64 {tag}, 2");
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = or i1 {is_f}, {is_i}");
                self.emit_type_guard(&ok, "expected `float` from dynamic `any` value", out);
                let df = self.next_tmp();
                let _ = writeln!(out, "  {df} = bitcast i64 {w1} to double");
                let di = self.next_tmp();
                let _ = writeln!(out, "  {di} = sitofp i64 {w1} to double");
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = select i1 {is_f}, double {df}, double {di}");
                Ok(r)
            }
            Type::Str => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 4");
                self.emit_type_guard(&ok, "expected `str` from dynamic `any` value", out);
                let w2 = self.next_tmp();
                let _ = writeln!(out, "  {w2} = extractvalue %ArchxAny {any_val}, 2");
                let s0 = self.next_tmp();
                let _ = writeln!(out, "  {s0} = insertvalue %ArchxStr poison, i64 {w1}, 0");
                let s1 = self.next_tmp();
                let _ = writeln!(out, "  {s1} = insertvalue %ArchxStr {s0}, i64 {w2}, 1");
                let cloned = self.emit_clone_value(&Type::Str, &s1, out);
                self.stmt_temps.push(TempDrop {
                    val: cloned.clone(),
                    ty: Type::Str,
                });
                Ok(cloned)
            }
            Type::Array(elem_ty) if **elem_ty == Type::Any => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 5");
                self.emit_type_guard(&ok, "expected `list` from dynamic `any` value", out);
                let raw = self.next_tmp();
                let _ = writeln!(out, "  {raw} = and i64 {w1}, -4");
                let lp = self.next_tmp();
                let _ = writeln!(out, "  {lp} = inttoptr i64 {raw} to ptr");
                let vec = self.next_tmp();
                let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {lp}, align 8");
                let cloned = self.emit_clone_value(expected, &vec, out);
                self.stmt_temps.push(TempDrop {
                    val: cloned.clone(),
                    ty: expected.clone(),
                });
                Ok(cloned)
            }
            Type::Dict(k, v) if **k == Type::Any && **v == Type::Any => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 6");
                self.emit_type_guard(&ok, "expected `dict` from dynamic `any` value", out);
                let cloned = self.emit_clone_value(expected, &w1, out);
                self.stmt_temps.push(TempDrop {
                    val: cloned.clone(),
                    ty: expected.clone(),
                });
                Ok(cloned)
            }
            Type::Set(e) if **e == Type::Any => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 7");
                self.emit_type_guard(&ok, "expected `set` from dynamic `any` value", out);
                let cloned = self.emit_clone_value(expected, &w1, out);
                self.stmt_temps.push(TempDrop {
                    val: cloned.clone(),
                    ty: expected.clone(),
                });
                Ok(cloned)
            }
            _ => Err(Diagnostic::new(
                format!(
                    "cannot implicitly unbox dynamic `any` into static `{}`",
                    expected.name()
                ),
                span,
            )),
        }
    }

    pub(super) fn emit_type_guard(&mut self, cond: &str, msg: &str, out: &mut String) {
        self.used_type_fail = true;
        let sym = self.strings.intern(msg);
        let ok_lbl = self.fresh_label("any.guard.ok");
        let fail_lbl = self.fresh_label("any.guard.fail");
        self.emit_cond_br(cond, &ok_lbl, &fail_lbl, out);
        self.start_block(&fail_lbl, out);
        let _ = writeln!(out, "  call void @archx_type_fail(ptr {sym})");
        let _ = writeln!(out, "  unreachable");
        self.start_block(&ok_lbl, out);
    }

    /// Evaluates `cond` as an `i1` boolean: requires `bool` for static Tier-1 values,
    /// and uses Python truthiness (`@archx_any_truthy`) for Tier-2 `%ArchxAny` values.
    pub(super) fn eval_cond_bool(
        &mut self,
        cond: &Expr,
        ctx_name: &str,
        out: &mut String,
    ) -> Result<String> {
        let (cty, cval) = self.eval_expr(cond, out)?;
        match cty {
            Type::Bool => Ok(cval),
            Type::Any => {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let b = self.next_tmp();
                let _ = writeln!(out, "  {b} = call fastcc i1 @archx_any_truthy(%ArchxAny {cval})");
                Ok(b)
            }
            _ => Err(Diagnostic::new(
                format!("`{ctx_name}` condition must be `bool`, found `{}`", cty.name()),
                cond.span,
            )),
        }
    }

    pub(super) fn eval_any_binary(
        &mut self,
        op: BinOp,
        lhs: &Expr,
        rhs: &Expr,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.mark_runtime_type(&Type::Any);
        self.used_any_rt = true;

        match op {
            BinOp::And | BinOp::Or => {
                let lv = self.eval_cond_bool(lhs, op.symbol(), out)?;
                let rhs_lbl = self.fresh_label("any.logic.rhs");
                let short_lbl = self.fresh_label("any.logic.short");
                let merge_lbl = self.fresh_label("any.logic.merge");
                if op == BinOp::And {
                    self.emit_cond_br(&lv, &rhs_lbl, &short_lbl, out);
                } else {
                    self.emit_cond_br(&lv, &short_lbl, &rhs_lbl, out);
                }
                self.start_block(&short_lbl, out);
                let short_val = if op == BinOp::And { "false" } else { "true" };
                self.emit_br(&merge_lbl, out);

                self.start_block(&rhs_lbl, out);
                let rv = self.eval_cond_bool(rhs, op.symbol(), out)?;
                let rhs_end = self.fresh_label("any.logic.rhs.end");
                self.emit_br(&rhs_end, out);
                self.start_block(&rhs_end, out);
                self.emit_br(&merge_lbl, out);

                self.start_block(&merge_lbl, out);
                let phi = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {phi} = phi i1 [ {short_val}, %{short_lbl} ], [ {rv}, %{rhs_end} ]"
                );
                Ok((Type::Bool, phi))
            }
            BinOp::Eq | BinOp::Ne => {
                let la = self.eval_expr_as_any(lhs, out)?;
                let ra = self.eval_expr_as_any(rhs, out)?;
                let eq = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {eq} = call fastcc i1 @archx_any_eq(%ArchxAny {la}, %ArchxAny {ra})"
                );
                if op == BinOp::Eq {
                    Ok((Type::Bool, eq))
                } else {
                    let ne = self.next_tmp();
                    let _ = writeln!(out, "  {ne} = xor i1 {eq}, true");
                    Ok((Type::Bool, ne))
                }
            }
            BinOp::Lt | BinOp::Gt | BinOp::Le | BinOp::Ge => {
                let la = self.eval_expr_as_any(lhs, out)?;
                let ra = self.eval_expr_as_any(rhs, out)?;
                let code = match op {
                    BinOp::Lt => 0,
                    BinOp::Gt => 1,
                    BinOp::Le => 2,
                    BinOp::Ge => 3,
                    _ => unreachable!(),
                };
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc i1 @archx_any_cmp(%ArchxAny {la}, %ArchxAny {ra}, i64 {code})"
                );
                Ok((Type::Bool, res))
            }
            BinOp::In | BinOp::NotIn => {
                let la = self.eval_expr_as_any(lhs, out)?;
                let ra = self.eval_expr_as_any(rhs, out)?;
                let fnd = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {fnd} = call fastcc i1 @archx_any_in(%ArchxAny {la}, %ArchxAny {ra})"
                );
                if op == BinOp::In {
                    Ok((Type::Bool, fnd))
                } else {
                    let nf = self.next_tmp();
                    let _ = writeln!(out, "  {nf} = xor i1 {fnd}, true");
                    Ok((Type::Bool, nf))
                }
            }
            BinOp::Add
            | BinOp::Sub
            | BinOp::Mul
            | BinOp::Div
            | BinOp::FloorDiv
            | BinOp::Mod
            | BinOp::Pow => {
                let la = self.eval_expr_as_any(lhs, out)?;
                let ra = self.eval_expr_as_any(rhs, out)?;
                let code = match op {
                    BinOp::Add => 0,
                    BinOp::Sub => 1,
                    BinOp::Mul => 2,
                    BinOp::Div => 3,
                    BinOp::FloorDiv => 4,
                    BinOp::Mod => 5,
                    BinOp::Pow => 6,
                    _ => unreachable!(),
                };
                let rarg = self.active_region_arg();
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxAny @archx_any_binop(%ArchxAny {la}, %ArchxAny {ra}, i64 {code}, ptr {rarg})"
                );
                self.stmt_temps.push(TempDrop {
                    val: res.clone(),
                    ty: Type::Any,
                });
                Ok((Type::Any, res))
            }
        }
    }

    pub(super) fn gen_builtin_type(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new(
                format!("`type` expects 1 argument, found {}", args.len()),
                span,
            ));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        if ty == Type::Any {
            self.mark_runtime_type(&Type::Any);
            self.used_any_rt = true;
            let res = self.next_tmp();
            let _ = writeln!(
                out,
                "  {res} = call fastcc %ArchxStr @archx_any_type_name(%ArchxAny {val})"
            );
            return Ok((Type::Str, res));
        }
        let tname = match &ty {
            Type::Int => "int",
            Type::Float => "float",
            Type::Bool => "bool",
            Type::Str => "str",
            Type::Void => "NoneType",
            Type::Array(_) => "list",
            Type::Dict(_, _) => "dict",
            Type::Set(_) => "set",
            Type::Struct(sname) => sname.as_str(),
            Type::Any => unreachable!(),
        };
        Ok(self.eval_str_lit(tname))
    }

    pub(super) fn gen_builtin_isinstance(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 2 {
            return Err(Diagnostic::new(
                format!("`isinstance` expects 2 arguments, found {}", args.len()),
                span,
            ));
        }
        let target_tname = match &args[1].kind {
            ExprKind::Var(n) => n.as_str(),
            ExprKind::NoneLit => "NoneType",
            _ => {
                return Err(Diagnostic::new(
                    "`isinstance` second argument must be a type name (`int`, `float`, `bool`, `str`, `list`, `dict`, `set`, or class name)",
                    args[1].span,
                ))
            }
        };
        let expected_tag: Option<i64> = match target_tname {
            "NoneType" => Some(0),
            "bool" => Some(1),
            "int" => Some(2),
            "float" => Some(3),
            "str" | "string" => Some(4),
            "list" => Some(5),
            "dict" => Some(6),
            "set" => Some(7),
            name if self.structs.contains_key(name) => None,
            other => {
                return Err(Diagnostic::new(
                    format!("unknown type `{other}` in `isinstance`"),
                    args[1].span,
                ))
            }
        };

        let (ty, val) = self.eval_expr(&args[0], out)?;
        if ty == Type::Any {
            let Some(tag_id) = expected_tag else {
                return Ok((Type::Bool, "false".to_string()));
            };
            let tag = self.next_tmp();
            let _ = writeln!(out, "  {tag} = extractvalue %ArchxAny {val}, 0");
            let m = self.next_tmp();
            let _ = writeln!(out, "  {m} = icmp eq i64 {tag}, {tag_id}");
            return Ok((Type::Bool, m));
        }

        let static_match = match (&ty, target_tname) {
            (Type::Void, "NoneType") => true,
            (Type::Bool, "bool") => true,
            (Type::Int, "int") => true,
            (Type::Float, "float") => true,
            (Type::Str, "str" | "string") => true,
            (Type::Array(_), "list") => true,
            (Type::Dict(_, _), "dict") => true,
            (Type::Set(_), "set") => true,
            (Type::Struct(s), cname) => s == cname,
            _ => false,
        };
        Ok((Type::Bool, if static_match { "true" } else { "false" }.to_string()))
    }
}
