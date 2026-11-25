; ModuleID = 'ci/out/enums_matching.ll'
source_filename = "ci/out/enums_matching.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxStr = type { i64, i64 }
%ArchxEnum_Shape = type { i64, [4 x i64] }

@.fmt.g15 = private unnamed_addr constant [6 x i8] c"%.15g\00", align 1
@.str.0 = private unnamed_addr constant [14 x i8] c"large-circle:\00", align 4
@.str.1 = private unnamed_addr constant [39 x i8] c"long_region_allocated_shape_identifier\00", align 4
@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@.err.bounds = private unnamed_addr constant [63 x i8] c"archx runtime panic: index %lld out of bounds for length %lld\0A\00", align 1
@.fmt.i64s = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@str = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %tmp.i1875 = alloca [12 x i8], align 4
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
  %tmp.i1832 = alloca [12 x i8], align 4
  %sso.i.i1802 = alloca [16 x i8], align 8
  %buf.i1803 = alloca [32 x i8], align 8
  %tmp.i1771 = alloca [12 x i8], align 4
  %sso.i.i1704 = alloca [16 x i8], align 8
  %buf.i1705 = alloca [32 x i8], align 8
  %sso.i.i1673 = alloca [16 x i8], align 8
  %buf.i1674 = alloca [32 x i8], align 8
  %tmp.i1618 = alloca [12 x i8], align 4
  %sso.i.i1551 = alloca [16 x i8], align 8
  %buf.i1552 = alloca [32 x i8], align 8
  %sso.i.i1479 = alloca [16 x i8], align 8
  %buf.i1480 = alloca [32 x i8], align 8
  %sso.i.i1448 = alloca [16 x i8], align 8
  %buf.i1449 = alloca [32 x i8], align 8
  %tmp.i = alloca [12 x i8], align 4
  %sso.i.i1377 = alloca [16 x i8], align 8
  %buf.i1378 = alloca [32 x i8], align 8
  %sso.i.i1319 = alloca [16 x i8], align 8
  %buf.i1320 = alloca [32 x i8], align 8
  %sso.i.i = alloca [16 x i8], align 8
  %buf.i = alloca [32 x i8], align 8
  %btmp.i1263 = alloca [12 x i8], align 4
  %out_sso.i1264.sroa.6.sroa.5 = alloca i32, align 4
  %atmp.i1196 = alloca [12 x i8], align 4
  %btmp.i1197 = alloca [12 x i8], align 4
  %out_sso.i1198 = alloca [16 x i8], align 8
  %atmp.i1142 = alloca [12 x i8], align 4
  %out_sso.i1144 = alloca [16 x i8], align 8
  %btmp.i1089 = alloca [12 x i8], align 4
  %out_sso.i1090.sroa.6.sroa.5.sroa.0 = alloca i48, align 8
  %atmp.i1022 = alloca [12 x i8], align 4
  %btmp.i1023 = alloca [12 x i8], align 4
  %out_sso.i1024 = alloca [16 x i8], align 8
  %atmp.i968 = alloca [12 x i8], align 4
  %out_sso.i970 = alloca [16 x i8], align 8
  %atmp.i914 = alloca [12 x i8], align 4
  %out_sso.i916 = alloca [16 x i8], align 8
  %atmp.i860 = alloca [12 x i8], align 4
  %out_sso.i862 = alloca [16 x i8], align 8
  %atmp.i806 = alloca [12 x i8], align 4
  %out_sso.i808 = alloca [16 x i8], align 8
  %atmp.i752 = alloca [12 x i8], align 4
  %out_sso.i754 = alloca [16 x i8], align 8
  %atmp.i686 = alloca [12 x i8], align 4
  %btmp.i687 = alloca [12 x i8], align 4
  %out_sso.i688 = alloca [16 x i8], align 8
  %atmp.i632 = alloca [12 x i8], align 4
  %out_sso.i634 = alloca [16 x i8], align 8
  %btmp.i579 = alloca [12 x i8], align 4
  %out_sso.i580.sroa.6.sroa.5.sroa.0 = alloca i56, align 8
  %atmp.i512 = alloca [12 x i8], align 4
  %btmp.i513 = alloca [12 x i8], align 4
  %out_sso.i514 = alloca [16 x i8], align 8
  %atmp.i458 = alloca [12 x i8], align 4
  %out_sso.i460 = alloca [16 x i8], align 8
  %atmp.i392 = alloca [12 x i8], align 4
  %btmp.i393 = alloca [12 x i8], align 4
  %out_sso.i394 = alloca [16 x i8], align 8
  %atmp.i354 = alloca [12 x i8], align 4
  %out_sso.i356 = alloca [16 x i8], align 8
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
  %len.i1316 = sext i32 %n32.i to i64
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
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, 2147483650) %len.i1316, i1 false)
  %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i = load i64, ptr %sso.i.i, align 8
  %sso.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 8
  %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i = load i64, ptr %sso.i.i.8.sroa_idx, align 8
  %ss0.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i, 0
  %ss1.i.i = insertvalue %ArchxStr %ss0.i.i, i64 %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i, 1
  br label %archx_str_from_int.exit

alloc_heap.i.i:                                   ; preds = %chk_sso.i.i
  %hp.i.i = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1316)
  %hnull.i.i = icmp eq ptr %hp.i.i, null
  br i1 %hnull.i.i, label %oom.i.i, label %copy_long.i.i

copy_long.i.i:                                    ; preds = %alloc_heap.i.i
  %hp_i.i.i = ptrtoint ptr %hp.i.i to i64
  %htagged.i.i = or disjoint i64 %hp_i.i.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, 2147483650) %len.i1316, i1 false)
  %pref32.i.i = load i32, ptr %hp.i.i, align 16
  %pref64.i.i = zext i32 %pref32.i.i to i64
  %pref_sh.i.i = shl nuw i64 %pref64.i.i, 32
  %w0_out.i.i = or disjoint i64 %pref_sh.i.i, %len.i1316
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
  %bptr.i2064 = phi ptr [ %blptr.i, %build.i.thread ], [ %btmp.i, %build.i ]
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
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 2 %dst_b.i, ptr nonnull align 1 %bptr.i2064, i64 %blen.i, i1 false)
  %w0_out.i = or disjoint i64 %tot.i, 8386112018410635264
  %ls0.i = insertvalue %ArchxStr poison, i64 %w0_out.i, 0
  %ls1.i = insertvalue %ArchxStr %ls0.i, i64 %htagged.i, 1
  br label %archx_str_concat.exit

archx_str_concat.exit:                            ; preds = %archx_str_from_int.exit, %build_sso.i, %copy_long.i
  %common.ret.op.i = phi %ArchxStr [ %rs1.i, %build_sso.i ], [ %ls1.i, %copy_long.i ], [ { i64 8386112018410635270, i64 15731 }, %archx_str_from_int.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i354)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i356)
  %aw0.i = extractvalue %ArchxStr %common.ret.op.i, 0
  %aw1.i = extractvalue %ArchxStr %common.ret.op.i, 1
  %alen.i = and i64 %aw0.i, 4294967295
  %az.i = icmp eq i64 %alen.i, 0
  br i1 %az.i, label %archx_str_concat.exit391, label %chk_bz.i

chk_bz.i:                                         ; preds = %archx_str_concat.exit
  %tot.i358 = add nuw nsw i64 %alen.i, 1
  %too_big.i359 = icmp samesign ugt i64 %alen.i, 2147483646
  br i1 %too_big.i359, label %oom.i380, label %mat_a.i360

oom.i380:                                         ; preds = %alloc_heap.i366, %chk_bz.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i360:                                       ; preds = %chk_bz.i
  %ashort.i = icmp samesign ult i64 %alen.i, 13
  br i1 %ashort.i, label %mat_b.i, label %mat_b.i.thread

mat_b.i.thread:                                   ; preds = %mat_a.i360
  %araw.i = and i64 %aw1.i, -4
  %alptr.i = inttoptr i64 %araw.i to ptr
  br label %alloc_heap.i366

mat_b.i:                                          ; preds = %mat_a.i360
  %ap4.i = lshr i64 %aw0.i, 32
  %ap4_32.i = trunc nuw i64 %ap4.i to i32
  store i32 %ap4_32.i, ptr %atmp.i354, align 4
  %atmp4.i390 = getelementptr inbounds nuw i8, ptr %atmp.i354, i64 4
  store i64 %aw1.i, ptr %atmp4.i390, align 4
  %fits_sso.i365.not = icmp eq i64 %alen.i, 12
  br i1 %fits_sso.i365.not, label %alloc_heap.i366, label %build_sso.i381

build_sso.i381:                                   ; preds = %mat_b.i
  %out_sso8.i382 = getelementptr inbounds nuw i8, ptr %out_sso.i356, i64 8
  %tot32.i383 = trunc nuw nsw i64 %tot.i358 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i356, i8 0, i64 16, i1 false)
  store i32 %tot32.i383, ptr %out_sso.i356, align 8
  %sso_dst_a.i384 = getelementptr inbounds nuw i8, ptr %out_sso.i356, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i384, ptr nonnull align 4 %atmp.i354, i64 %alen.i, i1 false)
  %sso_dst_b.i385 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i384, i64 %alen.i
  store i8 44, ptr %sso_dst_b.i385, align 1
  %rw0.i386 = load i64, ptr %out_sso.i356, align 8
  %rw1.i387 = load i64, ptr %out_sso8.i382, align 8
  %rs0.i388 = insertvalue %ArchxStr poison, i64 %rw0.i386, 0
  %rs1.i389 = insertvalue %ArchxStr %rs0.i388, i64 %rw1.i387, 1
  br label %archx_str_concat.exit391

alloc_heap.i366:                                  ; preds = %mat_b.i.thread, %mat_b.i
  %aptr.i1935 = phi ptr [ %alptr.i, %mat_b.i.thread ], [ %atmp.i354, %mat_b.i ]
  %hp.i367 = tail call noalias align 16 ptr @malloc(i64 %tot.i358)
  %hnull.i368 = icmp eq ptr %hp.i367, null
  br i1 %hnull.i368, label %oom.i380, label %copy_long.i369

copy_long.i369:                                   ; preds = %alloc_heap.i366
  %hp_i.i370 = ptrtoint ptr %hp.i367 to i64
  %htagged.i371 = or disjoint i64 %hp_i.i370, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i367, ptr nonnull align 1 %aptr.i1935, i64 %alen.i, i1 false)
  %dst_b.i372 = getelementptr inbounds nuw i8, ptr %hp.i367, i64 %alen.i
  store i8 44, ptr %dst_b.i372, align 1
  %pref32.i373 = load i32, ptr %hp.i367, align 16
  %pref64.i374 = zext i32 %pref32.i373 to i64
  %pref_sh.i375 = shl nuw i64 %pref64.i374, 32
  %w0_out.i376 = or disjoint i64 %pref_sh.i375, %tot.i358
  %ls0.i377 = insertvalue %ArchxStr poison, i64 %w0_out.i376, 0
  %ls1.i378 = insertvalue %ArchxStr %ls0.i377, i64 %htagged.i371, 1
  br label %archx_str_concat.exit391

archx_str_concat.exit391:                         ; preds = %archx_str_concat.exit, %build_sso.i381, %copy_long.i369
  %common.ret.op.i379 = phi %ArchxStr [ %rs1.i389, %build_sso.i381 ], [ %ls1.i378, %copy_long.i369 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i354)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i356)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1320)
  %n32.i1321 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1320, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 42)
  %len.i1322 = sext i32 %n32.i1321 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1319)
  %z.i.i1323 = icmp slt i32 %n32.i1321, 1
  br i1 %z.i.i1323, label %archx_str_from_int.exit1347, label %chk_sso.i.i1324

oom.i.i1339:                                      ; preds = %alloc_heap.i.i1326
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1324:                                  ; preds = %archx_str_concat.exit391
  %short.i.i1325 = icmp samesign ult i32 %n32.i1321, 13
  br i1 %short.i.i1325, label %pack_sso.i.i1340, label %alloc_heap.i.i1326

pack_sso.i.i1340:                                 ; preds = %chk_sso.i.i1324
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1319, i8 0, i64 16, i1 false)
  store i32 %n32.i1321, ptr %sso.i.i1319, align 8
  %sso.i.i1319.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1319, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1319.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1320, i64 range(i64 -2147483648, 2147483650) %len.i1322, i1 false)
  %sso.i.i1319.0.sso.i.i1319.0.sso.i.i1319.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1342 = load i64, ptr %sso.i.i1319, align 8
  %sso.i.i1319.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1319, i64 8
  %sso.i.i1319.8.sso.i.i1319.8.sso.i.i1319.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1344 = load i64, ptr %sso.i.i1319.8.sroa_idx, align 8
  %ss0.i.i1345 = insertvalue %ArchxStr poison, i64 %sso.i.i1319.0.sso.i.i1319.0.sso.i.i1319.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1342, 0
  %ss1.i.i1346 = insertvalue %ArchxStr %ss0.i.i1345, i64 %sso.i.i1319.8.sso.i.i1319.8.sso.i.i1319.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1344, 1
  br label %archx_str_from_int.exit1347

alloc_heap.i.i1326:                               ; preds = %chk_sso.i.i1324
  %hp.i.i1327 = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1322)
  %hnull.i.i1328 = icmp eq ptr %hp.i.i1327, null
  br i1 %hnull.i.i1328, label %oom.i.i1339, label %copy_long.i.i1329

copy_long.i.i1329:                                ; preds = %alloc_heap.i.i1326
  %hp_i.i.i1330 = ptrtoint ptr %hp.i.i1327 to i64
  %htagged.i.i1331 = or disjoint i64 %hp_i.i.i1330, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1327, ptr nonnull readonly align 8 %buf.i1320, i64 range(i64 -2147483648, 2147483650) %len.i1322, i1 false)
  %pref32.i.i1332 = load i32, ptr %hp.i.i1327, align 16
  %pref64.i.i1333 = zext i32 %pref32.i.i1332 to i64
  %pref_sh.i.i1334 = shl nuw i64 %pref64.i.i1333, 32
  %w0_out.i.i1335 = or disjoint i64 %pref_sh.i.i1334, %len.i1322
  %ls0.i.i1336 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1335, 0
  %ls1.i.i1337 = insertvalue %ArchxStr %ls0.i.i1336, i64 %htagged.i.i1331, 1
  br label %archx_str_from_int.exit1347

archx_str_from_int.exit1347:                      ; preds = %archx_str_concat.exit391, %pack_sso.i.i1340, %copy_long.i.i1329
  %common.ret.op.i.i1338 = phi %ArchxStr [ %ss1.i.i1346, %pack_sso.i.i1340 ], [ %ls1.i.i1337, %copy_long.i.i1329 ], [ zeroinitializer, %archx_str_concat.exit391 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1319)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1320)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i392)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i393)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i394)
  %aw0.i395 = extractvalue %ArchxStr %common.ret.op.i379, 0
  %aw1.i396 = extractvalue %ArchxStr %common.ret.op.i379, 1
  %bw0.i397 = extractvalue %ArchxStr %common.ret.op.i.i1338, 0
  %bw1.i398 = extractvalue %ArchxStr %common.ret.op.i.i1338, 1
  %alen.i399 = and i64 %aw0.i395, 4294967295
  %blen.i400 = and i64 %bw0.i397, 4294967295
  %az.i401 = icmp eq i64 %alen.i399, 0
  br i1 %az.i401, label %ret_b_clone.i455, label %chk_bz.i402

ret_b_clone.i455:                                 ; preds = %archx_str_from_int.exit1347
  %long.i1350 = icmp samesign ult i64 %blen.i400, 13
  %tag.i1354 = and i64 %bw1.i398, 3
  %owned.not.i1355 = icmp eq i64 %tag.i1354, 0
  %or.cond = select i1 %long.i1350, i1 true, i1 %owned.not.i1355
  br i1 %or.cond, label %archx_str_concat.exit457, label %dup_heap.i

dup_heap.i:                                       ; preds = %ret_b_clone.i455
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %blen.i400)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i1356, label %copy.i

oom.i1356:                                        ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %bw1.i398, -4
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 4 %src.i, i64 %blen.i400, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %out.i = insertvalue %ArchxStr %common.ret.op.i.i1338, i64 %tagged.i, 1
  br label %archx_str_concat.exit457

chk_bz.i402:                                      ; preds = %archx_str_from_int.exit1347
  %bz.i403 = icmp eq i64 %blen.i400, 0
  br i1 %bz.i403, label %ret_a_clone.i453, label %calc_tot.i404

ret_a_clone.i453:                                 ; preds = %chk_bz.i402
  %long.i1359 = icmp samesign ult i64 %alen.i399, 13
  %tag.i1363 = and i64 %aw1.i396, 3
  %owned.not.i1364 = icmp eq i64 %tag.i1363, 0
  %or.cond2000 = select i1 %long.i1359, i1 true, i1 %owned.not.i1364
  br i1 %or.cond2000, label %archx_str_concat.exit457, label %dup_heap.i1365

dup_heap.i1365:                                   ; preds = %ret_a_clone.i453
  %dst.i1366 = tail call noalias align 16 ptr @malloc(i64 %alen.i399)
  %isnull.i1367 = icmp eq ptr %dst.i1366, null
  br i1 %isnull.i1367, label %oom.i1374, label %copy.i1368

oom.i1374:                                        ; preds = %dup_heap.i1365
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i1368:                                       ; preds = %dup_heap.i1365
  %src_i.i1369 = and i64 %aw1.i396, -4
  %src.i1370 = inttoptr i64 %src_i.i1369 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1366, ptr nonnull align 4 %src.i1370, i64 %alen.i399, i1 false)
  %dst_i.i1371 = ptrtoint ptr %dst.i1366 to i64
  %tagged.i1372 = or disjoint i64 %dst_i.i1371, 1
  %out.i1373 = insertvalue %ArchxStr %common.ret.op.i379, i64 %tagged.i1372, 1
  br label %archx_str_concat.exit457

calc_tot.i404:                                    ; preds = %chk_bz.i402
  %tot.i405 = add nuw nsw i64 %blen.i400, %alen.i399
  %too_big.i406 = icmp samesign ugt i64 %tot.i405, 2147483647
  br i1 %too_big.i406, label %oom.i435, label %mat_a.i407

oom.i435:                                         ; preds = %alloc_heap.i421, %calc_tot.i404
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i407:                                       ; preds = %calc_tot.i404
  %ashort.i408 = icmp samesign ult i64 %alen.i399, 13
  br i1 %ashort.i408, label %mat_a_short.i449, label %mat_a_long.i409

mat_a_short.i449:                                 ; preds = %mat_a.i407
  %ap4.i450 = lshr i64 %aw0.i395, 32
  %ap4_32.i451 = trunc nuw i64 %ap4.i450 to i32
  store i32 %ap4_32.i451, ptr %atmp.i392, align 4
  %atmp4.i452 = getelementptr inbounds nuw i8, ptr %atmp.i392, i64 4
  store i64 %aw1.i396, ptr %atmp4.i452, align 4
  br label %mat_b.i412

mat_a_long.i409:                                  ; preds = %mat_a.i407
  %araw.i410 = and i64 %aw1.i396, -4
  %alptr.i411 = inttoptr i64 %araw.i410 to ptr
  br label %mat_b.i412

mat_b.i412:                                       ; preds = %mat_a_long.i409, %mat_a_short.i449
  %aptr.i413 = phi ptr [ %atmp.i392, %mat_a_short.i449 ], [ %alptr.i411, %mat_a_long.i409 ]
  %bshort.i414 = icmp samesign ult i64 %blen.i400, 13
  br i1 %bshort.i414, label %mat_b_short.i445, label %mat_b_long.i415

mat_b_short.i445:                                 ; preds = %mat_b.i412
  %bp4.i446 = lshr i64 %bw0.i397, 32
  %bp4_32.i447 = trunc nuw i64 %bp4.i446 to i32
  store i32 %bp4_32.i447, ptr %btmp.i393, align 4
  %btmp4.i448 = getelementptr inbounds nuw i8, ptr %btmp.i393, i64 4
  store i64 %bw1.i398, ptr %btmp4.i448, align 4
  br label %build.i418

mat_b_long.i415:                                  ; preds = %mat_b.i412
  %braw.i416 = and i64 %bw1.i398, -4
  %blptr.i417 = inttoptr i64 %braw.i416 to ptr
  br label %build.i418

build.i418:                                       ; preds = %mat_b_long.i415, %mat_b_short.i445
  %bptr.i419 = phi ptr [ %btmp.i393, %mat_b_short.i445 ], [ %blptr.i417, %mat_b_long.i415 ]
  %fits_sso.i420 = icmp samesign ult i64 %tot.i405, 13
  br i1 %fits_sso.i420, label %build_sso.i436, label %alloc_heap.i421

build_sso.i436:                                   ; preds = %build.i418
  %out_sso8.i437 = getelementptr inbounds nuw i8, ptr %out_sso.i394, i64 8
  %tot32.i438 = trunc nuw nsw i64 %tot.i405 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i394, i8 0, i64 16, i1 false)
  store i32 %tot32.i438, ptr %out_sso.i394, align 8
  %sso_dst_a.i439 = getelementptr inbounds nuw i8, ptr %out_sso.i394, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i439, ptr nonnull align 1 %aptr.i413, i64 %alen.i399, i1 false)
  %sso_dst_b.i440 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i439, i64 %alen.i399
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i440, ptr nonnull align 1 %bptr.i419, i64 %blen.i400, i1 false)
  %rw0.i441 = load i64, ptr %out_sso.i394, align 8
  %rw1.i442 = load i64, ptr %out_sso8.i437, align 8
  %rs0.i443 = insertvalue %ArchxStr poison, i64 %rw0.i441, 0
  %rs1.i444 = insertvalue %ArchxStr %rs0.i443, i64 %rw1.i442, 1
  br label %archx_str_concat.exit457

alloc_heap.i421:                                  ; preds = %build.i418
  %hp.i422 = tail call noalias align 16 ptr @malloc(i64 %tot.i405)
  %hnull.i423 = icmp eq ptr %hp.i422, null
  br i1 %hnull.i423, label %oom.i435, label %copy_long.i424

copy_long.i424:                                   ; preds = %alloc_heap.i421
  %hp_i.i425 = ptrtoint ptr %hp.i422 to i64
  %htagged.i426 = or disjoint i64 %hp_i.i425, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i422, ptr nonnull align 1 %aptr.i413, i64 %alen.i399, i1 false)
  %dst_b.i427 = getelementptr inbounds nuw i8, ptr %hp.i422, i64 %alen.i399
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i427, ptr nonnull align 1 %bptr.i419, i64 %blen.i400, i1 false)
  %pref32.i428 = load i32, ptr %hp.i422, align 16
  %pref64.i429 = zext i32 %pref32.i428 to i64
  %pref_sh.i430 = shl nuw i64 %pref64.i429, 32
  %w0_out.i431 = or disjoint i64 %pref_sh.i430, %tot.i405
  %ls0.i432 = insertvalue %ArchxStr poison, i64 %w0_out.i431, 0
  %ls1.i433 = insertvalue %ArchxStr %ls0.i432, i64 %htagged.i426, 1
  br label %archx_str_concat.exit457

archx_str_concat.exit457:                         ; preds = %copy.i1368, %ret_a_clone.i453, %copy.i, %ret_b_clone.i455, %build_sso.i436, %copy_long.i424
  %common.ret.op.i434 = phi %ArchxStr [ %rs1.i444, %build_sso.i436 ], [ %ls1.i433, %copy_long.i424 ], [ %out.i, %copy.i ], [ %common.ret.op.i.i1338, %ret_b_clone.i455 ], [ %out.i1373, %copy.i1368 ], [ %common.ret.op.i379, %ret_a_clone.i453 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i392)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i393)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i394)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i458)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i460)
  %aw0.i461 = extractvalue %ArchxStr %common.ret.op.i434, 0
  %aw1.i462 = extractvalue %ArchxStr %common.ret.op.i434, 1
  %alen.i463 = and i64 %aw0.i461, 4294967295
  %az.i464 = icmp eq i64 %alen.i463, 0
  br i1 %az.i464, label %archx_str_concat.exit511, label %chk_bz.i465

chk_bz.i465:                                      ; preds = %archx_str_concat.exit457
  %tot.i467 = add nuw nsw i64 %alen.i463, 1
  %too_big.i468 = icmp samesign ugt i64 %alen.i463, 2147483646
  br i1 %too_big.i468, label %oom.i495, label %mat_a.i469

oom.i495:                                         ; preds = %alloc_heap.i481, %chk_bz.i465
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i469:                                       ; preds = %chk_bz.i465
  %ashort.i470 = icmp samesign ult i64 %alen.i463, 13
  br i1 %ashort.i470, label %mat_b.i474, label %mat_b.i474.thread

mat_b.i474.thread:                                ; preds = %mat_a.i469
  %araw.i472 = and i64 %aw1.i462, -4
  %alptr.i473 = inttoptr i64 %araw.i472 to ptr
  br label %alloc_heap.i481

mat_b.i474:                                       ; preds = %mat_a.i469
  %ap4.i506 = lshr i64 %aw0.i461, 32
  %ap4_32.i507 = trunc nuw i64 %ap4.i506 to i32
  store i32 %ap4_32.i507, ptr %atmp.i458, align 4
  %atmp4.i508 = getelementptr inbounds nuw i8, ptr %atmp.i458, i64 4
  store i64 %aw1.i462, ptr %atmp4.i508, align 4
  %fits_sso.i480.not = icmp eq i64 %alen.i463, 12
  br i1 %fits_sso.i480.not, label %alloc_heap.i481, label %build_sso.i496

build_sso.i496:                                   ; preds = %mat_b.i474
  %out_sso8.i497 = getelementptr inbounds nuw i8, ptr %out_sso.i460, i64 8
  %tot32.i498 = trunc nuw nsw i64 %tot.i467 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i460, i8 0, i64 16, i1 false)
  store i32 %tot32.i498, ptr %out_sso.i460, align 8
  %sso_dst_a.i499 = getelementptr inbounds nuw i8, ptr %out_sso.i460, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i499, ptr nonnull align 4 %atmp.i458, i64 %alen.i463, i1 false)
  %sso_dst_b.i500 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i499, i64 %alen.i463
  store i8 44, ptr %sso_dst_b.i500, align 1
  %rw0.i501 = load i64, ptr %out_sso.i460, align 8
  %rw1.i502 = load i64, ptr %out_sso8.i497, align 8
  %rs0.i503 = insertvalue %ArchxStr poison, i64 %rw0.i501, 0
  %rs1.i504 = insertvalue %ArchxStr %rs0.i503, i64 %rw1.i502, 1
  br label %archx_str_concat.exit511

