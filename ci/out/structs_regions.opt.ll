; ModuleID = 'ci/out/structs_regions.ll'
source_filename = "ci/out/structs_regions.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxStr = type { i64, i64 }

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@str = private unnamed_addr constant [38 x i8] c"archx runtime panic: integer overflow\00", align 1
@str.1 = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %tmp.i = alloca [12 x i8], align 4
  %func.region.i = alloca %ArchxRegion, align 8
  %t3.i = tail call noalias align 16 dereferenceable_or_null(256) ptr @calloc(i64 32, i64 8)
  %t4.i = icmp eq ptr %t3.i, null
  br i1 %t4.i, label %calloc.oom.3.i, label %calloc.ok.2.i

calloc.oom.3.i:                                   ; preds = %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.2.i:                                    ; preds = %entry
  %t7.i = tail call noalias align 16 dereferenceable_or_null(256) ptr @calloc(i64 32, i64 8)
  %t8.i = icmp eq ptr %t7.i, null
  br i1 %t8.i, label %calloc.oom.5.i, label %calloc.ok.4.i

calloc.oom.5.i:                                   ; preds = %calloc.ok.2.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.4.i:                                    ; preds = %calloc.ok.2.i
  %t12.i = tail call noalias align 16 dereferenceable_or_null(256) ptr @malloc(i64 256)
  %t13.i = icmp eq ptr %t12.i, null
  br i1 %t13.i, label %alloc.oom.7.i, label %fill.body.9.preheader.i

fill.body.9.preheader.i:                          ; preds = %calloc.ok.4.i
  store <4 x i64> splat (i64 1), ptr %t12.i, align 16
  %t17.4.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 32
  store <4 x i64> splat (i64 1), ptr %t17.4.i, align 16
  %t17.8.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 64
  store <4 x i64> splat (i64 1), ptr %t17.8.i, align 16
  %t17.12.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 96
  store <4 x i64> splat (i64 1), ptr %t17.12.i, align 16
  %t17.16.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 128
  store <4 x i64> splat (i64 1), ptr %t17.16.i, align 16
  %t17.20.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 160
  store <4 x i64> splat (i64 1), ptr %t17.20.i, align 16
  %t17.24.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 192
  store <4 x i64> splat (i64 1), ptr %t17.24.i, align 16
  %t17.28.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 224
  store <4 x i64> splat (i64 1), ptr %t17.28.i, align 16
  %t22.i = tail call noalias align 16 dereferenceable_or_null(256) ptr @malloc(i64 256)
  %t23.i = icmp eq ptr %t22.i, null
  br i1 %t23.i, label %alloc.oom.12.i, label %fill.body.14.preheader.i

alloc.oom.7.i:                                    ; preds = %calloc.ok.4.i
  tail call fastcc void @archx_oom_fail()
  unreachable

