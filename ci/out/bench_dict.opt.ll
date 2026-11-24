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
  %for.i.5.0203 = phi i64 [ 0, %entry ], [ %t101, %for.step.2 ]
  %var.vocab.4.sroa.13.0201 = phi i64 [ 0, %entry ], [ %var.vocab.4.sroa.13.3, %for.step.2 ]
  %var.vocab.4.sroa.26.0200 = phi ptr [ null, %entry ], [ %var.vocab.4.sroa.26.3, %for.step.2 ]
  %t9 = and i64 %for.i.5.0203, 1
  %t10 = icmp eq i64 %t9, 0
  br i1 %t10, label %if.then.4, label %if.else.5

if.then.4:                                        ; preds = %for.body.1
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %buf.i)
  %n32.i = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 range(i64 -9223372036854775808, 1024) %for.i.5.0203)
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
  %bptr.i276 = phi ptr [ %blptr.i, %build.i.thread ], [ %btmp.i, %build.i ]
  %hp.i = tail call noalias align 16 ptr @malloc(i64 %tot.i)
  %hnull.i = icmp eq ptr %hp.i, null
  br i1 %hnull.i, label %oom.i, label %copy_long.i

copy_long.i:                                      ; preds = %alloc_heap.i
  %hp_i.i = ptrtoint ptr %hp.i to i64
  %htagged.i = or disjoint i64 %hp_i.i, 1
  store i32 1600876404, ptr %hp.i, align 16
  %dst_b.i = getelementptr inbounds nuw i8, ptr %hp.i, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %dst_b.i, ptr nonnull align 1 %bptr.i276, i64 %blen.i, i1 false)
  %w0_out.i = or disjoint i64 %tot.i, 6875711800118083584
  %ls0.i = insertvalue %ArchxStr poison, i64 %w0_out.i, 0
  %ls1.i = insertvalue %ArchxStr %ls0.i, i64 %htagged.i, 1
  br label %archx_str_concat.exit

archx_str_concat.exit:                            ; preds = %archx_str_from_int.exit, %build_sso.i, %copy_long.i
  %common.ret.op.i = phi %ArchxStr [ %rs1.i, %build_sso.i ], [ %ls1.i, %copy_long.i ], [ { i64 6875711800118083588, i64 0 }, %archx_str_from_int.exit ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %out_sso.i.sroa.6)
  %t18 = icmp slt i64 %var.vocab.4.sroa.13.0201, 0
  %t20 = tail call i64 @llvm.abs.i64(i64 %var.vocab.4.sroa.13.0201, i1 true)
  %t21.not = icmp samesign ult i64 %for.i.5.0203, %t20
  br i1 %t21.not, label %push.store.8, label %push.calc.10

push.calc.10:                                     ; preds = %archx_str_concat.exit
  %t23 = icmp eq i64 %var.vocab.4.sroa.13.0201, 0
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
  %t34 = shl nuw nsw i64 %for.i.5.0203, 4
  %t37 = tail call i64 @llvm.umax.i64(i64 %t34, i64 1)
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t38, ptr noundef nonnull align 8 dereferenceable(1) %var.vocab.4.sroa.26.0200, i64 %t37, i1 false)
  br label %push.store.8

push.grow.from_heap.14:                           ; preds = %mul.ok.12
  %t44 = tail call align 16 ptr @realloc(ptr %var.vocab.4.sroa.26.0200, i64 %t32)
  %t45 = icmp eq ptr %t44, null
  br i1 %t45, label %realloc.oom.22, label %push.store.8

realloc.oom.22:                                   ; preds = %push.grow.from_heap.14
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.8:                                     ; preds = %push.grow.from_heap.14, %push.reg.copy.19, %archx_str_concat.exit
  %var.vocab.4.sroa.26.1 = phi ptr [ %var.vocab.4.sroa.26.0200, %archx_str_concat.exit ], [ %t38, %push.reg.copy.19 ], [ %t44, %push.grow.from_heap.14 ]
  %var.vocab.4.sroa.13.1 = phi i64 [ %var.vocab.4.sroa.13.0201, %archx_str_concat.exit ], [ %t27, %push.reg.copy.19 ], [ %t27, %push.grow.from_heap.14 ]
  %t51 = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.1, i64 %for.i.5.0203
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
  %n32.i83 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull dereferenceable(1) %buf.i82, ptr nonnull dereferenceable(1) @.fmt.i64s, i64 range(i64 -9223372036854775808, 1024) %for.i.5.0203)
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
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(17) %hp.i49, ptr noundef nonnull align 4 dereferenceable(17) @.str.1, i64 17, i1 false)
  %dst_b.i54 = getelementptr inbounds nuw i8, ptr %hp.i49, i64 17
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b.i54, ptr nonnull align 1 %bptr.i46, i64 %blen.i35, i1 false)
  %w0_out.i58 = or disjoint i64 %tot.i38, 7954874718954192896
  %ls0.i59 = insertvalue %ArchxStr poison, i64 %w0_out.i58, 0
  %ls1.i60 = insertvalue %ArchxStr %ls0.i59, i64 %htagged.i53, 1
  br label %archx_str_concat.exit78

archx_str_concat.exit78:                          ; preds = %archx_str_from_int.exit109, %copy_long.i51
  %common.ret.op.i61 = phi %ArchxStr [ %ls1.i60, %copy_long.i51 ], [ { i64 7954874718954192913, i64 ptrtoint (ptr @.str.1 to i64) }, %archx_str_from_int.exit109 ]
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %btmp.i31)
  %t64 = icmp slt i64 %var.vocab.4.sroa.13.0201, 0
  %t66 = tail call i64 @llvm.abs.i64(i64 %var.vocab.4.sroa.13.0201, i1 true)
  %t67.not = icmp samesign ult i64 %for.i.5.0203, %t66
  br i1 %t67.not, label %push.store.24, label %push.calc.26

push.calc.26:                                     ; preds = %archx_str_concat.exit78
  %t69 = icmp eq i64 %var.vocab.4.sroa.13.0201, 0
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
  %t80 = shl nuw nsw i64 %for.i.5.0203, 4
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 16 dereferenceable(1) %t84, ptr noundef nonnull align 8 dereferenceable(1) %var.vocab.4.sroa.26.0200, i64 %t80, i1 false)
  br label %push.store.24

push.grow.from_heap.30:                           ; preds = %mul.ok.28
  %t90 = tail call align 16 ptr @realloc(ptr %var.vocab.4.sroa.26.0200, i64 %t78)
  %t91 = icmp eq ptr %t90, null
  br i1 %t91, label %realloc.oom.38, label %push.store.24

realloc.oom.38:                                   ; preds = %push.grow.from_heap.30
  tail call fastcc void @archx_oom_fail()
  unreachable

push.store.24:                                    ; preds = %push.grow.from_heap.30, %push.reg.copy.35, %archx_str_concat.exit78
  %var.vocab.4.sroa.26.2 = phi ptr [ %var.vocab.4.sroa.26.0200, %archx_str_concat.exit78 ], [ %t84, %push.reg.copy.35 ], [ %t90, %push.grow.from_heap.30 ]
  %var.vocab.4.sroa.13.2 = phi i64 [ %var.vocab.4.sroa.13.0201, %archx_str_concat.exit78 ], [ %t73, %push.reg.copy.35 ], [ %t73, %push.grow.from_heap.30 ]
  %t97 = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.2, i64 %for.i.5.0203
  %t59.elt = extractvalue %ArchxStr %common.ret.op.i61, 0
  store i64 %t59.elt, ptr %t97, align 8
  %t97.repack15 = getelementptr inbounds nuw i8, ptr %t97, i64 8
  %t59.elt16 = extractvalue %ArchxStr %common.ret.op.i61, 1
  store i64 %t59.elt16, ptr %t97.repack15, align 8
  %long.i21 = icmp samesign ult i64 %blen.i35, 13
  %tag.i24 = and i64 %bw1.i34, 1
  %owned.not.i25 = icmp eq i64 %tag.i24, 0
  %or.cond145 = select i1 %long.i21, i1 true, i1 %owned.not.i25
  br i1 %or.cond145, label %for.step.2, label %for.step.2.sink.split

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
  %t101 = add nuw nsw i64 %for.i.5.0203, 1
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
  %var.str_checksum.0.0600.i = phi i64 [ 0, %for.end.3 ], [ %var.str_checksum.0.3.lcssa635.i, %for.body.1.i.backedge ]
  %for.r.4.0599.i = phi i64 [ 0, %for.end.3 ], [ %for.r.4.0599.i.be, %for.body.1.i.backedge ]
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
  %t22.i = and i64 %rpi.pre-phi.i.i, -4
  %t23.i = inttoptr i64 %t22.i to ptr
  %t24.i = getelementptr inbounds nuw i8, ptr %t23.i, i64 48
  br label %for.fast.body.5.i

for.fast.body.5.i:                                ; preds = %for.fast.body.5.i.preheader, %for.fast.body.5.i
  %for.i.9.0560.i = phi i64 [ %t28.i, %for.fast.body.5.i ], [ 0, %for.fast.body.5.i.preheader ]
  %t17.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %for.i.9.0560.i
  %t18.unpack.i = load i64, ptr %t17.i, align 8
  %4 = insertvalue %ArchxStr poison, i64 %t18.unpack.i, 0
  %t18.elt38.i = getelementptr inbounds nuw i8, ptr %t17.i, i64 8
  %t18.unpack39.i = load i64, ptr %t18.elt38.i, align 8
  %t1840.i = insertvalue %ArchxStr %4, i64 %t18.unpack39.i, 1
  %t19.i = call fastcc i64 @archx_dict_upsert_str(i64 %rtag.i.i, %ArchxStr %t1840.i)
  %t25.i = load ptr, ptr %t24.i, align 8
  %t26.i = getelementptr inbounds i64, ptr %t25.i, i64 %t19.i
  store i64 1, ptr %t26.i, align 8
  %t28.i = add nuw nsw i64 %for.i.9.0560.i, 1
  %exitcond615.not.i = icmp eq i64 %t28.i, 1024
  br i1 %exitcond615.not.i, label %for.end.10.i, label %for.fast.body.5.i

for.end.10.i:                                     ; preds = %for.fast.body.5.i
  %t54.i = mul nuw nsw i64 %for.r.4.0599.i, 19
  %is_z.i.i.i.i = icmp eq i64 %t22.i, 0
  %ctrl_p.i.i.i.i = getelementptr inbounds nuw i8, ptr %t23.i, i64 32
  %mask_p.i.i.i.i = getelementptr inbounds nuw i8, ptr %t23.i, i64 16
  %keys_p.i.i.i.i = getelementptr inbounds nuw i8, ptr %t23.i, i64 40
  br label %idx.ok.17.i

for.cond.21.preheader.i:                          ; preds = %archx_str_drop.exit.i
  %t87.i = mul nuw nsw i64 %for.r.4.0599.i, 7
  br label %idx.ok.25.i

idx.ok.17.i:                                      ; preds = %for.end.10.i, %archx_str_drop.exit.i
  %for.step.48.0568.i = phi i64 [ 0, %for.end.10.i ], [ %t80.i, %archx_str_drop.exit.i ]
  %t52.i = mul nuw nsw i64 %for.step.48.0568.i, 73
  %t55.i = add nuw nsw i64 %t52.i, %t54.i
  %t56.i = and i64 %t55.i, 1023
  %t60.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %t56.i
  %t61.unpack.i = load i64, ptr %t60.i, align 8
  %5 = insertvalue %ArchxStr poison, i64 %t61.unpack.i, 0
  %t61.elt35.i = getelementptr inbounds nuw i8, ptr %t60.i, i64 8
  %t61.unpack36.i = load i64, ptr %t61.elt35.i, align 8
  %t6137.i = insertvalue %ArchxStr %5, i64 %t61.unpack36.i, 1
  %len.i492.i = and i64 %t61.unpack.i, 4294967295
  %long.i493.i = icmp samesign ult i64 %len.i492.i, 13
  %tag.i496.i = and i64 %t61.unpack36.i, 3
  %owned.not.i497.i = icmp eq i64 %tag.i496.i, 0
  %or.cond.i = select i1 %long.i493.i, i1 true, i1 %owned.not.i497.i
  br i1 %or.cond.i, label %archx_str_clone.exit.i, label %dup_heap.i.i

dup_heap.i.i:                                     ; preds = %idx.ok.17.i
  %dst.i.i = call noalias align 16 ptr @malloc(i64 %len.i492.i)
  %isnull.i.i = icmp eq ptr %dst.i.i, null
  br i1 %isnull.i.i, label %oom.i.i113, label %copy.i.i

oom.i.i113:                                       ; preds = %dup_heap.i.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i.i:                                         ; preds = %dup_heap.i.i
  %src_i.i.i = and i64 %t61.unpack36.i, -4
  %src.i.i = inttoptr i64 %src_i.i.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i, ptr nonnull align 4 %src.i.i, i64 %len.i492.i, i1 false)
  %dst_i.i.i = ptrtoint ptr %dst.i.i to i64
  %tagged.i.i = or disjoint i64 %dst_i.i.i, 1
  %out.i.i = insertvalue %ArchxStr %t6137.i, i64 %tagged.i.i, 1
  br label %archx_str_clone.exit.i

