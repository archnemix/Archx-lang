; ModuleID = 'benchmarks/nbody_float.c'
source_filename = "benchmarks/nbody_float.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Body = type { double, double, double, double, double, double, double }

@.str = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = tail call noalias dereferenceable_or_null(5600000) ptr @malloc(i64 noundef 5600000) #8
  %2 = icmp eq ptr %1, null
  br i1 %2, label %30, label %3

3:                                                ; preds = %0, %3
  %4 = phi i64 [ %18, %3 ], [ 0, %0 ]
  %5 = phi <2 x i64> [ %19, %3 ], [ <i64 0, i64 1>, %0 ]
  %6 = add nuw nsw <2 x i64> %5, splat (i64 1)
  %7 = uitofp nneg <2 x i64> %6 to <2 x double>
  %8 = getelementptr inbounds nuw %struct.Body, ptr %1, i64 %4
  %9 = fmul <2 x double> %7, splat (double 5.000000e-04)
  %10 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %7, <2 x double> splat (double 1.000000e-04), <2 x double> splat (double 1.000000e+00))
  %11 = shufflevector <2 x double> %7, <2 x double> poison, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
  %12 = fmul <4 x double> %11, <double 1.000000e-03, double 1.000000e-03, double 2.000000e-03, double 2.000000e-03>
  %13 = shufflevector <2 x double> %9, <2 x double> splat (double 1.000000e-02), <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %14 = shufflevector <4 x double> %12, <4 x double> %13, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %15 = shufflevector <2 x double> %10, <2 x double> poison, <4 x i32> <i32 0, i32 1, i32 poison, i32 poison>
  %16 = shufflevector <4 x double> <double -2.000000e-02, double -2.000000e-02, double 5.000000e-03, double 5.000000e-03>, <4 x double> %15, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 poison, i32 poison>
  %17 = shufflevector <8 x double> %14, <8 x double> %16, <14 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13>
  store <14 x double> %17, ptr %8, align 8, !tbaa !5
  %18 = add nuw i64 %4, 2
  %19 = add <2 x i64> %5, splat (i64 2)
  %20 = icmp eq i64 %18, 100000
  br i1 %20, label %21, label %3, !llvm.loop !9

21:                                               ; preds = %3
  %22 = getelementptr inbounds nuw i8, ptr %1, i64 5599888
  %23 = getelementptr inbounds nuw i8, ptr %1, i64 5599904
  %24 = getelementptr inbounds nuw i8, ptr %1, i64 5599912
  %25 = getelementptr inbounds nuw i8, ptr %1, i64 5599928
  %26 = getelementptr inbounds nuw i8, ptr %1, i64 5599944
  %27 = getelementptr inbounds nuw i8, ptr %1, i64 5599960
  %28 = getelementptr inbounds nuw i8, ptr %1, i64 5599968
  %29 = getelementptr inbounds nuw i8, ptr %1, i64 5599984
  br label %31

30:                                               ; preds = %0
  tail call void @abort() #9
  unreachable

31:                                               ; preds = %21, %98
  %32 = phi i64 [ %139, %98 ], [ 0, %21 ]
  br label %33

