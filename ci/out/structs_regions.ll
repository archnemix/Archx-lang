; Archx LLVM IR module

%ArchxVec = type { i64, i64, ptr }
%ArchxStr = type { i64, i64 }
%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxStruct_Body = type { i64, i64, i64, i64 }

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1

define internal fastcc i64 @archx_fn_advance(i64 %arg.n, i64 %arg.steps) {
entry:
  %for.i.29 = alloca i64, align 8
  %for.t.42 = alloca i64, align 8
  %for.i.45 = alloca i64, align 8
  %for.i.64 = alloca i64, align 8
  %var.total.75 = alloca i64, align 8
  %foreach.idx.76 = alloca i64, align 8
  %t0 = icmp ugt i64 %arg.n, 140737488355328
  br i1 %t0, label %repeat.bad.1, label %repeat.ok.0
repeat.bad.1:
  call void @archx_neg_len_fail(i64 %arg.n)
  unreachable
repeat.ok.0:
  %t1 = icmp eq i64 %arg.n, 0
  %t2 = select i1 %t1, i64 1, i64 %arg.n
  %t3 = call noalias align 16 ptr @calloc(i64 %t2, i64 8)
  %t4 = icmp eq ptr %t3, null
  br i1 %t4, label %calloc.oom.3, label %calloc.ok.2
calloc.oom.3:
  call void @archx_oom_fail()
  unreachable
calloc.ok.2:
  %t5 = icmp eq i64 %arg.n, 0
  %t6 = select i1 %t5, i64 1, i64 %arg.n
  %t7 = call noalias align 16 ptr @calloc(i64 %t6, i64 8)
  %t8 = icmp eq ptr %t7, null
  br i1 %t8, label %calloc.oom.5, label %calloc.ok.4
calloc.oom.5:
  call void @archx_oom_fail()
  unreachable
calloc.ok.4:
  %t9 = mul nuw nsw i64 %arg.n, 8
  %t10 = icmp eq i64 %t9, 0
  %t11 = select i1 %t10, i64 1, i64 %t9
  %t12 = call noalias align 16 ptr @malloc(i64 %t11)
  %t13 = icmp eq ptr %t12, null
  br i1 %t13, label %alloc.oom.7, label %alloc.ok.6
alloc.oom.7:
  call void @archx_oom_fail()
  unreachable
alloc.ok.6:
  %t14 = icmp sgt i64 %arg.n, 0
  br i1 %t14, label %fill.pre.8, label %fill.end.10
fill.pre.8:
  br label %fill.body.9
fill.body.9:
  %t15 = phi i64 [ 0, %fill.pre.8 ], [ %t16, %fill.body.9 ]
  %t17 = getelementptr inbounds i64, ptr %t12, i64 %t15
  store i64 1, ptr %t17, align 8
  %t16 = add nuw nsw i64 %t15, 1
  %t18 = icmp slt i64 %t16, %arg.n
  br i1 %t18, label %fill.body.9, label %fill.end.10
fill.end.10:
  %t19 = mul nuw nsw i64 %arg.n, 8
  %t20 = icmp eq i64 %t19, 0
  %t21 = select i1 %t20, i64 1, i64 %t19
  %t22 = call noalias align 16 ptr @malloc(i64 %t21)
  %t23 = icmp eq ptr %t22, null
  br i1 %t23, label %alloc.oom.12, label %alloc.ok.11
alloc.oom.12:
  call void @archx_oom_fail()
  unreachable
alloc.ok.11:
  %t24 = icmp sgt i64 %arg.n, 0
  br i1 %t24, label %fill.pre.13, label %fill.end.15
fill.pre.13:
  br label %fill.body.14
fill.body.14:
  %t25 = phi i64 [ 0, %fill.pre.13 ], [ %t26, %fill.body.14 ]
  %t27 = getelementptr inbounds i64, ptr %t22, i64 %t25
  store i64 2, ptr %t27, align 8
  %t26 = add nuw nsw i64 %t25, 1
  %t28 = icmp slt i64 %t26, %arg.n
  br i1 %t28, label %fill.body.14, label %fill.end.15
fill.end.15:
  store i64 0, ptr %for.i.29, align 8
  br label %for.cond.16
for.cond.16:
  %t30 = load i64, ptr %for.i.29, align 8
  %t31 = icmp slt i64 %t30, %arg.n
  br i1 %t31, label %for.body.17, label %for.end.19
for.body.17:
  %t32 = load i64, ptr %for.i.29, align 8
  %t33 = getelementptr inbounds i64, ptr %t3, i64 %t32
  %t34 = load i64, ptr %for.i.29, align 8
  %t35 = mul i64 %t34, 2
  store i64 %t35, ptr %t33, align 8
  %t36 = load i64, ptr %for.i.29, align 8
  %t37 = getelementptr inbounds i64, ptr %t7, i64 %t36
  %t38 = load i64, ptr %for.i.29, align 8
  %t39 = mul i64 %t38, 3
  store i64 %t39, ptr %t37, align 8
  br label %for.step.18
for.step.18:
  %t40 = load i64, ptr %for.i.29, align 8
  %t41 = add nsw i64 %t40, 1
  store i64 %t41, ptr %for.i.29, align 8
  br label %for.cond.16
for.end.19:
  store i64 0, ptr %for.t.42, align 8
  br label %for.cond.20
for.cond.20:
  %t43 = load i64, ptr %for.t.42, align 8
  %t44 = icmp slt i64 %t43, %arg.steps
  br i1 %t44, label %for.body.21, label %for.end.23
for.body.21:
  store i64 0, ptr %for.i.45, align 8
  br label %for.cond.24
for.cond.24:
  %t46 = load i64, ptr %for.i.45, align 8
  %t47 = icmp slt i64 %t46, %arg.n
  br i1 %t47, label %for.body.25, label %for.end.27
for.body.25:
  %t48 = load i64, ptr %for.i.45, align 8
  %t49 = getelementptr inbounds i64, ptr %t3, i64 %t48
  %t50 = load i64, ptr %t49, align 8
  %t51 = load i64, ptr %for.i.45, align 8
  %t52 = getelementptr inbounds i64, ptr %t12, i64 %t51
  %t53 = load i64, ptr %t52, align 8
  %t54 = add i64 %t50, %t53
  store i64 %t54, ptr %t49, align 8
  %t55 = load i64, ptr %for.i.45, align 8
  %t56 = getelementptr inbounds i64, ptr %t7, i64 %t55
  %t57 = load i64, ptr %t56, align 8
  %t58 = load i64, ptr %for.i.45, align 8
  %t59 = getelementptr inbounds i64, ptr %t22, i64 %t58
  %t60 = load i64, ptr %t59, align 8
  %t61 = add i64 %t57, %t60
  store i64 %t61, ptr %t56, align 8
  br label %for.step.26
for.step.26:
  %t62 = load i64, ptr %for.i.45, align 8
  %t63 = add nsw i64 %t62, 1
  store i64 %t63, ptr %for.i.45, align 8
  br label %for.cond.24
for.end.27:
  store i64 0, ptr %for.i.64, align 8
  br label %for.cond.28
for.cond.28:
  %t65 = load i64, ptr %for.i.64, align 8
  %t66 = icmp slt i64 %t65, %arg.n
  br i1 %t66, label %for.body.29, label %for.end.31
for.body.29:
  %t67 = load i64, ptr %for.i.64, align 8
  %t68 = getelementptr inbounds i64, ptr %t12, i64 %t67
  %t69 = load i64, ptr %t68, align 8
  %t70 = add i64 %t69, 1
  store i64 %t70, ptr %t68, align 8
  br label %for.step.30
for.step.30:
  %t71 = load i64, ptr %for.i.64, align 8
  %t72 = add nsw i64 %t71, 4
  store i64 %t72, ptr %for.i.64, align 8
  br label %for.cond.28
for.end.31:
  br label %for.step.22
for.step.22:
  %t73 = load i64, ptr %for.t.42, align 8
  %t74 = add nsw i64 %t73, 1
  store i64 %t74, ptr %for.t.42, align 8
  br label %for.cond.20
for.end.23:
  store i64 0, ptr %var.total.75, align 8
  store i64 0, ptr %foreach.idx.76, align 8
  br label %foreach.cond.32
foreach.cond.32:
  %t77 = load i64, ptr %foreach.idx.76, align 8
  %t78 = icmp slt i64 %t77, %arg.n
  br i1 %t78, label %foreach.body.33, label %foreach.end.35
foreach.body.33:
  %t79 = getelementptr inbounds i64, ptr %t3, i64 %t77
  %t80 = load i64, ptr %t79, align 8
  %t81 = insertvalue %ArchxStruct_Body poison, i64 %t80, 0
  %t82 = getelementptr inbounds i64, ptr %t7, i64 %t77
  %t83 = load i64, ptr %t82, align 8
  %t84 = insertvalue %ArchxStruct_Body %t81, i64 %t83, 1
  %t85 = getelementptr inbounds i64, ptr %t12, i64 %t77
  %t86 = load i64, ptr %t85, align 8
  %t87 = insertvalue %ArchxStruct_Body %t84, i64 %t86, 2
  %t88 = getelementptr inbounds i64, ptr %t22, i64 %t77
  %t89 = load i64, ptr %t88, align 8
  %t90 = insertvalue %ArchxStruct_Body %t87, i64 %t89, 3
  %t91 = load i64, ptr %var.total.75, align 8
  %t92 = extractvalue %ArchxStruct_Body %t90, 0
  %t93 = extractvalue %ArchxStruct_Body %t90, 1
  %t94 = add i64 %t92, %t93
  %t95 = add i64 %t91, %t94
  store i64 %t95, ptr %var.total.75, align 8
  br label %foreach.step.34
foreach.step.34:
  %t96 = load i64, ptr %foreach.idx.76, align 8
  %t97 = add nsw i64 %t96, 1
  store i64 %t97, ptr %foreach.idx.76, align 8
  br label %foreach.cond.32
foreach.end.35:
  %t98 = load i64, ptr %var.total.75, align 8
  call void @free(ptr %t22)
  call void @free(ptr %t12)
  call void @free(ptr %t7)
  call void @free(ptr %t3)
  ret i64 %t98
}

