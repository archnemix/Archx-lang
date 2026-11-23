; ModuleID = '/tmp/bench_nbody_float.ll'
source_filename = "/tmp/bench_nbody_float.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@str = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
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
  %t15.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @calloc(i64 100000, i64 8)
  %t16.i = icmp eq ptr %t15.i, null
  br i1 %t16.i, label %calloc.oom.9.i, label %calloc.ok.8.i

calloc.oom.9.i:                                   ; preds = %calloc.ok.6.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.8.i:                                    ; preds = %calloc.ok.6.i
  %t19.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @calloc(i64 100000, i64 8)
  %t20.i = icmp eq ptr %t19.i, null
  br i1 %t20.i, label %calloc.oom.11.i, label %calloc.ok.10.i

calloc.oom.11.i:                                  ; preds = %calloc.ok.8.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.10.i:                                   ; preds = %calloc.ok.8.i
  %t23.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @calloc(i64 100000, i64 8)
  %t24.i = icmp eq ptr %t23.i, null
  br i1 %t24.i, label %calloc.oom.13.i, label %calloc.ok.12.i

calloc.oom.13.i:                                  ; preds = %calloc.ok.10.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.12.i:                                   ; preds = %calloc.ok.10.i
  %t27.i = tail call noalias align 16 dereferenceable_or_null(800000) ptr @calloc(i64 100000, i64 8)
  %t28.i = icmp eq ptr %t27.i, null
  br i1 %t28.i, label %calloc.oom.15.i, label %vector.body

vector.body:                                      ; preds = %calloc.ok.12.i, %vector.body
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %calloc.ok.12.i ]
  %vec.ind = phi <2 x i64> [ %vec.ind.next, %vector.body ], [ <i64 0, i64 1>, %calloc.ok.12.i ]
  %0 = add nuw nsw <2 x i64> %vec.ind, splat (i64 1)
  %1 = uitofp nneg <2 x i64> %0 to <2 x double>
  %2 = getelementptr inbounds nuw double, ptr %t3.i, i64 %index
  %3 = fmul <2 x double> %1, splat (double 1.000000e-03)
  store <2 x double> %3, ptr %2, align 16
  %4 = getelementptr inbounds nuw double, ptr %t7.i, i64 %index
  %5 = fmul <2 x double> %1, splat (double 2.000000e-03)
  store <2 x double> %5, ptr %4, align 16
  %6 = getelementptr inbounds nuw double, ptr %t11.i, i64 %index
  %7 = fmul <2 x double> %1, splat (double 5.000000e-04)
  store <2 x double> %7, ptr %6, align 16
  %8 = getelementptr inbounds nuw double, ptr %t15.i, i64 %index
  store <2 x double> splat (double 1.000000e-02), ptr %8, align 16
  %9 = getelementptr inbounds nuw double, ptr %t19.i, i64 %index
  store <2 x double> splat (double -2.000000e-02), ptr %9, align 16
  %10 = getelementptr inbounds nuw double, ptr %t23.i, i64 %index
  store <2 x double> splat (double 5.000000e-03), ptr %10, align 16
  %11 = getelementptr inbounds nuw double, ptr %t27.i, i64 %index
  %12 = fmul <2 x double> %1, splat (double 1.000000e-04)
  %13 = fadd <2 x double> %12, splat (double 1.000000e+00)
  store <2 x double> %13, ptr %11, align 16
  %index.next = add nuw i64 %index, 2
  %vec.ind.next = add <2 x i64> %vec.ind, splat (i64 2)
  %14 = icmp eq i64 %index.next, 100000
  br i1 %14, label %vector.ph82, label %vector.body, !llvm.loop !0

calloc.oom.15.i:                                  ; preds = %calloc.ok.12.i
  tail call fastcc void @archx_oom_fail()
  unreachable

vector.ph82:                                      ; preds = %vector.body, %for.step.22.i
  %for._s.57.028.i = phi i64 [ %t122.i, %for.step.22.i ], [ 0, %vector.body ]
  br label %vector.body83

