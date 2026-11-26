; ModuleID = 'ci/out/enums_matching.ll'
source_filename = "ci/out/enums_matching.ll"
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
@str = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %tmp.i1895 = alloca [12 x i8], align 4
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
  %tmp.i1837 = alloca [12 x i8], align 4
  %sso.i.i1807 = alloca [16 x i8], align 8
  %buf.i1808 = alloca [32 x i8], align 8
  %tmp.i1776 = alloca [12 x i8], align 4
  %sso.i.i1709 = alloca [16 x i8], align 8
  %buf.i1710 = alloca [32 x i8], align 8
  %sso.i.i1678 = alloca [16 x i8], align 8
  %buf.i1679 = alloca [32 x i8], align 8
  %tmp.i1623 = alloca [12 x i8], align 4
  %sso.i.i1556 = alloca [16 x i8], align 8
  %buf.i1557 = alloca [32 x i8], align 8
  %sso.i.i1484 = alloca [16 x i8], align 8
  %buf.i1485 = alloca [32 x i8], align 8
  %sso.i.i1453 = alloca [16 x i8], align 8
  %buf.i1454 = alloca [32 x i8], align 8
  %tmp.i = alloca [12 x i8], align 4
  %sso.i.i1382 = alloca [16 x i8], align 8
  %buf.i1383 = alloca [32 x i8], align 8
  %sso.i.i1324 = alloca [16 x i8], align 8
  %buf.i1325 = alloca [32 x i8], align 8
  %sso.i.i = alloca [16 x i8], align 8
  %buf.i = alloca [32 x i8], align 8
  %btmp.i1268 = alloca [12 x i8], align 4
  %out_sso.i1269.sroa.6.sroa.5 = alloca i32, align 4
  %atmp.i1201 = alloca [12 x i8], align 4
  %btmp.i1202 = alloca [12 x i8], align 4
  %out_sso.i1203 = alloca [16 x i8], align 8
  %atmp.i1147 = alloca [12 x i8], align 4
  %out_sso.i1149 = alloca [16 x i8], align 8
  %btmp.i1094 = alloca [12 x i8], align 4
  %out_sso.i1095.sroa.6.sroa.5.sroa.0 = alloca i48, align 8
  %atmp.i1027 = alloca [12 x i8], align 4
  %btmp.i1028 = alloca [12 x i8], align 4
  %out_sso.i1029 = alloca [16 x i8], align 8
  %atmp.i973 = alloca [12 x i8], align 4
  %out_sso.i975 = alloca [16 x i8], align 8
  %atmp.i919 = alloca [12 x i8], align 4
  %out_sso.i921 = alloca [16 x i8], align 8
  %atmp.i865 = alloca [12 x i8], align 4
  %out_sso.i867 = alloca [16 x i8], align 8
  %atmp.i811 = alloca [12 x i8], align 4
  %out_sso.i813 = alloca [16 x i8], align 8
  %atmp.i757 = alloca [12 x i8], align 4
  %out_sso.i759 = alloca [16 x i8], align 8
  %atmp.i691 = alloca [12 x i8], align 4
  %btmp.i692 = alloca [12 x i8], align 4
  %out_sso.i693 = alloca [16 x i8], align 8
  %atmp.i637 = alloca [12 x i8], align 4
  %out_sso.i639 = alloca [16 x i8], align 8
  %btmp.i584 = alloca [12 x i8], align 4
  %out_sso.i585.sroa.6.sroa.5.sroa.0 = alloca i56, align 8
  %atmp.i517 = alloca [12 x i8], align 4
  %btmp.i518 = alloca [12 x i8], align 4
  %out_sso.i519 = alloca [16 x i8], align 8
  %atmp.i463 = alloca [12 x i8], align 4
  %out_sso.i465 = alloca [16 x i8], align 8
  %atmp.i397 = alloca [12 x i8], align 4
  %btmp.i398 = alloca [12 x i8], align 4
  %out_sso.i399 = alloca [16 x i8], align 8
  %atmp.i359 = alloca [12 x i8], align 4
  %out_sso.i361 = alloca [16 x i8], align 8
  %btmp.i = alloca [12 x i8], align 4
  %out_sso.i.sroa.6.sroa.5.sroa.0 = alloca i48, align 8
  %t0 = tail call noalias align 16 dereferenceable_or_null(40) ptr @malloc(i64 40)
  %t1 = icmp eq ptr %t0, null
  br i1 %t1, label %alloc.oom.1, label %alloc.ok.0

alloc.oom.1:                                      ; preds = %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.0:                                       ; preds = %entry
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
  %len.i1321 = sext i32 %n32.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i)
  %z.i.i = icmp slt i32 %n32.i, 1
  br i1 %z.i.i, label %archx_str_from_int.exit, label %chk_sso.i.i

oom.i.i:                                          ; preds = %alloc_heap.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i:                                      ; preds = %alloc.ok.0
  %short.i.i = icmp samesign ult i32 %n32.i, 13
  br i1 %short.i.i, label %pack_sso.i.i, label %alloc_heap.i.i

pack_sso.i.i:                                     ; preds = %chk_sso.i.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i, i8 0, i64 16, i1 false)
  store i32 %n32.i, ptr %sso.i.i, align 8
  %sso.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, 2147483650) %len.i1321, i1 false)
  %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i = load i64, ptr %sso.i.i, align 8
  %sso.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 8
  %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i = load i64, ptr %sso.i.i.8.sroa_idx, align 8
  %ss0.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i, 0
  %ss1.i.i = insertvalue %ArchxStr %ss0.i.i, i64 %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i, 1
  br label %archx_str_from_int.exit

alloc_heap.i.i:                                   ; preds = %chk_sso.i.i
  %hp.i.i = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1321)
  %hnull.i.i = icmp eq ptr %hp.i.i, null
  br i1 %hnull.i.i, label %oom.i.i, label %copy_long.i.i

copy_long.i.i:                                    ; preds = %alloc_heap.i.i
  %hp_i.i.i = ptrtoint ptr %hp.i.i to i64
  %htagged.i.i = or disjoint i64 %hp_i.i.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, 2147483650) %len.i1321, i1 false)
  %pref32.i.i = load i32, ptr %hp.i.i, align 16
  %pref64.i.i = zext i32 %pref32.i.i to i64
  %pref_sh.i.i = shl nuw i64 %pref64.i.i, 32
  %w0_out.i.i = or disjoint i64 %pref_sh.i.i, %len.i1321
  %ls0.i.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i, 0
  %ls1.i.i = insertvalue %ArchxStr %ls0.i.i, i64 %htagged.i.i, 1
  br label %archx_str_from_int.exit

archx_str_from_int.exit:                          ; preds = %alloc.ok.0, %pack_sso.i.i, %copy_long.i.i
  %common.ret.op.i.i = phi %ArchxStr [ %ss1.i.i, %pack_sso.i.i ], [ %ls1.i.i, %copy_long.i.i ], [ zeroinitializer, %alloc.ok.0 ]
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
  %bptr.i2183 = phi ptr [ %blptr.i, %build.i.thread ], [ %btmp.i, %build.i ]
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
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 2 %dst_b.i, ptr nonnull align 1 %bptr.i2183, i64 %blen.i, i1 false)
  %w0_out.i = or disjoint i64 %tot.i, 8386112018410635264
  %ls0.i = insertvalue %ArchxStr poison, i64 %w0_out.i, 0
  %ls1.i = insertvalue %ArchxStr %ls0.i, i64 %htagged.i, 1
  br label %archx_str_concat.exit

archx_str_concat.exit:                            ; preds = %archx_str_from_int.exit, %build_sso.i, %copy_long.i
  %common.ret.op.i = phi %ArchxStr [ %rs1.i, %build_sso.i ], [ %ls1.i, %copy_long.i ], [ { i64 8386112018410635270, i64 15731 }, %archx_str_from_int.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i359)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i361)
  %aw0.i = extractvalue %ArchxStr %common.ret.op.i, 0
  %aw1.i = extractvalue %ArchxStr %common.ret.op.i, 1
  %alen.i = and i64 %aw0.i, 4294967295
  %az.i = icmp eq i64 %alen.i, 0
  br i1 %az.i, label %archx_str_concat.exit396, label %chk_bz.i

chk_bz.i:                                         ; preds = %archx_str_concat.exit
  %tot.i363 = add nuw nsw i64 %alen.i, 1
  %too_big.i364 = icmp samesign ugt i64 %alen.i, 2147483646
  br i1 %too_big.i364, label %oom.i385, label %mat_a.i365

oom.i385:                                         ; preds = %alloc_heap.i371, %chk_bz.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i365:                                       ; preds = %chk_bz.i
  %ashort.i = icmp samesign ult i64 %alen.i, 13
  br i1 %ashort.i, label %mat_b.i, label %mat_b.i.thread

mat_b.i.thread:                                   ; preds = %mat_a.i365
  %araw.i = and i64 %aw1.i, -4
  %alptr.i = inttoptr i64 %araw.i to ptr
  br label %alloc_heap.i371

mat_b.i:                                          ; preds = %mat_a.i365
  %ap4.i = lshr i64 %aw0.i, 32
  %ap4_32.i = trunc nuw i64 %ap4.i to i32
  store i32 %ap4_32.i, ptr %atmp.i359, align 4
  %atmp4.i395 = getelementptr inbounds nuw i8, ptr %atmp.i359, i64 4
  store i64 %aw1.i, ptr %atmp4.i395, align 4
  %fits_sso.i370.not = icmp eq i64 %alen.i, 12
  br i1 %fits_sso.i370.not, label %alloc_heap.i371, label %build_sso.i386

build_sso.i386:                                   ; preds = %mat_b.i
  %out_sso8.i387 = getelementptr inbounds nuw i8, ptr %out_sso.i361, i64 8
  %tot32.i388 = trunc nuw nsw i64 %tot.i363 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i361, i8 0, i64 16, i1 false)
  store i32 %tot32.i388, ptr %out_sso.i361, align 8
  %sso_dst_a.i389 = getelementptr inbounds nuw i8, ptr %out_sso.i361, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i389, ptr nonnull align 4 %atmp.i359, i64 %alen.i, i1 false)
  %sso_dst_b.i390 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i389, i64 %alen.i
  store i8 44, ptr %sso_dst_b.i390, align 1
  %rw0.i391 = load i64, ptr %out_sso.i361, align 8
  %rw1.i392 = load i64, ptr %out_sso8.i387, align 8
  %rs0.i393 = insertvalue %ArchxStr poison, i64 %rw0.i391, 0
  %rs1.i394 = insertvalue %ArchxStr %rs0.i393, i64 %rw1.i392, 1
  br label %archx_str_concat.exit396

alloc_heap.i371:                                  ; preds = %mat_b.i.thread, %mat_b.i
  %aptr.i1966 = phi ptr [ %alptr.i, %mat_b.i.thread ], [ %atmp.i359, %mat_b.i ]
  %hp.i372 = tail call noalias align 16 ptr @malloc(i64 %tot.i363)
  %hnull.i373 = icmp eq ptr %hp.i372, null
  br i1 %hnull.i373, label %oom.i385, label %copy_long.i374

copy_long.i374:                                   ; preds = %alloc_heap.i371
  %hp_i.i375 = ptrtoint ptr %hp.i372 to i64
  %htagged.i376 = or disjoint i64 %hp_i.i375, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i372, ptr nonnull align 1 %aptr.i1966, i64 %alen.i, i1 false)
  %dst_b.i377 = getelementptr inbounds nuw i8, ptr %hp.i372, i64 %alen.i
  store i8 44, ptr %dst_b.i377, align 1
  %pref32.i378 = load i32, ptr %hp.i372, align 16
  %pref64.i379 = zext i32 %pref32.i378 to i64
  %pref_sh.i380 = shl nuw i64 %pref64.i379, 32
  %w0_out.i381 = or disjoint i64 %pref_sh.i380, %tot.i363
  %ls0.i382 = insertvalue %ArchxStr poison, i64 %w0_out.i381, 0
  %ls1.i383 = insertvalue %ArchxStr %ls0.i382, i64 %htagged.i376, 1
  br label %archx_str_concat.exit396

archx_str_concat.exit396:                         ; preds = %archx_str_concat.exit, %build_sso.i386, %copy_long.i374
  %common.ret.op.i384 = phi %ArchxStr [ %rs1.i394, %build_sso.i386 ], [ %ls1.i383, %copy_long.i374 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i359)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i361)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1325)
  %n32.i1326 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1325, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 42)
  %len.i1327 = sext i32 %n32.i1326 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1324)
  %z.i.i1328 = icmp slt i32 %n32.i1326, 1
  br i1 %z.i.i1328, label %archx_str_from_int.exit1352, label %chk_sso.i.i1329

oom.i.i1344:                                      ; preds = %alloc_heap.i.i1331
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1329:                                  ; preds = %archx_str_concat.exit396
  %short.i.i1330 = icmp samesign ult i32 %n32.i1326, 13
  br i1 %short.i.i1330, label %pack_sso.i.i1345, label %alloc_heap.i.i1331

pack_sso.i.i1345:                                 ; preds = %chk_sso.i.i1329
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1324, i8 0, i64 16, i1 false)
  store i32 %n32.i1326, ptr %sso.i.i1324, align 8
  %sso.i.i1324.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1324, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1324.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1325, i64 range(i64 -2147483648, 2147483650) %len.i1327, i1 false)
  %sso.i.i1324.0.sso.i.i1324.0.sso.i.i1324.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1347 = load i64, ptr %sso.i.i1324, align 8
  %sso.i.i1324.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1324, i64 8
  %sso.i.i1324.8.sso.i.i1324.8.sso.i.i1324.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1349 = load i64, ptr %sso.i.i1324.8.sroa_idx, align 8
  %ss0.i.i1350 = insertvalue %ArchxStr poison, i64 %sso.i.i1324.0.sso.i.i1324.0.sso.i.i1324.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1347, 0
  %ss1.i.i1351 = insertvalue %ArchxStr %ss0.i.i1350, i64 %sso.i.i1324.8.sso.i.i1324.8.sso.i.i1324.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1349, 1
  br label %archx_str_from_int.exit1352

alloc_heap.i.i1331:                               ; preds = %chk_sso.i.i1329
  %hp.i.i1332 = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1327)
  %hnull.i.i1333 = icmp eq ptr %hp.i.i1332, null
  br i1 %hnull.i.i1333, label %oom.i.i1344, label %copy_long.i.i1334

copy_long.i.i1334:                                ; preds = %alloc_heap.i.i1331
  %hp_i.i.i1335 = ptrtoint ptr %hp.i.i1332 to i64
  %htagged.i.i1336 = or disjoint i64 %hp_i.i.i1335, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1332, ptr nonnull readonly align 8 %buf.i1325, i64 range(i64 -2147483648, 2147483650) %len.i1327, i1 false)
  %pref32.i.i1337 = load i32, ptr %hp.i.i1332, align 16
  %pref64.i.i1338 = zext i32 %pref32.i.i1337 to i64
  %pref_sh.i.i1339 = shl nuw i64 %pref64.i.i1338, 32
  %w0_out.i.i1340 = or disjoint i64 %pref_sh.i.i1339, %len.i1327
  %ls0.i.i1341 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1340, 0
  %ls1.i.i1342 = insertvalue %ArchxStr %ls0.i.i1341, i64 %htagged.i.i1336, 1
  br label %archx_str_from_int.exit1352

archx_str_from_int.exit1352:                      ; preds = %archx_str_concat.exit396, %pack_sso.i.i1345, %copy_long.i.i1334
  %common.ret.op.i.i1343 = phi %ArchxStr [ %ss1.i.i1351, %pack_sso.i.i1345 ], [ %ls1.i.i1342, %copy_long.i.i1334 ], [ zeroinitializer, %archx_str_concat.exit396 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1324)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1325)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i397)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i398)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i399)
  %aw0.i400 = extractvalue %ArchxStr %common.ret.op.i384, 0
  %aw1.i401 = extractvalue %ArchxStr %common.ret.op.i384, 1
  %bw0.i402 = extractvalue %ArchxStr %common.ret.op.i.i1343, 0
  %bw1.i403 = extractvalue %ArchxStr %common.ret.op.i.i1343, 1
  %alen.i404 = and i64 %aw0.i400, 4294967295
  %blen.i405 = and i64 %bw0.i402, 4294967295
  %az.i406 = icmp eq i64 %alen.i404, 0
  br i1 %az.i406, label %ret_b_clone.i460, label %chk_bz.i407

ret_b_clone.i460:                                 ; preds = %archx_str_from_int.exit1352
  %long.i1355 = icmp samesign ult i64 %blen.i405, 13
  %tag.i1359 = and i64 %bw1.i403, 3
  %owned.not.i1360 = icmp eq i64 %tag.i1359, 0
  %or.cond = select i1 %long.i1355, i1 true, i1 %owned.not.i1360
  br i1 %or.cond, label %archx_str_concat.exit462, label %dup_heap.i

dup_heap.i:                                       ; preds = %ret_b_clone.i460
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %blen.i405)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i1361, label %copy.i

oom.i1361:                                        ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %bw1.i403, -4
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 4 %src.i, i64 %blen.i405, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %out.i = insertvalue %ArchxStr %common.ret.op.i.i1343, i64 %tagged.i, 1
  br label %archx_str_concat.exit462

chk_bz.i407:                                      ; preds = %archx_str_from_int.exit1352
  %bz.i408 = icmp eq i64 %blen.i405, 0
  br i1 %bz.i408, label %ret_a_clone.i458, label %calc_tot.i409

ret_a_clone.i458:                                 ; preds = %chk_bz.i407
  %long.i1364 = icmp samesign ult i64 %alen.i404, 13
  %tag.i1368 = and i64 %aw1.i401, 3
  %owned.not.i1369 = icmp eq i64 %tag.i1368, 0
  %or.cond2047 = select i1 %long.i1364, i1 true, i1 %owned.not.i1369
  br i1 %or.cond2047, label %archx_str_concat.exit462, label %dup_heap.i1370

dup_heap.i1370:                                   ; preds = %ret_a_clone.i458
  %dst.i1371 = tail call noalias align 16 ptr @malloc(i64 %alen.i404)
  %isnull.i1372 = icmp eq ptr %dst.i1371, null
  br i1 %isnull.i1372, label %oom.i1379, label %copy.i1373

oom.i1379:                                        ; preds = %dup_heap.i1370
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i1373:                                       ; preds = %dup_heap.i1370
  %src_i.i1374 = and i64 %aw1.i401, -4
  %src.i1375 = inttoptr i64 %src_i.i1374 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1371, ptr nonnull align 4 %src.i1375, i64 %alen.i404, i1 false)
  %dst_i.i1376 = ptrtoint ptr %dst.i1371 to i64
  %tagged.i1377 = or disjoint i64 %dst_i.i1376, 1
  %out.i1378 = insertvalue %ArchxStr %common.ret.op.i384, i64 %tagged.i1377, 1
  br label %archx_str_concat.exit462

calc_tot.i409:                                    ; preds = %chk_bz.i407
  %tot.i410 = add nuw nsw i64 %blen.i405, %alen.i404
  %too_big.i411 = icmp samesign ugt i64 %tot.i410, 2147483647
  br i1 %too_big.i411, label %oom.i440, label %mat_a.i412

oom.i440:                                         ; preds = %alloc_heap.i426, %calc_tot.i409
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i412:                                       ; preds = %calc_tot.i409
  %ashort.i413 = icmp samesign ult i64 %alen.i404, 13
  br i1 %ashort.i413, label %mat_a_short.i454, label %mat_a_long.i414

mat_a_short.i454:                                 ; preds = %mat_a.i412
  %ap4.i455 = lshr i64 %aw0.i400, 32
  %ap4_32.i456 = trunc nuw i64 %ap4.i455 to i32
  store i32 %ap4_32.i456, ptr %atmp.i397, align 4
  %atmp4.i457 = getelementptr inbounds nuw i8, ptr %atmp.i397, i64 4
  store i64 %aw1.i401, ptr %atmp4.i457, align 4
  br label %mat_b.i417

mat_a_long.i414:                                  ; preds = %mat_a.i412
  %araw.i415 = and i64 %aw1.i401, -4
  %alptr.i416 = inttoptr i64 %araw.i415 to ptr
  br label %mat_b.i417

mat_b.i417:                                       ; preds = %mat_a_long.i414, %mat_a_short.i454
  %aptr.i418 = phi ptr [ %atmp.i397, %mat_a_short.i454 ], [ %alptr.i416, %mat_a_long.i414 ]
  %bshort.i419 = icmp samesign ult i64 %blen.i405, 13
  br i1 %bshort.i419, label %mat_b_short.i450, label %mat_b_long.i420

mat_b_short.i450:                                 ; preds = %mat_b.i417
  %bp4.i451 = lshr i64 %bw0.i402, 32
  %bp4_32.i452 = trunc nuw i64 %bp4.i451 to i32
  store i32 %bp4_32.i452, ptr %btmp.i398, align 4
  %btmp4.i453 = getelementptr inbounds nuw i8, ptr %btmp.i398, i64 4
  store i64 %bw1.i403, ptr %btmp4.i453, align 4
  br label %build.i423

mat_b_long.i420:                                  ; preds = %mat_b.i417
  %braw.i421 = and i64 %bw1.i403, -4
  %blptr.i422 = inttoptr i64 %braw.i421 to ptr
  br label %build.i423

build.i423:                                       ; preds = %mat_b_long.i420, %mat_b_short.i450
  %bptr.i424 = phi ptr [ %btmp.i398, %mat_b_short.i450 ], [ %blptr.i422, %mat_b_long.i420 ]
  %fits_sso.i425 = icmp samesign ult i64 %tot.i410, 13
  br i1 %fits_sso.i425, label %build_sso.i441, label %alloc_heap.i426

build_sso.i441:                                   ; preds = %build.i423
  %out_sso8.i442 = getelementptr inbounds nuw i8, ptr %out_sso.i399, i64 8
  %tot32.i443 = trunc nuw nsw i64 %tot.i410 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i399, i8 0, i64 16, i1 false)
  store i32 %tot32.i443, ptr %out_sso.i399, align 8
  %sso_dst_a.i444 = getelementptr inbounds nuw i8, ptr %out_sso.i399, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i444, ptr nonnull align 1 %aptr.i418, i64 %alen.i404, i1 false)
  %sso_dst_b.i445 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i444, i64 %alen.i404
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i445, ptr nonnull align 1 %bptr.i424, i64 %blen.i405, i1 false)
  %rw0.i446 = load i64, ptr %out_sso.i399, align 8
  %rw1.i447 = load i64, ptr %out_sso8.i442, align 8
  %rs0.i448 = insertvalue %ArchxStr poison, i64 %rw0.i446, 0
  %rs1.i449 = insertvalue %ArchxStr %rs0.i448, i64 %rw1.i447, 1
  br label %archx_str_concat.exit462

alloc_heap.i426:                                  ; preds = %build.i423
  %hp.i427 = tail call noalias align 16 ptr @malloc(i64 %tot.i410)
  %hnull.i428 = icmp eq ptr %hp.i427, null
  br i1 %hnull.i428, label %oom.i440, label %copy_long.i429

copy_long.i429:                                   ; preds = %alloc_heap.i426
  %hp_i.i430 = ptrtoint ptr %hp.i427 to i64
  %htagged.i431 = or disjoint i64 %hp_i.i430, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i427, ptr nonnull align 1 %aptr.i418, i64 %alen.i404, i1 false)
  %dst_b.i432 = getelementptr inbounds nuw i8, ptr %hp.i427, i64 %alen.i404
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i432, ptr nonnull align 1 %bptr.i424, i64 %blen.i405, i1 false)
  %pref32.i433 = load i32, ptr %hp.i427, align 16
  %pref64.i434 = zext i32 %pref32.i433 to i64
  %pref_sh.i435 = shl nuw i64 %pref64.i434, 32
  %w0_out.i436 = or disjoint i64 %pref_sh.i435, %tot.i410
  %ls0.i437 = insertvalue %ArchxStr poison, i64 %w0_out.i436, 0
  %ls1.i438 = insertvalue %ArchxStr %ls0.i437, i64 %htagged.i431, 1
  br label %archx_str_concat.exit462

archx_str_concat.exit462:                         ; preds = %copy.i1373, %ret_a_clone.i458, %copy.i, %ret_b_clone.i460, %build_sso.i441, %copy_long.i429
  %common.ret.op.i439 = phi %ArchxStr [ %rs1.i449, %build_sso.i441 ], [ %ls1.i438, %copy_long.i429 ], [ %out.i, %copy.i ], [ %common.ret.op.i.i1343, %ret_b_clone.i460 ], [ %out.i1378, %copy.i1373 ], [ %common.ret.op.i384, %ret_a_clone.i458 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i397)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i398)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i399)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i463)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i465)
  %aw0.i466 = extractvalue %ArchxStr %common.ret.op.i439, 0
  %aw1.i467 = extractvalue %ArchxStr %common.ret.op.i439, 1
  %alen.i468 = and i64 %aw0.i466, 4294967295
  %az.i469 = icmp eq i64 %alen.i468, 0
  br i1 %az.i469, label %archx_str_concat.exit516, label %chk_bz.i470

chk_bz.i470:                                      ; preds = %archx_str_concat.exit462
  %tot.i472 = add nuw nsw i64 %alen.i468, 1
  %too_big.i473 = icmp samesign ugt i64 %alen.i468, 2147483646
  br i1 %too_big.i473, label %oom.i500, label %mat_a.i474

oom.i500:                                         ; preds = %alloc_heap.i486, %chk_bz.i470
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i474:                                       ; preds = %chk_bz.i470
  %ashort.i475 = icmp samesign ult i64 %alen.i468, 13
  br i1 %ashort.i475, label %mat_b.i479, label %mat_b.i479.thread

mat_b.i479.thread:                                ; preds = %mat_a.i474
  %araw.i477 = and i64 %aw1.i467, -4
  %alptr.i478 = inttoptr i64 %araw.i477 to ptr
  br label %alloc_heap.i486

mat_b.i479:                                       ; preds = %mat_a.i474
  %ap4.i511 = lshr i64 %aw0.i466, 32
  %ap4_32.i512 = trunc nuw i64 %ap4.i511 to i32
  store i32 %ap4_32.i512, ptr %atmp.i463, align 4
  %atmp4.i513 = getelementptr inbounds nuw i8, ptr %atmp.i463, i64 4
  store i64 %aw1.i467, ptr %atmp4.i513, align 4
  %fits_sso.i485.not = icmp eq i64 %alen.i468, 12
  br i1 %fits_sso.i485.not, label %alloc_heap.i486, label %build_sso.i501

