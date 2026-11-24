; ModuleID = 'benchmarks/dict_bench.c'
source_filename = "benchmarks/dict_bench.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.StrMap = type { ptr, i64, i64 }
%struct.IntMap = type { ptr, i64, i64, i64 }
%struct.StrEntry = type { ptr, i64, i8 }
%struct.IntEntry = type { i64, i64, i8 }

@.str = private unnamed_addr constant [7 x i8] c"tok_%d\00", align 1
@.str.1 = private unnamed_addr constant [20 x i8] c"identifier_token_%d\00", align 1
@.str.2 = private unnamed_addr constant [18 x i8] c"missing_token_xyz\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"%ld\0A%ld\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local noundef i32 @main() local_unnamed_addr #0 {
  %1 = alloca [1024 x ptr], align 16
  %2 = alloca %struct.StrMap, align 8
  %3 = alloca %struct.IntMap, align 8
  call void @llvm.lifetime.start.p0(i64 8192, ptr nonnull %1) #10
  br label %7

4:                                                ; preds = %7
  %5 = getelementptr inbounds nuw i8, ptr %2, i64 8
  %6 = getelementptr inbounds nuw i8, ptr %2, i64 16
  br label %22

7:                                                ; preds = %0, %7
  %8 = phi i64 [ 0, %0 ], [ %16, %7 ]
  %9 = tail call noalias dereferenceable_or_null(32) ptr @malloc(i64 noundef 32) #11
  %10 = getelementptr inbounds nuw [1024 x ptr], ptr %1, i64 0, i64 %8
  store ptr %9, ptr %10, align 8, !tbaa !5
  %11 = trunc nuw nsw i64 %8 to i32
  %12 = and i32 %11, 1
  %13 = icmp eq i32 %12, 0
  %14 = select i1 %13, ptr @.str, ptr @.str.1
  %15 = tail call i32 (ptr, ptr, ...) @sprintf(ptr noundef nonnull dereferenceable(1) %9, ptr noundef nonnull dereferenceable(1) %14, i32 noundef %11) #10
  %16 = add nuw nsw i64 %8, 1
  %17 = icmp eq i64 %16, 1024
  br i1 %17, label %4, label %7, !llvm.loop !10

18:                                               ; preds = %161
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %3) #10
  %19 = getelementptr inbounds nuw i8, ptr %3, i64 8
  store i64 8, ptr %19, align 8, !tbaa !12
  %20 = getelementptr inbounds nuw i8, ptr %3, i64 16
  %21 = tail call noalias dereferenceable_or_null(192) ptr @calloc(i64 noundef 8, i64 noundef 24) #12
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %20, i8 0, i64 16, i1 false)
  store ptr %21, ptr %3, align 8, !tbaa !15
  br label %214

22:                                               ; preds = %4, %161
  %23 = phi i64 [ 0, %4 ], [ %162, %161 ]
  %24 = phi i64 [ 0, %4 ], [ %163, %161 ]
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %2) #10
  store i64 8, ptr %5, align 8, !tbaa !16
  store i64 0, ptr %6, align 8, !tbaa !18
  %25 = tail call noalias dereferenceable_or_null(192) ptr @calloc(i64 noundef 8, i64 noundef 24) #12
  store ptr %25, ptr %2, align 8, !tbaa !19
  br label %28

26:                                               ; preds = %28
  %27 = mul nuw nsw i64 %24, 19
  br label %40

28:                                               ; preds = %22, %28
  %29 = phi i64 [ 0, %22 ], [ %33, %28 ]
  %30 = getelementptr inbounds nuw [1024 x ptr], ptr %1, i64 0, i64 %29
  %31 = load ptr, ptr %30, align 8, !tbaa !5
  %32 = call fastcc ptr @strmap_upsert(ptr noundef %2, ptr noundef %31)
  store i64 1, ptr %32, align 8, !tbaa !20
  %33 = add nuw nsw i64 %29, 1
  %34 = icmp eq i64 %33, 1024
  br i1 %34, label %26, label %28, !llvm.loop !21

35:                                               ; preds = %40
  %36 = mul nuw nsw i64 %24, 7
  %37 = load i64, ptr %5, align 8, !tbaa !16
  %38 = add i64 %37, -1
  %39 = load ptr, ptr %2, align 8, !tbaa !19
  br label %75

40:                                               ; preds = %26, %40
  %41 = phi i64 [ 0, %26 ], [ %54, %40 ]
  %42 = mul nuw nsw i64 %41, 73
  %43 = add nuw nsw i64 %42, %27
  %44 = and i64 %43, 1023
  %45 = getelementptr inbounds nuw [1024 x ptr], ptr %1, i64 0, i64 %44
  %46 = load ptr, ptr %45, align 8, !tbaa !5
  %47 = call fastcc ptr @strmap_upsert(ptr noundef %2, ptr noundef %46)
  %48 = load i64, ptr %47, align 8, !tbaa !20
  %49 = trunc nuw nsw i64 %41 to i16
  %50 = urem i16 %49, 7
  %51 = add nuw nsw i16 %50, 1
  %52 = zext nneg i16 %51 to i64
  %53 = add i64 %48, %52
  store i64 %53, ptr %47, align 8, !tbaa !20
  %54 = add nuw nsw i64 %41, 1
  %55 = icmp eq i64 %54, 8192
  br i1 %55, label %35, label %40, !llvm.loop !22