fill.body.14.preheader.i:                         ; preds = %fill.body.9.preheader.i
  store <4 x i64> splat (i64 2), ptr %t22.i, align 16
  %t27.4.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 32
  store <4 x i64> splat (i64 2), ptr %t27.4.i, align 16
  %t27.8.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 64
  store <4 x i64> splat (i64 2), ptr %t27.8.i, align 16
  %t27.12.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 96
  store <4 x i64> splat (i64 2), ptr %t27.12.i, align 16
  %t27.16.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 128
  store <4 x i64> splat (i64 2), ptr %t27.16.i, align 16
  %t27.20.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 160
  store <4 x i64> splat (i64 2), ptr %t27.20.i, align 16
  %t27.24.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 192
  store <4 x i64> splat (i64 2), ptr %t27.24.i, align 16
  %t27.28.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 224
  store <4 x i64> splat (i64 2), ptr %t27.28.i, align 16
  %0 = getelementptr inbounds nuw i8, ptr %t3.i, i64 16
  store <2 x i64> <i64 0, i64 2>, ptr %t3.i, align 16
  store <2 x i64> <i64 4, i64 6>, ptr %0, align 16
  %1 = getelementptr inbounds nuw i8, ptr %t7.i, i64 16
  store <2 x i64> <i64 0, i64 3>, ptr %t7.i, align 16
  store <2 x i64> <i64 6, i64 9>, ptr %1, align 16
  %2 = getelementptr inbounds nuw i8, ptr %t3.i, i64 32
  %3 = getelementptr inbounds nuw i8, ptr %t3.i, i64 48
  store <2 x i64> <i64 8, i64 10>, ptr %2, align 16
  store <2 x i64> <i64 12, i64 14>, ptr %3, align 16
  %4 = getelementptr inbounds nuw i8, ptr %t7.i, i64 32
  %5 = getelementptr inbounds nuw i8, ptr %t7.i, i64 48
  store <2 x i64> <i64 12, i64 15>, ptr %4, align 16
  store <2 x i64> <i64 18, i64 21>, ptr %5, align 16
  %6 = getelementptr inbounds nuw i8, ptr %t3.i, i64 64
  %7 = getelementptr inbounds nuw i8, ptr %t3.i, i64 80
  store <2 x i64> <i64 16, i64 18>, ptr %6, align 16
  store <2 x i64> <i64 20, i64 22>, ptr %7, align 16
  %8 = getelementptr inbounds nuw i8, ptr %t7.i, i64 64
  %9 = getelementptr inbounds nuw i8, ptr %t7.i, i64 80
  store <2 x i64> <i64 24, i64 27>, ptr %8, align 16
  store <2 x i64> <i64 30, i64 33>, ptr %9, align 16
  %10 = getelementptr inbounds nuw i8, ptr %t3.i, i64 96
  %11 = getelementptr inbounds nuw i8, ptr %t3.i, i64 112
  store <2 x i64> <i64 24, i64 26>, ptr %10, align 16
  store <2 x i64> <i64 28, i64 30>, ptr %11, align 16
  %12 = getelementptr inbounds nuw i8, ptr %t7.i, i64 96
  %13 = getelementptr inbounds nuw i8, ptr %t7.i, i64 112
  store <2 x i64> <i64 36, i64 39>, ptr %12, align 16
  store <2 x i64> <i64 42, i64 45>, ptr %13, align 16
  %14 = getelementptr inbounds nuw i8, ptr %t3.i, i64 128
  %15 = getelementptr inbounds nuw i8, ptr %t3.i, i64 144
  store <2 x i64> <i64 32, i64 34>, ptr %14, align 16
  store <2 x i64> <i64 36, i64 38>, ptr %15, align 16
  %16 = getelementptr inbounds nuw i8, ptr %t7.i, i64 128
  %17 = getelementptr inbounds nuw i8, ptr %t7.i, i64 144
  store <2 x i64> <i64 48, i64 51>, ptr %16, align 16
  store <2 x i64> <i64 54, i64 57>, ptr %17, align 16
  %18 = getelementptr inbounds nuw i8, ptr %t3.i, i64 160
  %19 = getelementptr inbounds nuw i8, ptr %t3.i, i64 176
  store <2 x i64> <i64 40, i64 42>, ptr %18, align 16
  store <2 x i64> <i64 44, i64 46>, ptr %19, align 16
  %20 = getelementptr inbounds nuw i8, ptr %t7.i, i64 160
  %21 = getelementptr inbounds nuw i8, ptr %t7.i, i64 176
  store <2 x i64> <i64 60, i64 63>, ptr %20, align 16
  store <2 x i64> <i64 66, i64 69>, ptr %21, align 16
  %22 = getelementptr inbounds nuw i8, ptr %t3.i, i64 192
  %23 = getelementptr inbounds nuw i8, ptr %t3.i, i64 208
  store <2 x i64> <i64 48, i64 50>, ptr %22, align 16
  store <2 x i64> <i64 52, i64 54>, ptr %23, align 16
  %24 = getelementptr inbounds nuw i8, ptr %t7.i, i64 192
  %25 = getelementptr inbounds nuw i8, ptr %t7.i, i64 208
  store <2 x i64> <i64 72, i64 75>, ptr %24, align 16
  store <2 x i64> <i64 78, i64 81>, ptr %25, align 16
  %26 = getelementptr inbounds nuw i8, ptr %t3.i, i64 224
  %27 = getelementptr inbounds nuw i8, ptr %t3.i, i64 240
  store <2 x i64> <i64 56, i64 58>, ptr %26, align 16
  store <2 x i64> <i64 60, i64 62>, ptr %27, align 16
  %28 = getelementptr inbounds nuw i8, ptr %t7.i, i64 224
  %29 = getelementptr inbounds nuw i8, ptr %t7.i, i64 240
  store <2 x i64> <i64 84, i64 87>, ptr %28, align 16
  store <2 x i64> <i64 90, i64 93>, ptr %29, align 16
  br label %for.cond.28.preheader.i

