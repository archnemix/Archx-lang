; ModuleID = '/tmp/bench_dict.ll'
source_filename = "/tmp/bench_dict.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxStr = type { i64, i64 }
%ArchxAny = type { i64, i64, i64 }
%ArchxVec = type { i64, i64, ptr }

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.0 = private unnamed_addr constant [18 x i8] c"missing_token_xyz\00", align 4
@.str.1 = private unnamed_addr constant [40 x i8] c"expected `int` from dynamic `any` value\00", align 4
@.str.2 = private unnamed_addr constant [18 x i8] c"identifier_token_\00", align 4
@.fmt.i64s = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.err.type = private unnamed_addr constant [36 x i8] c"archx runtime panic: TypeError: %s\0A\00", align 1
@.any.unhash = private unnamed_addr constant [36 x i8] c"mutable list/dict/set is unhashable\00", align 1
@.any.badop = private unnamed_addr constant [48 x i8] c"unsupported operand types for dynamic operation\00", align 1
@str = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1
@str.1 = private unnamed_addr constant [57 x i8] c"archx runtime panic: KeyError: key not found in dict/set\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %func.region.i = alloca %ArchxRegion, align 8
  %sso.i.i81 = alloca [16 x i8], align 8
  %buf.i82 = alloca [32 x i8], align 8
  %sso.i.i = alloca [16 x i8], align 8
  %buf.i = alloca [32 x i8], align 8
  %btmp.i31 = alloca [12 x i8], align 4
  %btmp.i = alloca [12 x i8], align 4
  %out_sso.i.sroa.6 = alloca i64, align 8
  %btmp4.i75 = getelementptr inbounds nuw i8, ptr %btmp.i31, i64 4
  %btmp4.i = getelementptr inbounds nuw i8, ptr %btmp.i, i64 4
  %sso.i.i81.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i81, i64 4
  %sso.i.i81.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i81, i64 8
  %sso.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 4
  %sso.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 8
  br label %for.body.1

for.body.1:                                       ; preds = %entry, %for.step.2
  %for.i.5.0213 = phi i64 [ 0, %entry ], [ %t101, %for.step.2 ]
  %var.vocab.4.sroa.13.0211 = phi i64 [ 0, %entry ], [ %var.vocab.4.sroa.13.3, %for.step.2 ]
  %var.vocab.4.sroa.26.0210 = phi ptr [ null, %entry ], [ %var.vocab.4.sroa.26.3, %for.step.2 ]
  %t9 = and i64 %for.i.5.0213, 1
  %t10 = icmp eq i64 %t9, 0
  br i1 %t10, label %if.then.4, label %if.else.5

if.then.4:                                        ; preds = %for.body.1
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i)
  %n32.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 range(i64 -9223372036854775808, 1024) %for.i.5.0213)
  %len.i79 = sext i32 %n32.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i)
  %z.i.i = icmp slt i32 %n32.i, 1
  br i1 %z.i.i, label %archx_str_from_int.exit, label %chk_sso.i.i

oom.i.i:                                          ; preds = %alloc_heap.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i:                                      ; preds = %if.then.4
  %short.i.i = icmp samesign ult i32 %n32.i, 13
  br i1 %short.i.i, label %pack_sso.i.i, label %alloc_heap.i.i

pack_sso.i.i:                                     ; preds = %chk_sso.i.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i, i8 0, i64 16, i1 false)
  store i32 %n32.i, ptr %sso.i.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, 2147483648) %len.i79, i1 false)
  %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i = load i64, ptr %sso.i.i, align 8
  %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i = load i64, ptr %sso.i.i.8.sroa_idx, align 8
  %ss0.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i, 0
  %ss1.i.i = insertvalue %ArchxStr %ss0.i.i, i64 %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i, 1
  br label %archx_str_from_int.exit

alloc_heap.i.i:                                   ; preds = %chk_sso.i.i
  %hp.i.i = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483648) %len.i79)
  %hnull.i.i = icmp eq ptr %hp.i.i, null
  br i1 %hnull.i.i, label %oom.i.i, label %copy_long.i.i

copy_long.i.i:                                    ; preds = %alloc_heap.i.i
  %hp_i.i.i = ptrtoint ptr %hp.i.i to i64
  %htagged.i.i = or disjoint i64 %hp_i.i.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, 2147483648) %len.i79, i1 false)
  %pref32.i.i = load i32, ptr %hp.i.i, align 16
  %pref64.i.i = zext i32 %pref32.i.i to i64
  %pref_sh.i.i = shl nuw i64 %pref64.i.i, 32
  %w0_out.i.i = or disjoint i64 %pref_sh.i.i, %len.i79
  %ls0.i.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i, 0
  %ls1.i.i = insertvalue %ArchxStr %ls0.i.i, i64 %htagged.i.i, 1
  br label %archx_str_from_int.exit

archx_str_from_int.exit:                          ; preds = %if.then.4, %pack_sso.i.i, %copy_long.i.i
  %common.ret.op.i.i = phi %ArchxStr [ %ss1.i.i, %pack_sso.i.i ], [ %ls1.i.i, %copy_long.i.i ], [ zeroinitializer, %if.then.4 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  %bw0.i = extractvalue %ArchxStr %common.ret.op.i.i, 0
  %bw1.i = extractvalue %ArchxStr %common.ret.op.i.i, 1
  %blen.i = and i64 %bw0.i, 4294967295
  %bz.i = icmp eq i64 %blen.i, 0
  br i1 %bz.i, label %archx_str_concat.exit, label %calc_tot.i

calc_tot.i:                                       ; preds = %archx_str_from_int.exit
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
  %braw.i = and i64 %bw1.i, -4
  %blptr.i = inttoptr i64 %braw.i to ptr
  br label %alloc_heap.i

build.i:                                          ; preds = %mat_a.i
  %bp4.i = lshr i64 %bw0.i, 32
  %bp4_32.i = trunc nuw i64 %bp4.i to i32
  store i32 %bp4_32.i, ptr %btmp.i, align 4
  store i64 %bw1.i, ptr %btmp4.i, align 4
  %fits_sso.i = icmp samesign ult i64 %blen.i, 9
  br i1 %fits_sso.i, label %build_sso.i, label %alloc_heap.i

build_sso.i:                                      ; preds = %build.i
  store i64 0, ptr %out_sso.i.sroa.6, align 8
  %out_sso.i.sroa.0.4.insert.insert = or disjoint i64 %tot.i, 6875711800118083584
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %out_sso.i.sroa.6, ptr nonnull align 4 %btmp.i, i64 %blen.i, i1 false)
  %out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.8.rw1.i = load i64, ptr %out_sso.i.sroa.6, align 8
  %rs0.i = insertvalue %ArchxStr poison, i64 %out_sso.i.sroa.0.4.insert.insert, 0
  %rs1.i = insertvalue %ArchxStr %rs0.i, i64 %out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.0.out_sso.i.sroa.6.8.rw1.i, 1
  br label %archx_str_concat.exit

alloc_heap.i:                                     ; preds = %build.i.thread, %build.i
  %bptr.i315 = phi ptr [ %blptr.i, %build.i.thread ], [ %btmp.i, %build.i ]
  %hp.i = tail call noalias align 16 ptr @malloc(i64 %tot.i)
  %hnull.i = icmp eq ptr %hp.i, null
  br i1 %hnull.i, label %oom.i, label %copy_long.i

copy_long.i:                                      ; preds = %alloc_heap.i
  %hp_i.i = ptrtoint ptr %hp.i to i64
  %htagged.i = or disjoint i64 %hp_i.i, 1
  store i32 1600876404, ptr %hp.i, align 16
  %dst_b.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %dst_b.i, ptr nonnull align 1 %bptr.i315, i64 %blen.i, i1 false)
  %w0_out.i = or disjoint i64 %tot.i, 6875711800118083584
  %ls0.i = insertvalue %ArchxStr poison, i64 %w0_out.i, 0
  %ls1.i = insertvalue %ArchxStr %ls0.i, i64 %htagged.i, 1
  br label %archx_str_concat.exit

archx_str_concat.exit:                            ; preds = %archx_str_from_int.exit, %build_sso.i, %copy_long.i
  %common.ret.op.i = phi %ArchxStr [ %rs1.i, %build_sso.i ], [ %ls1.i, %copy_long.i ], [ { i64 6875711800118083588, i64 0 }, %archx_str_from_int.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  %t18 = icmp slt i64 %var.vocab.4.sroa.13.0211, 0
  %t20 = tail call i64 @llvm.abs.i64(i64 %var.vocab.4.sroa.13.0211, i1 true)
  %t21.not = icmp samesign ult i64 %for.i.5.0213, %t20
  br i1 %t21.not, label %push.store.8, label %push.calc.10

push.calc.10:                                     ; preds = %archx_str_concat.exit
  %t23 = icmp eq i64 %var.vocab.4.sroa.13.0211, 0
  %t24 = shl nuw i64 %t20, 1
  %0 = tail call i64 @llvm.smin.i64(i64 %t24, i64 140737488355328)
  %t27 = select i1 %t23, i64 4, i64 %0
  %1 = add i64 %t27, -576460752303423488
  %t30 = icmp ult i64 %1, -1152921504606846976
  br i1 %t30, label %mul.oom.11, label %mul.ok.12

mul.oom.11:                                       ; preds = %push.calc.10
  tail call fastcc void @archx_oom_fail()
  unreachable

mul.ok.12:                                        ; preds = %push.calc.10
  %t29 = shl nsw i64 %t27, 4
  %t32 = tail call i64 @llvm.umax.i64(i64 %t29, i64 1)
  br i1 %t18, label %mul.ok.16, label %push.grow.from_heap.14

mul.ok.16:                                        ; preds = %mul.ok.12
  %t38 = tail call noalias align 16 ptr @malloc(i64 %t32)
  %t39 = icmp eq ptr %t38, null
  br i1 %t39, label %alloc.oom.18, label %push.reg.copy.19

alloc.oom.18:                                     ; preds = %mul.ok.16
  tail call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.19:                                 ; preds = %mul.ok.16
  %t34 = shl nuw nsw i64 %for.i.5.0213, 4
  %t37 = tail call i64 @llvm.umax.i64(i64 %t34, i64 1)
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t38, ptr noundef nonnull align 8 dereferenceable(1) %var.vocab.4.sroa.26.0210, i64 %t37, i1 false)
  br label %push.store.8

push.grow.from_heap.14:                           ; preds = %mul.ok.12
  %t44 = tail call align 16 ptr @realloc(ptr %var.vocab.4.sroa.26.0210, i64 %t32)
  %t45 = icmp eq ptr %t44, null
  br i1 %t45, label %realloc.oom.22, label %push.store.8

realloc.oom.22:                                   ; preds = %push.grow.from_heap.14
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.8:                                     ; preds = %push.grow.from_heap.14, %push.reg.copy.19, %archx_str_concat.exit
  %var.vocab.4.sroa.26.1 = phi ptr [ %var.vocab.4.sroa.26.0210, %archx_str_concat.exit ], [ %t38, %push.reg.copy.19 ], [ %t44, %push.grow.from_heap.14 ]
  %var.vocab.4.sroa.13.1 = phi i64 [ %var.vocab.4.sroa.13.0211, %archx_str_concat.exit ], [ %t27, %push.reg.copy.19 ], [ %t27, %push.grow.from_heap.14 ]
  %t51 = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.1, i64 %for.i.5.0213
  %t13.elt = extractvalue %ArchxStr %common.ret.op.i, 0
  store i64 %t13.elt, ptr %t51, align 8
  %t51.repack17 = getelementptr inbounds nuw i8, ptr %t51, i64 8
  %t13.elt18 = extractvalue %ArchxStr %common.ret.op.i, 1
  store i64 %t13.elt18, ptr %t51.repack17, align 8
  %long.i = icmp samesign ult i64 %blen.i, 13
  %tag.i = and i64 %bw1.i, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %long.i, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %for.step.2, label %for.step.2.sink.split

if.else.5:                                        ; preds = %for.body.1
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i82)
  %n32.i83 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i82, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 range(i64 -9223372036854775808, 1024) %for.i.5.0213)
  %len.i84 = sext i32 %n32.i83 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i81)
  %z.i.i85 = icmp slt i32 %n32.i83, 1
  br i1 %z.i.i85, label %archx_str_from_int.exit109, label %chk_sso.i.i86

oom.i.i101:                                       ; preds = %alloc_heap.i.i88
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i86:                                    ; preds = %if.else.5
  %short.i.i87 = icmp samesign ult i32 %n32.i83, 13
  br i1 %short.i.i87, label %pack_sso.i.i102, label %alloc_heap.i.i88

pack_sso.i.i102:                                  ; preds = %chk_sso.i.i86
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i81, i8 0, i64 16, i1 false)
  store i32 %n32.i83, ptr %sso.i.i81, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i81.4.sroa_idx, ptr nonnull readonly align 8 %buf.i82, i64 range(i64 -2147483648, 2147483648) %len.i84, i1 false)
  %sso.i.i81.0.sso.i.i81.0.sso.i.i81.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i104 = load i64, ptr %sso.i.i81, align 8
  %sso.i.i81.8.sso.i.i81.8.sso.i.i81.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i106 = load i64, ptr %sso.i.i81.8.sroa_idx, align 8
  %ss0.i.i107 = insertvalue %ArchxStr poison, i64 %sso.i.i81.0.sso.i.i81.0.sso.i.i81.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i104, 0
  %ss1.i.i108 = insertvalue %ArchxStr %ss0.i.i107, i64 %sso.i.i81.8.sso.i.i81.8.sso.i.i81.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i106, 1
  br label %archx_str_from_int.exit109

alloc_heap.i.i88:                                 ; preds = %chk_sso.i.i86
  %hp.i.i89 = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483648) %len.i84)
  %hnull.i.i90 = icmp eq ptr %hp.i.i89, null
  br i1 %hnull.i.i90, label %oom.i.i101, label %copy_long.i.i91

copy_long.i.i91:                                  ; preds = %alloc_heap.i.i88
  %hp_i.i.i92 = ptrtoint ptr %hp.i.i89 to i64
  %htagged.i.i93 = or disjoint i64 %hp_i.i.i92, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i89, ptr nonnull readonly align 8 %buf.i82, i64 range(i64 -2147483648, 2147483648) %len.i84, i1 false)
  %pref32.i.i94 = load i32, ptr %hp.i.i89, align 16
  %pref64.i.i95 = zext i32 %pref32.i.i94 to i64
  %pref_sh.i.i96 = shl nuw i64 %pref64.i.i95, 32
  %w0_out.i.i97 = or disjoint i64 %pref_sh.i.i96, %len.i84
  %ls0.i.i98 = insertvalue %ArchxStr poison, i64 %w0_out.i.i97, 0
  %ls1.i.i99 = insertvalue %ArchxStr %ls0.i.i98, i64 %htagged.i.i93, 1
  br label %archx_str_from_int.exit109

