; Archx LLVM IR module

%ArchxVec = type { i64, i64, ptr }
%ArchxStr = type { i64, i64 }
%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxStruct_Stats = type { i64, double }

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.fmt.int.elem = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.fmt.str.elem = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.none = private unnamed_addr constant [5 x i8] c"None\00", align 1
@.fmt.g15 = private unnamed_addr constant [6 x i8] c"%.15g\00", align 1
@.str.0 = private unnamed_addr constant [31 x i8] c"  fast pythonic native archx  \00", align 4

define internal fastcc void @archx_method_5_Stats_add(ptr %arg.self, double %arg.value) {
entry:
  %t0 = getelementptr inbounds %ArchxStruct_Stats, ptr %arg.self, i32 0, i32 0
  %t1 = load i64, ptr %t0, align 8
  %t2 = add i64 %t1, 1
  store i64 %t2, ptr %t0, align 8
  %t3 = getelementptr inbounds %ArchxStruct_Stats, ptr %arg.self, i32 0, i32 1
  %t4 = load double, ptr %t3, align 8
  %t5 = fadd double %t4, %arg.value
  store double %t5, ptr %t3, align 8
  ret void
}

define internal fastcc double @archx_method_5_Stats_mean(%ArchxStruct_Stats %arg.self) {
entry:
  %ifexpr.res.6 = alloca double, align 8
  %t0 = extractvalue %ArchxStruct_Stats %arg.self, 0
  %t1 = icmp sgt i64 %t0, 0
  br i1 %t1, label %ifexpr.then.0, label %ifexpr.else.1
ifexpr.then.0:
  %t2 = extractvalue %ArchxStruct_Stats %arg.self, 1
  %t3 = extractvalue %ArchxStruct_Stats %arg.self, 0
  %t4 = sitofp i64 %t3 to double
  %t5 = fdiv double %t2, %t4
  store double %t5, ptr %ifexpr.res.6, align 8
  br label %ifexpr.merge.2
ifexpr.else.1:
  store double 0x0000000000000000, ptr %ifexpr.res.6, align 8
  br label %ifexpr.merge.2
ifexpr.merge.2:
  %t7 = load double, ptr %ifexpr.res.6, align 8
  ret double %t7
}

define internal fastcc i64 @archx_fn_countdown_sum(i64 %arg.start) {
entry:
  %var.acc.0 = alloca i64, align 8
  %for.k.2 = alloca i64, align 8
  store i64 0, ptr %var.acc.0, align 8
  %t1 = sub i64 0, 2
  store i64 %arg.start, ptr %for.k.2, align 8
  br label %for.cond.0
for.cond.0:
  %t3 = load i64, ptr %for.k.2, align 8
  %t4 = icmp sgt i64 %t3, 0
  br i1 %t4, label %for.body.1, label %for.end.3
for.body.1:
  %t5 = load i64, ptr %var.acc.0, align 8
  %t6 = load i64, ptr %for.k.2, align 8
  %t7 = add i64 %t5, %t6
  store i64 %t7, ptr %var.acc.0, align 8
  br label %for.step.2
for.step.2:
  %t8 = load i64, ptr %for.k.2, align 8
  %t9 = add i64 %t8, %t1
  store i64 %t9, ptr %for.k.2, align 8
  br label %for.cond.0
for.end.3:
  %t10 = load i64, ptr %var.acc.0, align 8
  ret i64 %t10
}

