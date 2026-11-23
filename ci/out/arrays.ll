; Archx module
%ArchxVec = type { i64, i64, ptr }

declare i32 @printf(ptr, ...)
declare i32 @strcmp(ptr, ptr)
declare noalias align 16 ptr @malloc(i64)
declare align 16 ptr @realloc(ptr, i64)
declare void @free(ptr)
declare void @exit(i32) noreturn nounwind

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.str.true = private unnamed_addr constant [5 x i8] c"true\00"
@.str.false = private unnamed_addr constant [6 x i8] c"false\00"
@.fmt.lbrack = private unnamed_addr constant [2 x i8] c"[\00"
@.fmt.sep = private unnamed_addr constant [3 x i8] c", \00"
@.fmt.rbrack = private unnamed_addr constant [3 x i8] c"]\0A\00"
@.fmt.int.elem = private unnamed_addr constant [5 x i8] c"%lld\00"
@.fmt.str.elem = private unnamed_addr constant [3 x i8] c"%s\00"
@.fmt.oob = private unnamed_addr constant [55 x i8] c"archx panic: index %lld out of bounds for length %lld\0A\00"
@.fmt.neglen = private unnamed_addr constant [40 x i8] c"archx panic: invalid array length %lld\0A\00"
@.fmt.emptypop = private unnamed_addr constant [35 x i8] c"archx panic: pop from empty array\0A\00"
@.str.0 = private unnamed_addr constant [2 x i8] c"A\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"B\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"C\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"F\00"
@.str.4 = private unnamed_addr constant [6 x i8] c"archx\00"

define private void @archx_bounds_fail(i64 %idx, i64 %len) cold noreturn nounwind {
entry:
  %0 = call i32 (ptr, ...) @printf(ptr @.fmt.oob, i64 %idx, i64 %len)
  call void @exit(i32 101)
  unreachable
}

define private void @archx_neg_len_fail(i64 %len) cold noreturn nounwind {
entry:
  %0 = call i32 (ptr, ...) @printf(ptr @.fmt.neglen, i64 %len)
  call void @exit(i32 101)
  unreachable
}

define private void @archx_empty_pop_fail() cold noreturn nounwind {
entry:
  %0 = call i32 (ptr, ...) @printf(ptr @.fmt.emptypop)
  call void @exit(i32 101)
  unreachable
}

define internal i64 @archx_dot(%ArchxVec %param.a, %ArchxVec %param.b) nounwind {
entry:
  %var.total.0 = alloca i64, align 8
  %for.i.2 = alloca i64, align 8
  store i64 0, ptr %var.total.0, align 8
  %t1 = extractvalue %ArchxVec %param.a, 0
  store i64 0, ptr %for.i.2, align 8
  %t3 = extractvalue %ArchxVec %param.b, 0
  %t4 = icmp ule i64 %t1, %t3
  br i1 %t4, label %for.fast.cond.0, label %for.cond.3

for.fast.cond.0:
  %t5 = load i64, ptr %for.i.2, align 8
  %t6 = icmp slt i64 %t5, %t1
  br i1 %t6, label %for.fast.body.1, label %for.end.6

for.fast.body.1:
  %t7 = load i64, ptr %var.total.0, align 8
  %t8 = load i64, ptr %for.i.2, align 8
  %t9 = extractvalue %ArchxVec %param.a, 2
  %t10 = getelementptr inbounds i64, ptr %t9, i64 %t8
  %t11 = load i64, ptr %t10, align 8
  %t12 = load i64, ptr %for.i.2, align 8
  %t13 = extractvalue %ArchxVec %param.b, 2
  %t14 = getelementptr inbounds i64, ptr %t13, i64 %t12
  %t15 = load i64, ptr %t14, align 8
  %t16 = mul i64 %t11, %t15
  %t17 = add i64 %t7, %t16
  store i64 %t17, ptr %var.total.0, align 8
  br label %for.fast.step.2

for.fast.step.2:
  %t18 = load i64, ptr %for.i.2, align 8
  %t19 = add nsw i64 %t18, 1
  store i64 %t19, ptr %for.i.2, align 8
  br label %for.fast.cond.0

for.cond.3:
  %t20 = load i64, ptr %for.i.2, align 8
  %t21 = icmp slt i64 %t20, %t1
  br i1 %t21, label %for.body.4, label %for.end.6

for.body.4:
  %t22 = load i64, ptr %var.total.0, align 8
  %t23 = load i64, ptr %for.i.2, align 8
  %t24 = extractvalue %ArchxVec %param.a, 2
  %t25 = getelementptr inbounds i64, ptr %t24, i64 %t23
  %t26 = load i64, ptr %t25, align 8
  %t27 = load i64, ptr %for.i.2, align 8
  %t28 = extractvalue %ArchxVec %param.b, 0
  %t29 = icmp ult i64 %t27, %t28
  br i1 %t29, label %idx.ok.7, label %idx.oob.8

idx.oob.8:
  call void @archx_bounds_fail(i64 %t27, i64 %t28)
  unreachable

idx.ok.7:
  %t30 = extractvalue %ArchxVec %param.b, 2
  %t31 = getelementptr inbounds i64, ptr %t30, i64 %t27
  %t32 = load i64, ptr %t31, align 8
  %t33 = mul i64 %t26, %t32
  %t34 = add i64 %t22, %t33
  store i64 %t34, ptr %var.total.0, align 8
  br label %for.step.5

for.step.5:
  %t35 = load i64, ptr %for.i.2, align 8
  %t36 = add nsw i64 %t35, 1
  store i64 %t36, ptr %for.i.2, align 8
  br label %for.cond.3

for.end.6:
  %t37 = load i64, ptr %var.total.0, align 8
  ret i64 %t37
}