archx_str_clone.exit.i:                           ; preds = %copy.i.i, %idx.ok.17.i
  %common.ret.op.i.i112 = phi %ArchxStr [ %out.i.i, %copy.i.i ], [ %t6137.i, %idx.ok.17.i ]
  %w0.i.i.i.i = extractvalue %ArchxStr %common.ret.op.i.i112, 0
  %w1.i.i.i.i = extractvalue %ArchxStr %common.ret.op.i.i112, 1
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
  %acc.i.i.i562.i.unr = phi i64 [ %seed.i.i.i.i, %long_hash.i.i.i.i ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx.i.i.i561.i.unr = phi i64 [ 0, %long_hash.i.i.i.i ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %11 = and i64 %7, 8
  %lcmp.mod.not.not = icmp eq i64 %11, 0
  br i1 %lcmp.mod.not.not, label %l_body.i.i.i.i.epil, label %l_tail_cond.i.i.i.preheader.i

l_body.i.i.i.i.epil:                              ; preds = %l_tail_cond.i.i.i.preheader.i.unr-lcssa
  %lp.i.i.i.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %idx.i.i.i561.i.unr
  %lane.i.i.i.i.epil = load i64, ptr %lp.i.i.i.i.epil, align 4
  %lm.i.i.i.i.epil = mul i64 %lane.i.i.i.i.epil, -4417276706812531889
  %lx.i.i.i.i.epil = xor i64 %lm.i.i.i.i.epil, %acc.i.i.i562.i.unr
  %s1.i2.i.i.i.i.epil = lshr i64 %lx.i.i.i.i.epil, 30
  %x1.i3.i.i.i.i.epil = xor i64 %s1.i2.i.i.i.i.epil, %lx.i.i.i.i.epil
  %m1.i4.i.i.i.i.epil = mul i64 %x1.i3.i.i.i.i.epil, -4658895280553007687
  %s2.i5.i.i.i.i.epil = lshr i64 %m1.i4.i.i.i.i.epil, 27
  %x2.i6.i.i.i.i.epil = xor i64 %s2.i5.i.i.i.i.epil, %m1.i4.i.i.i.i.epil
  %m2.i7.i.i.i.i.epil = mul i64 %x2.i6.i.i.i.i.epil, -7723592293110705685
  %s3.i8.i.i.i.i.epil = lshr i64 %m2.i7.i.i.i.i.epil, 31
  %x3.i9.i.i.i.i.epil = xor i64 %s3.i8.i.i.i.i.epil, %m2.i7.i.i.i.i.epil
  %acc_next.i.i.i.i.epil = add i64 %x3.i9.i.i.i.i.epil, %idx.i.i.i561.i.unr
  %idx_next.i.i.i.i.epil = add nuw nsw i64 %idx.i.i.i561.i.unr, 8
  br label %l_tail_cond.i.i.i.preheader.i

l_tail_cond.i.i.i.preheader.i:                    ; preds = %l_tail_cond.i.i.i.preheader.i.unr-lcssa, %l_body.i.i.i.i.epil
  %acc_next.i.i.i.i.lcssa = phi i64 [ %acc_next.i.i.i.i.lcssa.ph, %l_tail_cond.i.i.i.preheader.i.unr-lcssa ], [ %acc_next.i.i.i.i.epil, %l_body.i.i.i.i.epil ]
  %idx_next.i.i.i.i.lcssa = phi i64 [ %idx_next.i.i.i.i.lcssa.ph, %l_tail_cond.i.i.i.preheader.i.unr-lcssa ], [ %idx_next.i.i.i.i.epil, %l_body.i.i.i.i.epil ]
  %tmore.i.i.i563.i = icmp samesign ult i64 %idx_next.i.i.i.i.lcssa, %len.i.i.i.i
  br i1 %tmore.i.i.i563.i, label %l_tail_body.i.i.i.i.preheader, label %l_done.i.i.i.i

l_tail_body.i.i.i.i.preheader:                    ; preds = %l_tail_cond.i.i.i.preheader.i
  %12 = sub i64 %w0.i.i.i.i, %idx_next.i.i.i.i.lcssa
  %xtraiter318 = and i64 %12, 3
  %lcmp.mod319.not = icmp eq i64 %xtraiter318, 0
  br i1 %lcmp.mod319.not, label %l_tail_body.i.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.i.prol

l_tail_body.i.i.i.i.prol:                         ; preds = %l_tail_body.i.i.i.i.preheader, %l_tail_body.i.i.i.i.prol
  %tacc.i.i.i565.i.prol = phi i64 [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ], [ %acc_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ]
  %ti.i.i.i564.i.prol = phi i64 [ %ti_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ], [ %idx_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %l_tail_body.i.i.i.i.prol ], [ 0, %l_tail_body.i.i.i.i.preheader ]
  %tp.i.i.i.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %ti.i.i.i564.i.prol
  %tb.i.i.i.i.prol = load i8, ptr %tp.i.i.i.i.prol, align 1
  %tz.i.i.i.i.prol = zext i8 %tb.i.i.i.i.prol to i64
  %tx.i.i.i.i.prol = xor i64 %tacc.i.i.i565.i.prol, %tz.i.i.i.i.prol
  %tacc_next.i.i.i.i.prol = mul i64 %tx.i.i.i.i.prol, 1099511628211
  %ti_next.i.i.i.i.prol = add nuw nsw i64 %ti.i.i.i564.i.prol, 1
  %prol.iter.next = add i64 %prol.iter, 1
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter318
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.i.i.i.prol.loopexit, label %l_tail_body.i.i.i.i.prol, !llvm.loop !0

l_tail_body.i.i.i.i.prol.loopexit:                ; preds = %l_tail_body.i.i.i.i.prol, %l_tail_body.i.i.i.i.preheader
  %tacc.i.i.i565.i.unr = phi i64 [ %acc_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ], [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %ti.i.i.i564.i.unr = phi i64 [ %idx_next.i.i.i.i.lcssa, %l_tail_body.i.i.i.i.preheader ], [ %ti_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %tacc_next.i.i.i.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.i.i.preheader ], [ %tacc_next.i.i.i.i.prol, %l_tail_body.i.i.i.i.prol ]
  %13 = sub i64 %idx_next.i.i.i.i.lcssa, %len.i.i.i.i
  %14 = icmp ugt i64 %13, -4
  br i1 %14, label %l_done.i.i.i.i, label %l_tail_body.i.i.i.i.preheader.new

l_tail_body.i.i.i.i.preheader.new:                ; preds = %l_tail_body.i.i.i.i.prol.loopexit
  %invariant.gep = getelementptr i8, ptr %ptr.i.i.i.i, i64 1
  %invariant.gep345 = getelementptr i8, ptr %ptr.i.i.i.i, i64 2
  %invariant.gep347 = getelementptr i8, ptr %ptr.i.i.i.i, i64 3
  br label %l_tail_body.i.i.i.i

l_body.i.i.i.i:                                   ; preds = %l_body.i.i.i.i, %long_hash.i.i.i.i.new
  %acc.i.i.i562.i = phi i64 [ %seed.i.i.i.i, %long_hash.i.i.i.i.new ], [ %acc_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %idx.i.i.i561.i = phi i64 [ 0, %long_hash.i.i.i.i.new ], [ %idx_next.i.i.i.i.1, %l_body.i.i.i.i ]
  %niter = phi i64 [ 0, %long_hash.i.i.i.i.new ], [ %niter.next.1, %l_body.i.i.i.i ]
  %lp.i.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %idx.i.i.i561.i
  %lane.i.i.i.i = load i64, ptr %lp.i.i.i.i, align 4
  %lm.i.i.i.i = mul i64 %lane.i.i.i.i, -4417276706812531889
  %lx.i.i.i.i = xor i64 %lm.i.i.i.i, %acc.i.i.i562.i
  %s1.i2.i.i.i.i = lshr i64 %lx.i.i.i.i, 30
  %x1.i3.i.i.i.i = xor i64 %s1.i2.i.i.i.i, %lx.i.i.i.i
  %m1.i4.i.i.i.i = mul i64 %x1.i3.i.i.i.i, -4658895280553007687
  %s2.i5.i.i.i.i = lshr i64 %m1.i4.i.i.i.i, 27
  %x2.i6.i.i.i.i = xor i64 %s2.i5.i.i.i.i, %m1.i4.i.i.i.i
  %m2.i7.i.i.i.i = mul i64 %x2.i6.i.i.i.i, -7723592293110705685
  %s3.i8.i.i.i.i = lshr i64 %m2.i7.i.i.i.i, 31
  %x3.i9.i.i.i.i = xor i64 %s3.i8.i.i.i.i, %m2.i7.i.i.i.i
  %acc_next.i.i.i.i = add i64 %x3.i9.i.i.i.i, %idx.i.i.i561.i
  %idx_next.i.i.i.i = or disjoint i64 %idx.i.i.i561.i, 8
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
  %idx_next.i.i.i.i.1 = add nuw nsw i64 %idx.i.i.i561.i, 16
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1.not = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1.not, label %l_tail_cond.i.i.i.preheader.i.unr-lcssa, label %l_body.i.i.i.i

l_tail_body.i.i.i.i:                              ; preds = %l_tail_body.i.i.i.i, %l_tail_body.i.i.i.i.preheader.new
  %tacc.i.i.i565.i = phi i64 [ %tacc.i.i.i565.i.unr, %l_tail_body.i.i.i.i.preheader.new ], [ %tacc_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %ti.i.i.i564.i = phi i64 [ %ti.i.i.i564.i.unr, %l_tail_body.i.i.i.i.preheader.new ], [ %ti_next.i.i.i.i.3, %l_tail_body.i.i.i.i ]
  %tp.i.i.i.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i.i, i64 %ti.i.i.i564.i
  %tb.i.i.i.i = load i8, ptr %tp.i.i.i.i, align 1
  %tz.i.i.i.i = zext i8 %tb.i.i.i.i to i64
  %tx.i.i.i.i = xor i64 %tacc.i.i.i565.i, %tz.i.i.i.i
  %tacc_next.i.i.i.i = mul i64 %tx.i.i.i.i, 1099511628211
  %gep = getelementptr i8, ptr %invariant.gep, i64 %ti.i.i.i564.i
  %tb.i.i.i.i.1 = load i8, ptr %gep, align 1
  %tz.i.i.i.i.1 = zext i8 %tb.i.i.i.i.1 to i64
  %tx.i.i.i.i.1 = xor i64 %tacc_next.i.i.i.i, %tz.i.i.i.i.1
  %tacc_next.i.i.i.i.1 = mul i64 %tx.i.i.i.i.1, 1099511628211
  %gep346 = getelementptr i8, ptr %invariant.gep345, i64 %ti.i.i.i564.i
  %tb.i.i.i.i.2 = load i8, ptr %gep346, align 1
  %tz.i.i.i.i.2 = zext i8 %tb.i.i.i.i.2 to i64
  %tx.i.i.i.i.2 = xor i64 %tacc_next.i.i.i.i.1, %tz.i.i.i.i.2
  %tacc_next.i.i.i.i.2 = mul i64 %tx.i.i.i.i.2, 1099511628211
  %gep348 = getelementptr i8, ptr %invariant.gep347, i64 %ti.i.i.i564.i
  %tb.i.i.i.i.3 = load i8, ptr %gep348, align 1
  %tz.i.i.i.i.3 = zext i8 %tb.i.i.i.i.3 to i64
  %tx.i.i.i.i.3 = xor i64 %tacc_next.i.i.i.i.2, %tz.i.i.i.i.3
  %tacc_next.i.i.i.i.3 = mul i64 %tx.i.i.i.i.3, 1099511628211
  %ti_next.i.i.i.i.3 = add nuw nsw i64 %ti.i.i.i564.i, 4
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
  br i1 %is_z.i.i.i.i, label %dupd.miss.20.i, label %chk_ctrl.i.i.i.i

chk_ctrl.i.i.i.i:                                 ; preds = %archx_hash_str.exit.i.i.i
  %ctrl.i.i.i.i = load ptr, ptr %ctrl_p.i.i.i.i, align 8
  %c_null.i.i.i.i = icmp eq ptr %ctrl.i.i.i.i, null
  br i1 %c_null.i.i.i.i, label %dupd.miss.20.i, label %do_probe.i.i.i.i

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
  %has_m.not.i.i.i566.i = icmp eq i16 %mbits.i.i.i.i, 0
  br i1 %has_m.not.i.i.i566.i, label %chk_empty.i.i.i.i, label %chk_key.i.i.i.preheader.i

chk_key.i.i.i.preheader.i:                        ; preds = %probe.i.i.i.i
  %mmask0.i.i.i.i = zext i16 %mbits.i.i.i.i to i32
  br label %chk_key.i.i.i.i

chk_key.i.i.i.i:                                  ; preds = %mbit_cont.i.i.i.i, %chk_key.i.i.i.preheader.i
  %mmask.i.i.i567.i = phi i32 [ %mmask_next.i.i.i.i, %mbit_cont.i.i.i.i ], [ %mmask0.i.i.i.i, %chk_key.i.i.i.preheader.i ]
  %tz.i2.i.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i567.i, i1 true)
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
  br i1 %eq_s.i.i.i.i.i, label %dupd.ok.19.i, label %mbit_cont.i.i.i.i

cmp_long.i.i.i.i.i:                               ; preds = %chk_len.i.i.i.i.i
  %ap_i.i.i.i.i.i = and i64 %cand_k.unpack2.i.i.i.i, -4
  %same_ptr.i.i.i.i.i = icmp eq i64 %ap_i.i.i.i.i.i, %bp_i.i.i.i.i.i
  br i1 %same_ptr.i.i.i.i.i, label %dupd.ok.19.i, label %archx_str_eq.exit.i.i.i.i

archx_str_eq.exit.i.i.i.i:                        ; preds = %cmp_long.i.i.i.i.i
  %ap.i.i.i.i.i = inttoptr i64 %ap_i.i.i.i.i.i to ptr
  %ap4.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i.i, i64 4
  %bcmp.i.i.i.i.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i.i.i, ptr nonnull %bp4.i.i.i.i.i, i64 %rem.i.i.i.i.i)
  %eq_m.i.i.i.i.i = icmp eq i32 %bcmp.i.i.i.i.i, 0
  br i1 %eq_m.i.i.i.i.i, label %dupd.ok.19.i, label %mbit_cont.i.i.i.i

mbit_cont.i.i.i.i:                                ; preds = %archx_str_eq.exit.i.i.i.i, %cmp_short.i.i.i.i.i, %chk_key.i.i.i.i
  %mm1.i.i.i.i = add nsw i32 %mmask.i.i.i567.i, -1
  %mmask_next.i.i.i.i = and i32 %mm1.i.i.i.i, %mmask.i.i.i567.i
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
  br i1 %has_e.not.i.i.i.i, label %next_grp.i.i.i.i, label %dupd.miss.20.i

next_grp.i.i.i.i:                                 ; preds = %after_a.i.i.i.i
  %step_next.i.i.i.i = add i64 %step.i.i.i.i, 16
  %padd.i.i.i.i = add i64 %step_next.i.i.i.i, %pos.i.i.i.i
  br label %probe.i.i.i.i

dupd.miss.20.i:                                   ; preds = %chk_ctrl.i.i.i.i, %archx_hash_str.exit.i.i.i, %after_a.i.i.i.i
  call fastcc void @archx_key_fail()
  unreachable

dupd.ok.19.i:                                     ; preds = %archx_str_eq.exit.i.i.i.i, %cmp_long.i.i.i.i.i, %cmp_short.i.i.i.i.i
  %t71.i = load ptr, ptr %t24.i, align 8
  %t72.i = getelementptr inbounds nuw i64, ptr %t71.i, i64 %didx.i.i.i.i
  %t73.i = load i64, ptr %t72.i, align 8
  %t75.i = urem i64 %for.step.48.0568.i, 7
  %t76.i = add nuw nsw i64 %t75.i, 1
  %t77.i = add i64 %t76.i, %t73.i
  store i64 %t77.i, ptr %t72.i, align 8
  %tag.i.i = and i64 %w1.i.i.i.i, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond534.i = select i1 %short.i.i.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond534.i, label %archx_str_drop.exit.i, label %do_free.i.i

do_free.i.i:                                      ; preds = %dupd.ok.19.i
  %raw.i.i = and i64 %w1.i.i.i.i, -2
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  call void @free(ptr %ptr.i.i)
  br label %archx_str_drop.exit.i

archx_str_drop.exit.i:                            ; preds = %do_free.i.i, %dupd.ok.19.i
  %t80.i = add nuw nsw i64 %for.step.48.0568.i, 1
  %exitcond616.not.i = icmp eq i64 %t80.i, 8192
  br i1 %exitcond616.not.i, label %for.cond.21.preheader.i, label %idx.ok.17.i

idx.ok.25.i:                                      ; preds = %for.cond.21.preheader.i, %archx_str_drop.exit51.i
  %var.str_checksum.0.1578.i = phi i64 [ %var.str_checksum.0.0600.i, %for.cond.21.preheader.i ], [ %t109.i, %archx_str_drop.exit51.i ]
  %for.p.81.0577.i = phi i64 [ 0, %for.cond.21.preheader.i ], [ %t112.i, %archx_str_drop.exit51.i ]
  %t85.i = mul nuw nsw i64 %for.p.81.0577.i, 131
  %t88.i = add nuw nsw i64 %t85.i, %t87.i
  %t89.i = and i64 %t88.i, 1023
  %t93.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %t89.i
  %t94.unpack.i = load i64, ptr %t93.i, align 8
  %17 = insertvalue %ArchxStr poison, i64 %t94.unpack.i, 0
  %t94.elt32.i = getelementptr inbounds nuw i8, ptr %t93.i, i64 8
  %t94.unpack33.i = load i64, ptr %t94.elt32.i, align 8
  %t9434.i = insertvalue %ArchxStr %17, i64 %t94.unpack33.i, 1
  %len.i499.i = and i64 %t94.unpack.i, 4294967295
  %long.i500.i = icmp samesign ult i64 %len.i499.i, 13
  %tag.i504.i = and i64 %t94.unpack33.i, 3
  %owned.not.i505.i = icmp eq i64 %tag.i504.i, 0
  %or.cond535.i = select i1 %long.i500.i, i1 true, i1 %owned.not.i505.i
  br i1 %or.cond535.i, label %archx_str_clone.exit516.i, label %dup_heap.i506.i

dup_heap.i506.i:                                  ; preds = %idx.ok.25.i
  %dst.i507.i = call noalias align 16 ptr @malloc(i64 %len.i499.i)
  %isnull.i508.i = icmp eq ptr %dst.i507.i, null
  br i1 %isnull.i508.i, label %oom.i515.i, label %copy.i509.i

oom.i515.i:                                       ; preds = %dup_heap.i506.i
  call fastcc void @archx_oom_fail()
  unreachable

copy.i509.i:                                      ; preds = %dup_heap.i506.i
  %src_i.i510.i = and i64 %t94.unpack33.i, -4
  %src.i511.i = inttoptr i64 %src_i.i510.i to ptr
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i507.i, ptr nonnull align 4 %src.i511.i, i64 %len.i499.i, i1 false)
  %dst_i.i512.i = ptrtoint ptr %dst.i507.i to i64
  %tagged.i513.i = or disjoint i64 %dst_i.i512.i, 1
  %out.i514.i = insertvalue %ArchxStr %t9434.i, i64 %tagged.i513.i, 1
  br label %archx_str_clone.exit516.i

archx_str_clone.exit516.i:                        ; preds = %copy.i509.i, %idx.ok.25.i
  %common.ret.op.i501.i = phi %ArchxStr [ %out.i514.i, %copy.i509.i ], [ %t9434.i, %idx.ok.25.i ]
  %w0.i.i.i52.i = extractvalue %ArchxStr %common.ret.op.i501.i, 0
  %w1.i.i.i53.i = extractvalue %ArchxStr %common.ret.op.i501.i, 1
  %len.i.i.i54.i = and i64 %w0.i.i.i52.i, 4294967295
  %short.i.i.i55.i = icmp samesign ult i64 %len.i.i.i54.i, 13
  br i1 %short.i.i.i55.i, label %sso_hash.i.i.i195.i, label %long_hash.i.i.i56.i

sso_hash.i.i.i195.i:                              ; preds = %archx_str_clone.exit516.i
  %p0_raw.i.i.i196.i = lshr i64 %w0.i.i.i52.i, 32
  %le4.i.i.i197.i = icmp samesign ult i64 %len.i.i.i54.i, 5
  br i1 %le4.i.i.i197.i, label %sso_le4.i.i.i221.i, label %sso_gt4.i.i.i198.i

sso_le4.i.i.i221.i:                               ; preds = %sso_hash.i.i.i195.i
  %sh0.i.i.i222.i = shl nuw nsw i64 %len.i.i.i54.i, 3
  %notmask1.i.i.i223.i = shl nsw i64 -1, %sh0.i.i.i222.i
  %m0.i.i.i224.i = xor i64 %notmask1.i.i.i223.i, -1
  %p0_4.i.i.i225.i = and i64 %p0_raw.i.i.i196.i, %m0.i.i.i224.i
  br label %sso_mix.i.i.i206.i

sso_gt4.i.i.i198.i:                               ; preds = %sso_hash.i.i.i195.i
  %eq12.i.i.i199.i = icmp eq i64 %len.i.i.i54.i, 12
  br i1 %eq12.i.i.i199.i, label %sso_mix.i.i.i206.i, label %sso_mid.i.i.i200.i

sso_mid.i.i.i200.i:                               ; preds = %sso_gt4.i.i.i198.i
  %rem.i.i.i201.i = shl nuw nsw i64 %len.i.i.i54.i, 3
  %sh1.i.i.i202.i = add nsw i64 %rem.i.i.i201.i, -32
  %notmask.i.i.i203.i = shl nsw i64 -1, %sh1.i.i.i202.i
  %m1.i.i.i204.i = xor i64 %notmask.i.i.i203.i, -1
  %p1_m.i.i.i205.i = and i64 %w1.i.i.i53.i, %m1.i.i.i204.i
  br label %sso_mix.i.i.i206.i

sso_mix.i.i.i206.i:                               ; preds = %sso_mid.i.i.i200.i, %sso_gt4.i.i.i198.i, %sso_le4.i.i.i221.i
  %p0.i.i.i207.i = phi i64 [ %p0_4.i.i.i225.i, %sso_le4.i.i.i221.i ], [ %p0_raw.i.i.i196.i, %sso_mid.i.i.i200.i ], [ %p0_raw.i.i.i196.i, %sso_gt4.i.i.i198.i ]
  %p1.i.i.i208.i = phi i64 [ 0, %sso_le4.i.i.i221.i ], [ %p1_m.i.i.i205.i, %sso_mid.i.i.i200.i ], [ %w1.i.i.i53.i, %sso_gt4.i.i.i198.i ]
  %a0.i.i.i209.i = mul i64 %p0.i.i.i207.i, -7046029254386353131
  %a1.i.i.i210.i = mul i64 %p1.i.i.i208.i, -4417276706812531889
  %ax.i.i.i211.i = xor i64 %a1.i.i.i210.i, %a0.i.i.i209.i
  %s1.i10.i.i.i213.i = lshr i64 %ax.i.i.i211.i, 30
  %18 = xor i64 %len.i.i.i54.i, %s1.i10.i.i.i213.i
  %x1.i11.i.i.i214.i = xor i64 %18, %ax.i.i.i211.i
  br label %archx_hash_str.exit.i.i78.i

long_hash.i.i.i56.i:                              ; preds = %archx_str_clone.exit516.i
  %raw.i.i.i57.i = and i64 %w1.i.i.i53.i, -4
  %ptr.i.i.i58.i = inttoptr i64 %raw.i.i.i57.i to ptr
  %seed.i.i.i59.i = mul i64 %len.i.i.i54.i, -7046029254386353131
  %19 = add nsw i64 %len.i.i.i54.i, -8
  %20 = icmp ult i64 %19, 8
  br i1 %20, label %l_tail_cond.i.i.i65.preheader.i.unr-lcssa, label %long_hash.i.i.i56.i.new

long_hash.i.i.i56.i.new:                          ; preds = %long_hash.i.i.i56.i
  %21 = lshr i64 %19, 3
  %22 = add nuw nsw i64 %21, 1
  %unroll_iter324 = and i64 %22, 4611686018427387902
  br label %l_body.i.i.i180.i

l_tail_cond.i.i.i65.preheader.i.unr-lcssa:        ; preds = %l_body.i.i.i180.i, %long_hash.i.i.i56.i
  %acc_next.i.i.i193.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i56.i ], [ %acc_next.i.i.i193.i.1, %l_body.i.i.i180.i ]
  %idx_next.i.i.i194.i.lcssa.ph = phi i64 [ poison, %long_hash.i.i.i56.i ], [ %idx_next.i.i.i194.i.1, %l_body.i.i.i180.i ]
  %acc.i.i.i62570.i.unr = phi i64 [ %seed.i.i.i59.i, %long_hash.i.i.i56.i ], [ %acc_next.i.i.i193.i.1, %l_body.i.i.i180.i ]
  %idx.i.i.i61569.i.unr = phi i64 [ 0, %long_hash.i.i.i56.i ], [ %idx_next.i.i.i194.i.1, %l_body.i.i.i180.i ]
  %23 = and i64 %19, 8
  %lcmp.mod321.not.not = icmp eq i64 %23, 0
  br i1 %lcmp.mod321.not.not, label %l_body.i.i.i180.i.epil, label %l_tail_cond.i.i.i65.preheader.i

l_body.i.i.i180.i.epil:                           ; preds = %l_tail_cond.i.i.i65.preheader.i.unr-lcssa
  %lp.i.i.i181.i.epil = getelementptr inbounds nuw i8, ptr %ptr.i.i.i58.i, i64 %idx.i.i.i61569.i.unr
  %lane.i.i.i182.i.epil = load i64, ptr %lp.i.i.i181.i.epil, align 4
  %lm.i.i.i183.i.epil = mul i64 %lane.i.i.i182.i.epil, -4417276706812531889
  %lx.i.i.i184.i.epil = xor i64 %lm.i.i.i183.i.epil, %acc.i.i.i62570.i.unr
  %s1.i2.i.i.i185.i.epil = lshr i64 %lx.i.i.i184.i.epil, 30
  %x1.i3.i.i.i186.i.epil = xor i64 %s1.i2.i.i.i185.i.epil, %lx.i.i.i184.i.epil
  %m1.i4.i.i.i187.i.epil = mul i64 %x1.i3.i.i.i186.i.epil, -4658895280553007687
  %s2.i5.i.i.i188.i.epil = lshr i64 %m1.i4.i.i.i187.i.epil, 27
  %x2.i6.i.i.i189.i.epil = xor i64 %s2.i5.i.i.i188.i.epil, %m1.i4.i.i.i187.i.epil
  %m2.i7.i.i.i190.i.epil = mul i64 %x2.i6.i.i.i189.i.epil, -7723592293110705685
  %s3.i8.i.i.i191.i.epil = lshr i64 %m2.i7.i.i.i190.i.epil, 31
  %x3.i9.i.i.i192.i.epil = xor i64 %s3.i8.i.i.i191.i.epil, %m2.i7.i.i.i190.i.epil
  %acc_next.i.i.i193.i.epil = add i64 %x3.i9.i.i.i192.i.epil, %idx.i.i.i61569.i.unr
  %idx_next.i.i.i194.i.epil = add nuw nsw i64 %idx.i.i.i61569.i.unr, 8
  br label %l_tail_cond.i.i.i65.preheader.i

l_tail_cond.i.i.i65.preheader.i:                  ; preds = %l_tail_cond.i.i.i65.preheader.i.unr-lcssa, %l_body.i.i.i180.i.epil
  %acc_next.i.i.i193.i.lcssa = phi i64 [ %acc_next.i.i.i193.i.lcssa.ph, %l_tail_cond.i.i.i65.preheader.i.unr-lcssa ], [ %acc_next.i.i.i193.i.epil, %l_body.i.i.i180.i.epil ]
  %idx_next.i.i.i194.i.lcssa = phi i64 [ %idx_next.i.i.i194.i.lcssa.ph, %l_tail_cond.i.i.i65.preheader.i.unr-lcssa ], [ %idx_next.i.i.i194.i.epil, %l_body.i.i.i180.i.epil ]
  %tmore.i.i.i68571.i = icmp samesign ult i64 %idx_next.i.i.i194.i.lcssa, %len.i.i.i54.i
  br i1 %tmore.i.i.i68571.i, label %l_tail_body.i.i.i173.i.preheader, label %l_done.i.i.i69.i

l_tail_body.i.i.i173.i.preheader:                 ; preds = %l_tail_cond.i.i.i65.preheader.i
  %24 = sub i64 %w0.i.i.i52.i, %idx_next.i.i.i194.i.lcssa
  %xtraiter326 = and i64 %24, 3
  %lcmp.mod327.not = icmp eq i64 %xtraiter326, 0
  br i1 %lcmp.mod327.not, label %l_tail_body.i.i.i173.i.prol.loopexit, label %l_tail_body.i.i.i173.i.prol

l_tail_body.i.i.i173.i.prol:                      ; preds = %l_tail_body.i.i.i173.i.preheader, %l_tail_body.i.i.i173.i.prol
  %tacc.i.i.i67573.i.prol = phi i64 [ %tacc_next.i.i.i178.i.prol, %l_tail_body.i.i.i173.i.prol ], [ %acc_next.i.i.i193.i.lcssa, %l_tail_body.i.i.i173.i.preheader ]
  %ti.i.i.i66572.i.prol = phi i64 [ %ti_next.i.i.i179.i.prol, %l_tail_body.i.i.i173.i.prol ], [ %idx_next.i.i.i194.i.lcssa, %l_tail_body.i.i.i173.i.preheader ]
  %prol.iter328 = phi i64 [ %prol.iter328.next, %l_tail_body.i.i.i173.i.prol ], [ 0, %l_tail_body.i.i.i173.i.preheader ]
  %tp.i.i.i174.i.prol = getelementptr inbounds nuw i8, ptr %ptr.i.i.i58.i, i64 %ti.i.i.i66572.i.prol
  %tb.i.i.i175.i.prol = load i8, ptr %tp.i.i.i174.i.prol, align 1
  %tz.i.i.i176.i.prol = zext i8 %tb.i.i.i175.i.prol to i64
  %tx.i.i.i177.i.prol = xor i64 %tacc.i.i.i67573.i.prol, %tz.i.i.i176.i.prol
  %tacc_next.i.i.i178.i.prol = mul i64 %tx.i.i.i177.i.prol, 1099511628211
  %ti_next.i.i.i179.i.prol = add nuw nsw i64 %ti.i.i.i66572.i.prol, 1
  %prol.iter328.next = add i64 %prol.iter328, 1
  %prol.iter328.cmp.not = icmp eq i64 %prol.iter328.next, %xtraiter326
  br i1 %prol.iter328.cmp.not, label %l_tail_body.i.i.i173.i.prol.loopexit, label %l_tail_body.i.i.i173.i.prol, !llvm.loop !2

l_tail_body.i.i.i173.i.prol.loopexit:             ; preds = %l_tail_body.i.i.i173.i.prol, %l_tail_body.i.i.i173.i.preheader
  %tacc.i.i.i67573.i.unr = phi i64 [ %acc_next.i.i.i193.i.lcssa, %l_tail_body.i.i.i173.i.preheader ], [ %tacc_next.i.i.i178.i.prol, %l_tail_body.i.i.i173.i.prol ]
  %ti.i.i.i66572.i.unr = phi i64 [ %idx_next.i.i.i194.i.lcssa, %l_tail_body.i.i.i173.i.preheader ], [ %ti_next.i.i.i179.i.prol, %l_tail_body.i.i.i173.i.prol ]
  %tacc_next.i.i.i178.i.lcssa.unr = phi i64 [ poison, %l_tail_body.i.i.i173.i.preheader ], [ %tacc_next.i.i.i178.i.prol, %l_tail_body.i.i.i173.i.prol ]
  %25 = sub i64 %idx_next.i.i.i194.i.lcssa, %len.i.i.i54.i
  %26 = icmp ugt i64 %25, -4
  br i1 %26, label %l_done.i.i.i69.i, label %l_tail_body.i.i.i173.i.preheader.new

l_tail_body.i.i.i173.i.preheader.new:             ; preds = %l_tail_body.i.i.i173.i.prol.loopexit
  %invariant.gep349 = getelementptr i8, ptr %ptr.i.i.i58.i, i64 1
  %invariant.gep351 = getelementptr i8, ptr %ptr.i.i.i58.i, i64 2
  %invariant.gep353 = getelementptr i8, ptr %ptr.i.i.i58.i, i64 3
  br label %l_tail_body.i.i.i173.i

l_body.i.i.i180.i:                                ; preds = %l_body.i.i.i180.i, %long_hash.i.i.i56.i.new
  %acc.i.i.i62570.i = phi i64 [ %seed.i.i.i59.i, %long_hash.i.i.i56.i.new ], [ %acc_next.i.i.i193.i.1, %l_body.i.i.i180.i ]
  %idx.i.i.i61569.i = phi i64 [ 0, %long_hash.i.i.i56.i.new ], [ %idx_next.i.i.i194.i.1, %l_body.i.i.i180.i ]
  %niter325 = phi i64 [ 0, %long_hash.i.i.i56.i.new ], [ %niter325.next.1, %l_body.i.i.i180.i ]
  %lp.i.i.i181.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i58.i, i64 %idx.i.i.i61569.i
  %lane.i.i.i182.i = load i64, ptr %lp.i.i.i181.i, align 4
  %lm.i.i.i183.i = mul i64 %lane.i.i.i182.i, -4417276706812531889
  %lx.i.i.i184.i = xor i64 %lm.i.i.i183.i, %acc.i.i.i62570.i
  %s1.i2.i.i.i185.i = lshr i64 %lx.i.i.i184.i, 30
  %x1.i3.i.i.i186.i = xor i64 %s1.i2.i.i.i185.i, %lx.i.i.i184.i
  %m1.i4.i.i.i187.i = mul i64 %x1.i3.i.i.i186.i, -4658895280553007687
  %s2.i5.i.i.i188.i = lshr i64 %m1.i4.i.i.i187.i, 27
  %x2.i6.i.i.i189.i = xor i64 %s2.i5.i.i.i188.i, %m1.i4.i.i.i187.i
  %m2.i7.i.i.i190.i = mul i64 %x2.i6.i.i.i189.i, -7723592293110705685
  %s3.i8.i.i.i191.i = lshr i64 %m2.i7.i.i.i190.i, 31
  %x3.i9.i.i.i192.i = xor i64 %s3.i8.i.i.i191.i, %m2.i7.i.i.i190.i
  %acc_next.i.i.i193.i = add i64 %x3.i9.i.i.i192.i, %idx.i.i.i61569.i
  %idx_next.i.i.i194.i = or disjoint i64 %idx.i.i.i61569.i, 8
  %lp.i.i.i181.i.1 = getelementptr inbounds nuw i8, ptr %ptr.i.i.i58.i, i64 %idx_next.i.i.i194.i
  %lane.i.i.i182.i.1 = load i64, ptr %lp.i.i.i181.i.1, align 4
  %lm.i.i.i183.i.1 = mul i64 %lane.i.i.i182.i.1, -4417276706812531889
  %lx.i.i.i184.i.1 = xor i64 %lm.i.i.i183.i.1, %acc_next.i.i.i193.i
  %s1.i2.i.i.i185.i.1 = lshr i64 %lx.i.i.i184.i.1, 30
  %x1.i3.i.i.i186.i.1 = xor i64 %s1.i2.i.i.i185.i.1, %lx.i.i.i184.i.1
  %m1.i4.i.i.i187.i.1 = mul i64 %x1.i3.i.i.i186.i.1, -4658895280553007687
  %s2.i5.i.i.i188.i.1 = lshr i64 %m1.i4.i.i.i187.i.1, 27
  %x2.i6.i.i.i189.i.1 = xor i64 %s2.i5.i.i.i188.i.1, %m1.i4.i.i.i187.i.1
  %m2.i7.i.i.i190.i.1 = mul i64 %x2.i6.i.i.i189.i.1, -7723592293110705685
  %s3.i8.i.i.i191.i.1 = lshr i64 %m2.i7.i.i.i190.i.1, 31
  %x3.i9.i.i.i192.i.1 = xor i64 %s3.i8.i.i.i191.i.1, %m2.i7.i.i.i190.i.1
  %acc_next.i.i.i193.i.1 = add i64 %x3.i9.i.i.i192.i.1, %idx_next.i.i.i194.i
  %idx_next.i.i.i194.i.1 = add nuw nsw i64 %idx.i.i.i61569.i, 16
  %niter325.next.1 = add i64 %niter325, 2
  %niter325.ncmp.1.not = icmp eq i64 %niter325.next.1, %unroll_iter324
  br i1 %niter325.ncmp.1.not, label %l_tail_cond.i.i.i65.preheader.i.unr-lcssa, label %l_body.i.i.i180.i

l_tail_body.i.i.i173.i:                           ; preds = %l_tail_body.i.i.i173.i, %l_tail_body.i.i.i173.i.preheader.new
  %tacc.i.i.i67573.i = phi i64 [ %tacc.i.i.i67573.i.unr, %l_tail_body.i.i.i173.i.preheader.new ], [ %tacc_next.i.i.i178.i.3, %l_tail_body.i.i.i173.i ]
  %ti.i.i.i66572.i = phi i64 [ %ti.i.i.i66572.i.unr, %l_tail_body.i.i.i173.i.preheader.new ], [ %ti_next.i.i.i179.i.3, %l_tail_body.i.i.i173.i ]
  %tp.i.i.i174.i = getelementptr inbounds nuw i8, ptr %ptr.i.i.i58.i, i64 %ti.i.i.i66572.i
  %tb.i.i.i175.i = load i8, ptr %tp.i.i.i174.i, align 1
  %tz.i.i.i176.i = zext i8 %tb.i.i.i175.i to i64
  %tx.i.i.i177.i = xor i64 %tacc.i.i.i67573.i, %tz.i.i.i176.i
  %tacc_next.i.i.i178.i = mul i64 %tx.i.i.i177.i, 1099511628211
  %gep350 = getelementptr i8, ptr %invariant.gep349, i64 %ti.i.i.i66572.i
  %tb.i.i.i175.i.1 = load i8, ptr %gep350, align 1
  %tz.i.i.i176.i.1 = zext i8 %tb.i.i.i175.i.1 to i64
  %tx.i.i.i177.i.1 = xor i64 %tacc_next.i.i.i178.i, %tz.i.i.i176.i.1
  %tacc_next.i.i.i178.i.1 = mul i64 %tx.i.i.i177.i.1, 1099511628211
  %gep352 = getelementptr i8, ptr %invariant.gep351, i64 %ti.i.i.i66572.i
  %tb.i.i.i175.i.2 = load i8, ptr %gep352, align 1
  %tz.i.i.i176.i.2 = zext i8 %tb.i.i.i175.i.2 to i64
  %tx.i.i.i177.i.2 = xor i64 %tacc_next.i.i.i178.i.1, %tz.i.i.i176.i.2
  %tacc_next.i.i.i178.i.2 = mul i64 %tx.i.i.i177.i.2, 1099511628211
  %gep354 = getelementptr i8, ptr %invariant.gep353, i64 %ti.i.i.i66572.i
  %tb.i.i.i175.i.3 = load i8, ptr %gep354, align 1
  %tz.i.i.i176.i.3 = zext i8 %tb.i.i.i175.i.3 to i64
  %tx.i.i.i177.i.3 = xor i64 %tacc_next.i.i.i178.i.2, %tz.i.i.i176.i.3
  %tacc_next.i.i.i178.i.3 = mul i64 %tx.i.i.i177.i.3, 1099511628211
  %ti_next.i.i.i179.i.3 = add nuw nsw i64 %ti.i.i.i66572.i, 4
  %tmore.i.i.i68.i.3 = icmp samesign ult i64 %ti_next.i.i.i179.i.3, %len.i.i.i54.i
  br i1 %tmore.i.i.i68.i.3, label %l_tail_body.i.i.i173.i, label %l_done.i.i.i69.i

l_done.i.i.i69.i:                                 ; preds = %l_tail_body.i.i.i173.i.prol.loopexit, %l_tail_body.i.i.i173.i, %l_tail_cond.i.i.i65.preheader.i
  %tacc.i.i.i67.lcssa.i = phi i64 [ %acc_next.i.i.i193.i.lcssa, %l_tail_cond.i.i.i65.preheader.i ], [ %tacc_next.i.i.i178.i.lcssa.unr, %l_tail_body.i.i.i173.i.prol.loopexit ], [ %tacc_next.i.i.i178.i.3, %l_tail_body.i.i.i173.i ]
  %s1.i.i.i.i70.i = lshr i64 %tacc.i.i.i67.lcssa.i, 30
  %x1.i.i.i.i71.i = xor i64 %s1.i.i.i.i70.i, %tacc.i.i.i67.lcssa.i
  br label %archx_hash_str.exit.i.i78.i

archx_hash_str.exit.i.i78.i:                      ; preds = %l_done.i.i.i69.i, %sso_mix.i.i.i206.i
  %x1.i.i.i.i71.sink.i = phi i64 [ %x1.i.i.i.i71.i, %l_done.i.i.i69.i ], [ %x1.i11.i.i.i214.i, %sso_mix.i.i.i206.i ]
  %ctrl.i.i.i85.i = load ptr, ptr %ctrl_p.i.i.i.i, align 8
  %c_null.i.i.i86.i = icmp eq ptr %ctrl.i.i.i85.i, null
  br i1 %c_null.i.i.i86.i, label %dget2.merge.31.i, label %do_probe.i.i.i87.i

do_probe.i.i.i87.i:                               ; preds = %archx_hash_str.exit.i.i78.i
  %m1.i.i.i.i72.i = mul i64 %x1.i.i.i.i71.sink.i, -4658895280553007687
  %s2.i.i.i.i73.i = lshr i64 %m1.i.i.i.i72.i, 27
  %x2.i.i.i.i74.i = xor i64 %s2.i.i.i.i73.i, %m1.i.i.i.i72.i
  %m2.i.i.i.i75.i = mul i64 %x2.i.i.i.i74.i, -7723592293110705685
  %s3.i.i.i.i76.i = lshr i64 %m2.i.i.i.i75.i, 31
  %x3.i.i.i.i77.i = xor i64 %s3.i.i.i.i76.i, %m2.i.i.i.i75.i
  %mask.i.i.i90.i = load i64, ptr %mask_p.i.i.i.i, align 8
  %keys.i.i.i91.i = load ptr, ptr %keys_p.i.i.i.i, align 8
  %27 = getelementptr i8, ptr %ctrl.i.i.i85.i, i64 %mask.i.i.i90.i
  %idx_base.i.i.i92.i = getelementptr i8, ptr %27, i64 17
  %h2_64.i.i.i93.i = lshr i64 %m2.i.i.i.i75.i, 57
  %h2.i.i.i94.i = trunc nuw nsw i64 %h2_64.i.i.i93.i to i8
  %h2_ins.i.i.i95.i = insertelement <16 x i8> poison, i8 %h2.i.i.i94.i, i64 0
  %h2_vec.i.i.i96.i = shufflevector <16 x i8> %h2_ins.i.i.i95.i, <16 x i8> poison, <16 x i32> zeroinitializer
  %bp_i.i.i.i.i141.i = and i64 %w1.i.i.i53.i, -4
  %bp.i.i.i.i145.i = inttoptr i64 %bp_i.i.i.i.i141.i to ptr
  %bp4.i.i.i.i147.i = getelementptr inbounds nuw i8, ptr %bp.i.i.i.i145.i, i64 4
  %rem.i.i.i.i148.i = add nsw i64 %len.i.i.i54.i, -4
  br label %probe.i.i.i97.i

probe.i.i.i97.i:                                  ; preds = %next_grp.i.i.i162.i, %do_probe.i.i.i87.i
  %h.pn.i.i.i98.i = phi i64 [ %x3.i.i.i.i77.i, %do_probe.i.i.i87.i ], [ %padd.i.i.i164.i, %next_grp.i.i.i162.i ]
  %step.i.i.i99.i = phi i64 [ 0, %do_probe.i.i.i87.i ], [ %step_next.i.i.i163.i, %next_grp.i.i.i162.i ]
  %avail.i.i.i100.i = phi i64 [ -1, %do_probe.i.i.i87.i ], [ %avail_cur.i.i.i156.i, %next_grp.i.i.i162.i ]
  %pos.i.i.i101.i = and i64 %h.pn.i.i.i98.i, %mask.i.i.i90.i
  %gp.i.i.i102.i = getelementptr inbounds i8, ptr %ctrl.i.i.i85.i, i64 %pos.i.i.i101.i
  %grp.i.i.i103.i = load <16 x i8>, ptr %gp.i.i.i102.i, align 1
  %mcmp.i.i.i104.i = icmp eq <16 x i8> %grp.i.i.i103.i, %h2_vec.i.i.i96.i
  %mbits.i.i.i105.i = bitcast <16 x i1> %mcmp.i.i.i104.i to i16
  %has_m.not.i.i.i109575.i = icmp eq i16 %mbits.i.i.i105.i, 0
  br i1 %has_m.not.i.i.i109575.i, label %chk_empty.i.i.i153.i, label %chk_key.i.i.i110.preheader.i

chk_key.i.i.i110.preheader.i:                     ; preds = %probe.i.i.i97.i
  %mmask0.i.i.i106.i = zext i16 %mbits.i.i.i105.i to i32
  br label %chk_key.i.i.i110.i

chk_key.i.i.i110.i:                               ; preds = %mbit_cont.i.i.i127.i, %chk_key.i.i.i110.preheader.i
  %mmask.i.i.i108576.i = phi i32 [ %mmask_next.i.i.i129.i, %mbit_cont.i.i.i127.i ], [ %mmask0.i.i.i106.i, %chk_key.i.i.i110.preheader.i ]
  %tz.i2.i.i111.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i108576.i, i1 true)
  %tz64.i.i.i112.i = zext nneg i32 %tz.i2.i.i111.i to i64
  %s_add.i.i.i113.i = add i64 %pos.i.i.i101.i, %tz64.i.i.i112.i
  %slot.i.i.i114.i = and i64 %s_add.i.i.i113.i, %mask.i.i.i90.i
  %ip.i.i.i115.i = getelementptr inbounds i32, ptr %idx_base.i.i.i92.i, i64 %slot.i.i.i114.i
  %didx32.i.i.i116.i = load i32, ptr %ip.i.i.i115.i, align 4
  %didx.i.i.i117.i = zext i32 %didx32.i.i.i116.i to i64
  %kp.i.i.i118.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i91.i, i64 %didx.i.i.i117.i
  %cand_k.unpack.i.i.i119.i = load i64, ptr %kp.i.i.i118.i, align 8
  %cand_k.elt1.i.i.i120.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i118.i, i64 8
  %cand_k.unpack2.i.i.i121.i = load i64, ptr %cand_k.elt1.i.i.i120.i, align 8
  %w0_eq.i.i.i.i124.i = icmp eq i64 %cand_k.unpack.i.i.i119.i, %w0.i.i.i52.i
  br i1 %w0_eq.i.i.i.i124.i, label %chk_len.i.i.i.i135.i, label %mbit_cont.i.i.i127.i

