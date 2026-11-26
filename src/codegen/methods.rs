//! Method definition & dispatch lowering: user `class`/`struct` methods (`def method(self, ...):`),
//! Python list methods (`.append()`, `.pop()`, `.clear()`), and SSO-aware string methods
//! (`.strip()`, `.split()`, `.startswith()`, `.endswith()`, `.upper()`, `.lower()`, `.find()`, `.replace()`).

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::analysis::*;
use super::*;

impl Codegen {
    pub(super) fn gen_method(
        &mut self,
        struct_name: &str,
        func: &Func,
        out: &mut String,
    ) -> Result<()> {
        let sig = self
            .methods
            .get(&(struct_name.to_string(), func.name.clone()))
            .cloned()
            .expect("method registered");

        self.scopes = vec![Scope::default()];
        self.stmt_temps.clear();
        self.adaptive_hints = compute_adaptive_hints(
            &func.params,
            &func.body,
            &self.structs,
            &self.enums,
            &self.sigs,
        );
        let mut mutated =
            collect_mutated_vars(&func.params, &func.body, &self.mutating_method_names);
        for dvar in &self.adaptive_hints.dynamic_vars {
            mutated.insert(dvar.clone());
        }
        self.mutated_vars = mutated;
        self.returned_vars = collect_returned_vars(&func.body);
        self.loop_stack.clear();
        self.loop_bounds.clear();
        self.region_stack.clear();
        self.func_region_slot = None;
        self.break_count = 0;
        self.depth = 0;
        self.next_tmp = 0;
        self.next_label = 0;
        self.terminated = false;
        self.is_main = false;
        self.allocas.clear();
        self.sort_tmp_slot = None;
        self.current_ret = sig.ret.clone();

        let ir_ret = ir_ret_type(sig.ret.as_ref());
        let mut header = format!("define internal fastcc {ir_ret} {}(", sig.ir_name);
        let self_ty = Type::Struct(struct_name.to_string());
        if sig.self_by_ptr {
            header.push_str("ptr %arg.self");
        } else {
            let _ = write!(header, "{} %arg.self", ir_type(&self_ty));
        }
        for param in &func.params[1..] {
            let _ = write!(header, ", {} %arg.{}", ir_type(&param.ty), param.name);
        }
        header.push_str(") {");

        let mut body = String::new();
        if stmts_use_region(&func.body) {
            self.used_region = true;
            let rslot = "%func.region".to_string();
            let _ = writeln!(self.allocas, "  {rslot} = alloca %ArchxRegion, align 8");
            let _ = writeln!(
                body,
                "  store %ArchxRegion zeroinitializer, ptr {rslot}, align 8"
            );
            self.func_region_slot = Some(rslot);
        }

        let self_storage = if sig.self_by_ptr {
            VarStorage::Slot("%arg.self".to_string())
        } else {
            VarStorage::Imm("%arg.self".to_string())
        };
        self.scopes[0].vars.insert(
            "self".to_string(),
            VarEntry {
                ty: self_ty,
                storage: self_storage,
                is_param: true,
                region_depth: 0,
            },
        );

        for param in &func.params[1..] {
            let arg_ssa = format!("%arg.{}", param.name);
            let is_mut = self.mutated_vars.contains(&param.name);
            let storage = if is_mut {
                let ty_ir = ir_type(&param.ty);
                let align = ir_align(&param.ty);
                let ptr = self.next_slot(&format!("param.{}", param.name));
                let _ = writeln!(self.allocas, "  {ptr} = alloca {ty_ir}, align {align}");
                let init_val = if self.type_needs_drop(&param.ty) {
                    self.emit_clone_value(&param.ty, &arg_ssa, &mut body)
                } else {
                    arg_ssa
                };
                let _ = writeln!(body, "  store {ty_ir} {init_val}, ptr {ptr}, align {align}");
                if self.type_needs_drop(&param.ty) {
                    self.scopes[0].owned_buffers.push(DropTarget::TypedSlot {
                        ptr: ptr.clone(),
                        ty: param.ty.clone(),
                    });
                }
                VarStorage::Slot(ptr)
            } else {
                VarStorage::Imm(arg_ssa)
            };

            self.scopes[0].vars.insert(
                param.name.clone(),
                VarEntry {
                    ty: param.ty.clone(),
                    storage,
                    is_param: !is_mut,
                    region_depth: 0,
                },
            );
        }

        self.gen_block(&func.body, &mut body)?;

        if !self.terminated {
            if self.current_ret.is_none() {
                self.emit_func_exit_cleanup(None, &mut body);
                body.push_str("  ret void\n");
            } else if self.current_ret == Some(Type::Any) {
                self.mark_runtime_type(&Type::Any);
                self.emit_func_exit_cleanup(None, &mut body);
                body.push_str("  ret %ArchxAny zeroinitializer\n");
            } else if let Some(Type::Optional(inner)) = &self.current_ret.clone() {
                let opt_ir = ir_type(&Type::Optional(inner.clone()));
                self.emit_func_exit_cleanup(None, &mut body);
                let _ = writeln!(body, "  ret {opt_ir} zeroinitializer");
            } else {
                return Err(Diagnostic::new(
                    format!(
                        "method `{struct_name}.{}` must return a value on every path",
                        func.name
                    ),
                    func.span,
                ));
            }
        }

        let _ = writeln!(out, "{header}");
        let _ = writeln!(out, "entry:");
        out.push_str(&self.allocas);
        out.push_str(&body);
        let _ = writeln!(out, "}}\n");
        Ok(())
    }

