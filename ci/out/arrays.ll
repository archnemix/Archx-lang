; Archx LLVM IR module

%ArchxVec = type { i64, i64, ptr }
%ArchxStr = type { i64, i64 }

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.fmt.int.elem = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.fmt.str.elem = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.none = private unnamed_addr constant [5 x i8] c"None\00", align 1
@.fmt.lbrack = private unnamed_addr constant [2 x i8] c"[\00", align 1
@.fmt.sep = private unnamed_addr constant [3 x i8] c", \00", align 1
@.fmt.rbrack = private unnamed_addr constant [3 x i8] c"]\0A\00", align 1
@.fmt.rbrack.inline = private unnamed_addr constant [2 x i8] c"]\00", align 1

define internal fastcc i64 @archx_fn_dot(%ArchxVec %arg.a, %ArchxVec %arg.b) {
entry:
  %var.total.0 = alloca i64, align 8
  %for.i.2 = alloca i64, align 8
  %for.last.i.3 = alloca i64, align 8
  store i64 0, ptr %var.total.0, align 8
  %t1 = extractvalue %ArchxVec %arg.a, 0
  store i64 0, ptr %for.i.2, align 8
  store i64 0, ptr %for.last.i.3, align 8
  %t4 = extractvalue %ArchxVec %arg.b, 0
  %t5 = icmp ule i64 %t1, %t4
  br i1 %t5, label %for.fast.cond.0, label %for.cond.3
for.fast.cond.0:
  %t6 = load i64, ptr %for.i.2, align 8
  %t7 = icmp slt i64 %t6, %t1
  br i1 %t7, label %for.fast.body.1, label %for.end.6
for.fast.body.1:
  store i64 %t6, ptr %for.last.i.3, align 8
  %t8 = load i64, ptr %var.total.0, align 8
  %t9 = load i64, ptr %for.last.i.3, align 8
  %t10 = extractvalue %ArchxVec %arg.a, 2
  %t11 = getelementptr inbounds i64, ptr %t10, i64 %t9
  %t12 = load i64, ptr %t11, align 8
  %t13 = load i64, ptr %for.last.i.3, align 8
  %t14 = extractvalue %ArchxVec %arg.b, 2
  %t15 = getelementptr inbounds i64, ptr %t14, i64 %t13
  %t16 = load i64, ptr %t15, align 8
  %t17 = mul i64 %t12, %t16
  %t18 = add i64 %t8, %t17
  store i64 %t18, ptr %var.total.0, align 8
  br label %for.fast.step.2
for.fast.step.2:
  %t19 = load i64, ptr %for.i.2, align 8
  %t20 = add nsw i64 %t19, 1
  store i64 %t20, ptr %for.i.2, align 8
  br label %for.fast.cond.0
for.cond.3:
  %t21 = load i64, ptr %for.i.2, align 8
  %t22 = icmp slt i64 %t21, %t1
  br i1 %t22, label %for.body.4, label %for.end.6
for.body.4:
  store i64 %t21, ptr %for.last.i.3, align 8
  %t23 = load i64, ptr %var.total.0, align 8
  %t24 = load i64, ptr %for.last.i.3, align 8
  %t25 = extractvalue %ArchxVec %arg.a, 2
  %t26 = getelementptr inbounds i64, ptr %t25, i64 %t24
  %t27 = load i64, ptr %t26, align 8
  %t28 = load i64, ptr %for.last.i.3, align 8
  %t29 = extractvalue %ArchxVec %arg.b, 0
  %t30 = icmp uge i64 %t28, %t29
  br i1 %t30, label %idx.oob.8, label %idx.ok.7
idx.oob.8:
  call void @archx_bounds_fail(i64 %t28, i64 %t29)
  unreachable
idx.ok.7:
  %t31 = extractvalue %ArchxVec %arg.b, 2
  %t32 = getelementptr inbounds i64, ptr %t31, i64 %t28
  %t33 = load i64, ptr %t32, align 8
  %t34 = mul i64 %t27, %t33
  %t35 = add i64 %t23, %t34
  store i64 %t35, ptr %var.total.0, align 8
  br label %for.step.5
for.step.5:
  %t36 = load i64, ptr %for.i.2, align 8
  %t37 = add nsw i64 %t36, 1
  store i64 %t37, ptr %for.i.2, align 8
  br label %for.cond.3
for.end.6:
  %t38 = load i64, ptr %var.total.0, align 8
  ret i64 %t38
}

