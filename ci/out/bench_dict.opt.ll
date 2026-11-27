; ModuleID = '/tmp/bench_dict.ll'
source_filename = "/tmp/bench_dict.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxStr = type { i64, i64 }

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.0 = private unnamed_addr constant [18 x i8] c"missing_token_xyz\00", align 4
@.str.1 = private unnamed_addr constant [18 x i8] c"identifier_token_\00", align 4
@.fmt.i64s = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@str = private unnamed_addr constant [38 x i8] c"archx runtime panic: integer overflow\00", align 1
@str.1 = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1
@str.2 = private unnamed_addr constant [57 x i8] c"archx runtime panic: KeyError: key not found in dict/set\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %func.region.i = alloca %ArchxRegion, align 8
  %sso.i.i80 = alloca [16 x i8], align 8
  %buf.i81 = alloca [32 x i8], align 8
  %sso.i.i = alloca [16 x i8], align 8
  %buf.i = alloca [32 x i8], align 8
  %btmp.i30 = alloca [12 x i8], align 4
  %btmp.i = alloca [12 x i8], align 4
  %out_sso.i.sroa.6 = alloca i64, align 8
  %btmp4.i74 = getelementptr inbounds nuw i8, ptr %btmp.i30, i64 4
  %btmp4.i = getelementptr inbounds nuw i8, ptr %btmp.i, i64 4
  %sso.i.i80.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i80, i64 4
  %sso.i.i80.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i80, i64 8
  %sso.i.i.4.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 4
  %sso.i.i.8.sroa_idx = getelementptr inbounds nuw i8, ptr %sso.i.i, i64 8
  br label %mod.ok.5

mod.ok.5:                                         ; preds = %entry, %for.step.2
  %for.i.5.0202 = phi i64 [ 0, %entry ], [ %t114, %for.step.2 ]
  %var.vocab.4.sroa.13.0200 = phi i64 [ 0, %entry ], [ %var.vocab.4.sroa.13.3, %for.step.2 ]
  %var.vocab.4.sroa.26.0199 = phi ptr [ null, %entry ], [ %var.vocab.4.sroa.26.3, %for.step.2 ]
  %t15 = and i64 %for.i.5.0202, 1
  %t23 = icmp eq i64 %t15, 0
  br i1 %t23, label %if.then.6, label %if.else.7

if.then.6:                                        ; preds = %mod.ok.5
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i)
  %n32.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 range(i64 -9223372036854775808, 1024) %for.i.5.0202)
  %len.i78 = sext i32 %n32.i to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i)
  %z.i.i = icmp slt i32 %n32.i, 1
  br i1 %z.i.i, label %archx_str_from_int.exit, label %chk_sso.i.i

oom.i.i:                                          ; preds = %alloc_heap.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i:                                      ; preds = %if.then.6
  %short.i.i = icmp samesign ult i32 %n32.i, 13
  br i1 %short.i.i, label %pack_sso.i.i, label %alloc_heap.i.i

pack_sso.i.i:                                     ; preds = %chk_sso.i.i
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i, i8 0, i64 16, i1 false)
  store i32 %n32.i, ptr %sso.i.i, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i.4.sroa_idx, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, 2147483648) %len.i78, i1 false)
  %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i = load i64, ptr %sso.i.i, align 8
  %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i = load i64, ptr %sso.i.i.8.sroa_idx, align 8
  %ss0.i.i = insertvalue %ArchxStr poison, i64 %sso.i.i.0.sso.i.i.0.sso.i.i.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i, 0
  %ss1.i.i = insertvalue %ArchxStr %ss0.i.i, i64 %sso.i.i.8.sso.i.i.8.sso.i.i.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i, 1
  br label %archx_str_from_int.exit

alloc_heap.i.i:                                   ; preds = %chk_sso.i.i
  %hp.i.i = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483648) %len.i78)
  %hnull.i.i = icmp eq ptr %hp.i.i, null
  br i1 %hnull.i.i, label %oom.i.i, label %copy_long.i.i

copy_long.i.i:                                    ; preds = %alloc_heap.i.i
  %hp_i.i.i = ptrtoint ptr %hp.i.i to i64
  %htagged.i.i = or disjoint i64 %hp_i.i.i, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i, ptr nonnull readonly align 8 %buf.i, i64 range(i64 -2147483648, 2147483648) %len.i78, i1 false)
  %pref32.i.i = load i32, ptr %hp.i.i, align 16
  %pref64.i.i = zext i32 %pref32.i.i to i64
  %pref_sh.i.i = shl nuw i64 %pref64.i.i, 32
  %w0_out.i.i = or disjoint i64 %pref_sh.i.i, %len.i78
  %ls0.i.i = insertvalue %ArchxStr poison, i64 %w0_out.i.i, 0
  %ls1.i.i = insertvalue %ArchxStr %ls0.i.i, i64 %htagged.i.i, 1
  br label %archx_str_from_int.exit

archx_str_from_int.exit:                          ; preds = %if.then.6, %pack_sso.i.i, %copy_long.i.i
  %common.ret.op.i.i = phi %ArchxStr [ %ss1.i.i, %pack_sso.i.i ], [ %ls1.i.i, %copy_long.i.i ], [ zeroinitializer, %if.then.6 ]
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
  %bptr.i293 = phi ptr [ %blptr.i, %build.i.thread ], [ %btmp.i, %build.i ]
  %hp.i = tail call noalias align 16 ptr @malloc(i64 %tot.i)
  %hnull.i = icmp eq ptr %hp.i, null
  br i1 %hnull.i, label %oom.i, label %copy_long.i

copy_long.i:                                      ; preds = %alloc_heap.i
  %hp_i.i = ptrtoint ptr %hp.i to i64
  %htagged.i = or disjoint i64 %hp_i.i, 1
  store i32 1600876404, ptr %hp.i, align 16
  %dst_b.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %dst_b.i, ptr nonnull align 1 %bptr.i293, i64 %blen.i, i1 false)
  %w0_out.i = or disjoint i64 %tot.i, 6875711800118083584
  %ls0.i = insertvalue %ArchxStr poison, i64 %w0_out.i, 0
  %ls1.i = insertvalue %ArchxStr %ls0.i, i64 %htagged.i, 1
  br label %archx_str_concat.exit

archx_str_concat.exit:                            ; preds = %archx_str_from_int.exit, %build_sso.i, %copy_long.i
  %common.ret.op.i = phi %ArchxStr [ %rs1.i, %build_sso.i ], [ %ls1.i, %copy_long.i ], [ { i64 6875711800118083588, i64 0 }, %archx_str_from_int.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  %t31 = icmp slt i64 %var.vocab.4.sroa.13.0200, 0
  %t33 = tail call i64 @llvm.abs.i64(i64 %var.vocab.4.sroa.13.0200, i1 true)
  %t34.not = icmp samesign ult i64 %for.i.5.0202, %t33
  br i1 %t34.not, label %push.store.10, label %push.calc.12

push.calc.12:                                     ; preds = %archx_str_concat.exit
  %t36 = icmp eq i64 %var.vocab.4.sroa.13.0200, 0
  %t37 = shl nuw i64 %t33, 1
  %0 = tail call i64 @llvm.smin.i64(i64 %t37, i64 140737488355328)
  %t40 = select i1 %t36, i64 4, i64 %0
  %1 = add i64 %t40, -576460752303423488
  %t43 = icmp ult i64 %1, -1152921504606846976
  br i1 %t43, label %mul.oom.13, label %mul.ok.14

mul.oom.13:                                       ; preds = %push.calc.12
  tail call fastcc void @archx_oom_fail()
  unreachable

mul.ok.14:                                        ; preds = %push.calc.12
  %t42 = shl nsw i64 %t40, 4
  %t45 = tail call i64 @llvm.umax.i64(i64 %t42, i64 1)
  br i1 %t31, label %mul.ok.18, label %push.grow.from_heap.16

mul.ok.18:                                        ; preds = %mul.ok.14
  %t51 = tail call noalias align 16 ptr @malloc(i64 %t45)
  %t52 = icmp eq ptr %t51, null
  br i1 %t52, label %alloc.oom.20, label %push.reg.copy.21

alloc.oom.20:                                     ; preds = %mul.ok.18
  tail call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.21:                                 ; preds = %mul.ok.18
  %t47 = shl nuw nsw i64 %for.i.5.0202, 4
  %t50 = tail call i64 @llvm.umax.i64(i64 %t47, i64 1)
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t51, ptr noundef nonnull align 8 dereferenceable(1) %var.vocab.4.sroa.26.0199, i64 %t50, i1 false)
  br label %push.store.10

push.grow.from_heap.16:                           ; preds = %mul.ok.14
  %t57 = tail call align 16 ptr @realloc(ptr %var.vocab.4.sroa.26.0199, i64 %t45)
  %t58 = icmp eq ptr %t57, null
  br i1 %t58, label %realloc.oom.24, label %push.store.10

realloc.oom.24:                                   ; preds = %push.grow.from_heap.16
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.10:                                    ; preds = %push.grow.from_heap.16, %push.reg.copy.21, %archx_str_concat.exit
  %var.vocab.4.sroa.26.1 = phi ptr [ %var.vocab.4.sroa.26.0199, %archx_str_concat.exit ], [ %t51, %push.reg.copy.21 ], [ %t57, %push.grow.from_heap.16 ]
  %var.vocab.4.sroa.13.1 = phi i64 [ %var.vocab.4.sroa.13.0200, %archx_str_concat.exit ], [ %t40, %push.reg.copy.21 ], [ %t40, %push.grow.from_heap.16 ]
  %t64 = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.1, i64 %for.i.5.0202
  %t26.elt = extractvalue %ArchxStr %common.ret.op.i, 0
  store i64 %t26.elt, ptr %t64, align 8
  %t64.repack16 = getelementptr inbounds nuw i8, ptr %t64, i64 8
  %t26.elt17 = extractvalue %ArchxStr %common.ret.op.i, 1
  store i64 %t26.elt17, ptr %t64.repack16, align 8
  %long.i = icmp samesign ult i64 %blen.i, 13
  %tag.i = and i64 %bw1.i, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %long.i, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %for.step.2, label %for.step.2.sink.split

if.else.7:                                        ; preds = %mod.ok.5
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i81)
  %n32.i82 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i81, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 range(i64 -9223372036854775808, 1024) %for.i.5.0202)
  %len.i83 = sext i32 %n32.i82 to i64
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %sso.i.i80)
  %z.i.i84 = icmp slt i32 %n32.i82, 1
  br i1 %z.i.i84, label %archx_str_from_int.exit108, label %chk_sso.i.i85

oom.i.i100:                                       ; preds = %alloc_heap.i.i87
  tail call fastcc void @archx_oom_fail()
  unreachable

chk_sso.i.i85:                                    ; preds = %if.else.7
  %short.i.i86 = icmp samesign ult i32 %n32.i82, 13
  br i1 %short.i.i86, label %pack_sso.i.i101, label %alloc_heap.i.i87

pack_sso.i.i101:                                  ; preds = %chk_sso.i.i85
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %sso.i.i80, i8 0, i64 16, i1 false)
  store i32 %n32.i82, ptr %sso.i.i80, align 8
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso.i.i80.4.sroa_idx, ptr nonnull readonly align 8 %buf.i81, i64 range(i64 -2147483648, 2147483648) %len.i83, i1 false)
  %sso.i.i80.0.sso.i.i80.0.sso.i.i80.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i103 = load i64, ptr %sso.i.i80, align 8
  %sso.i.i80.8.sso.i.i80.8.sso.i.i80.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i105 = load i64, ptr %sso.i.i80.8.sroa_idx, align 8
  %ss0.i.i106 = insertvalue %ArchxStr poison, i64 %sso.i.i80.0.sso.i.i80.0.sso.i.i80.0.sso.i.0.sso.i.0.sso.0.sso.0.sso.0.sw0.i.i103, 0
  %ss1.i.i107 = insertvalue %ArchxStr %ss0.i.i106, i64 %sso.i.i80.8.sso.i.i80.8.sso.i.i80.8.sso.i.8.sso.i.8.sso.8.sso.8.sso.8.sw1.i.i105, 1
  br label %archx_str_from_int.exit108

alloc_heap.i.i87:                                 ; preds = %chk_sso.i.i85
  %hp.i.i88 = tail call noalias align 16 ptr @malloc(i64 range(i64 -2147483648, 2147483648) %len.i83)
  %hnull.i.i89 = icmp eq ptr %hp.i.i88, null
  br i1 %hnull.i.i89, label %oom.i.i100, label %copy_long.i.i90

copy_long.i.i90:                                  ; preds = %alloc_heap.i.i87
  %hp_i.i.i91 = ptrtoint ptr %hp.i.i88 to i64
  %htagged.i.i92 = or disjoint i64 %hp_i.i.i91, 1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %hp.i.i88, ptr nonnull readonly align 8 %buf.i81, i64 range(i64 -2147483648, 2147483648) %len.i83, i1 false)
  %pref32.i.i93 = load i32, ptr %hp.i.i88, align 16
  %pref64.i.i94 = zext i32 %pref32.i.i93 to i64
  %pref_sh.i.i95 = shl nuw i64 %pref64.i.i94, 32
  %w0_out.i.i96 = or disjoint i64 %pref_sh.i.i95, %len.i83
  %ls0.i.i97 = insertvalue %ArchxStr poison, i64 %w0_out.i.i96, 0
  %ls1.i.i98 = insertvalue %ArchxStr %ls0.i.i97, i64 %htagged.i.i92, 1
  br label %archx_str_from_int.exit108

archx_str_from_int.exit108:                       ; preds = %if.else.7, %pack_sso.i.i101, %copy_long.i.i90
  %common.ret.op.i.i99 = phi %ArchxStr [ %ss1.i.i107, %pack_sso.i.i101 ], [ %ls1.i.i98, %copy_long.i.i90 ], [ zeroinitializer, %if.else.7 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %sso.i.i80)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %buf.i81)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %btmp.i30)
  %bw0.i32 = extractvalue %ArchxStr %common.ret.op.i.i99, 0
  %bw1.i33 = extractvalue %ArchxStr %common.ret.op.i.i99, 1
  %blen.i34 = and i64 %bw0.i32, 4294967295
  %bz.i35 = icmp eq i64 %blen.i34, 0
  br i1 %bz.i35, label %archx_str_concat.exit77, label %calc_tot.i36

calc_tot.i36:                                     ; preds = %archx_str_from_int.exit108
  %tot.i37 = add nuw nsw i64 %blen.i34, 17
  %too_big.i38 = icmp samesign ugt i64 %blen.i34, 2147483630
  br i1 %too_big.i38, label %oom.i61, label %mat_a.i39

oom.i61:                                          ; preds = %alloc_heap.i47, %calc_tot.i36
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a.i39:                                        ; preds = %calc_tot.i36
  %bshort.i40 = icmp samesign ult i64 %blen.i34, 13
  br i1 %bshort.i40, label %mat_b_short.i71, label %mat_b_long.i41

mat_b_short.i71:                                  ; preds = %mat_a.i39
  %bp4.i72 = lshr i64 %bw0.i32, 32
  %bp4_32.i73 = trunc nuw i64 %bp4.i72 to i32
  store i32 %bp4_32.i73, ptr %btmp.i30, align 4
  store i64 %bw1.i33, ptr %btmp4.i74, align 4
  br label %alloc_heap.i47

mat_b_long.i41:                                   ; preds = %mat_a.i39
  %braw.i42 = and i64 %bw1.i33, -4
  %blptr.i43 = inttoptr i64 %braw.i42 to ptr
  br label %alloc_heap.i47

alloc_heap.i47:                                   ; preds = %mat_b_short.i71, %mat_b_long.i41
  %bptr.i45 = phi ptr [ %btmp.i30, %mat_b_short.i71 ], [ %blptr.i43, %mat_b_long.i41 ]
  %hp.i48 = tail call noalias align 16 ptr @malloc(i64 %tot.i37)
  %hnull.i49 = icmp eq ptr %hp.i48, null
  br i1 %hnull.i49, label %oom.i61, label %copy_long.i50

copy_long.i50:                                    ; preds = %alloc_heap.i47
  %hp_i.i51 = ptrtoint ptr %hp.i48 to i64
  %htagged.i52 = or disjoint i64 %hp_i.i51, 1
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(17) %hp.i48, ptr noundef nonnull align 4 dereferenceable(17) @.str.1, i64 17, i1 false)
  %dst_b.i53 = getelementptr inbounds nuw i8, ptr %hp.i48, i64 17
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i53, ptr nonnull align 1 %bptr.i45, i64 %blen.i34, i1 false)
  %w0_out.i57 = or disjoint i64 %tot.i37, 7954874718954192896
  %ls0.i58 = insertvalue %ArchxStr poison, i64 %w0_out.i57, 0
  %ls1.i59 = insertvalue %ArchxStr %ls0.i58, i64 %htagged.i52, 1
  br label %archx_str_concat.exit77

archx_str_concat.exit77:                          ; preds = %archx_str_from_int.exit108, %copy_long.i50
  %common.ret.op.i60 = phi %ArchxStr [ %ls1.i59, %copy_long.i50 ], [ { i64 7954874718954192913, i64 ptrtoint (ptr @.str.1 to i64) }, %archx_str_from_int.exit108 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i30)
  %t77 = icmp slt i64 %var.vocab.4.sroa.13.0200, 0
  %t79 = tail call i64 @llvm.abs.i64(i64 %var.vocab.4.sroa.13.0200, i1 true)
  %t80.not = icmp samesign ult i64 %for.i.5.0202, %t79
  br i1 %t80.not, label %push.store.26, label %push.calc.28

push.calc.28:                                     ; preds = %archx_str_concat.exit77
  %t82 = icmp eq i64 %var.vocab.4.sroa.13.0200, 0
  %t83 = shl nuw i64 %t79, 1
  %2 = tail call i64 @llvm.smin.i64(i64 %t83, i64 140737488355328)
  %t86 = select i1 %t82, i64 4, i64 %2
  %3 = add i64 %t86, -576460752303423488
  %t89 = icmp ult i64 %3, -1152921504606846976
  br i1 %t89, label %mul.oom.29, label %mul.ok.30

mul.oom.29:                                       ; preds = %push.calc.28
  tail call fastcc void @archx_oom_fail()
  unreachable

mul.ok.30:                                        ; preds = %push.calc.28
  %t88 = shl nsw i64 %t86, 4
  %t91 = tail call i64 @llvm.umax.i64(i64 %t88, i64 1)
  br i1 %t77, label %mul.ok.34, label %push.grow.from_heap.32

