; ModuleID = 'ci/out/arrays.ll'
source_filename = "ci/out/arrays.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.fmt.int.elem = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.fmt.sep = private unnamed_addr constant [3 x i8] c", \00", align 1
@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@str.1 = private unnamed_addr constant [2 x i8] c"]\00", align 1
@str.3 = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
push.grow.from_heap.18.peel:
  %tmp.i = alloca [12 x i8], align 4
  %putchar = tail call i32 @putchar(i32 91)
  %t24 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 10)
  %t21.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t24.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 25)
  %t21.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t24.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 30)
  %t21.3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t24.3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 40)
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.1)
  %t27 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 4)
  %malloc = tail call dereferenceable_or_null(32) ptr @malloc(i64 32)
  %t69.peel = icmp eq ptr %malloc, null
  br i1 %t69.peel, label %realloc.oom.26, label %for.body.8.peel.next

for.body.8.peel.next:                             ; preds = %push.grow.from_heap.18.peel
  store i64 10, ptr %malloc, align 8
  %t75 = getelementptr inbounds nuw i8, ptr %malloc, i64 8
  store i64 20, ptr %t75, align 8
  %t75.1 = getelementptr inbounds nuw i8, ptr %malloc, i64 16
  store i64 30, ptr %t75.1, align 8
  %t75.2 = getelementptr inbounds nuw i8, ptr %malloc, i64 24
  store i64 40, ptr %t75.2, align 8
  %t88 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 40)
  %putchar15 = tail call i32 @putchar(i32 91)
  %t99.pre = load i64, ptr %malloc, align 8
  %t100 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t99.pre)
  %t97.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t98.1 = getelementptr inbounds nuw i8, ptr %malloc, i64 8
  %t99.1 = load i64, ptr %t98.1, align 8
  %t100.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t99.1)
  %t97.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t98.2 = getelementptr inbounds nuw i8, ptr %malloc, i64 16
  %t99.2 = load i64, ptr %t98.2, align 8
  %t100.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t99.2)
  %puts16 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.1)
  %t122 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 300)
  %t3.i = tail call noalias align 16 dereferenceable_or_null(100) ptr @malloc(i64 100)
  %t4.i = icmp eq ptr %t3.i, null
  br i1 %t4.i, label %alloc.oom.3.i, label %if.merge.15.7.i

realloc.oom.26:                                   ; preds = %push.grow.from_heap.18.peel
  tail call fastcc void @archx_oom_fail()
  unreachable

alloc.oom.3.i:                                    ; preds = %for.body.8.peel.next
  tail call fastcc void @archx_oom_fail()
  unreachable