define i32 @main() {
entry:
  %func.region = alloca %ArchxRegion, align 8
  %var.stats.2 = alloca %ArchxStruct_Stats, align 8
  %var.samples.7 = alloca %ArchxVec, align 8
  %for.i.8 = alloca i64, align 8
  %enum.pos.59 = alloca i64, align 8
  %var.words.80 = alloca %ArchxVec, align 8
  %for.i.103 = alloca i64, align 8
  store %ArchxRegion zeroinitializer, ptr %func.region, align 8
  %t0 = insertvalue %ArchxStruct_Stats poison, i64 0, 0
  %t1 = insertvalue %ArchxStruct_Stats %t0, double 0x0000000000000000, 1
  store %ArchxStruct_Stats %t1, ptr %var.stats.2, align 8
  %t3 = insertvalue %ArchxVec poison, i64 0, 0
  %t4 = insertvalue %ArchxVec %t3, i64 0, 1
  %t5 = insertvalue %ArchxVec %t4, ptr null, 2
  %t6 = call fastcc %ArchxVec @archx_vec_clone_f(%ArchxVec %t5)
  store %ArchxVec %t6, ptr %var.samples.7, align 8
  store i64 1, ptr %for.i.8, align 8
  br label %for.cond.0
for.cond.0:
  %t9 = load i64, ptr %for.i.8, align 8
  %t10 = icmp slt i64 %t9, 6
  br i1 %t10, label %for.body.1, label %for.end.3
for.body.1:
  %t11 = load i64, ptr %for.i.8, align 8
  %t12 = sitofp i64 %t11 to double
  %t13 = fmul double %t12, 0x3FF8000000000000
  %t14 = load %ArchxVec, ptr %var.samples.7, align 8
  %t15 = extractvalue %ArchxVec %t14, 0
  %t16 = extractvalue %ArchxVec %t14, 1
  %t17 = extractvalue %ArchxVec %t14, 2
  %t18 = icmp slt i64 %t16, 0
  %t19 = sub nsw i64 0, %t16
  %t20 = select i1 %t18, i64 %t19, i64 %t16
  %t21 = icmp sge i64 %t15, %t20
  br i1 %t21, label %push.grow.4, label %push.store.5
push.grow.4:
  %t22 = icmp sge i64 %t15, 140737488355328
  br i1 %t22, label %push.oom.6, label %push.calc.7
push.oom.6:
  call void @archx_oom_fail()
  unreachable
push.calc.7:
  %t23 = icmp eq i64 %t20, 0
  %t24 = shl i64 %t20, 1
  %t25 = select i1 %t23, i64 4, i64 %t24
  %t26 = icmp sgt i64 %t25, 140737488355328
  %t27 = select i1 %t26, i64 140737488355328, i64 %t25
  %t28 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t27, i64 8)
  %t29 = extractvalue { i64, i1 } %t28, 0
  %t30 = extractvalue { i64, i1 } %t28, 1
  br i1 %t30, label %mul.oom.8, label %mul.ok.9
mul.oom.8:
  call void @archx_oom_fail()
  unreachable
mul.ok.9:
  %t31 = icmp eq i64 %t29, 0
  %t32 = select i1 %t31, i64 1, i64 %t29
  br i1 %t18, label %push.grow.from_reg.10, label %push.grow.from_heap.11
push.grow.from_reg.10:
  %t33 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t15, i64 8)
  %t34 = extractvalue { i64, i1 } %t33, 0
  %t35 = extractvalue { i64, i1 } %t33, 1
  br i1 %t35, label %mul.oom.12, label %mul.ok.13
mul.oom.12:
  call void @archx_oom_fail()
  unreachable
mul.ok.13:
  %t36 = icmp eq i64 %t34, 0
  %t37 = select i1 %t36, i64 1, i64 %t34
  %t38 = call noalias align 16 ptr @malloc(i64 %t32)
  %t39 = icmp eq ptr %t38, null
  br i1 %t39, label %alloc.oom.15, label %alloc.ok.14
alloc.oom.15:
  call void @archx_oom_fail()
  unreachable
alloc.ok.14:
  %t40 = icmp sgt i64 %t37, 0
  br i1 %t40, label %push.reg.copy.16, label %push.reg.copied.17
push.reg.copy.16:
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %t38, ptr align 8 %t17, i64 %t37, i1 false)
  br label %push.reg.copied.17
push.reg.copied.17:
  %t41 = insertvalue %ArchxVec poison, i64 %t15, 0
  %t42 = insertvalue %ArchxVec %t41, i64 %t27, 1
  %t43 = insertvalue %ArchxVec %t42, ptr %t38, 2
  store %ArchxVec %t43, ptr %var.samples.7, align 8
  br label %push.store.5
