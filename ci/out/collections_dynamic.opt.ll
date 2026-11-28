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
@.fmt.g16 = private unnamed_addr constant [6 x i8] c"%.16g\00", align 1
@.fmt.g17 = private unnamed_addr constant [6 x i8] c"%.17g\00", align 1
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
@str = private unnamed_addr constant [38 x i8] c"archx runtime panic: integer overflow\00", align 1
@str.1 = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1
@str.3 = private unnamed_addr constant [57 x i8] c"archx runtime panic: KeyError: key not found in dict/set\00", align 1

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
  %t0 = tail call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %arg.val)
  %newret5 = extractvalue { i64, i64, i64 } %t0, 0
  %oldret6 = insertvalue %ArchxAny poison, i64 %newret5, 0
  %newret7 = extractvalue { i64, i64, i64 } %t0, 1
  %oldret8 = insertvalue %ArchxAny %oldret6, i64 %newret7, 1
  %newret9 = extractvalue { i64, i64, i64 } %t0, 2
  %oldret10 = insertvalue %ArchxAny %oldret8, i64 %newret9, 2
  %t1 = tail call fastcc i1 @archx_any_eq(%ArchxAny %oldret10, %ArchxAny zeroinitializer)
  tail call fastcc void @archx_any_drop(%ArchxAny %oldret10)
  br i1 %t1, label %common.ret, label %if.else.1

common.ret:                                       ; preds = %do_free.i52, %archx_str_drop.exit44, %do_free.i30, %archx_str_drop.exit22, %do_free.i8, %archx_str_drop.exit, %entry, %archx_str_clone.exit
  %common.ret.op = phi %ArchxAny [ %t39, %archx_str_clone.exit ], [ { i64 4, i64 8390326386350358533, i64 121 }, %entry ], [ %t14347, %archx_str_drop.exit ], [ %t14347, %do_free.i8 ], [ %t23357, %archx_str_drop.exit22 ], [ %t23357, %do_free.i30 ], [ %t33367, %archx_str_drop.exit44 ], [ %t33367, %do_free.i52 ]
  %oldret = extractvalue %ArchxAny %common.ret.op, 0
  %newret = insertvalue { i64, i64, i64 } poison, i64 %oldret, 0
  %oldret1 = extractvalue %ArchxAny %common.ret.op, 1
  %newret2 = insertvalue { i64, i64, i64 } %newret, i64 %oldret1, 1
  %oldret3 = extractvalue %ArchxAny %common.ret.op, 2
  %newret4 = insertvalue { i64, i64, i64 } %newret2, i64 %oldret3, 2
  ret { i64, i64, i64 } %newret4

if.else.1:                                        ; preds = %entry
  %t6 = extractvalue %ArchxAny %arg.val, 0
  switch i64 %t6, label %t7.i [
    i64 2, label %if.then.3
    i64 4, label %if.then.6
    i64 5, label %l_cont.i
    i64 0, label %archx_any_type_name.exit
    i64 1, label %t1.i
    i64 6, label %t6.i
    i64 3, label %t3.i
  ]

if.then.3:                                        ; preds = %if.else.1
  %t8 = tail call fastcc { i64, i64 } @archx_any_to_str(%ArchxAny %arg.val)
  %newret11 = extractvalue { i64, i64 } %t8, 0
  %newret13 = extractvalue { i64, i64 } %t8, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  %blen.i = and i64 %newret11, 4294967295
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
  %braw.i = and i64 %newret13, -4
  %blptr.i = inttoptr i64 %braw.i to ptr
  br label %alloc_heap.i

build.i:                                          ; preds = %mat_a.i
  %bp4.i = lshr i64 %newret11, 32
  %bp4_32.i = trunc nuw i64 %bp4.i to i32
  store i32 %bp4_32.i, ptr %btmp.i, align 4
  %btmp4.i = getelementptr inbounds nuw i8, ptr %btmp.i, i64 4
  store i64 %newret13, ptr %btmp4.i, align 4
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
  %t11342 = extractvalue %ArchxStr %common.ret.op.i81.ph, 0
  %t12343 = extractvalue %ArchxStr %common.ret.op.i81.ph, 1
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
  %t11342.pn = phi i64 [ %t11342, %archx_str_concat.exit93.thread ], [ %w0_out.i78, %archx_str_concat.exit93 ], [ %w0_out.i78, %do_free.i ]
  %t12343.pn = phi i64 [ %t12343, %archx_str_concat.exit93.thread ], [ %htagged.i73, %archx_str_concat.exit93 ], [ %htagged.i73, %do_free.i ]
  %t13344.pn = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t11342.pn, 1
  %t14347 = insertvalue %ArchxAny %t13344.pn, i64 %t12343.pn, 2
  %long.i3 = icmp samesign ult i64 %blen.i, 13
  %tag.i6 = and i64 %newret13, 1
  %owned.not.i7 = icmp eq i64 %tag.i6, 0
  %or.cond368 = select i1 %long.i3, i1 true, i1 %owned.not.i7
  br i1 %or.cond368, label %common.ret, label %do_free.i8

do_free.i8:                                       ; preds = %archx_str_drop.exit
  %raw.i9 = and i64 %newret13, -2
  %ptr.i10 = inttoptr i64 %raw.i9 to ptr
  tail call void @free(ptr %ptr.i10)
  br label %common.ret

if.then.6:                                        ; preds = %if.else.1
  %t17 = tail call fastcc { i64, i64 } @archx_any_to_str(%ArchxAny %arg.val)
  %newret15 = extractvalue { i64, i64 } %t17, 0
  %newret17 = extractvalue { i64, i64 } %t17, 1
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i95)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i96.sroa.6)
  %blen.i99 = and i64 %newret15, 4294967295
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
  %braw.i112 = and i64 %newret17, -4
  %blptr.i113 = inttoptr i64 %braw.i112 to ptr
  br label %alloc_heap.i117

build.i114:                                       ; preds = %mat_a.i105
  %bp4.i142 = lshr i64 %newret15, 32
  %bp4_32.i143 = trunc nuw i64 %bp4.i142 to i32
  store i32 %bp4_32.i143, ptr %btmp.i95, align 4
  %btmp4.i144 = getelementptr inbounds nuw i8, ptr %btmp.i95, i64 4
  store i64 %newret17, ptr %btmp4.i144, align 4
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
  %t20352 = extractvalue %ArchxStr %common.ret.op.i184.ph, 0
  %t21353 = extractvalue %ArchxStr %common.ret.op.i184.ph, 1
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
  %t20352.pn = phi i64 [ %t20352, %archx_str_concat.exit201.thread ], [ %w0_out.i181, %archx_str_concat.exit201 ], [ %w0_out.i181, %do_free.i19 ]
  %t21353.pn = phi i64 [ %t21353, %archx_str_concat.exit201.thread ], [ %htagged.i176, %archx_str_concat.exit201 ], [ %htagged.i176, %do_free.i19 ]
  %t22354.pn = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t20352.pn, 1
  %t23357 = insertvalue %ArchxAny %t22354.pn, i64 %t21353.pn, 2
  %long.i25 = icmp samesign ult i64 %blen.i99, 13
  %tag.i28 = and i64 %newret17, 1
  %owned.not.i29 = icmp eq i64 %tag.i28, 0
  %or.cond370 = select i1 %long.i25, i1 true, i1 %owned.not.i29
  br i1 %or.cond370, label %common.ret, label %do_free.i30

do_free.i30:                                      ; preds = %archx_str_drop.exit22
  %raw.i31 = and i64 %newret17, -2
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
  %t30362 = extractvalue %ArchxStr %common.ret.op.i292.ph, 0
  %t31363 = extractvalue %ArchxStr %common.ret.op.i292.ph, 1
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
  %t30362.pn = phi i64 [ %t30362, %archx_str_concat.exit309.thread ], [ %w0_out.i289, %archx_str_concat.exit309 ], [ %w0_out.i289, %do_free.i41 ]
  %t31363.pn = phi i64 [ %t31363, %archx_str_concat.exit309.thread ], [ %htagged.i284, %archx_str_concat.exit309 ], [ %htagged.i284, %do_free.i41 ]
  %t32364.pn = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t30362.pn, 1
  %t33367 = insertvalue %ArchxAny %t32364.pn, i64 %t31363.pn, 2
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
  %t36.pre-phi = phi i64 [ %w0.i323, %archx_any_type_name.exit ], [ %w0.i323, %chk_tag.i327 ], [ %.pre, %copy.i ]
  %common.ret.op.i326 = phi %ArchxStr [ %common.ret.op.i322, %archx_any_type_name.exit ], [ %common.ret.op.i322, %chk_tag.i327 ], [ %out.i, %copy.i ]
  %t37 = extractvalue %ArchxStr %common.ret.op.i326, 1
  %t38 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t36.pre-phi, 1
  %t39 = insertvalue %ArchxAny %t38, i64 %t37, 2
  br label %common.ret
}

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %tmp.i807 = alloca [12 x i8], align 4
  %tmp.i733 = alloca [12 x i8], align 4
  %tmp.i715 = alloca [12 x i8], align 4
  %tmp.i697 = alloca [12 x i8], align 4
  %tmp.i657 = alloca [12 x i8], align 4
  %tmp.i639 = alloca [12 x i8], align 4
  %tmp.i620 = alloca [12 x i8], align 4
  %tmp.i605 = alloca [12 x i8], align 4
  %sso.i.i595 = alloca [16 x i8], align 8
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
  %ctrl_p.i.i.i.i = getelementptr inbounds nuw i8, ptr %res.i.i.i, i64 32
  %mask_p.i.i.i.i = getelementptr inbounds nuw i8, ptr %res.i.i.i, i64 16
  %keys_p.i.i.i.i = getelementptr inbounds nuw i8, ptr %res.i.i.i, i64 40
  %t22.i = getelementptr inbounds nuw i8, ptr %res.i.i.i, i64 48
  br label %foreach.body.1.i

foreach.body.1.i:                                 ; preds = %foreach.step.2.i, %alloc.ok.0
  %var.w.5.sroa.0.0249.i = phi i64 [ 0, %alloc.ok.0 ], [ %t11.fca.0.extract.i, %foreach.step.2.i ]
  %var.w.5.sroa.7.0248.i = phi i64 [ 0, %alloc.ok.0 ], [ %t11.fca.1.extract.i, %foreach.step.2.i ]
  %foreach.idx.4.0247.i = phi i64 [ 0, %alloc.ok.0 ], [ %t40.i, %foreach.step.2.i ]
  %t8.i = getelementptr inbounds nuw %ArchxStr, ptr %t0, i64 %foreach.idx.4.0247.i
  %t9.unpack.i = load i64, ptr %t8.i, align 16
  %0 = insertvalue %ArchxStr poison, i64 %t9.unpack.i, 0
  %t9.elt19.i = getelementptr inbounds nuw i8, ptr %t8.i, i64 8
  %t9.unpack20.i = load i64, ptr %t9.elt19.i, align 8
  %t921.i = insertvalue %ArchxStr %0, i64 %t9.unpack20.i, 1
  %len.i.i = and i64 %var.w.5.sroa.0.0249.i, 4294967295
  %long.i.i = icmp samesign ult i64 %len.i.i, 13
  %tag.i.i = and i64 %var.w.5.sroa.7.0248.i, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond.i = select i1 %long.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond.i, label %archx_str_drop.exit.i, label %do_free.i.i

do_free.i.i:                                      ; preds = %foreach.body.1.i
  %raw.i.i532 = and i64 %var.w.5.sroa.7.0248.i, -2
  %ptr.i.i = inttoptr i64 %raw.i.i532 to ptr
  call void @free(ptr %ptr.i.i)
  br label %archx_str_drop.exit.i

archx_str_drop.exit.i:                            ; preds = %do_free.i.i, %foreach.body.1.i
  %len.i206.i = and i64 %t9.unpack.i, 4294967295
  %long.i207.i = icmp samesign ult i64 %len.i206.i, 13
  %tag.i209.i = and i64 %t9.unpack20.i, 3
  %owned.not.i210.i = icmp eq i64 %tag.i209.i, 0
  %or.cond221.i = select i1 %long.i207.i, i1 true, i1 %owned.not.i210.i
  br i1 %or.cond221.i, label %archx_str_clone.exit.i, label %dup_heap.i.i

dup_heap.i.i:                                     ; preds = %archx_str_drop.exit.i
  %dst.i.i = call noalias align 16 ptr @malloc(i64 %len.i206.i)
  %isnull.i.i = icmp eq ptr %dst.i.i, null
  br i1 %isnull.i.i, label %oom.i.i, label %copy.i.i

oom.i.i:                                          ; preds = %dup_heap.i.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i:                                         ; preds = %dup_heap.i.i
  %src_i.i.i = and i64 %t9.unpack20.i, -4
  %src.i.i = inttoptr i64 %src_i.i.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i, ptr nonnull align 4 %src.i.i, i64 %len.i206.i, i1 false)
  %dst_i.i.i = ptrtoint ptr %dst.i.i to i64
  %tagged.i.i = or disjoint i64 %dst_i.i.i, 1
  %out.i.i = insertvalue %ArchxStr %t921.i, i64 %tagged.i.i, 1
  br label %archx_str_clone.exit.i

archx_str_clone.exit.i:                           ; preds = %copy.i.i, %archx_str_drop.exit.i
  %common.ret.op.i.i533 = phi %ArchxStr [ %out.i.i, %copy.i.i ], [ %t921.i, %archx_str_drop.exit.i ]
  %t11.fca.0.extract.i = extractvalue %ArchxStr %common.ret.op.i.i533, 0
  %t11.fca.1.extract.i = extractvalue %ArchxStr %common.ret.op.i.i533, 1
  %len.i.i.i.i534 = and i64 %t11.fca.0.extract.i, 4294967295
  %short.i.i.i.i535 = icmp samesign ult i64 %len.i.i.i.i534, 13
  br i1 %short.i.i.i.i535, label %sso_hash.i.i.i.i, label %long_hash.i.i.i.i

sso_hash.i.i.i.i:                                 ; preds = %archx_str_clone.exit.i
  %p0_raw.i.i.i.i = lshr i64 %t11.fca.0.extract.i, 32
  %le4.i.i.i.i = icmp samesign ult i64 %len.i.i.i.i534, 5
  br i1 %le4.i.i.i.i, label %sso_le4.i.i.i.i, label %sso_gt4.i.i.i.i

sso_le4.i.i.i.i:                                  ; preds = %sso_hash.i.i.i.i
  %sh0.i.i.i.i = shl nuw nsw i64 %len.i.i.i.i534, 3
  %notmask1.i.i.i.i = shl nsw i64 -1, %sh0.i.i.i.i
  %m0.i.i.i.i = xor i64 %notmask1.i.i.i.i, -1
  %p0_4.i.i.i.i = and i64 %p0_raw.i.i.i.i, %m0.i.i.i.i
  br label %sso_mix.i.i.i.i

sso_gt4.i.i.i.i:                                  ; preds = %sso_hash.i.i.i.i
  %eq12.i.i.i.i = icmp eq i64 %len.i.i.i.i534, 12
  br i1 %eq12.i.i.i.i, label %sso_mix.i.i.i.i, label %sso_mid.i.i.i.i

sso_mid.i.i.i.i:                                  ; preds = %sso_gt4.i.i.i.i
  %rem.i.i.i.i538 = shl nuw nsw i64 %len.i.i.i.i534, 3
  %sh1.i.i.i.i = add nsw i64 %rem.i.i.i.i538, -32
  %notmask.i.i.i.i = shl nsw i64 -1, %sh1.i.i.i.i
  %m1.i.i.i.i = xor i64 %notmask.i.i.i.i, -1
  %p1_m.i.i.i.i = and i64 %t11.fca.1.extract.i, %m1.i.i.i.i
  br label %sso_mix.i.i.i.i

sso_mix.i.i.i.i:                                  ; preds = %sso_mid.i.i.i.i, %sso_gt4.i.i.i.i, %sso_le4.i.i.i.i
  %p0.i.i.i.i = phi i64 [ %p0_4.i.i.i.i, %sso_le4.i.i.i.i ], [ %p0_raw.i.i.i.i, %sso_mid.i.i.i.i ], [ %p0_raw.i.i.i.i, %sso_gt4.i.i.i.i ]
  %p1.i.i.i.i = phi i64 [ 0, %sso_le4.i.i.i.i ], [ %p1_m.i.i.i.i, %sso_mid.i.i.i.i ], [ %t11.fca.1.extract.i, %sso_gt4.i.i.i.i ]
  %a0.i.i.i.i = mul i64 %p0.i.i.i.i, -7046029254386353131
  %a1.i.i.i.i = mul i64 %p1.i.i.i.i, -4417276706812531889
  %ax.i.i.i.i = xor i64 %a1.i.i.i.i, %a0.i.i.i.i
  %s1.i10.i.i.i.i = lshr i64 %ax.i.i.i.i, 30
  %1 = xor i64 %len.i.i.i.i534, %s1.i10.i.i.i.i
  %x1.i11.i.i.i.i = xor i64 %1, %ax.i.i.i.i
  br label %chk_ctrl.i.i.i.i

long_hash.i.i.i.i:                                ; preds = %archx_str_clone.exit.i
  %raw.i.i.i.i = and i64 %t11.fca.1.extract.i, -4
  %ptr.i.i.i.i = inttoptr i64 %raw.i.i.i.i to ptr
  %seed.i.i.i.i = mul i64 %len.i.i.i.i534, -7046029254386353131
  %2 = add nsw i64 %len.i.i.i.i534, -8
  %3 = icmp ult i64 %2, 8
  br i1 %3, label %l_tail_cond.i.i.i.preheader.i.unr-lcssa, label %long_hash.i.i.i.i.new

long_hash.i.i.i.i.new:                            ; preds = %long_hash.i.i.i.i
  %4 = lshr i64 %2, 3
  %5 = add nuw nsw i64 %4, 1
  %unroll_iter = and i64 %5, 4611686018427387902
  br label %l_body.i.i.i.i