archx_str_from_int.exit109:                       ; preds = %if.else.5, %pack_sso.i.i102, %copy_long.i.i91
  %common.ret.op.i.i100 = phi %ArchxStr [ %ss1.i.i108, %pack_sso.i.i102 ], [ %ls1.i.i99, %copy_long.i.i91 ], [ zeroinitializer, %if.else.5 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i81)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i82)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i31)
  %bw0.i33 = extractvalue %ArchxStr %common.ret.op.i.i100, 0
  %bw1.i34 = extractvalue %ArchxStr %common.ret.op.i.i100, 1
  %blen.i35 = and i64 %bw0.i33, 4294967295
  %bz.i36 = icmp eq i64 %blen.i35, 0
  br i1 %bz.i36, label %archx_str_concat.exit78, label %calc_tot.i37

calc_tot.i37:                                     ; preds = %archx_str_from_int.exit109
  %tot.i38 = add nuw nsw i64 %blen.i35, 17
  %too_big.i39 = icmp samesign ugt i64 %blen.i35, 2147483630
  br i1 %too_big.i39, label %oom.i62, label %mat_a.i40

oom.i62:                                          ; preds = %alloc_heap.i48, %calc_tot.i37
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i40:                                        ; preds = %calc_tot.i37
  %bshort.i41 = icmp samesign ult i64 %blen.i35, 13
  br i1 %bshort.i41, label %mat_b_short.i72, label %mat_b_long.i42

mat_b_short.i72:                                  ; preds = %mat_a.i40
  %bp4.i73 = lshr i64 %bw0.i33, 32
  %bp4_32.i74 = trunc nuw i64 %bp4.i73 to i32
  store i32 %bp4_32.i74, ptr %btmp.i31, align 4
  store i64 %bw1.i34, ptr %btmp4.i75, align 4
  br label %alloc_heap.i48

mat_b_long.i42:                                   ; preds = %mat_a.i40
  %braw.i43 = and i64 %bw1.i34, -4
  %blptr.i44 = inttoptr i64 %braw.i43 to ptr
  br label %alloc_heap.i48

alloc_heap.i48:                                   ; preds = %mat_b_short.i72, %mat_b_long.i42
  %bptr.i46 = phi ptr [ %btmp.i31, %mat_b_short.i72 ], [ %blptr.i44, %mat_b_long.i42 ]
  %hp.i49 = tail call noalias align 16 ptr @malloc(i64 %tot.i38)
  %hnull.i50 = icmp eq ptr %hp.i49, null
  br i1 %hnull.i50, label %oom.i62, label %copy_long.i51

copy_long.i51:                                    ; preds = %alloc_heap.i48
  %hp_i.i52 = ptrtoint ptr %hp.i49 to i64
  %htagged.i53 = or disjoint i64 %hp_i.i52, 1
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(17) %hp.i49, ptr noundef nonnull align 4 dereferenceable(17) @.str.2, i64 17, i1 false)
  %dst_b.i54 = getelementptr inbounds nuw i8, ptr %hp.i49, i64 17
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i54, ptr nonnull align 1 %bptr.i46, i64 %blen.i35, i1 false)
  %w0_out.i58 = or disjoint i64 %tot.i38, 7954874718954192896
  %ls0.i59 = insertvalue %ArchxStr poison, i64 %w0_out.i58, 0
  %ls1.i60 = insertvalue %ArchxStr %ls0.i59, i64 %htagged.i53, 1
  br label %archx_str_concat.exit78

archx_str_concat.exit78:                          ; preds = %archx_str_from_int.exit109, %copy_long.i51
  %common.ret.op.i61 = phi %ArchxStr [ %ls1.i60, %copy_long.i51 ], [ { i64 7954874718954192913, i64 ptrtoint (ptr @.str.2 to i64) }, %archx_str_from_int.exit109 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i31)
  %t64 = icmp slt i64 %var.vocab.4.sroa.13.0211, 0
  %t66 = tail call i64 @llvm.abs.i64(i64 %var.vocab.4.sroa.13.0211, i1 true)
  %t67.not = icmp samesign ult i64 %for.i.5.0213, %t66
  br i1 %t67.not, label %push.store.24, label %push.calc.26

push.calc.26:                                     ; preds = %archx_str_concat.exit78
  %t69 = icmp eq i64 %var.vocab.4.sroa.13.0211, 0
  %t70 = shl nuw i64 %t66, 1
  %2 = tail call i64 @llvm.smin.i64(i64 %t70, i64 140737488355328)
  %t73 = select i1 %t69, i64 4, i64 %2
  %3 = add i64 %t73, -576460752303423488
  %t76 = icmp ult i64 %3, -1152921504606846976
  br i1 %t76, label %mul.oom.27, label %mul.ok.28

mul.oom.27:                                       ; preds = %push.calc.26
  tail call fastcc void @archx_oom_fail()
  unreachable

mul.ok.28:                                        ; preds = %push.calc.26
  %t75 = shl nsw i64 %t73, 4
  %t78 = tail call i64 @llvm.umax.i64(i64 %t75, i64 1)
  br i1 %t64, label %mul.ok.32, label %push.grow.from_heap.30

mul.ok.32:                                        ; preds = %mul.ok.28
  %t84 = tail call noalias align 16 ptr @malloc(i64 %t78)
  %t85 = icmp eq ptr %t84, null
  br i1 %t85, label %alloc.oom.34, label %push.reg.copy.35

alloc.oom.34:                                     ; preds = %mul.ok.32
  tail call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.35:                                 ; preds = %mul.ok.32
  %t80 = shl nuw nsw i64 %for.i.5.0213, 4
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t84, ptr noundef nonnull align 8 dereferenceable(1) %var.vocab.4.sroa.26.0210, i64 %t80, i1 false)
  br label %push.store.24

push.grow.from_heap.30:                           ; preds = %mul.ok.28
  %t90 = tail call align 16 ptr @realloc(ptr %var.vocab.4.sroa.26.0210, i64 %t78)
  %t91 = icmp eq ptr %t90, null
  br i1 %t91, label %realloc.oom.38, label %push.store.24

realloc.oom.38:                                   ; preds = %push.grow.from_heap.30
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.24:                                    ; preds = %push.grow.from_heap.30, %push.reg.copy.35, %archx_str_concat.exit78
  %var.vocab.4.sroa.26.2 = phi ptr [ %var.vocab.4.sroa.26.0210, %archx_str_concat.exit78 ], [ %t84, %push.reg.copy.35 ], [ %t90, %push.grow.from_heap.30 ]
  %var.vocab.4.sroa.13.2 = phi i64 [ %var.vocab.4.sroa.13.0211, %archx_str_concat.exit78 ], [ %t73, %push.reg.copy.35 ], [ %t73, %push.grow.from_heap.30 ]
  %t97 = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.2, i64 %for.i.5.0213
  %t59.elt = extractvalue %ArchxStr %common.ret.op.i61, 0
  store i64 %t59.elt, ptr %t97, align 8
  %t97.repack15 = getelementptr inbounds nuw i8, ptr %t97, i64 8
  %t59.elt16 = extractvalue %ArchxStr %common.ret.op.i61, 1
  store i64 %t59.elt16, ptr %t97.repack15, align 8
  %long.i21 = icmp samesign ult i64 %blen.i35, 13
  %tag.i24 = and i64 %bw1.i34, 1
  %owned.not.i25 = icmp eq i64 %tag.i24, 0
  %or.cond150 = select i1 %long.i21, i1 true, i1 %owned.not.i25
  br i1 %or.cond150, label %for.step.2, label %for.step.2.sink.split

for.step.2.sink.split:                            ; preds = %push.store.24, %push.store.8
  %bw1.i34.sink = phi i64 [ %bw1.i, %push.store.8 ], [ %bw1.i34, %push.store.24 ]
  %var.vocab.4.sroa.26.3.ph = phi ptr [ %var.vocab.4.sroa.26.1, %push.store.8 ], [ %var.vocab.4.sroa.26.2, %push.store.24 ]
  %var.vocab.4.sroa.13.3.ph = phi i64 [ %var.vocab.4.sroa.13.1, %push.store.8 ], [ %var.vocab.4.sroa.13.2, %push.store.24 ]
  %raw.i27 = and i64 %bw1.i34.sink, -2
  %ptr.i28 = inttoptr i64 %raw.i27 to ptr
  tail call void @free(ptr %ptr.i28)
  br label %for.step.2

for.step.2:                                       ; preds = %for.step.2.sink.split, %push.store.24, %push.store.8
  %var.vocab.4.sroa.26.3 = phi ptr [ %var.vocab.4.sroa.26.1, %push.store.8 ], [ %var.vocab.4.sroa.26.2, %push.store.24 ], [ %var.vocab.4.sroa.26.3.ph, %for.step.2.sink.split ]
  %var.vocab.4.sroa.13.3 = phi i64 [ %var.vocab.4.sroa.13.1, %push.store.8 ], [ %var.vocab.4.sroa.13.2, %push.store.24 ], [ %var.vocab.4.sroa.13.3.ph, %for.step.2.sink.split ]
  %t101 = add nuw nsw i64 %for.i.5.0213, 1
  %exitcond.not = icmp eq i64 %t101, 1024
  br i1 %exitcond.not, label %for.end.3, label %for.body.1

for.end.3:                                        ; preds = %for.step.2
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %func.region.i)
  %.fca.1.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 8
  %.fca.2.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 16
  %.fca.3.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 24
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %func.region.i, i8 0, i64 32, i1 false)
  br label %for.body.1.i

for.body.1.i:                                     ; preds = %for.body.1.i.backedge, %for.end.3
  %end.i.i.i = phi ptr [ null, %for.end.3 ], [ %end.i.i.i.be, %for.body.1.i.backedge ]
  %cur.i.i.i = phi ptr [ null, %for.end.3 ], [ %cur.i.i.i.be, %for.body.1.i.backedge ]
  %var.str_checksum.0.0621.i = phi i64 [ 0, %for.end.3 ], [ %var.str_checksum.0.4.lcssa660.i, %for.body.1.i.backedge ]
  %for.r.4.0620.i = phi i64 [ 0, %for.end.3 ], [ %for.r.4.0620.i.be, %for.body.1.i.backedge ]
  %cur_i.i.i.i = ptrtoint ptr %cur.i.i.i to i64
  %end_i.i.i.i = ptrtoint ptr %end.i.i.i to i64
  %rem.i.i.i = sub i64 %end_i.i.i.i, %cur_i.i.i.i
  %fits.not.i.i.i = icmp slt i64 %rem.i.i.i, 64
  br i1 %fits.not.i.i.i, label %fallback.i.i.i, label %fast.i.i.i

fast.i.i.i:                                       ; preds = %for.body.1.i
  %next.i.i.i = getelementptr inbounds nuw i8, ptr %cur.i.i.i, i64 64
  store ptr %next.i.i.i, ptr %func.region.i, align 8
  br label %for.fast.body.5.i.preheader

fallback.i.i.i:                                   ; preds = %for.body.1.i
  %res.i.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr nonnull %func.region.i, i64 64)
  %.pre.i.i = ptrtoint ptr %res.i.i.i to i64
  br label %for.fast.body.5.i.preheader

for.fast.body.5.i.preheader:                      ; preds = %fast.i.i.i, %fallback.i.i.i
  %rpi.pre-phi.i.i = phi i64 [ %cur_i.i.i.i, %fast.i.i.i ], [ %.pre.i.i, %fallback.i.i.i ]
  %common.ret.op.i.i344.i = phi ptr [ %cur.i.i.i, %fast.i.i.i ], [ %res.i.i.i, %fallback.i.i.i ]
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(64) %common.ret.op.i.i344.i, i8 0, i64 64, i1 false)
  %r_reg_gep.i.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i344.i, i64 24
  store ptr %func.region.i, ptr %r_reg_gep.i.i, align 8
  %r_meta_gep.i.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i344.i, i64 56
  store i64 103079219201, ptr %r_meta_gep.i.i, align 8
  %rtag.i.i = or disjoint i64 %rpi.pre-phi.i.i, 2
  %t23.i = and i64 %rpi.pre-phi.i.i, -4
  %t24.i = inttoptr i64 %t23.i to ptr
  %t25.i = getelementptr inbounds nuw i8, ptr %t24.i, i64 48
  br label %for.fast.body.5.i

for.fast.body.5.i:                                ; preds = %for.fast.body.5.i.preheader, %dins.store.12.i
  %for.i.9.0599.i = phi i64 [ %t30.i, %dins.store.12.i ], [ 0, %for.fast.body.5.i.preheader ]
  %t17.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %for.i.9.0599.i
  %t18.unpack.i = load i64, ptr %t17.i, align 8
  %4 = insertvalue %ArchxStr poison, i64 %t18.unpack.i, 0
  %t18.elt83.i = getelementptr inbounds nuw i8, ptr %t17.i, i64 8
  %t18.unpack84.i = load i64, ptr %t18.elt83.i, align 8
  %t1885.i = insertvalue %ArchxStr %4, i64 %t18.unpack84.i, 1
  %t20.i = call fastcc { i64, i1 } @archx_dict_upsert_str(i64 %rtag.i.i, %ArchxStr %t1885.i)
  %t21.i = extractvalue { i64, i1 } %t20.i, 0
  %t22.i = extractvalue { i64, i1 } %t20.i, 1
  %t26.i = load ptr, ptr %t25.i, align 8
  %t27.i = getelementptr inbounds %ArchxAny, ptr %t26.i, i64 %t21.i
  br i1 %t22.i, label %dins.dropold.11.i, label %dins.store.12.i

dins.dropold.11.i:                                ; preds = %for.fast.body.5.i
  %t28.unpack.i = load i64, ptr %t27.i, align 8
  %5 = insertvalue %ArchxAny poison, i64 %t28.unpack.i, 0
  %t28.elt86.i = getelementptr inbounds nuw i8, ptr %t27.i, i64 8
  %t28.unpack87.i = load i64, ptr %t28.elt86.i, align 8
  %6 = insertvalue %ArchxAny %5, i64 %t28.unpack87.i, 1
  %t28.elt88.i = getelementptr inbounds nuw i8, ptr %t27.i, i64 16
  %t28.unpack89.i = load i64, ptr %t28.elt88.i, align 8
  %t2890.i = insertvalue %ArchxAny %6, i64 %t28.unpack89.i, 2
  call fastcc void @archx_any_drop(%ArchxAny %t2890.i)
  br label %dins.store.12.i

dins.store.12.i:                                  ; preds = %dins.dropold.11.i, %for.fast.body.5.i
  store i64 2, ptr %t27.i, align 8
  %t27.repack91.i = getelementptr inbounds nuw i8, ptr %t27.i, i64 8
  store i64 1, ptr %t27.repack91.i, align 8
  %t27.repack92.i = getelementptr inbounds nuw i8, ptr %t27.i, i64 16
  store i64 0, ptr %t27.repack92.i, align 8
  %t30.i = add nuw nsw i64 %for.i.9.0599.i, 1
  %exitcond642.not.i = icmp eq i64 %t30.i, 1024
  br i1 %exitcond642.not.i, label %for.end.10.i, label %for.fast.body.5.i