define internal fastcc %ArchxStr @archx_fn_format_report(%ArchxStr %arg.label, i64 %arg.score) {
entry:
  %func.region = alloca %ArchxRegion, align 8
  %for.i.21 = alloca i64, align 8
  %var.tag.31 = alloca %ArchxStr, align 8
  %bool.result.36 = alloca i1, align 1
  store %ArchxRegion zeroinitializer, ptr %func.region, align 8
  %t0 = load ptr, ptr %func.region, align 8
  %t1 = getelementptr inbounds %ArchxRegion, ptr %func.region, i32 0, i32 1
  %t2 = load ptr, ptr %t1, align 8
  %t3 = getelementptr inbounds %ArchxRegion, ptr %func.region, i32 0, i32 3
  %t4 = load ptr, ptr %t3, align 8
  %t5 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 64, i64 8)
  %t6 = extractvalue { i64, i1 } %t5, 0
  %t7 = extractvalue { i64, i1 } %t5, 1
  br i1 %t7, label %mul.oom.0, label %mul.ok.1
mul.oom.0:
  call void @archx_oom_fail()
  unreachable
mul.ok.1:
  %t8 = icmp eq i64 %t6, 0
  %t9 = select i1 %t8, i64 1, i64 %t6
  %t10 = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %func.region, i64 %t9)
  %t11 = sub nsw i64 0, 64
  %t12 = icmp sgt i64 64, 0
  br i1 %t12, label %fill.pre.2, label %fill.end.4