alloc.oom.12.i:                                   ; preds = %fill.body.9.preheader.i
  tail call fastcc void @archx_oom_fail()
  unreachable

for.cond.28.preheader.i:                          ; preds = %fill.body.14.preheader.i, %overflow.ok.41.7.i
  %t81.7.i = phi i64 [ %30, %overflow.ok.41.7.i ], [ 1, %fill.body.14.preheader.i ]
  %for.t.47.018.i = phi i64 [ %t88.i, %overflow.ok.41.7.i ], [ 0, %fill.body.14.preheader.i ]
  br label %for.body.29.i

for.body.29.i:                                    ; preds = %overflow.ok.35.i, %for.cond.28.preheader.i
  %for.i.51.016.i = phi i64 [ 0, %for.cond.28.preheader.i ], [ %t74.i, %overflow.ok.35.i ]
  %t56.i = getelementptr inbounds nuw i64, ptr %t3.i, i64 %for.i.51.016.i
  %t57.i = load i64, ptr %t56.i, align 8
  %t59.i = getelementptr inbounds nuw i64, ptr %t12.i, i64 %for.i.51.016.i
  %t60.i = load i64, ptr %t59.i, align 8
  %t61.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t57.i, i64 %t60.i)
  %t63.i = extractvalue { i64, i1 } %t61.i, 1
  br i1 %t63.i, label %overflow.add.32.i, label %overflow.ok.33.i

overflow.add.32.i:                                ; preds = %for.body.29.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.33.i:                                 ; preds = %for.body.29.i
  %t62.i = extractvalue { i64, i1 } %t61.i, 0
  store i64 %t62.i, ptr %t56.i, align 8
  %t65.i = getelementptr inbounds nuw i64, ptr %t7.i, i64 %for.i.51.016.i
  %t66.i = load i64, ptr %t65.i, align 8
  %t68.i = getelementptr inbounds nuw i64, ptr %t22.i, i64 %for.i.51.016.i
  %t69.i = load i64, ptr %t68.i, align 8
  %t70.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t66.i, i64 %t69.i)
  %t72.i = extractvalue { i64, i1 } %t70.i, 1
  br i1 %t72.i, label %overflow.add.34.i, label %overflow.ok.35.i

overflow.add.34.i:                                ; preds = %overflow.ok.33.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.35.i:                                 ; preds = %overflow.ok.33.i
  %t71.i = extractvalue { i64, i1 } %t70.i, 0
  store i64 %t71.i, ptr %t65.i, align 8
  %t74.i = add nuw nsw i64 %for.i.51.016.i, 1
  %exitcond21.not.i = icmp eq i64 %t74.i, 32
  br i1 %exitcond21.not.i, label %overflow.ok.41.7.i, label %for.body.29.i

overflow.ok.41.7.i:                               ; preds = %overflow.ok.35.i
  %30 = add nuw nsw i64 %t81.7.i, 1
  store i64 %30, ptr %t12.i, align 16
  store i64 %30, ptr %t17.4.i, align 16
  store i64 %30, ptr %t17.8.i, align 16
  store i64 %30, ptr %t17.12.i, align 16
  store i64 %30, ptr %t17.16.i, align 16
  store i64 %30, ptr %t17.20.i, align 16
  store i64 %30, ptr %t17.24.i, align 16
  store i64 %30, ptr %t17.28.i, align 16
  %t88.i = add nuw nsw i64 %for.t.47.018.i, 1
  %exitcond22.not.i = icmp eq i64 %t88.i, 5
  br i1 %exitcond22.not.i, label %foreach.body.43.i, label %for.cond.28.preheader.i

foreach.body.43.i:                                ; preds = %overflow.ok.41.7.i, %overflow.ok.49.i.1
  %foreach.idx.90.020.i = phi i64 [ %t115.i.1, %overflow.ok.49.i.1 ], [ 0, %overflow.ok.41.7.i ]
  %var.total.89.019.i = phi i64 [ %t112.i.1, %overflow.ok.49.i.1 ], [ 0, %overflow.ok.41.7.i ]
  %t93.i = getelementptr inbounds nuw i64, ptr %t3.i, i64 %foreach.idx.90.020.i
  %t94.i = load i64, ptr %t93.i, align 16
  %t96.i = getelementptr inbounds nuw i64, ptr %t7.i, i64 %foreach.idx.90.020.i
  %t97.i = load i64, ptr %t96.i, align 16
  %t108.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t94.i, i64 %t97.i)
  %t110.i = extractvalue { i64, i1 } %t108.i, 1
  br i1 %t110.i, label %overflow.add.46.i, label %overflow.ok.47.i