l_tail_cond.i.i.i.preheader.i.unr-lcssa:          ; preds = %l_body.i.i.i.i, %long_hash.i.i.i.i
  %acc_next.i.i.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i.i ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx_next.i.i.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i.i ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %acc.i.i.i233.i.unr = phi i64 [ %seed.i.i.i.i, %long_hash.i.i.i.i ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx.i.i.i232.i.unr = phi i64 [ 0, %long_hash.i.i.i.i ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %6 = and i64 %2, 8
  %lcmp.mod.not.not = icmp eq i64 %6, 0
  br i1 %lcmp.mod.not.not, label %l_body.i.i.i.i.epil, label %l_tail_cond.i.i.i.preheader.i

l_body.i.i.i.i.epil:                              ; preds = %l_tail_cond.i.i.i.preheader.i.unr-lcssa
  %lp.i.i.i.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %idx.i.i.i232.i.unr
  %lane.i.i.i.i.epil = load i64, ptr %lp.i.i.i.i.epil, align 4
  %lm.i.i.i.i.epil = mul i64 %lane.i.i.i.i.epil, -4417276706812531889
  %lx.i.i.i.i.epil = xor i64 %lm.i.i.i.i.epil, %acc.i.i.i233.i.unr
  %s1.i2.i.i.i.i.epil = lshr i64 %lx.i.i.i.i.epil, 30
  %x1.i3.i.i.i.i.epil = xor i64 %s1.i2.i.i.i.i.epil, %lx.i.i.i.i.epil
  %m1.i4.i.i.i.i.epil = mul i64 %x1.i3.i.i.i.i.epil, -4658895280553007687
  %s2.i5.i.i.i.i.epil = lshr i64 %m1.i4.i.i.i.i.epil, 27
  %x2.i6.i.i.i.i.epil = xor i64 %s2.i5.i.i.i.i.epil, %m1.i4.i.i.i.i.epil
  %m2.i7.i.i.i.i.epil = mul i64 %x2.i6.i.i.i.i.epil, -7723592293110705685
  %s3.i8.i.i.i.i.epil = lshr i64 %m2.i7.i.i.i.i.epil, 31
  %x3.i9.i.i.i.i.epil = xor i64 %s3.i8.i.i.i.i.epil, %m2.i7.i.i.i.i.epil
  %acc_next.i.i.i.i.epil = add i64 %x3.i9.i.i.i.i.epil, %idx.i.i.i232.i.unr
  %idx_next.i.i.i.i.epil = add nuw nsw i64 %idx.i.i.i232.i.unr, 8
  br label %l_tail_cond.i.i.i.preheader.i

l_tail_cond.i.i.i.preheader.i:                    ; preds = %l_tail_cond.i.i.i.preheader.i.unr-lcssa, %l_body.i.i.i.i.epil
  %acc_next.i.i.i.i.lcssa = phi i64 [ %acc_next.i.i.i.i.lcssa.ph, %l_tail_cond.i.i.i.preheader.i.unr-lcssa ], [ %acc_next.i.i.i.i.epil, %l_body.i.i.i.i.epil ]
  %idx_next.i.i.i.i.lcssa = phi i64 [ %idx_next.i.i.i.i.lcssa.ph, %l_tail_cond.i.i.i.preheader.i.unr-lcssa ], [ %idx_next.i.i.i.i.epil, %l_body.i.i.i.i.epil ]
  %tmore.i.i.i234.i = icmp samesign ult i64 %idx_next.i.i.i.i.lcssa, %len.i.i.i.i534
  br i1 %tmore.i.i.i234.i, label %l_tail_body.i.i.i.i.preheader, label %l_done.i.i.i.i

l_tail_body.i.i.i.i.preheader:                    ; preds = %l_tail_cond.i.i.i.preheader.i
  %7 = sub i64 %t11.fca.0.extract.i, %idx_next.i.i.i.i.lcssa
  %xtraiter1036 = and i64 %7, 3
  %lcmp.mod1037.not = icmp eq i64 %xtraiter1036, 0
  br i1 %lcmp.mod1037.not, label %l_tail_body.i.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.i.prol

l_tail_body.i.i.i.i.prol:                         ; preds = %l_tail_body.i.i.i.i.preheader, %l_tail_body.i.i.i.i.prol
  %tacc.i.i.i236.i.prol = phi i64 [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ], [ %acc_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ]
  %ti.i.i.i235.i.prol = phi i64 [ %ti_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ], [ %idx_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %l_tail_body.i.i.i.i.prol ], [ 0, %l_tail_body.i.i.i.i.preheader ]
  %tp.i.i.i.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %ti.i.i.i235.i.prol
  %tb.i.i.i.i.prol = load i8, ptr %tp.i.i.i.i.prol, align 1
  %tz.i.i.i.i.prol = zext i8 %tb.i.i.i.i.prol to i64
  %tx.i.i.i.i.prol = xor i64 %tacc.i.i.i236.i.prol, %tz.i.i.i.i.prol
  %tacc_next.i.i.i.i.prol = mul i64 %tx.i.i.i.i.prol, 1099511628211
  %ti_next.i.i.i.i.prol = add nuw nsw i64 %ti.i.i.i235.i.prol, 1
  %prol.iter.next = add i64 %prol.iter, 1
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter1036
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.i.prol, !llvm.loop !2

l_tail_body.i.i.i.i.prol.loopexit:                ; preds = %l_tail_body.i.i.i.i.prol, %l_tail_body.i.i.i.i.preheader
  %tacc.i.i.i236.i.unr = phi i64 [ %acc_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ], [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %ti.i.i.i235.i.unr = phi i64 [ %idx_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ], [ %ti_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %tacc_next.i.i.i.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.i.i.preheader ], [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %8 = sub i64 %idx_next.i.i.i.i.lcssa, %len.i.i.i.i534
  %9 = icmp ugt i64 %8, -4
  br i1 %9, label %l_done.i.i.i.i, label %l_tail_body.i.i.i.i.preheader.new

l_tail_body.i.i.i.i.preheader.new:                ; preds = %l_tail_body.i.i.i.i.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr.i.i.i.i, i64 1
  %invariant.gep1052 = getelementptr i8, ptr %ptr.i.i.i.i, i64 2
  %invariant.gep1054 = getelementptr i8, ptr %ptr.i.i.i.i, i64 3
  br label %l_tail_body.i.i.i.i

l_body.i.i.i.i:                                   ; preds = %l_body.i.i.i.i, %long_hash.i.i.i.i.new
  %acc.i.i.i233.i = phi i64 [ %seed.i.i.i.i, %long_hash.i.i.i.i.new ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx.i.i.i232.i = phi i64 [ 0, %long_hash.i.i.i.i.new ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %niter = phi i64 [ 0, %long_hash.i.i.i.i.new ], [ %niter.next.1, %l_body.i.i.i.i ]
  %lp.i.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %idx.i.i.i232.i
  %lane.i.i.i.i = load i64, ptr %lp.i.i.i.i, align 4
  %lm.i.i.i.i = mul i64 %lane.i.i.i.i, -4417276706812531889
  %lx.i.i.i.i = xor i64 %lm.i.i.i.i, %acc.i.i.i233.i
  %s1.i2.i.i.i.i = lshr i64 %lx.i.i.i.i, 30
  %x1.i3.i.i.i.i = xor i64 %s1.i2.i.i.i.i, %lx.i.i.i.i
  %m1.i4.i.i.i.i = mul i64 %x1.i3.i.i.i.i, -4658895280553007687
  %s2.i5.i.i.i.i = lshr i64 %m1.i4.i.i.i.i, 27
  %x2.i6.i.i.i.i = xor i64 %s2.i5.i.i.i.i, %m1.i4.i.i.i.i
  %m2.i7.i.i.i.i = mul i64 %x2.i6.i.i.i.i, -7723592293110705685
  %s3.i8.i.i.i.i = lshr i64 %m2.i7.i.i.i.i, 31
  %x3.i9.i.i.i.i = xor i64 %s3.i8.i.i.i.i, %m2.i7.i.i.i.i
  %acc_next.i.i.i.i = add i64 %x3.i9.i.i.i.i, %idx.i.i.i232.i
  %idx_next.i.i.i.i = or disjoint i64 %idx.i.i.i232.i, 8
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
  %idx_next.i.i.i.i.1 = add nuw nsw i64 %idx.i.i.i232.i, 16
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1.not = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1.not, label %l_tail_cond.i.i.i.preheader.i.unr-lcssa, label %l_body.i.i.i.i

l_tail_body.i.i.i.i:                              ; preds = %l_tail_body.i.i.i.i, %l_tail_body.i.i.i.i.preheader.new
  %tacc.i.i.i236.i = phi i64 [ %tacc.i.i.i236.i.unr, %l_tail_body.i.i.i.i.preheader.new ], [ %tacc_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %ti.i.i.i235.i = phi i64 [ %ti.i.i.i235.i.unr, %l_tail_body.i.i.i.i.preheader.new ], [ %ti_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %tp.i.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %ti.i.i.i235.i
  %tb.i.i.i.i = load i8, ptr %tp.i.i.i.i, align 1
  %tz.i.i.i.i = zext i8 %tb.i.i.i.i to i64
  %tx.i.i.i.i = xor i64 %tacc.i.i.i236.i, %tz.i.i.i.i
  %tacc_next.i.i.i.i = mul i64 %tx.i.i.i.i, 1099511628211
  %gep = getelementptr i8, ptr %invariant.gep, i64 %ti.i.i.i235.i
  %tb.i.i.i.i.1 = load i8, ptr %gep, align 1
  %tz.i.i.i.i.1 = zext i8 %tb.i.i.i.i.1 to i64
  %tx.i.i.i.i.1 = xor i64 %tacc_next.i.i.i.i, %tz.i.i.i.i.1
  %tacc_next.i.i.i.i.1 = mul i64 %tx.i.i.i.i.1, 1099511628211
  %gep1053 = getelementptr i8, ptr %invariant.gep1052, i64 %ti.i.i.i235.i
  %tb.i.i.i.i.2 = load i8, ptr %gep1053, align 1
  %tz.i.i.i.i.2 = zext i8 %tb.i.i.i.i.2 to i64
  %tx.i.i.i.i.2 = xor i64 %tacc_next.i.i.i.i.1, %tz.i.i.i.i.2
  %tacc_next.i.i.i.i.2 = mul i64 %tx.i.i.i.i.2, 1099511628211
  %gep1055 = getelementptr i8, ptr %invariant.gep1054, i64 %ti.i.i.i235.i
  %tb.i.i.i.i.3 = load i8, ptr %gep1055, align 1
  %tz.i.i.i.i.3 = zext i8 %tb.i.i.i.i.3 to i64
  %tx.i.i.i.i.3 = xor i64 %tacc_next.i.i.i.i.2, %tz.i.i.i.i.3
  %tacc_next.i.i.i.i.3 = mul i64 %tx.i.i.i.i.3, 1099511628211
  %ti_next.i.i.i.i.3 = add nuw nsw i64 %ti.i.i.i235.i, 4
  %tmore.i.i.i.i.3 = icmp samesign ult i64 %ti_next.i.i.i.i.3, %len.i.i.i.i534
  br i1 %tmore.i.i.i.i.3, label %l_tail_body.i.i.i.i, label %l_done.i.i.i.i

l_done.i.i.i.i:                                   ; preds = %l_tail_body.i.i.i.i.prol.loopexit, %l_tail_body.i.i.i.i, %l_tail_cond.i.i.i.preheader.i
  %tacc.i.i.i.lcssa.i = phi i64 [ %acc_next.i.i.i.i.lcssa, %l_tail_cond.i.i.i.preheader.i ], [ %tacc_next.i.i.i.i.lcssa.unr, %l_tail_body.i.i.i.i.prol.loopexit ], [ %tacc_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %s1.i.i.i.i.i = lshr i64 %tacc.i.i.i.lcssa.i, 30
  %x1.i.i.i.i.i = xor i64 %s1.i.i.i.i.i, %tacc.i.i.i.lcssa.i
  br label %chk_ctrl.i.i.i.i

chk_ctrl.i.i.i.i:                                 ; preds = %l_done.i.i.i.i, %sso_mix.i.i.i.i
  %x1.i11.i.i.i.sink.i = phi i64 [ %x1.i11.i.i.i.i, %sso_mix.i.i.i.i ], [ %x1.i.i.i.i.i, %l_done.i.i.i.i ]
  %ctrl.i.i.i.i = load ptr, ptr %ctrl_p.i.i.i.i, align 16
  %c_null.i.i.i.i = icmp eq ptr %ctrl.i.i.i.i, null
  br i1 %c_null.i.i.i.i, label %if.else.5.i, label %do_probe.i.i.i.i

do_probe.i.i.i.i:                                 ; preds = %chk_ctrl.i.i.i.i
  %m1.i12.i.i.i.i = mul i64 %x1.i11.i.i.i.sink.i, -4658895280553007687
  %s2.i13.i.i.i.i = lshr i64 %m1.i12.i.i.i.i, 27
  %x2.i14.i.i.i.i = xor i64 %s2.i13.i.i.i.i, %m1.i12.i.i.i.i
  %m2.i15.i.i.i.i = mul i64 %x2.i14.i.i.i.i, -7723592293110705685
  %s3.i16.i.i.i.i = lshr i64 %m2.i15.i.i.i.i, 31
  %x3.i17.i.i.i.i = xor i64 %s3.i16.i.i.i.i, %m2.i15.i.i.i.i
  %mask.i.i.i.i = load i64, ptr %mask_p.i.i.i.i, align 16
  %keys.i.i.i.i = load ptr, ptr %keys_p.i.i.i.i, align 8
  %10 = getelementptr i8, ptr %ctrl.i.i.i.i, i64 %mask.i.i.i.i
  %idx_base.i.i.i.i = getelementptr i8, ptr %10, i64 17
  %h2_64.i.i.i.i = lshr i64 %m2.i15.i.i.i.i, 57
  %h2.i.i.i.i = trunc nuw nsw i64 %h2_64.i.i.i.i to i8
  %h2_ins.i.i.i.i = insertelement <16 x i8> poison, i8 %h2.i.i.i.i, i64 0
  %h2_vec.i.i.i.i = shufflevector <16 x i8> %h2_ins.i.i.i.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bp_i.i.i.i.i.i = and i64 %t11.fca.1.extract.i, -4
  %bp.i.i.i.i.i = inttoptr i64 %bp_i.i.i.i.i.i to ptr
  %bp4.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %bp.i.i.i.i.i, i64 4
  %rem.i.i.i.i.i = add nsw i64 %len.i.i.i.i534, -4
  br label %probe.i.i.i.i

probe.i.i.i.i:                                    ; preds = %next_grp.i.i.i.i, %do_probe.i.i.i.i
  %h.pn.i.i.i.i = phi i64 [ %x3.i17.i.i.i.i, %do_probe.i.i.i.i ], [ %padd.i.i.i.i, %next_grp.i.i.i.i ]
  %step.i.i.i.i = phi i64 [ 0, %do_probe.i.i.i.i ], [ %step_next.i.i.i.i, %next_grp.i.i.i.i ]
  %avail.i.i.i.i = phi i64 [ -1, %do_probe.i.i.i.i ], [ %avail_cur.i.i.i.i, %next_grp.i.i.i.i ]
  %pos.i.i.i.i = and i64 %h.pn.i.i.i.i, %mask.i.i.i.i
  %gp.i.i.i.i = getelementptr inbounds i8, ptr %ctrl.i.i.i.i, i64 %pos.i.i.i.i
  %grp.i.i.i.i = load <16 x i8>, ptr %gp.i.i.i.i, align 1
  %mcmp.i.i.i.i = icmp eq <16 x i8> %grp.i.i.i.i, %h2_vec.i.i.i.i
  %mbits.i.i.i.i = bitcast <16 x i1> %mcmp.i.i.i.i to i16
  %has_m.not.i.i.i237.i = icmp eq i16 %mbits.i.i.i.i, 0
  br i1 %has_m.not.i.i.i237.i, label %chk_empty.i.i.i.i, label %chk_key.i.i.i.preheader.i

chk_key.i.i.i.preheader.i:                        ; preds = %probe.i.i.i.i
  %mmask0.i.i.i.i = zext i16 %mbits.i.i.i.i to i32
  br label %chk_key.i.i.i.i

chk_key.i.i.i.i:                                  ; preds = %mbit_cont.i.i.i.i, %chk_key.i.i.i.preheader.i
  %mmask.i.i.i238.i = phi i32 [ %mmask_next.i.i.i.i, %mbit_cont.i.i.i.i ], [ %mmask0.i.i.i.i, %chk_key.i.i.i.preheader.i ]
  %tz.i2.i.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i238.i, i1 true)
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
  %w0_eq.i.i.i.i.i = icmp eq i64 %cand_k.unpack.i.i.i.i, %t11.fca.0.extract.i
  br i1 %w0_eq.i.i.i.i.i, label %chk_len.i.i.i.i.i, label %mbit_cont.i.i.i.i

chk_len.i.i.i.i.i:                                ; preds = %chk_key.i.i.i.i
  br i1 %short.i.i.i.i535, label %cmp_short.i.i.i.i.i, label %cmp_long.i.i.i.i.i

cmp_short.i.i.i.i.i:                              ; preds = %chk_len.i.i.i.i.i
  %eq_s.i.i.i.i.i = icmp eq i64 %cand_k.unpack2.i.i.i.i, %t11.fca.1.extract.i
  br i1 %eq_s.i.i.i.i.i, label %sso_hash.i.i.i174.i, label %mbit_cont.i.i.i.i

cmp_long.i.i.i.i.i:                               ; preds = %chk_len.i.i.i.i.i
  %ap_i.i.i.i.i.i = and i64 %cand_k.unpack2.i.i.i.i, -4
  %same_ptr.i.i.i.i.i = icmp eq i64 %ap_i.i.i.i.i.i, %bp_i.i.i.i.i.i
  br i1 %same_ptr.i.i.i.i.i, label %long_hash.i.i.i35.i, label %archx_str_eq.exit.i.i.i.i

archx_str_eq.exit.i.i.i.i:                        ; preds = %cmp_long.i.i.i.i.i
  %ap.i.i.i.i.i = inttoptr i64 %ap_i.i.i.i.i.i to ptr
  %ap4.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i.i, i64 4
  %bcmp.i.i.i.i.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i.i.i, ptr nonnull %bp4.i.i.i.i.i, i64 %rem.i.i.i.i.i)
  %eq_m.i.i.i.i.i = icmp eq i32 %bcmp.i.i.i.i.i, 0
  br i1 %eq_m.i.i.i.i.i, label %long_hash.i.i.i35.i, label %mbit_cont.i.i.i.i

mbit_cont.i.i.i.i:                                ; preds = %archx_str_eq.exit.i.i.i.i, %cmp_short.i.i.i.i.i, %chk_key.i.i.i.i
  %mm1.i.i.i.i = add nsw i32 %mmask.i.i.i238.i, -1
  %mmask_next.i.i.i.i = and i32 %mm1.i.i.i.i, %mmask.i.i.i238.i
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
  %11 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i.i, i1 true)
  %atz64.i.i.i.i = zext nneg i16 %11 to i64
  %as_add.i.i.i.i = add i64 %pos.i.i.i.i, %atz64.i.i.i.i
  %aslot.i.i.i.i = and i64 %as_add.i.i.i.i, %mask.i.i.i.i
  br label %after_a.i.i.i.i

after_a.i.i.i.i:                                  ; preds = %set_a.i.i.i.i, %find_a.i.i.i.i, %chk_empty.i.i.i.i
  %avail_cur.i.i.i.i = phi i64 [ %avail.i.i.i.i, %chk_empty.i.i.i.i ], [ -1, %find_a.i.i.i.i ], [ %aslot.i.i.i.i, %set_a.i.i.i.i ]
  %ecmp.i.i.i.i = icmp eq <16 x i8> %grp.i.i.i.i, splat (i8 -128)
  %ebits.i.i.i.i = bitcast <16 x i1> %ecmp.i.i.i.i to i16
  %has_e.not.i.i.i.i = icmp eq i16 %ebits.i.i.i.i, 0
  br i1 %has_e.not.i.i.i.i, label %next_grp.i.i.i.i, label %if.else.5.i

next_grp.i.i.i.i:                                 ; preds = %after_a.i.i.i.i
  %step_next.i.i.i.i = add i64 %step.i.i.i.i, 16
  %padd.i.i.i.i = add i64 %step_next.i.i.i.i, %pos.i.i.i.i
  br label %probe.i.i.i.i

sso_hash.i.i.i174.i:                              ; preds = %cmp_short.i.i.i.i.i
  %p0_raw.i.i.i175.i = lshr i64 %t11.fca.0.extract.i, 32
  %le4.i.i.i176.i = icmp samesign ult i64 %len.i.i.i.i534, 5
  br i1 %le4.i.i.i176.i, label %sso_le4.i.i.i200.i, label %sso_gt4.i.i.i177.i

sso_le4.i.i.i200.i:                               ; preds = %sso_hash.i.i.i174.i
  %sh0.i.i.i201.i = shl nuw nsw i64 %len.i.i.i.i534, 3
  %notmask1.i.i.i202.i = shl nsw i64 -1, %sh0.i.i.i201.i
  %m0.i.i.i203.i = xor i64 %notmask1.i.i.i202.i, -1
  %p0_4.i.i.i204.i = and i64 %p0_raw.i.i.i175.i, %m0.i.i.i203.i
  br label %sso_mix.i.i.i185.i

sso_gt4.i.i.i177.i:                               ; preds = %sso_hash.i.i.i174.i
  %eq12.i.i.i178.i = icmp eq i64 %len.i.i.i.i534, 12
  br i1 %eq12.i.i.i178.i, label %sso_mix.i.i.i185.i, label %sso_mid.i.i.i179.i

sso_mid.i.i.i179.i:                               ; preds = %sso_gt4.i.i.i177.i
  %rem.i.i.i180.i = shl nuw nsw i64 %len.i.i.i.i534, 3
  %sh1.i.i.i181.i = add nsw i64 %rem.i.i.i180.i, -32
  %notmask.i.i.i182.i = shl nsw i64 -1, %sh1.i.i.i181.i
  %m1.i.i.i183.i = xor i64 %notmask.i.i.i182.i, -1
  %p1_m.i.i.i184.i = and i64 %t11.fca.1.extract.i, %m1.i.i.i183.i
  br label %sso_mix.i.i.i185.i

sso_mix.i.i.i185.i:                               ; preds = %sso_mid.i.i.i179.i, %sso_gt4.i.i.i177.i, %sso_le4.i.i.i200.i
  %p0.i.i.i186.i = phi i64 [ %p0_4.i.i.i204.i, %sso_le4.i.i.i200.i ], [ %p0_raw.i.i.i175.i, %sso_mid.i.i.i179.i ], [ %p0_raw.i.i.i175.i, %sso_gt4.i.i.i177.i ]
  %p1.i.i.i187.i = phi i64 [ 0, %sso_le4.i.i.i200.i ], [ %p1_m.i.i.i184.i, %sso_mid.i.i.i179.i ], [ %t11.fca.1.extract.i, %sso_gt4.i.i.i177.i ]
  %a0.i.i.i188.i = mul i64 %p0.i.i.i186.i, -7046029254386353131
  %a1.i.i.i189.i = mul i64 %p1.i.i.i187.i, -4417276706812531889
  %ax.i.i.i190.i = xor i64 %a1.i.i.i189.i, %a0.i.i.i188.i
  %s1.i10.i.i.i192.i = lshr i64 %ax.i.i.i190.i, 30
  %12 = xor i64 %len.i.i.i.i534, %s1.i10.i.i.i192.i
  %x1.i11.i.i.i193.i = xor i64 %12, %ax.i.i.i190.i
  br label %do_probe.i.i.i66.i

long_hash.i.i.i35.i:                              ; preds = %archx_str_eq.exit.i.i.i.i, %cmp_long.i.i.i.i.i
  %seed.i.i.i38.i = mul i64 %len.i.i.i.i534, -7046029254386353131
  %invariant.op270.i = add nsw i64 %len.i.i.i.i534, -7
  br label %l_body.i.i.i159.i

l_tail_cond.i.i.i44.preheader.i:                  ; preds = %l_body.i.i.i159.i
  %tmore.i.i.i47241.i = icmp samesign ult i64 %idx_next.i.i.i173.i, %len.i.i.i.i534
  br i1 %tmore.i.i.i47241.i, label %l_tail_body.i.i.i152.i, label %l_done.i.i.i48.i

l_body.i.i.i159.i:                                ; preds = %l_body.i.i.i159.i, %long_hash.i.i.i35.i
  %acc.i.i.i41240.i = phi i64 [ %seed.i.i.i38.i, %long_hash.i.i.i35.i ], [ %acc_next.i.i.i172.i, %l_body.i.i.i159.i ]
  %idx.i.i.i40239.i = phi i64 [ 0, %long_hash.i.i.i35.i ], [ %idx_next.i.i.i173.i, %l_body.i.i.i159.i ]
  %lp.i.i.i160.i = getelementptr inbounds nuw i8, ptr %bp.i.i.i.i.i, i64 %idx.i.i.i40239.i
  %lane.i.i.i161.i = load i64, ptr %lp.i.i.i160.i, align 4
  %lm.i.i.i162.i = mul i64 %lane.i.i.i161.i, -4417276706812531889
  %lx.i.i.i163.i = xor i64 %lm.i.i.i162.i, %acc.i.i.i41240.i
  %s1.i2.i.i.i164.i = lshr i64 %lx.i.i.i163.i, 30
  %x1.i3.i.i.i165.i = xor i64 %s1.i2.i.i.i164.i, %lx.i.i.i163.i
  %m1.i4.i.i.i166.i = mul i64 %x1.i3.i.i.i165.i, -4658895280553007687
  %s2.i5.i.i.i167.i = lshr i64 %m1.i4.i.i.i166.i, 27
  %x2.i6.i.i.i168.i = xor i64 %s2.i5.i.i.i167.i, %m1.i4.i.i.i166.i
  %m2.i7.i.i.i169.i = mul i64 %x2.i6.i.i.i168.i, -7723592293110705685
  %s3.i8.i.i.i170.i = lshr i64 %m2.i7.i.i.i169.i, 31
  %x3.i9.i.i.i171.i = xor i64 %s3.i8.i.i.i170.i, %m2.i7.i.i.i169.i
  %acc_next.i.i.i172.i = add i64 %x3.i9.i.i.i171.i, %idx.i.i.i40239.i
  %idx_next.i.i.i173.i = add nuw nsw i64 %idx.i.i.i40239.i, 8
  %ge8.i.i.i43.i = icmp slt i64 %idx_next.i.i.i173.i, %invariant.op270.i
  br i1 %ge8.i.i.i43.i, label %l_body.i.i.i159.i, label %l_tail_cond.i.i.i44.preheader.i

l_tail_body.i.i.i152.i:                           ; preds = %l_tail_cond.i.i.i44.preheader.i, %l_tail_body.i.i.i152.i
  %tacc.i.i.i46243.i = phi i64 [ %tacc_next.i.i.i157.i, %l_tail_body.i.i.i152.i ], [ %acc_next.i.i.i172.i, %l_tail_cond.i.i.i44.preheader.i ]
  %ti.i.i.i45242.i = phi i64 [ %ti_next.i.i.i158.i, %l_tail_body.i.i.i152.i ], [ %idx_next.i.i.i173.i, %l_tail_cond.i.i.i44.preheader.i ]
  %tp.i.i.i153.i = getelementptr inbounds nuw i8, ptr %bp.i.i.i.i.i, i64 %ti.i.i.i45242.i
  %tb.i.i.i154.i = load i8, ptr %tp.i.i.i153.i, align 1
  %tz.i.i.i155.i = zext i8 %tb.i.i.i154.i to i64
  %tx.i.i.i156.i = xor i64 %tacc.i.i.i46243.i, %tz.i.i.i155.i
  %tacc_next.i.i.i157.i = mul i64 %tx.i.i.i156.i, 1099511628211
  %ti_next.i.i.i158.i = add nuw nsw i64 %ti.i.i.i45242.i, 1
  %tmore.i.i.i47.i = icmp samesign ult i64 %ti_next.i.i.i158.i, %len.i.i.i.i534
  br i1 %tmore.i.i.i47.i, label %l_tail_body.i.i.i152.i, label %l_done.i.i.i48.i

l_done.i.i.i48.i:                                 ; preds = %l_tail_body.i.i.i152.i, %l_tail_cond.i.i.i44.preheader.i
  %tacc.i.i.i46.lcssa.i = phi i64 [ %acc_next.i.i.i172.i, %l_tail_cond.i.i.i44.preheader.i ], [ %tacc_next.i.i.i157.i, %l_tail_body.i.i.i152.i ]
  %s1.i.i.i.i49.i = lshr i64 %tacc.i.i.i46.lcssa.i, 30
  %x1.i.i.i.i50.i = xor i64 %s1.i.i.i.i49.i, %tacc.i.i.i46.lcssa.i
  br label %do_probe.i.i.i66.i

do_probe.i.i.i66.i:                               ; preds = %l_done.i.i.i48.i, %sso_mix.i.i.i185.i
  %x1.i.i.i.i50.sink.i = phi i64 [ %x1.i.i.i.i50.i, %l_done.i.i.i48.i ], [ %x1.i11.i.i.i193.i, %sso_mix.i.i.i185.i ]
  %m1.i.i.i.i51.i = mul i64 %x1.i.i.i.i50.sink.i, -4658895280553007687
  %s2.i.i.i.i52.i = lshr i64 %m1.i.i.i.i51.i, 27
  %x2.i.i.i.i53.i = xor i64 %s2.i.i.i.i52.i, %m1.i.i.i.i51.i
  %m2.i.i.i.i54.i = mul i64 %x2.i.i.i.i53.i, -7723592293110705685
  %s3.i.i.i.i55.i = lshr i64 %m2.i.i.i.i54.i, 31
  %x3.i.i.i.i56.i = xor i64 %s3.i.i.i.i55.i, %m2.i.i.i.i54.i
  %h2_64.i.i.i72.i = lshr i64 %m2.i.i.i.i54.i, 57
  %h2.i.i.i73.i = trunc nuw nsw i64 %h2_64.i.i.i72.i to i8
  %h2_ins.i.i.i74.i = insertelement <16 x i8> poison, i8 %h2.i.i.i73.i, i64 0
  %h2_vec.i.i.i75.i = shufflevector <16 x i8> %h2_ins.i.i.i74.i, <16 x i8> poison, <16 x i32> zeroinitializer
  br label %probe.i.i.i76.i

probe.i.i.i76.i:                                  ; preds = %next_grp.i.i.i141.i, %do_probe.i.i.i66.i
  %h.pn.i.i.i77.i = phi i64 [ %x3.i.i.i.i56.i, %do_probe.i.i.i66.i ], [ %padd.i.i.i143.i, %next_grp.i.i.i141.i ]
  %step.i.i.i78.i = phi i64 [ 0, %do_probe.i.i.i66.i ], [ %step_next.i.i.i142.i, %next_grp.i.i.i141.i ]
  %avail.i.i.i79.i = phi i64 [ -1, %do_probe.i.i.i66.i ], [ %avail_cur.i.i.i135.i, %next_grp.i.i.i141.i ]
  %pos.i.i.i80.i = and i64 %h.pn.i.i.i77.i, %mask.i.i.i.i
  %gp.i.i.i81.i = getelementptr inbounds i8, ptr %ctrl.i.i.i.i, i64 %pos.i.i.i80.i
  %grp.i.i.i82.i = load <16 x i8>, ptr %gp.i.i.i81.i, align 1
  %mcmp.i.i.i83.i = icmp eq <16 x i8> %grp.i.i.i82.i, %h2_vec.i.i.i75.i
  %mbits.i.i.i84.i = bitcast <16 x i1> %mcmp.i.i.i83.i to i16
  %has_m.not.i.i.i88245.i = icmp eq i16 %mbits.i.i.i84.i, 0
  br i1 %has_m.not.i.i.i88245.i, label %chk_empty.i.i.i132.i, label %chk_key.i.i.i89.preheader.i

chk_key.i.i.i89.preheader.i:                      ; preds = %probe.i.i.i76.i
  %mmask0.i.i.i85.i = zext i16 %mbits.i.i.i84.i to i32
  br label %chk_key.i.i.i89.i

chk_key.i.i.i89.i:                                ; preds = %mbit_cont.i.i.i106.i, %chk_key.i.i.i89.preheader.i
  %mmask.i.i.i87246.i = phi i32 [ %mmask_next.i.i.i108.i, %mbit_cont.i.i.i106.i ], [ %mmask0.i.i.i85.i, %chk_key.i.i.i89.preheader.i ]
  %tz.i2.i.i90.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i87246.i, i1 true)
  %tz64.i.i.i91.i = zext nneg i32 %tz.i2.i.i90.i to i64
  %s_add.i.i.i92.i = add i64 %pos.i.i.i80.i, %tz64.i.i.i91.i
  %slot.i.i.i93.i = and i64 %s_add.i.i.i92.i, %mask.i.i.i.i
  %ip.i.i.i94.i = getelementptr inbounds i32, ptr %idx_base.i.i.i.i, i64 %slot.i.i.i93.i
  %didx32.i.i.i95.i = load i32, ptr %ip.i.i.i94.i, align 4
  %didx.i.i.i96.i = zext i32 %didx32.i.i.i95.i to i64
  %kp.i.i.i97.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i.i, i64 %didx.i.i.i96.i
  %cand_k.unpack.i.i.i98.i = load i64, ptr %kp.i.i.i97.i, align 8
  %cand_k.elt1.i.i.i99.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i97.i, i64 8
  %cand_k.unpack2.i.i.i100.i = load i64, ptr %cand_k.elt1.i.i.i99.i, align 8
  %w0_eq.i.i.i.i103.i = icmp eq i64 %cand_k.unpack.i.i.i98.i, %t11.fca.0.extract.i
  br i1 %w0_eq.i.i.i.i103.i, label %chk_len.i.i.i.i114.i, label %mbit_cont.i.i.i106.i

chk_len.i.i.i.i114.i:                             ; preds = %chk_key.i.i.i89.i
  br i1 %short.i.i.i.i535, label %cmp_short.i.i.i.i130.i, label %cmp_long.i.i.i.i118.i

cmp_short.i.i.i.i130.i:                           ; preds = %chk_len.i.i.i.i114.i
  %eq_s.i.i.i.i131.i = icmp eq i64 %cand_k.unpack2.i.i.i100.i, %t11.fca.1.extract.i
  br i1 %eq_s.i.i.i.i131.i, label %dupd.ok.7.i, label %mbit_cont.i.i.i106.i

cmp_long.i.i.i.i118.i:                            ; preds = %chk_len.i.i.i.i114.i
  %ap_i.i.i.i.i119.i = and i64 %cand_k.unpack2.i.i.i100.i, -4
  %same_ptr.i.i.i.i121.i = icmp eq i64 %ap_i.i.i.i.i119.i, %bp_i.i.i.i.i.i
  br i1 %same_ptr.i.i.i.i121.i, label %dupd.ok.7.i, label %archx_str_eq.exit.i.i.i104.i

archx_str_eq.exit.i.i.i104.i:                     ; preds = %cmp_long.i.i.i.i118.i
  %ap.i.i.i.i123.i = inttoptr i64 %ap_i.i.i.i.i119.i to ptr
  %ap4.i.i.i.i125.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i123.i, i64 4
  %bcmp.i.i.i.i128.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i.i125.i, ptr nonnull %bp4.i.i.i.i.i, i64 %rem.i.i.i.i.i)
  %eq_m.i.i.i.i129.i = icmp eq i32 %bcmp.i.i.i.i128.i, 0
  br i1 %eq_m.i.i.i.i129.i, label %dupd.ok.7.i, label %mbit_cont.i.i.i106.i

mbit_cont.i.i.i106.i:                             ; preds = %archx_str_eq.exit.i.i.i104.i, %cmp_short.i.i.i.i130.i, %chk_key.i.i.i89.i
  %mm1.i.i.i107.i = add nsw i32 %mmask.i.i.i87246.i, -1
  %mmask_next.i.i.i108.i = and i32 %mm1.i.i.i107.i, %mmask.i.i.i87246.i
  %has_m.not.i.i.i88.i = icmp eq i32 %mmask_next.i.i.i108.i, 0
  br i1 %has_m.not.i.i.i88.i, label %chk_empty.i.i.i132.i, label %chk_key.i.i.i89.i

chk_empty.i.i.i132.i:                             ; preds = %mbit_cont.i.i.i106.i, %probe.i.i.i76.i
  %need_a.i.i.i133.i = icmp slt i64 %avail.i.i.i79.i, 0
  br i1 %need_a.i.i.i133.i, label %find_a.i.i.i144.i, label %after_a.i.i.i134.i

find_a.i.i.i144.i:                                ; preds = %chk_empty.i.i.i132.i
  %acmp.i.i.i145.i = icmp slt <16 x i8> %grp.i.i.i82.i, zeroinitializer
  %abits16.i.i.i146.i = bitcast <16 x i1> %acmp.i.i.i145.i to i16
  %has_a0.not.i.i.i147.i = icmp eq i16 %abits16.i.i.i146.i, 0
  br i1 %has_a0.not.i.i.i147.i, label %after_a.i.i.i134.i, label %set_a.i.i.i148.i

set_a.i.i.i148.i:                                 ; preds = %find_a.i.i.i144.i
  %13 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i146.i, i1 true)
  %atz64.i.i.i149.i = zext nneg i16 %13 to i64
  %as_add.i.i.i150.i = add i64 %pos.i.i.i80.i, %atz64.i.i.i149.i
  %aslot.i.i.i151.i = and i64 %as_add.i.i.i150.i, %mask.i.i.i.i
  br label %after_a.i.i.i134.i

after_a.i.i.i134.i:                               ; preds = %set_a.i.i.i148.i, %find_a.i.i.i144.i, %chk_empty.i.i.i132.i
  %avail_cur.i.i.i135.i = phi i64 [ %avail.i.i.i79.i, %chk_empty.i.i.i132.i ], [ -1, %find_a.i.i.i144.i ], [ %aslot.i.i.i151.i, %set_a.i.i.i148.i ]
  %ecmp.i.i.i136.i = icmp eq <16 x i8> %grp.i.i.i82.i, splat (i8 -128)
  %ebits.i.i.i137.i = bitcast <16 x i1> %ecmp.i.i.i136.i to i16
  %has_e.not.i.i.i138.i = icmp eq i16 %ebits.i.i.i137.i, 0
  br i1 %has_e.not.i.i.i138.i, label %next_grp.i.i.i141.i, label %dupd.miss.8.i

next_grp.i.i.i141.i:                              ; preds = %after_a.i.i.i134.i
  %step_next.i.i.i142.i = add i64 %step.i.i.i78.i, 16
  %padd.i.i.i143.i = add i64 %step_next.i.i.i142.i, %pos.i.i.i80.i
  br label %probe.i.i.i76.i

dupd.miss.8.i:                                    ; preds = %after_a.i.i.i134.i
  call fastcc void @archx_key_fail()
  unreachable

dupd.ok.7.i:                                      ; preds = %archx_str_eq.exit.i.i.i104.i, %cmp_long.i.i.i.i118.i, %cmp_short.i.i.i.i130.i
  %t23.i = load ptr, ptr %t22.i, align 16
  %t24.i = getelementptr inbounds nuw i64, ptr %t23.i, i64 %didx.i.i.i96.i
  %t25.i = load i64, ptr %t24.i, align 8
  %t26.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t25.i, i64 1)
  %t28.i = extractvalue { i64, i1 } %t26.i, 1
  br i1 %t28.i, label %overflow.add.9.i, label %overflow.ok.10.i

overflow.add.9.i:                                 ; preds = %dupd.ok.7.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.10.i:                                 ; preds = %dupd.ok.7.i
  %t27.i = extractvalue { i64, i1 } %t26.i, 0
  store i64 %t27.i, ptr %t24.i, align 8
  br label %foreach.step.2.i

if.else.5.i:                                      ; preds = %after_a.i.i.i.i, %chk_ctrl.i.i.i.i
  %t31.i = call fastcc { i64, i1 } @archx_dict_upsert_str(i64 %rtag.i.i, %ArchxStr %common.ret.op.i.i533)
  %t32.i = extractvalue { i64, i1 } %t31.i, 0
  %t37.i = load ptr, ptr %t22.i, align 16
  %t38.i = getelementptr inbounds i64, ptr %t37.i, i64 %t32.i
  store i64 1, ptr %t38.i, align 8
  br label %foreach.step.2.i

foreach.step.2.i:                                 ; preds = %if.else.5.i, %overflow.ok.10.i
  %t40.i = add nuw nsw i64 %foreach.idx.4.0247.i, 1
  %exitcond.not.i = icmp eq i64 %t40.i, 7
  br i1 %exitcond.not.i, label %dlen.load.12.i, label %foreach.body.1.i

dlen.load.12.i:                                   ; preds = %foreach.step.2.i
  %t46.i = load i64, ptr %res.i.i.i, align 16
  %t50250.i = icmp sgt i64 %t46.i, 0
  br i1 %t50250.i, label %foritems.body.15.lr.ph.i, label %foritems.end.17.i

foritems.body.15.lr.ph.i:                         ; preds = %dlen.load.12.i
  %t55.i = load ptr, ptr %keys_p.i.i.i.i, align 8
  br label %foritems.body.15.i

foritems.body.15.i:                               ; preds = %foritems.step.16.i, %foritems.body.15.lr.ph.i
  %foritems.idx.48.0252.i = phi i64 [ 0, %foritems.body.15.lr.ph.i ], [ %t72.i, %foritems.step.16.i ]
  %var.total.41.0251.i = phi i64 [ 0, %foritems.body.15.lr.ph.i ], [ %var.total.41.1.i, %foritems.step.16.i ]
  %t57.i = getelementptr inbounds nuw %ArchxStr, ptr %t55.i, i64 %foritems.idx.48.0252.i
  %t58.unpack.i = load i64, ptr %t57.i, align 8
  %t62.i = and i64 %t58.unpack.i, 4294967295
  %t63.i = icmp samesign ugt i64 %t62.i, 2
  br i1 %t63.i, label %if.then.18.i, label %foritems.step.16.i

if.then.18.i:                                     ; preds = %foritems.body.15.i
  %t56.i = load ptr, ptr %t22.i, align 16
  %t59.i = getelementptr inbounds nuw i64, ptr %t56.i, i64 %foritems.idx.48.0252.i
  %t60.i = load i64, ptr %t59.i, align 8
  %t65.i = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t60.i, i64 10)
  %t67.i = extractvalue { i64, i1 } %t65.i, 1
  br i1 %t67.i, label %overflow.mul.21.i, label %overflow.ok.22.i

overflow.mul.21.i:                                ; preds = %if.then.18.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.22.i:                                 ; preds = %if.then.18.i
  %t66.i = extractvalue { i64, i1 } %t65.i, 0
  %t68.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.total.41.0251.i, i64 %t66.i)
  %t70.i = extractvalue { i64, i1 } %t68.i, 1
  br i1 %t70.i, label %overflow.add.23.i, label %overflow.ok.24.i

overflow.add.23.i:                                ; preds = %overflow.ok.22.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.24.i:                                 ; preds = %overflow.ok.22.i
  %t69.i = extractvalue { i64, i1 } %t68.i, 0
  br label %foritems.step.16.i

foritems.step.16.i:                               ; preds = %overflow.ok.24.i, %foritems.body.15.i
  %var.total.41.1.i = phi i64 [ %t69.i, %overflow.ok.24.i ], [ %var.total.41.0251.i, %foritems.body.15.i ]
  %t72.i = add nuw nsw i64 %foritems.idx.48.0252.i, 1
  %exitcond260.not.i = icmp eq i64 %t72.i, %t46.i
  br i1 %exitcond260.not.i, label %foritems.end.17.i, label %foritems.body.15.i

foritems.end.17.i:                                ; preds = %foritems.step.16.i, %dlen.load.12.i
  %var.total.41.0.lcssa.i = phi i64 [ 0, %dlen.load.12.i ], [ %var.total.41.1.i, %foritems.step.16.i ]
  %tag.i25.i = and i64 %t11.fca.1.extract.i, 1
  %owned.not.i26.i = icmp eq i64 %tag.i25.i, 0
  %or.cond222.i = select i1 %short.i.i.i.i535, i1 true, i1 %owned.not.i26.i
  br i1 %or.cond222.i, label %body.i.i, label %do_free.i27.i

do_free.i27.i:                                    ; preds = %foritems.end.17.i
  %raw.i28.i = and i64 %t11.fca.1.extract.i, -2
  %ptr.i29.i = inttoptr i64 %raw.i28.i to ptr
  call void @free(ptr %ptr.i29.i)
  %len.i212.pre.i = load i64, ptr %res.i.i.i, align 16
  br label %body.i.i

body.i.i:                                         ; preds = %do_free.i27.i, %foritems.end.17.i
  %len.i212.i = phi i64 [ %len.i212.pre.i, %do_free.i27.i ], [ %t46.i, %foritems.end.17.i ]
  %keys.i.i536 = load ptr, ptr %keys_p.i.i.i.i, align 8
  %more4.i.i = icmp sgt i64 %len.i212.i, 0
  br i1 %more4.i.i, label %d_elem.i.i, label %archx_dict_drop_s_i.exit.i

