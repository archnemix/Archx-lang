; ModuleID = '/tmp/bench_composite.ll'
source_filename = "/tmp/bench_composite.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxStr = type { i64, i64 }

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.0 = private unnamed_addr constant [15 x i8] c"packet_header_\00", align 4
@.str.1 = private unnamed_addr constant [27 x i8] c"packet_header_payload_v2_a\00", align 4
@.str.2 = private unnamed_addr constant [27 x i8] c"packet_header_never_match!\00", align 4
@str = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %func.region.i = alloca %ArchxRegion, align 8
  %t3.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @calloc(i64 100000, i64 8)
  %t4.i = icmp eq ptr %t3.i, null
  br i1 %t4.i, label %calloc.oom.3.i, label %calloc.ok.2.i

calloc.oom.3.i:                                   ; preds = %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.2.i:                                    ; preds = %entry
  %t7.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @calloc(i64 100000, i64 8)
  %t8.i = icmp eq ptr %t7.i, null
  br i1 %t8.i, label %calloc.oom.5.i, label %calloc.ok.4.i

calloc.oom.5.i:                                   ; preds = %calloc.ok.2.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.4.i:                                    ; preds = %calloc.ok.2.i
  %t11.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @calloc(i64 100000, i64 8)
  %t12.i = icmp eq ptr %t11.i, null
  br i1 %t12.i, label %calloc.oom.7.i, label %calloc.ok.6.i

calloc.oom.7.i:                                   ; preds = %calloc.ok.4.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.6.i:                                    ; preds = %calloc.ok.4.i
  %t16.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @malloc(i64 800000)
  %t17.i = icmp eq ptr %t16.i, null
  br i1 %t17.i, label %alloc.oom.9.i, label %vector.body

vector.body:                                      ; preds = %calloc.ok.6.i, %vector.body
  %index = phi i64 [ %index.next.4, %vector.body ], [ 0, %calloc.ok.6.i ]
  %0 = getelementptr inbounds nuw i64, ptr %t16.i, i64 %index
  %1 = getelementptr inbounds nuw i8, ptr %0, i64 16
  store <2 x i64> splat (i64 1), ptr %0, align 16
  store <2 x i64> splat (i64 1), ptr %1, align 16
  %2 = getelementptr inbounds nuw i64, ptr %t16.i, i64 %index
  %3 = getelementptr inbounds nuw i8, ptr %2, i64 32
  %4 = getelementptr inbounds nuw i8, ptr %2, i64 48
  store <2 x i64> splat (i64 1), ptr %3, align 16
  store <2 x i64> splat (i64 1), ptr %4, align 16
  %5 = getelementptr inbounds nuw i64, ptr %t16.i, i64 %index
  %6 = getelementptr inbounds nuw i8, ptr %5, i64 64
  %7 = getelementptr inbounds nuw i8, ptr %5, i64 80
  store <2 x i64> splat (i64 1), ptr %6, align 16
  store <2 x i64> splat (i64 1), ptr %7, align 16
  %8 = getelementptr inbounds nuw i64, ptr %t16.i, i64 %index
  %9 = getelementptr inbounds nuw i8, ptr %8, i64 96
  %10 = getelementptr inbounds nuw i8, ptr %8, i64 112
  store <2 x i64> splat (i64 1), ptr %9, align 16
  store <2 x i64> splat (i64 1), ptr %10, align 16
  %11 = getelementptr inbounds nuw i64, ptr %t16.i, i64 %index
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 128
  %13 = getelementptr inbounds nuw i8, ptr %11, i64 144
  store <2 x i64> splat (i64 1), ptr %12, align 16
  store <2 x i64> splat (i64 1), ptr %13, align 16
  %index.next.4 = add nuw nsw i64 %index, 20
  %14 = icmp eq i64 %index.next.4, 100000
  br i1 %14, label %fill.end.12.i, label %vector.body, !llvm.loop !0

alloc.oom.9.i:                                    ; preds = %calloc.ok.6.i
  tail call fastcc void @archx_oom_fail()
  unreachable

fill.end.12.i:                                    ; preds = %vector.body
  %t26.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @malloc(i64 800000)
  %t27.i = icmp eq ptr %t26.i, null
  br i1 %t27.i, label %alloc.oom.14.i, label %vector.body28

vector.body28:                                    ; preds = %fill.end.12.i, %vector.body28
  %index29 = phi i64 [ %index.next30.4, %vector.body28 ], [ 0, %fill.end.12.i ]
  %15 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index29
  %16 = getelementptr inbounds nuw i8, ptr %15, i64 16
  store <2 x i64> splat (i64 2), ptr %15, align 16
  store <2 x i64> splat (i64 2), ptr %16, align 16
  %17 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index29
  %18 = getelementptr inbounds nuw i8, ptr %17, i64 32
  %19 = getelementptr inbounds nuw i8, ptr %17, i64 48
  store <2 x i64> splat (i64 2), ptr %18, align 16
  store <2 x i64> splat (i64 2), ptr %19, align 16
  %20 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index29
  %21 = getelementptr inbounds nuw i8, ptr %20, i64 64
  %22 = getelementptr inbounds nuw i8, ptr %20, i64 80
  store <2 x i64> splat (i64 2), ptr %21, align 16
  store <2 x i64> splat (i64 2), ptr %22, align 16
  %23 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index29
  %24 = getelementptr inbounds nuw i8, ptr %23, i64 96
  %25 = getelementptr inbounds nuw i8, ptr %23, i64 112
  store <2 x i64> splat (i64 2), ptr %24, align 16
  store <2 x i64> splat (i64 2), ptr %25, align 16
  %26 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index29
  %27 = getelementptr inbounds nuw i8, ptr %26, i64 128
  %28 = getelementptr inbounds nuw i8, ptr %26, i64 144
  store <2 x i64> splat (i64 2), ptr %27, align 16
  store <2 x i64> splat (i64 2), ptr %28, align 16
  %index.next30.4 = add nuw nsw i64 %index29, 20
  %29 = icmp eq i64 %index.next30.4, 100000
  br i1 %29, label %fill.end.17.i, label %vector.body28, !llvm.loop !3

alloc.oom.14.i:                                   ; preds = %fill.end.12.i
  tail call fastcc void @archx_oom_fail()
  unreachable

fill.end.17.i:                                    ; preds = %vector.body28
  %t36.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @malloc(i64 800000)
  %t37.i = icmp eq ptr %t36.i, null
  br i1 %t37.i, label %alloc.oom.19.i, label %vector.body35