build_sso.i501:                                   ; preds = %mat_b.i479
  %out_sso8.i502 = getelementptr inbounds nuw i8, ptr %out_sso.i465, i64 8
  %tot32.i503 = trunc nuw nsw i64 %tot.i472 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i465, i8 0, i64 16, i1 false)
  store i32 %tot32.i503, ptr %out_sso.i465, align 8
  %sso_dst_a.i504 = getelementptr inbounds nuw i8, ptr %out_sso.i465, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i504, ptr nonnull align 4 %atmp.i463, i64 %alen.i468, i1 false)
  %sso_dst_b.i505 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i504, i64 %alen.i468
  store i8 44, ptr %sso_dst_b.i505, align 1
  %rw0.i506 = load i64, ptr %out_sso.i465, align 8
  %rw1.i507 = load i64, ptr %out_sso8.i502, align 8
  %rs0.i508 = insertvalue %ArchxStr poison, i64 %rw0.i506, 0
  %rs1.i509 = insertvalue %ArchxStr %rs0.i508, i64 %rw1.i507, 1
  br label %archx_str_concat.exit516

alloc_heap.i486:                                  ; preds = %mat_b.i479.thread, %mat_b.i479
  %aptr.i4801969 = phi ptr [ %alptr.i478, %mat_b.i479.thread ], [ %atmp.i463, %mat_b.i479 ]
  %hp.i487 = tail call noalias align 16 ptr @malloc(i64 %tot.i472)
  %hnull.i488 = icmp eq ptr %hp.i487, null
  br i1 %hnull.i488, label %oom.i500, label %copy_long.i489

copy_long.i489:                                   ; preds = %alloc_heap.i486
  %hp_i.i490 = ptrtoint ptr %hp.i487 to i64
  %htagged.i491 = or disjoint i64 %hp_i.i490, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i487, ptr nonnull align 1 %aptr.i4801969, i64 %alen.i468, i1 false)
  %dst_b.i492 = getelementptr inbounds nuw i8, ptr %hp.i487, i64 %alen.i468
  store i8 44, ptr %dst_b.i492, align 1
  %pref32.i493 = load i32, ptr %hp.i487, align 16
  %pref64.i494 = zext i32 %pref32.i493 to i64
  %pref_sh.i495 = shl nuw i64 %pref64.i494, 32
  %w0_out.i496 = or disjoint i64 %pref_sh.i495, %tot.i472
  %ls0.i497 = insertvalue %ArchxStr poison, i64 %w0_out.i496, 0
  %ls1.i498 = insertvalue %ArchxStr %ls0.i497, i64 %htagged.i491, 1
  br label %archx_str_concat.exit516

archx_str_concat.exit516:                         ; preds = %archx_str_concat.exit462, %build_sso.i501, %copy_long.i489
  %common.ret.op.i499 = phi %ArchxStr [ %rs1.i509, %build_sso.i501 ], [ %ls1.i498, %copy_long.i489 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit462 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i463)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i465)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1383)
  %n32.i1384 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1383, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 86)
  %len.i1385 = sext i32 %n32.i1384 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1382)
  %z.i.i1386 = icmp slt i32 %n32.i1384, 1
  br i1 %z.i.i1386, label %archx_str_from_int.exit1410, label %chk_sso.i.i1387

oom.i.i1402:                                      ; preds = %alloc_heap.i.i1389
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1387:                                  ; preds = %archx_str_concat.exit516
  %short.i.i1388 = icmp samesign ult i32 %n32.i1384, 13
  br i1 %short.i.i1388, label %pack_sso.i.i1403, label %alloc_heap.i.i1389

pack_sso.i.i1403:                                 ; preds = %chk_sso.i.i1387
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1382, i8 0, i64 16, i1 false)
  store i32 %n32.i1384, ptr %sso.i.i1382, align 8
  %sso.i.i1382.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1382, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1382.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1383, i64 range(i64 -2147483648, 2147483650) %len.i1385, i1 false)
  %sso.i.i1382.0.sso.i.i1382.0.sso.i.i1382.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1405 = load i64, ptr %sso.i.i1382, align 8
  %sso.i.i1382.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1382, i64 8
  %sso.i.i1382.8.sso.i.i1382.8.sso.i.i1382.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1407 = load i64, ptr %sso.i.i1382.8.sroa_idx, align 8
  %ss0.i.i1408 = insertvalue %ArchxStr poison, i64 %sso.i.i1382.0.sso.i.i1382.0.sso.i.i1382.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1405, 0
  %ss1.i.i1409 = insertvalue %ArchxStr %ss0.i.i1408, i64 %sso.i.i1382.8.sso.i.i1382.8.sso.i.i1382.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1407, 1
  br label %archx_str_from_int.exit1410

alloc_heap.i.i1389:                               ; preds = %chk_sso.i.i1387
  %hp.i.i1390 = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1385)
  %hnull.i.i1391 = icmp eq ptr %hp.i.i1390, null
  br i1 %hnull.i.i1391, label %oom.i.i1402, label %copy_long.i.i1392

copy_long.i.i1392:                                ; preds = %alloc_heap.i.i1389
  %hp_i.i.i1393 = ptrtoint ptr %hp.i.i1390 to i64
  %htagged.i.i1394 = or disjoint i64 %hp_i.i.i1393, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1390, ptr nonnull readonly align 8 %buf.i1383, i64 range(i64 -2147483648, 2147483650) %len.i1385, i1 false)
  %pref32.i.i1395 = load i32, ptr %hp.i.i1390, align 16
  %pref64.i.i1396 = zext i32 %pref32.i.i1395 to i64
  %pref_sh.i.i1397 = shl nuw i64 %pref64.i.i1396, 32
  %w0_out.i.i1398 = or disjoint i64 %pref_sh.i.i1397, %len.i1385
  %ls0.i.i1399 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1398, 0
  %ls1.i.i1400 = insertvalue %ArchxStr %ls0.i.i1399, i64 %htagged.i.i1394, 1
  br label %archx_str_from_int.exit1410

archx_str_from_int.exit1410:                      ; preds = %archx_str_concat.exit516, %pack_sso.i.i1403, %copy_long.i.i1392
  %common.ret.op.i.i1401 = phi %ArchxStr [ %ss1.i.i1409, %pack_sso.i.i1403 ], [ %ls1.i.i1400, %copy_long.i.i1392 ], [ zeroinitializer, %archx_str_concat.exit516 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1382)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1383)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i517)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i518)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i519)
  %aw0.i520 = extractvalue %ArchxStr %common.ret.op.i499, 0
  %aw1.i521 = extractvalue %ArchxStr %common.ret.op.i499, 1
  %bw0.i522 = extractvalue %ArchxStr %common.ret.op.i.i1401, 0
  %bw1.i523 = extractvalue %ArchxStr %common.ret.op.i.i1401, 1
  %alen.i524 = and i64 %aw0.i520, 4294967295
  %blen.i525 = and i64 %bw0.i522, 4294967295
  %az.i526 = icmp eq i64 %alen.i524, 0
  br i1 %az.i526, label %ret_b_clone.i580, label %chk_bz.i527

ret_b_clone.i580:                                 ; preds = %archx_str_from_int.exit1410
  %long.i1413 = icmp samesign ult i64 %blen.i525, 13
  %tag.i1417 = and i64 %bw1.i523, 3
  %owned.not.i1418 = icmp eq i64 %tag.i1417, 0
  %or.cond2048 = select i1 %long.i1413, i1 true, i1 %owned.not.i1418
  br i1 %or.cond2048, label %archx_str_concat.exit582, label %dup_heap.i1419

dup_heap.i1419:                                   ; preds = %ret_b_clone.i580
  %dst.i1420 = tail call noalias align 16 ptr @malloc(i64 %blen.i525)
  %isnull.i1421 = icmp eq ptr %dst.i1420, null
  br i1 %isnull.i1421, label %oom.i1428, label %copy.i1422

oom.i1428:                                        ; preds = %dup_heap.i1419
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i1422:                                       ; preds = %dup_heap.i1419
  %src_i.i1423 = and i64 %bw1.i523, -4
  %src.i1424 = inttoptr i64 %src_i.i1423 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1420, ptr nonnull align 4 %src.i1424, i64 %blen.i525, i1 false)
  %dst_i.i1425 = ptrtoint ptr %dst.i1420 to i64
  %tagged.i1426 = or disjoint i64 %dst_i.i1425, 1
  %out.i1427 = insertvalue %ArchxStr %common.ret.op.i.i1401, i64 %tagged.i1426, 1
  br label %archx_str_concat.exit582

chk_bz.i527:                                      ; preds = %archx_str_from_int.exit1410
  %bz.i528 = icmp eq i64 %blen.i525, 0
  br i1 %bz.i528, label %ret_a_clone.i578, label %calc_tot.i529

ret_a_clone.i578:                                 ; preds = %chk_bz.i527
  %long.i1432 = icmp samesign ult i64 %alen.i524, 13
  %tag.i1436 = and i64 %aw1.i521, 3
  %owned.not.i1437 = icmp eq i64 %tag.i1436, 0
  %or.cond2049 = select i1 %long.i1432, i1 true, i1 %owned.not.i1437
  br i1 %or.cond2049, label %archx_str_concat.exit582, label %dup_heap.i1438

dup_heap.i1438:                                   ; preds = %ret_a_clone.i578
  %dst.i1439 = tail call noalias align 16 ptr @malloc(i64 %alen.i524)
  %isnull.i1440 = icmp eq ptr %dst.i1439, null
  br i1 %isnull.i1440, label %oom.i1447, label %copy.i1441

oom.i1447:                                        ; preds = %dup_heap.i1438
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i1441:                                       ; preds = %dup_heap.i1438
  %src_i.i1442 = and i64 %aw1.i521, -4
  %src.i1443 = inttoptr i64 %src_i.i1442 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1439, ptr nonnull align 4 %src.i1443, i64 %alen.i524, i1 false)
  %dst_i.i1444 = ptrtoint ptr %dst.i1439 to i64
  %tagged.i1445 = or disjoint i64 %dst_i.i1444, 1
  %out.i1446 = insertvalue %ArchxStr %common.ret.op.i499, i64 %tagged.i1445, 1
  br label %archx_str_concat.exit582

calc_tot.i529:                                    ; preds = %chk_bz.i527
  %tot.i530 = add nuw nsw i64 %blen.i525, %alen.i524
  %too_big.i531 = icmp samesign ugt i64 %tot.i530, 2147483647
  br i1 %too_big.i531, label %oom.i560, label %mat_a.i532

oom.i560:                                         ; preds = %alloc_heap.i546, %calc_tot.i529
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i532:                                       ; preds = %calc_tot.i529
  %ashort.i533 = icmp samesign ult i64 %alen.i524, 13
  br i1 %ashort.i533, label %mat_a_short.i574, label %mat_a_long.i534

mat_a_short.i574:                                 ; preds = %mat_a.i532
  %ap4.i575 = lshr i64 %aw0.i520, 32
  %ap4_32.i576 = trunc nuw i64 %ap4.i575 to i32
  store i32 %ap4_32.i576, ptr %atmp.i517, align 4
  %atmp4.i577 = getelementptr inbounds nuw i8, ptr %atmp.i517, i64 4
  store i64 %aw1.i521, ptr %atmp4.i577, align 4
  br label %mat_b.i537

mat_a_long.i534:                                  ; preds = %mat_a.i532
  %araw.i535 = and i64 %aw1.i521, -4
  %alptr.i536 = inttoptr i64 %araw.i535 to ptr
  br label %mat_b.i537

mat_b.i537:                                       ; preds = %mat_a_long.i534, %mat_a_short.i574
  %aptr.i538 = phi ptr [ %atmp.i517, %mat_a_short.i574 ], [ %alptr.i536, %mat_a_long.i534 ]
  %bshort.i539 = icmp samesign ult i64 %blen.i525, 13
  br i1 %bshort.i539, label %mat_b_short.i570, label %mat_b_long.i540

mat_b_short.i570:                                 ; preds = %mat_b.i537
  %bp4.i571 = lshr i64 %bw0.i522, 32
  %bp4_32.i572 = trunc nuw i64 %bp4.i571 to i32
  store i32 %bp4_32.i572, ptr %btmp.i518, align 4
  %btmp4.i573 = getelementptr inbounds nuw i8, ptr %btmp.i518, i64 4
  store i64 %bw1.i523, ptr %btmp4.i573, align 4
  br label %build.i543

mat_b_long.i540:                                  ; preds = %mat_b.i537
  %braw.i541 = and i64 %bw1.i523, -4
  %blptr.i542 = inttoptr i64 %braw.i541 to ptr
  br label %build.i543

build.i543:                                       ; preds = %mat_b_long.i540, %mat_b_short.i570
  %bptr.i544 = phi ptr [ %btmp.i518, %mat_b_short.i570 ], [ %blptr.i542, %mat_b_long.i540 ]
  %fits_sso.i545 = icmp samesign ult i64 %tot.i530, 13
  br i1 %fits_sso.i545, label %build_sso.i561, label %alloc_heap.i546

build_sso.i561:                                   ; preds = %build.i543
  %out_sso8.i562 = getelementptr inbounds nuw i8, ptr %out_sso.i519, i64 8
  %tot32.i563 = trunc nuw nsw i64 %tot.i530 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i519, i8 0, i64 16, i1 false)
  store i32 %tot32.i563, ptr %out_sso.i519, align 8
  %sso_dst_a.i564 = getelementptr inbounds nuw i8, ptr %out_sso.i519, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i564, ptr nonnull align 1 %aptr.i538, i64 %alen.i524, i1 false)
  %sso_dst_b.i565 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i564, i64 %alen.i524
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i565, ptr nonnull align 1 %bptr.i544, i64 %blen.i525, i1 false)
  %rw0.i566 = load i64, ptr %out_sso.i519, align 8
  %rw1.i567 = load i64, ptr %out_sso8.i562, align 8
  %rs0.i568 = insertvalue %ArchxStr poison, i64 %rw0.i566, 0
  %rs1.i569 = insertvalue %ArchxStr %rs0.i568, i64 %rw1.i567, 1
  br label %archx_str_concat.exit582

alloc_heap.i546:                                  ; preds = %build.i543
  %hp.i547 = tail call noalias align 16 ptr @malloc(i64 %tot.i530)
  %hnull.i548 = icmp eq ptr %hp.i547, null
  br i1 %hnull.i548, label %oom.i560, label %copy_long.i549

copy_long.i549:                                   ; preds = %alloc_heap.i546
  %hp_i.i550 = ptrtoint ptr %hp.i547 to i64
  %htagged.i551 = or disjoint i64 %hp_i.i550, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i547, ptr nonnull align 1 %aptr.i538, i64 %alen.i524, i1 false)
  %dst_b.i552 = getelementptr inbounds nuw i8, ptr %hp.i547, i64 %alen.i524
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i552, ptr nonnull align 1 %bptr.i544, i64 %blen.i525, i1 false)
  %pref32.i553 = load i32, ptr %hp.i547, align 16
  %pref64.i554 = zext i32 %pref32.i553 to i64
  %pref_sh.i555 = shl nuw i64 %pref64.i554, 32
  %w0_out.i556 = or disjoint i64 %pref_sh.i555, %tot.i530
  %ls0.i557 = insertvalue %ArchxStr poison, i64 %w0_out.i556, 0
  %ls1.i558 = insertvalue %ArchxStr %ls0.i557, i64 %htagged.i551, 1
  br label %archx_str_concat.exit582

archx_str_concat.exit582:                         ; preds = %copy.i1441, %ret_a_clone.i578, %copy.i1422, %ret_b_clone.i580, %build_sso.i561, %copy_long.i549
  %common.ret.op.i559 = phi %ArchxStr [ %rs1.i569, %build_sso.i561 ], [ %ls1.i558, %copy_long.i549 ], [ %out.i1427, %copy.i1422 ], [ %common.ret.op.i.i1401, %ret_b_clone.i580 ], [ %out.i1446, %copy.i1441 ], [ %common.ret.op.i499, %ret_a_clone.i578 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i517)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i518)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i519)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  %w0.i1449 = extractvalue %ArchxStr %common.ret.op.i559, 0
  %w1.i1450 = extractvalue %ArchxStr %common.ret.op.i559, 1
  %len.i1451 = and i64 %w0.i1449, 4294967295
  %short.i = icmp samesign ult i64 %len.i1451, 13
  br i1 %short.i, label %emit.i, label %emit.thread.i

emit.thread.i:                                    ; preds = %archx_str_concat.exit582
  %raw.i1452 = and i64 %w1.i1450, -4
  %lptr.i = inttoptr i64 %raw.i1452 to ptr
  br label %chk_nul.i

emit.i:                                           ; preds = %archx_str_concat.exit582
  %p4.i = lshr i64 %w0.i1449, 32
  %p4_32.i = trunc nuw i64 %p4.i to i32
  store i32 %p4_32.i, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 %w1.i1450, ptr %tmp4.i, align 4
  %pos.not.i = icmp eq i64 %len.i1451, 0
  br i1 %pos.not.i, label %do_nl.i, label %chk_nul.i

chk_nul.i:                                        ; preds = %emit.i, %emit.thread.i
  %data3.i = phi ptr [ %lptr.i, %emit.thread.i ], [ %tmp.i, %emit.i ]
  %nul.i = call ptr @memchr(ptr nonnull %data3.i, i32 0, i64 %len.i1451)
  %has_nul.not.i = icmp eq ptr %nul.i, null
  br i1 %has_nul.not.i, label %fast_printf.i, label %byte_loop.i

fast_printf.i:                                    ; preds = %chk_nul.i
  %len32.i = trunc i64 %w0.i1449 to i32
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i, ptr nonnull %data3.i)
  br label %archx_str_print.exit

byte_loop.i:                                      ; preds = %chk_nul.i, %byte_loop.i
  %bi.i = phi i64 [ %bnext.i, %byte_loop.i ], [ 0, %chk_nul.i ]
  %bp.i = getelementptr inbounds nuw i8, ptr %data3.i, i64 %bi.i
  %ch8.i = load i8, ptr %bp.i, align 1
  %ch32.i = zext i8 %ch8.i to i32
  %pc.i = tail call i32 @putchar(i32 %ch32.i)
  %bnext.i = add nuw nsw i64 %bi.i, 1
  %exitcond.not.i = icmp eq i64 %bnext.i, %len.i1451
  br i1 %exitcond.not.i, label %do_nl.i, label %byte_loop.i

do_nl.i:                                          ; preds = %byte_loop.i, %emit.i
  %nc.i = tail call i32 @putchar(i32 10)
  br label %archx_str_print.exit

archx_str_print.exit:                             ; preds = %fast_printf.i, %do_nl.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %tag.i = and i64 %w1.i1450, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond2050 = select i1 %short.i, i1 true, i1 %owned.not.i
  br i1 %or.cond2050, label %archx_str_drop.exit, label %do_free.i

do_free.i:                                        ; preds = %archx_str_print.exit
  %raw.i = and i64 %w1.i1450, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  call void @free(ptr %ptr.i)
  br label %archx_str_drop.exit

archx_str_drop.exit:                              ; preds = %archx_str_print.exit, %do_free.i
  %long.i64 = icmp samesign ult i64 %blen.i525, 13
  %tag.i67 = and i64 %bw1.i523, 1
  %owned.not.i68 = icmp eq i64 %tag.i67, 0
  %or.cond2051 = select i1 %long.i64, i1 true, i1 %owned.not.i68
  br i1 %or.cond2051, label %archx_str_drop.exit72, label %do_free.i69

do_free.i69:                                      ; preds = %archx_str_drop.exit
  %raw.i70 = and i64 %bw1.i523, -2
  %ptr.i71 = inttoptr i64 %raw.i70 to ptr
  call void @free(ptr %ptr.i71)
  br label %archx_str_drop.exit72

archx_str_drop.exit72:                            ; preds = %archx_str_drop.exit, %do_free.i69
  %long.i75 = icmp samesign ult i64 %alen.i524, 13
  %tag.i78 = and i64 %aw1.i521, 1
  %owned.not.i79 = icmp eq i64 %tag.i78, 0
  %or.cond2052 = select i1 %long.i75, i1 true, i1 %owned.not.i79
  br i1 %or.cond2052, label %archx_str_drop.exit83, label %do_free.i80

do_free.i80:                                      ; preds = %archx_str_drop.exit72
  %raw.i81 = and i64 %aw1.i521, -2
  %ptr.i82 = inttoptr i64 %raw.i81 to ptr
  call void @free(ptr %ptr.i82)
  br label %archx_str_drop.exit83

archx_str_drop.exit83:                            ; preds = %archx_str_drop.exit72, %do_free.i80
  %long.i86 = icmp samesign ult i64 %alen.i468, 13
  %tag.i89 = and i64 %aw1.i467, 1
  %owned.not.i90 = icmp eq i64 %tag.i89, 0
  %or.cond2053 = select i1 %long.i86, i1 true, i1 %owned.not.i90
  br i1 %or.cond2053, label %archx_str_drop.exit94, label %do_free.i91

do_free.i91:                                      ; preds = %archx_str_drop.exit83
  %raw.i92 = and i64 %aw1.i467, -2
  %ptr.i93 = inttoptr i64 %raw.i92 to ptr
  call void @free(ptr %ptr.i93)
  br label %archx_str_drop.exit94

archx_str_drop.exit94:                            ; preds = %archx_str_drop.exit83, %do_free.i91
  %long.i97 = icmp samesign ult i64 %blen.i405, 13
  %tag.i100 = and i64 %bw1.i403, 1
  %owned.not.i101 = icmp eq i64 %tag.i100, 0
  %or.cond2054 = select i1 %long.i97, i1 true, i1 %owned.not.i101
  br i1 %or.cond2054, label %archx_str_drop.exit105, label %do_free.i102

do_free.i102:                                     ; preds = %archx_str_drop.exit94
  %raw.i103 = and i64 %bw1.i403, -2
  %ptr.i104 = inttoptr i64 %raw.i103 to ptr
  call void @free(ptr %ptr.i104)
  br label %archx_str_drop.exit105

archx_str_drop.exit105:                           ; preds = %archx_str_drop.exit94, %do_free.i102
  %long.i108 = icmp samesign ult i64 %alen.i404, 13
  %tag.i111 = and i64 %aw1.i401, 1
  %owned.not.i112 = icmp eq i64 %tag.i111, 0
  %or.cond2055 = select i1 %long.i108, i1 true, i1 %owned.not.i112
  br i1 %or.cond2055, label %archx_str_drop.exit116, label %do_free.i113

do_free.i113:                                     ; preds = %archx_str_drop.exit105
  %raw.i114 = and i64 %aw1.i401, -2
  %ptr.i115 = inttoptr i64 %raw.i114 to ptr
  call void @free(ptr %ptr.i115)
  br label %archx_str_drop.exit116

archx_str_drop.exit116:                           ; preds = %archx_str_drop.exit105, %do_free.i113
  %long.i119 = icmp samesign ult i64 %alen.i, 13
  %tag.i122 = and i64 %aw1.i, 1
  %owned.not.i123 = icmp eq i64 %tag.i122, 0
  %or.cond2056 = select i1 %long.i119, i1 true, i1 %owned.not.i123
  br i1 %or.cond2056, label %archx_str_drop.exit127, label %do_free.i124

do_free.i124:                                     ; preds = %archx_str_drop.exit116
  %raw.i125 = and i64 %aw1.i, -2
  %ptr.i126 = inttoptr i64 %raw.i125 to ptr
  call void @free(ptr %ptr.i126)
  br label %archx_str_drop.exit127

archx_str_drop.exit127:                           ; preds = %archx_str_drop.exit116, %do_free.i124
  %long.i130 = icmp samesign ult i64 %blen.i, 13
  %tag.i133 = and i64 %bw1.i, 1
  %owned.not.i134 = icmp eq i64 %tag.i133, 0
  %or.cond2057 = select i1 %long.i130, i1 true, i1 %owned.not.i134
  br i1 %or.cond2057, label %archx_str_drop.exit138, label %do_free.i135

do_free.i135:                                     ; preds = %archx_str_drop.exit127
  %raw.i136 = and i64 %bw1.i, -2
  %ptr.i137 = inttoptr i64 %raw.i136 to ptr
  call void @free(ptr %ptr.i137)
  br label %archx_str_drop.exit138

archx_str_drop.exit138:                           ; preds = %archx_str_drop.exit127, %do_free.i135
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1454)
  %n32.i1455 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1454, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 99)
  %len.i1456 = sext i32 %n32.i1455 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1453)
  %z.i.i1457 = icmp slt i32 %n32.i1455, 1
  br i1 %z.i.i1457, label %archx_str_from_int.exit1481, label %chk_sso.i.i1458

oom.i.i1473:                                      ; preds = %alloc_heap.i.i1460
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1458:                                  ; preds = %archx_str_drop.exit138
  %short.i.i1459 = icmp samesign ult i32 %n32.i1455, 13
  br i1 %short.i.i1459, label %pack_sso.i.i1474, label %alloc_heap.i.i1460

pack_sso.i.i1474:                                 ; preds = %chk_sso.i.i1458
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1453, i8 0, i64 16, i1 false)
  store i32 %n32.i1455, ptr %sso.i.i1453, align 8
  %sso.i.i1453.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1453, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1453.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1454, i64 range(i64 -2147483648, 2147483650) %len.i1456, i1 false)
  %sso.i.i1453.0.sso.i.i1453.0.sso.i.i1453.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1476 = load i64, ptr %sso.i.i1453, align 8
  %sso.i.i1453.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1453, i64 8
  %sso.i.i1453.8.sso.i.i1453.8.sso.i.i1453.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1478 = load i64, ptr %sso.i.i1453.8.sroa_idx, align 8
  %ss0.i.i1479 = insertvalue %ArchxStr poison, i64 %sso.i.i1453.0.sso.i.i1453.0.sso.i.i1453.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1476, 0
  %ss1.i.i1480 = insertvalue %ArchxStr %ss0.i.i1479, i64 %sso.i.i1453.8.sso.i.i1453.8.sso.i.i1453.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1478, 1
  br label %archx_str_from_int.exit1481

alloc_heap.i.i1460:                               ; preds = %chk_sso.i.i1458
  %hp.i.i1461 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1456)
  %hnull.i.i1462 = icmp eq ptr %hp.i.i1461, null
  br i1 %hnull.i.i1462, label %oom.i.i1473, label %copy_long.i.i1463

copy_long.i.i1463:                                ; preds = %alloc_heap.i.i1460
  %hp_i.i.i1464 = ptrtoint ptr %hp.i.i1461 to i64
  %htagged.i.i1465 = or disjoint i64 %hp_i.i.i1464, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1461, ptr nonnull readonly align 8 %buf.i1454, i64 range(i64 -2147483648, 2147483650) %len.i1456, i1 false)
  %pref32.i.i1466 = load i32, ptr %hp.i.i1461, align 16
  %pref64.i.i1467 = zext i32 %pref32.i.i1466 to i64
  %pref_sh.i.i1468 = shl nuw i64 %pref64.i.i1467, 32
  %w0_out.i.i1469 = or disjoint i64 %pref_sh.i.i1468, %len.i1456
  %ls0.i.i1470 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1469, 0
  %ls1.i.i1471 = insertvalue %ArchxStr %ls0.i.i1470, i64 %htagged.i.i1465, 1
  br label %archx_str_from_int.exit1481

