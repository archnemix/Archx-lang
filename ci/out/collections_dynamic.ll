; Archx LLVM IR module

%ArchxVec = type { i64, i64, ptr }
%ArchxStr = type { i64, i64 }
%ArchxDictHdr = type { i64, i64, i64, ptr, ptr, ptr, ptr, i64 }
%ArchxAny = type { i64, i64, i64 }
%ArchxRegion = type { ptr, ptr, ptr, ptr }

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.fmt.int.elem = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.fmt.str.elem = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.none = private unnamed_addr constant [5 x i8] c"None\00", align 1
@.fmt.lbrack = private unnamed_addr constant [2 x i8] c"[\00", align 1
@.fmt.sep = private unnamed_addr constant [3 x i8] c", \00", align 1
@.fmt.rbrack = private unnamed_addr constant [3 x i8] c"]\0A\00", align 1
@.fmt.rbrack.inline = private unnamed_addr constant [2 x i8] c"]\00", align 1
@.fmt.g15 = private unnamed_addr constant [6 x i8] c"%.15g\00", align 1
@.str.0 = private unnamed_addr constant [14 x i8] c"region score:\00", align 4
@.str.1 = private unnamed_addr constant [14 x i8] c"unique count:\00", align 4
@.str.2 = private unnamed_addr constant [14 x i8] c"middle slice:\00", align 4
@.str.3 = private unnamed_addr constant [15 x i8] c"reversed step:\00", align 4
@.str.4 = private unnamed_addr constant [36 x i8] c"`.append()` requires a `list` value\00", align 4
@.str.5 = private unnamed_addr constant [15 x i8] c"before rebind:\00", align 4
@.str.6 = private unnamed_addr constant [14 x i8] c"after rebind:\00", align 4
@.str.7 = private unnamed_addr constant [14 x i8] c"rebound list:\00", align 4

define internal fastcc %ArchxAny @archx_fn_summarize_tag(%ArchxAny %arg.val) {
entry:
  %t0 = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %arg.val)
  %t1 = call fastcc i1 @archx_any_eq(%ArchxAny %t0, %ArchxAny zeroinitializer)
  call fastcc void @archx_any_drop(%ArchxAny %t0)
  br i1 %t1, label %if.then.0, label %if.else.1
if.then.0:
  %t2 = extractvalue %ArchxStr { i64 8390326386350358533, i64 121 }, 0
  %t3 = extractvalue %ArchxStr { i64 8390326386350358533, i64 121 }, 1
  %t4 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t2, 1
  %t5 = insertvalue %ArchxAny %t4, i64 %t3, 2
  ret %ArchxAny %t5
if.else.1:
  %t6 = extractvalue %ArchxAny %arg.val, 0
  %t7 = icmp eq i64 %t6, 2
  br i1 %t7, label %if.then.3, label %if.else.4
if.then.3:
  %t8 = call fastcc %ArchxStr @archx_any_to_str(%ArchxAny %arg.val, ptr null)
  %t9 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 2915076256066174980, i64 0 }, %ArchxStr %t8, ptr null)
  %t10 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t9, %ArchxStr { i64 176093659137, i64 0 }, ptr null)
  %t11 = extractvalue %ArchxStr %t10, 0
  %t12 = extractvalue %ArchxStr %t10, 1
  %t13 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t11, 1
  %t14 = insertvalue %ArchxAny %t13, i64 %t12, 2
  call fastcc void @archx_str_drop(%ArchxStr %t9)
  call fastcc void @archx_str_drop(%ArchxStr %t8)
  ret %ArchxAny %t14
if.else.4:
  %t15 = extractvalue %ArchxAny %arg.val, 0
  %t16 = icmp eq i64 %t15, 4
  br i1 %t16, label %if.then.6, label %if.else.7
if.then.6:
  %t17 = call fastcc %ArchxStr @archx_any_to_str(%ArchxAny %arg.val, ptr null)
  %t18 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 2914519946132193284, i64 0 }, %ArchxStr %t17, ptr null)
  %t19 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t18, %ArchxStr { i64 176093659137, i64 0 }, ptr null)
  %t20 = extractvalue %ArchxStr %t19, 0
  %t21 = extractvalue %ArchxStr %t19, 1
  %t22 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t20, 1
  %t23 = insertvalue %ArchxAny %t22, i64 %t21, 2
  call fastcc void @archx_str_drop(%ArchxStr %t18)
  call fastcc void @archx_str_drop(%ArchxStr %t17)
  ret %ArchxAny %t23
if.else.7:
  %t24 = extractvalue %ArchxAny %arg.val, 0
  %t25 = icmp eq i64 %t24, 5
  br i1 %t25, label %if.then.9, label %if.else.10
if.then.9:
  %t26 = call fastcc i64 @archx_any_len(%ArchxAny %arg.val)
  %t27 = call fastcc %ArchxStr @archx_str_from_int(i64 %t26, ptr null)
  %t28 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 8391166443298750473, i64 263845145640 }, %ArchxStr %t27, ptr null)
  %t29 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t28, %ArchxStr { i64 176093659137, i64 0 }, ptr null)
  %t30 = extractvalue %ArchxStr %t29, 0
  %t31 = extractvalue %ArchxStr %t29, 1
  %t32 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t30, 1
  %t33 = insertvalue %ArchxAny %t32, i64 %t31, 2
  call fastcc void @archx_str_drop(%ArchxStr %t28)
  call fastcc void @archx_str_drop(%ArchxStr %t27)
  ret %ArchxAny %t33
if.else.10:
  br label %if.merge.11
if.merge.11:
  br label %if.merge.8
if.merge.8:
  br label %if.merge.5
if.merge.5:
  br label %if.merge.2
if.merge.2:
  %t34 = call fastcc %ArchxStr @archx_any_type_name(%ArchxAny %arg.val)
  %t35 = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %t34)
  %t36 = extractvalue %ArchxStr %t35, 0
  %t37 = extractvalue %ArchxStr %t35, 1
  %t38 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t36, 1
  %t39 = insertvalue %ArchxAny %t38, i64 %t37, 2
  ret %ArchxAny %t39
}

define internal fastcc i64 @archx_fn_count_words_in_region(%ArchxVec %arg.words) {
entry:
  %func.region = alloca %ArchxRegion, align 8
  %var.freq.1 = alloca i64, align 8
  %foreach.idx.4 = alloca i64, align 8
  %var.total.33 = alloca i64, align 8
  %foritems.idx.40 = alloca i64, align 8
  store %ArchxRegion zeroinitializer, ptr %func.region, align 8
  %t0 = call fastcc i64 @archx_dict_new(i64 34359742465, ptr %func.region)
  store i64 %t0, ptr %var.freq.1, align 8
  %t2 = extractvalue %ArchxVec %arg.words, 0
  %t3 = extractvalue %ArchxVec %arg.words, 2
  store i64 0, ptr %foreach.idx.4, align 8
  br label %foreach.cond.0
foreach.cond.0:
  %t5 = load i64, ptr %foreach.idx.4, align 8
  %t6 = icmp slt i64 %t5, %t2
  br i1 %t6, label %foreach.body.1, label %foreach.end.3
foreach.body.1:
  %t7 = getelementptr inbounds %ArchxStr, ptr %t3, i64 %t5
  %t8 = load %ArchxStr, ptr %t7, align 8
  %t9 = load i64, ptr %var.freq.1, align 8
  %t10 = call fastcc i64 @archx_dict_lookup_str(i64 %t9, %ArchxStr %t8)
  %t11 = icmp sge i64 %t10, 0
  br i1 %t11, label %if.then.4, label %if.else.5
if.then.4:
  %t12 = load i64, ptr %var.freq.1, align 8
  %t13 = call fastcc i64 @archx_dict_lookup_str(i64 %t12, %ArchxStr %t8)
  %t14 = icmp sge i64 %t13, 0
  br i1 %t14, label %dupd.ok.7, label %dupd.miss.8
dupd.miss.8:
  call void @archx_key_fail()
  unreachable
dupd.ok.7:
  %t15 = and i64 %t12, -4
  %t16 = inttoptr i64 %t15 to ptr
  %t17 = getelementptr inbounds %ArchxDictHdr, ptr %t16, i32 0, i32 6
  %t18 = load ptr, ptr %t17, align 8
  %t19 = getelementptr inbounds i64, ptr %t18, i64 %t13
  %t20 = load i64, ptr %t19, align 8
  %t21 = add i64 %t20, 1
  store i64 %t21, ptr %t19, align 8
  br label %if.merge.6
if.else.5:
  %t22 = load i64, ptr %var.freq.1, align 8
  %t23 = call fastcc { i64, i1 } @archx_dict_upsert_str(i64 %t22, %ArchxStr %t8)
  %t24 = extractvalue { i64, i1 } %t23, 0
  %t25 = extractvalue { i64, i1 } %t23, 1
  %t26 = and i64 %t22, -4
  %t27 = inttoptr i64 %t26 to ptr
  %t28 = getelementptr inbounds %ArchxDictHdr, ptr %t27, i32 0, i32 6
  %t29 = load ptr, ptr %t28, align 8
  %t30 = getelementptr inbounds i64, ptr %t29, i64 %t24
  store i64 1, ptr %t30, align 8
  br label %if.merge.6
if.merge.6:
  br label %foreach.step.2
foreach.step.2:
  %t31 = load i64, ptr %foreach.idx.4, align 8
  %t32 = add nsw i64 %t31, 1
  store i64 %t32, ptr %foreach.idx.4, align 8
  br label %foreach.cond.0
foreach.end.3:
  store i64 0, ptr %var.total.33, align 8
  %t34 = load i64, ptr %var.freq.1, align 8
  %t35 = and i64 %t34, -4
  %t36 = icmp eq i64 %t35, 0
  br i1 %t36, label %dlen.zero.9, label %dlen.load.10
dlen.zero.9:
  br label %dlen.done.11
dlen.load.10:
  %t37 = inttoptr i64 %t35 to ptr
  %t38 = load i64, ptr %t37, align 8
  br label %dlen.done.11
dlen.done.11:
  %t39 = phi i64 [ 0, %dlen.zero.9 ], [ %t38, %dlen.load.10 ]
  store i64 0, ptr %foritems.idx.40, align 8
  br label %foritems.cond.12
foritems.cond.12:
  %t41 = load i64, ptr %foritems.idx.40, align 8
  %t42 = icmp slt i64 %t41, %t39
  br i1 %t42, label %foritems.body.13, label %foritems.end.15
foritems.body.13:
  %t43 = and i64 %t34, -4
  %t44 = inttoptr i64 %t43 to ptr
  %t45 = getelementptr inbounds %ArchxDictHdr, ptr %t44, i32 0, i32 5
  %t46 = getelementptr inbounds %ArchxDictHdr, ptr %t44, i32 0, i32 6
  %t47 = load ptr, ptr %t45, align 8
  %t48 = load ptr, ptr %t46, align 8
  %t49 = getelementptr inbounds %ArchxStr, ptr %t47, i64 %t41
  %t50 = load %ArchxStr, ptr %t49, align 8
  %t51 = getelementptr inbounds i64, ptr %t48, i64 %t41
  %t52 = load i64, ptr %t51, align 8
  %t53 = extractvalue %ArchxStr %t50, 0
  %t54 = and i64 %t53, 4294967295
  %t55 = icmp sgt i64 %t54, 2
  br i1 %t55, label %if.then.16, label %if.else.17
if.then.16:
  %t56 = load i64, ptr %var.total.33, align 8
  %t57 = mul i64 %t52, 10
  %t58 = add i64 %t56, %t57
  store i64 %t58, ptr %var.total.33, align 8
  br label %if.merge.18
if.else.17:
  br label %if.merge.18
if.merge.18:
  br label %foritems.step.14
foritems.step.14:
  %t59 = load i64, ptr %foritems.idx.40, align 8
  %t60 = add nuw nsw i64 %t59, 1
  store i64 %t60, ptr %foritems.idx.40, align 8
  br label %foritems.cond.12
foritems.end.15:
  %t61 = load i64, ptr %var.total.33, align 8
  %t62 = load i64, ptr %var.freq.1, align 8
  call fastcc void @archx_dict_drop_s_i(i64 %t62)
  %t63 = getelementptr inbounds %ArchxRegion, ptr %func.region, i32 0, i32 2
  %t64 = load ptr, ptr %t63, align 8
  call fastcc void @archx_region_release_from(ptr %t64)
  ret i64 %t61
}

define i32 @main() {
entry:
  %var.words.12 = alloca %ArchxVec, align 8
  %setctor.i.35 = alloca i64, align 8
  %var.unique_ids.45 = alloca i64, align 8
  %print.idx.112 = alloca i64, align 8
  %vslice.i.145 = alloca i64, align 8
  %vslice.cur.146 = alloca i64, align 8
  %print.idx.162 = alloca i64, align 8
  %var.hello.225 = alloca i64, align 8
  %var.name.325 = alloca %ArchxAny, align 8
  %t0 = call noalias align 16 ptr @malloc(i64 112)
  %t1 = icmp eq ptr %t0, null
  br i1 %t1, label %alloc.oom.1, label %alloc.ok.0
alloc.oom.1:
  call void @archx_oom_fail()
  unreachable
alloc.ok.0:
  %t2 = getelementptr inbounds %ArchxStr, ptr %t0, i64 0
  store %ArchxStr { i64 7521981563576254469, i64 120 }, ptr %t2, align 8
  %t3 = getelementptr inbounds %ArchxStr, ptr %t0, i64 1
  store %ArchxStr { i64 7236556118896410628, i64 0 }, ptr %t3, align 8
  %t4 = getelementptr inbounds %ArchxStr, ptr %t0, i64 2
  store %ArchxStr { i64 7521981563576254469, i64 120 }, ptr %t4, align 8
  %t5 = getelementptr inbounds %ArchxStr, ptr %t0, i64 3
  store %ArchxStr { i64 7887611008498270212, i64 0 }, ptr %t5, align 8
  %t6 = getelementptr inbounds %ArchxStr, ptr %t0, i64 4
  store %ArchxStr { i64 7526774399186239494, i64 28271 }, ptr %t6, align 8
  %t7 = getelementptr inbounds %ArchxStr, ptr %t0, i64 5
  store %ArchxStr { i64 7521981563576254469, i64 120 }, ptr %t7, align 8
  %t8 = getelementptr inbounds %ArchxStr, ptr %t0, i64 6
  store %ArchxStr { i64 7236556118896410628, i64 0 }, ptr %t8, align 8
  %t9 = insertvalue %ArchxVec poison, i64 7, 0
  %t10 = insertvalue %ArchxVec %t9, i64 7, 1
  %t11 = insertvalue %ArchxVec %t10, ptr %t0, 2
  store %ArchxVec %t11, ptr %var.words.12, align 8
  %t13 = ptrtoint ptr @.str.0 to i64
  %t14 = insertvalue %ArchxStr poison, i64 7595150836884307981, 0
  %t15 = insertvalue %ArchxStr %t14, i64 %t13, 1
  %t16 = load %ArchxVec, ptr %var.words.12, align 8
  %t17 = call fastcc i64 @archx_fn_count_words_in_region(%ArchxVec %t16)
  call fastcc void @archx_str_print(%ArchxStr %t15, i1 false)
  %t18 = call i32 @putchar(i32 32)
  %t19 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t17)
  %t20 = call i32 @putchar(i32 10)
  %t21 = call noalias align 16 ptr @malloc(i64 48)
  %t22 = icmp eq ptr %t21, null
  br i1 %t22, label %alloc.oom.3, label %alloc.ok.2
alloc.oom.3:
  call void @archx_oom_fail()
  unreachable
alloc.ok.2:
  %t23 = getelementptr inbounds i64, ptr %t21, i64 0
  store i64 42, ptr %t23, align 8
  %t24 = getelementptr inbounds i64, ptr %t21, i64 1
  store i64 7, ptr %t24, align 8
  %t25 = getelementptr inbounds i64, ptr %t21, i64 2
  store i64 42, ptr %t25, align 8
  %t26 = getelementptr inbounds i64, ptr %t21, i64 3
  store i64 19, ptr %t26, align 8
  %t27 = getelementptr inbounds i64, ptr %t21, i64 4
  store i64 7, ptr %t27, align 8
  %t28 = getelementptr inbounds i64, ptr %t21, i64 5
  store i64 99, ptr %t28, align 8
  %t29 = insertvalue %ArchxVec poison, i64 6, 0
  %t30 = insertvalue %ArchxVec %t29, i64 6, 1
  %t31 = insertvalue %ArchxVec %t30, ptr %t21, 2
  %t32 = call fastcc i64 @archx_dict_new(i64 2048, ptr null)
  %t33 = extractvalue %ArchxVec %t31, 0
  %t34 = extractvalue %ArchxVec %t31, 2
  store i64 0, ptr %setctor.i.35, align 8
  br label %setctor.cond.4
setctor.cond.4:
  %t36 = load i64, ptr %setctor.i.35, align 8
  %t37 = icmp slt i64 %t36, %t33
  br i1 %t37, label %setctor.body.5, label %setctor.done.6
setctor.body.5:
  %t38 = getelementptr inbounds i64, ptr %t34, i64 %t36
  %t39 = load i64, ptr %t38, align 8
  %t40 = call fastcc { i64, i1 } @archx_dict_upsert_i64(i64 %t32, i64 %t39)
  %t41 = add nuw nsw i64 %t36, 1
  store i64 %t41, ptr %setctor.i.35, align 8
  br label %setctor.cond.4
setctor.done.6:
  %t42 = extractvalue %ArchxVec %t31, 1
  %t43 = icmp sgt i64 %t42, 0
  br i1 %t43, label %drop.vec.free.7, label %drop.vec.done.8
drop.vec.free.7:
  %t44 = extractvalue %ArchxVec %t31, 2
  call void @free(ptr %t44)
  br label %drop.vec.done.8
drop.vec.done.8:
  store i64 %t32, ptr %var.unique_ids.45, align 8
  %t46 = load i64, ptr %var.unique_ids.45, align 8
  %t47 = call fastcc { i64, i1 } @archx_dict_upsert_i64(i64 %t46, i64 105)
  %t48 = load i64, ptr %var.unique_ids.45, align 8
  %t49 = call fastcc { i64, i64 } @archx_dict_find_i64(i64 %t48, i64 7)
  %t50 = extractvalue { i64, i64 } %t49, 0
  %t51 = extractvalue { i64, i64 } %t49, 1
  %t52 = icmp sge i64 %t50, 0
  br i1 %t52, label %srem.hit.9, label %srem.miss.10
srem.miss.10:
  br label %srem.done.11
srem.hit.9:
  %t53 = and i64 %t48, -4
  %t54 = inttoptr i64 %t53 to ptr
  call fastcc void @archx_dict_erase_slot(ptr %t54, i64 %t51)
  br label %srem.done.11
srem.done.11:
  %t55 = ptrtoint ptr @.str.1 to i64
  %t56 = insertvalue %ArchxStr poison, i64 8172184447630704653, 0
  %t57 = insertvalue %ArchxStr %t56, i64 %t55, 1
  %t58 = load i64, ptr %var.unique_ids.45, align 8
  %t59 = and i64 %t58, -4
  %t60 = icmp eq i64 %t59, 0
  br i1 %t60, label %dlen.zero.12, label %dlen.load.13
dlen.zero.12:
  br label %dlen.done.14
dlen.load.13:
  %t61 = inttoptr i64 %t59 to ptr
  %t62 = load i64, ptr %t61, align 8
  br label %dlen.done.14
dlen.done.14:
  %t63 = phi i64 [ 0, %dlen.zero.12 ], [ %t62, %dlen.load.13 ]
  %t64 = load i64, ptr %var.unique_ids.45, align 8
  %t65 = call fastcc i64 @archx_dict_lookup_i64(i64 %t64, i64 42)
  %t66 = icmp sge i64 %t65, 0
  call fastcc void @archx_str_print(%ArchxStr %t57, i1 false)
  %t67 = call i32 @putchar(i32 32)
  %t68 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t63)
  %t69 = call i32 @putchar(i32 32)
  call fastcc void @archx_str_print(%ArchxStr { i64 2338319730839912455, i64 3813940 }, i1 false)
  %t70 = call i32 @putchar(i32 32)
  %t71 = select i1 %t66, ptr @.str.true, ptr @.str.false
  %t72 = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr %t71)
  %t73 = call i32 @putchar(i32 10)
  %t74 = call noalias align 16 ptr @malloc(i64 48)
  %t75 = icmp eq ptr %t74, null
  br i1 %t75, label %alloc.oom.16, label %alloc.ok.15
alloc.oom.16:
  call void @archx_oom_fail()
  unreachable
alloc.ok.15:
  %t76 = getelementptr inbounds i64, ptr %t74, i64 0
  store i64 10, ptr %t76, align 8
  %t77 = getelementptr inbounds i64, ptr %t74, i64 1
  store i64 20, ptr %t77, align 8
  %t78 = getelementptr inbounds i64, ptr %t74, i64 2
  store i64 30, ptr %t78, align 8
  %t79 = getelementptr inbounds i64, ptr %t74, i64 3
  store i64 40, ptr %t79, align 8
  %t80 = getelementptr inbounds i64, ptr %t74, i64 4
  store i64 50, ptr %t80, align 8
  %t81 = getelementptr inbounds i64, ptr %t74, i64 5
  store i64 60, ptr %t81, align 8
  %t82 = insertvalue %ArchxVec poison, i64 6, 0
  %t83 = insertvalue %ArchxVec %t82, i64 6, 1
  %t84 = insertvalue %ArchxVec %t83, ptr %t74, 2
  %t85 = extractvalue %ArchxVec %t84, 2
  %t86 = ptrtoint ptr @.str.2 to i64
  %t87 = insertvalue %ArchxStr poison, i64 7234022818336210957, 0
  %t88 = insertvalue %ArchxStr %t87, i64 %t86, 1
  %t89 = extractvalue %ArchxVec %t84, 0
  %t90 = extractvalue %ArchxVec %t84, 2
  %t91 = call fastcc { i64, i64 } @archx_slice_bounds(i64 %t89, i64 1, i1 true, i64 5, i1 true, i64 1)
  %t92 = extractvalue { i64, i64 } %t91, 0
  %t93 = extractvalue { i64, i64 } %t91, 1
  %t94 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t93, i64 8)
  %t95 = extractvalue { i64, i1 } %t94, 0
  %t96 = extractvalue { i64, i1 } %t94, 1
  br i1 %t96, label %mul.oom.17, label %mul.ok.18
mul.oom.17:
  call void @archx_oom_fail()
  unreachable
mul.ok.18:
  %t97 = icmp eq i64 %t95, 0
  %t98 = select i1 %t97, i64 1, i64 %t95
  %t99 = call noalias align 16 ptr @malloc(i64 %t98)
  %t100 = icmp eq ptr %t99, null
  br i1 %t100, label %alloc.oom.20, label %alloc.ok.19
alloc.oom.20:
  call void @archx_oom_fail()
  unreachable
alloc.ok.19:
  %t101 = icmp eq i64 %t93, 0
  %t102 = select i1 %t101, i64 1, i64 %t93
  %t103 = icmp sgt i64 %t93, 0
  br i1 %t103, label %vslice.copy.21, label %vslice.done.22
vslice.copy.21:
  %t104 = getelementptr inbounds i64, ptr %t90, i64 %t92
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %t99, ptr nonnull align 1 %t104, i64 %t98, i1 false)
  br label %vslice.done.22
vslice.done.22:
  %t105 = insertvalue %ArchxVec poison, i64 %t93, 0
  %t106 = insertvalue %ArchxVec %t105, i64 %t102, 1
  %t107 = insertvalue %ArchxVec %t106, ptr %t99, 2
  call fastcc void @archx_str_print(%ArchxStr %t88, i1 false)
  %t108 = call i32 @putchar(i32 32)
  %t109 = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %t110 = extractvalue %ArchxVec %t107, 0
  %t111 = extractvalue %ArchxVec %t107, 2
  store i64 0, ptr %print.idx.112, align 8
  br label %print.cond.23
print.cond.23:
  %t113 = load i64, ptr %print.idx.112, align 8
  %t114 = icmp slt i64 %t113, %t110
  br i1 %t114, label %print.body.24, label %print.end.27
print.body.24:
  %t115 = icmp sgt i64 %t113, 0
  br i1 %t115, label %print.sep.25, label %print.elem.26
print.sep.25:
  %t116 = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %print.elem.26
print.elem.26:
  %t117 = getelementptr inbounds i64, ptr %t111, i64 %t113
  %t118 = load i64, ptr %t117, align 8
  %t119 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t118)
  %t120 = add nsw i64 %t113, 1
  store i64 %t120, ptr %print.idx.112, align 8
  br label %print.cond.23
print.end.27:
  %t121 = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack.inline)
  %t122 = call i32 @putchar(i32 10)
  %t123 = extractvalue %ArchxVec %t107, 1
  %t124 = icmp sgt i64 %t123, 0
  br i1 %t124, label %drop.vec.free.28, label %drop.vec.done.29
drop.vec.free.28:
  %t125 = extractvalue %ArchxVec %t107, 2
  call void @free(ptr %t125)
  br label %drop.vec.done.29
