; ModuleID = 'ci/out/collections_dynamic.ll'
source_filename = "ci/out/collections_dynamic.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxAny = type { i64, i64, i64 }
%ArchxStr = type { i64, i64 }
%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxVec = type { i64, i64, ptr }

@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.fmt.str.elem = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.none = private unnamed_addr constant [5 x i8] c"None\00", align 1
@.fmt.sep = private unnamed_addr constant [3 x i8] c", \00", align 1
@.fmt.g15 = private unnamed_addr constant [6 x i8] c"%.15g\00", align 1
@.str.0 = private unnamed_addr constant [14 x i8] c"region score:\00", align 4
@.str.1 = private unnamed_addr constant [14 x i8] c"unique count:\00", align 4
@.str.2 = private unnamed_addr constant [14 x i8] c"middle slice:\00", align 4
@.str.3 = private unnamed_addr constant [15 x i8] c"reversed step:\00", align 4
@.str.4 = private unnamed_addr constant [36 x i8] c"`.append()` requires a `list` value\00", align 4
@.str.5 = private unnamed_addr constant [15 x i8] c"before rebind:\00", align 4
@.str.6 = private unnamed_addr constant [14 x i8] c"after rebind:\00", align 4
@.str.7 = private unnamed_addr constant [14 x i8] c"rebound list:\00", align 4
@.fmt.pstr = private unnamed_addr constant [5 x i8] c"%.*s\00", align 1
@.err.bounds = private unnamed_addr constant [63 x i8] c"archx runtime panic: index %lld out of bounds for length %lld\0A\00", align 1
@.fmt.i64s = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.err.type = private unnamed_addr constant [36 x i8] c"archx runtime panic: TypeError: %s\0A\00", align 1
@.fmt.colon = private unnamed_addr constant [3 x i8] c": \00", align 1
@.any.unhash = private unnamed_addr constant [36 x i8] c"mutable list/dict/set is unhashable\00", align 1
@.any.badop = private unnamed_addr constant [48 x i8] c"unsupported operand types for dynamic operation\00", align 1
@.any.badidx = private unnamed_addr constant [59 x i8] c"dynamic value is not subscriptable or index has wrong type\00", align 1
@.any.badlen = private unnamed_addr constant [41 x i8] c"object of this dynamic type has no len()\00", align 1
@str = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1
@str.2 = private unnamed_addr constant [57 x i8] c"archx runtime panic: KeyError: key not found in dict/set\00", align 1

; Function Attrs: nounwind
define internal fastcc { i64, i64, i64 } @archx_fn_summarize_tag(%ArchxAny %arg.val) unnamed_addr #0 {
entry:
  %sso.i.i = alloca [16 x i8], align 8
  %buf.i = alloca [32 x i8], align 8
  %atmp.i256 = alloca [12 x i8], align 4
  %out_sso.i258 = alloca [16 x i8], align 8
  %btmp.i203 = alloca [12 x i8], align 4
  %out_sso.i204.sroa.6.sroa.5.sroa.0 = alloca i24, align 4
  %atmp.i148 = alloca [12 x i8], align 4
  %out_sso.i150 = alloca [16 x i8], align 8
  %btmp.i95 = alloca [12 x i8], align 4
  %out_sso.i96.sroa.6 = alloca i64, align 8
  %atmp.i56 = alloca [12 x i8], align 4
  %out_sso.i58 = alloca [16 x i8], align 8
  %btmp.i = alloca [12 x i8], align 4
  %out_sso.i.sroa.6 = alloca i64, align 8
  %t0 = tail call fastcc i1 @archx_any_eq(%ArchxAny %arg.val, %ArchxAny zeroinitializer)
  br i1 %t0, label %common.ret, label %if.else.1

common.ret:                                       ; preds = %do_free.i52, %archx_str_drop.exit44, %do_free.i30, %archx_str_drop.exit22, %do_free.i8, %archx_str_drop.exit, %entry, %archx_str_clone.exit
  %common.ret.op = phi %ArchxAny [ %t38, %archx_str_clone.exit ], [ { i64 4, i64 8390326386350358533, i64 121 }, %entry ], [ %t13347, %archx_str_drop.exit ], [ %t13347, %do_free.i8 ], [ %t22357, %archx_str_drop.exit22 ], [ %t22357, %do_free.i30 ], [ %t32367, %archx_str_drop.exit44 ], [ %t32367, %do_free.i52 ]
  %oldret = extractvalue %ArchxAny %common.ret.op, 0
  %newret = insertvalue { i64, i64, i64 } poison, i64 %oldret, 0
  %oldret1 = extractvalue %ArchxAny %common.ret.op, 1
  %newret2 = insertvalue { i64, i64, i64 } %newret, i64 %oldret1, 1
  %oldret3 = extractvalue %ArchxAny %common.ret.op, 2
  %newret4 = insertvalue { i64, i64, i64 } %newret2, i64 %oldret3, 2
  ret { i64, i64, i64 } %newret4

if.else.1:                                        ; preds = %entry
  %t5 = extractvalue %ArchxAny %arg.val, 0
  switch i64 %t5, label %t7.i [
    i64 2, label %if.then.3
    i64 4, label %if.then.6
    i64 5, label %l_cont.i
    i64 0, label %archx_any_type_name.exit
    i64 1, label %t1.i
    i64 6, label %t6.i
    i64 3, label %t3.i
  ]

if.then.3:                                        ; preds = %if.else.1
  %t7 = tail call fastcc { i64, i64 } @archx_any_to_str(%ArchxAny %arg.val)
  %newret5 = extractvalue { i64, i64 } %t7, 0
  %newret7 = extractvalue { i64, i64 } %t7, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  %blen.i = and i64 %newret5, 4294967295
  %bz.i = icmp eq i64 %blen.i, 0
  br i1 %bz.i, label %archx_str_concat.exit, label %calc_tot.i

calc_tot.i:                                       ; preds = %if.then.3
  %tot.i = add nuw nsw i64 %blen.i, 4
  %too_big.i = icmp samesign ugt i64 %blen.i, 2147483643
  br i1 %too_big.i, label %oom.i, label %mat_a.i

oom.i:                                            ; preds = %alloc_heap.i, %calc_tot.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i:                                          ; preds = %calc_tot.i
  %bshort.i = icmp samesign ult i64 %blen.i, 13
  br i1 %bshort.i, label %build.i, label %build.i.thread

build.i.thread:                                   ; preds = %mat_a.i
  %braw.i = and i64 %newret7, -4
  %blptr.i = inttoptr i64 %braw.i to ptr
  br label %alloc_heap.i

build.i:                                          ; preds = %mat_a.i
  %bp4.i = lshr i64 %newret5, 32
  %bp4_32.i = trunc nuw i64 %bp4.i to i32
  store i32 %bp4_32.i, ptr %btmp.i, align 4
  %btmp4.i = getelementptr inbounds nuw i8, ptr %btmp.i, i64 4
  store i64 %newret7, ptr %btmp4.i, align 4
  %fits_sso.i = icmp samesign ult i64 %blen.i, 9
  br i1 %fits_sso.i, label %build_sso.i, label %alloc_heap.i

build_sso.i:                                      ; preds = %build.i
  store i64 0, ptr %out_sso.i.sroa.6, align 8
  %out_sso.i.sroa.0.4.insert.insert = or disjoint i64 %tot.i, 2915076256066174976
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i.sroa.6, ptr nonnull align 4 %btmp.i, i64 %blen.i, i1 false)
  %out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.8.rw1.i = load i64, ptr %out_sso.i.sroa.6, align 8
  %rs0.i = insertvalue %ArchxStr poison, i64 %out_sso.i.sroa.0.4.insert.insert, 0
  %rs1.i = insertvalue %ArchxStr %rs0.i, i64 %out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.8.rw1.i, 1
  br label %archx_str_concat.exit

alloc_heap.i:                                     ; preds = %build.i.thread, %build.i
  %bptr.i377 = phi ptr [ %blptr.i, %build.i.thread ], [ %btmp.i, %build.i ]
  %hp.i = tail call noalias align 16 ptr @malloc(i64 %tot.i)
  %hnull.i = icmp eq ptr %hp.i, null
  br i1 %hnull.i, label %oom.i, label %copy_long.i

copy_long.i:                                      ; preds = %alloc_heap.i
  %hp_i.i = ptrtoint ptr %hp.i to i64
  %htagged.i = or disjoint i64 %hp_i.i, 1
  store i32 678719081, ptr %hp.i, align 16
  %dst_b.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %dst_b.i, ptr nonnull align 1 %bptr.i377, i64 %blen.i, i1 false)
  %w0_out.i = or disjoint i64 %tot.i, 2915076256066174976
  %ls0.i = insertvalue %ArchxStr poison, i64 %w0_out.i, 0
  %ls1.i = insertvalue %ArchxStr %ls0.i, i64 %htagged.i, 1
  br label %archx_str_concat.exit

archx_str_concat.exit:                            ; preds = %if.then.3, %build_sso.i, %copy_long.i
  %common.ret.op.i = phi %ArchxStr [ %rs1.i, %build_sso.i ], [ %ls1.i, %copy_long.i ], [ { i64 2915076256066174980, i64 0 }, %if.then.3 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i56)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i58)
  %aw0.i = extractvalue %ArchxStr %common.ret.op.i, 0
  %aw1.i = extractvalue %ArchxStr %common.ret.op.i, 1
  %alen.i = and i64 %aw0.i, 4294967295
  %az.i = icmp eq i64 %alen.i, 0
  br i1 %az.i, label %archx_str_concat.exit93.thread, label %chk_bz.i

chk_bz.i:                                         ; preds = %archx_str_concat.exit
  %tot.i60 = add nuw nsw i64 %alen.i, 1
  %too_big.i61 = icmp samesign ugt i64 %alen.i, 2147483646
  br i1 %too_big.i61, label %oom.i82, label %mat_a.i62

oom.i82:                                          ; preds = %alloc_heap.i68, %chk_bz.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i62:                                        ; preds = %chk_bz.i
  %ashort.i = icmp samesign ult i64 %alen.i, 13
  br i1 %ashort.i, label %mat_b.i, label %mat_b.i.thread

mat_b.i.thread:                                   ; preds = %mat_a.i62
  %araw.i = and i64 %aw1.i, -4
  %alptr.i = inttoptr i64 %araw.i to ptr
  br label %alloc_heap.i68

mat_b.i:                                          ; preds = %mat_a.i62
  %ap4.i = lshr i64 %aw0.i, 32
  %ap4_32.i = trunc nuw i64 %ap4.i to i32
  store i32 %ap4_32.i, ptr %atmp.i56, align 4
  %atmp4.i92 = getelementptr inbounds nuw i8, ptr %atmp.i56, i64 4
  store i64 %aw1.i, ptr %atmp4.i92, align 4
  %fits_sso.i67.not = icmp eq i64 %alen.i, 12
  br i1 %fits_sso.i67.not, label %alloc_heap.i68, label %build_sso.i83

build_sso.i83:                                    ; preds = %mat_b.i
  %out_sso8.i84 = getelementptr inbounds nuw i8, ptr %out_sso.i58, i64 8
  %tot32.i85 = trunc nuw nsw i64 %tot.i60 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i58, i8 0, i64 16, i1 false)
  store i32 %tot32.i85, ptr %out_sso.i58, align 8
  %sso_dst_a.i86 = getelementptr inbounds nuw i8, ptr %out_sso.i58, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i86, ptr nonnull align 4 %atmp.i56, i64 %alen.i, i1 false)
  %sso_dst_b.i87 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i86, i64 %alen.i
  store i8 41, ptr %sso_dst_b.i87, align 1
  %rw0.i88 = load i64, ptr %out_sso.i58, align 8
  %rw1.i89 = load i64, ptr %out_sso8.i84, align 8
  %rs0.i90 = insertvalue %ArchxStr poison, i64 %rw0.i88, 0
  %rs1.i91 = insertvalue %ArchxStr %rs0.i90, i64 %rw1.i89, 1
  br label %archx_str_concat.exit93.thread

alloc_heap.i68:                                   ; preds = %mat_b.i.thread, %mat_b.i
  %aptr.i340 = phi ptr [ %alptr.i, %mat_b.i.thread ], [ %atmp.i56, %mat_b.i ]
  %hp.i69 = tail call noalias align 16 ptr @malloc(i64 %tot.i60)
  %hnull.i70 = icmp eq ptr %hp.i69, null
  br i1 %hnull.i70, label %oom.i82, label %archx_str_concat.exit93

archx_str_concat.exit93.thread:                   ; preds = %archx_str_concat.exit, %build_sso.i83
  %common.ret.op.i81.ph = phi %ArchxStr [ { i64 176093659137, i64 0 }, %archx_str_concat.exit ], [ %rs1.i91, %build_sso.i83 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i56)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i58)
  %t10342 = extractvalue %ArchxStr %common.ret.op.i81.ph, 0
  %t11343 = extractvalue %ArchxStr %common.ret.op.i81.ph, 1
  br label %archx_str_drop.exit

archx_str_concat.exit93:                          ; preds = %alloc_heap.i68
  %hp_i.i72 = ptrtoint ptr %hp.i69 to i64
  %htagged.i73 = or disjoint i64 %hp_i.i72, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i69, ptr nonnull align 1 %aptr.i340, i64 %alen.i, i1 false)
  %dst_b.i74 = getelementptr inbounds nuw i8, ptr %hp.i69, i64 %alen.i
  store i8 41, ptr %dst_b.i74, align 1
  %pref32.i75 = load i32, ptr %hp.i69, align 16
  %pref64.i76 = zext i32 %pref32.i75 to i64
  %pref_sh.i77 = shl nuw i64 %pref64.i76, 32
  %w0_out.i78 = or disjoint i64 %pref_sh.i77, %tot.i60
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i56)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i58)
  %tag.i = and i64 %aw1.i, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %ashort.i, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %archx_str_drop.exit, label %do_free.i

do_free.i:                                        ; preds = %archx_str_concat.exit93
  %raw.i = and i64 %aw1.i, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  tail call void @free(ptr %ptr.i)
  br label %archx_str_drop.exit

archx_str_drop.exit:                              ; preds = %archx_str_concat.exit93.thread, %archx_str_concat.exit93, %do_free.i
  %t10342.pn = phi i64 [ %t10342, %archx_str_concat.exit93.thread ], [ %w0_out.i78, %archx_str_concat.exit93 ], [ %w0_out.i78, %do_free.i ]
  %t11343.pn = phi i64 [ %t11343, %archx_str_concat.exit93.thread ], [ %htagged.i73, %archx_str_concat.exit93 ], [ %htagged.i73, %do_free.i ]
  %t12344.pn = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t10342.pn, 1
  %t13347 = insertvalue %ArchxAny %t12344.pn, i64 %t11343.pn, 2
  %long.i3 = icmp samesign ult i64 %blen.i, 13
  %tag.i6 = and i64 %newret7, 1
  %owned.not.i7 = icmp eq i64 %tag.i6, 0
  %or.cond368 = select i1 %long.i3, i1 true, i1 %owned.not.i7
  br i1 %or.cond368, label %common.ret, label %do_free.i8

do_free.i8:                                       ; preds = %archx_str_drop.exit
  %raw.i9 = and i64 %newret7, -2
  %ptr.i10 = inttoptr i64 %raw.i9 to ptr
  tail call void @free(ptr %ptr.i10)
  br label %common.ret

if.then.6:                                        ; preds = %if.else.1
  %t16 = tail call fastcc { i64, i64 } @archx_any_to_str(%ArchxAny %arg.val)
  %newret9 = extractvalue { i64, i64 } %t16, 0
  %newret11 = extractvalue { i64, i64 } %t16, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i95)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i96.sroa.6)
  %blen.i99 = and i64 %newret9, 4294967295
  %bz.i101 = icmp eq i64 %blen.i99, 0
  br i1 %bz.i101, label %archx_str_concat.exit147, label %calc_tot.i102

calc_tot.i102:                                    ; preds = %if.then.6
  %tot.i103 = add nuw nsw i64 %blen.i99, 4
  %too_big.i104 = icmp samesign ugt i64 %blen.i99, 2147483643
  br i1 %too_big.i104, label %oom.i131, label %mat_a.i105

oom.i131:                                         ; preds = %alloc_heap.i117, %calc_tot.i102
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i105:                                       ; preds = %calc_tot.i102
  %bshort.i110 = icmp samesign ult i64 %blen.i99, 13
  br i1 %bshort.i110, label %build.i114, label %build.i114.thread

build.i114.thread:                                ; preds = %mat_a.i105
  %braw.i112 = and i64 %newret11, -4
  %blptr.i113 = inttoptr i64 %braw.i112 to ptr
  br label %alloc_heap.i117

build.i114:                                       ; preds = %mat_a.i105
  %bp4.i142 = lshr i64 %newret9, 32
  %bp4_32.i143 = trunc nuw i64 %bp4.i142 to i32
  store i32 %bp4_32.i143, ptr %btmp.i95, align 4
  %btmp4.i144 = getelementptr inbounds nuw i8, ptr %btmp.i95, i64 4
  store i64 %newret11, ptr %btmp4.i144, align 4
  %fits_sso.i116 = icmp samesign ult i64 %blen.i99, 9
  br i1 %fits_sso.i116, label %build_sso.i132, label %alloc_heap.i117

build_sso.i132:                                   ; preds = %build.i114
  store i64 0, ptr %out_sso.i96.sroa.6, align 8
  %out_sso.i96.sroa.0.4.insert.insert = or disjoint i64 %tot.i103, 2914519946132193280
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i96.sroa.6, ptr nonnull align 4 %btmp.i95, i64 %blen.i99, i1 false)
  %out_sso.i96.sroa.6.0.out_sso.i96.sroa.6.0.out_sso.i96.sroa.6.0.out_sso.i96.sroa.6.8.rw1.i138 = load i64, ptr %out_sso.i96.sroa.6, align 8
  %rs0.i139 = insertvalue %ArchxStr poison, i64 %out_sso.i96.sroa.0.4.insert.insert, 0
  %rs1.i140 = insertvalue %ArchxStr %rs0.i139, i64 %out_sso.i96.sroa.6.0.out_sso.i96.sroa.6.0.out_sso.i96.sroa.6.0.out_sso.i96.sroa.6.8.rw1.i138, 1
  br label %archx_str_concat.exit147

alloc_heap.i117:                                  ; preds = %build.i114.thread, %build.i114
  %bptr.i115380 = phi ptr [ %blptr.i113, %build.i114.thread ], [ %btmp.i95, %build.i114 ]
  %hp.i118 = tail call noalias align 16 ptr @malloc(i64 %tot.i103)
  %hnull.i119 = icmp eq ptr %hp.i118, null
  br i1 %hnull.i119, label %oom.i131, label %copy_long.i120

copy_long.i120:                                   ; preds = %alloc_heap.i117
  %hp_i.i121 = ptrtoint ptr %hp.i118 to i64
  %htagged.i122 = or disjoint i64 %hp_i.i121, 1
  store i32 678589555, ptr %hp.i118, align 16
  %dst_b.i123 = getelementptr inbounds nuw i8, ptr %hp.i118, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %dst_b.i123, ptr nonnull align 1 %bptr.i115380, i64 %blen.i99, i1 false)
  %w0_out.i127 = or disjoint i64 %tot.i103, 2914519946132193280
  %ls0.i128 = insertvalue %ArchxStr poison, i64 %w0_out.i127, 0
  %ls1.i129 = insertvalue %ArchxStr %ls0.i128, i64 %htagged.i122, 1
  br label %archx_str_concat.exit147

archx_str_concat.exit147:                         ; preds = %if.then.6, %build_sso.i132, %copy_long.i120
  %common.ret.op.i130 = phi %ArchxStr [ %rs1.i140, %build_sso.i132 ], [ %ls1.i129, %copy_long.i120 ], [ { i64 2914519946132193284, i64 0 }, %if.then.6 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i95)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i96.sroa.6)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i148)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i150)
  %aw0.i151 = extractvalue %ArchxStr %common.ret.op.i130, 0
  %aw1.i152 = extractvalue %ArchxStr %common.ret.op.i130, 1
  %alen.i153 = and i64 %aw0.i151, 4294967295
  %az.i154 = icmp eq i64 %alen.i153, 0
  br i1 %az.i154, label %archx_str_concat.exit201.thread, label %chk_bz.i155

chk_bz.i155:                                      ; preds = %archx_str_concat.exit147
  %tot.i157 = add nuw nsw i64 %alen.i153, 1
  %too_big.i158 = icmp samesign ugt i64 %alen.i153, 2147483646
  br i1 %too_big.i158, label %oom.i185, label %mat_a.i159

oom.i185:                                         ; preds = %alloc_heap.i171, %chk_bz.i155
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i159:                                       ; preds = %chk_bz.i155
  %ashort.i160 = icmp samesign ult i64 %alen.i153, 13
  br i1 %ashort.i160, label %mat_b.i164, label %mat_b.i164.thread

mat_b.i164.thread:                                ; preds = %mat_a.i159
  %araw.i162 = and i64 %aw1.i152, -4
  %alptr.i163 = inttoptr i64 %araw.i162 to ptr
  br label %alloc_heap.i171

mat_b.i164:                                       ; preds = %mat_a.i159
  %ap4.i196 = lshr i64 %aw0.i151, 32
  %ap4_32.i197 = trunc nuw i64 %ap4.i196 to i32
  store i32 %ap4_32.i197, ptr %atmp.i148, align 4
  %atmp4.i198 = getelementptr inbounds nuw i8, ptr %atmp.i148, i64 4
  store i64 %aw1.i152, ptr %atmp4.i198, align 4
  %fits_sso.i170.not = icmp eq i64 %alen.i153, 12
  br i1 %fits_sso.i170.not, label %alloc_heap.i171, label %build_sso.i186

build_sso.i186:                                   ; preds = %mat_b.i164
  %out_sso8.i187 = getelementptr inbounds nuw i8, ptr %out_sso.i150, i64 8
  %tot32.i188 = trunc nuw nsw i64 %tot.i157 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i150, i8 0, i64 16, i1 false)
  store i32 %tot32.i188, ptr %out_sso.i150, align 8
  %sso_dst_a.i189 = getelementptr inbounds nuw i8, ptr %out_sso.i150, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i189, ptr nonnull align 4 %atmp.i148, i64 %alen.i153, i1 false)
  %sso_dst_b.i190 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i189, i64 %alen.i153
  store i8 41, ptr %sso_dst_b.i190, align 1
  %rw0.i191 = load i64, ptr %out_sso.i150, align 8
  %rw1.i192 = load i64, ptr %out_sso8.i187, align 8
  %rs0.i193 = insertvalue %ArchxStr poison, i64 %rw0.i191, 0
  %rs1.i194 = insertvalue %ArchxStr %rs0.i193, i64 %rw1.i192, 1
  br label %archx_str_concat.exit201.thread

alloc_heap.i171:                                  ; preds = %mat_b.i164.thread, %mat_b.i164
  %aptr.i165350 = phi ptr [ %alptr.i163, %mat_b.i164.thread ], [ %atmp.i148, %mat_b.i164 ]
  %hp.i172 = tail call noalias align 16 ptr @malloc(i64 %tot.i157)
  %hnull.i173 = icmp eq ptr %hp.i172, null
  br i1 %hnull.i173, label %oom.i185, label %archx_str_concat.exit201

archx_str_concat.exit201.thread:                  ; preds = %archx_str_concat.exit147, %build_sso.i186
  %common.ret.op.i184.ph = phi %ArchxStr [ { i64 176093659137, i64 0 }, %archx_str_concat.exit147 ], [ %rs1.i194, %build_sso.i186 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i148)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i150)
  %t19352 = extractvalue %ArchxStr %common.ret.op.i184.ph, 0
  %t20353 = extractvalue %ArchxStr %common.ret.op.i184.ph, 1
  br label %archx_str_drop.exit22

archx_str_concat.exit201:                         ; preds = %alloc_heap.i171
  %hp_i.i175 = ptrtoint ptr %hp.i172 to i64
  %htagged.i176 = or disjoint i64 %hp_i.i175, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i172, ptr nonnull align 1 %aptr.i165350, i64 %alen.i153, i1 false)
  %dst_b.i177 = getelementptr inbounds nuw i8, ptr %hp.i172, i64 %alen.i153
  store i8 41, ptr %dst_b.i177, align 1
  %pref32.i178 = load i32, ptr %hp.i172, align 16
  %pref64.i179 = zext i32 %pref32.i178 to i64
  %pref_sh.i180 = shl nuw i64 %pref64.i179, 32
  %w0_out.i181 = or disjoint i64 %pref_sh.i180, %tot.i157
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i148)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i150)
  %tag.i17 = and i64 %aw1.i152, 1
  %owned.not.i18 = icmp eq i64 %tag.i17, 0
  %or.cond369 = select i1 %ashort.i160, i1 true, i1 %owned.not.i18
  br i1 %or.cond369, label %archx_str_drop.exit22, label %do_free.i19

do_free.i19:                                      ; preds = %archx_str_concat.exit201
  %raw.i20 = and i64 %aw1.i152, -2
  %ptr.i21 = inttoptr i64 %raw.i20 to ptr
  tail call void @free(ptr %ptr.i21)
  br label %archx_str_drop.exit22

archx_str_drop.exit22:                            ; preds = %archx_str_concat.exit201.thread, %archx_str_concat.exit201, %do_free.i19
  %t19352.pn = phi i64 [ %t19352, %archx_str_concat.exit201.thread ], [ %w0_out.i181, %archx_str_concat.exit201 ], [ %w0_out.i181, %do_free.i19 ]
  %t20353.pn = phi i64 [ %t20353, %archx_str_concat.exit201.thread ], [ %htagged.i176, %archx_str_concat.exit201 ], [ %htagged.i176, %do_free.i19 ]
  %t21354.pn = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t19352.pn, 1
  %t22357 = insertvalue %ArchxAny %t21354.pn, i64 %t20353.pn, 2
  %long.i25 = icmp samesign ult i64 %blen.i99, 13
  %tag.i28 = and i64 %newret11, 1
  %owned.not.i29 = icmp eq i64 %tag.i28, 0
  %or.cond370 = select i1 %long.i25, i1 true, i1 %owned.not.i29
  br i1 %or.cond370, label %common.ret, label %do_free.i30

do_free.i30:                                      ; preds = %archx_str_drop.exit22
  %raw.i31 = and i64 %newret11, -2
  %ptr.i32 = inttoptr i64 %raw.i31 to ptr
  tail call void @free(ptr %ptr.i32)
  br label %common.ret

l_cont.i:                                         ; preds = %if.else.1
  %w1.i315 = extractvalue %ArchxAny %arg.val, 1
  %raw.i316 = and i64 %w1.i315, -4
  %z.i = icmp eq i64 %raw.i316, 0
  br i1 %z.i, label %archx_any_len.exit, label %load_l.i

load_l.i:                                         ; preds = %l_cont.i
  %p.i = inttoptr i64 %raw.i316 to ptr
  %l.i = load i64, ptr %p.i, align 8
  br label %archx_any_len.exit

archx_any_len.exit:                               ; preds = %l_cont.i, %load_l.i
  %common.ret.op.i317 = phi i64 [ %l.i, %load_l.i ], [ 0, %l_cont.i ]
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i)
  %n32.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %common.ret.op.i317)
  %len.i318 = sext i32 %n32.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i)
  %z.i.i = icmp slt i32 %n32.i, 1
  br i1 %z.i.i, label %archx_str_from_int.exit, label %chk_sso.i.i

oom.i.i:                                          ; preds = %alloc_heap.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i:                                      ; preds = %archx_any_len.exit
  %short.i.i = icmp samesign ult i32 %n32.i, 13
  br i1 %short.i.i, label %pack_sso.i.i, label %alloc_heap.i.i

pack_sso.i.i:                                     ; preds = %chk_sso.i.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i, i8 0, i64 16, i1 false)
  store i32 %n32.i, ptr %sso.i.i, align 8
  %sso.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, -9223372036854775808) %len.i318, i1 false)
  %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i = load i64, ptr %sso.i.i, align 8
  %sso.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 8
  %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i = load i64, ptr %sso.i.i.8.sroa_idx, align 8
  %ss0.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i, 0
  %ss1.i.i = insertvalue %ArchxStr %ss0.i.i, i64 %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i, 1
  br label %archx_str_from_int.exit

alloc_heap.i.i:                                   ; preds = %chk_sso.i.i
  %hp.i.i = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, -9223372036854775808) %len.i318)
  %hnull.i.i = icmp eq ptr %hp.i.i, null
  br i1 %hnull.i.i, label %oom.i.i, label %copy_long.i.i

copy_long.i.i:                                    ; preds = %alloc_heap.i.i
  %hp_i.i.i = ptrtoint ptr %hp.i.i to i64
  %htagged.i.i = or disjoint i64 %hp_i.i.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, -9223372036854775808) %len.i318, i1 false)
  %pref32.i.i = load i32, ptr %hp.i.i, align 16
  %pref64.i.i = zext i32 %pref32.i.i to i64
  %pref_sh.i.i = shl nuw i64 %pref64.i.i, 32
  %w0_out.i.i = or disjoint i64 %pref_sh.i.i, %len.i318
  %ls0.i.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i, 0
  %ls1.i.i = insertvalue %ArchxStr %ls0.i.i, i64 %htagged.i.i, 1
  br label %archx_str_from_int.exit

archx_str_from_int.exit:                          ; preds = %archx_any_len.exit, %pack_sso.i.i, %copy_long.i.i
  %common.ret.op.i.i = phi %ArchxStr [ %ss1.i.i, %pack_sso.i.i ], [ %ls1.i.i, %copy_long.i.i ], [ zeroinitializer, %archx_any_len.exit ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i203)
  %bw0.i205 = extractvalue %ArchxStr %common.ret.op.i.i, 0
  %bw1.i206 = extractvalue %ArchxStr %common.ret.op.i.i, 1
  %blen.i207 = and i64 %bw0.i205, 4294967295
  %bz.i209 = icmp eq i64 %blen.i207, 0
  br i1 %bz.i209, label %archx_str_concat.exit255, label %calc_tot.i210

calc_tot.i210:                                    ; preds = %archx_str_from_int.exit
  %tot.i211 = add nuw nsw i64 %blen.i207, 9
  %too_big.i212 = icmp samesign ugt i64 %blen.i207, 2147483638
  br i1 %too_big.i212, label %oom.i239, label %mat_a.i213

oom.i239:                                         ; preds = %alloc_heap.i225, %calc_tot.i210
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i213:                                       ; preds = %calc_tot.i210
  %bshort.i218 = icmp samesign ult i64 %blen.i207, 13
  br i1 %bshort.i218, label %build.i222, label %build.i222.thread

build.i222.thread:                                ; preds = %mat_a.i213
  %braw.i220 = and i64 %bw1.i206, -4
  %blptr.i221 = inttoptr i64 %braw.i220 to ptr
  br label %alloc_heap.i225

build.i222:                                       ; preds = %mat_a.i213
  %bp4.i250 = lshr i64 %bw0.i205, 32
  %bp4_32.i251 = trunc nuw i64 %bp4.i250 to i32
  store i32 %bp4_32.i251, ptr %btmp.i203, align 4
  %btmp4.i252 = getelementptr inbounds nuw i8, ptr %btmp.i203, i64 4
  store i64 %bw1.i206, ptr %btmp4.i252, align 4
  %fits_sso.i224 = icmp samesign ult i64 %blen.i207, 4
  br i1 %fits_sso.i224, label %build_sso.i240, label %alloc_heap.i225

build_sso.i240:                                   ; preds = %build.i222
  store i24 0, ptr %out_sso.i204.sroa.6.sroa.5.sroa.0, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %out_sso.i204.sroa.6.sroa.5.sroa.0, ptr nonnull align 4 %btmp.i203, i64 %blen.i207, i1 false)
  %out_sso.i204.sroa.0.sroa.0.0.insert.insert = or disjoint i64 %tot.i211, 8391166443298750464
  %out_sso.i204.sroa.6.sroa.5.sroa.0.0.out_sso.i204.sroa.6.sroa.5.sroa.0.0.out_sso.i204.sroa.6.sroa.5.sroa.0.0.out_sso.i204.sroa.6.sroa.5.sroa.0.0.out_sso.i204.sroa.6.sroa.5.0.out_sso.i204.sroa.6.8.rw1.i246 = load i24, ptr %out_sso.i204.sroa.6.sroa.5.sroa.0, align 4
  %out_sso.i204.sroa.6.sroa.5.0.insert.ext = zext i24 %out_sso.i204.sroa.6.sroa.5.sroa.0.0.out_sso.i204.sroa.6.sroa.5.sroa.0.0.out_sso.i204.sroa.6.sroa.5.sroa.0.0.out_sso.i204.sroa.6.sroa.5.sroa.0.0.out_sso.i204.sroa.6.sroa.5.0.out_sso.i204.sroa.6.8.rw1.i246 to i64
  %out_sso.i204.sroa.6.sroa.5.0.insert.shift = shl nuw i64 %out_sso.i204.sroa.6.sroa.5.0.insert.ext, 40
  %out_sso.i204.sroa.6.sroa.0.0.insert.insert = or disjoint i64 %out_sso.i204.sroa.6.sroa.5.0.insert.shift, 263845145640
  %rs0.i247 = insertvalue %ArchxStr poison, i64 %out_sso.i204.sroa.0.sroa.0.0.insert.insert, 0
  %rs1.i248 = insertvalue %ArchxStr %rs0.i247, i64 %out_sso.i204.sroa.6.sroa.0.0.insert.insert, 1
  br label %archx_str_concat.exit255

alloc_heap.i225:                                  ; preds = %build.i222.thread, %build.i222
  %bptr.i223383 = phi ptr [ %blptr.i221, %build.i222.thread ], [ %btmp.i203, %build.i222 ]
  %hp.i226 = tail call noalias align 16 ptr @malloc(i64 %tot.i211)
  %hnull.i227 = icmp eq ptr %hp.i226, null
  br i1 %hnull.i227, label %oom.i239, label %copy_long.i228

copy_long.i228:                                   ; preds = %alloc_heap.i225
  %hp_i.i229 = ptrtoint ptr %hp.i226 to i64
  %htagged.i230 = or disjoint i64 %hp_i.i229, 1
  store i32 1953720684, ptr %hp.i226, align 16
  %atmp.i202.sroa.5.0.hp.i226.sroa_idx = getelementptr inbounds nuw i8, ptr %hp.i226, i64 4
  store i40 263845145640, ptr %atmp.i202.sroa.5.0.hp.i226.sroa_idx, align 4
  %dst_b.i231 = getelementptr inbounds nuw i8, ptr %hp.i226, i64 9
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i231, ptr nonnull align 1 %bptr.i223383, i64 %blen.i207, i1 false)
  %w0_out.i235 = or disjoint i64 %tot.i211, 8391166443298750464
  %ls0.i236 = insertvalue %ArchxStr poison, i64 %w0_out.i235, 0
  %ls1.i237 = insertvalue %ArchxStr %ls0.i236, i64 %htagged.i230, 1
  br label %archx_str_concat.exit255

archx_str_concat.exit255:                         ; preds = %archx_str_from_int.exit, %build_sso.i240, %copy_long.i228
  %common.ret.op.i238 = phi %ArchxStr [ %rs1.i248, %build_sso.i240 ], [ %ls1.i237, %copy_long.i228 ], [ { i64 8391166443298750473, i64 263845145640 }, %archx_str_from_int.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i203)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %atmp.i256)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %out_sso.i258)
  %aw0.i259 = extractvalue %ArchxStr %common.ret.op.i238, 0
  %aw1.i260 = extractvalue %ArchxStr %common.ret.op.i238, 1
  %alen.i261 = and i64 %aw0.i259, 4294967295
  %az.i262 = icmp eq i64 %alen.i261, 0
  br i1 %az.i262, label %archx_str_concat.exit309.thread, label %chk_bz.i263

chk_bz.i263:                                      ; preds = %archx_str_concat.exit255
  %tot.i265 = add nuw nsw i64 %alen.i261, 1
  %too_big.i266 = icmp samesign ugt i64 %alen.i261, 2147483646
  br i1 %too_big.i266, label %oom.i293, label %mat_a.i267

oom.i293:                                         ; preds = %alloc_heap.i279, %chk_bz.i263
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i267:                                       ; preds = %chk_bz.i263
  %ashort.i268 = icmp samesign ult i64 %alen.i261, 13
  br i1 %ashort.i268, label %mat_b.i272, label %mat_b.i272.thread

mat_b.i272.thread:                                ; preds = %mat_a.i267
  %araw.i270 = and i64 %aw1.i260, -4
  %alptr.i271 = inttoptr i64 %araw.i270 to ptr
  br label %alloc_heap.i279

mat_b.i272:                                       ; preds = %mat_a.i267
  %ap4.i304 = lshr i64 %aw0.i259, 32
  %ap4_32.i305 = trunc nuw i64 %ap4.i304 to i32
  store i32 %ap4_32.i305, ptr %atmp.i256, align 4
  %atmp4.i306 = getelementptr inbounds nuw i8, ptr %atmp.i256, i64 4
  store i64 %aw1.i260, ptr %atmp4.i306, align 4
  %fits_sso.i278.not = icmp eq i64 %alen.i261, 12
  br i1 %fits_sso.i278.not, label %alloc_heap.i279, label %build_sso.i294

build_sso.i294:                                   ; preds = %mat_b.i272
  %out_sso8.i295 = getelementptr inbounds nuw i8, ptr %out_sso.i258, i64 8
  %tot32.i296 = trunc nuw nsw i64 %tot.i265 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso.i258, i8 0, i64 16, i1 false)
  store i32 %tot32.i296, ptr %out_sso.i258, align 8
  %sso_dst_a.i297 = getelementptr inbounds nuw i8, ptr %out_sso.i258, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a.i297, ptr nonnull align 4 %atmp.i256, i64 %alen.i261, i1 false)
  %sso_dst_b.i298 = getelementptr inbounds nuw i8, ptr %sso_dst_a.i297, i64 %alen.i261
  store i8 41, ptr %sso_dst_b.i298, align 1
  %rw0.i299 = load i64, ptr %out_sso.i258, align 8
  %rw1.i300 = load i64, ptr %out_sso8.i295, align 8
  %rs0.i301 = insertvalue %ArchxStr poison, i64 %rw0.i299, 0
  %rs1.i302 = insertvalue %ArchxStr %rs0.i301, i64 %rw1.i300, 1
  br label %archx_str_concat.exit309.thread

alloc_heap.i279:                                  ; preds = %mat_b.i272.thread, %mat_b.i272
  %aptr.i273360 = phi ptr [ %alptr.i271, %mat_b.i272.thread ], [ %atmp.i256, %mat_b.i272 ]
  %hp.i280 = tail call noalias align 16 ptr @malloc(i64 %tot.i265)
  %hnull.i281 = icmp eq ptr %hp.i280, null
  br i1 %hnull.i281, label %oom.i293, label %archx_str_concat.exit309