define internal fastcc i64 @archx_fn_sieve_count(i64 %arg.limit) {
entry:
  %var.p.20 = alloca i64, align 8
  %var.j.35 = alloca i64, align 8
  %var.count.66 = alloca i64, align 8
  %for.i.67 = alloca i64, align 8
  %for.last.i.68 = alloca i64, align 8
  %t0 = icmp ugt i64 %arg.limit, 140737488355328
  br i1 %t0, label %repeat.bad.1, label %repeat.ok.0
repeat.bad.1:
  call void @archx_neg_len_fail(i64 %arg.limit)
  unreachable
repeat.ok.0:
  %t1 = icmp eq i64 %arg.limit, 0
  %t2 = select i1 %t1, i64 1, i64 %arg.limit
  %t3 = call noalias align 16 ptr @malloc(i64 %t2)
  %t4 = icmp eq ptr %t3, null
  br i1 %t4, label %alloc.oom.3, label %alloc.ok.2
alloc.oom.3:
  call void @archx_oom_fail()
  unreachable
alloc.ok.2:
  %t5 = zext i1 true to i8
  call void @llvm.memset.p0.i64(ptr nonnull align 16 %t3, i8 %t5, i64 %arg.limit, i1 false)
  %t6 = insertvalue %ArchxVec poison, i64 %arg.limit, 0
  %t7 = insertvalue %ArchxVec %t6, i64 %arg.limit, 1
  %t8 = insertvalue %ArchxVec %t7, ptr %t3, 2
  %t9 = extractvalue %ArchxVec %t8, 2
  %t10 = extractvalue %ArchxVec %t8, 0
  %t11 = icmp uge i64 0, %t10
  br i1 %t11, label %idx.oob.5, label %idx.ok.4
idx.oob.5:
  call void @archx_bounds_fail(i64 0, i64 %t10)
  unreachable
idx.ok.4:
  %t12 = extractvalue %ArchxVec %t8, 2
  %t13 = getelementptr inbounds i8, ptr %t12, i64 0
  %t14 = zext i1 false to i8
  store i8 %t14, ptr %t13, align 1
  %t15 = extractvalue %ArchxVec %t8, 0
  %t16 = icmp uge i64 1, %t15
  br i1 %t16, label %idx.oob.7, label %idx.ok.6
idx.oob.7:
  call void @archx_bounds_fail(i64 1, i64 %t15)
  unreachable
idx.ok.6:
  %t17 = extractvalue %ArchxVec %t8, 2
  %t18 = getelementptr inbounds i8, ptr %t17, i64 1
  %t19 = zext i1 false to i8
  store i8 %t19, ptr %t18, align 1
  store i64 2, ptr %var.p.20, align 8
  br label %while.cond.8
while.cond.8:
  %t21 = load i64, ptr %var.p.20, align 8
  %t22 = load i64, ptr %var.p.20, align 8
  %t23 = mul i64 %t21, %t22
  %t24 = icmp slt i64 %t23, %arg.limit
  br i1 %t24, label %while.body.9, label %while.end.10
while.body.9:
  %t25 = load i64, ptr %var.p.20, align 8
  %t26 = extractvalue %ArchxVec %t8, 0
  %t27 = icmp uge i64 %t25, %t26
  br i1 %t27, label %idx.oob.12, label %idx.ok.11
idx.oob.12:
  call void @archx_bounds_fail(i64 %t25, i64 %t26)
  unreachable
idx.ok.11:
  %t28 = extractvalue %ArchxVec %t8, 2
  %t29 = getelementptr inbounds i8, ptr %t28, i64 %t25
  %t30 = load i8, ptr %t29, align 1
  %t31 = trunc i8 %t30 to i1
  br i1 %t31, label %if.then.13, label %if.else.14
if.then.13:
  %t32 = load i64, ptr %var.p.20, align 8
  %t33 = load i64, ptr %var.p.20, align 8
  %t34 = mul i64 %t32, %t33
  store i64 %t34, ptr %var.j.35, align 8
  %t36 = load i64, ptr %var.j.35, align 8
  %t37 = icmp sge i64 %t36, 0
  %t38 = icmp ule i64 %arg.limit, 140737488355328
  %t39 = and i1 %t37, %t38
  %t40 = load i64, ptr %var.p.20, align 8
  %t41 = sub i64 %t40, 1
  %t42 = icmp ult i64 %t41, 140737488355328
  %t43 = and i1 %t39, %t42
  br i1 %t43, label %while.fast.cond.16, label %while.cond.18
while.fast.cond.16:
  %t44 = load i64, ptr %var.j.35, align 8
  %t45 = icmp slt i64 %t44, %arg.limit
  br i1 %t45, label %while.fast.body.17, label %while.end.20
while.fast.body.17:
  %t46 = load i64, ptr %var.j.35, align 8
  %t47 = extractvalue %ArchxVec %t8, 2
  %t48 = getelementptr inbounds i8, ptr %t47, i64 %t46
  %t49 = zext i1 false to i8
  store i8 %t49, ptr %t48, align 1
  %t50 = load i64, ptr %var.j.35, align 8
  %t51 = load i64, ptr %var.p.20, align 8
  %t52 = add i64 %t50, %t51
  store i64 %t52, ptr %var.j.35, align 8
  br label %while.fast.cond.16
while.cond.18:
  %t53 = load i64, ptr %var.j.35, align 8
  %t54 = icmp slt i64 %t53, %arg.limit
  br i1 %t54, label %while.body.19, label %while.end.20
while.body.19:
  %t55 = load i64, ptr %var.j.35, align 8
  %t56 = extractvalue %ArchxVec %t8, 0
  %t57 = icmp uge i64 %t55, %t56
  br i1 %t57, label %idx.oob.22, label %idx.ok.21
idx.oob.22:
  call void @archx_bounds_fail(i64 %t55, i64 %t56)
  unreachable
idx.ok.21:
  %t58 = extractvalue %ArchxVec %t8, 2
  %t59 = getelementptr inbounds i8, ptr %t58, i64 %t55
  %t60 = zext i1 false to i8
  store i8 %t60, ptr %t59, align 1
  %t61 = load i64, ptr %var.j.35, align 8
  %t62 = load i64, ptr %var.p.20, align 8
  %t63 = add i64 %t61, %t62
  store i64 %t63, ptr %var.j.35, align 8
  br label %while.cond.18
while.end.20:
  br label %if.merge.15
if.else.14:
  br label %if.merge.15
if.merge.15:
  %t64 = load i64, ptr %var.p.20, align 8
  %t65 = add i64 %t64, 1
  store i64 %t65, ptr %var.p.20, align 8
  br label %while.cond.8
while.end.10:
  store i64 0, ptr %var.count.66, align 8
  store i64 2, ptr %for.i.67, align 8
  store i64 2, ptr %for.last.i.68, align 8
  br label %for.cond.23
for.cond.23:
  %t69 = load i64, ptr %for.i.67, align 8
  %t70 = icmp slt i64 %t69, %arg.limit
  br i1 %t70, label %for.body.24, label %for.end.26
for.body.24:
  store i64 %t69, ptr %for.last.i.68, align 8
  %t71 = load i64, ptr %for.last.i.68, align 8
  %t72 = extractvalue %ArchxVec %t8, 2
  %t73 = getelementptr inbounds i8, ptr %t72, i64 %t71
  %t74 = load i8, ptr %t73, align 1
  %t75 = trunc i8 %t74 to i1
  br i1 %t75, label %if.then.27, label %if.else.28
if.then.27:
  %t76 = load i64, ptr %var.count.66, align 8
  %t77 = add i64 %t76, 1
  store i64 %t77, ptr %var.count.66, align 8
  br label %if.merge.29
if.else.28:
  br label %if.merge.29
if.merge.29:
  br label %for.step.25
for.step.25:
  %t78 = load i64, ptr %for.i.67, align 8
  %t79 = add nsw i64 %t78, 1
  store i64 %t79, ptr %for.i.67, align 8
  br label %for.cond.23
for.end.26:
  %t80 = load i64, ptr %var.count.66, align 8
  call void @free(ptr %t9)
  ret i64 %t80
}

