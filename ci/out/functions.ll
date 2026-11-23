; Archx LLVM IR module

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1

define internal fastcc i64 @archx_fn_add(i64 %arg.a, i64 %arg.b) {
entry:
  %t0 = add i64 %arg.a, %arg.b
  ret i64 %t0
}

define i32 @main() {
entry:
  %t0 = call fastcc i64 @archx_fn_add(i64 40, i64 2)
  %t1 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t0)
  ret i32 0
}

declare i32 @printf(ptr nocapture readonly, ...)