drop.vec.done.29:
  %t126 = ptrtoint ptr @.str.3 to i64
  %t127 = insertvalue %ArchxStr poison, i64 7311142585383256078, 0
  %t128 = insertvalue %ArchxStr %t127, i64 %t126, 1
  %t129 = sub i64 0, 2
  %t130 = extractvalue %ArchxVec %t84, 0
  %t131 = extractvalue %ArchxVec %t84, 2
  %t132 = call fastcc { i64, i64 } @archx_slice_bounds(i64 %t130, i64 0, i1 false, i64 0, i1 false, i64 %t129)
  %t133 = extractvalue { i64, i64 } %t132, 0
  %t134 = extractvalue { i64, i64 } %t132, 1
  %t135 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %t134, i64 8)
  %t136 = extractvalue { i64, i1 } %t135, 0
  %t137 = extractvalue { i64, i1 } %t135, 1
  br i1 %t137, label %mul.oom.30, label %mul.ok.31
mul.oom.30:
  call void @archx_oom_fail()
  unreachable
mul.ok.31:
  %t138 = icmp eq i64 %t136, 0
  %t139 = select i1 %t138, i64 1, i64 %t136
  %t140 = call noalias align 16 ptr @malloc(i64 %t139)
  %t141 = icmp eq ptr %t140, null
  br i1 %t141, label %alloc.oom.33, label %alloc.ok.32
alloc.oom.33:
  call void @archx_oom_fail()
  unreachable
alloc.ok.32:
  %t142 = icmp eq i64 %t134, 0
  %t143 = select i1 %t142, i64 1, i64 %t134
  %t144 = icmp sgt i64 %t134, 0
  br i1 %t144, label %vslice.copy.34, label %vslice.done.35
vslice.copy.34:
  store i64 0, ptr %vslice.i.145, align 8
  store i64 %t133, ptr %vslice.cur.146, align 8
  br label %vslice.cond.36
vslice.cond.36:
  %t147 = load i64, ptr %vslice.i.145, align 8
  %t148 = icmp slt i64 %t147, %t134
  br i1 %t148, label %vslice.body.37, label %vslice.done.35
vslice.body.37:
  %t149 = load i64, ptr %vslice.cur.146, align 8
  %t150 = getelementptr inbounds i64, ptr %t131, i64 %t149
  %t151 = load i64, ptr %t150, align 8
  %t152 = getelementptr inbounds i64, ptr %t140, i64 %t147
  store i64 %t151, ptr %t152, align 8
  %t153 = add nuw nsw i64 %t147, 1
  %t154 = add i64 %t149, %t129
  store i64 %t153, ptr %vslice.i.145, align 8
  store i64 %t154, ptr %vslice.cur.146, align 8
  br label %vslice.cond.36
vslice.done.35:
  %t155 = insertvalue %ArchxVec poison, i64 %t134, 0
  %t156 = insertvalue %ArchxVec %t155, i64 %t143, 1
  %t157 = insertvalue %ArchxVec %t156, ptr %t140, 2
  call fastcc void @archx_str_print(%ArchxStr %t128, i1 false)
  %t158 = call i32 @putchar(i32 32)
  %t159 = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %t160 = extractvalue %ArchxVec %t157, 0
  %t161 = extractvalue %ArchxVec %t157, 2
  store i64 0, ptr %print.idx.162, align 8
  br label %print.cond.38
print.cond.38:
  %t163 = load i64, ptr %print.idx.162, align 8
  %t164 = icmp slt i64 %t163, %t160
  br i1 %t164, label %print.body.39, label %print.end.42
print.body.39:
  %t165 = icmp sgt i64 %t163, 0
  br i1 %t165, label %print.sep.40, label %print.elem.41
print.sep.40:
  %t166 = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %print.elem.41
print.elem.41:
  %t167 = getelementptr inbounds i64, ptr %t161, i64 %t163
  %t168 = load i64, ptr %t167, align 8
  %t169 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t168)
  %t170 = add nsw i64 %t163, 1
  store i64 %t170, ptr %print.idx.162, align 8
  br label %print.cond.38
print.end.42:
  %t171 = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack.inline)
  %t172 = call i32 @putchar(i32 10)
  %t173 = extractvalue %ArchxVec %t157, 1
  %t174 = icmp sgt i64 %t173, 0
  br i1 %t174, label %drop.vec.free.43, label %drop.vec.done.44
drop.vec.free.43:
  %t175 = extractvalue %ArchxVec %t157, 2
  call void @free(ptr %t175)
  br label %drop.vec.done.44
drop.vec.done.44:
  %t176 = call fastcc %ArchxStr @archx_str_slice(%ArchxStr { i64 7521981426137301004, i64 3471773034270305656 }, i64 0, i1 false, i64 5, i1 true, i64 1, ptr null)
  %t177 = sub i64 0, 6
  %t178 = call fastcc %ArchxStr @archx_str_slice(%ArchxStr { i64 7521981426137301004, i64 3471773034270305656 }, i64 %t177, i1 true, i64 0, i1 false, i64 1, ptr null)
  call fastcc void @archx_str_print(%ArchxStr { i64 7378429389878329351, i64 3831913 }, i1 false)
  %t179 = call i32 @putchar(i32 32)
  call fastcc void @archx_str_print(%ArchxStr %t176, i1 false)
  %t180 = call i32 @putchar(i32 32)
  call fastcc void @archx_str_print(%ArchxStr { i64 8318823019187273736, i64 980316009 }, i1 false)
  %t181 = call i32 @putchar(i32 32)
  call fastcc void @archx_str_print(%ArchxStr %t178, i1 false)
  %t182 = call i32 @putchar(i32 10)
  call fastcc void @archx_str_drop(%ArchxStr %t178)
  call fastcc void @archx_str_drop(%ArchxStr %t176)
  %t183 = extractvalue %ArchxStr { i64 7521981426137300997, i64 120 }, 0
  %t184 = extractvalue %ArchxStr { i64 7521981426137300997, i64 120 }, 1
  %t185 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t183, 1
  %t186 = insertvalue %ArchxAny %t185, i64 %t184, 2
  %t187 = insertvalue %ArchxAny { i64 2, i64 0, i64 0 }, i64 18, 1
  %t188 = extractvalue %ArchxStr { i64 7018690058811080709, i64 108 }, 0
  %t189 = extractvalue %ArchxStr { i64 7018690058811080709, i64 108 }, 1
  %t190 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t188, 1
  %t191 = insertvalue %ArchxAny %t190, i64 %t189, 2
  %t192 = call noalias align 16 ptr @malloc(i64 72)
  %t193 = icmp eq ptr %t192, null
  br i1 %t193, label %alloc.oom.46, label %alloc.ok.45
alloc.oom.46:
  call void @archx_oom_fail()
  unreachable
alloc.ok.45:
  %t194 = getelementptr inbounds %ArchxAny, ptr %t192, i64 0
  store %ArchxAny %t186, ptr %t194, align 8
  %t195 = getelementptr inbounds %ArchxAny, ptr %t192, i64 1
  store %ArchxAny %t187, ptr %t195, align 8
  %t196 = getelementptr inbounds %ArchxAny, ptr %t192, i64 2
  store %ArchxAny %t191, ptr %t196, align 8
  %t197 = insertvalue %ArchxVec poison, i64 3, 0
  %t198 = insertvalue %ArchxVec %t197, i64 3, 1
  %t199 = insertvalue %ArchxVec %t198, ptr %t192, 2
  %t200 = call fastcc i64 @archx_dict_new(i64 103079219201, ptr null)
  %t201 = call noalias align 16 ptr @malloc(i64 24)
  %t202 = icmp eq ptr %t201, null
  br i1 %t202, label %alloc.oom.48, label %alloc.ok.47
alloc.oom.48:
  call void @archx_oom_fail()
  unreachable
alloc.ok.47:
  store %ArchxVec %t199, ptr %t201, align 8
  %t203 = ptrtoint ptr %t201 to i64
  %t204 = or i64 %t203, 1
  %t205 = insertvalue %ArchxAny { i64 5, i64 0, i64 0 }, i64 %t204, 1
  %t206 = call fastcc { i64, i1 } @archx_dict_upsert_str(i64 %t200, %ArchxStr { i64 7022344801102069764, i64 0 })
  %t207 = extractvalue { i64, i1 } %t206, 0
  %t208 = extractvalue { i64, i1 } %t206, 1
  %t209 = and i64 %t200, -4
  %t210 = inttoptr i64 %t209 to ptr
  %t211 = getelementptr inbounds %ArchxDictHdr, ptr %t210, i32 0, i32 6
  %t212 = load ptr, ptr %t211, align 8
  %t213 = getelementptr inbounds %ArchxAny, ptr %t212, i64 %t207
  br i1 %t208, label %dlit.dropold.49, label %dlit.store.50
dlit.dropold.49:
  %t214 = load %ArchxAny, ptr %t213, align 8
  call fastcc void @archx_any_drop(%ArchxAny %t214)
  br label %dlit.store.50
dlit.store.50:
  store %ArchxAny %t205, ptr %t213, align 8
  %t215 = insertvalue %ArchxAny { i64 2, i64 0, i64 0 }, i64 18, 1
  %t216 = call fastcc { i64, i1 } @archx_dict_upsert_str(i64 %t200, %ArchxStr { i64 28542638957264899, i64 0 })
  %t217 = extractvalue { i64, i1 } %t216, 0
  %t218 = extractvalue { i64, i1 } %t216, 1
  %t219 = and i64 %t200, -4
  %t220 = inttoptr i64 %t219 to ptr
  %t221 = getelementptr inbounds %ArchxDictHdr, ptr %t220, i32 0, i32 6
  %t222 = load ptr, ptr %t221, align 8
  %t223 = getelementptr inbounds %ArchxAny, ptr %t222, i64 %t217
  br i1 %t218, label %dlit.dropold.51, label %dlit.store.52
dlit.dropold.51:
  %t224 = load %ArchxAny, ptr %t223, align 8
  call fastcc void @archx_any_drop(%ArchxAny %t224)
  br label %dlit.store.52
dlit.store.52:
  store %ArchxAny %t215, ptr %t223, align 8
  store i64 %t200, ptr %var.hello.225, align 8
  %t226 = load i64, ptr %var.hello.225, align 8
  %t227 = call fastcc i64 @archx_dict_lookup_str(i64 %t226, %ArchxStr { i64 7022344801102069764, i64 0 })
  %t228 = icmp sge i64 %t227, 0
  br i1 %t228, label %dm.ok.53, label %dm.miss.54
dm.miss.54:
  call void @archx_key_fail()
  unreachable
dm.ok.53:
  %t230 = and i64 %t226, -4
  %t231 = inttoptr i64 %t230 to ptr
  %t232 = getelementptr inbounds %ArchxDictHdr, ptr %t231, i32 0, i32 6
  %t233 = load ptr, ptr %t232, align 8
  %t234 = getelementptr inbounds %ArchxAny, ptr %t233, i64 %t227
  %t229 = load %ArchxAny, ptr %t234, align 8
  %t235 = extractvalue %ArchxAny %t229, 0
  %t236 = extractvalue %ArchxAny %t229, 1
  %t237 = icmp eq i64 %t235, 5
  br i1 %t237, label %any.guard.ok.55, label %any.guard.fail.56
any.guard.fail.56:
  call void @archx_type_fail(ptr @.str.4)
  unreachable
any.guard.ok.55:
  %t238 = extractvalue %ArchxStr { i64 7598805596355166214, i64 25974 }, 0
  %t239 = extractvalue %ArchxStr { i64 7598805596355166214, i64 25974 }, 1
  %t240 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t238, 1
  %t241 = insertvalue %ArchxAny %t240, i64 %t239, 2
  %t242 = and i64 %t236, -4
  %t243 = inttoptr i64 %t242 to ptr
  %t244 = load %ArchxVec, ptr %t243, align 8
  %t245 = extractvalue %ArchxVec %t244, 0
  %t246 = extractvalue %ArchxVec %t244, 1
  %t247 = extractvalue %ArchxVec %t244, 2
  %t248 = icmp slt i64 %t246, 0
  %t249 = sub nsw i64 0, %t246
  %t250 = select i1 %t248, i64 %t249, i64 %t246
  %t251 = icmp sge i64 %t245, %t250
  br i1 %t251, label %aapp.grow.57, label %aapp.keep.59
aapp.keep.59:
  br label %aapp.store.58
aapp.grow.57:
  %t252 = icmp eq i64 %t250, 0
  %t253 = shl i64 %t250, 1
  %t254 = select i1 %t252, i64 4, i64 %t253
  %t255 = mul nuw nsw i64 %t254, 24
  %t256 = icmp eq i64 %t255, 0
  %t257 = select i1 %t256, i64 1, i64 %t255
  %t258 = call noalias align 16 ptr @malloc(i64 %t257)
  %t259 = icmp eq ptr %t258, null
  br i1 %t259, label %alloc.oom.61, label %alloc.ok.60
alloc.oom.61:
  call void @archx_oom_fail()
  unreachable
alloc.ok.60:
  %t260 = icmp sgt i64 %t245, 0
  br i1 %t260, label %aapp.cp.62, label %aapp.fr.63
aapp.cp.62:
  %t261 = mul i64 %t245, 24
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %t258, ptr nonnull align 8 %t247, i64 %t261, i1 false)
  br label %aapp.fr.63
aapp.fr.63:
  %t262 = icmp sgt i64 %t246, 0
  br i1 %t262, label %aapp.dofr.65, label %aapp.gdone.64
aapp.dofr.65:
  call void @free(ptr %t247)
  br label %aapp.gdone.64
aapp.gdone.64:
  br label %aapp.store.58
aapp.store.58:
  %t263 = phi ptr [ %t247, %aapp.keep.59 ], [ %t258, %aapp.gdone.64 ]
  %t264 = phi i64 [ %t246, %aapp.keep.59 ], [ %t254, %aapp.gdone.64 ]
  %t265 = getelementptr inbounds %ArchxAny, ptr %t263, i64 %t245
  store %ArchxAny %t241, ptr %t265, align 8
  %t266 = add nuw nsw i64 %t245, 1
  %t267 = insertvalue %ArchxVec poison, i64 %t266, 0
  %t268 = insertvalue %ArchxVec %t267, i64 %t264, 1
  %t269 = insertvalue %ArchxVec %t268, ptr %t263, 2
  store %ArchxVec %t269, ptr %t243, align 8
  %t270 = load i64, ptr %var.hello.225, align 8
  %t271 = call fastcc i64 @archx_dict_lookup_str(i64 %t270, %ArchxStr { i64 28542638957264899, i64 0 })
  %t272 = icmp sge i64 %t271, 0
  br i1 %t272, label %dupd.ok.66, label %dupd.miss.67
dupd.miss.67:
  call void @archx_key_fail()
  unreachable
dupd.ok.66:
  %t273 = and i64 %t270, -4
  %t274 = inttoptr i64 %t273 to ptr
  %t275 = getelementptr inbounds %ArchxDictHdr, ptr %t274, i32 0, i32 6
  %t276 = load ptr, ptr %t275, align 8
  %t277 = getelementptr inbounds %ArchxAny, ptr %t276, i64 %t271
  %t278 = load %ArchxAny, ptr %t277, align 8
  %t279 = insertvalue %ArchxAny { i64 2, i64 0, i64 0 }, i64 2, 1
  %t280 = call fastcc %ArchxAny @archx_any_binop(%ArchxAny %t278, %ArchxAny %t279, i64 0, ptr null)
  call fastcc void @archx_any_drop(%ArchxAny %t278)
  store %ArchxAny %t280, ptr %t277, align 8
  call fastcc void @archx_any_drop(%ArchxAny %t279)
  %t281 = load i64, ptr %var.hello.225, align 8
  %t282 = call fastcc i64 @archx_dict_lookup_str(i64 %t281, %ArchxStr { i64 7022344801102069764, i64 0 })
  %t283 = icmp sge i64 %t282, 0
  br i1 %t283, label %dget.ok.68, label %dget.miss.69
dget.miss.69:
  call void @archx_key_fail()
  unreachable
dget.ok.68:
  %t284 = and i64 %t281, -4
  %t285 = inttoptr i64 %t284 to ptr
  %t286 = getelementptr inbounds %ArchxDictHdr, ptr %t285, i32 0, i32 6
  %t287 = load ptr, ptr %t286, align 8
  %t288 = getelementptr inbounds %ArchxAny, ptr %t287, i64 %t282
  %t289 = load %ArchxAny, ptr %t288, align 8
  %t290 = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %t289)
  %t291 = insertvalue %ArchxAny { i64 2, i64 0, i64 0 }, i64 0, 1
  %t292 = call fastcc %ArchxAny @archx_any_get_idx(%ArchxAny %t290, %ArchxAny %t291)
  %t293 = load i64, ptr %var.hello.225, align 8
  %t294 = call fastcc i64 @archx_dict_lookup_str(i64 %t293, %ArchxStr { i64 7022344801102069764, i64 0 })
  %t295 = icmp sge i64 %t294, 0
  br i1 %t295, label %dget.ok.70, label %dget.miss.71
dget.miss.71:
  call void @archx_key_fail()
  unreachable
dget.ok.70:
  %t296 = and i64 %t293, -4
  %t297 = inttoptr i64 %t296 to ptr
  %t298 = getelementptr inbounds %ArchxDictHdr, ptr %t297, i32 0, i32 6
  %t299 = load ptr, ptr %t298, align 8
  %t300 = getelementptr inbounds %ArchxAny, ptr %t299, i64 %t294
  %t301 = load %ArchxAny, ptr %t300, align 8
  %t302 = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %t301)
  %t303 = call fastcc i64 @archx_any_len(%ArchxAny %t302)
  %t304 = load i64, ptr %var.hello.225, align 8
  %t305 = call fastcc i64 @archx_dict_lookup_str(i64 %t304, %ArchxStr { i64 28542638957264899, i64 0 })
  %t306 = icmp sge i64 %t305, 0
  br i1 %t306, label %dget.ok.72, label %dget.miss.73
dget.miss.73:
  call void @archx_key_fail()
  unreachable
dget.ok.72:
  %t307 = and i64 %t304, -4
  %t308 = inttoptr i64 %t307 to ptr
  %t309 = getelementptr inbounds %ArchxDictHdr, ptr %t308, i32 0, i32 6
  %t310 = load ptr, ptr %t309, align 8
  %t311 = getelementptr inbounds %ArchxAny, ptr %t310, i64 %t305
  %t312 = load %ArchxAny, ptr %t311, align 8
  %t313 = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %t312)
  call fastcc void @archx_str_print(%ArchxStr { i64 7816385761942437896, i64 979657071 }, i1 false)
  %t314 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %t292, i1 false)
  %t315 = call i32 @putchar(i32 32)
  call fastcc void @archx_str_print(%ArchxStr { i64 7882834717102309382, i64 14963 }, i1 false)
  %t316 = call i32 @putchar(i32 32)
  %t317 = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %t303)
  %t318 = call i32 @putchar(i32 32)
  call fastcc void @archx_str_print(%ArchxStr { i64 4207883093157085188, i64 0 }, i1 false)
  %t319 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %t313, i1 false)
  %t320 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %t313)
  call fastcc void @archx_any_drop(%ArchxAny %t302)
  call fastcc void @archx_any_drop(%ArchxAny %t292)
  call fastcc void @archx_any_drop(%ArchxAny %t291)
  call fastcc void @archx_any_drop(%ArchxAny %t290)
  %t321 = extractvalue %ArchxStr { i64 8458994031421030408, i64 1751215212 }, 0
  %t322 = extractvalue %ArchxStr { i64 8458994031421030408, i64 1751215212 }, 1
  %t323 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t321, 1
  %t324 = insertvalue %ArchxAny %t323, i64 %t322, 2
  store %ArchxAny %t324, ptr %var.name.325, align 8
  %t326 = ptrtoint ptr @.str.5 to i64
  %t327 = insertvalue %ArchxStr poison, i64 8027214857415688206, 0
  %t328 = insertvalue %ArchxStr %t327, i64 %t326, 1
  %t329 = load %ArchxAny, ptr %var.name.325, align 8
  %t330 = call fastcc %ArchxAny @archx_fn_summarize_tag(%ArchxAny %t329)
  call fastcc void @archx_str_print(%ArchxStr %t328, i1 false)
  %t331 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %t330, i1 false)
  %t332 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %t330)
  %t333 = insertvalue %ArchxAny { i64 2, i64 0, i64 0 }, i64 18, 1
  %t334 = load %ArchxAny, ptr %var.name.325, align 8
  call fastcc void @archx_any_drop(%ArchxAny %t334)
  store %ArchxAny %t333, ptr %var.name.325, align 8
  %t335 = ptrtoint ptr @.str.6 to i64
  %t336 = insertvalue %ArchxStr poison, i64 7310580661927018509, 0
  %t337 = insertvalue %ArchxStr %t336, i64 %t335, 1
  %t338 = load %ArchxAny, ptr %var.name.325, align 8
  %t339 = insertvalue %ArchxAny { i64 2, i64 0, i64 0 }, i64 7, 1
  %t340 = call fastcc %ArchxAny @archx_any_binop(%ArchxAny %t338, %ArchxAny %t339, i64 0, ptr null)
  %t341 = call fastcc %ArchxAny @archx_fn_summarize_tag(%ArchxAny %t340)
  call fastcc void @archx_str_print(%ArchxStr %t337, i1 false)
  %t342 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %t341, i1 false)
  %t343 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %t341)
  call fastcc void @archx_any_drop(%ArchxAny %t340)
  call fastcc void @archx_any_drop(%ArchxAny %t339)
  %t344 = extractvalue %ArchxStr { i64 8243110639908683781, i64 49 }, 0
  %t345 = extractvalue %ArchxStr { i64 8243110639908683781, i64 49 }, 1
  %t346 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t344, 1
  %t347 = insertvalue %ArchxAny %t346, i64 %t345, 2
  %t348 = extractvalue %ArchxStr { i64 8243110639908683781, i64 50 }, 0
  %t349 = extractvalue %ArchxStr { i64 8243110639908683781, i64 50 }, 1
  %t350 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %t348, 1
  %t351 = insertvalue %ArchxAny %t350, i64 %t349, 2
  %t352 = insertvalue %ArchxAny { i64 2, i64 0, i64 0 }, i64 7, 1
  %t353 = call noalias align 16 ptr @malloc(i64 72)
  %t354 = icmp eq ptr %t353, null
  br i1 %t354, label %alloc.oom.75, label %alloc.ok.74
alloc.oom.75:
  call void @archx_oom_fail()
  unreachable
alloc.ok.74:
  %t355 = getelementptr inbounds %ArchxAny, ptr %t353, i64 0
  store %ArchxAny %t347, ptr %t355, align 8
  %t356 = getelementptr inbounds %ArchxAny, ptr %t353, i64 1
  store %ArchxAny %t351, ptr %t356, align 8
  %t357 = getelementptr inbounds %ArchxAny, ptr %t353, i64 2
  store %ArchxAny %t352, ptr %t357, align 8
  %t358 = insertvalue %ArchxVec poison, i64 3, 0
  %t359 = insertvalue %ArchxVec %t358, i64 3, 1
  %t360 = insertvalue %ArchxVec %t359, ptr %t353, 2
  %t361 = call noalias align 16 ptr @malloc(i64 24)
  %t362 = icmp eq ptr %t361, null
  br i1 %t362, label %alloc.oom.77, label %alloc.ok.76
alloc.oom.77:
  call void @archx_oom_fail()
  unreachable
alloc.ok.76:
  store %ArchxVec %t360, ptr %t361, align 8
  %t363 = ptrtoint ptr %t361 to i64
  %t364 = or i64 %t363, 1
  %t365 = insertvalue %ArchxAny { i64 5, i64 0, i64 0 }, i64 %t364, 1
  %t366 = load %ArchxAny, ptr %var.name.325, align 8
  call fastcc void @archx_any_drop(%ArchxAny %t366)
  store %ArchxAny %t365, ptr %var.name.325, align 8
  %t367 = ptrtoint ptr @.str.7 to i64
  %t368 = insertvalue %ArchxStr poison, i64 8026089026228322317, 0
  %t369 = insertvalue %ArchxStr %t368, i64 %t367, 1
  %t370 = load %ArchxAny, ptr %var.name.325, align 8
  %t371 = call fastcc %ArchxAny @archx_fn_summarize_tag(%ArchxAny %t370)
  %t372 = load %ArchxAny, ptr %var.name.325, align 8
  %t373 = sub i64 0, 1
  %t374 = insertvalue %ArchxAny { i64 2, i64 0, i64 0 }, i64 %t373, 1
  %t375 = call fastcc %ArchxAny @archx_any_get_idx(%ArchxAny %t372, %ArchxAny %t374)
  call fastcc void @archx_str_print(%ArchxStr %t369, i1 false)
  %t376 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %t371, i1 false)
  %t377 = call i32 @putchar(i32 32)
  call fastcc void @archx_str_print(%ArchxStr { i64 8391157647205728261, i64 58 }, i1 false)
  %t378 = call i32 @putchar(i32 32)
  call fastcc void @archx_any_print(%ArchxAny %t375, i1 false)
  %t379 = call i32 @putchar(i32 10)
  call fastcc void @archx_any_drop(%ArchxAny %t375)
  call fastcc void @archx_any_drop(%ArchxAny %t374)
  call fastcc void @archx_any_drop(%ArchxAny %t371)
  %t380 = load %ArchxAny, ptr %var.name.325, align 8
  call fastcc void @archx_any_drop(%ArchxAny %t380)
  %t381 = load i64, ptr %var.hello.225, align 8
  call fastcc void @archx_dict_drop_s_y(i64 %t381)
  call void @free(ptr %t85)
  %t382 = load i64, ptr %var.unique_ids.45, align 8
  call fastcc void @archx_set_drop_i(i64 %t382)
  %t383 = load %ArchxVec, ptr %var.words.12, align 8
  call fastcc void @archx_vec_drop_s(%ArchxVec %t383)
  ret i32 0
}

