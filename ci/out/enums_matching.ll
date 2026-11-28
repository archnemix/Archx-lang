; Archx LLVM IR module
source_filename = "enums_matching.archx.lang"
; archx.dialect=native version=1 source=directive

%ArchxVec = type { i64, i64, ptr }
%ArchxStr = type { i64, i64 }
%ArchxRegion = type { ptr, ptr, ptr, ptr }
%ArchxEnum_Shape = type { i64, [4 x i64] }

@.fmt.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.fmt.int = private unnamed_addr constant [6 x i8] c"%lld\0A\00", align 1
@.str.true = private unnamed_addr constant [5 x i8] c"true\00", align 1
@.str.false = private unnamed_addr constant [6 x i8] c"false\00", align 1
@.fmt.str.repr = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.fmt.g15 = private unnamed_addr constant [6 x i8] c"%.15g\00", align 1
@.fmt.g16 = private unnamed_addr constant [6 x i8] c"%.16g\00", align 1
@.fmt.g17 = private unnamed_addr constant [6 x i8] c"%.17g\00", align 1
@.str.0 = private unnamed_addr constant [14 x i8] c"large-circle:\00", align 4
@.str.1 = private unnamed_addr constant [39 x i8] c"long_region_allocated_shape_identifier\00", align 4

define internal fastcc { i64, i64, i64 } @archx_fn_min_max_sum(%ArchxVec %arg.xs) {
entry:
  %var.lo.5 = alloca i64, align 8
  %var.hi.11 = alloca i64, align 8
  %var.total.12 = alloca i64, align 8
  %foreach.idx.15 = alloca i64, align 8
  %var.x.16 = alloca i64, align 8
  %t0 = extractvalue %ArchxVec %arg.xs, 0
  %t1 = icmp uge i64 0, %t0
  br i1 %t1, label %idx.oob.1, label %idx.ok.0
idx.oob.1:
  call void @archx_bounds_fail(i64 0, i64 %t0)
  unreachable
idx.ok.0:
  %t2 = extractvalue %ArchxVec %arg.xs, 2
  %t3 = getelementptr inbounds i64, ptr %t2, i64 0
  %t4 = load i64, ptr %t3, align 8
  store i64 %t4, ptr %var.lo.5, align 8
  %t6 = extractvalue %ArchxVec %arg.xs, 0
  %t7 = icmp uge i64 0, %t6
  br i1 %t7, label %idx.oob.3, label %idx.ok.2
idx.oob.3:
  call void @archx_bounds_fail(i64 0, i64 %t6)
  unreachable
idx.ok.2:
  %t8 = extractvalue %ArchxVec %arg.xs, 2
  %t9 = getelementptr inbounds i64, ptr %t8, i64 0
  %t10 = load i64, ptr %t9, align 8
  store i64 %t10, ptr %var.hi.11, align 8
  store i64 0, ptr %var.total.12, align 8
  %t13 = extractvalue %ArchxVec %arg.xs, 0
  %t14 = extractvalue %ArchxVec %arg.xs, 2
  store i64 0, ptr %foreach.idx.15, align 8
  br label %foreach.cond.4
foreach.cond.4:
  %t17 = load i64, ptr %foreach.idx.15, align 8
  %t18 = icmp slt i64 %t17, %t13
  br i1 %t18, label %foreach.body.5, label %foreach.end.7
foreach.body.5:
  %t19 = getelementptr inbounds i64, ptr %t14, i64 %t17
  %t20 = load i64, ptr %t19, align 8
  store i64 %t20, ptr %var.x.16, align 8
  %t21 = load i64, ptr %var.x.16, align 8
  %t22 = load i64, ptr %var.lo.5, align 8
  %t23 = icmp slt i64 %t21, %t22
  br i1 %t23, label %if.then.8, label %if.else.9
if.then.8:
  %t24 = load i64, ptr %var.x.16, align 8
  store i64 %t24, ptr %var.lo.5, align 8
  br label %if.merge.10
if.else.9:
  br label %if.merge.10
if.merge.10:
  %t25 = load i64, ptr %var.x.16, align 8
  %t26 = load i64, ptr %var.hi.11, align 8
  %t27 = icmp sgt i64 %t25, %t26
  br i1 %t27, label %if.then.11, label %if.else.12
if.then.11:
  %t28 = load i64, ptr %var.x.16, align 8
  store i64 %t28, ptr %var.hi.11, align 8
  br label %if.merge.13
if.else.12:
  br label %if.merge.13
if.merge.13:
  %t29 = load i64, ptr %var.total.12, align 8
  %t30 = load i64, ptr %var.x.16, align 8
  %t31 = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %t29, i64 %t30)
  %t32 = extractvalue { i64, i1 } %t31, 0
  %t33 = extractvalue { i64, i1 } %t31, 1
  br i1 %t33, label %overflow.add.14, label %overflow.ok.15
overflow.add.14:
  call void @archx_int_overflow_fail()
  unreachable
overflow.ok.15:
  store i64 %t32, ptr %var.total.12, align 8
  br label %foreach.step.6
foreach.step.6:
  %t34 = load i64, ptr %foreach.idx.15, align 8
  %t35 = add nsw i64 %t34, 1
  store i64 %t35, ptr %foreach.idx.15, align 8
  br label %foreach.cond.4