fill.pre.2:
  br label %fill.body.3
fill.body.3:
  %t13 = phi i64 [ 0, %fill.pre.2 ], [ %t14, %fill.body.3 ]
  %t15 = getelementptr inbounds i64, ptr %t10, i64 %t13
  store i64 1, ptr %t15, align 8
  %t14 = add nuw nsw i64 %t13, 1
  %t16 = icmp slt i64 %t14, 64
  br i1 %t16, label %fill.body.3, label %fill.end.4
fill.end.4:
  %t17 = insertvalue %ArchxVec poison, i64 64, 0
  %t18 = insertvalue %ArchxVec %t17, i64 %t11, 1
  %t19 = insertvalue %ArchxVec %t18, ptr %t10, 2
  %t20 = call fastcc %ArchxVec @archx_vec_clone_i(%ArchxVec %t19)
  store i64 0, ptr %for.i.21, align 8
  br label %for.cond.5
for.cond.5:
  %t22 = load i64, ptr %for.i.21, align 8
  %t23 = icmp slt i64 %t22, 64
  br i1 %t23, label %for.body.6, label %for.end.8
for.body.6:
  %t24 = load i64, ptr %for.i.21, align 8
  %t25 = extractvalue %ArchxVec %t20, 2
  %t26 = getelementptr inbounds i64, ptr %t25, i64 %t24
  store i64 %arg.score, ptr %t26, align 8
  br label %for.step.7
for.step.7:
  %t27 = load i64, ptr %for.i.21, align 8
  %t28 = add nsw i64 %t27, 2
  store i64 %t28, ptr %for.i.21, align 8
  br label %for.cond.5
