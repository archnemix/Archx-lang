; ModuleID = 'ci/out/structs_regions.ll'
source_filename = "ci/out/structs_regions.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxStr = type { i64, i64 }

@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@str = private unnamed_addr constant [35 x i8] c"archx runtime panic: out of memory\00", align 1

; Function Attrs: nounwind
define noundef i32 @main() local_unnamed_addr #0 {
entry:
  %tmp.i = alloca [12 x i8], align 4
  %func.region.i = alloca %ArchxRegion, align 8
  %t3.i = tail call noalias align 16 dereferenceable_or_null(256) ptr @calloc(i64 32, i64 8)
  %t4.i = icmp eq ptr %t3.i, null
  br i1 %t4.i, label %calloc.oom.3.i, label %calloc.ok.2.i

calloc.oom.3.i:                                   ; preds = %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.2.i:                                    ; preds = %entry
  %t7.i = tail call noalias align 16 dereferenceable_or_null(256) ptr @calloc(i64 32, i64 8)
  %t8.i = icmp eq ptr %t7.i, null
  br i1 %t8.i, label %calloc.oom.5.i, label %calloc.ok.4.i

calloc.oom.5.i:                                   ; preds = %calloc.ok.2.i
  tail call fastcc void @archx_oom_fail()
  unreachable

calloc.ok.4.i:                                    ; preds = %calloc.ok.2.i
  %t12.i = tail call noalias align 16 dereferenceable_or_null(256) ptr @malloc(i64 256)
  %t13.i = icmp eq ptr %t12.i, null
  br i1 %t13.i, label %alloc.oom.7.i, label %fill.body.9.preheader.i

fill.body.9.preheader.i:                          ; preds = %calloc.ok.4.i
  store <4 x i64> splat (i64 1), ptr %t12.i, align 16
  %t17.4.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 32
  store <4 x i64> splat (i64 1), ptr %t17.4.i, align 16
  %t17.8.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 64
  store <4 x i64> splat (i64 1), ptr %t17.8.i, align 16
  %t17.12.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 96
  store <4 x i64> splat (i64 1), ptr %t17.12.i, align 16
  %t17.16.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 128
  store <4 x i64> splat (i64 1), ptr %t17.16.i, align 16
  %t17.20.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 160
  store <4 x i64> splat (i64 1), ptr %t17.20.i, align 16
  %t17.24.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 192
  store <4 x i64> splat (i64 1), ptr %t17.24.i, align 16
  %t17.28.i = getelementptr inbounds nuw i8, ptr %t12.i, i64 224
  store <4 x i64> splat (i64 1), ptr %t17.28.i, align 16
  %t22.i = tail call noalias align 16 dereferenceable_or_null(256) ptr @malloc(i64 256)
  %t23.i = icmp eq ptr %t22.i, null
  br i1 %t23.i, label %alloc.oom.12.i, label %fill.body.14.preheader.i

alloc.oom.7.i:                                    ; preds = %calloc.ok.4.i
  tail call fastcc void @archx_oom_fail()
  unreachable

fill.body.14.preheader.i:                         ; preds = %fill.body.9.preheader.i
  store <4 x i64> splat (i64 2), ptr %t22.i, align 16
  %t27.4.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 32
  store <4 x i64> splat (i64 2), ptr %t27.4.i, align 16
  %t27.8.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 64
  store <4 x i64> splat (i64 2), ptr %t27.8.i, align 16
  %t27.12.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 96
  store <4 x i64> splat (i64 2), ptr %t27.12.i, align 16
  %t27.16.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 128
  store <4 x i64> splat (i64 2), ptr %t27.16.i, align 16
  %t27.20.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 160
  store <4 x i64> splat (i64 2), ptr %t27.20.i, align 16
  %t27.24.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 192
  store <4 x i64> splat (i64 2), ptr %t27.24.i, align 16
  %t27.28.i = getelementptr inbounds nuw i8, ptr %t22.i, i64 224
  store <4 x i64> splat (i64 2), ptr %t27.28.i, align 16
  %0 = getelementptr inbounds nuw i8, ptr %t3.i, i64 16
  store <2 x i64> <i64 0, i64 2>, ptr %t3.i, align 16
  store <2 x i64> <i64 4, i64 6>, ptr %0, align 16
  %1 = getelementptr inbounds nuw i8, ptr %t7.i, i64 16
  store <2 x i64> <i64 0, i64 3>, ptr %t7.i, align 16
  store <2 x i64> <i64 6, i64 9>, ptr %1, align 16
  %2 = getelementptr inbounds nuw i8, ptr %t3.i, i64 32
  %3 = getelementptr inbounds nuw i8, ptr %t3.i, i64 48
  store <2 x i64> <i64 8, i64 10>, ptr %2, align 16
  store <2 x i64> <i64 12, i64 14>, ptr %3, align 16
  %4 = getelementptr inbounds nuw i8, ptr %t7.i, i64 32
  %5 = getelementptr inbounds nuw i8, ptr %t7.i, i64 48
  store <2 x i64> <i64 12, i64 15>, ptr %4, align 16
  store <2 x i64> <i64 18, i64 21>, ptr %5, align 16
  %6 = getelementptr inbounds nuw i8, ptr %t3.i, i64 64
  %7 = getelementptr inbounds nuw i8, ptr %t3.i, i64 80
  store <2 x i64> <i64 16, i64 18>, ptr %6, align 16
  store <2 x i64> <i64 20, i64 22>, ptr %7, align 16
  %8 = getelementptr inbounds nuw i8, ptr %t7.i, i64 64
  %9 = getelementptr inbounds nuw i8, ptr %t7.i, i64 80
  store <2 x i64> <i64 24, i64 27>, ptr %8, align 16
  store <2 x i64> <i64 30, i64 33>, ptr %9, align 16
  %10 = getelementptr inbounds nuw i8, ptr %t3.i, i64 96
  %11 = getelementptr inbounds nuw i8, ptr %t3.i, i64 112
  store <2 x i64> <i64 24, i64 26>, ptr %10, align 16
  store <2 x i64> <i64 28, i64 30>, ptr %11, align 16
  %12 = getelementptr inbounds nuw i8, ptr %t7.i, i64 96
  %13 = getelementptr inbounds nuw i8, ptr %t7.i, i64 112
  store <2 x i64> <i64 36, i64 39>, ptr %12, align 16
  store <2 x i64> <i64 42, i64 45>, ptr %13, align 16
  %14 = getelementptr inbounds nuw i8, ptr %t3.i, i64 128
  %15 = getelementptr inbounds nuw i8, ptr %t3.i, i64 144
  store <2 x i64> <i64 32, i64 34>, ptr %14, align 16
  store <2 x i64> <i64 36, i64 38>, ptr %15, align 16
  %16 = getelementptr inbounds nuw i8, ptr %t7.i, i64 128
  %17 = getelementptr inbounds nuw i8, ptr %t7.i, i64 144
  store <2 x i64> <i64 48, i64 51>, ptr %16, align 16
  store <2 x i64> <i64 54, i64 57>, ptr %17, align 16
  %18 = getelementptr inbounds nuw i8, ptr %t3.i, i64 160
  %19 = getelementptr inbounds nuw i8, ptr %t3.i, i64 176
  store <2 x i64> <i64 40, i64 42>, ptr %18, align 16
  store <2 x i64> <i64 44, i64 46>, ptr %19, align 16
  %20 = getelementptr inbounds nuw i8, ptr %t7.i, i64 160
  %21 = getelementptr inbounds nuw i8, ptr %t7.i, i64 176
  store <2 x i64> <i64 60, i64 63>, ptr %20, align 16
  store <2 x i64> <i64 66, i64 69>, ptr %21, align 16
  %22 = getelementptr inbounds nuw i8, ptr %t3.i, i64 192
  %23 = getelementptr inbounds nuw i8, ptr %t3.i, i64 208
  store <2 x i64> <i64 48, i64 50>, ptr %22, align 16
  store <2 x i64> <i64 52, i64 54>, ptr %23, align 16
  %24 = getelementptr inbounds nuw i8, ptr %t7.i, i64 192
  %25 = getelementptr inbounds nuw i8, ptr %t7.i, i64 208
  store <2 x i64> <i64 72, i64 75>, ptr %24, align 16
  store <2 x i64> <i64 78, i64 81>, ptr %25, align 16
  %26 = getelementptr inbounds nuw i8, ptr %t3.i, i64 224
  %27 = getelementptr inbounds nuw i8, ptr %t3.i, i64 240
  store <2 x i64> <i64 56, i64 58>, ptr %26, align 16
  store <2 x i64> <i64 60, i64 62>, ptr %27, align 16
  %28 = getelementptr inbounds nuw i8, ptr %t7.i, i64 224
  %29 = getelementptr inbounds nuw i8, ptr %t7.i, i64 240
  store <2 x i64> <i64 84, i64 87>, ptr %28, align 16
  store <2 x i64> <i64 90, i64 93>, ptr %29, align 16
  br label %vector.body23