overflow.add.46.i:                                ; preds = %overflow.ok.49.i, %foreach.body.43.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.47.i:                                 ; preds = %foreach.body.43.i
  %t109.i = extractvalue { i64, i1 } %t108.i, 0
  %t111.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.total.89.019.i, i64 %t109.i)
  %t113.i = extractvalue { i64, i1 } %t111.i, 1
  br i1 %t113.i, label %overflow.add.48.i, label %overflow.ok.49.i

overflow.add.48.i:                                ; preds = %overflow.ok.47.i.1, %overflow.ok.47.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.49.i:                                 ; preds = %overflow.ok.47.i
  %t115.i = or disjoint i64 %foreach.idx.90.020.i, 1
  %t93.i.1 = getelementptr inbounds nuw i64, ptr %t3.i, i64 %t115.i
  %t94.i.1 = load i64, ptr %t93.i.1, align 8
  %t96.i.1 = getelementptr inbounds nuw i64, ptr %t7.i, i64 %t115.i
  %t97.i.1 = load i64, ptr %t96.i.1, align 8
  %t108.i.1 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t94.i.1, i64 %t97.i.1)
  %t110.i.1 = extractvalue { i64, i1 } %t108.i.1, 1
  br i1 %t110.i.1, label %overflow.add.46.i, label %overflow.ok.47.i.1

overflow.ok.47.i.1:                               ; preds = %overflow.ok.49.i
  %t112.i = extractvalue { i64, i1 } %t111.i, 0
  %t109.i.1 = extractvalue { i64, i1 } %t108.i.1, 0
  %t111.i.1 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t112.i, i64 %t109.i.1)
  %t113.i.1 = extractvalue { i64, i1 } %t111.i.1, 1
  br i1 %t113.i.1, label %overflow.add.48.i, label %overflow.ok.49.i.1

overflow.ok.49.i.1:                               ; preds = %overflow.ok.47.i.1
  %t112.i.1 = extractvalue { i64, i1 } %t111.i.1, 0
  %t115.i.1 = add nuw nsw i64 %foreach.idx.90.020.i, 2
  %exitcond23.not.i.1 = icmp eq i64 %t115.i.1, 32
  br i1 %exitcond23.not.i.1, label %archx_fn_advance.exit, label %foreach.body.43.i