vector.body35:                                    ; preds = %fill.end.17.i, %vector.body35
  %index36 = phi i64 [ %index.next37.4, %vector.body35 ], [ 0, %fill.end.17.i ]
  %30 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index36
  %31 = getelementptr inbounds nuw i8, ptr %30, i64 16
  store <2 x i64> splat (i64 3), ptr %30, align 16
  store <2 x i64> splat (i64 3), ptr %31, align 16
  %32 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index36
  %33 = getelementptr inbounds nuw i8, ptr %32, i64 32
  %34 = getelementptr inbounds nuw i8, ptr %32, i64 48
  store <2 x i64> splat (i64 3), ptr %33, align 16
  store <2 x i64> splat (i64 3), ptr %34, align 16
  %35 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index36
  %36 = getelementptr inbounds nuw i8, ptr %35, i64 64
  %37 = getelementptr inbounds nuw i8, ptr %35, i64 80
  store <2 x i64> splat (i64 3), ptr %36, align 16
  store <2 x i64> splat (i64 3), ptr %37, align 16
  %38 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index36
  %39 = getelementptr inbounds nuw i8, ptr %38, i64 96
  %40 = getelementptr inbounds nuw i8, ptr %38, i64 112
  store <2 x i64> splat (i64 3), ptr %39, align 16
  store <2 x i64> splat (i64 3), ptr %40, align 16
  %41 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index36
  %42 = getelementptr inbounds nuw i8, ptr %41, i64 128
  %43 = getelementptr inbounds nuw i8, ptr %41, i64 144
  store <2 x i64> splat (i64 3), ptr %42, align 16
  store <2 x i64> splat (i64 3), ptr %43, align 16
  %index.next37.4 = add nuw nsw i64 %index36, 20
  %44 = icmp eq i64 %index.next37.4, 100000
  br i1 %44, label %for.body.24.i, label %vector.body35, !llvm.loop !4

alloc.oom.19.i:                                   ; preds = %fill.end.17.i
  tail call fastcc void @archx_oom_fail()
  unreachable

for.body.24.i:                                    ; preds = %vector.body35, %for.body.24.i
  %for.i.43.032.i = phi i64 [ %t74.i, %for.body.24.i ], [ 0, %vector.body35 ]
  %t47.i = getelementptr inbounds nuw i64, ptr %t3.i, i64 %for.i.43.032.i
  %t49.i = mul nuw nsw i64 %for.i.43.032.i, 3
  store i64 %t49.i, ptr %t47.i, align 8
  %t51.i = getelementptr inbounds nuw i64, ptr %t7.i, i64 %for.i.43.032.i
  %t53.i = mul nuw nsw i64 %for.i.43.032.i, 5
  store i64 %t53.i, ptr %t51.i, align 8
  %t55.i = getelementptr inbounds nuw i64, ptr %t11.i, i64 %for.i.43.032.i
  %t57.i = mul nuw nsw i64 %for.i.43.032.i, 7
  store i64 %t57.i, ptr %t55.i, align 8
  %t59.i = getelementptr inbounds nuw i64, ptr %t16.i, i64 %for.i.43.032.i
  %t61.lhs.trunc.i = trunc nuw nsw i64 %for.i.43.032.i to i32
  %t6126.i = urem i32 %t61.lhs.trunc.i, 7
  %narrow.i = add nuw nsw i32 %t6126.i, 1
  %t62.i = zext nneg i32 %narrow.i to i64
  store i64 %t62.i, ptr %t59.i, align 8
  %t64.i = getelementptr inbounds nuw i64, ptr %t26.i, i64 %for.i.43.032.i
  %t6627.i = urem i32 %t61.lhs.trunc.i, 5
  %narrow30.i = add nuw nsw i32 %t6627.i, 1
  %t67.i = zext nneg i32 %narrow30.i to i64
  store i64 %t67.i, ptr %t64.i, align 8
  %t69.i = getelementptr inbounds nuw i64, ptr %t36.i, i64 %for.i.43.032.i
  %t7128.i = urem i32 %t61.lhs.trunc.i, 3
  %narrow31.i = add nuw nsw i32 %t7128.i, 1
  %t72.i = zext nneg i32 %narrow31.i to i64
  store i64 %t72.i, ptr %t69.i, align 8
  %t74.i = add nuw nsw i64 %for.i.43.032.i, 1
  %exitcond40.not.i = icmp eq i64 %t74.i, 100000
  br i1 %exitcond40.not.i, label %vector.ph41, label %for.body.24.i

vector.ph41:                                      ; preds = %for.body.24.i, %for.step.29.i
  %for.t.75.035.i = phi i64 [ %t114.i, %for.step.29.i ], [ 0, %for.body.24.i ]
  br label %vector.body42

vector.body42:                                    ; preds = %vector.body42, %vector.ph41
  %index43 = phi i64 [ 0, %vector.ph41 ], [ %index.next51, %vector.body42 ]
  %45 = getelementptr inbounds nuw i64, ptr %t3.i, i64 %index43
  %46 = getelementptr inbounds nuw i8, ptr %45, i64 16
  %wide.load = load <2 x i64>, ptr %45, align 16
  %wide.load44 = load <2 x i64>, ptr %46, align 16
  %47 = getelementptr inbounds nuw i64, ptr %t16.i, i64 %index43
  %48 = getelementptr inbounds nuw i8, ptr %47, i64 16
  %wide.load45 = load <2 x i64>, ptr %47, align 16
  %wide.load46 = load <2 x i64>, ptr %48, align 16
  %49 = add <2 x i64> %wide.load45, %wide.load
  %50 = add <2 x i64> %wide.load46, %wide.load44
  store <2 x i64> %49, ptr %45, align 16
  store <2 x i64> %50, ptr %46, align 16
  %51 = getelementptr inbounds nuw i64, ptr %t7.i, i64 %index43
  %52 = getelementptr inbounds nuw i8, ptr %51, i64 16
  %wide.load47 = load <2 x i64>, ptr %51, align 16
  %wide.load48 = load <2 x i64>, ptr %52, align 16
  %53 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index43
  %54 = getelementptr inbounds nuw i8, ptr %53, i64 16
  %wide.load49 = load <2 x i64>, ptr %53, align 16
  %wide.load50 = load <2 x i64>, ptr %54, align 16
  %55 = sub <2 x i64> %wide.load47, %wide.load49
  %56 = sub <2 x i64> %wide.load48, %wide.load50
  store <2 x i64> %55, ptr %51, align 16
  store <2 x i64> %56, ptr %52, align 16
  %index.next51 = add nuw i64 %index43, 4
  %57 = icmp eq i64 %index.next51, 100000
  br i1 %57, label %for.body.36.preheader.i, label %vector.body42, !llvm.loop !5

