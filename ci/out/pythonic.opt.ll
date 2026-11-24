; ModuleID = 'ci/out/pythonic.ll'
source_filename = "ci/out/pythonic.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxStr = type { i64, i64 }

@.fmt.g15 = private unnamed_addr constant [6 x i8] c"%.15g\00", align 1
@.str.0 = private unnamed_addr constant [31 x i8] c"  fast pythonic native archx  \00", align 4
@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@.fmt.pstr = private unnamed_addr constant [5 x i8] c"%.*s\00", align 1
@.err.bounds = private unnamed_addr constant [63 x i8] c"archx runtime panic: index %lld out of bounds for length %lld\0A\00", align 1
@.fmt.i64s = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@str = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
push.grow.from_heap.11.peel:
  %sso.i1051 = alloca [16 x i8], align 8
  %sso.i1005 = alloca [16 x i8], align 8
  %sso.i = alloca [16 x i8], align 8
  %tmp.i944 = alloca [12 x i8], align 4
  %buf.i902 = alloca [32 x i8], align 8
  %buf.i860 = alloca [32 x i8], align 8
  %tmp.i824 = alloca [12 x i8], align 4
  %tmp.i805 = alloca [12 x i8], align 4
  %tmp.i786 = alloca [12 x i8], align 4
  %tmp.i767 = alloca [12 x i8], align 4
  %sso.i.i729 = alloca [16 x i8], align 8
  %tmp.i730 = alloca [12 x i8], align 4
  %sbuf.i = alloca [64 x i8], align 8
  %sso.i.i694 = alloca [16 x i8], align 8
  %tmp.i = alloca [12 x i8], align 4
  %buf.i = alloca [32 x i8], align 8
  %atmp.i567 = alloca [12 x i8], align 4
  %btmp.i568 = alloca [12 x i8], align 4
  %out_sso.i569 = alloca [16 x i8], align 8
  %atmp.i495 = alloca [12 x i8], align 4
  %out_sso.i497 = alloca [16 x i8], align 8
  %atmp.i408 = alloca [12 x i8], align 4
  %btmp.i409 = alloca [12 x i8], align 4
  %out_sso.i410 = alloca [16 x i8], align 8
  %atmp.i337 = alloca [12 x i8], align 4
  %btmp.i284 = alloca [12 x i8], align 4
  %out_sso.i285.sroa.6.sroa.5.sroa.0 = alloca i56, align 8
  %atmp.i217 = alloca [12 x i8], align 4
  %btmp.i218 = alloca [12 x i8], align 4
  %out_sso.i219 = alloca [16 x i8], align 8
  %atmp.i179 = alloca [12 x i8], align 4
  %out_sso.i181 = alloca [16 x i8], align 8
  %btmp.i = alloca [12 x i8], align 4
  %out_sso.i.sroa.6.sroa.5 = alloca i32, align 4
  %func.region = alloca %ArchxRegion, align 8
  %.fca.1.gep = getelementptr inbounds nuw i8, ptr %func.region, i64 8
  %.fca.2.gep = getelementptr inbounds nuw i8, ptr %func.region, i64 16
  %.fca.3.gep = getelementptr inbounds nuw i8, ptr %func.region, i64 24
  %malloc = tail call dereferenceable_or_null(32) ptr @malloc(i64 32)
  %t45.peel = icmp eq ptr %malloc, null
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %func.region, i8 0, i64 32, i1 false)
  br i1 %t45.peel, label %realloc.oom.19, label %for.body.1.peel.next

for.body.1.peel.next:                             ; preds = %push.grow.from_heap.11.peel
  store double 1.500000e+00, ptr %malloc, align 8
  br label %for.body.1

enum.cond.20.preheader:                           ; preds = %push.store.5
  %btmp4.i = getelementptr inbounds nuw i8, ptr %btmp.i, i64 4
  %atmp4.i215 = getelementptr inbounds nuw i8, ptr %atmp.i179, i64 4
  %out_sso8.i207 = getelementptr inbounds nuw i8, ptr %out_sso.i181, i64 8
  %sso_dst_a.i209 = getelementptr inbounds nuw i8, ptr %out_sso.i181, i64 4
  %atmp4.i277 = getelementptr inbounds nuw i8, ptr %atmp.i217, i64 4
  %btmp4.i273 = getelementptr inbounds nuw i8, ptr %btmp.i218, i64 4
  %out_sso8.i262 = getelementptr inbounds nuw i8, ptr %out_sso.i219, i64 8
  %sso_dst_a.i264 = getelementptr inbounds nuw i8, ptr %out_sso.i219, i64 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  %t64 = load double, ptr %var.samples.7.sroa.18.1, align 8
  %t5.i = fadd double %t64, 0.000000e+00
  %t63.1 = getelementptr inbounds nuw i8, ptr %var.samples.7.sroa.18.1, i64 8
  %t64.1 = load double, ptr %t63.1, align 8
  %t5.i.1 = fadd double %t5.i, %t64.1
  %t63.2 = getelementptr inbounds nuw i8, ptr %var.samples.7.sroa.18.1, i64 16
  %t64.2 = load double, ptr %t63.2, align 8
  %t5.i.2 = fadd double %t5.i.1, %t64.2
  %t63.3 = getelementptr inbounds nuw i8, ptr %var.samples.7.sroa.18.1, i64 24
  %t64.3 = load double, ptr %t63.3, align 8
  %t5.i.3 = fadd double %t5.i.2, %t64.3
  %t63.4 = getelementptr inbounds nuw i8, ptr %var.samples.7.sroa.18.1, i64 32
  %t64.4 = load double, ptr %t63.4, align 8
  %t5.i.4 = fadd double %t5.i.3, %t64.4
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i)
  %n32.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 5)
  %len.i656 = sext i32 %n32.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i)
  %z.i987 = icmp slt i32 %n32.i, 1
  br i1 %z.i987, label %archx_str_from_slice.exit, label %chk_sso.i

for.body.1:                                       ; preds = %for.body.1.peel.next, %push.store.5
  %var.samples.7.sroa.18.01198 = phi ptr [ %malloc, %for.body.1.peel.next ], [ %var.samples.7.sroa.18.1, %push.store.5 ]
  %var.samples.7.sroa.9.01197 = phi i64 [ 4, %for.body.1.peel.next ], [ %var.samples.7.sroa.9.1, %push.store.5 ]
  %var.samples.7.sroa.0.01196 = phi i64 [ 1, %for.body.1.peel.next ], [ %t52, %push.store.5 ]
  %for.i.8.01195 = phi i64 [ 2, %for.body.1.peel.next ], [ %t55, %push.store.5 ]
  %t12 = uitofp nneg i64 %for.i.8.01195 to double
  %t13 = fmul double %t12, 1.500000e+00
  %t18 = icmp slt i64 %var.samples.7.sroa.9.01197, 0
  %t20 = tail call i64 @llvm.abs.i64(i64 %var.samples.7.sroa.9.01197, i1 true)
  %t21.not = icmp samesign ult i64 %var.samples.7.sroa.0.01196, %t20
  br i1 %t21.not, label %push.store.5, label %push.calc.7

push.calc.7:                                      ; preds = %for.body.1
  %t23 = icmp eq i64 %var.samples.7.sroa.9.01197, 0
  %t24 = shl nuw i64 %t20, 1
  %0 = tail call i64 @llvm.smin.i64(i64 %t24, i64 140737488355328)
  %t27 = select i1 %t23, i64 4, i64 %0
  %1 = add i64 %t27, -1152921504606846976
  %t30 = icmp ult i64 %1, -2305843009213693952
  br i1 %t30, label %mul.oom.8, label %mul.ok.9

mul.oom.8:                                        ; preds = %push.calc.7
  tail call fastcc void @archx_oom_fail()
  unreachable

mul.ok.9:                                         ; preds = %push.calc.7
  %t29 = shl nsw i64 %t27, 3
  %t32 = tail call i64 @llvm.umax.i64(i64 %t29, i64 1)
  br i1 %t18, label %mul.ok.13, label %push.grow.from_heap.11

mul.ok.13:                                        ; preds = %mul.ok.9
  %t38 = tail call noalias align 16 ptr @malloc(i64 %t32)
  %t39 = icmp eq ptr %t38, null
  br i1 %t39, label %alloc.oom.15, label %push.reg.copy.16

alloc.oom.15:                                     ; preds = %mul.ok.13
  tail call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.16:                                 ; preds = %mul.ok.13
  %t34 = shl nuw nsw i64 %var.samples.7.sroa.0.01196, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t38, ptr noundef nonnull align 8 dereferenceable(1) %var.samples.7.sroa.18.01198, i64 %t34, i1 false)
  br label %push.store.5

push.grow.from_heap.11:                           ; preds = %mul.ok.9
  %t44 = tail call align 16 ptr @realloc(ptr %var.samples.7.sroa.18.01198, i64 %t32)
  %t45 = icmp eq ptr %t44, null
  br i1 %t45, label %realloc.oom.19, label %push.store.5

realloc.oom.19:                                   ; preds = %push.grow.from_heap.11, %push.grow.from_heap.11.peel
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.5:                                     ; preds = %push.grow.from_heap.11, %push.reg.copy.16, %for.body.1
  %var.samples.7.sroa.9.1 = phi i64 [ %var.samples.7.sroa.9.01197, %for.body.1 ], [ %t27, %push.reg.copy.16 ], [ %t27, %push.grow.from_heap.11 ]
  %var.samples.7.sroa.18.1 = phi ptr [ %var.samples.7.sroa.18.01198, %for.body.1 ], [ %t38, %push.reg.copy.16 ], [ %t44, %push.grow.from_heap.11 ]
  %t51 = getelementptr inbounds nuw double, ptr %var.samples.7.sroa.18.1, i64 %var.samples.7.sroa.0.01196
  store double %t13, ptr %t51, align 8
  %t52 = add nuw nsw i64 %var.samples.7.sroa.0.01196, 1
  %t55 = add nuw nsw i64 %for.i.8.01195, 1
  %exitcond.not = icmp eq i64 %t52, 5
  br i1 %exitcond.not, label %enum.cond.20.preheader, label %for.body.1, !llvm.loop !0

oom.i1003:                                        ; preds = %build_long.i989
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i:                                        ; preds = %enum.cond.20.preheader
  %short.i988 = icmp samesign ult i32 %n32.i, 13
  br i1 %short.i988, label %pack_sso.i, label %build_long.i989

pack_sso.i:                                       ; preds = %chk_sso.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i, i8 0, i64 16, i1 false)
  store i32 %n32.i, ptr %sso.i, align 8
  %sso.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i, i64 %len.i656, i1 false)
  %sso.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i = load i64, ptr %sso.i, align 8
  %sso.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i, i64 8
  %sso.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i = load i64, ptr %sso.i.8.sroa_idx, align 8
  %ss0.i = insertvalue %ArchxStr poison, i64 %sso.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i, 0
  %ss1.i = insertvalue %ArchxStr %ss0.i, i64 %sso.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i, 1
  br label %archx_str_from_slice.exit

build_long.i989:                                  ; preds = %chk_sso.i
  %hp.i990 = tail call noalias align 16 ptr @malloc(i64 %len.i656)
  %hnull.i991 = icmp eq ptr %hp.i990, null
  br i1 %hnull.i991, label %oom.i1003, label %tag_heap.i992

tag_heap.i992:                                    ; preds = %build_long.i989
  %hp_i.i993 = ptrtoint ptr %hp.i990 to i64
  %htagged.i994 = or disjoint i64 %hp_i.i993, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i990, ptr nonnull readonly align 8 %buf.i, i64 %len.i656, i1 false)
  %pref32.i996 = load i32, ptr %hp.i990, align 16
  %pref64.i997 = zext i32 %pref32.i996 to i64
  %pref_sh.i998 = shl nuw i64 %pref64.i997, 32
  %w0_out.i999 = or disjoint i64 %pref_sh.i998, %len.i656
  %ls0.i1000 = insertvalue %ArchxStr poison, i64 %w0_out.i999, 0
  %ls1.i1001 = insertvalue %ArchxStr %ls0.i1000, i64 %htagged.i994, 1
  br label %archx_str_from_slice.exit

archx_str_from_slice.exit:                        ; preds = %enum.cond.20.preheader, %pack_sso.i, %tag_heap.i992
  %common.ret.op.i1002 = phi %ArchxStr [ %ss1.i, %pack_sso.i ], [ %ls1.i1001, %tag_heap.i992 ], [ zeroinitializer, %enum.cond.20.preheader ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %out_sso.i.sroa.6.sroa.5)
  %bw0.i = extractvalue %ArchxStr %common.ret.op.i1002, 0
  %bw1.i = extractvalue %ArchxStr %common.ret.op.i1002, 1
  %blen.i = and i64 %bw0.i, 4294967295
  %bz.i = icmp eq i64 %blen.i, 0
  br i1 %bz.i, label %archx_str_concat.exit, label %calc_tot.i

calc_tot.i:                                       ; preds = %archx_str_from_slice.exit
  %tot.i = add nuw nsw i64 %blen.i, 8
  %too_big.i = icmp samesign ugt i64 %blen.i, 2147483639
  br i1 %too_big.i, label %oom.i, label %mat_a.i

oom.i:                                            ; preds = %build_long.i, %calc_tot.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i:                                          ; preds = %calc_tot.i
  %bshort.i = icmp samesign ult i64 %blen.i, 13
  br i1 %bshort.i, label %build.i, label %build.i.thread

build.i.thread:                                   ; preds = %mat_a.i
  %braw.i = and i64 %bw1.i, -4
  %blptr.i = inttoptr i64 %braw.i to ptr
  br label %build_long.i

build.i:                                          ; preds = %mat_a.i
  %bp4.i = lshr i64 %bw0.i, 32
  %bp4_32.i = trunc nuw i64 %bp4.i to i32
  store i32 %bp4_32.i, ptr %btmp.i, align 4
  store i64 %bw1.i, ptr %btmp4.i, align 4
  %fits_sso.i = icmp samesign ult i64 %blen.i, 5
  br i1 %fits_sso.i, label %build_sso.i, label %build_long.i

build_sso.i:                                      ; preds = %build.i
  store i32 0, ptr %out_sso.i.sroa.6.sroa.5, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %out_sso.i.sroa.6.sroa.5, ptr nonnull align 4 %btmp.i, i64 %blen.i, i1 false)
  %out_sso.i.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i, 8101238451258523648
  %out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.8.rw1.i = load i32, ptr %out_sso.i.sroa.6.sroa.5, align 4
  %out_sso.i.sroa.6.sroa.5.0.insert.ext = zext i32 %out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.8.rw1.i to i64
  %out_sso.i.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i.sroa.6.sroa.5.0.insert.ext, 32
  %out_sso.i.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i.sroa.6.sroa.5.0.insert.shift, 589325676
  %rs0.i = insertvalue %ArchxStr poison, i64 %out_sso.i.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i = insertvalue %ArchxStr %rs0.i, i64 %out_sso.i.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit

build_long.i:                                     ; preds = %build.i.thread, %build.i
  %bptr.i1258 = phi ptr [ %blptr.i, %build.i.thread ], [ %btmp.i, %build.i ]
  %hp.i = tail call noalias align 16 ptr @malloc(i64 %tot.i)
  %hnull.i = icmp eq ptr %hp.i, null
  br i1 %hnull.i, label %oom.i, label %tag_heap.i

tag_heap.i:                                       ; preds = %build_long.i
  %hp_i.i = ptrtoint ptr %hp.i to i64
  %htagged.i = or disjoint i64 %hp_i.i, 1
  store i32 1886216563, ptr %hp.i, align 16
  %atmp.i.sroa.5.0.hp.i.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i, i64 4
  store i32 589325676, ptr %atmp.i.sroa.5.0.hp.i.sroa_idx, align 4
  %dst_b.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %dst_b.i, ptr nonnull align 1 %bptr.i1258, i64 %blen.i, i1 false)
  %w0_out.i = or disjoint i64 %tot.i, 8101238451258523648
  %ls0.i = insertvalue %ArchxStr poison, i64 %w0_out.i, 0
  %ls1.i = insertvalue %ArchxStr %ls0.i, i64 %htagged.i, 1
  br label %archx_str_concat.exit

archx_str_concat.exit:                            ; preds = %archx_str_from_slice.exit, %build_sso.i, %tag_heap.i
  %common.ret.op.i178 = phi %ArchxStr [ %rs1.i, %build_sso.i ], [ %ls1.i, %tag_heap.i ], [ { i64 8101238451258523656, i64 589325676 }, %archx_str_from_slice.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %out_sso.i.sroa.6.sroa.5)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i179)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i181)
  %aw0.i = extractvalue %ArchxStr %common.ret.op.i178, 0
  %aw1.i = extractvalue %ArchxStr %common.ret.op.i178, 1
  %alen.i = and i64 %aw0.i, 4294967295
  %az.i = icmp eq i64 %alen.i, 0
  br i1 %az.i, label %archx_str_concat.exit216, label %chk_bz.i

chk_bz.i:                                         ; preds = %archx_str_concat.exit
  %tot.i183 = add nuw nsw i64 %alen.i, 3
  %too_big.i184 = icmp samesign ugt i64 %alen.i, 2147483644
  br i1 %too_big.i184, label %oom.i205, label %mat_a.i185

oom.i205:                                         ; preds = %build_long.i191, %chk_bz.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i185:                                       ; preds = %chk_bz.i
  %ashort.i = icmp samesign ult i64 %alen.i, 13
  br i1 %ashort.i, label %mat_b.i, label %mat_b.i.thread

mat_b.i.thread:                                   ; preds = %mat_a.i185
  %araw.i = and i64 %aw1.i, -4
  %alptr.i = inttoptr i64 %araw.i to ptr
  br label %build_long.i191

