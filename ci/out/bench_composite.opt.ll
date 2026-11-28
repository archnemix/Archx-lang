; ModuleID = '/tmp/bench_composite.ll'
source_filename = "composite.archx.lang"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxRegion = type { ptr, ptr, ptr, ptr }

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.0 = private unnamed_addr constant [15 x i8] c"packet_header_\00", align 4
@.str.1 = private unnamed_addr constant [27 x i8] c"packet_header_payload_v2_a\00", align 4
@.str.2 = private unnamed_addr constant [27 x i8] c"packet_header_never_match!\00", align 4
@str = private unnamed_addr constant [38 x i8] c"archx runtime panic: integer overflow\00", align 1
@str.1 = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

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
  br i1 %14, label %fill.end.12.i, label %vector.body, !llvm.loop !3

alloc.oom.9.i:                                    ; preds = %calloc.ok.6.i
  tail call fastcc void @archx_oom_fail()
  unreachable

fill.end.12.i:                                    ; preds = %vector.body
  %t26.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @malloc(i64 800000)
  %t27.i = icmp eq ptr %t26.i, null
  br i1 %t27.i, label %alloc.oom.14.i, label %vector.body47

vector.body47:                                    ; preds = %fill.end.12.i, %vector.body47
  %index48 = phi i64 [ %index.next49.4, %vector.body47 ], [ 0, %fill.end.12.i ]
  %15 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index48
  %16 = getelementptr inbounds nuw i8, ptr %15, i64 16
  store <2 x i64> splat (i64 2), ptr %15, align 16
  store <2 x i64> splat (i64 2), ptr %16, align 16
  %17 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index48
  %18 = getelementptr inbounds nuw i8, ptr %17, i64 32
  %19 = getelementptr inbounds nuw i8, ptr %17, i64 48
  store <2 x i64> splat (i64 2), ptr %18, align 16
  store <2 x i64> splat (i64 2), ptr %19, align 16
  %20 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index48
  %21 = getelementptr inbounds nuw i8, ptr %20, i64 64
  %22 = getelementptr inbounds nuw i8, ptr %20, i64 80
  store <2 x i64> splat (i64 2), ptr %21, align 16
  store <2 x i64> splat (i64 2), ptr %22, align 16
  %23 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index48
  %24 = getelementptr inbounds nuw i8, ptr %23, i64 96
  %25 = getelementptr inbounds nuw i8, ptr %23, i64 112
  store <2 x i64> splat (i64 2), ptr %24, align 16
  store <2 x i64> splat (i64 2), ptr %25, align 16
  %26 = getelementptr inbounds nuw i64, ptr %t26.i, i64 %index48
  %27 = getelementptr inbounds nuw i8, ptr %26, i64 128
  %28 = getelementptr inbounds nuw i8, ptr %26, i64 144
  store <2 x i64> splat (i64 2), ptr %27, align 16
  store <2 x i64> splat (i64 2), ptr %28, align 16
  %index.next49.4 = add nuw nsw i64 %index48, 20
  %29 = icmp eq i64 %index.next49.4, 100000
  br i1 %29, label %fill.end.17.i, label %vector.body47, !llvm.loop !6

alloc.oom.14.i:                                   ; preds = %fill.end.12.i
  tail call fastcc void @archx_oom_fail()
  unreachable

fill.end.17.i:                                    ; preds = %vector.body47
  %t36.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @malloc(i64 800000)
  %t37.i = icmp eq ptr %t36.i, null
  br i1 %t37.i, label %alloc.oom.19.i, label %vector.body54

vector.body54:                                    ; preds = %fill.end.17.i, %vector.body54
  %index55 = phi i64 [ %index.next56.4, %vector.body54 ], [ 0, %fill.end.17.i ]
  %30 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index55
  %31 = getelementptr inbounds nuw i8, ptr %30, i64 16
  store <2 x i64> splat (i64 3), ptr %30, align 16
  store <2 x i64> splat (i64 3), ptr %31, align 16
  %32 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index55
  %33 = getelementptr inbounds nuw i8, ptr %32, i64 32
  %34 = getelementptr inbounds nuw i8, ptr %32, i64 48
  store <2 x i64> splat (i64 3), ptr %33, align 16
  store <2 x i64> splat (i64 3), ptr %34, align 16
  %35 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index55
  %36 = getelementptr inbounds nuw i8, ptr %35, i64 64
  %37 = getelementptr inbounds nuw i8, ptr %35, i64 80
  store <2 x i64> splat (i64 3), ptr %36, align 16
  store <2 x i64> splat (i64 3), ptr %37, align 16
  %38 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index55
  %39 = getelementptr inbounds nuw i8, ptr %38, i64 96
  %40 = getelementptr inbounds nuw i8, ptr %38, i64 112
  store <2 x i64> splat (i64 3), ptr %39, align 16
  store <2 x i64> splat (i64 3), ptr %40, align 16
  %41 = getelementptr inbounds nuw i64, ptr %t36.i, i64 %index55
  %42 = getelementptr inbounds nuw i8, ptr %41, i64 128
  %43 = getelementptr inbounds nuw i8, ptr %41, i64 144
  store <2 x i64> splat (i64 3), ptr %42, align 16
  store <2 x i64> splat (i64 3), ptr %43, align 16
  %index.next56.4 = add nuw nsw i64 %index55, 20
  %44 = icmp eq i64 %index.next56.4, 100000
  br i1 %44, label %overflow.ok.28.i, label %vector.body54, !llvm.loop !7

