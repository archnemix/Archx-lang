; ModuleID = 'ci/out/enums_matching.ll'
source_filename = "enums_matching.archx.lang"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxStr = type { i64, i64 }
%ArchxEnum_Shape = type { i64, [4 x i64] }

@.fmt.g15 = private unnamed_addr constant [6 x i8] c"%.15g\00", align 1
@.fmt.g16 = private unnamed_addr constant [6 x i8] c"%.16g\00", align 1
@.fmt.g17 = private unnamed_addr constant [6 x i8] c"%.17g\00", align 1
@.str.0 = private unnamed_addr constant [14 x i8] c"large-circle:\00", align 4
@.str.1 = private unnamed_addr constant [39 x i8] c"long_region_allocated_shape_identifier\00", align 4
@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@.err.bounds = private unnamed_addr constant [63 x i8] c"archx runtime panic: index %lld out of bounds for length %lld\0A\00", align 1
@.fmt.i64s = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@str.1 = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %tmp.i1913 = alloca [12 x i8], align 4
  %sso.i.i620.i = alloca [16 x i8], align 8
  %buf.i621.i = alloca [32 x i8], align 8
  %sso.i.i.i = alloca [16 x i8], align 8
  %buf.i.i = alloca [32 x i8], align 8
  %atmp.i453.i = alloca [12 x i8], align 4
  %btmp.i454.i = alloca [12 x i8], align 4
  %out_sso.i455.i = alloca [16 x i8], align 8
  %atmp.i399.i = alloca [12 x i8], align 4
  %out_sso.i401.i = alloca [16 x i8], align 8
  %atmp.i333.i = alloca [12 x i8], align 4
  %btmp.i334.i = alloca [12 x i8], align 4
  %out_sso.i335.i = alloca [16 x i8], align 8
  %atmp.i295.i = alloca [12 x i8], align 4
  %out_sso.i297.i = alloca [16 x i8], align 8
  %btmp.i246.i = alloca [12 x i8], align 4
  %out_sso.i247.sroa.6.sroa.5.sroa.0.i = alloca i56, align 8
  %btmp.i196.i = alloca [12 x i8], align 4
  %out_sso.i197.sroa.6.sroa.5.sroa.0.i = alloca i40, align 8
  %btmp.i159.i = alloca [12 x i8], align 4
  %out_sso.i.sroa.6.sroa.5.sroa.0.i = alloca i40, align 8
  %btmp.i.i = alloca [12 x i8], align 4
  %tmp.i1842 = alloca [12 x i8], align 4
  %sso.i.i1812 = alloca [16 x i8], align 8
  %buf.i1813 = alloca [32 x i8], align 8
  %tmp.i1781 = alloca [12 x i8], align 4
  %sso.i.i1714 = alloca [16 x i8], align 8
  %buf.i1715 = alloca [32 x i8], align 8
  %sso.i.i1683 = alloca [16 x i8], align 8
  %buf.i1684 = alloca [32 x i8], align 8
  %tmp.i1628 = alloca [12 x i8], align 4
  %sso.i.i1561 = alloca [16 x i8], align 8
  %buf.i1562 = alloca [32 x i8], align 8
  %sso.i.i1489 = alloca [16 x i8], align 8
  %buf.i1490 = alloca [32 x i8], align 8
  %sso.i.i1458 = alloca [16 x i8], align 8
  %buf.i1459 = alloca [32 x i8], align 8
  %tmp.i = alloca [12 x i8], align 4
  %sso.i.i1387 = alloca [16 x i8], align 8
  %buf.i1388 = alloca [32 x i8], align 8
  %sso.i.i1329 = alloca [16 x i8], align 8
  %buf.i1330 = alloca [32 x i8], align 8
  %sso.i.i = alloca [16 x i8], align 8
  %buf.i = alloca [32 x i8], align 8
  %btmp.i1273 = alloca [12 x i8], align 4
  %out_sso.i1274.sroa.6.sroa.5 = alloca i32, align 4
  %atmp.i1206 = alloca [12 x i8], align 4
  %btmp.i1207 = alloca [12 x i8], align 4
  %out_sso.i1208 = alloca [16 x i8], align 8
  %atmp.i1152 = alloca [12 x i8], align 4
  %out_sso.i1154 = alloca [16 x i8], align 8
  %btmp.i1099 = alloca [12 x i8], align 4
  %out_sso.i1100.sroa.6.sroa.5.sroa.0 = alloca i48, align 8
  %atmp.i1032 = alloca [12 x i8], align 4
  %btmp.i1033 = alloca [12 x i8], align 4
  %out_sso.i1034 = alloca [16 x i8], align 8
  %atmp.i978 = alloca [12 x i8], align 4
  %out_sso.i980 = alloca [16 x i8], align 8
  %atmp.i924 = alloca [12 x i8], align 4
  %out_sso.i926 = alloca [16 x i8], align 8
  %atmp.i870 = alloca [12 x i8], align 4
  %out_sso.i872 = alloca [16 x i8], align 8
  %atmp.i816 = alloca [12 x i8], align 4
  %out_sso.i818 = alloca [16 x i8], align 8
  %atmp.i762 = alloca [12 x i8], align 4
  %out_sso.i764 = alloca [16 x i8], align 8
  %atmp.i696 = alloca [12 x i8], align 4
  %btmp.i697 = alloca [12 x i8], align 4
  %out_sso.i698 = alloca [16 x i8], align 8
  %atmp.i642 = alloca [12 x i8], align 4
  %out_sso.i644 = alloca [16 x i8], align 8
  %btmp.i589 = alloca [12 x i8], align 4
  %out_sso.i590.sroa.6.sroa.5.sroa.0 = alloca i56, align 8
  %atmp.i522 = alloca [12 x i8], align 4
  %btmp.i523 = alloca [12 x i8], align 4
  %out_sso.i524 = alloca [16 x i8], align 8
  %atmp.i468 = alloca [12 x i8], align 4
  %out_sso.i470 = alloca [16 x i8], align 8
  %atmp.i402 = alloca [12 x i8], align 4
  %btmp.i403 = alloca [12 x i8], align 4
  %out_sso.i404 = alloca [16 x i8], align 8
  %atmp.i364 = alloca [12 x i8], align 4
  %out_sso.i366 = alloca [16 x i8], align 8
  %btmp.i = alloca [12 x i8], align 4
  %out_sso.i.sroa.6.sroa.5.sroa.0 = alloca i48, align 8
  %t0 = tail call noalias align 16 dereferenceable_or_null(40) ptr @malloc(i64 40)
  %t1 = icmp eq ptr %t0, null
  br i1 %t1, label %alloc.oom.1, label %archx_fn_min_max_sum.exit

alloc.oom.1:                                      ; preds = %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

archx_fn_min_max_sum.exit:                        ; preds = %entry
  store i64 12, ptr %t0, align 16
  %t3 = getelementptr inbounds nuw i8, ptr %t0, i64 8
  store i64 5, ptr %t3, align 8
  %t4 = getelementptr inbounds nuw i8, ptr %t0, i64 16
  store i64 42, ptr %t4, align 16
  %t5 = getelementptr inbounds nuw i8, ptr %t0, i64 24
  store i64 19, ptr %t5, align 8
  %t6 = getelementptr inbounds nuw i8, ptr %t0, i64 32
  store i64 8, ptr %t6, align 16
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i)
  %n32.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 5)
  %len.i1326 = sext i32 %n32.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i)
  %z.i.i = icmp slt i32 %n32.i, 1
  br i1 %z.i.i, label %archx_str_from_int.exit, label %chk_sso.i.i

oom.i.i:                                          ; preds = %alloc_heap.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i:                                      ; preds = %archx_fn_min_max_sum.exit
  %short.i.i = icmp samesign ult i32 %n32.i, 13
  br i1 %short.i.i, label %pack_sso.i.i, label %alloc_heap.i.i

pack_sso.i.i:                                     ; preds = %chk_sso.i.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i, i8 0, i64 16, i1 false)
  store i32 %n32.i, ptr %sso.i.i, align 8
  %sso.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, 2147483650) %len.i1326, i1 false)
  %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i = load i64, ptr %sso.i.i, align 8
  %sso.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 8
  %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i = load i64, ptr %sso.i.i.8.sroa_idx, align 8
  %ss0.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i, 0
  %ss1.i.i = insertvalue %ArchxStr %ss0.i.i, i64 %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i, 1
  br label %archx_str_from_int.exit

alloc_heap.i.i:                                   ; preds = %chk_sso.i.i
  %hp.i.i = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1326)
  %hnull.i.i = icmp eq ptr %hp.i.i, null
  br i1 %hnull.i.i, label %oom.i.i, label %copy_long.i.i

copy_long.i.i:                                    ; preds = %alloc_heap.i.i
  %hp_i.i.i = ptrtoint ptr %hp.i.i to i64
  %htagged.i.i = or disjoint i64 %hp_i.i.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, 2147483650) %len.i1326, i1 false)
  %pref32.i.i = load i32, ptr %hp.i.i, align 16
  %pref64.i.i = zext i32 %pref32.i.i to i64
  %pref_sh.i.i = shl nuw i64 %pref64.i.i, 32
  %w0_out.i.i = or disjoint i64 %pref_sh.i.i, %len.i1326
  %ls0.i.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i, 0
  %ls1.i.i = insertvalue %ArchxStr %ls0.i.i, i64 %htagged.i.i, 1
  br label %archx_str_from_int.exit

archx_str_from_int.exit:                          ; preds = %archx_fn_min_max_sum.exit, %pack_sso.i.i, %copy_long.i.i
  %common.ret.op.i.i = phi %ArchxStr [ %ss1.i.i, %pack_sso.i.i ], [ %ls1.i.i, %copy_long.i.i ], [ zeroinitializer, %archx_fn_min_max_sum.exit ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i)
  %bw0.i = extractvalue %ArchxStr %common.ret.op.i.i, 0
  %bw1.i = extractvalue %ArchxStr %common.ret.op.i.i, 1
  %blen.i = and i64 %bw0.i, 4294967295
  %bz.i = icmp eq i64 %blen.i, 0
  br i1 %bz.i, label %archx_str_concat.exit, label %calc_tot.i

calc_tot.i:                                       ; preds = %archx_str_from_int.exit
  %tot.i = add nuw nsw i64 %blen.i, 6
  %too_big.i = icmp samesign ugt i64 %blen.i, 2147483641
  br i1 %too_big.i, label %oom.i, label %mat_a.i

oom.i:                                            ; preds = %alloc_heap.i, %calc_tot.i
  tail call fastcc void @archx_oom_fail()
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
  %fits_sso.i = icmp samesign ult i64 %blen.i, 7
  br i1 %fits_sso.i, label %build_sso.i, label %alloc_heap.i

build_sso.i:                                      ; preds = %build.i
  store i48 0, ptr %out_sso.i.sroa.6.sroa.5.sroa.0, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i.sroa.6.sroa.5.sroa.0, ptr nonnull align 4 %btmp.i, i64 %blen.i, i1 false)
  %out_sso.i.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i, 8386112018410635264
  %out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.8.rw1.i = load i48, ptr %out_sso.i.sroa.6.sroa.5.sroa.0, align 8
  %out_sso.i.sroa.6.sroa.5.0.insert.ext = zext i48 %out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.8.rw1.i to i64
  %out_sso.i.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i.sroa.6.sroa.5.0.insert.ext, 16
  %out_sso.i.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i.sroa.6.sroa.5.0.insert.shift, 15731
  %rs0.i = insertvalue %ArchxStr poison, i64 %out_sso.i.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i = insertvalue %ArchxStr %rs0.i, i64 %out_sso.i.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit

alloc_heap.i:                                     ; preds = %build.i.thread, %build.i
  %bptr.i2205 = phi ptr [ %blptr.i, %build.i.thread ], [ %btmp.i, %build.i ]
  %hp.i = tail call noalias align 16 ptr @malloc(i64 %tot.i)
  %hnull.i = icmp eq ptr %hp.i, null
  br i1 %hnull.i, label %oom.i, label %copy_long.i

copy_long.i:                                      ; preds = %alloc_heap.i
  %hp_i.i = ptrtoint ptr %hp.i to i64
  %htagged.i = or disjoint i64 %hp_i.i, 1
  store i32 1952543859, ptr %hp.i, align 16
  %atmp.i.sroa.5.0.hp.i.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i, i64 4
  store i16 15731, ptr %atmp.i.sroa.5.0.hp.i.sroa_idx, align 4
  %dst_b.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 6
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 2 %dst_b.i, ptr nonnull align 1 %bptr.i2205, i64 %blen.i, i1 false)
  %w0_out.i = or disjoint i64 %tot.i, 8386112018410635264
  %ls0.i = insertvalue %ArchxStr poison, i64 %w0_out.i, 0
  %ls1.i = insertvalue %ArchxStr %ls0.i, i64 %htagged.i, 1
  br label %archx_str_concat.exit

archx_str_concat.exit:                            ; preds = %archx_str_from_int.exit, %build_sso.i, %copy_long.i
  %common.ret.op.i = phi %ArchxStr [ %rs1.i, %build_sso.i ], [ %ls1.i, %copy_long.i ], [ { i64 8386112018410635270, i64 15731 }, %archx_str_from_int.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i364)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i366)
  %aw0.i = extractvalue %ArchxStr %common.ret.op.i, 0
  %aw1.i = extractvalue %ArchxStr %common.ret.op.i, 1
  %alen.i = and i64 %aw0.i, 4294967295
  %az.i = icmp eq i64 %alen.i, 0
  br i1 %az.i, label %archx_str_concat.exit401, label %chk_bz.i

chk_bz.i:                                         ; preds = %archx_str_concat.exit
  %tot.i368 = add nuw nsw i64 %alen.i, 1
  %too_big.i369 = icmp samesign ugt i64 %alen.i, 2147483646
  br i1 %too_big.i369, label %oom.i390, label %mat_a.i370

oom.i390:                                         ; preds = %alloc_heap.i376, %chk_bz.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i370:                                       ; preds = %chk_bz.i
  %ashort.i = icmp samesign ult i64 %alen.i, 13
  br i1 %ashort.i, label %mat_b.i, label %mat_b.i.thread

mat_b.i.thread:                                   ; preds = %mat_a.i370
  %araw.i = and i64 %aw1.i, -4
  %alptr.i = inttoptr i64 %araw.i to ptr
  br label %alloc_heap.i376

mat_b.i:                                          ; preds = %mat_a.i370
  %ap4.i = lshr i64 %aw0.i, 32
  %ap4_32.i = trunc nuw i64 %ap4.i to i32
  store i32 %ap4_32.i, ptr %atmp.i364, align 4
  %atmp4.i400 = getelementptr inbounds nuw i8, ptr %atmp.i364, i64 4
  store i64 %aw1.i, ptr %atmp4.i400, align 4
  %fits_sso.i375.not = icmp eq i64 %alen.i, 12
  br i1 %fits_sso.i375.not, label %alloc_heap.i376, label %build_sso.i391

build_sso.i391:                                   ; preds = %mat_b.i
  %out_sso8.i392 = getelementptr inbounds nuw i8, ptr %out_sso.i366, i64 8
  %tot32.i393 = trunc nuw nsw i64 %tot.i368 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i366, i8 0, i64 16, i1 false)
  store i32 %tot32.i393, ptr %out_sso.i366, align 8
  %sso_dst_a.i394 = getelementptr inbounds nuw i8, ptr %out_sso.i366, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i394, ptr nonnull align 4 %atmp.i364, i64 %alen.i, i1 false)
  %sso_dst_b.i395 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i394, i64 %alen.i
  store i8 44, ptr %sso_dst_b.i395, align 1
  %rw0.i396 = load i64, ptr %out_sso.i366, align 8
  %rw1.i397 = load i64, ptr %out_sso8.i392, align 8
  %rs0.i398 = insertvalue %ArchxStr poison, i64 %rw0.i396, 0
  %rs1.i399 = insertvalue %ArchxStr %rs0.i398, i64 %rw1.i397, 1
  br label %archx_str_concat.exit401

alloc_heap.i376:                                  ; preds = %mat_b.i.thread, %mat_b.i
  %aptr.i1985 = phi ptr [ %alptr.i, %mat_b.i.thread ], [ %atmp.i364, %mat_b.i ]
  %hp.i377 = tail call noalias align 16 ptr @malloc(i64 %tot.i368)
  %hnull.i378 = icmp eq ptr %hp.i377, null
  br i1 %hnull.i378, label %oom.i390, label %copy_long.i379

copy_long.i379:                                   ; preds = %alloc_heap.i376
  %hp_i.i380 = ptrtoint ptr %hp.i377 to i64
  %htagged.i381 = or disjoint i64 %hp_i.i380, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i377, ptr nonnull align 1 %aptr.i1985, i64 %alen.i, i1 false)
  %dst_b.i382 = getelementptr inbounds nuw i8, ptr %hp.i377, i64 %alen.i
  store i8 44, ptr %dst_b.i382, align 1
  %pref32.i383 = load i32, ptr %hp.i377, align 16
  %pref64.i384 = zext i32 %pref32.i383 to i64
  %pref_sh.i385 = shl nuw i64 %pref64.i384, 32
  %w0_out.i386 = or disjoint i64 %pref_sh.i385, %tot.i368
  %ls0.i387 = insertvalue %ArchxStr poison, i64 %w0_out.i386, 0
  %ls1.i388 = insertvalue %ArchxStr %ls0.i387, i64 %htagged.i381, 1
  br label %archx_str_concat.exit401

archx_str_concat.exit401:                         ; preds = %archx_str_concat.exit, %build_sso.i391, %copy_long.i379
  %common.ret.op.i389 = phi %ArchxStr [ %rs1.i399, %build_sso.i391 ], [ %ls1.i388, %copy_long.i379 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i364)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i366)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1330)
  %n32.i1331 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1330, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 42)
  %len.i1332 = sext i32 %n32.i1331 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1329)
  %z.i.i1333 = icmp slt i32 %n32.i1331, 1
  br i1 %z.i.i1333, label %archx_str_from_int.exit1357, label %chk_sso.i.i1334

oom.i.i1349:                                      ; preds = %alloc_heap.i.i1336
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1334:                                  ; preds = %archx_str_concat.exit401
  %short.i.i1335 = icmp samesign ult i32 %n32.i1331, 13
  br i1 %short.i.i1335, label %pack_sso.i.i1350, label %alloc_heap.i.i1336

pack_sso.i.i1350:                                 ; preds = %chk_sso.i.i1334
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1329, i8 0, i64 16, i1 false)
  store i32 %n32.i1331, ptr %sso.i.i1329, align 8
  %sso.i.i1329.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1329, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1329.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1330, i64 range(i64 -2147483648, 2147483650) %len.i1332, i1 false)
  %sso.i.i1329.0.sso.i.i1329.0.sso.i.i1329.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1352 = load i64, ptr %sso.i.i1329, align 8
  %sso.i.i1329.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1329, i64 8
  %sso.i.i1329.8.sso.i.i1329.8.sso.i.i1329.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1354 = load i64, ptr %sso.i.i1329.8.sroa_idx, align 8
  %ss0.i.i1355 = insertvalue %ArchxStr poison, i64 %sso.i.i1329.0.sso.i.i1329.0.sso.i.i1329.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1352, 0
  %ss1.i.i1356 = insertvalue %ArchxStr %ss0.i.i1355, i64 %sso.i.i1329.8.sso.i.i1329.8.sso.i.i1329.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1354, 1
  br label %archx_str_from_int.exit1357

alloc_heap.i.i1336:                               ; preds = %chk_sso.i.i1334
  %hp.i.i1337 = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1332)
  %hnull.i.i1338 = icmp eq ptr %hp.i.i1337, null
  br i1 %hnull.i.i1338, label %oom.i.i1349, label %copy_long.i.i1339

copy_long.i.i1339:                                ; preds = %alloc_heap.i.i1336
  %hp_i.i.i1340 = ptrtoint ptr %hp.i.i1337 to i64
  %htagged.i.i1341 = or disjoint i64 %hp_i.i.i1340, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1337, ptr nonnull readonly align 8 %buf.i1330, i64 range(i64 -2147483648, 2147483650) %len.i1332, i1 false)
  %pref32.i.i1342 = load i32, ptr %hp.i.i1337, align 16
  %pref64.i.i1343 = zext i32 %pref32.i.i1342 to i64
  %pref_sh.i.i1344 = shl nuw i64 %pref64.i.i1343, 32
  %w0_out.i.i1345 = or disjoint i64 %pref_sh.i.i1344, %len.i1332
  %ls0.i.i1346 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1345, 0
  %ls1.i.i1347 = insertvalue %ArchxStr %ls0.i.i1346, i64 %htagged.i.i1341, 1
  br label %archx_str_from_int.exit1357

archx_str_from_int.exit1357:                      ; preds = %archx_str_concat.exit401, %pack_sso.i.i1350, %copy_long.i.i1339
  %common.ret.op.i.i1348 = phi %ArchxStr [ %ss1.i.i1356, %pack_sso.i.i1350 ], [ %ls1.i.i1347, %copy_long.i.i1339 ], [ zeroinitializer, %archx_str_concat.exit401 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1329)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1330)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i402)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i403)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i404)
  %aw0.i405 = extractvalue %ArchxStr %common.ret.op.i389, 0
  %aw1.i406 = extractvalue %ArchxStr %common.ret.op.i389, 1
  %bw0.i407 = extractvalue %ArchxStr %common.ret.op.i.i1348, 0
  %bw1.i408 = extractvalue %ArchxStr %common.ret.op.i.i1348, 1
  %alen.i409 = and i64 %aw0.i405, 4294967295
  %blen.i410 = and i64 %bw0.i407, 4294967295
  %az.i411 = icmp eq i64 %alen.i409, 0
  br i1 %az.i411, label %ret_b_clone.i465, label %chk_bz.i412

ret_b_clone.i465:                                 ; preds = %archx_str_from_int.exit1357
  %long.i1360 = icmp samesign ult i64 %blen.i410, 13
  %tag.i1364 = and i64 %bw1.i408, 3
  %owned.not.i1365 = icmp eq i64 %tag.i1364, 0
  %or.cond = select i1 %long.i1360, i1 true, i1 %owned.not.i1365
  br i1 %or.cond, label %archx_str_concat.exit467, label %dup_heap.i

dup_heap.i:                                       ; preds = %ret_b_clone.i465
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %blen.i410)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i1366, label %copy.i

oom.i1366:                                        ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %bw1.i408, -4
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 4 %src.i, i64 %blen.i410, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %out.i = insertvalue %ArchxStr %common.ret.op.i.i1348, i64 %tagged.i, 1
  br label %archx_str_concat.exit467

chk_bz.i412:                                      ; preds = %archx_str_from_int.exit1357
  %bz.i413 = icmp eq i64 %blen.i410, 0
  br i1 %bz.i413, label %ret_a_clone.i463, label %calc_tot.i414

ret_a_clone.i463:                                 ; preds = %chk_bz.i412
  %long.i1369 = icmp samesign ult i64 %alen.i409, 13
  %tag.i1373 = and i64 %aw1.i406, 3
  %owned.not.i1374 = icmp eq i64 %tag.i1373, 0
  %or.cond2066 = select i1 %long.i1369, i1 true, i1 %owned.not.i1374
  br i1 %or.cond2066, label %archx_str_concat.exit467, label %dup_heap.i1375

dup_heap.i1375:                                   ; preds = %ret_a_clone.i463
  %dst.i1376 = tail call noalias align 16 ptr @malloc(i64 %alen.i409)
  %isnull.i1377 = icmp eq ptr %dst.i1376, null
  br i1 %isnull.i1377, label %oom.i1384, label %copy.i1378

oom.i1384:                                        ; preds = %dup_heap.i1375
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i1378:                                       ; preds = %dup_heap.i1375
  %src_i.i1379 = and i64 %aw1.i406, -4
  %src.i1380 = inttoptr i64 %src_i.i1379 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1376, ptr nonnull align 4 %src.i1380, i64 %alen.i409, i1 false)
  %dst_i.i1381 = ptrtoint ptr %dst.i1376 to i64
  %tagged.i1382 = or disjoint i64 %dst_i.i1381, 1
  %out.i1383 = insertvalue %ArchxStr %common.ret.op.i389, i64 %tagged.i1382, 1
  br label %archx_str_concat.exit467

calc_tot.i414:                                    ; preds = %chk_bz.i412
  %tot.i415 = add nuw nsw i64 %blen.i410, %alen.i409
  %too_big.i416 = icmp samesign ugt i64 %tot.i415, 2147483647
  br i1 %too_big.i416, label %oom.i445, label %mat_a.i417

oom.i445:                                         ; preds = %alloc_heap.i431, %calc_tot.i414
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i417:                                       ; preds = %calc_tot.i414
  %ashort.i418 = icmp samesign ult i64 %alen.i409, 13
  br i1 %ashort.i418, label %mat_a_short.i459, label %mat_a_long.i419

mat_a_short.i459:                                 ; preds = %mat_a.i417
  %ap4.i460 = lshr i64 %aw0.i405, 32
  %ap4_32.i461 = trunc nuw i64 %ap4.i460 to i32
  store i32 %ap4_32.i461, ptr %atmp.i402, align 4
  %atmp4.i462 = getelementptr inbounds nuw i8, ptr %atmp.i402, i64 4
  store i64 %aw1.i406, ptr %atmp4.i462, align 4
  br label %mat_b.i422

mat_a_long.i419:                                  ; preds = %mat_a.i417
  %araw.i420 = and i64 %aw1.i406, -4
  %alptr.i421 = inttoptr i64 %araw.i420 to ptr
  br label %mat_b.i422

mat_b.i422:                                       ; preds = %mat_a_long.i419, %mat_a_short.i459
  %aptr.i423 = phi ptr [ %atmp.i402, %mat_a_short.i459 ], [ %alptr.i421, %mat_a_long.i419 ]
  %bshort.i424 = icmp samesign ult i64 %blen.i410, 13
  br i1 %bshort.i424, label %mat_b_short.i455, label %mat_b_long.i425

mat_b_short.i455:                                 ; preds = %mat_b.i422
  %bp4.i456 = lshr i64 %bw0.i407, 32
  %bp4_32.i457 = trunc nuw i64 %bp4.i456 to i32
  store i32 %bp4_32.i457, ptr %btmp.i403, align 4
  %btmp4.i458 = getelementptr inbounds nuw i8, ptr %btmp.i403, i64 4
  store i64 %bw1.i408, ptr %btmp4.i458, align 4
  br label %build.i428

mat_b_long.i425:                                  ; preds = %mat_b.i422
  %braw.i426 = and i64 %bw1.i408, -4
  %blptr.i427 = inttoptr i64 %braw.i426 to ptr
  br label %build.i428

build.i428:                                       ; preds = %mat_b_long.i425, %mat_b_short.i455
  %bptr.i429 = phi ptr [ %btmp.i403, %mat_b_short.i455 ], [ %blptr.i427, %mat_b_long.i425 ]
  %fits_sso.i430 = icmp samesign ult i64 %tot.i415, 13
  br i1 %fits_sso.i430, label %build_sso.i446, label %alloc_heap.i431

build_sso.i446:                                   ; preds = %build.i428
  %out_sso8.i447 = getelementptr inbounds nuw i8, ptr %out_sso.i404, i64 8
  %tot32.i448 = trunc nuw nsw i64 %tot.i415 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i404, i8 0, i64 16, i1 false)
  store i32 %tot32.i448, ptr %out_sso.i404, align 8
  %sso_dst_a.i449 = getelementptr inbounds nuw i8, ptr %out_sso.i404, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i449, ptr nonnull align 1 %aptr.i423, i64 %alen.i409, i1 false)
  %sso_dst_b.i450 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i449, i64 %alen.i409
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i450, ptr nonnull align 1 %bptr.i429, i64 %blen.i410, i1 false)
  %rw0.i451 = load i64, ptr %out_sso.i404, align 8
  %rw1.i452 = load i64, ptr %out_sso8.i447, align 8
  %rs0.i453 = insertvalue %ArchxStr poison, i64 %rw0.i451, 0
  %rs1.i454 = insertvalue %ArchxStr %rs0.i453, i64 %rw1.i452, 1
  br label %archx_str_concat.exit467

alloc_heap.i431:                                  ; preds = %build.i428
  %hp.i432 = tail call noalias align 16 ptr @malloc(i64 %tot.i415)
  %hnull.i433 = icmp eq ptr %hp.i432, null
  br i1 %hnull.i433, label %oom.i445, label %copy_long.i434

copy_long.i434:                                   ; preds = %alloc_heap.i431
  %hp_i.i435 = ptrtoint ptr %hp.i432 to i64
  %htagged.i436 = or disjoint i64 %hp_i.i435, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i432, ptr nonnull align 1 %aptr.i423, i64 %alen.i409, i1 false)
  %dst_b.i437 = getelementptr inbounds nuw i8, ptr %hp.i432, i64 %alen.i409
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i437, ptr nonnull align 1 %bptr.i429, i64 %blen.i410, i1 false)
  %pref32.i438 = load i32, ptr %hp.i432, align 16
  %pref64.i439 = zext i32 %pref32.i438 to i64
  %pref_sh.i440 = shl nuw i64 %pref64.i439, 32
  %w0_out.i441 = or disjoint i64 %pref_sh.i440, %tot.i415
  %ls0.i442 = insertvalue %ArchxStr poison, i64 %w0_out.i441, 0
  %ls1.i443 = insertvalue %ArchxStr %ls0.i442, i64 %htagged.i436, 1
  br label %archx_str_concat.exit467

archx_str_concat.exit467:                         ; preds = %copy.i1378, %ret_a_clone.i463, %copy.i, %ret_b_clone.i465, %build_sso.i446, %copy_long.i434
  %common.ret.op.i444 = phi %ArchxStr [ %rs1.i454, %build_sso.i446 ], [ %ls1.i443, %copy_long.i434 ], [ %out.i, %copy.i ], [ %common.ret.op.i.i1348, %ret_b_clone.i465 ], [ %out.i1383, %copy.i1378 ], [ %common.ret.op.i389, %ret_a_clone.i463 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i402)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i403)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i404)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i468)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i470)
  %aw0.i471 = extractvalue %ArchxStr %common.ret.op.i444, 0
  %aw1.i472 = extractvalue %ArchxStr %common.ret.op.i444, 1
  %alen.i473 = and i64 %aw0.i471, 4294967295
  %az.i474 = icmp eq i64 %alen.i473, 0
  br i1 %az.i474, label %archx_str_concat.exit521, label %chk_bz.i475

chk_bz.i475:                                      ; preds = %archx_str_concat.exit467
  %tot.i477 = add nuw nsw i64 %alen.i473, 1
  %too_big.i478 = icmp samesign ugt i64 %alen.i473, 2147483646
  br i1 %too_big.i478, label %oom.i505, label %mat_a.i479

oom.i505:                                         ; preds = %alloc_heap.i491, %chk_bz.i475
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i479:                                       ; preds = %chk_bz.i475
  %ashort.i480 = icmp samesign ult i64 %alen.i473, 13
  br i1 %ashort.i480, label %mat_b.i484, label %mat_b.i484.thread

mat_b.i484.thread:                                ; preds = %mat_a.i479
  %araw.i482 = and i64 %aw1.i472, -4
  %alptr.i483 = inttoptr i64 %araw.i482 to ptr
  br label %alloc_heap.i491

mat_b.i484:                                       ; preds = %mat_a.i479
  %ap4.i516 = lshr i64 %aw0.i471, 32
  %ap4_32.i517 = trunc nuw i64 %ap4.i516 to i32
  store i32 %ap4_32.i517, ptr %atmp.i468, align 4
  %atmp4.i518 = getelementptr inbounds nuw i8, ptr %atmp.i468, i64 4
  store i64 %aw1.i472, ptr %atmp4.i518, align 4
  %fits_sso.i490.not = icmp eq i64 %alen.i473, 12
  br i1 %fits_sso.i490.not, label %alloc_heap.i491, label %build_sso.i506

build_sso.i506:                                   ; preds = %mat_b.i484
  %out_sso8.i507 = getelementptr inbounds nuw i8, ptr %out_sso.i470, i64 8
  %tot32.i508 = trunc nuw nsw i64 %tot.i477 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i470, i8 0, i64 16, i1 false)
  store i32 %tot32.i508, ptr %out_sso.i470, align 8
  %sso_dst_a.i509 = getelementptr inbounds nuw i8, ptr %out_sso.i470, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i509, ptr nonnull align 4 %atmp.i468, i64 %alen.i473, i1 false)
  %sso_dst_b.i510 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i509, i64 %alen.i473
  store i8 44, ptr %sso_dst_b.i510, align 1
  %rw0.i511 = load i64, ptr %out_sso.i470, align 8
  %rw1.i512 = load i64, ptr %out_sso8.i507, align 8
  %rs0.i513 = insertvalue %ArchxStr poison, i64 %rw0.i511, 0
  %rs1.i514 = insertvalue %ArchxStr %rs0.i513, i64 %rw1.i512, 1
  br label %archx_str_concat.exit521

alloc_heap.i491:                                  ; preds = %mat_b.i484.thread, %mat_b.i484
  %aptr.i4851988 = phi ptr [ %alptr.i483, %mat_b.i484.thread ], [ %atmp.i468, %mat_b.i484 ]
  %hp.i492 = tail call noalias align 16 ptr @malloc(i64 %tot.i477)
  %hnull.i493 = icmp eq ptr %hp.i492, null
  br i1 %hnull.i493, label %oom.i505, label %copy_long.i494

copy_long.i494:                                   ; preds = %alloc_heap.i491
  %hp_i.i495 = ptrtoint ptr %hp.i492 to i64
  %htagged.i496 = or disjoint i64 %hp_i.i495, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i492, ptr nonnull align 1 %aptr.i4851988, i64 %alen.i473, i1 false)
  %dst_b.i497 = getelementptr inbounds nuw i8, ptr %hp.i492, i64 %alen.i473
  store i8 44, ptr %dst_b.i497, align 1
  %pref32.i498 = load i32, ptr %hp.i492, align 16
  %pref64.i499 = zext i32 %pref32.i498 to i64
  %pref_sh.i500 = shl nuw i64 %pref64.i499, 32
  %w0_out.i501 = or disjoint i64 %pref_sh.i500, %tot.i477
  %ls0.i502 = insertvalue %ArchxStr poison, i64 %w0_out.i501, 0
  %ls1.i503 = insertvalue %ArchxStr %ls0.i502, i64 %htagged.i496, 1
  br label %archx_str_concat.exit521

archx_str_concat.exit521:                         ; preds = %archx_str_concat.exit467, %build_sso.i506, %copy_long.i494
  %common.ret.op.i504 = phi %ArchxStr [ %rs1.i514, %build_sso.i506 ], [ %ls1.i503, %copy_long.i494 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit467 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i468)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i470)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1388)
  %n32.i1389 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1388, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 86)
  %len.i1390 = sext i32 %n32.i1389 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1387)
  %z.i.i1391 = icmp slt i32 %n32.i1389, 1
  br i1 %z.i.i1391, label %archx_str_from_int.exit1415, label %chk_sso.i.i1392

oom.i.i1407:                                      ; preds = %alloc_heap.i.i1394
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1392:                                  ; preds = %archx_str_concat.exit521
  %short.i.i1393 = icmp samesign ult i32 %n32.i1389, 13
  br i1 %short.i.i1393, label %pack_sso.i.i1408, label %alloc_heap.i.i1394

pack_sso.i.i1408:                                 ; preds = %chk_sso.i.i1392
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1387, i8 0, i64 16, i1 false)
  store i32 %n32.i1389, ptr %sso.i.i1387, align 8
  %sso.i.i1387.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1387, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1387.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1388, i64 range(i64 -2147483648, 2147483650) %len.i1390, i1 false)
  %sso.i.i1387.0.sso.i.i1387.0.sso.i.i1387.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1410 = load i64, ptr %sso.i.i1387, align 8
  %sso.i.i1387.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1387, i64 8
  %sso.i.i1387.8.sso.i.i1387.8.sso.i.i1387.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1412 = load i64, ptr %sso.i.i1387.8.sroa_idx, align 8
  %ss0.i.i1413 = insertvalue %ArchxStr poison, i64 %sso.i.i1387.0.sso.i.i1387.0.sso.i.i1387.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1410, 0
  %ss1.i.i1414 = insertvalue %ArchxStr %ss0.i.i1413, i64 %sso.i.i1387.8.sso.i.i1387.8.sso.i.i1387.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1412, 1
  br label %archx_str_from_int.exit1415

