; ModuleID = '/tmp/bench_composite.ll'
source_filename = "/tmp/bench_composite.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxRegion = type { ptr, ptr, ptr, ptr }

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.0 = private unnamed_addr constant [15 x i8] c"packet_header_\00", align 4
@.str.1 = private unnamed_addr constant [27 x i8] c"packet_header_payload_v2_a\00", align 4
@.str.2 = private unnamed_addr constant [27 x i8] c"packet_header_never_match!\00", align 4
@str = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %btmp.i.i = alloca [12 x i8], align 4
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
  br i1 %t27.i, label %alloc.oom.14.i, label %vector.body38

vector.body38:                                    ; preds = %fill.end.12.i, %vector.body38
  %index39 = phi i64 [ %index.next40.4, %vector.body38 ], [ 0, %fill.end.12.i ]
  %15 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index39
  %16 = getelementptr inbounds nuw i8, ptr %15, i64 16
  store <2 x i64> splat (i64 2), ptr %15, align 16
  store <2 x i64> splat (i64 2), ptr %16, align 16
  %17 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index39
  %18 = getelementptr inbounds nuw i8, ptr %17, i64 32
  %19 = getelementptr inbounds nuw i8, ptr %17, i64 48
  store <2 x i64> splat (i64 2), ptr %18, align 16
  store <2 x i64> splat (i64 2), ptr %19, align 16
  %20 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index39
  %21 = getelementptr inbounds nuw i8, ptr %20, i64 64
  %22 = getelementptr inbounds nuw i8, ptr %20, i64 80
  store <2 x i64> splat (i64 2), ptr %21, align 16
  store <2 x i64> splat (i64 2), ptr %22, align 16
  %23 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index39
  %24 = getelementptr inbounds nuw i8, ptr %23, i64 96
  %25 = getelementptr inbounds nuw i8, ptr %23, i64 112
  store <2 x i64> splat (i64 2), ptr %24, align 16
  store <2 x i64> splat (i64 2), ptr %25, align 16
  %26 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index39
  %27 = getelementptr inbounds nuw i8, ptr %26, i64 128
  %28 = getelementptr inbounds nuw i8, ptr %26, i64 144
  store <2 x i64> splat (i64 2), ptr %27, align 16
  store <2 x i64> splat (i64 2), ptr %28, align 16
  %index.next40.4 = add nuw nsw i64 %index39, 20
  %29 = icmp eq i64 %index.next40.4, 100000
  br i1 %29, label %fill.end.17.i, label %vector.body38, !llvm.loop !3

alloc.oom.14.i:                                   ; preds = %fill.end.12.i
  tail call fastcc void @archx_oom_fail()
  unreachable

fill.end.17.i:                                    ; preds = %vector.body38
  %t36.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @malloc(i64 800000)
  %t37.i = icmp eq ptr %t36.i, null
  br i1 %t37.i, label %alloc.oom.19.i, label %vector.body45

vector.body45:                                    ; preds = %fill.end.17.i, %vector.body45
  %index46 = phi i64 [ %index.next47.4, %vector.body45 ], [ 0, %fill.end.17.i ]
  %30 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index46
  %31 = getelementptr inbounds nuw i8, ptr %30, i64 16
  store <2 x i64> splat (i64 3), ptr %30, align 16
  store <2 x i64> splat (i64 3), ptr %31, align 16
  %32 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index46
  %33 = getelementptr inbounds nuw i8, ptr %32, i64 32
  %34 = getelementptr inbounds nuw i8, ptr %32, i64 48
  store <2 x i64> splat (i64 3), ptr %33, align 16
  store <2 x i64> splat (i64 3), ptr %34, align 16
  %35 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index46
  %36 = getelementptr inbounds nuw i8, ptr %35, i64 64
  %37 = getelementptr inbounds nuw i8, ptr %35, i64 80
  store <2 x i64> splat (i64 3), ptr %36, align 16
  store <2 x i64> splat (i64 3), ptr %37, align 16
  %38 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index46
  %39 = getelementptr inbounds nuw i8, ptr %38, i64 96
  %40 = getelementptr inbounds nuw i8, ptr %38, i64 112
  store <2 x i64> splat (i64 3), ptr %39, align 16
  store <2 x i64> splat (i64 3), ptr %40, align 16
  %41 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index46
  %42 = getelementptr inbounds nuw i8, ptr %41, i64 128
  %43 = getelementptr inbounds nuw i8, ptr %41, i64 144
  store <2 x i64> splat (i64 3), ptr %42, align 16
  store <2 x i64> splat (i64 3), ptr %43, align 16
  %index.next47.4 = add nuw nsw i64 %index46, 20
  %44 = icmp eq i64 %index.next47.4, 100000
  br i1 %44, label %for.body.24.i, label %vector.body45, !llvm.loop !4

