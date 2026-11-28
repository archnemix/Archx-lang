; Archx LLVM IR module
; archx.dialect=native version=1 source=directive

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
  %t17 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t12, i64 %t16)
  %t18 = extractvalue { i64, i1 } %t17, 0
  %t19 = extractvalue { i64, i1 } %t17, 1
  br i1 %t19, label %overflow.mul.7, label %overflow.ok.8
overflow.mul.7:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.8:
  %t20 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t8, i64 %t18)
  %t21 = extractvalue { i64, i1 } %t20, 0
  %t22 = extractvalue { i64, i1 } %t20, 1
  br i1 %t22, label %overflow.add.9, label %overflow.ok.10
overflow.add.9:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.10:
  store i64 %t21, ptr %var.total.0, align 8
  br label %for.fast.step.2
for.fast.step.2:
  %t23 = load i64, ptr %for.i.2, align 8
  %t24 = add nsw i64 %t23, 1
  store i64 %t24, ptr %for.i.2, align 8
  br label %for.fast.cond.0
for.cond.3:
  %t25 = load i64, ptr %for.i.2, align 8
  %t26 = icmp slt i64 %t25, %t1
  br i1 %t26, label %for.body.4, label %for.end.6
for.body.4:
  store i64 %t25, ptr %for.last.i.3, align 8
  %t27 = load i64, ptr %var.total.0, align 8
  %t28 = load i64, ptr %for.last.i.3, align 8
  %t29 = extractvalue %ArchxVec %arg.a, 2
  %t30 = getelementptr inbounds i64, ptr %t29, i64 %t28
  %t31 = load i64, ptr %t30, align 8
  %t32 = load i64, ptr %for.last.i.3, align 8
  %t33 = extractvalue %ArchxVec %arg.b, 0
  %t34 = icmp uge i64 %t32, %t33
  br i1 %t34, label %idx.oob.12, label %idx.ok.11
idx.oob.12:
  call void @archx_bounds_fail(i64 %t32, i64 %t33)
  unreachable
idx.ok.11:
  %t35 = extractvalue %ArchxVec %arg.b, 2
  %t36 = getelementptr inbounds i64, ptr %t35, i64 %t32
  %t37 = load i64, ptr %t36, align 8
  %t38 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t31, i64 %t37)
  %t39 = extractvalue { i64, i1 } %t38, 0
  %t40 = extractvalue { i64, i1 } %t38, 1
  br i1 %t40, label %overflow.mul.13, label %overflow.ok.14
overflow.mul.13:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.14:
  %t41 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t27, i64 %t39)
  %t42 = extractvalue { i64, i1 } %t41, 0
  %t43 = extractvalue { i64, i1 } %t41, 1
  br i1 %t43, label %overflow.add.15, label %overflow.ok.16
overflow.add.15:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.16:
  store i64 %t42, ptr %var.total.0, align 8
  br label %for.step.5
for.step.5:
  %t44 = load i64, ptr %for.i.2, align 8
  %t45 = add nsw i64 %t44, 1
  store i64 %t45, ptr %for.i.2, align 8
  br label %for.cond.3
for.end.6:
  %t46 = load i64, ptr %var.total.0, align 8
  ret i64 %t46
}

define internal fastcc i64 @archx_fn_sieve_count(i64 %arg.limit) {
entry:
  %var.p.20 = alloca i64, align 8
  %var.j.39 = alloca i64, align 8
  %var.count.76 = alloca i64, align 8
  %for.i.77 = alloca i64, align 8
  %for.last.i.78 = alloca i64, align 8
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
  %t23 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t21, i64 %t22)
  %t24 = extractvalue { i64, i1 } %t23, 0
  %t25 = extractvalue { i64, i1 } %t23, 1
  br i1 %t25, label %overflow.mul.11, label %overflow.ok.12
overflow.mul.11:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.12:
  %t26 = icmp slt i64 %t24, %arg.limit
  br i1 %t26, label %while.body.9, label %while.end.10
while.body.9:
  %t27 = load i64, ptr %var.p.20, align 8
  %t28 = extractvalue %ArchxVec %t8, 0
  %t29 = icmp uge i64 %t27, %t28
  br i1 %t29, label %idx.oob.14, label %idx.ok.13