for.end.8:
  %t29 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 8030029675902271495, i64 3830898 }, %ArchxStr %arg.label, ptr %func.region)
  %t30 = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %t29)
  store %ArchxStr %t30, ptr %var.tag.31, align 8
  %t32 = extractvalue %ArchxVec %t20, 2
  %t33 = getelementptr inbounds i64, ptr %t32, i64 0
  %t34 = load i64, ptr %t33, align 8
  %t35 = icmp eq i64 %t34, %arg.score
  store i1 false, ptr %bool.result.36, align 1
  br i1 %t35, label %bool.rhs.9, label %bool.merge.10
bool.rhs.9:
  %t37 = load %ArchxStr, ptr %var.tag.31, align 8
  %t38 = extractvalue %ArchxStr %t37, 0
  %t39 = and i64 %t38, 4294967295
  %t40 = icmp sgt i64 %t39, 7
  store i1 %t40, ptr %bool.result.36, align 1
  br label %bool.merge.10
bool.merge.10:
  %t41 = load i1, ptr %bool.result.36, align 1
  br i1 %t41, label %if.then.11, label %if.else.12
if.then.11:
  %t42 = load %ArchxStr, ptr %var.tag.31, align 8
  %t43 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t42, %ArchxStr { i64 30240117406826499, i64 0 }, ptr %func.region)
  %t44 = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %t43)
  %t45 = call fastcc %ArchxStr @archx_str_promote(%ArchxStr %t44)
  %t46 = load %ArchxStr, ptr %var.tag.31, align 8
  call fastcc void @archx_str_drop(%ArchxStr %t46)
  %t47 = getelementptr inbounds %ArchxRegion, ptr %func.region, i32 0, i32 2
  %t48 = load ptr, ptr %t47, align 8
  call fastcc void @archx_region_release_from(ptr %t48)
  ret %ArchxStr %t45
if.else.12:
  br label %if.merge.13
if.merge.13:
  %t49 = load %ArchxStr, ptr %var.tag.31, align 8
  call fastcc void @archx_str_drop(%ArchxStr %t49)
  store ptr %t0, ptr %func.region, align 8
  %t50 = getelementptr inbounds %ArchxRegion, ptr %func.region, i32 0, i32 1
  store ptr %t2, ptr %t50, align 8
  %t51 = getelementptr inbounds %ArchxRegion, ptr %func.region, i32 0, i32 3
  store ptr %t4, ptr %t51, align 8
  %t52 = getelementptr inbounds %ArchxRegion, ptr %func.region, i32 0, i32 2
  %t53 = load ptr, ptr %t52, align 8
  call fastcc void @archx_region_release_from(ptr %t53)
  ret %ArchxStr { i64 7310026593965965323, i64 28548142444602209 }
}

define i32 @main() {
entry:
  %t0 = call fastcc i64 @archx_fn_advance(i64 32, i64 5)
  %t1 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t0)
  %t2 = call fastcc %ArchxStr @archx_fn_format_report(%ArchxStr { i64 7308332212187824138, i64 58709760767091 }, i64 %t0)
  call fastcc void @archx_str_print(%ArchxStr %t2, i1 true)
  call fastcc void @archx_str_drop(%ArchxStr %t2)
  ret i32 0
}

define private fastcc %ArchxVec @archx_vec_clone_i(%ArchxVec %v) {
entry:
  %len = extractvalue %ArchxVec %v, 0
  %src = extractvalue %ArchxVec %v, 2
  %empty = icmp sle i64 %len, 0
  br i1 %empty, label %ret.empty, label %alloc
ret.empty:
  ret %ArchxVec zeroinitializer
alloc:
  %t0 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %len, i64 8)
  %t1 = extractvalue { i64, i1 } %t0, 0
  %t2 = extractvalue { i64, i1 } %t0, 1
  br i1 %t2, label %mul.oom.0, label %mul.ok.1
mul.oom.0:
  call void @archx_oom_fail()
  unreachable
mul.ok.1:
  %t3 = icmp eq i64 %t1, 0
  %t4 = select i1 %t3, i64 1, i64 %t1
  %t5 = call noalias align 16 ptr @malloc(i64 %t4)
  %t6 = icmp eq ptr %t5, null
  br i1 %t6, label %alloc.oom.3, label %alloc.ok.2
alloc.oom.3:
  call void @archx_oom_fail()
  unreachable
alloc.ok.2:
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %t5, ptr nonnull align 1 %src, i64 %t4, i1 false)
  br label %finish
