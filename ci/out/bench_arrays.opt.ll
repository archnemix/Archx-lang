; ModuleID = '/tmp/bench_arrays.ll'
source_filename = "/tmp/bench_arrays.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00"

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #0

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef align 16 ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef align 16 ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #2

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #3

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #4 {
entry:
  %t1.i = tail call noalias align 16 dereferenceable_or_null(8000000) ptr @calloc(i64 1000000, i64 8)
  %t7.i = tail call noalias align 16 dereferenceable_or_null(8000000) ptr @calloc(i64 1000000, i64 8)
  %t13.i = tail call noalias align 16 dereferenceable_or_null(8000000) ptr @calloc(i64 1000000, i64 8)
  br label %for.body.7.i

for.body.7.i:                                     ; preds = %for.body.7.i, %entry
  %for.i.18.015.i = phi i64 [ 0, %entry ], [ %t36.i, %for.body.7.i ]
  %t23.i = getelementptr inbounds nuw i64, ptr %t1.i, i64 %for.i.18.015.i
  %0 = trunc nuw nsw i64 %for.i.18.015.i to i32
  %1 = mul nuw nsw i32 %0, 7
  %t27.lhs.trunc.i = add nuw nsw i32 %1, 3
  %t2713.i = urem i32 %t27.lhs.trunc.i, 1000
  %t27.zext.i = zext nneg i32 %t2713.i to i64
  store i64 %t27.zext.i, ptr %t23.i, align 8
  %t30.i = getelementptr inbounds nuw i64, ptr %t7.i, i64 %for.i.18.015.i
  %2 = mul nuw nsw i32 %0, 13
  %t34.lhs.trunc.i = add nuw nsw i32 %2, 5
  %t3414.i = urem i32 %t34.lhs.trunc.i, 1000
  %t34.zext.i = zext nneg i32 %t3414.i to i64
  store i64 %t34.zext.i, ptr %t30.i, align 8
  %t36.i = add nuw nsw i64 %for.i.18.015.i, 1
  %exitcond.not.i = icmp eq i64 %t36.i, 1000000
  br i1 %exitcond.not.i, label %vector.ph, label %for.body.7.i

vector.ph:                                        ; preds = %for.body.7.i, %archx_vec_step.exit.i
  %for.r.38.017.i = phi i64 [ %t61.i, %archx_vec_step.exit.i ], [ 0, %for.body.7.i ]
  %var.checksum.37.016.i = phi i64 [ %t59.i, %archx_vec_step.exit.i ], [ 0, %for.body.7.i ]
  %broadcast.splatinsert = insertelement <2 x i64> poison, i64 %for.r.38.017.i, i64 0
  %broadcast.splat = shufflevector <2 x i64> %broadcast.splatinsert, <2 x i64> poison, <2 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %3 = getelementptr inbounds nuw i64, ptr %t13.i, i64 %index
  %4 = getelementptr inbounds nuw i64, ptr %t1.i, i64 %index
  %5 = getelementptr inbounds nuw i8, ptr %4, i64 16
  %wide.load = load <2 x i64>, ptr %4, align 16
  %wide.load4 = load <2 x i64>, ptr %5, align 16
  %6 = mul <2 x i64> %wide.load, splat (i64 3)
  %7 = mul <2 x i64> %wide.load4, splat (i64 3)
  %8 = getelementptr inbounds nuw i64, ptr %t7.i, i64 %index
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %wide.load5 = load <2 x i64>, ptr %8, align 16
  %wide.load6 = load <2 x i64>, ptr %9, align 16
  %10 = add <2 x i64> %wide.load5, %broadcast.splat
  %11 = add <2 x i64> %wide.load6, %broadcast.splat
  %12 = add <2 x i64> %10, %6
  %13 = add <2 x i64> %11, %7
  %14 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store <2 x i64> %12, ptr %3, align 16
  store <2 x i64> %13, ptr %14, align 16
  %index.next = add nuw i64 %index, 4
  %15 = icmp eq i64 %index.next, 1000000
  br i1 %15, label %archx_vec_step.exit.i, label %vector.body, !llvm.loop !0

