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
@str.1 = private unnamed_addr constant [38 x i8] c"archx runtime panic: integer overflow\00", align 1
@str.2 = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1
@str.4 = private unnamed_addr constant [57 x i8] c"archx runtime panic: KeyError: key not found in dict/set\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %tmp.i1787 = alloca [12 x i8], align 4
  %sso.i.i1757 = alloca [16 x i8], align 8
  %buf.i1758 = alloca [32 x i8], align 8
  %tmp.i1726 = alloca [12 x i8], align 4
  %sso.i.i1695 = alloca [16 x i8], align 8
  %buf.i1696 = alloca [32 x i8], align 8
  %tmp.i1664 = alloca [12 x i8], align 4
  %sso.i.i.i1560 = alloca [16 x i8], align 8
  %buf.i.i1561 = alloca [32 x i8], align 8
  %sso.i.i1492 = alloca [16 x i8], align 8
  %buf.i1493 = alloca [32 x i8], align 8
  %sso.i.i1424 = alloca [16 x i8], align 8
  %buf.i1425 = alloca [32 x i8], align 8
  %sso.i.i1393 = alloca [16 x i8], align 8
  %buf.i1394 = alloca [32 x i8], align 8
  %tmp.i1362 = alloca [12 x i8], align 4
  %sso.i.i1303 = alloca [16 x i8], align 8
  %buf.i1304 = alloca [32 x i8], align 8
  %tmp.i = alloca [12 x i8], align 4
  %sso.i.i1268 = alloca [16 x i8], align 8
  %buf.i1269 = alloca [32 x i8], align 8
  %sso.i.i = alloca [16 x i8], align 8
  %buf.i = alloca [32 x i8], align 8
  %sso.i.i603.i = alloca [16 x i8], align 8
  %tmp.i604.i = alloca [12 x i8], align 4
  %sbuf.i.i = alloca [64 x i8], align 8
  %sso.i.i574.i = alloca [16 x i8], align 8
  %tmp.i.i = alloca [12 x i8], align 4
  %sso.i.i542.i = alloca [16 x i8], align 8
  %buf.i543.i = alloca [32 x i8], align 8
  %sso.i.i.i = alloca [16 x i8], align 8
  %buf.i.i = alloca [32 x i8], align 8
  %atmp.i195.i = alloca [12 x i8], align 4
  %out_sso.i197.i = alloca [16 x i8], align 8
  %btmp.i147.i = alloca [12 x i8], align 4
  %btmp.i.i = alloca [12 x i8], align 4
  %out_sso.i.sroa.6.i = alloca i64, align 8
  %func.region.i = alloca %ArchxRegion, align 8
  %btmp.i1084 = alloca [12 x i8], align 4
  %out_sso.i1085.sroa.6.sroa.5.sroa.0 = alloca i24, align 4
  %btmp.i1031 = alloca [12 x i8], align 4
  %atmp.i964 = alloca [12 x i8], align 4
  %btmp.i965 = alloca [12 x i8], align 4
  %out_sso.i966 = alloca [16 x i8], align 8
  %atmp.i910 = alloca [12 x i8], align 4
  %out_sso.i912 = alloca [16 x i8], align 8
  %atmp.i844 = alloca [12 x i8], align 4
  %btmp.i845 = alloca [12 x i8], align 4
  %out_sso.i846 = alloca [16 x i8], align 8
  %atmp.i790 = alloca [12 x i8], align 4
  %out_sso.i792 = alloca [16 x i8], align 8
  %atmp.i724 = alloca [12 x i8], align 4
  %btmp.i725 = alloca [12 x i8], align 4
  %out_sso.i726 = alloca [16 x i8], align 8
  %atmp.i670 = alloca [12 x i8], align 4
  %out_sso.i672 = alloca [16 x i8], align 8
  %atmp.i604 = alloca [12 x i8], align 4
  %btmp.i605 = alloca [12 x i8], align 4
  %out_sso.i606 = alloca [16 x i8], align 8
  %atmp.i550 = alloca [12 x i8], align 4
  %out_sso.i552 = alloca [16 x i8], align 8
  %btmp.i497 = alloca [12 x i8], align 4
  %out_sso.i498.sroa.6.sroa.5 = alloca i16, align 2
  %atmp.i430 = alloca [12 x i8], align 4
  %atmp.i392 = alloca [12 x i8], align 4
  %out_sso.i394 = alloca [16 x i8], align 8
  %btmp.i343 = alloca [12 x i8], align 4
  %btmp.i293 = alloca [12 x i8], align 4
  %out_sso.i294.sroa.6 = alloca i64, align 8
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
  br i1 %11, label %vector.ph2024, label %vector.body, !llvm.loop !0

calloc.oom.11.i:                                  ; preds = %calloc.ok.8.i
  tail call fastcc void @archx_oom_fail()
  unreachable

vector.ph2024:                                    ; preds = %vector.body, %for.step.20.i
  %for._s.48.019.i = phi i64 [ %t97.i, %for.step.20.i ], [ 0, %vector.body ]
  br label %vector.body2025

vector.body2025:                                  ; preds = %vector.body2025, %vector.ph2024
  %index2026 = phi i64 [ 0, %vector.ph2024 ], [ %index.next2030, %vector.body2025 ]
  %12 = getelementptr inbounds nuw double, ptr %t3.i, i64 %index2026
  %wide.load = load <2 x double>, ptr %12, align 16
  %13 = getelementptr inbounds nuw double, ptr %t7.i, i64 %index2026
  %wide.load2027 = load <2 x double>, ptr %13, align 16
  %14 = fmul <2 x double> %wide.load, %wide.load
  %15 = fmul <2 x double> %wide.load2027, %wide.load2027
  %16 = fadd <2 x double> %14, %15
  %17 = fadd <2 x double> %16, splat (double 1.000000e+00)
  %18 = tail call <2 x double> @llvm.sqrt.v2f64(<2 x double> %17)
  %19 = fdiv <2 x double> splat (double 1.000000e-02), %18
  %20 = getelementptr inbounds nuw double, ptr %t11.i, i64 %index2026
  %wide.load2028 = load <2 x double>, ptr %20, align 16
  %21 = fmul <2 x double> %wide.load, %19
  %22 = fsub <2 x double> %wide.load2028, %21
  store <2 x double> %22, ptr %20, align 16
  %23 = getelementptr inbounds nuw double, ptr %t15.i, i64 %index2026
  %wide.load2029 = load <2 x double>, ptr %23, align 16
  %24 = fmul <2 x double> %wide.load2027, %19
  %25 = fsub <2 x double> %wide.load2029, %24
  store <2 x double> %25, ptr %23, align 16
  %26 = fmul <2 x double> %22, splat (double 1.000000e-02)
  %27 = fadd <2 x double> %wide.load, %26
  store <2 x double> %27, ptr %12, align 16
  %28 = fmul <2 x double> %25, splat (double 1.000000e-02)
  %29 = fadd <2 x double> %wide.load2027, %28
  store <2 x double> %29, ptr %13, align 16
  %index.next2030 = add nuw i64 %index2026, 2
  %30 = icmp eq i64 %index.next2030, 40000
  br i1 %30, label %for.step.20.i, label %vector.body2025, !llvm.loop !3

for.step.20.i:                                    ; preds = %vector.body2025
  %t97.i = add nuw nsw i64 %for._s.48.019.i, 1
  %exitcond23.not.i = icmp eq i64 %t97.i, 30
  br i1 %exitcond23.not.i, label %for.body.27.i, label %vector.ph2024

for.body.27.i:                                    ; preds = %for.step.20.i, %for.body.27.i
  %for.i.99.021.i = phi i64 [ %t123.i.1, %for.body.27.i ], [ 0, %for.step.20.i ]
  %var.ke.98.020.i = phi double [ %t121.i.1, %for.body.27.i ], [ 0.000000e+00, %for.step.20.i ]
  %t111.i = getelementptr inbounds nuw double, ptr %t11.i, i64 %for.i.99.021.i
  %t112.i = load double, ptr %t111.i, align 16
  %t114.i = getelementptr inbounds nuw double, ptr %t15.i, i64 %for.i.99.021.i
  %t115.i = load double, ptr %t114.i, align 16
  %t117.i = getelementptr inbounds nuw double, ptr %t19.i, i64 %for.i.99.021.i
  %t118.i = load double, ptr %t117.i, align 16
  %t1.i.i = fmul double %t118.i, 5.000000e-01
  %t4.i.i = fmul double %t112.i, %t112.i
  %t7.i.i = fmul double %t115.i, %t115.i
  %t8.i.i = fadd double %t4.i.i, %t7.i.i
  %t9.i.i = fmul double %t1.i.i, %t8.i.i
  %t121.i = fadd double %var.ke.98.020.i, %t9.i.i
  %t123.i = or disjoint i64 %for.i.99.021.i, 1
  %t111.i.1 = getelementptr inbounds nuw double, ptr %t11.i, i64 %t123.i
  %t112.i.1 = load double, ptr %t111.i.1, align 8
  %t114.i.1 = getelementptr inbounds nuw double, ptr %t15.i, i64 %t123.i
  %t115.i.1 = load double, ptr %t114.i.1, align 8
  %t117.i.1 = getelementptr inbounds nuw double, ptr %t19.i, i64 %t123.i
  %t118.i.1 = load double, ptr %t117.i.1, align 8
  %t1.i.i.1 = fmul double %t118.i.1, 5.000000e-01
  %t4.i.i.1 = fmul double %t112.i.1, %t112.i.1
  %t7.i.i.1 = fmul double %t115.i.1, %t115.i.1
  %t8.i.i.1 = fadd double %t4.i.i.1, %t7.i.i.1
  %t9.i.i.1 = fmul double %t1.i.i.1, %t8.i.i.1
  %t121.i.1 = fadd double %t121.i, %t9.i.i.1
  %t123.i.1 = add nuw nsw i64 %for.i.99.021.i, 2
  %exitcond24.not.i.1 = icmp eq i64 %t123.i.1, 40000
  br i1 %exitcond24.not.i.1, label %archx_fn_simulate_field.exit, label %for.body.27.i

archx_fn_simulate_field.exit:                     ; preds = %for.body.27.i
  %t125.i = fmul double %t121.i.1, 1.000000e+03
  %t126.i = tail call i64 @llvm.fptosi.sat.i64.f64(double %t125.i)
  tail call void @free(ptr nonnull %t19.i)
  tail call void @free(ptr nonnull %t15.i)
  tail call void @free(ptr nonnull %t11.i)
  tail call void @free(ptr nonnull %t7.i)
  tail call void @free(ptr nonnull %t3.i)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %func.region.i)
  %.fca.1.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 8
  %.fca.2.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 16
  %.fca.3.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 24
  %btmp4.i191.i = getelementptr inbounds nuw i8, ptr %btmp.i147.i, i64 4
  %atmp4.i231.i = getelementptr inbounds nuw i8, ptr %atmp.i195.i, i64 4
  %out_sso8.i223.i = getelementptr inbounds nuw i8, ptr %out_sso.i197.i, i64 8
  %sso_dst_a.i225.i = getelementptr inbounds nuw i8, ptr %out_sso.i197.i, i64 4
  %t4.i.i1137 = getelementptr inbounds nuw i8, ptr %tmp.i.i, i64 4
  %t4.i638.i = getelementptr inbounds nuw i8, ptr %tmp.i604.i, i64 4
  %btmp4.i.i = getelementptr inbounds nuw i8, ptr %btmp.i.i, i64 4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %func.region.i, i8 0, i64 32, i1 false)
  %sso.i.i542.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i542.i, i64 4
  %sso.i.i542.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i542.i, i64 8
  %sso.i.i574.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i574.i, i64 4
  %sso.i.i574.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i574.i, i64 8
  %sso.i.i603.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i603.i, i64 4
  %sso.i.i603.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i603.i, i64 8
  %sso.i.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i, i64 4
  %sso.i.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i, i64 8
  br label %mod.ok.5.i

mod.ok.5.i:                                       ; preds = %for.step.2.i, %archx_fn_simulate_field.exit
  %var.vocab.4.sroa.34.0869.i = phi ptr [ null, %archx_fn_simulate_field.exit ], [ %var.vocab.4.sroa.34.3.i, %for.step.2.i ]
  %var.vocab.4.sroa.17.0868.i = phi i64 [ 0, %archx_fn_simulate_field.exit ], [ %var.vocab.4.sroa.17.3.i, %for.step.2.i ]
  %var.vocab.4.sroa.0.0867.i = phi i64 [ 0, %archx_fn_simulate_field.exit ], [ %var.vocab.4.sroa.0.3.i, %for.step.2.i ]
  %t15.i1138 = and i64 %var.vocab.4.sroa.0.0867.i, 1
  %t23.i = icmp eq i64 %t15.i1138, 0
  br i1 %t23.i, label %if.then.6.i, label %if.else.7.i

if.then.6.i:                                      ; preds = %mod.ok.5.i
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i.i)
  %n32.i.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %var.vocab.4.sroa.0.0867.i)
  %len.i540.i = sext i32 %n32.i.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i.i)
  %z.i.i.i = icmp slt i32 %n32.i.i, 1
  br i1 %z.i.i.i, label %archx_str_from_int.exit.i, label %chk_sso.i.i.i

oom.i.i.i:                                        ; preds = %alloc_heap.i.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i.i:                                    ; preds = %if.then.6.i
  %short.i.i.i = icmp samesign ult i32 %n32.i.i, 13
  br i1 %short.i.i.i, label %pack_sso.i.i.i, label %alloc_heap.i.i.i

pack_sso.i.i.i:                                   ; preds = %chk_sso.i.i.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i.i, i8 0, i64 16, i1 false)
  store i32 %n32.i.i, ptr %sso.i.i.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i.i, i64 %len.i540.i, i1 false)
  %sso.i.i.i.0.sso.i.i.i.0.sso.i.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i.i = load i64, ptr %sso.i.i.i, align 8
  %sso.i.i.i.8.sso.i.i.i.8.sso.i.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i.i = load i64, ptr %sso.i.i.i.8.sroa_idx, align 8
  %ss0.i.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.i.0.sso.i.i.i.0.sso.i.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i.i, 0
  %ss1.i.i.i = insertvalue %ArchxStr %ss0.i.i.i, i64 %sso.i.i.i.8.sso.i.i.i.8.sso.i.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i.i, 1
  br label %archx_str_from_int.exit.i

alloc_heap.i.i.i:                                 ; preds = %chk_sso.i.i.i
  %hp.i.i.i = tail call noalias align 16 ptr @malloc(i64 %len.i540.i)
  %hnull.i.i.i = icmp eq ptr %hp.i.i.i, null
  br i1 %hnull.i.i.i, label %oom.i.i.i, label %copy_long.i.i.i

copy_long.i.i.i:                                  ; preds = %alloc_heap.i.i.i
  %hp_i.i.i.i = ptrtoint ptr %hp.i.i.i to i64
  %htagged.i.i.i = or disjoint i64 %hp_i.i.i.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i.i, ptr nonnull readonly align 8 %buf.i.i, i64 %len.i540.i, i1 false)
  %pref32.i.i.i = load i32, ptr %hp.i.i.i, align 16
  %pref64.i.i.i = zext i32 %pref32.i.i.i to i64
  %pref_sh.i.i.i = shl nuw i64 %pref64.i.i.i, 32
  %w0_out.i.i.i = or disjoint i64 %pref_sh.i.i.i, %len.i540.i
  %ls0.i.i.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i.i, 0
  %ls1.i.i.i = insertvalue %ArchxStr %ls0.i.i.i, i64 %htagged.i.i.i, 1
  br label %archx_str_from_int.exit.i

archx_str_from_int.exit.i:                        ; preds = %copy_long.i.i.i, %pack_sso.i.i.i, %if.then.6.i
  %common.ret.op.i.i.i = phi %ArchxStr [ %ss1.i.i.i, %pack_sso.i.i.i ], [ %ls1.i.i.i, %copy_long.i.i.i ], [ zeroinitializer, %if.then.6.i ]
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
  %bptr.i958.i = phi ptr [ %blptr.i.i, %build.i.thread.i ], [ %btmp.i.i, %build.i.i ]
  %hp.i.i = tail call noalias align 16 ptr @malloc(i64 %tot.i.i)
  %hnull.i.i = icmp eq ptr %hp.i.i, null
  br i1 %hnull.i.i, label %oom.i.i, label %copy_long.i.i

copy_long.i.i:                                    ; preds = %alloc_heap.i.i
  %hp_i.i.i = ptrtoint ptr %hp.i.i to i64
  %htagged.i.i = or disjoint i64 %hp_i.i.i, 1
  store i32 1600876404, ptr %hp.i.i, align 16
  %dst_b.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %dst_b.i.i, ptr nonnull align 1 %bptr.i958.i, i64 %blen.i.i, i1 false)
  %w0_out.i.i = or disjoint i64 %tot.i.i, 6875711800118083584
  %ls0.i.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i, 0
  %ls1.i.i = insertvalue %ArchxStr %ls0.i.i, i64 %htagged.i.i, 1
  br label %archx_str_concat.exit.i

archx_str_concat.exit.i:                          ; preds = %copy_long.i.i, %build_sso.i.i, %archx_str_from_int.exit.i
  %common.ret.op.i.i = phi %ArchxStr [ %rs1.i.i, %build_sso.i.i ], [ %ls1.i.i, %copy_long.i.i ], [ { i64 6875711800118083588, i64 0 }, %archx_str_from_int.exit.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6.i)
  %t31.i1143 = icmp slt i64 %var.vocab.4.sroa.17.0868.i, 0
  %t33.i = tail call i64 @llvm.abs.i64(i64 %var.vocab.4.sroa.17.0868.i, i1 true)
  %t34.not.i = icmp samesign ult i64 %var.vocab.4.sroa.0.0867.i, %t33.i
  br i1 %t34.not.i, label %push.store.10.i, label %push.calc.12.i

push.calc.12.i:                                   ; preds = %archx_str_concat.exit.i
  %t36.i1144 = icmp eq i64 %var.vocab.4.sroa.17.0868.i, 0
  %t37.i = shl nuw i64 %t33.i, 1
  %31 = tail call i64 @llvm.smin.i64(i64 %t37.i, i64 140737488355328)
  %t40.i1145 = select i1 %t36.i1144, i64 4, i64 %31
  %32 = add i64 %t40.i1145, -576460752303423488
  %t43.i1146 = icmp ult i64 %32, -1152921504606846976
  br i1 %t43.i1146, label %mul.oom.13.i, label %mul.ok.14.i

mul.oom.13.i:                                     ; preds = %push.calc.12.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mul.ok.14.i:                                      ; preds = %push.calc.12.i
  %t42.i = shl nsw i64 %t40.i1145, 4
  %t45.i1147 = tail call i64 @llvm.umax.i64(i64 %t42.i, i64 1)
  br i1 %t31.i1143, label %mul.ok.18.i, label %push.grow.from_heap.16.i

mul.ok.18.i:                                      ; preds = %mul.ok.14.i
  %t51.i = tail call noalias align 16 ptr @malloc(i64 %t45.i1147)
  %t52.i = icmp eq ptr %t51.i, null
  br i1 %t52.i, label %alloc.oom.20.i, label %push.reg.copy.21.i

alloc.oom.20.i:                                   ; preds = %mul.ok.18.i
  tail call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.21.i:                               ; preds = %mul.ok.18.i
  %t47.i = shl nuw nsw i64 %var.vocab.4.sroa.0.0867.i, 4
  %t50.i = tail call i64 @llvm.umax.i64(i64 %t47.i, i64 1)
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t51.i, ptr noundef nonnull align 8 dereferenceable(1) %var.vocab.4.sroa.34.0869.i, i64 %t50.i, i1 false)
  br label %push.store.10.i

push.grow.from_heap.16.i:                         ; preds = %mul.ok.14.i
  %t57.i1148 = tail call align 16 ptr @realloc(ptr %var.vocab.4.sroa.34.0869.i, i64 %t45.i1147)
  %t58.i1149 = icmp eq ptr %t57.i1148, null
  br i1 %t58.i1149, label %realloc.oom.24.i, label %push.store.10.i

realloc.oom.24.i:                                 ; preds = %push.grow.from_heap.16.i
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.10.i:                                  ; preds = %push.grow.from_heap.16.i, %push.reg.copy.21.i, %archx_str_concat.exit.i
  %var.vocab.4.sroa.17.1.i = phi i64 [ %var.vocab.4.sroa.17.0868.i, %archx_str_concat.exit.i ], [ %t40.i1145, %push.reg.copy.21.i ], [ %t40.i1145, %push.grow.from_heap.16.i ]
  %var.vocab.4.sroa.34.1.i = phi ptr [ %var.vocab.4.sroa.34.0869.i, %archx_str_concat.exit.i ], [ %t51.i, %push.reg.copy.21.i ], [ %t57.i1148, %push.grow.from_heap.16.i ]
  %t64.i1150 = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.1.i, i64 %var.vocab.4.sroa.0.0867.i
  %t26.elt.i = extractvalue %ArchxStr %common.ret.op.i.i, 0
  store i64 %t26.elt.i, ptr %t64.i1150, align 8
  %t64.repack67.i = getelementptr inbounds nuw i8, ptr %t64.i1150, i64 8
  %t26.elt68.i = extractvalue %ArchxStr %common.ret.op.i.i, 1
  store i64 %t26.elt68.i, ptr %t64.repack67.i, align 8
  %long.i.i = icmp samesign ult i64 %blen.i.i, 13
  %tag.i.i = and i64 %bw1.i.i, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond.i = select i1 %long.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond.i, label %for.step.2.i, label %for.step.2.sink.split.i

if.else.7.i:                                      ; preds = %mod.ok.5.i
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i543.i)
  %n32.i544.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i543.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %var.vocab.4.sroa.0.0867.i)
  %len.i545.i = sext i32 %n32.i544.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i542.i)
  %z.i.i546.i = icmp slt i32 %n32.i544.i, 1
  br i1 %z.i.i546.i, label %archx_str_from_int.exit570.i, label %chk_sso.i.i547.i

oom.i.i562.i:                                     ; preds = %alloc_heap.i.i549.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i547.i:                                 ; preds = %if.else.7.i
  %short.i.i548.i = icmp samesign ult i32 %n32.i544.i, 13
  br i1 %short.i.i548.i, label %pack_sso.i.i563.i, label %alloc_heap.i.i549.i

pack_sso.i.i563.i:                                ; preds = %chk_sso.i.i547.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i542.i, i8 0, i64 16, i1 false)
  store i32 %n32.i544.i, ptr %sso.i.i542.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i542.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i543.i, i64 %len.i545.i, i1 false)
  %sso.i.i542.i.0.sso.i.i542.i.0.sso.i.i542.i.0.sso.i.i542.0.sso.i.i542.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i565.i = load i64, ptr %sso.i.i542.i, align 8
  %sso.i.i542.i.8.sso.i.i542.i.8.sso.i.i542.i.8.sso.i.i542.8.sso.i.i542.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i567.i = load i64, ptr %sso.i.i542.i.8.sroa_idx, align 8
  %ss0.i.i568.i = insertvalue %ArchxStr poison, i64 %sso.i.i542.i.0.sso.i.i542.i.0.sso.i.i542.i.0.sso.i.i542.0.sso.i.i542.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i565.i, 0
  %ss1.i.i569.i = insertvalue %ArchxStr %ss0.i.i568.i, i64 %sso.i.i542.i.8.sso.i.i542.i.8.sso.i.i542.i.8.sso.i.i542.8.sso.i.i542.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i567.i, 1
  br label %archx_str_from_int.exit570.i

alloc_heap.i.i549.i:                              ; preds = %chk_sso.i.i547.i
  %hp.i.i550.i = tail call noalias align 16 ptr @malloc(i64 %len.i545.i)
  %hnull.i.i551.i = icmp eq ptr %hp.i.i550.i, null
  br i1 %hnull.i.i551.i, label %oom.i.i562.i, label %copy_long.i.i552.i

copy_long.i.i552.i:                               ; preds = %alloc_heap.i.i549.i
  %hp_i.i.i553.i = ptrtoint ptr %hp.i.i550.i to i64
  %htagged.i.i554.i = or disjoint i64 %hp_i.i.i553.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i550.i, ptr nonnull readonly align 8 %buf.i543.i, i64 %len.i545.i, i1 false)
  %pref32.i.i555.i = load i32, ptr %hp.i.i550.i, align 16
  %pref64.i.i556.i = zext i32 %pref32.i.i555.i to i64
  %pref_sh.i.i557.i = shl nuw i64 %pref64.i.i556.i, 32
  %w0_out.i.i558.i = or disjoint i64 %pref_sh.i.i557.i, %len.i545.i
  %ls0.i.i559.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i558.i, 0
  %ls1.i.i560.i = insertvalue %ArchxStr %ls0.i.i559.i, i64 %htagged.i.i554.i, 1
  br label %archx_str_from_int.exit570.i

archx_str_from_int.exit570.i:                     ; preds = %copy_long.i.i552.i, %pack_sso.i.i563.i, %if.else.7.i
  %common.ret.op.i.i561.i = phi %ArchxStr [ %ss1.i.i569.i, %pack_sso.i.i563.i ], [ %ls1.i.i560.i, %copy_long.i.i552.i ], [ zeroinitializer, %if.else.7.i ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i542.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i543.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i147.i)
  %bw0.i149.i = extractvalue %ArchxStr %common.ret.op.i.i561.i, 0
  %bw1.i150.i = extractvalue %ArchxStr %common.ret.op.i.i561.i, 1
  %blen.i151.i = and i64 %bw0.i149.i, 4294967295
  %bz.i152.i = icmp eq i64 %blen.i151.i, 0
  br i1 %bz.i152.i, label %archx_str_concat.exit194.i, label %calc_tot.i153.i

calc_tot.i153.i:                                  ; preds = %archx_str_from_int.exit570.i
  %tot.i154.i = add nuw nsw i64 %blen.i151.i, 21
  %too_big.i155.i = icmp samesign ugt i64 %blen.i151.i, 2147483626
  br i1 %too_big.i155.i, label %oom.i178.i, label %mat_a.i156.i

oom.i178.i:                                       ; preds = %alloc_heap.i164.i, %calc_tot.i153.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i156.i:                                     ; preds = %calc_tot.i153.i
  %bshort.i157.i = icmp samesign ult i64 %blen.i151.i, 13
  br i1 %bshort.i157.i, label %mat_b_short.i188.i, label %mat_b_long.i158.i

mat_b_short.i188.i:                               ; preds = %mat_a.i156.i
  %bp4.i189.i = lshr i64 %bw0.i149.i, 32
  %bp4_32.i190.i = trunc nuw i64 %bp4.i189.i to i32
  store i32 %bp4_32.i190.i, ptr %btmp.i147.i, align 4
  store i64 %bw1.i150.i, ptr %btmp4.i191.i, align 4
  br label %alloc_heap.i164.i

mat_b_long.i158.i:                                ; preds = %mat_a.i156.i
  %braw.i159.i = and i64 %bw1.i150.i, -4
  %blptr.i160.i = inttoptr i64 %braw.i159.i to ptr
  br label %alloc_heap.i164.i

alloc_heap.i164.i:                                ; preds = %mat_b_long.i158.i, %mat_b_short.i188.i
  %bptr.i162.i = phi ptr [ %btmp.i147.i, %mat_b_short.i188.i ], [ %blptr.i160.i, %mat_b_long.i158.i ]
  %hp.i165.i = tail call noalias align 16 ptr @malloc(i64 %tot.i154.i)
  %hnull.i166.i = icmp eq ptr %hp.i165.i, null
  br i1 %hnull.i166.i, label %oom.i178.i, label %copy_long.i167.i

copy_long.i167.i:                                 ; preds = %alloc_heap.i164.i
  %hp_i.i168.i = ptrtoint ptr %hp.i165.i to i64
  %htagged.i169.i = or disjoint i64 %hp_i.i168.i, 1
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(21) %hp.i165.i, ptr noundef nonnull align 4 dereferenceable(21) @.str.0, i64 21, i1 false)
  %dst_b.i170.i = getelementptr inbounds nuw i8, ptr %hp.i165.i, i64 21
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i170.i, ptr nonnull align 1 %bptr.i162.i, i64 %blen.i151.i, i1 false)
  %w0_out.i174.i = or disjoint i64 %tot.i154.i, 6061880420251729920
  %ls0.i175.i = insertvalue %ArchxStr poison, i64 %w0_out.i174.i, 0
  %ls1.i176.i = insertvalue %ArchxStr %ls0.i175.i, i64 %htagged.i169.i, 1
  br label %archx_str_concat.exit194.i

archx_str_concat.exit194.i:                       ; preds = %copy_long.i167.i, %archx_str_from_int.exit570.i
  %common.ret.op.i177.i = phi %ArchxStr [ %ls1.i176.i, %copy_long.i167.i ], [ { i64 6061880420251729941, i64 ptrtoint (ptr @.str.0 to i64) }, %archx_str_from_int.exit570.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i147.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i195.i)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i197.i)
  %aw0.i.i = extractvalue %ArchxStr %common.ret.op.i177.i, 0
  %aw1.i.i = extractvalue %ArchxStr %common.ret.op.i177.i, 1
  %alen.i.i = and i64 %aw0.i.i, 4294967295
  %az.i.i = icmp eq i64 %alen.i.i, 0
  br i1 %az.i.i, label %archx_str_concat.exit232.thread.i, label %chk_bz.i.i

chk_bz.i.i:                                       ; preds = %archx_str_concat.exit194.i
  %tot.i199.i = add nuw nsw i64 %alen.i.i, 2
  %too_big.i200.i = icmp samesign ugt i64 %alen.i.i, 2147483645
  br i1 %too_big.i200.i, label %oom.i221.i, label %mat_a.i201.i

oom.i221.i:                                       ; preds = %alloc_heap.i207.i, %chk_bz.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i201.i:                                     ; preds = %chk_bz.i.i
  %ashort.i.i = icmp samesign ult i64 %alen.i.i, 13
  br i1 %ashort.i.i, label %mat_b.i.i, label %mat_b.i.thread.i

mat_b.i.thread.i:                                 ; preds = %mat_a.i201.i
  %araw.i.i = and i64 %aw1.i.i, -4
  %alptr.i.i = inttoptr i64 %araw.i.i to ptr
  br label %alloc_heap.i207.i

mat_b.i.i:                                        ; preds = %mat_a.i201.i
  %ap4.i.i = lshr i64 %aw0.i.i, 32
  %ap4_32.i.i = trunc nuw i64 %ap4.i.i to i32
  store i32 %ap4_32.i.i, ptr %atmp.i195.i, align 4
  store i64 %aw1.i.i, ptr %atmp4.i231.i, align 4
  %fits_sso.i206.i = icmp samesign ult i64 %alen.i.i, 11
  br i1 %fits_sso.i206.i, label %build_sso.i222.i, label %alloc_heap.i207.i

build_sso.i222.i:                                 ; preds = %mat_b.i.i
  %tot32.i224.i = trunc nuw nsw i64 %tot.i199.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i197.i, i8 0, i64 16, i1 false)
  store i32 %tot32.i224.i, ptr %out_sso.i197.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i225.i, ptr nonnull align 4 %atmp.i195.i, i64 %alen.i.i, i1 false)
  %sso_dst_b.i226.i = getelementptr inbounds nuw i8, ptr %sso_dst_a.i225.i, i64 %alen.i.i
  store i16 8224, ptr %sso_dst_b.i226.i, align 1
  %rw0.i227.i = load i64, ptr %out_sso.i197.i, align 8
  %rw1.i228.i = load i64, ptr %out_sso8.i223.i, align 8
  %rs0.i229.i = insertvalue %ArchxStr poison, i64 %rw0.i227.i, 0
  %rs1.i230.i = insertvalue %ArchxStr %rs0.i229.i, i64 %rw1.i228.i, 1
  br label %archx_str_concat.exit232.thread.i

alloc_heap.i207.i:                                ; preds = %mat_b.i.i, %mat_b.i.thread.i
  %aptr.i767.i = phi ptr [ %alptr.i.i, %mat_b.i.thread.i ], [ %atmp.i195.i, %mat_b.i.i ]
  %hp.i208.i = tail call noalias align 16 ptr @malloc(i64 %tot.i199.i)
  %hnull.i209.i = icmp eq ptr %hp.i208.i, null
  br i1 %hnull.i209.i, label %oom.i221.i, label %archx_str_concat.exit232.i

archx_str_concat.exit232.thread.i:                ; preds = %build_sso.i222.i, %archx_str_concat.exit194.i
  %common.ret.op.i220.ph.i = phi %ArchxStr [ { i64 35321811042306, i64 0 }, %archx_str_concat.exit194.i ], [ %rs1.i230.i, %build_sso.i222.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i195.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i197.i)
  br label %archx_str_drop.exit79.i

archx_str_concat.exit232.i:                       ; preds = %alloc_heap.i207.i
  %hp_i.i211.i = ptrtoint ptr %hp.i208.i to i64
  %htagged.i212.i = or disjoint i64 %hp_i.i211.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i208.i, ptr nonnull align 1 %aptr.i767.i, i64 %alen.i.i, i1 false)
  %dst_b.i213.i = getelementptr inbounds nuw i8, ptr %hp.i208.i, i64 %alen.i.i
  store i16 8224, ptr %dst_b.i213.i, align 1
  %pref32.i214.i = load i32, ptr %hp.i208.i, align 16
  %pref64.i215.i = zext i32 %pref32.i214.i to i64
  %pref_sh.i216.i = shl nuw i64 %pref64.i215.i, 32
  %w0_out.i217.i = or disjoint i64 %pref_sh.i216.i, %tot.i199.i
  %ls0.i218.i = insertvalue %ArchxStr poison, i64 %w0_out.i217.i, 0
  %ls1.i219.i = insertvalue %ArchxStr %ls0.i218.i, i64 %htagged.i212.i, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i195.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i197.i)
  %tag.i74.i = and i64 %aw1.i.i, 1
  %owned.not.i75.i = icmp eq i64 %tag.i74.i, 0
  %or.cond780.i = select i1 %ashort.i.i, i1 true, i1 %owned.not.i75.i
  br i1 %or.cond780.i, label %archx_str_drop.exit79.i, label %do_free.i76.i

do_free.i76.i:                                    ; preds = %archx_str_concat.exit232.i
  %raw.i77.i = and i64 %aw1.i.i, -2
  %ptr.i78.i = inttoptr i64 %raw.i77.i to ptr
  tail call void @free(ptr %ptr.i78.i)
  br label %archx_str_drop.exit79.i

archx_str_drop.exit79.i:                          ; preds = %do_free.i76.i, %archx_str_concat.exit232.i, %archx_str_concat.exit232.thread.i
  %common.ret.op.i220770.i = phi %ArchxStr [ %common.ret.op.i220.ph.i, %archx_str_concat.exit232.thread.i ], [ %ls1.i219.i, %archx_str_concat.exit232.i ], [ %ls1.i219.i, %do_free.i76.i ]
  %long.i82.i = icmp samesign ult i64 %blen.i151.i, 13
  %tag.i85.i = and i64 %bw1.i150.i, 1
  %owned.not.i86.i = icmp eq i64 %tag.i85.i, 0
  %or.cond781.i = select i1 %long.i82.i, i1 true, i1 %owned.not.i86.i
  br i1 %or.cond781.i, label %archx_str_drop.exit90.i, label %do_free.i87.i

do_free.i87.i:                                    ; preds = %archx_str_drop.exit79.i
  %raw.i88.i = and i64 %bw1.i150.i, -2
  %ptr.i89.i = inttoptr i64 %raw.i88.i to ptr
  tail call void @free(ptr %ptr.i89.i)
  br label %archx_str_drop.exit90.i

archx_str_drop.exit90.i:                          ; preds = %do_free.i87.i, %archx_str_drop.exit79.i
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i.i)
  %w0.i575.i = extractvalue %ArchxStr %common.ret.op.i220770.i, 0
  %w1.i576.i = extractvalue %ArchxStr %common.ret.op.i220770.i, 1
  %len.i577.i = and i64 %w0.i575.i, 4294967295
  %short.i.i = icmp samesign ult i64 %len.i577.i, 13
  br i1 %short.i.i, label %trim_l_pre.i.i, label %trim_l_pre.thread.i.i

trim_l_pre.thread.i.i:                            ; preds = %archx_str_drop.exit90.i
  %raw.i578.i = and i64 %w1.i576.i, -4
  %lp.i.i = inttoptr i64 %raw.i578.i to ptr
  br label %trim_l_chk.preheader.i.i

trim_l_pre.i.i:                                   ; preds = %archx_str_drop.exit90.i
  %p4.i.i = lshr i64 %w0.i575.i, 32
  %p4_32.i.i = trunc nuw i64 %p4.i.i to i32
  store i32 %p4_32.i.i, ptr %tmp.i.i, align 4
  store i64 %w1.i576.i, ptr %t4.i.i1137, align 4
  %lo_lt4.not.i.i = icmp eq i64 %len.i577.i, 0
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
  %hi_gt6.i.i = icmp samesign ugt i64 %len.i577.i, %lo5.i.i
  br i1 %hi_gt6.i.i, label %trim_r_chk.i.i, label %archx_str_strip.exit.i

trim_l_ws.i.i:                                    ; preds = %trim_l_chk.i.i, %trim_l_chk.i.i, %trim_l_chk.i.i, %trim_l_chk.i.i, %trim_l_chk.i.i, %trim_l_chk.i.i
  %lo_next.i.i = add nuw nsw i64 %lo5.i.i, 1
  %exitcond.not.i.i = icmp eq i64 %lo_next.i.i, %len.i577.i
  br i1 %exitcond.not.i.i, label %archx_str_strip.exit.i, label %trim_l_chk.i.i

trim_r_chk.i.i:                                   ; preds = %trim_r.preheader.i.i, %trim_r.backedge.i.i
  %hi7.i.i = phi i64 [ %hi_prev.i.i, %trim_r.backedge.i.i ], [ %len.i577.i, %trim_r.preheader.i.i ]
  %hi_prev.i.i = add nsw i64 %hi7.i.i, -1
  %rp_c.i.i = getelementptr inbounds nuw i8, ptr %data15.i.i, i64 %hi_prev.i.i
  %rc.i.i = load i8, ptr %rp_c.i.i, align 1
  switch i8 %rc.i.i, label %build.i580.i [
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

build.i580.i:                                     ; preds = %trim_r_chk.i.i
  %nlen.i.i = sub nuw nsw i64 %hi7.i.i, %lo5.i.i
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i574.i)
  %z.i.i581.i = icmp slt i64 %nlen.i.i, 1
  br i1 %z.i.i581.i, label %archx_str_from_slice.exit.i.i, label %chk_big.i.i.i

chk_big.i.i.i:                                    ; preds = %build.i580.i
  %big.i.i.i = icmp samesign ugt i64 %nlen.i.i, 2147483647
  br i1 %big.i.i.i, label %oom.i.i597.i, label %chk_sso.i.i582.i

oom.i.i597.i:                                     ; preds = %alloc_heap.i.i584.i, %chk_big.i.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i582.i:                                 ; preds = %chk_big.i.i.i
  %short.i.i583.i = icmp samesign ult i64 %nlen.i.i, 13
  br i1 %short.i.i583.i, label %pack_sso.i.i598.i, label %alloc_heap.i.i584.i

pack_sso.i.i598.i:                                ; preds = %chk_sso.i.i582.i
  %len32.i.i.i = trunc nuw nsw i64 %nlen.i.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i574.i, i8 0, i64 16, i1 false)
  store i32 %len32.i.i.i, ptr %sso.i.i574.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i574.i.4.sroa_idx, ptr nonnull readonly align 1 %lp_c.i.i.le, i64 %nlen.i.i, i1 false)
  %sso.i.i574.i.0.sso.i.i574.i.0.sso.i.i574.i.0.sso.i.i574.0.sso.i.i574.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i599.i = load i64, ptr %sso.i.i574.i, align 8
  %sso.i.i574.i.8.sso.i.i574.i.8.sso.i.i574.i.8.sso.i.i574.8.sso.i.i574.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i600.i = load i64, ptr %sso.i.i574.i.8.sroa_idx, align 8
  %ss0.i.i601.i = insertvalue %ArchxStr poison, i64 %sso.i.i574.i.0.sso.i.i574.i.0.sso.i.i574.i.0.sso.i.i574.0.sso.i.i574.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i599.i, 0
  %ss1.i.i602.i = insertvalue %ArchxStr %ss0.i.i601.i, i64 %sso.i.i574.i.8.sso.i.i574.i.8.sso.i.i574.i.8.sso.i.i574.8.sso.i.i574.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i600.i, 1
  br label %archx_str_from_slice.exit.i.i

alloc_heap.i.i584.i:                              ; preds = %chk_sso.i.i582.i
  %hp.i.i585.i = tail call noalias align 16 ptr @malloc(i64 %nlen.i.i)
  %hnull.i.i586.i = icmp eq ptr %hp.i.i585.i, null
  br i1 %hnull.i.i586.i, label %oom.i.i597.i, label %copy_long.i.i587.i

copy_long.i.i587.i:                               ; preds = %alloc_heap.i.i584.i
  %hp_i.i.i588.i = ptrtoint ptr %hp.i.i585.i to i64
  %htagged.i.i589.i = or disjoint i64 %hp_i.i.i588.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i585.i, ptr nonnull readonly align 1 %lp_c.i.i.le, i64 %nlen.i.i, i1 false)
  %pref32.i.i590.i = load i32, ptr %hp.i.i585.i, align 16
  %pref64.i.i591.i = zext i32 %pref32.i.i590.i to i64
  %pref_sh.i.i592.i = shl nuw i64 %pref64.i.i591.i, 32
  %w0_out.i.i593.i = or disjoint i64 %pref_sh.i.i592.i, %nlen.i.i
  %ls0.i.i594.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i593.i, 0
  %ls1.i.i595.i = insertvalue %ArchxStr %ls0.i.i594.i, i64 %htagged.i.i589.i, 1
  br label %archx_str_from_slice.exit.i.i

archx_str_from_slice.exit.i.i:                    ; preds = %copy_long.i.i587.i, %pack_sso.i.i598.i, %build.i580.i
  %common.ret.op.i.i596.i = phi %ArchxStr [ %ss1.i.i602.i, %pack_sso.i.i598.i ], [ %ls1.i.i595.i, %copy_long.i.i587.i ], [ zeroinitializer, %build.i580.i ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i574.i)
  br label %archx_str_strip.exit.i

archx_str_strip.exit.i:                           ; preds = %trim_l_ws.i.i, %trim_r.backedge.i.i, %archx_str_from_slice.exit.i.i, %trim_r.preheader.i.i, %trim_l_pre.i.i
  %common.ret.op.i579.i = phi %ArchxStr [ %common.ret.op.i.i596.i, %archx_str_from_slice.exit.i.i ], [ zeroinitializer, %trim_r.preheader.i.i ], [ zeroinitializer, %trim_l_pre.i.i ], [ zeroinitializer, %trim_r.backedge.i.i ], [ zeroinitializer, %trim_l_ws.i.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i604.i)
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %sbuf.i.i)
  %w0.i605.i = extractvalue %ArchxStr %common.ret.op.i579.i, 0
  %w1.i606.i = extractvalue %ArchxStr %common.ret.op.i579.i, 1
  %len.i607.i = and i64 %w0.i605.i, 4294967295
  %z.i.i = icmp eq i64 %len.i607.i, 0
  br i1 %z.i.i, label %archx_str_case.exit.i, label %mat.i.i

mat.i.i:                                          ; preds = %archx_str_strip.exit.i
  %short.i608.i = icmp samesign ult i64 %len.i607.i, 13
  br i1 %short.i608.i, label %alloc_dst.thread.i.i, label %alloc_dst.i.i

alloc_dst.thread.i.i:                             ; preds = %mat.i.i
  %p4.i636.i = lshr i64 %w0.i605.i, 32
  %p4_32.i637.i = trunc nuw i64 %p4.i636.i to i32
  store i32 %p4_32.i637.i, ptr %tmp.i604.i, align 4
  store i64 %w1.i606.i, ptr %t4.i638.i, align 4
  br label %iter.check

alloc_dst.i.i:                                    ; preds = %mat.i.i
  %raw.i609.i = and i64 %w1.i606.i, -4
  %lp.i610.i = inttoptr i64 %raw.i609.i to ptr
  %fits.i.i = icmp samesign ugt i64 %len.i607.i, 64
  br i1 %fits.i.i, label %use_heap.i.i, label %iter.check

use_heap.i.i:                                     ; preds = %alloc_dst.i.i
  %hp.i634.i = tail call noalias ptr @malloc(i64 %len.i607.i)
  %hn.i.i = icmp eq ptr %hp.i634.i, null
  br i1 %hn.i.i, label %oom.i635.i, label %iter.check

oom.i635.i:                                       ; preds = %use_heap.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

iter.check:                                       ; preds = %use_heap.i.i, %alloc_dst.i.i, %alloc_dst.thread.i.i
  %fits4.i.i = phi i1 [ true, %use_heap.i.i ], [ false, %alloc_dst.i.i ], [ false, %alloc_dst.thread.i.i ]
  %src3.i.i = phi ptr [ %lp.i610.i, %use_heap.i.i ], [ %lp.i610.i, %alloc_dst.i.i ], [ %tmp.i604.i, %alloc_dst.thread.i.i ]
  %dst.i.i = phi ptr [ %hp.i634.i, %use_heap.i.i ], [ %sbuf.i.i, %alloc_dst.i.i ], [ %sbuf.i.i, %alloc_dst.thread.i.i ]
  %min.iters.check = icmp samesign ult i64 %len.i607.i, 8
  br i1 %min.iters.check, label %loop.i.i.preheader, label %vector.main.loop.iter.check

vector.main.loop.iter.check:                      ; preds = %iter.check
  %min.iters.check2035 = icmp samesign ult i64 %len.i607.i, 32
  br i1 %min.iters.check2035, label %vec.epilog.ph, label %vector.ph2036

vector.ph2036:                                    ; preds = %vector.main.loop.iter.check
  %n.vec = and i64 %w0.i605.i, 4294967264
  br label %vector.body2037

vector.body2037:                                  ; preds = %vector.body2037, %vector.ph2036
  %index2038 = phi i64 [ 0, %vector.ph2036 ], [ %index.next2041, %vector.body2037 ]
  %33 = getelementptr inbounds nuw i8, ptr %src3.i.i, i64 %index2038
  %34 = getelementptr inbounds nuw i8, ptr %33, i64 16
  %wide.load2039 = load <16 x i8>, ptr %33, align 1
  %wide.load2040 = load <16 x i8>, ptr %34, align 1
  %35 = add <16 x i8> %wide.load2039, splat (i8 -65)
  %36 = add <16 x i8> %wide.load2040, splat (i8 -65)
  %37 = icmp ult <16 x i8> %35, splat (i8 26)
  %38 = icmp ult <16 x i8> %36, splat (i8 26)
  %39 = add <16 x i8> %wide.load2039, splat (i8 32)
  %40 = add <16 x i8> %wide.load2040, splat (i8 32)
  %41 = select <16 x i1> %37, <16 x i8> %39, <16 x i8> %wide.load2039
  %42 = select <16 x i1> %38, <16 x i8> %40, <16 x i8> %wide.load2040
  %43 = getelementptr inbounds nuw i8, ptr %dst.i.i, i64 %index2038
  %44 = getelementptr inbounds nuw i8, ptr %43, i64 16
  store <16 x i8> %41, ptr %43, align 1
  store <16 x i8> %42, ptr %44, align 1
  %index.next2041 = add nuw i64 %index2038, 32
  %45 = icmp eq i64 %index.next2041, %n.vec
  br i1 %45, label %middle.block2042, label %vector.body2037, !llvm.loop !4

middle.block2042:                                 ; preds = %vector.body2037
  %cmp.n = icmp eq i64 %len.i607.i, %n.vec
  br i1 %cmp.n, label %chk_big.i.i612.i, label %vec.epilog.iter.check

vec.epilog.iter.check:                            ; preds = %middle.block2042
  %n.vec.remaining = and i64 %w0.i605.i, 24
  %min.epilog.iters.check = icmp eq i64 %n.vec.remaining, 0
  br i1 %min.epilog.iters.check, label %loop.i.i.preheader, label %vec.epilog.ph

vec.epilog.ph:                                    ; preds = %vec.epilog.iter.check, %vector.main.loop.iter.check
  %vec.epilog.resume.val = phi i64 [ %n.vec, %vec.epilog.iter.check ], [ 0, %vector.main.loop.iter.check ]
  %n.vec2044 = and i64 %w0.i605.i, 4294967288
  br label %vec.epilog.vector.body

vec.epilog.vector.body:                           ; preds = %vec.epilog.vector.body, %vec.epilog.ph
  %index2045 = phi i64 [ %vec.epilog.resume.val, %vec.epilog.ph ], [ %index.next2047, %vec.epilog.vector.body ]
  %46 = getelementptr inbounds nuw i8, ptr %src3.i.i, i64 %index2045
  %wide.load2046 = load <8 x i8>, ptr %46, align 1
  %47 = add <8 x i8> %wide.load2046, splat (i8 -65)
  %48 = icmp ult <8 x i8> %47, splat (i8 26)
  %49 = add <8 x i8> %wide.load2046, splat (i8 32)
  %50 = select <8 x i1> %48, <8 x i8> %49, <8 x i8> %wide.load2046
  %51 = getelementptr inbounds nuw i8, ptr %dst.i.i, i64 %index2045
  store <8 x i8> %50, ptr %51, align 1
  %index.next2047 = add nuw i64 %index2045, 8
  %52 = icmp eq i64 %index.next2047, %n.vec2044
  br i1 %52, label %vec.epilog.middle.block, label %vec.epilog.vector.body, !llvm.loop !5

vec.epilog.middle.block:                          ; preds = %vec.epilog.vector.body
  %cmp.n2048 = icmp eq i64 %len.i607.i, %n.vec2044
  br i1 %cmp.n2048, label %chk_big.i.i612.i, label %loop.i.i.preheader

loop.i.i.preheader:                               ; preds = %vec.epilog.iter.check, %vec.epilog.middle.block, %iter.check
  %i.i.i.ph = phi i64 [ 0, %iter.check ], [ %n.vec, %vec.epilog.iter.check ], [ %n.vec2044, %vec.epilog.middle.block ]
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
  %exitcond.not.i611.i = icmp eq i64 %inext.i.i, %len.i607.i
  br i1 %exitcond.not.i611.i, label %chk_big.i.i612.i, label %loop.i.i, !llvm.loop !6

chk_big.i.i612.i:                                 ; preds = %loop.i.i, %vec.epilog.middle.block, %middle.block2042
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i603.i)
  %big.i.i613.i = icmp samesign ugt i64 %len.i607.i, 2147483647
  br i1 %big.i.i613.i, label %oom.i.i629.i, label %chk_sso.i.i614.i

oom.i.i629.i:                                     ; preds = %alloc_heap.i.i615.i, %chk_big.i.i612.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i614.i:                                 ; preds = %chk_big.i.i612.i
  br i1 %short.i608.i, label %pack_sso.i.i630.i, label %alloc_heap.i.i615.i

pack_sso.i.i630.i:                                ; preds = %chk_sso.i.i614.i
  %len32.i.i631.i = trunc i64 %w0.i605.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i603.i, i8 0, i64 16, i1 false)
  store i32 %len32.i.i631.i, ptr %sso.i.i603.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i603.i.4.sroa_idx, ptr nonnull readonly align 1 %dst.i.i, i64 %len.i607.i, i1 false)
  %sso.i.i603.i.0.sso.i.i603.i.0.sso.i.i603.i.0.sso.i.i603.0.sso.i.i603.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i632.i = load i64, ptr %sso.i.i603.i, align 8
  %sso.i.i603.i.8.sso.i.i603.i.8.sso.i.i603.i.8.sso.i.i603.8.sso.i.i603.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i633.i = load i64, ptr %sso.i.i603.i.8.sroa_idx, align 8
  br label %archx_str_from_slice.exit.i625.i

alloc_heap.i.i615.i:                              ; preds = %chk_sso.i.i614.i
  %hp.i.i616.i = tail call noalias align 16 ptr @malloc(i64 %len.i607.i)
  %hnull.i.i617.i = icmp eq ptr %hp.i.i616.i, null
  br i1 %hnull.i.i617.i, label %oom.i.i629.i, label %copy_long.i.i618.i

copy_long.i.i618.i:                               ; preds = %alloc_heap.i.i615.i
  %hp_i.i.i619.i = ptrtoint ptr %hp.i.i616.i to i64
  %htagged.i.i620.i = or disjoint i64 %hp_i.i.i619.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i616.i, ptr nonnull readonly align 1 %dst.i.i, i64 %len.i607.i, i1 false)
  %pref32.i.i621.i = load i32, ptr %hp.i.i616.i, align 16
  %pref64.i.i622.i = zext i32 %pref32.i.i621.i to i64
  %pref_sh.i.i623.i = shl nuw i64 %pref64.i.i622.i, 32
  %w0_out.i.i624.i = or disjoint i64 %pref_sh.i.i623.i, %len.i607.i
  br label %archx_str_from_slice.exit.i625.i

archx_str_from_slice.exit.i625.i:                 ; preds = %copy_long.i.i618.i, %pack_sso.i.i630.i
  %sso.i.0.sso.0.sso.0.sso.0.sw0.i.pn.i.i = phi i64 [ %sso.i.i603.i.0.sso.i.i603.i.0.sso.i.i603.i.0.sso.i.i603.0.sso.i.i603.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i632.i, %pack_sso.i.i630.i ], [ %w0_out.i.i624.i, %copy_long.i.i618.i ]
  %sso.i.8.sso.8.sso.8.sso.8.sw1.i.pn.i.i = phi i64 [ %sso.i.i603.i.8.sso.i.i603.i.8.sso.i.i603.i.8.sso.i.i603.8.sso.i.i603.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i633.i, %pack_sso.i.i630.i ], [ %htagged.i.i620.i, %copy_long.i.i618.i ]
  %ss0.i.pn.i.i = insertvalue %ArchxStr poison, i64 %sso.i.0.sso.0.sso.0.sso.0.sw0.i.pn.i.i, 0
  %common.ret.op.i.i626.i = insertvalue %ArchxStr %ss0.i.pn.i.i, i64 %sso.i.8.sso.8.sso.8.sso.8.sw1.i.pn.i.i, 1
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i603.i)
  br i1 %fits4.i.i, label %do_free.i628.i, label %archx_str_case.exit.i

do_free.i628.i:                                   ; preds = %archx_str_from_slice.exit.i625.i
  call void @free(ptr nonnull %dst.i.i)
  br label %archx_str_case.exit.i

archx_str_case.exit.i:                            ; preds = %do_free.i628.i, %archx_str_from_slice.exit.i625.i, %archx_str_strip.exit.i
  %common.ret.op.i627.i = phi %ArchxStr [ zeroinitializer, %archx_str_strip.exit.i ], [ %common.ret.op.i.i626.i, %do_free.i628.i ], [ %common.ret.op.i.i626.i, %archx_str_from_slice.exit.i625.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i604.i)
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %sbuf.i.i)
  %t82.i = icmp slt i64 %var.vocab.4.sroa.17.0868.i, 0
  %t84.i1139 = tail call i64 @llvm.abs.i64(i64 %var.vocab.4.sroa.17.0868.i, i1 true)
  %t85.not.i = icmp samesign ult i64 %var.vocab.4.sroa.0.0867.i, %t84.i1139
  br i1 %t85.not.i, label %push.store.26.i, label %push.calc.28.i

push.calc.28.i:                                   ; preds = %archx_str_case.exit.i
  %t87.i = icmp eq i64 %var.vocab.4.sroa.17.0868.i, 0
  %t88.i = shl nuw i64 %t84.i1139, 1
  %53 = tail call i64 @llvm.smin.i64(i64 %t88.i, i64 140737488355328)
  %t91.i = select i1 %t87.i, i64 4, i64 %53
  %54 = add i64 %t91.i, -576460752303423488
  %t94.i = icmp ult i64 %54, -1152921504606846976
  br i1 %t94.i, label %mul.oom.29.i, label %mul.ok.30.i

mul.oom.29.i:                                     ; preds = %push.calc.28.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mul.ok.30.i:                                      ; preds = %push.calc.28.i
  %t93.i1140 = shl nsw i64 %t91.i, 4
  %t96.i = tail call i64 @llvm.umax.i64(i64 %t93.i1140, i64 1)
  br i1 %t82.i, label %mul.ok.34.i, label %push.grow.from_heap.32.i

mul.ok.34.i:                                      ; preds = %mul.ok.30.i
  %t102.i = tail call noalias align 16 ptr @malloc(i64 %t96.i)
  %t103.i = icmp eq ptr %t102.i, null
  br i1 %t103.i, label %alloc.oom.36.i, label %push.reg.copy.37.i

alloc.oom.36.i:                                   ; preds = %mul.ok.34.i
  tail call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.37.i:                               ; preds = %mul.ok.34.i
  %t98.i = shl nuw nsw i64 %var.vocab.4.sroa.0.0867.i, 4
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t102.i, ptr noundef nonnull align 8 dereferenceable(1) %var.vocab.4.sroa.34.0869.i, i64 %t98.i, i1 false)
  br label %push.store.26.i

push.grow.from_heap.32.i:                         ; preds = %mul.ok.30.i
  %t108.i = tail call align 16 ptr @realloc(ptr %var.vocab.4.sroa.34.0869.i, i64 %t96.i)
  %t109.i = icmp eq ptr %t108.i, null
  br i1 %t109.i, label %realloc.oom.40.i, label %push.store.26.i

realloc.oom.40.i:                                 ; preds = %push.grow.from_heap.32.i
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.26.i:                                  ; preds = %push.grow.from_heap.32.i, %push.reg.copy.37.i, %archx_str_case.exit.i
  %var.vocab.4.sroa.17.2.i = phi i64 [ %var.vocab.4.sroa.17.0868.i, %archx_str_case.exit.i ], [ %t91.i, %push.reg.copy.37.i ], [ %t91.i, %push.grow.from_heap.32.i ]
  %var.vocab.4.sroa.34.2.i = phi ptr [ %var.vocab.4.sroa.34.0869.i, %archx_str_case.exit.i ], [ %t102.i, %push.reg.copy.37.i ], [ %t108.i, %push.grow.from_heap.32.i ]
  %t115.i1141 = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.2.i, i64 %var.vocab.4.sroa.0.0867.i
  %t77.elt.i = extractvalue %ArchxStr %common.ret.op.i627.i, 0
  store i64 %t77.elt.i, ptr %t115.i1141, align 8
  %t115.repack65.i = getelementptr inbounds nuw i8, ptr %t115.i1141, i64 8
  %t77.elt66.i = extractvalue %ArchxStr %common.ret.op.i627.i, 1
  store i64 %t77.elt66.i, ptr %t115.repack65.i, align 8
  %long.i93.i = icmp samesign ult i64 %len.i607.i, 13
  %tag.i96.i = and i64 %w1.i606.i, 1
  %owned.not.i97.i = icmp eq i64 %tag.i96.i, 0
  %or.cond782.i = select i1 %long.i93.i, i1 true, i1 %owned.not.i97.i
  br i1 %or.cond782.i, label %archx_str_drop.exit101.i, label %do_free.i98.i

do_free.i98.i:                                    ; preds = %push.store.26.i
  %raw.i99.i = and i64 %w1.i606.i, -2
  %ptr.i100.i = inttoptr i64 %raw.i99.i to ptr
  tail call void @free(ptr %ptr.i100.i)
  br label %archx_str_drop.exit101.i

archx_str_drop.exit101.i:                         ; preds = %do_free.i98.i, %push.store.26.i
  %tag.i107.i = and i64 %w1.i576.i, 1
  %owned.not.i108.i = icmp eq i64 %tag.i107.i, 0
  %or.cond783.i = select i1 %short.i.i, i1 true, i1 %owned.not.i108.i
  br i1 %or.cond783.i, label %for.step.2.i, label %for.step.2.sink.split.i

for.step.2.sink.split.i:                          ; preds = %archx_str_drop.exit101.i, %push.store.10.i
  %w1.i576.sink.i = phi i64 [ %bw1.i.i, %push.store.10.i ], [ %w1.i576.i, %archx_str_drop.exit101.i ]
  %var.vocab.4.sroa.17.3.ph.i = phi i64 [ %var.vocab.4.sroa.17.1.i, %push.store.10.i ], [ %var.vocab.4.sroa.17.2.i, %archx_str_drop.exit101.i ]
  %var.vocab.4.sroa.34.3.ph.i = phi ptr [ %var.vocab.4.sroa.34.1.i, %push.store.10.i ], [ %var.vocab.4.sroa.34.2.i, %archx_str_drop.exit101.i ]
  %raw.i110.i = and i64 %w1.i576.sink.i, -2
  %ptr.i111.i = inttoptr i64 %raw.i110.i to ptr
  tail call void @free(ptr %ptr.i111.i)
  br label %for.step.2.i

for.step.2.i:                                     ; preds = %for.step.2.sink.split.i, %archx_str_drop.exit101.i, %push.store.10.i
  %var.vocab.4.sroa.17.3.i = phi i64 [ %var.vocab.4.sroa.17.1.i, %push.store.10.i ], [ %var.vocab.4.sroa.17.2.i, %archx_str_drop.exit101.i ], [ %var.vocab.4.sroa.17.3.ph.i, %for.step.2.sink.split.i ]
  %var.vocab.4.sroa.34.3.i = phi ptr [ %var.vocab.4.sroa.34.1.i, %push.store.10.i ], [ %var.vocab.4.sroa.34.2.i, %archx_str_drop.exit101.i ], [ %var.vocab.4.sroa.34.3.ph.i, %for.step.2.sink.split.i ]
  %var.vocab.4.sroa.0.3.i = add nuw nsw i64 %var.vocab.4.sroa.0.0867.i, 1
  %exitcond.not.i1142 = icmp eq i64 %var.vocab.4.sroa.0.3.i, 512
  br i1 %exitcond.not.i1142, label %for.end.3.i, label %mod.ok.5.i

for.end.3.i:                                      ; preds = %for.step.2.i
  %buf.i639.i = tail call noalias dereferenceable_or_null(20) ptr @malloc(i64 20)
  %bnull.i.i = icmp eq ptr %buf.i639.i, null
  br i1 %bnull.i.i, label %oom.i651.i, label %sloop.preheader.i.i

sloop.preheader.i.i:                              ; preds = %for.end.3.i
  store <16 x i8> <i8 110, i8 111, i8 104, i8 116, i8 121, i8 112, i8 95, i8 115, i8 109, i8 101, i8 116, i8 115, i8 121, i8 115, i8 95, i8 120>, ptr %buf.i639.i, align 1
  %dp.16.i.i = getelementptr inbounds nuw i8, ptr %buf.i639.i, i64 16
  store <4 x i8> <i8 104, i8 99, i8 114, i8 97>, ptr %dp.16.i.i, align 1
  %hp.i.i640.i = tail call noalias align 16 dereferenceable_or_null(20) ptr @malloc(i64 20)
  %hnull.i.i641.i = icmp eq ptr %hp.i.i640.i, null
  br i1 %hnull.i.i641.i, label %oom.i.i650.i, label %archx_str_slice.exit.i

oom.i651.i:                                       ; preds = %for.end.3.i
  tail call fastcc void @archx_oom_fail()
  unreachable

oom.i.i650.i:                                     ; preds = %sloop.preheader.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

archx_str_slice.exit.i:                           ; preds = %sloop.preheader.i.i
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(20) %hp.i.i640.i, ptr noundef nonnull readonly align 1 dereferenceable(20) %buf.i639.i, i64 20, i1 false)
  %pref32.i.i644.i = load i32, ptr %hp.i.i640.i, align 16
  tail call void @free(ptr nonnull %buf.i639.i)
  br label %for.body.42.i

for.body.42.i:                                    ; preds = %archx_region_rewind_root.exit.i, %archx_str_slice.exit.i
  %var.checksum.127.0903.i = phi i64 [ 0, %archx_str_slice.exit.i ], [ %var.checksum.127.3.lcssa968.i, %archx_region_rewind_root.exit.i ]
  %for.r.131.0902.i = phi i64 [ 0, %archx_str_slice.exit.i ], [ %t350.i, %archx_region_rewind_root.exit.i ]
  %cur.i.i.i = load ptr, ptr %func.region.i, align 8
  %end.i.i.i = load ptr, ptr %.fca.1.gep.i, align 8
  %cur_i.i.i.i = ptrtoint ptr %cur.i.i.i to i64
  %end_i.i.i.i = ptrtoint ptr %end.i.i.i to i64
  %rem.i.i.i = sub i64 %end_i.i.i.i, %cur_i.i.i.i
  %fits.not.i.i.i = icmp slt i64 %rem.i.i.i, 64
  br i1 %fits.not.i.i.i, label %fallback.i.i.i, label %fast.i.i.i

fast.i.i.i:                                       ; preds = %for.body.42.i
  %next.i.i.i = getelementptr inbounds nuw i8, ptr %cur.i.i.i, i64 64
  store ptr %next.i.i.i, ptr %func.region.i, align 8
  br label %archx_dict_new.exit.i

fallback.i.i.i:                                   ; preds = %for.body.42.i
  %res.i.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 64)
  %.pre.i.i = ptrtoint ptr %res.i.i.i to i64
  %cur.i.i654.pre.i = load ptr, ptr %func.region.i, align 8
  %end.i.i655.pre.i = load ptr, ptr %.fca.1.gep.i, align 8
  %.pre.i = ptrtoint ptr %end.i.i655.pre.i to i64
  br label %archx_dict_new.exit.i

archx_dict_new.exit.i:                            ; preds = %fallback.i.i.i, %fast.i.i.i
  %end_i.i.i657.pre-phi.i = phi i64 [ %end_i.i.i.i, %fast.i.i.i ], [ %.pre.i, %fallback.i.i.i ]
  %cur.i.i654.i = phi ptr [ %next.i.i.i, %fast.i.i.i ], [ %cur.i.i654.pre.i, %fallback.i.i.i ]
  %rpi.pre-phi.i.i = phi i64 [ %cur_i.i.i.i, %fast.i.i.i ], [ %.pre.i.i, %fallback.i.i.i ]
  %common.ret.op.i.i652.i = phi ptr [ %cur.i.i.i, %fast.i.i.i ], [ %res.i.i.i, %fallback.i.i.i ]
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(64) %common.ret.op.i.i652.i, i8 0, i64 64, i1 false)
  %r_reg_gep.i.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i652.i, i64 24
  store ptr %func.region.i, ptr %r_reg_gep.i.i, align 8
  %r_meta_gep.i.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i652.i, i64 56
  store i64 34359742465, ptr %r_meta_gep.i.i, align 8
  %cur_i.i.i656.i = ptrtoint ptr %cur.i.i654.i to i64
  %rem.i.i658.i = sub i64 %end_i.i.i657.pre-phi.i, %cur_i.i.i656.i
  %fits.not.i.i659.i = icmp slt i64 %rem.i.i658.i, 64
  br i1 %fits.not.i.i659.i, label %fallback.i.i667.i, label %fast.i.i660.i

fast.i.i660.i:                                    ; preds = %archx_dict_new.exit.i
  %next.i.i661.i = getelementptr inbounds nuw i8, ptr %cur.i.i654.i, i64 64
  store ptr %next.i.i661.i, ptr %func.region.i, align 8
  br label %for.fast.cond.45.preheader.i

fallback.i.i667.i:                                ; preds = %archx_dict_new.exit.i
  %res.i.i668.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 64)
  %.pre.i669.i = ptrtoint ptr %res.i.i668.i to i64
  br label %for.fast.cond.45.preheader.i

for.fast.cond.45.preheader.i:                     ; preds = %fallback.i.i667.i, %fast.i.i660.i
  %rpi.pre-phi.i662.i = phi i64 [ %cur_i.i.i656.i, %fast.i.i660.i ], [ %.pre.i669.i, %fallback.i.i667.i ]
  %common.ret.op.i.i663.i = phi ptr [ %cur.i.i654.i, %fast.i.i660.i ], [ %res.i.i668.i, %fallback.i.i667.i ]
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(64) %common.ret.op.i.i663.i, i8 0, i64 64, i1 false)
  %r_reg_gep.i664.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i663.i, i64 24
  store ptr %func.region.i, ptr %r_reg_gep.i664.i, align 8
  %r_meta_gep.i665.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i663.i, i64 56
  store i64 2048, ptr %r_meta_gep.i665.i, align 8
  %t155.i = and i64 %rpi.pre-phi.i.i, -4
  %t156.i = inttoptr i64 %t155.i to ptr
  %t157.i = getelementptr inbounds nuw i8, ptr %t156.i, i64 48
  %ctrl_p.i = getelementptr inbounds nuw i8, ptr %t156.i, i64 32
  %is_z.i.i = icmp eq i64 %t155.i, 0
  %mask_p.i.i = getelementptr inbounds nuw i8, ptr %t156.i, i64 16
  %keys_p.i.i = getelementptr inbounds nuw i8, ptr %t156.i, i64 40
  %used_p.i = getelementptr inbounds nuw i8, ptr %t156.i, i64 8
  br label %for.fast.body.46.i

for.fast.body.46.i:                               ; preds = %archx_dict_upsert_str.exit, %for.fast.cond.45.preheader.i
  %for.i.139.0871.i = phi i64 [ 0, %for.fast.cond.45.preheader.i ], [ %t161.i, %archx_dict_upsert_str.exit ]
  %t150.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.3.i, i64 %for.i.139.0871.i
  %t151.unpack.i = load i64, ptr %t150.i, align 8
  %t151.elt62.i = getelementptr inbounds nuw i8, ptr %t150.i, i64 8
  %t151.unpack63.i = load i64, ptr %t151.elt62.i, align 8
  %len.i.i1818 = and i64 %t151.unpack.i, 4294967295
  %short.i.i1819 = icmp samesign ult i64 %len.i.i1818, 13
  br i1 %short.i.i1819, label %sso_hash.i.i, label %long_hash.i.i

sso_hash.i.i:                                     ; preds = %for.fast.body.46.i
  %p0_raw.i.i = lshr i64 %t151.unpack.i, 32
  %le4.i.i = icmp samesign ult i64 %len.i.i1818, 5
  br i1 %le4.i.i, label %sso_le4.i.i, label %sso_gt4.i.i

sso_le4.i.i:                                      ; preds = %sso_hash.i.i
  %sh0.i.i = shl nuw nsw i64 %len.i.i1818, 3
  %notmask1.i.i = shl nsw i64 -1, %sh0.i.i
  %m0.i.i = xor i64 %notmask1.i.i, -1
  %p0_4.i.i = and i64 %p0_raw.i.i, %m0.i.i
  br label %sso_mix.i.i

sso_gt4.i.i:                                      ; preds = %sso_hash.i.i
  %eq12.i.i = icmp eq i64 %len.i.i1818, 12
  br i1 %eq12.i.i, label %sso_mix.i.i, label %sso_mid.i.i

sso_mid.i.i:                                      ; preds = %sso_gt4.i.i
  %rem.i.i = shl nuw nsw i64 %len.i.i1818, 3
  %sh1.i.i = add nsw i64 %rem.i.i, -32
  %notmask.i.i = shl nsw i64 -1, %sh1.i.i
  %m1.i.i = xor i64 %notmask.i.i, -1
  %p1_m.i.i = and i64 %t151.unpack63.i, %m1.i.i
  br label %sso_mix.i.i

sso_mix.i.i:                                      ; preds = %sso_mid.i.i, %sso_gt4.i.i, %sso_le4.i.i
  %p0.i.i = phi i64 [ %p0_4.i.i, %sso_le4.i.i ], [ %p0_raw.i.i, %sso_mid.i.i ], [ %p0_raw.i.i, %sso_gt4.i.i ]
  %p1.i.i = phi i64 [ 0, %sso_le4.i.i ], [ %p1_m.i.i, %sso_mid.i.i ], [ %t151.unpack63.i, %sso_gt4.i.i ]
  %a0.i.i = mul i64 %p0.i.i, -7046029254386353131
  %a1.i.i = mul i64 %p1.i.i, -4417276706812531889
  %ax.i.i = xor i64 %a1.i.i, %a0.i.i
  %s1.i10.i.i = lshr i64 %ax.i.i, 30
  %55 = xor i64 %len.i.i1818, %s1.i10.i.i
  %x1.i11.i.i = xor i64 %55, %ax.i.i
  br label %archx_hash_str.exit.i

long_hash.i.i:                                    ; preds = %for.fast.body.46.i
  %raw.i.i = and i64 %t151.unpack63.i, -4
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  %seed.i.i = mul i64 %len.i.i1818, -7046029254386353131
  %56 = add nsw i64 %len.i.i1818, -8
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
  %lp.i.i1821.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %idx.i15.i.unr
  %lane.i.i.epil = load i64, ptr %lp.i.i1821.epil, align 4
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
  %tmore.i17.i = icmp samesign ult i64 %idx_next.i.i.lcssa, %len.i.i1818
  br i1 %tmore.i17.i, label %l_tail_body.i.i.preheader, label %l_done.i.i

l_tail_body.i.i.preheader:                        ; preds = %l_tail_cond.i.preheader.i
  %61 = sub i64 %t151.unpack.i, %idx_next.i.i.lcssa
  %xtraiter2114 = and i64 %61, 3
  %lcmp.mod2115.not = icmp eq i64 %xtraiter2114, 0
  br i1 %lcmp.mod2115.not, label %l_tail_body.i.i.prol.loopexit, label %l_tail_body.i.i.prol

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
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter2114
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.i.prol.loopexit, label %l_tail_body.i.i.prol, !llvm.loop !7

l_tail_body.i.i.prol.loopexit:                    ; preds = %l_tail_body.i.i.prol, %l_tail_body.i.i.preheader
  %tacc.i19.i.unr = phi i64 [ %acc_next.i.i.lcssa, %l_tail_body.i.i.preheader ], [ %tacc_next.i.i.prol, %l_tail_body.i.i.prol ]
  %ti.i18.i.unr = phi i64 [ %idx_next.i.i.lcssa, %l_tail_body.i.i.preheader ], [ %ti_next.i.i.prol, %l_tail_body.i.i.prol ]
  %tacc_next.i.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.preheader ], [ %tacc_next.i.i.prol, %l_tail_body.i.i.prol ]
  %62 = sub i64 %idx_next.i.i.lcssa, %len.i.i1818
  %63 = icmp ugt i64 %62, -4
  br i1 %63, label %l_done.i.i, label %l_tail_body.i.i.preheader.new

l_tail_body.i.i.preheader.new:                    ; preds = %l_tail_body.i.i.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr.i.i, i64 1
  %invariant.gep2145 = getelementptr i8, ptr %ptr.i.i, i64 2
  %invariant.gep2147 = getelementptr i8, ptr %ptr.i.i, i64 3
  br label %l_tail_body.i.i

l_body.i.i:                                       ; preds = %l_body.i.i, %long_hash.i.i.new
  %acc.i16.i = phi i64 [ %seed.i.i, %long_hash.i.i.new ], [ %acc_next.i.i.1, %l_body.i.i ]
  %idx.i15.i = phi i64 [ 0, %long_hash.i.i.new ], [ %idx_next.i.i.1, %l_body.i.i ]
  %niter = phi i64 [ 0, %long_hash.i.i.new ], [ %niter.next.1, %l_body.i.i ]
  %lp.i.i1821 = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %idx.i15.i
  %lane.i.i = load i64, ptr %lp.i.i1821, align 4
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
  %lp.i.i1821.1 = getelementptr inbounds nuw i8, ptr %ptr.i.i, i64 %idx_next.i.i
  %lane.i.i.1 = load i64, ptr %lp.i.i1821.1, align 4
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
  %gep2146 = getelementptr i8, ptr %invariant.gep2145, i64 %ti.i18.i
  %tb.i.i.2 = load i8, ptr %gep2146, align 1
  %tz.i.i.2 = zext i8 %tb.i.i.2 to i64
  %tx.i.i.2 = xor i64 %tacc_next.i.i.1, %tz.i.i.2
  %tacc_next.i.i.2 = mul i64 %tx.i.i.2, 1099511628211
  %gep2148 = getelementptr i8, ptr %invariant.gep2147, i64 %ti.i18.i
  %tb.i.i.3 = load i8, ptr %gep2148, align 1
  %tz.i.i.3 = zext i8 %tb.i.i.3 to i64
  %tx.i.i.3 = xor i64 %tacc_next.i.i.2, %tz.i.i.3
  %tacc_next.i.i.3 = mul i64 %tx.i.i.3, 1099511628211
  %ti_next.i.i.3 = add nuw nsw i64 %ti.i18.i, 4
  %tmore.i.i.3 = icmp samesign ult i64 %ti_next.i.i.3, %len.i.i1818
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
  %mask.i.i1823 = load i64, ptr %mask_p.i.i, align 8
  %keys.i.i1824 = load ptr, ptr %keys_p.i.i, align 8
  %64 = getelementptr i8, ptr %ctrl0.i, i64 %mask.i.i1823
  %idx_base.i.i = getelementptr i8, ptr %64, i64 17
  %h2_64.i.i = lshr i64 %m2.i15.i.i, 57
  %h2.i.i = trunc nuw nsw i64 %h2_64.i.i to i8
  %h2_ins.i.i = insertelement <16 x i8> poison, i8 %h2.i.i, i64 0
  %h2_vec.i.i = shufflevector <16 x i8> %h2_ins.i.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bp_i.i.i.i = and i64 %t151.unpack63.i, -4
  %bp.i.i.i = inttoptr i64 %bp_i.i.i.i to ptr
  %bp4.i.i.i = getelementptr inbounds nuw i8, ptr %bp.i.i.i, i64 4
  %rem.i.i.i1825 = add nsw i64 %len.i.i1818, -4
  br label %probe.i.i

probe.i.i:                                        ; preds = %next_grp.i.i, %do_probe.i.i
  %h.pn.i.i = phi i64 [ %x3.i17.i.i, %do_probe.i.i ], [ %padd.i.i1850, %next_grp.i.i ]
  %step.i.i = phi i64 [ 0, %do_probe.i.i ], [ %step_next.i.i1849, %next_grp.i.i ]
  %avail.i.i = phi i64 [ -1, %do_probe.i.i ], [ %avail_cur.i.i, %next_grp.i.i ]
  %pos.i.i1826 = and i64 %h.pn.i.i, %mask.i.i1823
  %gp.i.i1827 = getelementptr inbounds i8, ptr %ctrl0.i, i64 %pos.i.i1826
  %grp.i.i1828 = load <16 x i8>, ptr %gp.i.i1827, align 1
  %mcmp.i.i = icmp eq <16 x i8> %grp.i.i1828, %h2_vec.i.i
  %mbits.i.i = bitcast <16 x i1> %mcmp.i.i to i16
  %has_m.not.i20.i = icmp eq i16 %mbits.i.i, 0
  br i1 %has_m.not.i20.i, label %chk_empty.i.i, label %chk_key.i.preheader.i

chk_key.i.preheader.i:                            ; preds = %probe.i.i
  %mmask0.i.i = zext i16 %mbits.i.i to i32
  br label %chk_key.i.i

chk_key.i.i:                                      ; preds = %mbit_cont.i.i, %chk_key.i.preheader.i
  %mmask.i21.i = phi i32 [ %mmask_next.i.i, %mbit_cont.i.i ], [ %mmask0.i.i, %chk_key.i.preheader.i ]
  %tz.i6.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i21.i, i1 true)
  %tz64.i.i1829 = zext nneg i32 %tz.i6.i to i64
  %s_add.i.i1830 = add i64 %pos.i.i1826, %tz64.i.i1829
  %slot.i.i1831 = and i64 %s_add.i.i1830, %mask.i.i1823
  %ip.i.i1832 = getelementptr inbounds i32, ptr %idx_base.i.i, i64 %slot.i.i1831
  %didx32.i.i = load i32, ptr %ip.i.i1832, align 4
  %didx.i.i = zext i32 %didx32.i.i to i64
  %kp.i.i1833 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i1824, i64 %didx.i.i
  %cand_k.unpack.i.i = load i64, ptr %kp.i.i1833, align 8
  %cand_k.elt1.i.i = getelementptr inbounds nuw i8, ptr %kp.i.i1833, i64 8
  %cand_k.unpack2.i.i = load i64, ptr %cand_k.elt1.i.i, align 8
  %w0_eq.i.i.i = icmp eq i64 %cand_k.unpack.i.i, %t151.unpack.i
  br i1 %w0_eq.i.i.i, label %chk_len.i.i.i, label %mbit_cont.i.i

chk_len.i.i.i:                                    ; preds = %chk_key.i.i
  br i1 %short.i.i1819, label %cmp_short.i.i.i, label %cmp_long.i.i.i

cmp_short.i.i.i:                                  ; preds = %chk_len.i.i.i
  %eq_s.i.i.i = icmp eq i64 %cand_k.unpack2.i.i, %t151.unpack63.i
  br i1 %eq_s.i.i.i, label %found.i.i, label %mbit_cont.i.i

cmp_long.i.i.i:                                   ; preds = %chk_len.i.i.i
  %ap_i.i.i.i = and i64 %cand_k.unpack2.i.i, -4
  %same_ptr.i.i.i = icmp eq i64 %ap_i.i.i.i, %bp_i.i.i.i
  br i1 %same_ptr.i.i.i, label %found.i.i, label %archx_str_eq.exit.i.i

archx_str_eq.exit.i.i:                            ; preds = %cmp_long.i.i.i
  %ap.i.i.i = inttoptr i64 %ap_i.i.i.i to ptr
  %ap4.i.i.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i, i64 4
  %bcmp.i.i.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i, ptr nonnull %bp4.i.i.i, i64 %rem.i.i.i1825)
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
  %acmp.i.i = icmp slt <16 x i8> %grp.i.i1828, zeroinitializer
  %abits16.i.i = bitcast <16 x i1> %acmp.i.i to i16
  %has_a0.not.i.i = icmp eq i16 %abits16.i.i, 0
  br i1 %has_a0.not.i.i, label %after_a.i.i, label %set_a.i.i

set_a.i.i:                                        ; preds = %find_a.i.i
  %65 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i, i1 true)
  %atz64.i.i = zext nneg i16 %65 to i64
  %as_add.i.i = add i64 %pos.i.i1826, %atz64.i.i
  %aslot.i.i = and i64 %as_add.i.i, %mask.i.i1823
  br label %after_a.i.i

after_a.i.i:                                      ; preds = %set_a.i.i, %find_a.i.i, %chk_empty.i.i
  %avail_cur.i.i = phi i64 [ %avail.i.i, %chk_empty.i.i ], [ -1, %find_a.i.i ], [ %aslot.i.i, %set_a.i.i ]
  %ecmp.i.i = icmp eq <16 x i8> %grp.i.i1828, splat (i8 -128)
  %ebits.i.i = bitcast <16 x i1> %ecmp.i.i to i16
  %has_e.not.i.i = icmp eq i16 %ebits.i.i, 0
  br i1 %has_e.not.i.i, label %next_grp.i.i, label %not_found_avail.i.i

next_grp.i.i:                                     ; preds = %after_a.i.i
  %step_next.i.i1849 = add i64 %step.i.i, 16
  %padd.i.i1850 = add i64 %step_next.i.i1849, %pos.i.i1826
  br label %probe.i.i

found.i.i:                                        ; preds = %archx_str_eq.exit.i.i, %cmp_long.i.i.i, %cmp_short.i.i.i
  %f0.i.i = insertvalue { i64, i64 } poison, i64 %didx.i.i, 0
  %f1.i.i = insertvalue { i64, i64 } %f0.i.i, i64 %slot.i.i1831, 1
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
  call fastcc void @archx_dict_grow(ptr nonnull %t156.i)
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
  %d_idx.i = load i64, ptr %t156.i, align 8
  %d_new.i = add i64 %d_idx.i, 1
  store i64 %d_new.i, ptr %t156.i, align 8
  %ip.i = getelementptr inbounds i32, ptr %idx_base_c.i, i64 %slot.i
  %d_idx32.i = trunc i64 %d_idx.i to i32
  store i32 %d_idx32.i, ptr %ip.i, align 4
  %tag.i.i1834 = and i64 %t151.unpack63.i, 3
  %owned.not.i.i1835 = icmp eq i64 %tag.i.i1834, 0
  %or.cond.i1836 = select i1 %short.i.i1819, i1 true, i1 %owned.not.i.i1835
  br i1 %or.cond.i1836, label %archx_str_clone.exit.i1846, label %dup_heap.i.i1837

dup_heap.i.i1837:                                 ; preds = %archx_dict_set_ctrl.exit.i
  %dst.i.i1838 = call noalias align 16 ptr @malloc(i64 %len.i.i1818)
  %isnull.i.i1839 = icmp eq ptr %dst.i.i1838, null
  br i1 %isnull.i.i1839, label %oom.i.i1848, label %copy.i.i1840

oom.i.i1848:                                      ; preds = %dup_heap.i.i1837
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i1840:                                     ; preds = %dup_heap.i.i1837
  %src_i.i.i1841 = and i64 %t151.unpack63.i, -4
  %src.i.i1842 = inttoptr i64 %src_i.i.i1841 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i1838, ptr nonnull align 4 %src.i.i1842, i64 %len.i.i1818, i1 false)
  %dst_i.i.i1843 = ptrtoint ptr %dst.i.i1838 to i64
  %tagged.i.i1844 = or disjoint i64 %dst_i.i.i1843, 1
  br label %archx_str_clone.exit.i1846

archx_str_clone.exit.i1846:                       ; preds = %copy.i.i1840, %archx_dict_set_ctrl.exit.i
  %stored_k.elt2.pre-phi.i = phi i64 [ %t151.unpack63.i, %archx_dict_set_ctrl.exit.i ], [ %tagged.i.i1844, %copy.i.i1840 ]
  %kp.i = getelementptr inbounds %ArchxStr, ptr %keys_c.i, i64 %d_idx.i
  store i64 %t151.unpack.i, ptr %kp.i, align 8
  %kp.repack1.i = getelementptr inbounds nuw i8, ptr %kp.i, i64 8
  store i64 %stored_k.elt2.pre-phi.i, ptr %kp.repack1.i, align 8
  br label %archx_dict_upsert_str.exit

archx_dict_upsert_str.exit:                       ; preds = %archx_dict_find_h_str.exit.i, %archx_str_clone.exit.i1846
  %found_idx.pn.i = phi i64 [ %d_idx.i, %archx_str_clone.exit.i1846 ], [ %found_idx.i, %archx_dict_find_h_str.exit.i ]
  %t158.i = load ptr, ptr %t157.i, align 8
  %t159.i = getelementptr inbounds i64, ptr %t158.i, i64 %found_idx.pn.i
  store i64 1, ptr %t159.i, align 8
  %t161.i = add nuw nsw i64 %for.i.139.0871.i, 1
  %exitcond940.not.i = icmp eq i64 %t161.i, 512
  br i1 %exitcond940.not.i, label %for.end.51.i, label %for.fast.body.46.i

for.end.51.i:                                     ; preds = %archx_dict_upsert_str.exit
  %t191.i = mul nuw nsw i64 %for.r.131.0902.i, 19
  %raw.i681.i = and i64 %rpi.pre-phi.i662.i, -4
  %hdr.i.i = inttoptr i64 %raw.i681.i to ptr
  %ctrl_p.i.i = getelementptr inbounds nuw i8, ptr %hdr.i.i, i64 32
  %is_z.i.i.i = icmp eq i64 %raw.i681.i, 0
  %mask_p.i.i.i = getelementptr inbounds nuw i8, ptr %hdr.i.i, i64 16
  %keys_p.i.i.i = getelementptr inbounds nuw i8, ptr %hdr.i.i, i64 40
  %used_p.i.i = getelementptr inbounds nuw i8, ptr %hdr.i.i, i64 8
  br label %idx.ok.66.i

for.cond.79.preheader.i:                          ; preds = %archx_str_drop.exit123.i
  %t265.i = mul nuw nsw i64 %for.r.131.0902.i, 7
  br label %idx.ok.91.i

idx.ok.66.i:                                      ; preds = %archx_str_drop.exit123.i, %for.end.51.i
  %for.step.182.0879.i = phi i64 [ 0, %for.end.51.i ], [ %t254.i, %archx_str_drop.exit123.i ]
  %t187.i = mul nuw nsw i64 %for.step.182.0879.i, 73
  %t194.i = add nuw nsw i64 %t187.i, %t191.i
  %t202.i = and i64 %t194.i, 511
  %t214.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.3.i, i64 %t202.i
  %t215.unpack.i = load i64, ptr %t214.i, align 8
  %70 = insertvalue %ArchxStr poison, i64 %t215.unpack.i, 0
  %t215.elt59.i = getelementptr inbounds nuw i8, ptr %t214.i, i64 8
  %t215.unpack60.i = load i64, ptr %t215.elt59.i, align 8
  %t21561.i = insertvalue %ArchxStr %70, i64 %t215.unpack60.i, 1
  %len.i672.i = and i64 %t215.unpack.i, 4294967295
  %long.i673.i = icmp samesign ult i64 %len.i672.i, 13
  %tag.i677.i = and i64 %t215.unpack60.i, 3
  %owned.not.i678.i = icmp eq i64 %tag.i677.i, 0
  %or.cond784.i = select i1 %long.i673.i, i1 true, i1 %owned.not.i678.i
  br i1 %or.cond784.i, label %archx_str_clone.exit.i, label %dup_heap.i.i

dup_heap.i.i:                                     ; preds = %idx.ok.66.i
  %dst.i679.i = call noalias align 16 ptr @malloc(i64 %len.i672.i)
  %isnull.i.i = icmp eq ptr %dst.i679.i, null
  br i1 %isnull.i.i, label %oom.i680.i, label %copy.i.i

oom.i680.i:                                       ; preds = %dup_heap.i.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i:                                         ; preds = %dup_heap.i.i
  %src_i.i.i = and i64 %t215.unpack60.i, -4
  %src.i.i = inttoptr i64 %src_i.i.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i679.i, ptr nonnull align 4 %src.i.i, i64 %len.i672.i, i1 false)
  %dst_i.i.i = ptrtoint ptr %dst.i679.i to i64
  %tagged.i.i = or disjoint i64 %dst_i.i.i, 1
  %out.i.i = insertvalue %ArchxStr %t21561.i, i64 %tagged.i.i, 1
  br label %archx_str_clone.exit.i

archx_str_clone.exit.i:                           ; preds = %copy.i.i, %idx.ok.66.i
  %common.ret.op.i674.i = phi %ArchxStr [ %out.i.i, %copy.i.i ], [ %t21561.i, %idx.ok.66.i ]
  %w0.i.i.i.i = extractvalue %ArchxStr %common.ret.op.i674.i, 0
  %w1.i.i.i.i = extractvalue %ArchxStr %common.ret.op.i674.i, 1
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
  %unroll_iter2120 = and i64 %75, 4611686018427387902
  br label %l_body.i.i.i.i

l_tail_cond.i.i.i.preheader.i.unr-lcssa:          ; preds = %l_body.i.i.i.i, %long_hash.i.i.i.i
  %acc_next.i.i.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i.i ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx_next.i.i.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i.i ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %acc.i.i.i873.i.unr = phi i64 [ %seed.i.i.i.i, %long_hash.i.i.i.i ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx.i.i.i872.i.unr = phi i64 [ 0, %long_hash.i.i.i.i ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %76 = and i64 %72, 8
  %lcmp.mod2117.not.not = icmp eq i64 %76, 0
  br i1 %lcmp.mod2117.not.not, label %l_body.i.i.i.i.epil, label %l_tail_cond.i.i.i.preheader.i

l_body.i.i.i.i.epil:                              ; preds = %l_tail_cond.i.i.i.preheader.i.unr-lcssa
  %lp.i.i.i.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %idx.i.i.i872.i.unr
  %lane.i.i.i.i.epil = load i64, ptr %lp.i.i.i.i.epil, align 4
  %lm.i.i.i.i.epil = mul i64 %lane.i.i.i.i.epil, -4417276706812531889
  %lx.i.i.i.i.epil = xor i64 %lm.i.i.i.i.epil, %acc.i.i.i873.i.unr
  %s1.i2.i.i.i.i.epil = lshr i64 %lx.i.i.i.i.epil, 30
  %x1.i3.i.i.i.i.epil = xor i64 %s1.i2.i.i.i.i.epil, %lx.i.i.i.i.epil
  %m1.i4.i.i.i.i.epil = mul i64 %x1.i3.i.i.i.i.epil, -4658895280553007687
  %s2.i5.i.i.i.i.epil = lshr i64 %m1.i4.i.i.i.i.epil, 27
  %x2.i6.i.i.i.i.epil = xor i64 %s2.i5.i.i.i.i.epil, %m1.i4.i.i.i.i.epil
  %m2.i7.i.i.i.i.epil = mul i64 %x2.i6.i.i.i.i.epil, -7723592293110705685
  %s3.i8.i.i.i.i.epil = lshr i64 %m2.i7.i.i.i.i.epil, 31
  %x3.i9.i.i.i.i.epil = xor i64 %s3.i8.i.i.i.i.epil, %m2.i7.i.i.i.i.epil
  %acc_next.i.i.i.i.epil = add i64 %x3.i9.i.i.i.i.epil, %idx.i.i.i872.i.unr
  %idx_next.i.i.i.i.epil = add nuw nsw i64 %idx.i.i.i872.i.unr, 8
  br label %l_tail_cond.i.i.i.preheader.i

l_tail_cond.i.i.i.preheader.i:                    ; preds = %l_tail_cond.i.i.i.preheader.i.unr-lcssa, %l_body.i.i.i.i.epil
  %acc_next.i.i.i.i.lcssa = phi i64 [ %acc_next.i.i.i.i.lcssa.ph, %l_tail_cond.i.i.i.preheader.i.unr-lcssa ], [ %acc_next.i.i.i.i.epil, %l_body.i.i.i.i.epil ]
  %idx_next.i.i.i.i.lcssa = phi i64 [ %idx_next.i.i.i.i.lcssa.ph, %l_tail_cond.i.i.i.preheader.i.unr-lcssa ], [ %idx_next.i.i.i.i.epil, %l_body.i.i.i.i.epil ]
  %tmore.i.i.i874.i = icmp samesign ult i64 %idx_next.i.i.i.i.lcssa, %len.i.i.i.i
  br i1 %tmore.i.i.i874.i, label %l_tail_body.i.i.i.i.preheader, label %l_done.i.i.i.i

l_tail_body.i.i.i.i.preheader:                    ; preds = %l_tail_cond.i.i.i.preheader.i
  %77 = sub i64 %w0.i.i.i.i, %idx_next.i.i.i.i.lcssa
  %xtraiter2122 = and i64 %77, 3
  %lcmp.mod2123.not = icmp eq i64 %xtraiter2122, 0
  br i1 %lcmp.mod2123.not, label %l_tail_body.i.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.i.prol

l_tail_body.i.i.i.i.prol:                         ; preds = %l_tail_body.i.i.i.i.preheader, %l_tail_body.i.i.i.i.prol
  %tacc.i.i.i876.i.prol = phi i64 [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ], [ %acc_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ]
  %ti.i.i.i875.i.prol = phi i64 [ %ti_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ], [ %idx_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ]
  %prol.iter2124 = phi i64 [ %prol.iter2124.next, %l_tail_body.i.i.i.i.prol ], [ 0, %l_tail_body.i.i.i.i.preheader ]
  %tp.i.i.i.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %ti.i.i.i875.i.prol
  %tb.i.i.i.i.prol = load i8, ptr %tp.i.i.i.i.prol, align 1
  %tz.i.i.i.i.prol = zext i8 %tb.i.i.i.i.prol to i64
  %tx.i.i.i.i.prol = xor i64 %tacc.i.i.i876.i.prol, %tz.i.i.i.i.prol
  %tacc_next.i.i.i.i.prol = mul i64 %tx.i.i.i.i.prol, 1099511628211
  %ti_next.i.i.i.i.prol = add nuw nsw i64 %ti.i.i.i875.i.prol, 1
  %prol.iter2124.next = add i64 %prol.iter2124, 1
  %prol.iter2124.cmp.not = icmp eq i64 %prol.iter2124.next, %xtraiter2122
  br i1 %prol.iter2124.cmp.not, label %l_tail_body.i.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.i.prol, !llvm.loop !9

l_tail_body.i.i.i.i.prol.loopexit:                ; preds = %l_tail_body.i.i.i.i.prol, %l_tail_body.i.i.i.i.preheader
  %tacc.i.i.i876.i.unr = phi i64 [ %acc_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ], [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %ti.i.i.i875.i.unr = phi i64 [ %idx_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ], [ %ti_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %tacc_next.i.i.i.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.i.i.preheader ], [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %78 = sub i64 %idx_next.i.i.i.i.lcssa, %len.i.i.i.i
  %79 = icmp ugt i64 %78, -4
  br i1 %79, label %l_done.i.i.i.i, label %l_tail_body.i.i.i.i.preheader.new

l_tail_body.i.i.i.i.preheader.new:                ; preds = %l_tail_body.i.i.i.i.prol.loopexit
  %invariant.gep2149 = getelementptr i8, ptr %ptr.i.i.i.i, i64 1
  %invariant.gep2151 = getelementptr i8, ptr %ptr.i.i.i.i, i64 2
  %invariant.gep2153 = getelementptr i8, ptr %ptr.i.i.i.i, i64 3
  br label %l_tail_body.i.i.i.i

l_body.i.i.i.i:                                   ; preds = %l_body.i.i.i.i, %long_hash.i.i.i.i.new
  %acc.i.i.i873.i = phi i64 [ %seed.i.i.i.i, %long_hash.i.i.i.i.new ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx.i.i.i872.i = phi i64 [ 0, %long_hash.i.i.i.i.new ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %niter2121 = phi i64 [ 0, %long_hash.i.i.i.i.new ], [ %niter2121.next.1, %l_body.i.i.i.i ]
  %lp.i.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %idx.i.i.i872.i
  %lane.i.i.i.i = load i64, ptr %lp.i.i.i.i, align 4
  %lm.i.i.i.i = mul i64 %lane.i.i.i.i, -4417276706812531889
  %lx.i.i.i.i = xor i64 %lm.i.i.i.i, %acc.i.i.i873.i
  %s1.i2.i.i.i.i = lshr i64 %lx.i.i.i.i, 30
  %x1.i3.i.i.i.i = xor i64 %s1.i2.i.i.i.i, %lx.i.i.i.i
  %m1.i4.i.i.i.i = mul i64 %x1.i3.i.i.i.i, -4658895280553007687
  %s2.i5.i.i.i.i = lshr i64 %m1.i4.i.i.i.i, 27
  %x2.i6.i.i.i.i = xor i64 %s2.i5.i.i.i.i, %m1.i4.i.i.i.i
  %m2.i7.i.i.i.i = mul i64 %x2.i6.i.i.i.i, -7723592293110705685
  %s3.i8.i.i.i.i = lshr i64 %m2.i7.i.i.i.i, 31
  %x3.i9.i.i.i.i = xor i64 %s3.i8.i.i.i.i, %m2.i7.i.i.i.i
  %acc_next.i.i.i.i = add i64 %x3.i9.i.i.i.i, %idx.i.i.i872.i
  %idx_next.i.i.i.i = or disjoint i64 %idx.i.i.i872.i, 8
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
  %idx_next.i.i.i.i.1 = add nuw nsw i64 %idx.i.i.i872.i, 16
  %niter2121.next.1 = add i64 %niter2121, 2
  %niter2121.ncmp.1.not = icmp eq i64 %niter2121.next.1, %unroll_iter2120
  br i1 %niter2121.ncmp.1.not, label %l_tail_cond.i.i.i.preheader.i.unr-lcssa, label %l_body.i.i.i.i

l_tail_body.i.i.i.i:                              ; preds = %l_tail_body.i.i.i.i, %l_tail_body.i.i.i.i.preheader.new
  %tacc.i.i.i876.i = phi i64 [ %tacc.i.i.i876.i.unr, %l_tail_body.i.i.i.i.preheader.new ], [ %tacc_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %ti.i.i.i875.i = phi i64 [ %ti.i.i.i875.i.unr, %l_tail_body.i.i.i.i.preheader.new ], [ %ti_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %tp.i.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %ti.i.i.i875.i
  %tb.i.i.i.i = load i8, ptr %tp.i.i.i.i, align 1
  %tz.i.i.i.i = zext i8 %tb.i.i.i.i to i64
  %tx.i.i.i.i = xor i64 %tacc.i.i.i876.i, %tz.i.i.i.i
  %tacc_next.i.i.i.i = mul i64 %tx.i.i.i.i, 1099511628211
  %gep2150 = getelementptr i8, ptr %invariant.gep2149, i64 %ti.i.i.i875.i
  %tb.i.i.i.i.1 = load i8, ptr %gep2150, align 1
  %tz.i.i.i.i.1 = zext i8 %tb.i.i.i.i.1 to i64
  %tx.i.i.i.i.1 = xor i64 %tacc_next.i.i.i.i, %tz.i.i.i.i.1
  %tacc_next.i.i.i.i.1 = mul i64 %tx.i.i.i.i.1, 1099511628211
  %gep2152 = getelementptr i8, ptr %invariant.gep2151, i64 %ti.i.i.i875.i
  %tb.i.i.i.i.2 = load i8, ptr %gep2152, align 1
  %tz.i.i.i.i.2 = zext i8 %tb.i.i.i.i.2 to i64
  %tx.i.i.i.i.2 = xor i64 %tacc_next.i.i.i.i.1, %tz.i.i.i.i.2
  %tacc_next.i.i.i.i.2 = mul i64 %tx.i.i.i.i.2, 1099511628211
  %gep2154 = getelementptr i8, ptr %invariant.gep2153, i64 %ti.i.i.i875.i
  %tb.i.i.i.i.3 = load i8, ptr %gep2154, align 1
  %tz.i.i.i.i.3 = zext i8 %tb.i.i.i.i.3 to i64
  %tx.i.i.i.i.3 = xor i64 %tacc_next.i.i.i.i.2, %tz.i.i.i.i.3
  %tacc_next.i.i.i.i.3 = mul i64 %tx.i.i.i.i.3, 1099511628211
  %ti_next.i.i.i.i.3 = add nuw nsw i64 %ti.i.i.i875.i, 4
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
  br i1 %is_z.i.i, label %dupd.miss.69.i, label %chk_ctrl.i.i.i.i

chk_ctrl.i.i.i.i:                                 ; preds = %archx_hash_str.exit.i.i.i
  %ctrl.i.i.i.i = load ptr, ptr %ctrl_p.i, align 8
  %c_null.i.i.i.i = icmp eq ptr %ctrl.i.i.i.i, null
  br i1 %c_null.i.i.i.i, label %dupd.miss.69.i, label %do_probe.i.i.i.i

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
  %has_m.not.i.i.i877.i = icmp eq i16 %mbits.i.i.i.i, 0
  br i1 %has_m.not.i.i.i877.i, label %chk_empty.i.i.i.i, label %chk_key.i.i.i.preheader.i

chk_key.i.i.i.preheader.i:                        ; preds = %probe.i.i.i.i
  %mmask0.i.i.i.i = zext i16 %mbits.i.i.i.i to i32
  br label %chk_key.i.i.i.i

chk_key.i.i.i.i:                                  ; preds = %mbit_cont.i.i.i.i, %chk_key.i.i.i.preheader.i
  %mmask.i.i.i878.i = phi i32 [ %mmask_next.i.i.i.i, %mbit_cont.i.i.i.i ], [ %mmask0.i.i.i.i, %chk_key.i.i.i.preheader.i ]
  %tz.i2.i.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i878.i, i1 true)
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
  br i1 %eq_s.i.i.i.i.i, label %dupd.ok.68.i, label %mbit_cont.i.i.i.i

cmp_long.i.i.i.i.i:                               ; preds = %chk_len.i.i.i.i.i
  %ap_i.i.i.i.i.i = and i64 %cand_k.unpack2.i.i.i.i, -4
  %same_ptr.i.i.i.i.i = icmp eq i64 %ap_i.i.i.i.i.i, %bp_i.i.i.i.i.i
  br i1 %same_ptr.i.i.i.i.i, label %dupd.ok.68.i, label %archx_str_eq.exit.i.i.i.i

archx_str_eq.exit.i.i.i.i:                        ; preds = %cmp_long.i.i.i.i.i
  %ap.i.i.i.i.i = inttoptr i64 %ap_i.i.i.i.i.i to ptr
  %ap4.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i.i, i64 4
  %bcmp.i.i.i.i.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i.i.i, ptr nonnull %bp4.i.i.i.i.i, i64 %rem.i.i.i.i.i)
  %eq_m.i.i.i.i.i = icmp eq i32 %bcmp.i.i.i.i.i, 0
  br i1 %eq_m.i.i.i.i.i, label %dupd.ok.68.i, label %mbit_cont.i.i.i.i

mbit_cont.i.i.i.i:                                ; preds = %archx_str_eq.exit.i.i.i.i, %cmp_short.i.i.i.i.i, %chk_key.i.i.i.i
  %mm1.i.i.i.i = add nsw i32 %mmask.i.i.i878.i, -1
  %mmask_next.i.i.i.i = and i32 %mm1.i.i.i.i, %mmask.i.i.i878.i
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
  br i1 %has_e.not.i.i.i.i, label %next_grp.i.i.i.i, label %dupd.miss.69.i

next_grp.i.i.i.i:                                 ; preds = %after_a.i.i.i.i
  %step_next.i.i.i.i = add i64 %step.i.i.i.i, 16
  %padd.i.i.i.i = add i64 %step_next.i.i.i.i, %pos.i.i.i.i
  br label %probe.i.i.i.i

dupd.miss.69.i:                                   ; preds = %chk_ctrl.i.i.i.i, %archx_hash_str.exit.i.i.i, %after_a.i.i.i.i
  call fastcc void @archx_key_fail()
  unreachable

dupd.ok.68.i:                                     ; preds = %archx_str_eq.exit.i.i.i.i, %cmp_long.i.i.i.i.i, %cmp_short.i.i.i.i.i
  %t225.i = load ptr, ptr %t157.i, align 8
  %t226.i = getelementptr inbounds nuw i64, ptr %t225.i, i64 %didx.i.i.i.i
  %t227.i = load i64, ptr %t226.i, align 8
  %t234.i = urem i64 %for.step.182.0879.i, 5
  %t242.i = add nuw nsw i64 %t234.i, 1
  %t245.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t227.i, i64 %t242.i)
  %t247.i = extractvalue { i64, i1 } %t245.i, 1
  br i1 %t247.i, label %overflow.add.74.i, label %overflow.ok.75.i

overflow.add.74.i:                                ; preds = %dupd.ok.68.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.75.i:                                 ; preds = %dupd.ok.68.i
  %t246.i = extractvalue { i64, i1 } %t245.i, 0
  store i64 %t246.i, ptr %t226.i, align 8
  %t249.i = icmp samesign ult i64 %for.step.182.0879.i, 64
  br i1 %t249.i, label %if.then.76.i, label %if.merge.78.i

if.then.76.i:                                     ; preds = %overflow.ok.75.i
  %m1.i.i.i = mul i64 %t202.i, -4658895280553007687
  %s2.i.i.i = lshr i64 %m1.i.i.i, 27
  %x2.i.i.i = xor i64 %s2.i.i.i, %m1.i.i.i
  %m2.i.i.i = mul i64 %x2.i.i.i, -7723592293110705685
  %s3.i.i.i = lshr i64 %m2.i.i.i, 31
  %x3.i.i.i = xor i64 %s3.i.i.i, %m2.i.i.i
  %ctrl0.i.i = load ptr, ptr %ctrl_p.i.i, align 8
  %uninit.i.i = icmp eq ptr %ctrl0.i.i, null
  br i1 %uninit.i.i, label %probe_insert_init.i.i, label %chk_probe_existing.i.i

chk_probe_existing.i.i:                           ; preds = %if.then.76.i
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
  %eq.i.i.i = icmp eq i64 %cand_k.i.i.i, %t202.i
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
  %common.ret.op.i.i682.i = phi { i64, i64 } [ %f1.i.i.i, %found.i.i.i ], [ %nf1.i.i.i, %not_found_avail.i.i.i ], [ { i64 -1, i64 -1 }, %chk_probe_existing.i.i ]
  %found_idx.i.i = extractvalue { i64, i64 } %common.ret.op.i.i682.i, 0
  %avail_slot.i.i = extractvalue { i64, i64 } %common.ret.op.i.i682.i, 1
  %exists.i.i = icmp sgt i64 %found_idx.i.i, -1
  br i1 %exists.i.i, label %if.merge.78.i, label %chk_cap.i.i

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

probe_insert_init.i.i:                            ; preds = %chk_cap.i.i, %if.then.76.i
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
  br i1 %has_a.not10.i.i, label %inext.i684.i, label %iput.i.i

inext.i684.i:                                     ; preds = %probe_insert_init.i.i, %inext.i684.i
  %pos12.i.i = phi i64 [ %pos.i.i, %inext.i684.i ], [ %pos5.i.i, %probe_insert_init.i.i ]
  %step11.i.i = phi i64 [ %step_next.i.i, %inext.i684.i ], [ 0, %probe_insert_init.i.i ]
  %step_next.i.i = add i64 %step11.i.i, 16
  %padd.i.i = add i64 %step_next.i.i, %pos12.i.i
  %pos.i.i = and i64 %padd.i.i, %mask.i.i
  %gp.i.i = getelementptr inbounds i8, ptr %ctrl.i.i, i64 %pos.i.i
  %grp.i.i = load <16 x i8>, ptr %gp.i.i, align 1
  %avail_cmp.i.i = icmp slt <16 x i8> %grp.i.i, zeroinitializer
  %abits.i.i = bitcast <16 x i1> %avail_cmp.i.i to i16
  %has_a.not.i.i = icmp eq i16 %abits.i.i, 0
  br i1 %has_a.not.i.i, label %inext.i684.i, label %iput.i.i

iput.i.i:                                         ; preds = %inext.i684.i, %probe_insert_init.i.i
  %pos.lcssa.i.i = phi i64 [ %pos5.i.i, %probe_insert_init.i.i ], [ %pos.i.i, %inext.i684.i ]
  %abits.lcssa.i.i = phi i16 [ %abits9.i.i, %probe_insert_init.i.i ], [ %abits.i.i, %inext.i684.i ]
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
  store i64 %t202.i, ptr %kp.i.i, align 8
  br label %if.merge.78.i

if.merge.78.i:                                    ; preds = %archx_dict_set_ctrl.exit.i.i, %archx_dict_find_h_i64.exit.i.i, %overflow.ok.75.i
  %tag.i118.i = and i64 %w1.i.i.i.i, 1
  %owned.not.i119.i = icmp eq i64 %tag.i118.i, 0
  %or.cond785.i = select i1 %short.i.i.i.i, i1 true, i1 %owned.not.i119.i
  br i1 %or.cond785.i, label %archx_str_drop.exit123.i, label %do_free.i120.i

do_free.i120.i:                                   ; preds = %if.merge.78.i
  %raw.i121.i = and i64 %w1.i.i.i.i, -2
  %ptr.i122.i = inttoptr i64 %raw.i121.i to ptr
  call void @free(ptr %ptr.i122.i)
  br label %archx_str_drop.exit123.i

archx_str_drop.exit123.i:                         ; preds = %do_free.i120.i, %if.merge.78.i
  %t254.i = add nuw nsw i64 %for.step.182.0879.i, 1
  %exitcond941.not.i = icmp eq i64 %t254.i, 4096
  br i1 %exitcond941.not.i, label %for.cond.79.preheader.i, label %idx.ok.66.i

idx.ok.91.i:                                      ; preds = %archx_str_drop.exit134.i, %for.cond.79.preheader.i
  %for.p.255.0889.i = phi i64 [ 0, %for.cond.79.preheader.i ], [ %t308.i, %archx_str_drop.exit134.i ]
  %var.checksum.127.1888.i = phi i64 [ %var.checksum.127.0903.i, %for.cond.79.preheader.i ], [ %t304.i, %archx_str_drop.exit134.i ]
  %t261.i = mul nuw nsw i64 %for.p.255.0889.i, 131
  %t268.i = add nuw nsw i64 %t261.i, %t265.i
  %t276.i = and i64 %t268.i, 511
  %t287.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.3.i, i64 %t276.i
  %t288.unpack.i = load i64, ptr %t287.i, align 8
  %88 = insertvalue %ArchxStr poison, i64 %t288.unpack.i, 0
  %t288.elt56.i = getelementptr inbounds nuw i8, ptr %t287.i, i64 8
  %t288.unpack57.i = load i64, ptr %t288.elt56.i, align 8
  %t28858.i = insertvalue %ArchxStr %88, i64 %t288.unpack57.i, 1
  %len.i686.i = and i64 %t288.unpack.i, 4294967295
  %long.i687.i = icmp samesign ult i64 %len.i686.i, 13
  %tag.i691.i = and i64 %t288.unpack57.i, 3
  %owned.not.i692.i = icmp eq i64 %tag.i691.i, 0
  %or.cond786.i = select i1 %long.i687.i, i1 true, i1 %owned.not.i692.i
  br i1 %or.cond786.i, label %archx_str_clone.exit703.i, label %dup_heap.i693.i

dup_heap.i693.i:                                  ; preds = %idx.ok.91.i
  %dst.i694.i = call noalias align 16 ptr @malloc(i64 %len.i686.i)
  %isnull.i695.i = icmp eq ptr %dst.i694.i, null
  br i1 %isnull.i695.i, label %oom.i702.i, label %copy.i696.i

oom.i702.i:                                       ; preds = %dup_heap.i693.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i696.i:                                      ; preds = %dup_heap.i693.i
  %src_i.i697.i = and i64 %t288.unpack57.i, -4
  %src.i698.i = inttoptr i64 %src_i.i697.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i694.i, ptr nonnull align 4 %src.i698.i, i64 %len.i686.i, i1 false)
  %dst_i.i699.i = ptrtoint ptr %dst.i694.i to i64
  %tagged.i700.i = or disjoint i64 %dst_i.i699.i, 1
  %out.i701.i = insertvalue %ArchxStr %t28858.i, i64 %tagged.i700.i, 1
  br label %archx_str_clone.exit703.i

archx_str_clone.exit703.i:                        ; preds = %copy.i696.i, %idx.ok.91.i
  %common.ret.op.i688.i = phi %ArchxStr [ %out.i701.i, %copy.i696.i ], [ %t28858.i, %idx.ok.91.i ]
  %w0.i.i.i233.i = extractvalue %ArchxStr %common.ret.op.i688.i, 0
  %w1.i.i.i234.i = extractvalue %ArchxStr %common.ret.op.i688.i, 1
  %len.i.i.i235.i = and i64 %w0.i.i.i233.i, 4294967295
  %short.i.i.i236.i = icmp samesign ult i64 %len.i.i.i235.i, 13
  br i1 %short.i.i.i236.i, label %sso_hash.i.i.i376.i, label %long_hash.i.i.i237.i

sso_hash.i.i.i376.i:                              ; preds = %archx_str_clone.exit703.i
  %p0_raw.i.i.i377.i = lshr i64 %w0.i.i.i233.i, 32
  %le4.i.i.i378.i = icmp samesign ult i64 %len.i.i.i235.i, 5
  br i1 %le4.i.i.i378.i, label %sso_le4.i.i.i402.i, label %sso_gt4.i.i.i379.i

sso_le4.i.i.i402.i:                               ; preds = %sso_hash.i.i.i376.i
  %sh0.i.i.i403.i = shl nuw nsw i64 %len.i.i.i235.i, 3
  %notmask1.i.i.i404.i = shl nsw i64 -1, %sh0.i.i.i403.i
  %m0.i.i.i405.i = xor i64 %notmask1.i.i.i404.i, -1
  %p0_4.i.i.i406.i = and i64 %p0_raw.i.i.i377.i, %m0.i.i.i405.i
  br label %sso_mix.i.i.i387.i

sso_gt4.i.i.i379.i:                               ; preds = %sso_hash.i.i.i376.i
  %eq12.i.i.i380.i = icmp eq i64 %len.i.i.i235.i, 12
  br i1 %eq12.i.i.i380.i, label %sso_mix.i.i.i387.i, label %sso_mid.i.i.i381.i

sso_mid.i.i.i381.i:                               ; preds = %sso_gt4.i.i.i379.i
  %rem.i.i.i382.i = shl nuw nsw i64 %len.i.i.i235.i, 3
  %sh1.i.i.i383.i = add nsw i64 %rem.i.i.i382.i, -32
  %notmask.i.i.i384.i = shl nsw i64 -1, %sh1.i.i.i383.i
  %m1.i.i.i385.i = xor i64 %notmask.i.i.i384.i, -1
  %p1_m.i.i.i386.i = and i64 %w1.i.i.i234.i, %m1.i.i.i385.i
  br label %sso_mix.i.i.i387.i

sso_mix.i.i.i387.i:                               ; preds = %sso_mid.i.i.i381.i, %sso_gt4.i.i.i379.i, %sso_le4.i.i.i402.i
  %p0.i.i.i388.i = phi i64 [ %p0_4.i.i.i406.i, %sso_le4.i.i.i402.i ], [ %p0_raw.i.i.i377.i, %sso_mid.i.i.i381.i ], [ %p0_raw.i.i.i377.i, %sso_gt4.i.i.i379.i ]
  %p1.i.i.i389.i = phi i64 [ 0, %sso_le4.i.i.i402.i ], [ %p1_m.i.i.i386.i, %sso_mid.i.i.i381.i ], [ %w1.i.i.i234.i, %sso_gt4.i.i.i379.i ]
  %a0.i.i.i390.i = mul i64 %p0.i.i.i388.i, -7046029254386353131
  %a1.i.i.i391.i = mul i64 %p1.i.i.i389.i, -4417276706812531889
  %ax.i.i.i392.i = xor i64 %a1.i.i.i391.i, %a0.i.i.i390.i
  %s1.i10.i.i.i394.i = lshr i64 %ax.i.i.i392.i, 30
  %89 = xor i64 %len.i.i.i235.i, %s1.i10.i.i.i394.i
  %x1.i11.i.i.i395.i = xor i64 %89, %ax.i.i.i392.i
  br label %archx_hash_str.exit.i.i259.i

long_hash.i.i.i237.i:                             ; preds = %archx_str_clone.exit703.i
  %raw.i.i.i238.i = and i64 %w1.i.i.i234.i, -4
  %ptr.i.i.i239.i = inttoptr i64 %raw.i.i.i238.i to ptr
  %seed.i.i.i240.i = mul i64 %len.i.i.i235.i, -7046029254386353131
  %90 = add nsw i64 %len.i.i.i235.i, -8
  %91 = icmp ult i64 %90, 8
  br i1 %91, label %l_tail_cond.i.i.i246.preheader.i.unr-lcssa, label %long_hash.i.i.i237.i.new

long_hash.i.i.i237.i.new:                         ; preds = %long_hash.i.i.i237.i
  %92 = lshr i64 %90, 3
  %93 = add nuw nsw i64 %92, 1
  %unroll_iter2129 = and i64 %93, 4611686018427387902
  br label %l_body.i.i.i361.i

l_tail_cond.i.i.i246.preheader.i.unr-lcssa:       ; preds = %l_body.i.i.i361.i, %long_hash.i.i.i237.i
  %acc_next.i.i.i374.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i237.i ], [ %acc_next.i.i.i374.i.1, %l_body.i.i.i361.i ]
  %idx_next.i.i.i375.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i237.i ], [ %idx_next.i.i.i375.i.1, %l_body.i.i.i361.i ]
  %acc.i.i.i243881.i.unr = phi i64 [ %seed.i.i.i240.i, %long_hash.i.i.i237.i ], [ %acc_next.i.i.i374.i.1, %l_body.i.i.i361.i ]
  %idx.i.i.i242880.i.unr = phi i64 [ 0, %long_hash.i.i.i237.i ], [ %idx_next.i.i.i375.i.1, %l_body.i.i.i361.i ]
  %94 = and i64 %90, 8
  %lcmp.mod2126.not.not = icmp eq i64 %94, 0
  br i1 %lcmp.mod2126.not.not, label %l_body.i.i.i361.i.epil, label %l_tail_cond.i.i.i246.preheader.i

l_body.i.i.i361.i.epil:                           ; preds = %l_tail_cond.i.i.i246.preheader.i.unr-lcssa
  %lp.i.i.i362.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i.i239.i, i64 %idx.i.i.i242880.i.unr
  %lane.i.i.i363.i.epil = load i64, ptr %lp.i.i.i362.i.epil, align 4
  %lm.i.i.i364.i.epil = mul i64 %lane.i.i.i363.i.epil, -4417276706812531889
  %lx.i.i.i365.i.epil = xor i64 %lm.i.i.i364.i.epil, %acc.i.i.i243881.i.unr
  %s1.i2.i.i.i366.i.epil = lshr i64 %lx.i.i.i365.i.epil, 30
  %x1.i3.i.i.i367.i.epil = xor i64 %s1.i2.i.i.i366.i.epil, %lx.i.i.i365.i.epil
  %m1.i4.i.i.i368.i.epil = mul i64 %x1.i3.i.i.i367.i.epil, -4658895280553007687
  %s2.i5.i.i.i369.i.epil = lshr i64 %m1.i4.i.i.i368.i.epil, 27
  %x2.i6.i.i.i370.i.epil = xor i64 %s2.i5.i.i.i369.i.epil, %m1.i4.i.i.i368.i.epil
  %m2.i7.i.i.i371.i.epil = mul i64 %x2.i6.i.i.i370.i.epil, -7723592293110705685
  %s3.i8.i.i.i372.i.epil = lshr i64 %m2.i7.i.i.i371.i.epil, 31
  %x3.i9.i.i.i373.i.epil = xor i64 %s3.i8.i.i.i372.i.epil, %m2.i7.i.i.i371.i.epil
  %acc_next.i.i.i374.i.epil = add i64 %x3.i9.i.i.i373.i.epil, %idx.i.i.i242880.i.unr
  %idx_next.i.i.i375.i.epil = add nuw nsw i64 %idx.i.i.i242880.i.unr, 8
  br label %l_tail_cond.i.i.i246.preheader.i

l_tail_cond.i.i.i246.preheader.i:                 ; preds = %l_tail_cond.i.i.i246.preheader.i.unr-lcssa, %l_body.i.i.i361.i.epil
  %acc_next.i.i.i374.i.lcssa = phi i64 [ %acc_next.i.i.i374.i.lcssa.ph, %l_tail_cond.i.i.i246.preheader.i.unr-lcssa ], [ %acc_next.i.i.i374.i.epil, %l_body.i.i.i361.i.epil ]
  %idx_next.i.i.i375.i.lcssa = phi i64 [ %idx_next.i.i.i375.i.lcssa.ph, %l_tail_cond.i.i.i246.preheader.i.unr-lcssa ], [ %idx_next.i.i.i375.i.epil, %l_body.i.i.i361.i.epil ]
  %tmore.i.i.i249882.i = icmp samesign ult i64 %idx_next.i.i.i375.i.lcssa, %len.i.i.i235.i
  br i1 %tmore.i.i.i249882.i, label %l_tail_body.i.i.i354.i.preheader, label %l_done.i.i.i250.i

l_tail_body.i.i.i354.i.preheader:                 ; preds = %l_tail_cond.i.i.i246.preheader.i
  %95 = sub i64 %w0.i.i.i233.i, %idx_next.i.i.i375.i.lcssa
  %xtraiter2131 = and i64 %95, 3
  %lcmp.mod2132.not = icmp eq i64 %xtraiter2131, 0
  br i1 %lcmp.mod2132.not, label %l_tail_body.i.i.i354.i.prol.loopexit, label %l_tail_body.i.i.i354.i.prol

l_tail_body.i.i.i354.i.prol:                      ; preds = %l_tail_body.i.i.i354.i.preheader, %l_tail_body.i.i.i354.i.prol
  %tacc.i.i.i248884.i.prol = phi i64 [ %tacc_next.i.i.i359.i.prol, %l_tail_body.i.i.i354.i.prol ], [ %acc_next.i.i.i374.i.lcssa, %l_tail_body.i.i.i354.i.preheader ]
  %ti.i.i.i247883.i.prol = phi i64 [ %ti_next.i.i.i360.i.prol, %l_tail_body.i.i.i354.i.prol ], [ %idx_next.i.i.i375.i.lcssa, %l_tail_body.i.i.i354.i.preheader ]
  %prol.iter2133 = phi i64 [ %prol.iter2133.next, %l_tail_body.i.i.i354.i.prol ], [ 0, %l_tail_body.i.i.i354.i.preheader ]
  %tp.i.i.i355.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i.i239.i, i64 %ti.i.i.i247883.i.prol
  %tb.i.i.i356.i.prol = load i8, ptr %tp.i.i.i355.i.prol, align 1
  %tz.i.i.i357.i.prol = zext i8 %tb.i.i.i356.i.prol to i64
  %tx.i.i.i358.i.prol = xor i64 %tacc.i.i.i248884.i.prol, %tz.i.i.i357.i.prol
  %tacc_next.i.i.i359.i.prol = mul i64 %tx.i.i.i358.i.prol, 1099511628211
  %ti_next.i.i.i360.i.prol = add nuw nsw i64 %ti.i.i.i247883.i.prol, 1
  %prol.iter2133.next = add i64 %prol.iter2133, 1
  %prol.iter2133.cmp.not = icmp eq i64 %prol.iter2133.next, %xtraiter2131
  br i1 %prol.iter2133.cmp.not, label %l_tail_body.i.i.i354.i.prol.loopexit, label %l_tail_body.i.i.i354.i.prol, !llvm.loop !10

l_tail_body.i.i.i354.i.prol.loopexit:             ; preds = %l_tail_body.i.i.i354.i.prol, %l_tail_body.i.i.i354.i.preheader
  %tacc.i.i.i248884.i.unr = phi i64 [ %acc_next.i.i.i374.i.lcssa, %l_tail_body.i.i.i354.i.preheader ], [ %tacc_next.i.i.i359.i.prol, %l_tail_body.i.i.i354.i.prol ]
  %ti.i.i.i247883.i.unr = phi i64 [ %idx_next.i.i.i375.i.lcssa, %l_tail_body.i.i.i354.i.preheader ], [ %ti_next.i.i.i360.i.prol, %l_tail_body.i.i.i354.i.prol ]
  %tacc_next.i.i.i359.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.i354.i.preheader ], [ %tacc_next.i.i.i359.i.prol, %l_tail_body.i.i.i354.i.prol ]
  %96 = sub i64 %idx_next.i.i.i375.i.lcssa, %len.i.i.i235.i
  %97 = icmp ugt i64 %96, -4
  br i1 %97, label %l_done.i.i.i250.i, label %l_tail_body.i.i.i354.i.preheader.new

l_tail_body.i.i.i354.i.preheader.new:             ; preds = %l_tail_body.i.i.i354.i.prol.loopexit
  %invariant.gep2155 = getelementptr i8, ptr %ptr.i.i.i239.i, i64 1
  %invariant.gep2157 = getelementptr i8, ptr %ptr.i.i.i239.i, i64 2
  %invariant.gep2159 = getelementptr i8, ptr %ptr.i.i.i239.i, i64 3
  br label %l_tail_body.i.i.i354.i

l_body.i.i.i361.i:                                ; preds = %l_body.i.i.i361.i, %long_hash.i.i.i237.i.new
  %acc.i.i.i243881.i = phi i64 [ %seed.i.i.i240.i, %long_hash.i.i.i237.i.new ], [ %acc_next.i.i.i374.i.1, %l_body.i.i.i361.i ]
  %idx.i.i.i242880.i = phi i64 [ 0, %long_hash.i.i.i237.i.new ], [ %idx_next.i.i.i375.i.1, %l_body.i.i.i361.i ]
  %niter2130 = phi i64 [ 0, %long_hash.i.i.i237.i.new ], [ %niter2130.next.1, %l_body.i.i.i361.i ]
  %lp.i.i.i362.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i239.i, i64 %idx.i.i.i242880.i
  %lane.i.i.i363.i = load i64, ptr %lp.i.i.i362.i, align 4
  %lm.i.i.i364.i = mul i64 %lane.i.i.i363.i, -4417276706812531889
  %lx.i.i.i365.i = xor i64 %lm.i.i.i364.i, %acc.i.i.i243881.i
  %s1.i2.i.i.i366.i = lshr i64 %lx.i.i.i365.i, 30
  %x1.i3.i.i.i367.i = xor i64 %s1.i2.i.i.i366.i, %lx.i.i.i365.i
  %m1.i4.i.i.i368.i = mul i64 %x1.i3.i.i.i367.i, -4658895280553007687
  %s2.i5.i.i.i369.i = lshr i64 %m1.i4.i.i.i368.i, 27
  %x2.i6.i.i.i370.i = xor i64 %s2.i5.i.i.i369.i, %m1.i4.i.i.i368.i
  %m2.i7.i.i.i371.i = mul i64 %x2.i6.i.i.i370.i, -7723592293110705685
  %s3.i8.i.i.i372.i = lshr i64 %m2.i7.i.i.i371.i, 31
  %x3.i9.i.i.i373.i = xor i64 %s3.i8.i.i.i372.i, %m2.i7.i.i.i371.i
  %acc_next.i.i.i374.i = add i64 %x3.i9.i.i.i373.i, %idx.i.i.i242880.i
  %idx_next.i.i.i375.i = or disjoint i64 %idx.i.i.i242880.i, 8
  %lp.i.i.i362.i.1 = getelementptr inbounds nuw i8, ptr %ptr.i.i.i239.i, i64 %idx_next.i.i.i375.i
  %lane.i.i.i363.i.1 = load i64, ptr %lp.i.i.i362.i.1, align 4
  %lm.i.i.i364.i.1 = mul i64 %lane.i.i.i363.i.1, -4417276706812531889
  %lx.i.i.i365.i.1 = xor i64 %lm.i.i.i364.i.1, %acc_next.i.i.i374.i
  %s1.i2.i.i.i366.i.1 = lshr i64 %lx.i.i.i365.i.1, 30
  %x1.i3.i.i.i367.i.1 = xor i64 %s1.i2.i.i.i366.i.1, %lx.i.i.i365.i.1
  %m1.i4.i.i.i368.i.1 = mul i64 %x1.i3.i.i.i367.i.1, -4658895280553007687
  %s2.i5.i.i.i369.i.1 = lshr i64 %m1.i4.i.i.i368.i.1, 27
  %x2.i6.i.i.i370.i.1 = xor i64 %s2.i5.i.i.i369.i.1, %m1.i4.i.i.i368.i.1
  %m2.i7.i.i.i371.i.1 = mul i64 %x2.i6.i.i.i370.i.1, -7723592293110705685
  %s3.i8.i.i.i372.i.1 = lshr i64 %m2.i7.i.i.i371.i.1, 31
  %x3.i9.i.i.i373.i.1 = xor i64 %s3.i8.i.i.i372.i.1, %m2.i7.i.i.i371.i.1
  %acc_next.i.i.i374.i.1 = add i64 %x3.i9.i.i.i373.i.1, %idx_next.i.i.i375.i
  %idx_next.i.i.i375.i.1 = add nuw nsw i64 %idx.i.i.i242880.i, 16
  %niter2130.next.1 = add i64 %niter2130, 2
  %niter2130.ncmp.1.not = icmp eq i64 %niter2130.next.1, %unroll_iter2129
  br i1 %niter2130.ncmp.1.not, label %l_tail_cond.i.i.i246.preheader.i.unr-lcssa, label %l_body.i.i.i361.i

l_tail_body.i.i.i354.i:                           ; preds = %l_tail_body.i.i.i354.i, %l_tail_body.i.i.i354.i.preheader.new
  %tacc.i.i.i248884.i = phi i64 [ %tacc.i.i.i248884.i.unr, %l_tail_body.i.i.i354.i.preheader.new ], [ %tacc_next.i.i.i359.i.3, %l_tail_body.i.i.i354.i ]
  %ti.i.i.i247883.i = phi i64 [ %ti.i.i.i247883.i.unr, %l_tail_body.i.i.i354.i.preheader.new ], [ %ti_next.i.i.i360.i.3, %l_tail_body.i.i.i354.i ]
  %tp.i.i.i355.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i239.i, i64 %ti.i.i.i247883.i
  %tb.i.i.i356.i = load i8, ptr %tp.i.i.i355.i, align 1
  %tz.i.i.i357.i = zext i8 %tb.i.i.i356.i to i64
  %tx.i.i.i358.i = xor i64 %tacc.i.i.i248884.i, %tz.i.i.i357.i
  %tacc_next.i.i.i359.i = mul i64 %tx.i.i.i358.i, 1099511628211
  %gep2156 = getelementptr i8, ptr %invariant.gep2155, i64 %ti.i.i.i247883.i
  %tb.i.i.i356.i.1 = load i8, ptr %gep2156, align 1
  %tz.i.i.i357.i.1 = zext i8 %tb.i.i.i356.i.1 to i64
  %tx.i.i.i358.i.1 = xor i64 %tacc_next.i.i.i359.i, %tz.i.i.i357.i.1
  %tacc_next.i.i.i359.i.1 = mul i64 %tx.i.i.i358.i.1, 1099511628211
  %gep2158 = getelementptr i8, ptr %invariant.gep2157, i64 %ti.i.i.i247883.i
  %tb.i.i.i356.i.2 = load i8, ptr %gep2158, align 1
  %tz.i.i.i357.i.2 = zext i8 %tb.i.i.i356.i.2 to i64
  %tx.i.i.i358.i.2 = xor i64 %tacc_next.i.i.i359.i.1, %tz.i.i.i357.i.2
  %tacc_next.i.i.i359.i.2 = mul i64 %tx.i.i.i358.i.2, 1099511628211
  %gep2160 = getelementptr i8, ptr %invariant.gep2159, i64 %ti.i.i.i247883.i
  %tb.i.i.i356.i.3 = load i8, ptr %gep2160, align 1
  %tz.i.i.i357.i.3 = zext i8 %tb.i.i.i356.i.3 to i64
  %tx.i.i.i358.i.3 = xor i64 %tacc_next.i.i.i359.i.2, %tz.i.i.i357.i.3
  %tacc_next.i.i.i359.i.3 = mul i64 %tx.i.i.i358.i.3, 1099511628211
  %ti_next.i.i.i360.i.3 = add nuw nsw i64 %ti.i.i.i247883.i, 4
  %tmore.i.i.i249.i.3 = icmp samesign ult i64 %ti_next.i.i.i360.i.3, %len.i.i.i235.i
  br i1 %tmore.i.i.i249.i.3, label %l_tail_body.i.i.i354.i, label %l_done.i.i.i250.i

l_done.i.i.i250.i:                                ; preds = %l_tail_body.i.i.i354.i.prol.loopexit, %l_tail_body.i.i.i354.i, %l_tail_cond.i.i.i246.preheader.i
  %tacc.i.i.i248.lcssa.i = phi i64 [ %acc_next.i.i.i374.i.lcssa, %l_tail_cond.i.i.i246.preheader.i ], [ %tacc_next.i.i.i359.i.lcssa.unr, %l_tail_body.i.i.i354.i.prol.loopexit ], [ %tacc_next.i.i.i359.i.3, %l_tail_body.i.i.i354.i ]
  %s1.i.i.i.i251.i = lshr i64 %tacc.i.i.i248.lcssa.i, 30
  %x1.i.i.i.i252.i = xor i64 %s1.i.i.i.i251.i, %tacc.i.i.i248.lcssa.i
  br label %archx_hash_str.exit.i.i259.i

archx_hash_str.exit.i.i259.i:                     ; preds = %l_done.i.i.i250.i, %sso_mix.i.i.i387.i
  %x1.i.i.i.i252.sink.i = phi i64 [ %x1.i.i.i.i252.i, %l_done.i.i.i250.i ], [ %x1.i11.i.i.i395.i, %sso_mix.i.i.i387.i ]
  %ctrl.i.i.i266.i = load ptr, ptr %ctrl_p.i, align 8
  %c_null.i.i.i267.i = icmp eq ptr %ctrl.i.i.i266.i, null
  br i1 %c_null.i.i.i267.i, label %dget2.merge.97.i, label %do_probe.i.i.i268.i

do_probe.i.i.i268.i:                              ; preds = %archx_hash_str.exit.i.i259.i
  %m1.i.i.i.i253.i = mul i64 %x1.i.i.i.i252.sink.i, -4658895280553007687
  %s2.i.i.i.i254.i = lshr i64 %m1.i.i.i.i253.i, 27
  %x2.i.i.i.i255.i = xor i64 %s2.i.i.i.i254.i, %m1.i.i.i.i253.i
  %m2.i.i.i.i256.i = mul i64 %x2.i.i.i.i255.i, -7723592293110705685
  %s3.i.i.i.i257.i = lshr i64 %m2.i.i.i.i256.i, 31
  %x3.i.i.i.i258.i = xor i64 %s3.i.i.i.i257.i, %m2.i.i.i.i256.i
  %mask.i.i.i271.i = load i64, ptr %mask_p.i.i, align 8
  %keys.i.i.i272.i = load ptr, ptr %keys_p.i.i, align 8
  %98 = getelementptr i8, ptr %ctrl.i.i.i266.i, i64 %mask.i.i.i271.i
  %idx_base.i.i.i273.i = getelementptr i8, ptr %98, i64 17
  %h2_64.i.i.i274.i = lshr i64 %m2.i.i.i.i256.i, 57
  %h2.i.i.i275.i = trunc nuw nsw i64 %h2_64.i.i.i274.i to i8
  %h2_ins.i.i.i276.i = insertelement <16 x i8> poison, i8 %h2.i.i.i275.i, i64 0
  %h2_vec.i.i.i277.i = shufflevector <16 x i8> %h2_ins.i.i.i276.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bp_i.i.i.i.i322.i = and i64 %w1.i.i.i234.i, -4
  %bp.i.i.i.i326.i = inttoptr i64 %bp_i.i.i.i.i322.i to ptr
  %bp4.i.i.i.i328.i = getelementptr inbounds nuw i8, ptr %bp.i.i.i.i326.i, i64 4
  %rem.i.i.i.i329.i = add nsw i64 %len.i.i.i235.i, -4
  br label %probe.i.i.i278.i

probe.i.i.i278.i:                                 ; preds = %next_grp.i.i.i343.i, %do_probe.i.i.i268.i
  %h.pn.i.i.i279.i = phi i64 [ %x3.i.i.i.i258.i, %do_probe.i.i.i268.i ], [ %padd.i.i.i345.i, %next_grp.i.i.i343.i ]
  %step.i.i.i280.i = phi i64 [ 0, %do_probe.i.i.i268.i ], [ %step_next.i.i.i344.i, %next_grp.i.i.i343.i ]
  %avail.i.i.i281.i = phi i64 [ -1, %do_probe.i.i.i268.i ], [ %avail_cur.i.i.i337.i, %next_grp.i.i.i343.i ]
  %pos.i.i.i282.i = and i64 %h.pn.i.i.i279.i, %mask.i.i.i271.i
  %gp.i.i.i283.i = getelementptr inbounds i8, ptr %ctrl.i.i.i266.i, i64 %pos.i.i.i282.i
  %grp.i.i.i284.i = load <16 x i8>, ptr %gp.i.i.i283.i, align 1
  %mcmp.i.i.i285.i = icmp eq <16 x i8> %grp.i.i.i284.i, %h2_vec.i.i.i277.i
  %mbits.i.i.i286.i = bitcast <16 x i1> %mcmp.i.i.i285.i to i16
  %has_m.not.i.i.i290886.i = icmp eq i16 %mbits.i.i.i286.i, 0
  br i1 %has_m.not.i.i.i290886.i, label %chk_empty.i.i.i334.i, label %chk_key.i.i.i291.preheader.i

chk_key.i.i.i291.preheader.i:                     ; preds = %probe.i.i.i278.i
  %mmask0.i.i.i287.i = zext i16 %mbits.i.i.i286.i to i32
  br label %chk_key.i.i.i291.i

chk_key.i.i.i291.i:                               ; preds = %mbit_cont.i.i.i308.i, %chk_key.i.i.i291.preheader.i
  %mmask.i.i.i289887.i = phi i32 [ %mmask_next.i.i.i310.i, %mbit_cont.i.i.i308.i ], [ %mmask0.i.i.i287.i, %chk_key.i.i.i291.preheader.i ]
  %tz.i2.i.i292.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i289887.i, i1 true)
  %tz64.i.i.i293.i = zext nneg i32 %tz.i2.i.i292.i to i64
  %s_add.i.i.i294.i = add i64 %pos.i.i.i282.i, %tz64.i.i.i293.i
  %slot.i.i.i295.i = and i64 %s_add.i.i.i294.i, %mask.i.i.i271.i
  %ip.i.i.i296.i = getelementptr inbounds i32, ptr %idx_base.i.i.i273.i, i64 %slot.i.i.i295.i
  %didx32.i.i.i297.i = load i32, ptr %ip.i.i.i296.i, align 4
  %didx.i.i.i298.i = zext i32 %didx32.i.i.i297.i to i64
  %kp.i.i.i299.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i272.i, i64 %didx.i.i.i298.i
  %cand_k.unpack.i.i.i300.i = load i64, ptr %kp.i.i.i299.i, align 8
  %cand_k.elt1.i.i.i301.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i299.i, i64 8
  %cand_k.unpack2.i.i.i302.i = load i64, ptr %cand_k.elt1.i.i.i301.i, align 8
  %w0_eq.i.i.i.i305.i = icmp eq i64 %cand_k.unpack.i.i.i300.i, %w0.i.i.i233.i
  br i1 %w0_eq.i.i.i.i305.i, label %chk_len.i.i.i.i316.i, label %mbit_cont.i.i.i308.i

chk_len.i.i.i.i316.i:                             ; preds = %chk_key.i.i.i291.i
  br i1 %short.i.i.i236.i, label %cmp_short.i.i.i.i332.i, label %cmp_long.i.i.i.i320.i

cmp_short.i.i.i.i332.i:                           ; preds = %chk_len.i.i.i.i316.i
  %eq_s.i.i.i.i333.i = icmp eq i64 %cand_k.unpack2.i.i.i302.i, %w1.i.i.i234.i
  br i1 %eq_s.i.i.i.i333.i, label %dget2.hit.93.i, label %mbit_cont.i.i.i308.i

cmp_long.i.i.i.i320.i:                            ; preds = %chk_len.i.i.i.i316.i
  %ap_i.i.i.i.i321.i = and i64 %cand_k.unpack2.i.i.i302.i, -4
  %same_ptr.i.i.i.i323.i = icmp eq i64 %ap_i.i.i.i.i321.i, %bp_i.i.i.i.i322.i
  br i1 %same_ptr.i.i.i.i323.i, label %dget2.hit.93.i, label %archx_str_eq.exit.i.i.i306.i

archx_str_eq.exit.i.i.i306.i:                     ; preds = %cmp_long.i.i.i.i320.i
  %ap.i.i.i.i325.i = inttoptr i64 %ap_i.i.i.i.i321.i to ptr
  %ap4.i.i.i.i327.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i325.i, i64 4
  %bcmp.i.i.i.i330.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i.i327.i, ptr nonnull %bp4.i.i.i.i328.i, i64 %rem.i.i.i.i329.i)
  %eq_m.i.i.i.i331.i = icmp eq i32 %bcmp.i.i.i.i330.i, 0
  br i1 %eq_m.i.i.i.i331.i, label %dget2.hit.93.i, label %mbit_cont.i.i.i308.i

mbit_cont.i.i.i308.i:                             ; preds = %archx_str_eq.exit.i.i.i306.i, %cmp_short.i.i.i.i332.i, %chk_key.i.i.i291.i
  %mm1.i.i.i309.i = add nsw i32 %mmask.i.i.i289887.i, -1
  %mmask_next.i.i.i310.i = and i32 %mm1.i.i.i309.i, %mmask.i.i.i289887.i
  %has_m.not.i.i.i290.i = icmp eq i32 %mmask_next.i.i.i310.i, 0
  br i1 %has_m.not.i.i.i290.i, label %chk_empty.i.i.i334.i, label %chk_key.i.i.i291.i

chk_empty.i.i.i334.i:                             ; preds = %mbit_cont.i.i.i308.i, %probe.i.i.i278.i
  %need_a.i.i.i335.i = icmp slt i64 %avail.i.i.i281.i, 0
  br i1 %need_a.i.i.i335.i, label %find_a.i.i.i346.i, label %after_a.i.i.i336.i

find_a.i.i.i346.i:                                ; preds = %chk_empty.i.i.i334.i
  %acmp.i.i.i347.i = icmp slt <16 x i8> %grp.i.i.i284.i, zeroinitializer
  %abits16.i.i.i348.i = bitcast <16 x i1> %acmp.i.i.i347.i to i16
  %has_a0.not.i.i.i349.i = icmp eq i16 %abits16.i.i.i348.i, 0
  br i1 %has_a0.not.i.i.i349.i, label %after_a.i.i.i336.i, label %set_a.i.i.i350.i

set_a.i.i.i350.i:                                 ; preds = %find_a.i.i.i346.i
  %99 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i348.i, i1 true)
  %atz64.i.i.i351.i = zext nneg i16 %99 to i64
  %as_add.i.i.i352.i = add i64 %pos.i.i.i282.i, %atz64.i.i.i351.i
  %aslot.i.i.i353.i = and i64 %as_add.i.i.i352.i, %mask.i.i.i271.i
  br label %after_a.i.i.i336.i

after_a.i.i.i336.i:                               ; preds = %set_a.i.i.i350.i, %find_a.i.i.i346.i, %chk_empty.i.i.i334.i
  %avail_cur.i.i.i337.i = phi i64 [ %avail.i.i.i281.i, %chk_empty.i.i.i334.i ], [ -1, %find_a.i.i.i346.i ], [ %aslot.i.i.i353.i, %set_a.i.i.i350.i ]
  %ecmp.i.i.i338.i = icmp eq <16 x i8> %grp.i.i.i284.i, splat (i8 -128)
  %ebits.i.i.i339.i = bitcast <16 x i1> %ecmp.i.i.i338.i to i16
  %has_e.not.i.i.i340.i = icmp eq i16 %ebits.i.i.i339.i, 0
  br i1 %has_e.not.i.i.i340.i, label %next_grp.i.i.i343.i, label %dget2.merge.97.i

next_grp.i.i.i343.i:                              ; preds = %after_a.i.i.i336.i
  %step_next.i.i.i344.i = add i64 %step.i.i.i280.i, 16
  %padd.i.i.i345.i = add i64 %step_next.i.i.i344.i, %pos.i.i.i282.i
  br label %probe.i.i.i278.i

dget2.hit.93.i:                                   ; preds = %archx_str_eq.exit.i.i.i306.i, %cmp_long.i.i.i.i320.i, %cmp_short.i.i.i.i332.i
  %t299.i = load ptr, ptr %t157.i, align 8
  %t300.i = getelementptr inbounds nuw i64, ptr %t299.i, i64 %didx.i.i.i298.i
  %t301.i = load i64, ptr %t300.i, align 8
  br label %dget2.merge.97.i

dget2.merge.97.i:                                 ; preds = %after_a.i.i.i336.i, %dget2.hit.93.i, %archx_hash_str.exit.i.i259.i
  %t302.i = phi i64 [ %t301.i, %dget2.hit.93.i ], [ 0, %archx_hash_str.exit.i.i259.i ], [ 0, %after_a.i.i.i336.i ]
  %t303.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.checksum.127.1888.i, i64 %t302.i)
  %t305.i = extractvalue { i64, i1 } %t303.i, 1
  br i1 %t305.i, label %overflow.add.98.i, label %overflow.ok.99.i

overflow.add.98.i:                                ; preds = %dget2.merge.97.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.99.i:                                 ; preds = %dget2.merge.97.i
  %t304.i = extractvalue { i64, i1 } %t303.i, 0
  %tag.i129.i = and i64 %w1.i.i.i234.i, 1
  %owned.not.i130.i = icmp eq i64 %tag.i129.i, 0
  %or.cond787.i = select i1 %short.i.i.i236.i, i1 true, i1 %owned.not.i130.i
  br i1 %or.cond787.i, label %archx_str_drop.exit134.i, label %do_free.i131.i

do_free.i131.i:                                   ; preds = %overflow.ok.99.i
  %raw.i132.i = and i64 %w1.i.i.i234.i, -2
  %ptr.i133.i = inttoptr i64 %raw.i132.i to ptr
  call void @free(ptr %ptr.i133.i)
  br label %archx_str_drop.exit134.i

archx_str_drop.exit134.i:                         ; preds = %do_free.i131.i, %overflow.ok.99.i
  %t308.i = add nuw nsw i64 %for.p.255.0889.i, 1
  %exitcond942.not.i = icmp eq i64 %t308.i, 1024
  br i1 %exitcond942.not.i, label %l_done.i.i.i418.i, label %idx.ok.91.i

l_done.i.i.i418.i:                                ; preds = %archx_str_drop.exit134.i
  %ctrl.i.i.i434.i = load ptr, ptr %ctrl_p.i, align 8
  %c_null.i.i.i435.i = icmp eq ptr %ctrl.i.i.i434.i, null
  br i1 %c_null.i.i.i435.i, label %if.then.100.critedge.i, label %do_probe.i.i.i436.i

do_probe.i.i.i436.i:                              ; preds = %l_done.i.i.i418.i
  %mask.i.i.i439.i = load i64, ptr %mask_p.i.i, align 8
  %keys.i.i.i440.i = load ptr, ptr %keys_p.i.i, align 8
  %100 = getelementptr i8, ptr %ctrl.i.i.i434.i, i64 %mask.i.i.i439.i
  %idx_base.i.i.i441.i = getelementptr i8, ptr %100, i64 17
  br label %probe.i.i.i446.i

probe.i.i.i446.i:                                 ; preds = %next_grp.i.i.i506.i, %do_probe.i.i.i436.i
  %h.pn.i.i.i447.i = phi i64 [ 7840821588020221045, %do_probe.i.i.i436.i ], [ %padd.i.i.i508.i, %next_grp.i.i.i506.i ]
  %step.i.i.i448.i = phi i64 [ 0, %do_probe.i.i.i436.i ], [ %step_next.i.i.i507.i, %next_grp.i.i.i506.i ]
  %avail.i.i.i449.i = phi i64 [ -1, %do_probe.i.i.i436.i ], [ %avail_cur.i.i.i500.i, %next_grp.i.i.i506.i ]
  %pos.i.i.i450.i = and i64 %h.pn.i.i.i447.i, %mask.i.i.i439.i
  %gp.i.i.i451.i = getelementptr inbounds i8, ptr %ctrl.i.i.i434.i, i64 %pos.i.i.i450.i
  %grp.i.i.i452.i = load <16 x i8>, ptr %gp.i.i.i451.i, align 1
  %mcmp.i.i.i453.i = icmp eq <16 x i8> %grp.i.i.i452.i, splat (i8 54)
  %mbits.i.i.i454.i = bitcast <16 x i1> %mcmp.i.i.i453.i to i16
  %has_m.not.i.i.i458896.i = icmp eq i16 %mbits.i.i.i454.i, 0
  br i1 %has_m.not.i.i.i458896.i, label %chk_empty.i.i.i497.i, label %chk_key.i.i.i459.preheader.i

chk_key.i.i.i459.preheader.i:                     ; preds = %probe.i.i.i446.i
  %mmask0.i.i.i455.i = zext i16 %mbits.i.i.i454.i to i32
  br label %chk_key.i.i.i459.i

chk_key.i.i.i459.i:                               ; preds = %mbit_cont.i.i.i475.i, %chk_key.i.i.i459.preheader.i
  %mmask.i.i.i457897.i = phi i32 [ %mmask_next.i.i.i477.i, %mbit_cont.i.i.i475.i ], [ %mmask0.i.i.i455.i, %chk_key.i.i.i459.preheader.i ]
  %tz.i2.i.i460.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i457897.i, i1 true)
  %tz64.i.i.i461.i = zext nneg i32 %tz.i2.i.i460.i to i64
  %s_add.i.i.i462.i = add i64 %pos.i.i.i450.i, %tz64.i.i.i461.i
  %slot.i.i.i463.i = and i64 %s_add.i.i.i462.i, %mask.i.i.i439.i
  %ip.i.i.i464.i = getelementptr inbounds i32, ptr %idx_base.i.i.i441.i, i64 %slot.i.i.i463.i
  %didx32.i.i.i465.i = load i32, ptr %ip.i.i.i464.i, align 4
  %didx.i.i.i466.i = zext i32 %didx32.i.i.i465.i to i64
  %kp.i.i.i467.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i440.i, i64 %didx.i.i.i466.i
  %cand_k.unpack.i.i.i468.i = load i64, ptr %kp.i.i.i467.i, align 8
  %w0_eq.i.i.i.i472.i = icmp eq i64 %cand_k.unpack.i.i.i468.i, 7310294788903796754
  br i1 %w0_eq.i.i.i.i472.i, label %cmp_long.i.i.i.i486.i, label %mbit_cont.i.i.i475.i

cmp_long.i.i.i.i486.i:                            ; preds = %chk_key.i.i.i459.i
  %cand_k.elt1.i.i.i469.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i467.i, i64 8
  %cand_k.unpack2.i.i.i470.i = load i64, ptr %cand_k.elt1.i.i.i469.i, align 8
  %ap_i.i.i.i.i487.i = and i64 %cand_k.unpack2.i.i.i470.i, -4
  %same_ptr.i.i.i.i488.i = icmp eq i64 %ap_i.i.i.i.i487.i, ptrtoint (ptr @.str.2 to i64)
  br i1 %same_ptr.i.i.i.i488.i, label %if.merge.102.i, label %archx_str_eq.exit.i.i.i473.i

archx_str_eq.exit.i.i.i473.i:                     ; preds = %cmp_long.i.i.i.i486.i
  %ap.i.i.i.i490.i = inttoptr i64 %ap_i.i.i.i.i487.i to ptr
  %ap4.i.i.i.i491.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i490.i, i64 4
  %bcmp.i.i.i.i493.i = call i32 @bcmp(ptr noundef nonnull dereferenceable(14) %ap4.i.i.i.i491.i, ptr noundef nonnull dereferenceable(14) getelementptr inbounds nuw (i8, ptr @.str.2, i64 4), i64 14)
  %eq_m.i.i.i.i494.i = icmp eq i32 %bcmp.i.i.i.i493.i, 0
  br i1 %eq_m.i.i.i.i494.i, label %if.merge.102.i, label %mbit_cont.i.i.i475.i

mbit_cont.i.i.i475.i:                             ; preds = %archx_str_eq.exit.i.i.i473.i, %chk_key.i.i.i459.i
  %mm1.i.i.i476.i = add nsw i32 %mmask.i.i.i457897.i, -1
  %mmask_next.i.i.i477.i = and i32 %mm1.i.i.i476.i, %mmask.i.i.i457897.i
  %has_m.not.i.i.i458.i = icmp eq i32 %mmask_next.i.i.i477.i, 0
  br i1 %has_m.not.i.i.i458.i, label %chk_empty.i.i.i497.i, label %chk_key.i.i.i459.i

chk_empty.i.i.i497.i:                             ; preds = %mbit_cont.i.i.i475.i, %probe.i.i.i446.i
  %need_a.i.i.i498.i = icmp slt i64 %avail.i.i.i449.i, 0
  br i1 %need_a.i.i.i498.i, label %find_a.i.i.i509.i, label %after_a.i.i.i499.i

find_a.i.i.i509.i:                                ; preds = %chk_empty.i.i.i497.i
  %acmp.i.i.i510.i = icmp slt <16 x i8> %grp.i.i.i452.i, zeroinitializer
  %abits16.i.i.i511.i = bitcast <16 x i1> %acmp.i.i.i510.i to i16
  %has_a0.not.i.i.i512.i = icmp eq i16 %abits16.i.i.i511.i, 0
  br i1 %has_a0.not.i.i.i512.i, label %after_a.i.i.i499.i, label %set_a.i.i.i513.i

set_a.i.i.i513.i:                                 ; preds = %find_a.i.i.i509.i
  %101 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i511.i, i1 true)
  %atz64.i.i.i514.i = zext nneg i16 %101 to i64
  %as_add.i.i.i515.i = add i64 %pos.i.i.i450.i, %atz64.i.i.i514.i
  %aslot.i.i.i516.i = and i64 %as_add.i.i.i515.i, %mask.i.i.i439.i
  br label %after_a.i.i.i499.i

after_a.i.i.i499.i:                               ; preds = %set_a.i.i.i513.i, %find_a.i.i.i509.i, %chk_empty.i.i.i497.i
  %avail_cur.i.i.i500.i = phi i64 [ %avail.i.i.i449.i, %chk_empty.i.i.i497.i ], [ -1, %find_a.i.i.i509.i ], [ %aslot.i.i.i516.i, %set_a.i.i.i513.i ]
  %ecmp.i.i.i501.i = icmp eq <16 x i8> %grp.i.i.i452.i, splat (i8 -128)
  %ebits.i.i.i502.i = bitcast <16 x i1> %ecmp.i.i.i501.i to i16
  %has_e.not.i.i.i503.i = icmp eq i16 %ebits.i.i.i502.i, 0
  br i1 %has_e.not.i.i.i503.i, label %next_grp.i.i.i506.i, label %if.then.100.critedge.i

next_grp.i.i.i506.i:                              ; preds = %after_a.i.i.i499.i
  %step_next.i.i.i507.i = add i64 %step.i.i.i448.i, 16
  %padd.i.i.i508.i = add i64 %step_next.i.i.i507.i, %pos.i.i.i450.i
  br label %probe.i.i.i446.i

if.then.100.critedge.i:                           ; preds = %after_a.i.i.i499.i, %l_done.i.i.i418.i
  br i1 %is_z.i.i.i, label %dlen.done.105.i, label %dlen.load.104.i

dlen.load.104.i:                                  ; preds = %if.then.100.critedge.i
  %t317.i = load i64, ptr %hdr.i.i, align 8
  br label %dlen.done.105.i

dlen.done.105.i:                                  ; preds = %dlen.load.104.i, %if.then.100.critedge.i
  %t318.i = phi i64 [ %t317.i, %dlen.load.104.i ], [ 0, %if.then.100.critedge.i ]
  %t319.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t304.i, i64 %t318.i)
  %t321.i = extractvalue { i64, i1 } %t319.i, 1
  br i1 %t321.i, label %overflow.add.106.i, label %overflow.ok.107.i

overflow.add.106.i:                               ; preds = %dlen.done.105.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.107.i:                                ; preds = %dlen.done.105.i
  %t320.i = extractvalue { i64, i1 } %t319.i, 0
  br label %if.merge.102.i

if.merge.102.i:                                   ; preds = %archx_str_eq.exit.i.i.i473.i, %cmp_long.i.i.i.i486.i, %overflow.ok.107.i
  %var.checksum.127.2.i = phi i64 [ %t320.i, %overflow.ok.107.i ], [ %t304.i, %cmp_long.i.i.i.i486.i ], [ %t304.i, %archx_str_eq.exit.i.i.i473.i ]
  %t326.i = load i64, ptr %t156.i, align 8
  %t330898.i = icmp sgt i64 %t326.i, 0
  br i1 %t330898.i, label %foritems.body.112.lr.ph.i, label %archx_dict_drop_s_i.exit.i

foritems.body.112.lr.ph.i:                        ; preds = %if.merge.102.i
  %t336.i = load ptr, ptr %t157.i, align 8
  br label %foritems.body.112.i

foritems.body.112.i:                              ; preds = %overflow.ok.116.i, %foritems.body.112.lr.ph.i
  %foritems.idx.328.0900.i = phi i64 [ 0, %foritems.body.112.lr.ph.i ], [ %t346.i, %overflow.ok.116.i ]
  %var.checksum.127.3899.i = phi i64 [ %var.checksum.127.2.i, %foritems.body.112.lr.ph.i ], [ %t343.i, %overflow.ok.116.i ]
  %t339.i = getelementptr inbounds nuw i64, ptr %t336.i, i64 %foritems.idx.328.0900.i
  %t340.i = load i64, ptr %t339.i, align 8
  %t342.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.checksum.127.3899.i, i64 %t340.i)
  %t344.i = extractvalue { i64, i1 } %t342.i, 1
  br i1 %t344.i, label %overflow.add.115.i, label %overflow.ok.116.i

overflow.add.115.i:                               ; preds = %foritems.body.112.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.116.i:                                ; preds = %foritems.body.112.i
  %t343.i = extractvalue { i64, i1 } %t342.i, 0
  %t346.i = add nuw nsw i64 %foritems.idx.328.0900.i, 1
  %exitcond943.not.i = icmp eq i64 %t346.i, %t326.i
  br i1 %exitcond943.not.i, label %foritems.end.114.i, label %foritems.body.112.i

foritems.end.114.i:                               ; preds = %overflow.ok.116.i
  %keys.i709.i = load ptr, ptr %keys_p.i.i, align 8
  br label %d_elem.i.i

d_elem.i.i:                                       ; preds = %foritems.end.114.i, %archx_str_drop.exit.i.i
  %storemerge5.i.i = phi i64 [ %inext.i712.i, %archx_str_drop.exit.i.i ], [ 0, %foritems.end.114.i ]
  %t0.i.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i709.i, i64 %storemerge5.i.i
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
  %inext.i712.i = add nuw nsw i64 %storemerge5.i.i, 1
  %exitcond.not.i713.i = icmp eq i64 %inext.i712.i, %t326.i
  br i1 %exitcond.not.i713.i, label %archx_dict_drop_s_i.exit.i, label %d_elem.i.i

archx_dict_drop_s_i.exit.i:                       ; preds = %archx_str_drop.exit.i.i, %if.merge.102.i
  %var.checksum.127.3.lcssa968.i = phi i64 [ %var.checksum.127.2.i, %if.merge.102.i ], [ %t343.i, %archx_str_drop.exit.i.i ]
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
  %t350.i = add nuw nsw i64 %for.r.131.0902.i, 1
  %exitcond944.not.i = icmp eq i64 %t350.i, 60
  br i1 %exitcond944.not.i, label %overflow.ok.136.i, label %for.body.42.i

overflow.ok.136.i:                                ; preds = %archx_region_rewind_root.exit.i
  %t420.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.checksum.127.3.lcssa968.i, i64 225)
  %t422.i = extractvalue { i64, i1 } %t420.i, 1
  br i1 %t422.i, label %overflow.add.137.i, label %overflow.ok.138.i

overflow.add.137.i:                               ; preds = %overflow.ok.136.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.138.i:                                ; preds = %overflow.ok.136.i
  %dst.i735.i = call noalias align 16 dereferenceable_or_null(20) ptr @malloc(i64 20)
  %isnull.i736.i = icmp eq ptr %dst.i735.i, null
  br i1 %isnull.i736.i, label %oom.i743.i, label %loop.i748.preheader.i

oom.i743.i:                                       ; preds = %overflow.ok.138.i
  call fastcc void @archx_oom_fail()
  unreachable

loop.i748.preheader.i:                            ; preds = %overflow.ok.138.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(20) %dst.i735.i, ptr noundef nonnull align 16 dereferenceable(20) %hp.i.i640.i, i64 20, i1 false)
  call void @free(ptr %hp.i.i640.i)
  br label %loop.i748.i

loop.i748.i:                                      ; preds = %archx_str_drop.exit.i758.i, %loop.i748.preheader.i
  %i.i749.i = phi i64 [ %inext.i759.i, %archx_str_drop.exit.i758.i ], [ 0, %loop.i748.preheader.i ]
  %ep.i.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.34.3.i, i64 %i.i749.i
  %t0.unpack.i.i = load i64, ptr %ep.i.i, align 8
  %t0.elt1.i.i = getelementptr inbounds nuw i8, ptr %ep.i.i, i64 8
  %t0.unpack2.i.i = load i64, ptr %t0.elt1.i.i, align 8
  %len.i.i750.i = and i64 %t0.unpack.i.i, 4294967295
  %long.i.i751.i = icmp samesign ult i64 %len.i.i750.i, 13
  %tag.i.i752.i = and i64 %t0.unpack2.i.i, 1
  %owned.not.i.i753.i = icmp eq i64 %tag.i.i752.i, 0
  %or.cond.i754.i = select i1 %long.i.i751.i, i1 true, i1 %owned.not.i.i753.i
  br i1 %or.cond.i754.i, label %archx_str_drop.exit.i758.i, label %do_free.i.i755.i

do_free.i.i755.i:                                 ; preds = %loop.i748.i
  %raw.i.i756.i = and i64 %t0.unpack2.i.i, -2
  %ptr.i.i757.i = inttoptr i64 %raw.i.i756.i to ptr
  call void @free(ptr %ptr.i.i757.i)
  br label %archx_str_drop.exit.i758.i

archx_str_drop.exit.i758.i:                       ; preds = %do_free.i.i755.i, %loop.i748.i
  %inext.i759.i = add nuw nsw i64 %i.i749.i, 1
  %exitcond.not.i760.i = icmp eq i64 %i.i749.i, 511
  br i1 %exitcond.not.i760.i, label %check.free.i.i, label %loop.i748.i

check.free.i.i:                                   ; preds = %archx_str_drop.exit.i758.i
  %is_heap.i.i = icmp sgt i64 %var.vocab.4.sroa.17.3.i, 0
  br i1 %is_heap.i.i, label %do.free.i.i, label %archx_vec_drop_s.exit.i

do.free.i.i:                                      ; preds = %check.free.i.i
  call void @free(ptr nonnull %var.vocab.4.sroa.34.3.i)
  br label %archx_vec_drop_s.exit.i

archx_vec_drop_s.exit.i:                          ; preds = %do.free.i.i, %check.free.i.i
  %t431.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i761.i = icmp eq ptr %t431.i, null
  br i1 %empty.i761.i, label %archx_fn_dict_and_slicing_tour.exit, label %loop.i762.i

loop.i762.i:                                      ; preds = %archx_vec_drop_s.exit.i, %loop.i762.i
  %cur.i.i = phi ptr [ %next.i.i, %loop.i762.i ], [ %t431.i, %archx_vec_drop_s.exit.i ]
  %next.i.i = load ptr, ptr %cur.i.i, align 8
  call void @free(ptr nonnull %cur.i.i)
  %more.not.i.i = icmp eq ptr %next.i.i, null
  br i1 %more.not.i.i, label %archx_fn_dict_and_slicing_tour.exit, label %loop.i762.i

archx_fn_dict_and_slicing_tour.exit:              ; preds = %loop.i762.i, %archx_vec_drop_s.exit.i
  %t421.i = extractvalue { i64, i1 } %t420.i, 0
  %pref64.i.i645.i = zext i32 %pref32.i.i644.i to i64
  %pref_sh.i.i646.i = shl nuw i64 %pref64.i.i645.i, 32
  %w0_out.i.i647.i = or disjoint i64 %pref_sh.i.i646.i, 20
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  %t7 = call noalias align 16 dereferenceable_or_null(512) ptr @calloc(i64 64, i64 8)
  %t8 = icmp eq ptr %t7, null
  br i1 %t8, label %calloc.oom.1, label %vector.body2052

vector.body2052:                                  ; preds = %archx_fn_dict_and_slicing_tour.exit, %vector.body2052
  %index2053 = phi i64 [ %index.next2055, %vector.body2052 ], [ 0, %archx_fn_dict_and_slicing_tour.exit ]
  %vec.ind2054 = phi <2 x i16> [ %vec.ind.next2056, %vector.body2052 ], [ <i16 0, i16 1>, %archx_fn_dict_and_slicing_tour.exit ]
  %102 = getelementptr inbounds nuw i64, ptr %t7, i64 %index2053
  %103 = mul nuw nsw <2 x i16> %vec.ind2054, splat (i16 37)
  %104 = mul <2 x i16> %vec.ind2054, splat (i16 37)
  %105 = add nuw nsw <2 x i16> %103, splat (i16 11)
  %106 = add <2 x i16> %104, splat (i16 85)
  %107 = urem <2 x i16> %105, splat (i16 97)
  %108 = urem <2 x i16> %106, splat (i16 97)
  %109 = add nuw nsw <2 x i16> %107, splat (i16 8)
  %110 = add nuw nsw <2 x i16> %108, splat (i16 8)
  %111 = zext nneg <2 x i16> %109 to <2 x i64>
  %112 = zext nneg <2 x i16> %110 to <2 x i64>
  %113 = getelementptr inbounds nuw i8, ptr %102, i64 16
  store <2 x i64> %111, ptr %102, align 16
  store <2 x i64> %112, ptr %113, align 16
  %index.next2055 = add nuw i64 %index2053, 4
  %vec.ind.next2056 = add <2 x i16> %vec.ind2054, splat (i16 4)
  %114 = icmp eq i64 %index.next2055, 64
  br i1 %114, label %for.end.5, label %vector.body2052, !llvm.loop !11

calloc.oom.1:                                     ; preds = %archx_fn_dict_and_slicing_tour.exit
  call fastcc void @archx_oom_fail()
  unreachable

for.end.5:                                        ; preds = %vector.body2052
  %t4.i1151 = load i64, ptr %t7, align 16
  %invariant.gep2161 = getelementptr inbounds i8, ptr %t7, i64 8
  br label %foreach.body.5.i

foreach.body.5.i:                                 ; preds = %overflow.ok.15.i.1, %for.end.5
  %var.lo.5.015.i = phi i64 [ %t4.i1151, %for.end.5 ], [ %spec.select.i.1, %overflow.ok.15.i.1 ]
  %foreach.idx.15.014.i = phi i64 [ 0, %for.end.5 ], [ %t35.i.1, %overflow.ok.15.i.1 ]
  %var.total.12.013.i = phi i64 [ 0, %for.end.5 ], [ %t32.i1156.1, %overflow.ok.15.i.1 ]
  %var.hi.11.012.i = phi i64 [ %t4.i1151, %for.end.5 ], [ %var.hi.11.1.i.1, %overflow.ok.15.i.1 ]
  %t19.i1152 = getelementptr inbounds nuw i64, ptr %t7, i64 %foreach.idx.15.014.i
  %t20.i1153 = load i64, ptr %t19.i1152, align 16
  %t31.i1154 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.total.12.013.i, i64 %t20.i1153)
  %t33.i1155 = extractvalue { i64, i1 } %t31.i1154, 1
  br i1 %t33.i1155, label %overflow.add.14.i, label %overflow.ok.15.i

overflow.add.14.i:                                ; preds = %overflow.ok.15.i, %foreach.body.5.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.15.i:                                 ; preds = %foreach.body.5.i
  %t32.i1156 = extractvalue { i64, i1 } %t31.i1154, 0
  %gep2162 = getelementptr inbounds i64, ptr %invariant.gep2161, i64 %foreach.idx.15.014.i
  %t20.i1153.1 = load i64, ptr %gep2162, align 8
  %t31.i1154.1 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t32.i1156, i64 %t20.i1153.1)
  %t33.i1155.1 = extractvalue { i64, i1 } %t31.i1154.1, 1
  br i1 %t33.i1155.1, label %overflow.add.14.i, label %overflow.ok.15.i.1

overflow.ok.15.i.1:                               ; preds = %overflow.ok.15.i
  %spec.select.i = call i64 @llvm.smin.i64(i64 %t20.i1153, i64 %var.lo.5.015.i)
  %var.hi.11.1.i = call i64 @llvm.smax.i64(i64 %t20.i1153, i64 %var.hi.11.012.i)
  %var.hi.11.1.i.1 = call i64 @llvm.smax.i64(i64 %t20.i1153.1, i64 %var.hi.11.1.i)
  %spec.select.i.1 = call i64 @llvm.smin.i64(i64 %t20.i1153.1, i64 %spec.select.i)
  %t32.i1156.1 = extractvalue { i64, i1 } %t31.i1154.1, 0
  %t35.i.1 = add nuw nsw i64 %foreach.idx.15.014.i, 2
  %exitcond.not.i1157.1 = icmp eq i64 %t35.i.1, 64
  br i1 %exitcond.not.i1157.1, label %enum.body.1.i, label %foreach.body.5.i

enum.body.1.i:                                    ; preds = %overflow.ok.15.i.1, %enum.step.2.i.3
  %enum.pos.2.03.i = phi i64 [ %t19.i1161.3, %enum.step.2.i.3 ], [ 0, %overflow.ok.15.i.1 ]
  %t5.i = getelementptr inbounds nuw i64, ptr %t7, i64 %enum.pos.2.03.i
  %t6.i = load i64, ptr %t5.i, align 16
  %t8.not.i = icmp slt i64 %t6.i, 95
  br i1 %t8.not.i, label %enum.step.2.i, label %overflow.ok.8.i

overflow.ok.8.i:                                  ; preds = %enum.step.2.i.2, %enum.step.2.i.1, %enum.step.2.i, %enum.body.1.i
  %enum.pos.2.03.i.lcssa = phi i64 [ %enum.pos.2.03.i, %enum.body.1.i ], [ %t19.i1161, %enum.step.2.i ], [ %t19.i1161.1, %enum.step.2.i.1 ], [ %t19.i1161.2, %enum.step.2.i.2 ]
  %t6.i.lcssa = phi i64 [ %t6.i, %enum.body.1.i ], [ %t6.i.1, %enum.step.2.i ], [ %t6.i.2, %enum.step.2.i.1 ], [ %t6.i.3, %enum.step.2.i.2 ]
  %t10.i = mul nuw nsw i64 %enum.pos.2.03.i.lcssa, 1000
  %t13.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t10.i, i64 %t6.i.lcssa)
  %t15.i1159 = extractvalue { i64, i1 } %t13.i, 1
  br i1 %t15.i1159, label %overflow.add.9.i, label %overflow.ok.10.i

overflow.add.9.i:                                 ; preds = %overflow.ok.8.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.10.i:                                 ; preds = %overflow.ok.8.i
  %t14.i = extractvalue { i64, i1 } %t13.i, 0
  %t17.i = insertvalue { i1, i64 } { i1 true, i64 undef }, i64 %t14.i, 1
  br label %archx_fn_find_spike.exit

enum.step.2.i:                                    ; preds = %enum.body.1.i
  %t19.i1161 = or disjoint i64 %enum.pos.2.03.i, 1
  %t5.i.1 = getelementptr inbounds nuw i64, ptr %t7, i64 %t19.i1161
  %t6.i.1 = load i64, ptr %t5.i.1, align 8
  %t8.not.i.1 = icmp slt i64 %t6.i.1, 95
  br i1 %t8.not.i.1, label %enum.step.2.i.1, label %overflow.ok.8.i

enum.step.2.i.1:                                  ; preds = %enum.step.2.i
  %t19.i1161.1 = or disjoint i64 %enum.pos.2.03.i, 2
  %t5.i.2 = getelementptr inbounds nuw i64, ptr %t7, i64 %t19.i1161.1
  %t6.i.2 = load i64, ptr %t5.i.2, align 16
  %t8.not.i.2 = icmp slt i64 %t6.i.2, 95
  br i1 %t8.not.i.2, label %enum.step.2.i.2, label %overflow.ok.8.i

enum.step.2.i.2:                                  ; preds = %enum.step.2.i.1
  %t19.i1161.2 = or disjoint i64 %enum.pos.2.03.i, 3
  %t5.i.3 = getelementptr inbounds nuw i64, ptr %t7, i64 %t19.i1161.2
  %t6.i.3 = load i64, ptr %t5.i.3, align 8
  %t8.not.i.3 = icmp slt i64 %t6.i.3, 95
  br i1 %t8.not.i.3, label %enum.step.2.i.3, label %overflow.ok.8.i

enum.step.2.i.3:                                  ; preds = %enum.step.2.i.2
  %t19.i1161.3 = add nuw nsw i64 %enum.pos.2.03.i, 4
  %exitcond.not.i1162.3 = icmp eq i64 %t19.i1161.3, 64
  br i1 %exitcond.not.i1162.3, label %archx_fn_find_spike.exit, label %enum.body.1.i

archx_fn_find_spike.exit:                         ; preds = %enum.step.2.i.3, %overflow.ok.10.i
  %common.ret.op.i1160 = phi { i1, i64 } [ %t17.i, %overflow.ok.10.i ], [ zeroinitializer, %enum.step.2.i.3 ]
  br label %enum.body.1.i1163

enum.body.1.i1163:                                ; preds = %enum.step.2.i1177.3, %archx_fn_find_spike.exit
  %enum.pos.2.03.i1164 = phi i64 [ 0, %archx_fn_find_spike.exit ], [ %t19.i1178.3, %enum.step.2.i1177.3 ]
  %t5.i1165 = getelementptr inbounds nuw i64, ptr %t7, i64 %enum.pos.2.03.i1164
  %t6.i1166 = load i64, ptr %t5.i1165, align 16
  %t8.not.i1167 = icmp slt i64 %t6.i1166, 999
  br i1 %t8.not.i1167, label %enum.step.2.i1177, label %overflow.ok.8.i1168

overflow.ok.8.i1168:                              ; preds = %enum.step.2.i1177.2, %enum.step.2.i1177.1, %enum.step.2.i1177, %enum.body.1.i1163
  %enum.pos.2.03.i1164.lcssa = phi i64 [ %enum.pos.2.03.i1164, %enum.body.1.i1163 ], [ %t19.i1178, %enum.step.2.i1177 ], [ %t19.i1178.1, %enum.step.2.i1177.1 ], [ %t19.i1178.2, %enum.step.2.i1177.2 ]
  %t6.i1166.lcssa = phi i64 [ %t6.i1166, %enum.body.1.i1163 ], [ %t6.i1166.1, %enum.step.2.i1177 ], [ %t6.i1166.2, %enum.step.2.i1177.1 ], [ %t6.i1166.3, %enum.step.2.i1177.2 ]
  %t10.i1169 = mul nuw nsw i64 %enum.pos.2.03.i1164.lcssa, 1000
  %t13.i1170 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t10.i1169, i64 %t6.i1166.lcssa)
  %t15.i1171 = extractvalue { i64, i1 } %t13.i1170, 1
  br i1 %t15.i1171, label %overflow.add.9.i1176, label %overflow.ok.10.i1172

overflow.add.9.i1176:                             ; preds = %overflow.ok.8.i1168
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.10.i1172:                             ; preds = %overflow.ok.8.i1168
  %t14.i1173 = extractvalue { i64, i1 } %t13.i1170, 0
  %t17.i1174 = insertvalue { i1, i64 } { i1 true, i64 undef }, i64 %t14.i1173, 1
  br label %archx_fn_find_spike.exit1180

enum.step.2.i1177:                                ; preds = %enum.body.1.i1163
  %t19.i1178 = or disjoint i64 %enum.pos.2.03.i1164, 1
  %t5.i1165.1 = getelementptr inbounds nuw i64, ptr %t7, i64 %t19.i1178
  %t6.i1166.1 = load i64, ptr %t5.i1165.1, align 8
  %t8.not.i1167.1 = icmp slt i64 %t6.i1166.1, 999
  br i1 %t8.not.i1167.1, label %enum.step.2.i1177.1, label %overflow.ok.8.i1168

enum.step.2.i1177.1:                              ; preds = %enum.step.2.i1177
  %t19.i1178.1 = or disjoint i64 %enum.pos.2.03.i1164, 2
  %t5.i1165.2 = getelementptr inbounds nuw i64, ptr %t7, i64 %t19.i1178.1
  %t6.i1166.2 = load i64, ptr %t5.i1165.2, align 16
  %t8.not.i1167.2 = icmp slt i64 %t6.i1166.2, 999
  br i1 %t8.not.i1167.2, label %enum.step.2.i1177.2, label %overflow.ok.8.i1168

enum.step.2.i1177.2:                              ; preds = %enum.step.2.i1177.1
  %t19.i1178.2 = or disjoint i64 %enum.pos.2.03.i1164, 3
  %t5.i1165.3 = getelementptr inbounds nuw i64, ptr %t7, i64 %t19.i1178.2
  %t6.i1166.3 = load i64, ptr %t5.i1165.3, align 8
  %t8.not.i1167.3 = icmp slt i64 %t6.i1166.3, 999
  br i1 %t8.not.i1167.3, label %enum.step.2.i1177.3, label %overflow.ok.8.i1168

enum.step.2.i1177.3:                              ; preds = %enum.step.2.i1177.2
  %t19.i1178.3 = add nuw nsw i64 %enum.pos.2.03.i1164, 4
  %exitcond.not.i1179.3 = icmp eq i64 %t19.i1178.3, 64
  br i1 %exitcond.not.i1179.3, label %archx_fn_find_spike.exit1180, label %enum.body.1.i1163

archx_fn_find_spike.exit1180:                     ; preds = %enum.step.2.i1177.3, %overflow.ok.10.i1172
  %common.ret.op.i1175 = phi { i1, i64 } [ %t17.i1174, %overflow.ok.10.i1172 ], [ zeroinitializer, %enum.step.2.i1177.3 ]
  %t51 = extractvalue { i1, i64 } %common.ret.op.i1160, 0
  br i1 %t51, label %ifexpr.then.14, label %ifexpr.merge.16

ifexpr.then.14:                                   ; preds = %archx_fn_find_spike.exit1180
  %t52 = extractvalue { i1, i64 } %common.ret.op.i1160, 1
  %t53 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t52, i64 1)
  %t55 = extractvalue { i64, i1 } %t53, 1
  br i1 %t55, label %overflow.add.17, label %overflow.ok.18

overflow.add.17:                                  ; preds = %ifexpr.then.14
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.18:                                   ; preds = %ifexpr.then.14
  %t54 = extractvalue { i64, i1 } %t53, 0
  br label %ifexpr.merge.16

ifexpr.merge.16:                                  ; preds = %archx_fn_find_spike.exit1180, %overflow.ok.18
  %ifexpr.res.56.0 = phi i64 [ %t54, %overflow.ok.18 ], [ -1, %archx_fn_find_spike.exit1180 ]
  %t50.fca.0.extract = extractvalue { i1, i64 } %common.ret.op.i1175, 0
  br i1 %t50.fca.0.extract, label %pat.opt.some.22, label %match.end.19

pat.opt.some.22:                                  ; preds = %ifexpr.merge.16
  %t50.fca.1.extract = extractvalue { i1, i64 } %common.ret.op.i1175, 1
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i)
  %n32.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t50.fca.1.extract)
  %len.i1181 = sext i32 %n32.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i)
  %z.i.i1182 = icmp slt i32 %n32.i, 1
  br i1 %z.i.i1182, label %archx_str_from_int.exit, label %chk_sso.i.i

oom.i.i1194:                                      ; preds = %alloc_heap.i.i1184
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i:                                      ; preds = %pat.opt.some.22
  %short.i.i1183 = icmp samesign ult i32 %n32.i, 13
  br i1 %short.i.i1183, label %pack_sso.i.i, label %alloc_heap.i.i1184

pack_sso.i.i:                                     ; preds = %chk_sso.i.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i, i8 0, i64 16, i1 false)
  store i32 %n32.i, ptr %sso.i.i, align 8
  %sso.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i, i64 %len.i1181, i1 false)
  %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i = load i64, ptr %sso.i.i, align 8
  %sso.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 8
  %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i = load i64, ptr %sso.i.i.8.sroa_idx, align 8
  %ss0.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i, 0
  %ss1.i.i = insertvalue %ArchxStr %ss0.i.i, i64 %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i, 1
  br label %archx_str_from_int.exit

alloc_heap.i.i1184:                               ; preds = %chk_sso.i.i
  %hp.i.i1185 = call noalias align 16 ptr @malloc(i64 %len.i1181)
  %hnull.i.i1186 = icmp eq ptr %hp.i.i1185, null
  br i1 %hnull.i.i1186, label %oom.i.i1194, label %copy_long.i.i1187

copy_long.i.i1187:                                ; preds = %alloc_heap.i.i1184
  %hp_i.i.i1188 = ptrtoint ptr %hp.i.i1185 to i64
  %htagged.i.i1189 = or disjoint i64 %hp_i.i.i1188, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1185, ptr nonnull readonly align 8 %buf.i, i64 %len.i1181, i1 false)
  %pref32.i.i = load i32, ptr %hp.i.i1185, align 16
  %pref64.i.i = zext i32 %pref32.i.i to i64
  %pref_sh.i.i = shl nuw i64 %pref64.i.i, 32
  %w0_out.i.i1190 = or disjoint i64 %pref_sh.i.i, %len.i1181
  %ls0.i.i1191 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1190, 0
  %ls1.i.i1192 = insertvalue %ArchxStr %ls0.i.i1191, i64 %htagged.i.i1189, 1
  br label %archx_str_from_int.exit

archx_str_from_int.exit:                          ; preds = %pat.opt.some.22, %pack_sso.i.i, %copy_long.i.i1187
  %common.ret.op.i.i1193 = phi %ArchxStr [ %ss1.i.i, %pack_sso.i.i ], [ %ls1.i.i1192, %copy_long.i.i1187 ], [ zeroinitializer, %pat.opt.some.22 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  %bw0.i = extractvalue %ArchxStr %common.ret.op.i.i1193, 0
  %bw1.i = extractvalue %ArchxStr %common.ret.op.i.i1193, 1
  %blen.i = and i64 %bw0.i, 4294967295
  %bz.i = icmp eq i64 %blen.i, 0
  br i1 %bz.i, label %archx_str_concat.exit.thread, label %calc_tot.i

archx_str_concat.exit.thread:                     ; preds = %archx_str_from_int.exit
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  br label %match.end.19

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
  br i1 %fits_sso.i, label %archx_str_concat.exit.thread1975, label %alloc_heap.i

archx_str_concat.exit.thread1975:                 ; preds = %build.i
  store i64 0, ptr %out_sso.i.sroa.6, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i.sroa.6, ptr nonnull align 4 %btmp.i, i64 %blen.i, i1 false)
  %out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.8.rw1.i = load i64, ptr %out_sso.i.sroa.6, align 8
  %out_sso.i.sroa.0.4.insert.insert.pn1977 = or disjoint i64 %tot.i, 6875977890521939968
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  br label %match.end.19

alloc_heap.i:                                     ; preds = %build.i.thread, %build.i
  %bptr.i1974 = phi ptr [ %blptr.i, %build.i.thread ], [ %btmp.i, %build.i ]
  %hp.i = call noalias align 16 ptr @malloc(i64 %tot.i)
  %hnull.i = icmp eq ptr %hp.i, null
  br i1 %hnull.i, label %oom.i, label %archx_str_concat.exit

archx_str_concat.exit:                            ; preds = %alloc_heap.i
  %hp_i.i = ptrtoint ptr %hp.i to i64
  %htagged.i = or disjoint i64 %hp_i.i, 1
  store i32 1600938358, ptr %hp.i, align 16
  %dst_b.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %dst_b.i, ptr nonnull align 1 %bptr.i1974, i64 %blen.i, i1 false)
  %out_sso.i.sroa.0.4.insert.insert.pn = or disjoint i64 %tot.i, 6875977890521939968
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  %tag.i = and i64 %bw1.i, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %bshort.i, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %match.end.19, label %do_free.i

do_free.i:                                        ; preds = %archx_str_concat.exit
  %raw.i = and i64 %bw1.i, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  call void @free(ptr %ptr.i)
  br label %match.end.19

match.end.19:                                     ; preds = %archx_str_concat.exit.thread1975, %do_free.i, %archx_str_concat.exit, %archx_str_concat.exit.thread, %ifexpr.merge.16
  %var.miss_label.61.sroa.7.0 = phi i64 [ 121, %ifexpr.merge.16 ], [ 0, %archx_str_concat.exit.thread ], [ %htagged.i, %archx_str_concat.exit ], [ %htagged.i, %do_free.i ], [ %out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.8.rw1.i, %archx_str_concat.exit.thread1975 ]
  %var.miss_label.61.sroa.0.0 = phi i64 [ 8390326386350358533, %ifexpr.merge.16 ], [ 6875977890521939972, %archx_str_concat.exit.thread ], [ %out_sso.i.sroa.0.4.insert.insert.pn, %archx_str_concat.exit ], [ %out_sso.i.sroa.0.4.insert.insert.pn, %do_free.i ], [ %out_sso.i.sroa.0.4.insert.insert.pn1977, %archx_str_concat.exit.thread1975 ]
  br label %mod.ok.5.i1196

mod.ok.5.i1196:                                   ; preds = %for.step.2.i1201, %match.end.19
  %var.acc.0.039.i = phi i64 [ 0, %match.end.19 ], [ %var.acc.0.1.i, %for.step.2.i1201 ]
  %for.i.1.038.i = phi i64 [ 0, %match.end.19 ], [ %t148.i, %for.step.2.i1201 ]
  %t11.lhs.trunc.i = trunc nuw nsw i64 %for.i.1.038.i to i32
  %t1124.i = urem i32 %t11.lhs.trunc.i, 5
  %115 = mul nuw nsw i32 %t11.lhs.trunc.i, 17
  %t31.lhs.trunc.i = add nuw nsw i32 %115, 3
  %t3125.i = urem i32 %t31.lhs.trunc.i, 40
  %t31.zext.i = zext nneg i32 %t3125.i to i64
  switch i32 %t1124.i, label %archx_fn_make_event.exit.i [
    i32 0, label %pat.int.ok.2.i.i
    i32 1, label %pat.int.ok.4.i.i
    i32 2, label %pat.int.ok.6.i.i
    i32 3, label %pat.int.ok.8.i.i
  ]

pat.int.ok.2.i.i:                                 ; preds = %mod.ok.5.i1196
  %t5.fca.1.0.insert.i.i = insertvalue %ArchxEnum_Event { i64 0, [2 x i64] poison }, i64 %t31.zext.i, 1, 0
  %t5.fca.1.1.insert.i.i = insertvalue %ArchxEnum_Event %t5.fca.1.0.insert.i.i, i64 0, 1, 1
  br label %archx_fn_make_event.exit.i

pat.int.ok.4.i.i:                                 ; preds = %mod.ok.5.i1196
  %116 = mul nuw nsw i32 %t11.lhs.trunc.i, 13
  %t51.lhs.trunc.i = add nuw nsw i32 %116, 7
  %t5126.i = urem i32 %t51.lhs.trunc.i, 25
  %t51.zext.i = zext nneg i32 %t5126.i to i64
  %t11.fca.1.0.insert.i.i = insertvalue %ArchxEnum_Event { i64 1, [2 x i64] poison }, i64 %t31.zext.i, 1, 0
  %t11.fca.1.1.insert.i.i = insertvalue %ArchxEnum_Event %t11.fca.1.0.insert.i.i, i64 %t51.zext.i, 1, 1
  br label %archx_fn_make_event.exit.i

pat.int.ok.6.i.i:                                 ; preds = %mod.ok.5.i1196
  %t16.fca.1.0.insert.i.i = insertvalue %ArchxEnum_Event { i64 2, [2 x i64] poison }, i64 %t31.zext.i, 1, 0
  %t16.fca.1.1.insert.i.i = insertvalue %ArchxEnum_Event %t16.fca.1.0.insert.i.i, i64 0, 1, 1
  br label %archx_fn_make_event.exit.i

pat.int.ok.8.i.i:                                 ; preds = %mod.ok.5.i1196
  %t21.fca.1.0.insert.i.i = insertvalue %ArchxEnum_Event { i64 3, [2 x i64] poison }, i64 %t31.zext.i, 1, 0
  %t21.fca.1.1.insert.i.i = insertvalue %ArchxEnum_Event %t21.fca.1.0.insert.i.i, i64 0, 1, 1
  br label %archx_fn_make_event.exit.i

archx_fn_make_event.exit.i:                       ; preds = %pat.int.ok.8.i.i, %pat.int.ok.6.i.i, %pat.int.ok.4.i.i, %pat.int.ok.2.i.i, %mod.ok.5.i1196
  %common.ret.op.i.i1197 = phi %ArchxEnum_Event [ %t5.fca.1.1.insert.i.i, %pat.int.ok.2.i.i ], [ %t11.fca.1.1.insert.i.i, %pat.int.ok.4.i.i ], [ %t16.fca.1.1.insert.i.i, %pat.int.ok.6.i.i ], [ %t21.fca.1.1.insert.i.i, %pat.int.ok.8.i.i ], [ { i64 4, [2 x i64] zeroinitializer }, %mod.ok.5.i1196 ]
  %t59.fca.0.extract.i = extractvalue %ArchxEnum_Event %common.ret.op.i.i1197, 0
  %t59.fca.1.0.extract.i = extractvalue %ArchxEnum_Event %common.ret.op.i.i1197, 1, 0
  %t59.fca.1.1.extract.i = extractvalue %ArchxEnum_Event %common.ret.op.i.i1197, 1, 1
  %t63.i1198 = icmp eq i64 %t59.fca.0.extract.i, 0
  %t69.i1199 = icmp sgt i64 %t59.fca.1.0.extract.i, 20
  %or.cond.i1200 = select i1 %t63.i1198, i1 %t69.i1199, i1 false
  br i1 %or.cond.i1200, label %match.body.21.i, label %match.next.19.i

match.body.21.i:                                  ; preds = %archx_fn_make_event.exit.i
  %t71.i1212 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t59.fca.1.0.extract.i, i64 %t59.fca.1.0.extract.i)
  %t73.i = extractvalue { i64, i1 } %t71.i1212, 1
  br i1 %t73.i, label %overflow.mul.23.i, label %overflow.ok.24.i

overflow.mul.23.i:                                ; preds = %match.body.21.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.24.i:                                 ; preds = %match.body.21.i
  %t72.i1213 = extractvalue { i64, i1 } %t71.i1212, 0
  %t74.i1214 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t72.i1213, i64 7)
  %t76.i1215 = extractvalue { i64, i1 } %t74.i1214, 1
  br i1 %t76.i1215, label %overflow.add.25.i, label %overflow.ok.26.i

overflow.add.25.i:                                ; preds = %overflow.ok.24.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.26.i:                                 ; preds = %overflow.ok.24.i
  %t75.i1216 = extractvalue { i64, i1 } %t74.i1214, 0
  %t77.i1217 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.0.039.i, i64 %t75.i1216)
  %t79.i = extractvalue { i64, i1 } %t77.i1217, 1
  br i1 %t79.i, label %overflow.add.27.i, label %overflow.ok.28.i

overflow.add.27.i:                                ; preds = %overflow.ok.26.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.28.i:                                 ; preds = %overflow.ok.26.i
  %t78.i = extractvalue { i64, i1 } %t77.i1217, 0
  br label %for.step.2.i1201

match.next.19.i:                                  ; preds = %archx_fn_make_event.exit.i
  br i1 %t63.i1198, label %pat.enum.ok.30.i, label %match.next.29.i

pat.enum.ok.30.i:                                 ; preds = %match.next.19.i
  %t89.i = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t59.fca.1.0.extract.i, i64 3)
  %t91.i1208 = extractvalue { i64, i1 } %t89.i, 1
  br i1 %t91.i1208, label %overflow.mul.31.i, label %overflow.ok.34.i

overflow.mul.31.i:                                ; preds = %pat.enum.ok.30.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.34.i:                                 ; preds = %pat.enum.ok.30.i
  %t90.i = extractvalue { i64, i1 } %t89.i, 0
  %t9227.i = add nsw i64 %t90.i, 1
  %t95.i1209 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.0.039.i, i64 %t9227.i)
  %t97.i1210 = extractvalue { i64, i1 } %t95.i1209, 1
  br i1 %t97.i1210, label %overflow.add.35.i, label %overflow.ok.36.i

overflow.add.35.i:                                ; preds = %overflow.ok.34.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.36.i:                                 ; preds = %overflow.ok.34.i
  %t96.i1211 = extractvalue { i64, i1 } %t95.i1209, 0
  br label %for.step.2.i1201

match.next.29.i:                                  ; preds = %match.next.19.i
  switch i64 %t59.fca.0.extract.i, label %for.step.2.i1201 [
    i64 1, label %pat.enum.ok.38.i
    i64 2, label %pat.or.ok.44.i
    i64 3, label %pat.or.ok.44.i
    i64 4, label %pat.enum.ok.54.i
  ]

pat.enum.ok.38.i:                                 ; preds = %match.next.29.i
  %t111.i1204 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t59.fca.1.0.extract.i, i64 %t59.fca.1.1.extract.i)
  %t113.i = extractvalue { i64, i1 } %t111.i1204, 1
  br i1 %t113.i, label %overflow.mul.39.i, label %overflow.ok.40.i

overflow.mul.39.i:                                ; preds = %pat.enum.ok.38.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.40.i:                                 ; preds = %pat.enum.ok.38.i
  %t112.i1205 = extractvalue { i64, i1 } %t111.i1204, 0
  %t114.i1206 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.0.039.i, i64 %t112.i1205)
  %t116.i = extractvalue { i64, i1 } %t114.i1206, 1
  br i1 %t116.i, label %overflow.add.41.i, label %overflow.ok.42.i

overflow.add.41.i:                                ; preds = %overflow.ok.40.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.42.i:                                 ; preds = %overflow.ok.40.i
  %t115.i1207 = extractvalue { i64, i1 } %t114.i1206, 0
  br label %for.step.2.i1201

pat.or.ok.44.i:                                   ; preds = %match.next.29.i, %match.next.29.i
  %117 = add i64 %t59.fca.1.0.extract.i, -2305843009213693952
  %t133.i = icmp ult i64 %117, -4611686018427387904
  br i1 %t133.i, label %overflow.mul.48.i, label %overflow.ok.51.i

overflow.mul.48.i:                                ; preds = %pat.or.ok.44.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.51.i:                                 ; preds = %pat.or.ok.44.i
  %t132.i = shl nsw i64 %t59.fca.1.0.extract.i, 2
  %t134.i = or disjoint i64 %t132.i, 2
  %t137.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.0.039.i, i64 %t134.i)
  %t139.i = extractvalue { i64, i1 } %t137.i, 1
  br i1 %t139.i, label %overflow.add.52.i, label %overflow.ok.53.i

overflow.add.52.i:                                ; preds = %overflow.ok.51.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.53.i:                                 ; preds = %overflow.ok.51.i
  %t138.i = extractvalue { i64, i1 } %t137.i, 0
  br label %for.step.2.i1201

pat.enum.ok.54.i:                                 ; preds = %match.next.29.i
  %t144.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.0.039.i, i64 1)
  %t146.i = extractvalue { i64, i1 } %t144.i, 1
  br i1 %t146.i, label %overflow.add.55.i, label %overflow.ok.56.i

overflow.add.55.i:                                ; preds = %pat.enum.ok.54.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.56.i:                                 ; preds = %pat.enum.ok.54.i
  %t145.i = extractvalue { i64, i1 } %t144.i, 0
  br label %for.step.2.i1201

for.step.2.i1201:                                 ; preds = %overflow.ok.56.i, %overflow.ok.53.i, %overflow.ok.42.i, %match.next.29.i, %overflow.ok.36.i, %overflow.ok.28.i
  %var.acc.0.1.i = phi i64 [ %t78.i, %overflow.ok.28.i ], [ %t96.i1211, %overflow.ok.36.i ], [ %t115.i1207, %overflow.ok.42.i ], [ %t138.i, %overflow.ok.53.i ], [ %t145.i, %overflow.ok.56.i ], [ %var.acc.0.039.i, %match.next.29.i ]
  %t148.i = add nuw nsw i64 %for.i.1.038.i, 1
  %exitcond.not.i1202 = icmp eq i64 %t148.i, 200000
  br i1 %exitcond.not.i1202, label %archx_fn_dispatch_events.exit, label %mod.ok.5.i1196

archx_fn_dispatch_events.exit:                    ; preds = %for.step.2.i1201
  %t3.i1218 = call noalias align 16 dereferenceable_or_null(16000) ptr @calloc(i64 2000, i64 8)
  %t4.i1219 = icmp eq ptr %t3.i1218, null
  br i1 %t4.i1219, label %calloc.oom.3.i1267, label %overflow.ok.9.i

calloc.oom.3.i1267:                               ; preds = %archx_fn_dispatch_events.exit
  call fastcc void @archx_oom_fail()
  unreachable

overflow.ok.9.i:                                  ; preds = %archx_fn_dispatch_events.exit, %overflow.ok.9.i
  %for.i.9.0113.i = phi i64 [ %t22.i.4, %overflow.ok.9.i ], [ 0, %archx_fn_dispatch_events.exit ]
  %t18.i = mul nuw nsw i64 %for.i.9.0113.i, %for.i.9.0113.i
  %t15.i1220 = getelementptr inbounds nuw i64, ptr %t3.i1218, i64 %for.i.9.0113.i
  store i64 %t18.i, ptr %t15.i1220, align 8
  %t22.i = add nuw nsw i64 %for.i.9.0113.i, 1
  %t18.i.1 = mul nuw nsw i64 %t22.i, %t22.i
  %t15.i1220.1 = getelementptr inbounds nuw i64, ptr %t3.i1218, i64 %t22.i
  store i64 %t18.i.1, ptr %t15.i1220.1, align 8
  %t22.i.1 = add nuw nsw i64 %for.i.9.0113.i, 2
  %t18.i.2 = mul nuw nsw i64 %t22.i.1, %t22.i.1
  %t15.i1220.2 = getelementptr inbounds nuw i64, ptr %t3.i1218, i64 %t22.i.1
  store i64 %t18.i.2, ptr %t15.i1220.2, align 8
  %t22.i.2 = add nuw nsw i64 %for.i.9.0113.i, 3
  %t18.i.3 = mul nuw nsw i64 %t22.i.2, %t22.i.2
  %t15.i1220.3 = getelementptr inbounds nuw i64, ptr %t3.i1218, i64 %t22.i.2
  store i64 %t18.i.3, ptr %t15.i1220.3, align 8
  %t22.i.3 = add nuw nsw i64 %for.i.9.0113.i, 4
  %t18.i.4 = mul nuw nsw i64 %t22.i.3, %t22.i.3
  %t15.i1220.4 = getelementptr inbounds nuw i64, ptr %t3.i1218, i64 %t22.i.3
  store i64 %t18.i.4, ptr %t15.i1220.4, align 8
  %t22.i.4 = add nuw nsw i64 %for.i.9.0113.i, 5
  %exitcond.not.i1221.4 = icmp eq i64 %t22.i.4, 2000
  br i1 %exitcond.not.i1221.4, label %foreach.body.11.i.preheader, label %overflow.ok.9.i

foreach.body.11.i.preheader:                      ; preds = %overflow.ok.9.i
  %invariant.gep2163 = getelementptr inbounds i8, ptr %t3.i1218, i64 8
  br label %foreach.body.11.i

foreach.body.11.i:                                ; preds = %foreach.step.12.i.1, %foreach.body.11.i.preheader
  %var.acc.23.0115.i = phi i64 [ 0, %foreach.body.11.i.preheader ], [ %var.acc.23.1.i.1, %foreach.step.12.i.1 ]
  %foreach.idx.26.0114.i = phi i64 [ 0, %foreach.body.11.i.preheader ], [ %t53.i.1, %foreach.step.12.i.1 ]
  %t30.i = getelementptr inbounds nuw i64, ptr %t3.i1218, i64 %foreach.idx.26.0114.i
  %t31.i1222 = load i64, ptr %t30.i, align 16
  %t45.i1223 = and i64 %t31.i1222, 1
  %t46.i = icmp eq i64 %t45.i1223, 0
  br i1 %t46.i, label %if.then.16.i, label %foreach.step.12.i

if.then.16.i:                                     ; preds = %foreach.body.11.i
  %t49.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.23.0115.i, i64 %t31.i1222)
  %t51.i1265 = extractvalue { i64, i1 } %t49.i, 1
  br i1 %t51.i1265, label %overflow.add.19.i, label %overflow.ok.20.i

overflow.add.19.i:                                ; preds = %if.then.16.i.1, %if.then.16.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.20.i:                                 ; preds = %if.then.16.i
  %t50.i1266 = extractvalue { i64, i1 } %t49.i, 0
  br label %foreach.step.12.i

foreach.step.12.i:                                ; preds = %overflow.ok.20.i, %foreach.body.11.i
  %var.acc.23.1.i = phi i64 [ %t50.i1266, %overflow.ok.20.i ], [ %var.acc.23.0115.i, %foreach.body.11.i ]
  %gep2164 = getelementptr inbounds i64, ptr %invariant.gep2163, i64 %foreach.idx.26.0114.i
  %t31.i1222.1 = load i64, ptr %gep2164, align 8
  %t45.i1223.1 = and i64 %t31.i1222.1, 1
  %t46.i.1 = icmp eq i64 %t45.i1223.1, 0
  br i1 %t46.i.1, label %if.then.16.i.1, label %foreach.step.12.i.1

if.then.16.i.1:                                   ; preds = %foreach.step.12.i
  %t49.i.1 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.23.1.i, i64 %t31.i1222.1)
  %t51.i1265.1 = extractvalue { i64, i1 } %t49.i.1, 1
  br i1 %t51.i1265.1, label %overflow.add.19.i, label %overflow.ok.20.i.1

overflow.ok.20.i.1:                               ; preds = %if.then.16.i.1
  %t50.i1266.1 = extractvalue { i64, i1 } %t49.i.1, 0
  br label %foreach.step.12.i.1

foreach.step.12.i.1:                              ; preds = %overflow.ok.20.i.1, %foreach.step.12.i
  %var.acc.23.1.i.1 = phi i64 [ %t50.i1266.1, %overflow.ok.20.i.1 ], [ %var.acc.23.1.i, %foreach.step.12.i ]
  %t53.i.1 = add nuw nsw i64 %foreach.idx.26.0114.i, 2
  %exitcond199.not.i.1 = icmp eq i64 %t53.i.1, 2000
  br i1 %exitcond199.not.i.1, label %mod.ok.26.i, label %foreach.body.11.i

mod.ok.26.i:                                      ; preds = %foreach.step.12.i.1, %for.step.23.i.1
  %for.x.54.0117.i = phi i64 [ %t79.i1225.1, %for.step.23.i.1 ], [ 0, %foreach.step.12.i.1 ]
  %var.acc.23.2116.i = phi i64 [ %var.acc.23.3.i.1, %for.step.23.i.1 ], [ %var.acc.23.1.i.1, %foreach.step.12.i.1 ]
  %t64.lhs.trunc.i = trunc nuw nsw i64 %for.x.54.0117.i to i16
  %t6478.i = urem i16 %t64.lhs.trunc.i, 3
  %t72.i1224 = icmp eq i16 %t6478.i, 0
  br i1 %t72.i1224, label %if.then.27.i, label %for.step.23.i

if.then.27.i:                                     ; preds = %mod.ok.26.i
  %t75.i1262 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.23.2116.i, i64 %for.x.54.0117.i)
  %t77.i1263 = extractvalue { i64, i1 } %t75.i1262, 1
  br i1 %t77.i1263, label %overflow.add.30.i, label %overflow.ok.31.i

overflow.add.30.i:                                ; preds = %if.then.27.i.1, %if.then.27.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.31.i:                                 ; preds = %if.then.27.i
  %t76.i1264 = extractvalue { i64, i1 } %t75.i1262, 0
  br label %for.step.23.i

for.step.23.i:                                    ; preds = %overflow.ok.31.i, %mod.ok.26.i
  %var.acc.23.3.i = phi i64 [ %t76.i1264, %overflow.ok.31.i ], [ %var.acc.23.2116.i, %mod.ok.26.i ]
  %t79.i1225 = or disjoint i64 %for.x.54.0117.i, 1
  %t64.lhs.trunc.i.1 = trunc nuw nsw i64 %t79.i1225 to i16
  %t6478.i.1 = urem i16 %t64.lhs.trunc.i.1, 3
  %t72.i1224.1 = icmp eq i16 %t6478.i.1, 0
  br i1 %t72.i1224.1, label %if.then.27.i.1, label %for.step.23.i.1

if.then.27.i.1:                                   ; preds = %for.step.23.i
  %t75.i1262.1 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.23.3.i, i64 %t79.i1225)
  %t77.i1263.1 = extractvalue { i64, i1 } %t75.i1262.1, 1
  br i1 %t77.i1263.1, label %overflow.add.30.i, label %overflow.ok.31.i.1

overflow.ok.31.i.1:                               ; preds = %if.then.27.i.1
  %t76.i1264.1 = extractvalue { i64, i1 } %t75.i1262.1, 0
  br label %for.step.23.i.1

for.step.23.i.1:                                  ; preds = %overflow.ok.31.i.1, %for.step.23.i
  %var.acc.23.3.i.1 = phi i64 [ %t76.i1264.1, %overflow.ok.31.i.1 ], [ %var.acc.23.3.i, %for.step.23.i ]
  %t79.i1225.1 = add nuw nsw i64 %for.x.54.0117.i, 2
  %exitcond200.not.i.1 = icmp eq i64 %t79.i1225.1, 2000
  br i1 %exitcond200.not.i.1, label %mul.ok.33.i, label %mod.ok.26.i

mul.ok.33.i:                                      ; preds = %for.step.23.i.1
  %t94.i1226 = call noalias align 16 dereferenceable_or_null(16008) ptr @malloc(i64 16008)
  %t95.i1227 = icmp eq ptr %t94.i1226, null
  br i1 %t95.i1227, label %alloc.oom.35.i, label %for.body.37.peel.next.i

for.body.37.peel.next.i:                          ; preds = %mul.ok.33.i
  store i64 0, ptr %t94.i1226, align 16
  br label %for.body.37.i

alloc.oom.35.i:                                   ; preds = %mul.ok.33.i
  call fastcc void @archx_oom_fail()
  unreachable

for.body.37.i:                                    ; preds = %push.store.43.i, %for.body.37.peel.next.i
  %for.x.100.0121.i = phi i64 [ %t149.i, %push.store.43.i ], [ 1, %for.body.37.peel.next.i ]
  %comp.out.81.sroa.8.0119.i = phi i64 [ %comp.out.81.sroa.8.1.i, %push.store.43.i ], [ 2001, %for.body.37.peel.next.i ]
  %comp.out.81.sroa.16.0118.i = phi ptr [ %comp.out.81.sroa.16.1.i, %push.store.43.i ], [ %t94.i1226, %for.body.37.peel.next.i ]
  %t105.i = shl nuw nsw i64 %for.x.100.0121.i, 1
  %t112.i1228 = icmp slt i64 %comp.out.81.sroa.8.0119.i, 0
  %t114.i1229 = call i64 @llvm.abs.i64(i64 %comp.out.81.sroa.8.0119.i, i1 true)
  %t115.not.i = icmp samesign ult i64 %for.x.100.0121.i, %t114.i1229
  br i1 %t115.not.i, label %push.store.43.i, label %push.calc.45.i

push.calc.45.i:                                   ; preds = %for.body.37.i
  %t117.i1230 = icmp eq i64 %comp.out.81.sroa.8.0119.i, 0
  %t118.i1231 = shl nuw i64 %t114.i1229, 1
  %118 = call i64 @llvm.smin.i64(i64 %t118.i1231, i64 140737488355328)
  %t121.i1232 = select i1 %t117.i1230, i64 4, i64 %118
  %119 = add i64 %t121.i1232, -1152921504606846976
  %t124.i = icmp ult i64 %119, -2305843009213693952
  br i1 %t124.i, label %mul.oom.46.i, label %mul.ok.47.i

mul.oom.46.i:                                     ; preds = %push.calc.45.i
  call fastcc void @archx_oom_fail()
  unreachable

mul.ok.47.i:                                      ; preds = %push.calc.45.i
  %t123.i1233 = shl nsw i64 %t121.i1232, 3
  %t126.i1234 = call i64 @llvm.umax.i64(i64 %t123.i1233, i64 1)
  br i1 %t112.i1228, label %mul.ok.51.i, label %push.grow.from_heap.49.i

mul.ok.51.i:                                      ; preds = %mul.ok.47.i
  %t132.i1260 = call noalias align 16 ptr @malloc(i64 %t126.i1234)
  %t133.i1261 = icmp eq ptr %t132.i1260, null
  br i1 %t133.i1261, label %alloc.oom.53.i, label %push.reg.copy.54.i

alloc.oom.53.i:                                   ; preds = %mul.ok.51.i
  call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.54.i:                               ; preds = %mul.ok.51.i
  %t128.i = shl nuw nsw i64 %for.x.100.0121.i, 3
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t132.i1260, ptr noundef nonnull align 8 dereferenceable(1) %comp.out.81.sroa.16.0118.i, i64 %t128.i, i1 false)
  br label %push.store.43.i

push.grow.from_heap.49.i:                         ; preds = %mul.ok.47.i
  %t138.i1235 = call align 16 ptr @realloc(ptr %comp.out.81.sroa.16.0118.i, i64 %t126.i1234)
  %t139.i1236 = icmp eq ptr %t138.i1235, null
  br i1 %t139.i1236, label %realloc.oom.57.i, label %push.store.43.i

realloc.oom.57.i:                                 ; preds = %push.grow.from_heap.49.i
  call fastcc void @archx_oom_fail()
  unreachable

push.store.43.i:                                  ; preds = %push.grow.from_heap.49.i, %push.reg.copy.54.i, %for.body.37.i
  %comp.out.81.sroa.16.1.i = phi ptr [ %comp.out.81.sroa.16.0118.i, %for.body.37.i ], [ %t132.i1260, %push.reg.copy.54.i ], [ %t138.i1235, %push.grow.from_heap.49.i ]
  %comp.out.81.sroa.8.1.i = phi i64 [ %comp.out.81.sroa.8.0119.i, %for.body.37.i ], [ %t121.i1232, %push.reg.copy.54.i ], [ %t121.i1232, %push.grow.from_heap.49.i ]
  %t145.i1237 = getelementptr inbounds nuw i64, ptr %comp.out.81.sroa.16.1.i, i64 %for.x.100.0121.i
  store i64 %t105.i, ptr %t145.i1237, align 8
  %t149.i = add nuw nsw i64 %for.x.100.0121.i, 1
  %exitcond201.not.i = icmp eq i64 %t149.i, 2000
  br i1 %exitcond201.not.i, label %vector.ph2060, label %for.body.37.i, !llvm.loop !12

vector.ph2060:                                    ; preds = %push.store.43.i
  %t155.i1238 = load i64, ptr %comp.out.81.sroa.16.1.i, align 8
  %broadcast.splatinsert = insertelement <2 x i64> poison, i64 %t155.i1238, i64 0
  %broadcast.splat = shufflevector <2 x i64> %broadcast.splatinsert, <2 x i64> poison, <2 x i32> zeroinitializer
  br label %vector.body2061

vector.body2061:                                  ; preds = %vector.body2061, %vector.ph2060
  %index2062 = phi i64 [ 0, %vector.ph2060 ], [ %index.next2066, %vector.body2061 ]
  %vec.phi = phi <2 x i64> [ %broadcast.splat, %vector.ph2060 ], [ %123, %vector.body2061 ]
  %vec.phi2063 = phi <2 x i64> [ %broadcast.splat, %vector.ph2060 ], [ %124, %vector.body2061 ]
  %120 = getelementptr inbounds nuw i64, ptr %comp.out.81.sroa.16.1.i, i64 %index2062
  %121 = getelementptr inbounds nuw i8, ptr %120, i64 8
  %122 = getelementptr inbounds nuw i8, ptr %120, i64 24
  %wide.load2064 = load <2 x i64>, ptr %121, align 8
  %wide.load2065 = load <2 x i64>, ptr %122, align 8
  %123 = call <2 x i64> @llvm.smax.v2i64(<2 x i64> %wide.load2064, <2 x i64> %vec.phi)
  %124 = call <2 x i64> @llvm.smax.v2i64(<2 x i64> %wide.load2065, <2 x i64> %vec.phi2063)
  %index.next2066 = add nuw i64 %index2062, 4
  %125 = icmp eq i64 %index.next2066, 1996
  br i1 %125, label %mm.body.61.i, label %vector.body2061, !llvm.loop !14

mm.body.61.i:                                     ; preds = %vector.body2061
  %rdx.minmax = call <2 x i64> @llvm.smax.v2i64(<2 x i64> %123, <2 x i64> %124)
  %126 = call i64 @llvm.vector.reduce.smax.v2i64(<2 x i64> %rdx.minmax)
  %t160.i = getelementptr inbounds nuw i8, ptr %comp.out.81.sroa.16.1.i, i64 15976
  %t161.i1239 = load i64, ptr %t160.i, align 8
  %t164.i = call i64 @llvm.smax.i64(i64 %t161.i1239, i64 %126)
  %t160.i.1 = getelementptr inbounds nuw i8, ptr %comp.out.81.sroa.16.1.i, i64 15984
  %t161.i1239.1 = load i64, ptr %t160.i.1, align 8
  %t164.i.1 = call i64 @llvm.smax.i64(i64 %t161.i1239.1, i64 %t164.i)
  %t160.i.2 = getelementptr inbounds nuw i8, ptr %comp.out.81.sroa.16.1.i, i64 15992
  %t161.i1239.2 = load i64, ptr %t160.i.2, align 8
  %t164.i.2 = call i64 @llvm.smax.i64(i64 %t161.i1239.2, i64 %t164.i.1)
  %t168.i = icmp sgt i64 %comp.out.81.sroa.8.1.i, 0
  br i1 %t168.i, label %drop.vec.free.63.i, label %drop.vec.done.64.i

drop.vec.free.63.i:                               ; preds = %mm.body.61.i
  call void @free(ptr nonnull %comp.out.81.sroa.16.1.i)
  br label %drop.vec.done.64.i

drop.vec.done.64.i:                               ; preds = %drop.vec.free.63.i, %mm.body.61.i
  %t170.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.23.3.i.1, i64 %t164.i.2)
  %t171.i = extractvalue { i64, i1 } %t170.i, 0
  %t172.i = extractvalue { i64, i1 } %t170.i, 1
  br i1 %t172.i, label %overflow.add.65.i, label %mul.ok.68.i

overflow.add.65.i:                                ; preds = %drop.vec.done.64.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

mul.ok.68.i:                                      ; preds = %drop.vec.done.64.i
  %t187.i1240 = call noalias align 16 dereferenceable_or_null(16008) ptr @malloc(i64 16008)
  %t188.i = icmp eq ptr %t187.i1240, null
  br i1 %t188.i, label %alloc.oom.70.i, label %overflow.ok.76.peel.next.i

overflow.ok.76.peel.next.i:                       ; preds = %mul.ok.68.i
  store i64 1, ptr %t187.i1240, align 16
  br label %overflow.ok.76.i

alloc.oom.70.i:                                   ; preds = %mul.ok.68.i
  call fastcc void @archx_oom_fail()
  unreachable

overflow.ok.76.i:                                 ; preds = %push.store.80.i, %overflow.ok.76.peel.next.i
  %for.x.193.0128.i = phi i64 [ %t245.i1243, %push.store.80.i ], [ 1, %overflow.ok.76.peel.next.i ]
  %comp.out.174.sroa.8.0126.i = phi i64 [ %comp.out.174.sroa.8.1.i, %push.store.80.i ], [ 2001, %overflow.ok.76.peel.next.i ]
  %comp.out.174.sroa.16.0125.i = phi ptr [ %comp.out.174.sroa.16.1.i, %push.store.80.i ], [ %t187.i1240, %overflow.ok.76.peel.next.i ]
  %t198.i = mul nuw nsw i64 %for.x.193.0128.i, 3
  %t201.i = add nuw nsw i64 %t198.i, 1
  %t208.i = icmp slt i64 %comp.out.174.sroa.8.0126.i, 0
  %t210.i = call i64 @llvm.abs.i64(i64 %comp.out.174.sroa.8.0126.i, i1 true)
  %t211.not.i = icmp samesign ult i64 %for.x.193.0128.i, %t210.i
  br i1 %t211.not.i, label %push.store.80.i, label %push.calc.82.i

push.calc.82.i:                                   ; preds = %overflow.ok.76.i
  %t213.i = icmp eq i64 %comp.out.174.sroa.8.0126.i, 0
  %t214.i1241 = shl nuw i64 %t210.i, 1
  %127 = call i64 @llvm.smin.i64(i64 %t214.i1241, i64 140737488355328)
  %t217.i = select i1 %t213.i, i64 4, i64 %127
  %128 = add i64 %t217.i, -1152921504606846976
  %t220.i = icmp ult i64 %128, -2305843009213693952
  br i1 %t220.i, label %mul.oom.83.i, label %mul.ok.84.i

mul.oom.83.i:                                     ; preds = %push.calc.82.i
  call fastcc void @archx_oom_fail()
  unreachable

mul.ok.84.i:                                      ; preds = %push.calc.82.i
  %t219.i = shl nsw i64 %t217.i, 3
  %t222.i = call i64 @llvm.umax.i64(i64 %t219.i, i64 1)
  br i1 %t208.i, label %mul.ok.88.i, label %push.grow.from_heap.86.i

mul.ok.88.i:                                      ; preds = %mul.ok.84.i
  %t228.i = call noalias align 16 ptr @malloc(i64 %t222.i)
  %t229.i = icmp eq ptr %t228.i, null
  br i1 %t229.i, label %alloc.oom.90.i, label %push.reg.copy.91.i

alloc.oom.90.i:                                   ; preds = %mul.ok.88.i
  call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.91.i:                               ; preds = %mul.ok.88.i
  %t224.i1259 = shl nuw nsw i64 %for.x.193.0128.i, 3
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t228.i, ptr noundef nonnull align 8 dereferenceable(1) %comp.out.174.sroa.16.0125.i, i64 %t224.i1259, i1 false)
  br label %push.store.80.i

push.grow.from_heap.86.i:                         ; preds = %mul.ok.84.i
  %t234.i1242 = call align 16 ptr @realloc(ptr %comp.out.174.sroa.16.0125.i, i64 %t222.i)
  %t235.i = icmp eq ptr %t234.i1242, null
  br i1 %t235.i, label %realloc.oom.94.i, label %push.store.80.i

realloc.oom.94.i:                                 ; preds = %push.grow.from_heap.86.i
  call fastcc void @archx_oom_fail()
  unreachable

push.store.80.i:                                  ; preds = %push.grow.from_heap.86.i, %push.reg.copy.91.i, %overflow.ok.76.i
  %comp.out.174.sroa.16.1.i = phi ptr [ %comp.out.174.sroa.16.0125.i, %overflow.ok.76.i ], [ %t228.i, %push.reg.copy.91.i ], [ %t234.i1242, %push.grow.from_heap.86.i ]
  %comp.out.174.sroa.8.1.i = phi i64 [ %comp.out.174.sroa.8.0126.i, %overflow.ok.76.i ], [ %t217.i, %push.reg.copy.91.i ], [ %t217.i, %push.grow.from_heap.86.i ]
  %t241.i = getelementptr inbounds nuw i64, ptr %comp.out.174.sroa.16.1.i, i64 %for.x.193.0128.i
  store i64 %t201.i, ptr %t241.i, align 8
  %t245.i1243 = add nuw nsw i64 %for.x.193.0128.i, 1
  %exitcond204.not.i = icmp eq i64 %t245.i1243, 2000
  br i1 %exitcond204.not.i, label %vector.ph2070, label %overflow.ok.76.i, !llvm.loop !15

vector.ph2070:                                    ; preds = %push.store.80.i
  %t251.i = load i64, ptr %comp.out.174.sroa.16.1.i, align 8
  %broadcast.splatinsert2071 = insertelement <2 x i64> poison, i64 %t251.i, i64 0
  %broadcast.splat2072 = shufflevector <2 x i64> %broadcast.splatinsert2071, <2 x i64> poison, <2 x i32> zeroinitializer
  br label %vector.body2073

vector.body2073:                                  ; preds = %vector.body2073, %vector.ph2070
  %index2074 = phi i64 [ 0, %vector.ph2070 ], [ %index.next2080, %vector.body2073 ]
  %vec.phi2075 = phi <2 x i64> [ %broadcast.splat2072, %vector.ph2070 ], [ %132, %vector.body2073 ]
  %vec.phi2076 = phi <2 x i64> [ %broadcast.splat2072, %vector.ph2070 ], [ %133, %vector.body2073 ]
  %129 = getelementptr inbounds nuw i64, ptr %comp.out.174.sroa.16.1.i, i64 %index2074
  %130 = getelementptr inbounds nuw i8, ptr %129, i64 8
  %131 = getelementptr inbounds nuw i8, ptr %129, i64 24
  %wide.load2078 = load <2 x i64>, ptr %130, align 8
  %wide.load2079 = load <2 x i64>, ptr %131, align 8
  %132 = call <2 x i64> @llvm.smin.v2i64(<2 x i64> %wide.load2078, <2 x i64> %vec.phi2075)
  %133 = call <2 x i64> @llvm.smin.v2i64(<2 x i64> %wide.load2079, <2 x i64> %vec.phi2076)
  %index.next2080 = add nuw i64 %index2074, 4
  %134 = icmp eq i64 %index.next2080, 1996
  br i1 %134, label %mm.body.98.i, label %vector.body2073, !llvm.loop !16

mm.body.98.i:                                     ; preds = %vector.body2073
  %rdx.minmax2082 = call <2 x i64> @llvm.smin.v2i64(<2 x i64> %132, <2 x i64> %133)
  %135 = call i64 @llvm.vector.reduce.smin.v2i64(<2 x i64> %rdx.minmax2082)
  %t256.i = getelementptr inbounds nuw i8, ptr %comp.out.174.sroa.16.1.i, i64 15976
  %t257.i = load i64, ptr %t256.i, align 8
  %t260.i = call i64 @llvm.smin.i64(i64 %t257.i, i64 %135)
  %t256.i.1 = getelementptr inbounds nuw i8, ptr %comp.out.174.sroa.16.1.i, i64 15984
  %t257.i.1 = load i64, ptr %t256.i.1, align 8
  %t260.i.1 = call i64 @llvm.smin.i64(i64 %t257.i.1, i64 %t260.i)
  %t256.i.2 = getelementptr inbounds nuw i8, ptr %comp.out.174.sroa.16.1.i, i64 15992
  %t257.i.2 = load i64, ptr %t256.i.2, align 8
  %t260.i.2 = call i64 @llvm.smin.i64(i64 %t257.i.2, i64 %t260.i.1)
  %t264.i = icmp sgt i64 %comp.out.174.sroa.8.1.i, 0
  br i1 %t264.i, label %drop.vec.free.100.i, label %drop.vec.done.101.i

drop.vec.free.100.i:                              ; preds = %mm.body.98.i
  call void @free(ptr nonnull %comp.out.174.sroa.16.1.i)
  br label %drop.vec.done.101.i

drop.vec.done.101.i:                              ; preds = %drop.vec.free.100.i, %mm.body.98.i
  %t266.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t171.i, i64 %t260.i.2)
  %t268.i1245 = extractvalue { i64, i1 } %t266.i, 1
  br i1 %t268.i1245, label %overflow.add.102.i, label %for.cond.104.preheader.i

for.cond.104.preheader.i:                         ; preds = %drop.vec.done.101.i
  %t267.i = extractvalue { i64, i1 } %t266.i, 0
  %t297.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t267.i, i64 2)
  %t299.i1246 = extractvalue { i64, i1 } %t297.i, 1
  br i1 %t299.i1246, label %overflow.add.126.i, label %repeat.ok.128.i

overflow.add.102.i:                               ; preds = %drop.vec.done.101.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.add.126.i:                               ; preds = %for.cond.104.preheader.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

repeat.ok.128.i:                                  ; preds = %for.cond.104.preheader.i
  %t303.i1247 = call noalias align 16 dereferenceable_or_null(16000) ptr @calloc(i64 2000, i64 8)
  %t304.i1248 = icmp eq ptr %t303.i1247, null
  br i1 %t304.i1248, label %calloc.oom.131.i, label %repeat.ok.132.i

calloc.oom.131.i:                                 ; preds = %repeat.ok.128.i
  call fastcc void @archx_oom_fail()
  unreachable

repeat.ok.132.i:                                  ; preds = %repeat.ok.128.i
  %t312.i = call noalias align 16 dereferenceable_or_null(16000) ptr @calloc(i64 2000, i64 8)
  %t313.i = icmp eq ptr %t312.i, null
  br i1 %t313.i, label %calloc.oom.135.i, label %vector.body2087

vector.body2087:                                  ; preds = %repeat.ok.132.i, %vector.body2087
  %index2088 = phi i64 [ %index.next2091.1, %vector.body2087 ], [ 0, %repeat.ok.132.i ]
  %vec.ind2089 = phi <2 x i64> [ %vec.ind.next2092.1, %vector.body2087 ], [ <i64 0, i64 1>, %repeat.ok.132.i ]
  %step.add2090 = add <2 x i64> %vec.ind2089, splat (i64 2)
  %136 = getelementptr inbounds nuw i64, ptr %t303.i1247, i64 %index2088
  %137 = getelementptr inbounds nuw i8, ptr %136, i64 16
  store <2 x i64> %vec.ind2089, ptr %136, align 16
  store <2 x i64> %step.add2090, ptr %137, align 16
  %138 = sub nuw nsw <2 x i64> splat (i64 2000), %vec.ind2089
  %139 = sub <2 x i64> splat (i64 1998), %vec.ind2089
  %140 = getelementptr inbounds nuw i64, ptr %t312.i, i64 %index2088
  %141 = getelementptr inbounds nuw i8, ptr %140, i64 16
  store <2 x i64> %138, ptr %140, align 16
  store <2 x i64> %139, ptr %141, align 16
  %index.next2091 = or disjoint i64 %index2088, 4
  %vec.ind.next2092 = add <2 x i64> %vec.ind2089, splat (i64 4)
  %step.add2090.1 = add <2 x i64> %vec.ind2089, splat (i64 6)
  %142 = getelementptr inbounds nuw i64, ptr %t303.i1247, i64 %index.next2091
  %143 = getelementptr inbounds nuw i8, ptr %142, i64 16
  store <2 x i64> %vec.ind.next2092, ptr %142, align 16
  store <2 x i64> %step.add2090.1, ptr %143, align 16
  %144 = sub <2 x i64> splat (i64 1996), %vec.ind2089
  %145 = sub <2 x i64> splat (i64 1994), %vec.ind2089
  %146 = getelementptr inbounds nuw i64, ptr %t312.i, i64 %index.next2091
  %147 = getelementptr inbounds nuw i8, ptr %146, i64 16
  store <2 x i64> %144, ptr %146, align 16
  store <2 x i64> %145, ptr %147, align 16
  %index.next2091.1 = add nuw nsw i64 %index2088, 8
  %vec.ind.next2092.1 = add <2 x i64> %vec.ind2089, splat (i64 8)
  %148 = icmp eq i64 %index.next2091.1, 2000
  br i1 %148, label %zip.cond.142.preheader.i, label %vector.body2087, !llvm.loop !17

calloc.oom.135.i:                                 ; preds = %repeat.ok.132.i
  call fastcc void @archx_oom_fail()
  unreachable

zip.cond.142.preheader.i:                         ; preds = %vector.body2087
  %var.acc.23.6134.i = extractvalue { i64, i1 } %t297.i, 0
  br label %zip.body.143.i

zip.cond.142.i:                                   ; preds = %overflow.ok.147.i
  %t355.i = or disjoint i64 %zip.idx.341.0135.i, 1
  %t344.i1249.1 = getelementptr inbounds nuw i64, ptr %t303.i1247, i64 %t355.i
  %t345.i.1 = load i64, ptr %t344.i1249.1, align 8
  %t346.i1250.1 = getelementptr inbounds nuw i64, ptr %t312.i, i64 %t355.i
  %t347.i.1 = load i64, ptr %t346.i1250.1, align 8
  %t349.i.1 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t345.i.1, i64 %t347.i.1)
  %t351.i.1 = extractvalue { i64, i1 } %t349.i.1, 1
  br i1 %t351.i.1, label %overflow.mul.146.i, label %overflow.ok.147.i.1

overflow.ok.147.i.1:                              ; preds = %zip.cond.142.i
  %var.acc.23.6.i = extractvalue { i64, i1 } %t352.i, 0
  %t350.i1251.1 = extractvalue { i64, i1 } %t349.i.1, 0
  %t352.i.1 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.23.6.i, i64 %t350.i1251.1)
  %t354.i.1 = extractvalue { i64, i1 } %t352.i.1, 1
  br i1 %t354.i.1, label %overflow.add.148.i, label %zip.cond.142.i.1

zip.cond.142.i.1:                                 ; preds = %overflow.ok.147.i.1
  %t355.i.1 = add nuw nsw i64 %zip.idx.341.0135.i, 2
  %var.acc.23.6.i.1 = extractvalue { i64, i1 } %t352.i.1, 0
  %exitcond208.not.i.1 = icmp eq i64 %t355.i.1, 2000
  br i1 %exitcond208.not.i.1, label %repeat.ok.150.i, label %zip.body.143.i

zip.body.143.i:                                   ; preds = %zip.cond.142.i.1, %zip.cond.142.preheader.i
  %var.acc.23.6136.i = phi i64 [ %var.acc.23.6134.i, %zip.cond.142.preheader.i ], [ %var.acc.23.6.i.1, %zip.cond.142.i.1 ]
  %zip.idx.341.0135.i = phi i64 [ 0, %zip.cond.142.preheader.i ], [ %t355.i.1, %zip.cond.142.i.1 ]
  %t344.i1249 = getelementptr inbounds nuw i64, ptr %t303.i1247, i64 %zip.idx.341.0135.i
  %t345.i = load i64, ptr %t344.i1249, align 16
  %t346.i1250 = getelementptr inbounds nuw i64, ptr %t312.i, i64 %zip.idx.341.0135.i
  %t347.i = load i64, ptr %t346.i1250, align 16
  %t349.i = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t345.i, i64 %t347.i)
  %t351.i = extractvalue { i64, i1 } %t349.i, 1
  br i1 %t351.i, label %overflow.mul.146.i, label %overflow.ok.147.i

overflow.mul.146.i:                               ; preds = %zip.cond.142.i, %zip.body.143.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.147.i:                                ; preds = %zip.body.143.i
  %t350.i1251 = extractvalue { i64, i1 } %t349.i, 0
  %t352.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.23.6136.i, i64 %t350.i1251)
  %t354.i = extractvalue { i64, i1 } %t352.i, 1
  br i1 %t354.i, label %overflow.add.148.i, label %zip.cond.142.i

overflow.add.148.i:                               ; preds = %overflow.ok.147.i.1, %overflow.ok.147.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

repeat.ok.150.i:                                  ; preds = %zip.cond.142.i.1
  %t359.i = call noalias align 16 dereferenceable_or_null(16000) ptr @calloc(i64 2000, i64 8)
  %t360.i = icmp eq ptr %t359.i, null
  br i1 %t360.i, label %calloc.oom.153.i, label %for.body.155.i

calloc.oom.153.i:                                 ; preds = %repeat.ok.150.i
  call fastcc void @archx_oom_fail()
  unreachable

for.body.155.i:                                   ; preds = %repeat.ok.150.i, %for.body.155.i
  %for.i.365.0137.i = phi i64 [ %t390.i.1, %for.body.155.i ], [ 0, %repeat.ok.150.i ]
  %t371.i = getelementptr inbounds nuw i64, ptr %t359.i, i64 %for.i.365.0137.i
  %149 = trunc nuw nsw i64 %for.i.365.0137.i to i32
  %t381.lhs.trunc.i = mul nuw nsw i32 %149, 37
  %t38179.i = urem i32 %t381.lhs.trunc.i, 997
  %t381.zext.i = zext nneg i32 %t38179.i to i64
  store i64 %t381.zext.i, ptr %t371.i, align 16
  %t390.i = or disjoint i64 %for.i.365.0137.i, 1
  %t371.i.1 = getelementptr inbounds nuw i64, ptr %t359.i, i64 %t390.i
  %150 = trunc nuw nsw i64 %t390.i to i32
  %t381.lhs.trunc.i.1 = mul nuw nsw i32 %150, 37
  %t38179.i.1 = urem i32 %t381.lhs.trunc.i.1, 997
  %t381.zext.i.1 = zext nneg i32 %t38179.i.1 to i64
  store i64 %t381.zext.i.1, ptr %t371.i.1, align 8
  %t390.i.1 = add nuw nsw i64 %for.i.365.0137.i, 2
  %exitcond209.not.i.1 = icmp eq i64 %t390.i.1, 2000
  br i1 %exitcond209.not.i.1, label %mul.ok.163.i, label %for.body.155.i

mul.ok.163.i:                                     ; preds = %for.body.155.i
  %t398.i = call noalias align 16 dereferenceable_or_null(16000) ptr @malloc(i64 16000)
  %t399.i = icmp eq ptr %t398.i, null
  br i1 %t399.i, label %alloc.oom.165.i, label %alloc.ok.164.i

alloc.oom.165.i:                                  ; preds = %mul.ok.163.i
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.164.i:                                   ; preds = %mul.ok.163.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16000) %t398.i, ptr noundef nonnull align 16 dereferenceable(16000) %t359.i, i64 16000, i1 false)
  %t407.i = call noalias align 16 dereferenceable_or_null(16000) ptr @malloc(i64 16000)
  %t408.i = icmp eq ptr %t407.i, null
  br i1 %t408.i, label %alloc.oom.169.i, label %alloc.ok.168.i

alloc.oom.169.i:                                  ; preds = %alloc.ok.164.i
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.168.i:                                   ; preds = %alloc.ok.164.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16000) %t407.i, ptr noundef nonnull align 16 dereferenceable(16000) %t359.i, i64 16000, i1 false)
  br label %sort.ins.outer.body.171.i

sort.ins.outer.170.loopexit.i:                    ; preds = %sort.ins.place.179.i, %sort.ins.outer.body.171.i
  %t411.i = icmp slt i64 %sort.ins.run.409.0145.i, 1984
  br i1 %t411.i, label %sort.ins.outer.body.171.i, label %sort.pass.body.182.i

sort.ins.outer.body.171.i:                        ; preds = %sort.ins.outer.170.loopexit.i, %alloc.ok.168.i
  %sort.ins.run.409.0145.i = phi i64 [ 0, %alloc.ok.168.i ], [ %t414.i, %sort.ins.outer.170.loopexit.i ]
  %151 = call i64 @llvm.smin.i64(i64 %sort.ins.run.409.0145.i, i64 1984)
  %t414.i = add nsw i64 %151, 16
  %sort.ins.i.415.0142.i = add nsw i64 %sort.ins.run.409.0145.i, 1
  %t418143.i = icmp slt i64 %sort.ins.i.415.0142.i, %t414.i
  br i1 %t418143.i, label %sort.ins.body.174.i, label %sort.ins.outer.170.loopexit.i

sort.ins.body.174.i:                              ; preds = %sort.ins.outer.body.171.i, %sort.ins.place.179.i
  %sort.ins.i.415.0144.i = phi i64 [ %sort.ins.i.415.0.i, %sort.ins.place.179.i ], [ %sort.ins.i.415.0142.i, %sort.ins.outer.body.171.i ]
  %t420.i1253 = shl nuw nsw i64 %sort.ins.i.415.0144.i, 3
  %t421.i1254 = getelementptr inbounds nuw i8, ptr %t407.i, i64 %t420.i1253
  %sort.tmp.419.sroa.0.0.copyload32.i = load i64, ptr %t421.i1254, align 8
  %t424.not138.i = icmp sgt i64 %sort.ins.i.415.0144.i, %sort.ins.run.409.0145.i
  br i1 %t424.not138.i, label %sort.ins.check.177.i, label %sort.ins.place.179.i

sort.ins.check.177.i:                             ; preds = %sort.ins.body.174.i, %sort.ins.shift.178.i
  %sort.ins.j.422.0139.i = phi i64 [ %t425.i, %sort.ins.shift.178.i ], [ %sort.ins.i.415.0144.i, %sort.ins.body.174.i ]
  %t425.i = add nsw i64 %sort.ins.j.422.0139.i, -1
  %t426.i1255 = shl nuw nsw i64 %t425.i, 3
  %t427.i1256 = getelementptr inbounds nuw i8, ptr %t407.i, i64 %t426.i1255
  %t431.i1257 = load i64, ptr %t427.i1256, align 8
  %t432.not.i = icmp slt i64 %sort.tmp.419.sroa.0.0.copyload32.i, %t431.i1257
  br i1 %t432.not.i, label %sort.ins.shift.178.i, label %sort.ins.place.179.loopexit.i

sort.ins.shift.178.i:                             ; preds = %sort.ins.check.177.i
  %t434.i = shl nuw nsw i64 %sort.ins.j.422.0139.i, 3
  %t435.i = getelementptr inbounds nuw i8, ptr %t407.i, i64 %t434.i
  store i64 %t431.i1257, ptr %t435.i, align 8
  %t424.not.i = icmp sgt i64 %t425.i, %sort.ins.run.409.0145.i
  br i1 %t424.not.i, label %sort.ins.check.177.i, label %sort.ins.place.179.loopexit.i

sort.ins.place.179.loopexit.i:                    ; preds = %sort.ins.shift.178.i, %sort.ins.check.177.i
  %sort.ins.j.422.0.lcssa.ph.i = phi i64 [ %sort.ins.run.409.0145.i, %sort.ins.shift.178.i ], [ %sort.ins.j.422.0139.i, %sort.ins.check.177.i ]
  %.pre.i1258 = shl nuw nsw i64 %sort.ins.j.422.0.lcssa.ph.i, 3
  br label %sort.ins.place.179.i

sort.ins.place.179.i:                             ; preds = %sort.ins.place.179.loopexit.i, %sort.ins.body.174.i
  %t437.pre-phi.i = phi i64 [ %.pre.i1258, %sort.ins.place.179.loopexit.i ], [ %t420.i1253, %sort.ins.body.174.i ]
  %t438.i = getelementptr inbounds nuw i8, ptr %t407.i, i64 %t437.pre-phi.i
  store i64 %sort.tmp.419.sroa.0.0.copyload32.i, ptr %t438.i, align 8
  %sort.ins.i.415.0.i = add nsw i64 %sort.ins.i.415.0144.i, 1
  %exitcond210.not.i = icmp eq i64 %sort.ins.i.415.0.i, %t414.i
  br i1 %exitcond210.not.i, label %sort.ins.outer.170.loopexit.i, label %sort.ins.body.174.i

sort.pass.body.182.i:                             ; preds = %sort.ins.outer.170.loopexit.i, %sort.run.done.189.i
  %sort.flip.442.0148.i = phi i1 [ %t525.i, %sort.run.done.189.i ], [ true, %sort.ins.outer.170.loopexit.i ]
  %sort.width.441.0147.i = phi i64 [ %invariant.op.i1252, %sort.run.done.189.i ], [ 16, %sort.ins.outer.170.loopexit.i ]
  %t446.i = select i1 %sort.flip.442.0148.i, ptr %t407.i, ptr %t398.i
  %t447.i = select i1 %sort.flip.442.0148.i, ptr %t398.i, ptr %t407.i
  %invariant.op.i1252 = shl i64 %sort.width.441.0147.i, 1
  br label %sort.run.body.187.i

sort.run.body.187.i:                              ; preds = %sort.run.next.188.i, %sort.pass.body.182.i
  %sort.lo.448.0146.i = phi i64 [ 0, %sort.pass.body.182.i ], [ %t454.reass.i, %sort.run.next.188.i ]
  %t451.i = add nuw nsw i64 %sort.lo.448.0146.i, %sort.width.441.0147.i
  %t453.i = call i64 @llvm.smin.i64(i64 %t451.i, i64 2000)
  %t454.reass.i = add nuw nsw i64 %sort.lo.448.0146.i, %invariant.op.i1252
  %t456.i = call i64 @llvm.smin.i64(i64 %t454.reass.i, i64 2000)
  br label %sort.m.head.190.i

sort.m.head.190.i:                                ; preds = %sort.m.store.194.i, %sort.run.body.187.i
  %sort.m.i.457.0.i = phi i64 [ %sort.lo.448.0146.i, %sort.run.body.187.i ], [ %sort.m.i.457.1.i, %sort.m.store.194.i ]
  %sort.m.j.458.0.i = phi i64 [ %t453.i, %sort.run.body.187.i ], [ %sort.m.j.458.1.i, %sort.m.store.194.i ]
  %sort.m.k.459.0.i = phi i64 [ %sort.lo.448.0146.i, %sort.run.body.187.i ], [ %t507.i, %sort.m.store.194.i ]
  %t463.i = icmp samesign uge i64 %sort.m.k.459.0.i, %t456.i
  %t464.i = icmp sge i64 %sort.m.i.457.0.i, %t453.i
  %t465.i = icmp sge i64 %sort.m.j.458.0.i, %t456.i
  %t466.i = or i1 %t464.i, %t463.i
  %t467.i = or i1 %t465.i, %t466.i
  br i1 %t467.i, label %sort.m.drain.195.i, label %sort.m.cmp.191.i

sort.m.cmp.191.i:                                 ; preds = %sort.m.head.190.i
  %t468.i = shl nuw nsw i64 %sort.m.i.457.0.i, 3
  %t469.i = getelementptr inbounds nuw i8, ptr %t446.i, i64 %t468.i
  %t471.i = load i64, ptr %t469.i, align 8
  %t472.i = shl nuw nsw i64 %sort.m.j.458.0.i, 3
  %t473.i = getelementptr inbounds nuw i8, ptr %t446.i, i64 %t472.i
  %t475.i = load i64, ptr %t473.i, align 8
  %t476.i = icmp slt i64 %t475.i, %t471.i
  %t484.i = shl nuw nsw i64 %sort.m.k.459.0.i, 3
  %t485.i = getelementptr inbounds nuw i8, ptr %t447.i, i64 %t484.i
  br i1 %t476.i, label %sort.m.r.192.i, label %sort.m.l.193.i

sort.m.l.193.i:                                   ; preds = %sort.m.cmp.191.i
  store i64 %t471.i, ptr %t485.i, align 8
  %t481.i = add nsw i64 %sort.m.i.457.0.i, 1
  br label %sort.m.store.194.i

sort.m.r.192.i:                                   ; preds = %sort.m.cmp.191.i
  store i64 %t475.i, ptr %t485.i, align 8
  %t486.i = add nsw i64 %sort.m.j.458.0.i, 1
  br label %sort.m.store.194.i

sort.m.drain.195.i:                               ; preds = %sort.m.head.190.i
  %t489.not.i = or i1 %t464.i, %t465.i
  br i1 %t489.not.i, label %sort.m.end2.200.i, label %sort.m.cmp2.199.i

sort.m.cmp2.199.i:                                ; preds = %sort.m.drain.195.i
  %t492.i = shl nuw nsw i64 %sort.m.i.457.0.i, 3
  %t493.i = getelementptr inbounds nuw i8, ptr %t446.i, i64 %t492.i
  %t495.i = load i64, ptr %t493.i, align 8
  %t496.i = shl nuw nsw i64 %sort.m.j.458.0.i, 3
  %t497.i = getelementptr inbounds nuw i8, ptr %t446.i, i64 %t496.i
  %t499.i = load i64, ptr %t497.i, align 8
  %t500.i = icmp slt i64 %t499.i, %t495.i
  %t504.i = shl nuw nsw i64 %sort.m.k.459.0.i, 3
  %t505.i = getelementptr inbounds nuw i8, ptr %t447.i, i64 %t504.i
  br i1 %t500.i, label %sort.m.r2.196.i, label %sort.m.l2.197.i

sort.m.l2.197.i:                                  ; preds = %sort.m.cmp2.199.i
  store i64 %t495.i, ptr %t505.i, align 8
  %t503.i = add nsw i64 %sort.m.i.457.0.i, 1
  br label %sort.m.store.194.i

sort.m.r2.196.i:                                  ; preds = %sort.m.cmp2.199.i
  store i64 %t499.i, ptr %t505.i, align 8
  %t506.i = add nsw i64 %sort.m.j.458.0.i, 1
  br label %sort.m.store.194.i

sort.m.store.194.i:                               ; preds = %sort.m.r2.196.i, %sort.m.l2.197.i, %sort.m.r.192.i, %sort.m.l.193.i
  %sort.m.i.457.1.i = phi i64 [ %sort.m.i.457.0.i, %sort.m.r2.196.i ], [ %t503.i, %sort.m.l2.197.i ], [ %sort.m.i.457.0.i, %sort.m.r.192.i ], [ %t481.i, %sort.m.l.193.i ]
  %sort.m.j.458.1.i = phi i64 [ %t506.i, %sort.m.r2.196.i ], [ %sort.m.j.458.0.i, %sort.m.l2.197.i ], [ %t486.i, %sort.m.r.192.i ], [ %sort.m.j.458.0.i, %sort.m.l.193.i ]
  %t507.i = add nuw nsw i64 %sort.m.k.459.0.i, 1
  br label %sort.m.head.190.i

sort.m.end2.200.i:                                ; preds = %sort.m.drain.195.i
  br i1 %t464.i, label %sort.m.tail.r.202.i, label %sort.cpy.204.i

sort.cpy.204.i:                                   ; preds = %sort.m.end2.200.i
  %t508.i = sub nsw i64 %t453.i, %sort.m.i.457.0.i
  br label %sort.run.next.188.sink.split.i

sort.m.tail.r.202.i:                              ; preds = %sort.m.end2.200.i
  %t521.not.i = icmp eq i64 %t456.i, %sort.m.j.458.0.i
  br i1 %t521.not.i, label %sort.run.next.188.i, label %sort.cpy.206.i

sort.cpy.206.i:                                   ; preds = %sort.m.tail.r.202.i
  %t515.i = sub nsw i64 %t456.i, %sort.m.j.458.0.i
  br label %sort.run.next.188.sink.split.i

sort.run.next.188.sink.split.i:                   ; preds = %sort.cpy.206.i, %sort.cpy.204.i
  %t515.sink.i = phi i64 [ %t515.i, %sort.cpy.206.i ], [ %t508.i, %sort.cpy.204.i ]
  %sort.m.j.458.0.sink.i = phi i64 [ %sort.m.j.458.0.i, %sort.cpy.206.i ], [ %sort.m.i.457.0.i, %sort.cpy.204.i ]
  %t520.i = shl nuw nsw i64 %t515.sink.i, 3
  %t518.i = shl nuw nsw i64 %sort.m.k.459.0.i, 3
  %t519.i = getelementptr inbounds nuw i8, ptr %t447.i, i64 %t518.i
  %t516.i = shl nuw nsw i64 %sort.m.j.458.0.sink.i, 3
  %t517.i = getelementptr inbounds nuw i8, ptr %t446.i, i64 %t516.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %t519.i, ptr nonnull align 8 %t517.i, i64 %t520.i, i1 false)
  br label %sort.run.next.188.i

sort.run.next.188.i:                              ; preds = %sort.run.next.188.sink.split.i, %sort.m.tail.r.202.i
  %t450.i = icmp samesign ult i64 %t454.reass.i, 2000
  br i1 %t450.i, label %sort.run.body.187.i, label %sort.run.done.189.i

sort.run.done.189.i:                              ; preds = %sort.run.next.188.i
  %t525.i = xor i1 %sort.flip.442.0148.i, true
  %t444.i = icmp ult i64 %sort.width.441.0147.i, 1000
  br i1 %t444.i, label %sort.pass.body.182.i, label %sort.finish.185.i

sort.finish.185.i:                                ; preds = %sort.run.done.189.i
  call void @free(ptr %t407.i)
  %t536.i = call noalias align 16 dereferenceable_or_null(16000) ptr @malloc(i64 16000)
  %t537.i = icmp eq ptr %t536.i, null
  br i1 %t537.i, label %alloc.oom.211.i, label %alloc.ok.210.i

alloc.oom.211.i:                                  ; preds = %sort.finish.185.i
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.210.i:                                   ; preds = %sort.finish.185.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16000) %t536.i, ptr noundef nonnull align 16 dereferenceable(16000) %t359.i, i64 16000, i1 false)
  %t545.i = call noalias align 16 dereferenceable_or_null(16000) ptr @malloc(i64 16000)
  %t546.i = icmp eq ptr %t545.i, null
  br i1 %t546.i, label %alloc.oom.215.i, label %alloc.ok.214.i

alloc.oom.215.i:                                  ; preds = %alloc.ok.210.i
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.214.i:                                   ; preds = %alloc.ok.210.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16000) %t545.i, ptr noundef nonnull align 16 dereferenceable(16000) %t359.i, i64 16000, i1 false)
  br label %sort.ins.outer.body.217.i

sort.ins.outer.216.loopexit.i:                    ; preds = %sort.ins.place.225.i, %sort.ins.outer.body.217.i
  %t549.i = icmp slt i64 %sort.ins.run.547.0156.i, 1984
  br i1 %t549.i, label %sort.ins.outer.body.217.i, label %sort.pass.body.228.i

sort.ins.outer.body.217.i:                        ; preds = %sort.ins.outer.216.loopexit.i, %alloc.ok.214.i
  %sort.ins.run.547.0156.i = phi i64 [ 0, %alloc.ok.214.i ], [ %t552.i, %sort.ins.outer.216.loopexit.i ]
  %152 = call i64 @llvm.smin.i64(i64 %sort.ins.run.547.0156.i, i64 1984)
  %t552.i = add nsw i64 %152, 16
  %sort.ins.i.553.0153.i = add nsw i64 %sort.ins.run.547.0156.i, 1
  %t556154.i = icmp slt i64 %sort.ins.i.553.0153.i, %t552.i
  br i1 %t556154.i, label %sort.ins.body.220.i, label %sort.ins.outer.216.loopexit.i

sort.ins.body.220.i:                              ; preds = %sort.ins.outer.body.217.i, %sort.ins.place.225.i
  %sort.ins.i.553.0155.i = phi i64 [ %sort.ins.i.553.0.i, %sort.ins.place.225.i ], [ %sort.ins.i.553.0153.i, %sort.ins.outer.body.217.i ]
  %t557.i = shl nuw nsw i64 %sort.ins.i.553.0155.i, 3
  %t558.i = getelementptr inbounds nuw i8, ptr %t545.i, i64 %t557.i
  %sort.tmp.419.sroa.0.0.copyload34.i = load i64, ptr %t558.i, align 8
  %t561.not149.i = icmp sgt i64 %sort.ins.i.553.0155.i, %sort.ins.run.547.0156.i
  br i1 %t561.not149.i, label %sort.ins.check.223.i, label %sort.ins.place.225.i

sort.ins.check.223.i:                             ; preds = %sort.ins.body.220.i, %sort.ins.shift.224.i
  %sort.ins.j.559.0150.i = phi i64 [ %t562.i, %sort.ins.shift.224.i ], [ %sort.ins.i.553.0155.i, %sort.ins.body.220.i ]
  %t562.i = add nsw i64 %sort.ins.j.559.0150.i, -1
  %t563.i = shl nuw nsw i64 %t562.i, 3
  %t564.i = getelementptr inbounds nuw i8, ptr %t545.i, i64 %t563.i
  %t568.i = load i64, ptr %t564.i, align 8
  %t569.not.i = icmp sgt i64 %sort.tmp.419.sroa.0.0.copyload34.i, %t568.i
  br i1 %t569.not.i, label %sort.ins.shift.224.i, label %sort.ins.place.225.loopexit.i

sort.ins.shift.224.i:                             ; preds = %sort.ins.check.223.i
  %t571.i = shl nuw nsw i64 %sort.ins.j.559.0150.i, 3
  %t572.i = getelementptr inbounds nuw i8, ptr %t545.i, i64 %t571.i
  store i64 %t568.i, ptr %t572.i, align 8
  %t561.not.i = icmp sgt i64 %t562.i, %sort.ins.run.547.0156.i
  br i1 %t561.not.i, label %sort.ins.check.223.i, label %sort.ins.place.225.loopexit.i

sort.ins.place.225.loopexit.i:                    ; preds = %sort.ins.shift.224.i, %sort.ins.check.223.i
  %sort.ins.j.559.0.lcssa.ph.i = phi i64 [ %sort.ins.run.547.0156.i, %sort.ins.shift.224.i ], [ %sort.ins.j.559.0150.i, %sort.ins.check.223.i ]
  %.pre218.i = shl nuw nsw i64 %sort.ins.j.559.0.lcssa.ph.i, 3
  br label %sort.ins.place.225.i

sort.ins.place.225.i:                             ; preds = %sort.ins.place.225.loopexit.i, %sort.ins.body.220.i
  %t574.pre-phi.i = phi i64 [ %.pre218.i, %sort.ins.place.225.loopexit.i ], [ %t557.i, %sort.ins.body.220.i ]
  %t575.i = getelementptr inbounds nuw i8, ptr %t545.i, i64 %t574.pre-phi.i
  store i64 %sort.tmp.419.sroa.0.0.copyload34.i, ptr %t575.i, align 8
  %sort.ins.i.553.0.i = add nsw i64 %sort.ins.i.553.0155.i, 1
  %exitcond211.not.i = icmp eq i64 %sort.ins.i.553.0.i, %t552.i
  br i1 %exitcond211.not.i, label %sort.ins.outer.216.loopexit.i, label %sort.ins.body.220.i

sort.pass.body.228.i:                             ; preds = %sort.ins.outer.216.loopexit.i, %sort.run.done.235.i
  %sort.flip.579.0160.i = phi i1 [ %t662.i, %sort.run.done.235.i ], [ true, %sort.ins.outer.216.loopexit.i ]
  %sort.width.578.0159.i = phi i64 [ %invariant.op157.i, %sort.run.done.235.i ], [ 16, %sort.ins.outer.216.loopexit.i ]
  %t583.i = select i1 %sort.flip.579.0160.i, ptr %t545.i, ptr %t536.i
  %t584.i = select i1 %sort.flip.579.0160.i, ptr %t536.i, ptr %t545.i
  %invariant.op157.i = shl i64 %sort.width.578.0159.i, 1
  br label %sort.run.body.233.i

sort.run.body.233.i:                              ; preds = %sort.run.next.234.i, %sort.pass.body.228.i
  %sort.lo.585.0158.i = phi i64 [ 0, %sort.pass.body.228.i ], [ %t591.reass.i, %sort.run.next.234.i ]
  %t588.i = add nuw nsw i64 %sort.lo.585.0158.i, %sort.width.578.0159.i
  %t590.i = call i64 @llvm.smin.i64(i64 %t588.i, i64 2000)
  %t591.reass.i = add nuw nsw i64 %sort.lo.585.0158.i, %invariant.op157.i
  %t593.i = call i64 @llvm.smin.i64(i64 %t591.reass.i, i64 2000)
  br label %sort.m.head.236.i

sort.m.head.236.i:                                ; preds = %sort.m.store.240.i, %sort.run.body.233.i
  %sort.m.i.594.0.i = phi i64 [ %sort.lo.585.0158.i, %sort.run.body.233.i ], [ %sort.m.i.594.1.i, %sort.m.store.240.i ]
  %sort.m.j.595.0.i = phi i64 [ %t590.i, %sort.run.body.233.i ], [ %sort.m.j.595.1.i, %sort.m.store.240.i ]
  %sort.m.k.596.0.i = phi i64 [ %sort.lo.585.0158.i, %sort.run.body.233.i ], [ %t644.i, %sort.m.store.240.i ]
  %t600.i = icmp samesign uge i64 %sort.m.k.596.0.i, %t593.i
  %t601.i = icmp sge i64 %sort.m.i.594.0.i, %t590.i
  %t602.i = icmp sge i64 %sort.m.j.595.0.i, %t593.i
  %t603.i = or i1 %t601.i, %t600.i
  %t604.i = or i1 %t602.i, %t603.i
  br i1 %t604.i, label %sort.m.drain.241.i, label %sort.m.cmp.237.i

sort.m.cmp.237.i:                                 ; preds = %sort.m.head.236.i
  %t605.i = shl nuw nsw i64 %sort.m.i.594.0.i, 3
  %t606.i = getelementptr inbounds nuw i8, ptr %t583.i, i64 %t605.i
  %t608.i = load i64, ptr %t606.i, align 8
  %t609.i = shl nuw nsw i64 %sort.m.j.595.0.i, 3
  %t610.i = getelementptr inbounds nuw i8, ptr %t583.i, i64 %t609.i
  %t612.i = load i64, ptr %t610.i, align 8
  %t613.i = icmp sgt i64 %t612.i, %t608.i
  %t621.i = shl nuw nsw i64 %sort.m.k.596.0.i, 3
  %t622.i = getelementptr inbounds nuw i8, ptr %t584.i, i64 %t621.i
  br i1 %t613.i, label %sort.m.r.238.i, label %sort.m.l.239.i

sort.m.l.239.i:                                   ; preds = %sort.m.cmp.237.i
  store i64 %t608.i, ptr %t622.i, align 8
  %t618.i = add nsw i64 %sort.m.i.594.0.i, 1
  br label %sort.m.store.240.i

sort.m.r.238.i:                                   ; preds = %sort.m.cmp.237.i
  store i64 %t612.i, ptr %t622.i, align 8
  %t623.i = add nsw i64 %sort.m.j.595.0.i, 1
  br label %sort.m.store.240.i

sort.m.drain.241.i:                               ; preds = %sort.m.head.236.i
  %t626.not.i = or i1 %t601.i, %t602.i
  br i1 %t626.not.i, label %sort.m.end2.246.i, label %sort.m.cmp2.245.i

sort.m.cmp2.245.i:                                ; preds = %sort.m.drain.241.i
  %t629.i = shl nuw nsw i64 %sort.m.i.594.0.i, 3
  %t630.i = getelementptr inbounds nuw i8, ptr %t583.i, i64 %t629.i
  %t632.i = load i64, ptr %t630.i, align 8
  %t633.i = shl nuw nsw i64 %sort.m.j.595.0.i, 3
  %t634.i = getelementptr inbounds nuw i8, ptr %t583.i, i64 %t633.i
  %t636.i = load i64, ptr %t634.i, align 8
  %t637.i = icmp sgt i64 %t636.i, %t632.i
  %t641.i = shl nuw nsw i64 %sort.m.k.596.0.i, 3
  %t642.i = getelementptr inbounds nuw i8, ptr %t584.i, i64 %t641.i
  br i1 %t637.i, label %sort.m.r2.242.i, label %sort.m.l2.243.i

sort.m.l2.243.i:                                  ; preds = %sort.m.cmp2.245.i
  store i64 %t632.i, ptr %t642.i, align 8
  %t640.i = add nsw i64 %sort.m.i.594.0.i, 1
  br label %sort.m.store.240.i

sort.m.r2.242.i:                                  ; preds = %sort.m.cmp2.245.i
  store i64 %t636.i, ptr %t642.i, align 8
  %t643.i = add nsw i64 %sort.m.j.595.0.i, 1
  br label %sort.m.store.240.i

sort.m.store.240.i:                               ; preds = %sort.m.r2.242.i, %sort.m.l2.243.i, %sort.m.r.238.i, %sort.m.l.239.i
  %sort.m.i.594.1.i = phi i64 [ %sort.m.i.594.0.i, %sort.m.r2.242.i ], [ %t640.i, %sort.m.l2.243.i ], [ %sort.m.i.594.0.i, %sort.m.r.238.i ], [ %t618.i, %sort.m.l.239.i ]
  %sort.m.j.595.1.i = phi i64 [ %t643.i, %sort.m.r2.242.i ], [ %sort.m.j.595.0.i, %sort.m.l2.243.i ], [ %t623.i, %sort.m.r.238.i ], [ %sort.m.j.595.0.i, %sort.m.l.239.i ]
  %t644.i = add nuw nsw i64 %sort.m.k.596.0.i, 1
  br label %sort.m.head.236.i

sort.m.end2.246.i:                                ; preds = %sort.m.drain.241.i
  br i1 %t601.i, label %sort.m.tail.r.248.i, label %sort.cpy.250.i

sort.cpy.250.i:                                   ; preds = %sort.m.end2.246.i
  %t645.i = sub nsw i64 %t590.i, %sort.m.i.594.0.i
  br label %sort.run.next.234.sink.split.i

sort.m.tail.r.248.i:                              ; preds = %sort.m.end2.246.i
  %t658.not.i = icmp eq i64 %t593.i, %sort.m.j.595.0.i
  br i1 %t658.not.i, label %sort.run.next.234.i, label %sort.cpy.252.i

sort.cpy.252.i:                                   ; preds = %sort.m.tail.r.248.i
  %t652.i = sub nsw i64 %t593.i, %sort.m.j.595.0.i
  br label %sort.run.next.234.sink.split.i

sort.run.next.234.sink.split.i:                   ; preds = %sort.cpy.252.i, %sort.cpy.250.i
  %t652.sink.i = phi i64 [ %t652.i, %sort.cpy.252.i ], [ %t645.i, %sort.cpy.250.i ]
  %sort.m.j.595.0.sink.i = phi i64 [ %sort.m.j.595.0.i, %sort.cpy.252.i ], [ %sort.m.i.594.0.i, %sort.cpy.250.i ]
  %t657.i = shl nuw nsw i64 %t652.sink.i, 3
  %t655.i = shl nuw nsw i64 %sort.m.k.596.0.i, 3
  %t656.i = getelementptr inbounds nuw i8, ptr %t584.i, i64 %t655.i
  %t653.i = shl nuw nsw i64 %sort.m.j.595.0.sink.i, 3
  %t654.i = getelementptr inbounds nuw i8, ptr %t583.i, i64 %t653.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %t656.i, ptr nonnull align 8 %t654.i, i64 %t657.i, i1 false)
  br label %sort.run.next.234.i

sort.run.next.234.i:                              ; preds = %sort.run.next.234.sink.split.i, %sort.m.tail.r.248.i
  %t587.i = icmp samesign ult i64 %t591.reass.i, 2000
  br i1 %t587.i, label %sort.run.body.233.i, label %sort.run.done.235.i

sort.run.done.235.i:                              ; preds = %sort.run.next.234.i
  %t662.i = xor i1 %sort.flip.579.0160.i, true
  %t581.i = icmp ult i64 %sort.width.578.0159.i, 1000
  br i1 %t581.i, label %sort.pass.body.228.i, label %sort.finish.231.i

sort.finish.231.i:                                ; preds = %sort.run.done.235.i
  call void @free(ptr %t545.i)
  %t673.i = call noalias align 16 dereferenceable_or_null(16000) ptr @malloc(i64 16000)
  %t674.i = icmp eq ptr %t673.i, null
  br i1 %t674.i, label %alloc.oom.257.i, label %alloc.ok.256.i

alloc.oom.257.i:                                  ; preds = %sort.finish.231.i
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.256.i:                                   ; preds = %sort.finish.231.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16000) %t673.i, ptr noundef nonnull align 16 dereferenceable(16000) %t359.i, i64 16000, i1 false)
  %t683.i = call noalias align 16 dereferenceable_or_null(32000) ptr @malloc(i64 32000)
  %t684.i = icmp eq ptr %t683.i, null
  br i1 %t684.i, label %alloc.oom.261.i, label %sort.fill.body.263.i

alloc.oom.261.i:                                  ; preds = %alloc.ok.256.i
  call fastcc void @archx_oom_fail()
  unreachable

sort.fill.body.263.i:                             ; preds = %alloc.ok.256.i, %sort.fill.body.263.i
  %sort.fill.i.685.0161.i = phi i64 [ %t695.i.1, %sort.fill.body.263.i ], [ 0, %alloc.ok.256.i ]
  %t688.i = getelementptr inbounds nuw i64, ptr %t673.i, i64 %sort.fill.i.685.0161.i
  %t689.i = load i64, ptr %t688.i, align 16
  %t690.i = sub i64 0, %t689.i
  %t691.i = shl nuw nsw i64 %sort.fill.i.685.0161.i, 4
  %t692.i = getelementptr inbounds nuw i8, ptr %t683.i, i64 %t691.i
  store i64 %t690.i, ptr %t692.i, align 16
  %t694.i = getelementptr inbounds nuw i8, ptr %t692.i, i64 8
  store i64 %sort.fill.i.685.0161.i, ptr %t694.i, align 8
  %t695.i = or disjoint i64 %sort.fill.i.685.0161.i, 1
  %t688.i.1 = getelementptr inbounds nuw i64, ptr %t673.i, i64 %t695.i
  %t689.i.1 = load i64, ptr %t688.i.1, align 8
  %t690.i.1 = sub i64 0, %t689.i.1
  %t691.i.1 = shl nuw nsw i64 %t695.i, 4
  %t692.i.1 = getelementptr inbounds nuw i8, ptr %t683.i, i64 %t691.i.1
  store i64 %t690.i.1, ptr %t692.i.1, align 16
  %t694.i.1 = getelementptr inbounds nuw i8, ptr %t692.i.1, i64 8
  store i64 %t695.i, ptr %t694.i.1, align 8
  %t695.i.1 = add nuw nsw i64 %sort.fill.i.685.0161.i, 2
  %exitcond212.not.i.1 = icmp eq i64 %t695.i.1, 2000
  br i1 %exitcond212.not.i.1, label %sort.fill.end.264.i, label %sort.fill.body.263.i

sort.fill.end.264.i:                              ; preds = %sort.fill.body.263.i
  %t697.i = call noalias align 16 dereferenceable_or_null(32000) ptr @malloc(i64 32000)
  %t698.i = icmp eq ptr %t697.i, null
  br i1 %t698.i, label %alloc.oom.266.i, label %alloc.ok.265.i

alloc.oom.266.i:                                  ; preds = %sort.fill.end.264.i
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.265.i:                                   ; preds = %sort.fill.end.264.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(32000) %t697.i, ptr noundef nonnull align 16 dereferenceable(32000) %t683.i, i64 32000, i1 false)
  br label %sort.ins.outer.body.268.i

sort.ins.outer.267.loopexit.i:                    ; preds = %sort.ins.place.276.i, %sort.ins.outer.body.268.i
  %t701.i = icmp slt i64 %sort.ins.run.699.0169.i, 1984
  br i1 %t701.i, label %sort.ins.outer.body.268.i, label %sort.pass.body.279.i

sort.ins.outer.body.268.i:                        ; preds = %sort.ins.outer.267.loopexit.i, %alloc.ok.265.i
  %sort.ins.run.699.0169.i = phi i64 [ 0, %alloc.ok.265.i ], [ %t704.i, %sort.ins.outer.267.loopexit.i ]
  %153 = call i64 @llvm.smin.i64(i64 %sort.ins.run.699.0169.i, i64 1984)
  %t704.i = add nsw i64 %153, 16
  %sort.ins.i.705.0166.i = add nsw i64 %sort.ins.run.699.0169.i, 1
  %t708167.i = icmp slt i64 %sort.ins.i.705.0166.i, %t704.i
  br i1 %t708167.i, label %sort.ins.body.271.i, label %sort.ins.outer.267.loopexit.i

sort.ins.body.271.i:                              ; preds = %sort.ins.outer.body.268.i, %sort.ins.place.276.i
  %sort.ins.i.705.0168.i = phi i64 [ %sort.ins.i.705.0.i, %sort.ins.place.276.i ], [ %sort.ins.i.705.0166.i, %sort.ins.outer.body.268.i ]
  %t709.i = shl nuw nsw i64 %sort.ins.i.705.0168.i, 4
  %t710.i = getelementptr inbounds nuw i8, ptr %t697.i, i64 %t709.i
  %sort.tmp.419.sroa.0.0.copyload.i = load i64, ptr %t710.i, align 16
  %sort.tmp.419.sroa.12.0.t710.sroa_idx.i = getelementptr inbounds nuw i8, ptr %t710.i, i64 8
  %sort.tmp.419.sroa.12.0.copyload.i = load i64, ptr %sort.tmp.419.sroa.12.0.t710.sroa_idx.i, align 8
  %t713.not162.i = icmp sgt i64 %sort.ins.i.705.0168.i, %sort.ins.run.699.0169.i
  br i1 %t713.not162.i, label %sort.ins.check.274.i, label %sort.ins.place.276.i

sort.ins.check.274.i:                             ; preds = %sort.ins.body.271.i, %sort.ins.shift.275.i
  %sort.ins.j.711.0163.i = phi i64 [ %t714.i, %sort.ins.shift.275.i ], [ %sort.ins.i.705.0168.i, %sort.ins.body.271.i ]
  %t714.i = add nsw i64 %sort.ins.j.711.0163.i, -1
  %t715.i = shl nuw nsw i64 %t714.i, 4
  %t716.i = getelementptr inbounds nuw i8, ptr %t697.i, i64 %t715.i
  %t720.i = load i64, ptr %t716.i, align 16
  %t721.i = icmp sge i64 %sort.tmp.419.sroa.0.0.copyload.i, %t720.i
  %t722.i = icmp ne i64 %sort.tmp.419.sroa.0.0.copyload.i, %t720.i
  %t725.i = getelementptr inbounds nuw i8, ptr %t716.i, i64 8
  %t726.i = load i64, ptr %t725.i, align 8
  %t727.i = icmp sge i64 %sort.tmp.419.sroa.12.0.copyload.i, %t726.i
  %t728.not77.i = or i1 %t722.i, %t727.i
  %t729.not.i = and i1 %t721.i, %t728.not77.i
  br i1 %t729.not.i, label %sort.ins.place.276.loopexit.i, label %sort.ins.shift.275.i

sort.ins.shift.275.i:                             ; preds = %sort.ins.check.274.i
  %t731.i = shl nuw nsw i64 %sort.ins.j.711.0163.i, 4
  %t732.i = getelementptr inbounds nuw i8, ptr %t697.i, i64 %t731.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %t732.i, ptr noundef nonnull align 16 dereferenceable(16) %t716.i, i64 16, i1 false)
  %t713.not.i = icmp sgt i64 %t714.i, %sort.ins.run.699.0169.i
  br i1 %t713.not.i, label %sort.ins.check.274.i, label %sort.ins.place.276.loopexit.i

sort.ins.place.276.loopexit.i:                    ; preds = %sort.ins.shift.275.i, %sort.ins.check.274.i
  %sort.ins.j.711.0.lcssa.ph.i = phi i64 [ %sort.ins.run.699.0169.i, %sort.ins.shift.275.i ], [ %sort.ins.j.711.0163.i, %sort.ins.check.274.i ]
  %.pre219.i = shl nuw nsw i64 %sort.ins.j.711.0.lcssa.ph.i, 4
  br label %sort.ins.place.276.i

sort.ins.place.276.i:                             ; preds = %sort.ins.place.276.loopexit.i, %sort.ins.body.271.i
  %t734.pre-phi.i = phi i64 [ %.pre219.i, %sort.ins.place.276.loopexit.i ], [ %t709.i, %sort.ins.body.271.i ]
  %t735.i = getelementptr inbounds nuw i8, ptr %t697.i, i64 %t734.pre-phi.i
  store i64 %sort.tmp.419.sroa.0.0.copyload.i, ptr %t735.i, align 16
  %sort.tmp.419.sroa.12.0.t735.sroa_idx.i = getelementptr inbounds nuw i8, ptr %t735.i, i64 8
  store i64 %sort.tmp.419.sroa.12.0.copyload.i, ptr %sort.tmp.419.sroa.12.0.t735.sroa_idx.i, align 8
  %sort.ins.i.705.0.i = add nsw i64 %sort.ins.i.705.0168.i, 1
  %exitcond213.not.i = icmp eq i64 %sort.ins.i.705.0.i, %t704.i
  br i1 %exitcond213.not.i, label %sort.ins.outer.267.loopexit.i, label %sort.ins.body.271.i

sort.pass.body.279.i:                             ; preds = %sort.ins.outer.267.loopexit.i, %sort.run.done.286.i
  %sort.flip.739.0173.i = phi i1 [ %t838.i, %sort.run.done.286.i ], [ true, %sort.ins.outer.267.loopexit.i ]
  %sort.width.738.0172.i = phi i64 [ %invariant.op170.i, %sort.run.done.286.i ], [ 16, %sort.ins.outer.267.loopexit.i ]
  %t743.i = select i1 %sort.flip.739.0173.i, ptr %t697.i, ptr %t683.i
  %t744.i = select i1 %sort.flip.739.0173.i, ptr %t683.i, ptr %t697.i
  %invariant.op170.i = shl i64 %sort.width.738.0172.i, 1
  br label %sort.run.body.284.i

sort.run.body.284.i:                              ; preds = %sort.run.next.285.i, %sort.pass.body.279.i
  %sort.lo.745.0171.i = phi i64 [ 0, %sort.pass.body.279.i ], [ %t751.reass.i, %sort.run.next.285.i ]
  %t748.i = add nuw nsw i64 %sort.lo.745.0171.i, %sort.width.738.0172.i
  %t750.i = call i64 @llvm.smin.i64(i64 %t748.i, i64 2000)
  %t751.reass.i = add nuw nsw i64 %sort.lo.745.0171.i, %invariant.op170.i
  %t753.i = call i64 @llvm.smin.i64(i64 %t751.reass.i, i64 2000)
  br label %sort.m.head.287.i

sort.m.head.287.i:                                ; preds = %sort.m.store.291.i, %sort.run.body.284.i
  %sort.m.i.754.0.i = phi i64 [ %sort.lo.745.0171.i, %sort.run.body.284.i ], [ %sort.m.i.754.1.i, %sort.m.store.291.i ]
  %sort.m.j.755.0.i = phi i64 [ %t750.i, %sort.run.body.284.i ], [ %sort.m.j.755.1.i, %sort.m.store.291.i ]
  %sort.m.k.756.0.i = phi i64 [ %sort.lo.745.0171.i, %sort.run.body.284.i ], [ %t820.i, %sort.m.store.291.i ]
  %t760.i = icmp samesign uge i64 %sort.m.k.756.0.i, %t753.i
  %t761.i = icmp sge i64 %sort.m.i.754.0.i, %t750.i
  %t762.i = icmp sge i64 %sort.m.j.755.0.i, %t753.i
  %t763.i = or i1 %t761.i, %t760.i
  %t764.i = or i1 %t762.i, %t763.i
  br i1 %t764.i, label %sort.m.drain.292.i, label %sort.m.cmp.288.i

sort.m.cmp.288.i:                                 ; preds = %sort.m.head.287.i
  %t765.i = shl nuw nsw i64 %sort.m.i.754.0.i, 4
  %t766.i = getelementptr inbounds nuw i8, ptr %t743.i, i64 %t765.i
  %t768.i = load i64, ptr %t766.i, align 16
  %t769.i = shl nuw nsw i64 %sort.m.j.755.0.i, 4
  %t770.i = getelementptr inbounds nuw i8, ptr %t743.i, i64 %t769.i
  %t772.i = load i64, ptr %t770.i, align 16
  %t773.i = icmp slt i64 %t772.i, %t768.i
  %t774.i = icmp eq i64 %t772.i, %t768.i
  %t775.i = getelementptr inbounds nuw i8, ptr %t770.i, i64 8
  %t776.i = load i64, ptr %t775.i, align 8
  %t777.i = getelementptr inbounds nuw i8, ptr %t766.i, i64 8
  %t778.i = load i64, ptr %t777.i, align 8
  %t779.i = icmp slt i64 %t776.i, %t778.i
  %t780.i = and i1 %t774.i, %t779.i
  %t781.i = or i1 %t773.i, %t780.i
  %t789.i = shl nuw nsw i64 %sort.m.k.756.0.i, 4
  %t790.i = getelementptr inbounds nuw i8, ptr %t744.i, i64 %t789.i
  br i1 %t781.i, label %sort.m.r.289.i, label %sort.m.l.290.i

sort.m.l.290.i:                                   ; preds = %sort.m.cmp.288.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %t790.i, ptr noundef nonnull align 16 dereferenceable(16) %t766.i, i64 16, i1 false)
  %t786.i = add nsw i64 %sort.m.i.754.0.i, 1
  br label %sort.m.store.291.i

sort.m.r.289.i:                                   ; preds = %sort.m.cmp.288.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %t790.i, ptr noundef nonnull align 16 dereferenceable(16) %t770.i, i64 16, i1 false)
  %t791.i = add nsw i64 %sort.m.j.755.0.i, 1
  br label %sort.m.store.291.i

sort.m.drain.292.i:                               ; preds = %sort.m.head.287.i
  %t794.not.i = or i1 %t761.i, %t762.i
  br i1 %t794.not.i, label %sort.m.end2.297.i, label %sort.m.cmp2.296.i

sort.m.cmp2.296.i:                                ; preds = %sort.m.drain.292.i
  %t797.i = shl nuw nsw i64 %sort.m.i.754.0.i, 4
  %t798.i = getelementptr inbounds nuw i8, ptr %t743.i, i64 %t797.i
  %t800.i = load i64, ptr %t798.i, align 16
  %t801.i = shl nuw nsw i64 %sort.m.j.755.0.i, 4
  %t802.i = getelementptr inbounds nuw i8, ptr %t743.i, i64 %t801.i
  %t804.i = load i64, ptr %t802.i, align 16
  %t805.i = icmp slt i64 %t804.i, %t800.i
  %t806.i = icmp eq i64 %t804.i, %t800.i
  %t807.i = getelementptr inbounds nuw i8, ptr %t802.i, i64 8
  %t808.i = load i64, ptr %t807.i, align 8
  %t809.i = getelementptr inbounds nuw i8, ptr %t798.i, i64 8
  %t810.i = load i64, ptr %t809.i, align 8
  %t811.i = icmp slt i64 %t808.i, %t810.i
  %t812.i = and i1 %t806.i, %t811.i
  %t813.i = or i1 %t805.i, %t812.i
  %t817.i = shl nuw nsw i64 %sort.m.k.756.0.i, 4
  %t818.i = getelementptr inbounds nuw i8, ptr %t744.i, i64 %t817.i
  br i1 %t813.i, label %sort.m.r2.293.i, label %sort.m.l2.294.i

sort.m.l2.294.i:                                  ; preds = %sort.m.cmp2.296.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %t818.i, ptr noundef nonnull align 16 dereferenceable(16) %t798.i, i64 16, i1 false)
  %t816.i = add nsw i64 %sort.m.i.754.0.i, 1
  br label %sort.m.store.291.i

sort.m.r2.293.i:                                  ; preds = %sort.m.cmp2.296.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %t818.i, ptr noundef nonnull align 16 dereferenceable(16) %t802.i, i64 16, i1 false)
  %t819.i = add nsw i64 %sort.m.j.755.0.i, 1
  br label %sort.m.store.291.i

sort.m.store.291.i:                               ; preds = %sort.m.r2.293.i, %sort.m.l2.294.i, %sort.m.r.289.i, %sort.m.l.290.i
  %sort.m.i.754.1.i = phi i64 [ %sort.m.i.754.0.i, %sort.m.r2.293.i ], [ %t816.i, %sort.m.l2.294.i ], [ %sort.m.i.754.0.i, %sort.m.r.289.i ], [ %t786.i, %sort.m.l.290.i ]
  %sort.m.j.755.1.i = phi i64 [ %t819.i, %sort.m.r2.293.i ], [ %sort.m.j.755.0.i, %sort.m.l2.294.i ], [ %t791.i, %sort.m.r.289.i ], [ %sort.m.j.755.0.i, %sort.m.l.290.i ]
  %t820.i = add nuw nsw i64 %sort.m.k.756.0.i, 1
  br label %sort.m.head.287.i

sort.m.end2.297.i:                                ; preds = %sort.m.drain.292.i
  br i1 %t761.i, label %sort.m.tail.r.299.i, label %sort.cpy.301.i

sort.cpy.301.i:                                   ; preds = %sort.m.end2.297.i
  %t821.i = sub nsw i64 %t750.i, %sort.m.i.754.0.i
  br label %sort.run.next.285.sink.split.i

sort.m.tail.r.299.i:                              ; preds = %sort.m.end2.297.i
  %t834.not.i = icmp eq i64 %t753.i, %sort.m.j.755.0.i
  br i1 %t834.not.i, label %sort.run.next.285.i, label %sort.cpy.303.i

sort.cpy.303.i:                                   ; preds = %sort.m.tail.r.299.i
  %t828.i = sub nsw i64 %t753.i, %sort.m.j.755.0.i
  br label %sort.run.next.285.sink.split.i

sort.run.next.285.sink.split.i:                   ; preds = %sort.cpy.303.i, %sort.cpy.301.i
  %t828.sink.i = phi i64 [ %t828.i, %sort.cpy.303.i ], [ %t821.i, %sort.cpy.301.i ]
  %sort.m.j.755.0.sink.i = phi i64 [ %sort.m.j.755.0.i, %sort.cpy.303.i ], [ %sort.m.i.754.0.i, %sort.cpy.301.i ]
  %t833.i = shl nuw nsw i64 %t828.sink.i, 4
  %t831.i = shl nuw nsw i64 %sort.m.k.756.0.i, 4
  %t832.i = getelementptr inbounds nuw i8, ptr %t744.i, i64 %t831.i
  %t829.i = shl nuw nsw i64 %sort.m.j.755.0.sink.i, 4
  %t830.i = getelementptr inbounds nuw i8, ptr %t743.i, i64 %t829.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %t832.i, ptr nonnull align 16 %t830.i, i64 %t833.i, i1 false)
  br label %sort.run.next.285.i

sort.run.next.285.i:                              ; preds = %sort.run.next.285.sink.split.i, %sort.m.tail.r.299.i
  %t747.i = icmp samesign ult i64 %t751.reass.i, 2000
  br i1 %t747.i, label %sort.run.body.284.i, label %sort.run.done.286.i

sort.run.done.286.i:                              ; preds = %sort.run.next.285.i
  %t838.i = xor i1 %sort.flip.739.0173.i, true
  %t741.i = icmp ult i64 %sort.width.738.0172.i, 1000
  br i1 %t741.i, label %sort.pass.body.279.i, label %sort.finish.282.i

sort.finish.282.i:                                ; preds = %sort.run.done.286.i
  call void @free(ptr %t697.i)
  %t842.i = call noalias align 16 dereferenceable_or_null(16000) ptr @malloc(i64 16000)
  %t843.i = icmp eq ptr %t842.i, null
  br i1 %t843.i, label %alloc.oom.306.i, label %alloc.ok.305.i

alloc.oom.306.i:                                  ; preds = %sort.finish.282.i
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.305.i:                                   ; preds = %sort.finish.282.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16000) %t842.i, ptr noundef nonnull align 16 dereferenceable(16000) %t673.i, i64 16000, i1 false)
  %invariant.gep.i = getelementptr inbounds nuw i8, ptr %t683.i, i64 8
  br label %sort.gather.body.308.i

sort.gather.body.308.i:                           ; preds = %sort.gather.body.308.i, %alloc.ok.305.i
  %sort.gather.i.844.0174.i = phi i64 [ 0, %alloc.ok.305.i ], [ %t855.i.1, %sort.gather.body.308.i ]
  %t847.i = shl nuw nsw i64 %sort.gather.i.844.0174.i, 4
  %gep.i = getelementptr inbounds nuw i8, ptr %invariant.gep.i, i64 %t847.i
  %t850.i = load i64, ptr %gep.i, align 8
  %t851.i = shl nuw nsw i64 %t850.i, 3
  %t852.i = getelementptr inbounds nuw i8, ptr %t842.i, i64 %t851.i
  %t853.i = shl nuw nsw i64 %sort.gather.i.844.0174.i, 3
  %t854.i = getelementptr inbounds nuw i8, ptr %t673.i, i64 %t853.i
  %154 = load i64, ptr %t852.i, align 16
  store i64 %154, ptr %t854.i, align 16
  %t855.i = or disjoint i64 %sort.gather.i.844.0174.i, 1
  %t847.i.1 = shl nuw nsw i64 %t855.i, 4
  %gep.i.1 = getelementptr inbounds nuw i8, ptr %invariant.gep.i, i64 %t847.i.1
  %t850.i.1 = load i64, ptr %gep.i.1, align 8
  %t851.i.1 = shl nuw nsw i64 %t850.i.1, 3
  %t852.i.1 = getelementptr inbounds nuw i8, ptr %t842.i, i64 %t851.i.1
  %t853.i.1 = shl nuw nsw i64 %t855.i, 3
  %t854.i.1 = getelementptr inbounds nuw i8, ptr %t673.i, i64 %t853.i.1
  %155 = load i64, ptr %t852.i.1, align 16
  store i64 %155, ptr %t854.i.1, align 8
  %t855.i.1 = add nuw nsw i64 %sort.gather.i.844.0174.i, 2
  %exitcond214.not.i.1 = icmp eq i64 %t855.i.1, 2000
  br i1 %exitcond214.not.i.1, label %sort.gather.end.309.i, label %sort.gather.body.308.i

sort.gather.end.309.i:                            ; preds = %sort.gather.body.308.i
  call void @free(ptr nonnull %t842.i)
  call void @free(ptr nonnull %t683.i)
  %t864.i = call noalias align 16 dereferenceable_or_null(16000) ptr @malloc(i64 16000)
  %t865.i = icmp eq ptr %t864.i, null
  br i1 %t865.i, label %alloc.oom.313.i, label %alloc.ok.312.i

alloc.oom.313.i:                                  ; preds = %sort.gather.end.309.i
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.312.i:                                   ; preds = %sort.gather.end.309.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16000) %t864.i, ptr noundef nonnull align 16 dereferenceable(16000) %t359.i, i64 16000, i1 false)
  %t873.i = call noalias align 16 dereferenceable_or_null(16000) ptr @malloc(i64 16000)
  %t874.i = icmp eq ptr %t873.i, null
  br i1 %t874.i, label %alloc.oom.317.i, label %alloc.ok.316.i

alloc.oom.317.i:                                  ; preds = %alloc.ok.312.i
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.316.i:                                   ; preds = %alloc.ok.312.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(16000) %t873.i, ptr noundef nonnull align 16 dereferenceable(16000) %t359.i, i64 16000, i1 false)
  br label %sort.ins.outer.body.319.i

sort.ins.outer.318.loopexit.i:                    ; preds = %sort.ins.place.327.i, %sort.ins.outer.body.319.i
  %t877.i = icmp slt i64 %sort.ins.run.875.0182.i, 1984
  br i1 %t877.i, label %sort.ins.outer.body.319.i, label %sort.pass.body.330.i

sort.ins.outer.body.319.i:                        ; preds = %sort.ins.outer.318.loopexit.i, %alloc.ok.316.i
  %sort.ins.run.875.0182.i = phi i64 [ 0, %alloc.ok.316.i ], [ %t880.i, %sort.ins.outer.318.loopexit.i ]
  %156 = call i64 @llvm.smin.i64(i64 %sort.ins.run.875.0182.i, i64 1984)
  %t880.i = add nsw i64 %156, 16
  %sort.ins.i.881.0179.i = add nsw i64 %sort.ins.run.875.0182.i, 1
  %t884180.i = icmp slt i64 %sort.ins.i.881.0179.i, %t880.i
  br i1 %t884180.i, label %sort.ins.body.322.i, label %sort.ins.outer.318.loopexit.i

sort.ins.body.322.i:                              ; preds = %sort.ins.outer.body.319.i, %sort.ins.place.327.i
  %sort.ins.i.881.0181.i = phi i64 [ %sort.ins.i.881.0.i, %sort.ins.place.327.i ], [ %sort.ins.i.881.0179.i, %sort.ins.outer.body.319.i ]
  %t885.i = shl nuw nsw i64 %sort.ins.i.881.0181.i, 3
  %t886.i = getelementptr inbounds nuw i8, ptr %t873.i, i64 %t885.i
  %sort.tmp.419.sroa.0.0.copyload36.i = load i64, ptr %t886.i, align 8
  %t889.not175.i = icmp sgt i64 %sort.ins.i.881.0181.i, %sort.ins.run.875.0182.i
  br i1 %t889.not175.i, label %sort.ins.check.325.i, label %sort.ins.place.327.i

sort.ins.check.325.i:                             ; preds = %sort.ins.body.322.i, %sort.ins.shift.326.i
  %sort.ins.j.887.0176.i = phi i64 [ %t890.i, %sort.ins.shift.326.i ], [ %sort.ins.i.881.0181.i, %sort.ins.body.322.i ]
  %t890.i = add nsw i64 %sort.ins.j.887.0176.i, -1
  %t891.i = shl nuw nsw i64 %t890.i, 3
  %t892.i = getelementptr inbounds nuw i8, ptr %t873.i, i64 %t891.i
  %t896.i = load i64, ptr %t892.i, align 8
  %t897.not.i = icmp slt i64 %sort.tmp.419.sroa.0.0.copyload36.i, %t896.i
  br i1 %t897.not.i, label %sort.ins.shift.326.i, label %sort.ins.place.327.loopexit.i

sort.ins.shift.326.i:                             ; preds = %sort.ins.check.325.i
  %t899.i = shl nuw nsw i64 %sort.ins.j.887.0176.i, 3
  %t900.i = getelementptr inbounds nuw i8, ptr %t873.i, i64 %t899.i
  store i64 %t896.i, ptr %t900.i, align 8
  %t889.not.i = icmp sgt i64 %t890.i, %sort.ins.run.875.0182.i
  br i1 %t889.not.i, label %sort.ins.check.325.i, label %sort.ins.place.327.loopexit.i

sort.ins.place.327.loopexit.i:                    ; preds = %sort.ins.shift.326.i, %sort.ins.check.325.i
  %sort.ins.j.887.0.lcssa.ph.i = phi i64 [ %sort.ins.run.875.0182.i, %sort.ins.shift.326.i ], [ %sort.ins.j.887.0176.i, %sort.ins.check.325.i ]
  %.pre220.i = shl nuw nsw i64 %sort.ins.j.887.0.lcssa.ph.i, 3
  br label %sort.ins.place.327.i

sort.ins.place.327.i:                             ; preds = %sort.ins.place.327.loopexit.i, %sort.ins.body.322.i
  %t902.pre-phi.i = phi i64 [ %.pre220.i, %sort.ins.place.327.loopexit.i ], [ %t885.i, %sort.ins.body.322.i ]
  %t903.i = getelementptr inbounds nuw i8, ptr %t873.i, i64 %t902.pre-phi.i
  store i64 %sort.tmp.419.sroa.0.0.copyload36.i, ptr %t903.i, align 8
  %sort.ins.i.881.0.i = add nsw i64 %sort.ins.i.881.0181.i, 1
  %exitcond215.not.i = icmp eq i64 %sort.ins.i.881.0.i, %t880.i
  br i1 %exitcond215.not.i, label %sort.ins.outer.318.loopexit.i, label %sort.ins.body.322.i

sort.pass.body.330.i:                             ; preds = %sort.ins.outer.318.loopexit.i, %sort.run.done.337.i
  %sort.flip.907.0186.i = phi i1 [ %t990.i, %sort.run.done.337.i ], [ true, %sort.ins.outer.318.loopexit.i ]
  %sort.width.906.0185.i = phi i64 [ %invariant.op183.i, %sort.run.done.337.i ], [ 16, %sort.ins.outer.318.loopexit.i ]
  %t911.i = select i1 %sort.flip.907.0186.i, ptr %t873.i, ptr %t864.i
  %t912.i = select i1 %sort.flip.907.0186.i, ptr %t864.i, ptr %t873.i
  %invariant.op183.i = shl i64 %sort.width.906.0185.i, 1
  br label %sort.run.body.335.i

sort.run.body.335.i:                              ; preds = %sort.run.next.336.i, %sort.pass.body.330.i
  %sort.lo.913.0184.i = phi i64 [ 0, %sort.pass.body.330.i ], [ %t919.reass.i, %sort.run.next.336.i ]
  %t916.i = add nuw nsw i64 %sort.lo.913.0184.i, %sort.width.906.0185.i
  %t918.i = call i64 @llvm.smin.i64(i64 %t916.i, i64 2000)
  %t919.reass.i = add nuw nsw i64 %sort.lo.913.0184.i, %invariant.op183.i
  %t921.i = call i64 @llvm.smin.i64(i64 %t919.reass.i, i64 2000)
  br label %sort.m.head.338.i

sort.m.head.338.i:                                ; preds = %sort.m.store.342.i, %sort.run.body.335.i
  %sort.m.i.922.0.i = phi i64 [ %sort.lo.913.0184.i, %sort.run.body.335.i ], [ %sort.m.i.922.1.i, %sort.m.store.342.i ]
  %sort.m.j.923.0.i = phi i64 [ %t918.i, %sort.run.body.335.i ], [ %sort.m.j.923.1.i, %sort.m.store.342.i ]
  %sort.m.k.924.0.i = phi i64 [ %sort.lo.913.0184.i, %sort.run.body.335.i ], [ %t972.i, %sort.m.store.342.i ]
  %t928.i = icmp samesign uge i64 %sort.m.k.924.0.i, %t921.i
  %t929.i = icmp sge i64 %sort.m.i.922.0.i, %t918.i
  %t930.i = icmp sge i64 %sort.m.j.923.0.i, %t921.i
  %t931.i = or i1 %t929.i, %t928.i
  %t932.i = or i1 %t930.i, %t931.i
  br i1 %t932.i, label %sort.m.drain.343.i, label %sort.m.cmp.339.i

sort.m.cmp.339.i:                                 ; preds = %sort.m.head.338.i
  %t933.i = shl nuw nsw i64 %sort.m.i.922.0.i, 3
  %t934.i = getelementptr inbounds nuw i8, ptr %t911.i, i64 %t933.i
  %t936.i = load i64, ptr %t934.i, align 8
  %t937.i = shl nuw nsw i64 %sort.m.j.923.0.i, 3
  %t938.i = getelementptr inbounds nuw i8, ptr %t911.i, i64 %t937.i
  %t940.i = load i64, ptr %t938.i, align 8
  %t941.i = icmp slt i64 %t940.i, %t936.i
  %t949.i = shl nuw nsw i64 %sort.m.k.924.0.i, 3
  %t950.i = getelementptr inbounds nuw i8, ptr %t912.i, i64 %t949.i
  br i1 %t941.i, label %sort.m.r.340.i, label %sort.m.l.341.i

sort.m.l.341.i:                                   ; preds = %sort.m.cmp.339.i
  store i64 %t936.i, ptr %t950.i, align 8
  %t946.i = add nsw i64 %sort.m.i.922.0.i, 1
  br label %sort.m.store.342.i

sort.m.r.340.i:                                   ; preds = %sort.m.cmp.339.i
  store i64 %t940.i, ptr %t950.i, align 8
  %t951.i = add nsw i64 %sort.m.j.923.0.i, 1
  br label %sort.m.store.342.i

sort.m.drain.343.i:                               ; preds = %sort.m.head.338.i
  %t954.not.i = or i1 %t929.i, %t930.i
  br i1 %t954.not.i, label %sort.m.end2.348.i, label %sort.m.cmp2.347.i

sort.m.cmp2.347.i:                                ; preds = %sort.m.drain.343.i
  %t957.i = shl nuw nsw i64 %sort.m.i.922.0.i, 3
  %t958.i = getelementptr inbounds nuw i8, ptr %t911.i, i64 %t957.i
  %t960.i = load i64, ptr %t958.i, align 8
  %t961.i = shl nuw nsw i64 %sort.m.j.923.0.i, 3
  %t962.i = getelementptr inbounds nuw i8, ptr %t911.i, i64 %t961.i
  %t964.i = load i64, ptr %t962.i, align 8
  %t965.i = icmp slt i64 %t964.i, %t960.i
  %t969.i = shl nuw nsw i64 %sort.m.k.924.0.i, 3
  %t970.i = getelementptr inbounds nuw i8, ptr %t912.i, i64 %t969.i
  br i1 %t965.i, label %sort.m.r2.344.i, label %sort.m.l2.345.i

sort.m.l2.345.i:                                  ; preds = %sort.m.cmp2.347.i
  store i64 %t960.i, ptr %t970.i, align 8
  %t968.i = add nsw i64 %sort.m.i.922.0.i, 1
  br label %sort.m.store.342.i

sort.m.r2.344.i:                                  ; preds = %sort.m.cmp2.347.i
  store i64 %t964.i, ptr %t970.i, align 8
  %t971.i = add nsw i64 %sort.m.j.923.0.i, 1
  br label %sort.m.store.342.i

sort.m.store.342.i:                               ; preds = %sort.m.r2.344.i, %sort.m.l2.345.i, %sort.m.r.340.i, %sort.m.l.341.i
  %sort.m.i.922.1.i = phi i64 [ %sort.m.i.922.0.i, %sort.m.r2.344.i ], [ %t968.i, %sort.m.l2.345.i ], [ %sort.m.i.922.0.i, %sort.m.r.340.i ], [ %t946.i, %sort.m.l.341.i ]
  %sort.m.j.923.1.i = phi i64 [ %t971.i, %sort.m.r2.344.i ], [ %sort.m.j.923.0.i, %sort.m.l2.345.i ], [ %t951.i, %sort.m.r.340.i ], [ %sort.m.j.923.0.i, %sort.m.l.341.i ]
  %t972.i = add nuw nsw i64 %sort.m.k.924.0.i, 1
  br label %sort.m.head.338.i

sort.m.end2.348.i:                                ; preds = %sort.m.drain.343.i
  br i1 %t929.i, label %sort.m.tail.r.350.i, label %sort.cpy.352.i

sort.cpy.352.i:                                   ; preds = %sort.m.end2.348.i
  %t973.i = sub nsw i64 %t918.i, %sort.m.i.922.0.i
  br label %sort.run.next.336.sink.split.i

sort.m.tail.r.350.i:                              ; preds = %sort.m.end2.348.i
  %t986.not.i = icmp eq i64 %t921.i, %sort.m.j.923.0.i
  br i1 %t986.not.i, label %sort.run.next.336.i, label %sort.cpy.354.i

sort.cpy.354.i:                                   ; preds = %sort.m.tail.r.350.i
  %t980.i = sub nsw i64 %t921.i, %sort.m.j.923.0.i
  br label %sort.run.next.336.sink.split.i

sort.run.next.336.sink.split.i:                   ; preds = %sort.cpy.354.i, %sort.cpy.352.i
  %t980.sink.i = phi i64 [ %t980.i, %sort.cpy.354.i ], [ %t973.i, %sort.cpy.352.i ]
  %sort.m.j.923.0.sink.i = phi i64 [ %sort.m.j.923.0.i, %sort.cpy.354.i ], [ %sort.m.i.922.0.i, %sort.cpy.352.i ]
  %t985.i = shl nuw nsw i64 %t980.sink.i, 3
  %t983.i = shl nuw nsw i64 %sort.m.k.924.0.i, 3
  %t984.i = getelementptr inbounds nuw i8, ptr %t912.i, i64 %t983.i
  %t981.i = shl nuw nsw i64 %sort.m.j.923.0.sink.i, 3
  %t982.i = getelementptr inbounds nuw i8, ptr %t911.i, i64 %t981.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %t984.i, ptr nonnull align 8 %t982.i, i64 %t985.i, i1 false)
  br label %sort.run.next.336.i

sort.run.next.336.i:                              ; preds = %sort.run.next.336.sink.split.i, %sort.m.tail.r.350.i
  %t915.i = icmp samesign ult i64 %t919.reass.i, 2000
  br i1 %t915.i, label %sort.run.body.335.i, label %sort.run.done.337.i

sort.run.done.337.i:                              ; preds = %sort.run.next.336.i
  %t990.i = xor i1 %sort.flip.907.0186.i, true
  %t909.i = icmp ult i64 %sort.width.906.0185.i, 1000
  br i1 %t909.i, label %sort.pass.body.330.i, label %sort.finish.333.i

sort.finish.333.i:                                ; preds = %sort.run.done.337.i
  call void @free(ptr %t873.i)
  br label %for.fast.body.357.i

for.fast.body.357.i:                              ; preds = %overflow.ok.370.i, %sort.finish.333.i
  %for.i.994.0188.i = phi i64 [ 0, %sort.finish.333.i ], [ %t1039.i, %overflow.ok.370.i ]
  %var.acc.23.7187.i = phi i64 [ %var.acc.23.6.i.1, %sort.finish.333.i ], [ %t1036.i, %overflow.ok.370.i ]
  %t1012.i = getelementptr inbounds nuw i64, ptr %t398.i, i64 %for.i.994.0188.i
  %t1013.i = load i64, ptr %t1012.i, align 8
  %t1016.i = getelementptr inbounds nuw i64, ptr %t536.i, i64 %for.i.994.0188.i
  %t1017.i = load i64, ptr %t1016.i, align 8
  %t1018.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t1013.i, i64 %t1017.i)
  %t1020.i = extractvalue { i64, i1 } %t1018.i, 1
  br i1 %t1020.i, label %overflow.add.363.i, label %overflow.ok.364.i

overflow.add.363.i:                               ; preds = %for.fast.body.357.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.364.i:                                ; preds = %for.fast.body.357.i
  %t1019.i = extractvalue { i64, i1 } %t1018.i, 0
  %t1023.i = getelementptr inbounds nuw i64, ptr %t673.i, i64 %for.i.994.0188.i
  %t1024.i = load i64, ptr %t1023.i, align 8
  %t1025.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t1019.i, i64 %t1024.i)
  %t1027.i = extractvalue { i64, i1 } %t1025.i, 1
  br i1 %t1027.i, label %overflow.add.365.i, label %overflow.ok.366.i

overflow.add.365.i:                               ; preds = %overflow.ok.364.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.366.i:                                ; preds = %overflow.ok.364.i
  %t1026.i = extractvalue { i64, i1 } %t1025.i, 0
  %t1030.i = getelementptr inbounds nuw i64, ptr %t864.i, i64 %for.i.994.0188.i
  %t1031.i = load i64, ptr %t1030.i, align 8
  %t1032.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t1026.i, i64 %t1031.i)
  %t1034.i = extractvalue { i64, i1 } %t1032.i, 1
  br i1 %t1034.i, label %overflow.add.367.i, label %overflow.ok.368.i

overflow.add.367.i:                               ; preds = %overflow.ok.366.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.368.i:                                ; preds = %overflow.ok.366.i
  %t1033.i = extractvalue { i64, i1 } %t1032.i, 0
  %t1035.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.23.7187.i, i64 %t1033.i)
  %t1037.i = extractvalue { i64, i1 } %t1035.i, 1
  br i1 %t1037.i, label %overflow.add.369.i, label %overflow.ok.370.i

overflow.add.369.i:                               ; preds = %overflow.ok.368.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.370.i:                                ; preds = %overflow.ok.368.i
  %t1036.i = extractvalue { i64, i1 } %t1035.i, 0
  %t1039.i = add nuw nsw i64 %for.i.994.0188.i, 1
  %exitcond216.not.i = icmp eq i64 %t1039.i, 8
  br i1 %exitcond216.not.i, label %mod.ok.392.i, label %for.fast.body.357.i

mod.ok.392.i:                                     ; preds = %overflow.ok.370.i, %overflow.ok.394.i
  %foreach.idx.1083.0190.i = phi i64 [ %t1108.i, %overflow.ok.394.i ], [ 0, %overflow.ok.370.i ]
  %var.acc.23.10189.i = phi i64 [ %t1105.i, %overflow.ok.394.i ], [ %t1036.i, %overflow.ok.370.i ]
  %t1087.i = getelementptr inbounds nuw i64, ptr %t673.i, i64 %foreach.idx.1083.0190.i
  %t1088.i = load i64, ptr %t1087.i, align 8
  %t1096.i = srem i64 %t1088.i, 7
  %t1098.i = icmp slt i64 %t1096.i, 0
  %t1102.i = select i1 %t1098.i, i64 7, i64 0
  %t1103.i = add nsw i64 %t1102.i, %t1096.i
  %t1104.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.acc.23.10189.i, i64 %t1103.i)
  %t1106.i = extractvalue { i64, i1 } %t1104.i, 1
  br i1 %t1106.i, label %overflow.add.393.i, label %overflow.ok.394.i

overflow.add.393.i:                               ; preds = %mod.ok.392.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.394.i:                                ; preds = %mod.ok.392.i
  %t1105.i = extractvalue { i64, i1 } %t1104.i, 0
  %t1108.i = add nuw nsw i64 %foreach.idx.1083.0190.i, 1
  %exitcond217.not.i = icmp eq i64 %t1108.i, 2000
  br i1 %exitcond217.not.i, label %archx_fn_pipeline_tour.exit, label %mod.ok.392.i

archx_fn_pipeline_tour.exit:                      ; preds = %overflow.ok.394.i
  call void @free(ptr %t864.i)
  call void @free(ptr nonnull %t673.i)
  call void @free(ptr %t536.i)
  call void @free(ptr %t398.i)
  call void @free(ptr %t359.i)
  call void @free(ptr %t312.i)
  call void @free(ptr %t303.i1247)
  call void @free(ptr %t3.i1218)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1269)
  %n32.i1270 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1269, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t126.i)
  %len.i1271 = sext i32 %n32.i1270 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1268)
  %z.i.i1272 = icmp slt i32 %n32.i1270, 1
  br i1 %z.i.i1272, label %archx_str_from_int.exit1296, label %chk_sso.i.i1273

oom.i.i1288:                                      ; preds = %alloc_heap.i.i1275
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1273:                                  ; preds = %archx_fn_pipeline_tour.exit
  %short.i.i1274 = icmp samesign ult i32 %n32.i1270, 13
  br i1 %short.i.i1274, label %pack_sso.i.i1289, label %alloc_heap.i.i1275

pack_sso.i.i1289:                                 ; preds = %chk_sso.i.i1273
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1268, i8 0, i64 16, i1 false)
  store i32 %n32.i1270, ptr %sso.i.i1268, align 8
  %sso.i.i1268.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1268, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1268.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1269, i64 %len.i1271, i1 false)
  %sso.i.i1268.0.sso.i.i1268.0.sso.i.i1268.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1291 = load i64, ptr %sso.i.i1268, align 8
  %sso.i.i1268.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1268, i64 8
  %sso.i.i1268.8.sso.i.i1268.8.sso.i.i1268.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1293 = load i64, ptr %sso.i.i1268.8.sroa_idx, align 8
  %ss0.i.i1294 = insertvalue %ArchxStr poison, i64 %sso.i.i1268.0.sso.i.i1268.0.sso.i.i1268.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1291, 0
  %ss1.i.i1295 = insertvalue %ArchxStr %ss0.i.i1294, i64 %sso.i.i1268.8.sso.i.i1268.8.sso.i.i1268.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1293, 1
  br label %archx_str_from_int.exit1296

alloc_heap.i.i1275:                               ; preds = %chk_sso.i.i1273
  %hp.i.i1276 = call noalias align 16 ptr @malloc(i64 %len.i1271)
  %hnull.i.i1277 = icmp eq ptr %hp.i.i1276, null
  br i1 %hnull.i.i1277, label %oom.i.i1288, label %copy_long.i.i1278

copy_long.i.i1278:                                ; preds = %alloc_heap.i.i1275
  %hp_i.i.i1279 = ptrtoint ptr %hp.i.i1276 to i64
  %htagged.i.i1280 = or disjoint i64 %hp_i.i.i1279, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1276, ptr nonnull readonly align 8 %buf.i1269, i64 %len.i1271, i1 false)
  %pref32.i.i1281 = load i32, ptr %hp.i.i1276, align 16
  %pref64.i.i1282 = zext i32 %pref32.i.i1281 to i64
  %pref_sh.i.i1283 = shl nuw i64 %pref64.i.i1282, 32
  %w0_out.i.i1284 = or disjoint i64 %pref_sh.i.i1283, %len.i1271
  %ls0.i.i1285 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1284, 0
  %ls1.i.i1286 = insertvalue %ArchxStr %ls0.i.i1285, i64 %htagged.i.i1280, 1
  br label %archx_str_from_int.exit1296

archx_str_from_int.exit1296:                      ; preds = %archx_fn_pipeline_tour.exit, %pack_sso.i.i1289, %copy_long.i.i1278
  %common.ret.op.i.i1287 = phi %ArchxStr [ %ss1.i.i1295, %pack_sso.i.i1289 ], [ %ls1.i.i1286, %copy_long.i.i1278 ], [ zeroinitializer, %archx_fn_pipeline_tour.exit ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1268)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1269)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i293)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i294.sroa.6)
  %bw0.i295 = extractvalue %ArchxStr %common.ret.op.i.i1287, 0
  %bw1.i296 = extractvalue %ArchxStr %common.ret.op.i.i1287, 1
  %blen.i297 = and i64 %bw0.i295, 4294967295
  %bz.i298 = icmp eq i64 %blen.i297, 0
  br i1 %bz.i298, label %archx_str_concat.exit341, label %calc_tot.i299

calc_tot.i299:                                    ; preds = %archx_str_from_int.exit1296
  %tot.i300 = add nuw nsw i64 %blen.i297, 4
  %too_big.i301 = icmp samesign ugt i64 %blen.i297, 2147483643
  br i1 %too_big.i301, label %oom.i325, label %mat_a.i302

oom.i325:                                         ; preds = %alloc_heap.i311, %calc_tot.i299
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i302:                                       ; preds = %calc_tot.i299
  %bshort.i304 = icmp samesign ult i64 %blen.i297, 13
  br i1 %bshort.i304, label %build.i308, label %build.i308.thread

build.i308.thread:                                ; preds = %mat_a.i302
  %braw.i306 = and i64 %bw1.i296, -4
  %blptr.i307 = inttoptr i64 %braw.i306 to ptr
  br label %alloc_heap.i311

build.i308:                                       ; preds = %mat_a.i302
  %bp4.i336 = lshr i64 %bw0.i295, 32
  %bp4_32.i337 = trunc nuw i64 %bp4.i336 to i32
  store i32 %bp4_32.i337, ptr %btmp.i293, align 4
  %btmp4.i338 = getelementptr inbounds nuw i8, ptr %btmp.i293, i64 4
  store i64 %bw1.i296, ptr %btmp4.i338, align 4
  %fits_sso.i310 = icmp samesign ult i64 %blen.i297, 9
  br i1 %fits_sso.i310, label %build_sso.i326, label %alloc_heap.i311

build_sso.i326:                                   ; preds = %build.i308
  store i64 0, ptr %out_sso.i294.sroa.6, align 8
  %out_sso.i294.sroa.0.4.insert.insert = or disjoint i64 %tot.i300, 4426309951417221120
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i294.sroa.6, ptr nonnull align 4 %btmp.i293, i64 %blen.i297, i1 false)
  %out_sso.i294.sroa.6.0.out_sso.i294.sroa.6.0.out_sso.i294.sroa.6.0.out_sso.i294.sroa.6.8.rw1.i332 = load i64, ptr %out_sso.i294.sroa.6, align 8
  %rs0.i333 = insertvalue %ArchxStr poison, i64 %out_sso.i294.sroa.0.4.insert.insert, 0
  %rs1.i334 = insertvalue %ArchxStr %rs0.i333, i64 %out_sso.i294.sroa.6.0.out_sso.i294.sroa.6.0.out_sso.i294.sroa.6.0.out_sso.i294.sroa.6.8.rw1.i332, 1
  br label %archx_str_concat.exit341

alloc_heap.i311:                                  ; preds = %build.i308.thread, %build.i308
  %bptr.i3091983 = phi ptr [ %blptr.i307, %build.i308.thread ], [ %btmp.i293, %build.i308 ]
  %hp.i312 = call noalias align 16 ptr @malloc(i64 %tot.i300)
  %hnull.i313 = icmp eq ptr %hp.i312, null
  br i1 %hnull.i313, label %oom.i325, label %copy_long.i314

copy_long.i314:                                   ; preds = %alloc_heap.i311
  %hp_i.i315 = ptrtoint ptr %hp.i312 to i64
  %htagged.i316 = or disjoint i64 %hp_i.i315, 1
  store i32 1030580595, ptr %hp.i312, align 16
  %dst_b.i317 = getelementptr inbounds nuw i8, ptr %hp.i312, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %dst_b.i317, ptr nonnull align 1 %bptr.i3091983, i64 %blen.i297, i1 false)
  %w0_out.i321 = or disjoint i64 %tot.i300, 4426309951417221120
  %ls0.i322 = insertvalue %ArchxStr poison, i64 %w0_out.i321, 0
  %ls1.i323 = insertvalue %ArchxStr %ls0.i322, i64 %htagged.i316, 1
  br label %archx_str_concat.exit341

archx_str_concat.exit341:                         ; preds = %archx_str_from_int.exit1296, %build_sso.i326, %copy_long.i314
  %common.ret.op.i324 = phi %ArchxStr [ %rs1.i334, %build_sso.i326 ], [ %ls1.i323, %copy_long.i314 ], [ { i64 4426309951417221124, i64 0 }, %archx_str_from_int.exit1296 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i293)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i294.sroa.6)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  %w0.i1298 = extractvalue %ArchxStr %common.ret.op.i324, 0
  %w1.i1299 = extractvalue %ArchxStr %common.ret.op.i324, 1
  %len.i1300 = and i64 %w0.i1298, 4294967295
  %short.i = icmp samesign ult i64 %len.i1300, 13
  br i1 %short.i, label %emit.i, label %emit.thread.i

emit.thread.i:                                    ; preds = %archx_str_concat.exit341
  %raw.i1301 = and i64 %w1.i1299, -4
  %lptr.i = inttoptr i64 %raw.i1301 to ptr
  br label %chk_nul.i

emit.i:                                           ; preds = %archx_str_concat.exit341
  %p4.i = lshr i64 %w0.i1298, 32
  %p4_32.i = trunc nuw i64 %p4.i to i32
  store i32 %p4_32.i, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 %w1.i1299, ptr %tmp4.i, align 4
  %pos.not.i = icmp eq i64 %len.i1300, 0
  br i1 %pos.not.i, label %do_nl.i, label %chk_nul.i

chk_nul.i:                                        ; preds = %emit.i, %emit.thread.i
  %data3.i = phi ptr [ %lptr.i, %emit.thread.i ], [ %tmp.i, %emit.i ]
  %nul.i = call ptr @memchr(ptr nonnull %data3.i, i32 0, i64 %len.i1300)
  %has_nul.not.i = icmp eq ptr %nul.i, null
  br i1 %has_nul.not.i, label %fast_printf.i, label %byte_loop.i

fast_printf.i:                                    ; preds = %chk_nul.i
  %len32.i = trunc i64 %w0.i1298 to i32
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i, ptr nonnull %data3.i)
  br label %archx_str_print.exit

byte_loop.i:                                      ; preds = %chk_nul.i, %byte_loop.i
  %bi.i = phi i64 [ %bnext.i, %byte_loop.i ], [ 0, %chk_nul.i ]
  %bp.i = getelementptr inbounds nuw i8, ptr %data3.i, i64 %bi.i
  %ch8.i = load i8, ptr %bp.i, align 1
  %ch32.i = zext i8 %ch8.i to i32
  %pc.i = call i32 @putchar(i32 %ch32.i)
  %bnext.i = add nuw nsw i64 %bi.i, 1
  %exitcond.not.i1302 = icmp eq i64 %bnext.i, %len.i1300
  br i1 %exitcond.not.i1302, label %do_nl.i, label %byte_loop.i

do_nl.i:                                          ; preds = %byte_loop.i, %emit.i
  %nc.i = call i32 @putchar(i32 10)
  br label %archx_str_print.exit

archx_str_print.exit:                             ; preds = %fast_printf.i, %do_nl.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %tag.i22 = and i64 %w1.i1299, 1
  %owned.not.i23 = icmp eq i64 %tag.i22, 0
  %or.cond1883 = select i1 %short.i, i1 true, i1 %owned.not.i23
  br i1 %or.cond1883, label %archx_str_drop.exit27, label %do_free.i24

do_free.i24:                                      ; preds = %archx_str_print.exit
  %raw.i25 = and i64 %w1.i1299, -2
  %ptr.i26 = inttoptr i64 %raw.i25 to ptr
  call void @free(ptr %ptr.i26)
  br label %archx_str_drop.exit27

archx_str_drop.exit27:                            ; preds = %archx_str_print.exit, %do_free.i24
  %long.i30 = icmp samesign ult i64 %blen.i297, 13
  %tag.i33 = and i64 %bw1.i296, 1
  %owned.not.i34 = icmp eq i64 %tag.i33, 0
  %or.cond1884 = select i1 %long.i30, i1 true, i1 %owned.not.i34
  br i1 %or.cond1884, label %archx_str_drop.exit38, label %do_free.i35

do_free.i35:                                      ; preds = %archx_str_drop.exit27
  %raw.i36 = and i64 %bw1.i296, -2
  %ptr.i37 = inttoptr i64 %raw.i36 to ptr
  call void @free(ptr %ptr.i37)
  br label %archx_str_drop.exit38

archx_str_drop.exit38:                            ; preds = %archx_str_drop.exit27, %do_free.i35
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1304)
  %n32.i1305 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1304, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t421.i)
  %len.i1306 = sext i32 %n32.i1305 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1303)
  %z.i.i1307 = icmp slt i32 %n32.i1305, 1
  br i1 %z.i.i1307, label %archx_str_from_int.exit1331, label %chk_sso.i.i1308

oom.i.i1323:                                      ; preds = %alloc_heap.i.i1310
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1308:                                  ; preds = %archx_str_drop.exit38
  %short.i.i1309 = icmp samesign ult i32 %n32.i1305, 13
  br i1 %short.i.i1309, label %pack_sso.i.i1324, label %alloc_heap.i.i1310

pack_sso.i.i1324:                                 ; preds = %chk_sso.i.i1308
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1303, i8 0, i64 16, i1 false)
  store i32 %n32.i1305, ptr %sso.i.i1303, align 8
  %sso.i.i1303.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1303, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1303.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1304, i64 %len.i1306, i1 false)
  %sso.i.i1303.0.sso.i.i1303.0.sso.i.i1303.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1326 = load i64, ptr %sso.i.i1303, align 8
  %sso.i.i1303.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1303, i64 8
  %sso.i.i1303.8.sso.i.i1303.8.sso.i.i1303.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1328 = load i64, ptr %sso.i.i1303.8.sroa_idx, align 8
  %ss0.i.i1329 = insertvalue %ArchxStr poison, i64 %sso.i.i1303.0.sso.i.i1303.0.sso.i.i1303.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1326, 0
  %ss1.i.i1330 = insertvalue %ArchxStr %ss0.i.i1329, i64 %sso.i.i1303.8.sso.i.i1303.8.sso.i.i1303.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1328, 1
  br label %archx_str_from_int.exit1331

alloc_heap.i.i1310:                               ; preds = %chk_sso.i.i1308
  %hp.i.i1311 = call noalias align 16 ptr @malloc(i64 %len.i1306)
  %hnull.i.i1312 = icmp eq ptr %hp.i.i1311, null
  br i1 %hnull.i.i1312, label %oom.i.i1323, label %copy_long.i.i1313

copy_long.i.i1313:                                ; preds = %alloc_heap.i.i1310
  %hp_i.i.i1314 = ptrtoint ptr %hp.i.i1311 to i64
  %htagged.i.i1315 = or disjoint i64 %hp_i.i.i1314, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1311, ptr nonnull readonly align 8 %buf.i1304, i64 %len.i1306, i1 false)
  %pref32.i.i1316 = load i32, ptr %hp.i.i1311, align 16
  %pref64.i.i1317 = zext i32 %pref32.i.i1316 to i64
  %pref_sh.i.i1318 = shl nuw i64 %pref64.i.i1317, 32
  %w0_out.i.i1319 = or disjoint i64 %pref_sh.i.i1318, %len.i1306
  %ls0.i.i1320 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1319, 0
  %ls1.i.i1321 = insertvalue %ArchxStr %ls0.i.i1320, i64 %htagged.i.i1315, 1
  br label %archx_str_from_int.exit1331

archx_str_from_int.exit1331:                      ; preds = %archx_str_drop.exit38, %pack_sso.i.i1324, %copy_long.i.i1313
  %common.ret.op.i.i1322 = phi %ArchxStr [ %ss1.i.i1330, %pack_sso.i.i1324 ], [ %ls1.i.i1321, %copy_long.i.i1313 ], [ zeroinitializer, %archx_str_drop.exit38 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1303)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1304)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i343)
  %bw0.i345 = extractvalue %ArchxStr %common.ret.op.i.i1322, 0
  %bw1.i346 = extractvalue %ArchxStr %common.ret.op.i.i1322, 1
  %blen.i347 = and i64 %bw0.i345, 4294967295
  %bz.i348 = icmp eq i64 %blen.i347, 0
  br i1 %bz.i348, label %archx_str_concat.exit391, label %calc_tot.i349

calc_tot.i349:                                    ; preds = %archx_str_from_int.exit1331
  %tot.i350 = add nuw nsw i64 %blen.i347, 11
  %too_big.i351 = icmp samesign ugt i64 %blen.i347, 2147483636
  br i1 %too_big.i351, label %oom.i375, label %mat_a.i352

oom.i375:                                         ; preds = %alloc_heap.i361, %calc_tot.i349
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i352:                                       ; preds = %calc_tot.i349
  %bshort.i354 = icmp samesign ult i64 %blen.i347, 13
  br i1 %bshort.i354, label %build.i358, label %build.i358.thread

build.i358.thread:                                ; preds = %mat_a.i352
  %braw.i356 = and i64 %bw1.i346, -4
  %blptr.i357 = inttoptr i64 %braw.i356 to ptr
  br label %alloc_heap.i361

build.i358:                                       ; preds = %mat_a.i352
  %bp4.i386 = lshr i64 %bw0.i345, 32
  %bp4_32.i387 = trunc nuw i64 %bp4.i386 to i32
  store i32 %bp4_32.i387, ptr %btmp.i343, align 4
  %btmp4.i388 = getelementptr inbounds nuw i8, ptr %btmp.i343, i64 4
  store i64 %bw1.i346, ptr %btmp4.i388, align 4
  %fits_sso.i360 = icmp eq i64 %blen.i347, 1
  br i1 %fits_sso.i360, label %build_sso.i376, label %alloc_heap.i361

build_sso.i376:                                   ; preds = %build.i358
  %157 = load i8, ptr %btmp.i343, align 4
  %out_sso.i344.sroa.6.sroa.5.0.insert.ext = zext i8 %157 to i64
  %out_sso.i344.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i344.sroa.6.sroa.5.0.insert.ext, 56
  %out_sso.i344.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i344.sroa.6.sroa.5.0.insert.shift, 17281451224232799
  %rs1.i384 = insertvalue %ArchxStr { i64 8386662809311641612, i64 poison }, i64 %out_sso.i344.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit391

alloc_heap.i361:                                  ; preds = %build.i358.thread, %build.i358
  %bptr.i3591986 = phi ptr [ %blptr.i357, %build.i358.thread ], [ %btmp.i343, %build.i358 ]
  %hp.i362 = call noalias align 16 ptr @malloc(i64 %tot.i350)
  %hnull.i363 = icmp eq ptr %hp.i362, null
  br i1 %hnull.i363, label %oom.i375, label %copy_long.i364

copy_long.i364:                                   ; preds = %alloc_heap.i361
  %hp_i.i365 = ptrtoint ptr %hp.i362 to i64
  %htagged.i366 = or disjoint i64 %hp_i.i365, 1
  store i32 1952672100, ptr %hp.i362, align 16
  %atmp.i342.sroa.5.0.hp.i362.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i362, i64 4
  store i56 17281451224232799, ptr %atmp.i342.sroa.5.0.hp.i362.sroa_idx, align 4
  %dst_b.i367 = getelementptr inbounds nuw i8, ptr %hp.i362, i64 11
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i367, ptr nonnull align 1 %bptr.i3591986, i64 %blen.i347, i1 false)
  %w0_out.i371 = or disjoint i64 %tot.i350, 8386662809311641600
  %ls0.i372 = insertvalue %ArchxStr poison, i64 %w0_out.i371, 0
  %ls1.i373 = insertvalue %ArchxStr %ls0.i372, i64 %htagged.i366, 1
  br label %archx_str_concat.exit391

archx_str_concat.exit391:                         ; preds = %archx_str_from_int.exit1331, %build_sso.i376, %copy_long.i364
  %common.ret.op.i374 = phi %ArchxStr [ %rs1.i384, %build_sso.i376 ], [ %ls1.i373, %copy_long.i364 ], [ { i64 8386662809311641611, i64 17281451224232799 }, %archx_str_from_int.exit1331 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i343)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i392)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i394)
  %aw0.i = extractvalue %ArchxStr %common.ret.op.i374, 0
  %aw1.i = extractvalue %ArchxStr %common.ret.op.i374, 1
  %alen.i = and i64 %aw0.i, 4294967295
  %az.i = icmp eq i64 %alen.i, 0
  br i1 %az.i, label %archx_str_concat.exit429, label %chk_bz.i

chk_bz.i:                                         ; preds = %archx_str_concat.exit391
  %tot.i396 = add nuw nsw i64 %alen.i, 1
  %too_big.i397 = icmp samesign ugt i64 %alen.i, 2147483646
  br i1 %too_big.i397, label %oom.i418, label %mat_a.i398

oom.i418:                                         ; preds = %alloc_heap.i404, %chk_bz.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i398:                                       ; preds = %chk_bz.i
  %ashort.i = icmp samesign ult i64 %alen.i, 13
  br i1 %ashort.i, label %mat_b.i, label %mat_b.i.thread

mat_b.i.thread:                                   ; preds = %mat_a.i398
  %araw.i = and i64 %aw1.i, -4
  %alptr.i = inttoptr i64 %araw.i to ptr
  br label %alloc_heap.i404

mat_b.i:                                          ; preds = %mat_a.i398
  %ap4.i = lshr i64 %aw0.i, 32
  %ap4_32.i = trunc nuw i64 %ap4.i to i32
  store i32 %ap4_32.i, ptr %atmp.i392, align 4
  %atmp4.i428 = getelementptr inbounds nuw i8, ptr %atmp.i392, i64 4
  store i64 %aw1.i, ptr %atmp4.i428, align 4
  %fits_sso.i403.not = icmp eq i64 %alen.i, 12
  br i1 %fits_sso.i403.not, label %alloc_heap.i404, label %build_sso.i419

build_sso.i419:                                   ; preds = %mat_b.i
  %out_sso8.i420 = getelementptr inbounds nuw i8, ptr %out_sso.i394, i64 8
  %tot32.i421 = trunc nuw nsw i64 %tot.i396 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i394, i8 0, i64 16, i1 false)
  store i32 %tot32.i421, ptr %out_sso.i394, align 8
  %sso_dst_a.i422 = getelementptr inbounds nuw i8, ptr %out_sso.i394, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i422, ptr nonnull align 4 %atmp.i392, i64 %alen.i, i1 false)
  %sso_dst_b.i423 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i422, i64 %alen.i
  store i8 44, ptr %sso_dst_b.i423, align 1
  %rw0.i424 = load i64, ptr %out_sso.i394, align 8
  %rw1.i425 = load i64, ptr %out_sso8.i420, align 8
  %rs0.i426 = insertvalue %ArchxStr poison, i64 %rw0.i424, 0
  %rs1.i427 = insertvalue %ArchxStr %rs0.i426, i64 %rw1.i425, 1
  br label %archx_str_concat.exit429

alloc_heap.i404:                                  ; preds = %mat_b.i.thread, %mat_b.i
  %aptr.i1869 = phi ptr [ %alptr.i, %mat_b.i.thread ], [ %atmp.i392, %mat_b.i ]
  %hp.i405 = call noalias align 16 ptr @malloc(i64 %tot.i396)
  %hnull.i406 = icmp eq ptr %hp.i405, null
  br i1 %hnull.i406, label %oom.i418, label %copy_long.i407

copy_long.i407:                                   ; preds = %alloc_heap.i404
  %hp_i.i408 = ptrtoint ptr %hp.i405 to i64
  %htagged.i409 = or disjoint i64 %hp_i.i408, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i405, ptr nonnull align 1 %aptr.i1869, i64 %alen.i, i1 false)
  %dst_b.i410 = getelementptr inbounds nuw i8, ptr %hp.i405, i64 %alen.i
  store i8 44, ptr %dst_b.i410, align 1
  %pref32.i411 = load i32, ptr %hp.i405, align 16
  %pref64.i412 = zext i32 %pref32.i411 to i64
  %pref_sh.i413 = shl nuw i64 %pref64.i412, 32
  %w0_out.i414 = or disjoint i64 %pref_sh.i413, %tot.i396
  %ls0.i415 = insertvalue %ArchxStr poison, i64 %w0_out.i414, 0
  %ls1.i416 = insertvalue %ArchxStr %ls0.i415, i64 %htagged.i409, 1
  br label %archx_str_concat.exit429

archx_str_concat.exit429:                         ; preds = %archx_str_concat.exit391, %build_sso.i419, %copy_long.i407
  %common.ret.op.i417 = phi %ArchxStr [ %rs1.i427, %build_sso.i419 ], [ %ls1.i416, %copy_long.i407 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit391 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i392)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i394)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i430)
  %aw0.i433 = extractvalue %ArchxStr %common.ret.op.i417, 0
  %aw1.i434 = extractvalue %ArchxStr %common.ret.op.i417, 1
  %alen.i437 = and i64 %aw0.i433, 4294967295
  %az.i439 = icmp eq i64 %alen.i437, 0
  br i1 %az.i439, label %dup_heap.i, label %calc_tot.i442

dup_heap.i:                                       ; preds = %archx_str_concat.exit429
  %dst.i = call noalias align 16 dereferenceable_or_null(20) ptr @malloc(i64 20)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i1342, label %archx_str_clone.exit

oom.i1342:                                        ; preds = %dup_heap.i
  call fastcc void @archx_oom_fail()
  unreachable

archx_str_clone.exit:                             ; preds = %dup_heap.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(20) %dst.i, ptr noundef nonnull align 16 dereferenceable(20) %dst.i735.i, i64 20, i1 false)
  br label %archx_str_concat.exit495

calc_tot.i442:                                    ; preds = %archx_str_concat.exit429
  %tot.i443 = add nuw nsw i64 %alen.i437, 20
  %too_big.i444 = icmp samesign ugt i64 %alen.i437, 2147483627
  br i1 %too_big.i444, label %oom.i473, label %mat_a.i445

oom.i473:                                         ; preds = %alloc_heap.i459, %calc_tot.i442
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i445:                                       ; preds = %calc_tot.i442
  %ashort.i446 = icmp samesign ult i64 %alen.i437, 13
  br i1 %ashort.i446, label %mat_a_short.i487, label %mat_a_long.i447

mat_a_short.i487:                                 ; preds = %mat_a.i445
  %ap4.i488 = lshr i64 %aw0.i433, 32
  %ap4_32.i489 = trunc nuw i64 %ap4.i488 to i32
  store i32 %ap4_32.i489, ptr %atmp.i430, align 4
  %atmp4.i490 = getelementptr inbounds nuw i8, ptr %atmp.i430, i64 4
  store i64 %aw1.i434, ptr %atmp4.i490, align 4
  br label %alloc_heap.i459

mat_a_long.i447:                                  ; preds = %mat_a.i445
  %araw.i448 = and i64 %aw1.i434, -4
  %alptr.i449 = inttoptr i64 %araw.i448 to ptr
  br label %alloc_heap.i459

alloc_heap.i459:                                  ; preds = %mat_a_short.i487, %mat_a_long.i447
  %aptr.i451 = phi ptr [ %atmp.i430, %mat_a_short.i487 ], [ %alptr.i449, %mat_a_long.i447 ]
  %hp.i460 = call noalias align 16 ptr @malloc(i64 %tot.i443)
  %hnull.i461 = icmp eq ptr %hp.i460, null
  br i1 %hnull.i461, label %oom.i473, label %copy_long.i462

copy_long.i462:                                   ; preds = %alloc_heap.i459
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i460, ptr nonnull align 1 %aptr.i451, i64 %alen.i437, i1 false)
  %dst_b.i465 = getelementptr inbounds nuw i8, ptr %hp.i460, i64 %alen.i437
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(20) %dst_b.i465, ptr noundef nonnull align 16 dereferenceable(20) %dst.i735.i, i64 20, i1 false)
  %pref32.i466 = load i32, ptr %hp.i460, align 16
  %pref64.i467 = zext i32 %pref32.i466 to i64
  %pref_sh.i468 = shl nuw i64 %pref64.i467, 32
  %w0_out.i469 = or disjoint i64 %pref_sh.i468, %tot.i443
  br label %archx_str_concat.exit495

archx_str_concat.exit495:                         ; preds = %archx_str_clone.exit, %copy_long.i462
  %w0_out.i.i647.i.pn = phi i64 [ %w0_out.i.i647.i, %archx_str_clone.exit ], [ %w0_out.i469, %copy_long.i462 ]
  %tagged.i.pn.in.in = phi ptr [ %dst.i, %archx_str_clone.exit ], [ %hp.i460, %copy_long.i462 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i430)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1362)
  %len.i1365 = and i64 %w0_out.i.i647.i.pn, 4294967295
  %short.i1366 = icmp samesign ult i64 %len.i1365, 13
  br i1 %short.i1366, label %emit.i1387, label %chk_nul.i1370

emit.i1387:                                       ; preds = %archx_str_concat.exit495
  %tagged.i.pn.in = ptrtoint ptr %tagged.i.pn.in.in to i64
  %tagged.i.pn = or disjoint i64 %tagged.i.pn.in, 1
  %p4.i1388 = lshr i64 %w0_out.i.i647.i.pn, 32
  %p4_32.i1389 = trunc nuw i64 %p4.i1388 to i32
  store i32 %p4_32.i1389, ptr %tmp.i1362, align 4
  %tmp4.i1390 = getelementptr inbounds nuw i8, ptr %tmp.i1362, i64 4
  store i64 %tagged.i.pn, ptr %tmp4.i1390, align 4
  %pos.not.i1391 = icmp eq i64 %len.i1365, 0
  br i1 %pos.not.i1391, label %do_nl.i1382, label %chk_nul.i1370

chk_nul.i1370:                                    ; preds = %archx_str_concat.exit495, %emit.i1387
  %data3.i1371 = phi ptr [ %tmp.i1362, %emit.i1387 ], [ %tagged.i.pn.in.in, %archx_str_concat.exit495 ]
  %nul.i1372 = call ptr @memchr(ptr nonnull %data3.i1371, i32 0, i64 %len.i1365)
  %has_nul.not.i1373 = icmp eq ptr %nul.i1372, null
  br i1 %has_nul.not.i1373, label %fast_printf.i1384, label %byte_loop.i1374

fast_printf.i1384:                                ; preds = %chk_nul.i1370
  %len32.i1385 = trunc i64 %w0_out.i.i647.i.pn to i32
  %np.i1386 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1385, ptr nonnull %data3.i1371)
  br label %archx_str_print.exit1392

byte_loop.i1374:                                  ; preds = %chk_nul.i1370, %byte_loop.i1374
  %bi.i1375 = phi i64 [ %bnext.i1380, %byte_loop.i1374 ], [ 0, %chk_nul.i1370 ]
  %bp.i1376 = getelementptr inbounds nuw i8, ptr %data3.i1371, i64 %bi.i1375
  %ch8.i1377 = load i8, ptr %bp.i1376, align 1
  %ch32.i1378 = zext i8 %ch8.i1377 to i32
  %pc.i1379 = call i32 @putchar(i32 %ch32.i1378)
  %bnext.i1380 = add nuw nsw i64 %bi.i1375, 1
  %exitcond.not.i1381 = icmp eq i64 %bnext.i1380, %len.i1365
  br i1 %exitcond.not.i1381, label %do_nl.i1382, label %byte_loop.i1374

do_nl.i1382:                                      ; preds = %byte_loop.i1374, %emit.i1387
  %nc.i1383 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1392

archx_str_print.exit1392:                         ; preds = %fast_printf.i1384, %do_nl.i1382
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1362)
  br i1 %short.i1366, label %archx_str_drop.exit49, label %do_free.i46

do_free.i46:                                      ; preds = %archx_str_print.exit1392
  call void @free(ptr nonnull %tagged.i.pn.in.in)
  br label %archx_str_drop.exit49

archx_str_drop.exit49:                            ; preds = %archx_str_print.exit1392, %do_free.i46
  %long.i52 = icmp samesign ult i64 %alen.i437, 13
  %tag.i55 = and i64 %aw1.i434, 1
  %owned.not.i56 = icmp eq i64 %tag.i55, 0
  %or.cond1886 = select i1 %long.i52, i1 true, i1 %owned.not.i56
  br i1 %or.cond1886, label %archx_str_drop.exit60, label %do_free.i57

do_free.i57:                                      ; preds = %archx_str_drop.exit49
  %raw.i58 = and i64 %aw1.i434, -2
  %ptr.i59 = inttoptr i64 %raw.i58 to ptr
  call void @free(ptr %ptr.i59)
  br label %archx_str_drop.exit60

archx_str_drop.exit60:                            ; preds = %archx_str_drop.exit49, %do_free.i57
  %long.i63 = icmp samesign ult i64 %alen.i, 13
  %tag.i66 = and i64 %aw1.i, 1
  %owned.not.i67 = icmp eq i64 %tag.i66, 0
  %or.cond1887 = select i1 %long.i63, i1 true, i1 %owned.not.i67
  br i1 %or.cond1887, label %archx_str_drop.exit71, label %do_free.i68

do_free.i68:                                      ; preds = %archx_str_drop.exit60
  %raw.i69 = and i64 %aw1.i, -2
  %ptr.i70 = inttoptr i64 %raw.i69 to ptr
  call void @free(ptr %ptr.i70)
  br label %archx_str_drop.exit71

archx_str_drop.exit71:                            ; preds = %archx_str_drop.exit60, %do_free.i68
  %long.i74 = icmp samesign ult i64 %blen.i347, 13
  %tag.i77 = and i64 %bw1.i346, 1
  %owned.not.i78 = icmp eq i64 %tag.i77, 0
  %or.cond1888 = select i1 %long.i74, i1 true, i1 %owned.not.i78
  br i1 %or.cond1888, label %archx_str_drop.exit82, label %do_free.i79

do_free.i79:                                      ; preds = %archx_str_drop.exit71
  %raw.i80 = and i64 %bw1.i346, -2
  %ptr.i81 = inttoptr i64 %raw.i80 to ptr
  call void @free(ptr %ptr.i81)
  br label %archx_str_drop.exit82

archx_str_drop.exit82:                            ; preds = %archx_str_drop.exit71, %do_free.i79
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1394)
  %n32.i1395 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1394, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %spec.select.i.1)
  %len.i1396 = sext i32 %n32.i1395 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1393)
  %z.i.i1397 = icmp slt i32 %n32.i1395, 1
  br i1 %z.i.i1397, label %archx_str_from_int.exit1421, label %chk_sso.i.i1398

oom.i.i1413:                                      ; preds = %alloc_heap.i.i1400
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1398:                                  ; preds = %archx_str_drop.exit82
  %short.i.i1399 = icmp samesign ult i32 %n32.i1395, 13
  br i1 %short.i.i1399, label %pack_sso.i.i1414, label %alloc_heap.i.i1400

pack_sso.i.i1414:                                 ; preds = %chk_sso.i.i1398
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1393, i8 0, i64 16, i1 false)
  store i32 %n32.i1395, ptr %sso.i.i1393, align 8
  %sso.i.i1393.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1393, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1393.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1394, i64 %len.i1396, i1 false)
  %sso.i.i1393.0.sso.i.i1393.0.sso.i.i1393.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1416 = load i64, ptr %sso.i.i1393, align 8
  %sso.i.i1393.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1393, i64 8
  %sso.i.i1393.8.sso.i.i1393.8.sso.i.i1393.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1418 = load i64, ptr %sso.i.i1393.8.sroa_idx, align 8
  %ss0.i.i1419 = insertvalue %ArchxStr poison, i64 %sso.i.i1393.0.sso.i.i1393.0.sso.i.i1393.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1416, 0
  %ss1.i.i1420 = insertvalue %ArchxStr %ss0.i.i1419, i64 %sso.i.i1393.8.sso.i.i1393.8.sso.i.i1393.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1418, 1
  br label %archx_str_from_int.exit1421

alloc_heap.i.i1400:                               ; preds = %chk_sso.i.i1398
  %hp.i.i1401 = call noalias align 16 ptr @malloc(i64 %len.i1396)
  %hnull.i.i1402 = icmp eq ptr %hp.i.i1401, null
  br i1 %hnull.i.i1402, label %oom.i.i1413, label %copy_long.i.i1403

copy_long.i.i1403:                                ; preds = %alloc_heap.i.i1400
  %hp_i.i.i1404 = ptrtoint ptr %hp.i.i1401 to i64
  %htagged.i.i1405 = or disjoint i64 %hp_i.i.i1404, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1401, ptr nonnull readonly align 8 %buf.i1394, i64 %len.i1396, i1 false)
  %pref32.i.i1406 = load i32, ptr %hp.i.i1401, align 16
  %pref64.i.i1407 = zext i32 %pref32.i.i1406 to i64
  %pref_sh.i.i1408 = shl nuw i64 %pref64.i.i1407, 32
  %w0_out.i.i1409 = or disjoint i64 %pref_sh.i.i1408, %len.i1396
  %ls0.i.i1410 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1409, 0
  %ls1.i.i1411 = insertvalue %ArchxStr %ls0.i.i1410, i64 %htagged.i.i1405, 1
  br label %archx_str_from_int.exit1421

archx_str_from_int.exit1421:                      ; preds = %archx_str_drop.exit82, %pack_sso.i.i1414, %copy_long.i.i1403
  %common.ret.op.i.i1412 = phi %ArchxStr [ %ss1.i.i1420, %pack_sso.i.i1414 ], [ %ls1.i.i1411, %copy_long.i.i1403 ], [ zeroinitializer, %archx_str_drop.exit82 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1393)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1394)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i497)
  call void @llvm.lifetime.start.p0(i64 2, ptr nonnull %out_sso.i498.sroa.6.sroa.5)
  %bw0.i499 = extractvalue %ArchxStr %common.ret.op.i.i1412, 0
  %bw1.i500 = extractvalue %ArchxStr %common.ret.op.i.i1412, 1
  %blen.i501 = and i64 %bw0.i499, 4294967295
  %bz.i503 = icmp eq i64 %blen.i501, 0
  br i1 %bz.i503, label %archx_str_concat.exit549, label %calc_tot.i504

calc_tot.i504:                                    ; preds = %archx_str_from_int.exit1421
  %tot.i505 = add nuw nsw i64 %blen.i501, 10
  %too_big.i506 = icmp samesign ugt i64 %blen.i501, 2147483637
  br i1 %too_big.i506, label %oom.i533, label %mat_a.i507

oom.i533:                                         ; preds = %alloc_heap.i519, %calc_tot.i504
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i507:                                       ; preds = %calc_tot.i504
  %bshort.i512 = icmp samesign ult i64 %blen.i501, 13
  br i1 %bshort.i512, label %build.i516, label %build.i516.thread

build.i516.thread:                                ; preds = %mat_a.i507
  %braw.i514 = and i64 %bw1.i500, -4
  %blptr.i515 = inttoptr i64 %braw.i514 to ptr
  br label %alloc_heap.i519

build.i516:                                       ; preds = %mat_a.i507
  %bp4.i544 = lshr i64 %bw0.i499, 32
  %bp4_32.i545 = trunc nuw i64 %bp4.i544 to i32
  store i32 %bp4_32.i545, ptr %btmp.i497, align 4
  %btmp4.i546 = getelementptr inbounds nuw i8, ptr %btmp.i497, i64 4
  store i64 %bw1.i500, ptr %btmp4.i546, align 4
  %fits_sso.i518 = icmp samesign ult i64 %blen.i501, 3
  br i1 %fits_sso.i518, label %build_sso.i534, label %alloc_heap.i519

build_sso.i534:                                   ; preds = %build.i516
  store i16 0, ptr %out_sso.i498.sroa.6.sroa.5, align 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 2 %out_sso.i498.sroa.6.sroa.5, ptr nonnull align 4 %btmp.i497, i64 %blen.i501, i1 false)
  %out_sso.i498.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i505, 7813874494564466688
  %out_sso.i498.sroa.6.sroa.5.0.out_sso.i498.sroa.6.sroa.5.0.out_sso.i498.sroa.6.sroa.5.0.out_sso.i498.sroa.6.sroa.5.0.out_sso.i498.sroa.6.8.rw1.i540 = load i16, ptr %out_sso.i498.sroa.6.sroa.5, align 2
  %out_sso.i498.sroa.6.sroa.5.0.insert.ext = zext i16 %out_sso.i498.sroa.6.sroa.5.0.out_sso.i498.sroa.6.sroa.5.0.out_sso.i498.sroa.6.sroa.5.0.out_sso.i498.sroa.6.sroa.5.0.out_sso.i498.sroa.6.8.rw1.i540 to i64
  %out_sso.i498.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i498.sroa.6.sroa.5.0.insert.ext, 48
  %out_sso.i498.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i498.sroa.6.sroa.5.0.insert.shift, 67570311847781
  %rs0.i541 = insertvalue %ArchxStr poison, i64 %out_sso.i498.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i542 = insertvalue %ArchxStr %rs0.i541, i64 %out_sso.i498.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit549

alloc_heap.i519:                                  ; preds = %build.i516.thread, %build.i516
  %bptr.i5171989 = phi ptr [ %blptr.i515, %build.i516.thread ], [ %btmp.i497, %build.i516 ]
  %hp.i520 = call noalias align 16 ptr @malloc(i64 %tot.i505)
  %hnull.i521 = icmp eq ptr %hp.i520, null
  br i1 %hnull.i521, label %oom.i533, label %copy_long.i522

copy_long.i522:                                   ; preds = %alloc_heap.i519
  %hp_i.i523 = ptrtoint ptr %hp.i520 to i64
  %htagged.i524 = or disjoint i64 %hp_i.i523, 1
  store i32 1819309428, ptr %hp.i520, align 16
  %atmp.i496.sroa.5.0.hp.i520.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i520, i64 4
  store i48 67570311847781, ptr %atmp.i496.sroa.5.0.hp.i520.sroa_idx, align 4
  %dst_b.i525 = getelementptr inbounds nuw i8, ptr %hp.i520, i64 10
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 2 %dst_b.i525, ptr nonnull align 1 %bptr.i5171989, i64 %blen.i501, i1 false)
  %w0_out.i529 = or disjoint i64 %tot.i505, 7813874494564466688
  %ls0.i530 = insertvalue %ArchxStr poison, i64 %w0_out.i529, 0
  %ls1.i531 = insertvalue %ArchxStr %ls0.i530, i64 %htagged.i524, 1
  br label %archx_str_concat.exit549

archx_str_concat.exit549:                         ; preds = %archx_str_from_int.exit1421, %build_sso.i534, %copy_long.i522
  %common.ret.op.i532 = phi %ArchxStr [ %rs1.i542, %build_sso.i534 ], [ %ls1.i531, %copy_long.i522 ], [ { i64 7813874494564466698, i64 67570311847781 }, %archx_str_from_int.exit1421 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i497)
  call void @llvm.lifetime.end.p0(i64 2, ptr nonnull %out_sso.i498.sroa.6.sroa.5)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i550)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i552)
  %aw0.i553 = extractvalue %ArchxStr %common.ret.op.i532, 0
  %aw1.i554 = extractvalue %ArchxStr %common.ret.op.i532, 1
  %alen.i555 = and i64 %aw0.i553, 4294967295
  %az.i556 = icmp eq i64 %alen.i555, 0
  br i1 %az.i556, label %archx_str_concat.exit603, label %chk_bz.i557

chk_bz.i557:                                      ; preds = %archx_str_concat.exit549
  %tot.i559 = add nuw nsw i64 %alen.i555, 1
  %too_big.i560 = icmp samesign ugt i64 %alen.i555, 2147483646
  br i1 %too_big.i560, label %oom.i587, label %mat_a.i561

oom.i587:                                         ; preds = %alloc_heap.i573, %chk_bz.i557
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i561:                                       ; preds = %chk_bz.i557
  %ashort.i562 = icmp samesign ult i64 %alen.i555, 13
  br i1 %ashort.i562, label %mat_b.i566, label %mat_b.i566.thread

mat_b.i566.thread:                                ; preds = %mat_a.i561
  %araw.i564 = and i64 %aw1.i554, -4
  %alptr.i565 = inttoptr i64 %araw.i564 to ptr
  br label %alloc_heap.i573

mat_b.i566:                                       ; preds = %mat_a.i561
  %ap4.i598 = lshr i64 %aw0.i553, 32
  %ap4_32.i599 = trunc nuw i64 %ap4.i598 to i32
  store i32 %ap4_32.i599, ptr %atmp.i550, align 4
  %atmp4.i600 = getelementptr inbounds nuw i8, ptr %atmp.i550, i64 4
  store i64 %aw1.i554, ptr %atmp4.i600, align 4
  %fits_sso.i572.not = icmp eq i64 %alen.i555, 12
  br i1 %fits_sso.i572.not, label %alloc_heap.i573, label %build_sso.i588

build_sso.i588:                                   ; preds = %mat_b.i566
  %out_sso8.i589 = getelementptr inbounds nuw i8, ptr %out_sso.i552, i64 8
  %tot32.i590 = trunc nuw nsw i64 %tot.i559 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i552, i8 0, i64 16, i1 false)
  store i32 %tot32.i590, ptr %out_sso.i552, align 8
  %sso_dst_a.i591 = getelementptr inbounds nuw i8, ptr %out_sso.i552, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i591, ptr nonnull align 4 %atmp.i550, i64 %alen.i555, i1 false)
  %sso_dst_b.i592 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i591, i64 %alen.i555
  store i8 44, ptr %sso_dst_b.i592, align 1
  %rw0.i593 = load i64, ptr %out_sso.i552, align 8
  %rw1.i594 = load i64, ptr %out_sso8.i589, align 8
  %rs0.i595 = insertvalue %ArchxStr poison, i64 %rw0.i593, 0
  %rs1.i596 = insertvalue %ArchxStr %rs0.i595, i64 %rw1.i594, 1
  br label %archx_str_concat.exit603

alloc_heap.i573:                                  ; preds = %mat_b.i566.thread, %mat_b.i566
  %aptr.i5671872 = phi ptr [ %alptr.i565, %mat_b.i566.thread ], [ %atmp.i550, %mat_b.i566 ]
  %hp.i574 = call noalias align 16 ptr @malloc(i64 %tot.i559)
  %hnull.i575 = icmp eq ptr %hp.i574, null
  br i1 %hnull.i575, label %oom.i587, label %copy_long.i576

copy_long.i576:                                   ; preds = %alloc_heap.i573
  %hp_i.i577 = ptrtoint ptr %hp.i574 to i64
  %htagged.i578 = or disjoint i64 %hp_i.i577, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i574, ptr nonnull align 1 %aptr.i5671872, i64 %alen.i555, i1 false)
  %dst_b.i579 = getelementptr inbounds nuw i8, ptr %hp.i574, i64 %alen.i555
  store i8 44, ptr %dst_b.i579, align 1
  %pref32.i580 = load i32, ptr %hp.i574, align 16
  %pref64.i581 = zext i32 %pref32.i580 to i64
  %pref_sh.i582 = shl nuw i64 %pref64.i581, 32
  %w0_out.i583 = or disjoint i64 %pref_sh.i582, %tot.i559
  %ls0.i584 = insertvalue %ArchxStr poison, i64 %w0_out.i583, 0
  %ls1.i585 = insertvalue %ArchxStr %ls0.i584, i64 %htagged.i578, 1
  br label %archx_str_concat.exit603

archx_str_concat.exit603:                         ; preds = %archx_str_concat.exit549, %build_sso.i588, %copy_long.i576
  %common.ret.op.i586 = phi %ArchxStr [ %rs1.i596, %build_sso.i588 ], [ %ls1.i585, %copy_long.i576 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit549 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i550)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i552)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1425)
  %n32.i1426 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1425, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %var.hi.11.1.i.1)
  %len.i1427 = sext i32 %n32.i1426 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1424)
  %z.i.i1428 = icmp slt i32 %n32.i1426, 1
  br i1 %z.i.i1428, label %archx_str_from_int.exit1452, label %chk_sso.i.i1429

oom.i.i1444:                                      ; preds = %alloc_heap.i.i1431
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1429:                                  ; preds = %archx_str_concat.exit603
  %short.i.i1430 = icmp samesign ult i32 %n32.i1426, 13
  br i1 %short.i.i1430, label %pack_sso.i.i1445, label %alloc_heap.i.i1431

pack_sso.i.i1445:                                 ; preds = %chk_sso.i.i1429
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1424, i8 0, i64 16, i1 false)
  store i32 %n32.i1426, ptr %sso.i.i1424, align 8
  %sso.i.i1424.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1424, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1424.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1425, i64 %len.i1427, i1 false)
  %sso.i.i1424.0.sso.i.i1424.0.sso.i.i1424.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1447 = load i64, ptr %sso.i.i1424, align 8
  %sso.i.i1424.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1424, i64 8
  %sso.i.i1424.8.sso.i.i1424.8.sso.i.i1424.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1449 = load i64, ptr %sso.i.i1424.8.sroa_idx, align 8
  %ss0.i.i1450 = insertvalue %ArchxStr poison, i64 %sso.i.i1424.0.sso.i.i1424.0.sso.i.i1424.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1447, 0
  %ss1.i.i1451 = insertvalue %ArchxStr %ss0.i.i1450, i64 %sso.i.i1424.8.sso.i.i1424.8.sso.i.i1424.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1449, 1
  br label %archx_str_from_int.exit1452

alloc_heap.i.i1431:                               ; preds = %chk_sso.i.i1429
  %hp.i.i1432 = call noalias align 16 ptr @malloc(i64 %len.i1427)
  %hnull.i.i1433 = icmp eq ptr %hp.i.i1432, null
  br i1 %hnull.i.i1433, label %oom.i.i1444, label %copy_long.i.i1434

copy_long.i.i1434:                                ; preds = %alloc_heap.i.i1431
  %hp_i.i.i1435 = ptrtoint ptr %hp.i.i1432 to i64
  %htagged.i.i1436 = or disjoint i64 %hp_i.i.i1435, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1432, ptr nonnull readonly align 8 %buf.i1425, i64 %len.i1427, i1 false)
  %pref32.i.i1437 = load i32, ptr %hp.i.i1432, align 16
  %pref64.i.i1438 = zext i32 %pref32.i.i1437 to i64
  %pref_sh.i.i1439 = shl nuw i64 %pref64.i.i1438, 32
  %w0_out.i.i1440 = or disjoint i64 %pref_sh.i.i1439, %len.i1427
  %ls0.i.i1441 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1440, 0
  %ls1.i.i1442 = insertvalue %ArchxStr %ls0.i.i1441, i64 %htagged.i.i1436, 1
  br label %archx_str_from_int.exit1452

archx_str_from_int.exit1452:                      ; preds = %archx_str_concat.exit603, %pack_sso.i.i1445, %copy_long.i.i1434
  %common.ret.op.i.i1443 = phi %ArchxStr [ %ss1.i.i1451, %pack_sso.i.i1445 ], [ %ls1.i.i1442, %copy_long.i.i1434 ], [ zeroinitializer, %archx_str_concat.exit603 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1424)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1425)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i604)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i605)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i606)
  %aw0.i607 = extractvalue %ArchxStr %common.ret.op.i586, 0
  %aw1.i608 = extractvalue %ArchxStr %common.ret.op.i586, 1
  %bw0.i609 = extractvalue %ArchxStr %common.ret.op.i.i1443, 0
  %bw1.i610 = extractvalue %ArchxStr %common.ret.op.i.i1443, 1
  %alen.i611 = and i64 %aw0.i607, 4294967295
  %blen.i612 = and i64 %bw0.i609, 4294967295
  %az.i613 = icmp eq i64 %alen.i611, 0
  br i1 %az.i613, label %ret_b_clone.i667, label %chk_bz.i614

ret_b_clone.i667:                                 ; preds = %archx_str_from_int.exit1452
  %long.i1455 = icmp samesign ult i64 %blen.i612, 13
  %tag.i1459 = and i64 %bw1.i610, 3
  %owned.not.i1460 = icmp eq i64 %tag.i1459, 0
  %or.cond1889 = select i1 %long.i1455, i1 true, i1 %owned.not.i1460
  br i1 %or.cond1889, label %archx_str_concat.exit669, label %dup_heap.i1461

dup_heap.i1461:                                   ; preds = %ret_b_clone.i667
  %dst.i1462 = call noalias align 16 ptr @malloc(i64 %blen.i612)
  %isnull.i1463 = icmp eq ptr %dst.i1462, null
  br i1 %isnull.i1463, label %oom.i1470, label %copy.i1464

oom.i1470:                                        ; preds = %dup_heap.i1461
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1464:                                       ; preds = %dup_heap.i1461
  %src_i.i1465 = and i64 %bw1.i610, -4
  %src.i1466 = inttoptr i64 %src_i.i1465 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1462, ptr nonnull align 4 %src.i1466, i64 %blen.i612, i1 false)
  %dst_i.i1467 = ptrtoint ptr %dst.i1462 to i64
  %tagged.i1468 = or disjoint i64 %dst_i.i1467, 1
  %out.i1469 = insertvalue %ArchxStr %common.ret.op.i.i1443, i64 %tagged.i1468, 1
  br label %archx_str_concat.exit669

chk_bz.i614:                                      ; preds = %archx_str_from_int.exit1452
  %bz.i615 = icmp eq i64 %blen.i612, 0
  br i1 %bz.i615, label %ret_a_clone.i665, label %calc_tot.i616

ret_a_clone.i665:                                 ; preds = %chk_bz.i614
  %long.i1474 = icmp samesign ult i64 %alen.i611, 13
  %tag.i1478 = and i64 %aw1.i608, 3
  %owned.not.i1479 = icmp eq i64 %tag.i1478, 0
  %or.cond1890 = select i1 %long.i1474, i1 true, i1 %owned.not.i1479
  br i1 %or.cond1890, label %archx_str_concat.exit669, label %dup_heap.i1480

dup_heap.i1480:                                   ; preds = %ret_a_clone.i665
  %dst.i1481 = call noalias align 16 ptr @malloc(i64 %alen.i611)
  %isnull.i1482 = icmp eq ptr %dst.i1481, null
  br i1 %isnull.i1482, label %oom.i1489, label %copy.i1483

oom.i1489:                                        ; preds = %dup_heap.i1480
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1483:                                       ; preds = %dup_heap.i1480
  %src_i.i1484 = and i64 %aw1.i608, -4
  %src.i1485 = inttoptr i64 %src_i.i1484 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1481, ptr nonnull align 4 %src.i1485, i64 %alen.i611, i1 false)
  %dst_i.i1486 = ptrtoint ptr %dst.i1481 to i64
  %tagged.i1487 = or disjoint i64 %dst_i.i1486, 1
  %out.i1488 = insertvalue %ArchxStr %common.ret.op.i586, i64 %tagged.i1487, 1
  br label %archx_str_concat.exit669

calc_tot.i616:                                    ; preds = %chk_bz.i614
  %tot.i617 = add nuw nsw i64 %blen.i612, %alen.i611
  %too_big.i618 = icmp samesign ugt i64 %tot.i617, 2147483647
  br i1 %too_big.i618, label %oom.i647, label %mat_a.i619

oom.i647:                                         ; preds = %alloc_heap.i633, %calc_tot.i616
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i619:                                       ; preds = %calc_tot.i616
  %ashort.i620 = icmp samesign ult i64 %alen.i611, 13
  br i1 %ashort.i620, label %mat_a_short.i661, label %mat_a_long.i621

mat_a_short.i661:                                 ; preds = %mat_a.i619
  %ap4.i662 = lshr i64 %aw0.i607, 32
  %ap4_32.i663 = trunc nuw i64 %ap4.i662 to i32
  store i32 %ap4_32.i663, ptr %atmp.i604, align 4
  %atmp4.i664 = getelementptr inbounds nuw i8, ptr %atmp.i604, i64 4
  store i64 %aw1.i608, ptr %atmp4.i664, align 4
  br label %mat_b.i624

mat_a_long.i621:                                  ; preds = %mat_a.i619
  %araw.i622 = and i64 %aw1.i608, -4
  %alptr.i623 = inttoptr i64 %araw.i622 to ptr
  br label %mat_b.i624

mat_b.i624:                                       ; preds = %mat_a_long.i621, %mat_a_short.i661
  %aptr.i625 = phi ptr [ %atmp.i604, %mat_a_short.i661 ], [ %alptr.i623, %mat_a_long.i621 ]
  %bshort.i626 = icmp samesign ult i64 %blen.i612, 13
  br i1 %bshort.i626, label %mat_b_short.i657, label %mat_b_long.i627

mat_b_short.i657:                                 ; preds = %mat_b.i624
  %bp4.i658 = lshr i64 %bw0.i609, 32
  %bp4_32.i659 = trunc nuw i64 %bp4.i658 to i32
  store i32 %bp4_32.i659, ptr %btmp.i605, align 4
  %btmp4.i660 = getelementptr inbounds nuw i8, ptr %btmp.i605, i64 4
  store i64 %bw1.i610, ptr %btmp4.i660, align 4
  br label %build.i630

mat_b_long.i627:                                  ; preds = %mat_b.i624
  %braw.i628 = and i64 %bw1.i610, -4
  %blptr.i629 = inttoptr i64 %braw.i628 to ptr
  br label %build.i630

build.i630:                                       ; preds = %mat_b_long.i627, %mat_b_short.i657
  %bptr.i631 = phi ptr [ %btmp.i605, %mat_b_short.i657 ], [ %blptr.i629, %mat_b_long.i627 ]
  %fits_sso.i632 = icmp samesign ult i64 %tot.i617, 13
  br i1 %fits_sso.i632, label %build_sso.i648, label %alloc_heap.i633

build_sso.i648:                                   ; preds = %build.i630
  %out_sso8.i649 = getelementptr inbounds nuw i8, ptr %out_sso.i606, i64 8
  %tot32.i650 = trunc nuw nsw i64 %tot.i617 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i606, i8 0, i64 16, i1 false)
  store i32 %tot32.i650, ptr %out_sso.i606, align 8
  %sso_dst_a.i651 = getelementptr inbounds nuw i8, ptr %out_sso.i606, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i651, ptr nonnull align 1 %aptr.i625, i64 %alen.i611, i1 false)
  %sso_dst_b.i652 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i651, i64 %alen.i611
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i652, ptr nonnull align 1 %bptr.i631, i64 %blen.i612, i1 false)
  %rw0.i653 = load i64, ptr %out_sso.i606, align 8
  %rw1.i654 = load i64, ptr %out_sso8.i649, align 8
  %rs0.i655 = insertvalue %ArchxStr poison, i64 %rw0.i653, 0
  %rs1.i656 = insertvalue %ArchxStr %rs0.i655, i64 %rw1.i654, 1
  br label %archx_str_concat.exit669

alloc_heap.i633:                                  ; preds = %build.i630
  %hp.i634 = call noalias align 16 ptr @malloc(i64 %tot.i617)
  %hnull.i635 = icmp eq ptr %hp.i634, null
  br i1 %hnull.i635, label %oom.i647, label %copy_long.i636

copy_long.i636:                                   ; preds = %alloc_heap.i633
  %hp_i.i637 = ptrtoint ptr %hp.i634 to i64
  %htagged.i638 = or disjoint i64 %hp_i.i637, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i634, ptr nonnull align 1 %aptr.i625, i64 %alen.i611, i1 false)
  %dst_b.i639 = getelementptr inbounds nuw i8, ptr %hp.i634, i64 %alen.i611
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i639, ptr nonnull align 1 %bptr.i631, i64 %blen.i612, i1 false)
  %pref32.i640 = load i32, ptr %hp.i634, align 16
  %pref64.i641 = zext i32 %pref32.i640 to i64
  %pref_sh.i642 = shl nuw i64 %pref64.i641, 32
  %w0_out.i643 = or disjoint i64 %pref_sh.i642, %tot.i617
  %ls0.i644 = insertvalue %ArchxStr poison, i64 %w0_out.i643, 0
  %ls1.i645 = insertvalue %ArchxStr %ls0.i644, i64 %htagged.i638, 1
  br label %archx_str_concat.exit669

archx_str_concat.exit669:                         ; preds = %copy.i1483, %ret_a_clone.i665, %copy.i1464, %ret_b_clone.i667, %build_sso.i648, %copy_long.i636
  %common.ret.op.i646 = phi %ArchxStr [ %rs1.i656, %build_sso.i648 ], [ %ls1.i645, %copy_long.i636 ], [ %out.i1469, %copy.i1464 ], [ %common.ret.op.i.i1443, %ret_b_clone.i667 ], [ %out.i1488, %copy.i1483 ], [ %common.ret.op.i586, %ret_a_clone.i665 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i604)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i605)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i606)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i670)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i672)
  %aw0.i673 = extractvalue %ArchxStr %common.ret.op.i646, 0
  %aw1.i674 = extractvalue %ArchxStr %common.ret.op.i646, 1
  %alen.i675 = and i64 %aw0.i673, 4294967295
  %az.i676 = icmp eq i64 %alen.i675, 0
  br i1 %az.i676, label %archx_str_concat.exit723, label %chk_bz.i677

chk_bz.i677:                                      ; preds = %archx_str_concat.exit669
  %tot.i679 = add nuw nsw i64 %alen.i675, 1
  %too_big.i680 = icmp samesign ugt i64 %alen.i675, 2147483646
  br i1 %too_big.i680, label %oom.i707, label %mat_a.i681

oom.i707:                                         ; preds = %alloc_heap.i693, %chk_bz.i677
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i681:                                       ; preds = %chk_bz.i677
  %ashort.i682 = icmp samesign ult i64 %alen.i675, 13
  br i1 %ashort.i682, label %mat_b.i686, label %mat_b.i686.thread

mat_b.i686.thread:                                ; preds = %mat_a.i681
  %araw.i684 = and i64 %aw1.i674, -4
  %alptr.i685 = inttoptr i64 %araw.i684 to ptr
  br label %alloc_heap.i693

mat_b.i686:                                       ; preds = %mat_a.i681
  %ap4.i718 = lshr i64 %aw0.i673, 32
  %ap4_32.i719 = trunc nuw i64 %ap4.i718 to i32
  store i32 %ap4_32.i719, ptr %atmp.i670, align 4
  %atmp4.i720 = getelementptr inbounds nuw i8, ptr %atmp.i670, i64 4
  store i64 %aw1.i674, ptr %atmp4.i720, align 4
  %fits_sso.i692.not = icmp eq i64 %alen.i675, 12
  br i1 %fits_sso.i692.not, label %alloc_heap.i693, label %build_sso.i708

build_sso.i708:                                   ; preds = %mat_b.i686
  %out_sso8.i709 = getelementptr inbounds nuw i8, ptr %out_sso.i672, i64 8
  %tot32.i710 = trunc nuw nsw i64 %tot.i679 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i672, i8 0, i64 16, i1 false)
  store i32 %tot32.i710, ptr %out_sso.i672, align 8
  %sso_dst_a.i711 = getelementptr inbounds nuw i8, ptr %out_sso.i672, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i711, ptr nonnull align 4 %atmp.i670, i64 %alen.i675, i1 false)
  %sso_dst_b.i712 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i711, i64 %alen.i675
  store i8 44, ptr %sso_dst_b.i712, align 1
  %rw0.i713 = load i64, ptr %out_sso.i672, align 8
  %rw1.i714 = load i64, ptr %out_sso8.i709, align 8
  %rs0.i715 = insertvalue %ArchxStr poison, i64 %rw0.i713, 0
  %rs1.i716 = insertvalue %ArchxStr %rs0.i715, i64 %rw1.i714, 1
  br label %archx_str_concat.exit723

alloc_heap.i693:                                  ; preds = %mat_b.i686.thread, %mat_b.i686
  %aptr.i6871875 = phi ptr [ %alptr.i685, %mat_b.i686.thread ], [ %atmp.i670, %mat_b.i686 ]
  %hp.i694 = call noalias align 16 ptr @malloc(i64 %tot.i679)
  %hnull.i695 = icmp eq ptr %hp.i694, null
  br i1 %hnull.i695, label %oom.i707, label %copy_long.i696

copy_long.i696:                                   ; preds = %alloc_heap.i693
  %hp_i.i697 = ptrtoint ptr %hp.i694 to i64
  %htagged.i698 = or disjoint i64 %hp_i.i697, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i694, ptr nonnull align 1 %aptr.i6871875, i64 %alen.i675, i1 false)
  %dst_b.i699 = getelementptr inbounds nuw i8, ptr %hp.i694, i64 %alen.i675
  store i8 44, ptr %dst_b.i699, align 1
  %pref32.i700 = load i32, ptr %hp.i694, align 16
  %pref64.i701 = zext i32 %pref32.i700 to i64
  %pref_sh.i702 = shl nuw i64 %pref64.i701, 32
  %w0_out.i703 = or disjoint i64 %pref_sh.i702, %tot.i679
  %ls0.i704 = insertvalue %ArchxStr poison, i64 %w0_out.i703, 0
  %ls1.i705 = insertvalue %ArchxStr %ls0.i704, i64 %htagged.i698, 1
  br label %archx_str_concat.exit723

archx_str_concat.exit723:                         ; preds = %archx_str_concat.exit669, %build_sso.i708, %copy_long.i696
  %common.ret.op.i706 = phi %ArchxStr [ %rs1.i716, %build_sso.i708 ], [ %ls1.i705, %copy_long.i696 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit669 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i670)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i672)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1493)
  %n32.i1494 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1493, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t32.i1156.1)
  %len.i1495 = sext i32 %n32.i1494 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1492)
  %z.i.i1496 = icmp slt i32 %n32.i1494, 1
  br i1 %z.i.i1496, label %archx_str_from_int.exit1520, label %chk_sso.i.i1497

oom.i.i1512:                                      ; preds = %alloc_heap.i.i1499
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1497:                                  ; preds = %archx_str_concat.exit723
  %short.i.i1498 = icmp samesign ult i32 %n32.i1494, 13
  br i1 %short.i.i1498, label %pack_sso.i.i1513, label %alloc_heap.i.i1499

pack_sso.i.i1513:                                 ; preds = %chk_sso.i.i1497
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1492, i8 0, i64 16, i1 false)
  store i32 %n32.i1494, ptr %sso.i.i1492, align 8
  %sso.i.i1492.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1492, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1492.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1493, i64 %len.i1495, i1 false)
  %sso.i.i1492.0.sso.i.i1492.0.sso.i.i1492.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1515 = load i64, ptr %sso.i.i1492, align 8
  %sso.i.i1492.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1492, i64 8
  %sso.i.i1492.8.sso.i.i1492.8.sso.i.i1492.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1517 = load i64, ptr %sso.i.i1492.8.sroa_idx, align 8
  %ss0.i.i1518 = insertvalue %ArchxStr poison, i64 %sso.i.i1492.0.sso.i.i1492.0.sso.i.i1492.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1515, 0
  %ss1.i.i1519 = insertvalue %ArchxStr %ss0.i.i1518, i64 %sso.i.i1492.8.sso.i.i1492.8.sso.i.i1492.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1517, 1
  br label %archx_str_from_int.exit1520

alloc_heap.i.i1499:                               ; preds = %chk_sso.i.i1497
  %hp.i.i1500 = call noalias align 16 ptr @malloc(i64 %len.i1495)
  %hnull.i.i1501 = icmp eq ptr %hp.i.i1500, null
  br i1 %hnull.i.i1501, label %oom.i.i1512, label %copy_long.i.i1502

copy_long.i.i1502:                                ; preds = %alloc_heap.i.i1499
  %hp_i.i.i1503 = ptrtoint ptr %hp.i.i1500 to i64
  %htagged.i.i1504 = or disjoint i64 %hp_i.i.i1503, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1500, ptr nonnull readonly align 8 %buf.i1493, i64 %len.i1495, i1 false)
  %pref32.i.i1505 = load i32, ptr %hp.i.i1500, align 16
  %pref64.i.i1506 = zext i32 %pref32.i.i1505 to i64
  %pref_sh.i.i1507 = shl nuw i64 %pref64.i.i1506, 32
  %w0_out.i.i1508 = or disjoint i64 %pref_sh.i.i1507, %len.i1495
  %ls0.i.i1509 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1508, 0
  %ls1.i.i1510 = insertvalue %ArchxStr %ls0.i.i1509, i64 %htagged.i.i1504, 1
  br label %archx_str_from_int.exit1520

archx_str_from_int.exit1520:                      ; preds = %archx_str_concat.exit723, %pack_sso.i.i1513, %copy_long.i.i1502
  %common.ret.op.i.i1511 = phi %ArchxStr [ %ss1.i.i1519, %pack_sso.i.i1513 ], [ %ls1.i.i1510, %copy_long.i.i1502 ], [ zeroinitializer, %archx_str_concat.exit723 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1492)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1493)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i724)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i725)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i726)
  %aw0.i727 = extractvalue %ArchxStr %common.ret.op.i706, 0
  %aw1.i728 = extractvalue %ArchxStr %common.ret.op.i706, 1
  %bw0.i729 = extractvalue %ArchxStr %common.ret.op.i.i1511, 0
  %bw1.i730 = extractvalue %ArchxStr %common.ret.op.i.i1511, 1
  %alen.i731 = and i64 %aw0.i727, 4294967295
  %blen.i732 = and i64 %bw0.i729, 4294967295
  %az.i733 = icmp eq i64 %alen.i731, 0
  br i1 %az.i733, label %ret_b_clone.i787, label %chk_bz.i734

ret_b_clone.i787:                                 ; preds = %archx_str_from_int.exit1520
  %long.i1523 = icmp samesign ult i64 %blen.i732, 13
  %tag.i1527 = and i64 %bw1.i730, 3
  %owned.not.i1528 = icmp eq i64 %tag.i1527, 0
  %or.cond1891 = select i1 %long.i1523, i1 true, i1 %owned.not.i1528
  br i1 %or.cond1891, label %archx_str_concat.exit789, label %dup_heap.i1529

dup_heap.i1529:                                   ; preds = %ret_b_clone.i787
  %dst.i1530 = call noalias align 16 ptr @malloc(i64 %blen.i732)
  %isnull.i1531 = icmp eq ptr %dst.i1530, null
  br i1 %isnull.i1531, label %oom.i1538, label %copy.i1532

oom.i1538:                                        ; preds = %dup_heap.i1529
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1532:                                       ; preds = %dup_heap.i1529
  %src_i.i1533 = and i64 %bw1.i730, -4
  %src.i1534 = inttoptr i64 %src_i.i1533 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1530, ptr nonnull align 4 %src.i1534, i64 %blen.i732, i1 false)
  %dst_i.i1535 = ptrtoint ptr %dst.i1530 to i64
  %tagged.i1536 = or disjoint i64 %dst_i.i1535, 1
  %out.i1537 = insertvalue %ArchxStr %common.ret.op.i.i1511, i64 %tagged.i1536, 1
  br label %archx_str_concat.exit789

chk_bz.i734:                                      ; preds = %archx_str_from_int.exit1520
  %bz.i735 = icmp eq i64 %blen.i732, 0
  br i1 %bz.i735, label %ret_a_clone.i785, label %calc_tot.i736

ret_a_clone.i785:                                 ; preds = %chk_bz.i734
  %long.i1542 = icmp samesign ult i64 %alen.i731, 13
  %tag.i1546 = and i64 %aw1.i728, 3
  %owned.not.i1547 = icmp eq i64 %tag.i1546, 0
  %or.cond1892 = select i1 %long.i1542, i1 true, i1 %owned.not.i1547
  br i1 %or.cond1892, label %archx_str_concat.exit789, label %dup_heap.i1548

dup_heap.i1548:                                   ; preds = %ret_a_clone.i785
  %dst.i1549 = call noalias align 16 ptr @malloc(i64 %alen.i731)
  %isnull.i1550 = icmp eq ptr %dst.i1549, null
  br i1 %isnull.i1550, label %oom.i1557, label %copy.i1551

oom.i1557:                                        ; preds = %dup_heap.i1548
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1551:                                       ; preds = %dup_heap.i1548
  %src_i.i1552 = and i64 %aw1.i728, -4
  %src.i1553 = inttoptr i64 %src_i.i1552 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1549, ptr nonnull align 4 %src.i1553, i64 %alen.i731, i1 false)
  %dst_i.i1554 = ptrtoint ptr %dst.i1549 to i64
  %tagged.i1555 = or disjoint i64 %dst_i.i1554, 1
  %out.i1556 = insertvalue %ArchxStr %common.ret.op.i706, i64 %tagged.i1555, 1
  br label %archx_str_concat.exit789

calc_tot.i736:                                    ; preds = %chk_bz.i734
  %tot.i737 = add nuw nsw i64 %blen.i732, %alen.i731
  %too_big.i738 = icmp samesign ugt i64 %tot.i737, 2147483647
  br i1 %too_big.i738, label %oom.i767, label %mat_a.i739

oom.i767:                                         ; preds = %alloc_heap.i753, %calc_tot.i736
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i739:                                       ; preds = %calc_tot.i736
  %ashort.i740 = icmp samesign ult i64 %alen.i731, 13
  br i1 %ashort.i740, label %mat_a_short.i781, label %mat_a_long.i741

mat_a_short.i781:                                 ; preds = %mat_a.i739
  %ap4.i782 = lshr i64 %aw0.i727, 32
  %ap4_32.i783 = trunc nuw i64 %ap4.i782 to i32
  store i32 %ap4_32.i783, ptr %atmp.i724, align 4
  %atmp4.i784 = getelementptr inbounds nuw i8, ptr %atmp.i724, i64 4
  store i64 %aw1.i728, ptr %atmp4.i784, align 4
  br label %mat_b.i744

mat_a_long.i741:                                  ; preds = %mat_a.i739
  %araw.i742 = and i64 %aw1.i728, -4
  %alptr.i743 = inttoptr i64 %araw.i742 to ptr
  br label %mat_b.i744

mat_b.i744:                                       ; preds = %mat_a_long.i741, %mat_a_short.i781
  %aptr.i745 = phi ptr [ %atmp.i724, %mat_a_short.i781 ], [ %alptr.i743, %mat_a_long.i741 ]
  %bshort.i746 = icmp samesign ult i64 %blen.i732, 13
  br i1 %bshort.i746, label %mat_b_short.i777, label %mat_b_long.i747

mat_b_short.i777:                                 ; preds = %mat_b.i744
  %bp4.i778 = lshr i64 %bw0.i729, 32
  %bp4_32.i779 = trunc nuw i64 %bp4.i778 to i32
  store i32 %bp4_32.i779, ptr %btmp.i725, align 4
  %btmp4.i780 = getelementptr inbounds nuw i8, ptr %btmp.i725, i64 4
  store i64 %bw1.i730, ptr %btmp4.i780, align 4
  br label %build.i750

mat_b_long.i747:                                  ; preds = %mat_b.i744
  %braw.i748 = and i64 %bw1.i730, -4
  %blptr.i749 = inttoptr i64 %braw.i748 to ptr
  br label %build.i750

build.i750:                                       ; preds = %mat_b_long.i747, %mat_b_short.i777
  %bptr.i751 = phi ptr [ %btmp.i725, %mat_b_short.i777 ], [ %blptr.i749, %mat_b_long.i747 ]
  %fits_sso.i752 = icmp samesign ult i64 %tot.i737, 13
  br i1 %fits_sso.i752, label %build_sso.i768, label %alloc_heap.i753

build_sso.i768:                                   ; preds = %build.i750
  %out_sso8.i769 = getelementptr inbounds nuw i8, ptr %out_sso.i726, i64 8
  %tot32.i770 = trunc nuw nsw i64 %tot.i737 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i726, i8 0, i64 16, i1 false)
  store i32 %tot32.i770, ptr %out_sso.i726, align 8
  %sso_dst_a.i771 = getelementptr inbounds nuw i8, ptr %out_sso.i726, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i771, ptr nonnull align 1 %aptr.i745, i64 %alen.i731, i1 false)
  %sso_dst_b.i772 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i771, i64 %alen.i731
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i772, ptr nonnull align 1 %bptr.i751, i64 %blen.i732, i1 false)
  %rw0.i773 = load i64, ptr %out_sso.i726, align 8
  %rw1.i774 = load i64, ptr %out_sso8.i769, align 8
  %rs0.i775 = insertvalue %ArchxStr poison, i64 %rw0.i773, 0
  %rs1.i776 = insertvalue %ArchxStr %rs0.i775, i64 %rw1.i774, 1
  br label %archx_str_concat.exit789

alloc_heap.i753:                                  ; preds = %build.i750
  %hp.i754 = call noalias align 16 ptr @malloc(i64 %tot.i737)
  %hnull.i755 = icmp eq ptr %hp.i754, null
  br i1 %hnull.i755, label %oom.i767, label %copy_long.i756

copy_long.i756:                                   ; preds = %alloc_heap.i753
  %hp_i.i757 = ptrtoint ptr %hp.i754 to i64
  %htagged.i758 = or disjoint i64 %hp_i.i757, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i754, ptr nonnull align 1 %aptr.i745, i64 %alen.i731, i1 false)
  %dst_b.i759 = getelementptr inbounds nuw i8, ptr %hp.i754, i64 %alen.i731
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i759, ptr nonnull align 1 %bptr.i751, i64 %blen.i732, i1 false)
  %pref32.i760 = load i32, ptr %hp.i754, align 16
  %pref64.i761 = zext i32 %pref32.i760 to i64
  %pref_sh.i762 = shl nuw i64 %pref64.i761, 32
  %w0_out.i763 = or disjoint i64 %pref_sh.i762, %tot.i737
  %ls0.i764 = insertvalue %ArchxStr poison, i64 %w0_out.i763, 0
  %ls1.i765 = insertvalue %ArchxStr %ls0.i764, i64 %htagged.i758, 1
  br label %archx_str_concat.exit789

archx_str_concat.exit789:                         ; preds = %copy.i1551, %ret_a_clone.i785, %copy.i1532, %ret_b_clone.i787, %build_sso.i768, %copy_long.i756
  %common.ret.op.i766 = phi %ArchxStr [ %rs1.i776, %build_sso.i768 ], [ %ls1.i765, %copy_long.i756 ], [ %out.i1537, %copy.i1532 ], [ %common.ret.op.i.i1511, %ret_b_clone.i787 ], [ %out.i1556, %copy.i1551 ], [ %common.ret.op.i706, %ret_a_clone.i785 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i724)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i725)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i726)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i790)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i792)
  %aw0.i793 = extractvalue %ArchxStr %common.ret.op.i766, 0
  %aw1.i794 = extractvalue %ArchxStr %common.ret.op.i766, 1
  %alen.i795 = and i64 %aw0.i793, 4294967295
  %az.i796 = icmp eq i64 %alen.i795, 0
  br i1 %az.i796, label %archx_str_concat.exit843, label %chk_bz.i797

chk_bz.i797:                                      ; preds = %archx_str_concat.exit789
  %tot.i799 = add nuw nsw i64 %alen.i795, 1
  %too_big.i800 = icmp samesign ugt i64 %alen.i795, 2147483646
  br i1 %too_big.i800, label %oom.i827, label %mat_a.i801

oom.i827:                                         ; preds = %alloc_heap.i813, %chk_bz.i797
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i801:                                       ; preds = %chk_bz.i797
  %ashort.i802 = icmp samesign ult i64 %alen.i795, 13
  br i1 %ashort.i802, label %mat_b.i806, label %mat_b.i806.thread

mat_b.i806.thread:                                ; preds = %mat_a.i801
  %araw.i804 = and i64 %aw1.i794, -4
  %alptr.i805 = inttoptr i64 %araw.i804 to ptr
  br label %alloc_heap.i813

mat_b.i806:                                       ; preds = %mat_a.i801
  %ap4.i838 = lshr i64 %aw0.i793, 32
  %ap4_32.i839 = trunc nuw i64 %ap4.i838 to i32
  store i32 %ap4_32.i839, ptr %atmp.i790, align 4
  %atmp4.i840 = getelementptr inbounds nuw i8, ptr %atmp.i790, i64 4
  store i64 %aw1.i794, ptr %atmp4.i840, align 4
  %fits_sso.i812.not = icmp eq i64 %alen.i795, 12
  br i1 %fits_sso.i812.not, label %alloc_heap.i813, label %build_sso.i828

build_sso.i828:                                   ; preds = %mat_b.i806
  %out_sso8.i829 = getelementptr inbounds nuw i8, ptr %out_sso.i792, i64 8
  %tot32.i830 = trunc nuw nsw i64 %tot.i799 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i792, i8 0, i64 16, i1 false)
  store i32 %tot32.i830, ptr %out_sso.i792, align 8
  %sso_dst_a.i831 = getelementptr inbounds nuw i8, ptr %out_sso.i792, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i831, ptr nonnull align 4 %atmp.i790, i64 %alen.i795, i1 false)
  %sso_dst_b.i832 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i831, i64 %alen.i795
  store i8 44, ptr %sso_dst_b.i832, align 1
  %rw0.i833 = load i64, ptr %out_sso.i792, align 8
  %rw1.i834 = load i64, ptr %out_sso8.i829, align 8
  %rs0.i835 = insertvalue %ArchxStr poison, i64 %rw0.i833, 0
  %rs1.i836 = insertvalue %ArchxStr %rs0.i835, i64 %rw1.i834, 1
  br label %archx_str_concat.exit843

alloc_heap.i813:                                  ; preds = %mat_b.i806.thread, %mat_b.i806
  %aptr.i8071878 = phi ptr [ %alptr.i805, %mat_b.i806.thread ], [ %atmp.i790, %mat_b.i806 ]
  %hp.i814 = call noalias align 16 ptr @malloc(i64 %tot.i799)
  %hnull.i815 = icmp eq ptr %hp.i814, null
  br i1 %hnull.i815, label %oom.i827, label %copy_long.i816

copy_long.i816:                                   ; preds = %alloc_heap.i813
  %hp_i.i817 = ptrtoint ptr %hp.i814 to i64
  %htagged.i818 = or disjoint i64 %hp_i.i817, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i814, ptr nonnull align 1 %aptr.i8071878, i64 %alen.i795, i1 false)
  %dst_b.i819 = getelementptr inbounds nuw i8, ptr %hp.i814, i64 %alen.i795
  store i8 44, ptr %dst_b.i819, align 1
  %pref32.i820 = load i32, ptr %hp.i814, align 16
  %pref64.i821 = zext i32 %pref32.i820 to i64
  %pref_sh.i822 = shl nuw i64 %pref64.i821, 32
  %w0_out.i823 = or disjoint i64 %pref_sh.i822, %tot.i799
  %ls0.i824 = insertvalue %ArchxStr poison, i64 %w0_out.i823, 0
  %ls1.i825 = insertvalue %ArchxStr %ls0.i824, i64 %htagged.i818, 1
  br label %archx_str_concat.exit843

archx_str_concat.exit843:                         ; preds = %archx_str_concat.exit789, %build_sso.i828, %copy_long.i816
  %common.ret.op.i826 = phi %ArchxStr [ %rs1.i836, %build_sso.i828 ], [ %ls1.i825, %copy_long.i816 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit789 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i790)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i792)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i.i1561)
  %n32.i.i1563 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i.i1561, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %ifexpr.res.56.0)
  %len.i.i = sext i32 %n32.i.i1563 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i.i1560)
  %z.i.i.i1564 = icmp slt i32 %n32.i.i1563, 1
  br i1 %z.i.i.i1564, label %archx_any_to_str.exit, label %chk_sso.i.i.i1565

oom.i.i.i1581:                                    ; preds = %alloc_heap.i.i.i1567
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i.i1565:                                ; preds = %archx_str_concat.exit843
  %short.i.i.i1566 = icmp samesign ult i32 %n32.i.i1563, 13
  br i1 %short.i.i.i1566, label %pack_sso.i.i.i1582, label %alloc_heap.i.i.i1567

pack_sso.i.i.i1582:                               ; preds = %chk_sso.i.i.i1565
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i.i1560, i8 0, i64 16, i1 false)
  store i32 %n32.i.i1563, ptr %sso.i.i.i1560, align 8
  %sso.i.i.i1560.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i1560, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.i1560.4.sroa_idx, ptr nonnull readonly align 8 %buf.i.i1561, i64 %len.i.i, i1 false)
  %sso.i.i.i1560.0.sso.i.i.i1560.0.sso.i.i.i1560.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i.i1583 = load i64, ptr %sso.i.i.i1560, align 8
  %sso.i.i.i1560.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i1560, i64 8
  %sso.i.i.i1560.8.sso.i.i.i1560.8.sso.i.i.i1560.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i.i1584 = load i64, ptr %sso.i.i.i1560.8.sroa_idx, align 8
  %ss0.i.i.i1585 = insertvalue %ArchxStr poison, i64 %sso.i.i.i1560.0.sso.i.i.i1560.0.sso.i.i.i1560.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i.i1583, 0
  %ss1.i.i.i1586 = insertvalue %ArchxStr %ss0.i.i.i1585, i64 %sso.i.i.i1560.8.sso.i.i.i1560.8.sso.i.i.i1560.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i.i1584, 1
  br label %archx_any_to_str.exit

alloc_heap.i.i.i1567:                             ; preds = %chk_sso.i.i.i1565
  %hp.i.i.i1568 = call noalias align 16 ptr @malloc(i64 %len.i.i)
  %hnull.i.i.i1569 = icmp eq ptr %hp.i.i.i1568, null
  br i1 %hnull.i.i.i1569, label %oom.i.i.i1581, label %copy_long.i.i.i1570

copy_long.i.i.i1570:                              ; preds = %alloc_heap.i.i.i1567
  %hp_i.i.i.i1571 = ptrtoint ptr %hp.i.i.i1568 to i64
  %htagged.i.i.i1572 = or disjoint i64 %hp_i.i.i.i1571, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i.i1568, ptr nonnull readonly align 8 %buf.i.i1561, i64 %len.i.i, i1 false)
  %pref32.i.i.i1573 = load i32, ptr %hp.i.i.i1568, align 16
  %pref64.i.i.i1574 = zext i32 %pref32.i.i.i1573 to i64
  %pref_sh.i.i.i1575 = shl nuw i64 %pref64.i.i.i1574, 32
  %w0_out.i.i.i1576 = or disjoint i64 %pref_sh.i.i.i1575, %len.i.i
  %ls0.i.i.i1577 = insertvalue %ArchxStr poison, i64 %w0_out.i.i.i1576, 0
  %ls1.i.i.i1578 = insertvalue %ArchxStr %ls0.i.i.i1577, i64 %htagged.i.i.i1572, 1
  br label %archx_any_to_str.exit

archx_any_to_str.exit:                            ; preds = %archx_str_concat.exit843, %pack_sso.i.i.i1582, %copy_long.i.i.i1570
  %common.ret.op.i.i.i1580 = phi %ArchxStr [ %ss1.i.i.i1586, %pack_sso.i.i.i1582 ], [ %ls1.i.i.i1578, %copy_long.i.i.i1570 ], [ zeroinitializer, %archx_str_concat.exit843 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i.i1560)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i.i1561)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i844)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i845)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i846)
  %aw0.i847 = extractvalue %ArchxStr %common.ret.op.i826, 0
  %aw1.i848 = extractvalue %ArchxStr %common.ret.op.i826, 1
  %bw0.i849 = extractvalue %ArchxStr %common.ret.op.i.i.i1580, 0
  %bw1.i850 = extractvalue %ArchxStr %common.ret.op.i.i.i1580, 1
  %alen.i851 = and i64 %aw0.i847, 4294967295
  %blen.i852 = and i64 %bw0.i849, 4294967295
  %az.i853 = icmp eq i64 %alen.i851, 0
  br i1 %az.i853, label %ret_b_clone.i907, label %chk_bz.i854

ret_b_clone.i907:                                 ; preds = %archx_any_to_str.exit
  %long.i1589 = icmp samesign ult i64 %blen.i852, 13
  %tag.i1593 = and i64 %bw1.i850, 3
  %owned.not.i1594 = icmp eq i64 %tag.i1593, 0
  %or.cond1893 = select i1 %long.i1589, i1 true, i1 %owned.not.i1594
  br i1 %or.cond1893, label %archx_str_concat.exit909, label %dup_heap.i1595

dup_heap.i1595:                                   ; preds = %ret_b_clone.i907
  %dst.i1596 = call noalias align 16 ptr @malloc(i64 %blen.i852)
  %isnull.i1597 = icmp eq ptr %dst.i1596, null
  br i1 %isnull.i1597, label %oom.i1604, label %copy.i1598

oom.i1604:                                        ; preds = %dup_heap.i1595
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1598:                                       ; preds = %dup_heap.i1595
  %src_i.i1599 = and i64 %bw1.i850, -4
  %src.i1600 = inttoptr i64 %src_i.i1599 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1596, ptr nonnull align 4 %src.i1600, i64 %blen.i852, i1 false)
  %dst_i.i1601 = ptrtoint ptr %dst.i1596 to i64
  %tagged.i1602 = or disjoint i64 %dst_i.i1601, 1
  %out.i1603 = insertvalue %ArchxStr %common.ret.op.i.i.i1580, i64 %tagged.i1602, 1
  br label %archx_str_concat.exit909

chk_bz.i854:                                      ; preds = %archx_any_to_str.exit
  %bz.i855 = icmp eq i64 %blen.i852, 0
  br i1 %bz.i855, label %ret_a_clone.i905, label %calc_tot.i856

ret_a_clone.i905:                                 ; preds = %chk_bz.i854
  %long.i1608 = icmp samesign ult i64 %alen.i851, 13
  %tag.i1612 = and i64 %aw1.i848, 3
  %owned.not.i1613 = icmp eq i64 %tag.i1612, 0
  %or.cond1894 = select i1 %long.i1608, i1 true, i1 %owned.not.i1613
  br i1 %or.cond1894, label %archx_str_concat.exit909, label %dup_heap.i1614

dup_heap.i1614:                                   ; preds = %ret_a_clone.i905
  %dst.i1615 = call noalias align 16 ptr @malloc(i64 %alen.i851)
  %isnull.i1616 = icmp eq ptr %dst.i1615, null
  br i1 %isnull.i1616, label %oom.i1623, label %copy.i1617

oom.i1623:                                        ; preds = %dup_heap.i1614
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1617:                                       ; preds = %dup_heap.i1614
  %src_i.i1618 = and i64 %aw1.i848, -4
  %src.i1619 = inttoptr i64 %src_i.i1618 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1615, ptr nonnull align 4 %src.i1619, i64 %alen.i851, i1 false)
  %dst_i.i1620 = ptrtoint ptr %dst.i1615 to i64
  %tagged.i1621 = or disjoint i64 %dst_i.i1620, 1
  %out.i1622 = insertvalue %ArchxStr %common.ret.op.i826, i64 %tagged.i1621, 1
  br label %archx_str_concat.exit909

calc_tot.i856:                                    ; preds = %chk_bz.i854
  %tot.i857 = add nuw nsw i64 %blen.i852, %alen.i851
  %too_big.i858 = icmp samesign ugt i64 %tot.i857, 2147483647
  br i1 %too_big.i858, label %oom.i887, label %mat_a.i859

oom.i887:                                         ; preds = %alloc_heap.i873, %calc_tot.i856
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i859:                                       ; preds = %calc_tot.i856
  %ashort.i860 = icmp samesign ult i64 %alen.i851, 13
  br i1 %ashort.i860, label %mat_a_short.i901, label %mat_a_long.i861

mat_a_short.i901:                                 ; preds = %mat_a.i859
  %ap4.i902 = lshr i64 %aw0.i847, 32
  %ap4_32.i903 = trunc nuw i64 %ap4.i902 to i32
  store i32 %ap4_32.i903, ptr %atmp.i844, align 4
  %atmp4.i904 = getelementptr inbounds nuw i8, ptr %atmp.i844, i64 4
  store i64 %aw1.i848, ptr %atmp4.i904, align 4
  br label %mat_b.i864

mat_a_long.i861:                                  ; preds = %mat_a.i859
  %araw.i862 = and i64 %aw1.i848, -4
  %alptr.i863 = inttoptr i64 %araw.i862 to ptr
  br label %mat_b.i864

mat_b.i864:                                       ; preds = %mat_a_long.i861, %mat_a_short.i901
  %aptr.i865 = phi ptr [ %atmp.i844, %mat_a_short.i901 ], [ %alptr.i863, %mat_a_long.i861 ]
  %bshort.i866 = icmp samesign ult i64 %blen.i852, 13
  br i1 %bshort.i866, label %mat_b_short.i897, label %mat_b_long.i867

mat_b_short.i897:                                 ; preds = %mat_b.i864
  %bp4.i898 = lshr i64 %bw0.i849, 32
  %bp4_32.i899 = trunc nuw i64 %bp4.i898 to i32
  store i32 %bp4_32.i899, ptr %btmp.i845, align 4
  %btmp4.i900 = getelementptr inbounds nuw i8, ptr %btmp.i845, i64 4
  store i64 %bw1.i850, ptr %btmp4.i900, align 4
  br label %build.i870

mat_b_long.i867:                                  ; preds = %mat_b.i864
  %braw.i868 = and i64 %bw1.i850, -4
  %blptr.i869 = inttoptr i64 %braw.i868 to ptr
  br label %build.i870

build.i870:                                       ; preds = %mat_b_long.i867, %mat_b_short.i897
  %bptr.i871 = phi ptr [ %btmp.i845, %mat_b_short.i897 ], [ %blptr.i869, %mat_b_long.i867 ]
  %fits_sso.i872 = icmp samesign ult i64 %tot.i857, 13
  br i1 %fits_sso.i872, label %build_sso.i888, label %alloc_heap.i873

build_sso.i888:                                   ; preds = %build.i870
  %out_sso8.i889 = getelementptr inbounds nuw i8, ptr %out_sso.i846, i64 8
  %tot32.i890 = trunc nuw nsw i64 %tot.i857 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i846, i8 0, i64 16, i1 false)
  store i32 %tot32.i890, ptr %out_sso.i846, align 8
  %sso_dst_a.i891 = getelementptr inbounds nuw i8, ptr %out_sso.i846, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i891, ptr nonnull align 1 %aptr.i865, i64 %alen.i851, i1 false)
  %sso_dst_b.i892 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i891, i64 %alen.i851
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i892, ptr nonnull align 1 %bptr.i871, i64 %blen.i852, i1 false)
  %rw0.i893 = load i64, ptr %out_sso.i846, align 8
  %rw1.i894 = load i64, ptr %out_sso8.i889, align 8
  %rs0.i895 = insertvalue %ArchxStr poison, i64 %rw0.i893, 0
  %rs1.i896 = insertvalue %ArchxStr %rs0.i895, i64 %rw1.i894, 1
  br label %archx_str_concat.exit909

alloc_heap.i873:                                  ; preds = %build.i870
  %hp.i874 = call noalias align 16 ptr @malloc(i64 %tot.i857)
  %hnull.i875 = icmp eq ptr %hp.i874, null
  br i1 %hnull.i875, label %oom.i887, label %copy_long.i876

copy_long.i876:                                   ; preds = %alloc_heap.i873
  %hp_i.i877 = ptrtoint ptr %hp.i874 to i64
  %htagged.i878 = or disjoint i64 %hp_i.i877, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i874, ptr nonnull align 1 %aptr.i865, i64 %alen.i851, i1 false)
  %dst_b.i879 = getelementptr inbounds nuw i8, ptr %hp.i874, i64 %alen.i851
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i879, ptr nonnull align 1 %bptr.i871, i64 %blen.i852, i1 false)
  %pref32.i880 = load i32, ptr %hp.i874, align 16
  %pref64.i881 = zext i32 %pref32.i880 to i64
  %pref_sh.i882 = shl nuw i64 %pref64.i881, 32
  %w0_out.i883 = or disjoint i64 %pref_sh.i882, %tot.i857
  %ls0.i884 = insertvalue %ArchxStr poison, i64 %w0_out.i883, 0
  %ls1.i885 = insertvalue %ArchxStr %ls0.i884, i64 %htagged.i878, 1
  br label %archx_str_concat.exit909

archx_str_concat.exit909:                         ; preds = %copy.i1617, %ret_a_clone.i905, %copy.i1598, %ret_b_clone.i907, %build_sso.i888, %copy_long.i876
  %common.ret.op.i886 = phi %ArchxStr [ %rs1.i896, %build_sso.i888 ], [ %ls1.i885, %copy_long.i876 ], [ %out.i1603, %copy.i1598 ], [ %common.ret.op.i.i.i1580, %ret_b_clone.i907 ], [ %out.i1622, %copy.i1617 ], [ %common.ret.op.i826, %ret_a_clone.i905 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i844)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i845)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i846)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i910)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i912)
  %aw0.i913 = extractvalue %ArchxStr %common.ret.op.i886, 0
  %aw1.i914 = extractvalue %ArchxStr %common.ret.op.i886, 1
  %alen.i915 = and i64 %aw0.i913, 4294967295
  %az.i916 = icmp eq i64 %alen.i915, 0
  br i1 %az.i916, label %archx_str_concat.exit963, label %chk_bz.i917

chk_bz.i917:                                      ; preds = %archx_str_concat.exit909
  %tot.i919 = add nuw nsw i64 %alen.i915, 1
  %too_big.i920 = icmp samesign ugt i64 %alen.i915, 2147483646
  br i1 %too_big.i920, label %oom.i947, label %mat_a.i921

oom.i947:                                         ; preds = %alloc_heap.i933, %chk_bz.i917
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i921:                                       ; preds = %chk_bz.i917
  %ashort.i922 = icmp samesign ult i64 %alen.i915, 13
  br i1 %ashort.i922, label %mat_b.i926, label %mat_b.i926.thread

mat_b.i926.thread:                                ; preds = %mat_a.i921
  %araw.i924 = and i64 %aw1.i914, -4
  %alptr.i925 = inttoptr i64 %araw.i924 to ptr
  br label %alloc_heap.i933

mat_b.i926:                                       ; preds = %mat_a.i921
  %ap4.i958 = lshr i64 %aw0.i913, 32
  %ap4_32.i959 = trunc nuw i64 %ap4.i958 to i32
  store i32 %ap4_32.i959, ptr %atmp.i910, align 4
  %atmp4.i960 = getelementptr inbounds nuw i8, ptr %atmp.i910, i64 4
  store i64 %aw1.i914, ptr %atmp4.i960, align 4
  %fits_sso.i932.not = icmp eq i64 %alen.i915, 12
  br i1 %fits_sso.i932.not, label %alloc_heap.i933, label %build_sso.i948

build_sso.i948:                                   ; preds = %mat_b.i926
  %out_sso8.i949 = getelementptr inbounds nuw i8, ptr %out_sso.i912, i64 8
  %tot32.i950 = trunc nuw nsw i64 %tot.i919 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i912, i8 0, i64 16, i1 false)
  store i32 %tot32.i950, ptr %out_sso.i912, align 8
  %sso_dst_a.i951 = getelementptr inbounds nuw i8, ptr %out_sso.i912, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i951, ptr nonnull align 4 %atmp.i910, i64 %alen.i915, i1 false)
  %sso_dst_b.i952 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i951, i64 %alen.i915
  store i8 44, ptr %sso_dst_b.i952, align 1
  %rw0.i953 = load i64, ptr %out_sso.i912, align 8
  %rw1.i954 = load i64, ptr %out_sso8.i949, align 8
  %rs0.i955 = insertvalue %ArchxStr poison, i64 %rw0.i953, 0
  %rs1.i956 = insertvalue %ArchxStr %rs0.i955, i64 %rw1.i954, 1
  br label %archx_str_concat.exit963

alloc_heap.i933:                                  ; preds = %mat_b.i926.thread, %mat_b.i926
  %aptr.i9271881 = phi ptr [ %alptr.i925, %mat_b.i926.thread ], [ %atmp.i910, %mat_b.i926 ]
  %hp.i934 = call noalias align 16 ptr @malloc(i64 %tot.i919)
  %hnull.i935 = icmp eq ptr %hp.i934, null
  br i1 %hnull.i935, label %oom.i947, label %copy_long.i936

copy_long.i936:                                   ; preds = %alloc_heap.i933
  %hp_i.i937 = ptrtoint ptr %hp.i934 to i64
  %htagged.i938 = or disjoint i64 %hp_i.i937, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i934, ptr nonnull align 1 %aptr.i9271881, i64 %alen.i915, i1 false)
  %dst_b.i939 = getelementptr inbounds nuw i8, ptr %hp.i934, i64 %alen.i915
  store i8 44, ptr %dst_b.i939, align 1
  %pref32.i940 = load i32, ptr %hp.i934, align 16
  %pref64.i941 = zext i32 %pref32.i940 to i64
  %pref_sh.i942 = shl nuw i64 %pref64.i941, 32
  %w0_out.i943 = or disjoint i64 %pref_sh.i942, %tot.i919
  %ls0.i944 = insertvalue %ArchxStr poison, i64 %w0_out.i943, 0
  %ls1.i945 = insertvalue %ArchxStr %ls0.i944, i64 %htagged.i938, 1
  br label %archx_str_concat.exit963

archx_str_concat.exit963:                         ; preds = %archx_str_concat.exit909, %build_sso.i948, %copy_long.i936
  %common.ret.op.i946 = phi %ArchxStr [ %rs1.i956, %build_sso.i948 ], [ %ls1.i945, %copy_long.i936 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit909 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i910)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i912)
  %t96.fca.0.insert = insertvalue %ArchxStr poison, i64 %var.miss_label.61.sroa.0.0, 0
  %t96.fca.1.insert = insertvalue %ArchxStr %t96.fca.0.insert, i64 %var.miss_label.61.sroa.7.0, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i964)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i965)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i966)
  %aw0.i967 = extractvalue %ArchxStr %common.ret.op.i946, 0
  %aw1.i968 = extractvalue %ArchxStr %common.ret.op.i946, 1
  %alen.i971 = and i64 %aw0.i967, 4294967295
  %blen.i972 = and i64 %var.miss_label.61.sroa.0.0, 4294967295
  %az.i973 = icmp eq i64 %alen.i971, 0
  br i1 %az.i973, label %ret_b_clone.i1027, label %chk_bz.i974

ret_b_clone.i1027:                                ; preds = %archx_str_concat.exit963
  %long.i1628 = icmp samesign ult i64 %blen.i972, 13
  %tag.i1632 = and i64 %var.miss_label.61.sroa.7.0, 3
  %owned.not.i1633 = icmp eq i64 %tag.i1632, 0
  %or.cond1895 = select i1 %long.i1628, i1 true, i1 %owned.not.i1633
  br i1 %or.cond1895, label %archx_str_concat.exit1029, label %dup_heap.i1634

dup_heap.i1634:                                   ; preds = %ret_b_clone.i1027
  %dst.i1635 = call noalias align 16 ptr @malloc(i64 %blen.i972)
  %isnull.i1636 = icmp eq ptr %dst.i1635, null
  br i1 %isnull.i1636, label %oom.i1643, label %copy.i1637

oom.i1643:                                        ; preds = %dup_heap.i1634
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1637:                                       ; preds = %dup_heap.i1634
  %src_i.i1638 = and i64 %var.miss_label.61.sroa.7.0, -4
  %src.i1639 = inttoptr i64 %src_i.i1638 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1635, ptr nonnull align 4 %src.i1639, i64 %blen.i972, i1 false)
  %dst_i.i1640 = ptrtoint ptr %dst.i1635 to i64
  %tagged.i1641 = or disjoint i64 %dst_i.i1640, 1
  %out.i1642 = insertvalue %ArchxStr %t96.fca.1.insert, i64 %tagged.i1641, 1
  br label %archx_str_concat.exit1029

chk_bz.i974:                                      ; preds = %archx_str_concat.exit963
  %bz.i975 = icmp eq i64 %blen.i972, 0
  br i1 %bz.i975, label %ret_a_clone.i1025, label %calc_tot.i976

ret_a_clone.i1025:                                ; preds = %chk_bz.i974
  %long.i1647 = icmp samesign ult i64 %alen.i971, 13
  %tag.i1651 = and i64 %aw1.i968, 3
  %owned.not.i1652 = icmp eq i64 %tag.i1651, 0
  %or.cond1896 = select i1 %long.i1647, i1 true, i1 %owned.not.i1652
  br i1 %or.cond1896, label %archx_str_concat.exit1029, label %dup_heap.i1653

dup_heap.i1653:                                   ; preds = %ret_a_clone.i1025
  %dst.i1654 = call noalias align 16 ptr @malloc(i64 %alen.i971)
  %isnull.i1655 = icmp eq ptr %dst.i1654, null
  br i1 %isnull.i1655, label %oom.i1662, label %copy.i1656

oom.i1662:                                        ; preds = %dup_heap.i1653
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1656:                                       ; preds = %dup_heap.i1653
  %src_i.i1657 = and i64 %aw1.i968, -4
  %src.i1658 = inttoptr i64 %src_i.i1657 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1654, ptr nonnull align 4 %src.i1658, i64 %alen.i971, i1 false)
  %dst_i.i1659 = ptrtoint ptr %dst.i1654 to i64
  %tagged.i1660 = or disjoint i64 %dst_i.i1659, 1
  %out.i1661 = insertvalue %ArchxStr %common.ret.op.i946, i64 %tagged.i1660, 1
  br label %archx_str_concat.exit1029

calc_tot.i976:                                    ; preds = %chk_bz.i974
  %tot.i977 = add nuw nsw i64 %alen.i971, %blen.i972
  %too_big.i978 = icmp samesign ugt i64 %tot.i977, 2147483647
  br i1 %too_big.i978, label %oom.i1007, label %mat_a.i979

oom.i1007:                                        ; preds = %alloc_heap.i993, %calc_tot.i976
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i979:                                       ; preds = %calc_tot.i976
  %ashort.i980 = icmp samesign ult i64 %alen.i971, 13
  br i1 %ashort.i980, label %mat_a_short.i1021, label %mat_a_long.i981

mat_a_short.i1021:                                ; preds = %mat_a.i979
  %ap4.i1022 = lshr i64 %aw0.i967, 32
  %ap4_32.i1023 = trunc nuw i64 %ap4.i1022 to i32
  store i32 %ap4_32.i1023, ptr %atmp.i964, align 4
  %atmp4.i1024 = getelementptr inbounds nuw i8, ptr %atmp.i964, i64 4
  store i64 %aw1.i968, ptr %atmp4.i1024, align 4
  br label %mat_b.i984

mat_a_long.i981:                                  ; preds = %mat_a.i979
  %araw.i982 = and i64 %aw1.i968, -4
  %alptr.i983 = inttoptr i64 %araw.i982 to ptr
  br label %mat_b.i984

mat_b.i984:                                       ; preds = %mat_a_long.i981, %mat_a_short.i1021
  %aptr.i985 = phi ptr [ %atmp.i964, %mat_a_short.i1021 ], [ %alptr.i983, %mat_a_long.i981 ]
  %bshort.i986 = icmp samesign ult i64 %blen.i972, 13
  br i1 %bshort.i986, label %mat_b_short.i1017, label %mat_b_long.i987

mat_b_short.i1017:                                ; preds = %mat_b.i984
  %bp4.i1018 = lshr i64 %var.miss_label.61.sroa.0.0, 32
  %bp4_32.i1019 = trunc nuw nsw i64 %bp4.i1018 to i32
  store i32 %bp4_32.i1019, ptr %btmp.i965, align 4
  %btmp4.i1020 = getelementptr inbounds nuw i8, ptr %btmp.i965, i64 4
  store i64 %var.miss_label.61.sroa.7.0, ptr %btmp4.i1020, align 4
  br label %build.i990

mat_b_long.i987:                                  ; preds = %mat_b.i984
  %braw.i988 = and i64 %var.miss_label.61.sroa.7.0, -4
  %blptr.i989 = inttoptr i64 %braw.i988 to ptr
  br label %build.i990

build.i990:                                       ; preds = %mat_b_long.i987, %mat_b_short.i1017
  %bptr.i991 = phi ptr [ %btmp.i965, %mat_b_short.i1017 ], [ %blptr.i989, %mat_b_long.i987 ]
  %fits_sso.i992 = icmp samesign ult i64 %tot.i977, 13
  br i1 %fits_sso.i992, label %build_sso.i1008, label %alloc_heap.i993

build_sso.i1008:                                  ; preds = %build.i990
  %out_sso8.i1009 = getelementptr inbounds nuw i8, ptr %out_sso.i966, i64 8
  %tot32.i1010 = trunc nuw nsw i64 %tot.i977 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i966, i8 0, i64 16, i1 false)
  store i32 %tot32.i1010, ptr %out_sso.i966, align 8
  %sso_dst_a.i1011 = getelementptr inbounds nuw i8, ptr %out_sso.i966, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1011, ptr nonnull align 1 %aptr.i985, i64 %alen.i971, i1 false)
  %sso_dst_b.i1012 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1011, i64 %alen.i971
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i1012, ptr nonnull align 1 %bptr.i991, i64 %blen.i972, i1 false)
  %rw0.i1013 = load i64, ptr %out_sso.i966, align 8
  %rw1.i1014 = load i64, ptr %out_sso8.i1009, align 8
  %rs0.i1015 = insertvalue %ArchxStr poison, i64 %rw0.i1013, 0
  %rs1.i1016 = insertvalue %ArchxStr %rs0.i1015, i64 %rw1.i1014, 1
  br label %archx_str_concat.exit1029

alloc_heap.i993:                                  ; preds = %build.i990
  %hp.i994 = call noalias align 16 ptr @malloc(i64 %tot.i977)
  %hnull.i995 = icmp eq ptr %hp.i994, null
  br i1 %hnull.i995, label %oom.i1007, label %copy_long.i996

copy_long.i996:                                   ; preds = %alloc_heap.i993
  %hp_i.i997 = ptrtoint ptr %hp.i994 to i64
  %htagged.i998 = or disjoint i64 %hp_i.i997, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i994, ptr nonnull align 1 %aptr.i985, i64 %alen.i971, i1 false)
  %dst_b.i999 = getelementptr inbounds nuw i8, ptr %hp.i994, i64 %alen.i971
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i999, ptr nonnull align 1 %bptr.i991, i64 %blen.i972, i1 false)
  %pref32.i1000 = load i32, ptr %hp.i994, align 16
  %pref64.i1001 = zext i32 %pref32.i1000 to i64
  %pref_sh.i1002 = shl nuw i64 %pref64.i1001, 32
  %w0_out.i1003 = or disjoint i64 %pref_sh.i1002, %tot.i977
  %ls0.i1004 = insertvalue %ArchxStr poison, i64 %w0_out.i1003, 0
  %ls1.i1005 = insertvalue %ArchxStr %ls0.i1004, i64 %htagged.i998, 1
  br label %archx_str_concat.exit1029

archx_str_concat.exit1029:                        ; preds = %copy.i1656, %ret_a_clone.i1025, %copy.i1637, %ret_b_clone.i1027, %build_sso.i1008, %copy_long.i996
  %common.ret.op.i1006 = phi %ArchxStr [ %rs1.i1016, %build_sso.i1008 ], [ %ls1.i1005, %copy_long.i996 ], [ %out.i1642, %copy.i1637 ], [ %t96.fca.1.insert, %ret_b_clone.i1027 ], [ %out.i1661, %copy.i1656 ], [ %common.ret.op.i946, %ret_a_clone.i1025 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i964)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i965)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i966)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1664)
  %w0.i1665 = extractvalue %ArchxStr %common.ret.op.i1006, 0
  %w1.i1666 = extractvalue %ArchxStr %common.ret.op.i1006, 1
  %len.i1667 = and i64 %w0.i1665, 4294967295
  %short.i1668 = icmp samesign ult i64 %len.i1667, 13
  br i1 %short.i1668, label %emit.i1689, label %emit.thread.i1669

emit.thread.i1669:                                ; preds = %archx_str_concat.exit1029
  %raw.i1670 = and i64 %w1.i1666, -4
  %lptr.i1671 = inttoptr i64 %raw.i1670 to ptr
  br label %chk_nul.i1672

emit.i1689:                                       ; preds = %archx_str_concat.exit1029
  %p4.i1690 = lshr i64 %w0.i1665, 32
  %p4_32.i1691 = trunc nuw i64 %p4.i1690 to i32
  store i32 %p4_32.i1691, ptr %tmp.i1664, align 4
  %tmp4.i1692 = getelementptr inbounds nuw i8, ptr %tmp.i1664, i64 4
  store i64 %w1.i1666, ptr %tmp4.i1692, align 4
  %pos.not.i1693 = icmp eq i64 %len.i1667, 0
  br i1 %pos.not.i1693, label %do_nl.i1684, label %chk_nul.i1672

chk_nul.i1672:                                    ; preds = %emit.i1689, %emit.thread.i1669
  %data3.i1673 = phi ptr [ %lptr.i1671, %emit.thread.i1669 ], [ %tmp.i1664, %emit.i1689 ]
  %nul.i1674 = call ptr @memchr(ptr nonnull %data3.i1673, i32 0, i64 %len.i1667)
  %has_nul.not.i1675 = icmp eq ptr %nul.i1674, null
  br i1 %has_nul.not.i1675, label %fast_printf.i1686, label %byte_loop.i1676

fast_printf.i1686:                                ; preds = %chk_nul.i1672
  %len32.i1687 = trunc i64 %w0.i1665 to i32
  %np.i1688 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1687, ptr nonnull %data3.i1673)
  br label %archx_str_print.exit1694

byte_loop.i1676:                                  ; preds = %chk_nul.i1672, %byte_loop.i1676
  %bi.i1677 = phi i64 [ %bnext.i1682, %byte_loop.i1676 ], [ 0, %chk_nul.i1672 ]
  %bp.i1678 = getelementptr inbounds nuw i8, ptr %data3.i1673, i64 %bi.i1677
  %ch8.i1679 = load i8, ptr %bp.i1678, align 1
  %ch32.i1680 = zext i8 %ch8.i1679 to i32
  %pc.i1681 = call i32 @putchar(i32 %ch32.i1680)
  %bnext.i1682 = add nuw nsw i64 %bi.i1677, 1
  %exitcond.not.i1683 = icmp eq i64 %bnext.i1682, %len.i1667
  br i1 %exitcond.not.i1683, label %do_nl.i1684, label %byte_loop.i1676

do_nl.i1684:                                      ; preds = %byte_loop.i1676, %emit.i1689
  %nc.i1685 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1694

archx_str_print.exit1694:                         ; preds = %fast_printf.i1686, %do_nl.i1684
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1664)
  %tag.i88 = and i64 %w1.i1666, 1
  %owned.not.i89 = icmp eq i64 %tag.i88, 0
  %or.cond1897 = select i1 %short.i1668, i1 true, i1 %owned.not.i89
  br i1 %or.cond1897, label %archx_str_drop.exit93, label %do_free.i90

do_free.i90:                                      ; preds = %archx_str_print.exit1694
  %raw.i91 = and i64 %w1.i1666, -2
  %ptr.i92 = inttoptr i64 %raw.i91 to ptr
  call void @free(ptr %ptr.i92)
  br label %archx_str_drop.exit93

archx_str_drop.exit93:                            ; preds = %archx_str_print.exit1694, %do_free.i90
  %long.i96 = icmp samesign ult i64 %alen.i971, 13
  %tag.i99 = and i64 %aw1.i968, 1
  %owned.not.i100 = icmp eq i64 %tag.i99, 0
  %or.cond1898 = select i1 %long.i96, i1 true, i1 %owned.not.i100
  br i1 %or.cond1898, label %archx_str_drop.exit104, label %do_free.i101

do_free.i101:                                     ; preds = %archx_str_drop.exit93
  %raw.i102 = and i64 %aw1.i968, -2
  %ptr.i103 = inttoptr i64 %raw.i102 to ptr
  call void @free(ptr %ptr.i103)
  br label %archx_str_drop.exit104

archx_str_drop.exit104:                           ; preds = %archx_str_drop.exit93, %do_free.i101
  %long.i107 = icmp samesign ult i64 %alen.i915, 13
  %tag.i110 = and i64 %aw1.i914, 1
  %owned.not.i111 = icmp eq i64 %tag.i110, 0
  %or.cond1899 = select i1 %long.i107, i1 true, i1 %owned.not.i111
  br i1 %or.cond1899, label %archx_str_drop.exit115, label %do_free.i112

do_free.i112:                                     ; preds = %archx_str_drop.exit104
  %raw.i113 = and i64 %aw1.i914, -2
  %ptr.i114 = inttoptr i64 %raw.i113 to ptr
  call void @free(ptr %ptr.i114)
  br label %archx_str_drop.exit115

archx_str_drop.exit115:                           ; preds = %archx_str_drop.exit104, %do_free.i112
  %long.i118 = icmp samesign ult i64 %blen.i852, 13
  %tag.i121 = and i64 %bw1.i850, 1
  %owned.not.i122 = icmp eq i64 %tag.i121, 0
  %or.cond1900 = select i1 %long.i118, i1 true, i1 %owned.not.i122
  br i1 %or.cond1900, label %archx_str_drop.exit126, label %do_free.i123

do_free.i123:                                     ; preds = %archx_str_drop.exit115
  %raw.i124 = and i64 %bw1.i850, -2
  %ptr.i125 = inttoptr i64 %raw.i124 to ptr
  call void @free(ptr %ptr.i125)
  br label %archx_str_drop.exit126

archx_str_drop.exit126:                           ; preds = %archx_str_drop.exit115, %do_free.i123
  %long.i129 = icmp samesign ult i64 %alen.i851, 13
  %tag.i132 = and i64 %aw1.i848, 1
  %owned.not.i133 = icmp eq i64 %tag.i132, 0
  %or.cond1901 = select i1 %long.i129, i1 true, i1 %owned.not.i133
  br i1 %or.cond1901, label %archx_str_drop.exit137, label %do_free.i134

do_free.i134:                                     ; preds = %archx_str_drop.exit126
  %raw.i135 = and i64 %aw1.i848, -2
  %ptr.i136 = inttoptr i64 %raw.i135 to ptr
  call void @free(ptr %ptr.i136)
  br label %archx_str_drop.exit137

archx_str_drop.exit137:                           ; preds = %archx_str_drop.exit126, %do_free.i134
  %long.i140 = icmp samesign ult i64 %alen.i795, 13
  %tag.i143 = and i64 %aw1.i794, 1
  %owned.not.i144 = icmp eq i64 %tag.i143, 0
  %or.cond1902 = select i1 %long.i140, i1 true, i1 %owned.not.i144
  br i1 %or.cond1902, label %archx_str_drop.exit148, label %do_free.i145

do_free.i145:                                     ; preds = %archx_str_drop.exit137
  %raw.i146 = and i64 %aw1.i794, -2
  %ptr.i147 = inttoptr i64 %raw.i146 to ptr
  call void @free(ptr %ptr.i147)
  br label %archx_str_drop.exit148

archx_str_drop.exit148:                           ; preds = %archx_str_drop.exit137, %do_free.i145
  %long.i151 = icmp samesign ult i64 %blen.i732, 13
  %tag.i154 = and i64 %bw1.i730, 1
  %owned.not.i155 = icmp eq i64 %tag.i154, 0
  %or.cond1903 = select i1 %long.i151, i1 true, i1 %owned.not.i155
  br i1 %or.cond1903, label %archx_str_drop.exit159, label %do_free.i156

do_free.i156:                                     ; preds = %archx_str_drop.exit148
  %raw.i157 = and i64 %bw1.i730, -2
  %ptr.i158 = inttoptr i64 %raw.i157 to ptr
  call void @free(ptr %ptr.i158)
  br label %archx_str_drop.exit159

archx_str_drop.exit159:                           ; preds = %archx_str_drop.exit148, %do_free.i156
  %long.i162 = icmp samesign ult i64 %alen.i731, 13
  %tag.i165 = and i64 %aw1.i728, 1
  %owned.not.i166 = icmp eq i64 %tag.i165, 0
  %or.cond1904 = select i1 %long.i162, i1 true, i1 %owned.not.i166
  br i1 %or.cond1904, label %archx_str_drop.exit170, label %do_free.i167

do_free.i167:                                     ; preds = %archx_str_drop.exit159
  %raw.i168 = and i64 %aw1.i728, -2
  %ptr.i169 = inttoptr i64 %raw.i168 to ptr
  call void @free(ptr %ptr.i169)
  br label %archx_str_drop.exit170

archx_str_drop.exit170:                           ; preds = %archx_str_drop.exit159, %do_free.i167
  %long.i173 = icmp samesign ult i64 %alen.i675, 13
  %tag.i176 = and i64 %aw1.i674, 1
  %owned.not.i177 = icmp eq i64 %tag.i176, 0
  %or.cond1905 = select i1 %long.i173, i1 true, i1 %owned.not.i177
  br i1 %or.cond1905, label %archx_str_drop.exit181, label %do_free.i178

do_free.i178:                                     ; preds = %archx_str_drop.exit170
  %raw.i179 = and i64 %aw1.i674, -2
  %ptr.i180 = inttoptr i64 %raw.i179 to ptr
  call void @free(ptr %ptr.i180)
  br label %archx_str_drop.exit181

archx_str_drop.exit181:                           ; preds = %archx_str_drop.exit170, %do_free.i178
  %long.i184 = icmp samesign ult i64 %blen.i612, 13
  %tag.i187 = and i64 %bw1.i610, 1
  %owned.not.i188 = icmp eq i64 %tag.i187, 0
  %or.cond1906 = select i1 %long.i184, i1 true, i1 %owned.not.i188
  br i1 %or.cond1906, label %archx_str_drop.exit192, label %do_free.i189

do_free.i189:                                     ; preds = %archx_str_drop.exit181
  %raw.i190 = and i64 %bw1.i610, -2
  %ptr.i191 = inttoptr i64 %raw.i190 to ptr
  call void @free(ptr %ptr.i191)
  br label %archx_str_drop.exit192

archx_str_drop.exit192:                           ; preds = %archx_str_drop.exit181, %do_free.i189
  %long.i195 = icmp samesign ult i64 %alen.i611, 13
  %tag.i198 = and i64 %aw1.i608, 1
  %owned.not.i199 = icmp eq i64 %tag.i198, 0
  %or.cond1907 = select i1 %long.i195, i1 true, i1 %owned.not.i199
  br i1 %or.cond1907, label %archx_str_drop.exit203, label %do_free.i200

do_free.i200:                                     ; preds = %archx_str_drop.exit192
  %raw.i201 = and i64 %aw1.i608, -2
  %ptr.i202 = inttoptr i64 %raw.i201 to ptr
  call void @free(ptr %ptr.i202)
  br label %archx_str_drop.exit203

archx_str_drop.exit203:                           ; preds = %archx_str_drop.exit192, %do_free.i200
  %long.i206 = icmp samesign ult i64 %alen.i555, 13
  %tag.i209 = and i64 %aw1.i554, 1
  %owned.not.i210 = icmp eq i64 %tag.i209, 0
  %or.cond1908 = select i1 %long.i206, i1 true, i1 %owned.not.i210
  br i1 %or.cond1908, label %archx_str_drop.exit214, label %do_free.i211

do_free.i211:                                     ; preds = %archx_str_drop.exit203
  %raw.i212 = and i64 %aw1.i554, -2
  %ptr.i213 = inttoptr i64 %raw.i212 to ptr
  call void @free(ptr %ptr.i213)
  br label %archx_str_drop.exit214

archx_str_drop.exit214:                           ; preds = %archx_str_drop.exit203, %do_free.i211
  %long.i217 = icmp samesign ult i64 %blen.i501, 13
  %tag.i220 = and i64 %bw1.i500, 1
  %owned.not.i221 = icmp eq i64 %tag.i220, 0
  %or.cond1909 = select i1 %long.i217, i1 true, i1 %owned.not.i221
  br i1 %or.cond1909, label %archx_str_drop.exit225, label %do_free.i222

do_free.i222:                                     ; preds = %archx_str_drop.exit214
  %raw.i223 = and i64 %bw1.i500, -2
  %ptr.i224 = inttoptr i64 %raw.i223 to ptr
  call void @free(ptr %ptr.i224)
  br label %archx_str_drop.exit225

archx_str_drop.exit225:                           ; preds = %archx_str_drop.exit214, %do_free.i222
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1696)
  %n32.i1697 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1696, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %var.acc.0.1.i)
  %len.i1698 = sext i32 %n32.i1697 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1695)
  %z.i.i1699 = icmp slt i32 %n32.i1697, 1
  br i1 %z.i.i1699, label %archx_str_from_int.exit1723, label %chk_sso.i.i1700

oom.i.i1715:                                      ; preds = %alloc_heap.i.i1702
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1700:                                  ; preds = %archx_str_drop.exit225
  %short.i.i1701 = icmp samesign ult i32 %n32.i1697, 13
  br i1 %short.i.i1701, label %pack_sso.i.i1716, label %alloc_heap.i.i1702

pack_sso.i.i1716:                                 ; preds = %chk_sso.i.i1700
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1695, i8 0, i64 16, i1 false)
  store i32 %n32.i1697, ptr %sso.i.i1695, align 8
  %sso.i.i1695.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1695, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1695.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1696, i64 %len.i1698, i1 false)
  %sso.i.i1695.0.sso.i.i1695.0.sso.i.i1695.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1718 = load i64, ptr %sso.i.i1695, align 8
  %sso.i.i1695.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1695, i64 8
  %sso.i.i1695.8.sso.i.i1695.8.sso.i.i1695.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1720 = load i64, ptr %sso.i.i1695.8.sroa_idx, align 8
  %ss0.i.i1721 = insertvalue %ArchxStr poison, i64 %sso.i.i1695.0.sso.i.i1695.0.sso.i.i1695.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1718, 0
  %ss1.i.i1722 = insertvalue %ArchxStr %ss0.i.i1721, i64 %sso.i.i1695.8.sso.i.i1695.8.sso.i.i1695.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1720, 1
  br label %archx_str_from_int.exit1723

alloc_heap.i.i1702:                               ; preds = %chk_sso.i.i1700
  %hp.i.i1703 = call noalias align 16 ptr @malloc(i64 %len.i1698)
  %hnull.i.i1704 = icmp eq ptr %hp.i.i1703, null
  br i1 %hnull.i.i1704, label %oom.i.i1715, label %copy_long.i.i1705

copy_long.i.i1705:                                ; preds = %alloc_heap.i.i1702
  %hp_i.i.i1706 = ptrtoint ptr %hp.i.i1703 to i64
  %htagged.i.i1707 = or disjoint i64 %hp_i.i.i1706, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1703, ptr nonnull readonly align 8 %buf.i1696, i64 %len.i1698, i1 false)
  %pref32.i.i1708 = load i32, ptr %hp.i.i1703, align 16
  %pref64.i.i1709 = zext i32 %pref32.i.i1708 to i64
  %pref_sh.i.i1710 = shl nuw i64 %pref64.i.i1709, 32
  %w0_out.i.i1711 = or disjoint i64 %pref_sh.i.i1710, %len.i1698
  %ls0.i.i1712 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1711, 0
  %ls1.i.i1713 = insertvalue %ArchxStr %ls0.i.i1712, i64 %htagged.i.i1707, 1
  br label %archx_str_from_int.exit1723

archx_str_from_int.exit1723:                      ; preds = %archx_str_drop.exit225, %pack_sso.i.i1716, %copy_long.i.i1705
  %common.ret.op.i.i1714 = phi %ArchxStr [ %ss1.i.i1722, %pack_sso.i.i1716 ], [ %ls1.i.i1713, %copy_long.i.i1705 ], [ zeroinitializer, %archx_str_drop.exit225 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1695)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1696)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1031)
  %bw0.i1033 = extractvalue %ArchxStr %common.ret.op.i.i1714, 0
  %bw1.i1034 = extractvalue %ArchxStr %common.ret.op.i.i1714, 1
  %blen.i1035 = and i64 %bw0.i1033, 4294967295
  %bz.i1037 = icmp eq i64 %blen.i1035, 0
  br i1 %bz.i1037, label %archx_str_concat.exit1082, label %calc_tot.i1038

calc_tot.i1038:                                   ; preds = %archx_str_from_int.exit1723
  %tot.i1039 = add nuw nsw i64 %blen.i1035, 15
  %too_big.i1040 = icmp samesign ugt i64 %blen.i1035, 2147483632
  br i1 %too_big.i1040, label %oom.i1066, label %mat_a.i1041

oom.i1066:                                        ; preds = %alloc_heap.i1052, %calc_tot.i1038
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1041:                                      ; preds = %calc_tot.i1038
  %bshort.i1045 = icmp samesign ult i64 %blen.i1035, 13
  br i1 %bshort.i1045, label %mat_b_short.i1076, label %mat_b_long.i1046

mat_b_short.i1076:                                ; preds = %mat_a.i1041
  %bp4.i1077 = lshr i64 %bw0.i1033, 32
  %bp4_32.i1078 = trunc nuw i64 %bp4.i1077 to i32
  store i32 %bp4_32.i1078, ptr %btmp.i1031, align 4
  %btmp4.i1079 = getelementptr inbounds nuw i8, ptr %btmp.i1031, i64 4
  store i64 %bw1.i1034, ptr %btmp4.i1079, align 4
  br label %alloc_heap.i1052

mat_b_long.i1046:                                 ; preds = %mat_a.i1041
  %braw.i1047 = and i64 %bw1.i1034, -4
  %blptr.i1048 = inttoptr i64 %braw.i1047 to ptr
  br label %alloc_heap.i1052

alloc_heap.i1052:                                 ; preds = %mat_b_short.i1076, %mat_b_long.i1046
  %bptr.i1050 = phi ptr [ %btmp.i1031, %mat_b_short.i1076 ], [ %blptr.i1048, %mat_b_long.i1046 ]
  %hp.i1053 = call noalias align 16 ptr @malloc(i64 %tot.i1039)
  %hnull.i1054 = icmp eq ptr %hp.i1053, null
  br i1 %hnull.i1054, label %oom.i1066, label %copy_long.i1055

copy_long.i1055:                                  ; preds = %alloc_heap.i1052
  %hp_i.i1056 = ptrtoint ptr %hp.i1053 to i64
  %htagged.i1057 = or disjoint i64 %hp_i.i1056, 1
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(15) %hp.i1053, ptr noundef nonnull align 4 dereferenceable(15) @.str.3, i64 15, i1 false)
  %dst_b.i1058 = getelementptr inbounds nuw i8, ptr %hp.i1053, i64 15
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i1058, ptr nonnull align 1 %bptr.i1050, i64 %blen.i1035, i1 false)
  %w0_out.i1062 = or disjoint i64 %tot.i1039, 7166460027832631296
  %ls0.i1063 = insertvalue %ArchxStr poison, i64 %w0_out.i1062, 0
  %ls1.i1064 = insertvalue %ArchxStr %ls0.i1063, i64 %htagged.i1057, 1
  br label %archx_str_concat.exit1082

archx_str_concat.exit1082:                        ; preds = %archx_str_from_int.exit1723, %copy_long.i1055
  %common.ret.op.i1065 = phi %ArchxStr [ %ls1.i1064, %copy_long.i1055 ], [ { i64 7166460027832631311, i64 ptrtoint (ptr @.str.3 to i64) }, %archx_str_from_int.exit1723 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1031)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1726)
  %w0.i1727 = extractvalue %ArchxStr %common.ret.op.i1065, 0
  %w1.i1728 = extractvalue %ArchxStr %common.ret.op.i1065, 1
  %len.i1729 = and i64 %w0.i1727, 4294967295
  %short.i1730 = icmp samesign ult i64 %len.i1729, 13
  br i1 %short.i1730, label %emit.i1751, label %emit.thread.i1731

emit.thread.i1731:                                ; preds = %archx_str_concat.exit1082
  %raw.i1732 = and i64 %w1.i1728, -4
  %lptr.i1733 = inttoptr i64 %raw.i1732 to ptr
  br label %chk_nul.i1734

emit.i1751:                                       ; preds = %archx_str_concat.exit1082
  %p4.i1752 = lshr i64 %w0.i1727, 32
  %p4_32.i1753 = trunc nuw i64 %p4.i1752 to i32
  store i32 %p4_32.i1753, ptr %tmp.i1726, align 4
  %tmp4.i1754 = getelementptr inbounds nuw i8, ptr %tmp.i1726, i64 4
  store i64 %w1.i1728, ptr %tmp4.i1754, align 4
  %pos.not.i1755 = icmp eq i64 %len.i1729, 0
  br i1 %pos.not.i1755, label %do_nl.i1746, label %chk_nul.i1734

chk_nul.i1734:                                    ; preds = %emit.i1751, %emit.thread.i1731
  %data3.i1735 = phi ptr [ %lptr.i1733, %emit.thread.i1731 ], [ %tmp.i1726, %emit.i1751 ]
  %nul.i1736 = call ptr @memchr(ptr nonnull %data3.i1735, i32 0, i64 %len.i1729)
  %has_nul.not.i1737 = icmp eq ptr %nul.i1736, null
  br i1 %has_nul.not.i1737, label %fast_printf.i1748, label %byte_loop.i1738

fast_printf.i1748:                                ; preds = %chk_nul.i1734
  %len32.i1749 = trunc i64 %w0.i1727 to i32
  %np.i1750 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1749, ptr nonnull %data3.i1735)
  br label %archx_str_print.exit1756

byte_loop.i1738:                                  ; preds = %chk_nul.i1734, %byte_loop.i1738
  %bi.i1739 = phi i64 [ %bnext.i1744, %byte_loop.i1738 ], [ 0, %chk_nul.i1734 ]
  %bp.i1740 = getelementptr inbounds nuw i8, ptr %data3.i1735, i64 %bi.i1739
  %ch8.i1741 = load i8, ptr %bp.i1740, align 1
  %ch32.i1742 = zext i8 %ch8.i1741 to i32
  %pc.i1743 = call i32 @putchar(i32 %ch32.i1742)
  %bnext.i1744 = add nuw nsw i64 %bi.i1739, 1
  %exitcond.not.i1745 = icmp eq i64 %bnext.i1744, %len.i1729
  br i1 %exitcond.not.i1745, label %do_nl.i1746, label %byte_loop.i1738

do_nl.i1746:                                      ; preds = %byte_loop.i1738, %emit.i1751
  %nc.i1747 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1756

archx_str_print.exit1756:                         ; preds = %fast_printf.i1748, %do_nl.i1746
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1726)
  %tag.i231 = and i64 %w1.i1728, 1
  %owned.not.i232 = icmp eq i64 %tag.i231, 0
  %or.cond1910 = select i1 %short.i1730, i1 true, i1 %owned.not.i232
  br i1 %or.cond1910, label %archx_str_drop.exit236, label %do_free.i233

do_free.i233:                                     ; preds = %archx_str_print.exit1756
  %raw.i234 = and i64 %w1.i1728, -2
  %ptr.i235 = inttoptr i64 %raw.i234 to ptr
  call void @free(ptr %ptr.i235)
  br label %archx_str_drop.exit236

archx_str_drop.exit236:                           ; preds = %archx_str_print.exit1756, %do_free.i233
  %long.i239 = icmp samesign ult i64 %blen.i1035, 13
  %tag.i242 = and i64 %bw1.i1034, 1
  %owned.not.i243 = icmp eq i64 %tag.i242, 0
  %or.cond1911 = select i1 %long.i239, i1 true, i1 %owned.not.i243
  br i1 %or.cond1911, label %archx_str_drop.exit247, label %do_free.i244

do_free.i244:                                     ; preds = %archx_str_drop.exit236
  %raw.i245 = and i64 %bw1.i1034, -2
  %ptr.i246 = inttoptr i64 %raw.i245 to ptr
  call void @free(ptr %ptr.i246)
  br label %archx_str_drop.exit247

archx_str_drop.exit247:                           ; preds = %archx_str_drop.exit236, %do_free.i244
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1758)
  %n32.i1759 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1758, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t1105.i)
  %len.i1760 = sext i32 %n32.i1759 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1757)
  %z.i.i1761 = icmp slt i32 %n32.i1759, 1
  br i1 %z.i.i1761, label %archx_str_from_int.exit1785, label %chk_sso.i.i1762

oom.i.i1777:                                      ; preds = %alloc_heap.i.i1764
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1762:                                  ; preds = %archx_str_drop.exit247
  %short.i.i1763 = icmp samesign ult i32 %n32.i1759, 13
  br i1 %short.i.i1763, label %pack_sso.i.i1778, label %alloc_heap.i.i1764

pack_sso.i.i1778:                                 ; preds = %chk_sso.i.i1762
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1757, i8 0, i64 16, i1 false)
  store i32 %n32.i1759, ptr %sso.i.i1757, align 8
  %sso.i.i1757.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1757, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1757.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1758, i64 %len.i1760, i1 false)
  %sso.i.i1757.0.sso.i.i1757.0.sso.i.i1757.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1780 = load i64, ptr %sso.i.i1757, align 8
  %sso.i.i1757.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1757, i64 8
  %sso.i.i1757.8.sso.i.i1757.8.sso.i.i1757.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1782 = load i64, ptr %sso.i.i1757.8.sroa_idx, align 8
  %ss0.i.i1783 = insertvalue %ArchxStr poison, i64 %sso.i.i1757.0.sso.i.i1757.0.sso.i.i1757.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1780, 0
  %ss1.i.i1784 = insertvalue %ArchxStr %ss0.i.i1783, i64 %sso.i.i1757.8.sso.i.i1757.8.sso.i.i1757.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1782, 1
  br label %archx_str_from_int.exit1785

alloc_heap.i.i1764:                               ; preds = %chk_sso.i.i1762
  %hp.i.i1765 = call noalias align 16 ptr @malloc(i64 %len.i1760)
  %hnull.i.i1766 = icmp eq ptr %hp.i.i1765, null
  br i1 %hnull.i.i1766, label %oom.i.i1777, label %copy_long.i.i1767

copy_long.i.i1767:                                ; preds = %alloc_heap.i.i1764
  %hp_i.i.i1768 = ptrtoint ptr %hp.i.i1765 to i64
  %htagged.i.i1769 = or disjoint i64 %hp_i.i.i1768, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1765, ptr nonnull readonly align 8 %buf.i1758, i64 %len.i1760, i1 false)
  %pref32.i.i1770 = load i32, ptr %hp.i.i1765, align 16
  %pref64.i.i1771 = zext i32 %pref32.i.i1770 to i64
  %pref_sh.i.i1772 = shl nuw i64 %pref64.i.i1771, 32
  %w0_out.i.i1773 = or disjoint i64 %pref_sh.i.i1772, %len.i1760
  %ls0.i.i1774 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1773, 0
  %ls1.i.i1775 = insertvalue %ArchxStr %ls0.i.i1774, i64 %htagged.i.i1769, 1
  br label %archx_str_from_int.exit1785

archx_str_from_int.exit1785:                      ; preds = %archx_str_drop.exit247, %pack_sso.i.i1778, %copy_long.i.i1767
  %common.ret.op.i.i1776 = phi %ArchxStr [ %ss1.i.i1784, %pack_sso.i.i1778 ], [ %ls1.i.i1775, %copy_long.i.i1767 ], [ zeroinitializer, %archx_str_drop.exit247 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1757)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1758)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1084)
  %bw0.i1086 = extractvalue %ArchxStr %common.ret.op.i.i1776, 0
  %bw1.i1087 = extractvalue %ArchxStr %common.ret.op.i.i1776, 1
  %blen.i1088 = and i64 %bw0.i1086, 4294967295
  %bz.i1090 = icmp eq i64 %blen.i1088, 0
  br i1 %bz.i1090, label %archx_str_concat.exit1136, label %calc_tot.i1091

calc_tot.i1091:                                   ; preds = %archx_str_from_int.exit1785
  %tot.i1092 = add nuw nsw i64 %blen.i1088, 9
  %too_big.i1093 = icmp samesign ugt i64 %blen.i1088, 2147483638
  br i1 %too_big.i1093, label %oom.i1120, label %mat_a.i1094

oom.i1120:                                        ; preds = %alloc_heap.i1106, %calc_tot.i1091
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1094:                                      ; preds = %calc_tot.i1091
  %bshort.i1099 = icmp samesign ult i64 %blen.i1088, 13
  br i1 %bshort.i1099, label %build.i1103, label %build.i1103.thread

build.i1103.thread:                               ; preds = %mat_a.i1094
  %braw.i1101 = and i64 %bw1.i1087, -4
  %blptr.i1102 = inttoptr i64 %braw.i1101 to ptr
  br label %alloc_heap.i1106

build.i1103:                                      ; preds = %mat_a.i1094
  %bp4.i1131 = lshr i64 %bw0.i1086, 32
  %bp4_32.i1132 = trunc nuw i64 %bp4.i1131 to i32
  store i32 %bp4_32.i1132, ptr %btmp.i1084, align 4
  %btmp4.i1133 = getelementptr inbounds nuw i8, ptr %btmp.i1084, i64 4
  store i64 %bw1.i1087, ptr %btmp4.i1133, align 4
  %fits_sso.i1105 = icmp samesign ult i64 %blen.i1088, 4
  br i1 %fits_sso.i1105, label %build_sso.i1121, label %alloc_heap.i1106

build_sso.i1121:                                  ; preds = %build.i1103
  store i24 0, ptr %out_sso.i1085.sroa.6.sroa.5.sroa.0, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %out_sso.i1085.sroa.6.sroa.5.sroa.0, ptr nonnull align 4 %btmp.i1084, i64 %blen.i1088, i1 false)
  %out_sso.i1085.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i1092, 7309458124979568640
  %out_sso.i1085.sroa.6.sroa.5.sroa.0.0.out_sso.i1085.sroa.6.sroa.5.sroa.0.0.out_sso.i1085.sroa.6.sroa.5.sroa.0.0.out_sso.i1085.sroa.6.sroa.5.sroa.0.0.out_sso.i1085.sroa.6.sroa.5.0.out_sso.i1085.sroa.6.8.rw1.i1127 = load i24, ptr %out_sso.i1085.sroa.6.sroa.5.sroa.0, align 4
  %out_sso.i1085.sroa.6.sroa.5.0.insert.ext = zext i24 %out_sso.i1085.sroa.6.sroa.5.sroa.0.0.out_sso.i1085.sroa.6.sroa.5.sroa.0.0.out_sso.i1085.sroa.6.sroa.5.sroa.0.0.out_sso.i1085.sroa.6.sroa.5.sroa.0.0.out_sso.i1085.sroa.6.sroa.5.0.out_sso.i1085.sroa.6.8.rw1.i1127 to i64
  %out_sso.i1085.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i1085.sroa.6.sroa.5.0.insert.ext, 40
  %out_sso.i1085.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i1085.sroa.6.sroa.5.0.insert.shift, 263694739820
  %rs0.i1128 = insertvalue %ArchxStr poison, i64 %out_sso.i1085.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i1129 = insertvalue %ArchxStr %rs0.i1128, i64 %out_sso.i1085.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit1136

alloc_heap.i1106:                                 ; preds = %build.i1103.thread, %build.i1103
  %bptr.i11041992 = phi ptr [ %blptr.i1102, %build.i1103.thread ], [ %btmp.i1084, %build.i1103 ]
  %hp.i1107 = call noalias align 16 ptr @malloc(i64 %tot.i1092)
  %hnull.i1108 = icmp eq ptr %hp.i1107, null
  br i1 %hnull.i1108, label %oom.i1120, label %copy_long.i1109

copy_long.i1109:                                  ; preds = %alloc_heap.i1106
  %hp_i.i1110 = ptrtoint ptr %hp.i1107 to i64
  %htagged.i1111 = or disjoint i64 %hp_i.i1110, 1
  store i32 1701865840, ptr %hp.i1107, align 16
  %atmp.i1083.sroa.5.0.hp.i1107.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i1107, i64 4
  store i40 263694739820, ptr %atmp.i1083.sroa.5.0.hp.i1107.sroa_idx, align 4
  %dst_b.i1112 = getelementptr inbounds nuw i8, ptr %hp.i1107, i64 9
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i1112, ptr nonnull align 1 %bptr.i11041992, i64 %blen.i1088, i1 false)
  %w0_out.i1116 = or disjoint i64 %tot.i1092, 7309458124979568640
  %ls0.i1117 = insertvalue %ArchxStr poison, i64 %w0_out.i1116, 0
  %ls1.i1118 = insertvalue %ArchxStr %ls0.i1117, i64 %htagged.i1111, 1
  br label %archx_str_concat.exit1136

archx_str_concat.exit1136:                        ; preds = %archx_str_from_int.exit1785, %build_sso.i1121, %copy_long.i1109
  %common.ret.op.i1119 = phi %ArchxStr [ %rs1.i1129, %build_sso.i1121 ], [ %ls1.i1118, %copy_long.i1109 ], [ { i64 7309458124979568649, i64 263694739820 }, %archx_str_from_int.exit1785 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1084)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1787)
  %w0.i1788 = extractvalue %ArchxStr %common.ret.op.i1119, 0
  %w1.i1789 = extractvalue %ArchxStr %common.ret.op.i1119, 1
  %len.i1790 = and i64 %w0.i1788, 4294967295
  %short.i1791 = icmp samesign ult i64 %len.i1790, 13
  br i1 %short.i1791, label %emit.i1812, label %emit.thread.i1792

emit.thread.i1792:                                ; preds = %archx_str_concat.exit1136
  %raw.i1793 = and i64 %w1.i1789, -4
  %lptr.i1794 = inttoptr i64 %raw.i1793 to ptr
  br label %chk_nul.i1795

emit.i1812:                                       ; preds = %archx_str_concat.exit1136
  %p4.i1813 = lshr i64 %w0.i1788, 32
  %p4_32.i1814 = trunc nuw i64 %p4.i1813 to i32
  store i32 %p4_32.i1814, ptr %tmp.i1787, align 4
  %tmp4.i1815 = getelementptr inbounds nuw i8, ptr %tmp.i1787, i64 4
  store i64 %w1.i1789, ptr %tmp4.i1815, align 4
  %pos.not.i1816 = icmp eq i64 %len.i1790, 0
  br i1 %pos.not.i1816, label %do_nl.i1807, label %chk_nul.i1795

chk_nul.i1795:                                    ; preds = %emit.i1812, %emit.thread.i1792
  %data3.i1796 = phi ptr [ %lptr.i1794, %emit.thread.i1792 ], [ %tmp.i1787, %emit.i1812 ]
  %nul.i1797 = call ptr @memchr(ptr nonnull %data3.i1796, i32 0, i64 %len.i1790)
  %has_nul.not.i1798 = icmp eq ptr %nul.i1797, null
  br i1 %has_nul.not.i1798, label %fast_printf.i1809, label %byte_loop.i1799

fast_printf.i1809:                                ; preds = %chk_nul.i1795
  %len32.i1810 = trunc i64 %w0.i1788 to i32
  %np.i1811 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1810, ptr nonnull %data3.i1796)
  br label %archx_str_print.exit1817

byte_loop.i1799:                                  ; preds = %chk_nul.i1795, %byte_loop.i1799
  %bi.i1800 = phi i64 [ %bnext.i1805, %byte_loop.i1799 ], [ 0, %chk_nul.i1795 ]
  %bp.i1801 = getelementptr inbounds nuw i8, ptr %data3.i1796, i64 %bi.i1800
  %ch8.i1802 = load i8, ptr %bp.i1801, align 1
  %ch32.i1803 = zext i8 %ch8.i1802 to i32
  %pc.i1804 = call i32 @putchar(i32 %ch32.i1803)
  %bnext.i1805 = add nuw nsw i64 %bi.i1800, 1
  %exitcond.not.i1806 = icmp eq i64 %bnext.i1805, %len.i1790
  br i1 %exitcond.not.i1806, label %do_nl.i1807, label %byte_loop.i1799

do_nl.i1807:                                      ; preds = %byte_loop.i1799, %emit.i1812
  %nc.i1808 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1817

archx_str_print.exit1817:                         ; preds = %fast_printf.i1809, %do_nl.i1807
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1787)
  %tag.i253 = and i64 %w1.i1789, 1
  %owned.not.i254 = icmp eq i64 %tag.i253, 0
  %or.cond1912 = select i1 %short.i1791, i1 true, i1 %owned.not.i254
  br i1 %or.cond1912, label %archx_str_drop.exit258, label %do_free.i255

do_free.i255:                                     ; preds = %archx_str_print.exit1817
  %raw.i256 = and i64 %w1.i1789, -2
  %ptr.i257 = inttoptr i64 %raw.i256 to ptr
  call void @free(ptr %ptr.i257)
  br label %archx_str_drop.exit258

archx_str_drop.exit258:                           ; preds = %archx_str_print.exit1817, %do_free.i255
  %long.i261 = icmp samesign ult i64 %blen.i1088, 13
  %tag.i264 = and i64 %bw1.i1087, 1
  %owned.not.i265 = icmp eq i64 %tag.i264, 0
  %or.cond1913 = select i1 %long.i261, i1 true, i1 %owned.not.i265
  br i1 %or.cond1913, label %archx_str_drop.exit269, label %do_free.i266

do_free.i266:                                     ; preds = %archx_str_drop.exit258
  %raw.i267 = and i64 %bw1.i1087, -2
  %ptr.i268 = inttoptr i64 %raw.i267 to ptr
  call void @free(ptr %ptr.i268)
  br label %archx_str_drop.exit269

archx_str_drop.exit269:                           ; preds = %archx_str_drop.exit258, %do_free.i266
  %long.i272 = icmp samesign ult i64 %blen.i972, 13
  %tag.i275 = and i64 %var.miss_label.61.sroa.7.0, 1
  %owned.not.i276 = icmp eq i64 %tag.i275, 0
  %or.cond1914 = select i1 %long.i272, i1 true, i1 %owned.not.i276
  br i1 %or.cond1914, label %archx_str_drop.exit291, label %do_free.i277

do_free.i277:                                     ; preds = %archx_str_drop.exit269
  %raw.i278 = and i64 %var.miss_label.61.sroa.7.0, -2
  %ptr.i279 = inttoptr i64 %raw.i278 to ptr
  call void @free(ptr %ptr.i279)
  br label %archx_str_drop.exit291

archx_str_drop.exit291:                           ; preds = %do_free.i277, %archx_str_drop.exit269
  call void @free(ptr %t7)
  call void @free(ptr %dst.i735.i)
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
define private fastcc void @archx_int_overflow_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.1)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_oom_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.2)
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

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #11

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) #11

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @memchr(ptr captures(none), i32, i64) local_unnamed_addr #12

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #4

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #3

; Function Attrs: nofree nounwind
declare noundef i32 @sprintf(ptr noalias noundef writeonly captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.fptosi.sat.i64.f64(double) #11

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_key_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.4)
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
  br i1 %prol.iter91.cmp.not, label %l_tail_body.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.prol, !llvm.loop !18

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
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.i.prol.loopexit, label %l_tail_body.i.i.prol, !llvm.loop !19

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
declare i32 @llvm.cttz.i32(i32, i1 immarg) #11

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
declare <2 x i64> @llvm.smax.v2i64(<2 x i64>, <2 x i64>) #13

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.smax.v2i64(<2 x i64>) #13

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x i64> @llvm.smin.v2i64(<2 x i64>, <2 x i64>) #13

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.smin.v2i64(<2 x i64>) #13

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
attributes #11 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #12 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) }
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
!12 = distinct !{!12, !13}
!13 = !{!"llvm.loop.peeled.count", i32 1}
!14 = distinct !{!14, !1, !2}
!15 = distinct !{!15, !13}
!16 = distinct !{!16, !1, !2}
!17 = distinct !{!17, !1, !2}
!18 = distinct !{!18, !8}
!19 = distinct !{!19, !8}