push.grow.from_heap.11:
  %t44 = call align 16 ptr @realloc(ptr %t17, i64 %t32)
  %t45 = icmp eq ptr %t44, null
  br i1 %t45, label %realloc.oom.19, label %realloc.ok.18
realloc.oom.19:
  call void @archx_oom_fail()
  unreachable
realloc.ok.18:
  %t46 = insertvalue %ArchxVec poison, i64 %t15, 0
  %t47 = insertvalue %ArchxVec %t46, i64 %t27, 1
  %t48 = insertvalue %ArchxVec %t47, ptr %t44, 2
  store %ArchxVec %t48, ptr %var.samples.7, align 8
  br label %push.store.5
push.store.5:
  %t49 = load %ArchxVec, ptr %var.samples.7, align 8
  %t50 = extractvalue %ArchxVec %t49, 2
  %t51 = getelementptr inbounds double, ptr %t50, i64 %t15
  store double %t13, ptr %t51, align 8
  %t52 = add nsw i64 %t15, 1
  %t53 = insertvalue %ArchxVec %t49, i64 %t52, 0
  store %ArchxVec %t53, ptr %var.samples.7, align 8
  br label %for.step.2
for.step.2:
  %t54 = load i64, ptr %for.i.8, align 8
  %t55 = add nsw i64 %t54, 1
  store i64 %t55, ptr %for.i.8, align 8
  br label %for.cond.0
for.end.3:
  %t56 = load %ArchxVec, ptr %var.samples.7, align 8
  %t57 = extractvalue %ArchxVec %t56, 0
  %t58 = extractvalue %ArchxVec %t56, 2
  store i64 0, ptr %enum.pos.59, align 8
  br label %enum.cond.20
enum.cond.20:
  %t60 = load i64, ptr %enum.pos.59, align 8
  %t61 = icmp slt i64 %t60, %t57
  br i1 %t61, label %enum.body.21, label %enum.end.23
enum.body.21:
  %t62 = add i64 1, %t60
  %t63 = getelementptr inbounds double, ptr %t58, i64 %t60
  %t64 = load double, ptr %t63, align 8
  call fastcc void @archx_method_5_Stats_add(ptr %var.stats.2, double %t64)
  %t65 = load %ArchxVec, ptr %var.samples.7, align 8
  %t66 = extractvalue %ArchxVec %t65, 0
  %t67 = icmp eq i64 %t62, %t66
  br i1 %t67, label %if.then.24, label %if.else.25
if.then.24:
  %t68 = call fastcc %ArchxStr @archx_str_from_int(i64 %t62, ptr null)
  %t69 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 8101238451258523656, i64 589325676 }, %ArchxStr %t68, ptr null)
  %t70 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t69, %ArchxStr { i64 9074406902988803, i64 0 }, ptr null)
  %t71 = call fastcc %ArchxStr @archx_str_from_float(double %t64, ptr null)
  %t72 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t70, %ArchxStr %t71, ptr null)
  call fastcc void @archx_str_print(%ArchxStr %t72, i1 true)
  call fastcc void @archx_str_drop(%ArchxStr %t72)
  call fastcc void @archx_str_drop(%ArchxStr %t71)
  call fastcc void @archx_str_drop(%ArchxStr %t70)
  call fastcc void @archx_str_drop(%ArchxStr %t69)
  call fastcc void @archx_str_drop(%ArchxStr %t68)
  br label %if.merge.26
if.else.25:
  br label %if.merge.26
if.merge.26:
  br label %enum.step.22
enum.step.22:
  %t73 = load i64, ptr %enum.pos.59, align 8
  %t74 = add nsw i64 %t73, 1
  store i64 %t74, ptr %enum.pos.59, align 8
  br label %enum.cond.20
enum.end.23:
  %t75 = ptrtoint ptr @.str.0 to i64
  %t76 = insertvalue %ArchxStr poison, i64 7018332391114539038, 0
  %t77 = insertvalue %ArchxStr %t76, i64 %t75, 1
  %t78 = call fastcc %ArchxStr @archx_str_strip(%ArchxStr %t77, ptr null)
  %t79 = call fastcc %ArchxVec @archx_str_split_ws(%ArchxStr %t78)
  call fastcc void @archx_str_drop(%ArchxStr %t78)
  store %ArchxVec %t79, ptr %var.words.80, align 8
  %t81 = load %ArchxVec, ptr %var.words.80, align 8
  %t82 = extractvalue %ArchxVec %t81, 0
  %t83 = load %ArchxVec, ptr %var.words.80, align 8
  %t84 = extractvalue %ArchxVec %t83, 0
  %t85 = icmp uge i64 0, %t84
  br i1 %t85, label %idx.oob.28, label %idx.ok.27