d_elem.i.i:                                       ; preds = %body.i.i, %archx_str_drop.exit.i.i
  %storemerge5.i.i = phi i64 [ %inext.i.i, %archx_str_drop.exit.i.i ], [ 0, %body.i.i ]
  %t0.i.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i536, i64 %storemerge5.i.i
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
  %raw.i.i.i537 = and i64 %t1.unpack2.i.i, -2
  %ptr.i.i.i = inttoptr i64 %raw.i.i.i537 to ptr
  call void @free(ptr %ptr.i.i.i)
  br label %archx_str_drop.exit.i.i

archx_str_drop.exit.i.i:                          ; preds = %do_free.i.i.i, %d_elem.i.i
  %inext.i.i = add nuw nsw i64 %storemerge5.i.i, 1
  %exitcond.not.i.i = icmp eq i64 %inext.i.i, %len.i212.i
  br i1 %exitcond.not.i.i, label %archx_dict_drop_s_i.exit.i, label %d_elem.i.i

archx_dict_drop_s_i.exit.i:                       ; preds = %archx_str_drop.exit.i.i, %body.i.i
  %t77.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i.i = icmp eq ptr %t77.i, null
  br i1 %empty.i.i, label %alloc.ok.2, label %loop.i.i

loop.i.i:                                         ; preds = %archx_dict_drop_s_i.exit.i, %loop.i.i
  %cur.i.i = phi ptr [ %next.i.i, %loop.i.i ], [ %t77.i, %archx_dict_drop_s_i.exit.i ]
  %next.i.i = load ptr, ptr %cur.i.i, align 8
  call void @free(ptr nonnull %cur.i.i)
  %more.not.i.i = icmp eq ptr %next.i.i, null
  br i1 %more.not.i.i, label %alloc.ok.2, label %loop.i.i

alloc.ok.2:                                       ; preds = %loop.i.i, %archx_dict_drop_s_i.exit.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 13, ptr nonnull @.str.0)
  %t18 = call i32 @putchar(i32 32)
  %t19 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %var.total.41.0.lcssa.i)
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
  %ctrl_p.i.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 32
  %ctrl.i.i = load ptr, ptr %ctrl_p.i.i, align 16
  %c_null.i.i = icmp eq ptr %ctrl.i.i, null
  br i1 %c_null.i.i, label %archx_dict_find_i64.exit, label %do_probe.i.i

do_probe.i.i:                                     ; preds = %archx_dict_new.exit
  %mask_p.i.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 16
  %keys_p.i.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 40
  %mask.i.i = load i64, ptr %mask_p.i.i, align 16
  %keys.i.i = load ptr, ptr %keys_p.i.i, align 8
  %14 = getelementptr i8, ptr %ctrl.i.i, i64 %mask.i.i
  %idx_base.i.i = getelementptr i8, ptr %14, i64 17
  br label %probe.i.i

probe.i.i:                                        ; preds = %next_grp.i.i, %do_probe.i.i
  %h.pn.i.i = phi i64 [ 1346066267577507604, %do_probe.i.i ], [ %padd.i.i, %next_grp.i.i ]
  %step.i.i = phi i64 [ 0, %do_probe.i.i ], [ %step_next.i.i, %next_grp.i.i ]
  %avail.i.i = phi i64 [ -1, %do_probe.i.i ], [ %avail_cur.i.i, %next_grp.i.i ]
  %pos.i.i = and i64 %h.pn.i.i, %mask.i.i
  %gp.i.i = getelementptr inbounds i8, ptr %ctrl.i.i, i64 %pos.i.i
  %grp.i.i = load <16 x i8>, ptr %gp.i.i, align 1
  %mcmp.i.i = icmp eq <16 x i8> %grp.i.i, splat (i8 9)
  %mbits.i.i = bitcast <16 x i1> %mcmp.i.i to i16
  %has_m.not.i.i895 = icmp eq i16 %mbits.i.i, 0
  br i1 %has_m.not.i.i895, label %chk_empty.i.i, label %chk_key.i.i.preheader

chk_key.i.i.preheader:                            ; preds = %probe.i.i
  %mmask0.i.i = zext i16 %mbits.i.i to i32
  br label %chk_key.i.i

chk_key.i.i:                                      ; preds = %chk_key.i.i.preheader, %mbit_cont.i.i
  %mmask.i.i896 = phi i32 [ %mmask_next.i.i, %mbit_cont.i.i ], [ %mmask0.i.i, %chk_key.i.i.preheader ]
  %tz.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i896, i1 true)
  %tz64.i.i = zext nneg i32 %tz.i.i to i64
  %s_add.i.i = add i64 %pos.i.i, %tz64.i.i
  %slot.i.i = and i64 %s_add.i.i, %mask.i.i
  %ip.i.i = getelementptr inbounds i32, ptr %idx_base.i.i, i64 %slot.i.i
  %didx32.i.i = load i32, ptr %ip.i.i, align 4
  %didx.i.i = zext i32 %didx32.i.i to i64
  %kp.i.i = getelementptr inbounds nuw i64, ptr %keys.i.i, i64 %didx.i.i
  %cand_k.i.i = load i64, ptr %kp.i.i, align 8
  %eq.i.i = icmp eq i64 %cand_k.i.i, 7
  br i1 %eq.i.i, label %found.i.i, label %mbit_cont.i.i

mbit_cont.i.i:                                    ; preds = %chk_key.i.i
  %mm1.i.i = add nsw i32 %mmask.i.i896, -1
  %mmask_next.i.i = and i32 %mm1.i.i, %mmask.i.i896
  %has_m.not.i.i = icmp eq i32 %mmask_next.i.i, 0
  br i1 %has_m.not.i.i, label %chk_empty.i.i, label %chk_key.i.i

chk_empty.i.i:                                    ; preds = %mbit_cont.i.i, %probe.i.i
  %need_a.i.i = icmp slt i64 %avail.i.i, 0
  br i1 %need_a.i.i, label %find_a.i.i, label %after_a.i.i

find_a.i.i:                                       ; preds = %chk_empty.i.i
  %acmp.i.i = icmp slt <16 x i8> %grp.i.i, zeroinitializer
  %abits16.i.i = bitcast <16 x i1> %acmp.i.i to i16
  %has_a0.not.i.i = icmp eq i16 %abits16.i.i, 0
  br i1 %has_a0.not.i.i, label %after_a.i.i, label %set_a.i.i

set_a.i.i:                                        ; preds = %find_a.i.i
  %15 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i, i1 true)
  %atz64.i.i = zext nneg i16 %15 to i64
  %as_add.i.i = add i64 %pos.i.i, %atz64.i.i
  %aslot.i.i = and i64 %as_add.i.i, %mask.i.i
  br label %after_a.i.i

after_a.i.i:                                      ; preds = %set_a.i.i, %find_a.i.i, %chk_empty.i.i
  %avail_cur.i.i = phi i64 [ %avail.i.i, %chk_empty.i.i ], [ -1, %find_a.i.i ], [ %aslot.i.i, %set_a.i.i ]
  %ecmp.i.i = icmp eq <16 x i8> %grp.i.i, splat (i8 -128)
  %ebits.i.i = bitcast <16 x i1> %ecmp.i.i to i16
  %has_e.not.i.i = icmp eq i16 %ebits.i.i, 0
  br i1 %has_e.not.i.i, label %next_grp.i.i, label %not_found_avail.i.i

next_grp.i.i:                                     ; preds = %after_a.i.i
  %step_next.i.i = add i64 %step.i.i, 16
  %padd.i.i = add i64 %step_next.i.i, %pos.i.i
  br label %probe.i.i

found.i.i:                                        ; preds = %chk_key.i.i
  %f0.i.i = insertvalue { i64, i64 } poison, i64 %didx.i.i, 0
  %f1.i.i = insertvalue { i64, i64 } %f0.i.i, i64 %slot.i.i, 1
  br label %archx_dict_find_i64.exit

not_found_avail.i.i:                              ; preds = %after_a.i.i
  %nf1.i.i = insertvalue { i64, i64 } { i64 -1, i64 poison }, i64 %avail_cur.i.i, 1
  br label %archx_dict_find_i64.exit

archx_dict_find_i64.exit:                         ; preds = %archx_dict_new.exit, %found.i.i, %not_found_avail.i.i
  %common.ret.op.i.i = phi { i64, i64 } [ %f1.i.i, %found.i.i ], [ %nf1.i.i, %not_found_avail.i.i ], [ { i64 -1, i64 -1 }, %archx_dict_new.exit ]
  %t50 = extractvalue { i64, i64 } %common.ret.op.i.i, 0
  %t52 = icmp sgt i64 %t50, -1
  %t62.pre934 = load i64, ptr %hp.i, align 16
  br i1 %t52, label %srem.hit.9, label %chk_ctrl.i.i.i

srem.hit.9:                                       ; preds = %archx_dict_find_i64.exit
  %t51 = extractvalue { i64, i64 } %common.ret.op.i.i, 1
  %mask_p.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 16
  %keys_p.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 40
  %vals_p.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 48
  %mask.i = load i64, ptr %mask_p.i, align 16
  %keys.i = load ptr, ptr %keys_p.i, align 8
  %vals.i = load ptr, ptr %vals_p.i, align 16
  %meta.i = load i64, ptr %h_meta_gep.i, align 8
  %16 = getelementptr i8, ptr %ctrl.i.i, i64 %mask.i
  %idx_base.i = getelementptr i8, ptr %16, i64 17
  %sp_ip.i = getelementptr inbounds i32, ptr %idx_base.i, i64 %t51
  %d_idx32.i = load i32, ptr %sp_ip.i, align 4
  %d_idx.i = zext i32 %d_idx32.i to i64
  %p.i.i = getelementptr inbounds i8, ptr %ctrl.i.i, i64 %t51
  store i8 -2, ptr %p.i.i, align 1
  %mir.i.i = icmp ult i64 %t51, 16
  br i1 %mir.i.i, label %do_mir.i.i, label %archx_dict_set_ctrl.exit.i

do_mir.i.i:                                       ; preds = %srem.hit.9
  %17 = getelementptr i8, ptr %16, i64 1
  %mp.i.i = getelementptr i8, ptr %17, i64 %t51
  store i8 -2, ptr %mp.i.i, align 1
  br label %archx_dict_set_ctrl.exit.i

archx_dict_set_ctrl.exit.i:                       ; preds = %do_mir.i.i, %srem.hit.9
  %last.i = add i64 %t62.pre934, -1
  store i64 %last.i, ptr %hp.i, align 16
  %need_swap.i = icmp sgt i64 %last.i, %d_idx.i
  br i1 %need_swap.i, label %do_swap.i, label %chk_ctrl.i.i.i

do_swap.i:                                        ; preds = %archx_dict_set_ctrl.exit.i
  %kind.i = and i64 %meta.i, 255
  %ksz_sh.i = lshr i64 %meta.i, 8
  %ksz.i = and i64 %ksz_sh.i, 16777215
  %kd_off.i = mul nuw nsw i64 %ksz.i, %d_idx.i
  %kl_off.i = mul i64 %ksz.i, %last.i
  %kd_p.i = getelementptr inbounds nuw i8, ptr %keys.i, i64 %kd_off.i
  %kl_p.i = getelementptr inbounds i8, ptr %keys.i, i64 %kl_off.i
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
  %h.i = call fastcc i64 @archx_dict_key_hash_at(ptr %keys.i, i64 %d_idx.i, i64 %kind.i)
  %h2_64.i = lshr i64 %h.i, 57
  %h2.i = trunc nuw nsw i64 %h2_64.i to i8
  %h2_ins.i = insertelement <16 x i8> poison, i8 %h2.i, i64 0
  %h2_vec.i = shufflevector <16 x i8> %h2_ins.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %last32.i = trunc i64 %last.i to i32
  br label %fprobe.i

fprobe.i:                                         ; preds = %fnext_grp.i, %fix_sparse.i
  %h.pn.i = phi i64 [ %h.i, %fix_sparse.i ], [ %padd.i, %fnext_grp.i ]
  %step.i = phi i64 [ 0, %fix_sparse.i ], [ %step_next.i, %fnext_grp.i ]
  %pos.i = and i64 %h.pn.i, %mask.i
  %gp.i = getelementptr inbounds i8, ptr %ctrl.i.i, i64 %pos.i
  %grp.i = load <16 x i8>, ptr %gp.i, align 1
  %mcmp.i = icmp eq <16 x i8> %grp.i, %h2_vec.i
  %mbits.i = bitcast <16 x i1> %mcmp.i to i16
  %has_m.not1.i = icmp eq i16 %mbits.i, 0
  br i1 %has_m.not1.i, label %fnext_grp.i, label %fchk.preheader.i

fchk.preheader.i:                                 ; preds = %fprobe.i
  %mmask0.i = zext i16 %mbits.i to i32
  br label %fchk.i

fchk.i:                                           ; preds = %fbit_cont.i, %fchk.preheader.i
  %mmask2.i = phi i32 [ %mmask_next.i, %fbit_cont.i ], [ %mmask0.i, %fchk.preheader.i ]
  %tz.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask2.i, i1 true)
  %tz64.i = zext nneg i32 %tz.i to i64
  %s_add.i = add i64 %pos.i, %tz64.i
  %cand.i = and i64 %s_add.i, %mask.i
  %cip.i = getelementptr inbounds i32, ptr %idx_base.i, i64 %cand.i
  %cv.i = load i32, ptr %cip.i, align 4
  %hit.i = icmp eq i32 %cv.i, %last32.i
  br i1 %hit.i, label %fupdate.i, label %fbit_cont.i

fbit_cont.i:                                      ; preds = %fchk.i
  %mm1.i = add nsw i32 %mmask2.i, -1
  %mmask_next.i = and i32 %mm1.i, %mmask2.i
  %has_m.not.i = icmp eq i32 %mmask_next.i, 0
  br i1 %has_m.not.i, label %fnext_grp.i, label %fchk.i

fnext_grp.i:                                      ; preds = %fbit_cont.i, %fprobe.i
  %step_next.i = add i64 %step.i, 16
  %padd.i = add i64 %step_next.i, %pos.i
  br label %fprobe.i

fupdate.i:                                        ; preds = %fchk.i
  %cip.i.le = getelementptr inbounds i32, ptr %idx_base.i, i64 %cand.i
  store i32 %d_idx32.i, ptr %cip.i.le, align 4
  %t62.pre = load i64, ptr %hp.i, align 16
  br label %chk_ctrl.i.i.i

chk_ctrl.i.i.i:                                   ; preds = %archx_dict_find_i64.exit, %archx_dict_set_ctrl.exit.i, %fupdate.i
  %t62 = phi i64 [ %t62.pre934, %archx_dict_find_i64.exit ], [ %last.i, %archx_dict_set_ctrl.exit.i ], [ %t62.pre, %fupdate.i ]
  %ctrl.i.i.i = load ptr, ptr %ctrl_p.i.i, align 16
  %c_null.i.i.i = icmp eq ptr %ctrl.i.i.i, null
  br i1 %c_null.i.i.i, label %fast_printf.i551, label %do_probe.i.i.i

do_probe.i.i.i:                                   ; preds = %chk_ctrl.i.i.i
  %mask_p.i.i.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 16
  %keys_p.i.i.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 40
  %mask.i.i.i = load i64, ptr %mask_p.i.i.i, align 16
  %keys.i.i.i = load ptr, ptr %keys_p.i.i.i, align 8
  %18 = getelementptr i8, ptr %ctrl.i.i.i, i64 %mask.i.i.i
  %idx_base.i.i.i = getelementptr i8, ptr %18, i64 17
  br label %probe.i.i.i

probe.i.i.i:                                      ; preds = %next_grp.i.i.i, %do_probe.i.i.i
  %h.pn.i.i.i = phi i64 [ -6387817139659442654, %do_probe.i.i.i ], [ %padd.i.i.i, %next_grp.i.i.i ]
  %step.i.i.i = phi i64 [ 0, %do_probe.i.i.i ], [ %step_next.i.i.i, %next_grp.i.i.i ]
  %avail.i.i.i = phi i64 [ -1, %do_probe.i.i.i ], [ %avail_cur.i.i.i, %next_grp.i.i.i ]
  %pos.i.i.i = and i64 %h.pn.i.i.i, %mask.i.i.i
  %gp.i.i.i = getelementptr inbounds i8, ptr %ctrl.i.i.i, i64 %pos.i.i.i
  %grp.i.i.i = load <16 x i8>, ptr %gp.i.i.i, align 1
  %mcmp.i.i.i = icmp eq <16 x i8> %grp.i.i.i, splat (i8 83)
  %mbits.i.i.i = bitcast <16 x i1> %mcmp.i.i.i to i16
  %has_m.not.i.i.i897 = icmp eq i16 %mbits.i.i.i, 0
  br i1 %has_m.not.i.i.i897, label %chk_empty.i.i.i, label %chk_key.i.i.i.preheader

chk_key.i.i.i.preheader:                          ; preds = %probe.i.i.i
  %mmask0.i.i.i = zext i16 %mbits.i.i.i to i32
  br label %chk_key.i.i.i

chk_key.i.i.i:                                    ; preds = %chk_key.i.i.i.preheader, %mbit_cont.i.i.i
  %mmask.i.i.i898 = phi i32 [ %mmask_next.i.i.i, %mbit_cont.i.i.i ], [ %mmask0.i.i.i, %chk_key.i.i.i.preheader ]
  %tz.i.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i898, i1 true)
  %tz64.i.i.i = zext nneg i32 %tz.i.i.i to i64
  %s_add.i.i.i = add i64 %pos.i.i.i, %tz64.i.i.i
  %slot.i.i.i = and i64 %s_add.i.i.i, %mask.i.i.i
  %ip.i.i.i = getelementptr inbounds i32, ptr %idx_base.i.i.i, i64 %slot.i.i.i
  %didx32.i.i.i = load i32, ptr %ip.i.i.i, align 4
  %didx.i.i.i = zext i32 %didx32.i.i.i to i64
  %kp.i.i.i = getelementptr inbounds nuw i64, ptr %keys.i.i.i, i64 %didx.i.i.i
  %cand_k.i.i.i = load i64, ptr %kp.i.i.i, align 8
  %eq.i.i.i = icmp eq i64 %cand_k.i.i.i, 42
  br i1 %eq.i.i.i, label %fast_printf.i551, label %mbit_cont.i.i.i

mbit_cont.i.i.i:                                  ; preds = %chk_key.i.i.i
  %mm1.i.i.i = add nsw i32 %mmask.i.i.i898, -1
  %mmask_next.i.i.i = and i32 %mm1.i.i.i, %mmask.i.i.i898
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
  %19 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i, i1 true)
  %atz64.i.i.i = zext nneg i16 %19 to i64
  %as_add.i.i.i = add i64 %pos.i.i.i, %atz64.i.i.i
  %aslot.i.i.i = and i64 %as_add.i.i.i, %mask.i.i.i
  br label %after_a.i.i.i

after_a.i.i.i:                                    ; preds = %set_a.i.i.i, %find_a.i.i.i, %chk_empty.i.i.i
  %avail_cur.i.i.i = phi i64 [ %avail.i.i.i, %chk_empty.i.i.i ], [ -1, %find_a.i.i.i ], [ %aslot.i.i.i, %set_a.i.i.i ]
  %ecmp.i.i.i = icmp eq <16 x i8> %grp.i.i.i, splat (i8 -128)
  %ebits.i.i.i = bitcast <16 x i1> %ecmp.i.i.i to i16
  %has_e.not.i.i.i = icmp eq i16 %ebits.i.i.i, 0
  br i1 %has_e.not.i.i.i, label %next_grp.i.i.i, label %fast_printf.i551

next_grp.i.i.i:                                   ; preds = %after_a.i.i.i
  %step_next.i.i.i = add i64 %step.i.i.i, 16
  %padd.i.i.i = add i64 %step_next.i.i.i, %pos.i.i.i
  br label %probe.i.i.i

fast_printf.i551:                                 ; preds = %after_a.i.i.i, %chk_key.i.i.i, %chk_ctrl.i.i.i
  %common.ret.op.i.i.i = phi ptr [ @.str.false, %chk_ctrl.i.i.i ], [ @.str.true, %chk_key.i.i.i ], [ @.str.false, %after_a.i.i.i ]
  %np.i552 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 13, ptr nonnull @.str.1)
  %t67 = call i32 @putchar(i32 32)
  %t68 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %t62)
  %t69 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  store i32 544432488, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 3813940, ptr %tmp4.i, align 4
  %nul.i554 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i, i32 0, i64 7)
  %has_nul.not.i555 = icmp eq ptr %nul.i554, null
  br i1 %has_nul.not.i555, label %fast_printf.i564, label %byte_loop.i556.preheader

byte_loop.i556.preheader:                         ; preds = %fast_printf.i551
  %pc.i561 = call i32 @putchar(i32 104)
  %bp.i558.1 = getelementptr inbounds nuw i8, ptr %tmp.i, i64 1
  %ch8.i559.1 = load i8, ptr %bp.i558.1, align 1
  %ch32.i560.1 = zext i8 %ch8.i559.1 to i32
  %pc.i561.1 = call i32 @putchar(i32 %ch32.i560.1)
  %bp.i558.2 = getelementptr inbounds nuw i8, ptr %tmp.i, i64 2
  %ch8.i559.2 = load i8, ptr %bp.i558.2, align 2
  %ch32.i560.2 = zext i8 %ch8.i559.2 to i32
  %pc.i561.2 = call i32 @putchar(i32 %ch32.i560.2)
  %bp.i558.3 = getelementptr inbounds nuw i8, ptr %tmp.i, i64 3
  %ch8.i559.3 = load i8, ptr %bp.i558.3, align 1
  %ch32.i560.3 = zext i8 %ch8.i559.3 to i32
  %pc.i561.3 = call i32 @putchar(i32 %ch32.i560.3)
  %ch8.i559.4 = load i8, ptr %tmp4.i, align 4
  %ch32.i560.4 = zext i8 %ch8.i559.4 to i32
  %pc.i561.4 = call i32 @putchar(i32 %ch32.i560.4)
  %bp.i558.5 = getelementptr inbounds nuw i8, ptr %tmp.i, i64 5
  %ch8.i559.5 = load i8, ptr %bp.i558.5, align 1
  %ch32.i560.5 = zext i8 %ch8.i559.5 to i32
  %pc.i561.5 = call i32 @putchar(i32 %ch32.i560.5)
  %bp.i558.6 = getelementptr inbounds nuw i8, ptr %tmp.i, i64 6
  %ch8.i559.6 = load i8, ptr %bp.i558.6, align 2
  %ch32.i560.6 = zext i8 %ch8.i559.6 to i32
  %pc.i561.6 = call i32 @putchar(i32 %ch32.i560.6)
  br label %archx_str_print.exit566

fast_printf.i564:                                 ; preds = %fast_printf.i551
  %np.i565 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 7, ptr nonnull %tmp.i)
  br label %archx_str_print.exit566

archx_str_print.exit566:                          ; preds = %byte_loop.i556.preheader, %fast_printf.i564
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %t70 = call i32 @putchar(i32 32)
  %t72 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.str.elem, ptr nonnull %common.ret.op.i.i.i)
  %t73 = call i32 @putchar(i32 10)
  %t74 = call noalias align 16 dereferenceable_or_null(48) ptr @malloc(i64 48)
  %t75 = icmp eq ptr %t74, null
  br i1 %t75, label %alloc.oom.16, label %mul.ok.18

alloc.oom.16:                                     ; preds = %archx_str_print.exit566
  call fastcc void @archx_oom_fail()
  unreachable

mul.ok.18:                                        ; preds = %archx_str_print.exit566
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
  %np.i579 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 13, ptr nonnull @.str.2)
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
  %np.i593 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 14, ptr nonnull @.str.3)
  %t158 = call i32 @putchar(i32 32)
  %putchar38 = call i32 @putchar(i32 91)
  %t169 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 60)
  %t166.1 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t169.1 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 40)
  %t166.2 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t169.2 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 20)
  %putchar39 = call i32 @putchar(i32 93)
  %t172 = call i32 @putchar(i32 10)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i595)
  %sso.i.i595.8.sroa_idx1038 = getelementptr inbounds nuw i8, ptr %sso.i.i595, i64 8
  store i64 0, ptr %sso.i.i595.8.sroa_idx1038, align 8
  store i32 6, ptr %sso.i.i595, align 8
  %sso.i.i595.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i595, i64 4
  store i48 52975052402806, ptr %sso.i.i595.4.sroa_idx, align 4
  %sso.i.i595.0.sso.i.i595.0.sso.i.i595.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i600 = load i64, ptr %sso.i.i595, align 8
  %sso.i.i595.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i595, i64 8
  %sso.i.i595.8.sso.i.i595.8.sso.i.i595.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i602 = load i64, ptr %sso.i.i595.8.sroa_idx, align 8
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i595)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i605)
  store i32 1717924464, ptr %tmp.i605, align 4
  %tmp4.i606 = getelementptr inbounds nuw i8, ptr %tmp.i605, i64 4
  store i64 3831913, ptr %tmp4.i606, align 4
  %nul.i607 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i605, i32 0, i64 7)
  %has_nul.not.i608 = icmp eq ptr %nul.i607, null
  br i1 %has_nul.not.i608, label %fast_printf.i617, label %byte_loop.i609.preheader

byte_loop.i609.preheader:                         ; preds = %print.elem.41.2
  %pc.i614 = call i32 @putchar(i32 112)
  %bp.i611.1 = getelementptr inbounds nuw i8, ptr %tmp.i605, i64 1
  %ch8.i612.1 = load i8, ptr %bp.i611.1, align 1
  %ch32.i613.1 = zext i8 %ch8.i612.1 to i32
  %pc.i614.1 = call i32 @putchar(i32 %ch32.i613.1)
  %bp.i611.2 = getelementptr inbounds nuw i8, ptr %tmp.i605, i64 2
  %ch8.i612.2 = load i8, ptr %bp.i611.2, align 2
  %ch32.i613.2 = zext i8 %ch8.i612.2 to i32
  %pc.i614.2 = call i32 @putchar(i32 %ch32.i613.2)
  %bp.i611.3 = getelementptr inbounds nuw i8, ptr %tmp.i605, i64 3
  %ch8.i612.3 = load i8, ptr %bp.i611.3, align 1
  %ch32.i613.3 = zext i8 %ch8.i612.3 to i32
  %pc.i614.3 = call i32 @putchar(i32 %ch32.i613.3)
  %ch8.i612.4 = load i8, ptr %tmp4.i606, align 4
  %ch32.i613.4 = zext i8 %ch8.i612.4 to i32
  %pc.i614.4 = call i32 @putchar(i32 %ch32.i613.4)
  %bp.i611.5 = getelementptr inbounds nuw i8, ptr %tmp.i605, i64 5
  %ch8.i612.5 = load i8, ptr %bp.i611.5, align 1
  %ch32.i613.5 = zext i8 %ch8.i612.5 to i32
  %pc.i614.5 = call i32 @putchar(i32 %ch32.i613.5)
  %bp.i611.6 = getelementptr inbounds nuw i8, ptr %tmp.i605, i64 6
  %ch8.i612.6 = load i8, ptr %bp.i611.6, align 2
  %ch32.i613.6 = zext i8 %ch8.i612.6 to i32
  %pc.i614.6 = call i32 @putchar(i32 %ch32.i613.6)
  br label %chk_nul.i

fast_printf.i617:                                 ; preds = %print.elem.41.2
  %np.i618 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 7, ptr nonnull %tmp.i605)
  br label %chk_nul.i

chk_nul.i:                                        ; preds = %byte_loop.i609.preheader, %fast_printf.i617
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i605)
  %t179 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i620)
  store i32 1751347777, ptr %tmp.i620, align 4
  %tmp4.i637 = getelementptr inbounds nuw i8, ptr %tmp.i620, i64 4
  store i64 120, ptr %tmp4.i637, align 4
  %nul.i625 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i620, i32 0, i64 5)
  %has_nul.not.i626 = icmp eq ptr %nul.i625, null
  br i1 %has_nul.not.i626, label %fast_printf.i635, label %byte_loop.i627.preheader

byte_loop.i627.preheader:                         ; preds = %chk_nul.i
  %pc.i632 = call i32 @putchar(i32 65)
  %bp.i629.1 = getelementptr inbounds nuw i8, ptr %tmp.i620, i64 1
  %ch8.i630.1 = load i8, ptr %bp.i629.1, align 1
  %ch32.i631.1 = zext i8 %ch8.i630.1 to i32
  %pc.i632.1 = call i32 @putchar(i32 %ch32.i631.1)
  %bp.i629.2 = getelementptr inbounds nuw i8, ptr %tmp.i620, i64 2
  %ch8.i630.2 = load i8, ptr %bp.i629.2, align 2
  %ch32.i631.2 = zext i8 %ch8.i630.2 to i32
  %pc.i632.2 = call i32 @putchar(i32 %ch32.i631.2)
  %bp.i629.3 = getelementptr inbounds nuw i8, ptr %tmp.i620, i64 3
  %ch8.i630.3 = load i8, ptr %bp.i629.3, align 1
  %ch32.i631.3 = zext i8 %ch8.i630.3 to i32
  %pc.i632.3 = call i32 @putchar(i32 %ch32.i631.3)
  %ch8.i630.4 = load i8, ptr %tmp4.i637, align 4
  %ch32.i631.4 = zext i8 %ch8.i630.4 to i32
  %pc.i632.4 = call i32 @putchar(i32 %ch32.i631.4)
  br label %archx_str_print.exit638

fast_printf.i635:                                 ; preds = %chk_nul.i
  %np.i636 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 5, ptr nonnull %tmp.i620)
  br label %archx_str_print.exit638

archx_str_print.exit638:                          ; preds = %byte_loop.i627.preheader, %fast_printf.i635
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i620)
  %t180 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i639)
  store i32 1936876918, ptr %tmp.i639, align 4
  %tmp4.i641 = getelementptr inbounds nuw i8, ptr %tmp.i639, i64 4
  store i64 980316009, ptr %tmp4.i641, align 4
  %nul.i644 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i639, i32 0, i64 8)
  %has_nul.not.i645 = icmp eq ptr %nul.i644, null
  br i1 %has_nul.not.i645, label %fast_printf.i654, label %byte_loop.i646.preheader

byte_loop.i646.preheader:                         ; preds = %archx_str_print.exit638
  %pc.i651 = call i32 @putchar(i32 118)
  %bp.i648.1 = getelementptr inbounds nuw i8, ptr %tmp.i639, i64 1
  %ch8.i649.1 = load i8, ptr %bp.i648.1, align 1
  %ch32.i650.1 = zext i8 %ch8.i649.1 to i32
  %pc.i651.1 = call i32 @putchar(i32 %ch32.i650.1)
  %bp.i648.2 = getelementptr inbounds nuw i8, ptr %tmp.i639, i64 2
  %ch8.i649.2 = load i8, ptr %bp.i648.2, align 2
  %ch32.i650.2 = zext i8 %ch8.i649.2 to i32
  %pc.i651.2 = call i32 @putchar(i32 %ch32.i650.2)
  %bp.i648.3 = getelementptr inbounds nuw i8, ptr %tmp.i639, i64 3
  %ch8.i649.3 = load i8, ptr %bp.i648.3, align 1
  %ch32.i650.3 = zext i8 %ch8.i649.3 to i32
  %pc.i651.3 = call i32 @putchar(i32 %ch32.i650.3)
  %ch8.i649.4 = load i8, ptr %tmp4.i641, align 4
  %ch32.i650.4 = zext i8 %ch8.i649.4 to i32
  %pc.i651.4 = call i32 @putchar(i32 %ch32.i650.4)
  %bp.i648.5 = getelementptr inbounds nuw i8, ptr %tmp.i639, i64 5
  %ch8.i649.5 = load i8, ptr %bp.i648.5, align 1
  %ch32.i650.5 = zext i8 %ch8.i649.5 to i32
  %pc.i651.5 = call i32 @putchar(i32 %ch32.i650.5)
  %bp.i648.6 = getelementptr inbounds nuw i8, ptr %tmp.i639, i64 6
  %ch8.i649.6 = load i8, ptr %bp.i648.6, align 2
  %ch32.i650.6 = zext i8 %ch8.i649.6 to i32
  %pc.i651.6 = call i32 @putchar(i32 %ch32.i650.6)
  %bp.i648.7 = getelementptr inbounds nuw i8, ptr %tmp.i639, i64 7
  %ch8.i649.7 = load i8, ptr %bp.i648.7, align 1
  %ch32.i650.7 = zext i8 %ch8.i649.7 to i32
  %pc.i651.7 = call i32 @putchar(i32 %ch32.i650.7)
  br label %archx_str_print.exit656