define internal fastcc %ArchxStr @archx_fn_classify(i64 %arg.score) {
entry:
  %t0 = icmp sge i64 %arg.score, 90
  br i1 %t0, label %if.then.0, label %if.else.1
if.then.0:
  ret %ArchxStr { i64 279172874241, i64 0 }
if.else.1:
  %t1 = icmp sge i64 %arg.score, 80
  br i1 %t1, label %if.then.3, label %if.else.4
if.then.3:
  ret %ArchxStr { i64 283467841537, i64 0 }
if.else.4:
  %t2 = icmp sge i64 %arg.score, 70
  br i1 %t2, label %if.then.6, label %if.else.7
if.then.6:
  ret %ArchxStr { i64 287762808833, i64 0 }
if.else.7:
  ret %ArchxStr { i64 300647710721, i64 0 }
if.merge.8:
  unreachable
if.merge.5:
  unreachable
if.merge.2:
  unreachable
}

define i32 @main() {
entry:
  %print.idx.17 = alloca i64, align 8
  %var.stack.32 = alloca %ArchxVec, align 8
  %for.i.33 = alloca i64, align 8
  %for.last.i.34 = alloca i64, align 8
  %print.idx.94 = alloca i64, align 8
  %var.grade.133 = alloca %ArchxStr, align 8
  %t0 = call noalias align 16 ptr @malloc(i64 32)
  %t1 = icmp eq ptr %t0, null
  br i1 %t1, label %alloc.oom.1, label %alloc.ok.0
alloc.oom.1:
  call void @archx_oom_fail()
  unreachable
alloc.ok.0:
  %t2 = getelementptr inbounds i64, ptr %t0, i64 0
  store i64 10, ptr %t2, align 8
  %t3 = getelementptr inbounds i64, ptr %t0, i64 1
  store i64 20, ptr %t3, align 8
  %t4 = getelementptr inbounds i64, ptr %t0, i64 2
  store i64 30, ptr %t4, align 8
  %t5 = getelementptr inbounds i64, ptr %t0, i64 3
  store i64 40, ptr %t5, align 8
  %t6 = insertvalue %ArchxVec poison, i64 4, 0
  %t7 = insertvalue %ArchxVec %t6, i64 4, 1
  %t8 = insertvalue %ArchxVec %t7, ptr %t0, 2
  %t9 = extractvalue %ArchxVec %t8, 2
  %t10 = extractvalue %ArchxVec %t8, 2
  %t11 = getelementptr inbounds i64, ptr %t10, i64 1
  %t12 = load i64, ptr %t11, align 8
  %t13 = add i64 %t12, 5
  store i64 %t13, ptr %t11, align 8
  %t14 = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %t15 = extractvalue %ArchxVec %t8, 0
  %t16 = extractvalue %ArchxVec %t8, 2
  store i64 0, ptr %print.idx.17, align 8
  br label %print.cond.2
print.cond.2:
  %t18 = load i64, ptr %print.idx.17, align 8
  %t19 = icmp slt i64 %t18, %t15
  br i1 %t19, label %print.body.3, label %print.end.6
print.body.3:
  %t20 = icmp sgt i64 %t18, 0
  br i1 %t20, label %print.sep.4, label %print.elem.5
print.sep.4:
  %t21 = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %print.elem.5
print.elem.5:
  %t22 = getelementptr inbounds i64, ptr %t16, i64 %t18
  %t23 = load i64, ptr %t22, align 8
  %t24 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t23)
  %t25 = add nsw i64 %t18, 1
  store i64 %t25, ptr %print.idx.17, align 8
  br label %print.cond.2