chk_len.i.i.i.i135.i:                             ; preds = %chk_key.i.i.i110.i
  br i1 %short.i.i.i55.i, label %cmp_short.i.i.i.i151.i, label %cmp_long.i.i.i.i139.i

cmp_short.i.i.i.i151.i:                           ; preds = %chk_len.i.i.i.i135.i
  %eq_s.i.i.i.i152.i = icmp eq i64 %cand_k.unpack2.i.i.i121.i, %w1.i.i.i53.i
  br i1 %eq_s.i.i.i.i152.i, label %dget2.hit.27.i, label %mbit_cont.i.i.i127.i

cmp_long.i.i.i.i139.i:                            ; preds = %chk_len.i.i.i.i135.i
  %ap_i.i.i.i.i140.i = and i64 %cand_k.unpack2.i.i.i121.i, -4
  %same_ptr.i.i.i.i142.i = icmp eq i64 %ap_i.i.i.i.i140.i, %bp_i.i.i.i.i141.i
  br i1 %same_ptr.i.i.i.i142.i, label %dget2.hit.27.i, label %archx_str_eq.exit.i.i.i125.i

archx_str_eq.exit.i.i.i125.i:                     ; preds = %cmp_long.i.i.i.i139.i
  %ap.i.i.i.i144.i = inttoptr i64 %ap_i.i.i.i.i140.i to ptr
  %ap4.i.i.i.i146.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i144.i, i64 4
  %bcmp.i.i.i.i149.i = call i32 @bcmp(ptr nonnull %ap4.i.i.i.i146.i, ptr nonnull %bp4.i.i.i.i147.i, i64 %rem.i.i.i.i148.i)
  %eq_m.i.i.i.i150.i = icmp eq i32 %bcmp.i.i.i.i149.i, 0
  br i1 %eq_m.i.i.i.i150.i, label %dget2.hit.27.i, label %mbit_cont.i.i.i127.i