for.body.36.preheader.i:                          ; preds = %vector.body42
  %t79.lhs.trunc.i = trunc nuw i64 %for.t.75.035.i to i8
  %t7929.i = urem i8 %t79.lhs.trunc.i, 3
  %t79.zext.i = zext nneg i8 %t7929.i to i64
  %t80.i = add nsw i64 %t79.zext.i, -1
  br label %for.body.36.i

for.body.36.i:                                    ; preds = %for.body.36.i, %for.body.36.preheader.i
  %for.i.100.034.i = phi i64 [ 0, %for.body.36.preheader.i ], [ %t112.i.1, %for.body.36.i ]
  %t104.i = getelementptr inbounds nuw i64, ptr %t11.i, i64 %for.i.100.034.i
  %t105.i = load i64, ptr %t104.i, align 16
  %t107.i = getelementptr inbounds nuw i64, ptr %t36.i, i64 %for.i.100.034.i
  %t108.i = load i64, ptr %t107.i, align 16
  %t109.i = add i64 %t80.i, %t105.i
  %t110.i = add i64 %t109.i, %t108.i
  store i64 %t110.i, ptr %t104.i, align 16
  %t112.i = or disjoint i64 %for.i.100.034.i, 8
  %t104.i.1 = getelementptr inbounds nuw i64, ptr %t11.i, i64 %t112.i
  %t105.i.1 = load i64, ptr %t104.i.1, align 16
  %t107.i.1 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %t112.i
  %t108.i.1 = load i64, ptr %t107.i.1, align 16
  %t109.i.1 = add i64 %t80.i, %t105.i.1
  %t110.i.1 = add i64 %t109.i.1, %t108.i.1
  store i64 %t110.i.1, ptr %t104.i.1, align 16
  %t112.i.1 = add nuw nsw i64 %for.i.100.034.i, 16
  %t102.i.1 = icmp samesign ult i64 %t112.i, 99992
  br i1 %t102.i.1, label %for.body.36.i, label %for.step.29.i

for.step.29.i:                                    ; preds = %for.body.36.i
  %t114.i = add nuw nsw i64 %for.t.75.035.i, 1
  %exitcond42.not.i = icmp eq i64 %t114.i, 120
  br i1 %exitcond42.not.i, label %foreach.body.40.i, label %vector.ph41

foreach.body.40.i:                                ; preds = %for.step.29.i, %foreach.body.40.i
  %foreach.idx.116.037.i = phi i64 [ %t146.i.1, %foreach.body.40.i ], [ 0, %for.step.29.i ]
  %var.acc.115.036.i = phi i64 [ %t144.i.1, %foreach.body.40.i ], [ 0, %for.step.29.i ]
  %t119.i = getelementptr inbounds nuw i64, ptr %t3.i, i64 %foreach.idx.116.037.i
  %t120.i = load i64, ptr %t119.i, align 16
  %t122.i = getelementptr inbounds nuw i64, ptr %t7.i, i64 %foreach.idx.116.037.i
  %t123.i = load i64, ptr %t122.i, align 16
  %t125.i = getelementptr inbounds nuw i64, ptr %t11.i, i64 %foreach.idx.116.037.i
  %t126.i = load i64, ptr %t125.i, align 16
  %t139.i = add i64 %t120.i, %var.acc.115.036.i
  %t141.i = add i64 %t139.i, %t123.i
  %t143.i = add i64 %t141.i, %t126.i
  %t144.i = srem i64 %t143.i, 1000000007
  %t146.i = or disjoint i64 %foreach.idx.116.037.i, 1
  %t119.i.1 = getelementptr inbounds nuw i64, ptr %t3.i, i64 %t146.i
  %t120.i.1 = load i64, ptr %t119.i.1, align 8
  %t122.i.1 = getelementptr inbounds nuw i64, ptr %t7.i, i64 %t146.i
  %t123.i.1 = load i64, ptr %t122.i.1, align 8
  %t125.i.1 = getelementptr inbounds nuw i64, ptr %t11.i, i64 %t146.i
  %t126.i.1 = load i64, ptr %t125.i.1, align 8
  %t139.i.1 = add i64 %t120.i.1, %t144.i
  %t141.i.1 = add i64 %t139.i.1, %t123.i.1
  %t143.i.1 = add i64 %t141.i.1, %t126.i.1
  %t144.i.1 = srem i64 %t143.i.1, 1000000007
  %t146.i.1 = add nuw nsw i64 %foreach.idx.116.037.i, 2
  %exitcond43.not.i.1 = icmp eq i64 %t146.i.1, 100000
  br i1 %exitcond43.not.i.1, label %archx_fn_particle_sim.exit, label %foreach.body.40.i

archx_fn_particle_sim.exit:                       ; preds = %foreach.body.40.i
  tail call void @free(ptr nonnull %t36.i)
  tail call void @free(ptr nonnull %t26.i)
  tail call void @free(ptr nonnull %t16.i)
  tail call void @free(ptr nonnull %t11.i)
  tail call void @free(ptr nonnull %t7.i)
  tail call void @free(ptr nonnull %t3.i)
  %t1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t144.i.1)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %func.region.i)
  %.fca.1.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 8
  %.fca.2.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 16
  %.fca.3.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %func.region.i, i8 0, i64 32, i1 false)
  br label %check_reuse.i.i

check_reuse.i.i:                                  ; preds = %archx_str_drop.exit56.i, %archx_fn_particle_sim.exit
  %var.total.0.0133.i = phi i64 [ 0, %archx_fn_particle_sim.exit ], [ %t111.i, %archx_str_drop.exit56.i ]
  %for.r.1.0132.i = phi i64 [ 0, %archx_fn_particle_sim.exit ], [ %t119.i15, %archx_str_drop.exit56.i ]
  %58 = and i64 %for.r.1.0132.i, 15
  %59 = add nuw nsw i64 %58, 255
  %60 = lshr i64 %59, 2
  %61 = add nuw nsw i64 %60, 1
  %t10.i = and i64 %for.r.1.0132.i, 15
  %t11.i1 = or disjoint i64 %t10.i, 256
  %t13.i = shl nuw nsw i64 %t11.i1, 3
  %a1.i.i = add nuw nsw i64 %t13.i, 15
  %aligned.i.i = and i64 %a1.i.i, 2288
  %cand.i.i = load ptr, ptr %.fca.2.gep.i, align 8
  %has_cand.not.i.i = icmp eq ptr %cand.i.i, null
  br i1 %has_cand.not.i.i, label %slow.i.i, label %check_cand_cap.i.i