define private fastcc void @archx_dict_drop_s_i(i64 %d) {
entry:
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %done, label %body
body:
  %hdr = inttoptr i64 %raw to ptr
  %len = load i64, ptr %hdr, align 8
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %vals = load ptr, ptr %vals_p, align 8
  %i_slot = alloca i64, align 8
  store i64 0, ptr %i_slot, align 8
  br label %d_cond
d_cond:
  %i = load i64, ptr %i_slot, align 8
  %more = icmp slt i64 %i, %len
  br i1 %more, label %d_elem, label %free_hdr
d_elem:
  %t0 = getelementptr inbounds %ArchxStr, ptr %keys, i64 %i
  %t1 = load %ArchxStr, ptr %t0, align 8
  call fastcc void @archx_str_drop(%ArchxStr %t1)
  %inext = add nuw nsw i64 %i, 1
  store i64 %inext, ptr %i_slot, align 8
  br label %d_cond
free_hdr:
  %tag = and i64 %d, 3
  %is_heap = icmp eq i64 %tag, 1
  br i1 %is_heap, label %do_free, label %done
do_free:
  call void @free(ptr %ctrl)
  call void @free(ptr %keys)
  call void @free(ptr %vals)
  call void @free(ptr %hdr)
  br label %done
done:
  ret void
}

define private fastcc void @archx_dict_drop_s_y(i64 %d) {
entry:
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %done, label %body
body:
  %hdr = inttoptr i64 %raw to ptr
  %len = load i64, ptr %hdr, align 8
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %vals = load ptr, ptr %vals_p, align 8
  %i_slot = alloca i64, align 8
  store i64 0, ptr %i_slot, align 8
  br label %d_cond
d_cond:
  %i = load i64, ptr %i_slot, align 8
  %more = icmp slt i64 %i, %len
  br i1 %more, label %d_elem, label %free_hdr
d_elem:
  %t0 = getelementptr inbounds %ArchxStr, ptr %keys, i64 %i
  %t1 = load %ArchxStr, ptr %t0, align 8
  call fastcc void @archx_str_drop(%ArchxStr %t1)
  %t2 = getelementptr inbounds %ArchxAny, ptr %vals, i64 %i
  %t3 = load %ArchxAny, ptr %t2, align 8
  call fastcc void @archx_any_drop(%ArchxAny %t3)
  %inext = add nuw nsw i64 %i, 1
  store i64 %inext, ptr %i_slot, align 8
  br label %d_cond
free_hdr:
  %tag = and i64 %d, 3
  %is_heap = icmp eq i64 %tag, 1
  br i1 %is_heap, label %do_free, label %done
do_free:
  call void @free(ptr %ctrl)
  call void @free(ptr %keys)
  call void @free(ptr %vals)
  call void @free(ptr %hdr)
  br label %done
done:
  ret void
}

define private fastcc void @archx_set_drop_i(i64 %d) {
entry:
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %done, label %body
body:
  %hdr = inttoptr i64 %raw to ptr
  %len = load i64, ptr %hdr, align 8
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %vals = load ptr, ptr %vals_p, align 8
  br label %free_hdr
free_hdr:
  %tag = and i64 %d, 3
  %is_heap = icmp eq i64 %tag, 1
  br i1 %is_heap, label %do_free, label %done
do_free:
  call void @free(ptr %ctrl)
  call void @free(ptr %keys)
  call void @free(ptr %vals)
  call void @free(ptr %hdr)
  br label %done
done:
  ret void
}

define private fastcc void @archx_vec_drop_s(%ArchxVec %v) nounwind {
entry:
  %len = extractvalue %ArchxVec %v, 0
  %cap = extractvalue %ArchxVec %v, 1
  %data = extractvalue %ArchxVec %v, 2
  %has_elems = icmp sgt i64 %len, 0
  br i1 %has_elems, label %loop.pre, label %check.free
loop.pre:
  br label %loop
loop:
  %i = phi i64 [ 0, %loop.pre ], [ %inext, %loop.latch ]
  %ep = getelementptr inbounds %ArchxStr, ptr %data, i64 %i
  %t0 = load %ArchxStr, ptr %ep, align 8
  call fastcc void @archx_str_drop(%ArchxStr %t0)
  br label %loop.latch
loop.latch:
  %inext = add nuw nsw i64 %i, 1
  %more = icmp slt i64 %inext, %len
  br i1 %more, label %loop, label %check.free
check.free:
  %is_heap = icmp sgt i64 %cap, 0
  br i1 %is_heap, label %do.free, label %done
do.free:
  call void @free(ptr %data)
  br label %done
done:
  ret void
}

define private fastcc void @archx_vec_drop_y(%ArchxVec %v) nounwind {
entry:
  %len = extractvalue %ArchxVec %v, 0
  %cap = extractvalue %ArchxVec %v, 1
  %data = extractvalue %ArchxVec %v, 2
  %has_elems = icmp sgt i64 %len, 0
  br i1 %has_elems, label %loop.pre, label %check.free
loop.pre:
  br label %loop
loop:
  %i = phi i64 [ 0, %loop.pre ], [ %inext, %loop.latch ]
  %ep = getelementptr inbounds %ArchxAny, ptr %data, i64 %i
  %t0 = load %ArchxAny, ptr %ep, align 8
  call fastcc void @archx_any_drop(%ArchxAny %t0)
  br label %loop.latch
loop.latch:
  %inext = add nuw nsw i64 %i, 1
  %more = icmp slt i64 %inext, %len
  br i1 %more, label %loop, label %check.free
check.free:
  %is_heap = icmp sgt i64 %cap, 0
  br i1 %is_heap, label %do.free, label %done
do.free:
  call void @free(ptr %data)
  br label %done
done:
  ret void
}

define private fastcc %ArchxVec @archx_vec_clone_y(%ArchxVec %v) {
entry:
  %len = extractvalue %ArchxVec %v, 0
  %src = extractvalue %ArchxVec %v, 2
  %empty = icmp sle i64 %len, 0
  br i1 %empty, label %ret.empty, label %alloc
ret.empty:
  ret %ArchxVec zeroinitializer
alloc:
  %t0 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 %len, i64 24)
  %t1 = extractvalue { i64, i1 } %t0, 0
  %t2 = extractvalue { i64, i1 } %t0, 1
  br i1 %t2, label %mul.oom.0, label %mul.ok.1
mul.oom.0:
  call void @archx_oom_fail()
  unreachable
mul.ok.1:
  %t3 = icmp eq i64 %t1, 0
  %t4 = select i1 %t3, i64 1, i64 %t1
  %t5 = call noalias align 16 ptr @malloc(i64 %t4)
  %t6 = icmp eq ptr %t5, null
  br i1 %t6, label %alloc.oom.3, label %alloc.ok.2
alloc.oom.3:
  call void @archx_oom_fail()
  unreachable
alloc.ok.2:
  br label %loop.pre
loop.pre:
  br label %loop
loop:
  %i = phi i64 [ 0, %loop.pre ], [ %inext, %loop.latch ]
  %sp = getelementptr inbounds %ArchxAny, ptr %src, i64 %i
  %dp = getelementptr inbounds %ArchxAny, ptr %t5, i64 %i
  %t7 = load %ArchxAny, ptr %sp, align 8
  %t8 = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %t7)
  store %ArchxAny %t8, ptr %dp, align 8
  br label %loop.latch
loop.latch:
  %inext = add nuw nsw i64 %i, 1
  %more = icmp slt i64 %inext, %len
  br i1 %more, label %loop, label %finish
finish:
  %t9 = insertvalue %ArchxVec poison, i64 %len, 0
  %t10 = insertvalue %ArchxVec %t9, i64 %len, 1
  %t11 = insertvalue %ArchxVec %t10, ptr %t5, 2
  ret %ArchxVec %t11
}

define private fastcc void @archx_dict_drop_y_y(i64 %d) {
entry:
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %done, label %body
body:
  %hdr = inttoptr i64 %raw to ptr
  %len = load i64, ptr %hdr, align 8
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %vals = load ptr, ptr %vals_p, align 8
  %i_slot = alloca i64, align 8
  store i64 0, ptr %i_slot, align 8
  br label %d_cond
d_cond:
  %i = load i64, ptr %i_slot, align 8
  %more = icmp slt i64 %i, %len
  br i1 %more, label %d_elem, label %free_hdr
d_elem:
  %t0 = getelementptr inbounds %ArchxAny, ptr %keys, i64 %i
  %t1 = load %ArchxAny, ptr %t0, align 8
  call fastcc void @archx_any_drop(%ArchxAny %t1)
  %t2 = getelementptr inbounds %ArchxAny, ptr %vals, i64 %i
  %t3 = load %ArchxAny, ptr %t2, align 8
  call fastcc void @archx_any_drop(%ArchxAny %t3)
  %inext = add nuw nsw i64 %i, 1
  store i64 %inext, ptr %i_slot, align 8
  br label %d_cond
free_hdr:
  %tag = and i64 %d, 3
  %is_heap = icmp eq i64 %tag, 1
  br i1 %is_heap, label %do_free, label %done
do_free:
  call void @free(ptr %ctrl)
  call void @free(ptr %keys)
  call void @free(ptr %vals)
  call void @free(ptr %hdr)
  br label %done
done:
  ret void
}

define private fastcc i64 @archx_dict_clone_y_y(i64 %d) {
entry:
  %dst = call fastcc i64 @archx_dict_new(i64 103079221250, ptr null)
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %done, label %init
init:
  %hdr = inttoptr i64 %raw to ptr
  %len = load i64, ptr %hdr, align 8
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6
  %keys = load ptr, ptr %keys_p, align 8
  %vals = load ptr, ptr %vals_p, align 8
  %i_slot = alloca i64, align 8
  store i64 0, ptr %i_slot, align 8
  br label %c_cond
c_cond:
  %i = load i64, ptr %i_slot, align 8
  %more = icmp slt i64 %i, %len
  br i1 %more, label %c_body, label %done
c_body:
  %t0 = getelementptr inbounds %ArchxAny, ptr %keys, i64 %i
  %t1 = load %ArchxAny, ptr %t0, align 8
  %t2 = call fastcc { i64, i1 } @archx_dict_upsert_any(i64 %dst, %ArchxAny %t1)
  %t3 = extractvalue { i64, i1 } %t2, 0
  %t4 = getelementptr inbounds %ArchxAny, ptr %vals, i64 %i
  %t5 = load %ArchxAny, ptr %t4, align 8
  %t6 = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %t5)
  %t7 = and i64 %dst, -4
  %t8 = inttoptr i64 %t7 to ptr
  %t9 = getelementptr inbounds %ArchxDictHdr, ptr %t8, i32 0, i32 6
  %t10 = load ptr, ptr %t9, align 8
  %t11 = getelementptr inbounds %ArchxAny, ptr %t10, i64 %t3
  store %ArchxAny %t6, ptr %t11, align 8
  %inext = add nuw nsw i64 %i, 1
  store i64 %inext, ptr %i_slot, align 8
  br label %c_cond
done:
  ret i64 %dst
}

define private fastcc void @archx_set_drop_y(i64 %d) {
entry:
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %done, label %body
body:
  %hdr = inttoptr i64 %raw to ptr
  %len = load i64, ptr %hdr, align 8
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %vals = load ptr, ptr %vals_p, align 8
  %i_slot = alloca i64, align 8
  store i64 0, ptr %i_slot, align 8
  br label %d_cond
d_cond:
  %i = load i64, ptr %i_slot, align 8
  %more = icmp slt i64 %i, %len
  br i1 %more, label %d_elem, label %free_hdr
d_elem:
  %t0 = getelementptr inbounds %ArchxAny, ptr %keys, i64 %i
  %t1 = load %ArchxAny, ptr %t0, align 8
  call fastcc void @archx_any_drop(%ArchxAny %t1)
  %inext = add nuw nsw i64 %i, 1
  store i64 %inext, ptr %i_slot, align 8
  br label %d_cond
free_hdr:
  %tag = and i64 %d, 3
  %is_heap = icmp eq i64 %tag, 1
  br i1 %is_heap, label %do_free, label %done
do_free:
  call void @free(ptr %ctrl)
  call void @free(ptr %keys)
  call void @free(ptr %vals)
  call void @free(ptr %hdr)
  br label %done
done:
  ret void
}

define private fastcc i64 @archx_set_clone_y(i64 %d) {
entry:
  %dst = call fastcc i64 @archx_dict_new(i64 6146, ptr null)
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %done, label %init
init:
  %hdr = inttoptr i64 %raw to ptr
  %len = load i64, ptr %hdr, align 8
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6
  %keys = load ptr, ptr %keys_p, align 8
  %vals = load ptr, ptr %vals_p, align 8
  %i_slot = alloca i64, align 8
  store i64 0, ptr %i_slot, align 8
  br label %c_cond
c_cond:
  %i = load i64, ptr %i_slot, align 8
  %more = icmp slt i64 %i, %len
  br i1 %more, label %c_body, label %done
c_body:
  %t0 = getelementptr inbounds %ArchxAny, ptr %keys, i64 %i
  %t1 = load %ArchxAny, ptr %t0, align 8
  %t2 = call fastcc { i64, i1 } @archx_dict_upsert_any(i64 %dst, %ArchxAny %t1)
  %inext = add nuw nsw i64 %i, 1
  store i64 %inext, ptr %i_slot, align 8
  br label %c_cond
done:
  ret i64 %dst
}

define private fastcc void @archx_region_release_from(ptr %first) nounwind {
entry:
  %empty = icmp eq ptr %first, null
  br i1 %empty, label %done, label %loop
loop:
  %cur = phi ptr [ %first, %entry ], [ %next, %loop ]
  %next = load ptr, ptr %cur, align 8
  call void @free(ptr %cur)
  %more = icmp ne ptr %next, null
  br i1 %more, label %loop, label %done
done:
  ret void
}

define private fastcc noalias nonnull align 16 ptr @archx_region_alloc_slow(ptr %reg, i64 %aligned) noinline {
entry:
  %min_body = icmp slt i64 %aligned, 65536
  %body_sz = select i1 %min_body, i64 65536, i64 %aligned
  %ovf_chk = icmp sgt i64 %body_sz, 9223372036854775791
  br i1 %ovf_chk, label %oom, label %do_malloc
do_malloc:
  %tot = add nuw nsw i64 %body_sz, 16
  %blk = call noalias align 16 ptr @malloc(i64 %tot)
  %isnull = icmp eq ptr %blk, null
  br i1 %isnull, label %oom, label %ok
oom:
  call void @archx_oom_fail()
  unreachable
ok:
  store ptr null, ptr %blk, align 8
  %cap_ptr = getelementptr inbounds i8, ptr %blk, i64 8
  store i64 %body_sz, ptr %cap_ptr, align 8
  %head_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 2
  %tail_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 3
  %old_tail = load ptr, ptr %tail_slot, align 8
  %has_tail = icmp ne ptr %old_tail, null
  br i1 %has_tail, label %link_tail, label %link_head
link_tail:
  store ptr %blk, ptr %old_tail, align 8
  br label %finish
link_head:
  store ptr %blk, ptr %head_slot, align 8
  br label %finish
finish:
  store ptr %blk, ptr %tail_slot, align 8
  %data = getelementptr inbounds i8, ptr %blk, i64 16
  %new_cur = getelementptr inbounds i8, ptr %data, i64 %aligned
  %new_end = getelementptr inbounds i8, ptr %data, i64 %body_sz
  %cur_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 0
  %end_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 1
  store ptr %new_cur, ptr %cur_slot, align 8
  store ptr %new_end, ptr %end_slot, align 8
  ret ptr %data
}

define private fastcc void @archx_region_rewind_root(ptr %reg) alwaysinline nounwind {
entry:
  %head_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 2
  %head = load ptr, ptr %head_slot, align 8
  %empty = icmp eq ptr %head, null
  br i1 %empty, label %done, label %rewind
rewind:
  %cap_ptr = getelementptr inbounds i8, ptr %head, i64 8
  %cap = load i64, ptr %cap_ptr, align 8
  %data = getelementptr inbounds i8, ptr %head, i64 16
  %end = getelementptr inbounds i8, ptr %data, i64 %cap
  %end_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 1
  %tail_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 3
  store ptr %data, ptr %reg, align 8
  store ptr %end, ptr %end_slot, align 8
  store ptr %head, ptr %tail_slot, align 8
  br label %done
done:
  ret void
}

define private fastcc noalias nonnull align 16 ptr @archx_region_alloc_fallback(ptr %reg, i64 %aligned) noinline {
entry:
  %cur_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 0
  %end_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 1
  %tail_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 3
  %tail = load ptr, ptr %tail_slot, align 8
  %has_tail = icmp ne ptr %tail, null
  br i1 %has_tail, label %try_next_blk, label %try_head_blk
try_head_blk:
  %head_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 2
  %head = load ptr, ptr %head_slot, align 8
  br label %inspect_cand
try_next_blk:
  %tnext = load ptr, ptr %tail, align 8
  br label %inspect_cand
inspect_cand:
  %cand = phi ptr [ %head, %try_head_blk ], [ %tnext, %try_next_blk ]
  %has_cand = icmp ne ptr %cand, null
  br i1 %has_cand, label %check_cand_cap, label %slow
check_cand_cap:
  %ccap_ptr = getelementptr inbounds i8, ptr %cand, i64 8
  %ccap = load i64, ptr %ccap_ptr, align 8
  %cfits = icmp sge i64 %ccap, %aligned
  br i1 %cfits, label %reuse_cand, label %drop_stale_chain
reuse_cand:
  store ptr %cand, ptr %tail_slot, align 8
  %cdata = getelementptr inbounds i8, ptr %cand, i64 16
  %ccur = getelementptr inbounds i8, ptr %cdata, i64 %aligned
  %cend = getelementptr inbounds i8, ptr %cdata, i64 %ccap
  store ptr %ccur, ptr %cur_slot, align 8
  store ptr %cend, ptr %end_slot, align 8
  ret ptr %cdata
drop_stale_chain:
  br i1 %has_tail, label %unlink_from_tail, label %unlink_from_head
unlink_from_tail:
  store ptr null, ptr %tail, align 8
  br label %free_cand
unlink_from_head:
  %hs2 = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 2
  store ptr null, ptr %hs2, align 8
  br label %free_cand
free_cand:
  call fastcc void @archx_region_release_from(ptr %cand)
  br label %slow
slow:
  %res = call fastcc nonnull align 16 ptr @archx_region_alloc_slow(ptr %reg, i64 %aligned)
  ret ptr %res
}

define private fastcc noalias nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %size) alwaysinline {
entry:
  %z = icmp sle i64 %size, 0
  %sz = select i1 %z, i64 16, i64 %size
  %too_big = icmp sgt i64 %sz, 9223372036854775776
  br i1 %too_big, label %oom, label %align_ok
oom:
  call void @archx_oom_fail()
  unreachable
align_ok:
  %a1 = add nuw nsw i64 %sz, 15
  %aligned = and i64 %a1, -16
  %cur_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 0
  %end_slot = getelementptr inbounds %ArchxRegion, ptr %reg, i32 0, i32 1
  %cur = load ptr, ptr %cur_slot, align 8
  %end = load ptr, ptr %end_slot, align 8
  %cur_i = ptrtoint ptr %cur to i64
  %end_i = ptrtoint ptr %end to i64
  %rem = sub i64 %end_i, %cur_i
  %fits = icmp sge i64 %rem, %aligned
  br i1 %fits, label %fast, label %fallback
fast:
  %next = getelementptr inbounds i8, ptr %cur, i64 %aligned
  store ptr %next, ptr %cur_slot, align 8
  ret ptr %cur
fallback:
  %res = call fastcc nonnull align 16 ptr @archx_region_alloc_fallback(ptr %reg, i64 %aligned)
  ret ptr %res
}

define private fastcc void @archx_str_drop(%ArchxStr %s) alwaysinline nounwind {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %len = and i64 %w0, 4294967295
  %long = icmp ugt i64 %len, 12
  br i1 %long, label %chk_tag, label %done
chk_tag:
  %w1 = extractvalue %ArchxStr %s, 1
  %tag = and i64 %w1, 1
  %owned = icmp ne i64 %tag, 0
  br i1 %owned, label %do_free, label %done
do_free:
  %raw = and i64 %w1, -2
  %ptr = inttoptr i64 %raw to ptr
  call void @free(ptr %ptr)
  br label %done
done:
  ret void
}

define private fastcc %ArchxStr @archx_str_clone(%ArchxStr %s) {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %len = and i64 %w0, 4294967295
  %long = icmp ugt i64 %len, 12
  br i1 %long, label %chk_tag, label %ret_same
chk_tag:
  %w1 = extractvalue %ArchxStr %s, 1
  %tag = and i64 %w1, 3
  %owned = icmp ne i64 %tag, 0
  br i1 %owned, label %dup_heap, label %ret_same
dup_heap:
  %src_i = and i64 %w1, -4
  %src = inttoptr i64 %src_i to ptr
  %dst = call noalias align 16 ptr @malloc(i64 %len)
  %isnull = icmp eq ptr %dst, null
  br i1 %isnull, label %oom, label %copy
oom:
  call void @archx_oom_fail()
  unreachable
copy:
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst, ptr nonnull align 1 %src, i64 %len, i1 false)
  %dst_i = ptrtoint ptr %dst to i64
  %tagged = or i64 %dst_i, 1
  %out = insertvalue %ArchxStr %s, i64 %tagged, 1
  ret %ArchxStr %out
ret_same:
  ret %ArchxStr %s
}

define private fastcc %ArchxStr @archx_str_promote(%ArchxStr %s) {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %len = and i64 %w0, 4294967295
  %long = icmp ugt i64 %len, 12
  br i1 %long, label %chk_reg, label %ret_same
chk_reg:
  %w1 = extractvalue %ArchxStr %s, 1
  %tag = and i64 %w1, 3
  %is_reg = icmp eq i64 %tag, 2
  br i1 %is_reg, label %dup_heap, label %ret_same
dup_heap:
  %src_i = and i64 %w1, -4
  %src = inttoptr i64 %src_i to ptr
  %dst = call noalias align 16 ptr @malloc(i64 %len)
  %isnull = icmp eq ptr %dst, null
  br i1 %isnull, label %oom, label %copy
oom:
  call void @archx_oom_fail()
  unreachable
copy:
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst, ptr nonnull align 1 %src, i64 %len, i1 false)
  %dst_i = ptrtoint ptr %dst to i64
  %tagged = or i64 %dst_i, 1
  %out = insertvalue %ArchxStr %s, i64 %tagged, 1
  ret %ArchxStr %out
ret_same:
  ret %ArchxStr %s
}

define private fastcc i1 @archx_str_eq(%ArchxStr %a, %ArchxStr %b) alwaysinline nounwind {
entry:
  %aw0 = extractvalue %ArchxStr %a, 0
  %bw0 = extractvalue %ArchxStr %b, 0
  %w0_eq = icmp eq i64 %aw0, %bw0
  br i1 %w0_eq, label %chk_len, label %ret_false
chk_len:
  %len = and i64 %aw0, 4294967295
  %aw1 = extractvalue %ArchxStr %a, 1
  %bw1 = extractvalue %ArchxStr %b, 1
  %short = icmp ule i64 %len, 12
  br i1 %short, label %cmp_short, label %cmp_long
cmp_short:
  %eq_s = icmp eq i64 %aw1, %bw1
  ret i1 %eq_s
cmp_long:
  %ap_i = and i64 %aw1, -4
  %bp_i = and i64 %bw1, -4
  %same_ptr = icmp eq i64 %ap_i, %bp_i
  br i1 %same_ptr, label %ret_true, label %do_memcmp
do_memcmp:
  %ap = inttoptr i64 %ap_i to ptr
  %bp = inttoptr i64 %bp_i to ptr
  %ap4 = getelementptr inbounds i8, ptr %ap, i64 4
  %bp4 = getelementptr inbounds i8, ptr %bp, i64 4
  %rem = sub nuw nsw i64 %len, 4
  %mc = call i32 @memcmp(ptr nonnull %ap4, ptr nonnull %bp4, i64 %rem)
  %eq_m = icmp eq i32 %mc, 0
  ret i1 %eq_m
ret_true:
  ret i1 true
ret_false:
  ret i1 false
}

@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@.fmt.pstr = private unnamed_addr constant [5 x i8] c"%.*s\00", align 1