archx_vec_step.exit.i:                            ; preds = %vector.body
  %t52.i = sub nuw nsw i64 999999, %for.r.38.017.i
  %t48.i = getelementptr inbounds nuw i64, ptr %t13.i, i64 %for.r.38.017.i
  %t49.i = load i64, ptr %t48.i, align 8
  %t50.i = add i64 %t49.i, %var.checksum.37.016.i
  %t56.i = getelementptr inbounds nuw i64, ptr %t13.i, i64 %t52.i
  %t57.i = load i64, ptr %t56.i, align 8
  %t58.i = add i64 %t50.i, %t57.i
  %t59.i = srem i64 %t58.i, 1000000007
  %t61.i = add nuw nsw i64 %for.r.38.017.i, 1
  %exitcond20.not.i = icmp eq i64 %t61.i, 60
  br i1 %exitcond20.not.i, label %for.body.19.i.preheader, label %vector.ph

for.body.19.i.preheader:                          ; preds = %archx_vec_step.exit.i
  %invariant.gep = getelementptr inbounds i8, ptr %t13.i, i64 8
  br label %for.body.19.i

for.body.19.i:                                    ; preds = %for.body.19.i, %for.body.19.i.preheader
  %for.i.64.019.i = phi i64 [ 0, %for.body.19.i.preheader ], [ %t75.i.1, %for.body.19.i ]
  %var.total.63.018.i = phi i64 [ %t59.i, %for.body.19.i.preheader ], [ %t73.i.1, %for.body.19.i ]
  %t70.i = getelementptr inbounds nuw i64, ptr %t13.i, i64 %for.i.64.019.i
  %t71.i = load i64, ptr %t70.i, align 16
  %t72.i = add i64 %t71.i, %var.total.63.018.i
  %t73.i = srem i64 %t72.i, 1000000007
  %gep = getelementptr inbounds i64, ptr %invariant.gep, i64 %for.i.64.019.i
  %t71.i.1 = load i64, ptr %gep, align 8
  %t72.i.1 = add i64 %t71.i.1, %t73.i
  %t73.i.1 = srem i64 %t72.i.1, 1000000007
  %t75.i.1 = add nuw nsw i64 %for.i.64.019.i, 2
  %exitcond21.not.i.1 = icmp eq i64 %t75.i.1, 1000000
  br i1 %exitcond21.not.i.1, label %archx_vec_kernel.exit, label %for.body.19.i

archx_vec_kernel.exit:                            ; preds = %for.body.19.i
  tail call void @free(ptr nonnull %t13.i)
  tail call void @free(ptr nonnull %t7.i)
  tail call void @free(ptr nonnull %t1.i)
  %t1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t73.i.1)
  %t2.i = tail call noalias align 16 dereferenceable_or_null(5000000) ptr @malloc(i64 5000000)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(5000000) %t2.i, i8 1, i64 5000000, i1 false)
  store i8 0, ptr %t2.i, align 16
  %t21.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 1
  store i8 0, ptr %t21.i, align 1
  br label %idx.ok.12.i

idx.ok.12.i:                                      ; preds = %if.merge.16.i, %archx_vec_kernel.exit
  %t2624.i = phi i64 [ 4, %archx_vec_kernel.exit ], [ %t26.i, %if.merge.16.i ]
  %var.p.23.022.i = phi i64 [ 2, %archx_vec_kernel.exit ], [ %t68.i, %if.merge.16.i ]
  %t32.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 %var.p.23.022.i
  %t33.i = load i8, ptr %t32.i, align 1
  %t34.not.i = icmp ne i8 %t33.i, 0
  %t4820.i = icmp samesign ult i64 %t2624.i, 5000000
  %or.cond.i = select i1 %t34.not.i, i1 %t4820.i, i1 false
  br i1 %or.cond.i, label %while.fast.body.18.i, label %if.merge.16.i

while.fast.body.18.i:                             ; preds = %idx.ok.12.i, %while.fast.body.18.i
  %var.j.38.021.i = phi i64 [ %t55.i, %while.fast.body.18.i ], [ %t2624.i, %idx.ok.12.i ]
  %t51.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 %var.j.38.021.i
  store i8 0, ptr %t51.i, align 1
  %t55.i = add nuw nsw i64 %var.j.38.021.i, %var.p.23.022.i
  %t48.i3 = icmp samesign ult i64 %t55.i, 5000000
  br i1 %t48.i3, label %while.fast.body.18.i, label %if.merge.16.i