56:                                               ; preds = %119
  %57 = and i64 %38, -1846765514441464167
  %58 = getelementptr inbounds nuw %struct.StrEntry, ptr %39, i64 %57
  %59 = getelementptr inbounds nuw i8, ptr %58, i64 16
  %60 = load i8, ptr %59, align 8, !tbaa !23
  %61 = icmp eq i8 %60, 1
  br i1 %61, label %69, label %139

62:                                               ; preds = %69
  %63 = add i64 %71, 1
  %64 = and i64 %63, %38
  %65 = getelementptr inbounds nuw %struct.StrEntry, ptr %39, i64 %64
  %66 = getelementptr inbounds nuw i8, ptr %65, i64 16
  %67 = load i8, ptr %66, align 8, !tbaa !23
  %68 = icmp eq i8 %67, 1
  br i1 %68, label %69, label %130, !llvm.loop !25

69:                                               ; preds = %56, %62
  %70 = phi ptr [ %65, %62 ], [ %58, %56 ]
  %71 = phi i64 [ %64, %62 ], [ %57, %56 ]
  %72 = load ptr, ptr %70, align 8, !tbaa !26
  %73 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %72, ptr noundef nonnull dereferenceable(18) @.str.2) #13
  %74 = icmp eq i32 %73, 0
  br i1 %74, label %142, label %62

75:                                               ; preds = %35, %119
  %76 = phi i64 [ %23, %35 ], [ %120, %119 ]
  %77 = phi i64 [ 0, %35 ], [ %121, %119 ]
  %78 = mul nuw nsw i64 %77, 131
  %79 = add nuw nsw i64 %78, %36
  %80 = and i64 %79, 1023
  %81 = getelementptr inbounds nuw [1024 x ptr], ptr %1, i64 0, i64 %80
  %82 = load ptr, ptr %81, align 8, !tbaa !5
  %83 = load i8, ptr %82, align 1, !tbaa !27
  %84 = icmp eq i8 %83, 0
  br i1 %84, label %95, label %85

85:                                               ; preds = %75, %85
  %86 = phi i8 [ %93, %85 ], [ %83, %75 ]
  %87 = phi ptr [ %92, %85 ], [ %82, %75 ]
  %88 = phi i64 [ %91, %85 ], [ -3750763034362895579, %75 ]
  %89 = zext i8 %86 to i64
  %90 = xor i64 %88, %89
  %91 = mul i64 %90, 1099511628211
  %92 = getelementptr inbounds nuw i8, ptr %87, i64 1
  %93 = load i8, ptr %92, align 1, !tbaa !27
  %94 = icmp eq i8 %93, 0
  br i1 %94, label %95, label %85, !llvm.loop !28

95:                                               ; preds = %85, %75
  %96 = phi i64 [ -3750763034362895579, %75 ], [ %91, %85 ]
  %97 = and i64 %96, %38
  %98 = getelementptr inbounds nuw %struct.StrEntry, ptr %39, i64 %97
  %99 = getelementptr inbounds nuw i8, ptr %98, i64 16
  %100 = load i8, ptr %99, align 8, !tbaa !23
  %101 = icmp eq i8 %100, 1
  br i1 %101, label %109, label %119

102:                                              ; preds = %109
  %103 = add i64 %111, 1
  %104 = and i64 %103, %38
  %105 = getelementptr inbounds nuw %struct.StrEntry, ptr %39, i64 %104
  %106 = getelementptr inbounds nuw i8, ptr %105, i64 16
  %107 = load i8, ptr %106, align 8, !tbaa !23
  %108 = icmp eq i8 %107, 1
  br i1 %108, label %109, label %119, !llvm.loop !25

109:                                              ; preds = %95, %102
  %110 = phi ptr [ %105, %102 ], [ %98, %95 ]
  %111 = phi i64 [ %104, %102 ], [ %97, %95 ]
  %112 = load ptr, ptr %110, align 8, !tbaa !26
  %113 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %112, ptr noundef nonnull readonly dereferenceable(1) %82) #13
  %114 = icmp eq i32 %113, 0
  br i1 %114, label %115, label %102

115:                                              ; preds = %109
  %116 = getelementptr inbounds nuw i8, ptr %110, i64 8
  %117 = load i64, ptr %116, align 8, !tbaa !20
  %118 = add nsw i64 %117, %76
  br label %119

119:                                              ; preds = %102, %95, %115
  %120 = phi i64 [ %118, %115 ], [ %76, %95 ], [ %76, %102 ]
  %121 = add nuw nsw i64 %77, 1
  %122 = icmp eq i64 %121, 2048
  br i1 %122, label %56, label %75, !llvm.loop !29

