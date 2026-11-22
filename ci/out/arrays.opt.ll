; ModuleID = 'ci/out/arrays.ll'
source_filename = "ci/out/arrays.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxVec = type { i64, i64, ptr }

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.str.true = private unnamed_addr constant [5 x i8] c"true\00"
@.fmt.sep = private unnamed_addr constant [3 x i8] c", \00"
@.fmt.int.elem = private unnamed_addr constant [5 x i8] c"%lld\00"
@.fmt.oob = private unnamed_addr constant [55 x i8] c"archx panic: index %lld out of bounds for length %lld\0A\00"
@.fmt.neglen = private unnamed_addr constant [41 x i8] c"archx panic: negative array length %lld\0A\00"
@.str.0 = private unnamed_addr constant [2 x i8] c"A\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"B\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"C\00"
@.str.3 = private unnamed_addr constant [2 x i8] c"F\00"
@str.2 = private unnamed_addr constant [2 x i8] c"]\00", align 1

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #0

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #2

; Function Attrs: nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #3

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_bounds_fail(i64 %idx, i64 %len) unnamed_addr #4 {
entry:
  %0 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.oob, i64 %idx, i64 %len)
  tail call void @exit(i32 101) #9
  unreachable
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_neg_len_fail(i64 range(i64 -9223372036854775808, 0) %len) unnamed_addr #4 {
entry:
  %0 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.neglen, i64 %len)
  tail call void @exit(i32 101) #9
  unreachable
}

; Function Attrs: nofree nounwind
define i64 @archx_dot(%ArchxVec %param.a, %ArchxVec %param.b) local_unnamed_addr #0 {
entry:
  %t1 = extractvalue %ArchxVec %param.a, 0
  %t47 = icmp sgt i64 %t1, 0
  br i1 %t47, label %for.body.1.lr.ph, label %for.end.3

for.body.1.lr.ph:                                 ; preds = %entry
  %t11 = extractvalue %ArchxVec %param.b, 0
  %t7 = extractvalue %ArchxVec %param.a, 2
  %t13 = extractvalue %ArchxVec %param.b, 2
  %0 = add nsw i64 %t1, -1
  %.not.not = icmp ugt i64 %t11, %0
  br i1 %.not.not, label %for.body.1.preheader, label %idx.oob.5

for.body.1.preheader:                             ; preds = %for.body.1.lr.ph
  %min.iters.check = icmp ult i64 %t1, 4
  br i1 %min.iters.check, label %for.body.1.preheader15, label %vector.ph

vector.ph:                                        ; preds = %for.body.1.preheader
  %n.vec = and i64 %t1, 9223372036854775804
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %7, %vector.body ]
  %vec.phi11 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %8, %vector.body ]
  %1 = getelementptr inbounds nuw i64, ptr %t7, i64 %index
  %2 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %wide.load = load <2 x i64>, ptr %1, align 4
  %wide.load12 = load <2 x i64>, ptr %2, align 4
  %3 = getelementptr inbounds nuw i64, ptr %t13, i64 %index
  %4 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %wide.load13 = load <2 x i64>, ptr %3, align 4
  %wide.load14 = load <2 x i64>, ptr %4, align 4
  %5 = mul <2 x i64> %wide.load13, %wide.load
  %6 = mul <2 x i64> %wide.load14, %wide.load12
  %7 = add <2 x i64> %5, %vec.phi
  %8 = add <2 x i64> %6, %vec.phi11
  %index.next = add nuw i64 %index, 4
  %9 = icmp eq i64 %index.next, %n.vec
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !0

middle.block:                                     ; preds = %vector.body
  %bin.rdx = add <2 x i64> %8, %7
  %10 = tail call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx)
  %cmp.n = icmp eq i64 %t1, %n.vec
  br i1 %cmp.n, label %for.end.3, label %for.body.1.preheader15

for.body.1.preheader15:                           ; preds = %for.body.1.preheader, %middle.block
  %for.i.2.09.ph = phi i64 [ 0, %for.body.1.preheader ], [ %n.vec, %middle.block ]
  %var.total.0.08.ph = phi i64 [ 0, %for.body.1.preheader ], [ %10, %middle.block ]
  br label %for.body.1