vector.body83:                                    ; preds = %vector.body83, %vector.ph82
  %index84 = phi i64 [ 0, %vector.ph82 ], [ %index.next90, %vector.body83 ]
  %15 = getelementptr inbounds nuw double, ptr %t3.i, i64 %index84
  %wide.load = load <2 x double>, ptr %15, align 16
  %16 = getelementptr inbounds nuw double, ptr %t7.i, i64 %index84
  %wide.load85 = load <2 x double>, ptr %16, align 16
  %17 = getelementptr inbounds nuw double, ptr %t11.i, i64 %index84
  %wide.load86 = load <2 x double>, ptr %17, align 16
  %18 = fmul <2 x double> %wide.load, %wide.load
  %19 = fmul <2 x double> %wide.load85, %wide.load85
  %20 = fadd <2 x double> %18, %19
  %21 = fmul <2 x double> %wide.load86, %wide.load86
  %22 = fadd <2 x double> %20, %21
  %23 = fadd <2 x double> %22, splat (double 1.000000e+00)
  %24 = tail call <2 x double> @llvm.sqrt.v2f64(<2 x double> %23)
  %25 = fdiv <2 x double> splat (double 1.000000e-02), %24
  %26 = getelementptr inbounds nuw double, ptr %t15.i, i64 %index84
  %wide.load87 = load <2 x double>, ptr %26, align 16
  %27 = fmul <2 x double> %wide.load, %25
  %28 = fsub <2 x double> %wide.load87, %27
  store <2 x double> %28, ptr %26, align 16
  %29 = getelementptr inbounds nuw double, ptr %t19.i, i64 %index84
  %wide.load88 = load <2 x double>, ptr %29, align 16
  %30 = fmul <2 x double> %wide.load85, %25
  %31 = fsub <2 x double> %wide.load88, %30
  store <2 x double> %31, ptr %29, align 16
  %32 = getelementptr inbounds nuw double, ptr %t23.i, i64 %index84
  %wide.load89 = load <2 x double>, ptr %32, align 16
  %33 = fmul <2 x double> %wide.load86, %25
  %34 = fsub <2 x double> %wide.load89, %33
  store <2 x double> %34, ptr %32, align 16
  %35 = fmul <2 x double> %28, splat (double 1.000000e-02)
  %36 = fadd <2 x double> %wide.load, %35
  store <2 x double> %36, ptr %15, align 16
  %37 = fmul <2 x double> %31, splat (double 1.000000e-02)
  %38 = fadd <2 x double> %wide.load85, %37
  store <2 x double> %38, ptr %16, align 16
  %39 = fmul <2 x double> %34, splat (double 1.000000e-02)
  %40 = fadd <2 x double> %wide.load86, %39
  store <2 x double> %40, ptr %17, align 16
  %index.next90 = add nuw i64 %index84, 2
  %41 = icmp eq i64 %index.next90, 100000
  br i1 %41, label %for.step.22.i, label %vector.body83, !llvm.loop !3

for.step.22.i:                                    ; preds = %vector.body83
  %t122.i = add nuw nsw i64 %for._s.57.028.i, 1
  %exitcond32.not.i = icmp eq i64 %t122.i, 60
  br i1 %exitcond32.not.i, label %for.body.29.i, label %vector.ph82