mul.ok.34:                                        ; preds = %mul.ok.30
  %t97 = tail call noalias align 16 ptr @malloc(i64 %t91)
  %t98 = icmp eq ptr %t97, null
  br i1 %t98, label %alloc.oom.36, label %push.reg.copy.37

alloc.oom.36:                                     ; preds = %mul.ok.34
  tail call fastcc void @archx_oom_fail()
  unreachable

push.reg.copy.37:                                 ; preds = %mul.ok.34
  %t93 = shl nuw nsw i64 %for.i.5.0202, 4
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t97, ptr noundef nonnull align 8 dereferenceable(1) %var.vocab.4.sroa.26.0199, i64 %t93, i1 false)
  br label %push.store.26

push.grow.from_heap.32:                           ; preds = %mul.ok.30
  %t103 = tail call align 16 ptr @realloc(ptr %var.vocab.4.sroa.26.0199, i64 %t91)
  %t104 = icmp eq ptr %t103, null
  br i1 %t104, label %realloc.oom.40, label %push.store.26

realloc.oom.40:                                   ; preds = %push.grow.from_heap.32
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.26:                                    ; preds = %push.grow.from_heap.32, %push.reg.copy.37, %archx_str_concat.exit77
  %var.vocab.4.sroa.26.2 = phi ptr [ %var.vocab.4.sroa.26.0199, %archx_str_concat.exit77 ], [ %t97, %push.reg.copy.37 ], [ %t103, %push.grow.from_heap.32 ]
  %var.vocab.4.sroa.13.2 = phi i64 [ %var.vocab.4.sroa.13.0200, %archx_str_concat.exit77 ], [ %t86, %push.reg.copy.37 ], [ %t86, %push.grow.from_heap.32 ]
  %t110 = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.2, i64 %for.i.5.0202
  %t72.elt = extractvalue %ArchxStr %common.ret.op.i60, 0
  store i64 %t72.elt, ptr %t110, align 8
  %t110.repack14 = getelementptr inbounds nuw i8, ptr %t110, i64 8
  %t72.elt15 = extractvalue %ArchxStr %common.ret.op.i60, 1
  store i64 %t72.elt15, ptr %t110.repack14, align 8
  %long.i20 = icmp samesign ult i64 %blen.i34, 13
  %tag.i23 = and i64 %bw1.i33, 1
  %owned.not.i24 = icmp eq i64 %tag.i23, 0
  %or.cond142 = select i1 %long.i20, i1 true, i1 %owned.not.i24
  br i1 %or.cond142, label %for.step.2, label %for.step.2.sink.split

for.step.2.sink.split:                            ; preds = %push.store.26, %push.store.10
  %bw1.i33.sink = phi i64 [ %bw1.i, %push.store.10 ], [ %bw1.i33, %push.store.26 ]
  %var.vocab.4.sroa.26.3.ph = phi ptr [ %var.vocab.4.sroa.26.1, %push.store.10 ], [ %var.vocab.4.sroa.26.2, %push.store.26 ]
  %var.vocab.4.sroa.13.3.ph = phi i64 [ %var.vocab.4.sroa.13.1, %push.store.10 ], [ %var.vocab.4.sroa.13.2, %push.store.26 ]
  %raw.i26 = and i64 %bw1.i33.sink, -2
  %ptr.i27 = inttoptr i64 %raw.i26 to ptr
  tail call void @free(ptr %ptr.i27)
  br label %for.step.2

for.step.2:                                       ; preds = %for.step.2.sink.split, %push.store.26, %push.store.10
  %var.vocab.4.sroa.26.3 = phi ptr [ %var.vocab.4.sroa.26.1, %push.store.10 ], [ %var.vocab.4.sroa.26.2, %push.store.26 ], [ %var.vocab.4.sroa.26.3.ph, %for.step.2.sink.split ]
  %var.vocab.4.sroa.13.3 = phi i64 [ %var.vocab.4.sroa.13.1, %push.store.10 ], [ %var.vocab.4.sroa.13.2, %push.store.26 ], [ %var.vocab.4.sroa.13.3.ph, %for.step.2.sink.split ]
  %t114 = add nuw nsw i64 %for.i.5.0202, 1
  %exitcond.not = icmp eq i64 %t114, 1024
  br i1 %exitcond.not, label %for.end.3, label %mod.ok.5

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
  %var.str_checksum.0.0608.i = phi i64 [ 0, %for.end.3 ], [ %var.str_checksum.0.3.lcssa644.i, %for.body.1.i.backedge ]
  %for.r.4.0607.i = phi i64 [ 0, %for.end.3 ], [ %for.r.4.0607.i.be, %for.body.1.i.backedge ]
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
  %common.ret.op.i.i.i = phi ptr [ %cur.i.i.i, %fast.i.i.i ], [ %res.i.i.i, %fallback.i.i.i ]
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(64) %common.ret.op.i.i.i, i8 0, i64 64, i1 false)
  %r_reg_gep.i.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i.i, i64 24
  store ptr %func.region.i, ptr %r_reg_gep.i.i, align 8
  %r_meta_gep.i.i = getelementptr inbounds nuw i8, ptr %common.ret.op.i.i.i, i64 56
  store i64 34359742465, ptr %r_meta_gep.i.i, align 8
  %rtag.i.i = or disjoint i64 %rpi.pre-phi.i.i, 2
  %t24.i = and i64 %rpi.pre-phi.i.i, -4
  %t25.i = inttoptr i64 %t24.i to ptr
  %t26.i = getelementptr inbounds nuw i8, ptr %t25.i, i64 48
  br label %for.fast.body.5.i

for.fast.body.5.i:                                ; preds = %for.fast.body.5.i.preheader, %for.fast.body.5.i
  %for.i.10.0568.i = phi i64 [ %t30.i, %for.fast.body.5.i ], [ 0, %for.fast.body.5.i.preheader ]
  %t19.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %for.i.10.0568.i
  %t20.unpack.i = load i64, ptr %t19.i, align 8
  %4 = insertvalue %ArchxStr poison, i64 %t20.unpack.i, 0
  %t20.elt34.i = getelementptr inbounds nuw i8, ptr %t19.i, i64 8
  %t20.unpack35.i = load i64, ptr %t20.elt34.i, align 8
  %t2036.i = insertvalue %ArchxStr %4, i64 %t20.unpack35.i, 1
  %t21.i = call fastcc i64 @archx_dict_upsert_str(i64 %rtag.i.i, %ArchxStr %t2036.i)
  %t27.i = load ptr, ptr %t26.i, align 8
  %t28.i = getelementptr inbounds i64, ptr %t27.i, i64 %t21.i
  store i64 1, ptr %t28.i, align 8
  %t30.i = add nuw nsw i64 %for.i.10.0568.i, 1
  %exitcond625.not.i = icmp eq i64 %t30.i, 1024
  br i1 %exitcond625.not.i, label %for.end.10.i, label %for.fast.body.5.i

for.end.10.i:                                     ; preds = %for.fast.body.5.i
  %t59.i = mul nuw nsw i64 %for.r.4.0607.i, 19
  %is_z.i.i.i.i = icmp eq i64 %t24.i, 0
  %ctrl_p.i.i.i.i = getelementptr inbounds nuw i8, ptr %t25.i, i64 32
  %mask_p.i.i.i.i = getelementptr inbounds nuw i8, ptr %t25.i, i64 16
  %keys_p.i.i.i.i = getelementptr inbounds nuw i8, ptr %t25.i, i64 40
  br label %idx.ok.25.i

for.cond.35.preheader.i:                          ; preds = %archx_str_drop.exit.i
  %t127.i = mul nuw nsw i64 %for.r.4.0607.i, 7
  br label %idx.ok.47.i

idx.ok.25.i:                                      ; preds = %for.end.10.i, %archx_str_drop.exit.i
  %for.step.50.0576.i = phi i64 [ 0, %for.end.10.i ], [ %t117.i, %archx_str_drop.exit.i ]
  %t55.i = mul nuw nsw i64 %for.step.50.0576.i, 73
  %t62.i = add nuw nsw i64 %t55.i, %t59.i
  %t70.i = and i64 %t62.i, 1023
  %t81.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %t70.i
  %t82.unpack.i = load i64, ptr %t81.i, align 8
  %5 = insertvalue %ArchxStr poison, i64 %t82.unpack.i, 0
  %t82.elt31.i = getelementptr inbounds nuw i8, ptr %t81.i, i64 8
  %t82.unpack32.i = load i64, ptr %t82.elt31.i, align 8
  %t8233.i = insertvalue %ArchxStr %5, i64 %t82.unpack32.i, 1
  %len.i488.i = and i64 %t82.unpack.i, 4294967295
  %long.i489.i = icmp samesign ult i64 %len.i488.i, 13
  %tag.i492.i = and i64 %t82.unpack32.i, 3
  %owned.not.i493.i = icmp eq i64 %tag.i492.i, 0
  %or.cond.i = select i1 %long.i489.i, i1 true, i1 %owned.not.i493.i
  br i1 %or.cond.i, label %archx_str_clone.exit.i, label %dup_heap.i.i

dup_heap.i.i:                                     ; preds = %idx.ok.25.i
  %dst.i.i = call noalias align 16 ptr @malloc(i64 %len.i488.i)
  %isnull.i.i = icmp eq ptr %dst.i.i, null
  br i1 %isnull.i.i, label %oom.i.i112, label %copy.i.i

oom.i.i112:                                       ; preds = %dup_heap.i.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i:                                         ; preds = %dup_heap.i.i
  %src_i.i.i = and i64 %t82.unpack32.i, -4
  %src.i.i = inttoptr i64 %src_i.i.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i, ptr nonnull align 4 %src.i.i, i64 %len.i488.i, i1 false)
  %dst_i.i.i = ptrtoint ptr %dst.i.i to i64
  %tagged.i.i = or disjoint i64 %dst_i.i.i, 1
  %out.i.i = insertvalue %ArchxStr %t8233.i, i64 %tagged.i.i, 1
  br label %archx_str_clone.exit.i

archx_str_clone.exit.i:                           ; preds = %copy.i.i, %idx.ok.25.i
  %common.ret.op.i.i111 = phi %ArchxStr [ %out.i.i, %copy.i.i ], [ %t8233.i, %idx.ok.25.i ]
  %w0.i.i.i.i = extractvalue %ArchxStr %common.ret.op.i.i111, 0
  %w1.i.i.i.i = extractvalue %ArchxStr %common.ret.op.i.i111, 1
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
  %6 = xor i64 %len.i.i.i.i, %s1.i10.i.i.i.i
  %x1.i11.i.i.i.i = xor i64 %6, %ax.i.i.i.i
  br label %archx_hash_str.exit.i.i.i

long_hash.i.i.i.i:                                ; preds = %archx_str_clone.exit.i
  %raw.i.i.i.i = and i64 %w1.i.i.i.i, -4
  %ptr.i.i.i.i = inttoptr i64 %raw.i.i.i.i to ptr
  %seed.i.i.i.i = mul i64 %len.i.i.i.i, -7046029254386353131
  %7 = add nsw i64 %len.i.i.i.i, -8
  %8 = icmp ult i64 %7, 8
  br i1 %8, label %l_tail_cond.i.i.i.preheader.i.unr-lcssa, label %long_hash.i.i.i.i.new

long_hash.i.i.i.i.new:                            ; preds = %long_hash.i.i.i.i
  %9 = lshr i64 %7, 3
  %10 = add nuw nsw i64 %9, 1
  %unroll_iter = and i64 %10, 4611686018427387902
  br label %l_body.i.i.i.i