alloc_heap.i.i1394:                               ; preds = %chk_sso.i.i1392
  %hp.i.i1395 = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1390)
  %hnull.i.i1396 = icmp eq ptr %hp.i.i1395, null
  br i1 %hnull.i.i1396, label %oom.i.i1407, label %copy_long.i.i1397

copy_long.i.i1397:                                ; preds = %alloc_heap.i.i1394
  %hp_i.i.i1398 = ptrtoint ptr %hp.i.i1395 to i64
  %htagged.i.i1399 = or disjoint i64 %hp_i.i.i1398, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1395, ptr nonnull readonly align 8 %buf.i1388, i64 range(i64 -2147483648, 2147483650) %len.i1390, i1 false)
  %pref32.i.i1400 = load i32, ptr %hp.i.i1395, align 16
  %pref64.i.i1401 = zext i32 %pref32.i.i1400 to i64
  %pref_sh.i.i1402 = shl nuw i64 %pref64.i.i1401, 32
  %w0_out.i.i1403 = or disjoint i64 %pref_sh.i.i1402, %len.i1390
  %ls0.i.i1404 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1403, 0
  %ls1.i.i1405 = insertvalue %ArchxStr %ls0.i.i1404, i64 %htagged.i.i1399, 1
  br label %archx_str_from_int.exit1415

archx_str_from_int.exit1415:                      ; preds = %archx_str_concat.exit521, %pack_sso.i.i1408, %copy_long.i.i1397
  %common.ret.op.i.i1406 = phi %ArchxStr [ %ss1.i.i1414, %pack_sso.i.i1408 ], [ %ls1.i.i1405, %copy_long.i.i1397 ], [ zeroinitializer, %archx_str_concat.exit521 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1387)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1388)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i522)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i523)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i524)
  %aw0.i525 = extractvalue %ArchxStr %common.ret.op.i504, 0
  %aw1.i526 = extractvalue %ArchxStr %common.ret.op.i504, 1
  %bw0.i527 = extractvalue %ArchxStr %common.ret.op.i.i1406, 0
  %bw1.i528 = extractvalue %ArchxStr %common.ret.op.i.i1406, 1
  %alen.i529 = and i64 %aw0.i525, 4294967295
  %blen.i530 = and i64 %bw0.i527, 4294967295
  %az.i531 = icmp eq i64 %alen.i529, 0
  br i1 %az.i531, label %ret_b_clone.i585, label %chk_bz.i532

ret_b_clone.i585:                                 ; preds = %archx_str_from_int.exit1415
  %long.i1418 = icmp samesign ult i64 %blen.i530, 13
  %tag.i1422 = and i64 %bw1.i528, 3
  %owned.not.i1423 = icmp eq i64 %tag.i1422, 0
  %or.cond2067 = select i1 %long.i1418, i1 true, i1 %owned.not.i1423
  br i1 %or.cond2067, label %archx_str_concat.exit587, label %dup_heap.i1424

dup_heap.i1424:                                   ; preds = %ret_b_clone.i585
  %dst.i1425 = tail call noalias align 16 ptr @malloc(i64 %blen.i530)
  %isnull.i1426 = icmp eq ptr %dst.i1425, null
  br i1 %isnull.i1426, label %oom.i1433, label %copy.i1427

oom.i1433:                                        ; preds = %dup_heap.i1424
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i1427:                                       ; preds = %dup_heap.i1424
  %src_i.i1428 = and i64 %bw1.i528, -4
  %src.i1429 = inttoptr i64 %src_i.i1428 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1425, ptr nonnull align 4 %src.i1429, i64 %blen.i530, i1 false)
  %dst_i.i1430 = ptrtoint ptr %dst.i1425 to i64
  %tagged.i1431 = or disjoint i64 %dst_i.i1430, 1
  %out.i1432 = insertvalue %ArchxStr %common.ret.op.i.i1406, i64 %tagged.i1431, 1
  br label %archx_str_concat.exit587

chk_bz.i532:                                      ; preds = %archx_str_from_int.exit1415
  %bz.i533 = icmp eq i64 %blen.i530, 0
  br i1 %bz.i533, label %ret_a_clone.i583, label %calc_tot.i534

ret_a_clone.i583:                                 ; preds = %chk_bz.i532
  %long.i1437 = icmp samesign ult i64 %alen.i529, 13
  %tag.i1441 = and i64 %aw1.i526, 3
  %owned.not.i1442 = icmp eq i64 %tag.i1441, 0
  %or.cond2068 = select i1 %long.i1437, i1 true, i1 %owned.not.i1442
  br i1 %or.cond2068, label %archx_str_concat.exit587, label %dup_heap.i1443

dup_heap.i1443:                                   ; preds = %ret_a_clone.i583
  %dst.i1444 = tail call noalias align 16 ptr @malloc(i64 %alen.i529)
  %isnull.i1445 = icmp eq ptr %dst.i1444, null
  br i1 %isnull.i1445, label %oom.i1452, label %copy.i1446

oom.i1452:                                        ; preds = %dup_heap.i1443
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i1446:                                       ; preds = %dup_heap.i1443
  %src_i.i1447 = and i64 %aw1.i526, -4
  %src.i1448 = inttoptr i64 %src_i.i1447 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1444, ptr nonnull align 4 %src.i1448, i64 %alen.i529, i1 false)
  %dst_i.i1449 = ptrtoint ptr %dst.i1444 to i64
  %tagged.i1450 = or disjoint i64 %dst_i.i1449, 1
  %out.i1451 = insertvalue %ArchxStr %common.ret.op.i504, i64 %tagged.i1450, 1
  br label %archx_str_concat.exit587

calc_tot.i534:                                    ; preds = %chk_bz.i532
  %tot.i535 = add nuw nsw i64 %blen.i530, %alen.i529
  %too_big.i536 = icmp samesign ugt i64 %tot.i535, 2147483647
  br i1 %too_big.i536, label %oom.i565, label %mat_a.i537

oom.i565:                                         ; preds = %alloc_heap.i551, %calc_tot.i534
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i537:                                       ; preds = %calc_tot.i534
  %ashort.i538 = icmp samesign ult i64 %alen.i529, 13
  br i1 %ashort.i538, label %mat_a_short.i579, label %mat_a_long.i539

mat_a_short.i579:                                 ; preds = %mat_a.i537
  %ap4.i580 = lshr i64 %aw0.i525, 32
  %ap4_32.i581 = trunc nuw i64 %ap4.i580 to i32
  store i32 %ap4_32.i581, ptr %atmp.i522, align 4
  %atmp4.i582 = getelementptr inbounds nuw i8, ptr %atmp.i522, i64 4
  store i64 %aw1.i526, ptr %atmp4.i582, align 4
  br label %mat_b.i542

mat_a_long.i539:                                  ; preds = %mat_a.i537
  %araw.i540 = and i64 %aw1.i526, -4
  %alptr.i541 = inttoptr i64 %araw.i540 to ptr
  br label %mat_b.i542

mat_b.i542:                                       ; preds = %mat_a_long.i539, %mat_a_short.i579
  %aptr.i543 = phi ptr [ %atmp.i522, %mat_a_short.i579 ], [ %alptr.i541, %mat_a_long.i539 ]
  %bshort.i544 = icmp samesign ult i64 %blen.i530, 13
  br i1 %bshort.i544, label %mat_b_short.i575, label %mat_b_long.i545

mat_b_short.i575:                                 ; preds = %mat_b.i542
  %bp4.i576 = lshr i64 %bw0.i527, 32
  %bp4_32.i577 = trunc nuw i64 %bp4.i576 to i32
  store i32 %bp4_32.i577, ptr %btmp.i523, align 4
  %btmp4.i578 = getelementptr inbounds nuw i8, ptr %btmp.i523, i64 4
  store i64 %bw1.i528, ptr %btmp4.i578, align 4
  br label %build.i548

mat_b_long.i545:                                  ; preds = %mat_b.i542
  %braw.i546 = and i64 %bw1.i528, -4
  %blptr.i547 = inttoptr i64 %braw.i546 to ptr
  br label %build.i548

build.i548:                                       ; preds = %mat_b_long.i545, %mat_b_short.i575
  %bptr.i549 = phi ptr [ %btmp.i523, %mat_b_short.i575 ], [ %blptr.i547, %mat_b_long.i545 ]
  %fits_sso.i550 = icmp samesign ult i64 %tot.i535, 13
  br i1 %fits_sso.i550, label %build_sso.i566, label %alloc_heap.i551

build_sso.i566:                                   ; preds = %build.i548
  %out_sso8.i567 = getelementptr inbounds nuw i8, ptr %out_sso.i524, i64 8
  %tot32.i568 = trunc nuw nsw i64 %tot.i535 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i524, i8 0, i64 16, i1 false)
  store i32 %tot32.i568, ptr %out_sso.i524, align 8
  %sso_dst_a.i569 = getelementptr inbounds nuw i8, ptr %out_sso.i524, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i569, ptr nonnull align 1 %aptr.i543, i64 %alen.i529, i1 false)
  %sso_dst_b.i570 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i569, i64 %alen.i529
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i570, ptr nonnull align 1 %bptr.i549, i64 %blen.i530, i1 false)
  %rw0.i571 = load i64, ptr %out_sso.i524, align 8
  %rw1.i572 = load i64, ptr %out_sso8.i567, align 8
  %rs0.i573 = insertvalue %ArchxStr poison, i64 %rw0.i571, 0
  %rs1.i574 = insertvalue %ArchxStr %rs0.i573, i64 %rw1.i572, 1
  br label %archx_str_concat.exit587

alloc_heap.i551:                                  ; preds = %build.i548
  %hp.i552 = tail call noalias align 16 ptr @malloc(i64 %tot.i535)
  %hnull.i553 = icmp eq ptr %hp.i552, null
  br i1 %hnull.i553, label %oom.i565, label %copy_long.i554

copy_long.i554:                                   ; preds = %alloc_heap.i551
  %hp_i.i555 = ptrtoint ptr %hp.i552 to i64
  %htagged.i556 = or disjoint i64 %hp_i.i555, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i552, ptr nonnull align 1 %aptr.i543, i64 %alen.i529, i1 false)
  %dst_b.i557 = getelementptr inbounds nuw i8, ptr %hp.i552, i64 %alen.i529
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i557, ptr nonnull align 1 %bptr.i549, i64 %blen.i530, i1 false)
  %pref32.i558 = load i32, ptr %hp.i552, align 16
  %pref64.i559 = zext i32 %pref32.i558 to i64
  %pref_sh.i560 = shl nuw i64 %pref64.i559, 32
  %w0_out.i561 = or disjoint i64 %pref_sh.i560, %tot.i535
  %ls0.i562 = insertvalue %ArchxStr poison, i64 %w0_out.i561, 0
  %ls1.i563 = insertvalue %ArchxStr %ls0.i562, i64 %htagged.i556, 1
  br label %archx_str_concat.exit587

archx_str_concat.exit587:                         ; preds = %copy.i1446, %ret_a_clone.i583, %copy.i1427, %ret_b_clone.i585, %build_sso.i566, %copy_long.i554
  %common.ret.op.i564 = phi %ArchxStr [ %rs1.i574, %build_sso.i566 ], [ %ls1.i563, %copy_long.i554 ], [ %out.i1432, %copy.i1427 ], [ %common.ret.op.i.i1406, %ret_b_clone.i585 ], [ %out.i1451, %copy.i1446 ], [ %common.ret.op.i504, %ret_a_clone.i583 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i522)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i523)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i524)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  %w0.i1454 = extractvalue %ArchxStr %common.ret.op.i564, 0
  %w1.i1455 = extractvalue %ArchxStr %common.ret.op.i564, 1
  %len.i1456 = and i64 %w0.i1454, 4294967295
  %short.i = icmp samesign ult i64 %len.i1456, 13
  br i1 %short.i, label %emit.i, label %emit.thread.i

emit.thread.i:                                    ; preds = %archx_str_concat.exit587
  %raw.i1457 = and i64 %w1.i1455, -4
  %lptr.i = inttoptr i64 %raw.i1457 to ptr
  br label %chk_nul.i

emit.i:                                           ; preds = %archx_str_concat.exit587
  %p4.i = lshr i64 %w0.i1454, 32
  %p4_32.i = trunc nuw i64 %p4.i to i32
  store i32 %p4_32.i, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 %w1.i1455, ptr %tmp4.i, align 4
  %pos.not.i = icmp eq i64 %len.i1456, 0
  br i1 %pos.not.i, label %do_nl.i, label %chk_nul.i

chk_nul.i:                                        ; preds = %emit.i, %emit.thread.i
  %data3.i = phi ptr [ %lptr.i, %emit.thread.i ], [ %tmp.i, %emit.i ]
  %nul.i = call ptr @memchr(ptr nonnull %data3.i, i32 0, i64 %len.i1456)
  %has_nul.not.i = icmp eq ptr %nul.i, null
  br i1 %has_nul.not.i, label %fast_printf.i, label %byte_loop.i

fast_printf.i:                                    ; preds = %chk_nul.i
  %len32.i = trunc i64 %w0.i1454 to i32
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i, ptr nonnull %data3.i)
  br label %archx_str_print.exit

byte_loop.i:                                      ; preds = %chk_nul.i, %byte_loop.i
  %bi.i = phi i64 [ %bnext.i, %byte_loop.i ], [ 0, %chk_nul.i ]
  %bp.i = getelementptr inbounds nuw i8, ptr %data3.i, i64 %bi.i
  %ch8.i = load i8, ptr %bp.i, align 1
  %ch32.i = zext i8 %ch8.i to i32
  %pc.i = tail call i32 @putchar(i32 %ch32.i)
  %bnext.i = add nuw nsw i64 %bi.i, 1
  %exitcond.not.i = icmp eq i64 %bnext.i, %len.i1456
  br i1 %exitcond.not.i, label %do_nl.i, label %byte_loop.i

do_nl.i:                                          ; preds = %byte_loop.i, %emit.i
  %nc.i = tail call i32 @putchar(i32 10)
  br label %archx_str_print.exit

archx_str_print.exit:                             ; preds = %fast_printf.i, %do_nl.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %tag.i = and i64 %w1.i1455, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond2069 = select i1 %short.i, i1 true, i1 %owned.not.i
  br i1 %or.cond2069, label %archx_str_drop.exit, label %do_free.i

do_free.i:                                        ; preds = %archx_str_print.exit
  %raw.i = and i64 %w1.i1455, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  call void @free(ptr %ptr.i)
  br label %archx_str_drop.exit

archx_str_drop.exit:                              ; preds = %archx_str_print.exit, %do_free.i
  %long.i69 = icmp samesign ult i64 %blen.i530, 13
  %tag.i72 = and i64 %bw1.i528, 1
  %owned.not.i73 = icmp eq i64 %tag.i72, 0
  %or.cond2070 = select i1 %long.i69, i1 true, i1 %owned.not.i73
  br i1 %or.cond2070, label %archx_str_drop.exit77, label %do_free.i74

do_free.i74:                                      ; preds = %archx_str_drop.exit
  %raw.i75 = and i64 %bw1.i528, -2
  %ptr.i76 = inttoptr i64 %raw.i75 to ptr
  call void @free(ptr %ptr.i76)
  br label %archx_str_drop.exit77

archx_str_drop.exit77:                            ; preds = %archx_str_drop.exit, %do_free.i74
  %long.i80 = icmp samesign ult i64 %alen.i529, 13
  %tag.i83 = and i64 %aw1.i526, 1
  %owned.not.i84 = icmp eq i64 %tag.i83, 0
  %or.cond2071 = select i1 %long.i80, i1 true, i1 %owned.not.i84
  br i1 %or.cond2071, label %archx_str_drop.exit88, label %do_free.i85

do_free.i85:                                      ; preds = %archx_str_drop.exit77
  %raw.i86 = and i64 %aw1.i526, -2
  %ptr.i87 = inttoptr i64 %raw.i86 to ptr
  call void @free(ptr %ptr.i87)
  br label %archx_str_drop.exit88

archx_str_drop.exit88:                            ; preds = %archx_str_drop.exit77, %do_free.i85
  %long.i91 = icmp samesign ult i64 %alen.i473, 13
  %tag.i94 = and i64 %aw1.i472, 1
  %owned.not.i95 = icmp eq i64 %tag.i94, 0
  %or.cond2072 = select i1 %long.i91, i1 true, i1 %owned.not.i95
  br i1 %or.cond2072, label %archx_str_drop.exit99, label %do_free.i96

do_free.i96:                                      ; preds = %archx_str_drop.exit88
  %raw.i97 = and i64 %aw1.i472, -2
  %ptr.i98 = inttoptr i64 %raw.i97 to ptr
  call void @free(ptr %ptr.i98)
  br label %archx_str_drop.exit99

archx_str_drop.exit99:                            ; preds = %archx_str_drop.exit88, %do_free.i96
  %long.i102 = icmp samesign ult i64 %blen.i410, 13
  %tag.i105 = and i64 %bw1.i408, 1
  %owned.not.i106 = icmp eq i64 %tag.i105, 0
  %or.cond2073 = select i1 %long.i102, i1 true, i1 %owned.not.i106
  br i1 %or.cond2073, label %archx_str_drop.exit110, label %do_free.i107

do_free.i107:                                     ; preds = %archx_str_drop.exit99
  %raw.i108 = and i64 %bw1.i408, -2
  %ptr.i109 = inttoptr i64 %raw.i108 to ptr
  call void @free(ptr %ptr.i109)
  br label %archx_str_drop.exit110

archx_str_drop.exit110:                           ; preds = %archx_str_drop.exit99, %do_free.i107
  %long.i113 = icmp samesign ult i64 %alen.i409, 13
  %tag.i116 = and i64 %aw1.i406, 1
  %owned.not.i117 = icmp eq i64 %tag.i116, 0
  %or.cond2074 = select i1 %long.i113, i1 true, i1 %owned.not.i117
  br i1 %or.cond2074, label %archx_str_drop.exit121, label %do_free.i118

do_free.i118:                                     ; preds = %archx_str_drop.exit110
  %raw.i119 = and i64 %aw1.i406, -2
  %ptr.i120 = inttoptr i64 %raw.i119 to ptr
  call void @free(ptr %ptr.i120)
  br label %archx_str_drop.exit121

archx_str_drop.exit121:                           ; preds = %archx_str_drop.exit110, %do_free.i118
  %long.i124 = icmp samesign ult i64 %alen.i, 13
  %tag.i127 = and i64 %aw1.i, 1
  %owned.not.i128 = icmp eq i64 %tag.i127, 0
  %or.cond2075 = select i1 %long.i124, i1 true, i1 %owned.not.i128
  br i1 %or.cond2075, label %archx_str_drop.exit132, label %do_free.i129

do_free.i129:                                     ; preds = %archx_str_drop.exit121
  %raw.i130 = and i64 %aw1.i, -2
  %ptr.i131 = inttoptr i64 %raw.i130 to ptr
  call void @free(ptr %ptr.i131)
  br label %archx_str_drop.exit132

archx_str_drop.exit132:                           ; preds = %archx_str_drop.exit121, %do_free.i129
  %long.i135 = icmp samesign ult i64 %blen.i, 13
  %tag.i138 = and i64 %bw1.i, 1
  %owned.not.i139 = icmp eq i64 %tag.i138, 0
  %or.cond2076 = select i1 %long.i135, i1 true, i1 %owned.not.i139
  br i1 %or.cond2076, label %archx_str_drop.exit143, label %do_free.i140

do_free.i140:                                     ; preds = %archx_str_drop.exit132
  %raw.i141 = and i64 %bw1.i, -2
  %ptr.i142 = inttoptr i64 %raw.i141 to ptr
  call void @free(ptr %ptr.i142)
  br label %archx_str_drop.exit143

archx_str_drop.exit143:                           ; preds = %archx_str_drop.exit132, %do_free.i140
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1459)
  %n32.i1460 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1459, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 99)
  %len.i1461 = sext i32 %n32.i1460 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1458)
  %z.i.i1462 = icmp slt i32 %n32.i1460, 1
  br i1 %z.i.i1462, label %archx_str_from_int.exit1486, label %chk_sso.i.i1463

oom.i.i1478:                                      ; preds = %alloc_heap.i.i1465
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1463:                                  ; preds = %archx_str_drop.exit143
  %short.i.i1464 = icmp samesign ult i32 %n32.i1460, 13
  br i1 %short.i.i1464, label %pack_sso.i.i1479, label %alloc_heap.i.i1465

pack_sso.i.i1479:                                 ; preds = %chk_sso.i.i1463
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1458, i8 0, i64 16, i1 false)
  store i32 %n32.i1460, ptr %sso.i.i1458, align 8
  %sso.i.i1458.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1458, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1458.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1459, i64 range(i64 -2147483648, 2147483650) %len.i1461, i1 false)
  %sso.i.i1458.0.sso.i.i1458.0.sso.i.i1458.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1481 = load i64, ptr %sso.i.i1458, align 8
  %sso.i.i1458.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1458, i64 8
  %sso.i.i1458.8.sso.i.i1458.8.sso.i.i1458.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1483 = load i64, ptr %sso.i.i1458.8.sroa_idx, align 8
  %ss0.i.i1484 = insertvalue %ArchxStr poison, i64 %sso.i.i1458.0.sso.i.i1458.0.sso.i.i1458.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1481, 0
  %ss1.i.i1485 = insertvalue %ArchxStr %ss0.i.i1484, i64 %sso.i.i1458.8.sso.i.i1458.8.sso.i.i1458.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1483, 1
  br label %archx_str_from_int.exit1486

alloc_heap.i.i1465:                               ; preds = %chk_sso.i.i1463
  %hp.i.i1466 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1461)
  %hnull.i.i1467 = icmp eq ptr %hp.i.i1466, null
  br i1 %hnull.i.i1467, label %oom.i.i1478, label %copy_long.i.i1468

copy_long.i.i1468:                                ; preds = %alloc_heap.i.i1465
  %hp_i.i.i1469 = ptrtoint ptr %hp.i.i1466 to i64
  %htagged.i.i1470 = or disjoint i64 %hp_i.i.i1469, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1466, ptr nonnull readonly align 8 %buf.i1459, i64 range(i64 -2147483648, 2147483650) %len.i1461, i1 false)
  %pref32.i.i1471 = load i32, ptr %hp.i.i1466, align 16
  %pref64.i.i1472 = zext i32 %pref32.i.i1471 to i64
  %pref_sh.i.i1473 = shl nuw i64 %pref64.i.i1472, 32
  %w0_out.i.i1474 = or disjoint i64 %pref_sh.i.i1473, %len.i1461
  %ls0.i.i1475 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1474, 0
  %ls1.i.i1476 = insertvalue %ArchxStr %ls0.i.i1475, i64 %htagged.i.i1470, 1
  br label %archx_str_from_int.exit1486

archx_str_from_int.exit1486:                      ; preds = %archx_str_drop.exit143, %pack_sso.i.i1479, %copy_long.i.i1468
  %common.ret.op.i.i1477 = phi %ArchxStr [ %ss1.i.i1485, %pack_sso.i.i1479 ], [ %ls1.i.i1476, %copy_long.i.i1468 ], [ zeroinitializer, %archx_str_drop.exit143 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1458)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1459)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i589)
  %bw0.i591 = extractvalue %ArchxStr %common.ret.op.i.i1477, 0
  %bw1.i592 = extractvalue %ArchxStr %common.ret.op.i.i1477, 1
  %blen.i593 = and i64 %bw0.i591, 4294967295
  %bz.i595 = icmp eq i64 %blen.i593, 0
  br i1 %bz.i595, label %archx_str_concat.exit641, label %calc_tot.i596

calc_tot.i596:                                    ; preds = %archx_str_from_int.exit1486
  %tot.i597 = add nuw nsw i64 %blen.i593, 5
  %too_big.i598 = icmp samesign ugt i64 %blen.i593, 2147483642
  br i1 %too_big.i598, label %oom.i625, label %mat_a.i599

oom.i625:                                         ; preds = %alloc_heap.i611, %calc_tot.i596
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i599:                                       ; preds = %calc_tot.i596
  %bshort.i604 = icmp samesign ult i64 %blen.i593, 13
  br i1 %bshort.i604, label %build.i608, label %build.i608.thread

build.i608.thread:                                ; preds = %mat_a.i599
  %braw.i606 = and i64 %bw1.i592, -4
  %blptr.i607 = inttoptr i64 %braw.i606 to ptr
  br label %alloc_heap.i611

build.i608:                                       ; preds = %mat_a.i599
  %bp4.i636 = lshr i64 %bw0.i591, 32
  %bp4_32.i637 = trunc nuw i64 %bp4.i636 to i32
  store i32 %bp4_32.i637, ptr %btmp.i589, align 4
  %btmp4.i638 = getelementptr inbounds nuw i8, ptr %btmp.i589, i64 4
  store i64 %bw1.i592, ptr %btmp4.i638, align 4
  %fits_sso.i610 = icmp samesign ult i64 %blen.i593, 8
  br i1 %fits_sso.i610, label %build_sso.i626, label %alloc_heap.i611

build_sso.i626:                                   ; preds = %build.i608
  store i56 0, ptr %out_sso.i590.sroa.6.sroa.5.sroa.0, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i590.sroa.6.sroa.5.sroa.0, ptr nonnull align 4 %btmp.i589, i64 %blen.i593, i1 false)
  %out_sso.i590.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i597, 8097884940793806848
  %out_sso.i590.sroa.6.sroa.5.sroa.0.0.out_sso.i590.sroa.6.sroa.5.sroa.0.0.out_sso.i590.sroa.6.sroa.5.sroa.0.0.out_sso.i590.sroa.6.sroa.5.sroa.0.0.out_sso.i590.sroa.6.sroa.5.0.out_sso.i590.sroa.6.8.rw1.i632 = load i56, ptr %out_sso.i590.sroa.6.sroa.5.sroa.0, align 8
  %out_sso.i590.sroa.6.sroa.5.0.insert.ext = zext i56 %out_sso.i590.sroa.6.sroa.5.sroa.0.0.out_sso.i590.sroa.6.sroa.5.sroa.0.0.out_sso.i590.sroa.6.sroa.5.sroa.0.0.out_sso.i590.sroa.6.sroa.5.sroa.0.0.out_sso.i590.sroa.6.sroa.5.0.out_sso.i590.sroa.6.8.rw1.i632 to i64
  %out_sso.i590.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i590.sroa.6.sroa.5.0.insert.ext, 8
  %out_sso.i590.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i590.sroa.6.sroa.5.0.insert.shift, 61
  %rs0.i633 = insertvalue %ArchxStr poison, i64 %out_sso.i590.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i634 = insertvalue %ArchxStr %rs0.i633, i64 %out_sso.i590.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit641

alloc_heap.i611:                                  ; preds = %build.i608.thread, %build.i608
  %bptr.i6092208 = phi ptr [ %blptr.i607, %build.i608.thread ], [ %btmp.i589, %build.i608 ]
  %hp.i612 = call noalias align 16 ptr @malloc(i64 %tot.i597)
  %hnull.i613 = icmp eq ptr %hp.i612, null
  br i1 %hnull.i613, label %oom.i625, label %copy_long.i614

copy_long.i614:                                   ; preds = %alloc_heap.i611
  %hp_i.i615 = ptrtoint ptr %hp.i612 to i64
  %htagged.i616 = or disjoint i64 %hp_i.i615, 1
  store i32 1885435763, ptr %hp.i612, align 16
  %atmp.i588.sroa.5.0.hp.i612.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i612, i64 4
  store i8 61, ptr %atmp.i588.sroa.5.0.hp.i612.sroa_idx, align 4
  %dst_b.i617 = getelementptr inbounds nuw i8, ptr %hp.i612, i64 5
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i617, ptr nonnull align 1 %bptr.i6092208, i64 %blen.i593, i1 false)
  %w0_out.i621 = or disjoint i64 %tot.i597, 8097884940793806848
  %ls0.i622 = insertvalue %ArchxStr poison, i64 %w0_out.i621, 0
  %ls1.i623 = insertvalue %ArchxStr %ls0.i622, i64 %htagged.i616, 1
  br label %archx_str_concat.exit641

archx_str_concat.exit641:                         ; preds = %archx_str_from_int.exit1486, %build_sso.i626, %copy_long.i614
  %common.ret.op.i624 = phi %ArchxStr [ %rs1.i634, %build_sso.i626 ], [ %ls1.i623, %copy_long.i614 ], [ { i64 8097884940793806853, i64 61 }, %archx_str_from_int.exit1486 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i589)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i642)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i644)
  %aw0.i645 = extractvalue %ArchxStr %common.ret.op.i624, 0
  %aw1.i646 = extractvalue %ArchxStr %common.ret.op.i624, 1
  %alen.i647 = and i64 %aw0.i645, 4294967295
  %az.i648 = icmp eq i64 %alen.i647, 0
  br i1 %az.i648, label %archx_str_concat.exit695, label %chk_bz.i649

chk_bz.i649:                                      ; preds = %archx_str_concat.exit641
  %tot.i651 = add nuw nsw i64 %alen.i647, 1
  %too_big.i652 = icmp samesign ugt i64 %alen.i647, 2147483646
  br i1 %too_big.i652, label %oom.i679, label %mat_a.i653

oom.i679:                                         ; preds = %alloc_heap.i665, %chk_bz.i649
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i653:                                       ; preds = %chk_bz.i649
  %ashort.i654 = icmp samesign ult i64 %alen.i647, 13
  br i1 %ashort.i654, label %mat_b.i658, label %mat_b.i658.thread

mat_b.i658.thread:                                ; preds = %mat_a.i653
  %araw.i656 = and i64 %aw1.i646, -4
  %alptr.i657 = inttoptr i64 %araw.i656 to ptr
  br label %alloc_heap.i665

mat_b.i658:                                       ; preds = %mat_a.i653
  %ap4.i690 = lshr i64 %aw0.i645, 32
  %ap4_32.i691 = trunc nuw i64 %ap4.i690 to i32
  store i32 %ap4_32.i691, ptr %atmp.i642, align 4
  %atmp4.i692 = getelementptr inbounds nuw i8, ptr %atmp.i642, i64 4
  store i64 %aw1.i646, ptr %atmp4.i692, align 4
  %fits_sso.i664.not = icmp eq i64 %alen.i647, 12
  br i1 %fits_sso.i664.not, label %alloc_heap.i665, label %build_sso.i680

build_sso.i680:                                   ; preds = %mat_b.i658
  %out_sso8.i681 = getelementptr inbounds nuw i8, ptr %out_sso.i644, i64 8
  %tot32.i682 = trunc nuw nsw i64 %tot.i651 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i644, i8 0, i64 16, i1 false)
  store i32 %tot32.i682, ptr %out_sso.i644, align 8
  %sso_dst_a.i683 = getelementptr inbounds nuw i8, ptr %out_sso.i644, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i683, ptr nonnull align 4 %atmp.i642, i64 %alen.i647, i1 false)
  %sso_dst_b.i684 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i683, i64 %alen.i647
  store i8 44, ptr %sso_dst_b.i684, align 1
  %rw0.i685 = load i64, ptr %out_sso.i644, align 8
  %rw1.i686 = load i64, ptr %out_sso8.i681, align 8
  %rs0.i687 = insertvalue %ArchxStr poison, i64 %rw0.i685, 0
  %rs1.i688 = insertvalue %ArchxStr %rs0.i687, i64 %rw1.i686, 1
  br label %archx_str_concat.exit695

alloc_heap.i665:                                  ; preds = %mat_b.i658.thread, %mat_b.i658
  %aptr.i6591991 = phi ptr [ %alptr.i657, %mat_b.i658.thread ], [ %atmp.i642, %mat_b.i658 ]
  %hp.i666 = call noalias align 16 ptr @malloc(i64 %tot.i651)
  %hnull.i667 = icmp eq ptr %hp.i666, null
  br i1 %hnull.i667, label %oom.i679, label %copy_long.i668

copy_long.i668:                                   ; preds = %alloc_heap.i665
  %hp_i.i669 = ptrtoint ptr %hp.i666 to i64
  %htagged.i670 = or disjoint i64 %hp_i.i669, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i666, ptr nonnull align 1 %aptr.i6591991, i64 %alen.i647, i1 false)
  %dst_b.i671 = getelementptr inbounds nuw i8, ptr %hp.i666, i64 %alen.i647
  store i8 44, ptr %dst_b.i671, align 1
  %pref32.i672 = load i32, ptr %hp.i666, align 16
  %pref64.i673 = zext i32 %pref32.i672 to i64
  %pref_sh.i674 = shl nuw i64 %pref64.i673, 32
  %w0_out.i675 = or disjoint i64 %pref_sh.i674, %tot.i651
  %ls0.i676 = insertvalue %ArchxStr poison, i64 %w0_out.i675, 0
  %ls1.i677 = insertvalue %ArchxStr %ls0.i676, i64 %htagged.i670, 1
  br label %archx_str_concat.exit695

archx_str_concat.exit695:                         ; preds = %archx_str_concat.exit641, %build_sso.i680, %copy_long.i668
  %common.ret.op.i678 = phi %ArchxStr [ %rs1.i688, %build_sso.i680 ], [ %ls1.i677, %copy_long.i668 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit641 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i642)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i644)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1490)
  %n32.i1491 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1490, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 10)
  %len.i1492 = sext i32 %n32.i1491 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1489)
  %z.i.i1493 = icmp slt i32 %n32.i1491, 1
  br i1 %z.i.i1493, label %archx_str_from_int.exit1517, label %chk_sso.i.i1494

oom.i.i1509:                                      ; preds = %alloc_heap.i.i1496
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1494:                                  ; preds = %archx_str_concat.exit695
  %short.i.i1495 = icmp samesign ult i32 %n32.i1491, 13
  br i1 %short.i.i1495, label %pack_sso.i.i1510, label %alloc_heap.i.i1496

pack_sso.i.i1510:                                 ; preds = %chk_sso.i.i1494
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1489, i8 0, i64 16, i1 false)
  store i32 %n32.i1491, ptr %sso.i.i1489, align 8
  %sso.i.i1489.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1489, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1489.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1490, i64 range(i64 -2147483648, 2147483650) %len.i1492, i1 false)
  %sso.i.i1489.0.sso.i.i1489.0.sso.i.i1489.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1512 = load i64, ptr %sso.i.i1489, align 8
  %sso.i.i1489.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1489, i64 8
  %sso.i.i1489.8.sso.i.i1489.8.sso.i.i1489.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1514 = load i64, ptr %sso.i.i1489.8.sroa_idx, align 8
  %ss0.i.i1515 = insertvalue %ArchxStr poison, i64 %sso.i.i1489.0.sso.i.i1489.0.sso.i.i1489.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1512, 0
  %ss1.i.i1516 = insertvalue %ArchxStr %ss0.i.i1515, i64 %sso.i.i1489.8.sso.i.i1489.8.sso.i.i1489.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1514, 1
  br label %archx_str_from_int.exit1517

alloc_heap.i.i1496:                               ; preds = %chk_sso.i.i1494
  %hp.i.i1497 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1492)
  %hnull.i.i1498 = icmp eq ptr %hp.i.i1497, null
  br i1 %hnull.i.i1498, label %oom.i.i1509, label %copy_long.i.i1499

copy_long.i.i1499:                                ; preds = %alloc_heap.i.i1496
  %hp_i.i.i1500 = ptrtoint ptr %hp.i.i1497 to i64
  %htagged.i.i1501 = or disjoint i64 %hp_i.i.i1500, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1497, ptr nonnull readonly align 8 %buf.i1490, i64 range(i64 -2147483648, 2147483650) %len.i1492, i1 false)
  %pref32.i.i1502 = load i32, ptr %hp.i.i1497, align 16
  %pref64.i.i1503 = zext i32 %pref32.i.i1502 to i64
  %pref_sh.i.i1504 = shl nuw i64 %pref64.i.i1503, 32
  %w0_out.i.i1505 = or disjoint i64 %pref_sh.i.i1504, %len.i1492
  %ls0.i.i1506 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1505, 0
  %ls1.i.i1507 = insertvalue %ArchxStr %ls0.i.i1506, i64 %htagged.i.i1501, 1
  br label %archx_str_from_int.exit1517