check_cand_cap.i.i:                               ; preds = %check_reuse.i.i
  %ccap_ptr.i.i = getelementptr inbounds nuw i8, ptr %cand.i.i, i64 8
  %ccap.i.i = load i64, ptr %ccap_ptr.i.i, align 8
  %cfits.not.i.i = icmp slt i64 %ccap.i.i, %aligned.i.i
  br i1 %cfits.not.i.i, label %free_cand.i.i, label %reuse_cand.i.i

reuse_cand.i.i:                                   ; preds = %check_cand_cap.i.i
  store ptr %cand.i.i, ptr %.fca.3.gep.i, align 8
  %cdata.i.i = getelementptr inbounds nuw i8, ptr %cand.i.i, i64 16
  %ccur.i.i = getelementptr inbounds nuw i8, ptr %cdata.i.i, i64 %aligned.i.i
  %cend.i.i = getelementptr inbounds nuw i8, ptr %cdata.i.i, i64 %ccap.i.i
  store ptr %ccur.i.i, ptr %func.region.i, align 8
  store ptr %cend.i.i, ptr %.fca.1.gep.i, align 8
  br label %archx_region_alloc.exit.i

free_cand.i.i:                                    ; preds = %check_cand_cap.i.i
  store ptr null, ptr %.fca.2.gep.i, align 8
  br label %loop.i.i

loop.i.i:                                         ; preds = %loop.i.i, %free_cand.i.i
  %cur.i57.i = phi ptr [ %next.i58.i, %loop.i.i ], [ %cand.i.i, %free_cand.i.i ]
  %next.i58.i = load ptr, ptr %cur.i57.i, align 8
  tail call void @free(ptr nonnull %cur.i57.i)
  %more.not.i.i = icmp eq ptr %next.i58.i, null
  br i1 %more.not.i.i, label %slow.i.i, label %loop.i.i

slow.i.i:                                         ; preds = %loop.i.i, %check_reuse.i.i
  %res.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_slow(ptr nonnull %func.region.i, i64 %aligned.i.i)
  br label %archx_region_alloc.exit.i

archx_region_alloc.exit.i:                        ; preds = %slow.i.i, %reuse_cand.i.i
  %common.ret.op.i.i = phi ptr [ %cdata.i.i, %reuse_cand.i.i ], [ %res.i.i, %slow.i.i ]
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %common.ret.op.i.i, i8 0, i64 %t13.i, i1 false)
  %xtraiter = and i64 %61, 3
  %unroll_iter = and i64 %61, 252
  br label %for.body.9.i

for.body.9.i:                                     ; preds = %for.body.9.i, %archx_region_alloc.exit.i
  %for.k.24.0131.i = phi i64 [ 0, %archx_region_alloc.exit.i ], [ %t35.i.3, %for.body.9.i ]
  %niter = phi i64 [ 0, %archx_region_alloc.exit.i ], [ %niter.next.3, %for.body.9.i ]
  %t29.i2 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %for.k.24.0131.i
  %t32.i = mul nuw nsw i64 %for.k.24.0131.i, 3
  %t33.i = add nuw nsw i64 %t32.i, %for.r.1.0132.i
  store i64 %t33.i, ptr %t29.i2, align 8
  %t35.i = or disjoint i64 %for.k.24.0131.i, 4
  %t29.i2.1 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t35.i
  %t32.i.1 = mul nuw nsw i64 %t35.i, 3
  %t33.i.1 = add nuw nsw i64 %t32.i.1, %for.r.1.0132.i
  store i64 %t33.i.1, ptr %t29.i2.1, align 8
  %t35.i.1 = or disjoint i64 %for.k.24.0131.i, 8
  %t29.i2.2 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t35.i.1
  %t32.i.2 = mul nuw nsw i64 %t35.i.1, 3
  %t33.i.2 = add nuw nsw i64 %t32.i.2, %for.r.1.0132.i
  store i64 %t33.i.2, ptr %t29.i2.2, align 8
  %t35.i.2 = or disjoint i64 %for.k.24.0131.i, 12
  %t29.i2.3 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t35.i.2
  %t32.i.3 = mul nuw nsw i64 %t35.i.2, 3
  %t33.i.3 = add nuw nsw i64 %t32.i.3, %for.r.1.0132.i
  store i64 %t33.i.3, ptr %t29.i2.3, align 8
  %t35.i.3 = add nuw nsw i64 %for.k.24.0131.i, 16
  %niter.next.3 = add nuw nsw i64 %niter, 4
  %niter.ncmp.3.not = icmp eq i64 %niter.next.3, %unroll_iter
  br i1 %niter.ncmp.3.not, label %div.ok.13.i.unr-lcssa, label %for.body.9.i

div.ok.13.i.unr-lcssa:                            ; preds = %for.body.9.i
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %div.ok.13.i, label %for.body.9.i.epil

for.body.9.i.epil:                                ; preds = %div.ok.13.i.unr-lcssa, %for.body.9.i.epil
  %for.k.24.0131.i.epil = phi i64 [ %t35.i.epil, %for.body.9.i.epil ], [ %t35.i.3, %div.ok.13.i.unr-lcssa ]
  %epil.iter = phi i64 [ %epil.iter.next, %for.body.9.i.epil ], [ 0, %div.ok.13.i.unr-lcssa ]
  %t29.i2.epil = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %for.k.24.0131.i.epil
  %t32.i.epil = mul nuw nsw i64 %for.k.24.0131.i.epil, 3
  %t33.i.epil = add nuw nsw i64 %t32.i.epil, %for.r.1.0132.i
  store i64 %t33.i.epil, ptr %t29.i2.epil, align 8
  %t35.i.epil = add nuw nsw i64 %for.k.24.0131.i.epil, 4
  %epil.iter.next = add i64 %epil.iter, 1
  %epil.iter.cmp.not = icmp eq i64 %epil.iter.next, %xtraiter
  br i1 %epil.iter.cmp.not, label %div.ok.13.i, label %for.body.9.i.epil, !llvm.loop !6