123:                                              ; preds = %130
  %124 = add i64 %132, 1
  %125 = and i64 %124, %38
  %126 = getelementptr inbounds nuw %struct.StrEntry, ptr %39, i64 %125
  %127 = getelementptr inbounds nuw i8, ptr %126, i64 16
  %128 = load i8, ptr %127, align 8, !tbaa !23
  %129 = icmp eq i8 %128, 1
  br i1 %129, label %130, label %139, !llvm.loop !25

130:                                              ; preds = %62, %123
  %131 = phi ptr [ %126, %123 ], [ %58, %62 ]
  %132 = phi i64 [ %125, %123 ], [ %57, %62 ]
  %133 = load ptr, ptr %131, align 8, !tbaa !26
  %134 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %133, ptr noundef nonnull dereferenceable(18) @.str.2) #13
  %135 = icmp eq i32 %134, 0
  br i1 %135, label %136, label %123

136:                                              ; preds = %130
  %137 = getelementptr inbounds nuw i8, ptr %131, i64 8
  %138 = load i64, ptr %137, align 8, !tbaa !20
  br label %139

139:                                              ; preds = %123, %56, %136
  %140 = phi i64 [ %138, %136 ], [ 3, %56 ], [ 3, %123 ]
  %141 = add nsw i64 %140, %120
  br label %142

142:                                              ; preds = %69, %139
  %143 = phi i64 [ %141, %139 ], [ %120, %69 ]
  %144 = icmp eq i64 %37, 0
  br i1 %144, label %161, label %145

145:                                              ; preds = %142
  %146 = and i64 %37, 1
  %147 = icmp eq i64 %37, 1
  br i1 %147, label %192, label %148

148:                                              ; preds = %145
  %149 = and i64 %37, -2
  br label %165

150:                                              ; preds = %206, %158
  %151 = phi i64 [ %159, %158 ], [ 0, %206 ]
  %152 = getelementptr inbounds nuw %struct.StrEntry, ptr %39, i64 %151
  %153 = getelementptr inbounds nuw i8, ptr %152, i64 16
  %154 = load i8, ptr %153, align 8, !tbaa !23
  %155 = icmp eq i8 %154, 1
  br i1 %155, label %156, label %158

156:                                              ; preds = %150
  %157 = load ptr, ptr %152, align 8, !tbaa !26
  tail call void @free(ptr noundef %157) #10
  br label %158

158:                                              ; preds = %156, %150
  %159 = add nuw i64 %151, 1
  %160 = icmp eq i64 %159, %37
  br i1 %160, label %161, label %150, !llvm.loop !30

161:                                              ; preds = %158, %142
  %162 = phi i64 [ %143, %142 ], [ %207, %158 ]
  tail call void @free(ptr noundef %39) #10
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %2) #10
  %163 = add nuw nsw i64 %24, 1
  %164 = icmp eq i64 %163, 120
  br i1 %164, label %18, label %22, !llvm.loop !31

165:                                              ; preds = %187, %148
  %166 = phi i64 [ %143, %148 ], [ %188, %187 ]
  %167 = phi i64 [ 0, %148 ], [ %189, %187 ]
  %168 = phi i64 [ 0, %148 ], [ %190, %187 ]
  %169 = getelementptr inbounds nuw %struct.StrEntry, ptr %39, i64 %167
  %170 = getelementptr inbounds nuw i8, ptr %169, i64 16
  %171 = load i8, ptr %170, align 8, !tbaa !23
  %172 = icmp eq i8 %171, 1
  br i1 %172, label %173, label %177

173:                                              ; preds = %165
  %174 = getelementptr inbounds nuw i8, ptr %169, i64 8
  %175 = load i64, ptr %174, align 8, !tbaa !32
  %176 = add nsw i64 %175, %166
  br label %177

177:                                              ; preds = %165, %173
  %178 = phi i64 [ %176, %173 ], [ %166, %165 ]
  %179 = getelementptr inbounds nuw %struct.StrEntry, ptr %39, i64 %167
  %180 = getelementptr inbounds nuw i8, ptr %179, i64 40
  %181 = load i8, ptr %180, align 8, !tbaa !23
  %182 = icmp eq i8 %181, 1
  br i1 %182, label %183, label %187

183:                                              ; preds = %177
  %184 = getelementptr inbounds nuw i8, ptr %179, i64 32
  %185 = load i64, ptr %184, align 8, !tbaa !32
  %186 = add nsw i64 %185, %178
  br label %187

187:                                              ; preds = %183, %177
  %188 = phi i64 [ %186, %183 ], [ %178, %177 ]
  %189 = add nuw i64 %167, 2
  %190 = add i64 %168, 2
  %191 = icmp eq i64 %190, %149
  br i1 %191, label %192, label %165, !llvm.loop !33

192:                                              ; preds = %187, %145
  %193 = phi i64 [ poison, %145 ], [ %188, %187 ]
  %194 = phi i64 [ %143, %145 ], [ %188, %187 ]
  %195 = phi i64 [ 0, %145 ], [ %189, %187 ]
  %196 = icmp eq i64 %146, 0
  br i1 %196, label %206, label %197