alloc.oom.12.i:                                   ; preds = %fill.body.9.preheader.i
  tail call fastcc void @archx_oom_fail()
  unreachable

vector.body23:                                    ; preds = %fill.body.14.preheader.i, %vector.body23
  %index24 = phi i64 [ %index.next32, %vector.body23 ], [ 0, %fill.body.14.preheader.i ]
  %30 = getelementptr inbounds nuw i64, ptr %t3.i, i64 %index24
  %31 = getelementptr inbounds nuw i8, ptr %30, i64 16
  %wide.load = load <2 x i64>, ptr %30, align 16
  %wide.load25 = load <2 x i64>, ptr %31, align 16
  %32 = getelementptr inbounds nuw i64, ptr %t12.i, i64 %index24
  %33 = getelementptr inbounds nuw i8, ptr %32, i64 16
  %wide.load26 = load <2 x i64>, ptr %32, align 16
  %wide.load27 = load <2 x i64>, ptr %33, align 16
  %34 = add <2 x i64> %wide.load26, %wide.load
  %35 = add <2 x i64> %wide.load27, %wide.load25
  store <2 x i64> %34, ptr %30, align 16
  store <2 x i64> %35, ptr %31, align 16
  %36 = getelementptr inbounds nuw i64, ptr %t7.i, i64 %index24
  %37 = getelementptr inbounds nuw i8, ptr %36, i64 16
  %wide.load28 = load <2 x i64>, ptr %36, align 16
  %wide.load29 = load <2 x i64>, ptr %37, align 16
  %38 = getelementptr inbounds nuw i64, ptr %t22.i, i64 %index24
  %39 = getelementptr inbounds nuw i8, ptr %38, i64 16
  %wide.load30 = load <2 x i64>, ptr %38, align 16
  %wide.load31 = load <2 x i64>, ptr %39, align 16
  %40 = add <2 x i64> %wide.load30, %wide.load28
  %41 = add <2 x i64> %wide.load31, %wide.load29
  store <2 x i64> %40, ptr %36, align 16
  store <2 x i64> %41, ptr %37, align 16
  %index.next32 = add nuw i64 %index24, 4
  %42 = icmp eq i64 %index.next32, 32
  br i1 %42, label %for.body.29.preheader.i, label %vector.body23, !llvm.loop !0

for.body.29.preheader.i:                          ; preds = %vector.body23
  store i64 2, ptr %t12.i, align 16
  store i64 2, ptr %t17.4.i, align 16
  store i64 2, ptr %t17.8.i, align 16
  store i64 2, ptr %t17.12.i, align 16
  store i64 2, ptr %t17.16.i, align 16
  store i64 2, ptr %t17.20.i, align 16
  store i64 2, ptr %t17.24.i, align 16
  store i64 2, ptr %t17.28.i, align 16
  br label %vector.body37

vector.body37:                                    ; preds = %vector.body37, %for.body.29.preheader.i
  %index38 = phi i64 [ 0, %for.body.29.preheader.i ], [ %index.next47, %vector.body37 ]
  %43 = getelementptr inbounds nuw i64, ptr %t3.i, i64 %index38
  %44 = getelementptr inbounds nuw i8, ptr %43, i64 16
  %wide.load39 = load <2 x i64>, ptr %43, align 16
  %wide.load40 = load <2 x i64>, ptr %44, align 16
  %45 = getelementptr inbounds nuw i64, ptr %t12.i, i64 %index38
  %46 = getelementptr inbounds nuw i8, ptr %45, i64 16
  %wide.load41 = load <2 x i64>, ptr %45, align 16
  %wide.load42 = load <2 x i64>, ptr %46, align 16
  %47 = add <2 x i64> %wide.load41, %wide.load39
  %48 = add <2 x i64> %wide.load42, %wide.load40
  store <2 x i64> %47, ptr %43, align 16
  store <2 x i64> %48, ptr %44, align 16
  %49 = getelementptr inbounds nuw i64, ptr %t7.i, i64 %index38
  %50 = getelementptr inbounds nuw i8, ptr %49, i64 16
  %wide.load43 = load <2 x i64>, ptr %49, align 16
  %wide.load44 = load <2 x i64>, ptr %50, align 16
  %51 = getelementptr inbounds nuw i64, ptr %t22.i, i64 %index38
  %52 = getelementptr inbounds nuw i8, ptr %51, i64 16
  %wide.load45 = load <2 x i64>, ptr %51, align 16
  %wide.load46 = load <2 x i64>, ptr %52, align 16
  %53 = add <2 x i64> %wide.load45, %wide.load43
  %54 = add <2 x i64> %wide.load46, %wide.load44
  store <2 x i64> %53, ptr %49, align 16
  store <2 x i64> %54, ptr %50, align 16
  %index.next47 = add nuw i64 %index38, 4
  %55 = icmp eq i64 %index.next47, 32
  br i1 %55, label %for.body.29.preheader.i.1, label %vector.body37, !llvm.loop !3

for.body.29.preheader.i.1:                        ; preds = %vector.body37
  store i64 3, ptr %t12.i, align 16
  store i64 3, ptr %t17.4.i, align 16
  store i64 3, ptr %t17.8.i, align 16
  store i64 3, ptr %t17.12.i, align 16
  store i64 3, ptr %t17.16.i, align 16
  store i64 3, ptr %t17.20.i, align 16
  store i64 3, ptr %t17.24.i, align 16
  store i64 3, ptr %t17.28.i, align 16
  br label %vector.body52