alloc_heap.i481:                                  ; preds = %mat_b.i474.thread, %mat_b.i474
  %aptr.i4751938 = phi ptr [ %alptr.i473, %mat_b.i474.thread ], [ %atmp.i458, %mat_b.i474 ]
  %hp.i482 = tail call noalias align 16 ptr @malloc(i64 %tot.i467)
  %hnull.i483 = icmp eq ptr %hp.i482, null
  br i1 %hnull.i483, label %oom.i495, label %copy_long.i484

copy_long.i484:                                   ; preds = %alloc_heap.i481
  %hp_i.i485 = ptrtoint ptr %hp.i482 to i64
  %htagged.i486 = or disjoint i64 %hp_i.i485, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i482, ptr nonnull align 1 %aptr.i4751938, i64 %alen.i463, i1 false)
  %dst_b.i487 = getelementptr inbounds nuw i8, ptr %hp.i482, i64 %alen.i463
  store i8 44, ptr %dst_b.i487, align 1
  %pref32.i488 = load i32, ptr %hp.i482, align 16
  %pref64.i489 = zext i32 %pref32.i488 to i64
  %pref_sh.i490 = shl nuw i64 %pref64.i489, 32
  %w0_out.i491 = or disjoint i64 %pref_sh.i490, %tot.i467
  %ls0.i492 = insertvalue %ArchxStr poison, i64 %w0_out.i491, 0
  %ls1.i493 = insertvalue %ArchxStr %ls0.i492, i64 %htagged.i486, 1
  br label %archx_str_concat.exit511

archx_str_concat.exit511:                         ; preds = %archx_str_concat.exit457, %build_sso.i496, %copy_long.i484
  %common.ret.op.i494 = phi %ArchxStr [ %rs1.i504, %build_sso.i496 ], [ %ls1.i493, %copy_long.i484 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit457 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i458)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i460)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1378)
  %n32.i1379 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1378, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 86)
  %len.i1380 = sext i32 %n32.i1379 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1377)
  %z.i.i1381 = icmp slt i32 %n32.i1379, 1
  br i1 %z.i.i1381, label %archx_str_from_int.exit1405, label %chk_sso.i.i1382

oom.i.i1397:                                      ; preds = %alloc_heap.i.i1384
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1382:                                  ; preds = %archx_str_concat.exit511
  %short.i.i1383 = icmp samesign ult i32 %n32.i1379, 13
  br i1 %short.i.i1383, label %pack_sso.i.i1398, label %alloc_heap.i.i1384

pack_sso.i.i1398:                                 ; preds = %chk_sso.i.i1382
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1377, i8 0, i64 16, i1 false)
  store i32 %n32.i1379, ptr %sso.i.i1377, align 8
  %sso.i.i1377.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1377, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1377.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1378, i64 range(i64 -2147483648, 2147483650) %len.i1380, i1 false)
  %sso.i.i1377.0.sso.i.i1377.0.sso.i.i1377.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1400 = load i64, ptr %sso.i.i1377, align 8
  %sso.i.i1377.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1377, i64 8
  %sso.i.i1377.8.sso.i.i1377.8.sso.i.i1377.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1402 = load i64, ptr %sso.i.i1377.8.sroa_idx, align 8
  %ss0.i.i1403 = insertvalue %ArchxStr poison, i64 %sso.i.i1377.0.sso.i.i1377.0.sso.i.i1377.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1400, 0
  %ss1.i.i1404 = insertvalue %ArchxStr %ss0.i.i1403, i64 %sso.i.i1377.8.sso.i.i1377.8.sso.i.i1377.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1402, 1
  br label %archx_str_from_int.exit1405

alloc_heap.i.i1384:                               ; preds = %chk_sso.i.i1382
  %hp.i.i1385 = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1380)
  %hnull.i.i1386 = icmp eq ptr %hp.i.i1385, null
  br i1 %hnull.i.i1386, label %oom.i.i1397, label %copy_long.i.i1387

copy_long.i.i1387:                                ; preds = %alloc_heap.i.i1384
  %hp_i.i.i1388 = ptrtoint ptr %hp.i.i1385 to i64
  %htagged.i.i1389 = or disjoint i64 %hp_i.i.i1388, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1385, ptr nonnull readonly align 8 %buf.i1378, i64 range(i64 -2147483648, 2147483650) %len.i1380, i1 false)
  %pref32.i.i1390 = load i32, ptr %hp.i.i1385, align 16
  %pref64.i.i1391 = zext i32 %pref32.i.i1390 to i64
  %pref_sh.i.i1392 = shl nuw i64 %pref64.i.i1391, 32
  %w0_out.i.i1393 = or disjoint i64 %pref_sh.i.i1392, %len.i1380
  %ls0.i.i1394 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1393, 0
  %ls1.i.i1395 = insertvalue %ArchxStr %ls0.i.i1394, i64 %htagged.i.i1389, 1
  br label %archx_str_from_int.exit1405

archx_str_from_int.exit1405:                      ; preds = %archx_str_concat.exit511, %pack_sso.i.i1398, %copy_long.i.i1387
  %common.ret.op.i.i1396 = phi %ArchxStr [ %ss1.i.i1404, %pack_sso.i.i1398 ], [ %ls1.i.i1395, %copy_long.i.i1387 ], [ zeroinitializer, %archx_str_concat.exit511 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1377)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1378)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i512)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i513)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i514)
  %aw0.i515 = extractvalue %ArchxStr %common.ret.op.i494, 0
  %aw1.i516 = extractvalue %ArchxStr %common.ret.op.i494, 1
  %bw0.i517 = extractvalue %ArchxStr %common.ret.op.i.i1396, 0
  %bw1.i518 = extractvalue %ArchxStr %common.ret.op.i.i1396, 1
  %alen.i519 = and i64 %aw0.i515, 4294967295
  %blen.i520 = and i64 %bw0.i517, 4294967295
  %az.i521 = icmp eq i64 %alen.i519, 0
  br i1 %az.i521, label %ret_b_clone.i575, label %chk_bz.i522

ret_b_clone.i575:                                 ; preds = %archx_str_from_int.exit1405
  %long.i1408 = icmp samesign ult i64 %blen.i520, 13
  %tag.i1412 = and i64 %bw1.i518, 3
  %owned.not.i1413 = icmp eq i64 %tag.i1412, 0
  %or.cond2001 = select i1 %long.i1408, i1 true, i1 %owned.not.i1413
  br i1 %or.cond2001, label %archx_str_concat.exit577, label %dup_heap.i1414

dup_heap.i1414:                                   ; preds = %ret_b_clone.i575
  %dst.i1415 = tail call noalias align 16 ptr @malloc(i64 %blen.i520)
  %isnull.i1416 = icmp eq ptr %dst.i1415, null
  br i1 %isnull.i1416, label %oom.i1423, label %copy.i1417

oom.i1423:                                        ; preds = %dup_heap.i1414
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i1417:                                       ; preds = %dup_heap.i1414
  %src_i.i1418 = and i64 %bw1.i518, -4
  %src.i1419 = inttoptr i64 %src_i.i1418 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1415, ptr nonnull align 4 %src.i1419, i64 %blen.i520, i1 false)
  %dst_i.i1420 = ptrtoint ptr %dst.i1415 to i64
  %tagged.i1421 = or disjoint i64 %dst_i.i1420, 1
  %out.i1422 = insertvalue %ArchxStr %common.ret.op.i.i1396, i64 %tagged.i1421, 1
  br label %archx_str_concat.exit577

chk_bz.i522:                                      ; preds = %archx_str_from_int.exit1405
  %bz.i523 = icmp eq i64 %blen.i520, 0
  br i1 %bz.i523, label %ret_a_clone.i573, label %calc_tot.i524

ret_a_clone.i573:                                 ; preds = %chk_bz.i522
  %long.i1427 = icmp samesign ult i64 %alen.i519, 13
  %tag.i1431 = and i64 %aw1.i516, 3
  %owned.not.i1432 = icmp eq i64 %tag.i1431, 0
  %or.cond2002 = select i1 %long.i1427, i1 true, i1 %owned.not.i1432
  br i1 %or.cond2002, label %archx_str_concat.exit577, label %dup_heap.i1433

dup_heap.i1433:                                   ; preds = %ret_a_clone.i573
  %dst.i1434 = tail call noalias align 16 ptr @malloc(i64 %alen.i519)
  %isnull.i1435 = icmp eq ptr %dst.i1434, null
  br i1 %isnull.i1435, label %oom.i1442, label %copy.i1436

oom.i1442:                                        ; preds = %dup_heap.i1433
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i1436:                                       ; preds = %dup_heap.i1433
  %src_i.i1437 = and i64 %aw1.i516, -4
  %src.i1438 = inttoptr i64 %src_i.i1437 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1434, ptr nonnull align 4 %src.i1438, i64 %alen.i519, i1 false)
  %dst_i.i1439 = ptrtoint ptr %dst.i1434 to i64
  %tagged.i1440 = or disjoint i64 %dst_i.i1439, 1
  %out.i1441 = insertvalue %ArchxStr %common.ret.op.i494, i64 %tagged.i1440, 1
  br label %archx_str_concat.exit577

calc_tot.i524:                                    ; preds = %chk_bz.i522
  %tot.i525 = add nuw nsw i64 %blen.i520, %alen.i519
  %too_big.i526 = icmp samesign ugt i64 %tot.i525, 2147483647
  br i1 %too_big.i526, label %oom.i555, label %mat_a.i527

oom.i555:                                         ; preds = %alloc_heap.i541, %calc_tot.i524
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i527:                                       ; preds = %calc_tot.i524
  %ashort.i528 = icmp samesign ult i64 %alen.i519, 13
  br i1 %ashort.i528, label %mat_a_short.i569, label %mat_a_long.i529

mat_a_short.i569:                                 ; preds = %mat_a.i527
  %ap4.i570 = lshr i64 %aw0.i515, 32
  %ap4_32.i571 = trunc nuw i64 %ap4.i570 to i32
  store i32 %ap4_32.i571, ptr %atmp.i512, align 4
  %atmp4.i572 = getelementptr inbounds nuw i8, ptr %atmp.i512, i64 4
  store i64 %aw1.i516, ptr %atmp4.i572, align 4
  br label %mat_b.i532

mat_a_long.i529:                                  ; preds = %mat_a.i527
  %araw.i530 = and i64 %aw1.i516, -4
  %alptr.i531 = inttoptr i64 %araw.i530 to ptr
  br label %mat_b.i532

mat_b.i532:                                       ; preds = %mat_a_long.i529, %mat_a_short.i569
  %aptr.i533 = phi ptr [ %atmp.i512, %mat_a_short.i569 ], [ %alptr.i531, %mat_a_long.i529 ]
  %bshort.i534 = icmp samesign ult i64 %blen.i520, 13
  br i1 %bshort.i534, label %mat_b_short.i565, label %mat_b_long.i535

mat_b_short.i565:                                 ; preds = %mat_b.i532
  %bp4.i566 = lshr i64 %bw0.i517, 32
  %bp4_32.i567 = trunc nuw i64 %bp4.i566 to i32
  store i32 %bp4_32.i567, ptr %btmp.i513, align 4
  %btmp4.i568 = getelementptr inbounds nuw i8, ptr %btmp.i513, i64 4
  store i64 %bw1.i518, ptr %btmp4.i568, align 4
  br label %build.i538

mat_b_long.i535:                                  ; preds = %mat_b.i532
  %braw.i536 = and i64 %bw1.i518, -4
  %blptr.i537 = inttoptr i64 %braw.i536 to ptr
  br label %build.i538

build.i538:                                       ; preds = %mat_b_long.i535, %mat_b_short.i565
  %bptr.i539 = phi ptr [ %btmp.i513, %mat_b_short.i565 ], [ %blptr.i537, %mat_b_long.i535 ]
  %fits_sso.i540 = icmp samesign ult i64 %tot.i525, 13
  br i1 %fits_sso.i540, label %build_sso.i556, label %alloc_heap.i541

build_sso.i556:                                   ; preds = %build.i538
  %out_sso8.i557 = getelementptr inbounds nuw i8, ptr %out_sso.i514, i64 8
  %tot32.i558 = trunc nuw nsw i64 %tot.i525 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i514, i8 0, i64 16, i1 false)
  store i32 %tot32.i558, ptr %out_sso.i514, align 8
  %sso_dst_a.i559 = getelementptr inbounds nuw i8, ptr %out_sso.i514, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i559, ptr nonnull align 1 %aptr.i533, i64 %alen.i519, i1 false)
  %sso_dst_b.i560 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i559, i64 %alen.i519
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i560, ptr nonnull align 1 %bptr.i539, i64 %blen.i520, i1 false)
  %rw0.i561 = load i64, ptr %out_sso.i514, align 8
  %rw1.i562 = load i64, ptr %out_sso8.i557, align 8
  %rs0.i563 = insertvalue %ArchxStr poison, i64 %rw0.i561, 0
  %rs1.i564 = insertvalue %ArchxStr %rs0.i563, i64 %rw1.i562, 1
  br label %archx_str_concat.exit577

alloc_heap.i541:                                  ; preds = %build.i538
  %hp.i542 = tail call noalias align 16 ptr @malloc(i64 %tot.i525)
  %hnull.i543 = icmp eq ptr %hp.i542, null
  br i1 %hnull.i543, label %oom.i555, label %copy_long.i544

copy_long.i544:                                   ; preds = %alloc_heap.i541
  %hp_i.i545 = ptrtoint ptr %hp.i542 to i64
  %htagged.i546 = or disjoint i64 %hp_i.i545, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i542, ptr nonnull align 1 %aptr.i533, i64 %alen.i519, i1 false)
  %dst_b.i547 = getelementptr inbounds nuw i8, ptr %hp.i542, i64 %alen.i519
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i547, ptr nonnull align 1 %bptr.i539, i64 %blen.i520, i1 false)
  %pref32.i548 = load i32, ptr %hp.i542, align 16
  %pref64.i549 = zext i32 %pref32.i548 to i64
  %pref_sh.i550 = shl nuw i64 %pref64.i549, 32
  %w0_out.i551 = or disjoint i64 %pref_sh.i550, %tot.i525
  %ls0.i552 = insertvalue %ArchxStr poison, i64 %w0_out.i551, 0
  %ls1.i553 = insertvalue %ArchxStr %ls0.i552, i64 %htagged.i546, 1
  br label %archx_str_concat.exit577

archx_str_concat.exit577:                         ; preds = %copy.i1436, %ret_a_clone.i573, %copy.i1417, %ret_b_clone.i575, %build_sso.i556, %copy_long.i544
  %common.ret.op.i554 = phi %ArchxStr [ %rs1.i564, %build_sso.i556 ], [ %ls1.i553, %copy_long.i544 ], [ %out.i1422, %copy.i1417 ], [ %common.ret.op.i.i1396, %ret_b_clone.i575 ], [ %out.i1441, %copy.i1436 ], [ %common.ret.op.i494, %ret_a_clone.i573 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i512)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i513)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i514)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  %w0.i1444 = extractvalue %ArchxStr %common.ret.op.i554, 0
  %w1.i1445 = extractvalue %ArchxStr %common.ret.op.i554, 1
  %len.i1446 = and i64 %w0.i1444, 4294967295
  %short.i = icmp samesign ult i64 %len.i1446, 13
  br i1 %short.i, label %emit.i, label %emit.thread.i

emit.thread.i:                                    ; preds = %archx_str_concat.exit577
  %raw.i1447 = and i64 %w1.i1445, -4
  %lptr.i = inttoptr i64 %raw.i1447 to ptr
  br label %chk_nul.i

emit.i:                                           ; preds = %archx_str_concat.exit577
  %p4.i = lshr i64 %w0.i1444, 32
  %p4_32.i = trunc nuw i64 %p4.i to i32
  store i32 %p4_32.i, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 %w1.i1445, ptr %tmp4.i, align 4
  %pos.not.i = icmp eq i64 %len.i1446, 0
  br i1 %pos.not.i, label %do_nl.i, label %chk_nul.i

chk_nul.i:                                        ; preds = %emit.i, %emit.thread.i
  %data3.i = phi ptr [ %lptr.i, %emit.thread.i ], [ %tmp.i, %emit.i ]
  %nul.i = call ptr @memchr(ptr nonnull %data3.i, i32 0, i64 %len.i1446)
  %has_nul.not.i = icmp eq ptr %nul.i, null
  br i1 %has_nul.not.i, label %fast_printf.i, label %byte_loop.i

fast_printf.i:                                    ; preds = %chk_nul.i
  %len32.i = trunc i64 %w0.i1444 to i32
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i, ptr nonnull %data3.i)
  br label %archx_str_print.exit

byte_loop.i:                                      ; preds = %chk_nul.i, %byte_loop.i
  %bi.i = phi i64 [ %bnext.i, %byte_loop.i ], [ 0, %chk_nul.i ]
  %bp.i = getelementptr inbounds nuw i8, ptr %data3.i, i64 %bi.i
  %ch8.i = load i8, ptr %bp.i, align 1
  %ch32.i = zext i8 %ch8.i to i32
  %pc.i = tail call i32 @putchar(i32 %ch32.i)
  %bnext.i = add nuw nsw i64 %bi.i, 1
  %exitcond.not.i = icmp eq i64 %bnext.i, %len.i1446
  br i1 %exitcond.not.i, label %do_nl.i, label %byte_loop.i

do_nl.i:                                          ; preds = %byte_loop.i, %emit.i
  %nc.i = tail call i32 @putchar(i32 10)
  br label %archx_str_print.exit

archx_str_print.exit:                             ; preds = %fast_printf.i, %do_nl.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %tag.i = and i64 %w1.i1445, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond2003 = select i1 %short.i, i1 true, i1 %owned.not.i
  br i1 %or.cond2003, label %archx_str_drop.exit, label %do_free.i

do_free.i:                                        ; preds = %archx_str_print.exit
  %raw.i = and i64 %w1.i1445, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  call void @free(ptr %ptr.i)
  br label %archx_str_drop.exit

archx_str_drop.exit:                              ; preds = %archx_str_print.exit, %do_free.i
  %long.i59 = icmp samesign ult i64 %blen.i520, 13
  %tag.i62 = and i64 %bw1.i518, 1
  %owned.not.i63 = icmp eq i64 %tag.i62, 0
  %or.cond2004 = select i1 %long.i59, i1 true, i1 %owned.not.i63
  br i1 %or.cond2004, label %archx_str_drop.exit67, label %do_free.i64

do_free.i64:                                      ; preds = %archx_str_drop.exit
  %raw.i65 = and i64 %bw1.i518, -2
  %ptr.i66 = inttoptr i64 %raw.i65 to ptr
  call void @free(ptr %ptr.i66)
  br label %archx_str_drop.exit67

archx_str_drop.exit67:                            ; preds = %archx_str_drop.exit, %do_free.i64
  %long.i70 = icmp samesign ult i64 %alen.i519, 13
  %tag.i73 = and i64 %aw1.i516, 1
  %owned.not.i74 = icmp eq i64 %tag.i73, 0
  %or.cond2005 = select i1 %long.i70, i1 true, i1 %owned.not.i74
  br i1 %or.cond2005, label %archx_str_drop.exit78, label %do_free.i75

do_free.i75:                                      ; preds = %archx_str_drop.exit67
  %raw.i76 = and i64 %aw1.i516, -2
  %ptr.i77 = inttoptr i64 %raw.i76 to ptr
  call void @free(ptr %ptr.i77)
  br label %archx_str_drop.exit78

archx_str_drop.exit78:                            ; preds = %archx_str_drop.exit67, %do_free.i75
  %long.i81 = icmp samesign ult i64 %alen.i463, 13
  %tag.i84 = and i64 %aw1.i462, 1
  %owned.not.i85 = icmp eq i64 %tag.i84, 0
  %or.cond2006 = select i1 %long.i81, i1 true, i1 %owned.not.i85
  br i1 %or.cond2006, label %archx_str_drop.exit89, label %do_free.i86

do_free.i86:                                      ; preds = %archx_str_drop.exit78
  %raw.i87 = and i64 %aw1.i462, -2
  %ptr.i88 = inttoptr i64 %raw.i87 to ptr
  call void @free(ptr %ptr.i88)
  br label %archx_str_drop.exit89

archx_str_drop.exit89:                            ; preds = %archx_str_drop.exit78, %do_free.i86
  %long.i92 = icmp samesign ult i64 %blen.i400, 13
  %tag.i95 = and i64 %bw1.i398, 1
  %owned.not.i96 = icmp eq i64 %tag.i95, 0
  %or.cond2007 = select i1 %long.i92, i1 true, i1 %owned.not.i96
  br i1 %or.cond2007, label %archx_str_drop.exit100, label %do_free.i97

do_free.i97:                                      ; preds = %archx_str_drop.exit89
  %raw.i98 = and i64 %bw1.i398, -2
  %ptr.i99 = inttoptr i64 %raw.i98 to ptr
  call void @free(ptr %ptr.i99)
  br label %archx_str_drop.exit100

archx_str_drop.exit100:                           ; preds = %archx_str_drop.exit89, %do_free.i97
  %long.i103 = icmp samesign ult i64 %alen.i399, 13
  %tag.i106 = and i64 %aw1.i396, 1
  %owned.not.i107 = icmp eq i64 %tag.i106, 0
  %or.cond2008 = select i1 %long.i103, i1 true, i1 %owned.not.i107
  br i1 %or.cond2008, label %archx_str_drop.exit111, label %do_free.i108

do_free.i108:                                     ; preds = %archx_str_drop.exit100
  %raw.i109 = and i64 %aw1.i396, -2
  %ptr.i110 = inttoptr i64 %raw.i109 to ptr
  call void @free(ptr %ptr.i110)
  br label %archx_str_drop.exit111

archx_str_drop.exit111:                           ; preds = %archx_str_drop.exit100, %do_free.i108
  %long.i114 = icmp samesign ult i64 %alen.i, 13
  %tag.i117 = and i64 %aw1.i, 1
  %owned.not.i118 = icmp eq i64 %tag.i117, 0
  %or.cond2009 = select i1 %long.i114, i1 true, i1 %owned.not.i118
  br i1 %or.cond2009, label %archx_str_drop.exit122, label %do_free.i119

do_free.i119:                                     ; preds = %archx_str_drop.exit111
  %raw.i120 = and i64 %aw1.i, -2
  %ptr.i121 = inttoptr i64 %raw.i120 to ptr
  call void @free(ptr %ptr.i121)
  br label %archx_str_drop.exit122

archx_str_drop.exit122:                           ; preds = %archx_str_drop.exit111, %do_free.i119
  %long.i125 = icmp samesign ult i64 %blen.i, 13
  %tag.i128 = and i64 %bw1.i, 1
  %owned.not.i129 = icmp eq i64 %tag.i128, 0
  %or.cond2010 = select i1 %long.i125, i1 true, i1 %owned.not.i129
  br i1 %or.cond2010, label %archx_str_drop.exit133, label %do_free.i130

do_free.i130:                                     ; preds = %archx_str_drop.exit122
  %raw.i131 = and i64 %bw1.i, -2
  %ptr.i132 = inttoptr i64 %raw.i131 to ptr
  call void @free(ptr %ptr.i132)
  br label %archx_str_drop.exit133

archx_str_drop.exit133:                           ; preds = %archx_str_drop.exit122, %do_free.i130
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1449)
  %n32.i1450 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1449, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 99)
  %len.i1451 = sext i32 %n32.i1450 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1448)
  %z.i.i1452 = icmp slt i32 %n32.i1450, 1
  br i1 %z.i.i1452, label %archx_str_from_int.exit1476, label %chk_sso.i.i1453

oom.i.i1468:                                      ; preds = %alloc_heap.i.i1455
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1453:                                  ; preds = %archx_str_drop.exit133
  %short.i.i1454 = icmp samesign ult i32 %n32.i1450, 13
  br i1 %short.i.i1454, label %pack_sso.i.i1469, label %alloc_heap.i.i1455

pack_sso.i.i1469:                                 ; preds = %chk_sso.i.i1453
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1448, i8 0, i64 16, i1 false)
  store i32 %n32.i1450, ptr %sso.i.i1448, align 8
  %sso.i.i1448.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1448, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1448.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1449, i64 range(i64 -2147483648, 2147483650) %len.i1451, i1 false)
  %sso.i.i1448.0.sso.i.i1448.0.sso.i.i1448.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1471 = load i64, ptr %sso.i.i1448, align 8
  %sso.i.i1448.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1448, i64 8
  %sso.i.i1448.8.sso.i.i1448.8.sso.i.i1448.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1473 = load i64, ptr %sso.i.i1448.8.sroa_idx, align 8
  %ss0.i.i1474 = insertvalue %ArchxStr poison, i64 %sso.i.i1448.0.sso.i.i1448.0.sso.i.i1448.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1471, 0
  %ss1.i.i1475 = insertvalue %ArchxStr %ss0.i.i1474, i64 %sso.i.i1448.8.sso.i.i1448.8.sso.i.i1448.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1473, 1
  br label %archx_str_from_int.exit1476

alloc_heap.i.i1455:                               ; preds = %chk_sso.i.i1453
  %hp.i.i1456 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1451)
  %hnull.i.i1457 = icmp eq ptr %hp.i.i1456, null
  br i1 %hnull.i.i1457, label %oom.i.i1468, label %copy_long.i.i1458

copy_long.i.i1458:                                ; preds = %alloc_heap.i.i1455
  %hp_i.i.i1459 = ptrtoint ptr %hp.i.i1456 to i64
  %htagged.i.i1460 = or disjoint i64 %hp_i.i.i1459, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1456, ptr nonnull readonly align 8 %buf.i1449, i64 range(i64 -2147483648, 2147483650) %len.i1451, i1 false)
  %pref32.i.i1461 = load i32, ptr %hp.i.i1456, align 16
  %pref64.i.i1462 = zext i32 %pref32.i.i1461 to i64
  %pref_sh.i.i1463 = shl nuw i64 %pref64.i.i1462, 32
  %w0_out.i.i1464 = or disjoint i64 %pref_sh.i.i1463, %len.i1451
  %ls0.i.i1465 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1464, 0
  %ls1.i.i1466 = insertvalue %ArchxStr %ls0.i.i1465, i64 %htagged.i.i1460, 1
  br label %archx_str_from_int.exit1476