mat_b.i:                                          ; preds = %mat_a.i185
  %ap4.i = lshr i64 %aw0.i, 32
  %ap4_32.i = trunc nuw i64 %ap4.i to i32
  store i32 %ap4_32.i, ptr %atmp.i179, align 4
  store i64 %aw1.i, ptr %atmp4.i215, align 4
  %fits_sso.i190 = icmp samesign ult i64 %alen.i, 10
  br i1 %fits_sso.i190, label %build_sso.i206, label %build_long.i191

build_sso.i206:                                   ; preds = %mat_b.i
  %tot32.i208 = trunc nuw nsw i64 %tot.i183 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i181, i8 0, i64 16, i1 false)
  store i32 %tot32.i208, ptr %out_sso.i181, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i209, ptr nonnull align 4 %atmp.i179, i64 %alen.i, i1 false)
  %sso_dst_b.i210 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i209, i64 %alen.i
  store i24 2112800, ptr %sso_dst_b.i210, align 1
  %rw0.i211 = load i64, ptr %out_sso.i181, align 8
  %rw1.i212 = load i64, ptr %out_sso8.i207, align 8
  %rs0.i213 = insertvalue %ArchxStr poison, i64 %rw0.i211, 0
  %rs1.i214 = insertvalue %ArchxStr %rs0.i213, i64 %rw1.i212, 1
  br label %archx_str_concat.exit216

build_long.i191:                                  ; preds = %mat_b.i.thread, %mat_b.i
  %aptr.i1109 = phi ptr [ %alptr.i, %mat_b.i.thread ], [ %atmp.i179, %mat_b.i ]
  %hp.i192 = tail call noalias align 16 ptr @malloc(i64 %tot.i183)
  %hnull.i193 = icmp eq ptr %hp.i192, null
  br i1 %hnull.i193, label %oom.i205, label %tag_heap.i194

tag_heap.i194:                                    ; preds = %build_long.i191
  %hp_i.i195 = ptrtoint ptr %hp.i192 to i64
  %htagged.i196 = or disjoint i64 %hp_i.i195, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i192, ptr nonnull align 1 %aptr.i1109, i64 %alen.i, i1 false)
  %dst_b.i197 = getelementptr inbounds nuw i8, ptr %hp.i192, i64 %alen.i
  store i24 2112800, ptr %dst_b.i197, align 1
  %pref32.i198 = load i32, ptr %hp.i192, align 16
  %pref64.i199 = zext i32 %pref32.i198 to i64
  %pref_sh.i200 = shl nuw i64 %pref64.i199, 32
  %w0_out.i201 = or disjoint i64 %pref_sh.i200, %tot.i183
  %ls0.i202 = insertvalue %ArchxStr poison, i64 %w0_out.i201, 0
  %ls1.i203 = insertvalue %ArchxStr %ls0.i202, i64 %htagged.i196, 1
  br label %archx_str_concat.exit216

archx_str_concat.exit216:                         ; preds = %archx_str_concat.exit, %build_sso.i206, %tag_heap.i194
  %common.ret.op.i204 = phi %ArchxStr [ %rs1.i214, %build_sso.i206 ], [ %ls1.i203, %tag_heap.i194 ], [ { i64 9074406902988803, i64 0 }, %archx_str_concat.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i179)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i181)
  %t71 = tail call fastcc { i64, i64 } @archx_str_from_float(double %t64.4, ptr null)
  %newret = extractvalue { i64, i64 } %t71, 0
  %oldret = insertvalue %ArchxStr poison, i64 %newret, 0
  %newret1287 = extractvalue { i64, i64 } %t71, 1
  %oldret1288 = insertvalue %ArchxStr %oldret, i64 %newret1287, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i217)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i218)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i219)
  %aw0.i220 = extractvalue %ArchxStr %common.ret.op.i204, 0
  %aw1.i221 = extractvalue %ArchxStr %common.ret.op.i204, 1
  %alen.i224 = and i64 %aw0.i220, 4294967295
  %blen.i225 = and i64 %newret, 4294967295
  %az.i226 = icmp eq i64 %alen.i224, 0
  br i1 %az.i226, label %ret_b.i280, label %chk_bz.i227

ret_b.i280:                                       ; preds = %archx_str_concat.exit216
  %long.i661 = icmp samesign ult i64 %blen.i225, 13
  %tag.i665 = and i64 %newret1287, 3
  %owned.not.i666 = icmp eq i64 %tag.i665, 0
  %or.cond = select i1 %long.i661, i1 true, i1 %owned.not.i666
  br i1 %or.cond, label %archx_str_concat.exit282, label %dup_heap.i

dup_heap.i:                                       ; preds = %ret_b.i280
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %blen.i225)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i667, label %copy.i

oom.i667:                                         ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %newret1287, -4
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 4 %src.i, i64 %blen.i225, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %out.i = insertvalue %ArchxStr %oldret1288, i64 %tagged.i, 1
  br label %archx_str_concat.exit282

chk_bz.i227:                                      ; preds = %archx_str_concat.exit216
  %bz.i228 = icmp eq i64 %blen.i225, 0
  br i1 %bz.i228, label %ret_a.i278, label %calc_tot.i229

ret_a.i278:                                       ; preds = %chk_bz.i227
  %long.i670 = icmp samesign ult i64 %alen.i224, 13
  %tag.i674 = and i64 %aw1.i221, 3
  %owned.not.i675 = icmp eq i64 %tag.i674, 0
  %or.cond1130 = select i1 %long.i670, i1 true, i1 %owned.not.i675
  br i1 %or.cond1130, label %archx_str_concat.exit282, label %dup_heap.i676

dup_heap.i676:                                    ; preds = %ret_a.i278
  %dst.i677 = tail call noalias align 16 ptr @malloc(i64 %alen.i224)
  %isnull.i678 = icmp eq ptr %dst.i677, null
  br i1 %isnull.i678, label %oom.i685, label %copy.i679

oom.i685:                                         ; preds = %dup_heap.i676
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i679:                                        ; preds = %dup_heap.i676
  %src_i.i680 = and i64 %aw1.i221, -4
  %src.i681 = inttoptr i64 %src_i.i680 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i677, ptr nonnull align 4 %src.i681, i64 %alen.i224, i1 false)
  %dst_i.i682 = ptrtoint ptr %dst.i677 to i64
  %tagged.i683 = or disjoint i64 %dst_i.i682, 1
  %out.i684 = insertvalue %ArchxStr %common.ret.op.i204, i64 %tagged.i683, 1
  br label %archx_str_concat.exit282

calc_tot.i229:                                    ; preds = %chk_bz.i227
  %tot.i230 = add nuw nsw i64 %blen.i225, %alen.i224
  %too_big.i231 = icmp samesign ugt i64 %tot.i230, 2147483647
  br i1 %too_big.i231, label %oom.i260, label %mat_a.i232

oom.i260:                                         ; preds = %build_long.i246, %calc_tot.i229
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i232:                                       ; preds = %calc_tot.i229
  %ashort.i233 = icmp samesign ult i64 %alen.i224, 13
  br i1 %ashort.i233, label %mat_a_short.i274, label %mat_a_long.i234

mat_a_short.i274:                                 ; preds = %mat_a.i232
  %ap4.i275 = lshr i64 %aw0.i220, 32
  %ap4_32.i276 = trunc nuw i64 %ap4.i275 to i32
  store i32 %ap4_32.i276, ptr %atmp.i217, align 4
  store i64 %aw1.i221, ptr %atmp4.i277, align 4
  br label %mat_b.i237

mat_a_long.i234:                                  ; preds = %mat_a.i232
  %araw.i235 = and i64 %aw1.i221, -4
  %alptr.i236 = inttoptr i64 %araw.i235 to ptr
  br label %mat_b.i237

mat_b.i237:                                       ; preds = %mat_a_long.i234, %mat_a_short.i274
  %aptr.i238 = phi ptr [ %atmp.i217, %mat_a_short.i274 ], [ %alptr.i236, %mat_a_long.i234 ]
  %bshort.i239 = icmp samesign ult i64 %blen.i225, 13
  br i1 %bshort.i239, label %mat_b_short.i270, label %mat_b_long.i240

mat_b_short.i270:                                 ; preds = %mat_b.i237
  %bp4.i271 = lshr i64 %newret, 32
  %bp4_32.i272 = trunc nuw i64 %bp4.i271 to i32
  store i32 %bp4_32.i272, ptr %btmp.i218, align 4
  store i64 %newret1287, ptr %btmp4.i273, align 4
  br label %build.i243

mat_b_long.i240:                                  ; preds = %mat_b.i237
  %braw.i241 = and i64 %newret1287, -4
  %blptr.i242 = inttoptr i64 %braw.i241 to ptr
  br label %build.i243

build.i243:                                       ; preds = %mat_b_long.i240, %mat_b_short.i270
  %bptr.i244 = phi ptr [ %btmp.i218, %mat_b_short.i270 ], [ %blptr.i242, %mat_b_long.i240 ]
  %fits_sso.i245 = icmp samesign ult i64 %tot.i230, 13
  br i1 %fits_sso.i245, label %build_sso.i261, label %build_long.i246

build_sso.i261:                                   ; preds = %build.i243
  %tot32.i263 = trunc nuw nsw i64 %tot.i230 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i219, i8 0, i64 16, i1 false)
  store i32 %tot32.i263, ptr %out_sso.i219, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i264, ptr nonnull align 1 %aptr.i238, i64 %alen.i224, i1 false)
  %sso_dst_b.i265 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i264, i64 %alen.i224
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i265, ptr nonnull align 1 %bptr.i244, i64 %blen.i225, i1 false)
  %rw0.i266 = load i64, ptr %out_sso.i219, align 8
  %rw1.i267 = load i64, ptr %out_sso8.i262, align 8
  %rs0.i268 = insertvalue %ArchxStr poison, i64 %rw0.i266, 0
  %rs1.i269 = insertvalue %ArchxStr %rs0.i268, i64 %rw1.i267, 1
  br label %archx_str_concat.exit282

build_long.i246:                                  ; preds = %build.i243
  %hp.i247 = tail call noalias align 16 ptr @malloc(i64 %tot.i230)
  %hnull.i248 = icmp eq ptr %hp.i247, null
  br i1 %hnull.i248, label %oom.i260, label %tag_heap.i249

tag_heap.i249:                                    ; preds = %build_long.i246
  %hp_i.i250 = ptrtoint ptr %hp.i247 to i64
  %htagged.i251 = or disjoint i64 %hp_i.i250, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i247, ptr nonnull align 1 %aptr.i238, i64 %alen.i224, i1 false)
  %dst_b.i252 = getelementptr inbounds nuw i8, ptr %hp.i247, i64 %alen.i224
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i252, ptr nonnull align 1 %bptr.i244, i64 %blen.i225, i1 false)
  %pref32.i253 = load i32, ptr %hp.i247, align 16
  %pref64.i254 = zext i32 %pref32.i253 to i64
  %pref_sh.i255 = shl nuw i64 %pref64.i254, 32
  %w0_out.i256 = or disjoint i64 %pref_sh.i255, %tot.i230
  %ls0.i257 = insertvalue %ArchxStr poison, i64 %w0_out.i256, 0
  %ls1.i258 = insertvalue %ArchxStr %ls0.i257, i64 %htagged.i251, 1
  br label %archx_str_concat.exit282

archx_str_concat.exit282:                         ; preds = %copy.i679, %ret_a.i278, %copy.i, %ret_b.i280, %build_sso.i261, %tag_heap.i249
  %common.ret.op.i259 = phi %ArchxStr [ %rs1.i269, %build_sso.i261 ], [ %ls1.i258, %tag_heap.i249 ], [ %out.i, %copy.i ], [ %oldret1288, %ret_b.i280 ], [ %out.i684, %copy.i679 ], [ %common.ret.op.i204, %ret_a.i278 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i217)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i218)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i219)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  %w0.i687 = extractvalue %ArchxStr %common.ret.op.i259, 0
  %w1.i688 = extractvalue %ArchxStr %common.ret.op.i259, 1
  %len.i689 = and i64 %w0.i687, 4294967295
  %short.i = icmp samesign ult i64 %len.i689, 13
  br i1 %short.i, label %emit.i, label %emit.thread.i

emit.thread.i:                                    ; preds = %archx_str_concat.exit282
  %raw.i690 = and i64 %w1.i688, -4
  %lptr.i = inttoptr i64 %raw.i690 to ptr
  br label %chk_nul.i

emit.i:                                           ; preds = %archx_str_concat.exit282
  %p4.i = lshr i64 %w0.i687, 32
  %p4_32.i = trunc nuw i64 %p4.i to i32
  store i32 %p4_32.i, ptr %tmp.i, align 4
  store i64 %w1.i688, ptr %tmp4.i, align 4
  %pos.not.i = icmp eq i64 %len.i689, 0
  br i1 %pos.not.i, label %chk_nl.i, label %chk_nul.i

chk_nul.i:                                        ; preds = %emit.i, %emit.thread.i
  %data3.i = phi ptr [ %lptr.i, %emit.thread.i ], [ %tmp.i, %emit.i ]
  %nul.i = call ptr @memchr(ptr nonnull %data3.i, i32 0, i64 %len.i689)
  %has_nul.not.i = icmp eq ptr %nul.i, null
  br i1 %has_nul.not.i, label %fast_printf.i, label %byte_loop.i

fast_printf.i:                                    ; preds = %chk_nul.i
  %len32.i = trunc i64 %w0.i687 to i32
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i, ptr nonnull %data3.i)
  br label %archx_str_print.exit

byte_loop.i:                                      ; preds = %chk_nul.i, %byte_loop.i
  %bi.i = phi i64 [ %bnext.i, %byte_loop.i ], [ 0, %chk_nul.i ]
  %bp.i = getelementptr inbounds nuw i8, ptr %data3.i, i64 %bi.i
  %ch8.i = load i8, ptr %bp.i, align 1
  %ch32.i = zext i8 %ch8.i to i32
  %pc.i = tail call i32 @putchar(i32 %ch32.i)
  %bnext.i = add nuw nsw i64 %bi.i, 1
  %exitcond.not.i = icmp eq i64 %bnext.i, %len.i689
  br i1 %exitcond.not.i, label %chk_nl.i, label %byte_loop.i

chk_nl.i:                                         ; preds = %byte_loop.i, %emit.i
  %nc.i = tail call i32 @putchar(i32 10)
  br label %archx_str_print.exit

archx_str_print.exit:                             ; preds = %fast_printf.i, %chk_nl.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %tag.i = and i64 %w1.i688, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond1131 = select i1 %short.i, i1 true, i1 %owned.not.i
  br i1 %or.cond1131, label %archx_str_drop.exit, label %do_free.i

do_free.i:                                        ; preds = %archx_str_print.exit
  %raw.i = and i64 %w1.i688, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  call void @free(ptr %ptr.i)
  br label %archx_str_drop.exit

archx_str_drop.exit:                              ; preds = %archx_str_print.exit, %do_free.i
  %long.i26 = icmp samesign ult i64 %blen.i225, 13
  %tag.i29 = and i64 %newret1287, 1
  %owned.not.i30 = icmp eq i64 %tag.i29, 0
  %or.cond1132 = select i1 %long.i26, i1 true, i1 %owned.not.i30
  br i1 %or.cond1132, label %archx_str_drop.exit34, label %do_free.i31

do_free.i31:                                      ; preds = %archx_str_drop.exit
  %raw.i32 = and i64 %newret1287, -2
  %ptr.i33 = inttoptr i64 %raw.i32 to ptr
  call void @free(ptr %ptr.i33)
  br label %archx_str_drop.exit34

archx_str_drop.exit34:                            ; preds = %archx_str_drop.exit, %do_free.i31
  %long.i37 = icmp samesign ult i64 %alen.i224, 13
  %tag.i40 = and i64 %aw1.i221, 1
  %owned.not.i41 = icmp eq i64 %tag.i40, 0
  %or.cond1133 = select i1 %long.i37, i1 true, i1 %owned.not.i41
  br i1 %or.cond1133, label %archx_str_drop.exit45, label %do_free.i42

do_free.i42:                                      ; preds = %archx_str_drop.exit34
  %raw.i43 = and i64 %aw1.i221, -2
  %ptr.i44 = inttoptr i64 %raw.i43 to ptr
  call void @free(ptr %ptr.i44)
  br label %archx_str_drop.exit45

archx_str_drop.exit45:                            ; preds = %archx_str_drop.exit34, %do_free.i42
  %long.i48 = icmp samesign ult i64 %alen.i, 13
  %tag.i51 = and i64 %aw1.i, 1
  %owned.not.i52 = icmp eq i64 %tag.i51, 0
  %or.cond1134 = select i1 %long.i48, i1 true, i1 %owned.not.i52
  br i1 %or.cond1134, label %archx_str_drop.exit56, label %do_free.i53

do_free.i53:                                      ; preds = %archx_str_drop.exit45
  %raw.i54 = and i64 %aw1.i, -2
  %ptr.i55 = inttoptr i64 %raw.i54 to ptr
  call void @free(ptr %ptr.i55)
  br label %archx_str_drop.exit56

archx_str_drop.exit56:                            ; preds = %archx_str_drop.exit45, %do_free.i53
  %long.i59 = icmp samesign ult i64 %blen.i, 13
  %tag.i62 = and i64 %bw1.i, 1
  %owned.not.i63 = icmp eq i64 %tag.i62, 0
  %or.cond1135 = select i1 %long.i59, i1 true, i1 %owned.not.i63
  br i1 %or.cond1135, label %build_long.i.i, label %do_free.i64

do_free.i64:                                      ; preds = %archx_str_drop.exit56
  %raw.i65 = and i64 %bw1.i, -2
  %ptr.i66 = inttoptr i64 %raw.i65 to ptr
  call void @free(ptr %ptr.i66)
  br label %build_long.i.i

oom.i.i:                                          ; preds = %build_long.i.i
  call fastcc void @archx_oom_fail()
  unreachable