idx.oob.14:
  call void @archx_bounds_fail(i64 %t27, i64 %t28)
  unreachable
idx.ok.13:
  %t30 = extractvalue %ArchxVec %t8, 2
  %t31 = getelementptr inbounds i8, ptr %t30, i64 %t27
  %t32 = load i8, ptr %t31, align 1
  %t33 = trunc i8 %t32 to i1
  br i1 %t33, label %if.then.15, label %if.else.16
if.then.15:
  %t34 = load i64, ptr %var.p.20, align 8
  %t35 = load i64, ptr %var.p.20, align 8
  %t36 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t34, i64 %t35)
  %t37 = extractvalue { i64, i1 } %t36, 0
  %t38 = extractvalue { i64, i1 } %t36, 1
  br i1 %t38, label %overflow.mul.18, label %overflow.ok.19
overflow.mul.18:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.19:
  store i64 %t37, ptr %var.j.39, align 8
  %t40 = load i64, ptr %var.j.39, align 8
  %t41 = icmp sge i64 %t40, 0
  %t42 = icmp ule i64 %arg.limit, 140737488355328
  %t43 = and i1 %t41, %t42
  %t44 = load i64, ptr %var.p.20, align 8
  %t45 = sub i64 %t44, 1
  %t46 = icmp ult i64 %t45, 140737488355328
  %t47 = and i1 %t43, %t46
  br i1 %t47, label %while.fast.cond.20, label %while.cond.22
while.fast.cond.20:
  %t48 = load i64, ptr %var.j.39, align 8
  %t49 = icmp slt i64 %t48, %arg.limit
  br i1 %t49, label %while.fast.body.21, label %while.end.24
while.fast.body.21:
  %t50 = load i64, ptr %var.j.39, align 8
  %t51 = extractvalue %ArchxVec %t8, 2
  %t52 = getelementptr inbounds i8, ptr %t51, i64 %t50
  %t53 = zext i1 false to i8
  store i8 %t53, ptr %t52, align 1
  %t54 = load i64, ptr %var.j.39, align 8
  %t55 = load i64, ptr %var.p.20, align 8
  %t56 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t54, i64 %t55)
  %t57 = extractvalue { i64, i1 } %t56, 0
  %t58 = extractvalue { i64, i1 } %t56, 1
  br i1 %t58, label %overflow.add.25, label %overflow.ok.26
overflow.add.25:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.26:
  store i64 %t57, ptr %var.j.39, align 8
  br label %while.fast.cond.20
while.cond.22:
  %t59 = load i64, ptr %var.j.39, align 8
  %t60 = icmp slt i64 %t59, %arg.limit
  br i1 %t60, label %while.body.23, label %while.end.24
while.body.23:
  %t61 = load i64, ptr %var.j.39, align 8
  %t62 = extractvalue %ArchxVec %t8, 0
  %t63 = icmp uge i64 %t61, %t62
  br i1 %t63, label %idx.oob.28, label %idx.ok.27
idx.oob.28:
  call void @archx_bounds_fail(i64 %t61, i64 %t62)
  unreachable
idx.ok.27:
  %t64 = extractvalue %ArchxVec %t8, 2
  %t65 = getelementptr inbounds i8, ptr %t64, i64 %t61
  %t66 = zext i1 false to i8
  store i8 %t66, ptr %t65, align 1
  %t67 = load i64, ptr %var.j.39, align 8
  %t68 = load i64, ptr %var.p.20, align 8
  %t69 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t67, i64 %t68)
  %t70 = extractvalue { i64, i1 } %t69, 0
  %t71 = extractvalue { i64, i1 } %t69, 1
  br i1 %t71, label %overflow.add.29, label %overflow.ok.30
overflow.add.29:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.30:
  store i64 %t70, ptr %var.j.39, align 8
  br label %while.cond.22
while.end.24:
  br label %if.merge.17
if.else.16:
  br label %if.merge.17