archx_str_from_int.exit1476:                      ; preds = %archx_str_drop.exit133, %pack_sso.i.i1469, %copy_long.i.i1458
  %common.ret.op.i.i1467 = phi %ArchxStr [ %ss1.i.i1475, %pack_sso.i.i1469 ], [ %ls1.i.i1466, %copy_long.i.i1458 ], [ zeroinitializer, %archx_str_drop.exit133 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1448)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1449)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i579)
  %bw0.i581 = extractvalue %ArchxStr %common.ret.op.i.i1467, 0
  %bw1.i582 = extractvalue %ArchxStr %common.ret.op.i.i1467, 1
  %blen.i583 = and i64 %bw0.i581, 4294967295
  %bz.i585 = icmp eq i64 %blen.i583, 0
  br i1 %bz.i585, label %archx_str_concat.exit631, label %calc_tot.i586

calc_tot.i586:                                    ; preds = %archx_str_from_int.exit1476
  %tot.i587 = add nuw nsw i64 %blen.i583, 5
  %too_big.i588 = icmp samesign ugt i64 %blen.i583, 2147483642
  br i1 %too_big.i588, label %oom.i615, label %mat_a.i589

oom.i615:                                         ; preds = %alloc_heap.i601, %calc_tot.i586
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i589:                                       ; preds = %calc_tot.i586
  %bshort.i594 = icmp samesign ult i64 %blen.i583, 13
  br i1 %bshort.i594, label %build.i598, label %build.i598.thread

build.i598.thread:                                ; preds = %mat_a.i589
  %braw.i596 = and i64 %bw1.i582, -4
  %blptr.i597 = inttoptr i64 %braw.i596 to ptr
  br label %alloc_heap.i601

build.i598:                                       ; preds = %mat_a.i589
  %bp4.i626 = lshr i64 %bw0.i581, 32
  %bp4_32.i627 = trunc nuw i64 %bp4.i626 to i32
  store i32 %bp4_32.i627, ptr %btmp.i579, align 4
  %btmp4.i628 = getelementptr inbounds nuw i8, ptr %btmp.i579, i64 4
  store i64 %bw1.i582, ptr %btmp4.i628, align 4
  %fits_sso.i600 = icmp samesign ult i64 %blen.i583, 8
  br i1 %fits_sso.i600, label %build_sso.i616, label %alloc_heap.i601

build_sso.i616:                                   ; preds = %build.i598
  store i56 0, ptr %out_sso.i580.sroa.6.sroa.5.sroa.0, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i580.sroa.6.sroa.5.sroa.0, ptr nonnull align 4 %btmp.i579, i64 %blen.i583, i1 false)
  %out_sso.i580.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i587, 8097884940793806848
  %out_sso.i580.sroa.6.sroa.5.sroa.0.0.out_sso.i580.sroa.6.sroa.5.sroa.0.0.out_sso.i580.sroa.6.sroa.5.sroa.0.0.out_sso.i580.sroa.6.sroa.5.sroa.0.0.out_sso.i580.sroa.6.sroa.5.0.out_sso.i580.sroa.6.8.rw1.i622 = load i56, ptr %out_sso.i580.sroa.6.sroa.5.sroa.0, align 8
  %out_sso.i580.sroa.6.sroa.5.0.insert.ext = zext i56 %out_sso.i580.sroa.6.sroa.5.sroa.0.0.out_sso.i580.sroa.6.sroa.5.sroa.0.0.out_sso.i580.sroa.6.sroa.5.sroa.0.0.out_sso.i580.sroa.6.sroa.5.sroa.0.0.out_sso.i580.sroa.6.sroa.5.0.out_sso.i580.sroa.6.8.rw1.i622 to i64
  %out_sso.i580.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i580.sroa.6.sroa.5.0.insert.ext, 8
  %out_sso.i580.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i580.sroa.6.sroa.5.0.insert.shift, 61
  %rs0.i623 = insertvalue %ArchxStr poison, i64 %out_sso.i580.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i624 = insertvalue %ArchxStr %rs0.i623, i64 %out_sso.i580.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit631

alloc_heap.i601:                                  ; preds = %build.i598.thread, %build.i598
  %bptr.i5992067 = phi ptr [ %blptr.i597, %build.i598.thread ], [ %btmp.i579, %build.i598 ]
  %hp.i602 = call noalias align 16 ptr @malloc(i64 %tot.i587)
  %hnull.i603 = icmp eq ptr %hp.i602, null
  br i1 %hnull.i603, label %oom.i615, label %copy_long.i604

copy_long.i604:                                   ; preds = %alloc_heap.i601
  %hp_i.i605 = ptrtoint ptr %hp.i602 to i64
  %htagged.i606 = or disjoint i64 %hp_i.i605, 1
  store i32 1885435763, ptr %hp.i602, align 16
  %atmp.i578.sroa.5.0.hp.i602.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i602, i64 4
  store i8 61, ptr %atmp.i578.sroa.5.0.hp.i602.sroa_idx, align 4
  %dst_b.i607 = getelementptr inbounds nuw i8, ptr %hp.i602, i64 5
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i607, ptr nonnull align 1 %bptr.i5992067, i64 %blen.i583, i1 false)
  %w0_out.i611 = or disjoint i64 %tot.i587, 8097884940793806848
  %ls0.i612 = insertvalue %ArchxStr poison, i64 %w0_out.i611, 0
  %ls1.i613 = insertvalue %ArchxStr %ls0.i612, i64 %htagged.i606, 1
  br label %archx_str_concat.exit631

archx_str_concat.exit631:                         ; preds = %archx_str_from_int.exit1476, %build_sso.i616, %copy_long.i604
  %common.ret.op.i614 = phi %ArchxStr [ %rs1.i624, %build_sso.i616 ], [ %ls1.i613, %copy_long.i604 ], [ { i64 8097884940793806853, i64 61 }, %archx_str_from_int.exit1476 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i579)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i632)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i634)
  %aw0.i635 = extractvalue %ArchxStr %common.ret.op.i614, 0
  %aw1.i636 = extractvalue %ArchxStr %common.ret.op.i614, 1
  %alen.i637 = and i64 %aw0.i635, 4294967295
  %az.i638 = icmp eq i64 %alen.i637, 0
  br i1 %az.i638, label %archx_str_concat.exit685, label %chk_bz.i639

chk_bz.i639:                                      ; preds = %archx_str_concat.exit631
  %tot.i641 = add nuw nsw i64 %alen.i637, 1
  %too_big.i642 = icmp samesign ugt i64 %alen.i637, 2147483646
  br i1 %too_big.i642, label %oom.i669, label %mat_a.i643

oom.i669:                                         ; preds = %alloc_heap.i655, %chk_bz.i639
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i643:                                       ; preds = %chk_bz.i639
  %ashort.i644 = icmp samesign ult i64 %alen.i637, 13
  br i1 %ashort.i644, label %mat_b.i648, label %mat_b.i648.thread

mat_b.i648.thread:                                ; preds = %mat_a.i643
  %araw.i646 = and i64 %aw1.i636, -4
  %alptr.i647 = inttoptr i64 %araw.i646 to ptr
  br label %alloc_heap.i655

mat_b.i648:                                       ; preds = %mat_a.i643
  %ap4.i680 = lshr i64 %aw0.i635, 32
  %ap4_32.i681 = trunc nuw i64 %ap4.i680 to i32
  store i32 %ap4_32.i681, ptr %atmp.i632, align 4
  %atmp4.i682 = getelementptr inbounds nuw i8, ptr %atmp.i632, i64 4
  store i64 %aw1.i636, ptr %atmp4.i682, align 4
  %fits_sso.i654.not = icmp eq i64 %alen.i637, 12
  br i1 %fits_sso.i654.not, label %alloc_heap.i655, label %build_sso.i670

build_sso.i670:                                   ; preds = %mat_b.i648
  %out_sso8.i671 = getelementptr inbounds nuw i8, ptr %out_sso.i634, i64 8
  %tot32.i672 = trunc nuw nsw i64 %tot.i641 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i634, i8 0, i64 16, i1 false)
  store i32 %tot32.i672, ptr %out_sso.i634, align 8
  %sso_dst_a.i673 = getelementptr inbounds nuw i8, ptr %out_sso.i634, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i673, ptr nonnull align 4 %atmp.i632, i64 %alen.i637, i1 false)
  %sso_dst_b.i674 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i673, i64 %alen.i637
  store i8 44, ptr %sso_dst_b.i674, align 1
  %rw0.i675 = load i64, ptr %out_sso.i634, align 8
  %rw1.i676 = load i64, ptr %out_sso8.i671, align 8
  %rs0.i677 = insertvalue %ArchxStr poison, i64 %rw0.i675, 0
  %rs1.i678 = insertvalue %ArchxStr %rs0.i677, i64 %rw1.i676, 1
  br label %archx_str_concat.exit685

alloc_heap.i655:                                  ; preds = %mat_b.i648.thread, %mat_b.i648
  %aptr.i6491941 = phi ptr [ %alptr.i647, %mat_b.i648.thread ], [ %atmp.i632, %mat_b.i648 ]
  %hp.i656 = call noalias align 16 ptr @malloc(i64 %tot.i641)
  %hnull.i657 = icmp eq ptr %hp.i656, null
  br i1 %hnull.i657, label %oom.i669, label %copy_long.i658

copy_long.i658:                                   ; preds = %alloc_heap.i655
  %hp_i.i659 = ptrtoint ptr %hp.i656 to i64
  %htagged.i660 = or disjoint i64 %hp_i.i659, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i656, ptr nonnull align 1 %aptr.i6491941, i64 %alen.i637, i1 false)
  %dst_b.i661 = getelementptr inbounds nuw i8, ptr %hp.i656, i64 %alen.i637
  store i8 44, ptr %dst_b.i661, align 1
  %pref32.i662 = load i32, ptr %hp.i656, align 16
  %pref64.i663 = zext i32 %pref32.i662 to i64
  %pref_sh.i664 = shl nuw i64 %pref64.i663, 32
  %w0_out.i665 = or disjoint i64 %pref_sh.i664, %tot.i641
  %ls0.i666 = insertvalue %ArchxStr poison, i64 %w0_out.i665, 0
  %ls1.i667 = insertvalue %ArchxStr %ls0.i666, i64 %htagged.i660, 1
  br label %archx_str_concat.exit685

archx_str_concat.exit685:                         ; preds = %archx_str_concat.exit631, %build_sso.i670, %copy_long.i658
  %common.ret.op.i668 = phi %ArchxStr [ %rs1.i678, %build_sso.i670 ], [ %ls1.i667, %copy_long.i658 ], [ { i64 188978561025, i64 0 }, %archx_str_concat.exit631 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i632)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i634)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1480)
  %n32.i1481 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1480, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 10)
  %len.i1482 = sext i32 %n32.i1481 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1479)
  %z.i.i1483 = icmp slt i32 %n32.i1481, 1
  br i1 %z.i.i1483, label %archx_str_from_int.exit1507, label %chk_sso.i.i1484

oom.i.i1499:                                      ; preds = %alloc_heap.i.i1486
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1484:                                  ; preds = %archx_str_concat.exit685
  %short.i.i1485 = icmp samesign ult i32 %n32.i1481, 13
  br i1 %short.i.i1485, label %pack_sso.i.i1500, label %alloc_heap.i.i1486

pack_sso.i.i1500:                                 ; preds = %chk_sso.i.i1484
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1479, i8 0, i64 16, i1 false)
  store i32 %n32.i1481, ptr %sso.i.i1479, align 8
  %sso.i.i1479.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1479, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1479.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1480, i64 range(i64 -2147483648, 2147483650) %len.i1482, i1 false)
  %sso.i.i1479.0.sso.i.i1479.0.sso.i.i1479.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1502 = load i64, ptr %sso.i.i1479, align 8
  %sso.i.i1479.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1479, i64 8
  %sso.i.i1479.8.sso.i.i1479.8.sso.i.i1479.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1504 = load i64, ptr %sso.i.i1479.8.sroa_idx, align 8
  %ss0.i.i1505 = insertvalue %ArchxStr poison, i64 %sso.i.i1479.0.sso.i.i1479.0.sso.i.i1479.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1502, 0
  %ss1.i.i1506 = insertvalue %ArchxStr %ss0.i.i1505, i64 %sso.i.i1479.8.sso.i.i1479.8.sso.i.i1479.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1504, 1
  br label %archx_str_from_int.exit1507

alloc_heap.i.i1486:                               ; preds = %chk_sso.i.i1484
  %hp.i.i1487 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1482)
  %hnull.i.i1488 = icmp eq ptr %hp.i.i1487, null
  br i1 %hnull.i.i1488, label %oom.i.i1499, label %copy_long.i.i1489

copy_long.i.i1489:                                ; preds = %alloc_heap.i.i1486
  %hp_i.i.i1490 = ptrtoint ptr %hp.i.i1487 to i64
  %htagged.i.i1491 = or disjoint i64 %hp_i.i.i1490, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1487, ptr nonnull readonly align 8 %buf.i1480, i64 range(i64 -2147483648, 2147483650) %len.i1482, i1 false)
  %pref32.i.i1492 = load i32, ptr %hp.i.i1487, align 16
  %pref64.i.i1493 = zext i32 %pref32.i.i1492 to i64
  %pref_sh.i.i1494 = shl nuw i64 %pref64.i.i1493, 32
  %w0_out.i.i1495 = or disjoint i64 %pref_sh.i.i1494, %len.i1482
  %ls0.i.i1496 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1495, 0
  %ls1.i.i1497 = insertvalue %ArchxStr %ls0.i.i1496, i64 %htagged.i.i1491, 1
  br label %archx_str_from_int.exit1507

archx_str_from_int.exit1507:                      ; preds = %archx_str_concat.exit685, %pack_sso.i.i1500, %copy_long.i.i1489
  %common.ret.op.i.i1498 = phi %ArchxStr [ %ss1.i.i1506, %pack_sso.i.i1500 ], [ %ls1.i.i1497, %copy_long.i.i1489 ], [ zeroinitializer, %archx_str_concat.exit685 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1479)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1480)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i686)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i687)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i688)
  %aw0.i689 = extractvalue %ArchxStr %common.ret.op.i668, 0
  %aw1.i690 = extractvalue %ArchxStr %common.ret.op.i668, 1
  %bw0.i691 = extractvalue %ArchxStr %common.ret.op.i.i1498, 0
  %bw1.i692 = extractvalue %ArchxStr %common.ret.op.i.i1498, 1
  %alen.i693 = and i64 %aw0.i689, 4294967295
  %blen.i694 = and i64 %bw0.i691, 4294967295
  %az.i695 = icmp eq i64 %alen.i693, 0
  br i1 %az.i695, label %ret_b_clone.i749, label %chk_bz.i696

ret_b_clone.i749:                                 ; preds = %archx_str_from_int.exit1507
  %long.i1510 = icmp samesign ult i64 %blen.i694, 13
  %tag.i1514 = and i64 %bw1.i692, 3
  %owned.not.i1515 = icmp eq i64 %tag.i1514, 0
  %or.cond2011 = select i1 %long.i1510, i1 true, i1 %owned.not.i1515
  br i1 %or.cond2011, label %archx_str_concat.exit751, label %dup_heap.i1516

dup_heap.i1516:                                   ; preds = %ret_b_clone.i749
  %dst.i1517 = call noalias align 16 ptr @malloc(i64 %blen.i694)
  %isnull.i1518 = icmp eq ptr %dst.i1517, null
  br i1 %isnull.i1518, label %oom.i1525, label %copy.i1519

oom.i1525:                                        ; preds = %dup_heap.i1516
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1519:                                       ; preds = %dup_heap.i1516
  %src_i.i1520 = and i64 %bw1.i692, -4
  %src.i1521 = inttoptr i64 %src_i.i1520 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1517, ptr nonnull align 4 %src.i1521, i64 %blen.i694, i1 false)
  %dst_i.i1522 = ptrtoint ptr %dst.i1517 to i64
  %tagged.i1523 = or disjoint i64 %dst_i.i1522, 1
  %out.i1524 = insertvalue %ArchxStr %common.ret.op.i.i1498, i64 %tagged.i1523, 1
  br label %archx_str_concat.exit751

chk_bz.i696:                                      ; preds = %archx_str_from_int.exit1507
  %bz.i697 = icmp eq i64 %blen.i694, 0
  br i1 %bz.i697, label %ret_a_clone.i747, label %calc_tot.i698

ret_a_clone.i747:                                 ; preds = %chk_bz.i696
  %long.i1529 = icmp samesign ult i64 %alen.i693, 13
  %tag.i1533 = and i64 %aw1.i690, 3
  %owned.not.i1534 = icmp eq i64 %tag.i1533, 0
  %or.cond2012 = select i1 %long.i1529, i1 true, i1 %owned.not.i1534
  br i1 %or.cond2012, label %archx_str_concat.exit751, label %dup_heap.i1535

dup_heap.i1535:                                   ; preds = %ret_a_clone.i747
  %dst.i1536 = call noalias align 16 ptr @malloc(i64 %alen.i693)
  %isnull.i1537 = icmp eq ptr %dst.i1536, null
  br i1 %isnull.i1537, label %oom.i1544, label %copy.i1538

oom.i1544:                                        ; preds = %dup_heap.i1535
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1538:                                       ; preds = %dup_heap.i1535
  %src_i.i1539 = and i64 %aw1.i690, -4
  %src.i1540 = inttoptr i64 %src_i.i1539 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1536, ptr nonnull align 4 %src.i1540, i64 %alen.i693, i1 false)
  %dst_i.i1541 = ptrtoint ptr %dst.i1536 to i64
  %tagged.i1542 = or disjoint i64 %dst_i.i1541, 1
  %out.i1543 = insertvalue %ArchxStr %common.ret.op.i668, i64 %tagged.i1542, 1
  br label %archx_str_concat.exit751

calc_tot.i698:                                    ; preds = %chk_bz.i696
  %tot.i699 = add nuw nsw i64 %blen.i694, %alen.i693
  %too_big.i700 = icmp samesign ugt i64 %tot.i699, 2147483647
  br i1 %too_big.i700, label %oom.i729, label %mat_a.i701

oom.i729:                                         ; preds = %alloc_heap.i715, %calc_tot.i698
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i701:                                       ; preds = %calc_tot.i698
  %ashort.i702 = icmp samesign ult i64 %alen.i693, 13
  br i1 %ashort.i702, label %mat_a_short.i743, label %mat_a_long.i703

mat_a_short.i743:                                 ; preds = %mat_a.i701
  %ap4.i744 = lshr i64 %aw0.i689, 32
  %ap4_32.i745 = trunc nuw i64 %ap4.i744 to i32
  store i32 %ap4_32.i745, ptr %atmp.i686, align 4
  %atmp4.i746 = getelementptr inbounds nuw i8, ptr %atmp.i686, i64 4
  store i64 %aw1.i690, ptr %atmp4.i746, align 4
  br label %mat_b.i706

mat_a_long.i703:                                  ; preds = %mat_a.i701
  %araw.i704 = and i64 %aw1.i690, -4
  %alptr.i705 = inttoptr i64 %araw.i704 to ptr
  br label %mat_b.i706

mat_b.i706:                                       ; preds = %mat_a_long.i703, %mat_a_short.i743
  %aptr.i707 = phi ptr [ %atmp.i686, %mat_a_short.i743 ], [ %alptr.i705, %mat_a_long.i703 ]
  %bshort.i708 = icmp samesign ult i64 %blen.i694, 13
  br i1 %bshort.i708, label %mat_b_short.i739, label %mat_b_long.i709

mat_b_short.i739:                                 ; preds = %mat_b.i706
  %bp4.i740 = lshr i64 %bw0.i691, 32
  %bp4_32.i741 = trunc nuw i64 %bp4.i740 to i32
  store i32 %bp4_32.i741, ptr %btmp.i687, align 4
  %btmp4.i742 = getelementptr inbounds nuw i8, ptr %btmp.i687, i64 4
  store i64 %bw1.i692, ptr %btmp4.i742, align 4
  br label %build.i712

mat_b_long.i709:                                  ; preds = %mat_b.i706
  %braw.i710 = and i64 %bw1.i692, -4
  %blptr.i711 = inttoptr i64 %braw.i710 to ptr
  br label %build.i712

build.i712:                                       ; preds = %mat_b_long.i709, %mat_b_short.i739
  %bptr.i713 = phi ptr [ %btmp.i687, %mat_b_short.i739 ], [ %blptr.i711, %mat_b_long.i709 ]
  %fits_sso.i714 = icmp samesign ult i64 %tot.i699, 13
  br i1 %fits_sso.i714, label %build_sso.i730, label %alloc_heap.i715

build_sso.i730:                                   ; preds = %build.i712
  %out_sso8.i731 = getelementptr inbounds nuw i8, ptr %out_sso.i688, i64 8
  %tot32.i732 = trunc nuw nsw i64 %tot.i699 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i688, i8 0, i64 16, i1 false)
  store i32 %tot32.i732, ptr %out_sso.i688, align 8
  %sso_dst_a.i733 = getelementptr inbounds nuw i8, ptr %out_sso.i688, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i733, ptr nonnull align 1 %aptr.i707, i64 %alen.i693, i1 false)
  %sso_dst_b.i734 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i733, i64 %alen.i693
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i734, ptr nonnull align 1 %bptr.i713, i64 %blen.i694, i1 false)
  %rw0.i735 = load i64, ptr %out_sso.i688, align 8
  %rw1.i736 = load i64, ptr %out_sso8.i731, align 8
  %rs0.i737 = insertvalue %ArchxStr poison, i64 %rw0.i735, 0
  %rs1.i738 = insertvalue %ArchxStr %rs0.i737, i64 %rw1.i736, 1
  br label %archx_str_concat.exit751

alloc_heap.i715:                                  ; preds = %build.i712
  %hp.i716 = call noalias align 16 ptr @malloc(i64 %tot.i699)
  %hnull.i717 = icmp eq ptr %hp.i716, null
  br i1 %hnull.i717, label %oom.i729, label %copy_long.i718

copy_long.i718:                                   ; preds = %alloc_heap.i715
  %hp_i.i719 = ptrtoint ptr %hp.i716 to i64
  %htagged.i720 = or disjoint i64 %hp_i.i719, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i716, ptr nonnull align 1 %aptr.i707, i64 %alen.i693, i1 false)
  %dst_b.i721 = getelementptr inbounds nuw i8, ptr %hp.i716, i64 %alen.i693
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i721, ptr nonnull align 1 %bptr.i713, i64 %blen.i694, i1 false)
  %pref32.i722 = load i32, ptr %hp.i716, align 16
  %pref64.i723 = zext i32 %pref32.i722 to i64
  %pref_sh.i724 = shl nuw i64 %pref64.i723, 32
  %w0_out.i725 = or disjoint i64 %pref_sh.i724, %tot.i699
  %ls0.i726 = insertvalue %ArchxStr poison, i64 %w0_out.i725, 0
  %ls1.i727 = insertvalue %ArchxStr %ls0.i726, i64 %htagged.i720, 1
  br label %archx_str_concat.exit751

archx_str_concat.exit751:                         ; preds = %copy.i1538, %ret_a_clone.i747, %copy.i1519, %ret_b_clone.i749, %build_sso.i730, %copy_long.i718
  %common.ret.op.i728 = phi %ArchxStr [ %rs1.i738, %build_sso.i730 ], [ %ls1.i727, %copy_long.i718 ], [ %out.i1524, %copy.i1519 ], [ %common.ret.op.i.i1498, %ret_b_clone.i749 ], [ %out.i1543, %copy.i1538 ], [ %common.ret.op.i668, %ret_a_clone.i747 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i686)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i687)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i688)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i752)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i754)
  %aw0.i755 = extractvalue %ArchxStr %common.ret.op.i728, 0
  %aw1.i756 = extractvalue %ArchxStr %common.ret.op.i728, 1
  %alen.i757 = and i64 %aw0.i755, 4294967295
  %az.i758 = icmp eq i64 %alen.i757, 0
  br i1 %az.i758, label %archx_str_concat.exit805, label %chk_bz.i759

chk_bz.i759:                                      ; preds = %archx_str_concat.exit751
  %tot.i761 = add nuw nsw i64 %alen.i757, 5
  %too_big.i762 = icmp samesign ugt i64 %alen.i757, 2147483642
  br i1 %too_big.i762, label %oom.i789, label %mat_a.i763

oom.i789:                                         ; preds = %alloc_heap.i775, %chk_bz.i759
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i763:                                       ; preds = %chk_bz.i759
  %ashort.i764 = icmp samesign ult i64 %alen.i757, 13
  br i1 %ashort.i764, label %mat_b.i768, label %mat_b.i768.thread

mat_b.i768.thread:                                ; preds = %mat_a.i763
  %araw.i766 = and i64 %aw1.i756, -4
  %alptr.i767 = inttoptr i64 %araw.i766 to ptr
  br label %alloc_heap.i775

mat_b.i768:                                       ; preds = %mat_a.i763
  %ap4.i800 = lshr i64 %aw0.i755, 32
  %ap4_32.i801 = trunc nuw i64 %ap4.i800 to i32
  store i32 %ap4_32.i801, ptr %atmp.i752, align 4
  %atmp4.i802 = getelementptr inbounds nuw i8, ptr %atmp.i752, i64 4
  store i64 %aw1.i756, ptr %atmp4.i802, align 4
  %fits_sso.i774 = icmp samesign ult i64 %alen.i757, 8
  br i1 %fits_sso.i774, label %build_sso.i790, label %alloc_heap.i775

build_sso.i790:                                   ; preds = %mat_b.i768
  %out_sso8.i791 = getelementptr inbounds nuw i8, ptr %out_sso.i754, i64 8
  %tot32.i792 = trunc nuw nsw i64 %tot.i761 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i754, i8 0, i64 16, i1 false)
  store i32 %tot32.i792, ptr %out_sso.i754, align 8
  %sso_dst_a.i793 = getelementptr inbounds nuw i8, ptr %out_sso.i754, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i793, ptr nonnull align 4 %atmp.i752, i64 %alen.i757, i1 false)
  %sso_dst_b.i794 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i793, i64 %alen.i757
  store i32 1886745632, ptr %sso_dst_b.i794, align 1
  %btmp.i753.sroa.5.0.sso_dst_b.i794.sroa_idx = getelementptr inbounds nuw i8, ptr %sso_dst_b.i794, i64 4
  store i8 61, ptr %btmp.i753.sroa.5.0.sso_dst_b.i794.sroa_idx, align 1
  %rw0.i795 = load i64, ptr %out_sso.i754, align 8
  %rw1.i796 = load i64, ptr %out_sso8.i791, align 8
  %rs0.i797 = insertvalue %ArchxStr poison, i64 %rw0.i795, 0
  %rs1.i798 = insertvalue %ArchxStr %rs0.i797, i64 %rw1.i796, 1
  br label %archx_str_concat.exit805