foreach.end.7:
  %t36 = load i64, ptr %var.lo.5, align 8
  %t37 = load i64, ptr %var.hi.11, align 8
  %t38 = load i64, ptr %var.total.12, align 8
  %t39 = insertvalue { i64, i64, i64 } undef, i64 %t36, 0
  %t40 = insertvalue { i64, i64, i64 } %t39, i64 %t37, 1
  %t41 = insertvalue { i64, i64, i64 } %t40, i64 %t38, 2
  ret { i64, i64, i64 } %t41
}

define internal fastcc { i1, i64 } @archx_fn_find_gt(%ArchxVec %arg.xs, i64 %arg.limit) {
entry:
  %enum.pos.2 = alloca i64, align 8
  %var.i.7 = alloca i64, align 8
  %t0 = extractvalue %ArchxVec %arg.xs, 0
  %t1 = extractvalue %ArchxVec %arg.xs, 2
  store i64 0, ptr %enum.pos.2, align 8
  br label %enum.cond.0
enum.cond.0:
  %t3 = load i64, ptr %enum.pos.2, align 8
  %t4 = icmp slt i64 %t3, %t0
  br i1 %t4, label %enum.body.1, label %enum.end.3
enum.body.1:
  %t5 = getelementptr inbounds i64, ptr %t1, i64 %t3
  %t6 = load i64, ptr %t5, align 8
  store i64 %t3, ptr %var.i.7, align 8
  %t8 = icmp sgt i64 %t6, %arg.limit
  br i1 %t8, label %if.then.4, label %if.else.5
if.then.4:
  %t9 = load i64, ptr %var.i.7, align 8
  %t10 = insertvalue { i1, i64 } undef, i1 1, 0
  %t11 = insertvalue { i1, i64 } %t10, i64 %t9, 1
  ret { i1, i64 } %t11
if.else.5:
  br label %if.merge.6
if.merge.6:
  br label %enum.step.2
enum.step.2:
  %t12 = load i64, ptr %enum.pos.2, align 8
  %t13 = add nsw i64 %t12, 1
  store i64 %t13, ptr %enum.pos.2, align 8
  br label %enum.cond.0
enum.end.3:
  ret { i1, i64 } zeroinitializer
}

define internal fastcc %ArchxStr @archx_fn_describe_shape(%ArchxEnum_Shape %arg.s) {
entry:
  %match.subj.0 = alloca %ArchxEnum_Shape, align 8
  %pat.enum.5 = alloca %ArchxEnum_Shape, align 8
  %pbind.r.8 = alloca double, align 8
  %pat.enum.20 = alloca %ArchxEnum_Shape, align 8
  %pbind.r.23 = alloca double, align 8
  %pat.enum.31 = alloca %ArchxEnum_Shape, align 8
  %pbind.w.34 = alloca double, align 8
  %pbind.h.37 = alloca double, align 8
  %pat.enum.48 = alloca %ArchxEnum_Shape, align 8
  %pbind.w.51 = alloca double, align 8
  %pbind.h.54 = alloca double, align 8
  %pat.enum.64 = alloca %ArchxEnum_Shape, align 8
  %pbind.tag.67 = alloca %ArchxStr, align 8
  %pbind.x.71 = alloca i64, align 8
  %pbind.y.73 = alloca i64, align 8
  %pat.tag.76 = alloca %ArchxStr, align 8
  %t1 = call fastcc %ArchxEnum_Shape @archx_enum_clone_Shape(%ArchxEnum_Shape %arg.s)
  store %ArchxEnum_Shape %t1, ptr %match.subj.0, align 8
  %t2 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  %t3 = extractvalue %ArchxEnum_Shape %t2, 0
  %t4 = icmp eq i64 %t3, 0
  br i1 %t4, label %pat.enum.ok.2, label %match.next.1
pat.enum.ok.2:
  store %ArchxEnum_Shape %t2, ptr %pat.enum.5, align 8
  %t6 = getelementptr inbounds %ArchxEnum_Shape, ptr %pat.enum.5, i32 0, i32 1, i64 0
  %t7 = load double, ptr %t6, align 8
  store double %t7, ptr %pbind.r.8, align 8
  %t9 = load double, ptr %pbind.r.8, align 8
  %t10 = fcmp oge double %t9, 0x4024000000000000
  br i1 %t10, label %match.body.3, label %match.gfail.4
match.gfail.4:
  br label %match.next.1
match.body.3:
  %t11 = ptrtoint ptr @.str.0 to i64
  %t12 = insertvalue %ArchxStr poison, i64 7454127449735954445, 0
  %t13 = insertvalue %ArchxStr %t12, i64 %t11, 1
  %t14 = call fastcc %ArchxStr @archx_str_from_float(double %t9, ptr null)
  %t15 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t13, %ArchxStr %t14, ptr null)
  call fastcc void @archx_str_drop(%ArchxStr %t14)
  %t16 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  call fastcc void @archx_enum_drop_Shape(%ArchxEnum_Shape %t16)
  ret %ArchxStr %t15
match.next.1:
  %t17 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  %t18 = extractvalue %ArchxEnum_Shape %t17, 0
  %t19 = icmp eq i64 %t18, 0
  br i1 %t19, label %pat.enum.ok.6, label %match.next.5