define private fastcc void @archx_str_print(%ArchxStr %s, i1 %newline) {
entry:
  %tmp = alloca [12 x i8], align 4
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %short = icmp ule i64 %len, 12
  br i1 %short, label %prep_short, label %prep_long
prep_short:
  %p4 = lshr i64 %w0, 32
  %p4_32 = trunc i64 %p4 to i32
  store i32 %p4_32, ptr %tmp, align 4
  %tmp4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %tmp4, align 4
  br label %emit
prep_long:
  %raw = and i64 %w1, -4
  %lptr = inttoptr i64 %raw to ptr
  br label %emit
emit:
  %data = phi ptr [ %tmp, %prep_short ], [ %lptr, %prep_long ]
  %pos = icmp ugt i64 %len, 0
  br i1 %pos, label %chk_nul, label %chk_nl
chk_nul:
  %nul = call ptr @memchr(ptr nonnull %data, i32 0, i64 %len)
  %has_nul = icmp ne ptr %nul, null
  br i1 %has_nul, label %byte_loop_pre, label %fast_printf
fast_printf:
  %len32 = trunc i64 %len to i32
  %fmt = select i1 %newline, ptr @.fmt.pstr.nl, ptr @.fmt.pstr
  %np = call i32 (ptr, ...) @printf(ptr %fmt, i32 %len32, ptr nonnull %data)
  ret void
byte_loop_pre:
  br label %byte_loop
byte_loop:
  %bi = phi i64 [ 0, %byte_loop_pre ], [ %bnext, %byte_loop ]
  %bp = getelementptr inbounds i8, ptr %data, i64 %bi
  %ch8 = load i8, ptr %bp, align 1
  %ch32 = zext i8 %ch8 to i32
  %pc = call i32 @putchar(i32 %ch32)
  %bnext = add nuw nsw i64 %bi, 1
  %bmore = icmp ult i64 %bnext, %len
  br i1 %bmore, label %byte_loop, label %chk_nl
chk_nl:
  br i1 %newline, label %do_nl, label %done
do_nl:
  %nc = call i32 @putchar(i32 10)
  br label %done
done:
  ret void
}

define private fastcc %ArchxStr @archx_str_concat(%ArchxStr %a, %ArchxStr %b, ptr %reg) alwaysinline {
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
ret_b:
  %b_in_reg = icmp ne ptr %reg, null
  br i1 %b_in_reg, label %ret_b_raw, label %ret_b_clone
ret_b_raw:
  %bw1_tag = and i64 %bw1, 1
  %b_owned = icmp ne i64 %bw1_tag, 0
  br i1 %b_owned, label %ret_b_clone, label %ret_b_direct
ret_b_direct:
  ret %ArchxStr %b
ret_b_clone:
  %bc = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %b)
  ret %ArchxStr %bc
chk_bz:
  %bz = icmp eq i64 %blen, 0
  br i1 %bz, label %ret_a, label %calc_tot
ret_a:
  %a_in_reg = icmp ne ptr %reg, null
  br i1 %a_in_reg, label %ret_a_raw, label %ret_a_clone
ret_a_raw:
  %aw1_tag = and i64 %aw1, 1
  %a_owned = icmp ne i64 %aw1_tag, 0
  br i1 %a_owned, label %ret_a_clone, label %ret_a_direct
ret_a_direct:
  ret %ArchxStr %a
ret_a_clone:
  %ac = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %a)
  ret %ArchxStr %ac
calc_tot:
  %tot = add nuw nsw i64 %alen, %blen
  %too_big = icmp sgt i64 %tot, 2147483647
  br i1 %too_big, label %oom, label %mat_a
oom:
  call void @archx_oom_fail()
  unreachable
mat_a:
  %ashort = icmp ule i64 %alen, 12
  br i1 %ashort, label %mat_a_short, label %mat_a_long
mat_a_short:
  %ap4 = lshr i64 %aw0, 32
  %ap4_32 = trunc i64 %ap4 to i32
  store i32 %ap4_32, ptr %atmp, align 4
  %atmp4 = getelementptr inbounds i8, ptr %atmp, i64 4
  store i64 %aw1, ptr %atmp4, align 4
  br label %mat_b
mat_a_long:
  %araw = and i64 %aw1, -4
  %alptr = inttoptr i64 %araw to ptr
  br label %mat_b
mat_b:
  %aptr = phi ptr [ %atmp, %mat_a_short ], [ %alptr, %mat_a_long ]
  %bshort = icmp ule i64 %blen, 12
  br i1 %bshort, label %mat_b_short, label %mat_b_long
mat_b_short:
  %bp4 = lshr i64 %bw0, 32
  %bp4_32 = trunc i64 %bp4 to i32
  store i32 %bp4_32, ptr %btmp, align 4
  %btmp4 = getelementptr inbounds i8, ptr %btmp, i64 4
  store i64 %bw1, ptr %btmp4, align 4
  br label %build
mat_b_long:
  %braw = and i64 %bw1, -4
  %blptr = inttoptr i64 %braw to ptr
  br label %build
build:
  %bptr = phi ptr [ %btmp, %mat_b_short ], [ %blptr, %mat_b_long ]
  %fits_sso = icmp ule i64 %tot, 12
  br i1 %fits_sso, label %build_sso, label %build_long
build_sso:
  store i64 0, ptr %out_sso, align 8
  %out_sso8 = getelementptr inbounds i8, ptr %out_sso, i64 8
  store i64 0, ptr %out_sso8, align 8
  %tot32 = trunc i64 %tot to i32
  store i32 %tot32, ptr %out_sso, align 8
  %sso_dst_a = getelementptr inbounds i8, ptr %out_sso, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso_dst_a, ptr nonnull align 1 %aptr, i64 %alen, i1 false)
  %sso_dst_b = getelementptr inbounds i8, ptr %sso_dst_a, i64 %alen
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %sso_dst_b, ptr nonnull align 1 %bptr, i64 %blen, i1 false)
  %rw0 = load i64, ptr %out_sso, align 8
  %rw1 = load i64, ptr %out_sso8, align 8
  %rs0 = insertvalue %ArchxStr poison, i64 %rw0, 0
  %rs1 = insertvalue %ArchxStr %rs0, i64 %rw1, 1
  ret %ArchxStr %rs1
build_long:
  %use_reg = icmp ne ptr %reg, null
  br i1 %use_reg, label %alloc_reg, label %alloc_heap
alloc_reg:
  %rp = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %tot)
  %rp_i = ptrtoint ptr %rp to i64
  %rp_a = and i64 %rp_i, -4
  %rtagged = or i64 %rp_a, 2
  br label %copy_long
alloc_heap:
  %hp = call noalias align 16 ptr @malloc(i64 %tot)
  %hnull = icmp eq ptr %hp, null
  br i1 %hnull, label %oom, label %tag_heap
tag_heap:
  %hp_i = ptrtoint ptr %hp to i64
  %htagged = or i64 %hp_i, 1
  br label %copy_long
copy_long:
  %dst = phi ptr [ %rp, %alloc_reg ], [ %hp, %tag_heap ]
  %w1_out = phi i64 [ %rtagged, %alloc_reg ], [ %htagged, %tag_heap ]
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst, ptr nonnull align 1 %aptr, i64 %alen, i1 false)
  %dst_b = getelementptr inbounds i8, ptr %dst, i64 %alen
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dst_b, ptr nonnull align 1 %bptr, i64 %blen, i1 false)
  %pref32 = load i32, ptr %dst, align 16
  %pref64 = zext i32 %pref32 to i64
  %pref_sh = shl nuw i64 %pref64, 32
  %w0_out = or i64 %tot, %pref_sh
  %ls0 = insertvalue %ArchxStr poison, i64 %w0_out, 0
  %ls1 = insertvalue %ArchxStr %ls0, i64 %w1_out, 1
  ret %ArchxStr %ls1
}

@.err.bounds = private unnamed_addr constant [63 x i8] c"archx runtime panic: index %lld out of bounds for length %lld\0A\00", align 1

define private void @archx_bounds_fail(i64 %idx, i64 %len) cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.bounds, i64 %idx, i64 %len)
  call void @exit(i32 101)
  unreachable
}

@.err.pop = private unnamed_addr constant [46 x i8] c"archx runtime panic: pop from an empty array\0A\00", align 1

define private void @archx_pop_empty_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.pop)
  call void @exit(i32 101)
  unreachable
}

@.err.divz = private unnamed_addr constant [39 x i8] c"archx runtime panic: division by zero\0A\00", align 1

define private void @archx_div_zero_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.divz)
  call void @exit(i32 101)
  unreachable
}

@.err.oom = private unnamed_addr constant [36 x i8] c"archx runtime panic: out of memory\0A\00", align 1

define private void @archx_oom_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.oom)
  call void @exit(i32 101)
  unreachable
}

declare i32 @printf(ptr nocapture readonly, ...)
declare noalias ptr @malloc(i64) nounwind allocsize(0)
declare noalias ptr @calloc(i64, i64) nounwind allocsize(0, 1)
declare ptr @realloc(ptr, i64) nounwind allocsize(1)
declare void @free(ptr) nounwind
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) nounwind readnone speculatable
declare i32 @memcmp(ptr nocapture, ptr nocapture, i64) nounwind readonly
declare ptr @memchr(ptr nocapture, i32, i64) nounwind readonly
declare i32 @putchar(i32)
declare void @exit(i32) cold noreturn nounwind

define private fastcc %ArchxStr @archx_str_from_slice(ptr %src, i64 %len, ptr %reg) {
entry:
  %sso = alloca [16 x i8], align 8
  %z = icmp sle i64 %len, 0
  br i1 %z, label %ret_empty, label %chk_big
ret_empty:
  ret %ArchxStr zeroinitializer
chk_big:
  %big = icmp sgt i64 %len, 2147483647
  br i1 %big, label %oom, label %chk_sso
oom:
  call void @archx_oom_fail()
  unreachable
chk_sso:
  %short = icmp ule i64 %len, 12
  br i1 %short, label %pack_sso, label %build_long
pack_sso:
  store i64 0, ptr %sso, align 8
  %sso8 = getelementptr inbounds i8, ptr %sso, i64 8
  store i64 0, ptr %sso8, align 8
  %len32 = trunc i64 %len to i32
  store i32 %len32, ptr %sso, align 8
  %sso4 = getelementptr inbounds i8, ptr %sso, i64 4
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 4 %sso4, ptr nonnull align 1 %src, i64 %len, i1 false)
  %sw0 = load i64, ptr %sso, align 8
  %sw1 = load i64, ptr %sso8, align 8
  %ss0 = insertvalue %ArchxStr poison, i64 %sw0, 0
  %ss1 = insertvalue %ArchxStr %ss0, i64 %sw1, 1
  ret %ArchxStr %ss1
build_long:
  %use_reg = icmp ne ptr %reg, null
  br i1 %use_reg, label %alloc_reg, label %alloc_heap
alloc_reg:
  %rp = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %len)
  %rp_i = ptrtoint ptr %rp to i64
  %rp_a = and i64 %rp_i, -4
  %rtagged = or i64 %rp_a, 2
  br label %copy_long
alloc_heap:
  %hp = call noalias align 16 ptr @malloc(i64 %len)
  %hnull = icmp eq ptr %hp, null
  br i1 %hnull, label %oom, label %tag_heap
tag_heap:
  %hp_i = ptrtoint ptr %hp to i64
  %htagged = or i64 %hp_i, 1
  br label %copy_long
copy_long:
  %dst = phi ptr [ %rp, %alloc_reg ], [ %hp, %tag_heap ]
  %w1_out = phi i64 [ %rtagged, %alloc_reg ], [ %htagged, %tag_heap ]
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 16 %dst, ptr nonnull align 1 %src, i64 %len, i1 false)
  %pref32 = load i32, ptr %dst, align 16
  %pref64 = zext i32 %pref32 to i64
  %pref_sh = shl nuw i64 %pref64, 32
  %w0_out = or i64 %len, %pref_sh
  %ls0 = insertvalue %ArchxStr poison, i64 %w0_out, 0
  %ls1 = insertvalue %ArchxStr %ls0, i64 %w1_out, 1
  ret %ArchxStr %ls1
}


define private fastcc i64 @archx_fmt_float_buf(double %x, ptr %buf) nounwind {
entry:
  %n32 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull %buf, ptr @.fmt.g15, double %x)
  %n = sext i32 %n32 to i64
  %pos = icmp sgt i64 %n, 0
  br i1 %pos, label %scan, label %ret_orig
scan:
  %i = phi i64 [ 0, %entry ], [ %inext, %scan_step ]
  %cp = getelementptr inbounds i8, ptr %buf, i64 %i
  %ch = load i8, ptr %cp, align 1
  %is_dot = icmp eq i8 %ch, 46
  %is_e = icmp eq i8 %ch, 101
  %is_E = icmp eq i8 %ch, 69
  %is_n = icmp eq i8 %ch, 110
  %is_N = icmp eq i8 %ch, 78
  %is_i = icmp eq i8 %ch, 105
  %is_I = icmp eq i8 %ch, 73
  %o1 = or i1 %is_dot, %is_e
  %o2 = or i1 %o1, %is_E
  %o3 = or i1 %o2, %is_n
  %o4 = or i1 %o3, %is_N
  %o5 = or i1 %o4, %is_i
  %special = or i1 %o5, %is_I
  br i1 %special, label %ret_orig, label %scan_step
scan_step:
  %inext = add nuw nsw i64 %i, 1
  %more = icmp slt i64 %inext, %n
  br i1 %more, label %scan, label %append_dot0
append_dot0:
  %p0 = getelementptr inbounds i8, ptr %buf, i64 %n
  store i8 46, ptr %p0, align 1
  %n1 = add nuw nsw i64 %n, 1
  %p1 = getelementptr inbounds i8, ptr %buf, i64 %n1
  store i8 48, ptr %p1, align 1
  %n2 = add nuw nsw i64 %n, 2
  %p2 = getelementptr inbounds i8, ptr %buf, i64 %n2
  store i8 0, ptr %p2, align 1
  ret i64 %n2
ret_orig:
  ret i64 %n
}


define private fastcc void @archx_print_float(double %x, i1 %nl) {
entry:
  %buf = alloca [64 x i8], align 8
  %len = call fastcc i64 @archx_fmt_float_buf(double %x, ptr %buf)
  %fmt = select i1 %nl, ptr @.fmt.str, ptr @.fmt.str.elem
  %r = call i32 (ptr, ...) @printf(ptr %fmt, ptr nonnull %buf)
  ret void
}


define private fastcc %ArchxStr @archx_str_from_float(double %x, ptr %reg) {
entry:
  %buf = alloca [64 x i8], align 8
  %len = call fastcc i64 @archx_fmt_float_buf(double %x, ptr %buf)
  %s = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %buf, i64 %len, ptr %reg)
  ret %ArchxStr %s
}

@.fmt.i64s = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

define private fastcc %ArchxStr @archx_str_from_int(i64 %n, ptr %reg) {
entry:
  %buf = alloca [32 x i8], align 8
  %n32 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull %buf, ptr @.fmt.i64s, i64 %n)
  %len = sext i32 %n32 to i64
  %s = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %buf, i64 %len, ptr %reg)
  ret %ArchxStr %s
}


define private fastcc %ArchxStr @archx_str_byte_at(%ArchxStr %s, i64 %idx) {
entry:
  %tmp = alloca [12 x i8], align 4
  %w0 = extractvalue %ArchxStr %s, 0
  %len = and i64 %w0, 4294967295
  %oob = icmp uge i64 %idx, %len
  br i1 %oob, label %fail, label %ok
fail:
  call void @archx_bounds_fail(i64 %idx, i64 %len)
  unreachable
ok:
  %w1 = extractvalue %ArchxStr %s, 1
  %short = icmp ule i64 %len, 12
  br i1 %short, label %mat_short, label %mat_long
mat_short:
  %p4 = lshr i64 %w0, 32
  %p4_32 = trunc i64 %p4 to i32
  store i32 %p4_32, ptr %tmp, align 4
  %tmp4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %tmp4, align 4
  br label %load_b
mat_long:
  %raw = and i64 %w1, -4
  %lptr = inttoptr i64 %raw to ptr
  br label %load_b
load_b:
  %base = phi ptr [ %tmp, %mat_short ], [ %lptr, %mat_long ]
  %bp = getelementptr inbounds i8, ptr %base, i64 %idx
  %b8 = load i8, ptr %bp, align 1
  %b64 = zext i8 %b8 to i64
  %sh = shl nuw i64 %b64, 32
  %rw0 = or i64 %sh, 1
  %rs0 = insertvalue %ArchxStr poison, i64 %rw0, 0
  %rs1 = insertvalue %ArchxStr %rs0, i64 0, 1
  ret %ArchxStr %rs1
}


define private fastcc i64 @archx_str_find(%ArchxStr %hay, %ArchxStr %needle) nounwind {
entry:
  %atmp = alloca [12 x i8], align 4
  %btmp = alloca [12 x i8], align 4
  %hw0 = extractvalue %ArchxStr %hay, 0
  %nw0 = extractvalue %ArchxStr %needle, 0
  %hlen = and i64 %hw0, 4294967295
  %nlen = and i64 %nw0, 4294967295
  %nz = icmp eq i64 %nlen, 0
  br i1 %nz, label %ret_zero, label %chk_len
ret_zero:
  ret i64 0
chk_len:
  %too_long = icmp ugt i64 %nlen, %hlen
  br i1 %too_long, label %ret_neg1, label %mat_a
mat_a:
  %hw1 = extractvalue %ArchxStr %hay, 1
  %hshort = icmp ule i64 %hlen, 12
  br i1 %hshort, label %mat_as, label %mat_al
mat_as:
  %hp4 = lshr i64 %hw0, 32
  %hp32 = trunc i64 %hp4 to i32
  store i32 %hp32, ptr %atmp, align 4
  %at4 = getelementptr inbounds i8, ptr %atmp, i64 4
  store i64 %hw1, ptr %at4, align 4
  br label %mat_b
mat_al:
  %hraw = and i64 %hw1, -4
  %hlp = inttoptr i64 %hraw to ptr
  br label %mat_b
mat_b:
  %hptr = phi ptr [ %atmp, %mat_as ], [ %hlp, %mat_al ]
  %nw1 = extractvalue %ArchxStr %needle, 1
  %nshort = icmp ule i64 %nlen, 12
  br i1 %nshort, label %mat_bs, label %mat_bl
mat_bs:
  %np4 = lshr i64 %nw0, 32
  %np32 = trunc i64 %np4 to i32
  store i32 %np32, ptr %btmp, align 4
  %bt4 = getelementptr inbounds i8, ptr %btmp, i64 4
  store i64 %nw1, ptr %bt4, align 4
  br label %loop_pre
mat_bl:
  %nraw = and i64 %nw1, -4
  %nlp = inttoptr i64 %nraw to ptr
  br label %loop_pre
loop_pre:
  %nptr = phi ptr [ %btmp, %mat_bs ], [ %nlp, %mat_bl ]
  %max_i = sub nuw nsw i64 %hlen, %nlen
  %first_b = load i8, ptr %nptr, align 1
  br label %loop
loop:
  %i = phi i64 [ 0, %loop_pre ], [ %inext, %step ]
  %hp = getelementptr inbounds i8, ptr %hptr, i64 %i
  %hb = load i8, ptr %hp, align 1
  %b_eq = icmp eq i8 %hb, %first_b
  br i1 %b_eq, label %do_mc, label %step
do_mc:
  %mc = call i32 @memcmp(ptr nonnull %hp, ptr nonnull %nptr, i64 %nlen)
  %hit = icmp eq i32 %mc, 0
  br i1 %hit, label %found, label %step
found:
  ret i64 %i
step:
  %inext = add nuw nsw i64 %i, 1
  %more = icmp ule i64 %inext, %max_i
  br i1 %more, label %loop, label %ret_neg1
ret_neg1:
  ret i64 -1
}


define private fastcc %ArchxStr @archx_str_repeat(%ArchxStr %s, i64 %n, ptr %reg) {
entry:
  %tmp = alloca [12 x i8], align 4
  %sbuf = alloca [64 x i8], align 8
  %nonpos = icmp sle i64 %n, 0
  br i1 %nonpos, label %ret_empty, label %chk_slen
ret_empty:
  ret %ArchxStr zeroinitializer
chk_slen:
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %slen = and i64 %w0, 4294967295
  %sz = icmp eq i64 %slen, 0
  br i1 %sz, label %ret_empty, label %calc_tot
calc_tot:
  %max_n = udiv i64 2147483647, %slen
  %ovf = icmp ugt i64 %n, %max_n
  br i1 %ovf, label %oom, label %mat
oom:
  call void @archx_oom_fail()
  unreachable
mat:
  %tot = mul nuw nsw i64 %slen, %n
  %short = icmp ule i64 %slen, 12
  br i1 %short, label %mat_s, label %mat_l
mat_s:
  %p4 = lshr i64 %w0, 32
  %p32 = trunc i64 %p4 to i32
  store i32 %p32, ptr %tmp, align 4
  %t4 = getelementptr inbounds i8, ptr %tmp, i64 4
  store i64 %w1, ptr %t4, align 4
  br label %alloc_buf
mat_l:
  %raw = and i64 %w1, -4
  %lp = inttoptr i64 %raw to ptr
  br label %alloc_buf
alloc_buf:
  %src = phi ptr [ %tmp, %mat_s ], [ %lp, %mat_l ]
  %fits = icmp ule i64 %tot, 64
  br i1 %fits, label %use_stack, label %use_heap
use_stack:
  br label %loop_pre
use_heap:
  %hp = call noalias ptr @malloc(i64 %tot)
  %hn = icmp eq ptr %hp, null
  br i1 %hn, label %oom, label %loop_pre
loop_pre:
  %dst = phi ptr [ %sbuf, %use_stack ], [ %hp, %use_heap ]
  %on_heap = phi i1 [ false, %use_stack ], [ true, %use_heap ]
  br label %loop
loop:
  %k = phi i64 [ 0, %loop_pre ], [ %knext, %loop ]
  %off = mul nuw nsw i64 %k, %slen
  %dp = getelementptr inbounds i8, ptr %dst, i64 %off
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %dp, ptr nonnull align 1 %src, i64 %slen, i1 false)
  %knext = add nuw nsw i64 %k, 1
  %more = icmp slt i64 %knext, %n
  br i1 %more, label %loop, label %finish
finish:
  %res = call fastcc %ArchxStr @archx_str_from_slice(ptr nonnull %dst, i64 %tot, ptr %reg)
  br i1 %on_heap, label %do_free, label %done
do_free:
  call void @free(ptr %dst)
  br label %done
done:
  ret %ArchxStr %res
}

@.err.negexp = private unnamed_addr constant [83 x i8] c"archx runtime panic: negative exponent in integer `**` (convert to `float` first)\0A\00", align 1

define private void @archx_neg_exp_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.negexp)
  call void @exit(i32 101)
  unreachable
}

@.err.zstep = private unnamed_addr constant [63 x i8] c"archx runtime panic: `range()` step argument must not be zero\0A\00", align 1

define private void @archx_zero_step_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.zstep)
  call void @exit(i32 101)
  unreachable
}

declare i32 @sprintf(ptr nocapture writeonly, ptr nocapture readonly, ...) nounwind
declare double @llvm.pow.f64(double, double) nounwind readnone speculatable
declare double @llvm.floor.f64(double) nounwind readnone speculatable
declare i64 @llvm.fptosi.sat.i64.f64(double) nounwind readnone speculatable
@.err.key = private unnamed_addr constant [58 x i8] c"archx runtime panic: KeyError: key not found in dict/set\0A\00", align 1

define private void @archx_key_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.key)
  call void @exit(i32 101)
  unreachable
}
@.err.type = private unnamed_addr constant [36 x i8] c"archx runtime panic: TypeError: %s\0A\00", align 1

define private void @archx_type_fail(ptr %msg) cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.type, ptr %msg)
  call void @exit(i32 101)
  unreachable
}