alloc.oom.19.i:                                   ; preds = %fill.end.17.i
  tail call fastcc void @archx_oom_fail()
  unreachable

overflow.ok.28.i:                                 ; preds = %vector.body54, %overflow.ok.28.i
  %for.i.43.031.i = phi i64 [ %t123.i, %overflow.ok.28.i ], [ 0, %vector.body54 ]
  %t50.i = mul nuw nsw i64 %for.i.43.031.i, 3
  %t48.i = getelementptr inbounds nuw i64, ptr %t3.i, i64 %for.i.43.031.i
  store i64 %t50.i, ptr %t48.i, align 8
  %t56.i = mul nuw nsw i64 %for.i.43.031.i, 5
  %t54.i = getelementptr inbounds nuw i64, ptr %t7.i, i64 %for.i.43.031.i
  store i64 %t56.i, ptr %t54.i, align 8
  %t62.i = mul nuw nsw i64 %for.i.43.031.i, 7
  %t60.i = getelementptr inbounds nuw i64, ptr %t11.i, i64 %for.i.43.031.i
  store i64 %t62.i, ptr %t60.i, align 8
  %t66.i = getelementptr inbounds nuw i64, ptr %t16.i, i64 %for.i.43.031.i
  %t73.lhs.trunc.i = trunc nuw nsw i64 %for.i.43.031.i to i32
  %t7322.i = urem i32 %t73.lhs.trunc.i, 7
  %narrow.i = add nuw nsw i32 %t7322.i, 1
  %t81.i = zext nneg i32 %narrow.i to i64
  store i64 %t81.i, ptr %t66.i, align 8
  %t85.i = getelementptr inbounds nuw i64, ptr %t26.i, i64 %for.i.43.031.i
  %t9223.i = urem i32 %t73.lhs.trunc.i, 5
  %narrow26.i = add nuw nsw i32 %t9223.i, 1
  %t100.i = zext nneg i32 %narrow26.i to i64
  store i64 %t100.i, ptr %t85.i, align 8
  %t104.i = getelementptr inbounds nuw i64, ptr %t36.i, i64 %for.i.43.031.i
  %t11124.i = urem i32 %t73.lhs.trunc.i, 3
  %narrow27.i = add nuw nsw i32 %t11124.i, 1
  %t119.i = zext nneg i32 %narrow27.i to i64
  store i64 %t119.i, ptr %t104.i, align 8
  %t123.i = add nuw nsw i64 %for.i.43.031.i, 1
  %exitcond39.not.i = icmp eq i64 %t123.i, 100000
  br i1 %exitcond39.not.i, label %mod.ok.50.i, label %overflow.ok.28.i

mod.ok.50.i:                                      ; preds = %overflow.ok.28.i, %for.step.47.i
  %for.t.124.034.i = phi i64 [ %t188.i, %for.step.47.i ], [ 0, %overflow.ok.28.i ]
  %t134.lhs.trunc.i = trunc nuw i64 %for.t.124.034.i to i8
  %t13425.i = urem i8 %t134.lhs.trunc.i, 3
  %t134.zext.i = zext nneg i8 %t13425.i to i64
  %t142.i = add nsw i64 %t134.zext.i, -1
  br label %for.body.54.i

for.body.54.i:                                    ; preds = %overflow.ok.60.i, %mod.ok.50.i
  %for.i.145.032.i = phi i64 [ 0, %mod.ok.50.i ], [ %t168.i, %overflow.ok.60.i ]
  %t150.i = getelementptr inbounds nuw i64, ptr %t3.i, i64 %for.i.145.032.i
  %t151.i = load i64, ptr %t150.i, align 8
  %t153.i = getelementptr inbounds nuw i64, ptr %t16.i, i64 %for.i.145.032.i
  %t154.i = load i64, ptr %t153.i, align 8
  %t155.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t151.i, i64 %t154.i)
  %t157.i = extractvalue { i64, i1 } %t155.i, 1
  br i1 %t157.i, label %overflow.add.57.i, label %overflow.ok.58.i