finish:
  %t7 = insertvalue %ArchxVec poison, i64 %len, 0
  %t8 = insertvalue %ArchxVec %t7, i64 %len, 1
  %t9 = insertvalue %ArchxVec %t8, ptr %t5, 2
  ret %ArchxVec %t9
}

define private fastcc void @archx_region_release_from(ptr %first) nounwind {
entry:
  %empty = icmp eq ptr %first, null
  br i1 %empty, label %done, label %loop
loop:
  %cur = phi ptr [ %first, %entry ], [ %next, %loop ]
  %next = load ptr, ptr %cur, align 8
  call void @free(ptr %cur)
  %more = icmp ne ptr %next, null
  br i1 %more, label %loop, label %done
done:
  ret void
}

define private fastcc noalias nonnull align 16 ptr @archx_region_alloc_slow(ptr %reg, i64 %aligned) noinline {
entry:
  %min_body = icmp slt i64 %aligned, 65536
  %body_sz = select i1 %min_body, i64 65536, i64 %aligned
  %ovf_chk = icmp sgt i64 %body_sz, 9223372036854775791
  br i1 %ovf_chk, label %oom, label %do_malloc
do_malloc:
  %tot = add nuw nsw i64 %body_sz, 16
  %blk = call noalias align 16 ptr @malloc(i64 %tot)
  %isnull = icmp eq ptr %blk, null
  br i1 %isnull, label %oom, label %ok
oom:
  call void @archx_oom_fail()
  unreachable
ok:
  store ptr null, ptr %blk, align 8
  %cap_ptr = getelementptr inbounds i8, ptr %blk, i64 8
  store i64 %body_sz, ptr %cap_ptr, align 8
  %head_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 2
  %tail_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 3
  %old_tail = load ptr, ptr %tail_slot, align 8
  %has_tail = icmp ne ptr %old_tail, null
  br i1 %has_tail, label %link_tail, label %link_head
link_tail:
  store ptr %blk, ptr %old_tail, align 8
  br label %finish
link_head:
  store ptr %blk, ptr %head_slot, align 8
  br label %finish
finish:
  store ptr %blk, ptr %tail_slot, align 8
  %data = getelementptr inbounds i8, ptr %blk, i64 16
  %new_cur = getelementptr inbounds i8, ptr %data, i64 %aligned
  %new_end = getelementptr inbounds i8, ptr %data, i64 %body_sz
  %cur_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 0
  %end_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 1
  store ptr %new_cur, ptr %cur_slot, align 8
  store ptr %new_end, ptr %end_slot, align 8
  ret ptr %data
}

define private fastcc noalias nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %size) alwaysinline {
entry:
  %z = icmp sle i64 %size, 0
  %sz = select i1 %z, i64 16, i64 %size
  %too_big = icmp sgt i64 %sz, 9223372036854775776
  br i1 %too_big, label %oom, label %align_ok
oom:
  call void @archx_oom_fail()
  unreachable
align_ok:
  %a1 = add nuw nsw i64 %sz, 15
  %aligned = and i64 %a1, -16
  %cur_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 0
  %end_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 1
  %cur = load ptr, ptr %cur_slot, align 8
  %end = load ptr, ptr %end_slot, align 8
  %cur_i = ptrtoint ptr %cur to i64
  %end_i = ptrtoint ptr %end to i64
  %rem = sub i64 %end_i, %cur_i
  %fits = icmp sge i64 %rem, %aligned
  br i1 %fits, label %fast, label %check_reuse
fast:
  %next = getelementptr inbounds i8, ptr %cur, i64 %aligned
  store ptr %next, ptr %cur_slot, align 8
  ret ptr %cur
check_reuse:
  %tail_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 3
  %tail = load ptr, ptr %tail_slot, align 8
  %has_tail = icmp ne ptr %tail, null
  br i1 %has_tail, label %try_next_blk, label %try_head_blk
try_head_blk:
  %head_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 2
  %head = load ptr, ptr %head_slot, align 8
  br label %inspect_cand
try_next_blk:
  %tnext = load ptr, ptr %tail, align 8
  br label %inspect_cand
inspect_cand:
  %cand = phi ptr [ %head, %try_head_blk ], [ %tnext, %try_next_blk ]
  %has_cand = icmp ne ptr %cand, null
  br i1 %has_cand, label %check_cand_cap, label %slow
check_cand_cap:
  %ccap_ptr = getelementptr inbounds i8, ptr %cand, i64 8
  %ccap = load i64, ptr %ccap_ptr, align 8
  %cfits = icmp sge i64 %ccap, %aligned
  br i1 %cfits, label %reuse_cand, label %drop_stale_chain
reuse_cand:
  store ptr %cand, ptr %tail_slot, align 8
  %cdata = getelementptr inbounds i8, ptr %cand, i64 16
  %ccur = getelementptr inbounds i8, ptr %cdata, i64 %aligned
  %cend = getelementptr inbounds i8, ptr %cdata, i64 %ccap
  store ptr %ccur, ptr %cur_slot, align 8
  store ptr %cend, ptr %end_slot, align 8
  ret ptr %cdata
drop_stale_chain:
  br i1 %has_tail, label %unlink_from_tail, label %unlink_from_head
unlink_from_tail:
  store ptr null, ptr %tail, align 8
  br label %free_cand
unlink_from_head:
  %hs2 = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 2
  store ptr null, ptr %hs2, align 8
  br label %free_cand
free_cand:
  call fastcc void @archx_region_release_from(ptr %cand)
  br label %slow
slow:
  %res = call fastcc nonnull align 16 ptr @archx_region_alloc_slow(ptr %reg, i64 %aligned)
  ret ptr %res
}