alloc.oom.19.i:                                   ; preds = %fill.end.17.i
  tail call fastcc void @archx_oom_fail()
  unreachable

for.body.24.i:                                    ; preds = %vector.body45, %for.body.24.i
  %for.i.43.032.i = phi i64 [ %t74.i, %for.body.24.i ], [ 0, %vector.body45 ]
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
  br i1 %exitcond40.not.i, label %vector.ph51, label %for.body.24.i

vector.ph51:                                      ; preds = %for.body.24.i, %for.step.29.i
  %for.t.75.035.i = phi i64 [ %t114.i, %for.step.29.i ], [ 0, %for.body.24.i ]
  br label %vector.body52

vector.body52:                                    ; preds = %vector.body52, %vector.ph51
  %index53 = phi i64 [ 0, %vector.ph51 ], [ %index.next61, %vector.body52 ]
  %45 = getelementptr inbounds nuw i64, ptr %t3.i, i64 %index53
  %46 = getelementptr inbounds nuw i8, ptr %45, i64 16
  %wide.load = load <2 x i64>, ptr %45, align 16
  %wide.load54 = load <2 x i64>, ptr %46, align 16
  %47 = getelementptr inbounds nuw i64, ptr %t16.i, i64 %index53
  %48 = getelementptr inbounds nuw i8, ptr %47, i64 16
  %wide.load55 = load <2 x i64>, ptr %47, align 16
  %wide.load56 = load <2 x i64>, ptr %48, align 16
  %49 = add <2 x i64> %wide.load55, %wide.load
  %50 = add <2 x i64> %wide.load56, %wide.load54
  store <2 x i64> %49, ptr %45, align 16
  store <2 x i64> %50, ptr %46, align 16
  %51 = getelementptr inbounds nuw i64, ptr %t7.i, i64 %index53
  %52 = getelementptr inbounds nuw i8, ptr %51, i64 16
  %wide.load57 = load <2 x i64>, ptr %51, align 16
  %wide.load58 = load <2 x i64>, ptr %52, align 16
  %53 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index53
  %54 = getelementptr inbounds nuw i8, ptr %53, i64 16
  %wide.load59 = load <2 x i64>, ptr %53, align 16
  %wide.load60 = load <2 x i64>, ptr %54, align 16
  %55 = sub <2 x i64> %wide.load57, %wide.load59
  %56 = sub <2 x i64> %wide.load58, %wide.load60
  store <2 x i64> %55, ptr %51, align 16
  store <2 x i64> %56, ptr %52, align 16
  %index.next61 = add nuw i64 %index53, 4
  %57 = icmp eq i64 %index.next61, 100000
  br i1 %57, label %for.body.36.preheader.i, label %vector.body52, !llvm.loop !5

for.body.36.preheader.i:                          ; preds = %vector.body52
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
  br i1 %exitcond42.not.i, label %foreach.body.40.i, label %vector.ph51

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
  %btmp.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %btmp.i.i, i64 4
  %btmp.i.i.1.sroa_idx = getelementptr inbounds nuw i8, ptr %btmp.i.i, i64 1
  br label %for.body.1.i