define internal i64 @archx_sieve_count(i64 %param.limit) nounwind {
entry:
  %arr.fill.3 = alloca i64, align 8
  %var.p.23 = alloca i64, align 8
  %var.j.38 = alloca i64, align 8
  %var.count.69 = alloca i64, align 8
  %for.i.70 = alloca i64, align 8
  %t0 = icmp ugt i64 %param.limit, 140737488355328
  br i1 %t0, label %arr.neg.0, label %arr.ok.1

arr.neg.0:
  call void @archx_neg_len_fail(i64 %param.limit)
  unreachable

arr.ok.1:
  %t1 = mul nuw nsw i64 %param.limit, 1
  %t2 = call noalias align 16 ptr @malloc(i64 %t1)
  store i64 0, ptr %arr.fill.3, align 8
  br label %arr.fill.cond.2

arr.fill.cond.2:
  %t4 = load i64, ptr %arr.fill.3, align 8
  %t5 = icmp slt i64 %t4, %param.limit
  br i1 %t5, label %arr.fill.body.3, label %arr.fill.end.4

arr.fill.body.3:
  %t6 = getelementptr inbounds i8, ptr %t2, i64 %t4
  %t7 = zext i1 true to i8
  store i8 %t7, ptr %t6, align 1
  %t8 = add nsw i64 %t4, 1
  store i64 %t8, ptr %arr.fill.3, align 8
  br label %arr.fill.cond.2

arr.fill.end.4:
  %t9 = insertvalue %ArchxVec undef, i64 %param.limit, 0
  %t10 = insertvalue %ArchxVec %t9, i64 %param.limit, 1
  %t11 = insertvalue %ArchxVec %t10, ptr %t2, 2
  %t12 = extractvalue %ArchxVec %t11, 2
  %t13 = extractvalue %ArchxVec %t11, 0
  %t14 = icmp ult i64 0, %t13
  br i1 %t14, label %idx.ok.5, label %idx.oob.6

idx.oob.6:
  call void @archx_bounds_fail(i64 0, i64 %t13)
  unreachable

idx.ok.5:
  %t15 = extractvalue %ArchxVec %t11, 2
  %t16 = getelementptr inbounds i8, ptr %t15, i64 0
  %t17 = zext i1 false to i8
  store i8 %t17, ptr %t16, align 1
  %t18 = extractvalue %ArchxVec %t11, 0
  %t19 = icmp ult i64 1, %t18
  br i1 %t19, label %idx.ok.7, label %idx.oob.8

idx.oob.8:
  call void @archx_bounds_fail(i64 1, i64 %t18)
  unreachable

idx.ok.7:
  %t20 = extractvalue %ArchxVec %t11, 2
  %t21 = getelementptr inbounds i8, ptr %t20, i64 1
  %t22 = zext i1 false to i8
  store i8 %t22, ptr %t21, align 1
  store i64 2, ptr %var.p.23, align 8
  br label %while.cond.9

while.cond.9:
  %t24 = load i64, ptr %var.p.23, align 8
  %t25 = load i64, ptr %var.p.23, align 8
  %t26 = mul i64 %t24, %t25
  %t27 = icmp slt i64 %t26, %param.limit
  br i1 %t27, label %while.body.10, label %while.end.11

while.body.10:
  %t28 = load i64, ptr %var.p.23, align 8
  %t29 = extractvalue %ArchxVec %t11, 0
  %t30 = icmp ult i64 %t28, %t29
  br i1 %t30, label %idx.ok.12, label %idx.oob.13

idx.oob.13:
  call void @archx_bounds_fail(i64 %t28, i64 %t29)
  unreachable

idx.ok.12:
  %t31 = extractvalue %ArchxVec %t11, 2
  %t32 = getelementptr inbounds i8, ptr %t31, i64 %t28
  %t33 = load i8, ptr %t32, align 1
  %t34 = icmp ne i8 %t33, 0
  br i1 %t34, label %if.then.14, label %if.else.15

if.then.14:
  %t35 = load i64, ptr %var.p.23, align 8
  %t36 = load i64, ptr %var.p.23, align 8
  %t37 = mul i64 %t35, %t36
  store i64 %t37, ptr %var.j.38, align 8
  %t39 = load i64, ptr %var.j.38, align 8
  %t40 = icmp sge i64 %t39, 0
  %t41 = icmp ule i64 %param.limit, 140737488355328
  %t42 = and i1 %t40, %t41
  %t43 = load i64, ptr %var.p.23, align 8
  %t44 = sub i64 %t43, 1
  %t45 = icmp ult i64 %t44, 140737488355328
  %t46 = and i1 %t42, %t45
  br i1 %t46, label %while.fast.cond.17, label %while.cond.19

while.fast.cond.17:
  %t47 = load i64, ptr %var.j.38, align 8
  %t48 = icmp slt i64 %t47, %param.limit
  br i1 %t48, label %while.fast.body.18, label %while.end.21

while.fast.body.18:
  %t49 = load i64, ptr %var.j.38, align 8
  %t50 = extractvalue %ArchxVec %t11, 2
  %t51 = getelementptr inbounds i8, ptr %t50, i64 %t49
  %t52 = zext i1 false to i8
  store i8 %t52, ptr %t51, align 1
  %t53 = load i64, ptr %var.j.38, align 8
  %t54 = load i64, ptr %var.p.23, align 8
  %t55 = add i64 %t53, %t54
  store i64 %t55, ptr %var.j.38, align 8
  br label %while.fast.cond.17

while.cond.19:
  %t56 = load i64, ptr %var.j.38, align 8
  %t57 = icmp slt i64 %t56, %param.limit
  br i1 %t57, label %while.body.20, label %while.end.21

while.body.20:
  %t58 = load i64, ptr %var.j.38, align 8
  %t59 = extractvalue %ArchxVec %t11, 0
  %t60 = icmp ult i64 %t58, %t59
  br i1 %t60, label %idx.ok.22, label %idx.oob.23

idx.oob.23:
  call void @archx_bounds_fail(i64 %t58, i64 %t59)
  unreachable

idx.ok.22:
  %t61 = extractvalue %ArchxVec %t11, 2
  %t62 = getelementptr inbounds i8, ptr %t61, i64 %t58
  %t63 = zext i1 false to i8
  store i8 %t63, ptr %t62, align 1
  %t64 = load i64, ptr %var.j.38, align 8
  %t65 = load i64, ptr %var.p.23, align 8
  %t66 = add i64 %t64, %t65
  store i64 %t66, ptr %var.j.38, align 8
  br label %while.cond.19

while.end.21:
  br label %if.merge.16

if.else.15:
  br label %if.merge.16

if.merge.16:
  %t67 = load i64, ptr %var.p.23, align 8
  %t68 = add i64 %t67, 1
  store i64 %t68, ptr %var.p.23, align 8
  br label %while.cond.9

while.end.11:
  store i64 0, ptr %var.count.69, align 8
  store i64 2, ptr %for.i.70, align 8
  br label %for.cond.24

for.cond.24:
  %t71 = load i64, ptr %for.i.70, align 8
  %t72 = icmp slt i64 %t71, %param.limit
  br i1 %t72, label %for.body.25, label %for.end.27

for.body.25:
  %t73 = load i64, ptr %for.i.70, align 8
  %t74 = extractvalue %ArchxVec %t11, 2
  %t75 = getelementptr inbounds i8, ptr %t74, i64 %t73
  %t76 = load i8, ptr %t75, align 1
  %t77 = icmp ne i8 %t76, 0
  br i1 %t77, label %if.then.28, label %if.else.29

if.then.28:
  %t78 = load i64, ptr %var.count.69, align 8
  %t79 = add i64 %t78, 1
  store i64 %t79, ptr %var.count.69, align 8
  br label %if.merge.30

if.else.29:
  br label %if.merge.30

if.merge.30:
  br label %for.step.26

for.step.26:
  %t80 = load i64, ptr %for.i.70, align 8
  %t81 = add nsw i64 %t80, 1
  store i64 %t81, ptr %for.i.70, align 8
  br label %for.cond.24

for.end.27:
  %t82 = load i64, ptr %var.count.69, align 8
  call void @free(ptr %t12)
  ret i64 %t82
}