overflow.add.57.i:                                ; preds = %for.body.54.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.58.i:                                 ; preds = %for.body.54.i
  %t156.i = extractvalue { i64, i1 } %t155.i, 0
  store i64 %t156.i, ptr %t150.i, align 8
  %t159.i = getelementptr inbounds nuw i64, ptr %t7.i, i64 %for.i.145.032.i
  %t160.i = load i64, ptr %t159.i, align 8
  %t162.i = getelementptr inbounds nuw i64, ptr %t26.i, i64 %for.i.145.032.i
  %t163.i = load i64, ptr %t162.i, align 8
  %t164.i = tail call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %t160.i, i64 %t163.i)
  %t166.i = extractvalue { i64, i1 } %t164.i, 1
  br i1 %t166.i, label %overflow.sub.59.i, label %overflow.ok.60.i

overflow.sub.59.i:                                ; preds = %overflow.ok.58.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.60.i:                                 ; preds = %overflow.ok.58.i
  %t165.i = extractvalue { i64, i1 } %t164.i, 0
  store i64 %t165.i, ptr %t159.i, align 8
  %t168.i = add nuw nsw i64 %for.i.145.032.i, 1
  %exitcond40.not.i = icmp eq i64 %t168.i, 100000
  br i1 %exitcond40.not.i, label %for.body.62.i, label %for.body.54.i

for.body.62.i:                                    ; preds = %overflow.ok.60.i, %overflow.ok.68.i
  %for.i.169.033.i = phi i64 [ %t186.i, %overflow.ok.68.i ], [ 0, %overflow.ok.60.i ]
  %t174.i = getelementptr inbounds nuw i64, ptr %t11.i, i64 %for.i.169.033.i
  %t177.i = getelementptr inbounds nuw i64, ptr %t36.i, i64 %for.i.169.033.i
  %t178.i = load i64, ptr %t177.i, align 16
  %t179.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t178.i, i64 %t142.i)
  %t181.i = extractvalue { i64, i1 } %t179.i, 1
  br i1 %t181.i, label %overflow.add.65.i, label %overflow.ok.66.i

overflow.add.65.i:                                ; preds = %for.body.62.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.66.i:                                 ; preds = %for.body.62.i
  %t180.i = extractvalue { i64, i1 } %t179.i, 0
  %t175.i = load i64, ptr %t174.i, align 16
  %t182.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t175.i, i64 %t180.i)
  %t184.i = extractvalue { i64, i1 } %t182.i, 1
  br i1 %t184.i, label %overflow.add.67.i, label %overflow.ok.68.i

overflow.add.67.i:                                ; preds = %overflow.ok.66.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.68.i:                                 ; preds = %overflow.ok.66.i
  %t183.i = extractvalue { i64, i1 } %t182.i, 0
  store i64 %t183.i, ptr %t174.i, align 16
  %t186.i = add nuw nsw i64 %for.i.169.033.i, 8
  %t172.i = icmp samesign ult i64 %for.i.169.033.i, 99992
  br i1 %t172.i, label %for.body.62.i, label %for.step.47.i

for.step.47.i:                                    ; preds = %overflow.ok.68.i
  %t188.i = add nuw nsw i64 %for.t.124.034.i, 1
  %exitcond41.not.i = icmp eq i64 %t188.i, 120
  br i1 %exitcond41.not.i, label %foreach.body.70.i, label %mod.ok.50.i

foreach.body.70.i:                                ; preds = %for.step.47.i, %mod.ok.80.i
  %foreach.idx.190.036.i = phi i64 [ %t238.i, %mod.ok.80.i ], [ 0, %for.step.47.i ]
  %var.acc.189.035.i = phi i64 [ %t236.i, %mod.ok.80.i ], [ 0, %for.step.47.i ]
  %t193.i = getelementptr inbounds nuw i64, ptr %t3.i, i64 %foreach.idx.190.036.i
  %t194.i = load i64, ptr %t193.i, align 8
  %t199.i = getelementptr inbounds nuw i64, ptr %t11.i, i64 %foreach.idx.190.036.i
  %t200.i = load i64, ptr %t199.i, align 8
  %t213.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.189.035.i, i64 %t194.i)
  %t215.i = extractvalue { i64, i1 } %t213.i, 1
  br i1 %t215.i, label %overflow.add.73.i, label %overflow.ok.74.i

overflow.add.73.i:                                ; preds = %foreach.body.70.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.74.i:                                 ; preds = %foreach.body.70.i
  %t214.i = extractvalue { i64, i1 } %t213.i, 0
  %t196.i = getelementptr inbounds nuw i64, ptr %t7.i, i64 %foreach.idx.190.036.i
  %t197.i = load i64, ptr %t196.i, align 8
  %t217.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t214.i, i64 %t197.i)
  %t219.i = extractvalue { i64, i1 } %t217.i, 1
  br i1 %t219.i, label %overflow.add.75.i, label %overflow.ok.76.i

overflow.add.75.i:                                ; preds = %overflow.ok.74.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.76.i:                                 ; preds = %overflow.ok.74.i
  %t218.i = extractvalue { i64, i1 } %t217.i, 0
  %t221.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t218.i, i64 %t200.i)
  %t223.i = extractvalue { i64, i1 } %t221.i, 1
  br i1 %t223.i, label %overflow.add.77.i, label %mod.ok.80.i

