; ModuleID = 'ci/out/arrays.ll'
source_filename = "ci/out/arrays.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.str.true = private unnamed_addr constant [5 x i8] c"true\00"
@.fmt.sep = private unnamed_addr constant [3 x i8] c", \00"
@.fmt.int.elem = private unnamed_addr constant [5 x i8] c"%lld\00"
@.str.1 = private unnamed_addr constant [2 x i8] c"B\00"
@str.2 = private unnamed_addr constant [2 x i8] c"]\00", align 1

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #0

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef align 16 ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #2

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #3 {
print.end.17:
  %putchar = tail call i32 @putchar(i32 91)
  %t23 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 10)
  %t20.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t23.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 25)
  %t20.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t23.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 30)
  %t20.3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t23.3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 40)
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.2)
  %t26 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 4)
  %malloc = tail call dereferenceable_or_null(32) ptr @malloc(i64 32)
  store i64 10, ptr %malloc, align 16
  %t53.1 = getelementptr inbounds nuw i8, ptr %malloc, i64 8
  store i64 20, ptr %t53.1, align 8
  %t53.2 = getelementptr inbounds nuw i8, ptr %malloc, i64 16
  store i64 30, ptr %t53.2, align 16
  %t71 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 40)
  %putchar9 = tail call i32 @putchar(i32 91)
  %t82.pre = load i64, ptr %malloc, align 16
  %t83 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t82.pre)
  %t80.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t82.1 = load i64, ptr %t53.1, align 8
  %t83.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t82.1)
  %t80.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t82.2 = load i64, ptr %t53.2, align 16
  %t83.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t82.2)
  %puts10 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.2)
  %t103 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 300)
  %t2.i = tail call noalias align 16 dereferenceable_or_null(100) ptr @malloc(i64 100)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(100) %t2.i, i8 1, i64 100, i1 false)
  store i8 0, ptr %t2.i, align 16
  %t21.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 1
  store i8 0, ptr %t21.i, align 1
  %t51.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 4
  store i8 0, ptr %t51.i, align 4
  %t51.128.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 6
  store i8 0, ptr %t51.128.i, align 2
  %t51.230.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 8
  store i8 0, ptr %t51.230.i, align 8
  %t51.332.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 10
  store i8 0, ptr %t51.332.i, align 2
  %t51.536.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 14
  store i8 0, ptr %t51.536.i, align 2
  %t51.638.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 16
  store i8 0, ptr %t51.638.i, align 16
  %t51.8.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 20
  store i8 0, ptr %t51.8.i, align 4
  %t51.9.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 22
  store i8 0, ptr %t51.9.i, align 2
  %t51.10.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 24
  %t51.13.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 30
  %t51.14.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 32
  %t51.17.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 38
  %t51.20.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 44
  %t51.22.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 48
  %t51.25.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 54
  %t51.28.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 60
  %t51.29.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 62
  %t51.32.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 68
  %t51.35.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 74
  %t51.38.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 80
  %t51.40.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 84
  %t51.43.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 90
  %t51.47.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 98
  %t51.1.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 9
  store i8 0, ptr %t51.1.i, align 1
  %t51.1.1.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 12
  store i8 0, ptr %t51.1.1.i, align 4
  %t51.1.2.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 15
  store i8 0, ptr %t51.1.2.i, align 1
  %t51.1.3.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 18
  store i8 0, ptr %t51.1.3.i, align 2
  %t51.1.4.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 21
  store i8 0, ptr %t51.1.4.i, align 1
  %t51.1.11.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 42
  store i8 0, ptr %t51.1.11.i, align 2
  %t51.1.21.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 72
  store i8 0, ptr %t51.1.21.i, align 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(5) %t51.10.i, i8 0, i64 5, i1 false)
  store i8 0, ptr %t51.13.i, align 2
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(5) %t51.14.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(3) %t51.17.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(3) %t51.20.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(5) %t51.22.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(5) %t51.25.i, i8 0, i64 5, i1 false)
  store i8 0, ptr %t51.28.i, align 4
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(5) %t51.29.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(3) %t51.32.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(5) %t51.35.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(3) %t51.38.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(5) %t51.40.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(7) %t51.43.i, i8 0, i64 7, i1 false)
  store i16 0, ptr %t51.47.i, align 2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %print.end.17
  %index = phi i64 [ 0, %print.end.17 ], [ %index.next.1, %vector.body ]
  %vec.phi = phi <2 x i64> [ zeroinitializer, %print.end.17 ], [ %16, %vector.body ]
  %vec.phi21 = phi <2 x i64> [ zeroinitializer, %print.end.17 ], [ %17, %vector.body ]
  %0 = getelementptr inbounds nuw i8, ptr %t2.i, i64 %index
  %1 = getelementptr inbounds nuw i8, ptr %0, i64 2
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %wide.load = load <2 x i8>, ptr %1, align 2
  %wide.load22 = load <2 x i8>, ptr %2, align 4
  %3 = icmp ne <2 x i8> %wide.load, zeroinitializer
  %4 = icmp ne <2 x i8> %wide.load22, zeroinitializer
  %5 = zext <2 x i1> %3 to <2 x i64>
  %6 = zext <2 x i1> %4 to <2 x i64>
  %7 = add <2 x i64> %vec.phi, %5
  %8 = add <2 x i64> %vec.phi21, %6
  %9 = getelementptr inbounds nuw i8, ptr %t2.i, i64 %index
  %10 = getelementptr inbounds nuw i8, ptr %9, i64 6
  %11 = getelementptr inbounds nuw i8, ptr %9, i64 8
  %wide.load.1 = load <2 x i8>, ptr %10, align 2
  %wide.load22.1 = load <2 x i8>, ptr %11, align 8
  %12 = icmp ne <2 x i8> %wide.load.1, zeroinitializer
  %13 = icmp ne <2 x i8> %wide.load22.1, zeroinitializer
  %14 = zext <2 x i1> %12 to <2 x i64>
  %15 = zext <2 x i1> %13 to <2 x i64>
  %16 = add <2 x i64> %7, %14
  %17 = add <2 x i64> %8, %15
  %index.next.1 = add nuw nsw i64 %index, 8
  %18 = icmp eq i64 %index.next.1, 96
  br i1 %18, label %for.body.25.i, label %vector.body, !llvm.loop !0