for.body.1:                                       ; preds = %for.body.1.preheader15, %for.body.1
  %for.i.2.09 = phi i64 [ %t19, %for.body.1 ], [ %for.i.2.09.ph, %for.body.1.preheader15 ]
  %var.total.0.08 = phi i64 [ %t17, %for.body.1 ], [ %var.total.0.08.ph, %for.body.1.preheader15 ]
  %t8 = getelementptr inbounds nuw i64, ptr %t7, i64 %for.i.2.09
  %t9 = load i64, ptr %t8, align 4
  %t14 = getelementptr inbounds nuw i64, ptr %t13, i64 %for.i.2.09
  %t15 = load i64, ptr %t14, align 4
  %t16 = mul i64 %t15, %t9
  %t17 = add i64 %t16, %var.total.0.08
  %t19 = add nuw nsw i64 %for.i.2.09, 1
  %exitcond.not = icmp eq i64 %t19, %t1
  br i1 %exitcond.not, label %for.end.3, label %for.body.1, !llvm.loop !3

idx.oob.5:                                        ; preds = %for.body.1.lr.ph
  tail call fastcc void @archx_bounds_fail(i64 %t11, i64 %t11)
  unreachable

for.end.3:                                        ; preds = %for.body.1, %middle.block, %entry
  %var.total.0.0.lcssa = phi i64 [ 0, %entry ], [ %10, %middle.block ], [ %t17, %for.body.1 ]
  ret i64 %var.total.0.0.lcssa
}

; Function Attrs: nounwind
define i64 @archx_sieve_count(i64 %param.limit) local_unnamed_addr #5 {
entry:
  %t0 = icmp slt i64 %param.limit, 0
  br i1 %t0, label %arr.neg.0, label %arr.ok.1

arr.neg.0:                                        ; preds = %entry
  tail call fastcc void @archx_neg_len_fail(i64 %param.limit)
  unreachable

arr.ok.1:                                         ; preds = %entry
  %t2 = tail call noalias ptr @malloc(i64 %param.limit)
  %t525.not = icmp eq i64 %param.limit, 0
  br i1 %t525.not, label %idx.oob.6, label %idx.ok.5

idx.oob.6:                                        ; preds = %arr.ok.1
  tail call fastcc void @archx_bounds_fail(i64 0, i64 0)
  unreachable

idx.ok.5:                                         ; preds = %arr.ok.1
  tail call void @llvm.memset.p0.i64(ptr align 1 %t2, i8 1, i64 %param.limit, i1 false)
  store i8 0, ptr %t2, align 1
  %t21.not = icmp eq i64 %param.limit, 1
  br i1 %t21.not, label %idx.oob.8, label %idx.ok.7

idx.oob.8:                                        ; preds = %idx.ok.5
  tail call fastcc void @archx_bounds_fail(i64 1, i64 1)
  unreachable

idx.ok.7:                                         ; preds = %idx.ok.5
  %t23 = getelementptr inbounds nuw i8, ptr %t2, i64 1
  store i8 0, ptr %t23, align 1
  %t2929 = icmp samesign ugt i64 %param.limit, 4
  br i1 %t2929, label %while.body.10, label %for.cond.22.preheader

for.cond.22.preheader:                            ; preds = %if.merge.16, %idx.ok.7
  %t5933 = icmp sgt i64 %param.limit, 2
  br i1 %t5933, label %for.body.23.preheader, label %for.end.25

for.body.23.preheader:                            ; preds = %for.cond.22.preheader
  %0 = add nsw i64 %param.limit, -2
  %min.iters.check = icmp ult i64 %0, 4
  br i1 %min.iters.check, label %for.body.23.preheader44, label %vector.ph