alloc_heap.i775:                                  ; preds = %mat_b.i768.thread, %mat_b.i768
  %aptr.i7691944 = phi ptr [ %alptr.i767, %mat_b.i768.thread ], [ %atmp.i752, %mat_b.i768 ]
  %hp.i776 = call noalias align 16 ptr @malloc(i64 %tot.i761)
  %hnull.i777 = icmp eq ptr %hp.i776, null
  br i1 %hnull.i777, label %oom.i789, label %copy_long.i778

copy_long.i778:                                   ; preds = %alloc_heap.i775
  %hp_i.i779 = ptrtoint ptr %hp.i776 to i64
  %htagged.i780 = or disjoint i64 %hp_i.i779, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i776, ptr nonnull align 1 %aptr.i7691944, i64 %alen.i757, i1 false)
  %dst_b.i781 = getelementptr inbounds nuw i8, ptr %hp.i776, i64 %alen.i757
  store i32 1886745632, ptr %dst_b.i781, align 1
  %btmp.i753.sroa.5.0.dst_b.i781.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i781, i64 4
  store i8 61, ptr %btmp.i753.sroa.5.0.dst_b.i781.sroa_idx, align 1
  %pref32.i782 = load i32, ptr %hp.i776, align 16
  %pref64.i783 = zext i32 %pref32.i782 to i64
  %pref_sh.i784 = shl nuw i64 %pref64.i783, 32
  %w0_out.i785 = or disjoint i64 %pref_sh.i784, %tot.i761
  %ls0.i786 = insertvalue %ArchxStr poison, i64 %w0_out.i785, 0
  %ls1.i787 = insertvalue %ArchxStr %ls0.i786, i64 %htagged.i780, 1
  br label %archx_str_concat.exit805

archx_str_concat.exit805:                         ; preds = %archx_str_concat.exit751, %build_sso.i790, %copy_long.i778
  %common.ret.op.i788 = phi %ArchxStr [ %rs1.i798, %build_sso.i790 ], [ %ls1.i787, %copy_long.i778 ], [ { i64 8103510785310851077, i64 61 }, %archx_str_concat.exit751 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i752)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i754)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i806)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i808)
  %aw0.i809 = extractvalue %ArchxStr %common.ret.op.i788, 0
  %aw1.i810 = extractvalue %ArchxStr %common.ret.op.i788, 1
  %alen.i811 = and i64 %aw0.i809, 4294967295
  %az.i812 = icmp eq i64 %alen.i811, 0
  br i1 %az.i812, label %archx_str_concat.exit859, label %chk_bz.i813

chk_bz.i813:                                      ; preds = %archx_str_concat.exit805
  %tot.i815 = add nuw nsw i64 %alen.i811, 5
  %too_big.i816 = icmp samesign ugt i64 %alen.i811, 2147483642
  br i1 %too_big.i816, label %oom.i843, label %mat_a.i817

oom.i843:                                         ; preds = %alloc_heap.i829, %chk_bz.i813
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i817:                                       ; preds = %chk_bz.i813
  %ashort.i818 = icmp samesign ult i64 %alen.i811, 13
  br i1 %ashort.i818, label %mat_b.i822, label %mat_b.i822.thread

mat_b.i822.thread:                                ; preds = %mat_a.i817
  %araw.i820 = and i64 %aw1.i810, -4
  %alptr.i821 = inttoptr i64 %araw.i820 to ptr
  br label %alloc_heap.i829

mat_b.i822:                                       ; preds = %mat_a.i817
  %ap4.i854 = lshr i64 %aw0.i809, 32
  %ap4_32.i855 = trunc nuw i64 %ap4.i854 to i32
  store i32 %ap4_32.i855, ptr %atmp.i806, align 4
  %atmp4.i856 = getelementptr inbounds nuw i8, ptr %atmp.i806, i64 4
  store i64 %aw1.i810, ptr %atmp4.i856, align 4
  %fits_sso.i828 = icmp samesign ult i64 %alen.i811, 8
  br i1 %fits_sso.i828, label %build_sso.i844, label %alloc_heap.i829

build_sso.i844:                                   ; preds = %mat_b.i822
  %out_sso8.i845 = getelementptr inbounds nuw i8, ptr %out_sso.i808, i64 8
  %tot32.i846 = trunc nuw nsw i64 %tot.i815 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i808, i8 0, i64 16, i1 false)
  store i32 %tot32.i846, ptr %out_sso.i808, align 8
  %sso_dst_a.i847 = getelementptr inbounds nuw i8, ptr %out_sso.i808, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i847, ptr nonnull align 4 %atmp.i806, i64 %alen.i811, i1 false)
  %sso_dst_b.i848 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i847, i64 %alen.i811
  store i32 1751347809, ptr %sso_dst_b.i848, align 1
  %btmp.i807.sroa.5.0.sso_dst_b.i848.sroa_idx = getelementptr inbounds nuw i8, ptr %sso_dst_b.i848, i64 4
  store i8 120, ptr %btmp.i807.sroa.5.0.sso_dst_b.i848.sroa_idx, align 1
  %rw0.i849 = load i64, ptr %out_sso.i808, align 8
  %rw1.i850 = load i64, ptr %out_sso8.i845, align 8
  %rs0.i851 = insertvalue %ArchxStr poison, i64 %rw0.i849, 0
  %rs1.i852 = insertvalue %ArchxStr %rs0.i851, i64 %rw1.i850, 1
  br label %archx_str_concat.exit859

alloc_heap.i829:                                  ; preds = %mat_b.i822.thread, %mat_b.i822
  %aptr.i8231947 = phi ptr [ %alptr.i821, %mat_b.i822.thread ], [ %atmp.i806, %mat_b.i822 ]
  %hp.i830 = call noalias align 16 ptr @malloc(i64 %tot.i815)
  %hnull.i831 = icmp eq ptr %hp.i830, null
  br i1 %hnull.i831, label %oom.i843, label %copy_long.i832

copy_long.i832:                                   ; preds = %alloc_heap.i829
  %hp_i.i833 = ptrtoint ptr %hp.i830 to i64
  %htagged.i834 = or disjoint i64 %hp_i.i833, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i830, ptr nonnull align 1 %aptr.i8231947, i64 %alen.i811, i1 false)
  %dst_b.i835 = getelementptr inbounds nuw i8, ptr %hp.i830, i64 %alen.i811
  store i32 1751347809, ptr %dst_b.i835, align 1
  %btmp.i807.sroa.5.0.dst_b.i835.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i835, i64 4
  store i8 120, ptr %btmp.i807.sroa.5.0.dst_b.i835.sroa_idx, align 1
  %pref32.i836 = load i32, ptr %hp.i830, align 16
  %pref64.i837 = zext i32 %pref32.i836 to i64
  %pref_sh.i838 = shl nuw i64 %pref64.i837, 32
  %w0_out.i839 = or disjoint i64 %pref_sh.i838, %tot.i815
  %ls0.i840 = insertvalue %ArchxStr poison, i64 %w0_out.i839, 0
  %ls1.i841 = insertvalue %ArchxStr %ls0.i840, i64 %htagged.i834, 1
  br label %archx_str_concat.exit859

archx_str_concat.exit859:                         ; preds = %archx_str_concat.exit805, %build_sso.i844, %copy_long.i832
  %common.ret.op.i842 = phi %ArchxStr [ %rs1.i852, %build_sso.i844 ], [ %ls1.i841, %copy_long.i832 ], [ { i64 7521981563576254469, i64 120 }, %archx_str_concat.exit805 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i806)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i808)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i860)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i862)
  %aw0.i863 = extractvalue %ArchxStr %common.ret.op.i842, 0
  %aw1.i864 = extractvalue %ArchxStr %common.ret.op.i842, 1
  %alen.i865 = and i64 %aw0.i863, 4294967295
  %az.i866 = icmp eq i64 %alen.i865, 0
  br i1 %az.i866, label %archx_str_concat.exit913, label %chk_bz.i867

chk_bz.i867:                                      ; preds = %archx_str_concat.exit859
  %tot.i869 = add nuw nsw i64 %alen.i865, 1
  %too_big.i870 = icmp samesign ugt i64 %alen.i865, 2147483646
  br i1 %too_big.i870, label %oom.i897, label %mat_a.i871

oom.i897:                                         ; preds = %alloc_heap.i883, %chk_bz.i867
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i871:                                       ; preds = %chk_bz.i867
  %ashort.i872 = icmp samesign ult i64 %alen.i865, 13
  br i1 %ashort.i872, label %mat_b.i876, label %mat_b.i876.thread

mat_b.i876.thread:                                ; preds = %mat_a.i871
  %araw.i874 = and i64 %aw1.i864, -4
  %alptr.i875 = inttoptr i64 %araw.i874 to ptr
  br label %alloc_heap.i883

mat_b.i876:                                       ; preds = %mat_a.i871
  %ap4.i908 = lshr i64 %aw0.i863, 32
  %ap4_32.i909 = trunc nuw i64 %ap4.i908 to i32
  store i32 %ap4_32.i909, ptr %atmp.i860, align 4
  %atmp4.i910 = getelementptr inbounds nuw i8, ptr %atmp.i860, i64 4
  store i64 %aw1.i864, ptr %atmp4.i910, align 4
  %fits_sso.i882.not = icmp eq i64 %alen.i865, 12
  br i1 %fits_sso.i882.not, label %alloc_heap.i883, label %build_sso.i898

build_sso.i898:                                   ; preds = %mat_b.i876
  %out_sso8.i899 = getelementptr inbounds nuw i8, ptr %out_sso.i862, i64 8
  %tot32.i900 = trunc nuw nsw i64 %tot.i869 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i862, i8 0, i64 16, i1 false)
  store i32 %tot32.i900, ptr %out_sso.i862, align 8
  %sso_dst_a.i901 = getelementptr inbounds nuw i8, ptr %out_sso.i862, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i901, ptr nonnull align 4 %atmp.i860, i64 %alen.i865, i1 false)
  %sso_dst_b.i902 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i901, i64 %alen.i865
  store i8 58, ptr %sso_dst_b.i902, align 1
  %rw0.i903 = load i64, ptr %out_sso.i862, align 8
  %rw1.i904 = load i64, ptr %out_sso8.i899, align 8
  %rs0.i905 = insertvalue %ArchxStr poison, i64 %rw0.i903, 0
  %rs1.i906 = insertvalue %ArchxStr %rs0.i905, i64 %rw1.i904, 1
  br label %archx_str_concat.exit913

alloc_heap.i883:                                  ; preds = %mat_b.i876.thread, %mat_b.i876
  %aptr.i8771950 = phi ptr [ %alptr.i875, %mat_b.i876.thread ], [ %atmp.i860, %mat_b.i876 ]
  %hp.i884 = call noalias align 16 ptr @malloc(i64 %tot.i869)
  %hnull.i885 = icmp eq ptr %hp.i884, null
  br i1 %hnull.i885, label %oom.i897, label %copy_long.i886

copy_long.i886:                                   ; preds = %alloc_heap.i883
  %hp_i.i887 = ptrtoint ptr %hp.i884 to i64
  %htagged.i888 = or disjoint i64 %hp_i.i887, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i884, ptr nonnull align 1 %aptr.i8771950, i64 %alen.i865, i1 false)
  %dst_b.i889 = getelementptr inbounds nuw i8, ptr %hp.i884, i64 %alen.i865
  store i8 58, ptr %dst_b.i889, align 1
  %pref32.i890 = load i32, ptr %hp.i884, align 16
  %pref64.i891 = zext i32 %pref32.i890 to i64
  %pref_sh.i892 = shl nuw i64 %pref64.i891, 32
  %w0_out.i893 = or disjoint i64 %pref_sh.i892, %tot.i869
  %ls0.i894 = insertvalue %ArchxStr poison, i64 %w0_out.i893, 0
  %ls1.i895 = insertvalue %ArchxStr %ls0.i894, i64 %htagged.i888, 1
  br label %archx_str_concat.exit913

archx_str_concat.exit913:                         ; preds = %archx_str_concat.exit859, %build_sso.i898, %copy_long.i886
  %common.ret.op.i896 = phi %ArchxStr [ %rs1.i906, %build_sso.i898 ], [ %ls1.i895, %copy_long.i886 ], [ { i64 249108103169, i64 0 }, %archx_str_concat.exit859 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i860)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i862)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i914)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i916)
  %aw0.i917 = extractvalue %ArchxStr %common.ret.op.i896, 0
  %aw1.i918 = extractvalue %ArchxStr %common.ret.op.i896, 1
  %alen.i919 = and i64 %aw0.i917, 4294967295
  %az.i920 = icmp eq i64 %alen.i919, 0
  br i1 %az.i920, label %archx_str_concat.exit967, label %chk_bz.i921

chk_bz.i921:                                      ; preds = %archx_str_concat.exit913
  %tot.i923 = add nuw nsw i64 %alen.i919, 4
  %too_big.i924 = icmp samesign ugt i64 %alen.i919, 2147483643
  br i1 %too_big.i924, label %oom.i951, label %mat_a.i925

oom.i951:                                         ; preds = %alloc_heap.i937, %chk_bz.i921
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i925:                                       ; preds = %chk_bz.i921
  %ashort.i926 = icmp samesign ult i64 %alen.i919, 13
  br i1 %ashort.i926, label %mat_b.i930, label %mat_b.i930.thread

mat_b.i930.thread:                                ; preds = %mat_a.i925
  %araw.i928 = and i64 %aw1.i918, -4
  %alptr.i929 = inttoptr i64 %araw.i928 to ptr
  br label %alloc_heap.i937

mat_b.i930:                                       ; preds = %mat_a.i925
  %ap4.i962 = lshr i64 %aw0.i917, 32
  %ap4_32.i963 = trunc nuw i64 %ap4.i962 to i32
  store i32 %ap4_32.i963, ptr %atmp.i914, align 4
  %atmp4.i964 = getelementptr inbounds nuw i8, ptr %atmp.i914, i64 4
  store i64 %aw1.i918, ptr %atmp4.i964, align 4
  %fits_sso.i936 = icmp samesign ult i64 %alen.i919, 9
  br i1 %fits_sso.i936, label %build_sso.i952, label %alloc_heap.i937

build_sso.i952:                                   ; preds = %mat_b.i930
  %out_sso8.i953 = getelementptr inbounds nuw i8, ptr %out_sso.i916, i64 8
  %tot32.i954 = trunc nuw nsw i64 %tot.i923 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i916, i8 0, i64 16, i1 false)
  store i32 %tot32.i954, ptr %out_sso.i916, align 8
  %sso_dst_a.i955 = getelementptr inbounds nuw i8, ptr %out_sso.i916, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i955, ptr nonnull align 4 %atmp.i914, i64 %alen.i919, i1 false)
  %sso_dst_b.i956 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i955, i64 %alen.i919
  store i32 1702195828, ptr %sso_dst_b.i956, align 1
  %rw0.i957 = load i64, ptr %out_sso.i916, align 8
  %rw1.i958 = load i64, ptr %out_sso8.i953, align 8
  %rs0.i959 = insertvalue %ArchxStr poison, i64 %rw0.i957, 0
  %rs1.i960 = insertvalue %ArchxStr %rs0.i959, i64 %rw1.i958, 1
  br label %archx_str_concat.exit967

alloc_heap.i937:                                  ; preds = %mat_b.i930.thread, %mat_b.i930
  %aptr.i9311953 = phi ptr [ %alptr.i929, %mat_b.i930.thread ], [ %atmp.i914, %mat_b.i930 ]
  %hp.i938 = call noalias align 16 ptr @malloc(i64 %tot.i923)
  %hnull.i939 = icmp eq ptr %hp.i938, null
  br i1 %hnull.i939, label %oom.i951, label %copy_long.i940

copy_long.i940:                                   ; preds = %alloc_heap.i937
  %hp_i.i941 = ptrtoint ptr %hp.i938 to i64
  %htagged.i942 = or disjoint i64 %hp_i.i941, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i938, ptr nonnull align 1 %aptr.i9311953, i64 %alen.i919, i1 false)
  %dst_b.i943 = getelementptr inbounds nuw i8, ptr %hp.i938, i64 %alen.i919
  store i32 1702195828, ptr %dst_b.i943, align 1
  %pref32.i944 = load i32, ptr %hp.i938, align 16
  %pref64.i945 = zext i32 %pref32.i944 to i64
  %pref_sh.i946 = shl nuw i64 %pref64.i945, 32
  %w0_out.i947 = or disjoint i64 %pref_sh.i946, %tot.i923
  %ls0.i948 = insertvalue %ArchxStr poison, i64 %w0_out.i947, 0
  %ls1.i949 = insertvalue %ArchxStr %ls0.i948, i64 %htagged.i942, 1
  br label %archx_str_concat.exit967

archx_str_concat.exit967:                         ; preds = %archx_str_concat.exit913, %build_sso.i952, %copy_long.i940
  %common.ret.op.i950 = phi %ArchxStr [ %rs1.i960, %build_sso.i952 ], [ %ls1.i949, %copy_long.i940 ], [ { i64 7310875412647641092, i64 0 }, %archx_str_concat.exit913 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i914)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i916)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i968)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i970)
  %aw0.i971 = extractvalue %ArchxStr %common.ret.op.i950, 0
  %aw1.i972 = extractvalue %ArchxStr %common.ret.op.i950, 1
  %alen.i973 = and i64 %aw0.i971, 4294967295
  %az.i974 = icmp eq i64 %alen.i973, 0
  br i1 %az.i974, label %archx_str_concat.exit1021, label %chk_bz.i975

chk_bz.i975:                                      ; preds = %archx_str_concat.exit967
  %tot.i977 = add nuw nsw i64 %alen.i973, 5
  %too_big.i978 = icmp samesign ugt i64 %alen.i973, 2147483642
  br i1 %too_big.i978, label %oom.i1005, label %mat_a.i979

oom.i1005:                                        ; preds = %alloc_heap.i991, %chk_bz.i975
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i979:                                       ; preds = %chk_bz.i975
  %ashort.i980 = icmp samesign ult i64 %alen.i973, 13
  br i1 %ashort.i980, label %mat_b.i984, label %mat_b.i984.thread

mat_b.i984.thread:                                ; preds = %mat_a.i979
  %araw.i982 = and i64 %aw1.i972, -4
  %alptr.i983 = inttoptr i64 %araw.i982 to ptr
  br label %alloc_heap.i991

mat_b.i984:                                       ; preds = %mat_a.i979
  %ap4.i1016 = lshr i64 %aw0.i971, 32
  %ap4_32.i1017 = trunc nuw i64 %ap4.i1016 to i32
  store i32 %ap4_32.i1017, ptr %atmp.i968, align 4
  %atmp4.i1018 = getelementptr inbounds nuw i8, ptr %atmp.i968, i64 4
  store i64 %aw1.i972, ptr %atmp4.i1018, align 4
  %fits_sso.i990 = icmp samesign ult i64 %alen.i973, 8
  br i1 %fits_sso.i990, label %build_sso.i1006, label %alloc_heap.i991

build_sso.i1006:                                  ; preds = %mat_b.i984
  %out_sso8.i1007 = getelementptr inbounds nuw i8, ptr %out_sso.i970, i64 8
  %tot32.i1008 = trunc nuw nsw i64 %tot.i977 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i970, i8 0, i64 16, i1 false)
  store i32 %tot32.i1008, ptr %out_sso.i970, align 8
  %sso_dst_a.i1009 = getelementptr inbounds nuw i8, ptr %out_sso.i970, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1009, ptr nonnull align 4 %atmp.i968, i64 %alen.i973, i1 false)
  %sso_dst_b.i1010 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1009, i64 %alen.i973
  store i32 1852140576, ptr %sso_dst_b.i1010, align 1
  %btmp.i969.sroa.5.0.sso_dst_b.i1010.sroa_idx = getelementptr inbounds nuw i8, ptr %sso_dst_b.i1010, i64 4
  store i8 61, ptr %btmp.i969.sroa.5.0.sso_dst_b.i1010.sroa_idx, align 1
  %rw0.i1011 = load i64, ptr %out_sso.i970, align 8
  %rw1.i1012 = load i64, ptr %out_sso8.i1007, align 8
  %rs0.i1013 = insertvalue %ArchxStr poison, i64 %rw0.i1011, 0
  %rs1.i1014 = insertvalue %ArchxStr %rs0.i1013, i64 %rw1.i1012, 1
  br label %archx_str_concat.exit1021

alloc_heap.i991:                                  ; preds = %mat_b.i984.thread, %mat_b.i984
  %aptr.i9851956 = phi ptr [ %alptr.i983, %mat_b.i984.thread ], [ %atmp.i968, %mat_b.i984 ]
  %hp.i992 = call noalias align 16 ptr @malloc(i64 %tot.i977)
  %hnull.i993 = icmp eq ptr %hp.i992, null
  br i1 %hnull.i993, label %oom.i1005, label %copy_long.i994

copy_long.i994:                                   ; preds = %alloc_heap.i991
  %hp_i.i995 = ptrtoint ptr %hp.i992 to i64
  %htagged.i996 = or disjoint i64 %hp_i.i995, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i992, ptr nonnull align 1 %aptr.i9851956, i64 %alen.i973, i1 false)
  %dst_b.i997 = getelementptr inbounds nuw i8, ptr %hp.i992, i64 %alen.i973
  store i32 1852140576, ptr %dst_b.i997, align 1
  %btmp.i969.sroa.5.0.dst_b.i997.sroa_idx = getelementptr inbounds nuw i8, ptr %dst_b.i997, i64 4
  store i8 61, ptr %btmp.i969.sroa.5.0.dst_b.i997.sroa_idx, align 1
  %pref32.i998 = load i32, ptr %hp.i992, align 16
  %pref64.i999 = zext i32 %pref32.i998 to i64
  %pref_sh.i1000 = shl nuw i64 %pref64.i999, 32
  %w0_out.i1001 = or disjoint i64 %pref_sh.i1000, %tot.i977
  %ls0.i1002 = insertvalue %ArchxStr poison, i64 %w0_out.i1001, 0
  %ls1.i1003 = insertvalue %ArchxStr %ls0.i1002, i64 %htagged.i996, 1
  br label %archx_str_concat.exit1021

archx_str_concat.exit1021:                        ; preds = %archx_str_concat.exit967, %build_sso.i1006, %copy_long.i994
  %common.ret.op.i1004 = phi %ArchxStr [ %rs1.i1014, %build_sso.i1006 ], [ %ls1.i1003, %copy_long.i994 ], [ { i64 7954883201514602501, i64 61 }, %archx_str_concat.exit967 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i968)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i970)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1552)
  %n32.i1553 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1552, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 3)
  %len.i1554 = sext i32 %n32.i1553 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1551)
  %z.i.i1555 = icmp slt i32 %n32.i1553, 1
  br i1 %z.i.i1555, label %archx_str_from_int.exit1579, label %chk_sso.i.i1556

oom.i.i1571:                                      ; preds = %alloc_heap.i.i1558
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1556:                                  ; preds = %archx_str_concat.exit1021
  %short.i.i1557 = icmp samesign ult i32 %n32.i1553, 13
  br i1 %short.i.i1557, label %pack_sso.i.i1572, label %alloc_heap.i.i1558

pack_sso.i.i1572:                                 ; preds = %chk_sso.i.i1556
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1551, i8 0, i64 16, i1 false)
  store i32 %n32.i1553, ptr %sso.i.i1551, align 8
  %sso.i.i1551.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1551, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1551.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1552, i64 range(i64 -2147483648, 2147483650) %len.i1554, i1 false)
  %sso.i.i1551.0.sso.i.i1551.0.sso.i.i1551.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1574 = load i64, ptr %sso.i.i1551, align 8
  %sso.i.i1551.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1551, i64 8
  %sso.i.i1551.8.sso.i.i1551.8.sso.i.i1551.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1576 = load i64, ptr %sso.i.i1551.8.sroa_idx, align 8
  %ss0.i.i1577 = insertvalue %ArchxStr poison, i64 %sso.i.i1551.0.sso.i.i1551.0.sso.i.i1551.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1574, 0
  %ss1.i.i1578 = insertvalue %ArchxStr %ss0.i.i1577, i64 %sso.i.i1551.8.sso.i.i1551.8.sso.i.i1551.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1576, 1
  br label %archx_str_from_int.exit1579

alloc_heap.i.i1558:                               ; preds = %chk_sso.i.i1556
  %hp.i.i1559 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1554)
  %hnull.i.i1560 = icmp eq ptr %hp.i.i1559, null
  br i1 %hnull.i.i1560, label %oom.i.i1571, label %copy_long.i.i1561

copy_long.i.i1561:                                ; preds = %alloc_heap.i.i1558
  %hp_i.i.i1562 = ptrtoint ptr %hp.i.i1559 to i64
  %htagged.i.i1563 = or disjoint i64 %hp_i.i.i1562, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1559, ptr nonnull readonly align 8 %buf.i1552, i64 range(i64 -2147483648, 2147483650) %len.i1554, i1 false)
  %pref32.i.i1564 = load i32, ptr %hp.i.i1559, align 16
  %pref64.i.i1565 = zext i32 %pref32.i.i1564 to i64
  %pref_sh.i.i1566 = shl nuw i64 %pref64.i.i1565, 32
  %w0_out.i.i1567 = or disjoint i64 %pref_sh.i.i1566, %len.i1554
  %ls0.i.i1568 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1567, 0
  %ls1.i.i1569 = insertvalue %ArchxStr %ls0.i.i1568, i64 %htagged.i.i1563, 1
  br label %archx_str_from_int.exit1579