archx_fn_advance.exit:                            ; preds = %overflow.ok.49.i.1
  tail call void @free(ptr %t22.i)
  tail call void @free(ptr %t12.i)
  tail call void @free(ptr nonnull %t7.i)
  tail call void @free(ptr nonnull %t3.i)
  %t1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t112.i.1)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %func.region.i)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %func.region.i, i8 0, i64 32, i1 false)
  %res.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 512)
  %31 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 16
  store <2 x i64> splat (i64 1), ptr %res.i.i, align 16
  store <2 x i64> splat (i64 1), ptr %31, align 16
  %32 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 32
  %33 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 48
  store <2 x i64> splat (i64 1), ptr %32, align 16
  store <2 x i64> splat (i64 1), ptr %33, align 16
  %34 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 64
  %35 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 80
  store <2 x i64> splat (i64 1), ptr %34, align 16
  store <2 x i64> splat (i64 1), ptr %35, align 16
  %36 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 96
  %37 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 112
  store <2 x i64> splat (i64 1), ptr %36, align 16
  store <2 x i64> splat (i64 1), ptr %37, align 16
  %38 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 128
  %39 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 144
  store <2 x i64> splat (i64 1), ptr %38, align 16
  store <2 x i64> splat (i64 1), ptr %39, align 16
  %40 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 160
  %41 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 176
  store <2 x i64> splat (i64 1), ptr %40, align 16
  store <2 x i64> splat (i64 1), ptr %41, align 16
  %42 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 192
  %43 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 208
  store <2 x i64> splat (i64 1), ptr %42, align 16
  store <2 x i64> splat (i64 1), ptr %43, align 16
  %44 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 224
  %45 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 240
  store <2 x i64> splat (i64 1), ptr %44, align 16
  store <2 x i64> splat (i64 1), ptr %45, align 16
  %46 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 256
  %47 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 272
  store <2 x i64> splat (i64 1), ptr %46, align 16
  store <2 x i64> splat (i64 1), ptr %47, align 16
  %48 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 288
  %49 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 304
  store <2 x i64> splat (i64 1), ptr %48, align 16
  store <2 x i64> splat (i64 1), ptr %49, align 16
  %50 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 320
  %51 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 336
  store <2 x i64> splat (i64 1), ptr %50, align 16
  store <2 x i64> splat (i64 1), ptr %51, align 16
  %52 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 352
  %53 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 368
  store <2 x i64> splat (i64 1), ptr %52, align 16
  store <2 x i64> splat (i64 1), ptr %53, align 16
  %54 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 384
  %55 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 400
  store <2 x i64> splat (i64 1), ptr %54, align 16
  store <2 x i64> splat (i64 1), ptr %55, align 16
  %56 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 416
  %57 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 432
  store <2 x i64> splat (i64 1), ptr %56, align 16
  store <2 x i64> splat (i64 1), ptr %57, align 16
  %58 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 448
  %59 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 464
  store <2 x i64> splat (i64 1), ptr %58, align 16
  store <2 x i64> splat (i64 1), ptr %59, align 16
  %60 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 480
  %61 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 496
  store <2 x i64> splat (i64 1), ptr %60, align 16
  store <2 x i64> splat (i64 1), ptr %61, align 16
  %.fca.1.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 8
  %.fca.2.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 16
  %cur.i.i.i = load ptr, ptr %func.region.i, align 8
  %end.i.i.i = load ptr, ptr %.fca.1.gep.i, align 8
  %cur_i.i.i.i = ptrtoint ptr %cur.i.i.i to i64
  %end_i.i.i.i = ptrtoint ptr %end.i.i.i to i64
  %rem.i.i.i = sub i64 %end_i.i.i.i, %cur_i.i.i.i
  %fits.not.i.i.i = icmp slt i64 %rem.i.i.i, 32
  br i1 %fits.not.i.i.i, label %fallback.i.i.i, label %fast.i.i.i

fast.i.i.i:                                       ; preds = %archx_fn_advance.exit
  %next.i.i.i = getelementptr inbounds nuw i8, ptr %cur.i.i.i, i64 32
  store ptr %next.i.i.i, ptr %func.region.i, align 8
  br label %if.then.11.i

fallback.i.i.i:                                   ; preds = %archx_fn_advance.exit
  %res.i.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 32)
  %.pre.i = ptrtoint ptr %res.i.i.i to i64
  %cur.i.i26.i.pre = load ptr, ptr %func.region.i, align 8
  %end.i.i27.i.pre = load ptr, ptr %.fca.1.gep.i, align 8
  %.pre = ptrtoint ptr %end.i.i27.i.pre to i64
  br label %if.then.11.i

if.then.11.i:                                     ; preds = %fallback.i.i.i, %fast.i.i.i
  %end_i.i.i29.i.pre-phi = phi i64 [ %.pre, %fallback.i.i.i ], [ %end_i.i.i.i, %fast.i.i.i ]
  %cur.i.i26.i = phi ptr [ %cur.i.i26.i.pre, %fallback.i.i.i ], [ %next.i.i.i, %fast.i.i.i ]
  %rp_i.i.pre-phi.i = phi i64 [ %.pre.i, %fallback.i.i.i ], [ %cur_i.i.i.i, %fast.i.i.i ]
  %common.ret.op.i.i.i = phi ptr [ %res.i.i.i, %fallback.i.i.i ], [ %cur.i.i.i, %fast.i.i.i ]
  store i32 1869636978, ptr %common.ret.op.i.i.i, align 16
  %atmp.i.sroa.4.0.common.ret.op.i.i.sroa_idx.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i.i, i64 4
  store i24 3830898, ptr %atmp.i.sroa.4.0.common.ret.op.i.i.sroa_idx.i, align 4
  %dst_b.i.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i.i, i64 7
  store i32 1701603693, ptr %dst_b.i.i, align 1
  %btmp.i.sroa.4.0.dst_b.i.sroa_idx.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i.i, i64 11
  store i48 58709760767091, ptr %btmp.i.sroa.4.0.dst_b.i.sroa_idx.i, align 1
  %araw.i.i = and i64 %rp_i.i.pre-phi.i, -4
  %alptr.i.i = inttoptr i64 %araw.i.i to ptr
  %cur_i.i.i28.i = ptrtoint ptr %cur.i.i26.i to i64
  %rem.i.i30.i = sub i64 %end_i.i.i29.i.pre-phi, %cur_i.i.i28.i
  %fits.not.i.i31.i = icmp slt i64 %rem.i.i30.i, 32
  br i1 %fits.not.i.i31.i, label %fallback.i.i45.i, label %archx_str_concat.exit48.i

