//! LLVM IR runtime helpers for Milestone 7 (`v0.7.0`):
//! - Pythonic slice bounds normalization (`@archx_slice_bounds`) & SSO/heap string slicing (`@archx_str_slice`)
//! - Planar SIMD SwissTable (`%ArchxDictHdr`, `<16 x i8>` group probing, zero-tombstone dense arrays)
//! - Adaptive dynamic value engine (`%ArchxAny` 24B tagged value, zero GC, deterministic RAII)

use super::*;

impl Codegen {
    pub(super) fn finalize_hash_any_runtime_flags(&mut self) {
        if self.used_any_rt {
            self.mark_runtime_type(&Type::Any);
            self.used_dict_rt = true;
            self.used_slice_rt = true;
            self.used_key_fail = true;
            self.used_type_fail = true;
            self.used_bounds_fail = true;
            self.used_pop_empty_fail = true;
            self.used_div_zero_fail = true;
            self.used_neg_exp_fail = true;
            self.used_zero_step_fail = true;
            self.used_str_eq = true;
            self.used_str_drop = true;
            self.used_str_clone = true;
            self.used_str_promote = true;
            self.used_str_print = true;
            self.used_str_concat = true;
            self.used_str_repeat = true;
            self.used_str_find = true;
            self.used_str_byte_at = true;
            self.used_str_from_int = true;
            self.used_str_from_float = true;
            self.used_print_float = true;
            self.used_print_inline = true;
            self.used_array_print = true;
            self.used_pow_f64 = true;
            self.used_floor_f64 = true;
            self.used_fptosi_sat = true;
            self.used_malloc = true;
            self.used_calloc = true;
            self.used_realloc = true;
            self.used_free = true;
            self.used_memset = true;
            self.used_memcpy = true;
            self.used_oom_fail = true;

            let _ = self.ensure_vec_drop_helper(&Type::Any);
            let _ = self.ensure_vec_clone_helper(&Type::Any);
            let _ = self.ensure_dict_drop_helper(&Type::Any, Some(&Type::Any));
            let _ = self.ensure_dict_clone_helper(&Type::Any, Some(&Type::Any));
            let _ = self.ensure_dict_drop_helper(&Type::Any, None);
            let _ = self.ensure_dict_clone_helper(&Type::Any, None);
        }

        if self.used_slice_rt {
            self.used_zero_step_fail = true;
            self.used_malloc = true;
            self.used_free = true;
            self.used_memcpy = true;
            self.used_oom_fail = true;
        }

        if self.used_dict_rt {
            self.used_dict_type = true;
            self.used_str_type = true;
            self.used_str_eq = true;
            self.used_str_clone = true;
            self.used_malloc = true;
            self.used_calloc = true;
            self.used_realloc = true;
            self.used_free = true;
            self.used_memset = true;
            self.used_memcpy = true;
            self.used_oom_fail = true;
        }
    }

