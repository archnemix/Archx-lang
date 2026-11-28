; ModuleID = '/tmp/bench_arrays.ll'
source_filename = "/tmp/bench_arrays.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@str = private unnamed_addr constant [38 x i8] c"archx runtime panic: integer overflow\00", align 1
@str.1 = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %t3.i = tail call noalias align 16 dereferenceable_or_null(8000000) ptr @calloc(i64 1000000, i64 8)
  %t4.i = icmp eq ptr %t3.i, null
  br i1 %t4.i, label %calloc.oom.3.i, label %calloc.ok.2.i

calloc.oom.3.i:                                   ; preds = %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.2.i:                                    ; preds = %entry
  %t12.i = tail call noalias align 16 dereferenceable_or_null(8000000) ptr @calloc(i64 1000000, i64 8)
  %t13.i = icmp eq ptr %t12.i, null
  br i1 %t13.i, label %calloc.oom.7.i, label %calloc.ok.6.i

calloc.oom.7.i:                                   ; preds = %calloc.ok.2.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.6.i:                                    ; preds = %calloc.ok.2.i
  %t21.i = tail call noalias align 16 dereferenceable_or_null(8000000) ptr @calloc(i64 1000000, i64 8)
  %t22.i = icmp eq ptr %t21.i, null
  br i1 %t22.i, label %calloc.oom.11.i, label %for.body.13.i

calloc.oom.11.i:                                  ; preds = %calloc.ok.6.i
  tail call fastcc void @archx_oom_fail()
  unreachable

for.body.13.i:                                    ; preds = %calloc.ok.6.i, %for.body.13.i
  %for.i.27.018.i = phi i64 [ %t78.i, %for.body.13.i ], [ 0, %calloc.ok.6.i ]
  %t33.i = getelementptr inbounds nuw i64, ptr %t3.i, i64 %for.i.27.018.i
  %0 = trunc nuw nsw i64 %for.i.27.018.i to i32
  %1 = mul nuw nsw i32 %0, 7
  %t46.lhs.trunc.i = add nuw nsw i32 %1, 3
  %t4610.i = urem i32 %t46.lhs.trunc.i, 1000
  %t46.zext.i = zext nneg i32 %t4610.i to i64
  store i64 %t46.zext.i, ptr %t33.i, align 8
  %t56.i = getelementptr inbounds nuw i64, ptr %t12.i, i64 %for.i.27.018.i
  %2 = mul nuw nsw i32 %0, 13
  %t69.lhs.trunc.i = add nuw nsw i32 %2, 5
  %t6911.i = urem i32 %t69.lhs.trunc.i, 1000
  %t69.zext.i = zext nneg i32 %t6911.i to i64
  store i64 %t69.zext.i, ptr %t56.i, align 8
  %t78.i = add nuw nsw i64 %for.i.27.018.i, 1
  %exitcond.not.i = icmp eq i64 %t78.i, 1000000
  br i1 %exitcond.not.i, label %for.fast.body.1.i.preheader.i, label %for.body.13.i

for.fast.body.1.i.preheader.i:                    ; preds = %for.body.13.i, %mod.ok.47.i
  %for.r.80.020.i = phi i64 [ %t136.i, %mod.ok.47.i ], [ 0, %for.body.13.i ]
  %var.checksum.79.019.i = phi i64 [ %t134.i, %mod.ok.47.i ], [ 0, %for.body.13.i ]
  br label %for.fast.body.1.i.i

for.fast.body.1.i.i:                              ; preds = %overflow.ok.12.i.i, %for.fast.body.1.i.preheader.i
  %for.i.1.09.i.i = phi i64 [ %t31.i.i, %overflow.ok.12.i.i ], [ 0, %for.fast.body.1.i.preheader.i ]
  %t12.i.i = getelementptr inbounds nuw i64, ptr %t21.i, i64 %for.i.1.09.i.i
  %t15.i.i = getelementptr inbounds nuw i64, ptr %t3.i, i64 %for.i.1.09.i.i
  %t16.i.i = load i64, ptr %t15.i.i, align 8
  %t17.i.i = tail call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t16.i.i, i64 3)
  %t19.i.i = extractvalue { i64, i1 } %t17.i.i, 1
  br i1 %t19.i.i, label %overflow.mul.7.i.i, label %overflow.ok.8.i.i