l_tail_cond.i.i.i.preheader.i.unr-lcssa:          ; preds = %l_body.i.i.i.i, %long_hash.i.i.i.i
  %acc_next.i.i.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i.i ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx_next.i.i.i.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i.i ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %acc.i.i.i570.i.unr = phi i64 [ %seed.i.i.i.i, %long_hash.i.i.i.i ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx.i.i.i569.i.unr = phi i64 [ 0, %long_hash.i.i.i.i ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %11 = and i64 %7, 8
  %lcmp.mod.not.not = icmp eq i64 %11, 0
  br i1 %lcmp.mod.not.not, label %l_body.i.i.i.i.epil, label %l_tail_cond.i.i.i.preheader.i

l_body.i.i.i.i.epil:                              ; preds = %l_tail_cond.i.i.i.preheader.i.unr-lcssa
  %lp.i.i.i.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %idx.i.i.i569.i.unr
  %lane.i.i.i.i.epil = load i64, ptr %lp.i.i.i.i.epil, align 4
  %lm.i.i.i.i.epil = mul i64 %lane.i.i.i.i.epil, -4417276706812531889
  %lx.i.i.i.i.epil = xor i64 %lm.i.i.i.i.epil, %acc.i.i.i570.i.unr
  %s1.i2.i.i.i.i.epil = lshr i64 %lx.i.i.i.i.epil, 30
  %x1.i3.i.i.i.i.epil = xor i64 %s1.i2.i.i.i.i.epil, %lx.i.i.i.i.epil
  %m1.i4.i.i.i.i.epil = mul i64 %x1.i3.i.i.i.i.epil, -4658895280553007687
  %s2.i5.i.i.i.i.epil = lshr i64 %m1.i4.i.i.i.i.epil, 27
  %x2.i6.i.i.i.i.epil = xor i64 %s2.i5.i.i.i.i.epil, %m1.i4.i.i.i.i.epil
  %m2.i7.i.i.i.i.epil = mul i64 %x2.i6.i.i.i.i.epil, -7723592293110705685
  %s3.i8.i.i.i.i.epil = lshr i64 %m2.i7.i.i.i.i.epil, 31
  %x3.i9.i.i.i.i.epil = xor i64 %s3.i8.i.i.i.i.epil, %m2.i7.i.i.i.i.epil
  %acc_next.i.i.i.i.epil = add i64 %x3.i9.i.i.i.i.epil, %idx.i.i.i569.i.unr
  %idx_next.i.i.i.i.epil = add nuw nsw i64 %idx.i.i.i569.i.unr, 8
  br label %l_tail_cond.i.i.i.preheader.i

l_tail_cond.i.i.i.preheader.i:                    ; preds = %l_tail_cond.i.i.i.preheader.i.unr-lcssa, %l_body.i.i.i.i.epil
  %acc_next.i.i.i.i.lcssa = phi i64 [ %acc_next.i.i.i.i.lcssa.ph, %l_tail_cond.i.i.i.preheader.i.unr-lcssa ], [ %acc_next.i.i.i.i.epil, %l_body.i.i.i.i.epil ]
  %idx_next.i.i.i.i.lcssa = phi i64 [ %idx_next.i.i.i.i.lcssa.ph, %l_tail_cond.i.i.i.preheader.i.unr-lcssa ], [ %idx_next.i.i.i.i.epil, %l_body.i.i.i.i.epil ]
  %tmore.i.i.i571.i = icmp samesign ult i64 %idx_next.i.i.i.i.lcssa, %len.i.i.i.i
  br i1 %tmore.i.i.i571.i, label %l_tail_body.i.i.i.i.preheader, label %l_done.i.i.i.i

l_tail_body.i.i.i.i.preheader:                    ; preds = %l_tail_cond.i.i.i.preheader.i
  %12 = sub i64 %w0.i.i.i.i, %idx_next.i.i.i.i.lcssa
  %xtraiter331 = and i64 %12, 3
  %lcmp.mod332.not = icmp eq i64 %xtraiter331, 0
  br i1 %lcmp.mod332.not, label %l_tail_body.i.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.i.prol

l_tail_body.i.i.i.i.prol:                         ; preds = %l_tail_body.i.i.i.i.preheader, %l_tail_body.i.i.i.i.prol
  %tacc.i.i.i573.i.prol = phi i64 [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ], [ %acc_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ]
  %ti.i.i.i572.i.prol = phi i64 [ %ti_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ], [ %idx_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %l_tail_body.i.i.i.i.prol ], [ 0, %l_tail_body.i.i.i.i.preheader ]
  %tp.i.i.i.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %ti.i.i.i572.i.prol
  %tb.i.i.i.i.prol = load i8, ptr %tp.i.i.i.i.prol, align 1
  %tz.i.i.i.i.prol = zext i8 %tb.i.i.i.i.prol to i64
  %tx.i.i.i.i.prol = xor i64 %tacc.i.i.i573.i.prol, %tz.i.i.i.i.prol
  %tacc_next.i.i.i.i.prol = mul i64 %tx.i.i.i.i.prol, 1099511628211
  %ti_next.i.i.i.i.prol = add nuw nsw i64 %ti.i.i.i572.i.prol, 1
  %prol.iter.next = add i64 %prol.iter, 1
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter331
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.i.prol, !llvm.loop !0

l_tail_body.i.i.i.i.prol.loopexit:                ; preds = %l_tail_body.i.i.i.i.prol, %l_tail_body.i.i.i.i.preheader
  %tacc.i.i.i573.i.unr = phi i64 [ %acc_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ], [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %ti.i.i.i572.i.unr = phi i64 [ %idx_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ], [ %ti_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %tacc_next.i.i.i.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.i.i.preheader ], [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %13 = sub i64 %idx_next.i.i.i.i.lcssa, %len.i.i.i.i
  %14 = icmp ugt i64 %13, -4
  br i1 %14, label %l_done.i.i.i.i, label %l_tail_body.i.i.i.i.preheader.new

l_tail_body.i.i.i.i.preheader.new:                ; preds = %l_tail_body.i.i.i.i.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr.i.i.i.i, i64 1
  %invariant.gep351 = getelementptr i8, ptr %ptr.i.i.i.i, i64 2
  %invariant.gep353 = getelementptr i8, ptr %ptr.i.i.i.i, i64 3
  br label %l_tail_body.i.i.i.i

l_body.i.i.i.i:                                   ; preds = %l_body.i.i.i.i, %long_hash.i.i.i.i.new
  %acc.i.i.i570.i = phi i64 [ %seed.i.i.i.i, %long_hash.i.i.i.i.new ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx.i.i.i569.i = phi i64 [ 0, %long_hash.i.i.i.i.new ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %niter = phi i64 [ 0, %long_hash.i.i.i.i.new ], [ %niter.next.1, %l_body.i.i.i.i ]
  %lp.i.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %idx.i.i.i569.i
  %lane.i.i.i.i = load i64, ptr %lp.i.i.i.i, align 4
  %lm.i.i.i.i = mul i64 %lane.i.i.i.i, -4417276706812531889
  %lx.i.i.i.i = xor i64 %lm.i.i.i.i, %acc.i.i.i570.i
  %s1.i2.i.i.i.i = lshr i64 %lx.i.i.i.i, 30
  %x1.i3.i.i.i.i = xor i64 %s1.i2.i.i.i.i, %lx.i.i.i.i
  %m1.i4.i.i.i.i = mul i64 %x1.i3.i.i.i.i, -4658895280553007687
  %s2.i5.i.i.i.i = lshr i64 %m1.i4.i.i.i.i, 27
  %x2.i6.i.i.i.i = xor i64 %s2.i5.i.i.i.i, %m1.i4.i.i.i.i
  %m2.i7.i.i.i.i = mul i64 %x2.i6.i.i.i.i, -7723592293110705685
  %s3.i8.i.i.i.i = lshr i64 %m2.i7.i.i.i.i, 31
  %x3.i9.i.i.i.i = xor i64 %s3.i8.i.i.i.i, %m2.i7.i.i.i.i
  %acc_next.i.i.i.i = add i64 %x3.i9.i.i.i.i, %idx.i.i.i569.i
  %idx_next.i.i.i.i = or disjoint i64 %idx.i.i.i569.i, 8
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
  %idx_next.i.i.i.i.1 = add nuw nsw i64 %idx.i.i.i569.i, 16
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1.not = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1.not, label %l_tail_cond.i.i.i.preheader.i.unr-lcssa, label %l_body.i.i.i.i

l_tail_body.i.i.i.i:                              ; preds = %l_tail_body.i.i.i.i, %l_tail_body.i.i.i.i.preheader.new
  %tacc.i.i.i573.i = phi i64 [ %tacc.i.i.i573.i.unr, %l_tail_body.i.i.i.i.preheader.new ], [ %tacc_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %ti.i.i.i572.i = phi i64 [ %ti.i.i.i572.i.unr, %l_tail_body.i.i.i.i.preheader.new ], [ %ti_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %tp.i.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %ti.i.i.i572.i
  %tb.i.i.i.i = load i8, ptr %tp.i.i.i.i, align 1
  %tz.i.i.i.i = zext i8 %tb.i.i.i.i to i64
  %tx.i.i.i.i = xor i64 %tacc.i.i.i573.i, %tz.i.i.i.i
  %tacc_next.i.i.i.i = mul i64 %tx.i.i.i.i, 1099511628211
  %gep = getelementptr i8, ptr %invariant.gep, i64 %ti.i.i.i572.i
  %tb.i.i.i.i.1 = load i8, ptr %gep, align 1
  %tz.i.i.i.i.1 = zext i8 %tb.i.i.i.i.1 to i64
  %tx.i.i.i.i.1 = xor i64 %tacc_next.i.i.i.i, %tz.i.i.i.i.1
  %tacc_next.i.i.i.i.1 = mul i64 %tx.i.i.i.i.1, 1099511628211
  %gep352 = getelementptr i8, ptr %invariant.gep351, i64 %ti.i.i.i572.i
  %tb.i.i.i.i.2 = load i8, ptr %gep352, align 1
  %tz.i.i.i.i.2 = zext i8 %tb.i.i.i.i.2 to i64
  %tx.i.i.i.i.2 = xor i64 %tacc_next.i.i.i.i.1, %tz.i.i.i.i.2
  %tacc_next.i.i.i.i.2 = mul i64 %tx.i.i.i.i.2, 1099511628211
  %gep354 = getelementptr i8, ptr %invariant.gep353, i64 %ti.i.i.i572.i
  %tb.i.i.i.i.3 = load i8, ptr %gep354, align 1
  %tz.i.i.i.i.3 = zext i8 %tb.i.i.i.i.3 to i64
  %tx.i.i.i.i.3 = xor i64 %tacc_next.i.i.i.i.2, %tz.i.i.i.i.3
  %tacc_next.i.i.i.i.3 = mul i64 %tx.i.i.i.i.3, 1099511628211
  %ti_next.i.i.i.i.3 = add nuw nsw i64 %ti.i.i.i572.i, 4
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
  br i1 %is_z.i.i.i.i, label %dupd.miss.28.i, label %chk_ctrl.i.i.i.i

chk_ctrl.i.i.i.i:                                 ; preds = %archx_hash_str.exit.i.i.i
  %ctrl.i.i.i.i = load ptr, ptr %ctrl_p.i.i.i.i, align 8
  %c_null.i.i.i.i = icmp eq ptr %ctrl.i.i.i.i, null
  br i1 %c_null.i.i.i.i, label %dupd.miss.28.i, label %do_probe.i.i.i.i

do_probe.i.i.i.i:                                 ; preds = %chk_ctrl.i.i.i.i
  %mask.i.i.i.i = load i64, ptr %mask_p.i.i.i.i, align 8
  %keys.i.i.i.i = load ptr, ptr %keys_p.i.i.i.i, align 8
  %15 = getelementptr i8, ptr %ctrl.i.i.i.i, i64 %mask.i.i.i.i
  %idx_base.i.i.i.i = getelementptr i8, ptr %15, i64 17
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
  %has_m.not.i.i.i574.i = icmp eq i16 %mbits.i.i.i.i, 0
  br i1 %has_m.not.i.i.i574.i, label %chk_empty.i.i.i.i, label %chk_key.i.i.i.preheader.i

chk_key.i.i.i.preheader.i:                        ; preds = %probe.i.i.i.i
  %mmask0.i.i.i.i = zext i16 %mbits.i.i.i.i to i32
  br label %chk_key.i.i.i.i

chk_key.i.i.i.i:                                  ; preds = %mbit_cont.i.i.i.i, %chk_key.i.i.i.preheader.i
  %mmask.i.i.i575.i = phi i32 [ %mmask_next.i.i.i.i, %mbit_cont.i.i.i.i ], [ %mmask0.i.i.i.i, %chk_key.i.i.i.preheader.i ]
  %tz.i2.i.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i575.i, i1 true)
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
  br i1 %eq_s.i.i.i.i.i, label %dupd.ok.27.i, label %mbit_cont.i.i.i.i

cmp_long.i.i.i.i.i:                               ; preds = %chk_len.i.i.i.i.i
  %ap_i.i.i.i.i.i = and i64 %cand_k.unpack2.i.i.i.i, -4
  %same_ptr.i.i.i.i.i = icmp eq i64 %ap_i.i.i.i.i.i, %bp_i.i.i.i.i.i
  br i1 %same_ptr.i.i.i.i.i, label %dupd.ok.27.i, label %archx_str_eq.exit.i.i.i.i

archx_str_eq.exit.i.i.i.i:                        ; preds = %cmp_long.i.i.i.i.i
  %ap.i.i.i.i.i = inttoptr i64 %ap_i.i.i.i.i.i to ptr
  %ap4.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i.i, i64 4
  %bcmp.i.i.i.i.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i.i.i, ptr nonnull %bp4.i.i.i.i.i, i64 %rem.i.i.i.i.i)
  %eq_m.i.i.i.i.i = icmp eq i32 %bcmp.i.i.i.i.i, 0
  br i1 %eq_m.i.i.i.i.i, label %dupd.ok.27.i, label %mbit_cont.i.i.i.i

mbit_cont.i.i.i.i:                                ; preds = %archx_str_eq.exit.i.i.i.i, %cmp_short.i.i.i.i.i, %chk_key.i.i.i.i
  %mm1.i.i.i.i = add nsw i32 %mmask.i.i.i575.i, -1
  %mmask_next.i.i.i.i = and i32 %mm1.i.i.i.i, %mmask.i.i.i575.i
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
  %16 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i.i, i1 true)
  %atz64.i.i.i.i = zext nneg i16 %16 to i64
  %as_add.i.i.i.i = add i64 %pos.i.i.i.i, %atz64.i.i.i.i
  %aslot.i.i.i.i = and i64 %as_add.i.i.i.i, %mask.i.i.i.i
  br label %after_a.i.i.i.i

after_a.i.i.i.i:                                  ; preds = %set_a.i.i.i.i, %find_a.i.i.i.i, %chk_empty.i.i.i.i
  %avail_cur.i.i.i.i = phi i64 [ %avail.i.i.i.i, %chk_empty.i.i.i.i ], [ -1, %find_a.i.i.i.i ], [ %aslot.i.i.i.i, %set_a.i.i.i.i ]
  %ecmp.i.i.i.i = icmp eq <16 x i8> %grp.i.i.i.i, splat (i8 -128)
  %ebits.i.i.i.i = bitcast <16 x i1> %ecmp.i.i.i.i to i16
  %has_e.not.i.i.i.i = icmp eq i16 %ebits.i.i.i.i, 0
  br i1 %has_e.not.i.i.i.i, label %next_grp.i.i.i.i, label %dupd.miss.28.i

next_grp.i.i.i.i:                                 ; preds = %after_a.i.i.i.i
  %step_next.i.i.i.i = add i64 %step.i.i.i.i, 16
  %padd.i.i.i.i = add i64 %step_next.i.i.i.i, %pos.i.i.i.i
  br label %probe.i.i.i.i

dupd.miss.28.i:                                   ; preds = %chk_ctrl.i.i.i.i, %archx_hash_str.exit.i.i.i, %after_a.i.i.i.i
  call fastcc void @archx_key_fail()
  unreachable

dupd.ok.27.i:                                     ; preds = %archx_str_eq.exit.i.i.i.i, %cmp_long.i.i.i.i.i, %cmp_short.i.i.i.i.i
  %t92.i = load ptr, ptr %t26.i, align 8
  %t93.i = getelementptr inbounds nuw i64, ptr %t92.i, i64 %didx.i.i.i.i
  %t94.i = load i64, ptr %t93.i, align 8
  %t101.i = urem i64 %for.step.50.0576.i, 7
  %t109.i = add nuw nsw i64 %t101.i, 1
  %t112.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t94.i, i64 %t109.i)
  %t114.i = extractvalue { i64, i1 } %t112.i, 1
  br i1 %t114.i, label %overflow.add.33.i, label %overflow.ok.34.i

overflow.add.33.i:                                ; preds = %dupd.ok.27.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.34.i:                                 ; preds = %dupd.ok.27.i
  %t113.i = extractvalue { i64, i1 } %t112.i, 0
  store i64 %t113.i, ptr %t93.i, align 8
  %tag.i.i = and i64 %w1.i.i.i.i, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond530.i = select i1 %short.i.i.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond530.i, label %archx_str_drop.exit.i, label %do_free.i.i

do_free.i.i:                                      ; preds = %overflow.ok.34.i
  %raw.i.i = and i64 %w1.i.i.i.i, -2
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  call void @free(ptr %ptr.i.i)
  br label %archx_str_drop.exit.i

archx_str_drop.exit.i:                            ; preds = %do_free.i.i, %overflow.ok.34.i
  %t117.i = add nuw nsw i64 %for.step.50.0576.i, 1
  %exitcond626.not.i = icmp eq i64 %t117.i, 8192
  br i1 %exitcond626.not.i, label %for.cond.35.preheader.i, label %idx.ok.25.i

idx.ok.47.i:                                      ; preds = %for.cond.35.preheader.i, %archx_str_drop.exit47.i
  %var.str_checksum.0.1586.i = phi i64 [ %var.str_checksum.0.0608.i, %for.cond.35.preheader.i ], [ %t166.i, %archx_str_drop.exit47.i ]
  %for.p.118.0585.i = phi i64 [ 0, %for.cond.35.preheader.i ], [ %t170.i, %archx_str_drop.exit47.i ]
  %t123.i = mul nuw nsw i64 %for.p.118.0585.i, 131
  %t130.i = add nuw nsw i64 %t123.i, %t127.i
  %t138.i = and i64 %t130.i, 1023
  %t149.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %t138.i
  %t150.unpack.i = load i64, ptr %t149.i, align 8
  %17 = insertvalue %ArchxStr poison, i64 %t150.unpack.i, 0
  %t150.elt28.i = getelementptr inbounds nuw i8, ptr %t149.i, i64 8
  %t150.unpack29.i = load i64, ptr %t150.elt28.i, align 8
  %t15030.i = insertvalue %ArchxStr %17, i64 %t150.unpack29.i, 1
  %len.i495.i = and i64 %t150.unpack.i, 4294967295
  %long.i496.i = icmp samesign ult i64 %len.i495.i, 13
  %tag.i500.i = and i64 %t150.unpack29.i, 3
  %owned.not.i501.i = icmp eq i64 %tag.i500.i, 0
  %or.cond531.i = select i1 %long.i496.i, i1 true, i1 %owned.not.i501.i
  br i1 %or.cond531.i, label %archx_str_clone.exit512.i, label %dup_heap.i502.i

dup_heap.i502.i:                                  ; preds = %idx.ok.47.i
  %dst.i503.i = call noalias align 16 ptr @malloc(i64 %len.i495.i)
  %isnull.i504.i = icmp eq ptr %dst.i503.i, null
  br i1 %isnull.i504.i, label %oom.i511.i, label %copy.i505.i

oom.i511.i:                                       ; preds = %dup_heap.i502.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i505.i:                                      ; preds = %dup_heap.i502.i
  %src_i.i506.i = and i64 %t150.unpack29.i, -4
  %src.i507.i = inttoptr i64 %src_i.i506.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i503.i, ptr nonnull align 4 %src.i507.i, i64 %len.i495.i, i1 false)
  %dst_i.i508.i = ptrtoint ptr %dst.i503.i to i64
  %tagged.i509.i = or disjoint i64 %dst_i.i508.i, 1
  %out.i510.i = insertvalue %ArchxStr %t15030.i, i64 %tagged.i509.i, 1
  br label %archx_str_clone.exit512.i

archx_str_clone.exit512.i:                        ; preds = %copy.i505.i, %idx.ok.47.i
  %common.ret.op.i497.i = phi %ArchxStr [ %out.i510.i, %copy.i505.i ], [ %t15030.i, %idx.ok.47.i ]
  %w0.i.i.i48.i = extractvalue %ArchxStr %common.ret.op.i497.i, 0
  %w1.i.i.i49.i = extractvalue %ArchxStr %common.ret.op.i497.i, 1
  %len.i.i.i50.i = and i64 %w0.i.i.i48.i, 4294967295
  %short.i.i.i51.i = icmp samesign ult i64 %len.i.i.i50.i, 13
  br i1 %short.i.i.i51.i, label %sso_hash.i.i.i191.i, label %long_hash.i.i.i52.i

sso_hash.i.i.i191.i:                              ; preds = %archx_str_clone.exit512.i
  %p0_raw.i.i.i192.i = lshr i64 %w0.i.i.i48.i, 32
  %le4.i.i.i193.i = icmp samesign ult i64 %len.i.i.i50.i, 5
  br i1 %le4.i.i.i193.i, label %sso_le4.i.i.i217.i, label %sso_gt4.i.i.i194.i

sso_le4.i.i.i217.i:                               ; preds = %sso_hash.i.i.i191.i
  %sh0.i.i.i218.i = shl nuw nsw i64 %len.i.i.i50.i, 3
  %notmask1.i.i.i219.i = shl nsw i64 -1, %sh0.i.i.i218.i
  %m0.i.i.i220.i = xor i64 %notmask1.i.i.i219.i, -1
  %p0_4.i.i.i221.i = and i64 %p0_raw.i.i.i192.i, %m0.i.i.i220.i
  br label %sso_mix.i.i.i202.i

sso_gt4.i.i.i194.i:                               ; preds = %sso_hash.i.i.i191.i
  %eq12.i.i.i195.i = icmp eq i64 %len.i.i.i50.i, 12
  br i1 %eq12.i.i.i195.i, label %sso_mix.i.i.i202.i, label %sso_mid.i.i.i196.i

sso_mid.i.i.i196.i:                               ; preds = %sso_gt4.i.i.i194.i
  %rem.i.i.i197.i = shl nuw nsw i64 %len.i.i.i50.i, 3
  %sh1.i.i.i198.i = add nsw i64 %rem.i.i.i197.i, -32
  %notmask.i.i.i199.i = shl nsw i64 -1, %sh1.i.i.i198.i
  %m1.i.i.i200.i = xor i64 %notmask.i.i.i199.i, -1
  %p1_m.i.i.i201.i = and i64 %w1.i.i.i49.i, %m1.i.i.i200.i
  br label %sso_mix.i.i.i202.i

sso_mix.i.i.i202.i:                               ; preds = %sso_mid.i.i.i196.i, %sso_gt4.i.i.i194.i, %sso_le4.i.i.i217.i
  %p0.i.i.i203.i = phi i64 [ %p0_4.i.i.i221.i, %sso_le4.i.i.i217.i ], [ %p0_raw.i.i.i192.i, %sso_mid.i.i.i196.i ], [ %p0_raw.i.i.i192.i, %sso_gt4.i.i.i194.i ]
  %p1.i.i.i204.i = phi i64 [ 0, %sso_le4.i.i.i217.i ], [ %p1_m.i.i.i201.i, %sso_mid.i.i.i196.i ], [ %w1.i.i.i49.i, %sso_gt4.i.i.i194.i ]
  %a0.i.i.i205.i = mul i64 %p0.i.i.i203.i, -7046029254386353131
  %a1.i.i.i206.i = mul i64 %p1.i.i.i204.i, -4417276706812531889
  %ax.i.i.i207.i = xor i64 %a1.i.i.i206.i, %a0.i.i.i205.i
  %s1.i10.i.i.i209.i = lshr i64 %ax.i.i.i207.i, 30
  %18 = xor i64 %len.i.i.i50.i, %s1.i10.i.i.i209.i
  %x1.i11.i.i.i210.i = xor i64 %18, %ax.i.i.i207.i
  br label %archx_hash_str.exit.i.i74.i

long_hash.i.i.i52.i:                              ; preds = %archx_str_clone.exit512.i
  %raw.i.i.i53.i = and i64 %w1.i.i.i49.i, -4
  %ptr.i.i.i54.i = inttoptr i64 %raw.i.i.i53.i to ptr
  %seed.i.i.i55.i = mul i64 %len.i.i.i50.i, -7046029254386353131
  %19 = add nsw i64 %len.i.i.i50.i, -8
  %20 = icmp ult i64 %19, 8
  br i1 %20, label %l_tail_cond.i.i.i61.preheader.i.unr-lcssa, label %long_hash.i.i.i52.i.new

long_hash.i.i.i52.i.new:                          ; preds = %long_hash.i.i.i52.i
  %21 = lshr i64 %19, 3
  %22 = add nuw nsw i64 %21, 1
  %unroll_iter337 = and i64 %22, 4611686018427387902
  br label %l_body.i.i.i176.i

l_tail_cond.i.i.i61.preheader.i.unr-lcssa:        ; preds = %l_body.i.i.i176.i, %long_hash.i.i.i52.i
  %acc_next.i.i.i189.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i52.i ], [ %acc_next.i.i.i189.i.1, %l_body.i.i.i176.i ]
  %idx_next.i.i.i190.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i52.i ], [ %idx_next.i.i.i190.i.1, %l_body.i.i.i176.i ]
  %acc.i.i.i58578.i.unr = phi i64 [ %seed.i.i.i55.i, %long_hash.i.i.i52.i ], [ %acc_next.i.i.i189.i.1, %l_body.i.i.i176.i ]
  %idx.i.i.i57577.i.unr = phi i64 [ 0, %long_hash.i.i.i52.i ], [ %idx_next.i.i.i190.i.1, %l_body.i.i.i176.i ]
  %23 = and i64 %19, 8
  %lcmp.mod334.not.not = icmp eq i64 %23, 0
  br i1 %lcmp.mod334.not.not, label %l_body.i.i.i176.i.epil, label %l_tail_cond.i.i.i61.preheader.i

l_body.i.i.i176.i.epil:                           ; preds = %l_tail_cond.i.i.i61.preheader.i.unr-lcssa
  %lp.i.i.i177.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i.i54.i, i64 %idx.i.i.i57577.i.unr
  %lane.i.i.i178.i.epil = load i64, ptr %lp.i.i.i177.i.epil, align 4
  %lm.i.i.i179.i.epil = mul i64 %lane.i.i.i178.i.epil, -4417276706812531889
  %lx.i.i.i180.i.epil = xor i64 %lm.i.i.i179.i.epil, %acc.i.i.i58578.i.unr
  %s1.i2.i.i.i181.i.epil = lshr i64 %lx.i.i.i180.i.epil, 30
  %x1.i3.i.i.i182.i.epil = xor i64 %s1.i2.i.i.i181.i.epil, %lx.i.i.i180.i.epil
  %m1.i4.i.i.i183.i.epil = mul i64 %x1.i3.i.i.i182.i.epil, -4658895280553007687
  %s2.i5.i.i.i184.i.epil = lshr i64 %m1.i4.i.i.i183.i.epil, 27
  %x2.i6.i.i.i185.i.epil = xor i64 %s2.i5.i.i.i184.i.epil, %m1.i4.i.i.i183.i.epil
  %m2.i7.i.i.i186.i.epil = mul i64 %x2.i6.i.i.i185.i.epil, -7723592293110705685
  %s3.i8.i.i.i187.i.epil = lshr i64 %m2.i7.i.i.i186.i.epil, 31
  %x3.i9.i.i.i188.i.epil = xor i64 %s3.i8.i.i.i187.i.epil, %m2.i7.i.i.i186.i.epil
  %acc_next.i.i.i189.i.epil = add i64 %x3.i9.i.i.i188.i.epil, %idx.i.i.i57577.i.unr
  %idx_next.i.i.i190.i.epil = add nuw nsw i64 %idx.i.i.i57577.i.unr, 8
  br label %l_tail_cond.i.i.i61.preheader.i

l_tail_cond.i.i.i61.preheader.i:                  ; preds = %l_tail_cond.i.i.i61.preheader.i.unr-lcssa, %l_body.i.i.i176.i.epil
  %acc_next.i.i.i189.i.lcssa = phi i64 [ %acc_next.i.i.i189.i.lcssa.ph, %l_tail_cond.i.i.i61.preheader.i.unr-lcssa ], [ %acc_next.i.i.i189.i.epil, %l_body.i.i.i176.i.epil ]
  %idx_next.i.i.i190.i.lcssa = phi i64 [ %idx_next.i.i.i190.i.lcssa.ph, %l_tail_cond.i.i.i61.preheader.i.unr-lcssa ], [ %idx_next.i.i.i190.i.epil, %l_body.i.i.i176.i.epil ]
  %tmore.i.i.i64579.i = icmp samesign ult i64 %idx_next.i.i.i190.i.lcssa, %len.i.i.i50.i
  br i1 %tmore.i.i.i64579.i, label %l_tail_body.i.i.i169.i.preheader, label %l_done.i.i.i65.i

l_tail_body.i.i.i169.i.preheader:                 ; preds = %l_tail_cond.i.i.i61.preheader.i
  %24 = sub i64 %w0.i.i.i48.i, %idx_next.i.i.i190.i.lcssa
  %xtraiter339 = and i64 %24, 3
  %lcmp.mod340.not = icmp eq i64 %xtraiter339, 0
  br i1 %lcmp.mod340.not, label %l_tail_body.i.i.i169.i.prol.loopexit, label %l_tail_body.i.i.i169.i.prol

l_tail_body.i.i.i169.i.prol:                      ; preds = %l_tail_body.i.i.i169.i.preheader, %l_tail_body.i.i.i169.i.prol
  %tacc.i.i.i63581.i.prol = phi i64 [ %tacc_next.i.i.i174.i.prol, %l_tail_body.i.i.i169.i.prol ], [ %acc_next.i.i.i189.i.lcssa, %l_tail_body.i.i.i169.i.preheader ]
  %ti.i.i.i62580.i.prol = phi i64 [ %ti_next.i.i.i175.i.prol, %l_tail_body.i.i.i169.i.prol ], [ %idx_next.i.i.i190.i.lcssa, %l_tail_body.i.i.i169.i.preheader ]
  %prol.iter341 = phi i64 [ %prol.iter341.next, %l_tail_body.i.i.i169.i.prol ], [ 0, %l_tail_body.i.i.i169.i.preheader ]
  %tp.i.i.i170.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i.i54.i, i64 %ti.i.i.i62580.i.prol
  %tb.i.i.i171.i.prol = load i8, ptr %tp.i.i.i170.i.prol, align 1
  %tz.i.i.i172.i.prol = zext i8 %tb.i.i.i171.i.prol to i64
  %tx.i.i.i173.i.prol = xor i64 %tacc.i.i.i63581.i.prol, %tz.i.i.i172.i.prol
  %tacc_next.i.i.i174.i.prol = mul i64 %tx.i.i.i173.i.prol, 1099511628211
  %ti_next.i.i.i175.i.prol = add nuw nsw i64 %ti.i.i.i62580.i.prol, 1
  %prol.iter341.next = add i64 %prol.iter341, 1
  %prol.iter341.cmp.not = icmp eq i64 %prol.iter341.next, %xtraiter339
  br i1 %prol.iter341.cmp.not, label %l_tail_body.i.i.i169.i.prol.loopexit, label %l_tail_body.i.i.i169.i.prol, !llvm.loop !2

l_tail_body.i.i.i169.i.prol.loopexit:             ; preds = %l_tail_body.i.i.i169.i.prol, %l_tail_body.i.i.i169.i.preheader
  %tacc.i.i.i63581.i.unr = phi i64 [ %acc_next.i.i.i189.i.lcssa, %l_tail_body.i.i.i169.i.preheader ], [ %tacc_next.i.i.i174.i.prol, %l_tail_body.i.i.i169.i.prol ]
  %ti.i.i.i62580.i.unr = phi i64 [ %idx_next.i.i.i190.i.lcssa, %l_tail_body.i.i.i169.i.preheader ], [ %ti_next.i.i.i175.i.prol, %l_tail_body.i.i.i169.i.prol ]
  %tacc_next.i.i.i174.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.i169.i.preheader ], [ %tacc_next.i.i.i174.i.prol, %l_tail_body.i.i.i169.i.prol ]
  %25 = sub i64 %idx_next.i.i.i190.i.lcssa, %len.i.i.i50.i
  %26 = icmp ugt i64 %25, -4
  br i1 %26, label %l_done.i.i.i65.i, label %l_tail_body.i.i.i169.i.preheader.new