define private fastcc { i64, i64 } @archx_slice_bounds(i64 %len, i64 %start, i1 %has_start, i64 %stop, i1 %has_stop, i64 %step) {
entry:
  %z = icmp eq i64 %step, 0
  br i1 %z, label %zero_step, label %chk_dir
zero_step:
  call void @archx_zero_step_fail()
  unreachable
chk_dir:
  %pos = icmp sgt i64 %step, 0
  br i1 %pos, label %pos_step, label %neg_step

pos_step:
  br i1 %has_start, label %ps_has, label %ps_def
ps_def:
  br label %ps_done
ps_has:
  %ps_neg = icmp slt i64 %start, 0
  %ps_adj = add i64 %start, %len
  %ps_s0 = select i1 %ps_neg, i64 %ps_adj, i64 %start
  %ps_lt0 = icmp slt i64 %ps_s0, 0
  %ps_s1 = select i1 %ps_lt0, i64 0, i64 %ps_s0
  %ps_gtl = icmp sgt i64 %ps_s1, %len
  %ps_s2 = select i1 %ps_gtl, i64 %len, i64 %ps_s1
  br label %ps_done
ps_done:
  %s_pos = phi i64 [ 0, %ps_def ], [ %ps_s2, %ps_has ]
  br i1 %has_stop, label %pe_has, label %pe_def
pe_def:
  br label %pe_done
pe_has:
  %pe_neg = icmp slt i64 %stop, 0
  %pe_adj = add i64 %stop, %len
  %pe_e0 = select i1 %pe_neg, i64 %pe_adj, i64 %stop
  %pe_lt0 = icmp slt i64 %pe_e0, 0
  %pe_e1 = select i1 %pe_lt0, i64 0, i64 %pe_e0
  %pe_gtl = icmp sgt i64 %pe_e1, %len
  %pe_e2 = select i1 %pe_gtl, i64 %len, i64 %pe_e1
  br label %pe_done
pe_done:
  %e_pos = phi i64 [ %len, %pe_def ], [ %pe_e2, %pe_has ]
  %p_has_cnt = icmp sgt i64 %e_pos, %s_pos
  br i1 %p_has_cnt, label %p_calc, label %p_empty
p_calc:
  %p_diff = sub i64 %e_pos, %s_pos
  %p_dm1 = sub i64 %p_diff, 1
  %p_div = sdiv i64 %p_dm1, %step
  %p_cnt = add i64 %p_div, 1
  br label %finish
p_empty:
  br label %finish

neg_step:
  %len_m1 = sub i64 %len, 1
  br i1 %has_start, label %ns_has, label %ns_def
ns_def:
  br label %ns_done
ns_has:
  %ns_neg = icmp slt i64 %start, 0
  %ns_adj = add i64 %start, %len
  %ns_s0 = select i1 %ns_neg, i64 %ns_adj, i64 %start
  %ns_lt0 = icmp slt i64 %ns_s0, 0
  %ns_s1 = select i1 %ns_lt0, i64 -1, i64 %ns_s0
  %ns_gel = icmp sge i64 %ns_s1, %len
  %ns_s2 = select i1 %ns_gel, i64 %len_m1, i64 %ns_s1
  br label %ns_done
ns_done:
  %s_neg = phi i64 [ %len_m1, %ns_def ], [ %ns_s2, %ns_has ]
  br i1 %has_stop, label %ne_has, label %ne_def
ne_def:
  br label %ne_done
ne_has:
  %ne_neg = icmp slt i64 %stop, 0
  %ne_adj = add i64 %stop, %len
  %ne_e0 = select i1 %ne_neg, i64 %ne_adj, i64 %stop
  %ne_lt0 = icmp slt i64 %ne_e0, 0
  %ne_e1 = select i1 %ne_lt0, i64 -1, i64 %ne_e0
  %ne_gel = icmp sge i64 %ne_e1, %len
  %ne_e2 = select i1 %ne_gel, i64 %len_m1, i64 %ne_e1
  br label %ne_done
ne_done:
  %e_neg = phi i64 [ -1, %ne_def ], [ %ne_e2, %ne_has ]
  %n_has_cnt = icmp sgt i64 %s_neg, %e_neg
  br i1 %n_has_cnt, label %n_calc, label %n_empty
n_calc:
  %n_diff = sub i64 %s_neg, %e_neg
  %n_dm1 = sub i64 %n_diff, 1
  %abs_step = sub i64 0, %step
  %n_div = udiv i64 %n_dm1, %abs_step
  %n_cnt = add i64 %n_div, 1
  br label %finish
n_empty:
  br label %finish

finish:
  %out_s = phi i64 [ %s_pos, %p_calc ], [ 0, %p_empty ], [ %s_neg, %n_calc ], [ 0, %n_empty ]
  %out_c = phi i64 [ %p_cnt, %p_calc ], [ 0, %p_empty ], [ %n_cnt, %n_calc ], [ 0, %n_empty ]
  %r0 = insertvalue { i64, i64 } poison, i64 %out_s, 0
  %r1 = insertvalue { i64, i64 } %r0, i64 %out_c, 1
  ret { i64, i64 } %r1
}

define private fastcc %ArchxStr @archx_str_slice(%ArchxStr %s, i64 %start, i1 %has_start, i64 %stop, i1 %has_stop, i64 %step, ptr %reg) {
entry:
  %sso = alloca [16 x i8], align 8
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %bnds = call fastcc { i64, i64 } @archx_slice_bounds(i64 %len, i64 %start, i1 %has_start, i64 %stop, i1 %has_stop, i64 %step)
  %s_idx = extractvalue { i64, i64 } %bnds, 0
  %cnt = extractvalue { i64, i64 } %bnds, 1
  %empty = icmp sle i64 %cnt, 0
  br i1 %empty, label %ret_empty, label %get_ptr
ret_empty:
  ret %ArchxStr zeroinitializer
get_ptr:
  %is_sso = icmp ule i64 %len, 12
  br i1 %is_sso, label %from_sso, label %from_ptr
from_sso:
  store i64 %w0, ptr %sso, align 8
  %sso8 = getelementptr inbounds i8, ptr %sso, i64 8
  store i64 %w1, ptr %sso8, align 8
  %sso_p = getelementptr inbounds i8, ptr %sso, i64 4
  br label %have_ptr
from_ptr:
  %raw = and i64 %w1, -4
  %heap_p = inttoptr i64 %raw to ptr
  br label %have_ptr
have_ptr:
  %base = phi ptr [ %sso_p, %from_sso ], [ %heap_p, %from_ptr ]
  %unit = icmp eq i64 %step, 1
  br i1 %unit, label %contig, label %strided
contig:
  %sub_p = getelementptr inbounds i8, ptr %base, i64 %s_idx
  %res_c = call fastcc %ArchxStr @archx_str_from_slice(ptr %sub_p, i64 %cnt, ptr %reg)
  ret %ArchxStr %res_c
strided:
  %buf = call noalias ptr @malloc(i64 %cnt)
  %bnull = icmp eq ptr %buf, null
  br i1 %bnull, label %oom, label %sloop_pre
oom:
  call void @archx_oom_fail()
  unreachable
sloop_pre:
  br label %sloop
sloop:
  %i = phi i64 [ 0, %sloop_pre ], [ %inext, %sloop ]
  %cur = phi i64 [ %s_idx, %sloop_pre ], [ %curnext, %sloop ]
  %sp = getelementptr inbounds i8, ptr %base, i64 %cur
  %ch = load i8, ptr %sp, align 1
  %dp = getelementptr inbounds i8, ptr %buf, i64 %i
  store i8 %ch, ptr %dp, align 1
  %inext = add nuw nsw i64 %i, 1
  %curnext = add i64 %cur, %step
  %more = icmp slt i64 %inext, %cnt
  br i1 %more, label %sloop, label %sdone
sdone:
  %res_s = call fastcc %ArchxStr @archx_str_from_slice(ptr %buf, i64 %cnt, ptr %reg)
  call void @free(ptr %buf)
  ret %ArchxStr %res_s
}

define private fastcc i64 @archx_hash_i64(i64 %k) alwaysinline nounwind {
entry:
  %s1 = lshr i64 %k, 30
  %x1 = xor i64 %k, %s1
  %m1 = mul i64 %x1, -4658895280553007687
  %s2 = lshr i64 %m1, 27
  %x2 = xor i64 %m1, %s2
  %m2 = mul i64 %x2, -7723592293110705685
  %s3 = lshr i64 %m2, 31
  %x3 = xor i64 %m2, %s3
  ret i64 %x3
}

define private fastcc i64 @archx_hash_str(%ArchxStr %s) alwaysinline nounwind {
entry:
  %w0 = extractvalue %ArchxStr %s, 0
  %w1 = extractvalue %ArchxStr %s, 1
  %len = and i64 %w0, 4294967295
  %short = icmp ule i64 %len, 12
  br i1 %short, label %sso_hash, label %long_hash
sso_hash:
  %p0_raw = lshr i64 %w0, 32
  %le4 = icmp ule i64 %len, 4
  br i1 %le4, label %sso_le4, label %sso_gt4
sso_le4:
  %sh0 = shl i64 %len, 3
  %m0_a = shl i64 1, %sh0
  %m0 = sub i64 %m0_a, 1
  %p0_4 = and i64 %p0_raw, %m0
  br label %sso_mix
sso_gt4:
  %eq12 = icmp eq i64 %len, 12
  br i1 %eq12, label %sso_12, label %sso_mid
sso_12:
  br label %sso_mix
sso_mid:
  %rem = sub i64 %len, 4
  %sh1 = shl i64 %rem, 3
  %m1_a = shl i64 1, %sh1
  %m1 = sub i64 %m1_a, 1
  %p1_m = and i64 %w1, %m1
  br label %sso_mix
sso_mix:
  %p0 = phi i64 [ %p0_4, %sso_le4 ], [ %p0_raw, %sso_12 ], [ %p0_raw, %sso_mid ]
  %p1 = phi i64 [ 0, %sso_le4 ], [ %w1, %sso_12 ], [ %p1_m, %sso_mid ]
  %a0 = mul i64 %p0, -7046029254386353131
  %a1 = mul i64 %p1, -4417276706812531889
  %ax = xor i64 %a0, %a1
  %al = xor i64 %ax, %len
  %res_sso = call fastcc i64 @archx_hash_i64(i64 %al)
  ret i64 %res_sso

long_hash:
  %raw = and i64 %w1, -4
  %ptr = inttoptr i64 %raw to ptr
  %seed = mul i64 %len, -7046029254386353131
  br label %l_cond
l_cond:
  %idx = phi i64 [ 0, %long_hash ], [ %idx_next, %l_body ]
  %acc = phi i64 [ %seed, %long_hash ], [ %acc_next, %l_body ]
  %rem_l = sub i64 %len, %idx
  %ge8 = icmp sge i64 %rem_l, 8
  br i1 %ge8, label %l_body, label %l_tail_cond
l_body:
  %lp = getelementptr inbounds i8, ptr %ptr, i64 %idx
  %lane = load i64, ptr %lp, align 1
  %lm = mul i64 %lane, -4417276706812531889
  %lx = xor i64 %acc, %lm
  %lr = call fastcc i64 @archx_hash_i64(i64 %lx)
  %acc_next = add i64 %lr, %idx
  %idx_next = add i64 %idx, 8
  br label %l_cond
l_tail_cond:
  %ti = phi i64 [ %idx, %l_cond ], [ %ti_next, %l_tail_body ]
  %tacc = phi i64 [ %acc, %l_cond ], [ %tacc_next, %l_tail_body ]
  %tmore = icmp slt i64 %ti, %len
  br i1 %tmore, label %l_tail_body, label %l_done
l_tail_body:
  %tp = getelementptr inbounds i8, ptr %ptr, i64 %ti
  %tb = load i8, ptr %tp, align 1
  %tz = zext i8 %tb to i64
  %tx = xor i64 %tacc, %tz
  %tacc_next = mul i64 %tx, 1099511628211
  %ti_next = add i64 %ti, 1
  br label %l_tail_cond
l_done:
  %res_l = call fastcc i64 @archx_hash_i64(i64 %tacc)
  ret i64 %res_l
}

define private fastcc void @archx_dict_set_ctrl(ptr %ctrl, i64 %scap, i64 %slot, i8 %val) alwaysinline nounwind {
entry:
  %p = getelementptr inbounds i8, ptr %ctrl, i64 %slot
  store i8 %val, ptr %p, align 1
  %mir = icmp ult i64 %slot, 16
  br i1 %mir, label %do_mir, label %done
do_mir:
  %moff = add i64 %scap, %slot
  %mp = getelementptr inbounds i8, ptr %ctrl, i64 %moff
  store i8 %val, ptr %mp, align 1
  br label %done
done:
  ret void
}

define private fastcc i64 @archx_dict_new(i64 %meta, ptr %reg) {
entry:
  %is_reg = icmp ne ptr %reg, null
  br i1 %is_reg, label %alloc_reg, label %alloc_heap
alloc_reg:
  %rp = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 64)
  call void @llvm.memset.p0.i64(ptr nonnull align 16 %rp, i8 0, i64 64, i1 false)
  %r_reg_gep = getelementptr inbounds %ArchxDictHdr, ptr %rp, i32 0, i32 3
  store ptr %reg, ptr %r_reg_gep, align 8
  %r_meta_gep = getelementptr inbounds %ArchxDictHdr, ptr %rp, i32 0, i32 7
  store i64 %meta, ptr %r_meta_gep, align 8
  %rpi = ptrtoint ptr %rp to i64
  %rtag = or i64 %rpi, 2
  ret i64 %rtag
alloc_heap:
  %hp = call noalias align 16 ptr @calloc(i64 1, i64 64)
  %hnull = icmp eq ptr %hp, null
  br i1 %hnull, label %oom, label %ok
oom:
  call void @archx_oom_fail()
  unreachable
ok:
  %h_meta_gep = getelementptr inbounds %ArchxDictHdr, ptr %hp, i32 0, i32 7
  store i64 %meta, ptr %h_meta_gep, align 8
  %hpi = ptrtoint ptr %hp to i64
  %htag = or i64 %hpi, 1
  ret i64 %htag
}

define private fastcc i64 @archx_dict_key_hash_at(ptr %keys, i64 %idx, i64 %kind) {
entry:
  %is0 = icmp eq i64 %kind, 0
  br i1 %is0, label %k_i64, label %chk1
k_i64:
  %pi = getelementptr inbounds i64, ptr %keys, i64 %idx
  %vi = load i64, ptr %pi, align 8
  %hi = call fastcc i64 @archx_hash_i64(i64 %vi)
  ret i64 %hi
chk1:
  %is1 = icmp eq i64 %kind, 1
  br i1 %is1, label %k_str, label %k_any
k_any:
  %pa = getelementptr inbounds %ArchxAny, ptr %keys, i64 %idx
  %va = load %ArchxAny, ptr %pa, align 8
  %ha = call fastcc i64 @archx_any_hash(%ArchxAny %va)
  ret i64 %ha
k_str:
  %ps = getelementptr inbounds %ArchxStr, ptr %keys, i64 %idx
  %vs = load %ArchxStr, ptr %ps, align 8
  %hs = call fastcc i64 @archx_hash_str(%ArchxStr %vs)
  ret i64 %hs
}

define private fastcc void @archx_dict_grow(ptr %hdr) noinline {
entry:
  %len_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 0
  %used_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %reg_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 3
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6
  %meta_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 7

  %len = load i64, ptr %len_p, align 8
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
  %old_scap = add i64 %old_mask, 1
  %dbl_scap = shl i64 %old_scap, 1
  %new_scap = select i1 %uninit, i64 16, i64 %dbl_scap
  %new_mask = sub i64 %new_scap, 1
  %sc7 = mul i64 %new_scap, 7
  %new_dcap = lshr i64 %sc7, 3

  %c_mul = mul i64 %new_scap, 5
  %ctrl_bytes = add i64 %c_mul, 16
  %ctrl_init_len = add i64 %new_scap, 16
  %k_bytes = mul i64 %new_dcap, %ksz
  %v_bytes = mul i64 %new_dcap, %vsz
  %has_vals = icmp ugt i64 %vsz, 0
  %in_reg = icmp ne ptr %reg, null
  br i1 %in_reg, label %grow_reg, label %grow_heap
grow_reg:
  %rc = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %ctrl_bytes)
  %rk = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %k_bytes)
  %has_old_k = icmp sgt i64 %len, 0
  br i1 %has_old_k, label %rk_copy, label %rk_done
rk_copy:
  %old_kb = mul i64 %len, %ksz
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %rk, ptr nonnull align 8 %old_keys, i64 %old_kb, i1 false)
  br label %rk_done
rk_done:
  br i1 %has_vals, label %rv_alloc, label %rv_null
rv_alloc:
  %rv = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr %reg, i64 %v_bytes)
  br i1 %has_old_k, label %rv_copy, label %rv_set
rv_copy:
  %old_vb = mul i64 %len, %vsz
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %rv, ptr nonnull align 1 %old_vals, i64 %old_vb, i1 false)
  br label %rv_set
rv_set:
  br label %alloc_done
rv_null:
  br label %alloc_done
grow_heap:
  %hc = call noalias align 16 ptr @malloc(i64 %ctrl_bytes)
  %hc_null = icmp eq ptr %hc, null
  br i1 %hc_null, label %oom, label %hk_do
hk_do:
  %hk = call ptr @realloc(ptr %old_keys, i64 %k_bytes)
  %hk_null = icmp eq ptr %hk, null
  br i1 %hk_null, label %oom, label %hv_chk
hv_chk:
  br i1 %has_vals, label %hv_do, label %hv_skip
hv_do:
  %hv = call ptr @realloc(ptr %old_vals, i64 %v_bytes)
  %hv_null = icmp eq ptr %hv, null
  br i1 %hv_null, label %oom, label %hfree_old
hv_skip:
  br label %hfree_old
hfree_old:
  %hv_phi = phi ptr [ %hv, %hv_do ], [ null, %hv_skip ]
  call void @free(ptr %old_ctrl)
  br label %alloc_done
oom:
  call void @archx_oom_fail()
  unreachable
alloc_done:
  %new_ctrl = phi ptr [ %rc, %rv_set ], [ %rc, %rv_null ], [ %hc, %hfree_old ]
  %new_keys = phi ptr [ %rk, %rv_set ], [ %rk, %rv_null ], [ %hk, %hfree_old ]
  %new_vals = phi ptr [ %rv, %rv_set ], [ null, %rv_null ], [ %hv_phi, %hfree_old ]
  call void @llvm.memset.p0.i64(ptr nonnull align 1 %new_ctrl, i8 -128, i64 %ctrl_init_len, i1 false)
  %idx_base = getelementptr inbounds i8, ptr %new_ctrl, i64 %ctrl_init_len
  br label %rehash_cond
rehash_cond:
  %i = phi i64 [ 0, %alloc_done ], [ %i_next, %rehash_put ]
  %more = icmp slt i64 %i, %len
  br i1 %more, label %rehash_item, label %rehash_done
rehash_item:
  %h = call fastcc i64 @archx_dict_key_hash_at(ptr %new_keys, i64 %i, i64 %kind)
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %pos0 = and i64 %h, %new_mask
  br label %rprobe
rprobe:
  %pos = phi i64 [ %pos0, %rehash_item ], [ %pos_next, %rprobe_next ]
  %step = phi i64 [ 0, %rehash_item ], [ %step_next, %rprobe_next ]
  %gp = getelementptr inbounds i8, ptr %new_ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %ecmp = icmp eq <16 x i8> %grp, <i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128>
  %ebits = bitcast <16 x i1> %ecmp to i16
  %emask = zext i16 %ebits to i32
  %has_e = icmp ne i32 %emask, 0
  br i1 %has_e, label %rehash_put, label %rprobe_next
rprobe_next:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %new_mask
  br label %rprobe
rehash_put:
  %tz = call i32 @llvm.cttz.i32(i32 %emask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %slot = and i64 %s_add, %new_mask
  call fastcc void @archx_dict_set_ctrl(ptr %new_ctrl, i64 %new_scap, i64 %slot, i8 %h2)
  %ip = getelementptr inbounds i32, ptr %idx_base, i64 %slot
  %i32v = trunc i64 %i to i32
  store i32 %i32v, ptr %ip, align 4
  %i_next = add nuw nsw i64 %i, 1
  br label %rehash_cond
rehash_done:
  store i64 %len, ptr %used_p, align 8
  store i64 %new_mask, ptr %mask_p, align 8
  store ptr %new_ctrl, ptr %ctrl_p, align 8
  store ptr %new_keys, ptr %keys_p, align 8
  store ptr %new_vals, ptr %vals_p, align 8
  ret void
}

