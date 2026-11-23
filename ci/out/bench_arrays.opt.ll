; ModuleID = '/tmp/bench_arrays.ll'
source_filename = "/tmp/bench_arrays.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@str = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %t3.i = tail call noalias align 16 dereferenceable_or_null(8000000) ptr @calloc(i64 1000000, i64 8)
  %t4.i = icmp eq ptr %t3.i, null
  br i1 %t4.i, label %calloc.oom.3.i, label %calloc.ok.2.i

calloc.oom.3.i:                                   ; preds = %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.2.i:                                    ; preds = %entry
  %t12.i = tail call noalias align 16 dereferenceable_or_null(8000000) ptr @calloc(i64 1000000, i64 8)
  %t13.i = icmp eq ptr %t12.i, null
  br i1 %t13.i, label %calloc.oom.7.i, label %calloc.ok.6.i

calloc.oom.7.i:                                   ; preds = %calloc.ok.2.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.6.i:                                    ; preds = %calloc.ok.2.i
  %t21.i = tail call noalias align 16 dereferenceable_or_null(8000000) ptr @calloc(i64 1000000, i64 8)
  %t22.i = icmp eq ptr %t21.i, null
  br i1 %t22.i, label %calloc.oom.11.i, label %for.body.13.i

calloc.oom.11.i:                                  ; preds = %calloc.ok.6.i
  tail call fastcc void @archx_oom_fail()
  unreachable

for.body.13.i:                                    ; preds = %calloc.ok.6.i, %for.body.13.i
  %for.i.27.015.i = phi i64 [ %t45.i, %for.body.13.i ], [ 0, %calloc.ok.6.i ]
  %t32.i = getelementptr inbounds nuw i64, ptr %t3.i, i64 %for.i.27.015.i
  %0 = trunc nuw nsw i64 %for.i.27.015.i to i32
  %1 = mul nuw nsw i32 %0, 7
  %t36.lhs.trunc.i = add nuw nsw i32 %1, 3
  %t3613.i = urem i32 %t36.lhs.trunc.i, 1000
  %t36.zext.i = zext nneg i32 %t3613.i to i64
  store i64 %t36.zext.i, ptr %t32.i, align 8
  %t39.i = getelementptr inbounds nuw i64, ptr %t12.i, i64 %for.i.27.015.i
  %2 = mul nuw nsw i32 %0, 13
  %t43.lhs.trunc.i = add nuw nsw i32 %2, 5
  %t4314.i = urem i32 %t43.lhs.trunc.i, 1000
  %t43.zext.i = zext nneg i32 %t4314.i to i64
  store i64 %t43.zext.i, ptr %t39.i, align 8
  %t45.i = add nuw nsw i64 %for.i.27.015.i, 1
  %exitcond.not.i = icmp eq i64 %t45.i, 1000000
  br i1 %exitcond.not.i, label %vector.ph, label %for.body.13.i

vector.ph:                                        ; preds = %for.body.13.i, %archx_fn_vec_step.exit.i
  %for.r.47.017.i = phi i64 [ %t75.i, %archx_fn_vec_step.exit.i ], [ 0, %for.body.13.i ]
  %var.checksum.46.016.i = phi i64 [ %t73.i, %archx_fn_vec_step.exit.i ], [ 0, %for.body.13.i ]
  %broadcast.splatinsert = insertelement <2 x i64> poison, i64 %for.r.47.017.i, i64 0
  %broadcast.splat = shufflevector <2 x i64> %broadcast.splatinsert, <2 x i64> poison, <2 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %3 = getelementptr inbounds nuw i64, ptr %t21.i, i64 %index
  %4 = getelementptr inbounds nuw i64, ptr %t3.i, i64 %index
  %5 = getelementptr inbounds nuw i8, ptr %4, i64 16
  %wide.load = load <2 x i64>, ptr %4, align 16
  %wide.load7 = load <2 x i64>, ptr %5, align 16
  %6 = mul <2 x i64> %wide.load, splat (i64 3)
  %7 = mul <2 x i64> %wide.load7, splat (i64 3)
  %8 = getelementptr inbounds nuw i64, ptr %t12.i, i64 %index
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 16
  %wide.load8 = load <2 x i64>, ptr %8, align 16
  %wide.load9 = load <2 x i64>, ptr %9, align 16
  %10 = add <2 x i64> %wide.load8, %broadcast.splat
  %11 = add <2 x i64> %wide.load9, %broadcast.splat
  %12 = add <2 x i64> %10, %6
  %13 = add <2 x i64> %11, %7
  %14 = getelementptr inbounds nuw i8, ptr %3, i64 16
  store <2 x i64> %12, ptr %3, align 16
  store <2 x i64> %13, ptr %14, align 16
  %index.next = add nuw i64 %index, 4
  %15 = icmp eq i64 %index.next, 1000000
  br i1 %15, label %archx_fn_vec_step.exit.i, label %vector.body, !llvm.loop !0