print.end.6:
  %t26 = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack)
  %t27 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 4)
  %t28 = insertvalue %ArchxVec poison, i64 0, 0
  %t29 = insertvalue %ArchxVec %t28, i64 0, 1
  %t30 = insertvalue %ArchxVec %t29, ptr null, 2
  %t31 = call fastcc %ArchxVec @archx_vec_clone_i(%ArchxVec %t30)
  store %ArchxVec %t31, ptr %var.stack.32, align 8
  store i64 1, ptr %for.i.33, align 8
  store i64 1, ptr %for.last.i.34, align 8
  br label %for.cond.7
for.cond.7:
  %t35 = load i64, ptr %for.i.33, align 8
  %t36 = icmp slt i64 %t35, 5
  br i1 %t36, label %for.body.8, label %for.end.10
for.body.8:
  store i64 %t35, ptr %for.last.i.34, align 8
  %t37 = load i64, ptr %for.last.i.34, align 8
  %t38 = mul i64 %t37, 10
  %t39 = load %ArchxVec, ptr %var.stack.32, align 8
  %t40 = extractvalue %ArchxVec %t39, 0
  %t41 = extractvalue %ArchxVec %t39, 1
  %t42 = extractvalue %ArchxVec %t39, 2
  %t43 = icmp slt i64 %t41, 0
  %t44 = sub nsw i64 0, %t41
  %t45 = select i1 %t43, i64 %t44, i64 %t41
  %t46 = icmp sge i64 %t40, %t45
  br i1 %t46, label %push.grow.11, label %push.store.12