for.body.1.i:                                     ; preds = %for.body.1.i.backedge, %archx_fn_particle_sim.exit
  %indvar = phi i4 [ %indvar.next, %for.body.1.i.backedge ], [ 0, %archx_fn_particle_sim.exit ]
  %end.i37.i = phi ptr [ %end.i37.i.be, %for.body.1.i.backedge ], [ null, %archx_fn_particle_sim.exit ]
  %cur.i.i = phi ptr [ %cur.i.i.be, %for.body.1.i.backedge ], [ null, %archx_fn_particle_sim.exit ]
  %var.total.0.0145.i = phi i64 [ %t106.i, %for.body.1.i.backedge ], [ 0, %archx_fn_particle_sim.exit ]
  %for.r.1.0144.i = phi i64 [ %for.r.1.0144.i.be, %for.body.1.i.backedge ], [ 0, %archx_fn_particle_sim.exit ]
  %58 = zext i4 %indvar to i64
  %59 = add nuw nsw i64 %58, 255
  %60 = lshr i64 %59, 2
  %61 = add nuw nsw i64 %60, 1
  %t5.i = and i64 %for.r.1.0144.i, 15
  %t6.i = or disjoint i64 %t5.i, 256
  %t8.i1 = shl nuw nsw i64 %t6.i, 3
  %a1.i.i = add nuw nsw i64 %t8.i1, 15
  %aligned.i.i = and i64 %a1.i.i, 2288
  %cur_i.i.i = ptrtoint ptr %cur.i.i to i64
  %end_i.i.i = ptrtoint ptr %end.i37.i to i64
  %rem.i.i = sub i64 %end_i.i.i, %cur_i.i.i
  %fits.not.i.i = icmp slt i64 %rem.i.i, %aligned.i.i
  br i1 %fits.not.i.i, label %fallback.i.i, label %fast.i.i

fast.i.i:                                         ; preds = %for.body.1.i
  %next.i.i = getelementptr inbounds nuw i8, ptr %cur.i.i, i64 %aligned.i.i
  store ptr %next.i.i, ptr %func.region.i, align 8
  br label %archx_region_alloc.exit.i

fallback.i.i:                                     ; preds = %for.body.1.i
  %res.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 %aligned.i.i)
  br label %archx_region_alloc.exit.i

archx_region_alloc.exit.i:                        ; preds = %fallback.i.i, %fast.i.i
  %common.ret.op.i.i = phi ptr [ %cur.i.i, %fast.i.i ], [ %res.i.i, %fallback.i.i ]
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %common.ret.op.i.i, i8 0, i64 %t8.i1, i1 false)
  %xtraiter = and i64 %61, 3
  %unroll_iter = and i64 %61, 252
  br label %for.body.9.i

for.body.9.i:                                     ; preds = %for.body.9.i, %archx_region_alloc.exit.i
  %for.k.19.0143.i = phi i64 [ 0, %archx_region_alloc.exit.i ], [ %t30.i3.3, %for.body.9.i ]
  %niter = phi i64 [ 0, %archx_region_alloc.exit.i ], [ %niter.next.3, %for.body.9.i ]
  %t24.i = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %for.k.19.0143.i
  %t27.i2 = mul nuw nsw i64 %for.k.19.0143.i, 3
  %t28.i = add nuw nsw i64 %t27.i2, %for.r.1.0144.i
  store i64 %t28.i, ptr %t24.i, align 8
  %t30.i3 = or disjoint i64 %for.k.19.0143.i, 4
  %t24.i.1 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t30.i3
  %t27.i2.1 = mul nuw nsw i64 %t30.i3, 3
  %t28.i.1 = add nuw nsw i64 %t27.i2.1, %for.r.1.0144.i
  store i64 %t28.i.1, ptr %t24.i.1, align 8
  %t30.i3.1 = or disjoint i64 %for.k.19.0143.i, 8
  %t24.i.2 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t30.i3.1
  %t27.i2.2 = mul nuw nsw i64 %t30.i3.1, 3
  %t28.i.2 = add nuw nsw i64 %t27.i2.2, %for.r.1.0144.i
  store i64 %t28.i.2, ptr %t24.i.2, align 8
  %t30.i3.2 = or disjoint i64 %for.k.19.0143.i, 12
  %t24.i.3 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t30.i3.2
  %t27.i2.3 = mul nuw nsw i64 %t30.i3.2, 3
  %t28.i.3 = add nuw nsw i64 %t27.i2.3, %for.r.1.0144.i
  store i64 %t28.i.3, ptr %t24.i.3, align 8
  %t30.i3.3 = add nuw nsw i64 %for.k.19.0143.i, 16
  %niter.next.3 = add nuw nsw i64 %niter, 4
  %niter.ncmp.3.not = icmp eq i64 %niter.next.3, %unroll_iter
  br i1 %niter.ncmp.3.not, label %div.ok.13.i.unr-lcssa, label %for.body.9.i

div.ok.13.i.unr-lcssa:                            ; preds = %for.body.9.i
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %div.ok.13.i, label %for.body.9.i.epil