archx_str_from_int.exit1517:                      ; preds = %archx_str_concat.exit695, %pack_sso.i.i1510, %copy_long.i.i1499
  %common.ret.op.i.i1508 = phi %ArchxStr [ %ss1.i.i1516, %pack_sso.i.i1510 ], [ %ls1.i.i1507, %copy_long.i.i1499 ], [ zeroinitializer, %archx_str_concat.exit695 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1489)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1490)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i696)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i697)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i698)
  %aw0.i699 = extractvalue %ArchxStr %common.ret.op.i678, 0
  %aw1.i700 = extractvalue %ArchxStr %common.ret.op.i678, 1
  %bw0.i701 = extractvalue %ArchxStr %common.ret.op.i.i1508, 0
  %bw1.i702 = extractvalue %ArchxStr %common.ret.op.i.i1508, 1
  %alen.i703 = and i64 %aw0.i699, 4294967295
  %blen.i704 = and i64 %bw0.i701, 4294967295
  %az.i705 = icmp eq i64 %alen.i703, 0
  br i1 %az.i705, label %ret_b_clone.i759, label %chk_bz.i706

ret_b_clone.i759:                                 ; preds = %archx_str_from_int.exit1517
  %long.i1520 = icmp samesign ult i64 %blen.i704, 13
  %tag.i1524 = and i64 %bw1.i702, 3
  %owned.not.i1525 = icmp eq i64 %tag.i1524, 0
  %or.cond2077 = select i1 %long.i1520, i1 true, i1 %owned.not.i1525
  br i1 %or.cond2077, label %archx_str_concat.exit761, label %dup_heap.i1526

dup_heap.i1526:                                   ; preds = %ret_b_clone.i759
  %dst.i1527 = call noalias align 16 ptr @malloc(i64 %blen.i704)
  %isnull.i1528 = icmp eq ptr %dst.i1527, null
  br i1 %isnull.i1528, label %oom.i1535, label %copy.i1529

oom.i1535:                                        ; preds = %dup_heap.i1526
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1529:                                       ; preds = %dup_heap.i1526
  %src_i.i1530 = and i64 %bw1.i702, -4
  %src.i1531 = inttoptr i64 %src_i.i1530 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1527, ptr nonnull align 4 %src.i1531, i64 %blen.i704, i1 false)
  %dst_i.i1532 = ptrtoint ptr %dst.i1527 to i64
  %tagged.i1533 = or disjoint i64 %dst_i.i1532, 1
  %out.i1534 = insertvalue %ArchxStr %common.ret.op.i.i1508, i64 %tagged.i1533, 1
  br label %archx_str_concat.exit761

chk_bz.i706:                                      ; preds = %archx_str_from_int.exit1517
  %bz.i707 = icmp eq i64 %blen.i704, 0
  br i1 %bz.i707, label %ret_a_clone.i757, label %calc_tot.i708

ret_a_clone.i757:                                 ; preds = %chk_bz.i706
  %long.i1539 = icmp samesign ult i64 %alen.i703, 13
  %tag.i1543 = and i64 %aw1.i700, 3
  %owned.not.i1544 = icmp eq i64 %tag.i1543, 0
  %or.cond2078 = select i1 %long.i1539, i1 true, i1 %owned.not.i1544
  br i1 %or.cond2078, label %archx_str_concat.exit761, label %dup_heap.i1545

dup_heap.i1545:                                   ; preds = %ret_a_clone.i757
  %dst.i1546 = call noalias align 16 ptr @malloc(i64 %alen.i703)
  %isnull.i1547 = icmp eq ptr %dst.i1546, null
  br i1 %isnull.i1547, label %oom.i1554, label %copy.i1548

oom.i1554:                                        ; preds = %dup_heap.i1545
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1548:                                       ; preds = %dup_heap.i1545
  %src_i.i1549 = and i64 %aw1.i700, -4
  %src.i1550 = inttoptr i64 %src_i.i1549 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1546, ptr nonnull align 4 %src.i1550, i64 %alen.i703, i1 false)
  %dst_i.i1551 = ptrtoint ptr %dst.i1546 to i64
  %tagged.i1552 = or disjoint i64 %dst_i.i1551, 1
  %out.i1553 = insertvalue %ArchxStr %common.ret.op.i678, i64 %tagged.i1552, 1
  br label %archx_str_concat.exit761

calc_tot.i708:                                    ; preds = %chk_bz.i706
  %tot.i709 = add nuw nsw i64 %blen.i704, %alen.i703
  %too_big.i710 = icmp samesign ugt i64 %tot.i709, 2147483647
  br i1 %too_big.i710, label %oom.i739, label %mat_a.i711

oom.i739:                                         ; preds = %alloc_heap.i725, %calc_tot.i708
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i711:                                       ; preds = %calc_tot.i708
  %ashort.i712 = icmp samesign ult i64 %alen.i703, 13
  br i1 %ashort.i712, label %mat_a_short.i753, label %mat_a_long.i713

mat_a_short.i753:                                 ; preds = %mat_a.i711
  %ap4.i754 = lshr i64 %aw0.i699, 32
  %ap4_32.i755 = trunc nuw i64 %ap4.i754 to i32
  store i32 %ap4_32.i755, ptr %atmp.i696, align 4
  %atmp4.i756 = getelementptr inbounds nuw i8, ptr %atmp.i696, i64 4
  store i64 %aw1.i700, ptr %atmp4.i756, align 4
  br label %mat_b.i716

mat_a_long.i713:                                  ; preds = %mat_a.i711
  %araw.i714 = and i64 %aw1.i700, -4
  %alptr.i715 = inttoptr i64 %araw.i714 to ptr
  br label %mat_b.i716

mat_b.i716:                                       ; preds = %mat_a_long.i713, %mat_a_short.i753
  %aptr.i717 = phi ptr [ %atmp.i696, %mat_a_short.i753 ], [ %alptr.i715, %mat_a_long.i713 ]
  %bshort.i718 = icmp samesign ult i64 %blen.i704, 13
  br i1 %bshort.i718, label %mat_b_short.i749, label %mat_b_long.i719

mat_b_short.i749:                                 ; preds = %mat_b.i716
  %bp4.i750 = lshr i64 %bw0.i701, 32
  %bp4_32.i751 = trunc nuw i64 %bp4.i750 to i32
  store i32 %bp4_32.i751, ptr %btmp.i697, align 4
  %btmp4.i752 = getelementptr inbounds nuw i8, ptr %btmp.i697, i64 4
  store i64 %bw1.i702, ptr %btmp4.i752, align 4
  br label %build.i722

mat_b_long.i719:                                  ; preds = %mat_b.i716
  %braw.i720 = and i64 %bw1.i702, -4
  %blptr.i721 = inttoptr i64 %braw.i720 to ptr
  br label %build.i722

build.i722:                                       ; preds = %mat_b_long.i719, %mat_b_short.i749
  %bptr.i723 = phi ptr [ %btmp.i697, %mat_b_short.i749 ], [ %blptr.i721, %mat_b_long.i719 ]
  %fits_sso.i724 = icmp samesign ult i64 %tot.i709, 13
  br i1 %fits_sso.i724, label %build_sso.i740, label %alloc_heap.i725

build_sso.i740:                                   ; preds = %build.i722
  %out_sso8.i741 = getelementptr inbounds nuw i8, ptr %out_sso.i698, i64 8
  %tot32.i742 = trunc nuw nsw i64 %tot.i709 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i698, i8 0, i64 16, i1 false)
  store i32 %tot32.i742, ptr %out_sso.i698, align 8
  %sso_dst_a.i743 = getelementptr inbounds nuw i8, ptr %out_sso.i698, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i743, ptr nonnull align 1 %aptr.i717, i64 %alen.i703, i1 false)
  %sso_dst_b.i744 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i743, i64 %alen.i703
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i744, ptr nonnull align 1 %bptr.i723, i64 %blen.i704, i1 false)
  %rw0.i745 = load i64, ptr %out_sso.i698, align 8
  %rw1.i746 = load i64, ptr %out_sso8.i741, align 8
  %rs0.i747 = insertvalue %ArchxStr poison, i64 %rw0.i745, 0
  %rs1.i748 = insertvalue %ArchxStr %rs0.i747, i64 %rw1.i746, 1
  br label %archx_str_concat.exit761

alloc_heap.i725:                                  ; preds = %build.i722
  %hp.i726 = call noalias align 16 ptr @malloc(i64 %tot.i709)
  %hnull.i727 = icmp eq ptr %hp.i726, null
  br i1 %hnull.i727, label %oom.i739, label %copy_long.i728

copy_long.i728:                                   ; preds = %alloc_heap.i725
  %hp_i.i729 = ptrtoint ptr %hp.i726 to i64
  %htagged.i730 = or disjoint i64 %hp_i.i729, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i726, ptr nonnull align 1 %aptr.i717, i64 %alen.i703, i1 false)
  %dst_b.i731 = getelementptr inbounds nuw i8, ptr %hp.i726, i64 %alen.i703
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i731, ptr nonnull align 1 %bptr.i723, i64 %blen.i704, i1 false)
  %pref32.i732 = load i32, ptr %hp.i726, align 16
  %pref64.i733 = zext i32 %pref32.i732 to i64
  %pref_sh.i734 = shl nuw i64 %pref64.i733, 32
  %w0_out.i735 = or disjoint i64 %pref_sh.i734, %tot.i709
  %ls0.i736 = insertvalue %ArchxStr poison, i64 %w0_out.i735, 0
  %ls1.i737 = insertvalue %ArchxStr %ls0.i736, i64 %htagged.i730, 1
  br label %archx_str_concat.exit761

archx_str_concat.exit761:                         ; preds = %copy.i1548, %ret_a_clone.i757, %copy.i1529, %ret_b_clone.i759, %build_sso.i740, %copy_long.i728
  %common.ret.op.i738 = phi %ArchxStr [ %rs1.i748, %build_sso.i740 ], [ %ls1.i737, %copy_long.i728 ], [ %out.i1534, %copy.i1529 ], [ %common.ret.op.i.i1508, %ret_b_clone.i759 ], [ %out.i1553, %copy.i1548 ], [ %common.ret.op.i678, %ret_a_clone.i757 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i696)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i697)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i698)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i762)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i764)
  %aw0.i765 = extractvalue %ArchxStr %common.ret.op.i738, 0
  %aw1.i766 = extractvalue %ArchxStr %common.ret.op.i738, 1
  %alen.i767 = and i64 %aw0.i765, 4294967295
  %az.i768 = icmp eq i64 %alen.i767, 0
  br i1 %az.i768, label %archx_str_concat.exit815, label %chk_bz.i769

chk_bz.i769:                                      ; preds = %archx_str_concat.exit761
  %tot.i771 = add nuw nsw i64 %alen.i767, 5
  %too_big.i772 = icmp samesign ugt i64 %alen.i767, 2147483642
  br i1 %too_big.i772, label %oom.i799, label %mat_a.i773

oom.i799:                                         ; preds = %alloc_heap.i785, %chk_bz.i769
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i773:                                       ; preds = %chk_bz.i769
  %ashort.i774 = icmp samesign ult i64 %alen.i767, 13
  br i1 %ashort.i774, label %mat_b.i778, label %mat_b.i778.thread

mat_b.i778.thread:                                ; preds = %mat_a.i773
  %araw.i776 = and i64 %aw1.i766, -4
  %alptr.i777 = inttoptr i64 %araw.i776 to ptr
  br label %alloc_heap.i785

mat_b.i778:                                       ; preds = %mat_a.i773
  %ap4.i810 = lshr i64 %aw0.i765, 32
  %ap4_32.i811 = trunc nuw i64 %ap4.i810 to i32
  store i32 %ap4_32.i811, ptr %atmp.i762, align 4
  %atmp4.i812 = getelementptr inbounds nuw i8, ptr %atmp.i762, i64 4
  store i64 %aw1.i766, ptr %atmp4.i812, align 4
  %fits_sso.i784 = icmp samesign ult i64 %alen.i767, 8
  br i1 %fits_sso.i784, label %build_sso.i800, label %alloc_heap.i785

build_sso.i800:                                   ; preds = %mat_b.i778
  %out_sso8.i801 = getelementptr inbounds nuw i8, ptr %out_sso.i764, i64 8
  %tot32.i802 = trunc nuw nsw i64 %tot.i771 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i764, i8 0, i64 16, i1 false)
  store i32 %tot32.i802, ptr %out_sso.i764, align 8
  %sso_dst_a.i803 = getelementptr inbounds nuw i8, ptr %out_sso.i764, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i803, ptr nonnull align 4 %atmp.i762, i64 %alen.i767, i1 false)
  %sso_dst_b.i804 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i803, i64 %alen.i767
  store i32 1886745632, ptr %sso_dst_b.i804, align 1
  %btmp.i763.sroa.5.0.sso_dst_b.i804.sroa_idx = getelementptr inbounds nuw i8, ptr %sso_dst_b.i804, i64 4
  store i8 61, ptr %btmp.i763.sroa.5.0.sso_dst_b.i804.sroa_idx, align 1
  %rw0.i805 = load i64, ptr %out_sso.i764, align 8
  %rw1.i806 = load i64, ptr %out_sso8.i801, align 8
  %rs0.i807 = insertvalue %ArchxStr poison, i64 %rw0.i805, 0
  %rs1.i808 = insertvalue %ArchxStr %rs0.i807, i64 %rw1.i806, 1
  br label %archx_str_concat.exit815

alloc_heap.i785:                                  ; preds = %mat_b.i778.thread, %mat_b.i778
  %aptr.i7791994 = phi ptr [ %alptr.i777, %mat_b.i778.thread ], [ %atmp.i762, %mat_b.i778 ]
  %hp.i786 = call noalias align 16 ptr @malloc(i64 %tot.i771)
  %hnull.i787 = icmp eq ptr %hp.i786, null
  br i1 %hnull.i787, label %oom.i799, label %copy_long.i788

copy_long.i788:                                   ; preds = %alloc_heap.i785
  %hp_i.i789 = ptrtoint ptr %hp.i786 to i64
  %htagged.i790 = or disjoint i64 %hp_i.i789, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i786, ptr nonnull align 1 %aptr.i7791994, i64 %alen.i767, i1 false)
  %dst_b.i791 = getelementptr inbounds nuw i8, ptr %hp.i786, i64 %alen.i767
  store i32 1886745632, ptr %dst_b.i791, align 1
  %btmp.i763.sroa.5.0.dst_b.i791.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i791, i64 4
  store i8 61, ptr %btmp.i763.sroa.5.0.dst_b.i791.sroa_idx, align 1
  %pref32.i792 = load i32, ptr %hp.i786, align 16
  %pref64.i793 = zext i32 %pref32.i792 to i64
  %pref_sh.i794 = shl nuw i64 %pref64.i793, 32
  %w0_out.i795 = or disjoint i64 %pref_sh.i794, %tot.i771
  %ls0.i796 = insertvalue %ArchxStr poison, i64 %w0_out.i795, 0
  %ls1.i797 = insertvalue %ArchxStr %ls0.i796, i64 %htagged.i790, 1
  br label %archx_str_concat.exit815

archx_str_concat.exit815:                         ; preds = %archx_str_concat.exit761, %build_sso.i800, %copy_long.i788
  %common.ret.op.i798 = phi %ArchxStr [ %rs1.i808, %build_sso.i800 ], [ %ls1.i797, %copy_long.i788 ], [ { i64 8103510785310851077, i64 61 }, %archx_str_concat.exit761 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i762)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i764)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i816)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i818)
  %aw0.i819 = extractvalue %ArchxStr %common.ret.op.i798, 0
  %aw1.i820 = extractvalue %ArchxStr %common.ret.op.i798, 1
  %alen.i821 = and i64 %aw0.i819, 4294967295
  %az.i822 = icmp eq i64 %alen.i821, 0
  br i1 %az.i822, label %archx_str_concat.exit869, label %chk_bz.i823

chk_bz.i823:                                      ; preds = %archx_str_concat.exit815
  %tot.i825 = add nuw nsw i64 %alen.i821, 5
  %too_big.i826 = icmp samesign ugt i64 %alen.i821, 2147483642
  br i1 %too_big.i826, label %oom.i853, label %mat_a.i827

oom.i853:                                         ; preds = %alloc_heap.i839, %chk_bz.i823
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i827:                                       ; preds = %chk_bz.i823
  %ashort.i828 = icmp samesign ult i64 %alen.i821, 13
  br i1 %ashort.i828, label %mat_b.i832, label %mat_b.i832.thread

mat_b.i832.thread:                                ; preds = %mat_a.i827
  %araw.i830 = and i64 %aw1.i820, -4
  %alptr.i831 = inttoptr i64 %araw.i830 to ptr
  br label %alloc_heap.i839

mat_b.i832:                                       ; preds = %mat_a.i827
  %ap4.i864 = lshr i64 %aw0.i819, 32
  %ap4_32.i865 = trunc nuw i64 %ap4.i864 to i32
  store i32 %ap4_32.i865, ptr %atmp.i816, align 4
  %atmp4.i866 = getelementptr inbounds nuw i8, ptr %atmp.i816, i64 4
  store i64 %aw1.i820, ptr %atmp4.i866, align 4
  %fits_sso.i838 = icmp samesign ult i64 %alen.i821, 8
  br i1 %fits_sso.i838, label %build_sso.i854, label %alloc_heap.i839

build_sso.i854:                                   ; preds = %mat_b.i832
  %out_sso8.i855 = getelementptr inbounds nuw i8, ptr %out_sso.i818, i64 8
  %tot32.i856 = trunc nuw nsw i64 %tot.i825 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i818, i8 0, i64 16, i1 false)
  store i32 %tot32.i856, ptr %out_sso.i818, align 8
  %sso_dst_a.i857 = getelementptr inbounds nuw i8, ptr %out_sso.i818, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i857, ptr nonnull align 4 %atmp.i816, i64 %alen.i821, i1 false)
  %sso_dst_b.i858 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i857, i64 %alen.i821
  store i32 1751347809, ptr %sso_dst_b.i858, align 1
  %btmp.i817.sroa.5.0.sso_dst_b.i858.sroa_idx = getelementptr inbounds nuw i8, ptr %sso_dst_b.i858, i64 4
  store i8 120, ptr %btmp.i817.sroa.5.0.sso_dst_b.i858.sroa_idx, align 1
  %rw0.i859 = load i64, ptr %out_sso.i818, align 8
  %rw1.i860 = load i64, ptr %out_sso8.i855, align 8
  %rs0.i861 = insertvalue %ArchxStr poison, i64 %rw0.i859, 0
  %rs1.i862 = insertvalue %ArchxStr %rs0.i861, i64 %rw1.i860, 1
  br label %archx_str_concat.exit869

alloc_heap.i839:                                  ; preds = %mat_b.i832.thread, %mat_b.i832
  %aptr.i8331997 = phi ptr [ %alptr.i831, %mat_b.i832.thread ], [ %atmp.i816, %mat_b.i832 ]
  %hp.i840 = call noalias align 16 ptr @malloc(i64 %tot.i825)
  %hnull.i841 = icmp eq ptr %hp.i840, null
  br i1 %hnull.i841, label %oom.i853, label %copy_long.i842

copy_long.i842:                                   ; preds = %alloc_heap.i839
  %hp_i.i843 = ptrtoint ptr %hp.i840 to i64
  %htagged.i844 = or disjoint i64 %hp_i.i843, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i840, ptr nonnull align 1 %aptr.i8331997, i64 %alen.i821, i1 false)
  %dst_b.i845 = getelementptr inbounds nuw i8, ptr %hp.i840, i64 %alen.i821
  store i32 1751347809, ptr %dst_b.i845, align 1
  %btmp.i817.sroa.5.0.dst_b.i845.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i845, i64 4
  store i8 120, ptr %btmp.i817.sroa.5.0.dst_b.i845.sroa_idx, align 1
  %pref32.i846 = load i32, ptr %hp.i840, align 16
  %pref64.i847 = zext i32 %pref32.i846 to i64
  %pref_sh.i848 = shl nuw i64 %pref64.i847, 32
  %w0_out.i849 = or disjoint i64 %pref_sh.i848, %tot.i825
  %ls0.i850 = insertvalue %ArchxStr poison, i64 %w0_out.i849, 0
  %ls1.i851 = insertvalue %ArchxStr %ls0.i850, i64 %htagged.i844, 1
  br label %archx_str_concat.exit869

archx_str_concat.exit869:                         ; preds = %archx_str_concat.exit815, %build_sso.i854, %copy_long.i842
  %common.ret.op.i852 = phi %ArchxStr [ %rs1.i862, %build_sso.i854 ], [ %ls1.i851, %copy_long.i842 ], [ { i64 7521981563576254469, i64 120 }, %archx_str_concat.exit815 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i816)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i818)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i870)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i872)
  %aw0.i873 = extractvalue %ArchxStr %common.ret.op.i852, 0
  %aw1.i874 = extractvalue %ArchxStr %common.ret.op.i852, 1
  %alen.i875 = and i64 %aw0.i873, 4294967295
  %az.i876 = icmp eq i64 %alen.i875, 0
  br i1 %az.i876, label %archx_str_concat.exit923, label %chk_bz.i877

chk_bz.i877:                                      ; preds = %archx_str_concat.exit869
  %tot.i879 = add nuw nsw i64 %alen.i875, 1
  %too_big.i880 = icmp samesign ugt i64 %alen.i875, 2147483646
  br i1 %too_big.i880, label %oom.i907, label %mat_a.i881

oom.i907:                                         ; preds = %alloc_heap.i893, %chk_bz.i877
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i881:                                       ; preds = %chk_bz.i877
  %ashort.i882 = icmp samesign ult i64 %alen.i875, 13
  br i1 %ashort.i882, label %mat_b.i886, label %mat_b.i886.thread

mat_b.i886.thread:                                ; preds = %mat_a.i881
  %araw.i884 = and i64 %aw1.i874, -4
  %alptr.i885 = inttoptr i64 %araw.i884 to ptr
  br label %alloc_heap.i893

mat_b.i886:                                       ; preds = %mat_a.i881
  %ap4.i918 = lshr i64 %aw0.i873, 32
  %ap4_32.i919 = trunc nuw i64 %ap4.i918 to i32
  store i32 %ap4_32.i919, ptr %atmp.i870, align 4
  %atmp4.i920 = getelementptr inbounds nuw i8, ptr %atmp.i870, i64 4
  store i64 %aw1.i874, ptr %atmp4.i920, align 4
  %fits_sso.i892.not = icmp eq i64 %alen.i875, 12
  br i1 %fits_sso.i892.not, label %alloc_heap.i893, label %build_sso.i908

build_sso.i908:                                   ; preds = %mat_b.i886
  %out_sso8.i909 = getelementptr inbounds nuw i8, ptr %out_sso.i872, i64 8
  %tot32.i910 = trunc nuw nsw i64 %tot.i879 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i872, i8 0, i64 16, i1 false)
  store i32 %tot32.i910, ptr %out_sso.i872, align 8
  %sso_dst_a.i911 = getelementptr inbounds nuw i8, ptr %out_sso.i872, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i911, ptr nonnull align 4 %atmp.i870, i64 %alen.i875, i1 false)
  %sso_dst_b.i912 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i911, i64 %alen.i875
  store i8 58, ptr %sso_dst_b.i912, align 1
  %rw0.i913 = load i64, ptr %out_sso.i872, align 8
  %rw1.i914 = load i64, ptr %out_sso8.i909, align 8
  %rs0.i915 = insertvalue %ArchxStr poison, i64 %rw0.i913, 0
  %rs1.i916 = insertvalue %ArchxStr %rs0.i915, i64 %rw1.i914, 1
  br label %archx_str_concat.exit923

alloc_heap.i893:                                  ; preds = %mat_b.i886.thread, %mat_b.i886
  %aptr.i8872000 = phi ptr [ %alptr.i885, %mat_b.i886.thread ], [ %atmp.i870, %mat_b.i886 ]
  %hp.i894 = call noalias align 16 ptr @malloc(i64 %tot.i879)
  %hnull.i895 = icmp eq ptr %hp.i894, null
  br i1 %hnull.i895, label %oom.i907, label %copy_long.i896

copy_long.i896:                                   ; preds = %alloc_heap.i893
  %hp_i.i897 = ptrtoint ptr %hp.i894 to i64
  %htagged.i898 = or disjoint i64 %hp_i.i897, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i894, ptr nonnull align 1 %aptr.i8872000, i64 %alen.i875, i1 false)
  %dst_b.i899 = getelementptr inbounds nuw i8, ptr %hp.i894, i64 %alen.i875
  store i8 58, ptr %dst_b.i899, align 1
  %pref32.i900 = load i32, ptr %hp.i894, align 16
  %pref64.i901 = zext i32 %pref32.i900 to i64
  %pref_sh.i902 = shl nuw i64 %pref64.i901, 32
  %w0_out.i903 = or disjoint i64 %pref_sh.i902, %tot.i879
  %ls0.i904 = insertvalue %ArchxStr poison, i64 %w0_out.i903, 0
  %ls1.i905 = insertvalue %ArchxStr %ls0.i904, i64 %htagged.i898, 1
  br label %archx_str_concat.exit923

archx_str_concat.exit923:                         ; preds = %archx_str_concat.exit869, %build_sso.i908, %copy_long.i896
  %common.ret.op.i906 = phi %ArchxStr [ %rs1.i916, %build_sso.i908 ], [ %ls1.i905, %copy_long.i896 ], [ { i64 249108103169, i64 0 }, %archx_str_concat.exit869 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i870)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i872)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i924)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i926)
  %aw0.i927 = extractvalue %ArchxStr %common.ret.op.i906, 0
  %aw1.i928 = extractvalue %ArchxStr %common.ret.op.i906, 1
  %alen.i929 = and i64 %aw0.i927, 4294967295
  %az.i930 = icmp eq i64 %alen.i929, 0
  br i1 %az.i930, label %archx_str_concat.exit977, label %chk_bz.i931

chk_bz.i931:                                      ; preds = %archx_str_concat.exit923
  %tot.i933 = add nuw nsw i64 %alen.i929, 4
  %too_big.i934 = icmp samesign ugt i64 %alen.i929, 2147483643
  br i1 %too_big.i934, label %oom.i961, label %mat_a.i935

oom.i961:                                         ; preds = %alloc_heap.i947, %chk_bz.i931
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i935:                                       ; preds = %chk_bz.i931
  %ashort.i936 = icmp samesign ult i64 %alen.i929, 13
  br i1 %ashort.i936, label %mat_b.i940, label %mat_b.i940.thread

mat_b.i940.thread:                                ; preds = %mat_a.i935
  %araw.i938 = and i64 %aw1.i928, -4
  %alptr.i939 = inttoptr i64 %araw.i938 to ptr
  br label %alloc_heap.i947

mat_b.i940:                                       ; preds = %mat_a.i935
  %ap4.i972 = lshr i64 %aw0.i927, 32
  %ap4_32.i973 = trunc nuw i64 %ap4.i972 to i32
  store i32 %ap4_32.i973, ptr %atmp.i924, align 4
  %atmp4.i974 = getelementptr inbounds nuw i8, ptr %atmp.i924, i64 4
  store i64 %aw1.i928, ptr %atmp4.i974, align 4
  %fits_sso.i946 = icmp samesign ult i64 %alen.i929, 9
  br i1 %fits_sso.i946, label %build_sso.i962, label %alloc_heap.i947

build_sso.i962:                                   ; preds = %mat_b.i940
  %out_sso8.i963 = getelementptr inbounds nuw i8, ptr %out_sso.i926, i64 8
  %tot32.i964 = trunc nuw nsw i64 %tot.i933 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i926, i8 0, i64 16, i1 false)
  store i32 %tot32.i964, ptr %out_sso.i926, align 8
  %sso_dst_a.i965 = getelementptr inbounds nuw i8, ptr %out_sso.i926, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i965, ptr nonnull align 4 %atmp.i924, i64 %alen.i929, i1 false)
  %sso_dst_b.i966 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i965, i64 %alen.i929
  store i32 1702195828, ptr %sso_dst_b.i966, align 1
  %rw0.i967 = load i64, ptr %out_sso.i926, align 8
  %rw1.i968 = load i64, ptr %out_sso8.i963, align 8
  %rs0.i969 = insertvalue %ArchxStr poison, i64 %rw0.i967, 0
  %rs1.i970 = insertvalue %ArchxStr %rs0.i969, i64 %rw1.i968, 1
  br label %archx_str_concat.exit977

alloc_heap.i947:                                  ; preds = %mat_b.i940.thread, %mat_b.i940
  %aptr.i9412003 = phi ptr [ %alptr.i939, %mat_b.i940.thread ], [ %atmp.i924, %mat_b.i940 ]
  %hp.i948 = call noalias align 16 ptr @malloc(i64 %tot.i933)
  %hnull.i949 = icmp eq ptr %hp.i948, null
  br i1 %hnull.i949, label %oom.i961, label %copy_long.i950

copy_long.i950:                                   ; preds = %alloc_heap.i947
  %hp_i.i951 = ptrtoint ptr %hp.i948 to i64
  %htagged.i952 = or disjoint i64 %hp_i.i951, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i948, ptr nonnull align 1 %aptr.i9412003, i64 %alen.i929, i1 false)
  %dst_b.i953 = getelementptr inbounds nuw i8, ptr %hp.i948, i64 %alen.i929
  store i32 1702195828, ptr %dst_b.i953, align 1
  %pref32.i954 = load i32, ptr %hp.i948, align 16
  %pref64.i955 = zext i32 %pref32.i954 to i64
  %pref_sh.i956 = shl nuw i64 %pref64.i955, 32
  %w0_out.i957 = or disjoint i64 %pref_sh.i956, %tot.i933
  %ls0.i958 = insertvalue %ArchxStr poison, i64 %w0_out.i957, 0
  %ls1.i959 = insertvalue %ArchxStr %ls0.i958, i64 %htagged.i952, 1
  br label %archx_str_concat.exit977

archx_str_concat.exit977:                         ; preds = %archx_str_concat.exit923, %build_sso.i962, %copy_long.i950
  %common.ret.op.i960 = phi %ArchxStr [ %rs1.i970, %build_sso.i962 ], [ %ls1.i959, %copy_long.i950 ], [ { i64 7310875412647641092, i64 0 }, %archx_str_concat.exit923 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i924)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i926)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i978)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i980)
  %aw0.i981 = extractvalue %ArchxStr %common.ret.op.i960, 0
  %aw1.i982 = extractvalue %ArchxStr %common.ret.op.i960, 1
  %alen.i983 = and i64 %aw0.i981, 4294967295
  %az.i984 = icmp eq i64 %alen.i983, 0
  br i1 %az.i984, label %archx_str_concat.exit1031, label %chk_bz.i985

chk_bz.i985:                                      ; preds = %archx_str_concat.exit977
  %tot.i987 = add nuw nsw i64 %alen.i983, 5
  %too_big.i988 = icmp samesign ugt i64 %alen.i983, 2147483642
  br i1 %too_big.i988, label %oom.i1015, label %mat_a.i989

oom.i1015:                                        ; preds = %alloc_heap.i1001, %chk_bz.i985
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i989:                                       ; preds = %chk_bz.i985
  %ashort.i990 = icmp samesign ult i64 %alen.i983, 13
  br i1 %ashort.i990, label %mat_b.i994, label %mat_b.i994.thread

mat_b.i994.thread:                                ; preds = %mat_a.i989
  %araw.i992 = and i64 %aw1.i982, -4
  %alptr.i993 = inttoptr i64 %araw.i992 to ptr
  br label %alloc_heap.i1001

mat_b.i994:                                       ; preds = %mat_a.i989
  %ap4.i1026 = lshr i64 %aw0.i981, 32
  %ap4_32.i1027 = trunc nuw i64 %ap4.i1026 to i32
  store i32 %ap4_32.i1027, ptr %atmp.i978, align 4
  %atmp4.i1028 = getelementptr inbounds nuw i8, ptr %atmp.i978, i64 4
  store i64 %aw1.i982, ptr %atmp4.i1028, align 4
  %fits_sso.i1000 = icmp samesign ult i64 %alen.i983, 8
  br i1 %fits_sso.i1000, label %build_sso.i1016, label %alloc_heap.i1001

build_sso.i1016:                                  ; preds = %mat_b.i994
  %out_sso8.i1017 = getelementptr inbounds nuw i8, ptr %out_sso.i980, i64 8
  %tot32.i1018 = trunc nuw nsw i64 %tot.i987 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i980, i8 0, i64 16, i1 false)
  store i32 %tot32.i1018, ptr %out_sso.i980, align 8
  %sso_dst_a.i1019 = getelementptr inbounds nuw i8, ptr %out_sso.i980, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1019, ptr nonnull align 4 %atmp.i978, i64 %alen.i983, i1 false)
  %sso_dst_b.i1020 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1019, i64 %alen.i983
  store i32 1852140576, ptr %sso_dst_b.i1020, align 1
  %btmp.i979.sroa.5.0.sso_dst_b.i1020.sroa_idx = getelementptr inbounds nuw i8, ptr %sso_dst_b.i1020, i64 4
  store i8 61, ptr %btmp.i979.sroa.5.0.sso_dst_b.i1020.sroa_idx, align 1
  %rw0.i1021 = load i64, ptr %out_sso.i980, align 8
  %rw1.i1022 = load i64, ptr %out_sso8.i1017, align 8
  %rs0.i1023 = insertvalue %ArchxStr poison, i64 %rw0.i1021, 0
  %rs1.i1024 = insertvalue %ArchxStr %rs0.i1023, i64 %rw1.i1022, 1
  br label %archx_str_concat.exit1031

alloc_heap.i1001:                                 ; preds = %mat_b.i994.thread, %mat_b.i994
  %aptr.i9952006 = phi ptr [ %alptr.i993, %mat_b.i994.thread ], [ %atmp.i978, %mat_b.i994 ]
  %hp.i1002 = call noalias align 16 ptr @malloc(i64 %tot.i987)
  %hnull.i1003 = icmp eq ptr %hp.i1002, null
  br i1 %hnull.i1003, label %oom.i1015, label %copy_long.i1004

copy_long.i1004:                                  ; preds = %alloc_heap.i1001
  %hp_i.i1005 = ptrtoint ptr %hp.i1002 to i64
  %htagged.i1006 = or disjoint i64 %hp_i.i1005, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i1002, ptr nonnull align 1 %aptr.i9952006, i64 %alen.i983, i1 false)
  %dst_b.i1007 = getelementptr inbounds nuw i8, ptr %hp.i1002, i64 %alen.i983
  store i32 1852140576, ptr %dst_b.i1007, align 1
  %btmp.i979.sroa.5.0.dst_b.i1007.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i1007, i64 4
  store i8 61, ptr %btmp.i979.sroa.5.0.dst_b.i1007.sroa_idx, align 1
  %pref32.i1008 = load i32, ptr %hp.i1002, align 16
  %pref64.i1009 = zext i32 %pref32.i1008 to i64
  %pref_sh.i1010 = shl nuw i64 %pref64.i1009, 32
  %w0_out.i1011 = or disjoint i64 %pref_sh.i1010, %tot.i987
  %ls0.i1012 = insertvalue %ArchxStr poison, i64 %w0_out.i1011, 0
  %ls1.i1013 = insertvalue %ArchxStr %ls0.i1012, i64 %htagged.i1006, 1
  br label %archx_str_concat.exit1031

archx_str_concat.exit1031:                        ; preds = %archx_str_concat.exit977, %build_sso.i1016, %copy_long.i1004
  %common.ret.op.i1014 = phi %ArchxStr [ %rs1.i1024, %build_sso.i1016 ], [ %ls1.i1013, %copy_long.i1004 ], [ { i64 7954883201514602501, i64 61 }, %archx_str_concat.exit977 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i978)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i980)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1562)
  %n32.i1563 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1562, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 3)
  %len.i1564 = sext i32 %n32.i1563 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1561)
  %z.i.i1565 = icmp slt i32 %n32.i1563, 1
  br i1 %z.i.i1565, label %archx_str_from_int.exit1589, label %chk_sso.i.i1566

oom.i.i1581:                                      ; preds = %alloc_heap.i.i1568
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1566:                                  ; preds = %archx_str_concat.exit1031
  %short.i.i1567 = icmp samesign ult i32 %n32.i1563, 13
  br i1 %short.i.i1567, label %pack_sso.i.i1582, label %alloc_heap.i.i1568

