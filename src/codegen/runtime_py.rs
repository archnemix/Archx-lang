//! On-demand LLVM IR runtime helpers for Pythonic I/O (`input`, `float` formatting),
//! type conversions (`int(s)`, `float(s)`, `str(n)`, `str(x)`), string methods
//! (`strip`, `upper`/`lower`, `startswith`/`endswith`, `find`, `repeat`, `replace`, `split`),
//! 1-byte SSO indexing (`@archx_str_byte_at`), and `assert` / math intrinsics.

use super::*;

impl Codegen {
    pub(super) fn needs_str_from_slice(&self) -> bool {
        self.used_str_from_int
            || self.used_str_from_float
            || self.used_input
            || self.used_str_repeat
            || self.used_str_strip
            || self.used_str_case
            || self.used_str_split_ws
            || self.used_str_split_sep
            || self.used_str_replace
            || self.used_slice_rt
            || self.used_any_rt
    }

    pub(super) fn finalize_runtime_flags(&mut self) {
        if self.used_assert_fail || self.used_input {
            self.used_str_print = true;
        }
        if self.used_str_split_sep || self.used_str_replace {
            self.used_str_find = true;
            self.used_parse_fail = true;
        }
        if self.used_str_byte_at {
            self.used_bounds_fail = true;
        }
        if self.used_int_from_str || self.used_float_from_str {
            self.used_parse_fail = true;
        }
        if self.needs_str_from_slice() {
            self.used_malloc = true;
            self.used_memcpy = true;
            self.used_oom_fail = true;
        }
        if self.used_input
            || self.used_float_from_str
            || self.used_str_case
            || self.used_str_repeat
            || self.used_str_replace
            || self.used_str_split_ws
            || self.used_str_split_sep
        {
            self.used_malloc = true;
            self.used_free = true;
            self.used_oom_fail = true;
        }
        if self.used_input
            || self.used_str_split_ws
            || self.used_str_split_sep
            || self.used_str_replace
        {
            self.used_realloc = true;
        }
        if self.used_str_starts_ends || self.used_str_find {
            self.used_str_eq = true;
        }
        if self.used_print_float {
            self.used_print_inline = true;
        }
    }

    pub(super) fn emit_pythonic_runtime_helpers(&self, out: &mut String) {
        if self.needs_str_from_slice() {
            out.push_str(
                r#"
define private fastcc %ArchxStr @archx_str_from_slice(ptr %src, i64 %len, ptr %reg) {
entry:
  %sso = alloca [16 x i8], align 8
  %z = icmp sle i64 %len, 0
  br i1 %z, label %ret_empty, label %chk_big
ret_empty:
  ret %ArchxStr zeroinitializer
chk_big:
  %big = icmp sgt i64 %len, 2147483647
  br i1 %big, label %oom, label %chk_sso
oom:
  call void @archx_oom_fail()
  unreachable
chk_sso:
  %short = icmp ule i64 %len, 12
  br i1 %short, label %pack_sso, label %build_long
pack_sso:
  store i64 0, ptr %sso, align 8
  %sso8 = getelementptr inbounds i8, ptr %sso, i64 8
  store i64 0, ptr %sso8, align 8
  %len32 = trunc i64 %len to i32
  store i32 %len32, ptr %sso, align 8
  %sso4 = getelementptr inbounds i8, ptr %sso, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso4, ptr nonnull align 1 %src, i64 %len, i1 false)
  %sw0 = load i64, ptr %sso, align 8
  %sw1 = load i64, ptr %sso8, align 8
  %ss0 = insertvalue %ArchxStr poison, i64 %sw0, 0
  %ss1 = insertvalue %ArchxStr %ss0, i64 %sw1, 1
  ret %ArchxStr %ss1
"#,
            );
            if self.used_region {
                out.push_str(
                    r#"build_long:
  %use_reg = icmp ne ptr %reg, null
  br i1 %use_reg, label %alloc_reg, label %alloc_heap
alloc_reg:
  %rp = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %len)
  %rp_i = ptrtoint ptr %rp to i64
  %rp_a = and i64 %rp_i, -4
  %rtagged = or i64 %rp_a, 2
  br label %copy_long
alloc_heap:
  %hp = call noalias align 16 ptr @malloc(i64 %len)
  %hnull = icmp eq ptr %hp, null
  br i1 %hnull, label %oom, label %tag_heap
tag_heap:
  %hp_i = ptrtoint ptr %hp to i64
  %htagged = or i64 %hp_i, 1
  br label %copy_long
copy_long:
  %dst = phi ptr [ %rp, %alloc_reg ], [ %hp, %tag_heap ]
  %w1_out = phi i64 [ %rtagged, %alloc_reg ], [ %htagged, %tag_heap ]
"#,
                );
            } else {
                out.push_str(
                    r#"build_long:
  %hp = call noalias align 16 ptr @malloc(i64 %len)
  %hnull = icmp eq ptr %hp, null
  br i1 %hnull, label %oom, label %copy_long
copy_long:
  %dst = phi ptr [ %hp, %build_long ]
  %hp_i = ptrtoint ptr %hp to i64
  %w1_out = or i64 %hp_i, 1
"#,
                );
            }
            out.push_str(
                r#"  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst, ptr nonnull align 1 %src, i64 %len, i1 false)
  %pref32 = load i32, ptr %dst, align 16
  %pref64 = zext i32 %pref32 to i64
  %pref_sh = shl nuw i64 %pref64, 32
  %w0_out = or i64 %len, %pref_sh
  %ls0 = insertvalue %ArchxStr poison, i64 %w0_out, 0
  %ls1 = insertvalue %ArchxStr %ls0, i64 %w1_out, 1
  ret %ArchxStr %ls1
}

"#,
            );
        }

        if self.used_print_float || self.used_str_from_float {
            out.push_str(
                r#"
define private fastcc i64 @archx_fmt_float_buf(double %x, ptr %buf) nounwind {
entry:
  %n32 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull %buf, ptr @.fmt.g15, double %x)
  %n = sext i32 %n32 to i64
  %pos = icmp sgt i64 %n, 0
  br i1 %pos, label %scan, label %ret_orig
scan:
  %i = phi i64 [ 0, %entry ], [ %inext, %scan_step ]
  %cp = getelementptr inbounds i8, ptr %buf, i64 %i
  %ch = load i8, ptr %cp, align 1
  %is_dot = icmp eq i8 %ch, 46
  %is_e = icmp eq i8 %ch, 101
  %is_E = icmp eq i8 %ch, 69
  %is_n = icmp eq i8 %ch, 110
  %is_N = icmp eq i8 %ch, 78
  %is_i = icmp eq i8 %ch, 105
  %is_I = icmp eq i8 %ch, 73
  %o1 = or i1 %is_dot, %is_e
  %o2 = or i1 %o1, %is_E
  %o3 = or i1 %o2, %is_n
  %o4 = or i1 %o3, %is_N
  %o5 = or i1 %o4, %is_i
  %special = or i1 %o5, %is_I
  br i1 %special, label %ret_orig, label %scan_step
scan_step:
  %inext = add nuw nsw i64 %i, 1
  %more = icmp slt i64 %inext, %n
  br i1 %more, label %scan, label %append_dot0
append_dot0:
  %p0 = getelementptr inbounds i8, ptr %buf, i64 %n
  store i8 46, ptr %p0, align 1
  %n1 = add nuw nsw i64 %n, 1
  %p1 = getelementptr inbounds i8, ptr %buf, i64 %n1
  store i8 48, ptr %p1, align 1
  %n2 = add nuw nsw i64 %n, 2
  %p2 = getelementptr inbounds i8, ptr %buf, i64 %n2
  store i8 0, ptr %p2, align 1
  ret i64 %n2
ret_orig:
  ret i64 %n
}

"#,
            );
        }

        if self.used_print_float {
            out.push_str(
                r#"
define private fastcc void @archx_print_float(double %x, i1 %nl) {
entry:
  %buf = alloca [64 x i8], align 8
  %len = call fastcc i64 @archx_fmt_float_buf(double %x, ptr %buf)
  %fmt = select i1 %nl, ptr @.fmt.str, ptr @.fmt.str.elem
  %r = call i32 (ptr, ...) @printf(ptr %fmt, ptr nonnull %buf)
  ret void
}

"#,
            );
        }

        if self.used_str_from_float {
            out.push_str(
                r#"
define private fastcc %ArchxStr @archx_str_from_float(double %x, ptr %reg) {
entry:
  %buf = alloca [64 x i8], align 8
  %len = call fastcc i64 @archx_fmt_float_buf(double %x, ptr %buf)
  %s = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %buf, i64 %len, ptr %reg)
  ret %ArchxStr %s
}

"#,
            );
        }

        if self.used_str_from_int {
            emit_cstr_global(out, "@.fmt.i64s", "%lld");
            out.push_str(
                r#"
define private fastcc %ArchxStr @archx_str_from_int(i64 %n, ptr %reg) {
entry:
  %buf = alloca [32 x i8], align 8
  %n32 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull %buf, ptr @.fmt.i64s, i64 %n)
  %len = sext i32 %n32 to i64
  %s = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %buf, i64 %len, ptr %reg)
  ret %ArchxStr %s
}