pat.enum.ok.6:
  store %ArchxEnum_Shape %t17, ptr %pat.enum.20, align 8
  %t21 = getelementptr inbounds %ArchxEnum_Shape, ptr %pat.enum.20, i32 0, i32 1, i64 0
  %t22 = load double, ptr %t21, align 8
  store double %t22, ptr %pbind.r.23, align 8
  %t24 = load double, ptr %pbind.r.23, align 8
  %t25 = call fastcc %ArchxStr @archx_str_from_float(double %t24, ptr null)
  %t26 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 7165905831022559239, i64 3827052 }, %ArchxStr %t25, ptr null)
  call fastcc void @archx_str_drop(%ArchxStr %t25)
  %t27 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  call fastcc void @archx_enum_drop_Shape(%ArchxEnum_Shape %t27)
  ret %ArchxStr %t26
match.next.5:
  %t28 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  %t29 = extractvalue %ArchxEnum_Shape %t28, 0
  %t30 = icmp eq i64 %t29, 1
  br i1 %t30, label %pat.enum.ok.8, label %match.next.7
pat.enum.ok.8:
  store %ArchxEnum_Shape %t28, ptr %pat.enum.31, align 8
  %t32 = getelementptr inbounds %ArchxEnum_Shape, ptr %pat.enum.31, i32 0, i32 1, i64 0
  %t33 = load double, ptr %t32, align 8
  store double %t33, ptr %pbind.w.34, align 8
  %t35 = getelementptr inbounds %ArchxEnum_Shape, ptr %pat.enum.31, i32 0, i32 1, i64 1
  %t36 = load double, ptr %t35, align 8
  store double %t36, ptr %pbind.h.37, align 8
  %t38 = load double, ptr %pbind.w.34, align 8
  %t39 = load double, ptr %pbind.h.37, align 8
  %t40 = fcmp oeq double %t38, %t39
  br i1 %t40, label %match.body.9, label %match.gfail.10
match.gfail.10:
  br label %match.next.7
match.body.9:
  %t41 = fmul double %t38, %t39
  %t42 = call fastcc %ArchxStr @archx_str_from_float(double %t41, ptr null)
  %t43 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 7022643932689334279, i64 3827058 }, %ArchxStr %t42, ptr null)
  call fastcc void @archx_str_drop(%ArchxStr %t42)
  %t44 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  call fastcc void @archx_enum_drop_Shape(%ArchxEnum_Shape %t44)
  ret %ArchxStr %t43
match.next.7:
  %t45 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  %t46 = extractvalue %ArchxEnum_Shape %t45, 0
  %t47 = icmp eq i64 %t46, 1
  br i1 %t47, label %pat.enum.ok.12, label %match.next.11
pat.enum.ok.12:
  store %ArchxEnum_Shape %t45, ptr %pat.enum.48, align 8
  %t49 = getelementptr inbounds %ArchxEnum_Shape, ptr %pat.enum.48, i32 0, i32 1, i64 0
  %t50 = load double, ptr %t49, align 8
  store double %t50, ptr %pbind.w.51, align 8
  %t52 = getelementptr inbounds %ArchxEnum_Shape, ptr %pat.enum.48, i32 0, i32 1, i64 1
  %t53 = load double, ptr %t52, align 8
  store double %t53, ptr %pbind.h.54, align 8
  %t55 = load double, ptr %pbind.w.51, align 8
  %t56 = load double, ptr %pbind.h.54, align 8
  %t57 = fmul double %t55, %t56
  %t58 = call fastcc %ArchxStr @archx_str_from_float(double %t57, ptr null)
  %t59 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 8386658471394672645, i64 58 }, %ArchxStr %t58, ptr null)
  call fastcc void @archx_str_drop(%ArchxStr %t58)
  %t60 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  call fastcc void @archx_enum_drop_Shape(%ArchxEnum_Shape %t60)
  ret %ArchxStr %t59
match.next.11:
  %t61 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  %t62 = extractvalue %ArchxEnum_Shape %t61, 0
  %t63 = icmp eq i64 %t62, 2
  br i1 %t63, label %pat.enum.ok.14, label %match.next.13