div.ok.13.i:                                      ; preds = %for.body.9.i.epil, %div.ok.13.i.unr-lcssa
  %t37.i4 = mul nuw nsw i64 %for.r.1.0132.i, 7
  %t43.i = urem i64 %t37.i4, %t11.i1
  %t48.i = load i64, ptr %common.ret.op.i.i, align 8
  %t52.i = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t43.i
  %t53.i5 = load i64, ptr %t52.i, align 8
  %t54.i = add i64 %t53.i5, %t48.i
  %62 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t10.i
  %t59.i6 = getelementptr inbounds nuw i8, ptr %62, i64 2040
  %t60.i = load i64, ptr %t59.i6, align 8
  %t61.i = add i64 %t54.i, %t60.i
  %t65.i = and i64 %for.r.1.0132.i, 1
  %t66.i = icmp eq i64 %t65.i, 0
  %spec.select.i = select i1 %t66.i, i64 12385, i64 14649
  %spec.select127.i = select i1 %t66.i, i64 7525634141203726342, i64 7022349190558646278
  %t68.fca.0.insert.i = insertvalue %ArchxStr poison, i64 %spec.select127.i, 0
  %t68.fca.1.insert.i = insertvalue %ArchxStr %t68.fca.0.insert.i, i64 %spec.select.i, 1
  %t69.i7 = call fastcc { i64, i64 } @archx_str_concat(%ArchxStr { i64 26850524921856003, i64 0 }, %ArchxStr %t68.fca.1.insert.i, ptr %func.region.i)
  %newret22 = extractvalue { i64, i64 } %t69.i7, 0
  %oldret23 = insertvalue %ArchxStr poison, i64 %newret22, 0
  %newret24 = extractvalue { i64, i64 } %t69.i7, 1
  %oldret25 = insertvalue %ArchxStr %oldret23, i64 %newret24, 1
  %t69.fr.i = freeze %ArchxStr %oldret25
  %t69.fca.0.extract.i = extractvalue %ArchxStr %t69.fr.i, 0
  %t73.i = and i64 %for.r.1.0132.i, 3
  %t74.i8 = icmp eq i64 %t73.i, 0
  %var.l_rhs.71.sroa.5.0.i = select i1 %t74.i8, i64 7016382228454465903, i64 7088494763882274674
  %var.l_rhs.71.sroa.0.0.i = select i1 %t74.i8, i64 7816385761942437900, i64 7307218415498821644
  %t79.fca.0.insert.i = insertvalue %ArchxStr poison, i64 %var.l_rhs.71.sroa.0.0.i, 0
  %t79.fca.1.insert.i = insertvalue %ArchxStr %t79.fca.0.insert.i, i64 %var.l_rhs.71.sroa.5.0.i, 1
  %t80.i9 = call fastcc { i64, i64 } @archx_str_concat(%ArchxStr { i64 7738135718416875534, i64 ptrtoint (ptr @.str.0 to i64) }, %ArchxStr %t79.fca.1.insert.i, ptr %func.region.i)
  %newret = extractvalue { i64, i64 } %t80.i9, 0
  %newret20 = extractvalue { i64, i64 } %t80.i9, 1
  %w0_eq.i.i = icmp eq i64 %t69.fca.0.extract.i, 7016437146600865801
  %aw1.i.i = extractvalue %ArchxStr %t69.fr.i, 1
  %eq_s.i.i = icmp eq i64 %aw1.i.i, 207792664684
  %t85.i10 = add i64 %t61.i, 17
  %63 = and i1 %w0_eq.i.i, %eq_s.i.i
  %64 = select i1 %63, i64 %t85.i10, i64 %t61.i
  %w0_eq.i63.i = icmp eq i64 %newret, 7738135718416875546
  br i1 %w0_eq.i63.i, label %cmp_long.i69.i, label %archx_str_eq.exit99.thread123.i

cmp_long.i69.i:                                   ; preds = %div.ok.13.i
  %ap_i.i70.i = and i64 %newret20, -4
  %same_ptr.i71.i = icmp eq i64 %ap_i.i70.i, ptrtoint (ptr @.str.1 to i64)
  br i1 %same_ptr.i71.i, label %archx_str_eq.exit80.thread.i, label %archx_str_eq.exit80.i

archx_str_eq.exit80.thread.i:                     ; preds = %cmp_long.i69.i
  %t92111.i = add i64 %64, 43
  br label %cmp_long.i88.i

archx_str_eq.exit80.i:                            ; preds = %cmp_long.i69.i
  %ap.i73.i = inttoptr i64 %ap_i.i70.i to ptr
  %ap4.i74.i = getelementptr inbounds nuw i8, ptr %ap.i73.i, i64 4
  %bcmp.i76.i = tail call i32 @bcmp(ptr noundef nonnull dereferenceable(22) %ap4.i74.i, ptr noundef nonnull dereferenceable(22) getelementptr inbounds nuw (i8, ptr @.str.1, i64 4), i64 22)
  %bcmp.i76.fr.i = freeze i32 %bcmp.i76.i
  %eq_m.i77.i = icmp eq i32 %bcmp.i76.fr.i, 0
  %t92.i18 = add i64 %64, 43
  %spec.select129.i = select i1 %eq_m.i77.i, i64 %t92.i18, i64 %64
  br label %cmp_long.i88.i

cmp_long.i88.i:                                   ; preds = %archx_str_eq.exit80.i, %archx_str_eq.exit80.thread.i
  %.ph.i = phi i64 [ %t92111.i, %archx_str_eq.exit80.thread.i ], [ %spec.select129.i, %archx_str_eq.exit80.i ]
  %same_ptr.i90.i = icmp eq i64 %ap_i.i70.i, ptrtoint (ptr @.str.2 to i64)
  br i1 %same_ptr.i90.i, label %archx_str_eq.exit99.thread.i, label %archx_str_eq.exit99.i

archx_str_eq.exit99.thread.i:                     ; preds = %cmp_long.i88.i
  %t99120.i = add i64 %.ph.i, 99
  br label %archx_str_eq.exit99.thread123.i