for.body.29.i:                                    ; preds = %for.step.22.i, %for.body.29.i
  %for.i.124.030.i = phi i64 [ %t153.i.1, %for.body.29.i ], [ 0, %for.step.22.i ]
  %var.ke.123.029.i = phi double [ %t151.i.1, %for.body.29.i ], [ 0.000000e+00, %for.step.22.i ]
  %t138.i = getelementptr inbounds nuw double, ptr %t15.i, i64 %for.i.124.030.i
  %t139.i = load double, ptr %t138.i, align 16
  %t141.i = getelementptr inbounds nuw double, ptr %t19.i, i64 %for.i.124.030.i
  %t142.i = load double, ptr %t141.i, align 16
  %t144.i = getelementptr inbounds nuw double, ptr %t23.i, i64 %for.i.124.030.i
  %t145.i = load double, ptr %t144.i, align 16
  %t147.i = getelementptr inbounds nuw double, ptr %t27.i, i64 %for.i.124.030.i
  %t148.i = load double, ptr %t147.i, align 16
  %t1.i.i = fmul double %t148.i, 5.000000e-01
  %t4.i.i = fmul double %t139.i, %t139.i
  %t7.i.i = fmul double %t142.i, %t142.i
  %t8.i.i = fadd double %t4.i.i, %t7.i.i
  %t11.i.i = fmul double %t145.i, %t145.i
  %t12.i.i = fadd double %t11.i.i, %t8.i.i
  %t13.i.i = fmul double %t1.i.i, %t12.i.i
  %t151.i = fadd double %var.ke.123.029.i, %t13.i.i
  %t153.i = or disjoint i64 %for.i.124.030.i, 1
  %t138.i.1 = getelementptr inbounds nuw double, ptr %t15.i, i64 %t153.i
  %t139.i.1 = load double, ptr %t138.i.1, align 8
  %t141.i.1 = getelementptr inbounds nuw double, ptr %t19.i, i64 %t153.i
  %t142.i.1 = load double, ptr %t141.i.1, align 8
  %t144.i.1 = getelementptr inbounds nuw double, ptr %t23.i, i64 %t153.i
  %t145.i.1 = load double, ptr %t144.i.1, align 8
  %t147.i.1 = getelementptr inbounds nuw double, ptr %t27.i, i64 %t153.i
  %t148.i.1 = load double, ptr %t147.i.1, align 8
  %t1.i.i.1 = fmul double %t148.i.1, 5.000000e-01
  %t4.i.i.1 = fmul double %t139.i.1, %t139.i.1
  %t7.i.i.1 = fmul double %t142.i.1, %t142.i.1
  %t8.i.i.1 = fadd double %t4.i.i.1, %t7.i.i.1
  %t11.i.i.1 = fmul double %t145.i.1, %t145.i.1
  %t12.i.i.1 = fadd double %t11.i.i.1, %t8.i.i.1
  %t13.i.i.1 = fmul double %t1.i.i.1, %t12.i.i.1
  %t151.i.1 = fadd double %t151.i, %t13.i.i.1
  %t153.i.1 = add nuw nsw i64 %for.i.124.030.i, 2
  %exitcond33.not.i.1 = icmp eq i64 %t153.i.1, 100000
  br i1 %exitcond33.not.i.1, label %archx_fn_central_field_sim.exit, label %for.body.29.i

archx_fn_central_field_sim.exit:                  ; preds = %for.body.29.i
  %t155.i = fmul double %t151.i.1, 1.000000e+02
  %t156.i = tail call i64 @llvm.fptosi.sat.i64.f64(double %t155.i)
  tail call void @free(ptr nonnull %t27.i)
  tail call void @free(ptr nonnull %t23.i)
  tail call void @free(ptr nonnull %t19.i)
  tail call void @free(ptr nonnull %t15.i)
  tail call void @free(ptr nonnull %t11.i)
  tail call void @free(ptr nonnull %t7.i)
  tail call void @free(ptr nonnull %t3.i)
  %t1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t156.i)
  %t3.i1 = tail call noalias align 16 dereferenceable_or_null(512) ptr @calloc(i64 64, i64 8)
  %t4.i2 = icmp eq ptr %t3.i1, null
  br i1 %t4.i2, label %calloc.oom.3.i80, label %calloc.ok.2.i3

calloc.oom.3.i80:                                 ; preds = %archx_fn_central_field_sim.exit
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.2.i3:                                   ; preds = %archx_fn_central_field_sim.exit
  %t7.i4 = tail call noalias align 16 dereferenceable_or_null(512) ptr @calloc(i64 64, i64 8)
  %t8.i5 = icmp eq ptr %t7.i4, null
  br i1 %t8.i5, label %calloc.oom.5.i79, label %calloc.ok.4.i6

calloc.oom.5.i79:                                 ; preds = %calloc.ok.2.i3
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.4.i6:                                   ; preds = %calloc.ok.2.i3
  %t11.i7 = tail call noalias align 16 dereferenceable_or_null(512) ptr @calloc(i64 64, i64 8)
  %t12.i8 = icmp eq ptr %t11.i7, null
  br i1 %t12.i8, label %calloc.oom.7.i78, label %calloc.ok.6.i9