define private fastcc void @archx_str_drop(%ArchxStr %s) alwaysinline nounwind {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %len = and i64 %w0, 4294967295
  %long = icmp ugt i64 %len, 12
  br i1 %long, label %chk_tag, label %done
chk_tag:
  %w1 = extractvalue %ArchxStr %s, 1
  %tag = and i64 %w1, 1
  %owned = icmp ne i64 %tag, 0
  br i1 %owned, label %do_free, label %done
do_free:
  %raw = and i64 %w1, -2
  %ptr = inttoptr i64 %raw to ptr
  call void @free(ptr %ptr)
  br label %done
done:
  ret void
}

define private fastcc %ArchxStr @archx_str_clone(%ArchxStr %s) {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %len = and i64 %w0, 4294967295
  %long = icmp ugt i64 %len, 12
  br i1 %long, label %chk_tag, label %ret_same
chk_tag:
  %w1 = extractvalue %ArchxStr %s, 1
  %tag = and i64 %w1, 1
  %owned = icmp ne i64 %tag, 0
  br i1 %owned, label %dup_heap, label %ret_same
dup_heap:
  %src_i = and i64 %w1, -2
  %src = inttoptr i64 %src_i to ptr
  %dst = call noalias align 16 ptr @malloc(i64 %len)
  %isnull = icmp eq ptr %dst, null
  br i1 %isnull, label %oom, label %copy
oom:
  call void @archx_oom_fail()
  unreachable
copy:
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst, ptr nonnull align 1 %src, i64 %len, i1 false)
  %dst_i = ptrtoint ptr %dst to i64
  %tagged = or i64 %dst_i, 1
  %out = insertvalue %ArchxStr %s, i64 %tagged, 1
  ret %ArchxStr %out
ret_same:
  ret %ArchxStr %s
}

define private fastcc %ArchxStr @archx_str_promote(%ArchxStr %s) {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %len = and i64 %w0, 4294967295
  %long = icmp ugt i64 %len, 12
  br i1 %long, label %chk_reg, label %ret_same
chk_reg:
  %w1 = extractvalue %ArchxStr %s, 1
  %tag = and i64 %w1, 3
  %is_reg = icmp eq i64 %tag, 2
  br i1 %is_reg, label %dup_heap, label %ret_same
dup_heap:
  %src_i = and i64 %w1, -4
  %src = inttoptr i64 %src_i to ptr
  %dst = call noalias align 16 ptr @malloc(i64 %len)
  %isnull = icmp eq ptr %dst, null
  br i1 %isnull, label %oom, label %copy
oom:
  call void @archx_oom_fail()
  unreachable
copy:
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst, ptr nonnull align 1 %src, i64 %len, i1 false)
  %dst_i = ptrtoint ptr %dst to i64
  %tagged = or i64 %dst_i, 1
  %out = insertvalue %ArchxStr %s, i64 %tagged, 1
  ret %ArchxStr %out
ret_same:
  ret %ArchxStr %s
}

@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@.fmt.pstr = private unnamed_addr constant [5 x i8] c"%.*s\00", align 1

