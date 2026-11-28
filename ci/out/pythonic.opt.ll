; ModuleID = 'ci/out/pythonic.ll'
source_filename = "ci/out/pythonic.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxStr = type { i64, i64 }

@.fmt.g15 = private unnamed_addr constant [6 x i8] c"%.15g\00", align 1
@.fmt.g16 = private unnamed_addr constant [6 x i8] c"%.16g\00", align 1
@.fmt.g17 = private unnamed_addr constant [6 x i8] c"%.17g\00", align 1
@.str.0 = private unnamed_addr constant [31 x i8] c"  fast pythonic native archx  \00", align 4
@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@.fmt.pstr = private unnamed_addr constant [5 x i8] c"%.*s\00", align 1
@.err.bounds = private unnamed_addr constant [63 x i8] c"archx runtime panic: index %lld out of bounds for length %lld\0A\00", align 1
@.fmt.i64s = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@str.1 = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
push.grow.from_heap.11.peel:
  %sso.i1050 = alloca [16 x i8], align 8
  %sso.i1004 = alloca [16 x i8], align 8
  %sso.i = alloca [16 x i8], align 8
  %tmp.i943 = alloca [12 x i8], align 4
  %buf.i901 = alloca [32 x i8], align 8
  %buf.i859 = alloca [32 x i8], align 8
  %tmp.i823 = alloca [12 x i8], align 4
  %tmp.i804 = alloca [12 x i8], align 4
  %tmp.i785 = alloca [12 x i8], align 4
  %tmp.i766 = alloca [12 x i8], align 4
  %sso.i.i728 = alloca [16 x i8], align 8
  %tmp.i729 = alloca [12 x i8], align 4
  %sbuf.i = alloca [64 x i8], align 8
  %sso.i.i693 = alloca [16 x i8], align 8
  %tmp.i = alloca [12 x i8], align 4
  %buf.i = alloca [32 x i8], align 8
  %atmp.i566 = alloca [12 x i8], align 4
  %btmp.i567 = alloca [12 x i8], align 4
  %out_sso.i568 = alloca [16 x i8], align 8
  %atmp.i494 = alloca [12 x i8], align 4
  %out_sso.i496 = alloca [16 x i8], align 8
  %atmp.i407 = alloca [12 x i8], align 4
  %btmp.i408 = alloca [12 x i8], align 4
  %out_sso.i409 = alloca [16 x i8], align 8
  %atmp.i336 = alloca [12 x i8], align 4
  %btmp.i283 = alloca [12 x i8], align 4
  %out_sso.i284.sroa.6.sroa.5.sroa.0 = alloca i56, align 8
  %atmp.i216 = alloca [12 x i8], align 4
  %btmp.i217 = alloca [12 x i8], align 4
  %out_sso.i218 = alloca [16 x i8], align 8
  %atmp.i178 = alloca [12 x i8], align 4
  %out_sso.i180 = alloca [16 x i8], align 8
  %btmp.i = alloca [12 x i8], align 4
  %out_sso.i.sroa.6.sroa.5 = alloca i32, align 4
  %func.region = alloca %ArchxRegion, align 8
  %.fca.1.gep = getelementptr inbounds nuw i8, ptr %func.region, i64 8
  %.fca.2.gep = getelementptr inbounds nuw i8, ptr %func.region, i64 16
  %.fca.3.gep = getelementptr inbounds nuw i8, ptr %func.region, i64 24
  %malloc = tail call dereferenceable_or_null(32) ptr @malloc(i64 32)
  %t46.peel = icmp eq ptr %malloc, null
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %func.region, i8 0, i64 32, i1 false)
  br i1 %t46.peel, label %realloc.oom.19, label %for.body.1.peel.next

for.body.1.peel.next:                             ; preds = %push.grow.from_heap.11.peel
  store double 1.500000e+00, ptr %malloc, align 8
  br label %for.body.1

enum.cond.20.preheader:                           ; preds = %push.store.5
  %btmp4.i = getelementptr inbounds nuw i8, ptr %btmp.i, i64 4
  %atmp4.i214 = getelementptr inbounds nuw i8, ptr %atmp.i178, i64 4
  %out_sso8.i206 = getelementptr inbounds nuw i8, ptr %out_sso.i180, i64 8
  %sso_dst_a.i208 = getelementptr inbounds nuw i8, ptr %out_sso.i180, i64 4
  %atmp4.i276 = getelementptr inbounds nuw i8, ptr %atmp.i216, i64 4
  %btmp4.i272 = getelementptr inbounds nuw i8, ptr %btmp.i217, i64 4
  %out_sso8.i261 = getelementptr inbounds nuw i8, ptr %out_sso.i218, i64 8
  %sso_dst_a.i263 = getelementptr inbounds nuw i8, ptr %out_sso.i218, i64 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  %t65 = load double, ptr %var.samples.7.sroa.18.1, align 8
  %t7.i = fadd double %t65, 0.000000e+00
  %t64.1 = getelementptr inbounds nuw i8, ptr %var.samples.7.sroa.18.1, i64 8
  %t65.1 = load double, ptr %t64.1, align 8
  %t7.i.1 = fadd double %t7.i, %t65.1
  %t64.2 = getelementptr inbounds nuw i8, ptr %var.samples.7.sroa.18.1, i64 16
  %t65.2 = load double, ptr %t64.2, align 8
  %t7.i.2 = fadd double %t7.i.1, %t65.2
  %t64.3 = getelementptr inbounds nuw i8, ptr %var.samples.7.sroa.18.1, i64 24
  %t65.3 = load double, ptr %t64.3, align 8
  %t7.i.3 = fadd double %t7.i.2, %t65.3
  %t64.4 = getelementptr inbounds nuw i8, ptr %var.samples.7.sroa.18.1, i64 32
  %t65.4 = load double, ptr %t64.4, align 8
  %t7.i.4 = fadd double %t7.i.3, %t65.4
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i)
  %n32.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 5)
  %len.i655 = sext i32 %n32.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i)
  %z.i986 = icmp slt i32 %n32.i, 1
  br i1 %z.i986, label %archx_str_from_slice.exit, label %chk_sso.i

for.body.1:                                       ; preds = %for.body.1.peel.next, %push.store.5
  %var.samples.7.sroa.18.01199 = phi ptr [ %malloc, %for.body.1.peel.next ], [ %var.samples.7.sroa.18.1, %push.store.5 ]
  %var.samples.7.sroa.9.01198 = phi i64 [ 4, %for.body.1.peel.next ], [ %var.samples.7.sroa.9.1, %push.store.5 ]
  %var.samples.7.sroa.0.01197 = phi i64 [ 1, %for.body.1.peel.next ], [ %t53, %push.store.5 ]
  %for.i.8.01196 = phi i64 [ 2, %for.body.1.peel.next ], [ %t56, %push.store.5 ]
  %t13 = uitofp nneg i64 %for.i.8.01196 to double
  %t14 = fmul double %t13, 1.500000e+00
  %t19 = icmp slt i64 %var.samples.7.sroa.9.01198, 0
  %t21 = tail call i64 @llvm.abs.i64(i64 %var.samples.7.sroa.9.01198, i1 true)
  %t22.not = icmp samesign ult i64 %var.samples.7.sroa.0.01197, %t21
  br i1 %t22.not, label %push.store.5, label %push.calc.7

push.calc.7:                                      ; preds = %for.body.1
  %t24 = icmp eq i64 %var.samples.7.sroa.9.01198, 0
  %t25 = shl nuw i64 %t21, 1
  %0 = tail call i64 @llvm.smin.i64(i64 %t25, i64 140737488355328)
  %t28 = select i1 %t24, i64 4, i64 %0
  %1 = add i64 %t28, -1152921504606846976
  %t31 = icmp ult i64 %1, -2305843009213693952
  br i1 %t31, label %mul.oom.8, label %mul.ok.9

mul.oom.8:                                        ; preds = %push.calc.7
  tail call fastcc void @archx_oom_fail()
  unreachable

mul.ok.9:                                         ; preds = %push.calc.7
  %t30 = shl nsw i64 %t28, 3
  %t33 = tail call i64 @llvm.umax.i64(i64 %t30, i64 1)
  br i1 %t19, label %mul.ok.13, label %push.grow.from_heap.11

mul.ok.13:                                        ; preds = %mul.ok.9
  %t39 = tail call noalias align 16 ptr @malloc(i64 %t33)
  %t40 = icmp eq ptr %t39, null
  br i1 %t40, label %alloc.oom.15, label %push.reg.copy.16

alloc.oom.15:                                     ; preds = %mul.ok.13
  tail call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.16:                                 ; preds = %mul.ok.13
  %t35 = shl nuw nsw i64 %var.samples.7.sroa.0.01197, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t39, ptr noundef nonnull align 8 dereferenceable(1) %var.samples.7.sroa.18.01199, i64 %t35, i1 false)
  br label %push.store.5

push.grow.from_heap.11:                           ; preds = %mul.ok.9
  %t45 = tail call align 16 ptr @realloc(ptr %var.samples.7.sroa.18.01199, i64 %t33)
  %t46 = icmp eq ptr %t45, null
  br i1 %t46, label %realloc.oom.19, label %push.store.5

realloc.oom.19:                                   ; preds = %push.grow.from_heap.11, %push.grow.from_heap.11.peel
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.5:                                     ; preds = %push.grow.from_heap.11, %push.reg.copy.16, %for.body.1
  %var.samples.7.sroa.9.1 = phi i64 [ %var.samples.7.sroa.9.01198, %for.body.1 ], [ %t28, %push.reg.copy.16 ], [ %t28, %push.grow.from_heap.11 ]
  %var.samples.7.sroa.18.1 = phi ptr [ %var.samples.7.sroa.18.01199, %for.body.1 ], [ %t39, %push.reg.copy.16 ], [ %t45, %push.grow.from_heap.11 ]
  %t52 = getelementptr inbounds nuw double, ptr %var.samples.7.sroa.18.1, i64 %var.samples.7.sroa.0.01197
  store double %t14, ptr %t52, align 8
  %t53 = add nuw nsw i64 %var.samples.7.sroa.0.01197, 1
  %t56 = add nuw nsw i64 %for.i.8.01196, 1
  %exitcond.not = icmp eq i64 %t53, 5
  br i1 %exitcond.not, label %enum.cond.20.preheader, label %for.body.1, !llvm.loop !2

oom.i1002:                                        ; preds = %build_long.i988
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i:                                        ; preds = %enum.cond.20.preheader
  %short.i987 = icmp samesign ult i32 %n32.i, 13
  br i1 %short.i987, label %pack_sso.i, label %build_long.i988

pack_sso.i:                                       ; preds = %chk_sso.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i, i8 0, i64 16, i1 false)
  store i32 %n32.i, ptr %sso.i, align 8
  %sso.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i, i64 %len.i655, i1 false)
  %sso.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i = load i64, ptr %sso.i, align 8
  %sso.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i, i64 8
  %sso.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i = load i64, ptr %sso.i.8.sroa_idx, align 8
  %ss0.i = insertvalue %ArchxStr poison, i64 %sso.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i, 0
  %ss1.i = insertvalue %ArchxStr %ss0.i, i64 %sso.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i, 1
  br label %archx_str_from_slice.exit

build_long.i988:                                  ; preds = %chk_sso.i
  %hp.i989 = tail call noalias align 16 ptr @malloc(i64 %len.i655)
  %hnull.i990 = icmp eq ptr %hp.i989, null
  br i1 %hnull.i990, label %oom.i1002, label %tag_heap.i991

tag_heap.i991:                                    ; preds = %build_long.i988
  %hp_i.i992 = ptrtoint ptr %hp.i989 to i64
  %htagged.i993 = or disjoint i64 %hp_i.i992, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i989, ptr nonnull readonly align 8 %buf.i, i64 %len.i655, i1 false)
  %pref32.i995 = load i32, ptr %hp.i989, align 16
  %pref64.i996 = zext i32 %pref32.i995 to i64
  %pref_sh.i997 = shl nuw i64 %pref64.i996, 32
  %w0_out.i998 = or disjoint i64 %pref_sh.i997, %len.i655
  %ls0.i999 = insertvalue %ArchxStr poison, i64 %w0_out.i998, 0
  %ls1.i1000 = insertvalue %ArchxStr %ls0.i999, i64 %htagged.i993, 1
  br label %archx_str_from_slice.exit

archx_str_from_slice.exit:                        ; preds = %enum.cond.20.preheader, %pack_sso.i, %tag_heap.i991
  %common.ret.op.i1001 = phi %ArchxStr [ %ss1.i, %pack_sso.i ], [ %ls1.i1000, %tag_heap.i991 ], [ zeroinitializer, %enum.cond.20.preheader ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %out_sso.i.sroa.6.sroa.5)
  %bw0.i = extractvalue %ArchxStr %common.ret.op.i1001, 0
  %bw1.i = extractvalue %ArchxStr %common.ret.op.i1001, 1
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
  %bptr.i1253 = phi ptr [ %blptr.i, %build.i.thread ], [ %btmp.i, %build.i ]
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
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %dst_b.i, ptr nonnull align 1 %bptr.i1253, i64 %blen.i, i1 false)
  %w0_out.i = or disjoint i64 %tot.i, 8101238451258523648
  %ls0.i = insertvalue %ArchxStr poison, i64 %w0_out.i, 0
  %ls1.i = insertvalue %ArchxStr %ls0.i, i64 %htagged.i, 1
  br label %archx_str_concat.exit

archx_str_concat.exit:                            ; preds = %archx_str_from_slice.exit, %build_sso.i, %tag_heap.i
  %common.ret.op.i177 = phi %ArchxStr [ %rs1.i, %build_sso.i ], [ %ls1.i, %tag_heap.i ], [ { i64 8101238451258523656, i64 589325676 }, %archx_str_from_slice.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %out_sso.i.sroa.6.sroa.5)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i178)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i180)
  %aw0.i = extractvalue %ArchxStr %common.ret.op.i177, 0
  %aw1.i = extractvalue %ArchxStr %common.ret.op.i177, 1
  %alen.i = and i64 %aw0.i, 4294967295
  %az.i = icmp eq i64 %alen.i, 0
  br i1 %az.i, label %archx_str_concat.exit215, label %chk_bz.i

chk_bz.i:                                         ; preds = %archx_str_concat.exit
  %tot.i182 = add nuw nsw i64 %alen.i, 3
  %too_big.i183 = icmp samesign ugt i64 %alen.i, 2147483644
  br i1 %too_big.i183, label %oom.i204, label %mat_a.i184

oom.i204:                                         ; preds = %build_long.i190, %chk_bz.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i184:                                       ; preds = %chk_bz.i
  %ashort.i = icmp samesign ult i64 %alen.i, 13
  br i1 %ashort.i, label %mat_b.i, label %mat_b.i.thread

mat_b.i.thread:                                   ; preds = %mat_a.i184
  %araw.i = and i64 %aw1.i, -4
  %alptr.i = inttoptr i64 %araw.i to ptr
  br label %build_long.i190

mat_b.i:                                          ; preds = %mat_a.i184
  %ap4.i = lshr i64 %aw0.i, 32
  %ap4_32.i = trunc nuw i64 %ap4.i to i32
  store i32 %ap4_32.i, ptr %atmp.i178, align 4
  store i64 %aw1.i, ptr %atmp4.i214, align 4
  %fits_sso.i189 = icmp samesign ult i64 %alen.i, 10
  br i1 %fits_sso.i189, label %build_sso.i205, label %build_long.i190

build_sso.i205:                                   ; preds = %mat_b.i
  %tot32.i207 = trunc nuw nsw i64 %tot.i182 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i180, i8 0, i64 16, i1 false)
  store i32 %tot32.i207, ptr %out_sso.i180, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i208, ptr nonnull align 4 %atmp.i178, i64 %alen.i, i1 false)
  %sso_dst_b.i209 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i208, i64 %alen.i
  store i24 2112800, ptr %sso_dst_b.i209, align 1
  %rw0.i210 = load i64, ptr %out_sso.i180, align 8
  %rw1.i211 = load i64, ptr %out_sso8.i206, align 8
  %rs0.i212 = insertvalue %ArchxStr poison, i64 %rw0.i210, 0
  %rs1.i213 = insertvalue %ArchxStr %rs0.i212, i64 %rw1.i211, 1
  br label %archx_str_concat.exit215