l_tail_body.i.i.i169.i.preheader.new:             ; preds = %l_tail_body.i.i.i169.i.prol.loopexit
  %invariant.gep355 = getelementptr i8, ptr %ptr.i.i.i54.i, i64 1
  %invariant.gep357 = getelementptr i8, ptr %ptr.i.i.i54.i, i64 2
  %invariant.gep359 = getelementptr i8, ptr %ptr.i.i.i54.i, i64 3
  br label %l_tail_body.i.i.i169.i

l_body.i.i.i176.i:                                ; preds = %l_body.i.i.i176.i, %long_hash.i.i.i52.i.new
  %acc.i.i.i58578.i = phi i64 [ %seed.i.i.i55.i, %long_hash.i.i.i52.i.new ], [ %acc_next.i.i.i189.i.1, %l_body.i.i.i176.i ]
  %idx.i.i.i57577.i = phi i64 [ 0, %long_hash.i.i.i52.i.new ], [ %idx_next.i.i.i190.i.1, %l_body.i.i.i176.i ]
  %niter338 = phi i64 [ 0, %long_hash.i.i.i52.i.new ], [ %niter338.next.1, %l_body.i.i.i176.i ]
  %lp.i.i.i177.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i54.i, i64 %idx.i.i.i57577.i
  %lane.i.i.i178.i = load i64, ptr %lp.i.i.i177.i, align 4
  %lm.i.i.i179.i = mul i64 %lane.i.i.i178.i, -4417276706812531889
  %lx.i.i.i180.i = xor i64 %lm.i.i.i179.i, %acc.i.i.i58578.i
  %s1.i2.i.i.i181.i = lshr i64 %lx.i.i.i180.i, 30
  %x1.i3.i.i.i182.i = xor i64 %s1.i2.i.i.i181.i, %lx.i.i.i180.i
  %m1.i4.i.i.i183.i = mul i64 %x1.i3.i.i.i182.i, -4658895280553007687
  %s2.i5.i.i.i184.i = lshr i64 %m1.i4.i.i.i183.i, 27
  %x2.i6.i.i.i185.i = xor i64 %s2.i5.i.i.i184.i, %m1.i4.i.i.i183.i
  %m2.i7.i.i.i186.i = mul i64 %x2.i6.i.i.i185.i, -7723592293110705685
  %s3.i8.i.i.i187.i = lshr i64 %m2.i7.i.i.i186.i, 31
  %x3.i9.i.i.i188.i = xor i64 %s3.i8.i.i.i187.i, %m2.i7.i.i.i186.i
  %acc_next.i.i.i189.i = add i64 %x3.i9.i.i.i188.i, %idx.i.i.i57577.i
  %idx_next.i.i.i190.i = or disjoint i64 %idx.i.i.i57577.i, 8
  %lp.i.i.i177.i.1 = getelementptr inbounds nuw i8, ptr %ptr.i.i.i54.i, i64 %idx_next.i.i.i190.i
  %lane.i.i.i178.i.1 = load i64, ptr %lp.i.i.i177.i.1, align 4
  %lm.i.i.i179.i.1 = mul i64 %lane.i.i.i178.i.1, -4417276706812531889
  %lx.i.i.i180.i.1 = xor i64 %lm.i.i.i179.i.1, %acc_next.i.i.i189.i
  %s1.i2.i.i.i181.i.1 = lshr i64 %lx.i.i.i180.i.1, 30
  %x1.i3.i.i.i182.i.1 = xor i64 %s1.i2.i.i.i181.i.1, %lx.i.i.i180.i.1
  %m1.i4.i.i.i183.i.1 = mul i64 %x1.i3.i.i.i182.i.1, -4658895280553007687
  %s2.i5.i.i.i184.i.1 = lshr i64 %m1.i4.i.i.i183.i.1, 27
  %x2.i6.i.i.i185.i.1 = xor i64 %s2.i5.i.i.i184.i.1, %m1.i4.i.i.i183.i.1
  %m2.i7.i.i.i186.i.1 = mul i64 %x2.i6.i.i.i185.i.1, -7723592293110705685
  %s3.i8.i.i.i187.i.1 = lshr i64 %m2.i7.i.i.i186.i.1, 31
  %x3.i9.i.i.i188.i.1 = xor i64 %s3.i8.i.i.i187.i.1, %m2.i7.i.i.i186.i.1
  %acc_next.i.i.i189.i.1 = add i64 %x3.i9.i.i.i188.i.1, %idx_next.i.i.i190.i
  %idx_next.i.i.i190.i.1 = add nuw nsw i64 %idx.i.i.i57577.i, 16
  %niter338.next.1 = add i64 %niter338, 2
  %niter338.ncmp.1.not = icmp eq i64 %niter338.next.1, %unroll_iter337
  br i1 %niter338.ncmp.1.not, label %l_tail_cond.i.i.i61.preheader.i.unr-lcssa, label %l_body.i.i.i176.i

l_tail_body.i.i.i169.i:                           ; preds = %l_tail_body.i.i.i169.i, %l_tail_body.i.i.i169.i.preheader.new
  %tacc.i.i.i63581.i = phi i64 [ %tacc.i.i.i63581.i.unr, %l_tail_body.i.i.i169.i.preheader.new ], [ %tacc_next.i.i.i174.i.3, %l_tail_body.i.i.i169.i ]
  %ti.i.i.i62580.i = phi i64 [ %ti.i.i.i62580.i.unr, %l_tail_body.i.i.i169.i.preheader.new ], [ %ti_next.i.i.i175.i.3, %l_tail_body.i.i.i169.i ]
  %tp.i.i.i170.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i54.i, i64 %ti.i.i.i62580.i
  %tb.i.i.i171.i = load i8, ptr %tp.i.i.i170.i, align 1
  %tz.i.i.i172.i = zext i8 %tb.i.i.i171.i to i64
  %tx.i.i.i173.i = xor i64 %tacc.i.i.i63581.i, %tz.i.i.i172.i
  %tacc_next.i.i.i174.i = mul i64 %tx.i.i.i173.i, 1099511628211
  %gep356 = getelementptr i8, ptr %invariant.gep355, i64 %ti.i.i.i62580.i
  %tb.i.i.i171.i.1 = load i8, ptr %gep356, align 1
  %tz.i.i.i172.i.1 = zext i8 %tb.i.i.i171.i.1 to i64
  %tx.i.i.i173.i.1 = xor i64 %tacc_next.i.i.i174.i, %tz.i.i.i172.i.1
  %tacc_next.i.i.i174.i.1 = mul i64 %tx.i.i.i173.i.1, 1099511628211
  %gep358 = getelementptr i8, ptr %invariant.gep357, i64 %ti.i.i.i62580.i
  %tb.i.i.i171.i.2 = load i8, ptr %gep358, align 1
  %tz.i.i.i172.i.2 = zext i8 %tb.i.i.i171.i.2 to i64
  %tx.i.i.i173.i.2 = xor i64 %tacc_next.i.i.i174.i.1, %tz.i.i.i172.i.2
  %tacc_next.i.i.i174.i.2 = mul i64 %tx.i.i.i173.i.2, 1099511628211
  %gep360 = getelementptr i8, ptr %invariant.gep359, i64 %ti.i.i.i62580.i
  %tb.i.i.i171.i.3 = load i8, ptr %gep360, align 1
  %tz.i.i.i172.i.3 = zext i8 %tb.i.i.i171.i.3 to i64
  %tx.i.i.i173.i.3 = xor i64 %tacc_next.i.i.i174.i.2, %tz.i.i.i172.i.3
  %tacc_next.i.i.i174.i.3 = mul i64 %tx.i.i.i173.i.3, 1099511628211
  %ti_next.i.i.i175.i.3 = add nuw nsw i64 %ti.i.i.i62580.i, 4
  %tmore.i.i.i64.i.3 = icmp samesign ult i64 %ti_next.i.i.i175.i.3, %len.i.i.i50.i
  br i1 %tmore.i.i.i64.i.3, label %l_tail_body.i.i.i169.i, label %l_done.i.i.i65.i

l_done.i.i.i65.i:                                 ; preds = %l_tail_body.i.i.i169.i.prol.loopexit, %l_tail_body.i.i.i169.i, %l_tail_cond.i.i.i61.preheader.i
  %tacc.i.i.i63.lcssa.i = phi i64 [ %acc_next.i.i.i189.i.lcssa, %l_tail_cond.i.i.i61.preheader.i ], [ %tacc_next.i.i.i174.i.lcssa.unr, %l_tail_body.i.i.i169.i.prol.loopexit ], [ %tacc_next.i.i.i174.i.3, %l_tail_body.i.i.i169.i ]
  %s1.i.i.i.i66.i = lshr i64 %tacc.i.i.i63.lcssa.i, 30
  %x1.i.i.i.i67.i = xor i64 %s1.i.i.i.i66.i, %tacc.i.i.i63.lcssa.i
  br label %archx_hash_str.exit.i.i74.i

archx_hash_str.exit.i.i74.i:                      ; preds = %l_done.i.i.i65.i, %sso_mix.i.i.i202.i
  %x1.i.i.i.i67.sink.i = phi i64 [ %x1.i.i.i.i67.i, %l_done.i.i.i65.i ], [ %x1.i11.i.i.i210.i, %sso_mix.i.i.i202.i ]
  %ctrl.i.i.i81.i = load ptr, ptr %ctrl_p.i.i.i.i, align 8
  %c_null.i.i.i82.i = icmp eq ptr %ctrl.i.i.i81.i, null
  br i1 %c_null.i.i.i82.i, label %dget2.merge.53.i, label %do_probe.i.i.i83.i

do_probe.i.i.i83.i:                               ; preds = %archx_hash_str.exit.i.i74.i
  %m1.i.i.i.i68.i = mul i64 %x1.i.i.i.i67.sink.i, -4658895280553007687
  %s2.i.i.i.i69.i = lshr i64 %m1.i.i.i.i68.i, 27
  %x2.i.i.i.i70.i = xor i64 %s2.i.i.i.i69.i, %m1.i.i.i.i68.i
  %m2.i.i.i.i71.i = mul i64 %x2.i.i.i.i70.i, -7723592293110705685
  %s3.i.i.i.i72.i = lshr i64 %m2.i.i.i.i71.i, 31
  %x3.i.i.i.i73.i = xor i64 %s3.i.i.i.i72.i, %m2.i.i.i.i71.i
  %mask.i.i.i86.i = load i64, ptr %mask_p.i.i.i.i, align 8
  %keys.i.i.i87.i = load ptr, ptr %keys_p.i.i.i.i, align 8
  %27 = getelementptr i8, ptr %ctrl.i.i.i81.i, i64 %mask.i.i.i86.i
  %idx_base.i.i.i88.i = getelementptr i8, ptr %27, i64 17
  %h2_64.i.i.i89.i = lshr i64 %m2.i.i.i.i71.i, 57
  %h2.i.i.i90.i = trunc nuw nsw i64 %h2_64.i.i.i89.i to i8
  %h2_ins.i.i.i91.i = insertelement <16 x i8> poison, i8 %h2.i.i.i90.i, i64 0
  %h2_vec.i.i.i92.i = shufflevector <16 x i8> %h2_ins.i.i.i91.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bp_i.i.i.i.i137.i = and i64 %w1.i.i.i49.i, -4
  %bp.i.i.i.i141.i = inttoptr i64 %bp_i.i.i.i.i137.i to ptr
  %bp4.i.i.i.i143.i = getelementptr inbounds nuw i8, ptr %bp.i.i.i.i141.i, i64 4
  %rem.i.i.i.i144.i = add nsw i64 %len.i.i.i50.i, -4
  br label %probe.i.i.i93.i