    pub(super) fn emit_hash_any_runtime_helpers(&self, out: &mut String) {
        if self.used_key_fail {
            emit_cstr_global(
                out,
                "@.err.key",
                "archx runtime panic: KeyError: key not found in dict/set\n",
            );
            out.push_str(
                r#"
define private void @archx_key_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.key)
  call void @exit(i32 101)
  unreachable
}
"#,
            );
        }

        if self.used_type_fail {
            emit_cstr_global(
                out,
                "@.err.type",
                "archx runtime panic: TypeError: %s\n",
            );
            out.push_str(
                r#"
define private void @archx_type_fail(ptr %msg) cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.type, ptr %msg)
  call void @exit(i32 101)
  unreachable
}
"#,
            );
        }

        if self.used_slice_rt {
            self.emit_slice_runtime(out);
        }

        if self.used_dict_rt {
            self.emit_dict_runtime(out);
        }

        if self.used_any_rt || self.used_array_print {
            emit_cstr_global(out, "@.fmt.lbrace", "{");
            emit_cstr_global(out, "@.fmt.rbrace", "}");
            emit_cstr_global(out, "@.fmt.colon", ": ");
            emit_cstr_global(out, "@.fmt.nl", "\n");
        }

        if self.used_any_rt {
            self.emit_any_runtime(out);
        }

        if self.used_dict_rt {
            out.push_str(
                "declare i32 @llvm.cttz.i32(i32, i1 immarg) nounwind readnone speculatable\n",
            );
        }
    }

    fn emit_slice_runtime(&self, out: &mut String) {
        out.push_str(
            r#"
define private fastcc { i64, i64 } @archx_slice_bounds(i64 %len, i64 %start, i1 %has_start, i64 %stop, i1 %has_stop, i64 %step) {
entry:
  %z = icmp eq i64 %step, 0
  br i1 %z, label %zero_step, label %chk_dir
zero_step:
  call void @archx_zero_step_fail()
  unreachable
chk_dir:
  %pos = icmp sgt i64 %step, 0
  br i1 %pos, label %pos_step, label %neg_step

pos_step:
  br i1 %has_start, label %ps_has, label %ps_def
ps_def:
  br label %ps_done
ps_has:
  %ps_neg = icmp slt i64 %start, 0
  %ps_adj = add i64 %start, %len
  %ps_s0 = select i1 %ps_neg, i64 %ps_adj, i64 %start
  %ps_lt0 = icmp slt i64 %ps_s0, 0
  %ps_s1 = select i1 %ps_lt0, i64 0, i64 %ps_s0
  %ps_gtl = icmp sgt i64 %ps_s1, %len
  %ps_s2 = select i1 %ps_gtl, i64 %len, i64 %ps_s1
  br label %ps_done
ps_done:
  %s_pos = phi i64 [ 0, %ps_def ], [ %ps_s2, %ps_has ]
  br i1 %has_stop, label %pe_has, label %pe_def
pe_def:
  br label %pe_done
pe_has:
  %pe_neg = icmp slt i64 %stop, 0
  %pe_adj = add i64 %stop, %len
  %pe_e0 = select i1 %pe_neg, i64 %pe_adj, i64 %stop
  %pe_lt0 = icmp slt i64 %pe_e0, 0
  %pe_e1 = select i1 %pe_lt0, i64 0, i64 %pe_e0
  %pe_gtl = icmp sgt i64 %pe_e1, %len
  %pe_e2 = select i1 %pe_gtl, i64 %len, i64 %pe_e1
  br label %pe_done
pe_done:
  %e_pos = phi i64 [ %len, %pe_def ], [ %pe_e2, %pe_has ]
  %p_has_cnt = icmp sgt i64 %e_pos, %s_pos
  br i1 %p_has_cnt, label %p_calc, label %p_empty
p_calc:
  %p_diff = sub i64 %e_pos, %s_pos
  %p_dm1 = sub i64 %p_diff, 1
  %p_div = sdiv i64 %p_dm1, %step
  %p_cnt = add i64 %p_div, 1
  br label %finish
p_empty:
  br label %finish

neg_step:
  %len_m1 = sub i64 %len, 1
  br i1 %has_start, label %ns_has, label %ns_def
ns_def:
  br label %ns_done
ns_has:
  %ns_neg = icmp slt i64 %start, 0
  %ns_adj = add i64 %start, %len
  %ns_s0 = select i1 %ns_neg, i64 %ns_adj, i64 %start
  %ns_lt0 = icmp slt i64 %ns_s0, 0
  %ns_s1 = select i1 %ns_lt0, i64 -1, i64 %ns_s0
  %ns_gel = icmp sge i64 %ns_s1, %len
  %ns_s2 = select i1 %ns_gel, i64 %len_m1, i64 %ns_s1
  br label %ns_done
ns_done:
  %s_neg = phi i64 [ %len_m1, %ns_def ], [ %ns_s2, %ns_has ]
  br i1 %has_stop, label %ne_has, label %ne_def
ne_def:
  br label %ne_done
ne_has:
  %ne_neg = icmp slt i64 %stop, 0
  %ne_adj = add i64 %stop, %len
  %ne_e0 = select i1 %ne_neg, i64 %ne_adj, i64 %stop
  %ne_lt0 = icmp slt i64 %ne_e0, 0
  %ne_e1 = select i1 %ne_lt0, i64 -1, i64 %ne_e0
  %ne_gel = icmp sge i64 %ne_e1, %len
  %ne_e2 = select i1 %ne_gel, i64 %len_m1, i64 %ne_e1
  br label %ne_done
ne_done:
  %e_neg = phi i64 [ -1, %ne_def ], [ %ne_e2, %ne_has ]
  %n_has_cnt = icmp sgt i64 %s_neg, %e_neg
  br i1 %n_has_cnt, label %n_calc, label %n_empty
n_calc:
  %n_diff = sub i64 %s_neg, %e_neg
  %n_dm1 = sub i64 %n_diff, 1
  %abs_step = sub i64 0, %step
  %n_div = udiv i64 %n_dm1, %abs_step
  %n_cnt = add i64 %n_div, 1
  br label %finish
n_empty:
  br label %finish

finish:
  %out_s = phi i64 [ %s_pos, %p_calc ], [ 0, %p_empty ], [ %s_neg, %n_calc ], [ 0, %n_empty ]
  %out_c = phi i64 [ %p_cnt, %p_calc ], [ 0, %p_empty ], [ %n_cnt, %n_calc ], [ 0, %n_empty ]
  %r0 = insertvalue { i64, i64 } poison, i64 %out_s, 0
  %r1 = insertvalue { i64, i64 } %r0, i64 %out_c, 1
  ret { i64, i64 } %r1
}

define private fastcc %ArchxStr @archx_str_slice(%ArchxStr %s, i64 %start, i1 %has_start, i64 %stop, i1 %has_stop, i64 %step, ptr %reg) {
entry:
  %sso = alloca [16 x i8], align 8
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %bnds = call fastcc { i64, i64 } @archx_slice_bounds(i64 %len, i64 %start, i1 %has_start, i64 %stop, i1 %has_stop, i64 %step)
  %s_idx = extractvalue { i64, i64 } %bnds, 0
  %cnt = extractvalue { i64, i64 } %bnds, 1
  %empty = icmp sle i64 %cnt, 0
  br i1 %empty, label %ret_empty, label %get_ptr
ret_empty:
  ret %ArchxStr zeroinitializer
get_ptr:
  %is_sso = icmp ule i64 %len, 12
  br i1 %is_sso, label %from_sso, label %from_ptr
from_sso:
  store i64 %w0, ptr %sso, align 8
  %sso8 = getelementptr inbounds i8, ptr %sso, i64 8
  store i64 %w1, ptr %sso8, align 8
  %sso_p = getelementptr inbounds i8, ptr %sso, i64 4
  br label %have_ptr
from_ptr:
  %raw = and i64 %w1, -4
  %heap_p = inttoptr i64 %raw to ptr
  br label %have_ptr
have_ptr:
  %base = phi ptr [ %sso_p, %from_sso ], [ %heap_p, %from_ptr ]
  %unit = icmp eq i64 %step, 1
  br i1 %unit, label %contig, label %strided
contig:
  %sub_p = getelementptr inbounds i8, ptr %base, i64 %s_idx
  %res_c = call fastcc %ArchxStr @archx_str_from_slice(ptr %sub_p, i64 %cnt, ptr %reg)
  ret %ArchxStr %res_c
strided:
  %buf = call noalias ptr @malloc(i64 %cnt)
  %bnull = icmp eq ptr %buf, null
  br i1 %bnull, label %oom, label %sloop_pre
oom:
  call void @archx_oom_fail()
  unreachable
sloop_pre:
  br label %sloop
sloop:
  %i = phi i64 [ 0, %sloop_pre ], [ %inext, %sloop ]
  %cur = phi i64 [ %s_idx, %sloop_pre ], [ %curnext, %sloop ]
  %sp = getelementptr inbounds i8, ptr %base, i64 %cur
  %ch = load i8, ptr %sp, align 1
  %dp = getelementptr inbounds i8, ptr %buf, i64 %i
  store i8 %ch, ptr %dp, align 1
  %inext = add nuw nsw i64 %i, 1
  %curnext = add i64 %cur, %step
  %more = icmp slt i64 %inext, %cnt
  br i1 %more, label %sloop, label %sdone
sdone:
  %res_s = call fastcc %ArchxStr @archx_str_from_slice(ptr %buf, i64 %cnt, ptr %reg)
  call void @free(ptr %buf)
  ret %ArchxStr %res_s
}
"#,
        );
    }

    fn emit_dict_runtime(&self, out: &mut String) {
        out.push_str(
            r#"
define private fastcc i64 @archx_hash_i64(i64 %k) alwaysinline nounwind {
entry:
  %s1 = lshr i64 %k, 30
  %x1 = xor i64 %k, %s1
  %m1 = mul i64 %x1, -4658895280553007687
  %s2 = lshr i64 %m1, 27
  %x2 = xor i64 %m1, %s2
  %m2 = mul i64 %x2, -7723592293110705685
  %s3 = lshr i64 %m2, 31
  %x3 = xor i64 %m2, %s3
  ret i64 %x3
}

define private fastcc i64 @archx_hash_str(%ArchxStr %s) nounwind {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %short = icmp ule i64 %len, 12
  br i1 %short, label %sso_hash, label %long_hash
sso_hash:
  %p0_raw = lshr i64 %w0, 32
  %le4 = icmp ule i64 %len, 4
  br i1 %le4, label %sso_le4, label %sso_gt4
sso_le4:
  %sh0 = shl i64 %len, 3
  %m0_a = shl i64 1, %sh0
  %m0 = sub i64 %m0_a, 1
  %p0_4 = and i64 %p0_raw, %m0
  br label %sso_mix
sso_gt4:
  %eq12 = icmp eq i64 %len, 12
  br i1 %eq12, label %sso_12, label %sso_mid
sso_12:
  br label %sso_mix
sso_mid:
  %rem = sub i64 %len, 4
  %sh1 = shl i64 %rem, 3
  %m1_a = shl i64 1, %sh1
  %m1 = sub i64 %m1_a, 1
  %p1_m = and i64 %w1, %m1
  br label %sso_mix
sso_mix:
  %p0 = phi i64 [ %p0_4, %sso_le4 ], [ %p0_raw, %sso_12 ], [ %p0_raw, %sso_mid ]
  %p1 = phi i64 [ 0, %sso_le4 ], [ %w1, %sso_12 ], [ %p1_m, %sso_mid ]
  %a0 = mul i64 %p0, -7046029254386353131
  %a1 = mul i64 %p1, -4417276706812531889
  %ax = xor i64 %a0, %a1
  %al = xor i64 %ax, %len
  %res_sso = call fastcc i64 @archx_hash_i64(i64 %al)
  ret i64 %res_sso

long_hash:
  %raw = and i64 %w1, -4
  %ptr = inttoptr i64 %raw to ptr
  %seed = mul i64 %len, -7046029254386353131
  br label %l_cond
l_cond:
  %idx = phi i64 [ 0, %long_hash ], [ %idx_next, %l_body ]
  %acc = phi i64 [ %seed, %long_hash ], [ %acc_next, %l_body ]
  %rem_l = sub i64 %len, %idx
  %ge8 = icmp sge i64 %rem_l, 8
  br i1 %ge8, label %l_body, label %l_tail_cond
l_body:
  %lp = getelementptr inbounds i8, ptr %ptr, i64 %idx
  %lane = load i64, ptr %lp, align 1
  %lm = mul i64 %lane, -4417276706812531889
  %lx = xor i64 %acc, %lm
  %lr = call fastcc i64 @archx_hash_i64(i64 %lx)
  %acc_next = add i64 %lr, %idx
  %idx_next = add i64 %idx, 8
  br label %l_cond
l_tail_cond:
  %ti = phi i64 [ %idx, %l_cond ], [ %ti_next, %l_tail_body ]
  %tacc = phi i64 [ %acc, %l_cond ], [ %tacc_next, %l_tail_body ]
  %tmore = icmp slt i64 %ti, %len
  br i1 %tmore, label %l_tail_body, label %l_done
l_tail_body:
  %tp = getelementptr inbounds i8, ptr %ptr, i64 %ti
  %tb = load i8, ptr %tp, align 1
  %tz = zext i8 %tb to i64
  %tx = xor i64 %tacc, %tz
  %tacc_next = mul i64 %tx, 1099511628211
  %ti_next = add i64 %ti, 1
  br label %l_tail_cond
l_done:
  %res_l = call fastcc i64 @archx_hash_i64(i64 %tacc)
  ret i64 %res_l
}

define private fastcc void @archx_dict_set_ctrl(ptr %ctrl, i64 %scap, i64 %slot, i8 %val) alwaysinline nounwind {
entry:
  %p = getelementptr inbounds i8, ptr %ctrl, i64 %slot
  store i8 %val, ptr %p, align 1
  %mir = icmp ult i64 %slot, 16
  br i1 %mir, label %do_mir, label %done
do_mir:
  %moff = add i64 %scap, %slot
  %mp = getelementptr inbounds i8, ptr %ctrl, i64 %moff
  store i8 %val, ptr %mp, align 1
  br label %done
done:
  ret void
}
"#,
        );

        // `@archx_dict_new(i64 %meta, ptr %reg) -> i64`
        out.push_str(
            r#"
define private fastcc i64 @archx_dict_new(i64 %meta, ptr %reg) {
entry:
"#,
        );
        if self.used_region {
            out.push_str(
                r#"  %is_reg = icmp ne ptr %reg, null
  br i1 %is_reg, label %alloc_reg, label %alloc_heap
alloc_reg:
  %rp = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 64)
  call void @llvm.memset.p0.i64(ptr nonnull align 16 %rp, i8 0, i64 64, i1 false)
  %r_reg_gep = getelementptr inbounds %ArchxDictHdr, ptr %rp, i32 0, i32 3
  store ptr %reg, ptr %r_reg_gep, align 8
  %r_meta_gep = getelementptr inbounds %ArchxDictHdr, ptr %rp, i32 0, i32 7
  store i64 %meta, ptr %r_meta_gep, align 8
  %rpi = ptrtoint ptr %rp to i64
  %rtag = or i64 %rpi, 2
  ret i64 %rtag
alloc_heap:
"#,
            );
        }
        out.push_str(
            r#"  %hp = call noalias align 16 ptr @calloc(i64 1, i64 64)
  %hnull = icmp eq ptr %hp, null
  br i1 %hnull, label %oom, label %ok
oom:
  call void @archx_oom_fail()
  unreachable
ok:
  %h_meta_gep = getelementptr inbounds %ArchxDictHdr, ptr %hp, i32 0, i32 7
  store i64 %meta, ptr %h_meta_gep, align 8
  %hpi = ptrtoint ptr %hp to i64
  %htag = or i64 %hpi, 1
  ret i64 %htag
}
"#,
        );

        // `@archx_dict_key_hash_at`
        out.push_str(
            r#"
define private fastcc i64 @archx_dict_key_hash_at(ptr %keys, i64 %idx, i64 %kind) {
entry:
  %is0 = icmp eq i64 %kind, 0
  br i1 %is0, label %k_i64, label %chk1
k_i64:
  %pi = getelementptr inbounds i64, ptr %keys, i64 %idx
  %vi = load i64, ptr %pi, align 8
  %hi = call fastcc i64 @archx_hash_i64(i64 %vi)
  ret i64 %hi
chk1:
"#,
        );
        if self.used_any_rt {
            out.push_str(
                r#"  %is1 = icmp eq i64 %kind, 1
  br i1 %is1, label %k_str, label %k_any
k_any:
  %pa = getelementptr inbounds %ArchxAny, ptr %keys, i64 %idx
  %va = load %ArchxAny, ptr %pa, align 8
  %ha = call fastcc i64 @archx_any_hash(%ArchxAny %va)
  ret i64 %ha
"#,
            );
        } else {
            out.push_str("  br label %k_str\n");
        }
        out.push_str(
            r#"k_str:
  %ps = getelementptr inbounds %ArchxStr, ptr %keys, i64 %idx
  %vs = load %ArchxStr, ptr %ps, align 8
  %hs = call fastcc i64 @archx_hash_str(%ArchxStr %vs)
  ret i64 %hs
}
"#,
        );

        // `@archx_dict_grow(ptr %hdr)`
        out.push_str(
            r#"
define private fastcc void @archx_dict_grow(ptr %hdr) noinline {
entry:
  %len_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 0
  %used_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %reg_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 3
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6
  %meta_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 7

  %len = load i64, ptr %len_p, align 8
  %old_mask = load i64, ptr %mask_p, align 8
  %reg = load ptr, ptr %reg_p, align 8
  %old_ctrl = load ptr, ptr %ctrl_p, align 8
  %old_keys = load ptr, ptr %keys_p, align 8
  %old_vals = load ptr, ptr %vals_p, align 8
  %meta = load i64, ptr %meta_p, align 8

  %kind = and i64 %meta, 255
  %ksz_sh = lshr i64 %meta, 8
  %ksz = and i64 %ksz_sh, 16777215
  %vsz = lshr i64 %meta, 32

  %uninit = icmp eq ptr %old_ctrl, null
  %old_scap = add i64 %old_mask, 1
  %dbl_scap = shl i64 %old_scap, 1
  %new_scap = select i1 %uninit, i64 16, i64 %dbl_scap
  %new_mask = sub i64 %new_scap, 1
  %sc7 = mul i64 %new_scap, 7
  %new_dcap = lshr i64 %sc7, 3

  %c_mul = mul i64 %new_scap, 5
  %ctrl_bytes = add i64 %c_mul, 16
  %ctrl_init_len = add i64 %new_scap, 16
  %k_bytes = mul i64 %new_dcap, %ksz
  %v_bytes = mul i64 %new_dcap, %vsz
  %has_vals = icmp ugt i64 %vsz, 0
"#,
        );
        if self.used_region {
            out.push_str(
                r#"  %in_reg = icmp ne ptr %reg, null
  br i1 %in_reg, label %grow_reg, label %grow_heap
grow_reg:
  %rc = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %ctrl_bytes)
  %rk = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %k_bytes)
  %has_old_k = icmp sgt i64 %len, 0
  br i1 %has_old_k, label %rk_copy, label %rk_done
rk_copy:
  %old_kb = mul i64 %len, %ksz
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %rk, ptr nonnull align 8 %old_keys, i64 %old_kb, i1 false)
  br label %rk_done