mbit_cont.i.i.i127.i:                             ; preds = %archx_str_eq.exit.i.i.i125.i, %cmp_short.i.i.i.i151.i, %chk_key.i.i.i110.i
  %mm1.i.i.i128.i = add nsw i32 %mmask.i.i.i108576.i, -1
  %mmask_next.i.i.i129.i = and i32 %mm1.i.i.i128.i, %mmask.i.i.i108576.i
  %has_m.not.i.i.i109.i = icmp eq i32 %mmask_next.i.i.i129.i, 0
  br i1 %has_m.not.i.i.i109.i, label %chk_empty.i.i.i153.i, label %chk_key.i.i.i110.i

chk_empty.i.i.i153.i:                             ; preds = %mbit_cont.i.i.i127.i, %probe.i.i.i97.i
  %need_a.i.i.i154.i = icmp slt i64 %avail.i.i.i100.i, 0
  br i1 %need_a.i.i.i154.i, label %find_a.i.i.i165.i, label %after_a.i.i.i155.i

find_a.i.i.i165.i:                                ; preds = %chk_empty.i.i.i153.i
  %acmp.i.i.i166.i = icmp slt <16 x i8> %grp.i.i.i103.i, zeroinitializer
  %abits16.i.i.i167.i = bitcast <16 x i1> %acmp.i.i.i166.i to i16
  %has_a0.not.i.i.i168.i = icmp eq i16 %abits16.i.i.i167.i, 0
  br i1 %has_a0.not.i.i.i168.i, label %after_a.i.i.i155.i, label %set_a.i.i.i169.i