build_long.i.i:                                   ; preds = %archx_str_drop.exit56, %do_free.i64
  %hp.i.i = call noalias align 16 dereferenceable_or_null(26) ptr @malloc(i64 26)
  %hnull.i.i = icmp eq ptr %hp.i.i, null
  br i1 %hnull.i.i, label %oom.i.i, label %chk_ws.lr.ph.lr.ph.i

chk_ws.lr.ph.lr.ph.i:                             ; preds = %build_long.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(26) %hp.i.i, ptr noundef nonnull readonly align 2 dereferenceable(26) getelementptr inbounds nuw (i8, ptr @.str.0, i64 2), i64 26, i1 false)
  %sso.i.i694.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i694, i64 4
  %sso.i.i694.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i694, i64 8
  br label %chk_ws.lr.ph.i

chk_ws.lr.ph.i:                                   ; preds = %store_elem.i, %chk_ws.lr.ph.lr.ph.i
  %vcap.ph35.i = phi i64 [ 0, %chk_ws.lr.ph.lr.ph.i ], [ %vcap_next.i, %store_elem.i ]
  %vlen.ph34.i = phi i64 [ 0, %chk_ws.lr.ph.lr.ph.i ], [ %vlen_next.i, %store_elem.i ]
  %vptr.ph33.i = phi ptr [ null, %chk_ws.lr.ph.lr.ph.i ], [ %vptr_next.i, %store_elem.i ]
  %i.ph32.i = phi i64 [ 0, %chk_ws.lr.ph.lr.ph.i ], [ %j.lcssa.i.ph, %store_elem.i ]
  br label %chk_ws.i

chk_ws.i:                                         ; preds = %ws_adv.i, %chk_ws.lr.ph.i
  %i11.i = phi i64 [ %i.ph32.i, %chk_ws.lr.ph.i ], [ %i_ws.i, %ws_adv.i ]
  %cp.i = getelementptr inbounds nuw i8, ptr %hp.i.i, i64 %i11.i
  %c.i = load i8, ptr %cp.i, align 1
  switch i8 %c.i, label %tok_chk.i.preheader [
    i8 32, label %ws_adv.i
    i8 13, label %ws_adv.i
    i8 12, label %ws_adv.i
    i8 11, label %ws_adv.i
    i8 10, label %ws_adv.i
    i8 9, label %ws_adv.i
  ]

tok_chk.i.preheader:                              ; preds = %chk_ws.i
  %cp.i.le = getelementptr inbounds nuw i8, ptr %hp.i.i, i64 %i11.i
  br label %tok_chk.i

ws_adv.i:                                         ; preds = %chk_ws.i, %chk_ws.i, %chk_ws.i, %chk_ws.i, %chk_ws.i, %chk_ws.i
  %i_ws.i = add nuw nsw i64 %i11.i, 1
  %more.i = icmp samesign ult i64 %i11.i, 25
  br i1 %more.i, label %chk_ws.i, label %archx_str_drop.exit78

tok_chk.i:                                        ; preds = %tok_chk.i.preheader, %tok_adv.i
  %j18.i = phi i64 [ %jnext.i, %tok_adv.i ], [ %i11.i, %tok_chk.i.preheader ]
  %jp.i = getelementptr inbounds nuw i8, ptr %hp.i.i, i64 %j18.i
  %jc.i = load i8, ptr %jp.i, align 1
  switch i8 %jc.i, label %tok_adv.i [
    i8 32, label %emit_tok.i
    i8 13, label %emit_tok.i
    i8 12, label %emit_tok.i
    i8 11, label %emit_tok.i
    i8 10, label %emit_tok.i
    i8 9, label %emit_tok.i
  ]

tok_adv.i:                                        ; preds = %tok_chk.i
  %jnext.i = add nuw nsw i64 %j18.i, 1
  %jmore.i = icmp samesign ult i64 %j18.i, 25
  br i1 %jmore.i, label %tok_chk.i, label %emit_tok.i

emit_tok.i:                                       ; preds = %tok_adv.i, %tok_chk.i, %tok_chk.i, %tok_chk.i, %tok_chk.i, %tok_chk.i, %tok_chk.i
  %j.lcssa.i.ph = phi i64 [ %j18.i, %tok_chk.i ], [ %j18.i, %tok_chk.i ], [ %j18.i, %tok_chk.i ], [ %j18.i, %tok_chk.i ], [ %j18.i, %tok_chk.i ], [ %j18.i, %tok_chk.i ], [ 26, %tok_adv.i ]
  %tlen.i = sub nuw nsw i64 %j.lcssa.i.ph, %i11.i
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i694)
  %z.i.i700 = icmp eq i64 %j.lcssa.i.ph, %i11.i
  br i1 %z.i.i700, label %archx_str_from_slice.exit.i717, label %chk_sso.i.i703

oom.i.i720:                                       ; preds = %build_long.i.i705
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i703:                                   ; preds = %emit_tok.i
  %short.i.i704 = icmp samesign ult i64 %tlen.i, 13
  br i1 %short.i.i704, label %pack_sso.i.i721, label %build_long.i.i705

pack_sso.i.i721:                                  ; preds = %chk_sso.i.i703
  %len32.i.i722 = trunc nuw nsw i64 %tlen.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i694, i8 0, i64 16, i1 false)
  store i32 %len32.i.i722, ptr %sso.i.i694, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i694.4.sroa_idx, ptr nonnull readonly align 1 %cp.i.le, i64 %tlen.i, i1 false)
  %sso.i.i694.0.sso.i.i694.0.sso.i.i694.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i723 = load i64, ptr %sso.i.i694, align 8
  %sso.i.i694.8.sso.i.i694.8.sso.i.i694.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i724 = load i64, ptr %sso.i.i694.8.sroa_idx, align 8
  %ss0.i.i725 = insertvalue %ArchxStr poison, i64 %sso.i.i694.0.sso.i.i694.0.sso.i.i694.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i723, 0
  %ss1.i.i726 = insertvalue %ArchxStr %ss0.i.i725, i64 %sso.i.i694.8.sso.i.i694.8.sso.i.i694.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i724, 1
  br label %archx_str_from_slice.exit.i717

build_long.i.i705:                                ; preds = %chk_sso.i.i703
  %hp.i.i706 = call noalias align 16 ptr @malloc(i64 %tlen.i)
  %hnull.i.i707 = icmp eq ptr %hp.i.i706, null
  br i1 %hnull.i.i707, label %oom.i.i720, label %tag_heap.i.i708

tag_heap.i.i708:                                  ; preds = %build_long.i.i705
  %hp_i.i.i709 = ptrtoint ptr %hp.i.i706 to i64
  %htagged.i.i710 = or disjoint i64 %hp_i.i.i709, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i706, ptr nonnull readonly align 1 %cp.i.le, i64 %tlen.i, i1 false)
  %pref32.i.i711 = load i32, ptr %hp.i.i706, align 16
  %pref64.i.i712 = zext i32 %pref32.i.i711 to i64
  %pref_sh.i.i713 = shl nuw i64 %pref64.i.i712, 32
  %w0_out.i.i714 = or disjoint i64 %pref_sh.i.i713, %tlen.i
  %ls0.i.i715 = insertvalue %ArchxStr poison, i64 %w0_out.i.i714, 0
  %ls1.i.i716 = insertvalue %ArchxStr %ls0.i.i715, i64 %htagged.i.i710, 1
  br label %archx_str_from_slice.exit.i717

archx_str_from_slice.exit.i717:                   ; preds = %tag_heap.i.i708, %pack_sso.i.i721, %emit_tok.i
  %common.ret.op.i.i718 = phi %ArchxStr [ %ss1.i.i726, %pack_sso.i.i721 ], [ %ls1.i.i716, %tag_heap.i.i708 ], [ zeroinitializer, %emit_tok.i ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i694)
  %full.not.i = icmp slt i64 %vlen.ph34.i, %vcap.ph35.i
  br i1 %full.not.i, label %store_elem.i, label %grow.i

grow.i:                                           ; preds = %archx_str_from_slice.exit.i717
  %zc.i = icmp eq i64 %vcap.ph35.i, 0
  %dc.i = shl i64 %vcap.ph35.i, 1
  %ncap.i = select i1 %zc.i, i64 4, i64 %dc.i
  %bytes.i = shl i64 %ncap.i, 4
  %was_null.i = icmp eq ptr %vptr.ph33.i, null
  br i1 %was_null.i, label %gmalloc.i, label %grealloc.i

gmalloc.i:                                        ; preds = %grow.i
  %mp.i = call noalias align 16 ptr @malloc(i64 %bytes.i)
  %mn.i = icmp eq ptr %mp.i, null
  br i1 %mn.i, label %oom.i719, label %store_elem.i

grealloc.i:                                       ; preds = %grow.i
  %rp.i = call align 16 ptr @realloc(ptr nonnull %vptr.ph33.i, i64 %bytes.i)
  %rn.i = icmp eq ptr %rp.i, null
  br i1 %rn.i, label %oom.i719, label %store_elem.i

oom.i719:                                         ; preds = %grealloc.i, %gmalloc.i
  call fastcc void @archx_oom_fail()
  unreachable

store_elem.i:                                     ; preds = %grealloc.i, %gmalloc.i, %archx_str_from_slice.exit.i717
  %vptr_next.i = phi ptr [ %vptr.ph33.i, %archx_str_from_slice.exit.i717 ], [ %mp.i, %gmalloc.i ], [ %rp.i, %grealloc.i ]
  %vcap_next.i = phi i64 [ %vcap.ph35.i, %archx_str_from_slice.exit.i717 ], [ %ncap.i, %gmalloc.i ], [ %ncap.i, %grealloc.i ]
  %ep.i = getelementptr inbounds nuw %ArchxStr, ptr %vptr_next.i, i64 %vlen.ph34.i
  %elem.elt.i = extractvalue %ArchxStr %common.ret.op.i.i718, 0
  store i64 %elem.elt.i, ptr %ep.i, align 16
  %ep.repack1.i = getelementptr inbounds nuw i8, ptr %ep.i, i64 8
  %elem.elt2.i = extractvalue %ArchxStr %common.ret.op.i.i718, 1
  store i64 %elem.elt2.i, ptr %ep.repack1.i, align 8
  %vlen_next.i = add nuw nsw i64 %vlen.ph34.i, 1
  %more10.i = icmp samesign ult i64 %j.lcssa.i.ph, 26
  br i1 %more10.i, label %chk_ws.lr.ph.i, label %archx_str_drop.exit78.thread1260

archx_str_drop.exit78.thread1260:                 ; preds = %store_elem.i
  call void @free(ptr nonnull %hp.i.i)
  br label %idx.ok.27

archx_str_drop.exit78:                            ; preds = %ws_adv.i
  call void @free(ptr %hp.i.i)
  %t85 = icmp eq i64 %vlen.ph34.i, 0
  br i1 %t85, label %idx.oob.28, label %idx.ok.27

idx.oob.28:                                       ; preds = %archx_str_drop.exit78
  call fastcc void @archx_bounds_fail()
  unreachable

idx.ok.27:                                        ; preds = %archx_str_drop.exit78.thread1260, %archx_str_drop.exit78
  %vcap.ph.lcssa5.i1267 = phi i64 [ %vcap_next.i, %archx_str_drop.exit78.thread1260 ], [ %vcap.ph35.i, %archx_str_drop.exit78 ]
  %vlen.ph.lcssa7.i1266 = phi i64 [ %vlen_next.i, %archx_str_drop.exit78.thread1260 ], [ %vlen.ph34.i, %archx_str_drop.exit78 ]
  %vptr.ph.lcssa9.i1265 = phi ptr [ %vptr_next.i, %archx_str_drop.exit78.thread1260 ], [ %vptr.ph33.i, %archx_str_drop.exit78 ]
  %t88.unpack = load i64, ptr %vptr.ph.lcssa9.i1265, align 8
  %t88.elt19 = getelementptr inbounds nuw i8, ptr %vptr.ph.lcssa9.i1265, i64 8
  %t88.unpack20 = load i64, ptr %t88.elt19, align 8
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i730)
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %sbuf.i)
  %len.i733 = and i64 %t88.unpack, 4294967295
  %z.i = icmp eq i64 %len.i733, 0
  br i1 %z.i, label %archx_str_case.exit, label %mat.i

mat.i:                                            ; preds = %idx.ok.27
  %short.i734 = icmp samesign ult i64 %len.i733, 13
  br i1 %short.i734, label %alloc_dst.thread.i, label %alloc_dst.i

alloc_dst.thread.i:                               ; preds = %mat.i
  %p4.i764 = lshr i64 %t88.unpack, 32
  %p4_32.i765 = trunc nuw i64 %p4.i764 to i32
  store i32 %p4_32.i765, ptr %tmp.i730, align 4
  %t4.i766 = getelementptr inbounds nuw i8, ptr %tmp.i730, i64 4
  store i64 %t88.unpack20, ptr %t4.i766, align 4
  br label %iter.check

alloc_dst.i:                                      ; preds = %mat.i
  %raw.i735 = and i64 %t88.unpack20, -4
  %lp.i736 = inttoptr i64 %raw.i735 to ptr
  %fits.i = icmp samesign ugt i64 %len.i733, 64
  br i1 %fits.i, label %use_heap.i, label %iter.check

use_heap.i:                                       ; preds = %alloc_dst.i
  %hp.i762 = call noalias ptr @malloc(i64 %len.i733)
  %hn.i = icmp eq ptr %hp.i762, null
  br i1 %hn.i, label %oom.i763, label %iter.check

oom.i763:                                         ; preds = %use_heap.i
  call fastcc void @archx_oom_fail()
  unreachable

iter.check:                                       ; preds = %use_heap.i, %alloc_dst.i, %alloc_dst.thread.i
  %fits4.i = phi i1 [ true, %use_heap.i ], [ false, %alloc_dst.i ], [ false, %alloc_dst.thread.i ]
  %src3.i = phi ptr [ %lp.i736, %use_heap.i ], [ %lp.i736, %alloc_dst.i ], [ %tmp.i730, %alloc_dst.thread.i ]
  %dst.i737 = phi ptr [ %hp.i762, %use_heap.i ], [ %sbuf.i, %alloc_dst.i ], [ %sbuf.i, %alloc_dst.thread.i ]
  %min.iters.check = icmp samesign ult i64 %len.i733, 8
  br i1 %min.iters.check, label %loop.i.preheader, label %vector.main.loop.iter.check

vector.main.loop.iter.check:                      ; preds = %iter.check
  %min.iters.check1307 = icmp samesign ult i64 %len.i733, 32
  br i1 %min.iters.check1307, label %vec.epilog.ph, label %vector.ph

vector.ph:                                        ; preds = %vector.main.loop.iter.check
  %n.vec = and i64 %t88.unpack, 4294967264
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %2 = getelementptr inbounds nuw i8, ptr %src3.i, i64 %index
  %3 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %wide.load = load <16 x i8>, ptr %2, align 1
  %wide.load1308 = load <16 x i8>, ptr %3, align 1
  %4 = add <16 x i8> %wide.load, splat (i8 -97)
  %5 = add <16 x i8> %wide.load1308, splat (i8 -97)
  %6 = icmp ult <16 x i8> %4, splat (i8 26)
  %7 = icmp ult <16 x i8> %5, splat (i8 26)
  %8 = add <16 x i8> %wide.load, splat (i8 -32)
  %9 = add <16 x i8> %wide.load1308, splat (i8 -32)
  %10 = select <16 x i1> %6, <16 x i8> %8, <16 x i8> %wide.load
  %11 = select <16 x i1> %7, <16 x i8> %9, <16 x i8> %wide.load1308
  %12 = getelementptr inbounds nuw i8, ptr %dst.i737, i64 %index
  %13 = getelementptr inbounds nuw i8, ptr %12, i64 16
  store <16 x i8> %10, ptr %12, align 1
  store <16 x i8> %11, ptr %13, align 1
  %index.next = add nuw i64 %index, 32
  %14 = icmp eq i64 %index.next, %n.vec
  br i1 %14, label %middle.block, label %vector.body, !llvm.loop !2

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %len.i733, %n.vec
  br i1 %cmp.n, label %chk_big.i.i740, label %vec.epilog.iter.check

vec.epilog.iter.check:                            ; preds = %middle.block
  %n.vec.remaining = and i64 %t88.unpack, 24
  %min.epilog.iters.check = icmp eq i64 %n.vec.remaining, 0
  br i1 %min.epilog.iters.check, label %loop.i.preheader, label %vec.epilog.ph

vec.epilog.ph:                                    ; preds = %vec.epilog.iter.check, %vector.main.loop.iter.check
  %vec.epilog.resume.val = phi i64 [ %n.vec, %vec.epilog.iter.check ], [ 0, %vector.main.loop.iter.check ]
  %n.vec1310 = and i64 %t88.unpack, 4294967288
  br label %vec.epilog.vector.body

vec.epilog.vector.body:                           ; preds = %vec.epilog.vector.body, %vec.epilog.ph
  %index1311 = phi i64 [ %vec.epilog.resume.val, %vec.epilog.ph ], [ %index.next1313, %vec.epilog.vector.body ]
  %15 = getelementptr inbounds nuw i8, ptr %src3.i, i64 %index1311
  %wide.load1312 = load <8 x i8>, ptr %15, align 1
  %16 = add <8 x i8> %wide.load1312, splat (i8 -97)
  %17 = icmp ult <8 x i8> %16, splat (i8 26)
  %18 = add <8 x i8> %wide.load1312, splat (i8 -32)
  %19 = select <8 x i1> %17, <8 x i8> %18, <8 x i8> %wide.load1312
  %20 = getelementptr inbounds nuw i8, ptr %dst.i737, i64 %index1311
  store <8 x i8> %19, ptr %20, align 1
  %index.next1313 = add nuw i64 %index1311, 8
  %21 = icmp eq i64 %index.next1313, %n.vec1310
  br i1 %21, label %vec.epilog.middle.block, label %vec.epilog.vector.body, !llvm.loop !5