archx_str_eq.exit99.i:                            ; preds = %cmp_long.i88.i
  %ap.i92.i = inttoptr i64 %ap_i.i70.i to ptr
  %ap4.i93.i = getelementptr inbounds nuw i8, ptr %ap.i92.i, i64 4
  %bcmp.i95.i = tail call i32 @bcmp(ptr noundef nonnull dereferenceable(22) %ap4.i93.i, ptr noundef nonnull dereferenceable(22) getelementptr inbounds nuw (i8, ptr @.str.2, i64 4), i64 22)
  %bcmp.i95.fr.i = freeze i32 %bcmp.i95.i
  %eq_m.i96.i = icmp eq i32 %bcmp.i95.fr.i, 0
  %t99.i19 = add i64 %.ph.i, 99
  %spec.select130.i = select i1 %eq_m.i96.i, i64 %t99.i19, i64 %.ph.i
  br label %archx_str_eq.exit99.thread123.i

archx_str_eq.exit99.thread123.i:                  ; preds = %archx_str_eq.exit99.i, %archx_str_eq.exit99.thread.i, %div.ok.13.i
  %65 = phi i64 [ %t99120.i, %archx_str_eq.exit99.thread.i ], [ %64, %div.ok.13.i ], [ %spec.select130.i, %archx_str_eq.exit99.i ]
  %t105.i11 = and i64 %t69.fca.0.extract.i, 4294967295
  %t109.i12 = and i64 %newret, 4294967295
  %t102.i13 = add nsw i64 %t105.i11, %var.total.0.0133.i
  %t106.i = add nsw i64 %t102.i13, %t109.i12
  %t110.i14 = add i64 %t106.i, %65
  %t111.i = srem i64 %t110.i14, 1000000007
  %long.i.i = icmp samesign ult i64 %t105.i11, 13
  %tag.i.i = and i64 %aw1.i.i, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond.i = or i1 %long.i.i, %owned.not.i.i
  br i1 %or.cond.i, label %archx_str_drop.exit.i, label %do_free.i.i

do_free.i.i:                                      ; preds = %archx_str_eq.exit99.thread123.i
  %raw.i.i = and i64 %aw1.i.i, -2
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  tail call void @free(ptr %ptr.i.i)
  br label %archx_str_drop.exit.i

archx_str_drop.exit.i:                            ; preds = %do_free.i.i, %archx_str_eq.exit99.thread123.i
  %long.i48.i = icmp samesign ult i64 %t109.i12, 13
  %tag.i51.i = and i64 %newret20, 1
  %owned.not.i52.i = icmp eq i64 %tag.i51.i, 0
  %or.cond = select i1 %long.i48.i, i1 true, i1 %owned.not.i52.i
  br i1 %or.cond, label %archx_str_drop.exit56.i, label %do_free.i53.i

do_free.i53.i:                                    ; preds = %archx_str_drop.exit.i
  %raw.i54.i = and i64 %newret20, -2
  %ptr.i55.i = inttoptr i64 %raw.i54.i to ptr
  tail call void @free(ptr %ptr.i55.i)
  br label %archx_str_drop.exit56.i

archx_str_drop.exit56.i:                          ; preds = %do_free.i53.i, %archx_str_drop.exit.i
  store ptr null, ptr %.fca.3.gep.i, align 8
  %t119.i15 = add nuw nsw i64 %for.r.1.0132.i, 1
  %exitcond.not.i16 = icmp eq i64 %t119.i15, 40000
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %func.region.i, i8 0, i64 16, i1 false)
  br i1 %exitcond.not.i16, label %for.end.3.i, label %check_reuse.i.i

for.end.3.i:                                      ; preds = %archx_str_drop.exit56.i
  %t122.i17 = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i100.i = icmp eq ptr %t122.i17, null
  br i1 %empty.i100.i, label %archx_fn_arena_and_strings.exit, label %loop.i101.i

loop.i101.i:                                      ; preds = %for.end.3.i, %loop.i101.i
  %cur.i102.i = phi ptr [ %next.i103.i, %loop.i101.i ], [ %t122.i17, %for.end.3.i ]
  %next.i103.i = load ptr, ptr %cur.i102.i, align 8
  tail call void @free(ptr nonnull %cur.i102.i)
  %more.not.i104.i = icmp eq ptr %next.i103.i, null
  br i1 %more.not.i104.i, label %archx_fn_arena_and_strings.exit, label %loop.i101.i

archx_fn_arena_and_strings.exit:                  ; preds = %loop.i101.i, %for.end.3.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  %t3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t111.i)
  ret i32 0
}

; Function Attrs: nofree noinline nounwind
define private fastcc noalias nonnull align 16 ptr @archx_region_alloc_slow(ptr nonnull captures(none) %reg, i64 range(i64 16, 2147483663) %aligned) unnamed_addr #1 {
entry:
  %body_sz = tail call i64 @llvm.umax.i64(i64 %aligned, i64 65536)
  %tot = add nuw nsw i64 %body_sz, 16
  %blk = tail call noalias align 16 ptr @malloc(i64 %tot)
  %isnull = icmp eq ptr %blk, null
  br i1 %isnull, label %oom, label %ok

oom:                                              ; preds = %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

ok:                                               ; preds = %entry
  store ptr null, ptr %blk, align 16
  %cap_ptr = getelementptr inbounds nuw i8, ptr %blk, i64 8
  store i64 %body_sz, ptr %cap_ptr, align 8
  %tail_slot = getelementptr inbounds nuw i8, ptr %reg, i64 24
  %old_tail = load ptr, ptr %tail_slot, align 8
  %has_tail.not = icmp eq ptr %old_tail, null
  br i1 %has_tail.not, label %link_head, label %link_tail

link_tail:                                        ; preds = %ok
  store ptr %blk, ptr %old_tail, align 8
  br label %finish

link_head:                                        ; preds = %ok
  %head_slot = getelementptr inbounds nuw i8, ptr %reg, i64 16
  store ptr %blk, ptr %head_slot, align 8
  br label %finish

finish:                                           ; preds = %link_head, %link_tail
  store ptr %blk, ptr %tail_slot, align 8
  %data = getelementptr inbounds nuw i8, ptr %blk, i64 16
  %new_cur = getelementptr inbounds nuw i8, ptr %data, i64 %aligned
  %new_end = getelementptr inbounds nuw i8, ptr %data, i64 %body_sz
  %end_slot = getelementptr inbounds nuw i8, ptr %reg, i64 8
  store ptr %new_cur, ptr %reg, align 8
  store ptr %new_end, ptr %end_slot, align 8
  ret ptr %data
}