set_a.i.i.i169.i:                                 ; preds = %find_a.i.i.i165.i
  %28 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i167.i, i1 true)
  %atz64.i.i.i170.i = zext nneg i16 %28 to i64
  %as_add.i.i.i171.i = add i64 %pos.i.i.i101.i, %atz64.i.i.i170.i
  %aslot.i.i.i172.i = and i64 %as_add.i.i.i171.i, %mask.i.i.i90.i
  br label %after_a.i.i.i155.i

after_a.i.i.i155.i:                               ; preds = %set_a.i.i.i169.i, %find_a.i.i.i165.i, %chk_empty.i.i.i153.i
  %avail_cur.i.i.i156.i = phi i64 [ %avail.i.i.i100.i, %chk_empty.i.i.i153.i ], [ -1, %find_a.i.i.i165.i ], [ %aslot.i.i.i172.i, %set_a.i.i.i169.i ]
  %ecmp.i.i.i157.i = icmp eq <16 x i8> %grp.i.i.i103.i, splat (i8 -128)
  %ebits.i.i.i158.i = bitcast <16 x i1> %ecmp.i.i.i157.i to i16
  %has_e.not.i.i.i159.i = icmp eq i16 %ebits.i.i.i158.i, 0
  br i1 %has_e.not.i.i.i159.i, label %next_grp.i.i.i162.i, label %dget2.merge.31.i

next_grp.i.i.i162.i:                              ; preds = %after_a.i.i.i155.i
  %step_next.i.i.i163.i = add i64 %step.i.i.i99.i, 16
  %padd.i.i.i164.i = add i64 %step_next.i.i.i163.i, %pos.i.i.i101.i
  br label %probe.i.i.i97.i

dget2.hit.27.i:                                   ; preds = %archx_str_eq.exit.i.i.i125.i, %cmp_long.i.i.i.i139.i, %cmp_short.i.i.i.i151.i
  %t105.i = load ptr, ptr %t24.i, align 8
  %t106.i = getelementptr inbounds nuw i64, ptr %t105.i, i64 %didx.i.i.i117.i
  %t107.i = load i64, ptr %t106.i, align 8
  br label %dget2.merge.31.i

dget2.merge.31.i:                                 ; preds = %after_a.i.i.i155.i, %dget2.hit.27.i, %archx_hash_str.exit.i.i78.i
  %t108.i = phi i64 [ %t107.i, %dget2.hit.27.i ], [ 0, %archx_hash_str.exit.i.i78.i ], [ 0, %after_a.i.i.i155.i ]
  %t109.i = add i64 %t108.i, %var.str_checksum.0.1578.i
  %tag.i46.i = and i64 %w1.i.i.i53.i, 1
  %owned.not.i47.i = icmp eq i64 %tag.i46.i, 0
  %or.cond536.i = select i1 %short.i.i.i55.i, i1 true, i1 %owned.not.i47.i
  br i1 %or.cond536.i, label %archx_str_drop.exit51.i, label %do_free.i48.i

do_free.i48.i:                                    ; preds = %dget2.merge.31.i
  %raw.i49.i = and i64 %w1.i.i.i53.i, -2
  %ptr.i50.i = inttoptr i64 %raw.i49.i to ptr
  call void @free(ptr %ptr.i50.i)
  br label %archx_str_drop.exit51.i

archx_str_drop.exit51.i:                          ; preds = %do_free.i48.i, %dget2.merge.31.i
  %t112.i = add nuw nsw i64 %for.p.81.0577.i, 1
  %exitcond617.not.i = icmp eq i64 %t112.i, 2048
  br i1 %exitcond617.not.i, label %l_done.i.i.i237.i, label %idx.ok.25.i

l_done.i.i.i237.i:                                ; preds = %archx_str_drop.exit51.i
  %ctrl.i.i.i253.i = load ptr, ptr %ctrl_p.i.i.i.i, align 8
  %c_null.i.i.i254.i = icmp eq ptr %ctrl.i.i.i253.i, null
  br i1 %c_null.i.i.i254.i, label %dget2.merge.39.i, label %do_probe.i.i.i255.i

do_probe.i.i.i255.i:                              ; preds = %l_done.i.i.i237.i
  %mask.i.i.i258.i = load i64, ptr %mask_p.i.i.i.i, align 8
  %keys.i.i.i259.i = load ptr, ptr %keys_p.i.i.i.i, align 8
  %29 = getelementptr i8, ptr %ctrl.i.i.i253.i, i64 %mask.i.i.i258.i
  %idx_base.i.i.i260.i = getelementptr i8, ptr %29, i64 17
  br label %probe.i.i.i265.i

probe.i.i.i265.i:                                 ; preds = %next_grp.i.i.i325.i, %do_probe.i.i.i255.i
  %h.pn.i.i.i266.i = phi i64 [ 479829472233321983, %do_probe.i.i.i255.i ], [ %padd.i.i.i327.i, %next_grp.i.i.i325.i ]
  %step.i.i.i267.i = phi i64 [ 0, %do_probe.i.i.i255.i ], [ %step_next.i.i.i326.i, %next_grp.i.i.i325.i ]
  %avail.i.i.i268.i = phi i64 [ -1, %do_probe.i.i.i255.i ], [ %avail_cur.i.i.i319.i, %next_grp.i.i.i325.i ]
  %pos.i.i.i269.i = and i64 %h.pn.i.i.i266.i, %mask.i.i.i258.i
  %gp.i.i.i270.i = getelementptr inbounds i8, ptr %ctrl.i.i.i253.i, i64 %pos.i.i.i269.i
  %grp.i.i.i271.i = load <16 x i8>, ptr %gp.i.i.i270.i, align 1
  %mcmp.i.i.i272.i = icmp eq <16 x i8> %grp.i.i.i271.i, splat (i8 3)
  %mbits.i.i.i273.i = bitcast <16 x i1> %mcmp.i.i.i272.i to i16
  %has_m.not.i.i.i277585.i = icmp eq i16 %mbits.i.i.i273.i, 0
  br i1 %has_m.not.i.i.i277585.i, label %chk_empty.i.i.i316.i, label %chk_key.i.i.i278.preheader.i

chk_key.i.i.i278.preheader.i:                     ; preds = %probe.i.i.i265.i
  %mmask0.i.i.i274.i = zext i16 %mbits.i.i.i273.i to i32
  br label %chk_key.i.i.i278.i

chk_key.i.i.i278.i:                               ; preds = %mbit_cont.i.i.i294.i, %chk_key.i.i.i278.preheader.i
  %mmask.i.i.i276586.i = phi i32 [ %mmask_next.i.i.i296.i, %mbit_cont.i.i.i294.i ], [ %mmask0.i.i.i274.i, %chk_key.i.i.i278.preheader.i ]
  %tz.i2.i.i279.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i276586.i, i1 true)
  %tz64.i.i.i280.i = zext nneg i32 %tz.i2.i.i279.i to i64
  %s_add.i.i.i281.i = add i64 %pos.i.i.i269.i, %tz64.i.i.i280.i
  %slot.i.i.i282.i = and i64 %s_add.i.i.i281.i, %mask.i.i.i258.i
  %ip.i.i.i283.i = getelementptr inbounds i32, ptr %idx_base.i.i.i260.i, i64 %slot.i.i.i282.i
  %didx32.i.i.i284.i = load i32, ptr %ip.i.i.i283.i, align 4
  %didx.i.i.i285.i = zext i32 %didx32.i.i.i284.i to i64
  %kp.i.i.i286.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i259.i, i64 %didx.i.i.i285.i
  %cand_k.unpack.i.i.i287.i = load i64, ptr %kp.i.i.i286.i, align 8
  %w0_eq.i.i.i.i291.i = icmp eq i64 %cand_k.unpack.i.i.i287.i, 8319108853555789841
  br i1 %w0_eq.i.i.i.i291.i, label %cmp_long.i.i.i.i305.i, label %mbit_cont.i.i.i294.i

cmp_long.i.i.i.i305.i:                            ; preds = %chk_key.i.i.i278.i
  %cand_k.elt1.i.i.i288.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i286.i, i64 8
  %cand_k.unpack2.i.i.i289.i = load i64, ptr %cand_k.elt1.i.i.i288.i, align 8
  %ap_i.i.i.i.i306.i = and i64 %cand_k.unpack2.i.i.i289.i, -4
  %same_ptr.i.i.i.i307.i = icmp eq i64 %ap_i.i.i.i.i306.i, ptrtoint (ptr @.str.0 to i64)
  br i1 %same_ptr.i.i.i.i307.i, label %if.merge.34.i, label %archx_str_eq.exit.i.i.i292.i