pat.enum.ok.14:
  store %ArchxEnum_Shape %t61, ptr %pat.enum.64, align 8
  %t65 = getelementptr inbounds %ArchxEnum_Shape, ptr %pat.enum.64, i32 0, i32 1, i64 0
  %t66 = load %ArchxStr, ptr %t65, align 8
  store %ArchxStr %t66, ptr %pbind.tag.67, align 8
  %t68 = getelementptr inbounds %ArchxEnum_Shape, ptr %pat.enum.64, i32 0, i32 1, i64 2
  %t69 = load { i64, i64 }, ptr %t68, align 8
  %t70 = extractvalue { i64, i64 } %t69, 0
  store i64 %t70, ptr %pbind.x.71, align 8
  %t72 = extractvalue { i64, i64 } %t69, 1
  store i64 %t72, ptr %pbind.y.73, align 8
  %t74 = load %ArchxStr, ptr %pbind.tag.67, align 8
  %t75 = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %t74)
  store %ArchxStr %t75, ptr %pat.tag.76, align 8
  %t77 = load i64, ptr %pbind.x.71, align 8
  %t78 = load i64, ptr %pbind.y.73, align 8
  %t79 = load %ArchxStr, ptr %pat.tag.76, align 8
  %t80 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t79, %ArchxStr { i64 274877906945, i64 0 }, ptr null)
  %t81 = call fastcc %ArchxStr @archx_str_from_int(i64 %t77, ptr null)
  %t82 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t80, %ArchxStr %t81, ptr null)
  %t83 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t82, %ArchxStr { i64 188978561025, i64 0 }, ptr null)
  %t84 = call fastcc %ArchxStr @archx_str_from_int(i64 %t78, ptr null)
  %t85 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t83, %ArchxStr %t84, ptr null)
  call fastcc void @archx_str_drop(%ArchxStr %t84)
  call fastcc void @archx_str_drop(%ArchxStr %t83)
  call fastcc void @archx_str_drop(%ArchxStr %t82)
  call fastcc void @archx_str_drop(%ArchxStr %t81)
  call fastcc void @archx_str_drop(%ArchxStr %t80)
  %t86 = load %ArchxStr, ptr %pat.tag.76, align 8
  call fastcc void @archx_str_drop(%ArchxStr %t86)
  %t87 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  call fastcc void @archx_enum_drop_Shape(%ArchxEnum_Shape %t87)
  ret %ArchxStr %t85
match.next.13:
  %t88 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  %t89 = extractvalue %ArchxEnum_Shape %t88, 0
  %t90 = icmp eq i64 %t89, 3
  br i1 %t90, label %pat.enum.ok.15, label %match.end.0
pat.enum.ok.15:
  %t91 = load %ArchxEnum_Shape, ptr %match.subj.0, align 8
  call fastcc void @archx_enum_drop_Shape(%ArchxEnum_Shape %t91)
  ret %ArchxStr { i64 8390326386350358533, i64 121 }
match.end.0:
  unreachable
}

