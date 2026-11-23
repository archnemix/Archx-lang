//! Expression lowering: literals, variables, indexing, struct fields, checked integer arithmetic,
//! short-circuit booleans, and 16-byte German/Umbra prefix-SSO string operations.

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

impl Codegen {
    // ---------------- Expressions --------------------------------------------

    pub(super) fn eval_expr(&mut self, expr: &Expr, out: &mut String) -> Result<(Type, String)> {
        self.eval_expr_typed(expr, None, out)
    }

    pub(super) fn eval_expr_typed(
        &mut self,
        expr: &Expr,
        expected: Option<&Type>,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.enter_depth(expr.span)?;
        let res = self.eval_expr_typed_inner(expr, expected, out);
        self.depth -= 1;
        res
    }

    pub(super) fn eval_expr_typed_inner(
        &mut self,
        expr: &Expr,
        expected: Option<&Type>,
        out: &mut String,
    ) -> Result<(Type, String)> {
        match &expr.kind {
            ExprKind::Int(value) => Ok((Type::Int, value.to_string())),

            ExprKind::Float(value) => Ok((Type::Float, format_llvm_double(*value))),

            ExprKind::Bool(value) => Ok((Type::Bool, value.to_string())),

            ExprKind::NoneLit => Ok((Type::Void, String::new())),

            ExprKind::FString(parts) => self.gen_fstring(parts, out),

            ExprKind::MethodCall {
                target,
                method,
                args,
            } => self.gen_method_call(target, method, args, expr.span, out),

            ExprKind::CallKw {
                name,
                pos_args,
                kw_args,
            } => self.gen_call_kw(name, pos_args, kw_args, expr.span, out),

            ExprKind::IfExpr {
                then_expr,
                cond,
                else_expr,
            } => self.gen_if_expr(then_expr, cond, else_expr, expected, expr.span, out),

            ExprKind::Str(value) => {
                self.used_str_type = true;
                let bytes = value.as_bytes();
                if bytes.len() as i64 > MAX_STR_LEN {
                    return Err(Diagnostic::new(
                        "string literal exceeds maximum 2 GB length",
                        expr.span,
                    ));
                }
                if bytes.len() <= 12 {
                    let (w0, w1) = pack_sso_str_words(bytes);
                    Ok((Type::Str, format!("{{ i64 {w0}, i64 {w1} }}")))
                } else {
                    let sym = self.strings.intern(value);
                    let w0 = pack_long_str_w0(bytes);
                    let p_int = self.next_tmp();
                    let _ = writeln!(out, "  {p_int} = ptrtoint ptr {sym} to i64");
                    let s0 = self.next_tmp();
                    let _ = writeln!(out, "  {s0} = insertvalue %ArchxStr poison, i64 {w0}, 0");
                    let s1 = self.next_tmp();
                    let _ = writeln!(out, "  {s1} = insertvalue %ArchxStr {s0}, i64 {p_int}, 1");
                    Ok((Type::Str, s1))
                }
            }

            ExprKind::Var(name) => {
                let entry = self.lookup_var(name).cloned().ok_or_else(|| {
                    Diagnostic::new(format!("undefined variable `{name}`"), expr.span)
                })?;
                match entry.storage {
                    VarStorage::Imm(val) => Ok((entry.ty, val)),
                    VarStorage::Slot(ptr) => {
                        let reg = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {reg} = load {}, ptr {ptr}, align {}",
                            ir_type(&entry.ty),
                            ir_align(&entry.ty)
                        );
                        Ok((entry.ty, reg))
                    }
                    VarStorage::Soa { .. } => Err(Diagnostic::new(
                        format!(
                            "array `{name}` uses local SoA layout and cannot be copied as a whole"
                        ),
                        expr.span,
                    )),
                }
            }

            ExprKind::Field { target, field } => {
                if let ExprKind::Index {
                    target: arr_e,
                    index: idx_e,
                } = &target.kind
                {
                    if let ExprKind::Var(aname) = &arr_e.kind {
                        if let Some(entry) = self.lookup_var(aname).cloned() {
                            if let VarStorage::Soa {
                                struct_name,
                                len_val,
                                planes,
                            } = entry.storage
                            {
                                let (fidx, fty) =
                                    self.lookup_struct_field(&struct_name, field, expr.span)?;
                                let (idx_ty, idx_val) = self.eval_expr(idx_e, out)?;
                                if idx_ty != Type::Int {
                                    return Err(Diagnostic::new(
                                        format!("array index must be `int`, found `{}`", idx_ty.name()),
                                        idx_e.span,
                                    ));
                                }
                                self.emit_raw_len_bounds_check(
                                    arr_e, idx_e, &len_val, &idx_val, out,
                                )?;
                                let plane_ptr = &planes[fidx].1;
                                let mem_ty = elem_mem_ir_type(&fty);
                                let ep = self.next_tmp();
                                let _ = writeln!(
                                    out,
                                    "  {ep} = getelementptr inbounds {mem_ty}, ptr {plane_ptr}, i64 {idx_val}"
                                );
                                let val = self.emit_elem_load(&fty, &ep, out);
                                return Ok((fty, val));
                            }
                        }
                    }
                }

                let (base_ty, base_val) = self.eval_expr(target, out)?;
                let Type::Struct(sname) = base_ty else {
                    return Err(Diagnostic::new(
                        format!("cannot access field `{field}` on `{}`", base_ty.name()),
                        expr.span,
                    ));
                };
                let (fidx, fty) = self.lookup_struct_field(&sname, field, expr.span)?;
                let extracted = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {extracted} = extractvalue %ArchxStruct_{sname} {base_val}, {fidx}"
                );
                if self.type_needs_drop(&fty)
                    && self.stmt_temps.iter().any(|t| t.val == base_val)
                {
                    let cloned = self.emit_clone_value(&fty, &extracted, out);
                    self.stmt_temps.push(TempDrop {
                        val: cloned.clone(),
                        ty: fty.clone(),
                    });
                    return Ok((fty, cloned));
                }
                Ok((fty, extracted))
            }