probe.i.i.i93.i:                                  ; preds = %next_grp.i.i.i158.i, %do_probe.i.i.i83.i
  %h.pn.i.i.i94.i = phi i64 [ %x3.i.i.i.i73.i, %do_probe.i.i.i83.i ], [ %padd.i.i.i160.i, %next_grp.i.i.i158.i ]
  %step.i.i.i95.i = phi i64 [ 0, %do_probe.i.i.i83.i ], [ %step_next.i.i.i159.i, %next_grp.i.i.i158.i ]
  %avail.i.i.i96.i = phi i64 [ -1, %do_probe.i.i.i83.i ], [ %avail_cur.i.i.i152.i, %next_grp.i.i.i158.i ]
  %pos.i.i.i97.i = and i64 %h.pn.i.i.i94.i, %mask.i.i.i86.i
  %gp.i.i.i98.i = getelementptr inbounds i8, ptr %ctrl.i.i.i81.i, i64 %pos.i.i.i97.i
  %grp.i.i.i99.i = load <16 x i8>, ptr %gp.i.i.i98.i, align 1
  %mcmp.i.i.i100.i = icmp eq <16 x i8> %grp.i.i.i99.i, %h2_vec.i.i.i92.i
  %mbits.i.i.i101.i = bitcast <16 x i1> %mcmp.i.i.i100.i to i16
  %has_m.not.i.i.i105583.i = icmp eq i16 %mbits.i.i.i101.i, 0
  br i1 %has_m.not.i.i.i105583.i, label %chk_empty.i.i.i149.i, label %chk_key.i.i.i106.preheader.i

chk_key.i.i.i106.preheader.i:                     ; preds = %probe.i.i.i93.i
  %mmask0.i.i.i102.i = zext i16 %mbits.i.i.i101.i to i32
  br label %chk_key.i.i.i106.i

chk_key.i.i.i106.i:                               ; preds = %mbit_cont.i.i.i123.i, %chk_key.i.i.i106.preheader.i
  %mmask.i.i.i104584.i = phi i32 [ %mmask_next.i.i.i125.i, %mbit_cont.i.i.i123.i ], [ %mmask0.i.i.i102.i, %chk_key.i.i.i106.preheader.i ]
  %tz.i2.i.i107.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i104584.i, i1 true)
  %tz64.i.i.i108.i = zext nneg i32 %tz.i2.i.i107.i to i64
  %s_add.i.i.i109.i = add i64 %pos.i.i.i97.i, %tz64.i.i.i108.i
  %slot.i.i.i110.i = and i64 %s_add.i.i.i109.i, %mask.i.i.i86.i
  %ip.i.i.i111.i = getelementptr inbounds i32, ptr %idx_base.i.i.i88.i, i64 %slot.i.i.i110.i
  %didx32.i.i.i112.i = load i32, ptr %ip.i.i.i111.i, align 4
  %didx.i.i.i113.i = zext i32 %didx32.i.i.i112.i to i64
  %kp.i.i.i114.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i87.i, i64 %didx.i.i.i113.i
  %cand_k.unpack.i.i.i115.i = load i64, ptr %kp.i.i.i114.i, align 8
  %cand_k.elt1.i.i.i116.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i114.i, i64 8
  %cand_k.unpack2.i.i.i117.i = load i64, ptr %cand_k.elt1.i.i.i116.i, align 8
  %w0_eq.i.i.i.i120.i = icmp eq i64 %cand_k.unpack.i.i.i115.i, %w0.i.i.i48.i
  br i1 %w0_eq.i.i.i.i120.i, label %chk_len.i.i.i.i131.i, label %mbit_cont.i.i.i123.i

chk_len.i.i.i.i131.i:                             ; preds = %chk_key.i.i.i106.i
  br i1 %short.i.i.i51.i, label %cmp_short.i.i.i.i147.i, label %cmp_long.i.i.i.i135.i

cmp_short.i.i.i.i147.i:                           ; preds = %chk_len.i.i.i.i131.i
  %eq_s.i.i.i.i148.i = icmp eq i64 %cand_k.unpack2.i.i.i117.i, %w1.i.i.i49.i
  br i1 %eq_s.i.i.i.i148.i, label %dget2.hit.49.i, label %mbit_cont.i.i.i123.i

cmp_long.i.i.i.i135.i:                            ; preds = %chk_len.i.i.i.i131.i
  %ap_i.i.i.i.i136.i = and i64 %cand_k.unpack2.i.i.i117.i, -4
  %same_ptr.i.i.i.i138.i = icmp eq i64 %ap_i.i.i.i.i136.i, %bp_i.i.i.i.i137.i
  br i1 %same_ptr.i.i.i.i138.i, label %dget2.hit.49.i, label %archx_str_eq.exit.i.i.i121.i

archx_str_eq.exit.i.i.i121.i:                     ; preds = %cmp_long.i.i.i.i135.i
  %ap.i.i.i.i140.i = inttoptr i64 %ap_i.i.i.i.i136.i to ptr
  %ap4.i.i.i.i142.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i140.i, i64 4
  %bcmp.i.i.i.i145.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i.i142.i, ptr nonnull %bp4.i.i.i.i143.i, i64 %rem.i.i.i.i144.i)
  %eq_m.i.i.i.i146.i = icmp eq i32 %bcmp.i.i.i.i145.i, 0
  br i1 %eq_m.i.i.i.i146.i, label %dget2.hit.49.i, label %mbit_cont.i.i.i123.i

mbit_cont.i.i.i123.i:                             ; preds = %archx_str_eq.exit.i.i.i121.i, %cmp_short.i.i.i.i147.i, %chk_key.i.i.i106.i
  %mm1.i.i.i124.i = add nsw i32 %mmask.i.i.i104584.i, -1
  %mmask_next.i.i.i125.i = and i32 %mm1.i.i.i124.i, %mmask.i.i.i104584.i
  %has_m.not.i.i.i105.i = icmp eq i32 %mmask_next.i.i.i125.i, 0
  br i1 %has_m.not.i.i.i105.i, label %chk_empty.i.i.i149.i, label %chk_key.i.i.i106.i

chk_empty.i.i.i149.i:                             ; preds = %mbit_cont.i.i.i123.i, %probe.i.i.i93.i
  %need_a.i.i.i150.i = icmp slt i64 %avail.i.i.i96.i, 0
  br i1 %need_a.i.i.i150.i, label %find_a.i.i.i161.i, label %after_a.i.i.i151.i

find_a.i.i.i161.i:                                ; preds = %chk_empty.i.i.i149.i
  %acmp.i.i.i162.i = icmp slt <16 x i8> %grp.i.i.i99.i, zeroinitializer
  %abits16.i.i.i163.i = bitcast <16 x i1> %acmp.i.i.i162.i to i16
  %has_a0.not.i.i.i164.i = icmp eq i16 %abits16.i.i.i163.i, 0
  br i1 %has_a0.not.i.i.i164.i, label %after_a.i.i.i151.i, label %set_a.i.i.i165.i

set_a.i.i.i165.i:                                 ; preds = %find_a.i.i.i161.i
  %28 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i163.i, i1 true)
  %atz64.i.i.i166.i = zext nneg i16 %28 to i64
  %as_add.i.i.i167.i = add i64 %pos.i.i.i97.i, %atz64.i.i.i166.i
  %aslot.i.i.i168.i = and i64 %as_add.i.i.i167.i, %mask.i.i.i86.i
  br label %after_a.i.i.i151.i

after_a.i.i.i151.i:                               ; preds = %set_a.i.i.i165.i, %find_a.i.i.i161.i, %chk_empty.i.i.i149.i
  %avail_cur.i.i.i152.i = phi i64 [ %avail.i.i.i96.i, %chk_empty.i.i.i149.i ], [ -1, %find_a.i.i.i161.i ], [ %aslot.i.i.i168.i, %set_a.i.i.i165.i ]
  %ecmp.i.i.i153.i = icmp eq <16 x i8> %grp.i.i.i99.i, splat (i8 -128)
  %ebits.i.i.i154.i = bitcast <16 x i1> %ecmp.i.i.i153.i to i16
  %has_e.not.i.i.i155.i = icmp eq i16 %ebits.i.i.i154.i, 0
  br i1 %has_e.not.i.i.i155.i, label %next_grp.i.i.i158.i, label %dget2.merge.53.i

next_grp.i.i.i158.i:                              ; preds = %after_a.i.i.i151.i
  %step_next.i.i.i159.i = add i64 %step.i.i.i95.i, 16
  %padd.i.i.i160.i = add i64 %step_next.i.i.i159.i, %pos.i.i.i97.i
  br label %probe.i.i.i93.i

dget2.hit.49.i:                                   ; preds = %archx_str_eq.exit.i.i.i121.i, %cmp_long.i.i.i.i135.i, %cmp_short.i.i.i.i147.i
  %t161.i = load ptr, ptr %t26.i, align 8
  %t162.i = getelementptr inbounds nuw i64, ptr %t161.i, i64 %didx.i.i.i113.i
  %t163.i = load i64, ptr %t162.i, align 8
  br label %dget2.merge.53.i

dget2.merge.53.i:                                 ; preds = %after_a.i.i.i151.i, %dget2.hit.49.i, %archx_hash_str.exit.i.i74.i
  %t164.i = phi i64 [ %t163.i, %dget2.hit.49.i ], [ 0, %archx_hash_str.exit.i.i74.i ], [ 0, %after_a.i.i.i151.i ]
  %t165.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.str_checksum.0.1586.i, i64 %t164.i)
  %t167.i = extractvalue { i64, i1 } %t165.i, 1
  br i1 %t167.i, label %overflow.add.54.i, label %overflow.ok.55.i

overflow.add.54.i:                                ; preds = %dget2.merge.53.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.55.i:                                 ; preds = %dget2.merge.53.i
  %t166.i = extractvalue { i64, i1 } %t165.i, 0
  %tag.i42.i = and i64 %w1.i.i.i49.i, 1
  %owned.not.i43.i = icmp eq i64 %tag.i42.i, 0
  %or.cond532.i = select i1 %short.i.i.i51.i, i1 true, i1 %owned.not.i43.i
  br i1 %or.cond532.i, label %archx_str_drop.exit47.i, label %do_free.i44.i

do_free.i44.i:                                    ; preds = %overflow.ok.55.i
  %raw.i45.i = and i64 %w1.i.i.i49.i, -2
  %ptr.i46.i = inttoptr i64 %raw.i45.i to ptr
  call void @free(ptr %ptr.i46.i)
  br label %archx_str_drop.exit47.i

archx_str_drop.exit47.i:                          ; preds = %do_free.i44.i, %overflow.ok.55.i
  %t170.i = add nuw nsw i64 %for.p.118.0585.i, 1
  %exitcond627.not.i = icmp eq i64 %t170.i, 2048
  br i1 %exitcond627.not.i, label %l_done.i.i.i233.i, label %idx.ok.47.i

l_done.i.i.i233.i:                                ; preds = %archx_str_drop.exit47.i
  %ctrl.i.i.i249.i = load ptr, ptr %ctrl_p.i.i.i.i, align 8
  %c_null.i.i.i250.i = icmp eq ptr %ctrl.i.i.i249.i, null
  br i1 %c_null.i.i.i250.i, label %dget2.merge.63.i, label %do_probe.i.i.i251.i

do_probe.i.i.i251.i:                              ; preds = %l_done.i.i.i233.i
  %mask.i.i.i254.i = load i64, ptr %mask_p.i.i.i.i, align 8
  %keys.i.i.i255.i = load ptr, ptr %keys_p.i.i.i.i, align 8
  %29 = getelementptr i8, ptr %ctrl.i.i.i249.i, i64 %mask.i.i.i254.i
  %idx_base.i.i.i256.i = getelementptr i8, ptr %29, i64 17
  br label %probe.i.i.i261.i

probe.i.i.i261.i:                                 ; preds = %next_grp.i.i.i321.i, %do_probe.i.i.i251.i
  %h.pn.i.i.i262.i = phi i64 [ 479829472233321983, %do_probe.i.i.i251.i ], [ %padd.i.i.i323.i, %next_grp.i.i.i321.i ]
  %step.i.i.i263.i = phi i64 [ 0, %do_probe.i.i.i251.i ], [ %step_next.i.i.i322.i, %next_grp.i.i.i321.i ]
  %avail.i.i.i264.i = phi i64 [ -1, %do_probe.i.i.i251.i ], [ %avail_cur.i.i.i315.i, %next_grp.i.i.i321.i ]
  %pos.i.i.i265.i = and i64 %h.pn.i.i.i262.i, %mask.i.i.i254.i
  %gp.i.i.i266.i = getelementptr inbounds i8, ptr %ctrl.i.i.i249.i, i64 %pos.i.i.i265.i
  %grp.i.i.i267.i = load <16 x i8>, ptr %gp.i.i.i266.i, align 1
  %mcmp.i.i.i268.i = icmp eq <16 x i8> %grp.i.i.i267.i, splat (i8 3)
  %mbits.i.i.i269.i = bitcast <16 x i1> %mcmp.i.i.i268.i to i16
  %has_m.not.i.i.i273593.i = icmp eq i16 %mbits.i.i.i269.i, 0
  br i1 %has_m.not.i.i.i273593.i, label %chk_empty.i.i.i312.i, label %chk_key.i.i.i274.preheader.i

chk_key.i.i.i274.preheader.i:                     ; preds = %probe.i.i.i261.i
  %mmask0.i.i.i270.i = zext i16 %mbits.i.i.i269.i to i32
  br label %chk_key.i.i.i274.i

chk_key.i.i.i274.i:                               ; preds = %mbit_cont.i.i.i290.i, %chk_key.i.i.i274.preheader.i
  %mmask.i.i.i272594.i = phi i32 [ %mmask_next.i.i.i292.i, %mbit_cont.i.i.i290.i ], [ %mmask0.i.i.i270.i, %chk_key.i.i.i274.preheader.i ]
  %tz.i2.i.i275.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i272594.i, i1 true)
  %tz64.i.i.i276.i = zext nneg i32 %tz.i2.i.i275.i to i64
  %s_add.i.i.i277.i = add i64 %pos.i.i.i265.i, %tz64.i.i.i276.i
  %slot.i.i.i278.i = and i64 %s_add.i.i.i277.i, %mask.i.i.i254.i
  %ip.i.i.i279.i = getelementptr inbounds i32, ptr %idx_base.i.i.i256.i, i64 %slot.i.i.i278.i
  %didx32.i.i.i280.i = load i32, ptr %ip.i.i.i279.i, align 4
  %didx.i.i.i281.i = zext i32 %didx32.i.i.i280.i to i64
  %kp.i.i.i282.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i255.i, i64 %didx.i.i.i281.i
  %cand_k.unpack.i.i.i283.i = load i64, ptr %kp.i.i.i282.i, align 8
  %w0_eq.i.i.i.i287.i = icmp eq i64 %cand_k.unpack.i.i.i283.i, 8319108853555789841
  br i1 %w0_eq.i.i.i.i287.i, label %cmp_long.i.i.i.i301.i, label %mbit_cont.i.i.i290.i

cmp_long.i.i.i.i301.i:                            ; preds = %chk_key.i.i.i274.i
  %cand_k.elt1.i.i.i284.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i282.i, i64 8
  %cand_k.unpack2.i.i.i285.i = load i64, ptr %cand_k.elt1.i.i.i284.i, align 8
  %ap_i.i.i.i.i302.i = and i64 %cand_k.unpack2.i.i.i285.i, -4
  %same_ptr.i.i.i.i303.i = icmp eq i64 %ap_i.i.i.i.i302.i, ptrtoint (ptr @.str.0 to i64)
  br i1 %same_ptr.i.i.i.i303.i, label %if.merge.58.i, label %archx_str_eq.exit.i.i.i288.i

archx_str_eq.exit.i.i.i288.i:                     ; preds = %cmp_long.i.i.i.i301.i
  %ap.i.i.i.i305.i = inttoptr i64 %ap_i.i.i.i.i302.i to ptr
  %ap4.i.i.i.i306.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i305.i, i64 4
  %bcmp.i.i.i.i308.i = call i32 @bcmp(ptr noundef nonnull dereferenceable(13) %ap4.i.i.i.i306.i, ptr noundef nonnull dereferenceable(13) getelementptr inbounds nuw (i8, ptr @.str.0, i64 4), i64 13)
  %eq_m.i.i.i.i309.i = icmp eq i32 %bcmp.i.i.i.i308.i, 0
  br i1 %eq_m.i.i.i.i309.i, label %if.merge.58.i, label %mbit_cont.i.i.i290.i

mbit_cont.i.i.i290.i:                             ; preds = %archx_str_eq.exit.i.i.i288.i, %chk_key.i.i.i274.i
  %mm1.i.i.i291.i = add nsw i32 %mmask.i.i.i272594.i, -1
  %mmask_next.i.i.i292.i = and i32 %mm1.i.i.i291.i, %mmask.i.i.i272594.i
  %has_m.not.i.i.i273.i = icmp eq i32 %mmask_next.i.i.i292.i, 0
  br i1 %has_m.not.i.i.i273.i, label %chk_empty.i.i.i312.i, label %chk_key.i.i.i274.i

chk_empty.i.i.i312.i:                             ; preds = %mbit_cont.i.i.i290.i, %probe.i.i.i261.i
  %need_a.i.i.i313.i = icmp slt i64 %avail.i.i.i264.i, 0
  br i1 %need_a.i.i.i313.i, label %find_a.i.i.i324.i, label %after_a.i.i.i314.i

