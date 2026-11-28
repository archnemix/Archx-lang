; Archx LLVM IR module
; archx.dialect=native version=1 source=directive

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.str.0 = private unnamed_addr constant [4 x i8] c"big\00", align 4
@.str.1 = private unnamed_addr constant [6 x i8] c"small\00", align 4

define internal fastcc i64 @archx_fn_sign(i64 %arg.n) {
entry:
  %t0 = icmp sgt i64 %arg.n, 0
  br i1 %t0, label %if.then.0, label %if.else.1
if.then.0:
  ret i64 1
if.else.1:
  %t1 = sub i64 0, 1
  ret i64 %t1
if.merge.2:
  unreachable
}

define i32 @main() {
entry:
  %bool.result.14 = alloca i1, align 1
  %t0 = icmp sgt i64 7, 5
  br i1 %t0, label %if.then.0, label %if.else.1
if.then.0:
  %t1 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr @.str.0)
  br label %if.merge.2
if.else.1:
  %t2 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr @.str.1)
  br label %if.merge.2
if.merge.2:
  %t3 = call fastcc i64 @archx_fn_sign(i64 5)
  %t4 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t3)
  %t5 = sub i64 0, 5
  %t6 = call fastcc i64 @archx_fn_sign(i64 %t5)
  %t7 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t6)
  %t8 = select i1 true, ptr @.str.true, ptr @.str.false
  %t9 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t8)
  %t10 = xor i1 false, true
  %t11 = select i1 %t10, ptr @.str.true, ptr @.str.false
  %t12 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t11)
  %t13 = icmp slt i64 1, 2
  store i1 false, ptr %bool.result.14, align 1
  br i1 %t13, label %bool.rhs.3, label %bool.merge.4
bool.rhs.3:
  %t15 = icmp slt i64 2, 3
  store i1 %t15, ptr %bool.result.14, align 1
  br label %bool.merge.4
bool.merge.4:
  %t16 = load i1, ptr %bool.result.14, align 1
  %t17 = select i1 %t16, ptr @.str.true, ptr @.str.false
  %t18 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr %t17)
  ret i32 0
}

declare i32 @printf(ptr nocapture readonly, ...)

!llvm.module.flags = !{!0, !1}
!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