archx_str_from_int.exit1481:                      ; preds = %archx_str_drop.exit138, %pack_sso.i.i1474, %copy_long.i.i1463
  %common.ret.op.i.i1472 = phi %ArchxStr [ %ss1.i.i1480, %pack_sso.i.i1474 ], [ %ls1.i.i1471, %copy_long.i.i1463 ], [ zeroinitializer, %archx_str_drop.exit138 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1453)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1454)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i584)
  %bw0.i586 = extractvalue %ArchxStr %common.ret.op.i.i1472, 0
  %bw1.i587 = extractvalue %ArchxStr %common.ret.op.i.i1472, 1
  %blen.i588 = and i64 %bw0.i586, 4294967295
  %bz.i590 = icmp eq i64 %blen.i588, 0
  br i1 %bz.i590, label %archx_str_concat.exit636, label %calc_tot.i591

calc_tot.i591:                                    ; preds = %archx_str_from_int.exit1481
  %tot.i592 = add nuw nsw i64 %blen.i588, 5
  %too_big.i593 = icmp samesign ugt i64 %blen.i588, 2147483642
  br i1 %too_big.i593, label %oom.i620, label %mat_a.i594

oom.i620:                                         ; preds = %alloc_heap.i606, %calc_tot.i591
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i594:                                       ; preds = %calc_tot.i591
  %bshort.i599 = icmp samesign ult i64 %blen.i588, 13
  br i1 %bshort.i599, label %build.i603, label %build.i603.thread

build.i603.thread:                                ; preds = %mat_a.i594
  %braw.i601 = and i64 %bw1.i587, -4
  %blptr.i602 = inttoptr i64 %braw.i601 to ptr
  br label %alloc_heap.i606

build.i603:                                       ; preds = %mat_a.i594
  %bp4.i631 = lshr i64 %bw0.i586, 32
  %bp4_32.i632 = trunc nuw i64 %bp4.i631 to i32
  store i32 %bp4_32.i632, ptr %btmp.i584, align 4
  %btmp4.i633 = getelementptr inbounds nuw i8, ptr %btmp.i584, i64 4
  store i64 %bw1.i587, ptr %btmp4.i633, align 4
  %fits_sso.i605 = icmp samesign ult i64 %blen.i588, 8
  br i1 %fits_sso.i605, label %build_sso.i621, label %alloc_heap.i606

build_sso.i621:                                   ; preds = %build.i603
  store i56 0, ptr %out_sso.i585.sroa.6.sroa.5.sroa.0, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i585.sroa.6.sroa.5.sroa.0, ptr nonnull align 4 %btmp.i584, i64 %blen.i588, i1 false)
  %out_sso.i585.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i592, 8097884940793806848
  %out_sso.i585.sroa.6.sroa.5.sroa.0.0.out_sso.i585.sroa.6.sroa.5.sroa.0.0.out_sso.i585.sroa.6.sroa.5.sroa.0.0.out_sso.i585.sroa.6.sroa.5.sroa.0.0.out_sso.i585.sroa.6.sroa.5.0.out_sso.i585.sroa.6.8.rw1.i627 = load i56, ptr %out_sso.i585.sroa.6.sroa.5.sroa.0, align 8
  %out_sso.i585.sroa.6.sroa.5.0.insert.ext = zext i56 %out_sso.i585.sroa.6.sroa.5.sroa.0.0.out_sso.i585.sroa.6.sroa.5.sroa.0.0.out_sso.i585.sroa.6.sroa.5.sroa.0.0.out_sso.i585.sroa.6.sroa.5.sroa.0.0.out_sso.i585.sroa.6.sroa.5.0.out_sso.i585.sroa.6.8.rw1.i627 to i64
  %out_sso.i585.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i585.sroa.6.sroa.5.0.insert.ext, 8
  %out_sso.i585.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i585.sroa.6.sroa.5.0.insert.shift, 61
  %rs0.i628 = insertvalue %ArchxStr poison, i64 %out_sso.i585.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i629 = insertvalue %ArchxStr %rs0.i628, i64 %out_sso.i585.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit636

alloc_heap.i606:                                  ; preds = %build.i603.thread, %build.i603
  %bptr.i6042186 = phi ptr [ %blptr.i602, %build.i603.thread ], [ %btmp.i584, %build.i603 ]
  %hp.i607 = call noalias align 16 ptr @malloc(i64 %tot.i592)
  %hnull.i608 = icmp eq ptr %hp.i607, null
  br i1 %hnull.i608, label %oom.i620, label %copy_long.i609

copy_long.i609:                                   ; preds = %alloc_heap.i606
  %hp_i.i610 = ptrtoint ptr %hp.i607 to i64
  %htagged.i611 = or disjoint i64 %hp_i.i610, 1
  store i32 1885435763, ptr %hp.i607, align 16
  %atmp.i583.sroa.5.0.hp.i607.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i607, i64 4
  store i8 61, ptr %atmp.i583.sroa.5.0.hp.i607.sroa_idx, align 4
  %dst_b.i612 = getelementptr inbounds nuw i8, ptr %hp.i607, i64 5
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i612, ptr nonnull align 1 %bptr.i6042186, i64 %blen.i588, i1 false)
  %w0_out.i616 = or disjoint i64 %tot.i592, 8097884940793806848
  %ls0.i617 = insertvalue %ArchxStr poison, i64 %w0_out.i616, 0
  %ls1.i618 = insertvalue %ArchxStr %ls0.i617, i64 %htagged.i611, 1
  br label %archx_str_concat.exit636

archx_str_concat.exit636:                         ; preds = %archx_str_from_int.exit1481, %build_sso.i621, %copy_long.i609
  %common.ret.op.i619 = phi %ArchxStr [ %rs1.i629, %build_sso.i621 ], [ %ls1.i618, %copy_long.i609 ], [ { i64 8097884940793806853, i64 61 }, %archx_str_from_int.exit1481 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i584)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i637)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i639)
  %aw0.i640 = extractvalue %ArchxStr %common.ret.op.i619, 0
  %aw1.i641 = extractvalue %ArchxStr %common.ret.op.i619, 1
  %alen.i642 = and i64 %aw0.i640, 4294967295
  %az.i643 = icmp eq i64 %alen.i642, 0
  br i1 %az.i643, label %archx_str_concat.exit690, label %chk_bz.i644

chk_bz.i644:                                      ; preds = %archx_str_concat.exit636
  %tot.i646 = add nuw nsw i64 %alen.i642, 1
  %too_big.i647 = icmp samesign ugt i64 %alen.i642, 2147483646
  br i1 %too_big.i647, label %oom.i674, label %mat_a.i648

oom.i674:                                         ; preds = %alloc_heap.i660, %chk_bz.i644
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i648:                                       ; preds = %chk_bz.i644
  %ashort.i649 = icmp samesign ult i64 %alen.i642, 13
  br i1 %ashort.i649, label %mat_b.i653, label %mat_b.i653.thread

mat_b.i653.thread:                                ; preds = %mat_a.i648
  %araw.i651 = and i64 %aw1.i641, -4
  %alptr.i652 = inttoptr i64 %araw.i651 to ptr
  br label %alloc_heap.i660

mat_b.i653:                                       ; preds = %mat_a.i648
  %ap4.i685 = lshr i64 %aw0.i640, 32
  %ap4_32.i686 = trunc nuw i64 %ap4.i685 to i32
  store i32 %ap4_32.i686, ptr %atmp.i637, align 4
  %atmp4.i687 = getelementptr inbounds nuw i8, ptr %atmp.i637, i64 4
  store i64 %aw1.i641, ptr %atmp4.i687, align 4
  %fits_sso.i659.not = icmp eq i64 %alen.i642, 12
  br i1 %fits_sso.i659.not, label %alloc_heap.i660, label %build_sso.i675

build_sso.i675:                                   ; preds = %mat_b.i653
  %out_sso8.i676 = getelementptr inbounds nuw i8, ptr %out_sso.i639, i64 8
  %tot32.i677 = trunc nuw nsw i64 %tot.i646 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i639, i8 0, i64 16, i1 false)
  store i32 %tot32.i677, ptr %out_sso.i639, align 8
  %sso_dst_a.i678 = getelementptr inbounds nuw i8, ptr %out_sso.i639, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i678, ptr nonnull align 4 %atmp.i637, i64 %alen.i642, i1 false)
  %sso_dst_b.i679 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i678, i64 %alen.i642
  store i8 44, ptr %sso_dst_b.i679, align 1
  %rw0.i680 = load i64, ptr %out_sso.i639, align 8
  %rw1.i681 = load i64, ptr %out_sso8.i676, align 8
  %rs0.i682 = insertvalue %ArchxStr poison, i64 %rw0.i680, 0
  %rs1.i683 = insertvalue %ArchxStr %rs0.i682, i64 %rw1.i681, 1
  br label %archx_str_concat.exit690

alloc_heap.i660:                                  ; preds = %mat_b.i653.thread, %mat_b.i653
  %aptr.i6541972 = phi ptr [ %alptr.i652, %mat_b.i653.thread ], [ %atmp.i637, %mat_b.i653 ]
  %hp.i661 = call noalias align 16 ptr @malloc(i64 %tot.i646)
  %hnull.i662 = icmp eq ptr %hp.i661, null
  br i1 %hnull.i662, label %oom.i674, label %copy_long.i663

copy_long.i663:                                   ; preds = %alloc_heap.i660
  %hp_i.i664 = ptrtoint ptr %hp.i661 to i64
  %htagged.i665 = or disjoint i64 %hp_i.i664, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i661, ptr nonnull align 1 %aptr.i6541972, i64 %alen.i642, i1 false)
  %dst_b.i666 = getelementptr inbounds nuw i8, ptr %hp.i661, i64 %alen.i642
  store i8 44, ptr %dst_b.i666, align 1
  %pref32.i667 = load i32, ptr %hp.i661, align 16
  %pref64.i668 = zext i32 %pref32.i667 to i64
  %pref_sh.i669 = shl nuw i64 %pref64.i668, 32
  %w0_out.i670 = or disjoint i64 %pref_sh.i669, %tot.i646
  %ls0.i671 = insertvalue %ArchxStr poison, i64 %w0_out.i670, 0
  %ls1.i672 = insertvalue %ArchxStr %ls0.i671, i64 %htagged.i665, 1
  br label %archx_str_concat.exit690

archx_str_concat.exit690:                         ; preds = %archx_str_concat.exit636, %build_sso.i675, %copy_long.i663
  %common.ret.op.i673 = phi %ArchxStr [ %rs1.i683, %build_sso.i675 ], [ %ls1.i672, %copy_long.i663 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit636 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i637)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i639)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1485)
  %n32.i1486 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1485, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 10)
  %len.i1487 = sext i32 %n32.i1486 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1484)
  %z.i.i1488 = icmp slt i32 %n32.i1486, 1
  br i1 %z.i.i1488, label %archx_str_from_int.exit1512, label %chk_sso.i.i1489

oom.i.i1504:                                      ; preds = %alloc_heap.i.i1491
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1489:                                  ; preds = %archx_str_concat.exit690
  %short.i.i1490 = icmp samesign ult i32 %n32.i1486, 13
  br i1 %short.i.i1490, label %pack_sso.i.i1505, label %alloc_heap.i.i1491

pack_sso.i.i1505:                                 ; preds = %chk_sso.i.i1489
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1484, i8 0, i64 16, i1 false)
  store i32 %n32.i1486, ptr %sso.i.i1484, align 8
  %sso.i.i1484.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1484, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1484.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1485, i64 range(i64 -2147483648, 2147483650) %len.i1487, i1 false)
  %sso.i.i1484.0.sso.i.i1484.0.sso.i.i1484.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1507 = load i64, ptr %sso.i.i1484, align 8
  %sso.i.i1484.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1484, i64 8
  %sso.i.i1484.8.sso.i.i1484.8.sso.i.i1484.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1509 = load i64, ptr %sso.i.i1484.8.sroa_idx, align 8
  %ss0.i.i1510 = insertvalue %ArchxStr poison, i64 %sso.i.i1484.0.sso.i.i1484.0.sso.i.i1484.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1507, 0
  %ss1.i.i1511 = insertvalue %ArchxStr %ss0.i.i1510, i64 %sso.i.i1484.8.sso.i.i1484.8.sso.i.i1484.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1509, 1
  br label %archx_str_from_int.exit1512

alloc_heap.i.i1491:                               ; preds = %chk_sso.i.i1489
  %hp.i.i1492 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1487)
  %hnull.i.i1493 = icmp eq ptr %hp.i.i1492, null
  br i1 %hnull.i.i1493, label %oom.i.i1504, label %copy_long.i.i1494

copy_long.i.i1494:                                ; preds = %alloc_heap.i.i1491
  %hp_i.i.i1495 = ptrtoint ptr %hp.i.i1492 to i64
  %htagged.i.i1496 = or disjoint i64 %hp_i.i.i1495, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1492, ptr nonnull readonly align 8 %buf.i1485, i64 range(i64 -2147483648, 2147483650) %len.i1487, i1 false)
  %pref32.i.i1497 = load i32, ptr %hp.i.i1492, align 16
  %pref64.i.i1498 = zext i32 %pref32.i.i1497 to i64
  %pref_sh.i.i1499 = shl nuw i64 %pref64.i.i1498, 32
  %w0_out.i.i1500 = or disjoint i64 %pref_sh.i.i1499, %len.i1487
  %ls0.i.i1501 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1500, 0
  %ls1.i.i1502 = insertvalue %ArchxStr %ls0.i.i1501, i64 %htagged.i.i1496, 1
  br label %archx_str_from_int.exit1512

archx_str_from_int.exit1512:                      ; preds = %archx_str_concat.exit690, %pack_sso.i.i1505, %copy_long.i.i1494
  %common.ret.op.i.i1503 = phi %ArchxStr [ %ss1.i.i1511, %pack_sso.i.i1505 ], [ %ls1.i.i1502, %copy_long.i.i1494 ], [ zeroinitializer, %archx_str_concat.exit690 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1484)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1485)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i691)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i692)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i693)
  %aw0.i694 = extractvalue %ArchxStr %common.ret.op.i673, 0
  %aw1.i695 = extractvalue %ArchxStr %common.ret.op.i673, 1
  %bw0.i696 = extractvalue %ArchxStr %common.ret.op.i.i1503, 0
  %bw1.i697 = extractvalue %ArchxStr %common.ret.op.i.i1503, 1
  %alen.i698 = and i64 %aw0.i694, 4294967295
  %blen.i699 = and i64 %bw0.i696, 4294967295
  %az.i700 = icmp eq i64 %alen.i698, 0
  br i1 %az.i700, label %ret_b_clone.i754, label %chk_bz.i701

ret_b_clone.i754:                                 ; preds = %archx_str_from_int.exit1512
  %long.i1515 = icmp samesign ult i64 %blen.i699, 13
  %tag.i1519 = and i64 %bw1.i697, 3
  %owned.not.i1520 = icmp eq i64 %tag.i1519, 0
  %or.cond2058 = select i1 %long.i1515, i1 true, i1 %owned.not.i1520
  br i1 %or.cond2058, label %archx_str_concat.exit756, label %dup_heap.i1521

dup_heap.i1521:                                   ; preds = %ret_b_clone.i754
  %dst.i1522 = call noalias align 16 ptr @malloc(i64 %blen.i699)
  %isnull.i1523 = icmp eq ptr %dst.i1522, null
  br i1 %isnull.i1523, label %oom.i1530, label %copy.i1524

oom.i1530:                                        ; preds = %dup_heap.i1521
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1524:                                       ; preds = %dup_heap.i1521
  %src_i.i1525 = and i64 %bw1.i697, -4
  %src.i1526 = inttoptr i64 %src_i.i1525 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1522, ptr nonnull align 4 %src.i1526, i64 %blen.i699, i1 false)
  %dst_i.i1527 = ptrtoint ptr %dst.i1522 to i64
  %tagged.i1528 = or disjoint i64 %dst_i.i1527, 1
  %out.i1529 = insertvalue %ArchxStr %common.ret.op.i.i1503, i64 %tagged.i1528, 1
  br label %archx_str_concat.exit756

chk_bz.i701:                                      ; preds = %archx_str_from_int.exit1512
  %bz.i702 = icmp eq i64 %blen.i699, 0
  br i1 %bz.i702, label %ret_a_clone.i752, label %calc_tot.i703

ret_a_clone.i752:                                 ; preds = %chk_bz.i701
  %long.i1534 = icmp samesign ult i64 %alen.i698, 13
  %tag.i1538 = and i64 %aw1.i695, 3
  %owned.not.i1539 = icmp eq i64 %tag.i1538, 0
  %or.cond2059 = select i1 %long.i1534, i1 true, i1 %owned.not.i1539
  br i1 %or.cond2059, label %archx_str_concat.exit756, label %dup_heap.i1540

dup_heap.i1540:                                   ; preds = %ret_a_clone.i752
  %dst.i1541 = call noalias align 16 ptr @malloc(i64 %alen.i698)
  %isnull.i1542 = icmp eq ptr %dst.i1541, null
  br i1 %isnull.i1542, label %oom.i1549, label %copy.i1543

oom.i1549:                                        ; preds = %dup_heap.i1540
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1543:                                       ; preds = %dup_heap.i1540
  %src_i.i1544 = and i64 %aw1.i695, -4
  %src.i1545 = inttoptr i64 %src_i.i1544 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1541, ptr nonnull align 4 %src.i1545, i64 %alen.i698, i1 false)
  %dst_i.i1546 = ptrtoint ptr %dst.i1541 to i64
  %tagged.i1547 = or disjoint i64 %dst_i.i1546, 1
  %out.i1548 = insertvalue %ArchxStr %common.ret.op.i673, i64 %tagged.i1547, 1
  br label %archx_str_concat.exit756

calc_tot.i703:                                    ; preds = %chk_bz.i701
  %tot.i704 = add nuw nsw i64 %blen.i699, %alen.i698
  %too_big.i705 = icmp samesign ugt i64 %tot.i704, 2147483647
  br i1 %too_big.i705, label %oom.i734, label %mat_a.i706

oom.i734:                                         ; preds = %alloc_heap.i720, %calc_tot.i703
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i706:                                       ; preds = %calc_tot.i703
  %ashort.i707 = icmp samesign ult i64 %alen.i698, 13
  br i1 %ashort.i707, label %mat_a_short.i748, label %mat_a_long.i708

mat_a_short.i748:                                 ; preds = %mat_a.i706
  %ap4.i749 = lshr i64 %aw0.i694, 32
  %ap4_32.i750 = trunc nuw i64 %ap4.i749 to i32
  store i32 %ap4_32.i750, ptr %atmp.i691, align 4
  %atmp4.i751 = getelementptr inbounds nuw i8, ptr %atmp.i691, i64 4
  store i64 %aw1.i695, ptr %atmp4.i751, align 4
  br label %mat_b.i711

mat_a_long.i708:                                  ; preds = %mat_a.i706
  %araw.i709 = and i64 %aw1.i695, -4
  %alptr.i710 = inttoptr i64 %araw.i709 to ptr
  br label %mat_b.i711

mat_b.i711:                                       ; preds = %mat_a_long.i708, %mat_a_short.i748
  %aptr.i712 = phi ptr [ %atmp.i691, %mat_a_short.i748 ], [ %alptr.i710, %mat_a_long.i708 ]
  %bshort.i713 = icmp samesign ult i64 %blen.i699, 13
  br i1 %bshort.i713, label %mat_b_short.i744, label %mat_b_long.i714

mat_b_short.i744:                                 ; preds = %mat_b.i711
  %bp4.i745 = lshr i64 %bw0.i696, 32
  %bp4_32.i746 = trunc nuw i64 %bp4.i745 to i32
  store i32 %bp4_32.i746, ptr %btmp.i692, align 4
  %btmp4.i747 = getelementptr inbounds nuw i8, ptr %btmp.i692, i64 4
  store i64 %bw1.i697, ptr %btmp4.i747, align 4
  br label %build.i717

mat_b_long.i714:                                  ; preds = %mat_b.i711
  %braw.i715 = and i64 %bw1.i697, -4
  %blptr.i716 = inttoptr i64 %braw.i715 to ptr
  br label %build.i717

build.i717:                                       ; preds = %mat_b_long.i714, %mat_b_short.i744
  %bptr.i718 = phi ptr [ %btmp.i692, %mat_b_short.i744 ], [ %blptr.i716, %mat_b_long.i714 ]
  %fits_sso.i719 = icmp samesign ult i64 %tot.i704, 13
  br i1 %fits_sso.i719, label %build_sso.i735, label %alloc_heap.i720

build_sso.i735:                                   ; preds = %build.i717
  %out_sso8.i736 = getelementptr inbounds nuw i8, ptr %out_sso.i693, i64 8
  %tot32.i737 = trunc nuw nsw i64 %tot.i704 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i693, i8 0, i64 16, i1 false)
  store i32 %tot32.i737, ptr %out_sso.i693, align 8
  %sso_dst_a.i738 = getelementptr inbounds nuw i8, ptr %out_sso.i693, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i738, ptr nonnull align 1 %aptr.i712, i64 %alen.i698, i1 false)
  %sso_dst_b.i739 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i738, i64 %alen.i698
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i739, ptr nonnull align 1 %bptr.i718, i64 %blen.i699, i1 false)
  %rw0.i740 = load i64, ptr %out_sso.i693, align 8
  %rw1.i741 = load i64, ptr %out_sso8.i736, align 8
  %rs0.i742 = insertvalue %ArchxStr poison, i64 %rw0.i740, 0
  %rs1.i743 = insertvalue %ArchxStr %rs0.i742, i64 %rw1.i741, 1
  br label %archx_str_concat.exit756

alloc_heap.i720:                                  ; preds = %build.i717
  %hp.i721 = call noalias align 16 ptr @malloc(i64 %tot.i704)
  %hnull.i722 = icmp eq ptr %hp.i721, null
  br i1 %hnull.i722, label %oom.i734, label %copy_long.i723

copy_long.i723:                                   ; preds = %alloc_heap.i720
  %hp_i.i724 = ptrtoint ptr %hp.i721 to i64
  %htagged.i725 = or disjoint i64 %hp_i.i724, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i721, ptr nonnull align 1 %aptr.i712, i64 %alen.i698, i1 false)
  %dst_b.i726 = getelementptr inbounds nuw i8, ptr %hp.i721, i64 %alen.i698
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i726, ptr nonnull align 1 %bptr.i718, i64 %blen.i699, i1 false)
  %pref32.i727 = load i32, ptr %hp.i721, align 16
  %pref64.i728 = zext i32 %pref32.i727 to i64
  %pref_sh.i729 = shl nuw i64 %pref64.i728, 32
  %w0_out.i730 = or disjoint i64 %pref_sh.i729, %tot.i704
  %ls0.i731 = insertvalue %ArchxStr poison, i64 %w0_out.i730, 0
  %ls1.i732 = insertvalue %ArchxStr %ls0.i731, i64 %htagged.i725, 1
  br label %archx_str_concat.exit756

archx_str_concat.exit756:                         ; preds = %copy.i1543, %ret_a_clone.i752, %copy.i1524, %ret_b_clone.i754, %build_sso.i735, %copy_long.i723
  %common.ret.op.i733 = phi %ArchxStr [ %rs1.i743, %build_sso.i735 ], [ %ls1.i732, %copy_long.i723 ], [ %out.i1529, %copy.i1524 ], [ %common.ret.op.i.i1503, %ret_b_clone.i754 ], [ %out.i1548, %copy.i1543 ], [ %common.ret.op.i673, %ret_a_clone.i752 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i691)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i692)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i693)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i757)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i759)
  %aw0.i760 = extractvalue %ArchxStr %common.ret.op.i733, 0
  %aw1.i761 = extractvalue %ArchxStr %common.ret.op.i733, 1
  %alen.i762 = and i64 %aw0.i760, 4294967295
  %az.i763 = icmp eq i64 %alen.i762, 0
  br i1 %az.i763, label %archx_str_concat.exit810, label %chk_bz.i764

chk_bz.i764:                                      ; preds = %archx_str_concat.exit756
  %tot.i766 = add nuw nsw i64 %alen.i762, 5
  %too_big.i767 = icmp samesign ugt i64 %alen.i762, 2147483642
  br i1 %too_big.i767, label %oom.i794, label %mat_a.i768

oom.i794:                                         ; preds = %alloc_heap.i780, %chk_bz.i764
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i768:                                       ; preds = %chk_bz.i764
  %ashort.i769 = icmp samesign ult i64 %alen.i762, 13
  br i1 %ashort.i769, label %mat_b.i773, label %mat_b.i773.thread

mat_b.i773.thread:                                ; preds = %mat_a.i768
  %araw.i771 = and i64 %aw1.i761, -4
  %alptr.i772 = inttoptr i64 %araw.i771 to ptr
  br label %alloc_heap.i780

mat_b.i773:                                       ; preds = %mat_a.i768
  %ap4.i805 = lshr i64 %aw0.i760, 32
  %ap4_32.i806 = trunc nuw i64 %ap4.i805 to i32
  store i32 %ap4_32.i806, ptr %atmp.i757, align 4
  %atmp4.i807 = getelementptr inbounds nuw i8, ptr %atmp.i757, i64 4
  store i64 %aw1.i761, ptr %atmp4.i807, align 4
  %fits_sso.i779 = icmp samesign ult i64 %alen.i762, 8
  br i1 %fits_sso.i779, label %build_sso.i795, label %alloc_heap.i780

build_sso.i795:                                   ; preds = %mat_b.i773
  %out_sso8.i796 = getelementptr inbounds nuw i8, ptr %out_sso.i759, i64 8
  %tot32.i797 = trunc nuw nsw i64 %tot.i766 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i759, i8 0, i64 16, i1 false)
  store i32 %tot32.i797, ptr %out_sso.i759, align 8
  %sso_dst_a.i798 = getelementptr inbounds nuw i8, ptr %out_sso.i759, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i798, ptr nonnull align 4 %atmp.i757, i64 %alen.i762, i1 false)
  %sso_dst_b.i799 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i798, i64 %alen.i762
  store i32 1886745632, ptr %sso_dst_b.i799, align 1
  %btmp.i758.sroa.5.0.sso_dst_b.i799.sroa_idx = getelementptr inbounds nuw i8, ptr %sso_dst_b.i799, i64 4
  store i8 61, ptr %btmp.i758.sroa.5.0.sso_dst_b.i799.sroa_idx, align 1
  %rw0.i800 = load i64, ptr %out_sso.i759, align 8
  %rw1.i801 = load i64, ptr %out_sso8.i796, align 8
  %rs0.i802 = insertvalue %ArchxStr poison, i64 %rw0.i800, 0
  %rs1.i803 = insertvalue %ArchxStr %rs0.i802, i64 %rw1.i801, 1
  br label %archx_str_concat.exit810

alloc_heap.i780:                                  ; preds = %mat_b.i773.thread, %mat_b.i773
  %aptr.i7741975 = phi ptr [ %alptr.i772, %mat_b.i773.thread ], [ %atmp.i757, %mat_b.i773 ]
  %hp.i781 = call noalias align 16 ptr @malloc(i64 %tot.i766)
  %hnull.i782 = icmp eq ptr %hp.i781, null
  br i1 %hnull.i782, label %oom.i794, label %copy_long.i783