fallback.i.i45.i:                                 ; preds = %if.then.11.i
  %res.i.i46.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 32)
  %.pre68.i = ptrtoint ptr %res.i.i46.i to i64
  br label %archx_str_concat.exit48.i

archx_str_concat.exit48.i:                        ; preds = %fallback.i.i45.i, %if.then.11.i
  %rp_i.i35.pre-phi.i = phi i64 [ %.pre68.i, %fallback.i.i45.i ], [ %cur_i.i.i28.i, %if.then.11.i ]
  %common.ret.op.i.i34.i = phi ptr [ %res.i.i46.i, %fallback.i.i45.i ], [ %cur.i.i26.i, %if.then.11.i ]
  %rtagged.i36.i = or disjoint i64 %rp_i.i35.pre-phi.i, 2
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(17) %common.ret.op.i.i34.i, ptr noundef nonnull align 4 dereferenceable(17) %alptr.i.i, i64 17, i1 false)
  %dst_b.i37.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i34.i, i64 17
  store i24 7040826, ptr %dst_b.i37.i, align 1
  %pref32.i38.i = load i32, ptr %common.ret.op.i.i34.i, align 16
  %pref64.i39.i = zext i32 %pref32.i38.i to i64
  %pref_sh.i40.i = shl nuw i64 %pref64.i39.i, 32
  %w0_out.i41.i = or disjoint i64 %pref_sh.i40.i, 20
  %ls0.i42.i = insertvalue %ArchxStr poison, i64 %w0_out.i41.i, 0
  %ls1.i43.i = insertvalue %ArchxStr %ls0.i42.i, i64 %rtagged.i36.i, 1
  %tag.i54.i = and i64 %rtagged.i36.i, 3
  %is_reg.i.i = icmp eq i64 %tag.i54.i, 2
  br i1 %is_reg.i.i, label %dup_heap.i.i, label %archx_str_promote.exit.i

dup_heap.i.i:                                     ; preds = %archx_str_concat.exit48.i
  %dst.i.i = tail call noalias align 16 dereferenceable_or_null(20) ptr @malloc(i64 20)
  %isnull.i.i = icmp eq ptr %dst.i.i, null
  br i1 %isnull.i.i, label %oom.i.i, label %copy.i.i

oom.i.i:                                          ; preds = %dup_heap.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i.i:                                         ; preds = %dup_heap.i.i
  %src_i.i.i = and i64 %rp_i.i35.pre-phi.i, -4
  %src.i.i = inttoptr i64 %src_i.i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(20) %dst.i.i, ptr noundef nonnull align 4 dereferenceable(20) %src.i.i, i64 20, i1 false)
  %dst_i.i.i = ptrtoint ptr %dst.i.i to i64
  %tagged.i.i = or disjoint i64 %dst_i.i.i, 1
  %out.i.i = insertvalue %ArchxStr %ls1.i43.i, i64 %tagged.i.i, 1
  br label %archx_str_promote.exit.i

archx_str_promote.exit.i:                         ; preds = %copy.i.i, %archx_str_concat.exit48.i
  %common.ret.op.i52.i = phi %ArchxStr [ %out.i.i, %copy.i.i ], [ %ls1.i43.i, %archx_str_concat.exit48.i ]
  %tag.i.i = and i64 %rp_i.i.pre-phi.i, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  br i1 %owned.not.i.i, label %archx_str_drop.exit.i, label %do_free.i.i

do_free.i.i:                                      ; preds = %archx_str_promote.exit.i
  %raw.i.i = or disjoint i64 %araw.i.i, 2
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  tail call void @free(ptr nonnull %ptr.i.i)
  br label %archx_str_drop.exit.i

archx_str_drop.exit.i:                            ; preds = %do_free.i.i, %archx_str_promote.exit.i
  %t41.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i55.i = icmp eq ptr %t41.i, null
  br i1 %empty.i55.i, label %archx_fn_format_report.exit, label %loop.i.i