pack_sso.i.i1582:                                 ; preds = %chk_sso.i.i1566
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1561, i8 0, i64 16, i1 false)
  store i32 %n32.i1563, ptr %sso.i.i1561, align 8
  %sso.i.i1561.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1561, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1561.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1562, i64 range(i64 -2147483648, 2147483650) %len.i1564, i1 false)
  %sso.i.i1561.0.sso.i.i1561.0.sso.i.i1561.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1584 = load i64, ptr %sso.i.i1561, align 8
  %sso.i.i1561.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1561, i64 8
  %sso.i.i1561.8.sso.i.i1561.8.sso.i.i1561.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1586 = load i64, ptr %sso.i.i1561.8.sroa_idx, align 8
  %ss0.i.i1587 = insertvalue %ArchxStr poison, i64 %sso.i.i1561.0.sso.i.i1561.0.sso.i.i1561.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1584, 0
  %ss1.i.i1588 = insertvalue %ArchxStr %ss0.i.i1587, i64 %sso.i.i1561.8.sso.i.i1561.8.sso.i.i1561.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1586, 1
  br label %archx_str_from_int.exit1589

alloc_heap.i.i1568:                               ; preds = %chk_sso.i.i1566
  %hp.i.i1569 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1564)
  %hnull.i.i1570 = icmp eq ptr %hp.i.i1569, null
  br i1 %hnull.i.i1570, label %oom.i.i1581, label %copy_long.i.i1571

copy_long.i.i1571:                                ; preds = %alloc_heap.i.i1568
  %hp_i.i.i1572 = ptrtoint ptr %hp.i.i1569 to i64
  %htagged.i.i1573 = or disjoint i64 %hp_i.i.i1572, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1569, ptr nonnull readonly align 8 %buf.i1562, i64 range(i64 -2147483648, 2147483650) %len.i1564, i1 false)
  %pref32.i.i1574 = load i32, ptr %hp.i.i1569, align 16
  %pref64.i.i1575 = zext i32 %pref32.i.i1574 to i64
  %pref_sh.i.i1576 = shl nuw i64 %pref64.i.i1575, 32
  %w0_out.i.i1577 = or disjoint i64 %pref_sh.i.i1576, %len.i1564
  %ls0.i.i1578 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1577, 0
  %ls1.i.i1579 = insertvalue %ArchxStr %ls0.i.i1578, i64 %htagged.i.i1573, 1
  br label %archx_str_from_int.exit1589

archx_str_from_int.exit1589:                      ; preds = %archx_str_concat.exit1031, %pack_sso.i.i1582, %copy_long.i.i1571
  %common.ret.op.i.i1580 = phi %ArchxStr [ %ss1.i.i1588, %pack_sso.i.i1582 ], [ %ls1.i.i1579, %copy_long.i.i1571 ], [ zeroinitializer, %archx_str_concat.exit1031 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1561)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1562)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i1032)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1033)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i1034)
  %aw0.i1035 = extractvalue %ArchxStr %common.ret.op.i1014, 0
  %aw1.i1036 = extractvalue %ArchxStr %common.ret.op.i1014, 1
  %bw0.i1037 = extractvalue %ArchxStr %common.ret.op.i.i1580, 0
  %bw1.i1038 = extractvalue %ArchxStr %common.ret.op.i.i1580, 1
  %alen.i1039 = and i64 %aw0.i1035, 4294967295
  %blen.i1040 = and i64 %bw0.i1037, 4294967295
  %az.i1041 = icmp eq i64 %alen.i1039, 0
  br i1 %az.i1041, label %ret_b_clone.i1095, label %chk_bz.i1042

ret_b_clone.i1095:                                ; preds = %archx_str_from_int.exit1589
  %long.i1592 = icmp samesign ult i64 %blen.i1040, 13
  %tag.i1596 = and i64 %bw1.i1038, 3
  %owned.not.i1597 = icmp eq i64 %tag.i1596, 0
  %or.cond2079 = select i1 %long.i1592, i1 true, i1 %owned.not.i1597
  br i1 %or.cond2079, label %archx_str_concat.exit1097, label %dup_heap.i1598

dup_heap.i1598:                                   ; preds = %ret_b_clone.i1095
  %dst.i1599 = call noalias align 16 ptr @malloc(i64 %blen.i1040)
  %isnull.i1600 = icmp eq ptr %dst.i1599, null
  br i1 %isnull.i1600, label %oom.i1607, label %copy.i1601

oom.i1607:                                        ; preds = %dup_heap.i1598
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1601:                                       ; preds = %dup_heap.i1598
  %src_i.i1602 = and i64 %bw1.i1038, -4
  %src.i1603 = inttoptr i64 %src_i.i1602 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1599, ptr nonnull align 4 %src.i1603, i64 %blen.i1040, i1 false)
  %dst_i.i1604 = ptrtoint ptr %dst.i1599 to i64
  %tagged.i1605 = or disjoint i64 %dst_i.i1604, 1
  %out.i1606 = insertvalue %ArchxStr %common.ret.op.i.i1580, i64 %tagged.i1605, 1
  br label %archx_str_concat.exit1097

chk_bz.i1042:                                     ; preds = %archx_str_from_int.exit1589
  %bz.i1043 = icmp eq i64 %blen.i1040, 0
  br i1 %bz.i1043, label %ret_a_clone.i1093, label %calc_tot.i1044

ret_a_clone.i1093:                                ; preds = %chk_bz.i1042
  %long.i1611 = icmp samesign ult i64 %alen.i1039, 13
  %tag.i1615 = and i64 %aw1.i1036, 3
  %owned.not.i1616 = icmp eq i64 %tag.i1615, 0
  %or.cond2080 = select i1 %long.i1611, i1 true, i1 %owned.not.i1616
  br i1 %or.cond2080, label %archx_str_concat.exit1097, label %dup_heap.i1617

dup_heap.i1617:                                   ; preds = %ret_a_clone.i1093
  %dst.i1618 = call noalias align 16 ptr @malloc(i64 %alen.i1039)
  %isnull.i1619 = icmp eq ptr %dst.i1618, null
  br i1 %isnull.i1619, label %oom.i1626, label %copy.i1620

oom.i1626:                                        ; preds = %dup_heap.i1617
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1620:                                       ; preds = %dup_heap.i1617
  %src_i.i1621 = and i64 %aw1.i1036, -4
  %src.i1622 = inttoptr i64 %src_i.i1621 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1618, ptr nonnull align 4 %src.i1622, i64 %alen.i1039, i1 false)
  %dst_i.i1623 = ptrtoint ptr %dst.i1618 to i64
  %tagged.i1624 = or disjoint i64 %dst_i.i1623, 1
  %out.i1625 = insertvalue %ArchxStr %common.ret.op.i1014, i64 %tagged.i1624, 1
  br label %archx_str_concat.exit1097

calc_tot.i1044:                                   ; preds = %chk_bz.i1042
  %tot.i1045 = add nuw nsw i64 %blen.i1040, %alen.i1039
  %too_big.i1046 = icmp samesign ugt i64 %tot.i1045, 2147483647
  br i1 %too_big.i1046, label %oom.i1075, label %mat_a.i1047

oom.i1075:                                        ; preds = %alloc_heap.i1061, %calc_tot.i1044
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1047:                                      ; preds = %calc_tot.i1044
  %ashort.i1048 = icmp samesign ult i64 %alen.i1039, 13
  br i1 %ashort.i1048, label %mat_a_short.i1089, label %mat_a_long.i1049

mat_a_short.i1089:                                ; preds = %mat_a.i1047
  %ap4.i1090 = lshr i64 %aw0.i1035, 32
  %ap4_32.i1091 = trunc nuw i64 %ap4.i1090 to i32
  store i32 %ap4_32.i1091, ptr %atmp.i1032, align 4
  %atmp4.i1092 = getelementptr inbounds nuw i8, ptr %atmp.i1032, i64 4
  store i64 %aw1.i1036, ptr %atmp4.i1092, align 4
  br label %mat_b.i1052

mat_a_long.i1049:                                 ; preds = %mat_a.i1047
  %araw.i1050 = and i64 %aw1.i1036, -4
  %alptr.i1051 = inttoptr i64 %araw.i1050 to ptr
  br label %mat_b.i1052

mat_b.i1052:                                      ; preds = %mat_a_long.i1049, %mat_a_short.i1089
  %aptr.i1053 = phi ptr [ %atmp.i1032, %mat_a_short.i1089 ], [ %alptr.i1051, %mat_a_long.i1049 ]
  %bshort.i1054 = icmp samesign ult i64 %blen.i1040, 13
  br i1 %bshort.i1054, label %mat_b_short.i1085, label %mat_b_long.i1055

mat_b_short.i1085:                                ; preds = %mat_b.i1052
  %bp4.i1086 = lshr i64 %bw0.i1037, 32
  %bp4_32.i1087 = trunc nuw i64 %bp4.i1086 to i32
  store i32 %bp4_32.i1087, ptr %btmp.i1033, align 4
  %btmp4.i1088 = getelementptr inbounds nuw i8, ptr %btmp.i1033, i64 4
  store i64 %bw1.i1038, ptr %btmp4.i1088, align 4
  br label %build.i1058

mat_b_long.i1055:                                 ; preds = %mat_b.i1052
  %braw.i1056 = and i64 %bw1.i1038, -4
  %blptr.i1057 = inttoptr i64 %braw.i1056 to ptr
  br label %build.i1058

build.i1058:                                      ; preds = %mat_b_long.i1055, %mat_b_short.i1085
  %bptr.i1059 = phi ptr [ %btmp.i1033, %mat_b_short.i1085 ], [ %blptr.i1057, %mat_b_long.i1055 ]
  %fits_sso.i1060 = icmp samesign ult i64 %tot.i1045, 13
  br i1 %fits_sso.i1060, label %build_sso.i1076, label %alloc_heap.i1061

build_sso.i1076:                                  ; preds = %build.i1058
  %out_sso8.i1077 = getelementptr inbounds nuw i8, ptr %out_sso.i1034, i64 8
  %tot32.i1078 = trunc nuw nsw i64 %tot.i1045 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i1034, i8 0, i64 16, i1 false)
  store i32 %tot32.i1078, ptr %out_sso.i1034, align 8
  %sso_dst_a.i1079 = getelementptr inbounds nuw i8, ptr %out_sso.i1034, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1079, ptr nonnull align 1 %aptr.i1053, i64 %alen.i1039, i1 false)
  %sso_dst_b.i1080 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1079, i64 %alen.i1039
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i1080, ptr nonnull align 1 %bptr.i1059, i64 %blen.i1040, i1 false)
  %rw0.i1081 = load i64, ptr %out_sso.i1034, align 8
  %rw1.i1082 = load i64, ptr %out_sso8.i1077, align 8
  %rs0.i1083 = insertvalue %ArchxStr poison, i64 %rw0.i1081, 0
  %rs1.i1084 = insertvalue %ArchxStr %rs0.i1083, i64 %rw1.i1082, 1
  br label %archx_str_concat.exit1097

alloc_heap.i1061:                                 ; preds = %build.i1058
  %hp.i1062 = call noalias align 16 ptr @malloc(i64 %tot.i1045)
  %hnull.i1063 = icmp eq ptr %hp.i1062, null
  br i1 %hnull.i1063, label %oom.i1075, label %copy_long.i1064

copy_long.i1064:                                  ; preds = %alloc_heap.i1061
  %hp_i.i1065 = ptrtoint ptr %hp.i1062 to i64
  %htagged.i1066 = or disjoint i64 %hp_i.i1065, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i1062, ptr nonnull align 1 %aptr.i1053, i64 %alen.i1039, i1 false)
  %dst_b.i1067 = getelementptr inbounds nuw i8, ptr %hp.i1062, i64 %alen.i1039
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i1067, ptr nonnull align 1 %bptr.i1059, i64 %blen.i1040, i1 false)
  %pref32.i1068 = load i32, ptr %hp.i1062, align 16
  %pref64.i1069 = zext i32 %pref32.i1068 to i64
  %pref_sh.i1070 = shl nuw i64 %pref64.i1069, 32
  %w0_out.i1071 = or disjoint i64 %pref_sh.i1070, %tot.i1045
  %ls0.i1072 = insertvalue %ArchxStr poison, i64 %w0_out.i1071, 0
  %ls1.i1073 = insertvalue %ArchxStr %ls0.i1072, i64 %htagged.i1066, 1
  br label %archx_str_concat.exit1097

archx_str_concat.exit1097:                        ; preds = %copy.i1620, %ret_a_clone.i1093, %copy.i1601, %ret_b_clone.i1095, %build_sso.i1076, %copy_long.i1064
  %common.ret.op.i1074 = phi %ArchxStr [ %rs1.i1084, %build_sso.i1076 ], [ %ls1.i1073, %copy_long.i1064 ], [ %out.i1606, %copy.i1601 ], [ %common.ret.op.i.i1580, %ret_b_clone.i1095 ], [ %out.i1625, %copy.i1620 ], [ %common.ret.op.i1014, %ret_a_clone.i1093 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i1032)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1033)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i1034)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1628)
  %w0.i1629 = extractvalue %ArchxStr %common.ret.op.i1074, 0
  %w1.i1630 = extractvalue %ArchxStr %common.ret.op.i1074, 1
  %len.i1631 = and i64 %w0.i1629, 4294967295
  %short.i1632 = icmp samesign ult i64 %len.i1631, 13
  br i1 %short.i1632, label %emit.i1653, label %emit.thread.i1633

emit.thread.i1633:                                ; preds = %archx_str_concat.exit1097
  %raw.i1634 = and i64 %w1.i1630, -4
  %lptr.i1635 = inttoptr i64 %raw.i1634 to ptr
  br label %chk_nul.i1636

emit.i1653:                                       ; preds = %archx_str_concat.exit1097
  %p4.i1654 = lshr i64 %w0.i1629, 32
  %p4_32.i1655 = trunc nuw i64 %p4.i1654 to i32
  store i32 %p4_32.i1655, ptr %tmp.i1628, align 4
  %tmp4.i1656 = getelementptr inbounds nuw i8, ptr %tmp.i1628, i64 4
  store i64 %w1.i1630, ptr %tmp4.i1656, align 4
  %pos.not.i1657 = icmp eq i64 %len.i1631, 0
  br i1 %pos.not.i1657, label %do_nl.i1648, label %chk_nul.i1636

chk_nul.i1636:                                    ; preds = %emit.i1653, %emit.thread.i1633
  %data3.i1637 = phi ptr [ %lptr.i1635, %emit.thread.i1633 ], [ %tmp.i1628, %emit.i1653 ]
  %nul.i1638 = call ptr @memchr(ptr nonnull %data3.i1637, i32 0, i64 %len.i1631)
  %has_nul.not.i1639 = icmp eq ptr %nul.i1638, null
  br i1 %has_nul.not.i1639, label %fast_printf.i1650, label %byte_loop.i1640

fast_printf.i1650:                                ; preds = %chk_nul.i1636
  %len32.i1651 = trunc i64 %w0.i1629 to i32
  %np.i1652 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1651, ptr nonnull %data3.i1637)
  br label %archx_str_print.exit1658

byte_loop.i1640:                                  ; preds = %chk_nul.i1636, %byte_loop.i1640
  %bi.i1641 = phi i64 [ %bnext.i1646, %byte_loop.i1640 ], [ 0, %chk_nul.i1636 ]
  %bp.i1642 = getelementptr inbounds nuw i8, ptr %data3.i1637, i64 %bi.i1641
  %ch8.i1643 = load i8, ptr %bp.i1642, align 1
  %ch32.i1644 = zext i8 %ch8.i1643 to i32
  %pc.i1645 = call i32 @putchar(i32 %ch32.i1644)
  %bnext.i1646 = add nuw nsw i64 %bi.i1641, 1
  %exitcond.not.i1647 = icmp eq i64 %bnext.i1646, %len.i1631
  br i1 %exitcond.not.i1647, label %do_nl.i1648, label %byte_loop.i1640

do_nl.i1648:                                      ; preds = %byte_loop.i1640, %emit.i1653
  %nc.i1649 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1658

archx_str_print.exit1658:                         ; preds = %fast_printf.i1650, %do_nl.i1648
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1628)
  %tag.i149 = and i64 %w1.i1630, 1
  %owned.not.i150 = icmp eq i64 %tag.i149, 0
  %or.cond2081 = select i1 %short.i1632, i1 true, i1 %owned.not.i150
  br i1 %or.cond2081, label %archx_str_drop.exit154, label %do_free.i151

do_free.i151:                                     ; preds = %archx_str_print.exit1658
  %raw.i152 = and i64 %w1.i1630, -2
  %ptr.i153 = inttoptr i64 %raw.i152 to ptr
  call void @free(ptr %ptr.i153)
  br label %archx_str_drop.exit154

archx_str_drop.exit154:                           ; preds = %archx_str_print.exit1658, %do_free.i151
  %long.i157 = icmp samesign ult i64 %blen.i1040, 13
  %tag.i160 = and i64 %bw1.i1038, 1
  %owned.not.i161 = icmp eq i64 %tag.i160, 0
  %or.cond2082 = select i1 %long.i157, i1 true, i1 %owned.not.i161
  br i1 %or.cond2082, label %archx_str_drop.exit165, label %do_free.i162

do_free.i162:                                     ; preds = %archx_str_drop.exit154
  %raw.i163 = and i64 %bw1.i1038, -2
  %ptr.i164 = inttoptr i64 %raw.i163 to ptr
  call void @free(ptr %ptr.i164)
  br label %archx_str_drop.exit165

archx_str_drop.exit165:                           ; preds = %archx_str_drop.exit154, %do_free.i162
  %long.i168 = icmp samesign ult i64 %alen.i1039, 13
  %tag.i171 = and i64 %aw1.i1036, 1
  %owned.not.i172 = icmp eq i64 %tag.i171, 0
  %or.cond2083 = select i1 %long.i168, i1 true, i1 %owned.not.i172
  br i1 %or.cond2083, label %archx_str_drop.exit176, label %do_free.i173

do_free.i173:                                     ; preds = %archx_str_drop.exit165
  %raw.i174 = and i64 %aw1.i1036, -2
  %ptr.i175 = inttoptr i64 %raw.i174 to ptr
  call void @free(ptr %ptr.i175)
  br label %archx_str_drop.exit176

archx_str_drop.exit176:                           ; preds = %archx_str_drop.exit165, %do_free.i173
  %long.i179 = icmp samesign ult i64 %alen.i983, 13
  %tag.i182 = and i64 %aw1.i982, 1
  %owned.not.i183 = icmp eq i64 %tag.i182, 0
  %or.cond2084 = select i1 %long.i179, i1 true, i1 %owned.not.i183
  br i1 %or.cond2084, label %archx_str_drop.exit187, label %do_free.i184

do_free.i184:                                     ; preds = %archx_str_drop.exit176
  %raw.i185 = and i64 %aw1.i982, -2
  %ptr.i186 = inttoptr i64 %raw.i185 to ptr
  call void @free(ptr %ptr.i186)
  br label %archx_str_drop.exit187

archx_str_drop.exit187:                           ; preds = %archx_str_drop.exit176, %do_free.i184
  %long.i190 = icmp samesign ult i64 %alen.i929, 13
  %tag.i193 = and i64 %aw1.i928, 1
  %owned.not.i194 = icmp eq i64 %tag.i193, 0
  %or.cond2085 = select i1 %long.i190, i1 true, i1 %owned.not.i194
  br i1 %or.cond2085, label %archx_str_drop.exit198, label %do_free.i195

do_free.i195:                                     ; preds = %archx_str_drop.exit187
  %raw.i196 = and i64 %aw1.i928, -2
  %ptr.i197 = inttoptr i64 %raw.i196 to ptr
  call void @free(ptr %ptr.i197)
  br label %archx_str_drop.exit198

archx_str_drop.exit198:                           ; preds = %archx_str_drop.exit187, %do_free.i195
  %long.i201 = icmp samesign ult i64 %alen.i875, 13
  %tag.i204 = and i64 %aw1.i874, 1
  %owned.not.i205 = icmp eq i64 %tag.i204, 0
  %or.cond2086 = select i1 %long.i201, i1 true, i1 %owned.not.i205
  br i1 %or.cond2086, label %archx_str_drop.exit209, label %do_free.i206

do_free.i206:                                     ; preds = %archx_str_drop.exit198
  %raw.i207 = and i64 %aw1.i874, -2
  %ptr.i208 = inttoptr i64 %raw.i207 to ptr
  call void @free(ptr %ptr.i208)
  br label %archx_str_drop.exit209

archx_str_drop.exit209:                           ; preds = %archx_str_drop.exit198, %do_free.i206
  %long.i212 = icmp samesign ult i64 %alen.i821, 13
  %tag.i215 = and i64 %aw1.i820, 1
  %owned.not.i216 = icmp eq i64 %tag.i215, 0
  %or.cond2087 = select i1 %long.i212, i1 true, i1 %owned.not.i216
  br i1 %or.cond2087, label %archx_str_drop.exit220, label %do_free.i217

do_free.i217:                                     ; preds = %archx_str_drop.exit209
  %raw.i218 = and i64 %aw1.i820, -2
  %ptr.i219 = inttoptr i64 %raw.i218 to ptr
  call void @free(ptr %ptr.i219)
  br label %archx_str_drop.exit220

archx_str_drop.exit220:                           ; preds = %archx_str_drop.exit209, %do_free.i217
  %long.i223 = icmp samesign ult i64 %alen.i767, 13
  %tag.i226 = and i64 %aw1.i766, 1
  %owned.not.i227 = icmp eq i64 %tag.i226, 0
  %or.cond2088 = select i1 %long.i223, i1 true, i1 %owned.not.i227
  br i1 %or.cond2088, label %archx_str_drop.exit231, label %do_free.i228

do_free.i228:                                     ; preds = %archx_str_drop.exit220
  %raw.i229 = and i64 %aw1.i766, -2
  %ptr.i230 = inttoptr i64 %raw.i229 to ptr
  call void @free(ptr %ptr.i230)
  br label %archx_str_drop.exit231

archx_str_drop.exit231:                           ; preds = %archx_str_drop.exit220, %do_free.i228
  %long.i234 = icmp samesign ult i64 %blen.i704, 13
  %tag.i237 = and i64 %bw1.i702, 1
  %owned.not.i238 = icmp eq i64 %tag.i237, 0
  %or.cond2089 = select i1 %long.i234, i1 true, i1 %owned.not.i238
  br i1 %or.cond2089, label %archx_str_drop.exit242, label %do_free.i239

do_free.i239:                                     ; preds = %archx_str_drop.exit231
  %raw.i240 = and i64 %bw1.i702, -2
  %ptr.i241 = inttoptr i64 %raw.i240 to ptr
  call void @free(ptr %ptr.i241)
  br label %archx_str_drop.exit242

archx_str_drop.exit242:                           ; preds = %archx_str_drop.exit231, %do_free.i239
  %long.i245 = icmp samesign ult i64 %alen.i703, 13
  %tag.i248 = and i64 %aw1.i700, 1
  %owned.not.i249 = icmp eq i64 %tag.i248, 0
  %or.cond2090 = select i1 %long.i245, i1 true, i1 %owned.not.i249
  br i1 %or.cond2090, label %archx_str_drop.exit253, label %do_free.i250

do_free.i250:                                     ; preds = %archx_str_drop.exit242
  %raw.i251 = and i64 %aw1.i700, -2
  %ptr.i252 = inttoptr i64 %raw.i251 to ptr
  call void @free(ptr %ptr.i252)
  br label %archx_str_drop.exit253

archx_str_drop.exit253:                           ; preds = %archx_str_drop.exit242, %do_free.i250
  %long.i256 = icmp samesign ult i64 %alen.i647, 13
  %tag.i259 = and i64 %aw1.i646, 1
  %owned.not.i260 = icmp eq i64 %tag.i259, 0
  %or.cond2091 = select i1 %long.i256, i1 true, i1 %owned.not.i260
  br i1 %or.cond2091, label %archx_str_drop.exit264, label %do_free.i261

do_free.i261:                                     ; preds = %archx_str_drop.exit253
  %raw.i262 = and i64 %aw1.i646, -2
  %ptr.i263 = inttoptr i64 %raw.i262 to ptr
  call void @free(ptr %ptr.i263)
  br label %archx_str_drop.exit264

archx_str_drop.exit264:                           ; preds = %archx_str_drop.exit253, %do_free.i261
  %long.i267 = icmp samesign ult i64 %blen.i593, 13
  %tag.i270 = and i64 %bw1.i592, 1
  %owned.not.i271 = icmp eq i64 %tag.i270, 0
  %or.cond2092 = select i1 %long.i267, i1 true, i1 %owned.not.i271
  br i1 %or.cond2092, label %archx_str_drop.exit275, label %do_free.i272

do_free.i272:                                     ; preds = %archx_str_drop.exit264
  %raw.i273 = and i64 %bw1.i592, -2
  %ptr.i274 = inttoptr i64 %raw.i273 to ptr
  call void @free(ptr %ptr.i274)
  br label %archx_str_drop.exit275

archx_str_drop.exit275:                           ; preds = %archx_str_drop.exit264, %do_free.i272
  %t6.i = load i64, ptr %t0, align 16
  %t8.i = icmp sgt i64 %t6.i, 20
  br i1 %t8.i, label %archx_fn_find_gt.exit, label %enum.step.2.i

enum.step.2.i:                                    ; preds = %archx_str_drop.exit275
  %t6.1.i = load i64, ptr %t3, align 8
  %t8.1.i = icmp sgt i64 %t6.1.i, 20
  br i1 %t8.1.i, label %archx_fn_find_gt.exit.thread2012, label %enum.step.2.1.i

enum.step.2.1.i:                                  ; preds = %enum.step.2.i
  %t6.2.i = load i64, ptr %t4, align 16
  %t8.2.i = icmp sgt i64 %t6.2.i, 20
  br i1 %t8.2.i, label %archx_fn_find_gt.exit.thread2012, label %enum.step.2.2.i

enum.step.2.2.i:                                  ; preds = %enum.step.2.1.i
  %t6.3.i = load i64, ptr %t5, align 8
  %t8.3.i = icmp sgt i64 %t6.3.i, 20
  br i1 %t8.3.i, label %archx_fn_find_gt.exit.thread2012, label %enum.step.2.3.i

enum.step.2.3.i:                                  ; preds = %enum.step.2.2.i
  %t6.4.i = load i64, ptr %t6, align 16
  %t8.4.i = icmp sgt i64 %t6.4.i, 20
  br i1 %t8.4.i, label %archx_fn_find_gt.exit.thread2012, label %enum.step.2.i1662

archx_fn_find_gt.exit.thread2012:                 ; preds = %enum.step.2.i, %enum.step.2.1.i, %enum.step.2.2.i, %enum.step.2.3.i
  %enum.pos.2.03.lcssa.i.ph = phi i64 [ 4, %enum.step.2.3.i ], [ 3, %enum.step.2.2.i ], [ 2, %enum.step.2.1.i ], [ 1, %enum.step.2.i ]
  %t11.i2014 = insertvalue { i1, i64 } { i1 true, i64 undef }, i64 %enum.pos.2.03.lcssa.i.ph, 1
  br label %enum.step.2.i1662

archx_fn_find_gt.exit:                            ; preds = %archx_str_drop.exit275
  %t8.i1661 = icmp samesign ugt i64 %t6.i, 500
  br i1 %t8.i1661, label %if.then.4.i1679, label %enum.step.2.i1662

if.then.4.i1679:                                  ; preds = %enum.step.2.3.i1674, %enum.step.2.2.i1670, %enum.step.2.1.i1666, %enum.step.2.i1662, %archx_fn_find_gt.exit
  %common.ret.op.i16592010 = phi { i1, i64 } [ { i1 true, i64 0 }, %archx_fn_find_gt.exit ], [ %common.ret.op.i16592011, %enum.step.2.i1662 ], [ %common.ret.op.i16592011, %enum.step.2.1.i1666 ], [ %common.ret.op.i16592011, %enum.step.2.2.i1670 ], [ %common.ret.op.i16592011, %enum.step.2.3.i1674 ]
  %enum.pos.2.03.lcssa.i1680 = phi i64 [ 0, %archx_fn_find_gt.exit ], [ 1, %enum.step.2.i1662 ], [ 2, %enum.step.2.1.i1666 ], [ 3, %enum.step.2.2.i1670 ], [ 4, %enum.step.2.3.i1674 ]
  %t11.i1681 = insertvalue { i1, i64 } { i1 true, i64 undef }, i64 %enum.pos.2.03.lcssa.i1680, 1
  br label %archx_fn_find_gt.exit1682

enum.step.2.i1662:                                ; preds = %enum.step.2.3.i, %archx_fn_find_gt.exit.thread2012, %archx_fn_find_gt.exit
  %common.ret.op.i16592011 = phi { i1, i64 } [ { i1 true, i64 0 }, %archx_fn_find_gt.exit ], [ %t11.i2014, %archx_fn_find_gt.exit.thread2012 ], [ zeroinitializer, %enum.step.2.3.i ]
  %t6.1.i1664 = load i64, ptr %t3, align 8
  %t8.1.i1665 = icmp sgt i64 %t6.1.i1664, 500
  br i1 %t8.1.i1665, label %if.then.4.i1679, label %enum.step.2.1.i1666

enum.step.2.1.i1666:                              ; preds = %enum.step.2.i1662
  %t6.2.i1668 = load i64, ptr %t4, align 16
  %t8.2.i1669 = icmp sgt i64 %t6.2.i1668, 500
  br i1 %t8.2.i1669, label %if.then.4.i1679, label %enum.step.2.2.i1670

enum.step.2.2.i1670:                              ; preds = %enum.step.2.1.i1666
  %t6.3.i1672 = load i64, ptr %t5, align 8
  %t8.3.i1673 = icmp sgt i64 %t6.3.i1672, 500
  br i1 %t8.3.i1673, label %if.then.4.i1679, label %enum.step.2.3.i1674

enum.step.2.3.i1674:                              ; preds = %enum.step.2.2.i1670
  %t6.4.i1676 = load i64, ptr %t6, align 16
  %t8.4.i1677 = icmp sgt i64 %t6.4.i1676, 500
  br i1 %t8.4.i1677, label %if.then.4.i1679, label %archx_fn_find_gt.exit1682

archx_fn_find_gt.exit1682:                        ; preds = %if.then.4.i1679, %enum.step.2.3.i1674
  %common.ret.op.i16592009 = phi { i1, i64 } [ %common.ret.op.i16592010, %if.then.4.i1679 ], [ %common.ret.op.i16592011, %enum.step.2.3.i1674 ]
  %common.ret.op.i1678 = phi { i1, i64 } [ %t11.i1681, %if.then.4.i1679 ], [ zeroinitializer, %enum.step.2.3.i1674 ]
  %t57 = extractvalue { i1, i64 } %common.ret.op.i16592009, 0
  br i1 %t57, label %if.then.2, label %if.merge.4

if.then.2:                                        ; preds = %archx_fn_find_gt.exit1682
  %t58 = extractvalue { i1, i64 } %common.ret.op.i16592009, 1
  %t60 = icmp ugt i64 %t58, 4
  br i1 %t60, label %idx.oob.6, label %idx.ok.5

idx.oob.6:                                        ; preds = %if.then.2
  call fastcc void @archx_bounds_fail(i64 %t58)
  unreachable

idx.ok.5:                                         ; preds = %if.then.2
  %t62 = getelementptr inbounds nuw i64, ptr %t0, i64 %t58
  %t63 = load i64, ptr %t62, align 8
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1684)
  %n32.i1685 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1684, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t63)
  %len.i1686 = sext i32 %n32.i1685 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1683)
  %z.i.i1687 = icmp slt i32 %n32.i1685, 1
  br i1 %z.i.i1687, label %archx_str_from_int.exit1711, label %chk_sso.i.i1688

oom.i.i1703:                                      ; preds = %alloc_heap.i.i1690
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1688:                                  ; preds = %idx.ok.5
  %short.i.i1689 = icmp samesign ult i32 %n32.i1685, 13
  br i1 %short.i.i1689, label %pack_sso.i.i1704, label %alloc_heap.i.i1690

pack_sso.i.i1704:                                 ; preds = %chk_sso.i.i1688
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1683, i8 0, i64 16, i1 false)
  store i32 %n32.i1685, ptr %sso.i.i1683, align 8
  %sso.i.i1683.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1683, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1683.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1684, i64 range(i64 -2147483648, 2147483650) %len.i1686, i1 false)
  %sso.i.i1683.0.sso.i.i1683.0.sso.i.i1683.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1706 = load i64, ptr %sso.i.i1683, align 8
  %sso.i.i1683.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1683, i64 8
  %sso.i.i1683.8.sso.i.i1683.8.sso.i.i1683.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1708 = load i64, ptr %sso.i.i1683.8.sroa_idx, align 8
  %ss0.i.i1709 = insertvalue %ArchxStr poison, i64 %sso.i.i1683.0.sso.i.i1683.0.sso.i.i1683.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1706, 0
  %ss1.i.i1710 = insertvalue %ArchxStr %ss0.i.i1709, i64 %sso.i.i1683.8.sso.i.i1683.8.sso.i.i1683.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1708, 1
  br label %archx_str_from_int.exit1711

alloc_heap.i.i1690:                               ; preds = %chk_sso.i.i1688
  %hp.i.i1691 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1686)
  %hnull.i.i1692 = icmp eq ptr %hp.i.i1691, null
  br i1 %hnull.i.i1692, label %oom.i.i1703, label %copy_long.i.i1693

copy_long.i.i1693:                                ; preds = %alloc_heap.i.i1690
  %hp_i.i.i1694 = ptrtoint ptr %hp.i.i1691 to i64
  %htagged.i.i1695 = or disjoint i64 %hp_i.i.i1694, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1691, ptr nonnull readonly align 8 %buf.i1684, i64 range(i64 -2147483648, 2147483650) %len.i1686, i1 false)
  %pref32.i.i1696 = load i32, ptr %hp.i.i1691, align 16
  %pref64.i.i1697 = zext i32 %pref32.i.i1696 to i64
  %pref_sh.i.i1698 = shl nuw i64 %pref64.i.i1697, 32
  %w0_out.i.i1699 = or disjoint i64 %pref_sh.i.i1698, %len.i1686
  %ls0.i.i1700 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1699, 0
  %ls1.i.i1701 = insertvalue %ArchxStr %ls0.i.i1700, i64 %htagged.i.i1695, 1
  br label %archx_str_from_int.exit1711

archx_str_from_int.exit1711:                      ; preds = %idx.ok.5, %pack_sso.i.i1704, %copy_long.i.i1693
  %common.ret.op.i.i1702 = phi %ArchxStr [ %ss1.i.i1710, %pack_sso.i.i1704 ], [ %ls1.i.i1701, %copy_long.i.i1693 ], [ zeroinitializer, %idx.ok.5 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1683)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1684)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1099)
  %bw0.i1101 = extractvalue %ArchxStr %common.ret.op.i.i1702, 0
  %bw1.i1102 = extractvalue %ArchxStr %common.ret.op.i.i1702, 1
  %blen.i1103 = and i64 %bw0.i1101, 4294967295
  %bz.i1105 = icmp eq i64 %blen.i1103, 0
  br i1 %bz.i1105, label %archx_str_concat.exit1151, label %calc_tot.i1106

calc_tot.i1106:                                   ; preds = %archx_str_from_int.exit1711
  %tot.i1107 = add nuw nsw i64 %blen.i1103, 6
  %too_big.i1108 = icmp samesign ugt i64 %blen.i1103, 2147483641
  br i1 %too_big.i1108, label %oom.i1135, label %mat_a.i1109

oom.i1135:                                        ; preds = %alloc_heap.i1121, %calc_tot.i1106
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1109:                                      ; preds = %calc_tot.i1106
  %bshort.i1114 = icmp samesign ult i64 %blen.i1103, 13
  br i1 %bshort.i1114, label %build.i1118, label %build.i1118.thread

build.i1118.thread:                               ; preds = %mat_a.i1109
  %braw.i1116 = and i64 %bw1.i1102, -4
  %blptr.i1117 = inttoptr i64 %braw.i1116 to ptr
  br label %alloc_heap.i1121

