; ModuleID = 'ci/out/loops.ll'
source_filename = "ci/out/loops.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00"

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #0

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define i64 @archx_sum_to(i64 %param.n) local_unnamed_addr #1 {
entry:
  %t2 = add i64 %param.n, 1
  %t54 = icmp sgt i64 %t2, 1
  br i1 %t54, label %for.body.1.preheader, label %for.end.3

for.body.1.preheader:                             ; preds = %entry
  %0 = shl nuw i64 %param.n, 1
  %1 = add nsw i64 %param.n, -1
  %2 = zext nneg i64 %1 to i65
  %3 = add nsw i64 %param.n, -2
  %4 = zext i64 %3 to i65
  %5 = mul i65 %2, %4
  %6 = lshr i65 %5, 1
  %7 = trunc nuw i65 %6 to i64
  %8 = add i64 %0, %7
  %9 = add i64 %8, -1
  br label %for.end.3

for.end.3:                                        ; preds = %for.body.1.preheader, %entry
  %var.total.0.0.lcssa = phi i64 [ 0, %entry ], [ %9, %for.body.1.preheader ]
  ret i64 %var.total.0.0.lcssa
}

; Function Attrs: nofree nounwind
define noundef i32 @main() local_unnamed_addr #0 {
for.end.6:
  %t1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 55)
  %t12 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 120)
  %t21 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 0)
  %t21.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 1)
  %t21.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 2)
  %t21.4 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 4)
  %t21.5 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 5)
  %t21.6 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 6)
  %t42 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 10)
  ret i32 0
}

attributes #0 = { nofree nounwind }
attributes #1 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