for.end.10.i:                                     ; preds = %dins.store.12.i
  %t58.i = mul nuw nsw i64 %for.r.4.0620.i, 19
  %is_z.i.i.i = icmp eq i64 %t23.i, 0
  %ctrl_p.i.i.i = getelementptr inbounds nuw i8, ptr %t24.i, i64 32
  %mask_p.i.i.i = getelementptr inbounds nuw i8, ptr %t24.i, i64 16
  %keys_p.i.i.i = getelementptr inbounds nuw i8, ptr %t24.i, i64 40
  br label %idx.ok.21.i

for.cond.27.preheader.i:                          ; preds = %archx_str_drop.exit.i
  %t105.i = mul nuw nsw i64 %for.r.4.0620.i, 7
  br label %idx.ok.31.i

idx.ok.21.i:                                      ; preds = %for.end.10.i, %archx_str_drop.exit.i
  %for.step.52.0602.i = phi i64 [ 0, %for.end.10.i ], [ %t98.i, %archx_str_drop.exit.i ]
  %t56.i = mul nuw nsw i64 %for.step.52.0602.i, 73
  %t59.i = add nuw nsw i64 %t56.i, %t58.i
  %t60.i = and i64 %t59.i, 1023
  %t64.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %t60.i
  %t65.unpack.i = load i64, ptr %t64.i, align 8
  %7 = insertvalue %ArchxStr poison, i64 %t65.unpack.i, 0
  %t65.elt66.i = getelementptr inbounds nuw i8, ptr %t64.i, i64 8
  %t65.unpack67.i = load i64, ptr %t65.elt66.i, align 8
  %t6568.i = insertvalue %ArchxStr %7, i64 %t65.unpack67.i, 1
  %len.i346.i = and i64 %t65.unpack.i, 4294967295
  %long.i347.i = icmp samesign ult i64 %len.i346.i, 13
  %tag.i350.i = and i64 %t65.unpack67.i, 3
  %owned.not.i351.i = icmp eq i64 %tag.i350.i, 0
  %or.cond.i = select i1 %long.i347.i, i1 true, i1 %owned.not.i351.i
  br i1 %or.cond.i, label %archx_str_clone.exit.i, label %dup_heap.i.i

dup_heap.i.i:                                     ; preds = %idx.ok.21.i
  %dst.i.i = call noalias align 16 ptr @malloc(i64 %len.i346.i)
  %isnull.i.i = icmp eq ptr %dst.i.i, null
  br i1 %isnull.i.i, label %oom.i.i114, label %copy.i.i

oom.i.i114:                                       ; preds = %dup_heap.i.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i:                                         ; preds = %dup_heap.i.i
  %src_i.i.i = and i64 %t65.unpack67.i, -4
  %src.i.i = inttoptr i64 %src_i.i.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i, ptr nonnull align 4 %src.i.i, i64 %len.i346.i, i1 false)
  %dst_i.i.i = ptrtoint ptr %dst.i.i to i64
  %tagged.i.i = or disjoint i64 %dst_i.i.i, 1
  %out.i.i = insertvalue %ArchxStr %t6568.i, i64 %tagged.i.i, 1
  br label %archx_str_clone.exit.i

archx_str_clone.exit.i:                           ; preds = %copy.i.i, %idx.ok.21.i
  %common.ret.op.i.i112 = phi %ArchxStr [ %out.i.i, %copy.i.i ], [ %t6568.i, %idx.ok.21.i ]
  br i1 %is_z.i.i.i, label %dget.miss.24.i, label %chk_ctrl.i.i.i

chk_ctrl.i.i.i:                                   ; preds = %archx_str_clone.exit.i
  %ctrl.i.i.i = load ptr, ptr %ctrl_p.i.i.i, align 8
  %c_null.i.i.i = icmp eq ptr %ctrl.i.i.i, null
  br i1 %c_null.i.i.i, label %dget.miss.24.i, label %do_probe.i.i.i

do_probe.i.i.i:                                   ; preds = %chk_ctrl.i.i.i
  %mask.i.i.i = load i64, ptr %mask_p.i.i.i, align 8
  %keys.i.i.i = load ptr, ptr %keys_p.i.i.i, align 8
  %8 = getelementptr i8, ptr %ctrl.i.i.i, i64 %mask.i.i.i
  %idx_base.i.i.i = getelementptr i8, ptr %8, i64 17
  %h.i.i.i = call fastcc i64 @archx_hash_str(%ArchxStr %common.ret.op.i.i112)
  %h2_64.i.i.i = lshr i64 %h.i.i.i, 57
  %h2.i.i.i = trunc nuw nsw i64 %h2_64.i.i.i to i8
  %h2_ins.i.i.i = insertelement <16 x i8> poison, i8 %h2.i.i.i, i64 0
  %h2_vec.i.i.i = shufflevector <16 x i8> %h2_ins.i.i.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bw0.i.i = extractvalue %ArchxStr %common.ret.op.i.i112, 0
  %bw1.i.i = extractvalue %ArchxStr %common.ret.op.i.i112, 1
  %bp_i.i.i = and i64 %bw1.i.i, -4
  %bp.i.i = inttoptr i64 %bp_i.i.i to ptr
  %bp4.i.i = getelementptr inbounds nuw i8, ptr %bp.i.i, i64 4
  %len.i353.i = and i64 %bw0.i.i, 4294967295
  %short.i.i113 = icmp samesign ult i64 %len.i353.i, 13
  %rem.i.i = add nsw i64 %len.i353.i, -4
  br label %probe.i.i.i

probe.i.i.i:                                      ; preds = %next_grp.i.i.i, %do_probe.i.i.i
  %h.pn.i.i.i = phi i64 [ %h.i.i.i, %do_probe.i.i.i ], [ %padd.i.i.i, %next_grp.i.i.i ]
  %step.i.i.i = phi i64 [ 0, %do_probe.i.i.i ], [ %step_next.i.i.i, %next_grp.i.i.i ]
  %pos.i.i.i = and i64 %h.pn.i.i.i, %mask.i.i.i
  %gp.i.i.i = getelementptr inbounds i8, ptr %ctrl.i.i.i, i64 %pos.i.i.i
  %grp.i.i.i = load <16 x i8>, ptr %gp.i.i.i, align 1
  %mcmp.i.i.i = icmp eq <16 x i8> %grp.i.i.i, %h2_vec.i.i.i
  %mbits.i.i.i = bitcast <16 x i1> %mcmp.i.i.i to i16
  %has_m.not.i.i600.i = icmp eq i16 %mbits.i.i.i, 0
  br i1 %has_m.not.i.i600.i, label %chk_empty.i.i.i, label %chk_key.i.i.preheader.i

chk_key.i.i.preheader.i:                          ; preds = %probe.i.i.i
  %mmask0.i.i.i = zext i16 %mbits.i.i.i to i32
  br label %chk_key.i.i.i

chk_key.i.i.i:                                    ; preds = %mbit_cont.i.i.i, %chk_key.i.i.preheader.i
  %mmask.i.i601.i = phi i32 [ %mmask_next.i.i.i, %mbit_cont.i.i.i ], [ %mmask0.i.i.i, %chk_key.i.i.preheader.i ]
  %tz.i.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i601.i, i1 true)
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
  %w0_eq.i.i = icmp eq i64 %cand_k.unpack.i.i.i, %bw0.i.i
  br i1 %w0_eq.i.i, label %chk_len.i.i, label %mbit_cont.i.i.i

chk_len.i.i:                                      ; preds = %chk_key.i.i.i
  br i1 %short.i.i113, label %cmp_short.i.i, label %cmp_long.i.i

cmp_short.i.i:                                    ; preds = %chk_len.i.i
  %eq_s.i.i = icmp eq i64 %cand_k.unpack2.i.i.i, %bw1.i.i
  br i1 %eq_s.i.i, label %dget.ok.23.i, label %mbit_cont.i.i.i

cmp_long.i.i:                                     ; preds = %chk_len.i.i
  %ap_i.i.i = and i64 %cand_k.unpack2.i.i.i, -4
  %same_ptr.i.i = icmp eq i64 %ap_i.i.i, %bp_i.i.i
  br i1 %same_ptr.i.i, label %dget.ok.23.i, label %archx_str_eq.exit.i

archx_str_eq.exit.i:                              ; preds = %cmp_long.i.i
  %ap.i.i = inttoptr i64 %ap_i.i.i to ptr
  %ap4.i.i = getelementptr inbounds nuw i8, ptr %ap.i.i, i64 4
  %bcmp.i.i = call i32 @bcmp(ptr nonnull %ap4.i.i, ptr nonnull %bp4.i.i, i64 %rem.i.i)
  %eq_m.i.i = icmp eq i32 %bcmp.i.i, 0
  br i1 %eq_m.i.i, label %dget.ok.23.i, label %mbit_cont.i.i.i

mbit_cont.i.i.i:                                  ; preds = %archx_str_eq.exit.i, %cmp_short.i.i, %chk_key.i.i.i
  %mm1.i.i.i = add nsw i32 %mmask.i.i601.i, -1
  %mmask_next.i.i.i = and i32 %mm1.i.i.i, %mmask.i.i601.i
  %has_m.not.i.i.i = icmp eq i32 %mmask_next.i.i.i, 0
  br i1 %has_m.not.i.i.i, label %chk_empty.i.i.i, label %chk_key.i.i.i

chk_empty.i.i.i:                                  ; preds = %mbit_cont.i.i.i, %probe.i.i.i
  %ecmp.i.i.i = icmp eq <16 x i8> %grp.i.i.i, splat (i8 -128)
  %ebits.i.i.i = bitcast <16 x i1> %ecmp.i.i.i to i16
  %has_e.not.i.i.i = icmp eq i16 %ebits.i.i.i, 0
  br i1 %has_e.not.i.i.i, label %next_grp.i.i.i, label %dget.miss.24.i

next_grp.i.i.i:                                   ; preds = %chk_empty.i.i.i
  %step_next.i.i.i = add i64 %step.i.i.i, 16
  %padd.i.i.i = add i64 %step_next.i.i.i, %pos.i.i.i
  br label %probe.i.i.i

dget.miss.24.i:                                   ; preds = %chk_ctrl.i.i.i, %archx_str_clone.exit.i, %chk_empty.i.i.i
  call fastcc void @archx_key_fail()
  unreachable

dget.ok.23.i:                                     ; preds = %archx_str_eq.exit.i, %cmp_long.i.i, %cmp_short.i.i
  %t77.i = load ptr, ptr %t25.i, align 8
  %t78.i = getelementptr inbounds nuw %ArchxAny, ptr %t77.i, i64 %didx.i.i.i
  %t79.unpack.i = load i64, ptr %t78.i, align 8
  %9 = insertvalue %ArchxAny poison, i64 %t79.unpack.i, 0
  %t79.elt69.i = getelementptr inbounds nuw i8, ptr %t78.i, i64 8
  %t79.unpack70.i = load i64, ptr %t79.elt69.i, align 8
  %10 = insertvalue %ArchxAny %9, i64 %t79.unpack70.i, 1
  %t79.elt71.i = getelementptr inbounds nuw i8, ptr %t78.i, i64 16
  %t79.unpack72.i = load i64, ptr %t79.elt71.i, align 8
  %t7973.i = insertvalue %ArchxAny %10, i64 %t79.unpack72.i, 2
  %t80.i = call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t7973.i)
  %newret345 = extractvalue { i64, i64, i64 } %t80.i, 0
  %oldret346 = insertvalue %ArchxAny poison, i64 %newret345, 0
  %newret347 = extractvalue { i64, i64, i64 } %t80.i, 1
  %oldret348 = insertvalue %ArchxAny %oldret346, i64 %newret347, 1
  %newret349 = extractvalue { i64, i64, i64 } %t80.i, 2
  %oldret350 = insertvalue %ArchxAny %oldret348, i64 %newret349, 2
  %t82.i = urem i64 %for.step.52.0602.i, 7
  %t83.i = insertvalue %ArchxAny { i64 2, i64 0, i64 0 }, i64 %t82.i, 1
  %11 = add i64 %newret345, -1
  %na.i.i = icmp ult i64 %11, 3
  br i1 %na.i.i, label %num_op.i.i, label %bad_op.i.i

num_op.i.i:                                       ; preds = %dget.ok.23.i
  %fa_is.i.i = icmp eq i64 %newret345, 3
  br i1 %fa_is.i.i, label %ret_flt.i.i, label %ret_int.i.i

ret_int.i.i:                                      ; preds = %num_op.i.i
  %va.i.i = add i64 %newret347, %t82.i
  br label %archx_any_binop.exit.i

ret_flt.i.i:                                      ; preds = %num_op.i.i
  %da_b.i.i = bitcast i64 %newret347 to double
  %db_i.i.i = uitofp nneg i64 %t82.i to double
  %fva.i.i = fadd double %db_i.i.i, %da_b.i.i
  %fbits.i.i = bitcast double %fva.i.i to i64
  br label %archx_any_binop.exit.i

bad_op.i.i:                                       ; preds = %dget.ok.23.i
  call fastcc void @archx_type_fail(ptr nonnull @.any.badop)
  unreachable

archx_any_binop.exit.i:                           ; preds = %ret_flt.i.i, %ret_int.i.i
  %.pn.i.i = phi %ArchxAny [ { i64 2, i64 0, i64 0 }, %ret_int.i.i ], [ { i64 3, i64 0, i64 0 }, %ret_flt.i.i ]
  %va.pn.i.i = phi i64 [ %va.i.i, %ret_int.i.i ], [ %fbits.i.i, %ret_flt.i.i ]
  %common.ret.op.i354.i = insertvalue %ArchxAny %.pn.i.i, i64 %va.pn.i.i, 1
  %ta.i355.i = extractvalue %ArchxAny %.pn.i.i, 0
  %12 = add i64 %ta.i355.i, -1
  %na.i357.i = icmp ult i64 %12, 3
  br i1 %na.i357.i, label %num_op.i359.i, label %bad_op.i358.i

num_op.i359.i:                                    ; preds = %archx_any_binop.exit.i
  %fa_is.i360.i = icmp eq i64 %ta.i355.i, 3
  %va.i362.i = add i64 %va.pn.i.i, 1
  %da_b.i367.i = bitcast i64 %va.pn.i.i to double
  %fva.i368.i = fadd double %da_b.i367.i, 1.000000e+00
  %fbits.i369.i = bitcast double %fva.i368.i to i64
  %va.pn.i364.i = select i1 %fa_is.i360.i, i64 %fbits.i369.i, i64 %va.i362.i
  %t87.i = call fastcc { i64, i1 } @archx_dict_upsert_str(i64 %rtag.i.i, %ArchxStr %common.ret.op.i.i112)
  %t88.i = extractvalue { i64, i1 } %t87.i, 0
  %t89.i = extractvalue { i64, i1 } %t87.i, 1
  %t93.i = load ptr, ptr %t25.i, align 8
  %t94.i = getelementptr inbounds %ArchxAny, ptr %t93.i, i64 %t88.i
  br i1 %t89.i, label %dins.dropold.25.i, label %dins.store.26.i

bad_op.i358.i:                                    ; preds = %archx_any_binop.exit.i
  call fastcc void @archx_type_fail(ptr nonnull @.any.badop)
  unreachable

