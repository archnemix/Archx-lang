; Archx module
declare i32 @printf(ptr, ...)

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.str.true = private unnamed_addr constant [5 x i8] c"true\00"
@.str.false = private unnamed_addr constant [6 x i8] c"false\00"

define internal i64 @archx_sum_to(i64 %param.n) nounwind {
entry:
  %var.total.0 = alloca i64, align 8
  %for.i.2 = alloca i64, align 8
  store i64 0, ptr %var.total.0, align 8
  %t1 = add i64 %param.n, 1
  store i64 1, ptr %for.i.2, align 8
  br label %for.cond.0

for.cond.0:
  %t3 = load i64, ptr %for.i.2, align 8
  %t4 = icmp slt i64 %t3, %t1
  br i1 %t4, label %for.body.1, label %for.end.3

for.body.1:
  %t5 = load i64, ptr %var.total.0, align 8
  %t6 = load i64, ptr %for.i.2, align 8
  %t7 = add i64 %t5, %t6
  store i64 %t7, ptr %var.total.0, align 8
  br label %for.step.2

for.step.2:
  %t8 = load i64, ptr %for.i.2, align 8
  %t9 = add nsw i64 %t8, 1
  store i64 %t9, ptr %for.i.2, align 8
  br label %for.cond.0

for.end.3:
  %t10 = load i64, ptr %var.total.0, align 8
  ret i64 %t10
}

define i32 @main() nounwind {
entry:
  %var.n.2 = alloca i64, align 8
  %var.factorial.3 = alloca i64, align 8
  %for.i.13 = alloca i64, align 8
  %var.pairs.24 = alloca i64, align 8
  %for.i.25 = alloca i64, align 8
  %for.j.28 = alloca i64, align 8
  %t0 = call i64 @archx_sum_to(i64 10)
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
  br label %for.cond.3

for.cond.3:
  %t14 = load i64, ptr %for.i.13, align 8
  %t15 = icmp slt i64 %t14, 10
  br i1 %t15, label %for.body.4, label %for.end.6

for.body.4:
  %t16 = load i64, ptr %for.i.13, align 8
  %t17 = icmp eq i64 %t16, 3
  br i1 %t17, label %if.then.7, label %if.else.8

if.then.7:
  br label %for.step.5

if.else.8:
  br label %if.merge.9

if.merge.9:
  %t18 = load i64, ptr %for.i.13, align 8
  %t19 = icmp eq i64 %t18, 7
  br i1 %t19, label %if.then.10, label %if.else.11

if.then.10:
  br label %for.end.6

if.else.11:
  br label %if.merge.12

if.merge.12:
  %t20 = load i64, ptr %for.i.13, align 8
  %t21 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t20)
  br label %for.step.5

for.step.5:
  %t22 = load i64, ptr %for.i.13, align 8
  %t23 = add nsw i64 %t22, 1
  store i64 %t23, ptr %for.i.13, align 8
  br label %for.cond.3

for.end.6:
  store i64 0, ptr %var.pairs.24, align 8
  store i64 0, ptr %for.i.25, align 8
  br label %for.cond.13

for.cond.13:
  %t26 = load i64, ptr %for.i.25, align 8
  %t27 = icmp slt i64 %t26, 10
  br i1 %t27, label %for.body.14, label %for.end.16

for.body.14:
  store i64 0, ptr %for.j.28, align 8
  br label %for.cond.17

for.cond.17:
  %t29 = load i64, ptr %for.j.28, align 8
  %t30 = icmp slt i64 %t29, 10
  br i1 %t30, label %for.body.18, label %for.end.20

for.body.18:
  %t31 = load i64, ptr %for.i.25, align 8
  %t32 = load i64, ptr %for.j.28, align 8
  %t33 = add i64 %t31, %t32
  %t34 = icmp eq i64 %t33, 9
  br i1 %t34, label %if.then.21, label %if.else.22

if.then.21:
  %t35 = load i64, ptr %var.pairs.24, align 8
  %t36 = add i64 %t35, 1
  store i64 %t36, ptr %var.pairs.24, align 8
  br label %if.merge.23

if.else.22:
  br label %if.merge.23

if.merge.23:
  br label %for.step.19

for.step.19:
  %t37 = load i64, ptr %for.j.28, align 8
  %t38 = add nsw i64 %t37, 1
  store i64 %t38, ptr %for.j.28, align 8
  br label %for.cond.17

for.end.20:
  br label %for.step.15

for.step.15:
  %t39 = load i64, ptr %for.i.25, align 8
  %t40 = add nsw i64 %t39, 1
  store i64 %t40, ptr %for.i.25, align 8
  br label %for.cond.13

for.end.16:
  %t41 = load i64, ptr %var.pairs.24, align 8
  %t42 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t41)
  ret i32 0
}