overflow.add.77.i:                                ; preds = %overflow.ok.76.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

mod.ok.80.i:                                      ; preds = %overflow.ok.76.i
  %t222.i = extractvalue { i64, i1 } %t221.i, 0
  %t229.i = srem i64 %t222.i, 1000000007
  %t231.i = icmp slt i64 %t229.i, 0
  %t235.i = select i1 %t231.i, i64 1000000007, i64 0
  %t236.i = add nsw i64 %t235.i, %t229.i
  %t238.i = add nuw nsw i64 %foreach.idx.190.036.i, 1
  %exitcond42.not.i = icmp eq i64 %t238.i, 100000
  br i1 %exitcond42.not.i, label %archx_fn_particle_sim.exit, label %foreach.body.70.i

archx_fn_particle_sim.exit:                       ; preds = %mod.ok.80.i
  tail call void @free(ptr %t36.i)
  tail call void @free(ptr %t26.i)
  tail call void @free(ptr %t16.i)
  tail call void @free(ptr nonnull %t11.i)
  tail call void @free(ptr nonnull %t7.i)
  tail call void @free(ptr nonnull %t3.i)
  %t1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t236.i)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %func.region.i)
  %.fca.1.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 8
  %.fca.2.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 16
  %.fca.3.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %func.region.i, i8 0, i64 32, i1 false)
  %btmp.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %btmp.i.i, i64 4
  %btmp.i.i.1.sroa_idx = getelementptr inbounds nuw i8, ptr %btmp.i.i, i64 1
  br label %mod.ok.5.i

mod.ok.5.i:                                       ; preds = %mod.ok.5.i.backedge, %archx_fn_particle_sim.exit
  %indvar = phi i4 [ %indvar.next, %mod.ok.5.i.backedge ], [ 0, %archx_fn_particle_sim.exit ]
  %end.i35.i = phi ptr [ %end.i35.i.be, %mod.ok.5.i.backedge ], [ null, %archx_fn_particle_sim.exit ]
  %cur.i.i = phi ptr [ %cur.i.i.be, %mod.ok.5.i.backedge ], [ null, %archx_fn_particle_sim.exit ]
  %var.total.0.0143.i = phi i64 [ %t189.i, %mod.ok.5.i.backedge ], [ 0, %archx_fn_particle_sim.exit ]
  %for.r.1.0142.i = phi i64 [ %for.r.1.0142.i.be, %mod.ok.5.i.backedge ], [ 0, %archx_fn_particle_sim.exit ]
  %45 = zext i4 %indvar to i64
  %46 = add nuw nsw i64 %45, 255
  %47 = lshr i64 %46, 2
  %48 = add nuw nsw i64 %47, 1
  %t11.i1 = and i64 %for.r.1.0142.i, 15
  %t19.i2 = or disjoint i64 %t11.i1, 256
  %t23.i = shl nuw nsw i64 %t19.i2, 3
  %a1.i.i = add nuw nsw i64 %t23.i, 15
  %aligned.i.i = and i64 %a1.i.i, 2288
  %cur_i.i.i = ptrtoint ptr %cur.i.i to i64
  %end_i.i.i = ptrtoint ptr %end.i35.i to i64
  %rem.i.i = sub i64 %end_i.i.i, %cur_i.i.i
  %fits.not.i.i = icmp slt i64 %rem.i.i, %aligned.i.i
  br i1 %fits.not.i.i, label %fallback.i.i, label %fast.i.i

fast.i.i:                                         ; preds = %mod.ok.5.i
  %next.i.i = getelementptr inbounds nuw i8, ptr %cur.i.i, i64 %aligned.i.i
  store ptr %next.i.i, ptr %func.region.i, align 8
  br label %archx_region_alloc.exit.i

fallback.i.i:                                     ; preds = %mod.ok.5.i
  %res.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 %aligned.i.i)
  br label %archx_region_alloc.exit.i

archx_region_alloc.exit.i:                        ; preds = %fallback.i.i, %fast.i.i
  %common.ret.op.i.i = phi ptr [ %cur.i.i, %fast.i.i ], [ %res.i.i, %fallback.i.i ]
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %common.ret.op.i.i, i8 0, i64 %t23.i, i1 false)
  %xtraiter = and i64 %48, 3
  %unroll_iter = and i64 %48, 252
  br label %overflow.ok.19.i