197:                                              ; preds = %192
  %198 = getelementptr inbounds nuw %struct.StrEntry, ptr %39, i64 %195
  %199 = getelementptr inbounds nuw i8, ptr %198, i64 16
  %200 = load i8, ptr %199, align 8, !tbaa !23
  %201 = icmp eq i8 %200, 1
  br i1 %201, label %202, label %206

202:                                              ; preds = %197
  %203 = getelementptr inbounds nuw i8, ptr %198, i64 8
  %204 = load i64, ptr %203, align 8, !tbaa !32
  %205 = add nsw i64 %204, %194
  br label %206

206:                                              ; preds = %197, %202, %192
  %207 = phi i64 [ %193, %192 ], [ %205, %202 ], [ %194, %197 ]
  br label %150

208:                                              ; preds = %214
  %209 = load i64, ptr %19, align 8, !tbaa !12
  %210 = add i64 %209, -1
  %211 = load ptr, ptr %3, align 8, !tbaa !15
  %212 = load i64, ptr %20, align 8
  %213 = add i64 %212, -8192
  br label %226

214:                                              ; preds = %18, %214
  %215 = phi i64 [ 0, %18 ], [ %223, %214 ]
  %216 = mul nuw nsw i64 %215, 17
  %217 = add nuw nsw i64 %216, 3
  %218 = trunc nuw nsw i64 %215 to i32
  %219 = mul nuw nsw i32 %218, 31
  %220 = add nuw nsw i32 %219, 7
  %221 = urem i32 %220, 100000
  %222 = zext nneg i32 %221 to i64
  call fastcc void @intmap_put(ptr noundef %3, i64 noundef %217, i64 noundef %222)
  %223 = add nuw nsw i64 %215, 1
  %224 = icmp eq i64 %223, 32768
  br i1 %224, label %208, label %214, !llvm.loop !34

225:                                              ; preds = %246
  store i64 %213, ptr %20, align 8
  br label %259

226:                                              ; preds = %208, %246
  %227 = phi i64 [ 0, %208 ], [ %251, %246 ]
  %228 = phi i64 [ 0, %208 ], [ %250, %246 ]
  %229 = mul nuw nsw i64 %227, 17
  %230 = or disjoint i64 %229, 3
  %231 = mul i64 %230, -49064778989728563
  %232 = lshr i64 %231, 33
  %233 = xor i64 %232, %231
  br label %234

234:                                              ; preds = %243, %226
  %235 = phi i64 [ %233, %226 ], [ %244, %243 ]
  %236 = and i64 %235, %210
  %237 = getelementptr inbounds nuw %struct.IntEntry, ptr %211, i64 %236
  %238 = getelementptr inbounds nuw i8, ptr %237, i64 16
  %239 = load i8, ptr %238, align 8, !tbaa !35
  switch i8 %239, label %243 [
    i8 0, label %245
    i8 1, label %240
  ]

240:                                              ; preds = %234
  %241 = load i64, ptr %237, align 8, !tbaa !37
  %242 = icmp eq i64 %241, %230
  br i1 %242, label %246, label %243

243:                                              ; preds = %240, %234
  %244 = add i64 %236, 1
  br label %234, !llvm.loop !38

245:                                              ; preds = %234
  tail call void @abort() #14
  unreachable

246:                                              ; preds = %240
  %247 = getelementptr inbounds nuw i8, ptr %237, i64 16
  %248 = getelementptr inbounds nuw i8, ptr %237, i64 8
  %249 = load i64, ptr %248, align 8, !tbaa !39
  store i8 2, ptr %247, align 8, !tbaa !35
  %250 = add nsw i64 %249, %228
  %251 = add nuw nsw i64 %227, 4
  %252 = icmp samesign ult i64 %227, 32764
  br i1 %252, label %226, label %225, !llvm.loop !40

253:                                              ; preds = %259
  %254 = load i64, ptr %20, align 8, !tbaa !41
  %255 = add nsw i64 %254, %250
  %256 = load i64, ptr %19, align 8, !tbaa !12
  %257 = icmp eq i64 %256, 0
  %258 = load ptr, ptr %3, align 8
  br label %267

259:                                              ; preds = %225, %259
  %260 = phi i64 [ 0, %225 ], [ %265, %259 ]
  %261 = mul nuw nsw i64 %260, 13
  %262 = add nuw nsw i64 %261, 1000000
  %263 = mul nuw nsw i64 %260, 5
  %264 = add nuw nsw i64 %263, 1
  call fastcc void @intmap_put(ptr noundef %3, i64 noundef %262, i64 noundef %264)
  %265 = add nuw nsw i64 %260, 1
  %266 = icmp eq i64 %265, 8192
  br i1 %266, label %253, label %259, !llvm.loop !42

267:                                              ; preds = %253, %271
  %268 = phi i32 [ 0, %253 ], [ %273, %271 ]
  %269 = phi i64 [ %255, %253 ], [ %272, %271 ]
  br i1 %257, label %271, label %275