            ExprKind::ArrayLit(elems) => {
                self.used_vec_type = true;
                if elems.is_empty() {
                    let Some(Type::Array(elem_ty)) = expected else {
                        return Err(Diagnostic::new(
                            "cannot infer element type of empty array `[]`; add a type annotation like `let xs: [int] = []`",
                            expr.span,
                        ));
                    };
                    let vec = self.build_vec_val("0", "0", "null", out);
                    return Ok((Type::Array(elem_ty.clone()), vec));
                }

                let elem_hint = match expected {
                    Some(Type::Array(inner)) => Some(inner.as_ref()),
                    _ => None,
                };

                let (first_ty, raw_first) = self.eval_expr_typed(&elems[0], elem_hint, out)?;
                if first_ty == Type::Void {
                    return Err(Diagnostic::new(
                        "array elements cannot have type `void`",
                        elems[0].span,
                    ));
                }
                let elem_drops = self.type_needs_drop(&first_ty);
                let first_owned = if elem_drops {
                    if self.claim_stmt_temp(&raw_first) {
                        raw_first
                    } else {
                        self.emit_clone_value(&first_ty, &raw_first, out)
                    }
                } else {
                    raw_first
                };

                let mut vals = vec![first_owned];
                for item in &elems[1..] {
                    let (ty, raw_v) = self.eval_expr_typed(item, Some(&first_ty), out)?;
                    if ty != first_ty {
                        return Err(Diagnostic::new(
                            format!(
                                "array element type mismatch: expected `{}`, found `{}`",
                                first_ty.name(),
                                ty.name()
                            ),
                            item.span,
                        ));
                    }
                    let owned_v = if elem_drops {
                        if self.claim_stmt_temp(&raw_v) {
                            raw_v
                        } else {
                            self.emit_clone_value(&first_ty, &raw_v, out)
                        }
                    } else {
                        raw_v
                    };
                    vals.push(owned_v);
                }

                let count = vals.len() as i64;
                let count_str = count.to_string();
                let bytes = self.emit_type_bytes_const_mul(&first_ty, count, out);

                let use_region = !self.region_stack.is_empty() && !elem_drops;
                let (data_ptr, cap_str) = if use_region {
                    let rslot = self.func_region_slot.clone().unwrap();
                    let p = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {p} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
                    );
                    (p, format!("-{count}"))
                } else {
                    let p = self.emit_checked_malloc(&bytes, out);
                    (p, count_str.clone())
                };