overflow.mul.7.i.i:                               ; preds = %for.fast.body.1.i.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.8.i.i:                                ; preds = %for.fast.body.1.i.i
  %t18.i.i = extractvalue { i64, i1 } %t17.i.i, 0
  %t22.i.i = getelementptr inbounds nuw i64, ptr %t12.i, i64 %for.i.1.09.i.i
  %t23.i.i = load i64, ptr %t22.i.i, align 8
  %t24.i.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t18.i.i, i64 %t23.i.i)
  %t26.i.i = extractvalue { i64, i1 } %t24.i.i, 1
  br i1 %t26.i.i, label %overflow.add.9.i.i, label %overflow.ok.10.i.i

overflow.add.9.i.i:                               ; preds = %overflow.ok.8.i.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.10.i.i:                               ; preds = %overflow.ok.8.i.i
  %t25.i.i = extractvalue { i64, i1 } %t24.i.i, 0
  %t27.i.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t25.i.i, i64 range(i64 -9223372036854775808, 60) %for.r.80.020.i)
  %t29.i.i = extractvalue { i64, i1 } %t27.i.i, 1
  br i1 %t29.i.i, label %overflow.add.11.i.i, label %overflow.ok.12.i.i

overflow.add.11.i.i:                              ; preds = %overflow.ok.10.i.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.12.i.i:                               ; preds = %overflow.ok.10.i.i
  %t28.i.i = extractvalue { i64, i1 } %t27.i.i, 0
  store i64 %t28.i.i, ptr %t12.i.i, align 8
  %t31.i.i = add nuw nsw i64 %for.i.1.09.i.i, 1
  %exitcond.not.i.i = icmp eq i64 %t31.i.i, 1000000
  br i1 %exitcond.not.i.i, label %archx_fn_vec_step.exit.i, label %for.fast.body.1.i.i

archx_fn_vec_step.exit.i:                         ; preds = %overflow.ok.12.i.i
  %t103.i = getelementptr inbounds nuw i64, ptr %t21.i, i64 %for.r.80.020.i
  %t104.i = load i64, ptr %t103.i, align 8
  %t105.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.checksum.79.019.i, i64 %t104.i)
  %t107.i = extractvalue { i64, i1 } %t105.i, 1
  br i1 %t107.i, label %overflow.add.36.i, label %overflow.ok.39.i

overflow.add.36.i:                                ; preds = %archx_fn_vec_step.exit.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.39.i:                                 ; preds = %archx_fn_vec_step.exit.i
  %t106.i = extractvalue { i64, i1 } %t105.i, 0
  %t111.i = sub nuw nsw i64 999999, %for.r.80.020.i
  %t117.i = getelementptr inbounds nuw i64, ptr %t21.i, i64 %t111.i
  %t118.i = load i64, ptr %t117.i, align 8
  %t119.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t106.i, i64 %t118.i)
  %t121.i = extractvalue { i64, i1 } %t119.i, 1
  br i1 %t121.i, label %overflow.add.44.i, label %mod.ok.47.i

overflow.add.44.i:                                ; preds = %overflow.ok.39.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

mod.ok.47.i:                                      ; preds = %overflow.ok.39.i
  %t120.i = extractvalue { i64, i1 } %t119.i, 0
  %t127.i = srem i64 %t120.i, 1000000007
  %t129.i = icmp slt i64 %t127.i, 0
  %t133.i = select i1 %t129.i, i64 1000000007, i64 0
  %t134.i = add nsw i64 %t133.i, %t127.i
  %t136.i = add nuw nsw i64 %for.r.80.020.i, 1
  %exitcond23.not.i = icmp eq i64 %t136.i, 60
  br i1 %exitcond23.not.i, label %for.body.49.i, label %for.fast.body.1.i.preheader.i

for.body.49.i:                                    ; preds = %mod.ok.47.i, %mod.ok.55.i
  %for.i.139.022.i = phi i64 [ %t165.i, %mod.ok.55.i ], [ 0, %mod.ok.47.i ]
  %var.total.138.021.i = phi i64 [ %t163.i, %mod.ok.55.i ], [ %t134.i, %mod.ok.47.i ]
  %t146.i = getelementptr inbounds nuw i64, ptr %t21.i, i64 %for.i.139.022.i
  %t147.i = load i64, ptr %t146.i, align 8
  %t148.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.total.138.021.i, i64 %t147.i)
  %t150.i = extractvalue { i64, i1 } %t148.i, 1
  br i1 %t150.i, label %overflow.add.52.i, label %mod.ok.55.i

overflow.add.52.i:                                ; preds = %for.body.49.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

