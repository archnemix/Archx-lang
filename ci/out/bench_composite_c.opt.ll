; ModuleID = 'benchmarks/composite.c'
source_filename = "benchmarks/composite.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Body = type { i64, i64, i64, i64, i64, i64 }

@.str = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"alpha0\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"beta99\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"id_\00", align 1
@.str.4 = private unnamed_addr constant [13 x i8] c"payload_v2_a\00", align 1
@.str.5 = private unnamed_addr constant [13 x i8] c"other_kind_b\00", align 1
@.str.6 = private unnamed_addr constant [15 x i8] c"packet_header_\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"id_alpha0\00", align 1
@.str.8 = private unnamed_addr constant [27 x i8] c"packet_header_payload_v2_a\00", align 1
@.str.9 = private unnamed_addr constant [27 x i8] c"packet_header_never_match!\00", align 1

; Function Attrs: nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = tail call noalias dereferenceable_or_null(4800000) ptr @malloc(i64 noundef 4800000) #8
  %2 = icmp eq ptr %1, null
  br i1 %2, label %3, label %4

3:                                                ; preds = %0
  tail call void @abort() #9
  unreachable

4:                                                ; preds = %0, %4
  %5 = phi i64 [ %25, %4 ], [ 0, %0 ]
  %6 = mul nuw nsw i64 %5, 3
  %7 = getelementptr inbounds nuw %struct.Body, ptr %1, i64 %5
  store i64 %6, ptr %7, align 8, !tbaa !5
  %8 = mul nuw nsw i64 %5, 5
  %9 = getelementptr inbounds nuw i8, ptr %7, i64 8
  store i64 %8, ptr %9, align 8, !tbaa !10
  %10 = mul nuw nsw i64 %5, 7
  %11 = getelementptr inbounds nuw i8, ptr %7, i64 16
  store i64 %10, ptr %11, align 8, !tbaa !11
  %12 = trunc nuw nsw i64 %5 to i32
  %13 = urem i32 %12, 7
  %14 = add nuw nsw i32 %13, 1
  %15 = zext nneg i32 %14 to i64
  %16 = getelementptr inbounds nuw i8, ptr %7, i64 24
  store i64 %15, ptr %16, align 8, !tbaa !12
  %17 = urem i32 %12, 5
  %18 = add nuw nsw i32 %17, 1
  %19 = zext nneg i32 %18 to i64
  %20 = getelementptr inbounds nuw i8, ptr %7, i64 32
  store i64 %19, ptr %20, align 8, !tbaa !13
  %21 = urem i32 %12, 3
  %22 = add nuw nsw i32 %21, 1
  %23 = zext nneg i32 %22 to i64
  %24 = getelementptr inbounds nuw i8, ptr %7, i64 40
  store i64 %23, ptr %24, align 8, !tbaa !14
  %25 = add nuw nsw i64 %5, 1
  %26 = icmp eq i64 %25, 100000
  br i1 %26, label %27, label %4, !llvm.loop !15

27:                                               ; preds = %4, %53
  %28 = phi i64 [ %54, %53 ], [ 0, %4 ]
  br label %29

29:                                               ; preds = %29, %27
  %30 = phi i64 [ 0, %27 ], [ %46, %29 ]
  %31 = getelementptr inbounds nuw %struct.Body, ptr %1, i64 %30
  %32 = getelementptr inbounds nuw i8, ptr %31, i64 24
  %33 = load <2 x i64>, ptr %32, align 8, !tbaa !17
  %34 = load <2 x i64>, ptr %31, align 8, !tbaa !17
  %35 = add nsw <2 x i64> %34, %33
  %36 = sub nsw <2 x i64> %34, %33
  %37 = shufflevector <2 x i64> %35, <2 x i64> %36, <2 x i32> <i32 0, i32 3>
  store <2 x i64> %37, ptr %31, align 8, !tbaa !17
  %38 = getelementptr inbounds nuw %struct.Body, ptr %1, i64 %30
  %39 = getelementptr inbounds nuw i8, ptr %38, i64 48
  %40 = getelementptr inbounds nuw i8, ptr %38, i64 72
  %41 = load <2 x i64>, ptr %40, align 8, !tbaa !17
  %42 = load <2 x i64>, ptr %39, align 8, !tbaa !17
  %43 = add nsw <2 x i64> %42, %41
  %44 = sub nsw <2 x i64> %42, %41
  %45 = shufflevector <2 x i64> %43, <2 x i64> %44, <2 x i32> <i32 0, i32 3>
  store <2 x i64> %45, ptr %39, align 8, !tbaa !17
  %46 = add nuw nsw i64 %30, 2
  %47 = icmp eq i64 %46, 100000
  br i1 %47, label %48, label %29, !llvm.loop !18

