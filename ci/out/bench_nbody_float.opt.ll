; ModuleID = '/tmp/bench_nbody_float.ll'
source_filename = "nbody_float.archx.lang"
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
  br i1 %14, label %vector.ph82, label %vector.body, !llvm.loop !3

calloc.oom.15.i:                                  ; preds = %calloc.ok.12.i
  tail call fastcc void @archx_oom_fail()
  unreachable

vector.ph82:                                      ; preds = %vector.body, %for.step.24.i
  %for._s.60.025.i = phi i64 [ %t127.i, %for.step.24.i ], [ 0, %vector.body ]
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
  br i1 %41, label %for.step.24.i, label %vector.body83, !llvm.loop !6

for.step.24.i:                                    ; preds = %vector.body83
  %t127.i = add nuw nsw i64 %for._s.60.025.i, 1
  %exitcond29.not.i = icmp eq i64 %t127.i, 60
  br i1 %exitcond29.not.i, label %for.body.31.i, label %vector.ph82

for.body.31.i:                                    ; preds = %for.step.24.i, %for.body.31.i
  %for.i.129.027.i = phi i64 [ %t159.i.1, %for.body.31.i ], [ 0, %for.step.24.i ]
  %var.ke.128.026.i = phi double [ %t157.i.1, %for.body.31.i ], [ 0.000000e+00, %for.step.24.i ]
  %t144.i = getelementptr inbounds nuw double, ptr %t15.i, i64 %for.i.129.027.i
  %t145.i = load double, ptr %t144.i, align 16
  %t147.i = getelementptr inbounds nuw double, ptr %t19.i, i64 %for.i.129.027.i
  %t148.i = load double, ptr %t147.i, align 16
  %t150.i = getelementptr inbounds nuw double, ptr %t23.i, i64 %for.i.129.027.i
  %t151.i = load double, ptr %t150.i, align 16
  %t153.i = getelementptr inbounds nuw double, ptr %t27.i, i64 %for.i.129.027.i
  %t154.i = load double, ptr %t153.i, align 16
  %t1.i.i = fmul double %t154.i, 5.000000e-01
  %t4.i.i = fmul double %t145.i, %t145.i
  %t7.i.i = fmul double %t148.i, %t148.i
  %t8.i.i = fadd double %t4.i.i, %t7.i.i
  %t11.i.i = fmul double %t151.i, %t151.i
  %t12.i.i = fadd double %t11.i.i, %t8.i.i
  %t13.i.i = fmul double %t1.i.i, %t12.i.i
  %t157.i = fadd double %var.ke.128.026.i, %t13.i.i
  %t159.i = or disjoint i64 %for.i.129.027.i, 1
  %t144.i.1 = getelementptr inbounds nuw double, ptr %t15.i, i64 %t159.i
  %t145.i.1 = load double, ptr %t144.i.1, align 8
  %t147.i.1 = getelementptr inbounds nuw double, ptr %t19.i, i64 %t159.i
  %t148.i.1 = load double, ptr %t147.i.1, align 8
  %t150.i.1 = getelementptr inbounds nuw double, ptr %t23.i, i64 %t159.i
  %t151.i.1 = load double, ptr %t150.i.1, align 8
  %t153.i.1 = getelementptr inbounds nuw double, ptr %t27.i, i64 %t159.i
  %t154.i.1 = load double, ptr %t153.i.1, align 8
  %t1.i.i.1 = fmul double %t154.i.1, 5.000000e-01
  %t4.i.i.1 = fmul double %t145.i.1, %t145.i.1
  %t7.i.i.1 = fmul double %t148.i.1, %t148.i.1
  %t8.i.i.1 = fadd double %t4.i.i.1, %t7.i.i.1
  %t11.i.i.1 = fmul double %t151.i.1, %t151.i.1
  %t12.i.i.1 = fadd double %t11.i.i.1, %t8.i.i.1
  %t13.i.i.1 = fmul double %t1.i.i.1, %t12.i.i.1
  %t157.i.1 = fadd double %t157.i, %t13.i.i.1
  %t159.i.1 = add nuw nsw i64 %for.i.129.027.i, 2
  %exitcond30.not.i.1 = icmp eq i64 %t159.i.1, 100000
  br i1 %exitcond30.not.i.1, label %archx_fn_central_field_sim.exit, label %for.body.31.i