rk_done:
  br i1 %has_vals, label %rv_alloc, label %rv_null
rv_alloc:
  %rv = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %v_bytes)
  br i1 %has_old_k, label %rv_copy, label %rv_set
rv_copy:
  %old_vb = mul i64 %len, %vsz
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %rv, ptr nonnull align 1 %old_vals, i64 %old_vb, i1 false)
  br label %rv_set
rv_set:
  br label %alloc_done
rv_null:
  br label %alloc_done
grow_heap:
"#,
            );
        } else {
            out.push_str("  br label %grow_heap\ngrow_heap:\n");
        }
        out.push_str(
            r#"  %hc = call noalias align 16 ptr @malloc(i64 %ctrl_bytes)
  %hc_null = icmp eq ptr %hc, null
  br i1 %hc_null, label %oom, label %hk_do
hk_do:
  %hk = call ptr @realloc(ptr %old_keys, i64 %k_bytes)
  %hk_null = icmp eq ptr %hk, null
  br i1 %hk_null, label %oom, label %hv_chk
hv_chk:
  br i1 %has_vals, label %hv_do, label %hv_skip
hv_do:
  %hv = call ptr @realloc(ptr %old_vals, i64 %v_bytes)
  %hv_null = icmp eq ptr %hv, null
  br i1 %hv_null, label %oom, label %hfree_old
hv_skip:
  br label %hfree_old
hfree_old:
  %hv_phi = phi ptr [ %hv, %hv_do ], [ null, %hv_skip ]
  call void @free(ptr %old_ctrl)
  br label %alloc_done
oom:
  call void @archx_oom_fail()
  unreachable
alloc_done:
"#,
        );
        if self.used_region {
            out.push_str(
                r#"  %new_ctrl = phi ptr [ %rc, %rv_set ], [ %rc, %rv_null ], [ %hc, %hfree_old ]
  %new_keys = phi ptr [ %rk, %rv_set ], [ %rk, %rv_null ], [ %hk, %hfree_old ]
  %new_vals = phi ptr [ %rv, %rv_set ], [ null, %rv_null ], [ %hv_phi, %hfree_old ]
"#,
            );
        } else {
            out.push_str(
                r#"  %new_ctrl = phi ptr [ %hc, %hfree_old ]
  %new_keys = phi ptr [ %hk, %hfree_old ]
  %new_vals = phi ptr [ %hv_phi, %hfree_old ]
"#,
            );
        }
        out.push_str(
            r#"  call void @llvm.memset.p0.i64(ptr nonnull align 1 %new_ctrl, i8 -128, i64 %ctrl_init_len, i1 false)
  %idx_base = getelementptr inbounds i8, ptr %new_ctrl, i64 %ctrl_init_len
  br label %rehash_cond
rehash_cond:
  %i = phi i64 [ 0, %alloc_done ], [ %i_next, %rehash_put ]
  %more = icmp slt i64 %i, %len
  br i1 %more, label %rehash_item, label %rehash_done
rehash_item:
  %h = call fastcc i64 @archx_dict_key_hash_at(ptr %new_keys, i64 %i, i64 %kind)
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %pos0 = and i64 %h, %new_mask
  br label %rprobe
rprobe:
  %pos = phi i64 [ %pos0, %rehash_item ], [ %pos_next, %rprobe_next ]
  %step = phi i64 [ 0, %rehash_item ], [ %step_next, %rprobe_next ]
  %gp = getelementptr inbounds i8, ptr %new_ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %ecmp = icmp eq <16 x i8> %grp, <i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128>
  %ebits = bitcast <16 x i1> %ecmp to i16
  %emask = zext i16 %ebits to i32
  %has_e = icmp ne i32 %emask, 0
  br i1 %has_e, label %rehash_put, label %rprobe_next
rprobe_next:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %new_mask
  br label %rprobe
rehash_put:
  %tz = call i32 @llvm.cttz.i32(i32 %emask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %slot = and i64 %s_add, %new_mask
  call fastcc void @archx_dict_set_ctrl(ptr %new_ctrl, i64 %new_scap, i64 %slot, i8 %h2)
  %ip = getelementptr inbounds i32, ptr %idx_base, i64 %slot
  %i32v = trunc i64 %i to i32
  store i32 %i32v, ptr %ip, align 4
  %i_next = add nuw nsw i64 %i, 1
  br label %rehash_cond
rehash_done:
  store i64 %len, ptr %used_p, align 8
  store i64 %new_mask, ptr %mask_p, align 8
  store ptr %new_ctrl, ptr %ctrl_p, align 8
  store ptr %new_keys, ptr %keys_p, align 8
  store ptr %new_vals, ptr %vals_p, align 8
  ret void
}
"#,
        );

        // Emit specialized `<16 x i8>` SIMD lookup, find_slot, and upsert for i64, str, and (if used) any!
        self.emit_dict_typed_family(out, "i64", "i64", 0);
        self.emit_dict_typed_family(out, "str", "%ArchxStr", 1);
        if self.used_any_rt {
            self.emit_dict_typed_family(out, "any", "%ArchxAny", 2);
        }

        // Generic O(1) swap-remove helper `@archx_dict_erase_slot(ptr %hdr, i64 %sparse_slot)`
        out.push_str(
            r#"
define private fastcc void @archx_dict_erase_slot(ptr %hdr, i64 %sparse_slot) {
entry:
  %len_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 0
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6
  %meta_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 7

  %len = load i64, ptr %len_p, align 8
  %mask = load i64, ptr %mask_p, align 8
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %vals = load ptr, ptr %vals_p, align 8
  %meta = load i64, ptr %meta_p, align 8

  %scap = add i64 %mask, 1
  %c_init = add i64 %scap, 16
  %idx_base = getelementptr inbounds i8, ptr %ctrl, i64 %c_init
  %sp_ip = getelementptr inbounds i32, ptr %idx_base, i64 %sparse_slot
  %d_idx32 = load i32, ptr %sp_ip, align 4
  %d_idx = zext i32 %d_idx32 to i64

  call fastcc void @archx_dict_set_ctrl(ptr %ctrl, i64 %scap, i64 %sparse_slot, i8 -2)
  %last = sub i64 %len, 1
  store i64 %last, ptr %len_p, align 8
  %need_swap = icmp slt i64 %d_idx, %last
  br i1 %need_swap, label %do_swap, label %done
do_swap:
  %kind = and i64 %meta, 255
  %ksz_sh = lshr i64 %meta, 8
  %ksz = and i64 %ksz_sh, 16777215
  %vsz = lshr i64 %meta, 32

  %kd_off = mul i64 %d_idx, %ksz
  %kl_off = mul i64 %last, %ksz
  %kd_p = getelementptr inbounds i8, ptr %keys, i64 %kd_off
  %kl_p = getelementptr inbounds i8, ptr %keys, i64 %kl_off
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %kd_p, ptr nonnull align 1 %kl_p, i64 %ksz, i1 false)

  %has_v = icmp ugt i64 %vsz, 0
  br i1 %has_v, label %swap_v, label %fix_sparse
swap_v:
  %vd_off = mul i64 %d_idx, %vsz
  %vl_off = mul i64 %last, %vsz
  %vd_p = getelementptr inbounds i8, ptr %vals, i64 %vd_off
  %vl_p = getelementptr inbounds i8, ptr %vals, i64 %vl_off
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %vd_p, ptr nonnull align 1 %vl_p, i64 %vsz, i1 false)
  br label %fix_sparse
fix_sparse:
  %h = call fastcc i64 @archx_dict_key_hash_at(ptr %keys, i64 %d_idx, i64 %kind)
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %h2_ins = insertelement <16 x i8> poison, i8 %h2, i32 0
  %h2_vec = shufflevector <16 x i8> %h2_ins, <16 x i8> poison, <16 x i32> zeroinitializer
  %last32 = trunc i64 %last to i32
  %pos0 = and i64 %h, %mask
  br label %fprobe
fprobe:
  %pos = phi i64 [ %pos0, %fix_sparse ], [ %pos_next, %fnext_grp ]
  %step = phi i64 [ 0, %fix_sparse ], [ %step_next, %fnext_grp ]
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %mcmp = icmp eq <16 x i8> %grp, %h2_vec
  %mbits = bitcast <16 x i1> %mcmp to i16
  %mmask0 = zext i16 %mbits to i32
  br label %fbit
fbit:
  %mmask = phi i32 [ %mmask0, %fprobe ], [ %mmask_next, %fbit_cont ]
  %has_m = icmp ne i32 %mmask, 0
  br i1 %has_m, label %fchk, label %fnext_grp
