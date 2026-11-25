; ModuleID = '/tmp/bench_full_tour.ll'
source_filename = "/tmp/bench_full_tour.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxStr = type { i64, i64 }
%ArchxEnum_Event = type { i64, [2 x i64] }
%ArchxAny = type { i64, i64, i64 }

@.str.0 = private unnamed_addr constant [22 x i8] c"   Telemetry_Channel_\00", align 4
@.str.2 = private unnamed_addr constant [19 x i8] c"absent_channel_key\00", align 4
@.str.3 = private unnamed_addr constant [16 x i8] c"match_dispatch=\00", align 4
@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@.fmt.i64s = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.err.type = private unnamed_addr constant [36 x i8] c"archx runtime panic: TypeError: %s\0A\00", align 1
@.any.unhash = private unnamed_addr constant [36 x i8] c"mutable list/dict/set is unhashable\00", align 1
@str = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1
@str.2 = private unnamed_addr constant [57 x i8] c"archx runtime panic: KeyError: key not found in dict/set\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %tmp.i1592 = alloca [12 x i8], align 4
  %sso.i.i1561 = alloca [16 x i8], align 8
  %buf.i1562 = alloca [32 x i8], align 8
  %tmp.i1530 = alloca [12 x i8], align 4
  %sso.i.i.i1426 = alloca [16 x i8], align 8
  %buf.i.i1427 = alloca [32 x i8], align 8
  %sso.i.i1358 = alloca [16 x i8], align 8
  %buf.i1359 = alloca [32 x i8], align 8
  %sso.i.i1290 = alloca [16 x i8], align 8
  %buf.i1291 = alloca [32 x i8], align 8
  %sso.i.i1259 = alloca [16 x i8], align 8
  %buf.i1260 = alloca [32 x i8], align 8
  %tmp.i1228 = alloca [12 x i8], align 4
  %sso.i.i1169 = alloca [16 x i8], align 8
  %buf.i1170 = alloca [32 x i8], align 8
  %tmp.i = alloca [12 x i8], align 4
  %sso.i.i1134 = alloca [16 x i8], align 8
  %buf.i1135 = alloca [32 x i8], align 8
  %sso.i.i = alloca [16 x i8], align 8
  %buf.i = alloca [32 x i8], align 8
  %sso.i.i608.i = alloca [16 x i8], align 8
  %tmp.i609.i = alloca [12 x i8], align 4
  %sbuf.i.i = alloca [64 x i8], align 8
  %sso.i.i579.i = alloca [16 x i8], align 8
  %tmp.i.i = alloca [12 x i8], align 4
  %sso.i.i547.i = alloca [16 x i8], align 8
  %buf.i548.i = alloca [32 x i8], align 8
  %sso.i.i.i = alloca [16 x i8], align 8
  %buf.i.i = alloca [32 x i8], align 8
  %atmp.i200.i = alloca [12 x i8], align 4
  %out_sso.i202.i = alloca [16 x i8], align 8
  %btmp.i152.i = alloca [12 x i8], align 4
  %btmp.i.i = alloca [12 x i8], align 4
  %out_sso.i.sroa.6.i = alloca i64, align 8
  %func.region.i = alloca %ArchxRegion, align 8
  %btmp.i1010 = alloca [12 x i8], align 4
  %atmp.i943 = alloca [12 x i8], align 4
  %btmp.i944 = alloca [12 x i8], align 4
  %out_sso.i945 = alloca [16 x i8], align 8
  %atmp.i889 = alloca [12 x i8], align 4
  %out_sso.i891 = alloca [16 x i8], align 8
  %atmp.i823 = alloca [12 x i8], align 4
  %btmp.i824 = alloca [12 x i8], align 4
  %out_sso.i825 = alloca [16 x i8], align 8
  %atmp.i769 = alloca [12 x i8], align 4
  %out_sso.i771 = alloca [16 x i8], align 8
  %atmp.i703 = alloca [12 x i8], align 4
  %btmp.i704 = alloca [12 x i8], align 4
  %out_sso.i705 = alloca [16 x i8], align 8
  %atmp.i649 = alloca [12 x i8], align 4
  %out_sso.i651 = alloca [16 x i8], align 8
  %atmp.i583 = alloca [12 x i8], align 4
  %btmp.i584 = alloca [12 x i8], align 4
  %out_sso.i585 = alloca [16 x i8], align 8
  %atmp.i529 = alloca [12 x i8], align 4
  %out_sso.i531 = alloca [16 x i8], align 8
  %btmp.i476 = alloca [12 x i8], align 4
  %out_sso.i477.sroa.6.sroa.5 = alloca i16, align 2
  %atmp.i409 = alloca [12 x i8], align 4
  %atmp.i371 = alloca [12 x i8], align 4
  %out_sso.i373 = alloca [16 x i8], align 8
  %btmp.i322 = alloca [12 x i8], align 4
  %btmp.i272 = alloca [12 x i8], align 4
  %out_sso.i273.sroa.6 = alloca i64, align 8
  %btmp.i = alloca [12 x i8], align 4
  %out_sso.i.sroa.6 = alloca i64, align 8
  %t3.i = tail call noalias align 16 dereferenceable_or_null(320000) ptr @calloc(i64 40000, i64 8)
  %t4.i = icmp eq ptr %t3.i, null
  br i1 %t4.i, label %calloc.oom.3.i, label %calloc.ok.2.i

calloc.oom.3.i:                                   ; preds = %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.2.i:                                    ; preds = %entry
  %t7.i = tail call noalias align 16 dereferenceable_or_null(320000) ptr @calloc(i64 40000, i64 8)
  %t8.i = icmp eq ptr %t7.i, null
  br i1 %t8.i, label %calloc.oom.5.i, label %calloc.ok.4.i

calloc.oom.5.i:                                   ; preds = %calloc.ok.2.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.4.i:                                    ; preds = %calloc.ok.2.i
  %t11.i = tail call noalias align 16 dereferenceable_or_null(320000) ptr @calloc(i64 40000, i64 8)
  %t12.i = icmp eq ptr %t11.i, null
  br i1 %t12.i, label %calloc.oom.7.i, label %calloc.ok.6.i

calloc.oom.7.i:                                   ; preds = %calloc.ok.4.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.6.i:                                    ; preds = %calloc.ok.4.i
  %t15.i = tail call noalias align 16 dereferenceable_or_null(320000) ptr @calloc(i64 40000, i64 8)
  %t16.i = icmp eq ptr %t15.i, null
  br i1 %t16.i, label %calloc.oom.9.i, label %calloc.ok.8.i

calloc.oom.9.i:                                   ; preds = %calloc.ok.6.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.8.i:                                    ; preds = %calloc.ok.6.i
  %t19.i = tail call noalias align 16 dereferenceable_or_null(320000) ptr @calloc(i64 40000, i64 8)
  %t20.i = icmp eq ptr %t19.i, null
  br i1 %t20.i, label %calloc.oom.11.i, label %vector.body

vector.body:                                      ; preds = %calloc.ok.8.i, %vector.body
  %index = phi i64 [ %index.next, %vector.body ], [ 0, %calloc.ok.8.i ]
  %vec.ind = phi <2 x i64> [ %vec.ind.next, %vector.body ], [ <i64 0, i64 1>, %calloc.ok.8.i ]
  %0 = add nuw nsw <2 x i64> %vec.ind, splat (i64 1)
  %1 = uitofp nneg <2 x i64> %0 to <2 x double>
  %2 = getelementptr inbounds nuw double, ptr %t3.i, i64 %index
  %3 = fmul <2 x double> %1, splat (double 1.000000e-03)
  store <2 x double> %3, ptr %2, align 16
  %4 = getelementptr inbounds nuw double, ptr %t7.i, i64 %index
  %5 = fmul <2 x double> %1, splat (double -2.000000e-03)
  store <2 x double> %5, ptr %4, align 16
  %6 = getelementptr inbounds nuw double, ptr %t11.i, i64 %index
  store <2 x double> splat (double 2.000000e-02), ptr %6, align 16
  %7 = getelementptr inbounds nuw double, ptr %t15.i, i64 %index
  store <2 x double> splat (double -1.500000e-02), ptr %7, align 16
  %8 = getelementptr inbounds nuw double, ptr %t19.i, i64 %index
  %9 = fmul <2 x double> %1, splat (double 2.000000e-04)
  %10 = fadd <2 x double> %9, splat (double 1.000000e+00)
  store <2 x double> %10, ptr %8, align 16
  %index.next = add nuw i64 %index, 2
  %vec.ind.next = add <2 x i64> %vec.ind, splat (i64 2)
  %11 = icmp eq i64 %index.next, 40000
  br i1 %11, label %vector.ph1822, label %vector.body, !llvm.loop !0

calloc.oom.11.i:                                  ; preds = %calloc.ok.8.i
  tail call fastcc void @archx_oom_fail()
  unreachable

vector.ph1822:                                    ; preds = %vector.body, %for.step.18.i
  %for._s.45.022.i = phi i64 [ %t92.i, %for.step.18.i ], [ 0, %vector.body ]
  br label %vector.body1823

vector.body1823:                                  ; preds = %vector.body1823, %vector.ph1822
  %index1824 = phi i64 [ 0, %vector.ph1822 ], [ %index.next1828, %vector.body1823 ]
  %12 = getelementptr inbounds nuw double, ptr %t3.i, i64 %index1824
  %wide.load = load <2 x double>, ptr %12, align 16
  %13 = getelementptr inbounds nuw double, ptr %t7.i, i64 %index1824
  %wide.load1825 = load <2 x double>, ptr %13, align 16
  %14 = fmul <2 x double> %wide.load, %wide.load
  %15 = fmul <2 x double> %wide.load1825, %wide.load1825
  %16 = fadd <2 x double> %14, %15
  %17 = fadd <2 x double> %16, splat (double 1.000000e+00)
  %18 = tail call <2 x double> @llvm.sqrt.v2f64(<2 x double> %17)
  %19 = fdiv <2 x double> splat (double 1.000000e-02), %18
  %20 = getelementptr inbounds nuw double, ptr %t11.i, i64 %index1824
  %wide.load1826 = load <2 x double>, ptr %20, align 16
  %21 = fmul <2 x double> %wide.load, %19
  %22 = fsub <2 x double> %wide.load1826, %21
  store <2 x double> %22, ptr %20, align 16
  %23 = getelementptr inbounds nuw double, ptr %t15.i, i64 %index1824
  %wide.load1827 = load <2 x double>, ptr %23, align 16
  %24 = fmul <2 x double> %wide.load1825, %19
  %25 = fsub <2 x double> %wide.load1827, %24
  store <2 x double> %25, ptr %23, align 16
  %26 = fmul <2 x double> %22, splat (double 1.000000e-02)
  %27 = fadd <2 x double> %wide.load, %26
  store <2 x double> %27, ptr %12, align 16
  %28 = fmul <2 x double> %25, splat (double 1.000000e-02)
  %29 = fadd <2 x double> %wide.load1825, %28
  store <2 x double> %29, ptr %13, align 16
  %index.next1828 = add nuw i64 %index1824, 2
  %30 = icmp eq i64 %index.next1828, 40000
  br i1 %30, label %for.step.18.i, label %vector.body1823, !llvm.loop !3

for.step.18.i:                                    ; preds = %vector.body1823
  %t92.i = add nuw nsw i64 %for._s.45.022.i, 1
  %exitcond26.not.i = icmp eq i64 %t92.i, 30
  br i1 %exitcond26.not.i, label %for.body.25.i, label %vector.ph1822

for.body.25.i:                                    ; preds = %for.step.18.i, %for.body.25.i
  %for.i.94.024.i = phi i64 [ %t117.i.1, %for.body.25.i ], [ 0, %for.step.18.i ]
  %var.ke.93.023.i = phi double [ %t115.i.1, %for.body.25.i ], [ 0.000000e+00, %for.step.18.i ]
  %t105.i = getelementptr inbounds nuw double, ptr %t11.i, i64 %for.i.94.024.i
  %t106.i = load double, ptr %t105.i, align 16
  %t108.i = getelementptr inbounds nuw double, ptr %t15.i, i64 %for.i.94.024.i
  %t109.i = load double, ptr %t108.i, align 16
  %t111.i = getelementptr inbounds nuw double, ptr %t19.i, i64 %for.i.94.024.i
  %t112.i = load double, ptr %t111.i, align 16
  %t1.i.i = fmul double %t112.i, 5.000000e-01
  %t4.i.i = fmul double %t106.i, %t106.i
  %t7.i.i = fmul double %t109.i, %t109.i
  %t8.i.i = fadd double %t4.i.i, %t7.i.i
  %t9.i.i = fmul double %t1.i.i, %t8.i.i
  %t115.i = fadd double %var.ke.93.023.i, %t9.i.i
  %t117.i = or disjoint i64 %for.i.94.024.i, 1
  %t105.i.1 = getelementptr inbounds nuw double, ptr %t11.i, i64 %t117.i
  %t106.i.1 = load double, ptr %t105.i.1, align 8
  %t108.i.1 = getelementptr inbounds nuw double, ptr %t15.i, i64 %t117.i
  %t109.i.1 = load double, ptr %t108.i.1, align 8
  %t111.i.1 = getelementptr inbounds nuw double, ptr %t19.i, i64 %t117.i
  %t112.i.1 = load double, ptr %t111.i.1, align 8
  %t1.i.i.1 = fmul double %t112.i.1, 5.000000e-01
  %t4.i.i.1 = fmul double %t106.i.1, %t106.i.1
  %t7.i.i.1 = fmul double %t109.i.1, %t109.i.1
  %t8.i.i.1 = fadd double %t4.i.i.1, %t7.i.i.1
  %t9.i.i.1 = fmul double %t1.i.i.1, %t8.i.i.1
  %t115.i.1 = fadd double %t115.i, %t9.i.i.1
  %t117.i.1 = add nuw nsw i64 %for.i.94.024.i, 2
  %exitcond27.not.i.1 = icmp eq i64 %t117.i.1, 40000
  br i1 %exitcond27.not.i.1, label %archx_fn_simulate_field.exit, label %for.body.25.i

archx_fn_simulate_field.exit:                     ; preds = %for.body.25.i
  %t119.i = fmul double %t115.i.1, 1.000000e+03
  %t120.i = tail call i64 @llvm.fptosi.sat.i64.f64(double %t119.i)
  tail call void @free(ptr nonnull %t19.i)
  tail call void @free(ptr nonnull %t15.i)
  tail call void @free(ptr nonnull %t11.i)
  tail call void @free(ptr nonnull %t7.i)
  tail call void @free(ptr nonnull %t3.i)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %func.region.i)
  %.fca.1.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 8
  %.fca.2.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 16
  %.fca.3.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 24
  %btmp4.i196.i = getelementptr inbounds nuw i8, ptr %btmp.i152.i, i64 4
  %atmp4.i236.i = getelementptr inbounds nuw i8, ptr %atmp.i200.i, i64 4
  %out_sso8.i228.i = getelementptr inbounds nuw i8, ptr %out_sso.i202.i, i64 8
  %sso_dst_a.i230.i = getelementptr inbounds nuw i8, ptr %out_sso.i202.i, i64 4
  %t4.i.i1062 = getelementptr inbounds nuw i8, ptr %tmp.i.i, i64 4
  %t4.i643.i = getelementptr inbounds nuw i8, ptr %tmp.i609.i, i64 4
  %btmp4.i.i = getelementptr inbounds nuw i8, ptr %btmp.i.i, i64 4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %func.region.i, i8 0, i64 32, i1 false)
  %sso.i.i547.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i547.i, i64 4
  %sso.i.i547.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i547.i, i64 8
  %sso.i.i579.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i579.i, i64 4
  %sso.i.i579.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i579.i, i64 8
  %sso.i.i608.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i608.i, i64 4
  %sso.i.i608.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i608.i, i64 8
  %sso.i.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i, i64 4
  %sso.i.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i, i64 8
  br label %for.body.1.i

for.body.1.i:                                     ; preds = %for.step.2.i, %archx_fn_simulate_field.exit
  %var.vocab.4.sroa.34.0866.i = phi ptr [ null, %archx_fn_simulate_field.exit ], [ %var.vocab.4.sroa.34.3.i, %for.step.2.i ]
  %var.vocab.4.sroa.17.0865.i = phi i64 [ 0, %archx_fn_simulate_field.exit ], [ %var.vocab.4.sroa.17.3.i, %for.step.2.i ]
  %var.vocab.4.sroa.0.0864.i = phi i64 [ 0, %archx_fn_simulate_field.exit ], [ %var.vocab.4.sroa.0.3.i, %for.step.2.i ]
  %t9.i = and i64 %var.vocab.4.sroa.0.0864.i, 1
  %t10.i = icmp eq i64 %t9.i, 0
  br i1 %t10.i, label %if.then.4.i, label %if.else.5.i

if.then.4.i:                                      ; preds = %for.body.1.i
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i.i)
  %n32.i.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %var.vocab.4.sroa.0.0864.i)
  %len.i545.i = sext i32 %n32.i.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i.i)
  %z.i.i.i = icmp slt i32 %n32.i.i, 1
  br i1 %z.i.i.i, label %archx_str_from_int.exit.i, label %chk_sso.i.i.i

oom.i.i.i:                                        ; preds = %alloc_heap.i.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i.i:                                    ; preds = %if.then.4.i
  %short.i.i.i = icmp samesign ult i32 %n32.i.i, 13
  br i1 %short.i.i.i, label %pack_sso.i.i.i, label %alloc_heap.i.i.i

pack_sso.i.i.i:                                   ; preds = %chk_sso.i.i.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i.i, i8 0, i64 16, i1 false)
  store i32 %n32.i.i, ptr %sso.i.i.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i.i, i64 %len.i545.i, i1 false)
  %sso.i.i.i.0.sso.i.i.i.0.sso.i.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i.i = load i64, ptr %sso.i.i.i, align 8
  %sso.i.i.i.8.sso.i.i.i.8.sso.i.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i.i = load i64, ptr %sso.i.i.i.8.sroa_idx, align 8
  %ss0.i.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.i.0.sso.i.i.i.0.sso.i.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i.i, 0
  %ss1.i.i.i = insertvalue %ArchxStr %ss0.i.i.i, i64 %sso.i.i.i.8.sso.i.i.i.8.sso.i.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i.i, 1
  br label %archx_str_from_int.exit.i

alloc_heap.i.i.i:                                 ; preds = %chk_sso.i.i.i
  %hp.i.i.i = tail call noalias align 16 ptr @malloc(i64 %len.i545.i)
  %hnull.i.i.i = icmp eq ptr %hp.i.i.i, null
  br i1 %hnull.i.i.i, label %oom.i.i.i, label %copy_long.i.i.i

copy_long.i.i.i:                                  ; preds = %alloc_heap.i.i.i
  %hp_i.i.i.i = ptrtoint ptr %hp.i.i.i to i64
  %htagged.i.i.i = or disjoint i64 %hp_i.i.i.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i.i, ptr nonnull readonly align 8 %buf.i.i, i64 %len.i545.i, i1 false)
  %pref32.i.i.i = load i32, ptr %hp.i.i.i, align 16
  %pref64.i.i.i = zext i32 %pref32.i.i.i to i64
  %pref_sh.i.i.i = shl nuw i64 %pref64.i.i.i, 32
  %w0_out.i.i.i = or disjoint i64 %pref_sh.i.i.i, %len.i545.i
  %ls0.i.i.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i.i, 0
  %ls1.i.i.i = insertvalue %ArchxStr %ls0.i.i.i, i64 %htagged.i.i.i, 1
  br label %archx_str_from_int.exit.i

archx_str_from_int.exit.i:                        ; preds = %copy_long.i.i.i, %pack_sso.i.i.i, %if.then.4.i
  %common.ret.op.i.i.i = phi %ArchxStr [ %ss1.i.i.i, %pack_sso.i.i.i ], [ %ls1.i.i.i, %copy_long.i.i.i ], [ zeroinitializer, %if.then.4.i ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i.sroa.6.i)
  %bw0.i.i = extractvalue %ArchxStr %common.ret.op.i.i.i, 0
  %bw1.i.i = extractvalue %ArchxStr %common.ret.op.i.i.i, 1
  %blen.i.i = and i64 %bw0.i.i, 4294967295
  %bz.i.i = icmp eq i64 %blen.i.i, 0
  br i1 %bz.i.i, label %archx_str_concat.exit.i, label %calc_tot.i.i

calc_tot.i.i:                                     ; preds = %archx_str_from_int.exit.i
  %tot.i.i = add nuw nsw i64 %blen.i.i, 4
  %too_big.i.i = icmp samesign ugt i64 %blen.i.i, 2147483643
  br i1 %too_big.i.i, label %oom.i.i, label %mat_a.i.i

oom.i.i:                                          ; preds = %alloc_heap.i.i, %calc_tot.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i.i:                                        ; preds = %calc_tot.i.i
  %bshort.i.i = icmp samesign ult i64 %blen.i.i, 13
  br i1 %bshort.i.i, label %build.i.i, label %build.i.thread.i

build.i.thread.i:                                 ; preds = %mat_a.i.i
  %braw.i.i = and i64 %bw1.i.i, -4
  %blptr.i.i = inttoptr i64 %braw.i.i to ptr
  br label %alloc_heap.i.i

build.i.i:                                        ; preds = %mat_a.i.i
  %bp4.i.i = lshr i64 %bw0.i.i, 32
  %bp4_32.i.i = trunc nuw i64 %bp4.i.i to i32
  store i32 %bp4_32.i.i, ptr %btmp.i.i, align 4
  store i64 %bw1.i.i, ptr %btmp4.i.i, align 4
  %fits_sso.i.i = icmp samesign ult i64 %blen.i.i, 9
  br i1 %fits_sso.i.i, label %build_sso.i.i, label %alloc_heap.i.i

build_sso.i.i:                                    ; preds = %build.i.i
  store i64 0, ptr %out_sso.i.sroa.6.i, align 8
  %out_sso.i.sroa.0.4.insert.insert.i = or disjoint i64 %tot.i.i, 6875711800118083584
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i.sroa.6.i, ptr nonnull align 4 %btmp.i.i, i64 %blen.i.i, i1 false)
  %out_sso.i.sroa.6.i.0.out_sso.i.sroa.6.i.0.out_sso.i.sroa.6.i.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.8.rw1.i.i = load i64, ptr %out_sso.i.sroa.6.i, align 8
  %rs0.i.i = insertvalue %ArchxStr poison, i64 %out_sso.i.sroa.0.4.insert.insert.i, 0
  %rs1.i.i = insertvalue %ArchxStr %rs0.i.i, i64 %out_sso.i.sroa.6.i.0.out_sso.i.sroa.6.i.0.out_sso.i.sroa.6.i.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.8.rw1.i.i, 1
  br label %archx_str_concat.exit.i

alloc_heap.i.i:                                   ; preds = %build.i.i, %build.i.thread.i
  %bptr.i953.i = phi ptr [ %blptr.i.i, %build.i.thread.i ], [ %btmp.i.i, %build.i.i ]
  %hp.i.i = tail call noalias align 16 ptr @malloc(i64 %tot.i.i)
  %hnull.i.i = icmp eq ptr %hp.i.i, null
  br i1 %hnull.i.i, label %oom.i.i, label %copy_long.i.i

copy_long.i.i:                                    ; preds = %alloc_heap.i.i
  %hp_i.i.i = ptrtoint ptr %hp.i.i to i64
  %htagged.i.i = or disjoint i64 %hp_i.i.i, 1
  store i32 1600876404, ptr %hp.i.i, align 16
  %dst_b.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %dst_b.i.i, ptr nonnull align 1 %bptr.i953.i, i64 %blen.i.i, i1 false)
  %w0_out.i.i = or disjoint i64 %tot.i.i, 6875711800118083584
  %ls0.i.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i, 0
  %ls1.i.i = insertvalue %ArchxStr %ls0.i.i, i64 %htagged.i.i, 1
  br label %archx_str_concat.exit.i

archx_str_concat.exit.i:                          ; preds = %copy_long.i.i, %build_sso.i.i, %archx_str_from_int.exit.i
  %common.ret.op.i.i = phi %ArchxStr [ %rs1.i.i, %build_sso.i.i ], [ %ls1.i.i, %copy_long.i.i ], [ { i64 6875711800118083588, i64 0 }, %archx_str_from_int.exit.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6.i)
  %t18.i = icmp slt i64 %var.vocab.4.sroa.17.0865.i, 0
  %t20.i1068 = tail call i64 @llvm.abs.i64(i64 %var.vocab.4.sroa.17.0865.i, i1 true)
  %t21.not.i = icmp samesign ult i64 %var.vocab.4.sroa.0.0864.i, %t20.i1068
  br i1 %t21.not.i, label %push.store.8.i, label %push.calc.10.i

push.calc.10.i:                                   ; preds = %archx_str_concat.exit.i
  %t23.i = icmp eq i64 %var.vocab.4.sroa.17.0865.i, 0
  %t24.i = shl nuw i64 %t20.i1068, 1
  %31 = tail call i64 @llvm.smin.i64(i64 %t24.i, i64 140737488355328)
  %t27.i = select i1 %t23.i, i64 4, i64 %31
  %32 = add i64 %t27.i, -576460752303423488
  %t30.i = icmp ult i64 %32, -1152921504606846976
  br i1 %t30.i, label %mul.oom.11.i, label %mul.ok.12.i

mul.oom.11.i:                                     ; preds = %push.calc.10.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mul.ok.12.i:                                      ; preds = %push.calc.10.i
  %t29.i1069 = shl nsw i64 %t27.i, 4
  %t32.i = tail call i64 @llvm.umax.i64(i64 %t29.i1069, i64 1)
  br i1 %t18.i, label %mul.ok.16.i, label %push.grow.from_heap.14.i

mul.ok.16.i:                                      ; preds = %mul.ok.12.i
  %t38.i = tail call noalias align 16 ptr @malloc(i64 %t32.i)
  %t39.i = icmp eq ptr %t38.i, null
  br i1 %t39.i, label %alloc.oom.18.i, label %push.reg.copy.19.i

alloc.oom.18.i:                                   ; preds = %mul.ok.16.i
  tail call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.19.i:                               ; preds = %mul.ok.16.i
  %t34.i = shl nuw nsw i64 %var.vocab.4.sroa.0.0864.i, 4
  %t37.i1070 = tail call i64 @llvm.umax.i64(i64 %t34.i, i64 1)
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t38.i, ptr noundef nonnull align 8 dereferenceable(1) %var.vocab.4.sroa.34.0866.i, i64 %t37.i1070, i1 false)
  br label %push.store.8.i

push.grow.from_heap.14.i:                         ; preds = %mul.ok.12.i
  %t44.i = tail call align 16 ptr @realloc(ptr %var.vocab.4.sroa.34.0866.i, i64 %t32.i)
  %t45.i = icmp eq ptr %t44.i, null
  br i1 %t45.i, label %realloc.oom.22.i, label %push.store.8.i

realloc.oom.22.i:                                 ; preds = %push.grow.from_heap.14.i
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.8.i:                                   ; preds = %push.grow.from_heap.14.i, %push.reg.copy.19.i, %archx_str_concat.exit.i
  %var.vocab.4.sroa.17.1.i = phi i64 [ %var.vocab.4.sroa.17.0865.i, %archx_str_concat.exit.i ], [ %t27.i, %push.reg.copy.19.i ], [ %t27.i, %push.grow.from_heap.14.i ]
  %var.vocab.4.sroa.34.1.i = phi ptr [ %var.vocab.4.sroa.34.0866.i, %archx_str_concat.exit.i ], [ %t38.i, %push.reg.copy.19.i ], [ %t44.i, %push.grow.from_heap.14.i ]
  %t51.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.1.i, i64 %var.vocab.4.sroa.0.0864.i
  %t13.elt.i = extractvalue %ArchxStr %common.ret.op.i.i, 0
  store i64 %t13.elt.i, ptr %t51.i, align 8
  %t51.repack72.i = getelementptr inbounds nuw i8, ptr %t51.i, i64 8
  %t13.elt73.i = extractvalue %ArchxStr %common.ret.op.i.i, 1
  store i64 %t13.elt73.i, ptr %t51.repack72.i, align 8
  %long.i.i = icmp samesign ult i64 %blen.i.i, 13
  %tag.i.i = and i64 %bw1.i.i, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond.i = select i1 %long.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond.i, label %for.step.2.i, label %for.step.2.sink.split.i

if.else.5.i:                                      ; preds = %for.body.1.i
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i548.i)
  %n32.i549.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i548.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %var.vocab.4.sroa.0.0864.i)
  %len.i550.i = sext i32 %n32.i549.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i547.i)
  %z.i.i551.i = icmp slt i32 %n32.i549.i, 1
  br i1 %z.i.i551.i, label %archx_str_from_int.exit575.i, label %chk_sso.i.i552.i

oom.i.i567.i:                                     ; preds = %alloc_heap.i.i554.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i552.i:                                 ; preds = %if.else.5.i
  %short.i.i553.i = icmp samesign ult i32 %n32.i549.i, 13
  br i1 %short.i.i553.i, label %pack_sso.i.i568.i, label %alloc_heap.i.i554.i

pack_sso.i.i568.i:                                ; preds = %chk_sso.i.i552.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i547.i, i8 0, i64 16, i1 false)
  store i32 %n32.i549.i, ptr %sso.i.i547.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i547.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i548.i, i64 %len.i550.i, i1 false)
  %sso.i.i547.i.0.sso.i.i547.i.0.sso.i.i547.i.0.sso.i.i547.0.sso.i.i547.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i570.i = load i64, ptr %sso.i.i547.i, align 8
  %sso.i.i547.i.8.sso.i.i547.i.8.sso.i.i547.i.8.sso.i.i547.8.sso.i.i547.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i572.i = load i64, ptr %sso.i.i547.i.8.sroa_idx, align 8
  %ss0.i.i573.i = insertvalue %ArchxStr poison, i64 %sso.i.i547.i.0.sso.i.i547.i.0.sso.i.i547.i.0.sso.i.i547.0.sso.i.i547.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i570.i, 0
  %ss1.i.i574.i = insertvalue %ArchxStr %ss0.i.i573.i, i64 %sso.i.i547.i.8.sso.i.i547.i.8.sso.i.i547.i.8.sso.i.i547.8.sso.i.i547.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i572.i, 1
  br label %archx_str_from_int.exit575.i

alloc_heap.i.i554.i:                              ; preds = %chk_sso.i.i552.i
  %hp.i.i555.i = tail call noalias align 16 ptr @malloc(i64 %len.i550.i)
  %hnull.i.i556.i = icmp eq ptr %hp.i.i555.i, null
  br i1 %hnull.i.i556.i, label %oom.i.i567.i, label %copy_long.i.i557.i

copy_long.i.i557.i:                               ; preds = %alloc_heap.i.i554.i
  %hp_i.i.i558.i = ptrtoint ptr %hp.i.i555.i to i64
  %htagged.i.i559.i = or disjoint i64 %hp_i.i.i558.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i555.i, ptr nonnull readonly align 8 %buf.i548.i, i64 %len.i550.i, i1 false)
  %pref32.i.i560.i = load i32, ptr %hp.i.i555.i, align 16
  %pref64.i.i561.i = zext i32 %pref32.i.i560.i to i64
  %pref_sh.i.i562.i = shl nuw i64 %pref64.i.i561.i, 32
  %w0_out.i.i563.i = or disjoint i64 %pref_sh.i.i562.i, %len.i550.i
  %ls0.i.i564.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i563.i, 0
  %ls1.i.i565.i = insertvalue %ArchxStr %ls0.i.i564.i, i64 %htagged.i.i559.i, 1
  br label %archx_str_from_int.exit575.i

archx_str_from_int.exit575.i:                     ; preds = %copy_long.i.i557.i, %pack_sso.i.i568.i, %if.else.5.i
  %common.ret.op.i.i566.i = phi %ArchxStr [ %ss1.i.i574.i, %pack_sso.i.i568.i ], [ %ls1.i.i565.i, %copy_long.i.i557.i ], [ zeroinitializer, %if.else.5.i ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i547.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i548.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i152.i)
  %bw0.i154.i = extractvalue %ArchxStr %common.ret.op.i.i566.i, 0
  %bw1.i155.i = extractvalue %ArchxStr %common.ret.op.i.i566.i, 1
  %blen.i156.i = and i64 %bw0.i154.i, 4294967295
  %bz.i157.i = icmp eq i64 %blen.i156.i, 0
  br i1 %bz.i157.i, label %archx_str_concat.exit199.i, label %calc_tot.i158.i

calc_tot.i158.i:                                  ; preds = %archx_str_from_int.exit575.i
  %tot.i159.i = add nuw nsw i64 %blen.i156.i, 21
  %too_big.i160.i = icmp samesign ugt i64 %blen.i156.i, 2147483626
  br i1 %too_big.i160.i, label %oom.i183.i, label %mat_a.i161.i

oom.i183.i:                                       ; preds = %alloc_heap.i169.i, %calc_tot.i158.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i161.i:                                     ; preds = %calc_tot.i158.i
  %bshort.i162.i = icmp samesign ult i64 %blen.i156.i, 13
  br i1 %bshort.i162.i, label %mat_b_short.i193.i, label %mat_b_long.i163.i

mat_b_short.i193.i:                               ; preds = %mat_a.i161.i
  %bp4.i194.i = lshr i64 %bw0.i154.i, 32
  %bp4_32.i195.i = trunc nuw i64 %bp4.i194.i to i32
  store i32 %bp4_32.i195.i, ptr %btmp.i152.i, align 4
  store i64 %bw1.i155.i, ptr %btmp4.i196.i, align 4
  br label %alloc_heap.i169.i

mat_b_long.i163.i:                                ; preds = %mat_a.i161.i
  %braw.i164.i = and i64 %bw1.i155.i, -4
  %blptr.i165.i = inttoptr i64 %braw.i164.i to ptr
  br label %alloc_heap.i169.i

alloc_heap.i169.i:                                ; preds = %mat_b_long.i163.i, %mat_b_short.i193.i
  %bptr.i167.i = phi ptr [ %btmp.i152.i, %mat_b_short.i193.i ], [ %blptr.i165.i, %mat_b_long.i163.i ]
  %hp.i170.i = tail call noalias align 16 ptr @malloc(i64 %tot.i159.i)
  %hnull.i171.i = icmp eq ptr %hp.i170.i, null
  br i1 %hnull.i171.i, label %oom.i183.i, label %copy_long.i172.i

copy_long.i172.i:                                 ; preds = %alloc_heap.i169.i
  %hp_i.i173.i = ptrtoint ptr %hp.i170.i to i64
  %htagged.i174.i = or disjoint i64 %hp_i.i173.i, 1
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(21) %hp.i170.i, ptr noundef nonnull align 4 dereferenceable(21) @.str.0, i64 21, i1 false)
  %dst_b.i175.i = getelementptr inbounds nuw i8, ptr %hp.i170.i, i64 21
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i175.i, ptr nonnull align 1 %bptr.i167.i, i64 %blen.i156.i, i1 false)
  %w0_out.i179.i = or disjoint i64 %tot.i159.i, 6061880420251729920
  %ls0.i180.i = insertvalue %ArchxStr poison, i64 %w0_out.i179.i, 0
  %ls1.i181.i = insertvalue %ArchxStr %ls0.i180.i, i64 %htagged.i174.i, 1
  br label %archx_str_concat.exit199.i

archx_str_concat.exit199.i:                       ; preds = %copy_long.i172.i, %archx_str_from_int.exit575.i
  %common.ret.op.i182.i = phi %ArchxStr [ %ls1.i181.i, %copy_long.i172.i ], [ { i64 6061880420251729941, i64 ptrtoint (ptr @.str.0 to i64) }, %archx_str_from_int.exit575.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i152.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i200.i)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i202.i)
  %aw0.i.i = extractvalue %ArchxStr %common.ret.op.i182.i, 0
  %aw1.i.i = extractvalue %ArchxStr %common.ret.op.i182.i, 1
  %alen.i.i = and i64 %aw0.i.i, 4294967295
  %az.i.i = icmp eq i64 %alen.i.i, 0
  br i1 %az.i.i, label %archx_str_concat.exit237.thread.i, label %chk_bz.i.i

chk_bz.i.i:                                       ; preds = %archx_str_concat.exit199.i
  %tot.i204.i = add nuw nsw i64 %alen.i.i, 2
  %too_big.i205.i = icmp samesign ugt i64 %alen.i.i, 2147483645
  br i1 %too_big.i205.i, label %oom.i226.i, label %mat_a.i206.i

oom.i226.i:                                       ; preds = %alloc_heap.i212.i, %chk_bz.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i206.i:                                     ; preds = %chk_bz.i.i
  %ashort.i.i = icmp samesign ult i64 %alen.i.i, 13
  br i1 %ashort.i.i, label %mat_b.i.i, label %mat_b.i.thread.i

mat_b.i.thread.i:                                 ; preds = %mat_a.i206.i
  %araw.i.i = and i64 %aw1.i.i, -4
  %alptr.i.i = inttoptr i64 %araw.i.i to ptr
  br label %alloc_heap.i212.i

mat_b.i.i:                                        ; preds = %mat_a.i206.i
  %ap4.i.i = lshr i64 %aw0.i.i, 32
  %ap4_32.i.i = trunc nuw i64 %ap4.i.i to i32
  store i32 %ap4_32.i.i, ptr %atmp.i200.i, align 4
  store i64 %aw1.i.i, ptr %atmp4.i236.i, align 4
  %fits_sso.i211.i = icmp samesign ult i64 %alen.i.i, 11
  br i1 %fits_sso.i211.i, label %build_sso.i227.i, label %alloc_heap.i212.i

build_sso.i227.i:                                 ; preds = %mat_b.i.i
  %tot32.i229.i = trunc nuw nsw i64 %tot.i204.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i202.i, i8 0, i64 16, i1 false)
  store i32 %tot32.i229.i, ptr %out_sso.i202.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i230.i, ptr nonnull align 4 %atmp.i200.i, i64 %alen.i.i, i1 false)
  %sso_dst_b.i231.i = getelementptr inbounds nuw i8, ptr %sso_dst_a.i230.i, i64 %alen.i.i
  store i16 8224, ptr %sso_dst_b.i231.i, align 1
  %rw0.i232.i = load i64, ptr %out_sso.i202.i, align 8
  %rw1.i233.i = load i64, ptr %out_sso8.i228.i, align 8
  %rs0.i234.i = insertvalue %ArchxStr poison, i64 %rw0.i232.i, 0
  %rs1.i235.i = insertvalue %ArchxStr %rs0.i234.i, i64 %rw1.i233.i, 1
  br label %archx_str_concat.exit237.thread.i

alloc_heap.i212.i:                                ; preds = %mat_b.i.i, %mat_b.i.thread.i
  %aptr.i772.i = phi ptr [ %alptr.i.i, %mat_b.i.thread.i ], [ %atmp.i200.i, %mat_b.i.i ]
  %hp.i213.i = tail call noalias align 16 ptr @malloc(i64 %tot.i204.i)
  %hnull.i214.i = icmp eq ptr %hp.i213.i, null
  br i1 %hnull.i214.i, label %oom.i226.i, label %archx_str_concat.exit237.i

archx_str_concat.exit237.thread.i:                ; preds = %build_sso.i227.i, %archx_str_concat.exit199.i
  %common.ret.op.i225.ph.i = phi %ArchxStr [ { i64 35321811042306, i64 0 }, %archx_str_concat.exit199.i ], [ %rs1.i235.i, %build_sso.i227.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i200.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i202.i)
  br label %archx_str_drop.exit84.i

archx_str_concat.exit237.i:                       ; preds = %alloc_heap.i212.i
  %hp_i.i216.i = ptrtoint ptr %hp.i213.i to i64
  %htagged.i217.i = or disjoint i64 %hp_i.i216.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i213.i, ptr nonnull align 1 %aptr.i772.i, i64 %alen.i.i, i1 false)
  %dst_b.i218.i = getelementptr inbounds nuw i8, ptr %hp.i213.i, i64 %alen.i.i
  store i16 8224, ptr %dst_b.i218.i, align 1
  %pref32.i219.i = load i32, ptr %hp.i213.i, align 16
  %pref64.i220.i = zext i32 %pref32.i219.i to i64
  %pref_sh.i221.i = shl nuw i64 %pref64.i220.i, 32
  %w0_out.i222.i = or disjoint i64 %pref_sh.i221.i, %tot.i204.i
  %ls0.i223.i = insertvalue %ArchxStr poison, i64 %w0_out.i222.i, 0
  %ls1.i224.i = insertvalue %ArchxStr %ls0.i223.i, i64 %htagged.i217.i, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i200.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i202.i)
  %tag.i79.i = and i64 %aw1.i.i, 1
  %owned.not.i80.i = icmp eq i64 %tag.i79.i, 0
  %or.cond785.i = select i1 %ashort.i.i, i1 true, i1 %owned.not.i80.i
  br i1 %or.cond785.i, label %archx_str_drop.exit84.i, label %do_free.i81.i

do_free.i81.i:                                    ; preds = %archx_str_concat.exit237.i
  %raw.i82.i = and i64 %aw1.i.i, -2
  %ptr.i83.i = inttoptr i64 %raw.i82.i to ptr
  tail call void @free(ptr %ptr.i83.i)
  br label %archx_str_drop.exit84.i

archx_str_drop.exit84.i:                          ; preds = %do_free.i81.i, %archx_str_concat.exit237.i, %archx_str_concat.exit237.thread.i
  %common.ret.op.i225775.i = phi %ArchxStr [ %common.ret.op.i225.ph.i, %archx_str_concat.exit237.thread.i ], [ %ls1.i224.i, %archx_str_concat.exit237.i ], [ %ls1.i224.i, %do_free.i81.i ]
  %long.i87.i = icmp samesign ult i64 %blen.i156.i, 13
  %tag.i90.i = and i64 %bw1.i155.i, 1
  %owned.not.i91.i = icmp eq i64 %tag.i90.i, 0
  %or.cond786.i = select i1 %long.i87.i, i1 true, i1 %owned.not.i91.i
  br i1 %or.cond786.i, label %archx_str_drop.exit95.i, label %do_free.i92.i

do_free.i92.i:                                    ; preds = %archx_str_drop.exit84.i
  %raw.i93.i = and i64 %bw1.i155.i, -2
  %ptr.i94.i = inttoptr i64 %raw.i93.i to ptr
  tail call void @free(ptr %ptr.i94.i)
  br label %archx_str_drop.exit95.i

archx_str_drop.exit95.i:                          ; preds = %do_free.i92.i, %archx_str_drop.exit84.i
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i.i)
  %w0.i580.i = extractvalue %ArchxStr %common.ret.op.i225775.i, 0
  %w1.i581.i = extractvalue %ArchxStr %common.ret.op.i225775.i, 1
  %len.i582.i = and i64 %w0.i580.i, 4294967295
  %short.i.i = icmp samesign ult i64 %len.i582.i, 13
  br i1 %short.i.i, label %trim_l_pre.i.i, label %trim_l_pre.thread.i.i

trim_l_pre.thread.i.i:                            ; preds = %archx_str_drop.exit95.i
  %raw.i583.i = and i64 %w1.i581.i, -4
  %lp.i.i = inttoptr i64 %raw.i583.i to ptr
  br label %trim_l_chk.preheader.i.i

trim_l_pre.i.i:                                   ; preds = %archx_str_drop.exit95.i
  %p4.i.i = lshr i64 %w0.i580.i, 32
  %p4_32.i.i = trunc nuw i64 %p4.i.i to i32
  store i32 %p4_32.i.i, ptr %tmp.i.i, align 4
  store i64 %w1.i581.i, ptr %t4.i.i1062, align 4
  %lo_lt4.not.i.i = icmp eq i64 %len.i582.i, 0
  br i1 %lo_lt4.not.i.i, label %archx_str_strip.exit.i, label %trim_l_chk.preheader.i.i

trim_l_chk.preheader.i.i:                         ; preds = %trim_l_pre.i.i, %trim_l_pre.thread.i.i
  %data15.i.i = phi ptr [ %lp.i.i, %trim_l_pre.thread.i.i ], [ %tmp.i.i, %trim_l_pre.i.i ]
  br label %trim_l_chk.i.i

trim_l_chk.i.i:                                   ; preds = %trim_l_ws.i.i, %trim_l_chk.preheader.i.i
  %lo5.i.i = phi i64 [ %lo_next.i.i, %trim_l_ws.i.i ], [ 0, %trim_l_chk.preheader.i.i ]
  %lp_c.i.i = getelementptr inbounds nuw i8, ptr %data15.i.i, i64 %lo5.i.i
  %lc.i.i = load i8, ptr %lp_c.i.i, align 1
  switch i8 %lc.i.i, label %trim_r.preheader.i.i [
    i8 32, label %trim_l_ws.i.i
    i8 13, label %trim_l_ws.i.i
    i8 12, label %trim_l_ws.i.i
    i8 11, label %trim_l_ws.i.i
    i8 10, label %trim_l_ws.i.i
    i8 9, label %trim_l_ws.i.i
  ]

trim_r.preheader.i.i:                             ; preds = %trim_l_chk.i.i
  %lp_c.i.i.le = getelementptr inbounds nuw i8, ptr %data15.i.i, i64 %lo5.i.i
  %hi_gt6.i.i = icmp samesign ugt i64 %len.i582.i, %lo5.i.i
  br i1 %hi_gt6.i.i, label %trim_r_chk.i.i, label %archx_str_strip.exit.i

trim_l_ws.i.i:                                    ; preds = %trim_l_chk.i.i, %trim_l_chk.i.i, %trim_l_chk.i.i, %trim_l_chk.i.i, %trim_l_chk.i.i, %trim_l_chk.i.i
  %lo_next.i.i = add nuw nsw i64 %lo5.i.i, 1
  %exitcond.not.i.i = icmp eq i64 %lo_next.i.i, %len.i582.i
  br i1 %exitcond.not.i.i, label %archx_str_strip.exit.i, label %trim_l_chk.i.i

trim_r_chk.i.i:                                   ; preds = %trim_r.preheader.i.i, %trim_r.backedge.i.i
  %hi7.i.i = phi i64 [ %hi_prev.i.i, %trim_r.backedge.i.i ], [ %len.i582.i, %trim_r.preheader.i.i ]
  %hi_prev.i.i = add nsw i64 %hi7.i.i, -1
  %rp_c.i.i = getelementptr inbounds nuw i8, ptr %data15.i.i, i64 %hi_prev.i.i
  %rc.i.i = load i8, ptr %rp_c.i.i, align 1
  switch i8 %rc.i.i, label %build.i585.i [
    i8 32, label %trim_r.backedge.i.i
    i8 13, label %trim_r.backedge.i.i
    i8 12, label %trim_r.backedge.i.i
    i8 11, label %trim_r.backedge.i.i
    i8 10, label %trim_r.backedge.i.i
    i8 9, label %trim_r.backedge.i.i
  ]

trim_r.backedge.i.i:                              ; preds = %trim_r_chk.i.i, %trim_r_chk.i.i, %trim_r_chk.i.i, %trim_r_chk.i.i, %trim_r_chk.i.i, %trim_r_chk.i.i
  %hi_gt.i.i = icmp ugt i64 %hi_prev.i.i, %lo5.i.i
  br i1 %hi_gt.i.i, label %trim_r_chk.i.i, label %archx_str_strip.exit.i

build.i585.i:                                     ; preds = %trim_r_chk.i.i
  %nlen.i.i = sub nuw nsw i64 %hi7.i.i, %lo5.i.i
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i579.i)
  %z.i.i586.i = icmp slt i64 %nlen.i.i, 1
  br i1 %z.i.i586.i, label %archx_str_from_slice.exit.i.i, label %chk_big.i.i.i

chk_big.i.i.i:                                    ; preds = %build.i585.i
  %big.i.i.i = icmp samesign ugt i64 %nlen.i.i, 2147483647
  br i1 %big.i.i.i, label %oom.i.i602.i, label %chk_sso.i.i587.i

oom.i.i602.i:                                     ; preds = %alloc_heap.i.i589.i, %chk_big.i.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i587.i:                                 ; preds = %chk_big.i.i.i
  %short.i.i588.i = icmp samesign ult i64 %nlen.i.i, 13
  br i1 %short.i.i588.i, label %pack_sso.i.i603.i, label %alloc_heap.i.i589.i

pack_sso.i.i603.i:                                ; preds = %chk_sso.i.i587.i
  %len32.i.i.i = trunc nuw nsw i64 %nlen.i.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i579.i, i8 0, i64 16, i1 false)
  store i32 %len32.i.i.i, ptr %sso.i.i579.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i579.i.4.sroa_idx, ptr nonnull readonly align 1 %lp_c.i.i.le, i64 %nlen.i.i, i1 false)
  %sso.i.i579.i.0.sso.i.i579.i.0.sso.i.i579.i.0.sso.i.i579.0.sso.i.i579.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i604.i = load i64, ptr %sso.i.i579.i, align 8
  %sso.i.i579.i.8.sso.i.i579.i.8.sso.i.i579.i.8.sso.i.i579.8.sso.i.i579.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i605.i = load i64, ptr %sso.i.i579.i.8.sroa_idx, align 8
  %ss0.i.i606.i = insertvalue %ArchxStr poison, i64 %sso.i.i579.i.0.sso.i.i579.i.0.sso.i.i579.i.0.sso.i.i579.0.sso.i.i579.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i604.i, 0
  %ss1.i.i607.i = insertvalue %ArchxStr %ss0.i.i606.i, i64 %sso.i.i579.i.8.sso.i.i579.i.8.sso.i.i579.i.8.sso.i.i579.8.sso.i.i579.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i605.i, 1
  br label %archx_str_from_slice.exit.i.i

alloc_heap.i.i589.i:                              ; preds = %chk_sso.i.i587.i
  %hp.i.i590.i = tail call noalias align 16 ptr @malloc(i64 %nlen.i.i)
  %hnull.i.i591.i = icmp eq ptr %hp.i.i590.i, null
  br i1 %hnull.i.i591.i, label %oom.i.i602.i, label %copy_long.i.i592.i

copy_long.i.i592.i:                               ; preds = %alloc_heap.i.i589.i
  %hp_i.i.i593.i = ptrtoint ptr %hp.i.i590.i to i64
  %htagged.i.i594.i = or disjoint i64 %hp_i.i.i593.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i590.i, ptr nonnull readonly align 1 %lp_c.i.i.le, i64 %nlen.i.i, i1 false)
  %pref32.i.i595.i = load i32, ptr %hp.i.i590.i, align 16
  %pref64.i.i596.i = zext i32 %pref32.i.i595.i to i64
  %pref_sh.i.i597.i = shl nuw i64 %pref64.i.i596.i, 32
  %w0_out.i.i598.i = or disjoint i64 %pref_sh.i.i597.i, %nlen.i.i
  %ls0.i.i599.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i598.i, 0
  %ls1.i.i600.i = insertvalue %ArchxStr %ls0.i.i599.i, i64 %htagged.i.i594.i, 1
  br label %archx_str_from_slice.exit.i.i

archx_str_from_slice.exit.i.i:                    ; preds = %copy_long.i.i592.i, %pack_sso.i.i603.i, %build.i585.i
  %common.ret.op.i.i601.i = phi %ArchxStr [ %ss1.i.i607.i, %pack_sso.i.i603.i ], [ %ls1.i.i600.i, %copy_long.i.i592.i ], [ zeroinitializer, %build.i585.i ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i579.i)
  br label %archx_str_strip.exit.i

archx_str_strip.exit.i:                           ; preds = %trim_l_ws.i.i, %trim_r.backedge.i.i, %archx_str_from_slice.exit.i.i, %trim_r.preheader.i.i, %trim_l_pre.i.i
  %common.ret.op.i584.i = phi %ArchxStr [ %common.ret.op.i.i601.i, %archx_str_from_slice.exit.i.i ], [ zeroinitializer, %trim_r.preheader.i.i ], [ zeroinitializer, %trim_l_pre.i.i ], [ zeroinitializer, %trim_r.backedge.i.i ], [ zeroinitializer, %trim_l_ws.i.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i609.i)
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %sbuf.i.i)
  %w0.i610.i = extractvalue %ArchxStr %common.ret.op.i584.i, 0
  %w1.i611.i = extractvalue %ArchxStr %common.ret.op.i584.i, 1
  %len.i612.i = and i64 %w0.i610.i, 4294967295
  %z.i.i = icmp eq i64 %len.i612.i, 0
  br i1 %z.i.i, label %archx_str_case.exit.i, label %mat.i.i

mat.i.i:                                          ; preds = %archx_str_strip.exit.i
  %short.i613.i = icmp samesign ult i64 %len.i612.i, 13
  br i1 %short.i613.i, label %alloc_dst.thread.i.i, label %alloc_dst.i.i

alloc_dst.thread.i.i:                             ; preds = %mat.i.i
  %p4.i641.i = lshr i64 %w0.i610.i, 32
  %p4_32.i642.i = trunc nuw i64 %p4.i641.i to i32
  store i32 %p4_32.i642.i, ptr %tmp.i609.i, align 4
  store i64 %w1.i611.i, ptr %t4.i643.i, align 4
  br label %iter.check

alloc_dst.i.i:                                    ; preds = %mat.i.i
  %raw.i614.i = and i64 %w1.i611.i, -4
  %lp.i615.i = inttoptr i64 %raw.i614.i to ptr
  %fits.i.i = icmp samesign ugt i64 %len.i612.i, 64
  br i1 %fits.i.i, label %use_heap.i.i, label %iter.check

use_heap.i.i:                                     ; preds = %alloc_dst.i.i
  %hp.i639.i = tail call noalias ptr @malloc(i64 %len.i612.i)
  %hn.i.i = icmp eq ptr %hp.i639.i, null
  br i1 %hn.i.i, label %oom.i640.i, label %iter.check

oom.i640.i:                                       ; preds = %use_heap.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

iter.check:                                       ; preds = %use_heap.i.i, %alloc_dst.i.i, %alloc_dst.thread.i.i
  %fits4.i.i = phi i1 [ true, %use_heap.i.i ], [ false, %alloc_dst.i.i ], [ false, %alloc_dst.thread.i.i ]
  %src3.i.i = phi ptr [ %lp.i615.i, %use_heap.i.i ], [ %lp.i615.i, %alloc_dst.i.i ], [ %tmp.i609.i, %alloc_dst.thread.i.i ]
  %dst.i.i = phi ptr [ %hp.i639.i, %use_heap.i.i ], [ %sbuf.i.i, %alloc_dst.i.i ], [ %sbuf.i.i, %alloc_dst.thread.i.i ]
  %min.iters.check = icmp samesign ult i64 %len.i612.i, 8
  br i1 %min.iters.check, label %loop.i.i.preheader, label %vector.main.loop.iter.check

vector.main.loop.iter.check:                      ; preds = %iter.check
  %min.iters.check1833 = icmp samesign ult i64 %len.i612.i, 32
  br i1 %min.iters.check1833, label %vec.epilog.ph, label %vector.ph1834

vector.ph1834:                                    ; preds = %vector.main.loop.iter.check
  %n.vec = and i64 %w0.i610.i, 4294967264
  br label %vector.body1835

vector.body1835:                                  ; preds = %vector.body1835, %vector.ph1834
  %index1836 = phi i64 [ 0, %vector.ph1834 ], [ %index.next1839, %vector.body1835 ]
  %33 = getelementptr inbounds nuw i8, ptr %src3.i.i, i64 %index1836
  %34 = getelementptr inbounds nuw i8, ptr %33, i64 16
  %wide.load1837 = load <16 x i8>, ptr %33, align 1
  %wide.load1838 = load <16 x i8>, ptr %34, align 1
  %35 = add <16 x i8> %wide.load1837, splat (i8 -65)
  %36 = add <16 x i8> %wide.load1838, splat (i8 -65)
  %37 = icmp ult <16 x i8> %35, splat (i8 26)
  %38 = icmp ult <16 x i8> %36, splat (i8 26)
  %39 = add <16 x i8> %wide.load1837, splat (i8 32)
  %40 = add <16 x i8> %wide.load1838, splat (i8 32)
  %41 = select <16 x i1> %37, <16 x i8> %39, <16 x i8> %wide.load1837
  %42 = select <16 x i1> %38, <16 x i8> %40, <16 x i8> %wide.load1838
  %43 = getelementptr inbounds nuw i8, ptr %dst.i.i, i64 %index1836
  %44 = getelementptr inbounds nuw i8, ptr %43, i64 16
  store <16 x i8> %41, ptr %43, align 1
  store <16 x i8> %42, ptr %44, align 1
  %index.next1839 = add nuw i64 %index1836, 32
  %45 = icmp eq i64 %index.next1839, %n.vec
  br i1 %45, label %middle.block1840, label %vector.body1835, !llvm.loop !4

middle.block1840:                                 ; preds = %vector.body1835
  %cmp.n = icmp eq i64 %len.i612.i, %n.vec
  br i1 %cmp.n, label %chk_big.i.i617.i, label %vec.epilog.iter.check

vec.epilog.iter.check:                            ; preds = %middle.block1840
  %n.vec.remaining = and i64 %w0.i610.i, 24
  %min.epilog.iters.check = icmp eq i64 %n.vec.remaining, 0
  br i1 %min.epilog.iters.check, label %loop.i.i.preheader, label %vec.epilog.ph

vec.epilog.ph:                                    ; preds = %vec.epilog.iter.check, %vector.main.loop.iter.check
  %vec.epilog.resume.val = phi i64 [ %n.vec, %vec.epilog.iter.check ], [ 0, %vector.main.loop.iter.check ]
  %n.vec1842 = and i64 %w0.i610.i, 4294967288
  br label %vec.epilog.vector.body

vec.epilog.vector.body:                           ; preds = %vec.epilog.vector.body, %vec.epilog.ph
  %index1843 = phi i64 [ %vec.epilog.resume.val, %vec.epilog.ph ], [ %index.next1845, %vec.epilog.vector.body ]
  %46 = getelementptr inbounds nuw i8, ptr %src3.i.i, i64 %index1843
  %wide.load1844 = load <8 x i8>, ptr %46, align 1
  %47 = add <8 x i8> %wide.load1844, splat (i8 -65)
  %48 = icmp ult <8 x i8> %47, splat (i8 26)
  %49 = add <8 x i8> %wide.load1844, splat (i8 32)
  %50 = select <8 x i1> %48, <8 x i8> %49, <8 x i8> %wide.load1844
  %51 = getelementptr inbounds nuw i8, ptr %dst.i.i, i64 %index1843
  store <8 x i8> %50, ptr %51, align 1
  %index.next1845 = add nuw i64 %index1843, 8
  %52 = icmp eq i64 %index.next1845, %n.vec1842
  br i1 %52, label %vec.epilog.middle.block, label %vec.epilog.vector.body, !llvm.loop !5

vec.epilog.middle.block:                          ; preds = %vec.epilog.vector.body
  %cmp.n1846 = icmp eq i64 %len.i612.i, %n.vec1842
  br i1 %cmp.n1846, label %chk_big.i.i617.i, label %loop.i.i.preheader

loop.i.i.preheader:                               ; preds = %vec.epilog.iter.check, %vec.epilog.middle.block, %iter.check
  %i.i.i.ph = phi i64 [ 0, %iter.check ], [ %n.vec, %vec.epilog.iter.check ], [ %n.vec1842, %vec.epilog.middle.block ]
  br label %loop.i.i

loop.i.i:                                         ; preds = %loop.i.i.preheader, %loop.i.i
  %i.i.i = phi i64 [ %inext.i.i, %loop.i.i ], [ %i.i.i.ph, %loop.i.i.preheader ]
  %sp.i.i = getelementptr inbounds nuw i8, ptr %src3.i.i, i64 %i.i.i
  %c.i.i = load i8, ptr %sp.i.i, align 1
  %hi_s.i.i = add i8 %c.i.i, -65
  %is_hi.i.i = icmp ult i8 %hi_s.i.i, 26
  %lo_c.i.i = add i8 %c.i.i, 32
  %c2.i.i = select i1 %is_hi.i.i, i8 %lo_c.i.i, i8 %c.i.i
  %dp.i.i = getelementptr inbounds nuw i8, ptr %dst.i.i, i64 %i.i.i
  store i8 %c2.i.i, ptr %dp.i.i, align 1
  %inext.i.i = add nuw nsw i64 %i.i.i, 1
  %exitcond.not.i616.i = icmp eq i64 %inext.i.i, %len.i612.i
  br i1 %exitcond.not.i616.i, label %chk_big.i.i617.i, label %loop.i.i, !llvm.loop !6

chk_big.i.i617.i:                                 ; preds = %loop.i.i, %vec.epilog.middle.block, %middle.block1840
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i608.i)
  %big.i.i618.i = icmp samesign ugt i64 %len.i612.i, 2147483647
  br i1 %big.i.i618.i, label %oom.i.i634.i, label %chk_sso.i.i619.i

oom.i.i634.i:                                     ; preds = %alloc_heap.i.i620.i, %chk_big.i.i617.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i619.i:                                 ; preds = %chk_big.i.i617.i
  br i1 %short.i613.i, label %pack_sso.i.i635.i, label %alloc_heap.i.i620.i

pack_sso.i.i635.i:                                ; preds = %chk_sso.i.i619.i
  %len32.i.i636.i = trunc i64 %w0.i610.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i608.i, i8 0, i64 16, i1 false)
  store i32 %len32.i.i636.i, ptr %sso.i.i608.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i608.i.4.sroa_idx, ptr nonnull readonly align 1 %dst.i.i, i64 %len.i612.i, i1 false)
  %sso.i.i608.i.0.sso.i.i608.i.0.sso.i.i608.i.0.sso.i.i608.0.sso.i.i608.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i637.i = load i64, ptr %sso.i.i608.i, align 8
  %sso.i.i608.i.8.sso.i.i608.i.8.sso.i.i608.i.8.sso.i.i608.8.sso.i.i608.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i638.i = load i64, ptr %sso.i.i608.i.8.sroa_idx, align 8
  br label %archx_str_from_slice.exit.i630.i

alloc_heap.i.i620.i:                              ; preds = %chk_sso.i.i619.i
  %hp.i.i621.i = tail call noalias align 16 ptr @malloc(i64 %len.i612.i)
  %hnull.i.i622.i = icmp eq ptr %hp.i.i621.i, null
  br i1 %hnull.i.i622.i, label %oom.i.i634.i, label %copy_long.i.i623.i

copy_long.i.i623.i:                               ; preds = %alloc_heap.i.i620.i
  %hp_i.i.i624.i = ptrtoint ptr %hp.i.i621.i to i64
  %htagged.i.i625.i = or disjoint i64 %hp_i.i.i624.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i621.i, ptr nonnull readonly align 1 %dst.i.i, i64 %len.i612.i, i1 false)
  %pref32.i.i626.i = load i32, ptr %hp.i.i621.i, align 16
  %pref64.i.i627.i = zext i32 %pref32.i.i626.i to i64
  %pref_sh.i.i628.i = shl nuw i64 %pref64.i.i627.i, 32
  %w0_out.i.i629.i = or disjoint i64 %pref_sh.i.i628.i, %len.i612.i
  br label %archx_str_from_slice.exit.i630.i

archx_str_from_slice.exit.i630.i:                 ; preds = %copy_long.i.i623.i, %pack_sso.i.i635.i
  %sso.i.0.sso.0.sso.0.sso.0.sw0.i.pn.i.i = phi i64 [ %sso.i.i608.i.0.sso.i.i608.i.0.sso.i.i608.i.0.sso.i.i608.0.sso.i.i608.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i637.i, %pack_sso.i.i635.i ], [ %w0_out.i.i629.i, %copy_long.i.i623.i ]
  %sso.i.8.sso.8.sso.8.sso.8.sw1.i.pn.i.i = phi i64 [ %sso.i.i608.i.8.sso.i.i608.i.8.sso.i.i608.i.8.sso.i.i608.8.sso.i.i608.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i638.i, %pack_sso.i.i635.i ], [ %htagged.i.i625.i, %copy_long.i.i623.i ]
  %ss0.i.pn.i.i = insertvalue %ArchxStr poison, i64 %sso.i.0.sso.0.sso.0.sso.0.sw0.i.pn.i.i, 0
  %common.ret.op.i.i631.i = insertvalue %ArchxStr %ss0.i.pn.i.i, i64 %sso.i.8.sso.8.sso.8.sso.8.sw1.i.pn.i.i, 1
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i608.i)
  br i1 %fits4.i.i, label %do_free.i633.i, label %archx_str_case.exit.i

do_free.i633.i:                                   ; preds = %archx_str_from_slice.exit.i630.i
  call void @free(ptr nonnull %dst.i.i)
  br label %archx_str_case.exit.i

archx_str_case.exit.i:                            ; preds = %do_free.i633.i, %archx_str_from_slice.exit.i630.i, %archx_str_strip.exit.i
  %common.ret.op.i632.i = phi %ArchxStr [ zeroinitializer, %archx_str_strip.exit.i ], [ %common.ret.op.i.i631.i, %do_free.i633.i ], [ %common.ret.op.i.i631.i, %archx_str_from_slice.exit.i630.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i609.i)
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %sbuf.i.i)
  %t69.i1063 = icmp slt i64 %var.vocab.4.sroa.17.0865.i, 0
  %t71.i1064 = tail call i64 @llvm.abs.i64(i64 %var.vocab.4.sroa.17.0865.i, i1 true)
  %t72.not.i = icmp samesign ult i64 %var.vocab.4.sroa.0.0864.i, %t71.i1064
  br i1 %t72.not.i, label %push.store.24.i, label %push.calc.26.i

push.calc.26.i:                                   ; preds = %archx_str_case.exit.i
  %t74.i = icmp eq i64 %var.vocab.4.sroa.17.0865.i, 0
  %t75.i = shl nuw i64 %t71.i1064, 1
  %53 = tail call i64 @llvm.smin.i64(i64 %t75.i, i64 140737488355328)
  %t78.i = select i1 %t74.i, i64 4, i64 %53
  %54 = add i64 %t78.i, -576460752303423488
  %t81.i = icmp ult i64 %54, -1152921504606846976
  br i1 %t81.i, label %mul.oom.27.i, label %mul.ok.28.i

mul.oom.27.i:                                     ; preds = %push.calc.26.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mul.ok.28.i:                                      ; preds = %push.calc.26.i
  %t80.i1065 = shl nsw i64 %t78.i, 4
  %t83.i = tail call i64 @llvm.umax.i64(i64 %t80.i1065, i64 1)
  br i1 %t69.i1063, label %mul.ok.32.i, label %push.grow.from_heap.30.i

mul.ok.32.i:                                      ; preds = %mul.ok.28.i
  %t89.i = tail call noalias align 16 ptr @malloc(i64 %t83.i)
  %t90.i1067 = icmp eq ptr %t89.i, null
  br i1 %t90.i1067, label %alloc.oom.34.i, label %push.reg.copy.35.i

alloc.oom.34.i:                                   ; preds = %mul.ok.32.i
  tail call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.35.i:                               ; preds = %mul.ok.32.i
  %t85.i = shl nuw nsw i64 %var.vocab.4.sroa.0.0864.i, 4
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t89.i, ptr noundef nonnull align 8 dereferenceable(1) %var.vocab.4.sroa.34.0866.i, i64 %t85.i, i1 false)
  br label %push.store.24.i

push.grow.from_heap.30.i:                         ; preds = %mul.ok.28.i
  %t95.i = tail call align 16 ptr @realloc(ptr %var.vocab.4.sroa.34.0866.i, i64 %t83.i)
  %t96.i = icmp eq ptr %t95.i, null
  br i1 %t96.i, label %realloc.oom.38.i, label %push.store.24.i

realloc.oom.38.i:                                 ; preds = %push.grow.from_heap.30.i
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.24.i:                                  ; preds = %push.grow.from_heap.30.i, %push.reg.copy.35.i, %archx_str_case.exit.i
  %var.vocab.4.sroa.17.2.i = phi i64 [ %var.vocab.4.sroa.17.0865.i, %archx_str_case.exit.i ], [ %t78.i, %push.reg.copy.35.i ], [ %t78.i, %push.grow.from_heap.30.i ]
  %var.vocab.4.sroa.34.2.i = phi ptr [ %var.vocab.4.sroa.34.0866.i, %archx_str_case.exit.i ], [ %t89.i, %push.reg.copy.35.i ], [ %t95.i, %push.grow.from_heap.30.i ]
  %t102.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.2.i, i64 %var.vocab.4.sroa.0.0864.i
  %t64.elt.i = extractvalue %ArchxStr %common.ret.op.i632.i, 0
  store i64 %t64.elt.i, ptr %t102.i, align 8
  %t102.repack70.i = getelementptr inbounds nuw i8, ptr %t102.i, i64 8
  %t64.elt71.i = extractvalue %ArchxStr %common.ret.op.i632.i, 1
  store i64 %t64.elt71.i, ptr %t102.repack70.i, align 8
  %long.i98.i = icmp samesign ult i64 %len.i612.i, 13
  %tag.i101.i = and i64 %w1.i611.i, 1
  %owned.not.i102.i = icmp eq i64 %tag.i101.i, 0
  %or.cond787.i = select i1 %long.i98.i, i1 true, i1 %owned.not.i102.i
  br i1 %or.cond787.i, label %archx_str_drop.exit106.i, label %do_free.i103.i

do_free.i103.i:                                   ; preds = %push.store.24.i
  %raw.i104.i = and i64 %w1.i611.i, -2
  %ptr.i105.i = inttoptr i64 %raw.i104.i to ptr
  tail call void @free(ptr %ptr.i105.i)
  br label %archx_str_drop.exit106.i

archx_str_drop.exit106.i:                         ; preds = %do_free.i103.i, %push.store.24.i
  %tag.i112.i = and i64 %w1.i581.i, 1
  %owned.not.i113.i = icmp eq i64 %tag.i112.i, 0
  %or.cond788.i = select i1 %short.i.i, i1 true, i1 %owned.not.i113.i
  br i1 %or.cond788.i, label %for.step.2.i, label %for.step.2.sink.split.i

for.step.2.sink.split.i:                          ; preds = %archx_str_drop.exit106.i, %push.store.8.i
  %w1.i581.sink.i = phi i64 [ %bw1.i.i, %push.store.8.i ], [ %w1.i581.i, %archx_str_drop.exit106.i ]
  %var.vocab.4.sroa.17.3.ph.i = phi i64 [ %var.vocab.4.sroa.17.1.i, %push.store.8.i ], [ %var.vocab.4.sroa.17.2.i, %archx_str_drop.exit106.i ]
  %var.vocab.4.sroa.34.3.ph.i = phi ptr [ %var.vocab.4.sroa.34.1.i, %push.store.8.i ], [ %var.vocab.4.sroa.34.2.i, %archx_str_drop.exit106.i ]
  %raw.i115.i = and i64 %w1.i581.sink.i, -2
  %ptr.i116.i = inttoptr i64 %raw.i115.i to ptr
  tail call void @free(ptr %ptr.i116.i)
  br label %for.step.2.i

for.step.2.i:                                     ; preds = %for.step.2.sink.split.i, %archx_str_drop.exit106.i, %push.store.8.i
  %var.vocab.4.sroa.17.3.i = phi i64 [ %var.vocab.4.sroa.17.1.i, %push.store.8.i ], [ %var.vocab.4.sroa.17.2.i, %archx_str_drop.exit106.i ], [ %var.vocab.4.sroa.17.3.ph.i, %for.step.2.sink.split.i ]
  %var.vocab.4.sroa.34.3.i = phi ptr [ %var.vocab.4.sroa.34.1.i, %push.store.8.i ], [ %var.vocab.4.sroa.34.2.i, %archx_str_drop.exit106.i ], [ %var.vocab.4.sroa.34.3.ph.i, %for.step.2.sink.split.i ]
  %var.vocab.4.sroa.0.3.i = add nuw nsw i64 %var.vocab.4.sroa.0.0864.i, 1
  %exitcond.not.i1066 = icmp eq i64 %var.vocab.4.sroa.0.3.i, 512
  br i1 %exitcond.not.i1066, label %for.end.3.i, label %for.body.1.i

for.end.3.i:                                      ; preds = %for.step.2.i
  %buf.i644.i = tail call noalias dereferenceable_or_null(20) ptr @malloc(i64 20)
  %bnull.i.i = icmp eq ptr %buf.i644.i, null
  br i1 %bnull.i.i, label %oom.i656.i, label %sloop.preheader.i.i

sloop.preheader.i.i:                              ; preds = %for.end.3.i
  store <16 x i8> <i8 110, i8 111, i8 104, i8 116, i8 121, i8 112, i8 95, i8 115, i8 109, i8 101, i8 116, i8 115, i8 121, i8 115, i8 95, i8 120>, ptr %buf.i644.i, align 1
  %dp.16.i.i = getelementptr inbounds nuw i8, ptr %buf.i644.i, i64 16
  store <4 x i8> <i8 104, i8 99, i8 114, i8 97>, ptr %dp.16.i.i, align 1
  %hp.i.i645.i = tail call noalias align 16 dereferenceable_or_null(20) ptr @malloc(i64 20)
  %hnull.i.i646.i = icmp eq ptr %hp.i.i645.i, null
  br i1 %hnull.i.i646.i, label %oom.i.i655.i, label %archx_str_slice.exit.i

oom.i656.i:                                       ; preds = %for.end.3.i
  tail call fastcc void @archx_oom_fail()
  unreachable

oom.i.i655.i:                                     ; preds = %sloop.preheader.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

archx_str_slice.exit.i:                           ; preds = %sloop.preheader.i.i
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(20) %hp.i.i645.i, ptr noundef nonnull readonly align 1 dereferenceable(20) %buf.i644.i, i64 20, i1 false)
  %pref32.i.i649.i = load i32, ptr %hp.i.i645.i, align 16
  tail call void @free(ptr nonnull %buf.i644.i)
  br label %for.body.40.i

for.body.40.i:                                    ; preds = %archx_region_rewind_root.exit.i, %archx_str_slice.exit.i
  %var.checksum.114.0900.i = phi i64 [ 0, %archx_str_slice.exit.i ], [ %var.checksum.114.3.lcssa964.i, %archx_region_rewind_root.exit.i ]
  %for.r.118.0899.i = phi i64 [ 0, %archx_str_slice.exit.i ], [ %t275.i, %archx_region_rewind_root.exit.i ]
  %cur.i.i.i = load ptr, ptr %func.region.i, align 8
  %end.i.i.i = load ptr, ptr %.fca.1.gep.i, align 8
  %cur_i.i.i.i = ptrtoint ptr %cur.i.i.i to i64
  %end_i.i.i.i = ptrtoint ptr %end.i.i.i to i64
  %rem.i.i.i = sub i64 %end_i.i.i.i, %cur_i.i.i.i
  %fits.not.i.i.i = icmp slt i64 %rem.i.i.i, 64
  br i1 %fits.not.i.i.i, label %fallback.i.i.i, label %fast.i.i.i

fast.i.i.i:                                       ; preds = %for.body.40.i
  %next.i.i.i = getelementptr inbounds nuw i8, ptr %cur.i.i.i, i64 64
  store ptr %next.i.i.i, ptr %func.region.i, align 8
  br label %archx_dict_new.exit.i

fallback.i.i.i:                                   ; preds = %for.body.40.i
  %res.i.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 64)
  %.pre.i.i = ptrtoint ptr %res.i.i.i to i64
  %cur.i.i659.pre.i = load ptr, ptr %func.region.i, align 8
  %end.i.i660.pre.i = load ptr, ptr %.fca.1.gep.i, align 8
  %.pre.i = ptrtoint ptr %end.i.i660.pre.i to i64
  br label %archx_dict_new.exit.i

archx_dict_new.exit.i:                            ; preds = %fallback.i.i.i, %fast.i.i.i
  %end_i.i.i662.pre-phi.i = phi i64 [ %end_i.i.i.i, %fast.i.i.i ], [ %.pre.i, %fallback.i.i.i ]
  %cur.i.i659.i = phi ptr [ %next.i.i.i, %fast.i.i.i ], [ %cur.i.i659.pre.i, %fallback.i.i.i ]
  %rpi.pre-phi.i.i = phi i64 [ %cur_i.i.i.i, %fast.i.i.i ], [ %.pre.i.i, %fallback.i.i.i ]
  %common.ret.op.i.i657.i = phi ptr [ %cur.i.i.i, %fast.i.i.i ], [ %res.i.i.i, %fallback.i.i.i ]
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(64) %common.ret.op.i.i657.i, i8 0, i64 64, i1 false)
  %r_reg_gep.i.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i657.i, i64 24
  store ptr %func.region.i, ptr %r_reg_gep.i.i, align 8
  %r_meta_gep.i.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i657.i, i64 56
  store i64 34359742465, ptr %r_meta_gep.i.i, align 8
  %cur_i.i.i661.i = ptrtoint ptr %cur.i.i659.i to i64
  %rem.i.i663.i = sub i64 %end_i.i.i662.pre-phi.i, %cur_i.i.i661.i
  %fits.not.i.i664.i = icmp slt i64 %rem.i.i663.i, 64
  br i1 %fits.not.i.i664.i, label %fallback.i.i672.i, label %fast.i.i665.i

fast.i.i665.i:                                    ; preds = %archx_dict_new.exit.i
  %next.i.i666.i = getelementptr inbounds nuw i8, ptr %cur.i.i659.i, i64 64
  store ptr %next.i.i666.i, ptr %func.region.i, align 8
  br label %for.fast.cond.43.preheader.i

fallback.i.i672.i:                                ; preds = %archx_dict_new.exit.i
  %res.i.i673.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 64)
  %.pre.i674.i = ptrtoint ptr %res.i.i673.i to i64
  br label %for.fast.cond.43.preheader.i

for.fast.cond.43.preheader.i:                     ; preds = %fallback.i.i672.i, %fast.i.i665.i
  %rpi.pre-phi.i667.i = phi i64 [ %cur_i.i.i661.i, %fast.i.i665.i ], [ %.pre.i674.i, %fallback.i.i672.i ]
  %common.ret.op.i.i668.i = phi ptr [ %cur.i.i659.i, %fast.i.i665.i ], [ %res.i.i673.i, %fallback.i.i672.i ]
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(64) %common.ret.op.i.i668.i, i8 0, i64 64, i1 false)
  %r_reg_gep.i669.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i668.i, i64 24
  store ptr %func.region.i, ptr %r_reg_gep.i669.i, align 8
  %r_meta_gep.i670.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i668.i, i64 56
  store i64 2048, ptr %r_meta_gep.i670.i, align 8
  %t140.i = and i64 %rpi.pre-phi.i.i, -4
  %t141.i = inttoptr i64 %t140.i to ptr
  %t142.i = getelementptr inbounds nuw i8, ptr %t141.i, i64 48
  %ctrl_p.i = getelementptr inbounds nuw i8, ptr %t141.i, i64 32
  %is_z.i.i = icmp eq i64 %t140.i, 0
  %mask_p.i.i = getelementptr inbounds nuw i8, ptr %t141.i, i64 16
  %keys_p.i.i = getelementptr inbounds nuw i8, ptr %t141.i, i64 40
  %used_p.i = getelementptr inbounds nuw i8, ptr %t141.i, i64 8
  br label %for.fast.body.44.i

for.fast.body.44.i:                               ; preds = %archx_dict_upsert_str.exit, %for.fast.cond.43.preheader.i
  %for.i.125.0868.i = phi i64 [ 0, %for.fast.cond.43.preheader.i ], [ %t146.i, %archx_dict_upsert_str.exit ]
  %t135.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.3.i, i64 %for.i.125.0868.i
  %t136.unpack.i = load i64, ptr %t135.i, align 8
  %t136.elt67.i = getelementptr inbounds nuw i8, ptr %t135.i, i64 8
  %t136.unpack68.i = load i64, ptr %t136.elt67.i, align 8
  %len.i.i1623 = and i64 %t136.unpack.i, 4294967295
  %short.i.i1624 = icmp samesign ult i64 %len.i.i1623, 13
  br i1 %short.i.i1624, label %sso_hash.i.i, label %long_hash.i.i

sso_hash.i.i:                                     ; preds = %for.fast.body.44.i
  %p0_raw.i.i = lshr i64 %t136.unpack.i, 32
  %le4.i.i = icmp samesign ult i64 %len.i.i1623, 5
  br i1 %le4.i.i, label %sso_le4.i.i, label %sso_gt4.i.i

sso_le4.i.i:                                      ; preds = %sso_hash.i.i
  %sh0.i.i = shl nuw nsw i64 %len.i.i1623, 3
  %notmask1.i.i = shl nsw i64 -1, %sh0.i.i
  %m0.i.i = xor i64 %notmask1.i.i, -1
  %p0_4.i.i = and i64 %p0_raw.i.i, %m0.i.i
  br label %sso_mix.i.i

sso_gt4.i.i:                                      ; preds = %sso_hash.i.i
  %eq12.i.i = icmp eq i64 %len.i.i1623, 12
  br i1 %eq12.i.i, label %sso_mix.i.i, label %sso_mid.i.i

sso_mid.i.i:                                      ; preds = %sso_gt4.i.i
  %rem.i.i = shl nuw nsw i64 %len.i.i1623, 3
  %sh1.i.i = add nsw i64 %rem.i.i, -32
  %notmask.i.i = shl nsw i64 -1, %sh1.i.i
  %m1.i.i = xor i64 %notmask.i.i, -1
  %p1_m.i.i = and i64 %t136.unpack68.i, %m1.i.i
  br label %sso_mix.i.i

sso_mix.i.i:                                      ; preds = %sso_mid.i.i, %sso_gt4.i.i, %sso_le4.i.i
  %p0.i.i = phi i64 [ %p0_4.i.i, %sso_le4.i.i ], [ %p0_raw.i.i, %sso_mid.i.i ], [ %p0_raw.i.i, %sso_gt4.i.i ]
  %p1.i.i = phi i64 [ 0, %sso_le4.i.i ], [ %p1_m.i.i, %sso_mid.i.i ], [ %t136.unpack68.i, %sso_gt4.i.i ]
  %a0.i.i = mul i64 %p0.i.i, -7046029254386353131
  %a1.i.i = mul i64 %p1.i.i, -4417276706812531889
  %ax.i.i = xor i64 %a1.i.i, %a0.i.i
  %s1.i10.i.i = lshr i64 %ax.i.i, 30
  %55 = xor i64 %len.i.i1623, %s1.i10.i.i
  %x1.i11.i.i = xor i64 %55, %ax.i.i
  br label %archx_hash_str.exit.i

long_hash.i.i:                                    ; preds = %for.fast.body.44.i
  %raw.i.i = and i64 %t136.unpack68.i, -4
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  %seed.i.i = mul i64 %len.i.i1623, -7046029254386353131
  %56 = add nsw i64 %len.i.i1623, -8
  %57 = icmp ult i64 %56, 8
  br i1 %57, label %l_tail_cond.i.preheader.i.unr-lcssa, label %long_hash.i.i.new

long_hash.i.i.new:                                ; preds = %long_hash.i.i
  %58 = lshr i64 %56, 3
  %59 = add nuw nsw i64 %58, 1
  %unroll_iter = and i64 %59, 4611686018427387902
  br label %l_body.i.i

l_tail_cond.i.preheader.i.unr-lcssa:              ; preds = %l_body.i.i, %long_hash.i.i
  %acc_next.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i ], [ %acc_next.i.i.1, %l_body.i.i ]
  %idx_next.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i ], [ %idx_next.i.i.1, %l_body.i.i ]
  %acc.i16.i.unr = phi i64 [ %seed.i.i, %long_hash.i.i ], [ %acc_next.i.i.1, %l_body.i.i ]
  %idx.i15.i.unr = phi i64 [ 0, %long_hash.i.i ], [ %idx_next.i.i.1, %l_body.i.i ]
  %60 = and i64 %56, 8
  %lcmp.mod.not.not = icmp eq i64 %60, 0
  br i1 %lcmp.mod.not.not, label %l_body.i.i.epil, label %l_tail_cond.i.preheader.i

l_body.i.i.epil:                                  ; preds = %l_tail_cond.i.preheader.i.unr-lcssa
  %lp.i.i1626.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %idx.i15.i.unr
  %lane.i.i.epil = load i64, ptr %lp.i.i1626.epil, align 4
  %lm.i.i.epil = mul i64 %lane.i.i.epil, -4417276706812531889
  %lx.i.i.epil = xor i64 %lm.i.i.epil, %acc.i16.i.unr
  %s1.i2.i.i.epil = lshr i64 %lx.i.i.epil, 30
  %x1.i3.i.i.epil = xor i64 %s1.i2.i.i.epil, %lx.i.i.epil
  %m1.i4.i.i.epil = mul i64 %x1.i3.i.i.epil, -4658895280553007687
  %s2.i5.i.i.epil = lshr i64 %m1.i4.i.i.epil, 27
  %x2.i6.i.i.epil = xor i64 %s2.i5.i.i.epil, %m1.i4.i.i.epil
  %m2.i7.i.i.epil = mul i64 %x2.i6.i.i.epil, -7723592293110705685
  %s3.i8.i.i.epil = lshr i64 %m2.i7.i.i.epil, 31
  %x3.i9.i.i.epil = xor i64 %s3.i8.i.i.epil, %m2.i7.i.i.epil
  %acc_next.i.i.epil = add i64 %x3.i9.i.i.epil, %idx.i15.i.unr
  %idx_next.i.i.epil = add nuw nsw i64 %idx.i15.i.unr, 8
  br label %l_tail_cond.i.preheader.i

l_tail_cond.i.preheader.i:                        ; preds = %l_tail_cond.i.preheader.i.unr-lcssa, %l_body.i.i.epil
  %acc_next.i.i.lcssa = phi i64 [ %acc_next.i.i.lcssa.ph, %l_tail_cond.i.preheader.i.unr-lcssa ], [ %acc_next.i.i.epil, %l_body.i.i.epil ]
  %idx_next.i.i.lcssa = phi i64 [ %idx_next.i.i.lcssa.ph, %l_tail_cond.i.preheader.i.unr-lcssa ], [ %idx_next.i.i.epil, %l_body.i.i.epil ]
  %tmore.i17.i = icmp samesign ult i64 %idx_next.i.i.lcssa, %len.i.i1623
  br i1 %tmore.i17.i, label %l_tail_body.i.i.preheader, label %l_done.i.i

l_tail_body.i.i.preheader:                        ; preds = %l_tail_cond.i.preheader.i
  %61 = sub i64 %t136.unpack.i, %idx_next.i.i.lcssa
  %xtraiter1889 = and i64 %61, 3
  %lcmp.mod1890.not = icmp eq i64 %xtraiter1889, 0
  br i1 %lcmp.mod1890.not, label %l_tail_body.i.i.prol.loopexit, label %l_tail_body.i.i.prol

l_tail_body.i.i.prol:                             ; preds = %l_tail_body.i.i.preheader, %l_tail_body.i.i.prol
  %tacc.i19.i.prol = phi i64 [ %tacc_next.i.i.prol, %l_tail_body.i.i.prol ], [ %acc_next.i.i.lcssa, %l_tail_body.i.i.preheader ]
  %ti.i18.i.prol = phi i64 [ %ti_next.i.i.prol, %l_tail_body.i.i.prol ], [ %idx_next.i.i.lcssa, %l_tail_body.i.i.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %l_tail_body.i.i.prol ], [ 0, %l_tail_body.i.i.preheader ]
  %tp.i.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %ti.i18.i.prol
  %tb.i.i.prol = load i8, ptr %tp.i.i.prol, align 1
  %tz.i.i.prol = zext i8 %tb.i.i.prol to i64
  %tx.i.i.prol = xor i64 %tacc.i19.i.prol, %tz.i.i.prol
  %tacc_next.i.i.prol = mul i64 %tx.i.i.prol, 1099511628211
  %ti_next.i.i.prol = add nuw nsw i64 %ti.i18.i.prol, 1
  %prol.iter.next = add i64 %prol.iter, 1
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter1889
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.i.prol.loopexit, label %l_tail_body.i.i.prol, !llvm.loop !7

l_tail_body.i.i.prol.loopexit:                    ; preds = %l_tail_body.i.i.prol, %l_tail_body.i.i.preheader
  %tacc.i19.i.unr = phi i64 [ %acc_next.i.i.lcssa, %l_tail_body.i.i.preheader ], [ %tacc_next.i.i.prol, %l_tail_body.i.i.prol ]
  %ti.i18.i.unr = phi i64 [ %idx_next.i.i.lcssa, %l_tail_body.i.i.preheader ], [ %ti_next.i.i.prol, %l_tail_body.i.i.prol ]
  %tacc_next.i.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.preheader ], [ %tacc_next.i.i.prol, %l_tail_body.i.i.prol ]
  %62 = sub i64 %idx_next.i.i.lcssa, %len.i.i1623
  %63 = icmp ugt i64 %62, -4
  br i1 %63, label %l_done.i.i, label %l_tail_body.i.i.preheader.new

l_tail_body.i.i.preheader.new:                    ; preds = %l_tail_body.i.i.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr.i.i, i64 1
  %invariant.gep1919 = getelementptr i8, ptr %ptr.i.i, i64 2
  %invariant.gep1921 = getelementptr i8, ptr %ptr.i.i, i64 3
  br label %l_tail_body.i.i

l_body.i.i:                                       ; preds = %l_body.i.i, %long_hash.i.i.new
  %acc.i16.i = phi i64 [ %seed.i.i, %long_hash.i.i.new ], [ %acc_next.i.i.1, %l_body.i.i ]
  %idx.i15.i = phi i64 [ 0, %long_hash.i.i.new ], [ %idx_next.i.i.1, %l_body.i.i ]
  %niter = phi i64 [ 0, %long_hash.i.i.new ], [ %niter.next.1, %l_body.i.i ]
  %lp.i.i1626 = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %idx.i15.i
  %lane.i.i = load i64, ptr %lp.i.i1626, align 4
  %lm.i.i = mul i64 %lane.i.i, -4417276706812531889
  %lx.i.i = xor i64 %lm.i.i, %acc.i16.i
  %s1.i2.i.i = lshr i64 %lx.i.i, 30
  %x1.i3.i.i = xor i64 %s1.i2.i.i, %lx.i.i
  %m1.i4.i.i = mul i64 %x1.i3.i.i, -4658895280553007687
  %s2.i5.i.i = lshr i64 %m1.i4.i.i, 27
  %x2.i6.i.i = xor i64 %s2.i5.i.i, %m1.i4.i.i
  %m2.i7.i.i = mul i64 %x2.i6.i.i, -7723592293110705685
  %s3.i8.i.i = lshr i64 %m2.i7.i.i, 31
  %x3.i9.i.i = xor i64 %s3.i8.i.i, %m2.i7.i.i
  %acc_next.i.i = add i64 %x3.i9.i.i, %idx.i15.i
  %idx_next.i.i = or disjoint i64 %idx.i15.i, 8
  %lp.i.i1626.1 = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %idx_next.i.i
  %lane.i.i.1 = load i64, ptr %lp.i.i1626.1, align 4
  %lm.i.i.1 = mul i64 %lane.i.i.1, -4417276706812531889
  %lx.i.i.1 = xor i64 %lm.i.i.1, %acc_next.i.i
  %s1.i2.i.i.1 = lshr i64 %lx.i.i.1, 30
  %x1.i3.i.i.1 = xor i64 %s1.i2.i.i.1, %lx.i.i.1
  %m1.i4.i.i.1 = mul i64 %x1.i3.i.i.1, -4658895280553007687
  %s2.i5.i.i.1 = lshr i64 %m1.i4.i.i.1, 27
  %x2.i6.i.i.1 = xor i64 %s2.i5.i.i.1, %m1.i4.i.i.1
  %m2.i7.i.i.1 = mul i64 %x2.i6.i.i.1, -7723592293110705685
  %s3.i8.i.i.1 = lshr i64 %m2.i7.i.i.1, 31
  %x3.i9.i.i.1 = xor i64 %s3.i8.i.i.1, %m2.i7.i.i.1
  %acc_next.i.i.1 = add i64 %x3.i9.i.i.1, %idx_next.i.i
  %idx_next.i.i.1 = add nuw nsw i64 %idx.i15.i, 16
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1.not = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1.not, label %l_tail_cond.i.preheader.i.unr-lcssa, label %l_body.i.i

l_tail_body.i.i:                                  ; preds = %l_tail_body.i.i, %l_tail_body.i.i.preheader.new
  %tacc.i19.i = phi i64 [ %tacc.i19.i.unr, %l_tail_body.i.i.preheader.new ], [ %tacc_next.i.i.3, %l_tail_body.i.i ]
  %ti.i18.i = phi i64 [ %ti.i18.i.unr, %l_tail_body.i.i.preheader.new ], [ %ti_next.i.i.3, %l_tail_body.i.i ]
  %tp.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %ti.i18.i
  %tb.i.i = load i8, ptr %tp.i.i, align 1
  %tz.i.i = zext i8 %tb.i.i to i64
  %tx.i.i = xor i64 %tacc.i19.i, %tz.i.i
  %tacc_next.i.i = mul i64 %tx.i.i, 1099511628211
  %gep = getelementptr i8, ptr %invariant.gep, i64 %ti.i18.i
  %tb.i.i.1 = load i8, ptr %gep, align 1
  %tz.i.i.1 = zext i8 %tb.i.i.1 to i64
  %tx.i.i.1 = xor i64 %tacc_next.i.i, %tz.i.i.1
  %tacc_next.i.i.1 = mul i64 %tx.i.i.1, 1099511628211
  %gep1920 = getelementptr i8, ptr %invariant.gep1919, i64 %ti.i18.i
  %tb.i.i.2 = load i8, ptr %gep1920, align 1
  %tz.i.i.2 = zext i8 %tb.i.i.2 to i64
  %tx.i.i.2 = xor i64 %tacc_next.i.i.1, %tz.i.i.2
  %tacc_next.i.i.2 = mul i64 %tx.i.i.2, 1099511628211
  %gep1922 = getelementptr i8, ptr %invariant.gep1921, i64 %ti.i18.i
  %tb.i.i.3 = load i8, ptr %gep1922, align 1
  %tz.i.i.3 = zext i8 %tb.i.i.3 to i64
  %tx.i.i.3 = xor i64 %tacc_next.i.i.2, %tz.i.i.3
  %tacc_next.i.i.3 = mul i64 %tx.i.i.3, 1099511628211
  %ti_next.i.i.3 = add nuw nsw i64 %ti.i18.i, 4
  %tmore.i.i.3 = icmp samesign ult i64 %ti_next.i.i.3, %len.i.i1623
  br i1 %tmore.i.i.3, label %l_tail_body.i.i, label %l_done.i.i

l_done.i.i:                                       ; preds = %l_tail_body.i.i.prol.loopexit, %l_tail_body.i.i, %l_tail_cond.i.preheader.i
  %tacc.i.lcssa.i = phi i64 [ %acc_next.i.i.lcssa, %l_tail_cond.i.preheader.i ], [ %tacc_next.i.i.lcssa.unr, %l_tail_body.i.i.prol.loopexit ], [ %tacc_next.i.i.3, %l_tail_body.i.i ]
  %s1.i.i.i = lshr i64 %tacc.i.lcssa.i, 30
  %x1.i.i.i = xor i64 %s1.i.i.i, %tacc.i.lcssa.i
  br label %archx_hash_str.exit.i

archx_hash_str.exit.i:                            ; preds = %l_done.i.i, %sso_mix.i.i
  %x1.i11.i.sink.i = phi i64 [ %x1.i11.i.i, %sso_mix.i.i ], [ %x1.i.i.i, %l_done.i.i ]
  %m1.i12.i.i = mul i64 %x1.i11.i.sink.i, -4658895280553007687
  %s2.i13.i.i = lshr i64 %m1.i12.i.i, 27
  %x2.i14.i.i = xor i64 %s2.i13.i.i, %m1.i12.i.i
  %m2.i15.i.i = mul i64 %x2.i14.i.i, -7723592293110705685
  %s3.i16.i.i = lshr i64 %m2.i15.i.i, 31
  %x3.i17.i.i = xor i64 %s3.i16.i.i, %m2.i15.i.i
  %ctrl0.i = load ptr, ptr %ctrl_p.i, align 8
  %uninit.i = icmp eq ptr %ctrl0.i, null
  br i1 %uninit.i, label %probe_insert_init.i, label %chk_probe_existing.i

chk_probe_existing.i:                             ; preds = %archx_hash_str.exit.i
  br i1 %is_z.i.i, label %archx_dict_find_h_str.exit.i, label %do_probe.i.i

do_probe.i.i:                                     ; preds = %chk_probe_existing.i
  %mask.i.i1628 = load i64, ptr %mask_p.i.i, align 8
  %keys.i.i1629 = load ptr, ptr %keys_p.i.i, align 8
  %64 = getelementptr i8, ptr %ctrl0.i, i64 %mask.i.i1628
  %idx_base.i.i = getelementptr i8, ptr %64, i64 17
  %h2_64.i.i = lshr i64 %m2.i15.i.i, 57
  %h2.i.i = trunc nuw nsw i64 %h2_64.i.i to i8
  %h2_ins.i.i = insertelement <16 x i8> poison, i8 %h2.i.i, i64 0
  %h2_vec.i.i = shufflevector <16 x i8> %h2_ins.i.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bp_i.i.i.i = and i64 %t136.unpack68.i, -4
  %bp.i.i.i = inttoptr i64 %bp_i.i.i.i to ptr
  %bp4.i.i.i = getelementptr inbounds nuw i8, ptr %bp.i.i.i, i64 4
  %rem.i.i.i1630 = add nsw i64 %len.i.i1623, -4
  br label %probe.i.i

probe.i.i:                                        ; preds = %next_grp.i.i, %do_probe.i.i
  %h.pn.i.i = phi i64 [ %x3.i17.i.i, %do_probe.i.i ], [ %padd.i.i1655, %next_grp.i.i ]
  %step.i.i = phi i64 [ 0, %do_probe.i.i ], [ %step_next.i.i1654, %next_grp.i.i ]
  %avail.i.i = phi i64 [ -1, %do_probe.i.i ], [ %avail_cur.i.i, %next_grp.i.i ]
  %pos.i.i1631 = and i64 %h.pn.i.i, %mask.i.i1628
  %gp.i.i1632 = getelementptr inbounds i8, ptr %ctrl0.i, i64 %pos.i.i1631
  %grp.i.i1633 = load <16 x i8>, ptr %gp.i.i1632, align 1
  %mcmp.i.i = icmp eq <16 x i8> %grp.i.i1633, %h2_vec.i.i
  %mbits.i.i = bitcast <16 x i1> %mcmp.i.i to i16
  %has_m.not.i20.i = icmp eq i16 %mbits.i.i, 0
  br i1 %has_m.not.i20.i, label %chk_empty.i.i, label %chk_key.i.preheader.i

chk_key.i.preheader.i:                            ; preds = %probe.i.i
  %mmask0.i.i = zext i16 %mbits.i.i to i32
  br label %chk_key.i.i

chk_key.i.i:                                      ; preds = %mbit_cont.i.i, %chk_key.i.preheader.i
  %mmask.i21.i = phi i32 [ %mmask_next.i.i, %mbit_cont.i.i ], [ %mmask0.i.i, %chk_key.i.preheader.i ]
  %tz.i6.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i21.i, i1 true)
  %tz64.i.i1634 = zext nneg i32 %tz.i6.i to i64
  %s_add.i.i1635 = add i64 %pos.i.i1631, %tz64.i.i1634
  %slot.i.i1636 = and i64 %s_add.i.i1635, %mask.i.i1628
  %ip.i.i1637 = getelementptr inbounds i32, ptr %idx_base.i.i, i64 %slot.i.i1636
  %didx32.i.i = load i32, ptr %ip.i.i1637, align 4
  %didx.i.i = zext i32 %didx32.i.i to i64
  %kp.i.i1638 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i1629, i64 %didx.i.i
  %cand_k.unpack.i.i = load i64, ptr %kp.i.i1638, align 8
  %cand_k.elt1.i.i = getelementptr inbounds nuw i8, ptr %kp.i.i1638, i64 8
  %cand_k.unpack2.i.i = load i64, ptr %cand_k.elt1.i.i, align 8
  %w0_eq.i.i.i = icmp eq i64 %cand_k.unpack.i.i, %t136.unpack.i
  br i1 %w0_eq.i.i.i, label %chk_len.i.i.i, label %mbit_cont.i.i

chk_len.i.i.i:                                    ; preds = %chk_key.i.i
  br i1 %short.i.i1624, label %cmp_short.i.i.i, label %cmp_long.i.i.i

cmp_short.i.i.i:                                  ; preds = %chk_len.i.i.i
  %eq_s.i.i.i = icmp eq i64 %cand_k.unpack2.i.i, %t136.unpack68.i
  br i1 %eq_s.i.i.i, label %found.i.i, label %mbit_cont.i.i

cmp_long.i.i.i:                                   ; preds = %chk_len.i.i.i
  %ap_i.i.i.i = and i64 %cand_k.unpack2.i.i, -4
  %same_ptr.i.i.i = icmp eq i64 %ap_i.i.i.i, %bp_i.i.i.i
  br i1 %same_ptr.i.i.i, label %found.i.i, label %archx_str_eq.exit.i.i

archx_str_eq.exit.i.i:                            ; preds = %cmp_long.i.i.i
  %ap.i.i.i = inttoptr i64 %ap_i.i.i.i to ptr
  %ap4.i.i.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i, i64 4
  %bcmp.i.i.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i, ptr nonnull %bp4.i.i.i, i64 %rem.i.i.i1630)
  %eq_m.i.i.i = icmp eq i32 %bcmp.i.i.i, 0
  br i1 %eq_m.i.i.i, label %found.i.i, label %mbit_cont.i.i

mbit_cont.i.i:                                    ; preds = %archx_str_eq.exit.i.i, %cmp_short.i.i.i, %chk_key.i.i
  %mm1.i.i = add nsw i32 %mmask.i21.i, -1
  %mmask_next.i.i = and i32 %mm1.i.i, %mmask.i21.i
  %has_m.not.i.i = icmp eq i32 %mmask_next.i.i, 0
  br i1 %has_m.not.i.i, label %chk_empty.i.i, label %chk_key.i.i

chk_empty.i.i:                                    ; preds = %mbit_cont.i.i, %probe.i.i
  %need_a.i.i = icmp slt i64 %avail.i.i, 0
  br i1 %need_a.i.i, label %find_a.i.i, label %after_a.i.i

find_a.i.i:                                       ; preds = %chk_empty.i.i
  %acmp.i.i = icmp slt <16 x i8> %grp.i.i1633, zeroinitializer
  %abits16.i.i = bitcast <16 x i1> %acmp.i.i to i16
  %has_a0.not.i.i = icmp eq i16 %abits16.i.i, 0
  br i1 %has_a0.not.i.i, label %after_a.i.i, label %set_a.i.i

set_a.i.i:                                        ; preds = %find_a.i.i
  %65 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i, i1 true)
  %atz64.i.i = zext nneg i16 %65 to i64
  %as_add.i.i = add i64 %pos.i.i1631, %atz64.i.i
  %aslot.i.i = and i64 %as_add.i.i, %mask.i.i1628
  br label %after_a.i.i

after_a.i.i:                                      ; preds = %set_a.i.i, %find_a.i.i, %chk_empty.i.i
  %avail_cur.i.i = phi i64 [ %avail.i.i, %chk_empty.i.i ], [ -1, %find_a.i.i ], [ %aslot.i.i, %set_a.i.i ]
  %ecmp.i.i = icmp eq <16 x i8> %grp.i.i1633, splat (i8 -128)
  %ebits.i.i = bitcast <16 x i1> %ecmp.i.i to i16
  %has_e.not.i.i = icmp eq i16 %ebits.i.i, 0
  br i1 %has_e.not.i.i, label %next_grp.i.i, label %not_found_avail.i.i

next_grp.i.i:                                     ; preds = %after_a.i.i
  %step_next.i.i1654 = add i64 %step.i.i, 16
  %padd.i.i1655 = add i64 %step_next.i.i1654, %pos.i.i1631
  br label %probe.i.i

found.i.i:                                        ; preds = %archx_str_eq.exit.i.i, %cmp_long.i.i.i, %cmp_short.i.i.i
  %f0.i.i = insertvalue { i64, i64 } poison, i64 %didx.i.i, 0
  %f1.i.i = insertvalue { i64, i64 } %f0.i.i, i64 %slot.i.i1636, 1
  br label %archx_dict_find_h_str.exit.i

not_found_avail.i.i:                              ; preds = %after_a.i.i
  %nf1.i.i = insertvalue { i64, i64 } { i64 -1, i64 poison }, i64 %avail_cur.i.i, 1
  br label %archx_dict_find_h_str.exit.i

archx_dict_find_h_str.exit.i:                     ; preds = %not_found_avail.i.i, %found.i.i, %chk_probe_existing.i
  %common.ret.op.i7.i = phi { i64, i64 } [ %f1.i.i, %found.i.i ], [ %nf1.i.i, %not_found_avail.i.i ], [ { i64 -1, i64 -1 }, %chk_probe_existing.i ]
  %found_idx.i = extractvalue { i64, i64 } %common.ret.op.i7.i, 0
  %avail_slot.i = extractvalue { i64, i64 } %common.ret.op.i7.i, 1
  %exists.i = icmp sgt i64 %found_idx.i, -1
  br i1 %exists.i, label %archx_dict_upsert_str.exit, label %chk_cap.i

chk_cap.i:                                        ; preds = %archx_dict_find_h_str.exit.i
  %used0.i = load i64, ptr %used_p.i, align 8
  %mask0.i = load i64, ptr %mask_p.i.i, align 8
  %scap0.i = add i64 %mask0.i, 1
  %u1.i = shl i64 %used0.i, 3
  %lhs.i = add i64 %u1.i, 8
  %rhs.i = mul i64 %scap0.i, 7
  %full.i = icmp sgt i64 %lhs.i, %rhs.i
  br i1 %full.i, label %probe_insert_init.i, label %fast_insert_prep.i

fast_insert_prep.i:                               ; preds = %chk_cap.i
  %keys_f.i = load ptr, ptr %keys_p.i.i, align 8
  %66 = getelementptr i8, ptr %ctrl0.i, i64 %mask0.i
  br label %iput_commit.i

probe_insert_init.i:                              ; preds = %chk_cap.i, %archx_hash_str.exit.i
  call fastcc void @archx_dict_grow(ptr nonnull %t141.i)
  %ctrl.i = load ptr, ptr %ctrl_p.i, align 8
  %mask.i = load i64, ptr %mask_p.i.i, align 8
  %keys.i = load ptr, ptr %keys_p.i.i, align 8
  %scap.i = add i64 %mask.i, 1
  %67 = getelementptr i8, ptr %ctrl.i, i64 %mask.i
  %pos22.i = and i64 %mask.i, %x3.i17.i.i
  %gp23.i = getelementptr inbounds i8, ptr %ctrl.i, i64 %pos22.i
  %grp24.i = load <16 x i8>, ptr %gp23.i, align 1
  %avail_cmp25.i = icmp slt <16 x i8> %grp24.i, zeroinitializer
  %abits26.i = bitcast <16 x i1> %avail_cmp25.i to i16
  %has_a.not27.i = icmp eq i16 %abits26.i, 0
  br i1 %has_a.not27.i, label %inext.i, label %iput.i

inext.i:                                          ; preds = %probe_insert_init.i, %inext.i
  %pos29.i = phi i64 [ %pos.i, %inext.i ], [ %pos22.i, %probe_insert_init.i ]
  %step28.i = phi i64 [ %step_next.i, %inext.i ], [ 0, %probe_insert_init.i ]
  %step_next.i = add i64 %step28.i, 16
  %padd.i = add i64 %step_next.i, %pos29.i
  %pos.i = and i64 %padd.i, %mask.i
  %gp.i = getelementptr inbounds i8, ptr %ctrl.i, i64 %pos.i
  %grp.i = load <16 x i8>, ptr %gp.i, align 1
  %avail_cmp.i = icmp slt <16 x i8> %grp.i, zeroinitializer
  %abits.i = bitcast <16 x i1> %avail_cmp.i to i16
  %has_a.not.i = icmp eq i16 %abits.i, 0
  br i1 %has_a.not.i, label %inext.i, label %iput.i

iput.i:                                           ; preds = %inext.i, %probe_insert_init.i
  %pos.lcssa.i = phi i64 [ %pos22.i, %probe_insert_init.i ], [ %pos.i, %inext.i ]
  %abits.lcssa.i = phi i16 [ %abits26.i, %probe_insert_init.i ], [ %abits.i, %inext.i ]
  %68 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits.lcssa.i, i1 true)
  %tz64.i = zext nneg i16 %68 to i64
  %s_add.i = add i64 %pos.lcssa.i, %tz64.i
  %slot_g.i = and i64 %s_add.i, %mask.i
  %u_cur.pre.i = load i64, ptr %used_p.i, align 8
  br label %iput_commit.i

iput_commit.i:                                    ; preds = %iput.i, %fast_insert_prep.i
  %u_cur.i = phi i64 [ %used0.i, %fast_insert_prep.i ], [ %u_cur.pre.i, %iput.i ]
  %slot.i = phi i64 [ %avail_slot.i, %fast_insert_prep.i ], [ %slot_g.i, %iput.i ]
  %ctrl_c.i = phi ptr [ %ctrl0.i, %fast_insert_prep.i ], [ %ctrl.i, %iput.i ]
  %scap_c.i = phi i64 [ %scap0.i, %fast_insert_prep.i ], [ %scap.i, %iput.i ]
  %.pn.i = phi ptr [ %66, %fast_insert_prep.i ], [ %67, %iput.i ]
  %keys_c.i = phi ptr [ %keys_f.i, %fast_insert_prep.i ], [ %keys.i, %iput.i ]
  %h2_c.in.i = lshr i64 %m2.i15.i.i, 57
  %h2_c.i = trunc nuw nsw i64 %h2_c.in.i to i8
  %idx_base_c.i = getelementptr i8, ptr %.pn.i, i64 17
  %sp_c.i = getelementptr inbounds i8, ptr %ctrl_c.i, i64 %slot.i
  %old_cb.i = load i8, ptr %sp_c.i, align 1
  %was_empty.i = icmp eq i8 %old_cb.i, -128
  %u_inc.i = zext i1 %was_empty.i to i64
  %u_new.i = add i64 %u_cur.i, %u_inc.i
  store i64 %u_new.i, ptr %used_p.i, align 8
  store i8 %h2_c.i, ptr %sp_c.i, align 1
  %mir.i.i = icmp ult i64 %slot.i, 16
  br i1 %mir.i.i, label %do_mir.i.i, label %archx_dict_set_ctrl.exit.i

do_mir.i.i:                                       ; preds = %iput_commit.i
  %69 = getelementptr i8, ptr %ctrl_c.i, i64 %scap_c.i
  %mp.i.i = getelementptr i8, ptr %69, i64 %slot.i
  store i8 %h2_c.i, ptr %mp.i.i, align 1
  br label %archx_dict_set_ctrl.exit.i

archx_dict_set_ctrl.exit.i:                       ; preds = %do_mir.i.i, %iput_commit.i
  %d_idx.i = load i64, ptr %t141.i, align 8
  %d_new.i = add i64 %d_idx.i, 1
  store i64 %d_new.i, ptr %t141.i, align 8
  %ip.i = getelementptr inbounds i32, ptr %idx_base_c.i, i64 %slot.i
  %d_idx32.i = trunc i64 %d_idx.i to i32
  store i32 %d_idx32.i, ptr %ip.i, align 4
  %tag.i.i1639 = and i64 %t136.unpack68.i, 3
  %owned.not.i.i1640 = icmp eq i64 %tag.i.i1639, 0
  %or.cond.i1641 = select i1 %short.i.i1624, i1 true, i1 %owned.not.i.i1640
  br i1 %or.cond.i1641, label %archx_str_clone.exit.i1651, label %dup_heap.i.i1642

dup_heap.i.i1642:                                 ; preds = %archx_dict_set_ctrl.exit.i
  %dst.i.i1643 = call noalias align 16 ptr @malloc(i64 %len.i.i1623)
  %isnull.i.i1644 = icmp eq ptr %dst.i.i1643, null
  br i1 %isnull.i.i1644, label %oom.i.i1653, label %copy.i.i1645

oom.i.i1653:                                      ; preds = %dup_heap.i.i1642
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i1645:                                     ; preds = %dup_heap.i.i1642
  %src_i.i.i1646 = and i64 %t136.unpack68.i, -4
  %src.i.i1647 = inttoptr i64 %src_i.i.i1646 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i1643, ptr nonnull align 4 %src.i.i1647, i64 %len.i.i1623, i1 false)
  %dst_i.i.i1648 = ptrtoint ptr %dst.i.i1643 to i64
  %tagged.i.i1649 = or disjoint i64 %dst_i.i.i1648, 1
  br label %archx_str_clone.exit.i1651

archx_str_clone.exit.i1651:                       ; preds = %copy.i.i1645, %archx_dict_set_ctrl.exit.i
  %stored_k.elt2.pre-phi.i = phi i64 [ %t136.unpack68.i, %archx_dict_set_ctrl.exit.i ], [ %tagged.i.i1649, %copy.i.i1645 ]
  %kp.i = getelementptr inbounds %ArchxStr, ptr %keys_c.i, i64 %d_idx.i
  store i64 %t136.unpack.i, ptr %kp.i, align 8
  %kp.repack1.i = getelementptr inbounds nuw i8, ptr %kp.i, i64 8
  store i64 %stored_k.elt2.pre-phi.i, ptr %kp.repack1.i, align 8
  br label %archx_dict_upsert_str.exit

archx_dict_upsert_str.exit:                       ; preds = %archx_dict_find_h_str.exit.i, %archx_str_clone.exit.i1651
  %found_idx.pn.i = phi i64 [ %d_idx.i, %archx_str_clone.exit.i1651 ], [ %found_idx.i, %archx_dict_find_h_str.exit.i ]
  %t143.i = load ptr, ptr %t142.i, align 8
  %t144.i = getelementptr inbounds i64, ptr %t143.i, i64 %found_idx.pn.i
  store i64 1, ptr %t144.i, align 8
  %t146.i = add nuw nsw i64 %for.i.125.0868.i, 1
  %exitcond935.not.i = icmp eq i64 %t146.i, 512
  br i1 %exitcond935.not.i, label %for.end.49.i, label %for.fast.body.44.i

for.end.49.i:                                     ; preds = %archx_dict_upsert_str.exit
  %t173.i = mul nuw nsw i64 %for.r.118.0899.i, 19
  %raw.i686.i = and i64 %rpi.pre-phi.i667.i, -4
  %hdr.i.i = inttoptr i64 %raw.i686.i to ptr
  %ctrl_p.i.i = getelementptr inbounds nuw i8, ptr %hdr.i.i, i64 32
  %is_z.i.i.i = icmp eq i64 %raw.i686.i, 0
  %mask_p.i.i.i = getelementptr inbounds nuw i8, ptr %hdr.i.i, i64 16
  %keys_p.i.i.i = getelementptr inbounds nuw i8, ptr %hdr.i.i, i64 40
  %used_p.i.i = getelementptr inbounds nuw i8, ptr %hdr.i.i, i64 8
  br label %idx.ok.56.i

for.cond.63.preheader.i:                          ; preds = %archx_str_drop.exit128.i
  %t212.i = mul nuw nsw i64 %for.r.118.0899.i, 7
  br label %idx.ok.67.i

idx.ok.56.i:                                      ; preds = %archx_str_drop.exit128.i, %for.end.49.i
  %for.step.167.0876.i = phi i64 [ 0, %for.end.49.i ], [ %t204.i, %archx_str_drop.exit128.i ]
  %t171.i = mul nuw nsw i64 %for.step.167.0876.i, 73
  %t174.i = add nuw nsw i64 %t171.i, %t173.i
  %t175.i = and i64 %t174.i, 511
  %t180.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.3.i, i64 %t175.i
  %t181.unpack.i = load i64, ptr %t180.i, align 8
  %70 = insertvalue %ArchxStr poison, i64 %t181.unpack.i, 0
  %t181.elt64.i = getelementptr inbounds nuw i8, ptr %t180.i, i64 8
  %t181.unpack65.i = load i64, ptr %t181.elt64.i, align 8
  %t18166.i = insertvalue %ArchxStr %70, i64 %t181.unpack65.i, 1
  %len.i677.i = and i64 %t181.unpack.i, 4294967295
  %long.i678.i = icmp samesign ult i64 %len.i677.i, 13
  %tag.i682.i = and i64 %t181.unpack65.i, 3
  %owned.not.i683.i = icmp eq i64 %tag.i682.i, 0
  %or.cond789.i = select i1 %long.i678.i, i1 true, i1 %owned.not.i683.i
  br i1 %or.cond789.i, label %archx_str_clone.exit.i, label %dup_heap.i.i

dup_heap.i.i:                                     ; preds = %idx.ok.56.i
  %dst.i684.i = call noalias align 16 ptr @malloc(i64 %len.i677.i)
  %isnull.i.i = icmp eq ptr %dst.i684.i, null
  br i1 %isnull.i.i, label %oom.i685.i, label %copy.i.i

oom.i685.i:                                       ; preds = %dup_heap.i.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i:                                         ; preds = %dup_heap.i.i
  %src_i.i.i = and i64 %t181.unpack65.i, -4
  %src.i.i = inttoptr i64 %src_i.i.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i684.i, ptr nonnull align 4 %src.i.i, i64 %len.i677.i, i1 false)
  %dst_i.i.i = ptrtoint ptr %dst.i684.i to i64
  %tagged.i.i = or disjoint i64 %dst_i.i.i, 1
  %out.i.i = insertvalue %ArchxStr %t18166.i, i64 %tagged.i.i, 1
  br label %archx_str_clone.exit.i

archx_str_clone.exit.i:                           ; preds = %copy.i.i, %idx.ok.56.i
  %common.ret.op.i679.i = phi %ArchxStr [ %out.i.i, %copy.i.i ], [ %t18166.i, %idx.ok.56.i ]
  %w0.i.i.i.i = extractvalue %ArchxStr %common.ret.op.i679.i, 0
  %w1.i.i.i.i = extractvalue %ArchxStr %common.ret.op.i679.i, 1
  %len.i.i.i.i = and i64 %w0.i.i.i.i, 4294967295
  %short.i.i.i.i = icmp samesign ult i64 %len.i.i.i.i, 13
  br i1 %short.i.i.i.i, label %sso_hash.i.i.i.i, label %long_hash.i.i.i.i

sso_hash.i.i.i.i:                                 ; preds = %archx_str_clone.exit.i
  %p0_raw.i.i.i.i = lshr i64 %w0.i.i.i.i, 32
  %le4.i.i.i.i = icmp samesign ult i64 %len.i.i.i.i, 5
  br i1 %le4.i.i.i.i, label %sso_le4.i.i.i.i, label %sso_gt4.i.i.i.i

sso_le4.i.i.i.i:                                  ; preds = %sso_hash.i.i.i.i
  %sh0.i.i.i.i = shl nuw nsw i64 %len.i.i.i.i, 3
  %notmask1.i.i.i.i = shl nsw i64 -1, %sh0.i.i.i.i
  %m0.i.i.i.i = xor i64 %notmask1.i.i.i.i, -1
  %p0_4.i.i.i.i = and i64 %p0_raw.i.i.i.i, %m0.i.i.i.i
  br label %sso_mix.i.i.i.i

sso_gt4.i.i.i.i:                                  ; preds = %sso_hash.i.i.i.i
  %eq12.i.i.i.i = icmp eq i64 %len.i.i.i.i, 12
  br i1 %eq12.i.i.i.i, label %sso_mix.i.i.i.i, label %sso_mid.i.i.i.i

sso_mid.i.i.i.i:                                  ; preds = %sso_gt4.i.i.i.i
  %rem.i.i.i.i = shl nuw nsw i64 %len.i.i.i.i, 3
  %sh1.i.i.i.i = add nsw i64 %rem.i.i.i.i, -32
  %notmask.i.i.i.i = shl nsw i64 -1, %sh1.i.i.i.i
  %m1.i.i.i.i = xor i64 %notmask.i.i.i.i, -1
  %p1_m.i.i.i.i = and i64 %w1.i.i.i.i, %m1.i.i.i.i
  br label %sso_mix.i.i.i.i

sso_mix.i.i.i.i:                                  ; preds = %sso_mid.i.i.i.i, %sso_gt4.i.i.i.i, %sso_le4.i.i.i.i
  %p0.i.i.i.i = phi i64 [ %p0_4.i.i.i.i, %sso_le4.i.i.i.i ], [ %p0_raw.i.i.i.i, %sso_mid.i.i.i.i ], [ %p0_raw.i.i.i.i, %sso_gt4.i.i.i.i ]
  %p1.i.i.i.i = phi i64 [ 0, %sso_le4.i.i.i.i ], [ %p1_m.i.i.i.i, %sso_mid.i.i.i.i ], [ %w1.i.i.i.i, %sso_gt4.i.i.i.i ]
  %a0.i.i.i.i = mul i64 %p0.i.i.i.i, -7046029254386353131
  %a1.i.i.i.i = mul i64 %p1.i.i.i.i, -4417276706812531889
  %ax.i.i.i.i = xor i64 %a1.i.i.i.i, %a0.i.i.i.i
  %s1.i10.i.i.i.i = lshr i64 %ax.i.i.i.i, 30
  %71 = xor i64 %len.i.i.i.i, %s1.i10.i.i.i.i
  %x1.i11.i.i.i.i = xor i64 %71, %ax.i.i.i.i
  br label %archx_hash_str.exit.i.i.i

long_hash.i.i.i.i:                                ; preds = %archx_str_clone.exit.i
  %raw.i.i.i.i = and i64 %w1.i.i.i.i, -4
  %ptr.i.i.i.i = inttoptr i64 %raw.i.i.i.i to ptr
  %seed.i.i.i.i = mul i64 %len.i.i.i.i, -7046029254386353131
  %72 = add nsw i64 %len.i.i.i.i, -8
  %73 = icmp ult i64 %72, 8
  br i1 %73, label %l_tail_cond.i.i.i.preheader.i.unr-lcssa, label %long_hash.i.i.i.i.new

long_hash.i.i.i.i.new:                            ; preds = %long_hash.i.i.i.i
  %74 = lshr i64 %72, 3
  %75 = add nuw nsw i64 %74, 1
  %unroll_iter1895 = and i64 %75, 4611686018427387902
  br label %l_body.i.i.i.i

l_tail_cond.i.i.i.preheader.i.unr-lcssa:          ; preds = %l_body.i.i.i.i, %long_hash.i.i.i.i
  %acc_next.i.i.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i.i ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx_next.i.i.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i.i ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %acc.i.i.i870.i.unr = phi i64 [ %seed.i.i.i.i, %long_hash.i.i.i.i ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx.i.i.i869.i.unr = phi i64 [ 0, %long_hash.i.i.i.i ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %76 = and i64 %72, 8
  %lcmp.mod1892.not.not = icmp eq i64 %76, 0
  br i1 %lcmp.mod1892.not.not, label %l_body.i.i.i.i.epil, label %l_tail_cond.i.i.i.preheader.i

l_body.i.i.i.i.epil:                              ; preds = %l_tail_cond.i.i.i.preheader.i.unr-lcssa
  %lp.i.i.i.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %idx.i.i.i869.i.unr
  %lane.i.i.i.i.epil = load i64, ptr %lp.i.i.i.i.epil, align 4
  %lm.i.i.i.i.epil = mul i64 %lane.i.i.i.i.epil, -4417276706812531889
  %lx.i.i.i.i.epil = xor i64 %lm.i.i.i.i.epil, %acc.i.i.i870.i.unr
  %s1.i2.i.i.i.i.epil = lshr i64 %lx.i.i.i.i.epil, 30
  %x1.i3.i.i.i.i.epil = xor i64 %s1.i2.i.i.i.i.epil, %lx.i.i.i.i.epil
  %m1.i4.i.i.i.i.epil = mul i64 %x1.i3.i.i.i.i.epil, -4658895280553007687
  %s2.i5.i.i.i.i.epil = lshr i64 %m1.i4.i.i.i.i.epil, 27
  %x2.i6.i.i.i.i.epil = xor i64 %s2.i5.i.i.i.i.epil, %m1.i4.i.i.i.i.epil
  %m2.i7.i.i.i.i.epil = mul i64 %x2.i6.i.i.i.i.epil, -7723592293110705685
  %s3.i8.i.i.i.i.epil = lshr i64 %m2.i7.i.i.i.i.epil, 31
  %x3.i9.i.i.i.i.epil = xor i64 %s3.i8.i.i.i.i.epil, %m2.i7.i.i.i.i.epil
  %acc_next.i.i.i.i.epil = add i64 %x3.i9.i.i.i.i.epil, %idx.i.i.i869.i.unr
  %idx_next.i.i.i.i.epil = add nuw nsw i64 %idx.i.i.i869.i.unr, 8
  br label %l_tail_cond.i.i.i.preheader.i

l_tail_cond.i.i.i.preheader.i:                    ; preds = %l_tail_cond.i.i.i.preheader.i.unr-lcssa, %l_body.i.i.i.i.epil
  %acc_next.i.i.i.i.lcssa = phi i64 [ %acc_next.i.i.i.i.lcssa.ph, %l_tail_cond.i.i.i.preheader.i.unr-lcssa ], [ %acc_next.i.i.i.i.epil, %l_body.i.i.i.i.epil ]
  %idx_next.i.i.i.i.lcssa = phi i64 [ %idx_next.i.i.i.i.lcssa.ph, %l_tail_cond.i.i.i.preheader.i.unr-lcssa ], [ %idx_next.i.i.i.i.epil, %l_body.i.i.i.i.epil ]
  %tmore.i.i.i871.i = icmp samesign ult i64 %idx_next.i.i.i.i.lcssa, %len.i.i.i.i
  br i1 %tmore.i.i.i871.i, label %l_tail_body.i.i.i.i.preheader, label %l_done.i.i.i.i

l_tail_body.i.i.i.i.preheader:                    ; preds = %l_tail_cond.i.i.i.preheader.i
  %77 = sub i64 %w0.i.i.i.i, %idx_next.i.i.i.i.lcssa
  %xtraiter1897 = and i64 %77, 3
  %lcmp.mod1898.not = icmp eq i64 %xtraiter1897, 0
  br i1 %lcmp.mod1898.not, label %l_tail_body.i.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.i.prol

l_tail_body.i.i.i.i.prol:                         ; preds = %l_tail_body.i.i.i.i.preheader, %l_tail_body.i.i.i.i.prol
  %tacc.i.i.i873.i.prol = phi i64 [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ], [ %acc_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ]
  %ti.i.i.i872.i.prol = phi i64 [ %ti_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ], [ %idx_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ]
  %prol.iter1899 = phi i64 [ %prol.iter1899.next, %l_tail_body.i.i.i.i.prol ], [ 0, %l_tail_body.i.i.i.i.preheader ]
  %tp.i.i.i.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %ti.i.i.i872.i.prol
  %tb.i.i.i.i.prol = load i8, ptr %tp.i.i.i.i.prol, align 1
  %tz.i.i.i.i.prol = zext i8 %tb.i.i.i.i.prol to i64
  %tx.i.i.i.i.prol = xor i64 %tacc.i.i.i873.i.prol, %tz.i.i.i.i.prol
  %tacc_next.i.i.i.i.prol = mul i64 %tx.i.i.i.i.prol, 1099511628211
  %ti_next.i.i.i.i.prol = add nuw nsw i64 %ti.i.i.i872.i.prol, 1
  %prol.iter1899.next = add i64 %prol.iter1899, 1
  %prol.iter1899.cmp.not = icmp eq i64 %prol.iter1899.next, %xtraiter1897
  br i1 %prol.iter1899.cmp.not, label %l_tail_body.i.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.i.prol, !llvm.loop !9

l_tail_body.i.i.i.i.prol.loopexit:                ; preds = %l_tail_body.i.i.i.i.prol, %l_tail_body.i.i.i.i.preheader
  %tacc.i.i.i873.i.unr = phi i64 [ %acc_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ], [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %ti.i.i.i872.i.unr = phi i64 [ %idx_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ], [ %ti_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %tacc_next.i.i.i.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.i.i.preheader ], [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %78 = sub i64 %idx_next.i.i.i.i.lcssa, %len.i.i.i.i
  %79 = icmp ugt i64 %78, -4
  br i1 %79, label %l_done.i.i.i.i, label %l_tail_body.i.i.i.i.preheader.new

l_tail_body.i.i.i.i.preheader.new:                ; preds = %l_tail_body.i.i.i.i.prol.loopexit
  %invariant.gep1923 = getelementptr i8, ptr %ptr.i.i.i.i, i64 1
  %invariant.gep1925 = getelementptr i8, ptr %ptr.i.i.i.i, i64 2
  %invariant.gep1927 = getelementptr i8, ptr %ptr.i.i.i.i, i64 3
  br label %l_tail_body.i.i.i.i

l_body.i.i.i.i:                                   ; preds = %l_body.i.i.i.i, %long_hash.i.i.i.i.new
  %acc.i.i.i870.i = phi i64 [ %seed.i.i.i.i, %long_hash.i.i.i.i.new ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx.i.i.i869.i = phi i64 [ 0, %long_hash.i.i.i.i.new ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %niter1896 = phi i64 [ 0, %long_hash.i.i.i.i.new ], [ %niter1896.next.1, %l_body.i.i.i.i ]
  %lp.i.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %idx.i.i.i869.i
  %lane.i.i.i.i = load i64, ptr %lp.i.i.i.i, align 4
  %lm.i.i.i.i = mul i64 %lane.i.i.i.i, -4417276706812531889
  %lx.i.i.i.i = xor i64 %lm.i.i.i.i, %acc.i.i.i870.i
  %s1.i2.i.i.i.i = lshr i64 %lx.i.i.i.i, 30
  %x1.i3.i.i.i.i = xor i64 %s1.i2.i.i.i.i, %lx.i.i.i.i
  %m1.i4.i.i.i.i = mul i64 %x1.i3.i.i.i.i, -4658895280553007687
  %s2.i5.i.i.i.i = lshr i64 %m1.i4.i.i.i.i, 27
  %x2.i6.i.i.i.i = xor i64 %s2.i5.i.i.i.i, %m1.i4.i.i.i.i
  %m2.i7.i.i.i.i = mul i64 %x2.i6.i.i.i.i, -7723592293110705685
  %s3.i8.i.i.i.i = lshr i64 %m2.i7.i.i.i.i, 31
  %x3.i9.i.i.i.i = xor i64 %s3.i8.i.i.i.i, %m2.i7.i.i.i.i
  %acc_next.i.i.i.i = add i64 %x3.i9.i.i.i.i, %idx.i.i.i869.i
  %idx_next.i.i.i.i = or disjoint i64 %idx.i.i.i869.i, 8
  %lp.i.i.i.i.1 = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %idx_next.i.i.i.i
  %lane.i.i.i.i.1 = load i64, ptr %lp.i.i.i.i.1, align 4
  %lm.i.i.i.i.1 = mul i64 %lane.i.i.i.i.1, -4417276706812531889
  %lx.i.i.i.i.1 = xor i64 %lm.i.i.i.i.1, %acc_next.i.i.i.i
  %s1.i2.i.i.i.i.1 = lshr i64 %lx.i.i.i.i.1, 30
  %x1.i3.i.i.i.i.1 = xor i64 %s1.i2.i.i.i.i.1, %lx.i.i.i.i.1
  %m1.i4.i.i.i.i.1 = mul i64 %x1.i3.i.i.i.i.1, -4658895280553007687
  %s2.i5.i.i.i.i.1 = lshr i64 %m1.i4.i.i.i.i.1, 27
  %x2.i6.i.i.i.i.1 = xor i64 %s2.i5.i.i.i.i.1, %m1.i4.i.i.i.i.1
  %m2.i7.i.i.i.i.1 = mul i64 %x2.i6.i.i.i.i.1, -7723592293110705685
  %s3.i8.i.i.i.i.1 = lshr i64 %m2.i7.i.i.i.i.1, 31
  %x3.i9.i.i.i.i.1 = xor i64 %s3.i8.i.i.i.i.1, %m2.i7.i.i.i.i.1
  %acc_next.i.i.i.i.1 = add i64 %x3.i9.i.i.i.i.1, %idx_next.i.i.i.i
  %idx_next.i.i.i.i.1 = add nuw nsw i64 %idx.i.i.i869.i, 16
  %niter1896.next.1 = add i64 %niter1896, 2
  %niter1896.ncmp.1.not = icmp eq i64 %niter1896.next.1, %unroll_iter1895
  br i1 %niter1896.ncmp.1.not, label %l_tail_cond.i.i.i.preheader.i.unr-lcssa, label %l_body.i.i.i.i

l_tail_body.i.i.i.i:                              ; preds = %l_tail_body.i.i.i.i, %l_tail_body.i.i.i.i.preheader.new
  %tacc.i.i.i873.i = phi i64 [ %tacc.i.i.i873.i.unr, %l_tail_body.i.i.i.i.preheader.new ], [ %tacc_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %ti.i.i.i872.i = phi i64 [ %ti.i.i.i872.i.unr, %l_tail_body.i.i.i.i.preheader.new ], [ %ti_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %tp.i.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %ti.i.i.i872.i
  %tb.i.i.i.i = load i8, ptr %tp.i.i.i.i, align 1
  %tz.i.i.i.i = zext i8 %tb.i.i.i.i to i64
  %tx.i.i.i.i = xor i64 %tacc.i.i.i873.i, %tz.i.i.i.i
  %tacc_next.i.i.i.i = mul i64 %tx.i.i.i.i, 1099511628211
  %gep1924 = getelementptr i8, ptr %invariant.gep1923, i64 %ti.i.i.i872.i
  %tb.i.i.i.i.1 = load i8, ptr %gep1924, align 1
  %tz.i.i.i.i.1 = zext i8 %tb.i.i.i.i.1 to i64
  %tx.i.i.i.i.1 = xor i64 %tacc_next.i.i.i.i, %tz.i.i.i.i.1
  %tacc_next.i.i.i.i.1 = mul i64 %tx.i.i.i.i.1, 1099511628211
  %gep1926 = getelementptr i8, ptr %invariant.gep1925, i64 %ti.i.i.i872.i
  %tb.i.i.i.i.2 = load i8, ptr %gep1926, align 1
  %tz.i.i.i.i.2 = zext i8 %tb.i.i.i.i.2 to i64
  %tx.i.i.i.i.2 = xor i64 %tacc_next.i.i.i.i.1, %tz.i.i.i.i.2
  %tacc_next.i.i.i.i.2 = mul i64 %tx.i.i.i.i.2, 1099511628211
  %gep1928 = getelementptr i8, ptr %invariant.gep1927, i64 %ti.i.i.i872.i
  %tb.i.i.i.i.3 = load i8, ptr %gep1928, align 1
  %tz.i.i.i.i.3 = zext i8 %tb.i.i.i.i.3 to i64
  %tx.i.i.i.i.3 = xor i64 %tacc_next.i.i.i.i.2, %tz.i.i.i.i.3
  %tacc_next.i.i.i.i.3 = mul i64 %tx.i.i.i.i.3, 1099511628211
  %ti_next.i.i.i.i.3 = add nuw nsw i64 %ti.i.i.i872.i, 4
  %tmore.i.i.i.i.3 = icmp samesign ult i64 %ti_next.i.i.i.i.3, %len.i.i.i.i
  br i1 %tmore.i.i.i.i.3, label %l_tail_body.i.i.i.i, label %l_done.i.i.i.i

l_done.i.i.i.i:                                   ; preds = %l_tail_body.i.i.i.i.prol.loopexit, %l_tail_body.i.i.i.i, %l_tail_cond.i.i.i.preheader.i
  %tacc.i.i.i.lcssa.i = phi i64 [ %acc_next.i.i.i.i.lcssa, %l_tail_cond.i.i.i.preheader.i ], [ %tacc_next.i.i.i.i.lcssa.unr, %l_tail_body.i.i.i.i.prol.loopexit ], [ %tacc_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %s1.i.i.i.i.i = lshr i64 %tacc.i.i.i.lcssa.i, 30
  %x1.i.i.i.i.i = xor i64 %s1.i.i.i.i.i, %tacc.i.i.i.lcssa.i
  br label %archx_hash_str.exit.i.i.i

archx_hash_str.exit.i.i.i:                        ; preds = %l_done.i.i.i.i, %sso_mix.i.i.i.i
  %x1.i.i.i.i.sink.i = phi i64 [ %x1.i.i.i.i.i, %l_done.i.i.i.i ], [ %x1.i11.i.i.i.i, %sso_mix.i.i.i.i ]
  %m1.i.i.i.i.i = mul i64 %x1.i.i.i.i.sink.i, -4658895280553007687
  %s2.i.i.i.i.i = lshr i64 %m1.i.i.i.i.i, 27
  %x2.i.i.i.i.i = xor i64 %s2.i.i.i.i.i, %m1.i.i.i.i.i
  %m2.i.i.i.i.i = mul i64 %x2.i.i.i.i.i, -7723592293110705685
  %s3.i.i.i.i.i = lshr i64 %m2.i.i.i.i.i, 31
  %x3.i.i.i.i.i = xor i64 %s3.i.i.i.i.i, %m2.i.i.i.i.i
  br i1 %is_z.i.i, label %dupd.miss.59.i, label %chk_ctrl.i.i.i.i

chk_ctrl.i.i.i.i:                                 ; preds = %archx_hash_str.exit.i.i.i
  %ctrl.i.i.i.i = load ptr, ptr %ctrl_p.i, align 8
  %c_null.i.i.i.i = icmp eq ptr %ctrl.i.i.i.i, null
  br i1 %c_null.i.i.i.i, label %dupd.miss.59.i, label %do_probe.i.i.i.i

do_probe.i.i.i.i:                                 ; preds = %chk_ctrl.i.i.i.i
  %mask.i.i.i.i = load i64, ptr %mask_p.i.i, align 8
  %keys.i.i.i.i = load ptr, ptr %keys_p.i.i, align 8
  %80 = getelementptr i8, ptr %ctrl.i.i.i.i, i64 %mask.i.i.i.i
  %idx_base.i.i.i.i = getelementptr i8, ptr %80, i64 17
  %h2_64.i.i.i.i = lshr i64 %m2.i.i.i.i.i, 57
  %h2.i.i.i.i = trunc nuw nsw i64 %h2_64.i.i.i.i to i8
  %h2_ins.i.i.i.i = insertelement <16 x i8> poison, i8 %h2.i.i.i.i, i64 0
  %h2_vec.i.i.i.i = shufflevector <16 x i8> %h2_ins.i.i.i.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bp_i.i.i.i.i.i = and i64 %w1.i.i.i.i, -4
  %bp.i.i.i.i.i = inttoptr i64 %bp_i.i.i.i.i.i to ptr
  %bp4.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %bp.i.i.i.i.i, i64 4
  %rem.i.i.i.i.i = add nsw i64 %len.i.i.i.i, -4
  br label %probe.i.i.i.i

probe.i.i.i.i:                                    ; preds = %next_grp.i.i.i.i, %do_probe.i.i.i.i
  %h.pn.i.i.i.i = phi i64 [ %x3.i.i.i.i.i, %do_probe.i.i.i.i ], [ %padd.i.i.i.i, %next_grp.i.i.i.i ]
  %step.i.i.i.i = phi i64 [ 0, %do_probe.i.i.i.i ], [ %step_next.i.i.i.i, %next_grp.i.i.i.i ]
  %avail.i.i.i.i = phi i64 [ -1, %do_probe.i.i.i.i ], [ %avail_cur.i.i.i.i, %next_grp.i.i.i.i ]
  %pos.i.i.i.i = and i64 %h.pn.i.i.i.i, %mask.i.i.i.i
  %gp.i.i.i.i = getelementptr inbounds i8, ptr %ctrl.i.i.i.i, i64 %pos.i.i.i.i
  %grp.i.i.i.i = load <16 x i8>, ptr %gp.i.i.i.i, align 1
  %mcmp.i.i.i.i = icmp eq <16 x i8> %grp.i.i.i.i, %h2_vec.i.i.i.i
  %mbits.i.i.i.i = bitcast <16 x i1> %mcmp.i.i.i.i to i16
  %has_m.not.i.i.i874.i = icmp eq i16 %mbits.i.i.i.i, 0
  br i1 %has_m.not.i.i.i874.i, label %chk_empty.i.i.i.i, label %chk_key.i.i.i.preheader.i

chk_key.i.i.i.preheader.i:                        ; preds = %probe.i.i.i.i
  %mmask0.i.i.i.i = zext i16 %mbits.i.i.i.i to i32
  br label %chk_key.i.i.i.i

chk_key.i.i.i.i:                                  ; preds = %mbit_cont.i.i.i.i, %chk_key.i.i.i.preheader.i
  %mmask.i.i.i875.i = phi i32 [ %mmask_next.i.i.i.i, %mbit_cont.i.i.i.i ], [ %mmask0.i.i.i.i, %chk_key.i.i.i.preheader.i ]
  %tz.i2.i.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i875.i, i1 true)
  %tz64.i.i.i.i = zext nneg i32 %tz.i2.i.i.i to i64
  %s_add.i.i.i.i = add i64 %pos.i.i.i.i, %tz64.i.i.i.i
  %slot.i.i.i.i = and i64 %s_add.i.i.i.i, %mask.i.i.i.i
  %ip.i.i.i.i = getelementptr inbounds i32, ptr %idx_base.i.i.i.i, i64 %slot.i.i.i.i
  %didx32.i.i.i.i = load i32, ptr %ip.i.i.i.i, align 4
  %didx.i.i.i.i = zext i32 %didx32.i.i.i.i to i64
  %kp.i.i.i.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i.i, i64 %didx.i.i.i.i
  %cand_k.unpack.i.i.i.i = load i64, ptr %kp.i.i.i.i, align 8
  %cand_k.elt1.i.i.i.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i.i, i64 8
  %cand_k.unpack2.i.i.i.i = load i64, ptr %cand_k.elt1.i.i.i.i, align 8
  %w0_eq.i.i.i.i.i = icmp eq i64 %cand_k.unpack.i.i.i.i, %w0.i.i.i.i
  br i1 %w0_eq.i.i.i.i.i, label %chk_len.i.i.i.i.i, label %mbit_cont.i.i.i.i

chk_len.i.i.i.i.i:                                ; preds = %chk_key.i.i.i.i
  br i1 %short.i.i.i.i, label %cmp_short.i.i.i.i.i, label %cmp_long.i.i.i.i.i

cmp_short.i.i.i.i.i:                              ; preds = %chk_len.i.i.i.i.i
  %eq_s.i.i.i.i.i = icmp eq i64 %cand_k.unpack2.i.i.i.i, %w1.i.i.i.i
  br i1 %eq_s.i.i.i.i.i, label %dupd.ok.58.i, label %mbit_cont.i.i.i.i

cmp_long.i.i.i.i.i:                               ; preds = %chk_len.i.i.i.i.i
  %ap_i.i.i.i.i.i = and i64 %cand_k.unpack2.i.i.i.i, -4
  %same_ptr.i.i.i.i.i = icmp eq i64 %ap_i.i.i.i.i.i, %bp_i.i.i.i.i.i
  br i1 %same_ptr.i.i.i.i.i, label %dupd.ok.58.i, label %archx_str_eq.exit.i.i.i.i

archx_str_eq.exit.i.i.i.i:                        ; preds = %cmp_long.i.i.i.i.i
  %ap.i.i.i.i.i = inttoptr i64 %ap_i.i.i.i.i.i to ptr
  %ap4.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i.i, i64 4
  %bcmp.i.i.i.i.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i.i.i, ptr nonnull %bp4.i.i.i.i.i, i64 %rem.i.i.i.i.i)
  %eq_m.i.i.i.i.i = icmp eq i32 %bcmp.i.i.i.i.i, 0
  br i1 %eq_m.i.i.i.i.i, label %dupd.ok.58.i, label %mbit_cont.i.i.i.i

mbit_cont.i.i.i.i:                                ; preds = %archx_str_eq.exit.i.i.i.i, %cmp_short.i.i.i.i.i, %chk_key.i.i.i.i
  %mm1.i.i.i.i = add nsw i32 %mmask.i.i.i875.i, -1
  %mmask_next.i.i.i.i = and i32 %mm1.i.i.i.i, %mmask.i.i.i875.i
  %has_m.not.i.i.i.i = icmp eq i32 %mmask_next.i.i.i.i, 0
  br i1 %has_m.not.i.i.i.i, label %chk_empty.i.i.i.i, label %chk_key.i.i.i.i

chk_empty.i.i.i.i:                                ; preds = %mbit_cont.i.i.i.i, %probe.i.i.i.i
  %need_a.i.i.i.i = icmp slt i64 %avail.i.i.i.i, 0
  br i1 %need_a.i.i.i.i, label %find_a.i.i.i.i, label %after_a.i.i.i.i

find_a.i.i.i.i:                                   ; preds = %chk_empty.i.i.i.i
  %acmp.i.i.i.i = icmp slt <16 x i8> %grp.i.i.i.i, zeroinitializer
  %abits16.i.i.i.i = bitcast <16 x i1> %acmp.i.i.i.i to i16
  %has_a0.not.i.i.i.i = icmp eq i16 %abits16.i.i.i.i, 0
  br i1 %has_a0.not.i.i.i.i, label %after_a.i.i.i.i, label %set_a.i.i.i.i

set_a.i.i.i.i:                                    ; preds = %find_a.i.i.i.i
  %81 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i.i, i1 true)
  %atz64.i.i.i.i = zext nneg i16 %81 to i64
  %as_add.i.i.i.i = add i64 %pos.i.i.i.i, %atz64.i.i.i.i
  %aslot.i.i.i.i = and i64 %as_add.i.i.i.i, %mask.i.i.i.i
  br label %after_a.i.i.i.i

after_a.i.i.i.i:                                  ; preds = %set_a.i.i.i.i, %find_a.i.i.i.i, %chk_empty.i.i.i.i
  %avail_cur.i.i.i.i = phi i64 [ %avail.i.i.i.i, %chk_empty.i.i.i.i ], [ -1, %find_a.i.i.i.i ], [ %aslot.i.i.i.i, %set_a.i.i.i.i ]
  %ecmp.i.i.i.i = icmp eq <16 x i8> %grp.i.i.i.i, splat (i8 -128)
  %ebits.i.i.i.i = bitcast <16 x i1> %ecmp.i.i.i.i to i16
  %has_e.not.i.i.i.i = icmp eq i16 %ebits.i.i.i.i, 0
  br i1 %has_e.not.i.i.i.i, label %next_grp.i.i.i.i, label %dupd.miss.59.i

next_grp.i.i.i.i:                                 ; preds = %after_a.i.i.i.i
  %step_next.i.i.i.i = add i64 %step.i.i.i.i, 16
  %padd.i.i.i.i = add i64 %step_next.i.i.i.i, %pos.i.i.i.i
  br label %probe.i.i.i.i

dupd.miss.59.i:                                   ; preds = %chk_ctrl.i.i.i.i, %archx_hash_str.exit.i.i.i, %after_a.i.i.i.i
  call fastcc void @archx_key_fail()
  unreachable

dupd.ok.58.i:                                     ; preds = %archx_str_eq.exit.i.i.i.i, %cmp_long.i.i.i.i.i, %cmp_short.i.i.i.i.i
  %t191.i = load ptr, ptr %t142.i, align 8
  %t192.i = getelementptr inbounds nuw i64, ptr %t191.i, i64 %didx.i.i.i.i
  %t193.i = load i64, ptr %t192.i, align 8
  %t195.i = urem i64 %for.step.167.0876.i, 5
  %t196.i = add nuw nsw i64 %t195.i, 1
  %t197.i = add i64 %t196.i, %t193.i
  store i64 %t197.i, ptr %t192.i, align 8
  %t199.i = icmp samesign ult i64 %for.step.167.0876.i, 64
  br i1 %t199.i, label %if.then.60.i, label %if.merge.62.i

if.then.60.i:                                     ; preds = %dupd.ok.58.i
  %m1.i.i.i = mul i64 %t175.i, -4658895280553007687
  %s2.i.i.i = lshr i64 %m1.i.i.i, 27
  %x2.i.i.i = xor i64 %s2.i.i.i, %m1.i.i.i
  %m2.i.i.i = mul i64 %x2.i.i.i, -7723592293110705685
  %s3.i.i.i = lshr i64 %m2.i.i.i, 31
  %x3.i.i.i = xor i64 %s3.i.i.i, %m2.i.i.i
  %ctrl0.i.i = load ptr, ptr %ctrl_p.i.i, align 8
  %uninit.i.i = icmp eq ptr %ctrl0.i.i, null
  br i1 %uninit.i.i, label %probe_insert_init.i.i, label %chk_probe_existing.i.i

chk_probe_existing.i.i:                           ; preds = %if.then.60.i
  br i1 %is_z.i.i.i, label %archx_dict_find_h_i64.exit.i.i, label %do_probe.i.i.i

do_probe.i.i.i:                                   ; preds = %chk_probe_existing.i.i
  %mask.i.i.i = load i64, ptr %mask_p.i.i.i, align 8
  %keys.i.i.i = load ptr, ptr %keys_p.i.i.i, align 8
  %82 = getelementptr i8, ptr %ctrl0.i.i, i64 %mask.i.i.i
  %idx_base.i.i.i = getelementptr i8, ptr %82, i64 17
  %h2_64.i.i.i = lshr i64 %m2.i.i.i, 57
  %h2.i.i.i = trunc nuw nsw i64 %h2_64.i.i.i to i8
  %h2_ins.i.i.i = insertelement <16 x i8> poison, i8 %h2.i.i.i, i64 0
  %h2_vec.i.i.i = shufflevector <16 x i8> %h2_ins.i.i.i, <16 x i8> poison, <16 x i32> zeroinitializer
  br label %probe.i.i.i

probe.i.i.i:                                      ; preds = %next_grp.i.i.i, %do_probe.i.i.i
  %h.pn.i.i.i = phi i64 [ %x3.i.i.i, %do_probe.i.i.i ], [ %padd.i.i.i, %next_grp.i.i.i ]
  %step.i.i.i = phi i64 [ 0, %do_probe.i.i.i ], [ %step_next.i.i.i, %next_grp.i.i.i ]
  %avail.i.i.i = phi i64 [ -1, %do_probe.i.i.i ], [ %avail_cur.i.i.i, %next_grp.i.i.i ]
  %pos.i.i.i = and i64 %h.pn.i.i.i, %mask.i.i.i
  %gp.i.i.i = getelementptr inbounds i8, ptr %ctrl0.i.i, i64 %pos.i.i.i
  %grp.i.i.i = load <16 x i8>, ptr %gp.i.i.i, align 1
  %mcmp.i.i.i = icmp eq <16 x i8> %grp.i.i.i, %h2_vec.i.i.i
  %mbits.i.i.i = bitcast <16 x i1> %mcmp.i.i.i to i16
  %has_m.not.i3.i.i = icmp eq i16 %mbits.i.i.i, 0
  br i1 %has_m.not.i3.i.i, label %chk_empty.i.i.i, label %chk_key.i.preheader.i.i

chk_key.i.preheader.i.i:                          ; preds = %probe.i.i.i
  %mmask0.i.i.i = zext i16 %mbits.i.i.i to i32
  br label %chk_key.i.i.i

chk_key.i.i.i:                                    ; preds = %mbit_cont.i.i.i, %chk_key.i.preheader.i.i
  %mmask.i4.i.i = phi i32 [ %mmask_next.i.i.i, %mbit_cont.i.i.i ], [ %mmask0.i.i.i, %chk_key.i.preheader.i.i ]
  %tz.i.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i4.i.i, i1 true)
  %tz64.i.i.i = zext nneg i32 %tz.i.i.i to i64
  %s_add.i.i.i = add i64 %pos.i.i.i, %tz64.i.i.i
  %slot.i.i.i = and i64 %s_add.i.i.i, %mask.i.i.i
  %ip.i.i.i = getelementptr inbounds i32, ptr %idx_base.i.i.i, i64 %slot.i.i.i
  %didx32.i.i.i = load i32, ptr %ip.i.i.i, align 4
  %didx.i.i.i = zext i32 %didx32.i.i.i to i64
  %kp.i.i.i = getelementptr inbounds nuw i64, ptr %keys.i.i.i, i64 %didx.i.i.i
  %cand_k.i.i.i = load i64, ptr %kp.i.i.i, align 8
  %eq.i.i.i = icmp eq i64 %cand_k.i.i.i, %t175.i
  br i1 %eq.i.i.i, label %found.i.i.i, label %mbit_cont.i.i.i

mbit_cont.i.i.i:                                  ; preds = %chk_key.i.i.i
  %mm1.i.i.i = add nsw i32 %mmask.i4.i.i, -1
  %mmask_next.i.i.i = and i32 %mm1.i.i.i, %mmask.i4.i.i
  %has_m.not.i.i.i = icmp eq i32 %mmask_next.i.i.i, 0
  br i1 %has_m.not.i.i.i, label %chk_empty.i.i.i, label %chk_key.i.i.i

chk_empty.i.i.i:                                  ; preds = %mbit_cont.i.i.i, %probe.i.i.i
  %need_a.i.i.i = icmp slt i64 %avail.i.i.i, 0
  br i1 %need_a.i.i.i, label %find_a.i.i.i, label %after_a.i.i.i

find_a.i.i.i:                                     ; preds = %chk_empty.i.i.i
  %acmp.i.i.i = icmp slt <16 x i8> %grp.i.i.i, zeroinitializer
  %abits16.i.i.i = bitcast <16 x i1> %acmp.i.i.i to i16
  %has_a0.not.i.i.i = icmp eq i16 %abits16.i.i.i, 0
  br i1 %has_a0.not.i.i.i, label %after_a.i.i.i, label %set_a.i.i.i

set_a.i.i.i:                                      ; preds = %find_a.i.i.i
  %83 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i, i1 true)
  %atz64.i.i.i = zext nneg i16 %83 to i64
  %as_add.i.i.i = add i64 %pos.i.i.i, %atz64.i.i.i
  %aslot.i.i.i = and i64 %as_add.i.i.i, %mask.i.i.i
  br label %after_a.i.i.i

after_a.i.i.i:                                    ; preds = %set_a.i.i.i, %find_a.i.i.i, %chk_empty.i.i.i
  %avail_cur.i.i.i = phi i64 [ %avail.i.i.i, %chk_empty.i.i.i ], [ -1, %find_a.i.i.i ], [ %aslot.i.i.i, %set_a.i.i.i ]
  %ecmp.i.i.i = icmp eq <16 x i8> %grp.i.i.i, splat (i8 -128)
  %ebits.i.i.i = bitcast <16 x i1> %ecmp.i.i.i to i16
  %has_e.not.i.i.i = icmp eq i16 %ebits.i.i.i, 0
  br i1 %has_e.not.i.i.i, label %next_grp.i.i.i, label %not_found_avail.i.i.i

next_grp.i.i.i:                                   ; preds = %after_a.i.i.i
  %step_next.i.i.i = add i64 %step.i.i.i, 16
  %padd.i.i.i = add i64 %step_next.i.i.i, %pos.i.i.i
  br label %probe.i.i.i

found.i.i.i:                                      ; preds = %chk_key.i.i.i
  %f0.i.i.i = insertvalue { i64, i64 } poison, i64 %didx.i.i.i, 0
  %f1.i.i.i = insertvalue { i64, i64 } %f0.i.i.i, i64 %slot.i.i.i, 1
  br label %archx_dict_find_h_i64.exit.i.i

not_found_avail.i.i.i:                            ; preds = %after_a.i.i.i
  %nf1.i.i.i = insertvalue { i64, i64 } { i64 -1, i64 poison }, i64 %avail_cur.i.i.i, 1
  br label %archx_dict_find_h_i64.exit.i.i

archx_dict_find_h_i64.exit.i.i:                   ; preds = %not_found_avail.i.i.i, %found.i.i.i, %chk_probe_existing.i.i
  %common.ret.op.i.i687.i = phi { i64, i64 } [ %f1.i.i.i, %found.i.i.i ], [ %nf1.i.i.i, %not_found_avail.i.i.i ], [ { i64 -1, i64 -1 }, %chk_probe_existing.i.i ]
  %found_idx.i.i = extractvalue { i64, i64 } %common.ret.op.i.i687.i, 0
  %avail_slot.i.i = extractvalue { i64, i64 } %common.ret.op.i.i687.i, 1
  %exists.i.i = icmp sgt i64 %found_idx.i.i, -1
  br i1 %exists.i.i, label %if.merge.62.i, label %chk_cap.i.i

chk_cap.i.i:                                      ; preds = %archx_dict_find_h_i64.exit.i.i
  %used0.i.i = load i64, ptr %used_p.i.i, align 8
  %mask0.i.i = load i64, ptr %mask_p.i.i.i, align 8
  %scap0.i.i = add i64 %mask0.i.i, 1
  %u1.i.i = shl i64 %used0.i.i, 3
  %lhs.i.i = add i64 %u1.i.i, 8
  %rhs.i.i = mul i64 %scap0.i.i, 7
  %full.i.i = icmp sgt i64 %lhs.i.i, %rhs.i.i
  br i1 %full.i.i, label %probe_insert_init.i.i, label %fast_insert_prep.i.i

fast_insert_prep.i.i:                             ; preds = %chk_cap.i.i
  %keys_f.i.i = load ptr, ptr %keys_p.i.i.i, align 8
  %84 = getelementptr i8, ptr %ctrl0.i.i, i64 %mask0.i.i
  br label %iput_commit.i.i

probe_insert_init.i.i:                            ; preds = %chk_cap.i.i, %if.then.60.i
  call fastcc void @archx_dict_grow(ptr nonnull %hdr.i.i)
  %ctrl.i.i = load ptr, ptr %ctrl_p.i.i, align 8
  %mask.i.i = load i64, ptr %mask_p.i.i.i, align 8
  %keys.i.i = load ptr, ptr %keys_p.i.i.i, align 8
  %scap.i.i = add i64 %mask.i.i, 1
  %85 = getelementptr i8, ptr %ctrl.i.i, i64 %mask.i.i
  %pos5.i.i = and i64 %mask.i.i, %x3.i.i.i
  %gp6.i.i = getelementptr inbounds i8, ptr %ctrl.i.i, i64 %pos5.i.i
  %grp7.i.i = load <16 x i8>, ptr %gp6.i.i, align 1
  %avail_cmp8.i.i = icmp slt <16 x i8> %grp7.i.i, zeroinitializer
  %abits9.i.i = bitcast <16 x i1> %avail_cmp8.i.i to i16
  %has_a.not10.i.i = icmp eq i16 %abits9.i.i, 0
  br i1 %has_a.not10.i.i, label %inext.i689.i, label %iput.i.i

inext.i689.i:                                     ; preds = %probe_insert_init.i.i, %inext.i689.i
  %pos12.i.i = phi i64 [ %pos.i.i, %inext.i689.i ], [ %pos5.i.i, %probe_insert_init.i.i ]
  %step11.i.i = phi i64 [ %step_next.i.i, %inext.i689.i ], [ 0, %probe_insert_init.i.i ]
  %step_next.i.i = add i64 %step11.i.i, 16
  %padd.i.i = add i64 %step_next.i.i, %pos12.i.i
  %pos.i.i = and i64 %padd.i.i, %mask.i.i
  %gp.i.i = getelementptr inbounds i8, ptr %ctrl.i.i, i64 %pos.i.i
  %grp.i.i = load <16 x i8>, ptr %gp.i.i, align 1
  %avail_cmp.i.i = icmp slt <16 x i8> %grp.i.i, zeroinitializer
  %abits.i.i = bitcast <16 x i1> %avail_cmp.i.i to i16
  %has_a.not.i.i = icmp eq i16 %abits.i.i, 0
  br i1 %has_a.not.i.i, label %inext.i689.i, label %iput.i.i

iput.i.i:                                         ; preds = %inext.i689.i, %probe_insert_init.i.i
  %pos.lcssa.i.i = phi i64 [ %pos5.i.i, %probe_insert_init.i.i ], [ %pos.i.i, %inext.i689.i ]
  %abits.lcssa.i.i = phi i16 [ %abits9.i.i, %probe_insert_init.i.i ], [ %abits.i.i, %inext.i689.i ]
  %86 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits.lcssa.i.i, i1 true)
  %tz64.i.i = zext nneg i16 %86 to i64
  %s_add.i.i = add i64 %pos.lcssa.i.i, %tz64.i.i
  %slot_g.i.i = and i64 %s_add.i.i, %mask.i.i
  %u_cur.pre.i.i = load i64, ptr %used_p.i.i, align 8
  br label %iput_commit.i.i

iput_commit.i.i:                                  ; preds = %iput.i.i, %fast_insert_prep.i.i
  %u_cur.i.i = phi i64 [ %used0.i.i, %fast_insert_prep.i.i ], [ %u_cur.pre.i.i, %iput.i.i ]
  %slot.i.i = phi i64 [ %avail_slot.i.i, %fast_insert_prep.i.i ], [ %slot_g.i.i, %iput.i.i ]
  %ctrl_c.i.i = phi ptr [ %ctrl0.i.i, %fast_insert_prep.i.i ], [ %ctrl.i.i, %iput.i.i ]
  %scap_c.i.i = phi i64 [ %scap0.i.i, %fast_insert_prep.i.i ], [ %scap.i.i, %iput.i.i ]
  %.pn.i.i = phi ptr [ %84, %fast_insert_prep.i.i ], [ %85, %iput.i.i ]
  %keys_c.i.i = phi ptr [ %keys_f.i.i, %fast_insert_prep.i.i ], [ %keys.i.i, %iput.i.i ]
  %h2_c.in.i.i = lshr i64 %m2.i.i.i, 57
  %h2_c.i.i = trunc nuw nsw i64 %h2_c.in.i.i to i8
  %idx_base_c.i.i = getelementptr i8, ptr %.pn.i.i, i64 17
  %sp_c.i.i = getelementptr inbounds i8, ptr %ctrl_c.i.i, i64 %slot.i.i
  %old_cb.i.i = load i8, ptr %sp_c.i.i, align 1
  %was_empty.i.i = icmp eq i8 %old_cb.i.i, -128
  %u_inc.i.i = zext i1 %was_empty.i.i to i64
  %u_new.i.i = add i64 %u_cur.i.i, %u_inc.i.i
  store i64 %u_new.i.i, ptr %used_p.i.i, align 8
  store i8 %h2_c.i.i, ptr %sp_c.i.i, align 1
  %mir.i.i.i = icmp ult i64 %slot.i.i, 16
  br i1 %mir.i.i.i, label %do_mir.i.i.i, label %archx_dict_set_ctrl.exit.i.i

do_mir.i.i.i:                                     ; preds = %iput_commit.i.i
  %87 = getelementptr i8, ptr %ctrl_c.i.i, i64 %scap_c.i.i
  %mp.i.i.i = getelementptr i8, ptr %87, i64 %slot.i.i
  store i8 %h2_c.i.i, ptr %mp.i.i.i, align 1
  br label %archx_dict_set_ctrl.exit.i.i

archx_dict_set_ctrl.exit.i.i:                     ; preds = %do_mir.i.i.i, %iput_commit.i.i
  %d_idx.i.i = load i64, ptr %hdr.i.i, align 8
  %d_new.i.i = add i64 %d_idx.i.i, 1
  store i64 %d_new.i.i, ptr %hdr.i.i, align 8
  %ip.i.i = getelementptr inbounds i32, ptr %idx_base_c.i.i, i64 %slot.i.i
  %d_idx32.i.i = trunc i64 %d_idx.i.i to i32
  store i32 %d_idx32.i.i, ptr %ip.i.i, align 4
  %kp.i.i = getelementptr inbounds i64, ptr %keys_c.i.i, i64 %d_idx.i.i
  store i64 %t175.i, ptr %kp.i.i, align 8
  br label %if.merge.62.i

if.merge.62.i:                                    ; preds = %archx_dict_set_ctrl.exit.i.i, %archx_dict_find_h_i64.exit.i.i, %dupd.ok.58.i
  %tag.i123.i = and i64 %w1.i.i.i.i, 1
  %owned.not.i124.i = icmp eq i64 %tag.i123.i, 0
  %or.cond790.i = select i1 %short.i.i.i.i, i1 true, i1 %owned.not.i124.i
  br i1 %or.cond790.i, label %archx_str_drop.exit128.i, label %do_free.i125.i

do_free.i125.i:                                   ; preds = %if.merge.62.i
  %raw.i126.i = and i64 %w1.i.i.i.i, -2
  %ptr.i127.i = inttoptr i64 %raw.i126.i to ptr
  call void @free(ptr %ptr.i127.i)
  br label %archx_str_drop.exit128.i

archx_str_drop.exit128.i:                         ; preds = %do_free.i125.i, %if.merge.62.i
  %t204.i = add nuw nsw i64 %for.step.167.0876.i, 1
  %exitcond936.not.i = icmp eq i64 %t204.i, 4096
  br i1 %exitcond936.not.i, label %for.cond.63.preheader.i, label %idx.ok.56.i

idx.ok.67.i:                                      ; preds = %archx_str_drop.exit139.i, %for.cond.63.preheader.i
  %for.p.205.0886.i = phi i64 [ 0, %for.cond.63.preheader.i ], [ %t237.i, %archx_str_drop.exit139.i ]
  %var.checksum.114.1885.i = phi i64 [ %var.checksum.114.0900.i, %for.cond.63.preheader.i ], [ %t234.i, %archx_str_drop.exit139.i ]
  %t210.i = mul nuw nsw i64 %for.p.205.0886.i, 131
  %t213.i = add nuw nsw i64 %t210.i, %t212.i
  %t214.i = and i64 %t213.i, 511
  %t218.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.3.i, i64 %t214.i
  %t219.unpack.i = load i64, ptr %t218.i, align 8
  %88 = insertvalue %ArchxStr poison, i64 %t219.unpack.i, 0
  %t219.elt61.i = getelementptr inbounds nuw i8, ptr %t218.i, i64 8
  %t219.unpack62.i = load i64, ptr %t219.elt61.i, align 8
  %t21963.i = insertvalue %ArchxStr %88, i64 %t219.unpack62.i, 1
  %len.i691.i = and i64 %t219.unpack.i, 4294967295
  %long.i692.i = icmp samesign ult i64 %len.i691.i, 13
  %tag.i696.i = and i64 %t219.unpack62.i, 3
  %owned.not.i697.i = icmp eq i64 %tag.i696.i, 0
  %or.cond791.i = select i1 %long.i692.i, i1 true, i1 %owned.not.i697.i
  br i1 %or.cond791.i, label %archx_str_clone.exit708.i, label %dup_heap.i698.i

dup_heap.i698.i:                                  ; preds = %idx.ok.67.i
  %dst.i699.i = call noalias align 16 ptr @malloc(i64 %len.i691.i)
  %isnull.i700.i = icmp eq ptr %dst.i699.i, null
  br i1 %isnull.i700.i, label %oom.i707.i, label %copy.i701.i

oom.i707.i:                                       ; preds = %dup_heap.i698.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i701.i:                                      ; preds = %dup_heap.i698.i
  %src_i.i702.i = and i64 %t219.unpack62.i, -4
  %src.i703.i = inttoptr i64 %src_i.i702.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i699.i, ptr nonnull align 4 %src.i703.i, i64 %len.i691.i, i1 false)
  %dst_i.i704.i = ptrtoint ptr %dst.i699.i to i64
  %tagged.i705.i = or disjoint i64 %dst_i.i704.i, 1
  %out.i706.i = insertvalue %ArchxStr %t21963.i, i64 %tagged.i705.i, 1
  br label %archx_str_clone.exit708.i

archx_str_clone.exit708.i:                        ; preds = %copy.i701.i, %idx.ok.67.i
  %common.ret.op.i693.i = phi %ArchxStr [ %out.i706.i, %copy.i701.i ], [ %t21963.i, %idx.ok.67.i ]
  %w0.i.i.i238.i = extractvalue %ArchxStr %common.ret.op.i693.i, 0
  %w1.i.i.i239.i = extractvalue %ArchxStr %common.ret.op.i693.i, 1
  %len.i.i.i240.i = and i64 %w0.i.i.i238.i, 4294967295
  %short.i.i.i241.i = icmp samesign ult i64 %len.i.i.i240.i, 13
  br i1 %short.i.i.i241.i, label %sso_hash.i.i.i381.i, label %long_hash.i.i.i242.i

sso_hash.i.i.i381.i:                              ; preds = %archx_str_clone.exit708.i
  %p0_raw.i.i.i382.i = lshr i64 %w0.i.i.i238.i, 32
  %le4.i.i.i383.i = icmp samesign ult i64 %len.i.i.i240.i, 5
  br i1 %le4.i.i.i383.i, label %sso_le4.i.i.i407.i, label %sso_gt4.i.i.i384.i

sso_le4.i.i.i407.i:                               ; preds = %sso_hash.i.i.i381.i
  %sh0.i.i.i408.i = shl nuw nsw i64 %len.i.i.i240.i, 3
  %notmask1.i.i.i409.i = shl nsw i64 -1, %sh0.i.i.i408.i
  %m0.i.i.i410.i = xor i64 %notmask1.i.i.i409.i, -1
  %p0_4.i.i.i411.i = and i64 %p0_raw.i.i.i382.i, %m0.i.i.i410.i
  br label %sso_mix.i.i.i392.i

sso_gt4.i.i.i384.i:                               ; preds = %sso_hash.i.i.i381.i
  %eq12.i.i.i385.i = icmp eq i64 %len.i.i.i240.i, 12
  br i1 %eq12.i.i.i385.i, label %sso_mix.i.i.i392.i, label %sso_mid.i.i.i386.i

sso_mid.i.i.i386.i:                               ; preds = %sso_gt4.i.i.i384.i
  %rem.i.i.i387.i = shl nuw nsw i64 %len.i.i.i240.i, 3
  %sh1.i.i.i388.i = add nsw i64 %rem.i.i.i387.i, -32
  %notmask.i.i.i389.i = shl nsw i64 -1, %sh1.i.i.i388.i
  %m1.i.i.i390.i = xor i64 %notmask.i.i.i389.i, -1
  %p1_m.i.i.i391.i = and i64 %w1.i.i.i239.i, %m1.i.i.i390.i
  br label %sso_mix.i.i.i392.i

sso_mix.i.i.i392.i:                               ; preds = %sso_mid.i.i.i386.i, %sso_gt4.i.i.i384.i, %sso_le4.i.i.i407.i
  %p0.i.i.i393.i = phi i64 [ %p0_4.i.i.i411.i, %sso_le4.i.i.i407.i ], [ %p0_raw.i.i.i382.i, %sso_mid.i.i.i386.i ], [ %p0_raw.i.i.i382.i, %sso_gt4.i.i.i384.i ]
  %p1.i.i.i394.i = phi i64 [ 0, %sso_le4.i.i.i407.i ], [ %p1_m.i.i.i391.i, %sso_mid.i.i.i386.i ], [ %w1.i.i.i239.i, %sso_gt4.i.i.i384.i ]
  %a0.i.i.i395.i = mul i64 %p0.i.i.i393.i, -7046029254386353131
  %a1.i.i.i396.i = mul i64 %p1.i.i.i394.i, -4417276706812531889
  %ax.i.i.i397.i = xor i64 %a1.i.i.i396.i, %a0.i.i.i395.i
  %s1.i10.i.i.i399.i = lshr i64 %ax.i.i.i397.i, 30
  %89 = xor i64 %len.i.i.i240.i, %s1.i10.i.i.i399.i
  %x1.i11.i.i.i400.i = xor i64 %89, %ax.i.i.i397.i
  br label %archx_hash_str.exit.i.i264.i

long_hash.i.i.i242.i:                             ; preds = %archx_str_clone.exit708.i
  %raw.i.i.i243.i = and i64 %w1.i.i.i239.i, -4
  %ptr.i.i.i244.i = inttoptr i64 %raw.i.i.i243.i to ptr
  %seed.i.i.i245.i = mul i64 %len.i.i.i240.i, -7046029254386353131
  %90 = add nsw i64 %len.i.i.i240.i, -8
  %91 = icmp ult i64 %90, 8
  br i1 %91, label %l_tail_cond.i.i.i251.preheader.i.unr-lcssa, label %long_hash.i.i.i242.i.new

long_hash.i.i.i242.i.new:                         ; preds = %long_hash.i.i.i242.i
  %92 = lshr i64 %90, 3
  %93 = add nuw nsw i64 %92, 1
  %unroll_iter1904 = and i64 %93, 4611686018427387902
  br label %l_body.i.i.i366.i

l_tail_cond.i.i.i251.preheader.i.unr-lcssa:       ; preds = %l_body.i.i.i366.i, %long_hash.i.i.i242.i
  %acc_next.i.i.i379.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i242.i ], [ %acc_next.i.i.i379.i.1, %l_body.i.i.i366.i ]
  %idx_next.i.i.i380.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i242.i ], [ %idx_next.i.i.i380.i.1, %l_body.i.i.i366.i ]
  %acc.i.i.i248878.i.unr = phi i64 [ %seed.i.i.i245.i, %long_hash.i.i.i242.i ], [ %acc_next.i.i.i379.i.1, %l_body.i.i.i366.i ]
  %idx.i.i.i247877.i.unr = phi i64 [ 0, %long_hash.i.i.i242.i ], [ %idx_next.i.i.i380.i.1, %l_body.i.i.i366.i ]
  %94 = and i64 %90, 8
  %lcmp.mod1901.not.not = icmp eq i64 %94, 0
  br i1 %lcmp.mod1901.not.not, label %l_body.i.i.i366.i.epil, label %l_tail_cond.i.i.i251.preheader.i

l_body.i.i.i366.i.epil:                           ; preds = %l_tail_cond.i.i.i251.preheader.i.unr-lcssa
  %lp.i.i.i367.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i.i244.i, i64 %idx.i.i.i247877.i.unr
  %lane.i.i.i368.i.epil = load i64, ptr %lp.i.i.i367.i.epil, align 4
  %lm.i.i.i369.i.epil = mul i64 %lane.i.i.i368.i.epil, -4417276706812531889
  %lx.i.i.i370.i.epil = xor i64 %lm.i.i.i369.i.epil, %acc.i.i.i248878.i.unr
  %s1.i2.i.i.i371.i.epil = lshr i64 %lx.i.i.i370.i.epil, 30
  %x1.i3.i.i.i372.i.epil = xor i64 %s1.i2.i.i.i371.i.epil, %lx.i.i.i370.i.epil
  %m1.i4.i.i.i373.i.epil = mul i64 %x1.i3.i.i.i372.i.epil, -4658895280553007687
  %s2.i5.i.i.i374.i.epil = lshr i64 %m1.i4.i.i.i373.i.epil, 27
  %x2.i6.i.i.i375.i.epil = xor i64 %s2.i5.i.i.i374.i.epil, %m1.i4.i.i.i373.i.epil
  %m2.i7.i.i.i376.i.epil = mul i64 %x2.i6.i.i.i375.i.epil, -7723592293110705685
  %s3.i8.i.i.i377.i.epil = lshr i64 %m2.i7.i.i.i376.i.epil, 31
  %x3.i9.i.i.i378.i.epil = xor i64 %s3.i8.i.i.i377.i.epil, %m2.i7.i.i.i376.i.epil
  %acc_next.i.i.i379.i.epil = add i64 %x3.i9.i.i.i378.i.epil, %idx.i.i.i247877.i.unr
  %idx_next.i.i.i380.i.epil = add nuw nsw i64 %idx.i.i.i247877.i.unr, 8
  br label %l_tail_cond.i.i.i251.preheader.i

l_tail_cond.i.i.i251.preheader.i:                 ; preds = %l_tail_cond.i.i.i251.preheader.i.unr-lcssa, %l_body.i.i.i366.i.epil
  %acc_next.i.i.i379.i.lcssa = phi i64 [ %acc_next.i.i.i379.i.lcssa.ph, %l_tail_cond.i.i.i251.preheader.i.unr-lcssa ], [ %acc_next.i.i.i379.i.epil, %l_body.i.i.i366.i.epil ]
  %idx_next.i.i.i380.i.lcssa = phi i64 [ %idx_next.i.i.i380.i.lcssa.ph, %l_tail_cond.i.i.i251.preheader.i.unr-lcssa ], [ %idx_next.i.i.i380.i.epil, %l_body.i.i.i366.i.epil ]
  %tmore.i.i.i254879.i = icmp samesign ult i64 %idx_next.i.i.i380.i.lcssa, %len.i.i.i240.i
  br i1 %tmore.i.i.i254879.i, label %l_tail_body.i.i.i359.i.preheader, label %l_done.i.i.i255.i

l_tail_body.i.i.i359.i.preheader:                 ; preds = %l_tail_cond.i.i.i251.preheader.i
  %95 = sub i64 %w0.i.i.i238.i, %idx_next.i.i.i380.i.lcssa
  %xtraiter1906 = and i64 %95, 3
  %lcmp.mod1907.not = icmp eq i64 %xtraiter1906, 0
  br i1 %lcmp.mod1907.not, label %l_tail_body.i.i.i359.i.prol.loopexit, label %l_tail_body.i.i.i359.i.prol

l_tail_body.i.i.i359.i.prol:                      ; preds = %l_tail_body.i.i.i359.i.preheader, %l_tail_body.i.i.i359.i.prol
  %tacc.i.i.i253881.i.prol = phi i64 [ %tacc_next.i.i.i364.i.prol, %l_tail_body.i.i.i359.i.prol ], [ %acc_next.i.i.i379.i.lcssa, %l_tail_body.i.i.i359.i.preheader ]
  %ti.i.i.i252880.i.prol = phi i64 [ %ti_next.i.i.i365.i.prol, %l_tail_body.i.i.i359.i.prol ], [ %idx_next.i.i.i380.i.lcssa, %l_tail_body.i.i.i359.i.preheader ]
  %prol.iter1908 = phi i64 [ %prol.iter1908.next, %l_tail_body.i.i.i359.i.prol ], [ 0, %l_tail_body.i.i.i359.i.preheader ]
  %tp.i.i.i360.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i.i244.i, i64 %ti.i.i.i252880.i.prol
  %tb.i.i.i361.i.prol = load i8, ptr %tp.i.i.i360.i.prol, align 1
  %tz.i.i.i362.i.prol = zext i8 %tb.i.i.i361.i.prol to i64
  %tx.i.i.i363.i.prol = xor i64 %tacc.i.i.i253881.i.prol, %tz.i.i.i362.i.prol
  %tacc_next.i.i.i364.i.prol = mul i64 %tx.i.i.i363.i.prol, 1099511628211
  %ti_next.i.i.i365.i.prol = add nuw nsw i64 %ti.i.i.i252880.i.prol, 1
  %prol.iter1908.next = add i64 %prol.iter1908, 1
  %prol.iter1908.cmp.not = icmp eq i64 %prol.iter1908.next, %xtraiter1906
  br i1 %prol.iter1908.cmp.not, label %l_tail_body.i.i.i359.i.prol.loopexit, label %l_tail_body.i.i.i359.i.prol, !llvm.loop !10

l_tail_body.i.i.i359.i.prol.loopexit:             ; preds = %l_tail_body.i.i.i359.i.prol, %l_tail_body.i.i.i359.i.preheader
  %tacc.i.i.i253881.i.unr = phi i64 [ %acc_next.i.i.i379.i.lcssa, %l_tail_body.i.i.i359.i.preheader ], [ %tacc_next.i.i.i364.i.prol, %l_tail_body.i.i.i359.i.prol ]
  %ti.i.i.i252880.i.unr = phi i64 [ %idx_next.i.i.i380.i.lcssa, %l_tail_body.i.i.i359.i.preheader ], [ %ti_next.i.i.i365.i.prol, %l_tail_body.i.i.i359.i.prol ]
  %tacc_next.i.i.i364.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.i359.i.preheader ], [ %tacc_next.i.i.i364.i.prol, %l_tail_body.i.i.i359.i.prol ]
  %96 = sub i64 %idx_next.i.i.i380.i.lcssa, %len.i.i.i240.i
  %97 = icmp ugt i64 %96, -4
  br i1 %97, label %l_done.i.i.i255.i, label %l_tail_body.i.i.i359.i.preheader.new

l_tail_body.i.i.i359.i.preheader.new:             ; preds = %l_tail_body.i.i.i359.i.prol.loopexit
  %invariant.gep1929 = getelementptr i8, ptr %ptr.i.i.i244.i, i64 1
  %invariant.gep1931 = getelementptr i8, ptr %ptr.i.i.i244.i, i64 2
  %invariant.gep1933 = getelementptr i8, ptr %ptr.i.i.i244.i, i64 3
  br label %l_tail_body.i.i.i359.i

l_body.i.i.i366.i:                                ; preds = %l_body.i.i.i366.i, %long_hash.i.i.i242.i.new
  %acc.i.i.i248878.i = phi i64 [ %seed.i.i.i245.i, %long_hash.i.i.i242.i.new ], [ %acc_next.i.i.i379.i.1, %l_body.i.i.i366.i ]
  %idx.i.i.i247877.i = phi i64 [ 0, %long_hash.i.i.i242.i.new ], [ %idx_next.i.i.i380.i.1, %l_body.i.i.i366.i ]
  %niter1905 = phi i64 [ 0, %long_hash.i.i.i242.i.new ], [ %niter1905.next.1, %l_body.i.i.i366.i ]
  %lp.i.i.i367.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i244.i, i64 %idx.i.i.i247877.i
  %lane.i.i.i368.i = load i64, ptr %lp.i.i.i367.i, align 4
  %lm.i.i.i369.i = mul i64 %lane.i.i.i368.i, -4417276706812531889
  %lx.i.i.i370.i = xor i64 %lm.i.i.i369.i, %acc.i.i.i248878.i
  %s1.i2.i.i.i371.i = lshr i64 %lx.i.i.i370.i, 30
  %x1.i3.i.i.i372.i = xor i64 %s1.i2.i.i.i371.i, %lx.i.i.i370.i
  %m1.i4.i.i.i373.i = mul i64 %x1.i3.i.i.i372.i, -4658895280553007687
  %s2.i5.i.i.i374.i = lshr i64 %m1.i4.i.i.i373.i, 27
  %x2.i6.i.i.i375.i = xor i64 %s2.i5.i.i.i374.i, %m1.i4.i.i.i373.i
  %m2.i7.i.i.i376.i = mul i64 %x2.i6.i.i.i375.i, -7723592293110705685
  %s3.i8.i.i.i377.i = lshr i64 %m2.i7.i.i.i376.i, 31
  %x3.i9.i.i.i378.i = xor i64 %s3.i8.i.i.i377.i, %m2.i7.i.i.i376.i
  %acc_next.i.i.i379.i = add i64 %x3.i9.i.i.i378.i, %idx.i.i.i247877.i
  %idx_next.i.i.i380.i = or disjoint i64 %idx.i.i.i247877.i, 8
  %lp.i.i.i367.i.1 = getelementptr inbounds nuw i8, ptr %ptr.i.i.i244.i, i64 %idx_next.i.i.i380.i
  %lane.i.i.i368.i.1 = load i64, ptr %lp.i.i.i367.i.1, align 4
  %lm.i.i.i369.i.1 = mul i64 %lane.i.i.i368.i.1, -4417276706812531889
  %lx.i.i.i370.i.1 = xor i64 %lm.i.i.i369.i.1, %acc_next.i.i.i379.i
  %s1.i2.i.i.i371.i.1 = lshr i64 %lx.i.i.i370.i.1, 30
  %x1.i3.i.i.i372.i.1 = xor i64 %s1.i2.i.i.i371.i.1, %lx.i.i.i370.i.1
  %m1.i4.i.i.i373.i.1 = mul i64 %x1.i3.i.i.i372.i.1, -4658895280553007687
  %s2.i5.i.i.i374.i.1 = lshr i64 %m1.i4.i.i.i373.i.1, 27
  %x2.i6.i.i.i375.i.1 = xor i64 %s2.i5.i.i.i374.i.1, %m1.i4.i.i.i373.i.1
  %m2.i7.i.i.i376.i.1 = mul i64 %x2.i6.i.i.i375.i.1, -7723592293110705685
  %s3.i8.i.i.i377.i.1 = lshr i64 %m2.i7.i.i.i376.i.1, 31
  %x3.i9.i.i.i378.i.1 = xor i64 %s3.i8.i.i.i377.i.1, %m2.i7.i.i.i376.i.1
  %acc_next.i.i.i379.i.1 = add i64 %x3.i9.i.i.i378.i.1, %idx_next.i.i.i380.i
  %idx_next.i.i.i380.i.1 = add nuw nsw i64 %idx.i.i.i247877.i, 16
  %niter1905.next.1 = add i64 %niter1905, 2
  %niter1905.ncmp.1.not = icmp eq i64 %niter1905.next.1, %unroll_iter1904
  br i1 %niter1905.ncmp.1.not, label %l_tail_cond.i.i.i251.preheader.i.unr-lcssa, label %l_body.i.i.i366.i

l_tail_body.i.i.i359.i:                           ; preds = %l_tail_body.i.i.i359.i, %l_tail_body.i.i.i359.i.preheader.new
  %tacc.i.i.i253881.i = phi i64 [ %tacc.i.i.i253881.i.unr, %l_tail_body.i.i.i359.i.preheader.new ], [ %tacc_next.i.i.i364.i.3, %l_tail_body.i.i.i359.i ]
  %ti.i.i.i252880.i = phi i64 [ %ti.i.i.i252880.i.unr, %l_tail_body.i.i.i359.i.preheader.new ], [ %ti_next.i.i.i365.i.3, %l_tail_body.i.i.i359.i ]
  %tp.i.i.i360.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i244.i, i64 %ti.i.i.i252880.i
  %tb.i.i.i361.i = load i8, ptr %tp.i.i.i360.i, align 1
  %tz.i.i.i362.i = zext i8 %tb.i.i.i361.i to i64
  %tx.i.i.i363.i = xor i64 %tacc.i.i.i253881.i, %tz.i.i.i362.i
  %tacc_next.i.i.i364.i = mul i64 %tx.i.i.i363.i, 1099511628211
  %gep1930 = getelementptr i8, ptr %invariant.gep1929, i64 %ti.i.i.i252880.i
  %tb.i.i.i361.i.1 = load i8, ptr %gep1930, align 1
  %tz.i.i.i362.i.1 = zext i8 %tb.i.i.i361.i.1 to i64
  %tx.i.i.i363.i.1 = xor i64 %tacc_next.i.i.i364.i, %tz.i.i.i362.i.1
  %tacc_next.i.i.i364.i.1 = mul i64 %tx.i.i.i363.i.1, 1099511628211
  %gep1932 = getelementptr i8, ptr %invariant.gep1931, i64 %ti.i.i.i252880.i
  %tb.i.i.i361.i.2 = load i8, ptr %gep1932, align 1
  %tz.i.i.i362.i.2 = zext i8 %tb.i.i.i361.i.2 to i64
  %tx.i.i.i363.i.2 = xor i64 %tacc_next.i.i.i364.i.1, %tz.i.i.i362.i.2
  %tacc_next.i.i.i364.i.2 = mul i64 %tx.i.i.i363.i.2, 1099511628211
  %gep1934 = getelementptr i8, ptr %invariant.gep1933, i64 %ti.i.i.i252880.i
  %tb.i.i.i361.i.3 = load i8, ptr %gep1934, align 1
  %tz.i.i.i362.i.3 = zext i8 %tb.i.i.i361.i.3 to i64
  %tx.i.i.i363.i.3 = xor i64 %tacc_next.i.i.i364.i.2, %tz.i.i.i362.i.3
  %tacc_next.i.i.i364.i.3 = mul i64 %tx.i.i.i363.i.3, 1099511628211
  %ti_next.i.i.i365.i.3 = add nuw nsw i64 %ti.i.i.i252880.i, 4
  %tmore.i.i.i254.i.3 = icmp samesign ult i64 %ti_next.i.i.i365.i.3, %len.i.i.i240.i
  br i1 %tmore.i.i.i254.i.3, label %l_tail_body.i.i.i359.i, label %l_done.i.i.i255.i

l_done.i.i.i255.i:                                ; preds = %l_tail_body.i.i.i359.i.prol.loopexit, %l_tail_body.i.i.i359.i, %l_tail_cond.i.i.i251.preheader.i
  %tacc.i.i.i253.lcssa.i = phi i64 [ %acc_next.i.i.i379.i.lcssa, %l_tail_cond.i.i.i251.preheader.i ], [ %tacc_next.i.i.i364.i.lcssa.unr, %l_tail_body.i.i.i359.i.prol.loopexit ], [ %tacc_next.i.i.i364.i.3, %l_tail_body.i.i.i359.i ]
  %s1.i.i.i.i256.i = lshr i64 %tacc.i.i.i253.lcssa.i, 30
  %x1.i.i.i.i257.i = xor i64 %s1.i.i.i.i256.i, %tacc.i.i.i253.lcssa.i
  br label %archx_hash_str.exit.i.i264.i

archx_hash_str.exit.i.i264.i:                     ; preds = %l_done.i.i.i255.i, %sso_mix.i.i.i392.i
  %x1.i.i.i.i257.sink.i = phi i64 [ %x1.i.i.i.i257.i, %l_done.i.i.i255.i ], [ %x1.i11.i.i.i400.i, %sso_mix.i.i.i392.i ]
  %ctrl.i.i.i271.i = load ptr, ptr %ctrl_p.i, align 8
  %c_null.i.i.i272.i = icmp eq ptr %ctrl.i.i.i271.i, null
  br i1 %c_null.i.i.i272.i, label %dget2.merge.73.i, label %do_probe.i.i.i273.i

do_probe.i.i.i273.i:                              ; preds = %archx_hash_str.exit.i.i264.i
  %m1.i.i.i.i258.i = mul i64 %x1.i.i.i.i257.sink.i, -4658895280553007687
  %s2.i.i.i.i259.i = lshr i64 %m1.i.i.i.i258.i, 27
  %x2.i.i.i.i260.i = xor i64 %s2.i.i.i.i259.i, %m1.i.i.i.i258.i
  %m2.i.i.i.i261.i = mul i64 %x2.i.i.i.i260.i, -7723592293110705685
  %s3.i.i.i.i262.i = lshr i64 %m2.i.i.i.i261.i, 31
  %x3.i.i.i.i263.i = xor i64 %s3.i.i.i.i262.i, %m2.i.i.i.i261.i
  %mask.i.i.i276.i = load i64, ptr %mask_p.i.i, align 8
  %keys.i.i.i277.i = load ptr, ptr %keys_p.i.i, align 8
  %98 = getelementptr i8, ptr %ctrl.i.i.i271.i, i64 %mask.i.i.i276.i
  %idx_base.i.i.i278.i = getelementptr i8, ptr %98, i64 17
  %h2_64.i.i.i279.i = lshr i64 %m2.i.i.i.i261.i, 57
  %h2.i.i.i280.i = trunc nuw nsw i64 %h2_64.i.i.i279.i to i8
  %h2_ins.i.i.i281.i = insertelement <16 x i8> poison, i8 %h2.i.i.i280.i, i64 0
  %h2_vec.i.i.i282.i = shufflevector <16 x i8> %h2_ins.i.i.i281.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bp_i.i.i.i.i327.i = and i64 %w1.i.i.i239.i, -4
  %bp.i.i.i.i331.i = inttoptr i64 %bp_i.i.i.i.i327.i to ptr
  %bp4.i.i.i.i333.i = getelementptr inbounds nuw i8, ptr %bp.i.i.i.i331.i, i64 4
  %rem.i.i.i.i334.i = add nsw i64 %len.i.i.i240.i, -4
  br label %probe.i.i.i283.i

probe.i.i.i283.i:                                 ; preds = %next_grp.i.i.i348.i, %do_probe.i.i.i273.i
  %h.pn.i.i.i284.i = phi i64 [ %x3.i.i.i.i263.i, %do_probe.i.i.i273.i ], [ %padd.i.i.i350.i, %next_grp.i.i.i348.i ]
  %step.i.i.i285.i = phi i64 [ 0, %do_probe.i.i.i273.i ], [ %step_next.i.i.i349.i, %next_grp.i.i.i348.i ]
  %avail.i.i.i286.i = phi i64 [ -1, %do_probe.i.i.i273.i ], [ %avail_cur.i.i.i342.i, %next_grp.i.i.i348.i ]
  %pos.i.i.i287.i = and i64 %h.pn.i.i.i284.i, %mask.i.i.i276.i
  %gp.i.i.i288.i = getelementptr inbounds i8, ptr %ctrl.i.i.i271.i, i64 %pos.i.i.i287.i
  %grp.i.i.i289.i = load <16 x i8>, ptr %gp.i.i.i288.i, align 1
  %mcmp.i.i.i290.i = icmp eq <16 x i8> %grp.i.i.i289.i, %h2_vec.i.i.i282.i
  %mbits.i.i.i291.i = bitcast <16 x i1> %mcmp.i.i.i290.i to i16
  %has_m.not.i.i.i295883.i = icmp eq i16 %mbits.i.i.i291.i, 0
  br i1 %has_m.not.i.i.i295883.i, label %chk_empty.i.i.i339.i, label %chk_key.i.i.i296.preheader.i

chk_key.i.i.i296.preheader.i:                     ; preds = %probe.i.i.i283.i
  %mmask0.i.i.i292.i = zext i16 %mbits.i.i.i291.i to i32
  br label %chk_key.i.i.i296.i

chk_key.i.i.i296.i:                               ; preds = %mbit_cont.i.i.i313.i, %chk_key.i.i.i296.preheader.i
  %mmask.i.i.i294884.i = phi i32 [ %mmask_next.i.i.i315.i, %mbit_cont.i.i.i313.i ], [ %mmask0.i.i.i292.i, %chk_key.i.i.i296.preheader.i ]
  %tz.i2.i.i297.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i294884.i, i1 true)
  %tz64.i.i.i298.i = zext nneg i32 %tz.i2.i.i297.i to i64
  %s_add.i.i.i299.i = add i64 %pos.i.i.i287.i, %tz64.i.i.i298.i
  %slot.i.i.i300.i = and i64 %s_add.i.i.i299.i, %mask.i.i.i276.i
  %ip.i.i.i301.i = getelementptr inbounds i32, ptr %idx_base.i.i.i278.i, i64 %slot.i.i.i300.i
  %didx32.i.i.i302.i = load i32, ptr %ip.i.i.i301.i, align 4
  %didx.i.i.i303.i = zext i32 %didx32.i.i.i302.i to i64
  %kp.i.i.i304.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i277.i, i64 %didx.i.i.i303.i
  %cand_k.unpack.i.i.i305.i = load i64, ptr %kp.i.i.i304.i, align 8
  %cand_k.elt1.i.i.i306.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i304.i, i64 8
  %cand_k.unpack2.i.i.i307.i = load i64, ptr %cand_k.elt1.i.i.i306.i, align 8
  %w0_eq.i.i.i.i310.i = icmp eq i64 %cand_k.unpack.i.i.i305.i, %w0.i.i.i238.i
  br i1 %w0_eq.i.i.i.i310.i, label %chk_len.i.i.i.i321.i, label %mbit_cont.i.i.i313.i

chk_len.i.i.i.i321.i:                             ; preds = %chk_key.i.i.i296.i
  br i1 %short.i.i.i241.i, label %cmp_short.i.i.i.i337.i, label %cmp_long.i.i.i.i325.i

cmp_short.i.i.i.i337.i:                           ; preds = %chk_len.i.i.i.i321.i
  %eq_s.i.i.i.i338.i = icmp eq i64 %cand_k.unpack2.i.i.i307.i, %w1.i.i.i239.i
  br i1 %eq_s.i.i.i.i338.i, label %dget2.hit.69.i, label %mbit_cont.i.i.i313.i

cmp_long.i.i.i.i325.i:                            ; preds = %chk_len.i.i.i.i321.i
  %ap_i.i.i.i.i326.i = and i64 %cand_k.unpack2.i.i.i307.i, -4
  %same_ptr.i.i.i.i328.i = icmp eq i64 %ap_i.i.i.i.i326.i, %bp_i.i.i.i.i327.i
  br i1 %same_ptr.i.i.i.i328.i, label %dget2.hit.69.i, label %archx_str_eq.exit.i.i.i311.i

archx_str_eq.exit.i.i.i311.i:                     ; preds = %cmp_long.i.i.i.i325.i
  %ap.i.i.i.i330.i = inttoptr i64 %ap_i.i.i.i.i326.i to ptr
  %ap4.i.i.i.i332.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i330.i, i64 4
  %bcmp.i.i.i.i335.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i.i332.i, ptr nonnull %bp4.i.i.i.i333.i, i64 %rem.i.i.i.i334.i)
  %eq_m.i.i.i.i336.i = icmp eq i32 %bcmp.i.i.i.i335.i, 0
  br i1 %eq_m.i.i.i.i336.i, label %dget2.hit.69.i, label %mbit_cont.i.i.i313.i

mbit_cont.i.i.i313.i:                             ; preds = %archx_str_eq.exit.i.i.i311.i, %cmp_short.i.i.i.i337.i, %chk_key.i.i.i296.i
  %mm1.i.i.i314.i = add nsw i32 %mmask.i.i.i294884.i, -1
  %mmask_next.i.i.i315.i = and i32 %mm1.i.i.i314.i, %mmask.i.i.i294884.i
  %has_m.not.i.i.i295.i = icmp eq i32 %mmask_next.i.i.i315.i, 0
  br i1 %has_m.not.i.i.i295.i, label %chk_empty.i.i.i339.i, label %chk_key.i.i.i296.i

chk_empty.i.i.i339.i:                             ; preds = %mbit_cont.i.i.i313.i, %probe.i.i.i283.i
  %need_a.i.i.i340.i = icmp slt i64 %avail.i.i.i286.i, 0
  br i1 %need_a.i.i.i340.i, label %find_a.i.i.i351.i, label %after_a.i.i.i341.i

find_a.i.i.i351.i:                                ; preds = %chk_empty.i.i.i339.i
  %acmp.i.i.i352.i = icmp slt <16 x i8> %grp.i.i.i289.i, zeroinitializer
  %abits16.i.i.i353.i = bitcast <16 x i1> %acmp.i.i.i352.i to i16
  %has_a0.not.i.i.i354.i = icmp eq i16 %abits16.i.i.i353.i, 0
  br i1 %has_a0.not.i.i.i354.i, label %after_a.i.i.i341.i, label %set_a.i.i.i355.i

set_a.i.i.i355.i:                                 ; preds = %find_a.i.i.i351.i
  %99 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i353.i, i1 true)
  %atz64.i.i.i356.i = zext nneg i16 %99 to i64
  %as_add.i.i.i357.i = add i64 %pos.i.i.i287.i, %atz64.i.i.i356.i
  %aslot.i.i.i358.i = and i64 %as_add.i.i.i357.i, %mask.i.i.i276.i
  br label %after_a.i.i.i341.i

after_a.i.i.i341.i:                               ; preds = %set_a.i.i.i355.i, %find_a.i.i.i351.i, %chk_empty.i.i.i339.i
  %avail_cur.i.i.i342.i = phi i64 [ %avail.i.i.i286.i, %chk_empty.i.i.i339.i ], [ -1, %find_a.i.i.i351.i ], [ %aslot.i.i.i358.i, %set_a.i.i.i355.i ]
  %ecmp.i.i.i343.i = icmp eq <16 x i8> %grp.i.i.i289.i, splat (i8 -128)
  %ebits.i.i.i344.i = bitcast <16 x i1> %ecmp.i.i.i343.i to i16
  %has_e.not.i.i.i345.i = icmp eq i16 %ebits.i.i.i344.i, 0
  br i1 %has_e.not.i.i.i345.i, label %next_grp.i.i.i348.i, label %dget2.merge.73.i

next_grp.i.i.i348.i:                              ; preds = %after_a.i.i.i341.i
  %step_next.i.i.i349.i = add i64 %step.i.i.i285.i, 16
  %padd.i.i.i350.i = add i64 %step_next.i.i.i349.i, %pos.i.i.i287.i
  br label %probe.i.i.i283.i

dget2.hit.69.i:                                   ; preds = %archx_str_eq.exit.i.i.i311.i, %cmp_long.i.i.i.i325.i, %cmp_short.i.i.i.i337.i
  %t230.i = load ptr, ptr %t142.i, align 8
  %t231.i = getelementptr inbounds nuw i64, ptr %t230.i, i64 %didx.i.i.i303.i
  %t232.i = load i64, ptr %t231.i, align 8
  br label %dget2.merge.73.i

dget2.merge.73.i:                                 ; preds = %after_a.i.i.i341.i, %dget2.hit.69.i, %archx_hash_str.exit.i.i264.i
  %t233.i = phi i64 [ %t232.i, %dget2.hit.69.i ], [ 0, %archx_hash_str.exit.i.i264.i ], [ 0, %after_a.i.i.i341.i ]
  %t234.i = add i64 %t233.i, %var.checksum.114.1885.i
  %tag.i134.i = and i64 %w1.i.i.i239.i, 1
  %owned.not.i135.i = icmp eq i64 %tag.i134.i, 0
  %or.cond792.i = select i1 %short.i.i.i241.i, i1 true, i1 %owned.not.i135.i
  br i1 %or.cond792.i, label %archx_str_drop.exit139.i, label %do_free.i136.i

do_free.i136.i:                                   ; preds = %dget2.merge.73.i
  %raw.i137.i = and i64 %w1.i.i.i239.i, -2
  %ptr.i138.i = inttoptr i64 %raw.i137.i to ptr
  call void @free(ptr %ptr.i138.i)
  br label %archx_str_drop.exit139.i

archx_str_drop.exit139.i:                         ; preds = %do_free.i136.i, %dget2.merge.73.i
  %t237.i = add nuw nsw i64 %for.p.205.0886.i, 1
  %exitcond937.not.i = icmp eq i64 %t237.i, 1024
  br i1 %exitcond937.not.i, label %l_done.i.i.i423.i, label %idx.ok.67.i

l_done.i.i.i423.i:                                ; preds = %archx_str_drop.exit139.i
  %ctrl.i.i.i439.i = load ptr, ptr %ctrl_p.i, align 8
  %c_null.i.i.i440.i = icmp eq ptr %ctrl.i.i.i439.i, null
  br i1 %c_null.i.i.i440.i, label %if.then.74.critedge.i, label %do_probe.i.i.i441.i

do_probe.i.i.i441.i:                              ; preds = %l_done.i.i.i423.i
  %mask.i.i.i444.i = load i64, ptr %mask_p.i.i, align 8
  %keys.i.i.i445.i = load ptr, ptr %keys_p.i.i, align 8
  %100 = getelementptr i8, ptr %ctrl.i.i.i439.i, i64 %mask.i.i.i444.i
  %idx_base.i.i.i446.i = getelementptr i8, ptr %100, i64 17
  br label %probe.i.i.i451.i

probe.i.i.i451.i:                                 ; preds = %next_grp.i.i.i511.i, %do_probe.i.i.i441.i
  %h.pn.i.i.i452.i = phi i64 [ 7840821588020221045, %do_probe.i.i.i441.i ], [ %padd.i.i.i513.i, %next_grp.i.i.i511.i ]
  %step.i.i.i453.i = phi i64 [ 0, %do_probe.i.i.i441.i ], [ %step_next.i.i.i512.i, %next_grp.i.i.i511.i ]
  %avail.i.i.i454.i = phi i64 [ -1, %do_probe.i.i.i441.i ], [ %avail_cur.i.i.i505.i, %next_grp.i.i.i511.i ]
  %pos.i.i.i455.i = and i64 %h.pn.i.i.i452.i, %mask.i.i.i444.i
  %gp.i.i.i456.i = getelementptr inbounds i8, ptr %ctrl.i.i.i439.i, i64 %pos.i.i.i455.i
  %grp.i.i.i457.i = load <16 x i8>, ptr %gp.i.i.i456.i, align 1
  %mcmp.i.i.i458.i = icmp eq <16 x i8> %grp.i.i.i457.i, splat (i8 54)
  %mbits.i.i.i459.i = bitcast <16 x i1> %mcmp.i.i.i458.i to i16
  %has_m.not.i.i.i463893.i = icmp eq i16 %mbits.i.i.i459.i, 0
  br i1 %has_m.not.i.i.i463893.i, label %chk_empty.i.i.i502.i, label %chk_key.i.i.i464.preheader.i

chk_key.i.i.i464.preheader.i:                     ; preds = %probe.i.i.i451.i
  %mmask0.i.i.i460.i = zext i16 %mbits.i.i.i459.i to i32
  br label %chk_key.i.i.i464.i

chk_key.i.i.i464.i:                               ; preds = %mbit_cont.i.i.i480.i, %chk_key.i.i.i464.preheader.i
  %mmask.i.i.i462894.i = phi i32 [ %mmask_next.i.i.i482.i, %mbit_cont.i.i.i480.i ], [ %mmask0.i.i.i460.i, %chk_key.i.i.i464.preheader.i ]
  %tz.i2.i.i465.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i462894.i, i1 true)
  %tz64.i.i.i466.i = zext nneg i32 %tz.i2.i.i465.i to i64
  %s_add.i.i.i467.i = add i64 %pos.i.i.i455.i, %tz64.i.i.i466.i
  %slot.i.i.i468.i = and i64 %s_add.i.i.i467.i, %mask.i.i.i444.i
  %ip.i.i.i469.i = getelementptr inbounds i32, ptr %idx_base.i.i.i446.i, i64 %slot.i.i.i468.i
  %didx32.i.i.i470.i = load i32, ptr %ip.i.i.i469.i, align 4
  %didx.i.i.i471.i = zext i32 %didx32.i.i.i470.i to i64
  %kp.i.i.i472.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i445.i, i64 %didx.i.i.i471.i
  %cand_k.unpack.i.i.i473.i = load i64, ptr %kp.i.i.i472.i, align 8
  %w0_eq.i.i.i.i477.i = icmp eq i64 %cand_k.unpack.i.i.i473.i, 7310294788903796754
  br i1 %w0_eq.i.i.i.i477.i, label %cmp_long.i.i.i.i491.i, label %mbit_cont.i.i.i480.i

cmp_long.i.i.i.i491.i:                            ; preds = %chk_key.i.i.i464.i
  %cand_k.elt1.i.i.i474.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i472.i, i64 8
  %cand_k.unpack2.i.i.i475.i = load i64, ptr %cand_k.elt1.i.i.i474.i, align 8
  %ap_i.i.i.i.i492.i = and i64 %cand_k.unpack2.i.i.i475.i, -4
  %same_ptr.i.i.i.i493.i = icmp eq i64 %ap_i.i.i.i.i492.i, ptrtoint (ptr @.str.2 to i64)
  br i1 %same_ptr.i.i.i.i493.i, label %if.merge.76.i, label %archx_str_eq.exit.i.i.i478.i

archx_str_eq.exit.i.i.i478.i:                     ; preds = %cmp_long.i.i.i.i491.i
  %ap.i.i.i.i495.i = inttoptr i64 %ap_i.i.i.i.i492.i to ptr
  %ap4.i.i.i.i496.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i495.i, i64 4
  %bcmp.i.i.i.i498.i = call i32 @bcmp(ptr noundef nonnull dereferenceable(14) %ap4.i.i.i.i496.i, ptr noundef nonnull dereferenceable(14) getelementptr inbounds nuw (i8, ptr @.str.2, i64 4), i64 14)
  %eq_m.i.i.i.i499.i = icmp eq i32 %bcmp.i.i.i.i498.i, 0
  br i1 %eq_m.i.i.i.i499.i, label %if.merge.76.i, label %mbit_cont.i.i.i480.i

mbit_cont.i.i.i480.i:                             ; preds = %archx_str_eq.exit.i.i.i478.i, %chk_key.i.i.i464.i
  %mm1.i.i.i481.i = add nsw i32 %mmask.i.i.i462894.i, -1
  %mmask_next.i.i.i482.i = and i32 %mm1.i.i.i481.i, %mmask.i.i.i462894.i
  %has_m.not.i.i.i463.i = icmp eq i32 %mmask_next.i.i.i482.i, 0
  br i1 %has_m.not.i.i.i463.i, label %chk_empty.i.i.i502.i, label %chk_key.i.i.i464.i

chk_empty.i.i.i502.i:                             ; preds = %mbit_cont.i.i.i480.i, %probe.i.i.i451.i
  %need_a.i.i.i503.i = icmp slt i64 %avail.i.i.i454.i, 0
  br i1 %need_a.i.i.i503.i, label %find_a.i.i.i514.i, label %after_a.i.i.i504.i

find_a.i.i.i514.i:                                ; preds = %chk_empty.i.i.i502.i
  %acmp.i.i.i515.i = icmp slt <16 x i8> %grp.i.i.i457.i, zeroinitializer
  %abits16.i.i.i516.i = bitcast <16 x i1> %acmp.i.i.i515.i to i16
  %has_a0.not.i.i.i517.i = icmp eq i16 %abits16.i.i.i516.i, 0
  br i1 %has_a0.not.i.i.i517.i, label %after_a.i.i.i504.i, label %set_a.i.i.i518.i

set_a.i.i.i518.i:                                 ; preds = %find_a.i.i.i514.i
  %101 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i516.i, i1 true)
  %atz64.i.i.i519.i = zext nneg i16 %101 to i64
  %as_add.i.i.i520.i = add i64 %pos.i.i.i455.i, %atz64.i.i.i519.i
  %aslot.i.i.i521.i = and i64 %as_add.i.i.i520.i, %mask.i.i.i444.i
  br label %after_a.i.i.i504.i

after_a.i.i.i504.i:                               ; preds = %set_a.i.i.i518.i, %find_a.i.i.i514.i, %chk_empty.i.i.i502.i
  %avail_cur.i.i.i505.i = phi i64 [ %avail.i.i.i454.i, %chk_empty.i.i.i502.i ], [ -1, %find_a.i.i.i514.i ], [ %aslot.i.i.i521.i, %set_a.i.i.i518.i ]
  %ecmp.i.i.i506.i = icmp eq <16 x i8> %grp.i.i.i457.i, splat (i8 -128)
  %ebits.i.i.i507.i = bitcast <16 x i1> %ecmp.i.i.i506.i to i16
  %has_e.not.i.i.i508.i = icmp eq i16 %ebits.i.i.i507.i, 0
  br i1 %has_e.not.i.i.i508.i, label %next_grp.i.i.i511.i, label %if.then.74.critedge.i

next_grp.i.i.i511.i:                              ; preds = %after_a.i.i.i504.i
  %step_next.i.i.i512.i = add i64 %step.i.i.i453.i, 16
  %padd.i.i.i513.i = add i64 %step_next.i.i.i512.i, %pos.i.i.i455.i
  br label %probe.i.i.i451.i

if.then.74.critedge.i:                            ; preds = %after_a.i.i.i504.i, %l_done.i.i.i423.i
  br i1 %is_z.i.i.i, label %dlen.done.79.i, label %dlen.load.78.i

dlen.load.78.i:                                   ; preds = %if.then.74.critedge.i
  %t246.i = load i64, ptr %hdr.i.i, align 8
  br label %dlen.done.79.i

dlen.done.79.i:                                   ; preds = %dlen.load.78.i, %if.then.74.critedge.i
  %t247.i = phi i64 [ %t246.i, %dlen.load.78.i ], [ 0, %if.then.74.critedge.i ]
  %t248.i = add i64 %t247.i, %t234.i
  br label %if.merge.76.i

if.merge.76.i:                                    ; preds = %archx_str_eq.exit.i.i.i478.i, %cmp_long.i.i.i.i491.i, %dlen.done.79.i
  %var.checksum.114.2.i = phi i64 [ %t248.i, %dlen.done.79.i ], [ %t234.i, %cmp_long.i.i.i.i491.i ], [ %t234.i, %archx_str_eq.exit.i.i.i478.i ]
  %t253.i = load i64, ptr %t141.i, align 8
  %t257895.i = icmp sgt i64 %t253.i, 0
  br i1 %t257895.i, label %foritems.body.84.lr.ph.i, label %archx_dict_drop_s_i.exit.i

foritems.body.84.lr.ph.i:                         ; preds = %if.merge.76.i
  %t263.i = load ptr, ptr %t142.i, align 8
  %min.iters.check1849 = icmp ult i64 %t253.i, 4
  br i1 %min.iters.check1849, label %foritems.body.84.i.preheader, label %vector.ph1850

vector.ph1850:                                    ; preds = %foritems.body.84.lr.ph.i
  %n.vec1852 = and i64 %t253.i, 9223372036854775804
  %102 = insertelement <2 x i64> <i64 poison, i64 0>, i64 %var.checksum.114.2.i, i64 0
  br label %vector.body1853

vector.body1853:                                  ; preds = %vector.body1853, %vector.ph1850
  %index1854 = phi i64 [ 0, %vector.ph1850 ], [ %index.next1858, %vector.body1853 ]
  %vec.phi = phi <2 x i64> [ %102, %vector.ph1850 ], [ %105, %vector.body1853 ]
  %vec.phi1855 = phi <2 x i64> [ zeroinitializer, %vector.ph1850 ], [ %106, %vector.body1853 ]
  %103 = getelementptr inbounds nuw i64, ptr %t263.i, i64 %index1854
  %104 = getelementptr inbounds nuw i8, ptr %103, i64 16
  %wide.load1856 = load <2 x i64>, ptr %103, align 8
  %wide.load1857 = load <2 x i64>, ptr %104, align 8
  %105 = add <2 x i64> %wide.load1856, %vec.phi
  %106 = add <2 x i64> %wide.load1857, %vec.phi1855
  %index.next1858 = add nuw i64 %index1854, 4
  %107 = icmp eq i64 %index.next1858, %n.vec1852
  br i1 %107, label %middle.block1859, label %vector.body1853, !llvm.loop !11

middle.block1859:                                 ; preds = %vector.body1853
  %bin.rdx = add <2 x i64> %106, %105
  %108 = call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx)
  %cmp.n1860 = icmp eq i64 %t253.i, %n.vec1852
  br i1 %cmp.n1860, label %body.i.i, label %foritems.body.84.i.preheader

foritems.body.84.i.preheader:                     ; preds = %foritems.body.84.lr.ph.i, %middle.block1859
  %foritems.idx.255.0897.i.ph = phi i64 [ 0, %foritems.body.84.lr.ph.i ], [ %n.vec1852, %middle.block1859 ]
  %var.checksum.114.3896.i.ph = phi i64 [ %var.checksum.114.2.i, %foritems.body.84.lr.ph.i ], [ %108, %middle.block1859 ]
  br label %foritems.body.84.i

foritems.body.84.i:                               ; preds = %foritems.body.84.i.preheader, %foritems.body.84.i
  %foritems.idx.255.0897.i = phi i64 [ %t271.i, %foritems.body.84.i ], [ %foritems.idx.255.0897.i.ph, %foritems.body.84.i.preheader ]
  %var.checksum.114.3896.i = phi i64 [ %t269.i, %foritems.body.84.i ], [ %var.checksum.114.3896.i.ph, %foritems.body.84.i.preheader ]
  %t266.i = getelementptr inbounds nuw i64, ptr %t263.i, i64 %foritems.idx.255.0897.i
  %t267.i = load i64, ptr %t266.i, align 8
  %t269.i = add i64 %t267.i, %var.checksum.114.3896.i
  %t271.i = add nuw nsw i64 %foritems.idx.255.0897.i, 1
  %exitcond938.not.i = icmp eq i64 %t271.i, %t253.i
  br i1 %exitcond938.not.i, label %body.i.i, label %foritems.body.84.i, !llvm.loop !12

body.i.i:                                         ; preds = %foritems.body.84.i, %middle.block1859
  %t269.i.lcssa = phi i64 [ %108, %middle.block1859 ], [ %t269.i, %foritems.body.84.i ]
  %keys.i714.i = load ptr, ptr %keys_p.i.i, align 8
  br label %d_elem.i.i

d_elem.i.i:                                       ; preds = %body.i.i, %archx_str_drop.exit.i.i
  %storemerge5.i.i = phi i64 [ %inext.i717.i, %archx_str_drop.exit.i.i ], [ 0, %body.i.i ]
  %t0.i.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i714.i, i64 %storemerge5.i.i
  %t1.unpack.i.i = load i64, ptr %t0.i.i, align 8
  %t1.elt1.i.i = getelementptr inbounds nuw i8, ptr %t0.i.i, i64 8
  %t1.unpack2.i.i = load i64, ptr %t1.elt1.i.i, align 8
  %len.i.i.i = and i64 %t1.unpack.i.i, 4294967295
  %long.i.i.i = icmp samesign ult i64 %len.i.i.i, 13
  %tag.i.i.i = and i64 %t1.unpack2.i.i, 1
  %owned.not.i.i.i = icmp eq i64 %tag.i.i.i, 0
  %or.cond.i.i = select i1 %long.i.i.i, i1 true, i1 %owned.not.i.i.i
  br i1 %or.cond.i.i, label %archx_str_drop.exit.i.i, label %do_free.i.i.i

do_free.i.i.i:                                    ; preds = %d_elem.i.i
  %raw.i.i.i = and i64 %t1.unpack2.i.i, -2
  %ptr.i.i.i = inttoptr i64 %raw.i.i.i to ptr
  call void @free(ptr %ptr.i.i.i)
  br label %archx_str_drop.exit.i.i

archx_str_drop.exit.i.i:                          ; preds = %do_free.i.i.i, %d_elem.i.i
  %inext.i717.i = add nuw nsw i64 %storemerge5.i.i, 1
  %exitcond.not.i718.i = icmp eq i64 %inext.i717.i, %t253.i
  br i1 %exitcond.not.i718.i, label %archx_dict_drop_s_i.exit.i, label %d_elem.i.i

archx_dict_drop_s_i.exit.i:                       ; preds = %archx_str_drop.exit.i.i, %if.merge.76.i
  %var.checksum.114.3.lcssa964.i = phi i64 [ %var.checksum.114.2.i, %if.merge.76.i ], [ %t269.i.lcssa, %archx_str_drop.exit.i.i ]
  %head.i.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i.i = icmp eq ptr %head.i.i, null
  br i1 %empty.i.i, label %archx_region_rewind_root.exit.i, label %rewind.i.i

rewind.i.i:                                       ; preds = %archx_dict_drop_s_i.exit.i
  %cap_ptr.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 8
  %cap.i.i = load i64, ptr %cap_ptr.i.i, align 8
  %data.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 16
  %end.i.i = getelementptr inbounds i8, ptr %data.i.i, i64 %cap.i.i
  store ptr %data.i.i, ptr %func.region.i, align 8
  store ptr %end.i.i, ptr %.fca.1.gep.i, align 8
  store ptr %head.i.i, ptr %.fca.3.gep.i, align 8
  br label %archx_region_rewind_root.exit.i

archx_region_rewind_root.exit.i:                  ; preds = %rewind.i.i, %archx_dict_drop_s_i.exit.i
  %t275.i = add nuw nsw i64 %for.r.118.0899.i, 1
  %exitcond939.not.i = icmp eq i64 %t275.i, 60
  br i1 %exitcond939.not.i, label %vslice.body.96.preheader.i, label %for.body.40.i

vslice.body.96.preheader.i:                       ; preds = %archx_region_rewind_root.exit.i
  %dst.i740.i = call noalias align 16 dereferenceable_or_null(20) ptr @malloc(i64 20)
  %isnull.i741.i = icmp eq ptr %dst.i740.i, null
  br i1 %isnull.i741.i, label %oom.i748.i, label %loop.i753.preheader.i

oom.i748.i:                                       ; preds = %vslice.body.96.preheader.i
  call fastcc void @archx_oom_fail()
  unreachable

loop.i753.preheader.i:                            ; preds = %vslice.body.96.preheader.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(20) %dst.i740.i, ptr noundef nonnull align 16 dereferenceable(20) %hp.i.i645.i, i64 20, i1 false)
  call void @free(ptr %hp.i.i645.i)
  br label %loop.i753.i

loop.i753.i:                                      ; preds = %archx_str_drop.exit.i763.i, %loop.i753.preheader.i
  %i.i754.i = phi i64 [ %inext.i764.i, %archx_str_drop.exit.i763.i ], [ 0, %loop.i753.preheader.i ]
  %ep.i.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.3.i, i64 %i.i754.i
  %t0.unpack.i.i = load i64, ptr %ep.i.i, align 8
  %t0.elt1.i.i = getelementptr inbounds nuw i8, ptr %ep.i.i, i64 8
  %t0.unpack2.i.i = load i64, ptr %t0.elt1.i.i, align 8
  %len.i.i755.i = and i64 %t0.unpack.i.i, 4294967295
  %long.i.i756.i = icmp samesign ult i64 %len.i.i755.i, 13
  %tag.i.i757.i = and i64 %t0.unpack2.i.i, 1
  %owned.not.i.i758.i = icmp eq i64 %tag.i.i757.i, 0
  %or.cond.i759.i = select i1 %long.i.i756.i, i1 true, i1 %owned.not.i.i758.i
  br i1 %or.cond.i759.i, label %archx_str_drop.exit.i763.i, label %do_free.i.i760.i

do_free.i.i760.i:                                 ; preds = %loop.i753.i
  %raw.i.i761.i = and i64 %t0.unpack2.i.i, -2
  %ptr.i.i762.i = inttoptr i64 %raw.i.i761.i to ptr
  call void @free(ptr %ptr.i.i762.i)
  br label %archx_str_drop.exit.i763.i

archx_str_drop.exit.i763.i:                       ; preds = %do_free.i.i760.i, %loop.i753.i
  %inext.i764.i = add nuw nsw i64 %i.i754.i, 1
  %exitcond.not.i765.i = icmp eq i64 %i.i754.i, 511
  br i1 %exitcond.not.i765.i, label %check.free.i.i, label %loop.i753.i

check.free.i.i:                                   ; preds = %archx_str_drop.exit.i763.i
  %is_heap.i.i = icmp sgt i64 %var.vocab.4.sroa.17.3.i, 0
  br i1 %is_heap.i.i, label %do.free.i.i, label %archx_vec_drop_s.exit.i

do.free.i.i:                                      ; preds = %check.free.i.i
  call void @free(ptr nonnull %var.vocab.4.sroa.34.3.i)
  br label %archx_vec_drop_s.exit.i

archx_vec_drop_s.exit.i:                          ; preds = %do.free.i.i, %check.free.i.i
  %t350.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i766.i = icmp eq ptr %t350.i, null
  br i1 %empty.i766.i, label %archx_fn_dict_and_slicing_tour.exit, label %loop.i767.i

loop.i767.i:                                      ; preds = %archx_vec_drop_s.exit.i, %loop.i767.i
  %cur.i.i = phi ptr [ %next.i.i, %loop.i767.i ], [ %t350.i, %archx_vec_drop_s.exit.i ]
  %next.i.i = load ptr, ptr %cur.i.i, align 8
  call void @free(ptr nonnull %cur.i.i)
  %more.not.i.i = icmp eq ptr %next.i.i, null
  br i1 %more.not.i.i, label %archx_fn_dict_and_slicing_tour.exit, label %loop.i767.i

archx_fn_dict_and_slicing_tour.exit:              ; preds = %loop.i767.i, %archx_vec_drop_s.exit.i
  %t341.i = add i64 %var.checksum.114.3.lcssa964.i, 225
  %pref64.i.i650.i = zext i32 %pref32.i.i649.i to i64
  %pref_sh.i.i651.i = shl nuw i64 %pref64.i.i650.i, 32
  %w0_out.i.i652.i = or disjoint i64 %pref_sh.i.i651.i, 20
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  %t7 = call noalias align 16 dereferenceable_or_null(512) ptr @calloc(i64 64, i64 8)
  %t8 = icmp eq ptr %t7, null
  br i1 %t8, label %calloc.oom.1, label %vector.body1864

vector.body1864:                                  ; preds = %archx_fn_dict_and_slicing_tour.exit, %vector.body1864
  %index1865 = phi i64 [ %index.next1867, %vector.body1864 ], [ 0, %archx_fn_dict_and_slicing_tour.exit ]
  %vec.ind1866 = phi <2 x i16> [ %vec.ind.next1868, %vector.body1864 ], [ <i16 0, i16 1>, %archx_fn_dict_and_slicing_tour.exit ]
  %109 = getelementptr inbounds nuw i64, ptr %t7, i64 %index1865
  %110 = mul nuw nsw <2 x i16> %vec.ind1866, splat (i16 37)
  %111 = mul <2 x i16> %vec.ind1866, splat (i16 37)
  %112 = add nuw nsw <2 x i16> %110, splat (i16 11)
  %113 = add <2 x i16> %111, splat (i16 85)
  %114 = urem <2 x i16> %112, splat (i16 97)
  %115 = urem <2 x i16> %113, splat (i16 97)
  %116 = add nuw nsw <2 x i16> %114, splat (i16 8)
  %117 = add nuw nsw <2 x i16> %115, splat (i16 8)
  %118 = zext nneg <2 x i16> %116 to <2 x i64>
  %119 = zext nneg <2 x i16> %117 to <2 x i64>
  %120 = getelementptr inbounds nuw i8, ptr %109, i64 16
  store <2 x i64> %118, ptr %109, align 16
  store <2 x i64> %119, ptr %120, align 16
  %index.next1867 = add nuw i64 %index1865, 4
  %vec.ind.next1868 = add <2 x i16> %vec.ind1866, splat (i16 4)
  %121 = icmp eq i64 %index.next1867, 64
  br i1 %121, label %for.end.5, label %vector.body1864, !llvm.loop !13

calloc.oom.1:                                     ; preds = %archx_fn_dict_and_slicing_tour.exit
  call fastcc void @archx_oom_fail()
  unreachable

for.end.5:                                        ; preds = %vector.body1864
  %t4.i1071 = load i64, ptr %t7, align 16
  %invariant.gep1935 = getelementptr inbounds i8, ptr %t7, i64 8
  br label %foreach.body.5.i

foreach.body.5.i:                                 ; preds = %foreach.body.5.i, %for.end.5
  %foreach.idx.15.09.i = phi i64 [ 0, %for.end.5 ], [ %t27.i1075.1, %foreach.body.5.i ]
  %var.total.12.08.i = phi i64 [ 0, %for.end.5 ], [ %t25.i1074.1, %foreach.body.5.i ]
  %var.hi.11.07.i = phi i64 [ %t4.i1071, %for.end.5 ], [ %spec.store.select1.i.1, %foreach.body.5.i ]
  %var.lo.5.06.i = phi i64 [ %t4.i1071, %for.end.5 ], [ %spec.store.select.i.1, %foreach.body.5.i ]
  %t18.i1072 = getelementptr inbounds nuw i64, ptr %t7, i64 %foreach.idx.15.09.i
  %t19.i1073 = load i64, ptr %t18.i1072, align 16
  %spec.store.select.i = call i64 @llvm.smin.i64(i64 %t19.i1073, i64 %var.lo.5.06.i)
  %spec.store.select1.i = call i64 @llvm.smax.i64(i64 %t19.i1073, i64 %var.hi.11.07.i)
  %t25.i1074 = add i64 %t19.i1073, %var.total.12.08.i
  %gep1936 = getelementptr inbounds i64, ptr %invariant.gep1935, i64 %foreach.idx.15.09.i
  %t19.i1073.1 = load i64, ptr %gep1936, align 8
  %spec.store.select.i.1 = call i64 @llvm.smin.i64(i64 %t19.i1073.1, i64 %spec.store.select.i)
  %spec.store.select1.i.1 = call i64 @llvm.smax.i64(i64 %t19.i1073.1, i64 %spec.store.select1.i)
  %t25.i1074.1 = add i64 %t19.i1073.1, %t25.i1074
  %t27.i1075.1 = add nuw nsw i64 %foreach.idx.15.09.i, 2
  %exitcond.not.i1076.1 = icmp eq i64 %t27.i1075.1, 64
  br i1 %exitcond.not.i1076.1, label %enum.body.1.i, label %foreach.body.5.i

enum.body.1.i:                                    ; preds = %foreach.body.5.i, %enum.step.2.i.3
  %enum.pos.2.03.i = phi i64 [ %t13.i.3, %enum.step.2.i.3 ], [ 0, %foreach.body.5.i ]
  %t5.i = getelementptr inbounds nuw i64, ptr %t7, i64 %enum.pos.2.03.i
  %t6.i = load i64, ptr %t5.i, align 16
  %t7.not.i = icmp slt i64 %t6.i, 95
  br i1 %t7.not.i, label %enum.step.2.i, label %if.then.4.i1080

if.then.4.i1080:                                  ; preds = %enum.step.2.i.2, %enum.step.2.i.1, %enum.step.2.i, %enum.body.1.i
  %enum.pos.2.03.i.lcssa = phi i64 [ %enum.pos.2.03.i, %enum.body.1.i ], [ %t13.i, %enum.step.2.i ], [ %t13.i.1, %enum.step.2.i.1 ], [ %t13.i.2, %enum.step.2.i.2 ]
  %t6.i.lcssa = phi i64 [ %t6.i, %enum.body.1.i ], [ %t6.i.1, %enum.step.2.i ], [ %t6.i.2, %enum.step.2.i.1 ], [ %t6.i.3, %enum.step.2.i.2 ]
  %t8.i1081 = mul nuw nsw i64 %enum.pos.2.03.i.lcssa, 1000
  %t9.i1082 = add nuw i64 %t6.i.lcssa, %t8.i1081
  %t11.i1083 = insertvalue { i1, i64 } { i1 true, i64 undef }, i64 %t9.i1082, 1
  br label %archx_fn_find_spike.exit

enum.step.2.i:                                    ; preds = %enum.body.1.i
  %t13.i = or disjoint i64 %enum.pos.2.03.i, 1
  %t5.i.1 = getelementptr inbounds nuw i64, ptr %t7, i64 %t13.i
  %t6.i.1 = load i64, ptr %t5.i.1, align 8
  %t7.not.i.1 = icmp slt i64 %t6.i.1, 95
  br i1 %t7.not.i.1, label %enum.step.2.i.1, label %if.then.4.i1080

enum.step.2.i.1:                                  ; preds = %enum.step.2.i
  %t13.i.1 = or disjoint i64 %enum.pos.2.03.i, 2
  %t5.i.2 = getelementptr inbounds nuw i64, ptr %t7, i64 %t13.i.1
  %t6.i.2 = load i64, ptr %t5.i.2, align 16
  %t7.not.i.2 = icmp slt i64 %t6.i.2, 95
  br i1 %t7.not.i.2, label %enum.step.2.i.2, label %if.then.4.i1080

enum.step.2.i.2:                                  ; preds = %enum.step.2.i.1
  %t13.i.2 = or disjoint i64 %enum.pos.2.03.i, 3
  %t5.i.3 = getelementptr inbounds nuw i64, ptr %t7, i64 %t13.i.2
  %t6.i.3 = load i64, ptr %t5.i.3, align 8
  %t7.not.i.3 = icmp slt i64 %t6.i.3, 95
  br i1 %t7.not.i.3, label %enum.step.2.i.3, label %if.then.4.i1080

enum.step.2.i.3:                                  ; preds = %enum.step.2.i.2
  %t13.i.3 = add nuw nsw i64 %enum.pos.2.03.i, 4
  %exitcond.not.i1085.3 = icmp eq i64 %t13.i.3, 64
  br i1 %exitcond.not.i1085.3, label %archx_fn_find_spike.exit, label %enum.body.1.i

archx_fn_find_spike.exit:                         ; preds = %enum.step.2.i.3, %if.then.4.i1080
  %common.ret.op.i1084 = phi { i1, i64 } [ %t11.i1083, %if.then.4.i1080 ], [ zeroinitializer, %enum.step.2.i.3 ]
  br label %enum.body.1.i1086

enum.body.1.i1086:                                ; preds = %enum.step.2.i1096.3, %archx_fn_find_spike.exit
  %enum.pos.2.03.i1087 = phi i64 [ 0, %archx_fn_find_spike.exit ], [ %t13.i1097.3, %enum.step.2.i1096.3 ]
  %t5.i1088 = getelementptr inbounds nuw i64, ptr %t7, i64 %enum.pos.2.03.i1087
  %t6.i1089 = load i64, ptr %t5.i1088, align 16
  %t7.not.i1090 = icmp slt i64 %t6.i1089, 999
  br i1 %t7.not.i1090, label %enum.step.2.i1096, label %if.then.4.i1091

if.then.4.i1091:                                  ; preds = %enum.step.2.i1096.2, %enum.step.2.i1096.1, %enum.step.2.i1096, %enum.body.1.i1086
  %enum.pos.2.03.i1087.lcssa = phi i64 [ %enum.pos.2.03.i1087, %enum.body.1.i1086 ], [ %t13.i1097, %enum.step.2.i1096 ], [ %t13.i1097.1, %enum.step.2.i1096.1 ], [ %t13.i1097.2, %enum.step.2.i1096.2 ]
  %t6.i1089.lcssa = phi i64 [ %t6.i1089, %enum.body.1.i1086 ], [ %t6.i1089.1, %enum.step.2.i1096 ], [ %t6.i1089.2, %enum.step.2.i1096.1 ], [ %t6.i1089.3, %enum.step.2.i1096.2 ]
  %t8.i1092 = mul nuw nsw i64 %enum.pos.2.03.i1087.lcssa, 1000
  %t9.i1093 = add nuw i64 %t6.i1089.lcssa, %t8.i1092
  %t11.i1094 = insertvalue { i1, i64 } { i1 true, i64 undef }, i64 %t9.i1093, 1
  br label %archx_fn_find_spike.exit1099

enum.step.2.i1096:                                ; preds = %enum.body.1.i1086
  %t13.i1097 = or disjoint i64 %enum.pos.2.03.i1087, 1
  %t5.i1088.1 = getelementptr inbounds nuw i64, ptr %t7, i64 %t13.i1097
  %t6.i1089.1 = load i64, ptr %t5.i1088.1, align 8
  %t7.not.i1090.1 = icmp slt i64 %t6.i1089.1, 999
  br i1 %t7.not.i1090.1, label %enum.step.2.i1096.1, label %if.then.4.i1091

enum.step.2.i1096.1:                              ; preds = %enum.step.2.i1096
  %t13.i1097.1 = or disjoint i64 %enum.pos.2.03.i1087, 2
  %t5.i1088.2 = getelementptr inbounds nuw i64, ptr %t7, i64 %t13.i1097.1
  %t6.i1089.2 = load i64, ptr %t5.i1088.2, align 16
  %t7.not.i1090.2 = icmp slt i64 %t6.i1089.2, 999
  br i1 %t7.not.i1090.2, label %enum.step.2.i1096.2, label %if.then.4.i1091

enum.step.2.i1096.2:                              ; preds = %enum.step.2.i1096.1
  %t13.i1097.2 = or disjoint i64 %enum.pos.2.03.i1087, 3
  %t5.i1088.3 = getelementptr inbounds nuw i64, ptr %t7, i64 %t13.i1097.2
  %t6.i1089.3 = load i64, ptr %t5.i1088.3, align 8
  %t7.not.i1090.3 = icmp slt i64 %t6.i1089.3, 999
  br i1 %t7.not.i1090.3, label %enum.step.2.i1096.3, label %if.then.4.i1091

enum.step.2.i1096.3:                              ; preds = %enum.step.2.i1096.2
  %t13.i1097.3 = add nuw nsw i64 %enum.pos.2.03.i1087, 4
  %exitcond.not.i1098.3 = icmp eq i64 %t13.i1097.3, 64
  br i1 %exitcond.not.i1098.3, label %archx_fn_find_spike.exit1099, label %enum.body.1.i1086

archx_fn_find_spike.exit1099:                     ; preds = %enum.step.2.i1096.3, %if.then.4.i1091
  %common.ret.op.i1095 = phi { i1, i64 } [ %t11.i1094, %if.then.4.i1091 ], [ zeroinitializer, %enum.step.2.i1096.3 ]
  %t32 = extractvalue { i1, i64 } %common.ret.op.i1084, 0
  %t33 = extractvalue { i1, i64 } %common.ret.op.i1084, 1
  %t34 = add i64 %t33, 1
  %ifexpr.res.35.0 = select i1 %t32, i64 %t34, i64 -1
  %t31.fca.0.extract = extractvalue { i1, i64 } %common.ret.op.i1095, 0
  br i1 %t31.fca.0.extract, label %pat.opt.some.12, label %match.end.9

pat.opt.some.12:                                  ; preds = %archx_fn_find_spike.exit1099
  %t31.fca.1.extract = extractvalue { i1, i64 } %common.ret.op.i1095, 1
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i)
  %n32.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t31.fca.1.extract)
  %len.i1100 = sext i32 %n32.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i)
  %z.i.i1101 = icmp slt i32 %n32.i, 1
  br i1 %z.i.i1101, label %archx_str_from_int.exit, label %chk_sso.i.i

oom.i.i1113:                                      ; preds = %alloc_heap.i.i1103
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i:                                      ; preds = %pat.opt.some.12
  %short.i.i1102 = icmp samesign ult i32 %n32.i, 13
  br i1 %short.i.i1102, label %pack_sso.i.i, label %alloc_heap.i.i1103

pack_sso.i.i:                                     ; preds = %chk_sso.i.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i, i8 0, i64 16, i1 false)
  store i32 %n32.i, ptr %sso.i.i, align 8
  %sso.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i, i64 %len.i1100, i1 false)
  %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i = load i64, ptr %sso.i.i, align 8
  %sso.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 8
  %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i = load i64, ptr %sso.i.i.8.sroa_idx, align 8
  %ss0.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i, 0
  %ss1.i.i = insertvalue %ArchxStr %ss0.i.i, i64 %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i, 1
  br label %archx_str_from_int.exit

alloc_heap.i.i1103:                               ; preds = %chk_sso.i.i
  %hp.i.i1104 = call noalias align 16 ptr @malloc(i64 %len.i1100)
  %hnull.i.i1105 = icmp eq ptr %hp.i.i1104, null
  br i1 %hnull.i.i1105, label %oom.i.i1113, label %copy_long.i.i1106

copy_long.i.i1106:                                ; preds = %alloc_heap.i.i1103
  %hp_i.i.i1107 = ptrtoint ptr %hp.i.i1104 to i64
  %htagged.i.i1108 = or disjoint i64 %hp_i.i.i1107, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1104, ptr nonnull readonly align 8 %buf.i, i64 %len.i1100, i1 false)
  %pref32.i.i = load i32, ptr %hp.i.i1104, align 16
  %pref64.i.i = zext i32 %pref32.i.i to i64
  %pref_sh.i.i = shl nuw i64 %pref64.i.i, 32
  %w0_out.i.i1109 = or disjoint i64 %pref_sh.i.i, %len.i1100
  %ls0.i.i1110 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1109, 0
  %ls1.i.i1111 = insertvalue %ArchxStr %ls0.i.i1110, i64 %htagged.i.i1108, 1
  br label %archx_str_from_int.exit

archx_str_from_int.exit:                          ; preds = %pat.opt.some.12, %pack_sso.i.i, %copy_long.i.i1106
  %common.ret.op.i.i1112 = phi %ArchxStr [ %ss1.i.i, %pack_sso.i.i ], [ %ls1.i.i1111, %copy_long.i.i1106 ], [ zeroinitializer, %pat.opt.some.12 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  %bw0.i = extractvalue %ArchxStr %common.ret.op.i.i1112, 0
  %bw1.i = extractvalue %ArchxStr %common.ret.op.i.i1112, 1
  %blen.i = and i64 %bw0.i, 4294967295
  %bz.i = icmp eq i64 %blen.i, 0
  br i1 %bz.i, label %archx_str_concat.exit.thread, label %calc_tot.i

archx_str_concat.exit.thread:                     ; preds = %archx_str_from_int.exit
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  br label %match.end.9

calc_tot.i:                                       ; preds = %archx_str_from_int.exit
  %tot.i = add nuw nsw i64 %blen.i, 4
  %too_big.i = icmp samesign ugt i64 %blen.i, 2147483643
  br i1 %too_big.i, label %oom.i, label %mat_a.i

oom.i:                                            ; preds = %alloc_heap.i, %calc_tot.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i:                                          ; preds = %calc_tot.i
  %bshort.i = icmp samesign ult i64 %blen.i, 13
  br i1 %bshort.i, label %build.i, label %build.i.thread

build.i.thread:                                   ; preds = %mat_a.i
  %braw.i = and i64 %bw1.i, -4
  %blptr.i = inttoptr i64 %braw.i to ptr
  br label %alloc_heap.i

build.i:                                          ; preds = %mat_a.i
  %bp4.i = lshr i64 %bw0.i, 32
  %bp4_32.i = trunc nuw i64 %bp4.i to i32
  store i32 %bp4_32.i, ptr %btmp.i, align 4
  %btmp4.i = getelementptr inbounds nuw i8, ptr %btmp.i, i64 4
  store i64 %bw1.i, ptr %btmp4.i, align 4
  %fits_sso.i = icmp samesign ult i64 %blen.i, 9
  br i1 %fits_sso.i, label %archx_str_concat.exit.thread1776, label %alloc_heap.i

archx_str_concat.exit.thread1776:                 ; preds = %build.i
  store i64 0, ptr %out_sso.i.sroa.6, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i.sroa.6, ptr nonnull align 4 %btmp.i, i64 %blen.i, i1 false)
  %out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.8.rw1.i = load i64, ptr %out_sso.i.sroa.6, align 8
  %out_sso.i.sroa.0.4.insert.insert.pn1778 = or disjoint i64 %tot.i, 6875977890521939968
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  br label %match.end.9

alloc_heap.i:                                     ; preds = %build.i.thread, %build.i
  %bptr.i1775 = phi ptr [ %blptr.i, %build.i.thread ], [ %btmp.i, %build.i ]
  %hp.i = call noalias align 16 ptr @malloc(i64 %tot.i)
  %hnull.i = icmp eq ptr %hp.i, null
  br i1 %hnull.i, label %oom.i, label %archx_str_concat.exit

archx_str_concat.exit:                            ; preds = %alloc_heap.i
  %hp_i.i = ptrtoint ptr %hp.i to i64
  %htagged.i = or disjoint i64 %hp_i.i, 1
  store i32 1600938358, ptr %hp.i, align 16
  %dst_b.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %dst_b.i, ptr nonnull align 1 %bptr.i1775, i64 %blen.i, i1 false)
  %out_sso.i.sroa.0.4.insert.insert.pn = or disjoint i64 %tot.i, 6875977890521939968
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  %tag.i = and i64 %bw1.i, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %bshort.i, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %match.end.9, label %do_free.i

do_free.i:                                        ; preds = %archx_str_concat.exit
  %raw.i = and i64 %bw1.i, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  call void @free(ptr %ptr.i)
  br label %match.end.9

match.end.9:                                      ; preds = %archx_str_concat.exit.thread1776, %do_free.i, %archx_str_concat.exit, %archx_str_concat.exit.thread, %archx_fn_find_spike.exit1099
  %var.miss_label.40.sroa.0.0 = phi i64 [ 8390326386350358533, %archx_fn_find_spike.exit1099 ], [ 6875977890521939972, %archx_str_concat.exit.thread ], [ %out_sso.i.sroa.0.4.insert.insert.pn, %archx_str_concat.exit ], [ %out_sso.i.sroa.0.4.insert.insert.pn, %do_free.i ], [ %out_sso.i.sroa.0.4.insert.insert.pn1778, %archx_str_concat.exit.thread1776 ]
  %var.miss_label.40.sroa.7.0 = phi i64 [ 121, %archx_fn_find_spike.exit1099 ], [ 0, %archx_str_concat.exit.thread ], [ %htagged.i, %archx_str_concat.exit ], [ %htagged.i, %do_free.i ], [ %out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.8.rw1.i, %archx_str_concat.exit.thread1776 ]
  br label %for.body.1.i1115

for.body.1.i1115:                                 ; preds = %for.step.2.i1120, %match.end.9
  %var.acc.0.029.i = phi i64 [ 0, %match.end.9 ], [ %var.acc.0.1.i, %for.step.2.i1120 ]
  %for.i.1.028.i = phi i64 [ 0, %match.end.9 ], [ %t79.i1121, %for.step.2.i1120 ]
  %t5.lhs.trunc.i = trunc nuw nsw i64 %for.i.1.028.i to i32
  %t525.i = urem i32 %t5.lhs.trunc.i, 5
  %122 = mul nuw nsw i32 %t5.lhs.trunc.i, 17
  %t9.lhs.trunc.i = add nuw nsw i32 %122, 3
  %t926.i = urem i32 %t9.lhs.trunc.i, 40
  %t9.zext.i = zext nneg i32 %t926.i to i64
  switch i32 %t525.i, label %archx_fn_make_event.exit.i [
    i32 0, label %pat.int.ok.2.i.i
    i32 1, label %pat.int.ok.4.i.i
    i32 2, label %pat.int.ok.6.i.i
    i32 3, label %pat.int.ok.8.i.i
  ]

pat.int.ok.2.i.i:                                 ; preds = %for.body.1.i1115
  %t5.fca.1.0.insert.i.i = insertvalue %ArchxEnum_Event { i64 0, [2 x i64] poison }, i64 %t9.zext.i, 1, 0
  %t5.fca.1.1.insert.i.i = insertvalue %ArchxEnum_Event %t5.fca.1.0.insert.i.i, i64 0, 1, 1
  br label %archx_fn_make_event.exit.i

pat.int.ok.4.i.i:                                 ; preds = %for.body.1.i1115
  %123 = mul nuw nsw i32 %t5.lhs.trunc.i, 13
  %t13.lhs.trunc.i = add nuw nsw i32 %123, 7
  %t1327.i = urem i32 %t13.lhs.trunc.i, 25
  %t13.zext.i = zext nneg i32 %t1327.i to i64
  %t11.fca.1.0.insert.i.i = insertvalue %ArchxEnum_Event { i64 1, [2 x i64] poison }, i64 %t9.zext.i, 1, 0
  %t11.fca.1.1.insert.i.i = insertvalue %ArchxEnum_Event %t11.fca.1.0.insert.i.i, i64 %t13.zext.i, 1, 1
  br label %archx_fn_make_event.exit.i

pat.int.ok.6.i.i:                                 ; preds = %for.body.1.i1115
  %t16.fca.1.0.insert.i.i = insertvalue %ArchxEnum_Event { i64 2, [2 x i64] poison }, i64 %t9.zext.i, 1, 0
  %t16.fca.1.1.insert.i.i = insertvalue %ArchxEnum_Event %t16.fca.1.0.insert.i.i, i64 0, 1, 1
  br label %archx_fn_make_event.exit.i

pat.int.ok.8.i.i:                                 ; preds = %for.body.1.i1115
  %t21.fca.1.0.insert.i.i = insertvalue %ArchxEnum_Event { i64 3, [2 x i64] poison }, i64 %t9.zext.i, 1, 0
  %t21.fca.1.1.insert.i.i = insertvalue %ArchxEnum_Event %t21.fca.1.0.insert.i.i, i64 0, 1, 1
  br label %archx_fn_make_event.exit.i

archx_fn_make_event.exit.i:                       ; preds = %pat.int.ok.8.i.i, %pat.int.ok.6.i.i, %pat.int.ok.4.i.i, %pat.int.ok.2.i.i, %for.body.1.i1115
  %common.ret.op.i.i1116 = phi %ArchxEnum_Event [ %t5.fca.1.1.insert.i.i, %pat.int.ok.2.i.i ], [ %t11.fca.1.1.insert.i.i, %pat.int.ok.4.i.i ], [ %t16.fca.1.1.insert.i.i, %pat.int.ok.6.i.i ], [ %t21.fca.1.1.insert.i.i, %pat.int.ok.8.i.i ], [ { i64 4, [2 x i64] zeroinitializer }, %for.body.1.i1115 ]
  %t14.fca.0.extract.i = extractvalue %ArchxEnum_Event %common.ret.op.i.i1116, 0
  %t14.fca.1.0.extract.i = extractvalue %ArchxEnum_Event %common.ret.op.i.i1116, 1, 0
  %t14.fca.1.1.extract.i = extractvalue %ArchxEnum_Event %common.ret.op.i.i1116, 1, 1
  %t18.i1117 = icmp eq i64 %t14.fca.0.extract.i, 0
  %t24.i1118 = icmp sgt i64 %t14.fca.1.0.extract.i, 20
  %or.cond.i1119 = select i1 %t18.i1117, i1 %t24.i1118, i1 false
  br i1 %or.cond.i1119, label %match.body.7.i, label %match.next.5.i

match.body.7.i:                                   ; preds = %archx_fn_make_event.exit.i
  %t26.i1131 = mul i64 %t14.fca.1.0.extract.i, %t14.fca.1.0.extract.i
  %t27.i1132 = add i64 %var.acc.0.029.i, 7
  %t28.i1133 = add i64 %t27.i1132, %t26.i1131
  br label %for.step.2.i1120

match.next.5.i:                                   ; preds = %archx_fn_make_event.exit.i
  br i1 %t18.i1117, label %pat.enum.ok.10.i, label %match.next.9.i

pat.enum.ok.10.i:                                 ; preds = %match.next.5.i
  %t38.i1128 = mul i64 %t14.fca.1.0.extract.i, 3
  %t39.i1129 = add i64 %var.acc.0.029.i, 1
  %t40.i1130 = add i64 %t39.i1129, %t38.i1128
  br label %for.step.2.i1120

match.next.9.i:                                   ; preds = %match.next.5.i
  switch i64 %t14.fca.0.extract.i, label %for.step.2.i1120 [
    i64 1, label %pat.enum.ok.12.i
    i64 2, label %pat.or.ok.14.i
    i64 3, label %pat.or.ok.14.i
    i64 4, label %pat.enum.ok.18.i
  ]

pat.enum.ok.12.i:                                 ; preds = %match.next.9.i
  %t54.i = mul i64 %t14.fca.1.0.extract.i, %t14.fca.1.1.extract.i
  %t55.i1127 = add i64 %t54.i, %var.acc.0.029.i
  br label %for.step.2.i1120

pat.or.ok.14.i:                                   ; preds = %match.next.9.i, %match.next.9.i
  %t70.i1124 = shl i64 %t14.fca.1.0.extract.i, 2
  %t71.i1125 = add i64 %var.acc.0.029.i, 2
  %t72.i1126 = add i64 %t71.i1125, %t70.i1124
  br label %for.step.2.i1120

pat.enum.ok.18.i:                                 ; preds = %match.next.9.i
  %t77.i = add i64 %var.acc.0.029.i, 1
  br label %for.step.2.i1120

for.step.2.i1120:                                 ; preds = %pat.enum.ok.18.i, %pat.or.ok.14.i, %pat.enum.ok.12.i, %match.next.9.i, %pat.enum.ok.10.i, %match.body.7.i
  %var.acc.0.1.i = phi i64 [ %t28.i1133, %match.body.7.i ], [ %t40.i1130, %pat.enum.ok.10.i ], [ %t55.i1127, %pat.enum.ok.12.i ], [ %t72.i1126, %pat.or.ok.14.i ], [ %t77.i, %pat.enum.ok.18.i ], [ %var.acc.0.029.i, %match.next.9.i ]
  %t79.i1121 = add nuw nsw i64 %for.i.1.028.i, 1
  %exitcond.not.i1122 = icmp eq i64 %t79.i1121, 200000
  br i1 %exitcond.not.i1122, label %archx_fn_dispatch_events.exit, label %for.body.1.i1115

archx_fn_dispatch_events.exit:                    ; preds = %for.step.2.i1120
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1135)
  %n32.i1136 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1135, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t120.i)
  %len.i1137 = sext i32 %n32.i1136 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1134)
  %z.i.i1138 = icmp slt i32 %n32.i1136, 1
  br i1 %z.i.i1138, label %archx_str_from_int.exit1162, label %chk_sso.i.i1139

oom.i.i1154:                                      ; preds = %alloc_heap.i.i1141
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1139:                                  ; preds = %archx_fn_dispatch_events.exit
  %short.i.i1140 = icmp samesign ult i32 %n32.i1136, 13
  br i1 %short.i.i1140, label %pack_sso.i.i1155, label %alloc_heap.i.i1141

pack_sso.i.i1155:                                 ; preds = %chk_sso.i.i1139
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1134, i8 0, i64 16, i1 false)
  store i32 %n32.i1136, ptr %sso.i.i1134, align 8
  %sso.i.i1134.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1134, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1134.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1135, i64 %len.i1137, i1 false)
  %sso.i.i1134.0.sso.i.i1134.0.sso.i.i1134.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1157 = load i64, ptr %sso.i.i1134, align 8
  %sso.i.i1134.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1134, i64 8
  %sso.i.i1134.8.sso.i.i1134.8.sso.i.i1134.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1159 = load i64, ptr %sso.i.i1134.8.sroa_idx, align 8
  %ss0.i.i1160 = insertvalue %ArchxStr poison, i64 %sso.i.i1134.0.sso.i.i1134.0.sso.i.i1134.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1157, 0
  %ss1.i.i1161 = insertvalue %ArchxStr %ss0.i.i1160, i64 %sso.i.i1134.8.sso.i.i1134.8.sso.i.i1134.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1159, 1
  br label %archx_str_from_int.exit1162

alloc_heap.i.i1141:                               ; preds = %chk_sso.i.i1139
  %hp.i.i1142 = call noalias align 16 ptr @malloc(i64 %len.i1137)
  %hnull.i.i1143 = icmp eq ptr %hp.i.i1142, null
  br i1 %hnull.i.i1143, label %oom.i.i1154, label %copy_long.i.i1144

copy_long.i.i1144:                                ; preds = %alloc_heap.i.i1141
  %hp_i.i.i1145 = ptrtoint ptr %hp.i.i1142 to i64
  %htagged.i.i1146 = or disjoint i64 %hp_i.i.i1145, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1142, ptr nonnull readonly align 8 %buf.i1135, i64 %len.i1137, i1 false)
  %pref32.i.i1147 = load i32, ptr %hp.i.i1142, align 16
  %pref64.i.i1148 = zext i32 %pref32.i.i1147 to i64
  %pref_sh.i.i1149 = shl nuw i64 %pref64.i.i1148, 32
  %w0_out.i.i1150 = or disjoint i64 %pref_sh.i.i1149, %len.i1137
  %ls0.i.i1151 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1150, 0
  %ls1.i.i1152 = insertvalue %ArchxStr %ls0.i.i1151, i64 %htagged.i.i1146, 1
  br label %archx_str_from_int.exit1162

archx_str_from_int.exit1162:                      ; preds = %archx_fn_dispatch_events.exit, %pack_sso.i.i1155, %copy_long.i.i1144
  %common.ret.op.i.i1153 = phi %ArchxStr [ %ss1.i.i1161, %pack_sso.i.i1155 ], [ %ls1.i.i1152, %copy_long.i.i1144 ], [ zeroinitializer, %archx_fn_dispatch_events.exit ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1134)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1135)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i272)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i273.sroa.6)
  %bw0.i274 = extractvalue %ArchxStr %common.ret.op.i.i1153, 0
  %bw1.i275 = extractvalue %ArchxStr %common.ret.op.i.i1153, 1
  %blen.i276 = and i64 %bw0.i274, 4294967295
  %bz.i277 = icmp eq i64 %blen.i276, 0
  br i1 %bz.i277, label %archx_str_concat.exit320, label %calc_tot.i278

calc_tot.i278:                                    ; preds = %archx_str_from_int.exit1162
  %tot.i279 = add nuw nsw i64 %blen.i276, 4
  %too_big.i280 = icmp samesign ugt i64 %blen.i276, 2147483643
  br i1 %too_big.i280, label %oom.i304, label %mat_a.i281

oom.i304:                                         ; preds = %alloc_heap.i290, %calc_tot.i278
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i281:                                       ; preds = %calc_tot.i278
  %bshort.i283 = icmp samesign ult i64 %blen.i276, 13
  br i1 %bshort.i283, label %build.i287, label %build.i287.thread

build.i287.thread:                                ; preds = %mat_a.i281
  %braw.i285 = and i64 %bw1.i275, -4
  %blptr.i286 = inttoptr i64 %braw.i285 to ptr
  br label %alloc_heap.i290

build.i287:                                       ; preds = %mat_a.i281
  %bp4.i315 = lshr i64 %bw0.i274, 32
  %bp4_32.i316 = trunc nuw i64 %bp4.i315 to i32
  store i32 %bp4_32.i316, ptr %btmp.i272, align 4
  %btmp4.i317 = getelementptr inbounds nuw i8, ptr %btmp.i272, i64 4
  store i64 %bw1.i275, ptr %btmp4.i317, align 4
  %fits_sso.i289 = icmp samesign ult i64 %blen.i276, 9
  br i1 %fits_sso.i289, label %build_sso.i305, label %alloc_heap.i290

build_sso.i305:                                   ; preds = %build.i287
  store i64 0, ptr %out_sso.i273.sroa.6, align 8
  %out_sso.i273.sroa.0.4.insert.insert = or disjoint i64 %tot.i279, 4426309951417221120
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i273.sroa.6, ptr nonnull align 4 %btmp.i272, i64 %blen.i276, i1 false)
  %out_sso.i273.sroa.6.0.out_sso.i273.sroa.6.0.out_sso.i273.sroa.6.0.out_sso.i273.sroa.6.8.rw1.i311 = load i64, ptr %out_sso.i273.sroa.6, align 8
  %rs0.i312 = insertvalue %ArchxStr poison, i64 %out_sso.i273.sroa.0.4.insert.insert, 0
  %rs1.i313 = insertvalue %ArchxStr %rs0.i312, i64 %out_sso.i273.sroa.6.0.out_sso.i273.sroa.6.0.out_sso.i273.sroa.6.0.out_sso.i273.sroa.6.8.rw1.i311, 1
  br label %archx_str_concat.exit320

alloc_heap.i290:                                  ; preds = %build.i287.thread, %build.i287
  %bptr.i2881784 = phi ptr [ %blptr.i286, %build.i287.thread ], [ %btmp.i272, %build.i287 ]
  %hp.i291 = call noalias align 16 ptr @malloc(i64 %tot.i279)
  %hnull.i292 = icmp eq ptr %hp.i291, null
  br i1 %hnull.i292, label %oom.i304, label %copy_long.i293

copy_long.i293:                                   ; preds = %alloc_heap.i290
  %hp_i.i294 = ptrtoint ptr %hp.i291 to i64
  %htagged.i295 = or disjoint i64 %hp_i.i294, 1
  store i32 1030580595, ptr %hp.i291, align 16
  %dst_b.i296 = getelementptr inbounds nuw i8, ptr %hp.i291, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %dst_b.i296, ptr nonnull align 1 %bptr.i2881784, i64 %blen.i276, i1 false)
  %w0_out.i300 = or disjoint i64 %tot.i279, 4426309951417221120
  %ls0.i301 = insertvalue %ArchxStr poison, i64 %w0_out.i300, 0
  %ls1.i302 = insertvalue %ArchxStr %ls0.i301, i64 %htagged.i295, 1
  br label %archx_str_concat.exit320

archx_str_concat.exit320:                         ; preds = %archx_str_from_int.exit1162, %build_sso.i305, %copy_long.i293
  %common.ret.op.i303 = phi %ArchxStr [ %rs1.i313, %build_sso.i305 ], [ %ls1.i302, %copy_long.i293 ], [ { i64 4426309951417221124, i64 0 }, %archx_str_from_int.exit1162 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i272)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i273.sroa.6)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  %w0.i1164 = extractvalue %ArchxStr %common.ret.op.i303, 0
  %w1.i1165 = extractvalue %ArchxStr %common.ret.op.i303, 1
  %len.i1166 = and i64 %w0.i1164, 4294967295
  %short.i = icmp samesign ult i64 %len.i1166, 13
  br i1 %short.i, label %emit.i, label %emit.thread.i

emit.thread.i:                                    ; preds = %archx_str_concat.exit320
  %raw.i1167 = and i64 %w1.i1165, -4
  %lptr.i = inttoptr i64 %raw.i1167 to ptr
  br label %chk_nul.i

emit.i:                                           ; preds = %archx_str_concat.exit320
  %p4.i = lshr i64 %w0.i1164, 32
  %p4_32.i = trunc nuw i64 %p4.i to i32
  store i32 %p4_32.i, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 %w1.i1165, ptr %tmp4.i, align 4
  %pos.not.i = icmp eq i64 %len.i1166, 0
  br i1 %pos.not.i, label %do_nl.i, label %chk_nul.i

chk_nul.i:                                        ; preds = %emit.i, %emit.thread.i
  %data3.i = phi ptr [ %lptr.i, %emit.thread.i ], [ %tmp.i, %emit.i ]
  %nul.i = call ptr @memchr(ptr nonnull %data3.i, i32 0, i64 %len.i1166)
  %has_nul.not.i = icmp eq ptr %nul.i, null
  br i1 %has_nul.not.i, label %fast_printf.i, label %byte_loop.i

fast_printf.i:                                    ; preds = %chk_nul.i
  %len32.i = trunc i64 %w0.i1164 to i32
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i, ptr nonnull %data3.i)
  br label %archx_str_print.exit

byte_loop.i:                                      ; preds = %chk_nul.i, %byte_loop.i
  %bi.i = phi i64 [ %bnext.i, %byte_loop.i ], [ 0, %chk_nul.i ]
  %bp.i = getelementptr inbounds nuw i8, ptr %data3.i, i64 %bi.i
  %ch8.i = load i8, ptr %bp.i, align 1
  %ch32.i = zext i8 %ch8.i to i32
  %pc.i = call i32 @putchar(i32 %ch32.i)
  %bnext.i = add nuw nsw i64 %bi.i, 1
  %exitcond.not.i1168 = icmp eq i64 %bnext.i, %len.i1166
  br i1 %exitcond.not.i1168, label %do_nl.i, label %byte_loop.i

do_nl.i:                                          ; preds = %byte_loop.i, %emit.i
  %nc.i = call i32 @putchar(i32 10)
  br label %archx_str_print.exit

archx_str_print.exit:                             ; preds = %fast_printf.i, %do_nl.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %tag.i23 = and i64 %w1.i1165, 1
  %owned.not.i24 = icmp eq i64 %tag.i23, 0
  %or.cond1688 = select i1 %short.i, i1 true, i1 %owned.not.i24
  br i1 %or.cond1688, label %archx_str_drop.exit28, label %do_free.i25

do_free.i25:                                      ; preds = %archx_str_print.exit
  %raw.i26 = and i64 %w1.i1165, -2
  %ptr.i27 = inttoptr i64 %raw.i26 to ptr
  call void @free(ptr %ptr.i27)
  br label %archx_str_drop.exit28

archx_str_drop.exit28:                            ; preds = %archx_str_print.exit, %do_free.i25
  %long.i31 = icmp samesign ult i64 %blen.i276, 13
  %tag.i34 = and i64 %bw1.i275, 1
  %owned.not.i35 = icmp eq i64 %tag.i34, 0
  %or.cond1689 = select i1 %long.i31, i1 true, i1 %owned.not.i35
  br i1 %or.cond1689, label %archx_str_drop.exit39, label %do_free.i36

do_free.i36:                                      ; preds = %archx_str_drop.exit28
  %raw.i37 = and i64 %bw1.i275, -2
  %ptr.i38 = inttoptr i64 %raw.i37 to ptr
  call void @free(ptr %ptr.i38)
  br label %archx_str_drop.exit39

archx_str_drop.exit39:                            ; preds = %archx_str_drop.exit28, %do_free.i36
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1170)
  %n32.i1171 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1170, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t341.i)
  %len.i1172 = sext i32 %n32.i1171 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1169)
  %z.i.i1173 = icmp slt i32 %n32.i1171, 1
  br i1 %z.i.i1173, label %archx_str_from_int.exit1197, label %chk_sso.i.i1174

oom.i.i1189:                                      ; preds = %alloc_heap.i.i1176
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1174:                                  ; preds = %archx_str_drop.exit39
  %short.i.i1175 = icmp samesign ult i32 %n32.i1171, 13
  br i1 %short.i.i1175, label %pack_sso.i.i1190, label %alloc_heap.i.i1176

pack_sso.i.i1190:                                 ; preds = %chk_sso.i.i1174
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1169, i8 0, i64 16, i1 false)
  store i32 %n32.i1171, ptr %sso.i.i1169, align 8
  %sso.i.i1169.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1169, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1169.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1170, i64 %len.i1172, i1 false)
  %sso.i.i1169.0.sso.i.i1169.0.sso.i.i1169.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1192 = load i64, ptr %sso.i.i1169, align 8
  %sso.i.i1169.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1169, i64 8
  %sso.i.i1169.8.sso.i.i1169.8.sso.i.i1169.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1194 = load i64, ptr %sso.i.i1169.8.sroa_idx, align 8
  %ss0.i.i1195 = insertvalue %ArchxStr poison, i64 %sso.i.i1169.0.sso.i.i1169.0.sso.i.i1169.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1192, 0
  %ss1.i.i1196 = insertvalue %ArchxStr %ss0.i.i1195, i64 %sso.i.i1169.8.sso.i.i1169.8.sso.i.i1169.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1194, 1
  br label %archx_str_from_int.exit1197

alloc_heap.i.i1176:                               ; preds = %chk_sso.i.i1174
  %hp.i.i1177 = call noalias align 16 ptr @malloc(i64 %len.i1172)
  %hnull.i.i1178 = icmp eq ptr %hp.i.i1177, null
  br i1 %hnull.i.i1178, label %oom.i.i1189, label %copy_long.i.i1179

copy_long.i.i1179:                                ; preds = %alloc_heap.i.i1176
  %hp_i.i.i1180 = ptrtoint ptr %hp.i.i1177 to i64
  %htagged.i.i1181 = or disjoint i64 %hp_i.i.i1180, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1177, ptr nonnull readonly align 8 %buf.i1170, i64 %len.i1172, i1 false)
  %pref32.i.i1182 = load i32, ptr %hp.i.i1177, align 16
  %pref64.i.i1183 = zext i32 %pref32.i.i1182 to i64
  %pref_sh.i.i1184 = shl nuw i64 %pref64.i.i1183, 32
  %w0_out.i.i1185 = or disjoint i64 %pref_sh.i.i1184, %len.i1172
  %ls0.i.i1186 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1185, 0
  %ls1.i.i1187 = insertvalue %ArchxStr %ls0.i.i1186, i64 %htagged.i.i1181, 1
  br label %archx_str_from_int.exit1197

archx_str_from_int.exit1197:                      ; preds = %archx_str_drop.exit39, %pack_sso.i.i1190, %copy_long.i.i1179
  %common.ret.op.i.i1188 = phi %ArchxStr [ %ss1.i.i1196, %pack_sso.i.i1190 ], [ %ls1.i.i1187, %copy_long.i.i1179 ], [ zeroinitializer, %archx_str_drop.exit39 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1169)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1170)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i322)
  %bw0.i324 = extractvalue %ArchxStr %common.ret.op.i.i1188, 0
  %bw1.i325 = extractvalue %ArchxStr %common.ret.op.i.i1188, 1
  %blen.i326 = and i64 %bw0.i324, 4294967295
  %bz.i327 = icmp eq i64 %blen.i326, 0
  br i1 %bz.i327, label %archx_str_concat.exit370, label %calc_tot.i328

calc_tot.i328:                                    ; preds = %archx_str_from_int.exit1197
  %tot.i329 = add nuw nsw i64 %blen.i326, 11
  %too_big.i330 = icmp samesign ugt i64 %blen.i326, 2147483636
  br i1 %too_big.i330, label %oom.i354, label %mat_a.i331

oom.i354:                                         ; preds = %alloc_heap.i340, %calc_tot.i328
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i331:                                       ; preds = %calc_tot.i328
  %bshort.i333 = icmp samesign ult i64 %blen.i326, 13
  br i1 %bshort.i333, label %build.i337, label %build.i337.thread

build.i337.thread:                                ; preds = %mat_a.i331
  %braw.i335 = and i64 %bw1.i325, -4
  %blptr.i336 = inttoptr i64 %braw.i335 to ptr
  br label %alloc_heap.i340

build.i337:                                       ; preds = %mat_a.i331
  %bp4.i365 = lshr i64 %bw0.i324, 32
  %bp4_32.i366 = trunc nuw i64 %bp4.i365 to i32
  store i32 %bp4_32.i366, ptr %btmp.i322, align 4
  %btmp4.i367 = getelementptr inbounds nuw i8, ptr %btmp.i322, i64 4
  store i64 %bw1.i325, ptr %btmp4.i367, align 4
  %fits_sso.i339 = icmp eq i64 %blen.i326, 1
  br i1 %fits_sso.i339, label %build_sso.i355, label %alloc_heap.i340

build_sso.i355:                                   ; preds = %build.i337
  %124 = load i8, ptr %btmp.i322, align 4
  %out_sso.i323.sroa.6.sroa.5.0.insert.ext = zext i8 %124 to i64
  %out_sso.i323.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i323.sroa.6.sroa.5.0.insert.ext, 56
  %out_sso.i323.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i323.sroa.6.sroa.5.0.insert.shift, 17281451224232799
  %rs1.i363 = insertvalue %ArchxStr { i64 8386662809311641612, i64 poison }, i64 %out_sso.i323.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit370

alloc_heap.i340:                                  ; preds = %build.i337.thread, %build.i337
  %bptr.i3381787 = phi ptr [ %blptr.i336, %build.i337.thread ], [ %btmp.i322, %build.i337 ]
  %hp.i341 = call noalias align 16 ptr @malloc(i64 %tot.i329)
  %hnull.i342 = icmp eq ptr %hp.i341, null
  br i1 %hnull.i342, label %oom.i354, label %copy_long.i343

copy_long.i343:                                   ; preds = %alloc_heap.i340
  %hp_i.i344 = ptrtoint ptr %hp.i341 to i64
  %htagged.i345 = or disjoint i64 %hp_i.i344, 1
  store i32 1952672100, ptr %hp.i341, align 16
  %atmp.i321.sroa.5.0.hp.i341.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i341, i64 4
  store i56 17281451224232799, ptr %atmp.i321.sroa.5.0.hp.i341.sroa_idx, align 4
  %dst_b.i346 = getelementptr inbounds nuw i8, ptr %hp.i341, i64 11
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i346, ptr nonnull align 1 %bptr.i3381787, i64 %blen.i326, i1 false)
  %w0_out.i350 = or disjoint i64 %tot.i329, 8386662809311641600
  %ls0.i351 = insertvalue %ArchxStr poison, i64 %w0_out.i350, 0
  %ls1.i352 = insertvalue %ArchxStr %ls0.i351, i64 %htagged.i345, 1
  br label %archx_str_concat.exit370

archx_str_concat.exit370:                         ; preds = %archx_str_from_int.exit1197, %build_sso.i355, %copy_long.i343
  %common.ret.op.i353 = phi %ArchxStr [ %rs1.i363, %build_sso.i355 ], [ %ls1.i352, %copy_long.i343 ], [ { i64 8386662809311641611, i64 17281451224232799 }, %archx_str_from_int.exit1197 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i322)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i371)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i373)
  %aw0.i = extractvalue %ArchxStr %common.ret.op.i353, 0
  %aw1.i = extractvalue %ArchxStr %common.ret.op.i353, 1
  %alen.i = and i64 %aw0.i, 4294967295
  %az.i = icmp eq i64 %alen.i, 0
  br i1 %az.i, label %archx_str_concat.exit408, label %chk_bz.i

chk_bz.i:                                         ; preds = %archx_str_concat.exit370
  %tot.i375 = add nuw nsw i64 %alen.i, 1
  %too_big.i376 = icmp samesign ugt i64 %alen.i, 2147483646
  br i1 %too_big.i376, label %oom.i397, label %mat_a.i377

oom.i397:                                         ; preds = %alloc_heap.i383, %chk_bz.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i377:                                       ; preds = %chk_bz.i
  %ashort.i = icmp samesign ult i64 %alen.i, 13
  br i1 %ashort.i, label %mat_b.i, label %mat_b.i.thread

mat_b.i.thread:                                   ; preds = %mat_a.i377
  %araw.i = and i64 %aw1.i, -4
  %alptr.i = inttoptr i64 %araw.i to ptr
  br label %alloc_heap.i383

mat_b.i:                                          ; preds = %mat_a.i377
  %ap4.i = lshr i64 %aw0.i, 32
  %ap4_32.i = trunc nuw i64 %ap4.i to i32
  store i32 %ap4_32.i, ptr %atmp.i371, align 4
  %atmp4.i407 = getelementptr inbounds nuw i8, ptr %atmp.i371, i64 4
  store i64 %aw1.i, ptr %atmp4.i407, align 4
  %fits_sso.i382.not = icmp eq i64 %alen.i, 12
  br i1 %fits_sso.i382.not, label %alloc_heap.i383, label %build_sso.i398

build_sso.i398:                                   ; preds = %mat_b.i
  %out_sso8.i399 = getelementptr inbounds nuw i8, ptr %out_sso.i373, i64 8
  %tot32.i400 = trunc nuw nsw i64 %tot.i375 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i373, i8 0, i64 16, i1 false)
  store i32 %tot32.i400, ptr %out_sso.i373, align 8
  %sso_dst_a.i401 = getelementptr inbounds nuw i8, ptr %out_sso.i373, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i401, ptr nonnull align 4 %atmp.i371, i64 %alen.i, i1 false)
  %sso_dst_b.i402 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i401, i64 %alen.i
  store i8 44, ptr %sso_dst_b.i402, align 1
  %rw0.i403 = load i64, ptr %out_sso.i373, align 8
  %rw1.i404 = load i64, ptr %out_sso8.i399, align 8
  %rs0.i405 = insertvalue %ArchxStr poison, i64 %rw0.i403, 0
  %rs1.i406 = insertvalue %ArchxStr %rs0.i405, i64 %rw1.i404, 1
  br label %archx_str_concat.exit408

alloc_heap.i383:                                  ; preds = %mat_b.i.thread, %mat_b.i
  %aptr.i1674 = phi ptr [ %alptr.i, %mat_b.i.thread ], [ %atmp.i371, %mat_b.i ]
  %hp.i384 = call noalias align 16 ptr @malloc(i64 %tot.i375)
  %hnull.i385 = icmp eq ptr %hp.i384, null
  br i1 %hnull.i385, label %oom.i397, label %copy_long.i386

copy_long.i386:                                   ; preds = %alloc_heap.i383
  %hp_i.i387 = ptrtoint ptr %hp.i384 to i64
  %htagged.i388 = or disjoint i64 %hp_i.i387, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i384, ptr nonnull align 1 %aptr.i1674, i64 %alen.i, i1 false)
  %dst_b.i389 = getelementptr inbounds nuw i8, ptr %hp.i384, i64 %alen.i
  store i8 44, ptr %dst_b.i389, align 1
  %pref32.i390 = load i32, ptr %hp.i384, align 16
  %pref64.i391 = zext i32 %pref32.i390 to i64
  %pref_sh.i392 = shl nuw i64 %pref64.i391, 32
  %w0_out.i393 = or disjoint i64 %pref_sh.i392, %tot.i375
  %ls0.i394 = insertvalue %ArchxStr poison, i64 %w0_out.i393, 0
  %ls1.i395 = insertvalue %ArchxStr %ls0.i394, i64 %htagged.i388, 1
  br label %archx_str_concat.exit408

archx_str_concat.exit408:                         ; preds = %archx_str_concat.exit370, %build_sso.i398, %copy_long.i386
  %common.ret.op.i396 = phi %ArchxStr [ %rs1.i406, %build_sso.i398 ], [ %ls1.i395, %copy_long.i386 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit370 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i371)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i373)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i409)
  %aw0.i412 = extractvalue %ArchxStr %common.ret.op.i396, 0
  %aw1.i413 = extractvalue %ArchxStr %common.ret.op.i396, 1
  %alen.i416 = and i64 %aw0.i412, 4294967295
  %az.i418 = icmp eq i64 %alen.i416, 0
  br i1 %az.i418, label %dup_heap.i, label %calc_tot.i421

dup_heap.i:                                       ; preds = %archx_str_concat.exit408
  %dst.i = call noalias align 16 dereferenceable_or_null(20) ptr @malloc(i64 20)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i1208, label %archx_str_clone.exit

oom.i1208:                                        ; preds = %dup_heap.i
  call fastcc void @archx_oom_fail()
  unreachable

archx_str_clone.exit:                             ; preds = %dup_heap.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(20) %dst.i, ptr noundef nonnull align 16 dereferenceable(20) %dst.i740.i, i64 20, i1 false)
  br label %archx_str_concat.exit474

calc_tot.i421:                                    ; preds = %archx_str_concat.exit408
  %tot.i422 = add nuw nsw i64 %alen.i416, 20
  %too_big.i423 = icmp samesign ugt i64 %alen.i416, 2147483627
  br i1 %too_big.i423, label %oom.i452, label %mat_a.i424

oom.i452:                                         ; preds = %alloc_heap.i438, %calc_tot.i421
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i424:                                       ; preds = %calc_tot.i421
  %ashort.i425 = icmp samesign ult i64 %alen.i416, 13
  br i1 %ashort.i425, label %mat_a_short.i466, label %mat_a_long.i426

mat_a_short.i466:                                 ; preds = %mat_a.i424
  %ap4.i467 = lshr i64 %aw0.i412, 32
  %ap4_32.i468 = trunc nuw i64 %ap4.i467 to i32
  store i32 %ap4_32.i468, ptr %atmp.i409, align 4
  %atmp4.i469 = getelementptr inbounds nuw i8, ptr %atmp.i409, i64 4
  store i64 %aw1.i413, ptr %atmp4.i469, align 4
  br label %alloc_heap.i438

mat_a_long.i426:                                  ; preds = %mat_a.i424
  %araw.i427 = and i64 %aw1.i413, -4
  %alptr.i428 = inttoptr i64 %araw.i427 to ptr
  br label %alloc_heap.i438

alloc_heap.i438:                                  ; preds = %mat_a_short.i466, %mat_a_long.i426
  %aptr.i430 = phi ptr [ %atmp.i409, %mat_a_short.i466 ], [ %alptr.i428, %mat_a_long.i426 ]
  %hp.i439 = call noalias align 16 ptr @malloc(i64 %tot.i422)
  %hnull.i440 = icmp eq ptr %hp.i439, null
  br i1 %hnull.i440, label %oom.i452, label %copy_long.i441

copy_long.i441:                                   ; preds = %alloc_heap.i438
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i439, ptr nonnull align 1 %aptr.i430, i64 %alen.i416, i1 false)
  %dst_b.i444 = getelementptr inbounds nuw i8, ptr %hp.i439, i64 %alen.i416
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(20) %dst_b.i444, ptr noundef nonnull align 16 dereferenceable(20) %dst.i740.i, i64 20, i1 false)
  %pref32.i445 = load i32, ptr %hp.i439, align 16
  %pref64.i446 = zext i32 %pref32.i445 to i64
  %pref_sh.i447 = shl nuw i64 %pref64.i446, 32
  %w0_out.i448 = or disjoint i64 %pref_sh.i447, %tot.i422
  br label %archx_str_concat.exit474

archx_str_concat.exit474:                         ; preds = %archx_str_clone.exit, %copy_long.i441
  %w0_out.i.i652.i.pn = phi i64 [ %w0_out.i.i652.i, %archx_str_clone.exit ], [ %w0_out.i448, %copy_long.i441 ]
  %tagged.i.pn.in.in = phi ptr [ %dst.i, %archx_str_clone.exit ], [ %hp.i439, %copy_long.i441 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i409)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1228)
  %len.i1231 = and i64 %w0_out.i.i652.i.pn, 4294967295
  %short.i1232 = icmp samesign ult i64 %len.i1231, 13
  br i1 %short.i1232, label %emit.i1253, label %chk_nul.i1236

emit.i1253:                                       ; preds = %archx_str_concat.exit474
  %tagged.i.pn.in = ptrtoint ptr %tagged.i.pn.in.in to i64
  %tagged.i.pn = or disjoint i64 %tagged.i.pn.in, 1
  %p4.i1254 = lshr i64 %w0_out.i.i652.i.pn, 32
  %p4_32.i1255 = trunc nuw i64 %p4.i1254 to i32
  store i32 %p4_32.i1255, ptr %tmp.i1228, align 4
  %tmp4.i1256 = getelementptr inbounds nuw i8, ptr %tmp.i1228, i64 4
  store i64 %tagged.i.pn, ptr %tmp4.i1256, align 4
  %pos.not.i1257 = icmp eq i64 %len.i1231, 0
  br i1 %pos.not.i1257, label %do_nl.i1248, label %chk_nul.i1236

chk_nul.i1236:                                    ; preds = %archx_str_concat.exit474, %emit.i1253
  %data3.i1237 = phi ptr [ %tmp.i1228, %emit.i1253 ], [ %tagged.i.pn.in.in, %archx_str_concat.exit474 ]
  %nul.i1238 = call ptr @memchr(ptr nonnull %data3.i1237, i32 0, i64 %len.i1231)
  %has_nul.not.i1239 = icmp eq ptr %nul.i1238, null
  br i1 %has_nul.not.i1239, label %fast_printf.i1250, label %byte_loop.i1240

fast_printf.i1250:                                ; preds = %chk_nul.i1236
  %len32.i1251 = trunc i64 %w0_out.i.i652.i.pn to i32
  %np.i1252 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1251, ptr nonnull %data3.i1237)
  br label %archx_str_print.exit1258

byte_loop.i1240:                                  ; preds = %chk_nul.i1236, %byte_loop.i1240
  %bi.i1241 = phi i64 [ %bnext.i1246, %byte_loop.i1240 ], [ 0, %chk_nul.i1236 ]
  %bp.i1242 = getelementptr inbounds nuw i8, ptr %data3.i1237, i64 %bi.i1241
  %ch8.i1243 = load i8, ptr %bp.i1242, align 1
  %ch32.i1244 = zext i8 %ch8.i1243 to i32
  %pc.i1245 = call i32 @putchar(i32 %ch32.i1244)
  %bnext.i1246 = add nuw nsw i64 %bi.i1241, 1
  %exitcond.not.i1247 = icmp eq i64 %bnext.i1246, %len.i1231
  br i1 %exitcond.not.i1247, label %do_nl.i1248, label %byte_loop.i1240

do_nl.i1248:                                      ; preds = %byte_loop.i1240, %emit.i1253
  %nc.i1249 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1258

archx_str_print.exit1258:                         ; preds = %fast_printf.i1250, %do_nl.i1248
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1228)
  br i1 %short.i1232, label %archx_str_drop.exit50, label %do_free.i47

do_free.i47:                                      ; preds = %archx_str_print.exit1258
  call void @free(ptr nonnull %tagged.i.pn.in.in)
  br label %archx_str_drop.exit50

archx_str_drop.exit50:                            ; preds = %archx_str_print.exit1258, %do_free.i47
  %long.i53 = icmp samesign ult i64 %alen.i416, 13
  %tag.i56 = and i64 %aw1.i413, 1
  %owned.not.i57 = icmp eq i64 %tag.i56, 0
  %or.cond1691 = select i1 %long.i53, i1 true, i1 %owned.not.i57
  br i1 %or.cond1691, label %archx_str_drop.exit61, label %do_free.i58

do_free.i58:                                      ; preds = %archx_str_drop.exit50
  %raw.i59 = and i64 %aw1.i413, -2
  %ptr.i60 = inttoptr i64 %raw.i59 to ptr
  call void @free(ptr %ptr.i60)
  br label %archx_str_drop.exit61

archx_str_drop.exit61:                            ; preds = %archx_str_drop.exit50, %do_free.i58
  %long.i64 = icmp samesign ult i64 %alen.i, 13
  %tag.i67 = and i64 %aw1.i, 1
  %owned.not.i68 = icmp eq i64 %tag.i67, 0
  %or.cond1692 = select i1 %long.i64, i1 true, i1 %owned.not.i68
  br i1 %or.cond1692, label %archx_str_drop.exit72, label %do_free.i69

do_free.i69:                                      ; preds = %archx_str_drop.exit61
  %raw.i70 = and i64 %aw1.i, -2
  %ptr.i71 = inttoptr i64 %raw.i70 to ptr
  call void @free(ptr %ptr.i71)
  br label %archx_str_drop.exit72

archx_str_drop.exit72:                            ; preds = %archx_str_drop.exit61, %do_free.i69
  %long.i75 = icmp samesign ult i64 %blen.i326, 13
  %tag.i78 = and i64 %bw1.i325, 1
  %owned.not.i79 = icmp eq i64 %tag.i78, 0
  %or.cond1693 = select i1 %long.i75, i1 true, i1 %owned.not.i79
  br i1 %or.cond1693, label %archx_str_drop.exit83, label %do_free.i80

do_free.i80:                                      ; preds = %archx_str_drop.exit72
  %raw.i81 = and i64 %bw1.i325, -2
  %ptr.i82 = inttoptr i64 %raw.i81 to ptr
  call void @free(ptr %ptr.i82)
  br label %archx_str_drop.exit83

archx_str_drop.exit83:                            ; preds = %archx_str_drop.exit72, %do_free.i80
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1260)
  %n32.i1261 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1260, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %spec.store.select.i.1)
  %len.i1262 = sext i32 %n32.i1261 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1259)
  %z.i.i1263 = icmp slt i32 %n32.i1261, 1
  br i1 %z.i.i1263, label %archx_str_from_int.exit1287, label %chk_sso.i.i1264

oom.i.i1279:                                      ; preds = %alloc_heap.i.i1266
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1264:                                  ; preds = %archx_str_drop.exit83
  %short.i.i1265 = icmp samesign ult i32 %n32.i1261, 13
  br i1 %short.i.i1265, label %pack_sso.i.i1280, label %alloc_heap.i.i1266

pack_sso.i.i1280:                                 ; preds = %chk_sso.i.i1264
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1259, i8 0, i64 16, i1 false)
  store i32 %n32.i1261, ptr %sso.i.i1259, align 8
  %sso.i.i1259.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1259, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1259.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1260, i64 %len.i1262, i1 false)
  %sso.i.i1259.0.sso.i.i1259.0.sso.i.i1259.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1282 = load i64, ptr %sso.i.i1259, align 8
  %sso.i.i1259.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1259, i64 8
  %sso.i.i1259.8.sso.i.i1259.8.sso.i.i1259.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1284 = load i64, ptr %sso.i.i1259.8.sroa_idx, align 8
  %ss0.i.i1285 = insertvalue %ArchxStr poison, i64 %sso.i.i1259.0.sso.i.i1259.0.sso.i.i1259.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1282, 0
  %ss1.i.i1286 = insertvalue %ArchxStr %ss0.i.i1285, i64 %sso.i.i1259.8.sso.i.i1259.8.sso.i.i1259.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1284, 1
  br label %archx_str_from_int.exit1287

alloc_heap.i.i1266:                               ; preds = %chk_sso.i.i1264
  %hp.i.i1267 = call noalias align 16 ptr @malloc(i64 %len.i1262)
  %hnull.i.i1268 = icmp eq ptr %hp.i.i1267, null
  br i1 %hnull.i.i1268, label %oom.i.i1279, label %copy_long.i.i1269

copy_long.i.i1269:                                ; preds = %alloc_heap.i.i1266
  %hp_i.i.i1270 = ptrtoint ptr %hp.i.i1267 to i64
  %htagged.i.i1271 = or disjoint i64 %hp_i.i.i1270, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1267, ptr nonnull readonly align 8 %buf.i1260, i64 %len.i1262, i1 false)
  %pref32.i.i1272 = load i32, ptr %hp.i.i1267, align 16
  %pref64.i.i1273 = zext i32 %pref32.i.i1272 to i64
  %pref_sh.i.i1274 = shl nuw i64 %pref64.i.i1273, 32
  %w0_out.i.i1275 = or disjoint i64 %pref_sh.i.i1274, %len.i1262
  %ls0.i.i1276 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1275, 0
  %ls1.i.i1277 = insertvalue %ArchxStr %ls0.i.i1276, i64 %htagged.i.i1271, 1
  br label %archx_str_from_int.exit1287

archx_str_from_int.exit1287:                      ; preds = %archx_str_drop.exit83, %pack_sso.i.i1280, %copy_long.i.i1269
  %common.ret.op.i.i1278 = phi %ArchxStr [ %ss1.i.i1286, %pack_sso.i.i1280 ], [ %ls1.i.i1277, %copy_long.i.i1269 ], [ zeroinitializer, %archx_str_drop.exit83 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1259)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1260)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i476)
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %out_sso.i477.sroa.6.sroa.5)
  %bw0.i478 = extractvalue %ArchxStr %common.ret.op.i.i1278, 0
  %bw1.i479 = extractvalue %ArchxStr %common.ret.op.i.i1278, 1
  %blen.i480 = and i64 %bw0.i478, 4294967295
  %bz.i482 = icmp eq i64 %blen.i480, 0
  br i1 %bz.i482, label %archx_str_concat.exit528, label %calc_tot.i483

calc_tot.i483:                                    ; preds = %archx_str_from_int.exit1287
  %tot.i484 = add nuw nsw i64 %blen.i480, 10
  %too_big.i485 = icmp samesign ugt i64 %blen.i480, 2147483637
  br i1 %too_big.i485, label %oom.i512, label %mat_a.i486

oom.i512:                                         ; preds = %alloc_heap.i498, %calc_tot.i483
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i486:                                       ; preds = %calc_tot.i483
  %bshort.i491 = icmp samesign ult i64 %blen.i480, 13
  br i1 %bshort.i491, label %build.i495, label %build.i495.thread

build.i495.thread:                                ; preds = %mat_a.i486
  %braw.i493 = and i64 %bw1.i479, -4
  %blptr.i494 = inttoptr i64 %braw.i493 to ptr
  br label %alloc_heap.i498

build.i495:                                       ; preds = %mat_a.i486
  %bp4.i523 = lshr i64 %bw0.i478, 32
  %bp4_32.i524 = trunc nuw i64 %bp4.i523 to i32
  store i32 %bp4_32.i524, ptr %btmp.i476, align 4
  %btmp4.i525 = getelementptr inbounds nuw i8, ptr %btmp.i476, i64 4
  store i64 %bw1.i479, ptr %btmp4.i525, align 4
  %fits_sso.i497 = icmp samesign ult i64 %blen.i480, 3
  br i1 %fits_sso.i497, label %build_sso.i513, label %alloc_heap.i498

build_sso.i513:                                   ; preds = %build.i495
  store i16 0, ptr %out_sso.i477.sroa.6.sroa.5, align 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 2 %out_sso.i477.sroa.6.sroa.5, ptr nonnull align 4 %btmp.i476, i64 %blen.i480, i1 false)
  %out_sso.i477.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i484, 7813874494564466688
  %out_sso.i477.sroa.6.sroa.5.0.out_sso.i477.sroa.6.sroa.5.0.out_sso.i477.sroa.6.sroa.5.0.out_sso.i477.sroa.6.sroa.5.0.out_sso.i477.sroa.6.8.rw1.i519 = load i16, ptr %out_sso.i477.sroa.6.sroa.5, align 2
  %out_sso.i477.sroa.6.sroa.5.0.insert.ext = zext i16 %out_sso.i477.sroa.6.sroa.5.0.out_sso.i477.sroa.6.sroa.5.0.out_sso.i477.sroa.6.sroa.5.0.out_sso.i477.sroa.6.sroa.5.0.out_sso.i477.sroa.6.8.rw1.i519 to i64
  %out_sso.i477.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i477.sroa.6.sroa.5.0.insert.ext, 48
  %out_sso.i477.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i477.sroa.6.sroa.5.0.insert.shift, 67570311847781
  %rs0.i520 = insertvalue %ArchxStr poison, i64 %out_sso.i477.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i521 = insertvalue %ArchxStr %rs0.i520, i64 %out_sso.i477.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit528

alloc_heap.i498:                                  ; preds = %build.i495.thread, %build.i495
  %bptr.i4961790 = phi ptr [ %blptr.i494, %build.i495.thread ], [ %btmp.i476, %build.i495 ]
  %hp.i499 = call noalias align 16 ptr @malloc(i64 %tot.i484)
  %hnull.i500 = icmp eq ptr %hp.i499, null
  br i1 %hnull.i500, label %oom.i512, label %copy_long.i501

copy_long.i501:                                   ; preds = %alloc_heap.i498
  %hp_i.i502 = ptrtoint ptr %hp.i499 to i64
  %htagged.i503 = or disjoint i64 %hp_i.i502, 1
  store i32 1819309428, ptr %hp.i499, align 16
  %atmp.i475.sroa.5.0.hp.i499.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i499, i64 4
  store i48 67570311847781, ptr %atmp.i475.sroa.5.0.hp.i499.sroa_idx, align 4
  %dst_b.i504 = getelementptr inbounds nuw i8, ptr %hp.i499, i64 10
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 2 %dst_b.i504, ptr nonnull align 1 %bptr.i4961790, i64 %blen.i480, i1 false)
  %w0_out.i508 = or disjoint i64 %tot.i484, 7813874494564466688
  %ls0.i509 = insertvalue %ArchxStr poison, i64 %w0_out.i508, 0
  %ls1.i510 = insertvalue %ArchxStr %ls0.i509, i64 %htagged.i503, 1
  br label %archx_str_concat.exit528

archx_str_concat.exit528:                         ; preds = %archx_str_from_int.exit1287, %build_sso.i513, %copy_long.i501
  %common.ret.op.i511 = phi %ArchxStr [ %rs1.i521, %build_sso.i513 ], [ %ls1.i510, %copy_long.i501 ], [ { i64 7813874494564466698, i64 67570311847781 }, %archx_str_from_int.exit1287 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i476)
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %out_sso.i477.sroa.6.sroa.5)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i529)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i531)
  %aw0.i532 = extractvalue %ArchxStr %common.ret.op.i511, 0
  %aw1.i533 = extractvalue %ArchxStr %common.ret.op.i511, 1
  %alen.i534 = and i64 %aw0.i532, 4294967295
  %az.i535 = icmp eq i64 %alen.i534, 0
  br i1 %az.i535, label %archx_str_concat.exit582, label %chk_bz.i536

chk_bz.i536:                                      ; preds = %archx_str_concat.exit528
  %tot.i538 = add nuw nsw i64 %alen.i534, 1
  %too_big.i539 = icmp samesign ugt i64 %alen.i534, 2147483646
  br i1 %too_big.i539, label %oom.i566, label %mat_a.i540

oom.i566:                                         ; preds = %alloc_heap.i552, %chk_bz.i536
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i540:                                       ; preds = %chk_bz.i536
  %ashort.i541 = icmp samesign ult i64 %alen.i534, 13
  br i1 %ashort.i541, label %mat_b.i545, label %mat_b.i545.thread

mat_b.i545.thread:                                ; preds = %mat_a.i540
  %araw.i543 = and i64 %aw1.i533, -4
  %alptr.i544 = inttoptr i64 %araw.i543 to ptr
  br label %alloc_heap.i552

mat_b.i545:                                       ; preds = %mat_a.i540
  %ap4.i577 = lshr i64 %aw0.i532, 32
  %ap4_32.i578 = trunc nuw i64 %ap4.i577 to i32
  store i32 %ap4_32.i578, ptr %atmp.i529, align 4
  %atmp4.i579 = getelementptr inbounds nuw i8, ptr %atmp.i529, i64 4
  store i64 %aw1.i533, ptr %atmp4.i579, align 4
  %fits_sso.i551.not = icmp eq i64 %alen.i534, 12
  br i1 %fits_sso.i551.not, label %alloc_heap.i552, label %build_sso.i567

build_sso.i567:                                   ; preds = %mat_b.i545
  %out_sso8.i568 = getelementptr inbounds nuw i8, ptr %out_sso.i531, i64 8
  %tot32.i569 = trunc nuw nsw i64 %tot.i538 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i531, i8 0, i64 16, i1 false)
  store i32 %tot32.i569, ptr %out_sso.i531, align 8
  %sso_dst_a.i570 = getelementptr inbounds nuw i8, ptr %out_sso.i531, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i570, ptr nonnull align 4 %atmp.i529, i64 %alen.i534, i1 false)
  %sso_dst_b.i571 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i570, i64 %alen.i534
  store i8 44, ptr %sso_dst_b.i571, align 1
  %rw0.i572 = load i64, ptr %out_sso.i531, align 8
  %rw1.i573 = load i64, ptr %out_sso8.i568, align 8
  %rs0.i574 = insertvalue %ArchxStr poison, i64 %rw0.i572, 0
  %rs1.i575 = insertvalue %ArchxStr %rs0.i574, i64 %rw1.i573, 1
  br label %archx_str_concat.exit582

alloc_heap.i552:                                  ; preds = %mat_b.i545.thread, %mat_b.i545
  %aptr.i5461677 = phi ptr [ %alptr.i544, %mat_b.i545.thread ], [ %atmp.i529, %mat_b.i545 ]
  %hp.i553 = call noalias align 16 ptr @malloc(i64 %tot.i538)
  %hnull.i554 = icmp eq ptr %hp.i553, null
  br i1 %hnull.i554, label %oom.i566, label %copy_long.i555

copy_long.i555:                                   ; preds = %alloc_heap.i552
  %hp_i.i556 = ptrtoint ptr %hp.i553 to i64
  %htagged.i557 = or disjoint i64 %hp_i.i556, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i553, ptr nonnull align 1 %aptr.i5461677, i64 %alen.i534, i1 false)
  %dst_b.i558 = getelementptr inbounds nuw i8, ptr %hp.i553, i64 %alen.i534
  store i8 44, ptr %dst_b.i558, align 1
  %pref32.i559 = load i32, ptr %hp.i553, align 16
  %pref64.i560 = zext i32 %pref32.i559 to i64
  %pref_sh.i561 = shl nuw i64 %pref64.i560, 32
  %w0_out.i562 = or disjoint i64 %pref_sh.i561, %tot.i538
  %ls0.i563 = insertvalue %ArchxStr poison, i64 %w0_out.i562, 0
  %ls1.i564 = insertvalue %ArchxStr %ls0.i563, i64 %htagged.i557, 1
  br label %archx_str_concat.exit582

archx_str_concat.exit582:                         ; preds = %archx_str_concat.exit528, %build_sso.i567, %copy_long.i555
  %common.ret.op.i565 = phi %ArchxStr [ %rs1.i575, %build_sso.i567 ], [ %ls1.i564, %copy_long.i555 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit528 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i529)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i531)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1291)
  %n32.i1292 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1291, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %spec.store.select1.i.1)
  %len.i1293 = sext i32 %n32.i1292 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1290)
  %z.i.i1294 = icmp slt i32 %n32.i1292, 1
  br i1 %z.i.i1294, label %archx_str_from_int.exit1318, label %chk_sso.i.i1295

oom.i.i1310:                                      ; preds = %alloc_heap.i.i1297
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1295:                                  ; preds = %archx_str_concat.exit582
  %short.i.i1296 = icmp samesign ult i32 %n32.i1292, 13
  br i1 %short.i.i1296, label %pack_sso.i.i1311, label %alloc_heap.i.i1297

pack_sso.i.i1311:                                 ; preds = %chk_sso.i.i1295
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1290, i8 0, i64 16, i1 false)
  store i32 %n32.i1292, ptr %sso.i.i1290, align 8
  %sso.i.i1290.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1290, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1290.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1291, i64 %len.i1293, i1 false)
  %sso.i.i1290.0.sso.i.i1290.0.sso.i.i1290.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1313 = load i64, ptr %sso.i.i1290, align 8
  %sso.i.i1290.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1290, i64 8
  %sso.i.i1290.8.sso.i.i1290.8.sso.i.i1290.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1315 = load i64, ptr %sso.i.i1290.8.sroa_idx, align 8
  %ss0.i.i1316 = insertvalue %ArchxStr poison, i64 %sso.i.i1290.0.sso.i.i1290.0.sso.i.i1290.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1313, 0
  %ss1.i.i1317 = insertvalue %ArchxStr %ss0.i.i1316, i64 %sso.i.i1290.8.sso.i.i1290.8.sso.i.i1290.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1315, 1
  br label %archx_str_from_int.exit1318

alloc_heap.i.i1297:                               ; preds = %chk_sso.i.i1295
  %hp.i.i1298 = call noalias align 16 ptr @malloc(i64 %len.i1293)
  %hnull.i.i1299 = icmp eq ptr %hp.i.i1298, null
  br i1 %hnull.i.i1299, label %oom.i.i1310, label %copy_long.i.i1300

copy_long.i.i1300:                                ; preds = %alloc_heap.i.i1297
  %hp_i.i.i1301 = ptrtoint ptr %hp.i.i1298 to i64
  %htagged.i.i1302 = or disjoint i64 %hp_i.i.i1301, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1298, ptr nonnull readonly align 8 %buf.i1291, i64 %len.i1293, i1 false)
  %pref32.i.i1303 = load i32, ptr %hp.i.i1298, align 16
  %pref64.i.i1304 = zext i32 %pref32.i.i1303 to i64
  %pref_sh.i.i1305 = shl nuw i64 %pref64.i.i1304, 32
  %w0_out.i.i1306 = or disjoint i64 %pref_sh.i.i1305, %len.i1293
  %ls0.i.i1307 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1306, 0
  %ls1.i.i1308 = insertvalue %ArchxStr %ls0.i.i1307, i64 %htagged.i.i1302, 1
  br label %archx_str_from_int.exit1318

archx_str_from_int.exit1318:                      ; preds = %archx_str_concat.exit582, %pack_sso.i.i1311, %copy_long.i.i1300
  %common.ret.op.i.i1309 = phi %ArchxStr [ %ss1.i.i1317, %pack_sso.i.i1311 ], [ %ls1.i.i1308, %copy_long.i.i1300 ], [ zeroinitializer, %archx_str_concat.exit582 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1290)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1291)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i583)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i584)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i585)
  %aw0.i586 = extractvalue %ArchxStr %common.ret.op.i565, 0
  %aw1.i587 = extractvalue %ArchxStr %common.ret.op.i565, 1
  %bw0.i588 = extractvalue %ArchxStr %common.ret.op.i.i1309, 0
  %bw1.i589 = extractvalue %ArchxStr %common.ret.op.i.i1309, 1
  %alen.i590 = and i64 %aw0.i586, 4294967295
  %blen.i591 = and i64 %bw0.i588, 4294967295
  %az.i592 = icmp eq i64 %alen.i590, 0
  br i1 %az.i592, label %ret_b_clone.i646, label %chk_bz.i593

ret_b_clone.i646:                                 ; preds = %archx_str_from_int.exit1318
  %long.i1321 = icmp samesign ult i64 %blen.i591, 13
  %tag.i1325 = and i64 %bw1.i589, 3
  %owned.not.i1326 = icmp eq i64 %tag.i1325, 0
  %or.cond1694 = select i1 %long.i1321, i1 true, i1 %owned.not.i1326
  br i1 %or.cond1694, label %archx_str_concat.exit648, label %dup_heap.i1327

dup_heap.i1327:                                   ; preds = %ret_b_clone.i646
  %dst.i1328 = call noalias align 16 ptr @malloc(i64 %blen.i591)
  %isnull.i1329 = icmp eq ptr %dst.i1328, null
  br i1 %isnull.i1329, label %oom.i1336, label %copy.i1330

oom.i1336:                                        ; preds = %dup_heap.i1327
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1330:                                       ; preds = %dup_heap.i1327
  %src_i.i1331 = and i64 %bw1.i589, -4
  %src.i1332 = inttoptr i64 %src_i.i1331 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1328, ptr nonnull align 4 %src.i1332, i64 %blen.i591, i1 false)
  %dst_i.i1333 = ptrtoint ptr %dst.i1328 to i64
  %tagged.i1334 = or disjoint i64 %dst_i.i1333, 1
  %out.i1335 = insertvalue %ArchxStr %common.ret.op.i.i1309, i64 %tagged.i1334, 1
  br label %archx_str_concat.exit648

chk_bz.i593:                                      ; preds = %archx_str_from_int.exit1318
  %bz.i594 = icmp eq i64 %blen.i591, 0
  br i1 %bz.i594, label %ret_a_clone.i644, label %calc_tot.i595

ret_a_clone.i644:                                 ; preds = %chk_bz.i593
  %long.i1340 = icmp samesign ult i64 %alen.i590, 13
  %tag.i1344 = and i64 %aw1.i587, 3
  %owned.not.i1345 = icmp eq i64 %tag.i1344, 0
  %or.cond1695 = select i1 %long.i1340, i1 true, i1 %owned.not.i1345
  br i1 %or.cond1695, label %archx_str_concat.exit648, label %dup_heap.i1346

dup_heap.i1346:                                   ; preds = %ret_a_clone.i644
  %dst.i1347 = call noalias align 16 ptr @malloc(i64 %alen.i590)
  %isnull.i1348 = icmp eq ptr %dst.i1347, null
  br i1 %isnull.i1348, label %oom.i1355, label %copy.i1349

oom.i1355:                                        ; preds = %dup_heap.i1346
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1349:                                       ; preds = %dup_heap.i1346
  %src_i.i1350 = and i64 %aw1.i587, -4
  %src.i1351 = inttoptr i64 %src_i.i1350 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1347, ptr nonnull align 4 %src.i1351, i64 %alen.i590, i1 false)
  %dst_i.i1352 = ptrtoint ptr %dst.i1347 to i64
  %tagged.i1353 = or disjoint i64 %dst_i.i1352, 1
  %out.i1354 = insertvalue %ArchxStr %common.ret.op.i565, i64 %tagged.i1353, 1
  br label %archx_str_concat.exit648

calc_tot.i595:                                    ; preds = %chk_bz.i593
  %tot.i596 = add nuw nsw i64 %blen.i591, %alen.i590
  %too_big.i597 = icmp samesign ugt i64 %tot.i596, 2147483647
  br i1 %too_big.i597, label %oom.i626, label %mat_a.i598

oom.i626:                                         ; preds = %alloc_heap.i612, %calc_tot.i595
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i598:                                       ; preds = %calc_tot.i595
  %ashort.i599 = icmp samesign ult i64 %alen.i590, 13
  br i1 %ashort.i599, label %mat_a_short.i640, label %mat_a_long.i600

mat_a_short.i640:                                 ; preds = %mat_a.i598
  %ap4.i641 = lshr i64 %aw0.i586, 32
  %ap4_32.i642 = trunc nuw i64 %ap4.i641 to i32
  store i32 %ap4_32.i642, ptr %atmp.i583, align 4
  %atmp4.i643 = getelementptr inbounds nuw i8, ptr %atmp.i583, i64 4
  store i64 %aw1.i587, ptr %atmp4.i643, align 4
  br label %mat_b.i603

mat_a_long.i600:                                  ; preds = %mat_a.i598
  %araw.i601 = and i64 %aw1.i587, -4
  %alptr.i602 = inttoptr i64 %araw.i601 to ptr
  br label %mat_b.i603

mat_b.i603:                                       ; preds = %mat_a_long.i600, %mat_a_short.i640
  %aptr.i604 = phi ptr [ %atmp.i583, %mat_a_short.i640 ], [ %alptr.i602, %mat_a_long.i600 ]
  %bshort.i605 = icmp samesign ult i64 %blen.i591, 13
  br i1 %bshort.i605, label %mat_b_short.i636, label %mat_b_long.i606

mat_b_short.i636:                                 ; preds = %mat_b.i603
  %bp4.i637 = lshr i64 %bw0.i588, 32
  %bp4_32.i638 = trunc nuw i64 %bp4.i637 to i32
  store i32 %bp4_32.i638, ptr %btmp.i584, align 4
  %btmp4.i639 = getelementptr inbounds nuw i8, ptr %btmp.i584, i64 4
  store i64 %bw1.i589, ptr %btmp4.i639, align 4
  br label %build.i609

mat_b_long.i606:                                  ; preds = %mat_b.i603
  %braw.i607 = and i64 %bw1.i589, -4
  %blptr.i608 = inttoptr i64 %braw.i607 to ptr
  br label %build.i609

build.i609:                                       ; preds = %mat_b_long.i606, %mat_b_short.i636
  %bptr.i610 = phi ptr [ %btmp.i584, %mat_b_short.i636 ], [ %blptr.i608, %mat_b_long.i606 ]
  %fits_sso.i611 = icmp samesign ult i64 %tot.i596, 13
  br i1 %fits_sso.i611, label %build_sso.i627, label %alloc_heap.i612

build_sso.i627:                                   ; preds = %build.i609
  %out_sso8.i628 = getelementptr inbounds nuw i8, ptr %out_sso.i585, i64 8
  %tot32.i629 = trunc nuw nsw i64 %tot.i596 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i585, i8 0, i64 16, i1 false)
  store i32 %tot32.i629, ptr %out_sso.i585, align 8
  %sso_dst_a.i630 = getelementptr inbounds nuw i8, ptr %out_sso.i585, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i630, ptr nonnull align 1 %aptr.i604, i64 %alen.i590, i1 false)
  %sso_dst_b.i631 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i630, i64 %alen.i590
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i631, ptr nonnull align 1 %bptr.i610, i64 %blen.i591, i1 false)
  %rw0.i632 = load i64, ptr %out_sso.i585, align 8
  %rw1.i633 = load i64, ptr %out_sso8.i628, align 8
  %rs0.i634 = insertvalue %ArchxStr poison, i64 %rw0.i632, 0
  %rs1.i635 = insertvalue %ArchxStr %rs0.i634, i64 %rw1.i633, 1
  br label %archx_str_concat.exit648

alloc_heap.i612:                                  ; preds = %build.i609
  %hp.i613 = call noalias align 16 ptr @malloc(i64 %tot.i596)
  %hnull.i614 = icmp eq ptr %hp.i613, null
  br i1 %hnull.i614, label %oom.i626, label %copy_long.i615

copy_long.i615:                                   ; preds = %alloc_heap.i612
  %hp_i.i616 = ptrtoint ptr %hp.i613 to i64
  %htagged.i617 = or disjoint i64 %hp_i.i616, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i613, ptr nonnull align 1 %aptr.i604, i64 %alen.i590, i1 false)
  %dst_b.i618 = getelementptr inbounds nuw i8, ptr %hp.i613, i64 %alen.i590
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i618, ptr nonnull align 1 %bptr.i610, i64 %blen.i591, i1 false)
  %pref32.i619 = load i32, ptr %hp.i613, align 16
  %pref64.i620 = zext i32 %pref32.i619 to i64
  %pref_sh.i621 = shl nuw i64 %pref64.i620, 32
  %w0_out.i622 = or disjoint i64 %pref_sh.i621, %tot.i596
  %ls0.i623 = insertvalue %ArchxStr poison, i64 %w0_out.i622, 0
  %ls1.i624 = insertvalue %ArchxStr %ls0.i623, i64 %htagged.i617, 1
  br label %archx_str_concat.exit648

archx_str_concat.exit648:                         ; preds = %copy.i1349, %ret_a_clone.i644, %copy.i1330, %ret_b_clone.i646, %build_sso.i627, %copy_long.i615
  %common.ret.op.i625 = phi %ArchxStr [ %rs1.i635, %build_sso.i627 ], [ %ls1.i624, %copy_long.i615 ], [ %out.i1335, %copy.i1330 ], [ %common.ret.op.i.i1309, %ret_b_clone.i646 ], [ %out.i1354, %copy.i1349 ], [ %common.ret.op.i565, %ret_a_clone.i644 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i583)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i584)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i585)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i649)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i651)
  %aw0.i652 = extractvalue %ArchxStr %common.ret.op.i625, 0
  %aw1.i653 = extractvalue %ArchxStr %common.ret.op.i625, 1
  %alen.i654 = and i64 %aw0.i652, 4294967295
  %az.i655 = icmp eq i64 %alen.i654, 0
  br i1 %az.i655, label %archx_str_concat.exit702, label %chk_bz.i656

chk_bz.i656:                                      ; preds = %archx_str_concat.exit648
  %tot.i658 = add nuw nsw i64 %alen.i654, 1
  %too_big.i659 = icmp samesign ugt i64 %alen.i654, 2147483646
  br i1 %too_big.i659, label %oom.i686, label %mat_a.i660

oom.i686:                                         ; preds = %alloc_heap.i672, %chk_bz.i656
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i660:                                       ; preds = %chk_bz.i656
  %ashort.i661 = icmp samesign ult i64 %alen.i654, 13
  br i1 %ashort.i661, label %mat_b.i665, label %mat_b.i665.thread

mat_b.i665.thread:                                ; preds = %mat_a.i660
  %araw.i663 = and i64 %aw1.i653, -4
  %alptr.i664 = inttoptr i64 %araw.i663 to ptr
  br label %alloc_heap.i672

mat_b.i665:                                       ; preds = %mat_a.i660
  %ap4.i697 = lshr i64 %aw0.i652, 32
  %ap4_32.i698 = trunc nuw i64 %ap4.i697 to i32
  store i32 %ap4_32.i698, ptr %atmp.i649, align 4
  %atmp4.i699 = getelementptr inbounds nuw i8, ptr %atmp.i649, i64 4
  store i64 %aw1.i653, ptr %atmp4.i699, align 4
  %fits_sso.i671.not = icmp eq i64 %alen.i654, 12
  br i1 %fits_sso.i671.not, label %alloc_heap.i672, label %build_sso.i687

build_sso.i687:                                   ; preds = %mat_b.i665
  %out_sso8.i688 = getelementptr inbounds nuw i8, ptr %out_sso.i651, i64 8
  %tot32.i689 = trunc nuw nsw i64 %tot.i658 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i651, i8 0, i64 16, i1 false)
  store i32 %tot32.i689, ptr %out_sso.i651, align 8
  %sso_dst_a.i690 = getelementptr inbounds nuw i8, ptr %out_sso.i651, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i690, ptr nonnull align 4 %atmp.i649, i64 %alen.i654, i1 false)
  %sso_dst_b.i691 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i690, i64 %alen.i654
  store i8 44, ptr %sso_dst_b.i691, align 1
  %rw0.i692 = load i64, ptr %out_sso.i651, align 8
  %rw1.i693 = load i64, ptr %out_sso8.i688, align 8
  %rs0.i694 = insertvalue %ArchxStr poison, i64 %rw0.i692, 0
  %rs1.i695 = insertvalue %ArchxStr %rs0.i694, i64 %rw1.i693, 1
  br label %archx_str_concat.exit702

alloc_heap.i672:                                  ; preds = %mat_b.i665.thread, %mat_b.i665
  %aptr.i6661680 = phi ptr [ %alptr.i664, %mat_b.i665.thread ], [ %atmp.i649, %mat_b.i665 ]
  %hp.i673 = call noalias align 16 ptr @malloc(i64 %tot.i658)
  %hnull.i674 = icmp eq ptr %hp.i673, null
  br i1 %hnull.i674, label %oom.i686, label %copy_long.i675

copy_long.i675:                                   ; preds = %alloc_heap.i672
  %hp_i.i676 = ptrtoint ptr %hp.i673 to i64
  %htagged.i677 = or disjoint i64 %hp_i.i676, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i673, ptr nonnull align 1 %aptr.i6661680, i64 %alen.i654, i1 false)
  %dst_b.i678 = getelementptr inbounds nuw i8, ptr %hp.i673, i64 %alen.i654
  store i8 44, ptr %dst_b.i678, align 1
  %pref32.i679 = load i32, ptr %hp.i673, align 16
  %pref64.i680 = zext i32 %pref32.i679 to i64
  %pref_sh.i681 = shl nuw i64 %pref64.i680, 32
  %w0_out.i682 = or disjoint i64 %pref_sh.i681, %tot.i658
  %ls0.i683 = insertvalue %ArchxStr poison, i64 %w0_out.i682, 0
  %ls1.i684 = insertvalue %ArchxStr %ls0.i683, i64 %htagged.i677, 1
  br label %archx_str_concat.exit702

archx_str_concat.exit702:                         ; preds = %archx_str_concat.exit648, %build_sso.i687, %copy_long.i675
  %common.ret.op.i685 = phi %ArchxStr [ %rs1.i695, %build_sso.i687 ], [ %ls1.i684, %copy_long.i675 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit648 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i649)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i651)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1359)
  %n32.i1360 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1359, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t25.i1074.1)
  %len.i1361 = sext i32 %n32.i1360 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1358)
  %z.i.i1362 = icmp slt i32 %n32.i1360, 1
  br i1 %z.i.i1362, label %archx_str_from_int.exit1386, label %chk_sso.i.i1363

oom.i.i1378:                                      ; preds = %alloc_heap.i.i1365
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1363:                                  ; preds = %archx_str_concat.exit702
  %short.i.i1364 = icmp samesign ult i32 %n32.i1360, 13
  br i1 %short.i.i1364, label %pack_sso.i.i1379, label %alloc_heap.i.i1365

pack_sso.i.i1379:                                 ; preds = %chk_sso.i.i1363
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1358, i8 0, i64 16, i1 false)
  store i32 %n32.i1360, ptr %sso.i.i1358, align 8
  %sso.i.i1358.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1358, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1358.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1359, i64 %len.i1361, i1 false)
  %sso.i.i1358.0.sso.i.i1358.0.sso.i.i1358.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1381 = load i64, ptr %sso.i.i1358, align 8
  %sso.i.i1358.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1358, i64 8
  %sso.i.i1358.8.sso.i.i1358.8.sso.i.i1358.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1383 = load i64, ptr %sso.i.i1358.8.sroa_idx, align 8
  %ss0.i.i1384 = insertvalue %ArchxStr poison, i64 %sso.i.i1358.0.sso.i.i1358.0.sso.i.i1358.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1381, 0
  %ss1.i.i1385 = insertvalue %ArchxStr %ss0.i.i1384, i64 %sso.i.i1358.8.sso.i.i1358.8.sso.i.i1358.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1383, 1
  br label %archx_str_from_int.exit1386

alloc_heap.i.i1365:                               ; preds = %chk_sso.i.i1363
  %hp.i.i1366 = call noalias align 16 ptr @malloc(i64 %len.i1361)
  %hnull.i.i1367 = icmp eq ptr %hp.i.i1366, null
  br i1 %hnull.i.i1367, label %oom.i.i1378, label %copy_long.i.i1368

copy_long.i.i1368:                                ; preds = %alloc_heap.i.i1365
  %hp_i.i.i1369 = ptrtoint ptr %hp.i.i1366 to i64
  %htagged.i.i1370 = or disjoint i64 %hp_i.i.i1369, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1366, ptr nonnull readonly align 8 %buf.i1359, i64 %len.i1361, i1 false)
  %pref32.i.i1371 = load i32, ptr %hp.i.i1366, align 16
  %pref64.i.i1372 = zext i32 %pref32.i.i1371 to i64
  %pref_sh.i.i1373 = shl nuw i64 %pref64.i.i1372, 32
  %w0_out.i.i1374 = or disjoint i64 %pref_sh.i.i1373, %len.i1361
  %ls0.i.i1375 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1374, 0
  %ls1.i.i1376 = insertvalue %ArchxStr %ls0.i.i1375, i64 %htagged.i.i1370, 1
  br label %archx_str_from_int.exit1386

archx_str_from_int.exit1386:                      ; preds = %archx_str_concat.exit702, %pack_sso.i.i1379, %copy_long.i.i1368
  %common.ret.op.i.i1377 = phi %ArchxStr [ %ss1.i.i1385, %pack_sso.i.i1379 ], [ %ls1.i.i1376, %copy_long.i.i1368 ], [ zeroinitializer, %archx_str_concat.exit702 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1358)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1359)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i703)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i704)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i705)
  %aw0.i706 = extractvalue %ArchxStr %common.ret.op.i685, 0
  %aw1.i707 = extractvalue %ArchxStr %common.ret.op.i685, 1
  %bw0.i708 = extractvalue %ArchxStr %common.ret.op.i.i1377, 0
  %bw1.i709 = extractvalue %ArchxStr %common.ret.op.i.i1377, 1
  %alen.i710 = and i64 %aw0.i706, 4294967295
  %blen.i711 = and i64 %bw0.i708, 4294967295
  %az.i712 = icmp eq i64 %alen.i710, 0
  br i1 %az.i712, label %ret_b_clone.i766, label %chk_bz.i713

ret_b_clone.i766:                                 ; preds = %archx_str_from_int.exit1386
  %long.i1389 = icmp samesign ult i64 %blen.i711, 13
  %tag.i1393 = and i64 %bw1.i709, 3
  %owned.not.i1394 = icmp eq i64 %tag.i1393, 0
  %or.cond1696 = select i1 %long.i1389, i1 true, i1 %owned.not.i1394
  br i1 %or.cond1696, label %archx_str_concat.exit768, label %dup_heap.i1395

dup_heap.i1395:                                   ; preds = %ret_b_clone.i766
  %dst.i1396 = call noalias align 16 ptr @malloc(i64 %blen.i711)
  %isnull.i1397 = icmp eq ptr %dst.i1396, null
  br i1 %isnull.i1397, label %oom.i1404, label %copy.i1398

oom.i1404:                                        ; preds = %dup_heap.i1395
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1398:                                       ; preds = %dup_heap.i1395
  %src_i.i1399 = and i64 %bw1.i709, -4
  %src.i1400 = inttoptr i64 %src_i.i1399 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1396, ptr nonnull align 4 %src.i1400, i64 %blen.i711, i1 false)
  %dst_i.i1401 = ptrtoint ptr %dst.i1396 to i64
  %tagged.i1402 = or disjoint i64 %dst_i.i1401, 1
  %out.i1403 = insertvalue %ArchxStr %common.ret.op.i.i1377, i64 %tagged.i1402, 1
  br label %archx_str_concat.exit768

chk_bz.i713:                                      ; preds = %archx_str_from_int.exit1386
  %bz.i714 = icmp eq i64 %blen.i711, 0
  br i1 %bz.i714, label %ret_a_clone.i764, label %calc_tot.i715

ret_a_clone.i764:                                 ; preds = %chk_bz.i713
  %long.i1408 = icmp samesign ult i64 %alen.i710, 13
  %tag.i1412 = and i64 %aw1.i707, 3
  %owned.not.i1413 = icmp eq i64 %tag.i1412, 0
  %or.cond1697 = select i1 %long.i1408, i1 true, i1 %owned.not.i1413
  br i1 %or.cond1697, label %archx_str_concat.exit768, label %dup_heap.i1414

dup_heap.i1414:                                   ; preds = %ret_a_clone.i764
  %dst.i1415 = call noalias align 16 ptr @malloc(i64 %alen.i710)
  %isnull.i1416 = icmp eq ptr %dst.i1415, null
  br i1 %isnull.i1416, label %oom.i1423, label %copy.i1417

oom.i1423:                                        ; preds = %dup_heap.i1414
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1417:                                       ; preds = %dup_heap.i1414
  %src_i.i1418 = and i64 %aw1.i707, -4
  %src.i1419 = inttoptr i64 %src_i.i1418 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1415, ptr nonnull align 4 %src.i1419, i64 %alen.i710, i1 false)
  %dst_i.i1420 = ptrtoint ptr %dst.i1415 to i64
  %tagged.i1421 = or disjoint i64 %dst_i.i1420, 1
  %out.i1422 = insertvalue %ArchxStr %common.ret.op.i685, i64 %tagged.i1421, 1
  br label %archx_str_concat.exit768

calc_tot.i715:                                    ; preds = %chk_bz.i713
  %tot.i716 = add nuw nsw i64 %blen.i711, %alen.i710
  %too_big.i717 = icmp samesign ugt i64 %tot.i716, 2147483647
  br i1 %too_big.i717, label %oom.i746, label %mat_a.i718

oom.i746:                                         ; preds = %alloc_heap.i732, %calc_tot.i715
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i718:                                       ; preds = %calc_tot.i715
  %ashort.i719 = icmp samesign ult i64 %alen.i710, 13
  br i1 %ashort.i719, label %mat_a_short.i760, label %mat_a_long.i720

mat_a_short.i760:                                 ; preds = %mat_a.i718
  %ap4.i761 = lshr i64 %aw0.i706, 32
  %ap4_32.i762 = trunc nuw i64 %ap4.i761 to i32
  store i32 %ap4_32.i762, ptr %atmp.i703, align 4
  %atmp4.i763 = getelementptr inbounds nuw i8, ptr %atmp.i703, i64 4
  store i64 %aw1.i707, ptr %atmp4.i763, align 4
  br label %mat_b.i723

mat_a_long.i720:                                  ; preds = %mat_a.i718
  %araw.i721 = and i64 %aw1.i707, -4
  %alptr.i722 = inttoptr i64 %araw.i721 to ptr
  br label %mat_b.i723

mat_b.i723:                                       ; preds = %mat_a_long.i720, %mat_a_short.i760
  %aptr.i724 = phi ptr [ %atmp.i703, %mat_a_short.i760 ], [ %alptr.i722, %mat_a_long.i720 ]
  %bshort.i725 = icmp samesign ult i64 %blen.i711, 13
  br i1 %bshort.i725, label %mat_b_short.i756, label %mat_b_long.i726

mat_b_short.i756:                                 ; preds = %mat_b.i723
  %bp4.i757 = lshr i64 %bw0.i708, 32
  %bp4_32.i758 = trunc nuw i64 %bp4.i757 to i32
  store i32 %bp4_32.i758, ptr %btmp.i704, align 4
  %btmp4.i759 = getelementptr inbounds nuw i8, ptr %btmp.i704, i64 4
  store i64 %bw1.i709, ptr %btmp4.i759, align 4
  br label %build.i729

mat_b_long.i726:                                  ; preds = %mat_b.i723
  %braw.i727 = and i64 %bw1.i709, -4
  %blptr.i728 = inttoptr i64 %braw.i727 to ptr
  br label %build.i729

build.i729:                                       ; preds = %mat_b_long.i726, %mat_b_short.i756
  %bptr.i730 = phi ptr [ %btmp.i704, %mat_b_short.i756 ], [ %blptr.i728, %mat_b_long.i726 ]
  %fits_sso.i731 = icmp samesign ult i64 %tot.i716, 13
  br i1 %fits_sso.i731, label %build_sso.i747, label %alloc_heap.i732

build_sso.i747:                                   ; preds = %build.i729
  %out_sso8.i748 = getelementptr inbounds nuw i8, ptr %out_sso.i705, i64 8
  %tot32.i749 = trunc nuw nsw i64 %tot.i716 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i705, i8 0, i64 16, i1 false)
  store i32 %tot32.i749, ptr %out_sso.i705, align 8
  %sso_dst_a.i750 = getelementptr inbounds nuw i8, ptr %out_sso.i705, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i750, ptr nonnull align 1 %aptr.i724, i64 %alen.i710, i1 false)
  %sso_dst_b.i751 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i750, i64 %alen.i710
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i751, ptr nonnull align 1 %bptr.i730, i64 %blen.i711, i1 false)
  %rw0.i752 = load i64, ptr %out_sso.i705, align 8
  %rw1.i753 = load i64, ptr %out_sso8.i748, align 8
  %rs0.i754 = insertvalue %ArchxStr poison, i64 %rw0.i752, 0
  %rs1.i755 = insertvalue %ArchxStr %rs0.i754, i64 %rw1.i753, 1
  br label %archx_str_concat.exit768

alloc_heap.i732:                                  ; preds = %build.i729
  %hp.i733 = call noalias align 16 ptr @malloc(i64 %tot.i716)
  %hnull.i734 = icmp eq ptr %hp.i733, null
  br i1 %hnull.i734, label %oom.i746, label %copy_long.i735

copy_long.i735:                                   ; preds = %alloc_heap.i732
  %hp_i.i736 = ptrtoint ptr %hp.i733 to i64
  %htagged.i737 = or disjoint i64 %hp_i.i736, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i733, ptr nonnull align 1 %aptr.i724, i64 %alen.i710, i1 false)
  %dst_b.i738 = getelementptr inbounds nuw i8, ptr %hp.i733, i64 %alen.i710
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i738, ptr nonnull align 1 %bptr.i730, i64 %blen.i711, i1 false)
  %pref32.i739 = load i32, ptr %hp.i733, align 16
  %pref64.i740 = zext i32 %pref32.i739 to i64
  %pref_sh.i741 = shl nuw i64 %pref64.i740, 32
  %w0_out.i742 = or disjoint i64 %pref_sh.i741, %tot.i716
  %ls0.i743 = insertvalue %ArchxStr poison, i64 %w0_out.i742, 0
  %ls1.i744 = insertvalue %ArchxStr %ls0.i743, i64 %htagged.i737, 1
  br label %archx_str_concat.exit768

archx_str_concat.exit768:                         ; preds = %copy.i1417, %ret_a_clone.i764, %copy.i1398, %ret_b_clone.i766, %build_sso.i747, %copy_long.i735
  %common.ret.op.i745 = phi %ArchxStr [ %rs1.i755, %build_sso.i747 ], [ %ls1.i744, %copy_long.i735 ], [ %out.i1403, %copy.i1398 ], [ %common.ret.op.i.i1377, %ret_b_clone.i766 ], [ %out.i1422, %copy.i1417 ], [ %common.ret.op.i685, %ret_a_clone.i764 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i703)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i704)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i705)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i769)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i771)
  %aw0.i772 = extractvalue %ArchxStr %common.ret.op.i745, 0
  %aw1.i773 = extractvalue %ArchxStr %common.ret.op.i745, 1
  %alen.i774 = and i64 %aw0.i772, 4294967295
  %az.i775 = icmp eq i64 %alen.i774, 0
  br i1 %az.i775, label %archx_str_concat.exit822, label %chk_bz.i776

chk_bz.i776:                                      ; preds = %archx_str_concat.exit768
  %tot.i778 = add nuw nsw i64 %alen.i774, 1
  %too_big.i779 = icmp samesign ugt i64 %alen.i774, 2147483646
  br i1 %too_big.i779, label %oom.i806, label %mat_a.i780

oom.i806:                                         ; preds = %alloc_heap.i792, %chk_bz.i776
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i780:                                       ; preds = %chk_bz.i776
  %ashort.i781 = icmp samesign ult i64 %alen.i774, 13
  br i1 %ashort.i781, label %mat_b.i785, label %mat_b.i785.thread

mat_b.i785.thread:                                ; preds = %mat_a.i780
  %araw.i783 = and i64 %aw1.i773, -4
  %alptr.i784 = inttoptr i64 %araw.i783 to ptr
  br label %alloc_heap.i792

mat_b.i785:                                       ; preds = %mat_a.i780
  %ap4.i817 = lshr i64 %aw0.i772, 32
  %ap4_32.i818 = trunc nuw i64 %ap4.i817 to i32
  store i32 %ap4_32.i818, ptr %atmp.i769, align 4
  %atmp4.i819 = getelementptr inbounds nuw i8, ptr %atmp.i769, i64 4
  store i64 %aw1.i773, ptr %atmp4.i819, align 4
  %fits_sso.i791.not = icmp eq i64 %alen.i774, 12
  br i1 %fits_sso.i791.not, label %alloc_heap.i792, label %build_sso.i807

build_sso.i807:                                   ; preds = %mat_b.i785
  %out_sso8.i808 = getelementptr inbounds nuw i8, ptr %out_sso.i771, i64 8
  %tot32.i809 = trunc nuw nsw i64 %tot.i778 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i771, i8 0, i64 16, i1 false)
  store i32 %tot32.i809, ptr %out_sso.i771, align 8
  %sso_dst_a.i810 = getelementptr inbounds nuw i8, ptr %out_sso.i771, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i810, ptr nonnull align 4 %atmp.i769, i64 %alen.i774, i1 false)
  %sso_dst_b.i811 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i810, i64 %alen.i774
  store i8 44, ptr %sso_dst_b.i811, align 1
  %rw0.i812 = load i64, ptr %out_sso.i771, align 8
  %rw1.i813 = load i64, ptr %out_sso8.i808, align 8
  %rs0.i814 = insertvalue %ArchxStr poison, i64 %rw0.i812, 0
  %rs1.i815 = insertvalue %ArchxStr %rs0.i814, i64 %rw1.i813, 1
  br label %archx_str_concat.exit822

alloc_heap.i792:                                  ; preds = %mat_b.i785.thread, %mat_b.i785
  %aptr.i7861683 = phi ptr [ %alptr.i784, %mat_b.i785.thread ], [ %atmp.i769, %mat_b.i785 ]
  %hp.i793 = call noalias align 16 ptr @malloc(i64 %tot.i778)
  %hnull.i794 = icmp eq ptr %hp.i793, null
  br i1 %hnull.i794, label %oom.i806, label %copy_long.i795

copy_long.i795:                                   ; preds = %alloc_heap.i792
  %hp_i.i796 = ptrtoint ptr %hp.i793 to i64
  %htagged.i797 = or disjoint i64 %hp_i.i796, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i793, ptr nonnull align 1 %aptr.i7861683, i64 %alen.i774, i1 false)
  %dst_b.i798 = getelementptr inbounds nuw i8, ptr %hp.i793, i64 %alen.i774
  store i8 44, ptr %dst_b.i798, align 1
  %pref32.i799 = load i32, ptr %hp.i793, align 16
  %pref64.i800 = zext i32 %pref32.i799 to i64
  %pref_sh.i801 = shl nuw i64 %pref64.i800, 32
  %w0_out.i802 = or disjoint i64 %pref_sh.i801, %tot.i778
  %ls0.i803 = insertvalue %ArchxStr poison, i64 %w0_out.i802, 0
  %ls1.i804 = insertvalue %ArchxStr %ls0.i803, i64 %htagged.i797, 1
  br label %archx_str_concat.exit822

archx_str_concat.exit822:                         ; preds = %archx_str_concat.exit768, %build_sso.i807, %copy_long.i795
  %common.ret.op.i805 = phi %ArchxStr [ %rs1.i815, %build_sso.i807 ], [ %ls1.i804, %copy_long.i795 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit768 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i769)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i771)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i.i1427)
  %n32.i.i1429 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i.i1427, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %ifexpr.res.35.0)
  %len.i.i = sext i32 %n32.i.i1429 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i.i1426)
  %z.i.i.i1430 = icmp slt i32 %n32.i.i1429, 1
  br i1 %z.i.i.i1430, label %archx_any_to_str.exit, label %chk_sso.i.i.i1431

oom.i.i.i1447:                                    ; preds = %alloc_heap.i.i.i1433
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i.i1431:                                ; preds = %archx_str_concat.exit822
  %short.i.i.i1432 = icmp samesign ult i32 %n32.i.i1429, 13
  br i1 %short.i.i.i1432, label %pack_sso.i.i.i1448, label %alloc_heap.i.i.i1433

pack_sso.i.i.i1448:                               ; preds = %chk_sso.i.i.i1431
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i.i1426, i8 0, i64 16, i1 false)
  store i32 %n32.i.i1429, ptr %sso.i.i.i1426, align 8
  %sso.i.i.i1426.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i1426, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.i1426.4.sroa_idx, ptr nonnull readonly align 8 %buf.i.i1427, i64 %len.i.i, i1 false)
  %sso.i.i.i1426.0.sso.i.i.i1426.0.sso.i.i.i1426.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i.i1449 = load i64, ptr %sso.i.i.i1426, align 8
  %sso.i.i.i1426.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i1426, i64 8
  %sso.i.i.i1426.8.sso.i.i.i1426.8.sso.i.i.i1426.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i.i1450 = load i64, ptr %sso.i.i.i1426.8.sroa_idx, align 8
  %ss0.i.i.i1451 = insertvalue %ArchxStr poison, i64 %sso.i.i.i1426.0.sso.i.i.i1426.0.sso.i.i.i1426.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i.i1449, 0
  %ss1.i.i.i1452 = insertvalue %ArchxStr %ss0.i.i.i1451, i64 %sso.i.i.i1426.8.sso.i.i.i1426.8.sso.i.i.i1426.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i.i1450, 1
  br label %archx_any_to_str.exit

alloc_heap.i.i.i1433:                             ; preds = %chk_sso.i.i.i1431
  %hp.i.i.i1434 = call noalias align 16 ptr @malloc(i64 %len.i.i)
  %hnull.i.i.i1435 = icmp eq ptr %hp.i.i.i1434, null
  br i1 %hnull.i.i.i1435, label %oom.i.i.i1447, label %copy_long.i.i.i1436

copy_long.i.i.i1436:                              ; preds = %alloc_heap.i.i.i1433
  %hp_i.i.i.i1437 = ptrtoint ptr %hp.i.i.i1434 to i64
  %htagged.i.i.i1438 = or disjoint i64 %hp_i.i.i.i1437, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i.i1434, ptr nonnull readonly align 8 %buf.i.i1427, i64 %len.i.i, i1 false)
  %pref32.i.i.i1439 = load i32, ptr %hp.i.i.i1434, align 16
  %pref64.i.i.i1440 = zext i32 %pref32.i.i.i1439 to i64
  %pref_sh.i.i.i1441 = shl nuw i64 %pref64.i.i.i1440, 32
  %w0_out.i.i.i1442 = or disjoint i64 %pref_sh.i.i.i1441, %len.i.i
  %ls0.i.i.i1443 = insertvalue %ArchxStr poison, i64 %w0_out.i.i.i1442, 0
  %ls1.i.i.i1444 = insertvalue %ArchxStr %ls0.i.i.i1443, i64 %htagged.i.i.i1438, 1
  br label %archx_any_to_str.exit

archx_any_to_str.exit:                            ; preds = %archx_str_concat.exit822, %pack_sso.i.i.i1448, %copy_long.i.i.i1436
  %common.ret.op.i.i.i1446 = phi %ArchxStr [ %ss1.i.i.i1452, %pack_sso.i.i.i1448 ], [ %ls1.i.i.i1444, %copy_long.i.i.i1436 ], [ zeroinitializer, %archx_str_concat.exit822 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i.i1426)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i.i1427)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i823)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i824)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i825)
  %aw0.i826 = extractvalue %ArchxStr %common.ret.op.i805, 0
  %aw1.i827 = extractvalue %ArchxStr %common.ret.op.i805, 1
  %bw0.i828 = extractvalue %ArchxStr %common.ret.op.i.i.i1446, 0
  %bw1.i829 = extractvalue %ArchxStr %common.ret.op.i.i.i1446, 1
  %alen.i830 = and i64 %aw0.i826, 4294967295
  %blen.i831 = and i64 %bw0.i828, 4294967295
  %az.i832 = icmp eq i64 %alen.i830, 0
  br i1 %az.i832, label %ret_b_clone.i886, label %chk_bz.i833

ret_b_clone.i886:                                 ; preds = %archx_any_to_str.exit
  %long.i1455 = icmp samesign ult i64 %blen.i831, 13
  %tag.i1459 = and i64 %bw1.i829, 3
  %owned.not.i1460 = icmp eq i64 %tag.i1459, 0
  %or.cond1698 = select i1 %long.i1455, i1 true, i1 %owned.not.i1460
  br i1 %or.cond1698, label %archx_str_concat.exit888, label %dup_heap.i1461

dup_heap.i1461:                                   ; preds = %ret_b_clone.i886
  %dst.i1462 = call noalias align 16 ptr @malloc(i64 %blen.i831)
  %isnull.i1463 = icmp eq ptr %dst.i1462, null
  br i1 %isnull.i1463, label %oom.i1470, label %copy.i1464

oom.i1470:                                        ; preds = %dup_heap.i1461
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1464:                                       ; preds = %dup_heap.i1461
  %src_i.i1465 = and i64 %bw1.i829, -4
  %src.i1466 = inttoptr i64 %src_i.i1465 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1462, ptr nonnull align 4 %src.i1466, i64 %blen.i831, i1 false)
  %dst_i.i1467 = ptrtoint ptr %dst.i1462 to i64
  %tagged.i1468 = or disjoint i64 %dst_i.i1467, 1
  %out.i1469 = insertvalue %ArchxStr %common.ret.op.i.i.i1446, i64 %tagged.i1468, 1
  br label %archx_str_concat.exit888

chk_bz.i833:                                      ; preds = %archx_any_to_str.exit
  %bz.i834 = icmp eq i64 %blen.i831, 0
  br i1 %bz.i834, label %ret_a_clone.i884, label %calc_tot.i835

ret_a_clone.i884:                                 ; preds = %chk_bz.i833
  %long.i1474 = icmp samesign ult i64 %alen.i830, 13
  %tag.i1478 = and i64 %aw1.i827, 3
  %owned.not.i1479 = icmp eq i64 %tag.i1478, 0
  %or.cond1699 = select i1 %long.i1474, i1 true, i1 %owned.not.i1479
  br i1 %or.cond1699, label %archx_str_concat.exit888, label %dup_heap.i1480

dup_heap.i1480:                                   ; preds = %ret_a_clone.i884
  %dst.i1481 = call noalias align 16 ptr @malloc(i64 %alen.i830)
  %isnull.i1482 = icmp eq ptr %dst.i1481, null
  br i1 %isnull.i1482, label %oom.i1489, label %copy.i1483

oom.i1489:                                        ; preds = %dup_heap.i1480
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1483:                                       ; preds = %dup_heap.i1480
  %src_i.i1484 = and i64 %aw1.i827, -4
  %src.i1485 = inttoptr i64 %src_i.i1484 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1481, ptr nonnull align 4 %src.i1485, i64 %alen.i830, i1 false)
  %dst_i.i1486 = ptrtoint ptr %dst.i1481 to i64
  %tagged.i1487 = or disjoint i64 %dst_i.i1486, 1
  %out.i1488 = insertvalue %ArchxStr %common.ret.op.i805, i64 %tagged.i1487, 1
  br label %archx_str_concat.exit888

calc_tot.i835:                                    ; preds = %chk_bz.i833
  %tot.i836 = add nuw nsw i64 %blen.i831, %alen.i830
  %too_big.i837 = icmp samesign ugt i64 %tot.i836, 2147483647
  br i1 %too_big.i837, label %oom.i866, label %mat_a.i838

oom.i866:                                         ; preds = %alloc_heap.i852, %calc_tot.i835
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i838:                                       ; preds = %calc_tot.i835
  %ashort.i839 = icmp samesign ult i64 %alen.i830, 13
  br i1 %ashort.i839, label %mat_a_short.i880, label %mat_a_long.i840

mat_a_short.i880:                                 ; preds = %mat_a.i838
  %ap4.i881 = lshr i64 %aw0.i826, 32
  %ap4_32.i882 = trunc nuw i64 %ap4.i881 to i32
  store i32 %ap4_32.i882, ptr %atmp.i823, align 4
  %atmp4.i883 = getelementptr inbounds nuw i8, ptr %atmp.i823, i64 4
  store i64 %aw1.i827, ptr %atmp4.i883, align 4
  br label %mat_b.i843

mat_a_long.i840:                                  ; preds = %mat_a.i838
  %araw.i841 = and i64 %aw1.i827, -4
  %alptr.i842 = inttoptr i64 %araw.i841 to ptr
  br label %mat_b.i843

mat_b.i843:                                       ; preds = %mat_a_long.i840, %mat_a_short.i880
  %aptr.i844 = phi ptr [ %atmp.i823, %mat_a_short.i880 ], [ %alptr.i842, %mat_a_long.i840 ]
  %bshort.i845 = icmp samesign ult i64 %blen.i831, 13
  br i1 %bshort.i845, label %mat_b_short.i876, label %mat_b_long.i846

mat_b_short.i876:                                 ; preds = %mat_b.i843
  %bp4.i877 = lshr i64 %bw0.i828, 32
  %bp4_32.i878 = trunc nuw i64 %bp4.i877 to i32
  store i32 %bp4_32.i878, ptr %btmp.i824, align 4
  %btmp4.i879 = getelementptr inbounds nuw i8, ptr %btmp.i824, i64 4
  store i64 %bw1.i829, ptr %btmp4.i879, align 4
  br label %build.i849

mat_b_long.i846:                                  ; preds = %mat_b.i843
  %braw.i847 = and i64 %bw1.i829, -4
  %blptr.i848 = inttoptr i64 %braw.i847 to ptr
  br label %build.i849

build.i849:                                       ; preds = %mat_b_long.i846, %mat_b_short.i876
  %bptr.i850 = phi ptr [ %btmp.i824, %mat_b_short.i876 ], [ %blptr.i848, %mat_b_long.i846 ]
  %fits_sso.i851 = icmp samesign ult i64 %tot.i836, 13
  br i1 %fits_sso.i851, label %build_sso.i867, label %alloc_heap.i852

build_sso.i867:                                   ; preds = %build.i849
  %out_sso8.i868 = getelementptr inbounds nuw i8, ptr %out_sso.i825, i64 8
  %tot32.i869 = trunc nuw nsw i64 %tot.i836 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i825, i8 0, i64 16, i1 false)
  store i32 %tot32.i869, ptr %out_sso.i825, align 8
  %sso_dst_a.i870 = getelementptr inbounds nuw i8, ptr %out_sso.i825, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i870, ptr nonnull align 1 %aptr.i844, i64 %alen.i830, i1 false)
  %sso_dst_b.i871 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i870, i64 %alen.i830
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i871, ptr nonnull align 1 %bptr.i850, i64 %blen.i831, i1 false)
  %rw0.i872 = load i64, ptr %out_sso.i825, align 8
  %rw1.i873 = load i64, ptr %out_sso8.i868, align 8
  %rs0.i874 = insertvalue %ArchxStr poison, i64 %rw0.i872, 0
  %rs1.i875 = insertvalue %ArchxStr %rs0.i874, i64 %rw1.i873, 1
  br label %archx_str_concat.exit888

alloc_heap.i852:                                  ; preds = %build.i849
  %hp.i853 = call noalias align 16 ptr @malloc(i64 %tot.i836)
  %hnull.i854 = icmp eq ptr %hp.i853, null
  br i1 %hnull.i854, label %oom.i866, label %copy_long.i855

copy_long.i855:                                   ; preds = %alloc_heap.i852
  %hp_i.i856 = ptrtoint ptr %hp.i853 to i64
  %htagged.i857 = or disjoint i64 %hp_i.i856, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i853, ptr nonnull align 1 %aptr.i844, i64 %alen.i830, i1 false)
  %dst_b.i858 = getelementptr inbounds nuw i8, ptr %hp.i853, i64 %alen.i830
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i858, ptr nonnull align 1 %bptr.i850, i64 %blen.i831, i1 false)
  %pref32.i859 = load i32, ptr %hp.i853, align 16
  %pref64.i860 = zext i32 %pref32.i859 to i64
  %pref_sh.i861 = shl nuw i64 %pref64.i860, 32
  %w0_out.i862 = or disjoint i64 %pref_sh.i861, %tot.i836
  %ls0.i863 = insertvalue %ArchxStr poison, i64 %w0_out.i862, 0
  %ls1.i864 = insertvalue %ArchxStr %ls0.i863, i64 %htagged.i857, 1
  br label %archx_str_concat.exit888

archx_str_concat.exit888:                         ; preds = %copy.i1483, %ret_a_clone.i884, %copy.i1464, %ret_b_clone.i886, %build_sso.i867, %copy_long.i855
  %common.ret.op.i865 = phi %ArchxStr [ %rs1.i875, %build_sso.i867 ], [ %ls1.i864, %copy_long.i855 ], [ %out.i1469, %copy.i1464 ], [ %common.ret.op.i.i.i1446, %ret_b_clone.i886 ], [ %out.i1488, %copy.i1483 ], [ %common.ret.op.i805, %ret_a_clone.i884 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i823)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i824)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i825)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i889)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i891)
  %aw0.i892 = extractvalue %ArchxStr %common.ret.op.i865, 0
  %aw1.i893 = extractvalue %ArchxStr %common.ret.op.i865, 1
  %alen.i894 = and i64 %aw0.i892, 4294967295
  %az.i895 = icmp eq i64 %alen.i894, 0
  br i1 %az.i895, label %archx_str_concat.exit942, label %chk_bz.i896

chk_bz.i896:                                      ; preds = %archx_str_concat.exit888
  %tot.i898 = add nuw nsw i64 %alen.i894, 1
  %too_big.i899 = icmp samesign ugt i64 %alen.i894, 2147483646
  br i1 %too_big.i899, label %oom.i926, label %mat_a.i900

oom.i926:                                         ; preds = %alloc_heap.i912, %chk_bz.i896
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i900:                                       ; preds = %chk_bz.i896
  %ashort.i901 = icmp samesign ult i64 %alen.i894, 13
  br i1 %ashort.i901, label %mat_b.i905, label %mat_b.i905.thread

mat_b.i905.thread:                                ; preds = %mat_a.i900
  %araw.i903 = and i64 %aw1.i893, -4
  %alptr.i904 = inttoptr i64 %araw.i903 to ptr
  br label %alloc_heap.i912

mat_b.i905:                                       ; preds = %mat_a.i900
  %ap4.i937 = lshr i64 %aw0.i892, 32
  %ap4_32.i938 = trunc nuw i64 %ap4.i937 to i32
  store i32 %ap4_32.i938, ptr %atmp.i889, align 4
  %atmp4.i939 = getelementptr inbounds nuw i8, ptr %atmp.i889, i64 4
  store i64 %aw1.i893, ptr %atmp4.i939, align 4
  %fits_sso.i911.not = icmp eq i64 %alen.i894, 12
  br i1 %fits_sso.i911.not, label %alloc_heap.i912, label %build_sso.i927

build_sso.i927:                                   ; preds = %mat_b.i905
  %out_sso8.i928 = getelementptr inbounds nuw i8, ptr %out_sso.i891, i64 8
  %tot32.i929 = trunc nuw nsw i64 %tot.i898 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i891, i8 0, i64 16, i1 false)
  store i32 %tot32.i929, ptr %out_sso.i891, align 8
  %sso_dst_a.i930 = getelementptr inbounds nuw i8, ptr %out_sso.i891, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i930, ptr nonnull align 4 %atmp.i889, i64 %alen.i894, i1 false)
  %sso_dst_b.i931 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i930, i64 %alen.i894
  store i8 44, ptr %sso_dst_b.i931, align 1
  %rw0.i932 = load i64, ptr %out_sso.i891, align 8
  %rw1.i933 = load i64, ptr %out_sso8.i928, align 8
  %rs0.i934 = insertvalue %ArchxStr poison, i64 %rw0.i932, 0
  %rs1.i935 = insertvalue %ArchxStr %rs0.i934, i64 %rw1.i933, 1
  br label %archx_str_concat.exit942

alloc_heap.i912:                                  ; preds = %mat_b.i905.thread, %mat_b.i905
  %aptr.i9061686 = phi ptr [ %alptr.i904, %mat_b.i905.thread ], [ %atmp.i889, %mat_b.i905 ]
  %hp.i913 = call noalias align 16 ptr @malloc(i64 %tot.i898)
  %hnull.i914 = icmp eq ptr %hp.i913, null
  br i1 %hnull.i914, label %oom.i926, label %copy_long.i915

copy_long.i915:                                   ; preds = %alloc_heap.i912
  %hp_i.i916 = ptrtoint ptr %hp.i913 to i64
  %htagged.i917 = or disjoint i64 %hp_i.i916, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i913, ptr nonnull align 1 %aptr.i9061686, i64 %alen.i894, i1 false)
  %dst_b.i918 = getelementptr inbounds nuw i8, ptr %hp.i913, i64 %alen.i894
  store i8 44, ptr %dst_b.i918, align 1
  %pref32.i919 = load i32, ptr %hp.i913, align 16
  %pref64.i920 = zext i32 %pref32.i919 to i64
  %pref_sh.i921 = shl nuw i64 %pref64.i920, 32
  %w0_out.i922 = or disjoint i64 %pref_sh.i921, %tot.i898
  %ls0.i923 = insertvalue %ArchxStr poison, i64 %w0_out.i922, 0
  %ls1.i924 = insertvalue %ArchxStr %ls0.i923, i64 %htagged.i917, 1
  br label %archx_str_concat.exit942

archx_str_concat.exit942:                         ; preds = %archx_str_concat.exit888, %build_sso.i927, %copy_long.i915
  %common.ret.op.i925 = phi %ArchxStr [ %rs1.i935, %build_sso.i927 ], [ %ls1.i924, %copy_long.i915 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit888 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i889)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i891)
  %t74.fca.0.insert = insertvalue %ArchxStr poison, i64 %var.miss_label.40.sroa.0.0, 0
  %t74.fca.1.insert = insertvalue %ArchxStr %t74.fca.0.insert, i64 %var.miss_label.40.sroa.7.0, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i943)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i944)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i945)
  %aw0.i946 = extractvalue %ArchxStr %common.ret.op.i925, 0
  %aw1.i947 = extractvalue %ArchxStr %common.ret.op.i925, 1
  %alen.i950 = and i64 %aw0.i946, 4294967295
  %blen.i951 = and i64 %var.miss_label.40.sroa.0.0, 4294967295
  %az.i952 = icmp eq i64 %alen.i950, 0
  br i1 %az.i952, label %ret_b_clone.i1006, label %chk_bz.i953

ret_b_clone.i1006:                                ; preds = %archx_str_concat.exit942
  %long.i1494 = icmp samesign ult i64 %blen.i951, 13
  %tag.i1498 = and i64 %var.miss_label.40.sroa.7.0, 3
  %owned.not.i1499 = icmp eq i64 %tag.i1498, 0
  %or.cond1700 = select i1 %long.i1494, i1 true, i1 %owned.not.i1499
  br i1 %or.cond1700, label %archx_str_concat.exit1008, label %dup_heap.i1500

dup_heap.i1500:                                   ; preds = %ret_b_clone.i1006
  %dst.i1501 = call noalias align 16 ptr @malloc(i64 %blen.i951)
  %isnull.i1502 = icmp eq ptr %dst.i1501, null
  br i1 %isnull.i1502, label %oom.i1509, label %copy.i1503

oom.i1509:                                        ; preds = %dup_heap.i1500
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1503:                                       ; preds = %dup_heap.i1500
  %src_i.i1504 = and i64 %var.miss_label.40.sroa.7.0, -4
  %src.i1505 = inttoptr i64 %src_i.i1504 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1501, ptr nonnull align 4 %src.i1505, i64 %blen.i951, i1 false)
  %dst_i.i1506 = ptrtoint ptr %dst.i1501 to i64
  %tagged.i1507 = or disjoint i64 %dst_i.i1506, 1
  %out.i1508 = insertvalue %ArchxStr %t74.fca.1.insert, i64 %tagged.i1507, 1
  br label %archx_str_concat.exit1008

chk_bz.i953:                                      ; preds = %archx_str_concat.exit942
  %bz.i954 = icmp eq i64 %blen.i951, 0
  br i1 %bz.i954, label %ret_a_clone.i1004, label %calc_tot.i955

ret_a_clone.i1004:                                ; preds = %chk_bz.i953
  %long.i1513 = icmp samesign ult i64 %alen.i950, 13
  %tag.i1517 = and i64 %aw1.i947, 3
  %owned.not.i1518 = icmp eq i64 %tag.i1517, 0
  %or.cond1701 = select i1 %long.i1513, i1 true, i1 %owned.not.i1518
  br i1 %or.cond1701, label %archx_str_concat.exit1008, label %dup_heap.i1519

dup_heap.i1519:                                   ; preds = %ret_a_clone.i1004
  %dst.i1520 = call noalias align 16 ptr @malloc(i64 %alen.i950)
  %isnull.i1521 = icmp eq ptr %dst.i1520, null
  br i1 %isnull.i1521, label %oom.i1528, label %copy.i1522

oom.i1528:                                        ; preds = %dup_heap.i1519
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1522:                                       ; preds = %dup_heap.i1519
  %src_i.i1523 = and i64 %aw1.i947, -4
  %src.i1524 = inttoptr i64 %src_i.i1523 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1520, ptr nonnull align 4 %src.i1524, i64 %alen.i950, i1 false)
  %dst_i.i1525 = ptrtoint ptr %dst.i1520 to i64
  %tagged.i1526 = or disjoint i64 %dst_i.i1525, 1
  %out.i1527 = insertvalue %ArchxStr %common.ret.op.i925, i64 %tagged.i1526, 1
  br label %archx_str_concat.exit1008

calc_tot.i955:                                    ; preds = %chk_bz.i953
  %tot.i956 = add nuw nsw i64 %alen.i950, %blen.i951
  %too_big.i957 = icmp samesign ugt i64 %tot.i956, 2147483647
  br i1 %too_big.i957, label %oom.i986, label %mat_a.i958

oom.i986:                                         ; preds = %alloc_heap.i972, %calc_tot.i955
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i958:                                       ; preds = %calc_tot.i955
  %ashort.i959 = icmp samesign ult i64 %alen.i950, 13
  br i1 %ashort.i959, label %mat_a_short.i1000, label %mat_a_long.i960

mat_a_short.i1000:                                ; preds = %mat_a.i958
  %ap4.i1001 = lshr i64 %aw0.i946, 32
  %ap4_32.i1002 = trunc nuw i64 %ap4.i1001 to i32
  store i32 %ap4_32.i1002, ptr %atmp.i943, align 4
  %atmp4.i1003 = getelementptr inbounds nuw i8, ptr %atmp.i943, i64 4
  store i64 %aw1.i947, ptr %atmp4.i1003, align 4
  br label %mat_b.i963

mat_a_long.i960:                                  ; preds = %mat_a.i958
  %araw.i961 = and i64 %aw1.i947, -4
  %alptr.i962 = inttoptr i64 %araw.i961 to ptr
  br label %mat_b.i963

mat_b.i963:                                       ; preds = %mat_a_long.i960, %mat_a_short.i1000
  %aptr.i964 = phi ptr [ %atmp.i943, %mat_a_short.i1000 ], [ %alptr.i962, %mat_a_long.i960 ]
  %bshort.i965 = icmp samesign ult i64 %blen.i951, 13
  br i1 %bshort.i965, label %mat_b_short.i996, label %mat_b_long.i966

mat_b_short.i996:                                 ; preds = %mat_b.i963
  %bp4.i997 = lshr i64 %var.miss_label.40.sroa.0.0, 32
  %bp4_32.i998 = trunc nuw nsw i64 %bp4.i997 to i32
  store i32 %bp4_32.i998, ptr %btmp.i944, align 4
  %btmp4.i999 = getelementptr inbounds nuw i8, ptr %btmp.i944, i64 4
  store i64 %var.miss_label.40.sroa.7.0, ptr %btmp4.i999, align 4
  br label %build.i969

mat_b_long.i966:                                  ; preds = %mat_b.i963
  %braw.i967 = and i64 %var.miss_label.40.sroa.7.0, -4
  %blptr.i968 = inttoptr i64 %braw.i967 to ptr
  br label %build.i969

build.i969:                                       ; preds = %mat_b_long.i966, %mat_b_short.i996
  %bptr.i970 = phi ptr [ %btmp.i944, %mat_b_short.i996 ], [ %blptr.i968, %mat_b_long.i966 ]
  %fits_sso.i971 = icmp samesign ult i64 %tot.i956, 13
  br i1 %fits_sso.i971, label %build_sso.i987, label %alloc_heap.i972

build_sso.i987:                                   ; preds = %build.i969
  %out_sso8.i988 = getelementptr inbounds nuw i8, ptr %out_sso.i945, i64 8
  %tot32.i989 = trunc nuw nsw i64 %tot.i956 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i945, i8 0, i64 16, i1 false)
  store i32 %tot32.i989, ptr %out_sso.i945, align 8
  %sso_dst_a.i990 = getelementptr inbounds nuw i8, ptr %out_sso.i945, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i990, ptr nonnull align 1 %aptr.i964, i64 %alen.i950, i1 false)
  %sso_dst_b.i991 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i990, i64 %alen.i950
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i991, ptr nonnull align 1 %bptr.i970, i64 %blen.i951, i1 false)
  %rw0.i992 = load i64, ptr %out_sso.i945, align 8
  %rw1.i993 = load i64, ptr %out_sso8.i988, align 8
  %rs0.i994 = insertvalue %ArchxStr poison, i64 %rw0.i992, 0
  %rs1.i995 = insertvalue %ArchxStr %rs0.i994, i64 %rw1.i993, 1
  br label %archx_str_concat.exit1008

alloc_heap.i972:                                  ; preds = %build.i969
  %hp.i973 = call noalias align 16 ptr @malloc(i64 %tot.i956)
  %hnull.i974 = icmp eq ptr %hp.i973, null
  br i1 %hnull.i974, label %oom.i986, label %copy_long.i975

copy_long.i975:                                   ; preds = %alloc_heap.i972
  %hp_i.i976 = ptrtoint ptr %hp.i973 to i64
  %htagged.i977 = or disjoint i64 %hp_i.i976, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i973, ptr nonnull align 1 %aptr.i964, i64 %alen.i950, i1 false)
  %dst_b.i978 = getelementptr inbounds nuw i8, ptr %hp.i973, i64 %alen.i950
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i978, ptr nonnull align 1 %bptr.i970, i64 %blen.i951, i1 false)
  %pref32.i979 = load i32, ptr %hp.i973, align 16
  %pref64.i980 = zext i32 %pref32.i979 to i64
  %pref_sh.i981 = shl nuw i64 %pref64.i980, 32
  %w0_out.i982 = or disjoint i64 %pref_sh.i981, %tot.i956
  %ls0.i983 = insertvalue %ArchxStr poison, i64 %w0_out.i982, 0
  %ls1.i984 = insertvalue %ArchxStr %ls0.i983, i64 %htagged.i977, 1
  br label %archx_str_concat.exit1008

archx_str_concat.exit1008:                        ; preds = %copy.i1522, %ret_a_clone.i1004, %copy.i1503, %ret_b_clone.i1006, %build_sso.i987, %copy_long.i975
  %common.ret.op.i985 = phi %ArchxStr [ %rs1.i995, %build_sso.i987 ], [ %ls1.i984, %copy_long.i975 ], [ %out.i1508, %copy.i1503 ], [ %t74.fca.1.insert, %ret_b_clone.i1006 ], [ %out.i1527, %copy.i1522 ], [ %common.ret.op.i925, %ret_a_clone.i1004 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i943)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i944)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i945)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1530)
  %w0.i1531 = extractvalue %ArchxStr %common.ret.op.i985, 0
  %w1.i1532 = extractvalue %ArchxStr %common.ret.op.i985, 1
  %len.i1533 = and i64 %w0.i1531, 4294967295
  %short.i1534 = icmp samesign ult i64 %len.i1533, 13
  br i1 %short.i1534, label %emit.i1555, label %emit.thread.i1535

emit.thread.i1535:                                ; preds = %archx_str_concat.exit1008
  %raw.i1536 = and i64 %w1.i1532, -4
  %lptr.i1537 = inttoptr i64 %raw.i1536 to ptr
  br label %chk_nul.i1538

emit.i1555:                                       ; preds = %archx_str_concat.exit1008
  %p4.i1556 = lshr i64 %w0.i1531, 32
  %p4_32.i1557 = trunc nuw i64 %p4.i1556 to i32
  store i32 %p4_32.i1557, ptr %tmp.i1530, align 4
  %tmp4.i1558 = getelementptr inbounds nuw i8, ptr %tmp.i1530, i64 4
  store i64 %w1.i1532, ptr %tmp4.i1558, align 4
  %pos.not.i1559 = icmp eq i64 %len.i1533, 0
  br i1 %pos.not.i1559, label %do_nl.i1550, label %chk_nul.i1538

chk_nul.i1538:                                    ; preds = %emit.i1555, %emit.thread.i1535
  %data3.i1539 = phi ptr [ %lptr.i1537, %emit.thread.i1535 ], [ %tmp.i1530, %emit.i1555 ]
  %nul.i1540 = call ptr @memchr(ptr nonnull %data3.i1539, i32 0, i64 %len.i1533)
  %has_nul.not.i1541 = icmp eq ptr %nul.i1540, null
  br i1 %has_nul.not.i1541, label %fast_printf.i1552, label %byte_loop.i1542

fast_printf.i1552:                                ; preds = %chk_nul.i1538
  %len32.i1553 = trunc i64 %w0.i1531 to i32
  %np.i1554 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1553, ptr nonnull %data3.i1539)
  br label %archx_str_print.exit1560

byte_loop.i1542:                                  ; preds = %chk_nul.i1538, %byte_loop.i1542
  %bi.i1543 = phi i64 [ %bnext.i1548, %byte_loop.i1542 ], [ 0, %chk_nul.i1538 ]
  %bp.i1544 = getelementptr inbounds nuw i8, ptr %data3.i1539, i64 %bi.i1543
  %ch8.i1545 = load i8, ptr %bp.i1544, align 1
  %ch32.i1546 = zext i8 %ch8.i1545 to i32
  %pc.i1547 = call i32 @putchar(i32 %ch32.i1546)
  %bnext.i1548 = add nuw nsw i64 %bi.i1543, 1
  %exitcond.not.i1549 = icmp eq i64 %bnext.i1548, %len.i1533
  br i1 %exitcond.not.i1549, label %do_nl.i1550, label %byte_loop.i1542

do_nl.i1550:                                      ; preds = %byte_loop.i1542, %emit.i1555
  %nc.i1551 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1560

archx_str_print.exit1560:                         ; preds = %fast_printf.i1552, %do_nl.i1550
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1530)
  %tag.i89 = and i64 %w1.i1532, 1
  %owned.not.i90 = icmp eq i64 %tag.i89, 0
  %or.cond1702 = select i1 %short.i1534, i1 true, i1 %owned.not.i90
  br i1 %or.cond1702, label %archx_str_drop.exit94, label %do_free.i91

do_free.i91:                                      ; preds = %archx_str_print.exit1560
  %raw.i92 = and i64 %w1.i1532, -2
  %ptr.i93 = inttoptr i64 %raw.i92 to ptr
  call void @free(ptr %ptr.i93)
  br label %archx_str_drop.exit94

archx_str_drop.exit94:                            ; preds = %archx_str_print.exit1560, %do_free.i91
  %long.i97 = icmp samesign ult i64 %alen.i950, 13
  %tag.i100 = and i64 %aw1.i947, 1
  %owned.not.i101 = icmp eq i64 %tag.i100, 0
  %or.cond1703 = select i1 %long.i97, i1 true, i1 %owned.not.i101
  br i1 %or.cond1703, label %archx_str_drop.exit105, label %do_free.i102

do_free.i102:                                     ; preds = %archx_str_drop.exit94
  %raw.i103 = and i64 %aw1.i947, -2
  %ptr.i104 = inttoptr i64 %raw.i103 to ptr
  call void @free(ptr %ptr.i104)
  br label %archx_str_drop.exit105

archx_str_drop.exit105:                           ; preds = %archx_str_drop.exit94, %do_free.i102
  %long.i108 = icmp samesign ult i64 %alen.i894, 13
  %tag.i111 = and i64 %aw1.i893, 1
  %owned.not.i112 = icmp eq i64 %tag.i111, 0
  %or.cond1704 = select i1 %long.i108, i1 true, i1 %owned.not.i112
  br i1 %or.cond1704, label %archx_str_drop.exit116, label %do_free.i113

do_free.i113:                                     ; preds = %archx_str_drop.exit105
  %raw.i114 = and i64 %aw1.i893, -2
  %ptr.i115 = inttoptr i64 %raw.i114 to ptr
  call void @free(ptr %ptr.i115)
  br label %archx_str_drop.exit116

archx_str_drop.exit116:                           ; preds = %archx_str_drop.exit105, %do_free.i113
  %long.i119 = icmp samesign ult i64 %blen.i831, 13
  %tag.i122 = and i64 %bw1.i829, 1
  %owned.not.i123 = icmp eq i64 %tag.i122, 0
  %or.cond1705 = select i1 %long.i119, i1 true, i1 %owned.not.i123
  br i1 %or.cond1705, label %archx_str_drop.exit127, label %do_free.i124

do_free.i124:                                     ; preds = %archx_str_drop.exit116
  %raw.i125 = and i64 %bw1.i829, -2
  %ptr.i126 = inttoptr i64 %raw.i125 to ptr
  call void @free(ptr %ptr.i126)
  br label %archx_str_drop.exit127

archx_str_drop.exit127:                           ; preds = %archx_str_drop.exit116, %do_free.i124
  %long.i130 = icmp samesign ult i64 %alen.i830, 13
  %tag.i133 = and i64 %aw1.i827, 1
  %owned.not.i134 = icmp eq i64 %tag.i133, 0
  %or.cond1706 = select i1 %long.i130, i1 true, i1 %owned.not.i134
  br i1 %or.cond1706, label %archx_str_drop.exit138, label %do_free.i135

do_free.i135:                                     ; preds = %archx_str_drop.exit127
  %raw.i136 = and i64 %aw1.i827, -2
  %ptr.i137 = inttoptr i64 %raw.i136 to ptr
  call void @free(ptr %ptr.i137)
  br label %archx_str_drop.exit138

archx_str_drop.exit138:                           ; preds = %archx_str_drop.exit127, %do_free.i135
  %long.i141 = icmp samesign ult i64 %alen.i774, 13
  %tag.i144 = and i64 %aw1.i773, 1
  %owned.not.i145 = icmp eq i64 %tag.i144, 0
  %or.cond1707 = select i1 %long.i141, i1 true, i1 %owned.not.i145
  br i1 %or.cond1707, label %archx_str_drop.exit149, label %do_free.i146

do_free.i146:                                     ; preds = %archx_str_drop.exit138
  %raw.i147 = and i64 %aw1.i773, -2
  %ptr.i148 = inttoptr i64 %raw.i147 to ptr
  call void @free(ptr %ptr.i148)
  br label %archx_str_drop.exit149

archx_str_drop.exit149:                           ; preds = %archx_str_drop.exit138, %do_free.i146
  %long.i152 = icmp samesign ult i64 %blen.i711, 13
  %tag.i155 = and i64 %bw1.i709, 1
  %owned.not.i156 = icmp eq i64 %tag.i155, 0
  %or.cond1708 = select i1 %long.i152, i1 true, i1 %owned.not.i156
  br i1 %or.cond1708, label %archx_str_drop.exit160, label %do_free.i157

do_free.i157:                                     ; preds = %archx_str_drop.exit149
  %raw.i158 = and i64 %bw1.i709, -2
  %ptr.i159 = inttoptr i64 %raw.i158 to ptr
  call void @free(ptr %ptr.i159)
  br label %archx_str_drop.exit160

archx_str_drop.exit160:                           ; preds = %archx_str_drop.exit149, %do_free.i157
  %long.i163 = icmp samesign ult i64 %alen.i710, 13
  %tag.i166 = and i64 %aw1.i707, 1
  %owned.not.i167 = icmp eq i64 %tag.i166, 0
  %or.cond1709 = select i1 %long.i163, i1 true, i1 %owned.not.i167
  br i1 %or.cond1709, label %archx_str_drop.exit171, label %do_free.i168

do_free.i168:                                     ; preds = %archx_str_drop.exit160
  %raw.i169 = and i64 %aw1.i707, -2
  %ptr.i170 = inttoptr i64 %raw.i169 to ptr
  call void @free(ptr %ptr.i170)
  br label %archx_str_drop.exit171

archx_str_drop.exit171:                           ; preds = %archx_str_drop.exit160, %do_free.i168
  %long.i174 = icmp samesign ult i64 %alen.i654, 13
  %tag.i177 = and i64 %aw1.i653, 1
  %owned.not.i178 = icmp eq i64 %tag.i177, 0
  %or.cond1710 = select i1 %long.i174, i1 true, i1 %owned.not.i178
  br i1 %or.cond1710, label %archx_str_drop.exit182, label %do_free.i179

do_free.i179:                                     ; preds = %archx_str_drop.exit171
  %raw.i180 = and i64 %aw1.i653, -2
  %ptr.i181 = inttoptr i64 %raw.i180 to ptr
  call void @free(ptr %ptr.i181)
  br label %archx_str_drop.exit182

archx_str_drop.exit182:                           ; preds = %archx_str_drop.exit171, %do_free.i179
  %long.i185 = icmp samesign ult i64 %blen.i591, 13
  %tag.i188 = and i64 %bw1.i589, 1
  %owned.not.i189 = icmp eq i64 %tag.i188, 0
  %or.cond1711 = select i1 %long.i185, i1 true, i1 %owned.not.i189
  br i1 %or.cond1711, label %archx_str_drop.exit193, label %do_free.i190

do_free.i190:                                     ; preds = %archx_str_drop.exit182
  %raw.i191 = and i64 %bw1.i589, -2
  %ptr.i192 = inttoptr i64 %raw.i191 to ptr
  call void @free(ptr %ptr.i192)
  br label %archx_str_drop.exit193

archx_str_drop.exit193:                           ; preds = %archx_str_drop.exit182, %do_free.i190
  %long.i196 = icmp samesign ult i64 %alen.i590, 13
  %tag.i199 = and i64 %aw1.i587, 1
  %owned.not.i200 = icmp eq i64 %tag.i199, 0
  %or.cond1712 = select i1 %long.i196, i1 true, i1 %owned.not.i200
  br i1 %or.cond1712, label %archx_str_drop.exit204, label %do_free.i201

do_free.i201:                                     ; preds = %archx_str_drop.exit193
  %raw.i202 = and i64 %aw1.i587, -2
  %ptr.i203 = inttoptr i64 %raw.i202 to ptr
  call void @free(ptr %ptr.i203)
  br label %archx_str_drop.exit204

archx_str_drop.exit204:                           ; preds = %archx_str_drop.exit193, %do_free.i201
  %long.i207 = icmp samesign ult i64 %alen.i534, 13
  %tag.i210 = and i64 %aw1.i533, 1
  %owned.not.i211 = icmp eq i64 %tag.i210, 0
  %or.cond1713 = select i1 %long.i207, i1 true, i1 %owned.not.i211
  br i1 %or.cond1713, label %archx_str_drop.exit215, label %do_free.i212

do_free.i212:                                     ; preds = %archx_str_drop.exit204
  %raw.i213 = and i64 %aw1.i533, -2
  %ptr.i214 = inttoptr i64 %raw.i213 to ptr
  call void @free(ptr %ptr.i214)
  br label %archx_str_drop.exit215

archx_str_drop.exit215:                           ; preds = %archx_str_drop.exit204, %do_free.i212
  %long.i218 = icmp samesign ult i64 %blen.i480, 13
  %tag.i221 = and i64 %bw1.i479, 1
  %owned.not.i222 = icmp eq i64 %tag.i221, 0
  %or.cond1714 = select i1 %long.i218, i1 true, i1 %owned.not.i222
  br i1 %or.cond1714, label %archx_str_drop.exit226, label %do_free.i223

do_free.i223:                                     ; preds = %archx_str_drop.exit215
  %raw.i224 = and i64 %bw1.i479, -2
  %ptr.i225 = inttoptr i64 %raw.i224 to ptr
  call void @free(ptr %ptr.i225)
  br label %archx_str_drop.exit226

archx_str_drop.exit226:                           ; preds = %archx_str_drop.exit215, %do_free.i223
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1562)
  %n32.i1563 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1562, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %var.acc.0.1.i)
  %len.i1564 = sext i32 %n32.i1563 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1561)
  %z.i.i1565 = icmp slt i32 %n32.i1563, 1
  br i1 %z.i.i1565, label %archx_str_from_int.exit1589, label %chk_sso.i.i1566

oom.i.i1581:                                      ; preds = %alloc_heap.i.i1568
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1566:                                  ; preds = %archx_str_drop.exit226
  %short.i.i1567 = icmp samesign ult i32 %n32.i1563, 13
  br i1 %short.i.i1567, label %pack_sso.i.i1582, label %alloc_heap.i.i1568

pack_sso.i.i1582:                                 ; preds = %chk_sso.i.i1566
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1561, i8 0, i64 16, i1 false)
  store i32 %n32.i1563, ptr %sso.i.i1561, align 8
  %sso.i.i1561.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1561, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1561.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1562, i64 %len.i1564, i1 false)
  %sso.i.i1561.0.sso.i.i1561.0.sso.i.i1561.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1584 = load i64, ptr %sso.i.i1561, align 8
  %sso.i.i1561.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1561, i64 8
  %sso.i.i1561.8.sso.i.i1561.8.sso.i.i1561.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1586 = load i64, ptr %sso.i.i1561.8.sroa_idx, align 8
  %ss0.i.i1587 = insertvalue %ArchxStr poison, i64 %sso.i.i1561.0.sso.i.i1561.0.sso.i.i1561.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1584, 0
  %ss1.i.i1588 = insertvalue %ArchxStr %ss0.i.i1587, i64 %sso.i.i1561.8.sso.i.i1561.8.sso.i.i1561.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1586, 1
  br label %archx_str_from_int.exit1589

alloc_heap.i.i1568:                               ; preds = %chk_sso.i.i1566
  %hp.i.i1569 = call noalias align 16 ptr @malloc(i64 %len.i1564)
  %hnull.i.i1570 = icmp eq ptr %hp.i.i1569, null
  br i1 %hnull.i.i1570, label %oom.i.i1581, label %copy_long.i.i1571

copy_long.i.i1571:                                ; preds = %alloc_heap.i.i1568
  %hp_i.i.i1572 = ptrtoint ptr %hp.i.i1569 to i64
  %htagged.i.i1573 = or disjoint i64 %hp_i.i.i1572, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1569, ptr nonnull readonly align 8 %buf.i1562, i64 %len.i1564, i1 false)
  %pref32.i.i1574 = load i32, ptr %hp.i.i1569, align 16
  %pref64.i.i1575 = zext i32 %pref32.i.i1574 to i64
  %pref_sh.i.i1576 = shl nuw i64 %pref64.i.i1575, 32
  %w0_out.i.i1577 = or disjoint i64 %pref_sh.i.i1576, %len.i1564
  %ls0.i.i1578 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1577, 0
  %ls1.i.i1579 = insertvalue %ArchxStr %ls0.i.i1578, i64 %htagged.i.i1573, 1
  br label %archx_str_from_int.exit1589

archx_str_from_int.exit1589:                      ; preds = %archx_str_drop.exit226, %pack_sso.i.i1582, %copy_long.i.i1571
  %common.ret.op.i.i1580 = phi %ArchxStr [ %ss1.i.i1588, %pack_sso.i.i1582 ], [ %ls1.i.i1579, %copy_long.i.i1571 ], [ zeroinitializer, %archx_str_drop.exit226 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1561)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1562)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1010)
  %bw0.i1012 = extractvalue %ArchxStr %common.ret.op.i.i1580, 0
  %bw1.i1013 = extractvalue %ArchxStr %common.ret.op.i.i1580, 1
  %blen.i1014 = and i64 %bw0.i1012, 4294967295
  %bz.i1016 = icmp eq i64 %blen.i1014, 0
  br i1 %bz.i1016, label %archx_str_concat.exit1061, label %calc_tot.i1017

calc_tot.i1017:                                   ; preds = %archx_str_from_int.exit1589
  %tot.i1018 = add nuw nsw i64 %blen.i1014, 15
  %too_big.i1019 = icmp samesign ugt i64 %blen.i1014, 2147483632
  br i1 %too_big.i1019, label %oom.i1045, label %mat_a.i1020

oom.i1045:                                        ; preds = %alloc_heap.i1031, %calc_tot.i1017
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1020:                                      ; preds = %calc_tot.i1017
  %bshort.i1024 = icmp samesign ult i64 %blen.i1014, 13
  br i1 %bshort.i1024, label %mat_b_short.i1055, label %mat_b_long.i1025

mat_b_short.i1055:                                ; preds = %mat_a.i1020
  %bp4.i1056 = lshr i64 %bw0.i1012, 32
  %bp4_32.i1057 = trunc nuw i64 %bp4.i1056 to i32
  store i32 %bp4_32.i1057, ptr %btmp.i1010, align 4
  %btmp4.i1058 = getelementptr inbounds nuw i8, ptr %btmp.i1010, i64 4
  store i64 %bw1.i1013, ptr %btmp4.i1058, align 4
  br label %alloc_heap.i1031

mat_b_long.i1025:                                 ; preds = %mat_a.i1020
  %braw.i1026 = and i64 %bw1.i1013, -4
  %blptr.i1027 = inttoptr i64 %braw.i1026 to ptr
  br label %alloc_heap.i1031

alloc_heap.i1031:                                 ; preds = %mat_b_short.i1055, %mat_b_long.i1025
  %bptr.i1029 = phi ptr [ %btmp.i1010, %mat_b_short.i1055 ], [ %blptr.i1027, %mat_b_long.i1025 ]
  %hp.i1032 = call noalias align 16 ptr @malloc(i64 %tot.i1018)
  %hnull.i1033 = icmp eq ptr %hp.i1032, null
  br i1 %hnull.i1033, label %oom.i1045, label %copy_long.i1034

copy_long.i1034:                                  ; preds = %alloc_heap.i1031
  %hp_i.i1035 = ptrtoint ptr %hp.i1032 to i64
  %htagged.i1036 = or disjoint i64 %hp_i.i1035, 1
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(15) %hp.i1032, ptr noundef nonnull align 4 dereferenceable(15) @.str.3, i64 15, i1 false)
  %dst_b.i1037 = getelementptr inbounds nuw i8, ptr %hp.i1032, i64 15
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i1037, ptr nonnull align 1 %bptr.i1029, i64 %blen.i1014, i1 false)
  %w0_out.i1041 = or disjoint i64 %tot.i1018, 7166460027832631296
  %ls0.i1042 = insertvalue %ArchxStr poison, i64 %w0_out.i1041, 0
  %ls1.i1043 = insertvalue %ArchxStr %ls0.i1042, i64 %htagged.i1036, 1
  br label %archx_str_concat.exit1061

archx_str_concat.exit1061:                        ; preds = %archx_str_from_int.exit1589, %copy_long.i1034
  %common.ret.op.i1044 = phi %ArchxStr [ %ls1.i1043, %copy_long.i1034 ], [ { i64 7166460027832631311, i64 ptrtoint (ptr @.str.3 to i64) }, %archx_str_from_int.exit1589 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1010)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1592)
  %w0.i1593 = extractvalue %ArchxStr %common.ret.op.i1044, 0
  %w1.i1594 = extractvalue %ArchxStr %common.ret.op.i1044, 1
  %len.i1595 = and i64 %w0.i1593, 4294967295
  %short.i1596 = icmp samesign ult i64 %len.i1595, 13
  br i1 %short.i1596, label %emit.i1617, label %emit.thread.i1597

emit.thread.i1597:                                ; preds = %archx_str_concat.exit1061
  %raw.i1598 = and i64 %w1.i1594, -4
  %lptr.i1599 = inttoptr i64 %raw.i1598 to ptr
  br label %chk_nul.i1600

emit.i1617:                                       ; preds = %archx_str_concat.exit1061
  %p4.i1618 = lshr i64 %w0.i1593, 32
  %p4_32.i1619 = trunc nuw i64 %p4.i1618 to i32
  store i32 %p4_32.i1619, ptr %tmp.i1592, align 4
  %tmp4.i1620 = getelementptr inbounds nuw i8, ptr %tmp.i1592, i64 4
  store i64 %w1.i1594, ptr %tmp4.i1620, align 4
  %pos.not.i1621 = icmp eq i64 %len.i1595, 0
  br i1 %pos.not.i1621, label %do_nl.i1612, label %chk_nul.i1600

chk_nul.i1600:                                    ; preds = %emit.i1617, %emit.thread.i1597
  %data3.i1601 = phi ptr [ %lptr.i1599, %emit.thread.i1597 ], [ %tmp.i1592, %emit.i1617 ]
  %nul.i1602 = call ptr @memchr(ptr nonnull %data3.i1601, i32 0, i64 %len.i1595)
  %has_nul.not.i1603 = icmp eq ptr %nul.i1602, null
  br i1 %has_nul.not.i1603, label %fast_printf.i1614, label %byte_loop.i1604

fast_printf.i1614:                                ; preds = %chk_nul.i1600
  %len32.i1615 = trunc i64 %w0.i1593 to i32
  %np.i1616 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1615, ptr nonnull %data3.i1601)
  br label %archx_str_print.exit1622

byte_loop.i1604:                                  ; preds = %chk_nul.i1600, %byte_loop.i1604
  %bi.i1605 = phi i64 [ %bnext.i1610, %byte_loop.i1604 ], [ 0, %chk_nul.i1600 ]
  %bp.i1606 = getelementptr inbounds nuw i8, ptr %data3.i1601, i64 %bi.i1605
  %ch8.i1607 = load i8, ptr %bp.i1606, align 1
  %ch32.i1608 = zext i8 %ch8.i1607 to i32
  %pc.i1609 = call i32 @putchar(i32 %ch32.i1608)
  %bnext.i1610 = add nuw nsw i64 %bi.i1605, 1
  %exitcond.not.i1611 = icmp eq i64 %bnext.i1610, %len.i1595
  br i1 %exitcond.not.i1611, label %do_nl.i1612, label %byte_loop.i1604

do_nl.i1612:                                      ; preds = %byte_loop.i1604, %emit.i1617
  %nc.i1613 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1622

archx_str_print.exit1622:                         ; preds = %fast_printf.i1614, %do_nl.i1612
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1592)
  %tag.i232 = and i64 %w1.i1594, 1
  %owned.not.i233 = icmp eq i64 %tag.i232, 0
  %or.cond1715 = select i1 %short.i1596, i1 true, i1 %owned.not.i233
  br i1 %or.cond1715, label %archx_str_drop.exit237, label %do_free.i234

do_free.i234:                                     ; preds = %archx_str_print.exit1622
  %raw.i235 = and i64 %w1.i1594, -2
  %ptr.i236 = inttoptr i64 %raw.i235 to ptr
  call void @free(ptr %ptr.i236)
  br label %archx_str_drop.exit237

archx_str_drop.exit237:                           ; preds = %archx_str_print.exit1622, %do_free.i234
  %long.i240 = icmp samesign ult i64 %blen.i1014, 13
  %tag.i243 = and i64 %bw1.i1013, 1
  %owned.not.i244 = icmp eq i64 %tag.i243, 0
  %or.cond1716 = select i1 %long.i240, i1 true, i1 %owned.not.i244
  br i1 %or.cond1716, label %archx_str_drop.exit248, label %do_free.i245

do_free.i245:                                     ; preds = %archx_str_drop.exit237
  %raw.i246 = and i64 %bw1.i1013, -2
  %ptr.i247 = inttoptr i64 %raw.i246 to ptr
  call void @free(ptr %ptr.i247)
  br label %archx_str_drop.exit248

archx_str_drop.exit248:                           ; preds = %archx_str_drop.exit237, %do_free.i245
  %long.i251 = icmp samesign ult i64 %blen.i951, 13
  %tag.i254 = and i64 %var.miss_label.40.sroa.7.0, 1
  %owned.not.i255 = icmp eq i64 %tag.i254, 0
  %or.cond1717 = select i1 %long.i251, i1 true, i1 %owned.not.i255
  br i1 %or.cond1717, label %archx_str_drop.exit270, label %do_free.i256

do_free.i256:                                     ; preds = %archx_str_drop.exit248
  %raw.i257 = and i64 %var.miss_label.40.sroa.7.0, -2
  %ptr.i258 = inttoptr i64 %raw.i257 to ptr
  call void @free(ptr %ptr.i258)
  br label %archx_str_drop.exit270

archx_str_drop.exit270:                           ; preds = %do_free.i256, %archx_str_drop.exit248
  call void @free(ptr %t7)
  call void @free(ptr nonnull %dst.i740.i)
  ret i32 0
}

; Function Attrs: nofree noinline nounwind
define private fastcc noalias nonnull align 16 ptr @archx_region_alloc_slow(ptr nonnull captures(none) %reg, i64 range(i64 0, -15) %aligned) unnamed_addr #1 {
entry:
  %body_sz = tail call i64 @llvm.smax.i64(i64 %aligned, i64 65536)
  %ovf_chk = icmp sgt i64 %aligned, 9223372036854775791
  br i1 %ovf_chk, label %oom, label %do_malloc

do_malloc:                                        ; preds = %entry
  %tot = add nuw nsw i64 %body_sz, 16
  %blk = tail call noalias align 16 ptr @malloc(i64 %tot)
  %isnull = icmp eq ptr %blk, null
  br i1 %isnull, label %oom, label %ok

oom:                                              ; preds = %do_malloc, %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

ok:                                               ; preds = %do_malloc
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
  %new_cur = getelementptr inbounds i8, ptr %data, i64 %aligned
  %new_end = getelementptr inbounds nuw i8, ptr %data, i64 %body_sz
  %end_slot = getelementptr inbounds nuw i8, ptr %reg, i64 8
  store ptr %new_cur, ptr %reg, align 8
  store ptr %new_end, ptr %end_slot, align 8
  ret ptr %data
}

; Function Attrs: noinline nounwind
define private fastcc noalias nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull captures(none) %reg, i64 range(i64 0, -15) %aligned) unnamed_addr #2 {
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
  %ccur = getelementptr inbounds i8, ptr %cdata, i64 %aligned
  %cend = getelementptr inbounds i8, ptr %cdata, i64 %ccap
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

; Function Attrs: mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite)
declare noalias noundef ptr @realloc(ptr allocptr captures(none), i64 noundef) local_unnamed_addr #7

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #8

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #9

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #10

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @memchr(ptr captures(none), i32, i64) local_unnamed_addr #11

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #4

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #3

; Function Attrs: nofree nounwind
declare noundef i32 @sprintf(ptr noalias noundef writeonly captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.fptosi.sat.i64.f64(double) #12

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_key_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.2)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_type_fail() unnamed_addr #3 {
entry:
  %c = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.err.type, ptr nonnull @.any.unhash)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: noinline nounwind
define private fastcc void @archx_dict_grow(ptr captures(none) %hdr) unnamed_addr #2 {
entry:
  %mask_p = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %reg_p = getelementptr inbounds nuw i8, ptr %hdr, i64 24
  %ctrl_p = getelementptr inbounds nuw i8, ptr %hdr, i64 32
  %keys_p = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %vals_p = getelementptr inbounds nuw i8, ptr %hdr, i64 48
  %meta_p = getelementptr inbounds nuw i8, ptr %hdr, i64 56
  %len = load i64, ptr %hdr, align 8
  %old_mask = load i64, ptr %mask_p, align 8
  %reg = load ptr, ptr %reg_p, align 8
  %old_ctrl = load ptr, ptr %ctrl_p, align 8
  %old_keys = load ptr, ptr %keys_p, align 8
  %old_vals = load ptr, ptr %vals_p, align 8
  %meta = load i64, ptr %meta_p, align 8
  %ksz_sh = lshr i64 %meta, 8
  %ksz = and i64 %ksz_sh, 16777215
  %vsz = lshr i64 %meta, 32
  %uninit = icmp eq ptr %old_ctrl, null
  %old_scap = shl i64 %old_mask, 1
  %dbl_scap = add i64 %old_scap, 2
  %new_scap = select i1 %uninit, i64 16, i64 %dbl_scap
  %new_mask = add i64 %new_scap, -1
  %sc7 = mul i64 %new_scap, 7
  %new_dcap = lshr i64 %sc7, 3
  %c_mul = mul i64 %new_scap, 5
  %ctrl_bytes = add i64 %c_mul, 16
  %ctrl_init_len = add i64 %new_scap, 16
  %k_bytes = mul i64 %ksz, %new_dcap
  %v_bytes = mul i64 %new_dcap, %vsz
  %has_vals.not = icmp ult i64 %meta, 4294967296
  %in_reg.not = icmp eq ptr %reg, null
  br i1 %in_reg.not, label %grow_heap, label %grow_reg

grow_reg:                                         ; preds = %entry
  %z.i21 = icmp slt i64 %ctrl_bytes, 1
  %sz.i22 = select i1 %z.i21, i64 16, i64 %ctrl_bytes
  %too_big.i23 = icmp sgt i64 %sz.i22, 9223372036854775776
  br i1 %too_big.i23, label %oom.i39, label %align_ok.i24

oom.i39:                                          ; preds = %grow_reg
  tail call fastcc void @archx_oom_fail()
  unreachable

align_ok.i24:                                     ; preds = %grow_reg
  %a1.i25 = add nuw nsw i64 %sz.i22, 15
  %aligned.i26 = and i64 %a1.i25, -16
  %end_slot.i27 = getelementptr inbounds nuw i8, ptr %reg, i64 8
  %cur.i28 = load ptr, ptr %reg, align 8
  %end.i29 = load ptr, ptr %end_slot.i27, align 8
  %cur_i.i30 = ptrtoint ptr %cur.i28 to i64
  %end_i.i31 = ptrtoint ptr %end.i29 to i64
  %rem.i32 = sub i64 %end_i.i31, %cur_i.i30
  %fits.not.i33 = icmp slt i64 %rem.i32, %aligned.i26
  br i1 %fits.not.i33, label %fallback.i37, label %fast.i34

fast.i34:                                         ; preds = %align_ok.i24
  %next.i35 = getelementptr inbounds i8, ptr %cur.i28, i64 %aligned.i26
  store ptr %next.i35, ptr %reg, align 8
  br label %archx_region_alloc.exit40

fallback.i37:                                     ; preds = %align_ok.i24
  %res.i38 = tail call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %reg, i64 %aligned.i26)
  br label %archx_region_alloc.exit40

archx_region_alloc.exit40:                        ; preds = %fast.i34, %fallback.i37
  %common.ret.op.i36 = phi ptr [ %cur.i28, %fast.i34 ], [ %res.i38, %fallback.i37 ]
  %z.i1 = icmp slt i64 %k_bytes, 1
  %sz.i2 = select i1 %z.i1, i64 16, i64 %k_bytes
  %too_big.i3 = icmp sgt i64 %sz.i2, 9223372036854775776
  br i1 %too_big.i3, label %oom.i19, label %align_ok.i4

oom.i19:                                          ; preds = %archx_region_alloc.exit40
  tail call fastcc void @archx_oom_fail()
  unreachable

align_ok.i4:                                      ; preds = %archx_region_alloc.exit40
  %a1.i5 = add nuw nsw i64 %sz.i2, 15
  %aligned.i6 = and i64 %a1.i5, -16
  %cur.i8 = load ptr, ptr %reg, align 8
  %end.i9 = load ptr, ptr %end_slot.i27, align 8
  %cur_i.i10 = ptrtoint ptr %cur.i8 to i64
  %end_i.i11 = ptrtoint ptr %end.i9 to i64
  %rem.i12 = sub i64 %end_i.i11, %cur_i.i10
  %fits.not.i13 = icmp slt i64 %rem.i12, %aligned.i6
  br i1 %fits.not.i13, label %fallback.i17, label %fast.i14

fast.i14:                                         ; preds = %align_ok.i4
  %next.i15 = getelementptr inbounds i8, ptr %cur.i8, i64 %aligned.i6
  store ptr %next.i15, ptr %reg, align 8
  br label %archx_region_alloc.exit20

fallback.i17:                                     ; preds = %align_ok.i4
  %res.i18 = tail call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %reg, i64 %aligned.i6)
  br label %archx_region_alloc.exit20

archx_region_alloc.exit20:                        ; preds = %fast.i14, %fallback.i17
  %common.ret.op.i16 = phi ptr [ %cur.i8, %fast.i14 ], [ %res.i18, %fallback.i17 ]
  %has_old_k = icmp sgt i64 %len, 0
  br i1 %has_old_k, label %rk_copy, label %rk_done

rk_copy:                                          ; preds = %archx_region_alloc.exit20
  %old_kb = mul i64 %ksz, %len
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i16, ptr nonnull align 8 %old_keys, i64 %old_kb, i1 false)
  br label %rk_done

rk_done:                                          ; preds = %rk_copy, %archx_region_alloc.exit20
  br i1 %has_vals.not, label %alloc_done, label %rv_alloc

rv_alloc:                                         ; preds = %rk_done
  %z.i = icmp slt i64 %v_bytes, 1
  %sz.i = select i1 %z.i, i64 16, i64 %v_bytes
  %too_big.i = icmp sgt i64 %sz.i, 9223372036854775776
  br i1 %too_big.i, label %oom.i, label %align_ok.i

oom.i:                                            ; preds = %rv_alloc
  tail call fastcc void @archx_oom_fail()
  unreachable

align_ok.i:                                       ; preds = %rv_alloc
  %a1.i = add nuw nsw i64 %sz.i, 15
  %aligned.i = and i64 %a1.i, -16
  %cur.i = load ptr, ptr %reg, align 8
  %end.i = load ptr, ptr %end_slot.i27, align 8
  %cur_i.i = ptrtoint ptr %cur.i to i64
  %end_i.i = ptrtoint ptr %end.i to i64
  %rem.i = sub i64 %end_i.i, %cur_i.i
  %fits.not.i = icmp slt i64 %rem.i, %aligned.i
  br i1 %fits.not.i, label %fallback.i, label %fast.i

fast.i:                                           ; preds = %align_ok.i
  %next.i = getelementptr inbounds i8, ptr %cur.i, i64 %aligned.i
  store ptr %next.i, ptr %reg, align 8
  br label %archx_region_alloc.exit

fallback.i:                                       ; preds = %align_ok.i
  %res.i = tail call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %reg, i64 %aligned.i)
  br label %archx_region_alloc.exit

archx_region_alloc.exit:                          ; preds = %fast.i, %fallback.i
  %common.ret.op.i = phi ptr [ %cur.i, %fast.i ], [ %res.i, %fallback.i ]
  br i1 %has_old_k, label %alloc_done.thread, label %alloc_done.thread67

alloc_done.thread67:                              ; preds = %archx_region_alloc.exit
  tail call void @llvm.memset.p0.i64(ptr nonnull align 16 %common.ret.op.i36, i8 -128, i64 %ctrl_init_len, i1 false)
  br label %rehash_done

alloc_done.thread:                                ; preds = %archx_region_alloc.exit
  %old_vb = mul i64 %vsz, %len
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i, ptr nonnull align 1 %old_vals, i64 %old_vb, i1 false)
  tail call void @llvm.memset.p0.i64(ptr nonnull align 16 %common.ret.op.i36, i8 -128, i64 %ctrl_init_len, i1 false)
  br label %rehash_item.lr.ph

grow_heap:                                        ; preds = %entry
  %hc = tail call noalias align 16 ptr @malloc(i64 %ctrl_bytes)
  %hc_null = icmp eq ptr %hc, null
  br i1 %hc_null, label %oom, label %hk_do

hk_do:                                            ; preds = %grow_heap
  %hk = tail call ptr @realloc(ptr %old_keys, i64 %k_bytes)
  %hk_null = icmp eq ptr %hk, null
  br i1 %hk_null, label %oom, label %hv_chk

hv_chk:                                           ; preds = %hk_do
  br i1 %has_vals.not, label %hfree_old, label %hv_do

hv_do:                                            ; preds = %hv_chk
  %hv = tail call ptr @realloc(ptr %old_vals, i64 %v_bytes)
  %hv_null = icmp eq ptr %hv, null
  br i1 %hv_null, label %oom, label %hfree_old

hfree_old:                                        ; preds = %hv_chk, %hv_do
  %hv_phi = phi ptr [ %hv, %hv_do ], [ null, %hv_chk ]
  tail call void @free(ptr %old_ctrl)
  br label %alloc_done

oom:                                              ; preds = %hv_do, %hk_do, %grow_heap
  tail call fastcc void @archx_oom_fail()
  unreachable

alloc_done:                                       ; preds = %rk_done, %hfree_old
  %new_ctrl = phi ptr [ %hc, %hfree_old ], [ %common.ret.op.i36, %rk_done ]
  %new_keys = phi ptr [ %hk, %hfree_old ], [ %common.ret.op.i16, %rk_done ]
  %new_vals = phi ptr [ %hv_phi, %hfree_old ], [ null, %rk_done ]
  tail call void @llvm.memset.p0.i64(ptr nonnull align 16 %new_ctrl, i8 -128, i64 %ctrl_init_len, i1 false)
  %more51 = icmp sgt i64 %len, 0
  br i1 %more51, label %rehash_item.lr.ph, label %rehash_done

rehash_item.lr.ph:                                ; preds = %alloc_done.thread, %alloc_done
  %new_vals65 = phi ptr [ %common.ret.op.i, %alloc_done.thread ], [ %new_vals, %alloc_done ]
  %new_keys63 = phi ptr [ %common.ret.op.i16, %alloc_done.thread ], [ %new_keys, %alloc_done ]
  %new_ctrl60 = phi ptr [ %common.ret.op.i36, %alloc_done.thread ], [ %new_ctrl, %alloc_done ]
  %idx_base66 = getelementptr inbounds i8, ptr %new_ctrl60, i64 %ctrl_init_len
  %trunc.i = trunc i64 %meta to i8
  %0 = getelementptr i8, ptr %new_ctrl60, i64 %new_scap
  br label %rehash_item

rehash_item:                                      ; preds = %rehash_item.lr.ph, %archx_dict_set_ctrl.exit
  %i52 = phi i64 [ 0, %rehash_item.lr.ph ], [ %i_next, %archx_dict_set_ctrl.exit ]
  switch i8 %trunc.i, label %k_any.i [
    i8 0, label %k_i64.i
    i8 1, label %k_str.i
  ]

k_i64.i:                                          ; preds = %rehash_item
  %pi.i = getelementptr inbounds nuw i64, ptr %new_keys63, i64 %i52
  %vi.i = load i64, ptr %pi.i, align 8
  %s1.i.i = lshr i64 %vi.i, 30
  %x1.i.i = xor i64 %s1.i.i, %vi.i
  %m1.i.i = mul i64 %x1.i.i, -4658895280553007687
  %s2.i.i = lshr i64 %m1.i.i, 27
  %x2.i.i = xor i64 %s2.i.i, %m1.i.i
  %m2.i.i = mul i64 %x2.i.i, -7723592293110705685
  %s3.i.i = lshr i64 %m2.i.i, 31
  %x3.i.i = xor i64 %s3.i.i, %m2.i.i
  br label %archx_dict_key_hash_at.exit

k_any.i:                                          ; preds = %rehash_item
  %pa.i = getelementptr inbounds nuw %ArchxAny, ptr %new_keys63, i64 %i52
  %va.unpack.i = load i64, ptr %pa.i, align 8
  %va.elt4.i = getelementptr inbounds nuw i8, ptr %pa.i, i64 8
  %va.unpack5.i = load i64, ptr %va.elt4.i, align 8
  %va.elt6.i = getelementptr inbounds nuw i8, ptr %pa.i, i64 16
  %va.unpack7.i = load i64, ptr %va.elt6.i, align 8
  %is0.i.i = icmp eq i64 %va.unpack.i, 0
  br i1 %is0.i.i, label %archx_dict_key_hash_at.exit, label %chk_int.i.i

chk_int.i.i:                                      ; preds = %k_any.i
  %le2.i.i = icmp ult i64 %va.unpack.i, 3
  br i1 %le2.i.i, label %h_i64.i.i, label %chk_flt.i.i

h_i64.i.i:                                        ; preds = %chk_int.i.i
  %s1.i1.i.i = lshr i64 %va.unpack5.i, 30
  %x1.i2.i.i = xor i64 %s1.i1.i.i, %va.unpack5.i
  %m1.i3.i.i = mul i64 %x1.i2.i.i, -4658895280553007687
  %s2.i4.i.i = lshr i64 %m1.i3.i.i, 27
  %x2.i5.i.i = xor i64 %s2.i4.i.i, %m1.i3.i.i
  %m2.i6.i.i = mul i64 %x2.i5.i.i, -7723592293110705685
  %s3.i7.i.i = lshr i64 %m2.i6.i.i, 31
  %x3.i8.i.i = xor i64 %s3.i7.i.i, %m2.i6.i.i
  br label %archx_dict_key_hash_at.exit

chk_flt.i.i:                                      ; preds = %chk_int.i.i
  switch i64 %va.unpack.i, label %unhash.i.i [
    i64 3, label %h_flt.i.i
    i64 4, label %h_str.i.i
  ]

h_flt.i.i:                                        ; preds = %chk_flt.i.i
  %fv.i.i = bitcast i64 %va.unpack5.i to double
  %iv.i.i = tail call i64 @llvm.fptosi.sat.i64.f64(double %fv.i.i)
  %back.i.i = sitofp i64 %iv.i.i to double
  %exact.i.i = fcmp oeq double %fv.i.i, %back.i.i
  %hkey.i.i = select i1 %exact.i.i, i64 %iv.i.i, i64 %va.unpack5.i
  %s1.i.i11.i = lshr i64 %hkey.i.i, 30
  %x1.i.i12.i = xor i64 %s1.i.i11.i, %hkey.i.i
  %m1.i.i13.i = mul i64 %x1.i.i12.i, -4658895280553007687
  %s2.i.i14.i = lshr i64 %m1.i.i13.i, 27
  %x2.i.i15.i = xor i64 %s2.i.i14.i, %m1.i.i13.i
  %m2.i.i16.i = mul i64 %x2.i.i15.i, -7723592293110705685
  %s3.i.i17.i = lshr i64 %m2.i.i16.i, 31
  %x3.i.i18.i = xor i64 %s3.i.i17.i, %m2.i.i16.i
  br label %archx_dict_key_hash_at.exit

h_str.i.i:                                        ; preds = %chk_flt.i.i
  %len.i.i.i = and i64 %va.unpack5.i, 4294967295
  %short.i.i.i = icmp samesign ult i64 %len.i.i.i, 13
  br i1 %short.i.i.i, label %sso_hash.i.i.i, label %long_hash.i.i.i

sso_hash.i.i.i:                                   ; preds = %h_str.i.i
  %p0_raw.i.i.i = lshr i64 %va.unpack5.i, 32
  %le4.i.i.i = icmp samesign ult i64 %len.i.i.i, 5
  br i1 %le4.i.i.i, label %sso_le4.i.i.i, label %sso_gt4.i.i.i

sso_le4.i.i.i:                                    ; preds = %sso_hash.i.i.i
  %sh0.i.i.i = shl nuw nsw i64 %len.i.i.i, 3
  %notmask1.i.i.i = shl nsw i64 -1, %sh0.i.i.i
  %m0.i.i.i = xor i64 %notmask1.i.i.i, -1
  %p0_4.i.i.i = and i64 %p0_raw.i.i.i, %m0.i.i.i
  br label %sso_mix.i.i.i

sso_gt4.i.i.i:                                    ; preds = %sso_hash.i.i.i
  %eq12.i.i.i = icmp eq i64 %len.i.i.i, 12
  br i1 %eq12.i.i.i, label %sso_mix.i.i.i, label %sso_mid.i.i.i

sso_mid.i.i.i:                                    ; preds = %sso_gt4.i.i.i
  %rem.i.i.i = shl nuw nsw i64 %len.i.i.i, 3
  %sh1.i.i.i = add nsw i64 %rem.i.i.i, -32
  %notmask.i.i.i = shl nsw i64 -1, %sh1.i.i.i
  %m1.i9.i.i = xor i64 %notmask.i.i.i, -1
  %p1_m.i.i.i = and i64 %va.unpack7.i, %m1.i9.i.i
  br label %sso_mix.i.i.i

sso_mix.i.i.i:                                    ; preds = %sso_mid.i.i.i, %sso_gt4.i.i.i, %sso_le4.i.i.i
  %p0.i.i.i = phi i64 [ %p0_4.i.i.i, %sso_le4.i.i.i ], [ %p0_raw.i.i.i, %sso_mid.i.i.i ], [ %p0_raw.i.i.i, %sso_gt4.i.i.i ]
  %p1.i.i.i = phi i64 [ 0, %sso_le4.i.i.i ], [ %p1_m.i.i.i, %sso_mid.i.i.i ], [ %va.unpack7.i, %sso_gt4.i.i.i ]
  %a0.i.i.i = mul i64 %p0.i.i.i, -7046029254386353131
  %a1.i.i.i = mul i64 %p1.i.i.i, -4417276706812531889
  %ax.i.i.i = xor i64 %a1.i.i.i, %a0.i.i.i
  %s1.i10.i.i.i = lshr i64 %ax.i.i.i, 30
  %1 = xor i64 %len.i.i.i, %s1.i10.i.i.i
  %x1.i11.i.i.i = xor i64 %1, %ax.i.i.i
  %m1.i12.i.i.i = mul i64 %x1.i11.i.i.i, -4658895280553007687
  %s2.i13.i.i.i = lshr i64 %m1.i12.i.i.i, 27
  %x2.i14.i.i.i = xor i64 %s2.i13.i.i.i, %m1.i12.i.i.i
  %m2.i15.i.i.i = mul i64 %x2.i14.i.i.i, -7723592293110705685
  %s3.i16.i.i.i = lshr i64 %m2.i15.i.i.i, 31
  %x3.i17.i.i.i = xor i64 %s3.i16.i.i.i, %m2.i15.i.i.i
  br label %archx_dict_key_hash_at.exit

long_hash.i.i.i:                                  ; preds = %h_str.i.i
  %raw.i.i.i = and i64 %va.unpack7.i, -4
  %ptr.i.i.i = inttoptr i64 %raw.i.i.i to ptr
  %seed.i.i.i = mul i64 %len.i.i.i, -7046029254386353131
  %2 = add nsw i64 %len.i.i.i, -8
  %3 = icmp ult i64 %2, 8
  br i1 %3, label %l_tail_cond.i.preheader.i.i.unr-lcssa, label %long_hash.i.i.i.new

long_hash.i.i.i.new:                              ; preds = %long_hash.i.i.i
  %4 = lshr i64 %2, 3
  %5 = add nuw nsw i64 %4, 1
  %unroll_iter87 = and i64 %5, 4611686018427387902
  br label %l_body.i.i.i

l_tail_cond.i.preheader.i.i.unr-lcssa:            ; preds = %l_body.i.i.i, %long_hash.i.i.i
  %acc_next.i.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i ], [ %acc_next.i.i.i.1, %l_body.i.i.i ]
  %idx_next.i.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i ], [ %idx_next.i.i.i.1, %l_body.i.i.i ]
  %acc.i11.i.i.unr = phi i64 [ %seed.i.i.i, %long_hash.i.i.i ], [ %acc_next.i.i.i.1, %l_body.i.i.i ]
  %idx.i10.i.i.unr = phi i64 [ 0, %long_hash.i.i.i ], [ %idx_next.i.i.i.1, %l_body.i.i.i ]
  %6 = and i64 %2, 8
  %lcmp.mod84.not.not = icmp eq i64 %6, 0
  br i1 %lcmp.mod84.not.not, label %l_body.i.i.i.epil, label %l_tail_cond.i.preheader.i.i

l_body.i.i.i.epil:                                ; preds = %l_tail_cond.i.preheader.i.i.unr-lcssa
  %lp.i.i.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i.i, i64 %idx.i10.i.i.unr
  %lane.i.i.i.epil = load i64, ptr %lp.i.i.i.epil, align 4
  %lm.i.i.i.epil = mul i64 %lane.i.i.i.epil, -4417276706812531889
  %lx.i.i.i.epil = xor i64 %lm.i.i.i.epil, %acc.i11.i.i.unr
  %s1.i2.i.i.i.epil = lshr i64 %lx.i.i.i.epil, 30
  %x1.i3.i.i.i.epil = xor i64 %s1.i2.i.i.i.epil, %lx.i.i.i.epil
  %m1.i4.i.i.i.epil = mul i64 %x1.i3.i.i.i.epil, -4658895280553007687
  %s2.i5.i.i.i.epil = lshr i64 %m1.i4.i.i.i.epil, 27
  %x2.i6.i.i.i.epil = xor i64 %s2.i5.i.i.i.epil, %m1.i4.i.i.i.epil
  %m2.i7.i.i.i.epil = mul i64 %x2.i6.i.i.i.epil, -7723592293110705685
  %s3.i8.i.i.i.epil = lshr i64 %m2.i7.i.i.i.epil, 31
  %x3.i9.i.i.i.epil = xor i64 %s3.i8.i.i.i.epil, %m2.i7.i.i.i.epil
  %acc_next.i.i.i.epil = add i64 %x3.i9.i.i.i.epil, %idx.i10.i.i.unr
  %idx_next.i.i.i.epil = add nuw nsw i64 %idx.i10.i.i.unr, 8
  br label %l_tail_cond.i.preheader.i.i

l_tail_cond.i.preheader.i.i:                      ; preds = %l_tail_cond.i.preheader.i.i.unr-lcssa, %l_body.i.i.i.epil
  %acc_next.i.i.i.lcssa = phi i64 [ %acc_next.i.i.i.lcssa.ph, %l_tail_cond.i.preheader.i.i.unr-lcssa ], [ %acc_next.i.i.i.epil, %l_body.i.i.i.epil ]
  %idx_next.i.i.i.lcssa = phi i64 [ %idx_next.i.i.i.lcssa.ph, %l_tail_cond.i.preheader.i.i.unr-lcssa ], [ %idx_next.i.i.i.epil, %l_body.i.i.i.epil ]
  %tmore.i12.i.i = icmp samesign ult i64 %idx_next.i.i.i.lcssa, %len.i.i.i
  br i1 %tmore.i12.i.i, label %l_tail_body.i.i.i.preheader, label %l_done.i.i.i

l_tail_body.i.i.i.preheader:                      ; preds = %l_tail_cond.i.preheader.i.i
  %7 = sub i64 %va.unpack5.i, %idx_next.i.i.i.lcssa
  %xtraiter89 = and i64 %7, 3
  %lcmp.mod90.not = icmp eq i64 %xtraiter89, 0
  br i1 %lcmp.mod90.not, label %l_tail_body.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.prol

l_tail_body.i.i.i.prol:                           ; preds = %l_tail_body.i.i.i.preheader, %l_tail_body.i.i.i.prol
  %tacc.i14.i.i.prol = phi i64 [ %tacc_next.i.i.i.prol, %l_tail_body.i.i.i.prol ], [ %acc_next.i.i.i.lcssa, %l_tail_body.i.i.i.preheader ]
  %ti.i13.i.i.prol = phi i64 [ %ti_next.i.i.i.prol, %l_tail_body.i.i.i.prol ], [ %idx_next.i.i.i.lcssa, %l_tail_body.i.i.i.preheader ]
  %prol.iter91 = phi i64 [ %prol.iter91.next, %l_tail_body.i.i.i.prol ], [ 0, %l_tail_body.i.i.i.preheader ]
  %tp.i.i.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i.i, i64 %ti.i13.i.i.prol
  %tb.i.i.i.prol = load i8, ptr %tp.i.i.i.prol, align 1
  %tz.i.i.i.prol = zext i8 %tb.i.i.i.prol to i64
  %tx.i.i.i.prol = xor i64 %tacc.i14.i.i.prol, %tz.i.i.i.prol
  %tacc_next.i.i.i.prol = mul i64 %tx.i.i.i.prol, 1099511628211
  %ti_next.i.i.i.prol = add nuw nsw i64 %ti.i13.i.i.prol, 1
  %prol.iter91.next = add i64 %prol.iter91, 1
  %prol.iter91.cmp.not = icmp eq i64 %prol.iter91.next, %xtraiter89
  br i1 %prol.iter91.cmp.not, label %l_tail_body.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.prol, !llvm.loop !14

l_tail_body.i.i.i.prol.loopexit:                  ; preds = %l_tail_body.i.i.i.prol, %l_tail_body.i.i.i.preheader
  %tacc.i14.i.i.unr = phi i64 [ %acc_next.i.i.i.lcssa, %l_tail_body.i.i.i.preheader ], [ %tacc_next.i.i.i.prol, %l_tail_body.i.i.i.prol ]
  %ti.i13.i.i.unr = phi i64 [ %idx_next.i.i.i.lcssa, %l_tail_body.i.i.i.preheader ], [ %ti_next.i.i.i.prol, %l_tail_body.i.i.i.prol ]
  %tacc_next.i.i.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.i.preheader ], [ %tacc_next.i.i.i.prol, %l_tail_body.i.i.i.prol ]
  %8 = sub i64 %idx_next.i.i.i.lcssa, %len.i.i.i
  %9 = icmp ugt i64 %8, -4
  br i1 %9, label %l_done.i.i.i, label %l_tail_body.i.i.i.preheader.new

l_tail_body.i.i.i.preheader.new:                  ; preds = %l_tail_body.i.i.i.prol.loopexit
  %invariant.gep98 = getelementptr i8, ptr %ptr.i.i.i, i64 1
  %invariant.gep100 = getelementptr i8, ptr %ptr.i.i.i, i64 2
  %invariant.gep102 = getelementptr i8, ptr %ptr.i.i.i, i64 3
  br label %l_tail_body.i.i.i

l_body.i.i.i:                                     ; preds = %l_body.i.i.i, %long_hash.i.i.i.new
  %acc.i11.i.i = phi i64 [ %seed.i.i.i, %long_hash.i.i.i.new ], [ %acc_next.i.i.i.1, %l_body.i.i.i ]
  %idx.i10.i.i = phi i64 [ 0, %long_hash.i.i.i.new ], [ %idx_next.i.i.i.1, %l_body.i.i.i ]
  %niter88 = phi i64 [ 0, %long_hash.i.i.i.new ], [ %niter88.next.1, %l_body.i.i.i ]
  %lp.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i, i64 %idx.i10.i.i
  %lane.i.i.i = load i64, ptr %lp.i.i.i, align 4
  %lm.i.i.i = mul i64 %lane.i.i.i, -4417276706812531889
  %lx.i.i.i = xor i64 %lm.i.i.i, %acc.i11.i.i
  %s1.i2.i.i.i = lshr i64 %lx.i.i.i, 30
  %x1.i3.i.i.i = xor i64 %s1.i2.i.i.i, %lx.i.i.i
  %m1.i4.i.i.i = mul i64 %x1.i3.i.i.i, -4658895280553007687
  %s2.i5.i.i.i = lshr i64 %m1.i4.i.i.i, 27
  %x2.i6.i.i.i = xor i64 %s2.i5.i.i.i, %m1.i4.i.i.i
  %m2.i7.i.i.i = mul i64 %x2.i6.i.i.i, -7723592293110705685
  %s3.i8.i.i.i = lshr i64 %m2.i7.i.i.i, 31
  %x3.i9.i.i.i = xor i64 %s3.i8.i.i.i, %m2.i7.i.i.i
  %acc_next.i.i.i = add i64 %x3.i9.i.i.i, %idx.i10.i.i
  %idx_next.i.i.i = or disjoint i64 %idx.i10.i.i, 8
  %lp.i.i.i.1 = getelementptr inbounds nuw i8, ptr %ptr.i.i.i, i64 %idx_next.i.i.i
  %lane.i.i.i.1 = load i64, ptr %lp.i.i.i.1, align 4
  %lm.i.i.i.1 = mul i64 %lane.i.i.i.1, -4417276706812531889
  %lx.i.i.i.1 = xor i64 %lm.i.i.i.1, %acc_next.i.i.i
  %s1.i2.i.i.i.1 = lshr i64 %lx.i.i.i.1, 30
  %x1.i3.i.i.i.1 = xor i64 %s1.i2.i.i.i.1, %lx.i.i.i.1
  %m1.i4.i.i.i.1 = mul i64 %x1.i3.i.i.i.1, -4658895280553007687
  %s2.i5.i.i.i.1 = lshr i64 %m1.i4.i.i.i.1, 27
  %x2.i6.i.i.i.1 = xor i64 %s2.i5.i.i.i.1, %m1.i4.i.i.i.1
  %m2.i7.i.i.i.1 = mul i64 %x2.i6.i.i.i.1, -7723592293110705685
  %s3.i8.i.i.i.1 = lshr i64 %m2.i7.i.i.i.1, 31
  %x3.i9.i.i.i.1 = xor i64 %s3.i8.i.i.i.1, %m2.i7.i.i.i.1
  %acc_next.i.i.i.1 = add i64 %x3.i9.i.i.i.1, %idx_next.i.i.i
  %idx_next.i.i.i.1 = add nuw nsw i64 %idx.i10.i.i, 16
  %niter88.next.1 = add i64 %niter88, 2
  %niter88.ncmp.1.not = icmp eq i64 %niter88.next.1, %unroll_iter87
  br i1 %niter88.ncmp.1.not, label %l_tail_cond.i.preheader.i.i.unr-lcssa, label %l_body.i.i.i

l_tail_body.i.i.i:                                ; preds = %l_tail_body.i.i.i, %l_tail_body.i.i.i.preheader.new
  %tacc.i14.i.i = phi i64 [ %tacc.i14.i.i.unr, %l_tail_body.i.i.i.preheader.new ], [ %tacc_next.i.i.i.3, %l_tail_body.i.i.i ]
  %ti.i13.i.i = phi i64 [ %ti.i13.i.i.unr, %l_tail_body.i.i.i.preheader.new ], [ %ti_next.i.i.i.3, %l_tail_body.i.i.i ]
  %tp.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i, i64 %ti.i13.i.i
  %tb.i.i.i = load i8, ptr %tp.i.i.i, align 1
  %tz.i.i.i = zext i8 %tb.i.i.i to i64
  %tx.i.i.i = xor i64 %tacc.i14.i.i, %tz.i.i.i
  %tacc_next.i.i.i = mul i64 %tx.i.i.i, 1099511628211
  %gep99 = getelementptr i8, ptr %invariant.gep98, i64 %ti.i13.i.i
  %tb.i.i.i.1 = load i8, ptr %gep99, align 1
  %tz.i.i.i.1 = zext i8 %tb.i.i.i.1 to i64
  %tx.i.i.i.1 = xor i64 %tacc_next.i.i.i, %tz.i.i.i.1
  %tacc_next.i.i.i.1 = mul i64 %tx.i.i.i.1, 1099511628211
  %gep101 = getelementptr i8, ptr %invariant.gep100, i64 %ti.i13.i.i
  %tb.i.i.i.2 = load i8, ptr %gep101, align 1
  %tz.i.i.i.2 = zext i8 %tb.i.i.i.2 to i64
  %tx.i.i.i.2 = xor i64 %tacc_next.i.i.i.1, %tz.i.i.i.2
  %tacc_next.i.i.i.2 = mul i64 %tx.i.i.i.2, 1099511628211
  %gep103 = getelementptr i8, ptr %invariant.gep102, i64 %ti.i13.i.i
  %tb.i.i.i.3 = load i8, ptr %gep103, align 1
  %tz.i.i.i.3 = zext i8 %tb.i.i.i.3 to i64
  %tx.i.i.i.3 = xor i64 %tacc_next.i.i.i.2, %tz.i.i.i.3
  %tacc_next.i.i.i.3 = mul i64 %tx.i.i.i.3, 1099511628211
  %ti_next.i.i.i.3 = add nuw nsw i64 %ti.i13.i.i, 4
  %tmore.i.i.i.3 = icmp samesign ult i64 %ti_next.i.i.i.3, %len.i.i.i
  br i1 %tmore.i.i.i.3, label %l_tail_body.i.i.i, label %l_done.i.i.i

l_done.i.i.i:                                     ; preds = %l_tail_body.i.i.i.prol.loopexit, %l_tail_body.i.i.i, %l_tail_cond.i.preheader.i.i
  %tacc.i.lcssa.i.i = phi i64 [ %acc_next.i.i.i.lcssa, %l_tail_cond.i.preheader.i.i ], [ %tacc_next.i.i.i.lcssa.unr, %l_tail_body.i.i.i.prol.loopexit ], [ %tacc_next.i.i.i.3, %l_tail_body.i.i.i ]
  %s1.i.i.i.i = lshr i64 %tacc.i.lcssa.i.i, 30
  %x1.i.i.i.i = xor i64 %s1.i.i.i.i, %tacc.i.lcssa.i.i
  %m1.i.i.i.i = mul i64 %x1.i.i.i.i, -4658895280553007687
  %s2.i.i.i.i = lshr i64 %m1.i.i.i.i, 27
  %x2.i.i.i.i = xor i64 %s2.i.i.i.i, %m1.i.i.i.i
  %m2.i.i.i.i = mul i64 %x2.i.i.i.i, -7723592293110705685
  %s3.i.i.i.i = lshr i64 %m2.i.i.i.i, 31
  %x3.i.i.i.i = xor i64 %s3.i.i.i.i, %m2.i.i.i.i
  br label %archx_dict_key_hash_at.exit

unhash.i.i:                                       ; preds = %chk_flt.i.i
  tail call fastcc void @archx_type_fail()
  unreachable

k_str.i:                                          ; preds = %rehash_item
  %ps.i = getelementptr inbounds nuw %ArchxStr, ptr %new_keys63, i64 %i52
  %vs.unpack.i = load i64, ptr %ps.i, align 8
  %vs.elt1.i = getelementptr inbounds nuw i8, ptr %ps.i, i64 8
  %vs.unpack2.i = load i64, ptr %vs.elt1.i, align 8
  %len.i.i = and i64 %vs.unpack.i, 4294967295
  %short.i.i = icmp samesign ult i64 %len.i.i, 13
  br i1 %short.i.i, label %sso_hash.i.i, label %long_hash.i.i

sso_hash.i.i:                                     ; preds = %k_str.i
  %p0_raw.i.i = lshr i64 %vs.unpack.i, 32
  %le4.i.i = icmp samesign ult i64 %len.i.i, 5
  br i1 %le4.i.i, label %sso_le4.i.i, label %sso_gt4.i.i

sso_le4.i.i:                                      ; preds = %sso_hash.i.i
  %sh0.i.i = shl nuw nsw i64 %len.i.i, 3
  %notmask1.i.i = shl nsw i64 -1, %sh0.i.i
  %m0.i.i = xor i64 %notmask1.i.i, -1
  %p0_4.i.i = and i64 %p0_raw.i.i, %m0.i.i
  br label %sso_mix.i.i

sso_gt4.i.i:                                      ; preds = %sso_hash.i.i
  %eq12.i.i = icmp eq i64 %len.i.i, 12
  br i1 %eq12.i.i, label %sso_mix.i.i, label %sso_mid.i.i

sso_mid.i.i:                                      ; preds = %sso_gt4.i.i
  %rem.i.i = shl nuw nsw i64 %len.i.i, 3
  %sh1.i.i = add nsw i64 %rem.i.i, -32
  %notmask.i.i = shl nsw i64 -1, %sh1.i.i
  %m1.i9.i = xor i64 %notmask.i.i, -1
  %p1_m.i.i = and i64 %vs.unpack2.i, %m1.i9.i
  br label %sso_mix.i.i

sso_mix.i.i:                                      ; preds = %sso_mid.i.i, %sso_gt4.i.i, %sso_le4.i.i
  %p0.i.i = phi i64 [ %p0_4.i.i, %sso_le4.i.i ], [ %p0_raw.i.i, %sso_mid.i.i ], [ %p0_raw.i.i, %sso_gt4.i.i ]
  %p1.i.i = phi i64 [ 0, %sso_le4.i.i ], [ %p1_m.i.i, %sso_mid.i.i ], [ %vs.unpack2.i, %sso_gt4.i.i ]
  %a0.i.i = mul i64 %p0.i.i, -7046029254386353131
  %a1.i.i = mul i64 %p1.i.i, -4417276706812531889
  %ax.i.i = xor i64 %a1.i.i, %a0.i.i
  %s1.i10.i.i = lshr i64 %ax.i.i, 30
  %10 = xor i64 %len.i.i, %s1.i10.i.i
  %x1.i11.i.i = xor i64 %10, %ax.i.i
  %m1.i12.i.i = mul i64 %x1.i11.i.i, -4658895280553007687
  %s2.i13.i.i = lshr i64 %m1.i12.i.i, 27
  %x2.i14.i.i = xor i64 %s2.i13.i.i, %m1.i12.i.i
  %m2.i15.i.i = mul i64 %x2.i14.i.i, -7723592293110705685
  %s3.i16.i.i = lshr i64 %m2.i15.i.i, 31
  %x3.i17.i.i = xor i64 %s3.i16.i.i, %m2.i15.i.i
  br label %archx_dict_key_hash_at.exit

long_hash.i.i:                                    ; preds = %k_str.i
  %raw.i.i = and i64 %vs.unpack2.i, -4
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  %seed.i.i = mul i64 %len.i.i, -7046029254386353131
  %11 = add nsw i64 %len.i.i, -8
  %12 = icmp ult i64 %11, 8
  br i1 %12, label %l_tail_cond.i.preheader.i.unr-lcssa, label %long_hash.i.i.new

long_hash.i.i.new:                                ; preds = %long_hash.i.i
  %13 = lshr i64 %11, 3
  %14 = add nuw nsw i64 %13, 1
  %unroll_iter = and i64 %14, 4611686018427387902
  br label %l_body.i.i

l_tail_cond.i.preheader.i.unr-lcssa:              ; preds = %l_body.i.i, %long_hash.i.i
  %acc_next.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i ], [ %acc_next.i.i.1, %l_body.i.i ]
  %idx_next.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i ], [ %idx_next.i.i.1, %l_body.i.i ]
  %acc.i20.i.unr = phi i64 [ %seed.i.i, %long_hash.i.i ], [ %acc_next.i.i.1, %l_body.i.i ]
  %idx.i19.i.unr = phi i64 [ 0, %long_hash.i.i ], [ %idx_next.i.i.1, %l_body.i.i ]
  %15 = and i64 %11, 8
  %lcmp.mod.not.not = icmp eq i64 %15, 0
  br i1 %lcmp.mod.not.not, label %l_body.i.i.epil, label %l_tail_cond.i.preheader.i

l_body.i.i.epil:                                  ; preds = %l_tail_cond.i.preheader.i.unr-lcssa
  %lp.i.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %idx.i19.i.unr
  %lane.i.i.epil = load i64, ptr %lp.i.i.epil, align 4
  %lm.i.i.epil = mul i64 %lane.i.i.epil, -4417276706812531889
  %lx.i.i.epil = xor i64 %lm.i.i.epil, %acc.i20.i.unr
  %s1.i2.i.i.epil = lshr i64 %lx.i.i.epil, 30
  %x1.i3.i.i.epil = xor i64 %s1.i2.i.i.epil, %lx.i.i.epil
  %m1.i4.i.i.epil = mul i64 %x1.i3.i.i.epil, -4658895280553007687
  %s2.i5.i.i.epil = lshr i64 %m1.i4.i.i.epil, 27
  %x2.i6.i.i.epil = xor i64 %s2.i5.i.i.epil, %m1.i4.i.i.epil
  %m2.i7.i.i.epil = mul i64 %x2.i6.i.i.epil, -7723592293110705685
  %s3.i8.i.i.epil = lshr i64 %m2.i7.i.i.epil, 31
  %x3.i9.i.i.epil = xor i64 %s3.i8.i.i.epil, %m2.i7.i.i.epil
  %acc_next.i.i.epil = add i64 %x3.i9.i.i.epil, %idx.i19.i.unr
  %idx_next.i.i.epil = add nuw nsw i64 %idx.i19.i.unr, 8
  br label %l_tail_cond.i.preheader.i

l_tail_cond.i.preheader.i:                        ; preds = %l_tail_cond.i.preheader.i.unr-lcssa, %l_body.i.i.epil
  %acc_next.i.i.lcssa = phi i64 [ %acc_next.i.i.lcssa.ph, %l_tail_cond.i.preheader.i.unr-lcssa ], [ %acc_next.i.i.epil, %l_body.i.i.epil ]
  %idx_next.i.i.lcssa = phi i64 [ %idx_next.i.i.lcssa.ph, %l_tail_cond.i.preheader.i.unr-lcssa ], [ %idx_next.i.i.epil, %l_body.i.i.epil ]
  %tmore.i21.i = icmp samesign ult i64 %idx_next.i.i.lcssa, %len.i.i
  br i1 %tmore.i21.i, label %l_tail_body.i.i.preheader, label %l_done.i.i

l_tail_body.i.i.preheader:                        ; preds = %l_tail_cond.i.preheader.i
  %16 = sub i64 %vs.unpack.i, %idx_next.i.i.lcssa
  %xtraiter81 = and i64 %16, 3
  %lcmp.mod82.not = icmp eq i64 %xtraiter81, 0
  br i1 %lcmp.mod82.not, label %l_tail_body.i.i.prol.loopexit, label %l_tail_body.i.i.prol

l_tail_body.i.i.prol:                             ; preds = %l_tail_body.i.i.preheader, %l_tail_body.i.i.prol
  %tacc.i23.i.prol = phi i64 [ %tacc_next.i.i.prol, %l_tail_body.i.i.prol ], [ %acc_next.i.i.lcssa, %l_tail_body.i.i.preheader ]
  %ti.i22.i.prol = phi i64 [ %ti_next.i.i.prol, %l_tail_body.i.i.prol ], [ %idx_next.i.i.lcssa, %l_tail_body.i.i.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %l_tail_body.i.i.prol ], [ 0, %l_tail_body.i.i.preheader ]
  %tp.i.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %ti.i22.i.prol
  %tb.i.i.prol = load i8, ptr %tp.i.i.prol, align 1
  %tz.i.i.prol = zext i8 %tb.i.i.prol to i64
  %tx.i.i.prol = xor i64 %tacc.i23.i.prol, %tz.i.i.prol
  %tacc_next.i.i.prol = mul i64 %tx.i.i.prol, 1099511628211
  %ti_next.i.i.prol = add nuw nsw i64 %ti.i22.i.prol, 1
  %prol.iter.next = add i64 %prol.iter, 1
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter81
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.i.prol.loopexit, label %l_tail_body.i.i.prol, !llvm.loop !15

l_tail_body.i.i.prol.loopexit:                    ; preds = %l_tail_body.i.i.prol, %l_tail_body.i.i.preheader
  %tacc.i23.i.unr = phi i64 [ %acc_next.i.i.lcssa, %l_tail_body.i.i.preheader ], [ %tacc_next.i.i.prol, %l_tail_body.i.i.prol ]
  %ti.i22.i.unr = phi i64 [ %idx_next.i.i.lcssa, %l_tail_body.i.i.preheader ], [ %ti_next.i.i.prol, %l_tail_body.i.i.prol ]
  %tacc_next.i.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.preheader ], [ %tacc_next.i.i.prol, %l_tail_body.i.i.prol ]
  %17 = sub i64 %idx_next.i.i.lcssa, %len.i.i
  %18 = icmp ugt i64 %17, -4
  br i1 %18, label %l_done.i.i, label %l_tail_body.i.i.preheader.new

l_tail_body.i.i.preheader.new:                    ; preds = %l_tail_body.i.i.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr.i.i, i64 1
  %invariant.gep94 = getelementptr i8, ptr %ptr.i.i, i64 2
  %invariant.gep96 = getelementptr i8, ptr %ptr.i.i, i64 3
  br label %l_tail_body.i.i

l_body.i.i:                                       ; preds = %l_body.i.i, %long_hash.i.i.new
  %acc.i20.i = phi i64 [ %seed.i.i, %long_hash.i.i.new ], [ %acc_next.i.i.1, %l_body.i.i ]
  %idx.i19.i = phi i64 [ 0, %long_hash.i.i.new ], [ %idx_next.i.i.1, %l_body.i.i ]
  %niter = phi i64 [ 0, %long_hash.i.i.new ], [ %niter.next.1, %l_body.i.i ]
  %lp.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %idx.i19.i
  %lane.i.i = load i64, ptr %lp.i.i, align 4
  %lm.i.i = mul i64 %lane.i.i, -4417276706812531889
  %lx.i.i = xor i64 %lm.i.i, %acc.i20.i
  %s1.i2.i.i = lshr i64 %lx.i.i, 30
  %x1.i3.i.i = xor i64 %s1.i2.i.i, %lx.i.i
  %m1.i4.i.i = mul i64 %x1.i3.i.i, -4658895280553007687
  %s2.i5.i.i = lshr i64 %m1.i4.i.i, 27
  %x2.i6.i.i = xor i64 %s2.i5.i.i, %m1.i4.i.i
  %m2.i7.i.i = mul i64 %x2.i6.i.i, -7723592293110705685
  %s3.i8.i.i = lshr i64 %m2.i7.i.i, 31
  %x3.i9.i.i = xor i64 %s3.i8.i.i, %m2.i7.i.i
  %acc_next.i.i = add i64 %x3.i9.i.i, %idx.i19.i
  %idx_next.i.i = or disjoint i64 %idx.i19.i, 8
  %lp.i.i.1 = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %idx_next.i.i
  %lane.i.i.1 = load i64, ptr %lp.i.i.1, align 4
  %lm.i.i.1 = mul i64 %lane.i.i.1, -4417276706812531889
  %lx.i.i.1 = xor i64 %lm.i.i.1, %acc_next.i.i
  %s1.i2.i.i.1 = lshr i64 %lx.i.i.1, 30
  %x1.i3.i.i.1 = xor i64 %s1.i2.i.i.1, %lx.i.i.1
  %m1.i4.i.i.1 = mul i64 %x1.i3.i.i.1, -4658895280553007687
  %s2.i5.i.i.1 = lshr i64 %m1.i4.i.i.1, 27
  %x2.i6.i.i.1 = xor i64 %s2.i5.i.i.1, %m1.i4.i.i.1
  %m2.i7.i.i.1 = mul i64 %x2.i6.i.i.1, -7723592293110705685
  %s3.i8.i.i.1 = lshr i64 %m2.i7.i.i.1, 31
  %x3.i9.i.i.1 = xor i64 %s3.i8.i.i.1, %m2.i7.i.i.1
  %acc_next.i.i.1 = add i64 %x3.i9.i.i.1, %idx_next.i.i
  %idx_next.i.i.1 = add nuw nsw i64 %idx.i19.i, 16
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1.not = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1.not, label %l_tail_cond.i.preheader.i.unr-lcssa, label %l_body.i.i

l_tail_body.i.i:                                  ; preds = %l_tail_body.i.i, %l_tail_body.i.i.preheader.new
  %tacc.i23.i = phi i64 [ %tacc.i23.i.unr, %l_tail_body.i.i.preheader.new ], [ %tacc_next.i.i.3, %l_tail_body.i.i ]
  %ti.i22.i = phi i64 [ %ti.i22.i.unr, %l_tail_body.i.i.preheader.new ], [ %ti_next.i.i.3, %l_tail_body.i.i ]
  %tp.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %ti.i22.i
  %tb.i.i = load i8, ptr %tp.i.i, align 1
  %tz.i.i = zext i8 %tb.i.i to i64
  %tx.i.i = xor i64 %tacc.i23.i, %tz.i.i
  %tacc_next.i.i = mul i64 %tx.i.i, 1099511628211
  %gep = getelementptr i8, ptr %invariant.gep, i64 %ti.i22.i
  %tb.i.i.1 = load i8, ptr %gep, align 1
  %tz.i.i.1 = zext i8 %tb.i.i.1 to i64
  %tx.i.i.1 = xor i64 %tacc_next.i.i, %tz.i.i.1
  %tacc_next.i.i.1 = mul i64 %tx.i.i.1, 1099511628211
  %gep95 = getelementptr i8, ptr %invariant.gep94, i64 %ti.i22.i
  %tb.i.i.2 = load i8, ptr %gep95, align 1
  %tz.i.i.2 = zext i8 %tb.i.i.2 to i64
  %tx.i.i.2 = xor i64 %tacc_next.i.i.1, %tz.i.i.2
  %tacc_next.i.i.2 = mul i64 %tx.i.i.2, 1099511628211
  %gep97 = getelementptr i8, ptr %invariant.gep96, i64 %ti.i22.i
  %tb.i.i.3 = load i8, ptr %gep97, align 1
  %tz.i.i.3 = zext i8 %tb.i.i.3 to i64
  %tx.i.i.3 = xor i64 %tacc_next.i.i.2, %tz.i.i.3
  %tacc_next.i.i.3 = mul i64 %tx.i.i.3, 1099511628211
  %ti_next.i.i.3 = add nuw nsw i64 %ti.i22.i, 4
  %tmore.i.i.3 = icmp samesign ult i64 %ti_next.i.i.3, %len.i.i
  br i1 %tmore.i.i.3, label %l_tail_body.i.i, label %l_done.i.i

l_done.i.i:                                       ; preds = %l_tail_body.i.i.prol.loopexit, %l_tail_body.i.i, %l_tail_cond.i.preheader.i
  %tacc.i.lcssa.i = phi i64 [ %acc_next.i.i.lcssa, %l_tail_cond.i.preheader.i ], [ %tacc_next.i.i.lcssa.unr, %l_tail_body.i.i.prol.loopexit ], [ %tacc_next.i.i.3, %l_tail_body.i.i ]
  %s1.i.i.i = lshr i64 %tacc.i.lcssa.i, 30
  %x1.i.i.i = xor i64 %s1.i.i.i, %tacc.i.lcssa.i
  %m1.i.i.i = mul i64 %x1.i.i.i, -4658895280553007687
  %s2.i.i.i = lshr i64 %m1.i.i.i, 27
  %x2.i.i.i = xor i64 %s2.i.i.i, %m1.i.i.i
  %m2.i.i.i = mul i64 %x2.i.i.i, -7723592293110705685
  %s3.i.i.i = lshr i64 %m2.i.i.i, 31
  %x3.i.i.i = xor i64 %s3.i.i.i, %m2.i.i.i
  br label %archx_dict_key_hash_at.exit

archx_dict_key_hash_at.exit:                      ; preds = %k_i64.i, %k_any.i, %h_i64.i.i, %h_flt.i.i, %sso_mix.i.i.i, %l_done.i.i.i, %sso_mix.i.i, %l_done.i.i
  %common.ret.op.i41 = phi i64 [ %x3.i.i, %k_i64.i ], [ %x3.i8.i.i, %h_i64.i.i ], [ %x3.i.i18.i, %h_flt.i.i ], [ 5871781006564002453, %k_any.i ], [ %x3.i17.i.i.i, %sso_mix.i.i.i ], [ %x3.i.i.i.i, %l_done.i.i.i ], [ %x3.i17.i.i, %sso_mix.i.i ], [ %x3.i.i.i, %l_done.i.i ]
  %h2_64 = lshr i64 %common.ret.op.i41, 57
  %h2 = trunc nuw nsw i64 %h2_64 to i8
  %pos42 = and i64 %common.ret.op.i41, %new_mask
  %gp43 = getelementptr inbounds i8, ptr %new_ctrl60, i64 %pos42
  %grp44 = load <16 x i8>, ptr %gp43, align 1
  %ecmp45 = icmp eq <16 x i8> %grp44, splat (i8 -128)
  %ebits46 = bitcast <16 x i1> %ecmp45 to i16
  %has_e.not47 = icmp eq i16 %ebits46, 0
  br i1 %has_e.not47, label %rprobe_next, label %rehash_put

rprobe_next:                                      ; preds = %archx_dict_key_hash_at.exit, %rprobe_next
  %pos49 = phi i64 [ %pos, %rprobe_next ], [ %pos42, %archx_dict_key_hash_at.exit ]
  %step48 = phi i64 [ %step_next, %rprobe_next ], [ 0, %archx_dict_key_hash_at.exit ]
  %step_next = add i64 %step48, 16
  %padd = add i64 %step_next, %pos49
  %pos = and i64 %padd, %new_mask
  %gp = getelementptr inbounds i8, ptr %new_ctrl60, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %ecmp = icmp eq <16 x i8> %grp, splat (i8 -128)
  %ebits = bitcast <16 x i1> %ecmp to i16
  %has_e.not = icmp eq i16 %ebits, 0
  br i1 %has_e.not, label %rprobe_next, label %rehash_put

rehash_put:                                       ; preds = %rprobe_next, %archx_dict_key_hash_at.exit
  %pos.lcssa = phi i64 [ %pos42, %archx_dict_key_hash_at.exit ], [ %pos, %rprobe_next ]
  %ebits.lcssa = phi i16 [ %ebits46, %archx_dict_key_hash_at.exit ], [ %ebits, %rprobe_next ]
  %19 = tail call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %ebits.lcssa, i1 true)
  %tz64 = zext nneg i16 %19 to i64
  %s_add = add i64 %pos.lcssa, %tz64
  %slot = and i64 %s_add, %new_mask
  %p.i = getelementptr inbounds i8, ptr %new_ctrl60, i64 %slot
  store i8 %h2, ptr %p.i, align 1
  %mir.i = icmp ult i64 %slot, 16
  br i1 %mir.i, label %do_mir.i, label %archx_dict_set_ctrl.exit

do_mir.i:                                         ; preds = %rehash_put
  %mp.i = getelementptr i8, ptr %0, i64 %slot
  store i8 %h2, ptr %mp.i, align 1
  br label %archx_dict_set_ctrl.exit

archx_dict_set_ctrl.exit:                         ; preds = %rehash_put, %do_mir.i
  %ip = getelementptr inbounds i32, ptr %idx_base66, i64 %slot
  %i32v = trunc i64 %i52 to i32
  store i32 %i32v, ptr %ip, align 4
  %i_next = add nuw nsw i64 %i52, 1
  %exitcond.not = icmp eq i64 %i_next, %len
  br i1 %exitcond.not, label %rehash_done, label %rehash_item

rehash_done:                                      ; preds = %archx_dict_set_ctrl.exit, %alloc_done.thread67, %alloc_done
  %new_vals64 = phi ptr [ %new_vals, %alloc_done ], [ %common.ret.op.i, %alloc_done.thread67 ], [ %new_vals65, %archx_dict_set_ctrl.exit ]
  %new_keys62 = phi ptr [ %new_keys, %alloc_done ], [ %common.ret.op.i16, %alloc_done.thread67 ], [ %new_keys63, %archx_dict_set_ctrl.exit ]
  %new_ctrl61 = phi ptr [ %new_ctrl, %alloc_done ], [ %common.ret.op.i36, %alloc_done.thread67 ], [ %new_ctrl60, %archx_dict_set_ctrl.exit ]
  %used_p = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  store i64 %len, ptr %used_p, align 8
  store i64 %new_mask, ptr %mask_p, align 8
  store ptr %new_ctrl61, ptr %ctrl_p, align 8
  store ptr %new_keys62, ptr %keys_p, align 8
  store ptr %new_vals64, ptr %vals_p, align 8
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.cttz.i32(i32, i1 immarg) #12

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #13

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.abs.i64(i64, i1 immarg) #13

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smin.i64(i64, i64) #13

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smax.i64(i64, i64) #13

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @bcmp(ptr captures(none), ptr captures(none), i64) local_unnamed_addr #14

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.cttz.i16(i16, i1 immarg) #13

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #15

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #15

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v2i64(<2 x i64>) #13

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x double> @llvm.sqrt.v2f64(<2 x double>) #13

attributes #0 = { nounwind }
attributes #1 = { nofree noinline nounwind }
attributes #2 = { noinline nounwind }
attributes #3 = { cold nofree noreturn nounwind }
attributes #4 = { nofree nounwind }
attributes #5 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #6 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #7 = { mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #8 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #9 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #10 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #11 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #12 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #13 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #14 = { nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #15 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.isvectorized", i32 1}
!2 = !{!"llvm.loop.unroll.runtime.disable"}
!3 = distinct !{!3, !1, !2}
!4 = distinct !{!4, !1, !2}
!5 = distinct !{!5, !1, !2}
!6 = distinct !{!6, !2, !1}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.unroll.disable"}
!9 = distinct !{!9, !8}
!10 = distinct !{!10, !8}
!11 = distinct !{!11, !1, !2}
!12 = distinct !{!12, !2, !1}
!13 = distinct !{!13, !1, !2}
!14 = distinct !{!14, !8}
!15 = distinct !{!15, !8}
