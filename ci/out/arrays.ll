; Archx module
%ArchxVec = type { i64, i64, ptr }

declare i32 @printf(ptr, ...)
declare i32 @strcmp(ptr, ptr)
declare noalias ptr @malloc(i64)
declare ptr @realloc(ptr, i64)
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
@.fmt.neglen = private unnamed_addr constant [41 x i8] c"archx panic: negative array length %lld\0A\00"
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

define i64 @archx_dot(%ArchxVec %param.a, %ArchxVec %param.b) nounwind {
entry:
  %var.total.0 = alloca i64
  %for.i.2 = alloca i64
  store i64 0, ptr %var.total.0
  %t1 = extractvalue %ArchxVec %param.a, 0
  store i64 0, ptr %for.i.2
  br label %for.cond.0

for.cond.0:
  %t3 = load i64, ptr %for.i.2
  %t4 = icmp slt i64 %t3, %t1
  br i1 %t4, label %for.body.1, label %for.end.3

for.body.1:
  %t5 = load i64, ptr %var.total.0
  %t6 = load i64, ptr %for.i.2
  %t7 = extractvalue %ArchxVec %param.a, 2
  %t8 = getelementptr inbounds i64, ptr %t7, i64 %t6
  %t9 = load i64, ptr %t8
  %t10 = load i64, ptr %for.i.2
  %t11 = extractvalue %ArchxVec %param.b, 0
  %t12 = icmp ult i64 %t10, %t11
  br i1 %t12, label %idx.ok.4, label %idx.oob.5

idx.oob.5:
  call void @archx_bounds_fail(i64 %t10, i64 %t11)
  unreachable

idx.ok.4:
  %t13 = extractvalue %ArchxVec %param.b, 2
  %t14 = getelementptr inbounds i64, ptr %t13, i64 %t10
  %t15 = load i64, ptr %t14
  %t16 = mul i64 %t9, %t15
  %t17 = add i64 %t5, %t16
  store i64 %t17, ptr %var.total.0
  br label %for.step.2

for.step.2:
  %t18 = load i64, ptr %for.i.2
  %t19 = add nsw i64 %t18, 1
  store i64 %t19, ptr %for.i.2
  br label %for.cond.0

for.end.3:
  %t20 = load i64, ptr %var.total.0
  ret i64 %t20
}