overflow.ok.19.i:                                 ; preds = %overflow.ok.19.i, %archx_region_alloc.exit.i
  %for.k.34.0141.i = phi i64 [ 0, %archx_region_alloc.exit.i ], [ %t50.i4.3, %overflow.ok.19.i ]
  %niter = phi i64 [ 0, %archx_region_alloc.exit.i ], [ %niter.next.3, %overflow.ok.19.i ]
  %t40.i3 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %for.k.34.0141.i
  %49 = mul nuw nsw i64 %for.k.34.0141.i, 3
  %50 = add nuw nsw i64 %49, %for.r.1.0142.i
  store i64 %50, ptr %t40.i3, align 8
  %t50.i4 = or disjoint i64 %for.k.34.0141.i, 4
  %t40.i3.1 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t50.i4
  %51 = mul nuw nsw i64 %t50.i4, 3
  %52 = add nuw nsw i64 %51, %for.r.1.0142.i
  store i64 %52, ptr %t40.i3.1, align 8
  %t50.i4.1 = or disjoint i64 %for.k.34.0141.i, 8
  %t40.i3.2 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t50.i4.1
  %53 = mul nuw nsw i64 %t50.i4.1, 3
  %54 = add nuw nsw i64 %53, %for.r.1.0142.i
  store i64 %54, ptr %t40.i3.2, align 8
  %t50.i4.2 = or disjoint i64 %for.k.34.0141.i, 12
  %t40.i3.3 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t50.i4.2
  %55 = mul nuw nsw i64 %t50.i4.2, 3
  %56 = add nuw nsw i64 %55, %for.r.1.0142.i
  store i64 %56, ptr %t40.i3.3, align 8
  %t50.i4.3 = add nuw nsw i64 %for.k.34.0141.i, 16
  %niter.next.3 = add nuw nsw i64 %niter, 4
  %niter.ncmp.3.not = icmp eq i64 %niter.next.3, %unroll_iter
  br i1 %niter.ncmp.3.not, label %for.end.15.i.unr-lcssa, label %overflow.ok.19.i

for.end.15.i.unr-lcssa:                           ; preds = %overflow.ok.19.i
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %for.end.15.i, label %overflow.ok.19.i.epil

overflow.ok.19.i.epil:                            ; preds = %for.end.15.i.unr-lcssa, %overflow.ok.19.i.epil
  %for.k.34.0141.i.epil = phi i64 [ %t50.i4.epil, %overflow.ok.19.i.epil ], [ %t50.i4.3, %for.end.15.i.unr-lcssa ]
  %epil.iter = phi i64 [ %epil.iter.next, %overflow.ok.19.i.epil ], [ 0, %for.end.15.i.unr-lcssa ]
  %t40.i3.epil = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %for.k.34.0141.i.epil
  %57 = mul nuw nsw i64 %for.k.34.0141.i.epil, 3
  %58 = add nuw nsw i64 %57, %for.r.1.0142.i
  store i64 %58, ptr %t40.i3.epil, align 8
  %t50.i4.epil = add nuw nsw i64 %for.k.34.0141.i.epil, 4
  %epil.iter.next = add i64 %epil.iter, 1
  %epil.iter.cmp.not = icmp eq i64 %epil.iter.next, %xtraiter
  br i1 %epil.iter.cmp.not, label %for.end.15.i, label %overflow.ok.19.i.epil, !llvm.loop !8

for.end.15.i:                                     ; preds = %overflow.ok.19.i.epil, %for.end.15.i.unr-lcssa
  %t52.i = mul nuw nsw i64 %for.r.1.0142.i, 7
  %t60.i6 = urem i64 %t52.i, %t19.i2
  %t72.i = load i64, ptr %common.ret.op.i.i, align 8
  %t76.i = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t60.i6
  %t77.i = load i64, ptr %t76.i, align 8
  %t78.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t72.i, i64 %t77.i)
  %t80.i = extractvalue { i64, i1 } %t78.i, 1
  br i1 %t80.i, label %overflow.add.28.i, label %idx.ok.32.i

overflow.add.28.i:                                ; preds = %for.end.15.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

idx.ok.32.i:                                      ; preds = %for.end.15.i
  %t79.i = extractvalue { i64, i1 } %t78.i, 0
  %59 = getelementptr inbounds nuw i64, ptr %common.ret.op.i.i, i64 %t11.i1
  %t87.i = getelementptr inbounds nuw i8, ptr %59, i64 2040
  %t88.i = load i64, ptr %t87.i, align 8
  %t89.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t79.i, i64 %t88.i)
  %t90.i = extractvalue { i64, i1 } %t89.i, 0
  %t91.i = extractvalue { i64, i1 } %t89.i, 1
  br i1 %t91.i, label %overflow.add.34.i, label %mod.ok.37.i

overflow.add.34.i:                                ; preds = %idx.ok.32.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