if.merge.17:
  %t72 = load i64, ptr %var.p.20, align 8
  %t73 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t72, i64 1)
  %t74 = extractvalue { i64, i1 } %t73, 0
  %t75 = extractvalue { i64, i1 } %t73, 1
  br i1 %t75, label %overflow.add.31, label %overflow.ok.32
overflow.add.31:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.32:
  store i64 %t74, ptr %var.p.20, align 8
  br label %while.cond.8
while.end.10:
  store i64 0, ptr %var.count.76, align 8
  store i64 2, ptr %for.i.77, align 8
  store i64 2, ptr %for.last.i.78, align 8
  br label %for.cond.33
for.cond.33:
  %t79 = load i64, ptr %for.i.77, align 8
  %t80 = icmp slt i64 %t79, %arg.limit
  br i1 %t80, label %for.body.34, label %for.end.36
for.body.34:
  store i64 %t79, ptr %for.last.i.78, align 8
  %t81 = load i64, ptr %for.last.i.78, align 8
  %t82 = extractvalue %ArchxVec %t8, 2
  %t83 = getelementptr inbounds i8, ptr %t82, i64 %t81
  %t84 = load i8, ptr %t83, align 1
  %t85 = trunc i8 %t84 to i1
  br i1 %t85, label %if.then.37, label %if.else.38
if.then.37:
  %t86 = load i64, ptr %var.count.76, align 8
  %t87 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t86, i64 1)
  %t88 = extractvalue { i64, i1 } %t87, 0
  %t89 = extractvalue { i64, i1 } %t87, 1
  br i1 %t89, label %overflow.add.40, label %overflow.ok.41
overflow.add.40:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.41:
  store i64 %t88, ptr %var.count.76, align 8
  br label %if.merge.39
if.else.38:
  br label %if.merge.39
if.merge.39:
  br label %for.step.35
for.step.35:
  %t90 = load i64, ptr %for.i.77, align 8
  %t91 = add nsw i64 %t90, 1
  store i64 %t91, ptr %for.i.77, align 8
  br label %for.cond.33
for.end.36:
  %t92 = load i64, ptr %var.count.76, align 8
  call void @free(ptr %t9)
  ret i64 %t92
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
  %print.idx.19 = alloca i64, align 8
  %var.stack.34 = alloca %ArchxVec, align 8
  %for.i.35 = alloca i64, align 8
  %for.last.i.36 = alloca i64, align 8
  %print.idx.98 = alloca i64, align 8
  %var.grade.137 = alloca %ArchxStr, align 8
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
  %t13 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t12, i64 5)
  %t14 = extractvalue { i64, i1 } %t13, 0
  %t15 = extractvalue { i64, i1 } %t13, 1
  br i1 %t15, label %overflow.add.2, label %overflow.ok.3
overflow.add.2:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.3:
  store i64 %t14, ptr %t11, align 8
  %t16 = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %t17 = extractvalue %ArchxVec %t8, 0
  %t18 = extractvalue %ArchxVec %t8, 2
  store i64 0, ptr %print.idx.19, align 8
  br label %print.cond.4
print.cond.4:
  %t20 = load i64, ptr %print.idx.19, align 8
  %t21 = icmp slt i64 %t20, %t17
  br i1 %t21, label %print.body.5, label %print.end.8
print.body.5:
  %t22 = icmp sgt i64 %t20, 0
  br i1 %t22, label %print.sep.6, label %print.elem.7
print.sep.6:
  %t23 = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %print.elem.7
print.elem.7:
  %t24 = getelementptr inbounds i64, ptr %t18, i64 %t20
  %t25 = load i64, ptr %t24, align 8
  %t26 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t25)
  %t27 = add nsw i64 %t20, 1
  store i64 %t27, ptr %print.idx.19, align 8
  br label %print.cond.4
print.end.8:
  %t28 = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack)
  %t29 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 4)
  %t30 = insertvalue %ArchxVec poison, i64 0, 0
  %t31 = insertvalue %ArchxVec %t30, i64 0, 1
  %t32 = insertvalue %ArchxVec %t31, ptr null, 2
  %t33 = call fastcc %ArchxVec @archx_vec_clone_i(%ArchxVec %t32)
  store %ArchxVec %t33, ptr %var.stack.34, align 8
  store i64 1, ptr %for.i.35, align 8
  store i64 1, ptr %for.last.i.36, align 8
  br label %for.cond.9