dins.dropold.25.i:                                ; preds = %num_op.i359.i
  %t95.unpack.i = load i64, ptr %t94.i, align 8
  %13 = insertvalue %ArchxAny poison, i64 %t95.unpack.i, 0
  %t95.elt74.i = getelementptr inbounds nuw i8, ptr %t94.i, i64 8
  %t95.unpack75.i = load i64, ptr %t95.elt74.i, align 8
  %14 = insertvalue %ArchxAny %13, i64 %t95.unpack75.i, 1
  %t95.elt76.i = getelementptr inbounds nuw i8, ptr %t94.i, i64 16
  %t95.unpack77.i = load i64, ptr %t95.elt76.i, align 8
  %t9578.i = insertvalue %ArchxAny %14, i64 %t95.unpack77.i, 2
  call fastcc void @archx_any_drop(%ArchxAny %t9578.i)
  br label %dins.store.26.i

dins.store.26.i:                                  ; preds = %dins.dropold.25.i, %num_op.i359.i
  %t86.elt.i = select i1 %fa_is.i360.i, i64 3, i64 2
  store i64 %t86.elt.i, ptr %t94.i, align 8
  %t94.repack79.i = getelementptr inbounds nuw i8, ptr %t94.i, i64 8
  store i64 %va.pn.i364.i, ptr %t94.repack79.i, align 8
  %t94.repack81.i = getelementptr inbounds nuw i8, ptr %t94.i, i64 16
  store i64 0, ptr %t94.repack81.i, align 8
  call fastcc void @archx_any_drop(%ArchxAny %common.ret.op.i354.i)
  call fastcc void @archx_any_drop(%ArchxAny %t83.i)
  call fastcc void @archx_any_drop(%ArchxAny %oldret350)
  %tag.i.i = and i64 %bw1.i.i, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond151 = select i1 %short.i.i113, i1 true, i1 %owned.not.i.i
  br i1 %or.cond151, label %archx_str_drop.exit.i, label %do_free.i.i

do_free.i.i:                                      ; preds = %dins.store.26.i
  %raw.i.i = and i64 %bw1.i.i, -2
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  call void @free(ptr %ptr.i.i)
  br label %archx_str_drop.exit.i

archx_str_drop.exit.i:                            ; preds = %do_free.i.i, %dins.store.26.i
  %t98.i = add nuw nsw i64 %for.step.52.0602.i, 1
  %exitcond643.not.i = icmp eq i64 %t98.i, 8192
  br i1 %exitcond643.not.i, label %for.cond.27.preheader.i, label %idx.ok.21.i

idx.ok.31.i:                                      ; preds = %for.cond.27.preheader.i, %archx_str_drop.exit103.i
  %var.str_checksum.0.1609.i = phi i64 [ %var.str_checksum.0.0621.i, %for.cond.27.preheader.i ], [ %var.str_checksum.0.2.i, %archx_str_drop.exit103.i ]
  %for.p.99.0608.i = phi i64 [ 0, %for.cond.27.preheader.i ], [ %t137.i, %archx_str_drop.exit103.i ]
  %t103.i = mul nuw nsw i64 %for.p.99.0608.i, 131
  %t106.i = add nuw nsw i64 %t103.i, %t105.i
  %t107.i = and i64 %t106.i, 1023
  %t111.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %t107.i
  %t112.unpack.i = load i64, ptr %t111.i, align 8
  %15 = insertvalue %ArchxStr poison, i64 %t112.unpack.i, 0
  %t112.elt58.i = getelementptr inbounds nuw i8, ptr %t111.i, i64 8
  %t112.unpack59.i = load i64, ptr %t112.elt58.i, align 8
  %t11260.i = insertvalue %ArchxStr %15, i64 %t112.unpack59.i, 1
  %len.i372.i = and i64 %t112.unpack.i, 4294967295
  %long.i373.i = icmp samesign ult i64 %len.i372.i, 13
  %tag.i377.i = and i64 %t112.unpack59.i, 3
  %owned.not.i378.i = icmp eq i64 %tag.i377.i, 0
  %or.cond550.i = select i1 %long.i373.i, i1 true, i1 %owned.not.i378.i
  br i1 %or.cond550.i, label %archx_str_clone.exit389.i, label %dup_heap.i379.i

dup_heap.i379.i:                                  ; preds = %idx.ok.31.i
  %dst.i380.i = call noalias align 16 ptr @malloc(i64 %len.i372.i)
  %isnull.i381.i = icmp eq ptr %dst.i380.i, null
  br i1 %isnull.i381.i, label %oom.i388.i, label %copy.i382.i

oom.i388.i:                                       ; preds = %dup_heap.i379.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i382.i:                                      ; preds = %dup_heap.i379.i
  %src_i.i383.i = and i64 %t112.unpack59.i, -4
  %src.i384.i = inttoptr i64 %src_i.i383.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i380.i, ptr nonnull align 4 %src.i384.i, i64 %len.i372.i, i1 false)
  %dst_i.i385.i = ptrtoint ptr %dst.i380.i to i64
  %tagged.i386.i = or disjoint i64 %dst_i.i385.i, 1
  %out.i387.i = insertvalue %ArchxStr %t11260.i, i64 %tagged.i386.i, 1
  br label %archx_str_clone.exit389.i

archx_str_clone.exit389.i:                        ; preds = %copy.i382.i, %idx.ok.31.i
  %common.ret.op.i374.i = phi %ArchxStr [ %out.i387.i, %copy.i382.i ], [ %t11260.i, %idx.ok.31.i ]
  %ctrl.i.i109.i = load ptr, ptr %ctrl_p.i.i.i, align 8
  %c_null.i.i110.i = icmp eq ptr %ctrl.i.i109.i, null
  br i1 %c_null.i.i110.i, label %archx_str_clone.exit389.i.if.merge.35.i_crit_edge, label %do_probe.i.i111.i

archx_str_clone.exit389.i.if.merge.35.i_crit_edge: ; preds = %archx_str_clone.exit389.i
  %.pre = extractvalue %ArchxStr %common.ret.op.i374.i, 0
  %.pre312 = and i64 %.pre, 4294967295
  br label %if.merge.35.i

do_probe.i.i111.i:                                ; preds = %archx_str_clone.exit389.i
  %mask.i.i114.i = load i64, ptr %mask_p.i.i.i, align 8
  %keys.i.i115.i = load ptr, ptr %keys_p.i.i.i, align 8
  %16 = getelementptr i8, ptr %ctrl.i.i109.i, i64 %mask.i.i114.i
  %idx_base.i.i116.i = getelementptr i8, ptr %16, i64 17
  %h.i.i117.i = call fastcc i64 @archx_hash_str(%ArchxStr %common.ret.op.i374.i)
  %h2_64.i.i118.i = lshr i64 %h.i.i117.i, 57
  %h2.i.i119.i = trunc nuw nsw i64 %h2_64.i.i118.i to i8
  %h2_ins.i.i120.i = insertelement <16 x i8> poison, i8 %h2.i.i119.i, i64 0
  %h2_vec.i.i121.i = shufflevector <16 x i8> %h2_ins.i.i120.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bw0.i390.i = extractvalue %ArchxStr %common.ret.op.i374.i, 0
  %bw1.i395.i = extractvalue %ArchxStr %common.ret.op.i374.i, 1
  %bp_i.i399.i = and i64 %bw1.i395.i, -4
  %bp.i403.i = inttoptr i64 %bp_i.i399.i to ptr
  %bp4.i405.i = getelementptr inbounds nuw i8, ptr %bp.i403.i, i64 4
  %len.i394.i = and i64 %bw0.i390.i, 4294967295
  %short.i396.i = icmp samesign ult i64 %len.i394.i, 13
  %rem.i406.i = add nsw i64 %len.i394.i, -4
  br label %probe.i.i122.i

probe.i.i122.i:                                   ; preds = %next_grp.i.i160.i, %do_probe.i.i111.i
  %h.pn.i.i123.i = phi i64 [ %h.i.i117.i, %do_probe.i.i111.i ], [ %padd.i.i162.i, %next_grp.i.i160.i ]
  %step.i.i124.i = phi i64 [ 0, %do_probe.i.i111.i ], [ %step_next.i.i161.i, %next_grp.i.i160.i ]
  %pos.i.i125.i = and i64 %h.pn.i.i123.i, %mask.i.i114.i
  %gp.i.i126.i = getelementptr inbounds i8, ptr %ctrl.i.i109.i, i64 %pos.i.i125.i
  %grp.i.i127.i = load <16 x i8>, ptr %gp.i.i126.i, align 1
  %mcmp.i.i128.i = icmp eq <16 x i8> %grp.i.i127.i, %h2_vec.i.i121.i
  %mbits.i.i129.i = bitcast <16 x i1> %mcmp.i.i128.i to i16
  %has_m.not.i.i133.not603.i = icmp eq i16 %mbits.i.i129.i, 0
  br i1 %has_m.not.i.i133.not603.i, label %chk_empty.i.i156.i, label %chk_key.i.i134.preheader.i

chk_key.i.i134.preheader.i:                       ; preds = %probe.i.i122.i
  %mmask0.i.i130.i = zext i16 %mbits.i.i129.i to i32
  br label %chk_key.i.i134.i

chk_key.i.i134.i:                                 ; preds = %mbit_cont.i.i148.i, %chk_key.i.i134.preheader.i
  %mmask.i.i132604.i = phi i32 [ %mmask_next.i.i150.i, %mbit_cont.i.i148.i ], [ %mmask0.i.i130.i, %chk_key.i.i134.preheader.i ]
  %tz.i.i135.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i132604.i, i1 true)
  %tz64.i.i136.i = zext nneg i32 %tz.i.i135.i to i64
  %s_add.i.i137.i = add i64 %pos.i.i125.i, %tz64.i.i136.i
  %slot.i.i138.i = and i64 %s_add.i.i137.i, %mask.i.i114.i
  %ip.i.i139.i = getelementptr inbounds i32, ptr %idx_base.i.i116.i, i64 %slot.i.i138.i
  %didx32.i.i140.i = load i32, ptr %ip.i.i139.i, align 4
  %didx.i.i141.i = zext i32 %didx32.i.i140.i to i64
  %kp.i.i142.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i115.i, i64 %didx.i.i141.i
  %cand_k.unpack.i.i143.i = load i64, ptr %kp.i.i142.i, align 8
  %cand_k.elt1.i.i144.i = getelementptr inbounds nuw i8, ptr %kp.i.i142.i, i64 8
  %cand_k.unpack2.i.i145.i = load i64, ptr %cand_k.elt1.i.i144.i, align 8
  %w0_eq.i391.i = icmp eq i64 %cand_k.unpack.i.i143.i, %bw0.i390.i
  br i1 %w0_eq.i391.i, label %chk_len.i393.i, label %mbit_cont.i.i148.i

chk_len.i393.i:                                   ; preds = %chk_key.i.i134.i
  br i1 %short.i396.i, label %cmp_short.i409.i, label %cmp_long.i397.i

cmp_short.i409.i:                                 ; preds = %chk_len.i393.i
  %eq_s.i410.i = icmp eq i64 %cand_k.unpack2.i.i145.i, %bw1.i395.i
  br i1 %eq_s.i410.i, label %probe.i.i182.i.loopexit, label %mbit_cont.i.i148.i

cmp_long.i397.i:                                  ; preds = %chk_len.i393.i
  %ap_i.i398.i = and i64 %cand_k.unpack2.i.i145.i, -4
  %same_ptr.i400.i = icmp eq i64 %ap_i.i398.i, %bp_i.i399.i
  br i1 %same_ptr.i400.i, label %probe.i.i182.i.loopexit, label %archx_str_eq.exit411.i

archx_str_eq.exit411.i:                           ; preds = %cmp_long.i397.i
  %ap.i402.i = inttoptr i64 %ap_i.i398.i to ptr
  %ap4.i404.i = getelementptr inbounds nuw i8, ptr %ap.i402.i, i64 4
  %bcmp.i407.i = call i32 @bcmp(ptr nonnull %ap4.i404.i, ptr nonnull %bp4.i405.i, i64 %rem.i406.i)
  %eq_m.i408.i = icmp eq i32 %bcmp.i407.i, 0
  br i1 %eq_m.i408.i, label %probe.i.i182.i.loopexit, label %mbit_cont.i.i148.i

mbit_cont.i.i148.i:                               ; preds = %archx_str_eq.exit411.i, %cmp_short.i409.i, %chk_key.i.i134.i
  %mm1.i.i149.i = add nsw i32 %mmask.i.i132604.i, -1
  %mmask_next.i.i150.i = and i32 %mm1.i.i149.i, %mmask.i.i132604.i
  %has_m.not.i.i133.not.i = icmp eq i32 %mmask_next.i.i150.i, 0
  br i1 %has_m.not.i.i133.not.i, label %chk_empty.i.i156.i, label %chk_key.i.i134.i

chk_empty.i.i156.i:                               ; preds = %mbit_cont.i.i148.i, %probe.i.i122.i
  %ecmp.i.i157.i = icmp eq <16 x i8> %grp.i.i127.i, splat (i8 -128)
  %ebits.i.i158.i = bitcast <16 x i1> %ecmp.i.i157.i to i16
  %has_e.not.i.i159.i = icmp eq i16 %ebits.i.i158.i, 0
  br i1 %has_e.not.i.i159.i, label %next_grp.i.i160.i, label %if.merge.35.i

next_grp.i.i160.i:                                ; preds = %chk_empty.i.i156.i
  %step_next.i.i161.i = add i64 %step.i.i124.i, 16
  %padd.i.i162.i = add i64 %step_next.i.i161.i, %pos.i.i125.i
  br label %probe.i.i122.i

probe.i.i182.i.loopexit:                          ; preds = %archx_str_eq.exit411.i, %cmp_long.i397.i, %cmp_short.i409.i
  br label %probe.i.i182.i

probe.i.i182.i:                                   ; preds = %probe.i.i182.i.loopexit, %next_grp.i.i220.i
  %h.pn.i.i183.i = phi i64 [ %padd.i.i222.i, %next_grp.i.i220.i ], [ %h.i.i117.i, %probe.i.i182.i.loopexit ]
  %step.i.i184.i = phi i64 [ %step_next.i.i221.i, %next_grp.i.i220.i ], [ 0, %probe.i.i182.i.loopexit ]
  %pos.i.i185.i = and i64 %h.pn.i.i183.i, %mask.i.i114.i
  %gp.i.i186.i = getelementptr inbounds i8, ptr %ctrl.i.i109.i, i64 %pos.i.i185.i
  %grp.i.i187.i = load <16 x i8>, ptr %gp.i.i186.i, align 1
  %mcmp.i.i188.i = icmp eq <16 x i8> %grp.i.i187.i, %h2_vec.i.i121.i
  %mbits.i.i189.i = bitcast <16 x i1> %mcmp.i.i188.i to i16
  %has_m.not.i.i193606.i = icmp eq i16 %mbits.i.i189.i, 0
  br i1 %has_m.not.i.i193606.i, label %chk_empty.i.i216.i, label %chk_key.i.i194.preheader.i