idx.oob.28:
  call void @archx_bounds_fail(i64 0, i64 %t84)
  unreachable
idx.ok.27:
  %t86 = extractvalue %ArchxVec %t83, 2
  %t87 = getelementptr inbounds %ArchxStr, ptr %t86, i64 0
  %t88 = load %ArchxStr, ptr %t87, align 8
  %t89 = call fastcc %ArchxStr @archx_str_case(%ArchxStr %t88, i1 true, ptr null)
  call fastcc void @archx_str_print(%ArchxStr { i64 7237970108029599750, i64 14963 }, i1 false)
  call fastcc void @archx_str_print(%ArchxStr { i64 9143676135538691, i64 0 }, i1 false)
  %t90 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t82)
  call fastcc void @archx_str_print(%ArchxStr { i64 9143676135538691, i64 0 }, i1 false)
  call fastcc void @archx_str_print(%ArchxStr %t89, i1 false)
  %t91 = call i32 @putchar(i32 10)
  call fastcc void @archx_str_drop(%ArchxStr %t89)
  %t92 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 1000, i64 8)
  %t93 = extractvalue { i64, i1 } %t92, 0
  %t94 = extractvalue { i64, i1 } %t92, 1
  br i1 %t94, label %mul.oom.29, label %mul.ok.30
mul.oom.29:
  call void @archx_oom_fail()
  unreachable
mul.ok.30:
  %t95 = icmp eq i64 %t93, 0
  %t96 = select i1 %t95, i64 1, i64 %t93
  %t97 = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %func.region, i64 %t96)
  %t98 = sub nsw i64 0, 1000
  %t99 = shl nuw nsw i64 1000, 3
  call void @llvm.memset.p0.i64(ptr nonnull align 16 %t97, i8 0, i64 %t99, i1 false)
  %t100 = insertvalue %ArchxVec poison, i64 1000, 0
  %t101 = insertvalue %ArchxVec %t100, i64 %t98, 1
  %t102 = insertvalue %ArchxVec %t101, ptr %t97, 2
  store i64 0, ptr %for.i.103, align 8
  br label %for.cond.31
for.cond.31:
  %t104 = load i64, ptr %for.i.103, align 8
  %t105 = icmp slt i64 %t104, 1000
  br i1 %t105, label %for.body.32, label %for.end.34
for.body.32:
  %t106 = load i64, ptr %for.i.103, align 8
  %t107 = extractvalue %ArchxVec %t102, 2
  %t108 = getelementptr inbounds i64, ptr %t107, i64 %t106
  %t109 = load i64, ptr %for.i.103, align 8
  %t110 = icmp eq i64 10, 0
  br i1 %t110, label %fdiv.zero.35, label %fdiv.ok.36
fdiv.zero.35:
  call void @archx_div_zero_fail()
  unreachable
fdiv.ok.36:
  %t111 = icmp eq i64 %t109, -9223372036854775808
  %t112 = icmp eq i64 10, -1
  %t113 = and i1 %t111, %t112
  %t114 = select i1 %t113, i64 1, i64 10
  %t115 = sdiv i64 %t109, %t114
  %t116 = sub i64 0, %t109
  %t117 = select i1 %t113, i64 %t116, i64 %t115
  %t118 = srem i64 %t109, %t114
  %t119 = icmp ne i64 %t118, 0
  %t120 = xor i64 %t109, 10
  %t121 = icmp slt i64 %t120, 0
  %t122 = and i1 %t119, %t121
  %t123 = zext i1 %t122 to i64
  %t124 = sub i64 %t117, %t123
  store i64 %t124, ptr %t108, align 8
  br label %for.step.33
