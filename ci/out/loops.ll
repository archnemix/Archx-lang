; Archx LLVM IR module
; archx.dialect=native version=1 source=directive

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.fmt.str.repr = private unnamed_addr constant [3 x i8] c"%s\00", align 1

define internal fastcc i64 @archx_fn_sum_to(i64 %arg.n) {
entry:
  %var.total.0 = alloca i64, align 8
  %for.i.4 = alloca i64, align 8
  %for.last.i.5 = alloca i64, align 8
  store i64 0, ptr %var.total.0, align 8
  %t1 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %arg.n, i64 1)
  %t2 = extractvalue { i64, i1 } %t1, 0
  %t3 = extractvalue { i64, i1 } %t1, 1
  br i1 %t3, label %overflow.add.0, label %overflow.ok.1
overflow.add.0:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.1:
  store i64 1, ptr %for.i.4, align 8
  store i64 1, ptr %for.last.i.5, align 8
  br label %for.cond.2
for.cond.2:
  %t6 = load i64, ptr %for.i.4, align 8
  %t7 = icmp slt i64 %t6, %t2
  br i1 %t7, label %for.body.3, label %for.end.5
for.body.3:
  store i64 %t6, ptr %for.last.i.5, align 8
  %t8 = load i64, ptr %var.total.0, align 8
  %t9 = load i64, ptr %for.last.i.5, align 8
  %t10 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t8, i64 %t9)
  %t11 = extractvalue { i64, i1 } %t10, 0
  %t12 = extractvalue { i64, i1 } %t10, 1
  br i1 %t12, label %overflow.add.6, label %overflow.ok.7
overflow.add.6:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.7:
  store i64 %t11, ptr %var.total.0, align 8
  br label %for.step.4
for.step.4:
  %t13 = load i64, ptr %for.i.4, align 8
  %t14 = add nsw i64 %t13, 1
  store i64 %t14, ptr %for.i.4, align 8
  br label %for.cond.2
for.end.5:
  %t15 = load i64, ptr %var.total.0, align 8
  ret i64 %t15
}

define i32 @main() {
entry:
  %var.n.2 = alloca i64, align 8
  %var.factorial.3 = alloca i64, align 8
  %for.i.17 = alloca i64, align 8
  %for.last.i.18 = alloca i64, align 8
  %var.pairs.29 = alloca i64, align 8
  %for.i.30 = alloca i64, align 8
  %for.last.i.31 = alloca i64, align 8
  %for.j.34 = alloca i64, align 8
  %for.last.j.35 = alloca i64, align 8
  %t0 = call fastcc i64 @archx_fn_sum_to(i64 10)
  %t1 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t0)
  store i64 5, ptr %var.n.2, align 8
  store i64 1, ptr %var.factorial.3, align 8
  br label %while.cond.0
while.cond.0:
  %t4 = load i64, ptr %var.n.2, align 8
  %t5 = icmp sgt i64 %t4, 1
  br i1 %t5, label %while.body.1, label %while.end.2
while.body.1:
  %t6 = load i64, ptr %var.factorial.3, align 8
  %t7 = load i64, ptr %var.n.2, align 8
  %t8 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t6, i64 %t7)
  %t9 = extractvalue { i64, i1 } %t8, 0
  %t10 = extractvalue { i64, i1 } %t8, 1
  br i1 %t10, label %overflow.mul.3, label %overflow.ok.4
overflow.mul.3:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.4:
  store i64 %t9, ptr %var.factorial.3, align 8
  %t11 = load i64, ptr %var.n.2, align 8
  %t12 = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %t11, i64 1)
  %t13 = extractvalue { i64, i1 } %t12, 0
  %t14 = extractvalue { i64, i1 } %t12, 1
  br i1 %t14, label %overflow.sub.5, label %overflow.ok.6
overflow.sub.5:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.6:
  store i64 %t13, ptr %var.n.2, align 8
  br label %while.cond.0
while.end.2:
  %t15 = load i64, ptr %var.factorial.3, align 8
  %t16 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t15)
  store i64 0, ptr %for.i.17, align 8
  store i64 0, ptr %for.last.i.18, align 8
  br label %for.cond.7