48:                                               ; preds = %29
  %49 = trunc nuw i64 %28 to i8
  %50 = urem i8 %49, 3
  %51 = zext nneg i8 %50 to i64
  %52 = add nsw i64 %51, -1
  br label %56

53:                                               ; preds = %56
  %54 = add nuw nsw i64 %28, 1
  %55 = icmp eq i64 %54, 120
  br i1 %55, label %75, label %27, !llvm.loop !19

56:                                               ; preds = %56, %48
  %57 = phi i64 [ 0, %48 ], [ %73, %56 ]
  %58 = getelementptr inbounds nuw %struct.Body, ptr %1, i64 %57
  %59 = getelementptr inbounds nuw i8, ptr %58, i64 40
  %60 = load i64, ptr %59, align 8, !tbaa !14
  %61 = add nsw i64 %52, %60
  %62 = getelementptr inbounds nuw i8, ptr %58, i64 16
  %63 = load i64, ptr %62, align 8, !tbaa !11
  %64 = add nsw i64 %61, %63
  store i64 %64, ptr %62, align 8, !tbaa !11
  %65 = or disjoint i64 %57, 8
  %66 = getelementptr inbounds nuw %struct.Body, ptr %1, i64 %65
  %67 = getelementptr inbounds nuw i8, ptr %66, i64 40
  %68 = load i64, ptr %67, align 8, !tbaa !14
  %69 = add nsw i64 %52, %68
  %70 = getelementptr inbounds nuw i8, ptr %66, i64 16
  %71 = load i64, ptr %70, align 8, !tbaa !11
  %72 = add nsw i64 %69, %71
  store i64 %72, ptr %70, align 8, !tbaa !11
  %73 = add nuw nsw i64 %57, 16
  %74 = icmp samesign ult i64 %65, 99992
  br i1 %74, label %56, label %53, !llvm.loop !20

75:                                               ; preds = %53, %75
  %76 = phi i64 [ %99, %75 ], [ 0, %53 ]
  %77 = phi i64 [ %98, %75 ], [ 0, %53 ]
  %78 = getelementptr inbounds nuw %struct.Body, ptr %1, i64 %76
  %79 = load i64, ptr %78, align 8, !tbaa !5
  %80 = add nsw i64 %79, %77
  %81 = getelementptr inbounds nuw i8, ptr %78, i64 8
  %82 = load i64, ptr %81, align 8, !tbaa !10
  %83 = add nsw i64 %80, %82
  %84 = getelementptr inbounds nuw i8, ptr %78, i64 16
  %85 = load i64, ptr %84, align 8, !tbaa !11
  %86 = add nsw i64 %83, %85
  %87 = srem i64 %86, 1000000007
  %88 = getelementptr inbounds nuw %struct.Body, ptr %1, i64 %76
  %89 = getelementptr inbounds nuw i8, ptr %88, i64 48
  %90 = load i64, ptr %89, align 8, !tbaa !5
  %91 = add nsw i64 %90, %87
  %92 = getelementptr inbounds nuw i8, ptr %88, i64 56
  %93 = load i64, ptr %92, align 8, !tbaa !10
  %94 = add nsw i64 %91, %93
  %95 = getelementptr inbounds nuw i8, ptr %88, i64 64
  %96 = load i64, ptr %95, align 8, !tbaa !11
  %97 = add nsw i64 %94, %96
  %98 = srem i64 %97, 1000000007
  %99 = add nuw nsw i64 %76, 2
  %100 = icmp eq i64 %99, 100000
  br i1 %100, label %101, label %75, !llvm.loop !21