archx_str_eq.exit.i.i.i292.i:                     ; preds = %cmp_long.i.i.i.i305.i
  %ap.i.i.i.i309.i = inttoptr i64 %ap_i.i.i.i.i306.i to ptr
  %ap4.i.i.i.i310.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i309.i, i64 4
  %bcmp.i.i.i.i312.i = call i32 @bcmp(ptr noundef nonnull dereferenceable(13) %ap4.i.i.i.i310.i, ptr noundef nonnull dereferenceable(13) getelementptr inbounds nuw (i8, ptr @.str.0, i64 4), i64 13)
  %eq_m.i.i.i.i313.i = icmp eq i32 %bcmp.i.i.i.i312.i, 0
  br i1 %eq_m.i.i.i.i313.i, label %if.merge.34.i, label %mbit_cont.i.i.i294.i

mbit_cont.i.i.i294.i:                             ; preds = %archx_str_eq.exit.i.i.i292.i, %chk_key.i.i.i278.i
  %mm1.i.i.i295.i = add nsw i32 %mmask.i.i.i276586.i, -1
  %mmask_next.i.i.i296.i = and i32 %mm1.i.i.i295.i, %mmask.i.i.i276586.i
  %has_m.not.i.i.i277.i = icmp eq i32 %mmask_next.i.i.i296.i, 0
  br i1 %has_m.not.i.i.i277.i, label %chk_empty.i.i.i316.i, label %chk_key.i.i.i278.i

chk_empty.i.i.i316.i:                             ; preds = %mbit_cont.i.i.i294.i, %probe.i.i.i265.i
  %need_a.i.i.i317.i = icmp slt i64 %avail.i.i.i268.i, 0
  br i1 %need_a.i.i.i317.i, label %find_a.i.i.i328.i, label %after_a.i.i.i318.i

find_a.i.i.i328.i:                                ; preds = %chk_empty.i.i.i316.i
  %acmp.i.i.i329.i = icmp slt <16 x i8> %grp.i.i.i271.i, zeroinitializer
  %abits16.i.i.i330.i = bitcast <16 x i1> %acmp.i.i.i329.i to i16
  %has_a0.not.i.i.i331.i = icmp eq i16 %abits16.i.i.i330.i, 0
  br i1 %has_a0.not.i.i.i331.i, label %after_a.i.i.i318.i, label %set_a.i.i.i332.i

set_a.i.i.i332.i:                                 ; preds = %find_a.i.i.i328.i
  %30 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i330.i, i1 true)
  %atz64.i.i.i333.i = zext nneg i16 %30 to i64
  %as_add.i.i.i334.i = add i64 %pos.i.i.i269.i, %atz64.i.i.i333.i
  %aslot.i.i.i335.i = and i64 %as_add.i.i.i334.i, %mask.i.i.i258.i
  br label %after_a.i.i.i318.i

after_a.i.i.i318.i:                               ; preds = %set_a.i.i.i332.i, %find_a.i.i.i328.i, %chk_empty.i.i.i316.i
  %avail_cur.i.i.i319.i = phi i64 [ %avail.i.i.i268.i, %chk_empty.i.i.i316.i ], [ -1, %find_a.i.i.i328.i ], [ %aslot.i.i.i335.i, %set_a.i.i.i332.i ]
  %ecmp.i.i.i320.i = icmp eq <16 x i8> %grp.i.i.i271.i, splat (i8 -128)
  %ebits.i.i.i321.i = bitcast <16 x i1> %ecmp.i.i.i320.i to i16
  %has_e.not.i.i.i322.i = icmp eq i16 %ebits.i.i.i321.i, 0
  br i1 %has_e.not.i.i.i322.i, label %next_grp.i.i.i325.i, label %probe.i.i.i397.i

next_grp.i.i.i325.i:                              ; preds = %after_a.i.i.i318.i
  %step_next.i.i.i326.i = add i64 %step.i.i.i267.i, 16
  %padd.i.i.i327.i = add i64 %step_next.i.i.i326.i, %pos.i.i.i269.i
  br label %probe.i.i.i265.i

probe.i.i.i397.i:                                 ; preds = %after_a.i.i.i318.i, %next_grp.i.i.i457.i
  %h.pn.i.i.i398.i = phi i64 [ %padd.i.i.i459.i, %next_grp.i.i.i457.i ], [ 479829472233321983, %after_a.i.i.i318.i ]
  %step.i.i.i399.i = phi i64 [ %step_next.i.i.i458.i, %next_grp.i.i.i457.i ], [ 0, %after_a.i.i.i318.i ]
  %avail.i.i.i400.i = phi i64 [ %avail_cur.i.i.i451.i, %next_grp.i.i.i457.i ], [ -1, %after_a.i.i.i318.i ]
  %pos.i.i.i401.i = and i64 %h.pn.i.i.i398.i, %mask.i.i.i258.i
  %gp.i.i.i402.i = getelementptr inbounds i8, ptr %ctrl.i.i.i253.i, i64 %pos.i.i.i401.i
  %grp.i.i.i403.i = load <16 x i8>, ptr %gp.i.i.i402.i, align 1
  %mcmp.i.i.i404.i = icmp eq <16 x i8> %grp.i.i.i403.i, splat (i8 3)
  %mbits.i.i.i405.i = bitcast <16 x i1> %mcmp.i.i.i404.i to i16
  %has_m.not.i.i.i409593.i = icmp eq i16 %mbits.i.i.i405.i, 0
  br i1 %has_m.not.i.i.i409593.i, label %chk_empty.i.i.i448.i, label %chk_key.i.i.i410.preheader.i

chk_key.i.i.i410.preheader.i:                     ; preds = %probe.i.i.i397.i
  %mmask0.i.i.i406.i = zext i16 %mbits.i.i.i405.i to i32
  br label %chk_key.i.i.i410.i

chk_key.i.i.i410.i:                               ; preds = %mbit_cont.i.i.i426.i, %chk_key.i.i.i410.preheader.i
  %mmask.i.i.i408594.i = phi i32 [ %mmask_next.i.i.i428.i, %mbit_cont.i.i.i426.i ], [ %mmask0.i.i.i406.i, %chk_key.i.i.i410.preheader.i ]
  %tz.i2.i.i411.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i.i408594.i, i1 true)
  %tz64.i.i.i412.i = zext nneg i32 %tz.i2.i.i411.i to i64
  %s_add.i.i.i413.i = add i64 %pos.i.i.i401.i, %tz64.i.i.i412.i
  %slot.i.i.i414.i = and i64 %s_add.i.i.i413.i, %mask.i.i.i258.i
  %ip.i.i.i415.i = getelementptr inbounds i32, ptr %idx_base.i.i.i260.i, i64 %slot.i.i.i414.i
  %didx32.i.i.i416.i = load i32, ptr %ip.i.i.i415.i, align 4
  %didx.i.i.i417.i = zext i32 %didx32.i.i.i416.i to i64
  %kp.i.i.i418.i = getelementptr inbounds nuw %ArchxStr, ptr %keys.i.i.i259.i, i64 %didx.i.i.i417.i
  %cand_k.unpack.i.i.i419.i = load i64, ptr %kp.i.i.i418.i, align 8
  %w0_eq.i.i.i.i423.i = icmp eq i64 %cand_k.unpack.i.i.i419.i, 8319108853555789841
  br i1 %w0_eq.i.i.i.i423.i, label %cmp_long.i.i.i.i437.i, label %mbit_cont.i.i.i426.i

cmp_long.i.i.i.i437.i:                            ; preds = %chk_key.i.i.i410.i
  %cand_k.elt1.i.i.i420.i = getelementptr inbounds nuw i8, ptr %kp.i.i.i418.i, i64 8
  %cand_k.unpack2.i.i.i421.i = load i64, ptr %cand_k.elt1.i.i.i420.i, align 8
  %ap_i.i.i.i.i438.i = and i64 %cand_k.unpack2.i.i.i421.i, -4
  %same_ptr.i.i.i.i439.i = icmp eq i64 %ap_i.i.i.i.i438.i, ptrtoint (ptr @.str.0 to i64)
  br i1 %same_ptr.i.i.i.i439.i, label %dget2.hit.35.i, label %archx_str_eq.exit.i.i.i424.i

archx_str_eq.exit.i.i.i424.i:                     ; preds = %cmp_long.i.i.i.i437.i
  %ap.i.i.i.i441.i = inttoptr i64 %ap_i.i.i.i.i438.i to ptr
  %ap4.i.i.i.i442.i = getelementptr inbounds nuw i8, ptr %ap.i.i.i.i441.i, i64 4
  %bcmp.i.i.i.i444.i = call i32 @bcmp(ptr noundef nonnull dereferenceable(13) %ap4.i.i.i.i442.i, ptr noundef nonnull dereferenceable(13) getelementptr inbounds nuw (i8, ptr @.str.0, i64 4), i64 13)
  %eq_m.i.i.i.i445.i = icmp eq i32 %bcmp.i.i.i.i444.i, 0
  br i1 %eq_m.i.i.i.i445.i, label %dget2.hit.35.i, label %mbit_cont.i.i.i426.i

mbit_cont.i.i.i426.i:                             ; preds = %archx_str_eq.exit.i.i.i424.i, %chk_key.i.i.i410.i
  %mm1.i.i.i427.i = add nsw i32 %mmask.i.i.i408594.i, -1
  %mmask_next.i.i.i428.i = and i32 %mm1.i.i.i427.i, %mmask.i.i.i408594.i
  %has_m.not.i.i.i409.i = icmp eq i32 %mmask_next.i.i.i428.i, 0
  br i1 %has_m.not.i.i.i409.i, label %chk_empty.i.i.i448.i, label %chk_key.i.i.i410.i

chk_empty.i.i.i448.i:                             ; preds = %mbit_cont.i.i.i426.i, %probe.i.i.i397.i
  %need_a.i.i.i449.i = icmp slt i64 %avail.i.i.i400.i, 0
  br i1 %need_a.i.i.i449.i, label %find_a.i.i.i460.i, label %after_a.i.i.i450.i

find_a.i.i.i460.i:                                ; preds = %chk_empty.i.i.i448.i
  %acmp.i.i.i461.i = icmp slt <16 x i8> %grp.i.i.i403.i, zeroinitializer
  %abits16.i.i.i462.i = bitcast <16 x i1> %acmp.i.i.i461.i to i16
  %has_a0.not.i.i.i463.i = icmp eq i16 %abits16.i.i.i462.i, 0
  br i1 %has_a0.not.i.i.i463.i, label %after_a.i.i.i450.i, label %set_a.i.i.i464.i

set_a.i.i.i464.i:                                 ; preds = %find_a.i.i.i460.i
  %31 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i462.i, i1 true)
  %atz64.i.i.i465.i = zext nneg i16 %31 to i64
  %as_add.i.i.i466.i = add i64 %pos.i.i.i401.i, %atz64.i.i.i465.i
  %aslot.i.i.i467.i = and i64 %as_add.i.i.i466.i, %mask.i.i.i258.i
  br label %after_a.i.i.i450.i

after_a.i.i.i450.i:                               ; preds = %set_a.i.i.i464.i, %find_a.i.i.i460.i, %chk_empty.i.i.i448.i
  %avail_cur.i.i.i451.i = phi i64 [ %avail.i.i.i400.i, %chk_empty.i.i.i448.i ], [ -1, %find_a.i.i.i460.i ], [ %aslot.i.i.i467.i, %set_a.i.i.i464.i ]
  %ecmp.i.i.i452.i = icmp eq <16 x i8> %grp.i.i.i403.i, splat (i8 -128)
  %ebits.i.i.i453.i = bitcast <16 x i1> %ecmp.i.i.i452.i to i16
  %has_e.not.i.i.i454.i = icmp eq i16 %ebits.i.i.i453.i, 0
  br i1 %has_e.not.i.i.i454.i, label %next_grp.i.i.i457.i, label %dget2.merge.39.i

next_grp.i.i.i457.i:                              ; preds = %after_a.i.i.i450.i
  %step_next.i.i.i458.i = add i64 %step.i.i.i399.i, 16
  %padd.i.i.i459.i = add i64 %step_next.i.i.i458.i, %pos.i.i.i401.i
  br label %probe.i.i.i397.i

dget2.hit.35.i:                                   ; preds = %archx_str_eq.exit.i.i.i424.i, %cmp_long.i.i.i.i437.i
  %t123.i = load ptr, ptr %t24.i, align 8
  %t124.i = getelementptr inbounds nuw i64, ptr %t123.i, i64 %didx.i.i.i417.i
  %t125.i = load i64, ptr %t124.i, align 8
  br label %dget2.merge.39.i

dget2.merge.39.i:                                 ; preds = %after_a.i.i.i450.i, %dget2.hit.35.i, %l_done.i.i.i237.i
  %t126.i = phi i64 [ %t125.i, %dget2.hit.35.i ], [ 3, %l_done.i.i.i237.i ], [ 3, %after_a.i.i.i450.i ]
  %t127.i = add i64 %t126.i, %t109.i
  br label %if.merge.34.i

if.merge.34.i:                                    ; preds = %archx_str_eq.exit.i.i.i292.i, %cmp_long.i.i.i.i305.i, %dget2.merge.39.i
  %var.str_checksum.0.2.i = phi i64 [ %t127.i, %dget2.merge.39.i ], [ %t109.i, %cmp_long.i.i.i.i305.i ], [ %t109.i, %archx_str_eq.exit.i.i.i292.i ]
  %t132.i = load i64, ptr %t23.i, align 8
  %t136595.i = icmp sgt i64 %t132.i, 0
  br i1 %t136595.i, label %foritems.body.44.lr.ph.i, label %archx_dict_drop_s_i.exit.i

foritems.body.44.lr.ph.i:                         ; preds = %if.merge.34.i
  %t142.i = load ptr, ptr %t24.i, align 8
  %min.iters.check = icmp ult i64 %t132.i, 4
  br i1 %min.iters.check, label %foritems.body.44.i.preheader, label %vector.ph