    pub(super) fn gen_method_call(
        &mut self,
        target: &Expr,
        method: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        // 0. Algebraic enum payload construction (`Shape.Circle(3.0)`):
        if let ExprKind::Var(ename) = &target.kind {
            if self.lookup_var(ename).is_none() && self.enums.contains_key(ename) {
                return self.gen_enum_construct(ename, method, args, span, out);
            }
        }

        // 1. In-place list mutators (`xs.append(v)`, `xs.pop()`, `xs.clear()`) on a list variable:
        if let ExprKind::Var(vname) = &target.kind {
            if let Some(entry) = self.lookup_var(vname).cloned() {
                if let Type::Array(elem_ty) = &entry.ty {
                    return match method {
                        "sort" => self.gen_list_sort(target, args, &[], span, out),
                        "append" => {
                            if args.len() != 1 {
                                return Err(Diagnostic::new(
                                    "`list.append()` takes exactly 1 argument",
                                    span,
                                ));
                            }
                            self.emit_list_push_var(target, &args[0], "append", span, out)
                        }
                        "pop" => {
                            if !args.is_empty() {
                                return Err(Diagnostic::new(
                                    "`list.pop()` takes 0 arguments",
                                    span,
                                ));
                            }
                            self.emit_list_pop_var(target, "pop", span, out)
                        }
                        "clear" => {
                            if !args.is_empty() {
                                return Err(Diagnostic::new(
                                    "`list.clear()` takes 0 arguments",
                                    span,
                                ));
                            }
                            self.emit_list_clear_var(vname, &entry, elem_ty, span, out)
                        }
                        other => Err(Diagnostic::new(
                            format!("`{}` has no method `{other}`", entry.ty.name()),
                            span,
                        )),
                    };
                }
                if let Type::Struct(sname) = &entry.ty {
                    let sig = self
                        .methods
                        .get(&(sname.clone(), method.to_string()))
                        .cloned()
                        .ok_or_else(|| {
                            Diagnostic::new(
                                format!("class/struct `{sname}` has no method `{method}`"),
                                span,
                            )
                        })?;
                    if sig.self_by_ptr {
                        if let VarStorage::Slot(slot_ptr) = &entry.storage {
                            return self.emit_method_invoke(&sig, slot_ptr, args, span, out);
                        }
                    }
                }
            }
        }

        // 2. In-place `arr[idx].mutating_method(...)` on an AoS struct array element:
        if let ExprKind::Index {
            target: arr_expr,
            index: idx_expr,
        } = &target.kind
        {
            let maybe_elem_struct = match &arr_expr.kind {
                ExprKind::Var(aname) => self.lookup_var(aname).and_then(|e| match &e.ty {
                    Type::Array(inner) => match inner.as_ref() {
                        Type::Struct(s) => Some(s.clone()),
                        _ => None,
                    },
                    _ => None,
                }),
                _ => None,
            };
            if let Some(sname) = maybe_elem_struct {
                if let Some(sig) = self
                    .methods
                    .get(&(sname.clone(), method.to_string()))
                    .cloned()
                {
                    if sig.self_by_ptr {
                        let (_, vec_val) = self.eval_expr(arr_expr, out)?;
                        let (idx_ty, idx_val) = self.eval_expr(idx_expr, out)?;
                        if idx_ty != Type::Int {
                            return Err(Diagnostic::new(
                                format!("array index must be `int`, found `{}`", idx_ty.name()),
                                idx_expr.span,
                            ));
                        }
                        self.emit_bounds_check_if_needed(
                            arr_expr, idx_expr, &vec_val, &idx_val, out,
                        )?;
                        let data_ptr = self.next_tmp();
                        let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {vec_val}, 2");
                        let elem_ptr = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {elem_ptr} = getelementptr inbounds %ArchxStruct_{sname}, ptr {data_ptr}, i64 {idx_val}"
                        );
                        return self.emit_method_invoke(&sig, &elem_ptr, args, span, out);
                    }
                }
            }

            // In-place mutating method on a dictionary value (`hello["data"].append("fast")`):
            if matches!(method, "append" | "pop" | "add" | "remove" | "discard" | "clear") {
                if let ExprKind::Var(dname) = &arr_expr.kind {
                    if let Some(dentry) = self.lookup_var(dname).cloned() {
                        if let Type::Dict(k_ty, v_ty) = &dentry.ty {
                            if **v_ty == Type::Any {
                                let (_, d_val) = self.eval_expr(arr_expr, out)?;
                                self.used_dict_rt = true;
                                self.used_key_fail = true;
                                let fam = Self::dict_family_suffix(k_ty);
                                let (kir, kval) = self.eval_key_for_dict(k_ty, idx_expr, out)?;
                                let didx = self.next_tmp();
                                let _ = writeln!(
                                    out,
                                    "  {didx} = call fastcc i64 @archx_dict_lookup_{fam}(i64 {d_val}, {kir} {kval})"
                                );
                                let ok = self.next_tmp();
                                let _ = writeln!(out, "  {ok} = icmp sge i64 {didx}, 0");
                                let ok_lbl = self.fresh_label("dm.ok");
                                let miss_lbl = self.fresh_label("dm.miss");
                                self.emit_cond_br(&ok, &ok_lbl, &miss_lbl, out);
                                self.start_block(&miss_lbl, out);
                                let _ = writeln!(out, "  call void @archx_key_fail()");
                                let _ = writeln!(out, "  unreachable");
                                self.start_block(&ok_lbl, out);
                                let borrowed = self.next_tmp();
                                let raw = self.next_tmp();
                                let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
                                let hdr = self.next_tmp();
                                let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
                                let vg = self.next_tmp();
                                let _ = writeln!(
                                    out,
                                    "  {vg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 6"
                                );
                                let vp = self.next_tmp();
                                let _ = writeln!(out, "  {vp} = load ptr, ptr {vg}, align 8");
                                let vep = self.next_tmp();
                                let _ = writeln!(
                                    out,
                                    "  {vep} = getelementptr inbounds %ArchxAny, ptr {vp}, i64 {didx}"
                                );
                                let _ = writeln!(
                                    out,
                                    "  {borrowed} = load %ArchxAny, ptr {vep}, align 8"
                                );
                                return self.gen_any_method(&borrowed, method, args, span, out);
                            }
                        }
                    }
                }
            }
        }