archx_fn_vec_step.exit.i:                         ; preds = %vector.body
  %t66.i = sub nuw nsw i64 999999, %for.r.47.017.i
  %t62.i = getelementptr inbounds nuw i64, ptr %t21.i, i64 %for.r.47.017.i
  %t63.i = load i64, ptr %t62.i, align 8
  %t64.i = add i64 %t63.i, %var.checksum.46.016.i
  %t70.i = getelementptr inbounds nuw i64, ptr %t21.i, i64 %t66.i
  %t71.i = load i64, ptr %t70.i, align 8
  %t72.i = add i64 %t64.i, %t71.i
  %t73.i = srem i64 %t72.i, 1000000007
  %t75.i = add nuw nsw i64 %for.r.47.017.i, 1
  %exitcond20.not.i = icmp eq i64 %t75.i, 60
  br i1 %exitcond20.not.i, label %for.body.27.i.preheader, label %vector.ph

for.body.27.i.preheader:                          ; preds = %archx_fn_vec_step.exit.i
  %invariant.gep = getelementptr inbounds i8, ptr %t21.i, i64 8
  br label %for.body.27.i

for.body.27.i:                                    ; preds = %for.body.27.i, %for.body.27.i.preheader
  %for.i.78.019.i = phi i64 [ 0, %for.body.27.i.preheader ], [ %t89.i.1, %for.body.27.i ]
  %var.total.77.018.i = phi i64 [ %t73.i, %for.body.27.i.preheader ], [ %t87.i.1, %for.body.27.i ]
  %t84.i = getelementptr inbounds nuw i64, ptr %t21.i, i64 %for.i.78.019.i
  %t85.i = load i64, ptr %t84.i, align 16
  %t86.i = add i64 %t85.i, %var.total.77.018.i
  %t87.i = srem i64 %t86.i, 1000000007
  %gep = getelementptr inbounds i64, ptr %invariant.gep, i64 %for.i.78.019.i
  %t85.i.1 = load i64, ptr %gep, align 8
  %t86.i.1 = add i64 %t85.i.1, %t87.i
  %t87.i.1 = srem i64 %t86.i.1, 1000000007
  %t89.i.1 = add nuw nsw i64 %for.i.78.019.i, 2
  %exitcond21.not.i.1 = icmp eq i64 %t89.i.1, 1000000
  br i1 %exitcond21.not.i.1, label %archx_fn_vec_kernel.exit, label %for.body.27.i

archx_fn_vec_kernel.exit:                         ; preds = %for.body.27.i
  tail call void @free(ptr nonnull %t21.i)
  tail call void @free(ptr nonnull %t12.i)
  tail call void @free(ptr nonnull %t3.i)
  %t1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t87.i.1)
  %t3.i1 = tail call noalias align 16 dereferenceable_or_null(5000000) ptr @malloc(i64 5000000)
  %t4.i2 = icmp eq ptr %t3.i1, null
  br i1 %t4.i2, label %alloc.oom.3.i, label %alloc.ok.2.i