for.cond.9:
  %t37 = load i64, ptr %for.i.35, align 8
  %t38 = icmp slt i64 %t37, 5
  br i1 %t38, label %for.body.10, label %for.end.12
for.body.10:
  store i64 %t37, ptr %for.last.i.36, align 8
  %t39 = load i64, ptr %for.last.i.36, align 8
  %t40 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t39, i64 10)
  %t41 = extractvalue { i64, i1 } %t40, 0
  %t42 = extractvalue { i64, i1 } %t40, 1
  br i1 %t42, label %overflow.mul.13, label %overflow.ok.14
overflow.mul.13:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.14:
  %t43 = load %ArchxVec, ptr %var.stack.34, align 8
  %t44 = extractvalue %ArchxVec %t43, 0
  %t45 = extractvalue %ArchxVec %t43, 1
  %t46 = extractvalue %ArchxVec %t43, 2
  %t47 = icmp slt i64 %t45, 0
  %t48 = sub nsw i64 0, %t45
  %t49 = select i1 %t47, i64 %t48, i64 %t45
  %t50 = icmp sge i64 %t44, %t49
  br i1 %t50, label %push.grow.15, label %push.store.16
push.grow.15:
  %t51 = icmp sge i64 %t44, 140737488355328
  br i1 %t51, label %push.oom.17, label %push.calc.18
push.oom.17:
  call void @archx_oom_fail()
  unreachable
push.calc.18:
  %t52 = icmp eq i64 %t49, 0
  %t53 = shl i64 %t49, 1
  %t54 = select i1 %t52, i64 4, i64 %t53
  %t55 = icmp sgt i64 %t54, 140737488355328
  %t56 = select i1 %t55, i64 140737488355328, i64 %t54
  %t57 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t56, i64 8)
  %t58 = extractvalue { i64, i1 } %t57, 0
  %t59 = extractvalue { i64, i1 } %t57, 1
  br i1 %t59, label %mul.oom.19, label %mul.ok.20
mul.oom.19:
  call void @archx_oom_fail()
  unreachable
mul.ok.20:
  %t60 = icmp eq i64 %t58, 0
  %t61 = select i1 %t60, i64 1, i64 %t58
  br i1 %t47, label %push.grow.from_reg.21, label %push.grow.from_heap.22
push.grow.from_reg.21:
  %t62 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t44, i64 8)
  %t63 = extractvalue { i64, i1 } %t62, 0
  %t64 = extractvalue { i64, i1 } %t62, 1
  br i1 %t64, label %mul.oom.23, label %mul.ok.24
mul.oom.23:
  call void @archx_oom_fail()
  unreachable
mul.ok.24:
  %t65 = icmp eq i64 %t63, 0
  %t66 = select i1 %t65, i64 1, i64 %t63
  %t67 = call noalias align 16 ptr @malloc(i64 %t61)
  %t68 = icmp eq ptr %t67, null
  br i1 %t68, label %alloc.oom.26, label %alloc.ok.25
alloc.oom.26:
  call void @archx_oom_fail()
  unreachable
alloc.ok.25:
  %t69 = icmp sgt i64 %t66, 0
  br i1 %t69, label %push.reg.copy.27, label %push.reg.copied.28
push.reg.copy.27:
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %t67, ptr align 8 %t46, i64 %t66, i1 false)
  br label %push.reg.copied.28
push.reg.copied.28:
  %t70 = insertvalue %ArchxVec poison, i64 %t44, 0
  %t71 = insertvalue %ArchxVec %t70, i64 %t56, 1
  %t72 = insertvalue %ArchxVec %t71, ptr %t67, 2
  store %ArchxVec %t72, ptr %var.stack.34, align 8
  br label %push.store.16
push.grow.from_heap.22:
  %t73 = call align 16 ptr @realloc(ptr %t46, i64 %t61)
  %t74 = icmp eq ptr %t73, null
  br i1 %t74, label %realloc.oom.30, label %realloc.ok.29
