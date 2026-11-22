; Archx module
declare i32 @printf(ptr, ...)

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00"

define i64 @archx_add(i64 %param.a, i64 %param.b) {
entry:
  %param.a.addr = alloca i64
  store i64 %param.a, ptr %param.a.addr
  %param.b.addr = alloca i64
  store i64 %param.b, ptr %param.b.addr
  %t0 = load i64, ptr %param.a.addr
  %t1 = load i64, ptr %param.b.addr
  %t2 = add i64 %t0, %t1
  ret i64 %t2
}

define i32 @main() {
entry:
  %t3 = call i64 @archx_add(i64 40, i64 2)
  %var.result.4 = alloca i64
  store i64 %t3, ptr %var.result.4
  %t5 = load i64, ptr %var.result.4
  %t6 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t5)
  ret i32 0
}