for.body.25.i:                                    ; preds = %vector.body
  %bin.rdx = add <2 x i64> %17, %16
  %19 = tail call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx)
  %t75.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 98
  %t76.i = load i8, ptr %t75.i, align 2
  %t77.not.i = icmp ne i8 %t76.i, 0
  %t79.i = zext i1 %t77.not.i to i64
  %spec.select.i = add i64 %19, %t79.i
  %t75.i.1 = getelementptr inbounds nuw i8, ptr %t2.i, i64 99
  %t76.i.1 = load i8, ptr %t75.i.1, align 1
  %t77.not.i.1 = icmp ne i8 %t76.i.1, 0
  %t79.i.1 = zext i1 %t77.not.i.1 to i64
  %spec.select.i.1 = add i64 %spec.select.i, %t79.i.1
  tail call void @free(ptr nonnull %t2.i)
  %t105 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %spec.select.i.1)
  %puts11 = tail call i32 @puts(ptr nonnull dereferenceable(1) @.str.1)
  %puts12 = tail call i32 @puts(ptr nonnull dereferenceable(1) @.str.true)
  %t112 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 5)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #0

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #0

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v2i64(<2 x i64>) #5

attributes #0 = { nofree nounwind }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #3 = { nounwind }
attributes #4 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.isvectorized", i32 1}
!2 = !{!"llvm.loop.unroll.runtime.disable"}