vector.body52:                                    ; preds = %vector.body52, %for.body.29.preheader.i.1
  %index53 = phi i64 [ 0, %for.body.29.preheader.i.1 ], [ %index.next62, %vector.body52 ]
  %56 = getelementptr inbounds nuw i64, ptr %t3.i, i64 %index53
  %57 = getelementptr inbounds nuw i8, ptr %56, i64 16
  %wide.load54 = load <2 x i64>, ptr %56, align 16
  %wide.load55 = load <2 x i64>, ptr %57, align 16
  %58 = getelementptr inbounds nuw i64, ptr %t12.i, i64 %index53
  %59 = getelementptr inbounds nuw i8, ptr %58, i64 16
  %wide.load56 = load <2 x i64>, ptr %58, align 16
  %wide.load57 = load <2 x i64>, ptr %59, align 16
  %60 = add <2 x i64> %wide.load56, %wide.load54
  %61 = add <2 x i64> %wide.load57, %wide.load55
  store <2 x i64> %60, ptr %56, align 16
  store <2 x i64> %61, ptr %57, align 16
  %62 = getelementptr inbounds nuw i64, ptr %t7.i, i64 %index53
  %63 = getelementptr inbounds nuw i8, ptr %62, i64 16
  %wide.load58 = load <2 x i64>, ptr %62, align 16
  %wide.load59 = load <2 x i64>, ptr %63, align 16
  %64 = getelementptr inbounds nuw i64, ptr %t22.i, i64 %index53
  %65 = getelementptr inbounds nuw i8, ptr %64, i64 16
  %wide.load60 = load <2 x i64>, ptr %64, align 16
  %wide.load61 = load <2 x i64>, ptr %65, align 16
  %66 = add <2 x i64> %wide.load60, %wide.load58
  %67 = add <2 x i64> %wide.load61, %wide.load59
  store <2 x i64> %66, ptr %62, align 16
  store <2 x i64> %67, ptr %63, align 16
  %index.next62 = add nuw i64 %index53, 4
  %68 = icmp eq i64 %index.next62, 32
  br i1 %68, label %for.body.29.preheader.i.2, label %vector.body52, !llvm.loop !4

for.body.29.preheader.i.2:                        ; preds = %vector.body52
  store i64 4, ptr %t12.i, align 16
  store i64 4, ptr %t17.4.i, align 16
  store i64 4, ptr %t17.8.i, align 16
  store i64 4, ptr %t17.12.i, align 16
  store i64 4, ptr %t17.16.i, align 16
  store i64 4, ptr %t17.20.i, align 16
  store i64 4, ptr %t17.24.i, align 16
  store i64 4, ptr %t17.28.i, align 16
  br label %vector.body67

vector.body67:                                    ; preds = %vector.body67, %for.body.29.preheader.i.2
  %index68 = phi i64 [ 0, %for.body.29.preheader.i.2 ], [ %index.next77, %vector.body67 ]
  %69 = getelementptr inbounds nuw i64, ptr %t3.i, i64 %index68
  %70 = getelementptr inbounds nuw i8, ptr %69, i64 16
  %wide.load69 = load <2 x i64>, ptr %69, align 16
  %wide.load70 = load <2 x i64>, ptr %70, align 16
  %71 = getelementptr inbounds nuw i64, ptr %t12.i, i64 %index68
  %72 = getelementptr inbounds nuw i8, ptr %71, i64 16
  %wide.load71 = load <2 x i64>, ptr %71, align 16
  %wide.load72 = load <2 x i64>, ptr %72, align 16
  %73 = add <2 x i64> %wide.load71, %wide.load69
  %74 = add <2 x i64> %wide.load72, %wide.load70
  store <2 x i64> %73, ptr %69, align 16
  store <2 x i64> %74, ptr %70, align 16
  %75 = getelementptr inbounds nuw i64, ptr %t7.i, i64 %index68
  %76 = getelementptr inbounds nuw i8, ptr %75, i64 16
  %wide.load73 = load <2 x i64>, ptr %75, align 16
  %wide.load74 = load <2 x i64>, ptr %76, align 16
  %77 = getelementptr inbounds nuw i64, ptr %t22.i, i64 %index68
  %78 = getelementptr inbounds nuw i8, ptr %77, i64 16
  %wide.load75 = load <2 x i64>, ptr %77, align 16
  %wide.load76 = load <2 x i64>, ptr %78, align 16
  %79 = add <2 x i64> %wide.load75, %wide.load73
  %80 = add <2 x i64> %wide.load76, %wide.load74
  store <2 x i64> %79, ptr %75, align 16
  store <2 x i64> %80, ptr %76, align 16
  %index.next77 = add nuw i64 %index68, 4
  %81 = icmp eq i64 %index.next77, 32
  br i1 %81, label %for.body.29.preheader.i.3, label %vector.body67, !llvm.loop !5

for.body.29.preheader.i.3:                        ; preds = %vector.body67
  store i64 5, ptr %t12.i, align 16
  store i64 5, ptr %t17.4.i, align 16
  store i64 5, ptr %t17.8.i, align 16
  store i64 5, ptr %t17.12.i, align 16
  store i64 5, ptr %t17.16.i, align 16
  store i64 5, ptr %t17.20.i, align 16
  store i64 5, ptr %t17.24.i, align 16
  store i64 5, ptr %t17.28.i, align 16
  br label %vector.body82

vector.body82:                                    ; preds = %vector.body82, %for.body.29.preheader.i.3
  %index83 = phi i64 [ 0, %for.body.29.preheader.i.3 ], [ %index.next92, %vector.body82 ]
  %82 = getelementptr inbounds nuw i64, ptr %t3.i, i64 %index83
  %83 = getelementptr inbounds nuw i8, ptr %82, i64 16
  %wide.load84 = load <2 x i64>, ptr %82, align 16
  %wide.load85 = load <2 x i64>, ptr %83, align 16
  %84 = getelementptr inbounds nuw i64, ptr %t12.i, i64 %index83
  %85 = getelementptr inbounds nuw i8, ptr %84, i64 16
  %wide.load86 = load <2 x i64>, ptr %84, align 16
  %wide.load87 = load <2 x i64>, ptr %85, align 16
  %86 = add <2 x i64> %wide.load86, %wide.load84
  %87 = add <2 x i64> %wide.load87, %wide.load85
  store <2 x i64> %86, ptr %82, align 16
  store <2 x i64> %87, ptr %83, align 16
  %88 = getelementptr inbounds nuw i64, ptr %t7.i, i64 %index83
  %89 = getelementptr inbounds nuw i8, ptr %88, i64 16
  %wide.load88 = load <2 x i64>, ptr %88, align 16
  %wide.load89 = load <2 x i64>, ptr %89, align 16
  %90 = getelementptr inbounds nuw i64, ptr %t22.i, i64 %index83
  %91 = getelementptr inbounds nuw i8, ptr %90, i64 16
  %wide.load90 = load <2 x i64>, ptr %90, align 16
  %wide.load91 = load <2 x i64>, ptr %91, align 16
  %92 = add <2 x i64> %wide.load90, %wide.load88
  %93 = add <2 x i64> %wide.load91, %wide.load89
  store <2 x i64> %92, ptr %88, align 16
  store <2 x i64> %93, ptr %89, align 16
  %index.next92 = add nuw i64 %index83, 4
  %94 = icmp eq i64 %index.next92, 32
  br i1 %94, label %vector.body97, label %vector.body82, !llvm.loop !6