; Function Attrs: nounwind
define private fastcc { i64, i64 } @archx_str_concat(%ArchxStr %a, %ArchxStr %b, ptr nonnull captures(none) %reg) unnamed_addr #0 {
entry:
  %atmp = alloca [12 x i8], align 4
  %btmp = alloca [12 x i8], align 4
  %out_sso = alloca [16 x i8], align 8
  %aw0 = extractvalue %ArchxStr %a, 0
  %aw1 = extractvalue %ArchxStr %a, 1
  %bw0 = extractvalue %ArchxStr %b, 0
  %bw1 = extractvalue %ArchxStr %b, 1
  %alen = and i64 %aw0, 4294967295
  %blen = and i64 %bw0, 4294967295
  %az = icmp eq i64 %alen, 0
  br i1 %az, label %ret_b, label %chk_bz

ret_b:                                            ; preds = %entry
  %bw1_tag = and i64 %bw1, 1
  %b_owned.not = icmp ne i64 %bw1_tag, 0
  %long.i = icmp samesign ugt i64 %blen, 12
  %or.cond = select i1 %b_owned.not, i1 %long.i, i1 false
  br i1 %or.cond, label %dup_heap.i, label %common.ret

common.ret:                                       ; preds = %copy.i14, %copy.i, %ret_a, %ret_b, %archx_region_alloc.exit, %build_sso
  %common.ret.op = phi %ArchxStr [ %rs1, %build_sso ], [ %ls1, %archx_region_alloc.exit ], [ %b, %ret_b ], [ %a, %ret_a ], [ %out.i, %copy.i ], [ %out.i19, %copy.i14 ]
  %oldret = extractvalue %ArchxStr %common.ret.op, 0
  %newret = insertvalue { i64, i64 } poison, i64 %oldret, 0
  %oldret1 = extractvalue %ArchxStr %common.ret.op, 1
  %newret2 = insertvalue { i64, i64 } %newret, i64 %oldret1, 1
  ret { i64, i64 } %newret2

dup_heap.i:                                       ; preds = %ret_b
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %blen)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i, label %copy.i

oom.i:                                            ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %bw1, -2
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 2 %src.i, i64 %blen, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %out.i = insertvalue %ArchxStr %b, i64 %tagged.i, 1
  br label %common.ret

chk_bz:                                           ; preds = %entry
  %bz = icmp eq i64 %blen, 0
  br i1 %bz, label %ret_a, label %calc_tot

ret_a:                                            ; preds = %chk_bz
  %aw1_tag = and i64 %aw1, 1
  %a_owned.not = icmp ne i64 %aw1_tag, 0
  %long.i5 = icmp samesign ugt i64 %alen, 12
  %or.cond24 = select i1 %a_owned.not, i1 %long.i5, i1 false
  br i1 %or.cond24, label %dup_heap.i11, label %common.ret

dup_heap.i11:                                     ; preds = %ret_a
  %dst.i12 = tail call noalias align 16 ptr @malloc(i64 %alen)
  %isnull.i13 = icmp eq ptr %dst.i12, null
  br i1 %isnull.i13, label %oom.i20, label %copy.i14

oom.i20:                                          ; preds = %dup_heap.i11
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i14:                                         ; preds = %dup_heap.i11
  %src_i.i15 = and i64 %aw1, -2
  %src.i16 = inttoptr i64 %src_i.i15 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i12, ptr nonnull align 2 %src.i16, i64 %alen, i1 false)
  %dst_i.i17 = ptrtoint ptr %dst.i12 to i64
  %tagged.i18 = or disjoint i64 %dst_i.i17, 1
  %out.i19 = insertvalue %ArchxStr %a, i64 %tagged.i18, 1
  br label %common.ret

calc_tot:                                         ; preds = %chk_bz
  %tot = add nuw nsw i64 %blen, %alen
  %too_big = icmp samesign ugt i64 %tot, 2147483647
  br i1 %too_big, label %oom, label %mat_a

oom:                                              ; preds = %calc_tot
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a:                                            ; preds = %calc_tot
  %ashort = icmp samesign ult i64 %alen, 13
  br i1 %ashort, label %mat_a_short, label %mat_a_long

mat_a_short:                                      ; preds = %mat_a
  %ap4 = lshr i64 %aw0, 32
  %ap4_32 = trunc nuw nsw i64 %ap4 to i32
  store i32 %ap4_32, ptr %atmp, align 4
  %atmp4 = getelementptr inbounds nuw i8, ptr %atmp, i64 4
  store i64 %aw1, ptr %atmp4, align 4
  br label %mat_b

mat_a_long:                                       ; preds = %mat_a
  %araw = and i64 %aw1, -4
  %alptr = inttoptr i64 %araw to ptr
  br label %mat_b

mat_b:                                            ; preds = %mat_a_long, %mat_a_short
  %aptr = phi ptr [ %atmp, %mat_a_short ], [ %alptr, %mat_a_long ]
  %bshort = icmp samesign ult i64 %blen, 13
  br i1 %bshort, label %mat_b_short, label %mat_b_long

mat_b_short:                                      ; preds = %mat_b
  %bp4 = lshr i64 %bw0, 32
  %bp4_32 = trunc nuw nsw i64 %bp4 to i32
  store i32 %bp4_32, ptr %btmp, align 4
  %btmp4 = getelementptr inbounds nuw i8, ptr %btmp, i64 4
  store i64 %bw1, ptr %btmp4, align 4
  br label %build

mat_b_long:                                       ; preds = %mat_b
  %braw = and i64 %bw1, -4
  %blptr = inttoptr i64 %braw to ptr
  br label %build

build:                                            ; preds = %mat_b_long, %mat_b_short
  %bptr = phi ptr [ %btmp, %mat_b_short ], [ %blptr, %mat_b_long ]
  %fits_sso = icmp samesign ult i64 %tot, 13
  br i1 %fits_sso, label %build_sso, label %alloc_reg