33:                                               ; preds = %33, %31
  %34 = phi i64 [ 0, %31 ], [ %96, %33 ]
  %35 = getelementptr inbounds nuw %struct.Body, ptr %1, i64 %34
  %36 = getelementptr inbounds nuw %struct.Body, ptr %1, i64 %34
  %37 = getelementptr inbounds nuw i8, ptr %36, i64 56
  %38 = load double, ptr %35, align 8, !tbaa !13
  %39 = load double, ptr %37, align 8, !tbaa !13
  %40 = insertelement <2 x double> poison, double %38, i64 0
  %41 = insertelement <2 x double> %40, double %39, i64 1
  %42 = getelementptr inbounds nuw i8, ptr %35, i64 8
  %43 = getelementptr inbounds nuw i8, ptr %36, i64 64
  %44 = load double, ptr %42, align 8, !tbaa !15
  %45 = load double, ptr %43, align 8, !tbaa !15
  %46 = insertelement <2 x double> poison, double %44, i64 0
  %47 = insertelement <2 x double> %46, double %45, i64 1
  %48 = getelementptr inbounds nuw i8, ptr %35, i64 16
  %49 = getelementptr inbounds nuw i8, ptr %36, i64 72
  %50 = load double, ptr %48, align 8, !tbaa !16
  %51 = load double, ptr %49, align 8, !tbaa !16
  %52 = insertelement <2 x double> poison, double %50, i64 0
  %53 = insertelement <2 x double> %52, double %51, i64 1
  %54 = fmul <2 x double> %47, %47
  %55 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %41, <2 x double> %41, <2 x double> %54)
  %56 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %53, <2 x double> %53, <2 x double> %55)
  %57 = fadd <2 x double> %56, splat (double 1.000000e+00)
  %58 = tail call <2 x double> @llvm.sqrt.v2f64(<2 x double> %57)
  %59 = fdiv <2 x double> splat (double 1.000000e-02), %58
  %60 = getelementptr inbounds nuw i8, ptr %35, i64 24
  %61 = getelementptr inbounds nuw i8, ptr %36, i64 80
  %62 = load double, ptr %60, align 8, !tbaa !17
  %63 = load double, ptr %61, align 8, !tbaa !17
  %64 = insertelement <2 x double> poison, double %62, i64 0
  %65 = insertelement <2 x double> %64, double %63, i64 1
  %66 = fneg <2 x double> %41
  %67 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %66, <2 x double> %59, <2 x double> %65)
  %68 = extractelement <2 x double> %67, i64 0
  store double %68, ptr %60, align 8, !tbaa !17
  %69 = getelementptr inbounds nuw i8, ptr %35, i64 32
  %70 = getelementptr inbounds nuw i8, ptr %36, i64 88
  %71 = load double, ptr %69, align 8, !tbaa !18
  %72 = load double, ptr %70, align 8, !tbaa !18
  %73 = insertelement <2 x double> poison, double %71, i64 0
  %74 = insertelement <2 x double> %73, double %72, i64 1
  %75 = fneg <2 x double> %47
  %76 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %75, <2 x double> %59, <2 x double> %74)
  %77 = extractelement <2 x double> %76, i64 0
  store double %77, ptr %69, align 8, !tbaa !18
  %78 = getelementptr inbounds nuw i8, ptr %35, i64 40
  %79 = getelementptr inbounds nuw i8, ptr %36, i64 96
  %80 = load double, ptr %78, align 8, !tbaa !19
  %81 = load double, ptr %79, align 8, !tbaa !19
  %82 = insertelement <2 x double> poison, double %80, i64 0
  %83 = insertelement <2 x double> %82, double %81, i64 1
  %84 = fneg <2 x double> %53
  %85 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %84, <2 x double> %59, <2 x double> %83)
  %86 = extractelement <2 x double> %85, i64 0
  store double %86, ptr %78, align 8, !tbaa !19
  %87 = shufflevector <2 x double> %76, <2 x double> %85, <2 x i32> <i32 1, i32 3>
  store <2 x double> %87, ptr %70, align 8, !tbaa !5
  %88 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %67, <2 x double> splat (double 1.000000e-02), <2 x double> %41)
  %89 = extractelement <2 x double> %88, i64 0
  store double %89, ptr %35, align 8, !tbaa !13
  %90 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %76, <2 x double> splat (double 1.000000e-02), <2 x double> %47)
  %91 = extractelement <2 x double> %90, i64 0
  store double %91, ptr %42, align 8, !tbaa !15
  %92 = shufflevector <2 x double> %88, <2 x double> %90, <2 x i32> <i32 1, i32 3>
  store <2 x double> %92, ptr %37, align 8, !tbaa !5
  %93 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %85, <2 x double> splat (double 1.000000e-02), <2 x double> %53)
  %94 = extractelement <2 x double> %93, i64 0
  store double %94, ptr %48, align 8, !tbaa !16
  %95 = shufflevector <2 x double> %93, <2 x double> %67, <2 x i32> <i32 1, i32 3>
  store <2 x double> %95, ptr %49, align 8, !tbaa !5
  %96 = add nuw i64 %34, 2
  %97 = icmp eq i64 %96, 99998
  br i1 %97, label %98, label %33, !llvm.loop !20