build_long.i190:                                  ; preds = %mat_b.i.thread, %mat_b.i
  %aptr.i1108 = phi ptr [ %alptr.i, %mat_b.i.thread ], [ %atmp.i178, %mat_b.i ]
  %hp.i191 = tail call noalias align 16 ptr @malloc(i64 %tot.i182)
  %hnull.i192 = icmp eq ptr %hp.i191, null
  br i1 %hnull.i192, label %oom.i204, label %tag_heap.i193

tag_heap.i193:                                    ; preds = %build_long.i190
  %hp_i.i194 = ptrtoint ptr %hp.i191 to i64
  %htagged.i195 = or disjoint i64 %hp_i.i194, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i191, ptr nonnull align 1 %aptr.i1108, i64 %alen.i, i1 false)
  %dst_b.i196 = getelementptr inbounds nuw i8, ptr %hp.i191, i64 %alen.i
  store i24 2112800, ptr %dst_b.i196, align 1
  %pref32.i197 = load i32, ptr %hp.i191, align 16
  %pref64.i198 = zext i32 %pref32.i197 to i64
  %pref_sh.i199 = shl nuw i64 %pref64.i198, 32
  %w0_out.i200 = or disjoint i64 %pref_sh.i199, %tot.i182
  %ls0.i201 = insertvalue %ArchxStr poison, i64 %w0_out.i200, 0
  %ls1.i202 = insertvalue %ArchxStr %ls0.i201, i64 %htagged.i195, 1
  br label %archx_str_concat.exit215

archx_str_concat.exit215:                         ; preds = %archx_str_concat.exit, %build_sso.i205, %tag_heap.i193
  %common.ret.op.i203 = phi %ArchxStr [ %rs1.i213, %build_sso.i205 ], [ %ls1.i202, %tag_heap.i193 ], [ { i64 9074406902988803, i64 0 }, %archx_str_concat.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i178)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i180)
  %t75 = tail call fastcc { i64, i64 } @archx_str_from_float(double %t65.4, ptr null)
  %newret = extractvalue { i64, i64 } %t75, 0
  %oldret = insertvalue %ArchxStr poison, i64 %newret, 0
  %newret1282 = extractvalue { i64, i64 } %t75, 1
  %oldret1283 = insertvalue %ArchxStr %oldret, i64 %newret1282, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i216)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i217)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i218)
  %aw0.i219 = extractvalue %ArchxStr %common.ret.op.i203, 0
  %aw1.i220 = extractvalue %ArchxStr %common.ret.op.i203, 1
  %alen.i223 = and i64 %aw0.i219, 4294967295
  %blen.i224 = and i64 %newret, 4294967295
  %az.i225 = icmp eq i64 %alen.i223, 0
  br i1 %az.i225, label %ret_b.i279, label %chk_bz.i226

ret_b.i279:                                       ; preds = %archx_str_concat.exit215
  %long.i660 = icmp samesign ult i64 %blen.i224, 13
  %tag.i664 = and i64 %newret1282, 3
  %owned.not.i665 = icmp eq i64 %tag.i664, 0
  %or.cond = select i1 %long.i660, i1 true, i1 %owned.not.i665
  br i1 %or.cond, label %archx_str_concat.exit281, label %dup_heap.i

dup_heap.i:                                       ; preds = %ret_b.i279
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %blen.i224)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i666, label %copy.i

oom.i666:                                         ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %newret1282, -4
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 4 %src.i, i64 %blen.i224, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %out.i = insertvalue %ArchxStr %oldret1283, i64 %tagged.i, 1
  br label %archx_str_concat.exit281

chk_bz.i226:                                      ; preds = %archx_str_concat.exit215
  %bz.i227 = icmp eq i64 %blen.i224, 0
  br i1 %bz.i227, label %ret_a.i277, label %calc_tot.i228

ret_a.i277:                                       ; preds = %chk_bz.i226
  %long.i669 = icmp samesign ult i64 %alen.i223, 13
  %tag.i673 = and i64 %aw1.i220, 3
  %owned.not.i674 = icmp eq i64 %tag.i673, 0
  %or.cond1129 = select i1 %long.i669, i1 true, i1 %owned.not.i674
  br i1 %or.cond1129, label %archx_str_concat.exit281, label %dup_heap.i675

dup_heap.i675:                                    ; preds = %ret_a.i277
  %dst.i676 = tail call noalias align 16 ptr @malloc(i64 %alen.i223)
  %isnull.i677 = icmp eq ptr %dst.i676, null
  br i1 %isnull.i677, label %oom.i684, label %copy.i678

oom.i684:                                         ; preds = %dup_heap.i675
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i678:                                        ; preds = %dup_heap.i675
  %src_i.i679 = and i64 %aw1.i220, -4
  %src.i680 = inttoptr i64 %src_i.i679 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i676, ptr nonnull align 4 %src.i680, i64 %alen.i223, i1 false)
  %dst_i.i681 = ptrtoint ptr %dst.i676 to i64
  %tagged.i682 = or disjoint i64 %dst_i.i681, 1
  %out.i683 = insertvalue %ArchxStr %common.ret.op.i203, i64 %tagged.i682, 1
  br label %archx_str_concat.exit281

calc_tot.i228:                                    ; preds = %chk_bz.i226
  %tot.i229 = add nuw nsw i64 %blen.i224, %alen.i223
  %too_big.i230 = icmp samesign ugt i64 %tot.i229, 2147483647
  br i1 %too_big.i230, label %oom.i259, label %mat_a.i231

oom.i259:                                         ; preds = %build_long.i245, %calc_tot.i228
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i231:                                       ; preds = %calc_tot.i228
  %ashort.i232 = icmp samesign ult i64 %alen.i223, 13
  br i1 %ashort.i232, label %mat_a_short.i273, label %mat_a_long.i233

mat_a_short.i273:                                 ; preds = %mat_a.i231
  %ap4.i274 = lshr i64 %aw0.i219, 32
  %ap4_32.i275 = trunc nuw i64 %ap4.i274 to i32
  store i32 %ap4_32.i275, ptr %atmp.i216, align 4
  store i64 %aw1.i220, ptr %atmp4.i276, align 4
  br label %mat_b.i236

mat_a_long.i233:                                  ; preds = %mat_a.i231
  %araw.i234 = and i64 %aw1.i220, -4
  %alptr.i235 = inttoptr i64 %araw.i234 to ptr
  br label %mat_b.i236

mat_b.i236:                                       ; preds = %mat_a_long.i233, %mat_a_short.i273
  %aptr.i237 = phi ptr [ %atmp.i216, %mat_a_short.i273 ], [ %alptr.i235, %mat_a_long.i233 ]
  %bshort.i238 = icmp samesign ult i64 %blen.i224, 13
  br i1 %bshort.i238, label %mat_b_short.i269, label %mat_b_long.i239

mat_b_short.i269:                                 ; preds = %mat_b.i236
  %bp4.i270 = lshr i64 %newret, 32
  %bp4_32.i271 = trunc nuw i64 %bp4.i270 to i32
  store i32 %bp4_32.i271, ptr %btmp.i217, align 4
  store i64 %newret1282, ptr %btmp4.i272, align 4
  br label %build.i242

mat_b_long.i239:                                  ; preds = %mat_b.i236
  %braw.i240 = and i64 %newret1282, -4
  %blptr.i241 = inttoptr i64 %braw.i240 to ptr
  br label %build.i242

build.i242:                                       ; preds = %mat_b_long.i239, %mat_b_short.i269
  %bptr.i243 = phi ptr [ %btmp.i217, %mat_b_short.i269 ], [ %blptr.i241, %mat_b_long.i239 ]
  %fits_sso.i244 = icmp samesign ult i64 %tot.i229, 13
  br i1 %fits_sso.i244, label %build_sso.i260, label %build_long.i245

build_sso.i260:                                   ; preds = %build.i242
  %tot32.i262 = trunc nuw nsw i64 %tot.i229 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i218, i8 0, i64 16, i1 false)
  store i32 %tot32.i262, ptr %out_sso.i218, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i263, ptr nonnull align 1 %aptr.i237, i64 %alen.i223, i1 false)
  %sso_dst_b.i264 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i263, i64 %alen.i223
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i264, ptr nonnull align 1 %bptr.i243, i64 %blen.i224, i1 false)
  %rw0.i265 = load i64, ptr %out_sso.i218, align 8
  %rw1.i266 = load i64, ptr %out_sso8.i261, align 8
  %rs0.i267 = insertvalue %ArchxStr poison, i64 %rw0.i265, 0
  %rs1.i268 = insertvalue %ArchxStr %rs0.i267, i64 %rw1.i266, 1
  br label %archx_str_concat.exit281

build_long.i245:                                  ; preds = %build.i242
  %hp.i246 = tail call noalias align 16 ptr @malloc(i64 %tot.i229)
  %hnull.i247 = icmp eq ptr %hp.i246, null
  br i1 %hnull.i247, label %oom.i259, label %tag_heap.i248

tag_heap.i248:                                    ; preds = %build_long.i245
  %hp_i.i249 = ptrtoint ptr %hp.i246 to i64
  %htagged.i250 = or disjoint i64 %hp_i.i249, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i246, ptr nonnull align 1 %aptr.i237, i64 %alen.i223, i1 false)
  %dst_b.i251 = getelementptr inbounds nuw i8, ptr %hp.i246, i64 %alen.i223
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i251, ptr nonnull align 1 %bptr.i243, i64 %blen.i224, i1 false)
  %pref32.i252 = load i32, ptr %hp.i246, align 16
  %pref64.i253 = zext i32 %pref32.i252 to i64
  %pref_sh.i254 = shl nuw i64 %pref64.i253, 32
  %w0_out.i255 = or disjoint i64 %pref_sh.i254, %tot.i229
  %ls0.i256 = insertvalue %ArchxStr poison, i64 %w0_out.i255, 0
  %ls1.i257 = insertvalue %ArchxStr %ls0.i256, i64 %htagged.i250, 1
  br label %archx_str_concat.exit281

archx_str_concat.exit281:                         ; preds = %copy.i678, %ret_a.i277, %copy.i, %ret_b.i279, %build_sso.i260, %tag_heap.i248
  %common.ret.op.i258 = phi %ArchxStr [ %rs1.i268, %build_sso.i260 ], [ %ls1.i257, %tag_heap.i248 ], [ %out.i, %copy.i ], [ %oldret1283, %ret_b.i279 ], [ %out.i683, %copy.i678 ], [ %common.ret.op.i203, %ret_a.i277 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i216)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i217)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i218)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  %w0.i686 = extractvalue %ArchxStr %common.ret.op.i258, 0
  %w1.i687 = extractvalue %ArchxStr %common.ret.op.i258, 1
  %len.i688 = and i64 %w0.i686, 4294967295
  %short.i = icmp samesign ult i64 %len.i688, 13
  br i1 %short.i, label %emit.i, label %emit.thread.i

emit.thread.i:                                    ; preds = %archx_str_concat.exit281
  %raw.i689 = and i64 %w1.i687, -4
  %lptr.i = inttoptr i64 %raw.i689 to ptr
  br label %chk_nul.i

emit.i:                                           ; preds = %archx_str_concat.exit281
  %p4.i = lshr i64 %w0.i686, 32
  %p4_32.i = trunc nuw i64 %p4.i to i32
  store i32 %p4_32.i, ptr %tmp.i, align 4
  store i64 %w1.i687, ptr %tmp4.i, align 4
  %pos.not.i = icmp eq i64 %len.i688, 0
  br i1 %pos.not.i, label %chk_nl.i, label %chk_nul.i

chk_nul.i:                                        ; preds = %emit.i, %emit.thread.i
  %data3.i = phi ptr [ %lptr.i, %emit.thread.i ], [ %tmp.i, %emit.i ]
  %nul.i = call ptr @memchr(ptr nonnull %data3.i, i32 0, i64 %len.i688)
  %has_nul.not.i = icmp eq ptr %nul.i, null
  br i1 %has_nul.not.i, label %fast_printf.i, label %byte_loop.i

fast_printf.i:                                    ; preds = %chk_nul.i
  %len32.i = trunc i64 %w0.i686 to i32
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i, ptr nonnull %data3.i)
  br label %archx_str_print.exit

byte_loop.i:                                      ; preds = %chk_nul.i, %byte_loop.i
  %bi.i = phi i64 [ %bnext.i, %byte_loop.i ], [ 0, %chk_nul.i ]
  %bp.i = getelementptr inbounds nuw i8, ptr %data3.i, i64 %bi.i
  %ch8.i = load i8, ptr %bp.i, align 1
  %ch32.i = zext i8 %ch8.i to i32
  %pc.i = tail call i32 @putchar(i32 %ch32.i)
  %bnext.i = add nuw nsw i64 %bi.i, 1
  %exitcond.not.i = icmp eq i64 %bnext.i, %len.i688
  br i1 %exitcond.not.i, label %chk_nl.i, label %byte_loop.i

chk_nl.i:                                         ; preds = %byte_loop.i, %emit.i
  %nc.i = tail call i32 @putchar(i32 10)
  br label %archx_str_print.exit

archx_str_print.exit:                             ; preds = %fast_printf.i, %chk_nl.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %tag.i = and i64 %w1.i687, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond1130 = select i1 %short.i, i1 true, i1 %owned.not.i
  br i1 %or.cond1130, label %archx_str_drop.exit, label %do_free.i

do_free.i:                                        ; preds = %archx_str_print.exit
  %raw.i = and i64 %w1.i687, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  call void @free(ptr %ptr.i)
  br label %archx_str_drop.exit

archx_str_drop.exit:                              ; preds = %archx_str_print.exit, %do_free.i
  %long.i25 = icmp samesign ult i64 %blen.i224, 13
  %tag.i28 = and i64 %newret1282, 1
  %owned.not.i29 = icmp eq i64 %tag.i28, 0
  %or.cond1131 = select i1 %long.i25, i1 true, i1 %owned.not.i29
  br i1 %or.cond1131, label %archx_str_drop.exit33, label %do_free.i30

do_free.i30:                                      ; preds = %archx_str_drop.exit
  %raw.i31 = and i64 %newret1282, -2
  %ptr.i32 = inttoptr i64 %raw.i31 to ptr
  call void @free(ptr %ptr.i32)
  br label %archx_str_drop.exit33

archx_str_drop.exit33:                            ; preds = %archx_str_drop.exit, %do_free.i30
  %long.i36 = icmp samesign ult i64 %alen.i223, 13
  %tag.i39 = and i64 %aw1.i220, 1
  %owned.not.i40 = icmp eq i64 %tag.i39, 0
  %or.cond1132 = select i1 %long.i36, i1 true, i1 %owned.not.i40
  br i1 %or.cond1132, label %archx_str_drop.exit44, label %do_free.i41

do_free.i41:                                      ; preds = %archx_str_drop.exit33
  %raw.i42 = and i64 %aw1.i220, -2
  %ptr.i43 = inttoptr i64 %raw.i42 to ptr
  call void @free(ptr %ptr.i43)
  br label %archx_str_drop.exit44

archx_str_drop.exit44:                            ; preds = %archx_str_drop.exit33, %do_free.i41
  %long.i47 = icmp samesign ult i64 %alen.i, 13
  %tag.i50 = and i64 %aw1.i, 1
  %owned.not.i51 = icmp eq i64 %tag.i50, 0
  %or.cond1133 = select i1 %long.i47, i1 true, i1 %owned.not.i51
  br i1 %or.cond1133, label %archx_str_drop.exit55, label %do_free.i52

do_free.i52:                                      ; preds = %archx_str_drop.exit44
  %raw.i53 = and i64 %aw1.i, -2
  %ptr.i54 = inttoptr i64 %raw.i53 to ptr
  call void @free(ptr %ptr.i54)
  br label %archx_str_drop.exit55

archx_str_drop.exit55:                            ; preds = %archx_str_drop.exit44, %do_free.i52
  %long.i58 = icmp samesign ult i64 %blen.i, 13
  %tag.i61 = and i64 %bw1.i, 1
  %owned.not.i62 = icmp eq i64 %tag.i61, 0
  %or.cond1134 = select i1 %long.i58, i1 true, i1 %owned.not.i62
  br i1 %or.cond1134, label %build_long.i.i, label %do_free.i63