vector.ph:                                        ; preds = %foritems.body.44.lr.ph.i
  %n.vec = and i64 %t132.i, 9223372036854775804
  %32 = insertelement <2 x i64> <i64 poison, i64 0>, i64 %var.str_checksum.0.2.i, i64 0
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <2 x i64> [ %32, %vector.ph ], [ %35, %vector.body ]
  %vec.phi301 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %36, %vector.body ]
  %33 = getelementptr inbounds nuw i64, ptr %t142.i, i64 %index
  %34 = getelementptr inbounds nuw i8, ptr %33, i64 16
  %wide.load = load <2 x i64>, ptr %33, align 8
  %wide.load302 = load <2 x i64>, ptr %34, align 8
  %35 = add <2 x i64> %wide.load, %vec.phi
  %36 = add <2 x i64> %wide.load302, %vec.phi301
  %index.next = add nuw i64 %index, 4
  %37 = icmp eq i64 %index.next, %n.vec
  br i1 %37, label %middle.block, label %vector.body, !llvm.loop !3

middle.block:                                     ; preds = %vector.body
  %bin.rdx = add <2 x i64> %36, %35
  %38 = call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx)
  %cmp.n = icmp eq i64 %t132.i, %n.vec
  br i1 %cmp.n, label %body.i.i, label %foritems.body.44.i.preheader

foritems.body.44.i.preheader:                     ; preds = %foritems.body.44.lr.ph.i, %middle.block
  %foritems.idx.134.0597.i.ph = phi i64 [ 0, %foritems.body.44.lr.ph.i ], [ %n.vec, %middle.block ]
  %var.str_checksum.0.3596.i.ph = phi i64 [ %var.str_checksum.0.2.i, %foritems.body.44.lr.ph.i ], [ %38, %middle.block ]
  br label %foritems.body.44.i

foritems.body.44.i:                               ; preds = %foritems.body.44.i.preheader, %foritems.body.44.i
  %foritems.idx.134.0597.i = phi i64 [ %t150.i, %foritems.body.44.i ], [ %foritems.idx.134.0597.i.ph, %foritems.body.44.i.preheader ]
  %var.str_checksum.0.3596.i = phi i64 [ %t148.i, %foritems.body.44.i ], [ %var.str_checksum.0.3596.i.ph, %foritems.body.44.i.preheader ]
  %t145.i = getelementptr inbounds nuw i64, ptr %t142.i, i64 %foritems.idx.134.0597.i
  %t146.i = load i64, ptr %t145.i, align 8
  %t148.i = add i64 %t146.i, %var.str_checksum.0.3596.i
  %t150.i = add nuw nsw i64 %foritems.idx.134.0597.i, 1
  %exitcond618.not.i = icmp eq i64 %t150.i, %t132.i
  br i1 %exitcond618.not.i, label %body.i.i, label %foritems.body.44.i, !llvm.loop !6

body.i.i:                                         ; preds = %foritems.body.44.i, %middle.block
  %t148.i.lcssa = phi i64 [ %38, %middle.block ], [ %t148.i, %foritems.body.44.i ]
  %keys.i.i = load ptr, ptr %keys_p.i.i.i.i, align 8
  br label %d_elem.i.i

d_elem.i.i:                                       ; preds = %body.i.i, %archx_str_drop.exit.i.i
  %storemerge5.i.i = phi i64 [ %inext.i.i, %archx_str_drop.exit.i.i ], [ 0, %body.i.i ]
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
  %exitcond.not.i.i = icmp eq i64 %inext.i.i, %t132.i
  br i1 %exitcond.not.i.i, label %archx_dict_drop_s_i.exit.i, label %d_elem.i.i

archx_dict_drop_s_i.exit.i:                       ; preds = %archx_str_drop.exit.i.i, %if.merge.34.i
  %var.str_checksum.0.3.lcssa635.i = phi i64 [ %var.str_checksum.0.2.i, %if.merge.34.i ], [ %t148.i.lcssa, %archx_str_drop.exit.i.i ]
  %head.i.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i.i = icmp eq ptr %head.i.i, null
  br i1 %empty.i.i, label %archx_region_rewind_root.exit.i, label %archx_region_rewind_root.exit.thread.i

archx_region_rewind_root.exit.i:                  ; preds = %archx_dict_drop_s_i.exit.i
  %t153.i = add nuw nsw i64 %for.r.4.0599.i, 1
  %exitcond619.not.i = icmp eq i64 %t153.i, 120
  br i1 %exitcond619.not.i, label %archx_fn_run_str_bench.exit, label %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge

archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge: ; preds = %archx_region_rewind_root.exit.i
  %cur.i.i.i.pre.pre = load ptr, ptr %func.region.i, align 8
  %end.i.i.i.pre.pre = load ptr, ptr %.fca.1.gep.i, align 8
  br label %for.body.1.i.backedge

for.body.1.i.backedge:                            ; preds = %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge, %archx_region_rewind_root.exit.thread.i
  %end.i.i.i.be = phi ptr [ %end.i.i.i.pre.pre, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %end.i.i, %archx_region_rewind_root.exit.thread.i ]
  %cur.i.i.i.be = phi ptr [ %cur.i.i.i.pre.pre, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %data.i.i, %archx_region_rewind_root.exit.thread.i ]
  %for.r.4.0599.i.be = phi i64 [ %t153.i, %archx_region_rewind_root.exit.i.for.body.1.backedge.i_crit_edge ], [ %t153640.i, %archx_region_rewind_root.exit.thread.i ]
  br label %for.body.1.i

archx_region_rewind_root.exit.thread.i:           ; preds = %archx_dict_drop_s_i.exit.i
  %cap_ptr.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 8
  %cap.i.i = load i64, ptr %cap_ptr.i.i, align 8
  %data.i.i = getelementptr inbounds nuw i8, ptr %head.i.i, i64 16
  %end.i.i = getelementptr inbounds i8, ptr %data.i.i, i64 %cap.i.i
  store ptr %data.i.i, ptr %func.region.i, align 8
  store ptr %end.i.i, ptr %.fca.1.gep.i, align 8
  store ptr %head.i.i, ptr %.fca.3.gep.i, align 8
  %t153640.i = add nuw nsw i64 %for.r.4.0599.i, 1
  %exitcond619.not641.i = icmp eq i64 %t153640.i, 120
  br i1 %exitcond619.not641.i, label %loop.i.i, label %for.body.1.i.backedge

loop.i.i:                                         ; preds = %archx_region_rewind_root.exit.thread.i, %loop.i.i
  %cur.i.i = phi ptr [ %next.i.i, %loop.i.i ], [ %head.i.i, %archx_region_rewind_root.exit.thread.i ]
  %next.i.i = load ptr, ptr %cur.i.i, align 8
  call void @free(ptr nonnull %cur.i.i)
  %more.not.i.i = icmp eq ptr %next.i.i, null
  br i1 %more.not.i.i, label %archx_fn_run_str_bench.exit, label %loop.i.i

archx_fn_run_str_bench.exit:                      ; preds = %archx_region_rewind_root.exit.i, %loop.i.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  %t104 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %var.str_checksum.0.3.lcssa635.i)
  %hp.i.i114 = call noalias align 16 dereferenceable_or_null(64) ptr @calloc(i64 1, i64 64)
  %hnull.i.i115 = icmp eq ptr %hp.i.i114, null
  br i1 %hnull.i.i115, label %oom.i.i134, label %archx_dict_new.exit.i116

oom.i.i134:                                       ; preds = %archx_fn_run_str_bench.exit
  call fastcc void @archx_oom_fail()
  unreachable

archx_dict_new.exit.i116:                         ; preds = %archx_fn_run_str_bench.exit
  %h_meta_gep.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i114, i64 56
  store i64 34359740416, ptr %h_meta_gep.i.i, align 8
  %hpi.i.i = ptrtoint ptr %hp.i.i114 to i64
  %htag.i.i = or disjoint i64 %hpi.i.i, 1
  %t18.i = getelementptr inbounds nuw i8, ptr %hp.i.i114, i64 48
  br label %for.body.1.i117

for.cond.4.preheader.i:                           ; preds = %for.body.1.i117
  %ctrl_p.i.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i114, i64 32
  %mask_p.i.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i114, i64 16
  %keys_p.i.i.i = getelementptr inbounds nuw i8, ptr %hp.i.i114, i64 40
  br label %for.body.5.i

for.body.1.i117:                                  ; preds = %for.body.1.i117, %archx_dict_new.exit.i116
  %for.i.2.027.i = phi i64 [ 0, %archx_dict_new.exit.i116 ], [ %t22.i120, %for.body.1.i117 ]
  %t6.i = mul nuw nsw i64 %for.i.2.027.i, 17
  %t7.i = add nuw nsw i64 %t6.i, 3
  %39 = trunc nuw nsw i64 %for.i.2.027.i to i32
  %40 = mul nuw nsw i32 %39, 31
  %t12.lhs.trunc.i = add nuw nsw i32 %40, 7
  %t1224.i = urem i32 %t12.lhs.trunc.i, 100000
  %t12.zext.i = zext nneg i32 %t1224.i to i64
  %t13.i = call fastcc i64 @archx_dict_upsert_i64(i64 %htag.i.i, i64 %t7.i)
  %t19.i118 = load ptr, ptr %t18.i, align 16
  %t20.i119 = getelementptr inbounds i64, ptr %t19.i118, i64 %t13.i
  store i64 %t12.zext.i, ptr %t20.i119, align 8
  %t22.i120 = add nuw nsw i64 %for.i.2.027.i, 1
  %exitcond.not.i121 = icmp eq i64 %t22.i120, 32768
  br i1 %exitcond.not.i121, label %for.cond.4.preheader.i, label %for.body.1.i117

for.body.5.i:                                     ; preds = %archx_dict_erase_slot.exit.i, %for.cond.4.preheader.i
  %for.i.24.031.i = phi i64 [ 0, %for.cond.4.preheader.i ], [ %t46.i, %archx_dict_erase_slot.exit.i ]
  %var.popped_sum.23.030.i = phi i64 [ 0, %for.cond.4.preheader.i ], [ %t44.i125, %archx_dict_erase_slot.exit.i ]
  %t28.i122 = mul nuw nsw i64 %for.i.24.031.i, 17
  %t29.i = or disjoint i64 %t28.i122, 3
  %ctrl.i.i.i = load ptr, ptr %ctrl_p.i.i.i, align 16
  %c_null.i.i.i = icmp eq ptr %ctrl.i.i.i, null
  br i1 %c_null.i.i.i, label %archx_dict_find_i64.exit.i, label %do_probe.i.i.i

do_probe.i.i.i:                                   ; preds = %for.body.5.i
  %m1.i.i.i = mul i64 %t29.i, -4658895280553007687
  %s2.i.i.i = lshr i64 %m1.i.i.i, 27
  %x2.i.i.i = xor i64 %s2.i.i.i, %m1.i.i.i
  %m2.i.i.i = mul i64 %x2.i.i.i, -7723592293110705685
  %s3.i.i.i = lshr i64 %m2.i.i.i, 31
  %x3.i.i.i = xor i64 %s3.i.i.i, %m2.i.i.i
  %mask.i.i.i = load i64, ptr %mask_p.i.i.i, align 16
  %keys.i.i.i = load ptr, ptr %keys_p.i.i.i, align 8
  %41 = getelementptr i8, ptr %ctrl.i.i.i, i64 %mask.i.i.i
  %idx_base.i.i.i = getelementptr i8, ptr %41, i64 17
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
  %has_m.not.i.i28.i = icmp eq i16 %mbits.i.i.i, 0
  br i1 %has_m.not.i.i28.i, label %chk_empty.i.i.i, label %chk_key.i.i.preheader.i

chk_key.i.i.preheader.i:                          ; preds = %probe.i.i.i
  %mmask0.i.i.i = zext i16 %mbits.i.i.i to i32
  br label %chk_key.i.i.i

chk_key.i.i.i:                                    ; preds = %mbit_cont.i.i.i, %chk_key.i.i.preheader.i
  %mmask.i.i29.i = phi i32 [ %mmask_next.i.i.i, %mbit_cont.i.i.i ], [ %mmask0.i.i.i, %chk_key.i.i.preheader.i ]
  %tz.i.i.i = call range(i32 0, 33) i32 @llvm.cttz.i32(i32 %mmask.i.i29.i, i1 true)
  %tz64.i.i.i = zext nneg i32 %tz.i.i.i to i64
  %s_add.i.i.i = add i64 %pos.i.i.i, %tz64.i.i.i
  %slot.i.i.i = and i64 %s_add.i.i.i, %mask.i.i.i
  %ip.i.i.i = getelementptr inbounds i32, ptr %idx_base.i.i.i, i64 %slot.i.i.i
  %didx32.i.i.i = load i32, ptr %ip.i.i.i, align 4
  %didx.i.i.i = zext i32 %didx32.i.i.i to i64
  %kp.i.i.i = getelementptr inbounds nuw i64, ptr %keys.i.i.i, i64 %didx.i.i.i
  %cand_k.i.i.i = load i64, ptr %kp.i.i.i, align 8
  %eq.i.i.i = icmp eq i64 %cand_k.i.i.i, %t29.i
  br i1 %eq.i.i.i, label %found.i.i.i, label %mbit_cont.i.i.i

mbit_cont.i.i.i:                                  ; preds = %chk_key.i.i.i
  %mm1.i.i.i = add nsw i32 %mmask.i.i29.i, -1
  %mmask_next.i.i.i = and i32 %mm1.i.i.i, %mmask.i.i29.i
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
  %42 = call range(i16 0, 17) i16 @llvm.cttz.i16(i16 %abits16.i.i.i, i1 true)
  %atz64.i.i.i = zext nneg i16 %42 to i64
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

archx_dict_find_i64.exit.i:                       ; preds = %not_found_avail.i.i.i, %found.i.i.i, %for.body.5.i
  %common.ret.op.i.i.i123 = phi { i64, i64 } [ %f1.i.i.i, %found.i.i.i ], [ %nf1.i.i.i, %not_found_avail.i.i.i ], [ { i64 -1, i64 -1 }, %for.body.5.i ]
  %t33.i = extractvalue { i64, i64 } %common.ret.op.i.i.i123, 0
  %t35.i = icmp sgt i64 %t33.i, -1
  br i1 %t35.i, label %dpop.hit.8.i, label %dpop.miss.9.i

dpop.miss.9.i:                                    ; preds = %archx_dict_find_i64.exit.i
  call fastcc void @archx_key_fail()
  unreachable