vector.body97:                                    ; preds = %vector.body82
  %95 = getelementptr inbounds nuw i8, ptr %t3.i, i64 16
  %wide.load100 = load <2 x i64>, ptr %t3.i, align 16
  %wide.load101 = load <2 x i64>, ptr %95, align 16
  %96 = getelementptr inbounds nuw i8, ptr %t7.i, i64 16
  %wide.load102 = load <2 x i64>, ptr %t7.i, align 16
  %wide.load103 = load <2 x i64>, ptr %96, align 16
  %97 = add <2 x i64> %wide.load100, %wide.load102
  %98 = add <2 x i64> %wide.load101, %wide.load103
  %99 = getelementptr inbounds nuw i8, ptr %t3.i, i64 32
  %100 = getelementptr inbounds nuw i8, ptr %t3.i, i64 48
  %wide.load100.1 = load <2 x i64>, ptr %99, align 16
  %wide.load101.1 = load <2 x i64>, ptr %100, align 16
  %101 = getelementptr inbounds nuw i8, ptr %t7.i, i64 32
  %102 = getelementptr inbounds nuw i8, ptr %t7.i, i64 48
  %wide.load102.1 = load <2 x i64>, ptr %101, align 16
  %wide.load103.1 = load <2 x i64>, ptr %102, align 16
  %103 = add <2 x i64> %wide.load100.1, %97
  %104 = add <2 x i64> %wide.load101.1, %98
  %105 = add <2 x i64> %103, %wide.load102.1
  %106 = add <2 x i64> %104, %wide.load103.1
  %107 = getelementptr inbounds nuw i8, ptr %t3.i, i64 64
  %108 = getelementptr inbounds nuw i8, ptr %t3.i, i64 80
  %wide.load100.2 = load <2 x i64>, ptr %107, align 16
  %wide.load101.2 = load <2 x i64>, ptr %108, align 16
  %109 = getelementptr inbounds nuw i8, ptr %t7.i, i64 64
  %110 = getelementptr inbounds nuw i8, ptr %t7.i, i64 80
  %wide.load102.2 = load <2 x i64>, ptr %109, align 16
  %wide.load103.2 = load <2 x i64>, ptr %110, align 16
  %111 = add <2 x i64> %wide.load100.2, %105
  %112 = add <2 x i64> %wide.load101.2, %106
  %113 = add <2 x i64> %111, %wide.load102.2
  %114 = add <2 x i64> %112, %wide.load103.2
  %115 = getelementptr inbounds nuw i8, ptr %t3.i, i64 96
  %116 = getelementptr inbounds nuw i8, ptr %t3.i, i64 112
  %wide.load100.3 = load <2 x i64>, ptr %115, align 16
  %wide.load101.3 = load <2 x i64>, ptr %116, align 16
  %117 = getelementptr inbounds nuw i8, ptr %t7.i, i64 96
  %118 = getelementptr inbounds nuw i8, ptr %t7.i, i64 112
  %wide.load102.3 = load <2 x i64>, ptr %117, align 16
  %wide.load103.3 = load <2 x i64>, ptr %118, align 16
  %119 = add <2 x i64> %wide.load100.3, %113
  %120 = add <2 x i64> %wide.load101.3, %114
  %121 = add <2 x i64> %119, %wide.load102.3
  %122 = add <2 x i64> %120, %wide.load103.3
  %123 = getelementptr inbounds nuw i8, ptr %t3.i, i64 128
  %124 = getelementptr inbounds nuw i8, ptr %t3.i, i64 144
  %wide.load100.4 = load <2 x i64>, ptr %123, align 16
  %wide.load101.4 = load <2 x i64>, ptr %124, align 16
  %125 = getelementptr inbounds nuw i8, ptr %t7.i, i64 128
  %126 = getelementptr inbounds nuw i8, ptr %t7.i, i64 144
  %wide.load102.4 = load <2 x i64>, ptr %125, align 16
  %wide.load103.4 = load <2 x i64>, ptr %126, align 16
  %127 = add <2 x i64> %wide.load100.4, %121
  %128 = add <2 x i64> %wide.load101.4, %122
  %129 = add <2 x i64> %127, %wide.load102.4
  %130 = add <2 x i64> %128, %wide.load103.4
  %131 = getelementptr inbounds nuw i8, ptr %t3.i, i64 160
  %132 = getelementptr inbounds nuw i8, ptr %t3.i, i64 176
  %wide.load100.5 = load <2 x i64>, ptr %131, align 16
  %wide.load101.5 = load <2 x i64>, ptr %132, align 16
  %133 = getelementptr inbounds nuw i8, ptr %t7.i, i64 160
  %134 = getelementptr inbounds nuw i8, ptr %t7.i, i64 176
  %wide.load102.5 = load <2 x i64>, ptr %133, align 16
  %wide.load103.5 = load <2 x i64>, ptr %134, align 16
  %135 = add <2 x i64> %wide.load100.5, %129
  %136 = add <2 x i64> %wide.load101.5, %130
  %137 = add <2 x i64> %135, %wide.load102.5
  %138 = add <2 x i64> %136, %wide.load103.5
  %139 = getelementptr inbounds nuw i8, ptr %t3.i, i64 192
  %140 = getelementptr inbounds nuw i8, ptr %t3.i, i64 208
  %wide.load100.6 = load <2 x i64>, ptr %139, align 16
  %wide.load101.6 = load <2 x i64>, ptr %140, align 16
  %141 = getelementptr inbounds nuw i8, ptr %t7.i, i64 192
  %142 = getelementptr inbounds nuw i8, ptr %t7.i, i64 208
  %wide.load102.6 = load <2 x i64>, ptr %141, align 16
  %wide.load103.6 = load <2 x i64>, ptr %142, align 16
  %143 = add <2 x i64> %wide.load100.6, %137
  %144 = add <2 x i64> %wide.load101.6, %138
  %145 = add <2 x i64> %143, %wide.load102.6
  %146 = add <2 x i64> %144, %wide.load103.6
  %147 = getelementptr inbounds nuw i8, ptr %t3.i, i64 224
  %148 = getelementptr inbounds nuw i8, ptr %t3.i, i64 240
  %wide.load100.7 = load <2 x i64>, ptr %147, align 16
  %wide.load101.7 = load <2 x i64>, ptr %148, align 16
  %149 = getelementptr inbounds nuw i8, ptr %t7.i, i64 224
  %150 = getelementptr inbounds nuw i8, ptr %t7.i, i64 240
  %wide.load102.7 = load <2 x i64>, ptr %149, align 16
  %wide.load103.7 = load <2 x i64>, ptr %150, align 16
  %151 = add <2 x i64> %wide.load100.7, %145
  %152 = add <2 x i64> %wide.load101.7, %146
  %153 = add <2 x i64> %151, %wide.load102.7
  %154 = add <2 x i64> %152, %wide.load103.7
  %bin.rdx = add <2 x i64> %154, %153
  %155 = tail call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx)
  tail call void @free(ptr nonnull %t22.i)
  tail call void @free(ptr nonnull %t12.i)
  tail call void @free(ptr nonnull %t7.i)
  tail call void @free(ptr nonnull %t3.i)
  %t1 = tail call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.int, i64 %155)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %func.region.i)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %func.region.i, i8 0, i64 32, i1 false)
  %res.i.i = call fastcc nonnull align 16 ptr @archx_region_alloc_slow(ptr nonnull %func.region.i, i64 512)
  %156 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 16
  store <2 x i64> splat (i64 1), ptr %res.i.i, align 16
  store <2 x i64> splat (i64 1), ptr %156, align 16
  %157 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 32
  %158 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 48
  store <2 x i64> splat (i64 1), ptr %157, align 16
  store <2 x i64> splat (i64 1), ptr %158, align 16
  %159 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 64
  %160 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 80
  store <2 x i64> splat (i64 1), ptr %159, align 16
  store <2 x i64> splat (i64 1), ptr %160, align 16
  %161 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 96
  %162 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 112
  store <2 x i64> splat (i64 1), ptr %161, align 16
  store <2 x i64> splat (i64 1), ptr %162, align 16
  %163 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 128
  %164 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 144
  store <2 x i64> splat (i64 1), ptr %163, align 16
  store <2 x i64> splat (i64 1), ptr %164, align 16
  %165 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 160
  %166 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 176
  store <2 x i64> splat (i64 1), ptr %165, align 16
  store <2 x i64> splat (i64 1), ptr %166, align 16
  %167 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 192
  %168 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 208
  store <2 x i64> splat (i64 1), ptr %167, align 16
  store <2 x i64> splat (i64 1), ptr %168, align 16
  %169 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 224
  %170 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 240
  store <2 x i64> splat (i64 1), ptr %169, align 16
  store <2 x i64> splat (i64 1), ptr %170, align 16
  %171 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 256
  %172 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 272
  store <2 x i64> splat (i64 1), ptr %171, align 16
  store <2 x i64> splat (i64 1), ptr %172, align 16
  %173 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 288
  %174 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 304
  store <2 x i64> splat (i64 1), ptr %173, align 16
  store <2 x i64> splat (i64 1), ptr %174, align 16
  %175 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 320
  %176 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 336
  store <2 x i64> splat (i64 1), ptr %175, align 16
  store <2 x i64> splat (i64 1), ptr %176, align 16
  %177 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 352
  %178 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 368
  store <2 x i64> splat (i64 1), ptr %177, align 16
  store <2 x i64> splat (i64 1), ptr %178, align 16
  %179 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 384
  %180 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 400
  store <2 x i64> splat (i64 1), ptr %179, align 16
  store <2 x i64> splat (i64 1), ptr %180, align 16
  %181 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 416
  %182 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 432
  store <2 x i64> splat (i64 1), ptr %181, align 16
  store <2 x i64> splat (i64 1), ptr %182, align 16
  %183 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 448
  %184 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 464
  store <2 x i64> splat (i64 1), ptr %183, align 16
  store <2 x i64> splat (i64 1), ptr %184, align 16
  %185 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 480
  %186 = getelementptr inbounds nuw i8, ptr %res.i.i, i64 496
  store <2 x i64> splat (i64 1), ptr %185, align 16
  store <2 x i64> splat (i64 1), ptr %186, align 16
  %.fca.2.gep.i = getelementptr inbounds nuw i8, ptr %func.region.i, i64 16
  %t28.i = call fastcc { i64, i64 } @archx_str_concat(%ArchxStr { i64 8030029675902271495, i64 3830898 }, %ArchxStr { i64 7308332212187824138, i64 58709760767091 }, ptr %func.region.i)
  %newret16 = extractvalue { i64, i64 } %t28.i, 0
  %newret18 = extractvalue { i64, i64 } %t28.i, 1
  %t37.i3 = and i64 %newret16, 4294967288
  %t38.not.i = icmp eq i64 %t37.i3, 0
  br i1 %t38.not.i, label %archx_str_drop.exit19.i, label %if.then.11.i