alloc.oom.3.i:                                    ; preds = %archx_fn_vec_kernel.exit
  tail call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.2.i:                                     ; preds = %archx_fn_vec_kernel.exit
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(5000000) %t3.i1, i8 1, i64 5000000, i1 false)
  store i8 0, ptr %t3.i1, align 16
  %t18.i = getelementptr inbounds nuw i8, ptr %t3.i1, i64 1
  store i8 0, ptr %t18.i, align 1
  br label %idx.ok.11.i

idx.ok.11.i:                                      ; preds = %if.merge.15.i.1, %alloc.ok.2.i
  %t2323.i = phi i64 [ 4, %alloc.ok.2.i ], [ %t23.i.1, %if.merge.15.i.1 ]
  %var.p.20.021.i = phi i64 [ 2, %alloc.ok.2.i ], [ %t65.i.1, %if.merge.15.i.1 ]
  %t29.i = getelementptr inbounds nuw i8, ptr %t3.i1, i64 %var.p.20.021.i
  %t30.i = load i8, ptr %t29.i, align 2
  %t31.i = trunc i8 %t30.i to i1
  %t4519.i = icmp samesign ult i64 %t2323.i, 5000000
  %or.cond.i = select i1 %t31.i, i1 %t4519.i, i1 false
  br i1 %or.cond.i, label %while.fast.body.17.i, label %if.merge.15.i

while.fast.body.17.i:                             ; preds = %idx.ok.11.i, %while.fast.body.17.i
  %var.j.35.020.i = phi i64 [ %t52.i, %while.fast.body.17.i ], [ %t2323.i, %idx.ok.11.i ]
  %t48.i = getelementptr inbounds nuw i8, ptr %t3.i1, i64 %var.j.35.020.i
  store i8 0, ptr %t48.i, align 1
  %t52.i = add nuw nsw i64 %var.j.35.020.i, %var.p.20.021.i
  %t45.i6 = icmp samesign ult i64 %t52.i, 5000000
  br i1 %t45.i6, label %while.fast.body.17.i, label %if.merge.15.i

if.merge.15.i:                                    ; preds = %while.fast.body.17.i, %idx.ok.11.i
  %t65.i = or disjoint i64 %var.p.20.021.i, 1
  %t23.i = mul nuw nsw i64 %t65.i, %t65.i
  %exitcond.not.i3 = icmp eq i64 %var.p.20.021.i, 2236
  br i1 %exitcond.not.i3, label %vector.body12, label %idx.ok.11.i.1

idx.ok.11.i.1:                                    ; preds = %if.merge.15.i
  %t29.i.1 = getelementptr inbounds nuw i8, ptr %t3.i1, i64 %t65.i
  %t30.i.1 = load i8, ptr %t29.i.1, align 1
  %t31.i.1 = trunc i8 %t30.i.1 to i1
  %t4519.i.1 = icmp samesign ult i64 %t23.i, 5000000
  %or.cond.i.1 = select i1 %t31.i.1, i1 %t4519.i.1, i1 false
  br i1 %or.cond.i.1, label %while.fast.body.17.i.1, label %if.merge.15.i.1

while.fast.body.17.i.1:                           ; preds = %idx.ok.11.i.1, %while.fast.body.17.i.1
  %var.j.35.020.i.1 = phi i64 [ %t52.i.1, %while.fast.body.17.i.1 ], [ %t23.i, %idx.ok.11.i.1 ]
  %t48.i.1 = getelementptr inbounds nuw i8, ptr %t3.i1, i64 %var.j.35.020.i.1
  store i8 0, ptr %t48.i.1, align 1
  %t52.i.1 = add nuw nsw i64 %var.j.35.020.i.1, %t65.i
  %t45.i6.1 = icmp samesign ult i64 %t52.i.1, 5000000
  br i1 %t45.i6.1, label %while.fast.body.17.i.1, label %if.merge.15.i.1