define internal ptr @archx_classify(i64 %param.score) nounwind {
entry:
  %t0 = icmp sge i64 %param.score, 90
  br i1 %t0, label %if.then.0, label %if.else.1

if.then.0:
  ret ptr @.str.0

if.else.1:
  %t1 = icmp sge i64 %param.score, 80
  br i1 %t1, label %if.then.3, label %if.else.4

if.then.3:
  ret ptr @.str.1

if.else.4:
  %t2 = icmp sge i64 %param.score, 70
  br i1 %t2, label %if.then.6, label %if.else.7

if.then.6:
  ret ptr @.str.2

if.else.7:
  ret ptr @.str.3

if.merge.8:
  unreachable

if.merge.5:
  unreachable

if.merge.2:
  unreachable
}

define i32 @main() nounwind {
entry:
  %print.idx.16 = alloca i64, align 8
  %var.stack.30 = alloca %ArchxVec, align 8
  %for.i.31 = alloca i64, align 8
  %print.idx.76 = alloca i64, align 8
  %t0 = call noalias align 16 ptr @malloc(i64 32)
  %t1 = getelementptr inbounds i64, ptr %t0, i64 0
  store i64 10, ptr %t1, align 8
  %t2 = getelementptr inbounds i64, ptr %t0, i64 1
  store i64 20, ptr %t2, align 8
  %t3 = getelementptr inbounds i64, ptr %t0, i64 2
  store i64 30, ptr %t3, align 8
  %t4 = getelementptr inbounds i64, ptr %t0, i64 3
  store i64 40, ptr %t4, align 8
  %t5 = insertvalue %ArchxVec undef, i64 4, 0
  %t6 = insertvalue %ArchxVec %t5, i64 4, 1
  %t7 = insertvalue %ArchxVec %t6, ptr %t0, 2
  %t8 = extractvalue %ArchxVec %t7, 2
  %t9 = extractvalue %ArchxVec %t7, 2
  %t10 = getelementptr inbounds i64, ptr %t9, i64 1
  %t11 = load i64, ptr %t10, align 8
  %t12 = add i64 %t11, 5
  store i64 %t12, ptr %t10, align 8
  %t13 = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %t14 = extractvalue %ArchxVec %t7, 0
  %t15 = extractvalue %ArchxVec %t7, 2
  store i64 0, ptr %print.idx.16, align 8
  br label %print.cond.0

print.cond.0:
  %t17 = load i64, ptr %print.idx.16, align 8
  %t18 = icmp slt i64 %t17, %t14
  br i1 %t18, label %print.body.1, label %print.end.4

print.body.1:
  %t19 = icmp sgt i64 %t17, 0
  br i1 %t19, label %print.sep.2, label %print.elem.3

print.sep.2:
  %t20 = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %print.elem.3

print.elem.3:
  %t21 = getelementptr inbounds i64, ptr %t15, i64 %t17
  %t22 = load i64, ptr %t21, align 8
  %t23 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t22)
  %t24 = add nsw i64 %t17, 1
  store i64 %t24, ptr %print.idx.16, align 8
  br label %print.cond.0