mod.ok.37.i:                                      ; preds = %idx.ok.32.i
  %t100.i7 = and i64 %for.r.1.0142.i, 1
  %t108.i = icmp eq i64 %t100.i7, 0
  %spec.select.i = select i1 %t108.i, i64 12385, i64 14649
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i.i)
  %bp4_32.i.i = select i1 %t108.i, i32 1752198241, i32 1635018082
  store i32 %bp4_32.i.i, ptr %btmp.i.i, align 4
  store i64 %spec.select.i, ptr %btmp.i.i.4.sroa_idx, align 4
  %btmp.i.i.1.btmp.i.i.1.btmp.i.i.1.btmp.i.1.btmp.i.1.out_sso.i.sroa.7.7.copyload.i = load i40, ptr %btmp.i.i.1.sroa_idx, align 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i.i)
  %t120.i = and i64 %for.r.1.0142.i, 3
  %t128.i = icmp eq i64 %t120.i, 0
  %var.l_rhs.113.sroa.5.0.i = select i1 %t128.i, i64 7016382228454465903, i64 7088494763882274674
  %bp4_32.i111.i = select i1 %t128.i, i32 1819894128, i32 1701344367
  %cur.i.i.i = load ptr, ptr %func.region.i, align 8
  %end.i.i.i = load ptr, ptr %.fca.1.gep.i, align 8
  %cur_i.i.i.i = ptrtoint ptr %cur.i.i.i to i64
  %end_i.i.i.i = ptrtoint ptr %end.i.i.i to i64
  %rem.i.i.i = sub i64 %end_i.i.i.i, %cur_i.i.i.i
  %fits.not.i.i.i = icmp slt i64 %rem.i.i.i, 32
  br i1 %fits.not.i.i.i, label %fallback.i.i.i, label %fast.i.i.i

fast.i.i.i:                                       ; preds = %mod.ok.37.i
  %next.i.i.i = getelementptr inbounds nuw i8, ptr %cur.i.i.i, i64 32
  store ptr %next.i.i.i, ptr %func.region.i, align 8
  br label %archx_str_concat.exit.i

fallback.i.i.i:                                   ; preds = %mod.ok.37.i
  %res.i.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 32)
  %.pre.i = ptrtoint ptr %res.i.i.i to i64
  br label %archx_str_concat.exit.i

archx_str_concat.exit.i:                          ; preds = %fallback.i.i.i, %fast.i.i.i
  %rp_i.i.pre-phi.i = phi i64 [ %cur_i.i.i.i, %fast.i.i.i ], [ %.pre.i, %fallback.i.i.i ]
  %common.ret.op.i.i.i = phi ptr [ %cur.i.i.i, %fast.i.i.i ], [ %res.i.i.i, %fallback.i.i.i ]
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(14) %common.ret.op.i.i.i, ptr noundef nonnull align 4 dereferenceable(14) @.str.0, i64 14, i1 false)
  %dst_b.i.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i.i, i64 14
  store i32 %bp4_32.i111.i, ptr %dst_b.i.i, align 1
  %btmp.i100.sroa.4.0.dst_b.i.sroa_idx.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i.i, i64 18
  store i64 %var.l_rhs.113.sroa.5.0.i, ptr %btmp.i100.sroa.4.0.dst_b.i.sroa_idx.i, align 1
  %60 = and i32 %bp4_32.i.i, 99
  %w0_eq.i.i = icmp eq i32 %60, 97
  %eq_s.i.i = icmp eq i40 %btmp.i.i.1.btmp.i.i.1.btmp.i.i.1.btmp.i.1.btmp.i.1.out_sso.i.sroa.7.7.copyload.i, 207792664684
  %or.cond.i = select i1 %w0_eq.i.i, i1 %eq_s.i.i, i1 false
  br i1 %or.cond.i, label %if.then.46.i, label %cmp_long.i67.i

if.then.46.i:                                     ; preds = %archx_str_concat.exit.i
  %t139.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t90.i, i64 17)
  %t141.i = extractvalue { i64, i1 } %t139.i, 1
  br i1 %t141.i, label %overflow.add.49.i, label %overflow.ok.50.i

overflow.add.49.i:                                ; preds = %if.then.46.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.50.i:                                 ; preds = %if.then.46.i
  %t140.i = extractvalue { i64, i1 } %t139.i, 0
  br label %cmp_long.i67.i

cmp_long.i67.i:                                   ; preds = %overflow.ok.50.i, %archx_str_concat.exit.i
  %var.s_acc.92.0.i = phi i64 [ %t140.i, %overflow.ok.50.i ], [ %t90.i, %archx_str_concat.exit.i ]
  %ap_i.i68.i = and i64 %rp_i.i.pre-phi.i, -4
  %same_ptr.i69.i = icmp eq i64 %ap_i.i68.i, ptrtoint (ptr @.str.1 to i64)
  br i1 %same_ptr.i69.i, label %if.then.51.i, label %archx_str_eq.exit78.i