realloc.oom.30:
  call void @archx_oom_fail()
  unreachable
realloc.ok.29:
  %t75 = insertvalue %ArchxVec poison, i64 %t44, 0
  %t76 = insertvalue %ArchxVec %t75, i64 %t56, 1
  %t77 = insertvalue %ArchxVec %t76, ptr %t73, 2
  store %ArchxVec %t77, ptr %var.stack.34, align 8
  br label %push.store.16
push.store.16:
  %t78 = load %ArchxVec, ptr %var.stack.34, align 8
  %t79 = extractvalue %ArchxVec %t78, 2
  %t80 = getelementptr inbounds i64, ptr %t79, i64 %t44
  store i64 %t41, ptr %t80, align 8
  %t81 = add nsw i64 %t44, 1
  %t82 = insertvalue %ArchxVec %t78, i64 %t81, 0
  store %ArchxVec %t82, ptr %var.stack.34, align 8
  br label %for.step.11
for.step.11:
  %t83 = load i64, ptr %for.i.35, align 8
  %t84 = add nsw i64 %t83, 1
  store i64 %t84, ptr %for.i.35, align 8
  br label %for.cond.9
for.end.12:
  %t85 = load %ArchxVec, ptr %var.stack.34, align 8
  %t86 = extractvalue %ArchxVec %t85, 0
  %t87 = icmp sle i64 %t86, 0
  br i1 %t87, label %pop.empty.32, label %pop.ok.31
pop.empty.32:
  call void @archx_pop_empty_fail()
  unreachable
pop.ok.31:
  %t88 = sub nsw i64 %t86, 1
  %t89 = extractvalue %ArchxVec %t85, 2
  %t90 = getelementptr inbounds i64, ptr %t89, i64 %t88
  %t91 = load i64, ptr %t90, align 8
  %t92 = insertvalue %ArchxVec %t85, i64 %t88, 0
  store %ArchxVec %t92, ptr %var.stack.34, align 8
  %t93 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t91)
  %t94 = load %ArchxVec, ptr %var.stack.34, align 8
  %t95 = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %t96 = extractvalue %ArchxVec %t94, 0
  %t97 = extractvalue %ArchxVec %t94, 2
  store i64 0, ptr %print.idx.98, align 8
  br label %print.cond.33
print.cond.33:
  %t99 = load i64, ptr %print.idx.98, align 8
  %t100 = icmp slt i64 %t99, %t96
  br i1 %t100, label %print.body.34, label %print.end.37
print.body.34:
  %t101 = icmp sgt i64 %t99, 0
  br i1 %t101, label %print.sep.35, label %print.elem.36
print.sep.35:
  %t102 = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %print.elem.36
print.elem.36:
  %t103 = getelementptr inbounds i64, ptr %t97, i64 %t99
  %t104 = load i64, ptr %t103, align 8
  %t105 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t104)
  %t106 = add nsw i64 %t99, 1
  store i64 %t106, ptr %print.idx.98, align 8
  br label %print.cond.33
print.end.37:
  %t107 = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack)
  %t108 = call noalias align 16 ptr @malloc(i64 32)
  %t109 = icmp eq ptr %t108, null
  br i1 %t109, label %alloc.oom.39, label %alloc.ok.38
alloc.oom.39:
  call void @archx_oom_fail()
  unreachable
alloc.ok.38:
  %t110 = getelementptr inbounds i64, ptr %t108, i64 0
  store i64 1, ptr %t110, align 8
  %t111 = getelementptr inbounds i64, ptr %t108, i64 1
  store i64 2, ptr %t111, align 8
  %t112 = getelementptr inbounds i64, ptr %t108, i64 2
  store i64 3, ptr %t112, align 8
  %t113 = getelementptr inbounds i64, ptr %t108, i64 3
  store i64 4, ptr %t113, align 8
  %t114 = insertvalue %ArchxVec poison, i64 4, 0
  %t115 = insertvalue %ArchxVec %t114, i64 4, 1
  %t116 = insertvalue %ArchxVec %t115, ptr %t108, 2
  %t117 = call noalias align 16 ptr @malloc(i64 32)
  %t118 = icmp eq ptr %t117, null
  br i1 %t118, label %alloc.oom.41, label %alloc.ok.40