do_free.i63:                                      ; preds = %archx_str_drop.exit55
  %raw.i64 = and i64 %bw1.i, -2
  %ptr.i65 = inttoptr i64 %raw.i64 to ptr
  call void @free(ptr %ptr.i65)
  br label %build_long.i.i

oom.i.i:                                          ; preds = %build_long.i.i
  call fastcc void @archx_oom_fail()
  unreachable

build_long.i.i:                                   ; preds = %archx_str_drop.exit55, %do_free.i63
  %hp.i.i = call noalias align 16 dereferenceable_or_null(26) ptr @malloc(i64 26)
  %hnull.i.i = icmp eq ptr %hp.i.i, null
  br i1 %hnull.i.i, label %oom.i.i, label %chk_ws.lr.ph.lr.ph.i

chk_ws.lr.ph.lr.ph.i:                             ; preds = %build_long.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(26) %hp.i.i, ptr noundef nonnull readonly align 2 dereferenceable(26) getelementptr inbounds nuw (i8, ptr @.str.0, i64 2), i64 26, i1 false)
  %sso.i.i693.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i693, i64 4
  %sso.i.i693.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i693, i64 8
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
  br i1 %more.i, label %chk_ws.i, label %archx_str_drop.exit77

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
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i693)
  %z.i.i699 = icmp eq i64 %j.lcssa.i.ph, %i11.i
  br i1 %z.i.i699, label %archx_str_from_slice.exit.i716, label %chk_sso.i.i702

oom.i.i719:                                       ; preds = %build_long.i.i704
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i702:                                   ; preds = %emit_tok.i
  %short.i.i703 = icmp samesign ult i64 %tlen.i, 13
  br i1 %short.i.i703, label %pack_sso.i.i720, label %build_long.i.i704

pack_sso.i.i720:                                  ; preds = %chk_sso.i.i702
  %len32.i.i721 = trunc nuw nsw i64 %tlen.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i693, i8 0, i64 16, i1 false)
  store i32 %len32.i.i721, ptr %sso.i.i693, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i693.4.sroa_idx, ptr nonnull readonly align 1 %cp.i.le, i64 %tlen.i, i1 false)
  %sso.i.i693.0.sso.i.i693.0.sso.i.i693.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i722 = load i64, ptr %sso.i.i693, align 8
  %sso.i.i693.8.sso.i.i693.8.sso.i.i693.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i723 = load i64, ptr %sso.i.i693.8.sroa_idx, align 8
  %ss0.i.i724 = insertvalue %ArchxStr poison, i64 %sso.i.i693.0.sso.i.i693.0.sso.i.i693.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i722, 0
  %ss1.i.i725 = insertvalue %ArchxStr %ss0.i.i724, i64 %sso.i.i693.8.sso.i.i693.8.sso.i.i693.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i723, 1
  br label %archx_str_from_slice.exit.i716

build_long.i.i704:                                ; preds = %chk_sso.i.i702
  %hp.i.i705 = call noalias align 16 ptr @malloc(i64 %tlen.i)
  %hnull.i.i706 = icmp eq ptr %hp.i.i705, null
  br i1 %hnull.i.i706, label %oom.i.i719, label %tag_heap.i.i707

tag_heap.i.i707:                                  ; preds = %build_long.i.i704
  %hp_i.i.i708 = ptrtoint ptr %hp.i.i705 to i64
  %htagged.i.i709 = or disjoint i64 %hp_i.i.i708, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i705, ptr nonnull readonly align 1 %cp.i.le, i64 %tlen.i, i1 false)
  %pref32.i.i710 = load i32, ptr %hp.i.i705, align 16
  %pref64.i.i711 = zext i32 %pref32.i.i710 to i64
  %pref_sh.i.i712 = shl nuw i64 %pref64.i.i711, 32
  %w0_out.i.i713 = or disjoint i64 %pref_sh.i.i712, %tlen.i
  %ls0.i.i714 = insertvalue %ArchxStr poison, i64 %w0_out.i.i713, 0
  %ls1.i.i715 = insertvalue %ArchxStr %ls0.i.i714, i64 %htagged.i.i709, 1
  br label %archx_str_from_slice.exit.i716

archx_str_from_slice.exit.i716:                   ; preds = %tag_heap.i.i707, %pack_sso.i.i720, %emit_tok.i
  %common.ret.op.i.i717 = phi %ArchxStr [ %ss1.i.i725, %pack_sso.i.i720 ], [ %ls1.i.i715, %tag_heap.i.i707 ], [ zeroinitializer, %emit_tok.i ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i693)
  %full.not.i = icmp slt i64 %vlen.ph34.i, %vcap.ph35.i
  br i1 %full.not.i, label %store_elem.i, label %grow.i

grow.i:                                           ; preds = %archx_str_from_slice.exit.i716
  %zc.i = icmp eq i64 %vcap.ph35.i, 0
  %dc.i = shl i64 %vcap.ph35.i, 1
  %ncap.i = select i1 %zc.i, i64 4, i64 %dc.i
  %bytes.i = shl i64 %ncap.i, 4
  %was_null.i = icmp eq ptr %vptr.ph33.i, null
  br i1 %was_null.i, label %gmalloc.i, label %grealloc.i

gmalloc.i:                                        ; preds = %grow.i
  %mp.i = call noalias align 16 ptr @malloc(i64 %bytes.i)
  %mn.i = icmp eq ptr %mp.i, null
  br i1 %mn.i, label %oom.i718, label %store_elem.i

grealloc.i:                                       ; preds = %grow.i
  %rp.i = call align 16 ptr @realloc(ptr nonnull %vptr.ph33.i, i64 %bytes.i)
  %rn.i = icmp eq ptr %rp.i, null
  br i1 %rn.i, label %oom.i718, label %store_elem.i

oom.i718:                                         ; preds = %grealloc.i, %gmalloc.i
  call fastcc void @archx_oom_fail()
  unreachable

store_elem.i:                                     ; preds = %grealloc.i, %gmalloc.i, %archx_str_from_slice.exit.i716
  %vptr_next.i = phi ptr [ %vptr.ph33.i, %archx_str_from_slice.exit.i716 ], [ %mp.i, %gmalloc.i ], [ %rp.i, %grealloc.i ]
  %vcap_next.i = phi i64 [ %vcap.ph35.i, %archx_str_from_slice.exit.i716 ], [ %ncap.i, %gmalloc.i ], [ %ncap.i, %grealloc.i ]
  %ep.i = getelementptr inbounds nuw %ArchxStr, ptr %vptr_next.i, i64 %vlen.ph34.i
  %elem.elt.i = extractvalue %ArchxStr %common.ret.op.i.i717, 0
  store i64 %elem.elt.i, ptr %ep.i, align 16
  %ep.repack1.i = getelementptr inbounds nuw i8, ptr %ep.i, i64 8
  %elem.elt2.i = extractvalue %ArchxStr %common.ret.op.i.i717, 1
  store i64 %elem.elt2.i, ptr %ep.repack1.i, align 8
  %vlen_next.i = add nuw nsw i64 %vlen.ph34.i, 1
  %more10.i = icmp samesign ult i64 %j.lcssa.i.ph, 26
  br i1 %more10.i, label %chk_ws.lr.ph.i, label %archx_str_drop.exit77.thread1255

archx_str_drop.exit77.thread1255:                 ; preds = %store_elem.i
  call void @free(ptr nonnull %hp.i.i)
  br label %idx.ok.27

archx_str_drop.exit77:                            ; preds = %ws_adv.i
  call void @free(ptr %hp.i.i)
  %t89 = icmp eq i64 %vlen.ph34.i, 0
  br i1 %t89, label %idx.oob.28, label %idx.ok.27

idx.oob.28:                                       ; preds = %archx_str_drop.exit77
  call fastcc void @archx_bounds_fail()
  unreachable

idx.ok.27:                                        ; preds = %archx_str_drop.exit77.thread1255, %archx_str_drop.exit77
  %vcap.ph.lcssa5.i1262 = phi i64 [ %vcap_next.i, %archx_str_drop.exit77.thread1255 ], [ %vcap.ph35.i, %archx_str_drop.exit77 ]
  %vlen.ph.lcssa7.i1261 = phi i64 [ %vlen_next.i, %archx_str_drop.exit77.thread1255 ], [ %vlen.ph34.i, %archx_str_drop.exit77 ]
  %vptr.ph.lcssa9.i1260 = phi ptr [ %vptr_next.i, %archx_str_drop.exit77.thread1255 ], [ %vptr.ph33.i, %archx_str_drop.exit77 ]
  %t92.unpack = load i64, ptr %vptr.ph.lcssa9.i1260, align 8
  %t92.elt18 = getelementptr inbounds nuw i8, ptr %vptr.ph.lcssa9.i1260, i64 8
  %t92.unpack19 = load i64, ptr %t92.elt18, align 8
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i729)
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %sbuf.i)
  %len.i732 = and i64 %t92.unpack, 4294967295
  %z.i = icmp eq i64 %len.i732, 0
  br i1 %z.i, label %archx_str_case.exit, label %mat.i

mat.i:                                            ; preds = %idx.ok.27
  %short.i733 = icmp samesign ult i64 %len.i732, 13
  br i1 %short.i733, label %alloc_dst.thread.i, label %alloc_dst.i

alloc_dst.thread.i:                               ; preds = %mat.i
  %p4.i763 = lshr i64 %t92.unpack, 32
  %p4_32.i764 = trunc nuw i64 %p4.i763 to i32
  store i32 %p4_32.i764, ptr %tmp.i729, align 4
  %t4.i765 = getelementptr inbounds nuw i8, ptr %tmp.i729, i64 4
  store i64 %t92.unpack19, ptr %t4.i765, align 4
  br label %iter.check

alloc_dst.i:                                      ; preds = %mat.i
  %raw.i734 = and i64 %t92.unpack19, -4
  %lp.i735 = inttoptr i64 %raw.i734 to ptr
  %fits.i = icmp samesign ugt i64 %len.i732, 64
  br i1 %fits.i, label %use_heap.i, label %iter.check

use_heap.i:                                       ; preds = %alloc_dst.i
  %hp.i761 = call noalias ptr @malloc(i64 %len.i732)
  %hn.i = icmp eq ptr %hp.i761, null
  br i1 %hn.i, label %oom.i762, label %iter.check

oom.i762:                                         ; preds = %use_heap.i
  call fastcc void @archx_oom_fail()
  unreachable

iter.check:                                       ; preds = %use_heap.i, %alloc_dst.i, %alloc_dst.thread.i
  %fits4.i = phi i1 [ true, %use_heap.i ], [ false, %alloc_dst.i ], [ false, %alloc_dst.thread.i ]
  %src3.i = phi ptr [ %lp.i735, %use_heap.i ], [ %lp.i735, %alloc_dst.i ], [ %tmp.i729, %alloc_dst.thread.i ]
  %dst.i736 = phi ptr [ %hp.i761, %use_heap.i ], [ %sbuf.i, %alloc_dst.i ], [ %sbuf.i, %alloc_dst.thread.i ]
  %min.iters.check = icmp samesign ult i64 %len.i732, 8
  br i1 %min.iters.check, label %loop.i.preheader, label %vector.main.loop.iter.check

vector.main.loop.iter.check:                      ; preds = %iter.check
  %min.iters.check1302 = icmp samesign ult i64 %len.i732, 32
  br i1 %min.iters.check1302, label %vec.epilog.ph, label %vector.ph

vector.ph:                                        ; preds = %vector.main.loop.iter.check
  %n.vec = and i64 %t92.unpack, 4294967264
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %2 = getelementptr inbounds nuw i8, ptr %src3.i, i64 %index
  %3 = getelementptr inbounds nuw i8, ptr %2, i64 16
  %wide.load = load <16 x i8>, ptr %2, align 1
  %wide.load1303 = load <16 x i8>, ptr %3, align 1
  %4 = add <16 x i8> %wide.load, splat (i8 -97)
  %5 = add <16 x i8> %wide.load1303, splat (i8 -97)
  %6 = icmp ult <16 x i8> %4, splat (i8 26)
  %7 = icmp ult <16 x i8> %5, splat (i8 26)
  %8 = add <16 x i8> %wide.load, splat (i8 -32)
  %9 = add <16 x i8> %wide.load1303, splat (i8 -32)
  %10 = select <16 x i1> %6, <16 x i8> %8, <16 x i8> %wide.load
  %11 = select <16 x i1> %7, <16 x i8> %9, <16 x i8> %wide.load1303
  %12 = getelementptr inbounds nuw i8, ptr %dst.i736, i64 %index
  %13 = getelementptr inbounds nuw i8, ptr %12, i64 16
  store <16 x i8> %10, ptr %12, align 1
  store <16 x i8> %11, ptr %13, align 1
  %index.next = add nuw i64 %index, 32
  %14 = icmp eq i64 %index.next, %n.vec
  br i1 %14, label %middle.block, label %vector.body, !llvm.loop !4

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %len.i732, %n.vec
  br i1 %cmp.n, label %chk_big.i.i739, label %vec.epilog.iter.check

vec.epilog.iter.check:                            ; preds = %middle.block
  %n.vec.remaining = and i64 %t92.unpack, 24
  %min.epilog.iters.check = icmp eq i64 %n.vec.remaining, 0
  br i1 %min.epilog.iters.check, label %loop.i.preheader, label %vec.epilog.ph

vec.epilog.ph:                                    ; preds = %vec.epilog.iter.check, %vector.main.loop.iter.check
  %vec.epilog.resume.val = phi i64 [ %n.vec, %vec.epilog.iter.check ], [ 0, %vector.main.loop.iter.check ]
  %n.vec1305 = and i64 %t92.unpack, 4294967288
  br label %vec.epilog.vector.body

vec.epilog.vector.body:                           ; preds = %vec.epilog.vector.body, %vec.epilog.ph
  %index1306 = phi i64 [ %vec.epilog.resume.val, %vec.epilog.ph ], [ %index.next1308, %vec.epilog.vector.body ]
  %15 = getelementptr inbounds nuw i8, ptr %src3.i, i64 %index1306
  %wide.load1307 = load <8 x i8>, ptr %15, align 1
  %16 = add <8 x i8> %wide.load1307, splat (i8 -97)
  %17 = icmp ult <8 x i8> %16, splat (i8 26)
  %18 = add <8 x i8> %wide.load1307, splat (i8 -32)
  %19 = select <8 x i1> %17, <8 x i8> %18, <8 x i8> %wide.load1307
  %20 = getelementptr inbounds nuw i8, ptr %dst.i736, i64 %index1306
  store <8 x i8> %19, ptr %20, align 1
  %index.next1308 = add nuw i64 %index1306, 8
  %21 = icmp eq i64 %index.next1308, %n.vec1305
  br i1 %21, label %vec.epilog.middle.block, label %vec.epilog.vector.body, !llvm.loop !7

vec.epilog.middle.block:                          ; preds = %vec.epilog.vector.body
  %cmp.n1309 = icmp eq i64 %len.i732, %n.vec1305
  br i1 %cmp.n1309, label %chk_big.i.i739, label %loop.i.preheader

loop.i.preheader:                                 ; preds = %vec.epilog.iter.check, %vec.epilog.middle.block, %iter.check
  %i.i.ph = phi i64 [ 0, %iter.check ], [ %n.vec, %vec.epilog.iter.check ], [ %n.vec1305, %vec.epilog.middle.block ]
  br label %loop.i

loop.i:                                           ; preds = %loop.i.preheader, %loop.i
  %i.i = phi i64 [ %inext.i, %loop.i ], [ %i.i.ph, %loop.i.preheader ]
  %sp.i = getelementptr inbounds nuw i8, ptr %src3.i, i64 %i.i
  %c.i737 = load i8, ptr %sp.i, align 1
  %lo_s.i = add i8 %c.i737, -97
  %is_lo.i = icmp ult i8 %lo_s.i, 26
  %up_c.i = add i8 %c.i737, -32
  %c1.i = select i1 %is_lo.i, i8 %up_c.i, i8 %c.i737
  %dp.i = getelementptr inbounds nuw i8, ptr %dst.i736, i64 %i.i
  store i8 %c1.i, ptr %dp.i, align 1
  %inext.i = add nuw nsw i64 %i.i, 1
  %exitcond.not.i738 = icmp eq i64 %inext.i, %len.i732
  br i1 %exitcond.not.i738, label %chk_big.i.i739, label %loop.i, !llvm.loop !8