mod.ok.55.i:                                      ; preds = %for.body.49.i
  %t149.i = extractvalue { i64, i1 } %t148.i, 0
  %t156.i = srem i64 %t149.i, 1000000007
  %t158.i = icmp slt i64 %t156.i, 0
  %t162.i = select i1 %t158.i, i64 1000000007, i64 0
  %t163.i = add nsw i64 %t162.i, %t156.i
  %t165.i = add nuw nsw i64 %for.i.139.022.i, 1
  %exitcond24.not.i = icmp eq i64 %t165.i, 1000000
  br i1 %exitcond24.not.i, label %archx_fn_vec_kernel.exit, label %for.body.49.i

archx_fn_vec_kernel.exit:                         ; preds = %mod.ok.55.i
  tail call void @free(ptr nonnull %t21.i)
  tail call void @free(ptr %t12.i)
  tail call void @free(ptr %t3.i)
  %t1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %t163.i)
  %t3.i1 = tail call noalias align 16 dereferenceable_or_null(5000000) ptr @malloc(i64 5000000)
  %t4.i2 = icmp eq ptr %t3.i1, null
  br i1 %t4.i2, label %alloc.oom.3.i, label %alloc.ok.2.i

alloc.oom.3.i:                                    ; preds = %archx_fn_vec_kernel.exit
  tail call fastcc void @archx_oom_fail()
  unreachable

alloc.ok.2.i:                                     ; preds = %archx_fn_vec_kernel.exit
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(5000000) %t3.i1, i8 1, i64 5000000, i1 false)
  store i8 0, ptr %t3.i1, align 16
  %t18.i = getelementptr inbounds nuw i8, ptr %t3.i1, i64 1
  store i8 0, ptr %t18.i, align 1
  br label %idx.ok.13.i

idx.ok.13.i:                                      ; preds = %overflow.ok.32.i.1, %alloc.ok.2.i
  %var.p.20.022.i5 = phi i64 [ 2, %alloc.ok.2.i ], [ %t73.i.1, %overflow.ok.32.i.1 ]
  %t2424.i4 = phi i64 [ 4, %alloc.ok.2.i ], [ %t23.i.1, %overflow.ok.32.i.1 ]
  %t31.i = getelementptr inbounds nuw i8, ptr %t3.i1, i64 %var.p.20.022.i5
  %t32.i = load i8, ptr %t31.i, align 2
  %t33.i3 = trunc i8 %t32.i to i1
  br i1 %t33.i3, label %while.fast.body.21.i, label %overflow.ok.32.i

while.fast.body.21.i:                             ; preds = %idx.ok.13.i, %while.fast.body.21.i
  %var.j.39.021.i = phi i64 [ %t57.i, %while.fast.body.21.i ], [ %t2424.i4, %idx.ok.13.i ]
  %t52.i = getelementptr inbounds nuw i8, ptr %t3.i1, i64 %var.j.39.021.i
  store i8 0, ptr %t52.i, align 1
  %t57.i = add nuw nsw i64 %var.j.39.021.i, %var.p.20.022.i5
  %t49.i = icmp samesign ult i64 %t57.i, 5000000
  br i1 %t49.i, label %while.fast.body.21.i, label %overflow.ok.32.i

overflow.ok.32.i:                                 ; preds = %while.fast.body.21.i, %idx.ok.13.i
  %t73.i = or disjoint i64 %var.p.20.022.i5, 1
  %t23.i = mul nuw nsw i64 %t73.i, %t73.i
  %exitcond.not = icmp eq i64 %var.p.20.022.i5, 2236
  br i1 %exitcond.not, label %for.body.34.i.preheader, label %idx.ok.13.i.1

idx.ok.13.i.1:                                    ; preds = %overflow.ok.32.i
  %t31.i.1 = getelementptr inbounds nuw i8, ptr %t3.i1, i64 %t73.i
  %t32.i.1 = load i8, ptr %t31.i.1, align 1
  %t33.i3.1 = trunc i8 %t32.i.1 to i1
  br i1 %t33.i3.1, label %while.fast.body.21.i.1, label %overflow.ok.32.i.1

while.fast.body.21.i.1:                           ; preds = %idx.ok.13.i.1, %while.fast.body.21.i.1
  %var.j.39.021.i.1 = phi i64 [ %t57.i.1, %while.fast.body.21.i.1 ], [ %t23.i, %idx.ok.13.i.1 ]
  %t52.i.1 = getelementptr inbounds nuw i8, ptr %t3.i1, i64 %var.j.39.021.i.1
  store i8 0, ptr %t52.i.1, align 1
  %t57.i.1 = add nuw nsw i64 %var.j.39.021.i.1, %t73.i
  %t49.i.1 = icmp samesign ult i64 %t57.i.1, 5000000
  br i1 %t49.i.1, label %while.fast.body.21.i.1, label %overflow.ok.32.i.1