for.body.9.i.epil:                                ; preds = %div.ok.13.i.unr-lcssa, %for.body.9.i.epil
  %for.k.19.0143.i.epil = phi i64 [ %t30.i3.epil, %for.body.9.i.epil ], [ %t30.i3.3, %div.ok.13.i.unr-lcssa ]
  %epil.iter = phi i64 [ %epil.iter.next, %for.body.9.i.epil ], [ 0, %div.ok.13.i.unr-lcssa ]
  %t24.i.epil = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %for.k.19.0143.i.epil
  %t27.i2.epil = mul nuw nsw i64 %for.k.19.0143.i.epil, 3
  %t28.i.epil = add nuw nsw i64 %t27.i2.epil, %for.r.1.0144.i
  store i64 %t28.i.epil, ptr %t24.i.epil, align 8
  %t30.i3.epil = add nuw nsw i64 %for.k.19.0143.i.epil, 4
  %epil.iter.next = add i64 %epil.iter, 1
  %epil.iter.cmp.not = icmp eq i64 %epil.iter.next, %xtraiter
  br i1 %epil.iter.cmp.not, label %div.ok.13.i, label %for.body.9.i.epil, !llvm.loop !6

div.ok.13.i:                                      ; preds = %for.body.9.i.epil, %div.ok.13.i.unr-lcssa
  %t32.i = mul nuw nsw i64 %for.r.1.0144.i, 7
  %t38.i = urem i64 %t32.i, %t6.i
  %t43.i = load i64, ptr %common.ret.op.i.i, align 8
  %t47.i5 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t38.i
  %t48.i = load i64, ptr %t47.i5, align 8
  %t49.i6 = add i64 %t48.i, %t43.i
  %62 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t5.i
  %t54.i = getelementptr inbounds nuw i8, ptr %62, i64 2040
  %t55.i7 = load i64, ptr %t54.i, align 8
  %t56.i = add i64 %t49.i6, %t55.i7
  %t60.i = and i64 %for.r.1.0144.i, 1
  %t61.i = icmp eq i64 %t60.i, 0
  %spec.select.i = select i1 %t61.i, i64 12385, i64 14649
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i.i)
  %bp4_32.i.i = select i1 %t61.i, i32 1752198241, i32 1635018082
  store i32 %bp4_32.i.i, ptr %btmp.i.i, align 4
  store i64 %spec.select.i, ptr %btmp.i.i.4.sroa_idx, align 4
  %btmp.i.i.1.btmp.i.i.1.btmp.i.i.1.btmp.i.1.btmp.i.1.out_sso.i.sroa.7.7.copyload.i = load i40, ptr %btmp.i.i.1.sroa_idx, align 1
  %btmp.i.1.out_sso.i.sroa.7.7.copyload.fr.i = freeze i40 %btmp.i.i.1.btmp.i.i.1.btmp.i.i.1.btmp.i.1.btmp.i.1.out_sso.i.sroa.7.7.copyload.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i.i)
  %t68.i = and i64 %for.r.1.0144.i, 3
  %t69.i8 = icmp eq i64 %t68.i, 0
  %var.l_rhs.66.sroa.5.0.i = select i1 %t69.i8, i64 7016382228454465903, i64 7088494763882274674
  %bp4_32.i113.i = select i1 %t69.i8, i32 1819894128, i32 1701344367
  %cur.i.i.i = load ptr, ptr %func.region.i, align 8
  %end.i.i.i = load ptr, ptr %.fca.1.gep.i, align 8
  %cur_i.i.i.i = ptrtoint ptr %cur.i.i.i to i64
  %end_i.i.i.i = ptrtoint ptr %end.i.i.i to i64
  %rem.i.i.i = sub i64 %end_i.i.i.i, %cur_i.i.i.i
  %fits.not.i.i.i = icmp slt i64 %rem.i.i.i, 32
  br i1 %fits.not.i.i.i, label %fallback.i.i.i, label %fast.i.i.i

fast.i.i.i:                                       ; preds = %div.ok.13.i
  %next.i.i.i = getelementptr inbounds nuw i8, ptr %cur.i.i.i, i64 32
  store ptr %next.i.i.i, ptr %func.region.i, align 8
  br label %cmp_long.i69.i