archx_str_from_int.exit1579:                      ; preds = %archx_str_concat.exit1021, %pack_sso.i.i1572, %copy_long.i.i1561
  %common.ret.op.i.i1570 = phi %ArchxStr [ %ss1.i.i1578, %pack_sso.i.i1572 ], [ %ls1.i.i1569, %copy_long.i.i1561 ], [ zeroinitializer, %archx_str_concat.exit1021 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1551)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1552)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i1022)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1023)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i1024)
  %aw0.i1025 = extractvalue %ArchxStr %common.ret.op.i1004, 0
  %aw1.i1026 = extractvalue %ArchxStr %common.ret.op.i1004, 1
  %bw0.i1027 = extractvalue %ArchxStr %common.ret.op.i.i1570, 0
  %bw1.i1028 = extractvalue %ArchxStr %common.ret.op.i.i1570, 1
  %alen.i1029 = and i64 %aw0.i1025, 4294967295
  %blen.i1030 = and i64 %bw0.i1027, 4294967295
  %az.i1031 = icmp eq i64 %alen.i1029, 0
  br i1 %az.i1031, label %ret_b_clone.i1085, label %chk_bz.i1032

ret_b_clone.i1085:                                ; preds = %archx_str_from_int.exit1579
  %long.i1582 = icmp samesign ult i64 %blen.i1030, 13
  %tag.i1586 = and i64 %bw1.i1028, 3
  %owned.not.i1587 = icmp eq i64 %tag.i1586, 0
  %or.cond2013 = select i1 %long.i1582, i1 true, i1 %owned.not.i1587
  br i1 %or.cond2013, label %archx_str_concat.exit1087, label %dup_heap.i1588

dup_heap.i1588:                                   ; preds = %ret_b_clone.i1085
  %dst.i1589 = call noalias align 16 ptr @malloc(i64 %blen.i1030)
  %isnull.i1590 = icmp eq ptr %dst.i1589, null
  br i1 %isnull.i1590, label %oom.i1597, label %copy.i1591

oom.i1597:                                        ; preds = %dup_heap.i1588
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1591:                                       ; preds = %dup_heap.i1588
  %src_i.i1592 = and i64 %bw1.i1028, -4
  %src.i1593 = inttoptr i64 %src_i.i1592 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1589, ptr nonnull align 4 %src.i1593, i64 %blen.i1030, i1 false)
  %dst_i.i1594 = ptrtoint ptr %dst.i1589 to i64
  %tagged.i1595 = or disjoint i64 %dst_i.i1594, 1
  %out.i1596 = insertvalue %ArchxStr %common.ret.op.i.i1570, i64 %tagged.i1595, 1
  br label %archx_str_concat.exit1087

chk_bz.i1032:                                     ; preds = %archx_str_from_int.exit1579
  %bz.i1033 = icmp eq i64 %blen.i1030, 0
  br i1 %bz.i1033, label %ret_a_clone.i1083, label %calc_tot.i1034

ret_a_clone.i1083:                                ; preds = %chk_bz.i1032
  %long.i1601 = icmp samesign ult i64 %alen.i1029, 13
  %tag.i1605 = and i64 %aw1.i1026, 3
  %owned.not.i1606 = icmp eq i64 %tag.i1605, 0
  %or.cond2014 = select i1 %long.i1601, i1 true, i1 %owned.not.i1606
  br i1 %or.cond2014, label %archx_str_concat.exit1087, label %dup_heap.i1607

dup_heap.i1607:                                   ; preds = %ret_a_clone.i1083
  %dst.i1608 = call noalias align 16 ptr @malloc(i64 %alen.i1029)
  %isnull.i1609 = icmp eq ptr %dst.i1608, null
  br i1 %isnull.i1609, label %oom.i1616, label %copy.i1610

oom.i1616:                                        ; preds = %dup_heap.i1607
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1610:                                       ; preds = %dup_heap.i1607
  %src_i.i1611 = and i64 %aw1.i1026, -4
  %src.i1612 = inttoptr i64 %src_i.i1611 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1608, ptr nonnull align 4 %src.i1612, i64 %alen.i1029, i1 false)
  %dst_i.i1613 = ptrtoint ptr %dst.i1608 to i64
  %tagged.i1614 = or disjoint i64 %dst_i.i1613, 1
  %out.i1615 = insertvalue %ArchxStr %common.ret.op.i1004, i64 %tagged.i1614, 1
  br label %archx_str_concat.exit1087

calc_tot.i1034:                                   ; preds = %chk_bz.i1032
  %tot.i1035 = add nuw nsw i64 %blen.i1030, %alen.i1029
  %too_big.i1036 = icmp samesign ugt i64 %tot.i1035, 2147483647
  br i1 %too_big.i1036, label %oom.i1065, label %mat_a.i1037

oom.i1065:                                        ; preds = %alloc_heap.i1051, %calc_tot.i1034
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1037:                                      ; preds = %calc_tot.i1034
  %ashort.i1038 = icmp samesign ult i64 %alen.i1029, 13
  br i1 %ashort.i1038, label %mat_a_short.i1079, label %mat_a_long.i1039

mat_a_short.i1079:                                ; preds = %mat_a.i1037
  %ap4.i1080 = lshr i64 %aw0.i1025, 32
  %ap4_32.i1081 = trunc nuw i64 %ap4.i1080 to i32
  store i32 %ap4_32.i1081, ptr %atmp.i1022, align 4
  %atmp4.i1082 = getelementptr inbounds nuw i8, ptr %atmp.i1022, i64 4
  store i64 %aw1.i1026, ptr %atmp4.i1082, align 4
  br label %mat_b.i1042

mat_a_long.i1039:                                 ; preds = %mat_a.i1037
  %araw.i1040 = and i64 %aw1.i1026, -4
  %alptr.i1041 = inttoptr i64 %araw.i1040 to ptr
  br label %mat_b.i1042

mat_b.i1042:                                      ; preds = %mat_a_long.i1039, %mat_a_short.i1079
  %aptr.i1043 = phi ptr [ %atmp.i1022, %mat_a_short.i1079 ], [ %alptr.i1041, %mat_a_long.i1039 ]
  %bshort.i1044 = icmp samesign ult i64 %blen.i1030, 13
  br i1 %bshort.i1044, label %mat_b_short.i1075, label %mat_b_long.i1045

mat_b_short.i1075:                                ; preds = %mat_b.i1042
  %bp4.i1076 = lshr i64 %bw0.i1027, 32
  %bp4_32.i1077 = trunc nuw i64 %bp4.i1076 to i32
  store i32 %bp4_32.i1077, ptr %btmp.i1023, align 4
  %btmp4.i1078 = getelementptr inbounds nuw i8, ptr %btmp.i1023, i64 4
  store i64 %bw1.i1028, ptr %btmp4.i1078, align 4
  br label %build.i1048

mat_b_long.i1045:                                 ; preds = %mat_b.i1042
  %braw.i1046 = and i64 %bw1.i1028, -4
  %blptr.i1047 = inttoptr i64 %braw.i1046 to ptr
  br label %build.i1048

build.i1048:                                      ; preds = %mat_b_long.i1045, %mat_b_short.i1075
  %bptr.i1049 = phi ptr [ %btmp.i1023, %mat_b_short.i1075 ], [ %blptr.i1047, %mat_b_long.i1045 ]
  %fits_sso.i1050 = icmp samesign ult i64 %tot.i1035, 13
  br i1 %fits_sso.i1050, label %build_sso.i1066, label %alloc_heap.i1051

build_sso.i1066:                                  ; preds = %build.i1048
  %out_sso8.i1067 = getelementptr inbounds nuw i8, ptr %out_sso.i1024, i64 8
  %tot32.i1068 = trunc nuw nsw i64 %tot.i1035 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i1024, i8 0, i64 16, i1 false)
  store i32 %tot32.i1068, ptr %out_sso.i1024, align 8
  %sso_dst_a.i1069 = getelementptr inbounds nuw i8, ptr %out_sso.i1024, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1069, ptr nonnull align 1 %aptr.i1043, i64 %alen.i1029, i1 false)
  %sso_dst_b.i1070 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1069, i64 %alen.i1029
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i1070, ptr nonnull align 1 %bptr.i1049, i64 %blen.i1030, i1 false)
  %rw0.i1071 = load i64, ptr %out_sso.i1024, align 8
  %rw1.i1072 = load i64, ptr %out_sso8.i1067, align 8
  %rs0.i1073 = insertvalue %ArchxStr poison, i64 %rw0.i1071, 0
  %rs1.i1074 = insertvalue %ArchxStr %rs0.i1073, i64 %rw1.i1072, 1
  br label %archx_str_concat.exit1087

alloc_heap.i1051:                                 ; preds = %build.i1048
  %hp.i1052 = call noalias align 16 ptr @malloc(i64 %tot.i1035)
  %hnull.i1053 = icmp eq ptr %hp.i1052, null
  br i1 %hnull.i1053, label %oom.i1065, label %copy_long.i1054

copy_long.i1054:                                  ; preds = %alloc_heap.i1051
  %hp_i.i1055 = ptrtoint ptr %hp.i1052 to i64
  %htagged.i1056 = or disjoint i64 %hp_i.i1055, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i1052, ptr nonnull align 1 %aptr.i1043, i64 %alen.i1029, i1 false)
  %dst_b.i1057 = getelementptr inbounds nuw i8, ptr %hp.i1052, i64 %alen.i1029
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i1057, ptr nonnull align 1 %bptr.i1049, i64 %blen.i1030, i1 false)
  %pref32.i1058 = load i32, ptr %hp.i1052, align 16
  %pref64.i1059 = zext i32 %pref32.i1058 to i64
  %pref_sh.i1060 = shl nuw i64 %pref64.i1059, 32
  %w0_out.i1061 = or disjoint i64 %pref_sh.i1060, %tot.i1035
  %ls0.i1062 = insertvalue %ArchxStr poison, i64 %w0_out.i1061, 0
  %ls1.i1063 = insertvalue %ArchxStr %ls0.i1062, i64 %htagged.i1056, 1
  br label %archx_str_concat.exit1087

archx_str_concat.exit1087:                        ; preds = %copy.i1610, %ret_a_clone.i1083, %copy.i1591, %ret_b_clone.i1085, %build_sso.i1066, %copy_long.i1054
  %common.ret.op.i1064 = phi %ArchxStr [ %rs1.i1074, %build_sso.i1066 ], [ %ls1.i1063, %copy_long.i1054 ], [ %out.i1596, %copy.i1591 ], [ %common.ret.op.i.i1570, %ret_b_clone.i1085 ], [ %out.i1615, %copy.i1610 ], [ %common.ret.op.i1004, %ret_a_clone.i1083 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i1022)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1023)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i1024)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1618)
  %w0.i1619 = extractvalue %ArchxStr %common.ret.op.i1064, 0
  %w1.i1620 = extractvalue %ArchxStr %common.ret.op.i1064, 1
  %len.i1621 = and i64 %w0.i1619, 4294967295
  %short.i1622 = icmp samesign ult i64 %len.i1621, 13
  br i1 %short.i1622, label %emit.i1643, label %emit.thread.i1623

emit.thread.i1623:                                ; preds = %archx_str_concat.exit1087
  %raw.i1624 = and i64 %w1.i1620, -4
  %lptr.i1625 = inttoptr i64 %raw.i1624 to ptr
  br label %chk_nul.i1626

emit.i1643:                                       ; preds = %archx_str_concat.exit1087
  %p4.i1644 = lshr i64 %w0.i1619, 32
  %p4_32.i1645 = trunc nuw i64 %p4.i1644 to i32
  store i32 %p4_32.i1645, ptr %tmp.i1618, align 4
  %tmp4.i1646 = getelementptr inbounds nuw i8, ptr %tmp.i1618, i64 4
  store i64 %w1.i1620, ptr %tmp4.i1646, align 4
  %pos.not.i1647 = icmp eq i64 %len.i1621, 0
  br i1 %pos.not.i1647, label %do_nl.i1638, label %chk_nul.i1626

chk_nul.i1626:                                    ; preds = %emit.i1643, %emit.thread.i1623
  %data3.i1627 = phi ptr [ %lptr.i1625, %emit.thread.i1623 ], [ %tmp.i1618, %emit.i1643 ]
  %nul.i1628 = call ptr @memchr(ptr nonnull %data3.i1627, i32 0, i64 %len.i1621)
  %has_nul.not.i1629 = icmp eq ptr %nul.i1628, null
  br i1 %has_nul.not.i1629, label %fast_printf.i1640, label %byte_loop.i1630

fast_printf.i1640:                                ; preds = %chk_nul.i1626
  %len32.i1641 = trunc i64 %w0.i1619 to i32
  %np.i1642 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1641, ptr nonnull %data3.i1627)
  br label %archx_str_print.exit1648

byte_loop.i1630:                                  ; preds = %chk_nul.i1626, %byte_loop.i1630
  %bi.i1631 = phi i64 [ %bnext.i1636, %byte_loop.i1630 ], [ 0, %chk_nul.i1626 ]
  %bp.i1632 = getelementptr inbounds nuw i8, ptr %data3.i1627, i64 %bi.i1631
  %ch8.i1633 = load i8, ptr %bp.i1632, align 1
  %ch32.i1634 = zext i8 %ch8.i1633 to i32
  %pc.i1635 = call i32 @putchar(i32 %ch32.i1634)
  %bnext.i1636 = add nuw nsw i64 %bi.i1631, 1
  %exitcond.not.i1637 = icmp eq i64 %bnext.i1636, %len.i1621
  br i1 %exitcond.not.i1637, label %do_nl.i1638, label %byte_loop.i1630

do_nl.i1638:                                      ; preds = %byte_loop.i1630, %emit.i1643
  %nc.i1639 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1648

archx_str_print.exit1648:                         ; preds = %fast_printf.i1640, %do_nl.i1638
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1618)
  %tag.i139 = and i64 %w1.i1620, 1
  %owned.not.i140 = icmp eq i64 %tag.i139, 0
  %or.cond2015 = select i1 %short.i1622, i1 true, i1 %owned.not.i140
  br i1 %or.cond2015, label %archx_str_drop.exit144, label %do_free.i141

do_free.i141:                                     ; preds = %archx_str_print.exit1648
  %raw.i142 = and i64 %w1.i1620, -2
  %ptr.i143 = inttoptr i64 %raw.i142 to ptr
  call void @free(ptr %ptr.i143)
  br label %archx_str_drop.exit144

archx_str_drop.exit144:                           ; preds = %archx_str_print.exit1648, %do_free.i141
  %long.i147 = icmp samesign ult i64 %blen.i1030, 13
  %tag.i150 = and i64 %bw1.i1028, 1
  %owned.not.i151 = icmp eq i64 %tag.i150, 0
  %or.cond2016 = select i1 %long.i147, i1 true, i1 %owned.not.i151
  br i1 %or.cond2016, label %archx_str_drop.exit155, label %do_free.i152

do_free.i152:                                     ; preds = %archx_str_drop.exit144
  %raw.i153 = and i64 %bw1.i1028, -2
  %ptr.i154 = inttoptr i64 %raw.i153 to ptr
  call void @free(ptr %ptr.i154)
  br label %archx_str_drop.exit155

archx_str_drop.exit155:                           ; preds = %archx_str_drop.exit144, %do_free.i152
  %long.i158 = icmp samesign ult i64 %alen.i1029, 13
  %tag.i161 = and i64 %aw1.i1026, 1
  %owned.not.i162 = icmp eq i64 %tag.i161, 0
  %or.cond2017 = select i1 %long.i158, i1 true, i1 %owned.not.i162
  br i1 %or.cond2017, label %archx_str_drop.exit166, label %do_free.i163

do_free.i163:                                     ; preds = %archx_str_drop.exit155
  %raw.i164 = and i64 %aw1.i1026, -2
  %ptr.i165 = inttoptr i64 %raw.i164 to ptr
  call void @free(ptr %ptr.i165)
  br label %archx_str_drop.exit166

archx_str_drop.exit166:                           ; preds = %archx_str_drop.exit155, %do_free.i163
  %long.i169 = icmp samesign ult i64 %alen.i973, 13
  %tag.i172 = and i64 %aw1.i972, 1
  %owned.not.i173 = icmp eq i64 %tag.i172, 0
  %or.cond2018 = select i1 %long.i169, i1 true, i1 %owned.not.i173
  br i1 %or.cond2018, label %archx_str_drop.exit177, label %do_free.i174

do_free.i174:                                     ; preds = %archx_str_drop.exit166
  %raw.i175 = and i64 %aw1.i972, -2
  %ptr.i176 = inttoptr i64 %raw.i175 to ptr
  call void @free(ptr %ptr.i176)
  br label %archx_str_drop.exit177

archx_str_drop.exit177:                           ; preds = %archx_str_drop.exit166, %do_free.i174
  %long.i180 = icmp samesign ult i64 %alen.i919, 13
  %tag.i183 = and i64 %aw1.i918, 1
  %owned.not.i184 = icmp eq i64 %tag.i183, 0
  %or.cond2019 = select i1 %long.i180, i1 true, i1 %owned.not.i184
  br i1 %or.cond2019, label %archx_str_drop.exit188, label %do_free.i185

do_free.i185:                                     ; preds = %archx_str_drop.exit177
  %raw.i186 = and i64 %aw1.i918, -2
  %ptr.i187 = inttoptr i64 %raw.i186 to ptr
  call void @free(ptr %ptr.i187)
  br label %archx_str_drop.exit188

archx_str_drop.exit188:                           ; preds = %archx_str_drop.exit177, %do_free.i185
  %long.i191 = icmp samesign ult i64 %alen.i865, 13
  %tag.i194 = and i64 %aw1.i864, 1
  %owned.not.i195 = icmp eq i64 %tag.i194, 0
  %or.cond2020 = select i1 %long.i191, i1 true, i1 %owned.not.i195
  br i1 %or.cond2020, label %archx_str_drop.exit199, label %do_free.i196

do_free.i196:                                     ; preds = %archx_str_drop.exit188
  %raw.i197 = and i64 %aw1.i864, -2
  %ptr.i198 = inttoptr i64 %raw.i197 to ptr
  call void @free(ptr %ptr.i198)
  br label %archx_str_drop.exit199

archx_str_drop.exit199:                           ; preds = %archx_str_drop.exit188, %do_free.i196
  %long.i202 = icmp samesign ult i64 %alen.i811, 13
  %tag.i205 = and i64 %aw1.i810, 1
  %owned.not.i206 = icmp eq i64 %tag.i205, 0
  %or.cond2021 = select i1 %long.i202, i1 true, i1 %owned.not.i206
  br i1 %or.cond2021, label %archx_str_drop.exit210, label %do_free.i207

do_free.i207:                                     ; preds = %archx_str_drop.exit199
  %raw.i208 = and i64 %aw1.i810, -2
  %ptr.i209 = inttoptr i64 %raw.i208 to ptr
  call void @free(ptr %ptr.i209)
  br label %archx_str_drop.exit210

archx_str_drop.exit210:                           ; preds = %archx_str_drop.exit199, %do_free.i207
  %long.i213 = icmp samesign ult i64 %alen.i757, 13
  %tag.i216 = and i64 %aw1.i756, 1
  %owned.not.i217 = icmp eq i64 %tag.i216, 0
  %or.cond2022 = select i1 %long.i213, i1 true, i1 %owned.not.i217
  br i1 %or.cond2022, label %archx_str_drop.exit221, label %do_free.i218

do_free.i218:                                     ; preds = %archx_str_drop.exit210
  %raw.i219 = and i64 %aw1.i756, -2
  %ptr.i220 = inttoptr i64 %raw.i219 to ptr
  call void @free(ptr %ptr.i220)
  br label %archx_str_drop.exit221

archx_str_drop.exit221:                           ; preds = %archx_str_drop.exit210, %do_free.i218
  %long.i224 = icmp samesign ult i64 %blen.i694, 13
  %tag.i227 = and i64 %bw1.i692, 1
  %owned.not.i228 = icmp eq i64 %tag.i227, 0
  %or.cond2023 = select i1 %long.i224, i1 true, i1 %owned.not.i228
  br i1 %or.cond2023, label %archx_str_drop.exit232, label %do_free.i229

do_free.i229:                                     ; preds = %archx_str_drop.exit221
  %raw.i230 = and i64 %bw1.i692, -2
  %ptr.i231 = inttoptr i64 %raw.i230 to ptr
  call void @free(ptr %ptr.i231)
  br label %archx_str_drop.exit232

archx_str_drop.exit232:                           ; preds = %archx_str_drop.exit221, %do_free.i229
  %long.i235 = icmp samesign ult i64 %alen.i693, 13
  %tag.i238 = and i64 %aw1.i690, 1
  %owned.not.i239 = icmp eq i64 %tag.i238, 0
  %or.cond2024 = select i1 %long.i235, i1 true, i1 %owned.not.i239
  br i1 %or.cond2024, label %archx_str_drop.exit243, label %do_free.i240

do_free.i240:                                     ; preds = %archx_str_drop.exit232
  %raw.i241 = and i64 %aw1.i690, -2
  %ptr.i242 = inttoptr i64 %raw.i241 to ptr
  call void @free(ptr %ptr.i242)
  br label %archx_str_drop.exit243

archx_str_drop.exit243:                           ; preds = %archx_str_drop.exit232, %do_free.i240
  %long.i246 = icmp samesign ult i64 %alen.i637, 13
  %tag.i249 = and i64 %aw1.i636, 1
  %owned.not.i250 = icmp eq i64 %tag.i249, 0
  %or.cond2025 = select i1 %long.i246, i1 true, i1 %owned.not.i250
  br i1 %or.cond2025, label %archx_str_drop.exit254, label %do_free.i251

do_free.i251:                                     ; preds = %archx_str_drop.exit243
  %raw.i252 = and i64 %aw1.i636, -2
  %ptr.i253 = inttoptr i64 %raw.i252 to ptr
  call void @free(ptr %ptr.i253)
  br label %archx_str_drop.exit254

archx_str_drop.exit254:                           ; preds = %archx_str_drop.exit243, %do_free.i251
  %long.i257 = icmp samesign ult i64 %blen.i583, 13
  %tag.i260 = and i64 %bw1.i582, 1
  %owned.not.i261 = icmp eq i64 %tag.i260, 0
  %or.cond2026 = select i1 %long.i257, i1 true, i1 %owned.not.i261
  br i1 %or.cond2026, label %archx_str_drop.exit265, label %do_free.i262

do_free.i262:                                     ; preds = %archx_str_drop.exit254
  %raw.i263 = and i64 %bw1.i582, -2
  %ptr.i264 = inttoptr i64 %raw.i263 to ptr
  call void @free(ptr %ptr.i264)
  br label %archx_str_drop.exit265

archx_str_drop.exit265:                           ; preds = %archx_str_drop.exit254, %do_free.i262
  %t6.i = load i64, ptr %t0, align 16
  %t7.i = icmp sgt i64 %t6.i, 20
  br i1 %t7.i, label %archx_fn_find_gt.exit, label %enum.step.2.i

enum.step.2.i:                                    ; preds = %archx_str_drop.exit265
  %t6.1.i = load i64, ptr %t3, align 8
  %t7.1.i = icmp sgt i64 %t6.1.i, 20
  br i1 %t7.1.i, label %archx_fn_find_gt.exit.thread1962, label %enum.step.2.1.i

enum.step.2.1.i:                                  ; preds = %enum.step.2.i
  %t6.2.i = load i64, ptr %t4, align 16
  %t7.2.i = icmp sgt i64 %t6.2.i, 20
  br i1 %t7.2.i, label %archx_fn_find_gt.exit.thread1962, label %enum.step.2.2.i

enum.step.2.2.i:                                  ; preds = %enum.step.2.1.i
  %t6.3.i = load i64, ptr %t5, align 8
  %t7.3.i = icmp sgt i64 %t6.3.i, 20
  br i1 %t7.3.i, label %archx_fn_find_gt.exit.thread1962, label %enum.step.2.3.i

enum.step.2.3.i:                                  ; preds = %enum.step.2.2.i
  %t6.4.i = load i64, ptr %t6, align 16
  %t7.4.i = icmp sgt i64 %t6.4.i, 20
  br i1 %t7.4.i, label %archx_fn_find_gt.exit.thread1962, label %enum.step.2.i1652

archx_fn_find_gt.exit.thread1962:                 ; preds = %enum.step.2.i, %enum.step.2.1.i, %enum.step.2.2.i, %enum.step.2.3.i
  %enum.pos.2.03.lcssa.i.ph = phi i64 [ 4, %enum.step.2.3.i ], [ 3, %enum.step.2.2.i ], [ 2, %enum.step.2.1.i ], [ 1, %enum.step.2.i ]
  %t9.i1964 = insertvalue { i1, i64 } { i1 true, i64 undef }, i64 %enum.pos.2.03.lcssa.i.ph, 1
  br label %enum.step.2.i1652

archx_fn_find_gt.exit:                            ; preds = %archx_str_drop.exit265
  %t7.i1651 = icmp samesign ugt i64 %t6.i, 500
  br i1 %t7.i1651, label %if.then.4.i1669, label %enum.step.2.i1652

if.then.4.i1669:                                  ; preds = %enum.step.2.3.i1664, %enum.step.2.2.i1660, %enum.step.2.1.i1656, %enum.step.2.i1652, %archx_fn_find_gt.exit
  %common.ret.op.i16491960 = phi { i1, i64 } [ { i1 true, i64 0 }, %archx_fn_find_gt.exit ], [ %common.ret.op.i16491961, %enum.step.2.i1652 ], [ %common.ret.op.i16491961, %enum.step.2.1.i1656 ], [ %common.ret.op.i16491961, %enum.step.2.2.i1660 ], [ %common.ret.op.i16491961, %enum.step.2.3.i1664 ]
  %enum.pos.2.03.lcssa.i1670 = phi i64 [ 0, %archx_fn_find_gt.exit ], [ 1, %enum.step.2.i1652 ], [ 2, %enum.step.2.1.i1656 ], [ 3, %enum.step.2.2.i1660 ], [ 4, %enum.step.2.3.i1664 ]
  %t9.i1671 = insertvalue { i1, i64 } { i1 true, i64 undef }, i64 %enum.pos.2.03.lcssa.i1670, 1
  br label %archx_fn_find_gt.exit1672

enum.step.2.i1652:                                ; preds = %enum.step.2.3.i, %archx_fn_find_gt.exit.thread1962, %archx_fn_find_gt.exit
  %common.ret.op.i16491961 = phi { i1, i64 } [ { i1 true, i64 0 }, %archx_fn_find_gt.exit ], [ %t9.i1964, %archx_fn_find_gt.exit.thread1962 ], [ zeroinitializer, %enum.step.2.3.i ]
  %t6.1.i1654 = load i64, ptr %t3, align 8
  %t7.1.i1655 = icmp sgt i64 %t6.1.i1654, 500
  br i1 %t7.1.i1655, label %if.then.4.i1669, label %enum.step.2.1.i1656