archx_str_concat.exit309.thread:                  ; preds = %archx_str_concat.exit255, %build_sso.i294
  %common.ret.op.i292.ph = phi %ArchxStr [ { i64 176093659137, i64 0 }, %archx_str_concat.exit255 ], [ %rs1.i302, %build_sso.i294 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i256)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i258)
  %t29362 = extractvalue %ArchxStr %common.ret.op.i292.ph, 0
  %t30363 = extractvalue %ArchxStr %common.ret.op.i292.ph, 1
  br label %archx_str_drop.exit44

archx_str_concat.exit309:                         ; preds = %alloc_heap.i279
  %hp_i.i283 = ptrtoint ptr %hp.i280 to i64
  %htagged.i284 = or disjoint i64 %hp_i.i283, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i280, ptr nonnull align 1 %aptr.i273360, i64 %alen.i261, i1 false)
  %dst_b.i285 = getelementptr inbounds nuw i8, ptr %hp.i280, i64 %alen.i261
  store i8 41, ptr %dst_b.i285, align 1
  %pref32.i286 = load i32, ptr %hp.i280, align 16
  %pref64.i287 = zext i32 %pref32.i286 to i64
  %pref_sh.i288 = shl nuw i64 %pref64.i287, 32
  %w0_out.i289 = or disjoint i64 %pref_sh.i288, %tot.i265
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %atmp.i256)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %out_sso.i258)
  %tag.i39 = and i64 %aw1.i260, 1
  %owned.not.i40 = icmp eq i64 %tag.i39, 0
  %or.cond371 = select i1 %ashort.i268, i1 true, i1 %owned.not.i40
  br i1 %or.cond371, label %archx_str_drop.exit44, label %do_free.i41

do_free.i41:                                      ; preds = %archx_str_concat.exit309
  %raw.i42 = and i64 %aw1.i260, -2
  %ptr.i43 = inttoptr i64 %raw.i42 to ptr
  tail call void @free(ptr %ptr.i43)
  br label %archx_str_drop.exit44

archx_str_drop.exit44:                            ; preds = %archx_str_concat.exit309.thread, %archx_str_concat.exit309, %do_free.i41
  %t29362.pn = phi i64 [ %t29362, %archx_str_concat.exit309.thread ], [ %w0_out.i289, %archx_str_concat.exit309 ], [ %w0_out.i289, %do_free.i41 ]
  %t30363.pn = phi i64 [ %t30363, %archx_str_concat.exit309.thread ], [ %htagged.i284, %archx_str_concat.exit309 ], [ %htagged.i284, %do_free.i41 ]
  %t31364.pn = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t29362.pn, 1
  %t32367 = insertvalue %ArchxAny %t31364.pn, i64 %t30363.pn, 2
  %long.i47 = icmp samesign ult i64 %blen.i207, 13
  %tag.i50 = and i64 %bw1.i206, 1
  %owned.not.i51 = icmp eq i64 %tag.i50, 0
  %or.cond372 = select i1 %long.i47, i1 true, i1 %owned.not.i51
  br i1 %or.cond372, label %common.ret, label %do_free.i52

do_free.i52:                                      ; preds = %archx_str_drop.exit44
  %raw.i53 = and i64 %bw1.i206, -2
  %ptr.i54 = inttoptr i64 %raw.i53 to ptr
  tail call void @free(ptr %ptr.i54)
  br label %common.ret

t1.i:                                             ; preds = %if.else.1
  br label %archx_any_type_name.exit

t3.i:                                             ; preds = %if.else.1
  br label %archx_any_type_name.exit

t6.i:                                             ; preds = %if.else.1
  br label %archx_any_type_name.exit

t7.i:                                             ; preds = %if.else.1
  br label %archx_any_type_name.exit

archx_any_type_name.exit:                         ; preds = %if.else.1, %t1.i, %t3.i, %t6.i, %t7.i
  %common.ret.op.i322 = phi %ArchxStr [ { i64 7813586345208578052, i64 0 }, %t1.i ], [ { i64 7020949529436356613, i64 116 }, %t3.i ], [ { i64 8386662809311641604, i64 0 }, %t6.i ], [ { i64 32762641894080515, i64 0 }, %t7.i ], [ { i64 7308901626067025928, i64 1701869908 }, %if.else.1 ]
  %w0.i323 = extractvalue %ArchxStr %common.ret.op.i322, 0
  %len.i324 = and i64 %w0.i323, 4294967295
  %long.i325 = icmp samesign ugt i64 %len.i324, 12
  br i1 %long.i325, label %chk_tag.i327, label %archx_str_clone.exit

chk_tag.i327:                                     ; preds = %archx_any_type_name.exit
  %w1.i328 = extractvalue %ArchxStr %common.ret.op.i322, 1
  %tag.i329 = and i64 %w1.i328, 3
  %owned.not.i330 = icmp eq i64 %tag.i329, 0
  br i1 %owned.not.i330, label %archx_str_clone.exit, label %dup_heap.i

dup_heap.i:                                       ; preds = %chk_tag.i327
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %len.i324)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i331, label %copy.i

oom.i331:                                         ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %w1.i328, -4
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 4 %src.i, i64 %len.i324, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %out.i = insertvalue %ArchxStr %common.ret.op.i322, i64 %tagged.i, 1
  %.pre = extractvalue %ArchxStr %common.ret.op.i322, 0
  br label %archx_str_clone.exit

archx_str_clone.exit:                             ; preds = %archx_any_type_name.exit, %chk_tag.i327, %copy.i
  %t35.pre-phi = phi i64 [ %w0.i323, %archx_any_type_name.exit ], [ %w0.i323, %chk_tag.i327 ], [ %.pre, %copy.i ]
  %common.ret.op.i326 = phi %ArchxStr [ %common.ret.op.i322, %archx_any_type_name.exit ], [ %common.ret.op.i322, %chk_tag.i327 ], [ %out.i, %copy.i ]
  %t36 = extractvalue %ArchxStr %common.ret.op.i326, 1
  %t37 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t35.pre-phi, 1
  %t38 = insertvalue %ArchxAny %t37, i64 %t36, 2
  br label %common.ret
}

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %tmp.i810 = alloca [12 x i8], align 4
  %tmp.i736 = alloca [12 x i8], align 4
  %tmp.i718 = alloca [12 x i8], align 4
  %tmp.i700 = alloca [12 x i8], align 4
  %tmp.i563 = alloca [12 x i8], align 4
  %tmp.i545 = alloca [12 x i8], align 4
  %tmp.i526 = alloca [12 x i8], align 4
  %tmp.i511 = alloca [12 x i8], align 4
  %sso.i.i500 = alloca [16 x i8], align 8
  %tmp.i = alloca [12 x i8], align 4
  %func.region.i = alloca %ArchxRegion, align 8
  %t0 = tail call noalias align 16 dereferenceable_or_null(112) ptr @malloc(i64 112)
  %t1 = icmp eq ptr %t0, null
  br i1 %t1, label %alloc.oom.1, label %alloc.ok.0

alloc.oom.1:                                      ; preds = %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.0:                                       ; preds = %entry
  store i64 7521981563576254469, ptr %t0, align 16
  %t0.repack30 = getelementptr inbounds nuw i8, ptr %t0, i64 8
  store i64 120, ptr %t0.repack30, align 8
  %t3 = getelementptr inbounds nuw i8, ptr %t0, i64 16
  store i64 7236556118896410628, ptr %t3, align 16
  %t3.repack31 = getelementptr inbounds nuw i8, ptr %t0, i64 24
  store i64 0, ptr %t3.repack31, align 8
  %t4 = getelementptr inbounds nuw i8, ptr %t0, i64 32
  store i64 7521981563576254469, ptr %t4, align 16
  %t4.repack32 = getelementptr inbounds nuw i8, ptr %t0, i64 40
  store i64 120, ptr %t4.repack32, align 8
  %t5 = getelementptr inbounds nuw i8, ptr %t0, i64 48
  store i64 7887611008498270212, ptr %t5, align 16
  %t5.repack33 = getelementptr inbounds nuw i8, ptr %t0, i64 56
  store i64 0, ptr %t5.repack33, align 8
  %t6 = getelementptr inbounds nuw i8, ptr %t0, i64 64
  store i64 7526774399186239494, ptr %t6, align 16
  %t6.repack34 = getelementptr inbounds nuw i8, ptr %t0, i64 72
  store i64 28271, ptr %t6.repack34, align 8
  %t7 = getelementptr inbounds nuw i8, ptr %t0, i64 80
  store i64 7521981563576254469, ptr %t7, align 16
  %t7.repack35 = getelementptr inbounds nuw i8, ptr %t0, i64 88
  store i64 120, ptr %t7.repack35, align 8
  %t8 = getelementptr inbounds nuw i8, ptr %t0, i64 96
  store i64 7236556118896410628, ptr %t8, align 16
  %t8.repack36 = getelementptr inbounds nuw i8, ptr %t0, i64 104
  store i64 0, ptr %t8.repack36, align 8
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %func.region.i)
  %.fca.2.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 16
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %func.region.i, i8 0, i64 32, i1 false)
  %res.i.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 64)
  %.pre.i.i = ptrtoint ptr %res.i.i.i to i64
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(64) %res.i.i.i, i8 0, i64 64, i1 false)
  %r_reg_gep.i.i = getelementptr inbounds nuw i8, ptr %res.i.i.i, i64 24
  store ptr %func.region.i, ptr %r_reg_gep.i.i, align 8
  %r_meta_gep.i.i = getelementptr inbounds nuw i8, ptr %res.i.i.i, i64 56
  store i64 34359742465, ptr %r_meta_gep.i.i, align 8
  %rtag.i.i = or disjoint i64 %.pre.i.i, 2
  %ctrl_p.i.i.i = getelementptr inbounds nuw i8, ptr %res.i.i.i, i64 32
  %mask_p.i.i.i = getelementptr inbounds nuw i8, ptr %res.i.i.i, i64 16
  %keys_p.i.i.i = getelementptr inbounds nuw i8, ptr %res.i.i.i, i64 40
  %t17.i = getelementptr inbounds nuw i8, ptr %res.i.i.i, i64 48
  br label %foreach.body.1.i

foreach.body.1.i:                                 ; preds = %foreach.step.2.i, %alloc.ok.0
  %foreach.idx.4.0120.i = phi i64 [ 0, %alloc.ok.0 ], [ %t32.i, %foreach.step.2.i ]
  %t7.i = getelementptr inbounds nuw %ArchxStr, ptr %t0, i64 %foreach.idx.4.0120.i
  %t8.unpack.i = load i64, ptr %t7.i, align 16
  %0 = insertvalue %ArchxStr poison, i64 %t8.unpack.i, 0
  %t8.elt11.i = getelementptr inbounds nuw i8, ptr %t7.i, i64 8
  %t8.unpack12.i = load i64, ptr %t8.elt11.i, align 8
  %t813.i = insertvalue %ArchxStr %0, i64 %t8.unpack12.i, 1
  %ctrl.i.i.i = load ptr, ptr %ctrl_p.i.i.i, align 16
  %c_null.i.i.i = icmp eq ptr %ctrl.i.i.i, null
  br i1 %c_null.i.i.i, label %if.else.5.i, label %do_probe.i.i.i

do_probe.i.i.i:                                   ; preds = %foreach.body.1.i
  %mask.i.i.i = load i64, ptr %mask_p.i.i.i, align 16
  %keys.i.i.i = load ptr, ptr %keys_p.i.i.i, align 8
  %1 = getelementptr i8, ptr %ctrl.i.i.i, i64 %mask.i.i.i
  %idx_base.i.i.i = getelementptr i8, ptr %1, i64 17
  %h.i.i.i = call fastcc i64 @archx_hash_str(%ArchxStr %t813.i)
  %h2_64.i.i.i = lshr i64 %h.i.i.i, 57
  %h2.i.i.i = trunc nuw nsw i64 %h2_64.i.i.i to i8
  %h2_ins.i.i.i = insertelement <16 x i8> poison, i8 %h2.i.i.i, i64 0
  %h2_vec.i.i.i = shufflevector <16 x i8> %h2_ins.i.i.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bp_i.i.i = and i64 %t8.unpack12.i, -4
  %bp.i.i = inttoptr i64 %bp_i.i.i to ptr
  %bp4.i.i = getelementptr inbounds nuw i8, ptr %bp.i.i, i64 4
  %len.i.i = and i64 %t8.unpack.i, 4294967295
  %short.i.i = icmp samesign ult i64 %len.i.i, 13
  %rem.i.i = add nsw i64 %len.i.i, -4
  br label %probe.i.i.i

probe.i.i.i:                                      ; preds = %next_grp.i.i.i, %do_probe.i.i.i
  %h.pn.i.i.i = phi i64 [ %h.i.i.i, %do_probe.i.i.i ], [ %padd.i.i.i, %next_grp.i.i.i ]
  %step.i.i.i = phi i64 [ 0, %do_probe.i.i.i ], [ %step_next.i.i.i, %next_grp.i.i.i ]
  %pos.i.i.i = and i64 %h.pn.i.i.i, %mask.i.i.i
  %gp.i.i.i = getelementptr inbounds i8, ptr %ctrl.i.i.i, i64 %pos.i.i.i
  %grp.i.i.i = load <16 x i8>, ptr %gp.i.i.i, align 1
  %mcmp.i.i.i = icmp eq <16 x i8> %grp.i.i.i, %h2_vec.i.i.i
  %mbits.i.i.i = bitcast <16 x i1> %mcmp.i.i.i to i16
  %has_m.not.i.i.not115.i = icmp eq i16 %mbits.i.i.i, 0
  br i1 %has_m.not.i.i.not115.i, label %chk_empty.i.i.i, label %chk_key.i.i.preheader.i

chk_key.i.i.preheader.i:                          ; preds = %probe.i.i.i
  %mmask0.i.i.i = zext i16 %mbits.i.i.i to i32
  br label %chk_key.i.i.i

chk_key.i.i.i:                                    ; preds = %mbit_cont.i.i.i, %chk_key.i.i.preheader.i
  %mmask.i.i116.i = phi i32 [ %mmask_next.i.i.i, %mbit_cont.i.i.i ], [ %mmask0.i.i.i, %chk_key.i.i.preheader.i ]
  %tz.i.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i116.i, i1 true)
  %tz64.i.i.i = zext nneg i32 %tz.i.i.i to i64
  %s_add.i.i.i = add i64 %pos.i.i.i, %tz64.i.i.i
  %slot.i.i.i = and i64 %s_add.i.i.i, %mask.i.i.i
  %ip.i.i.i = getelementptr inbounds i32, ptr %idx_base.i.i.i, i64 %slot.i.i.i
  %didx32.i.i.i = load i32, ptr %ip.i.i.i, align 4
  %didx.i.i.i = zext i32 %didx32.i.i.i to i64
  %kp.i.i.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i, i64 %didx.i.i.i
  %cand_k.unpack.i.i.i = load i64, ptr %kp.i.i.i, align 8
  %cand_k.elt1.i.i.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i, i64 8
  %cand_k.unpack2.i.i.i = load i64, ptr %cand_k.elt1.i.i.i, align 8
  %w0_eq.i.i = icmp eq i64 %cand_k.unpack.i.i.i, %t8.unpack.i
  br i1 %w0_eq.i.i, label %chk_len.i.i, label %mbit_cont.i.i.i

chk_len.i.i:                                      ; preds = %chk_key.i.i.i
  br i1 %short.i.i, label %cmp_short.i.i, label %cmp_long.i.i

cmp_short.i.i:                                    ; preds = %chk_len.i.i
  %eq_s.i.i = icmp eq i64 %cand_k.unpack2.i.i.i, %t8.unpack12.i
  br i1 %eq_s.i.i, label %probe.i.i32.i.loopexit, label %mbit_cont.i.i.i

cmp_long.i.i:                                     ; preds = %chk_len.i.i
  %ap_i.i.i = and i64 %cand_k.unpack2.i.i.i, -4
  %same_ptr.i.i = icmp eq i64 %ap_i.i.i, %bp_i.i.i
  br i1 %same_ptr.i.i, label %probe.i.i32.i.loopexit, label %archx_str_eq.exit.i

archx_str_eq.exit.i:                              ; preds = %cmp_long.i.i
  %ap.i.i = inttoptr i64 %ap_i.i.i to ptr
  %ap4.i.i = getelementptr inbounds nuw i8, ptr %ap.i.i, i64 4
  %bcmp.i.i = call i32 @bcmp(ptr nonnull %ap4.i.i, ptr nonnull %bp4.i.i, i64 %rem.i.i)
  %eq_m.i.i = icmp eq i32 %bcmp.i.i, 0
  br i1 %eq_m.i.i, label %probe.i.i32.i.loopexit, label %mbit_cont.i.i.i

mbit_cont.i.i.i:                                  ; preds = %archx_str_eq.exit.i, %cmp_short.i.i, %chk_key.i.i.i
  %mm1.i.i.i = add nsw i32 %mmask.i.i116.i, -1
  %mmask_next.i.i.i = and i32 %mm1.i.i.i, %mmask.i.i116.i
  %has_m.not.i.i.not.i = icmp eq i32 %mmask_next.i.i.i, 0
  br i1 %has_m.not.i.i.not.i, label %chk_empty.i.i.i, label %chk_key.i.i.i

chk_empty.i.i.i:                                  ; preds = %mbit_cont.i.i.i, %probe.i.i.i
  %ecmp.i.i.i = icmp eq <16 x i8> %grp.i.i.i, splat (i8 -128)
  %ebits.i.i.i = bitcast <16 x i1> %ecmp.i.i.i to i16
  %has_e.not.i.i.i = icmp eq i16 %ebits.i.i.i, 0
  br i1 %has_e.not.i.i.i, label %next_grp.i.i.i, label %if.else.5.i

next_grp.i.i.i:                                   ; preds = %chk_empty.i.i.i
  %step_next.i.i.i = add i64 %step.i.i.i, 16
  %padd.i.i.i = add i64 %step_next.i.i.i, %pos.i.i.i
  br label %probe.i.i.i

probe.i.i32.i.loopexit:                           ; preds = %archx_str_eq.exit.i, %cmp_long.i.i, %cmp_short.i.i
  br label %probe.i.i32.i

probe.i.i32.i:                                    ; preds = %probe.i.i32.i.loopexit, %next_grp.i.i70.i
  %h.pn.i.i33.i = phi i64 [ %padd.i.i72.i, %next_grp.i.i70.i ], [ %h.i.i.i, %probe.i.i32.i.loopexit ]
  %step.i.i34.i = phi i64 [ %step_next.i.i71.i, %next_grp.i.i70.i ], [ 0, %probe.i.i32.i.loopexit ]
  %pos.i.i35.i = and i64 %h.pn.i.i33.i, %mask.i.i.i
  %gp.i.i36.i = getelementptr inbounds i8, ptr %ctrl.i.i.i, i64 %pos.i.i35.i
  %grp.i.i37.i = load <16 x i8>, ptr %gp.i.i36.i, align 1
  %mcmp.i.i38.i = icmp eq <16 x i8> %grp.i.i37.i, %h2_vec.i.i.i
  %mbits.i.i39.i = bitcast <16 x i1> %mcmp.i.i38.i to i16
  %has_m.not.i.i43118.i = icmp eq i16 %mbits.i.i39.i, 0
  br i1 %has_m.not.i.i43118.i, label %chk_empty.i.i66.i, label %chk_key.i.i44.preheader.i

chk_key.i.i44.preheader.i:                        ; preds = %probe.i.i32.i
  %mmask0.i.i40.i = zext i16 %mbits.i.i39.i to i32
  br label %chk_key.i.i44.i

chk_key.i.i44.i:                                  ; preds = %mbit_cont.i.i58.i, %chk_key.i.i44.preheader.i
  %mmask.i.i42119.i = phi i32 [ %mmask_next.i.i60.i, %mbit_cont.i.i58.i ], [ %mmask0.i.i40.i, %chk_key.i.i44.preheader.i ]
  %tz.i.i45.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i42119.i, i1 true)
  %tz64.i.i46.i = zext nneg i32 %tz.i.i45.i to i64
  %s_add.i.i47.i = add i64 %pos.i.i35.i, %tz64.i.i46.i
  %slot.i.i48.i = and i64 %s_add.i.i47.i, %mask.i.i.i
  %ip.i.i49.i = getelementptr inbounds i32, ptr %idx_base.i.i.i, i64 %slot.i.i48.i
  %didx32.i.i50.i = load i32, ptr %ip.i.i49.i, align 4
  %didx.i.i51.i = zext i32 %didx32.i.i50.i to i64
  %kp.i.i52.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i, i64 %didx.i.i51.i
  %cand_k.unpack.i.i53.i = load i64, ptr %kp.i.i52.i, align 8
  %cand_k.elt1.i.i54.i = getelementptr inbounds nuw i8, ptr %kp.i.i52.i, i64 8
  %cand_k.unpack2.i.i55.i = load i64, ptr %cand_k.elt1.i.i54.i, align 8
  %w0_eq.i75.i = icmp eq i64 %cand_k.unpack.i.i53.i, %t8.unpack.i
  br i1 %w0_eq.i75.i, label %chk_len.i77.i, label %mbit_cont.i.i58.i

chk_len.i77.i:                                    ; preds = %chk_key.i.i44.i
  br i1 %short.i.i, label %cmp_short.i92.i, label %cmp_long.i80.i

cmp_short.i92.i:                                  ; preds = %chk_len.i77.i
  %eq_s.i93.i = icmp eq i64 %cand_k.unpack2.i.i55.i, %t8.unpack12.i
  br i1 %eq_s.i93.i, label %dupd.ok.7.i, label %mbit_cont.i.i58.i

cmp_long.i80.i:                                   ; preds = %chk_len.i77.i
  %ap_i.i81.i = and i64 %cand_k.unpack2.i.i55.i, -4
  %same_ptr.i83.i = icmp eq i64 %ap_i.i81.i, %bp_i.i.i
  br i1 %same_ptr.i83.i, label %dupd.ok.7.i, label %archx_str_eq.exit94.i

archx_str_eq.exit94.i:                            ; preds = %cmp_long.i80.i
  %ap.i85.i = inttoptr i64 %ap_i.i81.i to ptr
  %ap4.i87.i = getelementptr inbounds nuw i8, ptr %ap.i85.i, i64 4
  %bcmp.i90.i = call i32 @bcmp(ptr nonnull %ap4.i87.i, ptr nonnull %bp4.i.i, i64 %rem.i.i)
  %eq_m.i91.i = icmp eq i32 %bcmp.i90.i, 0
  br i1 %eq_m.i91.i, label %dupd.ok.7.i, label %mbit_cont.i.i58.i

mbit_cont.i.i58.i:                                ; preds = %archx_str_eq.exit94.i, %cmp_short.i92.i, %chk_key.i.i44.i
  %mm1.i.i59.i = add nsw i32 %mmask.i.i42119.i, -1
  %mmask_next.i.i60.i = and i32 %mm1.i.i59.i, %mmask.i.i42119.i
  %has_m.not.i.i43.i = icmp eq i32 %mmask_next.i.i60.i, 0
  br i1 %has_m.not.i.i43.i, label %chk_empty.i.i66.i, label %chk_key.i.i44.i

chk_empty.i.i66.i:                                ; preds = %mbit_cont.i.i58.i, %probe.i.i32.i
  %ecmp.i.i67.i = icmp eq <16 x i8> %grp.i.i37.i, splat (i8 -128)
  %ebits.i.i68.i = bitcast <16 x i1> %ecmp.i.i67.i to i16
  %has_e.not.i.i69.i = icmp eq i16 %ebits.i.i68.i, 0
  br i1 %has_e.not.i.i69.i, label %next_grp.i.i70.i, label %dupd.miss.8.i

next_grp.i.i70.i:                                 ; preds = %chk_empty.i.i66.i
  %step_next.i.i71.i = add i64 %step.i.i34.i, 16
  %padd.i.i72.i = add i64 %step_next.i.i71.i, %pos.i.i35.i
  br label %probe.i.i32.i

dupd.miss.8.i:                                    ; preds = %chk_empty.i.i66.i
  call fastcc void @archx_key_fail()
  unreachable

dupd.ok.7.i:                                      ; preds = %archx_str_eq.exit94.i, %cmp_long.i80.i, %cmp_short.i92.i
  %t18.i = load ptr, ptr %t17.i, align 16
  %t19.i = getelementptr inbounds nuw i64, ptr %t18.i, i64 %didx.i.i51.i
  %t20.i = load i64, ptr %t19.i, align 8
  %t21.i = add i64 %t20.i, 1
  store i64 %t21.i, ptr %t19.i, align 8
  br label %foreach.step.2.i

if.else.5.i:                                      ; preds = %chk_empty.i.i.i, %foreach.body.1.i
  %t23.i = call fastcc { i64, i1 } @archx_dict_upsert_str(i64 %rtag.i.i, %ArchxStr %t813.i)
  %t24.i = extractvalue { i64, i1 } %t23.i, 0
  %t29.i = load ptr, ptr %t17.i, align 16
  %t30.i = getelementptr inbounds i64, ptr %t29.i, i64 %t24.i
  store i64 1, ptr %t30.i, align 8
  br label %foreach.step.2.i

foreach.step.2.i:                                 ; preds = %if.else.5.i, %dupd.ok.7.i
  %t32.i = add nuw nsw i64 %foreach.idx.4.0120.i, 1
  %exitcond.not.i = icmp eq i64 %t32.i, 7
  br i1 %exitcond.not.i, label %dlen.load.10.i, label %foreach.body.1.i

dlen.load.10.i:                                   ; preds = %foreach.step.2.i
  %t38.i = load i64, ptr %res.i.i.i, align 16
  %t42121.i = icmp sgt i64 %t38.i, 0
  %keys.i.pre.i = load ptr, ptr %keys_p.i.i.i, align 8
  br i1 %t42121.i, label %foritems.body.13.i.preheader, label %archx_dict_drop_s_i.exit.i

foritems.body.13.i.preheader:                     ; preds = %dlen.load.10.i
  %xtraiter = and i64 %t38.i, 1
  %2 = icmp eq i64 %t38.i, 1
  br i1 %2, label %d_elem.i.i.preheader.unr-lcssa, label %foritems.body.13.i.preheader.new

foritems.body.13.i.preheader.new:                 ; preds = %foritems.body.13.i.preheader
  %unroll_iter = and i64 %t38.i, 9223372036854775806
  br label %foritems.body.13.i

foritems.body.13.i:                               ; preds = %foritems.step.14.i.1, %foritems.body.13.i.preheader.new
  %foritems.idx.40.0123.i = phi i64 [ 0, %foritems.body.13.i.preheader.new ], [ %t60.i.1, %foritems.step.14.i.1 ]
  %var.total.33.0122.i = phi i64 [ 0, %foritems.body.13.i.preheader.new ], [ %var.total.33.1.i.1, %foritems.step.14.i.1 ]
  %niter = phi i64 [ 0, %foritems.body.13.i.preheader.new ], [ %niter.next.1, %foritems.step.14.i.1 ]
  %t49.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.pre.i, i64 %foritems.idx.40.0123.i
  %t50.unpack.i = load i64, ptr %t49.i, align 8
  %t54.i = and i64 %t50.unpack.i, 4294967295
  %t55.i = icmp samesign ugt i64 %t54.i, 2
  br i1 %t55.i, label %if.then.16.i, label %foritems.step.14.i

if.then.16.i:                                     ; preds = %foritems.body.13.i
  %t48.i = load ptr, ptr %t17.i, align 16
  %t51.i = getelementptr inbounds nuw i64, ptr %t48.i, i64 %foritems.idx.40.0123.i
  %t52.i = load i64, ptr %t51.i, align 8
  %t57.i = mul i64 %t52.i, 10
  %t58.i = add i64 %t57.i, %var.total.33.0122.i
  br label %foritems.step.14.i

foritems.step.14.i:                               ; preds = %if.then.16.i, %foritems.body.13.i
  %var.total.33.1.i = phi i64 [ %t58.i, %if.then.16.i ], [ %var.total.33.0122.i, %foritems.body.13.i ]
  %t60.i = or disjoint i64 %foritems.idx.40.0123.i, 1
  %t49.i.1 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.pre.i, i64 %t60.i
  %t50.unpack.i.1 = load i64, ptr %t49.i.1, align 8
  %t54.i.1 = and i64 %t50.unpack.i.1, 4294967295
  %t55.i.1 = icmp samesign ugt i64 %t54.i.1, 2
  br i1 %t55.i.1, label %if.then.16.i.1, label %foritems.step.14.i.1

if.then.16.i.1:                                   ; preds = %foritems.step.14.i
  %t48.i.1 = load ptr, ptr %t17.i, align 16
  %t51.i.1 = getelementptr inbounds nuw i64, ptr %t48.i.1, i64 %t60.i
  %t52.i.1 = load i64, ptr %t51.i.1, align 8
  %t57.i.1 = mul i64 %t52.i.1, 10
  %t58.i.1 = add i64 %t57.i.1, %var.total.33.1.i
  br label %foritems.step.14.i.1

foritems.step.14.i.1:                             ; preds = %if.then.16.i.1, %foritems.step.14.i
  %var.total.33.1.i.1 = phi i64 [ %t58.i.1, %if.then.16.i.1 ], [ %var.total.33.1.i, %foritems.step.14.i ]
  %t60.i.1 = add nuw nsw i64 %foritems.idx.40.0123.i, 2
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1 = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1, label %d_elem.i.i.preheader.unr-lcssa, label %foritems.body.13.i

d_elem.i.i.preheader.unr-lcssa:                   ; preds = %foritems.step.14.i.1, %foritems.body.13.i.preheader
  %var.total.33.1.i.lcssa.ph = phi i64 [ poison, %foritems.body.13.i.preheader ], [ %var.total.33.1.i.1, %foritems.step.14.i.1 ]
  %foritems.idx.40.0123.i.unr = phi i64 [ 0, %foritems.body.13.i.preheader ], [ %t60.i.1, %foritems.step.14.i.1 ]
  %var.total.33.0122.i.unr = phi i64 [ 0, %foritems.body.13.i.preheader ], [ %var.total.33.1.i.1, %foritems.step.14.i.1 ]
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %d_elem.i.i.preheader, label %foritems.body.13.i.epil

foritems.body.13.i.epil:                          ; preds = %d_elem.i.i.preheader.unr-lcssa
  %t49.i.epil = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.pre.i, i64 %foritems.idx.40.0123.i.unr
  %t50.unpack.i.epil = load i64, ptr %t49.i.epil, align 8
  %t54.i.epil = and i64 %t50.unpack.i.epil, 4294967295
  %t55.i.epil = icmp samesign ugt i64 %t54.i.epil, 2
  br i1 %t55.i.epil, label %if.then.16.i.epil, label %d_elem.i.i.preheader

if.then.16.i.epil:                                ; preds = %foritems.body.13.i.epil
  %t48.i.epil = load ptr, ptr %t17.i, align 16
  %t51.i.epil = getelementptr inbounds nuw i64, ptr %t48.i.epil, i64 %foritems.idx.40.0123.i.unr
  %t52.i.epil = load i64, ptr %t51.i.epil, align 8
  %t57.i.epil = mul i64 %t52.i.epil, 10
  %t58.i.epil = add i64 %t57.i.epil, %var.total.33.0122.i.unr
  br label %d_elem.i.i.preheader

d_elem.i.i.preheader:                             ; preds = %foritems.body.13.i.epil, %if.then.16.i.epil, %d_elem.i.i.preheader.unr-lcssa
  %var.total.33.1.i.lcssa = phi i64 [ %var.total.33.1.i.lcssa.ph, %d_elem.i.i.preheader.unr-lcssa ], [ %t58.i.epil, %if.then.16.i.epil ], [ %var.total.33.0122.i.unr, %foritems.body.13.i.epil ]
  br label %d_elem.i.i

d_elem.i.i:                                       ; preds = %d_elem.i.i.preheader, %archx_str_drop.exit.i.i
  %storemerge5.i.i = phi i64 [ %inext.i.i, %archx_str_drop.exit.i.i ], [ 0, %d_elem.i.i.preheader ]
  %t0.i.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.pre.i, i64 %storemerge5.i.i
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
  %raw.i.i96.i = and i64 %t1.unpack2.i.i, -2
  %ptr.i.i.i = inttoptr i64 %raw.i.i96.i to ptr
  call void @free(ptr %ptr.i.i.i)
  br label %archx_str_drop.exit.i.i

archx_str_drop.exit.i.i:                          ; preds = %do_free.i.i.i, %d_elem.i.i
  %inext.i.i = add nuw nsw i64 %storemerge5.i.i, 1
  %exitcond.not.i.i = icmp eq i64 %inext.i.i, %t38.i
  br i1 %exitcond.not.i.i, label %archx_dict_drop_s_i.exit.i, label %d_elem.i.i

archx_dict_drop_s_i.exit.i:                       ; preds = %archx_str_drop.exit.i.i, %dlen.load.10.i
  %var.total.33.0.lcssa134.i = phi i64 [ 0, %dlen.load.10.i ], [ %var.total.33.1.i.lcssa, %archx_str_drop.exit.i.i ]
  %t64.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i.i = icmp eq ptr %t64.i, null
  br i1 %empty.i.i, label %alloc.ok.2, label %loop.i.i

loop.i.i:                                         ; preds = %archx_dict_drop_s_i.exit.i, %loop.i.i
  %cur.i.i = phi ptr [ %next.i.i, %loop.i.i ], [ %t64.i, %archx_dict_drop_s_i.exit.i ]
  %next.i.i = load ptr, ptr %cur.i.i, align 8
  call void @free(ptr nonnull %cur.i.i)
  %more.not.i.i = icmp eq ptr %next.i.i, null
  br i1 %more.not.i.i, label %alloc.ok.2, label %loop.i.i

alloc.ok.2:                                       ; preds = %loop.i.i, %archx_dict_drop_s_i.exit.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 13, ptr nonnull @.str.0)
  %t18 = call i32 @putchar(i32 32)
  %t19 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %var.total.33.0.lcssa134.i)
  %t20 = call i32 @putchar(i32 10)
  %hp.i = call noalias align 16 dereferenceable_or_null(64) ptr @calloc(i64 1, i64 64)
  %hnull.i = icmp eq ptr %hp.i, null
  br i1 %hnull.i, label %oom.i, label %archx_dict_new.exit

oom.i:                                            ; preds = %alloc.ok.2
  call fastcc void @archx_oom_fail()
  unreachable

archx_dict_new.exit:                              ; preds = %alloc.ok.2
  %h_meta_gep.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 56
  store i64 2048, ptr %h_meta_gep.i, align 8
  %hpi.i = ptrtoint ptr %hp.i to i64
  %htag.i = or disjoint i64 %hpi.i, 1
  call fastcc void @archx_dict_upsert_i64(i64 %htag.i, i64 42)
  call fastcc void @archx_dict_upsert_i64(i64 %htag.i, i64 7)
  call fastcc void @archx_dict_upsert_i64(i64 %htag.i, i64 42)
  call fastcc void @archx_dict_upsert_i64(i64 %htag.i, i64 19)
  call fastcc void @archx_dict_upsert_i64(i64 %htag.i, i64 7)
  call fastcc void @archx_dict_upsert_i64(i64 %htag.i, i64 99)
  call fastcc void @archx_dict_upsert_i64(i64 %htag.i, i64 105)
  %ctrl_p.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 32
  %ctrl.i = load ptr, ptr %ctrl_p.i, align 16
  %c_null.i = icmp eq ptr %ctrl.i, null
  br i1 %c_null.i, label %archx_dict_find_i64.exit, label %do_probe.i

do_probe.i:                                       ; preds = %archx_dict_new.exit
  %mask_p.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 16
  %keys_p.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 40
  %mask.i = load i64, ptr %mask_p.i, align 16
  %keys.i = load ptr, ptr %keys_p.i, align 8
  %3 = getelementptr i8, ptr %ctrl.i, i64 %mask.i
  %idx_base.i = getelementptr i8, ptr %3, i64 17
  br label %probe.i

probe.i:                                          ; preds = %next_grp.i, %do_probe.i
  %h.pn.i = phi i64 [ 1346066267577507604, %do_probe.i ], [ %padd.i, %next_grp.i ]
  %step.i = phi i64 [ 0, %do_probe.i ], [ %step_next.i, %next_grp.i ]
  %pos.i = and i64 %h.pn.i, %mask.i
  %gp.i = getelementptr inbounds i8, ptr %ctrl.i, i64 %pos.i
  %grp.i = load <16 x i8>, ptr %gp.i, align 1
  %mcmp.i = icmp eq <16 x i8> %grp.i, splat (i8 9)
  %mbits.i = bitcast <16 x i1> %mcmp.i to i16
  %has_m.not.i889 = icmp eq i16 %mbits.i, 0
  br i1 %has_m.not.i889, label %chk_empty.i, label %chk_key.i.preheader

chk_key.i.preheader:                              ; preds = %probe.i
  %mmask0.i = zext i16 %mbits.i to i32
  br label %chk_key.i

chk_key.i:                                        ; preds = %chk_key.i.preheader, %mbit_cont.i
  %mmask.i890 = phi i32 [ %mmask_next.i, %mbit_cont.i ], [ %mmask0.i, %chk_key.i.preheader ]
  %tz.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i890, i1 true)
  %tz64.i = zext nneg i32 %tz.i to i64
  %s_add.i = add i64 %pos.i, %tz64.i
  %slot.i = and i64 %s_add.i, %mask.i
  %ip.i = getelementptr inbounds i32, ptr %idx_base.i, i64 %slot.i
  %didx32.i = load i32, ptr %ip.i, align 4
  %didx.i = zext i32 %didx32.i to i64
  %kp.i = getelementptr inbounds nuw i64, ptr %keys.i, i64 %didx.i
  %cand_k.i = load i64, ptr %kp.i, align 8
  %eq.i = icmp eq i64 %cand_k.i, 7
  br i1 %eq.i, label %found.i, label %mbit_cont.i

mbit_cont.i:                                      ; preds = %chk_key.i
  %mm1.i = add nsw i32 %mmask.i890, -1
  %mmask_next.i = and i32 %mm1.i, %mmask.i890
  %has_m.not.i = icmp eq i32 %mmask_next.i, 0
  br i1 %has_m.not.i, label %chk_empty.i, label %chk_key.i

chk_empty.i:                                      ; preds = %mbit_cont.i, %probe.i
  %ecmp.i = icmp eq <16 x i8> %grp.i, splat (i8 -128)
  %ebits.i = bitcast <16 x i1> %ecmp.i to i16
  %has_e.not.i = icmp eq i16 %ebits.i, 0
  br i1 %has_e.not.i, label %next_grp.i, label %archx_dict_find_i64.exit

next_grp.i:                                       ; preds = %chk_empty.i
  %step_next.i = add i64 %step.i, 16
  %padd.i = add i64 %step_next.i, %pos.i
  br label %probe.i

found.i:                                          ; preds = %chk_key.i
  %f0.i = insertvalue { i64, i64 } poison, i64 %didx.i, 0
  %f1.i = insertvalue { i64, i64 } %f0.i, i64 %slot.i, 1
  br label %archx_dict_find_i64.exit