overflow.ok.32.i.1:                               ; preds = %while.fast.body.21.i.1, %idx.ok.13.i.1
  %t73.i.1 = add nuw nsw i64 %var.p.20.022.i5, 2
  %t23.i.1 = mul nuw nsw i64 %t73.i.1, %t73.i.1
  br label %idx.ok.13.i

for.body.34.i.preheader:                          ; preds = %overflow.ok.32.i
  %invariant.gep = getelementptr inbounds i8, ptr %t3.i1, i64 1
  br label %for.body.34.i

for.body.34.i:                                    ; preds = %for.step.35.i.1, %for.body.34.i.preheader
  %for.i.77.026.i = phi i64 [ 2, %for.body.34.i.preheader ], [ %t91.i.1, %for.step.35.i.1 ]
  %var.count.76.025.i = phi i64 [ 0, %for.body.34.i.preheader ], [ %var.count.76.1.i.1, %for.step.35.i.1 ]
  %t83.i = getelementptr inbounds nuw i8, ptr %t3.i1, i64 %for.i.77.026.i
  %t84.i = load i8, ptr %t83.i, align 2
  %t85.i = trunc i8 %t84.i to i1
  br i1 %t85.i, label %if.then.37.i, label %for.step.35.i

if.then.37.i:                                     ; preds = %for.body.34.i
  %t87.i = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.count.76.025.i, i64 1)
  %t89.i = extractvalue { i64, i1 } %t87.i, 1
  br i1 %t89.i, label %overflow.add.40.i, label %overflow.ok.41.i

overflow.add.40.i:                                ; preds = %if.then.37.i.1, %if.then.37.i
  tail call fastcc void @archx_int_overflow_fail()
  unreachable

overflow.ok.41.i:                                 ; preds = %if.then.37.i
  %t88.i = extractvalue { i64, i1 } %t87.i, 0
  br label %for.step.35.i

for.step.35.i:                                    ; preds = %overflow.ok.41.i, %for.body.34.i
  %var.count.76.1.i = phi i64 [ %t88.i, %overflow.ok.41.i ], [ %var.count.76.025.i, %for.body.34.i ]
  %gep = getelementptr inbounds i8, ptr %invariant.gep, i64 %for.i.77.026.i
  %t84.i.1 = load i8, ptr %gep, align 1
  %t85.i.1 = trunc i8 %t84.i.1 to i1
  br i1 %t85.i.1, label %if.then.37.i.1, label %for.step.35.i.1

if.then.37.i.1:                                   ; preds = %for.step.35.i
  %t87.i.1 = tail call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %var.count.76.1.i, i64 1)
  %t89.i.1 = extractvalue { i64, i1 } %t87.i.1, 1
  br i1 %t89.i.1, label %overflow.add.40.i, label %overflow.ok.41.i.1

overflow.ok.41.i.1:                               ; preds = %if.then.37.i.1
  %t88.i.1 = extractvalue { i64, i1 } %t87.i.1, 0
  br label %for.step.35.i.1

for.step.35.i.1:                                  ; preds = %overflow.ok.41.i.1, %for.step.35.i
  %var.count.76.1.i.1 = phi i64 [ %t88.i.1, %overflow.ok.41.i.1 ], [ %var.count.76.1.i, %for.step.35.i ]
  %t91.i.1 = add nuw nsw i64 %for.i.77.026.i, 2
  %exitcond29.not.i.1 = icmp eq i64 %t91.i.1, 5000000
  br i1 %exitcond29.not.i.1, label %archx_fn_sieve_count.exit, label %for.body.34.i

archx_fn_sieve_count.exit:                        ; preds = %for.step.35.i.1
  tail call void @free(ptr nonnull %t3.i1)
  %t3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %var.count.76.1.i.1)
  ret i32 0
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_int_overflow_fail() unnamed_addr #1 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str)
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

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #4

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #5

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #6

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) #7

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) #7

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #1

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #2

attributes #0 = { nounwind }
attributes #1 = { cold nofree noreturn nounwind }
attributes #2 = { nofree nounwind }
attributes #3 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #4 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #5 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #6 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #7 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