vector.ph:                                        ; preds = %for.body.23.preheader
  %n.vec = and i64 %0, -4
  %1 = or disjoint i64 %n.vec, 2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %9, %vector.body ]
  %vec.phi42 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %10, %vector.body ]
  %2 = getelementptr inbounds nuw i8, ptr %t2, i64 %index
  %3 = getelementptr inbounds nuw i8, ptr %2, i64 2
  %4 = getelementptr inbounds nuw i8, ptr %2, i64 4
  %wide.load = load <2 x i8>, ptr %3, align 1
  %wide.load43 = load <2 x i8>, ptr %4, align 1
  %5 = icmp ne <2 x i8> %wide.load, zeroinitializer
  %6 = icmp ne <2 x i8> %wide.load43, zeroinitializer
  %7 = zext <2 x i1> %5 to <2 x i64>
  %8 = zext <2 x i1> %6 to <2 x i64>
  %9 = add <2 x i64> %vec.phi, %7
  %10 = add <2 x i64> %vec.phi42, %8
  %index.next = add nuw i64 %index, 4
  %11 = icmp eq i64 %index.next, %n.vec
  br i1 %11, label %middle.block, label %vector.body, !llvm.loop !4

middle.block:                                     ; preds = %vector.body
  %bin.rdx = add <2 x i64> %10, %9
  %12 = tail call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx)
  %cmp.n = icmp eq i64 %0, %n.vec
  br i1 %cmp.n, label %for.end.25, label %for.body.23.preheader44

for.body.23.preheader44:                          ; preds = %for.body.23.preheader, %middle.block
  %for.i.57.035.ph = phi i64 [ 2, %for.body.23.preheader ], [ %1, %middle.block ]
  %var.count.56.034.ph = phi i64 [ 0, %for.body.23.preheader ], [ %12, %middle.block ]
  br label %for.body.23

while.body.10:                                    ; preds = %idx.ok.7, %if.merge.16
  %t2832 = phi i64 [ %t28, %if.merge.16 ], [ 4, %idx.ok.7 ]
  %var.p.25.030 = phi i64 [ %t55, %if.merge.16 ], [ 2, %idx.ok.7 ]
  %exitcond.not = icmp eq i64 %var.p.25.030, %param.limit
  br i1 %exitcond.not, label %idx.oob.13, label %idx.ok.12

idx.oob.13:                                       ; preds = %while.body.10
  tail call fastcc void @archx_bounds_fail(i64 %param.limit, i64 %param.limit)
  unreachable

idx.ok.12:                                        ; preds = %while.body.10
  %t35 = getelementptr inbounds nuw i8, ptr %t2, i64 %var.p.25.030
  %t36 = load i8, ptr %t35, align 1
  %t37.not = icmp ne i8 %t36, 0
  %t4327 = icmp slt i64 %t2832, %param.limit
  %or.cond = and i1 %t37.not, %t4327
  br i1 %or.cond, label %while.body.18, label %if.merge.16

while.body.18:                                    ; preds = %idx.ok.12, %idx.ok.20
  %var.j.41.028 = phi i64 [ %t53, %idx.ok.20 ], [ %t2832, %idx.ok.12 ]
  %t47 = icmp ult i64 %var.j.41.028, %param.limit
  br i1 %t47, label %idx.ok.20, label %idx.oob.21

idx.oob.21:                                       ; preds = %while.body.18
  tail call fastcc void @archx_bounds_fail(i64 %var.j.41.028, i64 %param.limit)
  unreachable

idx.ok.20:                                        ; preds = %while.body.18
  %t49 = getelementptr inbounds nuw i8, ptr %t2, i64 %var.j.41.028
  store i8 0, ptr %t49, align 1
  %t53 = add nuw i64 %var.j.41.028, %var.p.25.030
  %t43 = icmp slt i64 %t53, %param.limit
  br i1 %t43, label %while.body.18, label %if.merge.16

if.merge.16:                                      ; preds = %idx.ok.20, %idx.ok.12
  %t55 = add nuw i64 %var.p.25.030, 1
  %t28 = mul i64 %t55, %t55
  %t29 = icmp slt i64 %t28, %param.limit
  br i1 %t29, label %while.body.10, label %for.cond.22.preheader