calloc.oom.7.i78:                                 ; preds = %calloc.ok.4.i6
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.6.i9:                                   ; preds = %calloc.ok.4.i6
  %t15.i10 = tail call noalias align 16 dereferenceable_or_null(512) ptr @calloc(i64 64, i64 8)
  %t16.i11 = icmp eq ptr %t15.i10, null
  br i1 %t16.i11, label %calloc.oom.9.i77, label %calloc.ok.8.i12

calloc.oom.9.i77:                                 ; preds = %calloc.ok.6.i9
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.8.i12:                                  ; preds = %calloc.ok.6.i9
  %t19.i13 = tail call noalias align 16 dereferenceable_or_null(512) ptr @calloc(i64 64, i64 8)
  %t20.i14 = icmp eq ptr %t19.i13, null
  br i1 %t20.i14, label %calloc.oom.11.i76, label %calloc.ok.10.i15

calloc.oom.11.i76:                                ; preds = %calloc.ok.8.i12
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.10.i15:                                 ; preds = %calloc.ok.8.i12
  %t23.i16 = tail call noalias align 16 dereferenceable_or_null(512) ptr @calloc(i64 64, i64 8)
  %t24.i17 = icmp eq ptr %t23.i16, null
  br i1 %t24.i17, label %calloc.oom.13.i75, label %calloc.ok.12.i18

calloc.oom.13.i75:                                ; preds = %calloc.ok.10.i15
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.12.i18:                                 ; preds = %calloc.ok.10.i15
  %t27.i19 = tail call noalias align 16 dereferenceable_or_null(512) ptr @calloc(i64 64, i64 8)
  %t28.i20 = icmp eq ptr %t27.i19, null
  br i1 %t28.i20, label %calloc.oom.15.i74, label %vector.body95

vector.body95:                                    ; preds = %calloc.ok.12.i18, %vector.body95
  %index96 = phi i64 [ %index.next98, %vector.body95 ], [ 0, %calloc.ok.12.i18 ]
  %vec.ind97 = phi <2 x i64> [ %vec.ind.next99, %vector.body95 ], [ <i64 0, i64 1>, %calloc.ok.12.i18 ]
  %42 = add nuw nsw <2 x i64> %vec.ind97, splat (i64 1)
  %43 = uitofp nneg <2 x i64> %42 to <2 x double>
  %44 = getelementptr inbounds nuw double, ptr %t3.i1, i64 %index96
  %45 = fmul <2 x double> %43, splat (double 1.000000e-01)
  store <2 x double> %45, ptr %44, align 16
  %46 = getelementptr inbounds nuw double, ptr %t7.i4, i64 %index96
  %47 = fmul <2 x double> %43, splat (double -7.000000e-02)
  store <2 x double> %47, ptr %46, align 16
  %48 = getelementptr inbounds nuw double, ptr %t11.i7, i64 %index96
  %49 = fmul <2 x double> %43, splat (double 3.000000e-02)
  store <2 x double> %49, ptr %48, align 16
  %50 = getelementptr inbounds nuw double, ptr %t27.i19, i64 %index96
  %51 = fmul <2 x double> %43, splat (double 1.000000e-02)
  %52 = fadd <2 x double> %51, splat (double 5.000000e-01)
  store <2 x double> %52, ptr %50, align 16
  %index.next98 = add nuw i64 %index96, 2
  %vec.ind.next99 = add <2 x i64> %vec.ind97, splat (i64 2)
  %53 = icmp eq i64 %index.next98, 64
  br i1 %53, label %for.cond.24.preheader.i32, label %vector.body95, !llvm.loop !4

calloc.oom.15.i74:                                ; preds = %calloc.ok.12.i18
  tail call fastcc void @archx_oom_fail()
  unreachable

