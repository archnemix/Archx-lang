//! Milestone 7 (`v0.7.0`) lowering for Planar SIMD `dict[K, V]`, `set[T]`, and Pythonic slicing
//! (`xs[start:stop:step]`, `s[start:stop:step]`, dynamic `any` slicing).

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

impl Codegen {
    // ---------------- Dict / Set Layout & Key Helpers ------------------------

    pub(super) fn dict_key_kind_and_size(k_ty: &Type) -> (u8, i64) {
        match k_ty {
            Type::Int | Type::Bool => (0, 8),
            Type::Str => (1, 16),
            Type::Any => (2, 24),
            _ => unreachable!("unhashable dict key type: {:?}", k_ty),
        }
    }

    pub(super) fn dict_family_suffix(k_ty: &Type) -> &'static str {
        match k_ty {
            Type::Int | Type::Bool => "i64",
            Type::Str => "str",
            Type::Any => "any",
            _ => unreachable!(),
        }
    }

    pub(super) fn dict_key_storage_ir(k_ty: &Type) -> &'static str {
        match k_ty {
            Type::Int | Type::Bool => "i64",
            Type::Str => "%ArchxStr",
            Type::Any => "%ArchxAny",
            _ => unreachable!(),
        }
    }

    pub(super) fn dict_meta_word(k_ty: &Type, v_ty: Option<&Type>) -> i64 {
        let (kind, ksz) = Self::dict_key_kind_and_size(k_ty);
        let vsz: i64 = match v_ty {
            None => 0,
            Some(Type::Bool) => 1,
            Some(Type::Int | Type::Float | Type::Dict(_, _) | Type::Set(_)) => 8,
            Some(Type::Str) => 16,
            Some(Type::Array(_) | Type::Any) => 24,
            Some(_) => 0,
        };
        (kind as i64) | (ksz << 8) | (vsz << 32)
    }

    pub(super) fn emit_dict_meta_ssa(
        &mut self,
        k_ty: &Type,
        v_ty: Option<&Type>,
        out: &mut String,
    ) -> String {
        let (kind, ksz) = Self::dict_key_kind_and_size(k_ty);
        let low = (kind as i64) | (ksz << 8);
        let Some(vt) = v_ty else {
            return low.to_string();
        };
        let vsz = self.emit_elem_sizeof(vt, out);
        if let Ok(c_vsz) = vsz.parse::<i64>() {
            return (low | (c_vsz << 32)).to_string();
        }
        let sh = self.next_tmp();
        let _ = writeln!(out, "  {sh} = shl i64 {vsz}, 32");
        let m = self.next_tmp();
        let _ = writeln!(out, "  {m} = or i64 {sh}, {low}");
        m
    }

    pub(super) fn emit_load_dict_key(
        &mut self,
        k_ty: &Type,
        ptr_ssa: &str,
        out: &mut String,
    ) -> String {
        let store_ty = Self::dict_key_storage_ir(k_ty);
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = load {store_ty}, ptr {ptr_ssa}, align 8");
        if *k_ty == Type::Bool {
            let b = self.next_tmp();
            let _ = writeln!(out, "  {b} = trunc i64 {raw} to i1");
            b
        } else {
            raw
        }
    }

    pub(super) fn eval_key_for_dict(
        &mut self,
        k_ty: &Type,
        key_expr: &Expr,
        out: &mut String,
    ) -> Result<(String, String)> {
        if *k_ty == Type::Any {
            let ka = self.eval_expr_as_any(key_expr, out)?;
            return Ok(("%ArchxAny".to_string(), ka));
        }
        let (actual_ty, val) = self.eval_expr_typed(key_expr, Some(k_ty), out)?;
        let coerced = if actual_ty == *k_ty {
            val
        } else if actual_ty == Type::Any {
            self.emit_unbox_any(k_ty, &val, key_expr.span, out)?
        } else {
            return Err(Diagnostic::new(
                format!(
                    "key type mismatch: expected `{}`, found `{}`",
                    k_ty.name(),
                    actual_ty.name()
                ),
                key_expr.span,
            ));
        };
        if *k_ty == Type::Bool {
            let z = self.next_tmp();
            let _ = writeln!(out, "  {z} = zext i1 {coerced} to i64");
            Ok(("i64".to_string(), z))
        } else {
            Ok((Self::dict_key_storage_ir(k_ty).to_string(), coerced))
        }
    }

    pub(super) fn emit_new_empty_dict_or_set(
        &mut self,
        k_ty: &Type,
        v_ty: Option<&Type>,
        out: &mut String,
    ) -> String {
        self.used_dict_rt = true;
        self.mark_runtime_type(k_ty);
        if let Some(vt) = v_ty {
            self.mark_runtime_type(vt);
        }
        self.used_dict_type = true;
        if *k_ty == Type::Any || v_ty == Some(&Type::Any) {
            self.used_any_rt = true;
        }
        let meta = self.emit_dict_meta_ssa(k_ty, v_ty, out);
        let rarg = self.active_region_arg();
        let d = self.next_tmp();
        let _ = writeln!(
            out,
            "  {d} = call fastcc i64 @archx_dict_new(i64 {meta}, ptr {rarg})"
        );
        d
    }

    pub(super) fn emit_dict_len(&mut self, d_val: &str, out: &mut String) -> String {
        self.used_dict_type = true;
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
        let is_z = self.next_tmp();
        let _ = writeln!(out, "  {is_z} = icmp eq i64 {raw}, 0");
        let z_lbl = self.fresh_label("dlen.zero");
        let ld_lbl = self.fresh_label("dlen.load");
        let done_lbl = self.fresh_label("dlen.done");
        self.emit_cond_br(&is_z, &z_lbl, &ld_lbl, out);
        self.start_block(&z_lbl, out);
        self.emit_br(&done_lbl, out);
        self.start_block(&ld_lbl, out);
        let hp = self.next_tmp();
        let _ = writeln!(out, "  {hp} = inttoptr i64 {raw} to ptr");
        let lv = self.next_tmp();
        let _ = writeln!(out, "  {lv} = load i64, ptr {hp}, align 8");
        self.emit_br(&done_lbl, out);
        self.start_block(&done_lbl, out);
        let phi = self.next_tmp();
        let _ = writeln!(
            out,
            "  {phi} = phi i64 [ 0, %{z_lbl} ], [ {lv}, %{ld_lbl} ]"
        );
        phi
    }

    // ---------------- Monomorphized RAII Drop & Clone ------------------------

    pub(super) fn ensure_dict_drop_helper(&mut self, k_ty: &Type, v_ty: Option<&Type>) -> String {
        self.used_dict_rt = true;
        self.used_dict_type = true;
        self.mark_runtime_type(k_ty);
        if let Some(vt) = v_ty {
            self.mark_runtime_type(vt);
        }
        let mkey = match v_ty {
            Some(vt) => format!("dict_{}_{}", type_mangle_key(k_ty), type_mangle_key(vt)),
            None => format!("set_{}", type_mangle_key(k_ty)),
        };
        let fn_sym = match v_ty {
            Some(vt) => format!(
                "@archx_dict_drop_{}_{}",
                type_mangle_key(k_ty),
                type_mangle_key(vt)
            ),
            None => format!("@archx_set_drop_{}", type_mangle_key(k_ty)),
        };
        if !self.emitted_dict_drops.insert(mkey) {
            return fn_sym;
        }

        let saved_tmp = self.next_tmp;
        let saved_lbl = self.next_label;
        let saved_term = self.terminated;
        self.next_tmp = 0;
        self.next_label = 0;
        self.terminated = false;

        let mut h = String::new();
        let _ = writeln!(h, "define private fastcc void {fn_sym}(i64 %d) {{");
        let _ = writeln!(h, "entry:");
        let _ = writeln!(h, "  %raw = and i64 %d, -4");
        let _ = writeln!(h, "  %is_z = icmp eq i64 %raw, 0");
        let _ = writeln!(h, "  br i1 %is_z, label %done, label %body");
        let _ = writeln!(h, "body:");
        let _ = writeln!(h, "  %hdr = inttoptr i64 %raw to ptr");
        let _ = writeln!(h, "  %len = load i64, ptr %hdr, align 8");
        let _ = writeln!(
            h,
            "  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4"
        );
        let _ = writeln!(
            h,
            "  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5"
        );
        let _ = writeln!(
            h,
            "  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6"
        );
        let _ = writeln!(h, "  %ctrl = load ptr, ptr %ctrl_p, align 8");
        let _ = writeln!(h, "  %keys = load ptr, ptr %keys_p, align 8");
        let _ = writeln!(h, "  %vals = load ptr, ptr %vals_p, align 8");

        let k_drop = self.type_needs_drop(k_ty);
        let v_drop = v_ty.map_or(false, |vt| self.type_needs_drop(vt));
        if k_drop || v_drop {
            let _ = writeln!(h, "  %i_slot = alloca i64, align 8");
            let _ = writeln!(h, "  store i64 0, ptr %i_slot, align 8");
            let _ = writeln!(h, "  br label %d_cond");
            let _ = writeln!(h, "d_cond:");
            let _ = writeln!(h, "  %i = load i64, ptr %i_slot, align 8");
            let _ = writeln!(h, "  %more = icmp slt i64 %i, %len");
            let _ = writeln!(h, "  br i1 %more, label %d_elem, label %free_hdr");
            let _ = writeln!(h, "d_elem:");
            self.terminated = false;
            if k_drop {
                let kstore = Self::dict_key_storage_ir(k_ty);
                let kp = self.next_tmp();
                let _ = writeln!(
                    h,
                    "  {kp} = getelementptr inbounds {kstore}, ptr %keys, i64 %i"
                );
                let kv = self.emit_load_dict_key(k_ty, &kp, &mut h);
                self.emit_drop_value(k_ty, &kv, &mut h);
            }
            if let Some(vt) = v_ty {
                if v_drop {
                    let vmem = elem_mem_ir_type(vt);
                    let vp = self.next_tmp();
                    let _ = writeln!(
                        h,
                        "  {vp} = getelementptr inbounds {vmem}, ptr %vals, i64 %i"
                    );
                    let vv = self.emit_elem_load(vt, &vp, &mut h);
                    self.emit_drop_value(vt, &vv, &mut h);
                }
            }
            let _ = writeln!(h, "  %inext = add nuw nsw i64 %i, 1");
            let _ = writeln!(h, "  store i64 %inext, ptr %i_slot, align 8");
            let _ = writeln!(h, "  br label %d_cond");
        } else {
            let _ = writeln!(h, "  br label %free_hdr");
        }

        let _ = writeln!(h, "free_hdr:");
        let _ = writeln!(h, "  %tag = and i64 %d, 3");
        let _ = writeln!(h, "  %is_heap = icmp eq i64 %tag, 1");
        let _ = writeln!(h, "  br i1 %is_heap, label %do_free, label %done");
        let _ = writeln!(h, "do_free:");
        let _ = writeln!(h, "  call void @free(ptr %ctrl)");
        let _ = writeln!(h, "  call void @free(ptr %keys)");
        let _ = writeln!(h, "  call void @free(ptr %vals)");
        let _ = writeln!(h, "  call void @free(ptr %hdr)");
        let _ = writeln!(h, "  br label %done");
        let _ = writeln!(h, "done:");
        let _ = writeln!(h, "  ret void");
        let _ = writeln!(h, "}}\n");

        self.next_tmp = saved_tmp;
        self.next_label = saved_lbl;
        self.terminated = saved_term;
        self.extra_helpers.push_str(&h);
        fn_sym
    }

    pub(super) fn ensure_dict_clone_helper(&mut self, k_ty: &Type, v_ty: Option<&Type>) -> String {
        self.used_dict_rt = true;
        self.used_dict_type = true;
        self.mark_runtime_type(k_ty);
        if let Some(vt) = v_ty {
            self.mark_runtime_type(vt);
        }
        let mkey = match v_ty {
            Some(vt) => format!("dict_{}_{}", type_mangle_key(k_ty), type_mangle_key(vt)),
            None => format!("set_{}", type_mangle_key(k_ty)),
        };
        let fn_sym = match v_ty {
            Some(vt) => format!(
                "@archx_dict_clone_{}_{}",
                type_mangle_key(k_ty),
                type_mangle_key(vt)
            ),
            None => format!("@archx_set_clone_{}", type_mangle_key(k_ty)),
        };
        if !self.emitted_dict_clones.insert(mkey) {
            return fn_sym;
        }

        let saved_tmp = self.next_tmp;
        let saved_lbl = self.next_label;
        let saved_term = self.terminated;
        let saved_regs = self.region_stack.clone();
        self.next_tmp = 0;
        self.next_label = 0;
        self.terminated = false;
        self.region_stack.clear();

        let mut h = String::new();
        let _ = writeln!(h, "define private fastcc i64 {fn_sym}(i64 %d) {{");
        let _ = writeln!(h, "entry:");
        let meta = self.emit_dict_meta_ssa(k_ty, v_ty, &mut h);
        let _ = writeln!(
            h,
            "  %dst = call fastcc i64 @archx_dict_new(i64 {meta}, ptr null)"
        );
        let _ = writeln!(h, "  %raw = and i64 %d, -4");
        let _ = writeln!(h, "  %is_z = icmp eq i64 %raw, 0");
        let _ = writeln!(h, "  br i1 %is_z, label %done, label %init");
        let _ = writeln!(h, "init:");
        let _ = writeln!(h, "  %hdr = inttoptr i64 %raw to ptr");
        let _ = writeln!(h, "  %len = load i64, ptr %hdr, align 8");
        let _ = writeln!(
            h,
            "  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5"
        );
        let _ = writeln!(
            h,
            "  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6"
        );
        let _ = writeln!(h, "  %keys = load ptr, ptr %keys_p, align 8");
        let _ = writeln!(h, "  %vals = load ptr, ptr %vals_p, align 8");
        let _ = writeln!(h, "  %i_slot = alloca i64, align 8");
        let _ = writeln!(h, "  store i64 0, ptr %i_slot, align 8");
        let _ = writeln!(h, "  br label %c_cond");
        let _ = writeln!(h, "c_cond:");
        let _ = writeln!(h, "  %i = load i64, ptr %i_slot, align 8");
        let _ = writeln!(h, "  %more = icmp slt i64 %i, %len");
        let _ = writeln!(h, "  br i1 %more, label %c_body, label %done");
        let _ = writeln!(h, "c_body:");
        self.terminated = false;

        let kstore = Self::dict_key_storage_ir(k_ty);
        let fam = Self::dict_family_suffix(k_ty);
        let kp = self.next_tmp();
        let _ = writeln!(
            h,
            "  {kp} = getelementptr inbounds {kstore}, ptr %keys, i64 %i"
        );
        let kraw = self.next_tmp();
        let _ = writeln!(h, "  {kraw} = load {kstore}, ptr {kp}, align 8");
        let up = self.next_tmp();
        let _ = writeln!(
            h,
            "  {up} = call fastcc {{ i64, i1 }} @archx_dict_upsert_{fam}(i64 %dst, {kstore} {kraw})"
        );
        if let Some(vt) = v_ty {
            let didx = self.next_tmp();
            let _ = writeln!(h, "  {didx} = extractvalue {{ i64, i1 }} {up}, 0");
            let vmem = elem_mem_ir_type(vt);
            let svp = self.next_tmp();
            let _ = writeln!(
                h,
                "  {svp} = getelementptr inbounds {vmem}, ptr %vals, i64 %i"
            );
            let sv = self.emit_elem_load(vt, &svp, &mut h);
            let cv = if self.type_needs_drop(vt) {
                self.emit_clone_value(vt, &sv, &mut h)
            } else {
                sv
            };
            let draw = self.next_tmp();
            let _ = writeln!(h, "  {draw} = and i64 %dst, -4");
            let dhdr = self.next_tmp();
            let _ = writeln!(h, "  {dhdr} = inttoptr i64 {draw} to ptr");
            let dvg = self.next_tmp();
            let _ = writeln!(
                h,
                "  {dvg} = getelementptr inbounds %ArchxDictHdr, ptr {dhdr}, i32 0, i32 6"
            );
            let dvp = self.next_tmp();
            let _ = writeln!(h, "  {dvp} = load ptr, ptr {dvg}, align 8");
            let dep = self.next_tmp();
            let _ = writeln!(
                h,
                "  {dep} = getelementptr inbounds {vmem}, ptr {dvp}, i64 {didx}"
            );
            self.emit_elem_store(vt, &cv, &dep, &mut h);
        }
        let _ = writeln!(h, "  %inext = add nuw nsw i64 %i, 1");
        let _ = writeln!(h, "  store i64 %inext, ptr %i_slot, align 8");
        let _ = writeln!(h, "  br label %c_cond");
        let _ = writeln!(h, "done:");
        let _ = writeln!(h, "  ret i64 %dst");
        let _ = writeln!(h, "}}\n");

        self.next_tmp = saved_tmp;
        self.next_label = saved_lbl;
        self.terminated = saved_term;
        self.region_stack = saved_regs;
        self.extra_helpers.push_str(&h);
        fn_sym
    }

    // ---------------- Literals & Builtin Constructors ------------------------

    pub(super) fn eval_dict_lit(
        &mut self,
        pairs: &[(Expr, Expr)],
        expected: Option<&Type>,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if pairs.is_empty() {
            let (kt, vt) = match expected {
                Some(Type::Dict(k, v)) => ((**k).clone(), (**v).clone()),
                _ => (Type::Any, Type::Any),
            };
            validate_type(&Type::Dict(Box::new(kt.clone()), Box::new(vt.clone())), &self.structs, span)?;
            let d = self.emit_new_empty_dict_or_set(&kt, Some(&vt), out);
            let res_ty = Type::Dict(Box::new(kt), Box::new(vt));
            self.stmt_temps.push(TempDrop {
                val: d.clone(),
                ty: res_ty.clone(),
            });
            return Ok((res_ty, d));
        }

        if let Some(Type::Dict(exp_k, exp_v)) = expected {
            validate_type(
                &Type::Dict(exp_k.clone(), exp_v.clone()),
                &self.structs,
                span,
            )?;
            let d = self.emit_new_empty_dict_or_set(exp_k, Some(exp_v), out);
            for (ke, ve) in pairs {
                self.emit_dict_insert_expr(exp_k, exp_v, &d, ke, ve, out)?;
            }
            let res_ty = Type::Dict(exp_k.clone(), exp_v.clone());
            self.stmt_temps.push(TempDrop {
                val: d.clone(),
                ty: res_ty.clone(),
            });
            return Ok((res_ty, d));
        }

        if expected == Some(&Type::Any) {
            let d = self.emit_new_empty_dict_or_set(&Type::Any, Some(&Type::Any), out);
            for (ke, ve) in pairs {
                self.emit_dict_insert_expr(&Type::Any, &Type::Any, &d, ke, ve, out)?;
            }
            let r = self.next_tmp();
            let _ = writeln!(
                out,
                "  {r} = insertvalue %ArchxAny {{ i64 6, i64 0, i64 0 }}, i64 {d}, 1"
            );
            self.stmt_temps.push(TempDrop {
                val: r.clone(),
                ty: Type::Any,
            });
            return Ok((Type::Any, r));
        }

        // Evaluate all pairs and adaptively specialize:
        // - Homogeneous K & V -> Tier-1 `dict[K, V]`
        // - Homogeneous K, mixed V (e.g. `{"data": ["Archx", 18], "age": 18}`) -> `dict[K, any]`
        // - Mixed K -> `dict[any, any]`
        let mut eval_ks = Vec::with_capacity(pairs.len());
        let mut eval_vs = Vec::with_capacity(pairs.len());
        for (ke, ve) in pairs {
            let kt_val = if matches!(&ke.kind, ExprKind::NoneLit) {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                (Type::Any, "zeroinitializer".to_string(), ke.span)
            } else {
                let (kt, kv) = self.eval_expr(ke, out)?;
                if !kt.is_hashable_key() {
                    return Err(Diagnostic::new(
                        format!("dict key of type `{}` is not hashable", kt.name()),
                        ke.span,
                    ));
                }
                (kt, kv, ke.span)
            };
            let vt_val = if matches!(&ve.kind, ExprKind::NoneLit) {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                (Type::Any, "zeroinitializer".to_string(), ve.span)
            } else {
                let (vt, vv) = self.eval_expr(ve, out)?;
                (vt, vv, ve.span)
            };
            eval_ks.push(kt_val);
            eval_vs.push(vt_val);
        }

        let unified_k = {
            let first = &eval_ks[0].0;
            if *first != Type::Any && eval_ks.iter().all(|(t, _, _)| t == first) {
                first.clone()
            } else {
                Type::Any
            }
        };
        let unified_v = {
            let first = &eval_vs[0].0;
            if *first != Type::Any
                && *first != Type::Void
                && eval_vs.iter().all(|(t, _, _)| t == first)
            {
                first.clone()
            } else {
                Type::Any
            }
        };

        let d = self.emit_new_empty_dict_or_set(&unified_k, Some(&unified_v), out);
        let fam = Self::dict_family_suffix(&unified_k);
        let kstore = Self::dict_key_storage_ir(&unified_k);
        let vmem = elem_mem_ir_type(&unified_v);

        for ((kt, kv, kspan), (vt, vv, vspan)) in eval_ks.into_iter().zip(eval_vs.into_iter()) {
            let (k_arg, drop_temp_k_any) = if unified_k == Type::Any {
                let ka = self.emit_box_any_owned(&kt, &kv, kspan, out)?;
                (ka, true)
            } else if unified_k == Type::Bool {
                let z = self.next_tmp();
                let _ = writeln!(out, "  {z} = zext i1 {kv} to i64");
                (z, false)
            } else {
                (kv, false)
            };

            let owned_v = if unified_v == Type::Any {
                self.emit_box_any_owned(&vt, &vv, vspan, out)?
            } else if self.type_needs_drop(&vt) {
                if self.claim_stmt_temp(&vv) {
                    vv
                } else {
                    self.emit_clone_value(&vt, &vv, out)
                }
            } else {
                vv
            };

            let up = self.next_tmp();
            let _ = writeln!(
                out,
                "  {up} = call fastcc {{ i64, i1 }} @archx_dict_upsert_{fam}(i64 {d}, {kstore} {k_arg})"
            );
            if drop_temp_k_any {
                let _ = writeln!(out, "  call fastcc void @archx_any_drop(%ArchxAny {k_arg})");
            }
            let didx = self.next_tmp();
            let _ = writeln!(out, "  {didx} = extractvalue {{ i64, i1 }} {up}, 0");
            let existed = self.next_tmp();
            let _ = writeln!(out, "  {existed} = extractvalue {{ i64, i1 }} {up}, 1");

            let raw = self.next_tmp();
            let _ = writeln!(out, "  {raw} = and i64 {d}, -4");
            let hdr = self.next_tmp();
            let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
            let vg = self.next_tmp();
            let _ = writeln!(
                out,
                "  {vg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 6"
            );
            let vptr = self.next_tmp();
            let _ = writeln!(out, "  {vptr} = load ptr, ptr {vg}, align 8");
            let vep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {vep} = getelementptr inbounds {vmem}, ptr {vptr}, i64 {didx}"
            );
            if self.type_needs_drop(&unified_v) {
                let drop_lbl = self.fresh_label("dlit.dropold");
                let store_lbl = self.fresh_label("dlit.store");
                self.emit_cond_br(&existed, &drop_lbl, &store_lbl, out);
                self.start_block(&drop_lbl, out);
                let old_v = self.emit_elem_load(&unified_v, &vep, out);
                self.emit_drop_value(&unified_v, &old_v, out);
                self.emit_br(&store_lbl, out);
                self.start_block(&store_lbl, out);
            }
            self.emit_elem_store(&unified_v, &owned_v, &vep, out);
        }

        let res_ty = Type::Dict(Box::new(unified_k), Box::new(unified_v));
        self.stmt_temps.push(TempDrop {
            val: d.clone(),
            ty: res_ty.clone(),
        });
        Ok((res_ty, d))
    }

    pub(super) fn eval_set_lit(
        &mut self,
        elems: &[Expr],
        expected: Option<&Type>,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if let Some(Type::Set(exp_e)) = expected {
            validate_type(&Type::Set(exp_e.clone()), &self.structs, span)?;
            let s = self.emit_new_empty_dict_or_set(exp_e, None, out);
            let fam = Self::dict_family_suffix(exp_e);
            for e in elems {
                let (kir, kval) = self.eval_key_for_dict(exp_e, e, out)?;
                let up = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {up} = call fastcc {{ i64, i1 }} @archx_dict_upsert_{fam}(i64 {s}, {kir} {kval})"
                );
            }
            let res_ty = Type::Set(exp_e.clone());
            self.stmt_temps.push(TempDrop {
                val: s.clone(),
                ty: res_ty.clone(),
            });
            return Ok((res_ty, s));
        }

        let mut eval_es = Vec::with_capacity(elems.len());
        for e in elems {
            let (et, ev) = self.eval_expr(e, out)?;
            if !et.is_hashable_key() {
                return Err(Diagnostic::new(
                    format!("set element of type `{}` is not hashable", et.name()),
                    e.span,
                ));
            }
            eval_es.push((et, ev, e.span));
        }
        let unified_e = if expected == Some(&Type::Any) || eval_es.is_empty() {
            Type::Any
        } else {
            let first = &eval_es[0].0;
            if *first != Type::Any && eval_es.iter().all(|(t, _, _)| t == first) {
                first.clone()
            } else {
                Type::Any
            }
        };

        let s = self.emit_new_empty_dict_or_set(&unified_e, None, out);
        let fam = Self::dict_family_suffix(&unified_e);
        let kstore = Self::dict_key_storage_ir(&unified_e);
        for (et, ev, espan) in eval_es {
            let (k_arg, drop_ka) = if unified_e == Type::Any {
                let ka = self.emit_box_any_owned(&et, &ev, espan, out)?;
                (ka, true)
            } else if unified_e == Type::Bool {
                let z = self.next_tmp();
                let _ = writeln!(out, "  {z} = zext i1 {ev} to i64");
                (z, false)
            } else {
                (ev, false)
            };
            let up = self.next_tmp();
            let _ = writeln!(
                out,
                "  {up} = call fastcc {{ i64, i1 }} @archx_dict_upsert_{fam}(i64 {s}, {kstore} {k_arg})"
            );
            if drop_ka {
                let _ = writeln!(out, "  call fastcc void @archx_any_drop(%ArchxAny {k_arg})");
            }
        }

        if expected == Some(&Type::Any) {
            let r = self.next_tmp();
            let _ = writeln!(
                out,
                "  {r} = insertvalue %ArchxAny {{ i64 7, i64 0, i64 0 }}, i64 {s}, 1"
            );
            self.stmt_temps.push(TempDrop {
                val: r.clone(),
                ty: Type::Any,
            });
            return Ok((Type::Any, r));
        }

        let res_ty = Type::Set(Box::new(unified_e));
        self.stmt_temps.push(TempDrop {
            val: s.clone(),
            ty: res_ty.clone(),
        });
        Ok((res_ty, s))
    }

    fn emit_dict_insert_expr(
        &mut self,
        k_ty: &Type,
        v_ty: &Type,
        d_val: &str,
        key_expr: &Expr,
        val_expr: &Expr,
        out: &mut String,
    ) -> Result<()> {
        let fam = Self::dict_family_suffix(k_ty);
        let (kir, kval) = self.eval_key_for_dict(k_ty, key_expr, out)?;
        let owned_v = self.eval_owned_for_slot(v_ty, val_expr, out)?;
        let up = self.next_tmp();
        let _ = writeln!(
            out,
            "  {up} = call fastcc {{ i64, i1 }} @archx_dict_upsert_{fam}(i64 {d_val}, {kir} {kval})"
        );
        let didx = self.next_tmp();
        let _ = writeln!(out, "  {didx} = extractvalue {{ i64, i1 }} {up}, 0");
        let existed = self.next_tmp();
        let _ = writeln!(out, "  {existed} = extractvalue {{ i64, i1 }} {up}, 1");

        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
        let hdr = self.next_tmp();
        let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
        let vg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 6"
        );
        let vptr = self.next_tmp();
        let _ = writeln!(out, "  {vptr} = load ptr, ptr {vg}, align 8");
        let vmem = elem_mem_ir_type(v_ty);
        let vep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vep} = getelementptr inbounds {vmem}, ptr {vptr}, i64 {didx}"
        );
        if self.type_needs_drop(v_ty) {
            let drop_lbl = self.fresh_label("dins.dropold");
            let store_lbl = self.fresh_label("dins.store");
            self.emit_cond_br(&existed, &drop_lbl, &store_lbl, out);
            self.start_block(&drop_lbl, out);
            let old_v = self.emit_elem_load(v_ty, &vep, out);
            self.emit_drop_value(v_ty, &old_v, out);
            self.emit_br(&store_lbl, out);
            self.start_block(&store_lbl, out);
        }
        self.emit_elem_store(v_ty, &owned_v, &vep, out);
        Ok(())
    }

    pub(super) fn eval_owned_for_slot(
        &mut self,
        expected: &Type,
        expr: &Expr,
        out: &mut String,
    ) -> Result<String> {
        if *expected == Type::Any {
            if matches!(&expr.kind, ExprKind::NoneLit) {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                return Ok("zeroinitializer".to_string());
            }
            let (ty, val) = self.eval_expr_typed(expr, Some(&Type::Any), out)?;
            return self.emit_box_any_owned(&ty, &val, expr.span, out);
        }
        let (ty, val) = self.eval_expr_typed(expr, Some(expected), out)?;
        let coerced = if ty == *expected {
            val
        } else if ty == Type::Any {
            self.emit_unbox_any(expected, &val, expr.span, out)?
        } else {
            return Err(Diagnostic::new(
                format!(
                    "type mismatch: expected `{}`, found `{}`",
                    expected.name(),
                    ty.name()
                ),
                expr.span,
            ));
        };
        if self.type_needs_drop(expected) {
            if self.claim_stmt_temp(&coerced) {
                Ok(coerced)
            } else {
                Ok(self.emit_clone_value(expected, &coerced, out))
            }
        } else {
            Ok(coerced)
        }
    }

    // ---------------- Indexing, Contains, Assignment & Methods ---------------

    pub(super) fn eval_dict_index(
        &mut self,
        k_ty: &Type,
        v_ty: &Type,
        d_val: &str,
        idx_expr: &Expr,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.used_dict_rt = true;
        self.used_key_fail = true;
        let fam = Self::dict_family_suffix(k_ty);
        let (kir, kval) = self.eval_key_for_dict(k_ty, idx_expr, out)?;
        let didx = self.next_tmp();
        let _ = writeln!(
            out,
            "  {didx} = call fastcc i64 @archx_dict_lookup_{fam}(i64 {d_val}, {kir} {kval})"
        );
        let ok = self.next_tmp();
        let _ = writeln!(out, "  {ok} = icmp sge i64 {didx}, 0");
        let ok_lbl = self.fresh_label("dget.ok");
        let miss_lbl = self.fresh_label("dget.miss");
        self.emit_cond_br(&ok, &ok_lbl, &miss_lbl, out);

        self.start_block(&miss_lbl, out);
        let _ = writeln!(out, "  call void @archx_key_fail()");
        let _ = writeln!(out, "  unreachable");

        self.start_block(&ok_lbl, out);
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
        let hdr = self.next_tmp();
        let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
        let vg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 6"
        );
        let vptr = self.next_tmp();
        let _ = writeln!(out, "  {vptr} = load ptr, ptr {vg}, align 8");
        let vmem = elem_mem_ir_type(v_ty);
        let vep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vep} = getelementptr inbounds {vmem}, ptr {vptr}, i64 {didx}"
        );
        let loaded = self.emit_elem_load(v_ty, &vep, out);
        let out_val = if self.type_needs_drop(v_ty) {
            let c = self.emit_clone_value(v_ty, &loaded, out);
            self.stmt_temps.push(TempDrop {
                val: c.clone(),
                ty: v_ty.clone(),
            });
            c
        } else {
            loaded
        };
        Ok((v_ty.clone(), out_val))
    }

    #[allow(clippy::too_many_arguments)]
    pub(super) fn gen_dict_index_assign(
        &mut self,
        k_ty: &Type,
        v_ty: &Type,
        d_val: &str,
        idx_expr: &Expr,
        op: Option<BinOp>,
        value: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        self.used_dict_rt = true;
        if let Some(bin_op) = op {
            self.used_key_fail = true;
            let fam = Self::dict_family_suffix(k_ty);
            let (kir, kval) = self.eval_key_for_dict(k_ty, idx_expr, out)?;
            let didx = self.next_tmp();
            let _ = writeln!(
                out,
                "  {didx} = call fastcc i64 @archx_dict_lookup_{fam}(i64 {d_val}, {kir} {kval})"
            );
            let ok = self.next_tmp();
            let _ = writeln!(out, "  {ok} = icmp sge i64 {didx}, 0");
            let ok_lbl = self.fresh_label("dupd.ok");
            let miss_lbl = self.fresh_label("dupd.miss");
            self.emit_cond_br(&ok, &ok_lbl, &miss_lbl, out);
            self.start_block(&miss_lbl, out);
            let _ = writeln!(out, "  call void @archx_key_fail()");
            let _ = writeln!(out, "  unreachable");
            self.start_block(&ok_lbl, out);

            let raw = self.next_tmp();
            let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
            let hdr = self.next_tmp();
            let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
            let vg = self.next_tmp();
            let _ = writeln!(
                out,
                "  {vg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 6"
            );
            let vptr = self.next_tmp();
            let _ = writeln!(out, "  {vptr} = load ptr, ptr {vg}, align 8");
            let vmem = elem_mem_ir_type(v_ty);
            let vep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {vep} = getelementptr inbounds {vmem}, ptr {vptr}, i64 {didx}"
            );
            let old_val = self.emit_elem_load(v_ty, &vep, out);
            match v_ty {
                Type::Int => {
                    let (rty, rval) = self.eval_expr(value, out)?;
                    if rty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires `int` right-hand side, found `{}`",
                                bin_op.symbol(),
                                rty.name()
                            ),
                            value.span,
                        ));
                    }
                    let nv = self.emit_int_arith(bin_op, &old_val, &rval, out);
                    let _ = writeln!(out, "  store i64 {nv}, ptr {vep}, align 8");
                }
                Type::Float => {
                    let (rty, rval) = self.eval_expr_typed(value, Some(&Type::Float), out)?;
                    let rflt = if rty == Type::Float {
                        rval
                    } else if rty == Type::Int {
                        let cv = self.next_tmp();
                        let _ = writeln!(out, "  {cv} = sitofp i64 {rval} to double");
                        cv
                    } else {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires numeric right-hand side, found `{}`",
                                bin_op.symbol(),
                                rty.name()
                            ),
                            value.span,
                        ));
                    };
                    let nv = self.emit_float_arith(bin_op, &old_val, &rflt, out);
                    let _ = writeln!(out, "  store double {nv}, ptr {vep}, align 8");
                }
                Type::Str if bin_op == BinOp::Add => {
                    let (rty, rval) = self.eval_expr(value, out)?;
                    if rty != Type::Str {
                        return Err(Diagnostic::new(
                            format!("`+=` on `str` requires `str`, found `{}`", rty.name()),
                            value.span,
                        ));
                    }
                    let nv = self.emit_str_concat_call(&old_val, &rval, out);
                    let _ = self.claim_stmt_temp(&nv);
                    let nv_heap = if !self.region_stack.is_empty() {
                        self.emit_promote_to_heap(&Type::Str, &nv, out)
                    } else {
                        nv
                    };
                    self.emit_drop_value(&Type::Str, &old_val, out);
                    let _ = writeln!(out, "  store %ArchxStr {nv_heap}, ptr {vep}, align 8");
                }
                Type::Any => {
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
                    let ra = self.eval_expr_as_any(value, out)?;
                    let rarg = self.active_region_arg();
                    let nv = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {nv} = call fastcc %ArchxAny @archx_any_binop(%ArchxAny {old_val}, %ArchxAny {ra}, i64 {code}, ptr {rarg})"
                    );
                    self.emit_drop_value(&Type::Any, &old_val, out);
                    let _ = writeln!(out, "  store %ArchxAny {nv}, ptr {vep}, align 8");
                }
                _ => {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}=` is not supported on dict value type `{}`",
                            bin_op.symbol(),
                            v_ty.name()
                        ),
                        span,
                    ))
                }
            }
            return Ok(());
        }

        self.emit_dict_insert_expr(k_ty, v_ty, d_val, idx_expr, value, out)
    }

    pub(super) fn eval_dict_or_set_contains(
        &mut self,
        k_ty: &Type,
        d_val: &str,
        needle_expr: &Expr,
        negated: bool,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.used_dict_rt = true;
        let fam = Self::dict_family_suffix(k_ty);
        let (kir, kval) = self.eval_key_for_dict(k_ty, needle_expr, out)?;
        let didx = self.next_tmp();
        let _ = writeln!(
            out,
            "  {didx} = call fastcc i64 @archx_dict_lookup_{fam}(i64 {d_val}, {kir} {kval})"
        );
        let cmp = if negated { "slt" } else { "sge" };
        let res = self.next_tmp();
        let _ = writeln!(out, "  {res} = icmp {cmp} i64 {didx}, 0");
        Ok((Type::Bool, res))
    }

    #[allow(clippy::too_many_arguments)]
    pub(super) fn gen_dict_method(
        &mut self,
        k_ty: &Type,
        v_ty: &Type,
        d_val: &str,
        method: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.used_dict_rt = true;
        match method {
            "get" => {
                if args.is_empty() || args.len() > 2 {
                    return Err(Diagnostic::new(
                        format!("`dict.get` expects 1 or 2 arguments, found {}", args.len()),
                        span,
                    ));
                }
                let fam = Self::dict_family_suffix(k_ty);
                let (kir, kval) = self.eval_key_for_dict(k_ty, &args[0], out)?;
                let didx = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {didx} = call fastcc i64 @archx_dict_lookup_{fam}(i64 {d_val}, {kir} {kval})"
                );
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp sge i64 {didx}, 0");

                if args.len() == 1 {
                    // 1-arg `d.get(k)` returns `any` (`None` when absent, boxed `V` when found) just like Python!
                    let hit_lbl = self.fresh_label("dget1.hit");
                    let hit_end = self.fresh_label("dget1.hit.end");
                    let miss_lbl = self.fresh_label("dget1.miss");
                    let merge_lbl = self.fresh_label("dget1.merge");
                    self.emit_cond_br(&ok, &hit_lbl, &miss_lbl, out);

                    self.start_block(&hit_lbl, out);
                    let loaded = self.emit_load_dict_val_at(v_ty, d_val, &didx, out);
                    let boxed = self.emit_box_any_owned(v_ty, &loaded, span, out)?;
                    self.emit_br(&hit_end, out);
                    self.start_block(&hit_end, out);
                    self.emit_br(&merge_lbl, out);

                    self.start_block(&miss_lbl, out);
                    self.mark_runtime_type(&Type::Any);
                    self.used_any_rt = true;
                    self.emit_br(&merge_lbl, out);

                    self.start_block(&merge_lbl, out);
                    let phi = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {phi} = phi %ArchxAny [ {boxed}, %{hit_end} ], [ zeroinitializer, %{miss_lbl} ]"
                    );
                    self.stmt_temps.push(TempDrop {
                        val: phi.clone(),
                        ty: Type::Any,
                    });
                    return Ok((Type::Any, phi));
                }

                // 2-arg `d.get(k, default)`: if `default` matches `v_ty`, stays Tier-1 `v_ty` (zero boxing!);
                // otherwise widens cleanly to `Type::Any`!
                let (def_ty, def_val) = if matches!(&args[1].kind, ExprKind::NoneLit) {
                    self.mark_runtime_type(&Type::Any);
                    self.used_any_rt = true;
                    (Type::Any, "zeroinitializer".to_string())
                } else {
                    self.eval_expr_typed(&args[1], Some(v_ty), out)?
                };
                let ret_ty = if def_ty == *v_ty {
                    v_ty.clone()
                } else {
                    Type::Any
                };

                let hit_lbl = self.fresh_label("dget2.hit");
                let hit_end = self.fresh_label("dget2.hit.end");
                let miss_lbl = self.fresh_label("dget2.miss");
                let miss_end = self.fresh_label("dget2.miss.end");
                let merge_lbl = self.fresh_label("dget2.merge");
                self.emit_cond_br(&ok, &hit_lbl, &miss_lbl, out);

                self.start_block(&hit_lbl, out);
                if self.type_needs_drop(&def_ty) && self.claim_stmt_temp(&def_val) {
                    self.emit_drop_value(&def_ty, &def_val, out);
                }
                let loaded = self.emit_load_dict_val_at(v_ty, d_val, &didx, out);
                let hv = if ret_ty == Type::Any && *v_ty != Type::Any {
                    self.emit_box_any_owned(v_ty, &loaded, span, out)?
                } else if self.type_needs_drop(&ret_ty) {
                    self.emit_clone_value(&ret_ty, &loaded, out)
                } else {
                    loaded
                };
                self.emit_br(&hit_end, out);
                self.start_block(&hit_end, out);
                self.emit_br(&merge_lbl, out);

                self.start_block(&miss_lbl, out);
                let mv = if ret_ty == Type::Any && def_ty != Type::Any {
                    self.emit_box_any_owned(&def_ty, &def_val, args[1].span, out)?
                } else if self.type_needs_drop(&ret_ty) {
                    if self.claim_stmt_temp(&def_val) {
                        def_val
                    } else {
                        self.emit_clone_value(&ret_ty, &def_val, out)
                    }
                } else {
                    def_val
                };
                self.emit_br(&miss_end, out);
                self.start_block(&miss_end, out);
                self.emit_br(&merge_lbl, out);

                self.start_block(&merge_lbl, out);
                let phi = self.next_tmp();
                let r_ir = ir_type(&ret_ty);
                let _ = writeln!(
                    out,
                    "  {phi} = phi {r_ir} [ {hv}, %{hit_end} ], [ {mv}, %{miss_end} ]"
                );
                if self.type_needs_drop(&ret_ty) {
                    self.stmt_temps.push(TempDrop {
                        val: phi.clone(),
                        ty: ret_ty.clone(),
                    });
                }
                Ok((ret_ty, phi))
            }

            "pop" => {
                if args.is_empty() || args.len() > 2 {
                    return Err(Diagnostic::new(
                        format!("`dict.pop` expects 1 or 2 arguments, found {}", args.len()),
                        span,
                    ));
                }
                let fam = Self::dict_family_suffix(k_ty);
                let (kir, kval) = self.eval_key_for_dict(k_ty, &args[0], out)?;
                let pair = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {pair} = call fastcc {{ i64, i64 }} @archx_dict_find_{fam}(i64 {d_val}, {kir} {kval})"
                );
                let didx = self.next_tmp();
                let _ = writeln!(out, "  {didx} = extractvalue {{ i64, i64 }} {pair}, 0");
                let sp_slot = self.next_tmp();
                let _ = writeln!(out, "  {sp_slot} = extractvalue {{ i64, i64 }} {pair}, 1");
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp sge i64 {didx}, 0");

                if args.len() == 1 {
                    self.used_key_fail = true;
                    let hit_lbl = self.fresh_label("dpop.hit");
                    let miss_lbl = self.fresh_label("dpop.miss");
                    self.emit_cond_br(&ok, &hit_lbl, &miss_lbl, out);
                    self.start_block(&miss_lbl, out);
                    let _ = writeln!(out, "  call void @archx_key_fail()");
                    let _ = writeln!(out, "  unreachable");
                    self.start_block(&hit_lbl, out);
                    let popped_v = self.emit_pop_dict_entry_at(k_ty, v_ty, d_val, &didx, &sp_slot, out);
                    if self.type_needs_drop(v_ty) {
                        self.stmt_temps.push(TempDrop {
                            val: popped_v.clone(),
                            ty: v_ty.clone(),
                        });
                    }
                    return Ok((v_ty.clone(), popped_v));
                }

                let def_owned = self.eval_owned_for_slot(v_ty, &args[1], out)?;
                let hit_lbl = self.fresh_label("dpop2.hit");
                let hit_end = self.fresh_label("dpop2.hit.end");
                let miss_lbl = self.fresh_label("dpop2.miss");
                let merge_lbl = self.fresh_label("dpop2.merge");
                self.emit_cond_br(&ok, &hit_lbl, &miss_lbl, out);

                self.start_block(&hit_lbl, out);
                self.emit_drop_value(v_ty, &def_owned, out);
                let popped_v = self.emit_pop_dict_entry_at(k_ty, v_ty, d_val, &didx, &sp_slot, out);
                self.emit_br(&hit_end, out);
                self.start_block(&hit_end, out);
                self.emit_br(&merge_lbl, out);

                self.start_block(&miss_lbl, out);
                self.emit_br(&merge_lbl, out);

                self.start_block(&merge_lbl, out);
                let phi = self.next_tmp();
                let vir = ir_type(v_ty);
                let _ = writeln!(
                    out,
                    "  {phi} = phi {vir} [ {popped_v}, %{hit_end} ], [ {def_owned}, %{miss_lbl} ]"
                );
                if self.type_needs_drop(v_ty) {
                    self.stmt_temps.push(TempDrop {
                        val: phi.clone(),
                        ty: v_ty.clone(),
                    });
                }
                Ok((v_ty.clone(), phi))
            }

            "keys" => {
                if !args.is_empty() {
                    return Err(Diagnostic::new(
                        format!("`dict.keys` expects 0 arguments, found {}", args.len()),
                        span,
                    ));
                }
                self.emit_extract_dict_plane(k_ty, d_val, true, out)
            }

            "values" => {
                if !args.is_empty() {
                    return Err(Diagnostic::new(
                        format!("`dict.values` expects 0 arguments, found {}", args.len()),
                        span,
                    ));
                }
                self.emit_extract_dict_plane(v_ty, d_val, false, out)
            }

            "clear" => {
                if !args.is_empty() {
                    return Err(Diagnostic::new(
                        format!("`dict.clear` expects 0 arguments, found {}", args.len()),
                        span,
                    ));
                }
                self.emit_clear_dict_or_set(k_ty, Some(v_ty), d_val, out);
                Ok((Type::Void, String::new()))
            }

            _ => Err(Diagnostic::new(
                format!(
                    "`{}` has no method `{method}` (supported: `get`, `pop`, `keys`, `values`, `clear`)",
                    Type::Dict(Box::new(k_ty.clone()), Box::new(v_ty.clone())).name()
                ),
                span,
            )),
        }
    }

    pub(super) fn gen_set_method(
        &mut self,
        elem_ty: &Type,
        s_val: &str,
        method: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.used_dict_rt = true;
        let fam = Self::dict_family_suffix(elem_ty);
        match method {
            "add" => {
                if args.len() != 1 {
                    return Err(Diagnostic::new(
                        format!("`set.add` expects 1 argument, found {}", args.len()),
                        span,
                    ));
                }
                let (kir, kval) = self.eval_key_for_dict(elem_ty, &args[0], out)?;
                let up = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {up} = call fastcc {{ i64, i1 }} @archx_dict_upsert_{fam}(i64 {s_val}, {kir} {kval})"
                );
                Ok((Type::Void, String::new()))
            }
            "remove" | "discard" => {
                if args.len() != 1 {
                    return Err(Diagnostic::new(
                        format!("`set.{method}` expects 1 argument, found {}", args.len()),
                        span,
                    ));
                }
                let (kir, kval) = self.eval_key_for_dict(elem_ty, &args[0], out)?;
                let pair = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {pair} = call fastcc {{ i64, i64 }} @archx_dict_find_{fam}(i64 {s_val}, {kir} {kval})"
                );
                let didx = self.next_tmp();
                let _ = writeln!(out, "  {didx} = extractvalue {{ i64, i64 }} {pair}, 0");
                let sp_slot = self.next_tmp();
                let _ = writeln!(out, "  {sp_slot} = extractvalue {{ i64, i64 }} {pair}, 1");
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp sge i64 {didx}, 0");
                let hit_lbl = self.fresh_label("srem.hit");
                let miss_lbl = self.fresh_label("srem.miss");
                let done_lbl = self.fresh_label("srem.done");
                self.emit_cond_br(&ok, &hit_lbl, &miss_lbl, out);

                self.start_block(&miss_lbl, out);
                if method == "remove" {
                    self.used_key_fail = true;
                    let _ = writeln!(out, "  call void @archx_key_fail()");
                    let _ = writeln!(out, "  unreachable");
                } else {
                    self.emit_br(&done_lbl, out);
                }

                self.start_block(&hit_lbl, out);
                let raw = self.next_tmp();
                let _ = writeln!(out, "  {raw} = and i64 {s_val}, -4");
                let hdr = self.next_tmp();
                let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
                if self.type_needs_drop(elem_ty) {
                    let kg = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {kg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 5"
                    );
                    let kp = self.next_tmp();
                    let _ = writeln!(out, "  {kp} = load ptr, ptr {kg}, align 8");
                    let kstore = Self::dict_key_storage_ir(elem_ty);
                    let kep = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {kep} = getelementptr inbounds {kstore}, ptr {kp}, i64 {didx}"
                    );
                    let old_k = self.emit_load_dict_key(elem_ty, &kep, out);
                    self.emit_drop_value(elem_ty, &old_k, out);
                }
                let _ = writeln!(
                    out,
                    "  call fastcc void @archx_dict_erase_slot(ptr {hdr}, i64 {sp_slot})"
                );
                self.emit_br(&done_lbl, out);
                self.start_block(&done_lbl, out);
                Ok((Type::Void, String::new()))
            }
            "clear" => {
                if !args.is_empty() {
                    return Err(Diagnostic::new(
                        format!("`set.clear` expects 0 arguments, found {}", args.len()),
                        span,
                    ));
                }
                self.emit_clear_dict_or_set(elem_ty, None, s_val, out);
                Ok((Type::Void, String::new()))
            }
            _ => Err(Diagnostic::new(
                format!(
                    "`{}` has no method `{method}` (supported: `add`, `remove`, `discard`, `clear`)",
                    Type::Set(Box::new(elem_ty.clone())).name()
                ),
                span,
            )),
        }
    }

    fn emit_load_dict_val_at(
        &mut self,
        v_ty: &Type,
        d_val: &str,
        didx: &str,
        out: &mut String,
    ) -> String {
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
        let hdr = self.next_tmp();
        let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
        let vg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 6"
        );
        let vptr = self.next_tmp();
        let _ = writeln!(out, "  {vptr} = load ptr, ptr {vg}, align 8");
        let vmem = elem_mem_ir_type(v_ty);
        let vep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vep} = getelementptr inbounds {vmem}, ptr {vptr}, i64 {didx}"
        );
        self.emit_elem_load(v_ty, &vep, out)
    }

    fn emit_pop_dict_entry_at(
        &mut self,
        k_ty: &Type,
        v_ty: &Type,
        d_val: &str,
        didx: &str,
        sp_slot: &str,
        out: &mut String,
    ) -> String {
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
        let hdr = self.next_tmp();
        let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
        if self.type_needs_drop(k_ty) {
            let kg = self.next_tmp();
            let _ = writeln!(
                out,
                "  {kg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 5"
            );
            let kp = self.next_tmp();
            let _ = writeln!(out, "  {kp} = load ptr, ptr {kg}, align 8");
            let kstore = Self::dict_key_storage_ir(k_ty);
            let kep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {kep} = getelementptr inbounds {kstore}, ptr {kp}, i64 {didx}"
            );
            let old_k = self.emit_load_dict_key(k_ty, &kep, out);
            self.emit_drop_value(k_ty, &old_k, out);
        }
        let popped_v = self.emit_load_dict_val_at(v_ty, d_val, didx, out);
        let _ = writeln!(
            out,
            "  call fastcc void @archx_dict_erase_slot(ptr {hdr}, i64 {sp_slot})"
        );
        popped_v
    }

    fn emit_extract_dict_plane(
        &mut self,
        elem_ty: &Type,
        d_val: &str,
        is_keys: bool,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.used_vec_type = true;
        self.mark_runtime_type(elem_ty);
        let len = self.emit_dict_len(d_val, out);
        let esz = self.emit_elem_sizeof(elem_ty, out);
        let bytes = self.emit_elem_bytes_val_mul(&len, &esz, out);
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

        let non_empty = self.next_tmp();
        let _ = writeln!(out, "  {non_empty} = icmp sgt i64 {len}, 0");
        let copy_lbl = self.fresh_label("dplane.copy");
        let cond_lbl = self.fresh_label("dplane.cond");
        let body_lbl = self.fresh_label("dplane.body");
        let done_lbl = self.fresh_label("dplane.done");
        self.emit_cond_br(&non_empty, &copy_lbl, &done_lbl, out);

        let i_slot = self.next_slot("dplane.i");
        let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
        let src_slot = self.next_slot("dplane.src");
        let _ = writeln!(self.allocas, "  {src_slot} = alloca ptr, align 8");

        self.start_block(&copy_lbl, out);
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
        let hdr = self.next_tmp();
        let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
        let field_idx = if is_keys { 5 } else { 6 };
        let pg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {pg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 {field_idx}"
        );
        let sptr = self.next_tmp();
        let _ = writeln!(out, "  {sptr} = load ptr, ptr {pg}, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
        let _ = writeln!(out, "  store ptr {sptr}, ptr {src_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&cond_lbl, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len}");
        self.emit_cond_br(&more, &body_lbl, &done_lbl, out);

        self.start_block(&body_lbl, out);
        let sp_base = self.next_tmp();
        let _ = writeln!(out, "  {sp_base} = load ptr, ptr {src_slot}, align 8");
        let ev = if is_keys {
            let kstore = Self::dict_key_storage_ir(elem_ty);
            let kp = self.next_tmp();
            let _ = writeln!(
                out,
                "  {kp} = getelementptr inbounds {kstore}, ptr {sp_base}, i64 {i}"
            );
            self.emit_load_dict_key(elem_ty, &kp, out)
        } else {
            let vmem = elem_mem_ir_type(elem_ty);
            let vp = self.next_tmp();
            let _ = writeln!(
                out,
                "  {vp} = getelementptr inbounds {vmem}, ptr {sp_base}, i64 {i}"
            );
            self.emit_elem_load(elem_ty, &vp, out)
        };
        let cloned = if self.type_needs_drop(elem_ty) {
            self.emit_clone_value(elem_ty, &ev, out)
        } else {
            ev
        };
        let dmem = elem_mem_ir_type(elem_ty);
        let dp = self.next_tmp();
        let _ = writeln!(
            out,
            "  {dp} = getelementptr inbounds {dmem}, ptr {dst_data}, i64 {i}"
        );
        self.emit_elem_store(elem_ty, &cloned, &dp, out);
        let inext = self.next_tmp();
        let _ = writeln!(out, "  {inext} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {inext}, ptr {i_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&done_lbl, out);
        let vec = self.build_vec_val(&len, &cap_val, &dst_data, out);
        let res_ty = Type::Array(Box::new(elem_ty.clone()));
        self.stmt_temps.push(TempDrop {
            val: vec.clone(),
            ty: res_ty.clone(),
        });
        Ok((res_ty, vec))
    }

    fn emit_clear_dict_or_set(
        &mut self,
        k_ty: &Type,
        v_ty: Option<&Type>,
        d_val: &str,
        out: &mut String,
    ) {
        self.used_memset = true;
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
        let nz = self.next_tmp();
        let _ = writeln!(out, "  {nz} = icmp ne i64 {raw}, 0");
        let init_lbl = self.fresh_label("dclr.init");
        let cond_lbl = self.fresh_label("dclr.cond");
        let body_lbl = self.fresh_label("dclr.body");
        let reset_lbl = self.fresh_label("dclr.reset");
        let done_lbl = self.fresh_label("dclr.done");
        self.emit_cond_br(&nz, &init_lbl, &done_lbl, out);

        let i_slot = self.next_slot("dclr.i");
        let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");

        self.start_block(&init_lbl, out);
        let hdr = self.next_tmp();
        let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = load i64, ptr {hdr}, align 8");
        let kg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {kg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 5"
        );
        let kp = self.next_tmp();
        let _ = writeln!(out, "  {kp} = load ptr, ptr {kg}, align 8");
        let vg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 6"
        );
        let vp = self.next_tmp();
        let _ = writeln!(out, "  {vp} = load ptr, ptr {vg}, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
        if self.type_needs_drop(k_ty) || v_ty.map_or(false, |vt| self.type_needs_drop(vt)) {
            self.emit_br(&cond_lbl, out);
            self.start_block(&cond_lbl, out);
            let i = self.next_tmp();
            let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
            let more = self.next_tmp();
            let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len}");
            self.emit_cond_br(&more, &body_lbl, &reset_lbl, out);

            self.start_block(&body_lbl, out);
            if self.type_needs_drop(k_ty) {
                let kstore = Self::dict_key_storage_ir(k_ty);
                let kep = self.next_tmp();
                let _ = writeln!(out, "  {kep} = getelementptr inbounds {kstore}, ptr {kp}, i64 {i}");
                let kv = self.emit_load_dict_key(k_ty, &kep, out);
                self.emit_drop_value(k_ty, &kv, out);
            }
            if let Some(vt) = v_ty {
                if self.type_needs_drop(vt) {
                    let vmem = elem_mem_ir_type(vt);
                    let vep = self.next_tmp();
                    let _ = writeln!(out, "  {vep} = getelementptr inbounds {vmem}, ptr {vp}, i64 {i}");
                    let vv = self.emit_elem_load(vt, &vep, out);
                    self.emit_drop_value(vt, &vv, out);
                }
            }
            let inext = self.next_tmp();
            let _ = writeln!(out, "  {inext} = add nuw nsw i64 {i}, 1");
            let _ = writeln!(out, "  store i64 {inext}, ptr {i_slot}, align 8");
            self.emit_br(&cond_lbl, out);
        } else {
            self.emit_br(&reset_lbl, out);
        }

        self.start_block(&reset_lbl, out);
        let _ = writeln!(out, "  store i64 0, ptr {hdr}, align 8");
        let ug = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ug} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 1"
        );
        let _ = writeln!(out, "  store i64 0, ptr {ug}, align 8");
        let cg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {cg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 4"
        );
        let ctrl = self.next_tmp();
        let _ = writeln!(out, "  {ctrl} = load ptr, ptr {cg}, align 8");
        let has_c = self.next_tmp();
        let _ = writeln!(out, "  {has_c} = icmp ne ptr {ctrl}, null");
        let mset_lbl = self.fresh_label("dclr.mset");
        self.emit_cond_br(&has_c, &mset_lbl, &done_lbl, out);
        self.start_block(&mset_lbl, out);
        let mg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {mg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 2"
        );
        let mask = self.next_tmp();
        let _ = writeln!(out, "  {mask} = load i64, ptr {mg}, align 8");
        let clen = self.next_tmp();
        let _ = writeln!(out, "  {clen} = add i64 {mask}, 17");
        let _ = writeln!(
            out,
            "  call void @llvm.memset.p0.i64(ptr nonnull align 1 {ctrl}, i8 -128, i64 {clen}, i1 false)"
        );
        self.emit_br(&done_lbl, out);
        self.start_block(&done_lbl, out);
    }

    // ---------------- Pythonic Slicing (`xs[a:b:step]`, `s[a:b:step]`) -------

    pub(super) fn eval_slice_expr(
        &mut self,
        target: &Expr,
        start: Option<&Expr>,
        stop: Option<&Expr>,
        step: Option<&Expr>,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.used_slice_rt = true;
        let (tty, tval) = self.eval_expr(target, out)?;

        let (start_val, has_start) = if let Some(se) = start {
            let v = self.eval_slice_bound_int(se, out)?;
            (v, "true")
        } else {
            ("0".to_string(), "false")
        };
        let (stop_val, has_stop) = if let Some(ee) = stop {
            let v = self.eval_slice_bound_int(ee, out)?;
            (v, "true")
        } else {
            ("0".to_string(), "false")
        };
        let step_val = if let Some(ste) = step {
            self.eval_slice_bound_int(ste, out)?
        } else {
            "1".to_string()
        };

        match tty {
            Type::Str => {
                self.used_str_type = true;
                let rarg = self.active_region_arg();
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxStr @archx_str_slice(%ArchxStr {tval}, i64 {start_val}, i1 {has_start}, i64 {stop_val}, i1 {has_stop}, i64 {step_val}, ptr {rarg})"
                );
                self.stmt_temps.push(TempDrop {
                    val: res.clone(),
                    ty: Type::Str,
                });
                Ok((Type::Str, res))
            }
            Type::Array(elem_ty) => {
                let res_vec = self.emit_vec_slice(
                    &elem_ty,
                    &tval,
                    &start_val,
                    has_start,
                    &stop_val,
                    has_stop,
                    &step_val,
                    out,
                );
                let res_ty = Type::Array(elem_ty);
                self.stmt_temps.push(TempDrop {
                    val: res_vec.clone(),
                    ty: res_ty.clone(),
                });
                Ok((res_ty, res_vec))
            }
            Type::Any => {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let tag = self.next_tmp();
                let _ = writeln!(out, "  {tag} = extractvalue %ArchxAny {tval}, 0");
                let w1 = self.next_tmp();
                let _ = writeln!(out, "  {w1} = extractvalue %ArchxAny {tval}, 1");
                let w2 = self.next_tmp();
                let _ = writeln!(out, "  {w2} = extractvalue %ArchxAny {tval}, 2");
                let is_s = self.next_tmp();
                let _ = writeln!(out, "  {is_s} = icmp eq i64 {tag}, 4");
                let is_l = self.next_tmp();
                let _ = writeln!(out, "  {is_l} = icmp eq i64 {tag}, 5");
                let s_lbl = self.fresh_label("aslice.str");
                let s_end = self.fresh_label("aslice.str.end");
                let chk_l = self.fresh_label("aslice.chkl");
                let l_lbl = self.fresh_label("aslice.list");
                let l_end = self.fresh_label("aslice.list.end");
                let bad_lbl = self.fresh_label("aslice.bad");
                let merge_lbl = self.fresh_label("aslice.merge");

                self.emit_cond_br(&is_s, &s_lbl, &chk_l, out);
                self.start_block(&s_lbl, out);
                let ss0 = self.next_tmp();
                let _ = writeln!(out, "  {ss0} = insertvalue %ArchxStr poison, i64 {w1}, 0");
                let ss1 = self.next_tmp();
                let _ = writeln!(out, "  {ss1} = insertvalue %ArchxStr {ss0}, i64 {w2}, 1");
                let rarg = self.active_region_arg();
                let sr = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {sr} = call fastcc %ArchxStr @archx_str_slice(%ArchxStr {ss1}, i64 {start_val}, i1 {has_start}, i64 {stop_val}, i1 {has_stop}, i64 {step_val}, ptr {rarg})"
                );
                let sr0 = self.next_tmp();
                let _ = writeln!(out, "  {sr0} = extractvalue %ArchxStr {sr}, 0");
                let sr1 = self.next_tmp();
                let _ = writeln!(out, "  {sr1} = extractvalue %ArchxStr {sr}, 1");
                let as0 = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {as0} = insertvalue %ArchxAny {{ i64 4, i64 0, i64 0 }}, i64 {sr0}, 1"
                );
                let as1 = self.next_tmp();
                let _ = writeln!(out, "  {as1} = insertvalue %ArchxAny {as0}, i64 {sr1}, 2");
                self.emit_br(&s_end, out);
                self.start_block(&s_end, out);
                self.emit_br(&merge_lbl, out);

                self.start_block(&chk_l, out);
                self.emit_cond_br(&is_l, &l_lbl, &bad_lbl, out);
                self.start_block(&bad_lbl, out);
                let sym = self.strings.intern("dynamic value does not support slicing");
                let _ = writeln!(out, "  call void @archx_type_fail(ptr {sym})");
                let _ = writeln!(out, "  unreachable");

                self.start_block(&l_lbl, out);
                let lraw = self.next_tmp();
                let _ = writeln!(out, "  {lraw} = and i64 {w1}, -4");
                let lp = self.next_tmp();
                let _ = writeln!(out, "  {lp} = inttoptr i64 {lraw} to ptr");
                let lvec = self.next_tmp();
                let _ = writeln!(out, "  {lvec} = load %ArchxVec, ptr {lp}, align 8");
                let sliced_v = self.emit_vec_slice(
                    &Type::Any,
                    &lvec,
                    &start_val,
                    has_start,
                    &stop_val,
                    has_stop,
                    &step_val,
                    out,
                );
                let al = self.emit_wrap_any_vec_cell(&sliced_v, out);
                self.emit_br(&l_end, out);
                self.start_block(&l_end, out);
                self.emit_br(&merge_lbl, out);

                self.start_block(&merge_lbl, out);
                let phi = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {phi} = phi %ArchxAny [ {as1}, %{s_end} ], [ {al}, %{l_end} ]"
                );
                self.stmt_temps.push(TempDrop {
                    val: phi.clone(),
                    ty: Type::Any,
                });
                Ok((Type::Any, phi))
            }
            _ => Err(Diagnostic::new(
                format!("cannot slice value of type `{}`", tty.name()),
                span,
            )),
        }
    }

    fn eval_slice_bound_int(&mut self, expr: &Expr, out: &mut String) -> Result<String> {
        let (ty, val) = self.eval_expr(expr, out)?;
        match ty {
            Type::Int => Ok(val),
            Type::Any => self.emit_unbox_any(&Type::Int, &val, expr.span, out),
            _ => Err(Diagnostic::new(
                format!("slice index must be `int`, found `{}`", ty.name()),
                expr.span,
            )),
        }
    }

    #[allow(clippy::too_many_arguments)]
    fn emit_vec_slice(
        &mut self,
        elem_ty: &Type,
        vec_val: &str,
        start_val: &str,
        has_start: &str,
        stop_val: &str,
        has_stop: &str,
        step_val: &str,
        out: &mut String,
    ) -> String {
        self.used_vec_type = true;
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec_val}, 0");
        let src_data = self.next_tmp();
        let _ = writeln!(out, "  {src_data} = extractvalue %ArchxVec {vec_val}, 2");

        let bnds = self.next_tmp();
        let _ = writeln!(
            out,
            "  {bnds} = call fastcc {{ i64, i64 }} @archx_slice_bounds(i64 {len}, i64 {start_val}, i1 {has_start}, i64 {stop_val}, i1 {has_stop}, i64 {step_val})"
        );
        let s_idx = self.next_tmp();
        let _ = writeln!(out, "  {s_idx} = extractvalue {{ i64, i64 }} {bnds}, 0");
        let cnt = self.next_tmp();
        let _ = writeln!(out, "  {cnt} = extractvalue {{ i64, i64 }} {bnds}, 1");

        let esz = self.emit_elem_sizeof(elem_ty, out);
        let bytes = self.emit_elem_bytes_val_mul(&cnt, &esz, out);
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
            let _ = writeln!(out, "  {z} = icmp eq i64 {cnt}, 0");
            let c = self.next_tmp();
            let _ = writeln!(out, "  {c} = select i1 {z}, i64 1, i64 {cnt}");
            (p, c)
        };

        let non_empty = self.next_tmp();
        let _ = writeln!(out, "  {non_empty} = icmp sgt i64 {cnt}, 0");
        let copy_lbl = self.fresh_label("vslice.copy");
        let done_lbl = self.fresh_label("vslice.done");
        self.emit_cond_br(&non_empty, &copy_lbl, &done_lbl, out);

        self.start_block(&copy_lbl, out);
        let mem_ty = elem_mem_ir_type(elem_ty);

        // Fast contiguous POD `memcpy` when `step == 1` and `!type_needs_drop`:
        if step_val == "1" && !self.type_needs_drop(elem_ty) {
            self.used_memcpy = true;
            let sp = self.next_tmp();
            let _ = writeln!(
                out,
                "  {sp} = getelementptr inbounds {mem_ty}, ptr {src_data}, i64 {s_idx}"
            );
            let _ = writeln!(
                out,
                "  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 {dst_data}, ptr nonnull align 1 {sp}, i64 {bytes}, i1 false)"
            );
            self.emit_br(&done_lbl, out);
        } else {
            let i_slot = self.next_slot("vslice.i");
            let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
            let cur_slot = self.next_slot("vslice.cur");
            let _ = writeln!(self.allocas, "  {cur_slot} = alloca i64, align 8");
            let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
            let _ = writeln!(out, "  store i64 {s_idx}, ptr {cur_slot}, align 8");
            let cond_lbl = self.fresh_label("vslice.cond");
            let body_lbl = self.fresh_label("vslice.body");
            self.emit_br(&cond_lbl, out);

            self.start_block(&cond_lbl, out);
            let i = self.next_tmp();
            let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
            let more = self.next_tmp();
            let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {cnt}");
            self.emit_cond_br(&more, &body_lbl, &done_lbl, out);

            self.start_block(&body_lbl, out);
            let cur = self.next_tmp();
            let _ = writeln!(out, "  {cur} = load i64, ptr {cur_slot}, align 8");
            let sp = self.next_tmp();
            let _ = writeln!(
                out,
                "  {sp} = getelementptr inbounds {mem_ty}, ptr {src_data}, i64 {cur}"
            );
            let ev = self.emit_elem_load(elem_ty, &sp, out);
            let cloned = if self.type_needs_drop(elem_ty) {
                self.emit_clone_value(elem_ty, &ev, out)
            } else {
                ev
            };
            let dp = self.next_tmp();
            let _ = writeln!(
                out,
                "  {dp} = getelementptr inbounds {mem_ty}, ptr {dst_data}, i64 {i}"
            );
            self.emit_elem_store(elem_ty, &cloned, &dp, out);
            let inext = self.next_tmp();
            let _ = writeln!(out, "  {inext} = add nuw nsw i64 {i}, 1");
            let curnext = self.next_tmp();
            let _ = writeln!(out, "  {curnext} = add i64 {cur}, {step_val}");
            let _ = writeln!(out, "  store i64 {inext}, ptr {i_slot}, align 8");
            let _ = writeln!(out, "  store i64 {curnext}, ptr {cur_slot}, align 8");
            self.emit_br(&cond_lbl, out);
        }

        self.start_block(&done_lbl, out);
        self.build_vec_val(&cnt, &cap_val, &dst_data, out)
    }
}