chk_big.i.i739:                                   ; preds = %loop.i, %vec.epilog.middle.block, %middle.block
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i728)
  %big.i.i740 = icmp samesign ugt i64 %len.i732, 2147483647
  br i1 %big.i.i740, label %oom.i.i756, label %chk_sso.i.i741

oom.i.i756:                                       ; preds = %build_long.i.i742, %chk_big.i.i739
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i741:                                   ; preds = %chk_big.i.i739
  br i1 %short.i733, label %pack_sso.i.i757, label %build_long.i.i742

pack_sso.i.i757:                                  ; preds = %chk_sso.i.i741
  %len32.i.i758 = trunc i64 %t92.unpack to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i728, i8 0, i64 16, i1 false)
  store i32 %len32.i.i758, ptr %sso.i.i728, align 8
  %sso.i.i728.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i728, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i728.4.sroa_idx, ptr nonnull readonly align 1 %dst.i736, i64 %len.i732, i1 false)
  %sso.i.i728.0.sso.i.i728.0.sso.i.i728.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i759 = load i64, ptr %sso.i.i728, align 8
  %sso.i.i728.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i728, i64 8
  %sso.i.i728.8.sso.i.i728.8.sso.i.i728.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i760 = load i64, ptr %sso.i.i728.8.sroa_idx, align 8
  br label %archx_str_from_slice.exit.i752

build_long.i.i742:                                ; preds = %chk_sso.i.i741
  %hp.i.i743 = call noalias align 16 ptr @malloc(i64 %len.i732)
  %hnull.i.i744 = icmp eq ptr %hp.i.i743, null
  br i1 %hnull.i.i744, label %oom.i.i756, label %tag_heap.i.i745

tag_heap.i.i745:                                  ; preds = %build_long.i.i742
  %hp_i.i.i746 = ptrtoint ptr %hp.i.i743 to i64
  %htagged.i.i747 = or disjoint i64 %hp_i.i.i746, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i743, ptr nonnull readonly align 1 %dst.i736, i64 %len.i732, i1 false)
  %pref32.i.i748 = load i32, ptr %hp.i.i743, align 16
  %pref64.i.i749 = zext i32 %pref32.i.i748 to i64
  %pref_sh.i.i750 = shl nuw i64 %pref64.i.i749, 32
  %w0_out.i.i751 = or disjoint i64 %pref_sh.i.i750, %len.i732
  br label %archx_str_from_slice.exit.i752

archx_str_from_slice.exit.i752:                   ; preds = %tag_heap.i.i745, %pack_sso.i.i757
  %sso.i.0.sso.0.sso.0.sso.0.sw0.i.pn.i = phi i64 [ %sso.i.i728.0.sso.i.i728.0.sso.i.i728.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i759, %pack_sso.i.i757 ], [ %w0_out.i.i751, %tag_heap.i.i745 ]
  %sso.i.8.sso.8.sso.8.sso.8.sw1.i.pn.i = phi i64 [ %sso.i.i728.8.sso.i.i728.8.sso.i.i728.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i760, %pack_sso.i.i757 ], [ %htagged.i.i747, %tag_heap.i.i745 ]
  %ss0.i.pn.i = insertvalue %ArchxStr poison, i64 %sso.i.0.sso.0.sso.0.sso.0.sw0.i.pn.i, 0
  %common.ret.op.i.i753 = insertvalue %ArchxStr %ss0.i.pn.i, i64 %sso.i.8.sso.8.sso.8.sso.8.sw1.i.pn.i, 1
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i728)
  br i1 %fits4.i, label %do_free.i755, label %archx_str_case.exit

do_free.i755:                                     ; preds = %archx_str_from_slice.exit.i752
  call void @free(ptr nonnull %dst.i736)
  br label %archx_str_case.exit

archx_str_case.exit:                              ; preds = %idx.ok.27, %archx_str_from_slice.exit.i752, %do_free.i755
  %common.ret.op.i754 = phi %ArchxStr [ zeroinitializer, %idx.ok.27 ], [ %common.ret.op.i.i753, %do_free.i755 ], [ %common.ret.op.i.i753, %archx_str_from_slice.exit.i752 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i729)
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %sbuf.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i766)
  store i32 1685221239, ptr %tmp.i766, align 4
  %tmp4.i768 = getelementptr inbounds nuw i8, ptr %tmp.i766, i64 4
  store i64 14963, ptr %tmp4.i768, align 4
  %nul.i771 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i766, i32 0, i64 6)
  %has_nul.not.i772 = icmp eq ptr %nul.i771, null
  br i1 %has_nul.not.i772, label %fast_printf.i782, label %byte_loop.i773.preheader

byte_loop.i773.preheader:                         ; preds = %archx_str_case.exit
  %pc.i778 = call i32 @putchar(i32 119)
  %bp.i775.1 = getelementptr inbounds nuw i8, ptr %tmp.i766, i64 1
  %ch8.i776.1 = load i8, ptr %bp.i775.1, align 1
  %ch32.i777.1 = zext i8 %ch8.i776.1 to i32
  %pc.i778.1 = call i32 @putchar(i32 %ch32.i777.1)
  %bp.i775.2 = getelementptr inbounds nuw i8, ptr %tmp.i766, i64 2
  %ch8.i776.2 = load i8, ptr %bp.i775.2, align 2
  %ch32.i777.2 = zext i8 %ch8.i776.2 to i32
  %pc.i778.2 = call i32 @putchar(i32 %ch32.i777.2)
  %bp.i775.3 = getelementptr inbounds nuw i8, ptr %tmp.i766, i64 3
  %ch8.i776.3 = load i8, ptr %bp.i775.3, align 1
  %ch32.i777.3 = zext i8 %ch8.i776.3 to i32
  %pc.i778.3 = call i32 @putchar(i32 %ch32.i777.3)
  %ch8.i776.4 = load i8, ptr %tmp4.i768, align 4
  %ch32.i777.4 = zext i8 %ch8.i776.4 to i32
  %pc.i778.4 = call i32 @putchar(i32 %ch32.i777.4)
  %bp.i775.5 = getelementptr inbounds nuw i8, ptr %tmp.i766, i64 5
  %ch8.i776.5 = load i8, ptr %bp.i775.5, align 1
  %ch32.i777.5 = zext i8 %ch8.i776.5 to i32
  %pc.i778.5 = call i32 @putchar(i32 %ch32.i777.5)
  br label %archx_str_print.exit784

fast_printf.i782:                                 ; preds = %archx_str_case.exit
  %np.i783 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 6, ptr nonnull %tmp.i766)
  br label %archx_str_print.exit784

archx_str_print.exit784:                          ; preds = %byte_loop.i773.preheader, %fast_printf.i782
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i766)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i785)
  store i32 2128928, ptr %tmp.i785, align 4
  %tmp4.i787 = getelementptr inbounds nuw i8, ptr %tmp.i785, i64 4
  store i64 0, ptr %tmp4.i787, align 4
  %nul.i790 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i785, i32 0, i64 3)
  %has_nul.not.i791 = icmp eq ptr %nul.i790, null
  br i1 %has_nul.not.i791, label %fast_printf.i801, label %byte_loop.i792.preheader

byte_loop.i792.preheader:                         ; preds = %archx_str_print.exit784
  %pc.i797 = call i32 @putchar(i32 32)
  %bp.i794.1 = getelementptr inbounds nuw i8, ptr %tmp.i785, i64 1
  %ch8.i795.1 = load i8, ptr %bp.i794.1, align 1
  %ch32.i796.1 = zext i8 %ch8.i795.1 to i32
  %pc.i797.1 = call i32 @putchar(i32 %ch32.i796.1)
  %bp.i794.2 = getelementptr inbounds nuw i8, ptr %tmp.i785, i64 2
  %ch8.i795.2 = load i8, ptr %bp.i794.2, align 2
  %ch32.i796.2 = zext i8 %ch8.i795.2 to i32
  %pc.i797.2 = call i32 @putchar(i32 %ch32.i796.2)
  br label %archx_str_print.exit803

fast_printf.i801:                                 ; preds = %archx_str_print.exit784
  %np.i802 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 3, ptr nonnull %tmp.i785)
  br label %archx_str_print.exit803

archx_str_print.exit803:                          ; preds = %byte_loop.i792.preheader, %fast_printf.i801
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i785)
  %t94 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %vlen.ph.lcssa7.i1261)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i804)
  store i32 2128928, ptr %tmp.i804, align 4
  %tmp4.i806 = getelementptr inbounds nuw i8, ptr %tmp.i804, i64 4
  store i64 0, ptr %tmp4.i806, align 4
  %nul.i809 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i804, i32 0, i64 3)
  %has_nul.not.i810 = icmp eq ptr %nul.i809, null
  br i1 %has_nul.not.i810, label %fast_printf.i820, label %byte_loop.i811.preheader

byte_loop.i811.preheader:                         ; preds = %archx_str_print.exit803
  %pc.i816 = call i32 @putchar(i32 32)
  %bp.i813.1 = getelementptr inbounds nuw i8, ptr %tmp.i804, i64 1
  %ch8.i814.1 = load i8, ptr %bp.i813.1, align 1
  %ch32.i815.1 = zext i8 %ch8.i814.1 to i32
  %pc.i816.1 = call i32 @putchar(i32 %ch32.i815.1)
  %bp.i813.2 = getelementptr inbounds nuw i8, ptr %tmp.i804, i64 2
  %ch8.i814.2 = load i8, ptr %bp.i813.2, align 2
  %ch32.i815.2 = zext i8 %ch8.i814.2 to i32
  %pc.i816.2 = call i32 @putchar(i32 %ch32.i815.2)
  br label %archx_str_print.exit822

fast_printf.i820:                                 ; preds = %archx_str_print.exit803
  %np.i821 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 3, ptr nonnull %tmp.i804)
  br label %archx_str_print.exit822

archx_str_print.exit822:                          ; preds = %byte_loop.i811.preheader, %fast_printf.i820
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i804)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i823)
  %w0.i824 = extractvalue %ArchxStr %common.ret.op.i754, 0
  %w1.i825 = extractvalue %ArchxStr %common.ret.op.i754, 1
  %len.i826 = and i64 %w0.i824, 4294967295
  %short.i827 = icmp samesign ult i64 %len.i826, 13
  br i1 %short.i827, label %emit.i847, label %emit.thread.i828

emit.thread.i828:                                 ; preds = %archx_str_print.exit822
  %raw.i829 = and i64 %w1.i825, -4
  %lptr.i830 = inttoptr i64 %raw.i829 to ptr
  br label %chk_nul.i831

emit.i847:                                        ; preds = %archx_str_print.exit822
  %p4.i848 = lshr i64 %w0.i824, 32
  %p4_32.i849 = trunc nuw i64 %p4.i848 to i32
  store i32 %p4_32.i849, ptr %tmp.i823, align 4
  %tmp4.i850 = getelementptr inbounds nuw i8, ptr %tmp.i823, i64 4
  store i64 %w1.i825, ptr %tmp4.i850, align 4
  %pos.not.i851 = icmp eq i64 %len.i826, 0
  br i1 %pos.not.i851, label %archx_str_print.exit852.thread, label %chk_nul.i831

archx_str_print.exit852.thread:                   ; preds = %emit.i847
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i823)
  %t951123 = call i32 @putchar(i32 10)
  br label %archx_str_drop.exit88

chk_nul.i831:                                     ; preds = %emit.i847, %emit.thread.i828
  %data3.i832 = phi ptr [ %lptr.i830, %emit.thread.i828 ], [ %tmp.i823, %emit.i847 ]
  %nul.i833 = call ptr @memchr(ptr nonnull %data3.i832, i32 0, i64 %len.i826)
  %has_nul.not.i834 = icmp eq ptr %nul.i833, null
  br i1 %has_nul.not.i834, label %fast_printf.i844, label %byte_loop.i835

fast_printf.i844:                                 ; preds = %chk_nul.i831
  %len32.i845 = trunc i64 %w0.i824 to i32
  %np.i846 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 %len32.i845, ptr nonnull %data3.i832)
  br label %archx_str_print.exit852

byte_loop.i835:                                   ; preds = %chk_nul.i831, %byte_loop.i835
  %bi.i836 = phi i64 [ %bnext.i841, %byte_loop.i835 ], [ 0, %chk_nul.i831 ]
  %bp.i837 = getelementptr inbounds nuw i8, ptr %data3.i832, i64 %bi.i836
  %ch8.i838 = load i8, ptr %bp.i837, align 1
  %ch32.i839 = zext i8 %ch8.i838 to i32
  %pc.i840 = call i32 @putchar(i32 %ch32.i839)
  %bnext.i841 = add nuw nsw i64 %bi.i836, 1
  %exitcond.not.i842 = icmp eq i64 %bnext.i841, %len.i826
  br i1 %exitcond.not.i842, label %archx_str_print.exit852, label %byte_loop.i835

archx_str_print.exit852:                          ; preds = %byte_loop.i835, %fast_printf.i844
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i823)
  %t95 = call i32 @putchar(i32 10)
  %tag.i83 = and i64 %w1.i825, 1
  %owned.not.i84 = icmp eq i64 %tag.i83, 0
  %or.cond1136 = select i1 %short.i827, i1 true, i1 %owned.not.i84
  br i1 %or.cond1136, label %archx_str_drop.exit88, label %do_free.i85

do_free.i85:                                      ; preds = %archx_str_print.exit852
  %raw.i86 = and i64 %w1.i825, -2
  %ptr.i87 = inttoptr i64 %raw.i86 to ptr
  call void @free(ptr %ptr.i87)
  br label %archx_str_drop.exit88

archx_str_drop.exit88:                            ; preds = %archx_str_print.exit852.thread, %archx_str_print.exit852, %do_free.i85
  %cur.i = load ptr, ptr %func.region, align 8
  %end.i22 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i = ptrtoint ptr %cur.i to i64
  %end_i.i = ptrtoint ptr %end.i22 to i64
  %rem.i = sub i64 %end_i.i, %cur_i.i
  %fits.not.i = icmp slt i64 %rem.i, 8000
  br i1 %fits.not.i, label %fallback.i, label %fast.i

fast.i:                                           ; preds = %archx_str_drop.exit88
  %next.i = getelementptr inbounds nuw i8, ptr %cur.i, i64 8000
  store ptr %next.i, ptr %func.region, align 8
  br label %archx_region_alloc.exit

fallback.i:                                       ; preds = %archx_str_drop.exit88
  %res.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 8000)
  br label %archx_region_alloc.exit

archx_region_alloc.exit:                          ; preds = %fast.i, %fallback.i
  %common.ret.op.i = phi ptr [ %cur.i, %fast.i ], [ %res.i, %fallback.i ]
  %t113.1 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 800
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(8000) %common.ret.op.i, i8 0, i64 8000, i1 false)
  store i64 10, ptr %t113.1, align 8
  %t113.2 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 1600
  store i64 20, ptr %t113.2, align 8
  %t113.3 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 2400
  store i64 30, ptr %t113.3, align 8
  %t113.4 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 3200
  store i64 40, ptr %t113.4, align 8
  %t113.5 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 4000
  store i64 50, ptr %t113.5, align 8
  %t113.6 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 4800
  store i64 60, ptr %t113.6, align 8
  %t113.7 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 5600
  store i64 70, ptr %t113.7, align 8
  %t113.8 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 6400
  store i64 80, ptr %t113.8, align 8
  %t113.9 = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 7200
  store i64 90, ptr %t113.9, align 8
  %t5.i856 = fdiv double %t7.i.4, 5.000000e+00
  %t134 = call fastcc { i64, i64 } @archx_str_from_float(double %t5.i856, ptr nonnull %func.region)
  %newret1284 = extractvalue { i64, i64 } %t134, 0
  %newret1286 = extractvalue { i64, i64 } %t134, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i283)
  %blen.i287 = and i64 %newret1284, 4294967295
  %bz.i289 = icmp eq i64 %blen.i287, 0
  br i1 %bz.i289, label %archx_str_concat.exit335, label %calc_tot.i290

calc_tot.i290:                                    ; preds = %archx_region_alloc.exit
  %tot.i291 = add nuw nsw i64 %blen.i287, 5
  %too_big.i292 = icmp samesign ugt i64 %blen.i287, 2147483642
  br i1 %too_big.i292, label %oom.i319, label %mat_a.i293