define private fastcc { i64, i64 } @archx_dict_find_h_i64(i64 %d, i64 %key, i64 %h) alwaysinline {
entry:
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %not_found_empty, label %chk_ctrl
chk_ctrl:
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %c_null = icmp eq ptr %ctrl, null
  br i1 %c_null, label %not_found_empty, label %do_probe
do_probe:
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %mask = load i64, ptr %mask_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %scap = add i64 %mask, 1
  %c_init = add i64 %scap, 16
  %idx_base = getelementptr inbounds i8, ptr %ctrl, i64 %c_init
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %h2_ins = insertelement <16 x i8> poison, i8 %h2, i32 0
  %h2_vec = shufflevector <16 x i8> %h2_ins, <16 x i8> poison, <16 x i32> zeroinitializer
  %pos0 = and i64 %h, %mask
  br label %probe
probe:
  %pos = phi i64 [ %pos0, %do_probe ], [ %pos_next, %next_grp ]
  %step = phi i64 [ 0, %do_probe ], [ %step_next, %next_grp ]
  %avail = phi i64 [ -1, %do_probe ], [ %avail_cur, %next_grp ]
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %mcmp = icmp eq <16 x i8> %grp, %h2_vec
  %mbits = bitcast <16 x i1> %mcmp to i16
  %mmask0 = zext i16 %mbits to i32
  br label %mbit
mbit:
  %mmask = phi i32 [ %mmask0, %probe ], [ %mmask_next, %mbit_cont ]
  %has_m = icmp ne i32 %mmask, 0
  br i1 %has_m, label %chk_key, label %chk_empty
chk_key:
  %tz = call i32 @llvm.cttz.i32(i32 %mmask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %slot = and i64 %s_add, %mask
  %ip = getelementptr inbounds i32, ptr %idx_base, i64 %slot
  %didx32 = load i32, ptr %ip, align 4
  %didx = zext i32 %didx32 to i64
  %kp = getelementptr inbounds i64, ptr %keys, i64 %didx
  %cand_k = load i64, ptr %kp, align 8
  %eq = icmp eq i64 %cand_k, %key
  br i1 %eq, label %found, label %mbit_cont
mbit_cont:
  %mm1 = sub i32 %mmask, 1
  %mmask_next = and i32 %mmask, %mm1
  br label %mbit
chk_empty:
  %need_a = icmp slt i64 %avail, 0
  br i1 %need_a, label %find_a, label %after_a
find_a:
  %acmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits16 = bitcast <16 x i1> %acmp to i16
  %amask0 = zext i16 %abits16 to i32
  %has_a0 = icmp ne i32 %amask0, 0
  br i1 %has_a0, label %set_a, label %after_a
set_a:
  %atz = call i32 @llvm.cttz.i32(i32 %amask0, i1 true)
  %atz64 = zext i32 %atz to i64
  %as_add = add i64 %pos, %atz64
  %aslot = and i64 %as_add, %mask
  br label %after_a
after_a:
  %avail_cur = phi i64 [ %avail, %chk_empty ], [ -1, %find_a ], [ %aslot, %set_a ]
  %ecmp = icmp eq <16 x i8> %grp, <i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128>
  %ebits = bitcast <16 x i1> %ecmp to i16
  %has_e = icmp ne i16 %ebits, 0
  br i1 %has_e, label %not_found_avail, label %next_grp
next_grp:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %mask
  br label %probe
found:
  %f0 = insertvalue { i64, i64 } poison, i64 %didx, 0
  %f1 = insertvalue { i64, i64 } %f0, i64 %slot, 1
  ret { i64, i64 } %f1
not_found_avail:
  %nf0 = insertvalue { i64, i64 } poison, i64 -1, 0
  %nf1 = insertvalue { i64, i64 } %nf0, i64 %avail_cur, 1
  ret { i64, i64 } %nf1
not_found_empty:
  ret { i64, i64 } { i64 -1, i64 -1 }
}

define private fastcc { i64, i64 } @archx_dict_find_i64(i64 %d, i64 %key) alwaysinline {
entry:
  %h = call fastcc i64 @archx_hash_i64(i64 %key)
  %res = call fastcc { i64, i64 } @archx_dict_find_h_i64(i64 %d, i64 %key, i64 %h)
  ret { i64, i64 } %res
}

define private fastcc i64 @archx_dict_lookup_i64(i64 %d, i64 %key) alwaysinline {
entry:
  %pair = call fastcc { i64, i64 } @archx_dict_find_i64(i64 %d, i64 %key)
  %didx = extractvalue { i64, i64 } %pair, 0
  ret i64 %didx
}

define private fastcc { i64, i1 } @archx_dict_upsert_i64(i64 %d, i64 %key) {
entry:
  %h = call fastcc i64 @archx_hash_i64(i64 %key)
  %raw = and i64 %d, -4
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %ctrl0 = load ptr, ptr %ctrl_p, align 8
  %uninit = icmp eq ptr %ctrl0, null
  br i1 %uninit, label %do_grow0, label %chk_probe_existing
do_grow0:
  call fastcc void @archx_dict_grow(ptr %hdr)
  br label %probe_insert_init
chk_probe_existing:
  %found_pair = call fastcc { i64, i64 } @archx_dict_find_h_i64(i64 %d, i64 %key, i64 %h)
  %found_idx = extractvalue { i64, i64 } %found_pair, 0
  %avail_slot = extractvalue { i64, i64 } %found_pair, 1
  %exists = icmp sge i64 %found_idx, 0
  br i1 %exists, label %ret_existing, label %chk_cap
ret_existing:
  %re0 = insertvalue { i64, i1 } poison, i64 %found_idx, 0
  %re1 = insertvalue { i64, i1 } %re0, i1 true, 1
  ret { i64, i1 } %re1
chk_cap:
  %used_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %used0 = load i64, ptr %used_p, align 8
  %mask0 = load i64, ptr %mask_p, align 8
  %scap0 = add i64 %mask0, 1
  %u1 = add i64 %used0, 1
  %lhs = shl i64 %u1, 3
  %rhs = mul i64 %scap0, 7
  %full = icmp sgt i64 %lhs, %rhs
  br i1 %full, label %do_grow1, label %fast_insert_prep
fast_insert_prep:
  %len_pf = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 0
  %used_pf = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %keys_pf = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %keys_f = load ptr, ptr %keys_pf, align 8
  %c_init_f = add i64 %scap0, 16
  %idx_base_f = getelementptr inbounds i8, ptr %ctrl0, i64 %c_init_f
  %h2_64_f = lshr i64 %h, 57
  %h2_f = trunc i64 %h2_64_f to i8
  br label %iput_commit
do_grow1:
  call fastcc void @archx_dict_grow(ptr %hdr)
  br label %probe_insert_init
probe_insert_init:
  %len_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 0
  %used_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %mask_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %keys_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %mask = load i64, ptr %mask_p2, align 8
  %keys = load ptr, ptr %keys_p2, align 8
  %scap = add i64 %mask, 1
  %c_init = add i64 %scap, 16
  %idx_base = getelementptr inbounds i8, ptr %ctrl, i64 %c_init
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %pos0 = and i64 %h, %mask
  br label %iprobe
iprobe:
  %pos = phi i64 [ %pos0, %probe_insert_init ], [ %pos_next, %inext ]
  %step = phi i64 [ 0, %probe_insert_init ], [ %step_next, %inext ]
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %avail_cmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits = bitcast <16 x i1> %avail_cmp to i16
  %amask = zext i16 %abits to i32
  %has_a = icmp ne i32 %amask, 0
  br i1 %has_a, label %iput, label %inext
inext:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %mask
  br label %iprobe
iput:
  %tz = call i32 @llvm.cttz.i32(i32 %amask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %slot_g = and i64 %s_add, %mask
  br label %iput_commit
iput_commit:
  %slot = phi i64 [ %avail_slot, %fast_insert_prep ], [ %slot_g, %iput ]
  %ctrl_c = phi ptr [ %ctrl0, %fast_insert_prep ], [ %ctrl, %iput ]
  %scap_c = phi i64 [ %scap0, %fast_insert_prep ], [ %scap, %iput ]
  %idx_base_c = phi ptr [ %idx_base_f, %fast_insert_prep ], [ %idx_base, %iput ]
  %keys_c = phi ptr [ %keys_f, %fast_insert_prep ], [ %keys, %iput ]
  %len_pc = phi ptr [ %len_pf, %fast_insert_prep ], [ %len_p, %iput ]
  %used_pc = phi ptr [ %used_pf, %fast_insert_prep ], [ %used_p2, %iput ]
  %h2_c = phi i8 [ %h2_f, %fast_insert_prep ], [ %h2, %iput ]
  %sp_c = getelementptr inbounds i8, ptr %ctrl_c, i64 %slot
  %old_cb = load i8, ptr %sp_c, align 1
  %was_empty = icmp eq i8 %old_cb, -128
  %u_cur = load i64, ptr %used_pc, align 8
  %u_inc = zext i1 %was_empty to i64
  %u_new = add i64 %u_cur, %u_inc
  store i64 %u_new, ptr %used_pc, align 8
  call fastcc void @archx_dict_set_ctrl(ptr %ctrl_c, i64 %scap_c, i64 %slot, i8 %h2_c)
  %d_idx = load i64, ptr %len_pc, align 8
  %d_new = add i64 %d_idx, 1
  store i64 %d_new, ptr %len_pc, align 8
  %ip = getelementptr inbounds i32, ptr %idx_base_c, i64 %slot
  %d_idx32 = trunc i64 %d_idx to i32
  store i32 %d_idx32, ptr %ip, align 4
  %stored_k = add i64 %key, 0
  %kp = getelementptr inbounds i64, ptr %keys_c, i64 %d_idx
  store i64 %stored_k, ptr %kp, align 8
  %rn0 = insertvalue { i64, i1 } poison, i64 %d_idx, 0
  %rn1 = insertvalue { i64, i1 } %rn0, i1 false, 1
  ret { i64, i1 } %rn1
}

define private fastcc { i64, i64 } @archx_dict_find_h_str(i64 %d, %ArchxStr %key, i64 %h) alwaysinline {
entry:
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %not_found_empty, label %chk_ctrl
chk_ctrl:
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %c_null = icmp eq ptr %ctrl, null
  br i1 %c_null, label %not_found_empty, label %do_probe
do_probe:
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %mask = load i64, ptr %mask_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %scap = add i64 %mask, 1
  %c_init = add i64 %scap, 16
  %idx_base = getelementptr inbounds i8, ptr %ctrl, i64 %c_init
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %h2_ins = insertelement <16 x i8> poison, i8 %h2, i32 0
  %h2_vec = shufflevector <16 x i8> %h2_ins, <16 x i8> poison, <16 x i32> zeroinitializer
  %pos0 = and i64 %h, %mask
  br label %probe
probe:
  %pos = phi i64 [ %pos0, %do_probe ], [ %pos_next, %next_grp ]
  %step = phi i64 [ 0, %do_probe ], [ %step_next, %next_grp ]
  %avail = phi i64 [ -1, %do_probe ], [ %avail_cur, %next_grp ]
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %mcmp = icmp eq <16 x i8> %grp, %h2_vec
  %mbits = bitcast <16 x i1> %mcmp to i16
  %mmask0 = zext i16 %mbits to i32
  br label %mbit
mbit:
  %mmask = phi i32 [ %mmask0, %probe ], [ %mmask_next, %mbit_cont ]
  %has_m = icmp ne i32 %mmask, 0
  br i1 %has_m, label %chk_key, label %chk_empty
chk_key:
  %tz = call i32 @llvm.cttz.i32(i32 %mmask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %slot = and i64 %s_add, %mask
  %ip = getelementptr inbounds i32, ptr %idx_base, i64 %slot
  %didx32 = load i32, ptr %ip, align 4
  %didx = zext i32 %didx32 to i64
  %kp = getelementptr inbounds %ArchxStr, ptr %keys, i64 %didx
  %cand_k = load %ArchxStr, ptr %kp, align 8
  %eq = call fastcc i1 @archx_str_eq(%ArchxStr %cand_k, %ArchxStr %key)
  br i1 %eq, label %found, label %mbit_cont
mbit_cont:
  %mm1 = sub i32 %mmask, 1
  %mmask_next = and i32 %mmask, %mm1
  br label %mbit
chk_empty:
  %need_a = icmp slt i64 %avail, 0
  br i1 %need_a, label %find_a, label %after_a
find_a:
  %acmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits16 = bitcast <16 x i1> %acmp to i16
  %amask0 = zext i16 %abits16 to i32
  %has_a0 = icmp ne i32 %amask0, 0
  br i1 %has_a0, label %set_a, label %after_a
set_a:
  %atz = call i32 @llvm.cttz.i32(i32 %amask0, i1 true)
  %atz64 = zext i32 %atz to i64
  %as_add = add i64 %pos, %atz64
  %aslot = and i64 %as_add, %mask
  br label %after_a
after_a:
  %avail_cur = phi i64 [ %avail, %chk_empty ], [ -1, %find_a ], [ %aslot, %set_a ]
  %ecmp = icmp eq <16 x i8> %grp, <i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128>
  %ebits = bitcast <16 x i1> %ecmp to i16
  %has_e = icmp ne i16 %ebits, 0
  br i1 %has_e, label %not_found_avail, label %next_grp
next_grp:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %mask
  br label %probe
found:
  %f0 = insertvalue { i64, i64 } poison, i64 %didx, 0
  %f1 = insertvalue { i64, i64 } %f0, i64 %slot, 1
  ret { i64, i64 } %f1
not_found_avail:
  %nf0 = insertvalue { i64, i64 } poison, i64 -1, 0
  %nf1 = insertvalue { i64, i64 } %nf0, i64 %avail_cur, 1
  ret { i64, i64 } %nf1
not_found_empty:
  ret { i64, i64 } { i64 -1, i64 -1 }
}

define private fastcc { i64, i64 } @archx_dict_find_str(i64 %d, %ArchxStr %key) alwaysinline {
entry:
  %h = call fastcc i64 @archx_hash_str(%ArchxStr %key)
  %res = call fastcc { i64, i64 } @archx_dict_find_h_str(i64 %d, %ArchxStr %key, i64 %h)
  ret { i64, i64 } %res
}

define private fastcc i64 @archx_dict_lookup_str(i64 %d, %ArchxStr %key) alwaysinline {
entry:
  %pair = call fastcc { i64, i64 } @archx_dict_find_str(i64 %d, %ArchxStr %key)
  %didx = extractvalue { i64, i64 } %pair, 0
  ret i64 %didx
}

define private fastcc { i64, i1 } @archx_dict_upsert_str(i64 %d, %ArchxStr %key) {
entry:
  %h = call fastcc i64 @archx_hash_str(%ArchxStr %key)
  %raw = and i64 %d, -4
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %ctrl0 = load ptr, ptr %ctrl_p, align 8
  %uninit = icmp eq ptr %ctrl0, null
  br i1 %uninit, label %do_grow0, label %chk_probe_existing
do_grow0:
  call fastcc void @archx_dict_grow(ptr %hdr)
  br label %probe_insert_init
chk_probe_existing:
  %found_pair = call fastcc { i64, i64 } @archx_dict_find_h_str(i64 %d, %ArchxStr %key, i64 %h)
  %found_idx = extractvalue { i64, i64 } %found_pair, 0
  %avail_slot = extractvalue { i64, i64 } %found_pair, 1
  %exists = icmp sge i64 %found_idx, 0
  br i1 %exists, label %ret_existing, label %chk_cap
ret_existing:
  %re0 = insertvalue { i64, i1 } poison, i64 %found_idx, 0
  %re1 = insertvalue { i64, i1 } %re0, i1 true, 1
  ret { i64, i1 } %re1
chk_cap:
  %used_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %used0 = load i64, ptr %used_p, align 8
  %mask0 = load i64, ptr %mask_p, align 8
  %scap0 = add i64 %mask0, 1
  %u1 = add i64 %used0, 1
  %lhs = shl i64 %u1, 3
  %rhs = mul i64 %scap0, 7
  %full = icmp sgt i64 %lhs, %rhs
  br i1 %full, label %do_grow1, label %fast_insert_prep
fast_insert_prep:
  %len_pf = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 0
  %used_pf = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %keys_pf = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %keys_f = load ptr, ptr %keys_pf, align 8
  %c_init_f = add i64 %scap0, 16
  %idx_base_f = getelementptr inbounds i8, ptr %ctrl0, i64 %c_init_f
  %h2_64_f = lshr i64 %h, 57
  %h2_f = trunc i64 %h2_64_f to i8
  br label %iput_commit
do_grow1:
  call fastcc void @archx_dict_grow(ptr %hdr)
  br label %probe_insert_init
probe_insert_init:
  %len_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 0
  %used_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %mask_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %keys_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %mask = load i64, ptr %mask_p2, align 8
  %keys = load ptr, ptr %keys_p2, align 8
  %scap = add i64 %mask, 1
  %c_init = add i64 %scap, 16
  %idx_base = getelementptr inbounds i8, ptr %ctrl, i64 %c_init
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %pos0 = and i64 %h, %mask
  br label %iprobe
iprobe:
  %pos = phi i64 [ %pos0, %probe_insert_init ], [ %pos_next, %inext ]
  %step = phi i64 [ 0, %probe_insert_init ], [ %step_next, %inext ]
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %avail_cmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits = bitcast <16 x i1> %avail_cmp to i16
  %amask = zext i16 %abits to i32
  %has_a = icmp ne i32 %amask, 0
  br i1 %has_a, label %iput, label %inext
inext:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %mask
  br label %iprobe
iput:
  %tz = call i32 @llvm.cttz.i32(i32 %amask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %slot_g = and i64 %s_add, %mask
  br label %iput_commit
iput_commit:
  %slot = phi i64 [ %avail_slot, %fast_insert_prep ], [ %slot_g, %iput ]
  %ctrl_c = phi ptr [ %ctrl0, %fast_insert_prep ], [ %ctrl, %iput ]
  %scap_c = phi i64 [ %scap0, %fast_insert_prep ], [ %scap, %iput ]
  %idx_base_c = phi ptr [ %idx_base_f, %fast_insert_prep ], [ %idx_base, %iput ]
  %keys_c = phi ptr [ %keys_f, %fast_insert_prep ], [ %keys, %iput ]
  %len_pc = phi ptr [ %len_pf, %fast_insert_prep ], [ %len_p, %iput ]
  %used_pc = phi ptr [ %used_pf, %fast_insert_prep ], [ %used_p2, %iput ]
  %h2_c = phi i8 [ %h2_f, %fast_insert_prep ], [ %h2, %iput ]
  %sp_c = getelementptr inbounds i8, ptr %ctrl_c, i64 %slot
  %old_cb = load i8, ptr %sp_c, align 1
  %was_empty = icmp eq i8 %old_cb, -128
  %u_cur = load i64, ptr %used_pc, align 8
  %u_inc = zext i1 %was_empty to i64
  %u_new = add i64 %u_cur, %u_inc
  store i64 %u_new, ptr %used_pc, align 8
  call fastcc void @archx_dict_set_ctrl(ptr %ctrl_c, i64 %scap_c, i64 %slot, i8 %h2_c)
  %d_idx = load i64, ptr %len_pc, align 8
  %d_new = add i64 %d_idx, 1
  store i64 %d_new, ptr %len_pc, align 8
  %ip = getelementptr inbounds i32, ptr %idx_base_c, i64 %slot
  %d_idx32 = trunc i64 %d_idx to i32
  store i32 %d_idx32, ptr %ip, align 4
  %stored_k = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %key)
  %kp = getelementptr inbounds %ArchxStr, ptr %keys_c, i64 %d_idx
  store %ArchxStr %stored_k, ptr %kp, align 8
  %rn0 = insertvalue { i64, i1 } poison, i64 %d_idx, 0
  %rn1 = insertvalue { i64, i1 } %rn0, i1 false, 1
  ret { i64, i1 } %rn1
}

define private fastcc { i64, i64 } @archx_dict_find_h_any(i64 %d, %ArchxAny %key, i64 %h) {
entry:
  %raw = and i64 %d, -4
  %is_z = icmp eq i64 %raw, 0
  br i1 %is_z, label %not_found_empty, label %chk_ctrl
chk_ctrl:
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %c_null = icmp eq ptr %ctrl, null
  br i1 %c_null, label %not_found_empty, label %do_probe
do_probe:
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %mask = load i64, ptr %mask_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %scap = add i64 %mask, 1
  %c_init = add i64 %scap, 16
  %idx_base = getelementptr inbounds i8, ptr %ctrl, i64 %c_init
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %h2_ins = insertelement <16 x i8> poison, i8 %h2, i32 0
  %h2_vec = shufflevector <16 x i8> %h2_ins, <16 x i8> poison, <16 x i32> zeroinitializer
  %pos0 = and i64 %h, %mask
  br label %probe
probe:
  %pos = phi i64 [ %pos0, %do_probe ], [ %pos_next, %next_grp ]
  %step = phi i64 [ 0, %do_probe ], [ %step_next, %next_grp ]
  %avail = phi i64 [ -1, %do_probe ], [ %avail_cur, %next_grp ]
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %mcmp = icmp eq <16 x i8> %grp, %h2_vec
  %mbits = bitcast <16 x i1> %mcmp to i16
  %mmask0 = zext i16 %mbits to i32
  br label %mbit
mbit:
  %mmask = phi i32 [ %mmask0, %probe ], [ %mmask_next, %mbit_cont ]
  %has_m = icmp ne i32 %mmask, 0
  br i1 %has_m, label %chk_key, label %chk_empty
chk_key:
  %tz = call i32 @llvm.cttz.i32(i32 %mmask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %slot = and i64 %s_add, %mask
  %ip = getelementptr inbounds i32, ptr %idx_base, i64 %slot
  %didx32 = load i32, ptr %ip, align 4
  %didx = zext i32 %didx32 to i64
  %kp = getelementptr inbounds %ArchxAny, ptr %keys, i64 %didx
  %cand_k = load %ArchxAny, ptr %kp, align 8
  %eq = call fastcc i1 @archx_any_eq(%ArchxAny %cand_k, %ArchxAny %key)
  br i1 %eq, label %found, label %mbit_cont
mbit_cont:
  %mm1 = sub i32 %mmask, 1
  %mmask_next = and i32 %mmask, %mm1
  br label %mbit
chk_empty:
  %need_a = icmp slt i64 %avail, 0
  br i1 %need_a, label %find_a, label %after_a
find_a:
  %acmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits16 = bitcast <16 x i1> %acmp to i16
  %amask0 = zext i16 %abits16 to i32
  %has_a0 = icmp ne i32 %amask0, 0
  br i1 %has_a0, label %set_a, label %after_a
set_a:
  %atz = call i32 @llvm.cttz.i32(i32 %amask0, i1 true)
  %atz64 = zext i32 %atz to i64
  %as_add = add i64 %pos, %atz64
  %aslot = and i64 %as_add, %mask
  br label %after_a
after_a:
  %avail_cur = phi i64 [ %avail, %chk_empty ], [ -1, %find_a ], [ %aslot, %set_a ]
  %ecmp = icmp eq <16 x i8> %grp, <i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128, i8 -128>
  %ebits = bitcast <16 x i1> %ecmp to i16
  %has_e = icmp ne i16 %ebits, 0
  br i1 %has_e, label %not_found_avail, label %next_grp
next_grp:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %mask
  br label %probe
found:
  %f0 = insertvalue { i64, i64 } poison, i64 %didx, 0
  %f1 = insertvalue { i64, i64 } %f0, i64 %slot, 1
  ret { i64, i64 } %f1
not_found_avail:
  %nf0 = insertvalue { i64, i64 } poison, i64 -1, 0
  %nf1 = insertvalue { i64, i64 } %nf0, i64 %avail_cur, 1
  ret { i64, i64 } %nf1
not_found_empty:
  ret { i64, i64 } { i64 -1, i64 -1 }
}

define private fastcc { i64, i64 } @archx_dict_find_any(i64 %d, %ArchxAny %key) {
entry:
  %h = call fastcc i64 @archx_any_hash(%ArchxAny %key)
  %res = call fastcc { i64, i64 } @archx_dict_find_h_any(i64 %d, %ArchxAny %key, i64 %h)
  ret { i64, i64 } %res
}

define private fastcc i64 @archx_dict_lookup_any(i64 %d, %ArchxAny %key) {
entry:
  %pair = call fastcc { i64, i64 } @archx_dict_find_any(i64 %d, %ArchxAny %key)
  %didx = extractvalue { i64, i64 } %pair, 0
  ret i64 %didx
}

define private fastcc { i64, i1 } @archx_dict_upsert_any(i64 %d, %ArchxAny %key) {
entry:
  %h = call fastcc i64 @archx_any_hash(%ArchxAny %key)
  %raw = and i64 %d, -4
  %hdr = inttoptr i64 %raw to ptr
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %ctrl0 = load ptr, ptr %ctrl_p, align 8
  %uninit = icmp eq ptr %ctrl0, null
  br i1 %uninit, label %do_grow0, label %chk_probe_existing
do_grow0:
  call fastcc void @archx_dict_grow(ptr %hdr)
  br label %probe_insert_init
chk_probe_existing:
  %found_pair = call fastcc { i64, i64 } @archx_dict_find_h_any(i64 %d, %ArchxAny %key, i64 %h)
  %found_idx = extractvalue { i64, i64 } %found_pair, 0
  %avail_slot = extractvalue { i64, i64 } %found_pair, 1
  %exists = icmp sge i64 %found_idx, 0
  br i1 %exists, label %ret_existing, label %chk_cap
ret_existing:
  %re0 = insertvalue { i64, i1 } poison, i64 %found_idx, 0
  %re1 = insertvalue { i64, i1 } %re0, i1 true, 1
  ret { i64, i1 } %re1
chk_cap:
  %used_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %used0 = load i64, ptr %used_p, align 8
  %mask0 = load i64, ptr %mask_p, align 8
  %scap0 = add i64 %mask0, 1
  %u1 = add i64 %used0, 1
  %lhs = shl i64 %u1, 3
  %rhs = mul i64 %scap0, 7
  %full = icmp sgt i64 %lhs, %rhs
  br i1 %full, label %do_grow1, label %fast_insert_prep
fast_insert_prep:
  %len_pf = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 0
  %used_pf = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %keys_pf = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %keys_f = load ptr, ptr %keys_pf, align 8
  %c_init_f = add i64 %scap0, 16
  %idx_base_f = getelementptr inbounds i8, ptr %ctrl0, i64 %c_init_f
  %h2_64_f = lshr i64 %h, 57
  %h2_f = trunc i64 %h2_64_f to i8
  br label %iput_commit
do_grow1:
  call fastcc void @archx_dict_grow(ptr %hdr)
  br label %probe_insert_init
probe_insert_init:
  %len_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 0
  %used_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 1
  %mask_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %keys_p2 = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %mask = load i64, ptr %mask_p2, align 8
  %keys = load ptr, ptr %keys_p2, align 8
  %scap = add i64 %mask, 1
  %c_init = add i64 %scap, 16
  %idx_base = getelementptr inbounds i8, ptr %ctrl, i64 %c_init
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %pos0 = and i64 %h, %mask
  br label %iprobe
iprobe:
  %pos = phi i64 [ %pos0, %probe_insert_init ], [ %pos_next, %inext ]
  %step = phi i64 [ 0, %probe_insert_init ], [ %step_next, %inext ]
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %avail_cmp = icmp slt <16 x i8> %grp, zeroinitializer
  %abits = bitcast <16 x i1> %avail_cmp to i16
  %amask = zext i16 %abits to i32
  %has_a = icmp ne i32 %amask, 0
  br i1 %has_a, label %iput, label %inext
inext:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %mask
  br label %iprobe
iput:
  %tz = call i32 @llvm.cttz.i32(i32 %amask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %slot_g = and i64 %s_add, %mask
  br label %iput_commit
iput_commit:
  %slot = phi i64 [ %avail_slot, %fast_insert_prep ], [ %slot_g, %iput ]
  %ctrl_c = phi ptr [ %ctrl0, %fast_insert_prep ], [ %ctrl, %iput ]
  %scap_c = phi i64 [ %scap0, %fast_insert_prep ], [ %scap, %iput ]
  %idx_base_c = phi ptr [ %idx_base_f, %fast_insert_prep ], [ %idx_base, %iput ]
  %keys_c = phi ptr [ %keys_f, %fast_insert_prep ], [ %keys, %iput ]
  %len_pc = phi ptr [ %len_pf, %fast_insert_prep ], [ %len_p, %iput ]
  %used_pc = phi ptr [ %used_pf, %fast_insert_prep ], [ %used_p2, %iput ]
  %h2_c = phi i8 [ %h2_f, %fast_insert_prep ], [ %h2, %iput ]
  %sp_c = getelementptr inbounds i8, ptr %ctrl_c, i64 %slot
  %old_cb = load i8, ptr %sp_c, align 1
  %was_empty = icmp eq i8 %old_cb, -128
  %u_cur = load i64, ptr %used_pc, align 8
  %u_inc = zext i1 %was_empty to i64
  %u_new = add i64 %u_cur, %u_inc
  store i64 %u_new, ptr %used_pc, align 8
  call fastcc void @archx_dict_set_ctrl(ptr %ctrl_c, i64 %scap_c, i64 %slot, i8 %h2_c)
  %d_idx = load i64, ptr %len_pc, align 8
  %d_new = add i64 %d_idx, 1
  store i64 %d_new, ptr %len_pc, align 8
  %ip = getelementptr inbounds i32, ptr %idx_base_c, i64 %slot
  %d_idx32 = trunc i64 %d_idx to i32
  store i32 %d_idx32, ptr %ip, align 4
  %stored_k = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %key)
  %kp = getelementptr inbounds %ArchxAny, ptr %keys_c, i64 %d_idx
  store %ArchxAny %stored_k, ptr %kp, align 8
  %rn0 = insertvalue { i64, i1 } poison, i64 %d_idx, 0
  %rn1 = insertvalue { i64, i1 } %rn0, i1 false, 1
  ret { i64, i1 } %rn1
}

define private fastcc void @archx_dict_erase_slot(ptr %hdr, i64 %sparse_slot) {
entry:
  %len_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 0
  %mask_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 2
  %ctrl_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 4
  %keys_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 5
  %vals_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 6
  %meta_p = getelementptr inbounds %ArchxDictHdr, ptr %hdr, i32 0, i32 7

  %len = load i64, ptr %len_p, align 8
  %mask = load i64, ptr %mask_p, align 8
  %ctrl = load ptr, ptr %ctrl_p, align 8
  %keys = load ptr, ptr %keys_p, align 8
  %vals = load ptr, ptr %vals_p, align 8
  %meta = load i64, ptr %meta_p, align 8

  %scap = add i64 %mask, 1
  %c_init = add i64 %scap, 16
  %idx_base = getelementptr inbounds i8, ptr %ctrl, i64 %c_init
  %sp_ip = getelementptr inbounds i32, ptr %idx_base, i64 %sparse_slot
  %d_idx32 = load i32, ptr %sp_ip, align 4
  %d_idx = zext i32 %d_idx32 to i64

  call fastcc void @archx_dict_set_ctrl(ptr %ctrl, i64 %scap, i64 %sparse_slot, i8 -2)
  %last = sub i64 %len, 1
  store i64 %last, ptr %len_p, align 8
  %need_swap = icmp slt i64 %d_idx, %last
  br i1 %need_swap, label %do_swap, label %done
do_swap:
  %kind = and i64 %meta, 255
  %ksz_sh = lshr i64 %meta, 8
  %ksz = and i64 %ksz_sh, 16777215
  %vsz = lshr i64 %meta, 32

  %kd_off = mul i64 %d_idx, %ksz
  %kl_off = mul i64 %last, %ksz
  %kd_p = getelementptr inbounds i8, ptr %keys, i64 %kd_off
  %kl_p = getelementptr inbounds i8, ptr %keys, i64 %kl_off
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %kd_p, ptr nonnull align 1 %kl_p, i64 %ksz, i1 false)

  %has_v = icmp ugt i64 %vsz, 0
  br i1 %has_v, label %swap_v, label %fix_sparse
swap_v:
  %vd_off = mul i64 %d_idx, %vsz
  %vl_off = mul i64 %last, %vsz
  %vd_p = getelementptr inbounds i8, ptr %vals, i64 %vd_off
  %vl_p = getelementptr inbounds i8, ptr %vals, i64 %vl_off
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %vd_p, ptr nonnull align 1 %vl_p, i64 %vsz, i1 false)
  br label %fix_sparse
fix_sparse:
  %h = call fastcc i64 @archx_dict_key_hash_at(ptr %keys, i64 %d_idx, i64 %kind)
  %h2_64 = lshr i64 %h, 57
  %h2 = trunc i64 %h2_64 to i8
  %h2_ins = insertelement <16 x i8> poison, i8 %h2, i32 0
  %h2_vec = shufflevector <16 x i8> %h2_ins, <16 x i8> poison, <16 x i32> zeroinitializer
  %last32 = trunc i64 %last to i32
  %pos0 = and i64 %h, %mask
  br label %fprobe
fprobe:
  %pos = phi i64 [ %pos0, %fix_sparse ], [ %pos_next, %fnext_grp ]
  %step = phi i64 [ 0, %fix_sparse ], [ %step_next, %fnext_grp ]
  %gp = getelementptr inbounds i8, ptr %ctrl, i64 %pos
  %grp = load <16 x i8>, ptr %gp, align 1
  %mcmp = icmp eq <16 x i8> %grp, %h2_vec
  %mbits = bitcast <16 x i1> %mcmp to i16
  %mmask0 = zext i16 %mbits to i32
  br label %fbit
fbit:
  %mmask = phi i32 [ %mmask0, %fprobe ], [ %mmask_next, %fbit_cont ]
  %has_m = icmp ne i32 %mmask, 0
  br i1 %has_m, label %fchk, label %fnext_grp
fchk:
  %tz = call i32 @llvm.cttz.i32(i32 %mmask, i1 true)
  %tz64 = zext i32 %tz to i64
  %s_add = add i64 %pos, %tz64
  %cand = and i64 %s_add, %mask
  %cip = getelementptr inbounds i32, ptr %idx_base, i64 %cand
  %cv = load i32, ptr %cip, align 4
  %hit = icmp eq i32 %cv, %last32
  br i1 %hit, label %fupdate, label %fbit_cont
fbit_cont:
  %mm1 = sub i32 %mmask, 1
  %mmask_next = and i32 %mmask, %mm1
  br label %fbit
fnext_grp:
  %step_next = add i64 %step, 16
  %padd = add i64 %pos, %step_next
  %pos_next = and i64 %padd, %mask
  br label %fprobe
fupdate:
  store i32 %d_idx32, ptr %cip, align 4
  br label %done
done:
  ret void
}
@.fmt.lbrace = private unnamed_addr constant [2 x i8] c"{\00", align 1
@.fmt.rbrace = private unnamed_addr constant [2 x i8] c"}\00", align 1
@.fmt.colon = private unnamed_addr constant [3 x i8] c": \00", align 1
@.fmt.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.any.unhash = private unnamed_addr constant [36 x i8] c"mutable list/dict/set is unhashable\00", align 1
@.any.badop = private unnamed_addr constant [48 x i8] c"unsupported operand types for dynamic operation\00", align 1
@.any.badidx = private unnamed_addr constant [59 x i8] c"dynamic value is not subscriptable or index has wrong type\00", align 1
@.any.badlen = private unnamed_addr constant [41 x i8] c"object of this dynamic type has no len()\00", align 1
@.any.badin = private unnamed_addr constant [44 x i8] c"argument of dynamic 'in' is not a container\00", align 1
@.tn.none = private unnamed_addr constant [9 x i8] c"NoneType\00", align 1
@.tn.bool = private unnamed_addr constant [5 x i8] c"bool\00", align 1
@.tn.int = private unnamed_addr constant [4 x i8] c"int\00", align 1
@.tn.float = private unnamed_addr constant [6 x i8] c"float\00", align 1
@.tn.str = private unnamed_addr constant [4 x i8] c"str\00", align 1
@.tn.list = private unnamed_addr constant [5 x i8] c"list\00", align 1
@.tn.dict = private unnamed_addr constant [5 x i8] c"dict\00", align 1
@.tn.set = private unnamed_addr constant [4 x i8] c"set\00", align 1

define private fastcc void @archx_any_drop(%ArchxAny %v) {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %pod = icmp ult i64 %tag, 4
  br i1 %pod, label %done, label %heap_chk
heap_chk:
  %w1 = extractvalue %ArchxAny %v, 1
  %w2 = extractvalue %ArchxAny %v, 2
  %is_str = icmp eq i64 %tag, 4
  br i1 %is_str, label %d_str, label %chk_list
d_str:
  %s0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %s1 = insertvalue %ArchxStr %s0, i64 %w2, 1
  call fastcc void @archx_str_drop(%ArchxStr %s1)
  ret void
chk_list:
  %is_list = icmp eq i64 %tag, 5
  br i1 %is_list, label %d_list, label %chk_dict
d_list:
  %lp_raw = and i64 %w1, -4
  %lp_z = icmp eq i64 %lp_raw, 0
  br i1 %lp_z, label %done, label %d_list_do
d_list_do:
  %lp = inttoptr i64 %lp_raw to ptr
  %vec = load %ArchxVec, ptr %lp, align 8
  call fastcc void @archx_vec_drop_y(%ArchxVec %vec)
  %ltag = and i64 %w1, 3
  %lheap = icmp eq i64 %ltag, 1
  br i1 %lheap, label %d_list_free, label %done
d_list_free:
  call void @free(ptr %lp)
  ret void
chk_dict:
  %is_dict = icmp eq i64 %tag, 6
  br i1 %is_dict, label %d_dict, label %chk_set
d_dict:
  call fastcc void @archx_dict_drop_y_y(i64 %w1)
  ret void
chk_set:
  %is_set = icmp eq i64 %tag, 7
  br i1 %is_set, label %d_set, label %done
d_set:
  call fastcc void @archx_set_drop_y(i64 %w1)
  br label %done
done:
  ret void
}

define private fastcc %ArchxAny @archx_any_clone(%ArchxAny %v) {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %pod = icmp ult i64 %tag, 4
  br i1 %pod, label %ret_self, label %heap_chk
ret_self:
  ret %ArchxAny %v
heap_chk:
  %w1 = extractvalue %ArchxAny %v, 1
  %w2 = extractvalue %ArchxAny %v, 2
  %is_str = icmp eq i64 %tag, 4
  br i1 %is_str, label %c_str, label %chk_list
c_str:
  %s0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %s1 = insertvalue %ArchxStr %s0, i64 %w2, 1
  %sc = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %s1)
  %sw0 = extractvalue %ArchxStr %sc, 0
  %sw1 = extractvalue %ArchxStr %sc, 1
  %as0 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %sw0, 1
  %as1 = insertvalue %ArchxAny %as0, i64 %sw1, 2
  ret %ArchxAny %as1
chk_list:
  %is_list = icmp eq i64 %tag, 5
  br i1 %is_list, label %c_list, label %chk_dict
c_list:
  %lp_raw = and i64 %w1, -4
  %lp = inttoptr i64 %lp_raw to ptr
  %vec = load %ArchxVec, ptr %lp, align 8
  %vc = call fastcc %ArchxVec @archx_vec_clone_y(%ArchxVec %vec)
  %ncell = call noalias align 16 ptr @malloc(i64 24)
  %nc_null = icmp eq ptr %ncell, null
  br i1 %nc_null, label %oom, label %c_list_ok
oom:
  call void @archx_oom_fail()
  unreachable
c_list_ok:
  store %ArchxVec %vc, ptr %ncell, align 8
  %nci = ptrtoint ptr %ncell to i64
  %nct = or i64 %nci, 1
  %al0 = insertvalue %ArchxAny { i64 5, i64 0, i64 0 }, i64 %nct, 1
  ret %ArchxAny %al0
chk_dict:
  %is_dict = icmp eq i64 %tag, 6
  br i1 %is_dict, label %c_dict, label %c_set
c_dict:
  %dc = call fastcc i64 @archx_dict_clone_y_y(i64 %w1)
  %ad0 = insertvalue %ArchxAny { i64 6, i64 0, i64 0 }, i64 %dc, 1
  ret %ArchxAny %ad0
c_set:
  %ec = call fastcc i64 @archx_set_clone_y(i64 %w1)
  %ae0 = insertvalue %ArchxAny { i64 7, i64 0, i64 0 }, i64 %ec, 1
  ret %ArchxAny %ae0
}

define private fastcc %ArchxAny @archx_any_promote(%ArchxAny %v) {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %pod = icmp ult i64 %tag, 4
  br i1 %pod, label %ret_self, label %do_prom
ret_self:
  ret %ArchxAny %v
do_prom:
  %c = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %v)
  call fastcc void @archx_any_drop(%ArchxAny %v)
  ret %ArchxAny %c
}