fchk:
  %tz = call i32 @llvm.cttz.i32(i32 %mmask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %cand = and i64 %s_add, %mask
  %cip = getelementptr inbounds i32, ptr %idx_base, i64 %cand
  %cv = load i32, ptr %cip, align 4
  %hit = icmp eq i32 %cv, %last32
  br i1 %hit, label %fupdate, label %fbit_cont
fbit_cont:
  %mm1 = sub i32 %mmask, 1
  %mmask_next = and i32 %mmask, %mm1
  br label %fbit
fnext_grp:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %mask
  br label %fprobe
fupdate:
  store i32 %d_idx32, ptr %cip, align 4
  br label %done
done:
  ret void
}
"#,
        );
    }

    fn emit_dict_typed_family(&self, out: &mut String, suffix: &str, key_ir: &str, kind: u8) {
        let hash_call = match kind {
            0 => "call fastcc i64 @archx_hash_i64(i64 %key)",
            1 => "call fastcc i64 @archx_hash_str(%ArchxStr %key)",
            _ => "call fastcc i64 @archx_any_hash(%ArchxAny %key)",
        };
        let eq_cmp = match kind {
            0 => "icmp eq i64 %cand_k, %key",
            1 => "call fastcc i1 @archx_str_eq(%ArchxStr %cand_k, %ArchxStr %key)",
            _ => "call fastcc i1 @archx_any_eq(%ArchxAny %cand_k, %ArchxAny %key)",
        };
        let clone_new_key = match kind {
            0 => "%stored_k = add i64 %key, 0".to_string(),
            1 => "%stored_k = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %key)".to_string(),
            _ => "%stored_k = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %key)".to_string(),
        };
        let inline_attr = if kind != 2 { "alwaysinline " } else { "" };

        use std::fmt::Write as _;
        let _ = write!(
            out,
            r#"
define private fastcc {{ i64, i64 }} @archx_dict_find_{suffix}(i64 %d, {key_ir} %key) {inline_attr}{{
entry:
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %not_found, label %chk_ctrl
chk_ctrl:
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %c_null = icmp eq ptr %ctrl, null
  br i1 %c_null, label %not_found, label %do_probe
do_probe:
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %mask = load i64, ptr %mask_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %scap = add i64 %mask, 1
  %c_init = add i64 %scap, 16
  %idx_base = getelementptr inbounds i8, ptr %ctrl, i64 %c_init
  %h = {hash_call}
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %h2_ins = insertelement <16 x i8> poison, i8 %h2, i32 0
  %h2_vec = shufflevector <16 x i8> %h2_ins, <16 x i8> poison, <16 x i32> zeroinitializer
  %pos0 = and i64 %h, %mask
  br label %probe
probe:
  %pos = phi i64 [ %pos0, %do_probe ], [ %pos_next, %next_grp ]
  %step = phi i64 [ 0, %do_probe ], [ %step_next, %next_grp ]
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %mcmp = icmp eq <16 x i8> %grp, %h2_vec
  %mbits = bitcast <16 x i1> %mcmp to i16
  %mmask0 = zext i16 %mbits to i32
  br label %mbit
mbit:
  %mmask = phi i32 [ %mmask0, %probe ], [ %mmask_next, %mbit_cont ]
  %has_m = icmp ne i32 %mmask, 0
  br i1 %has_m, label %chk_key, label %chk_empty
chk_key:
  %tz = call i32 @llvm.cttz.i32(i32 %mmask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %slot = and i64 %s_add, %mask
  %ip = getelementptr inbounds i32, ptr %idx_base, i64 %slot
  %didx32 = load i32, ptr %ip, align 4
  %didx = zext i32 %didx32 to i64
  %kp = getelementptr inbounds {key_ir}, ptr %keys, i64 %didx
  %cand_k = load {key_ir}, ptr %kp, align 8
  %eq = {eq_cmp}
  br i1 %eq, label %found, label %mbit_cont
mbit_cont:
  %mm1 = sub i32 %mmask, 1
  %mmask_next = and i32 %mmask, %mm1
  br label %mbit
chk_empty:
  %ecmp = icmp eq <16 x i8> %grp, <i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128>
  %ebits = bitcast <16 x i1> %ecmp to i16
  %has_e = icmp ne i16 %ebits, 0
  br i1 %has_e, label %not_found, label %next_grp
next_grp:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %mask
  br label %probe
found:
  %f0 = insertvalue {{ i64, i64 }} poison, i64 %didx, 0
  %f1 = insertvalue {{ i64, i64 }} %f0, i64 %slot, 1
  ret {{ i64, i64 }} %f1
not_found:
  ret {{ i64, i64 }} {{ i64 -1, i64 -1 }}
}}

define private fastcc i64 @archx_dict_lookup_{suffix}(i64 %d, {key_ir} %key) {inline_attr}{{
entry:
  %pair = call fastcc {{ i64, i64 }} @archx_dict_find_{suffix}(i64 %d, {key_ir} %key)
  %didx = extractvalue {{ i64, i64 }} %pair, 0
  ret i64 %didx
}}

define private fastcc {{ i64, i1 }} @archx_dict_upsert_{suffix}(i64 %d, {key_ir} %key) {{
entry:
  %h = {hash_call}
  %raw = and i64 %d, -4
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %ctrl0 = load ptr, ptr %ctrl_p, align 8
  %uninit = icmp eq ptr %ctrl0, null
  br i1 %uninit, label %do_grow0, label %chk_probe_existing
do_grow0:
  call fastcc void @archx_dict_grow(ptr %hdr)
  br label %probe_insert_init
chk_probe_existing:
  %found_pair = call fastcc {{ i64, i64 }} @archx_dict_find_{suffix}(i64 %d, {key_ir} %key)
  %found_idx = extractvalue {{ i64, i64 }} %found_pair, 0
  %exists = icmp sge i64 %found_idx, 0
  br i1 %exists, label %ret_existing, label %chk_cap
ret_existing:
  %re0 = insertvalue {{ i64, i1 }} poison, i64 %found_idx, 0
  %re1 = insertvalue {{ i64, i1 }} %re0, i1 true, 1
  ret {{ i64, i1 }} %re1
chk_cap:
  %used_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %used0 = load i64, ptr %used_p, align 8
  %mask0 = load i64, ptr %mask_p, align 8
  %scap0 = add i64 %mask0, 1
  %u1 = add i64 %used0, 1
  %lhs = shl i64 %u1, 3
  %rhs = mul i64 %scap0, 7
  %full = icmp sgt i64 %lhs, %rhs
  br i1 %full, label %do_grow1, label %probe_insert_init
do_grow1:
  call fastcc void @archx_dict_grow(ptr %hdr)
  br label %probe_insert_init
probe_insert_init:
  %len_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 0
  %used_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %mask_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %keys_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %mask = load i64, ptr %mask_p2, align 8
  %keys = load ptr, ptr %keys_p2, align 8
  %scap = add i64 %mask, 1
  %c_init = add i64 %scap, 16
  %idx_base = getelementptr inbounds i8, ptr %ctrl, i64 %c_init
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %pos0 = and i64 %h, %mask
  br label %iprobe
iprobe:
  %pos = phi i64 [ %pos0, %probe_insert_init ], [ %pos_next, %inext ]
  %step = phi i64 [ 0, %probe_insert_init ], [ %step_next, %inext ]
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %avail_cmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits = bitcast <16 x i1> %avail_cmp to i16
  %amask = zext i16 %abits to i32
  %has_a = icmp ne i32 %amask, 0
  br i1 %has_a, label %iput, label %inext
inext:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %mask
  br label %iprobe
iput:
  %tz = call i32 @llvm.cttz.i32(i32 %amask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %slot = and i64 %s_add, %mask
  %sp_c = getelementptr inbounds i8, ptr %ctrl, i64 %slot
  %old_cb = load i8, ptr %sp_c, align 1
  %was_empty = icmp eq i8 %old_cb, -128
  %u_cur = load i64, ptr %used_p2, align 8
  %u_inc = zext i1 %was_empty to i64
  %u_new = add i64 %u_cur, %u_inc
  store i64 %u_new, ptr %used_p2, align 8
  call fastcc void @archx_dict_set_ctrl(ptr %ctrl, i64 %scap, i64 %slot, i8 %h2)
  %d_idx = load i64, ptr %len_p, align 8
  %d_new = add i64 %d_idx, 1
  store i64 %d_new, ptr %len_p, align 8
  %ip = getelementptr inbounds i32, ptr %idx_base, i64 %slot
  %d_idx32 = trunc i64 %d_idx to i32
  store i32 %d_idx32, ptr %ip, align 4
  {clone_new_key}
  %kp = getelementptr inbounds {key_ir}, ptr %keys, i64 %d_idx
  store {key_ir} %stored_k, ptr %kp, align 8
  %rn0 = insertvalue {{ i64, i1 }} poison, i64 %d_idx, 0
  %rn1 = insertvalue {{ i64, i1 }} %rn0, i1 false, 1
  ret {{ i64, i1 }} %rn1
}}
"#
        );
    }

    fn emit_any_runtime(&self, out: &mut String) {
        let vec_drop_any = format!("@archx_vec_drop_{}", type_mangle_key(&Type::Any));
        let vec_clone_any = format!("@archx_vec_clone_{}", type_mangle_key(&Type::Any));
        let dict_drop_aa = format!("@archx_dict_drop_{}_{}", type_mangle_key(&Type::Any), type_mangle_key(&Type::Any));
        let dict_clone_aa = format!("@archx_dict_clone_{}_{}", type_mangle_key(&Type::Any), type_mangle_key(&Type::Any));
        let set_drop_a = format!("@archx_set_drop_{}", type_mangle_key(&Type::Any));
        let set_clone_a = format!("@archx_set_clone_{}", type_mangle_key(&Type::Any));

        emit_cstr_global(out, "@.any.unhash", "mutable list/dict/set is unhashable");
        emit_cstr_global(out, "@.any.badop", "unsupported operand types for dynamic operation");
        emit_cstr_global(out, "@.any.badidx", "dynamic value is not subscriptable or index has wrong type");
        emit_cstr_global(out, "@.any.badlen", "object of this dynamic type has no len()");
        emit_cstr_global(out, "@.any.badin", "argument of dynamic 'in' is not a container");
        emit_cstr_global(out, "@.tn.none", "NoneType");
        emit_cstr_global(out, "@.tn.bool", "bool");
        emit_cstr_global(out, "@.tn.int", "int");
        emit_cstr_global(out, "@.tn.float", "float");
        emit_cstr_global(out, "@.tn.str", "str");
        emit_cstr_global(out, "@.tn.list", "list");
        emit_cstr_global(out, "@.tn.dict", "dict");
        emit_cstr_global(out, "@.tn.set", "set");

        use std::fmt::Write as _;
        let _ = write!(
            out,
            r#"
define private fastcc void @archx_any_drop(%ArchxAny %v) {{
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %pod = icmp ult i64 %tag, 4
  br i1 %pod, label %done, label %heap_chk
heap_chk:
  %w1 = extractvalue %ArchxAny %v, 1
  %w2 = extractvalue %ArchxAny %v, 2
  %is_str = icmp eq i64 %tag, 4
  br i1 %is_str, label %d_str, label %chk_list
d_str:
  %s0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %s1 = insertvalue %ArchxStr %s0, i64 %w2, 1
  call fastcc void @archx_str_drop(%ArchxStr %s1)
  ret void
chk_list:
  %is_list = icmp eq i64 %tag, 5
  br i1 %is_list, label %d_list, label %chk_dict
d_list:
  %lp_raw = and i64 %w1, -4
  %lp_z = icmp eq i64 %lp_raw, 0
  br i1 %lp_z, label %done, label %d_list_do
d_list_do:
  %lp = inttoptr i64 %lp_raw to ptr
  %vec = load %ArchxVec, ptr %lp, align 8
  call fastcc void {vec_drop_any}(%ArchxVec %vec)
  %ltag = and i64 %w1, 3
  %lheap = icmp eq i64 %ltag, 1
  br i1 %lheap, label %d_list_free, label %done
d_list_free:
  call void @free(ptr %lp)
  ret void
chk_dict:
  %is_dict = icmp eq i64 %tag, 6
  br i1 %is_dict, label %d_dict, label %chk_set
d_dict:
  call fastcc void {dict_drop_aa}(i64 %w1)
  ret void
chk_set:
  %is_set = icmp eq i64 %tag, 7
  br i1 %is_set, label %d_set, label %done
d_set:
  call fastcc void {set_drop_a}(i64 %w1)
  br label %done
done:
  ret void
}}

define private fastcc %ArchxAny @archx_any_clone(%ArchxAny %v) {{
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %pod = icmp ult i64 %tag, 4
  br i1 %pod, label %ret_self, label %heap_chk
ret_self:
  ret %ArchxAny %v
heap_chk:
  %w1 = extractvalue %ArchxAny %v, 1
  %w2 = extractvalue %ArchxAny %v, 2
  %is_str = icmp eq i64 %tag, 4
  br i1 %is_str, label %c_str, label %chk_list
c_str:
  %s0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %s1 = insertvalue %ArchxStr %s0, i64 %w2, 1
  %sc = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %s1)
  %sw0 = extractvalue %ArchxStr %sc, 0
  %sw1 = extractvalue %ArchxStr %sc, 1
  %as0 = insertvalue %ArchxAny {{ i64 4, i64 0, i64 0 }}, i64 %sw0, 1
  %as1 = insertvalue %ArchxAny %as0, i64 %sw1, 2
  ret %ArchxAny %as1
chk_list:
  %is_list = icmp eq i64 %tag, 5
  br i1 %is_list, label %c_list, label %chk_dict
c_list:
  %lp_raw = and i64 %w1, -4
  %lp = inttoptr i64 %lp_raw to ptr
  %vec = load %ArchxVec, ptr %lp, align 8
  %vc = call fastcc %ArchxVec {vec_clone_any}(%ArchxVec %vec)
  %ncell = call noalias align 16 ptr @malloc(i64 24)
  %nc_null = icmp eq ptr %ncell, null
  br i1 %nc_null, label %oom, label %c_list_ok
oom:
  call void @archx_oom_fail()
  unreachable
c_list_ok:
  store %ArchxVec %vc, ptr %ncell, align 8
  %nci = ptrtoint ptr %ncell to i64
  %nct = or i64 %nci, 1
  %al0 = insertvalue %ArchxAny {{ i64 5, i64 0, i64 0 }}, i64 %nct, 1
  ret %ArchxAny %al0
chk_dict:
  %is_dict = icmp eq i64 %tag, 6
  br i1 %is_dict, label %c_dict, label %c_set
c_dict:
  %dc = call fastcc i64 {dict_clone_aa}(i64 %w1)
  %ad0 = insertvalue %ArchxAny {{ i64 6, i64 0, i64 0 }}, i64 %dc, 1
  ret %ArchxAny %ad0
c_set:
  %ec = call fastcc i64 {set_clone_a}(i64 %w1)
  %ae0 = insertvalue %ArchxAny {{ i64 7, i64 0, i64 0 }}, i64 %ec, 1
  ret %ArchxAny %ae0
}}

define private fastcc %ArchxAny @archx_any_promote(%ArchxAny %v) {{
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %pod = icmp ult i64 %tag, 4
  br i1 %pod, label %ret_self, label %do_prom
ret_self:
  ret %ArchxAny %v
do_prom:
  %c = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %v)
  call fastcc void @archx_any_drop(%ArchxAny %v)
  ret %ArchxAny %c
}}

define private fastcc i1 @archx_any_truthy(%ArchxAny %v) nounwind {{
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %is0 = icmp eq i64 %tag, 0
  br i1 %is0, label %ret_f, label %chk_num
ret_f:
  ret i1 false
chk_num:
  %le2 = icmp ule i64 %tag, 2
  br i1 %le2, label %t_int, label %chk_flt
t_int:
  %nz = icmp ne i64 %w1, 0
  ret i1 %nz
chk_flt:
  %is3 = icmp eq i64 %tag, 3
  br i1 %is3, label %t_flt, label %chk_str
t_flt:
  %fv = bitcast i64 %w1 to double
  %fnz = fcmp une double %fv, 0.0
  ret i1 %fnz
chk_str:
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %t_str, label %t_ptr
t_str:
  %slen = and i64 %w1, 4294967295
  %snz = icmp ne i64 %slen, 0
  ret i1 %snz
t_ptr:
  %raw = and i64 %w1, -4
  %pz = icmp eq i64 %raw, 0
  br i1 %pz, label %ret_f, label %t_load_len
t_load_len:
  %hp = inttoptr i64 %raw to ptr
  %clen = load i64, ptr %hp, align 8
  %cnz = icmp sgt i64 %clen, 0
  ret i1 %cnz
}}

define private fastcc i64 @archx_any_hash(%ArchxAny %v) {{
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %is0 = icmp eq i64 %tag, 0
  br i1 %is0, label %h_none, label %chk_int
h_none:
  ret i64 5871781006564002453
chk_int:
  %le2 = icmp ule i64 %tag, 2
  br i1 %le2, label %h_i64, label %chk_flt
h_i64:
  %hi = call fastcc i64 @archx_hash_i64(i64 %w1)
  ret i64 %hi
chk_flt:
  %is3 = icmp eq i64 %tag, 3
  br i1 %is3, label %h_flt, label %chk_str
h_flt:
  %fv = bitcast i64 %w1 to double
  %iv = call i64 @llvm.fptosi.sat.i64.f64(double %fv)
  %back = sitofp i64 %iv to double
  %exact = fcmp oeq double %fv, %back
  %hkey = select i1 %exact, i64 %iv, i64 %w1
  %hf = call fastcc i64 @archx_hash_i64(i64 %hkey)
  ret i64 %hf
chk_str:
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %h_str, label %unhash
h_str:
  %w2 = extractvalue %ArchxAny %v, 2
  %s0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %s1 = insertvalue %ArchxStr %s0, i64 %w2, 1
  %hs = call fastcc i64 @archx_hash_str(%ArchxStr %s1)
  ret i64 %hs
unhash:
  call void @archx_type_fail(ptr @.any.unhash)
  unreachable
}}

define private fastcc i1 @archx_any_eq(%ArchxAny %a, %ArchxAny %b) {{
entry:
  %ta = extractvalue %ArchxAny %a, 0
  %tb = extractvalue %ArchxAny %b, 0
  %wa1 = extractvalue %ArchxAny %a, 1
  %wb1 = extractvalue %ArchxAny %b, 1
  %na1 = icmp uge i64 %ta, 1
  %na2 = icmp ule i64 %ta, 3
  %na = and i1 %na1, %na2
  %nb1 = icmp uge i64 %tb, 1
  %nb2 = icmp ule i64 %tb, 3
  %nb = and i1 %nb1, %nb2
  %both_num = and i1 %na, %nb
  br i1 %both_num, label %num_eq, label %same_tag_chk
num_eq:
  %fa_is = icmp eq i64 %ta, 3
  %fb_is = icmp eq i64 %tb, 3
  %any_flt = or i1 %fa_is, %fb_is
  br i1 %any_flt, label %flt_eq, label %int_eq
int_eq:
  %ieq = icmp eq i64 %wa1, %wb1
  ret i1 %ieq
flt_eq:
  %da_b = bitcast i64 %wa1 to double
  %da_i = sitofp i64 %wa1 to double
  %da = select i1 %fa_is, double %da_b, double %da_i
  %db_b = bitcast i64 %wb1 to double
  %db_i = sitofp i64 %wb1 to double
  %db = select i1 %fb_is, double %db_b, double %db_i
  %feq = fcmp oeq double %da, %db
  ret i1 %feq
same_tag_chk:
  %teq = icmp eq i64 %ta, %tb
  br i1 %teq, label %by_tag, label %ret_f
ret_f:
  ret i1 false
by_tag:
  %is0 = icmp eq i64 %ta, 0
  br i1 %is0, label %ret_t, label %chk_str
ret_t:
  ret i1 true
chk_str:
  %is4 = icmp eq i64 %ta, 4
  br i1 %is4, label %eq_str, label %chk_list
eq_str:
  %wa2 = extractvalue %ArchxAny %a, 2
  %wb2 = extractvalue %ArchxAny %b, 2
  %sa0 = insertvalue %ArchxStr poison, i64 %wa1, 0
  %sa = insertvalue %ArchxStr %sa0, i64 %wa2, 1
  %sb0 = insertvalue %ArchxStr poison, i64 %wb1, 0
  %sb = insertvalue %ArchxStr %sb0, i64 %wb2, 1
  %seq = call fastcc i1 @archx_str_eq(%ArchxStr %sa, %ArchxStr %sb)
  ret i1 %seq
chk_list:
  %is5 = icmp eq i64 %ta, 5
  br i1 %is5, label %eq_list, label %chk_dict
eq_list:
  %ra = and i64 %wa1, -4
  %rb = and i64 %wb1, -4
  %lpa = inttoptr i64 %ra to ptr
  %lpb = inttoptr i64 %rb to ptr
  %va = load %ArchxVec, ptr %lpa, align 8
  %vb = load %ArchxVec, ptr %lpb, align 8
  %la = extractvalue %ArchxVec %va, 0
  %lb = extractvalue %ArchxVec %vb, 0
  %lleq = icmp eq i64 %la, %lb
  br i1 %lleq, label %lloop_init, label %ret_f
lloop_init:
  %da_p = extractvalue %ArchxVec %va, 2
  %db_p = extractvalue %ArchxVec %vb, 2
  br label %lloop_cond
lloop_cond:
  %li = phi i64 [ 0, %lloop_init ], [ %li_next, %lloop_next ]
  %lmore = icmp slt i64 %li, %la
  br i1 %lmore, label %lloop_body, label %ret_t
lloop_body:
  %ea_p = getelementptr inbounds %ArchxAny, ptr %da_p, i64 %li
  %eb_p = getelementptr inbounds %ArchxAny, ptr %db_p, i64 %li
  %ea = load %ArchxAny, ptr %ea_p, align 8
  %eb = load %ArchxAny, ptr %eb_p, align 8
  %eeq = call fastcc i1 @archx_any_eq(%ArchxAny %ea, %ArchxAny %eb)
  br i1 %eeq, label %lloop_next, label %ret_f
lloop_next:
  %li_next = add nuw nsw i64 %li, 1
  br label %lloop_cond
chk_dict:
  %dra = and i64 %wa1, -4
  %drb = and i64 %wb1, -4
  %dha = inttoptr i64 %dra to ptr
  %dhb = inttoptr i64 %drb to ptr
  %dla = load i64, ptr %dha, align 8
  %dlb = load i64, ptr %dhb, align 8
  %dleq = icmp eq i64 %dla, %dlb
  br i1 %dleq, label %dloop_init, label %ret_f
dloop_init:
  %akp_p = getelementptr inbounds %ArchxDictHdr, ptr %dha, i32 0, i32 5
  %avp_p = getelementptr inbounds %ArchxDictHdr, ptr %dha, i32 0, i32 6
  %bvp_p = getelementptr inbounds %ArchxDictHdr, ptr %dhb, i32 0, i32 6
  %akeys = load ptr, ptr %akp_p, align 8
  %avals = load ptr, ptr %avp_p, align 8
  %bvals = load ptr, ptr %bvp_p, align 8
  %is_dict_t = icmp eq i64 %ta, 6
  br label %dloop_cond
dloop_cond:
  %di = phi i64 [ 0, %dloop_init ], [ %di_next, %dloop_next ]
  %dmore = icmp slt i64 %di, %dla
  br i1 %dmore, label %dloop_body, label %ret_t
dloop_body:
  %ak_p = getelementptr inbounds %ArchxAny, ptr %akeys, i64 %di
  %ak = load %ArchxAny, ptr %ak_p, align 8
  %bidx = call fastcc i64 @archx_dict_lookup_any(i64 %wb1, %ArchxAny %ak)
  %bfound = icmp sge i64 %bidx, 0
  br i1 %bfound, label %dchk_val, label %ret_f
dchk_val:
  br i1 %is_dict_t, label %dchk_dv, label %dloop_next
dchk_dv:
  %av_p = getelementptr inbounds %ArchxAny, ptr %avals, i64 %di
  %bv_p = getelementptr inbounds %ArchxAny, ptr %bvals, i64 %bidx
  %av = load %ArchxAny, ptr %av_p, align 8
  %bv = load %ArchxAny, ptr %bv_p, align 8
  %veq = call fastcc i1 @archx_any_eq(%ArchxAny %av, %ArchxAny %bv)
  br i1 %veq, label %dloop_next, label %ret_f
dloop_next:
  %di_next = add nuw nsw i64 %di, 1
  br label %dloop_cond
}}

define private fastcc %ArchxStr @archx_any_type_name(%ArchxAny %v) {{
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %is0 = icmp eq i64 %tag, 0
  br i1 %is0, label %t0, label %c1
t0:
  %s0 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.none, i64 8, ptr null)
  ret %ArchxStr %s0
c1:
  %is1 = icmp eq i64 %tag, 1
  br i1 %is1, label %t1, label %c2
t1:
  %s1 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.bool, i64 4, ptr null)
  ret %ArchxStr %s1
c2:
  %is2 = icmp eq i64 %tag, 2
  br i1 %is2, label %t2, label %c3
t2:
  %s2 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.int, i64 3, ptr null)
  ret %ArchxStr %s2
c3:
  %is3 = icmp eq i64 %tag, 3
  br i1 %is3, label %t3, label %c4
t3:
  %s3 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.float, i64 5, ptr null)
  ret %ArchxStr %s3
