; Archx module
declare i32 @printf(ptr, ...)

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.str.true = private unnamed_addr constant [5 x i8] c"true\00"
@.str.false = private unnamed_addr constant [6 x i8] c"false\00"
@.str.0 = private unnamed_addr constant [4 x i8] c"big\00"
@.str.1 = private unnamed_addr constant [6 x i8] c"small\00"

define i64 @archx_sign(i64 %param.n) {
entry:
  %param.n.addr = alloca i64
  store i64 %param.n, ptr %param.n.addr
  %t0 = load i64, ptr %param.n.addr
  %t1 = icmp sgt i64 %t0, 0
  br i1 %t1, label %if.then.0, label %if.else.1

if.then.0:
  ret i64 1

if.else.1:
  %t2 = sub i64 0, 1
  ret i64 %t2

if.merge.2:
  unreachable
}

define i32 @main() {
entry:
  %var.x.0 = alloca i64
  %bool.result.16 = alloca i1
  store i64 7, ptr %var.x.0
  %t1 = load i64, ptr %var.x.0
  %t2 = icmp sgt i64 %t1, 5
  br i1 %t2, label %if.then.0, label %if.else.1

if.then.0:
  %t3 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr @.str.0)
  br label %if.merge.2

if.else.1:
  %t4 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr @.str.1)
  br label %if.merge.2

if.merge.2:
  %t5 = call i64 @archx_sign(i64 5)
  %t6 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t5)
  %t7 = sub i64 0, 5
  %t8 = call i64 @archx_sign(i64 %t7)
  %t9 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t8)
  %t11 = select i1 true, ptr @.str.true, ptr @.str.false
  %t10 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t11)
  %t12 = xor i1 false, true
  %t14 = select i1 %t12, ptr @.str.true, ptr @.str.false
  %t13 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t14)
  %t15 = icmp slt i64 1, 2
  store i1 false, ptr %bool.result.16
  br i1 %t15, label %bool.rhs.3, label %bool.merge.4

bool.rhs.3:
  %t17 = icmp slt i64 2, 3
  store i1 %t17, ptr %bool.result.16
  br label %bool.merge.4

bool.merge.4:
  %t18 = load i1, ptr %bool.result.16
  %t20 = select i1 %t18, ptr @.str.true, ptr @.str.false
  %t19 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t20)
  ret i32 0
}