copy_long.i783:                                   ; preds = %alloc_heap.i780
  %hp_i.i784 = ptrtoint ptr %hp.i781 to i64
  %htagged.i785 = or disjoint i64 %hp_i.i784, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i781, ptr nonnull align 1 %aptr.i7741975, i64 %alen.i762, i1 false)
  %dst_b.i786 = getelementptr inbounds nuw i8, ptr %hp.i781, i64 %alen.i762
  store i32 1886745632, ptr %dst_b.i786, align 1
  %btmp.i758.sroa.5.0.dst_b.i786.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i786, i64 4
  store i8 61, ptr %btmp.i758.sroa.5.0.dst_b.i786.sroa_idx, align 1
  %pref32.i787 = load i32, ptr %hp.i781, align 16
  %pref64.i788 = zext i32 %pref32.i787 to i64
  %pref_sh.i789 = shl nuw i64 %pref64.i788, 32
  %w0_out.i790 = or disjoint i64 %pref_sh.i789, %tot.i766
  %ls0.i791 = insertvalue %ArchxStr poison, i64 %w0_out.i790, 0
  %ls1.i792 = insertvalue %ArchxStr %ls0.i791, i64 %htagged.i785, 1
  br label %archx_str_concat.exit810

archx_str_concat.exit810:                         ; preds = %archx_str_concat.exit756, %build_sso.i795, %copy_long.i783
  %common.ret.op.i793 = phi %ArchxStr [ %rs1.i803, %build_sso.i795 ], [ %ls1.i792, %copy_long.i783 ], [ { i64 8103510785310851077, i64 61 }, %archx_str_concat.exit756 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i757)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i759)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i811)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i813)
  %aw0.i814 = extractvalue %ArchxStr %common.ret.op.i793, 0
  %aw1.i815 = extractvalue %ArchxStr %common.ret.op.i793, 1
  %alen.i816 = and i64 %aw0.i814, 4294967295
  %az.i817 = icmp eq i64 %alen.i816, 0
  br i1 %az.i817, label %archx_str_concat.exit864, label %chk_bz.i818

chk_bz.i818:                                      ; preds = %archx_str_concat.exit810
  %tot.i820 = add nuw nsw i64 %alen.i816, 5
  %too_big.i821 = icmp samesign ugt i64 %alen.i816, 2147483642
  br i1 %too_big.i821, label %oom.i848, label %mat_a.i822

oom.i848:                                         ; preds = %alloc_heap.i834, %chk_bz.i818
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i822:                                       ; preds = %chk_bz.i818
  %ashort.i823 = icmp samesign ult i64 %alen.i816, 13
  br i1 %ashort.i823, label %mat_b.i827, label %mat_b.i827.thread

mat_b.i827.thread:                                ; preds = %mat_a.i822
  %araw.i825 = and i64 %aw1.i815, -4
  %alptr.i826 = inttoptr i64 %araw.i825 to ptr
  br label %alloc_heap.i834

mat_b.i827:                                       ; preds = %mat_a.i822
  %ap4.i859 = lshr i64 %aw0.i814, 32
  %ap4_32.i860 = trunc nuw i64 %ap4.i859 to i32
  store i32 %ap4_32.i860, ptr %atmp.i811, align 4
  %atmp4.i861 = getelementptr inbounds nuw i8, ptr %atmp.i811, i64 4
  store i64 %aw1.i815, ptr %atmp4.i861, align 4
  %fits_sso.i833 = icmp samesign ult i64 %alen.i816, 8
  br i1 %fits_sso.i833, label %build_sso.i849, label %alloc_heap.i834

build_sso.i849:                                   ; preds = %mat_b.i827
  %out_sso8.i850 = getelementptr inbounds nuw i8, ptr %out_sso.i813, i64 8
  %tot32.i851 = trunc nuw nsw i64 %tot.i820 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i813, i8 0, i64 16, i1 false)
  store i32 %tot32.i851, ptr %out_sso.i813, align 8
  %sso_dst_a.i852 = getelementptr inbounds nuw i8, ptr %out_sso.i813, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i852, ptr nonnull align 4 %atmp.i811, i64 %alen.i816, i1 false)
  %sso_dst_b.i853 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i852, i64 %alen.i816
  store i32 1751347809, ptr %sso_dst_b.i853, align 1
  %btmp.i812.sroa.5.0.sso_dst_b.i853.sroa_idx = getelementptr inbounds nuw i8, ptr %sso_dst_b.i853, i64 4
  store i8 120, ptr %btmp.i812.sroa.5.0.sso_dst_b.i853.sroa_idx, align 1
  %rw0.i854 = load i64, ptr %out_sso.i813, align 8
  %rw1.i855 = load i64, ptr %out_sso8.i850, align 8
  %rs0.i856 = insertvalue %ArchxStr poison, i64 %rw0.i854, 0
  %rs1.i857 = insertvalue %ArchxStr %rs0.i856, i64 %rw1.i855, 1
  br label %archx_str_concat.exit864

alloc_heap.i834:                                  ; preds = %mat_b.i827.thread, %mat_b.i827
  %aptr.i8281978 = phi ptr [ %alptr.i826, %mat_b.i827.thread ], [ %atmp.i811, %mat_b.i827 ]
  %hp.i835 = call noalias align 16 ptr @malloc(i64 %tot.i820)
  %hnull.i836 = icmp eq ptr %hp.i835, null
  br i1 %hnull.i836, label %oom.i848, label %copy_long.i837

copy_long.i837:                                   ; preds = %alloc_heap.i834
  %hp_i.i838 = ptrtoint ptr %hp.i835 to i64
  %htagged.i839 = or disjoint i64 %hp_i.i838, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i835, ptr nonnull align 1 %aptr.i8281978, i64 %alen.i816, i1 false)
  %dst_b.i840 = getelementptr inbounds nuw i8, ptr %hp.i835, i64 %alen.i816
  store i32 1751347809, ptr %dst_b.i840, align 1
  %btmp.i812.sroa.5.0.dst_b.i840.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i840, i64 4
  store i8 120, ptr %btmp.i812.sroa.5.0.dst_b.i840.sroa_idx, align 1
  %pref32.i841 = load i32, ptr %hp.i835, align 16
  %pref64.i842 = zext i32 %pref32.i841 to i64
  %pref_sh.i843 = shl nuw i64 %pref64.i842, 32
  %w0_out.i844 = or disjoint i64 %pref_sh.i843, %tot.i820
  %ls0.i845 = insertvalue %ArchxStr poison, i64 %w0_out.i844, 0
  %ls1.i846 = insertvalue %ArchxStr %ls0.i845, i64 %htagged.i839, 1
  br label %archx_str_concat.exit864

archx_str_concat.exit864:                         ; preds = %archx_str_concat.exit810, %build_sso.i849, %copy_long.i837
  %common.ret.op.i847 = phi %ArchxStr [ %rs1.i857, %build_sso.i849 ], [ %ls1.i846, %copy_long.i837 ], [ { i64 7521981563576254469, i64 120 }, %archx_str_concat.exit810 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i811)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i813)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i865)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i867)
  %aw0.i868 = extractvalue %ArchxStr %common.ret.op.i847, 0
  %aw1.i869 = extractvalue %ArchxStr %common.ret.op.i847, 1
  %alen.i870 = and i64 %aw0.i868, 4294967295
  %az.i871 = icmp eq i64 %alen.i870, 0
  br i1 %az.i871, label %archx_str_concat.exit918, label %chk_bz.i872

chk_bz.i872:                                      ; preds = %archx_str_concat.exit864
  %tot.i874 = add nuw nsw i64 %alen.i870, 1
  %too_big.i875 = icmp samesign ugt i64 %alen.i870, 2147483646
  br i1 %too_big.i875, label %oom.i902, label %mat_a.i876

oom.i902:                                         ; preds = %alloc_heap.i888, %chk_bz.i872
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i876:                                       ; preds = %chk_bz.i872
  %ashort.i877 = icmp samesign ult i64 %alen.i870, 13
  br i1 %ashort.i877, label %mat_b.i881, label %mat_b.i881.thread

mat_b.i881.thread:                                ; preds = %mat_a.i876
  %araw.i879 = and i64 %aw1.i869, -4
  %alptr.i880 = inttoptr i64 %araw.i879 to ptr
  br label %alloc_heap.i888

mat_b.i881:                                       ; preds = %mat_a.i876
  %ap4.i913 = lshr i64 %aw0.i868, 32
  %ap4_32.i914 = trunc nuw i64 %ap4.i913 to i32
  store i32 %ap4_32.i914, ptr %atmp.i865, align 4
  %atmp4.i915 = getelementptr inbounds nuw i8, ptr %atmp.i865, i64 4
  store i64 %aw1.i869, ptr %atmp4.i915, align 4
  %fits_sso.i887.not = icmp eq i64 %alen.i870, 12
  br i1 %fits_sso.i887.not, label %alloc_heap.i888, label %build_sso.i903

build_sso.i903:                                   ; preds = %mat_b.i881
  %out_sso8.i904 = getelementptr inbounds nuw i8, ptr %out_sso.i867, i64 8
  %tot32.i905 = trunc nuw nsw i64 %tot.i874 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i867, i8 0, i64 16, i1 false)
  store i32 %tot32.i905, ptr %out_sso.i867, align 8
  %sso_dst_a.i906 = getelementptr inbounds nuw i8, ptr %out_sso.i867, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i906, ptr nonnull align 4 %atmp.i865, i64 %alen.i870, i1 false)
  %sso_dst_b.i907 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i906, i64 %alen.i870
  store i8 58, ptr %sso_dst_b.i907, align 1
  %rw0.i908 = load i64, ptr %out_sso.i867, align 8
  %rw1.i909 = load i64, ptr %out_sso8.i904, align 8
  %rs0.i910 = insertvalue %ArchxStr poison, i64 %rw0.i908, 0
  %rs1.i911 = insertvalue %ArchxStr %rs0.i910, i64 %rw1.i909, 1
  br label %archx_str_concat.exit918

alloc_heap.i888:                                  ; preds = %mat_b.i881.thread, %mat_b.i881
  %aptr.i8821981 = phi ptr [ %alptr.i880, %mat_b.i881.thread ], [ %atmp.i865, %mat_b.i881 ]
  %hp.i889 = call noalias align 16 ptr @malloc(i64 %tot.i874)
  %hnull.i890 = icmp eq ptr %hp.i889, null
  br i1 %hnull.i890, label %oom.i902, label %copy_long.i891

copy_long.i891:                                   ; preds = %alloc_heap.i888
  %hp_i.i892 = ptrtoint ptr %hp.i889 to i64
  %htagged.i893 = or disjoint i64 %hp_i.i892, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i889, ptr nonnull align 1 %aptr.i8821981, i64 %alen.i870, i1 false)
  %dst_b.i894 = getelementptr inbounds nuw i8, ptr %hp.i889, i64 %alen.i870
  store i8 58, ptr %dst_b.i894, align 1
  %pref32.i895 = load i32, ptr %hp.i889, align 16
  %pref64.i896 = zext i32 %pref32.i895 to i64
  %pref_sh.i897 = shl nuw i64 %pref64.i896, 32
  %w0_out.i898 = or disjoint i64 %pref_sh.i897, %tot.i874
  %ls0.i899 = insertvalue %ArchxStr poison, i64 %w0_out.i898, 0
  %ls1.i900 = insertvalue %ArchxStr %ls0.i899, i64 %htagged.i893, 1
  br label %archx_str_concat.exit918

archx_str_concat.exit918:                         ; preds = %archx_str_concat.exit864, %build_sso.i903, %copy_long.i891
  %common.ret.op.i901 = phi %ArchxStr [ %rs1.i911, %build_sso.i903 ], [ %ls1.i900, %copy_long.i891 ], [ { i64 249108103169, i64 0 }, %archx_str_concat.exit864 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i865)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i867)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i919)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i921)
  %aw0.i922 = extractvalue %ArchxStr %common.ret.op.i901, 0
  %aw1.i923 = extractvalue %ArchxStr %common.ret.op.i901, 1
  %alen.i924 = and i64 %aw0.i922, 4294967295
  %az.i925 = icmp eq i64 %alen.i924, 0
  br i1 %az.i925, label %archx_str_concat.exit972, label %chk_bz.i926

chk_bz.i926:                                      ; preds = %archx_str_concat.exit918
  %tot.i928 = add nuw nsw i64 %alen.i924, 4
  %too_big.i929 = icmp samesign ugt i64 %alen.i924, 2147483643
  br i1 %too_big.i929, label %oom.i956, label %mat_a.i930

oom.i956:                                         ; preds = %alloc_heap.i942, %chk_bz.i926
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i930:                                       ; preds = %chk_bz.i926
  %ashort.i931 = icmp samesign ult i64 %alen.i924, 13
  br i1 %ashort.i931, label %mat_b.i935, label %mat_b.i935.thread

mat_b.i935.thread:                                ; preds = %mat_a.i930
  %araw.i933 = and i64 %aw1.i923, -4
  %alptr.i934 = inttoptr i64 %araw.i933 to ptr
  br label %alloc_heap.i942

mat_b.i935:                                       ; preds = %mat_a.i930
  %ap4.i967 = lshr i64 %aw0.i922, 32
  %ap4_32.i968 = trunc nuw i64 %ap4.i967 to i32
  store i32 %ap4_32.i968, ptr %atmp.i919, align 4
  %atmp4.i969 = getelementptr inbounds nuw i8, ptr %atmp.i919, i64 4
  store i64 %aw1.i923, ptr %atmp4.i969, align 4
  %fits_sso.i941 = icmp samesign ult i64 %alen.i924, 9
  br i1 %fits_sso.i941, label %build_sso.i957, label %alloc_heap.i942

build_sso.i957:                                   ; preds = %mat_b.i935
  %out_sso8.i958 = getelementptr inbounds nuw i8, ptr %out_sso.i921, i64 8
  %tot32.i959 = trunc nuw nsw i64 %tot.i928 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i921, i8 0, i64 16, i1 false)
  store i32 %tot32.i959, ptr %out_sso.i921, align 8
  %sso_dst_a.i960 = getelementptr inbounds nuw i8, ptr %out_sso.i921, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i960, ptr nonnull align 4 %atmp.i919, i64 %alen.i924, i1 false)
  %sso_dst_b.i961 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i960, i64 %alen.i924
  store i32 1702195828, ptr %sso_dst_b.i961, align 1
  %rw0.i962 = load i64, ptr %out_sso.i921, align 8
  %rw1.i963 = load i64, ptr %out_sso8.i958, align 8
  %rs0.i964 = insertvalue %ArchxStr poison, i64 %rw0.i962, 0
  %rs1.i965 = insertvalue %ArchxStr %rs0.i964, i64 %rw1.i963, 1
  br label %archx_str_concat.exit972

alloc_heap.i942:                                  ; preds = %mat_b.i935.thread, %mat_b.i935
  %aptr.i9361984 = phi ptr [ %alptr.i934, %mat_b.i935.thread ], [ %atmp.i919, %mat_b.i935 ]
  %hp.i943 = call noalias align 16 ptr @malloc(i64 %tot.i928)
  %hnull.i944 = icmp eq ptr %hp.i943, null
  br i1 %hnull.i944, label %oom.i956, label %copy_long.i945

copy_long.i945:                                   ; preds = %alloc_heap.i942
  %hp_i.i946 = ptrtoint ptr %hp.i943 to i64
  %htagged.i947 = or disjoint i64 %hp_i.i946, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i943, ptr nonnull align 1 %aptr.i9361984, i64 %alen.i924, i1 false)
  %dst_b.i948 = getelementptr inbounds nuw i8, ptr %hp.i943, i64 %alen.i924
  store i32 1702195828, ptr %dst_b.i948, align 1
  %pref32.i949 = load i32, ptr %hp.i943, align 16
  %pref64.i950 = zext i32 %pref32.i949 to i64
  %pref_sh.i951 = shl nuw i64 %pref64.i950, 32
  %w0_out.i952 = or disjoint i64 %pref_sh.i951, %tot.i928
  %ls0.i953 = insertvalue %ArchxStr poison, i64 %w0_out.i952, 0
  %ls1.i954 = insertvalue %ArchxStr %ls0.i953, i64 %htagged.i947, 1
  br label %archx_str_concat.exit972

archx_str_concat.exit972:                         ; preds = %archx_str_concat.exit918, %build_sso.i957, %copy_long.i945
  %common.ret.op.i955 = phi %ArchxStr [ %rs1.i965, %build_sso.i957 ], [ %ls1.i954, %copy_long.i945 ], [ { i64 7310875412647641092, i64 0 }, %archx_str_concat.exit918 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i919)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i921)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i973)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i975)
  %aw0.i976 = extractvalue %ArchxStr %common.ret.op.i955, 0
  %aw1.i977 = extractvalue %ArchxStr %common.ret.op.i955, 1
  %alen.i978 = and i64 %aw0.i976, 4294967295
  %az.i979 = icmp eq i64 %alen.i978, 0
  br i1 %az.i979, label %archx_str_concat.exit1026, label %chk_bz.i980

chk_bz.i980:                                      ; preds = %archx_str_concat.exit972
  %tot.i982 = add nuw nsw i64 %alen.i978, 5
  %too_big.i983 = icmp samesign ugt i64 %alen.i978, 2147483642
  br i1 %too_big.i983, label %oom.i1010, label %mat_a.i984

oom.i1010:                                        ; preds = %alloc_heap.i996, %chk_bz.i980
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i984:                                       ; preds = %chk_bz.i980
  %ashort.i985 = icmp samesign ult i64 %alen.i978, 13
  br i1 %ashort.i985, label %mat_b.i989, label %mat_b.i989.thread

mat_b.i989.thread:                                ; preds = %mat_a.i984
  %araw.i987 = and i64 %aw1.i977, -4
  %alptr.i988 = inttoptr i64 %araw.i987 to ptr
  br label %alloc_heap.i996

mat_b.i989:                                       ; preds = %mat_a.i984
  %ap4.i1021 = lshr i64 %aw0.i976, 32
  %ap4_32.i1022 = trunc nuw i64 %ap4.i1021 to i32
  store i32 %ap4_32.i1022, ptr %atmp.i973, align 4
  %atmp4.i1023 = getelementptr inbounds nuw i8, ptr %atmp.i973, i64 4
  store i64 %aw1.i977, ptr %atmp4.i1023, align 4
  %fits_sso.i995 = icmp samesign ult i64 %alen.i978, 8
  br i1 %fits_sso.i995, label %build_sso.i1011, label %alloc_heap.i996

build_sso.i1011:                                  ; preds = %mat_b.i989
  %out_sso8.i1012 = getelementptr inbounds nuw i8, ptr %out_sso.i975, i64 8
  %tot32.i1013 = trunc nuw nsw i64 %tot.i982 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i975, i8 0, i64 16, i1 false)
  store i32 %tot32.i1013, ptr %out_sso.i975, align 8
  %sso_dst_a.i1014 = getelementptr inbounds nuw i8, ptr %out_sso.i975, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1014, ptr nonnull align 4 %atmp.i973, i64 %alen.i978, i1 false)
  %sso_dst_b.i1015 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1014, i64 %alen.i978
  store i32 1852140576, ptr %sso_dst_b.i1015, align 1
  %btmp.i974.sroa.5.0.sso_dst_b.i1015.sroa_idx = getelementptr inbounds nuw i8, ptr %sso_dst_b.i1015, i64 4
  store i8 61, ptr %btmp.i974.sroa.5.0.sso_dst_b.i1015.sroa_idx, align 1
  %rw0.i1016 = load i64, ptr %out_sso.i975, align 8
  %rw1.i1017 = load i64, ptr %out_sso8.i1012, align 8
  %rs0.i1018 = insertvalue %ArchxStr poison, i64 %rw0.i1016, 0
  %rs1.i1019 = insertvalue %ArchxStr %rs0.i1018, i64 %rw1.i1017, 1
  br label %archx_str_concat.exit1026

alloc_heap.i996:                                  ; preds = %mat_b.i989.thread, %mat_b.i989
  %aptr.i9901987 = phi ptr [ %alptr.i988, %mat_b.i989.thread ], [ %atmp.i973, %mat_b.i989 ]
  %hp.i997 = call noalias align 16 ptr @malloc(i64 %tot.i982)
  %hnull.i998 = icmp eq ptr %hp.i997, null
  br i1 %hnull.i998, label %oom.i1010, label %copy_long.i999

copy_long.i999:                                   ; preds = %alloc_heap.i996
  %hp_i.i1000 = ptrtoint ptr %hp.i997 to i64
  %htagged.i1001 = or disjoint i64 %hp_i.i1000, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i997, ptr nonnull align 1 %aptr.i9901987, i64 %alen.i978, i1 false)
  %dst_b.i1002 = getelementptr inbounds nuw i8, ptr %hp.i997, i64 %alen.i978
  store i32 1852140576, ptr %dst_b.i1002, align 1
  %btmp.i974.sroa.5.0.dst_b.i1002.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i1002, i64 4
  store i8 61, ptr %btmp.i974.sroa.5.0.dst_b.i1002.sroa_idx, align 1
  %pref32.i1003 = load i32, ptr %hp.i997, align 16
  %pref64.i1004 = zext i32 %pref32.i1003 to i64
  %pref_sh.i1005 = shl nuw i64 %pref64.i1004, 32
  %w0_out.i1006 = or disjoint i64 %pref_sh.i1005, %tot.i982
  %ls0.i1007 = insertvalue %ArchxStr poison, i64 %w0_out.i1006, 0
  %ls1.i1008 = insertvalue %ArchxStr %ls0.i1007, i64 %htagged.i1001, 1
  br label %archx_str_concat.exit1026

archx_str_concat.exit1026:                        ; preds = %archx_str_concat.exit972, %build_sso.i1011, %copy_long.i999
  %common.ret.op.i1009 = phi %ArchxStr [ %rs1.i1019, %build_sso.i1011 ], [ %ls1.i1008, %copy_long.i999 ], [ { i64 7954883201514602501, i64 61 }, %archx_str_concat.exit972 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i973)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i975)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1557)
  %n32.i1558 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1557, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 3)
  %len.i1559 = sext i32 %n32.i1558 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1556)
  %z.i.i1560 = icmp slt i32 %n32.i1558, 1
  br i1 %z.i.i1560, label %archx_str_from_int.exit1584, label %chk_sso.i.i1561

oom.i.i1576:                                      ; preds = %alloc_heap.i.i1563
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1561:                                  ; preds = %archx_str_concat.exit1026
  %short.i.i1562 = icmp samesign ult i32 %n32.i1558, 13
  br i1 %short.i.i1562, label %pack_sso.i.i1577, label %alloc_heap.i.i1563

pack_sso.i.i1577:                                 ; preds = %chk_sso.i.i1561
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1556, i8 0, i64 16, i1 false)
  store i32 %n32.i1558, ptr %sso.i.i1556, align 8
  %sso.i.i1556.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1556, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1556.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1557, i64 range(i64 -2147483648, 2147483650) %len.i1559, i1 false)
  %sso.i.i1556.0.sso.i.i1556.0.sso.i.i1556.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1579 = load i64, ptr %sso.i.i1556, align 8
  %sso.i.i1556.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1556, i64 8
  %sso.i.i1556.8.sso.i.i1556.8.sso.i.i1556.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1581 = load i64, ptr %sso.i.i1556.8.sroa_idx, align 8
  %ss0.i.i1582 = insertvalue %ArchxStr poison, i64 %sso.i.i1556.0.sso.i.i1556.0.sso.i.i1556.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1579, 0
  %ss1.i.i1583 = insertvalue %ArchxStr %ss0.i.i1582, i64 %sso.i.i1556.8.sso.i.i1556.8.sso.i.i1556.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1581, 1
  br label %archx_str_from_int.exit1584

alloc_heap.i.i1563:                               ; preds = %chk_sso.i.i1561
  %hp.i.i1564 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1559)
  %hnull.i.i1565 = icmp eq ptr %hp.i.i1564, null
  br i1 %hnull.i.i1565, label %oom.i.i1576, label %copy_long.i.i1566

copy_long.i.i1566:                                ; preds = %alloc_heap.i.i1563
  %hp_i.i.i1567 = ptrtoint ptr %hp.i.i1564 to i64
  %htagged.i.i1568 = or disjoint i64 %hp_i.i.i1567, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1564, ptr nonnull readonly align 8 %buf.i1557, i64 range(i64 -2147483648, 2147483650) %len.i1559, i1 false)
  %pref32.i.i1569 = load i32, ptr %hp.i.i1564, align 16
  %pref64.i.i1570 = zext i32 %pref32.i.i1569 to i64
  %pref_sh.i.i1571 = shl nuw i64 %pref64.i.i1570, 32
  %w0_out.i.i1572 = or disjoint i64 %pref_sh.i.i1571, %len.i1559
  %ls0.i.i1573 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1572, 0
  %ls1.i.i1574 = insertvalue %ArchxStr %ls0.i.i1573, i64 %htagged.i.i1568, 1
  br label %archx_str_from_int.exit1584

archx_str_from_int.exit1584:                      ; preds = %archx_str_concat.exit1026, %pack_sso.i.i1577, %copy_long.i.i1566
  %common.ret.op.i.i1575 = phi %ArchxStr [ %ss1.i.i1583, %pack_sso.i.i1577 ], [ %ls1.i.i1574, %copy_long.i.i1566 ], [ zeroinitializer, %archx_str_concat.exit1026 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1556)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1557)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i1027)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1028)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i1029)
  %aw0.i1030 = extractvalue %ArchxStr %common.ret.op.i1009, 0
  %aw1.i1031 = extractvalue %ArchxStr %common.ret.op.i1009, 1
  %bw0.i1032 = extractvalue %ArchxStr %common.ret.op.i.i1575, 0
  %bw1.i1033 = extractvalue %ArchxStr %common.ret.op.i.i1575, 1
  %alen.i1034 = and i64 %aw0.i1030, 4294967295
  %blen.i1035 = and i64 %bw0.i1032, 4294967295
  %az.i1036 = icmp eq i64 %alen.i1034, 0
  br i1 %az.i1036, label %ret_b_clone.i1090, label %chk_bz.i1037

ret_b_clone.i1090:                                ; preds = %archx_str_from_int.exit1584
  %long.i1587 = icmp samesign ult i64 %blen.i1035, 13
  %tag.i1591 = and i64 %bw1.i1033, 3
  %owned.not.i1592 = icmp eq i64 %tag.i1591, 0
  %or.cond2060 = select i1 %long.i1587, i1 true, i1 %owned.not.i1592
  br i1 %or.cond2060, label %archx_str_concat.exit1092, label %dup_heap.i1593

dup_heap.i1593:                                   ; preds = %ret_b_clone.i1090
  %dst.i1594 = call noalias align 16 ptr @malloc(i64 %blen.i1035)
  %isnull.i1595 = icmp eq ptr %dst.i1594, null
  br i1 %isnull.i1595, label %oom.i1602, label %copy.i1596