if.then.11.i:                                     ; preds = %vector.body97
  %oldret17 = insertvalue %ArchxStr poison, i64 %newret16, 0
  %oldret19 = insertvalue %ArchxStr %oldret17, i64 %newret18, 1
  %t41.i4 = call fastcc { i64, i64 } @archx_str_concat(%ArchxStr %oldret19, %ArchxStr { i64 30240117406826499, i64 0 }, ptr %func.region.i)
  %newret = extractvalue { i64, i64 } %t41.i4, 0
  %oldret = insertvalue %ArchxStr poison, i64 %newret, 0
  %newret14 = extractvalue { i64, i64 } %t41.i4, 1
  %oldret15 = insertvalue %ArchxStr %oldret, i64 %newret14, 1
  %len.i23.i = and i64 %newret, 4294967295
  %long.i24.i = icmp samesign ugt i64 %len.i23.i, 12
  %tag.i27.i = and i64 %newret14, 3
  %is_reg.i.i = icmp eq i64 %tag.i27.i, 2
  %or.cond114 = select i1 %long.i24.i, i1 %is_reg.i.i, i1 false
  br i1 %or.cond114, label %dup_heap.i.i, label %archx_str_promote.exit.i

dup_heap.i.i:                                     ; preds = %if.then.11.i
  %dst.i.i = tail call noalias align 16 ptr @malloc(i64 %len.i23.i)
  %isnull.i.i = icmp eq ptr %dst.i.i, null
  br i1 %isnull.i.i, label %oom.i.i, label %copy.i.i

oom.i.i:                                          ; preds = %dup_heap.i.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i.i:                                         ; preds = %dup_heap.i.i
  %src_i.i.i = and i64 %newret14, -4
  %src.i.i = inttoptr i64 %src_i.i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i.i, ptr nonnull align 4 %src.i.i, i64 %len.i23.i, i1 false)
  %dst_i.i.i = ptrtoint ptr %dst.i.i to i64
  %tagged.i.i = or disjoint i64 %dst_i.i.i, 1
  %out.i.i = insertvalue %ArchxStr %oldret15, i64 %tagged.i.i, 1
  br label %archx_str_promote.exit.i

archx_str_promote.exit.i:                         ; preds = %copy.i.i, %if.then.11.i
  %common.ret.op.i25.i = phi %ArchxStr [ %out.i.i, %copy.i.i ], [ %oldret15, %if.then.11.i ]
  %len.i.i = and i64 %newret16, 4294967295
  %long.i.i = icmp samesign ult i64 %len.i.i, 13
  %tag.i.i = and i64 %newret18, 1
  %owned.not.i.i = icmp eq i64 %tag.i.i, 0
  %or.cond115 = select i1 %long.i.i, i1 true, i1 %owned.not.i.i
  br i1 %or.cond115, label %archx_str_drop.exit.i, label %do_free.i.i

