//! Expression lowering: literals, variables, indexing, struct fields, checked integer arithmetic,
//! short-circuit booleans, and 16-byte German/Umbra prefix-SSO string operations.

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

impl Codegen {
    // ---------------- Expressions --------------------------------------------

    pub(super) fn eval_str_lit(&mut self, value: &str) -> (Type, String) {
        self.used_str_type = true;
        let bytes = value.as_bytes();
        let (w0, w1) = pack_sso_str_words(bytes);
        (Type::Str, format!("{{ i64 {w0}, i64 {w1} }}"))
    }

    pub(super) fn eval_array_lit(
        &mut self,
        elems: &[Expr],
        expected: Option<&Type>,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.used_vec_type = true;
        if elems.is_empty() {
            if expected == Some(&Type::Any) {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let vec = self.build_vec_val("0", "0", "null", out);
                let cell = self.emit_wrap_any_vec_cell(&vec, out);
                self.stmt_temps.push(TempDrop {
                    val: cell.clone(),
                    ty: Type::Any,
                });
                return Ok((Type::Any, cell));
            }
            let elem_ty = match expected {
                Some(Type::Array(inner)) => (**inner).clone(),
                _ => Type::Any,
            };
            self.mark_runtime_type(&elem_ty);
            let vec = self.build_vec_val("0", "0", "null", out);
            return Ok((Type::Array(Box::new(elem_ty)), vec));
        }

        // Strict static expected `[T]` where `T != any`:
        if let Some(Type::Array(exp_inner)) = expected {
            if **exp_inner != Type::Any {
                let target_t = (**exp_inner).clone();
                let elem_drops = self.type_needs_drop(&target_t);
                let mut vals = Vec::with_capacity(elems.len());
                for item in elems {
                    let (ty, raw_v) = self.eval_expr_typed(item, Some(&target_t), out)?;
                    let coerced = if ty == target_t {
                        raw_v
                    } else if ty == Type::Any {
                        self.emit_unbox_any(&target_t, &raw_v, item.span, out)?
                    } else {
                        return Err(Diagnostic::new(
                            format!(
                                "array element type mismatch: expected `{}`, found `{}`",
                                target_t.name(),
                                ty.name()
                            ),
                            item.span,
                        ));
                    };
                    let owned_v = if elem_drops {
                        if self.claim_stmt_temp(&coerced) {
                            coerced
                        } else {
                            self.emit_clone_value(&target_t, &coerced, out)
                        }
                    } else {
                        coerced
                    };
                    vals.push(owned_v);
                }
                return Ok(self.finish_array_lit_from_vals(target_t, vals, out));
            }
        }

        // Adaptive evaluation: Tier-1 homogeneous `[T]` when all elements match,
        // automatic fallback to Tier-2 `list[any]` on mixed types (`["Archx", 18, "legal"]`) or `expected == any`!
        let mut raw_items = Vec::with_capacity(elems.len());
        for item in elems {
            if matches!(&item.kind, ExprKind::NoneLit) {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                raw_items.push((Type::Any, "zeroinitializer".to_string(), item.span));
            } else {
                let hint = if expected == Some(&Type::Any) {
                    Some(&Type::Any)
                } else {
                    None
                };
                let (ty, val) = self.eval_expr_typed(item, hint, out)?;
                if ty == Type::Void {
                    return Err(Diagnostic::new(
                        "array elements cannot have type `void`",
                        item.span,
                    ));
                }
                raw_items.push((ty, val, item.span));
            }
        }

        let force_any = expected == Some(&Type::Any)
            || matches!(expected, Some(Type::Array(inner)) if **inner == Type::Any);
        let first_t = &raw_items[0].0;
        let all_same = !force_any
            && *first_t != Type::Any
            && raw_items.iter().all(|(t, _, _)| t == first_t);

        if all_same {
            let elem_t = first_t.clone();
            let elem_drops = self.type_needs_drop(&elem_t);
            let mut vals = Vec::with_capacity(raw_items.len());
            for (_, v, _) in raw_items {
                let owned = if elem_drops {
                    if self.claim_stmt_temp(&v) {
                        v
                    } else {
                        self.emit_clone_value(&elem_t, &v, out)
                    }
                } else {
                    v
                };
                vals.push(owned);
            }
            return Ok(self.finish_array_lit_from_vals(elem_t, vals, out));
        }

        let _ = span;
        self.mark_runtime_type(&Type::Any);
        self.used_any_rt = true;
        let mut any_vals = Vec::with_capacity(raw_items.len());
        for (ty, v, ispan) in raw_items {
            any_vals.push(self.emit_box_any_owned(&ty, &v, ispan, out)?);
        }
        let (_, vec) = self.finish_array_lit_from_vals(Type::Any, any_vals, out);
        if expected == Some(&Type::Any) {
            let _ = self.claim_stmt_temp(&vec);
            let cell = self.emit_wrap_any_vec_cell(&vec, out);
            self.stmt_temps.push(TempDrop {
                val: cell.clone(),
                ty: Type::Any,
            });
            return Ok((Type::Any, cell));
        }
        Ok((Type::Array(Box::new(Type::Any)), vec))
    }

    fn finish_array_lit_from_vals(
        &mut self,
        elem_ty: Type,
        vals: Vec<String>,
        out: &mut String,
    ) -> (Type, String) {
        self.mark_runtime_type(&elem_ty);
        let elem_drops = self.type_needs_drop(&elem_ty);
        let count = vals.len() as i64;
        let count_str = count.to_string();
        let bytes = self.emit_type_bytes_const_mul(&elem_ty, count, out);

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

        let mem_ty = elem_mem_ir_type(&elem_ty);
        for (i, val) in vals.iter().enumerate() {
            let ep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {ep} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {i}"
            );
            self.emit_elem_store(&elem_ty, val, &ep, out);
        }