print.end.4:
  %t25 = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack)
  %t26 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 4)
  %t27 = insertvalue %ArchxVec undef, i64 0, 0
  %t28 = insertvalue %ArchxVec %t27, i64 0, 1
  %t29 = insertvalue %ArchxVec %t28, ptr null, 2
  store %ArchxVec %t29, ptr %var.stack.30, align 8
  store i64 1, ptr %for.i.31, align 8
  br label %for.cond.5

for.cond.5:
  %t32 = load i64, ptr %for.i.31, align 8
  %t33 = icmp slt i64 %t32, 5
  br i1 %t33, label %for.body.6, label %for.end.8

for.body.6:
  %t34 = load i64, ptr %for.i.31, align 8
  %t35 = mul i64 %t34, 10
  %t36 = load %ArchxVec, ptr %var.stack.30, align 8
  %t37 = extractvalue %ArchxVec %t36, 0
  %t38 = extractvalue %ArchxVec %t36, 1
  %t39 = extractvalue %ArchxVec %t36, 2
  %t40 = icmp eq i64 %t37, %t38
  br i1 %t40, label %push.grow.9, label %push.write.10

push.grow.9:
  %t41 = icmp eq i64 %t38, 0
  %t42 = mul i64 %t38, 2
  %t43 = select i1 %t41, i64 4, i64 %t42
  %t44 = mul i64 %t43, 8
  %t45 = call align 16 ptr @realloc(ptr %t39, i64 %t44)
  %t46 = insertvalue %ArchxVec undef, i64 %t37, 0
  %t47 = insertvalue %ArchxVec %t46, i64 %t43, 1
  %t48 = insertvalue %ArchxVec %t47, ptr %t45, 2
  store %ArchxVec %t48, ptr %var.stack.30, align 8
  br label %push.write.10