enum.step.2.1.i1656:                              ; preds = %enum.step.2.i1652
  %t6.2.i1658 = load i64, ptr %t4, align 16
  %t7.2.i1659 = icmp sgt i64 %t6.2.i1658, 500
  br i1 %t7.2.i1659, label %if.then.4.i1669, label %enum.step.2.2.i1660

enum.step.2.2.i1660:                              ; preds = %enum.step.2.1.i1656
  %t6.3.i1662 = load i64, ptr %t5, align 8
  %t7.3.i1663 = icmp sgt i64 %t6.3.i1662, 500
  br i1 %t7.3.i1663, label %if.then.4.i1669, label %enum.step.2.3.i1664

enum.step.2.3.i1664:                              ; preds = %enum.step.2.2.i1660
  %t6.4.i1666 = load i64, ptr %t6, align 16
  %t7.4.i1667 = icmp sgt i64 %t6.4.i1666, 500
  br i1 %t7.4.i1667, label %if.then.4.i1669, label %archx_fn_find_gt.exit1672

archx_fn_find_gt.exit1672:                        ; preds = %if.then.4.i1669, %enum.step.2.3.i1664
  %common.ret.op.i16491959 = phi { i1, i64 } [ %common.ret.op.i16491960, %if.then.4.i1669 ], [ %common.ret.op.i16491961, %enum.step.2.3.i1664 ]
  %common.ret.op.i1668 = phi { i1, i64 } [ %t9.i1671, %if.then.4.i1669 ], [ zeroinitializer, %enum.step.2.3.i1664 ]
  %t57 = extractvalue { i1, i64 } %common.ret.op.i16491959, 0
  br i1 %t57, label %if.then.2, label %if.merge.4

if.then.2:                                        ; preds = %archx_fn_find_gt.exit1672
  %t58 = extractvalue { i1, i64 } %common.ret.op.i16491959, 1
  %t60 = icmp ugt i64 %t58, 4
  br i1 %t60, label %idx.oob.6, label %idx.ok.5

idx.oob.6:                                        ; preds = %if.then.2
  call fastcc void @archx_bounds_fail(i64 %t58)
  unreachable

idx.ok.5:                                         ; preds = %if.then.2
  %t62 = getelementptr inbounds nuw i64, ptr %t0, i64 %t58
  %t63 = load i64, ptr %t62, align 8
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1674)
  %n32.i1675 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1674, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t63)
  %len.i1676 = sext i32 %n32.i1675 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1673)
  %z.i.i1677 = icmp slt i32 %n32.i1675, 1
  br i1 %z.i.i1677, label %archx_str_from_int.exit1701, label %chk_sso.i.i1678

oom.i.i1693:                                      ; preds = %alloc_heap.i.i1680
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1678:                                  ; preds = %idx.ok.5
  %short.i.i1679 = icmp samesign ult i32 %n32.i1675, 13
  br i1 %short.i.i1679, label %pack_sso.i.i1694, label %alloc_heap.i.i1680

pack_sso.i.i1694:                                 ; preds = %chk_sso.i.i1678
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1673, i8 0, i64 16, i1 false)
  store i32 %n32.i1675, ptr %sso.i.i1673, align 8
  %sso.i.i1673.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1673, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1673.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1674, i64 range(i64 -2147483648, 2147483650) %len.i1676, i1 false)
  %sso.i.i1673.0.sso.i.i1673.0.sso.i.i1673.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1696 = load i64, ptr %sso.i.i1673, align 8
  %sso.i.i1673.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1673, i64 8
  %sso.i.i1673.8.sso.i.i1673.8.sso.i.i1673.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1698 = load i64, ptr %sso.i.i1673.8.sroa_idx, align 8
  %ss0.i.i1699 = insertvalue %ArchxStr poison, i64 %sso.i.i1673.0.sso.i.i1673.0.sso.i.i1673.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1696, 0
  %ss1.i.i1700 = insertvalue %ArchxStr %ss0.i.i1699, i64 %sso.i.i1673.8.sso.i.i1673.8.sso.i.i1673.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1698, 1
  br label %archx_str_from_int.exit1701

alloc_heap.i.i1680:                               ; preds = %chk_sso.i.i1678
  %hp.i.i1681 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1676)
  %hnull.i.i1682 = icmp eq ptr %hp.i.i1681, null
  br i1 %hnull.i.i1682, label %oom.i.i1693, label %copy_long.i.i1683

copy_long.i.i1683:                                ; preds = %alloc_heap.i.i1680
  %hp_i.i.i1684 = ptrtoint ptr %hp.i.i1681 to i64
  %htagged.i.i1685 = or disjoint i64 %hp_i.i.i1684, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1681, ptr nonnull readonly align 8 %buf.i1674, i64 range(i64 -2147483648, 2147483650) %len.i1676, i1 false)
  %pref32.i.i1686 = load i32, ptr %hp.i.i1681, align 16
  %pref64.i.i1687 = zext i32 %pref32.i.i1686 to i64
  %pref_sh.i.i1688 = shl nuw i64 %pref64.i.i1687, 32
  %w0_out.i.i1689 = or disjoint i64 %pref_sh.i.i1688, %len.i1676
  %ls0.i.i1690 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1689, 0
  %ls1.i.i1691 = insertvalue %ArchxStr %ls0.i.i1690, i64 %htagged.i.i1685, 1
  br label %archx_str_from_int.exit1701

archx_str_from_int.exit1701:                      ; preds = %idx.ok.5, %pack_sso.i.i1694, %copy_long.i.i1683
  %common.ret.op.i.i1692 = phi %ArchxStr [ %ss1.i.i1700, %pack_sso.i.i1694 ], [ %ls1.i.i1691, %copy_long.i.i1683 ], [ zeroinitializer, %idx.ok.5 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1673)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1674)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1089)
  %bw0.i1091 = extractvalue %ArchxStr %common.ret.op.i.i1692, 0
  %bw1.i1092 = extractvalue %ArchxStr %common.ret.op.i.i1692, 1
  %blen.i1093 = and i64 %bw0.i1091, 4294967295
  %bz.i1095 = icmp eq i64 %blen.i1093, 0
  br i1 %bz.i1095, label %archx_str_concat.exit1141, label %calc_tot.i1096

calc_tot.i1096:                                   ; preds = %archx_str_from_int.exit1701
  %tot.i1097 = add nuw nsw i64 %blen.i1093, 6
  %too_big.i1098 = icmp samesign ugt i64 %blen.i1093, 2147483641
  br i1 %too_big.i1098, label %oom.i1125, label %mat_a.i1099

oom.i1125:                                        ; preds = %alloc_heap.i1111, %calc_tot.i1096
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1099:                                      ; preds = %calc_tot.i1096
  %bshort.i1104 = icmp samesign ult i64 %blen.i1093, 13
  br i1 %bshort.i1104, label %build.i1108, label %build.i1108.thread

build.i1108.thread:                               ; preds = %mat_a.i1099
  %braw.i1106 = and i64 %bw1.i1092, -4
  %blptr.i1107 = inttoptr i64 %braw.i1106 to ptr
  br label %alloc_heap.i1111

build.i1108:                                      ; preds = %mat_a.i1099
  %bp4.i1136 = lshr i64 %bw0.i1091, 32
  %bp4_32.i1137 = trunc nuw i64 %bp4.i1136 to i32
  store i32 %bp4_32.i1137, ptr %btmp.i1089, align 4
  %btmp4.i1138 = getelementptr inbounds nuw i8, ptr %btmp.i1089, i64 4
  store i64 %bw1.i1092, ptr %btmp4.i1138, align 4
  %fits_sso.i1110 = icmp samesign ult i64 %blen.i1093, 7
  br i1 %fits_sso.i1110, label %build_sso.i1126, label %alloc_heap.i1111

build_sso.i1126:                                  ; preds = %build.i1108
  store i48 0, ptr %out_sso.i1090.sroa.6.sroa.5.sroa.0, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i1090.sroa.6.sroa.5.sroa.0, ptr nonnull align 4 %btmp.i1089, i64 %blen.i1093, i1 false)
  %out_sso.i1090.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i1097, 7959390400324567040
  %out_sso.i1090.sroa.6.sroa.5.sroa.0.0.out_sso.i1090.sroa.6.sroa.5.sroa.0.0.out_sso.i1090.sroa.6.sroa.5.sroa.0.0.out_sso.i1090.sroa.6.sroa.5.sroa.0.0.out_sso.i1090.sroa.6.sroa.5.0.out_sso.i1090.sroa.6.8.rw1.i1132 = load i48, ptr %out_sso.i1090.sroa.6.sroa.5.sroa.0, align 8
  %out_sso.i1090.sroa.6.sroa.5.0.insert.ext = zext i48 %out_sso.i1090.sroa.6.sroa.5.sroa.0.0.out_sso.i1090.sroa.6.sroa.5.sroa.0.0.out_sso.i1090.sroa.6.sroa.5.sroa.0.0.out_sso.i1090.sroa.6.sroa.5.sroa.0.0.out_sso.i1090.sroa.6.sroa.5.0.out_sso.i1090.sroa.6.8.rw1.i1132 to i64
  %out_sso.i1090.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i1090.sroa.6.sroa.5.0.insert.ext, 16
  %out_sso.i1090.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i1090.sroa.6.sroa.5.0.insert.shift, 15716
  %rs0.i1133 = insertvalue %ArchxStr poison, i64 %out_sso.i1090.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i1134 = insertvalue %ArchxStr %rs0.i1133, i64 %out_sso.i1090.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit1141

alloc_heap.i1111:                                 ; preds = %build.i1108.thread, %build.i1108
  %bptr.i11092070 = phi ptr [ %blptr.i1107, %build.i1108.thread ], [ %btmp.i1089, %build.i1108 ]
  %hp.i1112 = call noalias align 16 ptr @malloc(i64 %tot.i1097)
  %hnull.i1113 = icmp eq ptr %hp.i1112, null
  br i1 %hnull.i1113, label %oom.i1125, label %copy_long.i1114

copy_long.i1114:                                  ; preds = %alloc_heap.i1111
  %hp_i.i1115 = ptrtoint ptr %hp.i1112 to i64
  %htagged.i1116 = or disjoint i64 %hp_i.i1115, 1
  store i32 1853189990, ptr %hp.i1112, align 16
  %atmp.i1088.sroa.5.0.hp.i1112.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i1112, i64 4
  store i16 15716, ptr %atmp.i1088.sroa.5.0.hp.i1112.sroa_idx, align 4
  %dst_b.i1117 = getelementptr inbounds nuw i8, ptr %hp.i1112, i64 6
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 2 %dst_b.i1117, ptr nonnull align 1 %bptr.i11092070, i64 %blen.i1093, i1 false)
  %w0_out.i1121 = or disjoint i64 %tot.i1097, 7959390400324567040
  %ls0.i1122 = insertvalue %ArchxStr poison, i64 %w0_out.i1121, 0
  %ls1.i1123 = insertvalue %ArchxStr %ls0.i1122, i64 %htagged.i1116, 1
  br label %archx_str_concat.exit1141

archx_str_concat.exit1141:                        ; preds = %archx_str_from_int.exit1701, %build_sso.i1126, %copy_long.i1114
  %common.ret.op.i1124 = phi %ArchxStr [ %rs1.i1134, %build_sso.i1126 ], [ %ls1.i1123, %copy_long.i1114 ], [ { i64 7959390400324567046, i64 15716 }, %archx_str_from_int.exit1701 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1089)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i1142)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i1144)
  %aw0.i1145 = extractvalue %ArchxStr %common.ret.op.i1124, 0
  %aw1.i1146 = extractvalue %ArchxStr %common.ret.op.i1124, 1
  %alen.i1147 = and i64 %aw0.i1145, 4294967295
  %az.i1148 = icmp eq i64 %alen.i1147, 0
  br i1 %az.i1148, label %archx_str_concat.exit1195, label %chk_bz.i1149

chk_bz.i1149:                                     ; preds = %archx_str_concat.exit1141
  %tot.i1151 = add nuw nsw i64 %alen.i1147, 4
  %too_big.i1152 = icmp samesign ugt i64 %alen.i1147, 2147483643
  br i1 %too_big.i1152, label %oom.i1179, label %mat_a.i1153

oom.i1179:                                        ; preds = %alloc_heap.i1165, %chk_bz.i1149
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1153:                                      ; preds = %chk_bz.i1149
  %ashort.i1154 = icmp samesign ult i64 %alen.i1147, 13
  br i1 %ashort.i1154, label %mat_b.i1158, label %mat_b.i1158.thread

mat_b.i1158.thread:                               ; preds = %mat_a.i1153
  %araw.i1156 = and i64 %aw1.i1146, -4
  %alptr.i1157 = inttoptr i64 %araw.i1156 to ptr
  br label %alloc_heap.i1165

mat_b.i1158:                                      ; preds = %mat_a.i1153
  %ap4.i1190 = lshr i64 %aw0.i1145, 32
  %ap4_32.i1191 = trunc nuw i64 %ap4.i1190 to i32
  store i32 %ap4_32.i1191, ptr %atmp.i1142, align 4
  %atmp4.i1192 = getelementptr inbounds nuw i8, ptr %atmp.i1142, i64 4
  store i64 %aw1.i1146, ptr %atmp4.i1192, align 4
  %fits_sso.i1164 = icmp samesign ult i64 %alen.i1147, 9
  br i1 %fits_sso.i1164, label %build_sso.i1180, label %alloc_heap.i1165

build_sso.i1180:                                  ; preds = %mat_b.i1158
  %out_sso8.i1181 = getelementptr inbounds nuw i8, ptr %out_sso.i1144, i64 8
  %tot32.i1182 = trunc nuw nsw i64 %tot.i1151 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i1144, i8 0, i64 16, i1 false)
  store i32 %tot32.i1182, ptr %out_sso.i1144, align 8
  %sso_dst_a.i1183 = getelementptr inbounds nuw i8, ptr %out_sso.i1144, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1183, ptr nonnull align 4 %atmp.i1142, i64 %alen.i1147, i1 false)
  %sso_dst_b.i1184 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1183, i64 %alen.i1147
  store i32 544497952, ptr %sso_dst_b.i1184, align 1
  %rw0.i1185 = load i64, ptr %out_sso.i1144, align 8
  %rw1.i1186 = load i64, ptr %out_sso8.i1181, align 8
  %rs0.i1187 = insertvalue %ArchxStr poison, i64 %rw0.i1185, 0
  %rs1.i1188 = insertvalue %ArchxStr %rs0.i1187, i64 %rw1.i1186, 1
  br label %archx_str_concat.exit1195

alloc_heap.i1165:                                 ; preds = %mat_b.i1158.thread, %mat_b.i1158
  %aptr.i11591968 = phi ptr [ %alptr.i1157, %mat_b.i1158.thread ], [ %atmp.i1142, %mat_b.i1158 ]
  %hp.i1166 = call noalias align 16 ptr @malloc(i64 %tot.i1151)
  %hnull.i1167 = icmp eq ptr %hp.i1166, null
  br i1 %hnull.i1167, label %oom.i1179, label %copy_long.i1168

copy_long.i1168:                                  ; preds = %alloc_heap.i1165
  %hp_i.i1169 = ptrtoint ptr %hp.i1166 to i64
  %htagged.i1170 = or disjoint i64 %hp_i.i1169, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i1166, ptr nonnull align 1 %aptr.i11591968, i64 %alen.i1147, i1 false)
  %dst_b.i1171 = getelementptr inbounds nuw i8, ptr %hp.i1166, i64 %alen.i1147
  store i32 544497952, ptr %dst_b.i1171, align 1
  %pref32.i1172 = load i32, ptr %hp.i1166, align 16
  %pref64.i1173 = zext i32 %pref32.i1172 to i64
  %pref_sh.i1174 = shl nuw i64 %pref64.i1173, 32
  %w0_out.i1175 = or disjoint i64 %pref_sh.i1174, %tot.i1151
  %ls0.i1176 = insertvalue %ArchxStr poison, i64 %w0_out.i1175, 0
  %ls1.i1177 = insertvalue %ArchxStr %ls0.i1176, i64 %htagged.i1170, 1
  br label %archx_str_concat.exit1195

archx_str_concat.exit1195:                        ; preds = %archx_str_concat.exit1141, %build_sso.i1180, %copy_long.i1168
  %common.ret.op.i1178 = phi %ArchxStr [ %rs1.i1188, %build_sso.i1180 ], [ %ls1.i1177, %copy_long.i1168 ], [ { i64 2338600896578977796, i64 0 }, %archx_str_concat.exit1141 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i1142)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i1144)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1705)
  %n32.i1706 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1705, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t58)
  %len.i1707 = sext i32 %n32.i1706 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1704)
  %z.i.i1708 = icmp slt i32 %n32.i1706, 1
  br i1 %z.i.i1708, label %archx_str_from_int.exit1732, label %chk_sso.i.i1709

oom.i.i1724:                                      ; preds = %alloc_heap.i.i1711
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1709:                                  ; preds = %archx_str_concat.exit1195
  %short.i.i1710 = icmp samesign ult i32 %n32.i1706, 13
  br i1 %short.i.i1710, label %pack_sso.i.i1725, label %alloc_heap.i.i1711

pack_sso.i.i1725:                                 ; preds = %chk_sso.i.i1709
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1704, i8 0, i64 16, i1 false)
  store i32 %n32.i1706, ptr %sso.i.i1704, align 8
  %sso.i.i1704.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1704, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1704.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1705, i64 range(i64 -2147483648, 2147483650) %len.i1707, i1 false)
  %sso.i.i1704.0.sso.i.i1704.0.sso.i.i1704.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1727 = load i64, ptr %sso.i.i1704, align 8
  %sso.i.i1704.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1704, i64 8
  %sso.i.i1704.8.sso.i.i1704.8.sso.i.i1704.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1729 = load i64, ptr %sso.i.i1704.8.sroa_idx, align 8
  %ss0.i.i1730 = insertvalue %ArchxStr poison, i64 %sso.i.i1704.0.sso.i.i1704.0.sso.i.i1704.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1727, 0
  %ss1.i.i1731 = insertvalue %ArchxStr %ss0.i.i1730, i64 %sso.i.i1704.8.sso.i.i1704.8.sso.i.i1704.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1729, 1
  br label %archx_str_from_int.exit1732

alloc_heap.i.i1711:                               ; preds = %chk_sso.i.i1709
  %hp.i.i1712 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1707)
  %hnull.i.i1713 = icmp eq ptr %hp.i.i1712, null
  br i1 %hnull.i.i1713, label %oom.i.i1724, label %copy_long.i.i1714

copy_long.i.i1714:                                ; preds = %alloc_heap.i.i1711
  %hp_i.i.i1715 = ptrtoint ptr %hp.i.i1712 to i64
  %htagged.i.i1716 = or disjoint i64 %hp_i.i.i1715, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1712, ptr nonnull readonly align 8 %buf.i1705, i64 range(i64 -2147483648, 2147483650) %len.i1707, i1 false)
  %pref32.i.i1717 = load i32, ptr %hp.i.i1712, align 16
  %pref64.i.i1718 = zext i32 %pref32.i.i1717 to i64
  %pref_sh.i.i1719 = shl nuw i64 %pref64.i.i1718, 32
  %w0_out.i.i1720 = or disjoint i64 %pref_sh.i.i1719, %len.i1707
  %ls0.i.i1721 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1720, 0
  %ls1.i.i1722 = insertvalue %ArchxStr %ls0.i.i1721, i64 %htagged.i.i1716, 1
  br label %archx_str_from_int.exit1732

archx_str_from_int.exit1732:                      ; preds = %archx_str_concat.exit1195, %pack_sso.i.i1725, %copy_long.i.i1714
  %common.ret.op.i.i1723 = phi %ArchxStr [ %ss1.i.i1731, %pack_sso.i.i1725 ], [ %ls1.i.i1722, %copy_long.i.i1714 ], [ zeroinitializer, %archx_str_concat.exit1195 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1704)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1705)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i1196)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1197)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i1198)
  %aw0.i1199 = extractvalue %ArchxStr %common.ret.op.i1178, 0
  %aw1.i1200 = extractvalue %ArchxStr %common.ret.op.i1178, 1
  %bw0.i1201 = extractvalue %ArchxStr %common.ret.op.i.i1723, 0
  %bw1.i1202 = extractvalue %ArchxStr %common.ret.op.i.i1723, 1
  %alen.i1203 = and i64 %aw0.i1199, 4294967295
  %blen.i1204 = and i64 %bw0.i1201, 4294967295
  %az.i1205 = icmp eq i64 %alen.i1203, 0
  br i1 %az.i1205, label %ret_b_clone.i1259, label %chk_bz.i1206

ret_b_clone.i1259:                                ; preds = %archx_str_from_int.exit1732
  %long.i1735 = icmp samesign ult i64 %blen.i1204, 13
  %tag.i1739 = and i64 %bw1.i1202, 3
  %owned.not.i1740 = icmp eq i64 %tag.i1739, 0
  %or.cond2027 = select i1 %long.i1735, i1 true, i1 %owned.not.i1740
  br i1 %or.cond2027, label %archx_str_concat.exit1261, label %dup_heap.i1741

dup_heap.i1741:                                   ; preds = %ret_b_clone.i1259
  %dst.i1742 = call noalias align 16 ptr @malloc(i64 %blen.i1204)
  %isnull.i1743 = icmp eq ptr %dst.i1742, null
  br i1 %isnull.i1743, label %oom.i1750, label %copy.i1744

oom.i1750:                                        ; preds = %dup_heap.i1741
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1744:                                       ; preds = %dup_heap.i1741
  %src_i.i1745 = and i64 %bw1.i1202, -4
  %src.i1746 = inttoptr i64 %src_i.i1745 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1742, ptr nonnull align 4 %src.i1746, i64 %blen.i1204, i1 false)
  %dst_i.i1747 = ptrtoint ptr %dst.i1742 to i64
  %tagged.i1748 = or disjoint i64 %dst_i.i1747, 1
  %out.i1749 = insertvalue %ArchxStr %common.ret.op.i.i1723, i64 %tagged.i1748, 1
  br label %archx_str_concat.exit1261

chk_bz.i1206:                                     ; preds = %archx_str_from_int.exit1732
  %bz.i1207 = icmp eq i64 %blen.i1204, 0
  br i1 %bz.i1207, label %ret_a_clone.i1257, label %calc_tot.i1208

ret_a_clone.i1257:                                ; preds = %chk_bz.i1206
  %long.i1754 = icmp samesign ult i64 %alen.i1203, 13
  %tag.i1758 = and i64 %aw1.i1200, 3
  %owned.not.i1759 = icmp eq i64 %tag.i1758, 0
  %or.cond2028 = select i1 %long.i1754, i1 true, i1 %owned.not.i1759
  br i1 %or.cond2028, label %archx_str_concat.exit1261, label %dup_heap.i1760

dup_heap.i1760:                                   ; preds = %ret_a_clone.i1257
  %dst.i1761 = call noalias align 16 ptr @malloc(i64 %alen.i1203)
  %isnull.i1762 = icmp eq ptr %dst.i1761, null
  br i1 %isnull.i1762, label %oom.i1769, label %copy.i1763

oom.i1769:                                        ; preds = %dup_heap.i1760
  call fastcc void @archx_oom_fail()
  unreachable

copy.i1763:                                       ; preds = %dup_heap.i1760
  %src_i.i1764 = and i64 %aw1.i1200, -4
  %src.i1765 = inttoptr i64 %src_i.i1764 to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i1761, ptr nonnull align 4 %src.i1765, i64 %alen.i1203, i1 false)
  %dst_i.i1766 = ptrtoint ptr %dst.i1761 to i64
  %tagged.i1767 = or disjoint i64 %dst_i.i1766, 1
  %out.i1768 = insertvalue %ArchxStr %common.ret.op.i1178, i64 %tagged.i1767, 1
  br label %archx_str_concat.exit1261

calc_tot.i1208:                                   ; preds = %chk_bz.i1206
  %tot.i1209 = add nuw nsw i64 %blen.i1204, %alen.i1203
  %too_big.i1210 = icmp samesign ugt i64 %tot.i1209, 2147483647
  br i1 %too_big.i1210, label %oom.i1239, label %mat_a.i1211

oom.i1239:                                        ; preds = %alloc_heap.i1225, %calc_tot.i1208
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1211:                                      ; preds = %calc_tot.i1208
  %ashort.i1212 = icmp samesign ult i64 %alen.i1203, 13
  br i1 %ashort.i1212, label %mat_a_short.i1253, label %mat_a_long.i1213

mat_a_short.i1253:                                ; preds = %mat_a.i1211
  %ap4.i1254 = lshr i64 %aw0.i1199, 32
  %ap4_32.i1255 = trunc nuw i64 %ap4.i1254 to i32
  store i32 %ap4_32.i1255, ptr %atmp.i1196, align 4
  %atmp4.i1256 = getelementptr inbounds nuw i8, ptr %atmp.i1196, i64 4
  store i64 %aw1.i1200, ptr %atmp4.i1256, align 4
  br label %mat_b.i1216

mat_a_long.i1213:                                 ; preds = %mat_a.i1211
  %araw.i1214 = and i64 %aw1.i1200, -4
  %alptr.i1215 = inttoptr i64 %araw.i1214 to ptr
  br label %mat_b.i1216

mat_b.i1216:                                      ; preds = %mat_a_long.i1213, %mat_a_short.i1253
  %aptr.i1217 = phi ptr [ %atmp.i1196, %mat_a_short.i1253 ], [ %alptr.i1215, %mat_a_long.i1213 ]
  %bshort.i1218 = icmp samesign ult i64 %blen.i1204, 13
  br i1 %bshort.i1218, label %mat_b_short.i1249, label %mat_b_long.i1219

mat_b_short.i1249:                                ; preds = %mat_b.i1216
  %bp4.i1250 = lshr i64 %bw0.i1201, 32
  %bp4_32.i1251 = trunc nuw i64 %bp4.i1250 to i32
  store i32 %bp4_32.i1251, ptr %btmp.i1197, align 4
  %btmp4.i1252 = getelementptr inbounds nuw i8, ptr %btmp.i1197, i64 4
  store i64 %bw1.i1202, ptr %btmp4.i1252, align 4
  br label %build.i1222