oom.i1602:                                        ; preds = %dup_heap.i1593
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1596:                                       ; preds = %dup_heap.i1593
  %src_i.i1597 = and i64 %bw1.i1033, -4
  %src.i1598 = inttoptr i64 %src_i.i1597 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1594, ptr nonnull align 4 %src.i1598, i64 %blen.i1035, i1 false)
  %dst_i.i1599 = ptrtoint ptr %dst.i1594 to i64
  %tagged.i1600 = or disjoint i64 %dst_i.i1599, 1
  %out.i1601 = insertvalue %ArchxStr %common.ret.op.i.i1575, i64 %tagged.i1600, 1
  br label %archx_str_concat.exit1092

chk_bz.i1037:                                     ; preds = %archx_str_from_int.exit1584
  %bz.i1038 = icmp eq i64 %blen.i1035, 0
  br i1 %bz.i1038, label %ret_a_clone.i1088, label %calc_tot.i1039

ret_a_clone.i1088:                                ; preds = %chk_bz.i1037
  %long.i1606 = icmp samesign ult i64 %alen.i1034, 13
  %tag.i1610 = and i64 %aw1.i1031, 3
  %owned.not.i1611 = icmp eq i64 %tag.i1610, 0
  %or.cond2061 = select i1 %long.i1606, i1 true, i1 %owned.not.i1611
  br i1 %or.cond2061, label %archx_str_concat.exit1092, label %dup_heap.i1612

dup_heap.i1612:                                   ; preds = %ret_a_clone.i1088
  %dst.i1613 = call noalias align 16 ptr @malloc(i64 %alen.i1034)
  %isnull.i1614 = icmp eq ptr %dst.i1613, null
  br i1 %isnull.i1614, label %oom.i1621, label %copy.i1615

oom.i1621:                                        ; preds = %dup_heap.i1612
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1615:                                       ; preds = %dup_heap.i1612
  %src_i.i1616 = and i64 %aw1.i1031, -4
  %src.i1617 = inttoptr i64 %src_i.i1616 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1613, ptr nonnull align 4 %src.i1617, i64 %alen.i1034, i1 false)
  %dst_i.i1618 = ptrtoint ptr %dst.i1613 to i64
  %tagged.i1619 = or disjoint i64 %dst_i.i1618, 1
  %out.i1620 = insertvalue %ArchxStr %common.ret.op.i1009, i64 %tagged.i1619, 1
  br label %archx_str_concat.exit1092

calc_tot.i1039:                                   ; preds = %chk_bz.i1037
  %tot.i1040 = add nuw nsw i64 %blen.i1035, %alen.i1034
  %too_big.i1041 = icmp samesign ugt i64 %tot.i1040, 2147483647
  br i1 %too_big.i1041, label %oom.i1070, label %mat_a.i1042

oom.i1070:                                        ; preds = %alloc_heap.i1056, %calc_tot.i1039
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1042:                                      ; preds = %calc_tot.i1039
  %ashort.i1043 = icmp samesign ult i64 %alen.i1034, 13
  br i1 %ashort.i1043, label %mat_a_short.i1084, label %mat_a_long.i1044

mat_a_short.i1084:                                ; preds = %mat_a.i1042
  %ap4.i1085 = lshr i64 %aw0.i1030, 32
  %ap4_32.i1086 = trunc nuw i64 %ap4.i1085 to i32
  store i32 %ap4_32.i1086, ptr %atmp.i1027, align 4
  %atmp4.i1087 = getelementptr inbounds nuw i8, ptr %atmp.i1027, i64 4
  store i64 %aw1.i1031, ptr %atmp4.i1087, align 4
  br label %mat_b.i1047

mat_a_long.i1044:                                 ; preds = %mat_a.i1042
  %araw.i1045 = and i64 %aw1.i1031, -4
  %alptr.i1046 = inttoptr i64 %araw.i1045 to ptr
  br label %mat_b.i1047

mat_b.i1047:                                      ; preds = %mat_a_long.i1044, %mat_a_short.i1084
  %aptr.i1048 = phi ptr [ %atmp.i1027, %mat_a_short.i1084 ], [ %alptr.i1046, %mat_a_long.i1044 ]
  %bshort.i1049 = icmp samesign ult i64 %blen.i1035, 13
  br i1 %bshort.i1049, label %mat_b_short.i1080, label %mat_b_long.i1050

mat_b_short.i1080:                                ; preds = %mat_b.i1047
  %bp4.i1081 = lshr i64 %bw0.i1032, 32
  %bp4_32.i1082 = trunc nuw i64 %bp4.i1081 to i32
  store i32 %bp4_32.i1082, ptr %btmp.i1028, align 4
  %btmp4.i1083 = getelementptr inbounds nuw i8, ptr %btmp.i1028, i64 4
  store i64 %bw1.i1033, ptr %btmp4.i1083, align 4
  br label %build.i1053

mat_b_long.i1050:                                 ; preds = %mat_b.i1047
  %braw.i1051 = and i64 %bw1.i1033, -4
  %blptr.i1052 = inttoptr i64 %braw.i1051 to ptr
  br label %build.i1053

build.i1053:                                      ; preds = %mat_b_long.i1050, %mat_b_short.i1080
  %bptr.i1054 = phi ptr [ %btmp.i1028, %mat_b_short.i1080 ], [ %blptr.i1052, %mat_b_long.i1050 ]
  %fits_sso.i1055 = icmp samesign ult i64 %tot.i1040, 13
  br i1 %fits_sso.i1055, label %build_sso.i1071, label %alloc_heap.i1056

build_sso.i1071:                                  ; preds = %build.i1053
  %out_sso8.i1072 = getelementptr inbounds nuw i8, ptr %out_sso.i1029, i64 8
  %tot32.i1073 = trunc nuw nsw i64 %tot.i1040 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i1029, i8 0, i64 16, i1 false)
  store i32 %tot32.i1073, ptr %out_sso.i1029, align 8
  %sso_dst_a.i1074 = getelementptr inbounds nuw i8, ptr %out_sso.i1029, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1074, ptr nonnull align 1 %aptr.i1048, i64 %alen.i1034, i1 false)
  %sso_dst_b.i1075 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1074, i64 %alen.i1034
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i1075, ptr nonnull align 1 %bptr.i1054, i64 %blen.i1035, i1 false)
  %rw0.i1076 = load i64, ptr %out_sso.i1029, align 8
  %rw1.i1077 = load i64, ptr %out_sso8.i1072, align 8
  %rs0.i1078 = insertvalue %ArchxStr poison, i64 %rw0.i1076, 0
  %rs1.i1079 = insertvalue %ArchxStr %rs0.i1078, i64 %rw1.i1077, 1
  br label %archx_str_concat.exit1092

alloc_heap.i1056:                                 ; preds = %build.i1053
  %hp.i1057 = call noalias align 16 ptr @malloc(i64 %tot.i1040)
  %hnull.i1058 = icmp eq ptr %hp.i1057, null
  br i1 %hnull.i1058, label %oom.i1070, label %copy_long.i1059

copy_long.i1059:                                  ; preds = %alloc_heap.i1056
  %hp_i.i1060 = ptrtoint ptr %hp.i1057 to i64
  %htagged.i1061 = or disjoint i64 %hp_i.i1060, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i1057, ptr nonnull align 1 %aptr.i1048, i64 %alen.i1034, i1 false)
  %dst_b.i1062 = getelementptr inbounds nuw i8, ptr %hp.i1057, i64 %alen.i1034
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i1062, ptr nonnull align 1 %bptr.i1054, i64 %blen.i1035, i1 false)
  %pref32.i1063 = load i32, ptr %hp.i1057, align 16
  %pref64.i1064 = zext i32 %pref32.i1063 to i64
  %pref_sh.i1065 = shl nuw i64 %pref64.i1064, 32
  %w0_out.i1066 = or disjoint i64 %pref_sh.i1065, %tot.i1040
  %ls0.i1067 = insertvalue %ArchxStr poison, i64 %w0_out.i1066, 0
  %ls1.i1068 = insertvalue %ArchxStr %ls0.i1067, i64 %htagged.i1061, 1
  br label %archx_str_concat.exit1092

archx_str_concat.exit1092:                        ; preds = %copy.i1615, %ret_a_clone.i1088, %copy.i1596, %ret_b_clone.i1090, %build_sso.i1071, %copy_long.i1059
  %common.ret.op.i1069 = phi %ArchxStr [ %rs1.i1079, %build_sso.i1071 ], [ %ls1.i1068, %copy_long.i1059 ], [ %out.i1601, %copy.i1596 ], [ %common.ret.op.i.i1575, %ret_b_clone.i1090 ], [ %out.i1620, %copy.i1615 ], [ %common.ret.op.i1009, %ret_a_clone.i1088 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i1027)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1028)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i1029)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1623)
  %w0.i1624 = extractvalue %ArchxStr %common.ret.op.i1069, 0
  %w1.i1625 = extractvalue %ArchxStr %common.ret.op.i1069, 1
  %len.i1626 = and i64 %w0.i1624, 4294967295
  %short.i1627 = icmp samesign ult i64 %len.i1626, 13
  br i1 %short.i1627, label %emit.i1648, label %emit.thread.i1628

emit.thread.i1628:                                ; preds = %archx_str_concat.exit1092
  %raw.i1629 = and i64 %w1.i1625, -4
  %lptr.i1630 = inttoptr i64 %raw.i1629 to ptr
  br label %chk_nul.i1631

emit.i1648:                                       ; preds = %archx_str_concat.exit1092
  %p4.i1649 = lshr i64 %w0.i1624, 32
  %p4_32.i1650 = trunc nuw i64 %p4.i1649 to i32
  store i32 %p4_32.i1650, ptr %tmp.i1623, align 4
  %tmp4.i1651 = getelementptr inbounds nuw i8, ptr %tmp.i1623, i64 4
  store i64 %w1.i1625, ptr %tmp4.i1651, align 4
  %pos.not.i1652 = icmp eq i64 %len.i1626, 0
  br i1 %pos.not.i1652, label %do_nl.i1643, label %chk_nul.i1631

chk_nul.i1631:                                    ; preds = %emit.i1648, %emit.thread.i1628
  %data3.i1632 = phi ptr [ %lptr.i1630, %emit.thread.i1628 ], [ %tmp.i1623, %emit.i1648 ]
  %nul.i1633 = call ptr @memchr(ptr nonnull %data3.i1632, i32 0, i64 %len.i1626)
  %has_nul.not.i1634 = icmp eq ptr %nul.i1633, null
  br i1 %has_nul.not.i1634, label %fast_printf.i1645, label %byte_loop.i1635

fast_printf.i1645:                                ; preds = %chk_nul.i1631
  %len32.i1646 = trunc i64 %w0.i1624 to i32
  %np.i1647 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1646, ptr nonnull %data3.i1632)
  br label %archx_str_print.exit1653

byte_loop.i1635:                                  ; preds = %chk_nul.i1631, %byte_loop.i1635
  %bi.i1636 = phi i64 [ %bnext.i1641, %byte_loop.i1635 ], [ 0, %chk_nul.i1631 ]
  %bp.i1637 = getelementptr inbounds nuw i8, ptr %data3.i1632, i64 %bi.i1636
  %ch8.i1638 = load i8, ptr %bp.i1637, align 1
  %ch32.i1639 = zext i8 %ch8.i1638 to i32
  %pc.i1640 = call i32 @putchar(i32 %ch32.i1639)
  %bnext.i1641 = add nuw nsw i64 %bi.i1636, 1
  %exitcond.not.i1642 = icmp eq i64 %bnext.i1641, %len.i1626
  br i1 %exitcond.not.i1642, label %do_nl.i1643, label %byte_loop.i1635

do_nl.i1643:                                      ; preds = %byte_loop.i1635, %emit.i1648
  %nc.i1644 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1653

archx_str_print.exit1653:                         ; preds = %fast_printf.i1645, %do_nl.i1643
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1623)
  %tag.i144 = and i64 %w1.i1625, 1
  %owned.not.i145 = icmp eq i64 %tag.i144, 0
  %or.cond2062 = select i1 %short.i1627, i1 true, i1 %owned.not.i145
  br i1 %or.cond2062, label %archx_str_drop.exit149, label %do_free.i146

do_free.i146:                                     ; preds = %archx_str_print.exit1653
  %raw.i147 = and i64 %w1.i1625, -2
  %ptr.i148 = inttoptr i64 %raw.i147 to ptr
  call void @free(ptr %ptr.i148)
  br label %archx_str_drop.exit149

archx_str_drop.exit149:                           ; preds = %archx_str_print.exit1653, %do_free.i146
  %long.i152 = icmp samesign ult i64 %blen.i1035, 13
  %tag.i155 = and i64 %bw1.i1033, 1
  %owned.not.i156 = icmp eq i64 %tag.i155, 0
  %or.cond2063 = select i1 %long.i152, i1 true, i1 %owned.not.i156
  br i1 %or.cond2063, label %archx_str_drop.exit160, label %do_free.i157

do_free.i157:                                     ; preds = %archx_str_drop.exit149
  %raw.i158 = and i64 %bw1.i1033, -2
  %ptr.i159 = inttoptr i64 %raw.i158 to ptr
  call void @free(ptr %ptr.i159)
  br label %archx_str_drop.exit160

archx_str_drop.exit160:                           ; preds = %archx_str_drop.exit149, %do_free.i157
  %long.i163 = icmp samesign ult i64 %alen.i1034, 13
  %tag.i166 = and i64 %aw1.i1031, 1
  %owned.not.i167 = icmp eq i64 %tag.i166, 0
  %or.cond2064 = select i1 %long.i163, i1 true, i1 %owned.not.i167
  br i1 %or.cond2064, label %archx_str_drop.exit171, label %do_free.i168

do_free.i168:                                     ; preds = %archx_str_drop.exit160
  %raw.i169 = and i64 %aw1.i1031, -2
  %ptr.i170 = inttoptr i64 %raw.i169 to ptr
  call void @free(ptr %ptr.i170)
  br label %archx_str_drop.exit171

archx_str_drop.exit171:                           ; preds = %archx_str_drop.exit160, %do_free.i168
  %long.i174 = icmp samesign ult i64 %alen.i978, 13
  %tag.i177 = and i64 %aw1.i977, 1
  %owned.not.i178 = icmp eq i64 %tag.i177, 0
  %or.cond2065 = select i1 %long.i174, i1 true, i1 %owned.not.i178
  br i1 %or.cond2065, label %archx_str_drop.exit182, label %do_free.i179

do_free.i179:                                     ; preds = %archx_str_drop.exit171
  %raw.i180 = and i64 %aw1.i977, -2
  %ptr.i181 = inttoptr i64 %raw.i180 to ptr
  call void @free(ptr %ptr.i181)
  br label %archx_str_drop.exit182

archx_str_drop.exit182:                           ; preds = %archx_str_drop.exit171, %do_free.i179
  %long.i185 = icmp samesign ult i64 %alen.i924, 13
  %tag.i188 = and i64 %aw1.i923, 1
  %owned.not.i189 = icmp eq i64 %tag.i188, 0
  %or.cond2066 = select i1 %long.i185, i1 true, i1 %owned.not.i189
  br i1 %or.cond2066, label %archx_str_drop.exit193, label %do_free.i190

do_free.i190:                                     ; preds = %archx_str_drop.exit182
  %raw.i191 = and i64 %aw1.i923, -2
  %ptr.i192 = inttoptr i64 %raw.i191 to ptr
  call void @free(ptr %ptr.i192)
  br label %archx_str_drop.exit193

archx_str_drop.exit193:                           ; preds = %archx_str_drop.exit182, %do_free.i190
  %long.i196 = icmp samesign ult i64 %alen.i870, 13
  %tag.i199 = and i64 %aw1.i869, 1
  %owned.not.i200 = icmp eq i64 %tag.i199, 0
  %or.cond2067 = select i1 %long.i196, i1 true, i1 %owned.not.i200
  br i1 %or.cond2067, label %archx_str_drop.exit204, label %do_free.i201

do_free.i201:                                     ; preds = %archx_str_drop.exit193
  %raw.i202 = and i64 %aw1.i869, -2
  %ptr.i203 = inttoptr i64 %raw.i202 to ptr
  call void @free(ptr %ptr.i203)
  br label %archx_str_drop.exit204

archx_str_drop.exit204:                           ; preds = %archx_str_drop.exit193, %do_free.i201
  %long.i207 = icmp samesign ult i64 %alen.i816, 13
  %tag.i210 = and i64 %aw1.i815, 1
  %owned.not.i211 = icmp eq i64 %tag.i210, 0
  %or.cond2068 = select i1 %long.i207, i1 true, i1 %owned.not.i211
  br i1 %or.cond2068, label %archx_str_drop.exit215, label %do_free.i212

do_free.i212:                                     ; preds = %archx_str_drop.exit204
  %raw.i213 = and i64 %aw1.i815, -2
  %ptr.i214 = inttoptr i64 %raw.i213 to ptr
  call void @free(ptr %ptr.i214)
  br label %archx_str_drop.exit215

archx_str_drop.exit215:                           ; preds = %archx_str_drop.exit204, %do_free.i212
  %long.i218 = icmp samesign ult i64 %alen.i762, 13
  %tag.i221 = and i64 %aw1.i761, 1
  %owned.not.i222 = icmp eq i64 %tag.i221, 0
  %or.cond2069 = select i1 %long.i218, i1 true, i1 %owned.not.i222
  br i1 %or.cond2069, label %archx_str_drop.exit226, label %do_free.i223

do_free.i223:                                     ; preds = %archx_str_drop.exit215
  %raw.i224 = and i64 %aw1.i761, -2
  %ptr.i225 = inttoptr i64 %raw.i224 to ptr
  call void @free(ptr %ptr.i225)
  br label %archx_str_drop.exit226

archx_str_drop.exit226:                           ; preds = %archx_str_drop.exit215, %do_free.i223
  %long.i229 = icmp samesign ult i64 %blen.i699, 13
  %tag.i232 = and i64 %bw1.i697, 1
  %owned.not.i233 = icmp eq i64 %tag.i232, 0
  %or.cond2070 = select i1 %long.i229, i1 true, i1 %owned.not.i233
  br i1 %or.cond2070, label %archx_str_drop.exit237, label %do_free.i234

do_free.i234:                                     ; preds = %archx_str_drop.exit226
  %raw.i235 = and i64 %bw1.i697, -2
  %ptr.i236 = inttoptr i64 %raw.i235 to ptr
  call void @free(ptr %ptr.i236)
  br label %archx_str_drop.exit237

archx_str_drop.exit237:                           ; preds = %archx_str_drop.exit226, %do_free.i234
  %long.i240 = icmp samesign ult i64 %alen.i698, 13
  %tag.i243 = and i64 %aw1.i695, 1
  %owned.not.i244 = icmp eq i64 %tag.i243, 0
  %or.cond2071 = select i1 %long.i240, i1 true, i1 %owned.not.i244
  br i1 %or.cond2071, label %archx_str_drop.exit248, label %do_free.i245

do_free.i245:                                     ; preds = %archx_str_drop.exit237
  %raw.i246 = and i64 %aw1.i695, -2
  %ptr.i247 = inttoptr i64 %raw.i246 to ptr
  call void @free(ptr %ptr.i247)
  br label %archx_str_drop.exit248

archx_str_drop.exit248:                           ; preds = %archx_str_drop.exit237, %do_free.i245
  %long.i251 = icmp samesign ult i64 %alen.i642, 13
  %tag.i254 = and i64 %aw1.i641, 1
  %owned.not.i255 = icmp eq i64 %tag.i254, 0
  %or.cond2072 = select i1 %long.i251, i1 true, i1 %owned.not.i255
  br i1 %or.cond2072, label %archx_str_drop.exit259, label %do_free.i256

do_free.i256:                                     ; preds = %archx_str_drop.exit248
  %raw.i257 = and i64 %aw1.i641, -2
  %ptr.i258 = inttoptr i64 %raw.i257 to ptr
  call void @free(ptr %ptr.i258)
  br label %archx_str_drop.exit259

archx_str_drop.exit259:                           ; preds = %archx_str_drop.exit248, %do_free.i256
  %long.i262 = icmp samesign ult i64 %blen.i588, 13
  %tag.i265 = and i64 %bw1.i587, 1
  %owned.not.i266 = icmp eq i64 %tag.i265, 0
  %or.cond2073 = select i1 %long.i262, i1 true, i1 %owned.not.i266
  br i1 %or.cond2073, label %archx_str_drop.exit270, label %do_free.i267

do_free.i267:                                     ; preds = %archx_str_drop.exit259
  %raw.i268 = and i64 %bw1.i587, -2
  %ptr.i269 = inttoptr i64 %raw.i268 to ptr
  call void @free(ptr %ptr.i269)
  br label %archx_str_drop.exit270

archx_str_drop.exit270:                           ; preds = %archx_str_drop.exit259, %do_free.i267
  %t6.i = load i64, ptr %t0, align 16
  %t8.i = icmp sgt i64 %t6.i, 20
  br i1 %t8.i, label %archx_fn_find_gt.exit, label %enum.step.2.i

enum.step.2.i:                                    ; preds = %archx_str_drop.exit270
  %t6.1.i = load i64, ptr %t3, align 8
  %t8.1.i = icmp sgt i64 %t6.1.i, 20
  br i1 %t8.1.i, label %archx_fn_find_gt.exit.thread1993, label %enum.step.2.1.i

enum.step.2.1.i:                                  ; preds = %enum.step.2.i
  %t6.2.i = load i64, ptr %t4, align 16
  %t8.2.i = icmp sgt i64 %t6.2.i, 20
  br i1 %t8.2.i, label %archx_fn_find_gt.exit.thread1993, label %enum.step.2.2.i

enum.step.2.2.i:                                  ; preds = %enum.step.2.1.i
  %t6.3.i = load i64, ptr %t5, align 8
  %t8.3.i = icmp sgt i64 %t6.3.i, 20
  br i1 %t8.3.i, label %archx_fn_find_gt.exit.thread1993, label %enum.step.2.3.i

enum.step.2.3.i:                                  ; preds = %enum.step.2.2.i
  %t6.4.i = load i64, ptr %t6, align 16
  %t8.4.i = icmp sgt i64 %t6.4.i, 20
  br i1 %t8.4.i, label %archx_fn_find_gt.exit.thread1993, label %enum.step.2.i1657

archx_fn_find_gt.exit.thread1993:                 ; preds = %enum.step.2.i, %enum.step.2.1.i, %enum.step.2.2.i, %enum.step.2.3.i
  %enum.pos.2.03.lcssa.i.ph = phi i64 [ 4, %enum.step.2.3.i ], [ 3, %enum.step.2.2.i ], [ 2, %enum.step.2.1.i ], [ 1, %enum.step.2.i ]
  %t11.i1995 = insertvalue { i1, i64 } { i1 true, i64 undef }, i64 %enum.pos.2.03.lcssa.i.ph, 1
  br label %enum.step.2.i1657

archx_fn_find_gt.exit:                            ; preds = %archx_str_drop.exit270
  %t8.i1656 = icmp samesign ugt i64 %t6.i, 500
  br i1 %t8.i1656, label %if.then.4.i1674, label %enum.step.2.i1657

if.then.4.i1674:                                  ; preds = %enum.step.2.3.i1669, %enum.step.2.2.i1665, %enum.step.2.1.i1661, %enum.step.2.i1657, %archx_fn_find_gt.exit
  %common.ret.op.i16541991 = phi { i1, i64 } [ { i1 true, i64 0 }, %archx_fn_find_gt.exit ], [ %common.ret.op.i16541992, %enum.step.2.i1657 ], [ %common.ret.op.i16541992, %enum.step.2.1.i1661 ], [ %common.ret.op.i16541992, %enum.step.2.2.i1665 ], [ %common.ret.op.i16541992, %enum.step.2.3.i1669 ]
  %enum.pos.2.03.lcssa.i1675 = phi i64 [ 0, %archx_fn_find_gt.exit ], [ 1, %enum.step.2.i1657 ], [ 2, %enum.step.2.1.i1661 ], [ 3, %enum.step.2.2.i1665 ], [ 4, %enum.step.2.3.i1669 ]
  %t11.i1676 = insertvalue { i1, i64 } { i1 true, i64 undef }, i64 %enum.pos.2.03.lcssa.i1675, 1
  br label %archx_fn_find_gt.exit1677

enum.step.2.i1657:                                ; preds = %enum.step.2.3.i, %archx_fn_find_gt.exit.thread1993, %archx_fn_find_gt.exit
  %common.ret.op.i16541992 = phi { i1, i64 } [ { i1 true, i64 0 }, %archx_fn_find_gt.exit ], [ %t11.i1995, %archx_fn_find_gt.exit.thread1993 ], [ zeroinitializer, %enum.step.2.3.i ]
  %t6.1.i1659 = load i64, ptr %t3, align 8
  %t8.1.i1660 = icmp sgt i64 %t6.1.i1659, 500
  br i1 %t8.1.i1660, label %if.then.4.i1674, label %enum.step.2.1.i1661

enum.step.2.1.i1661:                              ; preds = %enum.step.2.i1657
  %t6.2.i1663 = load i64, ptr %t4, align 16
  %t8.2.i1664 = icmp sgt i64 %t6.2.i1663, 500
  br i1 %t8.2.i1664, label %if.then.4.i1674, label %enum.step.2.2.i1665

enum.step.2.2.i1665:                              ; preds = %enum.step.2.1.i1661
  %t6.3.i1667 = load i64, ptr %t5, align 8
  %t8.3.i1668 = icmp sgt i64 %t6.3.i1667, 500
  br i1 %t8.3.i1668, label %if.then.4.i1674, label %enum.step.2.3.i1669

enum.step.2.3.i1669:                              ; preds = %enum.step.2.2.i1665
  %t6.4.i1671 = load i64, ptr %t6, align 16
  %t8.4.i1672 = icmp sgt i64 %t6.4.i1671, 500
  br i1 %t8.4.i1672, label %if.then.4.i1674, label %archx_fn_find_gt.exit1677

archx_fn_find_gt.exit1677:                        ; preds = %if.then.4.i1674, %enum.step.2.3.i1669
  %common.ret.op.i16541990 = phi { i1, i64 } [ %common.ret.op.i16541991, %if.then.4.i1674 ], [ %common.ret.op.i16541992, %enum.step.2.3.i1669 ]
  %common.ret.op.i1673 = phi { i1, i64 } [ %t11.i1676, %if.then.4.i1674 ], [ zeroinitializer, %enum.step.2.3.i1669 ]
  %t57 = extractvalue { i1, i64 } %common.ret.op.i16541990, 0
  br i1 %t57, label %if.then.2, label %if.merge.4

if.then.2:                                        ; preds = %archx_fn_find_gt.exit1677
  %t58 = extractvalue { i1, i64 } %common.ret.op.i16541990, 1
  %t60 = icmp ugt i64 %t58, 4
  br i1 %t60, label %idx.oob.6, label %idx.ok.5

idx.oob.6:                                        ; preds = %if.then.2
  call fastcc void @archx_bounds_fail(i64 %t58)
  unreachable