fast_printf.i654:                                 ; preds = %archx_str_print.exit638
  %np.i655 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 8, ptr nonnull %tmp.i639)
  br label %archx_str_print.exit656

archx_str_print.exit656:                          ; preds = %byte_loop.i646.preheader, %fast_printf.i654
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i639)
  %t181 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i657)
  %len.i660 = and i64 %sso.i.i595.0.sso.i.i595.0.sso.i.i595.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i600, 4294967295
  %short.i661 = icmp samesign ult i64 %len.i660, 13
  br i1 %short.i661, label %emit.i680, label %emit.thread.i662

emit.thread.i662:                                 ; preds = %archx_str_print.exit656
  %raw.i663 = and i64 %sso.i.i595.8.sso.i.i595.8.sso.i.i595.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i602, -4
  %lptr.i664 = inttoptr i64 %raw.i663 to ptr
  br label %chk_nul.i665

emit.i680:                                        ; preds = %archx_str_print.exit656
  %p4.i681 = lshr i64 %sso.i.i595.0.sso.i.i595.0.sso.i.i595.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i600, 32
  %p4_32.i682 = trunc nuw i64 %p4.i681 to i32
  store i32 %p4_32.i682, ptr %tmp.i657, align 4
  %tmp4.i683 = getelementptr inbounds nuw i8, ptr %tmp.i657, i64 4
  store i64 %sso.i.i595.8.sso.i.i595.8.sso.i.i595.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i602, ptr %tmp4.i683, align 4
  %pos.not.i684 = icmp eq i64 %len.i660, 0
  br i1 %pos.not.i684, label %archx_str_print.exit685.thread, label %chk_nul.i665

archx_str_print.exit685.thread:                   ; preds = %emit.i680
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i657)
  %t182870 = call i32 @putchar(i32 10)
  br label %archx_str_drop.exit126

chk_nul.i665:                                     ; preds = %emit.i680, %emit.thread.i662
  %data3.i666 = phi ptr [ %lptr.i664, %emit.thread.i662 ], [ %tmp.i657, %emit.i680 ]
  %nul.i667 = call ptr @memchr(ptr nonnull %data3.i666, i32 0, i64 %len.i660)
  %has_nul.not.i668 = icmp eq ptr %nul.i667, null
  br i1 %has_nul.not.i668, label %fast_printf.i677, label %byte_loop.i669

fast_printf.i677:                                 ; preds = %chk_nul.i665
  %len32.i678 = trunc i64 %sso.i.i595.0.sso.i.i595.0.sso.i.i595.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i600 to i32
  %np.i679 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 %len32.i678, ptr nonnull %data3.i666)
  br label %archx_str_print.exit685

byte_loop.i669:                                   ; preds = %chk_nul.i665, %byte_loop.i669
  %bi.i670 = phi i64 [ %bnext.i675, %byte_loop.i669 ], [ 0, %chk_nul.i665 ]
  %bp.i671 = getelementptr inbounds nuw i8, ptr %data3.i666, i64 %bi.i670
  %ch8.i672 = load i8, ptr %bp.i671, align 1
  %ch32.i673 = zext i8 %ch8.i672 to i32
  %pc.i674 = call i32 @putchar(i32 %ch32.i673)
  %bnext.i675 = add nuw nsw i64 %bi.i670, 1
  %exitcond.not.i676 = icmp eq i64 %bnext.i675, %len.i660
  br i1 %exitcond.not.i676, label %archx_str_print.exit685, label %byte_loop.i669

archx_str_print.exit685:                          ; preds = %byte_loop.i669, %fast_printf.i677
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i657)
  %t182 = call i32 @putchar(i32 10)
  %tag.i = and i64 %sso.i.i595.8.sso.i.i595.8.sso.i.i595.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i602, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %short.i661, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %archx_str_drop.exit126, label %do_free.i

do_free.i:                                        ; preds = %archx_str_print.exit685
  %raw.i = and i64 %sso.i.i595.8.sso.i.i595.8.sso.i.i595.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i602, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  call void @free(ptr %ptr.i)
  br label %archx_str_drop.exit126

archx_str_drop.exit126:                           ; preds = %do_free.i, %archx_str_print.exit685, %archx_str_print.exit685.thread
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
  %hp.i686 = call noalias align 16 dereferenceable_or_null(64) ptr @calloc(i64 1, i64 64)
  %hnull.i687 = icmp eq ptr %hp.i686, null
  br i1 %hnull.i687, label %oom.i691, label %archx_dict_new.exit692

oom.i691:                                         ; preds = %alloc.ok.45
  call fastcc void @archx_oom_fail()
  unreachable

archx_dict_new.exit692:                           ; preds = %alloc.ok.45
  %h_meta_gep.i688 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 56
  store i64 103079219201, ptr %h_meta_gep.i688, align 8
  %hpi.i689 = ptrtoint ptr %hp.i686 to i64
  %htag.i690 = or disjoint i64 %hpi.i689, 1
  %t201 = call noalias align 16 dereferenceable_or_null(24) ptr @malloc(i64 24)
  %t202 = icmp eq ptr %t201, null
  br i1 %t202, label %alloc.oom.48, label %alloc.ok.47

alloc.oom.48:                                     ; preds = %archx_dict_new.exit692
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.47:                                      ; preds = %archx_dict_new.exit692
  store i64 3, ptr %t201, align 16
  %t201.repack46 = getelementptr inbounds nuw i8, ptr %t201, i64 8
  store i64 3, ptr %t201.repack46, align 8
  %t201.repack48 = getelementptr inbounds nuw i8, ptr %t201, i64 16
  store ptr %t192, ptr %t201.repack48, align 16
  %t203 = ptrtoint ptr %t201 to i64
  %t204 = or disjoint i64 %t203, 1
  %t206 = call fastcc { i64, i1 } @archx_dict_upsert_str(i64 %htag.i690, %ArchxStr { i64 7022344801102069764, i64 0 })
  %t207 = extractvalue { i64, i1 } %t206, 0
  %t208 = extractvalue { i64, i1 } %t206, 1
  %t211 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 48
  %t212 = load ptr, ptr %t211, align 16
  %t213 = getelementptr inbounds %ArchxAny, ptr %t212, i64 %t207
  br i1 %t208, label %dlit.dropold.49, label %dlit.store.50

dlit.dropold.49:                                  ; preds = %alloc.ok.47
  %t214.unpack = load i64, ptr %t213, align 8
  %20 = insertvalue %ArchxAny poison, i64 %t214.unpack, 0
  %t214.elt50 = getelementptr inbounds nuw i8, ptr %t213, i64 8
  %t214.unpack51 = load i64, ptr %t214.elt50, align 8
  %21 = insertvalue %ArchxAny %20, i64 %t214.unpack51, 1
  %t214.elt52 = getelementptr inbounds nuw i8, ptr %t213, i64 16
  %t214.unpack53 = load i64, ptr %t214.elt52, align 8
  %t21454 = insertvalue %ArchxAny %21, i64 %t214.unpack53, 2
  call fastcc void @archx_any_drop(%ArchxAny %t21454)
  br label %dlit.store.50

dlit.store.50:                                    ; preds = %dlit.dropold.49, %alloc.ok.47
  store i64 5, ptr %t213, align 8
  %t213.repack55 = getelementptr inbounds nuw i8, ptr %t213, i64 8
  store i64 %t204, ptr %t213.repack55, align 8
  %t213.repack57 = getelementptr inbounds nuw i8, ptr %t213, i64 16
  store i64 0, ptr %t213.repack57, align 8
  %t216 = call fastcc { i64, i1 } @archx_dict_upsert_str(i64 %htag.i690, %ArchxStr { i64 28542638957264899, i64 0 })
  %t217 = extractvalue { i64, i1 } %t216, 0
  %t218 = extractvalue { i64, i1 } %t216, 1
  %t222 = load ptr, ptr %t211, align 16
  %t223 = getelementptr inbounds %ArchxAny, ptr %t222, i64 %t217
  br i1 %t218, label %dlit.dropold.51, label %dlit.store.52

dlit.dropold.51:                                  ; preds = %dlit.store.50
  %t224.unpack = load i64, ptr %t223, align 8
  %22 = insertvalue %ArchxAny poison, i64 %t224.unpack, 0
  %t224.elt59 = getelementptr inbounds nuw i8, ptr %t223, i64 8
  %t224.unpack60 = load i64, ptr %t224.elt59, align 8
  %23 = insertvalue %ArchxAny %22, i64 %t224.unpack60, 1
  %t224.elt61 = getelementptr inbounds nuw i8, ptr %t223, i64 16
  %t224.unpack62 = load i64, ptr %t224.elt61, align 8
  %t22463 = insertvalue %ArchxAny %23, i64 %t224.unpack62, 2
  call fastcc void @archx_any_drop(%ArchxAny %t22463)
  br label %dlit.store.52

dlit.store.52:                                    ; preds = %dlit.dropold.51, %dlit.store.50
  store i64 2, ptr %t223, align 8
  %t223.repack64 = getelementptr inbounds nuw i8, ptr %t223, i64 8
  store i64 18, ptr %t223.repack64, align 8
  %t223.repack65 = getelementptr inbounds nuw i8, ptr %t223, i64 16
  store i64 0, ptr %t223.repack65, align 8
  %ctrl_p.i.i.i131 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 32
  %ctrl.i.i.i132 = load ptr, ptr %ctrl_p.i.i.i131, align 16
  %c_null.i.i.i133 = icmp eq ptr %ctrl.i.i.i132, null
  br i1 %c_null.i.i.i133, label %dm.miss.54, label %do_probe.i.i.i134

do_probe.i.i.i134:                                ; preds = %dlit.store.52
  %mask_p.i.i.i135 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 16
  %keys_p.i.i.i136 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 40
  %mask.i.i.i137 = load i64, ptr %mask_p.i.i.i135, align 16
  %keys.i.i.i138 = load ptr, ptr %keys_p.i.i.i136, align 8
  %24 = getelementptr i8, ptr %ctrl.i.i.i132, i64 %mask.i.i.i137
  %idx_base.i.i.i139 = getelementptr i8, ptr %24, i64 17
  br label %probe.i.i.i140

probe.i.i.i140:                                   ; preds = %next_grp.i.i.i177, %do_probe.i.i.i134
  %h.pn.i.i.i141 = phi i64 [ 7936257679436826279, %do_probe.i.i.i134 ], [ %padd.i.i.i179, %next_grp.i.i.i177 ]
  %step.i.i.i142 = phi i64 [ 0, %do_probe.i.i.i134 ], [ %step_next.i.i.i178, %next_grp.i.i.i177 ]
  %avail.i.i.i143 = phi i64 [ -1, %do_probe.i.i.i134 ], [ %avail_cur.i.i.i171, %next_grp.i.i.i177 ]
  %pos.i.i.i144 = and i64 %h.pn.i.i.i141, %mask.i.i.i137
  %gp.i.i.i145 = getelementptr inbounds i8, ptr %ctrl.i.i.i132, i64 %pos.i.i.i144
  %grp.i.i.i146 = load <16 x i8>, ptr %gp.i.i.i145, align 1
  %mcmp.i.i.i147 = icmp eq <16 x i8> %grp.i.i.i146, splat (i8 55)
  %mbits.i.i.i148 = bitcast <16 x i1> %mcmp.i.i.i147 to i16
  %has_m.not.i.i.i152903 = icmp eq i16 %mbits.i.i.i148, 0
  br i1 %has_m.not.i.i.i152903, label %chk_empty.i.i.i168, label %chk_key.i.i.i153.preheader

chk_key.i.i.i153.preheader:                       ; preds = %probe.i.i.i140
  %mmask0.i.i.i149 = zext i16 %mbits.i.i.i148 to i32
  br label %chk_key.i.i.i153

chk_key.i.i.i153:                                 ; preds = %chk_key.i.i.i153.preheader, %mbit_cont.i.i.i161
  %mmask.i.i.i151904 = phi i32 [ %mmask_next.i.i.i163, %mbit_cont.i.i.i161 ], [ %mmask0.i.i.i149, %chk_key.i.i.i153.preheader ]
  %tz.i2.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i151904, i1 true)
  %tz64.i.i.i154 = zext nneg i32 %tz.i2.i.i to i64
  %s_add.i.i.i155 = add i64 %pos.i.i.i144, %tz64.i.i.i154
  %slot.i.i.i156 = and i64 %s_add.i.i.i155, %mask.i.i.i137
  %ip.i.i.i157 = getelementptr inbounds i32, ptr %idx_base.i.i.i139, i64 %slot.i.i.i156
  %didx32.i.i.i158 = load i32, ptr %ip.i.i.i157, align 4
  %didx.i.i.i159 = zext i32 %didx32.i.i.i158 to i64
  %kp.i.i.i160 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i138, i64 %didx.i.i.i159
  %cand_k.unpack.i.i.i = load i64, ptr %kp.i.i.i160, align 8
  %cand_k.elt1.i.i.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i160, i64 8
  %cand_k.unpack2.i.i.i = load i64, ptr %cand_k.elt1.i.i.i, align 8
  %w0_eq.i.i.i.i = icmp eq i64 %cand_k.unpack.i.i.i, 7022344801102069764
  %eq_s.i.i.i.i = icmp eq i64 %cand_k.unpack2.i.i.i, 0
  %or.cond877 = select i1 %w0_eq.i.i.i.i, i1 %eq_s.i.i.i.i, i1 false
  br i1 %or.cond877, label %dm.ok.53, label %mbit_cont.i.i.i161

mbit_cont.i.i.i161:                               ; preds = %chk_key.i.i.i153
  %mm1.i.i.i162 = add nsw i32 %mmask.i.i.i151904, -1
  %mmask_next.i.i.i163 = and i32 %mm1.i.i.i162, %mmask.i.i.i151904
  %has_m.not.i.i.i152 = icmp eq i32 %mmask_next.i.i.i163, 0
  br i1 %has_m.not.i.i.i152, label %chk_empty.i.i.i168, label %chk_key.i.i.i153

chk_empty.i.i.i168:                               ; preds = %mbit_cont.i.i.i161, %probe.i.i.i140
  %need_a.i.i.i169 = icmp slt i64 %avail.i.i.i143, 0
  br i1 %need_a.i.i.i169, label %find_a.i.i.i180, label %after_a.i.i.i170

find_a.i.i.i180:                                  ; preds = %chk_empty.i.i.i168
  %acmp.i.i.i181 = icmp slt <16 x i8> %grp.i.i.i146, zeroinitializer
  %abits16.i.i.i182 = bitcast <16 x i1> %acmp.i.i.i181 to i16
  %has_a0.not.i.i.i183 = icmp eq i16 %abits16.i.i.i182, 0
  br i1 %has_a0.not.i.i.i183, label %after_a.i.i.i170, label %set_a.i.i.i184

set_a.i.i.i184:                                   ; preds = %find_a.i.i.i180
  %25 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i182, i1 true)
  %atz64.i.i.i185 = zext nneg i16 %25 to i64
  %as_add.i.i.i186 = add i64 %pos.i.i.i144, %atz64.i.i.i185
  %aslot.i.i.i187 = and i64 %as_add.i.i.i186, %mask.i.i.i137
  br label %after_a.i.i.i170

after_a.i.i.i170:                                 ; preds = %set_a.i.i.i184, %find_a.i.i.i180, %chk_empty.i.i.i168
  %avail_cur.i.i.i171 = phi i64 [ %avail.i.i.i143, %chk_empty.i.i.i168 ], [ -1, %find_a.i.i.i180 ], [ %aslot.i.i.i187, %set_a.i.i.i184 ]
  %ecmp.i.i.i172 = icmp eq <16 x i8> %grp.i.i.i146, splat (i8 -128)
  %ebits.i.i.i173 = bitcast <16 x i1> %ecmp.i.i.i172 to i16
  %has_e.not.i.i.i174 = icmp eq i16 %ebits.i.i.i173, 0
  br i1 %has_e.not.i.i.i174, label %next_grp.i.i.i177, label %dm.miss.54

next_grp.i.i.i177:                                ; preds = %after_a.i.i.i170
  %step_next.i.i.i178 = add i64 %step.i.i.i142, 16
  %padd.i.i.i179 = add i64 %step_next.i.i.i178, %pos.i.i.i144
  br label %probe.i.i.i140

dm.miss.54:                                       ; preds = %after_a.i.i.i170, %dlit.store.52
  call fastcc void @archx_key_fail()
  unreachable

dm.ok.53:                                         ; preds = %chk_key.i.i.i153
  %t233 = load ptr, ptr %t211, align 16
  %t234 = getelementptr inbounds nuw %ArchxAny, ptr %t233, i64 %didx.i.i.i159
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
  %ctrl.i.i.i194 = load ptr, ptr %ctrl_p.i.i.i131, align 16
  %c_null.i.i.i195 = icmp eq ptr %ctrl.i.i.i194, null
  br i1 %c_null.i.i.i195, label %dupd.miss.67, label %do_probe.i.i.i196

do_probe.i.i.i196:                                ; preds = %aapp.store.58
  %mask_p.i.i.i197 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 16
  %keys_p.i.i.i198 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 40
  %mask.i.i.i199 = load i64, ptr %mask_p.i.i.i197, align 16
  %keys.i.i.i200 = load ptr, ptr %keys_p.i.i.i198, align 8
  %26 = getelementptr i8, ptr %ctrl.i.i.i194, i64 %mask.i.i.i199
  %idx_base.i.i.i201 = getelementptr i8, ptr %26, i64 17
  br label %probe.i.i.i202

probe.i.i.i202:                                   ; preds = %next_grp.i.i.i262, %do_probe.i.i.i196
  %h.pn.i.i.i203 = phi i64 [ -8592923751486469375, %do_probe.i.i.i196 ], [ %padd.i.i.i264, %next_grp.i.i.i262 ]
  %step.i.i.i204 = phi i64 [ 0, %do_probe.i.i.i196 ], [ %step_next.i.i.i263, %next_grp.i.i.i262 ]
  %avail.i.i.i205 = phi i64 [ -1, %do_probe.i.i.i196 ], [ %avail_cur.i.i.i256, %next_grp.i.i.i262 ]
  %pos.i.i.i206 = and i64 %h.pn.i.i.i203, %mask.i.i.i199
  %gp.i.i.i207 = getelementptr inbounds i8, ptr %ctrl.i.i.i194, i64 %pos.i.i.i206
  %grp.i.i.i208 = load <16 x i8>, ptr %gp.i.i.i207, align 1
  %mcmp.i.i.i209 = icmp eq <16 x i8> %grp.i.i.i208, splat (i8 68)
  %mbits.i.i.i210 = bitcast <16 x i1> %mcmp.i.i.i209 to i16
  %has_m.not.i.i.i214905 = icmp eq i16 %mbits.i.i.i210, 0
  br i1 %has_m.not.i.i.i214905, label %chk_empty.i.i.i253, label %chk_key.i.i.i215.preheader

chk_key.i.i.i215.preheader:                       ; preds = %probe.i.i.i202
  %mmask0.i.i.i211 = zext i16 %mbits.i.i.i210 to i32
  br label %chk_key.i.i.i215

chk_key.i.i.i215:                                 ; preds = %chk_key.i.i.i215.preheader, %mbit_cont.i.i.i231
  %mmask.i.i.i213906 = phi i32 [ %mmask_next.i.i.i233, %mbit_cont.i.i.i231 ], [ %mmask0.i.i.i211, %chk_key.i.i.i215.preheader ]
  %tz.i2.i.i216 = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i213906, i1 true)
  %tz64.i.i.i217 = zext nneg i32 %tz.i2.i.i216 to i64
  %s_add.i.i.i218 = add i64 %pos.i.i.i206, %tz64.i.i.i217
  %slot.i.i.i219 = and i64 %s_add.i.i.i218, %mask.i.i.i199
  %ip.i.i.i220 = getelementptr inbounds i32, ptr %idx_base.i.i.i201, i64 %slot.i.i.i219
  %didx32.i.i.i221 = load i32, ptr %ip.i.i.i220, align 4
  %didx.i.i.i222 = zext i32 %didx32.i.i.i221 to i64
  %kp.i.i.i223 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i200, i64 %didx.i.i.i222
  %cand_k.unpack.i.i.i224 = load i64, ptr %kp.i.i.i223, align 8
  %cand_k.elt1.i.i.i225 = getelementptr inbounds nuw i8, ptr %kp.i.i.i223, i64 8
  %cand_k.unpack2.i.i.i226 = load i64, ptr %cand_k.elt1.i.i.i225, align 8
  %w0_eq.i.i.i.i228 = icmp eq i64 %cand_k.unpack.i.i.i224, 28542638957264899
  %eq_s.i.i.i.i252 = icmp eq i64 %cand_k.unpack2.i.i.i226, 0
  %or.cond878 = select i1 %w0_eq.i.i.i.i228, i1 %eq_s.i.i.i.i252, i1 false
  br i1 %or.cond878, label %dupd.ok.66, label %mbit_cont.i.i.i231

mbit_cont.i.i.i231:                               ; preds = %chk_key.i.i.i215
  %mm1.i.i.i232 = add nsw i32 %mmask.i.i.i213906, -1
  %mmask_next.i.i.i233 = and i32 %mm1.i.i.i232, %mmask.i.i.i213906
  %has_m.not.i.i.i214 = icmp eq i32 %mmask_next.i.i.i233, 0
  br i1 %has_m.not.i.i.i214, label %chk_empty.i.i.i253, label %chk_key.i.i.i215

chk_empty.i.i.i253:                               ; preds = %mbit_cont.i.i.i231, %probe.i.i.i202
  %need_a.i.i.i254 = icmp slt i64 %avail.i.i.i205, 0
  br i1 %need_a.i.i.i254, label %find_a.i.i.i265, label %after_a.i.i.i255

find_a.i.i.i265:                                  ; preds = %chk_empty.i.i.i253
  %acmp.i.i.i266 = icmp slt <16 x i8> %grp.i.i.i208, zeroinitializer
  %abits16.i.i.i267 = bitcast <16 x i1> %acmp.i.i.i266 to i16
  %has_a0.not.i.i.i268 = icmp eq i16 %abits16.i.i.i267, 0
  br i1 %has_a0.not.i.i.i268, label %after_a.i.i.i255, label %set_a.i.i.i269

set_a.i.i.i269:                                   ; preds = %find_a.i.i.i265
  %27 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i267, i1 true)
  %atz64.i.i.i270 = zext nneg i16 %27 to i64
  %as_add.i.i.i271 = add i64 %pos.i.i.i206, %atz64.i.i.i270
  %aslot.i.i.i272 = and i64 %as_add.i.i.i271, %mask.i.i.i199
  br label %after_a.i.i.i255

after_a.i.i.i255:                                 ; preds = %set_a.i.i.i269, %find_a.i.i.i265, %chk_empty.i.i.i253
  %avail_cur.i.i.i256 = phi i64 [ %avail.i.i.i205, %chk_empty.i.i.i253 ], [ -1, %find_a.i.i.i265 ], [ %aslot.i.i.i272, %set_a.i.i.i269 ]
  %ecmp.i.i.i257 = icmp eq <16 x i8> %grp.i.i.i208, splat (i8 -128)
  %ebits.i.i.i258 = bitcast <16 x i1> %ecmp.i.i.i257 to i16
  %has_e.not.i.i.i259 = icmp eq i16 %ebits.i.i.i258, 0
  br i1 %has_e.not.i.i.i259, label %next_grp.i.i.i262, label %dupd.miss.67

next_grp.i.i.i262:                                ; preds = %after_a.i.i.i255
  %step_next.i.i.i263 = add i64 %step.i.i.i204, 16
  %padd.i.i.i264 = add i64 %step_next.i.i.i263, %pos.i.i.i206
  br label %probe.i.i.i202

dupd.miss.67:                                     ; preds = %after_a.i.i.i255, %aapp.store.58
  call fastcc void @archx_key_fail()
  unreachable

dupd.ok.66:                                       ; preds = %chk_key.i.i.i215
  %t276 = load ptr, ptr %t211, align 16
  %t277 = getelementptr inbounds nuw %ArchxAny, ptr %t276, i64 %didx.i.i.i222
  %t278.unpack = load i64, ptr %t277, align 8
  %28 = add i64 %t278.unpack, -1
  %na.i = icmp ult i64 %28, 3
  br i1 %na.i, label %num_op.i, label %bad_op.i

num_op.i:                                         ; preds = %dupd.ok.66
  %29 = insertvalue %ArchxAny poison, i64 %t278.unpack, 0
  %t278.elt82 = getelementptr inbounds nuw i8, ptr %t277, i64 8
  %t278.unpack83 = load i64, ptr %t278.elt82, align 8
  %30 = insertvalue %ArchxAny %29, i64 %t278.unpack83, 1
  %t278.elt84 = getelementptr inbounds nuw i8, ptr %t277, i64 16
  %t278.unpack85 = load i64, ptr %t278.elt84, align 8
  %t27886 = insertvalue %ArchxAny %30, i64 %t278.unpack85, 2
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
  %ctrl.i.i.i280 = load ptr, ptr %ctrl_p.i.i.i131, align 16
  %c_null.i.i.i281 = icmp eq ptr %ctrl.i.i.i280, null
  br i1 %c_null.i.i.i281, label %dget.miss.69, label %do_probe.i.i.i282

bad_op.i:                                         ; preds = %dupd.ok.66
  call fastcc void @archx_type_fail(ptr nonnull @.any.badop)
  unreachable

do_probe.i.i.i282:                                ; preds = %num_op.i
  %mask_p.i.i.i283 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 16
  %keys_p.i.i.i284 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 40
  %mask.i.i.i285 = load i64, ptr %mask_p.i.i.i283, align 16
  %keys.i.i.i286 = load ptr, ptr %keys_p.i.i.i284, align 8
  %31 = getelementptr i8, ptr %ctrl.i.i.i280, i64 %mask.i.i.i285
  %idx_base.i.i.i287 = getelementptr i8, ptr %31, i64 17
  br label %probe.i.i.i288

probe.i.i.i288:                                   ; preds = %next_grp.i.i.i348, %do_probe.i.i.i282
  %h.pn.i.i.i289 = phi i64 [ 7936257679436826279, %do_probe.i.i.i282 ], [ %padd.i.i.i350, %next_grp.i.i.i348 ]
  %step.i.i.i290 = phi i64 [ 0, %do_probe.i.i.i282 ], [ %step_next.i.i.i349, %next_grp.i.i.i348 ]
  %avail.i.i.i291 = phi i64 [ -1, %do_probe.i.i.i282 ], [ %avail_cur.i.i.i342, %next_grp.i.i.i348 ]
  %pos.i.i.i292 = and i64 %h.pn.i.i.i289, %mask.i.i.i285
  %gp.i.i.i293 = getelementptr inbounds i8, ptr %ctrl.i.i.i280, i64 %pos.i.i.i292
  %grp.i.i.i294 = load <16 x i8>, ptr %gp.i.i.i293, align 1
  %mcmp.i.i.i295 = icmp eq <16 x i8> %grp.i.i.i294, splat (i8 55)
  %mbits.i.i.i296 = bitcast <16 x i1> %mcmp.i.i.i295 to i16
  %has_m.not.i.i.i300907 = icmp eq i16 %mbits.i.i.i296, 0
  br i1 %has_m.not.i.i.i300907, label %chk_empty.i.i.i339, label %chk_key.i.i.i301.preheader

chk_key.i.i.i301.preheader:                       ; preds = %probe.i.i.i288
  %mmask0.i.i.i297 = zext i16 %mbits.i.i.i296 to i32
  br label %chk_key.i.i.i301

chk_key.i.i.i301:                                 ; preds = %chk_key.i.i.i301.preheader, %mbit_cont.i.i.i317
  %mmask.i.i.i299908 = phi i32 [ %mmask_next.i.i.i319, %mbit_cont.i.i.i317 ], [ %mmask0.i.i.i297, %chk_key.i.i.i301.preheader ]
  %tz.i2.i.i302 = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i299908, i1 true)
  %tz64.i.i.i303 = zext nneg i32 %tz.i2.i.i302 to i64
  %s_add.i.i.i304 = add i64 %pos.i.i.i292, %tz64.i.i.i303
  %slot.i.i.i305 = and i64 %s_add.i.i.i304, %mask.i.i.i285
  %ip.i.i.i306 = getelementptr inbounds i32, ptr %idx_base.i.i.i287, i64 %slot.i.i.i305
  %didx32.i.i.i307 = load i32, ptr %ip.i.i.i306, align 4
  %didx.i.i.i308 = zext i32 %didx32.i.i.i307 to i64
  %kp.i.i.i309 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i286, i64 %didx.i.i.i308
  %cand_k.unpack.i.i.i310 = load i64, ptr %kp.i.i.i309, align 8
  %cand_k.elt1.i.i.i311 = getelementptr inbounds nuw i8, ptr %kp.i.i.i309, i64 8
  %cand_k.unpack2.i.i.i312 = load i64, ptr %cand_k.elt1.i.i.i311, align 8
  %w0_eq.i.i.i.i314 = icmp eq i64 %cand_k.unpack.i.i.i310, 7022344801102069764
  %eq_s.i.i.i.i338 = icmp eq i64 %cand_k.unpack2.i.i.i312, 0
  %or.cond879 = select i1 %w0_eq.i.i.i.i314, i1 %eq_s.i.i.i.i338, i1 false
  br i1 %or.cond879, label %dget.ok.68, label %mbit_cont.i.i.i317

mbit_cont.i.i.i317:                               ; preds = %chk_key.i.i.i301
  %mm1.i.i.i318 = add nsw i32 %mmask.i.i.i299908, -1
  %mmask_next.i.i.i319 = and i32 %mm1.i.i.i318, %mmask.i.i.i299908
  %has_m.not.i.i.i300 = icmp eq i32 %mmask_next.i.i.i319, 0
  br i1 %has_m.not.i.i.i300, label %chk_empty.i.i.i339, label %chk_key.i.i.i301

chk_empty.i.i.i339:                               ; preds = %mbit_cont.i.i.i317, %probe.i.i.i288
  %need_a.i.i.i340 = icmp slt i64 %avail.i.i.i291, 0
  br i1 %need_a.i.i.i340, label %find_a.i.i.i351, label %after_a.i.i.i341

find_a.i.i.i351:                                  ; preds = %chk_empty.i.i.i339
  %acmp.i.i.i352 = icmp slt <16 x i8> %grp.i.i.i294, zeroinitializer
  %abits16.i.i.i353 = bitcast <16 x i1> %acmp.i.i.i352 to i16
  %has_a0.not.i.i.i354 = icmp eq i16 %abits16.i.i.i353, 0
  br i1 %has_a0.not.i.i.i354, label %after_a.i.i.i341, label %set_a.i.i.i355