dpop.hit.8.i:                                     ; preds = %archx_dict_find_i64.exit.i
  %t34.i = extractvalue { i64, i64 } %common.ret.op.i.i.i123, 1
  %t41.i = load ptr, ptr %t18.i, align 16
  %t42.i = getelementptr inbounds nuw i64, ptr %t41.i, i64 %t33.i
  %t43.i = load i64, ptr %t42.i, align 8
  %len.i.i = load i64, ptr %hp.i.i114, align 16
  %mask.i.i = load i64, ptr %mask_p.i.i.i, align 16
  %keys.i.i124 = load ptr, ptr %keys_p.i.i.i, align 8
  %meta.i.i = load i64, ptr %h_meta_gep.i.i, align 8
  %43 = getelementptr i8, ptr %ctrl.i.i.i, i64 %mask.i.i
  %idx_base.i.i = getelementptr i8, ptr %43, i64 17
  %sp_ip.i.i = getelementptr inbounds i32, ptr %idx_base.i.i, i64 %t34.i
  %d_idx32.i.i = load i32, ptr %sp_ip.i.i, align 4
  %d_idx.i.i = zext i32 %d_idx32.i.i to i64
  %p.i.i.i = getelementptr inbounds i8, ptr %ctrl.i.i.i, i64 %t34.i
  store i8 -2, ptr %p.i.i.i, align 1
  %mir.i.i.i = icmp ult i64 %t34.i, 16
  br i1 %mir.i.i.i, label %do_mir.i.i.i, label %archx_dict_set_ctrl.exit.i.i

do_mir.i.i.i:                                     ; preds = %dpop.hit.8.i
  %44 = getelementptr i8, ptr %43, i64 1
  %mp.i.i.i = getelementptr i8, ptr %44, i64 %t34.i
  store i8 -2, ptr %mp.i.i.i, align 1
  br label %archx_dict_set_ctrl.exit.i.i

archx_dict_set_ctrl.exit.i.i:                     ; preds = %do_mir.i.i.i, %dpop.hit.8.i
  %last.i.i = add i64 %len.i.i, -1
  store i64 %last.i.i, ptr %hp.i.i114, align 16
  %need_swap.i.i = icmp sgt i64 %last.i.i, %d_idx.i.i
  br i1 %need_swap.i.i, label %do_swap.i.i, label %archx_dict_erase_slot.exit.i

do_swap.i.i:                                      ; preds = %archx_dict_set_ctrl.exit.i.i
  %kind.i.i = and i64 %meta.i.i, 255
  %ksz_sh.i.i = lshr i64 %meta.i.i, 8
  %ksz.i.i = and i64 %ksz_sh.i.i, 16777215
  %kd_off.i.i = mul nuw nsw i64 %ksz.i.i, %d_idx.i.i
  %kl_off.i.i = mul i64 %ksz.i.i, %last.i.i
  %kd_p.i.i = getelementptr inbounds nuw i8, ptr %keys.i.i124, i64 %kd_off.i.i
  %kl_p.i.i = getelementptr inbounds i8, ptr %keys.i.i124, i64 %kl_off.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %kd_p.i.i, ptr nonnull align 1 %kl_p.i.i, i64 %ksz.i.i, i1 false)
  %has_v.not.i.i = icmp ult i64 %meta.i.i, 4294967296
  br i1 %has_v.not.i.i, label %fix_sparse.i.i, label %swap_v.i.i

swap_v.i.i:                                       ; preds = %do_swap.i.i
  %vsz.i.i = lshr i64 %meta.i.i, 32
  %vd_off.i.i = mul nuw i64 %vsz.i.i, %d_idx.i.i
  %vl_off.i.i = mul i64 %vsz.i.i, %last.i.i
  %vd_p.i.i = getelementptr inbounds i8, ptr %t41.i, i64 %vd_off.i.i
  %vl_p.i.i = getelementptr inbounds i8, ptr %t41.i, i64 %vl_off.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %vd_p.i.i, ptr nonnull align 1 %vl_p.i.i, i64 %vsz.i.i, i1 false)
  br label %fix_sparse.i.i

fix_sparse.i.i:                                   ; preds = %swap_v.i.i, %do_swap.i.i
  %h.i.i = call fastcc i64 @archx_dict_key_hash_at(ptr %keys.i.i124, i64 %d_idx.i.i, i64 %kind.i.i)
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
  %t44.i125 = add i64 %t43.i, %var.popped_sum.23.030.i
  %t46.i = add nuw nsw i64 %for.i.24.031.i, 4
  %t26.i126 = icmp samesign ult i64 %for.i.24.031.i, 32764
  br i1 %t26.i126, label %for.body.5.i, label %for.body.11.i

for.body.11.i:                                    ; preds = %archx_dict_erase_slot.exit.i, %for.body.11.i
  %for.j.47.032.i = phi i64 [ %t66.i, %for.body.11.i ], [ 0, %archx_dict_erase_slot.exit.i ]
  %t51.i = mul nuw nsw i64 %for.j.47.032.i, 13
  %t52.i127 = add nuw nsw i64 %t51.i, 1000000
  %t55.i128 = mul nuw nsw i64 %for.j.47.032.i, 5
  %t56.i129 = add nuw nsw i64 %t55.i128, 1
  %t57.i = call fastcc i64 @archx_dict_upsert_i64(i64 %htag.i.i, i64 %t52.i127)
  %t63.i = load ptr, ptr %t18.i, align 16
  %t64.i = getelementptr inbounds i64, ptr %t63.i, i64 %t57.i
  store i64 %t56.i129, ptr %t64.i, align 8
  %t66.i = add nuw nsw i64 %for.j.47.032.i, 1
  %exitcond41.not.i = icmp eq i64 %t66.i, 8192
  br i1 %exitcond41.not.i, label %dlen.load.15.i, label %for.body.11.i

dlen.load.15.i:                                   ; preds = %for.body.11.i
  %t72.i130 = load i64, ptr %hp.i.i114, align 16
  %t74.i = add i64 %t72.i130, %t44.i125
  %t8733.i = icmp sgt i64 %t72.i130, 0
  %t92.i = load ptr, ptr %keys_p.i.i.i, align 8
  %t93.i131 = load ptr, ptr %t18.i, align 16
  %xtraiter329 = and i64 %t72.i130, 1
  %45 = icmp eq i64 %t72.i130, 1
  %unroll_iter332 = and i64 %t72.i130, 9223372036854775806
  %lcmp.mod330.not = icmp eq i64 %xtraiter329, 0
  br label %dlen.load.22.i

dlen.load.22.i:                                   ; preds = %for.step.19.i, %dlen.load.15.i
  %for._pass.76.037.i = phi i64 [ 0, %dlen.load.15.i ], [ %t105.i132, %for.step.19.i ]
  %var.int_checksum.75.036.i = phi i64 [ %t74.i, %dlen.load.15.i ], [ %var.int_checksum.75.1.lcssa.i, %for.step.19.i ]
  br i1 %t8733.i, label %foritems.body.25.i.preheader, label %for.step.19.i

foritems.body.25.i.preheader:                     ; preds = %dlen.load.22.i
  br i1 %45, label %for.step.19.i.loopexit.unr-lcssa, label %foritems.body.25.i

foritems.body.25.i:                               ; preds = %foritems.body.25.i.preheader, %foritems.body.25.i
  %foritems.idx.85.035.i = phi i64 [ %t103.i.1, %foritems.body.25.i ], [ 0, %foritems.body.25.i.preheader ]
  %var.int_checksum.75.134.i = phi i64 [ %t101.i.1, %foritems.body.25.i ], [ %var.int_checksum.75.036.i, %foritems.body.25.i.preheader ]
  %niter333 = phi i64 [ %niter333.next.1, %foritems.body.25.i ], [ 0, %foritems.body.25.i.preheader ]
  %t94.i = getelementptr inbounds nuw i64, ptr %t92.i, i64 %foritems.idx.85.035.i
  %t95.i = load i64, ptr %t94.i, align 8
  %t96.i = getelementptr inbounds nuw i64, ptr %t93.i131, i64 %foritems.idx.85.035.i
  %t97.i = load i64, ptr %t96.i, align 8
  %t99.i = srem i64 %t95.i, 997
  %t100.i = mul i64 %t99.i, %t97.i
  %t101.i = add i64 %t100.i, %var.int_checksum.75.134.i
  %t103.i = or disjoint i64 %foritems.idx.85.035.i, 1
  %t94.i.1 = getelementptr inbounds nuw i64, ptr %t92.i, i64 %t103.i
  %t95.i.1 = load i64, ptr %t94.i.1, align 8
  %t96.i.1 = getelementptr inbounds nuw i64, ptr %t93.i131, i64 %t103.i
  %t97.i.1 = load i64, ptr %t96.i.1, align 8
  %t99.i.1 = srem i64 %t95.i.1, 997
  %t100.i.1 = mul i64 %t99.i.1, %t97.i.1
  %t101.i.1 = add i64 %t100.i.1, %t101.i
  %t103.i.1 = add nuw nsw i64 %foritems.idx.85.035.i, 2
  %niter333.next.1 = add i64 %niter333, 2
  %niter333.ncmp.1 = icmp eq i64 %niter333.next.1, %unroll_iter332
  br i1 %niter333.ncmp.1, label %for.step.19.i.loopexit.unr-lcssa, label %foritems.body.25.i

for.step.19.i.loopexit.unr-lcssa:                 ; preds = %foritems.body.25.i, %foritems.body.25.i.preheader
  %t101.i.lcssa.ph = phi i64 [ poison, %foritems.body.25.i.preheader ], [ %t101.i.1, %foritems.body.25.i ]
  %foritems.idx.85.035.i.unr = phi i64 [ 0, %foritems.body.25.i.preheader ], [ %t103.i.1, %foritems.body.25.i ]
  %var.int_checksum.75.134.i.unr = phi i64 [ %var.int_checksum.75.036.i, %foritems.body.25.i.preheader ], [ %t101.i.1, %foritems.body.25.i ]
  br i1 %lcmp.mod330.not, label %for.step.19.i, label %foritems.body.25.i.epil

foritems.body.25.i.epil:                          ; preds = %for.step.19.i.loopexit.unr-lcssa
  %t94.i.epil = getelementptr inbounds nuw i64, ptr %t92.i, i64 %foritems.idx.85.035.i.unr
  %t95.i.epil = load i64, ptr %t94.i.epil, align 8
  %t96.i.epil = getelementptr inbounds nuw i64, ptr %t93.i131, i64 %foritems.idx.85.035.i.unr
  %t97.i.epil = load i64, ptr %t96.i.epil, align 8
  %t99.i.epil = srem i64 %t95.i.epil, 997
  %t100.i.epil = mul i64 %t99.i.epil, %t97.i.epil
  %t101.i.epil = add i64 %t100.i.epil, %var.int_checksum.75.134.i.unr
  br label %for.step.19.i

for.step.19.i:                                    ; preds = %foritems.body.25.i.epil, %for.step.19.i.loopexit.unr-lcssa, %dlen.load.22.i
  %var.int_checksum.75.1.lcssa.i = phi i64 [ %var.int_checksum.75.036.i, %dlen.load.22.i ], [ %t101.i.lcssa.ph, %for.step.19.i.loopexit.unr-lcssa ], [ %t101.i.epil, %foritems.body.25.i.epil ]
  %t105.i132 = add nuw nsw i64 %for._pass.76.037.i, 1
  %exitcond43.not.i = icmp eq i64 %t105.i132, 40
  br i1 %exitcond43.not.i, label %archx_fn_run_int_bench.exit, label %dlen.load.22.i

archx_fn_run_int_bench.exit:                      ; preds = %for.step.19.i
  %ctrl.i23.i = load ptr, ptr %ctrl_p.i.i.i, align 16
  call void @free(ptr %ctrl.i23.i)
  call void @free(ptr %t92.i)
  call void @free(ptr %t93.i131)
  call void @free(ptr %hp.i.i114)
  %t106 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %var.int_checksum.75.1.lcssa.i)
  br label %loop.i

loop.i:                                           ; preds = %archx_fn_run_int_bench.exit, %archx_str_drop.exit.i143
  %i.i = phi i64 [ %inext.i, %archx_str_drop.exit.i143 ], [ 0, %archx_fn_run_int_bench.exit ]
  %ep.i = getelementptr inbounds nuw %ArchxStr, ptr %var.vocab.4.sroa.26.3, i64 %i.i
  %t0.unpack.i = load i64, ptr %ep.i, align 8
  %t0.elt1.i = getelementptr inbounds nuw i8, ptr %ep.i, i64 8
  %t0.unpack2.i = load i64, ptr %t0.elt1.i, align 8
  %len.i.i136 = and i64 %t0.unpack.i, 4294967295
  %long.i.i = icmp samesign ult i64 %len.i.i136, 13
  %tag.i.i137 = and i64 %t0.unpack2.i, 1
  %owned.not.i.i138 = icmp eq i64 %tag.i.i137, 0
  %or.cond.i139 = select i1 %long.i.i, i1 true, i1 %owned.not.i.i138
  br i1 %or.cond.i139, label %archx_str_drop.exit.i143, label %do_free.i.i140

do_free.i.i140:                                   ; preds = %loop.i
  %raw.i.i141 = and i64 %t0.unpack2.i, -2
  %ptr.i.i142 = inttoptr i64 %raw.i.i141 to ptr
  call void @free(ptr %ptr.i.i142)
  br label %archx_str_drop.exit.i143

archx_str_drop.exit.i143:                         ; preds = %do_free.i.i140, %loop.i
  %inext.i = add nuw nsw i64 %i.i, 1
  %exitcond.not.i144 = icmp eq i64 %i.i, 1023
  br i1 %exitcond.not.i144, label %check.free.i, label %loop.i

check.free.i:                                     ; preds = %archx_str_drop.exit.i143
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

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #3

; Function Attrs: nofree nounwind
declare noundef i32 @sprintf(ptr noalias noundef writeonly captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #4

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_key_fail() unnamed_addr #3 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.1)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, inaccessiblemem: none)
define private fastcc i64 @archx_dict_key_hash_at(ptr readonly captures(none) %keys, i64 %idx, i64 range(i64 0, 256) %kind) unnamed_addr #11 {
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
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol, !llvm.loop !7

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
  br i1 %prol.iter.cmp.not, label %l_tail_body.i.prol.loopexit, label %l_tail_body.i.prol, !llvm.loop !8

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
declare i32 @llvm.cttz.i32(i32, i1 immarg) #12

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

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v2i64(<2 x i64>) #13

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
attributes #11 = { nofree norecurse nosync nounwind memory(read, inaccessiblemem: none) }
attributes #12 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #13 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #14 = { nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #15 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!0 = distinct !{!0, !1}
!1 = !{!"llvm.loop.unroll.disable"}
!2 = distinct !{!2, !1}
!3 = distinct !{!3, !4, !5}
!4 = !{!"llvm.loop.isvectorized", i32 1}
!5 = !{!"llvm.loop.unroll.runtime.disable"}
!6 = distinct !{!6, !5, !4}
!7 = distinct !{!7, !1}
!8 = distinct !{!8, !1}