270:                                              ; preds = %271
  tail call void @free(ptr noundef %258) #10
  br label %295

271:                                              ; preds = %289, %267
  %272 = phi i64 [ %269, %267 ], [ %290, %289 ]
  %273 = add nuw nsw i32 %268, 1
  %274 = icmp eq i32 %273, 40
  br i1 %274, label %270, label %267, !llvm.loop !43

275:                                              ; preds = %267, %289
  %276 = phi i64 [ %291, %289 ], [ 0, %267 ]
  %277 = phi i64 [ %290, %289 ], [ %269, %267 ]
  %278 = getelementptr inbounds nuw %struct.IntEntry, ptr %258, i64 %276
  %279 = getelementptr inbounds nuw i8, ptr %278, i64 16
  %280 = load i8, ptr %279, align 8, !tbaa !35
  %281 = icmp eq i8 %280, 1
  br i1 %281, label %282, label %289

282:                                              ; preds = %275
  %283 = load i64, ptr %278, align 8, !tbaa !37
  %284 = srem i64 %283, 997
  %285 = getelementptr inbounds nuw i8, ptr %278, i64 8
  %286 = load i64, ptr %285, align 8, !tbaa !39
  %287 = mul nsw i64 %284, %286
  %288 = add nsw i64 %287, %277
  br label %289

289:                                              ; preds = %275, %282
  %290 = phi i64 [ %288, %282 ], [ %277, %275 ]
  %291 = add nuw i64 %276, 1
  %292 = icmp eq i64 %291, %256
  br i1 %292, label %271, label %275, !llvm.loop !44

293:                                              ; preds = %295
  %294 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.3, i64 noundef %162, i64 noundef %272)
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %3) #10
  call void @llvm.lifetime.end.p0(i64 8192, ptr nonnull %1) #10
  ret i32 0

295:                                              ; preds = %270, %295
  %296 = phi i64 [ 0, %270 ], [ %299, %295 ]
  %297 = getelementptr inbounds nuw [1024 x ptr], ptr %1, i64 0, i64 %296
  %298 = load ptr, ptr %297, align 8, !tbaa !5
  tail call void @free(ptr noundef %298) #10
  %299 = add nuw nsw i64 %296, 1
  %300 = icmp eq i64 %299, 1024
  br i1 %300, label %293, label %295, !llvm.loop !45
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #2

; Function Attrs: nofree nounwind
declare noundef i32 @sprintf(ptr noalias noundef writeonly captures(none), ptr noundef readonly captures(none), ...) local_unnamed_addr #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #1

; Function Attrs: nounwind uwtable
define internal fastcc nonnull ptr @strmap_upsert(ptr noundef nonnull captures(none) %0, ptr noundef readonly captures(none) %1) unnamed_addr #0 {
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %4 = load i64, ptr %3, align 8, !tbaa !18
  %5 = mul i64 %4, 10
  %6 = add i64 %5, 10
  %7 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %8 = load i64, ptr %7, align 8, !tbaa !16
  %9 = mul i64 %8, 7
  %10 = icmp ult i64 %6, %9
  br i1 %10, label %54, label %11

11:                                               ; preds = %2
  %12 = shl i64 %8, 1
  %13 = load ptr, ptr %0, align 8, !tbaa !19
  %14 = tail call noalias ptr @calloc(i64 noundef %12, i64 noundef 24) #12
  store ptr %14, ptr %0, align 8, !tbaa !19
  store i64 %12, ptr %7, align 8, !tbaa !16
  %15 = add i64 %12, -1
  %16 = icmp eq i64 %8, 0
  br i1 %16, label %52, label %17

17:                                               ; preds = %11, %49
  %18 = phi i64 [ %50, %49 ], [ 0, %11 ]
  %19 = getelementptr inbounds nuw %struct.StrEntry, ptr %13, i64 %18
  %20 = getelementptr inbounds nuw i8, ptr %19, i64 16
  %21 = load i8, ptr %20, align 8, !tbaa !23
  %22 = icmp eq i8 %21, 1
  br i1 %22, label %23, label %49

23:                                               ; preds = %17
  %24 = load ptr, ptr %19, align 8, !tbaa !26
  %25 = load i8, ptr %24, align 1, !tbaa !27
  %26 = icmp eq i8 %25, 0
  br i1 %26, label %37, label %27

27:                                               ; preds = %23, %27
  %28 = phi i8 [ %35, %27 ], [ %25, %23 ]
  %29 = phi ptr [ %34, %27 ], [ %24, %23 ]
  %30 = phi i64 [ %33, %27 ], [ -3750763034362895579, %23 ]
  %31 = zext i8 %28 to i64
  %32 = xor i64 %30, %31
  %33 = mul i64 %32, 1099511628211
  %34 = getelementptr inbounds nuw i8, ptr %29, i64 1
  %35 = load i8, ptr %34, align 1, !tbaa !27
  %36 = icmp eq i8 %35, 0
  br i1 %36, label %37, label %27, !llvm.loop !28