set_a.i.i.i355:                                   ; preds = %find_a.i.i.i351
  %32 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i353, i1 true)
  %atz64.i.i.i356 = zext nneg i16 %32 to i64
  %as_add.i.i.i357 = add i64 %pos.i.i.i292, %atz64.i.i.i356
  %aslot.i.i.i358 = and i64 %as_add.i.i.i357, %mask.i.i.i285
  br label %after_a.i.i.i341

after_a.i.i.i341:                                 ; preds = %set_a.i.i.i355, %find_a.i.i.i351, %chk_empty.i.i.i339
  %avail_cur.i.i.i342 = phi i64 [ %avail.i.i.i291, %chk_empty.i.i.i339 ], [ -1, %find_a.i.i.i351 ], [ %aslot.i.i.i358, %set_a.i.i.i355 ]
  %ecmp.i.i.i343 = icmp eq <16 x i8> %grp.i.i.i294, splat (i8 -128)
  %ebits.i.i.i344 = bitcast <16 x i1> %ecmp.i.i.i343 to i16
  %has_e.not.i.i.i345 = icmp eq i16 %ebits.i.i.i344, 0
  br i1 %has_e.not.i.i.i345, label %next_grp.i.i.i348, label %dget.miss.69

next_grp.i.i.i348:                                ; preds = %after_a.i.i.i341
  %step_next.i.i.i349 = add i64 %step.i.i.i290, 16
  %padd.i.i.i350 = add i64 %step_next.i.i.i349, %pos.i.i.i292
  br label %probe.i.i.i288

dget.miss.69:                                     ; preds = %after_a.i.i.i341, %num_op.i
  call fastcc void @archx_key_fail()
  unreachable

dget.ok.68:                                       ; preds = %chk_key.i.i.i301
  %t287 = load ptr, ptr %t211, align 16
  %t288 = getelementptr inbounds nuw %ArchxAny, ptr %t287, i64 %didx.i.i.i308
  %t289.unpack = load i64, ptr %t288, align 8
  %33 = insertvalue %ArchxAny poison, i64 %t289.unpack, 0
  %t289.elt91 = getelementptr inbounds nuw i8, ptr %t288, i64 8
  %t289.unpack92 = load i64, ptr %t289.elt91, align 8
  %34 = insertvalue %ArchxAny %33, i64 %t289.unpack92, 1
  %t289.elt93 = getelementptr inbounds nuw i8, ptr %t288, i64 16
  %t289.unpack94 = load i64, ptr %t289.elt93, align 8
  %t28995 = insertvalue %ArchxAny %34, i64 %t289.unpack94, 2
  %t290 = call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t28995)
  %newret976 = extractvalue { i64, i64, i64 } %t290, 0
  %oldret977 = insertvalue %ArchxAny poison, i64 %newret976, 0
  %newret978 = extractvalue { i64, i64, i64 } %t290, 1
  %oldret979 = insertvalue %ArchxAny %oldret977, i64 %newret978, 1
  %newret980 = extractvalue { i64, i64, i64 } %t290, 2
  %oldret981 = insertvalue %ArchxAny %oldret979, i64 %newret980, 2
  %t292 = call fastcc { i64, i64, i64 } @archx_any_get_idx(%ArchxAny %oldret981, %ArchxAny { i64 2, i64 0, i64 0 })
  %newret994 = extractvalue { i64, i64, i64 } %t292, 0
  %oldret995 = insertvalue %ArchxAny poison, i64 %newret994, 0
  %newret996 = extractvalue { i64, i64, i64 } %t292, 1
  %oldret997 = insertvalue %ArchxAny %oldret995, i64 %newret996, 1
  %newret998 = extractvalue { i64, i64, i64 } %t292, 2
  %oldret999 = insertvalue %ArchxAny %oldret997, i64 %newret998, 2
  %ctrl.i.i.i366 = load ptr, ptr %ctrl_p.i.i.i131, align 16
  %c_null.i.i.i367 = icmp eq ptr %ctrl.i.i.i366, null
  br i1 %c_null.i.i.i367, label %dget.miss.71, label %do_probe.i.i.i368

do_probe.i.i.i368:                                ; preds = %dget.ok.68
  %mask_p.i.i.i369 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 16
  %keys_p.i.i.i370 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 40
  %mask.i.i.i371 = load i64, ptr %mask_p.i.i.i369, align 16
  %keys.i.i.i372 = load ptr, ptr %keys_p.i.i.i370, align 8
  %35 = getelementptr i8, ptr %ctrl.i.i.i366, i64 %mask.i.i.i371
  %idx_base.i.i.i373 = getelementptr i8, ptr %35, i64 17
  br label %probe.i.i.i374

probe.i.i.i374:                                   ; preds = %next_grp.i.i.i434, %do_probe.i.i.i368
  %h.pn.i.i.i375 = phi i64 [ 7936257679436826279, %do_probe.i.i.i368 ], [ %padd.i.i.i436, %next_grp.i.i.i434 ]
  %step.i.i.i376 = phi i64 [ 0, %do_probe.i.i.i368 ], [ %step_next.i.i.i435, %next_grp.i.i.i434 ]
  %avail.i.i.i377 = phi i64 [ -1, %do_probe.i.i.i368 ], [ %avail_cur.i.i.i428, %next_grp.i.i.i434 ]
  %pos.i.i.i378 = and i64 %h.pn.i.i.i375, %mask.i.i.i371
  %gp.i.i.i379 = getelementptr inbounds i8, ptr %ctrl.i.i.i366, i64 %pos.i.i.i378
  %grp.i.i.i380 = load <16 x i8>, ptr %gp.i.i.i379, align 1
  %mcmp.i.i.i381 = icmp eq <16 x i8> %grp.i.i.i380, splat (i8 55)
  %mbits.i.i.i382 = bitcast <16 x i1> %mcmp.i.i.i381 to i16
  %has_m.not.i.i.i386909 = icmp eq i16 %mbits.i.i.i382, 0
  br i1 %has_m.not.i.i.i386909, label %chk_empty.i.i.i425, label %chk_key.i.i.i387.preheader

chk_key.i.i.i387.preheader:                       ; preds = %probe.i.i.i374
  %mmask0.i.i.i383 = zext i16 %mbits.i.i.i382 to i32
  br label %chk_key.i.i.i387

chk_key.i.i.i387:                                 ; preds = %chk_key.i.i.i387.preheader, %mbit_cont.i.i.i403
  %mmask.i.i.i385910 = phi i32 [ %mmask_next.i.i.i405, %mbit_cont.i.i.i403 ], [ %mmask0.i.i.i383, %chk_key.i.i.i387.preheader ]
  %tz.i2.i.i388 = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i385910, i1 true)
  %tz64.i.i.i389 = zext nneg i32 %tz.i2.i.i388 to i64
  %s_add.i.i.i390 = add i64 %pos.i.i.i378, %tz64.i.i.i389
  %slot.i.i.i391 = and i64 %s_add.i.i.i390, %mask.i.i.i371
  %ip.i.i.i392 = getelementptr inbounds i32, ptr %idx_base.i.i.i373, i64 %slot.i.i.i391
  %didx32.i.i.i393 = load i32, ptr %ip.i.i.i392, align 4
  %didx.i.i.i394 = zext i32 %didx32.i.i.i393 to i64
  %kp.i.i.i395 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i372, i64 %didx.i.i.i394
  %cand_k.unpack.i.i.i396 = load i64, ptr %kp.i.i.i395, align 8
  %cand_k.elt1.i.i.i397 = getelementptr inbounds nuw i8, ptr %kp.i.i.i395, i64 8
  %cand_k.unpack2.i.i.i398 = load i64, ptr %cand_k.elt1.i.i.i397, align 8
  %w0_eq.i.i.i.i400 = icmp eq i64 %cand_k.unpack.i.i.i396, 7022344801102069764
  %eq_s.i.i.i.i424 = icmp eq i64 %cand_k.unpack2.i.i.i398, 0
  %or.cond880 = select i1 %w0_eq.i.i.i.i400, i1 %eq_s.i.i.i.i424, i1 false
  br i1 %or.cond880, label %dget.ok.70, label %mbit_cont.i.i.i403

mbit_cont.i.i.i403:                               ; preds = %chk_key.i.i.i387
  %mm1.i.i.i404 = add nsw i32 %mmask.i.i.i385910, -1
  %mmask_next.i.i.i405 = and i32 %mm1.i.i.i404, %mmask.i.i.i385910
  %has_m.not.i.i.i386 = icmp eq i32 %mmask_next.i.i.i405, 0
  br i1 %has_m.not.i.i.i386, label %chk_empty.i.i.i425, label %chk_key.i.i.i387

chk_empty.i.i.i425:                               ; preds = %mbit_cont.i.i.i403, %probe.i.i.i374
  %need_a.i.i.i426 = icmp slt i64 %avail.i.i.i377, 0
  br i1 %need_a.i.i.i426, label %find_a.i.i.i437, label %after_a.i.i.i427

find_a.i.i.i437:                                  ; preds = %chk_empty.i.i.i425
  %acmp.i.i.i438 = icmp slt <16 x i8> %grp.i.i.i380, zeroinitializer
  %abits16.i.i.i439 = bitcast <16 x i1> %acmp.i.i.i438 to i16
  %has_a0.not.i.i.i440 = icmp eq i16 %abits16.i.i.i439, 0
  br i1 %has_a0.not.i.i.i440, label %after_a.i.i.i427, label %set_a.i.i.i441

set_a.i.i.i441:                                   ; preds = %find_a.i.i.i437
  %36 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i439, i1 true)
  %atz64.i.i.i442 = zext nneg i16 %36 to i64
  %as_add.i.i.i443 = add i64 %pos.i.i.i378, %atz64.i.i.i442
  %aslot.i.i.i444 = and i64 %as_add.i.i.i443, %mask.i.i.i371
  br label %after_a.i.i.i427

after_a.i.i.i427:                                 ; preds = %set_a.i.i.i441, %find_a.i.i.i437, %chk_empty.i.i.i425
  %avail_cur.i.i.i428 = phi i64 [ %avail.i.i.i377, %chk_empty.i.i.i425 ], [ -1, %find_a.i.i.i437 ], [ %aslot.i.i.i444, %set_a.i.i.i441 ]
  %ecmp.i.i.i429 = icmp eq <16 x i8> %grp.i.i.i380, splat (i8 -128)
  %ebits.i.i.i430 = bitcast <16 x i1> %ecmp.i.i.i429 to i16
  %has_e.not.i.i.i431 = icmp eq i16 %ebits.i.i.i430, 0
  br i1 %has_e.not.i.i.i431, label %next_grp.i.i.i434, label %dget.miss.71

next_grp.i.i.i434:                                ; preds = %after_a.i.i.i427
  %step_next.i.i.i435 = add i64 %step.i.i.i376, 16
  %padd.i.i.i436 = add i64 %step_next.i.i.i435, %pos.i.i.i378
  br label %probe.i.i.i374

dget.miss.71:                                     ; preds = %after_a.i.i.i427, %dget.ok.68
  call fastcc void @archx_key_fail()
  unreachable

dget.ok.70:                                       ; preds = %chk_key.i.i.i387
  %t299 = load ptr, ptr %t211, align 16
  %t300 = getelementptr inbounds nuw %ArchxAny, ptr %t299, i64 %didx.i.i.i394
  %t301.unpack = load i64, ptr %t300, align 8
  %37 = insertvalue %ArchxAny poison, i64 %t301.unpack, 0
  %t301.elt96 = getelementptr inbounds nuw i8, ptr %t300, i64 8
  %t301.unpack97 = load i64, ptr %t301.elt96, align 8
  %38 = insertvalue %ArchxAny %37, i64 %t301.unpack97, 1
  %t301.elt98 = getelementptr inbounds nuw i8, ptr %t300, i64 16
  %t301.unpack99 = load i64, ptr %t301.elt98, align 8
  %t301100 = insertvalue %ArchxAny %38, i64 %t301.unpack99, 2
  %t302 = call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t301100)
  %newret982 = extractvalue { i64, i64, i64 } %t302, 0
  %oldret983 = insertvalue %ArchxAny poison, i64 %newret982, 0
  %newret984 = extractvalue { i64, i64, i64 } %t302, 1
  %oldret985 = insertvalue %ArchxAny %oldret983, i64 %newret984, 1
  %newret986 = extractvalue { i64, i64, i64 } %t302, 2
  %oldret987 = insertvalue %ArchxAny %oldret985, i64 %newret986, 2
  %is4.i = icmp eq i64 %newret982, 4
  br i1 %is4.i, label %l_str.i, label %chk_cont.i

l_str.i:                                          ; preds = %dget.ok.70
  %slen.i = and i64 %newret984, 4294967295
  br label %chk_ctrl.i.i.i449

chk_cont.i:                                       ; preds = %dget.ok.70
  %39 = add i64 %newret982, -5
  %ok.i = icmp ult i64 %39, 3
  br i1 %ok.i, label %l_cont.i, label %bad.i

l_cont.i:                                         ; preds = %chk_cont.i
  %raw.i695 = and i64 %newret984, -4
  %z.i = icmp eq i64 %raw.i695, 0
  br i1 %z.i, label %chk_ctrl.i.i.i449, label %load_l.i

load_l.i:                                         ; preds = %l_cont.i
  %p.i = inttoptr i64 %raw.i695 to ptr
  %l.i = load i64, ptr %p.i, align 8
  br label %chk_ctrl.i.i.i449

bad.i:                                            ; preds = %chk_cont.i
  call fastcc void @archx_type_fail(ptr nonnull @.any.badlen)
  unreachable

chk_ctrl.i.i.i449:                                ; preds = %load_l.i, %l_cont.i, %l_str.i
  %common.ret.op.i696 = phi i64 [ %slen.i, %l_str.i ], [ %l.i, %load_l.i ], [ 0, %l_cont.i ]
  %ctrl.i.i.i452 = load ptr, ptr %ctrl_p.i.i.i131, align 16
  %c_null.i.i.i453 = icmp eq ptr %ctrl.i.i.i452, null
  br i1 %c_null.i.i.i453, label %dget.miss.73, label %do_probe.i.i.i454

do_probe.i.i.i454:                                ; preds = %chk_ctrl.i.i.i449
  %mask_p.i.i.i455 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 16
  %keys_p.i.i.i456 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 40
  %mask.i.i.i457 = load i64, ptr %mask_p.i.i.i455, align 16
  %keys.i.i.i458 = load ptr, ptr %keys_p.i.i.i456, align 8
  %40 = getelementptr i8, ptr %ctrl.i.i.i452, i64 %mask.i.i.i457
  %idx_base.i.i.i459 = getelementptr i8, ptr %40, i64 17
  br label %probe.i.i.i460

probe.i.i.i460:                                   ; preds = %next_grp.i.i.i520, %do_probe.i.i.i454
  %h.pn.i.i.i461 = phi i64 [ -8592923751486469375, %do_probe.i.i.i454 ], [ %padd.i.i.i522, %next_grp.i.i.i520 ]
  %step.i.i.i462 = phi i64 [ 0, %do_probe.i.i.i454 ], [ %step_next.i.i.i521, %next_grp.i.i.i520 ]
  %avail.i.i.i463 = phi i64 [ -1, %do_probe.i.i.i454 ], [ %avail_cur.i.i.i514, %next_grp.i.i.i520 ]
  %pos.i.i.i464 = and i64 %h.pn.i.i.i461, %mask.i.i.i457
  %gp.i.i.i465 = getelementptr inbounds i8, ptr %ctrl.i.i.i452, i64 %pos.i.i.i464
  %grp.i.i.i466 = load <16 x i8>, ptr %gp.i.i.i465, align 1
  %mcmp.i.i.i467 = icmp eq <16 x i8> %grp.i.i.i466, splat (i8 68)
  %mbits.i.i.i468 = bitcast <16 x i1> %mcmp.i.i.i467 to i16
  %has_m.not.i.i.i472911 = icmp eq i16 %mbits.i.i.i468, 0
  br i1 %has_m.not.i.i.i472911, label %chk_empty.i.i.i511, label %chk_key.i.i.i473.preheader

chk_key.i.i.i473.preheader:                       ; preds = %probe.i.i.i460
  %mmask0.i.i.i469 = zext i16 %mbits.i.i.i468 to i32
  br label %chk_key.i.i.i473

chk_key.i.i.i473:                                 ; preds = %chk_key.i.i.i473.preheader, %mbit_cont.i.i.i489
  %mmask.i.i.i471912 = phi i32 [ %mmask_next.i.i.i491, %mbit_cont.i.i.i489 ], [ %mmask0.i.i.i469, %chk_key.i.i.i473.preheader ]
  %tz.i2.i.i474 = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i471912, i1 true)
  %tz64.i.i.i475 = zext nneg i32 %tz.i2.i.i474 to i64
  %s_add.i.i.i476 = add i64 %pos.i.i.i464, %tz64.i.i.i475
  %slot.i.i.i477 = and i64 %s_add.i.i.i476, %mask.i.i.i457
  %ip.i.i.i478 = getelementptr inbounds i32, ptr %idx_base.i.i.i459, i64 %slot.i.i.i477
  %didx32.i.i.i479 = load i32, ptr %ip.i.i.i478, align 4
  %didx.i.i.i480 = zext i32 %didx32.i.i.i479 to i64
  %kp.i.i.i481 = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i458, i64 %didx.i.i.i480
  %cand_k.unpack.i.i.i482 = load i64, ptr %kp.i.i.i481, align 8
  %cand_k.elt1.i.i.i483 = getelementptr inbounds nuw i8, ptr %kp.i.i.i481, i64 8
  %cand_k.unpack2.i.i.i484 = load i64, ptr %cand_k.elt1.i.i.i483, align 8
  %w0_eq.i.i.i.i486 = icmp eq i64 %cand_k.unpack.i.i.i482, 28542638957264899
  %eq_s.i.i.i.i510 = icmp eq i64 %cand_k.unpack2.i.i.i484, 0
  %or.cond881 = select i1 %w0_eq.i.i.i.i486, i1 %eq_s.i.i.i.i510, i1 false
  br i1 %or.cond881, label %dget.ok.72, label %mbit_cont.i.i.i489

mbit_cont.i.i.i489:                               ; preds = %chk_key.i.i.i473
  %mm1.i.i.i490 = add nsw i32 %mmask.i.i.i471912, -1
  %mmask_next.i.i.i491 = and i32 %mm1.i.i.i490, %mmask.i.i.i471912
  %has_m.not.i.i.i472 = icmp eq i32 %mmask_next.i.i.i491, 0
  br i1 %has_m.not.i.i.i472, label %chk_empty.i.i.i511, label %chk_key.i.i.i473

chk_empty.i.i.i511:                               ; preds = %mbit_cont.i.i.i489, %probe.i.i.i460
  %need_a.i.i.i512 = icmp slt i64 %avail.i.i.i463, 0
  br i1 %need_a.i.i.i512, label %find_a.i.i.i523, label %after_a.i.i.i513

find_a.i.i.i523:                                  ; preds = %chk_empty.i.i.i511
  %acmp.i.i.i524 = icmp slt <16 x i8> %grp.i.i.i466, zeroinitializer
  %abits16.i.i.i525 = bitcast <16 x i1> %acmp.i.i.i524 to i16
  %has_a0.not.i.i.i526 = icmp eq i16 %abits16.i.i.i525, 0
  br i1 %has_a0.not.i.i.i526, label %after_a.i.i.i513, label %set_a.i.i.i527

set_a.i.i.i527:                                   ; preds = %find_a.i.i.i523
  %41 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i525, i1 true)
  %atz64.i.i.i528 = zext nneg i16 %41 to i64
  %as_add.i.i.i529 = add i64 %pos.i.i.i464, %atz64.i.i.i528
  %aslot.i.i.i530 = and i64 %as_add.i.i.i529, %mask.i.i.i457
  br label %after_a.i.i.i513

after_a.i.i.i513:                                 ; preds = %set_a.i.i.i527, %find_a.i.i.i523, %chk_empty.i.i.i511
  %avail_cur.i.i.i514 = phi i64 [ %avail.i.i.i463, %chk_empty.i.i.i511 ], [ -1, %find_a.i.i.i523 ], [ %aslot.i.i.i530, %set_a.i.i.i527 ]
  %ecmp.i.i.i515 = icmp eq <16 x i8> %grp.i.i.i466, splat (i8 -128)
  %ebits.i.i.i516 = bitcast <16 x i1> %ecmp.i.i.i515 to i16
  %has_e.not.i.i.i517 = icmp eq i16 %ebits.i.i.i516, 0
  br i1 %has_e.not.i.i.i517, label %next_grp.i.i.i520, label %dget.miss.73

next_grp.i.i.i520:                                ; preds = %after_a.i.i.i513
  %step_next.i.i.i521 = add i64 %step.i.i.i462, 16
  %padd.i.i.i522 = add i64 %step_next.i.i.i521, %pos.i.i.i464
  br label %probe.i.i.i460

dget.miss.73:                                     ; preds = %after_a.i.i.i513, %chk_ctrl.i.i.i449
  call fastcc void @archx_key_fail()
  unreachable

dget.ok.72:                                       ; preds = %chk_key.i.i.i473
  %t310 = load ptr, ptr %t211, align 16
  %t311 = getelementptr inbounds nuw %ArchxAny, ptr %t310, i64 %didx.i.i.i480
  %t312.unpack = load i64, ptr %t311, align 8
  %42 = insertvalue %ArchxAny poison, i64 %t312.unpack, 0
  %t312.elt101 = getelementptr inbounds nuw i8, ptr %t311, i64 8
  %t312.unpack102 = load i64, ptr %t312.elt101, align 8
  %43 = insertvalue %ArchxAny %42, i64 %t312.unpack102, 1
  %t312.elt103 = getelementptr inbounds nuw i8, ptr %t311, i64 16
  %t312.unpack104 = load i64, ptr %t312.elt103, align 8
  %t312105 = insertvalue %ArchxAny %43, i64 %t312.unpack104, 2
  %t313 = call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t312105)
  %newret988 = extractvalue { i64, i64, i64 } %t313, 0
  %oldret989 = insertvalue %ArchxAny poison, i64 %newret988, 0
  %newret990 = extractvalue { i64, i64, i64 } %t313, 1
  %oldret991 = insertvalue %ArchxAny %oldret989, i64 %newret990, 1
  %newret992 = extractvalue { i64, i64, i64 } %t313, 2
  %oldret993 = insertvalue %ArchxAny %oldret991, i64 %newret992, 2
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i697)
  store i32 1819894128, ptr %tmp.i697, align 4
  %tmp4.i699 = getelementptr inbounds nuw i8, ptr %tmp.i697, i64 4
  store i64 979657071, ptr %tmp4.i699, align 4
  %nul.i702 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i697, i32 0, i64 8)
  %has_nul.not.i703 = icmp eq ptr %nul.i702, null
  br i1 %has_nul.not.i703, label %fast_printf.i712, label %byte_loop.i704.preheader

byte_loop.i704.preheader:                         ; preds = %dget.ok.72
  %pc.i709 = call i32 @putchar(i32 112)
  %bp.i706.1 = getelementptr inbounds nuw i8, ptr %tmp.i697, i64 1
  %ch8.i707.1 = load i8, ptr %bp.i706.1, align 1
  %ch32.i708.1 = zext i8 %ch8.i707.1 to i32
  %pc.i709.1 = call i32 @putchar(i32 %ch32.i708.1)
  %bp.i706.2 = getelementptr inbounds nuw i8, ptr %tmp.i697, i64 2
  %ch8.i707.2 = load i8, ptr %bp.i706.2, align 2
  %ch32.i708.2 = zext i8 %ch8.i707.2 to i32
  %pc.i709.2 = call i32 @putchar(i32 %ch32.i708.2)
  %bp.i706.3 = getelementptr inbounds nuw i8, ptr %tmp.i697, i64 3
  %ch8.i707.3 = load i8, ptr %bp.i706.3, align 1
  %ch32.i708.3 = zext i8 %ch8.i707.3 to i32
  %pc.i709.3 = call i32 @putchar(i32 %ch32.i708.3)
  %ch8.i707.4 = load i8, ptr %tmp4.i699, align 4
  %ch32.i708.4 = zext i8 %ch8.i707.4 to i32
  %pc.i709.4 = call i32 @putchar(i32 %ch32.i708.4)
  %bp.i706.5 = getelementptr inbounds nuw i8, ptr %tmp.i697, i64 5
  %ch8.i707.5 = load i8, ptr %bp.i706.5, align 1
  %ch32.i708.5 = zext i8 %ch8.i707.5 to i32
  %pc.i709.5 = call i32 @putchar(i32 %ch32.i708.5)
  %bp.i706.6 = getelementptr inbounds nuw i8, ptr %tmp.i697, i64 6
  %ch8.i707.6 = load i8, ptr %bp.i706.6, align 2
  %ch32.i708.6 = zext i8 %ch8.i707.6 to i32
  %pc.i709.6 = call i32 @putchar(i32 %ch32.i708.6)
  %bp.i706.7 = getelementptr inbounds nuw i8, ptr %tmp.i697, i64 7
  %ch8.i707.7 = load i8, ptr %bp.i706.7, align 1
  %ch32.i708.7 = zext i8 %ch8.i707.7 to i32
  %pc.i709.7 = call i32 @putchar(i32 %ch32.i708.7)
  br label %archx_str_print.exit714

fast_printf.i712:                                 ; preds = %dget.ok.72
  %np.i713 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 8, ptr nonnull %tmp.i697)
  br label %archx_str_print.exit714

archx_str_print.exit714:                          ; preds = %byte_loop.i704.preheader, %fast_printf.i712
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i697)
  %t314 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret999)
  %t315 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i715)
  store i32 1835365481, ptr %tmp.i715, align 4
  %tmp4.i717 = getelementptr inbounds nuw i8, ptr %tmp.i715, i64 4
  store i64 14963, ptr %tmp4.i717, align 4
  %nul.i720 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i715, i32 0, i64 6)
  %has_nul.not.i721 = icmp eq ptr %nul.i720, null
  br i1 %has_nul.not.i721, label %fast_printf.i730, label %byte_loop.i722.preheader

byte_loop.i722.preheader:                         ; preds = %archx_str_print.exit714
  %pc.i727 = call i32 @putchar(i32 105)
  %bp.i724.1 = getelementptr inbounds nuw i8, ptr %tmp.i715, i64 1
  %ch8.i725.1 = load i8, ptr %bp.i724.1, align 1
  %ch32.i726.1 = zext i8 %ch8.i725.1 to i32
  %pc.i727.1 = call i32 @putchar(i32 %ch32.i726.1)
  %bp.i724.2 = getelementptr inbounds nuw i8, ptr %tmp.i715, i64 2
  %ch8.i725.2 = load i8, ptr %bp.i724.2, align 2
  %ch32.i726.2 = zext i8 %ch8.i725.2 to i32
  %pc.i727.2 = call i32 @putchar(i32 %ch32.i726.2)
  %bp.i724.3 = getelementptr inbounds nuw i8, ptr %tmp.i715, i64 3
  %ch8.i725.3 = load i8, ptr %bp.i724.3, align 1
  %ch32.i726.3 = zext i8 %ch8.i725.3 to i32
  %pc.i727.3 = call i32 @putchar(i32 %ch32.i726.3)
  %ch8.i725.4 = load i8, ptr %tmp4.i717, align 4
  %ch32.i726.4 = zext i8 %ch8.i725.4 to i32
  %pc.i727.4 = call i32 @putchar(i32 %ch32.i726.4)
  %bp.i724.5 = getelementptr inbounds nuw i8, ptr %tmp.i715, i64 5
  %ch8.i725.5 = load i8, ptr %bp.i724.5, align 1
  %ch32.i726.5 = zext i8 %ch8.i725.5 to i32
  %pc.i727.5 = call i32 @putchar(i32 %ch32.i726.5)
  br label %archx_str_print.exit732

fast_printf.i730:                                 ; preds = %archx_str_print.exit714
  %np.i731 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 6, ptr nonnull %tmp.i715)
  br label %archx_str_print.exit732

archx_str_print.exit732:                          ; preds = %byte_loop.i722.preheader, %fast_printf.i730
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i715)
  %t316 = call i32 @putchar(i32 32)
  %t317 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.i64s, i64 %common.ret.op.i696)
  %t318 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i733)
  store i32 979724129, ptr %tmp.i733, align 4
  %tmp4.i735 = getelementptr inbounds nuw i8, ptr %tmp.i733, i64 4
  store i64 0, ptr %tmp4.i735, align 4
  %nul.i738 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i733, i32 0, i64 4)
  %has_nul.not.i739 = icmp eq ptr %nul.i738, null
  br i1 %has_nul.not.i739, label %fast_printf.i748, label %byte_loop.i740.preheader

byte_loop.i740.preheader:                         ; preds = %archx_str_print.exit732
  %pc.i745 = call i32 @putchar(i32 97)
  %pc.i745.1 = call i32 @putchar(i32 103)
  %pc.i745.2 = call i32 @putchar(i32 101)
  %pc.i745.3 = call i32 @putchar(i32 58)
  br label %archx_str_print.exit750

fast_printf.i748:                                 ; preds = %archx_str_print.exit732
  %np.i749 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 4, ptr nonnull %tmp.i733)
  br label %archx_str_print.exit750

archx_str_print.exit750:                          ; preds = %byte_loop.i740.preheader, %fast_printf.i748
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i733)
  %t319 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret993)
  %t320 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %oldret993)
  call fastcc void @archx_any_drop(%ArchxAny %oldret987)
  call fastcc void @archx_any_drop(%ArchxAny %oldret999)
  call fastcc void @archx_any_drop(%ArchxAny %oldret981)
  %t330 = call fastcc { i64, i64, i64 } @archx_fn_summarize_tag(%ArchxAny { i64 4, i64 8458994031421030408, i64 1751215212 })
  %newret970 = extractvalue { i64, i64, i64 } %t330, 0
  %oldret971 = insertvalue %ArchxAny poison, i64 %newret970, 0
  %newret972 = extractvalue { i64, i64, i64 } %t330, 1
  %oldret973 = insertvalue %ArchxAny %oldret971, i64 %newret972, 1
  %newret974 = extractvalue { i64, i64, i64 } %t330, 2
  %oldret975 = insertvalue %ArchxAny %oldret973, i64 %newret974, 2
  %np.i766 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 14, ptr nonnull @.str.5)
  %t331 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret975)
  %t332 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %oldret975)
  %t341 = call fastcc { i64, i64, i64 } @archx_fn_summarize_tag(%ArchxAny { i64 2, i64 25, i64 0 })
  %newret964 = extractvalue { i64, i64, i64 } %t341, 0
  %oldret965 = insertvalue %ArchxAny poison, i64 %newret964, 0
  %newret966 = extractvalue { i64, i64, i64 } %t341, 1
  %oldret967 = insertvalue %ArchxAny %oldret965, i64 %newret966, 1
  %newret968 = extractvalue { i64, i64, i64 } %t341, 2
  %oldret969 = insertvalue %ArchxAny %oldret967, i64 %newret968, 2
  %np.i788 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 13, ptr nonnull @.str.6)
  %t342 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret969)
  %t343 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %oldret969)
  %t353 = call noalias align 16 dereferenceable_or_null(72) ptr @malloc(i64 72)
  %t354 = icmp eq ptr %t353, null
  br i1 %t354, label %alloc.oom.75, label %alloc.ok.74