        // 3. Evaluate receiver by value:
        let (target_ty, target_val) = self.eval_expr(target, out)?;
        match &target_ty {
            Type::Str => self.gen_str_method(&target_val, method, args, span, out),
            Type::Dict(k_ty, v_ty) => {
                self.gen_dict_method(k_ty, v_ty, &target_val, method, args, span, out)
            }
            Type::Set(elem_ty) => {
                self.gen_set_method(elem_ty, &target_val, method, args, span, out)
            }
            Type::Any => self.gen_any_method(&target_val, method, args, span, out),
            Type::Struct(sname) => {
                let sig = self
                    .methods
                    .get(&(sname.clone(), method.to_string()))
                    .cloned()
                    .ok_or_else(|| {
                        Diagnostic::new(
                            format!("class/struct `{sname}` has no method `{method}`"),
                            span,
                        )
                    })?;
                if sig.self_by_ptr {
                    let tslot = self.next_slot(&format!("tmp.self.{sname}"));
                    let ty_ir = ir_type(&target_ty);
                    let _ = writeln!(self.allocas, "  {tslot} = alloca {ty_ir}, align 8");
                    let _ = writeln!(out, "  store {ty_ir} {target_val}, ptr {tslot}, align 8");
                    self.emit_method_invoke(&sig, &tslot, args, span, out)
                } else {
                    self.emit_method_invoke(&sig, &target_val, args, span, out)
                }
            }
            Type::Array(_) => Err(Diagnostic::new(
                format!(
                    "list method `{method}` requires a local list variable (e.g. `xs.{method}(...)`)"
                ),
                span,
            )),
            other => Err(Diagnostic::new(
                format!("type `{}` has no method `{method}`", other.name()),
                span,
            )),
        }
    }

    fn emit_method_invoke(
        &mut self,
        sig: &MethodSig,
        self_arg: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != sig.params.len() {
            return Err(Diagnostic::new(
                format!(
                    "method expects {} argument{}, but {} {} supplied",
                    sig.params.len(),
                    if sig.params.len() == 1 { "" } else { "s" },
                    args.len(),
                    if args.len() == 1 { "was" } else { "were" }
                ),
                span,
            ));
        }

        let mut arg_vals = Vec::with_capacity(args.len());
        for (i, arg) in args.iter().enumerate() {
            if sig.params[i] == Type::Any {
                let aval = self.eval_expr_as_any(arg, out)?;
                arg_vals.push((Type::Any, aval));
                continue;
            }
            let (ty, val) = self.eval_expr_typed(arg, Some(&sig.params[i]), out)?;
            let coerced = if ty == sig.params[i] {
                val
            } else if ty == Type::Any {
                self.emit_unbox_any(&sig.params[i], &val, arg.span, out)?
            } else {
                return Err(Diagnostic::new(
                    format!(
                        "method argument {} expects `{}`, found `{}`",
                        i + 1,
                        sig.params[i].name(),
                        ty.name()
                    ),
                    arg.span,
                ));
            };
            arg_vals.push((sig.params[i].clone(), coerced));
        }

        let self_prefix = if sig.self_by_ptr {
            format!("ptr {self_arg}")
        } else {
            let sty = sig.ir_name.splitn(4, '_').collect::<Vec<_>>();
            let _ = sty;
            // Reconstruct struct IR type from caller context:
            let sname = extract_struct_from_mangled(&sig.ir_name);
            format!("%ArchxStruct_{sname} {self_arg}")
        };

        if sig.ret.is_none() {
            let mut call = format!("  call fastcc void {}({self_prefix}", sig.ir_name);
            for (ty, val) in &arg_vals {
                let _ = write!(call, ", {} {}", ir_type(ty), val);
            }
            call.push_str(")\n");
            out.push_str(&call);
            return Ok((Type::Void, String::new()));
        }

        let reg = self.next_tmp();
        let ret_ir = ir_ret_type(sig.ret.as_ref());
        let mut call = format!("  {reg} = call fastcc {ret_ir} {}({self_prefix}", sig.ir_name);
        for (ty, val) in &arg_vals {
            let _ = write!(call, ", {} {}", ir_type(ty), val);
        }
        call.push_str(")\n");
        out.push_str(&call);

        let ret_ty = sig.ret.clone().unwrap();
        if self.type_needs_drop(&ret_ty) {
            self.stmt_temps.push(TempDrop {
                val: reg.clone(),
                ty: ret_ty.clone(),
            });
        }
        Ok((ret_ty, reg))
    }

    fn emit_list_clear_var(
        &mut self,
        arr_name: &str,
        entry: &VarEntry,
        elem_ty: &Type,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if entry.is_param {
            return Err(Diagnostic::new(
                format!("cannot `clear` borrowed parameter `{arr_name}`"),
                span,
            ));
        }
        let VarStorage::Slot(slot_ptr) = &entry.storage else {
            return Err(Diagnostic::new(
                format!("internal error: cleared list `{arr_name}` lacked a slot"),
                span,
            ));
        };
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}, align 8");
        if self.type_needs_drop(elem_ty) {
            let len_v = self.next_tmp();
            let _ = writeln!(out, "  {len_v} = extractvalue %ArchxVec {vec}, 0");
            let data_p = self.next_tmp();
            let _ = writeln!(out, "  {data_p} = extractvalue %ArchxVec {vec}, 2");
            let islot = self.next_slot("clear.idx");
            let _ = writeln!(self.allocas, "  {islot} = alloca i64, align 8");
            let _ = writeln!(out, "  store i64 0, ptr {islot}, align 8");
            let cl = self.fresh_label("clear.cond");
            let bl = self.fresh_label("clear.body");
            let el = self.fresh_label("clear.end");
            self.emit_br(&cl, out);
            self.start_block(&cl, out);
            let ci = self.next_tmp();
            let _ = writeln!(out, "  {ci} = load i64, ptr {islot}, align 8");
            let mc = self.next_tmp();
            let _ = writeln!(out, "  {mc} = icmp slt i64 {ci}, {len_v}");
            self.emit_cond_br(&mc, &bl, &el, out);
            self.start_block(&bl, out);
            let mem_ty = elem_mem_ir_type(elem_ty);
            let ep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {ep} = getelementptr inbounds {mem_ty}, ptr {data_p}, i64 {ci}"
            );
            let old_e = self.emit_elem_load(elem_ty, &ep, out);
            self.emit_drop_value(elem_ty, &old_e, out);
            let ni = self.next_tmp();
            let _ = writeln!(out, "  {ni} = add nuw nsw i64 {ci}, 1");
            let _ = writeln!(out, "  store i64 {ni}, ptr {islot}, align 8");
            self.emit_br(&cl, out);
            self.start_block(&el, out);
        }
        let vec0 = self.next_tmp();
        let _ = writeln!(out, "  {vec0} = insertvalue %ArchxVec {vec}, i64 0, 0");
        let _ = writeln!(out, "  store %ArchxVec {vec0}, ptr {slot_ptr}, align 8");
        Ok((Type::Void, String::new()))
    }

    // ---------------- Python String Methods ----------------------------------

    fn gen_str_method(
        &mut self,
        s_val: &str,
        method: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        match method {
            "strip" => {
                if !args.is_empty() {
                    return Err(Diagnostic::new("`str.strip()` takes 0 arguments", span));
                }
                self.used_str_strip = true;
                let reg_arg = self.active_region_arg();
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxStr @archx_str_strip(%ArchxStr {s_val}, ptr {reg_arg})"
                );
                self.stmt_temps.push(TempDrop {
                    val: res.clone(),
                    ty: Type::Str,
                });
                Ok((Type::Str, res))
            }
            "upper" | "lower" => {
                if !args.is_empty() {
                    return Err(Diagnostic::new(
                        format!("`str.{method}()` takes 0 arguments"),
                        span,
                    ));
                }
                self.used_str_case = true;
                let reg_arg = self.active_region_arg();
                let up = if method == "upper" { "true" } else { "false" };
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxStr @archx_str_case(%ArchxStr {s_val}, i1 {up}, ptr {reg_arg})"
                );
                self.stmt_temps.push(TempDrop {
                    val: res.clone(),
                    ty: Type::Str,
                });
                Ok((Type::Str, res))
            }
            "startswith" | "endswith" => {
                if args.len() != 1 {
                    return Err(Diagnostic::new(
                        format!("`str.{method}()` takes exactly 1 `str` argument"),
                        span,
                    ));
                }
                let (aty, aval) = self.eval_expr(&args[0], out)?;
                if aty != Type::Str {
                    return Err(Diagnostic::new(
                        format!("`str.{method}()` expects `str`, found `{}`", aty.name()),
                        args[0].span,
                    ));
                }
                self.used_str_starts_ends = true;
                let helper = if method == "startswith" {
                    "@archx_str_startswith"
                } else {
                    "@archx_str_endswith"
                };
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc i1 {helper}(%ArchxStr {s_val}, %ArchxStr {aval})"
                );
                Ok((Type::Bool, res))
            }
            "find" => {
                if args.len() != 1 {
                    return Err(Diagnostic::new(
                        "`str.find()` takes exactly 1 `str` argument",
                        span,
                    ));
                }
                let (aty, aval) = self.eval_expr(&args[0], out)?;
                if aty != Type::Str {
                    return Err(Diagnostic::new(
                        format!("`str.find()` expects `str`, found `{}`", aty.name()),
                        args[0].span,
                    ));
                }
                self.used_str_find = true;
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc i64 @archx_str_find(%ArchxStr {s_val}, %ArchxStr {aval})"
                );
                Ok((Type::Int, res))
            }
            "replace" => {
                if args.len() != 2 {
                    return Err(Diagnostic::new(
                        "`str.replace()` takes 2 `str` arguments (`s.replace(old, new)`)",
                        span,
                    ));
                }
                let (ot, ov) = self.eval_expr(&args[0], out)?;
                if ot != Type::Str {
                    return Err(Diagnostic::new(
                        format!("`str.replace()` expects `str`, found `{}`", ot.name()),
                        args[0].span,
                    ));
                }
                let (nt, nv) = self.eval_expr(&args[1], out)?;
                if nt != Type::Str {
                    return Err(Diagnostic::new(
                        format!("`str.replace()` expects `str`, found `{}`", nt.name()),
                        args[1].span,
                    ));
                }
                self.used_str_replace = true;
                let reg_arg = self.active_region_arg();
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxStr @archx_str_replace(%ArchxStr {s_val}, %ArchxStr {ov}, %ArchxStr {nv}, ptr {reg_arg})"
                );
                self.stmt_temps.push(TempDrop {
                    val: res.clone(),
                    ty: Type::Str,
                });
                Ok((Type::Str, res))
            }
            "split" => {
                if args.len() > 1 {
                    return Err(Diagnostic::new(
                        "`str.split()` takes at most 1 separator argument",
                        span,
                    ));
                }
                self.used_vec_type = true;
                let res = self.next_tmp();
                if args.is_empty() {
                    self.used_str_split_ws = true;
                    let _ = writeln!(
                        out,
                        "  {res} = call fastcc %ArchxVec @archx_str_split_ws(%ArchxStr {s_val})"
                    );
                } else {
                    let (sty, sval) = self.eval_expr(&args[0], out)?;
                    if sty != Type::Str {
                        return Err(Diagnostic::new(
                            format!("`str.split()` separator must be `str`, found `{}`", sty.name()),
                            args[0].span,
                        ));
                    }
                    self.used_str_split_sep = true;
                    let _ = writeln!(
                        out,
                        "  {res} = call fastcc %ArchxVec @archx_str_split_sep(%ArchxStr {s_val}, %ArchxStr {sval})"
                    );
                }
                let arr_ty = Type::Array(Box::new(Type::Str));
                self.stmt_temps.push(TempDrop {
                    val: res.clone(),
                    ty: arr_ty.clone(),
                });
                Ok((arr_ty, res))
            }
            other => Err(Diagnostic::new(
                format!("`str` has no method `{other}`"),
                span,
            )),
        }
    }

    /// `xs.m(k=...)` — method calls carrying keyword arguments (`xs.sort(key=..., reverse=...)`).
    pub(super) fn gen_method_call_kw(
        &mut self,
        target: &Expr,
        method: &str,
        pos_args: &[Expr],
        kw_args: &[(String, Expr, Span)],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if let ExprKind::Var(vname) = &target.kind {
            if let Some(entry) = self.lookup_var(vname).cloned() {
                if let Type::Array(_) = &entry.ty {
                    return match method {
                        "sort" => self.gen_list_sort(target, pos_args, kw_args, span, out),
                        other => Err(Diagnostic::new(
                            format!(
                                "`{}` has no method `{other}` accepting keyword arguments",
                                entry.ty.name()
                            ),
                            span,
                        )),
                    };
                }
                if let Type::Struct(sname) = &entry.ty {
                    let sig = self
                        .methods
                        .get(&(sname.clone(), method.to_string()))
                        .cloned()
                        .ok_or_else(|| {
                            Diagnostic::new(
                                format!("class/struct `{sname}` has no method `{method}`"),
                                span,
                            )
                        })?;
                    let _ = sig;
                    return Err(Diagnostic::new(
                        format!(
                            "`{sname}.{method}()` does not accept keyword arguments; pass them positionally"
                        ),
                        span,
                    ));
                }
            }
        }
        Err(Diagnostic::new(
            format!("`{method}()` does not accept keyword arguments here"),
            span,
        ))
    }

    pub(super) fn gen_any_method(
        &mut self,
        any_val: &str,
        method: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.mark_runtime_type(&Type::Any);
        self.used_any_rt = true;
        let tag = self.next_tmp();
        let _ = writeln!(out, "  {tag} = extractvalue %ArchxAny {any_val}, 0");
        let w1 = self.next_tmp();
        let _ = writeln!(out, "  {w1} = extractvalue %ArchxAny {any_val}, 1");

        match method {
            "append" => {
                if args.len() != 1 {
                    return Err(Diagnostic::new(
                        "`list.append()` takes exactly 1 argument",
                        span,
                    ));
                }
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 5");
                self.emit_type_guard(&ok, "`.append()` requires a `list` value", out);
                let item = self.eval_owned_for_slot(&Type::Any, &args[0], out)?;
                let raw = self.next_tmp();
                let _ = writeln!(out, "  {raw} = and i64 {w1}, -4");
                let cell = self.next_tmp();
                let _ = writeln!(out, "  {cell} = inttoptr i64 {raw} to ptr");
                let vec = self.next_tmp();
                let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {cell}, align 8");
                let len = self.next_tmp();
                let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
                let cap = self.next_tmp();
                let _ = writeln!(out, "  {cap} = extractvalue %ArchxVec {vec}, 1");
                let data = self.next_tmp();
                let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");

                let is_reg = self.next_tmp();
                let _ = writeln!(out, "  {is_reg} = icmp slt i64 {cap}, 0");
                let neg_c = self.next_tmp();
                let _ = writeln!(out, "  {neg_c} = sub nsw i64 0, {cap}");
                let eff_cap = self.next_tmp();
                let _ = writeln!(out, "  {eff_cap} = select i1 {is_reg}, i64 {neg_c}, i64 {cap}");
                let full = self.next_tmp();
                let _ = writeln!(out, "  {full} = icmp sge i64 {len}, {eff_cap}");
                let grow_lbl = self.fresh_label("aapp.grow");
                let store_lbl = self.fresh_label("aapp.store");
                let keep_lbl = self.fresh_label("aapp.keep");
                self.emit_cond_br(&full, &grow_lbl, &keep_lbl, out);

                self.start_block(&keep_lbl, out);
                self.emit_br(&store_lbl, out);

                self.start_block(&grow_lbl, out);
                let z = self.next_tmp();
                let _ = writeln!(out, "  {z} = icmp eq i64 {eff_cap}, 0");
                let dbl = self.next_tmp();
                let _ = writeln!(out, "  {dbl} = shl i64 {eff_cap}, 1");
                let ncap = self.next_tmp();
                let _ = writeln!(out, "  {ncap} = select i1 {z}, i64 4, i64 {dbl}");
                let nbytes = self.emit_elem_bytes_mul(&ncap, 24, out);
                let ndata = self.emit_checked_malloc(&nbytes, out);
                let has_old = self.next_tmp();
                let _ = writeln!(out, "  {has_old} = icmp sgt i64 {len}, 0");
                let cp_lbl = self.fresh_label("aapp.cp");
                let fr_lbl = self.fresh_label("aapp.fr");
                let gr_done = self.fresh_label("aapp.gdone");
                self.emit_cond_br(&has_old, &cp_lbl, &fr_lbl, out);
                self.start_block(&cp_lbl, out);
                let obytes = self.next_tmp();
                let _ = writeln!(out, "  {obytes} = mul i64 {len}, 24");
                self.used_memcpy = true;
                let _ = writeln!(
                    out,
                    "  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 {ndata}, ptr nonnull align 8 {data}, i64 {obytes}, i1 false)"
                );
                self.emit_br(&fr_lbl, out);
                self.start_block(&fr_lbl, out);
                let was_heap = self.next_tmp();
                let _ = writeln!(out, "  {was_heap} = icmp sgt i64 {cap}, 0");
                let do_fr = self.fresh_label("aapp.dofr");
                self.emit_cond_br(&was_heap, &do_fr, &gr_done, out);
                self.start_block(&do_fr, out);
                self.used_free = true;
                let _ = writeln!(out, "  call void @free(ptr {data})");
                self.emit_br(&gr_done, out);
                self.start_block(&gr_done, out);
                self.emit_br(&store_lbl, out);

                self.start_block(&store_lbl, out);
                let d_phi = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {d_phi} = phi ptr [ {data}, %{keep_lbl} ], [ {ndata}, %{gr_done} ]"
                );
                let c_phi = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {c_phi} = phi i64 [ {cap}, %{keep_lbl} ], [ {ncap}, %{gr_done} ]"
                );
                let ep = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {ep} = getelementptr inbounds %ArchxAny, ptr {d_phi}, i64 {len}"
                );
                let _ = writeln!(out, "  store %ArchxAny {item}, ptr {ep}, align 8");
                let nlen = self.next_tmp();
                let _ = writeln!(out, "  {nlen} = add nuw nsw i64 {len}, 1");
                let nvec = self.build_vec_val(&nlen, &c_phi, &d_phi, out);
                let _ = writeln!(out, "  store %ArchxVec {nvec}, ptr {cell}, align 8");
                Ok((Type::Void, String::new()))
            }
            "get" | "keys" | "values" => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 6");
                self.emit_type_guard(&ok, "dict method called on non-dict dynamic value", out);
                self.gen_dict_method(&Type::Any, &Type::Any, &w1, method, args, span, out)
            }
            "pop" if !args.is_empty() => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 6");
                self.emit_type_guard(&ok, "`dict.pop(k)` requires a `dict` value", out);
                self.gen_dict_method(&Type::Any, &Type::Any, &w1, "pop", args, span, out)
            }
            "pop" => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 5");
                self.emit_type_guard(&ok, "`list.pop()` requires a `list` value", out);
                self.used_pop_empty_fail = true;
                let raw = self.next_tmp();
                let _ = writeln!(out, "  {raw} = and i64 {w1}, -4");
                let cell = self.next_tmp();
                let _ = writeln!(out, "  {cell} = inttoptr i64 {raw} to ptr");
                let vec = self.next_tmp();
                let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {cell}, align 8");
                let len = self.next_tmp();
                let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
                let empty = self.next_tmp();
                let _ = writeln!(out, "  {empty} = icmp sle i64 {len}, 0");
                let fail_lbl = self.fresh_label("apop.empty");
                let ok_lbl = self.fresh_label("apop.ok");
                self.emit_cond_br(&empty, &fail_lbl, &ok_lbl, out);
                self.start_block(&fail_lbl, out);
                let _ = writeln!(out, "  call void @archx_pop_empty_fail()");
                let _ = writeln!(out, "  unreachable");
                self.start_block(&ok_lbl, out);
                let nlen = self.next_tmp();
                let _ = writeln!(out, "  {nlen} = sub nsw i64 {len}, 1");
                let data = self.next_tmp();
                let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");
                let ep = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {ep} = getelementptr inbounds %ArchxAny, ptr {data}, i64 {nlen}"
                );
                let ev = self.next_tmp();
                let _ = writeln!(out, "  {ev} = load %ArchxAny, ptr {ep}, align 8");
                let vec2 = self.next_tmp();
                let _ = writeln!(out, "  {vec2} = insertvalue %ArchxVec {vec}, i64 {nlen}, 0");
                let _ = writeln!(out, "  store %ArchxVec {vec2}, ptr {cell}, align 8");
                self.stmt_temps.push(TempDrop {
                    val: ev.clone(),
                    ty: Type::Any,
                });
                Ok((Type::Any, ev))
            }
            "add" | "remove" | "discard" => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 7");
                self.emit_type_guard(&ok, "set method called on non-set dynamic value", out);
                self.gen_set_method(&Type::Any, &w1, method, args, span, out)
            }
            "strip" | "upper" | "lower" | "startswith" | "endswith" | "find" | "replace"
            | "split" => {
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, 4");
                self.emit_type_guard(&ok, "string method called on non-str dynamic value", out);
                let w2 = self.next_tmp();
                let _ = writeln!(out, "  {w2} = extractvalue %ArchxAny {any_val}, 2");
                let s0 = self.next_tmp();
                let _ = writeln!(out, "  {s0} = insertvalue %ArchxStr poison, i64 {w1}, 0");
                let s1 = self.next_tmp();
                let _ = writeln!(out, "  {s1} = insertvalue %ArchxStr {s0}, i64 {w2}, 1");
                self.gen_str_method(&s1, method, args, span, out)
            }
            other => Err(Diagnostic::new(
                format!("dynamic `any` value has no supported method `{other}`"),
                span,
            )),
        }
    }
}

fn extract_struct_from_mangled(ir_name: &str) -> &str {
    // Format: `@archx_method_{len}_{StructName}_{MethodName}`
    let rest = ir_name
        .strip_prefix("@archx_method_")
        .expect("valid method symbol");
    let (len_str, after_len) = rest.split_once('_').expect("length prefix");
    let slen: usize = len_str.parse().expect("valid struct length");
    &after_len[..slen]
}