c4:
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %t4, label %c5
t4:
  %s4 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.str, i64 3, ptr null)
  ret %ArchxStr %s4
c5:
  %is5 = icmp eq i64 %tag, 5
  br i1 %is5, label %t5, label %c6
t5:
  %s5 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.list, i64 4, ptr null)
  ret %ArchxStr %s5
c6:
  %is6 = icmp eq i64 %tag, 6
  br i1 %is6, label %t6, label %t7
t6:
  %s6 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.dict, i64 4, ptr null)
  ret %ArchxStr %s6
t7:
  %s7 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.set, i64 3, ptr null)
  ret %ArchxStr %s7
}}

define private fastcc %ArchxStr @archx_any_to_str(%ArchxAny %v, ptr %reg) {{
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %w2 = extractvalue %ArchxAny %v, 2
  %is0 = icmp eq i64 %tag, 0
  br i1 %is0, label %s_none, label %c1
s_none:
  %rn = call fastcc %ArchxStr @archx_str_from_slice(ptr @.str.none, i64 4, ptr %reg)
  ret %ArchxStr %rn
c1:
  %is1 = icmp eq i64 %tag, 1
  br i1 %is1, label %s_bool, label %c2
s_bool:
  %bt = icmp ne i64 %w1, 0
  %bp = select i1 %bt, ptr @.str.true, ptr @.str.false
  %bl = select i1 %bt, i64 4, i64 5
  %rb = call fastcc %ArchxStr @archx_str_from_slice(ptr %bp, i64 %bl, ptr %reg)
  ret %ArchxStr %rb
c2:
  %is2 = icmp eq i64 %tag, 2
  br i1 %is2, label %s_int, label %c3
s_int:
  %ri = call fastcc %ArchxStr @archx_str_from_int(i64 %w1, ptr %reg)
  ret %ArchxStr %ri
c3:
  %is3 = icmp eq i64 %tag, 3
  br i1 %is3, label %s_flt, label %c4
s_flt:
  %fv = bitcast i64 %w1 to double
  %rf = call fastcc %ArchxStr @archx_str_from_float(double %fv, ptr %reg)
  ret %ArchxStr %rf
c4:
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %s_str, label %s_other
s_str:
  %ss0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %ss1 = insertvalue %ArchxStr %ss0, i64 %w2, 1
  %rc = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %ss1)
  ret %ArchxStr %rc
s_other:
  %rt = call fastcc %ArchxStr @archx_any_type_name(%ArchxAny %v)
  ret %ArchxStr %rt
}}