push.grow.11:
  %t47 = icmp sge i64 %t40, 140737488355328
  br i1 %t47, label %push.oom.13, label %push.calc.14
push.oom.13:
  call void @archx_oom_fail()
  unreachable
push.calc.14:
  %t48 = icmp eq i64 %t45, 0
  %t49 = shl i64 %t45, 1
  %t50 = select i1 %t48, i64 4, i64 %t49
  %t51 = icmp sgt i64 %t50, 140737488355328
  %t52 = select i1 %t51, i64 140737488355328, i64 %t50
  %t53 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t52, i64 8)
  %t54 = extractvalue { i64, i1 } %t53, 0
  %t55 = extractvalue { i64, i1 } %t53, 1
  br i1 %t55, label %mul.oom.15, label %mul.ok.16
mul.oom.15:
  call void @archx_oom_fail()
  unreachable
mul.ok.16:
  %t56 = icmp eq i64 %t54, 0
  %t57 = select i1 %t56, i64 1, i64 %t54
  br i1 %t43, label %push.grow.from_reg.17, label %push.grow.from_heap.18
push.grow.from_reg.17:
  %t58 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t40, i64 8)
  %t59 = extractvalue { i64, i1 } %t58, 0
  %t60 = extractvalue { i64, i1 } %t58, 1
  br i1 %t60, label %mul.oom.19, label %mul.ok.20
mul.oom.19:
  call void @archx_oom_fail()
  unreachable