archx_fn_central_field_sim.exit:                  ; preds = %for.body.31.i
  %t161.i = fmul double %t157.i.1, 1.000000e+02
  %t162.i = tail call i64 @llvm.fptosi.sat.i64.f64(double %t161.i)
  tail call void @free(ptr nonnull %t27.i)
  tail call void @free(ptr nonnull %t23.i)
  tail call void @free(ptr nonnull %t19.i)
  tail call void @free(ptr nonnull %t15.i)
  tail call void @free(ptr nonnull %t11.i)
  tail call void @free(ptr nonnull %t7.i)
  tail call void @free(ptr nonnull %t3.i)
  %t1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t162.i)
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
  br i1 %53, label %for.cond.26.preheader.i32, label %vector.body95, !llvm.loop !7

calloc.oom.15.i74:                                ; preds = %calloc.ok.12.i18
  tail call fastcc void @archx_oom_fail()
  unreachable

for.cond.26.preheader.i32:                        ; preds = %vector.body95, %for.step.24.i66
  %for._s.60.034.i = phi i64 [ %t168.i, %for.step.24.i66 ], [ 0, %vector.body95 ]
  br label %for.body.27.i33

for.body.27.i33:                                  ; preds = %for.end.33.i, %for.cond.26.preheader.i32
  %for.i.64.032.i = phi i64 [ 0, %for.cond.26.preheader.i32 ], [ %t136.i, %for.end.33.i ]
  %t69.i34 = getelementptr inbounds nuw double, ptr %t3.i1, i64 %for.i.64.032.i
  %t70.i35 = load double, ptr %t69.i34, align 8
  %t72.i36 = getelementptr inbounds nuw double, ptr %t7.i4, i64 %for.i.64.032.i
  %t73.i37 = load double, ptr %t72.i36, align 8
  %t75.i38 = getelementptr inbounds nuw double, ptr %t11.i7, i64 %for.i.64.032.i
  %t76.i39 = load double, ptr %t75.i38, align 8
  %54 = insertelement <2 x double> poison, double %t76.i39, i64 0
  %55 = insertelement <2 x double> %54, double %t73.i37, i64 1
  br label %for.body.31.i40