oom.i319:                                         ; preds = %calc_tot.i290
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i293:                                       ; preds = %calc_tot.i290
  %bshort.i298 = icmp samesign ult i64 %blen.i287, 13
  br i1 %bshort.i298, label %build.i302, label %build.i302.thread

build.i302.thread:                                ; preds = %mat_a.i293
  %braw.i300 = and i64 %newret1286, -4
  %blptr.i301 = inttoptr i64 %braw.i300 to ptr
  br label %build_long.i305

build.i302:                                       ; preds = %mat_a.i293
  %bp4.i330 = lshr i64 %newret1284, 32
  %bp4_32.i331 = trunc nuw i64 %bp4.i330 to i32
  store i32 %bp4_32.i331, ptr %btmp.i283, align 4
  %btmp4.i332 = getelementptr inbounds nuw i8, ptr %btmp.i283, i64 4
  store i64 %newret1286, ptr %btmp4.i332, align 4
  %fits_sso.i304 = icmp samesign ult i64 %blen.i287, 8
  br i1 %fits_sso.i304, label %build_sso.i320, label %build_long.i305

build_sso.i320:                                   ; preds = %build.i302
  store i56 0, ptr %out_sso.i284.sroa.6.sroa.5.sroa.0, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i284.sroa.6.sroa.5.sroa.0, ptr nonnull align 4 %btmp.i283, i64 %blen.i287, i1 false)
  %out_sso.i284.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i291, 7953749935738847232
  %out_sso.i284.sroa.6.sroa.5.sroa.0.0.out_sso.i284.sroa.6.sroa.5.sroa.0.0.out_sso.i284.sroa.6.sroa.5.sroa.0.0.out_sso.i284.sroa.6.sroa.5.sroa.0.0.out_sso.i284.sroa.6.sroa.5.0.out_sso.i284.sroa.6.8.rw1.i326 = load i56, ptr %out_sso.i284.sroa.6.sroa.5.sroa.0, align 8
  %out_sso.i284.sroa.6.sroa.5.0.insert.ext = zext i56 %out_sso.i284.sroa.6.sroa.5.sroa.0.0.out_sso.i284.sroa.6.sroa.5.sroa.0.0.out_sso.i284.sroa.6.sroa.5.sroa.0.0.out_sso.i284.sroa.6.sroa.5.sroa.0.0.out_sso.i284.sroa.6.sroa.5.0.out_sso.i284.sroa.6.8.rw1.i326 to i64
  %out_sso.i284.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i284.sroa.6.sroa.5.0.insert.ext, 8
  %out_sso.i284.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i284.sroa.6.sroa.5.0.insert.shift, 61
  %rs0.i327 = insertvalue %ArchxStr poison, i64 %out_sso.i284.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i328 = insertvalue %ArchxStr %rs0.i327, i64 %out_sso.i284.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit335

build_long.i305:                                  ; preds = %build.i302.thread, %build.i302
  %bptr.i3031265 = phi ptr [ %blptr.i301, %build.i302.thread ], [ %btmp.i283, %build.i302 ]
  %a1.i.i = add i64 %newret1284, 20
  %aligned.i.i = and i64 %a1.i.i, 4294967280
  %cur.i.i = load ptr, ptr %func.region, align 8
  %end.i.i = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i = ptrtoint ptr %cur.i.i to i64
  %end_i.i.i = ptrtoint ptr %end.i.i to i64
  %rem.i.i = sub i64 %end_i.i.i, %cur_i.i.i
  %fits.not.i.i = icmp slt i64 %rem.i.i, %aligned.i.i
  br i1 %fits.not.i.i, label %fallback.i.i, label %fast.i.i

fast.i.i:                                         ; preds = %build_long.i305
  %next.i.i = getelementptr inbounds nuw i8, ptr %cur.i.i, i64 %aligned.i.i
  store ptr %next.i.i, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i

fallback.i.i:                                     ; preds = %build_long.i305
  %res.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i)
  %.pre1250 = ptrtoint ptr %res.i.i to i64
  br label %archx_region_alloc.exit.i

archx_region_alloc.exit.i:                        ; preds = %fallback.i.i, %fast.i.i
  %rp_i.i.pre-phi = phi i64 [ %.pre1250, %fallback.i.i ], [ %cur_i.i.i, %fast.i.i ]
  %common.ret.op.i.i = phi ptr [ %res.i.i, %fallback.i.i ], [ %cur.i.i, %fast.i.i ]
  %rtagged.i = or disjoint i64 %rp_i.i.pre-phi, 2
  store i32 1851876717, ptr %common.ret.op.i.i, align 16
  %atmp.i282.sroa.5.0.common.ret.op.i.i.sroa_idx = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i, i64 4
  store i8 61, ptr %atmp.i282.sroa.5.0.common.ret.op.i.i.sroa_idx, align 4
  %dst_b.i306 = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i, i64 5
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i306, ptr nonnull align 1 %bptr.i3031265, i64 %blen.i287, i1 false)
  %w0_out.i310 = or disjoint i64 %tot.i291, 7953749935738847232
  %ls0.i311 = insertvalue %ArchxStr poison, i64 %w0_out.i310, 0
  %ls1.i312 = insertvalue %ArchxStr %ls0.i311, i64 %rtagged.i, 1
  br label %archx_str_concat.exit335

archx_str_concat.exit335:                         ; preds = %archx_region_alloc.exit, %build_sso.i320, %archx_region_alloc.exit.i
  %common.ret.op.i313 = phi %ArchxStr [ %rs1.i328, %build_sso.i320 ], [ %ls1.i312, %archx_region_alloc.exit.i ], [ { i64 7953749935738847237, i64 61 }, %archx_region_alloc.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i283)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i336)
  %aw0.i339 = extractvalue %ArchxStr %common.ret.op.i313, 0
  %aw1.i340 = extractvalue %ArchxStr %common.ret.op.i313, 1
  %alen.i341 = and i64 %aw0.i339, 4294967295
  %az.i342 = icmp eq i64 %alen.i341, 0
  br i1 %az.i342, label %archx_str_concat.exit406, label %chk_bz.i343

chk_bz.i343:                                      ; preds = %archx_str_concat.exit335
  %tot.i345 = add nuw nsw i64 %alen.i341, 12
  %too_big.i346 = icmp samesign ugt i64 %alen.i341, 2147483635
  br i1 %too_big.i346, label %oom.i390, label %mat_a.i347

oom.i390:                                         ; preds = %chk_bz.i343
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i347:                                       ; preds = %chk_bz.i343
  %ashort.i348 = icmp samesign ult i64 %alen.i341, 13
  br i1 %ashort.i348, label %mat_a_short.i400, label %mat_a_long.i349

mat_a_short.i400:                                 ; preds = %mat_a.i347
  %ap4.i401 = lshr i64 %aw0.i339, 32
  %ap4_32.i402 = trunc nuw i64 %ap4.i401 to i32
  store i32 %ap4_32.i402, ptr %atmp.i336, align 4
  %atmp4.i403 = getelementptr inbounds nuw i8, ptr %atmp.i336, i64 4
  store i64 %aw1.i340, ptr %atmp4.i403, align 4
  br label %build_long.i359

mat_a_long.i349:                                  ; preds = %mat_a.i347
  %araw.i350 = and i64 %aw1.i340, -4
  %alptr.i351 = inttoptr i64 %araw.i350 to ptr
  br label %build_long.i359

build_long.i359:                                  ; preds = %mat_a_short.i400, %mat_a_long.i349
  %aptr.i353 = phi ptr [ %atmp.i336, %mat_a_short.i400 ], [ %alptr.i351, %mat_a_long.i349 ]
  %a1.i.i360 = add i64 %aw0.i339, 27
  %aligned.i.i361 = and i64 %a1.i.i360, 4294967280
  %cur.i.i363 = load ptr, ptr %func.region, align 8
  %end.i.i364 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i365 = ptrtoint ptr %cur.i.i363 to i64
  %end_i.i.i366 = ptrtoint ptr %end.i.i364 to i64
  %rem.i.i367 = sub i64 %end_i.i.i366, %cur_i.i.i365
  %fits.not.i.i368 = icmp slt i64 %rem.i.i367, %aligned.i.i361
  br i1 %fits.not.i.i368, label %fallback.i.i383, label %fast.i.i369

fast.i.i369:                                      ; preds = %build_long.i359
  %next.i.i370 = getelementptr inbounds nuw i8, ptr %cur.i.i363, i64 %aligned.i.i361
  store ptr %next.i.i370, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i371

fallback.i.i383:                                  ; preds = %build_long.i359
  %res.i.i384 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i361)
  %.pre1249 = ptrtoint ptr %res.i.i384 to i64
  br label %archx_region_alloc.exit.i371

archx_region_alloc.exit.i371:                     ; preds = %fallback.i.i383, %fast.i.i369
  %rp_i.i373.pre-phi = phi i64 [ %.pre1249, %fallback.i.i383 ], [ %cur_i.i.i365, %fast.i.i369 ]
  %common.ret.op.i.i372 = phi ptr [ %res.i.i384, %fallback.i.i383 ], [ %cur.i.i363, %fast.i.i369 ]
  %rtagged.i374 = or disjoint i64 %rp_i.i373.pre-phi, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i372, ptr nonnull align 1 %aptr.i353, i64 %alen.i341, i1 false)
  %dst_b.i375 = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i372, i64 %alen.i341
  store i32 1868767276, ptr %dst_b.i375, align 1
  %btmp.i337.sroa.5.0.dst_b.i375.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i375, i64 4
  store i64 4426606804062203509, ptr %btmp.i337.sroa.5.0.dst_b.i375.sroa_idx, align 1
  %pref32.i376 = load i32, ptr %common.ret.op.i.i372, align 16
  %pref64.i377 = zext i32 %pref32.i376 to i64
  %pref_sh.i378 = shl nuw i64 %pref64.i377, 32
  %w0_out.i379 = or disjoint i64 %pref_sh.i378, %tot.i345
  %ls0.i380 = insertvalue %ArchxStr poison, i64 %w0_out.i379, 0
  %ls1.i381 = insertvalue %ArchxStr %ls0.i380, i64 %rtagged.i374, 1
  br label %archx_str_concat.exit406

archx_str_concat.exit406:                         ; preds = %archx_str_concat.exit335, %archx_region_alloc.exit.i371
  %common.ret.op.i382 = phi %ArchxStr [ %ls1.i381, %archx_region_alloc.exit.i371 ], [ { i64 8026294334255005708, i64 4426606804062203509 }, %archx_str_concat.exit335 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i336)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i859)
  %n32.i860 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i859, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 30)
  %len.i861 = sext i32 %n32.i860 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i1004)
  %z.i1005 = icmp slt i32 %n32.i860, 1
  br i1 %z.i1005, label %archx_str_from_slice.exit1049, label %chk_sso.i1008

chk_sso.i1008:                                    ; preds = %archx_str_concat.exit406
  %short.i1009 = icmp samesign ult i32 %n32.i860, 13
  br i1 %short.i1009, label %pack_sso.i1041, label %build_long.i1010

pack_sso.i1041:                                   ; preds = %chk_sso.i1008
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i1004, i8 0, i64 16, i1 false)
  store i32 %n32.i860, ptr %sso.i1004, align 8
  %sso.i1004.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i1004, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i1004.4.sroa_idx, ptr nonnull readonly align 8 %buf.i859, i64 %len.i861, i1 false)
  %sso.i1004.0.sso.i1004.0.sso.i1004.0.sso.0.sso.0.sso.0.sw0.i1045 = load i64, ptr %sso.i1004, align 8
  %sso.i1004.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i1004, i64 8
  %sso.i1004.8.sso.i1004.8.sso.i1004.8.sso.8.sso.8.sso.8.sw1.i1046 = load i64, ptr %sso.i1004.8.sroa_idx, align 8
  %ss0.i1047 = insertvalue %ArchxStr poison, i64 %sso.i1004.0.sso.i1004.0.sso.i1004.0.sso.0.sso.0.sso.0.sw0.i1045, 0
  %ss1.i1048 = insertvalue %ArchxStr %ss0.i1047, i64 %sso.i1004.8.sso.i1004.8.sso.i1004.8.sso.8.sso.8.sso.8.sw1.i1046, 1
  br label %archx_str_from_slice.exit1049

build_long.i1010:                                 ; preds = %chk_sso.i1008
  %a1.i.i1011 = add nuw nsw i64 %len.i861, 15
  %aligned.i.i1012 = and i64 %a1.i.i1011, 4294967280
  %cur.i.i1014 = load ptr, ptr %func.region, align 8
  %end.i.i1015 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i1016 = ptrtoint ptr %cur.i.i1014 to i64
  %end_i.i.i1017 = ptrtoint ptr %end.i.i1015 to i64
  %rem.i.i1018 = sub i64 %end_i.i.i1017, %cur_i.i.i1016
  %fits.not.i.i1019 = icmp slt i64 %rem.i.i1018, %aligned.i.i1012
  br i1 %fits.not.i.i1019, label %fallback.i.i1033, label %fast.i.i1020

fast.i.i1020:                                     ; preds = %build_long.i1010
  %next.i.i1021 = getelementptr inbounds nuw i8, ptr %cur.i.i1014, i64 %aligned.i.i1012
  store ptr %next.i.i1021, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i1022

fallback.i.i1033:                                 ; preds = %build_long.i1010
  %res.i.i1034 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i1012)
  %.pre.i = ptrtoint ptr %res.i.i1034 to i64
  br label %archx_region_alloc.exit.i1022

archx_region_alloc.exit.i1022:                    ; preds = %fallback.i.i1033, %fast.i.i1020
  %rp_i.pre-phi.i = phi i64 [ %cur_i.i.i1016, %fast.i.i1020 ], [ %.pre.i, %fallback.i.i1033 ]
  %common.ret.op.i.i1023 = phi ptr [ %cur.i.i1014, %fast.i.i1020 ], [ %res.i.i1034, %fallback.i.i1033 ]
  %rtagged.i1024 = or disjoint i64 %rp_i.pre-phi.i, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i1023, ptr nonnull readonly align 8 %buf.i859, i64 %len.i861, i1 false)
  %pref32.i1026 = load i32, ptr %common.ret.op.i.i1023, align 16
  %pref64.i1027 = zext i32 %pref32.i1026 to i64
  %pref_sh.i1028 = shl nuw i64 %pref64.i1027, 32
  %w0_out.i1029 = or disjoint i64 %pref_sh.i1028, %len.i861
  %ls0.i1030 = insertvalue %ArchxStr poison, i64 %w0_out.i1029, 0
  %ls1.i1031 = insertvalue %ArchxStr %ls0.i1030, i64 %rtagged.i1024, 1
  br label %archx_str_from_slice.exit1049

archx_str_from_slice.exit1049:                    ; preds = %archx_str_concat.exit406, %pack_sso.i1041, %archx_region_alloc.exit.i1022
  %common.ret.op.i1032 = phi %ArchxStr [ %ss1.i1048, %pack_sso.i1041 ], [ %ls1.i1031, %archx_region_alloc.exit.i1022 ], [ zeroinitializer, %archx_str_concat.exit406 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i1004)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i859)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i407)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i408)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i409)
  %aw0.i410 = extractvalue %ArchxStr %common.ret.op.i382, 0
  %aw1.i411 = extractvalue %ArchxStr %common.ret.op.i382, 1
  %bw0.i412 = extractvalue %ArchxStr %common.ret.op.i1032, 0
  %bw1.i413 = extractvalue %ArchxStr %common.ret.op.i1032, 1
  %alen.i414 = and i64 %aw0.i410, 4294967295
  %blen.i415 = and i64 %bw0.i412, 4294967295
  %az.i416 = icmp eq i64 %alen.i414, 0
  br i1 %az.i416, label %ret_b.i489, label %chk_bz.i417

ret_b.i489:                                       ; preds = %archx_str_from_slice.exit1049
  %bw1_tag.i490 = and i64 %bw1.i413, 1
  %b_owned.i491 = icmp eq i64 %bw1_tag.i490, 0
  %long.i865 = icmp samesign ult i64 %blen.i415, 13
  %or.cond1137.not1154 = select i1 %b_owned.i491, i1 true, i1 %long.i865
  %tag.i869 = and i64 %bw1.i413, 3
  %owned.not.i870 = icmp eq i64 %tag.i869, 0
  %or.cond1138 = select i1 %or.cond1137.not1154, i1 true, i1 %owned.not.i870
  br i1 %or.cond1138, label %archx_str_concat.exit493, label %dup_heap.i871