do_free.i.i:                                      ; preds = %archx_str_promote.exit.i
  %raw.i.i = and i64 %newret18, -2
  %ptr.i.i = inttoptr i64 %raw.i.i to ptr
  tail call void @free(ptr %ptr.i.i)
  br label %archx_str_drop.exit.i

archx_str_drop.exit.i:                            ; preds = %do_free.i.i, %archx_str_promote.exit.i
  %t45.i = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i28.i = icmp eq ptr %t45.i, null
  br i1 %empty.i28.i, label %archx_fn_format_report.exit, label %loop.i29.i

loop.i29.i:                                       ; preds = %archx_str_drop.exit.i, %loop.i29.i
  %cur.i30.i = phi ptr [ %next.i31.i, %loop.i29.i ], [ %t45.i, %archx_str_drop.exit.i ]
  %next.i31.i = load ptr, ptr %cur.i30.i, align 8
  tail call void @free(ptr nonnull %cur.i30.i)
  %more.not.i32.i = icmp eq ptr %next.i31.i, null
  br i1 %more.not.i32.i, label %archx_fn_format_report.exit, label %loop.i29.i

archx_str_drop.exit19.i:                          ; preds = %vector.body97
  %t50.i5 = load ptr, ptr %.fca.2.gep.i, align 8
  %empty.i34.i = icmp eq ptr %t50.i5, null
  br i1 %empty.i34.i, label %archx_fn_format_report.exit, label %loop.i35.i

loop.i35.i:                                       ; preds = %archx_str_drop.exit19.i, %loop.i35.i
  %cur.i36.i = phi ptr [ %next.i37.i, %loop.i35.i ], [ %t50.i5, %archx_str_drop.exit19.i ]
  %next.i37.i = load ptr, ptr %cur.i36.i, align 8
  tail call void @free(ptr nonnull %cur.i36.i)
  %more.not.i38.i = icmp eq ptr %next.i37.i, null
  br i1 %more.not.i38.i, label %archx_fn_format_report.exit, label %loop.i35.i

archx_fn_format_report.exit:                      ; preds = %loop.i29.i, %loop.i35.i, %archx_str_drop.exit.i, %archx_str_drop.exit19.i
  %common.ret.op.i = phi %ArchxStr [ %common.ret.op.i25.i, %archx_str_drop.exit.i ], [ { i64 7310026593965965323, i64 28548142444602209 }, %archx_str_drop.exit19.i ], [ { i64 7310026593965965323, i64 28548142444602209 }, %loop.i35.i ], [ %common.ret.op.i25.i, %loop.i29.i ]
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %func.region.i)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %tmp.i)
  %w0.i6 = extractvalue %ArchxStr %common.ret.op.i, 0
  %w1.i7 = extractvalue %ArchxStr %common.ret.op.i, 1
  %len.i8 = and i64 %w0.i6, 4294967295
  %short.i = icmp samesign ult i64 %len.i8, 13
  br i1 %short.i, label %emit.i, label %emit.thread.i

emit.thread.i:                                    ; preds = %archx_fn_format_report.exit
  %raw.i9 = and i64 %w1.i7, -4
  %lptr.i = inttoptr i64 %raw.i9 to ptr
  br label %chk_nul.i

emit.i:                                           ; preds = %archx_fn_format_report.exit
  %p4.i = lshr i64 %w0.i6, 32
  %p4_32.i = trunc nuw i64 %p4.i to i32
  store i32 %p4_32.i, ptr %tmp.i, align 4
  %tmp4.i = getelementptr inbounds nuw i8, ptr %tmp.i, i64 4
  store i64 %w1.i7, ptr %tmp4.i, align 4
  %pos.not.i = icmp eq i64 %len.i8, 0
  br i1 %pos.not.i, label %do_nl.i, label %chk_nul.i

chk_nul.i:                                        ; preds = %emit.i, %emit.thread.i
  %data3.i = phi ptr [ %lptr.i, %emit.thread.i ], [ %tmp.i, %emit.i ]
  %nul.i = call ptr @memchr(ptr nonnull %data3.i, i32 0, i64 %len.i8)
  %has_nul.not.i = icmp eq ptr %nul.i, null
  br i1 %has_nul.not.i, label %fast_printf.i, label %byte_loop.i

fast_printf.i:                                    ; preds = %chk_nul.i
  %len32.i = trunc i64 %w0.i6 to i32
  %np.i = call i32 (ptr, ...) @printf(ptr nonnull dereferenceable(1) @.fmt.pstr.nl, i32 %len32.i, ptr nonnull %data3.i)
  br label %archx_str_print.exit

byte_loop.i:                                      ; preds = %chk_nul.i, %byte_loop.i
  %bi.i = phi i64 [ %bnext.i, %byte_loop.i ], [ 0, %chk_nul.i ]
  %bp.i = getelementptr inbounds nuw i8, ptr %data3.i, i64 %bi.i
  %ch8.i = load i8, ptr %bp.i, align 1
  %ch32.i = zext i8 %ch8.i to i32
  %pc.i = tail call i32 @putchar(i32 %ch32.i)
  %bnext.i = add nuw nsw i64 %bi.i, 1
  %exitcond.not.i10 = icmp eq i64 %bnext.i, %len.i8
  br i1 %exitcond.not.i10, label %do_nl.i, label %byte_loop.i

do_nl.i:                                          ; preds = %byte_loop.i, %emit.i
  %nc.i = tail call i32 @putchar(i32 10)
  br label %archx_str_print.exit

archx_str_print.exit:                             ; preds = %fast_printf.i, %do_nl.i
  call void @llvm.lifetime.end.p0(i64 12, ptr nonnull %tmp.i)
  %tag.i = and i64 %w1.i7, 1
  %owned.not.i = icmp eq i64 %tag.i, 0
  %or.cond = select i1 %short.i, i1 true, i1 %owned.not.i
  br i1 %or.cond, label %archx_str_drop.exit, label %do_free.i

do_free.i:                                        ; preds = %archx_str_print.exit
  %raw.i = and i64 %w1.i7, -2
  %ptr.i = inttoptr i64 %raw.i to ptr
  call void @free(ptr %ptr.i)
  br label %archx_str_drop.exit

archx_str_drop.exit:                              ; preds = %archx_str_print.exit, %do_free.i
  ret i32 0
}

; Function Attrs: nofree noinline nounwind
define private fastcc noalias nonnull align 16 ptr @archx_region_alloc_slow(ptr nonnull captures(none) %reg, i64 range(i64 16, 2147483663) %aligned) unnamed_addr #1 {
entry:
  %body_sz = tail call i64 @llvm.umax.i64(i64 %aligned, i64 65536)
  %tot = add nuw nsw i64 %body_sz, 16
  %blk = tail call noalias align 16 ptr @malloc(i64 %tot)
  %isnull = icmp eq ptr %blk, null
  br i1 %isnull, label %oom, label %ok

oom:                                              ; preds = %entry
  tail call fastcc void @archx_oom_fail()
  unreachable