find_a.i.i.i324.i:                                ; preds = %chk_empty.i.i.i312.i
  %acmp.i.i.i325.i = icmp slt <16 x i8> %grp.i.i.i267.i, zeroinitializer
  %abits16.i.i.i326.i = bitcast <16 x i1> %acmp.i.i.i325.i to i16
  %has_a0.not.i.i.i327.i = icmp eq i16 %abits16.i.i.i326.i, 0
  br i1 %has_a0.not.i.i.i327.i, label %after_a.i.i.i314.i, label %set_a.i.i.i328.i

set_a.i.i.i328.i:                                 ; preds = %find_a.i.i.i324.i
  %30 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i326.i, i1 true)
  %atz64.i.i.i329.i = zext nneg i16 %30 to i64
  %as_add.i.i.i330.i = add i64 %pos.i.i.i265.i, %atz64.i.i.i329.i
  %aslot.i.i.i331.i = and i64 %as_add.i.i.i330.i, %mask.i.i.i254.i
  br label %after_a.i.i.i314.i

after_a.i.i.i314.i:                               ; preds = %set_a.i.i.i328.i, %find_a.i.i.i324.i, %chk_empty.i.i.i312.i
  %avail_cur.i.i.i315.i = phi i64 [ %avail.i.i.i264.i, %chk_empty.i.i.i312.i ], [ -1, %find_a.i.i.i324.i ], [ %aslot.i.i.i331.i, %set_a.i.i.i328.i ]
  %ecmp.i.i.i316.i = icmp eq <16 x i8> %grp.i.i.i267.i, splat (i8 -128)
  %ebits.i.i.i317.i = bitcast <16 x i1> %ecmp.i.i.i316.i to i16
  %has_e.not.i.i.i318.i = icmp eq i16 %ebits.i.i.i317.i, 0
  br i1 %has_e.not.i.i.i318.i, label %next_grp.i.i.i321.i, label %probe.i.i.i393.i

next_grp.i.i.i321.i:                              ; preds = %after_a.i.i.i314.i
  %step_next.i.i.i322.i = add i64 %step.i.i.i263.i, 16
  %padd.i.i.i323.i = add i64 %step_next.i.i.i322.i, %pos.i.i.i265.i
  br label %probe.i.i.i261.i

probe.i.i.i393.i:                                 ; preds = %after_a.i.i.i314.i, %next_grp.i.i.i453.i
  %h.pn.i.i.i394.i = phi i64 [ %padd.i.i.i455.i, %next_grp.i.i.i453.i ], [ 479829472233321983, %after_a.i.i.i314.i ]
  %step.i.i.i395.i = phi i64 [ %step_next.i.i.i454.i, %next_grp.i.i.i453.i ], [ 0, %after_a.i.i.i314.i ]
  %avail.i.i.i396.i = phi i64 [ %avail_cur.i.i.i447.i, %next_grp.i.i.i453.i ], [ -1, %after_a.i.i.i314.i ]
  %pos.i.i.i397.i = and i64 %h.pn.i.i.i394.i, %mask.i.i.i254.i
  %gp.i.i.i398.i = getelementptr inbounds i8, ptr %ctrl.i.i.i249.i, i64 %pos.i.i.i397.i
  %grp.i.i.i399.i = load <16 x i8>, ptr %gp.i.i.i398.i, align 1
  %mcmp.i.i.i400.i = icmp eq <16 x i8> %grp.i.i.i399.i, splat (i8 3)
  %mbits.i.i.i401.i = bitcast <16 x i1> %mcmp.i.i.i400.i to i16
  %has_m.not.i.i.i405601.i = icmp eq i16 %mbits.i.i.i401.i, 0
  br i1 %has_m.not.i.i.i405601.i, label %chk_empty.i.i.i444.i, label %chk_key.i.i.i406.preheader.i

chk_key.i.i.i406.preheader.i:                     ; preds = %probe.i.i.i393.i
  %mmask0.i.i.i402.i = zext i16 %mbits.i.i.i401.i to i32
  br label %chk_key.i.i.i406.i

chk_key.i.i.i406.i:                               ; preds = %mbit_cont.i.i.i422.i, %chk_key.i.i.i406.preheader.i
  %mmask.i.i.i404602.i = phi i32 [ %mmask_next.i.i.i424.i, %mbit_cont.i.i.i422.i ], [ %mmask0.i.i.i402.i, %chk_key.i.i.i406.preheader.i ]
  %tz.i2.i.i407.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i404602.i, i1 true)
  %tz64.i.i.i408.i = zext nneg i32 %tz.i2.i.i407.i to i64
  %s_add.i.i.i409.i = add i64 %pos.i.i.i397.i, %tz64.i.i.i408.i
  %slot.i.i.i410.i = and i64 %s_add.i.i.i409.i, %mask.i.i.i254.i
  %ip.i.i.i411.i = getelementptr inbounds i32, ptr %idx_base.i.i.i256.i, i64 %slot.i.i.i410.i
  %didx32.i.i.i412.i = load i32, ptr %ip.i.i.i411.i, align 4
  %didx.i.i.i413.i = zext i32 %didx32.i.i.i412.i to i64
  %kp.i.i.i414.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i255.i, i64 %didx.i.i.i413.i
  %cand_k.unpack.i.i.i415.i = load i64, ptr %kp.i.i.i414.i, align 8
  %w0_eq.i.i.i.i419.i = icmp eq i64 %cand_k.unpack.i.i.i415.i, 8319108853555789841
  br i1 %w0_eq.i.i.i.i419.i, label %cmp_long.i.i.i.i433.i, label %mbit_cont.i.i.i422.i

cmp_long.i.i.i.i433.i:                            ; preds = %chk_key.i.i.i406.i
  %cand_k.elt1.i.i.i416.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i414.i, i64 8
  %cand_k.unpack2.i.i.i417.i = load i64, ptr %cand_k.elt1.i.i.i416.i, align 8
  %ap_i.i.i.i.i434.i = and i64 %cand_k.unpack2.i.i.i417.i, -4
  %same_ptr.i.i.i.i435.i = icmp eq i64 %ap_i.i.i.i.i434.i, ptrtoint (ptr @.str.0 to i64)
  br i1 %same_ptr.i.i.i.i435.i, label %dget2.hit.59.i, label %archx_str_eq.exit.i.i.i420.i

archx_str_eq.exit.i.i.i420.i:                     ; preds = %cmp_long.i.i.i.i433.i
  %ap.i.i.i.i437.i = inttoptr i64 %ap_i.i.i.i.i434.i to ptr
  %ap4.i.i.i.i438.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i437.i, i64 4
  %bcmp.i.i.i.i440.i = call i32 @bcmp(ptr noundef nonnull dereferenceable(13) %ap4.i.i.i.i438.i, ptr noundef nonnull dereferenceable(13) getelementptr inbounds nuw (i8, ptr @.str.0, i64 4), i64 13)
  %eq_m.i.i.i.i441.i = icmp eq i32 %bcmp.i.i.i.i440.i, 0
  br i1 %eq_m.i.i.i.i441.i, label %dget2.hit.59.i, label %mbit_cont.i.i.i422.i

mbit_cont.i.i.i422.i:                             ; preds = %archx_str_eq.exit.i.i.i420.i, %chk_key.i.i.i406.i
  %mm1.i.i.i423.i = add nsw i32 %mmask.i.i.i404602.i, -1
  %mmask_next.i.i.i424.i = and i32 %mm1.i.i.i423.i, %mmask.i.i.i404602.i
  %has_m.not.i.i.i405.i = icmp eq i32 %mmask_next.i.i.i424.i, 0
  br i1 %has_m.not.i.i.i405.i, label %chk_empty.i.i.i444.i, label %chk_key.i.i.i406.i

chk_empty.i.i.i444.i:                             ; preds = %mbit_cont.i.i.i422.i, %probe.i.i.i393.i
  %need_a.i.i.i445.i = icmp slt i64 %avail.i.i.i396.i, 0
  br i1 %need_a.i.i.i445.i, label %find_a.i.i.i456.i, label %after_a.i.i.i446.i

find_a.i.i.i456.i:                                ; preds = %chk_empty.i.i.i444.i
  %acmp.i.i.i457.i = icmp slt <16 x i8> %grp.i.i.i399.i, zeroinitializer
  %abits16.i.i.i458.i = bitcast <16 x i1> %acmp.i.i.i457.i to i16
  %has_a0.not.i.i.i459.i = icmp eq i16 %abits16.i.i.i458.i, 0
  br i1 %has_a0.not.i.i.i459.i, label %after_a.i.i.i446.i, label %set_a.i.i.i460.i

set_a.i.i.i460.i:                                 ; preds = %find_a.i.i.i456.i
  %31 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i458.i, i1 true)
  %atz64.i.i.i461.i = zext nneg i16 %31 to i64
  %as_add.i.i.i462.i = add i64 %pos.i.i.i397.i, %atz64.i.i.i461.i
  %aslot.i.i.i463.i = and i64 %as_add.i.i.i462.i, %mask.i.i.i254.i
  br label %after_a.i.i.i446.i

after_a.i.i.i446.i:                               ; preds = %set_a.i.i.i460.i, %find_a.i.i.i456.i, %chk_empty.i.i.i444.i
  %avail_cur.i.i.i447.i = phi i64 [ %avail.i.i.i396.i, %chk_empty.i.i.i444.i ], [ -1, %find_a.i.i.i456.i ], [ %aslot.i.i.i463.i, %set_a.i.i.i460.i ]
  %ecmp.i.i.i448.i = icmp eq <16 x i8> %grp.i.i.i399.i, splat (i8 -128)
  %ebits.i.i.i449.i = bitcast <16 x i1> %ecmp.i.i.i448.i to i16
  %has_e.not.i.i.i450.i = icmp eq i16 %ebits.i.i.i449.i, 0
  br i1 %has_e.not.i.i.i450.i, label %next_grp.i.i.i453.i, label %dget2.merge.63.i

next_grp.i.i.i453.i:                              ; preds = %after_a.i.i.i446.i
  %step_next.i.i.i454.i = add i64 %step.i.i.i395.i, 16
  %padd.i.i.i455.i = add i64 %step_next.i.i.i454.i, %pos.i.i.i397.i
  br label %probe.i.i.i393.i

dget2.hit.59.i:                                   ; preds = %archx_str_eq.exit.i.i.i420.i, %cmp_long.i.i.i.i433.i
  %t181.i = load ptr, ptr %t26.i, align 8
  %t182.i = getelementptr inbounds nuw i64, ptr %t181.i, i64 %didx.i.i.i413.i
  %t183.i = load i64, ptr %t182.i, align 8
  br label %dget2.merge.63.i

dget2.merge.63.i:                                 ; preds = %after_a.i.i.i446.i, %dget2.hit.59.i, %l_done.i.i.i233.i
  %t184.i = phi i64 [ %t183.i, %dget2.hit.59.i ], [ 3, %l_done.i.i.i233.i ], [ 3, %after_a.i.i.i446.i ]
  %t185.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t166.i, i64 %t184.i)
  %t187.i = extractvalue { i64, i1 } %t185.i, 1
  br i1 %t187.i, label %overflow.add.64.i, label %overflow.ok.65.i

overflow.add.64.i:                                ; preds = %dget2.merge.63.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.65.i:                                 ; preds = %dget2.merge.63.i
  %t186.i = extractvalue { i64, i1 } %t185.i, 0
  br label %if.merge.58.i

if.merge.58.i:                                    ; preds = %archx_str_eq.exit.i.i.i288.i, %cmp_long.i.i.i.i301.i, %overflow.ok.65.i
  %var.str_checksum.0.2.i = phi i64 [ %t186.i, %overflow.ok.65.i ], [ %t166.i, %cmp_long.i.i.i.i301.i ], [ %t166.i, %archx_str_eq.exit.i.i.i288.i ]
  %t192.i = load i64, ptr %t25.i, align 8
  %t196603.i = icmp sgt i64 %t192.i, 0
  br i1 %t196603.i, label %foritems.body.70.lr.ph.i, label %archx_dict_drop_s_i.exit.i

foritems.body.70.lr.ph.i:                         ; preds = %if.merge.58.i
  %t202.i = load ptr, ptr %t26.i, align 8
  br label %foritems.body.70.i

foritems.body.70.i:                               ; preds = %overflow.ok.74.i, %foritems.body.70.lr.ph.i
  %foritems.idx.194.0605.i = phi i64 [ 0, %foritems.body.70.lr.ph.i ], [ %t212.i, %overflow.ok.74.i ]
  %var.str_checksum.0.3604.i = phi i64 [ %var.str_checksum.0.2.i, %foritems.body.70.lr.ph.i ], [ %t209.i, %overflow.ok.74.i ]
  %t205.i = getelementptr inbounds nuw i64, ptr %t202.i, i64 %foritems.idx.194.0605.i
  %t206.i = load i64, ptr %t205.i, align 8
  %t208.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.str_checksum.0.3604.i, i64 %t206.i)
  %t210.i = extractvalue { i64, i1 } %t208.i, 1
  br i1 %t210.i, label %overflow.add.73.i, label %overflow.ok.74.i

overflow.add.73.i:                                ; preds = %foritems.body.70.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.74.i:                                 ; preds = %foritems.body.70.i
  %t209.i = extractvalue { i64, i1 } %t208.i, 0
  %t212.i = add nuw nsw i64 %foritems.idx.194.0605.i, 1
  %exitcond628.not.i = icmp eq i64 %t212.i, %t192.i
  br i1 %exitcond628.not.i, label %foritems.end.72.i, label %foritems.body.70.i

foritems.end.72.i:                                ; preds = %overflow.ok.74.i
  %keys.i.i = load ptr, ptr %keys_p.i.i.i.i, align 8
  br label %d_elem.i.i

d_elem.i.i:                                       ; preds = %foritems.end.72.i, %archx_str_drop.exit.i.i
  %storemerge5.i.i = phi i64 [ %inext.i.i, %archx_str_drop.exit.i.i ], [ 0, %foritems.end.72.i ]
  %t0.i.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i, i64 %storemerge5.i.i
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
  %inext.i.i = add nuw nsw i64 %storemerge5.i.i, 1
  %exitcond.not.i.i = icmp eq i64 %inext.i.i, %t192.i
  br i1 %exitcond.not.i.i, label %archx_dict_drop_s_i.exit.i, label %d_elem.i.i

archx_dict_drop_s_i.exit.i:                       ; preds = %archx_str_drop.exit.i.i, %if.merge.58.i
  %var.str_checksum.0.3.lcssa644.i = phi i64 [ %var.str_checksum.0.2.i, %if.merge.58.i ], [ %t209.i, %archx_str_drop.exit.i.i ]
  %head.i.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i.i = icmp eq ptr %head.i.i, null
  br i1 %empty.i.i, label %archx_region_rewind_root.exit.i, label %archx_region_rewind_root.exit.thread.i

archx_region_rewind_root.exit.i:                  ; preds = %archx_dict_drop_s_i.exit.i
  %t215.i = add nuw nsw i64 %for.r.4.0607.i, 1
  %exitcond629.not.i = icmp eq i64 %t215.i, 120
  br i1 %exitcond629.not.i, label %archx_fn_run_str_bench.exit, label %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge

archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge: ; preds = %archx_region_rewind_root.exit.i
  %cur.i.i.i.pre.pre = load ptr, ptr %func.region.i, align 8
  %end.i.i.i.pre.pre = load ptr, ptr %.fca.1.gep.i, align 8
  br label %for.body.1.i.backedge

for.body.1.i.backedge:                            ; preds = %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge, %archx_region_rewind_root.exit.thread.i
  %end.i.i.i.be = phi ptr [ %end.i.i.i.pre.pre, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %end.i.i, %archx_region_rewind_root.exit.thread.i ]
  %cur.i.i.i.be = phi ptr [ %cur.i.i.i.pre.pre, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %data.i.i, %archx_region_rewind_root.exit.thread.i ]
  %for.r.4.0607.i.be = phi i64 [ %t215.i, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %t215652.i, %archx_region_rewind_root.exit.thread.i ]
  br label %for.body.1.i

archx_region_rewind_root.exit.thread.i:           ; preds = %archx_dict_drop_s_i.exit.i
  %cap_ptr.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 8
  %cap.i.i = load i64, ptr %cap_ptr.i.i, align 8
  %data.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 16
  %end.i.i = getelementptr inbounds i8, ptr %data.i.i, i64 %cap.i.i
  store ptr %data.i.i, ptr %func.region.i, align 8
  store ptr %end.i.i, ptr %.fca.1.gep.i, align 8
  store ptr %head.i.i, ptr %.fca.3.gep.i, align 8
  %t215652.i = add nuw nsw i64 %for.r.4.0607.i, 1
  %exitcond629.not653.i = icmp eq i64 %t215652.i, 120
  br i1 %exitcond629.not653.i, label %loop.i.i, label %for.body.1.i.backedge

loop.i.i:                                         ; preds = %archx_region_rewind_root.exit.thread.i, %loop.i.i
  %cur.i.i = phi ptr [ %next.i.i, %loop.i.i ], [ %head.i.i, %archx_region_rewind_root.exit.thread.i ]
  %next.i.i = load ptr, ptr %cur.i.i, align 8
  call void @free(ptr nonnull %cur.i.i)
  %more.not.i.i = icmp eq ptr %next.i.i, null
  br i1 %more.not.i.i, label %archx_fn_run_str_bench.exit, label %loop.i.i

archx_fn_run_str_bench.exit:                      ; preds = %archx_region_rewind_root.exit.i, %loop.i.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  %t117 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %var.str_checksum.0.3.lcssa644.i)
  %hp.i.i113 = call noalias align 16 dereferenceable_or_null(64) ptr @calloc(i64 1, i64 64)
  %hnull.i.i114 = icmp eq ptr %hp.i.i113, null
  br i1 %hnull.i.i114, label %oom.i.i131, label %archx_dict_new.exit.i115

oom.i.i131:                                       ; preds = %archx_fn_run_str_bench.exit
  call fastcc void @archx_oom_fail()
  unreachable

archx_dict_new.exit.i115:                         ; preds = %archx_fn_run_str_bench.exit
  %h_meta_gep.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i113, i64 56
  store i64 34359740416, ptr %h_meta_gep.i.i, align 8
  %hpi.i.i = ptrtoint ptr %hp.i.i113 to i64
  %htag.i.i = or disjoint i64 %hpi.i.i, 1
  %t39.i = getelementptr inbounds nuw i8, ptr %hp.i.i113, i64 48
  br label %overflow.ok.5.i

for.cond.14.preheader.i:                          ; preds = %overflow.ok.5.i
  %ctrl_p.i.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i113, i64 32
  %mask_p.i.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i113, i64 16
  %keys_p.i.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i113, i64 40
  br label %overflow.ok.21.i