"#,
            );
        }

        if self.used_str_byte_at {
            out.push_str(
                r#"
define private fastcc %ArchxStr @archx_str_byte_at(%ArchxStr %s, i64 %idx) {
entry:
  %tmp = alloca [12 x i8], align 4
  %w0 = extractvalue %ArchxStr %s, 0
  %len = and i64 %w0, 4294967295
  %oob = icmp uge i64 %idx, %len
  br i1 %oob, label %fail, label %ok
fail:
  call void @archx_bounds_fail(i64 %idx, i64 %len)
  unreachable
ok:
  %w1 = extractvalue %ArchxStr %s, 1
  %short = icmp ule i64 %len, 12
  br i1 %short, label %mat_short, label %mat_long
mat_short:
  %p4 = lshr i64 %w0, 32
  %p4_32 = trunc i64 %p4 to i32
  store i32 %p4_32, ptr %tmp, align 4
  %tmp4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %tmp4, align 4
  br label %load_b
mat_long:
  %raw = and i64 %w1, -4
  %lptr = inttoptr i64 %raw to ptr
  br label %load_b
load_b:
  %base = phi ptr [ %tmp, %mat_short ], [ %lptr, %mat_long ]
  %bp = getelementptr inbounds i8, ptr %base, i64 %idx
  %b8 = load i8, ptr %bp, align 1
  %b64 = zext i8 %b8 to i64
  %sh = shl nuw i64 %b64, 32
  %rw0 = or i64 %sh, 1
  %rs0 = insertvalue %ArchxStr poison, i64 %rw0, 0
  %rs1 = insertvalue %ArchxStr %rs0, i64 0, 1
  ret %ArchxStr %rs1
}

"#,
            );
        }

        if self.used_int_from_str {
            out.push_str(
                r#"
define private fastcc i64 @archx_int_from_str(%ArchxStr %s) {
entry:
  %tmp = alloca [12 x i8], align 4
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %short = icmp ule i64 %len, 12
  br i1 %short, label %mat_s, label %mat_l
mat_s:
  %p4 = lshr i64 %w0, 32
  %p4_32 = trunc i64 %p4 to i32
  store i32 %p4_32, ptr %tmp, align 4
  %t4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %t4, align 4
  br label %trim_l_pre
mat_l:
  %raw = and i64 %w1, -4
  %lp = inttoptr i64 %raw to ptr
  br label %trim_l_pre
trim_l_pre:
  %data = phi ptr [ %tmp, %mat_s ], [ %lp, %mat_l ]
  br label %trim_l
trim_l:
  %lo = phi i64 [ 0, %trim_l_pre ], [ %lo_next, %trim_l_ws ]
  %lo_lt = icmp ult i64 %lo, %len
  br i1 %lo_lt, label %trim_l_chk, label %fail
trim_l_chk:
  %lp_c = getelementptr inbounds i8, ptr %data, i64 %lo
  %lc = load i8, ptr %lp_c, align 1
  %ls1 = icmp eq i8 %lc, 32
  %lc_s = sub i8 %lc, 9
  %ls2 = icmp ult i8 %lc_s, 5
  %lws = or i1 %ls1, %ls2
  br i1 %lws, label %trim_l_ws, label %trim_r
trim_l_ws:
  %lo_next = add nuw nsw i64 %lo, 1
  br label %trim_l
trim_r:
  %hi = phi i64 [ %len, %trim_l_chk ], [ %hi_prev, %trim_r_ws ]
  %hi_gt = icmp ugt i64 %hi, %lo
  br i1 %hi_gt, label %trim_r_chk, label %fail
trim_r_chk:
  %hi_prev = sub nuw nsw i64 %hi, 1
  %rp_c = getelementptr inbounds i8, ptr %data, i64 %hi_prev
  %rc = load i8, ptr %rp_c, align 1
  %rs1 = icmp eq i8 %rc, 32
  %rc_s = sub i8 %rc, 9
  %rs2 = icmp ult i8 %rc_s, 5
  %rws = or i1 %rs1, %rs2
  br i1 %rws, label %trim_r_ws, label %chk_sign
trim_r_ws:
  br label %trim_r
chk_sign:
  %fc_p = getelementptr inbounds i8, ptr %data, i64 %lo
  %fc = load i8, ptr %fc_p, align 1
  %is_neg = icmp eq i8 %fc, 45
  %is_pos = icmp eq i8 %fc, 43
  %has_sign = or i1 %is_neg, %is_pos
  %lo_plus1 = add nuw nsw i64 %lo, 1
  %start = select i1 %has_sign, i64 %lo_plus1, i64 %lo
  %non_empty = icmp ult i64 %start, %hi
  br i1 %non_empty, label %loop_pre, label %fail
loop_pre:
  %limit = select i1 %is_neg, i64 -9223372036854775808, i64 9223372036854775807
  br label %loop
loop:
  %idx = phi i64 [ %start, %loop_pre ], [ %idx_next, %loop_next ]
  %acc = phi i64 [ 0, %loop_pre ], [ %acc_next, %loop_next ]
  %has_d = phi i1 [ false, %loop_pre ], [ %has_d_next, %loop_next ]
  %dp = getelementptr inbounds i8, ptr %data, i64 %idx
  %dc = load i8, ptr %dp, align 1
  %is_us = icmp eq i8 %dc, 95
  br i1 %is_us, label %chk_us, label %chk_dig
chk_us:
  %idx_p1 = add nuw nsw i64 %idx, 1
  %not_end = icmp ult i64 %idx_p1, %hi
  %us_ok = and i1 %has_d, %not_end
  br i1 %us_ok, label %us_adv, label %fail
us_adv:
  br label %loop_next
chk_dig:
  %dsub = sub i8 %dc, 48
  %dig_ok = icmp ult i8 %dsub, 10
  br i1 %dig_ok, label %mul_add, label %fail
mul_add:
  %ovf_mul = icmp ugt i64 %acc, 922337203685477580
  br i1 %ovf_mul, label %fail, label %do_add
do_add:
  %m10 = mul nuw i64 %acc, 10
  %d64 = zext i8 %dsub to i64
  %cand = add i64 %m10, %d64
  %ovf_add = icmp ult i64 %cand, %m10
  %ovf_lim = icmp ugt i64 %cand, %limit
  %bad_add = or i1 %ovf_add, %ovf_lim
  br i1 %bad_add, label %fail, label %dig_ok_blk
dig_ok_blk:
  br label %loop_next
loop_next:
  %acc_next = phi i64 [ %acc, %us_adv ], [ %cand, %dig_ok_blk ]
  %has_d_next = phi i1 [ %has_d, %us_adv ], [ true, %dig_ok_blk ]
  %idx_next = add nuw nsw i64 %idx, 1
  %more = icmp ult i64 %idx_next, %hi
  br i1 %more, label %loop, label %finish
finish:
  br i1 %has_d_next, label %ret_val, label %fail
ret_val:
  %neg_acc = sub i64 0, %acc_next
  %res = select i1 %is_neg, i64 %neg_acc, i64 %acc_next
  ret i64 %res
fail:
  call void @archx_parse_fail()
  unreachable
}

"#,
            );
        }

        if self.used_float_from_str {
            out.push_str(
                r#"
define private fastcc double @archx_float_from_str(%ArchxStr %s) {
entry:
  %tmp = alloca [12 x i8], align 4
  %sbuf = alloca [64 x i8], align 8
  %endp = alloca ptr, align 8
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %short = icmp ule i64 %len, 12
  br i1 %short, label %mat_s, label %mat_l
mat_s:
  %p4 = lshr i64 %w0, 32
  %p4_32 = trunc i64 %p4 to i32
  store i32 %p4_32, ptr %tmp, align 4
  %t4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %t4, align 4
  br label %trim_l_pre
mat_l:
  %raw = and i64 %w1, -4
  %lp = inttoptr i64 %raw to ptr
  br label %trim_l_pre
trim_l_pre:
  %data = phi ptr [ %tmp, %mat_s ], [ %lp, %mat_l ]
  br label %trim_l
trim_l:
  %lo = phi i64 [ 0, %trim_l_pre ], [ %lo_next, %trim_l_ws ]
  %lo_lt = icmp ult i64 %lo, %len
  br i1 %lo_lt, label %trim_l_chk, label %fail
trim_l_chk:
  %lp_c = getelementptr inbounds i8, ptr %data, i64 %lo
  %lc = load i8, ptr %lp_c, align 1
  %ls1 = icmp eq i8 %lc, 32
  %lc_s = sub i8 %lc, 9
  %ls2 = icmp ult i8 %lc_s, 5
  %lws = or i1 %ls1, %ls2
  br i1 %lws, label %trim_l_ws, label %trim_r
trim_l_ws:
  %lo_next = add nuw nsw i64 %lo, 1
  br label %trim_l
trim_r:
  %hi = phi i64 [ %len, %trim_l_chk ], [ %hi_prev, %trim_r_ws ]
  %hi_gt = icmp ugt i64 %hi, %lo
  br i1 %hi_gt, label %trim_r_chk, label %fail
trim_r_chk:
  %hi_prev = sub nuw nsw i64 %hi, 1
  %rp_c = getelementptr inbounds i8, ptr %data, i64 %hi_prev
  %rc = load i8, ptr %rp_c, align 1
  %rs1 = icmp eq i8 %rc, 32
  %rc_s = sub i8 %rc, 9
  %rs2 = icmp ult i8 %rc_s, 5
  %rws = or i1 %rs1, %rs2
  br i1 %rws, label %trim_r_ws, label %prep_cstr
trim_r_ws:
  br label %trim_r
prep_cstr:
  %tlen = sub nuw nsw i64 %hi, %lo
  %fits_s = icmp ult i64 %tlen, 63
  br i1 %fits_s, label %use_stack, label %use_heap
use_stack:
  br label %copy_clean
use_heap:
  %asz = add nuw nsw i64 %tlen, 1
  %hp = call noalias ptr @malloc(i64 %asz)
  %hn = icmp eq ptr %hp, null
  br i1 %hn, label %oom, label %copy_clean
oom:
  call void @archx_oom_fail()
  unreachable
copy_clean:
  %cbuf = phi ptr [ %sbuf, %use_stack ], [ %hp, %use_heap ]
  %on_heap = phi i1 [ false, %use_stack ], [ true, %use_heap ]
  br label %cloop
cloop:
  %si = phi i64 [ %lo, %copy_clean ], [ %si_next, %cloop_step ]
  %di = phi i64 [ 0, %copy_clean ], [ %di_next, %cloop_step ]
  %sp = getelementptr inbounds i8, ptr %data, i64 %si
  %sc = load i8, ptr %sp, align 1
  %is_us = icmp eq i8 %sc, 95
  br i1 %is_us, label %skip_us, label %write_c
skip_us:
  br label %cloop_step
write_c:
  %dp = getelementptr inbounds i8, ptr %cbuf, i64 %di
  store i8 %sc, ptr %dp, align 1
  %di_inc = add nuw nsw i64 %di, 1
  br label %cloop_step
cloop_step:
  %di_next = phi i64 [ %di, %skip_us ], [ %di_inc, %write_c ]
  %si_next = add nuw nsw i64 %si, 1
  %cmore = icmp ult i64 %si_next, %hi
  br i1 %cmore, label %cloop, label %parse_d
parse_d:
  %nulp = getelementptr inbounds i8, ptr %cbuf, i64 %di_next
  store i8 0, ptr %nulp, align 1
  %val = call double @strtod(ptr nonnull %cbuf, ptr nonnull %endp)
  %ep = load ptr, ptr %endp, align 8
  %empty_p = icmp eq ptr %ep, %cbuf
  %end_ch = load i8, ptr %ep, align 1
  %not_nul = icmp ne i8 %end_ch, 0
  %bad_p = or i1 %empty_p, %not_nul
  br i1 %on_heap, label %do_free, label %chk_ok
do_free:
  call void @free(ptr %cbuf)
  br label %chk_ok
chk_ok:
  br i1 %bad_p, label %fail, label %done
done:
  ret double %val
fail:
  call void @archx_parse_fail()
  unreachable
}

"#,
            );
        }

        if self.used_input {
            out.push_str(
                r#"
define private fastcc %ArchxStr @archx_input(%ArchxStr %prompt, i1 %has_prompt, ptr %reg) {
entry:
  %sbuf = alloca [64 x i8], align 8
  br i1 %has_prompt, label %do_prompt, label %do_flush
do_prompt:
  call fastcc void @archx_str_print(%ArchxStr %prompt, i1 false)
  br label %do_flush
do_flush:
  %fl = call i32 @fflush(ptr null)
  br label %read_loop
read_loop:
  %buf = phi ptr [ %sbuf, %do_flush ], [ %buf_next, %store_ch ]
  %cap = phi i64 [ 64, %do_flush ], [ %cap_next, %store_ch ]
  %len = phi i64 [ 0, %do_flush ], [ %len_next, %store_ch ]
  %heap = phi i1 [ false, %do_flush ], [ %heap_next, %store_ch ]
  %ch = call i32 @getchar()
  %is_eof = icmp eq i32 %ch, -1
  %is_nl = icmp eq i32 %ch, 10
  %stop = or i1 %is_eof, %is_nl
  br i1 %stop, label %strip_cr, label %chk_cap
chk_cap:
  %full = icmp sge i64 %len, %cap
  br i1 %full, label %grow, label %no_grow
no_grow:
  br label %store_ch
grow:
  %big = icmp sge i64 %cap, 1073741824
  br i1 %big, label %oom, label %do_grow
oom:
  call void @archx_oom_fail()
  unreachable
do_grow:
  %ncap = shl nuw nsw i64 %cap, 1
  br i1 %heap, label %grow_realloc, label %grow_malloc
grow_malloc:
  %mp = call noalias ptr @malloc(i64 %ncap)
  %mn = icmp eq ptr %mp, null
  br i1 %mn, label %oom, label %copy_stack
copy_stack:
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %mp, ptr nonnull align 8 %sbuf, i64 %len, i1 false)
  br label %store_ch
grow_realloc:
  %rp = call ptr @realloc(ptr %buf, i64 %ncap)
  %rn = icmp eq ptr %rp, null
  br i1 %rn, label %oom, label %store_ch
store_ch:
  %buf_next = phi ptr [ %buf, %no_grow ], [ %mp, %copy_stack ], [ %rp, %grow_realloc ]
  %cap_next = phi i64 [ %cap, %no_grow ], [ %ncap, %copy_stack ], [ %ncap, %grow_realloc ]
  %heap_next = phi i1 [ %heap, %no_grow ], [ true, %copy_stack ], [ true, %grow_realloc ]
  %ch8 = trunc i32 %ch to i8
  %wp = getelementptr inbounds i8, ptr %buf_next, i64 %len
  store i8 %ch8, ptr %wp, align 1
  %len_next = add nuw nsw i64 %len, 1
  br label %read_loop
strip_cr:
  %has_len = icmp sgt i64 %len, 0
  br i1 %has_len, label %chk_cr, label %finish
chk_cr:
  %lm1 = sub nuw nsw i64 %len, 1
  %lp = getelementptr inbounds i8, ptr %buf, i64 %lm1
  %last = load i8, ptr %lp, align 1
  %is_cr = icmp eq i8 %last, 13
  %flen = select i1 %is_cr, i64 %lm1, i64 %len
  br label %finish
finish:
  %out_len = phi i64 [ 0, %strip_cr ], [ %flen, %chk_cr ]
  %res = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %buf, i64 %out_len, ptr %reg)
  br i1 %heap, label %free_tmp, label %done
free_tmp:
  call void @free(ptr %buf)
  br label %done
done:
  ret %ArchxStr %res
}