chk_key.i.i194.preheader.i:                       ; preds = %probe.i.i182.i
  %mmask0.i.i190.i = zext i16 %mbits.i.i189.i to i32
  br label %chk_key.i.i194.i

chk_key.i.i194.i:                                 ; preds = %mbit_cont.i.i208.i, %chk_key.i.i194.preheader.i
  %mmask.i.i192607.i = phi i32 [ %mmask_next.i.i210.i, %mbit_cont.i.i208.i ], [ %mmask0.i.i190.i, %chk_key.i.i194.preheader.i ]
  %tz.i.i195.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i192607.i, i1 true)
  %tz64.i.i196.i = zext nneg i32 %tz.i.i195.i to i64
  %s_add.i.i197.i = add i64 %pos.i.i185.i, %tz64.i.i196.i
  %slot.i.i198.i = and i64 %s_add.i.i197.i, %mask.i.i114.i
  %ip.i.i199.i = getelementptr inbounds i32, ptr %idx_base.i.i116.i, i64 %slot.i.i198.i
  %didx32.i.i200.i = load i32, ptr %ip.i.i199.i, align 4
  %didx.i.i201.i = zext i32 %didx32.i.i200.i to i64
  %kp.i.i202.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i115.i, i64 %didx.i.i201.i
  %cand_k.unpack.i.i203.i = load i64, ptr %kp.i.i202.i, align 8
  %cand_k.elt1.i.i204.i = getelementptr inbounds nuw i8, ptr %kp.i.i202.i, i64 8
  %cand_k.unpack2.i.i205.i = load i64, ptr %cand_k.elt1.i.i204.i, align 8
  %w0_eq.i413.i = icmp eq i64 %cand_k.unpack.i.i203.i, %bw0.i390.i
  br i1 %w0_eq.i413.i, label %chk_len.i415.i, label %mbit_cont.i.i208.i

chk_len.i415.i:                                   ; preds = %chk_key.i.i194.i
  br i1 %short.i396.i, label %cmp_short.i431.i, label %cmp_long.i419.i

cmp_short.i431.i:                                 ; preds = %chk_len.i415.i
  %eq_s.i432.i = icmp eq i64 %cand_k.unpack2.i.i205.i, %bw1.i395.i
  br i1 %eq_s.i432.i, label %dget.ok.36.i, label %mbit_cont.i.i208.i

cmp_long.i419.i:                                  ; preds = %chk_len.i415.i
  %ap_i.i420.i = and i64 %cand_k.unpack2.i.i205.i, -4
  %same_ptr.i422.i = icmp eq i64 %ap_i.i420.i, %bp_i.i399.i
  br i1 %same_ptr.i422.i, label %dget.ok.36.i, label %archx_str_eq.exit433.i

archx_str_eq.exit433.i:                           ; preds = %cmp_long.i419.i
  %ap.i424.i = inttoptr i64 %ap_i.i420.i to ptr
  %ap4.i426.i = getelementptr inbounds nuw i8, ptr %ap.i424.i, i64 4
  %bcmp.i429.i = call i32 @bcmp(ptr nonnull %ap4.i426.i, ptr nonnull %bp4.i405.i, i64 %rem.i406.i)
  %eq_m.i430.i = icmp eq i32 %bcmp.i429.i, 0
  br i1 %eq_m.i430.i, label %dget.ok.36.i, label %mbit_cont.i.i208.i

mbit_cont.i.i208.i:                               ; preds = %archx_str_eq.exit433.i, %cmp_short.i431.i, %chk_key.i.i194.i
  %mm1.i.i209.i = add nsw i32 %mmask.i.i192607.i, -1
  %mmask_next.i.i210.i = and i32 %mm1.i.i209.i, %mmask.i.i192607.i
  %has_m.not.i.i193.i = icmp eq i32 %mmask_next.i.i210.i, 0
  br i1 %has_m.not.i.i193.i, label %chk_empty.i.i216.i, label %chk_key.i.i194.i

chk_empty.i.i216.i:                               ; preds = %mbit_cont.i.i208.i, %probe.i.i182.i
  %ecmp.i.i217.i = icmp eq <16 x i8> %grp.i.i187.i, splat (i8 -128)
  %ebits.i.i218.i = bitcast <16 x i1> %ecmp.i.i217.i to i16
  %has_e.not.i.i219.i = icmp eq i16 %ebits.i.i218.i, 0
  br i1 %has_e.not.i.i219.i, label %next_grp.i.i220.i, label %dget.miss.37.i

next_grp.i.i220.i:                                ; preds = %chk_empty.i.i216.i
  %step_next.i.i221.i = add i64 %step.i.i184.i, 16
  %padd.i.i222.i = add i64 %step_next.i.i221.i, %pos.i.i185.i
  br label %probe.i.i182.i

dget.miss.37.i:                                   ; preds = %chk_empty.i.i216.i
  call fastcc void @archx_key_fail()
  unreachable

dget.ok.36.i:                                     ; preds = %archx_str_eq.exit433.i, %cmp_long.i419.i, %cmp_short.i431.i
  %t127.i = load ptr, ptr %t25.i, align 8
  %t128.i = getelementptr inbounds nuw %ArchxAny, ptr %t127.i, i64 %didx.i.i201.i
  %t129.unpack.i = load i64, ptr %t128.i, align 8
  %17 = insertvalue %ArchxAny poison, i64 %t129.unpack.i, 0
  %t129.elt61.i = getelementptr inbounds nuw i8, ptr %t128.i, i64 8
  %t129.unpack62.i = load i64, ptr %t129.elt61.i, align 8
  %18 = insertvalue %ArchxAny %17, i64 %t129.unpack62.i, 1
  %t129.elt63.i = getelementptr inbounds nuw i8, ptr %t128.i, i64 16
  %t129.unpack64.i = load i64, ptr %t129.elt63.i, align 8
  %t12965.i = insertvalue %ArchxAny %18, i64 %t129.unpack64.i, 2
  %t130.i = call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t12965.i)
  %newret = extractvalue { i64, i64, i64 } %t130.i, 0
  %t133.i = icmp eq i64 %newret, 2
  br i1 %t133.i, label %any.guard.ok.38.i, label %any.guard.fail.39.i

any.guard.fail.39.i:                              ; preds = %dget.ok.36.i
  call fastcc void @archx_type_fail(ptr nonnull @.str.1)
  unreachable

any.guard.ok.38.i:                                ; preds = %dget.ok.36.i
  %oldret328 = insertvalue %ArchxAny poison, i64 %newret, 0
  %newret329 = extractvalue { i64, i64, i64 } %t130.i, 1
  %oldret330 = insertvalue %ArchxAny %oldret328, i64 %newret329, 1
  %newret331 = extractvalue { i64, i64, i64 } %t130.i, 2
  %oldret332 = insertvalue %ArchxAny %oldret330, i64 %newret331, 2
  %t134.i = add i64 %newret329, %var.str_checksum.0.1609.i
  call fastcc void @archx_any_drop(%ArchxAny %oldret332)
  br label %if.merge.35.i

if.merge.35.i:                                    ; preds = %chk_empty.i.i156.i, %archx_str_clone.exit389.i.if.merge.35.i_crit_edge, %any.guard.ok.38.i
  %len.i94.i.pre-phi = phi i64 [ %.pre312, %archx_str_clone.exit389.i.if.merge.35.i_crit_edge ], [ %len.i394.i, %any.guard.ok.38.i ], [ %len.i394.i, %chk_empty.i.i156.i ]
  %var.str_checksum.0.2.i = phi i64 [ %var.str_checksum.0.1609.i, %archx_str_clone.exit389.i.if.merge.35.i_crit_edge ], [ %t134.i, %any.guard.ok.38.i ], [ %var.str_checksum.0.1609.i, %chk_empty.i.i156.i ]
  %long.i95.i = icmp samesign ugt i64 %len.i94.i.pre-phi, 12
  br i1 %long.i95.i, label %chk_tag.i96.i, label %archx_str_drop.exit103.i

chk_tag.i96.i:                                    ; preds = %if.merge.35.i
  %w1.i97.i = extractvalue %ArchxStr %common.ret.op.i374.i, 1
  %tag.i98.i = and i64 %w1.i97.i, 1
  %owned.not.i99.i = icmp eq i64 %tag.i98.i, 0
  br i1 %owned.not.i99.i, label %archx_str_drop.exit103.i, label %do_free.i100.i

do_free.i100.i:                                   ; preds = %chk_tag.i96.i
  %raw.i101.i = and i64 %w1.i97.i, -2
  %ptr.i102.i = inttoptr i64 %raw.i101.i to ptr
  call void @free(ptr %ptr.i102.i)
  br label %archx_str_drop.exit103.i

archx_str_drop.exit103.i:                         ; preds = %do_free.i100.i, %chk_tag.i96.i, %if.merge.35.i
  %t137.i = add nuw nsw i64 %for.p.99.0608.i, 1
  %exitcond644.not.i = icmp eq i64 %t137.i, 2048
  br i1 %exitcond644.not.i, label %for.end.30.i, label %idx.ok.31.i

for.end.30.i:                                     ; preds = %archx_str_drop.exit103.i
  %ctrl.i.i229.i = load ptr, ptr %ctrl_p.i.i.i, align 8
  %c_null.i.i230.i = icmp eq ptr %ctrl.i.i229.i, null
  br i1 %c_null.i.i230.i, label %dget2.merge.47.i, label %archx_hash_str.exit.i

archx_hash_str.exit.i:                            ; preds = %for.end.30.i
  %mask.i.i234.i = load i64, ptr %mask_p.i.i.i, align 8
  %keys.i.i235.i = load ptr, ptr %keys_p.i.i.i, align 8
  %19 = getelementptr i8, ptr %ctrl.i.i229.i, i64 %mask.i.i234.i
  %idx_base.i.i236.i = getelementptr i8, ptr %19, i64 17
  br label %probe.i.i242.i

probe.i.i242.i:                                   ; preds = %next_grp.i.i280.i, %archx_hash_str.exit.i
  %h.pn.i.i243.i = phi i64 [ 479829472233321983, %archx_hash_str.exit.i ], [ %padd.i.i282.i, %next_grp.i.i280.i ]
  %step.i.i244.i = phi i64 [ 0, %archx_hash_str.exit.i ], [ %step_next.i.i281.i, %next_grp.i.i280.i ]
  %pos.i.i245.i = and i64 %h.pn.i.i243.i, %mask.i.i234.i
  %gp.i.i246.i = getelementptr inbounds i8, ptr %ctrl.i.i229.i, i64 %pos.i.i245.i
  %grp.i.i247.i = load <16 x i8>, ptr %gp.i.i246.i, align 1
  %mcmp.i.i248.i = icmp eq <16 x i8> %grp.i.i247.i, splat (i8 3)
  %mbits.i.i249.i = bitcast <16 x i1> %mcmp.i.i248.i to i16
  %has_m.not.i.i253610.i = icmp eq i16 %mbits.i.i249.i, 0
  br i1 %has_m.not.i.i253610.i, label %chk_empty.i.i276.i, label %chk_key.i.i254.preheader.i

chk_key.i.i254.preheader.i:                       ; preds = %probe.i.i242.i
  %mmask0.i.i250.i = zext i16 %mbits.i.i249.i to i32
  br label %chk_key.i.i254.i

chk_key.i.i254.i:                                 ; preds = %mbit_cont.i.i268.i, %chk_key.i.i254.preheader.i
  %mmask.i.i252611.i = phi i32 [ %mmask_next.i.i270.i, %mbit_cont.i.i268.i ], [ %mmask0.i.i250.i, %chk_key.i.i254.preheader.i ]
  %tz.i.i255.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i252611.i, i1 true)
  %tz64.i.i256.i = zext nneg i32 %tz.i.i255.i to i64
  %s_add.i.i257.i = add i64 %pos.i.i245.i, %tz64.i.i256.i
  %slot.i.i258.i = and i64 %s_add.i.i257.i, %mask.i.i234.i
  %ip.i.i259.i = getelementptr inbounds i32, ptr %idx_base.i.i236.i, i64 %slot.i.i258.i
  %didx32.i.i260.i = load i32, ptr %ip.i.i259.i, align 4
  %didx.i.i261.i = zext i32 %didx32.i.i260.i to i64
  %kp.i.i262.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i235.i, i64 %didx.i.i261.i
  %cand_k.unpack.i.i263.i = load i64, ptr %kp.i.i262.i, align 8
  %w0_eq.i434.i = icmp eq i64 %cand_k.unpack.i.i263.i, 8319108853555789841
  br i1 %w0_eq.i434.i, label %cmp_long.i439.i, label %mbit_cont.i.i268.i

cmp_long.i439.i:                                  ; preds = %chk_key.i.i254.i
  %cand_k.elt1.i.i264.i = getelementptr inbounds nuw i8, ptr %kp.i.i262.i, i64 8
  %cand_k.unpack2.i.i265.i = load i64, ptr %cand_k.elt1.i.i264.i, align 8
  %ap_i.i440.i = and i64 %cand_k.unpack2.i.i265.i, -4
  %same_ptr.i441.i = icmp eq i64 %ap_i.i440.i, ptrtoint (ptr @.str.0 to i64)
  br i1 %same_ptr.i441.i, label %if.merge.42.i, label %archx_str_eq.exit450.i

archx_str_eq.exit450.i:                           ; preds = %cmp_long.i439.i
  %ap.i443.i = inttoptr i64 %ap_i.i440.i to ptr
  %ap4.i444.i = getelementptr inbounds nuw i8, ptr %ap.i443.i, i64 4
  %bcmp.i446.i = call i32 @bcmp(ptr noundef nonnull dereferenceable(13) %ap4.i444.i, ptr noundef nonnull dereferenceable(13) getelementptr inbounds nuw (i8, ptr @.str.0, i64 4), i64 13)
  %eq_m.i447.i = icmp eq i32 %bcmp.i446.i, 0
  br i1 %eq_m.i447.i, label %if.merge.42.i, label %mbit_cont.i.i268.i

mbit_cont.i.i268.i:                               ; preds = %archx_str_eq.exit450.i, %chk_key.i.i254.i
  %mm1.i.i269.i = add nsw i32 %mmask.i.i252611.i, -1
  %mmask_next.i.i270.i = and i32 %mm1.i.i269.i, %mmask.i.i252611.i
  %has_m.not.i.i253.i = icmp eq i32 %mmask_next.i.i270.i, 0
  br i1 %has_m.not.i.i253.i, label %chk_empty.i.i276.i, label %chk_key.i.i254.i

chk_empty.i.i276.i:                               ; preds = %mbit_cont.i.i268.i, %probe.i.i242.i
  %ecmp.i.i277.i = icmp eq <16 x i8> %grp.i.i247.i, splat (i8 -128)
  %ebits.i.i278.i = bitcast <16 x i1> %ecmp.i.i277.i to i16
  %has_e.not.i.i279.i = icmp eq i16 %ebits.i.i278.i, 0
  br i1 %has_e.not.i.i279.i, label %next_grp.i.i280.i, label %probe.i.i302.i