archx_dict_find_i64.exit:                         ; preds = %chk_empty.i, %archx_dict_new.exit, %found.i
  %common.ret.op.i = phi { i64, i64 } [ %f1.i, %found.i ], [ { i64 -1, i64 -1 }, %archx_dict_new.exit ], [ { i64 -1, i64 -1 }, %chk_empty.i ]
  %t50 = extractvalue { i64, i64 } %common.ret.op.i, 0
  %t52 = icmp sgt i64 %t50, -1
  %t62.pre924 = load i64, ptr %hp.i, align 16
  br i1 %t52, label %srem.hit.9, label %chk_ctrl.i.i

srem.hit.9:                                       ; preds = %archx_dict_find_i64.exit
  %t51 = extractvalue { i64, i64 } %common.ret.op.i, 1
  %mask_p.i421 = getelementptr inbounds nuw i8, ptr %hp.i, i64 16
  %keys_p.i423 = getelementptr inbounds nuw i8, ptr %hp.i, i64 40
  %vals_p.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 48
  %mask.i425 = load i64, ptr %mask_p.i421, align 16
  %keys.i427 = load ptr, ptr %keys_p.i423, align 8
  %vals.i = load ptr, ptr %vals_p.i, align 16
  %meta.i = load i64, ptr %h_meta_gep.i, align 8
  %4 = getelementptr i8, ptr %ctrl.i, i64 %mask.i425
  %idx_base.i428 = getelementptr i8, ptr %4, i64 17
  %sp_ip.i = getelementptr inbounds i32, ptr %idx_base.i428, i64 %t51
  %d_idx32.i = load i32, ptr %sp_ip.i, align 4
  %d_idx.i = zext i32 %d_idx32.i to i64
  %p.i.i = getelementptr inbounds i8, ptr %ctrl.i, i64 %t51
  store i8 -2, ptr %p.i.i, align 1
  %mir.i.i = icmp ult i64 %t51, 16
  br i1 %mir.i.i, label %do_mir.i.i, label %archx_dict_set_ctrl.exit.i

do_mir.i.i:                                       ; preds = %srem.hit.9
  %5 = getelementptr i8, ptr %4, i64 1
  %mp.i.i = getelementptr i8, ptr %5, i64 %t51
  store i8 -2, ptr %mp.i.i, align 1
  br label %archx_dict_set_ctrl.exit.i

archx_dict_set_ctrl.exit.i:                       ; preds = %do_mir.i.i, %srem.hit.9
  %last.i = add i64 %t62.pre924, -1
  store i64 %last.i, ptr %hp.i, align 16
  %need_swap.i = icmp sgt i64 %last.i, %d_idx.i
  br i1 %need_swap.i, label %do_swap.i, label %chk_ctrl.i.i

do_swap.i:                                        ; preds = %archx_dict_set_ctrl.exit.i
  %kind.i = and i64 %meta.i, 255
  %ksz_sh.i = lshr i64 %meta.i, 8
  %ksz.i = and i64 %ksz_sh.i, 16777215
  %kd_off.i = mul nuw nsw i64 %ksz.i, %d_idx.i
  %kl_off.i = mul i64 %ksz.i, %last.i
  %kd_p.i = getelementptr inbounds nuw i8, ptr %keys.i427, i64 %kd_off.i
  %kl_p.i = getelementptr inbounds i8, ptr %keys.i427, i64 %kl_off.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %kd_p.i, ptr nonnull align 1 %kl_p.i, i64 %ksz.i, i1 false)
  %has_v.not.i = icmp ult i64 %meta.i, 4294967296
  br i1 %has_v.not.i, label %fix_sparse.i, label %swap_v.i

swap_v.i:                                         ; preds = %do_swap.i
  %vsz.i = lshr i64 %meta.i, 32
  %vd_off.i = mul nuw i64 %vsz.i, %d_idx.i
  %vl_off.i = mul i64 %vsz.i, %last.i
  %vd_p.i = getelementptr inbounds i8, ptr %vals.i, i64 %vd_off.i
  %vl_p.i = getelementptr inbounds i8, ptr %vals.i, i64 %vl_off.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %vd_p.i, ptr nonnull align 1 %vl_p.i, i64 %vsz.i, i1 false)
  br label %fix_sparse.i

fix_sparse.i:                                     ; preds = %swap_v.i, %do_swap.i
  %h.i = call fastcc i64 @archx_dict_key_hash_at(ptr %keys.i427, i64 %d_idx.i, i64 %kind.i)
  %h2_64.i = lshr i64 %h.i, 57
  %h2.i = trunc nuw nsw i64 %h2_64.i to i8
  %h2_ins.i = insertelement <16 x i8> poison, i8 %h2.i, i64 0
  %h2_vec.i = shufflevector <16 x i8> %h2_ins.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %last32.i = trunc i64 %last.i to i32
  br label %fprobe.i

fprobe.i:                                         ; preds = %fnext_grp.i, %fix_sparse.i
  %h.pn.i429 = phi i64 [ %h.i, %fix_sparse.i ], [ %padd.i444, %fnext_grp.i ]
  %step.i430 = phi i64 [ 0, %fix_sparse.i ], [ %step_next.i443, %fnext_grp.i ]
  %pos.i431 = and i64 %h.pn.i429, %mask.i425
  %gp.i432 = getelementptr inbounds i8, ptr %ctrl.i, i64 %pos.i431
  %grp.i433 = load <16 x i8>, ptr %gp.i432, align 1
  %mcmp.i434 = icmp eq <16 x i8> %grp.i433, %h2_vec.i
  %mbits.i435 = bitcast <16 x i1> %mcmp.i434 to i16
  %has_m.not1.i = icmp eq i16 %mbits.i435, 0
  br i1 %has_m.not1.i, label %fnext_grp.i, label %fchk.preheader.i

fchk.preheader.i:                                 ; preds = %fprobe.i
  %mmask0.i436 = zext i16 %mbits.i435 to i32
  br label %fchk.i

fchk.i:                                           ; preds = %fbit_cont.i, %fchk.preheader.i
  %mmask2.i = phi i32 [ %mmask_next.i441, %fbit_cont.i ], [ %mmask0.i436, %fchk.preheader.i ]
  %tz.i437 = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask2.i, i1 true)
  %tz64.i438 = zext nneg i32 %tz.i437 to i64
  %s_add.i439 = add i64 %pos.i431, %tz64.i438
  %cand.i = and i64 %s_add.i439, %mask.i425
  %cip.i = getelementptr inbounds i32, ptr %idx_base.i428, i64 %cand.i
  %cv.i = load i32, ptr %cip.i, align 4
  %hit.i = icmp eq i32 %cv.i, %last32.i
  br i1 %hit.i, label %fupdate.i, label %fbit_cont.i

fbit_cont.i:                                      ; preds = %fchk.i
  %mm1.i440 = add nsw i32 %mmask2.i, -1
  %mmask_next.i441 = and i32 %mm1.i440, %mmask2.i
  %has_m.not.i442 = icmp eq i32 %mmask_next.i441, 0
  br i1 %has_m.not.i442, label %fnext_grp.i, label %fchk.i

fnext_grp.i:                                      ; preds = %fbit_cont.i, %fprobe.i
  %step_next.i443 = add i64 %step.i430, 16
  %padd.i444 = add i64 %step_next.i443, %pos.i431
  br label %fprobe.i

fupdate.i:                                        ; preds = %fchk.i
  %cip.i.le = getelementptr inbounds i32, ptr %idx_base.i428, i64 %cand.i
  store i32 %d_idx32.i, ptr %cip.i.le, align 4
  %t62.pre = load i64, ptr %hp.i, align 16
  br label %chk_ctrl.i.i

chk_ctrl.i.i:                                     ; preds = %archx_dict_find_i64.exit, %archx_dict_set_ctrl.exit.i, %fupdate.i
  %t62 = phi i64 [ %t62.pre924, %archx_dict_find_i64.exit ], [ %last.i, %archx_dict_set_ctrl.exit.i ], [ %t62.pre, %fupdate.i ]
  %ctrl.i.i = load ptr, ptr %ctrl_p.i, align 16
  %c_null.i.i = icmp eq ptr %ctrl.i.i, null
  br i1 %c_null.i.i, label %fast_printf.i455, label %do_probe.i.i

do_probe.i.i:                                     ; preds = %chk_ctrl.i.i
  %mask_p.i.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 16
  %keys_p.i.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 40
  %mask.i.i = load i64, ptr %mask_p.i.i, align 16
  %keys.i.i = load ptr, ptr %keys_p.i.i, align 8
  %6 = getelementptr i8, ptr %ctrl.i.i, i64 %mask.i.i
  %idx_base.i.i = getelementptr i8, ptr %6, i64 17
  br label %probe.i.i

probe.i.i:                                        ; preds = %next_grp.i.i, %do_probe.i.i
  %h.pn.i.i = phi i64 [ -6387817139659442654, %do_probe.i.i ], [ %padd.i.i, %next_grp.i.i ]
  %step.i.i = phi i64 [ 0, %do_probe.i.i ], [ %step_next.i.i, %next_grp.i.i ]
  %pos.i.i = and i64 %h.pn.i.i, %mask.i.i
  %gp.i.i = getelementptr inbounds i8, ptr %ctrl.i.i, i64 %pos.i.i
  %grp.i.i = load <16 x i8>, ptr %gp.i.i, align 1
  %mcmp.i.i = icmp eq <16 x i8> %grp.i.i, splat (i8 83)
  %mbits.i.i = bitcast <16 x i1> %mcmp.i.i to i16
  %has_m.not.i.i891 = icmp eq i16 %mbits.i.i, 0
  br i1 %has_m.not.i.i891, label %chk_empty.i.i, label %chk_key.i.i.preheader

chk_key.i.i.preheader:                            ; preds = %probe.i.i
  %mmask0.i.i = zext i16 %mbits.i.i to i32
  br label %chk_key.i.i

chk_key.i.i:                                      ; preds = %chk_key.i.i.preheader, %mbit_cont.i.i
  %mmask.i.i892 = phi i32 [ %mmask_next.i.i, %mbit_cont.i.i ], [ %mmask0.i.i, %chk_key.i.i.preheader ]
  %tz.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i892, i1 true)
  %tz64.i.i = zext nneg i32 %tz.i.i to i64
  %s_add.i.i = add i64 %pos.i.i, %tz64.i.i
  %slot.i.i = and i64 %s_add.i.i, %mask.i.i
  %ip.i.i = getelementptr inbounds i32, ptr %idx_base.i.i, i64 %slot.i.i
  %didx32.i.i = load i32, ptr %ip.i.i, align 4
  %didx.i.i = zext i32 %didx32.i.i to i64
  %kp.i.i = getelementptr inbounds nuw i64, ptr %keys.i.i, i64 %didx.i.i
  %cand_k.i.i = load i64, ptr %kp.i.i, align 8
  %eq.i.i = icmp eq i64 %cand_k.i.i, 42
  br i1 %eq.i.i, label %fast_printf.i455, label %mbit_cont.i.i

mbit_cont.i.i:                                    ; preds = %chk_key.i.i
  %mm1.i.i = add nsw i32 %mmask.i.i892, -1
  %mmask_next.i.i = and i32 %mm1.i.i, %mmask.i.i892
  %has_m.not.i.i = icmp eq i32 %mmask_next.i.i, 0
  br i1 %has_m.not.i.i, label %chk_empty.i.i, label %chk_key.i.i

chk_empty.i.i:                                    ; preds = %mbit_cont.i.i, %probe.i.i
  %ecmp.i.i = icmp eq <16 x i8> %grp.i.i, splat (i8 -128)
  %ebits.i.i = bitcast <16 x i1> %ecmp.i.i to i16
  %has_e.not.i.i = icmp eq i16 %ebits.i.i, 0
  br i1 %has_e.not.i.i, label %next_grp.i.i, label %fast_printf.i455

next_grp.i.i:                                     ; preds = %chk_empty.i.i
  %step_next.i.i = add i64 %step.i.i, 16
  %padd.i.i = add i64 %step_next.i.i, %pos.i.i
  br label %probe.i.i

fast_printf.i455:                                 ; preds = %chk_empty.i.i, %chk_key.i.i, %chk_ctrl.i.i
  %common.ret.op.i.i = phi ptr [ @.str.false, %chk_ctrl.i.i ], [ @.str.true, %chk_key.i.i ], [ @.str.false, %chk_empty.i.i ]
  %np.i456 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 13, ptr nonnull @.str.1)
  %t67 = call i32 @putchar(i32 32)
  %t68 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t62)
  %t69 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  store i32 544432488, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 3813940, ptr %tmp4.i, align 4
  %nul.i458 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i, i32 0, i64 7)
  %has_nul.not.i459 = icmp eq ptr %nul.i458, null
  br i1 %has_nul.not.i459, label %fast_printf.i468, label %byte_loop.i460.preheader

byte_loop.i460.preheader:                         ; preds = %fast_printf.i455
  %pc.i465 = call i32 @putchar(i32 104)
  %bp.i462.1 = getelementptr inbounds nuw i8, ptr %tmp.i, i64 1
  %ch8.i463.1 = load i8, ptr %bp.i462.1, align 1
  %ch32.i464.1 = zext i8 %ch8.i463.1 to i32
  %pc.i465.1 = call i32 @putchar(i32 %ch32.i464.1)
  %bp.i462.2 = getelementptr inbounds nuw i8, ptr %tmp.i, i64 2
  %ch8.i463.2 = load i8, ptr %bp.i462.2, align 2
  %ch32.i464.2 = zext i8 %ch8.i463.2 to i32
  %pc.i465.2 = call i32 @putchar(i32 %ch32.i464.2)
  %bp.i462.3 = getelementptr inbounds nuw i8, ptr %tmp.i, i64 3
  %ch8.i463.3 = load i8, ptr %bp.i462.3, align 1
  %ch32.i464.3 = zext i8 %ch8.i463.3 to i32
  %pc.i465.3 = call i32 @putchar(i32 %ch32.i464.3)
  %ch8.i463.4 = load i8, ptr %tmp4.i, align 4
  %ch32.i464.4 = zext i8 %ch8.i463.4 to i32
  %pc.i465.4 = call i32 @putchar(i32 %ch32.i464.4)
  %bp.i462.5 = getelementptr inbounds nuw i8, ptr %tmp.i, i64 5
  %ch8.i463.5 = load i8, ptr %bp.i462.5, align 1
  %ch32.i464.5 = zext i8 %ch8.i463.5 to i32
  %pc.i465.5 = call i32 @putchar(i32 %ch32.i464.5)
  %bp.i462.6 = getelementptr inbounds nuw i8, ptr %tmp.i, i64 6
  %ch8.i463.6 = load i8, ptr %bp.i462.6, align 2
  %ch32.i464.6 = zext i8 %ch8.i463.6 to i32
  %pc.i465.6 = call i32 @putchar(i32 %ch32.i464.6)
  br label %archx_str_print.exit470

fast_printf.i468:                                 ; preds = %fast_printf.i455
  %np.i469 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 7, ptr nonnull %tmp.i)
  br label %archx_str_print.exit470

archx_str_print.exit470:                          ; preds = %byte_loop.i460.preheader, %fast_printf.i468
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %t70 = call i32 @putchar(i32 32)
  %t72 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.str.elem, ptr nonnull %common.ret.op.i.i)
  %t73 = call i32 @putchar(i32 10)
  %t74 = call noalias align 16 dereferenceable_or_null(48) ptr @malloc(i64 48)
  %t75 = icmp eq ptr %t74, null
  br i1 %t75, label %alloc.oom.16, label %mul.ok.18

alloc.oom.16:                                     ; preds = %archx_str_print.exit470
  call fastcc void @archx_oom_fail()
  unreachable

mul.ok.18:                                        ; preds = %archx_str_print.exit470
  store i64 10, ptr %t74, align 16
  %t77 = getelementptr inbounds nuw i8, ptr %t74, i64 8
  store i64 20, ptr %t77, align 8
  %t78 = getelementptr inbounds nuw i8, ptr %t74, i64 16
  store i64 30, ptr %t78, align 16
  %t79 = getelementptr inbounds nuw i8, ptr %t74, i64 24
  store i64 40, ptr %t79, align 8
  %t80 = getelementptr inbounds nuw i8, ptr %t74, i64 32
  store i64 50, ptr %t80, align 16
  %t81 = getelementptr inbounds nuw i8, ptr %t74, i64 40
  store i64 60, ptr %t81, align 8
  %t99 = call noalias align 16 dereferenceable_or_null(32) ptr @malloc(i64 32)
  %t100 = icmp eq ptr %t99, null
  br i1 %t100, label %alloc.oom.20, label %print.elem.41.2

alloc.oom.20:                                     ; preds = %mul.ok.18
  call fastcc void @archx_oom_fail()
  unreachable

print.elem.41.2:                                  ; preds = %mul.ok.18
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(32) %t99, ptr noundef nonnull align 8 dereferenceable(32) %t77, i64 32, i1 false)
  %np.i483 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 13, ptr nonnull @.str.2)
  %t108 = call i32 @putchar(i32 32)
  %putchar = call i32 @putchar(i32 91)
  %t118 = load i64, ptr %t99, align 16
  %t119 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t118)
  %t116.1 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t117.1 = getelementptr inbounds nuw i8, ptr %t99, i64 8
  %t118.1 = load i64, ptr %t117.1, align 8
  %t119.1 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t118.1)
  %t116.2 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t117.2 = getelementptr inbounds nuw i8, ptr %t99, i64 16
  %t118.2 = load i64, ptr %t117.2, align 16
  %t119.2 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t118.2)
  %t116.3 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t117.3 = getelementptr inbounds nuw i8, ptr %t99, i64 24
  %t118.3 = load i64, ptr %t117.3, align 8
  %t119.3 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t118.3)
  %putchar37 = call i32 @putchar(i32 93)
  %t122 = call i32 @putchar(i32 10)
  call void @free(ptr nonnull %t99)
  %np.i497 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 14, ptr nonnull @.str.3)
  %t158 = call i32 @putchar(i32 32)
  %putchar38 = call i32 @putchar(i32 91)
  %t169 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 60)
  %t166.1 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t169.1 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 40)
  %t166.2 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t169.2 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 20)
  %putchar39 = call i32 @putchar(i32 93)
  %t172 = call i32 @putchar(i32 10)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i500)
  %sso.i.i500.8.sroa_idx1013 = getelementptr inbounds nuw i8, ptr %sso.i.i500, i64 8
  store i64 0, ptr %sso.i.i500.8.sroa_idx1013, align 8
  store i32 6, ptr %sso.i.i500, align 8
  %sso.i.i500.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i500, i64 4
  store i48 52975052402806, ptr %sso.i.i500.4.sroa_idx, align 4
  %sso.i.i500.0.sso.i.i500.0.sso.i.i500.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i506 = load i64, ptr %sso.i.i500, align 8
  %sso.i.i500.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i500, i64 8
  %sso.i.i500.8.sso.i.i500.8.sso.i.i500.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i508 = load i64, ptr %sso.i.i500.8.sroa_idx, align 8
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i500)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i511)
  store i32 1717924464, ptr %tmp.i511, align 4
  %tmp4.i512 = getelementptr inbounds nuw i8, ptr %tmp.i511, i64 4
  store i64 3831913, ptr %tmp4.i512, align 4
  %nul.i513 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i511, i32 0, i64 7)
  %has_nul.not.i514 = icmp eq ptr %nul.i513, null
  br i1 %has_nul.not.i514, label %fast_printf.i523, label %byte_loop.i515.preheader

byte_loop.i515.preheader:                         ; preds = %print.elem.41.2
  %pc.i520 = call i32 @putchar(i32 112)
  %bp.i517.1 = getelementptr inbounds nuw i8, ptr %tmp.i511, i64 1
  %ch8.i518.1 = load i8, ptr %bp.i517.1, align 1
  %ch32.i519.1 = zext i8 %ch8.i518.1 to i32
  %pc.i520.1 = call i32 @putchar(i32 %ch32.i519.1)
  %bp.i517.2 = getelementptr inbounds nuw i8, ptr %tmp.i511, i64 2
  %ch8.i518.2 = load i8, ptr %bp.i517.2, align 2
  %ch32.i519.2 = zext i8 %ch8.i518.2 to i32
  %pc.i520.2 = call i32 @putchar(i32 %ch32.i519.2)
  %bp.i517.3 = getelementptr inbounds nuw i8, ptr %tmp.i511, i64 3
  %ch8.i518.3 = load i8, ptr %bp.i517.3, align 1
  %ch32.i519.3 = zext i8 %ch8.i518.3 to i32
  %pc.i520.3 = call i32 @putchar(i32 %ch32.i519.3)
  %ch8.i518.4 = load i8, ptr %tmp4.i512, align 4
  %ch32.i519.4 = zext i8 %ch8.i518.4 to i32
  %pc.i520.4 = call i32 @putchar(i32 %ch32.i519.4)
  %bp.i517.5 = getelementptr inbounds nuw i8, ptr %tmp.i511, i64 5
  %ch8.i518.5 = load i8, ptr %bp.i517.5, align 1
  %ch32.i519.5 = zext i8 %ch8.i518.5 to i32
  %pc.i520.5 = call i32 @putchar(i32 %ch32.i519.5)
  %bp.i517.6 = getelementptr inbounds nuw i8, ptr %tmp.i511, i64 6
  %ch8.i518.6 = load i8, ptr %bp.i517.6, align 2
  %ch32.i519.6 = zext i8 %ch8.i518.6 to i32
  %pc.i520.6 = call i32 @putchar(i32 %ch32.i519.6)
  br label %chk_nul.i

fast_printf.i523:                                 ; preds = %print.elem.41.2
  %np.i524 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 7, ptr nonnull %tmp.i511)
  br label %chk_nul.i

chk_nul.i:                                        ; preds = %byte_loop.i515.preheader, %fast_printf.i523
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i511)
  %t179 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i526)
  store i32 1751347777, ptr %tmp.i526, align 4
  %tmp4.i543 = getelementptr inbounds nuw i8, ptr %tmp.i526, i64 4
  store i64 120, ptr %tmp4.i543, align 4
  %nul.i531 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i526, i32 0, i64 5)
  %has_nul.not.i532 = icmp eq ptr %nul.i531, null
  br i1 %has_nul.not.i532, label %fast_printf.i541, label %byte_loop.i533.preheader

byte_loop.i533.preheader:                         ; preds = %chk_nul.i
  %pc.i538 = call i32 @putchar(i32 65)
  %bp.i535.1 = getelementptr inbounds nuw i8, ptr %tmp.i526, i64 1
  %ch8.i536.1 = load i8, ptr %bp.i535.1, align 1
  %ch32.i537.1 = zext i8 %ch8.i536.1 to i32
  %pc.i538.1 = call i32 @putchar(i32 %ch32.i537.1)
  %bp.i535.2 = getelementptr inbounds nuw i8, ptr %tmp.i526, i64 2
  %ch8.i536.2 = load i8, ptr %bp.i535.2, align 2
  %ch32.i537.2 = zext i8 %ch8.i536.2 to i32
  %pc.i538.2 = call i32 @putchar(i32 %ch32.i537.2)
  %bp.i535.3 = getelementptr inbounds nuw i8, ptr %tmp.i526, i64 3
  %ch8.i536.3 = load i8, ptr %bp.i535.3, align 1
  %ch32.i537.3 = zext i8 %ch8.i536.3 to i32
  %pc.i538.3 = call i32 @putchar(i32 %ch32.i537.3)
  %ch8.i536.4 = load i8, ptr %tmp4.i543, align 4
  %ch32.i537.4 = zext i8 %ch8.i536.4 to i32
  %pc.i538.4 = call i32 @putchar(i32 %ch32.i537.4)
  br label %archx_str_print.exit544

fast_printf.i541:                                 ; preds = %chk_nul.i
  %np.i542 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 5, ptr nonnull %tmp.i526)
  br label %archx_str_print.exit544

archx_str_print.exit544:                          ; preds = %byte_loop.i533.preheader, %fast_printf.i541
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i526)
  %t180 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i545)
  store i32 1936876918, ptr %tmp.i545, align 4
  %tmp4.i547 = getelementptr inbounds nuw i8, ptr %tmp.i545, i64 4
  store i64 980316009, ptr %tmp4.i547, align 4
  %nul.i550 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i545, i32 0, i64 8)
  %has_nul.not.i551 = icmp eq ptr %nul.i550, null
  br i1 %has_nul.not.i551, label %fast_printf.i560, label %byte_loop.i552.preheader

byte_loop.i552.preheader:                         ; preds = %archx_str_print.exit544
  %pc.i557 = call i32 @putchar(i32 118)
  %bp.i554.1 = getelementptr inbounds nuw i8, ptr %tmp.i545, i64 1
  %ch8.i555.1 = load i8, ptr %bp.i554.1, align 1
  %ch32.i556.1 = zext i8 %ch8.i555.1 to i32
  %pc.i557.1 = call i32 @putchar(i32 %ch32.i556.1)
  %bp.i554.2 = getelementptr inbounds nuw i8, ptr %tmp.i545, i64 2
  %ch8.i555.2 = load i8, ptr %bp.i554.2, align 2
  %ch32.i556.2 = zext i8 %ch8.i555.2 to i32
  %pc.i557.2 = call i32 @putchar(i32 %ch32.i556.2)
  %bp.i554.3 = getelementptr inbounds nuw i8, ptr %tmp.i545, i64 3
  %ch8.i555.3 = load i8, ptr %bp.i554.3, align 1
  %ch32.i556.3 = zext i8 %ch8.i555.3 to i32
  %pc.i557.3 = call i32 @putchar(i32 %ch32.i556.3)
  %ch8.i555.4 = load i8, ptr %tmp4.i547, align 4
  %ch32.i556.4 = zext i8 %ch8.i555.4 to i32
  %pc.i557.4 = call i32 @putchar(i32 %ch32.i556.4)
  %bp.i554.5 = getelementptr inbounds nuw i8, ptr %tmp.i545, i64 5
  %ch8.i555.5 = load i8, ptr %bp.i554.5, align 1
  %ch32.i556.5 = zext i8 %ch8.i555.5 to i32
  %pc.i557.5 = call i32 @putchar(i32 %ch32.i556.5)
  %bp.i554.6 = getelementptr inbounds nuw i8, ptr %tmp.i545, i64 6
  %ch8.i555.6 = load i8, ptr %bp.i554.6, align 2
  %ch32.i556.6 = zext i8 %ch8.i555.6 to i32
  %pc.i557.6 = call i32 @putchar(i32 %ch32.i556.6)
  %bp.i554.7 = getelementptr inbounds nuw i8, ptr %tmp.i545, i64 7
  %ch8.i555.7 = load i8, ptr %bp.i554.7, align 1
  %ch32.i556.7 = zext i8 %ch8.i555.7 to i32
  %pc.i557.7 = call i32 @putchar(i32 %ch32.i556.7)
  br label %archx_str_print.exit562

fast_printf.i560:                                 ; preds = %archx_str_print.exit544
  %np.i561 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 8, ptr nonnull %tmp.i545)
  br label %archx_str_print.exit562

archx_str_print.exit562:                          ; preds = %byte_loop.i552.preheader, %fast_printf.i560
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i545)
  %t181 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i563)
  %len.i566 = and i64 %sso.i.i500.0.sso.i.i500.0.sso.i.i500.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i506, 4294967295
  %short.i567 = icmp samesign ult i64 %len.i566, 13
  br i1 %short.i567, label %emit.i586, label %emit.thread.i568

emit.thread.i568:                                 ; preds = %archx_str_print.exit562
  %raw.i569 = and i64 %sso.i.i500.8.sso.i.i500.8.sso.i.i500.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i508, -4
  %lptr.i570 = inttoptr i64 %raw.i569 to ptr
  br label %chk_nul.i571

emit.i586:                                        ; preds = %archx_str_print.exit562
  %p4.i587 = lshr i64 %sso.i.i500.0.sso.i.i500.0.sso.i.i500.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i506, 32
  %p4_32.i588 = trunc nuw i64 %p4.i587 to i32
  store i32 %p4_32.i588, ptr %tmp.i563, align 4
  %tmp4.i589 = getelementptr inbounds nuw i8, ptr %tmp.i563, i64 4
  store i64 %sso.i.i500.8.sso.i.i500.8.sso.i.i500.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i508, ptr %tmp4.i589, align 4
  %pos.not.i590 = icmp eq i64 %len.i566, 0
  br i1 %pos.not.i590, label %archx_str_print.exit591.thread, label %chk_nul.i571

archx_str_print.exit591.thread:                   ; preds = %emit.i586
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i563)
  %t182868 = call i32 @putchar(i32 10)
  br label %archx_str_drop.exit126

chk_nul.i571:                                     ; preds = %emit.i586, %emit.thread.i568
  %data3.i572 = phi ptr [ %lptr.i570, %emit.thread.i568 ], [ %tmp.i563, %emit.i586 ]
  %nul.i573 = call ptr @memchr(ptr nonnull %data3.i572, i32 0, i64 %len.i566)
  %has_nul.not.i574 = icmp eq ptr %nul.i573, null
  br i1 %has_nul.not.i574, label %fast_printf.i583, label %byte_loop.i575

fast_printf.i583:                                 ; preds = %chk_nul.i571
  %len32.i584 = trunc i64 %sso.i.i500.0.sso.i.i500.0.sso.i.i500.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i506 to i32
  %np.i585 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 %len32.i584, ptr nonnull %data3.i572)
  br label %archx_str_print.exit591

byte_loop.i575:                                   ; preds = %chk_nul.i571, %byte_loop.i575
  %bi.i576 = phi i64 [ %bnext.i581, %byte_loop.i575 ], [ 0, %chk_nul.i571 ]
  %bp.i577 = getelementptr inbounds nuw i8, ptr %data3.i572, i64 %bi.i576
  %ch8.i578 = load i8, ptr %bp.i577, align 1
  %ch32.i579 = zext i8 %ch8.i578 to i32
  %pc.i580 = call i32 @putchar(i32 %ch32.i579)
  %bnext.i581 = add nuw nsw i64 %bi.i576, 1
  %exitcond.not.i582 = icmp eq i64 %bnext.i581, %len.i566
  br i1 %exitcond.not.i582, label %archx_str_print.exit591, label %byte_loop.i575

archx_str_print.exit591:                          ; preds = %byte_loop.i575, %fast_printf.i583
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i563)
  %t182 = call i32 @putchar(i32 10)
  %tag.i = and i64 %sso.i.i500.8.sso.i.i500.8.sso.i.i500.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i508, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %short.i567, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %archx_str_drop.exit126, label %do_free.i

do_free.i:                                        ; preds = %archx_str_print.exit591
  %raw.i = and i64 %sso.i.i500.8.sso.i.i500.8.sso.i.i500.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i508, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  call void @free(ptr %ptr.i)
  br label %archx_str_drop.exit126

archx_str_drop.exit126:                           ; preds = %do_free.i, %archx_str_print.exit591, %archx_str_print.exit591.thread
  %t192 = call noalias align 16 dereferenceable_or_null(72) ptr @malloc(i64 72)
  %t193 = icmp eq ptr %t192, null
  br i1 %t193, label %alloc.oom.46, label %alloc.ok.45

alloc.oom.46:                                     ; preds = %archx_str_drop.exit126
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.45:                                      ; preds = %archx_str_drop.exit126
  store i64 4, ptr %t192, align 16
  %t192.repack40 = getelementptr inbounds nuw i8, ptr %t192, i64 8
  store i64 7521981426137300997, ptr %t192.repack40, align 8
  %t192.repack41 = getelementptr inbounds nuw i8, ptr %t192, i64 16
  store i64 120, ptr %t192.repack41, align 16
  %t195 = getelementptr inbounds nuw i8, ptr %t192, i64 24
  store i64 2, ptr %t195, align 8
  %t195.repack42 = getelementptr inbounds nuw i8, ptr %t192, i64 32
  store i64 18, ptr %t195.repack42, align 16
  %t195.repack43 = getelementptr inbounds nuw i8, ptr %t192, i64 40
  store i64 0, ptr %t195.repack43, align 8
  %t196 = getelementptr inbounds nuw i8, ptr %t192, i64 48
  store i64 4, ptr %t196, align 16
  %t196.repack44 = getelementptr inbounds nuw i8, ptr %t192, i64 56
  store i64 7018690058811080709, ptr %t196.repack44, align 8
  %t196.repack45 = getelementptr inbounds nuw i8, ptr %t192, i64 64
  store i64 108, ptr %t196.repack45, align 16
  %hp.i592 = call noalias align 16 dereferenceable_or_null(64) ptr @calloc(i64 1, i64 64)
  %hnull.i593 = icmp eq ptr %hp.i592, null
  br i1 %hnull.i593, label %oom.i598, label %archx_dict_new.exit599

oom.i598:                                         ; preds = %alloc.ok.45
  call fastcc void @archx_oom_fail()
  unreachable

archx_dict_new.exit599:                           ; preds = %alloc.ok.45
  %h_meta_gep.i594 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 56
  store i64 103079219201, ptr %h_meta_gep.i594, align 8
  %hpi.i595 = ptrtoint ptr %hp.i592 to i64
  %htag.i596 = or disjoint i64 %hpi.i595, 1
  %t201 = call noalias align 16 dereferenceable_or_null(24) ptr @malloc(i64 24)
  %t202 = icmp eq ptr %t201, null
  br i1 %t202, label %alloc.oom.48, label %alloc.ok.47

alloc.oom.48:                                     ; preds = %archx_dict_new.exit599
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.47:                                      ; preds = %archx_dict_new.exit599
  store i64 3, ptr %t201, align 16
  %t201.repack46 = getelementptr inbounds nuw i8, ptr %t201, i64 8
  store i64 3, ptr %t201.repack46, align 8
  %t201.repack48 = getelementptr inbounds nuw i8, ptr %t201, i64 16
  store ptr %t192, ptr %t201.repack48, align 16
  %t203 = ptrtoint ptr %t201 to i64
  %t204 = or disjoint i64 %t203, 1
  %t206 = call fastcc { i64, i1 } @archx_dict_upsert_str(i64 %htag.i596, %ArchxStr { i64 7022344801102069764, i64 0 })
  %t207 = extractvalue { i64, i1 } %t206, 0
  %t208 = extractvalue { i64, i1 } %t206, 1
  %t211 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 48
  %t212 = load ptr, ptr %t211, align 16
  %t213 = getelementptr inbounds %ArchxAny, ptr %t212, i64 %t207
  br i1 %t208, label %dlit.dropold.49, label %dlit.store.50

dlit.dropold.49:                                  ; preds = %alloc.ok.47
  %t214.unpack = load i64, ptr %t213, align 8
  %7 = insertvalue %ArchxAny poison, i64 %t214.unpack, 0
  %t214.elt50 = getelementptr inbounds nuw i8, ptr %t213, i64 8
  %t214.unpack51 = load i64, ptr %t214.elt50, align 8
  %8 = insertvalue %ArchxAny %7, i64 %t214.unpack51, 1
  %t214.elt52 = getelementptr inbounds nuw i8, ptr %t213, i64 16
  %t214.unpack53 = load i64, ptr %t214.elt52, align 8
  %t21454 = insertvalue %ArchxAny %8, i64 %t214.unpack53, 2
  call fastcc void @archx_any_drop(%ArchxAny %t21454)
  br label %dlit.store.50

dlit.store.50:                                    ; preds = %dlit.dropold.49, %alloc.ok.47
  store i64 5, ptr %t213, align 8
  %t213.repack55 = getelementptr inbounds nuw i8, ptr %t213, i64 8
  store i64 %t204, ptr %t213.repack55, align 8
  %t213.repack57 = getelementptr inbounds nuw i8, ptr %t213, i64 16
  store i64 0, ptr %t213.repack57, align 8
  %t216 = call fastcc { i64, i1 } @archx_dict_upsert_str(i64 %htag.i596, %ArchxStr { i64 28542638957264899, i64 0 })
  %t217 = extractvalue { i64, i1 } %t216, 0
  %t218 = extractvalue { i64, i1 } %t216, 1
  %t222 = load ptr, ptr %t211, align 16
  %t223 = getelementptr inbounds %ArchxAny, ptr %t222, i64 %t217
  br i1 %t218, label %dlit.dropold.51, label %dlit.store.52

dlit.dropold.51:                                  ; preds = %dlit.store.50
  %t224.unpack = load i64, ptr %t223, align 8
  %9 = insertvalue %ArchxAny poison, i64 %t224.unpack, 0
  %t224.elt59 = getelementptr inbounds nuw i8, ptr %t223, i64 8
  %t224.unpack60 = load i64, ptr %t224.elt59, align 8
  %10 = insertvalue %ArchxAny %9, i64 %t224.unpack60, 1
  %t224.elt61 = getelementptr inbounds nuw i8, ptr %t223, i64 16
  %t224.unpack62 = load i64, ptr %t224.elt61, align 8
  %t22463 = insertvalue %ArchxAny %10, i64 %t224.unpack62, 2
  call fastcc void @archx_any_drop(%ArchxAny %t22463)
  br label %dlit.store.52

dlit.store.52:                                    ; preds = %dlit.dropold.51, %dlit.store.50
  store i64 2, ptr %t223, align 8
  %t223.repack64 = getelementptr inbounds nuw i8, ptr %t223, i64 8
  store i64 18, ptr %t223.repack64, align 8
  %t223.repack65 = getelementptr inbounds nuw i8, ptr %t223, i64 16
  store i64 0, ptr %t223.repack65, align 8
  %ctrl_p.i.i133 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 32
  %ctrl.i.i134 = load ptr, ptr %ctrl_p.i.i133, align 16
  %c_null.i.i135 = icmp eq ptr %ctrl.i.i134, null
  br i1 %c_null.i.i135, label %dm.miss.54, label %do_probe.i.i136

do_probe.i.i136:                                  ; preds = %dlit.store.52
  %mask_p.i.i137 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 16
  %keys_p.i.i138 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 40
  %mask.i.i139 = load i64, ptr %mask_p.i.i137, align 16
  %keys.i.i140 = load ptr, ptr %keys_p.i.i138, align 8
  %11 = getelementptr i8, ptr %ctrl.i.i134, i64 %mask.i.i139
  %idx_base.i.i141 = getelementptr i8, ptr %11, i64 17
  br label %probe.i.i142

probe.i.i142:                                     ; preds = %next_grp.i.i176, %do_probe.i.i136
  %h.pn.i.i143 = phi i64 [ 7936257679436826279, %do_probe.i.i136 ], [ %padd.i.i178, %next_grp.i.i176 ]
  %step.i.i144 = phi i64 [ 0, %do_probe.i.i136 ], [ %step_next.i.i177, %next_grp.i.i176 ]
  %pos.i.i145 = and i64 %h.pn.i.i143, %mask.i.i139
  %gp.i.i146 = getelementptr inbounds i8, ptr %ctrl.i.i134, i64 %pos.i.i145
  %grp.i.i147 = load <16 x i8>, ptr %gp.i.i146, align 1
  %mcmp.i.i148 = icmp eq <16 x i8> %grp.i.i147, splat (i8 55)
  %mbits.i.i149 = bitcast <16 x i1> %mcmp.i.i148 to i16
  %has_m.not.i.i153897 = icmp eq i16 %mbits.i.i149, 0
  br i1 %has_m.not.i.i153897, label %chk_empty.i.i172, label %chk_key.i.i154.preheader