for.cond.24.preheader.i32:                        ; preds = %vector.body95, %for.step.22.i66
  %for._s.57.039.i = phi i64 [ %t161.i, %for.step.22.i66 ], [ 0, %vector.body95 ]
  br label %for.body.25.i33

for.body.25.i33:                                  ; preds = %for.end.31.i, %for.cond.24.preheader.i32
  %for.i.60.037.i = phi i64 [ 0, %for.cond.24.preheader.i32 ], [ %t130.i, %for.end.31.i ]
  %t64.i34 = getelementptr inbounds nuw double, ptr %t3.i1, i64 %for.i.60.037.i
  %t65.i35 = load double, ptr %t64.i34, align 8
  %t67.i36 = getelementptr inbounds nuw double, ptr %t7.i4, i64 %for.i.60.037.i
  %t68.i37 = load double, ptr %t67.i36, align 8
  %t70.i38 = getelementptr inbounds nuw double, ptr %t11.i7, i64 %for.i.60.037.i
  %t71.i39 = load double, ptr %t70.i38, align 8
  %54 = insertelement <2 x double> poison, double %t71.i39, i64 0
  %55 = insertelement <2 x double> %54, double %t68.i37, i64 1
  br label %for.body.29.i40

for.body.29.i40:                                  ; preds = %for.body.29.i40, %for.body.25.i33
  %for.j.75.036.i = phi i64 [ 0, %for.body.25.i33 ], [ %t113.i, %for.body.29.i40 ]
  %var.dvx.72.033.i = phi double [ 0.000000e+00, %for.body.25.i33 ], [ %t105.i, %for.body.29.i40 ]
  %56 = phi <2 x double> [ zeroinitializer, %for.body.25.i33 ], [ %66, %for.body.29.i40 ]
  %t79.i41 = getelementptr inbounds nuw double, ptr %t3.i1, i64 %for.j.75.036.i
  %t80.i = load double, ptr %t79.i41, align 8
  %t81.i42 = fsub double %t80.i, %t65.i35
  %t83.i43 = getelementptr inbounds nuw double, ptr %t7.i4, i64 %for.j.75.036.i
  %t84.i44 = load double, ptr %t83.i43, align 8
  %t87.i45 = getelementptr inbounds nuw double, ptr %t11.i7, i64 %for.j.75.036.i
  %t88.i46 = load double, ptr %t87.i45, align 8
  %t90.i = fmul double %t81.i42, %t81.i42
  %t97.i = getelementptr inbounds nuw double, ptr %t27.i19, i64 %for.j.75.036.i
  %t98.i = load double, ptr %t97.i, align 8
  %t99.i = fmul double %t98.i, 5.000000e-03
  %57 = insertelement <2 x double> poison, double %t88.i46, i64 0
  %58 = insertelement <2 x double> %57, double %t84.i44, i64 1
  %59 = fsub <2 x double> %58, %55
  %60 = fmul <2 x double> %59, %59
  %61 = extractelement <2 x double> %60, i64 1
  %t92.i49 = fadd double %t90.i, %61
  %62 = extractelement <2 x double> %60, i64 0
  %t94.i51 = fadd double %t92.i49, %62
  %t95.i = fadd double %t94.i51, 5.000000e-02
  %t100.i = tail call double @llvm.sqrt.f64(double %t95.i)
  %t101.i52 = fmul double %t95.i, %t100.i
  %t102.i53 = fdiv double %t99.i, %t101.i52
  %t104.i = fmul double %t81.i42, %t102.i53
  %t105.i = fadd double %var.dvx.72.033.i, %t104.i
  %63 = insertelement <2 x double> poison, double %t102.i53, i64 0
  %64 = shufflevector <2 x double> %63, <2 x double> poison, <2 x i32> zeroinitializer
  %65 = fmul <2 x double> %59, %64
  %66 = fadd <2 x double> %56, %65
  %t113.i = add nuw nsw i64 %for.j.75.036.i, 1
  %exitcond42.not.i = icmp eq i64 %t113.i, 64
  br i1 %exitcond42.not.i, label %for.end.31.i, label %for.body.29.i40