push.write.10:
  %t49 = load %ArchxVec, ptr %var.stack.30, align 8
  %t50 = extractvalue %ArchxVec %t49, 0
  %t51 = extractvalue %ArchxVec %t49, 1
  %t52 = extractvalue %ArchxVec %t49, 2
  %t53 = getelementptr inbounds i64, ptr %t52, i64 %t50
  store i64 %t35, ptr %t53, align 8
  %t54 = add nsw i64 %t50, 1
  %t55 = insertvalue %ArchxVec undef, i64 %t54, 0
  %t56 = insertvalue %ArchxVec %t55, i64 %t51, 1
  %t57 = insertvalue %ArchxVec %t56, ptr %t52, 2
  store %ArchxVec %t57, ptr %var.stack.30, align 8
  br label %for.step.7

for.step.7:
  %t58 = load i64, ptr %for.i.31, align 8
  %t59 = add nsw i64 %t58, 1
  store i64 %t59, ptr %for.i.31, align 8
  br label %for.cond.5

for.end.8:
  %t60 = load %ArchxVec, ptr %var.stack.30, align 8
  %t61 = extractvalue %ArchxVec %t60, 0
  %t62 = extractvalue %ArchxVec %t60, 1
  %t63 = extractvalue %ArchxVec %t60, 2
  %t64 = icmp eq i64 %t61, 0
  br i1 %t64, label %pop.empty.11, label %pop.ok.12