                let mem_ty = elem_mem_ir_type(&first_ty);
                for (i, val) in vals.iter().enumerate() {
                    let ep = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {ep} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {i}"
                    );
                    self.emit_elem_store(&first_ty, val, &ep, out);
                }

                let vec = self.build_vec_val(&count_str, &cap_str, &data_ptr, out);
                let arr_ty = Type::Array(Box::new(first_ty));
                self.stmt_temps.push(TempDrop {
                    val: vec.clone(),
                    ty: arr_ty.clone(),
                });
                Ok((arr_ty, vec))
            }

            ExprKind::ArrayRepeat { value, count } => {
                self.used_vec_type = true;
                let elem_hint = match expected {
                    Some(Type::Array(inner)) => Some(inner.as_ref()),
                    _ => None,
                };
                let (elem_ty, raw_init) = self.eval_expr_typed(value, elem_hint, out)?;
                if elem_ty == Type::Void {
                    return Err(Diagnostic::new(
                        "array elements cannot have type `void`",
                        value.span,
                    ));
                }
                let (count_ty, count_val) = self.eval_expr(count, out)?;
                if count_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "array repeat count must be `int`, found `{}`",
                            count_ty.name()
                        ),
                        count.span,
                    ));
                }

                self.emit_repeat_count_check(count, &count_val, out)?;

                let elem_drops = self.type_needs_drop(&elem_ty);
                let use_region = !self.region_stack.is_empty() && !elem_drops;
                let is_zero_fill = !use_region
                    && ((elem_ty == Type::Int && raw_init == "0")
                        || (elem_ty == Type::Float && raw_init == "0x0000000000000000")
                        || (elem_ty == Type::Bool && raw_init == "false"));

                let (data_ptr, cap_val) = if is_zero_fill {
                    let elem_sz = if elem_ty == Type::Bool { 1 } else { 8 };
                    let p = self.emit_checked_calloc(&count_val, elem_sz, out);
                    (p, count_val.clone())
                } else {
                    let elem_sz_val = self.emit_elem_sizeof(&elem_ty, out);
                    let bytes = self.emit_elem_bytes_val_mul(&count_val, &elem_sz_val, out);
                    let (p, cval) = if use_region {
                        let rslot = self.func_region_slot.clone().unwrap();
                        let pr = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {pr} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
                        );
                        let neg_c = self.next_tmp();
                        let _ = writeln!(out, "  {neg_c} = sub nsw i64 0, {count_val}");
                        (pr, neg_c)
                    } else {
                        (self.emit_checked_malloc(&bytes, out), count_val.clone())
                    };
                    self.emit_general_fill_loop(&elem_ty, &raw_init, &p, &count_val, out);
                    (p, cval)
                };

                let vec = self.build_vec_val(&count_val, &cap_val, &data_ptr, out);
                let arr_ty = Type::Array(Box::new(elem_ty));
                self.stmt_temps.push(TempDrop {
                    val: vec.clone(),
                    ty: arr_ty.clone(),
                });
                Ok((arr_ty, vec))
            }

            ExprKind::Index { target, index } => {
                if let ExprKind::Var(aname) = &target.kind {
                    if let Some(entry) = self.lookup_var(aname).cloned() {
                        if let VarStorage::Soa {
                            struct_name,
                            len_val,
                            planes,
                        } = entry.storage
                        {
                            let (idx_ty, idx_val) = self.eval_expr(index, out)?;
                            if idx_ty != Type::Int {
                                return Err(Diagnostic::new(
                                    format!("array index must be `int`, found `{}`", idx_ty.name()),
                                    index.span,
                                ));
                            }
                            self.emit_raw_len_bounds_check(target, index, &len_val, &idx_val, out)?;
                            let sval =
                                self.load_soa_struct_at(&struct_name, &planes, &idx_val, out);
                            return Ok((Type::Struct(struct_name), sval));
                        }
                    }
                }

                let (arr_ty, vec_val) = self.eval_expr(target, out)?;
                if arr_ty == Type::Str {
                    let (idx_ty, idx_val) = self.eval_expr(index, out)?;
                    if idx_ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!("string index must be `int`, found `{}`", idx_ty.name()),
                            index.span,
                        ));
                    }
                    self.used_str_byte_at = true;
                    let ch = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {ch} = call fastcc %ArchxStr @archx_str_byte_at(%ArchxStr {vec_val}, i64 {idx_val})"
                    );
                    return Ok((Type::Str, ch));
                }
                let Type::Array(elem_ty) = arr_ty else {
                    return Err(Diagnostic::new(
                        format!("cannot index into value of type `{}`", arr_ty.name()),
                        target.span,
                    ));
                };
                let (idx_ty, idx_val) = self.eval_expr(index, out)?;
                if idx_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!("array index must be `int`, found `{}`", idx_ty.name()),
                        index.span,
                    ));
                }

                self.emit_bounds_check_if_needed(target, index, &vec_val, &idx_val, out)?;

                let data_ptr = self.next_tmp();
                let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {vec_val}, 2");
                let elem_ptr = self.next_tmp();
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let _ = writeln!(
                    out,
                    "  {elem_ptr} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {idx_val}"
                );
                let loaded = self.emit_elem_load(&elem_ty, &elem_ptr, out);
                let safe_loaded = if self.type_needs_drop(&elem_ty)
                    && self.stmt_temps.iter().any(|t| t.val == vec_val)
                {
                    let cloned = self.emit_clone_value(&elem_ty, &loaded, out);
                    self.stmt_temps.push(TempDrop {
                        val: cloned.clone(),
                        ty: (*elem_ty).clone(),
                    });
                    cloned
                } else {
                    loaded
                };
                Ok((*elem_ty, safe_loaded))
            }

            ExprKind::Unary { op, expr: inner } => {
                let (ty, val) = self.eval_expr(inner, out)?;
                match op {
                    UnOp::Neg => {
                        if ty == Type::Float {
                            let reg = self.next_tmp();
                            let _ = writeln!(out, "  {reg} = fneg double {val}");
                            return Ok((Type::Float, reg));
                        }
                        if ty != Type::Int {
                            return Err(Diagnostic::new(
                                "unary `-` requires an `int` or `float` operand",
                                expr.span,
                            ));
                        }
                        let reg = self.next_tmp();
                        let _ = writeln!(out, "  {reg} = sub i64 0, {val}");
                        Ok((Type::Int, reg))
                    }
                    UnOp::Not => {
                        if ty != Type::Bool {
                            return Err(Diagnostic::new(
                                "`not` requires a `bool` operand",
                                expr.span,
                            ));
                        }
                        let reg = self.next_tmp();
                        let _ = writeln!(out, "  {reg} = xor i1 {val}, true");
                        Ok((Type::Bool, reg))
                    }
                }
            }

            ExprKind::Binary { op, lhs, rhs } => self.gen_binary(*op, lhs, rhs, expr.span, out),

            ExprKind::Call { name, args } => self.gen_call(name, args, expr.span, out),
        }
    }

    pub(super) fn load_soa_struct_at(
        &mut self,
        struct_name: &str,
        planes: &[(Type, String)],
        idx_val: &str,
        out: &mut String,
    ) -> String {
        let mut agg = "poison".to_string();
        for (k, (fty, p_ptr)) in planes.iter().enumerate() {
            let mem_ty = elem_mem_ir_type(fty);
            let ep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {ep} = getelementptr inbounds {mem_ty}, ptr {p_ptr}, i64 {idx_val}"
            );
            let fv = self.emit_elem_load(fty, &ep, out);
            let next_agg = self.next_tmp();
            let _ = writeln!(
                out,
                "  {next_agg} = insertvalue %ArchxStruct_{struct_name} {agg}, {} {fv}, {k}",
                ir_type(fty)
            );
            agg = next_agg;
        }
        agg
    }

    pub(super) fn gen_if_expr(
        &mut self,
        then_expr: &Expr,
        cond: &Expr,
        else_expr: &Expr,
        expected: Option<&Type>,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let mark = self.stmt_temps.len();
        let (cond_ty, cond_val) = self.eval_expr(cond, out)?;
        if cond_ty != Type::Bool {
            return Err(Diagnostic::new(
                format!(
                    "conditional expression condition must be `bool`, found `{}`",
                    cond_ty.name()
                ),
                cond.span,
            ));
        }
        self.flush_stmt_temps_from(mark, out);

        let then_lbl = self.fresh_label("ifexpr.then");
        let else_lbl = self.fresh_label("ifexpr.else");
        let merge_lbl = self.fresh_label("ifexpr.merge");

        self.emit_cond_br(&cond_val, &then_lbl, &else_lbl, out);

        self.start_block(&then_lbl, out);
        let mark_t = self.stmt_temps.len();
        let (then_ty, raw_then) = self.eval_expr_typed(then_expr, expected, out)?;
        if then_ty == Type::Void {
            return Err(Diagnostic::new(
                "conditional expression branches must produce a value",
                then_expr.span,
            ));
        }
        let needs_drop = self.type_needs_drop(&then_ty);
        let then_owned = if needs_drop {
            if self.claim_stmt_temp(&raw_then) {
                raw_then
            } else {
                self.emit_clone_value(&then_ty, &raw_then, out)
            }
        } else {
            raw_then
        };
        self.flush_stmt_temps_from(mark_t, out);
        let slot = self.next_slot("ifexpr.res");
        let ty_ir = ir_type(&then_ty);
        let align = ir_align(&then_ty);
        let _ = writeln!(self.allocas, "  {slot} = alloca {ty_ir}, align {align}");
        let _ = writeln!(out, "  store {ty_ir} {then_owned}, ptr {slot}, align {align}");
        self.emit_br(&merge_lbl, out);

        self.start_block(&else_lbl, out);
        let mark_e = self.stmt_temps.len();
        let (else_ty, raw_else) = self.eval_expr_typed(else_expr, Some(&then_ty), out)?;
        if else_ty != then_ty {
            return Err(Diagnostic::new(
                format!(
                    "conditional expression branches have incompatible types `{}` and `{}`",
                    then_ty.name(),
                    else_ty.name()
                ),
                span,
            ));
        }
        let else_owned = if needs_drop {
            if self.claim_stmt_temp(&raw_else) {
                raw_else
            } else {
                self.emit_clone_value(&then_ty, &raw_else, out)
            }
        } else {
            raw_else
        };
        self.flush_stmt_temps_from(mark_e, out);
        let _ = writeln!(out, "  store {ty_ir} {else_owned}, ptr {slot}, align {align}");
        self.emit_br(&merge_lbl, out);

        self.start_block(&merge_lbl, out);
        let res = self.next_tmp();
        let _ = writeln!(out, "  {res} = load {ty_ir}, ptr {slot}, align {align}");
        if needs_drop {
            self.stmt_temps.push(TempDrop {
                val: res.clone(),
                ty: then_ty.clone(),
            });
        }
        Ok((then_ty, res))
    }

    pub(super) fn gen_binary(
        &mut self,
        op: BinOp,
        lhs: &Expr,
        rhs: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if matches!(op, BinOp::And | BinOp::Or) {
            return self.gen_short_circuit(op, lhs, rhs, span, out);
        }

        let (lhs_ty, lhs_val) = self.eval_expr(lhs, out)?;
        let (rhs_ty, rhs_val) = self.eval_expr(rhs, out)?;

        match op {
            BinOp::Add if lhs_ty == Type::Str && rhs_ty == Type::Str => {
                let res = self.emit_str_concat_call(&lhs_val, &rhs_val, out);
                Ok((Type::Str, res))
            }

            BinOp::Add if lhs_ty.is_array() && lhs_ty == rhs_ty => {
                let Type::Array(elem_ty) = lhs_ty else {
                    unreachable!()
                };
                let res = self.emit_list_concat(&elem_ty, &lhs_val, &rhs_val, out);
                Ok((Type::Array(elem_ty), res))
            }

            BinOp::Mul
                if (lhs_ty == Type::Str && rhs_ty == Type::Int)
                    || (lhs_ty == Type::Int && rhs_ty == Type::Str) =>
            {
                let (sval, nval) = if lhs_ty == Type::Str {
                    (&lhs_val, &rhs_val)
                } else {
                    (&rhs_val, &lhs_val)
                };
                self.used_str_repeat = true;
                let reg_arg = self.active_region_arg();
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxStr @archx_str_repeat(%ArchxStr {sval}, i64 {nval}, ptr {reg_arg})"
                );
                self.stmt_temps.push(TempDrop {
                    val: res.clone(),
                    ty: Type::Str,
                });
                Ok((Type::Str, res))
            }

            BinOp::In | BinOp::NotIn => {
                let found = self.gen_in_operator(&lhs_ty, &lhs_val, &rhs_ty, &rhs_val, span, out)?;
                if op == BinOp::In {
                    Ok((Type::Bool, found))
                } else {
                    let inv = self.next_tmp();
                    let _ = writeln!(out, "  {inv} = xor i1 {found}, true");
                    Ok((Type::Bool, inv))
                }
            }

            BinOp::Add
            | BinOp::Sub
            | BinOp::Mul
            | BinOp::Div
            | BinOp::FloorDiv
            | BinOp::Pow
            | BinOp::Mod => {
                if lhs_ty == Type::Float && rhs_ty == Type::Float {
                    let val = self.emit_float_arith(op, &lhs_val, &rhs_val, out);
                    return Ok((Type::Float, val));
                }
                if lhs_ty != Type::Int || rhs_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}` requires matching `int` or `float` operands, found `{}` and `{}`",
                            op.symbol(),
                            lhs_ty.name(),
                            rhs_ty.name()
                        ),
                        span,
                    ));
                }

                let val = self.emit_int_arith(op, &lhs_val, &rhs_val, out);
                Ok((Type::Int, val))
            }

            BinOp::Eq | BinOp::Ne => {
                let eq_val = self.emit_equality(&lhs_ty, &lhs_val, &rhs_ty, &rhs_val, span, out)?;
                if op == BinOp::Eq {
                    Ok((Type::Bool, eq_val))
                } else {
                    let inv = self.next_tmp();
                    let _ = writeln!(out, "  {inv} = xor i1 {eq_val}, true");
                    Ok((Type::Bool, inv))
                }
            }

            BinOp::Lt | BinOp::Gt | BinOp::Le | BinOp::Ge => {
                if lhs_ty == Type::Float && rhs_ty == Type::Float {
                    let reg = self.next_tmp();
                    let pred = match op {
                        BinOp::Lt => "olt",
                        BinOp::Gt => "ogt",
                        BinOp::Le => "ole",
                        BinOp::Ge => "oge",
                        _ => unreachable!(),
                    };
                    let _ = writeln!(out, "  {reg} = fcmp {pred} double {lhs_val}, {rhs_val}");
                    return Ok((Type::Bool, reg));
                }
                if lhs_ty != Type::Int || rhs_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}` requires matching `int` or `float` operands, found `{}` and `{}`",
                            op.symbol(),
                            lhs_ty.name(),
                            rhs_ty.name()
                        ),
                        span,
                    ));
                }

                let reg = self.next_tmp();
                let pred = match op {
                    BinOp::Lt => "slt",
                    BinOp::Gt => "sgt",
                    BinOp::Le => "sle",
                    BinOp::Ge => "sge",
                    _ => unreachable!(),
                };
                let _ = writeln!(out, "  {reg} = icmp {pred} i64 {lhs_val}, {rhs_val}");
                Ok((Type::Bool, reg))
            }

            BinOp::And | BinOp::Or => unreachable!(),
        }
    }

    pub(super) fn gen_in_operator(
        &mut self,
        lhs_ty: &Type,
        lhs_val: &str,
        rhs_ty: &Type,
        rhs_val: &str,
        span: Span,
        out: &mut String,
    ) -> Result<String> {
        if *lhs_ty == Type::Str && *rhs_ty == Type::Str {
            self.used_str_find = true;
            let pos = self.next_tmp();
            let _ = writeln!(
                out,
                "  {pos} = call fastcc i64 @archx_str_find(%ArchxStr {rhs_val}, %ArchxStr {lhs_val})"
            );
            let ok = self.next_tmp();
            let _ = writeln!(out, "  {ok} = icmp sge i64 {pos}, 0");
            return Ok(ok);
        }
        if let Type::Array(elem_ty) = rhs_ty {
            if lhs_ty != elem_ty.as_ref() {
                return Err(Diagnostic::new(
                    format!(
                        "`in` element type `{}` does not match list element type `{}`",
                        lhs_ty.name(),
                        elem_ty.name()
                    ),
                    span,
                ));
            }
            let len_v = self.next_tmp();
            let _ = writeln!(out, "  {len_v} = extractvalue %ArchxVec {rhs_val}, 0");
            let data_p = self.next_tmp();
            let _ = writeln!(out, "  {data_p} = extractvalue %ArchxVec {rhs_val}, 2");

            let islot = self.next_slot("in.idx");
            let rslot = self.next_slot("in.res");
            let _ = writeln!(self.allocas, "  {islot} = alloca i64, align 8");
            let _ = writeln!(self.allocas, "  {rslot} = alloca i1, align 1");
            let _ = writeln!(out, "  store i64 0, ptr {islot}, align 8");
            let _ = writeln!(out, "  store i1 false, ptr {rslot}, align 1");

            let cond_lbl = self.fresh_label("in.cond");
            let body_lbl = self.fresh_label("in.body");
            let hit_lbl = self.fresh_label("in.hit");
            let step_lbl = self.fresh_label("in.step");
            let end_lbl = self.fresh_label("in.end");

            self.emit_br(&cond_lbl, out);
            self.start_block(&cond_lbl, out);
            let cur = self.next_tmp();
            let _ = writeln!(out, "  {cur} = load i64, ptr {islot}, align 8");
            let more = self.next_tmp();
            let _ = writeln!(out, "  {more} = icmp slt i64 {cur}, {len_v}");
            self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

            self.start_block(&body_lbl, out);
            let mem_ty = elem_mem_ir_type(elem_ty);
            let ep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {ep} = getelementptr inbounds {mem_ty}, ptr {data_p}, i64 {cur}"
            );
            let ev = self.emit_elem_load(elem_ty, &ep, out);
            let eq = self.emit_equality(lhs_ty, lhs_val, elem_ty, &ev, span, out)?;
            self.emit_cond_br(&eq, &hit_lbl, &step_lbl, out);

            self.start_block(&hit_lbl, out);
            let _ = writeln!(out, "  store i1 true, ptr {rslot}, align 1");
            self.emit_br(&end_lbl, out);

            self.start_block(&step_lbl, out);
            let nxt = self.next_tmp();
            let _ = writeln!(out, "  {nxt} = add nsw i64 {cur}, 1");
            let _ = writeln!(out, "  store i64 {nxt}, ptr {islot}, align 8");
            self.emit_br(&cond_lbl, out);

            self.start_block(&end_lbl, out);
            let found = self.next_tmp();
            let _ = writeln!(out, "  {found} = load i1, ptr {rslot}, align 1");
            return Ok(found);
        }
        Err(Diagnostic::new(
            format!(
                "`in` requires `str in str` or `elem in list[elem]`, found `{}` and `{}`",
                lhs_ty.name(),
                rhs_ty.name()
            ),
            span,
        ))
    }

    pub(super) fn emit_list_concat(
        &mut self,
        elem_ty: &Type,
        lhs_val: &str,
        rhs_val: &str,
        out: &mut String,
    ) -> String {
        self.used_vec_type = true;
        let len_a = self.next_tmp();
        let _ = writeln!(out, "  {len_a} = extractvalue %ArchxVec {lhs_val}, 0");
        let ptr_a = self.next_tmp();
        let _ = writeln!(out, "  {ptr_a} = extractvalue %ArchxVec {lhs_val}, 2");
        let len_b = self.next_tmp();
        let _ = writeln!(out, "  {len_b} = extractvalue %ArchxVec {rhs_val}, 0");
        let ptr_b = self.next_tmp();
        let _ = writeln!(out, "  {ptr_b} = extractvalue %ArchxVec {rhs_val}, 2");

        let total = self.next_tmp();
        let _ = writeln!(out, "  {total} = add i64 {len_a}, {len_b}");
        self.used_oom_fail = true;
        let bad = self.next_tmp();
        let _ = writeln!(out, "  {bad} = icmp ugt i64 {total}, {MAX_ARRAY_LEN}");
        let bad_lbl = self.fresh_label("lcat.oom");
        let ok_lbl = self.fresh_label("lcat.ok");
        self.emit_cond_br(&bad, &bad_lbl, &ok_lbl, out);
        self.start_block(&bad_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;
        self.start_block(&ok_lbl, out);

        let elem_sz = self.emit_elem_sizeof(elem_ty, out);
        let bytes = self.emit_elem_bytes_val_mul(&total, &elem_sz, out);
        let dst = self.emit_checked_malloc(&bytes, out);
        let mem_ty = elem_mem_ir_type(elem_ty);
        let needs_drop = self.type_needs_drop(elem_ty);

        for (src_ptr, src_len, dst_off) in [
            (ptr_a, len_a.clone(), "0".to_string()),
            (ptr_b, len_b, len_a),
        ] {
            let islot = self.next_slot("lcat.i");
            let _ = writeln!(self.allocas, "  {islot} = alloca i64, align 8");
            let _ = writeln!(out, "  store i64 0, ptr {islot}, align 8");
            let cl = self.fresh_label("lcat.cond");
            let bl = self.fresh_label("lcat.body");
            let el = self.fresh_label("lcat.end");
            self.emit_br(&cl, out);
            self.start_block(&cl, out);
            let ci = self.next_tmp();
            let _ = writeln!(out, "  {ci} = load i64, ptr {islot}, align 8");
            let mc = self.next_tmp();
            let _ = writeln!(out, "  {mc} = icmp slt i64 {ci}, {src_len}");
            self.emit_cond_br(&mc, &bl, &el, out);
            self.start_block(&bl, out);
            let sp = self.next_tmp();
            let _ = writeln!(
                out,
                "  {sp} = getelementptr inbounds {mem_ty}, ptr {src_ptr}, i64 {ci}"
            );
            let raw_v = self.emit_elem_load(elem_ty, &sp, out);
            let v = if needs_drop {
                self.emit_clone_value(elem_ty, &raw_v, out)
            } else {
                raw_v
            };
            let di = if dst_off == "0" {
                ci.clone()
            } else {
                let d = self.next_tmp();
                let _ = writeln!(out, "  {d} = add nuw nsw i64 {dst_off}, {ci}");
                d
            };
            let dp = self.next_tmp();
            let _ = writeln!(
                out,
                "  {dp} = getelementptr inbounds {mem_ty}, ptr {dst}, i64 {di}"
            );
            self.emit_elem_store(elem_ty, &v, &dp, out);
            let ni = self.next_tmp();
            let _ = writeln!(out, "  {ni} = add nuw nsw i64 {ci}, 1");
            let _ = writeln!(out, "  store i64 {ni}, ptr {islot}, align 8");
            self.emit_br(&cl, out);
            self.start_block(&el, out);
        }

        let vec = self.build_vec_val(&total, &total, &dst, out);
        let arr_ty = Type::Array(Box::new(elem_ty.clone()));
        self.stmt_temps.push(TempDrop {
            val: vec.clone(),
            ty: arr_ty,
        });
        vec
    }

    pub(super) fn emit_equality(
        &mut self,
        lhs_ty: &Type,
        lhs_val: &str,
        rhs_ty: &Type,
        rhs_val: &str,
        span: Span,
        out: &mut String,
    ) -> Result<String> {
        if lhs_ty != rhs_ty {
            return Err(Diagnostic::new(
                format!("cannot compare `{}` and `{}`", lhs_ty.name(), rhs_ty.name()),
                span,
            ));
        }
        match lhs_ty {
            Type::Int => {
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = icmp eq i64 {lhs_val}, {rhs_val}");
                Ok(reg)
            }
            Type::Float => {
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = fcmp oeq double {lhs_val}, {rhs_val}");
                Ok(reg)
            }
            Type::Bool => {
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = icmp eq i1 {lhs_val}, {rhs_val}");
                Ok(reg)
            }
            Type::Void => Ok("true".to_string()),
            Type::Str => {
                self.used_str_eq = true;
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call fastcc i1 @archx_str_eq(%ArchxStr {lhs_val}, %ArchxStr {rhs_val})"
                );
                Ok(reg)
            }
            Type::Struct(sname) => {
                let fields = self.structs[sname].clone();
                let mut acc: Option<String> = None;
                for (i, f) in fields.iter().enumerate() {
                    let lf = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {lf} = extractvalue %ArchxStruct_{sname} {lhs_val}, {i}"
                    );
                    let rf = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {rf} = extractvalue %ArchxStruct_{sname} {rhs_val}, {i}"
                    );
                    let feq = self.emit_equality(&f.ty, &lf, &f.ty, &rf, span, out)?;
                    acc = Some(match acc {
                        None => feq,
                        Some(prev) => {
                            let both = self.next_tmp();
                            let _ = writeln!(out, "  {both} = and i1 {prev}, {feq}");
                            both
                        }
                    });
                }
                Ok(acc.unwrap_or_else(|| "true".to_string()))
            }
            _ => Err(Diagnostic::new(
                format!("equality is not supported on `{}`", lhs_ty.name()),
                span,
            )),
        }
    }

    pub(super) fn emit_str_concat_call(&mut self, lhs_val: &str, rhs_val: &str, out: &mut String) -> String {
        self.used_str_concat = true;
        let reg_arg = if !self.region_stack.is_empty() {
            self.func_region_slot.clone().unwrap()
        } else {
            "null".to_string()
        };
        let res = self.next_tmp();
        let _ = writeln!(
            out,
            "  {res} = call fastcc %ArchxStr @archx_str_concat(%ArchxStr {lhs_val}, %ArchxStr {rhs_val}, ptr {reg_arg})"
        );
        self.stmt_temps.push(TempDrop {
            val: res.clone(),
            ty: Type::Str,
        });
        res
    }

    pub(super) fn emit_float_arith(
        &mut self,
        op: BinOp,
        lhs_val: &str,
        rhs_val: &str,
        out: &mut String,
    ) -> String {
        match op {
            BinOp::Add | BinOp::Sub | BinOp::Mul | BinOp::Div | BinOp::Mod => {
                let instr = match op {
                    BinOp::Add => "fadd",
                    BinOp::Sub => "fsub",
                    BinOp::Mul => "fmul",
                    BinOp::Div => "fdiv",
                    BinOp::Mod => "frem",
                    _ => unreachable!(),
                };
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = {instr} double {lhs_val}, {rhs_val}");
                reg
            }
            BinOp::FloorDiv => {
                self.used_floor_f64 = true;
                let q = self.next_tmp();
                let _ = writeln!(out, "  {q} = fdiv double {lhs_val}, {rhs_val}");
                let fl = self.next_tmp();
                let _ = writeln!(out, "  {fl} = call double @llvm.floor.f64(double {q})");
                fl
            }
            BinOp::Pow => {
                self.used_pow_f64 = true;
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call double @llvm.pow.f64(double {lhs_val}, double {rhs_val})"
                );
                r
            }
            _ => unreachable!(),
        }
    }

    pub(super) fn emit_int_arith(&mut self, op: BinOp, lhs_val: &str, rhs_val: &str, out: &mut String) -> String {
        if let (Ok(a), Ok(b)) = (lhs_val.parse::<i64>(), rhs_val.parse::<i64>()) {
            let folded = match op {
                BinOp::Add => Some(a.wrapping_add(b)),
                BinOp::Sub => Some(a.wrapping_sub(b)),
                BinOp::Mul => Some(a.wrapping_mul(b)),
                BinOp::Div if b != 0 => Some(a.wrapping_div(b)),
                BinOp::FloorDiv if b != 0 => {
                    let q = a.wrapping_div(b);
                    let r = a.wrapping_rem(b);
                    Some(if r != 0 && (a ^ b) < 0 {
                        q.wrapping_sub(1)
                    } else {
                        q
                    })
                }
                BinOp::Pow if (0..=62).contains(&b) => Some(ipow_wrapping(a, b as u64)),
                BinOp::Mod if b != 0 => Some(a.wrapping_rem(b)),
                _ => None,
            };
            if let Some(res) = folded {
                return res.to_string();
            }
        }

        if op == BinOp::Pow {
            self.used_neg_exp_fail = true;
            let neg = self.next_tmp();
            let _ = writeln!(out, "  {neg} = icmp slt i64 {rhs_val}, 0");
            let bad_lbl = self.fresh_label("pow.neg");
            let pre_lbl = self.fresh_label("pow.pre");
            self.emit_cond_br(&neg, &bad_lbl, &pre_lbl, out);

            self.start_block(&bad_lbl, out);
            let _ = writeln!(out, "  call void @archx_neg_exp_fail()");
            let _ = writeln!(out, "  unreachable");
            self.terminated = true;

            self.start_block(&pre_lbl, out);
            let acc_slot = self.next_slot("pow.acc");
            let base_slot = self.next_slot("pow.base");
            let exp_slot = self.next_slot("pow.exp");
            let _ = writeln!(self.allocas, "  {acc_slot} = alloca i64, align 8");
            let _ = writeln!(self.allocas, "  {base_slot} = alloca i64, align 8");
            let _ = writeln!(self.allocas, "  {exp_slot} = alloca i64, align 8");
            let _ = writeln!(out, "  store i64 1, ptr {acc_slot}, align 8");
            let _ = writeln!(out, "  store i64 {lhs_val}, ptr {base_slot}, align 8");
            let _ = writeln!(out, "  store i64 {rhs_val}, ptr {exp_slot}, align 8");

            let cond_lbl = self.fresh_label("pow.cond");
            let body_lbl = self.fresh_label("pow.body");
            let done_lbl = self.fresh_label("pow.done");
            self.emit_br(&cond_lbl, out);

            self.start_block(&cond_lbl, out);
            let e = self.next_tmp();
            let _ = writeln!(out, "  {e} = load i64, ptr {exp_slot}, align 8");
            let gt = self.next_tmp();
            let _ = writeln!(out, "  {gt} = icmp sgt i64 {e}, 0");
            self.emit_cond_br(&gt, &body_lbl, &done_lbl, out);

            self.start_block(&body_lbl, out);
            let b = self.next_tmp();
            let _ = writeln!(out, "  {b} = load i64, ptr {base_slot}, align 8");
            let acc = self.next_tmp();
            let _ = writeln!(out, "  {acc} = load i64, ptr {acc_slot}, align 8");
            let bit = self.next_tmp();
            let _ = writeln!(out, "  {bit} = and i64 {e}, 1");
            let odd = self.next_tmp();
            let _ = writeln!(out, "  {odd} = icmp ne i64 {bit}, 0");
            let prod = self.next_tmp();
            let _ = writeln!(out, "  {prod} = mul i64 {acc}, {b}");
            let next_acc = self.next_tmp();
            let _ = writeln!(out, "  {next_acc} = select i1 {odd}, i64 {prod}, i64 {acc}");
            let _ = writeln!(out, "  store i64 {next_acc}, ptr {acc_slot}, align 8");
            let b2 = self.next_tmp();
            let _ = writeln!(out, "  {b2} = mul i64 {b}, {b}");
            let _ = writeln!(out, "  store i64 {b2}, ptr {base_slot}, align 8");
            let e2 = self.next_tmp();
            let _ = writeln!(out, "  {e2} = lshr i64 {e}, 1");
            let _ = writeln!(out, "  store i64 {e2}, ptr {exp_slot}, align 8");
            self.emit_br(&cond_lbl, out);

            self.start_block(&done_lbl, out);
            let res = self.next_tmp();
            let _ = writeln!(out, "  {res} = load i64, ptr {acc_slot}, align 8");
            return res;
        }

        if op == BinOp::FloorDiv {
            self.used_div_zero_fail = true;
            let dz = self.next_tmp();
            let _ = writeln!(out, "  {dz} = icmp eq i64 {rhs_val}, 0");
            let dz_lbl = self.fresh_label("fdiv.zero");
            let ok_lbl = self.fresh_label("fdiv.ok");
            self.emit_cond_br(&dz, &dz_lbl, &ok_lbl, out);

            self.start_block(&dz_lbl, out);
            let _ = writeln!(out, "  call void @archx_div_zero_fail()");
            let _ = writeln!(out, "  unreachable");
            self.terminated = true;

            self.start_block(&ok_lbl, out);
            let is_min = self.next_tmp();
            let _ = writeln!(out, "  {is_min} = icmp eq i64 {lhs_val}, {}", i64::MIN);
            let is_neg1 = self.next_tmp();
            let _ = writeln!(out, "  {is_neg1} = icmp eq i64 {rhs_val}, -1");
            let ovf = self.next_tmp();
            let _ = writeln!(out, "  {ovf} = and i1 {is_min}, {is_neg1}");
            let safe_rhs = self.next_tmp();
            let _ = writeln!(out, "  {safe_rhs} = select i1 {ovf}, i64 1, i64 {rhs_val}");
            let raw_q = self.next_tmp();
            let _ = writeln!(out, "  {raw_q} = sdiv i64 {lhs_val}, {safe_rhs}");
            let neg_lhs = self.next_tmp();
            let _ = writeln!(out, "  {neg_lhs} = sub i64 0, {lhs_val}");
            let q = self.next_tmp();
            let _ = writeln!(out, "  {q} = select i1 {ovf}, i64 {neg_lhs}, i64 {raw_q}");
            let rem = self.next_tmp();
            let _ = writeln!(out, "  {rem} = srem i64 {lhs_val}, {safe_rhs}");
            let has_rem = self.next_tmp();
            let _ = writeln!(out, "  {has_rem} = icmp ne i64 {rem}, 0");
            let xored = self.next_tmp();
            let _ = writeln!(out, "  {xored} = xor i64 {lhs_val}, {rhs_val}");
            let diff_sign = self.next_tmp();
            let _ = writeln!(out, "  {diff_sign} = icmp slt i64 {xored}, 0");
            let need_adj = self.next_tmp();
            let _ = writeln!(out, "  {need_adj} = and i1 {has_rem}, {diff_sign}");
            let adj = self.next_tmp();
            let _ = writeln!(out, "  {adj} = zext i1 {need_adj} to i64");
            let res = self.next_tmp();
            let _ = writeln!(out, "  {res} = sub i64 {q}, {adj}");
            return res;
        }

        if matches!(op, BinOp::Div | BinOp::Mod) {
            let instr = if op == BinOp::Div { "sdiv" } else { "srem" };
            if let Ok(b) = rhs_val.parse::<i64>() {
                if b == 0 {
                    self.used_div_zero_fail = true;
                    let ok_lbl = self.fresh_label("div.after");
                    let _ = writeln!(out, "  call void @archx_div_zero_fail()");
                    let _ = writeln!(out, "  unreachable");
                    self.terminated = true;
                    self.start_block(&ok_lbl, out);
                    return "0".to_string();
                }
                if b == -1 {
                    if op == BinOp::Mod {
                        return "0".to_string();
                    }
                    let neg = self.next_tmp();
                    let _ = writeln!(out, "  {neg} = sub i64 0, {lhs_val}");
                    return neg;
                }
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = {instr} i64 {lhs_val}, {rhs_val}");
                return reg;
            }

            self.used_div_zero_fail = true;
            let dz = self.next_tmp();
            let _ = writeln!(out, "  {dz} = icmp eq i64 {rhs_val}, 0");
            let dz_lbl = self.fresh_label("div.zero");
            let ok_lbl = self.fresh_label("div.ok");
            self.emit_cond_br(&dz, &dz_lbl, &ok_lbl, out);

            self.start_block(&dz_lbl, out);
            let _ = writeln!(out, "  call void @archx_div_zero_fail()");
            let _ = writeln!(out, "  unreachable");
            self.terminated = true;

            self.start_block(&ok_lbl, out);
            let is_min = self.next_tmp();
            let _ = writeln!(out, "  {is_min} = icmp eq i64 {lhs_val}, {}", i64::MIN);
            let is_neg1 = self.next_tmp();
            let _ = writeln!(out, "  {is_neg1} = icmp eq i64 {rhs_val}, -1");
            let ovf = self.next_tmp();
            let _ = writeln!(out, "  {ovf} = and i1 {is_min}, {is_neg1}");
            let safe_rhs = self.next_tmp();
            let _ = writeln!(out, "  {safe_rhs} = select i1 {ovf}, i64 1, i64 {rhs_val}");
            let reg = self.next_tmp();
            let _ = writeln!(out, "  {reg} = {instr} i64 {lhs_val}, {safe_rhs}");
            return reg;
        }

        let reg = self.next_tmp();
        let instr = match op {
            BinOp::Add => "add",
            BinOp::Sub => "sub",
            BinOp::Mul => "mul",
            _ => unreachable!(),
        };
        let _ = writeln!(out, "  {reg} = {instr} i64 {lhs_val}, {rhs_val}");
        reg
    }

    pub(super) fn gen_short_circuit(
        &mut self,
        op: BinOp,
        lhs: &Expr,
        rhs: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let mark = self.stmt_temps.len();
        let (lhs_ty, lhs_val) = self.eval_expr(lhs, out)?;
        if lhs_ty != Type::Bool {
            return Err(Diagnostic::new(
                format!(
                    "operator `{}` requires `bool` operands, found `{}`",
                    op.symbol(),
                    lhs_ty.name()
                ),
                span,
            ));
        }
        self.flush_stmt_temps_from(mark, out);

        let slot = self.next_slot("bool.result");
        let _ = writeln!(self.allocas, "  {slot} = alloca i1, align 1");

        let initial = if op == BinOp::And { "false" } else { "true" };
        let _ = writeln!(out, "  store i1 {initial}, ptr {slot}, align 1");

        let rhs_label = self.fresh_label("bool.rhs");
        let merge_label = self.fresh_label("bool.merge");

        if op == BinOp::And {
            self.emit_cond_br(&lhs_val, &rhs_label, &merge_label, out);
        } else {
            self.emit_cond_br(&lhs_val, &merge_label, &rhs_label, out);
        }

        self.start_block(&rhs_label, out);
        let mark_rhs = self.stmt_temps.len();
        let (rhs_ty, rhs_val) = self.eval_expr(rhs, out)?;
        if rhs_ty != Type::Bool {
            return Err(Diagnostic::new(
                format!(
                    "operator `{}` requires `bool` operands, found `{}`",
                    op.symbol(),
                    rhs_ty.name()
                ),
                rhs.span,
            ));
        }
        self.flush_stmt_temps_from(mark_rhs, out);
        let _ = writeln!(out, "  store i1 {rhs_val}, ptr {slot}, align 1");
        self.emit_br(&merge_label, out);

        self.start_block(&merge_label, out);
        let result = self.next_tmp();
        let _ = writeln!(out, "  {result} = load i1, ptr {slot}, align 1");
        Ok((Type::Bool, result))
    }

}