chk_key.i.i154.preheader:                         ; preds = %probe.i.i142
  %mmask0.i.i150 = zext i16 %mbits.i.i149 to i32
  br label %chk_key.i.i154

chk_key.i.i154:                                   ; preds = %chk_key.i.i154.preheader, %mbit_cont.i.i164
  %mmask.i.i152898 = phi i32 [ %mmask_next.i.i166, %mbit_cont.i.i164 ], [ %mmask0.i.i150, %chk_key.i.i154.preheader ]
  %tz.i.i155 = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i152898, i1 true)
  %tz64.i.i156 = zext nneg i32 %tz.i.i155 to i64
  %s_add.i.i157 = add i64 %pos.i.i145, %tz64.i.i156
  %slot.i.i158 = and i64 %s_add.i.i157, %mask.i.i139
  %ip.i.i159 = getelementptr inbounds i32, ptr %idx_base.i.i141, i64 %slot.i.i158
  %didx32.i.i160 = load i32, ptr %ip.i.i159, align 4
  %didx.i.i161 = zext i32 %didx32.i.i160 to i64
  %kp.i.i162 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i140, i64 %didx.i.i161
  %cand_k.unpack.i.i = load i64, ptr %kp.i.i162, align 8
  %cand_k.elt1.i.i = getelementptr inbounds nuw i8, ptr %kp.i.i162, i64 8
  %cand_k.unpack2.i.i = load i64, ptr %cand_k.elt1.i.i, align 8
  %w0_eq.i = icmp eq i64 %cand_k.unpack.i.i, 7022344801102069764
  %eq_s.i = icmp eq i64 %cand_k.unpack2.i.i, 0
  %or.cond875 = select i1 %w0_eq.i, i1 %eq_s.i, i1 false
  br i1 %or.cond875, label %dm.ok.53, label %mbit_cont.i.i164

mbit_cont.i.i164:                                 ; preds = %chk_key.i.i154
  %mm1.i.i165 = add nsw i32 %mmask.i.i152898, -1
  %mmask_next.i.i166 = and i32 %mm1.i.i165, %mmask.i.i152898
  %has_m.not.i.i153 = icmp eq i32 %mmask_next.i.i166, 0
  br i1 %has_m.not.i.i153, label %chk_empty.i.i172, label %chk_key.i.i154

chk_empty.i.i172:                                 ; preds = %mbit_cont.i.i164, %probe.i.i142
  %ecmp.i.i173 = icmp eq <16 x i8> %grp.i.i147, splat (i8 -128)
  %ebits.i.i174 = bitcast <16 x i1> %ecmp.i.i173 to i16
  %has_e.not.i.i175 = icmp eq i16 %ebits.i.i174, 0
  br i1 %has_e.not.i.i175, label %next_grp.i.i176, label %dm.miss.54

next_grp.i.i176:                                  ; preds = %chk_empty.i.i172
  %step_next.i.i177 = add i64 %step.i.i144, 16
  %padd.i.i178 = add i64 %step_next.i.i177, %pos.i.i145
  br label %probe.i.i142

dm.miss.54:                                       ; preds = %chk_empty.i.i172, %dlit.store.52
  call fastcc void @archx_key_fail()
  unreachable

dm.ok.53:                                         ; preds = %chk_key.i.i154
  %t233 = load ptr, ptr %t211, align 16
  %t234 = getelementptr inbounds nuw %ArchxAny, ptr %t233, i64 %didx.i.i161
  %t229.unpack = load i64, ptr %t234, align 8
  %t237 = icmp eq i64 %t229.unpack, 5
  br i1 %t237, label %any.guard.ok.55, label %any.guard.fail.56

any.guard.fail.56:                                ; preds = %dm.ok.53
  call fastcc void @archx_type_fail(ptr nonnull @.str.4)
  unreachable

any.guard.ok.55:                                  ; preds = %dm.ok.53
  %t229.elt66 = getelementptr inbounds nuw i8, ptr %t234, i64 8
  %t229.unpack67 = load i64, ptr %t229.elt66, align 8
  %t242 = and i64 %t229.unpack67, -4
  %t243 = inttoptr i64 %t242 to ptr
  %t244.unpack = load i64, ptr %t243, align 8
  %t244.elt71 = getelementptr inbounds nuw i8, ptr %t243, i64 8
  %t244.unpack72 = load i64, ptr %t244.elt71, align 8
  %t244.elt73 = getelementptr inbounds nuw i8, ptr %t243, i64 16
  %t244.unpack74 = load ptr, ptr %t244.elt73, align 8
  %t250 = call i64 @llvm.abs.i64(i64 %t244.unpack72, i1 true)
  %t251.not = icmp slt i64 %t244.unpack, %t250
  br i1 %t251.not, label %aapp.store.58, label %aapp.grow.57

aapp.grow.57:                                     ; preds = %any.guard.ok.55
  %t252 = icmp eq i64 %t244.unpack72, 0
  %t253 = shl nuw i64 %t250, 1
  %t254 = select i1 %t252, i64 4, i64 %t253
  %t255 = mul nuw nsw i64 %t254, 24
  %t256 = icmp eq i64 %t254, 0
  %t257 = select i1 %t256, i64 1, i64 %t255
  %t258 = call noalias align 16 ptr @malloc(i64 %t257)
  %t259 = icmp eq ptr %t258, null
  br i1 %t259, label %alloc.oom.61, label %alloc.ok.60

alloc.oom.61:                                     ; preds = %aapp.grow.57
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.60:                                      ; preds = %aapp.grow.57
  %t260.not = icmp eq i64 %t244.unpack, 0
  br i1 %t260.not, label %aapp.fr.63, label %aapp.cp.62

aapp.cp.62:                                       ; preds = %alloc.ok.60
  %t261 = mul i64 %t244.unpack, 24
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %t258, ptr nonnull align 8 %t244.unpack74, i64 %t261, i1 false)
  br label %aapp.fr.63

aapp.fr.63:                                       ; preds = %aapp.cp.62, %alloc.ok.60
  %t262 = icmp sgt i64 %t244.unpack72, 0
  br i1 %t262, label %aapp.dofr.65, label %aapp.store.58

aapp.dofr.65:                                     ; preds = %aapp.fr.63
  call void @free(ptr %t244.unpack74)
  br label %aapp.store.58

aapp.store.58:                                    ; preds = %aapp.fr.63, %aapp.dofr.65, %any.guard.ok.55
  %t263 = phi ptr [ %t244.unpack74, %any.guard.ok.55 ], [ %t258, %aapp.dofr.65 ], [ %t258, %aapp.fr.63 ]
  %t264 = phi i64 [ %t244.unpack72, %any.guard.ok.55 ], [ %t254, %aapp.dofr.65 ], [ %t254, %aapp.fr.63 ]
  %t265 = getelementptr inbounds %ArchxAny, ptr %t263, i64 %t244.unpack
  store i64 4, ptr %t265, align 8
  %t265.repack76 = getelementptr inbounds nuw i8, ptr %t265, i64 8
  store i64 7598805596355166214, ptr %t265.repack76, align 8
  %t265.repack77 = getelementptr inbounds nuw i8, ptr %t265, i64 16
  store i64 25974, ptr %t265.repack77, align 8
  %t266 = add nuw nsw i64 %t244.unpack, 1
  store i64 %t266, ptr %t243, align 8
  store i64 %t264, ptr %t244.elt71, align 8
  store ptr %t263, ptr %t244.elt73, align 8
  %ctrl.i.i184 = load ptr, ptr %ctrl_p.i.i133, align 16
  %c_null.i.i185 = icmp eq ptr %ctrl.i.i184, null
  br i1 %c_null.i.i185, label %dupd.miss.67, label %do_probe.i.i186

do_probe.i.i186:                                  ; preds = %aapp.store.58
  %mask_p.i.i187 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 16
  %keys_p.i.i188 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 40
  %mask.i.i189 = load i64, ptr %mask_p.i.i187, align 16
  %keys.i.i190 = load ptr, ptr %keys_p.i.i188, align 8
  %12 = getelementptr i8, ptr %ctrl.i.i184, i64 %mask.i.i189
  %idx_base.i.i191 = getelementptr i8, ptr %12, i64 17
  br label %probe.i.i197

probe.i.i197:                                     ; preds = %next_grp.i.i235, %do_probe.i.i186
  %h.pn.i.i198 = phi i64 [ -8592923751486469375, %do_probe.i.i186 ], [ %padd.i.i237, %next_grp.i.i235 ]
  %step.i.i199 = phi i64 [ 0, %do_probe.i.i186 ], [ %step_next.i.i236, %next_grp.i.i235 ]
  %pos.i.i200 = and i64 %h.pn.i.i198, %mask.i.i189
  %gp.i.i201 = getelementptr inbounds i8, ptr %ctrl.i.i184, i64 %pos.i.i200
  %grp.i.i202 = load <16 x i8>, ptr %gp.i.i201, align 1
  %mcmp.i.i203 = icmp eq <16 x i8> %grp.i.i202, splat (i8 68)
  %mbits.i.i204 = bitcast <16 x i1> %mcmp.i.i203 to i16
  %has_m.not.i.i208899 = icmp eq i16 %mbits.i.i204, 0
  br i1 %has_m.not.i.i208899, label %chk_empty.i.i231, label %chk_key.i.i209.preheader

chk_key.i.i209.preheader:                         ; preds = %probe.i.i197
  %mmask0.i.i205 = zext i16 %mbits.i.i204 to i32
  br label %chk_key.i.i209

chk_key.i.i209:                                   ; preds = %chk_key.i.i209.preheader, %mbit_cont.i.i223
  %mmask.i.i207900 = phi i32 [ %mmask_next.i.i225, %mbit_cont.i.i223 ], [ %mmask0.i.i205, %chk_key.i.i209.preheader ]
  %tz.i.i210 = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i207900, i1 true)
  %tz64.i.i211 = zext nneg i32 %tz.i.i210 to i64
  %s_add.i.i212 = add i64 %pos.i.i200, %tz64.i.i211
  %slot.i.i213 = and i64 %s_add.i.i212, %mask.i.i189
  %ip.i.i214 = getelementptr inbounds i32, ptr %idx_base.i.i191, i64 %slot.i.i213
  %didx32.i.i215 = load i32, ptr %ip.i.i214, align 4
  %didx.i.i216 = zext i32 %didx32.i.i215 to i64
  %kp.i.i217 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i190, i64 %didx.i.i216
  %cand_k.unpack.i.i218 = load i64, ptr %kp.i.i217, align 8
  %cand_k.elt1.i.i219 = getelementptr inbounds nuw i8, ptr %kp.i.i217, i64 8
  %cand_k.unpack2.i.i220 = load i64, ptr %cand_k.elt1.i.i219, align 8
  %w0_eq.i609 = icmp eq i64 %cand_k.unpack.i.i218, 28542638957264899
  %eq_s.i624 = icmp eq i64 %cand_k.unpack2.i.i220, 0
  %or.cond876 = select i1 %w0_eq.i609, i1 %eq_s.i624, i1 false
  br i1 %or.cond876, label %dupd.ok.66, label %mbit_cont.i.i223

mbit_cont.i.i223:                                 ; preds = %chk_key.i.i209
  %mm1.i.i224 = add nsw i32 %mmask.i.i207900, -1
  %mmask_next.i.i225 = and i32 %mm1.i.i224, %mmask.i.i207900
  %has_m.not.i.i208 = icmp eq i32 %mmask_next.i.i225, 0
  br i1 %has_m.not.i.i208, label %chk_empty.i.i231, label %chk_key.i.i209

chk_empty.i.i231:                                 ; preds = %mbit_cont.i.i223, %probe.i.i197
  %ecmp.i.i232 = icmp eq <16 x i8> %grp.i.i202, splat (i8 -128)
  %ebits.i.i233 = bitcast <16 x i1> %ecmp.i.i232 to i16
  %has_e.not.i.i234 = icmp eq i16 %ebits.i.i233, 0
  br i1 %has_e.not.i.i234, label %next_grp.i.i235, label %dupd.miss.67

next_grp.i.i235:                                  ; preds = %chk_empty.i.i231
  %step_next.i.i236 = add i64 %step.i.i199, 16
  %padd.i.i237 = add i64 %step_next.i.i236, %pos.i.i200
  br label %probe.i.i197

dupd.miss.67:                                     ; preds = %chk_empty.i.i231, %aapp.store.58
  call fastcc void @archx_key_fail()
  unreachable

dupd.ok.66:                                       ; preds = %chk_key.i.i209
  %t276 = load ptr, ptr %t211, align 16
  %t277 = getelementptr inbounds nuw %ArchxAny, ptr %t276, i64 %didx.i.i216
  %t278.unpack = load i64, ptr %t277, align 8
  %13 = add i64 %t278.unpack, -1
  %na.i = icmp ult i64 %13, 3
  br i1 %na.i, label %num_op.i, label %bad_op.i

num_op.i:                                         ; preds = %dupd.ok.66
  %14 = insertvalue %ArchxAny poison, i64 %t278.unpack, 0
  %t278.elt82 = getelementptr inbounds nuw i8, ptr %t277, i64 8
  %t278.unpack83 = load i64, ptr %t278.elt82, align 8
  %15 = insertvalue %ArchxAny %14, i64 %t278.unpack83, 1
  %t278.elt84 = getelementptr inbounds nuw i8, ptr %t277, i64 16
  %t278.unpack85 = load i64, ptr %t278.elt84, align 8
  %t27886 = insertvalue %ArchxAny %15, i64 %t278.unpack85, 2
  %fa_is.i = icmp eq i64 %t278.unpack, 3
  %va.i = add i64 %t278.unpack83, 2
  %da_b.i = bitcast i64 %t278.unpack83 to double
  %fva.i = fadd double %da_b.i, 2.000000e+00
  %fbits.i = bitcast double %fva.i to i64
  %va.pn.i = select i1 %fa_is.i, i64 %fbits.i, i64 %va.i
  call fastcc void @archx_any_drop(%ArchxAny %t27886)
  %t280.elt = select i1 %fa_is.i, i64 3, i64 2
  store i64 %t280.elt, ptr %t277, align 8
  store i64 %va.pn.i, ptr %t278.elt82, align 8
  store i64 0, ptr %t278.elt84, align 8
  %ctrl.i.i244 = load ptr, ptr %ctrl_p.i.i133, align 16
  %c_null.i.i245 = icmp eq ptr %ctrl.i.i244, null
  br i1 %c_null.i.i245, label %dget.miss.69, label %do_probe.i.i246

bad_op.i:                                         ; preds = %dupd.ok.66
  call fastcc void @archx_type_fail(ptr nonnull @.any.badop)
  unreachable

do_probe.i.i246:                                  ; preds = %num_op.i
  %mask_p.i.i247 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 16
  %keys_p.i.i248 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 40
  %mask.i.i249 = load i64, ptr %mask_p.i.i247, align 16
  %keys.i.i250 = load ptr, ptr %keys_p.i.i248, align 8
  %16 = getelementptr i8, ptr %ctrl.i.i244, i64 %mask.i.i249
  %idx_base.i.i251 = getelementptr i8, ptr %16, i64 17
  br label %probe.i.i257

probe.i.i257:                                     ; preds = %next_grp.i.i295, %do_probe.i.i246
  %h.pn.i.i258 = phi i64 [ 7936257679436826279, %do_probe.i.i246 ], [ %padd.i.i297, %next_grp.i.i295 ]
  %step.i.i259 = phi i64 [ 0, %do_probe.i.i246 ], [ %step_next.i.i296, %next_grp.i.i295 ]
  %pos.i.i260 = and i64 %h.pn.i.i258, %mask.i.i249
  %gp.i.i261 = getelementptr inbounds i8, ptr %ctrl.i.i244, i64 %pos.i.i260
  %grp.i.i262 = load <16 x i8>, ptr %gp.i.i261, align 1
  %mcmp.i.i263 = icmp eq <16 x i8> %grp.i.i262, splat (i8 55)
  %mbits.i.i264 = bitcast <16 x i1> %mcmp.i.i263 to i16
  %has_m.not.i.i268901 = icmp eq i16 %mbits.i.i264, 0
  br i1 %has_m.not.i.i268901, label %chk_empty.i.i291, label %chk_key.i.i269.preheader

chk_key.i.i269.preheader:                         ; preds = %probe.i.i257
  %mmask0.i.i265 = zext i16 %mbits.i.i264 to i32
  br label %chk_key.i.i269

chk_key.i.i269:                                   ; preds = %chk_key.i.i269.preheader, %mbit_cont.i.i283
  %mmask.i.i267902 = phi i32 [ %mmask_next.i.i285, %mbit_cont.i.i283 ], [ %mmask0.i.i265, %chk_key.i.i269.preheader ]
  %tz.i.i270 = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i267902, i1 true)
  %tz64.i.i271 = zext nneg i32 %tz.i.i270 to i64
  %s_add.i.i272 = add i64 %pos.i.i260, %tz64.i.i271
  %slot.i.i273 = and i64 %s_add.i.i272, %mask.i.i249
  %ip.i.i274 = getelementptr inbounds i32, ptr %idx_base.i.i251, i64 %slot.i.i273
  %didx32.i.i275 = load i32, ptr %ip.i.i274, align 4
  %didx.i.i276 = zext i32 %didx32.i.i275 to i64
  %kp.i.i277 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i250, i64 %didx.i.i276
  %cand_k.unpack.i.i278 = load i64, ptr %kp.i.i277, align 8
  %cand_k.elt1.i.i279 = getelementptr inbounds nuw i8, ptr %kp.i.i277, i64 8
  %cand_k.unpack2.i.i280 = load i64, ptr %cand_k.elt1.i.i279, align 8
  %w0_eq.i633 = icmp eq i64 %cand_k.unpack.i.i278, 7022344801102069764
  %eq_s.i648 = icmp eq i64 %cand_k.unpack2.i.i280, 0
  %or.cond877 = select i1 %w0_eq.i633, i1 %eq_s.i648, i1 false
  br i1 %or.cond877, label %dget.ok.68, label %mbit_cont.i.i283

mbit_cont.i.i283:                                 ; preds = %chk_key.i.i269
  %mm1.i.i284 = add nsw i32 %mmask.i.i267902, -1
  %mmask_next.i.i285 = and i32 %mm1.i.i284, %mmask.i.i267902
  %has_m.not.i.i268 = icmp eq i32 %mmask_next.i.i285, 0
  br i1 %has_m.not.i.i268, label %chk_empty.i.i291, label %chk_key.i.i269

chk_empty.i.i291:                                 ; preds = %mbit_cont.i.i283, %probe.i.i257
  %ecmp.i.i292 = icmp eq <16 x i8> %grp.i.i262, splat (i8 -128)
  %ebits.i.i293 = bitcast <16 x i1> %ecmp.i.i292 to i16
  %has_e.not.i.i294 = icmp eq i16 %ebits.i.i293, 0
  br i1 %has_e.not.i.i294, label %next_grp.i.i295, label %dget.miss.69

next_grp.i.i295:                                  ; preds = %chk_empty.i.i291
  %step_next.i.i296 = add i64 %step.i.i259, 16
  %padd.i.i297 = add i64 %step_next.i.i296, %pos.i.i260
  br label %probe.i.i257

dget.miss.69:                                     ; preds = %chk_empty.i.i291, %num_op.i
  call fastcc void @archx_key_fail()
  unreachable

dget.ok.68:                                       ; preds = %chk_key.i.i269
  %t287 = load ptr, ptr %t211, align 16
  %t288 = getelementptr inbounds nuw %ArchxAny, ptr %t287, i64 %didx.i.i276
  %t289.unpack = load i64, ptr %t288, align 8
  %17 = insertvalue %ArchxAny poison, i64 %t289.unpack, 0
  %t289.elt91 = getelementptr inbounds nuw i8, ptr %t288, i64 8
  %t289.unpack92 = load i64, ptr %t289.elt91, align 8
  %18 = insertvalue %ArchxAny %17, i64 %t289.unpack92, 1
  %t289.elt93 = getelementptr inbounds nuw i8, ptr %t288, i64 16
  %t289.unpack94 = load i64, ptr %t289.elt93, align 8
  %t28995 = insertvalue %ArchxAny %18, i64 %t289.unpack94, 2
  %t290 = call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t28995)
  %newret962 = extractvalue { i64, i64, i64 } %t290, 0
  %oldret963 = insertvalue %ArchxAny poison, i64 %newret962, 0
  %newret964 = extractvalue { i64, i64, i64 } %t290, 1
  %oldret965 = insertvalue %ArchxAny %oldret963, i64 %newret964, 1
  %newret966 = extractvalue { i64, i64, i64 } %t290, 2
  %oldret967 = insertvalue %ArchxAny %oldret965, i64 %newret966, 2
  %t292 = call fastcc { i64, i64, i64 } @archx_any_get_idx(%ArchxAny %oldret967, %ArchxAny { i64 2, i64 0, i64 0 })
  %newret980 = extractvalue { i64, i64, i64 } %t292, 0
  %oldret981 = insertvalue %ArchxAny poison, i64 %newret980, 0
  %newret982 = extractvalue { i64, i64, i64 } %t292, 1
  %oldret983 = insertvalue %ArchxAny %oldret981, i64 %newret982, 1
  %newret984 = extractvalue { i64, i64, i64 } %t292, 2
  %oldret985 = insertvalue %ArchxAny %oldret983, i64 %newret984, 2
  %ctrl.i.i304 = load ptr, ptr %ctrl_p.i.i133, align 16
  %c_null.i.i305 = icmp eq ptr %ctrl.i.i304, null
  br i1 %c_null.i.i305, label %dget.miss.71, label %do_probe.i.i306

do_probe.i.i306:                                  ; preds = %dget.ok.68
  %mask_p.i.i307 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 16
  %keys_p.i.i308 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 40
  %mask.i.i309 = load i64, ptr %mask_p.i.i307, align 16
  %keys.i.i310 = load ptr, ptr %keys_p.i.i308, align 8
  %19 = getelementptr i8, ptr %ctrl.i.i304, i64 %mask.i.i309
  %idx_base.i.i311 = getelementptr i8, ptr %19, i64 17
  br label %probe.i.i317

probe.i.i317:                                     ; preds = %next_grp.i.i355, %do_probe.i.i306
  %h.pn.i.i318 = phi i64 [ 7936257679436826279, %do_probe.i.i306 ], [ %padd.i.i357, %next_grp.i.i355 ]
  %step.i.i319 = phi i64 [ 0, %do_probe.i.i306 ], [ %step_next.i.i356, %next_grp.i.i355 ]
  %pos.i.i320 = and i64 %h.pn.i.i318, %mask.i.i309
  %gp.i.i321 = getelementptr inbounds i8, ptr %ctrl.i.i304, i64 %pos.i.i320
  %grp.i.i322 = load <16 x i8>, ptr %gp.i.i321, align 1
  %mcmp.i.i323 = icmp eq <16 x i8> %grp.i.i322, splat (i8 55)
  %mbits.i.i324 = bitcast <16 x i1> %mcmp.i.i323 to i16
  %has_m.not.i.i328903 = icmp eq i16 %mbits.i.i324, 0
  br i1 %has_m.not.i.i328903, label %chk_empty.i.i351, label %chk_key.i.i329.preheader

chk_key.i.i329.preheader:                         ; preds = %probe.i.i317
  %mmask0.i.i325 = zext i16 %mbits.i.i324 to i32
  br label %chk_key.i.i329

chk_key.i.i329:                                   ; preds = %chk_key.i.i329.preheader, %mbit_cont.i.i343
  %mmask.i.i327904 = phi i32 [ %mmask_next.i.i345, %mbit_cont.i.i343 ], [ %mmask0.i.i325, %chk_key.i.i329.preheader ]
  %tz.i.i330 = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i327904, i1 true)
  %tz64.i.i331 = zext nneg i32 %tz.i.i330 to i64
  %s_add.i.i332 = add i64 %pos.i.i320, %tz64.i.i331
  %slot.i.i333 = and i64 %s_add.i.i332, %mask.i.i309
  %ip.i.i334 = getelementptr inbounds i32, ptr %idx_base.i.i311, i64 %slot.i.i333
  %didx32.i.i335 = load i32, ptr %ip.i.i334, align 4
  %didx.i.i336 = zext i32 %didx32.i.i335 to i64
  %kp.i.i337 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i310, i64 %didx.i.i336
  %cand_k.unpack.i.i338 = load i64, ptr %kp.i.i337, align 8
  %cand_k.elt1.i.i339 = getelementptr inbounds nuw i8, ptr %kp.i.i337, i64 8
  %cand_k.unpack2.i.i340 = load i64, ptr %cand_k.elt1.i.i339, align 8
  %w0_eq.i656 = icmp eq i64 %cand_k.unpack.i.i338, 7022344801102069764
  %eq_s.i671 = icmp eq i64 %cand_k.unpack2.i.i340, 0
  %or.cond878 = select i1 %w0_eq.i656, i1 %eq_s.i671, i1 false
  br i1 %or.cond878, label %dget.ok.70, label %mbit_cont.i.i343

mbit_cont.i.i343:                                 ; preds = %chk_key.i.i329
  %mm1.i.i344 = add nsw i32 %mmask.i.i327904, -1
  %mmask_next.i.i345 = and i32 %mm1.i.i344, %mmask.i.i327904
  %has_m.not.i.i328 = icmp eq i32 %mmask_next.i.i345, 0
  br i1 %has_m.not.i.i328, label %chk_empty.i.i351, label %chk_key.i.i329

chk_empty.i.i351:                                 ; preds = %mbit_cont.i.i343, %probe.i.i317
  %ecmp.i.i352 = icmp eq <16 x i8> %grp.i.i322, splat (i8 -128)
  %ebits.i.i353 = bitcast <16 x i1> %ecmp.i.i352 to i16
  %has_e.not.i.i354 = icmp eq i16 %ebits.i.i353, 0
  br i1 %has_e.not.i.i354, label %next_grp.i.i355, label %dget.miss.71

next_grp.i.i355:                                  ; preds = %chk_empty.i.i351
  %step_next.i.i356 = add i64 %step.i.i319, 16
  %padd.i.i357 = add i64 %step_next.i.i356, %pos.i.i320
  br label %probe.i.i317

dget.miss.71:                                     ; preds = %chk_empty.i.i351, %dget.ok.68
  call fastcc void @archx_key_fail()
  unreachable

dget.ok.70:                                       ; preds = %chk_key.i.i329
  %t299 = load ptr, ptr %t211, align 16
  %t300 = getelementptr inbounds nuw %ArchxAny, ptr %t299, i64 %didx.i.i336
  %t301.unpack = load i64, ptr %t300, align 8
  %20 = insertvalue %ArchxAny poison, i64 %t301.unpack, 0
  %t301.elt96 = getelementptr inbounds nuw i8, ptr %t300, i64 8
  %t301.unpack97 = load i64, ptr %t301.elt96, align 8
  %21 = insertvalue %ArchxAny %20, i64 %t301.unpack97, 1
  %t301.elt98 = getelementptr inbounds nuw i8, ptr %t300, i64 16
  %t301.unpack99 = load i64, ptr %t301.elt98, align 8
  %t301100 = insertvalue %ArchxAny %21, i64 %t301.unpack99, 2
  %t302 = call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t301100)
  %newret968 = extractvalue { i64, i64, i64 } %t302, 0
  %oldret969 = insertvalue %ArchxAny poison, i64 %newret968, 0
  %newret970 = extractvalue { i64, i64, i64 } %t302, 1
  %oldret971 = insertvalue %ArchxAny %oldret969, i64 %newret970, 1
  %newret972 = extractvalue { i64, i64, i64 } %t302, 2
  %oldret973 = insertvalue %ArchxAny %oldret971, i64 %newret972, 2
  %is4.i = icmp eq i64 %newret968, 4
  br i1 %is4.i, label %l_str.i, label %chk_cont.i

l_str.i:                                          ; preds = %dget.ok.70
  %slen.i = and i64 %newret970, 4294967295
  br label %chk_ctrl.i.i361

chk_cont.i:                                       ; preds = %dget.ok.70
  %22 = add i64 %newret968, -5
  %ok.i = icmp ult i64 %22, 3
  br i1 %ok.i, label %l_cont.i, label %bad.i

l_cont.i:                                         ; preds = %chk_cont.i
  %raw.i675 = and i64 %newret970, -4
  %z.i = icmp eq i64 %raw.i675, 0
  br i1 %z.i, label %chk_ctrl.i.i361, label %load_l.i

load_l.i:                                         ; preds = %l_cont.i
  %p.i = inttoptr i64 %raw.i675 to ptr
  %l.i = load i64, ptr %p.i, align 8
  br label %chk_ctrl.i.i361

bad.i:                                            ; preds = %chk_cont.i
  call fastcc void @archx_type_fail(ptr nonnull @.any.badlen)
  unreachable

chk_ctrl.i.i361:                                  ; preds = %load_l.i, %l_cont.i, %l_str.i
  %common.ret.op.i676 = phi i64 [ %slen.i, %l_str.i ], [ %l.i, %load_l.i ], [ 0, %l_cont.i ]
  %ctrl.i.i364 = load ptr, ptr %ctrl_p.i.i133, align 16
  %c_null.i.i365 = icmp eq ptr %ctrl.i.i364, null
  br i1 %c_null.i.i365, label %dget.miss.73, label %do_probe.i.i366

do_probe.i.i366:                                  ; preds = %chk_ctrl.i.i361
  %mask_p.i.i367 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 16
  %keys_p.i.i368 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 40
  %mask.i.i369 = load i64, ptr %mask_p.i.i367, align 16
  %keys.i.i370 = load ptr, ptr %keys_p.i.i368, align 8
  %23 = getelementptr i8, ptr %ctrl.i.i364, i64 %mask.i.i369
  %idx_base.i.i371 = getelementptr i8, ptr %23, i64 17
  br label %probe.i.i377

probe.i.i377:                                     ; preds = %next_grp.i.i415, %do_probe.i.i366
  %h.pn.i.i378 = phi i64 [ -8592923751486469375, %do_probe.i.i366 ], [ %padd.i.i417, %next_grp.i.i415 ]
  %step.i.i379 = phi i64 [ 0, %do_probe.i.i366 ], [ %step_next.i.i416, %next_grp.i.i415 ]
  %pos.i.i380 = and i64 %h.pn.i.i378, %mask.i.i369
  %gp.i.i381 = getelementptr inbounds i8, ptr %ctrl.i.i364, i64 %pos.i.i380
  %grp.i.i382 = load <16 x i8>, ptr %gp.i.i381, align 1
  %mcmp.i.i383 = icmp eq <16 x i8> %grp.i.i382, splat (i8 68)
  %mbits.i.i384 = bitcast <16 x i1> %mcmp.i.i383 to i16
  %has_m.not.i.i388905 = icmp eq i16 %mbits.i.i384, 0
  br i1 %has_m.not.i.i388905, label %chk_empty.i.i411, label %chk_key.i.i389.preheader

chk_key.i.i389.preheader:                         ; preds = %probe.i.i377
  %mmask0.i.i385 = zext i16 %mbits.i.i384 to i32
  br label %chk_key.i.i389

chk_key.i.i389:                                   ; preds = %chk_key.i.i389.preheader, %mbit_cont.i.i403
  %mmask.i.i387906 = phi i32 [ %mmask_next.i.i405, %mbit_cont.i.i403 ], [ %mmask0.i.i385, %chk_key.i.i389.preheader ]
  %tz.i.i390 = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i387906, i1 true)
  %tz64.i.i391 = zext nneg i32 %tz.i.i390 to i64
  %s_add.i.i392 = add i64 %pos.i.i380, %tz64.i.i391
  %slot.i.i393 = and i64 %s_add.i.i392, %mask.i.i369
  %ip.i.i394 = getelementptr inbounds i32, ptr %idx_base.i.i371, i64 %slot.i.i393
  %didx32.i.i395 = load i32, ptr %ip.i.i394, align 4
  %didx.i.i396 = zext i32 %didx32.i.i395 to i64
  %kp.i.i397 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i370, i64 %didx.i.i396
  %cand_k.unpack.i.i398 = load i64, ptr %kp.i.i397, align 8
  %cand_k.elt1.i.i399 = getelementptr inbounds nuw i8, ptr %kp.i.i397, i64 8
  %cand_k.unpack2.i.i400 = load i64, ptr %cand_k.elt1.i.i399, align 8
  %w0_eq.i683 = icmp eq i64 %cand_k.unpack.i.i398, 28542638957264899
  %eq_s.i698 = icmp eq i64 %cand_k.unpack2.i.i400, 0
  %or.cond879 = select i1 %w0_eq.i683, i1 %eq_s.i698, i1 false
  br i1 %or.cond879, label %dget.ok.72, label %mbit_cont.i.i403

mbit_cont.i.i403:                                 ; preds = %chk_key.i.i389
  %mm1.i.i404 = add nsw i32 %mmask.i.i387906, -1
  %mmask_next.i.i405 = and i32 %mm1.i.i404, %mmask.i.i387906
  %has_m.not.i.i388 = icmp eq i32 %mmask_next.i.i405, 0
  br i1 %has_m.not.i.i388, label %chk_empty.i.i411, label %chk_key.i.i389

chk_empty.i.i411:                                 ; preds = %mbit_cont.i.i403, %probe.i.i377
  %ecmp.i.i412 = icmp eq <16 x i8> %grp.i.i382, splat (i8 -128)
  %ebits.i.i413 = bitcast <16 x i1> %ecmp.i.i412 to i16
  %has_e.not.i.i414 = icmp eq i16 %ebits.i.i413, 0
  br i1 %has_e.not.i.i414, label %next_grp.i.i415, label %dget.miss.73

next_grp.i.i415:                                  ; preds = %chk_empty.i.i411
  %step_next.i.i416 = add i64 %step.i.i379, 16
  %padd.i.i417 = add i64 %step_next.i.i416, %pos.i.i380
  br label %probe.i.i377

dget.miss.73:                                     ; preds = %chk_empty.i.i411, %chk_ctrl.i.i361
  call fastcc void @archx_key_fail()
  unreachable

dget.ok.72:                                       ; preds = %chk_key.i.i389
  %t310 = load ptr, ptr %t211, align 16
  %t311 = getelementptr inbounds nuw %ArchxAny, ptr %t310, i64 %didx.i.i396
  %t312.unpack = load i64, ptr %t311, align 8
  %24 = insertvalue %ArchxAny poison, i64 %t312.unpack, 0
  %t312.elt101 = getelementptr inbounds nuw i8, ptr %t311, i64 8
  %t312.unpack102 = load i64, ptr %t312.elt101, align 8
  %25 = insertvalue %ArchxAny %24, i64 %t312.unpack102, 1
  %t312.elt103 = getelementptr inbounds nuw i8, ptr %t311, i64 16
  %t312.unpack104 = load i64, ptr %t312.elt103, align 8
  %t312105 = insertvalue %ArchxAny %25, i64 %t312.unpack104, 2
  %t313 = call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t312105)
  %newret974 = extractvalue { i64, i64, i64 } %t313, 0
  %oldret975 = insertvalue %ArchxAny poison, i64 %newret974, 0
  %newret976 = extractvalue { i64, i64, i64 } %t313, 1
  %oldret977 = insertvalue %ArchxAny %oldret975, i64 %newret976, 1
  %newret978 = extractvalue { i64, i64, i64 } %t313, 2
  %oldret979 = insertvalue %ArchxAny %oldret977, i64 %newret978, 2
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i700)
  store i32 1819894128, ptr %tmp.i700, align 4
  %tmp4.i702 = getelementptr inbounds nuw i8, ptr %tmp.i700, i64 4
  store i64 979657071, ptr %tmp4.i702, align 4
  %nul.i705 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i700, i32 0, i64 8)
  %has_nul.not.i706 = icmp eq ptr %nul.i705, null
  br i1 %has_nul.not.i706, label %fast_printf.i715, label %byte_loop.i707.preheader

byte_loop.i707.preheader:                         ; preds = %dget.ok.72
  %pc.i712 = call i32 @putchar(i32 112)
  %bp.i709.1 = getelementptr inbounds nuw i8, ptr %tmp.i700, i64 1
  %ch8.i710.1 = load i8, ptr %bp.i709.1, align 1
  %ch32.i711.1 = zext i8 %ch8.i710.1 to i32
  %pc.i712.1 = call i32 @putchar(i32 %ch32.i711.1)
  %bp.i709.2 = getelementptr inbounds nuw i8, ptr %tmp.i700, i64 2
  %ch8.i710.2 = load i8, ptr %bp.i709.2, align 2
  %ch32.i711.2 = zext i8 %ch8.i710.2 to i32
  %pc.i712.2 = call i32 @putchar(i32 %ch32.i711.2)
  %bp.i709.3 = getelementptr inbounds nuw i8, ptr %tmp.i700, i64 3
  %ch8.i710.3 = load i8, ptr %bp.i709.3, align 1
  %ch32.i711.3 = zext i8 %ch8.i710.3 to i32
  %pc.i712.3 = call i32 @putchar(i32 %ch32.i711.3)
  %ch8.i710.4 = load i8, ptr %tmp4.i702, align 4
  %ch32.i711.4 = zext i8 %ch8.i710.4 to i32
  %pc.i712.4 = call i32 @putchar(i32 %ch32.i711.4)
  %bp.i709.5 = getelementptr inbounds nuw i8, ptr %tmp.i700, i64 5
  %ch8.i710.5 = load i8, ptr %bp.i709.5, align 1
  %ch32.i711.5 = zext i8 %ch8.i710.5 to i32
  %pc.i712.5 = call i32 @putchar(i32 %ch32.i711.5)
  %bp.i709.6 = getelementptr inbounds nuw i8, ptr %tmp.i700, i64 6
  %ch8.i710.6 = load i8, ptr %bp.i709.6, align 2
  %ch32.i711.6 = zext i8 %ch8.i710.6 to i32
  %pc.i712.6 = call i32 @putchar(i32 %ch32.i711.6)
  %bp.i709.7 = getelementptr inbounds nuw i8, ptr %tmp.i700, i64 7
  %ch8.i710.7 = load i8, ptr %bp.i709.7, align 1
  %ch32.i711.7 = zext i8 %ch8.i710.7 to i32
  %pc.i712.7 = call i32 @putchar(i32 %ch32.i711.7)
  br label %archx_str_print.exit717

fast_printf.i715:                                 ; preds = %dget.ok.72
  %np.i716 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 8, ptr nonnull %tmp.i700)
  br label %archx_str_print.exit717

archx_str_print.exit717:                          ; preds = %byte_loop.i707.preheader, %fast_printf.i715
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i700)
  %t314 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret985)
  %t315 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i718)
  store i32 1835365481, ptr %tmp.i718, align 4
  %tmp4.i720 = getelementptr inbounds nuw i8, ptr %tmp.i718, i64 4
  store i64 14963, ptr %tmp4.i720, align 4
  %nul.i723 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i718, i32 0, i64 6)
  %has_nul.not.i724 = icmp eq ptr %nul.i723, null
  br i1 %has_nul.not.i724, label %fast_printf.i733, label %byte_loop.i725.preheader