fallback.i.i.i:                                   ; preds = %div.ok.13.i
  %res.i.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 32)
  %.pre.i = ptrtoint ptr %res.i.i.i to i64
  br label %cmp_long.i69.i

cmp_long.i69.i:                                   ; preds = %fallback.i.i.i, %fast.i.i.i
  %rp_i.i.pre-phi.i = phi i64 [ %cur_i.i.i.i, %fast.i.i.i ], [ %.pre.i, %fallback.i.i.i ]
  %common.ret.op.i.i.i = phi ptr [ %cur.i.i.i, %fast.i.i.i ], [ %res.i.i.i, %fallback.i.i.i ]
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(14) %common.ret.op.i.i.i, ptr noundef nonnull align 4 dereferenceable(14) @.str.0, i64 14, i1 false)
  %dst_b.i.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i.i, i64 14
  store i32 %bp4_32.i113.i, ptr %dst_b.i.i, align 1
  %btmp.i102.sroa.4.0.dst_b.i.sroa_idx.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i.i, i64 18
  store i64 %var.l_rhs.66.sroa.5.0.i, ptr %btmp.i102.sroa.4.0.dst_b.i.sroa_idx.i, align 1
  %63 = and i32 %bp4_32.i.i, 99
  %w0_eq.i.i = icmp eq i32 %63, 97
  %eq_s.i.i = icmp eq i40 %btmp.i.1.out_sso.i.sroa.7.7.copyload.fr.i, 207792664684
  %t80.i9 = add i64 %t56.i, 17
  %64 = and i1 %w0_eq.i.i, %eq_s.i.i
  %65 = select i1 %64, i64 %t80.i9, i64 %t56.i
  %ap_i.i70.i = and i64 %rp_i.i.pre-phi.i, -4
  %same_ptr.i71.i = icmp eq i64 %ap_i.i70.i, ptrtoint (ptr @.str.1 to i64)
  br i1 %same_ptr.i71.i, label %archx_str_eq.exit80.thread.i, label %archx_str_eq.exit80.i

archx_str_eq.exit80.thread.i:                     ; preds = %cmp_long.i69.i
  %t87123.i = add i64 %65, 43
  br label %cmp_long.i88.i

archx_str_eq.exit80.i:                            ; preds = %cmp_long.i69.i
  %ap.i73.i = inttoptr i64 %ap_i.i70.i to ptr
  %ap4.i74.i = getelementptr inbounds nuw i8, ptr %ap.i73.i, i64 4
  %bcmp.i76.i = tail call i32 @bcmp(ptr noundef nonnull dereferenceable(22) %ap4.i74.i, ptr noundef nonnull dereferenceable(22) getelementptr inbounds nuw (i8, ptr @.str.1, i64 4), i64 22)
  %bcmp.i76.fr.i = freeze i32 %bcmp.i76.i
  %eq_m.i77.i = icmp eq i32 %bcmp.i76.fr.i, 0
  %t87.i = add i64 %65, 43
  %spec.select141.i = select i1 %eq_m.i77.i, i64 %t87.i, i64 %65
  br label %cmp_long.i88.i

cmp_long.i88.i:                                   ; preds = %archx_str_eq.exit80.i, %archx_str_eq.exit80.thread.i
  %.ph.i = phi i64 [ %t87123.i, %archx_str_eq.exit80.thread.i ], [ %spec.select141.i, %archx_str_eq.exit80.i ]
  %same_ptr.i90.i = icmp eq i64 %ap_i.i70.i, ptrtoint (ptr @.str.2 to i64)
  br i1 %same_ptr.i90.i, label %archx_str_eq.exit99.thread.i, label %archx_str_eq.exit99.i

archx_str_eq.exit99.thread.i:                     ; preds = %cmp_long.i88.i
  %t94132.i = add i64 %.ph.i, 99
  br label %archx_str_eq.exit99.thread135.i

archx_str_eq.exit99.i:                            ; preds = %cmp_long.i88.i
  %ap.i92.i = inttoptr i64 %ap_i.i70.i to ptr
  %ap4.i93.i = getelementptr inbounds nuw i8, ptr %ap.i92.i, i64 4
  %bcmp.i95.i = tail call i32 @bcmp(ptr noundef nonnull dereferenceable(22) %ap4.i93.i, ptr noundef nonnull dereferenceable(22) getelementptr inbounds nuw (i8, ptr @.str.2, i64 4), i64 22)
  %bcmp.i95.fr.i = freeze i32 %bcmp.i95.i
  %eq_m.i96.i = icmp eq i32 %bcmp.i95.fr.i, 0
  %t94.i = add i64 %.ph.i, 99
  %spec.select142.i = select i1 %eq_m.i96.i, i64 %t94.i, i64 %.ph.i
  br label %archx_str_eq.exit99.thread135.i