define private fastcc void @archx_any_print(%ArchxAny %v, i1 %newline) {{
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %w2 = extractvalue %ArchxAny %v, 2
  %is0 = icmp eq i64 %tag, 0
  br i1 %is0, label %p_none, label %c1
p_none:
  %cn = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr @.str.none)
  br label %finish_nl
c1:
  %is1 = icmp eq i64 %tag, 1
  br i1 %is1, label %p_bool, label %c2
p_bool:
  %bt = icmp ne i64 %w1, 0
  %bp = select i1 %bt, ptr @.str.true, ptr @.str.false
  %cb = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr %bp)
  br label %finish_nl
c2:
  %is2 = icmp eq i64 %tag, 2
  br i1 %is2, label %p_int, label %c3
p_int:
  %ci = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %w1)
  br label %finish_nl
c3:
  %is3 = icmp eq i64 %tag, 3
  br i1 %is3, label %p_flt, label %c4
p_flt:
  %fv = bitcast i64 %w1 to double
  call fastcc void @archx_print_float(double %fv, i1 false)
  br label %finish_nl
c4:
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %p_str, label %c5
p_str:
  %ss0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %ss1 = insertvalue %ArchxStr %ss0, i64 %w2, 1
  call fastcc void @archx_str_print(%ArchxStr %ss1, i1 false)
  br label %finish_nl
c5:
  %is5 = icmp eq i64 %tag, 5
  br i1 %is5, label %p_list, label %p_dictset
p_list:
  %lo = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %lraw = and i64 %w1, -4
  %lp = inttoptr i64 %lraw to ptr
  %lvec = load %ArchxVec, ptr %lp, align 8
  %llen = extractvalue %ArchxVec %lvec, 0
  %ldat = extractvalue %ArchxVec %lvec, 2
  br label %ll_cond
ll_cond:
  %li = phi i64 [ 0, %p_list ], [ %li_next, %ll_elem ]
  %lmore = icmp slt i64 %li, %llen
  br i1 %lmore, label %ll_body, label %ll_done
ll_body:
  %lgt0 = icmp sgt i64 %li, 0
  br i1 %lgt0, label %ll_sep, label %ll_elem
ll_sep:
  %lsc = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %ll_elem
ll_elem:
  %lep = getelementptr inbounds %ArchxAny, ptr %ldat, i64 %li
  %le = load %ArchxAny, ptr %lep, align 8
  call fastcc void @archx_any_print(%ArchxAny %le, i1 false)
  %li_next = add nuw nsw i64 %li, 1
  br label %ll_cond
ll_done:
  %lc = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack.inline)
  br label %finish_nl
p_dictset:
  %do = call i32 (ptr, ...) @printf(ptr @.fmt.lbrace)
  %draw = and i64 %w1, -4
  %dz = icmp eq i64 %draw, 0
  br i1 %dz, label %dd_done, label %dd_init
dd_init:
  %dh = inttoptr i64 %draw to ptr
  %dlen = load i64, ptr %dh, align 8
  %dkp = getelementptr inbounds %ArchxDictHdr, ptr %dh, i32 0, i32 5
  %dvp = getelementptr inbounds %ArchxDictHdr, ptr %dh, i32 0, i32 6
  %dkeys = load ptr, ptr %dkp, align 8
  %dvals = load ptr, ptr %dvp, align 8
  %is_d = icmp eq i64 %tag, 6
  br label %dd_cond
dd_cond:
  %di = phi i64 [ 0, %dd_init ], [ %di_next, %dd_next ]
  %dmore = icmp slt i64 %di, %dlen
  br i1 %dmore, label %dd_body, label %dd_done
dd_body:
  %dgt0 = icmp sgt i64 %di, 0
  br i1 %dgt0, label %dd_sep, label %dd_key
dd_sep:
  %dsc = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %dd_key
dd_key:
  %dk_e = getelementptr inbounds %ArchxAny, ptr %dkeys, i64 %di
  %dkv = load %ArchxAny, ptr %dk_e, align 8
  call fastcc void @archx_any_print(%ArchxAny %dkv, i1 false)
  br i1 %is_d, label %dd_val, label %dd_next
dd_val:
  %dcol = call i32 (ptr, ...) @printf(ptr @.fmt.colon)
  %dv_e = getelementptr inbounds %ArchxAny, ptr %dvals, i64 %di
  %dvv = load %ArchxAny, ptr %dv_e, align 8
  call fastcc void @archx_any_print(%ArchxAny %dvv, i1 false)
  br label %dd_next
dd_next:
  %di_next = add nuw nsw i64 %di, 1
  br label %dd_cond
dd_done:
  %dc = call i32 (ptr, ...) @printf(ptr @.fmt.rbrace)
  br label %finish_nl
finish_nl:
  br i1 %newline, label %do_nl, label %ret_done
do_nl:
  %cnl = call i32 (ptr, ...) @printf(ptr @.fmt.nl)
  br label %ret_done
ret_done:
  ret void
}}

define private fastcc i64 @archx_any_len(%ArchxAny %v) {{
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %l_str, label %chk_cont
l_str:
  %slen = and i64 %w1, 4294967295
  ret i64 %slen
chk_cont:
  %ge5 = icmp uge i64 %tag, 5
  %le7 = icmp ule i64 %tag, 7
  %ok = and i1 %ge5, %le7
  br i1 %ok, label %l_cont, label %bad
l_cont:
  %raw = and i64 %w1, -4
  %z = icmp eq i64 %raw, 0
  br i1 %z, label %ret0, label %load_l
ret0:
  ret i64 0
load_l:
  %p = inttoptr i64 %raw to ptr
  %l = load i64, ptr %p, align 8
  ret i64 %l
bad:
  call void @archx_type_fail(ptr @.any.badlen)
  unreachable
}}

define private fastcc %ArchxAny @archx_any_get_idx(%ArchxAny %target, %ArchxAny %idx) {{
entry:
  %ttag = extractvalue %ArchxAny %target, 0
  %tw1 = extractvalue %ArchxAny %target, 1
  %tw2 = extractvalue %ArchxAny %target, 2
  %itag = extractvalue %ArchxAny %idx, 0
  %iw1 = extractvalue %ArchxAny %idx, 1
  %is_list = icmp eq i64 %ttag, 5
  br i1 %is_list, label %g_list, label %chk_dict
g_list:
  %i_ok = icmp eq i64 %itag, 2
  br i1 %i_ok, label %gl_idx, label %bad_idx
gl_idx:
  %lraw = and i64 %tw1, -4
  %lp = inttoptr i64 %lraw to ptr
  %lvec = load %ArchxVec, ptr %lp, align 8
  %llen = extractvalue %ArchxVec %lvec, 0
  %neg = icmp slt i64 %iw1, 0
  %adj = add i64 %iw1, %llen
  %eff = select i1 %neg, i64 %adj, i64 %iw1
  %oob = icmp uge i64 %eff, %llen
  br i1 %oob, label %gl_oob, label %gl_ok
gl_oob:
  call void @archx_bounds_fail(i64 %iw1, i64 %llen)
  unreachable
gl_ok:
  %ldat = extractvalue %ArchxVec %lvec, 2
  %ep = getelementptr inbounds %ArchxAny, ptr %ldat, i64 %eff
  %ev = load %ArchxAny, ptr %ep, align 8
  %ec = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %ev)
  ret %ArchxAny %ec
chk_dict:
  %is_dict = icmp eq i64 %ttag, 6
  br i1 %is_dict, label %g_dict, label %chk_str
g_dict:
  %didx = call fastcc i64 @archx_dict_lookup_any(i64 %tw1, %ArchxAny %idx)
  %dfound = icmp sge i64 %didx, 0
  br i1 %dfound, label %gd_ok, label %gd_miss
gd_miss:
  call void @archx_key_fail()
  unreachable
gd_ok:
  %draw = and i64 %tw1, -4
  %dh = inttoptr i64 %draw to ptr
  %dvp = getelementptr inbounds %ArchxDictHdr, ptr %dh, i32 0, i32 6
  %dvals = load ptr, ptr %dvp, align 8
  %vp = getelementptr inbounds %ArchxAny, ptr %dvals, i64 %didx
  %vv = load %ArchxAny, ptr %vp, align 8
  %vc = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %vv)
  ret %ArchxAny %vc