for.step.33:
  %t125 = load i64, ptr %for.i.103, align 8
  %t126 = add nsw i64 %t125, 100
  store i64 %t126, ptr %for.i.103, align 8
  br label %for.cond.31
for.end.34:
  %t127 = load %ArchxStruct_Stats, ptr %var.stats.2, align 8
  %t128 = call fastcc double @archx_method_5_Stats_mean(%ArchxStruct_Stats %t127)
  %t129 = call fastcc %ArchxStr @archx_str_from_float(double %t128, ptr %func.region)
  %t130 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 7953749935738847237, i64 61 }, %ArchxStr %t129, ptr %func.region)
  %t131 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t130, %ArchxStr { i64 8026294334255005708, i64 4426606804062203509 }, ptr %func.region)
  %t132 = call fastcc i64 @archx_fn_countdown_sum(i64 10)
  %t133 = call fastcc %ArchxStr @archx_str_from_int(i64 %t132, ptr %func.region)
  %t134 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t131, %ArchxStr %t133, ptr %func.region)
  %t135 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t134, %ArchxStr { i64 8458358423505862665, i64 262801471846 }, ptr %func.region)
  %t136 = extractvalue %ArchxVec %t102, 2
  %t137 = getelementptr inbounds i64, ptr %t136, i64 900
  %t138 = load i64, ptr %t137, align 8
  %t139 = call fastcc %ArchxStr @archx_str_from_int(i64 %t138, ptr %func.region)
  %t140 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t135, %ArchxStr %t139, ptr %func.region)
  call fastcc void @archx_str_print(%ArchxStr %t140, i1 true)
  call fastcc void @archx_str_drop(%ArchxStr %t140)
  call fastcc void @archx_str_drop(%ArchxStr %t139)
  call fastcc void @archx_str_drop(%ArchxStr %t135)
  call fastcc void @archx_str_drop(%ArchxStr %t134)
  call fastcc void @archx_str_drop(%ArchxStr %t133)
  call fastcc void @archx_str_drop(%ArchxStr %t131)
  call fastcc void @archx_str_drop(%ArchxStr %t130)
  call fastcc void @archx_str_drop(%ArchxStr %t129)
  call fastcc void @archx_region_rewind_root(ptr %func.region)
  %t141 = load %ArchxVec, ptr %var.words.80, align 8
  call fastcc void @archx_vec_drop_s(%ArchxVec %t141)
  %t142 = load %ArchxVec, ptr %var.samples.7, align 8
  %t143 = extractvalue %ArchxVec %t142, 1
  %t144 = icmp sgt i64 %t143, 0
  br i1 %t144, label %drop.vec.free.37, label %drop.vec.done.38
drop.vec.free.37:
  %t145 = extractvalue %ArchxVec %t142, 2
  call void @free(ptr %t145)
  br label %drop.vec.done.38
drop.vec.done.38:
  %t146 = getelementptr inbounds %ArchxRegion, ptr %func.region, i32 0, i32 2
  %t147 = load ptr, ptr %t146, align 8
  call fastcc void @archx_region_release_from(ptr %t147)
  ret i32 0
}