if.merge.15.7.i:                                  ; preds = %for.body.8.peel.next
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(100) %t3.i, i8 1, i64 100, i1 false)
  store i8 0, ptr %t3.i, align 16
  %t18.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 1
  store i8 0, ptr %t18.i, align 1
  %t48.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 4
  store i8 0, ptr %t48.i, align 4
  %t48.127.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 6
  store i8 0, ptr %t48.127.i, align 2
  %t48.229.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 8
  store i8 0, ptr %t48.229.i, align 8
  %t48.331.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 10
  store i8 0, ptr %t48.331.i, align 2
  %t48.535.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 14
  store i8 0, ptr %t48.535.i, align 2
  %t48.637.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 16
  store i8 0, ptr %t48.637.i, align 16
  %t48.8.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 20
  store i8 0, ptr %t48.8.i, align 4
  %t48.9.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 22
  store i8 0, ptr %t48.9.i, align 2
  %t48.10.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 24
  %t48.13.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 30
  %t48.14.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 32
  %t48.17.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 38
  %t48.20.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 44
  %t48.22.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 48
  %t48.25.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 54
  %t48.28.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 60
  %t48.29.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 62
  %t48.32.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 68
  %t48.35.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 74
  %t48.38.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 80
  %t48.40.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 84
  %t48.43.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 90
  %t48.47.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 98
  %t48.1.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 9
  store i8 0, ptr %t48.1.i, align 1
  %t48.1.1.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 12
  store i8 0, ptr %t48.1.1.i, align 4
  %t48.1.2.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 15
  store i8 0, ptr %t48.1.2.i, align 1
  %t48.1.3.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 18
  store i8 0, ptr %t48.1.3.i, align 2
  %t48.1.4.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 21
  store i8 0, ptr %t48.1.4.i, align 1
  %t48.1.11.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 42
  store i8 0, ptr %t48.1.11.i, align 2
  %t48.1.21.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 72
  store i8 0, ptr %t48.1.21.i, align 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(5) %t48.10.i, i8 0, i64 5, i1 false)
  store i8 0, ptr %t48.13.i, align 2
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(5) %t48.14.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(3) %t48.17.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(3) %t48.20.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(5) %t48.22.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(5) %t48.25.i, i8 0, i64 5, i1 false)
  store i8 0, ptr %t48.28.i, align 4
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(5) %t48.29.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(3) %t48.32.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(5) %t48.35.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(3) %t48.38.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(5) %t48.40.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(7) %t48.43.i, i8 0, i64 7, i1 false)
  store i16 0, ptr %t48.47.i, align 2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %if.merge.15.7.i
  %index = phi i64 [ 0, %if.merge.15.7.i ], [ %index.next.1, %vector.body ]
  %vec.phi = phi <2 x i64> [ zeroinitializer, %if.merge.15.7.i ], [ %16, %vector.body ]
  %vec.phi45 = phi <2 x i64> [ zeroinitializer, %if.merge.15.7.i ], [ %17, %vector.body ]
  %0 = getelementptr inbounds nuw i8, ptr %t3.i, i64 %index
  %1 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %wide.load = load <2 x i8>, ptr %1, align 2
  %wide.load46 = load <2 x i8>, ptr %2, align 4
  %3 = and <2 x i8> %wide.load, splat (i8 1)
  %4 = and <2 x i8> %wide.load46, splat (i8 1)
  %5 = zext nneg <2 x i8> %3 to <2 x i64>
  %6 = zext nneg <2 x i8> %4 to <2 x i64>
  %7 = add <2 x i64> %vec.phi, %5
  %8 = add <2 x i64> %vec.phi45, %6
  %9 = getelementptr inbounds nuw i8, ptr %t3.i, i64 %index
  %10 = getelementptr inbounds nuw i8, ptr %9, i64 6
  %11 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %wide.load.1 = load <2 x i8>, ptr %10, align 2
  %wide.load46.1 = load <2 x i8>, ptr %11, align 8
  %12 = and <2 x i8> %wide.load.1, splat (i8 1)
  %13 = and <2 x i8> %wide.load46.1, splat (i8 1)
  %14 = zext nneg <2 x i8> %12 to <2 x i64>
  %15 = zext nneg <2 x i8> %13 to <2 x i64>
  %16 = add <2 x i64> %7, %14
  %17 = add <2 x i64> %8, %15
  %index.next.1 = add nuw nsw i64 %index, 8
  %18 = icmp eq i64 %index.next.1, 96
  br i1 %18, label %for.body.24.i, label %vector.body, !llvm.loop !0

for.body.24.i:                                    ; preds = %vector.body
  %bin.rdx = add <2 x i64> %17, %16
  %19 = tail call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx)
  %t72.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 98
  %t73.i = load i8, ptr %t72.i, align 2
  %20 = and i8 %t73.i, 1
  %21 = zext nneg i8 %20 to i64
  %spec.select.i = add i64 %19, %21
  %t72.i.1 = getelementptr inbounds nuw i8, ptr %t3.i, i64 99
  %t73.i.1 = load i8, ptr %t72.i.1, align 1
  %22 = and i8 %t73.i.1, 1
  %23 = zext nneg i8 %22 to i64
  %spec.select.i.1 = add i64 %spec.select.i, %23
  tail call void @free(ptr nonnull %t3.i)
  %t130 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %spec.select.i.1)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  store i32 66, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 0, ptr %tmp4.i, align 4
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 1, ptr nonnull %tmp.i)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %puts17 = call i32 @puts(ptr nonnull dereferenceable(1) @.str.true)
  %t138 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 5)
  call void @free(ptr nonnull %malloc)
  ret i32 0
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_oom_fail() unnamed_addr #1 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.3)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #2

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #5

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #2

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #1

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #6

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #6

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v2i64(<2 x i64>) #7

attributes #0 = { nounwind }
attributes #1 = { cold nofree noreturn nounwind }
attributes #2 = { nofree nounwind }
attributes #3 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #4 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #5 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #6 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #7 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.isvectorized", i32 1}
!2 = !{!"llvm.loop.unroll.runtime.disable"}