37:                                               ; preds = %27, %23
  %38 = phi i64 [ -3750763034362895579, %23 ], [ %33, %27 ]
  %39 = load ptr, ptr %0, align 8, !tbaa !19
  br label %40

40:                                               ; preds = %40, %37
  %41 = phi i64 [ %38, %37 ], [ %47, %40 ]
  %42 = and i64 %41, %15
  %43 = getelementptr inbounds nuw %struct.StrEntry, ptr %39, i64 %42
  %44 = getelementptr inbounds nuw i8, ptr %43, i64 16
  %45 = load i8, ptr %44, align 8, !tbaa !23
  %46 = icmp eq i8 %45, 1
  %47 = add i64 %42, 1
  br i1 %46, label %40, label %48, !llvm.loop !46

48:                                               ; preds = %40
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %43, ptr noundef nonnull align 8 dereferenceable(24) %19, i64 24, i1 false), !tbaa.struct !47
  br label %49

49:                                               ; preds = %48, %17
  %50 = add nuw i64 %18, 1
  %51 = icmp eq i64 %50, %8
  br i1 %51, label %52, label %17, !llvm.loop !48

52:                                               ; preds = %49, %11
  tail call void @free(ptr noundef %13) #10
  %53 = load i64, ptr %7, align 8, !tbaa !16
  br label %54

54:                                               ; preds = %52, %2
  %55 = phi i64 [ %53, %52 ], [ %8, %2 ]
  %56 = add i64 %55, -1
  %57 = load i8, ptr %1, align 1, !tbaa !27
  %58 = icmp eq i8 %57, 0
  br i1 %58, label %69, label %59

59:                                               ; preds = %54, %59
  %60 = phi i8 [ %67, %59 ], [ %57, %54 ]
  %61 = phi ptr [ %66, %59 ], [ %1, %54 ]
  %62 = phi i64 [ %65, %59 ], [ -3750763034362895579, %54 ]
  %63 = zext i8 %60 to i64
  %64 = xor i64 %62, %63
  %65 = mul i64 %64, 1099511628211
  %66 = getelementptr inbounds nuw i8, ptr %61, i64 1
  %67 = load i8, ptr %66, align 1, !tbaa !27
  %68 = icmp eq i8 %67, 0
  br i1 %68, label %69, label %59, !llvm.loop !28

69:                                               ; preds = %59, %54
  %70 = phi i64 [ -3750763034362895579, %54 ], [ %65, %59 ]
  %71 = load ptr, ptr %0, align 8, !tbaa !19
  %72 = and i64 %70, %56
  %73 = getelementptr inbounds nuw %struct.StrEntry, ptr %71, i64 %72
  %74 = getelementptr inbounds nuw i8, ptr %73, i64 16
  %75 = load i8, ptr %74, align 8, !tbaa !23
  %76 = icmp eq i8 %75, 1
  br i1 %76, label %77, label %92

77:                                               ; preds = %69, %85
  %78 = phi ptr [ %88, %85 ], [ %73, %69 ]
  %79 = phi i64 [ %87, %85 ], [ %72, %69 ]
  %80 = load ptr, ptr %78, align 8, !tbaa !26
  %81 = tail call i32 @strcmp(ptr noundef nonnull dereferenceable(1) %80, ptr noundef nonnull dereferenceable(1) %1) #13
  %82 = icmp eq i32 %81, 0
  br i1 %82, label %83, label %85

83:                                               ; preds = %77
  %84 = getelementptr inbounds nuw i8, ptr %78, i64 8
  br label %102

85:                                               ; preds = %77
  %86 = add i64 %79, 1
  %87 = and i64 %86, %56
  %88 = getelementptr inbounds nuw %struct.StrEntry, ptr %71, i64 %87
  %89 = getelementptr inbounds nuw i8, ptr %88, i64 16
  %90 = load i8, ptr %89, align 8, !tbaa !23
  %91 = icmp eq i8 %90, 1
  br i1 %91, label %77, label %92, !llvm.loop !49

92:                                               ; preds = %85, %69
  %93 = phi i64 [ %72, %69 ], [ %87, %85 ]
  %94 = phi ptr [ %73, %69 ], [ %88, %85 ]
  %95 = tail call i64 @strlen(ptr noundef nonnull dereferenceable(1) %1) #13
  %96 = add i64 %95, 1
  %97 = tail call noalias ptr @malloc(i64 noundef %96) #11
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 1 %97, ptr nonnull align 1 %1, i64 %96, i1 false)
  store ptr %97, ptr %94, align 8, !tbaa !26
  %98 = getelementptr inbounds nuw %struct.StrEntry, ptr %71, i64 %93, i32 1
  store i64 0, ptr %98, align 8, !tbaa !32
  %99 = getelementptr inbounds nuw %struct.StrEntry, ptr %71, i64 %93, i32 2
  store i8 1, ptr %99, align 8, !tbaa !23
  %100 = load i64, ptr %3, align 8, !tbaa !18
  %101 = add i64 %100, 1
  store i64 %101, ptr %3, align 8, !tbaa !18
  br label %102