"#,
            );
        }

        if self.used_str_strip {
            out.push_str(
                r#"
define private fastcc %ArchxStr @archx_str_strip(%ArchxStr %s, ptr %reg) {
entry:
  %tmp = alloca [12 x i8], align 4
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %short = icmp ule i64 %len, 12
  br i1 %short, label %mat_s, label %mat_l
mat_s:
  %p4 = lshr i64 %w0, 32
  %p4_32 = trunc i64 %p4 to i32
  store i32 %p4_32, ptr %tmp, align 4
  %t4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %t4, align 4
  br label %trim_l_pre
mat_l:
  %raw = and i64 %w1, -4
  %lp = inttoptr i64 %raw to ptr
  br label %trim_l_pre
trim_l_pre:
  %data = phi ptr [ %tmp, %mat_s ], [ %lp, %mat_l ]
  br label %trim_l
trim_l:
  %lo = phi i64 [ 0, %trim_l_pre ], [ %lo_next, %trim_l_ws ]
  %lo_lt = icmp ult i64 %lo, %len
  br i1 %lo_lt, label %trim_l_chk, label %ret_empty
trim_l_chk:
  %lp_c = getelementptr inbounds i8, ptr %data, i64 %lo
  %lc = load i8, ptr %lp_c, align 1
  %ls1 = icmp eq i8 %lc, 32
  %lc_s = sub i8 %lc, 9
  %ls2 = icmp ult i8 %lc_s, 5
  %lws = or i1 %ls1, %ls2
  br i1 %lws, label %trim_l_ws, label %trim_r
trim_l_ws:
  %lo_next = add nuw nsw i64 %lo, 1
  br label %trim_l
trim_r:
  %hi = phi i64 [ %len, %trim_l_chk ], [ %hi_prev, %trim_r_ws ]
  %hi_gt = icmp ugt i64 %hi, %lo
  br i1 %hi_gt, label %trim_r_chk, label %ret_empty
trim_r_chk:
  %hi_prev = sub nuw nsw i64 %hi, 1
  %rp_c = getelementptr inbounds i8, ptr %data, i64 %hi_prev
  %rc = load i8, ptr %rp_c, align 1
  %rs1 = icmp eq i8 %rc, 32
  %rc_s = sub i8 %rc, 9
  %rs2 = icmp ult i8 %rc_s, 5
  %rws = or i1 %rs1, %rs2
  br i1 %rws, label %trim_r_ws, label %build
trim_r_ws:
  br label %trim_r
build:
  %sp = getelementptr inbounds i8, ptr %data, i64 %lo
  %nlen = sub nuw nsw i64 %hi, %lo
  %res = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %sp, i64 %nlen, ptr %reg)
  ret %ArchxStr %res
ret_empty:
  ret %ArchxStr zeroinitializer
}

"#,
            );
        }

        if self.used_str_case {
            out.push_str(
                r#"
define private fastcc %ArchxStr @archx_str_case(%ArchxStr %s, i1 %upper, ptr %reg) {
entry:
  %tmp = alloca [12 x i8], align 4
  %sbuf = alloca [64 x i8], align 8
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %z = icmp eq i64 %len, 0
  br i1 %z, label %ret_empty, label %mat
ret_empty:
  ret %ArchxStr zeroinitializer
mat:
  %short = icmp ule i64 %len, 12
  br i1 %short, label %mat_s, label %mat_l
mat_s:
  %p4 = lshr i64 %w0, 32
  %p4_32 = trunc i64 %p4 to i32
  store i32 %p4_32, ptr %tmp, align 4
  %t4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %t4, align 4
  br label %alloc_dst
mat_l:
  %raw = and i64 %w1, -4
  %lp = inttoptr i64 %raw to ptr
  br label %alloc_dst
alloc_dst:
  %src = phi ptr [ %tmp, %mat_s ], [ %lp, %mat_l ]
  %fits = icmp ule i64 %len, 64
  br i1 %fits, label %use_stack, label %use_heap
use_stack:
  br label %loop_pre
use_heap:
  %hp = call noalias ptr @malloc(i64 %len)
  %hn = icmp eq ptr %hp, null
  br i1 %hn, label %oom, label %loop_pre
oom:
  call void @archx_oom_fail()
  unreachable
loop_pre:
  %dst = phi ptr [ %sbuf, %use_stack ], [ %hp, %use_heap ]
  %on_heap = phi i1 [ false, %use_stack ], [ true, %use_heap ]
  br label %loop
loop:
  %i = phi i64 [ 0, %loop_pre ], [ %inext, %loop ]
  %sp = getelementptr inbounds i8, ptr %src, i64 %i
  %c = load i8, ptr %sp, align 1
  %lo_s = sub i8 %c, 97
  %is_lo = icmp ult i8 %lo_s, 26
  %hi_s = sub i8 %c, 65
  %is_hi = icmp ult i8 %hi_s, 26
  %to_up = and i1 %upper, %is_lo
  %not_up = xor i1 %upper, true
  %to_lo = and i1 %not_up, %is_hi
  %up_c = sub i8 %c, 32
  %lo_c = add i8 %c, 32
  %c1 = select i1 %to_up, i8 %up_c, i8 %c
  %c2 = select i1 %to_lo, i8 %lo_c, i8 %c1
  %dp = getelementptr inbounds i8, ptr %dst, i64 %i
  store i8 %c2, ptr %dp, align 1
  %inext = add nuw nsw i64 %i, 1
  %more = icmp ult i64 %inext, %len
  br i1 %more, label %loop, label %finish
finish:
  %res = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %dst, i64 %len, ptr %reg)
  br i1 %on_heap, label %do_free, label %done
do_free:
  call void @free(ptr %dst)
  br label %done
done:
  ret %ArchxStr %res
}

"#,
            );
        }

        if self.used_str_starts_ends {
            out.push_str(
                r#"
define private fastcc i1 @archx_str_startswith(%ArchxStr %s, %ArchxStr %pre) nounwind {
entry:
  %atmp = alloca [12 x i8], align 4
  %btmp = alloca [12 x i8], align 4
  %sw0 = extractvalue %ArchxStr %s, 0
  %pw0 = extractvalue %ArchxStr %pre, 0
  %slen = and i64 %sw0, 4294967295
  %plen = and i64 %pw0, 4294967295
  %pz = icmp eq i64 %plen, 0
  br i1 %pz, label %ret_true, label %chk_len
chk_len:
  %too_long = icmp ugt i64 %plen, %slen
  br i1 %too_long, label %ret_false, label %mat_a
mat_a:
  %sw1 = extractvalue %ArchxStr %s, 1
  %sshort = icmp ule i64 %slen, 12
  br i1 %sshort, label %mat_as, label %mat_al
mat_as:
  %sp4 = lshr i64 %sw0, 32
  %sp32 = trunc i64 %sp4 to i32
  store i32 %sp32, ptr %atmp, align 4
  %at4 = getelementptr inbounds i8, ptr %atmp, i64 4
  store i64 %sw1, ptr %at4, align 4
  br label %mat_b
mat_al:
  %sraw = and i64 %sw1, -4
  %slp = inttoptr i64 %sraw to ptr
  br label %mat_b
mat_b:
  %aptr = phi ptr [ %atmp, %mat_as ], [ %slp, %mat_al ]
  %pw1 = extractvalue %ArchxStr %pre, 1
  %pshort = icmp ule i64 %plen, 12
  br i1 %pshort, label %mat_bs, label %mat_bl
mat_bs:
  %pp4 = lshr i64 %pw0, 32
  %pp32 = trunc i64 %pp4 to i32
  store i32 %pp32, ptr %btmp, align 4
  %bt4 = getelementptr inbounds i8, ptr %btmp, i64 4
  store i64 %pw1, ptr %bt4, align 4
  br label %cmp
mat_bl:
  %praw = and i64 %pw1, -4
  %plp = inttoptr i64 %praw to ptr
  br label %cmp
cmp:
  %bptr = phi ptr [ %btmp, %mat_bs ], [ %plp, %mat_bl ]
  %mc = call i32 @memcmp(ptr nonnull %aptr, ptr nonnull %bptr, i64 %plen)
  %eq = icmp eq i32 %mc, 0
  ret i1 %eq
ret_true:
  ret i1 true
ret_false:
  ret i1 false
}

define private fastcc i1 @archx_str_endswith(%ArchxStr %s, %ArchxStr %suf) nounwind {
entry:
  %atmp = alloca [12 x i8], align 4
  %btmp = alloca [12 x i8], align 4
  %sw0 = extractvalue %ArchxStr %s, 0
  %pw0 = extractvalue %ArchxStr %suf, 0
  %slen = and i64 %sw0, 4294967295
  %plen = and i64 %pw0, 4294967295
  %pz = icmp eq i64 %plen, 0
  br i1 %pz, label %ret_true, label %chk_len
chk_len:
  %too_long = icmp ugt i64 %plen, %slen
  br i1 %too_long, label %ret_false, label %mat_a
mat_a:
  %sw1 = extractvalue %ArchxStr %s, 1
  %sshort = icmp ule i64 %slen, 12
  br i1 %sshort, label %mat_as, label %mat_al
mat_as:
  %sp4 = lshr i64 %sw0, 32
  %sp32 = trunc i64 %sp4 to i32
  store i32 %sp32, ptr %atmp, align 4
  %at4 = getelementptr inbounds i8, ptr %atmp, i64 4
  store i64 %sw1, ptr %at4, align 4
  br label %mat_b
mat_al:
  %sraw = and i64 %sw1, -4
  %slp = inttoptr i64 %sraw to ptr
  br label %mat_b
mat_b:
  %aptr = phi ptr [ %atmp, %mat_as ], [ %slp, %mat_al ]
  %pw1 = extractvalue %ArchxStr %suf, 1
  %pshort = icmp ule i64 %plen, 12
  br i1 %pshort, label %mat_bs, label %mat_bl
mat_bs:
  %pp4 = lshr i64 %pw0, 32
  %pp32 = trunc i64 %pp4 to i32
  store i32 %pp32, ptr %btmp, align 4
  %bt4 = getelementptr inbounds i8, ptr %btmp, i64 4
  store i64 %pw1, ptr %bt4, align 4
  br label %cmp
mat_bl:
  %praw = and i64 %pw1, -4
  %plp = inttoptr i64 %praw to ptr
  br label %cmp
cmp:
  %bptr = phi ptr [ %btmp, %mat_bs ], [ %plp, %mat_bl ]
  %off = sub nuw nsw i64 %slen, %plen
  %atail = getelementptr inbounds i8, ptr %aptr, i64 %off
  %mc = call i32 @memcmp(ptr nonnull %atail, ptr nonnull %bptr, i64 %plen)
  %eq = icmp eq i32 %mc, 0
  ret i1 %eq
ret_true:
  ret i1 true
ret_false:
  ret i1 false
}

"#,
            );
        }

        if self.used_str_find {
            out.push_str(
                r#"
define private fastcc i64 @archx_str_find(%ArchxStr %hay, %ArchxStr %needle) nounwind {
entry:
  %atmp = alloca [12 x i8], align 4
  %btmp = alloca [12 x i8], align 4
  %hw0 = extractvalue %ArchxStr %hay, 0
  %nw0 = extractvalue %ArchxStr %needle, 0
  %hlen = and i64 %hw0, 4294967295
  %nlen = and i64 %nw0, 4294967295
  %nz = icmp eq i64 %nlen, 0
  br i1 %nz, label %ret_zero, label %chk_len
ret_zero:
  ret i64 0
chk_len:
  %too_long = icmp ugt i64 %nlen, %hlen
  br i1 %too_long, label %ret_neg1, label %mat_a
mat_a:
  %hw1 = extractvalue %ArchxStr %hay, 1
  %hshort = icmp ule i64 %hlen, 12
  br i1 %hshort, label %mat_as, label %mat_al
mat_as:
  %hp4 = lshr i64 %hw0, 32
  %hp32 = trunc i64 %hp4 to i32
  store i32 %hp32, ptr %atmp, align 4
  %at4 = getelementptr inbounds i8, ptr %atmp, i64 4
  store i64 %hw1, ptr %at4, align 4
  br label %mat_b
mat_al:
  %hraw = and i64 %hw1, -4
  %hlp = inttoptr i64 %hraw to ptr
  br label %mat_b
mat_b:
  %hptr = phi ptr [ %atmp, %mat_as ], [ %hlp, %mat_al ]
  %nw1 = extractvalue %ArchxStr %needle, 1
  %nshort = icmp ule i64 %nlen, 12
  br i1 %nshort, label %mat_bs, label %mat_bl
mat_bs:
  %np4 = lshr i64 %nw0, 32
  %np32 = trunc i64 %np4 to i32
  store i32 %np32, ptr %btmp, align 4
  %bt4 = getelementptr inbounds i8, ptr %btmp, i64 4
  store i64 %nw1, ptr %bt4, align 4
  br label %loop_pre
mat_bl:
  %nraw = and i64 %nw1, -4
  %nlp = inttoptr i64 %nraw to ptr
  br label %loop_pre
loop_pre:
  %nptr = phi ptr [ %btmp, %mat_bs ], [ %nlp, %mat_bl ]
  %max_i = sub nuw nsw i64 %hlen, %nlen
  %first_b = load i8, ptr %nptr, align 1
  br label %loop
loop:
  %i = phi i64 [ 0, %loop_pre ], [ %inext, %step ]
  %hp = getelementptr inbounds i8, ptr %hptr, i64 %i
  %hb = load i8, ptr %hp, align 1
  %b_eq = icmp eq i8 %hb, %first_b
  br i1 %b_eq, label %do_mc, label %step
do_mc:
  %mc = call i32 @memcmp(ptr nonnull %hp, ptr nonnull %nptr, i64 %nlen)
  %hit = icmp eq i32 %mc, 0
  br i1 %hit, label %found, label %step
found:
  ret i64 %i
step:
  %inext = add nuw nsw i64 %i, 1
  %more = icmp ule i64 %inext, %max_i
  br i1 %more, label %loop, label %ret_neg1
ret_neg1:
  ret i64 -1
}

"#,
            );
        }

        if self.used_str_repeat {
            out.push_str(
                r#"
define private fastcc %ArchxStr @archx_str_repeat(%ArchxStr %s, i64 %n, ptr %reg) {
entry:
  %tmp = alloca [12 x i8], align 4
  %sbuf = alloca [64 x i8], align 8
  %nonpos = icmp sle i64 %n, 0
  br i1 %nonpos, label %ret_empty, label %chk_slen
ret_empty:
  ret %ArchxStr zeroinitializer
chk_slen:
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %slen = and i64 %w0, 4294967295
  %sz = icmp eq i64 %slen, 0
  br i1 %sz, label %ret_empty, label %calc_tot
calc_tot:
  %max_n = udiv i64 2147483647, %slen
  %ovf = icmp ugt i64 %n, %max_n
  br i1 %ovf, label %oom, label %mat
oom:
  call void @archx_oom_fail()
  unreachable
mat:
  %tot = mul nuw nsw i64 %slen, %n
  %short = icmp ule i64 %slen, 12
  br i1 %short, label %mat_s, label %mat_l
mat_s:
  %p4 = lshr i64 %w0, 32
  %p32 = trunc i64 %p4 to i32
  store i32 %p32, ptr %tmp, align 4
  %t4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %t4, align 4
  br label %alloc_buf
mat_l:
  %raw = and i64 %w1, -4
  %lp = inttoptr i64 %raw to ptr
  br label %alloc_buf
alloc_buf:
  %src = phi ptr [ %tmp, %mat_s ], [ %lp, %mat_l ]
  %fits = icmp ule i64 %tot, 64
  br i1 %fits, label %use_stack, label %use_heap
use_stack:
  br label %loop_pre
use_heap:
  %hp = call noalias ptr @malloc(i64 %tot)
  %hn = icmp eq ptr %hp, null
  br i1 %hn, label %oom, label %loop_pre
loop_pre:
  %dst = phi ptr [ %sbuf, %use_stack ], [ %hp, %use_heap ]
  %on_heap = phi i1 [ false, %use_stack ], [ true, %use_heap ]
  br label %loop
loop:
  %k = phi i64 [ 0, %loop_pre ], [ %knext, %loop ]
  %off = mul nuw nsw i64 %k, %slen
  %dp = getelementptr inbounds i8, ptr %dst, i64 %off
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dp, ptr nonnull align 1 %src, i64 %slen, i1 false)
  %knext = add nuw nsw i64 %k, 1
  %more = icmp slt i64 %knext, %n
  br i1 %more, label %loop, label %finish
finish:
  %res = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %dst, i64 %tot, ptr %reg)
  br i1 %on_heap, label %do_free, label %done
do_free:
  call void @free(ptr %dst)
  br label %done
done:
  ret %ArchxStr %res
}