archx_str_eq.exit99.thread135.i:                  ; preds = %archx_str_eq.exit99.i, %archx_str_eq.exit99.thread.i
  %66 = phi i64 [ %t94132.i, %archx_str_eq.exit99.thread.i ], [ %spec.select142.i, %archx_str_eq.exit99.i ]
  %t97.i10 = add nsw i64 %var.total.0.0145.i, 35
  %t105.i11 = add i64 %t97.i10, %66
  %t106.i = srem i64 %t105.i11, 1000000007
  %tag.i53.i = and i64 %rp_i.i.pre-phi.i, 1
  %owned.not.i54.i = icmp eq i64 %tag.i53.i, 0
  br i1 %owned.not.i54.i, label %archx_str_drop.exit58.i, label %do_free.i55.i

do_free.i55.i:                                    ; preds = %archx_str_eq.exit99.thread135.i
  %raw.i56.i = or disjoint i64 %ap_i.i70.i, 2
  %ptr.i57.i = inttoptr i64 %raw.i56.i to ptr
  tail call void @free(ptr nonnull %ptr.i57.i)
  br label %archx_str_drop.exit58.i

archx_str_drop.exit58.i:                          ; preds = %do_free.i55.i, %archx_str_eq.exit99.thread135.i
  %head.i.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i.i = icmp eq ptr %head.i.i, null
  br i1 %empty.i.i, label %archx_region_rewind_root.exit.i, label %archx_region_rewind_root.exit.thread.i

archx_region_rewind_root.exit.i:                  ; preds = %archx_str_drop.exit58.i
  %t112.i12 = add nuw nsw i64 %for.r.1.0144.i, 1
  %exitcond.not.i13 = icmp eq i64 %t112.i12, 40000
  br i1 %exitcond.not.i13, label %archx_fn_arena_and_strings.exit, label %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge

archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge: ; preds = %archx_region_rewind_root.exit.i
  %cur.i.i.pre.pre = load ptr, ptr %func.region.i, align 8
  %end.i37.i.pre.pre = load ptr, ptr %.fca.1.gep.i, align 8
  br label %for.body.1.i.backedge

for.body.1.i.backedge:                            ; preds = %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge, %archx_region_rewind_root.exit.thread.i
  %end.i37.i.be = phi ptr [ %end.i37.i.pre.pre, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %end.i.i, %archx_region_rewind_root.exit.thread.i ]
  %cur.i.i.be = phi ptr [ %cur.i.i.pre.pre, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %data.i.i, %archx_region_rewind_root.exit.thread.i ]
  %for.r.1.0144.i.be = phi i64 [ %t112.i12, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %t112148.i, %archx_region_rewind_root.exit.thread.i ]
  %indvar.next = add i4 %indvar, 1
  br label %for.body.1.i

archx_region_rewind_root.exit.thread.i:           ; preds = %archx_str_drop.exit58.i
  %cap_ptr.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 8
  %cap.i.i = load i64, ptr %cap_ptr.i.i, align 8
  %data.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 16
  %end.i.i = getelementptr inbounds i8, ptr %data.i.i, i64 %cap.i.i
  store ptr %data.i.i, ptr %func.region.i, align 8
  store ptr %end.i.i, ptr %.fca.1.gep.i, align 8
  store ptr %head.i.i, ptr %.fca.3.gep.i, align 8
  %t112148.i = add nuw nsw i64 %for.r.1.0144.i, 1
  %exitcond.not149.i = icmp eq i64 %t112148.i, 40000
  br i1 %exitcond.not149.i, label %loop.i.i, label %for.body.1.i.backedge

loop.i.i:                                         ; preds = %archx_region_rewind_root.exit.thread.i, %loop.i.i
  %cur.i116.i = phi ptr [ %next.i117.i, %loop.i.i ], [ %head.i.i, %archx_region_rewind_root.exit.thread.i ]
  %next.i117.i = load ptr, ptr %cur.i116.i, align 8
  tail call void @free(ptr nonnull %cur.i116.i)
  %more.not.i.i = icmp eq ptr %next.i117.i, null
  br i1 %more.not.i.i, label %archx_fn_arena_and_strings.exit, label %loop.i.i