mul.ok.20:
  %t61 = icmp eq i64 %t59, 0
  %t62 = select i1 %t61, i64 1, i64 %t59
  %t63 = call noalias align 16 ptr @malloc(i64 %t57)
  %t64 = icmp eq ptr %t63, null
  br i1 %t64, label %alloc.oom.22, label %alloc.ok.21
alloc.oom.22:
  call void @archx_oom_fail()
  unreachable
alloc.ok.21:
  %t65 = icmp sgt i64 %t62, 0
  br i1 %t65, label %push.reg.copy.23, label %push.reg.copied.24
push.reg.copy.23:
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %t63, ptr align 8 %t42, i64 %t62, i1 false)
  br label %push.reg.copied.24
push.reg.copied.24:
  %t66 = insertvalue %ArchxVec poison, i64 %t40, 0
  %t67 = insertvalue %ArchxVec %t66, i64 %t52, 1
  %t68 = insertvalue %ArchxVec %t67, ptr %t63, 2
  store %ArchxVec %t68, ptr %var.stack.32, align 8
  br label %push.store.12
push.grow.from_heap.18:
  %t69 = call align 16 ptr @realloc(ptr %t42, i64 %t57)
  %t70 = icmp eq ptr %t69, null
  br i1 %t70, label %realloc.oom.26, label %realloc.ok.25
realloc.oom.26:
  call void @archx_oom_fail()
  unreachable
realloc.ok.25:
  %t71 = insertvalue %ArchxVec poison, i64 %t40, 0
  %t72 = insertvalue %ArchxVec %t71, i64 %t52, 1
  %t73 = insertvalue %ArchxVec %t72, ptr %t69, 2
  store %ArchxVec %t73, ptr %var.stack.32, align 8
  br label %push.store.12
push.store.12:
  %t74 = load %ArchxVec, ptr %var.stack.32, align 8
  %t75 = extractvalue %ArchxVec %t74, 2
  %t76 = getelementptr inbounds i64, ptr %t75, i64 %t40
  store i64 %t38, ptr %t76, align 8
  %t77 = add nsw i64 %t40, 1
  %t78 = insertvalue %ArchxVec %t74, i64 %t77, 0
  store %ArchxVec %t78, ptr %var.stack.32, align 8
  br label %for.step.9
for.step.9:
  %t79 = load i64, ptr %for.i.33, align 8
  %t80 = add nsw i64 %t79, 1
  store i64 %t80, ptr %for.i.33, align 8
  br label %for.cond.7
for.end.10:
  %t81 = load %ArchxVec, ptr %var.stack.32, align 8
  %t82 = extractvalue %ArchxVec %t81, 0
  %t83 = icmp sle i64 %t82, 0
  br i1 %t83, label %pop.empty.28, label %pop.ok.27
pop.empty.28:
  call void @archx_pop_empty_fail()
  unreachable
pop.ok.27:
  %t84 = sub nsw i64 %t82, 1
  %t85 = extractvalue %ArchxVec %t81, 2
  %t86 = getelementptr inbounds i64, ptr %t85, i64 %t84
  %t87 = load i64, ptr %t86, align 8
  %t88 = insertvalue %ArchxVec %t81, i64 %t84, 0
  store %ArchxVec %t88, ptr %var.stack.32, align 8
  %t89 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t87)
  %t90 = load %ArchxVec, ptr %var.stack.32, align 8
  %t91 = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %t92 = extractvalue %ArchxVec %t90, 0
  %t93 = extractvalue %ArchxVec %t90, 2
  store i64 0, ptr %print.idx.94, align 8
  br label %print.cond.29
print.cond.29:
  %t95 = load i64, ptr %print.idx.94, align 8
  %t96 = icmp slt i64 %t95, %t92
  br i1 %t96, label %print.body.30, label %print.end.33
print.body.30:
  %t97 = icmp sgt i64 %t95, 0
  br i1 %t97, label %print.sep.31, label %print.elem.32
print.sep.31:
  %t98 = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %print.elem.32