98:                                               ; preds = %33
  %99 = load double, ptr %23, align 8, !tbaa !16
  %100 = load double, ptr %25, align 8, !tbaa !19
  %101 = fneg double %99
  %102 = load <2 x double>, ptr %22, align 8, !tbaa !5
  %103 = fmul <2 x double> %102, %102
  %104 = extractelement <2 x double> %103, i64 1
  %105 = extractelement <2 x double> %102, i64 0
  %106 = tail call double @llvm.fmuladd.f64(double %105, double %105, double %104)
  %107 = tail call double @llvm.fmuladd.f64(double %99, double %99, double %106)
  %108 = fadd double %107, 1.000000e+00
  %109 = tail call double @llvm.sqrt.f64(double %108)
  %110 = fdiv double 1.000000e-02, %109
  %111 = load <2 x double>, ptr %24, align 8, !tbaa !5
  %112 = fneg <2 x double> %102
  %113 = insertelement <2 x double> poison, double %110, i64 0
  %114 = shufflevector <2 x double> %113, <2 x double> poison, <2 x i32> zeroinitializer
  %115 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %112, <2 x double> %114, <2 x double> %111)
  store <2 x double> %115, ptr %24, align 8, !tbaa !5
  %116 = tail call double @llvm.fmuladd.f64(double %101, double %110, double %100)
  store double %116, ptr %25, align 8, !tbaa !19
  %117 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %115, <2 x double> splat (double 1.000000e-02), <2 x double> %102)
  store <2 x double> %117, ptr %22, align 8, !tbaa !5
  %118 = tail call double @llvm.fmuladd.f64(double %116, double 1.000000e-02, double %99)
  store double %118, ptr %23, align 8, !tbaa !16
  %119 = load double, ptr %27, align 8, !tbaa !16
  %120 = load double, ptr %29, align 8, !tbaa !19
  %121 = fneg double %119
  %122 = load <2 x double>, ptr %26, align 8, !tbaa !5
  %123 = fmul <2 x double> %122, %122
  %124 = extractelement <2 x double> %123, i64 1
  %125 = extractelement <2 x double> %122, i64 0
  %126 = tail call double @llvm.fmuladd.f64(double %125, double %125, double %124)
  %127 = tail call double @llvm.fmuladd.f64(double %119, double %119, double %126)
  %128 = fadd double %127, 1.000000e+00
  %129 = tail call double @llvm.sqrt.f64(double %128)
  %130 = fdiv double 1.000000e-02, %129
  %131 = load <2 x double>, ptr %28, align 8, !tbaa !5
  %132 = fneg <2 x double> %122
  %133 = insertelement <2 x double> poison, double %130, i64 0
  %134 = shufflevector <2 x double> %133, <2 x double> poison, <2 x i32> zeroinitializer
  %135 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %132, <2 x double> %134, <2 x double> %131)
  store <2 x double> %135, ptr %28, align 8, !tbaa !5
  %136 = tail call double @llvm.fmuladd.f64(double %121, double %130, double %120)
  store double %136, ptr %29, align 8, !tbaa !19
  %137 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %135, <2 x double> splat (double 1.000000e-02), <2 x double> %122)
  store <2 x double> %137, ptr %26, align 8, !tbaa !5
  %138 = tail call double @llvm.fmuladd.f64(double %136, double 1.000000e-02, double %119)
  store double %138, ptr %27, align 8, !tbaa !16
  %139 = add nuw nsw i64 %32, 1
  %140 = icmp eq i64 %139, 60
  br i1 %140, label %141, label %31, !llvm.loop !21