byte_loop.i725.preheader:                         ; preds = %archx_str_print.exit717
  %pc.i730 = call i32 @putchar(i32 105)
  %bp.i727.1 = getelementptr inbounds nuw i8, ptr %tmp.i718, i64 1
  %ch8.i728.1 = load i8, ptr %bp.i727.1, align 1
  %ch32.i729.1 = zext i8 %ch8.i728.1 to i32
  %pc.i730.1 = call i32 @putchar(i32 %ch32.i729.1)
  %bp.i727.2 = getelementptr inbounds nuw i8, ptr %tmp.i718, i64 2
  %ch8.i728.2 = load i8, ptr %bp.i727.2, align 2
  %ch32.i729.2 = zext i8 %ch8.i728.2 to i32
  %pc.i730.2 = call i32 @putchar(i32 %ch32.i729.2)
  %bp.i727.3 = getelementptr inbounds nuw i8, ptr %tmp.i718, i64 3
  %ch8.i728.3 = load i8, ptr %bp.i727.3, align 1
  %ch32.i729.3 = zext i8 %ch8.i728.3 to i32
  %pc.i730.3 = call i32 @putchar(i32 %ch32.i729.3)
  %ch8.i728.4 = load i8, ptr %tmp4.i720, align 4
  %ch32.i729.4 = zext i8 %ch8.i728.4 to i32
  %pc.i730.4 = call i32 @putchar(i32 %ch32.i729.4)
  %bp.i727.5 = getelementptr inbounds nuw i8, ptr %tmp.i718, i64 5
  %ch8.i728.5 = load i8, ptr %bp.i727.5, align 1
  %ch32.i729.5 = zext i8 %ch8.i728.5 to i32
  %pc.i730.5 = call i32 @putchar(i32 %ch32.i729.5)
  br label %archx_str_print.exit735

fast_printf.i733:                                 ; preds = %archx_str_print.exit717
  %np.i734 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 6, ptr nonnull %tmp.i718)
  br label %archx_str_print.exit735

archx_str_print.exit735:                          ; preds = %byte_loop.i725.preheader, %fast_printf.i733
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i718)
  %t316 = call i32 @putchar(i32 32)
  %t317 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %common.ret.op.i676)
  %t318 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i736)
  store i32 979724129, ptr %tmp.i736, align 4
  %tmp4.i738 = getelementptr inbounds nuw i8, ptr %tmp.i736, i64 4
  store i64 0, ptr %tmp4.i738, align 4
  %nul.i741 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i736, i32 0, i64 4)
  %has_nul.not.i742 = icmp eq ptr %nul.i741, null
  br i1 %has_nul.not.i742, label %fast_printf.i751, label %byte_loop.i743.preheader

byte_loop.i743.preheader:                         ; preds = %archx_str_print.exit735
  %pc.i748 = call i32 @putchar(i32 97)
  %pc.i748.1 = call i32 @putchar(i32 103)
  %pc.i748.2 = call i32 @putchar(i32 101)
  %pc.i748.3 = call i32 @putchar(i32 58)
  br label %archx_str_print.exit753

fast_printf.i751:                                 ; preds = %archx_str_print.exit735
  %np.i752 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 4, ptr nonnull %tmp.i736)
  br label %archx_str_print.exit753

archx_str_print.exit753:                          ; preds = %byte_loop.i743.preheader, %fast_printf.i751
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i736)
  %t319 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret979)
  %t320 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %oldret979)
  call fastcc void @archx_any_drop(%ArchxAny %oldret973)
  call fastcc void @archx_any_drop(%ArchxAny %oldret985)
  call fastcc void @archx_any_drop(%ArchxAny %oldret967)
  %t330 = call fastcc { i64, i64, i64 } @archx_fn_summarize_tag(%ArchxAny { i64 4, i64 8458994031421030408, i64 1751215212 })
  %newret956 = extractvalue { i64, i64, i64 } %t330, 0
  %oldret957 = insertvalue %ArchxAny poison, i64 %newret956, 0
  %newret958 = extractvalue { i64, i64, i64 } %t330, 1
  %oldret959 = insertvalue %ArchxAny %oldret957, i64 %newret958, 1
  %newret960 = extractvalue { i64, i64, i64 } %t330, 2
  %oldret961 = insertvalue %ArchxAny %oldret959, i64 %newret960, 2
  %np.i769 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 14, ptr nonnull @.str.5)
  %t331 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret961)
  %t332 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %oldret961)
  %t341 = call fastcc { i64, i64, i64 } @archx_fn_summarize_tag(%ArchxAny { i64 2, i64 25, i64 0 })
  %newret950 = extractvalue { i64, i64, i64 } %t341, 0
  %oldret951 = insertvalue %ArchxAny poison, i64 %newret950, 0
  %newret952 = extractvalue { i64, i64, i64 } %t341, 1
  %oldret953 = insertvalue %ArchxAny %oldret951, i64 %newret952, 1
  %newret954 = extractvalue { i64, i64, i64 } %t341, 2
  %oldret955 = insertvalue %ArchxAny %oldret953, i64 %newret954, 2
  %np.i791 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 13, ptr nonnull @.str.6)
  %t342 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret955)
  %t343 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %oldret955)
  %t353 = call noalias align 16 dereferenceable_or_null(72) ptr @malloc(i64 72)
  %t354 = icmp eq ptr %t353, null
  br i1 %t354, label %alloc.oom.75, label %alloc.ok.74

alloc.oom.75:                                     ; preds = %archx_str_print.exit753
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.74:                                      ; preds = %archx_str_print.exit753
  store i64 4, ptr %t353, align 16
  %t353.repack106 = getelementptr inbounds nuw i8, ptr %t353, i64 8
  store i64 8243110639908683781, ptr %t353.repack106, align 8
  %t353.repack107 = getelementptr inbounds nuw i8, ptr %t353, i64 16
  store i64 49, ptr %t353.repack107, align 16
  %t356 = getelementptr inbounds nuw i8, ptr %t353, i64 24
  store i64 4, ptr %t356, align 8
  %t356.repack108 = getelementptr inbounds nuw i8, ptr %t353, i64 32
  store i64 8243110639908683781, ptr %t356.repack108, align 16
  %t356.repack109 = getelementptr inbounds nuw i8, ptr %t353, i64 40
  store i64 50, ptr %t356.repack109, align 8
  %t357 = getelementptr inbounds nuw i8, ptr %t353, i64 48
  store i64 2, ptr %t357, align 16
  %t357.repack110 = getelementptr inbounds nuw i8, ptr %t353, i64 56
  store i64 7, ptr %t357.repack110, align 8
  %t357.repack111 = getelementptr inbounds nuw i8, ptr %t353, i64 64
  store i64 0, ptr %t357.repack111, align 16
  %t361 = call noalias align 16 dereferenceable_or_null(24) ptr @malloc(i64 24)
  %t362 = icmp eq ptr %t361, null
  br i1 %t362, label %alloc.oom.77, label %alloc.ok.76

alloc.oom.77:                                     ; preds = %alloc.ok.74
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.76:                                      ; preds = %alloc.ok.74
  store i64 3, ptr %t361, align 16
  %t361.repack112 = getelementptr inbounds nuw i8, ptr %t361, i64 8
  store i64 3, ptr %t361.repack112, align 8
  %t361.repack114 = getelementptr inbounds nuw i8, ptr %t361, i64 16
  store ptr %t353, ptr %t361.repack114, align 16
  %t363 = ptrtoint ptr %t361 to i64
  %t364 = or disjoint i64 %t363, 1
  %t370.fca.1.insert = insertvalue %ArchxAny { i64 5, i64 0, i64 0 }, i64 %t364, 1
  %t370.fca.2.insert = insertvalue %ArchxAny %t370.fca.1.insert, i64 0, 2
  %t371 = call fastcc { i64, i64, i64 } @archx_fn_summarize_tag(%ArchxAny %t370.fca.2.insert)
  %newret = extractvalue { i64, i64, i64 } %t371, 0
  %oldret = insertvalue %ArchxAny poison, i64 %newret, 0
  %newret946 = extractvalue { i64, i64, i64 } %t371, 1
  %oldret947 = insertvalue %ArchxAny %oldret, i64 %newret946, 1
  %newret948 = extractvalue { i64, i64, i64 } %t371, 2
  %oldret949 = insertvalue %ArchxAny %oldret947, i64 %newret948, 2
  %t375 = call fastcc { i64, i64, i64 } @archx_any_get_idx(%ArchxAny %t370.fca.2.insert, %ArchxAny { i64 2, i64 -1, i64 0 })
  %newret986 = extractvalue { i64, i64, i64 } %t375, 0
  %oldret987 = insertvalue %ArchxAny poison, i64 %newret986, 0
  %newret988 = extractvalue { i64, i64, i64 } %t375, 1
  %oldret989 = insertvalue %ArchxAny %oldret987, i64 %newret988, 1
  %newret990 = extractvalue { i64, i64, i64 } %t375, 2
  %oldret991 = insertvalue %ArchxAny %oldret989, i64 %newret990, 2
  %np.i808 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 13, ptr nonnull @.str.7)
  %t376 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret949)
  %t377 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i810)
  store i32 1953718636, ptr %tmp.i810, align 4
  %tmp4.i812 = getelementptr inbounds nuw i8, ptr %tmp.i810, i64 4
  store i64 58, ptr %tmp4.i812, align 4
  %nul.i815 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i810, i32 0, i64 5)
  %has_nul.not.i816 = icmp eq ptr %nul.i815, null
  br i1 %has_nul.not.i816, label %fast_printf.i825, label %byte_loop.i817.preheader

byte_loop.i817.preheader:                         ; preds = %alloc.ok.76
  %pc.i822 = call i32 @putchar(i32 108)
  %pc.i822.1 = call i32 @putchar(i32 97)
  %pc.i822.2 = call i32 @putchar(i32 115)
  %pc.i822.3 = call i32 @putchar(i32 116)
  %pc.i822.4 = call i32 @putchar(i32 58)
  br label %archx_str_print.exit827

fast_printf.i825:                                 ; preds = %alloc.ok.76
  %np.i826 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 5, ptr nonnull %tmp.i810)
  br label %archx_str_print.exit827

archx_str_print.exit827:                          ; preds = %byte_loop.i817.preheader, %fast_printf.i825
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i810)
  %t378 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret991)
  %t379 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %oldret991)
  call fastcc void @archx_any_drop(%ArchxAny %oldret949)
  call fastcc void @archx_any_drop(%ArchxAny %t370.fca.2.insert)
  %len.i831 = load i64, ptr %hp.i592, align 16
  %keys_p.i833 = getelementptr inbounds nuw i8, ptr %hp.i592, i64 40
  %ctrl.i835 = load ptr, ptr %ctrl_p.i.i133, align 16
  %keys.i836 = load ptr, ptr %keys_p.i833, align 8
  %vals.i837 = load ptr, ptr %t211, align 16
  %more9.i = icmp sgt i64 %len.i831, 0
  br i1 %more9.i, label %d_elem.i, label %do_free.i839

d_elem.i:                                         ; preds = %archx_str_print.exit827, %archx_str_drop.exit.i
  %storemerge10.i = phi i64 [ %inext.i, %archx_str_drop.exit.i ], [ 0, %archx_str_print.exit827 ]
  %t0.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i836, i64 %storemerge10.i
  %t1.unpack.i = load i64, ptr %t0.i, align 8
  %t1.elt1.i = getelementptr inbounds nuw i8, ptr %t0.i, i64 8
  %t1.unpack2.i = load i64, ptr %t1.elt1.i, align 8
  %len.i.i840 = and i64 %t1.unpack.i, 4294967295
  %long.i.i = icmp samesign ult i64 %len.i.i840, 13
  %tag.i.i = and i64 %t1.unpack2.i, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond.i = select i1 %long.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond.i, label %archx_str_drop.exit.i, label %do_free.i.i

do_free.i.i:                                      ; preds = %d_elem.i
  %raw.i.i841 = and i64 %t1.unpack2.i, -2
  %ptr.i.i = inttoptr i64 %raw.i.i841 to ptr
  call void @free(ptr %ptr.i.i)
  br label %archx_str_drop.exit.i

archx_str_drop.exit.i:                            ; preds = %do_free.i.i, %d_elem.i
  %t2.i = getelementptr inbounds nuw %ArchxAny, ptr %vals.i837, i64 %storemerge10.i
  %t3.unpack.i = load i64, ptr %t2.i, align 8
  %26 = insertvalue %ArchxAny poison, i64 %t3.unpack.i, 0
  %t3.elt4.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 8
  %t3.unpack5.i = load i64, ptr %t3.elt4.i, align 8
  %27 = insertvalue %ArchxAny %26, i64 %t3.unpack5.i, 1
  %t3.elt6.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 16
  %t3.unpack7.i = load i64, ptr %t3.elt6.i, align 8
  %t38.i842 = insertvalue %ArchxAny %27, i64 %t3.unpack7.i, 2
  call fastcc void @archx_any_drop(%ArchxAny %t38.i842)
  %inext.i = add nuw nsw i64 %storemerge10.i, 1
  %exitcond.not.i843 = icmp eq i64 %inext.i, %len.i831
  br i1 %exitcond.not.i843, label %do_free.i839, label %d_elem.i

do_free.i839:                                     ; preds = %archx_str_drop.exit.i, %archx_str_print.exit827
  call void @free(ptr %ctrl.i835)
  call void @free(ptr %keys.i836)
  call void @free(ptr %vals.i837)
  call void @free(ptr %hp.i592)
  call void @free(ptr %t74)
  %vals_p.i851 = getelementptr inbounds nuw i8, ptr %hp.i, i64 48
  %vals.i852 = load ptr, ptr %vals_p.i851, align 16
  %keys_p.i853 = getelementptr inbounds nuw i8, ptr %hp.i, i64 40
  %keys.i854 = load ptr, ptr %keys_p.i853, align 8
  %ctrl.i856 = load ptr, ptr %ctrl_p.i, align 16
  call void @free(ptr %ctrl.i856)
  call void @free(ptr %keys.i854)
  call void @free(ptr %vals.i852)
  call void @free(ptr %hp.i)
  %t0.unpack.i = load i64, ptr %t0, align 16
  %t0.unpack2.i = load i64, ptr %t0.repack30, align 8
  %len.i.i857 = and i64 %t0.unpack.i, 4294967295
  %long.i.i858 = icmp samesign ult i64 %len.i.i857, 13
  %tag.i.i859 = and i64 %t0.unpack2.i, 1
  %owned.not.i.i860 = icmp eq i64 %tag.i.i859, 0
  %or.cond.i861 = select i1 %long.i.i858, i1 true, i1 %owned.not.i.i860
  br i1 %or.cond.i861, label %archx_str_drop.exit.i865, label %do_free.i.i862

do_free.i.i862:                                   ; preds = %do_free.i839
  %raw.i.i863 = and i64 %t0.unpack2.i, -2
  %ptr.i.i864 = inttoptr i64 %raw.i.i863 to ptr
  call void @free(ptr %ptr.i.i864)
  br label %archx_str_drop.exit.i865

archx_str_drop.exit.i865:                         ; preds = %do_free.i.i862, %do_free.i839
  %t0.unpack.1.i = load i64, ptr %t3, align 16
  %t0.unpack2.1.i = load i64, ptr %t3.repack31, align 8
  %len.i.1.i = and i64 %t0.unpack.1.i, 4294967295
  %long.i.1.i = icmp samesign ult i64 %len.i.1.i, 13
  %tag.i.1.i = and i64 %t0.unpack2.1.i, 1
  %owned.not.i.1.i = icmp eq i64 %tag.i.1.i, 0
  %or.cond.1.i = select i1 %long.i.1.i, i1 true, i1 %owned.not.i.1.i
  br i1 %or.cond.1.i, label %archx_str_drop.exit.1.i, label %do_free.i.1.i

do_free.i.1.i:                                    ; preds = %archx_str_drop.exit.i865
  %raw.i.1.i = and i64 %t0.unpack2.1.i, -2
  %ptr.i.1.i = inttoptr i64 %raw.i.1.i to ptr
  call void @free(ptr %ptr.i.1.i)
  br label %archx_str_drop.exit.1.i

archx_str_drop.exit.1.i:                          ; preds = %do_free.i.1.i, %archx_str_drop.exit.i865
  %t0.unpack.2.i = load i64, ptr %t4, align 16
  %t0.unpack2.2.i = load i64, ptr %t4.repack32, align 8
  %len.i.2.i = and i64 %t0.unpack.2.i, 4294967295
  %long.i.2.i = icmp samesign ult i64 %len.i.2.i, 13
  %tag.i.2.i = and i64 %t0.unpack2.2.i, 1
  %owned.not.i.2.i = icmp eq i64 %tag.i.2.i, 0
  %or.cond.2.i = select i1 %long.i.2.i, i1 true, i1 %owned.not.i.2.i
  br i1 %or.cond.2.i, label %archx_str_drop.exit.2.i, label %do_free.i.2.i

do_free.i.2.i:                                    ; preds = %archx_str_drop.exit.1.i
  %raw.i.2.i = and i64 %t0.unpack2.2.i, -2
  %ptr.i.2.i = inttoptr i64 %raw.i.2.i to ptr
  call void @free(ptr %ptr.i.2.i)
  br label %archx_str_drop.exit.2.i

archx_str_drop.exit.2.i:                          ; preds = %do_free.i.2.i, %archx_str_drop.exit.1.i
  %t0.unpack.3.i = load i64, ptr %t5, align 16
  %t0.unpack2.3.i = load i64, ptr %t5.repack33, align 8
  %len.i.3.i = and i64 %t0.unpack.3.i, 4294967295
  %long.i.3.i = icmp samesign ult i64 %len.i.3.i, 13
  %tag.i.3.i = and i64 %t0.unpack2.3.i, 1
  %owned.not.i.3.i = icmp eq i64 %tag.i.3.i, 0
  %or.cond.3.i = select i1 %long.i.3.i, i1 true, i1 %owned.not.i.3.i
  br i1 %or.cond.3.i, label %archx_str_drop.exit.3.i, label %do_free.i.3.i

do_free.i.3.i:                                    ; preds = %archx_str_drop.exit.2.i
  %raw.i.3.i = and i64 %t0.unpack2.3.i, -2
  %ptr.i.3.i = inttoptr i64 %raw.i.3.i to ptr
  call void @free(ptr %ptr.i.3.i)
  br label %archx_str_drop.exit.3.i

archx_str_drop.exit.3.i:                          ; preds = %do_free.i.3.i, %archx_str_drop.exit.2.i
  %t0.unpack.4.i = load i64, ptr %t6, align 16
  %t0.unpack2.4.i = load i64, ptr %t6.repack34, align 8
  %len.i.4.i = and i64 %t0.unpack.4.i, 4294967295
  %long.i.4.i = icmp samesign ult i64 %len.i.4.i, 13
  %tag.i.4.i = and i64 %t0.unpack2.4.i, 1
  %owned.not.i.4.i = icmp eq i64 %tag.i.4.i, 0
  %or.cond.4.i = select i1 %long.i.4.i, i1 true, i1 %owned.not.i.4.i
  br i1 %or.cond.4.i, label %archx_str_drop.exit.4.i, label %do_free.i.4.i

do_free.i.4.i:                                    ; preds = %archx_str_drop.exit.3.i
  %raw.i.4.i = and i64 %t0.unpack2.4.i, -2
  %ptr.i.4.i = inttoptr i64 %raw.i.4.i to ptr
  call void @free(ptr %ptr.i.4.i)
  br label %archx_str_drop.exit.4.i

archx_str_drop.exit.4.i:                          ; preds = %do_free.i.4.i, %archx_str_drop.exit.3.i
  %t0.unpack.5.i = load i64, ptr %t7, align 16
  %t0.unpack2.5.i = load i64, ptr %t7.repack35, align 8
  %len.i.5.i = and i64 %t0.unpack.5.i, 4294967295
  %long.i.5.i = icmp samesign ult i64 %len.i.5.i, 13
  %tag.i.5.i = and i64 %t0.unpack2.5.i, 1
  %owned.not.i.5.i = icmp eq i64 %tag.i.5.i, 0
  %or.cond.5.i = select i1 %long.i.5.i, i1 true, i1 %owned.not.i.5.i
  br i1 %or.cond.5.i, label %archx_str_drop.exit.5.i, label %do_free.i.5.i

do_free.i.5.i:                                    ; preds = %archx_str_drop.exit.4.i
  %raw.i.5.i = and i64 %t0.unpack2.5.i, -2
  %ptr.i.5.i = inttoptr i64 %raw.i.5.i to ptr
  call void @free(ptr %ptr.i.5.i)
  br label %archx_str_drop.exit.5.i

archx_str_drop.exit.5.i:                          ; preds = %do_free.i.5.i, %archx_str_drop.exit.4.i
  %t0.unpack.6.i = load i64, ptr %t8, align 16
  %t0.unpack2.6.i = load i64, ptr %t8.repack36, align 8
  %len.i.6.i = and i64 %t0.unpack.6.i, 4294967295
  %long.i.6.i = icmp samesign ult i64 %len.i.6.i, 13
  %tag.i.6.i = and i64 %t0.unpack2.6.i, 1
  %owned.not.i.6.i = icmp eq i64 %tag.i.6.i, 0
  %or.cond.6.i = select i1 %long.i.6.i, i1 true, i1 %owned.not.i.6.i
  br i1 %or.cond.6.i, label %archx_vec_drop_s.exit, label %do_free.i.6.i

do_free.i.6.i:                                    ; preds = %archx_str_drop.exit.5.i
  %raw.i.6.i = and i64 %t0.unpack2.6.i, -2
  %ptr.i.6.i = inttoptr i64 %raw.i.6.i to ptr
  call void @free(ptr %ptr.i.6.i)
  br label %archx_vec_drop_s.exit

archx_vec_drop_s.exit:                            ; preds = %archx_str_drop.exit.5.i, %do_free.i.6.i
  call void @free(ptr nonnull %t0)
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
define private fastcc void @archx_bounds_fail(i64 range(i64 -1, 4294967295) %idx, i64 %len) unnamed_addr #3 {
entry:
  %c = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.err.bounds, i64 %idx, i64 %len)
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

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @memchr(ptr captures(none), i32, i64) local_unnamed_addr #12

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #4

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #3

; Function Attrs: nofree nounwind
define private fastcc range(i64 -2147483648, 2147483650) i64 @archx_fmt_float_buf(double %x, ptr nonnull captures(none) %buf) unnamed_addr #4 {
entry:
  %n32 = tail call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf, ptr nonnull dereferenceable(1) @.fmt.g15, double %x)
  %n = sext i32 %n32 to i64
  %pos = icmp sgt i32 %n32, 0
  br i1 %pos, label %scan, label %common.ret

scan:                                             ; preds = %entry, %scan_step
  %i = phi i64 [ %inext, %scan_step ], [ 0, %entry ]
  %cp = getelementptr inbounds nuw i8, ptr %buf, i64 %i
  %ch = load i8, ptr %cp, align 1
  switch i8 %ch, label %scan_step [
    i8 110, label %common.ret
    i8 105, label %common.ret
    i8 101, label %common.ret
    i8 78, label %common.ret
    i8 73, label %common.ret
    i8 69, label %common.ret
    i8 46, label %common.ret
  ]

scan_step:                                        ; preds = %scan
  %inext = add nuw nsw i64 %i, 1
  %exitcond.not = icmp eq i64 %inext, %n
  br i1 %exitcond.not, label %append_dot0, label %scan

common.ret:                                       ; preds = %scan, %scan, %scan, %scan, %scan, %scan, %scan, %entry, %append_dot0
  %common.ret.op = phi i64 [ %n2, %append_dot0 ], [ %n, %entry ], [ %n, %scan ], [ %n, %scan ], [ %n, %scan ], [ %n, %scan ], [ %n, %scan ], [ %n, %scan ], [ %n, %scan ]
  ret i64 %common.ret.op

append_dot0:                                      ; preds = %scan_step
  %p0 = getelementptr inbounds nuw i8, ptr %buf, i64 %n
  store i8 46, ptr %p0, align 1
  %p1 = getelementptr inbounds nuw i8, ptr %p0, i64 1
  store i8 48, ptr %p1, align 1
  %n2 = add nuw nsw i64 %n, 2
  %p2 = getelementptr inbounds nuw i8, ptr %buf, i64 %n2
  store i8 0, ptr %p2, align 1
  br label %common.ret
}

; Function Attrs: nofree nounwind
declare noundef i32 @sprintf(ptr noalias noundef writeonly captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.fptosi.sat.i64.f64(double) #11

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_key_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.2)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_type_fail(ptr %msg) unnamed_addr #3 {
entry:
  %c = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.err.type, ptr %msg)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, inaccessiblemem: none)
define private fastcc i64 @archx_hash_str(%ArchxStr %s) unnamed_addr #13 {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %short = icmp samesign ult i64 %len, 13
  br i1 %short, label %sso_hash, label %long_hash

sso_hash:                                         ; preds = %entry
  %p0_raw = lshr i64 %w0, 32
  %le4 = icmp samesign ult i64 %len, 5
  br i1 %le4, label %sso_le4, label %sso_gt4

sso_le4:                                          ; preds = %sso_hash
  %sh0 = shl nuw nsw i64 %len, 3
  %notmask1 = shl nsw i64 -1, %sh0
  %m0 = xor i64 %notmask1, -1
  %p0_4 = and i64 %p0_raw, %m0
  br label %sso_mix

sso_gt4:                                          ; preds = %sso_hash
  %eq12 = icmp eq i64 %len, 12
  br i1 %eq12, label %sso_mix, label %sso_mid

sso_mid:                                          ; preds = %sso_gt4
  %rem = shl nuw nsw i64 %len, 3
  %sh1 = add nsw i64 %rem, -32
  %notmask = shl nsw i64 -1, %sh1
  %m1 = xor i64 %notmask, -1
  %p1_m = and i64 %w1, %m1
  br label %sso_mix

common.ret:                                       ; preds = %l_done, %sso_mix
  %x1.i.sink = phi i64 [ %x1.i, %l_done ], [ %x1.i11, %sso_mix ]
  %m1.i = mul i64 %x1.i.sink, -4658895280553007687
  %s2.i = lshr i64 %m1.i, 27
  %x2.i = xor i64 %s2.i, %m1.i
  %m2.i = mul i64 %x2.i, -7723592293110705685
  %s3.i = lshr i64 %m2.i, 31
  %x3.i = xor i64 %s3.i, %m2.i
  ret i64 %x3.i

sso_mix:                                          ; preds = %sso_gt4, %sso_mid, %sso_le4
  %p0 = phi i64 [ %p0_4, %sso_le4 ], [ %p0_raw, %sso_mid ], [ %p0_raw, %sso_gt4 ]
  %p1 = phi i64 [ 0, %sso_le4 ], [ %p1_m, %sso_mid ], [ %w1, %sso_gt4 ]
  %a0 = mul i64 %p0, -7046029254386353131
  %a1 = mul i64 %p1, -4417276706812531889
  %ax = xor i64 %a1, %a0
  %s1.i10 = lshr i64 %ax, 30
  %0 = xor i64 %len, %s1.i10
  %x1.i11 = xor i64 %0, %ax
  br label %common.ret

long_hash:                                        ; preds = %entry
  %raw = and i64 %w1, -4
  %ptr = inttoptr i64 %raw to ptr
  %seed = mul i64 %len, -7046029254386353131
  %1 = add nsw i64 %len, -8
  %2 = icmp ult i64 %1, 8
  br i1 %2, label %l_tail_cond.preheader.unr-lcssa, label %long_hash.new

long_hash.new:                                    ; preds = %long_hash
  %3 = lshr i64 %1, 3
  %4 = add nuw nsw i64 %3, 1
  %unroll_iter = and i64 %4, 4611686018427387902
  br label %l_body

l_tail_cond.preheader.unr-lcssa:                  ; preds = %l_body, %long_hash
  %acc_next.lcssa.ph = phi i64 [ poison, %long_hash ], [ %acc_next.1, %l_body ]
  %idx_next.lcssa.ph = phi i64 [ poison, %long_hash ], [ %idx_next.1, %l_body ]
  %acc19.unr = phi i64 [ %seed, %long_hash ], [ %acc_next.1, %l_body ]
  %idx18.unr = phi i64 [ 0, %long_hash ], [ %idx_next.1, %l_body ]
  %5 = and i64 %1, 8
  %lcmp.mod.not.not = icmp eq i64 %5, 0
  br i1 %lcmp.mod.not.not, label %l_body.epil, label %l_tail_cond.preheader

l_body.epil:                                      ; preds = %l_tail_cond.preheader.unr-lcssa
  %lp.epil = getelementptr inbounds nuw i8, ptr %ptr, i64 %idx18.unr
  %lane.epil = load i64, ptr %lp.epil, align 4
  %lm.epil = mul i64 %lane.epil, -4417276706812531889
  %lx.epil = xor i64 %lm.epil, %acc19.unr
  %s1.i2.epil = lshr i64 %lx.epil, 30
  %x1.i3.epil = xor i64 %s1.i2.epil, %lx.epil
  %m1.i4.epil = mul i64 %x1.i3.epil, -4658895280553007687
  %s2.i5.epil = lshr i64 %m1.i4.epil, 27
  %x2.i6.epil = xor i64 %s2.i5.epil, %m1.i4.epil
  %m2.i7.epil = mul i64 %x2.i6.epil, -7723592293110705685
  %s3.i8.epil = lshr i64 %m2.i7.epil, 31
  %x3.i9.epil = xor i64 %s3.i8.epil, %m2.i7.epil
  %acc_next.epil = add i64 %x3.i9.epil, %idx18.unr
  %idx_next.epil = add nuw nsw i64 %idx18.unr, 8
  br label %l_tail_cond.preheader

l_tail_cond.preheader:                            ; preds = %l_tail_cond.preheader.unr-lcssa, %l_body.epil
  %acc_next.lcssa = phi i64 [ %acc_next.lcssa.ph, %l_tail_cond.preheader.unr-lcssa ], [ %acc_next.epil, %l_body.epil ]
  %idx_next.lcssa = phi i64 [ %idx_next.lcssa.ph, %l_tail_cond.preheader.unr-lcssa ], [ %idx_next.epil, %l_body.epil ]
  %tmore20 = icmp samesign ult i64 %idx_next.lcssa, %len
  br i1 %tmore20, label %l_tail_body.preheader, label %l_done

l_tail_body.preheader:                            ; preds = %l_tail_cond.preheader
  %6 = sub i64 %w0, %idx_next.lcssa
  %xtraiter27 = and i64 %6, 3
  %lcmp.mod28.not = icmp eq i64 %xtraiter27, 0
  br i1 %lcmp.mod28.not, label %l_tail_body.prol.loopexit, label %l_tail_body.prol

l_tail_body.prol:                                 ; preds = %l_tail_body.preheader, %l_tail_body.prol
  %tacc22.prol = phi i64 [ %tacc_next.prol, %l_tail_body.prol ], [ %acc_next.lcssa, %l_tail_body.preheader ]
  %ti21.prol = phi i64 [ %ti_next.prol, %l_tail_body.prol ], [ %idx_next.lcssa, %l_tail_body.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %l_tail_body.prol ], [ 0, %l_tail_body.preheader ]
  %tp.prol = getelementptr inbounds nuw i8, ptr %ptr, i64 %ti21.prol
  %tb.prol = load i8, ptr %tp.prol, align 1
  %tz.prol = zext i8 %tb.prol to i64
  %tx.prol = xor i64 %tacc22.prol, %tz.prol
  %tacc_next.prol = mul i64 %tx.prol, 1099511628211
  %ti_next.prol = add nuw nsw i64 %ti21.prol, 1
  %prol.iter.next = add i64 %prol.iter, 1
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter27
  br i1 %prol.iter.cmp.not, label %l_tail_body.prol.loopexit, label %l_tail_body.prol, !llvm.loop !0

l_tail_body.prol.loopexit:                        ; preds = %l_tail_body.prol, %l_tail_body.preheader
  %tacc22.unr = phi i64 [ %acc_next.lcssa, %l_tail_body.preheader ], [ %tacc_next.prol, %l_tail_body.prol ]
  %ti21.unr = phi i64 [ %idx_next.lcssa, %l_tail_body.preheader ], [ %ti_next.prol, %l_tail_body.prol ]
  %tacc_next.lcssa.unr = phi i64 [ poison, %l_tail_body.preheader ], [ %tacc_next.prol, %l_tail_body.prol ]
  %7 = sub i64 %idx_next.lcssa, %len
  %8 = icmp ugt i64 %7, -4
  br i1 %8, label %l_done, label %l_tail_body.preheader.new

l_tail_body.preheader.new:                        ; preds = %l_tail_body.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr, i64 1
  %invariant.gep29 = getelementptr i8, ptr %ptr, i64 2
  %invariant.gep31 = getelementptr i8, ptr %ptr, i64 3
  br label %l_tail_body

l_body:                                           ; preds = %l_body, %long_hash.new
  %acc19 = phi i64 [ %seed, %long_hash.new ], [ %acc_next.1, %l_body ]
  %idx18 = phi i64 [ 0, %long_hash.new ], [ %idx_next.1, %l_body ]
  %niter = phi i64 [ 0, %long_hash.new ], [ %niter.next.1, %l_body ]
  %lp = getelementptr inbounds nuw i8, ptr %ptr, i64 %idx18
  %lane = load i64, ptr %lp, align 4
  %lm = mul i64 %lane, -4417276706812531889
  %lx = xor i64 %lm, %acc19
  %s1.i2 = lshr i64 %lx, 30
  %x1.i3 = xor i64 %s1.i2, %lx
  %m1.i4 = mul i64 %x1.i3, -4658895280553007687
  %s2.i5 = lshr i64 %m1.i4, 27
  %x2.i6 = xor i64 %s2.i5, %m1.i4
  %m2.i7 = mul i64 %x2.i6, -7723592293110705685
  %s3.i8 = lshr i64 %m2.i7, 31
  %x3.i9 = xor i64 %s3.i8, %m2.i7
  %acc_next = add i64 %x3.i9, %idx18
  %idx_next = or disjoint i64 %idx18, 8
  %lp.1 = getelementptr inbounds nuw i8, ptr %ptr, i64 %idx_next
  %lane.1 = load i64, ptr %lp.1, align 4
  %lm.1 = mul i64 %lane.1, -4417276706812531889
  %lx.1 = xor i64 %lm.1, %acc_next
  %s1.i2.1 = lshr i64 %lx.1, 30
  %x1.i3.1 = xor i64 %s1.i2.1, %lx.1
  %m1.i4.1 = mul i64 %x1.i3.1, -4658895280553007687
  %s2.i5.1 = lshr i64 %m1.i4.1, 27
  %x2.i6.1 = xor i64 %s2.i5.1, %m1.i4.1
  %m2.i7.1 = mul i64 %x2.i6.1, -7723592293110705685
  %s3.i8.1 = lshr i64 %m2.i7.1, 31
  %x3.i9.1 = xor i64 %s3.i8.1, %m2.i7.1
  %acc_next.1 = add i64 %x3.i9.1, %idx_next
  %idx_next.1 = add nuw nsw i64 %idx18, 16
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1.not = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1.not, label %l_tail_cond.preheader.unr-lcssa, label %l_body

l_tail_body:                                      ; preds = %l_tail_body, %l_tail_body.preheader.new
  %tacc22 = phi i64 [ %tacc22.unr, %l_tail_body.preheader.new ], [ %tacc_next.3, %l_tail_body ]
  %ti21 = phi i64 [ %ti21.unr, %l_tail_body.preheader.new ], [ %ti_next.3, %l_tail_body ]
  %tp = getelementptr inbounds nuw i8, ptr %ptr, i64 %ti21
  %tb = load i8, ptr %tp, align 1
  %tz = zext i8 %tb to i64
  %tx = xor i64 %tacc22, %tz
  %tacc_next = mul i64 %tx, 1099511628211
  %gep = getelementptr i8, ptr %invariant.gep, i64 %ti21
  %tb.1 = load i8, ptr %gep, align 1
  %tz.1 = zext i8 %tb.1 to i64
  %tx.1 = xor i64 %tacc_next, %tz.1
  %tacc_next.1 = mul i64 %tx.1, 1099511628211
  %gep30 = getelementptr i8, ptr %invariant.gep29, i64 %ti21
  %tb.2 = load i8, ptr %gep30, align 1
  %tz.2 = zext i8 %tb.2 to i64
  %tx.2 = xor i64 %tacc_next.1, %tz.2
  %tacc_next.2 = mul i64 %tx.2, 1099511628211
  %gep32 = getelementptr i8, ptr %invariant.gep31, i64 %ti21
  %tb.3 = load i8, ptr %gep32, align 1
  %tz.3 = zext i8 %tb.3 to i64
  %tx.3 = xor i64 %tacc_next.2, %tz.3
  %tacc_next.3 = mul i64 %tx.3, 1099511628211
  %ti_next.3 = add nuw nsw i64 %ti21, 4
  %tmore.3 = icmp samesign ult i64 %ti_next.3, %len
  br i1 %tmore.3, label %l_tail_body, label %l_done

l_done:                                           ; preds = %l_tail_body.prol.loopexit, %l_tail_body, %l_tail_cond.preheader
  %tacc.lcssa = phi i64 [ %acc_next.lcssa, %l_tail_cond.preheader ], [ %tacc_next.lcssa.unr, %l_tail_body.prol.loopexit ], [ %tacc_next.3, %l_tail_body ]
  %s1.i = lshr i64 %tacc.lcssa, 30
  %x1.i = xor i64 %s1.i, %tacc.lcssa
  br label %common.ret
}

; Function Attrs: nofree nounwind
define private fastcc i64 @archx_dict_key_hash_at(ptr readonly captures(none) %keys, i64 %idx, i64 range(i64 0, 256) %kind) unnamed_addr #4 {
entry:
  %trunc = trunc nuw i64 %kind to i8
  switch i8 %trunc, label %k_any [
    i8 0, label %k_i64
    i8 1, label %k_str
  ]

common.ret:                                       ; preds = %h_str.i, %h_flt.i, %h_i64.i, %k_any, %k_str, %k_i64
  %common.ret.op = phi i64 [ %x3.i, %k_i64 ], [ %hs, %k_str ], [ %x3.i8.i, %h_i64.i ], [ %x3.i.i, %h_flt.i ], [ %hs.i, %h_str.i ], [ 5871781006564002453, %k_any ]
  ret i64 %common.ret.op

k_i64:                                            ; preds = %entry
  %pi = getelementptr inbounds i64, ptr %keys, i64 %idx
  %vi = load i64, ptr %pi, align 8
  %s1.i = lshr i64 %vi, 30
  %x1.i = xor i64 %s1.i, %vi
  %m1.i = mul i64 %x1.i, -4658895280553007687
  %s2.i = lshr i64 %m1.i, 27
  %x2.i = xor i64 %s2.i, %m1.i
  %m2.i = mul i64 %x2.i, -7723592293110705685
  %s3.i = lshr i64 %m2.i, 31
  %x3.i = xor i64 %s3.i, %m2.i
  br label %common.ret