vec.epilog.middle.block:                          ; preds = %vec.epilog.vector.body
  %cmp.n1314 = icmp eq i64 %len.i733, %n.vec1310
  br i1 %cmp.n1314, label %chk_big.i.i740, label %loop.i.preheader

loop.i.preheader:                                 ; preds = %vec.epilog.iter.check, %vec.epilog.middle.block, %iter.check
  %i.i.ph = phi i64 [ 0, %iter.check ], [ %n.vec, %vec.epilog.iter.check ], [ %n.vec1310, %vec.epilog.middle.block ]
  br label %loop.i

loop.i:                                           ; preds = %loop.i.preheader, %loop.i
  %i.i = phi i64 [ %inext.i, %loop.i ], [ %i.i.ph, %loop.i.preheader ]
  %sp.i = getelementptr inbounds nuw i8, ptr %src3.i, i64 %i.i
  %c.i738 = load i8, ptr %sp.i, align 1
  %lo_s.i = add i8 %c.i738, -97
  %is_lo.i = icmp ult i8 %lo_s.i, 26
  %up_c.i = add i8 %c.i738, -32
  %c1.i = select i1 %is_lo.i, i8 %up_c.i, i8 %c.i738
  %dp.i = getelementptr inbounds nuw i8, ptr %dst.i737, i64 %i.i
  store i8 %c1.i, ptr %dp.i, align 1
  %inext.i = add nuw nsw i64 %i.i, 1
  %exitcond.not.i739 = icmp eq i64 %inext.i, %len.i733
  br i1 %exitcond.not.i739, label %chk_big.i.i740, label %loop.i, !llvm.loop !6

chk_big.i.i740:                                   ; preds = %loop.i, %vec.epilog.middle.block, %middle.block
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i729)
  %big.i.i741 = icmp samesign ugt i64 %len.i733, 2147483647
  br i1 %big.i.i741, label %oom.i.i757, label %chk_sso.i.i742

oom.i.i757:                                       ; preds = %build_long.i.i743, %chk_big.i.i740
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i742:                                   ; preds = %chk_big.i.i740
  br i1 %short.i734, label %pack_sso.i.i758, label %build_long.i.i743

pack_sso.i.i758:                                  ; preds = %chk_sso.i.i742
  %len32.i.i759 = trunc i64 %t88.unpack to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i729, i8 0, i64 16, i1 false)
  store i32 %len32.i.i759, ptr %sso.i.i729, align 8
  %sso.i.i729.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i729, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i729.4.sroa_idx, ptr nonnull readonly align 1 %dst.i737, i64 %len.i733, i1 false)
  %sso.i.i729.0.sso.i.i729.0.sso.i.i729.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i760 = load i64, ptr %sso.i.i729, align 8
  %sso.i.i729.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i729, i64 8
  %sso.i.i729.8.sso.i.i729.8.sso.i.i729.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i761 = load i64, ptr %sso.i.i729.8.sroa_idx, align 8
  br label %archx_str_from_slice.exit.i753

build_long.i.i743:                                ; preds = %chk_sso.i.i742
  %hp.i.i744 = call noalias align 16 ptr @malloc(i64 %len.i733)
  %hnull.i.i745 = icmp eq ptr %hp.i.i744, null
  br i1 %hnull.i.i745, label %oom.i.i757, label %tag_heap.i.i746

tag_heap.i.i746:                                  ; preds = %build_long.i.i743
  %hp_i.i.i747 = ptrtoint ptr %hp.i.i744 to i64
  %htagged.i.i748 = or disjoint i64 %hp_i.i.i747, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i744, ptr nonnull readonly align 1 %dst.i737, i64 %len.i733, i1 false)
  %pref32.i.i749 = load i32, ptr %hp.i.i744, align 16
  %pref64.i.i750 = zext i32 %pref32.i.i749 to i64
  %pref_sh.i.i751 = shl nuw i64 %pref64.i.i750, 32
  %w0_out.i.i752 = or disjoint i64 %pref_sh.i.i751, %len.i733
  br label %archx_str_from_slice.exit.i753

archx_str_from_slice.exit.i753:                   ; preds = %tag_heap.i.i746, %pack_sso.i.i758
  %sso.i.0.sso.0.sso.0.sso.0.sw0.i.pn.i = phi i64 [ %sso.i.i729.0.sso.i.i729.0.sso.i.i729.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i760, %pack_sso.i.i758 ], [ %w0_out.i.i752, %tag_heap.i.i746 ]
  %sso.i.8.sso.8.sso.8.sso.8.sw1.i.pn.i = phi i64 [ %sso.i.i729.8.sso.i.i729.8.sso.i.i729.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i761, %pack_sso.i.i758 ], [ %htagged.i.i748, %tag_heap.i.i746 ]
  %ss0.i.pn.i = insertvalue %ArchxStr poison, i64 %sso.i.0.sso.0.sso.0.sso.0.sw0.i.pn.i, 0
  %common.ret.op.i.i754 = insertvalue %ArchxStr %ss0.i.pn.i, i64 %sso.i.8.sso.8.sso.8.sso.8.sw1.i.pn.i, 1
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i729)
  br i1 %fits4.i, label %do_free.i756, label %archx_str_case.exit

do_free.i756:                                     ; preds = %archx_str_from_slice.exit.i753
  call void @free(ptr nonnull %dst.i737)
  br label %archx_str_case.exit

archx_str_case.exit:                              ; preds = %idx.ok.27, %archx_str_from_slice.exit.i753, %do_free.i756
  %common.ret.op.i755 = phi %ArchxStr [ zeroinitializer, %idx.ok.27 ], [ %common.ret.op.i.i754, %do_free.i756 ], [ %common.ret.op.i.i754, %archx_str_from_slice.exit.i753 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i730)
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %sbuf.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i767)
  store i32 1685221239, ptr %tmp.i767, align 4
  %tmp4.i769 = getelementptr inbounds nuw i8, ptr %tmp.i767, i64 4
  store i64 14963, ptr %tmp4.i769, align 4
  %nul.i772 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i767, i32 0, i64 6)
  %has_nul.not.i773 = icmp eq ptr %nul.i772, null
  br i1 %has_nul.not.i773, label %fast_printf.i783, label %byte_loop.i774.preheader

byte_loop.i774.preheader:                         ; preds = %archx_str_case.exit
  %pc.i779 = call i32 @putchar(i32 119)
  %bp.i776.1 = getelementptr inbounds nuw i8, ptr %tmp.i767, i64 1
  %ch8.i777.1 = load i8, ptr %bp.i776.1, align 1
  %ch32.i778.1 = zext i8 %ch8.i777.1 to i32
  %pc.i779.1 = call i32 @putchar(i32 %ch32.i778.1)
  %bp.i776.2 = getelementptr inbounds nuw i8, ptr %tmp.i767, i64 2
  %ch8.i777.2 = load i8, ptr %bp.i776.2, align 2
  %ch32.i778.2 = zext i8 %ch8.i777.2 to i32
  %pc.i779.2 = call i32 @putchar(i32 %ch32.i778.2)
  %bp.i776.3 = getelementptr inbounds nuw i8, ptr %tmp.i767, i64 3
  %ch8.i777.3 = load i8, ptr %bp.i776.3, align 1
  %ch32.i778.3 = zext i8 %ch8.i777.3 to i32
  %pc.i779.3 = call i32 @putchar(i32 %ch32.i778.3)
  %ch8.i777.4 = load i8, ptr %tmp4.i769, align 4
  %ch32.i778.4 = zext i8 %ch8.i777.4 to i32
  %pc.i779.4 = call i32 @putchar(i32 %ch32.i778.4)
  %bp.i776.5 = getelementptr inbounds nuw i8, ptr %tmp.i767, i64 5
  %ch8.i777.5 = load i8, ptr %bp.i776.5, align 1
  %ch32.i778.5 = zext i8 %ch8.i777.5 to i32
  %pc.i779.5 = call i32 @putchar(i32 %ch32.i778.5)
  br label %archx_str_print.exit785

fast_printf.i783:                                 ; preds = %archx_str_case.exit
  %np.i784 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 6, ptr nonnull %tmp.i767)
  br label %archx_str_print.exit785

archx_str_print.exit785:                          ; preds = %byte_loop.i774.preheader, %fast_printf.i783
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i767)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i786)
  store i32 2128928, ptr %tmp.i786, align 4
  %tmp4.i788 = getelementptr inbounds nuw i8, ptr %tmp.i786, i64 4
  store i64 0, ptr %tmp4.i788, align 4
  %nul.i791 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i786, i32 0, i64 3)
  %has_nul.not.i792 = icmp eq ptr %nul.i791, null
  br i1 %has_nul.not.i792, label %fast_printf.i802, label %byte_loop.i793.preheader

byte_loop.i793.preheader:                         ; preds = %archx_str_print.exit785
  %pc.i798 = call i32 @putchar(i32 32)
  %bp.i795.1 = getelementptr inbounds nuw i8, ptr %tmp.i786, i64 1
  %ch8.i796.1 = load i8, ptr %bp.i795.1, align 1
  %ch32.i797.1 = zext i8 %ch8.i796.1 to i32
  %pc.i798.1 = call i32 @putchar(i32 %ch32.i797.1)
  %bp.i795.2 = getelementptr inbounds nuw i8, ptr %tmp.i786, i64 2
  %ch8.i796.2 = load i8, ptr %bp.i795.2, align 2
  %ch32.i797.2 = zext i8 %ch8.i796.2 to i32
  %pc.i798.2 = call i32 @putchar(i32 %ch32.i797.2)
  br label %archx_str_print.exit804

fast_printf.i802:                                 ; preds = %archx_str_print.exit785
  %np.i803 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 3, ptr nonnull %tmp.i786)
  br label %archx_str_print.exit804

archx_str_print.exit804:                          ; preds = %byte_loop.i793.preheader, %fast_printf.i802
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i786)
  %t90 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %vlen.ph.lcssa7.i1266)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i805)
  store i32 2128928, ptr %tmp.i805, align 4
  %tmp4.i807 = getelementptr inbounds nuw i8, ptr %tmp.i805, i64 4
  store i64 0, ptr %tmp4.i807, align 4
  %nul.i810 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i805, i32 0, i64 3)
  %has_nul.not.i811 = icmp eq ptr %nul.i810, null
  br i1 %has_nul.not.i811, label %fast_printf.i821, label %byte_loop.i812.preheader

byte_loop.i812.preheader:                         ; preds = %archx_str_print.exit804
  %pc.i817 = call i32 @putchar(i32 32)
  %bp.i814.1 = getelementptr inbounds nuw i8, ptr %tmp.i805, i64 1
  %ch8.i815.1 = load i8, ptr %bp.i814.1, align 1
  %ch32.i816.1 = zext i8 %ch8.i815.1 to i32
  %pc.i817.1 = call i32 @putchar(i32 %ch32.i816.1)
  %bp.i814.2 = getelementptr inbounds nuw i8, ptr %tmp.i805, i64 2
  %ch8.i815.2 = load i8, ptr %bp.i814.2, align 2
  %ch32.i816.2 = zext i8 %ch8.i815.2 to i32
  %pc.i817.2 = call i32 @putchar(i32 %ch32.i816.2)
  br label %archx_str_print.exit823

fast_printf.i821:                                 ; preds = %archx_str_print.exit804
  %np.i822 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 3, ptr nonnull %tmp.i805)
  br label %archx_str_print.exit823

archx_str_print.exit823:                          ; preds = %byte_loop.i812.preheader, %fast_printf.i821
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i805)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i824)
  %w0.i825 = extractvalue %ArchxStr %common.ret.op.i755, 0
  %w1.i826 = extractvalue %ArchxStr %common.ret.op.i755, 1
  %len.i827 = and i64 %w0.i825, 4294967295
  %short.i828 = icmp samesign ult i64 %len.i827, 13
  br i1 %short.i828, label %emit.i848, label %emit.thread.i829

emit.thread.i829:                                 ; preds = %archx_str_print.exit823
  %raw.i830 = and i64 %w1.i826, -4
  %lptr.i831 = inttoptr i64 %raw.i830 to ptr
  br label %chk_nul.i832

emit.i848:                                        ; preds = %archx_str_print.exit823
  %p4.i849 = lshr i64 %w0.i825, 32
  %p4_32.i850 = trunc nuw i64 %p4.i849 to i32
  store i32 %p4_32.i850, ptr %tmp.i824, align 4
  %tmp4.i851 = getelementptr inbounds nuw i8, ptr %tmp.i824, i64 4
  store i64 %w1.i826, ptr %tmp4.i851, align 4
  %pos.not.i852 = icmp eq i64 %len.i827, 0
  br i1 %pos.not.i852, label %archx_str_print.exit853.thread, label %chk_nul.i832

archx_str_print.exit853.thread:                   ; preds = %emit.i848
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i824)
  %t911124 = call i32 @putchar(i32 10)
  br label %archx_str_drop.exit89

chk_nul.i832:                                     ; preds = %emit.i848, %emit.thread.i829
  %data3.i833 = phi ptr [ %lptr.i831, %emit.thread.i829 ], [ %tmp.i824, %emit.i848 ]
  %nul.i834 = call ptr @memchr(ptr nonnull %data3.i833, i32 0, i64 %len.i827)
  %has_nul.not.i835 = icmp eq ptr %nul.i834, null
  br i1 %has_nul.not.i835, label %fast_printf.i845, label %byte_loop.i836

fast_printf.i845:                                 ; preds = %chk_nul.i832
  %len32.i846 = trunc i64 %w0.i825 to i32
  %np.i847 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 %len32.i846, ptr nonnull %data3.i833)
  br label %archx_str_print.exit853

byte_loop.i836:                                   ; preds = %chk_nul.i832, %byte_loop.i836
  %bi.i837 = phi i64 [ %bnext.i842, %byte_loop.i836 ], [ 0, %chk_nul.i832 ]
  %bp.i838 = getelementptr inbounds nuw i8, ptr %data3.i833, i64 %bi.i837
  %ch8.i839 = load i8, ptr %bp.i838, align 1
  %ch32.i840 = zext i8 %ch8.i839 to i32
  %pc.i841 = call i32 @putchar(i32 %ch32.i840)
  %bnext.i842 = add nuw nsw i64 %bi.i837, 1
  %exitcond.not.i843 = icmp eq i64 %bnext.i842, %len.i827
  br i1 %exitcond.not.i843, label %archx_str_print.exit853, label %byte_loop.i836

archx_str_print.exit853:                          ; preds = %byte_loop.i836, %fast_printf.i845
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i824)
  %t91 = call i32 @putchar(i32 10)
  %tag.i84 = and i64 %w1.i826, 1
  %owned.not.i85 = icmp eq i64 %tag.i84, 0
  %or.cond1137 = select i1 %short.i828, i1 true, i1 %owned.not.i85
  br i1 %or.cond1137, label %archx_str_drop.exit89, label %do_free.i86

do_free.i86:                                      ; preds = %archx_str_print.exit853
  %raw.i87 = and i64 %w1.i826, -2
  %ptr.i88 = inttoptr i64 %raw.i87 to ptr
  call void @free(ptr %ptr.i88)
  br label %archx_str_drop.exit89

archx_str_drop.exit89:                            ; preds = %archx_str_print.exit853.thread, %archx_str_print.exit853, %do_free.i86
  %cur.i = load ptr, ptr %func.region, align 8
  %end.i23 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i = ptrtoint ptr %cur.i to i64
  %end_i.i = ptrtoint ptr %end.i23 to i64
  %rem.i = sub i64 %end_i.i, %cur_i.i
  %fits.not.i = icmp slt i64 %rem.i, 8000
  br i1 %fits.not.i, label %fallback.i, label %fast.i

fast.i:                                           ; preds = %archx_str_drop.exit89
  %next.i = getelementptr inbounds nuw i8, ptr %cur.i, i64 8000
  store ptr %next.i, ptr %func.region, align 8
  br label %archx_region_alloc.exit

fallback.i:                                       ; preds = %archx_str_drop.exit89
  %res.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 8000)
  br label %archx_region_alloc.exit

archx_region_alloc.exit:                          ; preds = %fast.i, %fallback.i
  %common.ret.op.i = phi ptr [ %cur.i, %fast.i ], [ %res.i, %fallback.i ]
  %t108.1 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 800
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(8000) %common.ret.op.i, i8 0, i64 8000, i1 false)
  store i64 10, ptr %t108.1, align 8
  %t108.2 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 1600
  store i64 20, ptr %t108.2, align 8
  %t108.3 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 2400
  store i64 30, ptr %t108.3, align 8
  %t108.4 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 3200
  store i64 40, ptr %t108.4, align 8
  %t108.5 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 4000
  store i64 50, ptr %t108.5, align 8
  %t108.6 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 4800
  store i64 60, ptr %t108.6, align 8
  %t108.7 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 5600
  store i64 70, ptr %t108.7, align 8
  %t108.8 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 6400
  store i64 80, ptr %t108.8, align 8
  %t108.9 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 7200
  store i64 90, ptr %t108.9, align 8
  %t5.i857 = fdiv double %t5.i.4, 5.000000e+00
  %t129 = call fastcc { i64, i64 } @archx_str_from_float(double %t5.i857, ptr nonnull %func.region)
  %newret1289 = extractvalue { i64, i64 } %t129, 0
  %newret1291 = extractvalue { i64, i64 } %t129, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i284)
  %blen.i288 = and i64 %newret1289, 4294967295
  %bz.i290 = icmp eq i64 %blen.i288, 0
  br i1 %bz.i290, label %archx_str_concat.exit336, label %calc_tot.i291

calc_tot.i291:                                    ; preds = %archx_region_alloc.exit
  %tot.i292 = add nuw nsw i64 %blen.i288, 5
  %too_big.i293 = icmp samesign ugt i64 %blen.i288, 2147483642
  br i1 %too_big.i293, label %oom.i320, label %mat_a.i294