ok:                                               ; preds = %entry
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
  %new_cur = getelementptr inbounds nuw i8, ptr %data, i64 %aligned
  %new_end = getelementptr inbounds nuw i8, ptr %data, i64 %body_sz
  %end_slot = getelementptr inbounds nuw i8, ptr %reg, i64 8
  store ptr %new_cur, ptr %reg, align 8
  store ptr %new_end, ptr %end_slot, align 8
  ret ptr %data
}

; Function Attrs: nounwind
define private fastcc { i64, i64 } @archx_str_concat(%ArchxStr %a, %ArchxStr %b, ptr nonnull captures(none) %reg) unnamed_addr #0 {
entry:
  %atmp = alloca [12 x i8], align 4
  %btmp = alloca [12 x i8], align 4
  %out_sso = alloca [16 x i8], align 8
  %aw0 = extractvalue %ArchxStr %a, 0
  %aw1 = extractvalue %ArchxStr %a, 1
  %bw0 = extractvalue %ArchxStr %b, 0
  %bw1 = extractvalue %ArchxStr %b, 1
  %alen = and i64 %aw0, 4294967295
  %blen = and i64 %bw0, 4294967295
  %az = icmp eq i64 %alen, 0
  br i1 %az, label %ret_b, label %chk_bz

ret_b:                                            ; preds = %entry
  %bw1_tag = and i64 %bw1, 1
  %b_owned.not = icmp ne i64 %bw1_tag, 0
  %long.i = icmp samesign ugt i64 %blen, 12
  %or.cond = select i1 %b_owned.not, i1 %long.i, i1 false
  br i1 %or.cond, label %dup_heap.i, label %common.ret

common.ret:                                       ; preds = %copy.i14, %copy.i, %ret_a, %ret_b, %archx_region_alloc.exit, %build_sso
  %common.ret.op = phi %ArchxStr [ %rs1, %build_sso ], [ %ls1, %archx_region_alloc.exit ], [ %b, %ret_b ], [ %a, %ret_a ], [ %out.i, %copy.i ], [ %out.i19, %copy.i14 ]
  %oldret = extractvalue %ArchxStr %common.ret.op, 0
  %newret = insertvalue { i64, i64 } poison, i64 %oldret, 0
  %oldret1 = extractvalue %ArchxStr %common.ret.op, 1
  %newret2 = insertvalue { i64, i64 } %newret, i64 %oldret1, 1
  ret { i64, i64 } %newret2

dup_heap.i:                                       ; preds = %ret_b
  %dst.i = tail call noalias align 16 ptr @malloc(i64 %blen)
  %isnull.i = icmp eq ptr %dst.i, null
  br i1 %isnull.i, label %oom.i, label %copy.i

oom.i:                                            ; preds = %dup_heap.i
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i:                                           ; preds = %dup_heap.i
  %src_i.i = and i64 %bw1, -2
  %src.i = inttoptr i64 %src_i.i to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i, ptr nonnull align 2 %src.i, i64 %blen, i1 false)
  %dst_i.i = ptrtoint ptr %dst.i to i64
  %tagged.i = or disjoint i64 %dst_i.i, 1
  %out.i = insertvalue %ArchxStr %b, i64 %tagged.i, 1
  br label %common.ret

chk_bz:                                           ; preds = %entry
  %bz = icmp eq i64 %blen, 0
  br i1 %bz, label %ret_a, label %calc_tot

ret_a:                                            ; preds = %chk_bz
  %aw1_tag = and i64 %aw1, 1
  %a_owned.not = icmp ne i64 %aw1_tag, 0
  %long.i5 = icmp samesign ugt i64 %alen, 12
  %or.cond24 = select i1 %a_owned.not, i1 %long.i5, i1 false
  br i1 %or.cond24, label %dup_heap.i11, label %common.ret

dup_heap.i11:                                     ; preds = %ret_a
  %dst.i12 = tail call noalias align 16 ptr @malloc(i64 %alen)
  %isnull.i13 = icmp eq ptr %dst.i12, null
  br i1 %isnull.i13, label %oom.i20, label %copy.i14

oom.i20:                                          ; preds = %dup_heap.i11
  tail call fastcc void @archx_oom_fail()
  unreachable

copy.i14:                                         ; preds = %dup_heap.i11
  %src_i.i15 = and i64 %aw1, -2
  %src.i16 = inttoptr i64 %src_i.i15 to ptr
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst.i12, ptr nonnull align 2 %src.i16, i64 %alen, i1 false)
  %dst_i.i17 = ptrtoint ptr %dst.i12 to i64
  %tagged.i18 = or disjoint i64 %dst_i.i17, 1
  %out.i19 = insertvalue %ArchxStr %a, i64 %tagged.i18, 1
  br label %common.ret

calc_tot:                                         ; preds = %chk_bz
  %tot = add nuw nsw i64 %blen, %alen
  %too_big = icmp samesign ugt i64 %tot, 2147483647
  br i1 %too_big, label %oom, label %mat_a

oom:                                              ; preds = %calc_tot
  tail call fastcc void @archx_oom_fail()
  unreachable

mat_a:                                            ; preds = %calc_tot
  %ashort = icmp samesign ult i64 %alen, 13
  br i1 %ashort, label %mat_a_short, label %mat_a_long

mat_a_short:                                      ; preds = %mat_a
  %ap4 = lshr i64 %aw0, 32
  %ap4_32 = trunc nuw i64 %ap4 to i32
  store i32 %ap4_32, ptr %atmp, align 4
  %atmp4 = getelementptr inbounds nuw i8, ptr %atmp, i64 4
  store i64 %aw1, ptr %atmp4, align 4
  br label %mat_b

mat_a_long:                                       ; preds = %mat_a
  %araw = and i64 %aw1, -4
  %alptr = inttoptr i64 %araw to ptr
  br label %mat_b

mat_b:                                            ; preds = %mat_a_long, %mat_a_short
  %aptr = phi ptr [ %atmp, %mat_a_short ], [ %alptr, %mat_a_long ]
  %bshort = icmp samesign ult i64 %blen, 13
  br i1 %bshort, label %mat_b_short, label %mat_b_long

mat_b_short:                                      ; preds = %mat_b
  %bp4 = lshr i64 %bw0, 32
  %bp4_32 = trunc nuw nsw i64 %bp4 to i32
  store i32 %bp4_32, ptr %btmp, align 4
  %btmp4 = getelementptr inbounds nuw i8, ptr %btmp, i64 4
  store i64 %bw1, ptr %btmp4, align 4
  br label %build

mat_b_long:                                       ; preds = %mat_b
  %braw = and i64 %bw1, -4
  %blptr = inttoptr i64 %braw to ptr
  br label %build

build:                                            ; preds = %mat_b_long, %mat_b_short
  %bptr = phi ptr [ %btmp, %mat_b_short ], [ %blptr, %mat_b_long ]
  %fits_sso = icmp samesign ult i64 %tot, 13
  br i1 %fits_sso, label %build_sso, label %alloc_reg