define i64 @archx_sieve_count(i64 %param.limit) nounwind {
entry:
  %arr.fill.3 = alloca i64
  %var.is_prime.12 = alloca %ArchxVec
  %var.p.25 = alloca i64
  %var.j.41 = alloca i64
  %var.count.56 = alloca i64
  %for.i.57 = alloca i64
  %t0 = icmp slt i64 %param.limit, 0
  br i1 %t0, label %arr.neg.0, label %arr.ok.1

arr.neg.0:
  call void @archx_neg_len_fail(i64 %param.limit)
  unreachable

arr.ok.1:
  %t1 = mul i64 %param.limit, 1
  %t2 = call noalias ptr @malloc(i64 %t1)
  store i64 0, ptr %arr.fill.3
  br label %arr.fill.cond.2

arr.fill.cond.2:
  %t4 = load i64, ptr %arr.fill.3
  %t5 = icmp slt i64 %t4, %param.limit
  br i1 %t5, label %arr.fill.body.3, label %arr.fill.end.4

arr.fill.body.3:
  %t6 = getelementptr inbounds i8, ptr %t2, i64 %t4
  %t7 = zext i1 true to i8
  store i8 %t7, ptr %t6
  %t8 = add nsw i64 %t4, 1
  store i64 %t8, ptr %arr.fill.3
  br label %arr.fill.cond.2

arr.fill.end.4:
  %t9 = insertvalue %ArchxVec undef, i64 %param.limit, 0
  %t10 = insertvalue %ArchxVec %t9, i64 %param.limit, 1
  %t11 = insertvalue %ArchxVec %t10, ptr %t2, 2
  store %ArchxVec %t11, ptr %var.is_prime.12
  %t13 = load %ArchxVec, ptr %var.is_prime.12
  %t14 = extractvalue %ArchxVec %t13, 0
  %t15 = icmp ult i64 0, %t14
  br i1 %t15, label %idx.ok.5, label %idx.oob.6

idx.oob.6:
  call void @archx_bounds_fail(i64 0, i64 %t14)
  unreachable

idx.ok.5:
  %t16 = extractvalue %ArchxVec %t13, 2
  %t17 = getelementptr inbounds i8, ptr %t16, i64 0
  %t18 = zext i1 false to i8
  store i8 %t18, ptr %t17
  %t19 = load %ArchxVec, ptr %var.is_prime.12
  %t20 = extractvalue %ArchxVec %t19, 0
  %t21 = icmp ult i64 1, %t20
  br i1 %t21, label %idx.ok.7, label %idx.oob.8

idx.oob.8:
  call void @archx_bounds_fail(i64 1, i64 %t20)
  unreachable

idx.ok.7:
  %t22 = extractvalue %ArchxVec %t19, 2
  %t23 = getelementptr inbounds i8, ptr %t22, i64 1
  %t24 = zext i1 false to i8
  store i8 %t24, ptr %t23
  store i64 2, ptr %var.p.25
  br label %while.cond.9

while.cond.9:
  %t26 = load i64, ptr %var.p.25
  %t27 = load i64, ptr %var.p.25
  %t28 = mul i64 %t26, %t27
  %t29 = icmp slt i64 %t28, %param.limit
  br i1 %t29, label %while.body.10, label %while.end.11

while.body.10:
  %t30 = load %ArchxVec, ptr %var.is_prime.12
  %t31 = load i64, ptr %var.p.25
  %t32 = extractvalue %ArchxVec %t30, 0
  %t33 = icmp ult i64 %t31, %t32
  br i1 %t33, label %idx.ok.12, label %idx.oob.13

idx.oob.13:
  call void @archx_bounds_fail(i64 %t31, i64 %t32)
  unreachable

idx.ok.12:
  %t34 = extractvalue %ArchxVec %t30, 2
  %t35 = getelementptr inbounds i8, ptr %t34, i64 %t31
  %t36 = load i8, ptr %t35
  %t37 = icmp ne i8 %t36, 0
  br i1 %t37, label %if.then.14, label %if.else.15

if.then.14:
  %t38 = load i64, ptr %var.p.25
  %t39 = load i64, ptr %var.p.25
  %t40 = mul i64 %t38, %t39
  store i64 %t40, ptr %var.j.41
  br label %while.cond.17

while.cond.17:
  %t42 = load i64, ptr %var.j.41
  %t43 = icmp slt i64 %t42, %param.limit
  br i1 %t43, label %while.body.18, label %while.end.19

while.body.18:
  %t44 = load %ArchxVec, ptr %var.is_prime.12
  %t45 = load i64, ptr %var.j.41
  %t46 = extractvalue %ArchxVec %t44, 0
  %t47 = icmp ult i64 %t45, %t46
  br i1 %t47, label %idx.ok.20, label %idx.oob.21

idx.oob.21:
  call void @archx_bounds_fail(i64 %t45, i64 %t46)
  unreachable

idx.ok.20:
  %t48 = extractvalue %ArchxVec %t44, 2
  %t49 = getelementptr inbounds i8, ptr %t48, i64 %t45
  %t50 = zext i1 false to i8
  store i8 %t50, ptr %t49
  %t51 = load i64, ptr %var.j.41
  %t52 = load i64, ptr %var.p.25
  %t53 = add i64 %t51, %t52
  store i64 %t53, ptr %var.j.41
  br label %while.cond.17

while.end.19:
  br label %if.merge.16

if.else.15:
  br label %if.merge.16

if.merge.16:
  %t54 = load i64, ptr %var.p.25
  %t55 = add i64 %t54, 1
  store i64 %t55, ptr %var.p.25
  br label %while.cond.9

while.end.11:
  store i64 0, ptr %var.count.56
  store i64 2, ptr %for.i.57
  br label %for.cond.22

for.cond.22:
  %t58 = load i64, ptr %for.i.57
  %t59 = icmp slt i64 %t58, %param.limit
  br i1 %t59, label %for.body.23, label %for.end.25

for.body.23:
  %t60 = load %ArchxVec, ptr %var.is_prime.12
  %t61 = load i64, ptr %for.i.57
  %t62 = extractvalue %ArchxVec %t60, 2
  %t63 = getelementptr inbounds i8, ptr %t62, i64 %t61
  %t64 = load i8, ptr %t63
  %t65 = icmp ne i8 %t64, 0
  br i1 %t65, label %if.then.26, label %if.else.27

if.then.26:
  %t66 = load i64, ptr %var.count.56
  %t67 = add i64 %t66, 1
  store i64 %t67, ptr %var.count.56
  br label %if.merge.28

if.else.27:
  br label %if.merge.28

if.merge.28:
  br label %for.step.24

for.step.24:
  %t68 = load i64, ptr %for.i.57
  %t69 = add nsw i64 %t68, 1
  store i64 %t69, ptr %for.i.57
  br label %for.cond.22

for.end.25:
  %t70 = load i64, ptr %var.count.56
  %t71 = load %ArchxVec, ptr %var.is_prime.12
  %t72 = extractvalue %ArchxVec %t71, 2
  call void @free(ptr %t72)
  ret i64 %t70
}