idx.ok.5:                                         ; preds = %if.then.2
  %t62 = getelementptr inbounds nuw i64, ptr %t0, i64 %t58
  %t63 = load i64, ptr %t62, align 8
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1679)
  %n32.i1680 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1679, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t63)
  %len.i1681 = sext i32 %n32.i1680 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1678)
  %z.i.i1682 = icmp slt i32 %n32.i1680, 1
  br i1 %z.i.i1682, label %archx_str_from_int.exit1706, label %chk_sso.i.i1683

oom.i.i1698:                                      ; preds = %alloc_heap.i.i1685
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1683:                                  ; preds = %idx.ok.5
  %short.i.i1684 = icmp samesign ult i32 %n32.i1680, 13
  br i1 %short.i.i1684, label %pack_sso.i.i1699, label %alloc_heap.i.i1685

pack_sso.i.i1699:                                 ; preds = %chk_sso.i.i1683
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1678, i8 0, i64 16, i1 false)
  store i32 %n32.i1680, ptr %sso.i.i1678, align 8
  %sso.i.i1678.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1678, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1678.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1679, i64 range(i64 -2147483648, 2147483650) %len.i1681, i1 false)
  %sso.i.i1678.0.sso.i.i1678.0.sso.i.i1678.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1701 = load i64, ptr %sso.i.i1678, align 8
  %sso.i.i1678.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1678, i64 8
  %sso.i.i1678.8.sso.i.i1678.8.sso.i.i1678.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1703 = load i64, ptr %sso.i.i1678.8.sroa_idx, align 8
  %ss0.i.i1704 = insertvalue %ArchxStr poison, i64 %sso.i.i1678.0.sso.i.i1678.0.sso.i.i1678.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1701, 0
  %ss1.i.i1705 = insertvalue %ArchxStr %ss0.i.i1704, i64 %sso.i.i1678.8.sso.i.i1678.8.sso.i.i1678.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1703, 1
  br label %archx_str_from_int.exit1706

alloc_heap.i.i1685:                               ; preds = %chk_sso.i.i1683
  %hp.i.i1686 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1681)
  %hnull.i.i1687 = icmp eq ptr %hp.i.i1686, null
  br i1 %hnull.i.i1687, label %oom.i.i1698, label %copy_long.i.i1688

copy_long.i.i1688:                                ; preds = %alloc_heap.i.i1685
  %hp_i.i.i1689 = ptrtoint ptr %hp.i.i1686 to i64
  %htagged.i.i1690 = or disjoint i64 %hp_i.i.i1689, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1686, ptr nonnull readonly align 8 %buf.i1679, i64 range(i64 -2147483648, 2147483650) %len.i1681, i1 false)
  %pref32.i.i1691 = load i32, ptr %hp.i.i1686, align 16
  %pref64.i.i1692 = zext i32 %pref32.i.i1691 to i64
  %pref_sh.i.i1693 = shl nuw i64 %pref64.i.i1692, 32
  %w0_out.i.i1694 = or disjoint i64 %pref_sh.i.i1693, %len.i1681
  %ls0.i.i1695 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1694, 0
  %ls1.i.i1696 = insertvalue %ArchxStr %ls0.i.i1695, i64 %htagged.i.i1690, 1
  br label %archx_str_from_int.exit1706

archx_str_from_int.exit1706:                      ; preds = %idx.ok.5, %pack_sso.i.i1699, %copy_long.i.i1688
  %common.ret.op.i.i1697 = phi %ArchxStr [ %ss1.i.i1705, %pack_sso.i.i1699 ], [ %ls1.i.i1696, %copy_long.i.i1688 ], [ zeroinitializer, %idx.ok.5 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1678)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1679)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1094)
  %bw0.i1096 = extractvalue %ArchxStr %common.ret.op.i.i1697, 0
  %bw1.i1097 = extractvalue %ArchxStr %common.ret.op.i.i1697, 1
  %blen.i1098 = and i64 %bw0.i1096, 4294967295
  %bz.i1100 = icmp eq i64 %blen.i1098, 0
  br i1 %bz.i1100, label %archx_str_concat.exit1146, label %calc_tot.i1101

calc_tot.i1101:                                   ; preds = %archx_str_from_int.exit1706
  %tot.i1102 = add nuw nsw i64 %blen.i1098, 6
  %too_big.i1103 = icmp samesign ugt i64 %blen.i1098, 2147483641
  br i1 %too_big.i1103, label %oom.i1130, label %mat_a.i1104

oom.i1130:                                        ; preds = %alloc_heap.i1116, %calc_tot.i1101
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1104:                                      ; preds = %calc_tot.i1101
  %bshort.i1109 = icmp samesign ult i64 %blen.i1098, 13
  br i1 %bshort.i1109, label %build.i1113, label %build.i1113.thread

build.i1113.thread:                               ; preds = %mat_a.i1104
  %braw.i1111 = and i64 %bw1.i1097, -4
  %blptr.i1112 = inttoptr i64 %braw.i1111 to ptr
  br label %alloc_heap.i1116

build.i1113:                                      ; preds = %mat_a.i1104
  %bp4.i1141 = lshr i64 %bw0.i1096, 32
  %bp4_32.i1142 = trunc nuw i64 %bp4.i1141 to i32
  store i32 %bp4_32.i1142, ptr %btmp.i1094, align 4
  %btmp4.i1143 = getelementptr inbounds nuw i8, ptr %btmp.i1094, i64 4
  store i64 %bw1.i1097, ptr %btmp4.i1143, align 4
  %fits_sso.i1115 = icmp samesign ult i64 %blen.i1098, 7
  br i1 %fits_sso.i1115, label %build_sso.i1131, label %alloc_heap.i1116

build_sso.i1131:                                  ; preds = %build.i1113
  store i48 0, ptr %out_sso.i1095.sroa.6.sroa.5.sroa.0, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i1095.sroa.6.sroa.5.sroa.0, ptr nonnull align 4 %btmp.i1094, i64 %blen.i1098, i1 false)
  %out_sso.i1095.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i1102, 7959390400324567040
  %out_sso.i1095.sroa.6.sroa.5.sroa.0.0.out_sso.i1095.sroa.6.sroa.5.sroa.0.0.out_sso.i1095.sroa.6.sroa.5.sroa.0.0.out_sso.i1095.sroa.6.sroa.5.sroa.0.0.out_sso.i1095.sroa.6.sroa.5.0.out_sso.i1095.sroa.6.8.rw1.i1137 = load i48, ptr %out_sso.i1095.sroa.6.sroa.5.sroa.0, align 8
  %out_sso.i1095.sroa.6.sroa.5.0.insert.ext = zext i48 %out_sso.i1095.sroa.6.sroa.5.sroa.0.0.out_sso.i1095.sroa.6.sroa.5.sroa.0.0.out_sso.i1095.sroa.6.sroa.5.sroa.0.0.out_sso.i1095.sroa.6.sroa.5.sroa.0.0.out_sso.i1095.sroa.6.sroa.5.0.out_sso.i1095.sroa.6.8.rw1.i1137 to i64
  %out_sso.i1095.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i1095.sroa.6.sroa.5.0.insert.ext, 16
  %out_sso.i1095.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i1095.sroa.6.sroa.5.0.insert.shift, 15716
  %rs0.i1138 = insertvalue %ArchxStr poison, i64 %out_sso.i1095.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i1139 = insertvalue %ArchxStr %rs0.i1138, i64 %out_sso.i1095.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit1146

alloc_heap.i1116:                                 ; preds = %build.i1113.thread, %build.i1113
  %bptr.i11142189 = phi ptr [ %blptr.i1112, %build.i1113.thread ], [ %btmp.i1094, %build.i1113 ]
  %hp.i1117 = call noalias align 16 ptr @malloc(i64 %tot.i1102)
  %hnull.i1118 = icmp eq ptr %hp.i1117, null
  br i1 %hnull.i1118, label %oom.i1130, label %copy_long.i1119

copy_long.i1119:                                  ; preds = %alloc_heap.i1116
  %hp_i.i1120 = ptrtoint ptr %hp.i1117 to i64
  %htagged.i1121 = or disjoint i64 %hp_i.i1120, 1
  store i32 1853189990, ptr %hp.i1117, align 16
  %atmp.i1093.sroa.5.0.hp.i1117.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i1117, i64 4
  store i16 15716, ptr %atmp.i1093.sroa.5.0.hp.i1117.sroa_idx, align 4
  %dst_b.i1122 = getelementptr inbounds nuw i8, ptr %hp.i1117, i64 6
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 2 %dst_b.i1122, ptr nonnull align 1 %bptr.i11142189, i64 %blen.i1098, i1 false)
  %w0_out.i1126 = or disjoint i64 %tot.i1102, 7959390400324567040
  %ls0.i1127 = insertvalue %ArchxStr poison, i64 %w0_out.i1126, 0
  %ls1.i1128 = insertvalue %ArchxStr %ls0.i1127, i64 %htagged.i1121, 1
  br label %archx_str_concat.exit1146

archx_str_concat.exit1146:                        ; preds = %archx_str_from_int.exit1706, %build_sso.i1131, %copy_long.i1119
  %common.ret.op.i1129 = phi %ArchxStr [ %rs1.i1139, %build_sso.i1131 ], [ %ls1.i1128, %copy_long.i1119 ], [ { i64 7959390400324567046, i64 15716 }, %archx_str_from_int.exit1706 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1094)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i1147)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i1149)
  %aw0.i1150 = extractvalue %ArchxStr %common.ret.op.i1129, 0
  %aw1.i1151 = extractvalue %ArchxStr %common.ret.op.i1129, 1
  %alen.i1152 = and i64 %aw0.i1150, 4294967295
  %az.i1153 = icmp eq i64 %alen.i1152, 0
  br i1 %az.i1153, label %archx_str_concat.exit1200, label %chk_bz.i1154

chk_bz.i1154:                                     ; preds = %archx_str_concat.exit1146
  %tot.i1156 = add nuw nsw i64 %alen.i1152, 4
  %too_big.i1157 = icmp samesign ugt i64 %alen.i1152, 2147483643
  br i1 %too_big.i1157, label %oom.i1184, label %mat_a.i1158

oom.i1184:                                        ; preds = %alloc_heap.i1170, %chk_bz.i1154
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1158:                                      ; preds = %chk_bz.i1154
  %ashort.i1159 = icmp samesign ult i64 %alen.i1152, 13
  br i1 %ashort.i1159, label %mat_b.i1163, label %mat_b.i1163.thread

mat_b.i1163.thread:                               ; preds = %mat_a.i1158
  %araw.i1161 = and i64 %aw1.i1151, -4
  %alptr.i1162 = inttoptr i64 %araw.i1161 to ptr
  br label %alloc_heap.i1170

mat_b.i1163:                                      ; preds = %mat_a.i1158
  %ap4.i1195 = lshr i64 %aw0.i1150, 32
  %ap4_32.i1196 = trunc nuw i64 %ap4.i1195 to i32
  store i32 %ap4_32.i1196, ptr %atmp.i1147, align 4
  %atmp4.i1197 = getelementptr inbounds nuw i8, ptr %atmp.i1147, i64 4
  store i64 %aw1.i1151, ptr %atmp4.i1197, align 4
  %fits_sso.i1169 = icmp samesign ult i64 %alen.i1152, 9
  br i1 %fits_sso.i1169, label %build_sso.i1185, label %alloc_heap.i1170

build_sso.i1185:                                  ; preds = %mat_b.i1163
  %out_sso8.i1186 = getelementptr inbounds nuw i8, ptr %out_sso.i1149, i64 8
  %tot32.i1187 = trunc nuw nsw i64 %tot.i1156 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i1149, i8 0, i64 16, i1 false)
  store i32 %tot32.i1187, ptr %out_sso.i1149, align 8
  %sso_dst_a.i1188 = getelementptr inbounds nuw i8, ptr %out_sso.i1149, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1188, ptr nonnull align 4 %atmp.i1147, i64 %alen.i1152, i1 false)
  %sso_dst_b.i1189 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1188, i64 %alen.i1152
  store i32 544497952, ptr %sso_dst_b.i1189, align 1
  %rw0.i1190 = load i64, ptr %out_sso.i1149, align 8
  %rw1.i1191 = load i64, ptr %out_sso8.i1186, align 8
  %rs0.i1192 = insertvalue %ArchxStr poison, i64 %rw0.i1190, 0
  %rs1.i1193 = insertvalue %ArchxStr %rs0.i1192, i64 %rw1.i1191, 1
  br label %archx_str_concat.exit1200

alloc_heap.i1170:                                 ; preds = %mat_b.i1163.thread, %mat_b.i1163
  %aptr.i11641999 = phi ptr [ %alptr.i1162, %mat_b.i1163.thread ], [ %atmp.i1147, %mat_b.i1163 ]
  %hp.i1171 = call noalias align 16 ptr @malloc(i64 %tot.i1156)
  %hnull.i1172 = icmp eq ptr %hp.i1171, null
  br i1 %hnull.i1172, label %oom.i1184, label %copy_long.i1173

copy_long.i1173:                                  ; preds = %alloc_heap.i1170
  %hp_i.i1174 = ptrtoint ptr %hp.i1171 to i64
  %htagged.i1175 = or disjoint i64 %hp_i.i1174, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i1171, ptr nonnull align 1 %aptr.i11641999, i64 %alen.i1152, i1 false)
  %dst_b.i1176 = getelementptr inbounds nuw i8, ptr %hp.i1171, i64 %alen.i1152
  store i32 544497952, ptr %dst_b.i1176, align 1
  %pref32.i1177 = load i32, ptr %hp.i1171, align 16
  %pref64.i1178 = zext i32 %pref32.i1177 to i64
  %pref_sh.i1179 = shl nuw i64 %pref64.i1178, 32
  %w0_out.i1180 = or disjoint i64 %pref_sh.i1179, %tot.i1156
  %ls0.i1181 = insertvalue %ArchxStr poison, i64 %w0_out.i1180, 0
  %ls1.i1182 = insertvalue %ArchxStr %ls0.i1181, i64 %htagged.i1175, 1
  br label %archx_str_concat.exit1200

archx_str_concat.exit1200:                        ; preds = %archx_str_concat.exit1146, %build_sso.i1185, %copy_long.i1173
  %common.ret.op.i1183 = phi %ArchxStr [ %rs1.i1193, %build_sso.i1185 ], [ %ls1.i1182, %copy_long.i1173 ], [ { i64 2338600896578977796, i64 0 }, %archx_str_concat.exit1146 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i1147)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i1149)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1710)
  %n32.i1711 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1710, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t58)
  %len.i1712 = sext i32 %n32.i1711 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1709)
  %z.i.i1713 = icmp slt i32 %n32.i1711, 1
  br i1 %z.i.i1713, label %archx_str_from_int.exit1737, label %chk_sso.i.i1714

oom.i.i1729:                                      ; preds = %alloc_heap.i.i1716
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1714:                                  ; preds = %archx_str_concat.exit1200
  %short.i.i1715 = icmp samesign ult i32 %n32.i1711, 13
  br i1 %short.i.i1715, label %pack_sso.i.i1730, label %alloc_heap.i.i1716

pack_sso.i.i1730:                                 ; preds = %chk_sso.i.i1714
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1709, i8 0, i64 16, i1 false)
  store i32 %n32.i1711, ptr %sso.i.i1709, align 8
  %sso.i.i1709.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1709, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1709.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1710, i64 range(i64 -2147483648, 2147483650) %len.i1712, i1 false)
  %sso.i.i1709.0.sso.i.i1709.0.sso.i.i1709.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1732 = load i64, ptr %sso.i.i1709, align 8
  %sso.i.i1709.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1709, i64 8
  %sso.i.i1709.8.sso.i.i1709.8.sso.i.i1709.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1734 = load i64, ptr %sso.i.i1709.8.sroa_idx, align 8
  %ss0.i.i1735 = insertvalue %ArchxStr poison, i64 %sso.i.i1709.0.sso.i.i1709.0.sso.i.i1709.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1732, 0
  %ss1.i.i1736 = insertvalue %ArchxStr %ss0.i.i1735, i64 %sso.i.i1709.8.sso.i.i1709.8.sso.i.i1709.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1734, 1
  br label %archx_str_from_int.exit1737

alloc_heap.i.i1716:                               ; preds = %chk_sso.i.i1714
  %hp.i.i1717 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1712)
  %hnull.i.i1718 = icmp eq ptr %hp.i.i1717, null
  br i1 %hnull.i.i1718, label %oom.i.i1729, label %copy_long.i.i1719

copy_long.i.i1719:                                ; preds = %alloc_heap.i.i1716
  %hp_i.i.i1720 = ptrtoint ptr %hp.i.i1717 to i64
  %htagged.i.i1721 = or disjoint i64 %hp_i.i.i1720, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1717, ptr nonnull readonly align 8 %buf.i1710, i64 range(i64 -2147483648, 2147483650) %len.i1712, i1 false)
  %pref32.i.i1722 = load i32, ptr %hp.i.i1717, align 16
  %pref64.i.i1723 = zext i32 %pref32.i.i1722 to i64
  %pref_sh.i.i1724 = shl nuw i64 %pref64.i.i1723, 32
  %w0_out.i.i1725 = or disjoint i64 %pref_sh.i.i1724, %len.i1712
  %ls0.i.i1726 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1725, 0
  %ls1.i.i1727 = insertvalue %ArchxStr %ls0.i.i1726, i64 %htagged.i.i1721, 1
  br label %archx_str_from_int.exit1737

archx_str_from_int.exit1737:                      ; preds = %archx_str_concat.exit1200, %pack_sso.i.i1730, %copy_long.i.i1719
  %common.ret.op.i.i1728 = phi %ArchxStr [ %ss1.i.i1736, %pack_sso.i.i1730 ], [ %ls1.i.i1727, %copy_long.i.i1719 ], [ zeroinitializer, %archx_str_concat.exit1200 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1709)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1710)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i1201)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1202)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i1203)
  %aw0.i1204 = extractvalue %ArchxStr %common.ret.op.i1183, 0
  %aw1.i1205 = extractvalue %ArchxStr %common.ret.op.i1183, 1
  %bw0.i1206 = extractvalue %ArchxStr %common.ret.op.i.i1728, 0
  %bw1.i1207 = extractvalue %ArchxStr %common.ret.op.i.i1728, 1
  %alen.i1208 = and i64 %aw0.i1204, 4294967295
  %blen.i1209 = and i64 %bw0.i1206, 4294967295
  %az.i1210 = icmp eq i64 %alen.i1208, 0
  br i1 %az.i1210, label %ret_b_clone.i1264, label %chk_bz.i1211

ret_b_clone.i1264:                                ; preds = %archx_str_from_int.exit1737
  %long.i1740 = icmp samesign ult i64 %blen.i1209, 13
  %tag.i1744 = and i64 %bw1.i1207, 3
  %owned.not.i1745 = icmp eq i64 %tag.i1744, 0
  %or.cond2074 = select i1 %long.i1740, i1 true, i1 %owned.not.i1745
  br i1 %or.cond2074, label %archx_str_concat.exit1266, label %dup_heap.i1746

dup_heap.i1746:                                   ; preds = %ret_b_clone.i1264
  %dst.i1747 = call noalias align 16 ptr @malloc(i64 %blen.i1209)
  %isnull.i1748 = icmp eq ptr %dst.i1747, null
  br i1 %isnull.i1748, label %oom.i1755, label %copy.i1749

oom.i1755:                                        ; preds = %dup_heap.i1746
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1749:                                       ; preds = %dup_heap.i1746
  %src_i.i1750 = and i64 %bw1.i1207, -4
  %src.i1751 = inttoptr i64 %src_i.i1750 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1747, ptr nonnull align 4 %src.i1751, i64 %blen.i1209, i1 false)
  %dst_i.i1752 = ptrtoint ptr %dst.i1747 to i64
  %tagged.i1753 = or disjoint i64 %dst_i.i1752, 1
  %out.i1754 = insertvalue %ArchxStr %common.ret.op.i.i1728, i64 %tagged.i1753, 1
  br label %archx_str_concat.exit1266

chk_bz.i1211:                                     ; preds = %archx_str_from_int.exit1737
  %bz.i1212 = icmp eq i64 %blen.i1209, 0
  br i1 %bz.i1212, label %ret_a_clone.i1262, label %calc_tot.i1213

ret_a_clone.i1262:                                ; preds = %chk_bz.i1211
  %long.i1759 = icmp samesign ult i64 %alen.i1208, 13
  %tag.i1763 = and i64 %aw1.i1205, 3
  %owned.not.i1764 = icmp eq i64 %tag.i1763, 0
  %or.cond2075 = select i1 %long.i1759, i1 true, i1 %owned.not.i1764
  br i1 %or.cond2075, label %archx_str_concat.exit1266, label %dup_heap.i1765

dup_heap.i1765:                                   ; preds = %ret_a_clone.i1262
  %dst.i1766 = call noalias align 16 ptr @malloc(i64 %alen.i1208)
  %isnull.i1767 = icmp eq ptr %dst.i1766, null
  br i1 %isnull.i1767, label %oom.i1774, label %copy.i1768

oom.i1774:                                        ; preds = %dup_heap.i1765
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1768:                                       ; preds = %dup_heap.i1765
  %src_i.i1769 = and i64 %aw1.i1205, -4
  %src.i1770 = inttoptr i64 %src_i.i1769 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1766, ptr nonnull align 4 %src.i1770, i64 %alen.i1208, i1 false)
  %dst_i.i1771 = ptrtoint ptr %dst.i1766 to i64
  %tagged.i1772 = or disjoint i64 %dst_i.i1771, 1
  %out.i1773 = insertvalue %ArchxStr %common.ret.op.i1183, i64 %tagged.i1772, 1
  br label %archx_str_concat.exit1266

calc_tot.i1213:                                   ; preds = %chk_bz.i1211
  %tot.i1214 = add nuw nsw i64 %blen.i1209, %alen.i1208
  %too_big.i1215 = icmp samesign ugt i64 %tot.i1214, 2147483647
  br i1 %too_big.i1215, label %oom.i1244, label %mat_a.i1216

oom.i1244:                                        ; preds = %alloc_heap.i1230, %calc_tot.i1213
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1216:                                      ; preds = %calc_tot.i1213
  %ashort.i1217 = icmp samesign ult i64 %alen.i1208, 13
  br i1 %ashort.i1217, label %mat_a_short.i1258, label %mat_a_long.i1218

mat_a_short.i1258:                                ; preds = %mat_a.i1216
  %ap4.i1259 = lshr i64 %aw0.i1204, 32
  %ap4_32.i1260 = trunc nuw i64 %ap4.i1259 to i32
  store i32 %ap4_32.i1260, ptr %atmp.i1201, align 4
  %atmp4.i1261 = getelementptr inbounds nuw i8, ptr %atmp.i1201, i64 4
  store i64 %aw1.i1205, ptr %atmp4.i1261, align 4
  br label %mat_b.i1221

mat_a_long.i1218:                                 ; preds = %mat_a.i1216
  %araw.i1219 = and i64 %aw1.i1205, -4
  %alptr.i1220 = inttoptr i64 %araw.i1219 to ptr
  br label %mat_b.i1221

mat_b.i1221:                                      ; preds = %mat_a_long.i1218, %mat_a_short.i1258
  %aptr.i1222 = phi ptr [ %atmp.i1201, %mat_a_short.i1258 ], [ %alptr.i1220, %mat_a_long.i1218 ]
  %bshort.i1223 = icmp samesign ult i64 %blen.i1209, 13
  br i1 %bshort.i1223, label %mat_b_short.i1254, label %mat_b_long.i1224

mat_b_short.i1254:                                ; preds = %mat_b.i1221
  %bp4.i1255 = lshr i64 %bw0.i1206, 32
  %bp4_32.i1256 = trunc nuw i64 %bp4.i1255 to i32
  store i32 %bp4_32.i1256, ptr %btmp.i1202, align 4
  %btmp4.i1257 = getelementptr inbounds nuw i8, ptr %btmp.i1202, i64 4
  store i64 %bw1.i1207, ptr %btmp4.i1257, align 4
  br label %build.i1227

mat_b_long.i1224:                                 ; preds = %mat_b.i1221
  %braw.i1225 = and i64 %bw1.i1207, -4
  %blptr.i1226 = inttoptr i64 %braw.i1225 to ptr
  br label %build.i1227

build.i1227:                                      ; preds = %mat_b_long.i1224, %mat_b_short.i1254
  %bptr.i1228 = phi ptr [ %btmp.i1202, %mat_b_short.i1254 ], [ %blptr.i1226, %mat_b_long.i1224 ]
  %fits_sso.i1229 = icmp samesign ult i64 %tot.i1214, 13
  br i1 %fits_sso.i1229, label %build_sso.i1245, label %alloc_heap.i1230

build_sso.i1245:                                  ; preds = %build.i1227
  %out_sso8.i1246 = getelementptr inbounds nuw i8, ptr %out_sso.i1203, i64 8
  %tot32.i1247 = trunc nuw nsw i64 %tot.i1214 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i1203, i8 0, i64 16, i1 false)
  store i32 %tot32.i1247, ptr %out_sso.i1203, align 8
  %sso_dst_a.i1248 = getelementptr inbounds nuw i8, ptr %out_sso.i1203, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1248, ptr nonnull align 1 %aptr.i1222, i64 %alen.i1208, i1 false)
  %sso_dst_b.i1249 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1248, i64 %alen.i1208
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i1249, ptr nonnull align 1 %bptr.i1228, i64 %blen.i1209, i1 false)
  %rw0.i1250 = load i64, ptr %out_sso.i1203, align 8
  %rw1.i1251 = load i64, ptr %out_sso8.i1246, align 8
  %rs0.i1252 = insertvalue %ArchxStr poison, i64 %rw0.i1250, 0
  %rs1.i1253 = insertvalue %ArchxStr %rs0.i1252, i64 %rw1.i1251, 1
  br label %archx_str_concat.exit1266

alloc_heap.i1230:                                 ; preds = %build.i1227
  %hp.i1231 = call noalias align 16 ptr @malloc(i64 %tot.i1214)
  %hnull.i1232 = icmp eq ptr %hp.i1231, null
  br i1 %hnull.i1232, label %oom.i1244, label %copy_long.i1233

copy_long.i1233:                                  ; preds = %alloc_heap.i1230
  %hp_i.i1234 = ptrtoint ptr %hp.i1231 to i64
  %htagged.i1235 = or disjoint i64 %hp_i.i1234, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i1231, ptr nonnull align 1 %aptr.i1222, i64 %alen.i1208, i1 false)
  %dst_b.i1236 = getelementptr inbounds nuw i8, ptr %hp.i1231, i64 %alen.i1208
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i1236, ptr nonnull align 1 %bptr.i1228, i64 %blen.i1209, i1 false)
  %pref32.i1237 = load i32, ptr %hp.i1231, align 16
  %pref64.i1238 = zext i32 %pref32.i1237 to i64
  %pref_sh.i1239 = shl nuw i64 %pref64.i1238, 32
  %w0_out.i1240 = or disjoint i64 %pref_sh.i1239, %tot.i1214
  %ls0.i1241 = insertvalue %ArchxStr poison, i64 %w0_out.i1240, 0
  %ls1.i1242 = insertvalue %ArchxStr %ls0.i1241, i64 %htagged.i1235, 1
  br label %archx_str_concat.exit1266