101:                                              ; preds = %75
  tail call void @free(ptr noundef nonnull %1) #10
  %102 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef %98)
  br label %103

103:                                              ; preds = %151, %101
  %104 = phi i64 [ 0, %101 ], [ %170, %151 ]
  %105 = phi i64 [ 0, %101 ], [ %171, %151 ]
  %106 = and i64 %105, 15
  %107 = add nuw nsw i64 %106, 255
  %108 = lshr i64 %107, 2
  %109 = add nuw nsw i64 %108, 1
  %110 = and i64 %105, 15
  %111 = or disjoint i64 %110, 256
  %112 = tail call noalias ptr @calloc(i64 noundef %111, i64 noundef 8) #11
  %113 = icmp eq ptr %112, null
  br i1 %113, label %117, label %114

114:                                              ; preds = %103
  %115 = and i64 %109, 3
  %116 = and i64 %109, 252
  br label %173

117:                                              ; preds = %103
  tail call void @abort() #9
  unreachable

118:                                              ; preds = %173
  %119 = icmp eq i64 %115, 0
  br i1 %119, label %129, label %120

120:                                              ; preds = %118, %120
  %121 = phi i64 [ %126, %120 ], [ %191, %118 ]
  %122 = phi i64 [ %127, %120 ], [ 0, %118 ]
  %123 = mul nuw nsw i64 %121, 3
  %124 = add nuw nsw i64 %123, %105
  %125 = getelementptr inbounds nuw i64, ptr %112, i64 %121
  store i64 %124, ptr %125, align 8, !tbaa !17
  %126 = add nuw nsw i64 %121, 4
  %127 = add i64 %122, 1
  %128 = icmp eq i64 %127, %115
  br i1 %128, label %129, label %120, !llvm.loop !22

129:                                              ; preds = %120, %118
  %130 = mul nuw nsw i64 %105, 7
  %131 = urem i64 %130, %111
  %132 = load i64, ptr %112, align 8, !tbaa !17
  %133 = getelementptr inbounds nuw i64, ptr %112, i64 %131
  %134 = load i64, ptr %133, align 8, !tbaa !17
  %135 = add nsw i64 %134, %132
  %136 = getelementptr inbounds nuw i64, ptr %112, i64 %110
  %137 = getelementptr inbounds nuw i8, ptr %136, i64 2040
  %138 = load i64, ptr %137, align 8, !tbaa !17
  %139 = add nsw i64 %135, %138
  %140 = tail call noalias dereferenceable_or_null(10) ptr @malloc(i64 noundef 10) #8
  %141 = icmp eq ptr %140, null
  br i1 %141, label %142, label %143

142:                                              ; preds = %129
  tail call void @abort() #9
  unreachable

143:                                              ; preds = %129
  %144 = and i64 %105, 1
  %145 = icmp eq i64 %144, 0
  %146 = select i1 %145, ptr @.str.1, ptr @.str.2
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %140, ptr noundef nonnull align 1 dereferenceable(3) @.str.3, i64 3, i1 false)
  %147 = getelementptr inbounds nuw i8, ptr %140, i64 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %147, ptr noundef nonnull readonly align 1 dereferenceable(7) %146, i64 7, i1 false)
  %148 = tail call noalias dereferenceable_or_null(27) ptr @malloc(i64 noundef 27) #8
  %149 = icmp eq ptr %148, null
  br i1 %149, label %150, label %151

150:                                              ; preds = %143
  tail call void @abort() #9
  unreachable