oom.i320:                                         ; preds = %calc_tot.i291
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i294:                                       ; preds = %calc_tot.i291
  %bshort.i299 = icmp samesign ult i64 %blen.i288, 13
  br i1 %bshort.i299, label %build.i303, label %build.i303.thread

build.i303.thread:                                ; preds = %mat_a.i294
  %braw.i301 = and i64 %newret1291, -4
  %blptr.i302 = inttoptr i64 %braw.i301 to ptr
  br label %build_long.i306

build.i303:                                       ; preds = %mat_a.i294
  %bp4.i331 = lshr i64 %newret1289, 32
  %bp4_32.i332 = trunc nuw i64 %bp4.i331 to i32
  store i32 %bp4_32.i332, ptr %btmp.i284, align 4
  %btmp4.i333 = getelementptr inbounds nuw i8, ptr %btmp.i284, i64 4
  store i64 %newret1291, ptr %btmp4.i333, align 4
  %fits_sso.i305 = icmp samesign ult i64 %blen.i288, 8
  br i1 %fits_sso.i305, label %build_sso.i321, label %build_long.i306

build_sso.i321:                                   ; preds = %build.i303
  store i56 0, ptr %out_sso.i285.sroa.6.sroa.5.sroa.0, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i285.sroa.6.sroa.5.sroa.0, ptr nonnull align 4 %btmp.i284, i64 %blen.i288, i1 false)
  %out_sso.i285.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i292, 7953749935738847232
  %out_sso.i285.sroa.6.sroa.5.sroa.0.0.out_sso.i285.sroa.6.sroa.5.sroa.0.0.out_sso.i285.sroa.6.sroa.5.sroa.0.0.out_sso.i285.sroa.6.sroa.5.sroa.0.0.out_sso.i285.sroa.6.sroa.5.0.out_sso.i285.sroa.6.8.rw1.i327 = load i56, ptr %out_sso.i285.sroa.6.sroa.5.sroa.0, align 8
  %out_sso.i285.sroa.6.sroa.5.0.insert.ext = zext i56 %out_sso.i285.sroa.6.sroa.5.sroa.0.0.out_sso.i285.sroa.6.sroa.5.sroa.0.0.out_sso.i285.sroa.6.sroa.5.sroa.0.0.out_sso.i285.sroa.6.sroa.5.sroa.0.0.out_sso.i285.sroa.6.sroa.5.0.out_sso.i285.sroa.6.8.rw1.i327 to i64
  %out_sso.i285.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i285.sroa.6.sroa.5.0.insert.ext, 8
  %out_sso.i285.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i285.sroa.6.sroa.5.0.insert.shift, 61
  %rs0.i328 = insertvalue %ArchxStr poison, i64 %out_sso.i285.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i329 = insertvalue %ArchxStr %rs0.i328, i64 %out_sso.i285.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit336

build_long.i306:                                  ; preds = %build.i303.thread, %build.i303
  %bptr.i3041270 = phi ptr [ %blptr.i302, %build.i303.thread ], [ %btmp.i284, %build.i303 ]
  %a1.i.i = add i64 %newret1289, 20
  %aligned.i.i = and i64 %a1.i.i, 4294967280
  %cur.i.i = load ptr, ptr %func.region, align 8
  %end.i.i = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i = ptrtoint ptr %cur.i.i to i64
  %end_i.i.i = ptrtoint ptr %end.i.i to i64
  %rem.i.i = sub i64 %end_i.i.i, %cur_i.i.i
  %fits.not.i.i = icmp slt i64 %rem.i.i, %aligned.i.i
  br i1 %fits.not.i.i, label %fallback.i.i, label %fast.i.i

fast.i.i:                                         ; preds = %build_long.i306
  %next.i.i = getelementptr inbounds nuw i8, ptr %cur.i.i, i64 %aligned.i.i
  store ptr %next.i.i, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i

fallback.i.i:                                     ; preds = %build_long.i306
  %res.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i)
  %.pre1255 = ptrtoint ptr %res.i.i to i64
  br label %archx_region_alloc.exit.i

archx_region_alloc.exit.i:                        ; preds = %fallback.i.i, %fast.i.i
  %rp_i.i.pre-phi = phi i64 [ %.pre1255, %fallback.i.i ], [ %cur_i.i.i, %fast.i.i ]
  %common.ret.op.i.i = phi ptr [ %res.i.i, %fallback.i.i ], [ %cur.i.i, %fast.i.i ]
  %rtagged.i = or disjoint i64 %rp_i.i.pre-phi, 2
  store i32 1851876717, ptr %common.ret.op.i.i, align 16
  %atmp.i283.sroa.5.0.common.ret.op.i.i.sroa_idx = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i, i64 4
  store i8 61, ptr %atmp.i283.sroa.5.0.common.ret.op.i.i.sroa_idx, align 4
  %dst_b.i307 = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i, i64 5
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i307, ptr nonnull align 1 %bptr.i3041270, i64 %blen.i288, i1 false)
  %w0_out.i311 = or disjoint i64 %tot.i292, 7953749935738847232
  %ls0.i312 = insertvalue %ArchxStr poison, i64 %w0_out.i311, 0
  %ls1.i313 = insertvalue %ArchxStr %ls0.i312, i64 %rtagged.i, 1
  br label %archx_str_concat.exit336

archx_str_concat.exit336:                         ; preds = %archx_region_alloc.exit, %build_sso.i321, %archx_region_alloc.exit.i
  %common.ret.op.i314 = phi %ArchxStr [ %rs1.i329, %build_sso.i321 ], [ %ls1.i313, %archx_region_alloc.exit.i ], [ { i64 7953749935738847237, i64 61 }, %archx_region_alloc.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i284)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i337)
  %aw0.i340 = extractvalue %ArchxStr %common.ret.op.i314, 0
  %aw1.i341 = extractvalue %ArchxStr %common.ret.op.i314, 1
  %alen.i342 = and i64 %aw0.i340, 4294967295
  %az.i343 = icmp eq i64 %alen.i342, 0
  br i1 %az.i343, label %archx_str_concat.exit407, label %chk_bz.i344

chk_bz.i344:                                      ; preds = %archx_str_concat.exit336
  %tot.i346 = add nuw nsw i64 %alen.i342, 12
  %too_big.i347 = icmp samesign ugt i64 %alen.i342, 2147483635
  br i1 %too_big.i347, label %oom.i391, label %mat_a.i348

oom.i391:                                         ; preds = %chk_bz.i344
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i348:                                       ; preds = %chk_bz.i344
  %ashort.i349 = icmp samesign ult i64 %alen.i342, 13
  br i1 %ashort.i349, label %mat_a_short.i401, label %mat_a_long.i350

mat_a_short.i401:                                 ; preds = %mat_a.i348
  %ap4.i402 = lshr i64 %aw0.i340, 32
  %ap4_32.i403 = trunc nuw i64 %ap4.i402 to i32
  store i32 %ap4_32.i403, ptr %atmp.i337, align 4
  %atmp4.i404 = getelementptr inbounds nuw i8, ptr %atmp.i337, i64 4
  store i64 %aw1.i341, ptr %atmp4.i404, align 4
  br label %build_long.i360

mat_a_long.i350:                                  ; preds = %mat_a.i348
  %araw.i351 = and i64 %aw1.i341, -4
  %alptr.i352 = inttoptr i64 %araw.i351 to ptr
  br label %build_long.i360

build_long.i360:                                  ; preds = %mat_a_short.i401, %mat_a_long.i350
  %aptr.i354 = phi ptr [ %atmp.i337, %mat_a_short.i401 ], [ %alptr.i352, %mat_a_long.i350 ]
  %a1.i.i361 = add i64 %aw0.i340, 27
  %aligned.i.i362 = and i64 %a1.i.i361, 4294967280
  %cur.i.i364 = load ptr, ptr %func.region, align 8
  %end.i.i365 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i366 = ptrtoint ptr %cur.i.i364 to i64
  %end_i.i.i367 = ptrtoint ptr %end.i.i365 to i64
  %rem.i.i368 = sub i64 %end_i.i.i367, %cur_i.i.i366
  %fits.not.i.i369 = icmp slt i64 %rem.i.i368, %aligned.i.i362
  br i1 %fits.not.i.i369, label %fallback.i.i384, label %fast.i.i370

fast.i.i370:                                      ; preds = %build_long.i360
  %next.i.i371 = getelementptr inbounds nuw i8, ptr %cur.i.i364, i64 %aligned.i.i362
  store ptr %next.i.i371, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i372

fallback.i.i384:                                  ; preds = %build_long.i360
  %res.i.i385 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i362)
  %.pre1254 = ptrtoint ptr %res.i.i385 to i64
  br label %archx_region_alloc.exit.i372

archx_region_alloc.exit.i372:                     ; preds = %fallback.i.i384, %fast.i.i370
  %rp_i.i374.pre-phi = phi i64 [ %.pre1254, %fallback.i.i384 ], [ %cur_i.i.i366, %fast.i.i370 ]
  %common.ret.op.i.i373 = phi ptr [ %res.i.i385, %fallback.i.i384 ], [ %cur.i.i364, %fast.i.i370 ]
  %rtagged.i375 = or disjoint i64 %rp_i.i374.pre-phi, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i373, ptr nonnull align 1 %aptr.i354, i64 %alen.i342, i1 false)
  %dst_b.i376 = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i373, i64 %alen.i342
  store i32 1868767276, ptr %dst_b.i376, align 1
  %btmp.i338.sroa.5.0.dst_b.i376.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i376, i64 4
  store i64 4426606804062203509, ptr %btmp.i338.sroa.5.0.dst_b.i376.sroa_idx, align 1
  %pref32.i377 = load i32, ptr %common.ret.op.i.i373, align 16
  %pref64.i378 = zext i32 %pref32.i377 to i64
  %pref_sh.i379 = shl nuw i64 %pref64.i378, 32
  %w0_out.i380 = or disjoint i64 %pref_sh.i379, %tot.i346
  %ls0.i381 = insertvalue %ArchxStr poison, i64 %w0_out.i380, 0
  %ls1.i382 = insertvalue %ArchxStr %ls0.i381, i64 %rtagged.i375, 1
  br label %archx_str_concat.exit407

archx_str_concat.exit407:                         ; preds = %archx_str_concat.exit336, %archx_region_alloc.exit.i372
  %common.ret.op.i383 = phi %ArchxStr [ %ls1.i382, %archx_region_alloc.exit.i372 ], [ { i64 8026294334255005708, i64 4426606804062203509 }, %archx_str_concat.exit336 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i337)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i860)
  %n32.i861 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i860, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 30)
  %len.i862 = sext i32 %n32.i861 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i1005)
  %z.i1006 = icmp slt i32 %n32.i861, 1
  br i1 %z.i1006, label %archx_str_from_slice.exit1050, label %chk_sso.i1009

chk_sso.i1009:                                    ; preds = %archx_str_concat.exit407
  %short.i1010 = icmp samesign ult i32 %n32.i861, 13
  br i1 %short.i1010, label %pack_sso.i1042, label %build_long.i1011

pack_sso.i1042:                                   ; preds = %chk_sso.i1009
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i1005, i8 0, i64 16, i1 false)
  store i32 %n32.i861, ptr %sso.i1005, align 8
  %sso.i1005.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i1005, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i1005.4.sroa_idx, ptr nonnull readonly align 8 %buf.i860, i64 %len.i862, i1 false)
  %sso.i1005.0.sso.i1005.0.sso.i1005.0.sso.0.sso.0.sso.0.sw0.i1046 = load i64, ptr %sso.i1005, align 8
  %sso.i1005.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i1005, i64 8
  %sso.i1005.8.sso.i1005.8.sso.i1005.8.sso.8.sso.8.sso.8.sw1.i1047 = load i64, ptr %sso.i1005.8.sroa_idx, align 8
  %ss0.i1048 = insertvalue %ArchxStr poison, i64 %sso.i1005.0.sso.i1005.0.sso.i1005.0.sso.0.sso.0.sso.0.sw0.i1046, 0
  %ss1.i1049 = insertvalue %ArchxStr %ss0.i1048, i64 %sso.i1005.8.sso.i1005.8.sso.i1005.8.sso.8.sso.8.sso.8.sw1.i1047, 1
  br label %archx_str_from_slice.exit1050

build_long.i1011:                                 ; preds = %chk_sso.i1009
  %a1.i.i1012 = add nuw nsw i64 %len.i862, 15
  %aligned.i.i1013 = and i64 %a1.i.i1012, 4294967280
  %cur.i.i1015 = load ptr, ptr %func.region, align 8
  %end.i.i1016 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i1017 = ptrtoint ptr %cur.i.i1015 to i64
  %end_i.i.i1018 = ptrtoint ptr %end.i.i1016 to i64
  %rem.i.i1019 = sub i64 %end_i.i.i1018, %cur_i.i.i1017
  %fits.not.i.i1020 = icmp slt i64 %rem.i.i1019, %aligned.i.i1013
  br i1 %fits.not.i.i1020, label %fallback.i.i1034, label %fast.i.i1021

fast.i.i1021:                                     ; preds = %build_long.i1011
  %next.i.i1022 = getelementptr inbounds nuw i8, ptr %cur.i.i1015, i64 %aligned.i.i1013
  store ptr %next.i.i1022, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i1023

fallback.i.i1034:                                 ; preds = %build_long.i1011
  %res.i.i1035 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i1013)
  %.pre.i = ptrtoint ptr %res.i.i1035 to i64
  br label %archx_region_alloc.exit.i1023

archx_region_alloc.exit.i1023:                    ; preds = %fallback.i.i1034, %fast.i.i1021
  %rp_i.pre-phi.i = phi i64 [ %cur_i.i.i1017, %fast.i.i1021 ], [ %.pre.i, %fallback.i.i1034 ]
  %common.ret.op.i.i1024 = phi ptr [ %cur.i.i1015, %fast.i.i1021 ], [ %res.i.i1035, %fallback.i.i1034 ]
  %rtagged.i1025 = or disjoint i64 %rp_i.pre-phi.i, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i1024, ptr nonnull readonly align 8 %buf.i860, i64 %len.i862, i1 false)
  %pref32.i1027 = load i32, ptr %common.ret.op.i.i1024, align 16
  %pref64.i1028 = zext i32 %pref32.i1027 to i64
  %pref_sh.i1029 = shl nuw i64 %pref64.i1028, 32
  %w0_out.i1030 = or disjoint i64 %pref_sh.i1029, %len.i862
  %ls0.i1031 = insertvalue %ArchxStr poison, i64 %w0_out.i1030, 0
  %ls1.i1032 = insertvalue %ArchxStr %ls0.i1031, i64 %rtagged.i1025, 1
  br label %archx_str_from_slice.exit1050

archx_str_from_slice.exit1050:                    ; preds = %archx_str_concat.exit407, %pack_sso.i1042, %archx_region_alloc.exit.i1023
  %common.ret.op.i1033 = phi %ArchxStr [ %ss1.i1049, %pack_sso.i1042 ], [ %ls1.i1032, %archx_region_alloc.exit.i1023 ], [ zeroinitializer, %archx_str_concat.exit407 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i1005)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i860)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i408)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i409)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i410)
  %aw0.i411 = extractvalue %ArchxStr %common.ret.op.i383, 0
  %aw1.i412 = extractvalue %ArchxStr %common.ret.op.i383, 1
  %bw0.i413 = extractvalue %ArchxStr %common.ret.op.i1033, 0
  %bw1.i414 = extractvalue %ArchxStr %common.ret.op.i1033, 1
  %alen.i415 = and i64 %aw0.i411, 4294967295
  %blen.i416 = and i64 %bw0.i413, 4294967295
  %az.i417 = icmp eq i64 %alen.i415, 0
  br i1 %az.i417, label %ret_b.i490, label %chk_bz.i418

ret_b.i490:                                       ; preds = %archx_str_from_slice.exit1050
  %bw1_tag.i491 = and i64 %bw1.i414, 1
  %b_owned.i492 = icmp eq i64 %bw1_tag.i491, 0
  %long.i866 = icmp samesign ult i64 %blen.i416, 13
  %or.cond1138.not1155 = select i1 %b_owned.i492, i1 true, i1 %long.i866
  %tag.i870 = and i64 %bw1.i414, 3
  %owned.not.i871 = icmp eq i64 %tag.i870, 0
  %or.cond1139 = select i1 %or.cond1138.not1155, i1 true, i1 %owned.not.i871
  br i1 %or.cond1139, label %archx_str_concat.exit494, label %dup_heap.i872

dup_heap.i872:                                    ; preds = %ret_b.i490
  %dst.i873 = call noalias align 16 ptr @malloc(i64 %blen.i416)
  %isnull.i874 = icmp eq ptr %dst.i873, null
  br i1 %isnull.i874, label %oom.i881, label %copy.i875

oom.i881:                                         ; preds = %dup_heap.i872
  call fastcc void @archx_oom_fail()
  unreachable

copy.i875:                                        ; preds = %dup_heap.i872
  %src_i.i876 = and i64 %bw1.i414, -4
  %src.i877 = inttoptr i64 %src_i.i876 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i873, ptr nonnull align 4 %src.i877, i64 %blen.i416, i1 false)
  %dst_i.i878 = ptrtoint ptr %dst.i873 to i64
  %tagged.i879 = or disjoint i64 %dst_i.i878, 1
  %out.i880 = insertvalue %ArchxStr %common.ret.op.i1033, i64 %tagged.i879, 1
  br label %archx_str_concat.exit494

chk_bz.i418:                                      ; preds = %archx_str_from_slice.exit1050
  %bz.i419 = icmp eq i64 %blen.i416, 0
  br i1 %bz.i419, label %ret_a.i486, label %calc_tot.i420

