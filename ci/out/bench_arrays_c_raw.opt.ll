; ModuleID = 'benchmarks/arrays_raw.c'
source_filename = "benchmarks/arrays_raw.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [5 x i8] c"%ld\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = tail call noalias dereferenceable_or_null(8000000) ptr @calloc(i64 noundef 1000000, i64 noundef 8) #6
  %2 = tail call noalias dereferenceable_or_null(8000000) ptr @calloc(i64 noundef 1000000, i64 noundef 8) #6
  %3 = tail call noalias dereferenceable_or_null(8000000) ptr @calloc(i64 noundef 1000000, i64 noundef 8) #6
  br label %4

4:                                                ; preds = %4, %0
  %5 = phi i64 [ 0, %0 ], [ %17, %4 ]
  %6 = trunc nuw nsw i64 %5 to i32
  %7 = mul nuw nsw i32 %6, 7
  %8 = add nuw nsw i32 %7, 3
  %9 = urem i32 %8, 1000
  %10 = zext nneg i32 %9 to i64
  %11 = getelementptr inbounds nuw i64, ptr %1, i64 %5
  store i64 %10, ptr %11, align 8, !tbaa !5
  %12 = mul nuw nsw i32 %6, 13
  %13 = add nuw nsw i32 %12, 5
  %14 = urem i32 %13, 1000
  %15 = zext nneg i32 %14 to i64
  %16 = getelementptr inbounds nuw i64, ptr %2, i64 %5
  store i64 %15, ptr %16, align 8, !tbaa !5
  %17 = add nuw nsw i64 %5, 1
  %18 = icmp eq i64 %17, 1000000
  br i1 %18, label %19, label %4, !llvm.loop !9

19:                                               ; preds = %4, %44
  %20 = phi i64 [ %53, %44 ], [ 0, %4 ]
  %21 = phi i64 [ %52, %44 ], [ 0, %4 ]
  %22 = insertelement <2 x i64> poison, i64 %20, i64 0
  %23 = shufflevector <2 x i64> %22, <2 x i64> poison, <2 x i32> zeroinitializer
  br label %24

24:                                               ; preds = %24, %19
  %25 = phi i64 [ 0, %19 ], [ %42, %24 ]
  %26 = getelementptr inbounds nuw i64, ptr %1, i64 %25
  %27 = getelementptr inbounds nuw i8, ptr %26, i64 16
  %28 = load <2 x i64>, ptr %26, align 8, !tbaa !5
  %29 = load <2 x i64>, ptr %27, align 8, !tbaa !5
  %30 = mul nsw <2 x i64> %28, splat (i64 3)
  %31 = mul nsw <2 x i64> %29, splat (i64 3)
  %32 = getelementptr inbounds nuw i64, ptr %2, i64 %25
  %33 = getelementptr inbounds nuw i8, ptr %32, i64 16
  %34 = load <2 x i64>, ptr %32, align 8, !tbaa !5
  %35 = load <2 x i64>, ptr %33, align 8, !tbaa !5
  %36 = add <2 x i64> %34, %23
  %37 = add <2 x i64> %35, %23
  %38 = add <2 x i64> %36, %30
  %39 = add <2 x i64> %37, %31
  %40 = getelementptr inbounds nuw i64, ptr %3, i64 %25
  %41 = getelementptr inbounds nuw i8, ptr %40, i64 16
  store <2 x i64> %38, ptr %40, align 8, !tbaa !5
  store <2 x i64> %39, ptr %41, align 8, !tbaa !5
  %42 = add nuw i64 %25, 4
  %43 = icmp eq i64 %42, 1000000
  br i1 %43, label %44, label %24, !llvm.loop !11