141:                                              ; preds = %98, %141
  %142 = phi i64 [ %159, %141 ], [ 0, %98 ]
  %143 = phi double [ %158, %141 ], [ 0.000000e+00, %98 ]
  %144 = getelementptr inbounds nuw %struct.Body, ptr %1, i64 %142
  %145 = getelementptr inbounds nuw i8, ptr %144, i64 48
  %146 = load double, ptr %145, align 8, !tbaa !22
  %147 = fmul double %146, 5.000000e-01
  %148 = getelementptr inbounds nuw i8, ptr %144, i64 24
  %149 = load double, ptr %148, align 8, !tbaa !17
  %150 = getelementptr inbounds nuw i8, ptr %144, i64 32
  %151 = load double, ptr %150, align 8, !tbaa !18
  %152 = fmul double %151, %151
  %153 = tail call double @llvm.fmuladd.f64(double %149, double %149, double %152)
  %154 = getelementptr inbounds nuw i8, ptr %144, i64 40
  %155 = load double, ptr %154, align 8, !tbaa !19
  %156 = tail call double @llvm.fmuladd.f64(double %155, double %155, double %153)
  %157 = fmul double %147, %156
  %158 = fadd double %143, %157
  %159 = add nuw nsw i64 %142, 1
  %160 = icmp eq i64 %159, 100000
  br i1 %160, label %161, label %141, !llvm.loop !23

161:                                              ; preds = %141
  tail call void @free(ptr noundef nonnull %1) #10
  %162 = fmul double %158, 1.000000e+02
  %163 = fptosi double %162 to i64
  %164 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef %163)
  %165 = tail call noalias dereferenceable_or_null(3584) ptr @malloc(i64 noundef 3584) #8
  %166 = icmp eq ptr %165, null
  br i1 %166, label %167, label %168

167:                                              ; preds = %161
  tail call void @abort() #9
  unreachable

168:                                              ; preds = %161, %168
  %169 = phi i64 [ %181, %168 ], [ 0, %161 ]
  %170 = or disjoint i64 %169, 1
  %171 = uitofp nneg i64 %170 to double
  %172 = getelementptr inbounds nuw %struct.Body, ptr %165, i64 %169
  %173 = fmul double %171, 3.000000e-02
  %174 = tail call double @llvm.fmuladd.f64(double %171, double 1.000000e-02, double 5.000000e-01)
  %175 = insertelement <2 x double> poison, double %171, i64 0
  %176 = shufflevector <2 x double> %175, <2 x double> poison, <2 x i32> zeroinitializer
  %177 = fmul <2 x double> %176, <double 1.000000e-01, double -7.000000e-02>
  store <2 x double> %177, ptr %172, align 8, !tbaa !5
  %178 = getelementptr inbounds nuw i8, ptr %172, i64 16
  store double %173, ptr %178, align 8, !tbaa !5
  %179 = getelementptr inbounds nuw i8, ptr %172, i64 24
  %180 = getelementptr inbounds nuw i8, ptr %172, i64 48
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %179, i8 0, i64 24, i1 false)
  store double %174, ptr %180, align 8, !tbaa !5
  %181 = add nuw nsw i64 %169, 2
  %182 = uitofp nneg i64 %181 to double
  %183 = getelementptr inbounds nuw %struct.Body, ptr %165, i64 %170
  %184 = fmul double %182, 3.000000e-02
  %185 = tail call double @llvm.fmuladd.f64(double %182, double 1.000000e-02, double 5.000000e-01)
  %186 = insertelement <2 x double> poison, double %182, i64 0
  %187 = shufflevector <2 x double> %186, <2 x double> poison, <2 x i32> zeroinitializer
  %188 = fmul <2 x double> %187, <double 1.000000e-01, double -7.000000e-02>
  store <2 x double> %188, ptr %183, align 8, !tbaa !5
  %189 = getelementptr inbounds nuw i8, ptr %183, i64 16
  store double %184, ptr %189, align 8, !tbaa !5
  %190 = getelementptr inbounds nuw i8, ptr %183, i64 24
  %191 = getelementptr inbounds nuw i8, ptr %183, i64 48
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %190, i8 0, i64 24, i1 false)
  store double %185, ptr %191, align 8, !tbaa !5
  %192 = icmp eq i64 %181, 64
  br i1 %192, label %193, label %168, !llvm.loop !24

193:                                              ; preds = %168, %238
  %194 = phi i64 [ %239, %238 ], [ 0, %168 ]
  br label %195

195:                                              ; preds = %201, %193
  %196 = phi i64 [ 0, %193 ], [ %208, %201 ]
  %197 = getelementptr inbounds nuw %struct.Body, ptr %165, i64 %196
  %198 = load <2 x double>, ptr %197, align 8, !tbaa !5
  %199 = getelementptr inbounds nuw i8, ptr %197, i64 16
  %200 = load double, ptr %199, align 8, !tbaa !16
  br label %210