build.i1118:                                      ; preds = %mat_a.i1109
  %bp4.i1146 = lshr i64 %bw0.i1101, 32
  %bp4_32.i1147 = trunc nuw i64 %bp4.i1146 to i32
  store i32 %bp4_32.i1147, ptr %btmp.i1099, align 4
  %btmp4.i1148 = getelementptr inbounds nuw i8, ptr %btmp.i1099, i64 4
  store i64 %bw1.i1102, ptr %btmp4.i1148, align 4
  %fits_sso.i1120 = icmp samesign ult i64 %blen.i1103, 7
  br i1 %fits_sso.i1120, label %build_sso.i1136, label %alloc_heap.i1121

build_sso.i1136:                                  ; preds = %build.i1118
  store i48 0, ptr %out_sso.i1100.sroa.6.sroa.5.sroa.0, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i1100.sroa.6.sroa.5.sroa.0, ptr nonnull align 4 %btmp.i1099, i64 %blen.i1103, i1 false)
  %out_sso.i1100.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i1107, 7959390400324567040
  %out_sso.i1100.sroa.6.sroa.5.sroa.0.0.out_sso.i1100.sroa.6.sroa.5.sroa.0.0.out_sso.i1100.sroa.6.sroa.5.sroa.0.0.out_sso.i1100.sroa.6.sroa.5.sroa.0.0.out_sso.i1100.sroa.6.sroa.5.0.out_sso.i1100.sroa.6.8.rw1.i1142 = load i48, ptr %out_sso.i1100.sroa.6.sroa.5.sroa.0, align 8
  %out_sso.i1100.sroa.6.sroa.5.0.insert.ext = zext i48 %out_sso.i1100.sroa.6.sroa.5.sroa.0.0.out_sso.i1100.sroa.6.sroa.5.sroa.0.0.out_sso.i1100.sroa.6.sroa.5.sroa.0.0.out_sso.i1100.sroa.6.sroa.5.sroa.0.0.out_sso.i1100.sroa.6.sroa.5.0.out_sso.i1100.sroa.6.8.rw1.i1142 to i64
  %out_sso.i1100.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i1100.sroa.6.sroa.5.0.insert.ext, 16
  %out_sso.i1100.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i1100.sroa.6.sroa.5.0.insert.shift, 15716
  %rs0.i1143 = insertvalue %ArchxStr poison, i64 %out_sso.i1100.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i1144 = insertvalue %ArchxStr %rs0.i1143, i64 %out_sso.i1100.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit1151

alloc_heap.i1121:                                 ; preds = %build.i1118.thread, %build.i1118
  %bptr.i11192211 = phi ptr [ %blptr.i1117, %build.i1118.thread ], [ %btmp.i1099, %build.i1118 ]
  %hp.i1122 = call noalias align 16 ptr @malloc(i64 %tot.i1107)
  %hnull.i1123 = icmp eq ptr %hp.i1122, null
  br i1 %hnull.i1123, label %oom.i1135, label %copy_long.i1124

copy_long.i1124:                                  ; preds = %alloc_heap.i1121
  %hp_i.i1125 = ptrtoint ptr %hp.i1122 to i64
  %htagged.i1126 = or disjoint i64 %hp_i.i1125, 1
  store i32 1853189990, ptr %hp.i1122, align 16
  %atmp.i1098.sroa.5.0.hp.i1122.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i1122, i64 4
  store i16 15716, ptr %atmp.i1098.sroa.5.0.hp.i1122.sroa_idx, align 4
  %dst_b.i1127 = getelementptr inbounds nuw i8, ptr %hp.i1122, i64 6
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 2 %dst_b.i1127, ptr nonnull align 1 %bptr.i11192211, i64 %blen.i1103, i1 false)
  %w0_out.i1131 = or disjoint i64 %tot.i1107, 7959390400324567040
  %ls0.i1132 = insertvalue %ArchxStr poison, i64 %w0_out.i1131, 0
  %ls1.i1133 = insertvalue %ArchxStr %ls0.i1132, i64 %htagged.i1126, 1
  br label %archx_str_concat.exit1151

archx_str_concat.exit1151:                        ; preds = %archx_str_from_int.exit1711, %build_sso.i1136, %copy_long.i1124
  %common.ret.op.i1134 = phi %ArchxStr [ %rs1.i1144, %build_sso.i1136 ], [ %ls1.i1133, %copy_long.i1124 ], [ { i64 7959390400324567046, i64 15716 }, %archx_str_from_int.exit1711 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1099)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i1152)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i1154)
  %aw0.i1155 = extractvalue %ArchxStr %common.ret.op.i1134, 0
  %aw1.i1156 = extractvalue %ArchxStr %common.ret.op.i1134, 1
  %alen.i1157 = and i64 %aw0.i1155, 4294967295
  %az.i1158 = icmp eq i64 %alen.i1157, 0
  br i1 %az.i1158, label %archx_str_concat.exit1205, label %chk_bz.i1159

chk_bz.i1159:                                     ; preds = %archx_str_concat.exit1151
  %tot.i1161 = add nuw nsw i64 %alen.i1157, 4
  %too_big.i1162 = icmp samesign ugt i64 %alen.i1157, 2147483643
  br i1 %too_big.i1162, label %oom.i1189, label %mat_a.i1163

oom.i1189:                                        ; preds = %alloc_heap.i1175, %chk_bz.i1159
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1163:                                      ; preds = %chk_bz.i1159
  %ashort.i1164 = icmp samesign ult i64 %alen.i1157, 13
  br i1 %ashort.i1164, label %mat_b.i1168, label %mat_b.i1168.thread

mat_b.i1168.thread:                               ; preds = %mat_a.i1163
  %araw.i1166 = and i64 %aw1.i1156, -4
  %alptr.i1167 = inttoptr i64 %araw.i1166 to ptr
  br label %alloc_heap.i1175

mat_b.i1168:                                      ; preds = %mat_a.i1163
  %ap4.i1200 = lshr i64 %aw0.i1155, 32
  %ap4_32.i1201 = trunc nuw i64 %ap4.i1200 to i32
  store i32 %ap4_32.i1201, ptr %atmp.i1152, align 4
  %atmp4.i1202 = getelementptr inbounds nuw i8, ptr %atmp.i1152, i64 4
  store i64 %aw1.i1156, ptr %atmp4.i1202, align 4
  %fits_sso.i1174 = icmp samesign ult i64 %alen.i1157, 9
  br i1 %fits_sso.i1174, label %build_sso.i1190, label %alloc_heap.i1175

build_sso.i1190:                                  ; preds = %mat_b.i1168
  %out_sso8.i1191 = getelementptr inbounds nuw i8, ptr %out_sso.i1154, i64 8
  %tot32.i1192 = trunc nuw nsw i64 %tot.i1161 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i1154, i8 0, i64 16, i1 false)
  store i32 %tot32.i1192, ptr %out_sso.i1154, align 8
  %sso_dst_a.i1193 = getelementptr inbounds nuw i8, ptr %out_sso.i1154, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1193, ptr nonnull align 4 %atmp.i1152, i64 %alen.i1157, i1 false)
  %sso_dst_b.i1194 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1193, i64 %alen.i1157
  store i32 544497952, ptr %sso_dst_b.i1194, align 1
  %rw0.i1195 = load i64, ptr %out_sso.i1154, align 8
  %rw1.i1196 = load i64, ptr %out_sso8.i1191, align 8
  %rs0.i1197 = insertvalue %ArchxStr poison, i64 %rw0.i1195, 0
  %rs1.i1198 = insertvalue %ArchxStr %rs0.i1197, i64 %rw1.i1196, 1
  br label %archx_str_concat.exit1205

alloc_heap.i1175:                                 ; preds = %mat_b.i1168.thread, %mat_b.i1168
  %aptr.i11692018 = phi ptr [ %alptr.i1167, %mat_b.i1168.thread ], [ %atmp.i1152, %mat_b.i1168 ]
  %hp.i1176 = call noalias align 16 ptr @malloc(i64 %tot.i1161)
  %hnull.i1177 = icmp eq ptr %hp.i1176, null
  br i1 %hnull.i1177, label %oom.i1189, label %copy_long.i1178

copy_long.i1178:                                  ; preds = %alloc_heap.i1175
  %hp_i.i1179 = ptrtoint ptr %hp.i1176 to i64
  %htagged.i1180 = or disjoint i64 %hp_i.i1179, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i1176, ptr nonnull align 1 %aptr.i11692018, i64 %alen.i1157, i1 false)
  %dst_b.i1181 = getelementptr inbounds nuw i8, ptr %hp.i1176, i64 %alen.i1157
  store i32 544497952, ptr %dst_b.i1181, align 1
  %pref32.i1182 = load i32, ptr %hp.i1176, align 16
  %pref64.i1183 = zext i32 %pref32.i1182 to i64
  %pref_sh.i1184 = shl nuw i64 %pref64.i1183, 32
  %w0_out.i1185 = or disjoint i64 %pref_sh.i1184, %tot.i1161
  %ls0.i1186 = insertvalue %ArchxStr poison, i64 %w0_out.i1185, 0
  %ls1.i1187 = insertvalue %ArchxStr %ls0.i1186, i64 %htagged.i1180, 1
  br label %archx_str_concat.exit1205

archx_str_concat.exit1205:                        ; preds = %archx_str_concat.exit1151, %build_sso.i1190, %copy_long.i1178
  %common.ret.op.i1188 = phi %ArchxStr [ %rs1.i1198, %build_sso.i1190 ], [ %ls1.i1187, %copy_long.i1178 ], [ { i64 2338600896578977796, i64 0 }, %archx_str_concat.exit1151 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i1152)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i1154)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1715)
  %n32.i1716 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1715, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t58)
  %len.i1717 = sext i32 %n32.i1716 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1714)
  %z.i.i1718 = icmp slt i32 %n32.i1716, 1
  br i1 %z.i.i1718, label %archx_str_from_int.exit1742, label %chk_sso.i.i1719

oom.i.i1734:                                      ; preds = %alloc_heap.i.i1721
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1719:                                  ; preds = %archx_str_concat.exit1205
  %short.i.i1720 = icmp samesign ult i32 %n32.i1716, 13
  br i1 %short.i.i1720, label %pack_sso.i.i1735, label %alloc_heap.i.i1721

pack_sso.i.i1735:                                 ; preds = %chk_sso.i.i1719
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1714, i8 0, i64 16, i1 false)
  store i32 %n32.i1716, ptr %sso.i.i1714, align 8
  %sso.i.i1714.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1714, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1714.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1715, i64 range(i64 -2147483648, 2147483650) %len.i1717, i1 false)
  %sso.i.i1714.0.sso.i.i1714.0.sso.i.i1714.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1737 = load i64, ptr %sso.i.i1714, align 8
  %sso.i.i1714.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1714, i64 8
  %sso.i.i1714.8.sso.i.i1714.8.sso.i.i1714.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1739 = load i64, ptr %sso.i.i1714.8.sroa_idx, align 8
  %ss0.i.i1740 = insertvalue %ArchxStr poison, i64 %sso.i.i1714.0.sso.i.i1714.0.sso.i.i1714.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1737, 0
  %ss1.i.i1741 = insertvalue %ArchxStr %ss0.i.i1740, i64 %sso.i.i1714.8.sso.i.i1714.8.sso.i.i1714.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1739, 1
  br label %archx_str_from_int.exit1742

alloc_heap.i.i1721:                               ; preds = %chk_sso.i.i1719
  %hp.i.i1722 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1717)
  %hnull.i.i1723 = icmp eq ptr %hp.i.i1722, null
  br i1 %hnull.i.i1723, label %oom.i.i1734, label %copy_long.i.i1724

copy_long.i.i1724:                                ; preds = %alloc_heap.i.i1721
  %hp_i.i.i1725 = ptrtoint ptr %hp.i.i1722 to i64
  %htagged.i.i1726 = or disjoint i64 %hp_i.i.i1725, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1722, ptr nonnull readonly align 8 %buf.i1715, i64 range(i64 -2147483648, 2147483650) %len.i1717, i1 false)
  %pref32.i.i1727 = load i32, ptr %hp.i.i1722, align 16
  %pref64.i.i1728 = zext i32 %pref32.i.i1727 to i64
  %pref_sh.i.i1729 = shl nuw i64 %pref64.i.i1728, 32
  %w0_out.i.i1730 = or disjoint i64 %pref_sh.i.i1729, %len.i1717
  %ls0.i.i1731 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1730, 0
  %ls1.i.i1732 = insertvalue %ArchxStr %ls0.i.i1731, i64 %htagged.i.i1726, 1
  br label %archx_str_from_int.exit1742

archx_str_from_int.exit1742:                      ; preds = %archx_str_concat.exit1205, %pack_sso.i.i1735, %copy_long.i.i1724
  %common.ret.op.i.i1733 = phi %ArchxStr [ %ss1.i.i1741, %pack_sso.i.i1735 ], [ %ls1.i.i1732, %copy_long.i.i1724 ], [ zeroinitializer, %archx_str_concat.exit1205 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1714)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1715)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i1206)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1207)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i1208)
  %aw0.i1209 = extractvalue %ArchxStr %common.ret.op.i1188, 0
  %aw1.i1210 = extractvalue %ArchxStr %common.ret.op.i1188, 1
  %bw0.i1211 = extractvalue %ArchxStr %common.ret.op.i.i1733, 0
  %bw1.i1212 = extractvalue %ArchxStr %common.ret.op.i.i1733, 1
  %alen.i1213 = and i64 %aw0.i1209, 4294967295
  %blen.i1214 = and i64 %bw0.i1211, 4294967295
  %az.i1215 = icmp eq i64 %alen.i1213, 0
  br i1 %az.i1215, label %ret_b_clone.i1269, label %chk_bz.i1216

ret_b_clone.i1269:                                ; preds = %archx_str_from_int.exit1742
  %long.i1745 = icmp samesign ult i64 %blen.i1214, 13
  %tag.i1749 = and i64 %bw1.i1212, 3
  %owned.not.i1750 = icmp eq i64 %tag.i1749, 0
  %or.cond2093 = select i1 %long.i1745, i1 true, i1 %owned.not.i1750
  br i1 %or.cond2093, label %archx_str_concat.exit1271, label %dup_heap.i1751

dup_heap.i1751:                                   ; preds = %ret_b_clone.i1269
  %dst.i1752 = call noalias align 16 ptr @malloc(i64 %blen.i1214)
  %isnull.i1753 = icmp eq ptr %dst.i1752, null
  br i1 %isnull.i1753, label %oom.i1760, label %copy.i1754

oom.i1760:                                        ; preds = %dup_heap.i1751
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1754:                                       ; preds = %dup_heap.i1751
  %src_i.i1755 = and i64 %bw1.i1212, -4
  %src.i1756 = inttoptr i64 %src_i.i1755 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1752, ptr nonnull align 4 %src.i1756, i64 %blen.i1214, i1 false)
  %dst_i.i1757 = ptrtoint ptr %dst.i1752 to i64
  %tagged.i1758 = or disjoint i64 %dst_i.i1757, 1
  %out.i1759 = insertvalue %ArchxStr %common.ret.op.i.i1733, i64 %tagged.i1758, 1
  br label %archx_str_concat.exit1271

chk_bz.i1216:                                     ; preds = %archx_str_from_int.exit1742
  %bz.i1217 = icmp eq i64 %blen.i1214, 0
  br i1 %bz.i1217, label %ret_a_clone.i1267, label %calc_tot.i1218

ret_a_clone.i1267:                                ; preds = %chk_bz.i1216
  %long.i1764 = icmp samesign ult i64 %alen.i1213, 13
  %tag.i1768 = and i64 %aw1.i1210, 3
  %owned.not.i1769 = icmp eq i64 %tag.i1768, 0
  %or.cond2094 = select i1 %long.i1764, i1 true, i1 %owned.not.i1769
  br i1 %or.cond2094, label %archx_str_concat.exit1271, label %dup_heap.i1770

dup_heap.i1770:                                   ; preds = %ret_a_clone.i1267
  %dst.i1771 = call noalias align 16 ptr @malloc(i64 %alen.i1213)
  %isnull.i1772 = icmp eq ptr %dst.i1771, null
  br i1 %isnull.i1772, label %oom.i1779, label %copy.i1773

oom.i1779:                                        ; preds = %dup_heap.i1770
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1773:                                       ; preds = %dup_heap.i1770
  %src_i.i1774 = and i64 %aw1.i1210, -4
  %src.i1775 = inttoptr i64 %src_i.i1774 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1771, ptr nonnull align 4 %src.i1775, i64 %alen.i1213, i1 false)
  %dst_i.i1776 = ptrtoint ptr %dst.i1771 to i64
  %tagged.i1777 = or disjoint i64 %dst_i.i1776, 1
  %out.i1778 = insertvalue %ArchxStr %common.ret.op.i1188, i64 %tagged.i1777, 1
  br label %archx_str_concat.exit1271

calc_tot.i1218:                                   ; preds = %chk_bz.i1216
  %tot.i1219 = add nuw nsw i64 %blen.i1214, %alen.i1213
  %too_big.i1220 = icmp samesign ugt i64 %tot.i1219, 2147483647
  br i1 %too_big.i1220, label %oom.i1249, label %mat_a.i1221

oom.i1249:                                        ; preds = %alloc_heap.i1235, %calc_tot.i1218
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1221:                                      ; preds = %calc_tot.i1218
  %ashort.i1222 = icmp samesign ult i64 %alen.i1213, 13
  br i1 %ashort.i1222, label %mat_a_short.i1263, label %mat_a_long.i1223

mat_a_short.i1263:                                ; preds = %mat_a.i1221
  %ap4.i1264 = lshr i64 %aw0.i1209, 32
  %ap4_32.i1265 = trunc nuw i64 %ap4.i1264 to i32
  store i32 %ap4_32.i1265, ptr %atmp.i1206, align 4
  %atmp4.i1266 = getelementptr inbounds nuw i8, ptr %atmp.i1206, i64 4
  store i64 %aw1.i1210, ptr %atmp4.i1266, align 4
  br label %mat_b.i1226

mat_a_long.i1223:                                 ; preds = %mat_a.i1221
  %araw.i1224 = and i64 %aw1.i1210, -4
  %alptr.i1225 = inttoptr i64 %araw.i1224 to ptr
  br label %mat_b.i1226

mat_b.i1226:                                      ; preds = %mat_a_long.i1223, %mat_a_short.i1263
  %aptr.i1227 = phi ptr [ %atmp.i1206, %mat_a_short.i1263 ], [ %alptr.i1225, %mat_a_long.i1223 ]
  %bshort.i1228 = icmp samesign ult i64 %blen.i1214, 13
  br i1 %bshort.i1228, label %mat_b_short.i1259, label %mat_b_long.i1229

mat_b_short.i1259:                                ; preds = %mat_b.i1226
  %bp4.i1260 = lshr i64 %bw0.i1211, 32
  %bp4_32.i1261 = trunc nuw i64 %bp4.i1260 to i32
  store i32 %bp4_32.i1261, ptr %btmp.i1207, align 4
  %btmp4.i1262 = getelementptr inbounds nuw i8, ptr %btmp.i1207, i64 4
  store i64 %bw1.i1212, ptr %btmp4.i1262, align 4
  br label %build.i1232

mat_b_long.i1229:                                 ; preds = %mat_b.i1226
  %braw.i1230 = and i64 %bw1.i1212, -4
  %blptr.i1231 = inttoptr i64 %braw.i1230 to ptr
  br label %build.i1232

build.i1232:                                      ; preds = %mat_b_long.i1229, %mat_b_short.i1259
  %bptr.i1233 = phi ptr [ %btmp.i1207, %mat_b_short.i1259 ], [ %blptr.i1231, %mat_b_long.i1229 ]
  %fits_sso.i1234 = icmp samesign ult i64 %tot.i1219, 13
  br i1 %fits_sso.i1234, label %build_sso.i1250, label %alloc_heap.i1235

build_sso.i1250:                                  ; preds = %build.i1232
  %out_sso8.i1251 = getelementptr inbounds nuw i8, ptr %out_sso.i1208, i64 8
  %tot32.i1252 = trunc nuw nsw i64 %tot.i1219 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i1208, i8 0, i64 16, i1 false)
  store i32 %tot32.i1252, ptr %out_sso.i1208, align 8
  %sso_dst_a.i1253 = getelementptr inbounds nuw i8, ptr %out_sso.i1208, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1253, ptr nonnull align 1 %aptr.i1227, i64 %alen.i1213, i1 false)
  %sso_dst_b.i1254 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1253, i64 %alen.i1213
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i1254, ptr nonnull align 1 %bptr.i1233, i64 %blen.i1214, i1 false)
  %rw0.i1255 = load i64, ptr %out_sso.i1208, align 8
  %rw1.i1256 = load i64, ptr %out_sso8.i1251, align 8
  %rs0.i1257 = insertvalue %ArchxStr poison, i64 %rw0.i1255, 0
  %rs1.i1258 = insertvalue %ArchxStr %rs0.i1257, i64 %rw1.i1256, 1
  br label %archx_str_concat.exit1271

alloc_heap.i1235:                                 ; preds = %build.i1232
  %hp.i1236 = call noalias align 16 ptr @malloc(i64 %tot.i1219)
  %hnull.i1237 = icmp eq ptr %hp.i1236, null
  br i1 %hnull.i1237, label %oom.i1249, label %copy_long.i1238

copy_long.i1238:                                  ; preds = %alloc_heap.i1235
  %hp_i.i1239 = ptrtoint ptr %hp.i1236 to i64
  %htagged.i1240 = or disjoint i64 %hp_i.i1239, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i1236, ptr nonnull align 1 %aptr.i1227, i64 %alen.i1213, i1 false)
  %dst_b.i1241 = getelementptr inbounds nuw i8, ptr %hp.i1236, i64 %alen.i1213
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i1241, ptr nonnull align 1 %bptr.i1233, i64 %blen.i1214, i1 false)
  %pref32.i1242 = load i32, ptr %hp.i1236, align 16
  %pref64.i1243 = zext i32 %pref32.i1242 to i64
  %pref_sh.i1244 = shl nuw i64 %pref64.i1243, 32
  %w0_out.i1245 = or disjoint i64 %pref_sh.i1244, %tot.i1219
  %ls0.i1246 = insertvalue %ArchxStr poison, i64 %w0_out.i1245, 0
  %ls1.i1247 = insertvalue %ArchxStr %ls0.i1246, i64 %htagged.i1240, 1
  br label %archx_str_concat.exit1271

archx_str_concat.exit1271:                        ; preds = %copy.i1773, %ret_a_clone.i1267, %copy.i1754, %ret_b_clone.i1269, %build_sso.i1250, %copy_long.i1238
  %common.ret.op.i1248 = phi %ArchxStr [ %rs1.i1258, %build_sso.i1250 ], [ %ls1.i1247, %copy_long.i1238 ], [ %out.i1759, %copy.i1754 ], [ %common.ret.op.i.i1733, %ret_b_clone.i1269 ], [ %out.i1778, %copy.i1773 ], [ %common.ret.op.i1188, %ret_a_clone.i1267 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i1206)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1207)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i1208)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1781)
  %w0.i1782 = extractvalue %ArchxStr %common.ret.op.i1248, 0
  %w1.i1783 = extractvalue %ArchxStr %common.ret.op.i1248, 1
  %len.i1784 = and i64 %w0.i1782, 4294967295
  %short.i1785 = icmp samesign ult i64 %len.i1784, 13
  br i1 %short.i1785, label %emit.i1806, label %emit.thread.i1786

emit.thread.i1786:                                ; preds = %archx_str_concat.exit1271
  %raw.i1787 = and i64 %w1.i1783, -4
  %lptr.i1788 = inttoptr i64 %raw.i1787 to ptr
  br label %chk_nul.i1789

emit.i1806:                                       ; preds = %archx_str_concat.exit1271
  %p4.i1807 = lshr i64 %w0.i1782, 32
  %p4_32.i1808 = trunc nuw i64 %p4.i1807 to i32
  store i32 %p4_32.i1808, ptr %tmp.i1781, align 4
  %tmp4.i1809 = getelementptr inbounds nuw i8, ptr %tmp.i1781, i64 4
  store i64 %w1.i1783, ptr %tmp4.i1809, align 4
  %pos.not.i1810 = icmp eq i64 %len.i1784, 0
  br i1 %pos.not.i1810, label %do_nl.i1801, label %chk_nul.i1789

chk_nul.i1789:                                    ; preds = %emit.i1806, %emit.thread.i1786
  %data3.i1790 = phi ptr [ %lptr.i1788, %emit.thread.i1786 ], [ %tmp.i1781, %emit.i1806 ]
  %nul.i1791 = call ptr @memchr(ptr nonnull %data3.i1790, i32 0, i64 %len.i1784)
  %has_nul.not.i1792 = icmp eq ptr %nul.i1791, null
  br i1 %has_nul.not.i1792, label %fast_printf.i1803, label %byte_loop.i1793

fast_printf.i1803:                                ; preds = %chk_nul.i1789
  %len32.i1804 = trunc i64 %w0.i1782 to i32
  %np.i1805 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1804, ptr nonnull %data3.i1790)
  br label %archx_str_print.exit1811

byte_loop.i1793:                                  ; preds = %chk_nul.i1789, %byte_loop.i1793
  %bi.i1794 = phi i64 [ %bnext.i1799, %byte_loop.i1793 ], [ 0, %chk_nul.i1789 ]
  %bp.i1795 = getelementptr inbounds nuw i8, ptr %data3.i1790, i64 %bi.i1794
  %ch8.i1796 = load i8, ptr %bp.i1795, align 1
  %ch32.i1797 = zext i8 %ch8.i1796 to i32
  %pc.i1798 = call i32 @putchar(i32 %ch32.i1797)
  %bnext.i1799 = add nuw nsw i64 %bi.i1794, 1
  %exitcond.not.i1800 = icmp eq i64 %bnext.i1799, %len.i1784
  br i1 %exitcond.not.i1800, label %do_nl.i1801, label %byte_loop.i1793

do_nl.i1801:                                      ; preds = %byte_loop.i1793, %emit.i1806
  %nc.i1802 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1811

archx_str_print.exit1811:                         ; preds = %fast_printf.i1803, %do_nl.i1801
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1781)
  %tag.i281 = and i64 %w1.i1783, 1
  %owned.not.i282 = icmp eq i64 %tag.i281, 0
  %or.cond2095 = select i1 %short.i1785, i1 true, i1 %owned.not.i282
  br i1 %or.cond2095, label %archx_str_drop.exit286, label %do_free.i283

do_free.i283:                                     ; preds = %archx_str_print.exit1811
  %raw.i284 = and i64 %w1.i1783, -2
  %ptr.i285 = inttoptr i64 %raw.i284 to ptr
  call void @free(ptr %ptr.i285)
  br label %archx_str_drop.exit286

archx_str_drop.exit286:                           ; preds = %archx_str_print.exit1811, %do_free.i283
  %long.i289 = icmp samesign ult i64 %blen.i1214, 13
  %tag.i292 = and i64 %bw1.i1212, 1
  %owned.not.i293 = icmp eq i64 %tag.i292, 0
  %or.cond2096 = select i1 %long.i289, i1 true, i1 %owned.not.i293
  br i1 %or.cond2096, label %archx_str_drop.exit297, label %do_free.i294

do_free.i294:                                     ; preds = %archx_str_drop.exit286
  %raw.i295 = and i64 %bw1.i1212, -2
  %ptr.i296 = inttoptr i64 %raw.i295 to ptr
  call void @free(ptr %ptr.i296)
  br label %archx_str_drop.exit297

archx_str_drop.exit297:                           ; preds = %archx_str_drop.exit286, %do_free.i294
  %long.i300 = icmp samesign ult i64 %alen.i1213, 13
  %tag.i303 = and i64 %aw1.i1210, 1
  %owned.not.i304 = icmp eq i64 %tag.i303, 0
  %or.cond2097 = select i1 %long.i300, i1 true, i1 %owned.not.i304
  br i1 %or.cond2097, label %archx_str_drop.exit308, label %do_free.i305

do_free.i305:                                     ; preds = %archx_str_drop.exit297
  %raw.i306 = and i64 %aw1.i1210, -2
  %ptr.i307 = inttoptr i64 %raw.i306 to ptr
  call void @free(ptr %ptr.i307)
  br label %archx_str_drop.exit308

archx_str_drop.exit308:                           ; preds = %archx_str_drop.exit297, %do_free.i305
  %long.i311 = icmp samesign ult i64 %alen.i1157, 13
  %tag.i314 = and i64 %aw1.i1156, 1
  %owned.not.i315 = icmp eq i64 %tag.i314, 0
  %or.cond2098 = select i1 %long.i311, i1 true, i1 %owned.not.i315
  br i1 %or.cond2098, label %archx_str_drop.exit319, label %do_free.i316

do_free.i316:                                     ; preds = %archx_str_drop.exit308
  %raw.i317 = and i64 %aw1.i1156, -2
  %ptr.i318 = inttoptr i64 %raw.i317 to ptr
  call void @free(ptr %ptr.i318)
  br label %archx_str_drop.exit319

archx_str_drop.exit319:                           ; preds = %archx_str_drop.exit308, %do_free.i316
  %long.i322 = icmp samesign ult i64 %blen.i1103, 13
  %tag.i325 = and i64 %bw1.i1102, 1
  %owned.not.i326 = icmp eq i64 %tag.i325, 0
  %or.cond2099 = select i1 %long.i322, i1 true, i1 %owned.not.i326
  br i1 %or.cond2099, label %if.merge.4, label %do_free.i327

do_free.i327:                                     ; preds = %archx_str_drop.exit319
  %raw.i328 = and i64 %bw1.i1102, -2
  %ptr.i329 = inttoptr i64 %raw.i328 to ptr
  call void @free(ptr %ptr.i329)
  br label %if.merge.4

if.merge.4:                                       ; preds = %do_free.i327, %archx_str_drop.exit319, %archx_fn_find_gt.exit1682
  %t70 = extractvalue { i1, i64 } %common.ret.op.i1678, 0
  br i1 %t70, label %stropt.some.7, label %build.i1292.thread2221

stropt.some.7:                                    ; preds = %if.merge.4
  %t72 = extractvalue { i1, i64 } %common.ret.op.i1678, 1
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1813)
  %n32.i1814 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1813, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t72)
  %len.i1815 = sext i32 %n32.i1814 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1812)
  %z.i.i1816 = icmp slt i32 %n32.i1814, 1
  br i1 %z.i.i1816, label %stropt.done.8, label %chk_sso.i.i1817

oom.i.i1832:                                      ; preds = %alloc_heap.i.i1819
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1817:                                  ; preds = %stropt.some.7
  %short.i.i1818 = icmp samesign ult i32 %n32.i1814, 13
  br i1 %short.i.i1818, label %pack_sso.i.i1833, label %alloc_heap.i.i1819

pack_sso.i.i1833:                                 ; preds = %chk_sso.i.i1817
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1812, i8 0, i64 16, i1 false)
  store i32 %n32.i1814, ptr %sso.i.i1812, align 8
  %sso.i.i1812.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1812, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1812.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1813, i64 range(i64 -2147483648, 2147483650) %len.i1815, i1 false)
  %sso.i.i1812.0.sso.i.i1812.0.sso.i.i1812.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1835 = load i64, ptr %sso.i.i1812, align 8
  %sso.i.i1812.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1812, i64 8
  %sso.i.i1812.8.sso.i.i1812.8.sso.i.i1812.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1837 = load i64, ptr %sso.i.i1812.8.sroa_idx, align 8
  %ss0.i.i1838 = insertvalue %ArchxStr poison, i64 %sso.i.i1812.0.sso.i.i1812.0.sso.i.i1812.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1835, 0
  %ss1.i.i1839 = insertvalue %ArchxStr %ss0.i.i1838, i64 %sso.i.i1812.8.sso.i.i1812.8.sso.i.i1812.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1837, 1
  br label %stropt.done.8

alloc_heap.i.i1819:                               ; preds = %chk_sso.i.i1817
  %hp.i.i1820 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1815)
  %hnull.i.i1821 = icmp eq ptr %hp.i.i1820, null
  br i1 %hnull.i.i1821, label %oom.i.i1832, label %copy_long.i.i1822

copy_long.i.i1822:                                ; preds = %alloc_heap.i.i1819
  %hp_i.i.i1823 = ptrtoint ptr %hp.i.i1820 to i64
  %htagged.i.i1824 = or disjoint i64 %hp_i.i.i1823, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1820, ptr nonnull readonly align 8 %buf.i1813, i64 range(i64 -2147483648, 2147483650) %len.i1815, i1 false)
  %pref32.i.i1825 = load i32, ptr %hp.i.i1820, align 16
  %pref64.i.i1826 = zext i32 %pref32.i.i1825 to i64
  %pref_sh.i.i1827 = shl nuw i64 %pref64.i.i1826, 32
  %w0_out.i.i1828 = or disjoint i64 %pref_sh.i.i1827, %len.i1815
  %ls0.i.i1829 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1828, 0
  %ls1.i.i1830 = insertvalue %ArchxStr %ls0.i.i1829, i64 %htagged.i.i1824, 1
  br label %stropt.done.8

stropt.done.8:                                    ; preds = %copy_long.i.i1822, %pack_sso.i.i1833, %stropt.some.7
  %common.ret.op.i.i1831 = phi %ArchxStr [ %ss1.i.i1839, %pack_sso.i.i1833 ], [ %ls1.i.i1830, %copy_long.i.i1822 ], [ zeroinitializer, %stropt.some.7 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1812)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1813)
  %t73.fca.0.extract = extractvalue %ArchxStr %common.ret.op.i.i1831, 0
  %t73.fca.1.extract = extractvalue %ArchxStr %common.ret.op.i.i1831, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1273)
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %out_sso.i1274.sroa.6.sroa.5)
  %blen.i1277 = and i64 %t73.fca.0.extract, 4294967295
  %bz.i1279 = icmp eq i64 %blen.i1277, 0
  br i1 %bz.i1279, label %archx_str_concat.exit1325, label %calc_tot.i1280

calc_tot.i1280:                                   ; preds = %stropt.done.8
  %tot.i1281 = add nuw nsw i64 %blen.i1277, 8
  %too_big.i1282 = icmp samesign ugt i64 %blen.i1277, 2147483639
  br i1 %too_big.i1282, label %oom.i1309, label %mat_a.i1283

build.i1292.thread2221:                           ; preds = %if.merge.4
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1273)
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %out_sso.i1274.sroa.6.sroa.5)
  store i32 1701736270, ptr %btmp.i1273, align 4
  %btmp4.i13222228 = getelementptr inbounds nuw i8, ptr %btmp.i1273, i64 4
  store i64 0, ptr %btmp4.i13222228, align 4
  br label %build_sso.i1310

oom.i1309:                                        ; preds = %alloc_heap.i1295, %calc_tot.i1280
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1283:                                      ; preds = %calc_tot.i1280
  %bshort.i1288 = icmp samesign ult i64 %blen.i1277, 13
  br i1 %bshort.i1288, label %build.i1292, label %build.i1292.thread

build.i1292.thread:                               ; preds = %mat_a.i1283
  %braw.i1290 = and i64 %t73.fca.1.extract, -4
  %blptr.i1291 = inttoptr i64 %braw.i1290 to ptr
  br label %alloc_heap.i1295

build.i1292:                                      ; preds = %mat_a.i1283
  %bp4.i1320 = lshr i64 %t73.fca.0.extract, 32
  %bp4_32.i1321 = trunc nuw i64 %bp4.i1320 to i32
  store i32 %bp4_32.i1321, ptr %btmp.i1273, align 4
  %btmp4.i1322 = getelementptr inbounds nuw i8, ptr %btmp.i1273, i64 4
  store i64 %t73.fca.1.extract, ptr %btmp4.i1322, align 4
  %fits_sso.i1294 = icmp samesign ult i64 %blen.i1277, 5
  br i1 %fits_sso.i1294, label %build_sso.i1310, label %alloc_heap.i1295