archx_str_concat.exit1266:                        ; preds = %copy.i1768, %ret_a_clone.i1262, %copy.i1749, %ret_b_clone.i1264, %build_sso.i1245, %copy_long.i1233
  %common.ret.op.i1243 = phi %ArchxStr [ %rs1.i1253, %build_sso.i1245 ], [ %ls1.i1242, %copy_long.i1233 ], [ %out.i1754, %copy.i1749 ], [ %common.ret.op.i.i1728, %ret_b_clone.i1264 ], [ %out.i1773, %copy.i1768 ], [ %common.ret.op.i1183, %ret_a_clone.i1262 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i1201)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1202)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i1203)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1776)
  %w0.i1777 = extractvalue %ArchxStr %common.ret.op.i1243, 0
  %w1.i1778 = extractvalue %ArchxStr %common.ret.op.i1243, 1
  %len.i1779 = and i64 %w0.i1777, 4294967295
  %short.i1780 = icmp samesign ult i64 %len.i1779, 13
  br i1 %short.i1780, label %emit.i1801, label %emit.thread.i1781

emit.thread.i1781:                                ; preds = %archx_str_concat.exit1266
  %raw.i1782 = and i64 %w1.i1778, -4
  %lptr.i1783 = inttoptr i64 %raw.i1782 to ptr
  br label %chk_nul.i1784

emit.i1801:                                       ; preds = %archx_str_concat.exit1266
  %p4.i1802 = lshr i64 %w0.i1777, 32
  %p4_32.i1803 = trunc nuw i64 %p4.i1802 to i32
  store i32 %p4_32.i1803, ptr %tmp.i1776, align 4
  %tmp4.i1804 = getelementptr inbounds nuw i8, ptr %tmp.i1776, i64 4
  store i64 %w1.i1778, ptr %tmp4.i1804, align 4
  %pos.not.i1805 = icmp eq i64 %len.i1779, 0
  br i1 %pos.not.i1805, label %do_nl.i1796, label %chk_nul.i1784

chk_nul.i1784:                                    ; preds = %emit.i1801, %emit.thread.i1781
  %data3.i1785 = phi ptr [ %lptr.i1783, %emit.thread.i1781 ], [ %tmp.i1776, %emit.i1801 ]
  %nul.i1786 = call ptr @memchr(ptr nonnull %data3.i1785, i32 0, i64 %len.i1779)
  %has_nul.not.i1787 = icmp eq ptr %nul.i1786, null
  br i1 %has_nul.not.i1787, label %fast_printf.i1798, label %byte_loop.i1788

fast_printf.i1798:                                ; preds = %chk_nul.i1784
  %len32.i1799 = trunc i64 %w0.i1777 to i32
  %np.i1800 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1799, ptr nonnull %data3.i1785)
  br label %archx_str_print.exit1806

byte_loop.i1788:                                  ; preds = %chk_nul.i1784, %byte_loop.i1788
  %bi.i1789 = phi i64 [ %bnext.i1794, %byte_loop.i1788 ], [ 0, %chk_nul.i1784 ]
  %bp.i1790 = getelementptr inbounds nuw i8, ptr %data3.i1785, i64 %bi.i1789
  %ch8.i1791 = load i8, ptr %bp.i1790, align 1
  %ch32.i1792 = zext i8 %ch8.i1791 to i32
  %pc.i1793 = call i32 @putchar(i32 %ch32.i1792)
  %bnext.i1794 = add nuw nsw i64 %bi.i1789, 1
  %exitcond.not.i1795 = icmp eq i64 %bnext.i1794, %len.i1779
  br i1 %exitcond.not.i1795, label %do_nl.i1796, label %byte_loop.i1788

do_nl.i1796:                                      ; preds = %byte_loop.i1788, %emit.i1801
  %nc.i1797 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1806

archx_str_print.exit1806:                         ; preds = %fast_printf.i1798, %do_nl.i1796
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1776)
  %tag.i276 = and i64 %w1.i1778, 1
  %owned.not.i277 = icmp eq i64 %tag.i276, 0
  %or.cond2076 = select i1 %short.i1780, i1 true, i1 %owned.not.i277
  br i1 %or.cond2076, label %archx_str_drop.exit281, label %do_free.i278

do_free.i278:                                     ; preds = %archx_str_print.exit1806
  %raw.i279 = and i64 %w1.i1778, -2
  %ptr.i280 = inttoptr i64 %raw.i279 to ptr
  call void @free(ptr %ptr.i280)
  br label %archx_str_drop.exit281

archx_str_drop.exit281:                           ; preds = %archx_str_print.exit1806, %do_free.i278
  %long.i284 = icmp samesign ult i64 %blen.i1209, 13
  %tag.i287 = and i64 %bw1.i1207, 1
  %owned.not.i288 = icmp eq i64 %tag.i287, 0
  %or.cond2077 = select i1 %long.i284, i1 true, i1 %owned.not.i288
  br i1 %or.cond2077, label %archx_str_drop.exit292, label %do_free.i289

do_free.i289:                                     ; preds = %archx_str_drop.exit281
  %raw.i290 = and i64 %bw1.i1207, -2
  %ptr.i291 = inttoptr i64 %raw.i290 to ptr
  call void @free(ptr %ptr.i291)
  br label %archx_str_drop.exit292

archx_str_drop.exit292:                           ; preds = %archx_str_drop.exit281, %do_free.i289
  %long.i295 = icmp samesign ult i64 %alen.i1208, 13
  %tag.i298 = and i64 %aw1.i1205, 1
  %owned.not.i299 = icmp eq i64 %tag.i298, 0
  %or.cond2078 = select i1 %long.i295, i1 true, i1 %owned.not.i299
  br i1 %or.cond2078, label %archx_str_drop.exit303, label %do_free.i300

do_free.i300:                                     ; preds = %archx_str_drop.exit292
  %raw.i301 = and i64 %aw1.i1205, -2
  %ptr.i302 = inttoptr i64 %raw.i301 to ptr
  call void @free(ptr %ptr.i302)
  br label %archx_str_drop.exit303

archx_str_drop.exit303:                           ; preds = %archx_str_drop.exit292, %do_free.i300
  %long.i306 = icmp samesign ult i64 %alen.i1152, 13
  %tag.i309 = and i64 %aw1.i1151, 1
  %owned.not.i310 = icmp eq i64 %tag.i309, 0
  %or.cond2079 = select i1 %long.i306, i1 true, i1 %owned.not.i310
  br i1 %or.cond2079, label %archx_str_drop.exit314, label %do_free.i311

do_free.i311:                                     ; preds = %archx_str_drop.exit303
  %raw.i312 = and i64 %aw1.i1151, -2
  %ptr.i313 = inttoptr i64 %raw.i312 to ptr
  call void @free(ptr %ptr.i313)
  br label %archx_str_drop.exit314

archx_str_drop.exit314:                           ; preds = %archx_str_drop.exit303, %do_free.i311
  %long.i317 = icmp samesign ult i64 %blen.i1098, 13
  %tag.i320 = and i64 %bw1.i1097, 1
  %owned.not.i321 = icmp eq i64 %tag.i320, 0
  %or.cond2080 = select i1 %long.i317, i1 true, i1 %owned.not.i321
  br i1 %or.cond2080, label %if.merge.4, label %do_free.i322

do_free.i322:                                     ; preds = %archx_str_drop.exit314
  %raw.i323 = and i64 %bw1.i1097, -2
  %ptr.i324 = inttoptr i64 %raw.i323 to ptr
  call void @free(ptr %ptr.i324)
  br label %if.merge.4

if.merge.4:                                       ; preds = %do_free.i322, %archx_str_drop.exit314, %archx_fn_find_gt.exit1677
  %t70 = extractvalue { i1, i64 } %common.ret.op.i1673, 0
  br i1 %t70, label %stropt.some.7, label %build.i1287.thread2199

stropt.some.7:                                    ; preds = %if.merge.4
  %t72 = extractvalue { i1, i64 } %common.ret.op.i1673, 1
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1808)
  %n32.i1809 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1808, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t72)
  %len.i1810 = sext i32 %n32.i1809 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1807)
  %z.i.i1811 = icmp slt i32 %n32.i1809, 1
  br i1 %z.i.i1811, label %stropt.done.8, label %chk_sso.i.i1812

oom.i.i1827:                                      ; preds = %alloc_heap.i.i1814
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1812:                                  ; preds = %stropt.some.7
  %short.i.i1813 = icmp samesign ult i32 %n32.i1809, 13
  br i1 %short.i.i1813, label %pack_sso.i.i1828, label %alloc_heap.i.i1814

pack_sso.i.i1828:                                 ; preds = %chk_sso.i.i1812
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1807, i8 0, i64 16, i1 false)
  store i32 %n32.i1809, ptr %sso.i.i1807, align 8
  %sso.i.i1807.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1807, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1807.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1808, i64 range(i64 -2147483648, 2147483650) %len.i1810, i1 false)
  %sso.i.i1807.0.sso.i.i1807.0.sso.i.i1807.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1830 = load i64, ptr %sso.i.i1807, align 8
  %sso.i.i1807.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1807, i64 8
  %sso.i.i1807.8.sso.i.i1807.8.sso.i.i1807.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1832 = load i64, ptr %sso.i.i1807.8.sroa_idx, align 8
  %ss0.i.i1833 = insertvalue %ArchxStr poison, i64 %sso.i.i1807.0.sso.i.i1807.0.sso.i.i1807.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1830, 0
  %ss1.i.i1834 = insertvalue %ArchxStr %ss0.i.i1833, i64 %sso.i.i1807.8.sso.i.i1807.8.sso.i.i1807.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1832, 1
  br label %stropt.done.8

alloc_heap.i.i1814:                               ; preds = %chk_sso.i.i1812
  %hp.i.i1815 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1810)
  %hnull.i.i1816 = icmp eq ptr %hp.i.i1815, null
  br i1 %hnull.i.i1816, label %oom.i.i1827, label %copy_long.i.i1817

copy_long.i.i1817:                                ; preds = %alloc_heap.i.i1814
  %hp_i.i.i1818 = ptrtoint ptr %hp.i.i1815 to i64
  %htagged.i.i1819 = or disjoint i64 %hp_i.i.i1818, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1815, ptr nonnull readonly align 8 %buf.i1808, i64 range(i64 -2147483648, 2147483650) %len.i1810, i1 false)
  %pref32.i.i1820 = load i32, ptr %hp.i.i1815, align 16
  %pref64.i.i1821 = zext i32 %pref32.i.i1820 to i64
  %pref_sh.i.i1822 = shl nuw i64 %pref64.i.i1821, 32
  %w0_out.i.i1823 = or disjoint i64 %pref_sh.i.i1822, %len.i1810
  %ls0.i.i1824 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1823, 0
  %ls1.i.i1825 = insertvalue %ArchxStr %ls0.i.i1824, i64 %htagged.i.i1819, 1
  br label %stropt.done.8

stropt.done.8:                                    ; preds = %copy_long.i.i1817, %pack_sso.i.i1828, %stropt.some.7
  %common.ret.op.i.i1826 = phi %ArchxStr [ %ss1.i.i1834, %pack_sso.i.i1828 ], [ %ls1.i.i1825, %copy_long.i.i1817 ], [ zeroinitializer, %stropt.some.7 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1807)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1808)
  %t73.fca.0.extract = extractvalue %ArchxStr %common.ret.op.i.i1826, 0
  %t73.fca.1.extract = extractvalue %ArchxStr %common.ret.op.i.i1826, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1268)
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %out_sso.i1269.sroa.6.sroa.5)
  %blen.i1272 = and i64 %t73.fca.0.extract, 4294967295
  %bz.i1274 = icmp eq i64 %blen.i1272, 0
  br i1 %bz.i1274, label %archx_str_concat.exit1320, label %calc_tot.i1275

calc_tot.i1275:                                   ; preds = %stropt.done.8
  %tot.i1276 = add nuw nsw i64 %blen.i1272, 8
  %too_big.i1277 = icmp samesign ugt i64 %blen.i1272, 2147483639
  br i1 %too_big.i1277, label %oom.i1304, label %mat_a.i1278

build.i1287.thread2199:                           ; preds = %if.merge.4
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1268)
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %out_sso.i1269.sroa.6.sroa.5)
  store i32 1701736270, ptr %btmp.i1268, align 4
  %btmp4.i13172206 = getelementptr inbounds nuw i8, ptr %btmp.i1268, i64 4
  store i64 0, ptr %btmp4.i13172206, align 4
  br label %build_sso.i1305

oom.i1304:                                        ; preds = %alloc_heap.i1290, %calc_tot.i1275
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1278:                                      ; preds = %calc_tot.i1275
  %bshort.i1283 = icmp samesign ult i64 %blen.i1272, 13
  br i1 %bshort.i1283, label %build.i1287, label %build.i1287.thread

build.i1287.thread:                               ; preds = %mat_a.i1278
  %braw.i1285 = and i64 %t73.fca.1.extract, -4
  %blptr.i1286 = inttoptr i64 %braw.i1285 to ptr
  br label %alloc_heap.i1290

build.i1287:                                      ; preds = %mat_a.i1278
  %bp4.i1315 = lshr i64 %t73.fca.0.extract, 32
  %bp4_32.i1316 = trunc nuw i64 %bp4.i1315 to i32
  store i32 %bp4_32.i1316, ptr %btmp.i1268, align 4
  %btmp4.i1317 = getelementptr inbounds nuw i8, ptr %btmp.i1268, i64 4
  store i64 %t73.fca.1.extract, ptr %btmp4.i1317, align 4
  %fits_sso.i1289 = icmp samesign ult i64 %blen.i1272, 5
  br i1 %fits_sso.i1289, label %build_sso.i1305, label %alloc_heap.i1290

build_sso.i1305:                                  ; preds = %build.i1287.thread2199, %build.i1287
  %tot.i1276201820252210 = phi i64 [ 12, %build.i1287.thread2199 ], [ %tot.i1276, %build.i1287 ]
  %stropt.res.71.sroa.3.02007201620272209 = phi i64 [ 0, %build.i1287.thread2199 ], [ %t73.fca.1.extract, %build.i1287 ]
  %blen.i12722008201520302208 = phi i64 [ 4, %build.i1287.thread2199 ], [ %blen.i1272, %build.i1287 ]
  store i32 0, ptr %out_sso.i1269.sroa.6.sroa.5, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %out_sso.i1269.sroa.6.sroa.5, ptr nonnull align 4 %btmp.i1268, i64 %blen.i12722008201520302208, i1 false)
  %out_sso.i1269.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i1276201820252210, 8319108853555789824
  %out_sso.i1269.sroa.6.sroa.5.0.out_sso.i1269.sroa.6.sroa.5.0.out_sso.i1269.sroa.6.sroa.5.0.out_sso.i1269.sroa.6.sroa.5.0.out_sso.i1269.sroa.6.8.rw1.i1311 = load i32, ptr %out_sso.i1269.sroa.6.sroa.5, align 4
  %out_sso.i1269.sroa.6.sroa.5.0.insert.ext = zext i32 %out_sso.i1269.sroa.6.sroa.5.0.out_sso.i1269.sroa.6.sroa.5.0.out_sso.i1269.sroa.6.sroa.5.0.out_sso.i1269.sroa.6.sroa.5.0.out_sso.i1269.sroa.6.8.rw1.i1311 to i64
  %out_sso.i1269.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i1269.sroa.6.sroa.5.0.insert.ext, 32
  %out_sso.i1269.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i1269.sroa.6.sroa.5.0.insert.shift, 1030188649
  %rs0.i1312 = insertvalue %ArchxStr poison, i64 %out_sso.i1269.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i1313 = insertvalue %ArchxStr %rs0.i1312, i64 %out_sso.i1269.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit1320

alloc_heap.i1290:                                 ; preds = %build.i1287.thread, %build.i1287
  %bptr.i12882198 = phi ptr [ %blptr.i1286, %build.i1287.thread ], [ %btmp.i1268, %build.i1287 ]
  %hp.i1291 = call noalias align 16 ptr @malloc(i64 %tot.i1276)
  %hnull.i1292 = icmp eq ptr %hp.i1291, null
  br i1 %hnull.i1292, label %oom.i1304, label %copy_long.i1293

copy_long.i1293:                                  ; preds = %alloc_heap.i1290
  %hp_i.i1294 = ptrtoint ptr %hp.i1291 to i64
  %htagged.i1295 = or disjoint i64 %hp_i.i1294, 1
  store i32 1936943469, ptr %hp.i1291, align 16
  %atmp.i1267.sroa.5.0.hp.i1291.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i1291, i64 4
  store i32 1030188649, ptr %atmp.i1267.sroa.5.0.hp.i1291.sroa_idx, align 4
  %dst_b.i1296 = getelementptr inbounds nuw i8, ptr %hp.i1291, i64 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %dst_b.i1296, ptr nonnull align 1 %bptr.i12882198, i64 %blen.i1272, i1 false)
  %w0_out.i1300 = or disjoint i64 %tot.i1276, 8319108853555789824
  %ls0.i1301 = insertvalue %ArchxStr poison, i64 %w0_out.i1300, 0
  %ls1.i1302 = insertvalue %ArchxStr %ls0.i1301, i64 %htagged.i1295, 1
  %0 = icmp samesign ult i64 %blen.i1272, 13
  br label %archx_str_concat.exit1320

archx_str_concat.exit1320:                        ; preds = %stropt.done.8, %build_sso.i1305, %copy_long.i1293
  %blen.i12722009 = phi i1 [ true, %build_sso.i1305 ], [ %0, %copy_long.i1293 ], [ true, %stropt.done.8 ]
  %stropt.res.71.sroa.3.02006 = phi i64 [ %stropt.res.71.sroa.3.02007201620272209, %build_sso.i1305 ], [ %t73.fca.1.extract, %copy_long.i1293 ], [ %t73.fca.1.extract, %stropt.done.8 ]
  %common.ret.op.i1303 = phi %ArchxStr [ %rs1.i1313, %build_sso.i1305 ], [ %ls1.i1302, %copy_long.i1293 ], [ { i64 8319108853555789832, i64 1030188649 }, %stropt.done.8 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1268)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %out_sso.i1269.sroa.6.sroa.5)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1837)
  %w0.i1838 = extractvalue %ArchxStr %common.ret.op.i1303, 0
  %w1.i1839 = extractvalue %ArchxStr %common.ret.op.i1303, 1
  %len.i1840 = and i64 %w0.i1838, 4294967295
  %short.i1841 = icmp samesign ult i64 %len.i1840, 13
  br i1 %short.i1841, label %emit.i1862, label %emit.thread.i1842

emit.thread.i1842:                                ; preds = %archx_str_concat.exit1320
  %raw.i1843 = and i64 %w1.i1839, -4
  %lptr.i1844 = inttoptr i64 %raw.i1843 to ptr
  br label %chk_nul.i1845

emit.i1862:                                       ; preds = %archx_str_concat.exit1320
  %p4.i1863 = lshr i64 %w0.i1838, 32
  %p4_32.i1864 = trunc nuw i64 %p4.i1863 to i32
  store i32 %p4_32.i1864, ptr %tmp.i1837, align 4
  %tmp4.i1865 = getelementptr inbounds nuw i8, ptr %tmp.i1837, i64 4
  store i64 %w1.i1839, ptr %tmp4.i1865, align 4
  %pos.not.i1866 = icmp eq i64 %len.i1840, 0
  br i1 %pos.not.i1866, label %do_nl.i1857, label %chk_nul.i1845

chk_nul.i1845:                                    ; preds = %emit.i1862, %emit.thread.i1842
  %data3.i1846 = phi ptr [ %lptr.i1844, %emit.thread.i1842 ], [ %tmp.i1837, %emit.i1862 ]
  %nul.i1847 = call ptr @memchr(ptr nonnull %data3.i1846, i32 0, i64 %len.i1840)
  %has_nul.not.i1848 = icmp eq ptr %nul.i1847, null
  br i1 %has_nul.not.i1848, label %fast_printf.i1859, label %byte_loop.i1849

fast_printf.i1859:                                ; preds = %chk_nul.i1845
  %len32.i1860 = trunc i64 %w0.i1838 to i32
  %np.i1861 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1860, ptr nonnull %data3.i1846)
  br label %archx_str_print.exit1867

byte_loop.i1849:                                  ; preds = %chk_nul.i1845, %byte_loop.i1849
  %bi.i1850 = phi i64 [ %bnext.i1855, %byte_loop.i1849 ], [ 0, %chk_nul.i1845 ]
  %bp.i1851 = getelementptr inbounds nuw i8, ptr %data3.i1846, i64 %bi.i1850
  %ch8.i1852 = load i8, ptr %bp.i1851, align 1
  %ch32.i1853 = zext i8 %ch8.i1852 to i32
  %pc.i1854 = call i32 @putchar(i32 %ch32.i1853)
  %bnext.i1855 = add nuw nsw i64 %bi.i1850, 1
  %exitcond.not.i1856 = icmp eq i64 %bnext.i1855, %len.i1840
  br i1 %exitcond.not.i1856, label %do_nl.i1857, label %byte_loop.i1849

do_nl.i1857:                                      ; preds = %byte_loop.i1849, %emit.i1862
  %nc.i1858 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1867

archx_str_print.exit1867:                         ; preds = %fast_printf.i1859, %do_nl.i1857
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1837)
  %tag.i331 = and i64 %w1.i1839, 1
  %owned.not.i332 = icmp eq i64 %tag.i331, 0
  %or.cond2081 = select i1 %short.i1841, i1 true, i1 %owned.not.i332
  br i1 %or.cond2081, label %archx_str_drop.exit336, label %do_free.i333

do_free.i333:                                     ; preds = %archx_str_print.exit1867
  %raw.i334 = and i64 %w1.i1839, -2
  %ptr.i335 = inttoptr i64 %raw.i334 to ptr
  call void @free(ptr %ptr.i335)
  br label %archx_str_drop.exit336

archx_str_drop.exit336:                           ; preds = %archx_str_print.exit1867, %do_free.i333
  %tag.i342 = and i64 %stropt.res.71.sroa.3.02006, 1
  %owned.not.i343 = icmp eq i64 %tag.i342, 0
  %or.cond2082 = select i1 %blen.i12722009, i1 true, i1 %owned.not.i343
  br i1 %or.cond2082, label %archx_str_drop.exit347, label %do_free.i344

do_free.i344:                                     ; preds = %archx_str_drop.exit336
  %raw.i345 = and i64 %stropt.res.71.sroa.3.02006, -2
  %ptr.i346 = inttoptr i64 %raw.i345 to ptr
  call void @free(ptr %ptr.i346)
  br label %archx_str_drop.exit347

archx_str_drop.exit347:                           ; preds = %archx_str_drop.exit336, %do_free.i344
  %t109 = call noalias align 16 dereferenceable_or_null(240) ptr @malloc(i64 240)
  %t110 = icmp eq ptr %t109, null
  br i1 %t110, label %alloc.oom.12, label %alloc.ok.11

alloc.oom.12:                                     ; preds = %archx_str_drop.exit347
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.11:                                      ; preds = %archx_str_drop.exit347
  store i64 0, ptr %t109, align 16
  %t109.repack20 = getelementptr inbounds nuw i8, ptr %t109, i64 8
  store i64 4615063718147915776, ptr %t109.repack20, align 8
  %t109.repack20.repack21 = getelementptr inbounds nuw i8, ptr %t109, i64 16
  %t112.repack24 = getelementptr inbounds nuw i8, ptr %t109, i64 48
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(32) %t109.repack20.repack21, i8 0, i64 32, i1 false)
  store i64 4622945017495814144, ptr %t112.repack24, align 16
  %t112.repack24.repack25 = getelementptr inbounds nuw i8, ptr %t109, i64 56
  %t113 = getelementptr inbounds nuw i8, ptr %t109, i64 80
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %t112.repack24.repack25, i8 0, i64 24, i1 false)
  store i64 1, ptr %t113, align 16
  %t113.repack28 = getelementptr inbounds nuw i8, ptr %t109, i64 88
  store i64 4616189618054758400, ptr %t113.repack28, align 8
  %t113.repack28.repack29 = getelementptr inbounds nuw i8, ptr %t109, i64 96
  store i64 4616189618054758400, ptr %t113.repack28.repack29, align 16
  %t113.repack28.repack30 = getelementptr inbounds nuw i8, ptr %t109, i64 104
  %t114 = getelementptr inbounds nuw i8, ptr %t109, i64 120
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %t113.repack28.repack30, i8 0, i64 16, i1 false)
  store i64 1, ptr %t114, align 8
  %t114.repack32 = getelementptr inbounds nuw i8, ptr %t109, i64 128
  store i64 4613937818241073152, ptr %t114.repack32, align 16
  %t114.repack32.repack33 = getelementptr inbounds nuw i8, ptr %t109, i64 136
  store i64 4617315517961601024, ptr %t114.repack32.repack33, align 8
  %t114.repack32.repack34 = getelementptr inbounds nuw i8, ptr %t109, i64 144
  %t115 = getelementptr inbounds nuw i8, ptr %t109, i64 160
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %t114.repack32.repack34, i8 0, i64 16, i1 false)
  store <6 x i64> <i64 2, i64 7453016942991900710, i64 ptrtoint (ptr @.str.1 to i64), i64 7, i64 9, i64 3>, ptr %t115, align 16
  %t116.repack44 = getelementptr inbounds nuw i8, ptr %t109, i64 208
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
  %tmp4.i1923 = getelementptr inbounds nuw i8, ptr %tmp.i1895, i64 4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(32) %t116.repack44, i8 0, i64 32, i1 false)
  %sso.i.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i, i64 4
  %sso.i.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i, i64 8
  %sso.i.i620.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i620.i, i64 4
  %sso.i.i620.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i620.i, i64 8
  br label %foreach.body.14

foreach.body.14:                                  ; preds = %alloc.ok.11, %archx_str_drop.exit358
  %foreach.idx.124.02135 = phi i64 [ 0, %alloc.ok.11 ], [ %t134, %archx_str_drop.exit358 ]
  %t127 = getelementptr inbounds nuw %ArchxEnum_Shape, ptr %t109, i64 %foreach.idx.124.02135
  %t128.unpack = load i64, ptr %t127, align 8
  %t128.elt52 = getelementptr inbounds nuw i8, ptr %t127, i64 8
  %t128.unpack53.unpack = load i64, ptr %t128.elt52, align 8
  %t128.unpack53.elt55 = getelementptr inbounds nuw i8, ptr %t127, i64 16
  %t128.unpack53.unpack56 = load i64, ptr %t128.unpack53.elt55, align 8
  %t128.unpack53.elt57 = getelementptr inbounds nuw i8, ptr %t127, i64 24
  %t128.unpack53.unpack58 = load i64, ptr %t128.unpack53.elt57, align 8
  %t128.unpack53.elt59 = getelementptr inbounds nuw i8, ptr %t127, i64 32
  %t128.unpack53.unpack60 = load i64, ptr %t128.unpack53.elt59, align 8
  %cond.i = icmp eq i64 %t128.unpack, 2
  br i1 %cond.i, label %v.2.i, label %archx_enum_clone_Shape.exit