201:                                              ; preds = %210
  %202 = getelementptr inbounds nuw i8, ptr %197, i64 24
  %203 = load <2 x double>, ptr %202, align 8, !tbaa !5
  %204 = fadd <2 x double> %234, %203
  store <2 x double> %204, ptr %202, align 8, !tbaa !5
  %205 = getelementptr inbounds nuw i8, ptr %197, i64 40
  %206 = load double, ptr %205, align 8, !tbaa !19
  %207 = fadd double %235, %206
  store double %207, ptr %205, align 8, !tbaa !19
  %208 = add nuw nsw i64 %196, 1
  %209 = icmp eq i64 %208, 64
  br i1 %209, label %241, label %195, !llvm.loop !25

210:                                              ; preds = %210, %195
  %211 = phi i64 [ 0, %195 ], [ %236, %210 ]
  %212 = phi double [ 0.000000e+00, %195 ], [ %235, %210 ]
  %213 = phi <2 x double> [ zeroinitializer, %195 ], [ %234, %210 ]
  %214 = getelementptr inbounds nuw %struct.Body, ptr %165, i64 %211
  %215 = load <2 x double>, ptr %214, align 8, !tbaa !5
  %216 = fsub <2 x double> %215, %198
  %217 = getelementptr inbounds nuw i8, ptr %214, i64 16
  %218 = load double, ptr %217, align 8, !tbaa !16
  %219 = fsub double %218, %200
  %220 = fmul <2 x double> %216, %216
  %221 = extractelement <2 x double> %220, i64 1
  %222 = extractelement <2 x double> %216, i64 0
  %223 = tail call double @llvm.fmuladd.f64(double %222, double %222, double %221)
  %224 = tail call double @llvm.fmuladd.f64(double %219, double %219, double %223)
  %225 = fadd double %224, 5.000000e-02
  %226 = getelementptr inbounds nuw i8, ptr %214, i64 48
  %227 = load double, ptr %226, align 8, !tbaa !22
  %228 = fmul double %227, 5.000000e-03
  %229 = tail call double @llvm.sqrt.f64(double %225)
  %230 = fmul double %225, %229
  %231 = fdiv double %228, %230
  %232 = insertelement <2 x double> poison, double %231, i64 0
  %233 = shufflevector <2 x double> %232, <2 x double> poison, <2 x i32> zeroinitializer
  %234 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %216, <2 x double> %233, <2 x double> %213)
  %235 = tail call double @llvm.fmuladd.f64(double %219, double %231, double %212)
  %236 = add nuw nsw i64 %211, 1
  %237 = icmp eq i64 %236, 64
  br i1 %237, label %201, label %210, !llvm.loop !26

238:                                              ; preds = %241
  %239 = add nuw nsw i64 %194, 1
  %240 = icmp eq i64 %239, 2000
  br i1 %240, label %266, label %193, !llvm.loop !27

241:                                              ; preds = %201, %241
  %242 = phi i64 [ %264, %241 ], [ 0, %201 ]
  %243 = getelementptr inbounds nuw %struct.Body, ptr %165, i64 %242
  %244 = getelementptr inbounds nuw i8, ptr %243, i64 24
  %245 = load <2 x double>, ptr %244, align 8, !tbaa !5
  %246 = load <2 x double>, ptr %243, align 8, !tbaa !5
  %247 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %245, <2 x double> splat (double 5.000000e-03), <2 x double> %246)
  store <2 x double> %247, ptr %243, align 8, !tbaa !5
  %248 = getelementptr inbounds nuw i8, ptr %243, i64 40
  %249 = load double, ptr %248, align 8, !tbaa !19
  %250 = getelementptr inbounds nuw i8, ptr %243, i64 16
  %251 = load double, ptr %250, align 8, !tbaa !16
  %252 = tail call double @llvm.fmuladd.f64(double %249, double 5.000000e-03, double %251)
  store double %252, ptr %250, align 8, !tbaa !16
  %253 = getelementptr inbounds nuw %struct.Body, ptr %165, i64 %242
  %254 = getelementptr inbounds nuw i8, ptr %253, i64 56
  %255 = getelementptr inbounds nuw i8, ptr %253, i64 80
  %256 = load <2 x double>, ptr %255, align 8, !tbaa !5
  %257 = load <2 x double>, ptr %254, align 8, !tbaa !5
  %258 = tail call <2 x double> @llvm.fmuladd.v2f64(<2 x double> %256, <2 x double> splat (double 5.000000e-03), <2 x double> %257)
  store <2 x double> %258, ptr %254, align 8, !tbaa !5
  %259 = getelementptr inbounds nuw i8, ptr %253, i64 96
  %260 = load double, ptr %259, align 8, !tbaa !19
  %261 = getelementptr inbounds nuw i8, ptr %253, i64 72
  %262 = load double, ptr %261, align 8, !tbaa !16
  %263 = tail call double @llvm.fmuladd.f64(double %260, double 5.000000e-03, double %262)
  store double %263, ptr %261, align 8, !tbaa !16
  %264 = add nuw nsw i64 %242, 2
  %265 = icmp eq i64 %264, 64
  br i1 %265, label %238, label %241, !llvm.loop !28