build_sso.i1310:                                  ; preds = %build.i1292.thread2221, %build.i1292
  %tot.i1281203720442232 = phi i64 [ 12, %build.i1292.thread2221 ], [ %tot.i1281, %build.i1292 ]
  %stropt.res.71.sroa.3.02026203520462231 = phi i64 [ 0, %build.i1292.thread2221 ], [ %t73.fca.1.extract, %build.i1292 ]
  %blen.i12772027203420492230 = phi i64 [ 4, %build.i1292.thread2221 ], [ %blen.i1277, %build.i1292 ]
  store i32 0, ptr %out_sso.i1274.sroa.6.sroa.5, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %out_sso.i1274.sroa.6.sroa.5, ptr nonnull align 4 %btmp.i1273, i64 %blen.i12772027203420492230, i1 false)
  %out_sso.i1274.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i1281203720442232, 8319108853555789824
  %out_sso.i1274.sroa.6.sroa.5.0.out_sso.i1274.sroa.6.sroa.5.0.out_sso.i1274.sroa.6.sroa.5.0.out_sso.i1274.sroa.6.sroa.5.0.out_sso.i1274.sroa.6.8.rw1.i1316 = load i32, ptr %out_sso.i1274.sroa.6.sroa.5, align 4
  %out_sso.i1274.sroa.6.sroa.5.0.insert.ext = zext i32 %out_sso.i1274.sroa.6.sroa.5.0.out_sso.i1274.sroa.6.sroa.5.0.out_sso.i1274.sroa.6.sroa.5.0.out_sso.i1274.sroa.6.sroa.5.0.out_sso.i1274.sroa.6.8.rw1.i1316 to i64
  %out_sso.i1274.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i1274.sroa.6.sroa.5.0.insert.ext, 32
  %out_sso.i1274.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i1274.sroa.6.sroa.5.0.insert.shift, 1030188649
  %rs0.i1317 = insertvalue %ArchxStr poison, i64 %out_sso.i1274.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i1318 = insertvalue %ArchxStr %rs0.i1317, i64 %out_sso.i1274.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit1325

alloc_heap.i1295:                                 ; preds = %build.i1292.thread, %build.i1292
  %bptr.i12932220 = phi ptr [ %blptr.i1291, %build.i1292.thread ], [ %btmp.i1273, %build.i1292 ]
  %hp.i1296 = call noalias align 16 ptr @malloc(i64 %tot.i1281)
  %hnull.i1297 = icmp eq ptr %hp.i1296, null
  br i1 %hnull.i1297, label %oom.i1309, label %copy_long.i1298

copy_long.i1298:                                  ; preds = %alloc_heap.i1295
  %hp_i.i1299 = ptrtoint ptr %hp.i1296 to i64
  %htagged.i1300 = or disjoint i64 %hp_i.i1299, 1
  store i32 1936943469, ptr %hp.i1296, align 16
  %atmp.i1272.sroa.5.0.hp.i1296.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i1296, i64 4
  store i32 1030188649, ptr %atmp.i1272.sroa.5.0.hp.i1296.sroa_idx, align 4
  %dst_b.i1301 = getelementptr inbounds nuw i8, ptr %hp.i1296, i64 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %dst_b.i1301, ptr nonnull align 1 %bptr.i12932220, i64 %blen.i1277, i1 false)
  %w0_out.i1305 = or disjoint i64 %tot.i1281, 8319108853555789824
  %ls0.i1306 = insertvalue %ArchxStr poison, i64 %w0_out.i1305, 0
  %ls1.i1307 = insertvalue %ArchxStr %ls0.i1306, i64 %htagged.i1300, 1
  %0 = icmp samesign ult i64 %blen.i1277, 13
  br label %archx_str_concat.exit1325

archx_str_concat.exit1325:                        ; preds = %stropt.done.8, %build_sso.i1310, %copy_long.i1298
  %blen.i12772028 = phi i1 [ true, %build_sso.i1310 ], [ %0, %copy_long.i1298 ], [ true, %stropt.done.8 ]
  %stropt.res.71.sroa.3.02025 = phi i64 [ %stropt.res.71.sroa.3.02026203520462231, %build_sso.i1310 ], [ %t73.fca.1.extract, %copy_long.i1298 ], [ %t73.fca.1.extract, %stropt.done.8 ]
  %common.ret.op.i1308 = phi %ArchxStr [ %rs1.i1318, %build_sso.i1310 ], [ %ls1.i1307, %copy_long.i1298 ], [ { i64 8319108853555789832, i64 1030188649 }, %stropt.done.8 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1273)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %out_sso.i1274.sroa.6.sroa.5)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1842)
  %w0.i1843 = extractvalue %ArchxStr %common.ret.op.i1308, 0
  %w1.i1844 = extractvalue %ArchxStr %common.ret.op.i1308, 1
  %len.i1845 = and i64 %w0.i1843, 4294967295
  %short.i1846 = icmp samesign ult i64 %len.i1845, 13
  br i1 %short.i1846, label %emit.i1867, label %emit.thread.i1847

emit.thread.i1847:                                ; preds = %archx_str_concat.exit1325
  %raw.i1848 = and i64 %w1.i1844, -4
  %lptr.i1849 = inttoptr i64 %raw.i1848 to ptr
  br label %chk_nul.i1850

emit.i1867:                                       ; preds = %archx_str_concat.exit1325
  %p4.i1868 = lshr i64 %w0.i1843, 32
  %p4_32.i1869 = trunc nuw i64 %p4.i1868 to i32
  store i32 %p4_32.i1869, ptr %tmp.i1842, align 4
  %tmp4.i1870 = getelementptr inbounds nuw i8, ptr %tmp.i1842, i64 4
  store i64 %w1.i1844, ptr %tmp4.i1870, align 4
  %pos.not.i1871 = icmp eq i64 %len.i1845, 0
  br i1 %pos.not.i1871, label %do_nl.i1862, label %chk_nul.i1850

chk_nul.i1850:                                    ; preds = %emit.i1867, %emit.thread.i1847
  %data3.i1851 = phi ptr [ %lptr.i1849, %emit.thread.i1847 ], [ %tmp.i1842, %emit.i1867 ]
  %nul.i1852 = call ptr @memchr(ptr nonnull %data3.i1851, i32 0, i64 %len.i1845)
  %has_nul.not.i1853 = icmp eq ptr %nul.i1852, null
  br i1 %has_nul.not.i1853, label %fast_printf.i1864, label %byte_loop.i1854

fast_printf.i1864:                                ; preds = %chk_nul.i1850
  %len32.i1865 = trunc i64 %w0.i1843 to i32
  %np.i1866 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1865, ptr nonnull %data3.i1851)
  br label %archx_str_print.exit1872

byte_loop.i1854:                                  ; preds = %chk_nul.i1850, %byte_loop.i1854
  %bi.i1855 = phi i64 [ %bnext.i1860, %byte_loop.i1854 ], [ 0, %chk_nul.i1850 ]
  %bp.i1856 = getelementptr inbounds nuw i8, ptr %data3.i1851, i64 %bi.i1855
  %ch8.i1857 = load i8, ptr %bp.i1856, align 1
  %ch32.i1858 = zext i8 %ch8.i1857 to i32
  %pc.i1859 = call i32 @putchar(i32 %ch32.i1858)
  %bnext.i1860 = add nuw nsw i64 %bi.i1855, 1
  %exitcond.not.i1861 = icmp eq i64 %bnext.i1860, %len.i1845
  br i1 %exitcond.not.i1861, label %do_nl.i1862, label %byte_loop.i1854

do_nl.i1862:                                      ; preds = %byte_loop.i1854, %emit.i1867
  %nc.i1863 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1872

archx_str_print.exit1872:                         ; preds = %fast_printf.i1864, %do_nl.i1862
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1842)
  %tag.i336 = and i64 %w1.i1844, 1
  %owned.not.i337 = icmp eq i64 %tag.i336, 0
  %or.cond2100 = select i1 %short.i1846, i1 true, i1 %owned.not.i337
  br i1 %or.cond2100, label %archx_str_drop.exit341, label %do_free.i338

do_free.i338:                                     ; preds = %archx_str_print.exit1872
  %raw.i339 = and i64 %w1.i1844, -2
  %ptr.i340 = inttoptr i64 %raw.i339 to ptr
  call void @free(ptr %ptr.i340)
  br label %archx_str_drop.exit341

archx_str_drop.exit341:                           ; preds = %archx_str_print.exit1872, %do_free.i338
  %tag.i347 = and i64 %stropt.res.71.sroa.3.02025, 1
  %owned.not.i348 = icmp eq i64 %tag.i347, 0
  %or.cond2101 = select i1 %blen.i12772028, i1 true, i1 %owned.not.i348
  br i1 %or.cond2101, label %archx_str_drop.exit352, label %do_free.i349

do_free.i349:                                     ; preds = %archx_str_drop.exit341
  %raw.i350 = and i64 %stropt.res.71.sroa.3.02025, -2
  %ptr.i351 = inttoptr i64 %raw.i350 to ptr
  call void @free(ptr %ptr.i351)
  br label %archx_str_drop.exit352

archx_str_drop.exit352:                           ; preds = %archx_str_drop.exit341, %do_free.i349
  %t109 = call noalias align 16 dereferenceable_or_null(240) ptr @malloc(i64 240)
  %t110 = icmp eq ptr %t109, null
  br i1 %t110, label %alloc.oom.12, label %alloc.ok.11

alloc.oom.12:                                     ; preds = %archx_str_drop.exit352
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.11:                                      ; preds = %archx_str_drop.exit352
  store i64 0, ptr %t109, align 16
  %t109.repack25 = getelementptr inbounds nuw i8, ptr %t109, i64 8
  store i64 4615063718147915776, ptr %t109.repack25, align 8
  %t109.repack25.repack26 = getelementptr inbounds nuw i8, ptr %t109, i64 16
  %t112.repack29 = getelementptr inbounds nuw i8, ptr %t109, i64 48
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(32) %t109.repack25.repack26, i8 0, i64 32, i1 false)
  store i64 4622945017495814144, ptr %t112.repack29, align 16
  %t112.repack29.repack30 = getelementptr inbounds nuw i8, ptr %t109, i64 56
  %t113 = getelementptr inbounds nuw i8, ptr %t109, i64 80
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %t112.repack29.repack30, i8 0, i64 24, i1 false)
  store i64 1, ptr %t113, align 16
  %t113.repack33 = getelementptr inbounds nuw i8, ptr %t109, i64 88
  store i64 4616189618054758400, ptr %t113.repack33, align 8
  %t113.repack33.repack34 = getelementptr inbounds nuw i8, ptr %t109, i64 96
  store i64 4616189618054758400, ptr %t113.repack33.repack34, align 16
  %t113.repack33.repack35 = getelementptr inbounds nuw i8, ptr %t109, i64 104
  %t114 = getelementptr inbounds nuw i8, ptr %t109, i64 120
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %t113.repack33.repack35, i8 0, i64 16, i1 false)
  store i64 1, ptr %t114, align 8
  %t114.repack37 = getelementptr inbounds nuw i8, ptr %t109, i64 128
  store i64 4613937818241073152, ptr %t114.repack37, align 16
  %t114.repack37.repack38 = getelementptr inbounds nuw i8, ptr %t109, i64 136
  store i64 4617315517961601024, ptr %t114.repack37.repack38, align 8
  %t114.repack37.repack39 = getelementptr inbounds nuw i8, ptr %t109, i64 144
  %t115 = getelementptr inbounds nuw i8, ptr %t109, i64 160
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %t114.repack37.repack39, i8 0, i64 16, i1 false)
  store <6 x i64> <i64 2, i64 7453016942991900710, i64 ptrtoint (ptr @.str.1 to i64), i64 7, i64 9, i64 3>, ptr %t115, align 16
  %t116.repack49 = getelementptr inbounds nuw i8, ptr %t109, i64 208
  %btmp4.i.i = getelementptr inbounds nuw i8, ptr %btmp.i.i, i64 4
  %btmp4.i191.i = getelementptr inbounds nuw i8, ptr %btmp.i159.i, i64 4
  %btmp4.i291.i = getelementptr inbounds nuw i8, ptr %btmp.i246.i, i64 4
  %btmp4.i241.i = getelementptr inbounds nuw i8, ptr %btmp.i196.i, i64 4
  %atmp4.i331.i = getelementptr inbounds nuw i8, ptr %atmp.i295.i, i64 4
  %out_sso8.i323.i = getelementptr inbounds nuw i8, ptr %out_sso.i297.i, i64 8
  %sso_dst_a.i325.i = getelementptr inbounds nuw i8, ptr %out_sso.i297.i, i64 4
  %atmp4.i393.i = getelementptr inbounds nuw i8, ptr %atmp.i333.i, i64 4
  %btmp4.i389.i = getelementptr inbounds nuw i8, ptr %btmp.i334.i, i64 4
  %out_sso8.i378.i = getelementptr inbounds nuw i8, ptr %out_sso.i335.i, i64 8
  %sso_dst_a.i380.i = getelementptr inbounds nuw i8, ptr %out_sso.i335.i, i64 4
  %atmp4.i449.i = getelementptr inbounds nuw i8, ptr %atmp.i399.i, i64 4
  %out_sso8.i438.i = getelementptr inbounds nuw i8, ptr %out_sso.i401.i, i64 8
  %sso_dst_a.i440.i = getelementptr inbounds nuw i8, ptr %out_sso.i401.i, i64 4
  %atmp4.i513.i = getelementptr inbounds nuw i8, ptr %atmp.i453.i, i64 4
  %btmp4.i509.i = getelementptr inbounds nuw i8, ptr %btmp.i454.i, i64 4
  %out_sso8.i498.i = getelementptr inbounds nuw i8, ptr %out_sso.i455.i, i64 8
  %sso_dst_a.i500.i = getelementptr inbounds nuw i8, ptr %out_sso.i455.i, i64 4
  %tmp4.i1941 = getelementptr inbounds nuw i8, ptr %tmp.i1913, i64 4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(32) %t116.repack49, i8 0, i64 32, i1 false)
  %sso.i.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i, i64 4
  %sso.i.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i, i64 8
  %sso.i.i620.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i620.i, i64 4
  %sso.i.i620.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i620.i, i64 8
  br label %foreach.body.14

foreach.body.14:                                  ; preds = %alloc.ok.11, %archx_str_drop.exit363
  %var.sh.125.sroa.0.02157 = phi i64 [ 0, %alloc.ok.11 ], [ %t129.unpack, %archx_str_drop.exit363 ]
  %var.sh.125.sroa.5.02156 = phi i64 [ 0, %alloc.ok.11 ], [ %dst.sroa.2.0.i2059, %archx_str_drop.exit363 ]
  %var.sh.125.sroa.10.02155 = phi i64 [ 0, %alloc.ok.11 ], [ %dst.sroa.5.0.i2061, %archx_str_drop.exit363 ]
  %foreach.idx.124.02154 = phi i64 [ 0, %alloc.ok.11 ], [ %t135, %archx_str_drop.exit363 ]
  %t128 = getelementptr inbounds nuw %ArchxEnum_Shape, ptr %t109, i64 %foreach.idx.124.02154
  %t129.unpack = load i64, ptr %t128, align 8
  %t129.elt57 = getelementptr inbounds nuw i8, ptr %t128, i64 8
  %t129.unpack58.unpack = load i64, ptr %t129.elt57, align 8
  %t129.unpack58.elt60 = getelementptr inbounds nuw i8, ptr %t128, i64 16
  %t129.unpack58.unpack61 = load i64, ptr %t129.unpack58.elt60, align 8
  %t129.unpack58.elt62 = getelementptr inbounds nuw i8, ptr %t128, i64 24
  %t129.unpack58.unpack63 = load i64, ptr %t129.unpack58.elt62, align 8
  %t129.unpack58.elt64 = getelementptr inbounds nuw i8, ptr %t128, i64 32
  %t129.unpack58.unpack65 = load i64, ptr %t129.unpack58.elt64, align 8
  %cond.i = icmp eq i64 %var.sh.125.sroa.0.02157, 2
  br i1 %cond.i, label %v.2.i, label %archx_enum_drop_Shape.exit

v.2.i:                                            ; preds = %foreach.body.14
  %len.i.i = and i64 %var.sh.125.sroa.5.02156, 4294967295
  %long.i.i = icmp samesign ult i64 %len.i.i, 13
  %tag.i.i = and i64 %var.sh.125.sroa.10.02155, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond.i = select i1 %long.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond.i, label %archx_enum_drop_Shape.exit, label %do_free.i.i

do_free.i.i:                                      ; preds = %v.2.i
  %raw.i.i = and i64 %var.sh.125.sroa.10.02155, -2
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  call void @free(ptr %ptr.i.i)
  br label %archx_enum_drop_Shape.exit

archx_enum_drop_Shape.exit:                       ; preds = %foreach.body.14, %v.2.i, %do_free.i.i
  %cond.i1876 = icmp eq i64 %t129.unpack, 2
  br i1 %cond.i1876, label %v.2.i1877, label %archx_enum_clone_Shape.exit

v.2.i1877:                                        ; preds = %archx_enum_drop_Shape.exit
  %t2.fca.0.insert.i = insertvalue %ArchxStr poison, i64 %t129.unpack58.unpack, 0
  %t2.fca.1.insert.i = insertvalue %ArchxStr %t2.fca.0.insert.i, i64 %t129.unpack58.unpack61, 1
  %len.i.i1878 = and i64 %t129.unpack58.unpack, 4294967295
  %long.i.i1879 = icmp samesign ult i64 %len.i.i1878, 13
  %tag.i.i1880 = and i64 %t129.unpack58.unpack61, 3
  %owned.not.i.i1881 = icmp eq i64 %tag.i.i1880, 0
  %or.cond.i1882 = select i1 %long.i.i1879, i1 true, i1 %owned.not.i.i1881
  br i1 %or.cond.i1882, label %archx_enum_clone_Shape.exit.thread, label %dup_heap.i.i

dup_heap.i.i:                                     ; preds = %v.2.i1877
  %dst.i.i = call noalias align 16 ptr @malloc(i64 %len.i.i1878)
  %isnull.i.i = icmp eq ptr %dst.i.i, null
  br i1 %isnull.i.i, label %oom.i.i1884, label %copy.i.i

oom.i.i1884:                                      ; preds = %dup_heap.i.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i:                                         ; preds = %dup_heap.i.i
  %src_i.i.i = and i64 %t129.unpack58.unpack61, -4
  %src.i.i = inttoptr i64 %src_i.i.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i, ptr nonnull align 4 %src.i.i, i64 %len.i.i1878, i1 false)
  %dst_i.i.i = ptrtoint ptr %dst.i.i to i64
  %tagged.i.i = or disjoint i64 %dst_i.i.i, 1
  %out.i.i = insertvalue %ArchxStr %t2.fca.1.insert.i, i64 %tagged.i.i, 1
  br label %archx_enum_clone_Shape.exit.thread

archx_enum_clone_Shape.exit.thread:               ; preds = %v.2.i1877, %copy.i.i
  %common.ret.op.i.i1883 = phi %ArchxStr [ %out.i.i, %copy.i.i ], [ %t2.fca.1.insert.i, %v.2.i1877 ]
  %t3.fca.0.extract.i = extractvalue %ArchxStr %common.ret.op.i.i1883, 0
  %t3.fca.1.extract.i = extractvalue %ArchxStr %common.ret.op.i.i1883, 1
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i247.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i197.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i.sroa.6.sroa.5.sroa.0.i)
  %len.i.i.i = and i64 %t3.fca.0.extract.i, 4294967295
  %long.i.i.i = icmp samesign ult i64 %len.i.i.i, 13
  %tag.i.i.i = and i64 %t3.fca.1.extract.i, 3
  %owned.not.i.i.i = icmp eq i64 %tag.i.i.i, 0
  %or.cond.i.i = select i1 %long.i.i.i, i1 true, i1 %owned.not.i.i.i
  br i1 %or.cond.i.i, label %archx_enum_clone_Shape.exit.thread.i, label %dup_heap.i.i.i

archx_enum_clone_Shape.exit:                      ; preds = %archx_enum_drop_Shape.exit
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i247.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i197.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i.sroa.6.sroa.5.sroa.0.i)
  switch i64 %t129.unpack, label %archx_enum_drop_Shape.exit710.i [
    i64 1, label %pat.enum.ok.8.i
    i64 0, label %pat.enum.ok.2.i
  ]

dup_heap.i.i.i:                                   ; preds = %archx_enum_clone_Shape.exit.thread
  %dst.i.i.i = call noalias align 16 ptr @malloc(i64 %len.i.i.i)
  %isnull.i.i.i = icmp eq ptr %dst.i.i.i, null
  br i1 %isnull.i.i.i, label %oom.i.i.i, label %copy.i.i.i

oom.i.i.i:                                        ; preds = %dup_heap.i.i.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i.i:                                       ; preds = %dup_heap.i.i.i
  %src_i.i.i.i = and i64 %t3.fca.1.extract.i, -4
  %src.i.i.i = inttoptr i64 %src_i.i.i.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i.i, ptr nonnull align 4 %src.i.i.i, i64 %len.i.i.i, i1 false)
  %dst_i.i.i.i = ptrtoint ptr %dst.i.i.i to i64
  %tagged.i.i.i = or disjoint i64 %dst_i.i.i.i, 1
  %out.i.i.i = insertvalue %ArchxStr %common.ret.op.i.i1883, i64 %tagged.i.i.i, 1
  %.pre = extractvalue %ArchxStr %common.ret.op.i.i1883, 0
  %.pre2198 = and i64 %.pre, 4294967295
  br label %archx_enum_clone_Shape.exit.thread.i

archx_enum_clone_Shape.exit.thread.i:             ; preds = %copy.i.i.i, %archx_enum_clone_Shape.exit.thread
  %tag.i574.i.pre-phi = phi i64 [ 1, %copy.i.i.i ], [ %tag.i.i.i, %archx_enum_clone_Shape.exit.thread ]
  %len.i569.i.pre-phi = phi i64 [ %.pre2198, %copy.i.i.i ], [ %len.i.i.i, %archx_enum_clone_Shape.exit.thread ]
  %t3.fca.1.extract.i.i.pre-phi = phi i64 [ %tagged.i.i.i, %copy.i.i.i ], [ %t3.fca.1.extract.i, %archx_enum_clone_Shape.exit.thread ]
  %t3.fca.0.extract.i.i.pre-phi = phi i64 [ %.pre, %copy.i.i.i ], [ %t3.fca.0.extract.i, %archx_enum_clone_Shape.exit.thread ]
  %common.ret.op.i.i.i = phi %ArchxStr [ %out.i.i.i, %copy.i.i.i ], [ %common.ret.op.i.i1883, %archx_enum_clone_Shape.exit.thread ]
  %long.i570.i = icmp samesign ult i64 %len.i569.i.pre-phi, 13
  %owned.not.i575.i = icmp eq i64 %tag.i574.i.pre-phi, 0
  %or.cond745.i = select i1 %long.i570.i, i1 true, i1 %owned.not.i575.i
  br i1 %or.cond745.i, label %archx_str_clone.exit.i1912, label %dup_heap.i.i1903

pat.enum.ok.2.i:                                  ; preds = %archx_enum_clone_Shape.exit
  %1 = bitcast i64 %t129.unpack58.unpack to double
  %t10.i = fcmp ult double %1, 1.000000e+01
  %t25.i = call fastcc { i64, i64 } @archx_str_from_float(double %1)
  %newret = extractvalue { i64, i64 } %t25.i, 0
  %newret2250 = extractvalue { i64, i64 } %t25.i, 1
  %blen.i162.i = and i64 %newret, 4294967295
  %bz.i163.i = icmp eq i64 %blen.i162.i, 0
  br i1 %t10.i, label %pat.enum.ok.6.i, label %match.body.3.i

match.body.3.i:                                   ; preds = %pat.enum.ok.2.i
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i.i)
  br i1 %bz.i163.i, label %archx_str_concat.exit.thread.i, label %calc_tot.i.i

archx_str_concat.exit.thread.i:                   ; preds = %match.body.3.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i.i)
  br label %archx_fn_describe_shape.exit

calc_tot.i.i:                                     ; preds = %match.body.3.i
  %tot.i.i = add nuw nsw i64 %blen.i162.i, 13
  %too_big.i.i = icmp samesign ugt i64 %blen.i162.i, 2147483634
  br i1 %too_big.i.i, label %oom.i.i1901, label %mat_a.i.i

oom.i.i1901:                                      ; preds = %build.i.i, %calc_tot.i.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i.i:                                        ; preds = %calc_tot.i.i
  %bshort.i.i = icmp samesign ult i64 %blen.i162.i, 13
  br i1 %bshort.i.i, label %mat_b_short.i.i, label %mat_b_long.i.i

mat_b_short.i.i:                                  ; preds = %mat_a.i.i
  %bp4.i.i = lshr i64 %newret, 32
  %bp4_32.i.i = trunc nuw i64 %bp4.i.i to i32
  store i32 %bp4_32.i.i, ptr %btmp.i.i, align 4
  store i64 %newret2250, ptr %btmp4.i.i, align 4
  br label %build.i.i

mat_b_long.i.i:                                   ; preds = %mat_a.i.i
  %braw.i.i = and i64 %newret2250, -4
  %blptr.i.i = inttoptr i64 %braw.i.i to ptr
  br label %build.i.i

build.i.i:                                        ; preds = %mat_b_long.i.i, %mat_b_short.i.i
  %bptr.i.i = phi ptr [ %btmp.i.i, %mat_b_short.i.i ], [ %blptr.i.i, %mat_b_long.i.i ]
  %hp.i.i1888 = call noalias align 16 ptr @malloc(i64 %tot.i.i)
  %hnull.i.i1889 = icmp eq ptr %hp.i.i1888, null
  br i1 %hnull.i.i1889, label %oom.i.i1901, label %archx_str_concat.exit.i

archx_str_concat.exit.i:                          ; preds = %build.i.i
  %hp_i.i.i1890 = ptrtoint ptr %hp.i.i1888 to i64
  %htagged.i.i1891 = or disjoint i64 %hp_i.i.i1890, 1
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(13) %hp.i.i1888, ptr noundef nonnull align 4 dereferenceable(13) @.str.0, i64 13, i1 false)
  %dst_b.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i1888, i64 13
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i.i, ptr nonnull align 1 %bptr.i.i, i64 %blen.i162.i, i1 false)
  %w0_out.i.i1892 = or disjoint i64 %tot.i.i, 7454127449735954432
  %ls0.i.i1893 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1892, 0
  %ls1.i.i1894 = insertvalue %ArchxStr %ls0.i.i1893, i64 %htagged.i.i1891, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i.i)
  %tag.i.i1895 = and i64 %newret2250, 1
  %owned.not.i.i1896 = icmp eq i64 %tag.i.i1895, 0
  %or.cond.i1897 = select i1 %bshort.i.i, i1 true, i1 %owned.not.i.i1896
  br i1 %or.cond.i1897, label %archx_fn_describe_shape.exit, label %do_free.i.i1898

do_free.i.i1898:                                  ; preds = %archx_str_concat.exit.i
  %raw.i.i1899 = and i64 %newret2250, -2
  %ptr.i.i1900 = inttoptr i64 %raw.i.i1899 to ptr
  call void @free(ptr %ptr.i.i1900)
  br label %archx_fn_describe_shape.exit

pat.enum.ok.6.i:                                  ; preds = %pat.enum.ok.2.i
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i159.i)
  br i1 %bz.i163.i, label %archx_str_concat.exit194.thread.i, label %calc_tot.i164.i

archx_str_concat.exit194.thread.i:                ; preds = %pat.enum.ok.6.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i159.i)
  br label %archx_fn_describe_shape.exit

calc_tot.i164.i:                                  ; preds = %pat.enum.ok.6.i
  %tot.i165.i = add nuw nsw i64 %blen.i162.i, 7
  %too_big.i166.i = icmp samesign ugt i64 %blen.i162.i, 2147483640
  br i1 %too_big.i166.i, label %oom.i187.i, label %mat_a.i167.i

oom.i187.i:                                       ; preds = %alloc_heap.i.i1902, %calc_tot.i164.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i167.i:                                     ; preds = %calc_tot.i164.i
  %bshort.i168.i = icmp samesign ult i64 %blen.i162.i, 13
  br i1 %bshort.i168.i, label %build.i172.i, label %build.i172.thread.i

build.i172.thread.i:                              ; preds = %mat_a.i167.i
  %braw.i170.i = and i64 %newret2250, -4
  %blptr.i171.i = inttoptr i64 %braw.i170.i to ptr
  br label %alloc_heap.i.i1902

build.i172.i:                                     ; preds = %mat_a.i167.i
  %bp4.i189.i = lshr i64 %newret, 32
  %bp4_32.i190.i = trunc nuw i64 %bp4.i189.i to i32
  store i32 %bp4_32.i190.i, ptr %btmp.i159.i, align 4
  store i64 %newret2250, ptr %btmp4.i191.i, align 4
  %fits_sso.i.i = icmp samesign ult i64 %blen.i162.i, 6
  br i1 %fits_sso.i.i, label %archx_str_concat.exit194.thread769.i, label %alloc_heap.i.i1902

archx_str_concat.exit194.thread769.i:             ; preds = %build.i172.i
  store i40 0, ptr %out_sso.i.sroa.6.sroa.5.sroa.0.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i.sroa.6.sroa.5.sroa.0.i, ptr nonnull align 4 %btmp.i159.i, i64 %blen.i162.i, i1 false)
  %out_sso.i.sroa.6.sroa.5.sroa.0.i.0.out_sso.i.sroa.6.sroa.5.sroa.0.i.0.out_sso.i.sroa.6.sroa.5.sroa.0.i.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.8.rw1.i.i = load i40, ptr %out_sso.i.sroa.6.sroa.5.sroa.0.i, align 8
  %out_sso.i.sroa.6.sroa.5.0.insert.ext.i = zext i40 %out_sso.i.sroa.6.sroa.5.sroa.0.i.0.out_sso.i.sroa.6.sroa.5.sroa.0.i.0.out_sso.i.sroa.6.sroa.5.sroa.0.i.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.sroa.0.0.out_sso.i.sroa.6.sroa.5.0.out_sso.i.sroa.6.8.rw1.i.i to i64
  %out_sso.i.sroa.6.sroa.5.0.insert.shift.i = shl nuw i64 %out_sso.i.sroa.6.sroa.5.0.insert.ext.i, 24
  %out_sso.i.sroa.6.sroa.0.0.insert.insert.i = or disjoint i64 %out_sso.i.sroa.6.sroa.5.0.insert.shift.i, 3827052
  %out_sso.i.sroa.0.sroa.0.0.insert.insert.pn771.i = or disjoint i64 %tot.i165.i, 7165905831022559232
  %rs0.i.pn772.i = insertvalue %ArchxStr poison, i64 %out_sso.i.sroa.0.sroa.0.0.insert.insert.pn771.i, 0
  %common.ret.op.i186773.i = insertvalue %ArchxStr %rs0.i.pn772.i, i64 %out_sso.i.sroa.6.sroa.0.0.insert.insert.i, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i159.i)
  br label %archx_fn_describe_shape.exit

alloc_heap.i.i1902:                               ; preds = %build.i172.i, %build.i172.thread.i
  %bptr.i173768.i = phi ptr [ %blptr.i171.i, %build.i172.thread.i ], [ %btmp.i159.i, %build.i172.i ]
  %hp.i174.i = call noalias align 16 ptr @malloc(i64 %tot.i165.i)
  %hnull.i175.i = icmp eq ptr %hp.i174.i, null
  br i1 %hnull.i175.i, label %oom.i187.i, label %archx_str_concat.exit194.i

archx_str_concat.exit194.i:                       ; preds = %alloc_heap.i.i1902
  %hp_i.i177.i = ptrtoint ptr %hp.i174.i to i64
  %htagged.i178.i = or disjoint i64 %hp_i.i177.i, 1
  store i32 1668442467, ptr %hp.i174.i, align 16
  %atmp.i.sroa.5.0.hp.i174.sroa_idx.i = getelementptr inbounds nuw i8, ptr %hp.i174.i, i64 4
  store i24 3827052, ptr %atmp.i.sroa.5.0.hp.i174.sroa_idx.i, align 4
  %dst_b.i179.i = getelementptr inbounds nuw i8, ptr %hp.i174.i, i64 7
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i179.i, ptr nonnull align 1 %bptr.i173768.i, i64 %blen.i162.i, i1 false)
  %out_sso.i.sroa.0.sroa.0.0.insert.insert.pn.i = or disjoint i64 %tot.i165.i, 7165905831022559232
  %rs0.i.pn.i = insertvalue %ArchxStr poison, i64 %out_sso.i.sroa.0.sroa.0.0.insert.insert.pn.i, 0
  %common.ret.op.i186.i = insertvalue %ArchxStr %rs0.i.pn.i, i64 %htagged.i178.i, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i159.i)
  %tag.i65.i = and i64 %newret2250, 1
  %owned.not.i66.i = icmp eq i64 %tag.i65.i, 0
  %or.cond742.i = select i1 %bshort.i168.i, i1 true, i1 %owned.not.i66.i
  br i1 %or.cond742.i, label %archx_fn_describe_shape.exit, label %do_free.i67.i

do_free.i67.i:                                    ; preds = %archx_str_concat.exit194.i
  %raw.i68.i = and i64 %newret2250, -2
  %ptr.i69.i = inttoptr i64 %raw.i68.i to ptr
  call void @free(ptr %ptr.i69.i)
  br label %archx_fn_describe_shape.exit

pat.enum.ok.8.i:                                  ; preds = %archx_enum_clone_Shape.exit
  %2 = bitcast i64 %t129.unpack58.unpack to double
  %3 = bitcast i64 %t129.unpack58.unpack61 to double
  %t40.i1885 = fcmp oeq double %2, %3
  %t41.i1886 = fmul double %2, %3
  %t42.i = call fastcc { i64, i64 } @archx_str_from_float(double %t41.i1886)
  %newret2252 = extractvalue { i64, i64 } %t42.i, 0
  %newret2254 = extractvalue { i64, i64 } %t42.i, 1
  %blen.i200.i = and i64 %newret2252, 4294967295
  %bz.i201.i = icmp eq i64 %blen.i200.i, 0
  br i1 %t40.i1885, label %match.body.9.i, label %pat.enum.ok.12.i

match.body.9.i:                                   ; preds = %pat.enum.ok.8.i
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i196.i)
  br i1 %bz.i201.i, label %archx_str_concat.exit244.thread.i, label %calc_tot.i202.i

archx_str_concat.exit244.thread.i:                ; preds = %match.body.9.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i196.i)
  br label %archx_fn_describe_shape.exit

calc_tot.i202.i:                                  ; preds = %match.body.9.i
  %tot.i203.i = add nuw nsw i64 %blen.i200.i, 7
  %too_big.i204.i = icmp samesign ugt i64 %blen.i200.i, 2147483640
  br i1 %too_big.i204.i, label %oom.i228.i, label %mat_a.i205.i

oom.i228.i:                                       ; preds = %alloc_heap.i214.i, %calc_tot.i202.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i205.i:                                     ; preds = %calc_tot.i202.i
  %bshort.i207.i = icmp samesign ult i64 %blen.i200.i, 13
  br i1 %bshort.i207.i, label %build.i211.i, label %build.i211.thread.i

build.i211.thread.i:                              ; preds = %mat_a.i205.i
  %braw.i209.i = and i64 %newret2254, -4
  %blptr.i210.i = inttoptr i64 %braw.i209.i to ptr
  br label %alloc_heap.i214.i

build.i211.i:                                     ; preds = %mat_a.i205.i
  %bp4.i239.i = lshr i64 %newret2252, 32
  %bp4_32.i240.i = trunc nuw i64 %bp4.i239.i to i32
  store i32 %bp4_32.i240.i, ptr %btmp.i196.i, align 4
  store i64 %newret2254, ptr %btmp4.i241.i, align 4
  %fits_sso.i213.i = icmp samesign ult i64 %blen.i200.i, 6
  br i1 %fits_sso.i213.i, label %archx_str_concat.exit244.thread780.i, label %alloc_heap.i214.i