dup_heap.i871:                                    ; preds = %ret_b.i489
  %dst.i872 = call noalias align 16 ptr @malloc(i64 %blen.i415)
  %isnull.i873 = icmp eq ptr %dst.i872, null
  br i1 %isnull.i873, label %oom.i880, label %copy.i874

oom.i880:                                         ; preds = %dup_heap.i871
  call fastcc void @archx_oom_fail()
  unreachable

copy.i874:                                        ; preds = %dup_heap.i871
  %src_i.i875 = and i64 %bw1.i413, -4
  %src.i876 = inttoptr i64 %src_i.i875 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i872, ptr nonnull align 4 %src.i876, i64 %blen.i415, i1 false)
  %dst_i.i877 = ptrtoint ptr %dst.i872 to i64
  %tagged.i878 = or disjoint i64 %dst_i.i877, 1
  %out.i879 = insertvalue %ArchxStr %common.ret.op.i1032, i64 %tagged.i878, 1
  br label %archx_str_concat.exit493

chk_bz.i417:                                      ; preds = %archx_str_from_slice.exit1049
  %bz.i418 = icmp eq i64 %blen.i415, 0
  br i1 %bz.i418, label %ret_a.i485, label %calc_tot.i419

ret_a.i485:                                       ; preds = %chk_bz.i417
  %aw1_tag.i486 = and i64 %aw1.i411, 1
  %a_owned.i487 = icmp eq i64 %aw1_tag.i486, 0
  %long.i884 = icmp samesign ult i64 %alen.i414, 13
  %or.cond1139.not1153 = select i1 %a_owned.i487, i1 true, i1 %long.i884
  %tag.i888 = and i64 %aw1.i411, 3
  %owned.not.i889 = icmp eq i64 %tag.i888, 0
  %or.cond1140 = select i1 %or.cond1139.not1153, i1 true, i1 %owned.not.i889
  br i1 %or.cond1140, label %archx_str_concat.exit493, label %dup_heap.i890

dup_heap.i890:                                    ; preds = %ret_a.i485
  %dst.i891 = call noalias align 16 ptr @malloc(i64 %alen.i414)
  %isnull.i892 = icmp eq ptr %dst.i891, null
  br i1 %isnull.i892, label %oom.i899, label %copy.i893

oom.i899:                                         ; preds = %dup_heap.i890
  call fastcc void @archx_oom_fail()
  unreachable

copy.i893:                                        ; preds = %dup_heap.i890
  %src_i.i894 = and i64 %aw1.i411, -4
  %src.i895 = inttoptr i64 %src_i.i894 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i891, ptr nonnull align 4 %src.i895, i64 %alen.i414, i1 false)
  %dst_i.i896 = ptrtoint ptr %dst.i891 to i64
  %tagged.i897 = or disjoint i64 %dst_i.i896, 1
  %out.i898 = insertvalue %ArchxStr %common.ret.op.i382, i64 %tagged.i897, 1
  br label %archx_str_concat.exit493

calc_tot.i419:                                    ; preds = %chk_bz.i417
  %tot.i420 = add nuw nsw i64 %blen.i415, %alen.i414
  %too_big.i421 = icmp samesign ugt i64 %tot.i420, 2147483647
  br i1 %too_big.i421, label %oom.i467, label %mat_a.i422

oom.i467:                                         ; preds = %calc_tot.i419
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i422:                                       ; preds = %calc_tot.i419
  %ashort.i423 = icmp samesign ult i64 %alen.i414, 13
  br i1 %ashort.i423, label %mat_a_short.i481, label %mat_a_long.i424

mat_a_short.i481:                                 ; preds = %mat_a.i422
  %ap4.i482 = lshr i64 %aw0.i410, 32
  %ap4_32.i483 = trunc nuw i64 %ap4.i482 to i32
  store i32 %ap4_32.i483, ptr %atmp.i407, align 4
  %atmp4.i484 = getelementptr inbounds nuw i8, ptr %atmp.i407, i64 4
  store i64 %aw1.i411, ptr %atmp4.i484, align 4
  br label %mat_b.i427

mat_a_long.i424:                                  ; preds = %mat_a.i422
  %araw.i425 = and i64 %aw1.i411, -4
  %alptr.i426 = inttoptr i64 %araw.i425 to ptr
  br label %mat_b.i427

mat_b.i427:                                       ; preds = %mat_a_long.i424, %mat_a_short.i481
  %aptr.i428 = phi ptr [ %atmp.i407, %mat_a_short.i481 ], [ %alptr.i426, %mat_a_long.i424 ]
  %bshort.i429 = icmp samesign ult i64 %blen.i415, 13
  br i1 %bshort.i429, label %mat_b_short.i477, label %mat_b_long.i430

mat_b_short.i477:                                 ; preds = %mat_b.i427
  %bp4.i478 = lshr i64 %bw0.i412, 32
  %bp4_32.i479 = trunc nuw i64 %bp4.i478 to i32
  store i32 %bp4_32.i479, ptr %btmp.i408, align 4
  %btmp4.i480 = getelementptr inbounds nuw i8, ptr %btmp.i408, i64 4
  store i64 %bw1.i413, ptr %btmp4.i480, align 4
  br label %build.i433

mat_b_long.i430:                                  ; preds = %mat_b.i427
  %braw.i431 = and i64 %bw1.i413, -4
  %blptr.i432 = inttoptr i64 %braw.i431 to ptr
  br label %build.i433

build.i433:                                       ; preds = %mat_b_long.i430, %mat_b_short.i477
  %bptr.i434 = phi ptr [ %btmp.i408, %mat_b_short.i477 ], [ %blptr.i432, %mat_b_long.i430 ]
  %fits_sso.i435 = icmp samesign ult i64 %tot.i420, 13
  br i1 %fits_sso.i435, label %build_sso.i468, label %build_long.i436

build_sso.i468:                                   ; preds = %build.i433
  %out_sso8.i469 = getelementptr inbounds nuw i8, ptr %out_sso.i409, i64 8
  %tot32.i470 = trunc nuw nsw i64 %tot.i420 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i409, i8 0, i64 16, i1 false)
  store i32 %tot32.i470, ptr %out_sso.i409, align 8
  %sso_dst_a.i471 = getelementptr inbounds nuw i8, ptr %out_sso.i409, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i471, ptr nonnull align 1 %aptr.i428, i64 %alen.i414, i1 false)
  %sso_dst_b.i472 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i471, i64 %alen.i414
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i472, ptr nonnull align 1 %bptr.i434, i64 %blen.i415, i1 false)
  %rw0.i473 = load i64, ptr %out_sso.i409, align 8
  %rw1.i474 = load i64, ptr %out_sso8.i469, align 8
  %rs0.i475 = insertvalue %ArchxStr poison, i64 %rw0.i473, 0
  %rs1.i476 = insertvalue %ArchxStr %rs0.i475, i64 %rw1.i474, 1
  br label %archx_str_concat.exit493

build_long.i436:                                  ; preds = %build.i433
  %a1.i.i437 = add nuw nsw i64 %tot.i420, 15
  %aligned.i.i438 = and i64 %a1.i.i437, 4294967280
  %cur.i.i440 = load ptr, ptr %func.region, align 8
  %end.i.i441 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i442 = ptrtoint ptr %cur.i.i440 to i64
  %end_i.i.i443 = ptrtoint ptr %end.i.i441 to i64
  %rem.i.i444 = sub i64 %end_i.i.i443, %cur_i.i.i442
  %fits.not.i.i445 = icmp slt i64 %rem.i.i444, %aligned.i.i438
  br i1 %fits.not.i.i445, label %fallback.i.i460, label %fast.i.i446

fast.i.i446:                                      ; preds = %build_long.i436
  %next.i.i447 = getelementptr inbounds nuw i8, ptr %cur.i.i440, i64 %aligned.i.i438
  store ptr %next.i.i447, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i448

fallback.i.i460:                                  ; preds = %build_long.i436
  %res.i.i461 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i438)
  %.pre1248 = ptrtoint ptr %res.i.i461 to i64
  br label %archx_region_alloc.exit.i448

archx_region_alloc.exit.i448:                     ; preds = %fallback.i.i460, %fast.i.i446
  %rp_i.i450.pre-phi = phi i64 [ %.pre1248, %fallback.i.i460 ], [ %cur_i.i.i442, %fast.i.i446 ]
  %common.ret.op.i.i449 = phi ptr [ %res.i.i461, %fallback.i.i460 ], [ %cur.i.i440, %fast.i.i446 ]
  %rtagged.i451 = or disjoint i64 %rp_i.i450.pre-phi, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i449, ptr nonnull align 1 %aptr.i428, i64 %alen.i414, i1 false)
  %dst_b.i452 = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i449, i64 %alen.i414
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i452, ptr nonnull align 1 %bptr.i434, i64 %blen.i415, i1 false)
  %pref32.i453 = load i32, ptr %common.ret.op.i.i449, align 16
  %pref64.i454 = zext i32 %pref32.i453 to i64
  %pref_sh.i455 = shl nuw i64 %pref64.i454, 32
  %w0_out.i456 = or disjoint i64 %pref_sh.i455, %tot.i420
  %ls0.i457 = insertvalue %ArchxStr poison, i64 %w0_out.i456, 0
  %ls1.i458 = insertvalue %ArchxStr %ls0.i457, i64 %rtagged.i451, 1
  br label %archx_str_concat.exit493

archx_str_concat.exit493:                         ; preds = %copy.i893, %copy.i874, %ret_b.i489, %ret_a.i485, %build_sso.i468, %archx_region_alloc.exit.i448
  %common.ret.op.i459 = phi %ArchxStr [ %rs1.i476, %build_sso.i468 ], [ %ls1.i458, %archx_region_alloc.exit.i448 ], [ %common.ret.op.i1032, %ret_b.i489 ], [ %common.ret.op.i382, %ret_a.i485 ], [ %out.i879, %copy.i874 ], [ %out.i898, %copy.i893 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i407)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i408)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i409)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i494)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i496)
  %aw0.i497 = extractvalue %ArchxStr %common.ret.op.i459, 0
  %aw1.i498 = extractvalue %ArchxStr %common.ret.op.i459, 1
  %alen.i499 = and i64 %aw0.i497, 4294967295
  %az.i500 = icmp eq i64 %alen.i499, 0
  br i1 %az.i500, label %archx_str_concat.exit565, label %chk_bz.i501

chk_bz.i501:                                      ; preds = %archx_str_concat.exit493
  %tot.i503 = add nuw nsw i64 %alen.i499, 9
  %too_big.i504 = icmp samesign ugt i64 %alen.i499, 2147483638
  br i1 %too_big.i504, label %oom.i548, label %mat_a.i505

oom.i548:                                         ; preds = %chk_bz.i501
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i505:                                       ; preds = %chk_bz.i501
  %ashort.i506 = icmp samesign ult i64 %alen.i499, 13
  br i1 %ashort.i506, label %mat_b.i510, label %mat_b.i510.thread

mat_b.i510.thread:                                ; preds = %mat_a.i505
  %araw.i508 = and i64 %aw1.i498, -4
  %alptr.i509 = inttoptr i64 %araw.i508 to ptr
  br label %build_long.i517

mat_b.i510:                                       ; preds = %mat_a.i505
  %ap4.i559 = lshr i64 %aw0.i497, 32
  %ap4_32.i560 = trunc nuw i64 %ap4.i559 to i32
  store i32 %ap4_32.i560, ptr %atmp.i494, align 4
  %atmp4.i561 = getelementptr inbounds nuw i8, ptr %atmp.i494, i64 4
  store i64 %aw1.i498, ptr %atmp4.i561, align 4
  %fits_sso.i516 = icmp samesign ult i64 %alen.i499, 4
  br i1 %fits_sso.i516, label %build_sso.i549, label %build_long.i517

build_sso.i549:                                   ; preds = %mat_b.i510
  %out_sso8.i550 = getelementptr inbounds nuw i8, ptr %out_sso.i496, i64 8
  %tot32.i551 = trunc nuw nsw i64 %tot.i503 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i496, i8 0, i64 16, i1 false)
  store i32 %tot32.i551, ptr %out_sso.i496, align 8
  %sso_dst_a.i552 = getelementptr inbounds nuw i8, ptr %out_sso.i496, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i552, ptr nonnull align 4 %atmp.i494, i64 %alen.i499, i1 false)
  %sso_dst_b.i553 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i552, i64 %alen.i499
  store i32 1969365036, ptr %sso_dst_b.i553, align 1
  %btmp.i495.sroa.5.0.sso_dst_b.i553.sroa_idx = getelementptr inbounds nuw i8, ptr %sso_dst_b.i553, i64 4
  store i40 262801471846, ptr %btmp.i495.sroa.5.0.sso_dst_b.i553.sroa_idx, align 1
  %rw0.i554 = load i64, ptr %out_sso.i496, align 8
  %rw1.i555 = load i64, ptr %out_sso8.i550, align 8
  %rs0.i556 = insertvalue %ArchxStr poison, i64 %rw0.i554, 0
  %rs1.i557 = insertvalue %ArchxStr %rs0.i556, i64 %rw1.i555, 1
  br label %archx_str_concat.exit565

build_long.i517:                                  ; preds = %mat_b.i510.thread, %mat_b.i510
  %aptr.i5111127 = phi ptr [ %alptr.i509, %mat_b.i510.thread ], [ %atmp.i494, %mat_b.i510 ]
  %a1.i.i518 = add i64 %aw0.i497, 24
  %aligned.i.i519 = and i64 %a1.i.i518, 4294967280
  %cur.i.i521 = load ptr, ptr %func.region, align 8
  %end.i.i522 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i523 = ptrtoint ptr %cur.i.i521 to i64
  %end_i.i.i524 = ptrtoint ptr %end.i.i522 to i64
  %rem.i.i525 = sub i64 %end_i.i.i524, %cur_i.i.i523
  %fits.not.i.i526 = icmp slt i64 %rem.i.i525, %aligned.i.i519
  br i1 %fits.not.i.i526, label %fallback.i.i541, label %fast.i.i527

fast.i.i527:                                      ; preds = %build_long.i517
  %next.i.i528 = getelementptr inbounds nuw i8, ptr %cur.i.i521, i64 %aligned.i.i519
  store ptr %next.i.i528, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i529

fallback.i.i541:                                  ; preds = %build_long.i517
  %res.i.i542 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i519)
  %.pre1247 = ptrtoint ptr %res.i.i542 to i64
  br label %archx_region_alloc.exit.i529

archx_region_alloc.exit.i529:                     ; preds = %fallback.i.i541, %fast.i.i527
  %rp_i.i531.pre-phi = phi i64 [ %.pre1247, %fallback.i.i541 ], [ %cur_i.i.i523, %fast.i.i527 ]
  %common.ret.op.i.i530 = phi ptr [ %res.i.i542, %fallback.i.i541 ], [ %cur.i.i521, %fast.i.i527 ]
  %rtagged.i532 = or disjoint i64 %rp_i.i531.pre-phi, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i530, ptr nonnull align 1 %aptr.i5111127, i64 %alen.i499, i1 false)
  %dst_b.i533 = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i530, i64 %alen.i499
  store i32 1969365036, ptr %dst_b.i533, align 1
  %btmp.i495.sroa.5.0.dst_b.i533.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i533, i64 4
  store i40 262801471846, ptr %btmp.i495.sroa.5.0.dst_b.i533.sroa_idx, align 1
  %pref32.i534 = load i32, ptr %common.ret.op.i.i530, align 16
  %pref64.i535 = zext i32 %pref32.i534 to i64
  %pref_sh.i536 = shl nuw i64 %pref64.i535, 32
  %w0_out.i537 = or disjoint i64 %pref_sh.i536, %tot.i503
  %ls0.i538 = insertvalue %ArchxStr poison, i64 %w0_out.i537, 0
  %ls1.i539 = insertvalue %ArchxStr %ls0.i538, i64 %rtagged.i532, 1
  br label %archx_str_concat.exit565