define private fastcc %ArchxVec @archx_vec_clone_f(%ArchxVec %v) {
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

define private fastcc void @archx_vec_drop_s(%ArchxVec %v) nounwind {
entry:
  %len = extractvalue %ArchxVec %v, 0
  %cap = extractvalue %ArchxVec %v, 1
  %data = extractvalue %ArchxVec %v, 2
  %has_elems = icmp sgt i64 %len, 0
  br i1 %has_elems, label %loop.pre, label %check.free
loop.pre:
  br label %loop
loop:
  %i = phi i64 [ 0, %loop.pre ], [ %inext, %loop.latch ]
  %ep = getelementptr inbounds %ArchxStr, ptr %data, i64 %i
  %t0 = load %ArchxStr, ptr %ep, align 8
  call fastcc void @archx_str_drop(%ArchxStr %t0)
  br label %loop.latch
loop.latch:
  %inext = add nuw nsw i64 %i, 1
  %more = icmp slt i64 %inext, %len
  br i1 %more, label %loop, label %check.free
check.free:
  %is_heap = icmp sgt i64 %cap, 0
  br i1 %is_heap, label %do.free, label %done
do.free:
  call void @free(ptr %data)
  br label %done
done:
  ret void
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

define private fastcc void @archx_region_rewind_root(ptr %reg) alwaysinline nounwind {
entry:
  %head_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 2
  %head = load ptr, ptr %head_slot, align 8
  %empty = icmp eq ptr %head, null
  br i1 %empty, label %done, label %rewind
rewind:
  %cap_ptr = getelementptr inbounds i8, ptr %head, i64 8
  %cap = load i64, ptr %cap_ptr, align 8
  %data = getelementptr inbounds i8, ptr %head, i64 16
  %end = getelementptr inbounds i8, ptr %data, i64 %cap
  %end_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 1
  %tail_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 3
  store ptr %data, ptr %reg, align 8
  store ptr %end, ptr %end_slot, align 8
  store ptr %head, ptr %tail_slot, align 8
  br label %done
done:
  ret void
}

define private fastcc noalias nonnull align 16 ptr @archx_region_alloc_fallback(ptr %reg, i64 %aligned) noinline {
entry:
  %cur_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 0
  %end_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 1
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
  br i1 %fits, label %fast, label %fallback
fast:
  %next = getelementptr inbounds i8, ptr %cur, i64 %aligned
  store ptr %next, ptr %cur_slot, align 8
  ret ptr %cur
fallback:
  %res = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr %reg, i64 %aligned)
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
  %tag = and i64 %w1, 3
  %owned = icmp ne i64 %tag, 0
  br i1 %owned, label %dup_heap, label %ret_same
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

define private fastcc %ArchxStr @archx_str_concat(%ArchxStr %a, %ArchxStr %b, ptr %reg) alwaysinline {
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
  %rp_a = and i64 %rp_i, -4
  %rtagged = or i64 %rp_a, 2
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

@.err.bounds = private unnamed_addr constant [63 x i8] c"archx runtime panic: index %lld out of bounds for length %lld\0A\00", align 1

define private void @archx_bounds_fail(i64 %idx, i64 %len) cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.bounds, i64 %idx, i64 %len)
  call void @exit(i32 101)
  unreachable
}

@.err.divz = private unnamed_addr constant [39 x i8] c"archx runtime panic: division by zero\0A\00", align 1

define private void @archx_div_zero_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.divz)
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
declare ptr @realloc(ptr, i64) nounwind allocsize(1)
declare void @free(ptr) nounwind
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) nounwind readnone speculatable
declare ptr @memchr(ptr nocapture, i32, i64) nounwind readonly
declare i32 @putchar(i32)
declare void @exit(i32) cold noreturn nounwind

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
build_long:
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
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst, ptr nonnull align 1 %src, i64 %len, i1 false)
  %pref32 = load i32, ptr %dst, align 16
  %pref64 = zext i32 %pref32 to i64
  %pref_sh = shl nuw i64 %pref64, 32
  %w0_out = or i64 %len, %pref_sh
  %ls0 = insertvalue %ArchxStr poison, i64 %w0_out, 0
  %ls1 = insertvalue %ArchxStr %ls0, i64 %w1_out, 1
  ret %ArchxStr %ls1
}


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


define private fastcc %ArchxStr @archx_str_from_float(double %x, ptr %reg) {
entry:
  %buf = alloca [64 x i8], align 8
  %len = call fastcc i64 @archx_fmt_float_buf(double %x, ptr %buf)
  %s = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %buf, i64 %len, ptr %reg)
  ret %ArchxStr %s
}

@.fmt.i64s = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

define private fastcc %ArchxStr @archx_str_from_int(i64 %n, ptr %reg) {
entry:
  %buf = alloca [32 x i8], align 8
  %n32 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull %buf, ptr @.fmt.i64s, i64 %n)
  %len = sext i32 %n32 to i64
  %s = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %buf, i64 %len, ptr %reg)
  ret %ArchxStr %s
}


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

declare i32 @sprintf(ptr nocapture writeonly, ptr nocapture readonly, ...) nounwind
