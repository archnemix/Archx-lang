; Archx LLVM IR module

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1

define internal fastcc i64 @archx_fn_sum_to(i64 %arg.n) {
entry:
  %var.total.0 = alloca i64, align 8
  %for.i.2 = alloca i64, align 8
  %for.last.i.3 = alloca i64, align 8
  store i64 0, ptr %var.total.0, align 8
  %t1 = add i64 %arg.n, 1
  store i64 1, ptr %for.i.2, align 8
  store i64 1, ptr %for.last.i.3, align 8
  br label %for.cond.0
for.cond.0:
  %t4 = load i64, ptr %for.i.2, align 8
  %t5 = icmp slt i64 %t4, %t1
  br i1 %t5, label %for.body.1, label %for.end.3
for.body.1:
  store i64 %t4, ptr %for.last.i.3, align 8
  %t6 = load i64, ptr %var.total.0, align 8
  %t7 = load i64, ptr %for.last.i.3, align 8
  %t8 = add i64 %t6, %t7
  store i64 %t8, ptr %var.total.0, align 8
  br label %for.step.2
for.step.2:
  %t9 = load i64, ptr %for.i.2, align 8
  %t10 = add nsw i64 %t9, 1
  store i64 %t10, ptr %for.i.2, align 8
  br label %for.cond.0
for.end.3:
  %t11 = load i64, ptr %var.total.0, align 8
  ret i64 %t11
}

define i32 @main() {
entry:
  %var.n.2 = alloca i64, align 8
  %var.factorial.3 = alloca i64, align 8
  %for.i.13 = alloca i64, align 8
  %for.last.i.14 = alloca i64, align 8
  %var.pairs.25 = alloca i64, align 8
  %for.i.26 = alloca i64, align 8
  %for.last.i.27 = alloca i64, align 8
  %for.j.30 = alloca i64, align 8
  %for.last.j.31 = alloca i64, align 8
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
  %t8 = mul i64 %t6, %t7
  store i64 %t8, ptr %var.factorial.3, align 8
  %t9 = load i64, ptr %var.n.2, align 8
  %t10 = sub i64 %t9, 1
  store i64 %t10, ptr %var.n.2, align 8
  br label %while.cond.0
while.end.2:
  %t11 = load i64, ptr %var.factorial.3, align 8
  %t12 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t11)
  store i64 0, ptr %for.i.13, align 8
  store i64 0, ptr %for.last.i.14, align 8
  br label %for.cond.3
for.cond.3:
  %t15 = load i64, ptr %for.i.13, align 8
  %t16 = icmp slt i64 %t15, 10
  br i1 %t16, label %for.body.4, label %for.end.6
for.body.4:
  store i64 %t15, ptr %for.last.i.14, align 8
  %t17 = load i64, ptr %for.last.i.14, align 8
  %t18 = icmp eq i64 %t17, 3
  br i1 %t18, label %if.then.7, label %if.else.8
if.then.7:
  br label %for.step.5
if.else.8:
  br label %if.merge.9
if.merge.9:
  %t19 = load i64, ptr %for.last.i.14, align 8
  %t20 = icmp eq i64 %t19, 7
  br i1 %t20, label %if.then.10, label %if.else.11
if.then.10:
  br label %for.end.6
if.else.11:
  br label %if.merge.12
if.merge.12:
  %t21 = load i64, ptr %for.last.i.14, align 8
  %t22 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t21)
  br label %for.step.5
for.step.5:
  %t23 = load i64, ptr %for.i.13, align 8
  %t24 = add nsw i64 %t23, 1
  store i64 %t24, ptr %for.i.13, align 8
  br label %for.cond.3
for.end.6:
  store i64 0, ptr %var.pairs.25, align 8
  store i64 0, ptr %for.i.26, align 8
  store i64 0, ptr %for.last.i.27, align 8
  br label %for.cond.13
for.cond.13:
  %t28 = load i64, ptr %for.i.26, align 8
  %t29 = icmp slt i64 %t28, 10
  br i1 %t29, label %for.body.14, label %for.end.16
for.body.14:
  store i64 %t28, ptr %for.last.i.27, align 8
  store i64 0, ptr %for.j.30, align 8
  store i64 0, ptr %for.last.j.31, align 8
  br label %for.cond.17
for.cond.17:
  %t32 = load i64, ptr %for.j.30, align 8
  %t33 = icmp slt i64 %t32, 10
  br i1 %t33, label %for.body.18, label %for.end.20
for.body.18:
  store i64 %t32, ptr %for.last.j.31, align 8
  %t34 = load i64, ptr %for.last.i.27, align 8
  %t35 = load i64, ptr %for.last.j.31, align 8
  %t36 = add i64 %t34, %t35
  %t37 = icmp eq i64 %t36, 9
  br i1 %t37, label %if.then.21, label %if.else.22
if.then.21:
  %t38 = load i64, ptr %var.pairs.25, align 8
  %t39 = add i64 %t38, 1
  store i64 %t39, ptr %var.pairs.25, align 8
  br label %if.merge.23
if.else.22:
  br label %if.merge.23
if.merge.23:
  br label %for.step.19
for.step.19:
  %t40 = load i64, ptr %for.j.30, align 8
  %t41 = add nsw i64 %t40, 1
  store i64 %t41, ptr %for.j.30, align 8
  br label %for.cond.17
for.end.20:
  br label %for.step.15
for.step.15:
  %t42 = load i64, ptr %for.i.26, align 8
  %t43 = add nsw i64 %t42, 1
  store i64 %t43, ptr %for.i.26, align 8
  br label %for.cond.13
for.end.16:
  %t44 = load i64, ptr %var.pairs.25, align 8
  %t45 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t44)
  ret i32 0
}

declare i32 @printf(ptr nocapture readonly, ...)