define i32 @main() {
entry:
  %func.region = alloca %ArchxRegion, align 8
  %var.a.23 = alloca i64, align 8
  %var.b.24 = alloca i64, align 8
  %var.pair.34 = alloca { %ArchxStr, i64, i1 }, align 8
  %stropt.res.71 = alloca %ArchxStr, align 8
  %enum.Shape.79 = alloca %ArchxEnum_Shape, align 8
  %enum.Shape.82 = alloca %ArchxEnum_Shape, align 8
  %enum.Shape.85 = alloca %ArchxEnum_Shape, align 8
  %enum.Shape.89 = alloca %ArchxEnum_Shape, align 8
  %enum.Shape.96 = alloca %ArchxEnum_Shape, align 8
  %var.shapes.120 = alloca %ArchxVec, align 8
  %foreach.idx.124 = alloca i64, align 8
  %var.sh.125 = alloca %ArchxEnum_Shape, align 8
  store %ArchxRegion zeroinitializer, ptr %func.region, align 8
  %t0 = call noalias align 16 ptr @malloc(i64 40)
  %t1 = icmp eq ptr %t0, null
  br i1 %t1, label %alloc.oom.1, label %alloc.ok.0
alloc.oom.1:
  call void @archx_oom_fail()
  unreachable
alloc.ok.0:
  %t2 = getelementptr inbounds i64, ptr %t0, i64 0
  store i64 12, ptr %t2, align 8
  %t3 = getelementptr inbounds i64, ptr %t0, i64 1
  store i64 5, ptr %t3, align 8
  %t4 = getelementptr inbounds i64, ptr %t0, i64 2
  store i64 42, ptr %t4, align 8
  %t5 = getelementptr inbounds i64, ptr %t0, i64 3
  store i64 19, ptr %t5, align 8
  %t6 = getelementptr inbounds i64, ptr %t0, i64 4
  store i64 8, ptr %t6, align 8
  %t7 = insertvalue %ArchxVec poison, i64 5, 0
  %t8 = insertvalue %ArchxVec %t7, i64 5, 1
  %t9 = insertvalue %ArchxVec %t8, ptr %t0, 2
  %t10 = extractvalue %ArchxVec %t9, 2
  %t11 = call fastcc { i64, i64, i64 } @archx_fn_min_max_sum(%ArchxVec %t9)
  %t12 = extractvalue { i64, i64, i64 } %t11, 0
  %t13 = extractvalue { i64, i64, i64 } %t11, 1
  %t14 = extractvalue { i64, i64, i64 } %t11, 2
  %t15 = call fastcc %ArchxStr @archx_str_from_int(i64 %t12, ptr null)
  %t16 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 8386112018410635270, i64 15731 }, %ArchxStr %t15, ptr null)
  %t17 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t16, %ArchxStr { i64 188978561025, i64 0 }, ptr null)
  %t18 = call fastcc %ArchxStr @archx_str_from_int(i64 %t13, ptr null)
  %t19 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t17, %ArchxStr %t18, ptr null)
  %t20 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t19, %ArchxStr { i64 188978561025, i64 0 }, ptr null)
  %t21 = call fastcc %ArchxStr @archx_str_from_int(i64 %t14, ptr null)
  %t22 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t20, %ArchxStr %t21, ptr null)
  call fastcc void @archx_str_print(%ArchxStr %t22, i1 true)
  call fastcc void @archx_str_drop(%ArchxStr %t22)
  call fastcc void @archx_str_drop(%ArchxStr %t21)
  call fastcc void @archx_str_drop(%ArchxStr %t20)
  call fastcc void @archx_str_drop(%ArchxStr %t19)
  call fastcc void @archx_str_drop(%ArchxStr %t18)
  call fastcc void @archx_str_drop(%ArchxStr %t17)
  call fastcc void @archx_str_drop(%ArchxStr %t16)
  call fastcc void @archx_str_drop(%ArchxStr %t15)
  store i64 10, ptr %var.a.23, align 8
  store i64 99, ptr %var.b.24, align 8
  %t25 = load i64, ptr %var.b.24, align 8
  %t26 = load i64, ptr %var.a.23, align 8
  %t27 = insertvalue { i64, i64 } undef, i64 %t25, 0
  %t28 = insertvalue { i64, i64 } %t27, i64 %t26, 1
  %t29 = extractvalue { i64, i64 } %t28, 0
  %t30 = extractvalue { i64, i64 } %t28, 1
  store i64 %t29, ptr %var.a.23, align 8
  store i64 %t30, ptr %var.b.24, align 8
  %t31 = insertvalue { %ArchxStr, i64, i1 } undef, %ArchxStr { i64 7521981563576254469, i64 120 }, 0
  %t32 = insertvalue { %ArchxStr, i64, i1 } %t31, i64 8, 1
  %t33 = insertvalue { %ArchxStr, i64, i1 } %t32, i1 true, 2
  store { %ArchxStr, i64, i1 } %t33, ptr %var.pair.34, align 8
  %t35 = load i64, ptr %var.a.23, align 8
  %t36 = call fastcc %ArchxStr @archx_str_from_int(i64 %t35, ptr null)
  %t37 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 8097884940793806853, i64 61 }, %ArchxStr %t36, ptr null)
  %t38 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t37, %ArchxStr { i64 188978561025, i64 0 }, ptr null)
  %t39 = load i64, ptr %var.b.24, align 8
  %t40 = call fastcc %ArchxStr @archx_str_from_int(i64 %t39, ptr null)
  %t41 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t38, %ArchxStr %t40, ptr null)
  %t42 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t41, %ArchxStr { i64 8103510785310851077, i64 61 }, ptr null)
  %t43 = load { %ArchxStr, i64, i1 }, ptr %var.pair.34, align 8
  %t44 = extractvalue { %ArchxStr, i64, i1 } %t43, 0
  %t45 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t42, %ArchxStr %t44, ptr null)
  %t46 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t45, %ArchxStr { i64 249108103169, i64 0 }, ptr null)
  %t47 = load { %ArchxStr, i64, i1 }, ptr %var.pair.34, align 8
  %t48 = extractvalue { %ArchxStr, i64, i1 } %t47, 2
  %t49 = select i1 %t48, %ArchxStr { i64 7310875412647641092, i64 0 }, %ArchxStr { i64 8317129702561021957, i64 101 }
  %t50 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t46, %ArchxStr %t49, ptr null)
  %t51 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t50, %ArchxStr { i64 7954883201514602501, i64 61 }, ptr null)
  %t52 = load { %ArchxStr, i64, i1 }, ptr %var.pair.34, align 8
  %t53 = call fastcc %ArchxStr @archx_str_from_int(i64 3, ptr null)
  %t54 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t51, %ArchxStr %t53, ptr null)
  call fastcc void @archx_str_print(%ArchxStr %t54, i1 true)
  call fastcc void @archx_str_drop(%ArchxStr %t54)
  call fastcc void @archx_str_drop(%ArchxStr %t53)
  call fastcc void @archx_str_drop(%ArchxStr %t51)
  call fastcc void @archx_str_drop(%ArchxStr %t50)
  call fastcc void @archx_str_drop(%ArchxStr %t46)
  call fastcc void @archx_str_drop(%ArchxStr %t45)
  call fastcc void @archx_str_drop(%ArchxStr %t42)
  call fastcc void @archx_str_drop(%ArchxStr %t41)
  call fastcc void @archx_str_drop(%ArchxStr %t40)
  call fastcc void @archx_str_drop(%ArchxStr %t38)
  call fastcc void @archx_str_drop(%ArchxStr %t37)
  call fastcc void @archx_str_drop(%ArchxStr %t36)
  %t55 = call fastcc { i1, i64 } @archx_fn_find_gt(%ArchxVec %t9, i64 20)
  %t56 = call fastcc { i1, i64 } @archx_fn_find_gt(%ArchxVec %t9, i64 500)
  %t57 = extractvalue { i1, i64 } %t55, 0
  br i1 %t57, label %if.then.2, label %if.else.3
if.then.2:
  %t58 = extractvalue { i1, i64 } %t55, 1
  %t59 = extractvalue %ArchxVec %t9, 0
  %t60 = icmp uge i64 %t58, %t59
  br i1 %t60, label %idx.oob.6, label %idx.ok.5
idx.oob.6:
  call void @archx_bounds_fail(i64 %t58, i64 %t59)
  unreachable