alloc.oom.75:                                     ; preds = %archx_str_print.exit750
  call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.74:                                      ; preds = %archx_str_print.exit750
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
  %newret960 = extractvalue { i64, i64, i64 } %t371, 1
  %oldret961 = insertvalue %ArchxAny %oldret, i64 %newret960, 1
  %newret962 = extractvalue { i64, i64, i64 } %t371, 2
  %oldret963 = insertvalue %ArchxAny %oldret961, i64 %newret962, 2
  %t375 = call fastcc { i64, i64, i64 } @archx_any_get_idx(%ArchxAny %t370.fca.2.insert, %ArchxAny { i64 2, i64 -1, i64 0 })
  %newret1000 = extractvalue { i64, i64, i64 } %t375, 0
  %oldret1001 = insertvalue %ArchxAny poison, i64 %newret1000, 0
  %newret1002 = extractvalue { i64, i64, i64 } %t375, 1
  %oldret1003 = insertvalue %ArchxAny %oldret1001, i64 %newret1002, 1
  %newret1004 = extractvalue { i64, i64, i64 } %t375, 2
  %oldret1005 = insertvalue %ArchxAny %oldret1003, i64 %newret1004, 2
  %np.i805 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 13, ptr nonnull @.str.7)
  %t376 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret963)
  %t377 = call i32 @putchar(i32 32)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i807)
  store i32 1953718636, ptr %tmp.i807, align 4
  %tmp4.i809 = getelementptr inbounds nuw i8, ptr %tmp.i807, i64 4
  store i64 58, ptr %tmp4.i809, align 4
  %nul.i812 = call ptr @memchr(ptr noundef nonnull dereferenceable(1) %tmp.i807, i32 0, i64 5)
  %has_nul.not.i813 = icmp eq ptr %nul.i812, null
  br i1 %has_nul.not.i813, label %fast_printf.i822, label %byte_loop.i814.preheader

byte_loop.i814.preheader:                         ; preds = %alloc.ok.76
  %pc.i819 = call i32 @putchar(i32 108)
  %pc.i819.1 = call i32 @putchar(i32 97)
  %pc.i819.2 = call i32 @putchar(i32 115)
  %pc.i819.3 = call i32 @putchar(i32 116)
  %pc.i819.4 = call i32 @putchar(i32 58)
  br label %archx_str_print.exit824

fast_printf.i822:                                 ; preds = %alloc.ok.76
  %np.i823 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr, i32 5, ptr nonnull %tmp.i807)
  br label %archx_str_print.exit824

archx_str_print.exit824:                          ; preds = %byte_loop.i814.preheader, %fast_printf.i822
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i807)
  %t378 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %oldret1005)
  %t379 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %oldret1005)
  call fastcc void @archx_any_drop(%ArchxAny %oldret963)
  call fastcc void @archx_any_drop(%ArchxAny %t370.fca.2.insert)
  %len.i826 = load i64, ptr %hp.i686, align 16
  %keys_p.i828 = getelementptr inbounds nuw i8, ptr %hp.i686, i64 40
  %ctrl.i830 = load ptr, ptr %ctrl_p.i.i.i131, align 16
  %keys.i831 = load ptr, ptr %keys_p.i828, align 8
  %vals.i832 = load ptr, ptr %t211, align 16
  %more9.i = icmp sgt i64 %len.i826, 0
  br i1 %more9.i, label %d_elem.i, label %do_free.i834

d_elem.i:                                         ; preds = %archx_str_print.exit824, %archx_str_drop.exit.i843
  %storemerge10.i = phi i64 [ %inext.i, %archx_str_drop.exit.i843 ], [ 0, %archx_str_print.exit824 ]
  %t0.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i831, i64 %storemerge10.i
  %t1.unpack.i = load i64, ptr %t0.i, align 8
  %t1.elt1.i = getelementptr inbounds nuw i8, ptr %t0.i, i64 8
  %t1.unpack2.i = load i64, ptr %t1.elt1.i, align 8
  %len.i.i835 = and i64 %t1.unpack.i, 4294967295
  %long.i.i836 = icmp samesign ult i64 %len.i.i835, 13
  %tag.i.i837 = and i64 %t1.unpack2.i, 1
  %owned.not.i.i838 = icmp eq i64 %tag.i.i837, 0
  %or.cond.i839 = select i1 %long.i.i836, i1 true, i1 %owned.not.i.i838
  br i1 %or.cond.i839, label %archx_str_drop.exit.i843, label %do_free.i.i840

do_free.i.i840:                                   ; preds = %d_elem.i
  %raw.i.i841 = and i64 %t1.unpack2.i, -2
  %ptr.i.i842 = inttoptr i64 %raw.i.i841 to ptr
  call void @free(ptr %ptr.i.i842)
  br label %archx_str_drop.exit.i843

archx_str_drop.exit.i843:                         ; preds = %do_free.i.i840, %d_elem.i
  %t2.i = getelementptr inbounds nuw %ArchxAny, ptr %vals.i832, i64 %storemerge10.i
  %t3.unpack.i = load i64, ptr %t2.i, align 8
  %44 = insertvalue %ArchxAny poison, i64 %t3.unpack.i, 0
  %t3.elt4.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 8
  %t3.unpack5.i = load i64, ptr %t3.elt4.i, align 8
  %45 = insertvalue %ArchxAny %44, i64 %t3.unpack5.i, 1
  %t3.elt6.i = getelementptr inbounds nuw i8, ptr %t2.i, i64 16
  %t3.unpack7.i = load i64, ptr %t3.elt6.i, align 8
  %t38.i844 = insertvalue %ArchxAny %45, i64 %t3.unpack7.i, 2
  call fastcc void @archx_any_drop(%ArchxAny %t38.i844)
  %inext.i = add nuw nsw i64 %storemerge10.i, 1
  %exitcond.not.i845 = icmp eq i64 %inext.i, %len.i826
  br i1 %exitcond.not.i845, label %do_free.i834, label %d_elem.i

do_free.i834:                                     ; preds = %archx_str_drop.exit.i843, %archx_str_print.exit824
  call void @free(ptr %ctrl.i830)
  call void @free(ptr %keys.i831)
  call void @free(ptr %vals.i832)
  call void @free(ptr %hp.i686)
  call void @free(ptr %t74)
  %vals_p.i853 = getelementptr inbounds nuw i8, ptr %hp.i, i64 48
  %vals.i854 = load ptr, ptr %vals_p.i853, align 16
  %keys_p.i855 = getelementptr inbounds nuw i8, ptr %hp.i, i64 40
  %keys.i856 = load ptr, ptr %keys_p.i855, align 8
  %ctrl.i858 = load ptr, ptr %ctrl_p.i.i, align 16
  call void @free(ptr %ctrl.i858)
  call void @free(ptr %keys.i856)
  call void @free(ptr %vals.i854)
  call void @free(ptr %hp.i)
  %t0.unpack.i = load i64, ptr %t0, align 16
  %t0.unpack2.i = load i64, ptr %t0.repack30, align 8
  %len.i.i859 = and i64 %t0.unpack.i, 4294967295
  %long.i.i860 = icmp samesign ult i64 %len.i.i859, 13
  %tag.i.i861 = and i64 %t0.unpack2.i, 1
  %owned.not.i.i862 = icmp eq i64 %tag.i.i861, 0
  %or.cond.i863 = select i1 %long.i.i860, i1 true, i1 %owned.not.i.i862
  br i1 %or.cond.i863, label %archx_str_drop.exit.i867, label %do_free.i.i864

do_free.i.i864:                                   ; preds = %do_free.i834
  %raw.i.i865 = and i64 %t0.unpack2.i, -2
  %ptr.i.i866 = inttoptr i64 %raw.i.i865 to ptr
  call void @free(ptr %ptr.i.i866)
  br label %archx_str_drop.exit.i867

archx_str_drop.exit.i867:                         ; preds = %do_free.i.i864, %do_free.i834
  %t0.unpack.1.i = load i64, ptr %t3, align 16
  %t0.unpack2.1.i = load i64, ptr %t3.repack31, align 8
  %len.i.1.i = and i64 %t0.unpack.1.i, 4294967295
  %long.i.1.i = icmp samesign ult i64 %len.i.1.i, 13
  %tag.i.1.i = and i64 %t0.unpack2.1.i, 1
  %owned.not.i.1.i = icmp eq i64 %tag.i.1.i, 0
  %or.cond.1.i = select i1 %long.i.1.i, i1 true, i1 %owned.not.i.1.i
  br i1 %or.cond.1.i, label %archx_str_drop.exit.1.i, label %do_free.i.1.i

do_free.i.1.i:                                    ; preds = %archx_str_drop.exit.i867
  %raw.i.1.i = and i64 %t0.unpack2.1.i, -2
  %ptr.i.1.i = inttoptr i64 %raw.i.1.i to ptr
  call void @free(ptr %ptr.i.1.i)
  br label %archx_str_drop.exit.1.i

archx_str_drop.exit.1.i:                          ; preds = %do_free.i.1.i, %archx_str_drop.exit.i867
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
define private fastcc void @archx_int_overflow_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str)
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
define private fastcc range(i64 -2147483648, 2147483650) i64 @archx_fmt_float_buf(double %x, ptr nonnull captures(none) %buf) unnamed_addr #4 {
entry:
  %n15 = tail call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf, ptr nonnull dereferenceable(1) @.fmt.g15, double %x)
  %back15 = tail call double @strtod(ptr nonnull captures(none) %buf, ptr null)
  %eq15 = fcmp oeq double %back15, %x
  br i1 %eq15, label %done, label %try16

try16:                                            ; preds = %entry
  %n16 = tail call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf, ptr nonnull dereferenceable(1) @.fmt.g16, double %x)
  %back16 = tail call double @strtod(ptr nonnull captures(none) %buf, ptr null)
  %eq16 = fcmp oeq double %back16, %x
  br i1 %eq16, label %done, label %try17

try17:                                            ; preds = %try16
  %n17 = tail call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf, ptr nonnull dereferenceable(1) @.fmt.g17, double %x)
  br label %done

done:                                             ; preds = %try17, %try16, %entry
  %n32 = phi i32 [ %n15, %entry ], [ %n16, %try16 ], [ %n17, %try17 ]
  %n = sext i32 %n32 to i64
  %pos = icmp sgt i32 %n32, 0
  br i1 %pos, label %scan, label %common.ret

scan:                                             ; preds = %done, %scan_step
  %i = phi i64 [ %inext, %scan_step ], [ 0, %done ]
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

common.ret:                                       ; preds = %scan, %scan, %scan, %scan, %scan, %scan, %scan, %done, %append_dot0
  %common.ret.op = phi i64 [ %n2, %append_dot0 ], [ %n, %done ], [ %n, %scan ], [ %n, %scan ], [ %n, %scan ], [ %n, %scan ], [ %n, %scan ], [ %n, %scan ], [ %n, %scan ]
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

; Function Attrs: mustprogress nocallback nofree nounwind willreturn
declare double @strtod(ptr readonly captures(none), ptr writeonly captures(none)) local_unnamed_addr #13

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.fptosi.sat.i64.f64(double) #11

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_key_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.3)
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

; Function Attrs: nofree nounwind
define private fastcc i64 @archx_dict_key_hash_at(ptr readonly captures(none) %keys, i64 %idx, i64 range(i64 0, 256) %kind) unnamed_addr #4 {
entry:
  %trunc = trunc nuw i64 %kind to i8
  switch i8 %trunc, label %k_any [
    i8 0, label %k_i64
    i8 1, label %k_str
  ]

common.ret:                                       ; preds = %l_done.i, %sso_mix.i, %k_any, %k_i64
  %common.ret.op = phi i64 [ %x3.i, %k_i64 ], [ %ha, %k_any ], [ %x3.i17.i, %sso_mix.i ], [ %x3.i.i, %l_done.i ]
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
  %0 = insertvalue %ArchxAny poison, i64 %va.unpack, 0
  %va.elt4 = getelementptr inbounds nuw i8, ptr %pa, i64 8
  %va.unpack5 = load i64, ptr %va.elt4, align 8
  %1 = insertvalue %ArchxAny %0, i64 %va.unpack5, 1
  %va.elt6 = getelementptr inbounds nuw i8, ptr %pa, i64 16
  %va.unpack7 = load i64, ptr %va.elt6, align 8
  %va8 = insertvalue %ArchxAny %1, i64 %va.unpack7, 2
  %ha = tail call fastcc i64 @archx_any_hash(%ArchxAny %va8)
  br label %common.ret

k_str:                                            ; preds = %entry
  %ps = getelementptr inbounds %ArchxStr, ptr %keys, i64 %idx
  %vs.unpack = load i64, ptr %ps, align 8
  %vs.elt1 = getelementptr inbounds nuw i8, ptr %ps, i64 8
  %vs.unpack2 = load i64, ptr %vs.elt1, align 8
  %len.i = and i64 %vs.unpack, 4294967295
  %short.i = icmp samesign ult i64 %len.i, 13
  br i1 %short.i, label %sso_hash.i, label %long_hash.i

sso_hash.i:                                       ; preds = %k_str
  %p0_raw.i = lshr i64 %vs.unpack, 32
  %le4.i = icmp samesign ult i64 %len.i, 5
  br i1 %le4.i, label %sso_le4.i, label %sso_gt4.i

sso_le4.i:                                        ; preds = %sso_hash.i
  %sh0.i = shl nuw nsw i64 %len.i, 3
  %notmask1.i = shl nsw i64 -1, %sh0.i
  %m0.i = xor i64 %notmask1.i, -1
  %p0_4.i = and i64 %p0_raw.i, %m0.i
  br label %sso_mix.i

sso_gt4.i:                                        ; preds = %sso_hash.i
  %eq12.i = icmp eq i64 %len.i, 12
  br i1 %eq12.i, label %sso_mix.i, label %sso_mid.i

sso_mid.i:                                        ; preds = %sso_gt4.i
  %rem.i = shl nuw nsw i64 %len.i, 3
  %sh1.i = add nsw i64 %rem.i, -32
  %notmask.i = shl nsw i64 -1, %sh1.i
  %m1.i9 = xor i64 %notmask.i, -1
  %p1_m.i = and i64 %vs.unpack2, %m1.i9
  br label %sso_mix.i

sso_mix.i:                                        ; preds = %sso_mid.i, %sso_gt4.i, %sso_le4.i
  %p0.i = phi i64 [ %p0_4.i, %sso_le4.i ], [ %p0_raw.i, %sso_mid.i ], [ %p0_raw.i, %sso_gt4.i ]
  %p1.i = phi i64 [ 0, %sso_le4.i ], [ %p1_m.i, %sso_mid.i ], [ %vs.unpack2, %sso_gt4.i ]
  %a0.i = mul i64 %p0.i, -7046029254386353131
  %a1.i = mul i64 %p1.i, -4417276706812531889
  %ax.i = xor i64 %a1.i, %a0.i
  %s1.i10.i = lshr i64 %ax.i, 30
  %2 = xor i64 %len.i, %s1.i10.i
  %x1.i11.i = xor i64 %2, %ax.i
  %m1.i12.i = mul i64 %x1.i11.i, -4658895280553007687
  %s2.i13.i = lshr i64 %m1.i12.i, 27
  %x2.i14.i = xor i64 %s2.i13.i, %m1.i12.i
  %m2.i15.i = mul i64 %x2.i14.i, -7723592293110705685
  %s3.i16.i = lshr i64 %m2.i15.i, 31
  %x3.i17.i = xor i64 %s3.i16.i, %m2.i15.i
  br label %common.ret

long_hash.i:                                      ; preds = %k_str
  %raw.i = and i64 %vs.unpack2, -4
  %ptr.i = inttoptr i64 %raw.i to ptr
  %seed.i = mul i64 %len.i, -7046029254386353131
  %3 = add nsw i64 %len.i, -8
  %4 = icmp ult i64 %3, 8
  br i1 %4, label %l_tail_cond.i.preheader.unr-lcssa, label %long_hash.i.new

long_hash.i.new:                                  ; preds = %long_hash.i
  %5 = lshr i64 %3, 3
  %6 = add nuw nsw i64 %5, 1
  %unroll_iter = and i64 %6, 4611686018427387902
  br label %l_body.i

l_tail_cond.i.preheader.unr-lcssa:                ; preds = %l_body.i, %long_hash.i
  %acc_next.i.lcssa.ph = phi i64 [ poison, %long_hash.i ], [ %acc_next.i.1, %l_body.i ]
  %idx_next.i.lcssa.ph = phi i64 [ poison, %long_hash.i ], [ %idx_next.i.1, %l_body.i ]
  %acc.i11.unr = phi i64 [ %seed.i, %long_hash.i ], [ %acc_next.i.1, %l_body.i ]
  %idx.i10.unr = phi i64 [ 0, %long_hash.i ], [ %idx_next.i.1, %l_body.i ]
  %7 = and i64 %3, 8
  %lcmp.mod.not.not = icmp eq i64 %7, 0
  br i1 %lcmp.mod.not.not, label %l_body.i.epil, label %l_tail_cond.i.preheader

l_body.i.epil:                                    ; preds = %l_tail_cond.i.preheader.unr-lcssa
  %lp.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %idx.i10.unr
  %lane.i.epil = load i64, ptr %lp.i.epil, align 4
  %lm.i.epil = mul i64 %lane.i.epil, -4417276706812531889
  %lx.i.epil = xor i64 %lm.i.epil, %acc.i11.unr
  %s1.i2.i.epil = lshr i64 %lx.i.epil, 30
  %x1.i3.i.epil = xor i64 %s1.i2.i.epil, %lx.i.epil
  %m1.i4.i.epil = mul i64 %x1.i3.i.epil, -4658895280553007687
  %s2.i5.i.epil = lshr i64 %m1.i4.i.epil, 27
  %x2.i6.i.epil = xor i64 %s2.i5.i.epil, %m1.i4.i.epil
  %m2.i7.i.epil = mul i64 %x2.i6.i.epil, -7723592293110705685
  %s3.i8.i.epil = lshr i64 %m2.i7.i.epil, 31
  %x3.i9.i.epil = xor i64 %s3.i8.i.epil, %m2.i7.i.epil
  %acc_next.i.epil = add i64 %x3.i9.i.epil, %idx.i10.unr
  %idx_next.i.epil = add nuw nsw i64 %idx.i10.unr, 8
  br label %l_tail_cond.i.preheader

l_tail_cond.i.preheader:                          ; preds = %l_tail_cond.i.preheader.unr-lcssa, %l_body.i.epil
  %acc_next.i.lcssa = phi i64 [ %acc_next.i.lcssa.ph, %l_tail_cond.i.preheader.unr-lcssa ], [ %acc_next.i.epil, %l_body.i.epil ]
  %idx_next.i.lcssa = phi i64 [ %idx_next.i.lcssa.ph, %l_tail_cond.i.preheader.unr-lcssa ], [ %idx_next.i.epil, %l_body.i.epil ]
  %tmore.i12 = icmp samesign ult i64 %idx_next.i.lcssa, %len.i
  br i1 %tmore.i12, label %l_tail_body.i.preheader, label %l_done.i

l_tail_body.i.preheader:                          ; preds = %l_tail_cond.i.preheader
  %8 = sub i64 %vs.unpack, %idx_next.i.lcssa
  %xtraiter17 = and i64 %8, 3
  %lcmp.mod18.not = icmp eq i64 %xtraiter17, 0
  br i1 %lcmp.mod18.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol

l_tail_body.i.prol:                               ; preds = %l_tail_body.i.preheader, %l_tail_body.i.prol
  %tacc.i14.prol = phi i64 [ %tacc_next.i.prol, %l_tail_body.i.prol ], [ %acc_next.i.lcssa, %l_tail_body.i.preheader ]
  %ti.i13.prol = phi i64 [ %ti_next.i.prol, %l_tail_body.i.prol ], [ %idx_next.i.lcssa, %l_tail_body.i.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %l_tail_body.i.prol ], [ 0, %l_tail_body.i.preheader ]
  %tp.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %ti.i13.prol
  %tb.i.prol = load i8, ptr %tp.i.prol, align 1
  %tz.i.prol = zext i8 %tb.i.prol to i64
  %tx.i.prol = xor i64 %tacc.i14.prol, %tz.i.prol
  %tacc_next.i.prol = mul i64 %tx.i.prol, 1099511628211
  %ti_next.i.prol = add nuw nsw i64 %ti.i13.prol, 1
  %prol.iter.next = add i64 %prol.iter, 1
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter17
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol, !llvm.loop !4

l_tail_body.i.prol.loopexit:                      ; preds = %l_tail_body.i.prol, %l_tail_body.i.preheader
  %tacc.i14.unr = phi i64 [ %acc_next.i.lcssa, %l_tail_body.i.preheader ], [ %tacc_next.i.prol, %l_tail_body.i.prol ]
  %ti.i13.unr = phi i64 [ %idx_next.i.lcssa, %l_tail_body.i.preheader ], [ %ti_next.i.prol, %l_tail_body.i.prol ]
  %tacc_next.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.preheader ], [ %tacc_next.i.prol, %l_tail_body.i.prol ]
  %9 = sub i64 %idx_next.i.lcssa, %len.i
  %10 = icmp ugt i64 %9, -4
  br i1 %10, label %l_done.i, label %l_tail_body.i.preheader.new

l_tail_body.i.preheader.new:                      ; preds = %l_tail_body.i.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr.i, i64 1
  %invariant.gep19 = getelementptr i8, ptr %ptr.i, i64 2
  %invariant.gep21 = getelementptr i8, ptr %ptr.i, i64 3
  br label %l_tail_body.i

l_body.i:                                         ; preds = %l_body.i, %long_hash.i.new
  %acc.i11 = phi i64 [ %seed.i, %long_hash.i.new ], [ %acc_next.i.1, %l_body.i ]
  %idx.i10 = phi i64 [ 0, %long_hash.i.new ], [ %idx_next.i.1, %l_body.i ]
  %niter = phi i64 [ 0, %long_hash.i.new ], [ %niter.next.1, %l_body.i ]
  %lp.i = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %idx.i10
  %lane.i = load i64, ptr %lp.i, align 4
  %lm.i = mul i64 %lane.i, -4417276706812531889
  %lx.i = xor i64 %lm.i, %acc.i11
  %s1.i2.i = lshr i64 %lx.i, 30
  %x1.i3.i = xor i64 %s1.i2.i, %lx.i
  %m1.i4.i = mul i64 %x1.i3.i, -4658895280553007687
  %s2.i5.i = lshr i64 %m1.i4.i, 27
  %x2.i6.i = xor i64 %s2.i5.i, %m1.i4.i
  %m2.i7.i = mul i64 %x2.i6.i, -7723592293110705685
  %s3.i8.i = lshr i64 %m2.i7.i, 31
  %x3.i9.i = xor i64 %s3.i8.i, %m2.i7.i
  %acc_next.i = add i64 %x3.i9.i, %idx.i10
  %idx_next.i = or disjoint i64 %idx.i10, 8
  %lp.i.1 = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %idx_next.i
  %lane.i.1 = load i64, ptr %lp.i.1, align 4
  %lm.i.1 = mul i64 %lane.i.1, -4417276706812531889
  %lx.i.1 = xor i64 %lm.i.1, %acc_next.i
  %s1.i2.i.1 = lshr i64 %lx.i.1, 30
  %x1.i3.i.1 = xor i64 %s1.i2.i.1, %lx.i.1
  %m1.i4.i.1 = mul i64 %x1.i3.i.1, -4658895280553007687
  %s2.i5.i.1 = lshr i64 %m1.i4.i.1, 27
  %x2.i6.i.1 = xor i64 %s2.i5.i.1, %m1.i4.i.1
  %m2.i7.i.1 = mul i64 %x2.i6.i.1, -7723592293110705685
  %s3.i8.i.1 = lshr i64 %m2.i7.i.1, 31
  %x3.i9.i.1 = xor i64 %s3.i8.i.1, %m2.i7.i.1
  %acc_next.i.1 = add i64 %x3.i9.i.1, %idx_next.i
  %idx_next.i.1 = add nuw nsw i64 %idx.i10, 16
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1.not = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1.not, label %l_tail_cond.i.preheader.unr-lcssa, label %l_body.i

l_tail_body.i:                                    ; preds = %l_tail_body.i, %l_tail_body.i.preheader.new
  %tacc.i14 = phi i64 [ %tacc.i14.unr, %l_tail_body.i.preheader.new ], [ %tacc_next.i.3, %l_tail_body.i ]
  %ti.i13 = phi i64 [ %ti.i13.unr, %l_tail_body.i.preheader.new ], [ %ti_next.i.3, %l_tail_body.i ]
  %tp.i = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %ti.i13
  %tb.i = load i8, ptr %tp.i, align 1
  %tz.i = zext i8 %tb.i to i64
  %tx.i = xor i64 %tacc.i14, %tz.i
  %tacc_next.i = mul i64 %tx.i, 1099511628211
  %gep = getelementptr i8, ptr %invariant.gep, i64 %ti.i13
  %tb.i.1 = load i8, ptr %gep, align 1
  %tz.i.1 = zext i8 %tb.i.1 to i64
  %tx.i.1 = xor i64 %tacc_next.i, %tz.i.1
  %tacc_next.i.1 = mul i64 %tx.i.1, 1099511628211
  %gep20 = getelementptr i8, ptr %invariant.gep19, i64 %ti.i13
  %tb.i.2 = load i8, ptr %gep20, align 1
  %tz.i.2 = zext i8 %tb.i.2 to i64
  %tx.i.2 = xor i64 %tacc_next.i.1, %tz.i.2
  %tacc_next.i.2 = mul i64 %tx.i.2, 1099511628211
  %gep22 = getelementptr i8, ptr %invariant.gep21, i64 %ti.i13
  %tb.i.3 = load i8, ptr %gep22, align 1
  %tz.i.3 = zext i8 %tb.i.3 to i64
  %tx.i.3 = xor i64 %tacc_next.i.2, %tz.i.3
  %tacc_next.i.3 = mul i64 %tx.i.3, 1099511628211
  %ti_next.i.3 = add nuw nsw i64 %ti.i13, 4
  %tmore.i.3 = icmp samesign ult i64 %ti_next.i.3, %len.i
  br i1 %tmore.i.3, label %l_tail_body.i, label %l_done.i

l_done.i:                                         ; preds = %l_tail_body.i.prol.loopexit, %l_tail_body.i, %l_tail_cond.i.preheader
  %tacc.i.lcssa = phi i64 [ %acc_next.i.lcssa, %l_tail_cond.i.preheader ], [ %tacc_next.i.lcssa.unr, %l_tail_body.i.prol.loopexit ], [ %tacc_next.i.3, %l_tail_body.i ]
  %s1.i.i = lshr i64 %tacc.i.lcssa, 30
  %x1.i.i = xor i64 %s1.i.i, %tacc.i.lcssa
  %m1.i.i = mul i64 %x1.i.i, -4658895280553007687
  %s2.i.i = lshr i64 %m1.i.i, 27
  %x2.i.i = xor i64 %s2.i.i, %m1.i.i
  %m2.i.i = mul i64 %x2.i.i, -7723592293110705685
  %s3.i.i = lshr i64 %m2.i.i, 31
  %x3.i.i = xor i64 %s3.i.i, %m2.i.i
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
  br i1 %uninit, label %probe_insert_init, label %chk_probe_existing

chk_probe_existing:                               ; preds = %entry
  %is_z.i = icmp eq i64 %raw, 0
  br i1 %is_z.i, label %archx_dict_find_h_i64.exit, label %do_probe.i

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
  %avail.i = phi i64 [ -1, %do_probe.i ], [ %avail_cur.i, %next_grp.i ]
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
  br i1 %eq.i, label %found.i, label %mbit_cont.i

mbit_cont.i:                                      ; preds = %chk_key.i
  %mm1.i = add nsw i32 %mmask.i4, -1
  %mmask_next.i = and i32 %mm1.i, %mmask.i4
  %has_m.not.i = icmp eq i32 %mmask_next.i, 0
  br i1 %has_m.not.i, label %chk_empty.i, label %chk_key.i

chk_empty.i:                                      ; preds = %mbit_cont.i, %probe.i
  %need_a.i = icmp slt i64 %avail.i, 0
  br i1 %need_a.i, label %find_a.i, label %after_a.i

find_a.i:                                         ; preds = %chk_empty.i
  %acmp.i = icmp slt <16 x i8> %grp.i, zeroinitializer
  %abits16.i = bitcast <16 x i1> %acmp.i to i16
  %has_a0.not.i = icmp eq i16 %abits16.i, 0
  br i1 %has_a0.not.i, label %after_a.i, label %set_a.i

set_a.i:                                          ; preds = %find_a.i
  %1 = tail call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i, i1 true)
  %atz64.i = zext nneg i16 %1 to i64
  %as_add.i = add i64 %pos.i, %atz64.i
  %aslot.i = and i64 %as_add.i, %mask.i
  br label %after_a.i

after_a.i:                                        ; preds = %set_a.i, %find_a.i, %chk_empty.i
  %avail_cur.i = phi i64 [ %avail.i, %chk_empty.i ], [ -1, %find_a.i ], [ %aslot.i, %set_a.i ]
  %ecmp.i = icmp eq <16 x i8> %grp.i, splat (i8 -128)
  %ebits.i = bitcast <16 x i1> %ecmp.i to i16
  %has_e.not.i = icmp eq i16 %ebits.i, 0
  br i1 %has_e.not.i, label %next_grp.i, label %not_found_avail.i

next_grp.i:                                       ; preds = %after_a.i
  %step_next.i = add i64 %step.i, 16
  %padd.i = add i64 %step_next.i, %pos.i
  br label %probe.i

found.i:                                          ; preds = %chk_key.i
  %f0.i = insertvalue { i64, i64 } poison, i64 %didx.i, 0
  %f1.i = insertvalue { i64, i64 } %f0.i, i64 %slot.i, 1
  br label %archx_dict_find_h_i64.exit

not_found_avail.i:                                ; preds = %after_a.i
  %nf1.i = insertvalue { i64, i64 } { i64 -1, i64 poison }, i64 %avail_cur.i, 1
  br label %archx_dict_find_h_i64.exit

archx_dict_find_h_i64.exit:                       ; preds = %chk_probe_existing, %found.i, %not_found_avail.i
  %common.ret.op.i = phi { i64, i64 } [ %f1.i, %found.i ], [ %nf1.i, %not_found_avail.i ], [ { i64 -1, i64 -1 }, %chk_probe_existing ]
  %found_idx = extractvalue { i64, i64 } %common.ret.op.i, 0
  %avail_slot = extractvalue { i64, i64 } %common.ret.op.i, 1
  %exists = icmp sgt i64 %found_idx, -1
  br i1 %exists, label %common.ret, label %chk_cap

common.ret:                                       ; preds = %archx_dict_find_h_i64.exit, %archx_dict_set_ctrl.exit
  ret void

chk_cap:                                          ; preds = %archx_dict_find_h_i64.exit
  %used_p = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %used0 = load i64, ptr %used_p, align 8
  %mask0 = load i64, ptr %mask_p, align 8
  %scap0 = add i64 %mask0, 1
  %u1 = shl i64 %used0, 3
  %lhs = add i64 %u1, 8
  %rhs = mul i64 %scap0, 7
  %full = icmp sgt i64 %lhs, %rhs
  br i1 %full, label %probe_insert_init, label %fast_insert_prep

fast_insert_prep:                                 ; preds = %chk_cap
  %keys_pf = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %keys_f = load ptr, ptr %keys_pf, align 8
  %2 = getelementptr i8, ptr %ctrl0, i64 %mask0
  br label %iput_commit

probe_insert_init:                                ; preds = %chk_cap, %entry
  tail call fastcc void @archx_dict_grow(ptr nonnull %hdr)
  %used_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %keys_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %mask = load i64, ptr %mask_p2, align 8
  %keys = load ptr, ptr %keys_p2, align 8
  %scap = add i64 %mask, 1
  %3 = getelementptr i8, ptr %ctrl, i64 %mask
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
  %4 = tail call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits.lcssa, i1 true)
  %tz64 = zext nneg i16 %4 to i64
  %s_add = add i64 %pos.lcssa, %tz64
  %slot_g = and i64 %s_add, %mask
  %u_cur.pre = load i64, ptr %used_p2, align 8
  br label %iput_commit