v.2.i:                                            ; preds = %foreach.body.14
  %t2.fca.0.insert.i = insertvalue %ArchxStr poison, i64 %t128.unpack53.unpack, 0
  %t2.fca.1.insert.i = insertvalue %ArchxStr %t2.fca.0.insert.i, i64 %t128.unpack53.unpack56, 1
  %len.i.i = and i64 %t128.unpack53.unpack, 4294967295
  %long.i.i = icmp samesign ult i64 %len.i.i, 13
  %tag.i.i = and i64 %t128.unpack53.unpack56, 3
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond.i = select i1 %long.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond.i, label %archx_enum_clone_Shape.exit.thread, label %dup_heap.i.i

dup_heap.i.i:                                     ; preds = %v.2.i
  %dst.i.i = call noalias align 16 ptr @malloc(i64 %len.i.i)
  %isnull.i.i = icmp eq ptr %dst.i.i, null
  br i1 %isnull.i.i, label %oom.i.i1871, label %copy.i.i

oom.i.i1871:                                      ; preds = %dup_heap.i.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i:                                         ; preds = %dup_heap.i.i
  %src_i.i.i = and i64 %t128.unpack53.unpack56, -4
  %src.i.i = inttoptr i64 %src_i.i.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i, ptr nonnull align 4 %src.i.i, i64 %len.i.i, i1 false)
  %dst_i.i.i = ptrtoint ptr %dst.i.i to i64
  %tagged.i.i = or disjoint i64 %dst_i.i.i, 1
  %out.i.i = insertvalue %ArchxStr %t2.fca.1.insert.i, i64 %tagged.i.i, 1
  br label %archx_enum_clone_Shape.exit.thread

archx_enum_clone_Shape.exit.thread:               ; preds = %v.2.i, %copy.i.i
  %common.ret.op.i.i1870 = phi %ArchxStr [ %out.i.i, %copy.i.i ], [ %t2.fca.1.insert.i, %v.2.i ]
  %t3.fca.0.extract.i = extractvalue %ArchxStr %common.ret.op.i.i1870, 0
  %t3.fca.1.extract.i = extractvalue %ArchxStr %common.ret.op.i.i1870, 1
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i247.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i197.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i.sroa.6.sroa.5.sroa.0.i)
  %len.i.i.i = and i64 %t3.fca.0.extract.i, 4294967295
  %long.i.i.i = icmp samesign ult i64 %len.i.i.i, 13
  %tag.i.i.i = and i64 %t3.fca.1.extract.i, 3
  %owned.not.i.i.i = icmp eq i64 %tag.i.i.i, 0
  %or.cond.i.i = select i1 %long.i.i.i, i1 true, i1 %owned.not.i.i.i
  br i1 %or.cond.i.i, label %archx_enum_clone_Shape.exit.thread.i, label %dup_heap.i.i.i

archx_enum_clone_Shape.exit:                      ; preds = %foreach.body.14
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i247.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i197.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i.sroa.6.sroa.5.sroa.0.i)
  switch i64 %t128.unpack, label %archx_enum_drop_Shape.exit710.i [
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
  %out.i.i.i = insertvalue %ArchxStr %common.ret.op.i.i1870, i64 %tagged.i.i.i, 1
  %.pre = extractvalue %ArchxStr %common.ret.op.i.i1870, 0
  %.pre2176 = and i64 %.pre, 4294967295
  br label %archx_enum_clone_Shape.exit.thread.i

archx_enum_clone_Shape.exit.thread.i:             ; preds = %copy.i.i.i, %archx_enum_clone_Shape.exit.thread
  %tag.i574.i.pre-phi = phi i64 [ 1, %copy.i.i.i ], [ %tag.i.i.i, %archx_enum_clone_Shape.exit.thread ]
  %len.i569.i.pre-phi = phi i64 [ %.pre2176, %copy.i.i.i ], [ %len.i.i.i, %archx_enum_clone_Shape.exit.thread ]
  %t3.fca.1.extract.i.i.pre-phi = phi i64 [ %tagged.i.i.i, %copy.i.i.i ], [ %t3.fca.1.extract.i, %archx_enum_clone_Shape.exit.thread ]
  %t3.fca.0.extract.i.i.pre-phi = phi i64 [ %.pre, %copy.i.i.i ], [ %t3.fca.0.extract.i, %archx_enum_clone_Shape.exit.thread ]
  %common.ret.op.i.i.i = phi %ArchxStr [ %out.i.i.i, %copy.i.i.i ], [ %common.ret.op.i.i1870, %archx_enum_clone_Shape.exit.thread ]
  %long.i570.i = icmp samesign ult i64 %len.i569.i.pre-phi, 13
  %owned.not.i575.i = icmp eq i64 %tag.i574.i.pre-phi, 0
  %or.cond745.i = select i1 %long.i570.i, i1 true, i1 %owned.not.i575.i
  br i1 %or.cond745.i, label %archx_str_clone.exit.i1894, label %dup_heap.i.i1885

pat.enum.ok.2.i:                                  ; preds = %archx_enum_clone_Shape.exit
  %1 = bitcast i64 %t128.unpack53.unpack to double
  %t10.i = fcmp ult double %1, 1.000000e+01
  %t25.i = call fastcc { i64, i64 } @archx_str_from_float(double %1)
  %newret = extractvalue { i64, i64 } %t25.i, 0
  %newret2228 = extractvalue { i64, i64 } %t25.i, 1
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
  br i1 %too_big.i.i, label %oom.i.i1883, label %mat_a.i.i

oom.i.i1883:                                      ; preds = %build.i.i, %calc_tot.i.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i.i:                                        ; preds = %calc_tot.i.i
  %bshort.i.i = icmp samesign ult i64 %blen.i162.i, 13
  br i1 %bshort.i.i, label %mat_b_short.i.i, label %mat_b_long.i.i

mat_b_short.i.i:                                  ; preds = %mat_a.i.i
  %bp4.i.i = lshr i64 %newret, 32
  %bp4_32.i.i = trunc nuw i64 %bp4.i.i to i32
  store i32 %bp4_32.i.i, ptr %btmp.i.i, align 4
  store i64 %newret2228, ptr %btmp4.i.i, align 4
  br label %build.i.i

mat_b_long.i.i:                                   ; preds = %mat_a.i.i
  %braw.i.i = and i64 %newret2228, -4
  %blptr.i.i = inttoptr i64 %braw.i.i to ptr
  br label %build.i.i

build.i.i:                                        ; preds = %mat_b_long.i.i, %mat_b_short.i.i
  %bptr.i.i = phi ptr [ %btmp.i.i, %mat_b_short.i.i ], [ %blptr.i.i, %mat_b_long.i.i ]
  %hp.i.i1873 = call noalias align 16 ptr @malloc(i64 %tot.i.i)
  %hnull.i.i1874 = icmp eq ptr %hp.i.i1873, null
  br i1 %hnull.i.i1874, label %oom.i.i1883, label %archx_str_concat.exit.i

archx_str_concat.exit.i:                          ; preds = %build.i.i
  %hp_i.i.i1875 = ptrtoint ptr %hp.i.i1873 to i64
  %htagged.i.i1876 = or disjoint i64 %hp_i.i.i1875, 1
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(13) %hp.i.i1873, ptr noundef nonnull align 4 dereferenceable(13) @.str.0, i64 13, i1 false)
  %dst_b.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i1873, i64 13
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i.i, ptr nonnull align 1 %bptr.i.i, i64 %blen.i162.i, i1 false)
  %w0_out.i.i1877 = or disjoint i64 %tot.i.i, 7454127449735954432
  %ls0.i.i1878 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1877, 0
  %ls1.i.i1879 = insertvalue %ArchxStr %ls0.i.i1878, i64 %htagged.i.i1876, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i.i)
  %tag.i.i1880 = and i64 %newret2228, 1
  %owned.not.i.i1881 = icmp eq i64 %tag.i.i1880, 0
  %or.cond.i1882 = select i1 %bshort.i.i, i1 true, i1 %owned.not.i.i1881
  br i1 %or.cond.i1882, label %archx_fn_describe_shape.exit, label %do_free.i.i

do_free.i.i:                                      ; preds = %archx_str_concat.exit.i
  %raw.i.i = and i64 %newret2228, -2
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  call void @free(ptr %ptr.i.i)
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

oom.i187.i:                                       ; preds = %alloc_heap.i.i1884, %calc_tot.i164.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i167.i:                                     ; preds = %calc_tot.i164.i
  %bshort.i168.i = icmp samesign ult i64 %blen.i162.i, 13
  br i1 %bshort.i168.i, label %build.i172.i, label %build.i172.thread.i

build.i172.thread.i:                              ; preds = %mat_a.i167.i
  %braw.i170.i = and i64 %newret2228, -4
  %blptr.i171.i = inttoptr i64 %braw.i170.i to ptr
  br label %alloc_heap.i.i1884

build.i172.i:                                     ; preds = %mat_a.i167.i
  %bp4.i189.i = lshr i64 %newret, 32
  %bp4_32.i190.i = trunc nuw i64 %bp4.i189.i to i32
  store i32 %bp4_32.i190.i, ptr %btmp.i159.i, align 4
  store i64 %newret2228, ptr %btmp4.i191.i, align 4
  %fits_sso.i.i = icmp samesign ult i64 %blen.i162.i, 6
  br i1 %fits_sso.i.i, label %archx_str_concat.exit194.thread769.i, label %alloc_heap.i.i1884

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

alloc_heap.i.i1884:                               ; preds = %build.i172.i, %build.i172.thread.i
  %bptr.i173768.i = phi ptr [ %blptr.i171.i, %build.i172.thread.i ], [ %btmp.i159.i, %build.i172.i ]
  %hp.i174.i = call noalias align 16 ptr @malloc(i64 %tot.i165.i)
  %hnull.i175.i = icmp eq ptr %hp.i174.i, null
  br i1 %hnull.i175.i, label %oom.i187.i, label %archx_str_concat.exit194.i

archx_str_concat.exit194.i:                       ; preds = %alloc_heap.i.i1884
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
  %tag.i65.i = and i64 %newret2228, 1
  %owned.not.i66.i = icmp eq i64 %tag.i65.i, 0
  %or.cond742.i = select i1 %bshort.i168.i, i1 true, i1 %owned.not.i66.i
  br i1 %or.cond742.i, label %archx_fn_describe_shape.exit, label %do_free.i67.i

do_free.i67.i:                                    ; preds = %archx_str_concat.exit194.i
  %raw.i68.i = and i64 %newret2228, -2
  %ptr.i69.i = inttoptr i64 %raw.i68.i to ptr
  call void @free(ptr %ptr.i69.i)
  br label %archx_fn_describe_shape.exit

pat.enum.ok.8.i:                                  ; preds = %archx_enum_clone_Shape.exit
  %2 = bitcast i64 %t128.unpack53.unpack to double
  %3 = bitcast i64 %t128.unpack53.unpack56 to double
  %t40.i = fcmp oeq double %2, %3
  %t41.i = fmul double %2, %3
  %t42.i = call fastcc { i64, i64 } @archx_str_from_float(double %t41.i)
  %newret2230 = extractvalue { i64, i64 } %t42.i, 0
  %newret2232 = extractvalue { i64, i64 } %t42.i, 1
  %blen.i200.i = and i64 %newret2230, 4294967295
  %bz.i201.i = icmp eq i64 %blen.i200.i, 0
  br i1 %t40.i, label %match.body.9.i, label %pat.enum.ok.12.i

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
  %braw.i209.i = and i64 %newret2232, -4
  %blptr.i210.i = inttoptr i64 %braw.i209.i to ptr
  br label %alloc_heap.i214.i

build.i211.i:                                     ; preds = %mat_a.i205.i
  %bp4.i239.i = lshr i64 %newret2230, 32
  %bp4_32.i240.i = trunc nuw i64 %bp4.i239.i to i32
  store i32 %bp4_32.i240.i, ptr %btmp.i196.i, align 4
  store i64 %newret2232, ptr %btmp4.i241.i, align 4
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
  %tag.i76.i = and i64 %newret2232, 1
  %owned.not.i77.i = icmp eq i64 %tag.i76.i, 0
  %or.cond743.i = select i1 %bshort.i207.i, i1 true, i1 %owned.not.i77.i
  br i1 %or.cond743.i, label %archx_fn_describe_shape.exit, label %do_free.i78.i

do_free.i78.i:                                    ; preds = %archx_str_concat.exit244.i
  %raw.i79.i = and i64 %newret2232, -2
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
  %braw.i259.i = and i64 %newret2232, -4
  %blptr.i260.i = inttoptr i64 %braw.i259.i to ptr
  br label %alloc_heap.i264.i

build.i261.i:                                     ; preds = %mat_a.i255.i
  %bp4.i289.i = lshr i64 %newret2230, 32
  %bp4_32.i290.i = trunc nuw i64 %bp4.i289.i to i32
  store i32 %bp4_32.i290.i, ptr %btmp.i246.i, align 4
  store i64 %newret2232, ptr %btmp4.i291.i, align 4
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
  %tag.i87.i = and i64 %newret2232, 1
  %owned.not.i88.i = icmp eq i64 %tag.i87.i, 0
  %or.cond744.i = select i1 %bshort.i257.i, i1 true, i1 %owned.not.i88.i
  br i1 %or.cond744.i, label %archx_fn_describe_shape.exit, label %do_free.i89.i

do_free.i89.i:                                    ; preds = %archx_str_concat.exit294.i
  %raw.i90.i = and i64 %newret2232, -2
  %ptr.i91.i = inttoptr i64 %raw.i90.i to ptr
  call void @free(ptr %ptr.i91.i)
  br label %archx_fn_describe_shape.exit

dup_heap.i.i1885:                                 ; preds = %archx_enum_clone_Shape.exit.thread.i
  %dst.i.i1886 = call noalias align 16 ptr @malloc(i64 %len.i569.i.pre-phi)
  %isnull.i.i1887 = icmp eq ptr %dst.i.i1886, null
  br i1 %isnull.i.i1887, label %oom.i576.i, label %copy.i.i1888

oom.i576.i:                                       ; preds = %dup_heap.i.i1885
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i1888:                                     ; preds = %dup_heap.i.i1885
  %src_i.i.i1889 = and i64 %t3.fca.1.extract.i.i.pre-phi, -4
  %src.i.i1890 = inttoptr i64 %src_i.i.i1889 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i1886, ptr nonnull align 4 %src.i.i1890, i64 %len.i569.i.pre-phi, i1 false)
  %dst_i.i.i1891 = ptrtoint ptr %dst.i.i1886 to i64
  %tagged.i.i1892 = or disjoint i64 %dst_i.i.i1891, 1
  %.pre2178 = extractvalue %ArchxStr %common.ret.op.i.i.i, 0
  %.pre2180 = and i64 %.pre2178, 4294967295
  br label %archx_str_clone.exit.i1894

archx_str_clone.exit.i1894:                       ; preds = %copy.i.i1888, %archx_enum_clone_Shape.exit.thread.i
  %alen.i.i.pre-phi = phi i64 [ %.pre2180, %copy.i.i1888 ], [ %len.i569.i.pre-phi, %archx_enum_clone_Shape.exit.thread.i ]
  %aw1.i.i.pre-phi = phi i64 [ %tagged.i.i1892, %copy.i.i1888 ], [ %t3.fca.1.extract.i.i.pre-phi, %archx_enum_clone_Shape.exit.thread.i ]
  %aw0.i.i.pre-phi = phi i64 [ %.pre2178, %copy.i.i1888 ], [ %t3.fca.0.extract.i.i.pre-phi, %archx_enum_clone_Shape.exit.thread.i ]
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i295.i)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i297.i)
  %az.i.i = icmp eq i64 %alen.i.i.pre-phi, 0
  br i1 %az.i.i, label %archx_str_concat.exit332.i, label %chk_bz.i.i

chk_bz.i.i:                                       ; preds = %archx_str_clone.exit.i1894
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

archx_str_concat.exit332.i:                       ; preds = %copy_long.i310.i, %build_sso.i322.i, %archx_str_clone.exit.i1894
  %common.ret.op.i320.i = phi %ArchxStr [ %rs1.i330.i, %build_sso.i322.i ], [ %ls1.i319.i, %copy_long.i310.i ], [ { i64 274877906945, i64 0 }, %archx_str_clone.exit.i1894 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i295.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i297.i)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i.i)
  %n32.i.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t128.unpack53.unpack58)
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
  %n32.i622.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i621.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t128.unpack53.unpack60)
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
  %t90.i = icmp eq i64 %t128.unpack, 3
  call void @llvm.assume(i1 %t90.i)
  br label %archx_fn_describe_shape.exit

archx_fn_describe_shape.exit:                     ; preds = %archx_str_concat.exit.thread.i, %archx_str_concat.exit.i, %do_free.i.i, %archx_str_concat.exit194.thread.i, %archx_str_concat.exit194.thread769.i, %archx_str_concat.exit194.i, %do_free.i67.i, %archx_str_concat.exit244.thread.i, %archx_str_concat.exit244.thread780.i, %archx_str_concat.exit244.i, %do_free.i78.i, %archx_str_concat.exit294.thread.i, %archx_str_concat.exit294.thread791.i, %archx_str_concat.exit294.i, %do_free.i89.i, %v.2.i689.i, %do_free.i.i695.i, %archx_enum_drop_Shape.exit710.i
  %dst.sroa.5.0.i2042 = phi i64 [ %t128.unpack53.unpack56, %archx_enum_drop_Shape.exit710.i ], [ %t128.unpack53.unpack56, %archx_str_concat.exit.thread.i ], [ %t128.unpack53.unpack56, %archx_str_concat.exit.i ], [ %t128.unpack53.unpack56, %do_free.i.i ], [ %t128.unpack53.unpack56, %archx_str_concat.exit194.thread.i ], [ %t128.unpack53.unpack56, %archx_str_concat.exit194.i ], [ %t128.unpack53.unpack56, %do_free.i67.i ], [ %t128.unpack53.unpack56, %archx_str_concat.exit244.thread.i ], [ %t128.unpack53.unpack56, %archx_str_concat.exit244.i ], [ %t128.unpack53.unpack56, %do_free.i78.i ], [ %t128.unpack53.unpack56, %archx_str_concat.exit294.thread.i ], [ %t128.unpack53.unpack56, %archx_str_concat.exit294.i ], [ %t128.unpack53.unpack56, %do_free.i89.i ], [ %t3.fca.1.extract.i, %v.2.i689.i ], [ %t3.fca.1.extract.i, %do_free.i.i695.i ], [ %t128.unpack53.unpack56, %archx_str_concat.exit194.thread769.i ], [ %t128.unpack53.unpack56, %archx_str_concat.exit244.thread780.i ], [ %t128.unpack53.unpack56, %archx_str_concat.exit294.thread791.i ]
  %dst.sroa.2.0.i2040 = phi i64 [ %t128.unpack53.unpack, %archx_enum_drop_Shape.exit710.i ], [ %t128.unpack53.unpack, %archx_str_concat.exit.thread.i ], [ %t128.unpack53.unpack, %archx_str_concat.exit.i ], [ %t128.unpack53.unpack, %do_free.i.i ], [ %t128.unpack53.unpack, %archx_str_concat.exit194.thread.i ], [ %t128.unpack53.unpack, %archx_str_concat.exit194.i ], [ %t128.unpack53.unpack, %do_free.i67.i ], [ %t128.unpack53.unpack, %archx_str_concat.exit244.thread.i ], [ %t128.unpack53.unpack, %archx_str_concat.exit244.i ], [ %t128.unpack53.unpack, %do_free.i78.i ], [ %t128.unpack53.unpack, %archx_str_concat.exit294.thread.i ], [ %t128.unpack53.unpack, %archx_str_concat.exit294.i ], [ %t128.unpack53.unpack, %do_free.i89.i ], [ %t3.fca.0.extract.i, %v.2.i689.i ], [ %t3.fca.0.extract.i, %do_free.i.i695.i ], [ %t128.unpack53.unpack, %archx_str_concat.exit194.thread769.i ], [ %t128.unpack53.unpack, %archx_str_concat.exit244.thread780.i ], [ %t128.unpack53.unpack, %archx_str_concat.exit294.thread791.i ]
  %common.ret.op.i1872 = phi %ArchxStr [ { i64 8390326386350358533, i64 121 }, %archx_enum_drop_Shape.exit710.i ], [ { i64 7454127449735954445, i64 ptrtoint (ptr @.str.0 to i64) }, %archx_str_concat.exit.thread.i ], [ %ls1.i.i1879, %archx_str_concat.exit.i ], [ %ls1.i.i1879, %do_free.i.i ], [ { i64 7165905831022559239, i64 3827052 }, %archx_str_concat.exit194.thread.i ], [ %common.ret.op.i186.i, %archx_str_concat.exit194.i ], [ %common.ret.op.i186.i, %do_free.i67.i ], [ { i64 7022643932689334279, i64 3827058 }, %archx_str_concat.exit244.thread.i ], [ %common.ret.op.i227.i, %archx_str_concat.exit244.i ], [ %common.ret.op.i227.i, %do_free.i78.i ], [ { i64 8386658471394672645, i64 58 }, %archx_str_concat.exit294.thread.i ], [ %common.ret.op.i277.i, %archx_str_concat.exit294.i ], [ %common.ret.op.i277.i, %do_free.i89.i ], [ %common.ret.op.i495735.i, %v.2.i689.i ], [ %common.ret.op.i495735.i, %do_free.i.i695.i ], [ %common.ret.op.i186773.i, %archx_str_concat.exit194.thread769.i ], [ %common.ret.op.i227784.i, %archx_str_concat.exit244.thread780.i ], [ %common.ret.op.i277795.i, %archx_str_concat.exit294.thread791.i ]
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i247.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i197.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1895)
  %w0.i1896 = extractvalue %ArchxStr %common.ret.op.i1872, 0
  %w1.i1897 = extractvalue %ArchxStr %common.ret.op.i1872, 1
  %len.i1898 = and i64 %w0.i1896, 4294967295
  %short.i1899 = icmp samesign ult i64 %len.i1898, 13
  br i1 %short.i1899, label %emit.i1920, label %emit.thread.i1900

emit.thread.i1900:                                ; preds = %archx_fn_describe_shape.exit
  %raw.i1901 = and i64 %w1.i1897, -4
  %lptr.i1902 = inttoptr i64 %raw.i1901 to ptr
  br label %chk_nul.i1903

emit.i1920:                                       ; preds = %archx_fn_describe_shape.exit
  %p4.i1921 = lshr i64 %w0.i1896, 32
  %p4_32.i1922 = trunc nuw i64 %p4.i1921 to i32
  store i32 %p4_32.i1922, ptr %tmp.i1895, align 4
  store i64 %w1.i1897, ptr %tmp4.i1923, align 4
  %pos.not.i1924 = icmp eq i64 %len.i1898, 0
  br i1 %pos.not.i1924, label %do_nl.i1915, label %chk_nul.i1903

chk_nul.i1903:                                    ; preds = %emit.i1920, %emit.thread.i1900
  %data3.i1904 = phi ptr [ %lptr.i1902, %emit.thread.i1900 ], [ %tmp.i1895, %emit.i1920 ]
  %nul.i1905 = call ptr @memchr(ptr nonnull %data3.i1904, i32 0, i64 %len.i1898)
  %has_nul.not.i1906 = icmp eq ptr %nul.i1905, null
  br i1 %has_nul.not.i1906, label %fast_printf.i1917, label %byte_loop.i1907

fast_printf.i1917:                                ; preds = %chk_nul.i1903
  %len32.i1918 = trunc i64 %w0.i1896 to i32
  %np.i1919 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1918, ptr nonnull %data3.i1904)
  br label %archx_str_print.exit1925

byte_loop.i1907:                                  ; preds = %chk_nul.i1903, %byte_loop.i1907
  %bi.i1908 = phi i64 [ %bnext.i1913, %byte_loop.i1907 ], [ 0, %chk_nul.i1903 ]
  %bp.i1909 = getelementptr inbounds nuw i8, ptr %data3.i1904, i64 %bi.i1908
  %ch8.i1910 = load i8, ptr %bp.i1909, align 1
  %ch32.i1911 = zext i8 %ch8.i1910 to i32
  %pc.i1912 = call i32 @putchar(i32 %ch32.i1911)
  %bnext.i1913 = add nuw nsw i64 %bi.i1908, 1
  %exitcond.not.i1914 = icmp eq i64 %bnext.i1913, %len.i1898
  br i1 %exitcond.not.i1914, label %do_nl.i1915, label %byte_loop.i1907

do_nl.i1915:                                      ; preds = %byte_loop.i1907, %emit.i1920
  %nc.i1916 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1925

archx_str_print.exit1925:                         ; preds = %fast_printf.i1917, %do_nl.i1915
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1895)
  %tag.i353 = and i64 %w1.i1897, 1
  %owned.not.i354 = icmp eq i64 %tag.i353, 0
  %or.cond2083 = select i1 %short.i1899, i1 true, i1 %owned.not.i354
  br i1 %or.cond2083, label %archx_str_drop.exit358, label %do_free.i355

do_free.i355:                                     ; preds = %archx_str_print.exit1925
  %raw.i356 = and i64 %w1.i1897, -2
  %ptr.i357 = inttoptr i64 %raw.i356 to ptr
  call void @free(ptr %ptr.i357)
  br label %archx_str_drop.exit358

archx_str_drop.exit358:                           ; preds = %archx_str_print.exit1925, %do_free.i355
  %t134 = add nuw nsw i64 %foreach.idx.124.02135, 1
  %exitcond.not = icmp eq i64 %t134, 6
  br i1 %exitcond.not, label %archx_vec_drop_U5_Shape.exit, label %foreach.body.14

archx_vec_drop_U5_Shape.exit:                     ; preds = %archx_str_drop.exit358
  call void @free(ptr nonnull %t109)
  br i1 %cond.i, label %v.2.i1935, label %archx_region_release_from.exit

v.2.i1935:                                        ; preds = %archx_vec_drop_U5_Shape.exit
  %len.i.i1936 = and i64 %dst.sroa.2.0.i2040, 4294967295
  %long.i.i1937 = icmp samesign ult i64 %len.i.i1936, 13
  %tag.i.i1938 = and i64 %dst.sroa.5.0.i2042, 1
  %owned.not.i.i1939 = icmp eq i64 %tag.i.i1938, 0
  %or.cond.i1940 = select i1 %long.i.i1937, i1 true, i1 %owned.not.i.i1939
  br i1 %or.cond.i1940, label %archx_region_release_from.exit, label %do_free.i.i1941

do_free.i.i1941:                                  ; preds = %v.2.i1935
  %raw.i.i1942 = and i64 %dst.sroa.5.0.i2042, -2
  %ptr.i.i1943 = inttoptr i64 %raw.i.i1942 to ptr
  call void @free(ptr %ptr.i.i1943)
  br label %archx_region_release_from.exit

archx_region_release_from.exit:                   ; preds = %archx_vec_drop_U5_Shape.exit, %v.2.i1935, %do_free.i.i1941
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
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str)
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