define ptr @archx_classify(i64 %param.score) nounwind {
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
  %var.nums.8 = alloca %ArchxVec
  %print.idx.18 = alloca i64
  %var.stack.32 = alloca %ArchxVec
  %for.i.33 = alloca i64
  %print.idx.78 = alloca i64
  %t0 = call noalias ptr @malloc(i64 32)
  %t1 = getelementptr inbounds i64, ptr %t0, i64 0
  store i64 10, ptr %t1
  %t2 = getelementptr inbounds i64, ptr %t0, i64 1
  store i64 20, ptr %t2
  %t3 = getelementptr inbounds i64, ptr %t0, i64 2
  store i64 30, ptr %t3
  %t4 = getelementptr inbounds i64, ptr %t0, i64 3
  store i64 40, ptr %t4
  %t5 = insertvalue %ArchxVec undef, i64 4, 0
  %t6 = insertvalue %ArchxVec %t5, i64 4, 1
  %t7 = insertvalue %ArchxVec %t6, ptr %t0, 2
  store %ArchxVec %t7, ptr %var.nums.8
  %t9 = load %ArchxVec, ptr %var.nums.8
  %t10 = extractvalue %ArchxVec %t9, 2
  %t11 = getelementptr inbounds i64, ptr %t10, i64 1
  %t12 = load i64, ptr %t11
  %t13 = add i64 %t12, 5
  store i64 %t13, ptr %t11
  %t14 = load %ArchxVec, ptr %var.nums.8
  %t15 = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %t16 = extractvalue %ArchxVec %t14, 0
  %t17 = extractvalue %ArchxVec %t14, 2
  store i64 0, ptr %print.idx.18
  br label %print.cond.0

print.cond.0:
  %t19 = load i64, ptr %print.idx.18
  %t20 = icmp slt i64 %t19, %t16
  br i1 %t20, label %print.body.1, label %print.end.4

print.body.1:
  %t21 = icmp sgt i64 %t19, 0
  br i1 %t21, label %print.sep.2, label %print.elem.3

print.sep.2:
  %t22 = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %print.elem.3

print.elem.3:
  %t23 = getelementptr inbounds i64, ptr %t17, i64 %t19
  %t24 = load i64, ptr %t23
  %t25 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t24)
  %t26 = add nsw i64 %t19, 1
  store i64 %t26, ptr %print.idx.18
  br label %print.cond.0

print.end.4:
  %t27 = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack)
  %t28 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 4)
  %t29 = insertvalue %ArchxVec undef, i64 0, 0
  %t30 = insertvalue %ArchxVec %t29, i64 0, 1
  %t31 = insertvalue %ArchxVec %t30, ptr null, 2
  store %ArchxVec %t31, ptr %var.stack.32
  store i64 1, ptr %for.i.33
  br label %for.cond.5

for.cond.5:
  %t34 = load i64, ptr %for.i.33
  %t35 = icmp slt i64 %t34, 5
  br i1 %t35, label %for.body.6, label %for.end.8

for.body.6:
  %t36 = load i64, ptr %for.i.33
  %t37 = mul i64 %t36, 10
  %t38 = load %ArchxVec, ptr %var.stack.32
  %t39 = extractvalue %ArchxVec %t38, 0
  %t40 = extractvalue %ArchxVec %t38, 1
  %t41 = extractvalue %ArchxVec %t38, 2
  %t42 = icmp eq i64 %t39, %t40
  br i1 %t42, label %push.grow.9, label %push.write.10

push.grow.9:
  %t43 = icmp eq i64 %t40, 0
  %t44 = mul i64 %t40, 2
  %t45 = select i1 %t43, i64 4, i64 %t44
  %t46 = mul i64 %t45, 8
  %t47 = call ptr @realloc(ptr %t41, i64 %t46)
  %t48 = insertvalue %ArchxVec undef, i64 %t39, 0
  %t49 = insertvalue %ArchxVec %t48, i64 %t45, 1
  %t50 = insertvalue %ArchxVec %t49, ptr %t47, 2
  store %ArchxVec %t50, ptr %var.stack.32
  br label %push.write.10

push.write.10:
  %t51 = load %ArchxVec, ptr %var.stack.32
  %t52 = extractvalue %ArchxVec %t51, 0
  %t53 = extractvalue %ArchxVec %t51, 1
  %t54 = extractvalue %ArchxVec %t51, 2
  %t55 = getelementptr inbounds i64, ptr %t54, i64 %t52
  store i64 %t37, ptr %t55
  %t56 = add nsw i64 %t52, 1
  %t57 = insertvalue %ArchxVec undef, i64 %t56, 0
  %t58 = insertvalue %ArchxVec %t57, i64 %t53, 1
  %t59 = insertvalue %ArchxVec %t58, ptr %t54, 2
  store %ArchxVec %t59, ptr %var.stack.32
  br label %for.step.7