define private fastcc void @archx_str_print(%ArchxStr %s, i1 %newline) {
entry:
  %tmp = alloca [12 x i8], align 4
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %short = icmp ule i64 %len, 12
  br i1 %short, label %prep_short, label %prep_long
prep_short:
  %p4 = lshr i64 %w0, 32
  %p4_32 = trunc i64 %p4 to i32
  store i32 %p4_32, ptr %tmp, align 4
  %tmp4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %tmp4, align 4
  br label %emit
prep_long:
  %raw = and i64 %w1, -4
  %lptr = inttoptr i64 %raw to ptr
  br label %emit
emit:
  %data = phi ptr [ %tmp, %prep_short ], [ %lptr, %prep_long ]
  %pos = icmp ugt i64 %len, 0
  br i1 %pos, label %chk_nul, label %chk_nl
chk_nul:
  %nul = call ptr @memchr(ptr nonnull %data, i32 0, i64 %len)
  %has_nul = icmp ne ptr %nul, null
  br i1 %has_nul, label %byte_loop_pre, label %fast_printf
fast_printf:
  %len32 = trunc i64 %len to i32
  %fmt = select i1 %newline, ptr @.fmt.pstr.nl, ptr @.fmt.pstr
  %np = call i32 (ptr, ...) @printf(ptr %fmt, i32 %len32, ptr nonnull %data)
  ret void
byte_loop_pre:
  br label %byte_loop
byte_loop:
  %bi = phi i64 [ 0, %byte_loop_pre ], [ %bnext, %byte_loop ]
  %bp = getelementptr inbounds i8, ptr %data, i64 %bi
  %ch8 = load i8, ptr %bp, align 1
  %ch32 = zext i8 %ch8 to i32
  %pc = call i32 @putchar(i32 %ch32)
  %bnext = add nuw nsw i64 %bi, 1
  %bmore = icmp ult i64 %bnext, %len
  br i1 %bmore, label %byte_loop, label %chk_nl
chk_nl:
  br i1 %newline, label %do_nl, label %done
do_nl:
  %nc = call i32 @putchar(i32 10)
  br label %done
done:
  ret void
}

define private fastcc %ArchxStr @archx_str_concat(%ArchxStr %a, %ArchxStr %b, ptr %reg) {
entry:
  %atmp = alloca [12 x i8], align 4
  %btmp = alloca [12 x i8], align 4
  %out_sso = alloca [16 x i8], align 8
  %aw0 = extractvalue %ArchxStr %a, 0
  %aw1 = extractvalue %ArchxStr %a, 1
  %bw0 = extractvalue %ArchxStr %b, 0
  %bw1 = extractvalue %ArchxStr %b, 1
  %alen = and i64 %aw0, 4294967295
  %blen = and i64 %bw0, 4294967295
  %az = icmp eq i64 %alen, 0
  br i1 %az, label %ret_b, label %chk_bz
ret_b:
  %b_in_reg = icmp ne ptr %reg, null
  br i1 %b_in_reg, label %ret_b_raw, label %ret_b_clone
ret_b_raw:
  %bw1_tag = and i64 %bw1, 1
  %b_owned = icmp ne i64 %bw1_tag, 0
  br i1 %b_owned, label %ret_b_clone, label %ret_b_direct
ret_b_direct:
  ret %ArchxStr %b
ret_b_clone:
  %bc = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %b)
  ret %ArchxStr %bc
chk_bz:
  %bz = icmp eq i64 %blen, 0
  br i1 %bz, label %ret_a, label %calc_tot
ret_a:
  %a_in_reg = icmp ne ptr %reg, null
  br i1 %a_in_reg, label %ret_a_raw, label %ret_a_clone
ret_a_raw:
  %aw1_tag = and i64 %aw1, 1
  %a_owned = icmp ne i64 %aw1_tag, 0
  br i1 %a_owned, label %ret_a_clone, label %ret_a_direct
ret_a_direct:
  ret %ArchxStr %a
ret_a_clone:
  %ac = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %a)
  ret %ArchxStr %ac
calc_tot:
  %tot = add nuw nsw i64 %alen, %blen
  %too_big = icmp sgt i64 %tot, 2147483647
  br i1 %too_big, label %oom, label %mat_a
oom:
  call void @archx_oom_fail()
  unreachable
mat_a:
  %ashort = icmp ule i64 %alen, 12
  br i1 %ashort, label %mat_a_short, label %mat_a_long
mat_a_short:
  %ap4 = lshr i64 %aw0, 32
  %ap4_32 = trunc i64 %ap4 to i32
  store i32 %ap4_32, ptr %atmp, align 4
  %atmp4 = getelementptr inbounds i8, ptr %atmp, i64 4
  store i64 %aw1, ptr %atmp4, align 4
  br label %mat_b
mat_a_long:
  %araw = and i64 %aw1, -4
  %alptr = inttoptr i64 %araw to ptr
  br label %mat_b