44:                                               ; preds = %24
  %45 = getelementptr inbounds nuw i64, ptr %3, i64 %20
  %46 = load i64, ptr %45, align 8, !tbaa !5
  %47 = add nsw i64 %46, %21
  %48 = sub nuw nsw i64 999999, %20
  %49 = getelementptr inbounds nuw i64, ptr %3, i64 %48
  %50 = load i64, ptr %49, align 8, !tbaa !5
  %51 = add nsw i64 %47, %50
  %52 = srem i64 %51, 1000000007
  %53 = add nuw nsw i64 %20, 1
  %54 = icmp eq i64 %53, 60
  br i1 %54, label %55, label %19, !llvm.loop !14

55:                                               ; preds = %44
  %56 = getelementptr inbounds i8, ptr %3, i64 8
  br label %57

57:                                               ; preds = %57, %55
  %58 = phi i64 [ 0, %55 ], [ %68, %57 ]
  %59 = phi i64 [ %52, %55 ], [ %67, %57 ]
  %60 = getelementptr inbounds nuw i64, ptr %3, i64 %58
  %61 = load i64, ptr %60, align 8, !tbaa !5
  %62 = add nsw i64 %61, %59
  %63 = srem i64 %62, 1000000007
  %64 = getelementptr inbounds i64, ptr %56, i64 %58
  %65 = load i64, ptr %64, align 8, !tbaa !5
  %66 = add nsw i64 %65, %63
  %67 = srem i64 %66, 1000000007
  %68 = add nuw nsw i64 %58, 2
  %69 = icmp eq i64 %68, 1000000
  br i1 %69, label %70, label %57, !llvm.loop !15

70:                                               ; preds = %57
  tail call void @free(ptr noundef nonnull %1) #7
  tail call void @free(ptr noundef nonnull %2) #7
  tail call void @free(ptr noundef nonnull %3) #7
  %71 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef %67)
  %72 = tail call noalias dereferenceable_or_null(5000000) ptr @malloc(i64 noundef 5000000) #8
  %73 = getelementptr inbounds nuw i8, ptr %72, i64 2
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(4999998) %73, i8 1, i64 4999998, i1 false), !tbaa !16
  store i8 0, ptr %72, align 1, !tbaa !16
  %74 = getelementptr inbounds nuw i8, ptr %72, i64 1
  store i8 0, ptr %74, align 1, !tbaa !16
  br label %75

75:                                               ; preds = %103, %70
  %76 = phi i64 [ 4, %70 ], [ %105, %103 ]
  %77 = phi i64 [ 2, %70 ], [ %104, %103 ]
  %78 = getelementptr inbounds nuw i8, ptr %72, i64 %77
  %79 = load i8, ptr %78, align 1, !tbaa !16, !range !18, !noundef !19
  %80 = trunc nuw i8 %79 to i1
  %81 = icmp samesign ult i64 %76, 5000000
  %82 = select i1 %80, i1 %81, i1 false
  br i1 %82, label %83, label %88

83:                                               ; preds = %75, %83
  %84 = phi i64 [ %86, %83 ], [ %76, %75 ]
  %85 = getelementptr inbounds nuw i8, ptr %72, i64 %84
  store i8 0, ptr %85, align 1, !tbaa !16
  %86 = add nuw nsw i64 %84, %77
  %87 = icmp samesign ult i64 %86, 5000000
  br i1 %87, label %83, label %88, !llvm.loop !20

88:                                               ; preds = %83, %75
  %89 = or disjoint i64 %77, 1
  %90 = mul nuw nsw i64 %89, %89
  %91 = icmp eq i64 %77, 2236
  br i1 %91, label %106, label %92, !llvm.loop !21

92:                                               ; preds = %88
  %93 = getelementptr inbounds nuw i8, ptr %72, i64 %89
  %94 = load i8, ptr %93, align 1, !tbaa !16, !range !18, !noundef !19
  %95 = trunc nuw i8 %94 to i1
  %96 = icmp samesign ult i64 %90, 5000000
  %97 = select i1 %95, i1 %96, i1 false
  br i1 %97, label %98, label %103