for.body.31.i40:                                  ; preds = %for.body.31.i40, %for.body.27.i33
  %for.j.80.031.i = phi i64 [ 0, %for.body.27.i33 ], [ %t119.i, %for.body.31.i40 ]
  %var.dvx.77.028.i = phi double [ 0.000000e+00, %for.body.27.i33 ], [ %t111.i, %for.body.31.i40 ]
  %56 = phi <2 x double> [ zeroinitializer, %for.body.27.i33 ], [ %66, %for.body.31.i40 ]
  %t85.i = getelementptr inbounds nuw double, ptr %t3.i1, i64 %for.j.80.031.i
  %t86.i41 = load double, ptr %t85.i, align 8
  %t87.i42 = fsub double %t86.i41, %t70.i35
  %t89.i43 = getelementptr inbounds nuw double, ptr %t7.i4, i64 %for.j.80.031.i
  %t90.i = load double, ptr %t89.i43, align 8
  %t93.i45 = getelementptr inbounds nuw double, ptr %t11.i7, i64 %for.j.80.031.i
  %t94.i46 = load double, ptr %t93.i45, align 8
  %t96.i47 = fmul double %t87.i42, %t87.i42
  %t103.i = getelementptr inbounds nuw double, ptr %t27.i19, i64 %for.j.80.031.i
  %t104.i = load double, ptr %t103.i, align 8
  %t105.i = fmul double %t104.i, 5.000000e-03
  %57 = insertelement <2 x double> poison, double %t94.i46, i64 0
  %58 = insertelement <2 x double> %57, double %t90.i, i64 1
  %59 = fsub <2 x double> %58, %55
  %60 = fmul <2 x double> %59, %59
  %61 = extractelement <2 x double> %60, i64 1
  %t98.i49 = fadd double %t96.i47, %61
  %62 = extractelement <2 x double> %60, i64 0
  %t100.i = fadd double %t98.i49, %62
  %t101.i = fadd double %t100.i, 5.000000e-02
  %t106.i51 = tail call double @llvm.sqrt.f64(double %t101.i)
  %t107.i52 = fmul double %t101.i, %t106.i51
  %t108.i = fdiv double %t105.i, %t107.i52
  %t110.i = fmul double %t87.i42, %t108.i
  %t111.i = fadd double %var.dvx.77.028.i, %t110.i
  %63 = insertelement <2 x double> poison, double %t108.i, i64 0
  %64 = shufflevector <2 x double> %63, <2 x double> poison, <2 x i32> zeroinitializer
  %65 = fmul <2 x double> %59, %64
  %66 = fadd <2 x double> %56, %65
  %t119.i = add nuw nsw i64 %for.j.80.031.i, 1
  %exitcond37.not.i = icmp eq i64 %t119.i, 64
  br i1 %exitcond37.not.i, label %for.end.33.i, label %for.body.31.i40

for.end.33.i:                                     ; preds = %for.body.31.i40
  %t121.i = getelementptr inbounds nuw double, ptr %t15.i10, i64 %for.i.64.032.i
  %t122.i54 = load double, ptr %t121.i, align 8
  %t124.i = fadd double %t111.i, %t122.i54
  store double %t124.i, ptr %t121.i, align 8
  %t126.i = getelementptr inbounds nuw double, ptr %t19.i13, i64 %for.i.64.032.i
  %t127.i55 = load double, ptr %t126.i, align 8
  %67 = extractelement <2 x double> %66, i64 1
  %t129.i = fadd double %67, %t127.i55
  store double %t129.i, ptr %t126.i, align 8
  %t131.i = getelementptr inbounds nuw double, ptr %t23.i16, i64 %for.i.64.032.i
  %t132.i = load double, ptr %t131.i, align 8
  %68 = extractelement <2 x double> %66, i64 0
  %t134.i = fadd double %68, %t132.i
  store double %t134.i, ptr %t131.i, align 8
  %t136.i = add nuw nsw i64 %for.i.64.032.i, 1
  %exitcond38.not.i = icmp eq i64 %t136.i, 64
  br i1 %exitcond38.not.i, label %vector.body104, label %for.body.27.i33

vector.body104:                                   ; preds = %for.end.33.i, %vector.body104
  %index105 = phi i64 [ %index.next112, %vector.body104 ], [ 0, %for.end.33.i ]
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
  br i1 %81, label %for.step.24.i66, label %vector.body104, !llvm.loop !8

for.step.24.i66:                                  ; preds = %vector.body104
  %t168.i = add nuw nsw i64 %for._s.60.034.i, 1
  %exitcond40.not.i = icmp eq i64 %t168.i, 2000
  br i1 %exitcond40.not.i, label %for.body.39.i, label %for.cond.26.preheader.i32