idx.ok.5:
  %t61 = extractvalue %ArchxVec %t9, 2
  %t62 = getelementptr inbounds i64, ptr %t61, i64 %t58
  %t63 = load i64, ptr %t62, align 8
  %t64 = call fastcc %ArchxStr @archx_str_from_int(i64 %t63, ptr null)
  %t65 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 7959390400324567046, i64 15716 }, %ArchxStr %t64, ptr null)
  %t66 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t65, %ArchxStr { i64 2338600896578977796, i64 0 }, ptr null)
  %t67 = extractvalue { i1, i64 } %t55, 1
  %t68 = call fastcc %ArchxStr @archx_str_from_int(i64 %t67, ptr null)
  %t69 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr %t66, %ArchxStr %t68, ptr null)
  call fastcc void @archx_str_print(%ArchxStr %t69, i1 true)
  call fastcc void @archx_str_drop(%ArchxStr %t69)
  call fastcc void @archx_str_drop(%ArchxStr %t68)
  call fastcc void @archx_str_drop(%ArchxStr %t66)
  call fastcc void @archx_str_drop(%ArchxStr %t65)
  call fastcc void @archx_str_drop(%ArchxStr %t64)
  br label %if.merge.4
if.else.3:
  br label %if.merge.4
if.merge.4:
  %t70 = extractvalue { i1, i64 } %t56, 0
  store %ArchxStr { i64 7308901626067025924, i64 0 }, ptr %stropt.res.71, align 8
  br i1 %t70, label %stropt.some.7, label %stropt.done.8
stropt.some.7:
  %t72 = extractvalue { i1, i64 } %t56, 1
  %t73 = call fastcc %ArchxStr @archx_str_from_int(i64 %t72, ptr null)
  store %ArchxStr %t73, ptr %stropt.res.71, align 8
  br label %stropt.done.8
stropt.done.8:
  %t74 = load %ArchxStr, ptr %stropt.res.71, align 8
  %t75 = call fastcc %ArchxStr @archx_str_concat(%ArchxStr { i64 8319108853555789832, i64 1030188649 }, %ArchxStr %t74, ptr null)
  call fastcc void @archx_str_print(%ArchxStr %t75, i1 true)
  call fastcc void @archx_str_drop(%ArchxStr %t75)
  call fastcc void @archx_str_drop(%ArchxStr %t74)
  %t76 = ptrtoint ptr @.str.1 to i64
  %t77 = insertvalue %ArchxStr poison, i64 7453016942991900710, 0
  %t78 = insertvalue %ArchxStr %t77, i64 %t76, 1
  store %ArchxEnum_Shape zeroinitializer, ptr %enum.Shape.79, align 8
  store i64 0, ptr %enum.Shape.79, align 8
  %t80 = getelementptr inbounds %ArchxEnum_Shape, ptr %enum.Shape.79, i32 0, i32 1, i64 0
  store double 0x400C000000000000, ptr %t80, align 8
  %t81 = load %ArchxEnum_Shape, ptr %enum.Shape.79, align 8
  store %ArchxEnum_Shape zeroinitializer, ptr %enum.Shape.82, align 8
  store i64 0, ptr %enum.Shape.82, align 8
  %t83 = getelementptr inbounds %ArchxEnum_Shape, ptr %enum.Shape.82, i32 0, i32 1, i64 0
  store double 0x4028000000000000, ptr %t83, align 8
  %t84 = load %ArchxEnum_Shape, ptr %enum.Shape.82, align 8
  store %ArchxEnum_Shape zeroinitializer, ptr %enum.Shape.85, align 8
  store i64 1, ptr %enum.Shape.85, align 8
  %t86 = getelementptr inbounds %ArchxEnum_Shape, ptr %enum.Shape.85, i32 0, i32 1, i64 0
  store double 0x4010000000000000, ptr %t86, align 8
  %t87 = getelementptr inbounds %ArchxEnum_Shape, ptr %enum.Shape.85, i32 0, i32 1, i64 1
  store double 0x4010000000000000, ptr %t87, align 8
  %t88 = load %ArchxEnum_Shape, ptr %enum.Shape.85, align 8
  store %ArchxEnum_Shape zeroinitializer, ptr %enum.Shape.89, align 8
  store i64 1, ptr %enum.Shape.89, align 8
  %t90 = getelementptr inbounds %ArchxEnum_Shape, ptr %enum.Shape.89, i32 0, i32 1, i64 0
  store double 0x4008000000000000, ptr %t90, align 8
  %t91 = getelementptr inbounds %ArchxEnum_Shape, ptr %enum.Shape.89, i32 0, i32 1, i64 1
  store double 0x4014000000000000, ptr %t91, align 8
  %t92 = load %ArchxEnum_Shape, ptr %enum.Shape.89, align 8
  %t93 = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %t78)
  %t94 = insertvalue { i64, i64 } undef, i64 7, 0
  %t95 = insertvalue { i64, i64 } %t94, i64 9, 1
  store %ArchxEnum_Shape zeroinitializer, ptr %enum.Shape.96, align 8
  store i64 2, ptr %enum.Shape.96, align 8
  %t97 = getelementptr inbounds %ArchxEnum_Shape, ptr %enum.Shape.96, i32 0, i32 1, i64 0
  store %ArchxStr %t93, ptr %t97, align 8
  %t98 = getelementptr inbounds %ArchxEnum_Shape, ptr %enum.Shape.96, i32 0, i32 1, i64 2
  store { i64, i64 } %t95, ptr %t98, align 8
  %t99 = load %ArchxEnum_Shape, ptr %enum.Shape.96, align 8
  %t100 = insertvalue %ArchxEnum_Shape zeroinitializer, i64 3, 0
  %t101 = call fastcc %ArchxEnum_Shape @archx_enum_clone_Shape(%ArchxEnum_Shape %t100)
  %t102 = getelementptr %ArchxEnum_Shape, ptr null, i64 1
  %t103 = ptrtoint ptr %t102 to i64
  %t104 = call { i64, i1 } @llvm.smul.with.overflow.i64(i64 6, i64 %t103)
  %t105 = extractvalue { i64, i1 } %t104, 0
  %t106 = extractvalue { i64, i1 } %t104, 1
  br i1 %t106, label %mul.oom.9, label %mul.ok.10