archx_str_concat.exit565:                         ; preds = %archx_str_concat.exit493, %build_sso.i549, %archx_region_alloc.exit.i529
  %common.ret.op.i540 = phi %ArchxStr [ %rs1.i557, %build_sso.i549 ], [ %ls1.i539, %archx_region_alloc.exit.i529 ], [ { i64 8458358423505862665, i64 262801471846 }, %archx_str_concat.exit493 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i494)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i496)
  %t143 = load i64, ptr %t113.9, align 8
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i901)
  %n32.i902 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i901, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t143)
  %len.i903 = sext i32 %n32.i902 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i1050)
  %z.i1051 = icmp slt i32 %n32.i902, 1
  br i1 %z.i1051, label %archx_str_from_slice.exit1097, label %chk_sso.i1054

chk_sso.i1054:                                    ; preds = %archx_str_concat.exit565
  %short.i1055 = icmp samesign ult i32 %n32.i902, 13
  br i1 %short.i1055, label %pack_sso.i1089, label %build_long.i1056

pack_sso.i1089:                                   ; preds = %chk_sso.i1054
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i1050, i8 0, i64 16, i1 false)
  store i32 %n32.i902, ptr %sso.i1050, align 8
  %sso.i1050.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i1050, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i1050.4.sroa_idx, ptr nonnull readonly align 8 %buf.i901, i64 %len.i903, i1 false)
  %sso.i1050.0.sso.i1050.0.sso.i1050.0.sso.0.sso.0.sso.0.sw0.i1093 = load i64, ptr %sso.i1050, align 8
  %sso.i1050.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i1050, i64 8
  %sso.i1050.8.sso.i1050.8.sso.i1050.8.sso.8.sso.8.sso.8.sw1.i1094 = load i64, ptr %sso.i1050.8.sroa_idx, align 8
  %ss0.i1095 = insertvalue %ArchxStr poison, i64 %sso.i1050.0.sso.i1050.0.sso.i1050.0.sso.0.sso.0.sso.0.sw0.i1093, 0
  %ss1.i1096 = insertvalue %ArchxStr %ss0.i1095, i64 %sso.i1050.8.sso.i1050.8.sso.i1050.8.sso.8.sso.8.sso.8.sw1.i1094, 1
  br label %archx_str_from_slice.exit1097

build_long.i1056:                                 ; preds = %chk_sso.i1054
  %a1.i.i1057 = add nuw nsw i64 %len.i903, 15
  %aligned.i.i1058 = and i64 %a1.i.i1057, 4294967280
  %cur.i.i1060 = load ptr, ptr %func.region, align 8
  %end.i.i1061 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i1062 = ptrtoint ptr %cur.i.i1060 to i64
  %end_i.i.i1063 = ptrtoint ptr %end.i.i1061 to i64
  %rem.i.i1064 = sub i64 %end_i.i.i1063, %cur_i.i.i1062
  %fits.not.i.i1065 = icmp slt i64 %rem.i.i1064, %aligned.i.i1058
  br i1 %fits.not.i.i1065, label %fallback.i.i1080, label %fast.i.i1066

fast.i.i1066:                                     ; preds = %build_long.i1056
  %next.i.i1067 = getelementptr inbounds nuw i8, ptr %cur.i.i1060, i64 %aligned.i.i1058
  store ptr %next.i.i1067, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i1068

fallback.i.i1080:                                 ; preds = %build_long.i1056
  %res.i.i1081 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i1058)
  %.pre.i1082 = ptrtoint ptr %res.i.i1081 to i64
  br label %archx_region_alloc.exit.i1068

archx_region_alloc.exit.i1068:                    ; preds = %fallback.i.i1080, %fast.i.i1066
  %rp_i.pre-phi.i1069 = phi i64 [ %cur_i.i.i1062, %fast.i.i1066 ], [ %.pre.i1082, %fallback.i.i1080 ]
  %common.ret.op.i.i1070 = phi ptr [ %cur.i.i1060, %fast.i.i1066 ], [ %res.i.i1081, %fallback.i.i1080 ]
  %rtagged.i1071 = or disjoint i64 %rp_i.pre-phi.i1069, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i1070, ptr nonnull readonly align 8 %buf.i901, i64 %len.i903, i1 false)
  %pref32.i1073 = load i32, ptr %common.ret.op.i.i1070, align 16
  %pref64.i1074 = zext i32 %pref32.i1073 to i64
  %pref_sh.i1075 = shl nuw i64 %pref64.i1074, 32
  %w0_out.i1076 = or disjoint i64 %pref_sh.i1075, %len.i903
  %ls0.i1077 = insertvalue %ArchxStr poison, i64 %w0_out.i1076, 0
  %ls1.i1078 = insertvalue %ArchxStr %ls0.i1077, i64 %rtagged.i1071, 1
  br label %archx_str_from_slice.exit1097

archx_str_from_slice.exit1097:                    ; preds = %archx_str_concat.exit565, %pack_sso.i1089, %archx_region_alloc.exit.i1068
  %common.ret.op.i1079 = phi %ArchxStr [ %ss1.i1096, %pack_sso.i1089 ], [ %ls1.i1078, %archx_region_alloc.exit.i1068 ], [ zeroinitializer, %archx_str_concat.exit565 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i1050)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i901)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i566)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i567)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i568)
  %aw0.i569 = extractvalue %ArchxStr %common.ret.op.i540, 0
  %aw1.i570 = extractvalue %ArchxStr %common.ret.op.i540, 1
  %bw0.i571 = extractvalue %ArchxStr %common.ret.op.i1079, 0
  %bw1.i572 = extractvalue %ArchxStr %common.ret.op.i1079, 1
  %alen.i573 = and i64 %aw0.i569, 4294967295
  %blen.i574 = and i64 %bw0.i571, 4294967295
  %az.i575 = icmp eq i64 %alen.i573, 0
  br i1 %az.i575, label %ret_b.i649, label %chk_bz.i576

ret_b.i649:                                       ; preds = %archx_str_from_slice.exit1097
  %bw1_tag.i650 = and i64 %bw1.i572, 1
  %b_owned.i651 = icmp eq i64 %bw1_tag.i650, 0
  %long.i907 = icmp samesign ult i64 %blen.i574, 13
  %or.cond1141.not1156 = select i1 %b_owned.i651, i1 true, i1 %long.i907
  %tag.i911 = and i64 %bw1.i572, 3
  %owned.not.i912 = icmp eq i64 %tag.i911, 0
  %or.cond1142 = select i1 %or.cond1141.not1156, i1 true, i1 %owned.not.i912
  br i1 %or.cond1142, label %archx_str_concat.exit654, label %dup_heap.i913

dup_heap.i913:                                    ; preds = %ret_b.i649
  %dst.i914 = call noalias align 16 ptr @malloc(i64 %blen.i574)
  %isnull.i915 = icmp eq ptr %dst.i914, null
  br i1 %isnull.i915, label %oom.i922, label %copy.i916

oom.i922:                                         ; preds = %dup_heap.i913
  call fastcc void @archx_oom_fail()
  unreachable

copy.i916:                                        ; preds = %dup_heap.i913
  %src_i.i917 = and i64 %bw1.i572, -4
  %src.i918 = inttoptr i64 %src_i.i917 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i914, ptr nonnull align 4 %src.i918, i64 %blen.i574, i1 false)
  %dst_i.i919 = ptrtoint ptr %dst.i914 to i64
  %tagged.i920 = or disjoint i64 %dst_i.i919, 1
  %out.i921 = insertvalue %ArchxStr %common.ret.op.i1079, i64 %tagged.i920, 1
  br label %archx_str_concat.exit654

chk_bz.i576:                                      ; preds = %archx_str_from_slice.exit1097
  %bz.i577 = icmp eq i64 %blen.i574, 0
  br i1 %bz.i577, label %ret_a.i644, label %calc_tot.i578

ret_a.i644:                                       ; preds = %chk_bz.i576
  %aw1_tag.i645 = and i64 %aw1.i570, 1
  %a_owned.i646 = icmp eq i64 %aw1_tag.i645, 0
  %long.i926 = icmp samesign ult i64 %alen.i573, 13
  %or.cond1143.not1155 = select i1 %a_owned.i646, i1 true, i1 %long.i926
  %tag.i930 = and i64 %aw1.i570, 3
  %owned.not.i931 = icmp eq i64 %tag.i930, 0
  %or.cond1144 = select i1 %or.cond1143.not1155, i1 true, i1 %owned.not.i931
  br i1 %or.cond1144, label %archx_str_concat.exit654, label %dup_heap.i932

dup_heap.i932:                                    ; preds = %ret_a.i644
  %dst.i933 = call noalias align 16 ptr @malloc(i64 %alen.i573)
  %isnull.i934 = icmp eq ptr %dst.i933, null
  br i1 %isnull.i934, label %oom.i941, label %copy.i935

oom.i941:                                         ; preds = %dup_heap.i932
  call fastcc void @archx_oom_fail()
  unreachable

copy.i935:                                        ; preds = %dup_heap.i932
  %src_i.i936 = and i64 %aw1.i570, -4
  %src.i937 = inttoptr i64 %src_i.i936 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i933, ptr nonnull align 4 %src.i937, i64 %alen.i573, i1 false)
  %dst_i.i938 = ptrtoint ptr %dst.i933 to i64
  %tagged.i939 = or disjoint i64 %dst_i.i938, 1
  %out.i940 = insertvalue %ArchxStr %common.ret.op.i540, i64 %tagged.i939, 1
  br label %archx_str_concat.exit654

calc_tot.i578:                                    ; preds = %chk_bz.i576
  %tot.i579 = add nuw nsw i64 %blen.i574, %alen.i573
  %too_big.i580 = icmp samesign ugt i64 %tot.i579, 2147483647
  br i1 %too_big.i580, label %oom.i626, label %mat_a.i581

oom.i626:                                         ; preds = %calc_tot.i578
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i581:                                       ; preds = %calc_tot.i578
  %ashort.i582 = icmp samesign ult i64 %alen.i573, 13
  br i1 %ashort.i582, label %mat_a_short.i640, label %mat_a_long.i583

mat_a_short.i640:                                 ; preds = %mat_a.i581
  %ap4.i641 = lshr i64 %aw0.i569, 32
  %ap4_32.i642 = trunc nuw i64 %ap4.i641 to i32
  store i32 %ap4_32.i642, ptr %atmp.i566, align 4
  %atmp4.i643 = getelementptr inbounds nuw i8, ptr %atmp.i566, i64 4
  store i64 %aw1.i570, ptr %atmp4.i643, align 4
  br label %mat_b.i586

mat_a_long.i583:                                  ; preds = %mat_a.i581
  %araw.i584 = and i64 %aw1.i570, -4
  %alptr.i585 = inttoptr i64 %araw.i584 to ptr
  br label %mat_b.i586

mat_b.i586:                                       ; preds = %mat_a_long.i583, %mat_a_short.i640
  %aptr.i587 = phi ptr [ %atmp.i566, %mat_a_short.i640 ], [ %alptr.i585, %mat_a_long.i583 ]
  %bshort.i588 = icmp samesign ult i64 %blen.i574, 13
  br i1 %bshort.i588, label %mat_b_short.i636, label %mat_b_long.i589

mat_b_short.i636:                                 ; preds = %mat_b.i586
  %bp4.i637 = lshr i64 %bw0.i571, 32
  %bp4_32.i638 = trunc nuw i64 %bp4.i637 to i32
  store i32 %bp4_32.i638, ptr %btmp.i567, align 4
  %btmp4.i639 = getelementptr inbounds nuw i8, ptr %btmp.i567, i64 4
  store i64 %bw1.i572, ptr %btmp4.i639, align 4
  br label %build.i592

mat_b_long.i589:                                  ; preds = %mat_b.i586
  %braw.i590 = and i64 %bw1.i572, -4
  %blptr.i591 = inttoptr i64 %braw.i590 to ptr
  br label %build.i592

build.i592:                                       ; preds = %mat_b_long.i589, %mat_b_short.i636
  %bptr.i593 = phi ptr [ %btmp.i567, %mat_b_short.i636 ], [ %blptr.i591, %mat_b_long.i589 ]
  %fits_sso.i594 = icmp samesign ult i64 %tot.i579, 13
  br i1 %fits_sso.i594, label %build_sso.i627, label %build_long.i595

build_sso.i627:                                   ; preds = %build.i592
  %out_sso8.i628 = getelementptr inbounds nuw i8, ptr %out_sso.i568, i64 8
  %tot32.i629 = trunc nuw nsw i64 %tot.i579 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i568, i8 0, i64 16, i1 false)
  store i32 %tot32.i629, ptr %out_sso.i568, align 8
  %sso_dst_a.i630 = getelementptr inbounds nuw i8, ptr %out_sso.i568, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i630, ptr nonnull align 1 %aptr.i587, i64 %alen.i573, i1 false)
  %sso_dst_b.i631 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i630, i64 %alen.i573
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i631, ptr nonnull align 1 %bptr.i593, i64 %blen.i574, i1 false)
  %rw0.i632 = load i64, ptr %out_sso.i568, align 8
  %rw1.i633 = load i64, ptr %out_sso8.i628, align 8
  %rs0.i634 = insertvalue %ArchxStr poison, i64 %rw0.i632, 0
  %rs1.i635 = insertvalue %ArchxStr %rs0.i634, i64 %rw1.i633, 1
  br label %archx_str_concat.exit654

build_long.i595:                                  ; preds = %build.i592
  %a1.i.i596 = add nuw nsw i64 %tot.i579, 15
  %aligned.i.i597 = and i64 %a1.i.i596, 4294967280
  %cur.i.i599 = load ptr, ptr %func.region, align 8
  %end.i.i600 = load ptr, ptr %.fca.1.gep, align 8
  %cur_i.i.i601 = ptrtoint ptr %cur.i.i599 to i64
  %end_i.i.i602 = ptrtoint ptr %end.i.i600 to i64
  %rem.i.i603 = sub i64 %end_i.i.i602, %cur_i.i.i601
  %fits.not.i.i604 = icmp slt i64 %rem.i.i603, %aligned.i.i597
  br i1 %fits.not.i.i604, label %fallback.i.i619, label %fast.i.i605

fast.i.i605:                                      ; preds = %build_long.i595
  %next.i.i606 = getelementptr inbounds nuw i8, ptr %cur.i.i599, i64 %aligned.i.i597
  store ptr %next.i.i606, ptr %func.region, align 8
  br label %archx_region_alloc.exit.i607

fallback.i.i619:                                  ; preds = %build_long.i595
  %res.i.i620 = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region, i64 %aligned.i.i597)
  %.pre = ptrtoint ptr %res.i.i620 to i64
  br label %archx_region_alloc.exit.i607

archx_region_alloc.exit.i607:                     ; preds = %fallback.i.i619, %fast.i.i605
  %rp_i.i609.pre-phi = phi i64 [ %.pre, %fallback.i.i619 ], [ %cur_i.i.i601, %fast.i.i605 ]
  %common.ret.op.i.i608 = phi ptr [ %res.i.i620, %fallback.i.i619 ], [ %cur.i.i599, %fast.i.i605 ]
  %rtagged.i610 = or disjoint i64 %rp_i.i609.pre-phi, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i.i608, ptr nonnull align 1 %aptr.i587, i64 %alen.i573, i1 false)
  %dst_b.i611 = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i608, i64 %alen.i573
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i611, ptr nonnull align 1 %bptr.i593, i64 %blen.i574, i1 false)
  %pref32.i612 = load i32, ptr %common.ret.op.i.i608, align 16
  %pref64.i613 = zext i32 %pref32.i612 to i64
  %pref_sh.i614 = shl nuw i64 %pref64.i613, 32
  %w0_out.i615 = or disjoint i64 %pref_sh.i614, %tot.i579
  %ls0.i616 = insertvalue %ArchxStr poison, i64 %w0_out.i615, 0
  %ls1.i617 = insertvalue %ArchxStr %ls0.i616, i64 %rtagged.i610, 1
  br label %archx_str_concat.exit654

archx_str_concat.exit654:                         ; preds = %copy.i935, %copy.i916, %ret_b.i649, %ret_a.i644, %build_sso.i627, %archx_region_alloc.exit.i607
  %common.ret.op.i618 = phi %ArchxStr [ %rs1.i635, %build_sso.i627 ], [ %ls1.i617, %archx_region_alloc.exit.i607 ], [ %common.ret.op.i1079, %ret_b.i649 ], [ %common.ret.op.i540, %ret_a.i644 ], [ %out.i921, %copy.i916 ], [ %out.i940, %copy.i935 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i566)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i567)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i568)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i943)
  %w0.i944 = extractvalue %ArchxStr %common.ret.op.i618, 0
  %w1.i945 = extractvalue %ArchxStr %common.ret.op.i618, 1
  %len.i946 = and i64 %w0.i944, 4294967295
  %short.i947 = icmp samesign ult i64 %len.i946, 13
  br i1 %short.i947, label %emit.i968, label %emit.thread.i948