define private fastcc i1 @archx_any_truthy(%ArchxAny %v) nounwind {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %is0 = icmp eq i64 %tag, 0
  br i1 %is0, label %ret_f, label %chk_num
ret_f:
  ret i1 false
chk_num:
  %le2 = icmp ule i64 %tag, 2
  br i1 %le2, label %t_int, label %chk_flt
t_int:
  %nz = icmp ne i64 %w1, 0
  ret i1 %nz
chk_flt:
  %is3 = icmp eq i64 %tag, 3
  br i1 %is3, label %t_flt, label %chk_str
t_flt:
  %fv = bitcast i64 %w1 to double
  %fnz = fcmp une double %fv, 0.0
  ret i1 %fnz
chk_str:
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %t_str, label %t_ptr
t_str:
  %slen = and i64 %w1, 4294967295
  %snz = icmp ne i64 %slen, 0
  ret i1 %snz
t_ptr:
  %raw = and i64 %w1, -4
  %pz = icmp eq i64 %raw, 0
  br i1 %pz, label %ret_f, label %t_load_len
t_load_len:
  %hp = inttoptr i64 %raw to ptr
  %clen = load i64, ptr %hp, align 8
  %cnz = icmp sgt i64 %clen, 0
  ret i1 %cnz
}

define private fastcc i64 @archx_any_hash(%ArchxAny %v) {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %is0 = icmp eq i64 %tag, 0
  br i1 %is0, label %h_none, label %chk_int
h_none:
  ret i64 5871781006564002453
chk_int:
  %le2 = icmp ule i64 %tag, 2
  br i1 %le2, label %h_i64, label %chk_flt
h_i64:
  %hi = call fastcc i64 @archx_hash_i64(i64 %w1)
  ret i64 %hi
chk_flt:
  %is3 = icmp eq i64 %tag, 3
  br i1 %is3, label %h_flt, label %chk_str
h_flt:
  %fv = bitcast i64 %w1 to double
  %iv = call i64 @llvm.fptosi.sat.i64.f64(double %fv)
  %back = sitofp i64 %iv to double
  %exact = fcmp oeq double %fv, %back
  %hkey = select i1 %exact, i64 %iv, i64 %w1
  %hf = call fastcc i64 @archx_hash_i64(i64 %hkey)
  ret i64 %hf
chk_str:
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %h_str, label %unhash
h_str:
  %w2 = extractvalue %ArchxAny %v, 2
  %s0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %s1 = insertvalue %ArchxStr %s0, i64 %w2, 1
  %hs = call fastcc i64 @archx_hash_str(%ArchxStr %s1)
  ret i64 %hs
unhash:
  call void @archx_type_fail(ptr @.any.unhash)
  unreachable
}

define private fastcc i1 @archx_any_eq(%ArchxAny %a, %ArchxAny %b) {
entry:
  %ta = extractvalue %ArchxAny %a, 0
  %tb = extractvalue %ArchxAny %b, 0
  %wa1 = extractvalue %ArchxAny %a, 1
  %wb1 = extractvalue %ArchxAny %b, 1
  %na1 = icmp uge i64 %ta, 1
  %na2 = icmp ule i64 %ta, 3
  %na = and i1 %na1, %na2
  %nb1 = icmp uge i64 %tb, 1
  %nb2 = icmp ule i64 %tb, 3
  %nb = and i1 %nb1, %nb2
  %both_num = and i1 %na, %nb
  br i1 %both_num, label %num_eq, label %same_tag_chk
num_eq:
  %fa_is = icmp eq i64 %ta, 3
  %fb_is = icmp eq i64 %tb, 3
  %any_flt = or i1 %fa_is, %fb_is
  br i1 %any_flt, label %flt_eq, label %int_eq
int_eq:
  %ieq = icmp eq i64 %wa1, %wb1
  ret i1 %ieq
flt_eq:
  %da_b = bitcast i64 %wa1 to double
  %da_i = sitofp i64 %wa1 to double
  %da = select i1 %fa_is, double %da_b, double %da_i
  %db_b = bitcast i64 %wb1 to double
  %db_i = sitofp i64 %wb1 to double
  %db = select i1 %fb_is, double %db_b, double %db_i
  %feq = fcmp oeq double %da, %db
  ret i1 %feq
same_tag_chk:
  %teq = icmp eq i64 %ta, %tb
  br i1 %teq, label %by_tag, label %ret_f
ret_f:
  ret i1 false
by_tag:
  %is0 = icmp eq i64 %ta, 0
  br i1 %is0, label %ret_t, label %chk_str
ret_t:
  ret i1 true
chk_str:
  %is4 = icmp eq i64 %ta, 4
  br i1 %is4, label %eq_str, label %chk_list
eq_str:
  %wa2 = extractvalue %ArchxAny %a, 2
  %wb2 = extractvalue %ArchxAny %b, 2
  %sa0 = insertvalue %ArchxStr poison, i64 %wa1, 0
  %sa = insertvalue %ArchxStr %sa0, i64 %wa2, 1
  %sb0 = insertvalue %ArchxStr poison, i64 %wb1, 0
  %sb = insertvalue %ArchxStr %sb0, i64 %wb2, 1
  %seq = call fastcc i1 @archx_str_eq(%ArchxStr %sa, %ArchxStr %sb)
  ret i1 %seq
chk_list:
  %is5 = icmp eq i64 %ta, 5
  br i1 %is5, label %eq_list, label %chk_dict
eq_list:
  %ra = and i64 %wa1, -4
  %rb = and i64 %wb1, -4
  %lpa = inttoptr i64 %ra to ptr
  %lpb = inttoptr i64 %rb to ptr
  %va = load %ArchxVec, ptr %lpa, align 8
  %vb = load %ArchxVec, ptr %lpb, align 8
  %la = extractvalue %ArchxVec %va, 0
  %lb = extractvalue %ArchxVec %vb, 0
  %lleq = icmp eq i64 %la, %lb
  br i1 %lleq, label %lloop_init, label %ret_f
lloop_init:
  %da_p = extractvalue %ArchxVec %va, 2
  %db_p = extractvalue %ArchxVec %vb, 2
  br label %lloop_cond
lloop_cond:
  %li = phi i64 [ 0, %lloop_init ], [ %li_next, %lloop_next ]
  %lmore = icmp slt i64 %li, %la
  br i1 %lmore, label %lloop_body, label %ret_t
lloop_body:
  %ea_p = getelementptr inbounds %ArchxAny, ptr %da_p, i64 %li
  %eb_p = getelementptr inbounds %ArchxAny, ptr %db_p, i64 %li
  %ea = load %ArchxAny, ptr %ea_p, align 8
  %eb = load %ArchxAny, ptr %eb_p, align 8
  %eeq = call fastcc i1 @archx_any_eq(%ArchxAny %ea, %ArchxAny %eb)
  br i1 %eeq, label %lloop_next, label %ret_f
lloop_next:
  %li_next = add nuw nsw i64 %li, 1
  br label %lloop_cond
chk_dict:
  %dra = and i64 %wa1, -4
  %drb = and i64 %wb1, -4
  %dha = inttoptr i64 %dra to ptr
  %dhb = inttoptr i64 %drb to ptr
  %dla = load i64, ptr %dha, align 8
  %dlb = load i64, ptr %dhb, align 8
  %dleq = icmp eq i64 %dla, %dlb
  br i1 %dleq, label %dloop_init, label %ret_f
dloop_init:
  %akp_p = getelementptr inbounds %ArchxDictHdr, ptr %dha, i32 0, i32 5
  %avp_p = getelementptr inbounds %ArchxDictHdr, ptr %dha, i32 0, i32 6
  %bvp_p = getelementptr inbounds %ArchxDictHdr, ptr %dhb, i32 0, i32 6
  %akeys = load ptr, ptr %akp_p, align 8
  %avals = load ptr, ptr %avp_p, align 8
  %bvals = load ptr, ptr %bvp_p, align 8
  %is_dict_t = icmp eq i64 %ta, 6
  br label %dloop_cond
dloop_cond:
  %di = phi i64 [ 0, %dloop_init ], [ %di_next, %dloop_next ]
  %dmore = icmp slt i64 %di, %dla
  br i1 %dmore, label %dloop_body, label %ret_t
dloop_body:
  %ak_p = getelementptr inbounds %ArchxAny, ptr %akeys, i64 %di
  %ak = load %ArchxAny, ptr %ak_p, align 8
  %bidx = call fastcc i64 @archx_dict_lookup_any(i64 %wb1, %ArchxAny %ak)
  %bfound = icmp sge i64 %bidx, 0
  br i1 %bfound, label %dchk_val, label %ret_f
dchk_val:
  br i1 %is_dict_t, label %dchk_dv, label %dloop_next
dchk_dv:
  %av_p = getelementptr inbounds %ArchxAny, ptr %avals, i64 %di
  %bv_p = getelementptr inbounds %ArchxAny, ptr %bvals, i64 %bidx
  %av = load %ArchxAny, ptr %av_p, align 8
  %bv = load %ArchxAny, ptr %bv_p, align 8
  %veq = call fastcc i1 @archx_any_eq(%ArchxAny %av, %ArchxAny %bv)
  br i1 %veq, label %dloop_next, label %ret_f
dloop_next:
  %di_next = add nuw nsw i64 %di, 1
  br label %dloop_cond
}

define private fastcc %ArchxStr @archx_any_type_name(%ArchxAny %v) {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %is0 = icmp eq i64 %tag, 0
  br i1 %is0, label %t0, label %c1
t0:
  %s0 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.none, i64 8, ptr null)
  ret %ArchxStr %s0
c1:
  %is1 = icmp eq i64 %tag, 1
  br i1 %is1, label %t1, label %c2
t1:
  %s1 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.bool, i64 4, ptr null)
  ret %ArchxStr %s1
c2:
  %is2 = icmp eq i64 %tag, 2
  br i1 %is2, label %t2, label %c3
t2:
  %s2 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.int, i64 3, ptr null)
  ret %ArchxStr %s2
c3:
  %is3 = icmp eq i64 %tag, 3
  br i1 %is3, label %t3, label %c4
t3:
  %s3 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.float, i64 5, ptr null)
  ret %ArchxStr %s3
c4:
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %t4, label %c5
t4:
  %s4 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.str, i64 3, ptr null)
  ret %ArchxStr %s4
c5:
  %is5 = icmp eq i64 %tag, 5
  br i1 %is5, label %t5, label %c6
t5:
  %s5 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.list, i64 4, ptr null)
  ret %ArchxStr %s5
c6:
  %is6 = icmp eq i64 %tag, 6
  br i1 %is6, label %t6, label %t7
t6:
  %s6 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.dict, i64 4, ptr null)
  ret %ArchxStr %s6
t7:
  %s7 = call fastcc %ArchxStr @archx_str_from_slice(ptr @.tn.set, i64 3, ptr null)
  ret %ArchxStr %s7
}

define private fastcc %ArchxStr @archx_any_to_str(%ArchxAny %v, ptr %reg) {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %w2 = extractvalue %ArchxAny %v, 2
  %is0 = icmp eq i64 %tag, 0
  br i1 %is0, label %s_none, label %c1
s_none:
  %rn = call fastcc %ArchxStr @archx_str_from_slice(ptr @.str.none, i64 4, ptr %reg)
  ret %ArchxStr %rn
c1:
  %is1 = icmp eq i64 %tag, 1
  br i1 %is1, label %s_bool, label %c2
s_bool:
  %bt = icmp ne i64 %w1, 0
  %bp = select i1 %bt, ptr @.str.true, ptr @.str.false
  %bl = select i1 %bt, i64 4, i64 5
  %rb = call fastcc %ArchxStr @archx_str_from_slice(ptr %bp, i64 %bl, ptr %reg)
  ret %ArchxStr %rb
c2:
  %is2 = icmp eq i64 %tag, 2
  br i1 %is2, label %s_int, label %c3
s_int:
  %ri = call fastcc %ArchxStr @archx_str_from_int(i64 %w1, ptr %reg)
  ret %ArchxStr %ri
c3:
  %is3 = icmp eq i64 %tag, 3
  br i1 %is3, label %s_flt, label %c4
s_flt:
  %fv = bitcast i64 %w1 to double
  %rf = call fastcc %ArchxStr @archx_str_from_float(double %fv, ptr %reg)
  ret %ArchxStr %rf
c4:
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %s_str, label %s_other
s_str:
  %ss0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %ss1 = insertvalue %ArchxStr %ss0, i64 %w2, 1
  %rc = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %ss1)
  ret %ArchxStr %rc
s_other:
  %rt = call fastcc %ArchxStr @archx_any_type_name(%ArchxAny %v)
  ret %ArchxStr %rt
}

define private fastcc void @archx_any_print(%ArchxAny %v, i1 %newline) {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %w2 = extractvalue %ArchxAny %v, 2
  %is0 = icmp eq i64 %tag, 0
  br i1 %is0, label %p_none, label %c1
p_none:
  %cn = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr @.str.none)
  br label %finish_nl
c1:
  %is1 = icmp eq i64 %tag, 1
  br i1 %is1, label %p_bool, label %c2
p_bool:
  %bt = icmp ne i64 %w1, 0
  %bp = select i1 %bt, ptr @.str.true, ptr @.str.false
  %cb = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr %bp)
  br label %finish_nl
c2:
  %is2 = icmp eq i64 %tag, 2
  br i1 %is2, label %p_int, label %c3
p_int:
  %ci = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 %w1)
  br label %finish_nl
c3:
  %is3 = icmp eq i64 %tag, 3
  br i1 %is3, label %p_flt, label %c4
p_flt:
  %fv = bitcast i64 %w1 to double
  call fastcc void @archx_print_float(double %fv, i1 false)
  br label %finish_nl
c4:
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %p_str, label %c5
p_str:
  %ss0 = insertvalue %ArchxStr poison, i64 %w1, 0
  %ss1 = insertvalue %ArchxStr %ss0, i64 %w2, 1
  call fastcc void @archx_str_print(%ArchxStr %ss1, i1 false)
  br label %finish_nl
c5:
  %is5 = icmp eq i64 %tag, 5
  br i1 %is5, label %p_list, label %p_dictset
p_list:
  %lo = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)
  %lraw = and i64 %w1, -4
  %lp = inttoptr i64 %lraw to ptr
  %lvec = load %ArchxVec, ptr %lp, align 8
  %llen = extractvalue %ArchxVec %lvec, 0
  %ldat = extractvalue %ArchxVec %lvec, 2
  br label %ll_cond
ll_cond:
  %li = phi i64 [ 0, %p_list ], [ %li_next, %ll_elem ]
  %lmore = icmp slt i64 %li, %llen
  br i1 %lmore, label %ll_body, label %ll_done
ll_body:
  %lgt0 = icmp sgt i64 %li, 0
  br i1 %lgt0, label %ll_sep, label %ll_elem
ll_sep:
  %lsc = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %ll_elem
ll_elem:
  %lep = getelementptr inbounds %ArchxAny, ptr %ldat, i64 %li
  %le = load %ArchxAny, ptr %lep, align 8
  call fastcc void @archx_any_print(%ArchxAny %le, i1 false)
  %li_next = add nuw nsw i64 %li, 1
  br label %ll_cond
ll_done:
  %lc = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack.inline)
  br label %finish_nl
p_dictset:
  %do = call i32 (ptr, ...) @printf(ptr @.fmt.lbrace)
  %draw = and i64 %w1, -4
  %dz = icmp eq i64 %draw, 0
  br i1 %dz, label %dd_done, label %dd_init
dd_init:
  %dh = inttoptr i64 %draw to ptr
  %dlen = load i64, ptr %dh, align 8
  %dkp = getelementptr inbounds %ArchxDictHdr, ptr %dh, i32 0, i32 5
  %dvp = getelementptr inbounds %ArchxDictHdr, ptr %dh, i32 0, i32 6
  %dkeys = load ptr, ptr %dkp, align 8
  %dvals = load ptr, ptr %dvp, align 8
  %is_d = icmp eq i64 %tag, 6
  br label %dd_cond
dd_cond:
  %di = phi i64 [ 0, %dd_init ], [ %di_next, %dd_next ]
  %dmore = icmp slt i64 %di, %dlen
  br i1 %dmore, label %dd_body, label %dd_done
dd_body:
  %dgt0 = icmp sgt i64 %di, 0
  br i1 %dgt0, label %dd_sep, label %dd_key
dd_sep:
  %dsc = call i32 (ptr, ...) @printf(ptr @.fmt.sep)
  br label %dd_key