archx_str_eq.exit78.i:                            ; preds = %cmp_long.i67.i
  %ap.i71.i = inttoptr i64 %ap_i.i68.i to ptr
  %ap4.i72.i = getelementptr inbounds nuw i8, ptr %ap.i71.i, i64 4
  %bcmp.i74.i = tail call i32 @bcmp(ptr noundef nonnull dereferenceable(22) %ap4.i72.i, ptr noundef nonnull dereferenceable(22) getelementptr inbounds nuw (i8, ptr @.str.1, i64 4), i64 22)
  %eq_m.i75.i = icmp eq i32 %bcmp.i74.i, 0
  br i1 %eq_m.i75.i, label %if.then.51.i, label %cmp_long.i86.i

if.then.51.i:                                     ; preds = %archx_str_eq.exit78.i, %cmp_long.i67.i
  %t148.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.s_acc.92.0.i, i64 43)
  %t150.i22 = extractvalue { i64, i1 } %t148.i, 1
  br i1 %t150.i22, label %overflow.add.54.i, label %overflow.ok.55.i

overflow.add.54.i:                                ; preds = %if.then.51.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.55.i:                                 ; preds = %if.then.51.i
  %t149.i = extractvalue { i64, i1 } %t148.i, 0
  br label %cmp_long.i86.i

cmp_long.i86.i:                                   ; preds = %overflow.ok.55.i, %archx_str_eq.exit78.i
  %var.s_acc.92.1.ph.i = phi i64 [ %var.s_acc.92.0.i, %archx_str_eq.exit78.i ], [ %t149.i, %overflow.ok.55.i ]
  %same_ptr.i88.i = icmp eq i64 %ap_i.i68.i, ptrtoint (ptr @.str.2 to i64)
  br i1 %same_ptr.i88.i, label %if.then.56.i, label %archx_str_eq.exit97.i

archx_str_eq.exit97.i:                            ; preds = %cmp_long.i86.i
  %ap.i90.i = inttoptr i64 %ap_i.i68.i to ptr
  %ap4.i91.i = getelementptr inbounds nuw i8, ptr %ap.i90.i, i64 4
  %bcmp.i93.i = tail call i32 @bcmp(ptr noundef nonnull dereferenceable(22) %ap4.i91.i, ptr noundef nonnull dereferenceable(22) getelementptr inbounds nuw (i8, ptr @.str.2, i64 4), i64 22)
  %eq_m.i94.i = icmp eq i32 %bcmp.i93.i, 0
  br i1 %eq_m.i94.i, label %if.then.56.i, label %if.merge.58.i

if.then.56.i:                                     ; preds = %archx_str_eq.exit97.i, %cmp_long.i86.i
  %t157.i19 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.s_acc.92.1.ph.i, i64 99)
  %t159.i20 = extractvalue { i64, i1 } %t157.i19, 1
  br i1 %t159.i20, label %overflow.add.59.i, label %overflow.ok.60.i21

overflow.add.59.i:                                ; preds = %if.then.56.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.60.i21:                               ; preds = %if.then.56.i
  %t158.i = extractvalue { i64, i1 } %t157.i19, 0
  br label %if.merge.58.i

if.merge.58.i:                                    ; preds = %overflow.ok.60.i21, %archx_str_eq.exit97.i
  %var.s_acc.92.2.i = phi i64 [ %t158.i, %overflow.ok.60.i21 ], [ %var.s_acc.92.1.ph.i, %archx_str_eq.exit97.i ]
  %t162.i8 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.total.0.0143.i, i64 %var.s_acc.92.2.i)
  %t164.i9 = extractvalue { i64, i1 } %t162.i8, 1
  br i1 %t164.i9, label %overflow.add.61.i, label %overflow.ok.62.i

overflow.add.61.i:                                ; preds = %if.merge.58.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.62.i:                                 ; preds = %if.merge.58.i
  %t163.i10 = extractvalue { i64, i1 } %t162.i8, 0
  %t168.i11 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t163.i10, i64 9)
  %t170.i = extractvalue { i64, i1 } %t168.i11, 1
  br i1 %t170.i, label %overflow.add.63.i, label %overflow.ok.64.i

overflow.add.63.i:                                ; preds = %overflow.ok.62.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.64.i:                                 ; preds = %overflow.ok.62.i
  %t169.i = extractvalue { i64, i1 } %t168.i11, 0
  %t174.i12 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t169.i, i64 26)
  %t176.i = extractvalue { i64, i1 } %t174.i12, 1
  br i1 %t176.i, label %overflow.add.65.i18, label %mod.ok.68.i

overflow.add.65.i18:                              ; preds = %overflow.ok.64.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

mod.ok.68.i:                                      ; preds = %overflow.ok.64.i
  %t175.i13 = extractvalue { i64, i1 } %t174.i12, 0
  %t182.i14 = srem i64 %t175.i13, 1000000007
  %t184.i15 = icmp slt i64 %t182.i14, 0
  %t188.i16 = select i1 %t184.i15, i64 1000000007, i64 0
  %t189.i = add nsw i64 %t188.i16, %t182.i14
  %tag.i51.i = and i64 %rp_i.i.pre-phi.i, 1
  %owned.not.i52.i = icmp eq i64 %tag.i51.i, 0
  br i1 %owned.not.i52.i, label %archx_str_drop.exit56.i, label %do_free.i53.i

