; Archx module
declare i32 @printf(ptr, ...)

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.str.true = private unnamed_addr constant [5 x i8] c"true\00"
@.str.false = private unnamed_addr constant [6 x i8] c"false\00"

define i64 @archx_add(i64 %param.a, i64 %param.b) {
entry:
  %param.a.addr = alloca i64
  %param.b.addr = alloca i64
  store i64 %param.a, ptr %param.a.addr
  store i64 %param.b, ptr %param.b.addr
  %t0 = load i64, ptr %param.a.addr
  %t1 = load i64, ptr %param.b.addr
  %t2 = add i64 %t0, %t1
  ret i64 %t2
}

define i32 @main() {
entry:
  %var.result.1 = alloca i64
  %t0 = call i64 @archx_add(i64 40, i64 2)
  store i64 %t0, ptr %var.result.1
  %t2 = load i64, ptr %var.result.1
  %t3 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t2)
  ret i32 0
}