mul.oom.9:
  call void @archx_oom_fail()
  unreachable
mul.ok.10:
  %t107 = icmp eq i64 %t105, 0
  %t108 = select i1 %t107, i64 1, i64 %t105
  %t109 = call noalias align 16 ptr @malloc(i64 %t108)
  %t110 = icmp eq ptr %t109, null
  br i1 %t110, label %alloc.oom.12, label %alloc.ok.11
alloc.oom.12:
  call void @archx_oom_fail()
  unreachable
alloc.ok.11:
  %t111 = getelementptr inbounds %ArchxEnum_Shape, ptr %t109, i64 0
  store %ArchxEnum_Shape %t81, ptr %t111, align 8
  %t112 = getelementptr inbounds %ArchxEnum_Shape, ptr %t109, i64 1
  store %ArchxEnum_Shape %t84, ptr %t112, align 8
  %t113 = getelementptr inbounds %ArchxEnum_Shape, ptr %t109, i64 2
  store %ArchxEnum_Shape %t88, ptr %t113, align 8
  %t114 = getelementptr inbounds %ArchxEnum_Shape, ptr %t109, i64 3
  store %ArchxEnum_Shape %t92, ptr %t114, align 8
  %t115 = getelementptr inbounds %ArchxEnum_Shape, ptr %t109, i64 4
  store %ArchxEnum_Shape %t99, ptr %t115, align 8
  %t116 = getelementptr inbounds %ArchxEnum_Shape, ptr %t109, i64 5
  store %ArchxEnum_Shape %t101, ptr %t116, align 8
  %t117 = insertvalue %ArchxVec poison, i64 6, 0
  %t118 = insertvalue %ArchxVec %t117, i64 6, 1
  %t119 = insertvalue %ArchxVec %t118, ptr %t109, 2
  store %ArchxVec %t119, ptr %var.shapes.120, align 8
  %t121 = load %ArchxVec, ptr %var.shapes.120, align 8
  %t122 = extractvalue %ArchxVec %t121, 0
  %t123 = extractvalue %ArchxVec %t121, 2
  store i64 0, ptr %foreach.idx.124, align 8
  store %ArchxEnum_Shape zeroinitializer, ptr %var.sh.125, align 8
  br label %foreach.cond.13
foreach.cond.13:
  %t126 = load i64, ptr %foreach.idx.124, align 8
  %t127 = icmp slt i64 %t126, %t122
  br i1 %t127, label %foreach.body.14, label %foreach.end.16
foreach.body.14:
  %t128 = getelementptr inbounds %ArchxEnum_Shape, ptr %t123, i64 %t126
  %t129 = load %ArchxEnum_Shape, ptr %t128, align 8
  %t130 = load %ArchxEnum_Shape, ptr %var.sh.125, align 8
  call fastcc void @archx_enum_drop_Shape(%ArchxEnum_Shape %t130)
  %t131 = call fastcc %ArchxEnum_Shape @archx_enum_clone_Shape(%ArchxEnum_Shape %t129)
  store %ArchxEnum_Shape %t131, ptr %var.sh.125, align 8
  %t132 = load %ArchxEnum_Shape, ptr %var.sh.125, align 8
  %t133 = call fastcc %ArchxStr @archx_fn_describe_shape(%ArchxEnum_Shape %t132)
  call fastcc void @archx_str_print(%ArchxStr %t133, i1 true)
  call fastcc void @archx_str_drop(%ArchxStr %t133)
  br label %foreach.step.15
foreach.step.15:
  %t134 = load i64, ptr %foreach.idx.124, align 8
  %t135 = add nsw i64 %t134, 1
  store i64 %t135, ptr %foreach.idx.124, align 8
  br label %foreach.cond.13
foreach.end.16:
  %t136 = load %ArchxVec, ptr %var.shapes.120, align 8
  call fastcc void @archx_vec_drop_U5_Shape(%ArchxVec %t136)
  %t137 = load %ArchxEnum_Shape, ptr %var.sh.125, align 8
  call fastcc void @archx_enum_drop_Shape(%ArchxEnum_Shape %t137)
  call fastcc void @archx_region_rewind_root(ptr %func.region)
  %t138 = load { %ArchxStr, i64, i1 }, ptr %var.pair.34, align 8
  %t139 = extractvalue { %ArchxStr, i64, i1 } %t138, 0
  call fastcc void @archx_str_drop(%ArchxStr %t139)
  call void @free(ptr %t10)
  %t140 = getelementptr inbounds %ArchxRegion, ptr %func.region, i32 0, i32 2
  %t141 = load ptr, ptr %t140, align 8
  call fastcc void @archx_region_release_from(ptr %t141)
  ret i32 0
}