overflow.ok.5.i:                                  ; preds = %overflow.ok.5.i, %archx_dict_new.exit.i115
  %for.i.2.029.i = phi i64 [ 0, %archx_dict_new.exit.i115 ], [ %t43.i, %overflow.ok.5.i ]
  %t7.i = mul nuw nsw i64 %for.i.2.029.i, 17
  %t10.i = add nuw nsw i64 %t7.i, 3
  %32 = trunc nuw nsw i64 %for.i.2.029.i to i32
  %33 = mul nuw nsw i32 %32, 31
  %t26.lhs.trunc.i = add nuw nsw i32 %33, 7
  %t2621.i = urem i32 %t26.lhs.trunc.i, 100000
  %t26.zext.i = zext nneg i32 %t2621.i to i64
  %t34.i = call fastcc i64 @archx_dict_upsert_i64(i64 %htag.i.i, i64 %t10.i)
  %t40.i116 = load ptr, ptr %t39.i, align 16
  %t41.i117 = getelementptr inbounds i64, ptr %t40.i116, i64 %t34.i
  store i64 %t26.zext.i, ptr %t41.i117, align 8
  %t43.i = add nuw nsw i64 %for.i.2.029.i, 1
  %exitcond.not.i118 = icmp eq i64 %t43.i, 32768
  br i1 %exitcond.not.i118, label %for.cond.14.preheader.i, label %overflow.ok.5.i

overflow.ok.21.i:                                 ; preds = %overflow.ok.25.i, %for.cond.14.preheader.i
  %for.i.45.033.i = phi i64 [ 0, %for.cond.14.preheader.i ], [ %t74.i, %overflow.ok.25.i ]
  %var.popped_sum.44.032.i = phi i64 [ 0, %for.cond.14.preheader.i ], [ %t71.i, %overflow.ok.25.i ]
  %t50.i = mul nuw nsw i64 %for.i.45.033.i, 17
  %t53.i = or disjoint i64 %t50.i, 3
  %ctrl.i.i.i = load ptr, ptr %ctrl_p.i.i.i, align 16
  %c_null.i.i.i = icmp eq ptr %ctrl.i.i.i, null
  br i1 %c_null.i.i.i, label %archx_dict_find_i64.exit.i, label %do_probe.i.i.i

do_probe.i.i.i:                                   ; preds = %overflow.ok.21.i
  %m1.i.i.i = mul i64 %t53.i, -4658895280553007687
  %s2.i.i.i = lshr i64 %m1.i.i.i, 27
  %x2.i.i.i = xor i64 %s2.i.i.i, %m1.i.i.i
  %m2.i.i.i = mul i64 %x2.i.i.i, -7723592293110705685
  %s3.i.i.i = lshr i64 %m2.i.i.i, 31
  %x3.i.i.i = xor i64 %s3.i.i.i, %m2.i.i.i
  %mask.i.i.i = load i64, ptr %mask_p.i.i.i, align 16
  %keys.i.i.i = load ptr, ptr %keys_p.i.i.i, align 8
  %34 = getelementptr i8, ptr %ctrl.i.i.i, i64 %mask.i.i.i
  %idx_base.i.i.i = getelementptr i8, ptr %34, i64 17
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
  %gp.i.i.i = getelementptr inbounds i8, ptr %ctrl.i.i.i, i64 %pos.i.i.i
  %grp.i.i.i = load <16 x i8>, ptr %gp.i.i.i, align 1
  %mcmp.i.i.i = icmp eq <16 x i8> %grp.i.i.i, %h2_vec.i.i.i
  %mbits.i.i.i = bitcast <16 x i1> %mcmp.i.i.i to i16
  %has_m.not.i.i30.i = icmp eq i16 %mbits.i.i.i, 0
  br i1 %has_m.not.i.i30.i, label %chk_empty.i.i.i, label %chk_key.i.i.preheader.i

chk_key.i.i.preheader.i:                          ; preds = %probe.i.i.i
  %mmask0.i.i.i = zext i16 %mbits.i.i.i to i32
  br label %chk_key.i.i.i

chk_key.i.i.i:                                    ; preds = %mbit_cont.i.i.i, %chk_key.i.i.preheader.i
  %mmask.i.i31.i = phi i32 [ %mmask_next.i.i.i, %mbit_cont.i.i.i ], [ %mmask0.i.i.i, %chk_key.i.i.preheader.i ]
  %tz.i.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i31.i, i1 true)
  %tz64.i.i.i = zext nneg i32 %tz.i.i.i to i64
  %s_add.i.i.i = add i64 %pos.i.i.i, %tz64.i.i.i
  %slot.i.i.i = and i64 %s_add.i.i.i, %mask.i.i.i
  %ip.i.i.i = getelementptr inbounds i32, ptr %idx_base.i.i.i, i64 %slot.i.i.i
  %didx32.i.i.i = load i32, ptr %ip.i.i.i, align 4
  %didx.i.i.i = zext i32 %didx32.i.i.i to i64
  %kp.i.i.i = getelementptr inbounds nuw i64, ptr %keys.i.i.i, i64 %didx.i.i.i
  %cand_k.i.i.i = load i64, ptr %kp.i.i.i, align 8
  %eq.i.i.i = icmp eq i64 %cand_k.i.i.i, %t53.i
  br i1 %eq.i.i.i, label %found.i.i.i, label %mbit_cont.i.i.i

mbit_cont.i.i.i:                                  ; preds = %chk_key.i.i.i
  %mm1.i.i.i = add nsw i32 %mmask.i.i31.i, -1
  %mmask_next.i.i.i = and i32 %mm1.i.i.i, %mmask.i.i31.i
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
  %35 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i, i1 true)
  %atz64.i.i.i = zext nneg i16 %35 to i64
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
  br label %archx_dict_find_i64.exit.i

not_found_avail.i.i.i:                            ; preds = %after_a.i.i.i
  %nf1.i.i.i = insertvalue { i64, i64 } { i64 -1, i64 poison }, i64 %avail_cur.i.i.i, 1
  br label %archx_dict_find_i64.exit.i

archx_dict_find_i64.exit.i:                       ; preds = %not_found_avail.i.i.i, %found.i.i.i, %overflow.ok.21.i
  %common.ret.op.i.i.i119 = phi { i64, i64 } [ %f1.i.i.i, %found.i.i.i ], [ %nf1.i.i.i, %not_found_avail.i.i.i ], [ { i64 -1, i64 -1 }, %overflow.ok.21.i ]
  %t59.i120 = extractvalue { i64, i64 } %common.ret.op.i.i.i119, 0
  %t61.i = icmp sgt i64 %t59.i120, -1
  br i1 %t61.i, label %dpop.hit.22.i, label %dpop.miss.23.i

dpop.miss.23.i:                                   ; preds = %archx_dict_find_i64.exit.i
  call fastcc void @archx_key_fail()
  unreachable

dpop.hit.22.i:                                    ; preds = %archx_dict_find_i64.exit.i
  %t60.i = extractvalue { i64, i64 } %common.ret.op.i.i.i119, 1
  %t67.i = load ptr, ptr %t39.i, align 16
  %t68.i = getelementptr inbounds nuw i64, ptr %t67.i, i64 %t59.i120
  %t69.i = load i64, ptr %t68.i, align 8
  %len.i.i = load i64, ptr %hp.i.i113, align 16
  %mask.i.i = load i64, ptr %mask_p.i.i.i, align 16
  %keys.i.i121 = load ptr, ptr %keys_p.i.i.i, align 8
  %meta.i.i = load i64, ptr %h_meta_gep.i.i, align 8
  %36 = getelementptr i8, ptr %ctrl.i.i.i, i64 %mask.i.i
  %idx_base.i.i = getelementptr i8, ptr %36, i64 17
  %sp_ip.i.i = getelementptr inbounds i32, ptr %idx_base.i.i, i64 %t60.i
  %d_idx32.i.i = load i32, ptr %sp_ip.i.i, align 4
  %d_idx.i.i = zext i32 %d_idx32.i.i to i64
  %p.i.i.i = getelementptr inbounds i8, ptr %ctrl.i.i.i, i64 %t60.i
  store i8 -2, ptr %p.i.i.i, align 1
  %mir.i.i.i = icmp ult i64 %t60.i, 16
  br i1 %mir.i.i.i, label %do_mir.i.i.i, label %archx_dict_set_ctrl.exit.i.i

do_mir.i.i.i:                                     ; preds = %dpop.hit.22.i
  %37 = getelementptr i8, ptr %36, i64 1
  %mp.i.i.i = getelementptr i8, ptr %37, i64 %t60.i
  store i8 -2, ptr %mp.i.i.i, align 1
  br label %archx_dict_set_ctrl.exit.i.i

archx_dict_set_ctrl.exit.i.i:                     ; preds = %do_mir.i.i.i, %dpop.hit.22.i
  %last.i.i = add i64 %len.i.i, -1
  store i64 %last.i.i, ptr %hp.i.i113, align 16
  %need_swap.i.i = icmp sgt i64 %last.i.i, %d_idx.i.i
  br i1 %need_swap.i.i, label %do_swap.i.i, label %archx_dict_erase_slot.exit.i

do_swap.i.i:                                      ; preds = %archx_dict_set_ctrl.exit.i.i
  %kind.i.i = and i64 %meta.i.i, 255
  %ksz_sh.i.i = lshr i64 %meta.i.i, 8
  %ksz.i.i = and i64 %ksz_sh.i.i, 16777215
  %kd_off.i.i = mul nuw nsw i64 %ksz.i.i, %d_idx.i.i
  %kl_off.i.i = mul i64 %ksz.i.i, %last.i.i
  %kd_p.i.i = getelementptr inbounds nuw i8, ptr %keys.i.i121, i64 %kd_off.i.i
  %kl_p.i.i = getelementptr inbounds i8, ptr %keys.i.i121, i64 %kl_off.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %kd_p.i.i, ptr nonnull align 1 %kl_p.i.i, i64 %ksz.i.i, i1 false)
  %has_v.not.i.i = icmp ult i64 %meta.i.i, 4294967296
  br i1 %has_v.not.i.i, label %fix_sparse.i.i, label %swap_v.i.i

swap_v.i.i:                                       ; preds = %do_swap.i.i
  %vsz.i.i = lshr i64 %meta.i.i, 32
  %vd_off.i.i = mul nuw i64 %vsz.i.i, %d_idx.i.i
  %vl_off.i.i = mul i64 %vsz.i.i, %last.i.i
  %vd_p.i.i = getelementptr inbounds i8, ptr %t67.i, i64 %vd_off.i.i
  %vl_p.i.i = getelementptr inbounds i8, ptr %t67.i, i64 %vl_off.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %vd_p.i.i, ptr nonnull align 1 %vl_p.i.i, i64 %vsz.i.i, i1 false)
  br label %fix_sparse.i.i

fix_sparse.i.i:                                   ; preds = %swap_v.i.i, %do_swap.i.i
  %h.i.i = call fastcc i64 @archx_dict_key_hash_at(ptr %keys.i.i121, i64 %d_idx.i.i, i64 %kind.i.i)
  %h2_64.i.i = lshr i64 %h.i.i, 57
  %h2.i.i = trunc nuw nsw i64 %h2_64.i.i to i8
  %h2_ins.i.i = insertelement <16 x i8> poison, i8 %h2.i.i, i64 0
  %h2_vec.i.i = shufflevector <16 x i8> %h2_ins.i.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %last32.i.i = trunc i64 %last.i.i to i32
  br label %fprobe.i.i

fprobe.i.i:                                       ; preds = %fnext_grp.i.i, %fix_sparse.i.i
  %h.pn.i.i = phi i64 [ %h.i.i, %fix_sparse.i.i ], [ %padd.i.i, %fnext_grp.i.i ]
  %step.i.i = phi i64 [ 0, %fix_sparse.i.i ], [ %step_next.i.i, %fnext_grp.i.i ]
  %pos.i.i = and i64 %h.pn.i.i, %mask.i.i
  %gp.i.i = getelementptr inbounds i8, ptr %ctrl.i.i.i, i64 %pos.i.i
  %grp.i.i = load <16 x i8>, ptr %gp.i.i, align 1
  %mcmp.i.i = icmp eq <16 x i8> %grp.i.i, %h2_vec.i.i
  %mbits.i.i = bitcast <16 x i1> %mcmp.i.i to i16
  %has_m.not1.i.i = icmp eq i16 %mbits.i.i, 0
  br i1 %has_m.not1.i.i, label %fnext_grp.i.i, label %fchk.preheader.i.i

fchk.preheader.i.i:                               ; preds = %fprobe.i.i
  %mmask0.i.i = zext i16 %mbits.i.i to i32
  br label %fchk.i.i

fchk.i.i:                                         ; preds = %fbit_cont.i.i, %fchk.preheader.i.i
  %mmask2.i.i = phi i32 [ %mmask_next.i.i, %fbit_cont.i.i ], [ %mmask0.i.i, %fchk.preheader.i.i ]
  %tz.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask2.i.i, i1 true)
  %tz64.i.i = zext nneg i32 %tz.i.i to i64
  %s_add.i.i = add i64 %pos.i.i, %tz64.i.i
  %cand.i.i = and i64 %s_add.i.i, %mask.i.i
  %cip.i.i = getelementptr inbounds i32, ptr %idx_base.i.i, i64 %cand.i.i
  %cv.i.i = load i32, ptr %cip.i.i, align 4
  %hit.i.i = icmp eq i32 %cv.i.i, %last32.i.i
  br i1 %hit.i.i, label %fupdate.i.i, label %fbit_cont.i.i

fbit_cont.i.i:                                    ; preds = %fchk.i.i
  %mm1.i.i = add nsw i32 %mmask2.i.i, -1
  %mmask_next.i.i = and i32 %mm1.i.i, %mmask2.i.i
  %has_m.not.i.i = icmp eq i32 %mmask_next.i.i, 0
  br i1 %has_m.not.i.i, label %fnext_grp.i.i, label %fchk.i.i

fnext_grp.i.i:                                    ; preds = %fbit_cont.i.i, %fprobe.i.i
  %step_next.i.i = add i64 %step.i.i, 16
  %padd.i.i = add i64 %step_next.i.i, %pos.i.i
  br label %fprobe.i.i

fupdate.i.i:                                      ; preds = %fchk.i.i
  %cip.i.i.le = getelementptr inbounds i32, ptr %idx_base.i.i, i64 %cand.i.i
  store i32 %d_idx32.i.i, ptr %cip.i.i.le, align 4
  br label %archx_dict_erase_slot.exit.i

archx_dict_erase_slot.exit.i:                     ; preds = %fupdate.i.i, %archx_dict_set_ctrl.exit.i.i
  %t70.i122 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.popped_sum.44.032.i, i64 %t69.i)
  %t72.i = extractvalue { i64, i1 } %t70.i122, 1
  br i1 %t72.i, label %overflow.add.24.i, label %overflow.ok.25.i

overflow.add.24.i:                                ; preds = %archx_dict_erase_slot.exit.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.25.i:                                 ; preds = %archx_dict_erase_slot.exit.i
  %t71.i = extractvalue { i64, i1 } %t70.i122, 0
  %t74.i = add nuw nsw i64 %for.i.45.033.i, 4
  %t48.i = icmp samesign ult i64 %for.i.45.033.i, 32764
  br i1 %t48.i, label %overflow.ok.21.i, label %overflow.ok.31.i

overflow.ok.31.i:                                 ; preds = %overflow.ok.25.i, %overflow.ok.31.i
  %for.j.75.034.i = phi i64 [ %t103.i, %overflow.ok.31.i ], [ 0, %overflow.ok.25.i ]
  %t80.i = mul nuw nsw i64 %for.j.75.034.i, 13
  %t83.i = add nuw nsw i64 %t80.i, 1000000
  %t88.i = mul nuw nsw i64 %for.j.75.034.i, 5
  %t91.i123 = add nuw nsw i64 %t88.i, 1
  %t94.i124 = call fastcc i64 @archx_dict_upsert_i64(i64 %htag.i.i, i64 %t83.i)
  %t100.i = load ptr, ptr %t39.i, align 16
  %t101.i125 = getelementptr inbounds i64, ptr %t100.i, i64 %t94.i124
  store i64 %t91.i123, ptr %t101.i125, align 8
  %t103.i = add nuw nsw i64 %for.j.75.034.i, 1
  %exitcond43.not.i = icmp eq i64 %t103.i, 8192
  br i1 %exitcond43.not.i, label %dlen.load.39.i, label %overflow.ok.31.i

dlen.load.39.i:                                   ; preds = %overflow.ok.31.i
  %t109.i126 = load i64, ptr %hp.i.i113, align 16
  %t111.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t71.i, i64 %t109.i126)
  %t113.i127 = extractvalue { i64, i1 } %t111.i, 1
  br i1 %t113.i127, label %overflow.add.41.i, label %overflow.ok.42.i

overflow.add.41.i:                                ; preds = %dlen.load.39.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.42.i:                                 ; preds = %dlen.load.39.i
  %t112.i128 = extractvalue { i64, i1 } %t111.i, 0
  %t12735.i = icmp sgt i64 %t109.i126, 0
  %t133.i = load ptr, ptr %t39.i, align 16
  %t132.i = load ptr, ptr %keys_p.i.i.i, align 8
  br label %dlen.load.48.i

dlen.load.48.i:                                   ; preds = %for.step.45.i, %overflow.ok.42.i
  %for._pass.115.039.i = phi i64 [ 0, %overflow.ok.42.i ], [ %t161.i129, %for.step.45.i ]
  %var.int_checksum.114.038.i = phi i64 [ %t112.i128, %overflow.ok.42.i ], [ %var.int_checksum.114.1.lcssa.i, %for.step.45.i ]
  br i1 %t12735.i, label %mod.ok.55.i, label %for.step.45.i

mod.ok.55.i:                                      ; preds = %dlen.load.48.i, %overflow.ok.59.i
  %foritems.idx.125.037.i = phi i64 [ %t159.i, %overflow.ok.59.i ], [ 0, %dlen.load.48.i ]
  %var.int_checksum.114.136.i = phi i64 [ %t156.i, %overflow.ok.59.i ], [ %var.int_checksum.114.038.i, %dlen.load.48.i ]
  %t136.i = getelementptr inbounds nuw i64, ptr %t133.i, i64 %foritems.idx.125.037.i
  %t137.i = load i64, ptr %t136.i, align 8
  %t134.i = getelementptr inbounds nuw i64, ptr %t132.i, i64 %foritems.idx.125.037.i
  %t135.i = load i64, ptr %t134.i, align 8
  %t144.i = srem i64 %t135.i, 997
  %t146.i = icmp slt i64 %t144.i, 0
  %t150.i = select i1 %t146.i, i64 997, i64 0
  %t151.i = add nsw i64 %t150.i, %t144.i
  %t152.i = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t151.i, i64 %t137.i)
  %t154.i = extractvalue { i64, i1 } %t152.i, 1
  br i1 %t154.i, label %overflow.mul.56.i, label %overflow.ok.57.i