dd_key:
  %dk_e = getelementptr inbounds %ArchxAny, ptr %dkeys, i64 %di
  %dkv = load %ArchxAny, ptr %dk_e, align 8
  call fastcc void @archx_any_print(%ArchxAny %dkv, i1 false)
  br i1 %is_d, label %dd_val, label %dd_next
dd_val:
  %dcol = call i32 (ptr, ...) @printf(ptr @.fmt.colon)
  %dv_e = getelementptr inbounds %ArchxAny, ptr %dvals, i64 %di
  %dvv = load %ArchxAny, ptr %dv_e, align 8
  call fastcc void @archx_any_print(%ArchxAny %dvv, i1 false)
  br label %dd_next
dd_next:
  %di_next = add nuw nsw i64 %di, 1
  br label %dd_cond
dd_done:
  %dc = call i32 (ptr, ...) @printf(ptr @.fmt.rbrace)
  br label %finish_nl
finish_nl:
  br i1 %newline, label %do_nl, label %ret_done
do_nl:
  %cnl = call i32 (ptr, ...) @printf(ptr @.fmt.nl)
  br label %ret_done
ret_done:
  ret void
}

define private fastcc i64 @archx_any_len(%ArchxAny %v) {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %is4 = icmp eq i64 %tag, 4
  br i1 %is4, label %l_str, label %chk_cont
l_str:
  %slen = and i64 %w1, 4294967295
  ret i64 %slen
chk_cont:
  %ge5 = icmp uge i64 %tag, 5
  %le7 = icmp ule i64 %tag, 7
  %ok = and i1 %ge5, %le7
  br i1 %ok, label %l_cont, label %bad
l_cont:
  %raw = and i64 %w1, -4
  %z = icmp eq i64 %raw, 0
  br i1 %z, label %ret0, label %load_l
ret0:
  ret i64 0
load_l:
  %p = inttoptr i64 %raw to ptr
  %l = load i64, ptr %p, align 8
  ret i64 %l
bad:
  call void @archx_type_fail(ptr @.any.badlen)
  unreachable
}

define private fastcc %ArchxAny @archx_any_get_idx(%ArchxAny %target, %ArchxAny %idx) {
entry:
  %ttag = extractvalue %ArchxAny %target, 0
  %tw1 = extractvalue %ArchxAny %target, 1
  %tw2 = extractvalue %ArchxAny %target, 2
  %itag = extractvalue %ArchxAny %idx, 0
  %iw1 = extractvalue %ArchxAny %idx, 1
  %is_list = icmp eq i64 %ttag, 5
  br i1 %is_list, label %g_list, label %chk_dict
g_list:
  %i_ok = icmp eq i64 %itag, 2
  br i1 %i_ok, label %gl_idx, label %bad_idx
gl_idx:
  %lraw = and i64 %tw1, -4
  %lp = inttoptr i64 %lraw to ptr
  %lvec = load %ArchxVec, ptr %lp, align 8
  %llen = extractvalue %ArchxVec %lvec, 0
  %neg = icmp slt i64 %iw1, 0
  %adj = add i64 %iw1, %llen
  %eff = select i1 %neg, i64 %adj, i64 %iw1
  %oob = icmp uge i64 %eff, %llen
  br i1 %oob, label %gl_oob, label %gl_ok
gl_oob:
  call void @archx_bounds_fail(i64 %iw1, i64 %llen)
  unreachable
gl_ok:
  %ldat = extractvalue %ArchxVec %lvec, 2
  %ep = getelementptr inbounds %ArchxAny, ptr %ldat, i64 %eff
  %ev = load %ArchxAny, ptr %ep, align 8
  %ec = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %ev)
  ret %ArchxAny %ec
chk_dict:
  %is_dict = icmp eq i64 %ttag, 6
  br i1 %is_dict, label %g_dict, label %chk_str
g_dict:
  %didx = call fastcc i64 @archx_dict_lookup_any(i64 %tw1, %ArchxAny %idx)
  %dfound = icmp sge i64 %didx, 0
  br i1 %dfound, label %gd_ok, label %gd_miss
gd_miss:
  call void @archx_key_fail()
  unreachable
gd_ok:
  %draw = and i64 %tw1, -4
  %dh = inttoptr i64 %draw to ptr
  %dvp = getelementptr inbounds %ArchxDictHdr, ptr %dh, i32 0, i32 6
  %dvals = load ptr, ptr %dvp, align 8
  %vp = getelementptr inbounds %ArchxAny, ptr %dvals, i64 %didx
  %vv = load %ArchxAny, ptr %vp, align 8
  %vc = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %vv)
  ret %ArchxAny %vc
chk_str:
  %is_str = icmp eq i64 %ttag, 4
  %si_ok = icmp eq i64 %itag, 2
  %sok = and i1 %is_str, %si_ok
  br i1 %sok, label %g_str, label %bad_idx
g_str:
  %slen = and i64 %tw1, 4294967295
  %sneg = icmp slt i64 %iw1, 0
  %sadj = add i64 %iw1, %slen
  %seff = select i1 %sneg, i64 %sadj, i64 %iw1
  %soob = icmp uge i64 %seff, %slen
  br i1 %soob, label %gs_oob, label %gs_ok
gs_oob:
  call void @archx_bounds_fail(i64 %iw1, i64 %slen)
  unreachable
gs_ok:
  %ss0 = insertvalue %ArchxStr poison, i64 %tw1, 0
  %ss1 = insertvalue %ArchxStr %ss0, i64 %tw2, 1
  %ch = call fastcc %ArchxStr @archx_str_byte_at(%ArchxStr %ss1, i64 %seff)
  %cw0 = extractvalue %ArchxStr %ch, 0
  %cw1 = extractvalue %ArchxStr %ch, 1
  %ar0 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %cw0, 1
  %ar1 = insertvalue %ArchxAny %ar0, i64 %cw1, 2
  ret %ArchxAny %ar1
bad_idx:
  call void @archx_type_fail(ptr @.any.badidx)
  unreachable
}

define private fastcc void @archx_any_set_idx(%ArchxAny %target, %ArchxAny %idx, %ArchxAny %val) {
entry:
  %ttag = extractvalue %ArchxAny %target, 0
  %tw1 = extractvalue %ArchxAny %target, 1
  %itag = extractvalue %ArchxAny %idx, 0
  %iw1 = extractvalue %ArchxAny %idx, 1
  %is_list = icmp eq i64 %ttag, 5
  br i1 %is_list, label %s_list, label %chk_dict
s_list:
  %i_ok = icmp eq i64 %itag, 2
  br i1 %i_ok, label %sl_do, label %bad_idx
sl_do:
  %lraw = and i64 %tw1, -4
  %lp = inttoptr i64 %lraw to ptr
  %lvec = load %ArchxVec, ptr %lp, align 8
  %llen = extractvalue %ArchxVec %lvec, 0
  %neg = icmp slt i64 %iw1, 0
  %adj = add i64 %iw1, %llen
  %eff = select i1 %neg, i64 %adj, i64 %iw1
  %oob = icmp uge i64 %eff, %llen
  br i1 %oob, label %sl_oob, label %sl_ok
sl_oob:
  call void @archx_bounds_fail(i64 %iw1, i64 %llen)
  unreachable
sl_ok:
  %ldat = extractvalue %ArchxVec %lvec, 2
  %ep = getelementptr inbounds %ArchxAny, ptr %ldat, i64 %eff
  %old = load %ArchxAny, ptr %ep, align 8
  %vc = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %val)
  call fastcc void @archx_any_drop(%ArchxAny %old)
  store %ArchxAny %vc, ptr %ep, align 8
  ret void
chk_dict:
  %is_dict = icmp eq i64 %ttag, 6
  br i1 %is_dict, label %s_dict, label %bad_idx
s_dict:
  %up = call fastcc { i64, i1 } @archx_dict_upsert_any(i64 %tw1, %ArchxAny %idx)
  %didx = extractvalue { i64, i1 } %up, 0
  %existed = extractvalue { i64, i1 } %up, 1
  %draw = and i64 %tw1, -4
  %dh = inttoptr i64 %draw to ptr
  %dvp = getelementptr inbounds %ArchxDictHdr, ptr %dh, i32 0, i32 6
  %dvals = load ptr, ptr %dvp, align 8
  %vp = getelementptr inbounds %ArchxAny, ptr %dvals, i64 %didx
  %vc2 = call fastcc %ArchxAny @archx_any_clone(%ArchxAny %val)
  br i1 %existed, label %sd_drop_old, label %sd_store
sd_drop_old:
  %oldv = load %ArchxAny, ptr %vp, align 8
  call fastcc void @archx_any_drop(%ArchxAny %oldv)
  br label %sd_store
sd_store:
  store %ArchxAny %vc2, ptr %vp, align 8
  ret void
bad_idx:
  call void @archx_type_fail(ptr @.any.badidx)
  unreachable
}

define private fastcc i1 @archx_any_in(%ArchxAny %needle, %ArchxAny %hay) {
entry:
  %htag = extractvalue %ArchxAny %hay, 0
  %hw1 = extractvalue %ArchxAny %hay, 1
  %hw2 = extractvalue %ArchxAny %hay, 2
  %is_list = icmp eq i64 %htag, 5
  br i1 %is_list, label %in_list, label %chk_ds
in_list:
  %lraw = and i64 %hw1, -4
  %lp = inttoptr i64 %lraw to ptr
  %lvec = load %ArchxVec, ptr %lp, align 8
  %llen = extractvalue %ArchxVec %lvec, 0
  %ldat = extractvalue %ArchxVec %lvec, 2
  br label %ll_cond
ll_cond:
  %li = phi i64 [ 0, %in_list ], [ %li_next, %ll_next ]
  %lmore = icmp slt i64 %li, %llen
  br i1 %lmore, label %ll_body, label %ret_f
ll_body:
  %ep = getelementptr inbounds %ArchxAny, ptr %ldat, i64 %li
  %ev = load %ArchxAny, ptr %ep, align 8
  %eq = call fastcc i1 @archx_any_eq(%ArchxAny %needle, %ArchxAny %ev)
  br i1 %eq, label %ret_t, label %ll_next
ll_next:
  %li_next = add nuw nsw i64 %li, 1
  br label %ll_cond
chk_ds:
  %is_d = icmp eq i64 %htag, 6
  %is_s = icmp eq i64 %htag, 7
  %is_ds = or i1 %is_d, %is_s
  br i1 %is_ds, label %in_ds, label %chk_str
in_ds:
  %didx = call fastcc i64 @archx_dict_lookup_any(i64 %hw1, %ArchxAny %needle)
  %fnd = icmp sge i64 %didx, 0
  ret i1 %fnd
chk_str:
  %nt = extractvalue %ArchxAny %needle, 0
  %is_hs = icmp eq i64 %htag, 4
  %is_ns = icmp eq i64 %nt, 4
  %both_s = and i1 %is_hs, %is_ns
  br i1 %both_s, label %in_str, label %bad
in_str:
  %nw1 = extractvalue %ArchxAny %needle, 1
  %nw2 = extractvalue %ArchxAny %needle, 2
  %hs0 = insertvalue %ArchxStr poison, i64 %hw1, 0
  %hs = insertvalue %ArchxStr %hs0, i64 %hw2, 1
  %ns0 = insertvalue %ArchxStr poison, i64 %nw1, 0
  %ns = insertvalue %ArchxStr %ns0, i64 %nw2, 1
  %pos = call fastcc i64 @archx_str_find(%ArchxStr %hs, %ArchxStr %ns)
  %sfnd = icmp sge i64 %pos, 0
  ret i1 %sfnd
ret_t:
  ret i1 true
ret_f:
  ret i1 false
bad:
  call void @archx_type_fail(ptr @.any.badin)
  unreachable
}

define private fastcc %ArchxAny @archx_any_neg(%ArchxAny %v) {
entry:
  %tag = extractvalue %ArchxAny %v, 0
  %w1 = extractvalue %ArchxAny %v, 1
  %le2 = icmp uge i64 %tag, 1
  %le2b = icmp ule i64 %tag, 2
  %is_i = and i1 %le2, %le2b
  br i1 %is_i, label %n_int, label %chk_f
n_int:
  %ni = sub i64 0, %w1
  %ri = insertvalue %ArchxAny { i64 2, i64 0, i64 0 }, i64 %ni, 1
  ret %ArchxAny %ri
chk_f:
  %is_f = icmp eq i64 %tag, 3
  br i1 %is_f, label %n_flt, label %bad
n_flt:
  %fv = bitcast i64 %w1 to double
  %nf = fneg double %fv
  %nfi = bitcast double %nf to i64
  %rf = insertvalue %ArchxAny { i64 3, i64 0, i64 0 }, i64 %nfi, 1
  ret %ArchxAny %rf
bad:
  call void @archx_type_fail(ptr @.any.badop)
  unreachable
}

define private fastcc i1 @archx_any_cmp(%ArchxAny %a, %ArchxAny %b, i64 %op) {
entry:
  %ta = extractvalue %ArchxAny %a, 0
  %tb = extractvalue %ArchxAny %b, 0
  %wa1 = extractvalue %ArchxAny %a, 1
  %wb1 = extractvalue %ArchxAny %b, 1
  %na1 = icmp uge i64 %ta, 1
  %na2 = icmp ule i64 %ta, 3
  %na = and i1 %na1, %na2
  %nb1 = icmp uge i64 %tb, 1
  %nb2 = icmp ule i64 %tb, 3
  %nb = and i1 %nb1, %nb2
  %both_num = and i1 %na, %nb
  br i1 %both_num, label %num_cmp, label %bad
num_cmp:
  %fa_is = icmp eq i64 %ta, 3
  %fb_is = icmp eq i64 %tb, 3
  %any_f = or i1 %fa_is, %fb_is
  br i1 %any_f, label %f_cmp, label %i_cmp
i_cmp:
  %ilt = icmp slt i64 %wa1, %wb1
  %igt = icmp sgt i64 %wa1, %wb1
  %ile = icmp sle i64 %wa1, %wb1
  %ige = icmp sge i64 %wa1, %wb1
  %is0 = icmp eq i64 %op, 0
  %is1 = icmp eq i64 %op, 1
  %is2 = icmp eq i64 %op, 2
  %r01 = select i1 %is0, i1 %ilt, i1 %igt
  %r012 = select i1 %is2, i1 %ile, i1 %r01
  %is3 = icmp eq i64 %op, 3
  %ri = select i1 %is3, i1 %ige, i1 %r012
  ret i1 %ri
f_cmp:
  %da_b = bitcast i64 %wa1 to double
  %da_i = sitofp i64 %wa1 to double
  %da = select i1 %fa_is, double %da_b, double %da_i
  %db_b = bitcast i64 %wb1 to double
  %db_i = sitofp i64 %wb1 to double
  %db = select i1 %fb_is, double %db_b, double %db_i
  %flt = fcmp olt double %da, %db
  %fgt = fcmp ogt double %da, %db
  %fle = fcmp ole double %da, %db
  %fge = fcmp oge double %da, %db
  %fs0 = icmp eq i64 %op, 0
  %fs2 = icmp eq i64 %op, 2
  %fs3 = icmp eq i64 %op, 3
  %fr01 = select i1 %fs0, i1 %flt, i1 %fgt
  %fr012 = select i1 %fs2, i1 %fle, i1 %fr01
  %rf = select i1 %fs3, i1 %fge, i1 %fr012
  ret i1 %rf
bad:
  call void @archx_type_fail(ptr @.any.badop)
  unreachable
}

define private fastcc %ArchxAny @archx_any_binop(%ArchxAny %a, %ArchxAny %b, i64 %op, ptr %reg) {
entry:
  %ta = extractvalue %ArchxAny %a, 0
  %tb = extractvalue %ArchxAny %b, 0
  %wa1 = extractvalue %ArchxAny %a, 1
  %wb1 = extractvalue %ArchxAny %b, 1
  %na1 = icmp uge i64 %ta, 1
  %na2 = icmp ule i64 %ta, 3
  %na = and i1 %na1, %na2
  %nb1 = icmp uge i64 %tb, 1
  %nb2 = icmp ule i64 %tb, 3
  %nb = and i1 %nb1, %nb2
  %both_num = and i1 %na, %nb
  br i1 %both_num, label %num_op, label %chk_str_op
num_op:
  %fa_is = icmp eq i64 %ta, 3
  %fb_is = icmp eq i64 %tb, 3
  %any_f = or i1 %fa_is, %fb_is
  br i1 %any_f, label %flt_op, label %int_op
int_op:
  %op_add = icmp eq i64 %op, 0
  br i1 %op_add, label %i_add, label %ic_sub
i_add:
  %va = add i64 %wa1, %wb1
  br label %ret_int
ic_sub:
  %op_sub = icmp eq i64 %op, 1
  br i1 %op_sub, label %i_sub, label %ic_mul
i_sub:
  %vs = sub i64 %wa1, %wb1
  br label %ret_int
ic_mul:
  %op_mul = icmp eq i64 %op, 2
  br i1 %op_mul, label %i_mul, label %ic_div
i_mul:
  %vm = mul i64 %wa1, %wb1
  br label %ret_int
ic_div:
  %op_pow = icmp eq i64 %op, 6
  br i1 %op_pow, label %i_pow, label %ic_divrem
i_pow:
  %neg_e = icmp slt i64 %wb1, 0
  br i1 %neg_e, label %pow_err, label %pow_loop_init
pow_err:
  call void @archx_neg_exp_fail()
  unreachable
pow_loop_init:
  br label %pow_cond
pow_cond:
  %pe = phi i64 [ %wb1, %pow_loop_init ], [ %pe_next, %pow_step ]
  %pacc = phi i64 [ 1, %pow_loop_init ], [ %pacc_next, %pow_step ]
  %pbase = phi i64 [ %wa1, %pow_loop_init ], [ %pbase_next, %pow_step ]
  %pgz = icmp sgt i64 %pe, 0
  br i1 %pgz, label %pow_step, label %ret_int_pow
pow_step:
  %odd = and i64 %pe, 1
  %is_odd = icmp ne i64 %odd, 0
  %pmul = mul i64 %pacc, %pbase
  %pacc_next = select i1 %is_odd, i64 %pmul, i64 %pacc
  %pbase_next = mul i64 %pbase, %pbase
  %pe_next = lshr i64 %pe, 1
  br label %pow_cond
ret_int_pow:
  br label %ret_int
ic_divrem:
  %bz = icmp eq i64 %wb1, 0
  br i1 %bz, label %div_z, label %ic_div_ok
div_z:
  call void @archx_div_zero_fail()
  unreachable
ic_div_ok:
  %is_min = icmp eq i64 %wa1, -9223372036854775808
  %is_m1 = icmp eq i64 %wb1, -1
  %ovf_d = and i1 %is_min, %is_m1
  %safe_b = select i1 %ovf_d, i64 1, i64 %wb1
  %q = sdiv i64 %wa1, %safe_b
  %r = srem i64 %wa1, %safe_b
  %op_div = icmp eq i64 %op, 3
  br i1 %op_div, label %i_div, label %ic_fdiv
i_div:
  %vd = select i1 %ovf_d, i64 -9223372036854775808, i64 %q
  br label %ret_int
ic_fdiv:
  %op_fdiv = icmp eq i64 %op, 4
  %r_nz = icmp ne i64 %r, 0
  %xr = xor i64 %wa1, %safe_b
  %diff_s = icmp slt i64 %xr, 0
  %need_adj = and i1 %r_nz, %diff_s
  br i1 %op_fdiv, label %i_fdiv, label %i_mod
i_fdiv:
  %qm1 = sub i64 %q, 1
  %vfd = select i1 %need_adj, i64 %qm1, i64 %q
  br label %ret_int
i_mod:
  %radj = add i64 %r, %safe_b
  %vmd = select i1 %need_adj, i64 %radj, i64 %r
  br label %ret_int
ret_int:
  %ival = phi i64 [ %va, %i_add ], [ %vs, %i_sub ], [ %vm, %i_mul ], [ %pacc, %ret_int_pow ], [ %vd, %i_div ], [ %vfd, %i_fdiv ], [ %vmd, %i_mod ]
  %ri = insertvalue %ArchxAny { i64 2, i64 0, i64 0 }, i64 %ival, 1
  ret %ArchxAny %ri

flt_op:
  %da_b = bitcast i64 %wa1 to double
  %da_i = sitofp i64 %wa1 to double
  %da = select i1 %fa_is, double %da_b, double %da_i
  %db_b = bitcast i64 %wb1 to double
  %db_i = sitofp i64 %wb1 to double
  %db = select i1 %fb_is, double %db_b, double %db_i
  %f_add = icmp eq i64 %op, 0
  br i1 %f_add, label %fl_add, label %fc_sub
fl_add:
  %fva = fadd double %da, %db
  br label %ret_flt
fc_sub:
  %f_sub = icmp eq i64 %op, 1
  br i1 %f_sub, label %fl_sub, label %fc_mul
fl_sub:
  %fvs = fsub double %da, %db
  br label %ret_flt
fc_mul:
  %f_mul = icmp eq i64 %op, 2
  br i1 %f_mul, label %fl_mul, label %fc_pow
fl_mul:
  %fvm = fmul double %da, %db
  br label %ret_flt
fc_pow:
  %f_pow = icmp eq i64 %op, 6
  br i1 %f_pow, label %fl_pow, label %fc_div
fl_pow:
  %fvp = call double @llvm.pow.f64(double %da, double %db)
  br label %ret_flt
fc_div:
  %fbz = fcmp oeq double %db, 0.0
  br i1 %fbz, label %fdiv_z, label %fc_div_ok
fdiv_z:
  call void @archx_div_zero_fail()
  unreachable
fc_div_ok:
  %fq = fdiv double %da, %db
  %f_div = icmp eq i64 %op, 3
  br i1 %f_div, label %fl_div, label %fc_fdiv
fl_div:
  br label %ret_flt
fc_fdiv:
  %fflr = call double @llvm.floor.f64(double %fq)
  %f_fdiv = icmp eq i64 %op, 4
  br i1 %f_fdiv, label %fl_fdiv, label %fl_mod
fl_fdiv:
  br label %ret_flt
fl_mod:
  %fmulq = fmul double %fflr, %db
  %fmod = fsub double %da, %fmulq
  br label %ret_flt
ret_flt:
  %fval = phi double [ %fva, %fl_add ], [ %fvs, %fl_sub ], [ %fvm, %fl_mul ], [ %fvp, %fl_pow ], [ %fq, %fl_div ], [ %fflr, %fl_fdiv ], [ %fmod, %fl_mod ]
  %fbits = bitcast double %fval to i64
  %rf = insertvalue %ArchxAny { i64 3, i64 0, i64 0 }, i64 %fbits, 1
  ret %ArchxAny %rf

chk_str_op:
  %wa2 = extractvalue %ArchxAny %a, 2
  %wb2 = extractvalue %ArchxAny %b, 2
  %sa_is = icmp eq i64 %ta, 4
  %sb_is = icmp eq i64 %tb, 4
  %op0 = icmp eq i64 %op, 0
  %both_s = and i1 %sa_is, %sb_is
  %s_cat = and i1 %op0, %both_s
  br i1 %s_cat, label %do_scat, label %chk_srep
do_scat:
  %sa0 = insertvalue %ArchxStr poison, i64 %wa1, 0
  %sa = insertvalue %ArchxStr %sa0, i64 %wa2, 1
  %sb0 = insertvalue %ArchxStr poison, i64 %wb1, 0
  %sb = insertvalue %ArchxStr %sb0, i64 %wb2, 1
  %sc = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %sa, %ArchxStr %sb, ptr %reg)
  %sc0 = extractvalue %ArchxStr %sc, 0
  %sc1 = extractvalue %ArchxStr %sc, 1
  %rsc0 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %sc0, 1
  %rsc = insertvalue %ArchxAny %rsc0, i64 %sc1, 2
  ret %ArchxAny %rsc
chk_srep:
  %op2 = icmp eq i64 %op, 2
  %bi_is = icmp eq i64 %tb, 2
  %ai_is = icmp eq i64 %ta, 2
  %sr1 = and i1 %sa_is, %bi_is
  %sr2 = and i1 %ai_is, %sb_is
  %sr_any = or i1 %sr1, %sr2
  %do_sr = and i1 %op2, %sr_any
  br i1 %do_sr, label %srep_do, label %bad_op
srep_do:
  %r_sw0 = select i1 %sa_is, i64 %wa1, i64 %wb1
  %r_sw1 = select i1 %sa_is, i64 %wa2, i64 %wb2
  %r_cnt = select i1 %sa_is, i64 %wb1, i64 %wa1
  %rs0 = insertvalue %ArchxStr poison, i64 %r_sw0, 0
  %rs = insertvalue %ArchxStr %rs0, i64 %r_sw1, 1
  %rr = call fastcc %ArchxStr @archx_str_repeat(%ArchxStr %rs, i64 %r_cnt, ptr %reg)
  %rr0 = extractvalue %ArchxStr %rr, 0
  %rr1 = extractvalue %ArchxStr %rr, 1
  %rrr0 = insertvalue %ArchxAny { i64 4, i64 0, i64 0 }, i64 %rr0, 1
  %rrr = insertvalue %ArchxAny %rrr0, i64 %rr1, 2
  ret %ArchxAny %rrr
bad_op:
  call void @archx_type_fail(ptr @.any.badop)
  unreachable
}
declare i32 @llvm.cttz.i32(i32, i1 immarg) nounwind readnone speculatable