k_any:                                            ; preds = %entry
  %pa = getelementptr inbounds %ArchxAny, ptr %keys, i64 %idx
  %va.unpack = load i64, ptr %pa, align 8
  %va.elt4 = getelementptr inbounds nuw i8, ptr %pa, i64 8
  %va.unpack5 = load i64, ptr %va.elt4, align 8
  %va.elt6 = getelementptr inbounds nuw i8, ptr %pa, i64 16
  %va.unpack7 = load i64, ptr %va.elt6, align 8
  %is0.i = icmp eq i64 %va.unpack, 0
  br i1 %is0.i, label %common.ret, label %chk_int.i

chk_int.i:                                        ; preds = %k_any
  %le2.i = icmp ult i64 %va.unpack, 3
  br i1 %le2.i, label %h_i64.i, label %chk_flt.i

h_i64.i:                                          ; preds = %chk_int.i
  %s1.i1.i = lshr i64 %va.unpack5, 30
  %x1.i2.i = xor i64 %s1.i1.i, %va.unpack5
  %m1.i3.i = mul i64 %x1.i2.i, -4658895280553007687
  %s2.i4.i = lshr i64 %m1.i3.i, 27
  %x2.i5.i = xor i64 %s2.i4.i, %m1.i3.i
  %m2.i6.i = mul i64 %x2.i5.i, -7723592293110705685
  %s3.i7.i = lshr i64 %m2.i6.i, 31
  %x3.i8.i = xor i64 %s3.i7.i, %m2.i6.i
  br label %common.ret

chk_flt.i:                                        ; preds = %chk_int.i
  switch i64 %va.unpack, label %unhash.i [
    i64 3, label %h_flt.i
    i64 4, label %h_str.i
  ]

h_flt.i:                                          ; preds = %chk_flt.i
  %fv.i = bitcast i64 %va.unpack5 to double
  %iv.i = tail call i64 @llvm.fptosi.sat.i64.f64(double %fv.i)
  %back.i = sitofp i64 %iv.i to double
  %exact.i = fcmp oeq double %fv.i, %back.i
  %hkey.i = select i1 %exact.i, i64 %iv.i, i64 %va.unpack5
  %s1.i.i = lshr i64 %hkey.i, 30
  %x1.i.i = xor i64 %s1.i.i, %hkey.i
  %m1.i.i = mul i64 %x1.i.i, -4658895280553007687
  %s2.i.i = lshr i64 %m1.i.i, 27
  %x2.i.i = xor i64 %s2.i.i, %m1.i.i
  %m2.i.i = mul i64 %x2.i.i, -7723592293110705685
  %s3.i.i = lshr i64 %m2.i.i, 31
  %x3.i.i = xor i64 %s3.i.i, %m2.i.i
  br label %common.ret

h_str.i:                                          ; preds = %chk_flt.i
  %s0.i = insertvalue %ArchxStr poison, i64 %va.unpack5, 0
  %s1.i9 = insertvalue %ArchxStr %s0.i, i64 %va.unpack7, 1
  %hs.i = tail call fastcc i64 @archx_hash_str(%ArchxStr %s1.i9)
  br label %common.ret

unhash.i:                                         ; preds = %chk_flt.i
  tail call fastcc void @archx_type_fail(ptr nonnull @.any.unhash)
  unreachable

k_str:                                            ; preds = %entry
  %ps = getelementptr inbounds %ArchxStr, ptr %keys, i64 %idx
  %vs.unpack = load i64, ptr %ps, align 8
  %0 = insertvalue %ArchxStr poison, i64 %vs.unpack, 0
  %vs.elt1 = getelementptr inbounds nuw i8, ptr %ps, i64 8
  %vs.unpack2 = load i64, ptr %vs.elt1, align 8
  %vs3 = insertvalue %ArchxStr %0, i64 %vs.unpack2, 1
  %hs = tail call fastcc i64 @archx_hash_str(%ArchxStr %vs3)
  br label %common.ret
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
  %kind = and i64 %meta, 255
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
  br i1 %has_old_k, label %alloc_done.thread, label %alloc_done.thread66

alloc_done.thread66:                              ; preds = %archx_region_alloc.exit
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
  %more50 = icmp sgt i64 %len, 0
  br i1 %more50, label %rehash_item.lr.ph, label %rehash_done

rehash_item.lr.ph:                                ; preds = %alloc_done.thread, %alloc_done
  %new_vals64 = phi ptr [ %common.ret.op.i, %alloc_done.thread ], [ %new_vals, %alloc_done ]
  %new_keys61 = phi ptr [ %common.ret.op.i16, %alloc_done.thread ], [ %new_keys, %alloc_done ]
  %new_ctrl59 = phi ptr [ %common.ret.op.i36, %alloc_done.thread ], [ %new_ctrl, %alloc_done ]
  %idx_base65 = getelementptr inbounds i8, ptr %new_ctrl59, i64 %ctrl_init_len
  %0 = getelementptr i8, ptr %new_ctrl59, i64 %new_scap
  br label %rehash_item

rehash_item:                                      ; preds = %rehash_item.lr.ph, %archx_dict_set_ctrl.exit
  %i51 = phi i64 [ 0, %rehash_item.lr.ph ], [ %i_next, %archx_dict_set_ctrl.exit ]
  %h = tail call fastcc i64 @archx_dict_key_hash_at(ptr nonnull %new_keys61, i64 %i51, i64 %kind)
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc nuw nsw i64 %h2_64 to i8
  %pos41 = and i64 %h, %new_mask
  %gp42 = getelementptr inbounds i8, ptr %new_ctrl59, i64 %pos41
  %grp43 = load <16 x i8>, ptr %gp42, align 1
  %ecmp44 = icmp eq <16 x i8> %grp43, splat (i8 -128)
  %ebits45 = bitcast <16 x i1> %ecmp44 to i16
  %has_e.not46 = icmp eq i16 %ebits45, 0
  br i1 %has_e.not46, label %rprobe_next, label %rehash_put

rprobe_next:                                      ; preds = %rehash_item, %rprobe_next
  %pos48 = phi i64 [ %pos, %rprobe_next ], [ %pos41, %rehash_item ]
  %step47 = phi i64 [ %step_next, %rprobe_next ], [ 0, %rehash_item ]
  %step_next = add i64 %step47, 16
  %padd = add i64 %step_next, %pos48
  %pos = and i64 %padd, %new_mask
  %gp = getelementptr inbounds i8, ptr %new_ctrl59, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %ecmp = icmp eq <16 x i8> %grp, splat (i8 -128)
  %ebits = bitcast <16 x i1> %ecmp to i16
  %has_e.not = icmp eq i16 %ebits, 0
  br i1 %has_e.not, label %rprobe_next, label %rehash_put

rehash_put:                                       ; preds = %rprobe_next, %rehash_item
  %pos.lcssa = phi i64 [ %pos41, %rehash_item ], [ %pos, %rprobe_next ]
  %ebits.lcssa = phi i16 [ %ebits45, %rehash_item ], [ %ebits, %rprobe_next ]
  %1 = tail call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %ebits.lcssa, i1 true)
  %tz64 = zext nneg i16 %1 to i64
  %s_add = add i64 %pos.lcssa, %tz64
  %slot = and i64 %s_add, %new_mask
  %p.i = getelementptr inbounds i8, ptr %new_ctrl59, i64 %slot
  store i8 %h2, ptr %p.i, align 1
  %mir.i = icmp ult i64 %slot, 16
  br i1 %mir.i, label %do_mir.i, label %archx_dict_set_ctrl.exit

do_mir.i:                                         ; preds = %rehash_put
  %mp.i = getelementptr i8, ptr %0, i64 %slot
  store i8 %h2, ptr %mp.i, align 1
  br label %archx_dict_set_ctrl.exit

archx_dict_set_ctrl.exit:                         ; preds = %rehash_put, %do_mir.i
  %ip = getelementptr inbounds i32, ptr %idx_base65, i64 %slot
  %i32v = trunc i64 %i51 to i32
  store i32 %i32v, ptr %ip, align 4
  %i_next = add nuw nsw i64 %i51, 1
  %exitcond.not = icmp eq i64 %i_next, %len
  br i1 %exitcond.not, label %rehash_done, label %rehash_item

rehash_done:                                      ; preds = %archx_dict_set_ctrl.exit, %alloc_done.thread66, %alloc_done
  %new_vals63 = phi ptr [ %new_vals, %alloc_done ], [ %common.ret.op.i, %alloc_done.thread66 ], [ %new_vals64, %archx_dict_set_ctrl.exit ]
  %new_keys62 = phi ptr [ %new_keys, %alloc_done ], [ %common.ret.op.i16, %alloc_done.thread66 ], [ %new_keys61, %archx_dict_set_ctrl.exit ]
  %new_ctrl60 = phi ptr [ %new_ctrl, %alloc_done ], [ %common.ret.op.i36, %alloc_done.thread66 ], [ %new_ctrl59, %archx_dict_set_ctrl.exit ]
  %used_p = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  store i64 %len, ptr %used_p, align 8
  store i64 %new_mask, ptr %mask_p, align 8
  store ptr %new_ctrl60, ptr %ctrl_p, align 8
  store ptr %new_keys62, ptr %keys_p, align 8
  store ptr %new_vals63, ptr %vals_p, align 8
  ret void
}

; Function Attrs: nounwind
define private fastcc void @archx_dict_upsert_i64(i64 range(i64 1, 0) %d, i64 %key) unnamed_addr #0 {
entry:
  %s1.i = lshr i64 %key, 30
  %x1.i = xor i64 %s1.i, %key
  %m1.i = mul i64 %x1.i, -4658895280553007687
  %s2.i = lshr i64 %m1.i, 27
  %x2.i = xor i64 %s2.i, %m1.i
  %m2.i = mul i64 %x2.i, -7723592293110705685
  %s3.i = lshr i64 %m2.i, 31
  %x3.i = xor i64 %s3.i, %m2.i
  %raw = and i64 %d, -4
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds nuw i8, ptr %hdr, i64 32
  %ctrl0 = load ptr, ptr %ctrl_p, align 8
  %uninit = icmp eq ptr %ctrl0, null
  br i1 %uninit, label %probe_insert_init.sink.split, label %chk_probe_existing

chk_probe_existing:                               ; preds = %entry
  %is_z.i = icmp eq i64 %raw, 0
  br i1 %is_z.i, label %chk_cap, label %do_probe.i

do_probe.i:                                       ; preds = %chk_probe_existing
  %mask_p.i = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %keys_p.i = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %mask.i = load i64, ptr %mask_p.i, align 8
  %keys.i = load ptr, ptr %keys_p.i, align 8
  %0 = getelementptr i8, ptr %ctrl0, i64 %mask.i
  %idx_base.i = getelementptr i8, ptr %0, i64 17
  %h2_64.i = lshr i64 %m2.i, 57
  %h2.i = trunc nuw nsw i64 %h2_64.i to i8
  %h2_ins.i = insertelement <16 x i8> poison, i8 %h2.i, i64 0
  %h2_vec.i = shufflevector <16 x i8> %h2_ins.i, <16 x i8> poison, <16 x i32> zeroinitializer
  br label %probe.i

probe.i:                                          ; preds = %next_grp.i, %do_probe.i
  %h.pn.i = phi i64 [ %x3.i, %do_probe.i ], [ %padd.i, %next_grp.i ]
  %step.i = phi i64 [ 0, %do_probe.i ], [ %step_next.i, %next_grp.i ]
  %pos.i = and i64 %h.pn.i, %mask.i
  %gp.i = getelementptr inbounds i8, ptr %ctrl0, i64 %pos.i
  %grp.i = load <16 x i8>, ptr %gp.i, align 1
  %mcmp.i = icmp eq <16 x i8> %grp.i, %h2_vec.i
  %mbits.i = bitcast <16 x i1> %mcmp.i to i16
  %has_m.not.i3 = icmp eq i16 %mbits.i, 0
  br i1 %has_m.not.i3, label %chk_empty.i, label %chk_key.i.preheader

chk_key.i.preheader:                              ; preds = %probe.i
  %mmask0.i = zext i16 %mbits.i to i32
  br label %chk_key.i

chk_key.i:                                        ; preds = %chk_key.i.preheader, %mbit_cont.i
  %mmask.i4 = phi i32 [ %mmask_next.i, %mbit_cont.i ], [ %mmask0.i, %chk_key.i.preheader ]
  %tz.i = tail call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i4, i1 true)
  %tz64.i = zext nneg i32 %tz.i to i64
  %s_add.i = add i64 %pos.i, %tz64.i
  %slot.i = and i64 %s_add.i, %mask.i
  %ip.i = getelementptr inbounds i32, ptr %idx_base.i, i64 %slot.i
  %didx32.i = load i32, ptr %ip.i, align 4
  %didx.i = zext i32 %didx32.i to i64
  %kp.i = getelementptr inbounds nuw i64, ptr %keys.i, i64 %didx.i
  %cand_k.i = load i64, ptr %kp.i, align 8
  %eq.i = icmp eq i64 %cand_k.i, %key
  br i1 %eq.i, label %common.ret, label %mbit_cont.i

mbit_cont.i:                                      ; preds = %chk_key.i
  %mm1.i = add nsw i32 %mmask.i4, -1
  %mmask_next.i = and i32 %mm1.i, %mmask.i4
  %has_m.not.i = icmp eq i32 %mmask_next.i, 0
  br i1 %has_m.not.i, label %chk_empty.i, label %chk_key.i

chk_empty.i:                                      ; preds = %mbit_cont.i, %probe.i
  %ecmp.i = icmp eq <16 x i8> %grp.i, splat (i8 -128)
  %ebits.i = bitcast <16 x i1> %ecmp.i to i16
  %has_e.not.i = icmp eq i16 %ebits.i, 0
  br i1 %has_e.not.i, label %next_grp.i, label %chk_cap

next_grp.i:                                       ; preds = %chk_empty.i
  %step_next.i = add i64 %step.i, 16
  %padd.i = add i64 %step_next.i, %pos.i
  br label %probe.i

common.ret:                                       ; preds = %chk_key.i, %archx_dict_set_ctrl.exit
  ret void

chk_cap:                                          ; preds = %chk_empty.i, %chk_probe_existing
  %used_p = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %used0 = load i64, ptr %used_p, align 8
  %mask0 = load i64, ptr %mask_p, align 8
  %u1 = shl i64 %used0, 3
  %lhs = add i64 %u1, 8
  %1 = mul i64 %mask0, 7
  %rhs = add i64 %1, 7
  %full = icmp sgt i64 %lhs, %rhs
  br i1 %full, label %probe_insert_init.sink.split, label %probe_insert_init

probe_insert_init.sink.split:                     ; preds = %chk_cap, %entry
  tail call fastcc void @archx_dict_grow(ptr nonnull %hdr)
  br label %probe_insert_init

probe_insert_init:                                ; preds = %probe_insert_init.sink.split, %chk_cap
  %used_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %keys_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %mask = load i64, ptr %mask_p2, align 8
  %keys = load ptr, ptr %keys_p2, align 8
  %2 = getelementptr i8, ptr %ctrl, i64 %mask
  %idx_base = getelementptr i8, ptr %2, i64 17
  %h2_64 = lshr i64 %m2.i, 57
  %h2 = trunc nuw nsw i64 %h2_64 to i8
  %pos5 = and i64 %x3.i, %mask
  %gp6 = getelementptr inbounds i8, ptr %ctrl, i64 %pos5
  %grp7 = load <16 x i8>, ptr %gp6, align 1
  %avail_cmp8 = icmp slt <16 x i8> %grp7, zeroinitializer
  %abits9 = bitcast <16 x i1> %avail_cmp8 to i16
  %has_a.not10 = icmp eq i16 %abits9, 0
  br i1 %has_a.not10, label %inext, label %iput

inext:                                            ; preds = %probe_insert_init, %inext
  %pos12 = phi i64 [ %pos, %inext ], [ %pos5, %probe_insert_init ]
  %step11 = phi i64 [ %step_next, %inext ], [ 0, %probe_insert_init ]
  %step_next = add i64 %step11, 16
  %padd = add i64 %step_next, %pos12
  %pos = and i64 %padd, %mask
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %avail_cmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits = bitcast <16 x i1> %avail_cmp to i16
  %has_a.not = icmp eq i16 %abits, 0
  br i1 %has_a.not, label %inext, label %iput

iput:                                             ; preds = %inext, %probe_insert_init
  %pos.lcssa = phi i64 [ %pos5, %probe_insert_init ], [ %pos, %inext ]
  %abits.lcssa = phi i16 [ %abits9, %probe_insert_init ], [ %abits, %inext ]
  %3 = tail call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits.lcssa, i1 true)
  %tz64 = zext nneg i16 %3 to i64
  %s_add = add i64 %pos.lcssa, %tz64
  %slot = and i64 %s_add, %mask
  %sp_c = getelementptr inbounds i8, ptr %ctrl, i64 %slot
  %old_cb = load i8, ptr %sp_c, align 1
  %was_empty = icmp eq i8 %old_cb, -128
  %u_cur = load i64, ptr %used_p2, align 8
  %u_inc = zext i1 %was_empty to i64
  %u_new = add i64 %u_cur, %u_inc
  store i64 %u_new, ptr %used_p2, align 8
  store i8 %h2, ptr %sp_c, align 1
  %mir.i = icmp ult i64 %slot, 16
  br i1 %mir.i, label %do_mir.i, label %archx_dict_set_ctrl.exit

do_mir.i:                                         ; preds = %iput
  %4 = getelementptr i8, ptr %2, i64 1
  %mp.i = getelementptr i8, ptr %4, i64 %slot
  store i8 %h2, ptr %mp.i, align 1
  br label %archx_dict_set_ctrl.exit

archx_dict_set_ctrl.exit:                         ; preds = %iput, %do_mir.i
  %d_idx = load i64, ptr %hdr, align 8
  %d_new = add i64 %d_idx, 1
  store i64 %d_new, ptr %hdr, align 8
  %ip = getelementptr inbounds i32, ptr %idx_base, i64 %slot
  %d_idx32 = trunc i64 %d_idx to i32
  store i32 %d_idx32, ptr %ip, align 4
  %kp = getelementptr inbounds i64, ptr %keys, i64 %d_idx
  store i64 %key, ptr %kp, align 8
  br label %common.ret
}

; Function Attrs: nounwind
define private fastcc { i64, i1 } @archx_dict_upsert_str(i64 range(i64 1, 0) %d, %ArchxStr %key) unnamed_addr #0 {
entry:
  %h = tail call fastcc i64 @archx_hash_str(%ArchxStr %key)
  %raw = and i64 %d, -4
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds nuw i8, ptr %hdr, i64 32
  %ctrl0 = load ptr, ptr %ctrl_p, align 8
  %uninit = icmp eq ptr %ctrl0, null
  br i1 %uninit, label %probe_insert_init.sink.split, label %chk_probe_existing

chk_probe_existing:                               ; preds = %entry
  %is_z.i = icmp eq i64 %raw, 0
  br i1 %is_z.i, label %chk_cap, label %do_probe.i

do_probe.i:                                       ; preds = %chk_probe_existing
  %mask_p.i = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %keys_p.i = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %mask.i = load i64, ptr %mask_p.i, align 8
  %keys.i = load ptr, ptr %keys_p.i, align 8
  %0 = getelementptr i8, ptr %ctrl0, i64 %mask.i
  %idx_base.i = getelementptr i8, ptr %0, i64 17
  %h2_64.i = lshr i64 %h, 57
  %h2.i = trunc nuw nsw i64 %h2_64.i to i8
  %h2_ins.i = insertelement <16 x i8> poison, i8 %h2.i, i64 0
  %h2_vec.i = shufflevector <16 x i8> %h2_ins.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bw0.i = extractvalue %ArchxStr %key, 0
  %bw1.i = extractvalue %ArchxStr %key, 1
  %bp_i.i = and i64 %bw1.i, -4
  %bp.i = inttoptr i64 %bp_i.i to ptr
  %bp4.i = getelementptr inbounds nuw i8, ptr %bp.i, i64 4
  %len.i = and i64 %bw0.i, 4294967295
  %short.i = icmp samesign ult i64 %len.i, 13
  %rem.i = add nsw i64 %len.i, -4
  br label %probe.i

probe.i:                                          ; preds = %next_grp.i, %do_probe.i
  %h.pn.i = phi i64 [ %h, %do_probe.i ], [ %padd.i, %next_grp.i ]
  %step.i = phi i64 [ 0, %do_probe.i ], [ %step_next.i, %next_grp.i ]
  %pos.i = and i64 %h.pn.i, %mask.i
  %gp.i = getelementptr inbounds i8, ptr %ctrl0, i64 %pos.i
  %grp.i = load <16 x i8>, ptr %gp.i, align 1
  %mcmp.i = icmp eq <16 x i8> %grp.i, %h2_vec.i
  %mbits.i = bitcast <16 x i1> %mcmp.i to i16
  %has_m.not.i11 = icmp eq i16 %mbits.i, 0
  br i1 %has_m.not.i11, label %chk_empty.i, label %chk_key.i.preheader

chk_key.i.preheader:                              ; preds = %probe.i
  %mmask0.i = zext i16 %mbits.i to i32
  br label %chk_key.i

chk_key.i:                                        ; preds = %chk_key.i.preheader, %mbit_cont.i
  %mmask.i12 = phi i32 [ %mmask_next.i, %mbit_cont.i ], [ %mmask0.i, %chk_key.i.preheader ]
  %tz.i = tail call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i12, i1 true)
  %tz64.i = zext nneg i32 %tz.i to i64
  %s_add.i = add i64 %pos.i, %tz64.i
  %slot.i = and i64 %s_add.i, %mask.i
  %ip.i = getelementptr inbounds i32, ptr %idx_base.i, i64 %slot.i
  %didx32.i = load i32, ptr %ip.i, align 4
  %didx.i = zext i32 %didx32.i to i64
  %kp.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i, i64 %didx.i
  %cand_k.unpack.i = load i64, ptr %kp.i, align 8
  %cand_k.elt1.i = getelementptr inbounds nuw i8, ptr %kp.i, i64 8
  %cand_k.unpack2.i = load i64, ptr %cand_k.elt1.i, align 8
  %w0_eq.i = icmp eq i64 %cand_k.unpack.i, %bw0.i
  br i1 %w0_eq.i, label %chk_len.i, label %mbit_cont.i

chk_len.i:                                        ; preds = %chk_key.i
  br i1 %short.i, label %cmp_short.i, label %cmp_long.i

cmp_short.i:                                      ; preds = %chk_len.i
  %eq_s.i = icmp eq i64 %cand_k.unpack2.i, %bw1.i
  br i1 %eq_s.i, label %common.ret, label %mbit_cont.i

cmp_long.i:                                       ; preds = %chk_len.i
  %ap_i.i = and i64 %cand_k.unpack2.i, -4
  %same_ptr.i = icmp eq i64 %ap_i.i, %bp_i.i
  br i1 %same_ptr.i, label %common.ret, label %archx_str_eq.exit

archx_str_eq.exit:                                ; preds = %cmp_long.i
  %ap.i = inttoptr i64 %ap_i.i to ptr
  %ap4.i = getelementptr inbounds nuw i8, ptr %ap.i, i64 4
  %bcmp.i = tail call i32 @bcmp(ptr nonnull %ap4.i, ptr nonnull %bp4.i, i64 %rem.i)
  %eq_m.i = icmp eq i32 %bcmp.i, 0
  br i1 %eq_m.i, label %common.ret, label %mbit_cont.i

mbit_cont.i:                                      ; preds = %chk_key.i, %cmp_short.i, %archx_str_eq.exit
  %mm1.i = add nsw i32 %mmask.i12, -1
  %mmask_next.i = and i32 %mm1.i, %mmask.i12
  %has_m.not.i = icmp eq i32 %mmask_next.i, 0
  br i1 %has_m.not.i, label %chk_empty.i, label %chk_key.i

chk_empty.i:                                      ; preds = %mbit_cont.i, %probe.i
  %ecmp.i = icmp eq <16 x i8> %grp.i, splat (i8 -128)
  %ebits.i = bitcast <16 x i1> %ecmp.i to i16
  %has_e.not.i = icmp eq i16 %ebits.i, 0
  br i1 %has_e.not.i, label %next_grp.i, label %chk_cap

next_grp.i:                                       ; preds = %chk_empty.i
  %step_next.i = add i64 %step.i, 16
  %padd.i = add i64 %step_next.i, %pos.i
  br label %probe.i

common.ret:                                       ; preds = %archx_str_eq.exit, %cmp_short.i, %cmp_long.i, %archx_str_clone.exit
  %found_idx.pn = phi i64 [ %d_idx, %archx_str_clone.exit ], [ %didx.i, %cmp_long.i ], [ %didx.i, %cmp_short.i ], [ %didx.i, %archx_str_eq.exit ]
  %.pn = phi i1 [ false, %archx_str_clone.exit ], [ true, %cmp_long.i ], [ true, %cmp_short.i ], [ true, %archx_str_eq.exit ]
  %re0.pn = insertvalue { i64, i1 } poison, i64 %found_idx.pn, 0
  %common.ret.op = insertvalue { i64, i1 } %re0.pn, i1 %.pn, 1
  ret { i64, i1 } %common.ret.op

chk_cap:                                          ; preds = %chk_empty.i, %chk_probe_existing
  %used_p = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %used0 = load i64, ptr %used_p, align 8
  %mask0 = load i64, ptr %mask_p, align 8
  %u1 = shl i64 %used0, 3
  %lhs = add i64 %u1, 8
  %1 = mul i64 %mask0, 7
  %rhs = add i64 %1, 7
  %full = icmp sgt i64 %lhs, %rhs
  br i1 %full, label %probe_insert_init.sink.split, label %probe_insert_init

probe_insert_init.sink.split:                     ; preds = %chk_cap, %entry
  tail call fastcc void @archx_dict_grow(ptr nonnull %hdr)
  br label %probe_insert_init

probe_insert_init:                                ; preds = %probe_insert_init.sink.split, %chk_cap
  %used_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %keys_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %mask = load i64, ptr %mask_p2, align 8
  %keys = load ptr, ptr %keys_p2, align 8
  %2 = getelementptr i8, ptr %ctrl, i64 %mask
  %idx_base = getelementptr i8, ptr %2, i64 17
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc nuw nsw i64 %h2_64 to i8
  %pos13 = and i64 %h, %mask
  %gp14 = getelementptr inbounds i8, ptr %ctrl, i64 %pos13
  %grp15 = load <16 x i8>, ptr %gp14, align 1
  %avail_cmp16 = icmp slt <16 x i8> %grp15, zeroinitializer
  %abits17 = bitcast <16 x i1> %avail_cmp16 to i16
  %has_a.not18 = icmp eq i16 %abits17, 0
  br i1 %has_a.not18, label %inext, label %iput

inext:                                            ; preds = %probe_insert_init, %inext
  %pos20 = phi i64 [ %pos, %inext ], [ %pos13, %probe_insert_init ]
  %step19 = phi i64 [ %step_next, %inext ], [ 0, %probe_insert_init ]
  %step_next = add i64 %step19, 16
  %padd = add i64 %step_next, %pos20
  %pos = and i64 %padd, %mask
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %avail_cmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits = bitcast <16 x i1> %avail_cmp to i16
  %has_a.not = icmp eq i16 %abits, 0
  br i1 %has_a.not, label %inext, label %iput

iput:                                             ; preds = %inext, %probe_insert_init
  %pos.lcssa = phi i64 [ %pos13, %probe_insert_init ], [ %pos, %inext ]
  %abits.lcssa = phi i16 [ %abits17, %probe_insert_init ], [ %abits, %inext ]
  %3 = tail call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits.lcssa, i1 true)
  %tz64 = zext nneg i16 %3 to i64
  %s_add = add i64 %pos.lcssa, %tz64
  %slot = and i64 %s_add, %mask
  %sp_c = getelementptr inbounds i8, ptr %ctrl, i64 %slot
  %old_cb = load i8, ptr %sp_c, align 1
  %was_empty = icmp eq i8 %old_cb, -128
  %u_cur = load i64, ptr %used_p2, align 8
  %u_inc = zext i1 %was_empty to i64
  %u_new = add i64 %u_cur, %u_inc
  store i64 %u_new, ptr %used_p2, align 8
  store i8 %h2, ptr %sp_c, align 1
  %mir.i = icmp ult i64 %slot, 16
  br i1 %mir.i, label %do_mir.i, label %archx_dict_set_ctrl.exit

do_mir.i:                                         ; preds = %iput
  %4 = getelementptr i8, ptr %2, i64 1
  %mp.i = getelementptr i8, ptr %4, i64 %slot
  store i8 %h2, ptr %mp.i, align 1
  br label %archx_dict_set_ctrl.exit

archx_dict_set_ctrl.exit:                         ; preds = %iput, %do_mir.i
  %d_idx = load i64, ptr %hdr, align 8
  %d_new = add i64 %d_idx, 1
  store i64 %d_new, ptr %hdr, align 8
  %ip = getelementptr inbounds i32, ptr %idx_base, i64 %slot
  %d_idx32 = trunc i64 %d_idx to i32
  store i32 %d_idx32, ptr %ip, align 4
  %w0.i = extractvalue %ArchxStr %key, 0
  %len.i5 = and i64 %w0.i, 4294967295
  %long.i = icmp samesign ugt i64 %len.i5, 12
  br i1 %long.i, label %chk_tag.i, label %archx_str_clone.exit

chk_tag.i:                                        ; preds = %archx_dict_set_ctrl.exit
  %w1.i = extractvalue %ArchxStr %key, 1
  %tag.i = and i64 %w1.i, 3
  %owned.not.i = icmp eq i64 %tag.i, 0
  br i1 %owned.not.i, label %archx_str_clone.exit, label %dup_heap.i

dup_heap.i:                                       ; preds = %chk_tag.i
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %len.i5)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i, label %copy.i

oom.i:                                            ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %w1.i, -4
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 4 %src.i, i64 %len.i5, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %out.i = insertvalue %ArchxStr %key, i64 %tagged.i, 1
  %.pre = extractvalue %ArchxStr %key, 0
  br label %archx_str_clone.exit

archx_str_clone.exit:                             ; preds = %archx_dict_set_ctrl.exit, %chk_tag.i, %copy.i
  %stored_k.elt.pre-phi = phi i64 [ %w0.i, %archx_dict_set_ctrl.exit ], [ %w0.i, %chk_tag.i ], [ %.pre, %copy.i ]
  %common.ret.op.i6 = phi %ArchxStr [ %key, %archx_dict_set_ctrl.exit ], [ %key, %chk_tag.i ], [ %out.i, %copy.i ]
  %kp = getelementptr inbounds %ArchxStr, ptr %keys, i64 %d_idx
  store i64 %stored_k.elt.pre-phi, ptr %kp, align 8
  %kp.repack1 = getelementptr inbounds nuw i8, ptr %kp, i64 8
  %stored_k.elt2 = extractvalue %ArchxStr %common.ret.op.i6, 1
  store i64 %stored_k.elt2, ptr %kp.repack1, align 8
  br label %common.ret
}

; Function Attrs: nofree nounwind
define private fastcc i64 @archx_dict_find_any(i64 %d, %ArchxAny %key) unnamed_addr #4 {
entry:
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %common.ret, label %chk_ctrl

chk_ctrl:                                         ; preds = %entry
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds nuw i8, ptr %hdr, i64 32
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %c_null = icmp eq ptr %ctrl, null
  br i1 %c_null, label %common.ret, label %do_probe

do_probe:                                         ; preds = %chk_ctrl
  %mask_p = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %keys_p = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %mask = load i64, ptr %mask_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %0 = getelementptr i8, ptr %ctrl, i64 %mask
  %idx_base = getelementptr i8, ptr %0, i64 17
  %tag.i = extractvalue %ArchxAny %key, 0
  %w1.i = extractvalue %ArchxAny %key, 1
  %is0.i = icmp eq i64 %tag.i, 0
  br i1 %is0.i, label %archx_any_hash.exit, label %chk_int.i

chk_int.i:                                        ; preds = %do_probe
  %le2.i = icmp ult i64 %tag.i, 3
  br i1 %le2.i, label %h_i64.i, label %chk_flt.i

h_i64.i:                                          ; preds = %chk_int.i
  %s1.i1.i = lshr i64 %w1.i, 30
  %x1.i2.i = xor i64 %s1.i1.i, %w1.i
  %m1.i3.i = mul i64 %x1.i2.i, -4658895280553007687
  %s2.i4.i = lshr i64 %m1.i3.i, 27
  %x2.i5.i = xor i64 %s2.i4.i, %m1.i3.i
  %m2.i6.i = mul i64 %x2.i5.i, -7723592293110705685
  %s3.i7.i = lshr i64 %m2.i6.i, 31
  %x3.i8.i = xor i64 %s3.i7.i, %m2.i6.i
  br label %archx_any_hash.exit

chk_flt.i:                                        ; preds = %chk_int.i
  switch i64 %tag.i, label %unhash.i [
    i64 3, label %h_flt.i
    i64 4, label %h_str.i
  ]

h_flt.i:                                          ; preds = %chk_flt.i
  %fv.i = bitcast i64 %w1.i to double
  %iv.i = tail call i64 @llvm.fptosi.sat.i64.f64(double %fv.i)
  %back.i = sitofp i64 %iv.i to double
  %exact.i = fcmp oeq double %fv.i, %back.i
  %hkey.i = select i1 %exact.i, i64 %iv.i, i64 %w1.i
  %s1.i.i = lshr i64 %hkey.i, 30
  %x1.i.i = xor i64 %s1.i.i, %hkey.i
  %m1.i.i = mul i64 %x1.i.i, -4658895280553007687
  %s2.i.i = lshr i64 %m1.i.i, 27
  %x2.i.i = xor i64 %s2.i.i, %m1.i.i
  %m2.i.i = mul i64 %x2.i.i, -7723592293110705685
  %s3.i.i = lshr i64 %m2.i.i, 31
  %x3.i.i = xor i64 %s3.i.i, %m2.i.i
  br label %archx_any_hash.exit

h_str.i:                                          ; preds = %chk_flt.i
  %w2.i = extractvalue %ArchxAny %key, 2
  %s0.i = insertvalue %ArchxStr poison, i64 %w1.i, 0
  %s1.i = insertvalue %ArchxStr %s0.i, i64 %w2.i, 1
  %hs.i = tail call fastcc i64 @archx_hash_str(%ArchxStr %s1.i)
  br label %archx_any_hash.exit

unhash.i:                                         ; preds = %chk_flt.i
  tail call fastcc void @archx_type_fail(ptr nonnull @.any.unhash)
  unreachable

archx_any_hash.exit:                              ; preds = %do_probe, %h_i64.i, %h_flt.i, %h_str.i
  %common.ret.op.i = phi i64 [ %x3.i8.i, %h_i64.i ], [ %x3.i.i, %h_flt.i ], [ %hs.i, %h_str.i ], [ 5871781006564002453, %do_probe ]
  %h2_64 = lshr i64 %common.ret.op.i, 57
  %h2 = trunc nuw nsw i64 %h2_64 to i8
  %h2_ins = insertelement <16 x i8> poison, i8 %h2, i64 0
  %h2_vec = shufflevector <16 x i8> %h2_ins, <16 x i8> poison, <16 x i32> zeroinitializer
  br label %probe

probe:                                            ; preds = %next_grp, %archx_any_hash.exit
  %h.pn = phi i64 [ %common.ret.op.i, %archx_any_hash.exit ], [ %padd, %next_grp ]
  %step = phi i64 [ 0, %archx_any_hash.exit ], [ %step_next, %next_grp ]
  %pos = and i64 %h.pn, %mask
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %mcmp = icmp eq <16 x i8> %grp, %h2_vec
  %mbits = bitcast <16 x i1> %mcmp to i16
  %has_m.not6 = icmp eq i16 %mbits, 0
  br i1 %has_m.not6, label %chk_empty, label %chk_key.preheader

chk_key.preheader:                                ; preds = %probe
  %mmask0 = zext i16 %mbits to i32
  br label %chk_key

chk_key:                                          ; preds = %chk_key.preheader, %mbit_cont
  %mmask7 = phi i32 [ %mmask_next, %mbit_cont ], [ %mmask0, %chk_key.preheader ]
  %tz = tail call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask7, i1 true)
  %tz64 = zext nneg i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %slot = and i64 %s_add, %mask
  %ip = getelementptr inbounds i32, ptr %idx_base, i64 %slot
  %didx32 = load i32, ptr %ip, align 4
  %didx = zext i32 %didx32 to i64
  %kp = getelementptr inbounds nuw %ArchxAny, ptr %keys, i64 %didx
  %cand_k.unpack = load i64, ptr %kp, align 8
  %1 = insertvalue %ArchxAny poison, i64 %cand_k.unpack, 0
  %cand_k.elt1 = getelementptr inbounds nuw i8, ptr %kp, i64 8
  %cand_k.unpack2 = load i64, ptr %cand_k.elt1, align 8
  %2 = insertvalue %ArchxAny %1, i64 %cand_k.unpack2, 1
  %cand_k.elt3 = getelementptr inbounds nuw i8, ptr %kp, i64 16
  %cand_k.unpack4 = load i64, ptr %cand_k.elt3, align 8
  %cand_k5 = insertvalue %ArchxAny %2, i64 %cand_k.unpack4, 2
  %eq = tail call fastcc i1 @archx_any_eq(%ArchxAny %cand_k5, %ArchxAny %key)
  br i1 %eq, label %common.ret, label %mbit_cont

mbit_cont:                                        ; preds = %chk_key
  %mm1 = add nsw i32 %mmask7, -1
  %mmask_next = and i32 %mm1, %mmask7
  %has_m.not = icmp eq i32 %mmask_next, 0
  br i1 %has_m.not, label %chk_empty, label %chk_key

chk_empty:                                        ; preds = %mbit_cont, %probe
  %ecmp = icmp eq <16 x i8> %grp, splat (i8 -128)
  %ebits = bitcast <16 x i1> %ecmp to i16
  %has_e.not = icmp eq i16 %ebits, 0
  br i1 %has_e.not, label %next_grp, label %common.ret

next_grp:                                         ; preds = %chk_empty
  %step_next = add i64 %step, 16
  %padd = add i64 %step_next, %pos
  br label %probe

common.ret:                                       ; preds = %chk_empty, %chk_key, %entry, %chk_ctrl
  %common.ret.op = phi i64 [ -1, %chk_ctrl ], [ -1, %entry ], [ %didx, %chk_key ], [ -1, %chk_empty ]
  ret i64 %common.ret.op
}

; Function Attrs: nounwind
define private fastcc i64 @archx_dict_upsert_any(i64 range(i64 1, 0) %d, %ArchxAny %key) unnamed_addr #0 {
entry:
  %tag.i = extractvalue %ArchxAny %key, 0
  %w1.i = extractvalue %ArchxAny %key, 1
  %is0.i = icmp eq i64 %tag.i, 0
  br i1 %is0.i, label %archx_any_hash.exit, label %chk_int.i