do_free.i53.i:                                    ; preds = %mod.ok.68.i
  %raw.i54.i = or disjoint i64 %ap_i.i68.i, 2
  %ptr.i55.i = inttoptr i64 %raw.i54.i to ptr
  tail call void @free(ptr nonnull %ptr.i55.i)
  br label %archx_str_drop.exit56.i

archx_str_drop.exit56.i:                          ; preds = %do_free.i53.i, %mod.ok.68.i
  %head.i.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i.i = icmp eq ptr %head.i.i, null
  br i1 %empty.i.i, label %archx_region_rewind_root.exit.i, label %archx_region_rewind_root.exit.thread.i

archx_region_rewind_root.exit.i:                  ; preds = %archx_str_drop.exit56.i
  %t195.i = add nuw nsw i64 %for.r.1.0142.i, 1
  %exitcond.not.i17 = icmp eq i64 %t195.i, 40000
  br i1 %exitcond.not.i17, label %archx_fn_arena_and_strings.exit, label %archx_region_rewind_root.exit.i.mod.ok.5.backedge.i_crit_edge

archx_region_rewind_root.exit.i.mod.ok.5.backedge.i_crit_edge: ; preds = %archx_region_rewind_root.exit.i
  %cur.i.i.pre.pre = load ptr, ptr %func.region.i, align 8
  %end.i35.i.pre.pre = load ptr, ptr %.fca.1.gep.i, align 8
  br label %mod.ok.5.i.backedge

mod.ok.5.i.backedge:                              ; preds = %archx_region_rewind_root.exit.i.mod.ok.5.backedge.i_crit_edge, %archx_region_rewind_root.exit.thread.i
  %end.i35.i.be = phi ptr [ %end.i35.i.pre.pre, %archx_region_rewind_root.exit.i.mod.ok.5.backedge.i_crit_edge ], [ %end.i.i, %archx_region_rewind_root.exit.thread.i ]
  %cur.i.i.be = phi ptr [ %cur.i.i.pre.pre, %archx_region_rewind_root.exit.i.mod.ok.5.backedge.i_crit_edge ], [ %data.i.i, %archx_region_rewind_root.exit.thread.i ]
  %for.r.1.0142.i.be = phi i64 [ %t195.i, %archx_region_rewind_root.exit.i.mod.ok.5.backedge.i_crit_edge ], [ %t195146.i, %archx_region_rewind_root.exit.thread.i ]
  %indvar.next = add i4 %indvar, 1
  br label %mod.ok.5.i

archx_region_rewind_root.exit.thread.i:           ; preds = %archx_str_drop.exit56.i
  %cap_ptr.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 8
  %cap.i.i = load i64, ptr %cap_ptr.i.i, align 8
  %data.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 16
  %end.i.i = getelementptr inbounds i8, ptr %data.i.i, i64 %cap.i.i
  store ptr %data.i.i, ptr %func.region.i, align 8
  store ptr %end.i.i, ptr %.fca.1.gep.i, align 8
  store ptr %head.i.i, ptr %.fca.3.gep.i, align 8
  %t195146.i = add nuw nsw i64 %for.r.1.0142.i, 1
  %exitcond.not147.i = icmp eq i64 %t195146.i, 40000
  br i1 %exitcond.not147.i, label %loop.i.i, label %mod.ok.5.i.backedge

loop.i.i:                                         ; preds = %archx_region_rewind_root.exit.thread.i, %loop.i.i
  %cur.i114.i = phi ptr [ %next.i115.i, %loop.i.i ], [ %head.i.i, %archx_region_rewind_root.exit.thread.i ]
  %next.i115.i = load ptr, ptr %cur.i114.i, align 8
  tail call void @free(ptr nonnull %cur.i114.i)
  %more.not.i.i = icmp eq ptr %next.i115.i, null
  br i1 %more.not.i.i, label %archx_fn_arena_and_strings.exit, label %loop.i.i

archx_fn_arena_and_strings.exit:                  ; preds = %archx_region_rewind_root.exit.i, %loop.i.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  %t3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t189.i)
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
define private fastcc void @archx_int_overflow_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_oom_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.1)
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

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) #10

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) #10

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #11

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @bcmp(ptr captures(none), ptr captures(none), i64) local_unnamed_addr #12

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #4

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #13

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #13

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
attributes #10 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #11 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #12 = { nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #13 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!llvm.module.flags = !{!0, !1, !2}

!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
!2 = !{i32 1, !"archx.wrapping", !"false"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.isvectorized", i32 1}
!5 = !{!"llvm.loop.unroll.runtime.disable"}
!6 = distinct !{!6, !4, !5}
!7 = distinct !{!7, !4, !5}
!8 = distinct !{!8, !9}
!9 = !{!"llvm.loop.unroll.disable"}