pop.empty.11:
  call void @archx_empty_pop_fail()
  unreachable

pop.ok.12:
  %t65 = sub nsw i64 %t61, 1
  %t66 = insertvalue %ArchxVec undef, i64 %t65, 0
  %t67 = insertvalue %ArchxVec %t66, i64 %t62, 1
  %t68 = insertvalue %ArchxVec %t67, ptr %t63, 2
  store %ArchxVec %t68, ptr %var.stack.30, align 8
  %t69 = getelementptr inbounds i64, ptr %t63, i64 %t65
  %t70 = load i64, ptr %t69, align 8
  %t71 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t70)
  %t72 = load %ArchxVec, ptr %var.stack.30, align 8
  %t73 = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %t74 = extractvalue %ArchxVec %t72, 0
  %t75 = extractvalue %ArchxVec %t72, 2
  store i64 0, ptr %print.idx.76, align 8
  br label %print.cond.13

print.cond.13:
  %t77 = load i64, ptr %print.idx.76, align 8
  %t78 = icmp slt i64 %t77, %t74
  br i1 %t78, label %print.body.14, label %print.end.17

print.body.14:
  %t79 = icmp sgt i64 %t77, 0
  br i1 %t79, label %print.sep.15, label %print.elem.16

print.sep.15:
  %t80 = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %print.elem.16

print.elem.16:
  %t81 = getelementptr inbounds i64, ptr %t75, i64 %t77
  %t82 = load i64, ptr %t81, align 8
  %t83 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t82)
  %t84 = add nsw i64 %t77, 1
  store i64 %t84, ptr %print.idx.76, align 8
  br label %print.cond.13

print.end.17:
  %t85 = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack)
  %t86 = call noalias align 16 ptr @malloc(i64 32)
  %t87 = getelementptr inbounds i64, ptr %t86, i64 0
  store i64 1, ptr %t87, align 8
  %t88 = getelementptr inbounds i64, ptr %t86, i64 1
  store i64 2, ptr %t88, align 8
  %t89 = getelementptr inbounds i64, ptr %t86, i64 2
  store i64 3, ptr %t89, align 8
  %t90 = getelementptr inbounds i64, ptr %t86, i64 3
  store i64 4, ptr %t90, align 8
  %t91 = insertvalue %ArchxVec undef, i64 4, 0
  %t92 = insertvalue %ArchxVec %t91, i64 4, 1
  %t93 = insertvalue %ArchxVec %t92, ptr %t86, 2
  %t94 = call noalias align 16 ptr @malloc(i64 32)
  %t95 = getelementptr inbounds i64, ptr %t94, i64 0
  store i64 10, ptr %t95, align 8
  %t96 = getelementptr inbounds i64, ptr %t94, i64 1
  store i64 20, ptr %t96, align 8
  %t97 = getelementptr inbounds i64, ptr %t94, i64 2
  store i64 30, ptr %t97, align 8
  %t98 = getelementptr inbounds i64, ptr %t94, i64 3
  store i64 40, ptr %t98, align 8
  %t99 = insertvalue %ArchxVec undef, i64 4, 0
  %t100 = insertvalue %ArchxVec %t99, i64 4, 1
  %t101 = insertvalue %ArchxVec %t100, ptr %t94, 2
  %t102 = call i64 @archx_dot(%ArchxVec %t93, %ArchxVec %t101)
  %t103 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t102)
  %t104 = call i64 @archx_sieve_count(i64 100)
  %t105 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t104)
  %t106 = call ptr @archx_classify(i64 85)
  %t107 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t106)
  %t108 = call i32 @strcmp(ptr %t106, ptr @.str.1)
  %t109 = icmp eq i32 %t108, 0
  %t110 = select i1 %t109, ptr @.str.true, ptr @.str.false
  %t111 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t110)
  %t112 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 5)
  call void @free(ptr %t8)
  ret i32 0
}