chk_int.i:                                        ; preds = %entry
  %le2.i = icmp ult i64 %tag.i, 3
  br i1 %le2.i, label %h_i64.i, label %chk_flt.i

h_i64.i:                                          ; preds = %chk_int.i
  %s1.i1.i = lshr i64 %w1.i, 30
  %x1.i2.i = xor i64 %s1.i1.i, %w1.i
  %m1.i3.i = mul i64 %x1.i2.i, -4658895280553007687
  %s2.i4.i = lshr i64 %m1.i3.i, 27
  %x2.i5.i = xor i64 %s2.i4.i, %m1.i3.i
  %m2.i6.i = mul i64 %x2.i5.i, -7723592293110705685
  %s3.i7.i = lshr i64 %m2.i6.i, 31
  %x3.i8.i = xor i64 %s3.i7.i, %m2.i6.i
  br label %archx_any_hash.exit

chk_flt.i:                                        ; preds = %chk_int.i
  switch i64 %tag.i, label %unhash.i [
    i64 3, label %h_flt.i
    i64 4, label %h_str.i
  ]

h_flt.i:                                          ; preds = %chk_flt.i
  %fv.i = bitcast i64 %w1.i to double
  %iv.i = tail call i64 @llvm.fptosi.sat.i64.f64(double %fv.i)
  %back.i = sitofp i64 %iv.i to double
  %exact.i = fcmp oeq double %fv.i, %back.i
  %hkey.i = select i1 %exact.i, i64 %iv.i, i64 %w1.i
  %s1.i.i = lshr i64 %hkey.i, 30
  %x1.i.i = xor i64 %s1.i.i, %hkey.i
  %m1.i.i = mul i64 %x1.i.i, -4658895280553007687
  %s2.i.i = lshr i64 %m1.i.i, 27
  %x2.i.i = xor i64 %s2.i.i, %m1.i.i
  %m2.i.i = mul i64 %x2.i.i, -7723592293110705685
  %s3.i.i = lshr i64 %m2.i.i, 31
  %x3.i.i = xor i64 %s3.i.i, %m2.i.i
  br label %archx_any_hash.exit

h_str.i:                                          ; preds = %chk_flt.i
  %w2.i = extractvalue %ArchxAny %key, 2
  %s0.i = insertvalue %ArchxStr poison, i64 %w1.i, 0
  %s1.i = insertvalue %ArchxStr %s0.i, i64 %w2.i, 1
  %hs.i = tail call fastcc i64 @archx_hash_str(%ArchxStr %s1.i)
  br label %archx_any_hash.exit

unhash.i:                                         ; preds = %chk_flt.i
  tail call fastcc void @archx_type_fail(ptr nonnull @.any.unhash)
  unreachable

archx_any_hash.exit:                              ; preds = %entry, %h_i64.i, %h_flt.i, %h_str.i
  %common.ret.op.i = phi i64 [ %x3.i8.i, %h_i64.i ], [ %x3.i.i, %h_flt.i ], [ %hs.i, %h_str.i ], [ 5871781006564002453, %entry ]
  %raw = and i64 %d, -4
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds nuw i8, ptr %hdr, i64 32
  %ctrl0 = load ptr, ptr %ctrl_p, align 8
  %uninit = icmp eq ptr %ctrl0, null
  br i1 %uninit, label %probe_insert_init.sink.split, label %chk_probe_existing

chk_probe_existing:                               ; preds = %archx_any_hash.exit
  %found_pair = tail call fastcc i64 @archx_dict_find_any(i64 %d, %ArchxAny %key)
  %exists = icmp sgt i64 %found_pair, -1
  br i1 %exists, label %common.ret, label %chk_cap

common.ret:                                       ; preds = %chk_probe_existing, %archx_dict_set_ctrl.exit
  %found_idx.pn = phi i64 [ %d_idx, %archx_dict_set_ctrl.exit ], [ %found_pair, %chk_probe_existing ]
  ret i64 %found_idx.pn

chk_cap:                                          ; preds = %chk_probe_existing
  %used_p = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %used0 = load i64, ptr %used_p, align 8
  %mask0 = load i64, ptr %mask_p, align 8
  %u1 = shl i64 %used0, 3
  %lhs = add i64 %u1, 8
  %0 = mul i64 %mask0, 7
  %rhs = add i64 %0, 7
  %full = icmp sgt i64 %lhs, %rhs
  br i1 %full, label %probe_insert_init.sink.split, label %probe_insert_init

probe_insert_init.sink.split:                     ; preds = %chk_cap, %archx_any_hash.exit
  tail call fastcc void @archx_dict_grow(ptr nonnull %hdr)
  br label %probe_insert_init

probe_insert_init:                                ; preds = %probe_insert_init.sink.split, %chk_cap
  %used_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %keys_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %mask = load i64, ptr %mask_p2, align 8
  %keys = load ptr, ptr %keys_p2, align 8
  %1 = getelementptr i8, ptr %ctrl, i64 %mask
  %idx_base = getelementptr i8, ptr %1, i64 17
  %h2_64 = lshr i64 %common.ret.op.i, 57
  %h2 = trunc nuw nsw i64 %h2_64 to i8
  %pos6 = and i64 %common.ret.op.i, %mask
  %gp7 = getelementptr inbounds i8, ptr %ctrl, i64 %pos6
  %grp8 = load <16 x i8>, ptr %gp7, align 1
  %avail_cmp9 = icmp slt <16 x i8> %grp8, zeroinitializer
  %abits10 = bitcast <16 x i1> %avail_cmp9 to i16
  %has_a.not11 = icmp eq i16 %abits10, 0
  br i1 %has_a.not11, label %inext, label %iput

inext:                                            ; preds = %probe_insert_init, %inext
  %pos13 = phi i64 [ %pos, %inext ], [ %pos6, %probe_insert_init ]
  %step12 = phi i64 [ %step_next, %inext ], [ 0, %probe_insert_init ]
  %step_next = add i64 %step12, 16
  %padd = add i64 %step_next, %pos13
  %pos = and i64 %padd, %mask
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %avail_cmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits = bitcast <16 x i1> %avail_cmp to i16
  %has_a.not = icmp eq i16 %abits, 0
  br i1 %has_a.not, label %inext, label %iput

iput:                                             ; preds = %inext, %probe_insert_init
  %pos.lcssa = phi i64 [ %pos6, %probe_insert_init ], [ %pos, %inext ]
  %abits.lcssa = phi i16 [ %abits10, %probe_insert_init ], [ %abits, %inext ]
  %2 = tail call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits.lcssa, i1 true)
  %tz64 = zext nneg i16 %2 to i64
  %s_add = add i64 %pos.lcssa, %tz64
  %slot = and i64 %s_add, %mask
  %sp_c = getelementptr inbounds i8, ptr %ctrl, i64 %slot
  %old_cb = load i8, ptr %sp_c, align 1
  %was_empty = icmp eq i8 %old_cb, -128
  %u_cur = load i64, ptr %used_p2, align 8
  %u_inc = zext i1 %was_empty to i64
  %u_new = add i64 %u_cur, %u_inc
  store i64 %u_new, ptr %used_p2, align 8
  store i8 %h2, ptr %sp_c, align 1
  %mir.i = icmp ult i64 %slot, 16
  br i1 %mir.i, label %do_mir.i, label %archx_dict_set_ctrl.exit

do_mir.i:                                         ; preds = %iput
  %3 = getelementptr i8, ptr %1, i64 1
  %mp.i = getelementptr i8, ptr %3, i64 %slot
  store i8 %h2, ptr %mp.i, align 1
  br label %archx_dict_set_ctrl.exit

archx_dict_set_ctrl.exit:                         ; preds = %iput, %do_mir.i
  %d_idx = load i64, ptr %hdr, align 8
  %d_new = add i64 %d_idx, 1
  store i64 %d_new, ptr %hdr, align 8
  %ip = getelementptr inbounds i32, ptr %idx_base, i64 %slot
  %d_idx32 = trunc i64 %d_idx to i32
  store i32 %d_idx32, ptr %ip, align 4
  %stored_k = tail call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %key)
  %newret = extractvalue { i64, i64, i64 } %stored_k, 0
  %newret3 = extractvalue { i64, i64, i64 } %stored_k, 1
  %newret5 = extractvalue { i64, i64, i64 } %stored_k, 2
  %kp = getelementptr inbounds %ArchxAny, ptr %keys, i64 %d_idx
  store i64 %newret, ptr %kp, align 8
  %kp.repack1 = getelementptr inbounds nuw i8, ptr %kp, i64 8
  store i64 %newret3, ptr %kp.repack1, align 8
  %kp.repack3 = getelementptr inbounds nuw i8, ptr %kp, i64 16
  store i64 %newret5, ptr %kp.repack3, align 8
  br label %common.ret
}

; Function Attrs: nounwind
define private fastcc void @archx_any_drop(%ArchxAny %v) unnamed_addr #0 {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %pod = icmp ult i64 %tag, 4
  br i1 %pod, label %common.ret, label %heap_chk

heap_chk:                                         ; preds = %entry
  %w1 = extractvalue %ArchxAny %v, 1
  switch i64 %tag, label %common.ret [
    i64 4, label %d_str
    i64 5, label %d_list
    i64 6, label %d_dict
    i64 7, label %d_set
  ]

common.ret.sink.split:                            ; preds = %archx_vec_drop_y.exit, %do_free.i, %do_free.i12, %do_free.i31
  %hdr.i17.sink = phi ptr [ %hdr.i17, %do_free.i31 ], [ %hdr.i, %do_free.i12 ], [ %ptr.i, %do_free.i ], [ %lp, %archx_vec_drop_y.exit ]
  tail call void @free(ptr %hdr.i17.sink)
  br label %common.ret

common.ret:                                       ; preds = %common.ret.sink.split, %free_hdr.i28, %d_set, %free_hdr.i, %d_dict, %d_str, %entry, %d_list, %archx_vec_drop_y.exit, %heap_chk
  ret void

d_str:                                            ; preds = %heap_chk
  %w2 = extractvalue %ArchxAny %v, 2
  %len.i = and i64 %w1, 4294967295
  %long.i = icmp samesign ult i64 %len.i, 13
  %tag.i = and i64 %w2, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %long.i, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %common.ret, label %do_free.i

do_free.i:                                        ; preds = %d_str
  %raw.i = and i64 %w2, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  br label %common.ret.sink.split

d_list:                                           ; preds = %heap_chk
  %lp_raw = and i64 %w1, -4
  %lp_z = icmp eq i64 %lp_raw, 0
  br i1 %lp_z, label %common.ret, label %d_list_do

d_list_do:                                        ; preds = %d_list
  %lp = inttoptr i64 %lp_raw to ptr
  %vec.unpack = load i64, ptr %lp, align 8
  %vec.elt1 = getelementptr inbounds nuw i8, ptr %lp, i64 8
  %vec.unpack2 = load i64, ptr %vec.elt1, align 8
  %vec.elt3 = getelementptr inbounds nuw i8, ptr %lp, i64 16
  %vec.unpack4 = load ptr, ptr %vec.elt3, align 8
  %has_elems.i = icmp sgt i64 %vec.unpack, 0
  br i1 %has_elems.i, label %loop.i, label %check.free.i

loop.i:                                           ; preds = %d_list_do, %loop.i
  %i.i = phi i64 [ %inext.i, %loop.i ], [ 0, %d_list_do ]
  %ep.i = getelementptr inbounds nuw %ArchxAny, ptr %vec.unpack4, i64 %i.i
  %t0.unpack.i = load i64, ptr %ep.i, align 8
  %0 = insertvalue %ArchxAny poison, i64 %t0.unpack.i, 0
  %t0.elt1.i = getelementptr inbounds nuw i8, ptr %ep.i, i64 8
  %t0.unpack2.i = load i64, ptr %t0.elt1.i, align 8
  %1 = insertvalue %ArchxAny %0, i64 %t0.unpack2.i, 1
  %t0.elt3.i = getelementptr inbounds nuw i8, ptr %ep.i, i64 16
  %t0.unpack4.i = load i64, ptr %t0.elt3.i, align 8
  %t05.i = insertvalue %ArchxAny %1, i64 %t0.unpack4.i, 2
  tail call fastcc void @archx_any_drop(%ArchxAny %t05.i) #0
  %inext.i = add nuw nsw i64 %i.i, 1
  %exitcond46.not = icmp eq i64 %inext.i, %vec.unpack
  br i1 %exitcond46.not, label %check.free.i, label %loop.i

check.free.i:                                     ; preds = %loop.i, %d_list_do
  %is_heap.i = icmp sgt i64 %vec.unpack2, 0
  br i1 %is_heap.i, label %do.free.i, label %archx_vec_drop_y.exit

do.free.i:                                        ; preds = %check.free.i
  tail call void @free(ptr %vec.unpack4)
  br label %archx_vec_drop_y.exit

archx_vec_drop_y.exit:                            ; preds = %check.free.i, %do.free.i
  %ltag = and i64 %w1, 3
  %lheap = icmp eq i64 %ltag, 1
  br i1 %lheap, label %common.ret.sink.split, label %common.ret

d_dict:                                           ; preds = %heap_chk
  %raw.i7 = and i64 %w1, -4
  %is_z.i = icmp eq i64 %raw.i7, 0
  br i1 %is_z.i, label %common.ret, label %body.i

body.i:                                           ; preds = %d_dict
  %hdr.i = inttoptr i64 %raw.i7 to ptr
  %len.i8 = load i64, ptr %hdr.i, align 8
  %ctrl_p.i = getelementptr inbounds nuw i8, ptr %hdr.i, i64 32
  %keys_p.i = getelementptr inbounds nuw i8, ptr %hdr.i, i64 40
  %vals_p.i = getelementptr inbounds nuw i8, ptr %hdr.i, i64 48
  %ctrl.i = load ptr, ptr %ctrl_p.i, align 8
  %keys.i = load ptr, ptr %keys_p.i, align 8
  %vals.i = load ptr, ptr %vals_p.i, align 8
  %more.i943 = icmp sgt i64 %len.i8, 0
  br i1 %more.i943, label %d_elem.i, label %free_hdr.i

d_elem.i:                                         ; preds = %body.i, %d_elem.i
  %storemerge.i44 = phi i64 [ %inext.i13, %d_elem.i ], [ 0, %body.i ]
  %t0.i = getelementptr inbounds nuw %ArchxAny, ptr %keys.i, i64 %storemerge.i44
  %t1.unpack.i = load i64, ptr %t0.i, align 8
  %2 = insertvalue %ArchxAny poison, i64 %t1.unpack.i, 0
  %t1.elt1.i = getelementptr inbounds nuw i8, ptr %t0.i, i64 8
  %t1.unpack2.i = load i64, ptr %t1.elt1.i, align 8
  %3 = insertvalue %ArchxAny %2, i64 %t1.unpack2.i, 1
  %t1.elt3.i = getelementptr inbounds nuw i8, ptr %t0.i, i64 16
  %t1.unpack4.i = load i64, ptr %t1.elt3.i, align 8
  %t15.i = insertvalue %ArchxAny %3, i64 %t1.unpack4.i, 2
  tail call fastcc void @archx_any_drop(%ArchxAny %t15.i)
  %t2.i = getelementptr inbounds nuw %ArchxAny, ptr %vals.i, i64 %storemerge.i44
  %t3.unpack.i = load i64, ptr %t2.i, align 8
  %4 = insertvalue %ArchxAny poison, i64 %t3.unpack.i, 0
  %t3.elt6.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 8
  %t3.unpack7.i = load i64, ptr %t3.elt6.i, align 8
  %5 = insertvalue %ArchxAny %4, i64 %t3.unpack7.i, 1
  %t3.elt8.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 16
  %t3.unpack9.i = load i64, ptr %t3.elt8.i, align 8
  %t310.i = insertvalue %ArchxAny %5, i64 %t3.unpack9.i, 2
  tail call fastcc void @archx_any_drop(%ArchxAny %t310.i)
  %inext.i13 = add nuw nsw i64 %storemerge.i44, 1
  %exitcond45.not = icmp eq i64 %inext.i13, %len.i8
  br i1 %exitcond45.not, label %free_hdr.i, label %d_elem.i

free_hdr.i:                                       ; preds = %d_elem.i, %body.i
  %tag.i10 = and i64 %w1, 3
  %is_heap.i11 = icmp eq i64 %tag.i10, 1
  br i1 %is_heap.i11, label %do_free.i12, label %common.ret

do_free.i12:                                      ; preds = %free_hdr.i
  tail call void @free(ptr %ctrl.i)
  tail call void @free(ptr %keys.i)
  tail call void @free(ptr %vals.i)
  br label %common.ret.sink.split

d_set:                                            ; preds = %heap_chk
  %raw.i14 = and i64 %w1, -4
  %is_z.i15 = icmp eq i64 %raw.i14, 0
  br i1 %is_z.i15, label %common.ret, label %body.i16

body.i16:                                         ; preds = %d_set
  %hdr.i17 = inttoptr i64 %raw.i14 to ptr
  %len.i18 = load i64, ptr %hdr.i17, align 8
  %ctrl_p.i19 = getelementptr inbounds nuw i8, ptr %hdr.i17, i64 32
  %keys_p.i20 = getelementptr inbounds nuw i8, ptr %hdr.i17, i64 40
  %vals_p.i21 = getelementptr inbounds nuw i8, ptr %hdr.i17, i64 48
  %ctrl.i22 = load ptr, ptr %ctrl_p.i19, align 8
  %keys.i23 = load ptr, ptr %keys_p.i20, align 8
  %vals.i24 = load ptr, ptr %vals_p.i21, align 8
  %more.i2741 = icmp sgt i64 %len.i18, 0
  br i1 %more.i2741, label %d_elem.i32, label %free_hdr.i28

d_elem.i32:                                       ; preds = %body.i16, %d_elem.i32
  %storemerge.i2642 = phi i64 [ %inext.i40, %d_elem.i32 ], [ 0, %body.i16 ]
  %t0.i33 = getelementptr inbounds nuw %ArchxAny, ptr %keys.i23, i64 %storemerge.i2642
  %t1.unpack.i34 = load i64, ptr %t0.i33, align 8
  %6 = insertvalue %ArchxAny poison, i64 %t1.unpack.i34, 0
  %t1.elt1.i35 = getelementptr inbounds nuw i8, ptr %t0.i33, i64 8
  %t1.unpack2.i36 = load i64, ptr %t1.elt1.i35, align 8
  %7 = insertvalue %ArchxAny %6, i64 %t1.unpack2.i36, 1
  %t1.elt3.i37 = getelementptr inbounds nuw i8, ptr %t0.i33, i64 16
  %t1.unpack4.i38 = load i64, ptr %t1.elt3.i37, align 8
  %t15.i39 = insertvalue %ArchxAny %7, i64 %t1.unpack4.i38, 2
  tail call fastcc void @archx_any_drop(%ArchxAny %t15.i39)
  %inext.i40 = add nuw nsw i64 %storemerge.i2642, 1
  %exitcond.not = icmp eq i64 %inext.i40, %len.i18
  br i1 %exitcond.not, label %free_hdr.i28, label %d_elem.i32

free_hdr.i28:                                     ; preds = %d_elem.i32, %body.i16
  %tag.i29 = and i64 %w1, 3
  %is_heap.i30 = icmp eq i64 %tag.i29, 1
  br i1 %is_heap.i30, label %do_free.i31, label %common.ret

do_free.i31:                                      ; preds = %free_hdr.i28
  tail call void @free(ptr %ctrl.i22)
  tail call void @free(ptr %keys.i23)
  tail call void @free(ptr %vals.i24)
  br label %common.ret.sink.split
}

; Function Attrs: nounwind
define private fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %v) unnamed_addr #0 {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %pod = icmp ult i64 %tag, 4
  br i1 %pod, label %common.ret, label %heap_chk

common.ret:                                       ; preds = %entry, %archx_set_clone_y.exit, %archx_dict_clone_y_y.exit, %c_list_ok, %archx_str_clone.exit
  %common.ret.op = phi %ArchxAny [ %as1, %archx_str_clone.exit ], [ %al0, %c_list_ok ], [ %ad0, %archx_dict_clone_y_y.exit ], [ %ae0, %archx_set_clone_y.exit ], [ %v, %entry ]
  %oldret1 = extractvalue %ArchxAny %common.ret.op, 0
  %newret2 = insertvalue { i64, i64, i64 } poison, i64 %oldret1, 0
  %oldret3 = extractvalue %ArchxAny %common.ret.op, 1
  %newret4 = insertvalue { i64, i64, i64 } %newret2, i64 %oldret3, 1
  %oldret5 = extractvalue %ArchxAny %common.ret.op, 2
  %newret6 = insertvalue { i64, i64, i64 } %newret4, i64 %oldret5, 2
  ret { i64, i64, i64 } %newret6

heap_chk:                                         ; preds = %entry
  %w1 = extractvalue %ArchxAny %v, 1
  switch i64 %tag, label %c_set [
    i64 4, label %c_str
    i64 5, label %c_list
    i64 6, label %c_dict
  ]

c_str:                                            ; preds = %heap_chk
  %w2 = extractvalue %ArchxAny %v, 2
  %s0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %s1 = insertvalue %ArchxStr %s0, i64 %w2, 1
  %len.i = and i64 %w1, 4294967295
  %long.i = icmp samesign ult i64 %len.i, 13
  %tag.i = and i64 %w2, 3
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %long.i, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %archx_str_clone.exit, label %dup_heap.i

dup_heap.i:                                       ; preds = %c_str
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %len.i)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i, label %copy.i

oom.i:                                            ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %w2, -4
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 4 %src.i, i64 %len.i, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %out.i = insertvalue %ArchxStr %s1, i64 %tagged.i, 1
  br label %archx_str_clone.exit

archx_str_clone.exit:                             ; preds = %c_str, %copy.i
  %common.ret.op.i = phi %ArchxStr [ %out.i, %copy.i ], [ %s1, %c_str ]
  %sw0 = extractvalue %ArchxStr %common.ret.op.i, 0
  %sw1 = extractvalue %ArchxStr %common.ret.op.i, 1
  %as0 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %sw0, 1
  %as1 = insertvalue %ArchxAny %as0, i64 %sw1, 2
  br label %common.ret

c_list:                                           ; preds = %heap_chk
  %lp_raw = and i64 %w1, -4
  %lp = inttoptr i64 %lp_raw to ptr
  %vec.unpack = load i64, ptr %lp, align 8
  %0 = insertvalue %ArchxVec poison, i64 %vec.unpack, 0
  %vec.elt3 = getelementptr inbounds nuw i8, ptr %lp, i64 16
  %vec.unpack4 = load ptr, ptr %vec.elt3, align 8
  %empty.i = icmp slt i64 %vec.unpack, 1
  br i1 %empty.i, label %archx_vec_clone_y.exit, label %alloc.i

alloc.i:                                          ; preds = %c_list
  %t0.i = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %vec.unpack, i64 24)
  %t2.i = extractvalue { i64, i1 } %t0.i, 1
  br i1 %t2.i, label %mul.oom.0.i, label %mul.ok.1.i

mul.oom.0.i:                                      ; preds = %alloc.i
  tail call fastcc void @archx_oom_fail()
  unreachable

mul.ok.1.i:                                       ; preds = %alloc.i
  %t1.i = extractvalue { i64, i1 } %t0.i, 0
  %t5.i = tail call noalias align 16 ptr @malloc(i64 %t1.i)
  %t6.i = icmp eq ptr %t5.i, null
  br i1 %t6.i, label %alloc.oom.3.i, label %loop.i

alloc.oom.3.i:                                    ; preds = %mul.ok.1.i
  tail call fastcc void @archx_oom_fail()
  unreachable

loop.i:                                           ; preds = %mul.ok.1.i, %loop.i
  %i.i = phi i64 [ %inext.i, %loop.i ], [ 0, %mul.ok.1.i ]
  %sp.i = getelementptr inbounds nuw %ArchxAny, ptr %vec.unpack4, i64 %i.i
  %dp.i = getelementptr inbounds nuw %ArchxAny, ptr %t5.i, i64 %i.i
  %t7.unpack.i = load i64, ptr %sp.i, align 8
  %1 = insertvalue %ArchxAny poison, i64 %t7.unpack.i, 0
  %t7.elt1.i = getelementptr inbounds nuw i8, ptr %sp.i, i64 8
  %t7.unpack2.i = load i64, ptr %t7.elt1.i, align 8
  %2 = insertvalue %ArchxAny %1, i64 %t7.unpack2.i, 1
  %t7.elt3.i = getelementptr inbounds nuw i8, ptr %sp.i, i64 16
  %t7.unpack4.i = load i64, ptr %t7.elt3.i, align 8
  %t75.i = insertvalue %ArchxAny %2, i64 %t7.unpack4.i, 2
  %t8.i = tail call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t75.i)
  %newret66 = extractvalue { i64, i64, i64 } %t8.i, 0
  %newret68 = extractvalue { i64, i64, i64 } %t8.i, 1
  %newret70 = extractvalue { i64, i64, i64 } %t8.i, 2
  store i64 %newret66, ptr %dp.i, align 8
  %dp.repack6.i = getelementptr inbounds nuw i8, ptr %dp.i, i64 8
  store i64 %newret68, ptr %dp.repack6.i, align 8
  %dp.repack8.i = getelementptr inbounds nuw i8, ptr %dp.i, i64 16
  store i64 %newret70, ptr %dp.repack8.i, align 8
  %inext.i = add nuw nsw i64 %i.i, 1
  %exitcond59.not = icmp eq i64 %inext.i, %vec.unpack
  br i1 %exitcond59.not, label %finish.i, label %loop.i

finish.i:                                         ; preds = %loop.i
  %t10.i = insertvalue %ArchxVec %0, i64 %vec.unpack, 1
  %t11.i = insertvalue %ArchxVec %t10.i, ptr %t5.i, 2
  br label %archx_vec_clone_y.exit

archx_vec_clone_y.exit:                           ; preds = %c_list, %finish.i
  %common.ret.op.i12 = phi %ArchxVec [ %t11.i, %finish.i ], [ zeroinitializer, %c_list ]
  %ncell = tail call noalias align 16 dereferenceable_or_null(24) ptr @malloc(i64 24)
  %nc_null = icmp eq ptr %ncell, null
  br i1 %nc_null, label %oom, label %c_list_ok

oom:                                              ; preds = %archx_vec_clone_y.exit
  tail call fastcc void @archx_oom_fail()
  unreachable

c_list_ok:                                        ; preds = %archx_vec_clone_y.exit
  %vc.elt = extractvalue %ArchxVec %common.ret.op.i12, 0
  store i64 %vc.elt, ptr %ncell, align 16
  %ncell.repack6 = getelementptr inbounds nuw i8, ptr %ncell, i64 8
  %vc.elt7 = extractvalue %ArchxVec %common.ret.op.i12, 1
  store i64 %vc.elt7, ptr %ncell.repack6, align 8
  %ncell.repack8 = getelementptr inbounds nuw i8, ptr %ncell, i64 16
  %vc.elt9 = extractvalue %ArchxVec %common.ret.op.i12, 2
  store ptr %vc.elt9, ptr %ncell.repack8, align 16
  %nci = ptrtoint ptr %ncell to i64
  %nct = or disjoint i64 %nci, 1
  %al0 = insertvalue %ArchxAny { i64 5, i64 0, i64 0 }, i64 %nct, 1
  br label %common.ret

c_dict:                                           ; preds = %heap_chk
  %hp.i = tail call noalias align 16 dereferenceable_or_null(64) ptr @calloc(i64 1, i64 64)
  %hnull.i = icmp eq ptr %hp.i, null
  br i1 %hnull.i, label %oom.i46, label %archx_dict_new.exit

oom.i46:                                          ; preds = %c_dict
  tail call fastcc void @archx_oom_fail()
  unreachable

archx_dict_new.exit:                              ; preds = %c_dict
  %h_meta_gep.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 56
  store i64 103079221250, ptr %h_meta_gep.i, align 8
  %hpi.i = ptrtoint ptr %hp.i to i64
  %htag.i = or disjoint i64 %hpi.i, 1
  %raw.i = and i64 %w1, -4
  %is_z.i = icmp eq i64 %raw.i, 0
  br i1 %is_z.i, label %archx_dict_clone_y_y.exit, label %init.i

init.i:                                           ; preds = %archx_dict_new.exit
  %hdr.i = inttoptr i64 %raw.i to ptr
  %len.i14 = load i64, ptr %hdr.i, align 8
  %keys_p.i = getelementptr inbounds nuw i8, ptr %hdr.i, i64 40
  %vals_p.i = getelementptr inbounds nuw i8, ptr %hdr.i, i64 48
  %keys.i = load ptr, ptr %keys_p.i, align 8
  %vals.i = load ptr, ptr %vals_p.i, align 8
  %more.i1555 = icmp sgt i64 %len.i14, 0
  br i1 %more.i1555, label %c_body.i.lr.ph, label %archx_dict_clone_y_y.exit

c_body.i.lr.ph:                                   ; preds = %init.i
  %t9.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 48
  br label %c_body.i

c_body.i:                                         ; preds = %c_body.i.lr.ph, %c_body.i
  %storemerge.i56 = phi i64 [ 0, %c_body.i.lr.ph ], [ %inext.i23, %c_body.i ]
  %t0.i16 = getelementptr inbounds nuw %ArchxAny, ptr %keys.i, i64 %storemerge.i56
  %t1.unpack.i = load i64, ptr %t0.i16, align 8
  %3 = insertvalue %ArchxAny poison, i64 %t1.unpack.i, 0
  %t1.elt1.i = getelementptr inbounds nuw i8, ptr %t0.i16, i64 8
  %t1.unpack2.i = load i64, ptr %t1.elt1.i, align 8
  %4 = insertvalue %ArchxAny %3, i64 %t1.unpack2.i, 1
  %t1.elt3.i = getelementptr inbounds nuw i8, ptr %t0.i16, i64 16
  %t1.unpack4.i = load i64, ptr %t1.elt3.i, align 8
  %t15.i = insertvalue %ArchxAny %4, i64 %t1.unpack4.i, 2
  %t2.i17 = tail call fastcc i64 @archx_dict_upsert_any(i64 %htag.i, %ArchxAny %t15.i)
  %t4.i18 = getelementptr inbounds nuw %ArchxAny, ptr %vals.i, i64 %storemerge.i56
  %t5.unpack.i = load i64, ptr %t4.i18, align 8
  %5 = insertvalue %ArchxAny poison, i64 %t5.unpack.i, 0
  %t5.elt6.i = getelementptr inbounds nuw i8, ptr %t4.i18, i64 8
  %t5.unpack7.i = load i64, ptr %t5.elt6.i, align 8
  %6 = insertvalue %ArchxAny %5, i64 %t5.unpack7.i, 1
  %t5.elt8.i = getelementptr inbounds nuw i8, ptr %t4.i18, i64 16
  %t5.unpack9.i = load i64, ptr %t5.elt8.i, align 8
  %t510.i = insertvalue %ArchxAny %6, i64 %t5.unpack9.i, 2
  %t6.i19 = tail call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t510.i)
  %newret = extractvalue { i64, i64, i64 } %t6.i19, 0
  %newret62 = extractvalue { i64, i64, i64 } %t6.i19, 1
  %newret64 = extractvalue { i64, i64, i64 } %t6.i19, 2
  %t10.i21 = load ptr, ptr %t9.i, align 16
  %t11.i22 = getelementptr inbounds %ArchxAny, ptr %t10.i21, i64 %t2.i17
  store i64 %newret, ptr %t11.i22, align 8
  %t11.repack11.i = getelementptr inbounds nuw i8, ptr %t11.i22, i64 8
  store i64 %newret62, ptr %t11.repack11.i, align 8
  %t11.repack13.i = getelementptr inbounds nuw i8, ptr %t11.i22, i64 16
  store i64 %newret64, ptr %t11.repack13.i, align 8
  %inext.i23 = add nuw nsw i64 %storemerge.i56, 1
  %exitcond.not = icmp eq i64 %inext.i23, %len.i14
  br i1 %exitcond.not, label %archx_dict_clone_y_y.exit, label %c_body.i

archx_dict_clone_y_y.exit:                        ; preds = %c_body.i, %init.i, %archx_dict_new.exit
  %ad0 = insertvalue %ArchxAny { i64 6, i64 0, i64 0 }, i64 %htag.i, 1
  br label %common.ret

c_set:                                            ; preds = %heap_chk
  %hp.i47 = tail call noalias align 16 dereferenceable_or_null(64) ptr @calloc(i64 1, i64 64)
  %hnull.i48 = icmp eq ptr %hp.i47, null
  br i1 %hnull.i48, label %oom.i53, label %archx_dict_new.exit54

oom.i53:                                          ; preds = %c_set
  tail call fastcc void @archx_oom_fail()
  unreachable

archx_dict_new.exit54:                            ; preds = %c_set
  %h_meta_gep.i49 = getelementptr inbounds nuw i8, ptr %hp.i47, i64 56
  store i64 6146, ptr %h_meta_gep.i49, align 8
  %hpi.i50 = ptrtoint ptr %hp.i47 to i64
  %htag.i51 = or disjoint i64 %hpi.i50, 1
  %raw.i25 = and i64 %w1, -4
  %is_z.i26 = icmp eq i64 %raw.i25, 0
  br i1 %is_z.i26, label %archx_set_clone_y.exit, label %init.i27

init.i27:                                         ; preds = %archx_dict_new.exit54
  %hdr.i28 = inttoptr i64 %raw.i25 to ptr
  %len.i29 = load i64, ptr %hdr.i28, align 8
  %keys_p.i30 = getelementptr inbounds nuw i8, ptr %hdr.i28, i64 40
  %keys.i31 = load ptr, ptr %keys_p.i30, align 8
  %more.i3457 = icmp sgt i64 %len.i29, 0
  br i1 %more.i3457, label %c_body.i35, label %archx_set_clone_y.exit

c_body.i35:                                       ; preds = %init.i27, %c_body.i35
  %storemerge.i3358 = phi i64 [ %inext.i44, %c_body.i35 ], [ 0, %init.i27 ]
  %t0.i36 = getelementptr inbounds nuw %ArchxAny, ptr %keys.i31, i64 %storemerge.i3358
  %t1.unpack.i37 = load i64, ptr %t0.i36, align 8
  %7 = insertvalue %ArchxAny poison, i64 %t1.unpack.i37, 0
  %t1.elt1.i38 = getelementptr inbounds nuw i8, ptr %t0.i36, i64 8
  %t1.unpack2.i39 = load i64, ptr %t1.elt1.i38, align 8
  %8 = insertvalue %ArchxAny %7, i64 %t1.unpack2.i39, 1
  %t1.elt3.i40 = getelementptr inbounds nuw i8, ptr %t0.i36, i64 16
  %t1.unpack4.i41 = load i64, ptr %t1.elt3.i40, align 8
  %t15.i42 = insertvalue %ArchxAny %8, i64 %t1.unpack4.i41, 2
  %9 = tail call fastcc i64 @archx_dict_upsert_any(i64 %htag.i51, %ArchxAny %t15.i42)
  %inext.i44 = add nuw nsw i64 %storemerge.i3358, 1
  %exitcond60.not = icmp eq i64 %inext.i44, %len.i29
  br i1 %exitcond60.not, label %archx_set_clone_y.exit, label %c_body.i35

archx_set_clone_y.exit:                           ; preds = %c_body.i35, %init.i27, %archx_dict_new.exit54
  %ae0 = insertvalue %ArchxAny { i64 7, i64 0, i64 0 }, i64 %htag.i51, 1
  br label %common.ret
}

; Function Attrs: nofree nounwind
define private fastcc i1 @archx_any_eq(%ArchxAny %a, %ArchxAny %b) unnamed_addr #4 {
entry:
  %ta = extractvalue %ArchxAny %a, 0
  %tb = extractvalue %ArchxAny %b, 0
  %wa1 = extractvalue %ArchxAny %a, 1
  %wb1 = extractvalue %ArchxAny %b, 1
  %0 = add i64 %ta, -1
  %na = icmp ult i64 %0, 3
  %1 = add i64 %tb, -1
  %nb = icmp ult i64 %1, 3
  %both_num = and i1 %na, %nb
  br i1 %both_num, label %num_eq, label %same_tag_chk

num_eq:                                           ; preds = %entry
  %fa_is = icmp eq i64 %ta, 3
  %fb_is = icmp eq i64 %tb, 3
  %any_flt = or i1 %fa_is, %fb_is
  br i1 %any_flt, label %flt_eq, label %int_eq

common.ret:                                       ; preds = %lloop_body, %dchk_dv, %dloop_body, %dloop_next, %lloop_init, %dloop_init, %do_memcmp.i, %cmp_long.i, %cmp_short.i, %eq_str, %by_tag, %same_tag_chk, %eq_list, %chk_dict, %flt_eq, %int_eq
  %common.ret.op = phi i1 [ %ieq, %int_eq ], [ %feq, %flt_eq ], [ false, %chk_dict ], [ false, %eq_list ], [ false, %same_tag_chk ], [ true, %by_tag ], [ %eq_s.i, %cmp_short.i ], [ %eq_m.i, %do_memcmp.i ], [ true, %cmp_long.i ], [ false, %eq_str ], [ true, %dloop_init ], [ true, %lloop_init ], [ false, %dchk_dv ], [ false, %dloop_body ], [ true, %dloop_next ], [ %eeq, %lloop_body ]
  ret i1 %common.ret.op

int_eq:                                           ; preds = %num_eq
  %ieq = icmp eq i64 %wa1, %wb1
  br label %common.ret

flt_eq:                                           ; preds = %num_eq
  %da_b = bitcast i64 %wa1 to double
  %da_i = sitofp i64 %wa1 to double
  %da = select i1 %fa_is, double %da_b, double %da_i
  %db_b = bitcast i64 %wb1 to double
  %db_i = sitofp i64 %wb1 to double
  %db = select i1 %fb_is, double %db_b, double %db_i
  %feq = fcmp oeq double %da, %db
  br label %common.ret

same_tag_chk:                                     ; preds = %entry
  %teq = icmp eq i64 %ta, %tb
  br i1 %teq, label %by_tag, label %common.ret

by_tag:                                           ; preds = %same_tag_chk
  switch i64 %ta, label %chk_dict [
    i64 0, label %common.ret
    i64 4, label %eq_str
    i64 5, label %eq_list
  ]

eq_str:                                           ; preds = %by_tag
  %wa2 = extractvalue %ArchxAny %a, 2
  %wb2 = extractvalue %ArchxAny %b, 2
  %w0_eq.i = icmp eq i64 %wa1, %wb1
  br i1 %w0_eq.i, label %chk_len.i, label %common.ret

chk_len.i:                                        ; preds = %eq_str
  %len.i = and i64 %wa1, 4294967295
  %short.i = icmp samesign ult i64 %len.i, 13
  br i1 %short.i, label %cmp_short.i, label %cmp_long.i

cmp_short.i:                                      ; preds = %chk_len.i
  %eq_s.i = icmp eq i64 %wa2, %wb2
  br label %common.ret