overflow.mul.56.i:                                ; preds = %mod.ok.55.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.57.i:                                 ; preds = %mod.ok.55.i
  %t153.i = extractvalue { i64, i1 } %t152.i, 0
  %t155.i = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.int_checksum.114.136.i, i64 %t153.i)
  %t157.i = extractvalue { i64, i1 } %t155.i, 1
  br i1 %t157.i, label %overflow.add.58.i, label %overflow.ok.59.i

overflow.add.58.i:                                ; preds = %overflow.ok.57.i
  call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.59.i:                                 ; preds = %overflow.ok.57.i
  %t156.i = extractvalue { i64, i1 } %t155.i, 0
  %t159.i = add nuw nsw i64 %foritems.idx.125.037.i, 1
  %exitcond44.not.i = icmp eq i64 %t159.i, %t109.i126
  br i1 %exitcond44.not.i, label %for.step.45.i, label %mod.ok.55.i

for.step.45.i:                                    ; preds = %overflow.ok.59.i, %dlen.load.48.i
  %var.int_checksum.114.1.lcssa.i = phi i64 [ %var.int_checksum.114.038.i, %dlen.load.48.i ], [ %t156.i, %overflow.ok.59.i ]
  %t161.i129 = add nuw nsw i64 %for._pass.115.039.i, 1
  %exitcond45.not.i = icmp eq i64 %t161.i129, 40
  br i1 %exitcond45.not.i, label %archx_fn_run_int_bench.exit, label %dlen.load.48.i

archx_fn_run_int_bench.exit:                      ; preds = %for.step.45.i
  %ctrl.i20.i = load ptr, ptr %ctrl_p.i.i.i, align 16
  call void @free(ptr %ctrl.i20.i)
  call void @free(ptr %t132.i)
  call void @free(ptr %t133.i)
  call void @free(ptr %hp.i.i113)
  %t119 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %var.int_checksum.114.1.lcssa.i)
  br label %loop.i

loop.i:                                           ; preds = %archx_fn_run_int_bench.exit, %archx_str_drop.exit.i140
  %i.i = phi i64 [ %inext.i, %archx_str_drop.exit.i140 ], [ 0, %archx_fn_run_int_bench.exit ]
  %ep.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %i.i
  %t0.unpack.i = load i64, ptr %ep.i, align 8
  %t0.elt1.i = getelementptr inbounds nuw i8, ptr %ep.i, i64 8
  %t0.unpack2.i = load i64, ptr %t0.elt1.i, align 8
  %len.i.i133 = and i64 %t0.unpack.i, 4294967295
  %long.i.i = icmp samesign ult i64 %len.i.i133, 13
  %tag.i.i134 = and i64 %t0.unpack2.i, 1
  %owned.not.i.i135 = icmp eq i64 %tag.i.i134, 0
  %or.cond.i136 = select i1 %long.i.i, i1 true, i1 %owned.not.i.i135
  br i1 %or.cond.i136, label %archx_str_drop.exit.i140, label %do_free.i.i137

do_free.i.i137:                                   ; preds = %loop.i
  %raw.i.i138 = and i64 %t0.unpack2.i, -2
  %ptr.i.i139 = inttoptr i64 %raw.i.i138 to ptr
  call void @free(ptr %ptr.i.i139)
  br label %archx_str_drop.exit.i140

archx_str_drop.exit.i140:                         ; preds = %do_free.i.i137, %loop.i
  %inext.i = add nuw nsw i64 %i.i, 1
  %exitcond.not.i141 = icmp eq i64 %i.i, 1023
  br i1 %exitcond.not.i141, label %check.free.i, label %loop.i

check.free.i:                                     ; preds = %archx_str_drop.exit.i140
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

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #3

; Function Attrs: nofree nounwind
declare noundef i32 @sprintf(ptr noalias noundef writeonly captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #4

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_key_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.2)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, inaccessiblemem: none)
define private fastcc i64 @archx_dict_key_hash_at(ptr readonly captures(none) %keys, i64 %idx, i64 range(i64 0, 256) %kind) unnamed_addr #12 {
entry:
  %is0 = icmp eq i64 %kind, 0
  br i1 %is0, label %k_i64, label %k_str

common.ret:                                       ; preds = %l_done.i, %sso_mix.i, %k_i64
  %x1.i.i.sink = phi i64 [ %x1.i.i, %l_done.i ], [ %x1.i11.i, %sso_mix.i ], [ %x1.i, %k_i64 ]
  %m1.i.i = mul i64 %x1.i.i.sink, -4658895280553007687
  %s2.i.i = lshr i64 %m1.i.i, 27
  %x2.i.i = xor i64 %s2.i.i, %m1.i.i
  %m2.i.i = mul i64 %x2.i.i, -7723592293110705685
  %s3.i.i = lshr i64 %m2.i.i, 31
  %x3.i.i = xor i64 %s3.i.i, %m2.i.i
  ret i64 %x3.i.i

k_i64:                                            ; preds = %entry
  %pi = getelementptr inbounds i64, ptr %keys, i64 %idx
  %vi = load i64, ptr %pi, align 8
  %s1.i = lshr i64 %vi, 30
  %x1.i = xor i64 %s1.i, %vi
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
  %m1.i4 = xor i64 %notmask.i, -1
  %p1_m.i = and i64 %vs.unpack2, %m1.i4
  br label %sso_mix.i

sso_mix.i:                                        ; preds = %sso_mid.i, %sso_gt4.i, %sso_le4.i
  %p0.i = phi i64 [ %p0_4.i, %sso_le4.i ], [ %p0_raw.i, %sso_mid.i ], [ %p0_raw.i, %sso_gt4.i ]
  %p1.i = phi i64 [ 0, %sso_le4.i ], [ %p1_m.i, %sso_mid.i ], [ %vs.unpack2, %sso_gt4.i ]
  %a0.i = mul i64 %p0.i, -7046029254386353131
  %a1.i = mul i64 %p1.i, -4417276706812531889
  %ax.i = xor i64 %a1.i, %a0.i
  %s1.i10.i = lshr i64 %ax.i, 30
  %0 = xor i64 %len.i, %s1.i10.i
  %x1.i11.i = xor i64 %0, %ax.i
  br label %common.ret

long_hash.i:                                      ; preds = %k_str
  %raw.i = and i64 %vs.unpack2, -4
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
  %acc.i6.unr = phi i64 [ %seed.i, %long_hash.i ], [ %acc_next.i.1, %l_body.i ]
  %idx.i5.unr = phi i64 [ 0, %long_hash.i ], [ %idx_next.i.1, %l_body.i ]
  %5 = and i64 %1, 8
  %lcmp.mod.not.not = icmp eq i64 %5, 0
  br i1 %lcmp.mod.not.not, label %l_body.i.epil, label %l_tail_cond.i.preheader

l_body.i.epil:                                    ; preds = %l_tail_cond.i.preheader.unr-lcssa
  %lp.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %idx.i5.unr
  %lane.i.epil = load i64, ptr %lp.i.epil, align 4
  %lm.i.epil = mul i64 %lane.i.epil, -4417276706812531889
  %lx.i.epil = xor i64 %lm.i.epil, %acc.i6.unr
  %s1.i2.i.epil = lshr i64 %lx.i.epil, 30
  %x1.i3.i.epil = xor i64 %s1.i2.i.epil, %lx.i.epil
  %m1.i4.i.epil = mul i64 %x1.i3.i.epil, -4658895280553007687
  %s2.i5.i.epil = lshr i64 %m1.i4.i.epil, 27
  %x2.i6.i.epil = xor i64 %s2.i5.i.epil, %m1.i4.i.epil
  %m2.i7.i.epil = mul i64 %x2.i6.i.epil, -7723592293110705685
  %s3.i8.i.epil = lshr i64 %m2.i7.i.epil, 31
  %x3.i9.i.epil = xor i64 %s3.i8.i.epil, %m2.i7.i.epil
  %acc_next.i.epil = add i64 %x3.i9.i.epil, %idx.i5.unr
  %idx_next.i.epil = add nuw nsw i64 %idx.i5.unr, 8
  br label %l_tail_cond.i.preheader

l_tail_cond.i.preheader:                          ; preds = %l_tail_cond.i.preheader.unr-lcssa, %l_body.i.epil
  %acc_next.i.lcssa = phi i64 [ %acc_next.i.lcssa.ph, %l_tail_cond.i.preheader.unr-lcssa ], [ %acc_next.i.epil, %l_body.i.epil ]
  %idx_next.i.lcssa = phi i64 [ %idx_next.i.lcssa.ph, %l_tail_cond.i.preheader.unr-lcssa ], [ %idx_next.i.epil, %l_body.i.epil ]
  %tmore.i7 = icmp samesign ult i64 %idx_next.i.lcssa, %len.i
  br i1 %tmore.i7, label %l_tail_body.i.preheader, label %l_done.i

l_tail_body.i.preheader:                          ; preds = %l_tail_cond.i.preheader
  %6 = sub i64 %vs.unpack, %idx_next.i.lcssa
  %xtraiter14 = and i64 %6, 3
  %lcmp.mod15.not = icmp eq i64 %xtraiter14, 0
  br i1 %lcmp.mod15.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol

l_tail_body.i.prol:                               ; preds = %l_tail_body.i.preheader, %l_tail_body.i.prol
  %tacc.i9.prol = phi i64 [ %tacc_next.i.prol, %l_tail_body.i.prol ], [ %acc_next.i.lcssa, %l_tail_body.i.preheader ]
  %ti.i8.prol = phi i64 [ %ti_next.i.prol, %l_tail_body.i.prol ], [ %idx_next.i.lcssa, %l_tail_body.i.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %l_tail_body.i.prol ], [ 0, %l_tail_body.i.preheader ]
  %tp.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %ti.i8.prol
  %tb.i.prol = load i8, ptr %tp.i.prol, align 1
  %tz.i.prol = zext i8 %tb.i.prol to i64
  %tx.i.prol = xor i64 %tacc.i9.prol, %tz.i.prol
  %tacc_next.i.prol = mul i64 %tx.i.prol, 1099511628211
  %ti_next.i.prol = add nuw nsw i64 %ti.i8.prol, 1
  %prol.iter.next = add i64 %prol.iter, 1
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter14
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol, !llvm.loop !3

l_tail_body.i.prol.loopexit:                      ; preds = %l_tail_body.i.prol, %l_tail_body.i.preheader
  %tacc.i9.unr = phi i64 [ %acc_next.i.lcssa, %l_tail_body.i.preheader ], [ %tacc_next.i.prol, %l_tail_body.i.prol ]
  %ti.i8.unr = phi i64 [ %idx_next.i.lcssa, %l_tail_body.i.preheader ], [ %ti_next.i.prol, %l_tail_body.i.prol ]
  %tacc_next.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.preheader ], [ %tacc_next.i.prol, %l_tail_body.i.prol ]
  %7 = sub i64 %idx_next.i.lcssa, %len.i
  %8 = icmp ugt i64 %7, -4
  br i1 %8, label %l_done.i, label %l_tail_body.i.preheader.new

l_tail_body.i.preheader.new:                      ; preds = %l_tail_body.i.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr.i, i64 1
  %invariant.gep16 = getelementptr i8, ptr %ptr.i, i64 2
  %invariant.gep18 = getelementptr i8, ptr %ptr.i, i64 3
  br label %l_tail_body.i

l_body.i:                                         ; preds = %l_body.i, %long_hash.i.new
  %acc.i6 = phi i64 [ %seed.i, %long_hash.i.new ], [ %acc_next.i.1, %l_body.i ]
  %idx.i5 = phi i64 [ 0, %long_hash.i.new ], [ %idx_next.i.1, %l_body.i ]
  %niter = phi i64 [ 0, %long_hash.i.new ], [ %niter.next.1, %l_body.i ]
  %lp.i = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %idx.i5
  %lane.i = load i64, ptr %lp.i, align 4
  %lm.i = mul i64 %lane.i, -4417276706812531889
  %lx.i = xor i64 %lm.i, %acc.i6
  %s1.i2.i = lshr i64 %lx.i, 30
  %x1.i3.i = xor i64 %s1.i2.i, %lx.i
  %m1.i4.i = mul i64 %x1.i3.i, -4658895280553007687
  %s2.i5.i = lshr i64 %m1.i4.i, 27
  %x2.i6.i = xor i64 %s2.i5.i, %m1.i4.i
  %m2.i7.i = mul i64 %x2.i6.i, -7723592293110705685
  %s3.i8.i = lshr i64 %m2.i7.i, 31
  %x3.i9.i = xor i64 %s3.i8.i, %m2.i7.i
  %acc_next.i = add i64 %x3.i9.i, %idx.i5
  %idx_next.i = or disjoint i64 %idx.i5, 8
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
  %idx_next.i.1 = add nuw nsw i64 %idx.i5, 16
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1.not = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1.not, label %l_tail_cond.i.preheader.unr-lcssa, label %l_body.i

l_tail_body.i:                                    ; preds = %l_tail_body.i, %l_tail_body.i.preheader.new
  %tacc.i9 = phi i64 [ %tacc.i9.unr, %l_tail_body.i.preheader.new ], [ %tacc_next.i.3, %l_tail_body.i ]
  %ti.i8 = phi i64 [ %ti.i8.unr, %l_tail_body.i.preheader.new ], [ %ti_next.i.3, %l_tail_body.i ]
  %tp.i = getelementptr inbounds nuw i8, ptr %ptr.i, i64 %ti.i8
  %tb.i = load i8, ptr %tp.i, align 1
  %tz.i = zext i8 %tb.i to i64
  %tx.i = xor i64 %tacc.i9, %tz.i
  %tacc_next.i = mul i64 %tx.i, 1099511628211
  %gep = getelementptr i8, ptr %invariant.gep, i64 %ti.i8
  %tb.i.1 = load i8, ptr %gep, align 1
  %tz.i.1 = zext i8 %tb.i.1 to i64
  %tx.i.1 = xor i64 %tacc_next.i, %tz.i.1
  %tacc_next.i.1 = mul i64 %tx.i.1, 1099511628211
  %gep17 = getelementptr i8, ptr %invariant.gep16, i64 %ti.i8
  %tb.i.2 = load i8, ptr %gep17, align 1
  %tz.i.2 = zext i8 %tb.i.2 to i64
  %tx.i.2 = xor i64 %tacc_next.i.1, %tz.i.2
  %tacc_next.i.2 = mul i64 %tx.i.2, 1099511628211
  %gep19 = getelementptr i8, ptr %invariant.gep18, i64 %ti.i8
  %tb.i.3 = load i8, ptr %gep19, align 1
  %tz.i.3 = zext i8 %tb.i.3 to i64
  %tx.i.3 = xor i64 %tacc_next.i.2, %tz.i.3
  %tacc_next.i.3 = mul i64 %tx.i.3, 1099511628211
  %ti_next.i.3 = add nuw nsw i64 %ti.i8, 4
  %tmore.i.3 = icmp samesign ult i64 %ti_next.i.3, %len.i
  br i1 %tmore.i.3, label %l_tail_body.i, label %l_done.i

l_done.i:                                         ; preds = %l_tail_body.i.prol.loopexit, %l_tail_body.i, %l_tail_cond.i.preheader
  %tacc.i.lcssa = phi i64 [ %acc_next.i.lcssa, %l_tail_cond.i.preheader ], [ %tacc_next.i.lcssa.unr, %l_tail_body.i.prol.loopexit ], [ %tacc_next.i.3, %l_tail_body.i ]
  %s1.i.i = lshr i64 %tacc.i.lcssa, 30
  %x1.i.i = xor i64 %s1.i.i, %tacc.i.lcssa
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
  %found_idx.pn = phi i64 [ %d_idx, %archx_dict_set_ctrl.exit ], [ %found_idx, %archx_dict_find_h_i64.exit ]
  ret i64 %found_idx.pn

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
define private fastcc i64 @archx_dict_upsert_str(i64 range(i64 1, 0) %d, %ArchxStr %key) unnamed_addr #0 {
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
  %xtraiter11 = and i64 %6, 3
  %lcmp.mod12.not = icmp eq i64 %xtraiter11, 0
  br i1 %lcmp.mod12.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol

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
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter11
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol, !llvm.loop !4

l_tail_body.i.prol.loopexit:                      ; preds = %l_tail_body.i.prol, %l_tail_body.i.preheader
  %tacc.i19.unr = phi i64 [ %acc_next.i.lcssa, %l_tail_body.i.preheader ], [ %tacc_next.i.prol, %l_tail_body.i.prol ]
  %ti.i18.unr = phi i64 [ %idx_next.i.lcssa, %l_tail_body.i.preheader ], [ %ti_next.i.prol, %l_tail_body.i.prol ]
  %tacc_next.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.preheader ], [ %tacc_next.i.prol, %l_tail_body.i.prol ]
  %7 = sub i64 %idx_next.i.lcssa, %len.i
  %8 = icmp ugt i64 %7, -4
  br i1 %8, label %l_done.i, label %l_tail_body.i.preheader.new

l_tail_body.i.preheader.new:                      ; preds = %l_tail_body.i.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr.i, i64 1
  %invariant.gep17 = getelementptr i8, ptr %ptr.i, i64 2
  %invariant.gep19 = getelementptr i8, ptr %ptr.i, i64 3
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
  %gep18 = getelementptr i8, ptr %invariant.gep17, i64 %ti.i18
  %tb.i.2 = load i8, ptr %gep18, align 1
  %tz.i.2 = zext i8 %tb.i.2 to i64
  %tx.i.2 = xor i64 %tacc_next.i.1, %tz.i.2
  %tacc_next.i.2 = mul i64 %tx.i.2, 1099511628211
  %gep20 = getelementptr i8, ptr %invariant.gep19, i64 %ti.i18
  %tb.i.3 = load i8, ptr %gep20, align 1
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
  ret i64 %found_idx.pn

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
!2 = distinct !{!2, !1}
!3 = distinct !{!3, !1}
!4 = distinct !{!4, !1}
