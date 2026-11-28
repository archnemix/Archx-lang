; Archx LLVM IR module
; archx.dialect=native version=1 source=directive

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.fmt.str.repr = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.0 = private unnamed_addr constant [14 x i8] c"Hello, Archx!\00", align 4
@.str.1 = private unnamed_addr constant [23 x i8] c"single quotes work too\00", align 4

define i32 @main() {
entry:
  %t0 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr @.str.0)
  %t1 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr @.str.1)
  %t2 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 42)
  ret i32 0
}

declare i32 @printf(ptr nocapture readonly, ...)

!llvm.module.flags = !{!0, !1}
!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
