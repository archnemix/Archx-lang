; ModuleID = 'ci/out/arrays.ll'
source_filename = "arrays.archx.lang"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.fmt.int.elem = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.fmt.sep = private unnamed_addr constant [3 x i8] c", \00", align 1
@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@str.1 = private unnamed_addr constant [2 x i8] c"]\00", align 1
@str.3 = private unnamed_addr constant [38 x i8] c"archx runtime panic: integer overflow\00", align 1
@str.4 = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
push.grow.from_heap.22.peel:
  %tmp.i = alloca [12 x i8], align 4
  %putchar = tail call i32 @putchar(i32 91)
  %t26 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 10)
  %t23.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t26.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 25)
  %t23.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t26.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 30)
  %t23.3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t26.3 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 40)
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.1)
  %t29 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 4)
  %malloc = tail call dereferenceable_or_null(32) ptr @malloc(i64 32)
  %t74.peel = icmp eq ptr %malloc, null
  br i1 %t74.peel, label %realloc.oom.30, label %for.body.10.peel.next

for.body.10.peel.next:                            ; preds = %push.grow.from_heap.22.peel
  store i64 10, ptr %malloc, align 8
  %t80 = getelementptr inbounds nuw i8, ptr %malloc, i64 8
  store i64 20, ptr %t80, align 8
  %t80.1 = getelementptr inbounds nuw i8, ptr %malloc, i64 16
  store i64 30, ptr %t80.1, align 8
  %t80.2 = getelementptr inbounds nuw i8, ptr %malloc, i64 24
  store i64 40, ptr %t80.2, align 8
  %t93 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 40)
  %putchar14 = tail call i32 @putchar(i32 91)
  %t104.pre = load i64, ptr %malloc, align 8
  %t105 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t104.pre)
  %t102.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t103.1 = getelementptr inbounds nuw i8, ptr %malloc, i64 8
  %t104.1 = load i64, ptr %t103.1, align 8
  %t105.1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t104.1)
  %t102.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.sep)
  %t103.2 = getelementptr inbounds nuw i8, ptr %malloc, i64 16
  %t104.2 = load i64, ptr %t103.2, align 8
  %t105.2 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int.elem, i64 %t104.2)
  %puts15 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.1)
  %t127 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 300)
  %t3.i = tail call noalias align 16 dereferenceable_or_null(100) ptr @malloc(i64 100)
  %t4.i = icmp eq ptr %t3.i, null
  br i1 %t4.i, label %alloc.oom.3.i, label %for.body.34.preheader.i

realloc.oom.30:                                   ; preds = %push.grow.from_heap.22.peel
  tail call fastcc void @archx_oom_fail()
  unreachable

alloc.oom.3.i:                                    ; preds = %for.body.10.peel.next
  tail call fastcc void @archx_oom_fail()
  unreachable

for.body.34.preheader.i:                          ; preds = %for.body.10.peel.next
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(100) %t3.i, i8 1, i64 100, i1 false)
  store i8 0, ptr %t3.i, align 16
  %t18.i17 = getelementptr inbounds nuw i8, ptr %t3.i, i64 1
  store i8 0, ptr %t18.i17, align 1
  %t52.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 4
  store i8 0, ptr %t52.i, align 4
  %t52.129.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 6
  store i8 0, ptr %t52.129.i, align 2
  %t52.231.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 8
  store i8 0, ptr %t52.231.i, align 8
  %t52.333.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 10
  store i8 0, ptr %t52.333.i, align 2
  %t52.537.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 14
  store i8 0, ptr %t52.537.i, align 2
  %t52.639.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 16
  store i8 0, ptr %t52.639.i, align 16
  %t52.844.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 20
  store i8 0, ptr %t52.844.i, align 4
  %t52.9.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 22
  store i8 0, ptr %t52.9.i, align 2
  %t52.10.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 24
  %t52.13.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 30
  %t52.14.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 32
  %t52.17.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 38
  %t52.20.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 44
  %t52.22.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 48
  %t52.25.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 54
  %t52.28.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 60
  %t52.29.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 62
  %t52.32.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 68
  %t52.35.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 74
  %t52.38.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 80
  %t52.40.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 84
  %t52.43.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 90
  %t52.47.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 98
  %t52.1.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 9
  store i8 0, ptr %t52.1.i, align 1
  %t52.1.1.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 12
  store i8 0, ptr %t52.1.1.i, align 4
  %t52.1.2.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 15
  store i8 0, ptr %t52.1.2.i, align 1
  %t52.1.3.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 18
  store i8 0, ptr %t52.1.3.i, align 2
  %t52.1.4.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 21
  store i8 0, ptr %t52.1.4.i, align 1
  %t52.1.11.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 42
  store i8 0, ptr %t52.1.11.i, align 2
  %t52.1.21.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 72
  store i8 0, ptr %t52.1.21.i, align 8
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(5) %t52.10.i, i8 0, i64 5, i1 false)
  store i8 0, ptr %t52.13.i, align 2
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(5) %t52.14.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(3) %t52.17.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(3) %t52.20.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(5) %t52.22.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(5) %t52.25.i, i8 0, i64 5, i1 false)
  store i8 0, ptr %t52.28.i, align 4
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(5) %t52.29.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(3) %t52.32.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(5) %t52.35.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(3) %t52.38.i, i8 0, i64 3, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(5) %t52.40.i, i8 0, i64 5, i1 false)
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 2 dereferenceable(7) %t52.43.i, i8 0, i64 7, i1 false)
  store i16 0, ptr %t52.47.i, align 2
  %invariant.gep = getelementptr inbounds i8, ptr %t3.i, i64 1
  br label %for.body.34.i

for.body.34.i:                                    ; preds = %for.step.35.i.1, %for.body.34.preheader.i
  %for.i.77.026.i = phi i64 [ 2, %for.body.34.preheader.i ], [ %t91.i.1, %for.step.35.i.1 ]
  %var.count.76.025.i = phi i64 [ 0, %for.body.34.preheader.i ], [ %var.count.76.1.i.1, %for.step.35.i.1 ]
  %t83.i = getelementptr inbounds nuw i8, ptr %t3.i, i64 %for.i.77.026.i
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
  %exitcond.not.i.1 = icmp eq i64 %t91.i.1, 100
  br i1 %exitcond.not.i.1, label %archx_fn_sieve_count.exit, label %for.body.34.i

archx_fn_sieve_count.exit:                        ; preds = %for.step.35.i.1
  tail call void @free(ptr nonnull %t3.i)
  %t135 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %var.count.76.1.i.1)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  store i32 66, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 0, ptr %tmp4.i, align 4
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 1, ptr nonnull %tmp.i)
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %puts16 = call i32 @puts(ptr nonnull dereferenceable(1) @.str.true)
  %t143 = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 5)
  call void @free(ptr %malloc)
  ret i32 0
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_int_overflow_fail() unnamed_addr #1 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.3)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_oom_fail() unnamed_addr #1 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str.4)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #2

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #4

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #5

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) #6

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #2

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #1

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #7

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #7

attributes #0 = { nounwind }
attributes #1 = { cold nofree noreturn nounwind }
attributes #2 = { nofree nounwind }
attributes #3 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #4 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #5 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #6 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