print.elem.32:
  %t99 = getelementptr inbounds i64, ptr %t93, i64 %t95
  %t100 = load i64, ptr %t99, align 8
  %t101 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t100)
  %t102 = add nsw i64 %t95, 1
  store i64 %t102, ptr %print.idx.94, align 8
  br label %print.cond.29
print.end.33:
  %t103 = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack)
  %t104 = call noalias align 16 ptr @malloc(i64 32)
  %t105 = icmp eq ptr %t104, null
  br i1 %t105, label %alloc.oom.35, label %alloc.ok.34
alloc.oom.35:
  call void @archx_oom_fail()
  unreachable
alloc.ok.34:
  %t106 = getelementptr inbounds i64, ptr %t104, i64 0
  store i64 1, ptr %t106, align 8
  %t107 = getelementptr inbounds i64, ptr %t104, i64 1
  store i64 2, ptr %t107, align 8
  %t108 = getelementptr inbounds i64, ptr %t104, i64 2
  store i64 3, ptr %t108, align 8
  %t109 = getelementptr inbounds i64, ptr %t104, i64 3
  store i64 4, ptr %t109, align 8
  %t110 = insertvalue %ArchxVec poison, i64 4, 0
  %t111 = insertvalue %ArchxVec %t110, i64 4, 1
  %t112 = insertvalue %ArchxVec %t111, ptr %t104, 2
  %t113 = call noalias align 16 ptr @malloc(i64 32)
  %t114 = icmp eq ptr %t113, null
  br i1 %t114, label %alloc.oom.37, label %alloc.ok.36
alloc.oom.37:
  call void @archx_oom_fail()
  unreachable
alloc.ok.36:
  %t115 = getelementptr inbounds i64, ptr %t113, i64 0
  store i64 10, ptr %t115, align 8
  %t116 = getelementptr inbounds i64, ptr %t113, i64 1
  store i64 20, ptr %t116, align 8
  %t117 = getelementptr inbounds i64, ptr %t113, i64 2
  store i64 30, ptr %t117, align 8
  %t118 = getelementptr inbounds i64, ptr %t113, i64 3
  store i64 40, ptr %t118, align 8
  %t119 = insertvalue %ArchxVec poison, i64 4, 0
  %t120 = insertvalue %ArchxVec %t119, i64 4, 1
  %t121 = insertvalue %ArchxVec %t120, ptr %t113, 2
  %t122 = call fastcc i64 @archx_fn_dot(%ArchxVec %t112, %ArchxVec %t121)
  %t123 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t122)
  %t124 = extractvalue %ArchxVec %t121, 1
  %t125 = icmp sgt i64 %t124, 0
  br i1 %t125, label %drop.vec.free.38, label %drop.vec.done.39
drop.vec.free.38:
  %t126 = extractvalue %ArchxVec %t121, 2
  call void @free(ptr %t126)
  br label %drop.vec.done.39
drop.vec.done.39:
  %t127 = extractvalue %ArchxVec %t112, 1
  %t128 = icmp sgt i64 %t127, 0
  br i1 %t128, label %drop.vec.free.40, label %drop.vec.done.41
drop.vec.free.40:
  %t129 = extractvalue %ArchxVec %t112, 2
  call void @free(ptr %t129)
  br label %drop.vec.done.41