if.merge.16.i:                                    ; preds = %while.fast.body.18.i, %idx.ok.12.i
  %t68.i = add nuw nsw i64 %var.p.23.022.i, 1
  %t26.i = mul nuw nsw i64 %t68.i, %t68.i
  %exitcond.not.i1 = icmp eq i64 %t68.i, 2237
  br i1 %exitcond.not.i1, label %vector.body9, label %idx.ok.12.i

vector.body9:                                     ; preds = %if.merge.16.i, %vector.body9.1
  %index10 = phi i64 [ %index.next14.1, %vector.body9.1 ], [ 0, %if.merge.16.i ]
  %vec.phi = phi <2 x i64> [ %33, %vector.body9.1 ], [ zeroinitializer, %if.merge.16.i ]
  %vec.phi11 = phi <2 x i64> [ %34, %vector.body9.1 ], [ zeroinitializer, %if.merge.16.i ]
  %16 = getelementptr inbounds nuw i8, ptr %t2.i, i64 %index10
  %17 = getelementptr inbounds nuw i8, ptr %16, i64 2
  %18 = getelementptr inbounds nuw i8, ptr %16, i64 4
  %wide.load12 = load <2 x i8>, ptr %17, align 2
  %wide.load13 = load <2 x i8>, ptr %18, align 4
  %19 = icmp ne <2 x i8> %wide.load12, zeroinitializer
  %20 = icmp ne <2 x i8> %wide.load13, zeroinitializer
  %21 = zext <2 x i1> %19 to <2 x i64>
  %22 = zext <2 x i1> %20 to <2 x i64>
  %23 = add <2 x i64> %vec.phi, %21
  %24 = add <2 x i64> %vec.phi11, %22
  %25 = icmp eq i64 %index10, 4999992
  br i1 %25, label %for.body.25.i, label %vector.body9.1, !llvm.loop !3

vector.body9.1:                                   ; preds = %vector.body9
  %26 = getelementptr inbounds nuw i8, ptr %t2.i, i64 %index10
  %27 = getelementptr inbounds nuw i8, ptr %26, i64 6
  %28 = getelementptr inbounds nuw i8, ptr %26, i64 8
  %wide.load12.1 = load <2 x i8>, ptr %27, align 2
  %wide.load13.1 = load <2 x i8>, ptr %28, align 8
  %29 = icmp ne <2 x i8> %wide.load12.1, zeroinitializer
  %30 = icmp ne <2 x i8> %wide.load13.1, zeroinitializer
  %31 = zext <2 x i1> %29 to <2 x i64>
  %32 = zext <2 x i1> %30 to <2 x i64>
  %33 = add <2 x i64> %23, %31
  %34 = add <2 x i64> %24, %32
  %index.next14.1 = add nuw nsw i64 %index10, 8
  br label %vector.body9

for.body.25.i:                                    ; preds = %vector.body9
  %bin.rdx = add <2 x i64> %24, %23
  %35 = tail call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx)
  %t75.i2 = getelementptr inbounds nuw i8, ptr %t2.i, i64 4999998
  %t76.i = load i8, ptr %t75.i2, align 2
  %t77.not.i = icmp ne i8 %t76.i, 0
  %t79.i = zext i1 %t77.not.i to i64
  %spec.select.i = add i64 %35, %t79.i
  %t75.i2.1 = getelementptr inbounds nuw i8, ptr %t2.i, i64 4999999
  %t76.i.1 = load i8, ptr %t75.i2.1, align 1
  %t77.not.i.1 = icmp ne i8 %t76.i.1, 0
  %t79.i.1 = zext i1 %t77.not.i.1 to i64
  %spec.select.i.1 = add i64 %spec.select.i, %t79.i.1
  tail call void @free(ptr nonnull %t2.i)
  %t3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %spec.select.i.1)
  ret i32 0
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v2i64(<2 x i64>) #6

attributes #0 = { nofree nounwind }
attributes #1 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #2 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #3 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #4 = { nounwind }
attributes #5 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #6 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.isvectorized", i32 1}
!2 = !{!"llvm.loop.unroll.runtime.disable"}
!3 = distinct !{!3, !1, !2}