"#,
            );
        }

        if self.used_str_replace {
            out.push_str(
                r#"
define private fastcc %ArchxStr @archx_str_replace(%ArchxStr %s, %ArchxStr %old, %ArchxStr %rep, ptr %reg) {
entry:
  %stmp = alloca [12 x i8], align 4
  %otmp = alloca [12 x i8], align 4
  %rtmp = alloca [12 x i8], align 4
  %sw0 = extractvalue %ArchxStr %s, 0
  %ow0 = extractvalue %ArchxStr %old, 0
  %rw0 = extractvalue %ArchxStr %rep, 0
  %slen = and i64 %sw0, 4294967295
  %olen = and i64 %ow0, 4294967295
  %rlen = and i64 %rw0, 4294967295
  %oz = icmp eq i64 %olen, 0
  br i1 %oz, label %fail_empty_old, label %mat_s
fail_empty_old:
  call void @archx_parse_fail()
  unreachable
mat_s:
  %sw1 = extractvalue %ArchxStr %s, 1
  %sshort = icmp ule i64 %slen, 12
  br i1 %sshort, label %mat_ss, label %mat_sl
mat_ss:
  %sp4 = lshr i64 %sw0, 32
  %sp32 = trunc i64 %sp4 to i32
  store i32 %sp32, ptr %stmp, align 4
  %st4 = getelementptr inbounds i8, ptr %stmp, i64 4
  store i64 %sw1, ptr %st4, align 4
  br label %mat_o
mat_sl:
  %sraw = and i64 %sw1, -4
  %slp = inttoptr i64 %sraw to ptr
  br label %mat_o
mat_o:
  %sptr = phi ptr [ %stmp, %mat_ss ], [ %slp, %mat_sl ]
  %ow1 = extractvalue %ArchxStr %old, 1
  %oshort = icmp ule i64 %olen, 12
  br i1 %oshort, label %mat_os, label %mat_ol
mat_os:
  %op4 = lshr i64 %ow0, 32
  %op32 = trunc i64 %op4 to i32
  store i32 %op32, ptr %otmp, align 4
  %ot4 = getelementptr inbounds i8, ptr %otmp, i64 4
  store i64 %ow1, ptr %ot4, align 4
  br label %mat_r
mat_ol:
  %oraw = and i64 %ow1, -4
  %olp = inttoptr i64 %oraw to ptr
  br label %mat_r
mat_r:
  %optr = phi ptr [ %otmp, %mat_os ], [ %olp, %mat_ol ]
  %rw1 = extractvalue %ArchxStr %rep, 1
  %rshort = icmp ule i64 %rlen, 12
  br i1 %rshort, label %mat_rs, label %mat_rl
mat_rs:
  %rp4 = lshr i64 %rw0, 32
  %rp32 = trunc i64 %rp4 to i32
  store i32 %rp32, ptr %rtmp, align 4
  %rt4 = getelementptr inbounds i8, ptr %rtmp, i64 4
  store i64 %rw1, ptr %rt4, align 4
  br label %init_buf
mat_rl:
  %rraw = and i64 %rw1, -4
  %rlp = inttoptr i64 %rraw to ptr
  br label %init_buf
init_buf:
  %rptr = phi ptr [ %rtmp, %mat_rs ], [ %rlp, %mat_rl ]
  %icap0 = add nuw nsw i64 %slen, 16
  %ibuf = call noalias ptr @malloc(i64 %icap0)
  %inull = icmp eq ptr %ibuf, null
  br i1 %inull, label %oom, label %loop
oom:
  call void @archx_oom_fail()
  unreachable
loop:
  %i = phi i64 [ 0, %init_buf ], [ %inext, %loop_latch ]
  %buf = phi ptr [ %ibuf, %init_buf ], [ %buf_l, %loop_latch ]
  %cap = phi i64 [ %icap0, %init_buf ], [ %cap_l, %loop_latch ]
  %dlen = phi i64 [ 0, %init_buf ], [ %dlen_l, %loop_latch ]
  %done = icmp uge i64 %i, %slen
  br i1 %done, label %finish, label %chk_rem
chk_rem:
  %rem = sub nuw i64 %slen, %i
  %can_match = icmp uge i64 %rem, %olen
  %sp_i = getelementptr inbounds i8, ptr %sptr, i64 %i
  br i1 %can_match, label %try_mc, label %emit_one
try_mc:
  %mc = call i32 @memcmp(ptr nonnull %sp_i, ptr nonnull %optr, i64 %olen)
  %hit = icmp eq i32 %mc, 0
  br i1 %hit, label %emit_rep, label %emit_one
emit_rep:
  %need_r = add nuw i64 %dlen, %rlen
  %big_r = icmp sgt i64 %need_r, 2147483647
  br i1 %big_r, label %oom, label %chk_rcap
chk_rcap:
  %grow_r = icmp ugt i64 %need_r, %cap
  br i1 %grow_r, label %do_rgrow, label %copy_rep
do_rgrow:
  %c2 = shl i64 %cap, 1
  %nc_r = select i1 true, i64 %c2, i64 %need_r
  %use_n = icmp ult i64 %nc_r, %need_r
  %fcap_r = select i1 %use_n, i64 %need_r, i64 %nc_r
  %nb_r = call ptr @realloc(ptr %buf, i64 %fcap_r)
  %nn_r = icmp eq ptr %nb_r, null
  br i1 %nn_r, label %oom, label %copy_rep
copy_rep:
  %buf_r = phi ptr [ %buf, %chk_rcap ], [ %nb_r, %do_rgrow ]
  %cap_r = phi i64 [ %cap, %chk_rcap ], [ %fcap_r, %do_rgrow ]
  %has_r = icmp ugt i64 %rlen, 0
  br i1 %has_r, label %do_rcpy, label %after_rep
do_rcpy:
  %dp_r = getelementptr inbounds i8, ptr %buf_r, i64 %dlen
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dp_r, ptr nonnull align 1 %rptr, i64 %rlen, i1 false)
  br label %after_rep
after_rep:
  %i_after_r = add nuw i64 %i, %olen
  br label %loop_latch
emit_one:
  %need_1 = add nuw i64 %dlen, 1
  %grow_1 = icmp ugt i64 %need_1, %cap
  br i1 %grow_1, label %do_1grow, label %copy_one
do_1grow:
  %fcap_1 = shl i64 %cap, 1
  %nb_1 = call ptr @realloc(ptr %buf, i64 %fcap_1)
  %nn_1 = icmp eq ptr %nb_1, null
  br i1 %nn_1, label %oom, label %copy_one
copy_one:
  %buf_1 = phi ptr [ %buf, %emit_one ], [ %nb_1, %do_1grow ]
  %cap_1 = phi i64 [ %cap, %emit_one ], [ %fcap_1, %do_1grow ]
  %ch1 = load i8, ptr %sp_i, align 1
  %dp_1 = getelementptr inbounds i8, ptr %buf_1, i64 %dlen
  store i8 %ch1, ptr %dp_1, align 1
  %i_after_1 = add nuw i64 %i, 1
  br label %loop_latch
loop_latch:
  %inext = phi i64 [ %i_after_r, %after_rep ], [ %i_after_1, %copy_one ]
  %buf_l = phi ptr [ %buf_r, %after_rep ], [ %buf_1, %copy_one ]
  %cap_l = phi i64 [ %cap_r, %after_rep ], [ %cap_1, %copy_one ]
  %dlen_l = phi i64 [ %need_r, %after_rep ], [ %need_1, %copy_one ]
  br label %loop
finish:
  %res = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %buf, i64 %dlen, ptr %reg)
  call void @free(ptr %buf)
  ret %ArchxStr %res
}