emit.thread.i948:                                 ; preds = %archx_str_concat.exit654
  %raw.i949 = and i64 %w1.i945, -4
  %lptr.i950 = inttoptr i64 %raw.i949 to ptr
  br label %chk_nul.i951

emit.i968:                                        ; preds = %archx_str_concat.exit654
  %p4.i969 = lshr i64 %w0.i944, 32
  %p4_32.i970 = trunc nuw i64 %p4.i969 to i32
  store i32 %p4_32.i970, ptr %tmp.i943, align 4
  %tmp4.i971 = getelementptr inbounds nuw i8, ptr %tmp.i943, i64 4
  store i64 %w1.i945, ptr %tmp4.i971, align 4
  %pos.not.i972 = icmp eq i64 %len.i946, 0
  br i1 %pos.not.i972, label %chk_nl.i963, label %chk_nul.i951

chk_nul.i951:                                     ; preds = %emit.i968, %emit.thread.i948
  %data3.i952 = phi ptr [ %lptr.i950, %emit.thread.i948 ], [ %tmp.i943, %emit.i968 ]
  %nul.i953 = call ptr @memchr(ptr nonnull %data3.i952, i32 0, i64 %len.i946)
  %has_nul.not.i954 = icmp eq ptr %nul.i953, null
  br i1 %has_nul.not.i954, label %fast_printf.i965, label %byte_loop.i955

fast_printf.i965:                                 ; preds = %chk_nul.i951
  %len32.i966 = trunc i64 %w0.i944 to i32
  %np.i967 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i966, ptr nonnull %data3.i952)
  br label %archx_str_print.exit973

byte_loop.i955:                                   ; preds = %chk_nul.i951, %byte_loop.i955
  %bi.i956 = phi i64 [ %bnext.i961, %byte_loop.i955 ], [ 0, %chk_nul.i951 ]
  %bp.i957 = getelementptr inbounds nuw i8, ptr %data3.i952, i64 %bi.i956
  %ch8.i958 = load i8, ptr %bp.i957, align 1
  %ch32.i959 = zext i8 %ch8.i958 to i32
  %pc.i960 = call i32 @putchar(i32 %ch32.i959)
  %bnext.i961 = add nuw nsw i64 %bi.i956, 1
  %exitcond.not.i962 = icmp eq i64 %bnext.i961, %len.i946
  br i1 %exitcond.not.i962, label %chk_nl.i963, label %byte_loop.i955

chk_nl.i963:                                      ; preds = %byte_loop.i955, %emit.i968
  %nc.i964 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit973

archx_str_print.exit973:                          ; preds = %fast_printf.i965, %chk_nl.i963
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i943)
  %tag.i94 = and i64 %w1.i945, 1
  %owned.not.i95 = icmp eq i64 %tag.i94, 0
  %or.cond1145 = select i1 %short.i947, i1 true, i1 %owned.not.i95
  br i1 %or.cond1145, label %archx_str_drop.exit99, label %do_free.i96

do_free.i96:                                      ; preds = %archx_str_print.exit973
  %raw.i97 = and i64 %w1.i945, -2
  %ptr.i98 = inttoptr i64 %raw.i97 to ptr
  call void @free(ptr %ptr.i98)
  br label %archx_str_drop.exit99

archx_str_drop.exit99:                            ; preds = %archx_str_print.exit973, %do_free.i96
  %long.i102 = icmp samesign ult i64 %blen.i574, 13
  %tag.i105 = and i64 %bw1.i572, 1
  %owned.not.i106 = icmp eq i64 %tag.i105, 0
  %or.cond1146 = select i1 %long.i102, i1 true, i1 %owned.not.i106
  br i1 %or.cond1146, label %archx_str_drop.exit110, label %do_free.i107

do_free.i107:                                     ; preds = %archx_str_drop.exit99
  %raw.i108 = and i64 %bw1.i572, -2
  %ptr.i109 = inttoptr i64 %raw.i108 to ptr
  call void @free(ptr %ptr.i109)
  br label %archx_str_drop.exit110

archx_str_drop.exit110:                           ; preds = %archx_str_drop.exit99, %do_free.i107
  %long.i113 = icmp samesign ult i64 %alen.i573, 13
  %tag.i116 = and i64 %aw1.i570, 1
  %owned.not.i117 = icmp eq i64 %tag.i116, 0
  %or.cond1147 = select i1 %long.i113, i1 true, i1 %owned.not.i117
  br i1 %or.cond1147, label %archx_str_drop.exit121, label %do_free.i118

do_free.i118:                                     ; preds = %archx_str_drop.exit110
  %raw.i119 = and i64 %aw1.i570, -2
  %ptr.i120 = inttoptr i64 %raw.i119 to ptr
  call void @free(ptr %ptr.i120)
  br label %archx_str_drop.exit121

archx_str_drop.exit121:                           ; preds = %archx_str_drop.exit110, %do_free.i118
  %long.i124 = icmp samesign ult i64 %alen.i499, 13
  %tag.i127 = and i64 %aw1.i498, 1
  %owned.not.i128 = icmp eq i64 %tag.i127, 0
  %or.cond1148 = select i1 %long.i124, i1 true, i1 %owned.not.i128
  br i1 %or.cond1148, label %archx_str_drop.exit132, label %do_free.i129

do_free.i129:                                     ; preds = %archx_str_drop.exit121
  %raw.i130 = and i64 %aw1.i498, -2
  %ptr.i131 = inttoptr i64 %raw.i130 to ptr
  call void @free(ptr %ptr.i131)
  br label %archx_str_drop.exit132

archx_str_drop.exit132:                           ; preds = %archx_str_drop.exit121, %do_free.i129
  %long.i135 = icmp samesign ult i64 %blen.i415, 13
  %tag.i138 = and i64 %bw1.i413, 1
  %owned.not.i139 = icmp eq i64 %tag.i138, 0
  %or.cond1149 = select i1 %long.i135, i1 true, i1 %owned.not.i139
  br i1 %or.cond1149, label %archx_str_drop.exit143, label %do_free.i140

do_free.i140:                                     ; preds = %archx_str_drop.exit132
  %raw.i141 = and i64 %bw1.i413, -2
  %ptr.i142 = inttoptr i64 %raw.i141 to ptr
  call void @free(ptr %ptr.i142)
  br label %archx_str_drop.exit143

archx_str_drop.exit143:                           ; preds = %archx_str_drop.exit132, %do_free.i140
  %long.i146 = icmp samesign ult i64 %alen.i414, 13
  %tag.i149 = and i64 %aw1.i411, 1
  %owned.not.i150 = icmp eq i64 %tag.i149, 0
  %or.cond1150 = select i1 %long.i146, i1 true, i1 %owned.not.i150
  br i1 %or.cond1150, label %archx_str_drop.exit154, label %do_free.i151

do_free.i151:                                     ; preds = %archx_str_drop.exit143
  %raw.i152 = and i64 %aw1.i411, -2
  %ptr.i153 = inttoptr i64 %raw.i152 to ptr
  call void @free(ptr %ptr.i153)
  br label %archx_str_drop.exit154

archx_str_drop.exit154:                           ; preds = %archx_str_drop.exit143, %do_free.i151
  %long.i157 = icmp samesign ult i64 %alen.i341, 13
  %tag.i160 = and i64 %aw1.i340, 1
  %owned.not.i161 = icmp eq i64 %tag.i160, 0
  %or.cond1151 = select i1 %long.i157, i1 true, i1 %owned.not.i161
  br i1 %or.cond1151, label %archx_str_drop.exit165, label %do_free.i162

do_free.i162:                                     ; preds = %archx_str_drop.exit154
  %raw.i163 = and i64 %aw1.i340, -2
  %ptr.i164 = inttoptr i64 %raw.i163 to ptr
  call void @free(ptr %ptr.i164)
  br label %archx_str_drop.exit165

archx_str_drop.exit165:                           ; preds = %archx_str_drop.exit154, %do_free.i162
  %long.i168 = icmp samesign ult i64 %blen.i287, 13
  %tag.i171 = and i64 %newret1286, 1
  %owned.not.i172 = icmp eq i64 %tag.i171, 0
  %or.cond1152 = select i1 %long.i168, i1 true, i1 %owned.not.i172
  br i1 %or.cond1152, label %archx_str_drop.exit176, label %do_free.i173

do_free.i173:                                     ; preds = %archx_str_drop.exit165
  %raw.i174 = and i64 %newret1286, -2
  %ptr.i175 = inttoptr i64 %raw.i174 to ptr
  call void @free(ptr %ptr.i175)
  br label %archx_str_drop.exit176

archx_str_drop.exit176:                           ; preds = %archx_str_drop.exit165, %do_free.i173
  %head.i = load ptr, ptr %.fca.2.gep, align 8
  %empty.i = icmp eq ptr %head.i, null
  br i1 %empty.i, label %archx_region_rewind_root.exit, label %rewind.i

rewind.i:                                         ; preds = %archx_str_drop.exit176
  %cap_ptr.i = getelementptr inbounds nuw i8, ptr %head.i, i64 8
  %cap.i = load i64, ptr %cap_ptr.i, align 8
  %data.i = getelementptr inbounds nuw i8, ptr %head.i, i64 16
  %end.i = getelementptr inbounds i8, ptr %data.i, i64 %cap.i
  store ptr %data.i, ptr %func.region, align 8
  store ptr %end.i, ptr %.fca.1.gep, align 8
  store ptr %head.i, ptr %.fca.3.gep, align 8
  br label %archx_region_rewind_root.exit

archx_region_rewind_root.exit:                    ; preds = %archx_str_drop.exit176, %rewind.i
  %has_elems.i = icmp sgt i64 %vlen.ph.lcssa7.i1261, 0
  br i1 %has_elems.i, label %loop.i977, label %check.free.i

loop.i977:                                        ; preds = %archx_region_rewind_root.exit, %archx_str_drop.exit.i
  %i.i978 = phi i64 [ %inext.i980, %archx_str_drop.exit.i ], [ 0, %archx_region_rewind_root.exit ]
  %ep.i979 = getelementptr inbounds nuw %ArchxStr, ptr %vptr.ph.lcssa9.i1260, i64 %i.i978
  %t0.unpack.i = load i64, ptr %ep.i979, align 8
  %t0.elt1.i = getelementptr inbounds nuw i8, ptr %ep.i979, i64 8
  %t0.unpack2.i = load i64, ptr %t0.elt1.i, align 8
  %len.i.i = and i64 %t0.unpack.i, 4294967295
  %long.i.i = icmp samesign ult i64 %len.i.i, 13
  %tag.i.i = and i64 %t0.unpack2.i, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond.i = select i1 %long.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond.i, label %archx_str_drop.exit.i, label %do_free.i.i

do_free.i.i:                                      ; preds = %loop.i977
  %raw.i.i = and i64 %t0.unpack2.i, -2
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  call void @free(ptr %ptr.i.i)
  br label %archx_str_drop.exit.i

archx_str_drop.exit.i:                            ; preds = %do_free.i.i, %loop.i977
  %inext.i980 = add nuw nsw i64 %i.i978, 1
  %exitcond.not.i981 = icmp eq i64 %inext.i980, %vlen.ph.lcssa7.i1261
  br i1 %exitcond.not.i981, label %check.free.i, label %loop.i977

check.free.i:                                     ; preds = %archx_str_drop.exit.i, %archx_region_rewind_root.exit
  %is_heap.i = icmp sgt i64 %vcap.ph.lcssa5.i1262, 0
  br i1 %is_heap.i, label %do.free.i, label %archx_vec_drop_s.exit

do.free.i:                                        ; preds = %check.free.i
  call void @free(ptr nonnull %vptr.ph.lcssa9.i1260)
  br label %archx_vec_drop_s.exit

archx_vec_drop_s.exit:                            ; preds = %check.free.i, %do.free.i
  %t149 = icmp sgt i64 %var.samples.7.sroa.9.1, 0
  br i1 %t149, label %drop.vec.free.37, label %drop.vec.done.38

drop.vec.free.37:                                 ; preds = %archx_vec_drop_s.exit
  call void @free(ptr %var.samples.7.sroa.18.1)
  br label %drop.vec.done.38

drop.vec.done.38:                                 ; preds = %drop.vec.free.37, %archx_vec_drop_s.exit
  %t152 = load ptr, ptr %.fca.2.gep, align 8
  %empty.i982 = icmp eq ptr %t152, null
  br i1 %empty.i982, label %archx_region_release_from.exit, label %loop.i983

loop.i983:                                        ; preds = %drop.vec.done.38, %loop.i983
  %cur.i984 = phi ptr [ %next.i985, %loop.i983 ], [ %t152, %drop.vec.done.38 ]
  %next.i985 = load ptr, ptr %cur.i984, align 8
  call void @free(ptr nonnull %cur.i984)
  %more.not.i = icmp eq ptr %next.i985, null
  br i1 %more.not.i, label %archx_region_release_from.exit, label %loop.i983

archx_region_release_from.exit:                   ; preds = %loop.i983, %drop.vec.done.38
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
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.1)
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
  %n15.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf, ptr nonnull dereferenceable(1) @.fmt.g15, double %x)
  %back15.i = call double @strtod(ptr nonnull captures(none) %buf, ptr null)
  %eq15.i = fcmp oeq double %back15.i, %x
  br i1 %eq15.i, label %done.i, label %try16.i

try16.i:                                          ; preds = %entry
  %n16.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf, ptr nonnull dereferenceable(1) @.fmt.g16, double %x)
  %back16.i = call double @strtod(ptr nonnull captures(none) %buf, ptr null)
  %eq16.i = fcmp oeq double %back16.i, %x
  br i1 %eq16.i, label %done.i, label %try17.i

try17.i:                                          ; preds = %try16.i
  %n17.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf, ptr nonnull dereferenceable(1) @.fmt.g17, double %x)
  br label %done.i

done.i:                                           ; preds = %try17.i, %try16.i, %entry
  %n32.i = phi i32 [ %n15.i, %entry ], [ %n16.i, %try16.i ], [ %n17.i, %try17.i ]
  %n.i = sext i32 %n32.i to i64
  %pos.i = icmp sgt i32 %n32.i, 0
  br i1 %pos.i, label %scan.i, label %archx_fmt_float_buf.exit

scan.i:                                           ; preds = %done.i, %scan_step.i
  %i.i = phi i64 [ %inext.i, %scan_step.i ], [ 0, %done.i ]
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

archx_fmt_float_buf.exit:                         ; preds = %scan.i, %scan.i, %scan.i, %scan.i, %scan.i, %scan.i, %scan.i, %done.i, %append_dot0.i
  %common.ret.op.i = phi i64 [ %n2.i, %append_dot0.i ], [ %n.i, %done.i ], [ %n.i, %scan.i ], [ %n.i, %scan.i ], [ %n.i, %scan.i ], [ %n.i, %scan.i ], [ %n.i, %scan.i ], [ %n.i, %scan.i ], [ %n.i, %scan.i ]
  %s = call fastcc { i64, i64 } @archx_str_from_slice(ptr nonnull %buf, i64 %common.ret.op.i, ptr %reg)
  ret { i64, i64 } %s
}

; Function Attrs: nofree nounwind
declare noundef i32 @sprintf(ptr noalias noundef writeonly captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nounwind willreturn
declare double @strtod(ptr readonly captures(none), ptr writeonly captures(none)) local_unnamed_addr #11

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.abs.i64(i64, i1 immarg) #12

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smin.i64(i64, i64) #12

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #12

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
attributes #6 = { mustprogress nounwind willreturn allockind("realloc") allocsize(1) memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #7 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #8 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #9 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #10 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #11 = { mustprogress nocallback nofree nounwind willreturn }
attributes #12 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #13 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.peeled.count", i32 1}
!4 = distinct !{!4, !5, !6}
!5 = !{!"llvm.loop.isvectorized", i32 1}
!6 = !{!"llvm.loop.unroll.runtime.disable"}
!7 = distinct !{!7, !5, !6}
!8 = distinct !{!8, !6, !5}