102:                                              ; preds = %92, %83
  %103 = phi ptr [ %84, %83 ], [ %98, %92 ]
  ret ptr %103
}

; Function Attrs: nounwind uwtable
define internal fastcc void @intmap_put(ptr noundef nonnull captures(none) %0, i64 noundef range(i64 -9223372036854775805, 1106484) %1, i64 noundef range(i64 -9223372036854775807, 100000) %2) unnamed_addr #0 {
  %4 = getelementptr inbounds nuw i8, ptr %0, i64 24
  %5 = load i64, ptr %4, align 8, !tbaa !50
  %6 = mul i64 %5, 10
  %7 = add i64 %6, 10
  %8 = getelementptr inbounds nuw i8, ptr %0, i64 8
  %9 = load i64, ptr %8, align 8, !tbaa !12
  %10 = mul i64 %9, 7
  %11 = icmp ult i64 %7, %10
  br i1 %11, label %51, label %12

12:                                               ; preds = %3
  %13 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %14 = load i64, ptr %13, align 8, !tbaa !41
  %15 = shl i64 %14, 1
  %16 = icmp uge i64 %15, %9
  %17 = zext i1 %16 to i64
  %18 = shl i64 %9, %17
  %19 = load ptr, ptr %0, align 8, !tbaa !15
  %20 = tail call noalias ptr @calloc(i64 noundef %18, i64 noundef 24) #12
  store ptr %20, ptr %0, align 8, !tbaa !15
  store i64 %18, ptr %8, align 8, !tbaa !12
  store i64 %14, ptr %4, align 8, !tbaa !50
  %21 = add i64 %18, -1
  %22 = icmp eq i64 %9, 0
  br i1 %22, label %49, label %23

23:                                               ; preds = %12, %46
  %24 = phi i64 [ %47, %46 ], [ 0, %12 ]
  %25 = getelementptr inbounds nuw %struct.IntEntry, ptr %19, i64 %24
  %26 = getelementptr inbounds nuw i8, ptr %25, i64 16
  %27 = load i8, ptr %26, align 8, !tbaa !35
  %28 = icmp eq i8 %27, 1
  br i1 %28, label %29, label %46

29:                                               ; preds = %23
  %30 = load i64, ptr %25, align 8, !tbaa !37
  %31 = lshr i64 %30, 33
  %32 = xor i64 %31, %30
  %33 = mul i64 %32, -49064778989728563
  %34 = lshr i64 %33, 33
  %35 = xor i64 %34, %33
  %36 = load ptr, ptr %0, align 8, !tbaa !15
  br label %37

37:                                               ; preds = %37, %29
  %38 = phi i64 [ %35, %29 ], [ %44, %37 ]
  %39 = and i64 %38, %21
  %40 = getelementptr inbounds nuw %struct.IntEntry, ptr %36, i64 %39
  %41 = getelementptr inbounds nuw i8, ptr %40, i64 16
  %42 = load i8, ptr %41, align 8, !tbaa !35
  %43 = icmp eq i8 %42, 1
  %44 = add i64 %39, 1
  br i1 %43, label %37, label %45, !llvm.loop !51

45:                                               ; preds = %37
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %40, ptr noundef nonnull align 8 dereferenceable(24) %25, i64 24, i1 false), !tbaa.struct !52
  br label %46

46:                                               ; preds = %45, %23
  %47 = add nuw i64 %24, 1
  %48 = icmp eq i64 %47, %9
  br i1 %48, label %49, label %23, !llvm.loop !53

49:                                               ; preds = %46, %12
  tail call void @free(ptr noundef %19) #10
  %50 = load i64, ptr %8, align 8, !tbaa !12
  br label %51

51:                                               ; preds = %49, %3
  %52 = phi i64 [ %50, %49 ], [ %9, %3 ]
  %53 = add i64 %52, -1
  %54 = lshr i64 %1, 33
  %55 = xor i64 %54, %1
  %56 = mul i64 %55, -49064778989728563
  %57 = lshr i64 %56, 33
  %58 = xor i64 %57, %56
  %59 = load ptr, ptr %0, align 8, !tbaa !15
  br label %60

60:                                               ; preds = %72, %51
  %61 = phi i64 [ -1, %51 ], [ %76, %72 ]
  %62 = phi i64 [ %58, %51 ], [ %77, %72 ]
  %63 = and i64 %62, %53
  %64 = getelementptr inbounds nuw %struct.IntEntry, ptr %59, i64 %63
  %65 = getelementptr inbounds nuw i8, ptr %64, i64 16
  %66 = load i8, ptr %65, align 8, !tbaa !35
  switch i8 %66, label %72 [
    i8 0, label %78
    i8 1, label %67
  ]

67:                                               ; preds = %60
  %68 = load i64, ptr %64, align 8, !tbaa !37
  %69 = icmp eq i64 %68, %1
  br i1 %69, label %70, label %72

70:                                               ; preds = %67
  %71 = getelementptr inbounds nuw i8, ptr %64, i64 8
  store i64 %2, ptr %71, align 8, !tbaa !39
  br label %91