for.body.39.i:                                    ; preds = %for.step.24.i66, %for.body.39.i
  %for.i.170.036.i = phi i64 [ %t200.i.1, %for.body.39.i ], [ 0, %for.step.24.i66 ]
  %var.ke.169.035.i = phi double [ %t198.i.1, %for.body.39.i ], [ 0.000000e+00, %for.step.24.i66 ]
  %t185.i = getelementptr inbounds nuw double, ptr %t15.i10, i64 %for.i.170.036.i
  %t186.i = load double, ptr %t185.i, align 16
  %t188.i = getelementptr inbounds nuw double, ptr %t19.i13, i64 %for.i.170.036.i
  %t189.i = load double, ptr %t188.i, align 16
  %t191.i = getelementptr inbounds nuw double, ptr %t23.i16, i64 %for.i.170.036.i
  %t192.i = load double, ptr %t191.i, align 16
  %t194.i = getelementptr inbounds nuw double, ptr %t27.i19, i64 %for.i.170.036.i
  %t195.i = load double, ptr %t194.i, align 16
  %t1.i.i67 = fmul double %t195.i, 5.000000e-01
  %t4.i.i68 = fmul double %t186.i, %t186.i
  %t7.i.i69 = fmul double %t189.i, %t189.i
  %t8.i.i70 = fadd double %t4.i.i68, %t7.i.i69
  %t11.i.i71 = fmul double %t192.i, %t192.i
  %t12.i.i72 = fadd double %t11.i.i71, %t8.i.i70
  %t13.i.i73 = fmul double %t1.i.i67, %t12.i.i72
  %t198.i = fadd double %var.ke.169.035.i, %t13.i.i73
  %t200.i = or disjoint i64 %for.i.170.036.i, 1
  %t185.i.1 = getelementptr inbounds nuw double, ptr %t15.i10, i64 %t200.i
  %t186.i.1 = load double, ptr %t185.i.1, align 8
  %t188.i.1 = getelementptr inbounds nuw double, ptr %t19.i13, i64 %t200.i
  %t189.i.1 = load double, ptr %t188.i.1, align 8
  %t191.i.1 = getelementptr inbounds nuw double, ptr %t23.i16, i64 %t200.i
  %t192.i.1 = load double, ptr %t191.i.1, align 8
  %t194.i.1 = getelementptr inbounds nuw double, ptr %t27.i19, i64 %t200.i
  %t195.i.1 = load double, ptr %t194.i.1, align 8
  %t1.i.i67.1 = fmul double %t195.i.1, 5.000000e-01
  %t4.i.i68.1 = fmul double %t186.i.1, %t186.i.1
  %t7.i.i69.1 = fmul double %t189.i.1, %t189.i.1
  %t8.i.i70.1 = fadd double %t4.i.i68.1, %t7.i.i69.1
  %t11.i.i71.1 = fmul double %t192.i.1, %t192.i.1
  %t12.i.i72.1 = fadd double %t11.i.i71.1, %t8.i.i70.1
  %t13.i.i73.1 = fmul double %t1.i.i67.1, %t12.i.i72.1
  %t198.i.1 = fadd double %t198.i, %t13.i.i73.1
  %t200.i.1 = add nuw nsw i64 %for.i.170.036.i, 2
  %exitcond41.not.i.1 = icmp eq i64 %t200.i.1, 64
  br i1 %exitcond41.not.i.1, label %archx_fn_pairwise_nbody.exit, label %for.body.39.i

archx_fn_pairwise_nbody.exit:                     ; preds = %for.body.39.i
  %t202.i = fmul double %t198.i.1, 1.000000e+04
  %t203.i = tail call i64 @llvm.fptosi.sat.i64.f64(double %t202.i)
  tail call void @free(ptr nonnull %t27.i19)
  tail call void @free(ptr nonnull %t23.i16)
  tail call void @free(ptr nonnull %t19.i13)
  tail call void @free(ptr nonnull %t15.i10)
  tail call void @free(ptr nonnull %t11.i7)
  tail call void @free(ptr nonnull %t7.i4)
  tail call void @free(ptr nonnull %t3.i1)
  %t3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t203.i)
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

!llvm.module.flags = !{!0, !1, !2}

!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
!2 = !{i32 1, !"archx.wrapping", !"false"}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.isvectorized", i32 1}
!5 = !{!"llvm.loop.unroll.runtime.disable"}
!6 = distinct !{!6, !4, !5}
!7 = distinct !{!7, !4, !5}
!8 = distinct !{!8, !4, !5}
