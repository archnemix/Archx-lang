; Archx LLVM IR module
; archx.dialect=native version=1 source=directive

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1

define internal fastcc i64 @archx_fn_add(i64 %arg.a, i64 %arg.b) {
entry:
  %t0 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %arg.a, i64 %arg.b)
  %t1 = extractvalue { i64, i1 } %t0, 0
  %t2 = extractvalue { i64, i1 } %t0, 1
  br i1 %t2, label %overflow.add.0, label %overflow.ok.1
overflow.add.0:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.1:
  ret i64 %t1
}

define i32 @main() {
entry:
  %t0 = call fastcc i64 @archx_fn_add(i64 40, i64 2)
  %t1 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t0)
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