next_grp.i.i280.i:                                ; preds = %chk_empty.i.i276.i
  %step_next.i.i281.i = add i64 %step.i.i244.i, 16
  %padd.i.i282.i = add i64 %step_next.i.i281.i, %pos.i.i245.i
  br label %probe.i.i242.i

probe.i.i302.i:                                   ; preds = %chk_empty.i.i276.i, %next_grp.i.i340.i
  %h.pn.i.i303.i = phi i64 [ %padd.i.i342.i, %next_grp.i.i340.i ], [ 479829472233321983, %chk_empty.i.i276.i ]
  %step.i.i304.i = phi i64 [ %step_next.i.i341.i, %next_grp.i.i340.i ], [ 0, %chk_empty.i.i276.i ]
  %pos.i.i305.i = and i64 %h.pn.i.i303.i, %mask.i.i234.i
  %gp.i.i306.i = getelementptr inbounds i8, ptr %ctrl.i.i229.i, i64 %pos.i.i305.i
  %grp.i.i307.i = load <16 x i8>, ptr %gp.i.i306.i, align 1
  %mcmp.i.i308.i = icmp eq <16 x i8> %grp.i.i307.i, splat (i8 3)
  %mbits.i.i309.i = bitcast <16 x i1> %mcmp.i.i308.i to i16
  %has_m.not.i.i313614.i = icmp eq i16 %mbits.i.i309.i, 0
  br i1 %has_m.not.i.i313614.i, label %chk_empty.i.i336.i, label %chk_key.i.i314.preheader.i

chk_key.i.i314.preheader.i:                       ; preds = %probe.i.i302.i
  %mmask0.i.i310.i = zext i16 %mbits.i.i309.i to i32
  br label %chk_key.i.i314.i

chk_key.i.i314.i:                                 ; preds = %mbit_cont.i.i328.i, %chk_key.i.i314.preheader.i
  %mmask.i.i312615.i = phi i32 [ %mmask_next.i.i330.i, %mbit_cont.i.i328.i ], [ %mmask0.i.i310.i, %chk_key.i.i314.preheader.i ]
  %tz.i.i315.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i312615.i, i1 true)
  %tz64.i.i316.i = zext nneg i32 %tz.i.i315.i to i64
  %s_add.i.i317.i = add i64 %pos.i.i305.i, %tz64.i.i316.i
  %slot.i.i318.i = and i64 %s_add.i.i317.i, %mask.i.i234.i
  %ip.i.i319.i = getelementptr inbounds i32, ptr %idx_base.i.i236.i, i64 %slot.i.i318.i
  %didx32.i.i320.i = load i32, ptr %ip.i.i319.i, align 4
  %didx.i.i321.i = zext i32 %didx32.i.i320.i to i64
  %kp.i.i322.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i235.i, i64 %didx.i.i321.i
  %cand_k.unpack.i.i323.i = load i64, ptr %kp.i.i322.i, align 8
  %w0_eq.i491.i = icmp eq i64 %cand_k.unpack.i.i323.i, 8319108853555789841
  br i1 %w0_eq.i491.i, label %cmp_long.i496.i, label %mbit_cont.i.i328.i

cmp_long.i496.i:                                  ; preds = %chk_key.i.i314.i
  %cand_k.elt1.i.i324.i = getelementptr inbounds nuw i8, ptr %kp.i.i322.i, i64 8
  %cand_k.unpack2.i.i325.i = load i64, ptr %cand_k.elt1.i.i324.i, align 8
  %ap_i.i497.i = and i64 %cand_k.unpack2.i.i325.i, -4
  %same_ptr.i498.i = icmp eq i64 %ap_i.i497.i, ptrtoint (ptr @.str.0 to i64)
  br i1 %same_ptr.i498.i, label %dget2.hit.43.i, label %archx_str_eq.exit507.i

archx_str_eq.exit507.i:                           ; preds = %cmp_long.i496.i
  %ap.i500.i = inttoptr i64 %ap_i.i497.i to ptr
  %ap4.i501.i = getelementptr inbounds nuw i8, ptr %ap.i500.i, i64 4
  %bcmp.i503.i = call i32 @bcmp(ptr noundef nonnull dereferenceable(13) %ap4.i501.i, ptr noundef nonnull dereferenceable(13) getelementptr inbounds nuw (i8, ptr @.str.0, i64 4), i64 13)
  %eq_m.i504.i = icmp eq i32 %bcmp.i503.i, 0
  br i1 %eq_m.i504.i, label %dget2.hit.43.i, label %mbit_cont.i.i328.i

mbit_cont.i.i328.i:                               ; preds = %archx_str_eq.exit507.i, %chk_key.i.i314.i
  %mm1.i.i329.i = add nsw i32 %mmask.i.i312615.i, -1
  %mmask_next.i.i330.i = and i32 %mm1.i.i329.i, %mmask.i.i312615.i
  %has_m.not.i.i313.i = icmp eq i32 %mmask_next.i.i330.i, 0
  br i1 %has_m.not.i.i313.i, label %chk_empty.i.i336.i, label %chk_key.i.i314.i

chk_empty.i.i336.i:                               ; preds = %mbit_cont.i.i328.i, %probe.i.i302.i
  %ecmp.i.i337.i = icmp eq <16 x i8> %grp.i.i307.i, splat (i8 -128)
  %ebits.i.i338.i = bitcast <16 x i1> %ecmp.i.i337.i to i16
  %has_e.not.i.i339.i = icmp eq i16 %ebits.i.i338.i, 0
  br i1 %has_e.not.i.i339.i, label %next_grp.i.i340.i, label %dget2.merge.47.i

next_grp.i.i340.i:                                ; preds = %chk_empty.i.i336.i
  %step_next.i.i341.i = add i64 %step.i.i304.i, 16
  %padd.i.i342.i = add i64 %step_next.i.i341.i, %pos.i.i305.i
  br label %probe.i.i302.i

dget2.hit.43.i:                                   ; preds = %archx_str_eq.exit507.i, %cmp_long.i496.i
  %t148.i = load ptr, ptr %t25.i, align 8
  %t149.i = getelementptr inbounds nuw %ArchxAny, ptr %t148.i, i64 %didx.i.i321.i
  %t150.unpack.i = load i64, ptr %t149.i, align 8
  %20 = insertvalue %ArchxAny poison, i64 %t150.unpack.i, 0
  %t150.elt48.i = getelementptr inbounds nuw i8, ptr %t149.i, i64 8
  %t150.unpack49.i = load i64, ptr %t150.elt48.i, align 8
  %21 = insertvalue %ArchxAny %20, i64 %t150.unpack49.i, 1
  %t150.elt50.i = getelementptr inbounds nuw i8, ptr %t149.i, i64 16
  %t150.unpack51.i = load i64, ptr %t150.elt50.i, align 8
  %t15052.i = insertvalue %ArchxAny %21, i64 %t150.unpack51.i, 2
  %t151.i = call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t15052.i)
  %newret333 = extractvalue { i64, i64, i64 } %t151.i, 0
  %oldret334 = insertvalue %ArchxAny poison, i64 %newret333, 0
  %newret335 = extractvalue { i64, i64, i64 } %t151.i, 1
  %oldret336 = insertvalue %ArchxAny %oldret334, i64 %newret335, 1
  %newret337 = extractvalue { i64, i64, i64 } %t151.i, 2
  %oldret338 = insertvalue %ArchxAny %oldret336, i64 %newret337, 2
  br label %dget2.merge.47.i

dget2.merge.47.i:                                 ; preds = %chk_empty.i.i336.i, %dget2.hit.43.i, %for.end.30.i
  %t153.i = phi %ArchxAny [ %oldret338, %dget2.hit.43.i ], [ { i64 2, i64 3, i64 0 }, %for.end.30.i ], [ { i64 2, i64 3, i64 0 }, %chk_empty.i.i336.i ]
  %t154.i = extractvalue %ArchxAny %t153.i, 0
  %t156.i = icmp eq i64 %t154.i, 2
  br i1 %t156.i, label %any.guard.ok.48.i, label %any.guard.fail.49.i

any.guard.fail.49.i:                              ; preds = %dget2.merge.47.i
  call fastcc void @archx_type_fail(ptr nonnull @.str.1)
  unreachable

any.guard.ok.48.i:                                ; preds = %dget2.merge.47.i
  %t155.i = extractvalue %ArchxAny %t153.i, 1
  %t157.i = add i64 %t155.i, %var.str_checksum.0.2.i
  call fastcc void @archx_any_drop(%ArchxAny %t153.i)
  br label %if.merge.42.i

if.merge.42.i:                                    ; preds = %archx_str_eq.exit450.i, %cmp_long.i439.i, %any.guard.ok.48.i
  %var.str_checksum.0.3.i = phi i64 [ %t157.i, %any.guard.ok.48.i ], [ %var.str_checksum.0.2.i, %cmp_long.i439.i ], [ %var.str_checksum.0.2.i, %archx_str_eq.exit450.i ]
  %t162.i = load i64, ptr %t24.i, align 8
  %t166616.i = icmp sgt i64 %t162.i, 0
  br i1 %t166616.i, label %foritems.body.54.i, label %archx_dict_drop_s_y.exit.i

foritems.body.54.i:                               ; preds = %if.merge.42.i, %any.guard.ok.57.i
  %var.str_checksum.0.4618.i = phi i64 [ %t184.i, %any.guard.ok.57.i ], [ %var.str_checksum.0.3.i, %if.merge.42.i ]
  %foritems.idx.164.0617.i = phi i64 [ %t187.i, %any.guard.ok.57.i ], [ 0, %if.merge.42.i ]
  %t172.i = load ptr, ptr %t25.i, align 8
  %t175.i = getelementptr inbounds nuw %ArchxAny, ptr %t172.i, i64 %foritems.idx.164.0617.i
  %t176.unpack.i = load i64, ptr %t175.i, align 8
  %22 = insertvalue %ArchxAny poison, i64 %t176.unpack.i, 0
  %t176.elt53.i = getelementptr inbounds nuw i8, ptr %t175.i, i64 8
  %t176.unpack54.i = load i64, ptr %t176.elt53.i, align 8
  %23 = insertvalue %ArchxAny %22, i64 %t176.unpack54.i, 1
  %t176.elt55.i = getelementptr inbounds nuw i8, ptr %t175.i, i64 16
  %t176.unpack56.i = load i64, ptr %t176.elt55.i, align 8
  %t17657.i = insertvalue %ArchxAny %23, i64 %t176.unpack56.i, 2
  %t178.i = call fastcc { i64, i64, i64 } @archx_any_clone(%ArchxAny %t17657.i)
  %newret339 = extractvalue { i64, i64, i64 } %t178.i, 0
  %t183.i = icmp eq i64 %newret339, 2
  br i1 %t183.i, label %any.guard.ok.57.i, label %any.guard.fail.58.i

any.guard.fail.58.i:                              ; preds = %foritems.body.54.i
  call fastcc void @archx_type_fail(ptr nonnull @.str.1)
  unreachable

any.guard.ok.57.i:                                ; preds = %foritems.body.54.i
  %oldret340 = insertvalue %ArchxAny poison, i64 %newret339, 0
  %newret341 = extractvalue { i64, i64, i64 } %t178.i, 1
  %oldret342 = insertvalue %ArchxAny %oldret340, i64 %newret341, 1
  %newret343 = extractvalue { i64, i64, i64 } %t178.i, 2
  %oldret344 = insertvalue %ArchxAny %oldret342, i64 %newret343, 2
  %t184.i = add i64 %newret341, %var.str_checksum.0.4618.i
  call fastcc void @archx_any_drop(%ArchxAny %oldret344)
  %t187.i = add nuw nsw i64 %foritems.idx.164.0617.i, 1
  %exitcond645.not.i = icmp eq i64 %t187.i, %t162.i
  br i1 %exitcond645.not.i, label %foritems.end.56.i, label %foritems.body.54.i

foritems.end.56.i:                                ; preds = %any.guard.ok.57.i
  %len.i509.pr.i = load i64, ptr %t24.i, align 8
  %keys.i.i = load ptr, ptr %keys_p.i.i.i, align 8
  %vals.i.i = load ptr, ptr %t25.i, align 8
  %more9.i.i = icmp sgt i64 %len.i509.pr.i, 0
  br i1 %more9.i.i, label %d_elem.i.i, label %archx_dict_drop_s_y.exit.i

d_elem.i.i:                                       ; preds = %foritems.end.56.i, %archx_str_drop.exit.i.i
  %storemerge10.i.i = phi i64 [ %inext.i.i, %archx_str_drop.exit.i.i ], [ 0, %foritems.end.56.i ]
  %t0.i.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i, i64 %storemerge10.i.i
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
  %raw.i.i512.i = and i64 %t1.unpack2.i.i, -2
  %ptr.i.i.i = inttoptr i64 %raw.i.i512.i to ptr
  call void @free(ptr %ptr.i.i.i)
  br label %archx_str_drop.exit.i.i

archx_str_drop.exit.i.i:                          ; preds = %do_free.i.i.i, %d_elem.i.i
  %t2.i.i = getelementptr inbounds nuw %ArchxAny, ptr %vals.i.i, i64 %storemerge10.i.i
  %t3.unpack.i.i = load i64, ptr %t2.i.i, align 8
  %24 = insertvalue %ArchxAny poison, i64 %t3.unpack.i.i, 0
  %t3.elt4.i.i = getelementptr inbounds nuw i8, ptr %t2.i.i, i64 8
  %t3.unpack5.i.i = load i64, ptr %t3.elt4.i.i, align 8
  %25 = insertvalue %ArchxAny %24, i64 %t3.unpack5.i.i, 1
  %t3.elt6.i.i = getelementptr inbounds nuw i8, ptr %t2.i.i, i64 16
  %t3.unpack7.i.i = load i64, ptr %t3.elt6.i.i, align 8
  %t38.i.i = insertvalue %ArchxAny %25, i64 %t3.unpack7.i.i, 2
  call fastcc void @archx_any_drop(%ArchxAny %t38.i.i)
  %inext.i.i = add nuw nsw i64 %storemerge10.i.i, 1
  %exitcond.not.i.i = icmp eq i64 %inext.i.i, %len.i509.pr.i
  br i1 %exitcond.not.i.i, label %archx_dict_drop_s_y.exit.i, label %d_elem.i.i

archx_dict_drop_s_y.exit.i:                       ; preds = %archx_str_drop.exit.i.i, %foritems.end.56.i, %if.merge.42.i
  %var.str_checksum.0.4.lcssa660.i = phi i64 [ %t184.i, %foritems.end.56.i ], [ %var.str_checksum.0.3.i, %if.merge.42.i ], [ %t184.i, %archx_str_drop.exit.i.i ]
  %head.i.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i.i = icmp eq ptr %head.i.i, null
  br i1 %empty.i.i, label %archx_region_rewind_root.exit.i, label %archx_region_rewind_root.exit.thread.i

archx_region_rewind_root.exit.i:                  ; preds = %archx_dict_drop_s_y.exit.i
  %t190.i = add nuw nsw i64 %for.r.4.0620.i, 1
  %exitcond646.not.i = icmp eq i64 %t190.i, 120
  br i1 %exitcond646.not.i, label %archx_fn_run_str_bench.exit, label %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge

archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge: ; preds = %archx_region_rewind_root.exit.i
  %cur.i.i.i.pre.pre = load ptr, ptr %func.region.i, align 8
  %end.i.i.i.pre.pre = load ptr, ptr %.fca.1.gep.i, align 8
  br label %for.body.1.i.backedge

for.body.1.i.backedge:                            ; preds = %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge, %archx_region_rewind_root.exit.thread.i
  %end.i.i.i.be = phi ptr [ %end.i.i.i.pre.pre, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %end.i.i, %archx_region_rewind_root.exit.thread.i ]
  %cur.i.i.i.be = phi ptr [ %cur.i.i.i.pre.pre, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %data.i.i, %archx_region_rewind_root.exit.thread.i ]
  %for.r.4.0620.i.be = phi i64 [ %t190.i, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %t190669.i, %archx_region_rewind_root.exit.thread.i ]
  br label %for.body.1.i

archx_region_rewind_root.exit.thread.i:           ; preds = %archx_dict_drop_s_y.exit.i
  %cap_ptr.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 8
  %cap.i.i = load i64, ptr %cap_ptr.i.i, align 8
  %data.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 16
  %end.i.i = getelementptr inbounds i8, ptr %data.i.i, i64 %cap.i.i
  store ptr %data.i.i, ptr %func.region.i, align 8
  store ptr %end.i.i, ptr %.fca.1.gep.i, align 8
  store ptr %head.i.i, ptr %.fca.3.gep.i, align 8
  %t190669.i = add nuw nsw i64 %for.r.4.0620.i, 1
  %exitcond646.not670.i = icmp eq i64 %t190669.i, 120
  br i1 %exitcond646.not670.i, label %loop.i.i, label %for.body.1.i.backedge

loop.i.i:                                         ; preds = %archx_region_rewind_root.exit.thread.i, %loop.i.i
  %cur.i.i = phi ptr [ %next.i.i, %loop.i.i ], [ %head.i.i, %archx_region_rewind_root.exit.thread.i ]
  %next.i.i = load ptr, ptr %cur.i.i, align 8
  call void @free(ptr nonnull %cur.i.i)
  %more.not.i.i = icmp eq ptr %next.i.i, null
  br i1 %more.not.i.i, label %archx_fn_run_str_bench.exit, label %loop.i.i

archx_fn_run_str_bench.exit:                      ; preds = %archx_region_rewind_root.exit.i, %loop.i.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  %t104 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %var.str_checksum.0.4.lcssa660.i)
  %hp.i.i115 = call noalias align 16 dereferenceable_or_null(64) ptr @calloc(i64 1, i64 64)
  %hnull.i.i116 = icmp eq ptr %hp.i.i115, null
  br i1 %hnull.i.i116, label %oom.i.i138, label %archx_dict_new.exit.i117

oom.i.i138:                                       ; preds = %archx_fn_run_str_bench.exit
  call fastcc void @archx_oom_fail()
  unreachable

archx_dict_new.exit.i117:                         ; preds = %archx_fn_run_str_bench.exit
  %h_meta_gep.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i115, i64 56
  store i64 34359740416, ptr %h_meta_gep.i.i, align 8
  %hpi.i.i = ptrtoint ptr %hp.i.i115 to i64
  %htag.i.i = or disjoint i64 %hpi.i.i, 1
  %t18.i = getelementptr inbounds nuw i8, ptr %hp.i.i115, i64 48
  br label %for.body.1.i118

for.cond.4.preheader.i:                           ; preds = %for.body.1.i118
  %ctrl_p.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i115, i64 32
  %mask_p.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i115, i64 16
  %keys_p.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i115, i64 40
  br label %for.body.5.i

for.body.1.i118:                                  ; preds = %for.body.1.i118, %archx_dict_new.exit.i117
  %for.i.2.058.i = phi i64 [ 0, %archx_dict_new.exit.i117 ], [ %t22.i120, %for.body.1.i118 ]
  %t6.i = mul nuw nsw i64 %for.i.2.058.i, 17
  %t7.i = add nuw nsw i64 %t6.i, 3
  %26 = trunc nuw nsw i64 %for.i.2.058.i to i32
  %27 = mul nuw nsw i32 %26, 31
  %t12.lhs.trunc.i = add nuw nsw i32 %27, 7
  %t1255.i = urem i32 %t12.lhs.trunc.i, 100000
  %t12.zext.i = zext nneg i32 %t1255.i to i64
  %t13.i = call fastcc i64 @archx_dict_upsert_i64(i64 %htag.i.i, i64 %t7.i)
  %t19.i = load ptr, ptr %t18.i, align 16
  %t20.i119 = getelementptr inbounds i64, ptr %t19.i, i64 %t13.i
  store i64 %t12.zext.i, ptr %t20.i119, align 8
  %t22.i120 = add nuw nsw i64 %for.i.2.058.i, 1
  %exitcond.not.i121 = icmp eq i64 %t22.i120, 32768
  br i1 %exitcond.not.i121, label %for.cond.4.preheader.i, label %for.body.1.i118

for.body.5.i:                                     ; preds = %archx_dict_erase_slot.exit.i, %for.cond.4.preheader.i
  %for.i.24.062.i = phi i64 [ 0, %for.cond.4.preheader.i ], [ %t46.i, %archx_dict_erase_slot.exit.i ]
  %var.popped_sum.23.061.i = phi i64 [ 0, %for.cond.4.preheader.i ], [ %t44.i, %archx_dict_erase_slot.exit.i ]
  %t28.i = mul nuw nsw i64 %for.i.24.062.i, 17
  %t29.i = or disjoint i64 %t28.i, 3
  %ctrl.i.i = load ptr, ptr %ctrl_p.i.i, align 16
  %c_null.i.i = icmp eq ptr %ctrl.i.i, null
  br i1 %c_null.i.i, label %archx_dict_find_i64.exit.i, label %do_probe.i.i

do_probe.i.i:                                     ; preds = %for.body.5.i
  %mask.i.i = load i64, ptr %mask_p.i.i, align 16
  %keys.i.i122 = load ptr, ptr %keys_p.i.i, align 8
  %28 = getelementptr i8, ptr %ctrl.i.i, i64 %mask.i.i
  %idx_base.i.i = getelementptr i8, ptr %28, i64 17
  %m1.i.i.i = mul i64 %t29.i, -4658895280553007687
  %s2.i.i.i = lshr i64 %m1.i.i.i, 27
  %x2.i.i.i = xor i64 %s2.i.i.i, %m1.i.i.i
  %m2.i.i.i = mul i64 %x2.i.i.i, -7723592293110705685
  %s3.i.i.i = lshr i64 %m2.i.i.i, 31
  %x3.i.i.i = xor i64 %s3.i.i.i, %m2.i.i.i
  %h2_64.i.i = lshr i64 %m2.i.i.i, 57
  %h2.i.i = trunc nuw nsw i64 %h2_64.i.i to i8
  %h2_ins.i.i = insertelement <16 x i8> poison, i8 %h2.i.i, i64 0
  %h2_vec.i.i = shufflevector <16 x i8> %h2_ins.i.i, <16 x i8> poison, <16 x i32> zeroinitializer
  br label %probe.i.i

probe.i.i:                                        ; preds = %next_grp.i.i, %do_probe.i.i
  %h.pn.i.i = phi i64 [ %x3.i.i.i, %do_probe.i.i ], [ %padd.i.i, %next_grp.i.i ]
  %step.i.i = phi i64 [ 0, %do_probe.i.i ], [ %step_next.i.i, %next_grp.i.i ]
  %pos.i.i = and i64 %h.pn.i.i, %mask.i.i
  %gp.i.i = getelementptr inbounds i8, ptr %ctrl.i.i, i64 %pos.i.i
  %grp.i.i = load <16 x i8>, ptr %gp.i.i, align 1
  %mcmp.i.i = icmp eq <16 x i8> %grp.i.i, %h2_vec.i.i
  %mbits.i.i = bitcast <16 x i1> %mcmp.i.i to i16
  %has_m.not.i59.i = icmp eq i16 %mbits.i.i, 0
  br i1 %has_m.not.i59.i, label %chk_empty.i.i, label %chk_key.i.preheader.i

chk_key.i.preheader.i:                            ; preds = %probe.i.i
  %mmask0.i.i = zext i16 %mbits.i.i to i32
  br label %chk_key.i.i

chk_key.i.i:                                      ; preds = %mbit_cont.i.i, %chk_key.i.preheader.i
  %mmask.i60.i = phi i32 [ %mmask_next.i.i, %mbit_cont.i.i ], [ %mmask0.i.i, %chk_key.i.preheader.i ]
  %tz.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i60.i, i1 true)
  %tz64.i.i = zext nneg i32 %tz.i.i to i64
  %s_add.i.i = add i64 %pos.i.i, %tz64.i.i
  %slot.i.i = and i64 %s_add.i.i, %mask.i.i
  %ip.i.i = getelementptr inbounds i32, ptr %idx_base.i.i, i64 %slot.i.i
  %didx32.i.i = load i32, ptr %ip.i.i, align 4
  %didx.i.i = zext i32 %didx32.i.i to i64
  %kp.i.i = getelementptr inbounds nuw i64, ptr %keys.i.i122, i64 %didx.i.i
  %cand_k.i.i = load i64, ptr %kp.i.i, align 8
  %eq.i.i = icmp eq i64 %cand_k.i.i, %t29.i
  br i1 %eq.i.i, label %found.i.i, label %mbit_cont.i.i

mbit_cont.i.i:                                    ; preds = %chk_key.i.i
  %mm1.i.i = add nsw i32 %mmask.i60.i, -1
  %mmask_next.i.i = and i32 %mm1.i.i, %mmask.i60.i
  %has_m.not.i.i = icmp eq i32 %mmask_next.i.i, 0
  br i1 %has_m.not.i.i, label %chk_empty.i.i, label %chk_key.i.i

chk_empty.i.i:                                    ; preds = %mbit_cont.i.i, %probe.i.i
  %ecmp.i.i = icmp eq <16 x i8> %grp.i.i, splat (i8 -128)
  %ebits.i.i = bitcast <16 x i1> %ecmp.i.i to i16
  %has_e.not.i.i = icmp eq i16 %ebits.i.i, 0
  br i1 %has_e.not.i.i, label %next_grp.i.i, label %archx_dict_find_i64.exit.i

next_grp.i.i:                                     ; preds = %chk_empty.i.i
  %step_next.i.i = add i64 %step.i.i, 16
  %padd.i.i = add i64 %step_next.i.i, %pos.i.i
  br label %probe.i.i

found.i.i:                                        ; preds = %chk_key.i.i
  %f0.i.i = insertvalue { i64, i64 } poison, i64 %didx.i.i, 0
  %f1.i.i = insertvalue { i64, i64 } %f0.i.i, i64 %slot.i.i, 1
  br label %archx_dict_find_i64.exit.i

archx_dict_find_i64.exit.i:                       ; preds = %chk_empty.i.i, %found.i.i, %for.body.5.i
  %common.ret.op.i.i123 = phi { i64, i64 } [ %f1.i.i, %found.i.i ], [ { i64 -1, i64 -1 }, %for.body.5.i ], [ { i64 -1, i64 -1 }, %chk_empty.i.i ]
  %t33.i = extractvalue { i64, i64 } %common.ret.op.i.i123, 0
  %t35.i = icmp sgt i64 %t33.i, -1
  br i1 %t35.i, label %dpop.hit.8.i, label %dpop.miss.9.i

dpop.miss.9.i:                                    ; preds = %archx_dict_find_i64.exit.i
  call fastcc void @archx_key_fail()
  unreachable

dpop.hit.8.i:                                     ; preds = %archx_dict_find_i64.exit.i
  %t34.i = extractvalue { i64, i64 } %common.ret.op.i.i123, 1
  %t41.i124 = load ptr, ptr %t18.i, align 16
  %t42.i125 = getelementptr inbounds nuw i64, ptr %t41.i124, i64 %t33.i
  %t43.i126 = load i64, ptr %t42.i125, align 8
  %len.i.i127 = load i64, ptr %hp.i.i115, align 16
  %mask.i22.i = load i64, ptr %mask_p.i.i, align 16
  %keys.i24.i = load ptr, ptr %keys_p.i.i, align 8
  %meta.i.i = load i64, ptr %h_meta_gep.i.i, align 8
  %29 = getelementptr i8, ptr %ctrl.i.i, i64 %mask.i22.i
  %idx_base.i25.i = getelementptr i8, ptr %29, i64 17
  %sp_ip.i.i = getelementptr inbounds i32, ptr %idx_base.i25.i, i64 %t34.i
  %d_idx32.i.i = load i32, ptr %sp_ip.i.i, align 4
  %d_idx.i.i = zext i32 %d_idx32.i.i to i64
  %p.i.i.i = getelementptr inbounds i8, ptr %ctrl.i.i, i64 %t34.i
  store i8 -2, ptr %p.i.i.i, align 1
  %mir.i.i.i = icmp ult i64 %t34.i, 16
  br i1 %mir.i.i.i, label %do_mir.i.i.i, label %archx_dict_set_ctrl.exit.i.i

do_mir.i.i.i:                                     ; preds = %dpop.hit.8.i
  %30 = getelementptr i8, ptr %29, i64 1
  %mp.i.i.i = getelementptr i8, ptr %30, i64 %t34.i
  store i8 -2, ptr %mp.i.i.i, align 1
  br label %archx_dict_set_ctrl.exit.i.i

archx_dict_set_ctrl.exit.i.i:                     ; preds = %do_mir.i.i.i, %dpop.hit.8.i
  %last.i.i = add i64 %len.i.i127, -1
  store i64 %last.i.i, ptr %hp.i.i115, align 16
  %need_swap.i.i = icmp sgt i64 %last.i.i, %d_idx.i.i
  br i1 %need_swap.i.i, label %do_swap.i.i, label %archx_dict_erase_slot.exit.i

do_swap.i.i:                                      ; preds = %archx_dict_set_ctrl.exit.i.i
  %kind.i.i = and i64 %meta.i.i, 255
  %ksz_sh.i.i = lshr i64 %meta.i.i, 8
  %ksz.i.i = and i64 %ksz_sh.i.i, 16777215
  %kd_off.i.i = mul nuw nsw i64 %ksz.i.i, %d_idx.i.i
  %kl_off.i.i = mul i64 %ksz.i.i, %last.i.i
  %kd_p.i.i = getelementptr inbounds nuw i8, ptr %keys.i24.i, i64 %kd_off.i.i
  %kl_p.i.i = getelementptr inbounds i8, ptr %keys.i24.i, i64 %kl_off.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %kd_p.i.i, ptr nonnull align 1 %kl_p.i.i, i64 %ksz.i.i, i1 false)
  %has_v.not.i.i = icmp ult i64 %meta.i.i, 4294967296
  br i1 %has_v.not.i.i, label %fix_sparse.i.i, label %swap_v.i.i