alloc.oom.41:
  call void @archx_oom_fail()
  unreachable
alloc.ok.40:
  %t119 = getelementptr inbounds i64, ptr %t117, i64 0
  store i64 10, ptr %t119, align 8
  %t120 = getelementptr inbounds i64, ptr %t117, i64 1
  store i64 20, ptr %t120, align 8
  %t121 = getelementptr inbounds i64, ptr %t117, i64 2
  store i64 30, ptr %t121, align 8
  %t122 = getelementptr inbounds i64, ptr %t117, i64 3
  store i64 40, ptr %t122, align 8
  %t123 = insertvalue %ArchxVec poison, i64 4, 0
  %t124 = insertvalue %ArchxVec %t123, i64 4, 1
  %t125 = insertvalue %ArchxVec %t124, ptr %t117, 2
  %t126 = call fastcc i64 @archx_fn_dot(%ArchxVec %t116, %ArchxVec %t125)
  %t127 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t126)
  %t128 = extractvalue %ArchxVec %t125, 1
  %t129 = icmp sgt i64 %t128, 0
  br i1 %t129, label %drop.vec.free.42, label %drop.vec.done.43
drop.vec.free.42:
  %t130 = extractvalue %ArchxVec %t125, 2
  call void @free(ptr %t130)
  br label %drop.vec.done.43
drop.vec.done.43:
  %t131 = extractvalue %ArchxVec %t116, 1
  %t132 = icmp sgt i64 %t131, 0
  br i1 %t132, label %drop.vec.free.44, label %drop.vec.done.45
drop.vec.free.44:
  %t133 = extractvalue %ArchxVec %t116, 2
  call void @free(ptr %t133)
  br label %drop.vec.done.45
drop.vec.done.45:
  %t134 = call fastcc i64 @archx_fn_sieve_count(i64 100)
  %t135 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t134)
  %t136 = call fastcc %ArchxStr @archx_fn_classify(i64 85)
  store %ArchxStr %t136, ptr %var.grade.137, align 8
  %t138 = load %ArchxStr, ptr %var.grade.137, align 8
  call fastcc void @archx_str_print(%ArchxStr %t138, i1 true)
  %t139 = load %ArchxStr, ptr %var.grade.137, align 8
  %t140 = call fastcc i1 @archx_str_eq(%ArchxStr %t139, %ArchxStr { i64 283467841537, i64 0 })
  %t141 = select i1 %t140, ptr @.str.true, ptr @.str.false
  %t142 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t141)
  %t143 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 5)
  %t144 = load %ArchxStr, ptr %var.grade.137, align 8
  call fastcc void @archx_str_drop(%ArchxStr %t144)
  %t145 = load %ArchxVec, ptr %var.stack.34, align 8
  %t146 = extractvalue %ArchxVec %t145, 1
  %t147 = icmp sgt i64 %t146, 0
  br i1 %t147, label %drop.vec.free.46, label %drop.vec.done.47
drop.vec.free.46:
  %t148 = extractvalue %ArchxVec %t145, 2
  call void @free(ptr %t148)
  br label %drop.vec.done.47
drop.vec.done.47:
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

@.err.overflow = private unnamed_addr constant [39 x i8] c"archx runtime panic: integer overflow\0A\00", align 1

define private void @archx_int_overflow_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.overflow)
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
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) nounwind readnone speculatable
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) nounwind readnone speculatable
declare i32 @memcmp(ptr nocapture, ptr nocapture, i64) nounwind readonly
declare ptr @memchr(ptr nocapture, i32, i64) nounwind readonly
declare i32 @putchar(i32)
declare void @exit(i32) cold noreturn nounwind
@.fmt.lbrace = private unnamed_addr constant [2 x i8] c"{\00", align 1
@.fmt.rbrace = private unnamed_addr constant [2 x i8] c"}\00", align 1
@.fmt.colon = private unnamed_addr constant [3 x i8] c": \00", align 1
@.fmt.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

!llvm.module.flags = !{!0, !1}
!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