266:                                              ; preds = %238, %266
  %267 = phi i64 [ %284, %266 ], [ 0, %238 ]
  %268 = phi double [ %283, %266 ], [ 0.000000e+00, %238 ]
  %269 = getelementptr inbounds nuw %struct.Body, ptr %165, i64 %267
  %270 = getelementptr inbounds nuw i8, ptr %269, i64 48
  %271 = load double, ptr %270, align 8, !tbaa !22
  %272 = fmul double %271, 5.000000e-01
  %273 = getelementptr inbounds nuw i8, ptr %269, i64 24
  %274 = load double, ptr %273, align 8, !tbaa !17
  %275 = getelementptr inbounds nuw i8, ptr %269, i64 32
  %276 = load double, ptr %275, align 8, !tbaa !18
  %277 = fmul double %276, %276
  %278 = tail call double @llvm.fmuladd.f64(double %274, double %274, double %277)
  %279 = getelementptr inbounds nuw i8, ptr %269, i64 40
  %280 = load double, ptr %279, align 8, !tbaa !19
  %281 = tail call double @llvm.fmuladd.f64(double %280, double %280, double %278)
  %282 = fmul double %272, %281
  %283 = fadd double %268, %282
  %284 = add nuw nsw i64 %267, 1
  %285 = icmp eq i64 %284, 64
  br i1 %285, label %286, label %266, !llvm.loop !29

286:                                              ; preds = %266
  tail call void @free(ptr noundef nonnull %165) #10
  %287 = fmul double %283, 1.000000e+04
  %288 = fptosi double %287 to i64
  %289 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str, i64 noundef %288)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #1

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #2

; Function Attrs: cold nofree noreturn nounwind
declare void @abort() local_unnamed_addr #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fmuladd.f64(double, double, double) #4

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sqrt.f64(double) #6

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x double> @llvm.fmuladd.v2f64(<2 x double>, <2 x double>, <2 x double>) #6

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <2 x double> @llvm.sqrt.v2f64(<2 x double>) #6

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { cold nofree noreturn nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #8 = { nounwind allocsize(0) }
attributes #9 = { cold noreturn nounwind }
attributes #10 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"double", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10, !11, !12}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.isvectorized", i32 1}
!12 = !{!"llvm.loop.unroll.runtime.disable"}
!13 = !{!14, !6, i64 0}
!14 = !{!"", !6, i64 0, !6, i64 8, !6, i64 16, !6, i64 24, !6, i64 32, !6, i64 40, !6, i64 48}
!15 = !{!14, !6, i64 8}
!16 = !{!14, !6, i64 16}
!17 = !{!14, !6, i64 24}
!18 = !{!14, !6, i64 32}
!19 = !{!14, !6, i64 40}
!20 = distinct !{!20, !10, !11, !12}
!21 = distinct !{!21, !10}
!22 = !{!14, !6, i64 48}
!23 = distinct !{!23, !10}
!24 = distinct !{!24, !10}
!25 = distinct !{!25, !10}
!26 = distinct !{!26, !10}
!27 = distinct !{!27, !10}
!28 = distinct !{!28, !10}
!29 = distinct !{!29, !10}