define private fastcc %ArchxEnum_Shape @archx_enum_clone_Shape(%ArchxEnum_Shape %v) {
entry:
  %src = alloca %ArchxEnum_Shape, align 8
  %dst = alloca %ArchxEnum_Shape, align 8
  store %ArchxEnum_Shape %v, ptr %src, align 8
  store %ArchxEnum_Shape %v, ptr %dst, align 8
  %tag = extractvalue %ArchxEnum_Shape %v, 0
  switch i64 %tag, label %done [ i64 2, label %v.2 ]
v.2:
  %t0 = getelementptr inbounds %ArchxEnum_Shape, ptr %src, i32 0, i32 1, i64 0
  %t1 = getelementptr inbounds %ArchxEnum_Shape, ptr %dst, i32 0, i32 1, i64 0
  %t2 = load %ArchxStr, ptr %t0, align 8
  %t3 = call fastcc %ArchxStr @archx_str_clone(%ArchxStr %t2)
  store %ArchxStr %t3, ptr %t1, align 8
  br label %done
done:
  %res = load %ArchxEnum_Shape, ptr %dst, align 8
  ret %ArchxEnum_Shape %res
}

define private fastcc void @archx_enum_drop_Shape(%ArchxEnum_Shape %v) nounwind {
entry:
  %slot = alloca %ArchxEnum_Shape, align 8
  store %ArchxEnum_Shape %v, ptr %slot, align 8
  %tag = extractvalue %ArchxEnum_Shape %v, 0
  switch i64 %tag, label %done [ i64 2, label %v.2 ]
v.2:
  %t0 = getelementptr inbounds %ArchxEnum_Shape, ptr %slot, i32 0, i32 1, i64 0
  %t1 = load %ArchxStr, ptr %t0, align 8
  call fastcc void @archx_str_drop(%ArchxStr %t1)
  br label %done
done:
  ret void
}

define private fastcc void @archx_vec_drop_U5_Shape(%ArchxVec %v) nounwind {
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
  %ep = getelementptr inbounds %ArchxEnum_Shape, ptr %data, i64 %i
  %t0 = load %ArchxEnum_Shape, ptr %ep, align 8
  call fastcc void @archx_enum_drop_Shape(%ArchxEnum_Shape %t0)
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

@.fmt.pstr.nl = private unnamed_addr constant [6 x i8] c"%.*s\0A\00", align 1
@.fmt.pstr = private unnamed_addr constant [5 x i8] c"%.*s\00", align 1

; Compat `repr()` spelling for an element inside a container: CPython shows quotes around a string.
define private void @archx_str_print_repr(%ArchxStr %s) nounwind {
entry:
  %q1 = call i32 @putchar(i32 39)
  call fastcc void @archx_str_print(%ArchxStr %s, i1 false)
  %q2 = call i32 @putchar(i32 39)
  ret void
}

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

@.err.overflow = private unnamed_addr constant [39 x i8] c"archx runtime panic: integer overflow\0A\00", align 1

define private void @archx_int_overflow_fail() cold noreturn nounwind {
entry:
  %c = call i32 (ptr, ...) @printf(ptr @.err.overflow)
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
declare void @free(ptr) nounwind
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg)
declare { i64, i1 } @llvm.smul.with.overflow.i64(i64, i64) nounwind readnone speculatable
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64) nounwind readnone speculatable
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64) nounwind readnone speculatable
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
  ; Python prints the shortest decimal that round-trips back to the same double. Start at 15
  ; significant digits and widen to 16 then 17 until `strtod` agrees again.
  %n15 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull %buf, ptr @.fmt.g15, double %x)
  %back15 = call double @strtod(ptr nonnull %buf, ptr null)
  %eq15 = fcmp oeq double %back15, %x
  br i1 %eq15, label %done, label %try16
try16:
  %n16 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull %buf, ptr @.fmt.g16, double %x)
  %back16 = call double @strtod(ptr nonnull %buf, ptr null)
  %eq16 = fcmp oeq double %back16, %x
  br i1 %eq16, label %done, label %try17
try17:
  %n17 = call i32 (ptr, ptr, ...) @sprintf(ptr nonnull %buf, ptr @.fmt.g17, double %x)
  br label %done
done:
  %n32 = phi i32 [ %n15, %entry ], [ %n16, %try16 ], [ %n17, %try17 ]
  %n = sext i32 %n32 to i64
  %pos = icmp sgt i64 %n, 0
  br i1 %pos, label %scan, label %ret_orig
scan:
  %i = phi i64 [ 0, %done ], [ %inext, %scan_step ]
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

declare i32 @sprintf(ptr nocapture writeonly, ptr nocapture readonly, ...) nounwind
declare double @strtod(ptr nocapture readonly, ptr nocapture writeonly) nounwind

!llvm.module.flags = !{!0, !1}
!0 = !{i32 1, !"archx.dialect", !"native"}
!1 = !{i32 1, !"archx.directive_version", !"1"}