archx_fn_arena_and_strings.exit:                  ; preds = %archx_region_rewind_root.exit.i, %loop.i.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  %t3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t106.i)
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

; Function Attrs: noinline nounwind
define private fastcc noalias nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull captures(none) %reg, i64 range(i64 16, 2147483663) %aligned) unnamed_addr #2 {
entry:
  %end_slot = getelementptr inbounds nuw i8, ptr %reg, i64 8
  %tail_slot = getelementptr inbounds nuw i8, ptr %reg, i64 24
  %tail = load ptr, ptr %tail_slot, align 8
  %has_tail.not = icmp eq ptr %tail, null
  %head_slot = getelementptr inbounds nuw i8, ptr %reg, i64 16
  %cand.in = select i1 %has_tail.not, ptr %head_slot, ptr %tail
  %cand = load ptr, ptr %cand.in, align 8
  %has_cand.not = icmp eq ptr %cand, null
  br i1 %has_cand.not, label %slow, label %check_cand_cap

check_cand_cap:                                   ; preds = %entry
  %ccap_ptr = getelementptr inbounds nuw i8, ptr %cand, i64 8
  %ccap = load i64, ptr %ccap_ptr, align 8
  %cfits.not = icmp slt i64 %ccap, %aligned
  br i1 %cfits.not, label %drop_stale_chain, label %reuse_cand

common.ret:                                       ; preds = %slow, %reuse_cand
  %common.ret.op = phi ptr [ %cdata, %reuse_cand ], [ %res, %slow ]
  ret ptr %common.ret.op

reuse_cand:                                       ; preds = %check_cand_cap
  store ptr %cand, ptr %tail_slot, align 8
  %cdata = getelementptr inbounds nuw i8, ptr %cand, i64 16
  %ccur = getelementptr inbounds nuw i8, ptr %cdata, i64 %aligned
  %cend = getelementptr inbounds nuw i8, ptr %cdata, i64 %ccap
  store ptr %ccur, ptr %reg, align 8
  store ptr %cend, ptr %end_slot, align 8
  br label %common.ret

drop_stale_chain:                                 ; preds = %check_cand_cap
  br i1 %has_tail.not, label %unlink_from_head, label %unlink_from_tail

unlink_from_tail:                                 ; preds = %drop_stale_chain
  store ptr null, ptr %tail, align 8
  br label %loop.i.preheader

unlink_from_head:                                 ; preds = %drop_stale_chain
  store ptr null, ptr %head_slot, align 8
  br label %loop.i.preheader

loop.i.preheader:                                 ; preds = %unlink_from_head, %unlink_from_tail
  br label %loop.i

loop.i:                                           ; preds = %loop.i.preheader, %loop.i
  %cur.i = phi ptr [ %next.i, %loop.i ], [ %cand, %loop.i.preheader ]
  %next.i = load ptr, ptr %cur.i, align 8
  tail call void @free(ptr nonnull %cur.i)
  %more.not.i = icmp eq ptr %next.i, null
  br i1 %more.not.i, label %slow, label %loop.i

slow:                                             ; preds = %loop.i, %entry
  %res = tail call fastcc nonnull align 16 ptr @archx_region_alloc_slow(ptr %reg, i64 %aligned)
  br label %common.ret
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_oom_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #4

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #5

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #6

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #7

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #8

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #9

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #10

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @bcmp(ptr captures(none), ptr captures(none), i64) local_unnamed_addr #11

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #4

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #12

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #12

attributes #0 = { nounwind }
attributes #1 = { nofree noinline nounwind }
attributes #2 = { noinline nounwind }
attributes #3 = { cold nofree noreturn nounwind }
attributes #4 = { nofree nounwind }
attributes #5 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #6 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #7 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #8 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #9 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #10 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #11 = { nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #12 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.isvectorized", i32 1}
!2 = !{!"llvm.loop.unroll.runtime.disable"}
!3 = distinct !{!3, !1, !2}
!4 = distinct !{!4, !1, !2}
!5 = distinct !{!5, !1, !2}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.unroll.disable"}