archx_str_concat.exit244.thread780.i:             ; preds = %build.i211.i
  store i40 0, ptr %out_sso.i197.sroa.6.sroa.5.sroa.0.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i197.sroa.6.sroa.5.sroa.0.i, ptr nonnull align 4 %btmp.i196.i, i64 %blen.i200.i, i1 false)
  %out_sso.i197.sroa.6.sroa.5.sroa.0.i.0.out_sso.i197.sroa.6.sroa.5.sroa.0.i.0.out_sso.i197.sroa.6.sroa.5.sroa.0.i.0.out_sso.i197.sroa.6.sroa.5.sroa.0.0.out_sso.i197.sroa.6.sroa.5.sroa.0.0.out_sso.i197.sroa.6.sroa.5.sroa.0.0.out_sso.i197.sroa.6.sroa.5.0.out_sso.i197.sroa.6.8.rw1.i235.i = load i40, ptr %out_sso.i197.sroa.6.sroa.5.sroa.0.i, align 8
  %out_sso.i197.sroa.6.sroa.5.0.insert.ext.i = zext i40 %out_sso.i197.sroa.6.sroa.5.sroa.0.i.0.out_sso.i197.sroa.6.sroa.5.sroa.0.i.0.out_sso.i197.sroa.6.sroa.5.sroa.0.i.0.out_sso.i197.sroa.6.sroa.5.sroa.0.0.out_sso.i197.sroa.6.sroa.5.sroa.0.0.out_sso.i197.sroa.6.sroa.5.sroa.0.0.out_sso.i197.sroa.6.sroa.5.0.out_sso.i197.sroa.6.8.rw1.i235.i to i64
  %out_sso.i197.sroa.6.sroa.5.0.insert.shift.i = shl nuw i64 %out_sso.i197.sroa.6.sroa.5.0.insert.ext.i, 24
  %out_sso.i197.sroa.6.sroa.0.0.insert.insert.i = or disjoint i64 %out_sso.i197.sroa.6.sroa.5.0.insert.shift.i, 3827058
  %out_sso.i197.sroa.0.sroa.0.0.insert.insert.pn782.i = or disjoint i64 %tot.i203.i, 7022643932689334272
  %rs0.i236.pn783.i = insertvalue %ArchxStr poison, i64 %out_sso.i197.sroa.0.sroa.0.0.insert.insert.pn782.i, 0
  %common.ret.op.i227784.i = insertvalue %ArchxStr %rs0.i236.pn783.i, i64 %out_sso.i197.sroa.6.sroa.0.0.insert.insert.i, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i196.i)
  br label %archx_fn_describe_shape.exit

alloc_heap.i214.i:                                ; preds = %build.i211.i, %build.i211.thread.i
  %bptr.i212779.i = phi ptr [ %blptr.i210.i, %build.i211.thread.i ], [ %btmp.i196.i, %build.i211.i ]
  %hp.i215.i = call noalias align 16 ptr @malloc(i64 %tot.i203.i)
  %hnull.i216.i = icmp eq ptr %hp.i215.i, null
  br i1 %hnull.i216.i, label %oom.i228.i, label %archx_str_concat.exit244.i

archx_str_concat.exit244.i:                       ; preds = %alloc_heap.i214.i
  %hp_i.i218.i = ptrtoint ptr %hp.i215.i to i64
  %htagged.i219.i = or disjoint i64 %hp_i.i218.i, 1
  store i32 1635086707, ptr %hp.i215.i, align 16
  %atmp.i195.sroa.5.0.hp.i215.sroa_idx.i = getelementptr inbounds nuw i8, ptr %hp.i215.i, i64 4
  store i24 3827058, ptr %atmp.i195.sroa.5.0.hp.i215.sroa_idx.i, align 4
  %dst_b.i220.i = getelementptr inbounds nuw i8, ptr %hp.i215.i, i64 7
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i220.i, ptr nonnull align 1 %bptr.i212779.i, i64 %blen.i200.i, i1 false)
  %out_sso.i197.sroa.0.sroa.0.0.insert.insert.pn.i = or disjoint i64 %tot.i203.i, 7022643932689334272
  %rs0.i236.pn.i = insertvalue %ArchxStr poison, i64 %out_sso.i197.sroa.0.sroa.0.0.insert.insert.pn.i, 0
  %common.ret.op.i227.i = insertvalue %ArchxStr %rs0.i236.pn.i, i64 %htagged.i219.i, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i196.i)
  %tag.i76.i = and i64 %newret2254, 1
  %owned.not.i77.i = icmp eq i64 %tag.i76.i, 0
  %or.cond743.i = select i1 %bshort.i207.i, i1 true, i1 %owned.not.i77.i
  br i1 %or.cond743.i, label %archx_fn_describe_shape.exit, label %do_free.i78.i

do_free.i78.i:                                    ; preds = %archx_str_concat.exit244.i
  %raw.i79.i = and i64 %newret2254, -2
  %ptr.i80.i = inttoptr i64 %raw.i79.i to ptr
  call void @free(ptr %ptr.i80.i)
  br label %archx_fn_describe_shape.exit

pat.enum.ok.12.i:                                 ; preds = %pat.enum.ok.8.i
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i246.i)
  br i1 %bz.i201.i, label %archx_str_concat.exit294.thread.i, label %calc_tot.i252.i

archx_str_concat.exit294.thread.i:                ; preds = %pat.enum.ok.12.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i246.i)
  br label %archx_fn_describe_shape.exit

calc_tot.i252.i:                                  ; preds = %pat.enum.ok.12.i
  %tot.i253.i = add nuw nsw i64 %blen.i200.i, 5
  %too_big.i254.i = icmp samesign ugt i64 %blen.i200.i, 2147483642
  br i1 %too_big.i254.i, label %oom.i278.i, label %mat_a.i255.i

oom.i278.i:                                       ; preds = %alloc_heap.i264.i, %calc_tot.i252.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i255.i:                                     ; preds = %calc_tot.i252.i
  %bshort.i257.i = icmp samesign ult i64 %blen.i200.i, 13
  br i1 %bshort.i257.i, label %build.i261.i, label %build.i261.thread.i

build.i261.thread.i:                              ; preds = %mat_a.i255.i
  %braw.i259.i = and i64 %newret2254, -4
  %blptr.i260.i = inttoptr i64 %braw.i259.i to ptr
  br label %alloc_heap.i264.i

build.i261.i:                                     ; preds = %mat_a.i255.i
  %bp4.i289.i = lshr i64 %newret2252, 32
  %bp4_32.i290.i = trunc nuw i64 %bp4.i289.i to i32
  store i32 %bp4_32.i290.i, ptr %btmp.i246.i, align 4
  store i64 %newret2254, ptr %btmp4.i291.i, align 4
  %fits_sso.i263.i = icmp samesign ult i64 %blen.i200.i, 8
  br i1 %fits_sso.i263.i, label %archx_str_concat.exit294.thread791.i, label %alloc_heap.i264.i

archx_str_concat.exit294.thread791.i:             ; preds = %build.i261.i
  store i56 0, ptr %out_sso.i247.sroa.6.sroa.5.sroa.0.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i247.sroa.6.sroa.5.sroa.0.i, ptr nonnull align 4 %btmp.i246.i, i64 %blen.i200.i, i1 false)
  %out_sso.i247.sroa.6.sroa.5.sroa.0.i.0.out_sso.i247.sroa.6.sroa.5.sroa.0.i.0.out_sso.i247.sroa.6.sroa.5.sroa.0.i.0.out_sso.i247.sroa.6.sroa.5.sroa.0.0.out_sso.i247.sroa.6.sroa.5.sroa.0.0.out_sso.i247.sroa.6.sroa.5.sroa.0.0.out_sso.i247.sroa.6.sroa.5.0.out_sso.i247.sroa.6.8.rw1.i285.i = load i56, ptr %out_sso.i247.sroa.6.sroa.5.sroa.0.i, align 8
  %out_sso.i247.sroa.6.sroa.5.0.insert.ext.i = zext i56 %out_sso.i247.sroa.6.sroa.5.sroa.0.i.0.out_sso.i247.sroa.6.sroa.5.sroa.0.i.0.out_sso.i247.sroa.6.sroa.5.sroa.0.i.0.out_sso.i247.sroa.6.sroa.5.sroa.0.0.out_sso.i247.sroa.6.sroa.5.sroa.0.0.out_sso.i247.sroa.6.sroa.5.sroa.0.0.out_sso.i247.sroa.6.sroa.5.0.out_sso.i247.sroa.6.8.rw1.i285.i to i64
  %out_sso.i247.sroa.6.sroa.5.0.insert.shift.i = shl nuw i64 %out_sso.i247.sroa.6.sroa.5.0.insert.ext.i, 8
  %out_sso.i247.sroa.6.sroa.0.0.insert.insert.i = or disjoint i64 %out_sso.i247.sroa.6.sroa.5.0.insert.shift.i, 58
  %out_sso.i247.sroa.0.sroa.0.0.insert.insert.pn793.i = or disjoint i64 %tot.i253.i, 8386658471394672640
  %rs0.i286.pn794.i = insertvalue %ArchxStr poison, i64 %out_sso.i247.sroa.0.sroa.0.0.insert.insert.pn793.i, 0
  %common.ret.op.i277795.i = insertvalue %ArchxStr %rs0.i286.pn794.i, i64 %out_sso.i247.sroa.6.sroa.0.0.insert.insert.i, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i246.i)
  br label %archx_fn_describe_shape.exit

alloc_heap.i264.i:                                ; preds = %build.i261.i, %build.i261.thread.i
  %bptr.i262790.i = phi ptr [ %blptr.i260.i, %build.i261.thread.i ], [ %btmp.i246.i, %build.i261.i ]
  %hp.i265.i = call noalias align 16 ptr @malloc(i64 %tot.i253.i)
  %hnull.i266.i = icmp eq ptr %hp.i265.i, null
  br i1 %hnull.i266.i, label %oom.i278.i, label %archx_str_concat.exit294.i

archx_str_concat.exit294.i:                       ; preds = %alloc_heap.i264.i
  %hp_i.i268.i = ptrtoint ptr %hp.i265.i to i64
  %htagged.i269.i = or disjoint i64 %hp_i.i268.i, 1
  store i32 1952671090, ptr %hp.i265.i, align 16
  %atmp.i245.sroa.5.0.hp.i265.sroa_idx.i = getelementptr inbounds nuw i8, ptr %hp.i265.i, i64 4
  store i8 58, ptr %atmp.i245.sroa.5.0.hp.i265.sroa_idx.i, align 4
  %dst_b.i270.i = getelementptr inbounds nuw i8, ptr %hp.i265.i, i64 5
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i270.i, ptr nonnull align 1 %bptr.i262790.i, i64 %blen.i200.i, i1 false)
  %out_sso.i247.sroa.0.sroa.0.0.insert.insert.pn.i = or disjoint i64 %tot.i253.i, 8386658471394672640
  %rs0.i286.pn.i = insertvalue %ArchxStr poison, i64 %out_sso.i247.sroa.0.sroa.0.0.insert.insert.pn.i, 0
  %common.ret.op.i277.i = insertvalue %ArchxStr %rs0.i286.pn.i, i64 %htagged.i269.i, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i246.i)
  %tag.i87.i = and i64 %newret2254, 1
  %owned.not.i88.i = icmp eq i64 %tag.i87.i, 0
  %or.cond744.i = select i1 %bshort.i257.i, i1 true, i1 %owned.not.i88.i
  br i1 %or.cond744.i, label %archx_fn_describe_shape.exit, label %do_free.i89.i

do_free.i89.i:                                    ; preds = %archx_str_concat.exit294.i
  %raw.i90.i = and i64 %newret2254, -2
  %ptr.i91.i = inttoptr i64 %raw.i90.i to ptr
  call void @free(ptr %ptr.i91.i)
  br label %archx_fn_describe_shape.exit

dup_heap.i.i1903:                                 ; preds = %archx_enum_clone_Shape.exit.thread.i
  %dst.i.i1904 = call noalias align 16 ptr @malloc(i64 %len.i569.i.pre-phi)
  %isnull.i.i1905 = icmp eq ptr %dst.i.i1904, null
  br i1 %isnull.i.i1905, label %oom.i576.i, label %copy.i.i1906

oom.i576.i:                                       ; preds = %dup_heap.i.i1903
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i1906:                                     ; preds = %dup_heap.i.i1903
  %src_i.i.i1907 = and i64 %t3.fca.1.extract.i.i.pre-phi, -4
  %src.i.i1908 = inttoptr i64 %src_i.i.i1907 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i1904, ptr nonnull align 4 %src.i.i1908, i64 %len.i569.i.pre-phi, i1 false)
  %dst_i.i.i1909 = ptrtoint ptr %dst.i.i1904 to i64
  %tagged.i.i1910 = or disjoint i64 %dst_i.i.i1909, 1
  %.pre2200 = extractvalue %ArchxStr %common.ret.op.i.i.i, 0
  %.pre2202 = and i64 %.pre2200, 4294967295
  br label %archx_str_clone.exit.i1912

archx_str_clone.exit.i1912:                       ; preds = %copy.i.i1906, %archx_enum_clone_Shape.exit.thread.i
  %alen.i.i.pre-phi = phi i64 [ %.pre2202, %copy.i.i1906 ], [ %len.i569.i.pre-phi, %archx_enum_clone_Shape.exit.thread.i ]
  %aw1.i.i.pre-phi = phi i64 [ %tagged.i.i1910, %copy.i.i1906 ], [ %t3.fca.1.extract.i.i.pre-phi, %archx_enum_clone_Shape.exit.thread.i ]
  %aw0.i.i.pre-phi = phi i64 [ %.pre2200, %copy.i.i1906 ], [ %t3.fca.0.extract.i.i.pre-phi, %archx_enum_clone_Shape.exit.thread.i ]
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i295.i)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i297.i)
  %az.i.i = icmp eq i64 %alen.i.i.pre-phi, 0
  br i1 %az.i.i, label %archx_str_concat.exit332.i, label %chk_bz.i.i

chk_bz.i.i:                                       ; preds = %archx_str_clone.exit.i1912
  %tot.i299.i = add nuw nsw i64 %alen.i.i.pre-phi, 1
  %too_big.i300.i = icmp samesign ugt i64 %alen.i.i.pre-phi, 2147483646
  br i1 %too_big.i300.i, label %oom.i321.i, label %mat_a.i301.i

oom.i321.i:                                       ; preds = %alloc_heap.i307.i, %chk_bz.i.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i301.i:                                     ; preds = %chk_bz.i.i
  %ashort.i.i = icmp samesign ult i64 %alen.i.i.pre-phi, 13
  br i1 %ashort.i.i, label %mat_b.i.i, label %mat_b.i.thread.i

mat_b.i.thread.i:                                 ; preds = %mat_a.i301.i
  %araw.i.i = and i64 %aw1.i.i.pre-phi, -4
  %alptr.i.i = inttoptr i64 %araw.i.i to ptr
  br label %alloc_heap.i307.i

mat_b.i.i:                                        ; preds = %mat_a.i301.i
  %ap4.i.i = lshr i64 %aw0.i.i.pre-phi, 32
  %ap4_32.i.i = trunc nuw i64 %ap4.i.i to i32
  store i32 %ap4_32.i.i, ptr %atmp.i295.i, align 4
  store i64 %aw1.i.i.pre-phi, ptr %atmp4.i331.i, align 4
  %fits_sso.i306.not.i = icmp eq i64 %alen.i.i.pre-phi, 12
  br i1 %fits_sso.i306.not.i, label %alloc_heap.i307.i, label %build_sso.i322.i

build_sso.i322.i:                                 ; preds = %mat_b.i.i
  %tot32.i324.i = trunc nuw nsw i64 %tot.i299.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i297.i, i8 0, i64 16, i1 false)
  store i32 %tot32.i324.i, ptr %out_sso.i297.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i325.i, ptr nonnull align 4 %atmp.i295.i, i64 %alen.i.i.pre-phi, i1 false)
  %sso_dst_b.i326.i = getelementptr inbounds nuw i8, ptr %sso_dst_a.i325.i, i64 %alen.i.i.pre-phi
  store i8 64, ptr %sso_dst_b.i326.i, align 1
  %rw0.i327.i = load i64, ptr %out_sso.i297.i, align 8
  %rw1.i328.i = load i64, ptr %out_sso8.i323.i, align 8
  %rs0.i329.i = insertvalue %ArchxStr poison, i64 %rw0.i327.i, 0
  %rs1.i330.i = insertvalue %ArchxStr %rs0.i329.i, i64 %rw1.i328.i, 1
  br label %archx_str_concat.exit332.i

alloc_heap.i307.i:                                ; preds = %mat_b.i.i, %mat_b.i.thread.i
  %aptr.i729.i = phi ptr [ %alptr.i.i, %mat_b.i.thread.i ], [ %atmp.i295.i, %mat_b.i.i ]
  %hp.i308.i = call noalias align 16 ptr @malloc(i64 %tot.i299.i)
  %hnull.i309.i = icmp eq ptr %hp.i308.i, null
  br i1 %hnull.i309.i, label %oom.i321.i, label %copy_long.i310.i

copy_long.i310.i:                                 ; preds = %alloc_heap.i307.i
  %hp_i.i311.i = ptrtoint ptr %hp.i308.i to i64
  %htagged.i312.i = or disjoint i64 %hp_i.i311.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i308.i, ptr nonnull align 1 %aptr.i729.i, i64 %alen.i.i.pre-phi, i1 false)
  %dst_b.i313.i = getelementptr inbounds nuw i8, ptr %hp.i308.i, i64 %alen.i.i.pre-phi
  store i8 64, ptr %dst_b.i313.i, align 1
  %pref32.i314.i = load i32, ptr %hp.i308.i, align 16
  %pref64.i315.i = zext i32 %pref32.i314.i to i64
  %pref_sh.i316.i = shl nuw i64 %pref64.i315.i, 32
  %w0_out.i317.i = or disjoint i64 %pref_sh.i316.i, %tot.i299.i
  %ls0.i318.i = insertvalue %ArchxStr poison, i64 %w0_out.i317.i, 0
  %ls1.i319.i = insertvalue %ArchxStr %ls0.i318.i, i64 %htagged.i312.i, 1
  br label %archx_str_concat.exit332.i

archx_str_concat.exit332.i:                       ; preds = %copy_long.i310.i, %build_sso.i322.i, %archx_str_clone.exit.i1912
  %common.ret.op.i320.i = phi %ArchxStr [ %rs1.i330.i, %build_sso.i322.i ], [ %ls1.i319.i, %copy_long.i310.i ], [ { i64 274877906945, i64 0 }, %archx_str_clone.exit.i1912 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i295.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i297.i)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i.i)
  %n32.i.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t129.unpack58.unpack63)
  %len.i578.i = sext i32 %n32.i.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i.i)
  %z.i.i.i = icmp slt i32 %n32.i.i, 1
  br i1 %z.i.i.i, label %archx_str_from_int.exit.i, label %chk_sso.i.i.i

oom.i.i580.i:                                     ; preds = %alloc_heap.i.i.i
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i.i:                                    ; preds = %archx_str_concat.exit332.i
  %short.i.i.i = icmp samesign ult i32 %n32.i.i, 13
  br i1 %short.i.i.i, label %pack_sso.i.i.i, label %alloc_heap.i.i.i

pack_sso.i.i.i:                                   ; preds = %chk_sso.i.i.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i.i, i8 0, i64 16, i1 false)
  store i32 %n32.i.i, ptr %sso.i.i.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i.i, i64 range(i64 -2147483648, 2147483650) %len.i578.i, i1 false)
  %sso.i.i.i.0.sso.i.i.i.0.sso.i.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i.i = load i64, ptr %sso.i.i.i, align 8
  %sso.i.i.i.8.sso.i.i.i.8.sso.i.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i.i = load i64, ptr %sso.i.i.i.8.sroa_idx, align 8
  %ss0.i.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.i.0.sso.i.i.i.0.sso.i.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i.i, 0
  %ss1.i.i.i = insertvalue %ArchxStr %ss0.i.i.i, i64 %sso.i.i.i.8.sso.i.i.i.8.sso.i.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i.i, 1
  br label %archx_str_from_int.exit.i

alloc_heap.i.i.i:                                 ; preds = %chk_sso.i.i.i
  %hp.i.i.i = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i578.i)
  %hnull.i.i.i = icmp eq ptr %hp.i.i.i, null
  br i1 %hnull.i.i.i, label %oom.i.i580.i, label %copy_long.i.i.i

copy_long.i.i.i:                                  ; preds = %alloc_heap.i.i.i
  %hp_i.i.i.i = ptrtoint ptr %hp.i.i.i to i64
  %htagged.i.i.i = or disjoint i64 %hp_i.i.i.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i.i, ptr nonnull readonly align 8 %buf.i.i, i64 range(i64 -2147483648, 2147483650) %len.i578.i, i1 false)
  %pref32.i.i.i = load i32, ptr %hp.i.i.i, align 16
  %pref64.i.i.i = zext i32 %pref32.i.i.i to i64
  %pref_sh.i.i.i = shl nuw i64 %pref64.i.i.i, 32
  %w0_out.i.i.i = or disjoint i64 %pref_sh.i.i.i, %len.i578.i
  %ls0.i.i.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i.i, 0
  %ls1.i.i.i = insertvalue %ArchxStr %ls0.i.i.i, i64 %htagged.i.i.i, 1
  br label %archx_str_from_int.exit.i

archx_str_from_int.exit.i:                        ; preds = %copy_long.i.i.i, %pack_sso.i.i.i, %archx_str_concat.exit332.i
  %common.ret.op.i.i579.i = phi %ArchxStr [ %ss1.i.i.i, %pack_sso.i.i.i ], [ %ls1.i.i.i, %copy_long.i.i.i ], [ zeroinitializer, %archx_str_concat.exit332.i ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i333.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i334.i)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i335.i)
  %aw0.i336.i = extractvalue %ArchxStr %common.ret.op.i320.i, 0
  %aw1.i337.i = extractvalue %ArchxStr %common.ret.op.i320.i, 1
  %bw0.i338.i = extractvalue %ArchxStr %common.ret.op.i.i579.i, 0
  %bw1.i339.i = extractvalue %ArchxStr %common.ret.op.i.i579.i, 1
  %alen.i340.i = and i64 %aw0.i336.i, 4294967295
  %blen.i341.i = and i64 %bw0.i338.i, 4294967295
  %az.i342.i = icmp eq i64 %alen.i340.i, 0
  br i1 %az.i342.i, label %ret_b_clone.i396.i, label %chk_bz.i343.i

ret_b_clone.i396.i:                               ; preds = %archx_str_from_int.exit.i
  %long.i583.i = icmp samesign ult i64 %blen.i341.i, 13
  %tag.i587.i = and i64 %bw1.i339.i, 3
  %owned.not.i588.i = icmp eq i64 %tag.i587.i, 0
  %or.cond746.i = select i1 %long.i583.i, i1 true, i1 %owned.not.i588.i
  br i1 %or.cond746.i, label %archx_str_concat.exit398.i, label %dup_heap.i589.i

dup_heap.i589.i:                                  ; preds = %ret_b_clone.i396.i
  %dst.i590.i = call noalias align 16 ptr @malloc(i64 %blen.i341.i)
  %isnull.i591.i = icmp eq ptr %dst.i590.i, null
  br i1 %isnull.i591.i, label %oom.i598.i, label %copy.i592.i

oom.i598.i:                                       ; preds = %dup_heap.i589.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i592.i:                                      ; preds = %dup_heap.i589.i
  %src_i.i593.i = and i64 %bw1.i339.i, -4
  %src.i594.i = inttoptr i64 %src_i.i593.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i590.i, ptr nonnull align 4 %src.i594.i, i64 %blen.i341.i, i1 false)
  %dst_i.i595.i = ptrtoint ptr %dst.i590.i to i64
  %tagged.i596.i = or disjoint i64 %dst_i.i595.i, 1
  %out.i597.i = insertvalue %ArchxStr %common.ret.op.i.i579.i, i64 %tagged.i596.i, 1
  br label %archx_str_concat.exit398.i

chk_bz.i343.i:                                    ; preds = %archx_str_from_int.exit.i
  %bz.i344.i = icmp eq i64 %blen.i341.i, 0
  br i1 %bz.i344.i, label %ret_a_clone.i394.i, label %calc_tot.i345.i

ret_a_clone.i394.i:                               ; preds = %chk_bz.i343.i
  %long.i602.i = icmp samesign ult i64 %alen.i340.i, 13
  %tag.i606.i = and i64 %aw1.i337.i, 3
  %owned.not.i607.i = icmp eq i64 %tag.i606.i, 0
  %or.cond747.i = select i1 %long.i602.i, i1 true, i1 %owned.not.i607.i
  br i1 %or.cond747.i, label %archx_str_concat.exit398.i, label %dup_heap.i608.i

dup_heap.i608.i:                                  ; preds = %ret_a_clone.i394.i
  %dst.i609.i = call noalias align 16 ptr @malloc(i64 %alen.i340.i)
  %isnull.i610.i = icmp eq ptr %dst.i609.i, null
  br i1 %isnull.i610.i, label %oom.i617.i, label %copy.i611.i

oom.i617.i:                                       ; preds = %dup_heap.i608.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i611.i:                                      ; preds = %dup_heap.i608.i
  %src_i.i612.i = and i64 %aw1.i337.i, -4
  %src.i613.i = inttoptr i64 %src_i.i612.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i609.i, ptr nonnull align 4 %src.i613.i, i64 %alen.i340.i, i1 false)
  %dst_i.i614.i = ptrtoint ptr %dst.i609.i to i64
  %tagged.i615.i = or disjoint i64 %dst_i.i614.i, 1
  %out.i616.i = insertvalue %ArchxStr %common.ret.op.i320.i, i64 %tagged.i615.i, 1
  br label %archx_str_concat.exit398.i

calc_tot.i345.i:                                  ; preds = %chk_bz.i343.i
  %tot.i346.i = add nuw nsw i64 %blen.i341.i, %alen.i340.i
  %too_big.i347.i = icmp samesign ugt i64 %tot.i346.i, 2147483647
  br i1 %too_big.i347.i, label %oom.i376.i, label %mat_a.i348.i

oom.i376.i:                                       ; preds = %alloc_heap.i362.i, %calc_tot.i345.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i348.i:                                     ; preds = %calc_tot.i345.i
  %ashort.i349.i = icmp samesign ult i64 %alen.i340.i, 13
  br i1 %ashort.i349.i, label %mat_a_short.i390.i, label %mat_a_long.i350.i

mat_a_short.i390.i:                               ; preds = %mat_a.i348.i
  %ap4.i391.i = lshr i64 %aw0.i336.i, 32
  %ap4_32.i392.i = trunc nuw i64 %ap4.i391.i to i32
  store i32 %ap4_32.i392.i, ptr %atmp.i333.i, align 4
  store i64 %aw1.i337.i, ptr %atmp4.i393.i, align 4
  br label %mat_b.i353.i

mat_a_long.i350.i:                                ; preds = %mat_a.i348.i
  %araw.i351.i = and i64 %aw1.i337.i, -4
  %alptr.i352.i = inttoptr i64 %araw.i351.i to ptr
  br label %mat_b.i353.i

mat_b.i353.i:                                     ; preds = %mat_a_long.i350.i, %mat_a_short.i390.i
  %aptr.i354.i = phi ptr [ %atmp.i333.i, %mat_a_short.i390.i ], [ %alptr.i352.i, %mat_a_long.i350.i ]
  %bshort.i355.i = icmp samesign ult i64 %blen.i341.i, 13
  br i1 %bshort.i355.i, label %mat_b_short.i386.i, label %mat_b_long.i356.i

mat_b_short.i386.i:                               ; preds = %mat_b.i353.i
  %bp4.i387.i = lshr i64 %bw0.i338.i, 32
  %bp4_32.i388.i = trunc nuw i64 %bp4.i387.i to i32
  store i32 %bp4_32.i388.i, ptr %btmp.i334.i, align 4
  store i64 %bw1.i339.i, ptr %btmp4.i389.i, align 4
  br label %build.i359.i

mat_b_long.i356.i:                                ; preds = %mat_b.i353.i
  %braw.i357.i = and i64 %bw1.i339.i, -4
  %blptr.i358.i = inttoptr i64 %braw.i357.i to ptr
  br label %build.i359.i

build.i359.i:                                     ; preds = %mat_b_long.i356.i, %mat_b_short.i386.i
  %bptr.i360.i = phi ptr [ %btmp.i334.i, %mat_b_short.i386.i ], [ %blptr.i358.i, %mat_b_long.i356.i ]
  %fits_sso.i361.i = icmp samesign ult i64 %tot.i346.i, 13
  br i1 %fits_sso.i361.i, label %build_sso.i377.i, label %alloc_heap.i362.i

build_sso.i377.i:                                 ; preds = %build.i359.i
  %tot32.i379.i = trunc nuw nsw i64 %tot.i346.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i335.i, i8 0, i64 16, i1 false)
  store i32 %tot32.i379.i, ptr %out_sso.i335.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i380.i, ptr nonnull align 1 %aptr.i354.i, i64 %alen.i340.i, i1 false)
  %sso_dst_b.i381.i = getelementptr inbounds nuw i8, ptr %sso_dst_a.i380.i, i64 %alen.i340.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i381.i, ptr nonnull align 1 %bptr.i360.i, i64 %blen.i341.i, i1 false)
  %rw0.i382.i = load i64, ptr %out_sso.i335.i, align 8
  %rw1.i383.i = load i64, ptr %out_sso8.i378.i, align 8
  %rs0.i384.i = insertvalue %ArchxStr poison, i64 %rw0.i382.i, 0
  %rs1.i385.i = insertvalue %ArchxStr %rs0.i384.i, i64 %rw1.i383.i, 1
  br label %archx_str_concat.exit398.i

alloc_heap.i362.i:                                ; preds = %build.i359.i
  %hp.i363.i = call noalias align 16 ptr @malloc(i64 %tot.i346.i)
  %hnull.i364.i = icmp eq ptr %hp.i363.i, null
  br i1 %hnull.i364.i, label %oom.i376.i, label %copy_long.i365.i

copy_long.i365.i:                                 ; preds = %alloc_heap.i362.i
  %hp_i.i366.i = ptrtoint ptr %hp.i363.i to i64
  %htagged.i367.i = or disjoint i64 %hp_i.i366.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i363.i, ptr nonnull align 1 %aptr.i354.i, i64 %alen.i340.i, i1 false)
  %dst_b.i368.i = getelementptr inbounds nuw i8, ptr %hp.i363.i, i64 %alen.i340.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i368.i, ptr nonnull align 1 %bptr.i360.i, i64 %blen.i341.i, i1 false)
  %pref32.i369.i = load i32, ptr %hp.i363.i, align 16
  %pref64.i370.i = zext i32 %pref32.i369.i to i64
  %pref_sh.i371.i = shl nuw i64 %pref64.i370.i, 32
  %w0_out.i372.i = or disjoint i64 %pref_sh.i371.i, %tot.i346.i
  %ls0.i373.i = insertvalue %ArchxStr poison, i64 %w0_out.i372.i, 0
  %ls1.i374.i = insertvalue %ArchxStr %ls0.i373.i, i64 %htagged.i367.i, 1
  br label %archx_str_concat.exit398.i

archx_str_concat.exit398.i:                       ; preds = %copy_long.i365.i, %build_sso.i377.i, %copy.i611.i, %ret_a_clone.i394.i, %copy.i592.i, %ret_b_clone.i396.i
  %common.ret.op.i375.i = phi %ArchxStr [ %rs1.i385.i, %build_sso.i377.i ], [ %ls1.i374.i, %copy_long.i365.i ], [ %out.i597.i, %copy.i592.i ], [ %common.ret.op.i.i579.i, %ret_b_clone.i396.i ], [ %out.i616.i, %copy.i611.i ], [ %common.ret.op.i320.i, %ret_a_clone.i394.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i333.i)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i334.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i335.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i399.i)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i401.i)
  %aw0.i402.i = extractvalue %ArchxStr %common.ret.op.i375.i, 0
  %aw1.i403.i = extractvalue %ArchxStr %common.ret.op.i375.i, 1
  %alen.i404.i = and i64 %aw0.i402.i, 4294967295
  %az.i405.i = icmp eq i64 %alen.i404.i, 0
  br i1 %az.i405.i, label %archx_str_concat.exit452.i, label %chk_bz.i406.i

chk_bz.i406.i:                                    ; preds = %archx_str_concat.exit398.i
  %tot.i408.i = add nuw nsw i64 %alen.i404.i, 1
  %too_big.i409.i = icmp samesign ugt i64 %alen.i404.i, 2147483646
  br i1 %too_big.i409.i, label %oom.i436.i, label %mat_a.i410.i

oom.i436.i:                                       ; preds = %alloc_heap.i422.i, %chk_bz.i406.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i410.i:                                     ; preds = %chk_bz.i406.i
  %ashort.i411.i = icmp samesign ult i64 %alen.i404.i, 13
  br i1 %ashort.i411.i, label %mat_b.i415.i, label %mat_b.i415.thread.i

mat_b.i415.thread.i:                              ; preds = %mat_a.i410.i
  %araw.i413.i = and i64 %aw1.i403.i, -4
  %alptr.i414.i = inttoptr i64 %araw.i413.i to ptr
  br label %alloc_heap.i422.i

mat_b.i415.i:                                     ; preds = %mat_a.i410.i
  %ap4.i447.i = lshr i64 %aw0.i402.i, 32
  %ap4_32.i448.i = trunc nuw i64 %ap4.i447.i to i32
  store i32 %ap4_32.i448.i, ptr %atmp.i399.i, align 4
  store i64 %aw1.i403.i, ptr %atmp4.i449.i, align 4
  %fits_sso.i421.not.i = icmp eq i64 %alen.i404.i, 12
  br i1 %fits_sso.i421.not.i, label %alloc_heap.i422.i, label %build_sso.i437.i

build_sso.i437.i:                                 ; preds = %mat_b.i415.i
  %tot32.i439.i = trunc nuw nsw i64 %tot.i408.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i401.i, i8 0, i64 16, i1 false)
  store i32 %tot32.i439.i, ptr %out_sso.i401.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i440.i, ptr nonnull align 4 %atmp.i399.i, i64 %alen.i404.i, i1 false)
  %sso_dst_b.i441.i = getelementptr inbounds nuw i8, ptr %sso_dst_a.i440.i, i64 %alen.i404.i
  store i8 44, ptr %sso_dst_b.i441.i, align 1
  %rw0.i442.i = load i64, ptr %out_sso.i401.i, align 8
  %rw1.i443.i = load i64, ptr %out_sso8.i438.i, align 8
  %rs0.i444.i = insertvalue %ArchxStr poison, i64 %rw0.i442.i, 0
  %rs1.i445.i = insertvalue %ArchxStr %rs0.i444.i, i64 %rw1.i443.i, 1
  br label %archx_str_concat.exit452.i

alloc_heap.i422.i:                                ; preds = %mat_b.i415.i, %mat_b.i415.thread.i
  %aptr.i416732.i = phi ptr [ %alptr.i414.i, %mat_b.i415.thread.i ], [ %atmp.i399.i, %mat_b.i415.i ]
  %hp.i423.i = call noalias align 16 ptr @malloc(i64 %tot.i408.i)
  %hnull.i424.i = icmp eq ptr %hp.i423.i, null
  br i1 %hnull.i424.i, label %oom.i436.i, label %copy_long.i425.i

copy_long.i425.i:                                 ; preds = %alloc_heap.i422.i
  %hp_i.i426.i = ptrtoint ptr %hp.i423.i to i64
  %htagged.i427.i = or disjoint i64 %hp_i.i426.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i423.i, ptr nonnull align 1 %aptr.i416732.i, i64 %alen.i404.i, i1 false)
  %dst_b.i428.i = getelementptr inbounds nuw i8, ptr %hp.i423.i, i64 %alen.i404.i
  store i8 44, ptr %dst_b.i428.i, align 1
  %pref32.i429.i = load i32, ptr %hp.i423.i, align 16
  %pref64.i430.i = zext i32 %pref32.i429.i to i64
  %pref_sh.i431.i = shl nuw i64 %pref64.i430.i, 32
  %w0_out.i432.i = or disjoint i64 %pref_sh.i431.i, %tot.i408.i
  %ls0.i433.i = insertvalue %ArchxStr poison, i64 %w0_out.i432.i, 0
  %ls1.i434.i = insertvalue %ArchxStr %ls0.i433.i, i64 %htagged.i427.i, 1
  br label %archx_str_concat.exit452.i

archx_str_concat.exit452.i:                       ; preds = %copy_long.i425.i, %build_sso.i437.i, %archx_str_concat.exit398.i
  %common.ret.op.i435.i = phi %ArchxStr [ %rs1.i445.i, %build_sso.i437.i ], [ %ls1.i434.i, %copy_long.i425.i ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit398.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i399.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i401.i)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i621.i)
  %n32.i622.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i621.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t129.unpack58.unpack65)
  %len.i623.i = sext i32 %n32.i622.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i620.i)
  %z.i.i624.i = icmp slt i32 %n32.i622.i, 1
  br i1 %z.i.i624.i, label %archx_str_from_int.exit648.i, label %chk_sso.i.i625.i