ret_a.i486:                                       ; preds = %chk_bz.i418
  %aw1_tag.i487 = and i64 %aw1.i412, 1
  %a_owned.i488 = icmp eq i64 %aw1_tag.i487, 0
  %long.i885 = icmp samesign ult i64 %alen.i415, 13
  %or.cond1140.not1154 = select i1 %a_owned.i488, i1 true, i1 %long.i885
  %tag.i889 = and i64 %aw1.i412, 3
  %owned.not.i890 = icmp eq i64 %tag.i889, 0
  %or.cond1141 = select i1 %or.cond1140.not1154, i1 true, i1 %owned.not.i890
  br i1 %or.cond1141, label %archx_str_concat.exit494, label %dup_heap.i891

dup_heap.i891:                                    ; preds = %ret_a.i486
  %dst.i892 = call noalias align 16 ptr @malloc(i64 %alen.i415)
  %isnull.i893 = icmp eq ptr %dst.i892, null
  br i1 %isnull.i893, label %oom.i900, label %copy.i894

oom.i900:                                         ; preds = %dup_heap.i891
  call fastcc void @archx_oom_fail()
  unreachable

copy.i894:                                        ; preds = %dup_heap.i891
  %src_i.i895 = and i64 %aw1.i412, -4
  %src.i896 = inttoptr i64 %src_i.i895 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i892, ptr nonnull align 4 %src.i896, i64 %alen.i415, i1 false)
  %dst_i.i897 = ptrtoint ptr %dst.i892 to i64
  %tagged.i898 = or disjoint i64 %dst_i.i897, 1
  %out.i899 = insertvalue %ArchxStr %common.ret.op.i383, i64 %tagged.i898, 1
  br label %archx_str_concat.exit494

calc_tot.i420:                                    ; preds = %chk_bz.i418
  %tot.i421 = add nuw nsw i64 %blen.i416, %alen.i415
  %too_big.i422 = icmp samesign ugt i64 %tot.i421, 2147483647
  br i1 %too_big.i422, label %oom.i468, label %mat_a.i423

oom.i468:                                         ; preds = %calc_tot.i420
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i423:                                       ; preds = %calc_tot.i420
  %ashort.i424 = icmp samesign ult i64 %alen.i415, 13
  br i1 %ashort.i424, label %mat_a_short.i482, label %mat_a_long.i425

mat_a_short.i482:                                 ; preds = %mat_a.i423
  %ap4.i483 = lshr i64 %aw0.i411, 32
  %ap4_32.i484 = trunc nuw i64 %ap4.i483 to i32
  store i32 %ap4_32.i484, ptr %atmp.i408, align 4
  %atmp4.i485 = getelementptr inbounds nuw i8, ptr %atmp.i408, i64 4
  store i64 %aw1.i412, ptr %atmp4.i485, align 4
  br label %mat_b.i428

mat_a_long.i425:                                  ; preds = %mat_a.i423
  %araw.i426 = and i64 %aw1.i412, -4
  %alptr.i427 = inttoptr i64 %araw.i426 to ptr
  br label %mat_b.i428

mat_b.i428:                                       ; preds = %mat_a_long.i425, %mat_a_short.i482
  %aptr.i429 = phi ptr [ %atmp.i408, %mat_a_short.i482 ], [ %alptr.i427, %mat_a_long.i425 ]
  %bshort.i430 = icmp samesign ult i64 %blen.i416, 13
  br i1 %bshort.i430, label %mat_b_short.i478, label %mat_b_long.i431

mat_b_short.i478:                                 ; preds = %mat_b.i428
  %bp4.i479 = lshr i64 %bw0.i413, 32
  %bp4_32.i480 = trunc nuw i64 %bp4.i479 to i32
  store i32 %bp4_32.i480, ptr %btmp.i409, align 4
  %btmp4.i481 = getelementptr inbounds nuw i8, ptr %btmp.i409, i64 4
  store i64 %bw1.i414, ptr %btmp4.i481, align 4
  br label %build.i434

mat_b_long.i431:                                  ; preds = %mat_b.i428
  %braw.i432 = and i64 %bw1.i414, -4
  %blptr.i433 = inttoptr i64 %braw.i432 to ptr
  br label %build.i434

build.i434:                                       ; preds = %mat_b_long.i431, %mat_b_short.i478
  %bptr.i435 = phi ptr [ %btmp.i409, %mat_b_short.i478 ], [ %blptr.i433, %mat_b_long.i431 ]
  %fits_sso.i436 = icmp samesign ult i64 %tot.i421, 13
  br i1 %fits_sso.i436, label %build_sso.i469, label %build_long.i437

build_sso.i469:                                   ; preds = %build.i434
  %out_sso8.i470 = getelementptr inbounds nuw i8, ptr %out_sso.i410, i64 8
  %tot32.i471 = trunc nuw nsw i64 %tot.i421 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i410, i8 0, i64 16, i1 false)
  store i32 %tot32.i471, ptr %out_sso.i410, align 8
  %sso_dst_a.i472 = getelementptr inbounds nuw i8, ptr %out_sso.i410, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i472, ptr nonnull align 1 %aptr.i429, i64 %alen.i415, i1 false)
  %sso_dst_b.i473 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i472, i64 %alen.i415
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i473, ptr nonnull align 1 %bptr.i435, i64 %blen.i416, i1 false)
  %rw0.i474 = load i64, ptr %out_sso.i410, align 8
  %rw1.i475 = load i64, ptr %out_sso8.i470, align 8
  %rs0.i476 = insertvalue %ArchxStr poison, i64 %rw0.i474, 0
  %rs1.i477 = insertvalue %ArchxStr %rs0.i476, i64 %rw1.i475, 1
  br label %archx_str_concat.exit494

build_long.i437:                                  ; preds = %build.i434
  %a1.i.i438 = add nuw nsw i64 %tot.i421, 15
  %aligned.i.i439 = and i64 %a1.i.i438, 4294967280
  %cur.i.i441 = load ptr, ptr %func.region, align 8
  %end.i.i442 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i443 = ptrtoint ptr %cur.i.i441 to i64
  %end_i.i.i444 = ptrtoint ptr %end.i.i442 to i64
  %rem.i.i445 = sub i64 %end_i.i.i444, %cur_i.i.i443
  %fits.not.i.i446 = icmp slt i64 %rem.i.i445, %aligned.i.i439
  br i1 %fits.not.i.i446, label %fallback.i.i461, label %fast.i.i447

fast.i.i447:                                      ; preds = %build_long.i437
  %next.i.i448 = getelementptr inbounds nuw i8, ptr %cur.i.i441, i64 %aligned.i.i439
  store ptr %next.i.i448, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i449

fallback.i.i461:                                  ; preds = %build_long.i437
  %res.i.i462 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i439)
  %.pre1253 = ptrtoint ptr %res.i.i462 to i64
  br label %archx_region_alloc.exit.i449

archx_region_alloc.exit.i449:                     ; preds = %fallback.i.i461, %fast.i.i447
  %rp_i.i451.pre-phi = phi i64 [ %.pre1253, %fallback.i.i461 ], [ %cur_i.i.i443, %fast.i.i447 ]
  %common.ret.op.i.i450 = phi ptr [ %res.i.i462, %fallback.i.i461 ], [ %cur.i.i441, %fast.i.i447 ]
  %rtagged.i452 = or disjoint i64 %rp_i.i451.pre-phi, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i450, ptr nonnull align 1 %aptr.i429, i64 %alen.i415, i1 false)
  %dst_b.i453 = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i450, i64 %alen.i415
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i453, ptr nonnull align 1 %bptr.i435, i64 %blen.i416, i1 false)
  %pref32.i454 = load i32, ptr %common.ret.op.i.i450, align 16
  %pref64.i455 = zext i32 %pref32.i454 to i64
  %pref_sh.i456 = shl nuw i64 %pref64.i455, 32
  %w0_out.i457 = or disjoint i64 %pref_sh.i456, %tot.i421
  %ls0.i458 = insertvalue %ArchxStr poison, i64 %w0_out.i457, 0
  %ls1.i459 = insertvalue %ArchxStr %ls0.i458, i64 %rtagged.i452, 1
  br label %archx_str_concat.exit494

archx_str_concat.exit494:                         ; preds = %copy.i894, %copy.i875, %ret_b.i490, %ret_a.i486, %build_sso.i469, %archx_region_alloc.exit.i449
  %common.ret.op.i460 = phi %ArchxStr [ %rs1.i477, %build_sso.i469 ], [ %ls1.i459, %archx_region_alloc.exit.i449 ], [ %common.ret.op.i1033, %ret_b.i490 ], [ %common.ret.op.i383, %ret_a.i486 ], [ %out.i880, %copy.i875 ], [ %out.i899, %copy.i894 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i408)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i409)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i410)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i495)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i497)
  %aw0.i498 = extractvalue %ArchxStr %common.ret.op.i460, 0
  %aw1.i499 = extractvalue %ArchxStr %common.ret.op.i460, 1
  %alen.i500 = and i64 %aw0.i498, 4294967295
  %az.i501 = icmp eq i64 %alen.i500, 0
  br i1 %az.i501, label %archx_str_concat.exit566, label %chk_bz.i502

chk_bz.i502:                                      ; preds = %archx_str_concat.exit494
  %tot.i504 = add nuw nsw i64 %alen.i500, 9
  %too_big.i505 = icmp samesign ugt i64 %alen.i500, 2147483638
  br i1 %too_big.i505, label %oom.i549, label %mat_a.i506

oom.i549:                                         ; preds = %chk_bz.i502
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i506:                                       ; preds = %chk_bz.i502
  %ashort.i507 = icmp samesign ult i64 %alen.i500, 13
  br i1 %ashort.i507, label %mat_b.i511, label %mat_b.i511.thread

mat_b.i511.thread:                                ; preds = %mat_a.i506
  %araw.i509 = and i64 %aw1.i499, -4
  %alptr.i510 = inttoptr i64 %araw.i509 to ptr
  br label %build_long.i518

mat_b.i511:                                       ; preds = %mat_a.i506
  %ap4.i560 = lshr i64 %aw0.i498, 32
  %ap4_32.i561 = trunc nuw i64 %ap4.i560 to i32
  store i32 %ap4_32.i561, ptr %atmp.i495, align 4
  %atmp4.i562 = getelementptr inbounds nuw i8, ptr %atmp.i495, i64 4
  store i64 %aw1.i499, ptr %atmp4.i562, align 4
  %fits_sso.i517 = icmp samesign ult i64 %alen.i500, 4
  br i1 %fits_sso.i517, label %build_sso.i550, label %build_long.i518

build_sso.i550:                                   ; preds = %mat_b.i511
  %out_sso8.i551 = getelementptr inbounds nuw i8, ptr %out_sso.i497, i64 8
  %tot32.i552 = trunc nuw nsw i64 %tot.i504 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i497, i8 0, i64 16, i1 false)
  store i32 %tot32.i552, ptr %out_sso.i497, align 8
  %sso_dst_a.i553 = getelementptr inbounds nuw i8, ptr %out_sso.i497, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i553, ptr nonnull align 4 %atmp.i495, i64 %alen.i500, i1 false)
  %sso_dst_b.i554 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i553, i64 %alen.i500
  store i32 1969365036, ptr %sso_dst_b.i554, align 1
  %btmp.i496.sroa.5.0.sso_dst_b.i554.sroa_idx = getelementptr inbounds nuw i8, ptr %sso_dst_b.i554, i64 4
  store i40 262801471846, ptr %btmp.i496.sroa.5.0.sso_dst_b.i554.sroa_idx, align 1
  %rw0.i555 = load i64, ptr %out_sso.i497, align 8
  %rw1.i556 = load i64, ptr %out_sso8.i551, align 8
  %rs0.i557 = insertvalue %ArchxStr poison, i64 %rw0.i555, 0
  %rs1.i558 = insertvalue %ArchxStr %rs0.i557, i64 %rw1.i556, 1
  br label %archx_str_concat.exit566

build_long.i518:                                  ; preds = %mat_b.i511.thread, %mat_b.i511
  %aptr.i5121128 = phi ptr [ %alptr.i510, %mat_b.i511.thread ], [ %atmp.i495, %mat_b.i511 ]
  %a1.i.i519 = add i64 %aw0.i498, 24
  %aligned.i.i520 = and i64 %a1.i.i519, 4294967280
  %cur.i.i522 = load ptr, ptr %func.region, align 8
  %end.i.i523 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i524 = ptrtoint ptr %cur.i.i522 to i64
  %end_i.i.i525 = ptrtoint ptr %end.i.i523 to i64
  %rem.i.i526 = sub i64 %end_i.i.i525, %cur_i.i.i524
  %fits.not.i.i527 = icmp slt i64 %rem.i.i526, %aligned.i.i520
  br i1 %fits.not.i.i527, label %fallback.i.i542, label %fast.i.i528

fast.i.i528:                                      ; preds = %build_long.i518
  %next.i.i529 = getelementptr inbounds nuw i8, ptr %cur.i.i522, i64 %aligned.i.i520
  store ptr %next.i.i529, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i530

fallback.i.i542:                                  ; preds = %build_long.i518
  %res.i.i543 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i520)
  %.pre1252 = ptrtoint ptr %res.i.i543 to i64
  br label %archx_region_alloc.exit.i530

archx_region_alloc.exit.i530:                     ; preds = %fallback.i.i542, %fast.i.i528
  %rp_i.i532.pre-phi = phi i64 [ %.pre1252, %fallback.i.i542 ], [ %cur_i.i.i524, %fast.i.i528 ]
  %common.ret.op.i.i531 = phi ptr [ %res.i.i543, %fallback.i.i542 ], [ %cur.i.i522, %fast.i.i528 ]
  %rtagged.i533 = or disjoint i64 %rp_i.i532.pre-phi, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i531, ptr nonnull align 1 %aptr.i5121128, i64 %alen.i500, i1 false)
  %dst_b.i534 = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i531, i64 %alen.i500
  store i32 1969365036, ptr %dst_b.i534, align 1
  %btmp.i496.sroa.5.0.dst_b.i534.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i534, i64 4
  store i40 262801471846, ptr %btmp.i496.sroa.5.0.dst_b.i534.sroa_idx, align 1
  %pref32.i535 = load i32, ptr %common.ret.op.i.i531, align 16
  %pref64.i536 = zext i32 %pref32.i535 to i64
  %pref_sh.i537 = shl nuw i64 %pref64.i536, 32
  %w0_out.i538 = or disjoint i64 %pref_sh.i537, %tot.i504
  %ls0.i539 = insertvalue %ArchxStr poison, i64 %w0_out.i538, 0
  %ls1.i540 = insertvalue %ArchxStr %ls0.i539, i64 %rtagged.i533, 1
  br label %archx_str_concat.exit566

archx_str_concat.exit566:                         ; preds = %archx_str_concat.exit494, %build_sso.i550, %archx_region_alloc.exit.i530
  %common.ret.op.i541 = phi %ArchxStr [ %rs1.i558, %build_sso.i550 ], [ %ls1.i540, %archx_region_alloc.exit.i530 ], [ { i64 8458358423505862665, i64 262801471846 }, %archx_str_concat.exit494 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i495)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i497)
  %t138 = load i64, ptr %t108.9, align 8
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i902)
  %n32.i903 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i902, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t138)
  %len.i904 = sext i32 %n32.i903 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i1051)
  %z.i1052 = icmp slt i32 %n32.i903, 1
  br i1 %z.i1052, label %archx_str_from_slice.exit1098, label %chk_sso.i1055

chk_sso.i1055:                                    ; preds = %archx_str_concat.exit566
  %short.i1056 = icmp samesign ult i32 %n32.i903, 13
  br i1 %short.i1056, label %pack_sso.i1090, label %build_long.i1057

pack_sso.i1090:                                   ; preds = %chk_sso.i1055
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i1051, i8 0, i64 16, i1 false)
  store i32 %n32.i903, ptr %sso.i1051, align 8
  %sso.i1051.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i1051, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i1051.4.sroa_idx, ptr nonnull readonly align 8 %buf.i902, i64 %len.i904, i1 false)
  %sso.i1051.0.sso.i1051.0.sso.i1051.0.sso.0.sso.0.sso.0.sw0.i1094 = load i64, ptr %sso.i1051, align 8
  %sso.i1051.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i1051, i64 8
  %sso.i1051.8.sso.i1051.8.sso.i1051.8.sso.8.sso.8.sso.8.sw1.i1095 = load i64, ptr %sso.i1051.8.sroa_idx, align 8
  %ss0.i1096 = insertvalue %ArchxStr poison, i64 %sso.i1051.0.sso.i1051.0.sso.i1051.0.sso.0.sso.0.sso.0.sw0.i1094, 0
  %ss1.i1097 = insertvalue %ArchxStr %ss0.i1096, i64 %sso.i1051.8.sso.i1051.8.sso.i1051.8.sso.8.sso.8.sso.8.sw1.i1095, 1
  br label %archx_str_from_slice.exit1098

build_long.i1057:                                 ; preds = %chk_sso.i1055
  %a1.i.i1058 = add nuw nsw i64 %len.i904, 15
  %aligned.i.i1059 = and i64 %a1.i.i1058, 4294967280
  %cur.i.i1061 = load ptr, ptr %func.region, align 8
  %end.i.i1062 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i1063 = ptrtoint ptr %cur.i.i1061 to i64
  %end_i.i.i1064 = ptrtoint ptr %end.i.i1062 to i64
  %rem.i.i1065 = sub i64 %end_i.i.i1064, %cur_i.i.i1063
  %fits.not.i.i1066 = icmp slt i64 %rem.i.i1065, %aligned.i.i1059
  br i1 %fits.not.i.i1066, label %fallback.i.i1081, label %fast.i.i1067

fast.i.i1067:                                     ; preds = %build_long.i1057
  %next.i.i1068 = getelementptr inbounds nuw i8, ptr %cur.i.i1061, i64 %aligned.i.i1059
  store ptr %next.i.i1068, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i1069