drop.vec.done.41:
  %t130 = call fastcc i64 @archx_fn_sieve_count(i64 100)
  %t131 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t130)
  %t132 = call fastcc %ArchxStr @archx_fn_classify(i64 85)
  store %ArchxStr %t132, ptr %var.grade.133, align 8
  %t134 = load %ArchxStr, ptr %var.grade.133, align 8
  call fastcc void @archx_str_print(%ArchxStr %t134, i1 true)
  %t135 = load %ArchxStr, ptr %var.grade.133, align 8
  %t136 = call fastcc i1 @archx_str_eq(%ArchxStr %t135, %ArchxStr { i64 283467841537, i64 0 })
  %t137 = select i1 %t136, ptr @.str.true, ptr @.str.false
  %t138 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t137)
  %t139 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 5)
  %t140 = load %ArchxStr, ptr %var.grade.133, align 8
  call fastcc void @archx_str_drop(%ArchxStr %t140)
  %t141 = load %ArchxVec, ptr %var.stack.32, align 8
  %t142 = extractvalue %ArchxVec %t141, 1
  %t143 = icmp sgt i64 %t142, 0
  br i1 %t143, label %drop.vec.free.42, label %drop.vec.done.43
drop.vec.free.42:
  %t144 = extractvalue %ArchxVec %t141, 2
  call void @free(ptr %t144)
  br label %drop.vec.done.43
drop.vec.done.43:
  call void @free(ptr %t9)
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

define private fastcc i1 @archx_str_eq(%ArchxStr %a, %ArchxStr %b) alwaysinline nounwind {
entry:
  %aw0 = extractvalue %ArchxStr %a, 0
  %bw0 = extractvalue %ArchxStr %b, 0
  %w0_eq = icmp eq i64 %aw0, %bw0
  br i1 %w0_eq, label %chk_len, label %ret_false
chk_len:
  %len = and i64 %aw0, 4294967295
  %aw1 = extractvalue %ArchxStr %a, 1
  %bw1 = extractvalue %ArchxStr %b, 1
  %short = icmp ule i64 %len, 12
  br i1 %short, label %cmp_short, label %cmp_long
cmp_short:
  %eq_s = icmp eq i64 %aw1, %bw1
  ret i1 %eq_s
cmp_long:
  %ap_i = and i64 %aw1, -4
  %bp_i = and i64 %bw1, -4
  %same_ptr = icmp eq i64 %ap_i, %bp_i
  br i1 %same_ptr, label %ret_true, label %do_memcmp
do_memcmp:
  %ap = inttoptr i64 %ap_i to ptr
  %bp = inttoptr i64 %bp_i to ptr
  %ap4 = getelementptr inbounds i8, ptr %ap, i64 4
  %bp4 = getelementptr inbounds i8, ptr %bp, i64 4
  %rem = sub nuw nsw i64 %len, 4
  %mc = call i32 @memcmp(ptr nonnull %ap4, ptr nonnull %bp4, i64 %rem)
  %eq_m = icmp eq i32 %mc, 0
  ret i1 %eq_m
ret_true:
  ret i1 true
ret_false:
  ret i1 false
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

@.err.bounds = private unnamed_addr constant [63 x i8] c"archx runtime panic: index %lld out of bounds for length %lld\0A\00", align 1

define private void @archx_bounds_fail(i64 %idx, i64 %len) cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.bounds, i64 %idx, i64 %len)
  call void @exit(i32 101)
  unreachable
}

@.err.neglen = private unnamed_addr constant [53 x i8] c"archx runtime panic: invalid array/step size (%lld)\0A\00", align 1

define private void @archx_neg_len_fail(i64 %n) cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.neglen, i64 %n)
  call void @exit(i32 101)
  unreachable
}

@.err.pop = private unnamed_addr constant [46 x i8] c"archx runtime panic: pop from an empty array\0A\00", align 1

define private void @archx_pop_empty_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.pop)
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
declare i32 @memcmp(ptr nocapture, ptr nocapture, i64) nounwind readonly
declare ptr @memchr(ptr nocapture, i32, i64) nounwind readonly
declare i32 @putchar(i32)
declare void @exit(i32) cold noreturn nounwind
@.fmt.lbrace = private unnamed_addr constant [2 x i8] c"{\00", align 1
@.fmt.rbrace = private unnamed_addr constant [2 x i8] c"}\00", align 1
@.fmt.colon = private unnamed_addr constant [3 x i8] c": \00", align 1
@.fmt.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