mat_b_long.i1219:                                 ; preds = %mat_b.i1216
  %braw.i1220 = and i64 %bw1.i1202, -4
  %blptr.i1221 = inttoptr i64 %braw.i1220 to ptr
  br label %build.i1222

build.i1222:                                      ; preds = %mat_b_long.i1219, %mat_b_short.i1249
  %bptr.i1223 = phi ptr [ %btmp.i1197, %mat_b_short.i1249 ], [ %blptr.i1221, %mat_b_long.i1219 ]
  %fits_sso.i1224 = icmp samesign ult i64 %tot.i1209, 13
  br i1 %fits_sso.i1224, label %build_sso.i1240, label %alloc_heap.i1225

build_sso.i1240:                                  ; preds = %build.i1222
  %out_sso8.i1241 = getelementptr inbounds nuw i8, ptr %out_sso.i1198, i64 8
  %tot32.i1242 = trunc nuw nsw i64 %tot.i1209 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i1198, i8 0, i64 16, i1 false)
  store i32 %tot32.i1242, ptr %out_sso.i1198, align 8
  %sso_dst_a.i1243 = getelementptr inbounds nuw i8, ptr %out_sso.i1198, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i1243, ptr nonnull align 1 %aptr.i1217, i64 %alen.i1203, i1 false)
  %sso_dst_b.i1244 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i1243, i64 %alen.i1203
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b.i1244, ptr nonnull align 1 %bptr.i1223, i64 %blen.i1204, i1 false)
  %rw0.i1245 = load i64, ptr %out_sso.i1198, align 8
  %rw1.i1246 = load i64, ptr %out_sso8.i1241, align 8
  %rs0.i1247 = insertvalue %ArchxStr poison, i64 %rw0.i1245, 0
  %rs1.i1248 = insertvalue %ArchxStr %rs0.i1247, i64 %rw1.i1246, 1
  br label %archx_str_concat.exit1261

alloc_heap.i1225:                                 ; preds = %build.i1222
  %hp.i1226 = call noalias align 16 ptr @malloc(i64 %tot.i1209)
  %hnull.i1227 = icmp eq ptr %hp.i1226, null
  br i1 %hnull.i1227, label %oom.i1239, label %copy_long.i1228

copy_long.i1228:                                  ; preds = %alloc_heap.i1225
  %hp_i.i1229 = ptrtoint ptr %hp.i1226 to i64
  %htagged.i1230 = or disjoint i64 %hp_i.i1229, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i1226, ptr nonnull align 1 %aptr.i1217, i64 %alen.i1203, i1 false)
  %dst_b.i1231 = getelementptr inbounds nuw i8, ptr %hp.i1226, i64 %alen.i1203
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i1231, ptr nonnull align 1 %bptr.i1223, i64 %blen.i1204, i1 false)
  %pref32.i1232 = load i32, ptr %hp.i1226, align 16
  %pref64.i1233 = zext i32 %pref32.i1232 to i64
  %pref_sh.i1234 = shl nuw i64 %pref64.i1233, 32
  %w0_out.i1235 = or disjoint i64 %pref_sh.i1234, %tot.i1209
  %ls0.i1236 = insertvalue %ArchxStr poison, i64 %w0_out.i1235, 0
  %ls1.i1237 = insertvalue %ArchxStr %ls0.i1236, i64 %htagged.i1230, 1
  br label %archx_str_concat.exit1261

archx_str_concat.exit1261:                        ; preds = %copy.i1763, %ret_a_clone.i1257, %copy.i1744, %ret_b_clone.i1259, %build_sso.i1240, %copy_long.i1228
  %common.ret.op.i1238 = phi %ArchxStr [ %rs1.i1248, %build_sso.i1240 ], [ %ls1.i1237, %copy_long.i1228 ], [ %out.i1749, %copy.i1744 ], [ %common.ret.op.i.i1723, %ret_b_clone.i1259 ], [ %out.i1768, %copy.i1763 ], [ %common.ret.op.i1178, %ret_a_clone.i1257 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i1196)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1197)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i1198)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1771)
  %w0.i1772 = extractvalue %ArchxStr %common.ret.op.i1238, 0
  %w1.i1773 = extractvalue %ArchxStr %common.ret.op.i1238, 1
  %len.i1774 = and i64 %w0.i1772, 4294967295
  %short.i1775 = icmp samesign ult i64 %len.i1774, 13
  br i1 %short.i1775, label %emit.i1796, label %emit.thread.i1776

emit.thread.i1776:                                ; preds = %archx_str_concat.exit1261
  %raw.i1777 = and i64 %w1.i1773, -4
  %lptr.i1778 = inttoptr i64 %raw.i1777 to ptr
  br label %chk_nul.i1779

emit.i1796:                                       ; preds = %archx_str_concat.exit1261
  %p4.i1797 = lshr i64 %w0.i1772, 32
  %p4_32.i1798 = trunc nuw i64 %p4.i1797 to i32
  store i32 %p4_32.i1798, ptr %tmp.i1771, align 4
  %tmp4.i1799 = getelementptr inbounds nuw i8, ptr %tmp.i1771, i64 4
  store i64 %w1.i1773, ptr %tmp4.i1799, align 4
  %pos.not.i1800 = icmp eq i64 %len.i1774, 0
  br i1 %pos.not.i1800, label %do_nl.i1791, label %chk_nul.i1779

chk_nul.i1779:                                    ; preds = %emit.i1796, %emit.thread.i1776
  %data3.i1780 = phi ptr [ %lptr.i1778, %emit.thread.i1776 ], [ %tmp.i1771, %emit.i1796 ]
  %nul.i1781 = call ptr @memchr(ptr nonnull %data3.i1780, i32 0, i64 %len.i1774)
  %has_nul.not.i1782 = icmp eq ptr %nul.i1781, null
  br i1 %has_nul.not.i1782, label %fast_printf.i1793, label %byte_loop.i1783

fast_printf.i1793:                                ; preds = %chk_nul.i1779
  %len32.i1794 = trunc i64 %w0.i1772 to i32
  %np.i1795 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1794, ptr nonnull %data3.i1780)
  br label %archx_str_print.exit1801

byte_loop.i1783:                                  ; preds = %chk_nul.i1779, %byte_loop.i1783
  %bi.i1784 = phi i64 [ %bnext.i1789, %byte_loop.i1783 ], [ 0, %chk_nul.i1779 ]
  %bp.i1785 = getelementptr inbounds nuw i8, ptr %data3.i1780, i64 %bi.i1784
  %ch8.i1786 = load i8, ptr %bp.i1785, align 1
  %ch32.i1787 = zext i8 %ch8.i1786 to i32
  %pc.i1788 = call i32 @putchar(i32 %ch32.i1787)
  %bnext.i1789 = add nuw nsw i64 %bi.i1784, 1
  %exitcond.not.i1790 = icmp eq i64 %bnext.i1789, %len.i1774
  br i1 %exitcond.not.i1790, label %do_nl.i1791, label %byte_loop.i1783

do_nl.i1791:                                      ; preds = %byte_loop.i1783, %emit.i1796
  %nc.i1792 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1801

archx_str_print.exit1801:                         ; preds = %fast_printf.i1793, %do_nl.i1791
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1771)
  %tag.i271 = and i64 %w1.i1773, 1
  %owned.not.i272 = icmp eq i64 %tag.i271, 0
  %or.cond2029 = select i1 %short.i1775, i1 true, i1 %owned.not.i272
  br i1 %or.cond2029, label %archx_str_drop.exit276, label %do_free.i273

do_free.i273:                                     ; preds = %archx_str_print.exit1801
  %raw.i274 = and i64 %w1.i1773, -2
  %ptr.i275 = inttoptr i64 %raw.i274 to ptr
  call void @free(ptr %ptr.i275)
  br label %archx_str_drop.exit276

archx_str_drop.exit276:                           ; preds = %archx_str_print.exit1801, %do_free.i273
  %long.i279 = icmp samesign ult i64 %blen.i1204, 13
  %tag.i282 = and i64 %bw1.i1202, 1
  %owned.not.i283 = icmp eq i64 %tag.i282, 0
  %or.cond2030 = select i1 %long.i279, i1 true, i1 %owned.not.i283
  br i1 %or.cond2030, label %archx_str_drop.exit287, label %do_free.i284

do_free.i284:                                     ; preds = %archx_str_drop.exit276
  %raw.i285 = and i64 %bw1.i1202, -2
  %ptr.i286 = inttoptr i64 %raw.i285 to ptr
  call void @free(ptr %ptr.i286)
  br label %archx_str_drop.exit287

archx_str_drop.exit287:                           ; preds = %archx_str_drop.exit276, %do_free.i284
  %long.i290 = icmp samesign ult i64 %alen.i1203, 13
  %tag.i293 = and i64 %aw1.i1200, 1
  %owned.not.i294 = icmp eq i64 %tag.i293, 0
  %or.cond2031 = select i1 %long.i290, i1 true, i1 %owned.not.i294
  br i1 %or.cond2031, label %archx_str_drop.exit298, label %do_free.i295

do_free.i295:                                     ; preds = %archx_str_drop.exit287
  %raw.i296 = and i64 %aw1.i1200, -2
  %ptr.i297 = inttoptr i64 %raw.i296 to ptr
  call void @free(ptr %ptr.i297)
  br label %archx_str_drop.exit298

archx_str_drop.exit298:                           ; preds = %archx_str_drop.exit287, %do_free.i295
  %long.i301 = icmp samesign ult i64 %alen.i1147, 13
  %tag.i304 = and i64 %aw1.i1146, 1
  %owned.not.i305 = icmp eq i64 %tag.i304, 0
  %or.cond2032 = select i1 %long.i301, i1 true, i1 %owned.not.i305
  br i1 %or.cond2032, label %archx_str_drop.exit309, label %do_free.i306

do_free.i306:                                     ; preds = %archx_str_drop.exit298
  %raw.i307 = and i64 %aw1.i1146, -2
  %ptr.i308 = inttoptr i64 %raw.i307 to ptr
  call void @free(ptr %ptr.i308)
  br label %archx_str_drop.exit309

archx_str_drop.exit309:                           ; preds = %archx_str_drop.exit298, %do_free.i306
  %long.i312 = icmp samesign ult i64 %blen.i1093, 13
  %tag.i315 = and i64 %bw1.i1092, 1
  %owned.not.i316 = icmp eq i64 %tag.i315, 0
  %or.cond2033 = select i1 %long.i312, i1 true, i1 %owned.not.i316
  br i1 %or.cond2033, label %if.merge.4, label %do_free.i317

do_free.i317:                                     ; preds = %archx_str_drop.exit309
  %raw.i318 = and i64 %bw1.i1092, -2
  %ptr.i319 = inttoptr i64 %raw.i318 to ptr
  call void @free(ptr %ptr.i319)
  br label %if.merge.4

if.merge.4:                                       ; preds = %do_free.i317, %archx_str_drop.exit309, %archx_fn_find_gt.exit1672
  %t70 = extractvalue { i1, i64 } %common.ret.op.i1668, 0
  br i1 %t70, label %stropt.some.7, label %build.i1282.thread2080

stropt.some.7:                                    ; preds = %if.merge.4
  %t72 = extractvalue { i1, i64 } %common.ret.op.i1668, 1
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i1803)
  %n32.i1804 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i1803, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t72)
  %len.i1805 = sext i32 %n32.i1804 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i1802)
  %z.i.i1806 = icmp slt i32 %n32.i1804, 1
  br i1 %z.i.i1806, label %stropt.done.8, label %chk_sso.i.i1807

oom.i.i1822:                                      ; preds = %alloc_heap.i.i1809
  call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i1807:                                  ; preds = %stropt.some.7
  %short.i.i1808 = icmp samesign ult i32 %n32.i1804, 13
  br i1 %short.i.i1808, label %pack_sso.i.i1823, label %alloc_heap.i.i1809

pack_sso.i.i1823:                                 ; preds = %chk_sso.i.i1807
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i1802, i8 0, i64 16, i1 false)
  store i32 %n32.i1804, ptr %sso.i.i1802, align 8
  %sso.i.i1802.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1802, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i1802.4.sroa_idx, ptr nonnull readonly align 8 %buf.i1803, i64 range(i64 -2147483648, 2147483650) %len.i1805, i1 false)
  %sso.i.i1802.0.sso.i.i1802.0.sso.i.i1802.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1825 = load i64, ptr %sso.i.i1802, align 8
  %sso.i.i1802.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i1802, i64 8
  %sso.i.i1802.8.sso.i.i1802.8.sso.i.i1802.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1827 = load i64, ptr %sso.i.i1802.8.sroa_idx, align 8
  %ss0.i.i1828 = insertvalue %ArchxStr poison, i64 %sso.i.i1802.0.sso.i.i1802.0.sso.i.i1802.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i1825, 0
  %ss1.i.i1829 = insertvalue %ArchxStr %ss0.i.i1828, i64 %sso.i.i1802.8.sso.i.i1802.8.sso.i.i1802.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i1827, 1
  br label %stropt.done.8

alloc_heap.i.i1809:                               ; preds = %chk_sso.i.i1807
  %hp.i.i1810 = call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483650) %len.i1805)
  %hnull.i.i1811 = icmp eq ptr %hp.i.i1810, null
  br i1 %hnull.i.i1811, label %oom.i.i1822, label %copy_long.i.i1812

copy_long.i.i1812:                                ; preds = %alloc_heap.i.i1809
  %hp_i.i.i1813 = ptrtoint ptr %hp.i.i1810 to i64
  %htagged.i.i1814 = or disjoint i64 %hp_i.i.i1813, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i1810, ptr nonnull readonly align 8 %buf.i1803, i64 range(i64 -2147483648, 2147483650) %len.i1805, i1 false)
  %pref32.i.i1815 = load i32, ptr %hp.i.i1810, align 16
  %pref64.i.i1816 = zext i32 %pref32.i.i1815 to i64
  %pref_sh.i.i1817 = shl nuw i64 %pref64.i.i1816, 32
  %w0_out.i.i1818 = or disjoint i64 %pref_sh.i.i1817, %len.i1805
  %ls0.i.i1819 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1818, 0
  %ls1.i.i1820 = insertvalue %ArchxStr %ls0.i.i1819, i64 %htagged.i.i1814, 1
  br label %stropt.done.8

stropt.done.8:                                    ; preds = %copy_long.i.i1812, %pack_sso.i.i1823, %stropt.some.7
  %common.ret.op.i.i1821 = phi %ArchxStr [ %ss1.i.i1829, %pack_sso.i.i1823 ], [ %ls1.i.i1820, %copy_long.i.i1812 ], [ zeroinitializer, %stropt.some.7 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i1802)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i1803)
  %t73.fca.0.extract = extractvalue %ArchxStr %common.ret.op.i.i1821, 0
  %t73.fca.1.extract = extractvalue %ArchxStr %common.ret.op.i.i1821, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1263)
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %out_sso.i1264.sroa.6.sroa.5)
  %blen.i1267 = and i64 %t73.fca.0.extract, 4294967295
  %bz.i1269 = icmp eq i64 %blen.i1267, 0
  br i1 %bz.i1269, label %archx_str_concat.exit1315, label %calc_tot.i1270

calc_tot.i1270:                                   ; preds = %stropt.done.8
  %tot.i1271 = add nuw nsw i64 %blen.i1267, 8
  %too_big.i1272 = icmp samesign ugt i64 %blen.i1267, 2147483639
  br i1 %too_big.i1272, label %oom.i1299, label %mat_a.i1273

build.i1282.thread2080:                           ; preds = %if.merge.4
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i1263)
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %out_sso.i1264.sroa.6.sroa.5)
  store i32 1701736270, ptr %btmp.i1263, align 4
  %btmp4.i13122087 = getelementptr inbounds nuw i8, ptr %btmp.i1263, i64 4
  store i64 0, ptr %btmp4.i13122087, align 4
  br label %build_sso.i1300

oom.i1299:                                        ; preds = %alloc_heap.i1285, %calc_tot.i1270
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i1273:                                      ; preds = %calc_tot.i1270
  %bshort.i1278 = icmp samesign ult i64 %blen.i1267, 13
  br i1 %bshort.i1278, label %build.i1282, label %build.i1282.thread

build.i1282.thread:                               ; preds = %mat_a.i1273
  %braw.i1280 = and i64 %t73.fca.1.extract, -4
  %blptr.i1281 = inttoptr i64 %braw.i1280 to ptr
  br label %alloc_heap.i1285

build.i1282:                                      ; preds = %mat_a.i1273
  %bp4.i1310 = lshr i64 %t73.fca.0.extract, 32
  %bp4_32.i1311 = trunc nuw i64 %bp4.i1310 to i32
  store i32 %bp4_32.i1311, ptr %btmp.i1263, align 4
  %btmp4.i1312 = getelementptr inbounds nuw i8, ptr %btmp.i1263, i64 4
  store i64 %t73.fca.1.extract, ptr %btmp4.i1312, align 4
  %fits_sso.i1284 = icmp samesign ult i64 %blen.i1267, 5
  br i1 %fits_sso.i1284, label %build_sso.i1300, label %alloc_heap.i1285

build_sso.i1300:                                  ; preds = %build.i1282.thread2080, %build.i1282
  %tot.i1271198719942091 = phi i64 [ 12, %build.i1282.thread2080 ], [ %tot.i1271, %build.i1282 ]
  %stropt.res.71.sroa.3.01976198519962090 = phi i64 [ 0, %build.i1282.thread2080 ], [ %t73.fca.1.extract, %build.i1282 ]
  %blen.i12671977198419992089 = phi i64 [ 4, %build.i1282.thread2080 ], [ %blen.i1267, %build.i1282 ]
  store i32 0, ptr %out_sso.i1264.sroa.6.sroa.5, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %out_sso.i1264.sroa.6.sroa.5, ptr nonnull align 4 %btmp.i1263, i64 %blen.i12671977198419992089, i1 false)
  %out_sso.i1264.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i1271198719942091, 8319108853555789824
  %out_sso.i1264.sroa.6.sroa.5.0.out_sso.i1264.sroa.6.sroa.5.0.out_sso.i1264.sroa.6.sroa.5.0.out_sso.i1264.sroa.6.sroa.5.0.out_sso.i1264.sroa.6.8.rw1.i1306 = load i32, ptr %out_sso.i1264.sroa.6.sroa.5, align 4
  %out_sso.i1264.sroa.6.sroa.5.0.insert.ext = zext i32 %out_sso.i1264.sroa.6.sroa.5.0.out_sso.i1264.sroa.6.sroa.5.0.out_sso.i1264.sroa.6.sroa.5.0.out_sso.i1264.sroa.6.sroa.5.0.out_sso.i1264.sroa.6.8.rw1.i1306 to i64
  %out_sso.i1264.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i1264.sroa.6.sroa.5.0.insert.ext, 32
  %out_sso.i1264.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i1264.sroa.6.sroa.5.0.insert.shift, 1030188649
  %rs0.i1307 = insertvalue %ArchxStr poison, i64 %out_sso.i1264.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i1308 = insertvalue %ArchxStr %rs0.i1307, i64 %out_sso.i1264.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit1315

alloc_heap.i1285:                                 ; preds = %build.i1282.thread, %build.i1282
  %bptr.i12832079 = phi ptr [ %blptr.i1281, %build.i1282.thread ], [ %btmp.i1263, %build.i1282 ]
  %hp.i1286 = call noalias align 16 ptr @malloc(i64 %tot.i1271)
  %hnull.i1287 = icmp eq ptr %hp.i1286, null
  br i1 %hnull.i1287, label %oom.i1299, label %copy_long.i1288

copy_long.i1288:                                  ; preds = %alloc_heap.i1285
  %hp_i.i1289 = ptrtoint ptr %hp.i1286 to i64
  %htagged.i1290 = or disjoint i64 %hp_i.i1289, 1
  store i32 1936943469, ptr %hp.i1286, align 16
  %atmp.i1262.sroa.5.0.hp.i1286.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i1286, i64 4
  store i32 1030188649, ptr %atmp.i1262.sroa.5.0.hp.i1286.sroa_idx, align 4
  %dst_b.i1291 = getelementptr inbounds nuw i8, ptr %hp.i1286, i64 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %dst_b.i1291, ptr nonnull align 1 %bptr.i12832079, i64 %blen.i1267, i1 false)
  %w0_out.i1295 = or disjoint i64 %tot.i1271, 8319108853555789824
  %ls0.i1296 = insertvalue %ArchxStr poison, i64 %w0_out.i1295, 0
  %ls1.i1297 = insertvalue %ArchxStr %ls0.i1296, i64 %htagged.i1290, 1
  %0 = icmp samesign ult i64 %blen.i1267, 13
  br label %archx_str_concat.exit1315

archx_str_concat.exit1315:                        ; preds = %stropt.done.8, %build_sso.i1300, %copy_long.i1288
  %blen.i12671978 = phi i1 [ true, %build_sso.i1300 ], [ %0, %copy_long.i1288 ], [ true, %stropt.done.8 ]
  %stropt.res.71.sroa.3.01975 = phi i64 [ %stropt.res.71.sroa.3.01976198519962090, %build_sso.i1300 ], [ %t73.fca.1.extract, %copy_long.i1288 ], [ %t73.fca.1.extract, %stropt.done.8 ]
  %common.ret.op.i1298 = phi %ArchxStr [ %rs1.i1308, %build_sso.i1300 ], [ %ls1.i1297, %copy_long.i1288 ], [ { i64 8319108853555789832, i64 1030188649 }, %stropt.done.8 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i1263)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %out_sso.i1264.sroa.6.sroa.5)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1832)
  %w0.i1833 = extractvalue %ArchxStr %common.ret.op.i1298, 0
  %w1.i1834 = extractvalue %ArchxStr %common.ret.op.i1298, 1
  %len.i1835 = and i64 %w0.i1833, 4294967295
  %short.i1836 = icmp samesign ult i64 %len.i1835, 13
  br i1 %short.i1836, label %emit.i1857, label %emit.thread.i1837

emit.thread.i1837:                                ; preds = %archx_str_concat.exit1315
  %raw.i1838 = and i64 %w1.i1834, -4
  %lptr.i1839 = inttoptr i64 %raw.i1838 to ptr
  br label %chk_nul.i1840

emit.i1857:                                       ; preds = %archx_str_concat.exit1315
  %p4.i1858 = lshr i64 %w0.i1833, 32
  %p4_32.i1859 = trunc nuw i64 %p4.i1858 to i32
  store i32 %p4_32.i1859, ptr %tmp.i1832, align 4
  %tmp4.i1860 = getelementptr inbounds nuw i8, ptr %tmp.i1832, i64 4
  store i64 %w1.i1834, ptr %tmp4.i1860, align 4
  %pos.not.i1861 = icmp eq i64 %len.i1835, 0
  br i1 %pos.not.i1861, label %do_nl.i1852, label %chk_nul.i1840

chk_nul.i1840:                                    ; preds = %emit.i1857, %emit.thread.i1837
  %data3.i1841 = phi ptr [ %lptr.i1839, %emit.thread.i1837 ], [ %tmp.i1832, %emit.i1857 ]
  %nul.i1842 = call ptr @memchr(ptr nonnull %data3.i1841, i32 0, i64 %len.i1835)
  %has_nul.not.i1843 = icmp eq ptr %nul.i1842, null
  br i1 %has_nul.not.i1843, label %fast_printf.i1854, label %byte_loop.i1844

fast_printf.i1854:                                ; preds = %chk_nul.i1840
  %len32.i1855 = trunc i64 %w0.i1833 to i32
  %np.i1856 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1855, ptr nonnull %data3.i1841)
  br label %archx_str_print.exit1862

byte_loop.i1844:                                  ; preds = %chk_nul.i1840, %byte_loop.i1844
  %bi.i1845 = phi i64 [ %bnext.i1850, %byte_loop.i1844 ], [ 0, %chk_nul.i1840 ]
  %bp.i1846 = getelementptr inbounds nuw i8, ptr %data3.i1841, i64 %bi.i1845
  %ch8.i1847 = load i8, ptr %bp.i1846, align 1
  %ch32.i1848 = zext i8 %ch8.i1847 to i32
  %pc.i1849 = call i32 @putchar(i32 %ch32.i1848)
  %bnext.i1850 = add nuw nsw i64 %bi.i1845, 1
  %exitcond.not.i1851 = icmp eq i64 %bnext.i1850, %len.i1835
  br i1 %exitcond.not.i1851, label %do_nl.i1852, label %byte_loop.i1844

do_nl.i1852:                                      ; preds = %byte_loop.i1844, %emit.i1857
  %nc.i1853 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1862

archx_str_print.exit1862:                         ; preds = %fast_printf.i1854, %do_nl.i1852
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1832)
  %tag.i326 = and i64 %w1.i1834, 1
  %owned.not.i327 = icmp eq i64 %tag.i326, 0
  %or.cond2034 = select i1 %short.i1836, i1 true, i1 %owned.not.i327
  br i1 %or.cond2034, label %archx_str_drop.exit331, label %do_free.i328

do_free.i328:                                     ; preds = %archx_str_print.exit1862
  %raw.i329 = and i64 %w1.i1834, -2
  %ptr.i330 = inttoptr i64 %raw.i329 to ptr
  call void @free(ptr %ptr.i330)
  br label %archx_str_drop.exit331

archx_str_drop.exit331:                           ; preds = %archx_str_print.exit1862, %do_free.i328
  %tag.i337 = and i64 %stropt.res.71.sroa.3.01975, 1
  %owned.not.i338 = icmp eq i64 %tag.i337, 0
  %or.cond2035 = select i1 %blen.i12671978, i1 true, i1 %owned.not.i338
  br i1 %or.cond2035, label %archx_str_drop.exit342, label %do_free.i339

do_free.i339:                                     ; preds = %archx_str_drop.exit331
  %raw.i340 = and i64 %stropt.res.71.sroa.3.01975, -2
  %ptr.i341 = inttoptr i64 %raw.i340 to ptr
  call void @free(ptr %ptr.i341)
  br label %archx_str_drop.exit342

archx_str_drop.exit342:                           ; preds = %archx_str_drop.exit331, %do_free.i339
  %t109 = call noalias align 16 dereferenceable_or_null(240) ptr @malloc(i64 240)
  %t110 = icmp eq ptr %t109, null
  br i1 %t110, label %alloc.oom.12, label %alloc.ok.11