for.end.31.i:                                     ; preds = %for.body.29.i40
  %t115.i = getelementptr inbounds nuw double, ptr %t15.i10, i64 %for.i.60.037.i
  %t116.i = load double, ptr %t115.i, align 8
  %t118.i55 = fadd double %t105.i, %t116.i
  store double %t118.i55, ptr %t115.i, align 8
  %t120.i56 = getelementptr inbounds nuw double, ptr %t19.i13, i64 %for.i.60.037.i
  %t121.i = load double, ptr %t120.i56, align 8
  %67 = extractelement <2 x double> %66, i64 1
  %t123.i = fadd double %67, %t121.i
  store double %t123.i, ptr %t120.i56, align 8
  %t125.i = getelementptr inbounds nuw double, ptr %t23.i16, i64 %for.i.60.037.i
  %t126.i = load double, ptr %t125.i, align 8
  %68 = extractelement <2 x double> %66, i64 0
  %t128.i = fadd double %68, %t126.i
  store double %t128.i, ptr %t125.i, align 8
  %t130.i = add nuw nsw i64 %for.i.60.037.i, 1
  %exitcond43.not.i = icmp eq i64 %t130.i, 64
  br i1 %exitcond43.not.i, label %vector.body104, label %for.body.25.i33

vector.body104:                                   ; preds = %for.end.31.i, %vector.body104
  %index105 = phi i64 [ %index.next112, %vector.body104 ], [ 0, %for.end.31.i ]
  %69 = getelementptr inbounds nuw double, ptr %t3.i1, i64 %index105
  %wide.load106 = load <2 x double>, ptr %69, align 16
  %70 = getelementptr inbounds nuw double, ptr %t15.i10, i64 %index105
  %wide.load107 = load <2 x double>, ptr %70, align 16
  %71 = fmul <2 x double> %wide.load107, splat (double 5.000000e-03)
  %72 = fadd <2 x double> %wide.load106, %71
  store <2 x double> %72, ptr %69, align 16
  %73 = getelementptr inbounds nuw double, ptr %t7.i4, i64 %index105
  %wide.load108 = load <2 x double>, ptr %73, align 16
  %74 = getelementptr inbounds nuw double, ptr %t19.i13, i64 %index105
  %wide.load109 = load <2 x double>, ptr %74, align 16
  %75 = fmul <2 x double> %wide.load109, splat (double 5.000000e-03)
  %76 = fadd <2 x double> %wide.load108, %75
  store <2 x double> %76, ptr %73, align 16
  %77 = getelementptr inbounds nuw double, ptr %t11.i7, i64 %index105
  %wide.load110 = load <2 x double>, ptr %77, align 16
  %78 = getelementptr inbounds nuw double, ptr %t23.i16, i64 %index105
  %wide.load111 = load <2 x double>, ptr %78, align 16
  %79 = fmul <2 x double> %wide.load111, splat (double 5.000000e-03)
  %80 = fadd <2 x double> %wide.load110, %79
  store <2 x double> %80, ptr %77, align 16
  %index.next112 = add nuw i64 %index105, 2
  %81 = icmp eq i64 %index.next112, 64
  br i1 %81, label %for.step.22.i66, label %vector.body104, !llvm.loop !5

for.step.22.i66:                                  ; preds = %vector.body104
  %t161.i = add nuw nsw i64 %for._s.57.039.i, 1
  %exitcond45.not.i = icmp eq i64 %t161.i, 2000
  br i1 %exitcond45.not.i, label %for.body.37.i, label %for.cond.24.preheader.i32