mat_b:
  %aptr = phi ptr [ %atmp, %mat_a_short ], [ %alptr, %mat_a_long ]
  %bshort = icmp ule i64 %blen, 12
  br i1 %bshort, label %mat_b_short, label %mat_b_long
mat_b_short:
  %bp4 = lshr i64 %bw0, 32
  %bp4_32 = trunc i64 %bp4 to i32
  store i32 %bp4_32, ptr %btmp, align 4
  %btmp4 = getelementptr inbounds i8, ptr %btmp, i64 4
  store i64 %bw1, ptr %btmp4, align 4
  br label %build
mat_b_long:
  %braw = and i64 %bw1, -4
  %blptr = inttoptr i64 %braw to ptr
  br label %build
build:
  %bptr = phi ptr [ %btmp, %mat_b_short ], [ %blptr, %mat_b_long ]
  %fits_sso = icmp ule i64 %tot, 12
  br i1 %fits_sso, label %build_sso, label %build_long
build_sso:
  store i64 0, ptr %out_sso, align 8
  %out_sso8 = getelementptr inbounds i8, ptr %out_sso, i64 8
  store i64 0, ptr %out_sso8, align 8
  %tot32 = trunc i64 %tot to i32
  store i32 %tot32, ptr %out_sso, align 8
  %sso_dst_a = getelementptr inbounds i8, ptr %out_sso, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a, ptr nonnull align 1 %aptr, i64 %alen, i1 false)
  %sso_dst_b = getelementptr inbounds i8, ptr %sso_dst_a, i64 %alen
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b, ptr nonnull align 1 %bptr, i64 %blen, i1 false)
  %rw0 = load i64, ptr %out_sso, align 8
  %rw1 = load i64, ptr %out_sso8, align 8
  %rs0 = insertvalue %ArchxStr poison, i64 %rw0, 0
  %rs1 = insertvalue %ArchxStr %rs0, i64 %rw1, 1
  ret %ArchxStr %rs1
build_long:
  %use_reg = icmp ne ptr %reg, null
  br i1 %use_reg, label %alloc_reg, label %alloc_heap
alloc_reg:
  %rp = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %tot)
  %rp_i = ptrtoint ptr %rp to i64
  %rtagged = or i64 %rp_i, 2
  br label %copy_long
alloc_heap:
  %hp = call noalias align 16 ptr @malloc(i64 %tot)
  %hnull = icmp eq ptr %hp, null
  br i1 %hnull, label %oom, label %tag_heap
tag_heap:
  %hp_i = ptrtoint ptr %hp to i64
  %htagged = or i64 %hp_i, 1
  br label %copy_long
copy_long:
  %dst = phi ptr [ %rp, %alloc_reg ], [ %hp, %tag_heap ]
  %w1_out = phi i64 [ %rtagged, %alloc_reg ], [ %htagged, %tag_heap ]
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst, ptr nonnull align 1 %aptr, i64 %alen, i1 false)
  %dst_b = getelementptr inbounds i8, ptr %dst, i64 %alen
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b, ptr nonnull align 1 %bptr, i64 %blen, i1 false)
  %pref32 = load i32, ptr %dst, align 16
  %pref64 = zext i32 %pref32 to i64
  %pref_sh = shl nuw i64 %pref64, 32
  %w0_out = or i64 %tot, %pref_sh
  %ls0 = insertvalue %ArchxStr poison, i64 %w0_out, 0
  %ls1 = insertvalue %ArchxStr %ls0, i64 %w1_out, 1
  ret %ArchxStr %ls1
}

@.err.neglen = private unnamed_addr constant [53 x i8] c"archx runtime panic: invalid array/step size (%lld)\0A\00", align 1

define private void @archx_neg_len_fail(i64 %n) cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.neglen, i64 %n)
  call void @exit(i32 101)
  unreachable
}

@.err.oom = private unnamed_addr constant [36 x i8] c"archx runtime panic: out of memory\0A\00", align 1

define private void @archx_oom_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.oom)
  call void @exit(i32 101)
  unreachable
}

declare i32 @printf(ptr nocapture readonly, ...)
declare noalias ptr @malloc(i64) nounwind allocsize(0)
declare noalias ptr @calloc(i64, i64) nounwind allocsize(0, 1)
declare void @free(ptr) nounwind
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) nounwind readnone speculatable
declare ptr @memchr(ptr nocapture, i32, i64) nounwind readonly
declare i32 @putchar(i32)
declare void @exit(i32) cold noreturn nounwind