loop.i.i:                                         ; preds = %archx_str_drop.exit.i, %loop.i.i
  %cur.i56.i = phi ptr [ %next.i57.i, %loop.i.i ], [ %t41.i, %archx_str_drop.exit.i ]
  %next.i57.i = load ptr, ptr %cur.i56.i, align 8
  tail call void @free(ptr nonnull %cur.i56.i)
  %more.not.i.i = icmp eq ptr %next.i57.i, null
  br i1 %more.not.i.i, label %archx_fn_format_report.exit, label %loop.i.i

archx_fn_format_report.exit:                      ; preds = %loop.i.i, %archx_str_drop.exit.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  %w0.i3 = extractvalue %ArchxStr %common.ret.op.i52.i, 0
  %w1.i4 = extractvalue %ArchxStr %common.ret.op.i52.i, 1
  %len.i5 = and i64 %w0.i3, 4294967295
  %short.i = icmp samesign ult i64 %len.i5, 13
  br i1 %short.i, label %emit.i, label %emit.thread.i

emit.thread.i:                                    ; preds = %archx_fn_format_report.exit
  %raw.i6 = and i64 %w1.i4, -4
  %lptr.i = inttoptr i64 %raw.i6 to ptr
  br label %chk_nul.i

emit.i:                                           ; preds = %archx_fn_format_report.exit
  %p4.i = lshr i64 %w0.i3, 32
  %p4_32.i = trunc nuw i64 %p4.i to i32
  store i32 %p4_32.i, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 %w1.i4, ptr %tmp4.i, align 4
  %pos.not.i = icmp eq i64 %len.i5, 0
  br i1 %pos.not.i, label %do_nl.i, label %chk_nul.i

chk_nul.i:                                        ; preds = %emit.i, %emit.thread.i
  %data3.i = phi ptr [ %lptr.i, %emit.thread.i ], [ %tmp.i, %emit.i ]
  %nul.i = call ptr @memchr(ptr nonnull %data3.i, i32 0, i64 %len.i5)
  %has_nul.not.i = icmp eq ptr %nul.i, null
  br i1 %has_nul.not.i, label %fast_printf.i, label %byte_loop.i

fast_printf.i:                                    ; preds = %chk_nul.i
  %len32.i = trunc i64 %w0.i3 to i32
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i, ptr nonnull %data3.i)
  br label %archx_str_print.exit

byte_loop.i:                                      ; preds = %chk_nul.i, %byte_loop.i
  %bi.i = phi i64 [ %bnext.i, %byte_loop.i ], [ 0, %chk_nul.i ]
  %bp.i = getelementptr inbounds nuw i8, ptr %data3.i, i64 %bi.i
  %ch8.i = load i8, ptr %bp.i, align 1
  %ch32.i = zext i8 %ch8.i to i32
  %pc.i = tail call i32 @putchar(i32 %ch32.i)
  %bnext.i = add nuw nsw i64 %bi.i, 1
  %exitcond.not.i7 = icmp eq i64 %bnext.i, %len.i5
  br i1 %exitcond.not.i7, label %do_nl.i, label %byte_loop.i

do_nl.i:                                          ; preds = %byte_loop.i, %emit.i
  %nc.i = tail call i32 @putchar(i32 10)
  br label %archx_str_print.exit

archx_str_print.exit:                             ; preds = %fast_printf.i, %do_nl.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %tag.i = and i64 %w1.i4, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %short.i, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %archx_str_drop.exit, label %do_free.i

do_free.i:                                        ; preds = %archx_str_print.exit
  %raw.i = and i64 %w1.i4, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  call void @free(ptr %ptr.i)
  br label %archx_str_drop.exit

archx_str_drop.exit:                              ; preds = %archx_str_print.exit, %do_free.i
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

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #8

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) #9

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @memchr(ptr captures(none), i32, i64) local_unnamed_addr #10

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #4

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #11

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #4

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #12

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #12

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #13

attributes #0 = { nounwind }
attributes #1 = { nofree noinline nounwind }
attributes #2 = { noinline nounwind }
attributes #3 = { cold nofree noreturn nounwind }
attributes #4 = { nofree nounwind }
attributes #5 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #6 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #7 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #8 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #9 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #10 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #11 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #12 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #13 = { nocallback nofree nounwind willreturn memory(argmem: write) }
