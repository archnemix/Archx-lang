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

            ExprKind::Bool(value) => Ok((Type::Bool, value.to_string())),

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
                        if ty != Type::Int {
                            return Err(Diagnostic::new(
                                "unary `-` requires an `int` operand",
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

            BinOp::Add | BinOp::Sub | BinOp::Mul | BinOp::Div | BinOp::Mod => {
                if lhs_ty != Type::Int || rhs_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}` requires `int` operands, found `{}` and `{}`",
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
                if lhs_ty != Type::Int || rhs_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}` requires `int` operands, found `{}` and `{}`",
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
            Type::Bool => {
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = icmp eq i1 {lhs_val}, {rhs_val}");
                Ok(reg)
            }
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

    pub(super) fn emit_int_arith(&mut self, op: BinOp, lhs_val: &str, rhs_val: &str, out: &mut String) -> String {
        if let (Ok(a), Ok(b)) = (lhs_val.parse::<i64>(), rhs_val.parse::<i64>()) {
            let folded = match op {
                BinOp::Add => Some(a.wrapping_add(b)),
                BinOp::Sub => Some(a.wrapping_sub(b)),
                BinOp::Mul => Some(a.wrapping_mul(b)),
                BinOp::Div if b != 0 => Some(a.wrapping_div(b)),
                BinOp::Mod if b != 0 => Some(a.wrapping_rem(b)),
                _ => None,
            };
            if let Some(res) = folded {
                return res.to_string();
            }
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

