; ModuleID = 'ci/out/hello.ll'
source_filename = "ci/out/hello.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.0 = private unnamed_addr constant [14 x i8] c"Hello, Archx!\00", align 4
@.str.1 = private unnamed_addr constant [23 x i8] c"single quotes work too\00", align 4

; Function Attrs: nofree nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @.str.0)
  %puts1 = tail call i32 @puts(ptr nonnull dereferenceable(1) @.str.1)
  %t2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 42)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #0

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #0

attributes #0 = { nofree nounwind }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