build_sso:                                        ; preds = %build
  %out_sso8 = getelementptr inbounds nuw i8, ptr %out_sso, i64 8
  %tot32 = trunc nuw nsw i64 %tot to i32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %out_sso, i8 0, i64 16, i1 false)
  store i32 %tot32, ptr %out_sso, align 8
  %sso_dst_a = getelementptr inbounds nuw i8, ptr %out_sso, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a, ptr nonnull align 1 %aptr, i64 %alen, i1 false)
  %sso_dst_b = getelementptr inbounds nuw i8, ptr %sso_dst_a, i64 %alen
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b, ptr nonnull align 1 %bptr, i64 %blen, i1 false)
  %rw0 = load i64, ptr %out_sso, align 8
  %rw1 = load i64, ptr %out_sso8, align 8
  %rs0 = insertvalue %ArchxStr poison, i64 %rw0, 0
  %rs1 = insertvalue %ArchxStr %rs0, i64 %rw1, 1
  br label %common.ret

alloc_reg:                                        ; preds = %build
  %a1.i = add nuw nsw i64 %tot, 15
  %aligned.i = and i64 %a1.i, 4294967280
  %end_slot.i = getelementptr inbounds nuw i8, ptr %reg, i64 8
  %cur.i = load ptr, ptr %reg, align 8
  %end.i = load ptr, ptr %end_slot.i, align 8
  %cur_i.i = ptrtoint ptr %cur.i to i64
  %end_i.i = ptrtoint ptr %end.i to i64
  %rem.i = sub i64 %end_i.i, %cur_i.i
  %fits.not.i = icmp slt i64 %rem.i, %aligned.i
  br i1 %fits.not.i, label %check_reuse.i, label %fast.i

fast.i:                                           ; preds = %alloc_reg
  %next.i = getelementptr inbounds nuw i8, ptr %cur.i, i64 %aligned.i
  store ptr %next.i, ptr %reg, align 8
  br label %archx_region_alloc.exit

check_reuse.i:                                    ; preds = %alloc_reg
  %tail_slot.i = getelementptr inbounds nuw i8, ptr %reg, i64 24
  %tail.i = load ptr, ptr %tail_slot.i, align 8
  %has_tail.not.i = icmp eq ptr %tail.i, null
  %head_slot.i = getelementptr inbounds nuw i8, ptr %reg, i64 16
  %cand.in.i = select i1 %has_tail.not.i, ptr %head_slot.i, ptr %tail.i
  %cand.i = load ptr, ptr %cand.in.i, align 8
  %has_cand.not.i = icmp eq ptr %cand.i, null
  br i1 %has_cand.not.i, label %slow.i, label %check_cand_cap.i

check_cand_cap.i:                                 ; preds = %check_reuse.i
  %ccap_ptr.i = getelementptr inbounds nuw i8, ptr %cand.i, i64 8
  %ccap.i = load i64, ptr %ccap_ptr.i, align 8
  %cfits.not.i = icmp slt i64 %ccap.i, %aligned.i
  br i1 %cfits.not.i, label %drop_stale_chain.i, label %reuse_cand.i

reuse_cand.i:                                     ; preds = %check_cand_cap.i
  store ptr %cand.i, ptr %tail_slot.i, align 8
  %cdata.i = getelementptr inbounds nuw i8, ptr %cand.i, i64 16
  %ccur.i = getelementptr inbounds nuw i8, ptr %cdata.i, i64 %aligned.i
  %cend.i = getelementptr inbounds nuw i8, ptr %cdata.i, i64 %ccap.i
  store ptr %ccur.i, ptr %reg, align 8
  store ptr %cend.i, ptr %end_slot.i, align 8
  br label %archx_region_alloc.exit

drop_stale_chain.i:                               ; preds = %check_cand_cap.i
  br i1 %has_tail.not.i, label %unlink_from_head.i, label %unlink_from_tail.i

unlink_from_tail.i:                               ; preds = %drop_stale_chain.i
  store ptr null, ptr %tail.i, align 8
  br label %loop.i.preheader

unlink_from_head.i:                               ; preds = %drop_stale_chain.i
  store ptr null, ptr %head_slot.i, align 8
  br label %loop.i.preheader

loop.i.preheader:                                 ; preds = %unlink_from_head.i, %unlink_from_tail.i
  br label %loop.i

loop.i:                                           ; preds = %loop.i.preheader, %loop.i
  %cur.i22 = phi ptr [ %next.i23, %loop.i ], [ %cand.i, %loop.i.preheader ]
  %next.i23 = load ptr, ptr %cur.i22, align 8
  tail call void @free(ptr nonnull %cur.i22)
  %more.not.i = icmp eq ptr %next.i23, null
  br i1 %more.not.i, label %slow.i, label %loop.i

slow.i:                                           ; preds = %loop.i, %check_reuse.i
  %res.i = tail call fastcc nonnull align 16 ptr @archx_region_alloc_slow(ptr nonnull %reg, i64 %aligned.i)
  br label %archx_region_alloc.exit

archx_region_alloc.exit:                          ; preds = %fast.i, %reuse_cand.i, %slow.i
  %common.ret.op.i = phi ptr [ %cur.i, %fast.i ], [ %cdata.i, %reuse_cand.i ], [ %res.i, %slow.i ]
  %rp_i = ptrtoint ptr %common.ret.op.i to i64
  %rtagged = or disjoint i64 %rp_i, 2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %common.ret.op.i, ptr nonnull align 1 %aptr, i64 %alen, i1 false)
  %dst_b = getelementptr inbounds nuw i8, ptr %common.ret.op.i, i64 %alen
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b, ptr nonnull align 1 %bptr, i64 %blen, i1 false)
  %pref32 = load i32, ptr %common.ret.op.i, align 16
  %pref64 = zext i32 %pref32 to i64
  %pref_sh = shl nuw i64 %pref64, 32
  %w0_out = or disjoint i64 %pref_sh, %tot
  %ls0 = insertvalue %ArchxStr poison, i64 %w0_out, 0
  %ls1 = insertvalue %ArchxStr %ls0, i64 %rtagged, 1
  br label %common.ret
}

; Function Attrs: cold nofree noreturn nounwind
define private fastcc void @archx_oom_fail() unnamed_addr #2 {
entry:
  %puts = tail call i32 @puts(ptr nonnull dereferenceable(1) @str)
  tail call void @exit(i32 101)
  unreachable
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #3

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #4

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #5

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #7

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare ptr @memchr(ptr captures(none), i32, i64) local_unnamed_addr #8

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #3

; Function Attrs: cold nofree noreturn nounwind
declare void @exit(i32) local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #9

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr noundef readonly captures(none)) local_unnamed_addr #3

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #10

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #11

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #11

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v2i64(<2 x i64>) #9

attributes #0 = { nounwind }
attributes #1 = { nofree noinline nounwind }
attributes #2 = { cold nofree noreturn nounwind }
attributes #3 = { nofree nounwind }
attributes #4 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #5 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #6 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" }
attributes #7 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #8 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) }
attributes #9 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #10 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #11 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.isvectorized", i32 1}
!2 = !{!"llvm.loop.unroll.runtime.disable"}
!3 = distinct !{!3, !1, !2}
!4 = distinct !{!4, !1, !2}
!5 = distinct !{!5, !1, !2}
!6 = distinct !{!6, !1, !2}