iput_commit:                                      ; preds = %iput, %fast_insert_prep
  %u_cur = phi i64 [ %used0, %fast_insert_prep ], [ %u_cur.pre, %iput ]
  %slot = phi i64 [ %avail_slot, %fast_insert_prep ], [ %slot_g, %iput ]
  %ctrl_c = phi ptr [ %ctrl0, %fast_insert_prep ], [ %ctrl, %iput ]
  %scap_c = phi i64 [ %scap0, %fast_insert_prep ], [ %scap, %iput ]
  %.pn = phi ptr [ %2, %fast_insert_prep ], [ %3, %iput ]
  %keys_c = phi ptr [ %keys_f, %fast_insert_prep ], [ %keys, %iput ]
  %used_pc = phi ptr [ %used_p, %fast_insert_prep ], [ %used_p2, %iput ]
  %h2_c.in = lshr i64 %m2.i, 57
  %h2_c = trunc nuw nsw i64 %h2_c.in to i8
  %idx_base_c = getelementptr i8, ptr %.pn, i64 17
  %sp_c = getelementptr inbounds i8, ptr %ctrl_c, i64 %slot
  %old_cb = load i8, ptr %sp_c, align 1
  %was_empty = icmp eq i8 %old_cb, -128
  %u_inc = zext i1 %was_empty to i64
  %u_new = add i64 %u_cur, %u_inc
  store i64 %u_new, ptr %used_pc, align 8
  store i8 %h2_c, ptr %sp_c, align 1
  %mir.i = icmp ult i64 %slot, 16
  br i1 %mir.i, label %do_mir.i, label %archx_dict_set_ctrl.exit

do_mir.i:                                         ; preds = %iput_commit
  %5 = getelementptr i8, ptr %ctrl_c, i64 %scap_c
  %mp.i = getelementptr i8, ptr %5, i64 %slot
  store i8 %h2_c, ptr %mp.i, align 1
  br label %archx_dict_set_ctrl.exit

archx_dict_set_ctrl.exit:                         ; preds = %iput_commit, %do_mir.i
  %d_idx = load i64, ptr %hdr, align 8
  %d_new = add i64 %d_idx, 1
  store i64 %d_new, ptr %hdr, align 8
  %ip = getelementptr inbounds i32, ptr %idx_base_c, i64 %slot
  %d_idx32 = trunc i64 %d_idx to i32
  store i32 %d_idx32, ptr %ip, align 4
  %kp = getelementptr inbounds i64, ptr %keys_c, i64 %d_idx
  store i64 %key, ptr %kp, align 8
  br label %common.ret
}

; Function Attrs: nounwind
define private fastcc { i64, i1 } @archx_dict_upsert_str(i64 range(i64 1, 0) %d, %ArchxStr %key) unnamed_addr #0 {
entry:
  %w0.i = extractvalue %ArchxStr %key, 0
  %w1.i = extractvalue %ArchxStr %key, 1
  %len.i = and i64 %w0.i, 4294967295
  %short.i = icmp samesign ult i64 %len.i, 13
  br i1 %short.i, label %sso_hash.i, label %long_hash.i

sso_hash.i:                                       ; preds = %entry
  %p0_raw.i = lshr i64 %w0.i, 32
  %le4.i = icmp samesign ult i64 %len.i, 5
  br i1 %le4.i, label %sso_le4.i, label %sso_gt4.i

sso_le4.i:                                        ; preds = %sso_hash.i
  %sh0.i = shl nuw nsw i64 %len.i, 3
  %notmask1.i = shl nsw i64 -1, %sh0.i
  %m0.i = xor i64 %notmask1.i, -1
  %p0_4.i = and i64 %p0_raw.i, %m0.i
  br label %sso_mix.i

sso_gt4.i:                                        ; preds = %sso_hash.i
  %eq12.i = icmp eq i64 %len.i, 12
  br i1 %eq12.i, label %sso_mix.i, label %sso_mid.i

sso_mid.i:                                        ; preds = %sso_gt4.i
  %rem.i = shl nuw nsw i64 %len.i, 3
  %sh1.i = add nsw i64 %rem.i, -32
  %notmask.i = shl nsw i64 -1, %sh1.i
  %m1.i = xor i64 %notmask.i, -1
  %p1_m.i = and i64 %w1.i, %m1.i
  br label %sso_mix.i

sso_mix.i:                                        ; preds = %sso_mid.i, %sso_gt4.i, %sso_le4.i
  %p0.i = phi i64 [ %p0_4.i, %sso_le4.i ], [ %p0_raw.i, %sso_mid.i ], [ %p0_raw.i, %sso_gt4.i ]
  %p1.i = phi i64 [ 0, %sso_le4.i ], [ %p1_m.i, %sso_mid.i ], [ %w1.i, %sso_gt4.i ]
  %a0.i = mul i64 %p0.i, -7046029254386353131
  %a1.i = mul i64 %p1.i, -4417276706812531889
  %ax.i = xor i64 %a1.i, %a0.i
  %s1.i10.i = lshr i64 %ax.i, 30
  %0 = xor i64 %len.i, %s1.i10.i
  %x1.i11.i = xor i64 %0, %ax.i
  br label %archx_hash_str.exit

long_hash.i:                                      ; preds = %entry
  %raw.i = and i64 %w1.i, -4
  %ptr.i = inttoptr i64 %raw.i to ptr
  %seed.i = mul i64 %len.i, -7046029254386353131
  %1 = add nsw i64 %len.i, -8
  %2 = icmp ult i64 %1, 8
  br i1 %2, label %l_tail_cond.i.preheader.unr-lcssa, label %long_hash.i.new

long_hash.i.new:                                  ; preds = %long_hash.i
  %3 = lshr i64 %1, 3
  %4 = add nuw nsw i64 %3, 1
  %unroll_iter = and i64 %4, 4611686018427387902
  br label %l_body.i

l_tail_cond.i.preheader.unr-lcssa:                ; preds = %l_body.i, %long_hash.i
  %acc_next.i.lcssa.ph = phi i64 [ poison, %long_hash.i ], [ %acc_next.i.1, %l_body.i ]
  %idx_next.i.lcssa.ph = phi i64 [ poison, %long_hash.i ], [ %idx_next.i.1, %l_body.i ]
  %acc.i16.unr = phi i64 [ %seed.i, %long_hash.i ], [ %acc_next.i.1, %l_body.i ]
  %idx.i15.unr = phi i64 [ 0, %long_hash.i ], [ %idx_next.i.1, %l_body.i ]
  %5 = and i64 %1, 8
  %lcmp.mod.not.not = icmp eq i64 %5, 0
  br i1 %lcmp.mod.not.not, label %l_body.i.epil, label %l_tail_cond.i.preheader

l_body.i.epil:                                    ; preds = %l_tail_cond.i.preheader.unr-lcssa
  %lp.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %idx.i15.unr
  %lane.i.epil = load i64, ptr %lp.i.epil, align 4
  %lm.i.epil = mul i64 %lane.i.epil, -4417276706812531889
  %lx.i.epil = xor i64 %lm.i.epil, %acc.i16.unr
  %s1.i2.i.epil = lshr i64 %lx.i.epil, 30
  %x1.i3.i.epil = xor i64 %s1.i2.i.epil, %lx.i.epil
  %m1.i4.i.epil = mul i64 %x1.i3.i.epil, -4658895280553007687
  %s2.i5.i.epil = lshr i64 %m1.i4.i.epil, 27
  %x2.i6.i.epil = xor i64 %s2.i5.i.epil, %m1.i4.i.epil
  %m2.i7.i.epil = mul i64 %x2.i6.i.epil, -7723592293110705685
  %s3.i8.i.epil = lshr i64 %m2.i7.i.epil, 31
  %x3.i9.i.epil = xor i64 %s3.i8.i.epil, %m2.i7.i.epil
  %acc_next.i.epil = add i64 %x3.i9.i.epil, %idx.i15.unr
  %idx_next.i.epil = add nuw nsw i64 %idx.i15.unr, 8
  br label %l_tail_cond.i.preheader

l_tail_cond.i.preheader:                          ; preds = %l_tail_cond.i.preheader.unr-lcssa, %l_body.i.epil
  %acc_next.i.lcssa = phi i64 [ %acc_next.i.lcssa.ph, %l_tail_cond.i.preheader.unr-lcssa ], [ %acc_next.i.epil, %l_body.i.epil ]
  %idx_next.i.lcssa = phi i64 [ %idx_next.i.lcssa.ph, %l_tail_cond.i.preheader.unr-lcssa ], [ %idx_next.i.epil, %l_body.i.epil ]
  %tmore.i17 = icmp samesign ult i64 %idx_next.i.lcssa, %len.i
  br i1 %tmore.i17, label %l_tail_body.i.preheader, label %l_done.i

l_tail_body.i.preheader:                          ; preds = %l_tail_cond.i.preheader
  %6 = sub i64 %w0.i, %idx_next.i.lcssa
  %xtraiter54 = and i64 %6, 3
  %lcmp.mod55.not = icmp eq i64 %xtraiter54, 0
  br i1 %lcmp.mod55.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol

l_tail_body.i.prol:                               ; preds = %l_tail_body.i.preheader, %l_tail_body.i.prol
  %tacc.i19.prol = phi i64 [ %tacc_next.i.prol, %l_tail_body.i.prol ], [ %acc_next.i.lcssa, %l_tail_body.i.preheader ]
  %ti.i18.prol = phi i64 [ %ti_next.i.prol, %l_tail_body.i.prol ], [ %idx_next.i.lcssa, %l_tail_body.i.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %l_tail_body.i.prol ], [ 0, %l_tail_body.i.preheader ]
  %tp.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %ti.i18.prol
  %tb.i.prol = load i8, ptr %tp.i.prol, align 1
  %tz.i.prol = zext i8 %tb.i.prol to i64
  %tx.i.prol = xor i64 %tacc.i19.prol, %tz.i.prol
  %tacc_next.i.prol = mul i64 %tx.i.prol, 1099511628211
  %ti_next.i.prol = add nuw nsw i64 %ti.i18.prol, 1
  %prol.iter.next = add i64 %prol.iter, 1
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter54
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol, !llvm.loop !5

l_tail_body.i.prol.loopexit:                      ; preds = %l_tail_body.i.prol, %l_tail_body.i.preheader
  %tacc.i19.unr = phi i64 [ %acc_next.i.lcssa, %l_tail_body.i.preheader ], [ %tacc_next.i.prol, %l_tail_body.i.prol ]
  %ti.i18.unr = phi i64 [ %idx_next.i.lcssa, %l_tail_body.i.preheader ], [ %ti_next.i.prol, %l_tail_body.i.prol ]
  %tacc_next.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.preheader ], [ %tacc_next.i.prol, %l_tail_body.i.prol ]
  %7 = sub i64 %idx_next.i.lcssa, %len.i
  %8 = icmp ugt i64 %7, -4
  br i1 %8, label %l_done.i, label %l_tail_body.i.preheader.new

l_tail_body.i.preheader.new:                      ; preds = %l_tail_body.i.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr.i, i64 1
  %invariant.gep60 = getelementptr i8, ptr %ptr.i, i64 2
  %invariant.gep62 = getelementptr i8, ptr %ptr.i, i64 3
  br label %l_tail_body.i

l_body.i:                                         ; preds = %l_body.i, %long_hash.i.new
  %acc.i16 = phi i64 [ %seed.i, %long_hash.i.new ], [ %acc_next.i.1, %l_body.i ]
  %idx.i15 = phi i64 [ 0, %long_hash.i.new ], [ %idx_next.i.1, %l_body.i ]
  %niter = phi i64 [ 0, %long_hash.i.new ], [ %niter.next.1, %l_body.i ]
  %lp.i = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %idx.i15
  %lane.i = load i64, ptr %lp.i, align 4
  %lm.i = mul i64 %lane.i, -4417276706812531889
  %lx.i = xor i64 %lm.i, %acc.i16
  %s1.i2.i = lshr i64 %lx.i, 30
  %x1.i3.i = xor i64 %s1.i2.i, %lx.i
  %m1.i4.i = mul i64 %x1.i3.i, -4658895280553007687
  %s2.i5.i = lshr i64 %m1.i4.i, 27
  %x2.i6.i = xor i64 %s2.i5.i, %m1.i4.i
  %m2.i7.i = mul i64 %x2.i6.i, -7723592293110705685
  %s3.i8.i = lshr i64 %m2.i7.i, 31
  %x3.i9.i = xor i64 %s3.i8.i, %m2.i7.i
  %acc_next.i = add i64 %x3.i9.i, %idx.i15
  %idx_next.i = or disjoint i64 %idx.i15, 8
  %lp.i.1 = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %idx_next.i
  %lane.i.1 = load i64, ptr %lp.i.1, align 4
  %lm.i.1 = mul i64 %lane.i.1, -4417276706812531889
  %lx.i.1 = xor i64 %lm.i.1, %acc_next.i
  %s1.i2.i.1 = lshr i64 %lx.i.1, 30
  %x1.i3.i.1 = xor i64 %s1.i2.i.1, %lx.i.1
  %m1.i4.i.1 = mul i64 %x1.i3.i.1, -4658895280553007687
  %s2.i5.i.1 = lshr i64 %m1.i4.i.1, 27
  %x2.i6.i.1 = xor i64 %s2.i5.i.1, %m1.i4.i.1
  %m2.i7.i.1 = mul i64 %x2.i6.i.1, -7723592293110705685
  %s3.i8.i.1 = lshr i64 %m2.i7.i.1, 31
  %x3.i9.i.1 = xor i64 %s3.i8.i.1, %m2.i7.i.1
  %acc_next.i.1 = add i64 %x3.i9.i.1, %idx_next.i
  %idx_next.i.1 = add nuw nsw i64 %idx.i15, 16
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1.not = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1.not, label %l_tail_cond.i.preheader.unr-lcssa, label %l_body.i

l_tail_body.i:                                    ; preds = %l_tail_body.i, %l_tail_body.i.preheader.new
  %tacc.i19 = phi i64 [ %tacc.i19.unr, %l_tail_body.i.preheader.new ], [ %tacc_next.i.3, %l_tail_body.i ]
  %ti.i18 = phi i64 [ %ti.i18.unr, %l_tail_body.i.preheader.new ], [ %ti_next.i.3, %l_tail_body.i ]
  %tp.i = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %ti.i18
  %tb.i = load i8, ptr %tp.i, align 1
  %tz.i = zext i8 %tb.i to i64
  %tx.i = xor i64 %tacc.i19, %tz.i
  %tacc_next.i = mul i64 %tx.i, 1099511628211
  %gep = getelementptr i8, ptr %invariant.gep, i64 %ti.i18
  %tb.i.1 = load i8, ptr %gep, align 1
  %tz.i.1 = zext i8 %tb.i.1 to i64
  %tx.i.1 = xor i64 %tacc_next.i, %tz.i.1
  %tacc_next.i.1 = mul i64 %tx.i.1, 1099511628211
  %gep61 = getelementptr i8, ptr %invariant.gep60, i64 %ti.i18
  %tb.i.2 = load i8, ptr %gep61, align 1
  %tz.i.2 = zext i8 %tb.i.2 to i64
  %tx.i.2 = xor i64 %tacc_next.i.1, %tz.i.2
  %tacc_next.i.2 = mul i64 %tx.i.2, 1099511628211
  %gep63 = getelementptr i8, ptr %invariant.gep62, i64 %ti.i18
  %tb.i.3 = load i8, ptr %gep63, align 1
  %tz.i.3 = zext i8 %tb.i.3 to i64
  %tx.i.3 = xor i64 %tacc_next.i.2, %tz.i.3
  %tacc_next.i.3 = mul i64 %tx.i.3, 1099511628211
  %ti_next.i.3 = add nuw nsw i64 %ti.i18, 4
  %tmore.i.3 = icmp samesign ult i64 %ti_next.i.3, %len.i
  br i1 %tmore.i.3, label %l_tail_body.i, label %l_done.i

l_done.i:                                         ; preds = %l_tail_body.i.prol.loopexit, %l_tail_body.i, %l_tail_cond.i.preheader
  %tacc.i.lcssa = phi i64 [ %acc_next.i.lcssa, %l_tail_cond.i.preheader ], [ %tacc_next.i.lcssa.unr, %l_tail_body.i.prol.loopexit ], [ %tacc_next.i.3, %l_tail_body.i ]
  %s1.i.i = lshr i64 %tacc.i.lcssa, 30
  %x1.i.i = xor i64 %s1.i.i, %tacc.i.lcssa
  br label %archx_hash_str.exit

archx_hash_str.exit:                              ; preds = %sso_mix.i, %l_done.i
  %x1.i11.i.sink = phi i64 [ %x1.i11.i, %sso_mix.i ], [ %x1.i.i, %l_done.i ]
  %m1.i12.i = mul i64 %x1.i11.i.sink, -4658895280553007687
  %s2.i13.i = lshr i64 %m1.i12.i, 27
  %x2.i14.i = xor i64 %s2.i13.i, %m1.i12.i
  %m2.i15.i = mul i64 %x2.i14.i, -7723592293110705685
  %s3.i16.i = lshr i64 %m2.i15.i, 31
  %x3.i17.i = xor i64 %s3.i16.i, %m2.i15.i
  %raw = and i64 %d, -4
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds nuw i8, ptr %hdr, i64 32
  %ctrl0 = load ptr, ptr %ctrl_p, align 8
  %uninit = icmp eq ptr %ctrl0, null
  br i1 %uninit, label %probe_insert_init, label %chk_probe_existing

chk_probe_existing:                               ; preds = %archx_hash_str.exit
  %is_z.i = icmp eq i64 %raw, 0
  br i1 %is_z.i, label %archx_dict_find_h_str.exit, label %do_probe.i

do_probe.i:                                       ; preds = %chk_probe_existing
  %mask_p.i = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %keys_p.i = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %mask.i = load i64, ptr %mask_p.i, align 8
  %keys.i = load ptr, ptr %keys_p.i, align 8
  %9 = getelementptr i8, ptr %ctrl0, i64 %mask.i
  %idx_base.i = getelementptr i8, ptr %9, i64 17
  %h2_64.i = lshr i64 %m2.i15.i, 57
  %h2.i = trunc nuw nsw i64 %h2_64.i to i8
  %h2_ins.i = insertelement <16 x i8> poison, i8 %h2.i, i64 0
  %h2_vec.i = shufflevector <16 x i8> %h2_ins.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bp_i.i.i = and i64 %w1.i, -4
  %bp.i.i = inttoptr i64 %bp_i.i.i to ptr
  %bp4.i.i = getelementptr inbounds nuw i8, ptr %bp.i.i, i64 4
  %rem.i.i = add nsw i64 %len.i, -4
  br label %probe.i

probe.i:                                          ; preds = %next_grp.i, %do_probe.i
  %h.pn.i = phi i64 [ %x3.i17.i, %do_probe.i ], [ %padd.i, %next_grp.i ]
  %step.i = phi i64 [ 0, %do_probe.i ], [ %step_next.i, %next_grp.i ]
  %avail.i = phi i64 [ -1, %do_probe.i ], [ %avail_cur.i, %next_grp.i ]
  %pos.i = and i64 %h.pn.i, %mask.i
  %gp.i = getelementptr inbounds i8, ptr %ctrl0, i64 %pos.i
  %grp.i = load <16 x i8>, ptr %gp.i, align 1
  %mcmp.i = icmp eq <16 x i8> %grp.i, %h2_vec.i
  %mbits.i = bitcast <16 x i1> %mcmp.i to i16
  %has_m.not.i20 = icmp eq i16 %mbits.i, 0
  br i1 %has_m.not.i20, label %chk_empty.i, label %chk_key.i.preheader

chk_key.i.preheader:                              ; preds = %probe.i
  %mmask0.i = zext i16 %mbits.i to i32
  br label %chk_key.i

chk_key.i:                                        ; preds = %chk_key.i.preheader, %mbit_cont.i
  %mmask.i21 = phi i32 [ %mmask_next.i, %mbit_cont.i ], [ %mmask0.i, %chk_key.i.preheader ]
  %tz.i6 = tail call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i21, i1 true)
  %tz64.i = zext nneg i32 %tz.i6 to i64
  %s_add.i = add i64 %pos.i, %tz64.i
  %slot.i = and i64 %s_add.i, %mask.i
  %ip.i = getelementptr inbounds i32, ptr %idx_base.i, i64 %slot.i
  %didx32.i = load i32, ptr %ip.i, align 4
  %didx.i = zext i32 %didx32.i to i64
  %kp.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i, i64 %didx.i
  %cand_k.unpack.i = load i64, ptr %kp.i, align 8
  %cand_k.elt1.i = getelementptr inbounds nuw i8, ptr %kp.i, i64 8
  %cand_k.unpack2.i = load i64, ptr %cand_k.elt1.i, align 8
  %w0_eq.i.i = icmp eq i64 %cand_k.unpack.i, %w0.i
  br i1 %w0_eq.i.i, label %chk_len.i.i, label %mbit_cont.i

chk_len.i.i:                                      ; preds = %chk_key.i
  br i1 %short.i, label %cmp_short.i.i, label %cmp_long.i.i

cmp_short.i.i:                                    ; preds = %chk_len.i.i
  %eq_s.i.i = icmp eq i64 %cand_k.unpack2.i, %w1.i
  br i1 %eq_s.i.i, label %found.i, label %mbit_cont.i

cmp_long.i.i:                                     ; preds = %chk_len.i.i
  %ap_i.i.i = and i64 %cand_k.unpack2.i, -4
  %same_ptr.i.i = icmp eq i64 %ap_i.i.i, %bp_i.i.i
  br i1 %same_ptr.i.i, label %found.i, label %archx_str_eq.exit.i

archx_str_eq.exit.i:                              ; preds = %cmp_long.i.i
  %ap.i.i = inttoptr i64 %ap_i.i.i to ptr
  %ap4.i.i = getelementptr inbounds nuw i8, ptr %ap.i.i, i64 4
  %bcmp.i.i = tail call i32 @bcmp(ptr nonnull %ap4.i.i, ptr nonnull %bp4.i.i, i64 %rem.i.i)
  %eq_m.i.i = icmp eq i32 %bcmp.i.i, 0
  br i1 %eq_m.i.i, label %found.i, label %mbit_cont.i

mbit_cont.i:                                      ; preds = %chk_key.i, %cmp_short.i.i, %archx_str_eq.exit.i
  %mm1.i = add nsw i32 %mmask.i21, -1
  %mmask_next.i = and i32 %mm1.i, %mmask.i21
  %has_m.not.i = icmp eq i32 %mmask_next.i, 0
  br i1 %has_m.not.i, label %chk_empty.i, label %chk_key.i

chk_empty.i:                                      ; preds = %mbit_cont.i, %probe.i
  %need_a.i = icmp slt i64 %avail.i, 0
  br i1 %need_a.i, label %find_a.i, label %after_a.i

find_a.i:                                         ; preds = %chk_empty.i
  %acmp.i = icmp slt <16 x i8> %grp.i, zeroinitializer
  %abits16.i = bitcast <16 x i1> %acmp.i to i16
  %has_a0.not.i = icmp eq i16 %abits16.i, 0
  br i1 %has_a0.not.i, label %after_a.i, label %set_a.i

set_a.i:                                          ; preds = %find_a.i
  %10 = tail call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i, i1 true)
  %atz64.i = zext nneg i16 %10 to i64
  %as_add.i = add i64 %pos.i, %atz64.i
  %aslot.i = and i64 %as_add.i, %mask.i
  br label %after_a.i

after_a.i:                                        ; preds = %set_a.i, %find_a.i, %chk_empty.i
  %avail_cur.i = phi i64 [ %avail.i, %chk_empty.i ], [ -1, %find_a.i ], [ %aslot.i, %set_a.i ]
  %ecmp.i = icmp eq <16 x i8> %grp.i, splat (i8 -128)
  %ebits.i = bitcast <16 x i1> %ecmp.i to i16
  %has_e.not.i = icmp eq i16 %ebits.i, 0
  br i1 %has_e.not.i, label %next_grp.i, label %not_found_avail.i

next_grp.i:                                       ; preds = %after_a.i
  %step_next.i = add i64 %step.i, 16
  %padd.i = add i64 %step_next.i, %pos.i
  br label %probe.i

found.i:                                          ; preds = %cmp_long.i.i, %cmp_short.i.i, %archx_str_eq.exit.i
  %f0.i = insertvalue { i64, i64 } poison, i64 %didx.i, 0
  %f1.i = insertvalue { i64, i64 } %f0.i, i64 %slot.i, 1
  br label %archx_dict_find_h_str.exit

not_found_avail.i:                                ; preds = %after_a.i
  %nf1.i = insertvalue { i64, i64 } { i64 -1, i64 poison }, i64 %avail_cur.i, 1
  br label %archx_dict_find_h_str.exit

archx_dict_find_h_str.exit:                       ; preds = %chk_probe_existing, %found.i, %not_found_avail.i
  %common.ret.op.i7 = phi { i64, i64 } [ %f1.i, %found.i ], [ %nf1.i, %not_found_avail.i ], [ { i64 -1, i64 -1 }, %chk_probe_existing ]
  %found_idx = extractvalue { i64, i64 } %common.ret.op.i7, 0
  %avail_slot = extractvalue { i64, i64 } %common.ret.op.i7, 1
  %exists = icmp sgt i64 %found_idx, -1
  br i1 %exists, label %common.ret, label %chk_cap

common.ret:                                       ; preds = %archx_dict_find_h_str.exit, %archx_str_clone.exit
  %found_idx.pn = phi i64 [ %d_idx, %archx_str_clone.exit ], [ %found_idx, %archx_dict_find_h_str.exit ]
  %.pn3 = phi i1 [ false, %archx_str_clone.exit ], [ true, %archx_dict_find_h_str.exit ]
  %re0.pn = insertvalue { i64, i1 } poison, i64 %found_idx.pn, 0
  %common.ret.op = insertvalue { i64, i1 } %re0.pn, i1 %.pn3, 1
  ret { i64, i1 } %common.ret.op

chk_cap:                                          ; preds = %archx_dict_find_h_str.exit
  %used_p = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %used0 = load i64, ptr %used_p, align 8
  %mask0 = load i64, ptr %mask_p, align 8
  %scap0 = add i64 %mask0, 1
  %u1 = shl i64 %used0, 3
  %lhs = add i64 %u1, 8
  %rhs = mul i64 %scap0, 7
  %full = icmp sgt i64 %lhs, %rhs
  br i1 %full, label %probe_insert_init, label %fast_insert_prep

fast_insert_prep:                                 ; preds = %chk_cap
  %keys_pf = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %keys_f = load ptr, ptr %keys_pf, align 8
  %11 = getelementptr i8, ptr %ctrl0, i64 %mask0
  br label %iput_commit

probe_insert_init:                                ; preds = %chk_cap, %archx_hash_str.exit
  tail call fastcc void @archx_dict_grow(ptr nonnull %hdr)
  %used_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %keys_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %mask = load i64, ptr %mask_p2, align 8
  %keys = load ptr, ptr %keys_p2, align 8
  %scap = add i64 %mask, 1
  %12 = getelementptr i8, ptr %ctrl, i64 %mask
  %pos22 = and i64 %x3.i17.i, %mask
  %gp23 = getelementptr inbounds i8, ptr %ctrl, i64 %pos22
  %grp24 = load <16 x i8>, ptr %gp23, align 1
  %avail_cmp25 = icmp slt <16 x i8> %grp24, zeroinitializer
  %abits26 = bitcast <16 x i1> %avail_cmp25 to i16
  %has_a.not27 = icmp eq i16 %abits26, 0
  br i1 %has_a.not27, label %inext, label %iput

inext:                                            ; preds = %probe_insert_init, %inext
  %pos29 = phi i64 [ %pos, %inext ], [ %pos22, %probe_insert_init ]
  %step28 = phi i64 [ %step_next, %inext ], [ 0, %probe_insert_init ]
  %step_next = add i64 %step28, 16
  %padd = add i64 %step_next, %pos29
  %pos = and i64 %padd, %mask
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %avail_cmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits = bitcast <16 x i1> %avail_cmp to i16
  %has_a.not = icmp eq i16 %abits, 0
  br i1 %has_a.not, label %inext, label %iput

iput:                                             ; preds = %inext, %probe_insert_init
  %pos.lcssa = phi i64 [ %pos22, %probe_insert_init ], [ %pos, %inext ]
  %abits.lcssa = phi i16 [ %abits26, %probe_insert_init ], [ %abits, %inext ]
  %13 = tail call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits.lcssa, i1 true)
  %tz64 = zext nneg i16 %13 to i64
  %s_add = add i64 %pos.lcssa, %tz64
  %slot_g = and i64 %s_add, %mask
  %u_cur.pre = load i64, ptr %used_p2, align 8
  br label %iput_commit

iput_commit:                                      ; preds = %iput, %fast_insert_prep
  %u_cur = phi i64 [ %used0, %fast_insert_prep ], [ %u_cur.pre, %iput ]
  %slot = phi i64 [ %avail_slot, %fast_insert_prep ], [ %slot_g, %iput ]
  %ctrl_c = phi ptr [ %ctrl0, %fast_insert_prep ], [ %ctrl, %iput ]
  %scap_c = phi i64 [ %scap0, %fast_insert_prep ], [ %scap, %iput ]
  %.pn = phi ptr [ %11, %fast_insert_prep ], [ %12, %iput ]
  %keys_c = phi ptr [ %keys_f, %fast_insert_prep ], [ %keys, %iput ]
  %used_pc = phi ptr [ %used_p, %fast_insert_prep ], [ %used_p2, %iput ]
  %h2_c.in = lshr i64 %m2.i15.i, 57
  %h2_c = trunc nuw nsw i64 %h2_c.in to i8
  %idx_base_c = getelementptr i8, ptr %.pn, i64 17
  %sp_c = getelementptr inbounds i8, ptr %ctrl_c, i64 %slot
  %old_cb = load i8, ptr %sp_c, align 1
  %was_empty = icmp eq i8 %old_cb, -128
  %u_inc = zext i1 %was_empty to i64
  %u_new = add i64 %u_cur, %u_inc
  store i64 %u_new, ptr %used_pc, align 8
  store i8 %h2_c, ptr %sp_c, align 1
  %mir.i = icmp ult i64 %slot, 16
  br i1 %mir.i, label %do_mir.i, label %archx_dict_set_ctrl.exit

do_mir.i:                                         ; preds = %iput_commit
  %14 = getelementptr i8, ptr %ctrl_c, i64 %scap_c
  %mp.i = getelementptr i8, ptr %14, i64 %slot
  store i8 %h2_c, ptr %mp.i, align 1
  br label %archx_dict_set_ctrl.exit

archx_dict_set_ctrl.exit:                         ; preds = %iput_commit, %do_mir.i
  %d_idx = load i64, ptr %hdr, align 8
  %d_new = add i64 %d_idx, 1
  store i64 %d_new, ptr %hdr, align 8
  %ip = getelementptr inbounds i32, ptr %idx_base_c, i64 %slot
  %d_idx32 = trunc i64 %d_idx to i32
  store i32 %d_idx32, ptr %ip, align 4
  %tag.i = and i64 %w1.i, 3
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %short.i, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %archx_str_clone.exit, label %dup_heap.i

dup_heap.i:                                       ; preds = %archx_dict_set_ctrl.exit
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %len.i)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i, label %copy.i

oom.i:                                            ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %w1.i, -4
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 4 %src.i, i64 %len.i, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %.pre = extractvalue %ArchxStr %key, 0
  br label %archx_str_clone.exit