pub(super) fn ipow_wrapping(mut base: i64, mut exp: u64) -> i64 {
    let mut acc = 1i64;
    while exp > 0 {
        if exp & 1 != 0 {
            acc = acc.wrapping_mul(base);
        }
        base = base.wrapping_mul(base);
        exp >>= 1;
    }
    acc
}

pub(super) fn pack_sso_str_words(bytes: &[u8]) -> (i64, i64) {
    debug_assert!(bytes.len() <= 12);
    let mut buf = [0u8; 16];
    let len32 = (bytes.len() as u32).to_le_bytes();
    buf[0..4].copy_from_slice(&len32);
    buf[4..4 + bytes.len()].copy_from_slice(bytes);
    let w0 = i64::from_le_bytes(buf[0..8].try_into().unwrap());
    let w1 = i64::from_le_bytes(buf[8..16].try_into().unwrap());
    (w0, w1)
}

pub(super) fn pack_long_str_w0(bytes: &[u8]) -> i64 {
    debug_assert!(bytes.len() > 12);
    let mut buf = [0u8; 8];
    let len32 = (bytes.len() as u32).to_le_bytes();
    buf[0..4].copy_from_slice(&len32);
    buf[4..8].copy_from_slice(&bytes[0..4]);
    i64::from_le_bytes(buf)
}