for.step.7:
  %t60 = load i64, ptr %for.i.33
  %t61 = add nsw i64 %t60, 1
  store i64 %t61, ptr %for.i.33
  br label %for.cond.5

for.end.8:
  %t62 = load %ArchxVec, ptr %var.stack.32
  %t63 = extractvalue %ArchxVec %t62, 0
  %t64 = extractvalue %ArchxVec %t62, 1
  %t65 = extractvalue %ArchxVec %t62, 2
  %t66 = icmp eq i64 %t63, 0
  br i1 %t66, label %pop.empty.11, label %pop.ok.12

pop.empty.11:
  call void @archx_empty_pop_fail()
  unreachable

pop.ok.12:
  %t67 = sub nsw i64 %t63, 1
  %t68 = insertvalue %ArchxVec undef, i64 %t67, 0
  %t69 = insertvalue %ArchxVec %t68, i64 %t64, 1
  %t70 = insertvalue %ArchxVec %t69, ptr %t65, 2
  store %ArchxVec %t70, ptr %var.stack.32
  %t71 = getelementptr inbounds i64, ptr %t65, i64 %t67
  %t72 = load i64, ptr %t71
  %t73 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t72)
  %t74 = load %ArchxVec, ptr %var.stack.32
  %t75 = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %t76 = extractvalue %ArchxVec %t74, 0
  %t77 = extractvalue %ArchxVec %t74, 2
  store i64 0, ptr %print.idx.78
  br label %print.cond.13

print.cond.13:
  %t79 = load i64, ptr %print.idx.78
  %t80 = icmp slt i64 %t79, %t76
  br i1 %t80, label %print.body.14, label %print.end.17

print.body.14:
  %t81 = icmp sgt i64 %t79, 0
  br i1 %t81, label %print.sep.15, label %print.elem.16

print.sep.15:
  %t82 = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %print.elem.16

print.elem.16:
  %t83 = getelementptr inbounds i64, ptr %t77, i64 %t79
  %t84 = load i64, ptr %t83
  %t85 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t84)
  %t86 = add nsw i64 %t79, 1
  store i64 %t86, ptr %print.idx.78
  br label %print.cond.13

print.end.17:
  %t87 = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack)
  %t88 = call noalias ptr @malloc(i64 32)
  %t89 = getelementptr inbounds i64, ptr %t88, i64 0
  store i64 1, ptr %t89
  %t90 = getelementptr inbounds i64, ptr %t88, i64 1
  store i64 2, ptr %t90
  %t91 = getelementptr inbounds i64, ptr %t88, i64 2
  store i64 3, ptr %t91
  %t92 = getelementptr inbounds i64, ptr %t88, i64 3
  store i64 4, ptr %t92
  %t93 = insertvalue %ArchxVec undef, i64 4, 0
  %t94 = insertvalue %ArchxVec %t93, i64 4, 1
  %t95 = insertvalue %ArchxVec %t94, ptr %t88, 2
  %t96 = call noalias ptr @malloc(i64 32)
  %t97 = getelementptr inbounds i64, ptr %t96, i64 0
  store i64 10, ptr %t97
  %t98 = getelementptr inbounds i64, ptr %t96, i64 1
  store i64 20, ptr %t98
  %t99 = getelementptr inbounds i64, ptr %t96, i64 2
  store i64 30, ptr %t99
  %t100 = getelementptr inbounds i64, ptr %t96, i64 3
  store i64 40, ptr %t100
  %t101 = insertvalue %ArchxVec undef, i64 4, 0
  %t102 = insertvalue %ArchxVec %t101, i64 4, 1
  %t103 = insertvalue %ArchxVec %t102, ptr %t96, 2
  %t104 = call i64 @archx_dot(%ArchxVec %t95, %ArchxVec %t103)
  %t105 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t104)
  %t106 = call i64 @archx_sieve_count(i64 100)
  %t107 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t106)
  %t108 = call ptr @archx_classify(i64 85)
  %t109 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t108)
  %t110 = call i32 @strcmp(ptr %t108, ptr @.str.1)
  %t111 = icmp eq i32 %t110, 0
  %t112 = select i1 %t111, ptr @.str.true, ptr @.str.false
  %t113 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t112)
  %t114 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 5)
  %t115 = load %ArchxVec, ptr %var.stack.32
  %t116 = extractvalue %ArchxVec %t115, 2
  call void @free(ptr %t116)
  %t117 = load %ArchxVec, ptr %var.nums.8
  %t118 = extractvalue %ArchxVec %t117, 2
  call void @free(ptr %t118)
  ret i32 0
}