archx_str_clone.exit:                             ; preds = %archx_dict_set_ctrl.exit, %copy.i
  %stored_k.elt2.pre-phi = phi i64 [ %w1.i, %archx_dict_set_ctrl.exit ], [ %tagged.i, %copy.i ]
  %stored_k.elt.pre-phi = phi i64 [ %w0.i, %archx_dict_set_ctrl.exit ], [ %.pre, %copy.i ]
  %kp = getelementptr inbounds %ArchxStr, ptr %keys_c, i64 %d_idx
  store i64 %stored_k.elt.pre-phi, ptr %kp, align 8
  %kp.repack1 = getelementptr inbounds nuw i8, ptr %kp, i64 8
  store i64 %stored_k.elt2.pre-phi, ptr %kp.repack1, align 8
  br label %common.ret
}

; Function Attrs: nofree nounwind
define private fastcc { i64, i64 } @archx_dict_find_h_any(i64 %d, %ArchxAny %key, i64 %h) unnamed_addr #4 {
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
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc nuw nsw i64 %h2_64 to i8
  %h2_ins = insertelement <16 x i8> poison, i8 %h2, i64 0
  %h2_vec = shufflevector <16 x i8> %h2_ins, <16 x i8> poison, <16 x i32> zeroinitializer
  br label %probe

probe:                                            ; preds = %next_grp, %do_probe
  %h.pn = phi i64 [ %h, %do_probe ], [ %padd, %next_grp ]
  %step = phi i64 [ 0, %do_probe ], [ %step_next, %next_grp ]
  %avail = phi i64 [ -1, %do_probe ], [ %avail_cur, %next_grp ]
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
  br i1 %eq, label %found, label %mbit_cont

mbit_cont:                                        ; preds = %chk_key
  %mm1 = add nsw i32 %mmask7, -1
  %mmask_next = and i32 %mm1, %mmask7
  %has_m.not = icmp eq i32 %mmask_next, 0
  br i1 %has_m.not, label %chk_empty, label %chk_key

chk_empty:                                        ; preds = %mbit_cont, %probe
  %need_a = icmp slt i64 %avail, 0
  br i1 %need_a, label %find_a, label %after_a

find_a:                                           ; preds = %chk_empty
  %acmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits16 = bitcast <16 x i1> %acmp to i16
  %has_a0.not = icmp eq i16 %abits16, 0
  br i1 %has_a0.not, label %after_a, label %set_a

set_a:                                            ; preds = %find_a
  %3 = tail call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16, i1 true)
  %atz64 = zext nneg i16 %3 to i64
  %as_add = add i64 %pos, %atz64
  %aslot = and i64 %as_add, %mask
  br label %after_a

after_a:                                          ; preds = %set_a, %find_a, %chk_empty
  %avail_cur = phi i64 [ %avail, %chk_empty ], [ -1, %find_a ], [ %aslot, %set_a ]
  %ecmp = icmp eq <16 x i8> %grp, splat (i8 -128)
  %ebits = bitcast <16 x i1> %ecmp to i16
  %has_e.not = icmp eq i16 %ebits, 0
  br i1 %has_e.not, label %next_grp, label %not_found_avail

next_grp:                                         ; preds = %after_a
  %step_next = add i64 %step, 16
  %padd = add i64 %step_next, %pos
  br label %probe

common.ret:                                       ; preds = %entry, %chk_ctrl, %not_found_avail, %found
  %common.ret.op = phi { i64, i64 } [ %f1, %found ], [ %nf1, %not_found_avail ], [ { i64 -1, i64 -1 }, %chk_ctrl ], [ { i64 -1, i64 -1 }, %entry ]
  ret { i64, i64 } %common.ret.op

found:                                            ; preds = %chk_key
  %f0 = insertvalue { i64, i64 } poison, i64 %didx, 0
  %f1 = insertvalue { i64, i64 } %f0, i64 %slot, 1
  br label %common.ret

not_found_avail:                                  ; preds = %after_a
  %nf1 = insertvalue { i64, i64 } { i64 -1, i64 poison }, i64 %avail_cur, 1
  br label %common.ret
}

; Function Attrs: nounwind
define private fastcc i64 @archx_dict_upsert_any(i64 range(i64 1, 0) %d, %ArchxAny %key) unnamed_addr #0 {
entry:
  %h = tail call fastcc i64 @archx_any_hash(%ArchxAny %key)
  %raw = and i64 %d, -4
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds nuw i8, ptr %hdr, i64 32
  %ctrl0 = load ptr, ptr %ctrl_p, align 8
  %uninit = icmp eq ptr %ctrl0, null
  br i1 %uninit, label %probe_insert_init, label %chk_probe_existing

chk_probe_existing:                               ; preds = %entry
  %found_pair = tail call fastcc { i64, i64 } @archx_dict_find_h_any(i64 %d, %ArchxAny %key, i64 %h)
  %found_idx = extractvalue { i64, i64 } %found_pair, 0
  %avail_slot = extractvalue { i64, i64 } %found_pair, 1
  %exists = icmp sgt i64 %found_idx, -1
  br i1 %exists, label %common.ret, label %chk_cap

common.ret:                                       ; preds = %chk_probe_existing, %archx_dict_set_ctrl.exit
  %found_idx.pn = phi i64 [ %d_idx, %archx_dict_set_ctrl.exit ], [ %found_idx, %chk_probe_existing ]
  ret i64 %found_idx.pn

chk_cap:                                          ; preds = %chk_probe_existing
  %used_p = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %used0 = load i64, ptr %used_p, align 8
  %mask0 = load i64, ptr %mask_p, align 8
  %scap0 = add i64 %mask0, 1
  %u1 = shl i64 %used0, 3
  %lhs = add i64 %u1, 8
  %rhs = mul i64 %scap0, 7
  %full = icmp sgt i64 %lhs, %rhs
  br i1 %full, label %probe_insert_init, label %fast_insert_prep

fast_insert_prep:                                 ; preds = %chk_cap
  %keys_pf = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %keys_f = load ptr, ptr %keys_pf, align 8
  %0 = getelementptr i8, ptr %ctrl0, i64 %mask0
  br label %iput_commit

probe_insert_init:                                ; preds = %chk_cap, %entry
  tail call fastcc void @archx_dict_grow(ptr nonnull %hdr)
  %used_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 8
  %mask_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 16
  %keys_p2 = getelementptr inbounds nuw i8, ptr %hdr, i64 40
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %mask = load i64, ptr %mask_p2, align 8
  %keys = load ptr, ptr %keys_p2, align 8
  %scap = add i64 %mask, 1
  %1 = getelementptr i8, ptr %ctrl, i64 %mask
  %pos7 = and i64 %h, %mask
  %gp8 = getelementptr inbounds i8, ptr %ctrl, i64 %pos7
  %grp9 = load <16 x i8>, ptr %gp8, align 1
  %avail_cmp10 = icmp slt <16 x i8> %grp9, zeroinitializer
  %abits11 = bitcast <16 x i1> %avail_cmp10 to i16
  %has_a.not12 = icmp eq i16 %abits11, 0
  br i1 %has_a.not12, label %inext, label %iput

inext:                                            ; preds = %probe_insert_init, %inext
  %pos14 = phi i64 [ %pos, %inext ], [ %pos7, %probe_insert_init ]
  %step13 = phi i64 [ %step_next, %inext ], [ 0, %probe_insert_init ]
  %step_next = add i64 %step13, 16
  %padd = add i64 %step_next, %pos14
  %pos = and i64 %padd, %mask
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %avail_cmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits = bitcast <16 x i1> %avail_cmp to i16
  %has_a.not = icmp eq i16 %abits, 0
  br i1 %has_a.not, label %inext, label %iput

iput:                                             ; preds = %inext, %probe_insert_init
  %pos.lcssa = phi i64 [ %pos7, %probe_insert_init ], [ %pos, %inext ]
  %abits.lcssa = phi i16 [ %abits11, %probe_insert_init ], [ %abits, %inext ]
  %2 = tail call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits.lcssa, i1 true)
  %tz64 = zext nneg i16 %2 to i64
  %s_add = add i64 %pos.lcssa, %tz64
  %slot_g = and i64 %s_add, %mask
  %u_cur.pre = load i64, ptr %used_p2, align 8
  br label %iput_commit

iput_commit:                                      ; preds = %iput, %fast_insert_prep
  %u_cur = phi i64 [ %used0, %fast_insert_prep ], [ %u_cur.pre, %iput ]
  %slot = phi i64 [ %avail_slot, %fast_insert_prep ], [ %slot_g, %iput ]
  %ctrl_c = phi ptr [ %ctrl0, %fast_insert_prep ], [ %ctrl, %iput ]
  %scap_c = phi i64 [ %scap0, %fast_insert_prep ], [ %scap, %iput ]
  %.pn = phi ptr [ %0, %fast_insert_prep ], [ %1, %iput ]
  %keys_c = phi ptr [ %keys_f, %fast_insert_prep ], [ %keys, %iput ]
  %used_pc = phi ptr [ %used_p, %fast_insert_prep ], [ %used_p2, %iput ]
  %h2_c.in = lshr i64 %h, 57
  %h2_c = trunc nuw nsw i64 %h2_c.in to i8
  %idx_base_c = getelementptr i8, ptr %.pn, i64 17
  %sp_c = getelementptr inbounds i8, ptr %ctrl_c, i64 %slot
  %old_cb = load i8, ptr %sp_c, align 1
  %was_empty = icmp eq i8 %old_cb, -128
  %u_inc = zext i1 %was_empty to i64
  %u_new = add i64 %u_cur, %u_inc
  store i64 %u_new, ptr %used_pc, align 8
  store i8 %h2_c, ptr %sp_c, align 1
  %mir.i = icmp ult i64 %slot, 16
  br i1 %mir.i, label %do_mir.i, label %archx_dict_set_ctrl.exit

do_mir.i:                                         ; preds = %iput_commit
  %3 = getelementptr i8, ptr %ctrl_c, i64 %scap_c
  %mp.i = getelementptr i8, ptr %3, i64 %slot
  store i8 %h2_c, ptr %mp.i, align 1
  br label %archx_dict_set_ctrl.exit

archx_dict_set_ctrl.exit:                         ; preds = %iput_commit, %do_mir.i
  %d_idx = load i64, ptr %hdr, align 8
  %d_new = add i64 %d_idx, 1
  store i64 %d_new, ptr %hdr, align 8
  %ip = getelementptr inbounds i32, ptr %idx_base_c, i64 %slot
  %d_idx32 = trunc i64 %d_idx to i32
  store i32 %d_idx32, ptr %ip, align 4
  %stored_k = tail call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %key)
  %newret = extractvalue { i64, i64, i64 } %stored_k, 0
  %newret2 = extractvalue { i64, i64, i64 } %stored_k, 1
  %newret4 = extractvalue { i64, i64, i64 } %stored_k, 2
  %kp = getelementptr inbounds %ArchxAny, ptr %keys_c, i64 %d_idx
  store i64 %newret, ptr %kp, align 8
  %kp.repack1 = getelementptr inbounds nuw i8, ptr %kp, i64 8
  store i64 %newret2, ptr %kp.repack1, align 8
  %kp.repack3 = getelementptr inbounds nuw i8, ptr %kp, i64 16
  store i64 %newret4, ptr %kp.repack3, align 8
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
define private fastcc i64 @archx_any_hash(%ArchxAny %v) unnamed_addr #4 {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %is0 = icmp eq i64 %tag, 0
  br i1 %is0, label %common.ret, label %chk_int

common.ret:                                       ; preds = %l_done.i, %sso_mix.i, %entry, %h_flt, %h_i64
  %common.ret.op = phi i64 [ %x3.i8, %h_i64 ], [ %x3.i, %h_flt ], [ 5871781006564002453, %entry ], [ %x3.i17.i, %sso_mix.i ], [ %x3.i.i, %l_done.i ]
  ret i64 %common.ret.op

chk_int:                                          ; preds = %entry
  %le2 = icmp ult i64 %tag, 3
  br i1 %le2, label %h_i64, label %chk_flt

h_i64:                                            ; preds = %chk_int
  %s1.i1 = lshr i64 %w1, 30
  %x1.i2 = xor i64 %s1.i1, %w1
  %m1.i3 = mul i64 %x1.i2, -4658895280553007687
  %s2.i4 = lshr i64 %m1.i3, 27
  %x2.i5 = xor i64 %s2.i4, %m1.i3
  %m2.i6 = mul i64 %x2.i5, -7723592293110705685
  %s3.i7 = lshr i64 %m2.i6, 31
  %x3.i8 = xor i64 %s3.i7, %m2.i6
  br label %common.ret

chk_flt:                                          ; preds = %chk_int
  switch i64 %tag, label %unhash [
    i64 3, label %h_flt
    i64 4, label %h_str
  ]

h_flt:                                            ; preds = %chk_flt
  %fv = bitcast i64 %w1 to double
  %iv = tail call i64 @llvm.fptosi.sat.i64.f64(double %fv)
  %back = sitofp i64 %iv to double
  %exact = fcmp oeq double %fv, %back
  %hkey = select i1 %exact, i64 %iv, i64 %w1
  %s1.i = lshr i64 %hkey, 30
  %x1.i = xor i64 %s1.i, %hkey
  %m1.i = mul i64 %x1.i, -4658895280553007687
  %s2.i = lshr i64 %m1.i, 27
  %x2.i = xor i64 %s2.i, %m1.i
  %m2.i = mul i64 %x2.i, -7723592293110705685
  %s3.i = lshr i64 %m2.i, 31
  %x3.i = xor i64 %s3.i, %m2.i
  br label %common.ret

h_str:                                            ; preds = %chk_flt
  %w2 = extractvalue %ArchxAny %v, 2
  %len.i = and i64 %w1, 4294967295
  %short.i = icmp samesign ult i64 %len.i, 13
  br i1 %short.i, label %sso_hash.i, label %long_hash.i

sso_hash.i:                                       ; preds = %h_str
  %p0_raw.i = lshr i64 %w1, 32
  %le4.i = icmp samesign ult i64 %len.i, 5
  br i1 %le4.i, label %sso_le4.i, label %sso_gt4.i

sso_le4.i:                                        ; preds = %sso_hash.i
  %sh0.i = shl nuw nsw i64 %len.i, 3
  %notmask1.i = shl nsw i64 -1, %sh0.i
  %m0.i = xor i64 %notmask1.i, -1
  %p0_4.i = and i64 %p0_raw.i, %m0.i
  br label %sso_mix.i

sso_gt4.i:                                        ; preds = %sso_hash.i
  %eq12.i = icmp eq i64 %len.i, 12
  br i1 %eq12.i, label %sso_mix.i, label %sso_mid.i

sso_mid.i:                                        ; preds = %sso_gt4.i
  %rem.i = shl nuw nsw i64 %len.i, 3
  %sh1.i = add nsw i64 %rem.i, -32
  %notmask.i = shl nsw i64 -1, %sh1.i
  %m1.i9 = xor i64 %notmask.i, -1
  %p1_m.i = and i64 %w2, %m1.i9
  br label %sso_mix.i

sso_mix.i:                                        ; preds = %sso_mid.i, %sso_gt4.i, %sso_le4.i
  %p0.i = phi i64 [ %p0_4.i, %sso_le4.i ], [ %p0_raw.i, %sso_mid.i ], [ %p0_raw.i, %sso_gt4.i ]
  %p1.i = phi i64 [ 0, %sso_le4.i ], [ %p1_m.i, %sso_mid.i ], [ %w2, %sso_gt4.i ]
  %a0.i = mul i64 %p0.i, -7046029254386353131
  %a1.i = mul i64 %p1.i, -4417276706812531889
  %ax.i = xor i64 %a1.i, %a0.i
  %s1.i10.i = lshr i64 %ax.i, 30
  %0 = xor i64 %len.i, %s1.i10.i
  %x1.i11.i = xor i64 %0, %ax.i
  %m1.i12.i = mul i64 %x1.i11.i, -4658895280553007687
  %s2.i13.i = lshr i64 %m1.i12.i, 27
  %x2.i14.i = xor i64 %s2.i13.i, %m1.i12.i
  %m2.i15.i = mul i64 %x2.i14.i, -7723592293110705685
  %s3.i16.i = lshr i64 %m2.i15.i, 31
  %x3.i17.i = xor i64 %s3.i16.i, %m2.i15.i
  br label %common.ret

long_hash.i:                                      ; preds = %h_str
  %raw.i = and i64 %w2, -4
  %ptr.i = inttoptr i64 %raw.i to ptr
  %seed.i = mul i64 %len.i, -7046029254386353131
  %1 = add nsw i64 %len.i, -8
  %2 = icmp ult i64 %1, 8
  br i1 %2, label %l_tail_cond.i.preheader.unr-lcssa, label %long_hash.i.new

long_hash.i.new:                                  ; preds = %long_hash.i
  %3 = lshr i64 %1, 3
  %4 = add nuw nsw i64 %3, 1
  %unroll_iter = and i64 %4, 4611686018427387902
  br label %l_body.i

l_tail_cond.i.preheader.unr-lcssa:                ; preds = %l_body.i, %long_hash.i
  %acc_next.i.lcssa.ph = phi i64 [ poison, %long_hash.i ], [ %acc_next.i.1, %l_body.i ]
  %idx_next.i.lcssa.ph = phi i64 [ poison, %long_hash.i ], [ %idx_next.i.1, %l_body.i ]
  %acc.i11.unr = phi i64 [ %seed.i, %long_hash.i ], [ %acc_next.i.1, %l_body.i ]
  %idx.i10.unr = phi i64 [ 0, %long_hash.i ], [ %idx_next.i.1, %l_body.i ]
  %5 = and i64 %1, 8
  %lcmp.mod.not.not = icmp eq i64 %5, 0
  br i1 %lcmp.mod.not.not, label %l_body.i.epil, label %l_tail_cond.i.preheader

l_body.i.epil:                                    ; preds = %l_tail_cond.i.preheader.unr-lcssa
  %lp.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %idx.i10.unr
  %lane.i.epil = load i64, ptr %lp.i.epil, align 4
  %lm.i.epil = mul i64 %lane.i.epil, -4417276706812531889
  %lx.i.epil = xor i64 %lm.i.epil, %acc.i11.unr
  %s1.i2.i.epil = lshr i64 %lx.i.epil, 30
  %x1.i3.i.epil = xor i64 %s1.i2.i.epil, %lx.i.epil
  %m1.i4.i.epil = mul i64 %x1.i3.i.epil, -4658895280553007687
  %s2.i5.i.epil = lshr i64 %m1.i4.i.epil, 27
  %x2.i6.i.epil = xor i64 %s2.i5.i.epil, %m1.i4.i.epil
  %m2.i7.i.epil = mul i64 %x2.i6.i.epil, -7723592293110705685
  %s3.i8.i.epil = lshr i64 %m2.i7.i.epil, 31
  %x3.i9.i.epil = xor i64 %s3.i8.i.epil, %m2.i7.i.epil
  %acc_next.i.epil = add i64 %x3.i9.i.epil, %idx.i10.unr
  %idx_next.i.epil = add nuw nsw i64 %idx.i10.unr, 8
  br label %l_tail_cond.i.preheader

l_tail_cond.i.preheader:                          ; preds = %l_tail_cond.i.preheader.unr-lcssa, %l_body.i.epil
  %acc_next.i.lcssa = phi i64 [ %acc_next.i.lcssa.ph, %l_tail_cond.i.preheader.unr-lcssa ], [ %acc_next.i.epil, %l_body.i.epil ]
  %idx_next.i.lcssa = phi i64 [ %idx_next.i.lcssa.ph, %l_tail_cond.i.preheader.unr-lcssa ], [ %idx_next.i.epil, %l_body.i.epil ]
  %tmore.i12 = icmp samesign ult i64 %idx_next.i.lcssa, %len.i
  br i1 %tmore.i12, label %l_tail_body.i.preheader, label %l_done.i

l_tail_body.i.preheader:                          ; preds = %l_tail_cond.i.preheader
  %6 = sub i64 %w1, %idx_next.i.lcssa
  %xtraiter17 = and i64 %6, 3
  %lcmp.mod18.not = icmp eq i64 %xtraiter17, 0
  br i1 %lcmp.mod18.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol

l_tail_body.i.prol:                               ; preds = %l_tail_body.i.preheader, %l_tail_body.i.prol
  %tacc.i14.prol = phi i64 [ %tacc_next.i.prol, %l_tail_body.i.prol ], [ %acc_next.i.lcssa, %l_tail_body.i.preheader ]
  %ti.i13.prol = phi i64 [ %ti_next.i.prol, %l_tail_body.i.prol ], [ %idx_next.i.lcssa, %l_tail_body.i.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %l_tail_body.i.prol ], [ 0, %l_tail_body.i.preheader ]
  %tp.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %ti.i13.prol
  %tb.i.prol = load i8, ptr %tp.i.prol, align 1
  %tz.i.prol = zext i8 %tb.i.prol to i64
  %tx.i.prol = xor i64 %tacc.i14.prol, %tz.i.prol
  %tacc_next.i.prol = mul i64 %tx.i.prol, 1099511628211
  %ti_next.i.prol = add nuw nsw i64 %ti.i13.prol, 1
  %prol.iter.next = add i64 %prol.iter, 1
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter17
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol, !llvm.loop !6

l_tail_body.i.prol.loopexit:                      ; preds = %l_tail_body.i.prol, %l_tail_body.i.preheader
  %tacc.i14.unr = phi i64 [ %acc_next.i.lcssa, %l_tail_body.i.preheader ], [ %tacc_next.i.prol, %l_tail_body.i.prol ]
  %ti.i13.unr = phi i64 [ %idx_next.i.lcssa, %l_tail_body.i.preheader ], [ %ti_next.i.prol, %l_tail_body.i.prol ]
  %tacc_next.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.preheader ], [ %tacc_next.i.prol, %l_tail_body.i.prol ]
  %7 = sub i64 %idx_next.i.lcssa, %len.i
  %8 = icmp ugt i64 %7, -4
  br i1 %8, label %l_done.i, label %l_tail_body.i.preheader.new

l_tail_body.i.preheader.new:                      ; preds = %l_tail_body.i.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr.i, i64 1
  %invariant.gep19 = getelementptr i8, ptr %ptr.i, i64 2
  %invariant.gep21 = getelementptr i8, ptr %ptr.i, i64 3
  br label %l_tail_body.i

l_body.i:                                         ; preds = %l_body.i, %long_hash.i.new
  %acc.i11 = phi i64 [ %seed.i, %long_hash.i.new ], [ %acc_next.i.1, %l_body.i ]
  %idx.i10 = phi i64 [ 0, %long_hash.i.new ], [ %idx_next.i.1, %l_body.i ]
  %niter = phi i64 [ 0, %long_hash.i.new ], [ %niter.next.1, %l_body.i ]
  %lp.i = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %idx.i10
  %lane.i = load i64, ptr %lp.i, align 4
  %lm.i = mul i64 %lane.i, -4417276706812531889
  %lx.i = xor i64 %lm.i, %acc.i11
  %s1.i2.i = lshr i64 %lx.i, 30
  %x1.i3.i = xor i64 %s1.i2.i, %lx.i
  %m1.i4.i = mul i64 %x1.i3.i, -4658895280553007687
  %s2.i5.i = lshr i64 %m1.i4.i, 27
  %x2.i6.i = xor i64 %s2.i5.i, %m1.i4.i
  %m2.i7.i = mul i64 %x2.i6.i, -7723592293110705685
  %s3.i8.i = lshr i64 %m2.i7.i, 31
  %x3.i9.i = xor i64 %s3.i8.i, %m2.i7.i
  %acc_next.i = add i64 %x3.i9.i, %idx.i10
  %idx_next.i = or disjoint i64 %idx.i10, 8
  %lp.i.1 = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %idx_next.i
  %lane.i.1 = load i64, ptr %lp.i.1, align 4
  %lm.i.1 = mul i64 %lane.i.1, -4417276706812531889
  %lx.i.1 = xor i64 %lm.i.1, %acc_next.i
  %s1.i2.i.1 = lshr i64 %lx.i.1, 30
  %x1.i3.i.1 = xor i64 %s1.i2.i.1, %lx.i.1
  %m1.i4.i.1 = mul i64 %x1.i3.i.1, -4658895280553007687
  %s2.i5.i.1 = lshr i64 %m1.i4.i.1, 27
  %x2.i6.i.1 = xor i64 %s2.i5.i.1, %m1.i4.i.1
  %m2.i7.i.1 = mul i64 %x2.i6.i.1, -7723592293110705685
  %s3.i8.i.1 = lshr i64 %m2.i7.i.1, 31
  %x3.i9.i.1 = xor i64 %s3.i8.i.1, %m2.i7.i.1
  %acc_next.i.1 = add i64 %x3.i9.i.1, %idx_next.i
  %idx_next.i.1 = add nuw nsw i64 %idx.i10, 16
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1.not = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1.not, label %l_tail_cond.i.preheader.unr-lcssa, label %l_body.i

l_tail_body.i:                                    ; preds = %l_tail_body.i, %l_tail_body.i.preheader.new
  %tacc.i14 = phi i64 [ %tacc.i14.unr, %l_tail_body.i.preheader.new ], [ %tacc_next.i.3, %l_tail_body.i ]
  %ti.i13 = phi i64 [ %ti.i13.unr, %l_tail_body.i.preheader.new ], [ %ti_next.i.3, %l_tail_body.i ]
  %tp.i = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %ti.i13
  %tb.i = load i8, ptr %tp.i, align 1
  %tz.i = zext i8 %tb.i to i64
  %tx.i = xor i64 %tacc.i14, %tz.i
  %tacc_next.i = mul i64 %tx.i, 1099511628211
  %gep = getelementptr i8, ptr %invariant.gep, i64 %ti.i13
  %tb.i.1 = load i8, ptr %gep, align 1
  %tz.i.1 = zext i8 %tb.i.1 to i64
  %tx.i.1 = xor i64 %tacc_next.i, %tz.i.1
  %tacc_next.i.1 = mul i64 %tx.i.1, 1099511628211
  %gep20 = getelementptr i8, ptr %invariant.gep19, i64 %ti.i13
  %tb.i.2 = load i8, ptr %gep20, align 1
  %tz.i.2 = zext i8 %tb.i.2 to i64
  %tx.i.2 = xor i64 %tacc_next.i.1, %tz.i.2
  %tacc_next.i.2 = mul i64 %tx.i.2, 1099511628211
  %gep22 = getelementptr i8, ptr %invariant.gep21, i64 %ti.i13
  %tb.i.3 = load i8, ptr %gep22, align 1
  %tz.i.3 = zext i8 %tb.i.3 to i64
  %tx.i.3 = xor i64 %tacc_next.i.2, %tz.i.3
  %tacc_next.i.3 = mul i64 %tx.i.3, 1099511628211
  %ti_next.i.3 = add nuw nsw i64 %ti.i13, 4
  %tmore.i.3 = icmp samesign ult i64 %ti_next.i.3, %len.i
  br i1 %tmore.i.3, label %l_tail_body.i, label %l_done.i

l_done.i:                                         ; preds = %l_tail_body.i.prol.loopexit, %l_tail_body.i, %l_tail_cond.i.preheader
  %tacc.i.lcssa = phi i64 [ %acc_next.i.lcssa, %l_tail_cond.i.preheader ], [ %tacc_next.i.lcssa.unr, %l_tail_body.i.prol.loopexit ], [ %tacc_next.i.3, %l_tail_body.i ]
  %s1.i.i = lshr i64 %tacc.i.lcssa, 30
  %x1.i.i = xor i64 %s1.i.i, %tacc.i.lcssa
  %m1.i.i = mul i64 %x1.i.i, -4658895280553007687
  %s2.i.i = lshr i64 %m1.i.i, 27
  %x2.i.i = xor i64 %s2.i.i, %m1.i.i
  %m2.i.i = mul i64 %x2.i.i, -7723592293110705685
  %s3.i.i = lshr i64 %m2.i.i, 31
  %x3.i.i = xor i64 %s3.i.i, %m2.i.i
  br label %common.ret

unhash:                                           ; preds = %chk_flt
  tail call fastcc void @archx_type_fail(ptr nonnull @.any.unhash)
  unreachable
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
  %h.i = tail call fastcc i64 @archx_any_hash(%ArchxAny %ak25)
  %res.i = tail call fastcc { i64, i64 } @archx_dict_find_h_any(i64 %wb1, %ArchxAny %ak25, i64 %h.i)
  %didx.i = extractvalue { i64, i64 } %res.i, 0
  %bfound = icmp sgt i64 %didx.i, -1
  br i1 %bfound, label %dchk_val, label %common.ret

dchk_val:                                         ; preds = %dloop_body
  br i1 %is_dict_t, label %dchk_dv, label %dloop_next

dchk_dv:                                          ; preds = %dchk_val
  %av_p = getelementptr inbounds nuw %ArchxAny, ptr %avals, i64 %di42
  %bv_p = getelementptr inbounds nuw %ArchxAny, ptr %bvals, i64 %didx.i
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
  br i1 %exitcond.not, label %ll_done, label %ll_elem, !llvm.loop !7

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
  br i1 %exitcond30.not, label %dd_done, label %dd_key, !llvm.loop !9

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
  %oldret21.pn = phi i64 [ %newret20, %gl_ok ], [ %newret, %gd_ok ], [ 4, %archx_str_byte_at.exit ]
  %newret22.pn = phi i64 [ %newret22, %gl_ok ], [ %newret16, %gd_ok ], [ %rw0.i, %archx_str_byte_at.exit ]
  %newret24.pn = phi i64 [ %newret24, %gl_ok ], [ %newret18, %gd_ok ], [ 0, %archx_str_byte_at.exit ]
  %newret2 = insertvalue { i64, i64, i64 } poison, i64 %oldret21.pn, 0
  %newret4 = insertvalue { i64, i64, i64 } %newret2, i64 %newret22.pn, 1
  %newret6 = insertvalue { i64, i64, i64 } %newret4, i64 %newret24.pn, 2
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
  %newret20 = extractvalue { i64, i64, i64 } %ec, 0
  %newret22 = extractvalue { i64, i64, i64 } %ec, 1
  %newret24 = extractvalue { i64, i64, i64 } %ec, 2
  br label %common.ret

g_dict:                                           ; preds = %entry
  %h.i.i = tail call fastcc i64 @archx_any_hash(%ArchxAny %idx)
  %res.i.i = tail call fastcc { i64, i64 } @archx_dict_find_h_any(i64 %tw1, %ArchxAny %idx, i64 %h.i.i)
  %didx.i = extractvalue { i64, i64 } %res.i.i, 0
  %dfound = icmp sgt i64 %didx.i, -1
  br i1 %dfound, label %gd_ok, label %gd_miss

gd_miss:                                          ; preds = %g_dict
  tail call fastcc void @archx_key_fail()
  unreachable

gd_ok:                                            ; preds = %g_dict
  %draw = and i64 %tw1, -4
  %dh = inttoptr i64 %draw to ptr
  %dvp = getelementptr inbounds nuw i8, ptr %dh, i64 48
  %dvals = load ptr, ptr %dvp, align 8
  %vp = getelementptr inbounds nuw %ArchxAny, ptr %dvals, i64 %didx.i
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
  %newret16 = extractvalue { i64, i64, i64 } %vc, 1
  %newret18 = extractvalue { i64, i64, i64 } %vc, 2
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
attributes #13 = { mustprogress nocallback nofree nounwind willreturn }
attributes #14 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #15 = { nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #16 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.unroll.disable"}
!4 = distinct !{!4, !3}
!5 = distinct !{!5, !3}
!6 = distinct !{!6, !3}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.peeled.count", i32 1}
!9 = distinct !{!9, !8}