151:                                              ; preds = %143
  %152 = and i64 %105, 3
  %153 = icmp eq i64 %152, 0
  %154 = select i1 %153, ptr @.str.4, ptr @.str.5
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(14) %148, ptr noundef nonnull align 1 dereferenceable(14) @.str.6, i64 14, i1 false)
  %155 = getelementptr inbounds nuw i8, ptr %148, i64 14
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(13) %155, ptr noundef nonnull readonly align 1 dereferenceable(13) %154, i64 13, i1 false)
  %156 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %140, ptr noundef nonnull dereferenceable(10) @.str.7) #12
  %157 = icmp eq i32 %156, 0
  %158 = add nsw i64 %139, 17
  %159 = select i1 %157, i64 %158, i64 %139
  %160 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %148, ptr noundef nonnull dereferenceable(27) @.str.8) #12
  %161 = icmp eq i32 %160, 0
  %162 = add nsw i64 %159, 43
  %163 = select i1 %161, i64 %162, i64 %159
  %164 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %148, ptr noundef nonnull dereferenceable(27) @.str.9) #12
  %165 = icmp eq i32 %164, 0
  %166 = add nsw i64 %163, 99
  %167 = select i1 %165, i64 %166, i64 %163
  %168 = add nsw i64 %104, 35
  %169 = add i64 %168, %167
  %170 = srem i64 %169, 1000000007
  tail call void @free(ptr noundef nonnull %148) #10
  tail call void @free(ptr noundef nonnull %140) #10
  tail call void @free(ptr noundef nonnull %112) #10
  %171 = add nuw nsw i64 %105, 1
  %172 = icmp eq i64 %171, 40000
  br i1 %172, label %194, label %103, !llvm.loop !24

173:                                              ; preds = %173, %114
  %174 = phi i64 [ 0, %114 ], [ %191, %173 ]
  %175 = phi i64 [ 0, %114 ], [ %192, %173 ]
  %176 = mul nuw nsw i64 %174, 3
  %177 = add nuw nsw i64 %176, %105
  %178 = getelementptr inbounds nuw i64, ptr %112, i64 %174
  store i64 %177, ptr %178, align 8, !tbaa !17
  %179 = or disjoint i64 %174, 4
  %180 = mul nuw nsw i64 %179, 3
  %181 = add nuw nsw i64 %180, %105
  %182 = getelementptr inbounds nuw i64, ptr %112, i64 %179
  store i64 %181, ptr %182, align 8, !tbaa !17
  %183 = or disjoint i64 %174, 8
  %184 = mul nuw nsw i64 %183, 3
  %185 = add nuw nsw i64 %184, %105
  %186 = getelementptr inbounds nuw i64, ptr %112, i64 %183
  store i64 %185, ptr %186, align 8, !tbaa !17
  %187 = or disjoint i64 %174, 12
  %188 = mul nuw nsw i64 %187, 3
  %189 = add nuw nsw i64 %188, %105
  %190 = getelementptr inbounds nuw i64, ptr %112, i64 %187
  store i64 %189, ptr %190, align 8, !tbaa !17
  %191 = add nuw nsw i64 %174, 16
  %192 = add nuw nsw i64 %175, 4
  %193 = icmp eq i64 %192, %116
  br i1 %193, label %118, label %173, !llvm.loop !25

194:                                              ; preds = %151
  %195 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef %170)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #1

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #2

; Function Attrs: cold nofree noreturn nounwind
declare void @abort() local_unnamed_addr #3

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #4

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #5

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @strcmp(ptr noundef captures(none), ptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #7

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold nofree noreturn nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #8 = { nounwind allocsize(0) }
attributes #9 = { cold noreturn nounwind }
attributes #10 = { nounwind }
attributes #11 = { nounwind allocsize(0,1) }
attributes #12 = { nounwind willreturn memory(read) }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!5 = !{!6, !7, i64 0}
!6 = !{!"", !7, i64 0, !7, i64 8, !7, i64 16, !7, i64 24, !7, i64 32, !7, i64 40}
!7 = !{!"long", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!6, !7, i64 8}
!11 = !{!6, !7, i64 16}
!12 = !{!6, !7, i64 24}
!13 = !{!6, !7, i64 32}
!14 = !{!6, !7, i64 40}
!15 = distinct !{!15, !16}
!16 = !{!"llvm.loop.mustprogress"}
!17 = !{!7, !7, i64 0}
!18 = distinct !{!18, !16}
!19 = distinct !{!19, !16}
!20 = distinct !{!20, !16}
!21 = distinct !{!21, !16}
!22 = distinct !{!22, !23}
!23 = !{!"llvm.loop.unroll.disable"}
!24 = distinct !{!24, !16}
!25 = distinct !{!25, !16}