if.merge.15.i.1:                                  ; preds = %while.fast.body.17.i.1, %idx.ok.11.i.1
  %t65.i.1 = add nuw nsw i64 %var.p.20.021.i, 2
  %t23.i.1 = mul nuw nsw i64 %t65.i.1, %t65.i.1
  br label %idx.ok.11.i

vector.body12:                                    ; preds = %if.merge.15.i, %vector.body12.1
  %index13 = phi i64 [ %index.next17.1, %vector.body12.1 ], [ 0, %if.merge.15.i ]
  %vec.phi = phi <2 x i64> [ %33, %vector.body12.1 ], [ zeroinitializer, %if.merge.15.i ]
  %vec.phi14 = phi <2 x i64> [ %34, %vector.body12.1 ], [ zeroinitializer, %if.merge.15.i ]
  %16 = getelementptr inbounds nuw i8, ptr %t3.i1, i64 %index13
  %17 = getelementptr inbounds nuw i8, ptr %16, i64 2
  %18 = getelementptr inbounds nuw i8, ptr %16, i64 4
  %wide.load15 = load <2 x i8>, ptr %17, align 2
  %wide.load16 = load <2 x i8>, ptr %18, align 4
  %19 = and <2 x i8> %wide.load15, splat (i8 1)
  %20 = and <2 x i8> %wide.load16, splat (i8 1)
  %21 = zext nneg <2 x i8> %19 to <2 x i64>
  %22 = zext nneg <2 x i8> %20 to <2 x i64>
  %23 = add <2 x i64> %vec.phi, %21
  %24 = add <2 x i64> %vec.phi14, %22
  %25 = icmp eq i64 %index13, 4999992
  br i1 %25, label %for.body.24.i, label %vector.body12.1, !llvm.loop !3

vector.body12.1:                                  ; preds = %vector.body12
  %26 = getelementptr inbounds nuw i8, ptr %t3.i1, i64 %index13
  %27 = getelementptr inbounds nuw i8, ptr %26, i64 6
  %28 = getelementptr inbounds nuw i8, ptr %26, i64 8
  %wide.load15.1 = load <2 x i8>, ptr %27, align 2
  %wide.load16.1 = load <2 x i8>, ptr %28, align 8
  %29 = and <2 x i8> %wide.load15.1, splat (i8 1)
  %30 = and <2 x i8> %wide.load16.1, splat (i8 1)
  %31 = zext nneg <2 x i8> %29 to <2 x i64>
  %32 = zext nneg <2 x i8> %30 to <2 x i64>
  %33 = add <2 x i64> %23, %31
  %34 = add <2 x i64> %24, %32
  %index.next17.1 = add nuw nsw i64 %index13, 8
  br label %vector.body12

for.body.24.i:                                    ; preds = %vector.body12
  %bin.rdx = add <2 x i64> %24, %23
  %35 = tail call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx)
  %t72.i4 = getelementptr inbounds nuw i8, ptr %t3.i1, i64 4999998
  %t73.i5 = load i8, ptr %t72.i4, align 2
  %36 = and i8 %t73.i5, 1
  %37 = zext nneg i8 %36 to i64
  %spec.select.i = add i64 %35, %37
  %t72.i4.1 = getelementptr inbounds nuw i8, ptr %t3.i1, i64 4999999
  %t73.i5.1 = load i8, ptr %t72.i4.1, align 1
  %38 = and i8 %t73.i5.1, 1
  %39 = zext nneg i8 %38 to i64
  %spec.select.i.1 = add i64 %spec.select.i, %39
  tail call void @free(ptr nonnull %t3.i1)
  %t3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %spec.select.i.1)
  ret i32 0
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_oom_fail() unnamed_addr #1 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #2

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #4

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #5

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #6

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #1

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v2i64(<2 x i64>) #7

attributes #0 = { nounwind }
attributes #1 = { cold nofree noreturn nounwind }
attributes #2 = { nofree nounwind }
attributes #3 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #4 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #5 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #6 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #7 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.isvectorized", i32 1}
!2 = !{!"llvm.loop.unroll.runtime.disable"}
!3 = distinct !{!3, !1, !2}