"#,
            );
        }

        if self.used_str_split_ws {
            out.push_str(
                r#"
define private fastcc %ArchxVec @archx_str_split_ws(%ArchxStr %s) {
entry:
  %tmp = alloca [12 x i8], align 4
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %slen = and i64 %w0, 4294967295
  %short = icmp ule i64 %slen, 12
  br i1 %short, label %mat_s, label %mat_l
mat_s:
  %p4 = lshr i64 %w0, 32
  %p32 = trunc i64 %p4 to i32
  store i32 %p32, ptr %tmp, align 4
  %t4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %t4, align 4
  br label %scan_pre
mat_l:
  %raw = and i64 %w1, -4
  %lp = inttoptr i64 %raw to ptr
  br label %scan_pre
scan_pre:
  %data = phi ptr [ %tmp, %mat_s ], [ %lp, %mat_l ]
  br label %skip_ws
skip_ws:
  %i = phi i64 [ 0, %scan_pre ], [ %i_ws, %ws_adv ], [ %j, %pushed ]
  %vptr = phi ptr [ null, %scan_pre ], [ %vptr, %ws_adv ], [ %vptr_next, %pushed ]
  %vlen = phi i64 [ 0, %scan_pre ], [ %vlen, %ws_adv ], [ %vlen_next, %pushed ]
  %vcap = phi i64 [ 0, %scan_pre ], [ %vcap, %ws_adv ], [ %vcap_next, %pushed ]
  %more = icmp ult i64 %i, %slen
  br i1 %more, label %chk_ws, label %done
chk_ws:
  %cp = getelementptr inbounds i8, ptr %data, i64 %i
  %c = load i8, ptr %cp, align 1
  %s1 = icmp eq i8 %c, 32
  %cs = sub i8 %c, 9
  %s2 = icmp ult i8 %cs, 5
  %is_ws = or i1 %s1, %s2
  br i1 %is_ws, label %ws_adv, label %tok_loop_pre
ws_adv:
  %i_ws = add nuw nsw i64 %i, 1
  br label %skip_ws
tok_loop_pre:
  br label %tok_loop
tok_loop:
  %j = phi i64 [ %i, %tok_loop_pre ], [ %jnext, %tok_adv ]
  %jmore = icmp ult i64 %j, %slen
  br i1 %jmore, label %tok_chk, label %emit_tok
tok_chk:
  %jp = getelementptr inbounds i8, ptr %data, i64 %j
  %jc = load i8, ptr %jp, align 1
  %js1 = icmp eq i8 %jc, 32
  %jcs = sub i8 %jc, 9
  %js2 = icmp ult i8 %jcs, 5
  %jws = or i1 %js1, %js2
  br i1 %jws, label %emit_tok, label %tok_adv
tok_adv:
  %jnext = add nuw nsw i64 %j, 1
  br label %tok_loop
emit_tok:
  %tptr = getelementptr inbounds i8, ptr %data, i64 %i
  %tlen = sub nuw nsw i64 %j, %i
  %elem = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %tptr, i64 %tlen, ptr null)
  %full = icmp sge i64 %vlen, %vcap
  br i1 %full, label %grow, label %store_elem
grow:
  %zc = icmp eq i64 %vcap, 0
  %dc = shl i64 %vcap, 1
  %ncap = select i1 %zc, i64 4, i64 %dc
  %bytes = shl i64 %ncap, 4
  %was_null = icmp eq ptr %vptr, null
  br i1 %was_null, label %gmalloc, label %grealloc
gmalloc:
  %mp = call noalias align 16 ptr @malloc(i64 %bytes)
  %mn = icmp eq ptr %mp, null
  br i1 %mn, label %oom, label %store_elem
grealloc:
  %rp = call align 16 ptr @realloc(ptr %vptr, i64 %bytes)
  %rn = icmp eq ptr %rp, null
  br i1 %rn, label %oom, label %store_elem
oom:
  call void @archx_oom_fail()
  unreachable
store_elem:
  %vptr_next = phi ptr [ %vptr, %emit_tok ], [ %mp, %gmalloc ], [ %rp, %grealloc ]
  %vcap_next = phi i64 [ %vcap, %emit_tok ], [ %ncap, %gmalloc ], [ %ncap, %grealloc ]
  %ep = getelementptr inbounds %ArchxStr, ptr %vptr_next, i64 %vlen
  store %ArchxStr %elem, ptr %ep, align 8
  %vlen_next = add nuw nsw i64 %vlen, 1
  br label %pushed
pushed:
  br label %skip_ws
done:
  %v0 = insertvalue %ArchxVec poison, i64 %vlen, 0
  %v1 = insertvalue %ArchxVec %v0, i64 %vcap, 1
  %v2 = insertvalue %ArchxVec %v1, ptr %vptr, 2
  ret %ArchxVec %v2
}

"#,
            );
        }

        if self.used_str_split_sep {
            out.push_str(
                r#"
define private fastcc %ArchxVec @archx_str_split_sep(%ArchxStr %s, %ArchxStr %sep) {
entry:
  %stmp = alloca [12 x i8], align 4
  %dtmp = alloca [12 x i8], align 4
  %sw0 = extractvalue %ArchxStr %s, 0
  %dw0 = extractvalue %ArchxStr %sep, 0
  %slen = and i64 %sw0, 4294967295
  %dlen = and i64 %dw0, 4294967295
  %dz = icmp eq i64 %dlen, 0
  br i1 %dz, label %fail, label %mat_s
fail:
  call void @archx_parse_fail()
  unreachable
mat_s:
  %sw1 = extractvalue %ArchxStr %s, 1
  %sshort = icmp ule i64 %slen, 12
  br i1 %sshort, label %mat_ss, label %mat_sl
mat_ss:
  %sp4 = lshr i64 %sw0, 32
  %sp32 = trunc i64 %sp4 to i32
  store i32 %sp32, ptr %stmp, align 4
  %st4 = getelementptr inbounds i8, ptr %stmp, i64 4
  store i64 %sw1, ptr %st4, align 4
  br label %mat_d
mat_sl:
  %sraw = and i64 %sw1, -4
  %slp = inttoptr i64 %sraw to ptr
  br label %mat_d
mat_d:
  %sptr = phi ptr [ %stmp, %mat_ss ], [ %slp, %mat_sl ]
  %dw1 = extractvalue %ArchxStr %sep, 1
  %dshort = icmp ule i64 %dlen, 12
  br i1 %dshort, label %mat_ds, label %mat_dl
mat_ds:
  %dp4 = lshr i64 %dw0, 32
  %dp32 = trunc i64 %dp4 to i32
  store i32 %dp32, ptr %dtmp, align 4
  %dt4 = getelementptr inbounds i8, ptr %dtmp, i64 4
  store i64 %dw1, ptr %dt4, align 4
  br label %init
mat_dl:
  %draw = and i64 %dw1, -4
  %dlp = inttoptr i64 %draw to ptr
  br label %init
init:
  %dptr = phi ptr [ %dtmp, %mat_ds ], [ %dlp, %mat_dl ]
  %iv = call noalias align 16 ptr @malloc(i64 64)
  %inull = icmp eq ptr %iv, null
  br i1 %inull, label %oom, label %loop
oom:
  call void @archx_oom_fail()
  unreachable
loop:
  %start = phi i64 [ 0, %init ], [ %next_start, %pushed ], [ %start, %no_hit ]
  %cur = phi i64 [ 0, %init ], [ %next_start, %pushed ], [ %cur_inc, %no_hit ]
  %vptr = phi ptr [ %iv, %init ], [ %vptr_p, %pushed ], [ %vptr, %no_hit ]
  %vlen = phi i64 [ 0, %init ], [ %vlen_p, %pushed ], [ %vlen, %no_hit ]
  %vcap = phi i64 [ 4, %init ], [ %vcap_p, %pushed ], [ %vcap, %no_hit ]
  %rem = sub i64 %slen, %cur
  %can = icmp sge i64 %rem, %dlen
  br i1 %can, label %try_mc, label %emit_last
try_mc:
  %cp = getelementptr inbounds i8, ptr %sptr, i64 %cur
  %mc = call i32 @memcmp(ptr nonnull %cp, ptr nonnull %dptr, i64 %dlen)
  %hit = icmp eq i32 %mc, 0
  br i1 %hit, label %emit_seg, label %no_hit
no_hit:
  %cur_inc = add nuw nsw i64 %cur, 1
  br label %loop
emit_seg:
  %seg_p = getelementptr inbounds i8, ptr %sptr, i64 %start
  %seg_l = sub nuw nsw i64 %cur, %start
  %elem = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %seg_p, i64 %seg_l, ptr null)
  %full = icmp sge i64 %vlen, %vcap
  br i1 %full, label %grow, label %store_seg
grow:
  %ncap = shl i64 %vcap, 1
  %bytes = shl i64 %ncap, 4
  %rp = call align 16 ptr @realloc(ptr %vptr, i64 %bytes)
  %rn = icmp eq ptr %rp, null
  br i1 %rn, label %oom, label %store_seg
store_seg:
  %vptr_p = phi ptr [ %vptr, %emit_seg ], [ %rp, %grow ]
  %vcap_p = phi i64 [ %vcap, %emit_seg ], [ %ncap, %grow ]
  %ep = getelementptr inbounds %ArchxStr, ptr %vptr_p, i64 %vlen
  store %ArchxStr %elem, ptr %ep, align 8
  %vlen_p = add nuw nsw i64 %vlen, 1
  %next_start = add nuw nsw i64 %cur, %dlen
  br label %pushed
pushed:
  br label %loop
emit_last:
  %last_p = getelementptr inbounds i8, ptr %sptr, i64 %start
  %last_l = sub nuw nsw i64 %slen, %start
  %lelem = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %last_p, i64 %last_l, ptr null)
  %lfull = icmp sge i64 %vlen, %vcap
  br i1 %lfull, label %lgrow, label %lstore
lgrow:
  %lncap = shl i64 %vcap, 1
  %lbytes = shl i64 %lncap, 4
  %lrp = call align 16 ptr @realloc(ptr %vptr, i64 %lbytes)
  %lrn = icmp eq ptr %lrp, null
  br i1 %lrn, label %oom, label %lstore
lstore:
  %fvptr = phi ptr [ %vptr, %emit_last ], [ %lrp, %lgrow ]
  %fvcap = phi i64 [ %vcap, %emit_last ], [ %lncap, %lgrow ]
  %lep = getelementptr inbounds %ArchxStr, ptr %fvptr, i64 %vlen
  store %ArchxStr %lelem, ptr %lep, align 8
  %fvlen = add nuw nsw i64 %vlen, 1
  %v0 = insertvalue %ArchxVec poison, i64 %fvlen, 0
  %v1 = insertvalue %ArchxVec %v0, i64 %fvcap, 1
  %v2 = insertvalue %ArchxVec %v1, ptr %fvptr, 2
  ret %ArchxVec %v2
}

