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
        self.mutated_vars =
            collect_mutated_vars(&func.params, &func.body, &self.mutating_method_names);
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
        // 1. In-place list mutators (`xs.append(v)`, `xs.pop()`, `xs.clear()`) on a list variable:
        if let ExprKind::Var(vname) = &target.kind {
            if let Some(entry) = self.lookup_var(vname).cloned() {
                if let Type::Array(elem_ty) = &entry.ty {
                    return match method {
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
        }

        // 3. Evaluate receiver by value:
        let (target_ty, target_val) = self.eval_expr(target, out)?;
        match &target_ty {
            Type::Str => self.gen_str_method(&target_val, method, args, span, out),
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
            let (ty, val) = self.eval_expr_typed(arg, Some(&sig.params[i]), out)?;
            if ty != sig.params[i] {
                return Err(Diagnostic::new(
                    format!(
                        "method argument {} expects `{}`, found `{}`",
                        i + 1,
                        sig.params[i].name(),
                        ty.name()
                    ),
                    arg.span,
                ));
            }
            arg_vals.push((ty, val));
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