fallback.i.i1081:                                 ; preds = %build_long.i1057
  %res.i.i1082 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i1059)
  %.pre.i1083 = ptrtoint ptr %res.i.i1082 to i64
  br label %archx_region_alloc.exit.i1069

archx_region_alloc.exit.i1069:                    ; preds = %fallback.i.i1081, %fast.i.i1067
  %rp_i.pre-phi.i1070 = phi i64 [ %cur_i.i.i1063, %fast.i.i1067 ], [ %.pre.i1083, %fallback.i.i1081 ]
  %common.ret.op.i.i1071 = phi ptr [ %cur.i.i1061, %fast.i.i1067 ], [ %res.i.i1082, %fallback.i.i1081 ]
  %rtagged.i1072 = or disjoint i64 %rp_i.pre-phi.i1070, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i1071, ptr nonnull readonly align 8 %buf.i902, i64 %len.i904, i1 false)
  %pref32.i1074 = load i32, ptr %common.ret.op.i.i1071, align 16
  %pref64.i1075 = zext i32 %pref32.i1074 to i64
  %pref_sh.i1076 = shl nuw i64 %pref64.i1075, 32
  %w0_out.i1077 = or disjoint i64 %pref_sh.i1076, %len.i904
  %ls0.i1078 = insertvalue %ArchxStr poison, i64 %w0_out.i1077, 0
  %ls1.i1079 = insertvalue %ArchxStr %ls0.i1078, i64 %rtagged.i1072, 1
  br label %archx_str_from_slice.exit1098

archx_str_from_slice.exit1098:                    ; preds = %archx_str_concat.exit566, %pack_sso.i1090, %archx_region_alloc.exit.i1069
  %common.ret.op.i1080 = phi %ArchxStr [ %ss1.i1097, %pack_sso.i1090 ], [ %ls1.i1079, %archx_region_alloc.exit.i1069 ], [ zeroinitializer, %archx_str_concat.exit566 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i1051)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i902)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i567)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i568)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i569)
  %aw0.i570 = extractvalue %ArchxStr %common.ret.op.i541, 0
  %aw1.i571 = extractvalue %ArchxStr %common.ret.op.i541, 1
  %bw0.i572 = extractvalue %ArchxStr %common.ret.op.i1080, 0
  %bw1.i573 = extractvalue %ArchxStr %common.ret.op.i1080, 1
  %alen.i574 = and i64 %aw0.i570, 4294967295
  %blen.i575 = and i64 %bw0.i572, 4294967295
  %az.i576 = icmp eq i64 %alen.i574, 0
  br i1 %az.i576, label %ret_b.i650, label %chk_bz.i577

ret_b.i650:                                       ; preds = %archx_str_from_slice.exit1098
  %bw1_tag.i651 = and i64 %bw1.i573, 1
  %b_owned.i652 = icmp eq i64 %bw1_tag.i651, 0
  %long.i908 = icmp samesign ult i64 %blen.i575, 13
  %or.cond1142.not1157 = select i1 %b_owned.i652, i1 true, i1 %long.i908
  %tag.i912 = and i64 %bw1.i573, 3
  %owned.not.i913 = icmp eq i64 %tag.i912, 0
  %or.cond1143 = select i1 %or.cond1142.not1157, i1 true, i1 %owned.not.i913
  br i1 %or.cond1143, label %archx_str_concat.exit655, label %dup_heap.i914

dup_heap.i914:                                    ; preds = %ret_b.i650
  %dst.i915 = call noalias align 16 ptr @malloc(i64 %blen.i575)
  %isnull.i916 = icmp eq ptr %dst.i915, null
  br i1 %isnull.i916, label %oom.i923, label %copy.i917

oom.i923:                                         ; preds = %dup_heap.i914
  call fastcc void @archx_oom_fail()
  unreachable

copy.i917:                                        ; preds = %dup_heap.i914
  %src_i.i918 = and i64 %bw1.i573, -4
  %src.i919 = inttoptr i64 %src_i.i918 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i915, ptr nonnull align 4 %src.i919, i64 %blen.i575, i1 false)
  %dst_i.i920 = ptrtoint ptr %dst.i915 to i64
  %tagged.i921 = or disjoint i64 %dst_i.i920, 1
  %out.i922 = insertvalue %ArchxStr %common.ret.op.i1080, i64 %tagged.i921, 1
  br label %archx_str_concat.exit655

chk_bz.i577:                                      ; preds = %archx_str_from_slice.exit1098
  %bz.i578 = icmp eq i64 %blen.i575, 0
  br i1 %bz.i578, label %ret_a.i645, label %calc_tot.i579

ret_a.i645:                                       ; preds = %chk_bz.i577
  %aw1_tag.i646 = and i64 %aw1.i571, 1
  %a_owned.i647 = icmp eq i64 %aw1_tag.i646, 0
  %long.i927 = icmp samesign ult i64 %alen.i574, 13
  %or.cond1144.not1156 = select i1 %a_owned.i647, i1 true, i1 %long.i927
  %tag.i931 = and i64 %aw1.i571, 3
  %owned.not.i932 = icmp eq i64 %tag.i931, 0
  %or.cond1145 = select i1 %or.cond1144.not1156, i1 true, i1 %owned.not.i932
  br i1 %or.cond1145, label %archx_str_concat.exit655, label %dup_heap.i933

dup_heap.i933:                                    ; preds = %ret_a.i645
  %dst.i934 = call noalias align 16 ptr @malloc(i64 %alen.i574)
  %isnull.i935 = icmp eq ptr %dst.i934, null
  br i1 %isnull.i935, label %oom.i942, label %copy.i936

oom.i942:                                         ; preds = %dup_heap.i933
  call fastcc void @archx_oom_fail()
  unreachable

copy.i936:                                        ; preds = %dup_heap.i933
  %src_i.i937 = and i64 %aw1.i571, -4
  %src.i938 = inttoptr i64 %src_i.i937 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i934, ptr nonnull align 4 %src.i938, i64 %alen.i574, i1 false)
  %dst_i.i939 = ptrtoint ptr %dst.i934 to i64
  %tagged.i940 = or disjoint i64 %dst_i.i939, 1
  %out.i941 = insertvalue %ArchxStr %common.ret.op.i541, i64 %tagged.i940, 1
  br label %archx_str_concat.exit655

calc_tot.i579:                                    ; preds = %chk_bz.i577
  %tot.i580 = add nuw nsw i64 %blen.i575, %alen.i574
  %too_big.i581 = icmp samesign ugt i64 %tot.i580, 2147483647
  br i1 %too_big.i581, label %oom.i627, label %mat_a.i582

oom.i627:                                         ; preds = %calc_tot.i579
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i582:                                       ; preds = %calc_tot.i579
  %ashort.i583 = icmp samesign ult i64 %alen.i574, 13
  br i1 %ashort.i583, label %mat_a_short.i641, label %mat_a_long.i584

mat_a_short.i641:                                 ; preds = %mat_a.i582
  %ap4.i642 = lshr i64 %aw0.i570, 32
  %ap4_32.i643 = trunc nuw i64 %ap4.i642 to i32
  store i32 %ap4_32.i643, ptr %atmp.i567, align 4
  %atmp4.i644 = getelementptr inbounds nuw i8, ptr %atmp.i567, i64 4
  store i64 %aw1.i571, ptr %atmp4.i644, align 4
  br label %mat_b.i587

mat_a_long.i584:                                  ; preds = %mat_a.i582
  %araw.i585 = and i64 %aw1.i571, -4
  %alptr.i586 = inttoptr i64 %araw.i585 to ptr
  br label %mat_b.i587

mat_b.i587:                                       ; preds = %mat_a_long.i584, %mat_a_short.i641
  %aptr.i588 = phi ptr [ %atmp.i567, %mat_a_short.i641 ], [ %alptr.i586, %mat_a_long.i584 ]
  %bshort.i589 = icmp samesign ult i64 %blen.i575, 13
  br i1 %bshort.i589, label %mat_b_short.i637, label %mat_b_long.i590

mat_b_short.i637:                                 ; preds = %mat_b.i587
  %bp4.i638 = lshr i64 %bw0.i572, 32
  %bp4_32.i639 = trunc nuw i64 %bp4.i638 to i32
  store i32 %bp4_32.i639, ptr %btmp.i568, align 4
  %btmp4.i640 = getelementptr inbounds nuw i8, ptr %btmp.i568, i64 4
  store i64 %bw1.i573, ptr %btmp4.i640, align 4
  br label %build.i593

mat_b_long.i590:                                  ; preds = %mat_b.i587
  %braw.i591 = and i64 %bw1.i573, -4
  %blptr.i592 = inttoptr i64 %braw.i591 to ptr
  br label %build.i593

build.i593:                                       ; preds = %mat_b_long.i590, %mat_b_short.i637
  %bptr.i594 = phi ptr [ %btmp.i568, %mat_b_short.i637 ], [ %blptr.i592, %mat_b_long.i590 ]
  %fits_sso.i595 = icmp samesign ult i64 %tot.i580, 13
  br i1 %fits_sso.i595, label %build_sso.i628, label %build_long.i596

build_sso.i628:                                   ; preds = %build.i593
  %out_sso8.i629 = getelementptr inbounds nuw i8, ptr %out_sso.i569, i64 8
  %tot32.i630 = trunc nuw nsw i64 %tot.i580 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i569, i8 0, i64 16, i1 false)
  store i32 %tot32.i630, ptr %out_sso.i569, align 8
  %sso_dst_a.i631 = getelementptr inbounds nuw i8, ptr %out_sso.i569, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i631, ptr nonnull align 1 %aptr.i588, i64 %alen.i574, i1 false)
  %sso_dst_b.i632 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i631, i64 %alen.i574
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i632, ptr nonnull align 1 %bptr.i594, i64 %blen.i575, i1 false)
  %rw0.i633 = load i64, ptr %out_sso.i569, align 8
  %rw1.i634 = load i64, ptr %out_sso8.i629, align 8
  %rs0.i635 = insertvalue %ArchxStr poison, i64 %rw0.i633, 0
  %rs1.i636 = insertvalue %ArchxStr %rs0.i635, i64 %rw1.i634, 1
  br label %archx_str_concat.exit655

build_long.i596:                                  ; preds = %build.i593
  %a1.i.i597 = add nuw nsw i64 %tot.i580, 15
  %aligned.i.i598 = and i64 %a1.i.i597, 4294967280
  %cur.i.i600 = load ptr, ptr %func.region, align 8
  %end.i.i601 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i602 = ptrtoint ptr %cur.i.i600 to i64
  %end_i.i.i603 = ptrtoint ptr %end.i.i601 to i64
  %rem.i.i604 = sub i64 %end_i.i.i603, %cur_i.i.i602
  %fits.not.i.i605 = icmp slt i64 %rem.i.i604, %aligned.i.i598
  br i1 %fits.not.i.i605, label %fallback.i.i620, label %fast.i.i606

fast.i.i606:                                      ; preds = %build_long.i596
  %next.i.i607 = getelementptr inbounds nuw i8, ptr %cur.i.i600, i64 %aligned.i.i598
  store ptr %next.i.i607, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i608

fallback.i.i620:                                  ; preds = %build_long.i596
  %res.i.i621 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i598)
  %.pre = ptrtoint ptr %res.i.i621 to i64
  br label %archx_region_alloc.exit.i608

archx_region_alloc.exit.i608:                     ; preds = %fallback.i.i620, %fast.i.i606
  %rp_i.i610.pre-phi = phi i64 [ %.pre, %fallback.i.i620 ], [ %cur_i.i.i602, %fast.i.i606 ]
  %common.ret.op.i.i609 = phi ptr [ %res.i.i621, %fallback.i.i620 ], [ %cur.i.i600, %fast.i.i606 ]
  %rtagged.i611 = or disjoint i64 %rp_i.i610.pre-phi, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i609, ptr nonnull align 1 %aptr.i588, i64 %alen.i574, i1 false)
  %dst_b.i612 = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i609, i64 %alen.i574
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i612, ptr nonnull align 1 %bptr.i594, i64 %blen.i575, i1 false)
  %pref32.i613 = load i32, ptr %common.ret.op.i.i609, align 16
  %pref64.i614 = zext i32 %pref32.i613 to i64
  %pref_sh.i615 = shl nuw i64 %pref64.i614, 32
  %w0_out.i616 = or disjoint i64 %pref_sh.i615, %tot.i580
  %ls0.i617 = insertvalue %ArchxStr poison, i64 %w0_out.i616, 0
  %ls1.i618 = insertvalue %ArchxStr %ls0.i617, i64 %rtagged.i611, 1
  br label %archx_str_concat.exit655

archx_str_concat.exit655:                         ; preds = %copy.i936, %copy.i917, %ret_b.i650, %ret_a.i645, %build_sso.i628, %archx_region_alloc.exit.i608
  %common.ret.op.i619 = phi %ArchxStr [ %rs1.i636, %build_sso.i628 ], [ %ls1.i618, %archx_region_alloc.exit.i608 ], [ %common.ret.op.i1080, %ret_b.i650 ], [ %common.ret.op.i541, %ret_a.i645 ], [ %out.i922, %copy.i917 ], [ %out.i941, %copy.i936 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i567)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i568)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i569)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i944)
  %w0.i945 = extractvalue %ArchxStr %common.ret.op.i619, 0
  %w1.i946 = extractvalue %ArchxStr %common.ret.op.i619, 1
  %len.i947 = and i64 %w0.i945, 4294967295
  %short.i948 = icmp samesign ult i64 %len.i947, 13
  br i1 %short.i948, label %emit.i969, label %emit.thread.i949

emit.thread.i949:                                 ; preds = %archx_str_concat.exit655
  %raw.i950 = and i64 %w1.i946, -4
  %lptr.i951 = inttoptr i64 %raw.i950 to ptr
  br label %chk_nul.i952

emit.i969:                                        ; preds = %archx_str_concat.exit655
  %p4.i970 = lshr i64 %w0.i945, 32
  %p4_32.i971 = trunc nuw i64 %p4.i970 to i32
  store i32 %p4_32.i971, ptr %tmp.i944, align 4
  %tmp4.i972 = getelementptr inbounds nuw i8, ptr %tmp.i944, i64 4
  store i64 %w1.i946, ptr %tmp4.i972, align 4
  %pos.not.i973 = icmp eq i64 %len.i947, 0
  br i1 %pos.not.i973, label %chk_nl.i964, label %chk_nul.i952

chk_nul.i952:                                     ; preds = %emit.i969, %emit.thread.i949
  %data3.i953 = phi ptr [ %lptr.i951, %emit.thread.i949 ], [ %tmp.i944, %emit.i969 ]
  %nul.i954 = call ptr @memchr(ptr nonnull %data3.i953, i32 0, i64 %len.i947)
  %has_nul.not.i955 = icmp eq ptr %nul.i954, null
  br i1 %has_nul.not.i955, label %fast_printf.i966, label %byte_loop.i956

fast_printf.i966:                                 ; preds = %chk_nul.i952
  %len32.i967 = trunc i64 %w0.i945 to i32
  %np.i968 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i967, ptr nonnull %data3.i953)
  br label %archx_str_print.exit974

byte_loop.i956:                                   ; preds = %chk_nul.i952, %byte_loop.i956
  %bi.i957 = phi i64 [ %bnext.i962, %byte_loop.i956 ], [ 0, %chk_nul.i952 ]
  %bp.i958 = getelementptr inbounds nuw i8, ptr %data3.i953, i64 %bi.i957
  %ch8.i959 = load i8, ptr %bp.i958, align 1
  %ch32.i960 = zext i8 %ch8.i959 to i32
  %pc.i961 = call i32 @putchar(i32 %ch32.i960)
  %bnext.i962 = add nuw nsw i64 %bi.i957, 1
  %exitcond.not.i963 = icmp eq i64 %bnext.i962, %len.i947
  br i1 %exitcond.not.i963, label %chk_nl.i964, label %byte_loop.i956

chk_nl.i964:                                      ; preds = %byte_loop.i956, %emit.i969
  %nc.i965 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit974

archx_str_print.exit974:                          ; preds = %fast_printf.i966, %chk_nl.i964
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i944)
  %tag.i95 = and i64 %w1.i946, 1
  %owned.not.i96 = icmp eq i64 %tag.i95, 0
  %or.cond1146 = select i1 %short.i948, i1 true, i1 %owned.not.i96
  br i1 %or.cond1146, label %archx_str_drop.exit100, label %do_free.i97

do_free.i97:                                      ; preds = %archx_str_print.exit974
  %raw.i98 = and i64 %w1.i946, -2
  %ptr.i99 = inttoptr i64 %raw.i98 to ptr
  call void @free(ptr %ptr.i99)
  br label %archx_str_drop.exit100

archx_str_drop.exit100:                           ; preds = %archx_str_print.exit974, %do_free.i97
  %long.i103 = icmp samesign ult i64 %blen.i575, 13
  %tag.i106 = and i64 %bw1.i573, 1
  %owned.not.i107 = icmp eq i64 %tag.i106, 0
  %or.cond1147 = select i1 %long.i103, i1 true, i1 %owned.not.i107
  br i1 %or.cond1147, label %archx_str_drop.exit111, label %do_free.i108

do_free.i108:                                     ; preds = %archx_str_drop.exit100
  %raw.i109 = and i64 %bw1.i573, -2
  %ptr.i110 = inttoptr i64 %raw.i109 to ptr
  call void @free(ptr %ptr.i110)
  br label %archx_str_drop.exit111

archx_str_drop.exit111:                           ; preds = %archx_str_drop.exit100, %do_free.i108
  %long.i114 = icmp samesign ult i64 %alen.i574, 13
  %tag.i117 = and i64 %aw1.i571, 1
  %owned.not.i118 = icmp eq i64 %tag.i117, 0
  %or.cond1148 = select i1 %long.i114, i1 true, i1 %owned.not.i118
  br i1 %or.cond1148, label %archx_str_drop.exit122, label %do_free.i119