cmp_long.i:                                       ; preds = %chk_len.i
  %ap_i.i = and i64 %wa2, -4
  %bp_i.i = and i64 %wb2, -4
  %same_ptr.i = icmp eq i64 %ap_i.i, %bp_i.i
  br i1 %same_ptr.i, label %common.ret, label %do_memcmp.i

do_memcmp.i:                                      ; preds = %cmp_long.i
  %ap.i = inttoptr i64 %ap_i.i to ptr
  %bp.i = inttoptr i64 %bp_i.i to ptr
  %ap4.i = getelementptr inbounds nuw i8, ptr %ap.i, i64 4
  %bp4.i = getelementptr inbounds nuw i8, ptr %bp.i, i64 4
  %rem.i = add nsw i64 %len.i, -4
  %bcmp.i = tail call i32 @bcmp(ptr nonnull %ap4.i, ptr nonnull %bp4.i, i64 %rem.i)
  %eq_m.i = icmp eq i32 %bcmp.i, 0
  br label %common.ret

eq_list:                                          ; preds = %by_tag
  %ra = and i64 %wa1, -4
  %rb = and i64 %wb1, -4
  %lpa = inttoptr i64 %ra to ptr
  %lpb = inttoptr i64 %rb to ptr
  %va.unpack = load i64, ptr %lpa, align 8
  %vb.unpack = load i64, ptr %lpb, align 8
  %lleq = icmp eq i64 %va.unpack, %vb.unpack
  br i1 %lleq, label %lloop_init, label %common.ret

lloop_init:                                       ; preds = %eq_list
  %vb.elt8 = getelementptr inbounds nuw i8, ptr %lpb, i64 16
  %vb.unpack9 = load ptr, ptr %vb.elt8, align 8
  %va.elt3 = getelementptr inbounds nuw i8, ptr %lpa, i64 16
  %va.unpack4 = load ptr, ptr %va.elt3, align 8
  %lmore38 = icmp sgt i64 %va.unpack, 0
  br i1 %lmore38, label %lloop_body, label %common.ret

lloop_body:                                       ; preds = %lloop_init, %lloop_body
  %li39 = phi i64 [ %li_next, %lloop_body ], [ 0, %lloop_init ]
  %ea_p = getelementptr inbounds nuw %ArchxAny, ptr %va.unpack4, i64 %li39
  %eb_p = getelementptr inbounds nuw %ArchxAny, ptr %vb.unpack9, i64 %li39
  %ea.unpack = load i64, ptr %ea_p, align 8
  %2 = insertvalue %ArchxAny poison, i64 %ea.unpack, 0
  %ea.elt11 = getelementptr inbounds nuw i8, ptr %ea_p, i64 8
  %ea.unpack12 = load i64, ptr %ea.elt11, align 8
  %3 = insertvalue %ArchxAny %2, i64 %ea.unpack12, 1
  %ea.elt13 = getelementptr inbounds nuw i8, ptr %ea_p, i64 16
  %ea.unpack14 = load i64, ptr %ea.elt13, align 8
  %ea15 = insertvalue %ArchxAny %3, i64 %ea.unpack14, 2
  %eb.unpack = load i64, ptr %eb_p, align 8
  %4 = insertvalue %ArchxAny poison, i64 %eb.unpack, 0
  %eb.elt16 = getelementptr inbounds nuw i8, ptr %eb_p, i64 8
  %eb.unpack17 = load i64, ptr %eb.elt16, align 8
  %5 = insertvalue %ArchxAny %4, i64 %eb.unpack17, 1
  %eb.elt18 = getelementptr inbounds nuw i8, ptr %eb_p, i64 16
  %eb.unpack19 = load i64, ptr %eb.elt18, align 8
  %eb20 = insertvalue %ArchxAny %5, i64 %eb.unpack19, 2
  %eeq = tail call fastcc i1 @archx_any_eq(%ArchxAny %ea15, %ArchxAny %eb20)
  %li_next = add nuw nsw i64 %li39, 1
  %exitcond.not = icmp ne i64 %li_next, %va.unpack
  %or.cond.not = select i1 %eeq, i1 %exitcond.not, i1 false
  br i1 %or.cond.not, label %lloop_body, label %common.ret

chk_dict:                                         ; preds = %by_tag
  %dra = and i64 %wa1, -4
  %drb = and i64 %wb1, -4
  %dha = inttoptr i64 %dra to ptr
  %dhb = inttoptr i64 %drb to ptr
  %dla = load i64, ptr %dha, align 8
  %dlb = load i64, ptr %dhb, align 8
  %dleq = icmp eq i64 %dla, %dlb
  br i1 %dleq, label %dloop_init, label %common.ret

dloop_init:                                       ; preds = %chk_dict
  %akp_p = getelementptr inbounds nuw i8, ptr %dha, i64 40
  %avp_p = getelementptr inbounds nuw i8, ptr %dha, i64 48
  %bvp_p = getelementptr inbounds nuw i8, ptr %dhb, i64 48
  %akeys = load ptr, ptr %akp_p, align 8
  %avals = load ptr, ptr %avp_p, align 8
  %bvals = load ptr, ptr %bvp_p, align 8
  %is_dict_t = icmp eq i64 %ta, 6
  %dmore41 = icmp sgt i64 %dla, 0
  br i1 %dmore41, label %dloop_body, label %common.ret

dloop_body:                                       ; preds = %dloop_init, %dloop_next
  %di42 = phi i64 [ %di_next, %dloop_next ], [ 0, %dloop_init ]
  %ak_p = getelementptr inbounds nuw %ArchxAny, ptr %akeys, i64 %di42
  %ak.unpack = load i64, ptr %ak_p, align 8
  %6 = insertvalue %ArchxAny poison, i64 %ak.unpack, 0
  %ak.elt21 = getelementptr inbounds nuw i8, ptr %ak_p, i64 8
  %ak.unpack22 = load i64, ptr %ak.elt21, align 8
  %7 = insertvalue %ArchxAny %6, i64 %ak.unpack22, 1
  %ak.elt23 = getelementptr inbounds nuw i8, ptr %ak_p, i64 16
  %ak.unpack24 = load i64, ptr %ak.elt23, align 8
  %ak25 = insertvalue %ArchxAny %7, i64 %ak.unpack24, 2
  %pair.i = tail call fastcc i64 @archx_dict_find_any(i64 %wb1, %ArchxAny %ak25)
  %bfound = icmp sgt i64 %pair.i, -1
  br i1 %bfound, label %dchk_val, label %common.ret

dchk_val:                                         ; preds = %dloop_body
  br i1 %is_dict_t, label %dchk_dv, label %dloop_next

dchk_dv:                                          ; preds = %dchk_val
  %av_p = getelementptr inbounds nuw %ArchxAny, ptr %avals, i64 %di42
  %bv_p = getelementptr inbounds nuw %ArchxAny, ptr %bvals, i64 %pair.i
  %av.unpack = load i64, ptr %av_p, align 8
  %8 = insertvalue %ArchxAny poison, i64 %av.unpack, 0
  %av.elt26 = getelementptr inbounds nuw i8, ptr %av_p, i64 8
  %av.unpack27 = load i64, ptr %av.elt26, align 8
  %9 = insertvalue %ArchxAny %8, i64 %av.unpack27, 1
  %av.elt28 = getelementptr inbounds nuw i8, ptr %av_p, i64 16
  %av.unpack29 = load i64, ptr %av.elt28, align 8
  %av30 = insertvalue %ArchxAny %9, i64 %av.unpack29, 2
  %bv.unpack = load i64, ptr %bv_p, align 8
  %10 = insertvalue %ArchxAny poison, i64 %bv.unpack, 0
  %bv.elt31 = getelementptr inbounds nuw i8, ptr %bv_p, i64 8
  %bv.unpack32 = load i64, ptr %bv.elt31, align 8
  %11 = insertvalue %ArchxAny %10, i64 %bv.unpack32, 1
  %bv.elt33 = getelementptr inbounds nuw i8, ptr %bv_p, i64 16
  %bv.unpack34 = load i64, ptr %bv.elt33, align 8
  %bv35 = insertvalue %ArchxAny %11, i64 %bv.unpack34, 2
  %veq = tail call fastcc i1 @archx_any_eq(%ArchxAny %av30, %ArchxAny %bv35)
  br i1 %veq, label %dloop_next, label %common.ret

dloop_next:                                       ; preds = %dchk_dv, %dchk_val
  %di_next = add nuw nsw i64 %di42, 1
  %exitcond48.not = icmp eq i64 %di_next, %dla
  br i1 %exitcond48.not, label %common.ret, label %dloop_body
}

; Function Attrs: nofree nounwind
define private fastcc { i64, i64 } @archx_any_to_str(%ArchxAny %v) unnamed_addr #4 {
entry:
  %sso.i.i8 = alloca [16 x i8], align 8
  %buf.i9 = alloca [64 x i8], align 8
  %sso.i.i = alloca [16 x i8], align 8
  %buf.i = alloca [32 x i8], align 8
  %sso.i1 = alloca [16 x i8], align 8
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  switch i64 %tag, label %t7.i [
    i64 0, label %common.ret
    i64 1, label %s_bool
    i64 2, label %s_int
    i64 3, label %s_flt
    i64 4, label %s_str
    i64 6, label %t6.i
    i64 5, label %t5.i
  ]

common.ret:                                       ; preds = %entry, %t7.i, %t6.i, %t5.i, %copy.i, %s_str, %archx_str_from_float.exit, %archx_str_from_int.exit, %s_bool
  %common.ret.op = phi %ArchxStr [ %ss1.i7, %s_bool ], [ %common.ret.op.i.i, %archx_str_from_int.exit ], [ %common.ret.op.i.i26, %archx_str_from_float.exit ], [ { i64 7308901626067025924, i64 0 }, %entry ], [ %out.i, %copy.i ], [ %ss1, %s_str ], [ { i64 8391166443298750468, i64 0 }, %t5.i ], [ { i64 8386662809311641604, i64 0 }, %t6.i ], [ { i64 32762641894080515, i64 0 }, %t7.i ]
  %oldret = extractvalue %ArchxStr %common.ret.op, 0
  %newret = insertvalue { i64, i64 } poison, i64 %oldret, 0
  %oldret1 = extractvalue %ArchxStr %common.ret.op, 1
  %newret2 = insertvalue { i64, i64 } %newret, i64 %oldret1, 1
  ret { i64, i64 } %newret2

s_bool:                                           ; preds = %entry
  %bt.not = icmp eq i64 %w1, 0
  %bp = select i1 %bt.not, ptr @.str.false, ptr @.str.true
  %bl = select i1 %bt.not, i64 5, i64 4
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i1)
  %len32.i = trunc nuw nsw i64 %bl to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i1, i8 0, i64 16, i1 false)
  store i32 %len32.i, ptr %sso.i1, align 8
  %sso.i1.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i1, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(4) %sso.i1.4.sroa_idx, ptr noundef nonnull readonly align 1 dereferenceable(4) %bp, i64 range(i64 -2147483648, -9223372036854775808) %bl, i1 false)
  %sso.i1.0.sso.i1.0.sso.i1.0.sso.0.sso.0.sso.0.sw0.i4 = load i64, ptr %sso.i1, align 8
  %sso.i1.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i1, i64 8
  %sso.i1.8.sso.i1.8.sso.i1.8.sso.8.sso.8.sso.8.sw1.i5 = load i64, ptr %sso.i1.8.sroa_idx, align 8
  %ss0.i6 = insertvalue %ArchxStr poison, i64 %sso.i1.0.sso.i1.0.sso.i1.0.sso.0.sso.0.sso.0.sw0.i4, 0
  %ss1.i7 = insertvalue %ArchxStr %ss0.i6, i64 %sso.i1.8.sso.i1.8.sso.i1.8.sso.8.sso.8.sso.8.sw1.i5, 1
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i1)
  br label %common.ret

s_int:                                            ; preds = %entry
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i)
  %n32.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %w1)
  %len.i = sext i32 %n32.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i)
  %z.i.i = icmp slt i32 %n32.i, 1
  br i1 %z.i.i, label %archx_str_from_int.exit, label %chk_sso.i.i

oom.i.i:                                          ; preds = %alloc_heap.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i:                                      ; preds = %s_int
  %short.i.i = icmp samesign ult i32 %n32.i, 13
  br i1 %short.i.i, label %pack_sso.i.i, label %alloc_heap.i.i

pack_sso.i.i:                                     ; preds = %chk_sso.i.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i, i8 0, i64 16, i1 false)
  store i32 %n32.i, ptr %sso.i.i, align 8
  %sso.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, -9223372036854775808) %len.i, i1 false)
  %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i = load i64, ptr %sso.i.i, align 8
  %sso.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 8
  %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i = load i64, ptr %sso.i.i.8.sroa_idx, align 8
  %ss0.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i, 0
  %ss1.i.i = insertvalue %ArchxStr %ss0.i.i, i64 %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i, 1
  br label %archx_str_from_int.exit

alloc_heap.i.i:                                   ; preds = %chk_sso.i.i
  %hp.i.i = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, -9223372036854775808) %len.i)
  %hnull.i.i = icmp eq ptr %hp.i.i, null
  br i1 %hnull.i.i, label %oom.i.i, label %copy_long.i.i

copy_long.i.i:                                    ; preds = %alloc_heap.i.i
  %hp_i.i.i = ptrtoint ptr %hp.i.i to i64
  %htagged.i.i = or disjoint i64 %hp_i.i.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, -9223372036854775808) %len.i, i1 false)
  %pref32.i.i = load i32, ptr %hp.i.i, align 16
  %pref64.i.i = zext i32 %pref32.i.i to i64
  %pref_sh.i.i = shl nuw i64 %pref64.i.i, 32
  %w0_out.i.i = or disjoint i64 %pref_sh.i.i, %len.i
  %ls0.i.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i, 0
  %ls1.i.i = insertvalue %ArchxStr %ls0.i.i, i64 %htagged.i.i, 1
  br label %archx_str_from_int.exit

archx_str_from_int.exit:                          ; preds = %s_int, %pack_sso.i.i, %copy_long.i.i
  %common.ret.op.i.i = phi %ArchxStr [ %ss1.i.i, %pack_sso.i.i ], [ %ls1.i.i, %copy_long.i.i ], [ zeroinitializer, %s_int ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i)
  br label %common.ret

s_flt:                                            ; preds = %entry
  %fv = bitcast i64 %w1 to double
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %buf.i9)
  %len.i10 = call fastcc i64 @archx_fmt_float_buf(double %fv, ptr %buf.i9)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i8)
  %z.i.i11 = icmp slt i64 %len.i10, 1
  br i1 %z.i.i11, label %archx_str_from_float.exit, label %chk_big.i.i

chk_big.i.i:                                      ; preds = %s_flt
  %big.i.i = icmp samesign ugt i64 %len.i10, 2147483647
  br i1 %big.i.i, label %oom.i.i27, label %chk_sso.i.i12

oom.i.i27:                                        ; preds = %alloc_heap.i.i14, %chk_big.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i12:                                    ; preds = %chk_big.i.i
  %short.i.i13 = icmp samesign ult i64 %len.i10, 13
  br i1 %short.i.i13, label %pack_sso.i.i28, label %alloc_heap.i.i14

pack_sso.i.i28:                                   ; preds = %chk_sso.i.i12
  %len32.i.i = trunc nuw nsw i64 %len.i10 to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i8, i8 0, i64 16, i1 false)
  store i32 %len32.i.i, ptr %sso.i.i8, align 8
  %sso.i.i8.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i8, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i8.4.sroa_idx, ptr nonnull readonly align 8 %buf.i9, i64 range(i64 -2147483648, -9223372036854775808) %len.i10, i1 false)
  %sso.i.i8.0.sso.i.i8.0.sso.i.i8.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i30 = load i64, ptr %sso.i.i8, align 8
  %sso.i.i8.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i8, i64 8
  %sso.i.i8.8.sso.i.i8.8.sso.i.i8.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i32 = load i64, ptr %sso.i.i8.8.sroa_idx, align 8
  %ss0.i.i33 = insertvalue %ArchxStr poison, i64 %sso.i.i8.0.sso.i.i8.0.sso.i.i8.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i30, 0
  %ss1.i.i34 = insertvalue %ArchxStr %ss0.i.i33, i64 %sso.i.i8.8.sso.i.i8.8.sso.i.i8.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i32, 1
  br label %archx_str_from_float.exit

alloc_heap.i.i14:                                 ; preds = %chk_sso.i.i12
  %hp.i.i15 = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, -9223372036854775808) %len.i10)
  %hnull.i.i16 = icmp eq ptr %hp.i.i15, null
  br i1 %hnull.i.i16, label %oom.i.i27, label %copy_long.i.i17

copy_long.i.i17:                                  ; preds = %alloc_heap.i.i14
  %hp_i.i.i18 = ptrtoint ptr %hp.i.i15 to i64
  %htagged.i.i19 = or disjoint i64 %hp_i.i.i18, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i15, ptr nonnull readonly align 8 %buf.i9, i64 range(i64 -2147483648, -9223372036854775808) %len.i10, i1 false)
  %pref32.i.i20 = load i32, ptr %hp.i.i15, align 16
  %pref64.i.i21 = zext i32 %pref32.i.i20 to i64
  %pref_sh.i.i22 = shl nuw i64 %pref64.i.i21, 32
  %w0_out.i.i23 = or disjoint i64 %pref_sh.i.i22, %len.i10
  %ls0.i.i24 = insertvalue %ArchxStr poison, i64 %w0_out.i.i23, 0
  %ls1.i.i25 = insertvalue %ArchxStr %ls0.i.i24, i64 %htagged.i.i19, 1
  br label %archx_str_from_float.exit

archx_str_from_float.exit:                        ; preds = %s_flt, %pack_sso.i.i28, %copy_long.i.i17
  %common.ret.op.i.i26 = phi %ArchxStr [ %ss1.i.i34, %pack_sso.i.i28 ], [ %ls1.i.i25, %copy_long.i.i17 ], [ zeroinitializer, %s_flt ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i8)
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %buf.i9)
  br label %common.ret

s_str:                                            ; preds = %entry
  %w2 = extractvalue %ArchxAny %v, 2
  %ss0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %ss1 = insertvalue %ArchxStr %ss0, i64 %w2, 1
  %len.i35 = and i64 %w1, 4294967295
  %long.i = icmp samesign ult i64 %len.i35, 13
  %tag.i = and i64 %w2, 3
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %long.i, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %common.ret, label %dup_heap.i

dup_heap.i:                                       ; preds = %s_str
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %len.i35)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i, label %copy.i

oom.i:                                            ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %w2, -4
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 4 %src.i, i64 %len.i35, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %out.i = insertvalue %ArchxStr %ss1, i64 %tagged.i, 1
  br label %common.ret

t5.i:                                             ; preds = %entry
  br label %common.ret

t6.i:                                             ; preds = %entry
  br label %common.ret

t7.i:                                             ; preds = %entry
  br label %common.ret
}

; Function Attrs: nofree nounwind
define private fastcc void @archx_any_print(%ArchxAny %v) unnamed_addr #4 {
entry:
  %tmp.i = alloca [12 x i8], align 4
  %buf.i = alloca [64 x i8], align 8
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  switch i64 %tag, label %p_dictset [
    i64 0, label %p_none
    i64 1, label %p_bool
    i64 2, label %p_int
    i64 3, label %p_flt
    i64 4, label %p_str
    i64 5, label %p_list
  ]

p_none:                                           ; preds = %entry
  %cn = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.str.elem, ptr nonnull @.str.none)
  br label %ret_done

p_bool:                                           ; preds = %entry
  %bt.not = icmp eq i64 %w1, 0
  %bp = select i1 %bt.not, ptr @.str.false, ptr @.str.true
  %cb = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.str.elem, ptr nonnull %bp)
  br label %ret_done

p_int:                                            ; preds = %entry
  %ci = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %w1)
  br label %ret_done

p_flt:                                            ; preds = %entry
  %fv = bitcast i64 %w1 to double
  call void @llvm.lifetime.start.p0(i64 64, ptr nonnull %buf.i)
  %len.i = call fastcc i64 @archx_fmt_float_buf(double %fv, ptr %buf.i)
  %r.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.str.elem, ptr nonnull %buf.i)
  call void @llvm.lifetime.end.p0(i64 64, ptr nonnull %buf.i)
  br label %ret_done

p_str:                                            ; preds = %entry
  %w2 = extractvalue %ArchxAny %v, 2
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  %len.i24 = and i64 %w1, 4294967295
  %short.i = icmp samesign ult i64 %len.i24, 13
  br i1 %short.i, label %emit.i, label %emit.thread.i

emit.thread.i:                                    ; preds = %p_str
  %raw.i = and i64 %w2, -4
  %lptr.i = inttoptr i64 %raw.i to ptr
  br label %chk_nul.i

emit.i:                                           ; preds = %p_str
  %p4.i = lshr i64 %w1, 32
  %p4_32.i = trunc nuw i64 %p4.i to i32
  store i32 %p4_32.i, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 %w2, ptr %tmp4.i, align 4
  %pos.not.i = icmp eq i64 %len.i24, 0
  br i1 %pos.not.i, label %archx_str_print.exit, label %chk_nul.i

chk_nul.i:                                        ; preds = %emit.i, %emit.thread.i
  %data3.i = phi ptr [ %lptr.i, %emit.thread.i ], [ %tmp.i, %emit.i ]
  %nul.i = call ptr @memchr(ptr nonnull %data3.i, i32 0, i64 %len.i24)
  %has_nul.not.i = icmp eq ptr %nul.i, null
  br i1 %has_nul.not.i, label %fast_printf.i, label %byte_loop.i

fast_printf.i:                                    ; preds = %chk_nul.i
  %len32.i = trunc i64 %w1 to i32
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 %len32.i, ptr nonnull %data3.i)
  br label %archx_str_print.exit

byte_loop.i:                                      ; preds = %chk_nul.i, %byte_loop.i
  %bi.i = phi i64 [ %bnext.i, %byte_loop.i ], [ 0, %chk_nul.i ]
  %bp.i = getelementptr inbounds nuw i8, ptr %data3.i, i64 %bi.i
  %ch8.i = load i8, ptr %bp.i, align 1
  %ch32.i = zext i8 %ch8.i to i32
  %pc.i = tail call i32 @putchar(i32 %ch32.i)
  %bnext.i = add nuw nsw i64 %bi.i, 1
  %exitcond.not.i = icmp eq i64 %bnext.i, %len.i24
  br i1 %exitcond.not.i, label %archx_str_print.exit, label %byte_loop.i

archx_str_print.exit:                             ; preds = %byte_loop.i, %emit.i, %fast_printf.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  br label %ret_done

p_list:                                           ; preds = %entry
  %putchar = tail call i32 @putchar(i32 91)
  %lraw = and i64 %w1, -4
  %lp = inttoptr i64 %lraw to ptr
  %lvec.unpack = load i64, ptr %lp, align 8
  %lvec.elt3 = getelementptr inbounds nuw i8, ptr %lp, i64 16
  %lvec.unpack4 = load ptr, ptr %lvec.elt3, align 8
  %lmore25 = icmp sgt i64 %lvec.unpack, 0
  br i1 %lmore25, label %ll_elem.peel, label %ll_done

ll_elem.peel:                                     ; preds = %p_list
  %le.elt9.peel.phi.trans.insert = getelementptr inbounds nuw i8, ptr %lvec.unpack4, i64 16
  %le.unpack10.peel.pre = load i64, ptr %le.elt9.peel.phi.trans.insert, align 8
  %le.elt7.peel.phi.trans.insert = getelementptr inbounds nuw i8, ptr %lvec.unpack4, i64 8
  %le.unpack8.peel.pre = load i64, ptr %le.elt7.peel.phi.trans.insert, align 8
  %le.unpack.peel.pre = load i64, ptr %lvec.unpack4, align 8
  %0 = insertvalue %ArchxAny poison, i64 %le.unpack.peel.pre, 0
  %1 = insertvalue %ArchxAny %0, i64 %le.unpack8.peel.pre, 1
  %le11.peel = insertvalue %ArchxAny %1, i64 %le.unpack10.peel.pre, 2
  tail call fastcc void @archx_any_print(%ArchxAny %le11.peel)
  %exitcond.peel.not = icmp eq i64 %lvec.unpack, 1
  br i1 %exitcond.peel.not, label %ll_done, label %ll_elem

ll_elem:                                          ; preds = %ll_elem.peel, %ll_elem
  %li26 = phi i64 [ %li_next, %ll_elem ], [ 1, %ll_elem.peel ]
  %lsc = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %lep = getelementptr inbounds nuw %ArchxAny, ptr %lvec.unpack4, i64 %li26
  %le.unpack = load i64, ptr %lep, align 8
  %2 = insertvalue %ArchxAny poison, i64 %le.unpack, 0
  %le.elt7 = getelementptr inbounds nuw i8, ptr %lep, i64 8
  %le.unpack8 = load i64, ptr %le.elt7, align 8
  %3 = insertvalue %ArchxAny %2, i64 %le.unpack8, 1
  %le.elt9 = getelementptr inbounds nuw i8, ptr %lep, i64 16
  %le.unpack10 = load i64, ptr %le.elt9, align 8
  %le11 = insertvalue %ArchxAny %3, i64 %le.unpack10, 2
  tail call fastcc void @archx_any_print(%ArchxAny %le11)
  %li_next = add nuw nsw i64 %li26, 1
  %exitcond.not = icmp eq i64 %li_next, %lvec.unpack
  br i1 %exitcond.not, label %ll_done, label %ll_elem, !llvm.loop !2

ll_done:                                          ; preds = %ll_elem, %ll_elem.peel, %p_list
  %putchar6 = tail call i32 @putchar(i32 93)
  br label %ret_done

p_dictset:                                        ; preds = %entry
  %putchar12 = tail call i32 @putchar(i32 123)
  %draw = and i64 %w1, -4
  %dz = icmp eq i64 %draw, 0
  br i1 %dz, label %dd_done, label %dd_init

dd_init:                                          ; preds = %p_dictset
  %dh = inttoptr i64 %draw to ptr
  %dlen = load i64, ptr %dh, align 8
  %dkp = getelementptr inbounds nuw i8, ptr %dh, i64 40
  %dvp = getelementptr inbounds nuw i8, ptr %dh, i64 48
  %dkeys = load ptr, ptr %dkp, align 8
  %dvals = load ptr, ptr %dvp, align 8
  %is_d = icmp eq i64 %tag, 6
  %dmore27 = icmp sgt i64 %dlen, 0
  br i1 %dmore27, label %dd_key.peel, label %dd_done

dd_key.peel:                                      ; preds = %dd_init
  %dkv.elt15.peel.phi.trans.insert = getelementptr inbounds nuw i8, ptr %dkeys, i64 16
  %dkv.unpack16.peel.pre = load i64, ptr %dkv.elt15.peel.phi.trans.insert, align 8
  %dkv.elt13.peel.phi.trans.insert = getelementptr inbounds nuw i8, ptr %dkeys, i64 8
  %dkv.unpack14.peel.pre = load i64, ptr %dkv.elt13.peel.phi.trans.insert, align 8
  %dkv.unpack.peel.pre = load i64, ptr %dkeys, align 8
  %4 = insertvalue %ArchxAny poison, i64 %dkv.unpack.peel.pre, 0
  %5 = insertvalue %ArchxAny %4, i64 %dkv.unpack14.peel.pre, 1
  %dkv17.peel = insertvalue %ArchxAny %5, i64 %dkv.unpack16.peel.pre, 2
  tail call fastcc void @archx_any_print(%ArchxAny %dkv17.peel)
  br i1 %is_d, label %dd_val.peel, label %dd_next.peel

dd_val.peel:                                      ; preds = %dd_key.peel
  %dcol.peel = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.colon)
  %dvv.unpack.peel = load i64, ptr %dvals, align 8
  %6 = insertvalue %ArchxAny poison, i64 %dvv.unpack.peel, 0
  %dvv.elt18.peel = getelementptr inbounds nuw i8, ptr %dvals, i64 8
  %dvv.unpack19.peel = load i64, ptr %dvv.elt18.peel, align 8
  %7 = insertvalue %ArchxAny %6, i64 %dvv.unpack19.peel, 1
  %dvv.elt20.peel = getelementptr inbounds nuw i8, ptr %dvals, i64 16
  %dvv.unpack21.peel = load i64, ptr %dvv.elt20.peel, align 8
  %dvv22.peel = insertvalue %ArchxAny %7, i64 %dvv.unpack21.peel, 2
  tail call fastcc void @archx_any_print(%ArchxAny %dvv22.peel)
  br label %dd_next.peel

dd_next.peel:                                     ; preds = %dd_val.peel, %dd_key.peel
  %exitcond30.peel.not = icmp eq i64 %dlen, 1
  br i1 %exitcond30.peel.not, label %dd_done, label %dd_key

dd_key:                                           ; preds = %dd_next.peel, %dd_next
  %di28 = phi i64 [ %di_next, %dd_next ], [ 1, %dd_next.peel ]
  %dsc = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %dk_e = getelementptr inbounds nuw %ArchxAny, ptr %dkeys, i64 %di28
  %dkv.unpack = load i64, ptr %dk_e, align 8
  %8 = insertvalue %ArchxAny poison, i64 %dkv.unpack, 0
  %dkv.elt13 = getelementptr inbounds nuw i8, ptr %dk_e, i64 8
  %dkv.unpack14 = load i64, ptr %dkv.elt13, align 8
  %9 = insertvalue %ArchxAny %8, i64 %dkv.unpack14, 1
  %dkv.elt15 = getelementptr inbounds nuw i8, ptr %dk_e, i64 16
  %dkv.unpack16 = load i64, ptr %dkv.elt15, align 8
  %dkv17 = insertvalue %ArchxAny %9, i64 %dkv.unpack16, 2
  tail call fastcc void @archx_any_print(%ArchxAny %dkv17)
  br i1 %is_d, label %dd_val, label %dd_next

dd_val:                                           ; preds = %dd_key
  %dcol = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.colon)
  %dv_e = getelementptr inbounds nuw %ArchxAny, ptr %dvals, i64 %di28
  %dvv.unpack = load i64, ptr %dv_e, align 8
  %10 = insertvalue %ArchxAny poison, i64 %dvv.unpack, 0
  %dvv.elt18 = getelementptr inbounds nuw i8, ptr %dv_e, i64 8
  %dvv.unpack19 = load i64, ptr %dvv.elt18, align 8
  %11 = insertvalue %ArchxAny %10, i64 %dvv.unpack19, 1
  %dvv.elt20 = getelementptr inbounds nuw i8, ptr %dv_e, i64 16
  %dvv.unpack21 = load i64, ptr %dvv.elt20, align 8
  %dvv22 = insertvalue %ArchxAny %11, i64 %dvv.unpack21, 2
  tail call fastcc void @archx_any_print(%ArchxAny %dvv22)
  br label %dd_next

dd_next:                                          ; preds = %dd_val, %dd_key
  %di_next = add nuw nsw i64 %di28, 1
  %exitcond30.not = icmp eq i64 %di_next, %dlen
  br i1 %exitcond30.not, label %dd_done, label %dd_key, !llvm.loop !4

dd_done:                                          ; preds = %dd_next, %dd_next.peel, %dd_init, %p_dictset
  %putchar23 = tail call i32 @putchar(i32 125)
  br label %ret_done

ret_done:                                         ; preds = %p_none, %p_bool, %p_int, %p_flt, %archx_str_print.exit, %ll_done, %dd_done
  ret void
}

; Function Attrs: nounwind
define private fastcc { i64, i64, i64 } @archx_any_get_idx(%ArchxAny %target, %ArchxAny %idx) unnamed_addr #0 {
entry:
  %tmp.i = alloca [12 x i8], align 4
  %ttag = extractvalue %ArchxAny %target, 0
  %tw1 = extractvalue %ArchxAny %target, 1
  %tw2 = extractvalue %ArchxAny %target, 2
  %iw1 = extractvalue %ArchxAny %idx, 1
  switch i64 %ttag, label %bad_idx [
    i64 5, label %gl_idx
    i64 6, label %g_dict
    i64 4, label %g_str
  ]

gl_idx:                                           ; preds = %entry
  %lraw = and i64 %tw1, -4
  %lp = inttoptr i64 %lraw to ptr
  %lvec.unpack = load i64, ptr %lp, align 8
  %neg = icmp slt i64 %iw1, 0
  %adj = select i1 %neg, i64 %lvec.unpack, i64 0
  %eff = add i64 %adj, %iw1
  %oob.not = icmp ult i64 %eff, %lvec.unpack
  br i1 %oob.not, label %gl_ok, label %gl_oob

gl_oob:                                           ; preds = %gl_idx
  tail call fastcc void @archx_bounds_fail(i64 %iw1, i64 %lvec.unpack)
  unreachable

common.ret:                                       ; preds = %archx_str_byte_at.exit, %gd_ok, %gl_ok
  %oldret22.pn = phi i64 [ %newret21, %gl_ok ], [ %newret, %gd_ok ], [ 4, %archx_str_byte_at.exit ]
  %newret23.pn = phi i64 [ %newret23, %gl_ok ], [ %newret17, %gd_ok ], [ %rw0.i, %archx_str_byte_at.exit ]
  %newret25.pn = phi i64 [ %newret25, %gl_ok ], [ %newret19, %gd_ok ], [ 0, %archx_str_byte_at.exit ]
  %newret2 = insertvalue { i64, i64, i64 } poison, i64 %oldret22.pn, 0
  %newret4 = insertvalue { i64, i64, i64 } %newret2, i64 %newret23.pn, 1
  %newret6 = insertvalue { i64, i64, i64 } %newret4, i64 %newret25.pn, 2
  ret { i64, i64, i64 } %newret6

gl_ok:                                            ; preds = %gl_idx
  %lvec.elt8 = getelementptr inbounds nuw i8, ptr %lp, i64 16
  %lvec.unpack9 = load ptr, ptr %lvec.elt8, align 8
  %ep = getelementptr inbounds %ArchxAny, ptr %lvec.unpack9, i64 %eff
  %ev.unpack = load i64, ptr %ep, align 8
  %0 = insertvalue %ArchxAny poison, i64 %ev.unpack, 0
  %ev.elt11 = getelementptr inbounds nuw i8, ptr %ep, i64 8
  %ev.unpack12 = load i64, ptr %ev.elt11, align 8
  %1 = insertvalue %ArchxAny %0, i64 %ev.unpack12, 1
  %ev.elt13 = getelementptr inbounds nuw i8, ptr %ep, i64 16
  %ev.unpack14 = load i64, ptr %ev.elt13, align 8
  %ev15 = insertvalue %ArchxAny %1, i64 %ev.unpack14, 2
  %ec = tail call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %ev15)
  %newret21 = extractvalue { i64, i64, i64 } %ec, 0
  %newret23 = extractvalue { i64, i64, i64 } %ec, 1
  %newret25 = extractvalue { i64, i64, i64 } %ec, 2
  br label %common.ret

g_dict:                                           ; preds = %entry
  %pair.i = tail call fastcc i64 @archx_dict_find_any(i64 %tw1, %ArchxAny %idx)
  %dfound = icmp sgt i64 %pair.i, -1
  br i1 %dfound, label %gd_ok, label %gd_miss

gd_miss:                                          ; preds = %g_dict
  tail call fastcc void @archx_key_fail()
  unreachable

gd_ok:                                            ; preds = %g_dict
  %draw = and i64 %tw1, -4
  %dh = inttoptr i64 %draw to ptr
  %dvp = getelementptr inbounds nuw i8, ptr %dh, i64 48
  %dvals = load ptr, ptr %dvp, align 8
  %vp = getelementptr inbounds nuw %ArchxAny, ptr %dvals, i64 %pair.i
  %vv.unpack = load i64, ptr %vp, align 8
  %2 = insertvalue %ArchxAny poison, i64 %vv.unpack, 0
  %vv.elt1 = getelementptr inbounds nuw i8, ptr %vp, i64 8
  %vv.unpack2 = load i64, ptr %vv.elt1, align 8
  %3 = insertvalue %ArchxAny %2, i64 %vv.unpack2, 1
  %vv.elt3 = getelementptr inbounds nuw i8, ptr %vp, i64 16
  %vv.unpack4 = load i64, ptr %vv.elt3, align 8
  %vv5 = insertvalue %ArchxAny %3, i64 %vv.unpack4, 2
  %vc = tail call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %vv5)
  %newret = extractvalue { i64, i64, i64 } %vc, 0
  %newret17 = extractvalue { i64, i64, i64 } %vc, 1
  %newret19 = extractvalue { i64, i64, i64 } %vc, 2
  br label %common.ret

g_str:                                            ; preds = %entry
  %slen = and i64 %tw1, 4294967295
  %sneg = icmp slt i64 %iw1, 0
  %sadj = select i1 %sneg, i64 %slen, i64 0
  %seff = add nsw i64 %sadj, %iw1
  %soob.not = icmp ult i64 %seff, %slen
  br i1 %soob.not, label %ok.i, label %gs_oob

gs_oob:                                           ; preds = %g_str
  tail call fastcc void @archx_bounds_fail(i64 %iw1, i64 %slen)
  unreachable

ok.i:                                             ; preds = %g_str
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  %short.i = icmp samesign ult i64 %slen, 13
  br i1 %short.i, label %mat_short.i, label %mat_long.i

mat_short.i:                                      ; preds = %ok.i
  %p4.i = lshr i64 %tw1, 32
  %p4_32.i = trunc nuw i64 %p4.i to i32
  store i32 %p4_32.i, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 %tw2, ptr %tmp4.i, align 4
  br label %archx_str_byte_at.exit

mat_long.i:                                       ; preds = %ok.i
  %raw.i = and i64 %tw2, -4
  %lptr.i = inttoptr i64 %raw.i to ptr
  br label %archx_str_byte_at.exit

archx_str_byte_at.exit:                           ; preds = %mat_short.i, %mat_long.i
  %base.i = phi ptr [ %tmp.i, %mat_short.i ], [ %lptr.i, %mat_long.i ]
  %bp.i = getelementptr inbounds nuw i8, ptr %base.i, i64 %seff
  %b8.i = load i8, ptr %bp.i, align 1
  %b64.i = zext i8 %b8.i to i64
  %sh.i = shl nuw nsw i64 %b64.i, 32
  %rw0.i = or disjoint i64 %sh.i, 1
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  br label %common.ret

bad_idx:                                          ; preds = %entry
  tail call fastcc void @archx_type_fail(ptr nonnull @.any.badidx)
  unreachable
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.cttz.i32(i32, i1 immarg) #11

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.abs.i64(i64, i1 immarg) #14

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smax.i64(i64, i64) #14

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @bcmp(ptr captures(none), ptr captures(none), i64) local_unnamed_addr #15

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.cttz.i16(i16, i1 immarg) #14

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #16

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #16

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
attributes #13 = { nofree norecurse nosync nounwind memory(read, inaccessiblemem: none) }
attributes #14 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #15 = { nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #16 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.unroll.disable"}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.peeled.count", i32 1}
!4 = distinct !{!4, !3}