72:                                               ; preds = %60, %67
  %73 = icmp eq i8 %66, 2
  %74 = icmp slt i64 %61, 0
  %75 = select i1 %73, i1 %74, i1 false
  %76 = select i1 %75, i64 %63, i64 %61
  %77 = add i64 %63, 1
  br label %60, !llvm.loop !54

78:                                               ; preds = %60
  %79 = icmp slt i64 %61, 0
  %80 = select i1 %79, i64 %63, i64 %61
  br i1 %79, label %81, label %84

81:                                               ; preds = %78
  %82 = load i64, ptr %4, align 8, !tbaa !50
  %83 = add i64 %82, 1
  store i64 %83, ptr %4, align 8, !tbaa !50
  br label %84

84:                                               ; preds = %81, %78
  %85 = getelementptr inbounds nuw %struct.IntEntry, ptr %59, i64 %80
  store i64 %1, ptr %85, align 8, !tbaa !37
  %86 = getelementptr inbounds nuw %struct.IntEntry, ptr %59, i64 %80, i32 1
  store i64 %2, ptr %86, align 8, !tbaa !39
  %87 = getelementptr inbounds nuw %struct.IntEntry, ptr %59, i64 %80, i32 2
  store i8 1, ptr %87, align 8, !tbaa !35
  %88 = getelementptr inbounds nuw i8, ptr %0, i64 16
  %89 = load i64, ptr %88, align 8, !tbaa !41
  %90 = add i64 %89, 1
  store i64 %90, ptr %88, align 8, !tbaa !41
  br label %91

91:                                               ; preds = %84, %70
  ret void
}

; Function Attrs: mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @free(ptr allocptr noundef captures(none)) local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr noundef readonly captures(none), ...) local_unnamed_addr #3

; Function Attrs: mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite)
declare noalias noundef ptr @calloc(i64 noundef, i64 noundef) local_unnamed_addr #5

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare i32 @strcmp(ptr noundef captures(none), ptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare i64 @strlen(ptr noundef captures(none)) local_unnamed_addr #6

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #7

; Function Attrs: cold nofree noreturn nounwind
declare void @abort() local_unnamed_addr #8

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #9

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nounwind willreturn allockind("free") memory(argmem: readwrite, inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { mustprogress nofree nounwind willreturn allockind("alloc,zeroed") allocsize(0,1) memory(inaccessiblemem: readwrite) "alloc-family"="malloc" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #8 = { cold nofree noreturn nounwind "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #10 = { nounwind }
attributes #11 = { nounwind allocsize(0) }
attributes #12 = { nounwind allocsize(0,1) }
attributes #13 = { nounwind willreturn memory(read) }
attributes #14 = { cold noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 21.1.8 (6ubuntu1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"p1 omnipotent char", !7, i64 0}
!7 = !{!"any pointer", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !11}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!13, !14, i64 8}
!13 = !{!"", !7, i64 0, !14, i64 8, !14, i64 16, !14, i64 24}
!14 = !{!"long", !8, i64 0}
!15 = !{!13, !7, i64 0}
!16 = !{!17, !14, i64 8}
!17 = !{!"", !7, i64 0, !14, i64 8, !14, i64 16}
!18 = !{!17, !14, i64 16}
!19 = !{!17, !7, i64 0}
!20 = !{!14, !14, i64 0}
!21 = distinct !{!21, !11}
!22 = distinct !{!22, !11}
!23 = !{!24, !8, i64 16}
!24 = !{!"", !6, i64 0, !14, i64 8, !8, i64 16}
!25 = distinct !{!25, !11}
!26 = !{!24, !6, i64 0}
!27 = !{!8, !8, i64 0}
!28 = distinct !{!28, !11}
!29 = distinct !{!29, !11}
!30 = distinct !{!30, !11}
!31 = distinct !{!31, !11}
!32 = !{!24, !14, i64 8}
!33 = distinct !{!33, !11}
!34 = distinct !{!34, !11}
!35 = !{!36, !8, i64 16}
!36 = !{!"", !14, i64 0, !14, i64 8, !8, i64 16}
!37 = !{!36, !14, i64 0}
!38 = distinct !{!38, !11}
!39 = !{!36, !14, i64 8}
!40 = distinct !{!40, !11}
!41 = !{!13, !14, i64 16}
!42 = distinct !{!42, !11}
!43 = distinct !{!43, !11}
!44 = distinct !{!44, !11}
!45 = distinct !{!45, !11}
!46 = distinct !{!46, !11}
!47 = !{i64 0, i64 8, !5, i64 8, i64 8, !20, i64 16, i64 1, !27}
!48 = distinct !{!48, !11}
!49 = distinct !{!49, !11}
!50 = !{!13, !14, i64 24}
!51 = distinct !{!51, !11}
!52 = !{i64 0, i64 8, !20, i64 8, i64 8, !20, i64 16, i64 1, !27}
!53 = distinct !{!53, !11}
!54 = distinct !{!54, !11}