alloc.oom.12:                                     ; preds = %archx_str_drop.exit342
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.11:                                      ; preds = %archx_str_drop.exit342
  store i64 0, ptr %t109, align 16
  %t109.repack15 = getelementptr inbounds nuw i8, ptr %t109, i64 8
  store i64 4615063718147915776, ptr %t109.repack15, align 8
  %t109.repack15.repack16 = getelementptr inbounds nuw i8, ptr %t109, i64 16
  %t112.repack19 = getelementptr inbounds nuw i8, ptr %t109, i64 48
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(32) %t109.repack15.repack16, i8 0, i64 32, i1 false)
  store i64 4622945017495814144, ptr %t112.repack19, align 16
  %t112.repack19.repack20 = getelementptr inbounds nuw i8, ptr %t109, i64 56
  %t113 = getelementptr inbounds nuw i8, ptr %t109, i64 80
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %t112.repack19.repack20, i8 0, i64 24, i1 false)
  store i64 1, ptr %t113, align 16
  %t113.repack23 = getelementptr inbounds nuw i8, ptr %t109, i64 88
  store i64 4616189618054758400, ptr %t113.repack23, align 8
  %t113.repack23.repack24 = getelementptr inbounds nuw i8, ptr %t109, i64 96
  store i64 4616189618054758400, ptr %t113.repack23.repack24, align 16
  %t113.repack23.repack25 = getelementptr inbounds nuw i8, ptr %t109, i64 104
  %t114 = getelementptr inbounds nuw i8, ptr %t109, i64 120
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %t113.repack23.repack25, i8 0, i64 16, i1 false)
  store i64 1, ptr %t114, align 8
  %t114.repack27 = getelementptr inbounds nuw i8, ptr %t109, i64 128
  store i64 4613937818241073152, ptr %t114.repack27, align 16
  %t114.repack27.repack28 = getelementptr inbounds nuw i8, ptr %t109, i64 136
  store i64 4617315517961601024, ptr %t114.repack27.repack28, align 8
  %t114.repack27.repack29 = getelementptr inbounds nuw i8, ptr %t109, i64 144
  %t115 = getelementptr inbounds nuw i8, ptr %t109, i64 160
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(16) %t114.repack27.repack29, i8 0, i64 16, i1 false)
  store <6 x i64> <i64 2, i64 7453016942991900710, i64 ptrtoint (ptr @.str.1 to i64), i64 7, i64 9, i64 3>, ptr %t115, align 16
  %t116.repack39 = getelementptr inbounds nuw i8, ptr %t109, i64 208
  %btmp4.i291.i = getelementptr inbounds nuw i8, ptr %btmp.i246.i, i64 4
  %btmp4.i241.i = getelementptr inbounds nuw i8, ptr %btmp.i196.i, i64 4
  %btmp4.i.i = getelementptr inbounds nuw i8, ptr %btmp.i.i, i64 4
  %btmp4.i191.i = getelementptr inbounds nuw i8, ptr %btmp.i159.i, i64 4
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
  %tmp4.i1903 = getelementptr inbounds nuw i8, ptr %tmp.i1875, i64 4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(32) %t116.repack39, i8 0, i64 32, i1 false)
  %sso.i.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i, i64 4
  %sso.i.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i.i, i64 8
  %sso.i.i620.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i620.i, i64 4
  %sso.i.i620.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i620.i, i64 8
  br label %foreach.body.14

foreach.body.14:                                  ; preds = %alloc.ok.11, %archx_str_drop.exit353
  %foreach.idx.124.02037 = phi i64 [ 0, %alloc.ok.11 ], [ %t131, %archx_str_drop.exit353 ]
  %t127 = getelementptr inbounds nuw %ArchxEnum_Shape, ptr %t109, i64 %foreach.idx.124.02037
  %t128.unpack = load i64, ptr %t127, align 8
  %t128.elt47 = getelementptr inbounds nuw i8, ptr %t127, i64 8
  %t128.unpack48.unpack = load i64, ptr %t128.elt47, align 8
  %t128.unpack48.elt50 = getelementptr inbounds nuw i8, ptr %t127, i64 16
  %t128.unpack48.unpack51 = load i64, ptr %t128.unpack48.elt50, align 8
  %t128.unpack48.elt52 = getelementptr inbounds nuw i8, ptr %t127, i64 24
  %t128.unpack48.unpack53 = load i64, ptr %t128.unpack48.elt52, align 8
  %t128.unpack48.elt54 = getelementptr inbounds nuw i8, ptr %t127, i64 32
  %t128.unpack48.unpack55 = load i64, ptr %t128.unpack48.elt54, align 8
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i247.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i197.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i.sroa.6.sroa.5.sroa.0.i)
  switch i64 %t128.unpack, label %archx_enum_drop_Shape.exit710.i [
    i64 2, label %v.2.i.i
    i64 0, label %pat.enum.ok.2.i
    i64 1, label %pat.enum.ok.8.i
  ]

v.2.i.i:                                          ; preds = %foreach.body.14
  %t2.fca.0.insert.i.i = insertvalue %ArchxStr poison, i64 %t128.unpack48.unpack, 0
  %t2.fca.1.insert.i.i = insertvalue %ArchxStr %t2.fca.0.insert.i.i, i64 %t128.unpack48.unpack51, 1
  %len.i.i.i = and i64 %t128.unpack48.unpack, 4294967295
  %long.i.i.i = icmp samesign ult i64 %len.i.i.i, 13
  %tag.i.i.i = and i64 %t128.unpack48.unpack51, 3
  %owned.not.i.i.i = icmp eq i64 %tag.i.i.i, 0
  %or.cond.i.i = select i1 %long.i.i.i, i1 true, i1 %owned.not.i.i.i
  br i1 %or.cond.i.i, label %archx_enum_clone_Shape.exit.thread.i, label %dup_heap.i.i.i

dup_heap.i.i.i:                                   ; preds = %v.2.i.i
  %dst.i.i.i = call noalias align 16 ptr @malloc(i64 %len.i.i.i)
  %isnull.i.i.i = icmp eq ptr %dst.i.i.i, null
  br i1 %isnull.i.i.i, label %oom.i.i.i, label %copy.i.i.i

oom.i.i.i:                                        ; preds = %dup_heap.i.i.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i.i:                                       ; preds = %dup_heap.i.i.i
  %src_i.i.i.i = and i64 %t128.unpack48.unpack51, -4
  %src.i.i.i = inttoptr i64 %src_i.i.i.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i.i, ptr nonnull align 4 %src.i.i.i, i64 %len.i.i.i, i1 false)
  %dst_i.i.i.i = ptrtoint ptr %dst.i.i.i to i64
  %tagged.i.i.i = or disjoint i64 %dst_i.i.i.i, 1
  %out.i.i.i = insertvalue %ArchxStr %t2.fca.1.insert.i.i, i64 %tagged.i.i.i, 1
  br label %archx_enum_clone_Shape.exit.thread.i

archx_enum_clone_Shape.exit.thread.i:             ; preds = %copy.i.i.i, %v.2.i.i
  %common.ret.op.i.i.i = phi %ArchxStr [ %out.i.i.i, %copy.i.i.i ], [ %t2.fca.1.insert.i.i, %v.2.i.i ]
  %t3.fca.0.extract.i.i = extractvalue %ArchxStr %common.ret.op.i.i.i, 0
  %t3.fca.1.extract.i.i = extractvalue %ArchxStr %common.ret.op.i.i.i, 1
  %len.i569.i = and i64 %t3.fca.0.extract.i.i, 4294967295
  %long.i570.i = icmp samesign ult i64 %len.i569.i, 13
  %tag.i574.i = and i64 %t3.fca.1.extract.i.i, 3
  %owned.not.i575.i = icmp eq i64 %tag.i574.i, 0
  %or.cond745.i = select i1 %long.i570.i, i1 true, i1 %owned.not.i575.i
  br i1 %or.cond745.i, label %archx_str_clone.exit.i, label %dup_heap.i.i

pat.enum.ok.2.i:                                  ; preds = %foreach.body.14
  %1 = bitcast i64 %t128.unpack48.unpack to double
  %t10.i = fcmp ult double %1, 1.000000e+01
  %t25.i = call fastcc { i64, i64 } @archx_str_from_float(double %1)
  %newret = extractvalue { i64, i64 } %t25.i, 0
  %newret2092 = extractvalue { i64, i64 } %t25.i, 1
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
  br i1 %too_big.i.i, label %oom.i.i1873, label %mat_a.i.i

oom.i.i1873:                                      ; preds = %build.i.i, %calc_tot.i.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i.i:                                        ; preds = %calc_tot.i.i
  %bshort.i.i = icmp samesign ult i64 %blen.i162.i, 13
  br i1 %bshort.i.i, label %mat_b_short.i.i, label %mat_b_long.i.i

mat_b_short.i.i:                                  ; preds = %mat_a.i.i
  %bp4.i.i = lshr i64 %newret, 32
  %bp4_32.i.i = trunc nuw i64 %bp4.i.i to i32
  store i32 %bp4_32.i.i, ptr %btmp.i.i, align 4
  store i64 %newret2092, ptr %btmp4.i.i, align 4
  br label %build.i.i

mat_b_long.i.i:                                   ; preds = %mat_a.i.i
  %braw.i.i = and i64 %newret2092, -4
  %blptr.i.i = inttoptr i64 %braw.i.i to ptr
  br label %build.i.i

build.i.i:                                        ; preds = %mat_b_long.i.i, %mat_b_short.i.i
  %bptr.i.i = phi ptr [ %btmp.i.i, %mat_b_short.i.i ], [ %blptr.i.i, %mat_b_long.i.i ]
  %hp.i.i1866 = call noalias align 16 ptr @malloc(i64 %tot.i.i)
  %hnull.i.i1867 = icmp eq ptr %hp.i.i1866, null
  br i1 %hnull.i.i1867, label %oom.i.i1873, label %archx_str_concat.exit.i

archx_str_concat.exit.i:                          ; preds = %build.i.i
  %hp_i.i.i1868 = ptrtoint ptr %hp.i.i1866 to i64
  %htagged.i.i1869 = or disjoint i64 %hp_i.i.i1868, 1
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(13) %hp.i.i1866, ptr noundef nonnull align 4 dereferenceable(13) @.str.0, i64 13, i1 false)
  %dst_b.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i1866, i64 13
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i.i, ptr nonnull align 1 %bptr.i.i, i64 %blen.i162.i, i1 false)
  %w0_out.i.i1870 = or disjoint i64 %tot.i.i, 7454127449735954432
  %ls0.i.i1871 = insertvalue %ArchxStr poison, i64 %w0_out.i.i1870, 0
  %ls1.i.i1872 = insertvalue %ArchxStr %ls0.i.i1871, i64 %htagged.i.i1869, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i.i)
  %tag.i.i = and i64 %newret2092, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond.i = select i1 %bshort.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond.i, label %archx_fn_describe_shape.exit, label %do_free.i.i

do_free.i.i:                                      ; preds = %archx_str_concat.exit.i
  %raw.i.i = and i64 %newret2092, -2
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

oom.i187.i:                                       ; preds = %alloc_heap.i.i1874, %calc_tot.i164.i
  call fastcc void @archx_oom_fail()
  unreachable

mat_a.i167.i:                                     ; preds = %calc_tot.i164.i
  %bshort.i168.i = icmp samesign ult i64 %blen.i162.i, 13
  br i1 %bshort.i168.i, label %build.i172.i, label %build.i172.thread.i

build.i172.thread.i:                              ; preds = %mat_a.i167.i
  %braw.i170.i = and i64 %newret2092, -4
  %blptr.i171.i = inttoptr i64 %braw.i170.i to ptr
  br label %alloc_heap.i.i1874

build.i172.i:                                     ; preds = %mat_a.i167.i
  %bp4.i189.i = lshr i64 %newret, 32
  %bp4_32.i190.i = trunc nuw i64 %bp4.i189.i to i32
  store i32 %bp4_32.i190.i, ptr %btmp.i159.i, align 4
  store i64 %newret2092, ptr %btmp4.i191.i, align 4
  %fits_sso.i.i = icmp samesign ult i64 %blen.i162.i, 6
  br i1 %fits_sso.i.i, label %archx_str_concat.exit194.thread769.i, label %alloc_heap.i.i1874

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

alloc_heap.i.i1874:                               ; preds = %build.i172.i, %build.i172.thread.i
  %bptr.i173768.i = phi ptr [ %blptr.i171.i, %build.i172.thread.i ], [ %btmp.i159.i, %build.i172.i ]
  %hp.i174.i = call noalias align 16 ptr @malloc(i64 %tot.i165.i)
  %hnull.i175.i = icmp eq ptr %hp.i174.i, null
  br i1 %hnull.i175.i, label %oom.i187.i, label %archx_str_concat.exit194.i

archx_str_concat.exit194.i:                       ; preds = %alloc_heap.i.i1874
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
  %tag.i65.i = and i64 %newret2092, 1
  %owned.not.i66.i = icmp eq i64 %tag.i65.i, 0
  %or.cond742.i = select i1 %bshort.i168.i, i1 true, i1 %owned.not.i66.i
  br i1 %or.cond742.i, label %archx_fn_describe_shape.exit, label %do_free.i67.i

do_free.i67.i:                                    ; preds = %archx_str_concat.exit194.i
  %raw.i68.i = and i64 %newret2092, -2
  %ptr.i69.i = inttoptr i64 %raw.i68.i to ptr
  call void @free(ptr %ptr.i69.i)
  br label %archx_fn_describe_shape.exit

pat.enum.ok.8.i:                                  ; preds = %foreach.body.14
  %2 = bitcast i64 %t128.unpack48.unpack to double
  %3 = bitcast i64 %t128.unpack48.unpack51 to double
  %t40.i = fcmp oeq double %2, %3
  %t41.i = fmul double %2, %3
  %t42.i = call fastcc { i64, i64 } @archx_str_from_float(double %t41.i)
  %newret2094 = extractvalue { i64, i64 } %t42.i, 0
  %newret2096 = extractvalue { i64, i64 } %t42.i, 1
  %blen.i200.i = and i64 %newret2094, 4294967295
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
  %braw.i209.i = and i64 %newret2096, -4
  %blptr.i210.i = inttoptr i64 %braw.i209.i to ptr
  br label %alloc_heap.i214.i

build.i211.i:                                     ; preds = %mat_a.i205.i
  %bp4.i239.i = lshr i64 %newret2094, 32
  %bp4_32.i240.i = trunc nuw i64 %bp4.i239.i to i32
  store i32 %bp4_32.i240.i, ptr %btmp.i196.i, align 4
  store i64 %newret2096, ptr %btmp4.i241.i, align 4
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
  %tag.i76.i = and i64 %newret2096, 1
  %owned.not.i77.i = icmp eq i64 %tag.i76.i, 0
  %or.cond743.i = select i1 %bshort.i207.i, i1 true, i1 %owned.not.i77.i
  br i1 %or.cond743.i, label %archx_fn_describe_shape.exit, label %do_free.i78.i

do_free.i78.i:                                    ; preds = %archx_str_concat.exit244.i
  %raw.i79.i = and i64 %newret2096, -2
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
  %braw.i259.i = and i64 %newret2096, -4
  %blptr.i260.i = inttoptr i64 %braw.i259.i to ptr
  br label %alloc_heap.i264.i

build.i261.i:                                     ; preds = %mat_a.i255.i
  %bp4.i289.i = lshr i64 %newret2094, 32
  %bp4_32.i290.i = trunc nuw i64 %bp4.i289.i to i32
  store i32 %bp4_32.i290.i, ptr %btmp.i246.i, align 4
  store i64 %newret2096, ptr %btmp4.i291.i, align 4
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
  %tag.i87.i = and i64 %newret2096, 1
  %owned.not.i88.i = icmp eq i64 %tag.i87.i, 0
  %or.cond744.i = select i1 %bshort.i257.i, i1 true, i1 %owned.not.i88.i
  br i1 %or.cond744.i, label %archx_fn_describe_shape.exit, label %do_free.i89.i

do_free.i89.i:                                    ; preds = %archx_str_concat.exit294.i
  %raw.i90.i = and i64 %newret2096, -2
  %ptr.i91.i = inttoptr i64 %raw.i90.i to ptr
  call void @free(ptr %ptr.i91.i)
  br label %archx_fn_describe_shape.exit

dup_heap.i.i:                                     ; preds = %archx_enum_clone_Shape.exit.thread.i
  %dst.i.i = call noalias align 16 ptr @malloc(i64 %len.i569.i)
  %isnull.i.i = icmp eq ptr %dst.i.i, null
  br i1 %isnull.i.i, label %oom.i576.i, label %copy.i.i

oom.i576.i:                                       ; preds = %dup_heap.i.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i:                                         ; preds = %dup_heap.i.i
  %src_i.i.i = and i64 %t3.fca.1.extract.i.i, -4
  %src.i.i = inttoptr i64 %src_i.i.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i, ptr nonnull align 4 %src.i.i, i64 %len.i569.i, i1 false)
  %dst_i.i.i = ptrtoint ptr %dst.i.i to i64
  %tagged.i.i = or disjoint i64 %dst_i.i.i, 1
  %.pre = extractvalue %ArchxStr %common.ret.op.i.i.i, 0
  %.pre2061 = and i64 %.pre, 4294967295
  br label %archx_str_clone.exit.i

archx_str_clone.exit.i:                           ; preds = %copy.i.i, %archx_enum_clone_Shape.exit.thread.i
  %alen.i.i.pre-phi = phi i64 [ %.pre2061, %copy.i.i ], [ %len.i569.i, %archx_enum_clone_Shape.exit.thread.i ]
  %aw1.i.i.pre-phi = phi i64 [ %tagged.i.i, %copy.i.i ], [ %t3.fca.1.extract.i.i, %archx_enum_clone_Shape.exit.thread.i ]
  %aw0.i.i.pre-phi = phi i64 [ %.pre, %copy.i.i ], [ %t3.fca.0.extract.i.i, %archx_enum_clone_Shape.exit.thread.i ]
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i295.i)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i297.i)
  %az.i.i = icmp eq i64 %alen.i.i.pre-phi, 0
  br i1 %az.i.i, label %archx_str_concat.exit332.i, label %chk_bz.i.i

chk_bz.i.i:                                       ; preds = %archx_str_clone.exit.i
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

archx_str_concat.exit332.i:                       ; preds = %copy_long.i310.i, %build_sso.i322.i, %archx_str_clone.exit.i
  %common.ret.op.i320.i = phi %ArchxStr [ %rs1.i330.i, %build_sso.i322.i ], [ %ls1.i319.i, %copy_long.i310.i ], [ { i64 274877906945, i64 0 }, %archx_str_clone.exit.i ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i295.i)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i297.i)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i.i)
  %n32.i.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t128.unpack48.unpack53)
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
  %n32.i622.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i621.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t128.unpack48.unpack55)
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
  %tag.i.i692.i = and i64 %t3.fca.1.extract.i.i, 1
  %owned.not.i.i693.i = icmp eq i64 %tag.i.i692.i, 0
  %or.cond.i694.i = select i1 %long.i570.i, i1 true, i1 %owned.not.i.i693.i
  br i1 %or.cond.i694.i, label %archx_fn_describe_shape.exit, label %do_free.i.i695.i

do_free.i.i695.i:                                 ; preds = %v.2.i689.i
  %raw.i.i696.i = and i64 %t3.fca.1.extract.i.i, -2
  %ptr.i.i697.i = inttoptr i64 %raw.i.i696.i to ptr
  call void @free(ptr %ptr.i.i697.i)
  br label %archx_fn_describe_shape.exit

archx_enum_drop_Shape.exit710.i:                  ; preds = %foreach.body.14
  %t90.i = icmp eq i64 %t128.unpack, 3
  call void @llvm.assume(i1 %t90.i)
  br label %archx_fn_describe_shape.exit

archx_fn_describe_shape.exit:                     ; preds = %archx_str_concat.exit.thread.i, %archx_str_concat.exit.i, %do_free.i.i, %archx_str_concat.exit194.thread.i, %archx_str_concat.exit194.thread769.i, %archx_str_concat.exit194.i, %do_free.i67.i, %archx_str_concat.exit244.thread.i, %archx_str_concat.exit244.thread780.i, %archx_str_concat.exit244.i, %do_free.i78.i, %archx_str_concat.exit294.thread.i, %archx_str_concat.exit294.thread791.i, %archx_str_concat.exit294.i, %do_free.i89.i, %v.2.i689.i, %do_free.i.i695.i, %archx_enum_drop_Shape.exit710.i
  %common.ret.op.i1865 = phi %ArchxStr [ { i64 8390326386350358533, i64 121 }, %archx_enum_drop_Shape.exit710.i ], [ { i64 7454127449735954445, i64 ptrtoint (ptr @.str.0 to i64) }, %archx_str_concat.exit.thread.i ], [ %ls1.i.i1872, %archx_str_concat.exit.i ], [ %ls1.i.i1872, %do_free.i.i ], [ { i64 7165905831022559239, i64 3827052 }, %archx_str_concat.exit194.thread.i ], [ %common.ret.op.i186.i, %archx_str_concat.exit194.i ], [ %common.ret.op.i186.i, %do_free.i67.i ], [ { i64 7022643932689334279, i64 3827058 }, %archx_str_concat.exit244.thread.i ], [ %common.ret.op.i227.i, %archx_str_concat.exit244.i ], [ %common.ret.op.i227.i, %do_free.i78.i ], [ { i64 8386658471394672645, i64 58 }, %archx_str_concat.exit294.thread.i ], [ %common.ret.op.i277.i, %archx_str_concat.exit294.i ], [ %common.ret.op.i277.i, %do_free.i89.i ], [ %common.ret.op.i495735.i, %v.2.i689.i ], [ %common.ret.op.i495735.i, %do_free.i.i695.i ], [ %common.ret.op.i186773.i, %archx_str_concat.exit194.thread769.i ], [ %common.ret.op.i227784.i, %archx_str_concat.exit244.thread780.i ], [ %common.ret.op.i277795.i, %archx_str_concat.exit294.thread791.i ]
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i247.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i197.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6.sroa.5.sroa.0.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i1875)
  %w0.i1876 = extractvalue %ArchxStr %common.ret.op.i1865, 0
  %w1.i1877 = extractvalue %ArchxStr %common.ret.op.i1865, 1
  %len.i1878 = and i64 %w0.i1876, 4294967295
  %short.i1879 = icmp samesign ult i64 %len.i1878, 13
  br i1 %short.i1879, label %emit.i1900, label %emit.thread.i1880

emit.thread.i1880:                                ; preds = %archx_fn_describe_shape.exit
  %raw.i1881 = and i64 %w1.i1877, -4
  %lptr.i1882 = inttoptr i64 %raw.i1881 to ptr
  br label %chk_nul.i1883

emit.i1900:                                       ; preds = %archx_fn_describe_shape.exit
  %p4.i1901 = lshr i64 %w0.i1876, 32
  %p4_32.i1902 = trunc nuw i64 %p4.i1901 to i32
  store i32 %p4_32.i1902, ptr %tmp.i1875, align 4
  store i64 %w1.i1877, ptr %tmp4.i1903, align 4
  %pos.not.i1904 = icmp eq i64 %len.i1878, 0
  br i1 %pos.not.i1904, label %do_nl.i1895, label %chk_nul.i1883

chk_nul.i1883:                                    ; preds = %emit.i1900, %emit.thread.i1880
  %data3.i1884 = phi ptr [ %lptr.i1882, %emit.thread.i1880 ], [ %tmp.i1875, %emit.i1900 ]
  %nul.i1885 = call ptr @memchr(ptr nonnull %data3.i1884, i32 0, i64 %len.i1878)
  %has_nul.not.i1886 = icmp eq ptr %nul.i1885, null
  br i1 %has_nul.not.i1886, label %fast_printf.i1897, label %byte_loop.i1887

fast_printf.i1897:                                ; preds = %chk_nul.i1883
  %len32.i1898 = trunc i64 %w0.i1876 to i32
  %np.i1899 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i1898, ptr nonnull %data3.i1884)
  br label %archx_str_print.exit1905

byte_loop.i1887:                                  ; preds = %chk_nul.i1883, %byte_loop.i1887
  %bi.i1888 = phi i64 [ %bnext.i1893, %byte_loop.i1887 ], [ 0, %chk_nul.i1883 ]
  %bp.i1889 = getelementptr inbounds nuw i8, ptr %data3.i1884, i64 %bi.i1888
  %ch8.i1890 = load i8, ptr %bp.i1889, align 1
  %ch32.i1891 = zext i8 %ch8.i1890 to i32
  %pc.i1892 = call i32 @putchar(i32 %ch32.i1891)
  %bnext.i1893 = add nuw nsw i64 %bi.i1888, 1
  %exitcond.not.i1894 = icmp eq i64 %bnext.i1893, %len.i1878
  br i1 %exitcond.not.i1894, label %do_nl.i1895, label %byte_loop.i1887

do_nl.i1895:                                      ; preds = %byte_loop.i1887, %emit.i1900
  %nc.i1896 = call i32 @putchar(i32 10)
  br label %archx_str_print.exit1905

archx_str_print.exit1905:                         ; preds = %fast_printf.i1897, %do_nl.i1895
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i1875)
  %tag.i348 = and i64 %w1.i1877, 1
  %owned.not.i349 = icmp eq i64 %tag.i348, 0
  %or.cond2036 = select i1 %short.i1879, i1 true, i1 %owned.not.i349
  br i1 %or.cond2036, label %archx_str_drop.exit353, label %do_free.i350

do_free.i350:                                     ; preds = %archx_str_print.exit1905
  %raw.i351 = and i64 %w1.i1877, -2
  %ptr.i352 = inttoptr i64 %raw.i351 to ptr
  call void @free(ptr %ptr.i352)
  br label %archx_str_drop.exit353

archx_str_drop.exit353:                           ; preds = %archx_str_print.exit1905, %do_free.i350
  %t131 = add nuw nsw i64 %foreach.idx.124.02037, 1
  %exitcond.not = icmp eq i64 %t131, 6
  br i1 %exitcond.not, label %archx_region_release_from.exit, label %foreach.body.14

archx_region_release_from.exit:                   ; preds = %archx_str_drop.exit353
  call void @free(ptr nonnull %t109)
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

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #7

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #8

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #8

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #9

attributes #0 = { nounwind }
attributes #1 = { cold nofree noreturn nounwind }
attributes #2 = { nofree nounwind }
attributes #3 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #4 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #5 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #6 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #7 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #8 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #9 = { nocallback nofree nounwind willreturn memory(argmem: write) }