swap_v.i.i:                                       ; preds = %do_swap.i.i
  %vsz.i.i = lshr i64 %meta.i.i, 32
  %vd_off.i.i = mul nuw i64 %vsz.i.i, %d_idx.i.i
  %vl_off.i.i = mul i64 %vsz.i.i, %last.i.i
  %vd_p.i.i = getelementptr inbounds i8, ptr %t41.i124, i64 %vd_off.i.i
  %vl_p.i.i = getelementptr inbounds i8, ptr %t41.i124, i64 %vl_off.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %vd_p.i.i, ptr nonnull align 1 %vl_p.i.i, i64 %vsz.i.i, i1 false)
  br label %fix_sparse.i.i

fix_sparse.i.i:                                   ; preds = %swap_v.i.i, %do_swap.i.i
  %h.i.i = call fastcc i64 @archx_dict_key_hash_at(ptr %keys.i24.i, i64 %d_idx.i.i, i64 %kind.i.i)
  %h2_64.i26.i = lshr i64 %h.i.i, 57
  %h2.i27.i = trunc nuw nsw i64 %h2_64.i26.i to i8
  %h2_ins.i28.i = insertelement <16 x i8> poison, i8 %h2.i27.i, i64 0
  %h2_vec.i29.i = shufflevector <16 x i8> %h2_ins.i28.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %last32.i.i = trunc i64 %last.i.i to i32
  br label %fprobe.i.i

fprobe.i.i:                                       ; preds = %fnext_grp.i.i, %fix_sparse.i.i
  %h.pn.i30.i = phi i64 [ %h.i.i, %fix_sparse.i.i ], [ %padd.i45.i, %fnext_grp.i.i ]
  %step.i31.i = phi i64 [ 0, %fix_sparse.i.i ], [ %step_next.i44.i, %fnext_grp.i.i ]
  %pos.i32.i = and i64 %h.pn.i30.i, %mask.i22.i
  %gp.i33.i = getelementptr inbounds i8, ptr %ctrl.i.i, i64 %pos.i32.i
  %grp.i34.i = load <16 x i8>, ptr %gp.i33.i, align 1
  %mcmp.i35.i = icmp eq <16 x i8> %grp.i34.i, %h2_vec.i29.i
  %mbits.i36.i = bitcast <16 x i1> %mcmp.i35.i to i16
  %has_m.not1.i.i = icmp eq i16 %mbits.i36.i, 0
  br i1 %has_m.not1.i.i, label %fnext_grp.i.i, label %fchk.preheader.i.i

fchk.preheader.i.i:                               ; preds = %fprobe.i.i
  %mmask0.i37.i = zext i16 %mbits.i36.i to i32
  br label %fchk.i.i

fchk.i.i:                                         ; preds = %fbit_cont.i.i, %fchk.preheader.i.i
  %mmask2.i.i = phi i32 [ %mmask_next.i42.i, %fbit_cont.i.i ], [ %mmask0.i37.i, %fchk.preheader.i.i ]
  %tz.i38.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask2.i.i, i1 true)
  %tz64.i39.i = zext nneg i32 %tz.i38.i to i64
  %s_add.i40.i = add i64 %pos.i32.i, %tz64.i39.i
  %cand.i.i = and i64 %s_add.i40.i, %mask.i22.i
  %cip.i.i = getelementptr inbounds i32, ptr %idx_base.i25.i, i64 %cand.i.i
  %cv.i.i = load i32, ptr %cip.i.i, align 4
  %hit.i.i = icmp eq i32 %cv.i.i, %last32.i.i
  br i1 %hit.i.i, label %fupdate.i.i, label %fbit_cont.i.i

fbit_cont.i.i:                                    ; preds = %fchk.i.i
  %mm1.i41.i = add nsw i32 %mmask2.i.i, -1
  %mmask_next.i42.i = and i32 %mm1.i41.i, %mmask2.i.i
  %has_m.not.i43.i = icmp eq i32 %mmask_next.i42.i, 0
  br i1 %has_m.not.i43.i, label %fnext_grp.i.i, label %fchk.i.i

fnext_grp.i.i:                                    ; preds = %fbit_cont.i.i, %fprobe.i.i
  %step_next.i44.i = add i64 %step.i31.i, 16
  %padd.i45.i = add i64 %step_next.i44.i, %pos.i32.i
  br label %fprobe.i.i

fupdate.i.i:                                      ; preds = %fchk.i.i
  %cip.i.i.le = getelementptr inbounds i32, ptr %idx_base.i25.i, i64 %cand.i.i
  store i32 %d_idx32.i.i, ptr %cip.i.i.le, align 4
  br label %archx_dict_erase_slot.exit.i

archx_dict_erase_slot.exit.i:                     ; preds = %fupdate.i.i, %archx_dict_set_ctrl.exit.i.i
  %t44.i = add i64 %t43.i126, %var.popped_sum.23.061.i
  %t46.i = add nuw nsw i64 %for.i.24.062.i, 4
  %t26.i128 = icmp samesign ult i64 %for.i.24.062.i, 32764
  br i1 %t26.i128, label %for.body.5.i, label %for.body.11.i

for.body.11.i:                                    ; preds = %archx_dict_erase_slot.exit.i, %for.body.11.i
  %for.j.47.063.i = phi i64 [ %t66.i, %for.body.11.i ], [ 0, %archx_dict_erase_slot.exit.i ]
  %t51.i129 = mul nuw nsw i64 %for.j.47.063.i, 13
  %t52.i = add nuw nsw i64 %t51.i129, 1000000
  %t55.i = mul nuw nsw i64 %for.j.47.063.i, 5
  %t56.i130 = add nuw nsw i64 %t55.i, 1
  %t57.i = call fastcc i64 @archx_dict_upsert_i64(i64 %htag.i.i, i64 %t52.i)
  %t63.i = load ptr, ptr %t18.i, align 16
  %t64.i132 = getelementptr inbounds i64, ptr %t63.i, i64 %t57.i
  store i64 %t56.i130, ptr %t64.i132, align 8
  %t66.i = add nuw nsw i64 %for.j.47.063.i, 1
  %exitcond72.not.i = icmp eq i64 %t66.i, 8192
  br i1 %exitcond72.not.i, label %dlen.load.15.i, label %for.body.11.i

dlen.load.15.i:                                   ; preds = %for.body.11.i
  %t72.i = load i64, ptr %hp.i.i115, align 16
  %t74.i = add i64 %t72.i, %t44.i
  %t8764.i = icmp sgt i64 %t72.i, 0
  %t92.i = load ptr, ptr %keys_p.i.i, align 8
  %t93.i133 = load ptr, ptr %t18.i, align 16
  %xtraiter = and i64 %t72.i, 1
  %31 = icmp eq i64 %t72.i, 1
  %unroll_iter = and i64 %t72.i, 9223372036854775806
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br label %dlen.load.22.i

dlen.load.22.i:                                   ; preds = %for.step.19.i, %dlen.load.15.i
  %for._pass.76.068.i = phi i64 [ 0, %dlen.load.15.i ], [ %t105.i134, %for.step.19.i ]
  %var.int_checksum.75.067.i = phi i64 [ %t74.i, %dlen.load.15.i ], [ %var.int_checksum.75.1.lcssa.i, %for.step.19.i ]
  br i1 %t8764.i, label %foritems.body.25.i.preheader, label %for.step.19.i

foritems.body.25.i.preheader:                     ; preds = %dlen.load.22.i
  br i1 %31, label %for.step.19.i.loopexit.unr-lcssa, label %foritems.body.25.i

foritems.body.25.i:                               ; preds = %foritems.body.25.i.preheader, %foritems.body.25.i
  %foritems.idx.85.066.i = phi i64 [ %t103.i137.1, %foritems.body.25.i ], [ 0, %foritems.body.25.i.preheader ]
  %var.int_checksum.75.165.i = phi i64 [ %t101.i.1, %foritems.body.25.i ], [ %var.int_checksum.75.067.i, %foritems.body.25.i.preheader ]
  %niter = phi i64 [ %niter.next.1, %foritems.body.25.i ], [ 0, %foritems.body.25.i.preheader ]
  %t94.i136 = getelementptr inbounds nuw i64, ptr %t92.i, i64 %foritems.idx.85.066.i
  %t95.i = load i64, ptr %t94.i136, align 8
  %t96.i = getelementptr inbounds nuw i64, ptr %t93.i133, i64 %foritems.idx.85.066.i
  %t97.i = load i64, ptr %t96.i, align 8
  %t99.i = srem i64 %t95.i, 997
  %t100.i = mul i64 %t99.i, %t97.i
  %t101.i = add i64 %t100.i, %var.int_checksum.75.165.i
  %t103.i137 = or disjoint i64 %foritems.idx.85.066.i, 1
  %t94.i136.1 = getelementptr inbounds nuw i64, ptr %t92.i, i64 %t103.i137
  %t95.i.1 = load i64, ptr %t94.i136.1, align 8
  %t96.i.1 = getelementptr inbounds nuw i64, ptr %t93.i133, i64 %t103.i137
  %t97.i.1 = load i64, ptr %t96.i.1, align 8
  %t99.i.1 = srem i64 %t95.i.1, 997
  %t100.i.1 = mul i64 %t99.i.1, %t97.i.1
  %t101.i.1 = add i64 %t100.i.1, %t101.i
  %t103.i137.1 = add nuw nsw i64 %foritems.idx.85.066.i, 2
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1 = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1, label %for.step.19.i.loopexit.unr-lcssa, label %foritems.body.25.i

for.step.19.i.loopexit.unr-lcssa:                 ; preds = %foritems.body.25.i, %foritems.body.25.i.preheader
  %t101.i.lcssa.ph = phi i64 [ poison, %foritems.body.25.i.preheader ], [ %t101.i.1, %foritems.body.25.i ]
  %foritems.idx.85.066.i.unr = phi i64 [ 0, %foritems.body.25.i.preheader ], [ %t103.i137.1, %foritems.body.25.i ]
  %var.int_checksum.75.165.i.unr = phi i64 [ %var.int_checksum.75.067.i, %foritems.body.25.i.preheader ], [ %t101.i.1, %foritems.body.25.i ]
  br i1 %lcmp.mod.not, label %for.step.19.i, label %foritems.body.25.i.epil

foritems.body.25.i.epil:                          ; preds = %for.step.19.i.loopexit.unr-lcssa
  %t94.i136.epil = getelementptr inbounds nuw i64, ptr %t92.i, i64 %foritems.idx.85.066.i.unr
  %t95.i.epil = load i64, ptr %t94.i136.epil, align 8
  %t96.i.epil = getelementptr inbounds nuw i64, ptr %t93.i133, i64 %foritems.idx.85.066.i.unr
  %t97.i.epil = load i64, ptr %t96.i.epil, align 8
  %t99.i.epil = srem i64 %t95.i.epil, 997
  %t100.i.epil = mul i64 %t99.i.epil, %t97.i.epil
  %t101.i.epil = add i64 %t100.i.epil, %var.int_checksum.75.165.i.unr
  br label %for.step.19.i

for.step.19.i:                                    ; preds = %foritems.body.25.i.epil, %for.step.19.i.loopexit.unr-lcssa, %dlen.load.22.i
  %var.int_checksum.75.1.lcssa.i = phi i64 [ %var.int_checksum.75.067.i, %dlen.load.22.i ], [ %t101.i.lcssa.ph, %for.step.19.i.loopexit.unr-lcssa ], [ %t101.i.epil, %foritems.body.25.i.epil ]
  %t105.i134 = add nuw nsw i64 %for._pass.76.068.i, 1
  %exitcond74.not.i = icmp eq i64 %t105.i134, 40
  br i1 %exitcond74.not.i, label %archx_fn_run_int_bench.exit, label %dlen.load.22.i

archx_fn_run_int_bench.exit:                      ; preds = %for.step.19.i
  %ctrl.i54.i = load ptr, ptr %ctrl_p.i.i, align 16
  call void @free(ptr %ctrl.i54.i)
  call void @free(ptr %t92.i)
  call void @free(ptr %t93.i133)
  call void @free(ptr %hp.i.i115)
  %t106 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %var.int_checksum.75.1.lcssa.i)
  br label %loop.i

loop.i:                                           ; preds = %archx_fn_run_int_bench.exit, %archx_str_drop.exit.i148
  %i.i = phi i64 [ %inext.i, %archx_str_drop.exit.i148 ], [ 0, %archx_fn_run_int_bench.exit ]
  %ep.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %i.i
  %t0.unpack.i = load i64, ptr %ep.i, align 8
  %t0.elt1.i = getelementptr inbounds nuw i8, ptr %ep.i, i64 8
  %t0.unpack2.i = load i64, ptr %t0.elt1.i, align 8
  %len.i.i140 = and i64 %t0.unpack.i, 4294967295
  %long.i.i141 = icmp samesign ult i64 %len.i.i140, 13
  %tag.i.i142 = and i64 %t0.unpack2.i, 1
  %owned.not.i.i143 = icmp eq i64 %tag.i.i142, 0
  %or.cond.i144 = select i1 %long.i.i141, i1 true, i1 %owned.not.i.i143
  br i1 %or.cond.i144, label %archx_str_drop.exit.i148, label %do_free.i.i145

do_free.i.i145:                                   ; preds = %loop.i
  %raw.i.i146 = and i64 %t0.unpack2.i, -2
  %ptr.i.i147 = inttoptr i64 %raw.i.i146 to ptr
  call void @free(ptr %ptr.i.i147)
  br label %archx_str_drop.exit.i148

archx_str_drop.exit.i148:                         ; preds = %do_free.i.i145, %loop.i
  %inext.i = add nuw nsw i64 %i.i, 1
  %exitcond.not.i149 = icmp eq i64 %i.i, 1023
  br i1 %exitcond.not.i149, label %check.free.i, label %loop.i

check.free.i:                                     ; preds = %archx_str_drop.exit.i148
  %is_heap.i = icmp sgt i64 %var.vocab.4.sroa.13.3, 0
  br i1 %is_heap.i, label %do.free.i, label %archx_vec_drop_s.exit

do.free.i:                                        ; preds = %check.free.i
  call void @free(ptr nonnull %var.vocab.4.sroa.26.3)
  br label %archx_vec_drop_s.exit

archx_vec_drop_s.exit:                            ; preds = %check.free.i, %do.free.i
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

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #11

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #3

; Function Attrs: nofree nounwind
declare noundef i32 @sprintf(ptr noalias noundef writeonly captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.fptosi.sat.i64.f64(double) #11

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_key_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.1)
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
define private fastcc i64 @archx_hash_str(%ArchxStr %s) unnamed_addr #12 {
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
define private fastcc i64 @archx_dict_upsert_i64(i64 range(i64 1, 0) %d, i64 %key) unnamed_addr #0 {
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
  %found_idx.pn = phi i64 [ %d_idx, %archx_dict_set_ctrl.exit ], [ %didx.i, %chk_key.i ]
  ret i64 %found_idx.pn

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

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.cttz.i32(i32, i1 immarg) #11

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.abs.i64(i64, i1 immarg) #13

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smin.i64(i64, i64) #13

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #13

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
attributes #12 = { nofree norecurse nosync nounwind memory(read, inaccessiblemem: none) }
attributes #13 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #14 = { nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #15 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.unroll.disable"}