oom.i.i640.i:                                     ; preds = %alloc_heap.i.i627.i
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i625.i:                                 ; preds = %archx_str_concat.exit452.i
  %short.i.i626.i = icmp samesign ult i32 %n32.i622.i, 13
  br i1 %short.i.i626.i, label %pack_sso.i.i641.i, label %alloc_heap.i.i627.i

pack_sso.i.i641.i:                                ; preds = %chk_sso.i.i625.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i620.i, i8 0, i64 16, i1 false)
  store i32 %n32.i622.i, ptr %sso.i.i620.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i620.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i621.i, i64 range(i64 -2147483648, 2147483650) %len.i623.i, i1 false)
  %sso.i.i620.i.0.sso.i.i620.i.0.sso.i.i620.i.0.sso.i.i620.0.sso.i.i620.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i643.i = load i64, ptr %sso.i.i620.i, align 8
  %sso.i.i620.i.8.sso.i.i620.i.8.sso.i.i620.i.8.sso.i.i620.8.sso.i.i620.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i645.i = load i64, ptr %sso.i.i620.i.8.sroa_idx, align 8
  %ss0.i.i646.i = insertvalue %ArchxStr poison, i64 %sso.i.i620.i.0.sso.i.i620.i.0.sso.i.i620.i.0.sso.i.i620.0.sso.i.i620.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i643.i, 0
  %ss1.i.i647.i = insertvalue %ArchxStr %ss0.i.i646.i, i64 %sso.i.i620.i.8.sso.i.i620.i.8.sso.i.i620.i.8.sso.i.i620.8.sso.i.i620.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i645.i, 1
  br label %archx_str_from_int.exit648.i

alloc_heap.i.i627.i:                              ; preds = %chk_sso.i.i625.i
  %hp.i.i628.i = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i623.i)
  %hnull.i.i629.i = icmp eq ptr %hp.i.i628.i, null
  br i1 %hnull.i.i629.i, label %oom.i.i640.i, label %copy_long.i.i630.i

copy_long.i.i630.i:                               ; preds = %alloc_heap.i.i627.i
  %hp_i.i.i631.i = ptrtoint ptr %hp.i.i628.i to i64
  %htagged.i.i632.i = or disjoint i64 %hp_i.i.i631.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i628.i, ptr nonnull readonly align 8 %buf.i621.i, i64 range(i64 -2147483648, 2147483650) %len.i623.i, i1 false)
  %pref32.i.i633.i = load i32, ptr %hp.i.i628.i, align 16
  %pref64.i.i634.i = zext i32 %pref32.i.i633.i to i64
  %pref_sh.i.i635.i = shl nuw i64 %pref64.i.i634.i, 32
  %w0_out.i.i636.i = or disjoint i64 %pref_sh.i.i635.i, %len.i623.i
  %ls0.i.i637.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i636.i, 0
  %ls1.i.i638.i = insertvalue %ArchxStr %ls0.i.i637.i, i64 %htagged.i.i632.i, 1
  br label %archx_str_from_int.exit648.i

archx_str_from_int.exit648.i:                     ; preds = %copy_long.i.i630.i, %pack_sso.i.i641.i, %archx_str_concat.exit452.i
  %common.ret.op.i.i639.i = phi %ArchxStr [ %ss1.i.i647.i, %pack_sso.i.i641.i ], [ %ls1.i.i638.i, %copy_long.i.i630.i ], [ zeroinitializer, %archx_str_concat.exit452.i ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i620.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i621.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i453.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i454.i)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i455.i)
  %aw0.i456.i = extractvalue %ArchxStr %common.ret.op.i435.i, 0
  %aw1.i457.i = extractvalue %ArchxStr %common.ret.op.i435.i, 1
  %bw0.i458.i = extractvalue %ArchxStr %common.ret.op.i.i639.i, 0
  %bw1.i459.i = extractvalue %ArchxStr %common.ret.op.i.i639.i, 1
  %alen.i460.i = and i64 %aw0.i456.i, 4294967295
  %blen.i461.i = and i64 %bw0.i458.i, 4294967295
  %az.i462.i = icmp eq i64 %alen.i460.i, 0
  br i1 %az.i462.i, label %ret_b_clone.i516.i, label %chk_bz.i463.i

ret_b_clone.i516.i:                               ; preds = %archx_str_from_int.exit648.i
  %long.i651.i = icmp samesign ugt i64 %blen.i461.i, 12
  br i1 %long.i651.i, label %chk_tag.i653.i, label %archx_str_concat.exit518.thread.i

chk_tag.i653.i:                                   ; preds = %ret_b_clone.i516.i
  %tag.i655.i = and i64 %bw1.i459.i, 3
  %owned.not.i656.i = icmp eq i64 %tag.i655.i, 0
  br i1 %owned.not.i656.i, label %archx_str_concat.exit518.thread738.i, label %dup_heap.i657.i

dup_heap.i657.i:                                  ; preds = %chk_tag.i653.i
  %dst.i658.i = call noalias align 16 ptr @malloc(i64 %blen.i461.i)
  %isnull.i659.i = icmp eq ptr %dst.i658.i, null
  br i1 %isnull.i659.i, label %oom.i666.i, label %copy.i660.i

oom.i666.i:                                       ; preds = %dup_heap.i657.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i660.i:                                      ; preds = %dup_heap.i657.i
  %src_i.i661.i = and i64 %bw1.i459.i, -4
  %src.i662.i = inttoptr i64 %src_i.i661.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i658.i, ptr nonnull align 4 %src.i662.i, i64 %blen.i461.i, i1 false)
  %dst_i.i663.i = ptrtoint ptr %dst.i658.i to i64
  %tagged.i664.i = or disjoint i64 %dst_i.i663.i, 1
  %out.i665.i = insertvalue %ArchxStr %common.ret.op.i.i639.i, i64 %tagged.i664.i, 1
  br label %archx_str_concat.exit518.thread738.i

chk_bz.i463.i:                                    ; preds = %archx_str_from_int.exit648.i
  %bz.i464.i = icmp eq i64 %blen.i461.i, 0
  br i1 %bz.i464.i, label %ret_a_clone.i514.i, label %calc_tot.i465.i

ret_a_clone.i514.i:                               ; preds = %chk_bz.i463.i
  %long.i670.i = icmp samesign ult i64 %alen.i460.i, 13
  %tag.i674.i = and i64 %aw1.i457.i, 3
  %owned.not.i675.i = icmp eq i64 %tag.i674.i, 0
  %or.cond748.i = select i1 %long.i670.i, i1 true, i1 %owned.not.i675.i
  br i1 %or.cond748.i, label %archx_str_concat.exit518.thread.i, label %dup_heap.i676.i

dup_heap.i676.i:                                  ; preds = %ret_a_clone.i514.i
  %dst.i677.i = call noalias align 16 ptr @malloc(i64 %alen.i460.i)
  %isnull.i678.i = icmp eq ptr %dst.i677.i, null
  br i1 %isnull.i678.i, label %oom.i685.i, label %copy.i679.i

oom.i685.i:                                       ; preds = %dup_heap.i676.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i679.i:                                      ; preds = %dup_heap.i676.i
  %src_i.i680.i = and i64 %aw1.i457.i, -4
  %src.i681.i = inttoptr i64 %src_i.i680.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i677.i, ptr nonnull align 4 %src.i681.i, i64 %alen.i460.i, i1 false)
  %dst_i.i682.i = ptrtoint ptr %dst.i677.i to i64
  %tagged.i683.i = or disjoint i64 %dst_i.i682.i, 1
  %out.i684.i = insertvalue %ArchxStr %common.ret.op.i435.i, i64 %tagged.i683.i, 1
  br label %archx_str_concat.exit518.thread.i

calc_tot.i465.i:                                  ; preds = %chk_bz.i463.i
  %tot.i466.i = add nuw nsw i64 %blen.i461.i, %alen.i460.i
  %too_big.i467.i = icmp samesign ugt i64 %tot.i466.i, 2147483647
  br i1 %too_big.i467.i, label %oom.i496.i, label %mat_a.i468.i

oom.i496.i:                                       ; preds = %alloc_heap.i482.i, %calc_tot.i465.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i468.i:                                     ; preds = %calc_tot.i465.i
  %ashort.i469.i = icmp samesign ult i64 %alen.i460.i, 13
  br i1 %ashort.i469.i, label %mat_a_short.i510.i, label %mat_a_long.i470.i

mat_a_short.i510.i:                               ; preds = %mat_a.i468.i
  %ap4.i511.i = lshr i64 %aw0.i456.i, 32
  %ap4_32.i512.i = trunc nuw i64 %ap4.i511.i to i32
  store i32 %ap4_32.i512.i, ptr %atmp.i453.i, align 4
  store i64 %aw1.i457.i, ptr %atmp4.i513.i, align 4
  br label %mat_b.i473.i

mat_a_long.i470.i:                                ; preds = %mat_a.i468.i
  %araw.i471.i = and i64 %aw1.i457.i, -4
  %alptr.i472.i = inttoptr i64 %araw.i471.i to ptr
  br label %mat_b.i473.i

mat_b.i473.i:                                     ; preds = %mat_a_long.i470.i, %mat_a_short.i510.i
  %aptr.i474.i = phi ptr [ %atmp.i453.i, %mat_a_short.i510.i ], [ %alptr.i472.i, %mat_a_long.i470.i ]
  %bshort.i475.i = icmp samesign ult i64 %blen.i461.i, 13
  br i1 %bshort.i475.i, label %mat_b_short.i506.i, label %mat_b_long.i476.i

mat_b_short.i506.i:                               ; preds = %mat_b.i473.i
  %bp4.i507.i = lshr i64 %bw0.i458.i, 32
  %bp4_32.i508.i = trunc nuw i64 %bp4.i507.i to i32
  store i32 %bp4_32.i508.i, ptr %btmp.i454.i, align 4
  store i64 %bw1.i459.i, ptr %btmp4.i509.i, align 4
  br label %build.i479.i

mat_b_long.i476.i:                                ; preds = %mat_b.i473.i
  %braw.i477.i = and i64 %bw1.i459.i, -4
  %blptr.i478.i = inttoptr i64 %braw.i477.i to ptr
  br label %build.i479.i

build.i479.i:                                     ; preds = %mat_b_long.i476.i, %mat_b_short.i506.i
  %bptr.i480.i = phi ptr [ %btmp.i454.i, %mat_b_short.i506.i ], [ %blptr.i478.i, %mat_b_long.i476.i ]
  %fits_sso.i481.i = icmp samesign ult i64 %tot.i466.i, 13
  br i1 %fits_sso.i481.i, label %build_sso.i497.i, label %alloc_heap.i482.i

build_sso.i497.i:                                 ; preds = %build.i479.i
  %tot32.i499.i = trunc nuw nsw i64 %tot.i466.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i455.i, i8 0, i64 16, i1 false)
  store i32 %tot32.i499.i, ptr %out_sso.i455.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i500.i, ptr nonnull align 1 %aptr.i474.i, i64 %alen.i460.i, i1 false)
  %sso_dst_b.i501.i = getelementptr inbounds nuw i8, ptr %sso_dst_a.i500.i, i64 %alen.i460.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i501.i, ptr nonnull align 1 %bptr.i480.i, i64 %blen.i461.i, i1 false)
  %rw0.i502.i = load i64, ptr %out_sso.i455.i, align 8
  %rw1.i503.i = load i64, ptr %out_sso8.i498.i, align 8
  br label %archx_str_concat.exit518.i

alloc_heap.i482.i:                                ; preds = %build.i479.i
  %hp.i483.i = call noalias align 16 ptr @malloc(i64 %tot.i466.i)
  %hnull.i484.i = icmp eq ptr %hp.i483.i, null
  br i1 %hnull.i484.i, label %oom.i496.i, label %copy_long.i485.i

copy_long.i485.i:                                 ; preds = %alloc_heap.i482.i
  %hp_i.i486.i = ptrtoint ptr %hp.i483.i to i64
  %htagged.i487.i = or disjoint i64 %hp_i.i486.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i483.i, ptr nonnull align 1 %aptr.i474.i, i64 %alen.i460.i, i1 false)
  %dst_b.i488.i = getelementptr inbounds nuw i8, ptr %hp.i483.i, i64 %alen.i460.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i488.i, ptr nonnull align 1 %bptr.i480.i, i64 %blen.i461.i, i1 false)
  %pref32.i489.i = load i32, ptr %hp.i483.i, align 16
  %pref64.i490.i = zext i32 %pref32.i489.i to i64
  %pref_sh.i491.i = shl nuw i64 %pref64.i490.i, 32
  %w0_out.i492.i = or disjoint i64 %pref_sh.i491.i, %tot.i466.i
  br label %archx_str_concat.exit518.i

archx_str_concat.exit518.thread.i:                ; preds = %copy.i679.i, %ret_a_clone.i514.i, %ret_b_clone.i516.i
  %common.ret.op.i495.ph.i = phi %ArchxStr [ %common.ret.op.i435.i, %ret_a_clone.i514.i ], [ %out.i684.i, %copy.i679.i ], [ %common.ret.op.i.i639.i, %ret_b_clone.i516.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i453.i)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i454.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i455.i)
  br label %archx_str_drop.exit103.i

archx_str_concat.exit518.thread738.i:             ; preds = %copy.i660.i, %chk_tag.i653.i
  %common.ret.op.i495.ph737.i = phi %ArchxStr [ %common.ret.op.i.i639.i, %chk_tag.i653.i ], [ %out.i665.i, %copy.i660.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i453.i)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i454.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i455.i)
  br label %chk_tag.i96.i

archx_str_concat.exit518.i:                       ; preds = %copy_long.i485.i, %build_sso.i497.i
  %rw0.i502.pn.i = phi i64 [ %rw0.i502.i, %build_sso.i497.i ], [ %w0_out.i492.i, %copy_long.i485.i ]
  %rw1.i503.pn.i = phi i64 [ %rw1.i503.i, %build_sso.i497.i ], [ %htagged.i487.i, %copy_long.i485.i ]
  %rs0.i504.pn.i = insertvalue %ArchxStr poison, i64 %rw0.i502.pn.i, 0
  %common.ret.op.i495.i = insertvalue %ArchxStr %rs0.i504.pn.i, i64 %rw1.i503.pn.i, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i453.i)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i454.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i455.i)
  %long.i95.i = icmp samesign ugt i64 %blen.i461.i, 12
  br i1 %long.i95.i, label %chk_tag.i96.i, label %archx_str_drop.exit103.i

chk_tag.i96.i:                                    ; preds = %archx_str_concat.exit518.i, %archx_str_concat.exit518.thread738.i
  %common.ret.op.i495741.i = phi %ArchxStr [ %common.ret.op.i495.ph737.i, %archx_str_concat.exit518.thread738.i ], [ %common.ret.op.i495.i, %archx_str_concat.exit518.i ]
  %tag.i98.i = and i64 %bw1.i459.i, 1
  %owned.not.i99.i = icmp eq i64 %tag.i98.i, 0
  br i1 %owned.not.i99.i, label %archx_str_drop.exit103.i, label %do_free.i100.i

do_free.i100.i:                                   ; preds = %chk_tag.i96.i
  %raw.i101.i = and i64 %bw1.i459.i, -2
  %ptr.i102.i = inttoptr i64 %raw.i101.i to ptr
  call void @free(ptr %ptr.i102.i)
  br label %archx_str_drop.exit103.i

archx_str_drop.exit103.i:                         ; preds = %do_free.i100.i, %chk_tag.i96.i, %archx_str_concat.exit518.i, %archx_str_concat.exit518.thread.i
  %common.ret.op.i495735.i = phi %ArchxStr [ %common.ret.op.i495.ph.i, %archx_str_concat.exit518.thread.i ], [ %common.ret.op.i495.i, %archx_str_concat.exit518.i ], [ %common.ret.op.i495741.i, %chk_tag.i96.i ], [ %common.ret.op.i495741.i, %do_free.i100.i ]
  %long.i106.i = icmp samesign ult i64 %alen.i460.i, 13
  %tag.i109.i = and i64 %aw1.i457.i, 1
  %owned.not.i110.i = icmp eq i64 %tag.i109.i, 0
  %or.cond749.i = select i1 %long.i106.i, i1 true, i1 %owned.not.i110.i
  br i1 %or.cond749.i, label %archx_str_drop.exit114.i, label %do_free.i111.i

do_free.i111.i:                                   ; preds = %archx_str_drop.exit103.i
  %raw.i112.i = and i64 %aw1.i457.i, -2
  %ptr.i113.i = inttoptr i64 %raw.i112.i to ptr
  call void @free(ptr %ptr.i113.i)
  br label %archx_str_drop.exit114.i

archx_str_drop.exit114.i:                         ; preds = %do_free.i111.i, %archx_str_drop.exit103.i
  %long.i117.i = icmp samesign ult i64 %alen.i404.i, 13
  %tag.i120.i = and i64 %aw1.i403.i, 1
  %owned.not.i121.i = icmp eq i64 %tag.i120.i, 0
  %or.cond750.i = select i1 %long.i117.i, i1 true, i1 %owned.not.i121.i
  br i1 %or.cond750.i, label %archx_str_drop.exit125.i, label %do_free.i122.i

do_free.i122.i:                                   ; preds = %archx_str_drop.exit114.i
  %raw.i123.i = and i64 %aw1.i403.i, -2
  %ptr.i124.i = inttoptr i64 %raw.i123.i to ptr
  call void @free(ptr %ptr.i124.i)
  br label %archx_str_drop.exit125.i

archx_str_drop.exit125.i:                         ; preds = %do_free.i122.i, %archx_str_drop.exit114.i
  %long.i128.i = icmp samesign ult i64 %blen.i341.i, 13
  %tag.i131.i = and i64 %bw1.i339.i, 1
  %owned.not.i132.i = icmp eq i64 %tag.i131.i, 0
  %or.cond751.i = select i1 %long.i128.i, i1 true, i1 %owned.not.i132.i
  br i1 %or.cond751.i, label %archx_str_drop.exit136.i, label %do_free.i133.i

do_free.i133.i:                                   ; preds = %archx_str_drop.exit125.i
  %raw.i134.i = and i64 %bw1.i339.i, -2
  %ptr.i135.i = inttoptr i64 %raw.i134.i to ptr
  call void @free(ptr %ptr.i135.i)
  br label %archx_str_drop.exit136.i

archx_str_drop.exit136.i:                         ; preds = %do_free.i133.i, %archx_str_drop.exit125.i
  %long.i139.i = icmp samesign ult i64 %alen.i340.i, 13
  %tag.i142.i = and i64 %aw1.i337.i, 1
  %owned.not.i143.i = icmp eq i64 %tag.i142.i, 0
  %or.cond752.i = select i1 %long.i139.i, i1 true, i1 %owned.not.i143.i
  br i1 %or.cond752.i, label %archx_str_drop.exit147.i, label %do_free.i144.i

do_free.i144.i:                                   ; preds = %archx_str_drop.exit136.i
  %raw.i145.i = and i64 %aw1.i337.i, -2
  %ptr.i146.i = inttoptr i64 %raw.i145.i to ptr
  call void @free(ptr %ptr.i146.i)
  br label %archx_str_drop.exit147.i

archx_str_drop.exit147.i:                         ; preds = %do_free.i144.i, %archx_str_drop.exit136.i
  %long.i150.i = icmp samesign ult i64 %alen.i.i.pre-phi, 13
  %tag.i153.i = and i64 %aw1.i.i.pre-phi, 1
  %owned.not.i154.i = icmp eq i64 %tag.i153.i, 0
  %or.cond753.i = select i1 %long.i150.i, i1 true, i1 %owned.not.i154.i
  br i1 %or.cond753.i, label %v.2.i689.i, label %do_free.i155.i

do_free.i155.i:                                   ; preds = %archx_str_drop.exit147.i
  %raw.i156.i = and i64 %aw1.i.i.pre-phi, -2
  %ptr.i157.i = inttoptr i64 %raw.i156.i to ptr
  call void @free(ptr %ptr.i157.i)
  br label %v.2.i689.i

v.2.i689.i:                                       ; preds = %do_free.i155.i, %archx_str_drop.exit147.i
  %tag.i.i692.i = and i64 %t3.fca.1.extract.i.i.pre-phi, 1
  %owned.not.i.i693.i = icmp eq i64 %tag.i.i692.i, 0
  %or.cond.i694.i = select i1 %long.i570.i, i1 true, i1 %owned.not.i.i693.i
  br i1 %or.cond.i694.i, label %archx_fn_describe_shape.exit, label %do_free.i.i695.i

do_free.i.i695.i:                                 ; preds = %v.2.i689.i
  %raw.i.i696.i = and i64 %t3.fca.1.extract.i.i.pre-phi, -2
  %ptr.i.i697.i = inttoptr i64 %raw.i.i696.i to ptr
  call void @free(ptr %ptr.i.i697.i)
  br label %archx_fn_describe_shape.exit

archx_enum_drop_Shape.exit710.i:                  ; preds = %archx_enum_clone_Shape.exit
  %t90.i = icmp eq i64 %t129.unpack, 3
  call void @llvm.assume(i1 %t90.i)
  br label %archx_fn_describe_shape.exit

archx_fn_describe_shape.exit:                     ; preds = %archx_str_concat.exit.thread.i, %archx_str_concat.exit.i, %do_free.i.i1898, %archx_str_concat.exit194.thread.i, %archx_str_concat.exit194.thread769.i, %archx_str_concat.exit194.i, %do_free.i67.i, %archx_str_concat.exit244.thread.i, %archx_str_concat.exit244.thread780.i, %archx_str_concat.exit244.i, %do_free.i78.i, %archx_str_concat.exit294.thread.i, %archx_str_concat.exit294.thread791.i, %archx_str_concat.exit294.i, %do_free.i89.i, %v.2.i689.i, %do_free.i.i695.i, %archx_enum_drop_Shape.exit710.i
  %dst.sroa.5.0.i2061 = phi i64 [ %t129.unpack58.unpack61, %archx_enum_drop_Shape.exit710.i ], [ %t129.unpack58.unpack61, %archx_str_concat.exit.thread.i ], [ %t129.unpack58.unpack61, %archx_str_concat.exit.i ], [ %t129.unpack58.unpack61, %do_free.i.i1898 ], [ %t129.unpack58.unpack61, %archx_str_concat.exit194.thread.i ], [ %t129.unpack58.unpack61, %archx_str_concat.exit194.i ], [ %t129.unpack58.unpack61, %do_free.i67.i ], [ %t129.unpack58.unpack61, %archx_str_concat.exit244.thread.i ], [ %t129.unpack58.unpack61, %archx_str_concat.exit244.i ], [ %t129.unpack58.unpack61, %do_free.i78.i ], [ %t129.unpack58.unpack61, %archx_str_concat.exit294.thread.i ], [ %t129.unpack58.unpack61, %archx_str_concat.exit294.i ], [ %t129.unpack58.unpack61, %do_free.i89.i ], [ %t3.fca.1.extract.i, %v.2.i689.i ], [ %t3.fca.1.extract.i, %do_free.i.i695.i ], [ %t129.unpack58.unpack61, %archx_str_concat.exit194.thread769.i ], [ %t129.unpack58.unpack61, %archx_str_concat.exit244.thread780.i ], [ %t129.unpack58.unpack61, %archx_str_concat.exit294.thread791.i ]
  %dst.sroa.2.0.i2059 = phi i64 [ %t129.unpack58.unpack, %archx_enum_drop_Shape.exit710.i ], [ %t129.unpack58.unpack, %archx_str_concat.exit.thread.i ], [ %t129.unpack58.unpack, %archx_str_concat.exit.i ], [ %t129.unpack58.unpack, %do_free.i.i1898 ], [ %t129.unpack58.unpack, %archx_str_concat.exit194.thread.i ], [ %t129.unpack58.unpack, %archx_str_concat.exit194.i ], [ %t129.unpack58.unpack, %do_free.i67.i ], [ %t129.unpack58.unpack, %archx_str_concat.exit244.thread.i ], [ %t129.unpack58.unpack, %archx_str_concat.exit244.i ], [ %t129.unpack58.unpack, %do_free.i78.i ], [ %t129.unpack58.unpack, %archx_str_concat.exit294.thread.i ], [ %t129.unpack58.unpack, %archx_str_concat.exit294.i ], [ %t129.unpack58.unpack, %do_free.i89.i ], [ %t3.fca.0.extract.i, %v.2.i689.i ], [ %t3.fca.0.extract.i, %do_free.i.i695.i ], [ %t129.unpack58.unpack, %archx_str_concat.exit194.thread769.i ], [ %t129.unpack58.unpack, %archx_str_concat.exit244.thread780.i ], [ %t129.unpack58.unpack, %archx_str_concat.exit294.thread791.i ]
  %common.ret.op.i1887 = phi %ArchxStr [ { i64 8390326386350358533, i64 121 }, %archx_enum_drop_Shape.exit710.i ], [ { i64 7454127449735954445, i64 ptrtoint (ptr @.str.0 to i64) }, %archx_str_concat.exit.thread.i ], [ %ls1.i.i1894, %archx_str_concat.exit.i ], [ %ls1.i.i1894, %do_free.i.i1898 ], [ { i64 7165905831022559239, i64 3827052 }, %archx_str_concat.exit194.thread.i ], [ %common.ret.op.i186.i, %archx_str_concat.exit194.i ], [ %common.ret.op.i186.i, %do_free.i67.i ], [ { i64 7022643932689334279, i64 3827058 }, %archx_str_concat.exit244.thread.i ], [ %common.ret.op.i227.i, %archx_str_concat.exit244.i ], [ %common.ret.op.i227.i, %do_free.i78.i ], [ { i64 8386658471394672645, i64 58 }, %archx_str_concat.exit294.thread.i ], [ %common.ret.op.i277.i, %archx_str_concat.exit294.i ], [ %common.ret.op.i277.i, %do_free.i89.i ], [ %common.ret.op.i495735.i, %v.2.i689.i ], [ %common.ret.op.i495735.i, %do_free.i.i695.i ], [ %common.ret.op.i186773.i, %archx_str_concat.exit194.thread769.i ], [ %common.ret.op.i227784.i, %archx_str_concat.exit244.thread780.i ], [ %common.ret.op.i277795.i, %archx_str_concat.exit294.thread791.i ]
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i247.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i197.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1913)
  %w0.i1914 = extractvalue %ArchxStr %common.ret.op.i1887, 0
  %w1.i1915 = extractvalue %ArchxStr %common.ret.op.i1887, 1
  %len.i1916 = and i64 %w0.i1914, 4294967295
  %short.i1917 = icmp samesign ult i64 %len.i1916, 13
  br i1 %short.i1917, label %emit.i1938, label %emit.thread.i1918

emit.thread.i1918:                                ; preds = %archx_fn_describe_shape.exit
  %raw.i1919 = and i64 %w1.i1915, -4
  %lptr.i1920 = inttoptr i64 %raw.i1919 to ptr
  br label %chk_nul.i1921

emit.i1938:                                       ; preds = %archx_fn_describe_shape.exit
  %p4.i1939 = lshr i64 %w0.i1914, 32
  %p4_32.i1940 = trunc nuw i64 %p4.i1939 to i32
  store i32 %p4_32.i1940, ptr %tmp.i1913, align 4
  store i64 %w1.i1915, ptr %tmp4.i1941, align 4
  %pos.not.i1942 = icmp eq i64 %len.i1916, 0
  br i1 %pos.not.i1942, label %do_nl.i1933, label %chk_nul.i1921

chk_nul.i1921:                                    ; preds = %emit.i1938, %emit.thread.i1918
  %data3.i1922 = phi ptr [ %lptr.i1920, %emit.thread.i1918 ], [ %tmp.i1913, %emit.i1938 ]
  %nul.i1923 = call ptr @memchr(ptr nonnull %data3.i1922, i32 0, i64 %len.i1916)
  %has_nul.not.i1924 = icmp eq ptr %nul.i1923, null
  br i1 %has_nul.not.i1924, label %fast_printf.i1935, label %byte_loop.i1925

fast_printf.i1935:                                ; preds = %chk_nul.i1921
  %len32.i1936 = trunc i64 %w0.i1914 to i32
  %np.i1937 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1936, ptr nonnull %data3.i1922)
  br label %archx_str_print.exit1943

byte_loop.i1925:                                  ; preds = %chk_nul.i1921, %byte_loop.i1925
  %bi.i1926 = phi i64 [ %bnext.i1931, %byte_loop.i1925 ], [ 0, %chk_nul.i1921 ]
  %bp.i1927 = getelementptr inbounds nuw i8, ptr %data3.i1922, i64 %bi.i1926
  %ch8.i1928 = load i8, ptr %bp.i1927, align 1
  %ch32.i1929 = zext i8 %ch8.i1928 to i32
  %pc.i1930 = call i32 @putchar(i32 %ch32.i1929)
  %bnext.i1931 = add nuw nsw i64 %bi.i1926, 1
  %exitcond.not.i1932 = icmp eq i64 %bnext.i1931, %len.i1916
  br i1 %exitcond.not.i1932, label %do_nl.i1933, label %byte_loop.i1925

do_nl.i1933:                                      ; preds = %byte_loop.i1925, %emit.i1938
  %nc.i1934 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1943

archx_str_print.exit1943:                         ; preds = %fast_printf.i1935, %do_nl.i1933
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1913)
  %tag.i358 = and i64 %w1.i1915, 1
  %owned.not.i359 = icmp eq i64 %tag.i358, 0
  %or.cond2102 = select i1 %short.i1917, i1 true, i1 %owned.not.i359
  br i1 %or.cond2102, label %archx_str_drop.exit363, label %do_free.i360

do_free.i360:                                     ; preds = %archx_str_print.exit1943
  %raw.i361 = and i64 %w1.i1915, -2
  %ptr.i362 = inttoptr i64 %raw.i361 to ptr
  call void @free(ptr %ptr.i362)
  br label %archx_str_drop.exit363

archx_str_drop.exit363:                           ; preds = %archx_str_print.exit1943, %do_free.i360
  %t135 = add nuw nsw i64 %foreach.idx.124.02154, 1
  %exitcond.not = icmp eq i64 %t135, 6
  br i1 %exitcond.not, label %archx_vec_drop_U5_Shape.exit, label %foreach.body.14

archx_vec_drop_U5_Shape.exit:                     ; preds = %archx_str_drop.exit363
  call void @free(ptr nonnull %t109)
  br i1 %cond.i1876, label %v.2.i1953, label %archx_region_release_from.exit

v.2.i1953:                                        ; preds = %archx_vec_drop_U5_Shape.exit
  %len.i.i1954 = and i64 %dst.sroa.2.0.i2059, 4294967295
  %long.i.i1955 = icmp samesign ult i64 %len.i.i1954, 13
  %tag.i.i1956 = and i64 %dst.sroa.5.0.i2061, 1
  %owned.not.i.i1957 = icmp eq i64 %tag.i.i1956, 0
  %or.cond.i1958 = select i1 %long.i.i1955, i1 true, i1 %owned.not.i.i1957
  br i1 %or.cond.i1958, label %archx_region_release_from.exit, label %do_free.i.i1959

do_free.i.i1959:                                  ; preds = %v.2.i1953
  %raw.i.i1960 = and i64 %dst.sroa.5.0.i2061, -2
  %ptr.i.i1961 = inttoptr i64 %raw.i.i1960 to ptr
  call void @free(ptr %ptr.i.i1961)
  br label %archx_region_release_from.exit

archx_region_release_from.exit:                   ; preds = %archx_vec_drop_U5_Shape.exit, %v.2.i1953, %do_free.i.i1959
  call void @free(ptr %t0)
  ret i32 0
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_bounds_fail(i64 range(i64 5, 0) %idx) unnamed_addr #1 {
entry:
  %c = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.err.bounds, i64 %idx, i64 5)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_oom_fail() unnamed_addr #1 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.1)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #2

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #5

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @memchr(ptr captures(none), i32, i64) local_unnamed_addr #6

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #2

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #1

; Function Attrs: nofree nounwind
define private fastcc { i64, i64 } @archx_str_from_float(double %x) unnamed_addr #2 {
entry:
  %sso.i = alloca [16 x i8], align 8
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
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i)
  %z.i = icmp slt i64 %common.ret.op.i, 1
  br i1 %z.i, label %archx_str_from_slice.exit, label %chk_big.i

chk_big.i:                                        ; preds = %archx_fmt_float_buf.exit
  %big.i = icmp samesign ugt i64 %common.ret.op.i, 2147483647
  br i1 %big.i, label %oom.i, label %chk_sso.i

oom.i:                                            ; preds = %alloc_heap.i, %chk_big.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i:                                        ; preds = %chk_big.i
  %short.i = icmp samesign ult i64 %common.ret.op.i, 13
  br i1 %short.i, label %pack_sso.i, label %alloc_heap.i

pack_sso.i:                                       ; preds = %chk_sso.i
  %len32.i = trunc nuw nsw i64 %common.ret.op.i to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i, i8 0, i64 16, i1 false)
  store i32 %len32.i, ptr %sso.i, align 8
  %sso.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.4.sroa_idx, ptr nonnull readonly align 8 %buf, i64 range(i64 -2147483648, 2147483650) %common.ret.op.i, i1 false)
  %sso.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i = load i64, ptr %sso.i, align 8
  %sso.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i, i64 8
  %sso.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i = load i64, ptr %sso.i.8.sroa_idx, align 8
  %ss0.i = insertvalue %ArchxStr poison, i64 %sso.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i, 0
  %ss1.i = insertvalue %ArchxStr %ss0.i, i64 %sso.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i, 1
  br label %archx_str_from_slice.exit

alloc_heap.i:                                     ; preds = %chk_sso.i
  %hp.i = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %common.ret.op.i)
  %hnull.i = icmp eq ptr %hp.i, null
  br i1 %hnull.i, label %oom.i, label %copy_long.i

copy_long.i:                                      ; preds = %alloc_heap.i
  %hp_i.i = ptrtoint ptr %hp.i to i64
  %htagged.i = or disjoint i64 %hp_i.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i, ptr nonnull readonly align 8 %buf, i64 range(i64 -2147483648, 2147483650) %common.ret.op.i, i1 false)
  %pref32.i = load i32, ptr %hp.i, align 16
  %pref64.i = zext i32 %pref32.i to i64
  %pref_sh.i = shl nuw i64 %pref64.i, 32
  %w0_out.i = or disjoint i64 %pref_sh.i, %common.ret.op.i
  %ls0.i = insertvalue %ArchxStr poison, i64 %w0_out.i, 0
  %ls1.i = insertvalue %ArchxStr %ls0.i, i64 %htagged.i, 1
  br label %archx_str_from_slice.exit

archx_str_from_slice.exit:                        ; preds = %archx_fmt_float_buf.exit, %pack_sso.i, %copy_long.i
  %common.ret.op.i1 = phi %ArchxStr [ %ss1.i, %pack_sso.i ], [ %ls1.i, %copy_long.i ], [ zeroinitializer, %archx_fmt_float_buf.exit ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i)
  %oldret = extractvalue %ArchxStr %common.ret.op.i1, 0
  %newret = insertvalue { i64, i64 } poison, i64 %oldret, 0
  %oldret1 = extractvalue %ArchxStr %common.ret.op.i1, 1
  %newret2 = insertvalue { i64, i64 } %newret, i64 %oldret1, 1
  ret { i64, i64 } %newret2
}

; Function Attrs: nofree nounwind
declare noundef i32 @sprintf(ptr noalias noundef writeonly captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #2

; Function Attrs: mustprogress nocallback nofree nounwind willreturn
declare double @strtod(ptr readonly captures(none), ptr writeonly captures(none)) local_unnamed_addr #7

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #8

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #9

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #9

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #10

attributes #0 = { nounwind }
attributes #1 = { cold nofree noreturn nounwind }
attributes #2 = { nofree nounwind }
attributes #3 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #4 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #5 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #6 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #7 = { mustprogress nocallback nofree nounwind willreturn }
attributes #8 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #9 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #10 = { nocallback nofree nounwind willreturn memory(argmem: write) }

!llvm.module.flags = !{!0, !1, !2}

!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
!2 = !{i32 1, !"archx.wrapping", !"false"}