chk_str:
  %is_str = icmp eq i64 %ttag, 4
  %si_ok = icmp eq i64 %itag, 2
  %sok = and i1 %is_str, %si_ok
  br i1 %sok, label %g_str, label %bad_idx
g_str:
  %slen = and i64 %tw1, 4294967295
  %sneg = icmp slt i64 %iw1, 0
  %sadj = add i64 %iw1, %slen
  %seff = select i1 %sneg, i64 %sadj, i64 %iw1
  %soob = icmp uge i64 %seff, %slen
  br i1 %soob, label %gs_oob, label %gs_ok
gs_oob:
  call void @archx_bounds_fail(i64 %iw1, i64 %slen)
  unreachable
gs_ok:
  %ss0 = insertvalue %ArchxStr poison, i64 %tw1, 0
  %ss1 = insertvalue %ArchxStr %ss0, i64 %tw2, 1
  %ch = call fastcc %ArchxStr @archx_str_byte_at(%ArchxStr %ss1, i64 %seff)
  %cw0 = extractvalue %ArchxStr %ch, 0
  %cw1 = extractvalue %ArchxStr %ch, 1
  %ar0 = insertvalue %ArchxAny {{ i64 4, i64 0, i64 0 }}, i64 %cw0, 1
  %ar1 = insertvalue %ArchxAny %ar0, i64 %cw1, 2
  ret %ArchxAny %ar1
bad_idx:
  call void @archx_type_fail(ptr @.any.badidx)
  unreachable
}}

define private fastcc void @archx_any_set_idx(%ArchxAny %target, %ArchxAny %idx, %ArchxAny %val) {{
entry:
  %ttag = extractvalue %ArchxAny %target, 0
  %tw1 = extractvalue %ArchxAny %target, 1
  %itag = extractvalue %ArchxAny %idx, 0
  %iw1 = extractvalue %ArchxAny %idx, 1
  %is_list = icmp eq i64 %ttag, 5
  br i1 %is_list, label %s_list, label %chk_dict
s_list:
  %i_ok = icmp eq i64 %itag, 2
  br i1 %i_ok, label %sl_do, label %bad_idx
sl_do:
  %lraw = and i64 %tw1, -4
  %lp = inttoptr i64 %lraw to ptr
  %lvec = load %ArchxVec, ptr %lp, align 8
  %llen = extractvalue %ArchxVec %lvec, 0
  %neg = icmp slt i64 %iw1, 0
  %adj = add i64 %iw1, %llen
  %eff = select i1 %neg, i64 %adj, i64 %iw1
  %oob = icmp uge i64 %eff, %llen
  br i1 %oob, label %sl_oob, label %sl_ok
sl_oob:
  call void @archx_bounds_fail(i64 %iw1, i64 %llen)
  unreachable
sl_ok:
  %ldat = extractvalue %ArchxVec %lvec, 2
  %ep = getelementptr inbounds %ArchxAny, ptr %ldat, i64 %eff
  %old = load %ArchxAny, ptr %ep, align 8
  %vc = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %val)
  call fastcc void @archx_any_drop(%ArchxAny %old)
  store %ArchxAny %vc, ptr %ep, align 8
  ret void
chk_dict:
  %is_dict = icmp eq i64 %ttag, 6
  br i1 %is_dict, label %s_dict, label %bad_idx
s_dict:
  %up = call fastcc {{ i64, i1 }} @archx_dict_upsert_any(i64 %tw1, %ArchxAny %idx)
  %didx = extractvalue {{ i64, i1 }} %up, 0
  %existed = extractvalue {{ i64, i1 }} %up, 1
  %draw = and i64 %tw1, -4
  %dh = inttoptr i64 %draw to ptr
  %dvp = getelementptr inbounds %ArchxDictHdr, ptr %dh, i32 0, i32 6
  %dvals = load ptr, ptr %dvp, align 8
  %vp = getelementptr inbounds %ArchxAny, ptr %dvals, i64 %didx
  %vc2 = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %val)
  br i1 %existed, label %sd_drop_old, label %sd_store
sd_drop_old:
  %oldv = load %ArchxAny, ptr %vp, align 8
  call fastcc void @archx_any_drop(%ArchxAny %oldv)
  br label %sd_store
sd_store:
  store %ArchxAny %vc2, ptr %vp, align 8
  ret void
bad_idx:
  call void @archx_type_fail(ptr @.any.badidx)
  unreachable
}}

define private fastcc i1 @archx_any_in(%ArchxAny %needle, %ArchxAny %hay) {{
entry:
  %htag = extractvalue %ArchxAny %hay, 0
  %hw1 = extractvalue %ArchxAny %hay, 1
  %hw2 = extractvalue %ArchxAny %hay, 2
  %is_list = icmp eq i64 %htag, 5
  br i1 %is_list, label %in_list, label %chk_ds
in_list:
  %lraw = and i64 %hw1, -4
  %lp = inttoptr i64 %lraw to ptr
  %lvec = load %ArchxVec, ptr %lp, align 8
  %llen = extractvalue %ArchxVec %lvec, 0
  %ldat = extractvalue %ArchxVec %lvec, 2
  br label %ll_cond
ll_cond:
  %li = phi i64 [ 0, %in_list ], [ %li_next, %ll_next ]
  %lmore = icmp slt i64 %li, %llen
  br i1 %lmore, label %ll_body, label %ret_f
ll_body:
  %ep = getelementptr inbounds %ArchxAny, ptr %ldat, i64 %li
  %ev = load %ArchxAny, ptr %ep, align 8
  %eq = call fastcc i1 @archx_any_eq(%ArchxAny %needle, %ArchxAny %ev)
  br i1 %eq, label %ret_t, label %ll_next
ll_next:
  %li_next = add nuw nsw i64 %li, 1
  br label %ll_cond
chk_ds:
  %is_d = icmp eq i64 %htag, 6
  %is_s = icmp eq i64 %htag, 7
  %is_ds = or i1 %is_d, %is_s
  br i1 %is_ds, label %in_ds, label %chk_str
in_ds:
  %didx = call fastcc i64 @archx_dict_lookup_any(i64 %hw1, %ArchxAny %needle)
  %fnd = icmp sge i64 %didx, 0
  ret i1 %fnd
chk_str:
  %nt = extractvalue %ArchxAny %needle, 0
  %is_hs = icmp eq i64 %htag, 4
  %is_ns = icmp eq i64 %nt, 4
  %both_s = and i1 %is_hs, %is_ns
  br i1 %both_s, label %in_str, label %bad
in_str:
  %nw1 = extractvalue %ArchxAny %needle, 1
  %nw2 = extractvalue %ArchxAny %needle, 2
  %hs0 = insertvalue %ArchxStr poison, i64 %hw1, 0
  %hs = insertvalue %ArchxStr %hs0, i64 %hw2, 1
  %ns0 = insertvalue %ArchxStr poison, i64 %nw1, 0
  %ns = insertvalue %ArchxStr %ns0, i64 %nw2, 1
  %pos = call fastcc i64 @archx_str_find(%ArchxStr %hs, %ArchxStr %ns)
  %sfnd = icmp sge i64 %pos, 0
  ret i1 %sfnd
ret_t:
  ret i1 true
ret_f:
  ret i1 false
bad:
  call void @archx_type_fail(ptr @.any.badin)
  unreachable
}}

define private fastcc %ArchxAny @archx_any_neg(%ArchxAny %v) {{
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %le2 = icmp uge i64 %tag, 1
  %le2b = icmp ule i64 %tag, 2
  %is_i = and i1 %le2, %le2b
  br i1 %is_i, label %n_int, label %chk_f
n_int:
  %ni = sub i64 0, %w1
  %ri = insertvalue %ArchxAny {{ i64 2, i64 0, i64 0 }}, i64 %ni, 1
  ret %ArchxAny %ri
chk_f:
  %is_f = icmp eq i64 %tag, 3
  br i1 %is_f, label %n_flt, label %bad
n_flt:
  %fv = bitcast i64 %w1 to double
  %nf = fneg double %fv
  %nfi = bitcast double %nf to i64
  %rf = insertvalue %ArchxAny {{ i64 3, i64 0, i64 0 }}, i64 %nfi, 1
  ret %ArchxAny %rf
bad:
  call void @archx_type_fail(ptr @.any.badop)
  unreachable
}}

define private fastcc i1 @archx_any_cmp(%ArchxAny %a, %ArchxAny %b, i64 %op) {{
entry:
  %ta = extractvalue %ArchxAny %a, 0
  %tb = extractvalue %ArchxAny %b, 0
  %wa1 = extractvalue %ArchxAny %a, 1
  %wb1 = extractvalue %ArchxAny %b, 1
  %na1 = icmp uge i64 %ta, 1
  %na2 = icmp ule i64 %ta, 3
  %na = and i1 %na1, %na2
  %nb1 = icmp uge i64 %tb, 1
  %nb2 = icmp ule i64 %tb, 3
  %nb = and i1 %nb1, %nb2
  %both_num = and i1 %na, %nb
  br i1 %both_num, label %num_cmp, label %bad
num_cmp:
  %fa_is = icmp eq i64 %ta, 3
  %fb_is = icmp eq i64 %tb, 3
  %any_f = or i1 %fa_is, %fb_is
  br i1 %any_f, label %f_cmp, label %i_cmp
i_cmp:
  %ilt = icmp slt i64 %wa1, %wb1
  %igt = icmp sgt i64 %wa1, %wb1
  %ile = icmp sle i64 %wa1, %wb1
  %ige = icmp sge i64 %wa1, %wb1
  %is0 = icmp eq i64 %op, 0
  %is1 = icmp eq i64 %op, 1
  %is2 = icmp eq i64 %op, 2
  %r01 = select i1 %is0, i1 %ilt, i1 %igt
  %r012 = select i1 %is2, i1 %ile, i1 %r01
  %is3 = icmp eq i64 %op, 3
  %ri = select i1 %is3, i1 %ige, i1 %r012
  ret i1 %ri
f_cmp:
  %da_b = bitcast i64 %wa1 to double
  %da_i = sitofp i64 %wa1 to double
  %da = select i1 %fa_is, double %da_b, double %da_i
  %db_b = bitcast i64 %wb1 to double
  %db_i = sitofp i64 %wb1 to double
  %db = select i1 %fb_is, double %db_b, double %db_i
  %flt = fcmp olt double %da, %db
  %fgt = fcmp ogt double %da, %db
  %fle = fcmp ole double %da, %db
  %fge = fcmp oge double %da, %db
  %fs0 = icmp eq i64 %op, 0
  %fs2 = icmp eq i64 %op, 2
  %fs3 = icmp eq i64 %op, 3
  %fr01 = select i1 %fs0, i1 %flt, i1 %fgt
  %fr012 = select i1 %fs2, i1 %fle, i1 %fr01
  %rf = select i1 %fs3, i1 %fge, i1 %fr012
  ret i1 %rf
bad:
  call void @archx_type_fail(ptr @.any.badop)
  unreachable
}}