for.cond.7:
  %t19 = load i64, ptr %for.i.17, align 8
  %t20 = icmp slt i64 %t19, 10
  br i1 %t20, label %for.body.8, label %for.end.10
for.body.8:
  store i64 %t19, ptr %for.last.i.18, align 8
  %t21 = load i64, ptr %for.last.i.18, align 8
  %t22 = icmp eq i64 %t21, 3
  br i1 %t22, label %if.then.11, label %if.else.12
if.then.11:
  br label %for.step.9
if.else.12:
  br label %if.merge.13
if.merge.13:
  %t23 = load i64, ptr %for.last.i.18, align 8
  %t24 = icmp eq i64 %t23, 7
  br i1 %t24, label %if.then.14, label %if.else.15
if.then.14:
  br label %for.end.10
if.else.15:
  br label %if.merge.16
if.merge.16:
  %t25 = load i64, ptr %for.last.i.18, align 8
  %t26 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t25)
  br label %for.step.9
for.step.9:
  %t27 = load i64, ptr %for.i.17, align 8
  %t28 = add nsw i64 %t27, 1
  store i64 %t28, ptr %for.i.17, align 8
  br label %for.cond.7
for.end.10:
  store i64 0, ptr %var.pairs.29, align 8
  store i64 0, ptr %for.i.30, align 8
  store i64 0, ptr %for.last.i.31, align 8
  br label %for.cond.17
for.cond.17:
  %t32 = load i64, ptr %for.i.30, align 8
  %t33 = icmp slt i64 %t32, 10
  br i1 %t33, label %for.body.18, label %for.end.20
for.body.18:
  store i64 %t32, ptr %for.last.i.31, align 8
  store i64 0, ptr %for.j.34, align 8
  store i64 0, ptr %for.last.j.35, align 8
  br label %for.cond.21
for.cond.21:
  %t36 = load i64, ptr %for.j.34, align 8
  %t37 = icmp slt i64 %t36, 10
  br i1 %t37, label %for.body.22, label %for.end.24
for.body.22:
  store i64 %t36, ptr %for.last.j.35, align 8
  %t38 = load i64, ptr %for.last.i.31, align 8
  %t39 = load i64, ptr %for.last.j.35, align 8
  %t40 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t38, i64 %t39)
  %t41 = extractvalue { i64, i1 } %t40, 0
  %t42 = extractvalue { i64, i1 } %t40, 1
  br i1 %t42, label %overflow.add.25, label %overflow.ok.26
overflow.add.25:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.26:
  %t43 = icmp eq i64 %t41, 9
  br i1 %t43, label %if.then.27, label %if.else.28
if.then.27:
  %t44 = load i64, ptr %var.pairs.29, align 8
  %t45 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t44, i64 1)
  %t46 = extractvalue { i64, i1 } %t45, 0
  %t47 = extractvalue { i64, i1 } %t45, 1
  br i1 %t47, label %overflow.add.30, label %overflow.ok.31
overflow.add.30:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.31:
  store i64 %t46, ptr %var.pairs.29, align 8
  br label %if.merge.29
if.else.28:
  br label %if.merge.29
if.merge.29:
  br label %for.step.23
for.step.23:
  %t48 = load i64, ptr %for.j.34, align 8
  %t49 = add nsw i64 %t48, 1
  store i64 %t49, ptr %for.j.34, align 8
  br label %for.cond.21
for.end.24:
  br label %for.step.19
for.step.19:
  %t50 = load i64, ptr %for.i.30, align 8
  %t51 = add nsw i64 %t50, 1
  store i64 %t51, ptr %for.i.30, align 8
  br label %for.cond.17
for.end.20:
  %t52 = load i64, ptr %var.pairs.29, align 8
  %t53 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t52)
  ret i32 0
}

@.err.overflow = private unnamed_addr constant [39 x i8] c"archx runtime panic: integer overflow\0A\00", align 1

define private void @archx_int_overflow_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.overflow)
  call void @exit(i32 101)
  unreachable
}

declare i32 @printf(ptr nocapture readonly, ...)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) nounwind readnone speculatable
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) nounwind readnone speculatable
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) nounwind readnone speculatable
declare void @exit(i32) cold noreturn nounwind

!llvm.module.flags = !{!0, !1}
!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