build_sso:                                        ; preds = %build
  %out_sso8 = getelementptr inbounds nuw i8, ptr %out_sso, i64 8
  %tot32 = trunc nuw nsw i64 %tot to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso, i8 0, i64 16, i1 false)
  store i32 %tot32, ptr %out_sso, align 8
  %sso_dst_a = getelementptr inbounds nuw i8, ptr %out_sso, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a, ptr nonnull align 1 %aptr, i64 %alen, i1 false)
  %sso_dst_b = getelementptr inbounds nuw i8, ptr %sso_dst_a, i64 %alen
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b, ptr nonnull align 1 %bptr, i64 %blen, i1 false)
  %rw0 = load i64, ptr %out_sso, align 8
  %rw1 = load i64, ptr %out_sso8, align 8
  %rs0 = insertvalue %ArchxStr poison, i64 %rw0, 0
  %rs1 = insertvalue %ArchxStr %rs0, i64 %rw1, 1
  br label %common.ret

alloc_reg:                                        ; preds = %build
  %a1.i = add nuw nsw i64 %tot, 15
  %aligned.i = and i64 %a1.i, 4294967280
  %end_slot.i = getelementptr inbounds nuw i8, ptr %reg, i64 8
  %cur.i = load ptr, ptr %reg, align 8
  %end.i = load ptr, ptr %end_slot.i, align 8
  %cur_i.i = ptrtoint ptr %cur.i to i64
  %end_i.i = ptrtoint ptr %end.i to i64
  %rem.i = sub i64 %end_i.i, %cur_i.i
  %fits.not.i = icmp slt i64 %rem.i, %aligned.i
  br i1 %fits.not.i, label %check_reuse.i, label %fast.i

fast.i:                                           ; preds = %alloc_reg
  %next.i = getelementptr inbounds nuw i8, ptr %cur.i, i64 %aligned.i
  store ptr %next.i, ptr %reg, align 8
  br label %archx_region_alloc.exit

check_reuse.i:                                    ; preds = %alloc_reg
  %tail_slot.i = getelementptr inbounds nuw i8, ptr %reg, i64 24
  %tail.i = load ptr, ptr %tail_slot.i, align 8
  %has_tail.not.i = icmp eq ptr %tail.i, null
  %head_slot.i = getelementptr inbounds nuw i8, ptr %reg, i64 16
  %cand.in.i = select i1 %has_tail.not.i, ptr %head_slot.i, ptr %tail.i
  %cand.i = load ptr, ptr %cand.in.i, align 8
  %has_cand.not.i = icmp eq ptr %cand.i, null
  br i1 %has_cand.not.i, label %slow.i, label %check_cand_cap.i

check_cand_cap.i:                                 ; preds = %check_reuse.i
  %ccap_ptr.i = getelementptr inbounds nuw i8, ptr %cand.i, i64 8
  %ccap.i = load i64, ptr %ccap_ptr.i, align 8
  %cfits.not.i = icmp slt i64 %ccap.i, %aligned.i
  br i1 %cfits.not.i, label %drop_stale_chain.i, label %reuse_cand.i

reuse_cand.i:                                     ; preds = %check_cand_cap.i
  store ptr %cand.i, ptr %tail_slot.i, align 8
  %cdata.i = getelementptr inbounds nuw i8, ptr %cand.i, i64 16
  %ccur.i = getelementptr inbounds nuw i8, ptr %cdata.i, i64 %aligned.i
  %cend.i = getelementptr inbounds nuw i8, ptr %cdata.i, i64 %ccap.i
  store ptr %ccur.i, ptr %reg, align 8
  store ptr %cend.i, ptr %end_slot.i, align 8
  br label %archx_region_alloc.exit

drop_stale_chain.i:                               ; preds = %check_cand_cap.i
  br i1 %has_tail.not.i, label %unlink_from_head.i, label %unlink_from_tail.i

unlink_from_tail.i:                               ; preds = %drop_stale_chain.i
  store ptr null, ptr %tail.i, align 8
  br label %loop.i.preheader

unlink_from_head.i:                               ; preds = %drop_stale_chain.i
  store ptr null, ptr %head_slot.i, align 8
  br label %loop.i.preheader

loop.i.preheader:                                 ; preds = %unlink_from_head.i, %unlink_from_tail.i
  br label %loop.i

loop.i:                                           ; preds = %loop.i.preheader, %loop.i
  %cur.i22 = phi ptr [ %next.i23, %loop.i ], [ %cand.i, %loop.i.preheader ]
  %next.i23 = load ptr, ptr %cur.i22, align 8
  tail call void @free(ptr nonnull %cur.i22)
  %more.not.i = icmp eq ptr %next.i23, null
  br i1 %more.not.i, label %slow.i, label %loop.i

slow.i:                                           ; preds = %loop.i, %check_reuse.i
  %res.i = tail call fastcc nonnull align 16 ptr @archx_region_alloc_slow(ptr nonnull %reg, i64 %aligned.i)
  br label %archx_region_alloc.exit

archx_region_alloc.exit:                          ; preds = %fast.i, %reuse_cand.i, %slow.i
  %common.ret.op.i = phi ptr [ %cur.i, %fast.i ], [ %cdata.i, %reuse_cand.i ], [ %res.i, %slow.i ]
  %rp_i = ptrtoint ptr %common.ret.op.i to i64
  %rtagged = or disjoint i64 %rp_i, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i, ptr nonnull align 1 %aptr, i64 %alen, i1 false)
  %dst_b = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 %alen
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b, ptr nonnull align 1 %bptr, i64 %blen, i1 false)
  %pref32 = load i32, ptr %common.ret.op.i, align 16
  %pref64 = zext i32 %pref32 to i64
  %pref_sh = shl nuw i64 %pref64, 32
  %w0_out = or disjoint i64 %pref_sh, %tot
  %ls0 = insertvalue %ArchxStr poison, i64 %w0_out, 0
  %ls1 = insertvalue %ArchxStr %ls0, i64 %rtagged, 1
  br label %common.ret
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_oom_fail() unnamed_addr #2 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #3

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #4

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #5

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #7

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #8

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #9

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @bcmp(ptr captures(none), ptr captures(none), i64) local_unnamed_addr #10

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #11

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #11

attributes #0 = { nounwind }
attributes #1 = { nofree noinline nounwind }
attributes #2 = { cold nofree noreturn nounwind }
attributes #3 = { nofree nounwind }
attributes #4 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #5 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #6 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #7 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #8 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #9 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #10 = { nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #11 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.isvectorized", i32 1}
!2 = !{!"llvm.loop.unroll.runtime.disable"}
!3 = distinct !{!3, !1, !2}
!4 = distinct !{!4, !1, !2}
!5 = distinct !{!5, !1, !2}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.unroll.disable"}