define private fastcc %ArchxAny @archx_any_binop(%ArchxAny %a, %ArchxAny %b, i64 %op, ptr %reg) {{
entry:
  %ta = extractvalue %ArchxAny %a, 0
  %tb = extractvalue %ArchxAny %b, 0
  %wa1 = extractvalue %ArchxAny %a, 1
  %wb1 = extractvalue %ArchxAny %b, 1
  %na1 = icmp uge i64 %ta, 1
  %na2 = icmp ule i64 %ta, 3
  %na = and i1 %na1, %na2
  %nb1 = icmp uge i64 %tb, 1
  %nb2 = icmp ule i64 %tb, 3
  %nb = and i1 %nb1, %nb2
  %both_num = and i1 %na, %nb
  br i1 %both_num, label %num_op, label %chk_str_op
num_op:
  %fa_is = icmp eq i64 %ta, 3
  %fb_is = icmp eq i64 %tb, 3
  %any_f = or i1 %fa_is, %fb_is
  br i1 %any_f, label %flt_op, label %int_op
int_op:
  %op_add = icmp eq i64 %op, 0
  br i1 %op_add, label %i_add, label %ic_sub
i_add:
  %va = add i64 %wa1, %wb1
  br label %ret_int
ic_sub:
  %op_sub = icmp eq i64 %op, 1
  br i1 %op_sub, label %i_sub, label %ic_mul
i_sub:
  %vs = sub i64 %wa1, %wb1
  br label %ret_int
ic_mul:
  %op_mul = icmp eq i64 %op, 2
  br i1 %op_mul, label %i_mul, label %ic_div
i_mul:
  %vm = mul i64 %wa1, %wb1
  br label %ret_int
ic_div:
  %op_pow = icmp eq i64 %op, 6
  br i1 %op_pow, label %i_pow, label %ic_divrem
i_pow:
  %neg_e = icmp slt i64 %wb1, 0
  br i1 %neg_e, label %pow_err, label %pow_loop_init
pow_err:
  call void @archx_neg_exp_fail()
  unreachable
pow_loop_init:
  br label %pow_cond
pow_cond:
  %pe = phi i64 [ %wb1, %pow_loop_init ], [ %pe_next, %pow_step ]
  %pacc = phi i64 [ 1, %pow_loop_init ], [ %pacc_next, %pow_step ]
  %pbase = phi i64 [ %wa1, %pow_loop_init ], [ %pbase_next, %pow_step ]
  %pgz = icmp sgt i64 %pe, 0
  br i1 %pgz, label %pow_step, label %ret_int_pow
pow_step:
  %odd = and i64 %pe, 1
  %is_odd = icmp ne i64 %odd, 0
  %pmul = mul i64 %pacc, %pbase
  %pacc_next = select i1 %is_odd, i64 %pmul, i64 %pacc
  %pbase_next = mul i64 %pbase, %pbase
  %pe_next = lshr i64 %pe, 1
  br label %pow_cond
ret_int_pow:
  br label %ret_int
ic_divrem:
  %bz = icmp eq i64 %wb1, 0
  br i1 %bz, label %div_z, label %ic_div_ok
div_z:
  call void @archx_div_zero_fail()
  unreachable
ic_div_ok:
  %is_min = icmp eq i64 %wa1, -9223372036854775808
  %is_m1 = icmp eq i64 %wb1, -1
  %ovf_d = and i1 %is_min, %is_m1
  %safe_b = select i1 %ovf_d, i64 1, i64 %wb1
  %q = sdiv i64 %wa1, %safe_b
  %r = srem i64 %wa1, %safe_b
  %op_div = icmp eq i64 %op, 3
  br i1 %op_div, label %i_div, label %ic_fdiv
i_div:
  %vd = select i1 %ovf_d, i64 -9223372036854775808, i64 %q
  br label %ret_int
ic_fdiv:
  %op_fdiv = icmp eq i64 %op, 4
  %r_nz = icmp ne i64 %r, 0
  %xr = xor i64 %wa1, %safe_b
  %diff_s = icmp slt i64 %xr, 0
  %need_adj = and i1 %r_nz, %diff_s
  br i1 %op_fdiv, label %i_fdiv, label %i_mod
i_fdiv:
  %qm1 = sub i64 %q, 1
  %vfd = select i1 %need_adj, i64 %qm1, i64 %q
  br label %ret_int
i_mod:
  %radj = add i64 %r, %safe_b
  %vmd = select i1 %need_adj, i64 %radj, i64 %r
  br label %ret_int
ret_int:
  %ival = phi i64 [ %va, %i_add ], [ %vs, %i_sub ], [ %vm, %i_mul ], [ %pacc, %ret_int_pow ], [ %vd, %i_div ], [ %vfd, %i_fdiv ], [ %vmd, %i_mod ]
  %ri = insertvalue %ArchxAny {{ i64 2, i64 0, i64 0 }}, i64 %ival, 1
  ret %ArchxAny %ri

flt_op:
  %da_b = bitcast i64 %wa1 to double
  %da_i = sitofp i64 %wa1 to double
  %da = select i1 %fa_is, double %da_b, double %da_i
  %db_b = bitcast i64 %wb1 to double
  %db_i = sitofp i64 %wb1 to double
  %db = select i1 %fb_is, double %db_b, double %db_i
  %f_add = icmp eq i64 %op, 0
  br i1 %f_add, label %fl_add, label %fc_sub
fl_add:
  %fva = fadd double %da, %db
  br label %ret_flt
fc_sub:
  %f_sub = icmp eq i64 %op, 1
  br i1 %f_sub, label %fl_sub, label %fc_mul
fl_sub:
  %fvs = fsub double %da, %db
  br label %ret_flt
fc_mul:
  %f_mul = icmp eq i64 %op, 2
  br i1 %f_mul, label %fl_mul, label %fc_pow
fl_mul:
  %fvm = fmul double %da, %db
  br label %ret_flt
fc_pow:
  %f_pow = icmp eq i64 %op, 6
  br i1 %f_pow, label %fl_pow, label %fc_div
fl_pow:
  %fvp = call double @llvm.pow.f64(double %da, double %db)
  br label %ret_flt
fc_div:
  %fbz = fcmp oeq double %db, 0.0
  br i1 %fbz, label %fdiv_z, label %fc_div_ok
fdiv_z:
  call void @archx_div_zero_fail()
  unreachable
fc_div_ok:
  %fq = fdiv double %da, %db
  %f_div = icmp eq i64 %op, 3
  br i1 %f_div, label %fl_div, label %fc_fdiv
fl_div:
  br label %ret_flt
fc_fdiv:
  %fflr = call double @llvm.floor.f64(double %fq)
  %f_fdiv = icmp eq i64 %op, 4
  br i1 %f_fdiv, label %fl_fdiv, label %fl_mod
fl_fdiv:
  br label %ret_flt
fl_mod:
  %fmulq = fmul double %fflr, %db
  %fmod = fsub double %da, %fmulq
  br label %ret_flt
ret_flt:
  %fval = phi double [ %fva, %fl_add ], [ %fvs, %fl_sub ], [ %fvm, %fl_mul ], [ %fvp, %fl_pow ], [ %fq, %fl_div ], [ %fflr, %fl_fdiv ], [ %fmod, %fl_mod ]
  %fbits = bitcast double %fval to i64
  %rf = insertvalue %ArchxAny {{ i64 3, i64 0, i64 0 }}, i64 %fbits, 1
  ret %ArchxAny %rf

chk_str_op:
  %wa2 = extractvalue %ArchxAny %a, 2
  %wb2 = extractvalue %ArchxAny %b, 2
  %sa_is = icmp eq i64 %ta, 4
  %sb_is = icmp eq i64 %tb, 4
  %op0 = icmp eq i64 %op, 0
  %both_s = and i1 %sa_is, %sb_is
  %s_cat = and i1 %op0, %both_s
  br i1 %s_cat, label %do_scat, label %chk_srep
do_scat:
  %sa0 = insertvalue %ArchxStr poison, i64 %wa1, 0
  %sa = insertvalue %ArchxStr %sa0, i64 %wa2, 1
  %sb0 = insertvalue %ArchxStr poison, i64 %wb1, 0
  %sb = insertvalue %ArchxStr %sb0, i64 %wb2, 1
  %sc = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %sa, %ArchxStr %sb, ptr %reg)
  %sc0 = extractvalue %ArchxStr %sc, 0
  %sc1 = extractvalue %ArchxStr %sc, 1
  %rsc0 = insertvalue %ArchxAny {{ i64 4, i64 0, i64 0 }}, i64 %sc0, 1
  %rsc = insertvalue %ArchxAny %rsc0, i64 %sc1, 2
  ret %ArchxAny %rsc
chk_srep:
  %op2 = icmp eq i64 %op, 2
  %bi_is = icmp eq i64 %tb, 2
  %ai_is = icmp eq i64 %ta, 2
  %sr1 = and i1 %sa_is, %bi_is
  %sr2 = and i1 %ai_is, %sb_is
  %sr_any = or i1 %sr1, %sr2
  %do_sr = and i1 %op2, %sr_any
  br i1 %do_sr, label %srep_do, label %bad_op
srep_do:
  %r_sw0 = select i1 %sa_is, i64 %wa1, i64 %wb1
  %r_sw1 = select i1 %sa_is, i64 %wa2, i64 %wb2
  %r_cnt = select i1 %sa_is, i64 %wb1, i64 %wa1
  %rs0 = insertvalue %ArchxStr poison, i64 %r_sw0, 0
  %rs = insertvalue %ArchxStr %rs0, i64 %r_sw1, 1
  %rr = call fastcc %ArchxStr @archx_str_repeat(%ArchxStr %rs, i64 %r_cnt, ptr %reg)
  %rr0 = extractvalue %ArchxStr %rr, 0
  %rr1 = extractvalue %ArchxStr %rr, 1
  %rrr0 = insertvalue %ArchxAny {{ i64 4, i64 0, i64 0 }}, i64 %rr0, 1
  %rrr = insertvalue %ArchxAny %rrr0, i64 %rr1, 2
  ret %ArchxAny %rrr
bad_op:
  call void @archx_type_fail(ptr @.any.badop)
  unreachable
}}
"#
        );
    }
}
