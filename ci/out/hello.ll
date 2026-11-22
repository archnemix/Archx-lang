; Archx module
declare i32 @printf(ptr, ...)

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.str.true = private unnamed_addr constant [5 x i8] c"true\00"
@.str.false = private unnamed_addr constant [6 x i8] c"false\00"
@.str.0 = private unnamed_addr constant [14 x i8] c"Hello, Archx!\00"
@.str.1 = private unnamed_addr constant [23 x i8] c"single quotes work too\00"

define i32 @main() nounwind {
entry:
  %t0 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr @.str.0)
  %t1 = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr @.str.1)
  %t2 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 42)
  ret i32 0
}