do_free.i119:                                     ; preds = %archx_str_drop.exit111
  %raw.i120 = and i64 %aw1.i571, -2
  %ptr.i121 = inttoptr i64 %raw.i120 to ptr
  call void @free(ptr %ptr.i121)
  br label %archx_str_drop.exit122

archx_str_drop.exit122:                           ; preds = %archx_str_drop.exit111, %do_free.i119
  %long.i125 = icmp samesign ult i64 %alen.i500, 13
  %tag.i128 = and i64 %aw1.i499, 1
  %owned.not.i129 = icmp eq i64 %tag.i128, 0
  %or.cond1149 = select i1 %long.i125, i1 true, i1 %owned.not.i129
  br i1 %or.cond1149, label %archx_str_drop.exit133, label %do_free.i130

do_free.i130:                                     ; preds = %archx_str_drop.exit122
  %raw.i131 = and i64 %aw1.i499, -2
  %ptr.i132 = inttoptr i64 %raw.i131 to ptr
  call void @free(ptr %ptr.i132)
  br label %archx_str_drop.exit133

archx_str_drop.exit133:                           ; preds = %archx_str_drop.exit122, %do_free.i130
  %long.i136 = icmp samesign ult i64 %blen.i416, 13
  %tag.i139 = and i64 %bw1.i414, 1
  %owned.not.i140 = icmp eq i64 %tag.i139, 0
  %or.cond1150 = select i1 %long.i136, i1 true, i1 %owned.not.i140
  br i1 %or.cond1150, label %archx_str_drop.exit144, label %do_free.i141

do_free.i141:                                     ; preds = %archx_str_drop.exit133
  %raw.i142 = and i64 %bw1.i414, -2
  %ptr.i143 = inttoptr i64 %raw.i142 to ptr
  call void @free(ptr %ptr.i143)
  br label %archx_str_drop.exit144

archx_str_drop.exit144:                           ; preds = %archx_str_drop.exit133, %do_free.i141
  %long.i147 = icmp samesign ult i64 %alen.i415, 13
  %tag.i150 = and i64 %aw1.i412, 1
  %owned.not.i151 = icmp eq i64 %tag.i150, 0
  %or.cond1151 = select i1 %long.i147, i1 true, i1 %owned.not.i151
  br i1 %or.cond1151, label %archx_str_drop.exit155, label %do_free.i152

do_free.i152:                                     ; preds = %archx_str_drop.exit144
  %raw.i153 = and i64 %aw1.i412, -2
  %ptr.i154 = inttoptr i64 %raw.i153 to ptr
  call void @free(ptr %ptr.i154)
  br label %archx_str_drop.exit155

archx_str_drop.exit155:                           ; preds = %archx_str_drop.exit144, %do_free.i152
  %long.i158 = icmp samesign ult i64 %alen.i342, 13
  %tag.i161 = and i64 %aw1.i341, 1
  %owned.not.i162 = icmp eq i64 %tag.i161, 0
  %or.cond1152 = select i1 %long.i158, i1 true, i1 %owned.not.i162
  br i1 %or.cond1152, label %archx_str_drop.exit166, label %do_free.i163

do_free.i163:                                     ; preds = %archx_str_drop.exit155
  %raw.i164 = and i64 %aw1.i341, -2
  %ptr.i165 = inttoptr i64 %raw.i164 to ptr
  call void @free(ptr %ptr.i165)
  br label %archx_str_drop.exit166

archx_str_drop.exit166:                           ; preds = %archx_str_drop.exit155, %do_free.i163
  %long.i169 = icmp samesign ult i64 %blen.i288, 13
  %tag.i172 = and i64 %newret1291, 1
  %owned.not.i173 = icmp eq i64 %tag.i172, 0
  %or.cond1153 = select i1 %long.i169, i1 true, i1 %owned.not.i173
  br i1 %or.cond1153, label %archx_str_drop.exit177, label %do_free.i174

do_free.i174:                                     ; preds = %archx_str_drop.exit166
  %raw.i175 = and i64 %newret1291, -2
  %ptr.i176 = inttoptr i64 %raw.i175 to ptr
  call void @free(ptr %ptr.i176)
  br label %archx_str_drop.exit177

archx_str_drop.exit177:                           ; preds = %archx_str_drop.exit166, %do_free.i174
  %head.i = load ptr, ptr %.fca.2.gep, align 8
  %empty.i = icmp eq ptr %head.i, null
  br i1 %empty.i, label %archx_region_rewind_root.exit, label %rewind.i

rewind.i:                                         ; preds = %archx_str_drop.exit177
  %cap_ptr.i = getelementptr inbounds nuw i8, ptr %head.i, i64 8
  %cap.i = load i64, ptr %cap_ptr.i, align 8
  %data.i = getelementptr inbounds nuw i8, ptr %head.i, i64 16
  %end.i = getelementptr inbounds i8, ptr %data.i, i64 %cap.i
  store ptr %data.i, ptr %func.region, align 8
  store ptr %end.i, ptr %.fca.1.gep, align 8
  store ptr %head.i, ptr %.fca.3.gep, align 8
  br label %archx_region_rewind_root.exit

archx_region_rewind_root.exit:                    ; preds = %archx_str_drop.exit177, %rewind.i
  %has_elems.i = icmp sgt i64 %vlen.ph.lcssa7.i1266, 0
  br i1 %has_elems.i, label %loop.i978, label %check.free.i

loop.i978:                                        ; preds = %archx_region_rewind_root.exit, %archx_str_drop.exit.i
  %i.i979 = phi i64 [ %inext.i981, %archx_str_drop.exit.i ], [ 0, %archx_region_rewind_root.exit ]
  %ep.i980 = getelementptr inbounds nuw %ArchxStr, ptr %vptr.ph.lcssa9.i1265, i64 %i.i979
  %t0.unpack.i = load i64, ptr %ep.i980, align 8
  %t0.elt1.i = getelementptr inbounds nuw i8, ptr %ep.i980, i64 8
  %t0.unpack2.i = load i64, ptr %t0.elt1.i, align 8
  %len.i.i = and i64 %t0.unpack.i, 4294967295
  %long.i.i = icmp samesign ult i64 %len.i.i, 13
  %tag.i.i = and i64 %t0.unpack2.i, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond.i = select i1 %long.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond.i, label %archx_str_drop.exit.i, label %do_free.i.i

do_free.i.i:                                      ; preds = %loop.i978
  %raw.i.i = and i64 %t0.unpack2.i, -2
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  call void @free(ptr %ptr.i.i)
  br label %archx_str_drop.exit.i

archx_str_drop.exit.i:                            ; preds = %do_free.i.i, %loop.i978
  %inext.i981 = add nuw nsw i64 %i.i979, 1
  %exitcond.not.i982 = icmp eq i64 %inext.i981, %vlen.ph.lcssa7.i1266
  br i1 %exitcond.not.i982, label %check.free.i, label %loop.i978

check.free.i:                                     ; preds = %archx_str_drop.exit.i, %archx_region_rewind_root.exit
  %is_heap.i = icmp sgt i64 %vcap.ph.lcssa5.i1267, 0
  br i1 %is_heap.i, label %do.free.i, label %archx_vec_drop_s.exit

do.free.i:                                        ; preds = %check.free.i
  call void @free(ptr nonnull %vptr.ph.lcssa9.i1265)
  br label %archx_vec_drop_s.exit

archx_vec_drop_s.exit:                            ; preds = %check.free.i, %do.free.i
  %t144 = icmp sgt i64 %var.samples.7.sroa.9.1, 0
  br i1 %t144, label %drop.vec.free.37, label %drop.vec.done.38

drop.vec.free.37:                                 ; preds = %archx_vec_drop_s.exit
  call void @free(ptr %var.samples.7.sroa.18.1)
  br label %drop.vec.done.38

drop.vec.done.38:                                 ; preds = %drop.vec.free.37, %archx_vec_drop_s.exit
  %t147 = load ptr, ptr %.fca.2.gep, align 8
  %empty.i983 = icmp eq ptr %t147, null
  br i1 %empty.i983, label %archx_region_release_from.exit, label %loop.i984

loop.i984:                                        ; preds = %drop.vec.done.38, %loop.i984
  %cur.i985 = phi ptr [ %next.i986, %loop.i984 ], [ %t147, %drop.vec.done.38 ]
  %next.i986 = load ptr, ptr %cur.i985, align 8
  call void @free(ptr nonnull %cur.i985)
  %more.not.i = icmp eq ptr %next.i986, null
  br i1 %more.not.i, label %archx_region_release_from.exit, label %loop.i984

archx_region_release_from.exit:                   ; preds = %loop.i984, %drop.vec.done.38
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
define private fastcc void @archx_bounds_fail() unnamed_addr #3 {
entry:
  %c = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.err.bounds, i64 0, i64 0)
  tail call void @exit(i32 101)
  unreachable
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

; Function Attrs: mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite)
declare noalias noundef ptr @realloc(ptr allocptr captures(none), i64 noundef) local_unnamed_addr #6

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #7

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #8

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #9

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @memchr(ptr captures(none), i32, i64) local_unnamed_addr #10

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #4

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #3

; Function Attrs: nounwind
define private fastcc { i64, i64 } @archx_str_from_slice(ptr readonly captures(none) %src, i64 %len, ptr captures(address_is_null) %reg) unnamed_addr #0 {
entry:
  %sso = alloca [16 x i8], align 8
  %z = icmp slt i64 %len, 1
  br i1 %z, label %common.ret, label %chk_big

common.ret:                                       ; preds = %entry, %copy_long, %pack_sso
  %common.ret.op = phi %ArchxStr [ %ss1, %pack_sso ], [ %ls1, %copy_long ], [ zeroinitializer, %entry ]
  %oldret = extractvalue %ArchxStr %common.ret.op, 0
  %newret = insertvalue { i64, i64 } poison, i64 %oldret, 0
  %oldret1 = extractvalue %ArchxStr %common.ret.op, 1
  %newret2 = insertvalue { i64, i64 } %newret, i64 %oldret1, 1
  ret { i64, i64 } %newret2

chk_big:                                          ; preds = %entry
  %big = icmp samesign ugt i64 %len, 2147483647
  br i1 %big, label %oom, label %chk_sso

oom:                                              ; preds = %alloc_heap, %chk_big
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso:                                          ; preds = %chk_big
  %short = icmp samesign ult i64 %len, 13
  br i1 %short, label %pack_sso, label %build_long

pack_sso:                                         ; preds = %chk_sso
  %len32 = trunc nuw nsw i64 %len to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso, i8 0, i64 16, i1 false)
  store i32 %len32, ptr %sso, align 8
  %sso.4.sroa_idx3 = getelementptr inbounds nuw i8, ptr %sso, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.4.sroa_idx3, ptr nonnull align 1 %src, i64 %len, i1 false)
  %sso.0.sso.0.sso.0.sso.0.sw0 = load i64, ptr %sso, align 8
  %sso.8.sroa_idx4 = getelementptr inbounds nuw i8, ptr %sso, i64 8
  %sso.8.sso.8.sso.8.sso.8.sw1 = load i64, ptr %sso.8.sroa_idx4, align 8
  %ss0 = insertvalue %ArchxStr poison, i64 %sso.0.sso.0.sso.0.sso.0.sw0, 0
  %ss1 = insertvalue %ArchxStr %ss0, i64 %sso.8.sso.8.sso.8.sso.8.sw1, 1
  br label %common.ret

build_long:                                       ; preds = %chk_sso
  %use_reg.not = icmp eq ptr %reg, null
  br i1 %use_reg.not, label %alloc_heap, label %alloc_reg

alloc_reg:                                        ; preds = %build_long
  %a1.i = add nuw nsw i64 %len, 15
  %aligned.i = and i64 %a1.i, 4294967280
  %end_slot.i = getelementptr inbounds nuw i8, ptr %reg, i64 8
  %cur.i = load ptr, ptr %reg, align 8
  %end.i = load ptr, ptr %end_slot.i, align 8
  %cur_i.i = ptrtoint ptr %cur.i to i64
  %end_i.i = ptrtoint ptr %end.i to i64
  %rem.i = sub i64 %end_i.i, %cur_i.i
  %fits.not.i = icmp slt i64 %rem.i, %aligned.i
  br i1 %fits.not.i, label %fallback.i, label %fast.i

fast.i:                                           ; preds = %alloc_reg
  %next.i = getelementptr inbounds nuw i8, ptr %cur.i, i64 %aligned.i
  store ptr %next.i, ptr %reg, align 8
  br label %archx_region_alloc.exit

fallback.i:                                       ; preds = %alloc_reg
  %res.i = tail call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %reg, i64 %aligned.i)
  %.pre = ptrtoint ptr %res.i to i64
  br label %archx_region_alloc.exit

archx_region_alloc.exit:                          ; preds = %fast.i, %fallback.i
  %rp_i.pre-phi = phi i64 [ %cur_i.i, %fast.i ], [ %.pre, %fallback.i ]
  %common.ret.op.i = phi ptr [ %cur.i, %fast.i ], [ %res.i, %fallback.i ]
  %rtagged = or disjoint i64 %rp_i.pre-phi, 2
  br label %copy_long

alloc_heap:                                       ; preds = %build_long
  %hp = tail call noalias align 16 ptr @malloc(i64 %len)
  %hnull = icmp eq ptr %hp, null
  br i1 %hnull, label %oom, label %tag_heap

tag_heap:                                         ; preds = %alloc_heap
  %hp_i = ptrtoint ptr %hp to i64
  %htagged = or disjoint i64 %hp_i, 1
  br label %copy_long

copy_long:                                        ; preds = %tag_heap, %archx_region_alloc.exit
  %dst = phi ptr [ %common.ret.op.i, %archx_region_alloc.exit ], [ %hp, %tag_heap ]
  %w1_out = phi i64 [ %rtagged, %archx_region_alloc.exit ], [ %htagged, %tag_heap ]
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst, ptr nonnull align 1 %src, i64 %len, i1 false)
  %pref32 = load i32, ptr %dst, align 16
  %pref64 = zext i32 %pref32 to i64
  %pref_sh = shl nuw i64 %pref64, 32
  %w0_out = or disjoint i64 %pref_sh, %len
  %ls0 = insertvalue %ArchxStr poison, i64 %w0_out, 0
  %ls1 = insertvalue %ArchxStr %ls0, i64 %w1_out, 1
  br label %common.ret
}

; Function Attrs: nounwind
define private fastcc { i64, i64 } @archx_str_from_float(double %x, ptr captures(address_is_null) %reg) unnamed_addr #0 {
entry:
  %buf = alloca [64 x i8], align 8
  %n32.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf, ptr nonnull dereferenceable(1) @.fmt.g15, double %x)
  %n.i = sext i32 %n32.i to i64
  %pos.i = icmp sgt i32 %n32.i, 0
  br i1 %pos.i, label %scan.i, label %archx_fmt_float_buf.exit

scan.i:                                           ; preds = %entry, %scan_step.i
  %i.i = phi i64 [ %inext.i, %scan_step.i ], [ 0, %entry ]
  %cp.i = getelementptr inbounds nuw i8, ptr %buf, i64 %i.i
  %ch.i = load i8, ptr %cp.i, align 1
  switch i8 %ch.i, label %scan_step.i [
    i8 110, label %archx_fmt_float_buf.exit
    i8 105, label %archx_fmt_float_buf.exit
    i8 101, label %archx_fmt_float_buf.exit
    i8 78, label %archx_fmt_float_buf.exit
    i8 73, label %archx_fmt_float_buf.exit
    i8 69, label %archx_fmt_float_buf.exit
    i8 46, label %archx_fmt_float_buf.exit
  ]

scan_step.i:                                      ; preds = %scan.i
  %inext.i = add nuw nsw i64 %i.i, 1
  %exitcond.not.i = icmp eq i64 %inext.i, %n.i
  br i1 %exitcond.not.i, label %append_dot0.i, label %scan.i

append_dot0.i:                                    ; preds = %scan_step.i
  %p0.i = getelementptr inbounds nuw i8, ptr %buf, i64 %n.i
  store i8 46, ptr %p0.i, align 1
  %p1.i = getelementptr inbounds nuw i8, ptr %p0.i, i64 1
  store i8 48, ptr %p1.i, align 1
  %n2.i = add nuw nsw i64 %n.i, 2
  %p2.i = getelementptr inbounds nuw i8, ptr %buf, i64 %n2.i
  store i8 0, ptr %p2.i, align 1
  br label %archx_fmt_float_buf.exit

archx_fmt_float_buf.exit:                         ; preds = %scan.i, %scan.i, %scan.i, %scan.i, %scan.i, %scan.i, %scan.i, %entry, %append_dot0.i
  %common.ret.op.i = phi i64 [ %n2.i, %append_dot0.i ], [ %n.i, %entry ], [ %n.i, %scan.i ], [ %n.i, %scan.i ], [ %n.i, %scan.i ], [ %n.i, %scan.i ], [ %n.i, %scan.i ], [ %n.i, %scan.i ], [ %n.i, %scan.i ]
  %s = call fastcc { i64, i64 } @archx_str_from_slice(ptr nonnull %buf, i64 %common.ret.op.i, ptr %reg)
  ret { i64, i64 } %s
}

; Function Attrs: nofree nounwind
declare noundef i32 @sprintf(ptr noalias noundef writeonly captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.abs.i64(i64, i1 immarg) #11

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smin.i64(i64, i64) #11

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #11

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
attributes #6 = { mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #7 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #8 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #9 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #10 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #11 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #12 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.peeled.count", i32 1}
!2 = distinct !{!2, !3, !4}
!3 = !{!"llvm.loop.isvectorized", i32 1}
!4 = !{!"llvm.loop.unroll.runtime.disable"}
!5 = distinct !{!5, !3, !4}
!6 = distinct !{!6, !4, !3}