for.body.23:                                      ; preds = %for.body.23.preheader44, %for.body.23
  %for.i.57.035 = phi i64 [ %t69, %for.body.23 ], [ %for.i.57.035.ph, %for.body.23.preheader44 ]
  %var.count.56.034 = phi i64 [ %spec.select, %for.body.23 ], [ %var.count.56.034.ph, %for.body.23.preheader44 ]
  %t63 = getelementptr inbounds nuw i8, ptr %t2, i64 %for.i.57.035
  %t64 = load i8, ptr %t63, align 1
  %t65.not = icmp ne i8 %t64, 0
  %t67 = zext i1 %t65.not to i64
  %spec.select = add i64 %var.count.56.034, %t67
  %t69 = add nuw nsw i64 %for.i.57.035, 1
  %exitcond39.not = icmp eq i64 %t69, %param.limit
  br i1 %exitcond39.not, label %for.end.25, label %for.body.23, !llvm.loop !5

for.end.25:                                       ; preds = %for.body.23, %middle.block, %for.cond.22.preheader
  %var.count.56.0.lcssa = phi i64 [ 0, %for.cond.22.preheader ], [ %12, %middle.block ], [ %spec.select, %for.body.23 ]
  tail call void @free(ptr nonnull %t2)
  ret i64 %var.count.56.0.lcssa
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define nonnull ptr @archx_classify(i64 %param.score) local_unnamed_addr #6 {
entry:
  %t0 = icmp sgt i64 %param.score, 89
  br i1 %t0, label %common.ret, label %if.else.1

common.ret:                                       ; preds = %if.else.4, %if.else.1, %entry
  %common.ret.op = phi ptr [ @.str.0, %entry ], [ @.str.1, %if.else.1 ], [ %.str.2..str.3, %if.else.4 ]
  ret ptr %common.ret.op

if.else.1:                                        ; preds = %entry
  %t1 = icmp sgt i64 %param.score, 79
  br i1 %t1, label %common.ret, label %if.else.4

if.else.4:                                        ; preds = %if.else.1
  %t2 = icmp sgt i64 %param.score, 69
  %.str.2..str.3 = select i1 %t2, ptr @.str.2, ptr @.str.3
  br label %common.ret
}

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #5 {
print.end.17:
  %putchar = tail call i32 @putchar(i32 91)
  %t25 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 10)
  %t22.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t25.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 25)
  %t22.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t25.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 30)
  %t22.3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t25.3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 40)
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.2)
  %t28 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 4)
  %malloc = tail call dereferenceable_or_null(32) ptr @malloc(i64 32)
  store i64 10, ptr %malloc, align 4
  %t55.1 = getelementptr inbounds nuw i8, ptr %malloc, i64 8
  store i64 20, ptr %t55.1, align 4
  %t55.2 = getelementptr inbounds nuw i8, ptr %malloc, i64 16
  store i64 30, ptr %t55.2, align 4
  %t55.3 = getelementptr inbounds nuw i8, ptr %malloc, i64 24
  store i64 40, ptr %t55.3, align 4
  %t73 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 40)
  %putchar15 = tail call i32 @putchar(i32 91)
  %t84.pre = load i64, ptr %malloc, align 4
  %t85 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t84.pre)
  %t82.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t84.1 = load i64, ptr %t55.1, align 4
  %t85.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t84.1)
  %t82.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t84.2 = load i64, ptr %t55.2, align 4
  %t85.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t84.2)
  %puts16 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.2)
  %t105 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 300)
  %t106 = tail call i64 @archx_sieve_count(i64 100)
  %t107 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t106)
  %puts17 = tail call i32 @puts(ptr nonnull dereferenceable(1) @.str.1)
  %puts18 = tail call i32 @puts(ptr nonnull dereferenceable(1) @.str.true)
  %t114 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 5)
  tail call void @free(ptr nonnull %malloc)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #0

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #0

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v2i64(<2 x i64>) #8

attributes #0 = { nofree nounwind }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #3 = { nofree noreturn nounwind }
attributes #4 = { cold nofree noreturn nounwind }
attributes #5 = { nounwind }
attributes #6 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
attributes #7 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #8 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #9 = { cold }

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.isvectorized", i32 1}
!2 = !{!"llvm.loop.unroll.runtime.disable"}
!3 = distinct !{!3, !2, !1}
!4 = distinct !{!4, !1, !2}
!5 = distinct !{!5, !2, !1}