98:                                               ; preds = %92, %98
  %99 = phi i64 [ %101, %98 ], [ %90, %92 ]
  %100 = getelementptr inbounds nuw i8, ptr %72, i64 %99
  store i8 0, ptr %100, align 1, !tbaa !16
  %101 = add nuw nsw i64 %99, %89
  %102 = icmp samesign ult i64 %101, 5000000
  br i1 %102, label %98, label %103, !llvm.loop !20

103:                                              ; preds = %98, %92
  %104 = add nuw nsw i64 %77, 2
  %105 = mul nuw nsw i64 %104, %104
  br label %75

106:                                              ; preds = %88
  %107 = getelementptr inbounds i8, ptr %72, i64 1
  %108 = getelementptr inbounds i8, ptr %72, i64 2
  %109 = getelementptr inbounds i8, ptr %72, i64 3
  %110 = getelementptr inbounds i8, ptr %72, i64 4
  %111 = getelementptr inbounds i8, ptr %72, i64 5
  br label %112

112:                                              ; preds = %112, %106
  %113 = phi i64 [ 2, %106 ], [ %139, %112 ]
  %114 = phi i64 [ 0, %106 ], [ %138, %112 ]
  %115 = getelementptr inbounds nuw i8, ptr %72, i64 %113
  %116 = load i8, ptr %115, align 1, !tbaa !16, !range !18, !noundef !19
  %117 = zext nneg i8 %116 to i64
  %118 = add nuw nsw i64 %114, %117
  %119 = getelementptr inbounds i8, ptr %107, i64 %113
  %120 = load i8, ptr %119, align 1, !tbaa !16, !range !18, !noundef !19
  %121 = zext nneg i8 %120 to i64
  %122 = add nuw nsw i64 %118, %121
  %123 = getelementptr inbounds i8, ptr %108, i64 %113
  %124 = load i8, ptr %123, align 1, !tbaa !16, !range !18, !noundef !19
  %125 = zext nneg i8 %124 to i64
  %126 = add nuw nsw i64 %122, %125
  %127 = getelementptr inbounds i8, ptr %109, i64 %113
  %128 = load i8, ptr %127, align 1, !tbaa !16, !range !18, !noundef !19
  %129 = zext nneg i8 %128 to i64
  %130 = add nuw nsw i64 %126, %129
  %131 = getelementptr inbounds i8, ptr %110, i64 %113
  %132 = load i8, ptr %131, align 1, !tbaa !16, !range !18, !noundef !19
  %133 = zext nneg i8 %132 to i64
  %134 = add nuw nsw i64 %130, %133
  %135 = getelementptr inbounds i8, ptr %111, i64 %113
  %136 = load i8, ptr %135, align 1, !tbaa !16, !range !18, !noundef !19
  %137 = zext nneg i8 %136 to i64
  %138 = add nuw nsw i64 %134, %137
  %139 = add nuw nsw i64 %113, 6
  %140 = icmp eq i64 %139, 5000000
  br i1 %140, label %141, label %112, !llvm.loop !22

141:                                              ; preds = %112
  tail call void @free(ptr noundef nonnull %72) #7
  %142 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef %138)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #1

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #2

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #3

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #4

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #5

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #6 = { nounwind allocsize(0,1) }
attributes #7 = { nounwind }
attributes #8 = { nounwind allocsize(0) }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"long", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
!11 = distinct !{!11, !10, !12, !13}
!12 = !{!"llvm.loop.isvectorized", i32 1}
!13 = !{!"llvm.loop.unroll.runtime.disable"}
!14 = distinct !{!14, !10}
!15 = distinct !{!15, !10}
!16 = !{!17, !17, i64 0}
!17 = !{!"_Bool", !7, i64 0}
!18 = !{i8 0, i8 2}
!19 = !{}
!20 = distinct !{!20, !10}
!21 = distinct !{!21, !10}
!22 = distinct !{!22, !10}