for.body.37.i:                                    ; preds = %for.step.22.i66, %for.body.37.i
  %for.i.163.041.i = phi i64 [ %t192.i.1, %for.body.37.i ], [ 0, %for.step.22.i66 ]
  %var.ke.162.040.i = phi double [ %t190.i.1, %for.body.37.i ], [ 0.000000e+00, %for.step.22.i66 ]
  %t177.i = getelementptr inbounds nuw double, ptr %t15.i10, i64 %for.i.163.041.i
  %t178.i = load double, ptr %t177.i, align 16
  %t180.i = getelementptr inbounds nuw double, ptr %t19.i13, i64 %for.i.163.041.i
  %t181.i = load double, ptr %t180.i, align 16
  %t183.i = getelementptr inbounds nuw double, ptr %t23.i16, i64 %for.i.163.041.i
  %t184.i = load double, ptr %t183.i, align 16
  %t186.i = getelementptr inbounds nuw double, ptr %t27.i19, i64 %for.i.163.041.i
  %t187.i = load double, ptr %t186.i, align 16
  %t1.i.i67 = fmul double %t187.i, 5.000000e-01
  %t4.i.i68 = fmul double %t178.i, %t178.i
  %t7.i.i69 = fmul double %t181.i, %t181.i
  %t8.i.i70 = fadd double %t4.i.i68, %t7.i.i69
  %t11.i.i71 = fmul double %t184.i, %t184.i
  %t12.i.i72 = fadd double %t11.i.i71, %t8.i.i70
  %t13.i.i73 = fmul double %t1.i.i67, %t12.i.i72
  %t190.i = fadd double %var.ke.162.040.i, %t13.i.i73
  %t192.i = or disjoint i64 %for.i.163.041.i, 1
  %t177.i.1 = getelementptr inbounds nuw double, ptr %t15.i10, i64 %t192.i
  %t178.i.1 = load double, ptr %t177.i.1, align 8
  %t180.i.1 = getelementptr inbounds nuw double, ptr %t19.i13, i64 %t192.i
  %t181.i.1 = load double, ptr %t180.i.1, align 8
  %t183.i.1 = getelementptr inbounds nuw double, ptr %t23.i16, i64 %t192.i
  %t184.i.1 = load double, ptr %t183.i.1, align 8
  %t186.i.1 = getelementptr inbounds nuw double, ptr %t27.i19, i64 %t192.i
  %t187.i.1 = load double, ptr %t186.i.1, align 8
  %t1.i.i67.1 = fmul double %t187.i.1, 5.000000e-01
  %t4.i.i68.1 = fmul double %t178.i.1, %t178.i.1
  %t7.i.i69.1 = fmul double %t181.i.1, %t181.i.1
  %t8.i.i70.1 = fadd double %t4.i.i68.1, %t7.i.i69.1
  %t11.i.i71.1 = fmul double %t184.i.1, %t184.i.1
  %t12.i.i72.1 = fadd double %t11.i.i71.1, %t8.i.i70.1
  %t13.i.i73.1 = fmul double %t1.i.i67.1, %t12.i.i72.1
  %t190.i.1 = fadd double %t190.i, %t13.i.i73.1
  %t192.i.1 = add nuw nsw i64 %for.i.163.041.i, 2
  %exitcond46.not.i.1 = icmp eq i64 %t192.i.1, 64
  br i1 %exitcond46.not.i.1, label %archx_fn_pairwise_nbody.exit, label %for.body.37.i

archx_fn_pairwise_nbody.exit:                     ; preds = %for.body.37.i
  %t194.i = fmul double %t190.i.1, 1.000000e+04
  %t195.i = tail call i64 @llvm.fptosi.sat.i64.f64(double %t194.i)
  tail call void @free(ptr nonnull %t27.i19)
  tail call void @free(ptr nonnull %t23.i16)
  tail call void @free(ptr nonnull %t19.i13)
  tail call void @free(ptr nonnull %t15.i10)
  tail call void @free(ptr nonnull %t11.i7)
  tail call void @free(ptr nonnull %t7.i4)
  tail call void @free(ptr nonnull %t3.i1)
  %t3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t195.i)
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

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #4

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sqrt.f64(double) #5

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.fptosi.sat.i64.f64(double) #5

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x double> @llvm.sqrt.v2f64(<2 x double>) #6

attributes #0 = { nounwind }
attributes #1 = { cold nofree noreturn nounwind }
attributes #2 = { nofree nounwind }
attributes #3 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #4 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #5 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.isvectorized", i32 1}
!2 = !{!"llvm.loop.unroll.runtime.disable"}
!3 = distinct !{!3, !1, !2}
!4 = distinct !{!4, !1, !2}
!5 = distinct !{!5, !1, !2}