        let vec = self.build_vec_val(&count_str, &cap_str, &data_ptr, out);
        let arr_ty = Type::Array(Box::new(elem_ty));
        self.stmt_temps.push(TempDrop {
            val: vec.clone(),
            ty: arr_ty.clone(),
        });
        (arr_ty, vec)
    }

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
        let (ty, val) = res?;
        if let Some(Type::Optional(inner)) = expected {
            if ty == Type::Void && matches!(&expr.kind, ExprKind::NoneLit) {
                return Ok((
                    Type::Optional(inner.clone()),
                    "zeroinitializer".to_string(),
                ));
            }
            if ty == **inner {
                return Ok(self.wrap_optional_some(inner, &val, out));
            }
        }
        Ok((ty, val))
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

            ExprKind::ListComp { elt, clauses } => {
                self.eval_list_comp(elt, clauses, expected, expr.span, out)
            }

            ExprKind::SetComp { elt, clauses } => {
                self.eval_set_comp(elt, clauses, expected, expr.span, out)
            }

            ExprKind::DictComp { key, val, clauses } => {
                self.eval_dict_comp(key, val, clauses, expected, expr.span, out)
            }

            ExprKind::GenExpr { elt, clauses } => {
                self.eval_gen_expr(elt, clauses, expected, expr.span, out)
            }

            ExprKind::Lambda { .. } => Err(Diagnostic::new(
                "a `lambda` must be bound to a name (`f = lambda x: ...`) or used as \
                 `key=lambda ...`",
                expr.span,
            )),

            ExprKind::MethodCallKw {
                target,
                method,
                pos_args,
                kw_args,
            } => self.gen_method_call_kw(target, method, pos_args, kw_args, expr.span, out),

            ExprKind::CallGeneric {
                name,
                pos_args,
                kw_args,
                ..
            } => self.gen_call_kw(name, pos_args, kw_args, expr.span, out),

            ExprKind::CallExpr { .. } => Err(Diagnostic::new(
                "only named closures (`f = lambda ...` then `f(x)`) can be called",
                expr.span,
            )),

            ExprKind::DictLit(pairs) => self.eval_dict_lit(pairs, expected, expr.span, out),

            ExprKind::SetLit(elems) => self.eval_set_lit(elems, expected, expr.span, out),

            ExprKind::TupleLit(elems) => self.eval_tuple_lit(elems, expected, expr.span, out),

            ExprKind::Slice {
                target,
                start,
                stop,
                step,
            } => self.eval_slice_expr(
                target,
                start.as_deref(),
                stop.as_deref(),
                step.as_deref(),
                expr.span,
                out,
            ),

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
                // A `global` name resolves to a module-level constant and compiles to the same
                // literal immediate the declaration produced.
                let entry = match self.lookup_var(name).cloned() {
                    Some(e) => e,
                    // A module-level constant is visible from every function without a
                    // declaration, exactly like Python's module scope (only *assignment* needs
                    // `global`).
                    None => match self.global_slots.get(name).cloned() {
                        Some((ty, sym)) => {
                            let reg = self.next_tmp();
                            let _ = writeln!(
                                out,
                                "  {reg} = load {}, ptr {sym}, align {}",
                                ir_type(&ty),
                                ir_align(&ty)
                            );
                            VarEntry {
                                ty,
                                storage: VarStorage::Imm(reg),
                                is_param: false,
                                region_depth: 0,
                            }
                        }
                        None => match self.consts.get(name).cloned() {
                            Some((ty, value)) => {
                                let (_, val) = self.eval_expr(&value, out)?;
                                VarEntry {
                                    ty,
                                    storage: VarStorage::Imm(val),
                                    is_param: false,
                                    region_depth: 0,
                                }
                            }
                            None => {
                                return Err(Diagnostic::new(
                                    format!("undefined variable `{name}`"),
                                    expr.span,
                                ));
                            }
                        },
                    },
                };
                let (raw_ty, raw_val) = match entry.storage {
                    VarStorage::Imm(val) => (entry.ty, val),
                    VarStorage::Slot(ptr) => {
                        let reg = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {reg} = load {}, ptr {ptr}, align {}",
                            ir_type(&entry.ty),
                            ir_align(&entry.ty)
                        );
                        (entry.ty, reg)
                    }
                    VarStorage::Soa { .. } => {
                        return Err(Diagnostic::new(
                            format!(
                                "array `{name}` uses local SoA layout and cannot be copied as a whole"
                            ),
                            expr.span,
                        ));
                    }
                };
                if let Type::Optional(inner) = &raw_ty {
                    if self.is_narrowed_optional(name) {
                        let opt_ir = ir_type(&raw_ty);
                        let unwrapped = self.next_tmp();
                        let _ = writeln!(out, "  {unwrapped} = extractvalue {opt_ir} {raw_val}, 1");
                        return Ok(((**inner).clone(), unwrapped));
                    }
                }
                Ok((raw_ty, raw_val))
            }

            ExprKind::Field { target, field } => {
                if let ExprKind::Var(ename) = &target.kind {
                    if self.lookup_var(ename).is_none() && self.enums.contains_key(ename) {
                        return self.gen_enum_unit(ename, field, expr.span, out);
                    }
                }
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

            ExprKind::ArrayLit(elems) => self.eval_array_lit(elems, expected, expr.span, out),

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
                if let Type::Tuple(items) = arr_ty {
                    return self.eval_tuple_index(&items, &vec_val, index, expr.span, out);
                }
                if let Type::Dict(k_ty, v_ty) = arr_ty {
                    return self.eval_dict_index(&k_ty, &v_ty, &vec_val, index, out);
                }
                if arr_ty == Type::Any {
                    self.mark_runtime_type(&Type::Any);
                    self.used_any_rt = true;
                    let idx_any = self.eval_expr_as_any(index, out)?;
                    let res = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {res} = call fastcc %ArchxAny @archx_any_get_idx(%ArchxAny {vec_val}, %ArchxAny {idx_any})"
                    );
                    self.stmt_temps.push(TempDrop {
                        val: res.clone(),
                        ty: Type::Any,
                    });
                    return Ok((Type::Any, res));
                }
                if arr_ty == Type::Str {
                    let (idx_ty, idx_val) = self.eval_expr(index, out)?;
                    let idx_val = if idx_ty == Type::Any {
                        self.emit_unbox_any(&Type::Int, &idx_val, index.span, out)?
                    } else if idx_ty == Type::Int {
                        idx_val
                    } else {
                        return Err(Diagnostic::new(
                            format!("string index must be `int`, found `{}`", idx_ty.name()),
                            index.span,
                        ));
                    };
                    self.used_str_byte_at = true;
                    let eff_idx = if analysis::eval_const_int(index).map_or(false, |c| c < 0) {
                        self.used_bounds_fail = true;
                        let w0 = self.next_tmp();
                        let _ = writeln!(out, "  {w0} = extractvalue %ArchxStr {vec_val}, 0");
                        let slen = self.next_tmp();
                        let _ = writeln!(out, "  {slen} = and i64 {w0}, 4294967295");
                        let adj = self.next_tmp();
                        let _ = writeln!(out, "  {adj} = add i64 {slen}, {idx_val}");
                        let oob = self.next_tmp();
                        let _ = writeln!(out, "  {oob} = icmp uge i64 {adj}, {slen}");
                        let oob_lbl = self.fresh_label("sidx.oob");
                        let ok_lbl = self.fresh_label("sidx.ok");
                        self.emit_cond_br(&oob, &oob_lbl, &ok_lbl, out);
                        self.start_block(&oob_lbl, out);
                        let _ = writeln!(out, "  call void @archx_bounds_fail(i64 {idx_val}, i64 {slen})");
                        let _ = writeln!(out, "  unreachable");
                        self.start_block(&ok_lbl, out);
                        adj
                    } else {
                        idx_val
                    };
                    let ch = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {ch} = call fastcc %ArchxStr @archx_str_byte_at(%ArchxStr {vec_val}, i64 {eff_idx})"
                    );
                    return Ok((Type::Str, ch));
                }
                let Type::Array(elem_ty) = arr_ty else {
                    return Err(Diagnostic::new(
                        format!("cannot index into value of type `{}`", arr_ty.name()),
                        target.span,
                    ));
                };
                let (idx_ty, raw_idx_val) = self.eval_expr(index, out)?;
                let idx_val = if idx_ty == Type::Any {
                    self.emit_unbox_any(&Type::Int, &raw_idx_val, index.span, out)?
                } else if idx_ty == Type::Int {
                    raw_idx_val
                } else {
                    return Err(Diagnostic::new(
                        format!("array index must be `int`, found `{}`", idx_ty.name()),
                        index.span,
                    ));
                };

                let eff_idx = if *elem_ty == Type::Any {
                    self.used_bounds_fail = true;
                    let len = self.next_tmp();
                    let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec_val}, 0");
                    let neg = self.next_tmp();
                    let _ = writeln!(out, "  {neg} = icmp slt i64 {idx_val}, 0");
                    let adj = self.next_tmp();
                    let _ = writeln!(out, "  {adj} = add i64 {idx_val}, {len}");
                    let eff = self.next_tmp();
                    let _ = writeln!(out, "  {eff} = select i1 {neg}, i64 {adj}, i64 {idx_val}");
                    let oob = self.next_tmp();
                    let _ = writeln!(out, "  {oob} = icmp uge i64 {eff}, {len}");
                    let oob_lbl = self.fresh_label("aidx.oob");
                    let ok_lbl = self.fresh_label("aidx.ok");
                    self.emit_cond_br(&oob, &oob_lbl, &ok_lbl, out);
                    self.start_block(&oob_lbl, out);
                    let _ = writeln!(out, "  call void @archx_bounds_fail(i64 {idx_val}, i64 {len})");
                    let _ = writeln!(out, "  unreachable");
                    self.start_block(&ok_lbl, out);
                    eff
                } else if analysis::eval_const_int(index).map_or(false, |c| c < 0) {
                    self.used_bounds_fail = true;
                    let len = self.next_tmp();
                    let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec_val}, 0");
                    let eff = self.next_tmp();
                    let _ = writeln!(out, "  {eff} = add i64 {len}, {idx_val}");
                    let oob = self.next_tmp();
                    let _ = writeln!(out, "  {oob} = icmp uge i64 {eff}, {len}");
                    let oob_lbl = self.fresh_label("nidx.oob");
                    let ok_lbl = self.fresh_label("nidx.ok");
                    self.emit_cond_br(&oob, &oob_lbl, &ok_lbl, out);
                    self.start_block(&oob_lbl, out);
                    let _ = writeln!(out, "  call void @archx_bounds_fail(i64 {idx_val}, i64 {len})");
                    let _ = writeln!(out, "  unreachable");
                    self.start_block(&ok_lbl, out);
                    eff
                } else {
                    self.emit_bounds_check_if_needed(target, index, &vec_val, &idx_val, out)?;
                    idx_val
                };

                let data_ptr = self.next_tmp();
                let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {vec_val}, 2");
                let elem_ptr = self.next_tmp();
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let _ = writeln!(
                    out,
                    "  {elem_ptr} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {eff_idx}"
                );
                let loaded = self.emit_elem_load(&elem_ty, &elem_ptr, out);
                let safe_loaded = if self.type_needs_drop(&elem_ty)
                    && (*elem_ty == Type::Any
                        || self.stmt_temps.iter().any(|t| t.val == vec_val))
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
                        if ty == Type::Any {
                            self.mark_runtime_type(&Type::Any);
                            self.used_any_rt = true;
                            let reg = self.next_tmp();
                            let _ = writeln!(
                                out,
                                "  {reg} = call fastcc %ArchxAny @archx_any_neg(%ArchxAny {val})"
                            );
                            self.stmt_temps.push(TempDrop {
                                val: reg.clone(),
                                ty: Type::Any,
                            });
                            return Ok((Type::Any, reg));
                        }
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
                    UnOp::BitNot => {
                        if ty != Type::Int {
                            return Err(Diagnostic::new(
                                "unary `~` requires an `int` operand",
                                expr.span,
                            ));
                        }
                        let reg = self.next_tmp();
                        let _ = writeln!(out, "  {reg} = xor i64 {val}, -1");
                        Ok((Type::Int, reg))
                    }
                    UnOp::Not => {
                        if ty == Type::Any {
                            self.mark_runtime_type(&Type::Any);
                            self.used_any_rt = true;
                            let tv = self.next_tmp();
                            let _ = writeln!(
                                out,
                                "  {tv} = call fastcc i1 @archx_any_truthy(%ArchxAny {val})"
                            );
                            let reg = self.next_tmp();
                            let _ = writeln!(out, "  {reg} = xor i1 {tv}, true");
                            return Ok((Type::Bool, reg));
                        }
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

            // `a < b < c`: evaluate `b` once, and short-circuit on the first false comparison.
            // The last entry of the vector is `(last_operand, placeholder_op)`.
            ExprKind::CompareChain(operands) => {
                self.gen_compare_chain(operands, expr.span, out)
            }

            ExprKind::PercentFormat { template, args } => {
                self.gen_percent_format(template, args, expr.span, out)
            }

            ExprKind::Call { name, args } => {
                if args.is_empty()
                    && self.lookup_var(name).is_none()
                    && !self.sigs.contains_key(name)
                {
                    match name.as_str() {
                        "set" => return self.eval_set_lit(&[], expected, expr.span, out),
                        "dict" => return self.eval_dict_lit(&[], expected, expr.span, out),
                        "list" => return self.eval_array_lit(&[], expected, expr.span, out),
                        "tuple" => return self.eval_tuple_lit(&[], expected, expr.span, out),
                        _ => {}
                    }
                }
                self.gen_call(name, args, expr.span, out)
            }
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
        let narrowing = self.detect_optional_narrowing(cond);
        let mark = self.stmt_temps.len();
        let cond_val = self.eval_cond_bool(cond, "conditional expression", out)?;
        self.flush_stmt_temps_from(mark, out);

        let then_lbl = self.fresh_label("ifexpr.then");
        let else_lbl = self.fresh_label("ifexpr.else");
        let merge_lbl = self.fresh_label("ifexpr.merge");

        // Promote `x if cond else None` / `None if cond else x` to stack `Type::Optional(T)`:
        let promote_to_opt = expected.is_none()
            && (matches!(&then_expr.kind, ExprKind::NoneLit)
                ^ matches!(&else_expr.kind, ExprKind::NoneLit));

        self.emit_cond_br(&cond_val, &then_lbl, &else_lbl, out);

        if promote_to_opt && matches!(&then_expr.kind, ExprKind::NoneLit) {
            self.start_block(&else_lbl, out);
            let mark_e = self.stmt_temps.len();
            let (else_ty, raw_else) = self.eval_expr(else_expr, out)?;
            if else_ty == Type::Void {
                return Err(Diagnostic::new(
                    "conditional expression branches must produce a value",
                    else_expr.span,
                ));
            }
            let res_ty = match &else_ty {
                Type::Optional(_) | Type::Any => else_ty.clone(),
                other => Type::Optional(Box::new(other.clone())),
            };
            let needs_drop = self.type_needs_drop(&res_ty);
            let else_wrapped = if res_ty == else_ty {
                raw_else
            } else {
                self.wrap_optional_some(&else_ty, &raw_else, out).1
            };
            let else_owned = if needs_drop {
                if self.claim_stmt_temp(&else_wrapped) {
                    else_wrapped
                } else {
                    self.emit_clone_value(&res_ty, &else_wrapped, out)
                }
            } else {
                else_wrapped
            };
            self.flush_stmt_temps_from(mark_e, out);
            let slot = self.next_slot("ifexpr.res");
            let ty_ir = ir_type(&res_ty);
            let align = ir_align(&res_ty);
            let _ = writeln!(self.allocas, "  {slot} = alloca {ty_ir}, align {align}");
            let _ = writeln!(out, "  store {ty_ir} {else_owned}, ptr {slot}, align {align}");
            self.emit_br(&merge_lbl, out);

            self.start_block(&then_lbl, out);
            let _ = writeln!(out, "  store {ty_ir} zeroinitializer, ptr {slot}, align {align}");
            self.emit_br(&merge_lbl, out);

            self.start_block(&merge_lbl, out);
            let res = self.next_tmp();
            let _ = writeln!(out, "  {res} = load {ty_ir}, ptr {slot}, align {align}");
            if needs_drop {
                self.stmt_temps.push(TempDrop {
                    val: res.clone(),
                    ty: res_ty.clone(),
                });
            }
            return Ok((res_ty, res));
        }

        self.start_block(&then_lbl, out);
        self.push_scope();
        if let Some((ref nvar, NarrowingKind::SomeInThen)) = narrowing {
            self.scopes
                .last_mut()
                .unwrap()
                .narrowed_optionals
                .insert(nvar.clone());
        }
        let mark_t = self.stmt_temps.len();
        let res_then = self.eval_expr_typed(then_expr, expected, out);
        self.pop_scope_with_drops(out);
        let (raw_then_ty, mut raw_then) = res_then?;
        if raw_then_ty == Type::Void {
            return Err(Diagnostic::new(
                "conditional expression branches must produce a value",
                then_expr.span,
            ));
        }
        let then_ty = if promote_to_opt
            && matches!(&else_expr.kind, ExprKind::NoneLit)
            && !matches!(&raw_then_ty, Type::Optional(_) | Type::Any)
        {
            let (oty, oval) = self.wrap_optional_some(&raw_then_ty, &raw_then, out);
            raw_then = oval;
            oty
        } else {
            raw_then_ty
        };
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
        self.push_scope();
        if let Some((ref nvar, NarrowingKind::NoneInThen)) = narrowing {
            self.scopes
                .last_mut()
                .unwrap()
                .narrowed_optionals
                .insert(nvar.clone());
        }
        let mark_e = self.stmt_temps.len();
        let res_else = self.eval_expr_typed(else_expr, Some(&then_ty), out);
        self.pop_scope_with_drops(out);
        let (else_ty, raw_else) = res_else?;
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

    /// `"%d items" % n` / `"%s=%d" % (name, n)` — Python's printf-style formatting.
    ///
    /// The template must be a literal, so each conversion lowers to the same
    /// `emit_value_to_str_spec` path an f-string uses. Supported: `%s %d %i %f %F %e %E %g %G
    /// %x %X %o %b %%`, with an optional `-`/`0` flag, width and `.precision`.
    fn gen_percent_format(
        &mut self,
        template: &str,
        args: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        // Either a single value or a tuple of values, one per conversion.
        let arg_exprs: Vec<Expr> = match &args.kind {
            ExprKind::TupleLit(es) => es.clone(),
            _ => vec![args.clone()],
        };

        // 1. Split the template into an ordered list of literal and conversion segments.
        enum Seg {
            Lit(String),
            Val(Expr, String),
        }
        let mut segs: Vec<Seg> = Vec::new();
        let mut literal = String::new();
        let chars: Vec<char> = template.chars().collect();
        let mut i = 0usize;
        let mut next = 0usize;

        while i < chars.len() {
            if chars[i] != '%' {
                literal.push(chars[i]);
                i += 1;
                continue;
            }
            if chars.get(i + 1) == Some(&'%') {
                literal.push('%');
                i += 2;
                continue;
            }
            i += 1;
            let (mut minus, mut zero) = (false, false);
            while i < chars.len() && matches!(chars[i], '-' | '0' | '+' | ' ') {
                match chars[i] {
                    '-' => minus = true,
                    '0' => zero = true,
                    _ => {}
                }
                i += 1;
            }
            let mut width_s = String::new();
            while i < chars.len() && chars[i].is_ascii_digit() {
                width_s.push(chars[i]);
                i += 1;
            }
            let mut prec: Option<i64> = None;
            if chars.get(i) == Some(&'.') {
                i += 1;
                let mut p = String::new();
                while i < chars.len() && chars[i].is_ascii_digit() {
                    p.push(chars[i]);
                    i += 1;
                }
                prec = p.parse::<i64>().ok();
            }
            let Some(&conv) = chars.get(i) else {
                return Err(Diagnostic::new("`%` format ends with a dangling `%`", span));
            };
            i += 1;
            let conv_ty = match conv {
                's' | 'r' => None,
                'd' | 'i' => Some('d'),
                'f' | 'F' | 'e' | 'E' | 'g' | 'G' | 'x' | 'X' | 'o' | 'b' => Some(conv),
                other => {
                    return Err(Diagnostic::new(
                        format!("unsupported `%` conversion `%{other}`"),
                        span,
                    ))
                }
            };
            if next >= arg_exprs.len() {
                return Err(Diagnostic::new(
                    format!(
                        "`%` format has more conversions than arguments ({} given)",
                        arg_exprs.len()
                    ),
                    span,
                ));
            }
            let arg = arg_exprs[next].clone();
            next += 1;

            let mut spec = String::new();
            if let Some(w) = width_s.parse::<i64>().ok().filter(|w| *w > 0) {
                spec.push(if minus {
                    '<'
                } else if zero {
                    '0'
                } else {
                    '>'
                });
                spec.push_str(&w.to_string());
            }
            if let Some(p) = prec {
                spec.push('.');
                spec.push_str(&p.to_string());
            }
            if let Some(c) = conv_ty {
                spec.push(c);
            }
            if !literal.is_empty() {
                segs.push(Seg::Lit(std::mem::take(&mut literal)));
            }
            segs.push(Seg::Val(arg, spec));
        }
        if !literal.is_empty() {
            segs.push(Seg::Lit(literal));
        }

        // 2. Evaluate in document order and concatenate.
        let mut acc: Option<String> = None;
        for seg in segs {
            let piece = match seg {
                Seg::Lit(text) => {
                    let lit_expr = Expr {
                        kind: ExprKind::Str(text),
                        span,
                    };
                    self.eval_expr(&lit_expr, out)?.1
                }
                Seg::Val(arg, spec) => {
                    let (aty, aval) = self.eval_expr(&arg, out)?;
                    if spec.is_empty() {
                        self.emit_value_to_str(&aty, &aval, arg.span, out)?
                    } else {
                        self.emit_value_to_str_spec(&aty, &aval, &spec, arg.span, out)?
                    }
                }
            };
            acc = Some(match acc.take() {
                None => piece,
                Some(prev) => self.emit_str_concat_call(&prev, &piece, out),
            });
        }

        let raw = acc.unwrap_or_else(|| "{ i64 0, i64 0 }".to_string());
        self.used_str_concat = true;
        let reg = self.active_region_arg();
        let res = self.next_tmp();
        let _ = writeln!(
            out,
            "  {res} = call fastcc %ArchxStr @archx_str_concat(%ArchxStr {{ i64 0, i64 0 }}, %ArchxStr {raw}, ptr {reg})"
        );
        self.stmt_temps.push(TempDrop {
            val: res.clone(),
            ty: Type::Str,
        });
        Ok((Type::Str, res))
    }

    /// Emit a chained comparison (`a < b < c`, `a == b == c`).
    ///
    /// Python semantics: the links are evaluated left to right and evaluation stops at the first
    /// one that is false. Each link stores its result in a slot, so the join block needs no `phi`:
    ///
    /// ```text
    ///   store i1 <cmp0>, ptr %slot ; br i1 <cmp0>, %l1, %end
    /// l1: store i1 <cmp1>, ptr %slot ; br i1 <cmp1>, %l2, %end
    /// end: %res = load i1, ptr %slot
    /// ```
    ///
    /// Every link is compiled through `gen_binary`, so mixed `int`/`float`, `str` and `any`
    /// comparison rules stay in exactly one place. (Operands are re-evaluated per link, which is
    /// pure-but-redundant for calls such as `f() < g() < h()`; the values are identical because
    /// Archx has no `global`-mutable state at expression level.)
    fn gen_compare_chain(
        &mut self,
        operands: &[(Box<Expr>, BinOp)],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let result_slot = self.next_slot("chain.res");
        let _ = writeln!(self.allocas, "  {result_slot} = alloca i1, align 8");
        let end_lbl = self.fresh_label("chain.end");
        let n_links = operands.len() - 1;

        for i in 0..operands.len() - 1 {
            let lhs = &operands[i].0;
            let op = operands[i].1;
            let rhs = &operands[i + 1].0;
            let (ty, val) = self.gen_binary(op, lhs, rhs, span, out)?;
            if ty != Type::Bool {
                return Err(Diagnostic::new("comparison must produce a `bool`", span));
            }
            let _ = writeln!(out, "  store i1 {val}, ptr {result_slot}, align 8");
            if i + 1 == n_links {
                self.emit_br(&end_lbl, out);
            } else {
                let next_lbl = self.fresh_label("chain.next");
                self.emit_cond_br(&val, &next_lbl, &end_lbl, out);
                self.start_block(&next_lbl, out);
            }
        }

        self.start_block(&end_lbl, out);
        let res = self.next_tmp();
        let _ = writeln!(out, "  {res} = load i1, ptr {result_slot}, align 8");
        Ok((Type::Bool, res))
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

        if matches!(op, BinOp::In | BinOp::NotIn) {
            let (rhs_ty, rhs_val) = self.eval_expr(rhs, out)?;
            match &rhs_ty {
                Type::Dict(k_ty, _) | Type::Set(k_ty) => {
                    return self.eval_dict_or_set_contains(
                        k_ty,
                        &rhs_val,
                        lhs,
                        op == BinOp::NotIn,
                        out,
                    );
                }
                Type::Any => {
                    let la = self.eval_expr_as_any(lhs, out)?;
                    self.used_any_rt = true;
                    let fnd = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {fnd} = call fastcc i1 @archx_any_in(%ArchxAny {la}, %ArchxAny {rhs_val})"
                    );
                    if op == BinOp::In {
                        return Ok((Type::Bool, fnd));
                    }
                    let inv = self.next_tmp();
                    let _ = writeln!(out, "  {inv} = xor i1 {fnd}, true");
                    return Ok((Type::Bool, inv));
                }
                _ => {
                    let (lhs_ty, lhs_val) = self.eval_expr(lhs, out)?;
                    let found =
                        self.gen_in_operator(&lhs_ty, &lhs_val, &rhs_ty, &rhs_val, span, out)?;
                    if op == BinOp::In {
                        return Ok((Type::Bool, found));
                    }
                    let inv = self.next_tmp();
                    let _ = writeln!(out, "  {inv} = xor i1 {found}, true");
                    return Ok((Type::Bool, inv));
                }
            }
        }

        if matches!(&lhs.kind, ExprKind::NoneLit) && !matches!(&rhs.kind, ExprKind::NoneLit) {
            if let Some(res) = self.eval_optional_none_cmp(op, rhs, out)? {
                return Ok(res);
            }
        } else if matches!(&rhs.kind, ExprKind::NoneLit) && !matches!(&lhs.kind, ExprKind::NoneLit)
        {
            if let Some(res) = self.eval_optional_none_cmp(op, lhs, out)? {
                return Ok(res);
            }
        }
        if matches!(&lhs.kind, ExprKind::NoneLit) || matches!(&rhs.kind, ExprKind::NoneLit) {
            return self.eval_any_binary(op, lhs, rhs, out);
        }

        let (lhs_ty, lhs_val) = self.eval_expr(lhs, out)?;
        let (rhs_ty, rhs_val) = self.eval_expr(rhs, out)?;

        if lhs_ty == Type::Any || rhs_ty == Type::Any {
            let la = if lhs_ty == Type::Any {
                lhs_val
            } else {
                let b = self.emit_box_any_owned(&lhs_ty, &lhs_val, lhs.span, out)?;
                self.stmt_temps.push(TempDrop {
                    val: b.clone(),
                    ty: Type::Any,
                });
                b
            };
            let ra = if rhs_ty == Type::Any {
                rhs_val
            } else {
                let b = self.emit_box_any_owned(&rhs_ty, &rhs_val, rhs.span, out)?;
                self.stmt_temps.push(TempDrop {
                    val: b.clone(),
                    ty: Type::Any,
                });
                b
            };
            self.mark_runtime_type(&Type::Any);
            self.used_any_rt = true;
            return match op {
                BinOp::Eq | BinOp::Ne => {
                    let eq = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {eq} = call fastcc i1 @archx_any_eq(%ArchxAny {la}, %ArchxAny {ra})"
                    );
                    if op == BinOp::Eq {
                        Ok((Type::Bool, eq))
                    } else {
                        let inv = self.next_tmp();
                        let _ = writeln!(out, "  {inv} = xor i1 {eq}, true");
                        Ok((Type::Bool, inv))
                    }
                }
                BinOp::Lt | BinOp::Gt | BinOp::Le | BinOp::Ge => {
                    let code = match op {
                        BinOp::Lt => 0,
                        BinOp::Gt => 1,
                        BinOp::Le => 2,
                        BinOp::Ge => 3,
                        _ => unreachable!(),
                    };
                    let res = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {res} = call fastcc i1 @archx_any_cmp(%ArchxAny {la}, %ArchxAny {ra}, i64 {code})"
                    );
                    Ok((Type::Bool, res))
                }
                _ => {
                    let code = match op {
                        BinOp::Add => 0,
                        BinOp::Sub => 1,
                        BinOp::Mul => 2,
                        BinOp::Div => 3,
                        BinOp::FloorDiv => 4,
                        BinOp::Mod => 5,
                        BinOp::Pow => 6,
                        BinOp::BitAnd => 7,
                        BinOp::BitOr => 8,
                        BinOp::BitXor => 9,
                        BinOp::Shl => 10,
                        BinOp::Shr => 11,
                        _ => unreachable!(),
                    };
                    let rarg = self.active_region_arg();
                    let res = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {res} = call fastcc %ArchxAny @archx_any_binop(%ArchxAny {la}, %ArchxAny {ra}, i64 {code}, ptr {rarg})"
                    );
                    self.stmt_temps.push(TempDrop {
                        val: res.clone(),
                        ty: Type::Any,
                    });
                    Ok((Type::Any, res))
                }
            };
        }

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
                // Set algebra: `a | b`, `a & b`, `a - b`, `a ^ b` build a fresh set.
                if let (Type::Set(ea), Type::Set(eb)) = (&lhs_ty, &rhs_ty) {
                    if ea != eb {
                        return Err(Diagnostic::new(
                            format!(
                                "set operator `{}` requires matching element types, found `{}` and `{}`",
                                op.symbol(),
                                lhs_ty.name(),
                                rhs_ty.name()
                            ),
                            span,
                        ));
                    }
                    let method = match op {
                        BinOp::BitOr => "union",
                        BinOp::BitAnd => "intersection",
                        BinOp::Sub => "difference",
                        BinOp::BitXor => "symmetric_difference",
                        _ => {
                            return Err(Diagnostic::new(
                                format!(
                                    "operator `{}` is not defined for sets (use `+` to concatenate lists)",
                                    op.symbol()
                                ),
                                span,
                            ))
                        }
                    };
                    let ea = ea.clone();
                    return self.emit_set_algebra(&ea, &lhs_val, &rhs_val, method, out);
                }

                // `x ** -k` parses as `x ** (-k)`: a unary negation is its own expression, so the
                // literal check has to look at the AST node, not at the folded SSA name.
                let rhs_is_neg_lit = match &rhs.kind {
                    ExprKind::Unary {
                        op: UnOp::Neg,
                        expr: inner,
                    } => matches!(inner.kind, ExprKind::Int(_)),
                    _ => self.neg_int_literal(&rhs_val),
                };
                if op == BinOp::Pow
                    && lhs_ty == Type::Int
                    && rhs_ty == Type::Int
                    && rhs_is_neg_lit
                {
                    // `int ** negative int` is a float in Python (`2 ** -1 == 0.5`).
                    let lb = self.next_tmp();
                    let _ = writeln!(out, "  {lb} = sitofp i64 {lhs_val} to double");
                    self.used_pow_f64 = true;
                    let ex = self.next_tmp();
                    let _ = writeln!(out, "  {ex} = sitofp i64 {rhs_val} to double");
                    let r = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {r} = call double @llvm.pow.f64(double {lb}, double {ex})"
                    );
                    return Ok((Type::Float, r));
                }
                // Python's `/` is *true* division: `7 / 2` is `3.5`, never `3`. `//` is the
                // truncating/flooring operator, so `int / int` widens to `float` here.
                if op == BinOp::Div && lhs_ty == Type::Int && rhs_ty == Type::Int {
                    let val = self.emit_int_true_div(&lhs_val, &rhs_val, out);
                    return Ok((Type::Float, val));
                }
                // Mixed `int`/`float`: Python widens the integer operand and yields a float.
                if let Some((l, r)) =
                    self.coerce_numeric_pair(&lhs_ty, &rhs_ty, &lhs_val, &rhs_val, out)
                {
                    let val = self.emit_float_arith(op, &l, &r, out);
                    return Ok((Type::Float, val));
                }
                if op == BinOp::Sub {
                    if let (Type::Set(ea), Type::Set(eb)) = (&lhs_ty, &rhs_ty) {
                        if ea == eb {
                            let ea = ea.clone();
                            return self.emit_set_algebra(
                                &ea, &lhs_val, &rhs_val, "difference", out,
                            );
                        }
                    }
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

            // Bitwise operators are integer-only in Python (`1.0 & 1` is a TypeError), except
            // that `set` overloads `| & ^ -` for its algebra.
            BinOp::BitAnd | BinOp::BitOr | BinOp::BitXor | BinOp::Shl | BinOp::Shr => {
                if let (Type::Set(ea), Type::Set(eb)) = (&lhs_ty, &rhs_ty) {
                    if ea != eb {
                        return Err(Diagnostic::new(
                            format!(
                                "set operator `{}` requires matching element types, found `{}` and `{}`",
                                op.symbol(),
                                lhs_ty.name(),
                                rhs_ty.name()
                            ),
                            span,
                        ));
                    }
                    let method = match op {
                        BinOp::BitOr => "union",
                        BinOp::BitAnd => "intersection",
                        BinOp::BitXor => "symmetric_difference",
                        _ => {
                            return Err(Diagnostic::new(
                                format!("operator `{}` is not defined for sets", op.symbol()),
                                span,
                            ))
                        }
                    };
                    let ea = ea.clone();
                    return self.emit_set_algebra(&ea, &lhs_val, &rhs_val, method, out);
                }
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
                let instr = match op {
                    BinOp::BitAnd => "and",
                    BinOp::BitOr => "or",
                    BinOp::BitXor => "xor",
                    BinOp::Shl => "shl",
                    BinOp::Shr => "ashr",
                    _ => unreachable!(),
                };
                let val = self.next_tmp();
                if matches!(op, BinOp::Shl | BinOp::Shr) {
                    // Shift counts are masked to 0..63; Python raises on negative counts, but a
                    // masked shift is the established Archx behaviour for `<<`/`>>`.
                    let masked = self.next_tmp();
                    let _ = writeln!(out, "  {masked} = and i64 {rhs_val}, 63");
                    let _ = writeln!(out, "  {val} = {instr} i64 {lhs_val}, {masked}");
                } else {
                    let _ = writeln!(out, "  {val} = {instr} i64 {lhs_val}, {rhs_val}");
                }
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
                // Python compares `str` lexicographically by code unit.
                if lhs_ty == Type::Str && rhs_ty == Type::Str {
                    self.used_str_cmp = true;
                    let c = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {c} = call fastcc i32 @archx_str_cmp(%ArchxStr {lhs_val}, %ArchxStr {rhs_val})"
                    );
                    let reg = self.next_tmp();
                    let pred = match op {
                        BinOp::Lt => "slt",
                        BinOp::Gt => "sgt",
                        BinOp::Le => "sle",
                        BinOp::Ge => "sge",
                        _ => unreachable!(),
                    };
                    let _ = writeln!(out, "  {reg} = icmp {pred} i32 {c}, 0");
                    return Ok((Type::Bool, reg));
                }
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
                // Mixed `int`/`float` comparison: widen the integer side.
                if let Some((l, r)) =
                    self.coerce_numeric_pair(&lhs_ty, &rhs_ty, &lhs_val, &rhs_val, out)
                {
                    let pred = match op {
                        BinOp::Lt => "olt",
                        BinOp::Gt => "ogt",
                        BinOp::Le => "ole",
                        BinOp::Ge => "oge",
                        _ => unreachable!(),
                    };
                    let reg = self.next_tmp();
                    let _ = writeln!(out, "  {reg} = fcmp {pred} double {l}, {r}");
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

    /// Python numeric promotion: `int` and `float` mix freely (`1 + 1.5`, `2 < 2.5`, `1 == 1.0`).
    /// Returns the two operands widened to `double` when the pair is `int`/`float`; `None` when
    /// the operands are not a numeric mix and the caller should keep its own diagnostics.
    pub(super) fn coerce_numeric_pair(
        &mut self,
        lhs_ty: &Type,
        rhs_ty: &Type,
        lhs_val: &str,
        rhs_val: &str,
        out: &mut String,
    ) -> Option<(String, String)> {
        let as_double = |cg: &mut Self, ty: &Type, val: &str, out: &mut String| match ty {
            Type::Float => Some(val.to_string()),
            Type::Int => {
                let t = cg.next_tmp();
                let _ = writeln!(out, "  {t} = sitofp i64 {val} to double");
                Some(t)
            }
            _ => None,
        };
        if *lhs_ty == *rhs_ty || (!matches!(lhs_ty, Type::Int | Type::Float))
            || (!matches!(rhs_ty, Type::Int | Type::Float))
        {
            return None;
        }
        let l = as_double(self, lhs_ty, lhs_val, out)?;
        let r = as_double(self, rhs_ty, rhs_val, out)?;
        Some((l, r))
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
        if let Type::Optional(inner) = lhs_ty {
            if **inner == *rhs_ty {
                let (_, wrapped_r) = self.wrap_optional_some(rhs_ty, rhs_val, out);
                return self.emit_structural_eq(lhs_ty, lhs_val, &wrapped_r, span, out);
            }
        }
        if let Type::Optional(inner) = rhs_ty {
            if **inner == *lhs_ty {
                let (_, wrapped_l) = self.wrap_optional_some(lhs_ty, lhs_val, out);
                return self.emit_structural_eq(rhs_ty, &wrapped_l, rhs_val, span, out);
            }
        }
        // `1 == 1.0` is legal Python: the int operand is widened to float first.
        if let Some((pl, pr)) = self.coerce_numeric_pair(lhs_ty, rhs_ty, lhs_val, rhs_val, out) {
            let eq = self.next_tmp();
            let _ = writeln!(out, "  {eq} = fcmp oeq double {pl}, {pr}");
            return Ok(eq);
        }
        if lhs_ty != rhs_ty {
            return Err(Diagnostic::new(
                format!("cannot compare `{}` and `{}`", lhs_ty.name(), rhs_ty.name()),
                span,
            ));
        }
        match lhs_ty {
            Type::Tuple(_) | Type::Optional(_) | Type::Enum(_) => {
                self.emit_structural_eq(lhs_ty, lhs_val, rhs_val, span, out)
            }
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
            Type::Any => {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call fastcc i1 @archx_any_eq(%ArchxAny {lhs_val}, %ArchxAny {rhs_val})"
                );
                Ok(reg)
            }
            Type::Array(_) | Type::Dict(_, _) | Type::Set(_) => {
                let la = self.emit_box_any_owned(lhs_ty, lhs_val, span, out)?;
                let ra = self.emit_box_any_owned(rhs_ty, rhs_val, span, out)?;
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call fastcc i1 @archx_any_eq(%ArchxAny {la}, %ArchxAny {ra})"
                );
                let _ = writeln!(out, "  call fastcc void @archx_any_drop(%ArchxAny {la})");
                let _ = writeln!(out, "  call fastcc void @archx_any_drop(%ArchxAny {ra})");
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
            Type::GenericInst { .. } => Err(Diagnostic::new(
                format!(
                    "cannot compare generic value of type `{}` (it must be monomorphized)",
                    lhs_ty.name()
                ),
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

    /// Python `int / int` -> `float` (true division). `sitofp` + `fdiv` is the fast path and is
    /// correctly rounded for magnitudes below 2^53; above that the `sitofp` round-trip loses bits
    /// before the divide sees them, so the remainder is folded back in (`a/b == q + r/b` with
    /// `q = a sdiv b` exact), which is the classic "two-step correctly rounded division".
    pub(super) fn emit_int_true_div(&mut self, lhs_val: &str, rhs_val: &str, out: &mut String) -> String {
        self.used_div_zero_fail = true;
        let dz = self.next_tmp();
        let _ = writeln!(out, "  {dz} = icmp eq i64 {rhs_val}, 0");
        let dz_lbl = self.fresh_label("tdiv.zero");
        let ok_lbl = self.fresh_label("tdiv.ok");
        self.emit_cond_br(&dz, &dz_lbl, &ok_lbl, out);

        self.start_block(&dz_lbl, out);
        let _ = writeln!(out, "  call void @archx_div_zero_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);

        // sdiv overflows only for i64::MIN / -1, which is exactly 2^63 — representable as a float.
        let is_min = self.next_tmp();
        let _ = writeln!(out, "  {is_min} = icmp eq i64 {lhs_val}, {}", i64::MIN);
        let is_neg1 = self.next_tmp();
        let _ = writeln!(out, "  {is_neg1} = icmp eq i64 {rhs_val}, -1");
        let ovf = self.next_tmp();
        let _ = writeln!(out, "  {ovf} = and i1 {is_min}, {is_neg1}");
        let safe_rhs = self.next_tmp();
        let _ = writeln!(out, "  {safe_rhs} = select i1 {ovf}, i64 1, i64 {rhs_val}");
        let q = self.next_tmp();
        let _ = writeln!(out, "  {q} = sdiv i64 {lhs_val}, {safe_rhs}");
        let r = self.next_tmp();
        let _ = writeln!(out, "  {r} = srem i64 {lhs_val}, {safe_rhs}");

        let fast = self.next_tmp();
        let _ = writeln!(out, "  {fast} = sitofp i64 {q} to double");
        let fr = self.next_tmp();
        let _ = writeln!(out, "  {fr} = sitofp i64 {r} to double");
        let fd = self.next_tmp();
        let _ = writeln!(out, "  {fd} = sitofp i64 {safe_rhs} to double");
        let frac = self.next_tmp();
        let _ = writeln!(out, "  {frac} = fdiv double {fr}, {fd}");
        let slow = self.next_tmp();
        let _ = writeln!(out, "  {slow} = fadd double {fast}, {frac}");

        // Small magnitudes (both |a| < 2^53) need no correction; use the plain `a / b` there so
        // the common case stays a single `sitofp` pair plus one `fdiv`.
        let cast_l = self.next_tmp();
        let _ = writeln!(out, "  {cast_l} = sitofp i64 {lhs_val} to double");
        let cast_r = self.next_tmp();
        let _ = writeln!(out, "  {cast_r} = sitofp i64 {safe_rhs} to double");
        let plain = self.next_tmp();
        let _ = writeln!(out, "  {plain} = fdiv double {cast_l}, {cast_r}");

        let neg_l = self.next_tmp();
        let _ = writeln!(out, "  {neg_l} = icmp slt i64 {lhs_val}, 0");
        let neg_lv = self.next_tmp();
        let _ = writeln!(out, "  {neg_lv} = sub nsw i64 0, {lhs_val}");
        let abs_l = self.next_tmp();
        let _ = writeln!(out, "  {abs_l} = select i1 {neg_l}, i64 {neg_lv}, i64 {lhs_val}");
        let neg_r = self.next_tmp();
        let _ = writeln!(out, "  {neg_r} = icmp slt i64 {safe_rhs}, 0");
        let neg_rv = self.next_tmp();
        let _ = writeln!(out, "  {neg_rv} = sub nsw i64 0, {safe_rhs}");
        let abs_r = self.next_tmp();
        let _ = writeln!(out, "  {abs_r} = select i1 {neg_r}, i64 {neg_rv}, i64 {safe_rhs}");
        let big_l = self.next_tmp();
        let _ = writeln!(out, "  {big_l} = icmp sgt i64 {abs_l}, 9007199254740992");
        let big_r = self.next_tmp();
        let _ = writeln!(out, "  {big_r} = icmp sgt i64 {abs_r}, 9007199254740992");
        let big = self.next_tmp();
        let _ = writeln!(out, "  {big} = or i1 {big_l}, {big_r}");
        let res = self.next_tmp();
        let _ = writeln!(out, "  {res} = select i1 {big}, double {slow}, double {plain}");
        // i64::MIN / -1 lands here with safe_rhs = 1, so `slow` already reads 2^63.
        res
    }

    /// True when an already-emitted integer operand is a negative literal (so its SSA name is
    /// either `-N` or a constant-folded negative).
    fn neg_int_literal(&self, val: &str) -> bool {
        match val.trim().parse::<i64>() {
            Ok(v) => v < 0,
            Err(_) => false,
        }
    }

    pub(super) fn emit_int_arith(&mut self, op: BinOp, lhs_val: &str, rhs_val: &str, out: &mut String) -> String {
        if let (Ok(a), Ok(b)) = (lhs_val.parse::<i64>(), rhs_val.parse::<i64>()) {
            let folded = match op {
                BinOp::Add => Some(a.wrapping_add(b)),
                BinOp::Sub => Some(a.wrapping_sub(b)),
                BinOp::Mul => Some(a.wrapping_mul(b)),
                // `int / int` is true division and produces a `float`; folding it to an
                // integer here would silently truncate (`7 / 2` -> `3`).
                BinOp::Div => None,
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
            // A *non-constant* exponent that turns out negative cannot change the expression's
            // type at runtime, so it is reported instead of silently returning an int.
            // (`2 ** -1` with a literal exponent is routed to the float path by `emit_binary`.)
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

        if op == BinOp::Mod {
            // Python's `%` is the *floor* modulus: the result takes the sign of the divisor
            // (`-7 % 3 == 2`, `7 % -3 == -2`), unlike LLVM's truncating `srem`.
            self.used_div_zero_fail = true;
            let dz = self.next_tmp();
            let _ = writeln!(out, "  {dz} = icmp eq i64 {rhs_val}, 0");
            let dz_lbl = self.fresh_label("mod.zero");
            let ok_lbl = self.fresh_label("mod.ok");
            self.emit_cond_br(&dz, &dz_lbl, &ok_lbl, out);

            self.start_block(&dz_lbl, out);
            let _ = writeln!(out, "  call void @archx_div_zero_fail()");
            let _ = writeln!(out, "  unreachable");
            self.terminated = true;

            self.start_block(&ok_lbl, out);
            // `i64::MIN % -1` traps in `srem`, but its true remainder is 0.
            let is_min = self.next_tmp();
            let _ = writeln!(out, "  {is_min} = icmp eq i64 {lhs_val}, {}", i64::MIN);
            let is_neg1 = self.next_tmp();
            let _ = writeln!(out, "  {is_neg1} = icmp eq i64 {rhs_val}, -1");
            let ovf = self.next_tmp();
            let _ = writeln!(out, "  {ovf} = and i1 {is_min}, {is_neg1}");
            let safe_rhs = self.next_tmp();
            let _ = writeln!(out, "  {safe_rhs} = select i1 {ovf}, i64 1, i64 {rhs_val}");
            let raw = self.next_tmp();
            let _ = writeln!(out, "  {raw} = srem i64 {lhs_val}, {safe_rhs}");
            let nz = self.next_tmp();
            let _ = writeln!(out, "  {nz} = icmp ne i64 {raw}, 0");
            let rsign = self.next_tmp();
            let _ = writeln!(out, "  {rsign} = icmp slt i64 {raw}, 0");
            let bsign = self.next_tmp();
            let _ = writeln!(out, "  {bsign} = icmp slt i64 {safe_rhs}, 0");
            let differ = self.next_tmp();
            let _ = writeln!(out, "  {differ} = xor i1 {rsign}, {bsign}");
            let need = self.next_tmp();
            let _ = writeln!(out, "  {need} = and i1 {nz}, {differ}");
            let adj = self.next_tmp();
            let _ = writeln!(out, "  {adj} = select i1 {need}, i64 {safe_rhs}, i64 0");
            let res = self.next_tmp();
            let _ = writeln!(out, "  {res} = add i64 {raw}, {adj}");
            return res;
        }

        if op == BinOp::Div {
            let instr = "sdiv";
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
        _span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let mark = self.stmt_temps.len();
        let lhs_val = self.eval_cond_bool(lhs, op.symbol(), out)?;
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
        let rhs_val = self.eval_cond_bool(rhs, op.symbol(), out)?;
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