"#,
            );
        }

        if self.used_neg_exp_fail {
            emit_cstr_global(
                out,
                "@.err.negexp",
                "archx runtime panic: negative exponent in integer `**` (convert to `float` first)\n",
            );
            out.push_str(
                r#"
define private void @archx_neg_exp_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.negexp)
  call void @exit(i32 101)
  unreachable
}

"#,
            );
        }

        if self.used_zero_step_fail {
            emit_cstr_global(
                out,
                "@.err.zstep",
                "archx runtime panic: `range()` step argument must not be zero\n",
            );
            out.push_str(
                r#"
define private void @archx_zero_step_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.zstep)
  call void @exit(i32 101)
  unreachable
}

"#,
            );
        }

        if self.used_parse_fail {
            emit_cstr_global(
                out,
                "@.err.parse",
                "archx runtime panic: ValueError in string/character conversion\n",
            );
            out.push_str(
                r#"
define private void @archx_parse_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.parse)
  call void @exit(i32 101)
  unreachable
}

"#,
            );
        }

        if self.used_assert_fail {
            emit_cstr_global(
                out,
                "@.err.assert.nomsg",
                "archx runtime panic: AssertionError at line %lld\n",
            );
            emit_cstr_global(
                out,
                "@.err.assert.pre",
                "archx runtime panic: AssertionError at line %lld: ",
            );
            out.push_str(
                r#"
define private void @archx_assert_fail(%ArchxStr %msg, i1 %has_msg, i64 %line) cold noreturn {
entry:
  br i1 %has_msg, label %with_msg, label %no_msg
with_msg:
  %c1 = call i32 (ptr, ...) @printf(ptr @.err.assert.pre, i64 %line)
  call fastcc void @archx_str_print(%ArchxStr %msg, i1 true)
  call void @exit(i32 101)
  unreachable
no_msg:
  %c2 = call i32 (ptr, ...) @printf(ptr @.err.assert.nomsg, i64 %line)
  call void @exit(i32 101)
  unreachable
}

"#,
            );
        }

        if self.used_print_float || self.used_str_from_float || self.used_str_from_int {
            out.push_str("declare i32 @sprintf(ptr nocapture writeonly, ptr nocapture readonly, ...) nounwind\n");
        }
        if self.used_float_from_str {
            out.push_str("declare double @strtod(ptr nocapture readonly, ptr nocapture writeonly) nounwind\n");
        }
        if self.used_input {
            out.push_str("declare i32 @getchar()\n");
            out.push_str("declare i32 @fflush(ptr)\n");
        }
        if self.used_pow_f64 {
            out.push_str("declare double @llvm.pow.f64(double, double) nounwind readnone speculatable\n");
        }
        if self.used_floor_f64 {
            out.push_str("declare double @llvm.floor.f64(double) nounwind readnone speculatable\n");
        }
        if self.used_fabs_f64 {
            out.push_str("declare double @llvm.fabs.f64(double) nounwind readnone speculatable\n");
        }
        if self.used_sqrt_f64 {
            out.push_str("declare double @llvm.sqrt.f64(double) nounwind readnone speculatable\n");
        }
        if self.used_fptosi_sat {
            out.push_str("declare i64 @llvm.fptosi.sat.i64.f64(double) nounwind readnone speculatable\n");
        }
    }
}
