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
        self.sort_tmp_bytes = 0;
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
        // `"{}-{}".format(a, b)`: expand the literal template into a concatenation. Doing it
        // here (rather than in `gen_str_method`) keeps the template text available.
        if method == "format" {
            if let ExprKind::Str(template) = &target.kind {
                return self.gen_str_format(template, args, span, out);
            }
        }

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
                        "reverse" => {
                            if !args.is_empty() {
                                return Err(Diagnostic::new(
                                    "`list.reverse()` takes 0 arguments",
                                    span,
                                ));
                            }
                            self.emit_list_reverse_var(vname, &entry, elem_ty, span, out)
                        }
                        "extend" => {
                            if args.len() != 1 {
                                return Err(Diagnostic::new(
                                    "`list.extend()` takes exactly 1 argument",
                                    span,
                                ));
                            }
                            self.emit_list_extend_var(vname, &entry, elem_ty, &args[0], span, out)
                        }
                        "insert" => {
                            if args.len() != 2 {
                                return Err(Diagnostic::new(
                                    "`list.insert()` takes exactly 2 arguments: `insert(index, value)`",
                                    span,
                                ));
                            }
                            self.emit_list_insert_var(vname, &entry, elem_ty, &args[0], &args[1], span, out)
                        }
                        "remove" => {
                            if args.len() != 1 {
                                return Err(Diagnostic::new(
                                    "`list.remove()` takes exactly 1 argument",
                                    span,
                                ));
                            }
                            self.emit_list_remove_var(vname, &entry, elem_ty, &args[0], span, out)
                        }
                        "index" => {
                            if args.len() != 1 {
                                return Err(Diagnostic::new(
                                    "`list.index()` takes exactly 1 argument",
                                    span,
                                ));
                            }
                            let found = self.emit_list_scan_var(vname, &entry, elem_ty, &args[0], span, out, true)?;
                            Ok((Type::Int, found))
                        }
                        "count" => {
                            if args.len() != 1 {
                                return Err(Diagnostic::new(
                                    "`list.count()` takes exactly 1 argument",
                                    span,
                                ));
                            }
                            let found = self.emit_list_scan_var(vname, &entry, elem_ty, &args[0], span, out, false)?;
                            Ok((Type::Int, found))
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

    /// `xs.reverse()` — in-place, element-width agnostic (records are moved, not copied).
    fn emit_list_reverse_var(
        &mut self,
        arr_name: &str,
        entry: &VarEntry,
        elem_ty: &Type,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if entry.is_param {
            return Err(Diagnostic::new(
                format!("cannot `reverse` borrowed parameter `{arr_name}`"),
                span,
            ));
        }
        let VarStorage::Slot(slot_ptr) = &entry.storage else {
            return Err(Diagnostic::new(
                format!("internal error: reversed list `{arr_name}` lacked a slot"),
                span,
            ));
        };
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");
        let sz = self.emit_elem_sizeof(elem_ty, out);
        let tmp = {
            let t = self.next_slot("rev.tmp");
            let _ = writeln!(self.allocas, "  {t} = alloca [16 x i8], align 8");
            t
        };
        let i_slot = self.next_slot("rev.i");
        let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
        let cond = self.fresh_label("rev.cond");
        let body = self.fresh_label("rev.body");
        let done = self.fresh_label("rev.done");
        self.emit_br(&cond, out);
        self.start_block(&cond, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
        let half = self.next_tmp();
        let _ = writeln!(out, "  {half} = lshr i64 {len}, 1");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {half}");
        self.emit_cond_br(&more, &body, &done, out);
        self.start_block(&body, out);
        let j = self.next_tmp();
        let _ = writeln!(out, "  {j} = sub nsw i64 {len}, 1");
        let j2 = self.next_tmp();
        let _ = writeln!(out, "  {j2} = sub nsw i64 {j}, {i}");
        let bi = self.next_tmp();
        let _ = writeln!(out, "  {bi} = mul nuw nsw i64 {i}, {sz}");
        let bj = self.next_tmp();
        let _ = writeln!(out, "  {bj} = mul nuw nsw i64 {j2}, {sz}");
        let pi = self.next_tmp();
        let _ = writeln!(out, "  {pi} = getelementptr inbounds i8, ptr {data}, i64 {bi}");
        let pj = self.next_tmp();
        let _ = writeln!(out, "  {pj} = getelementptr inbounds i8, ptr {data}, i64 {bj}");
        self.used_memcpy = true;
        let _ = writeln!(out, "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {tmp}, ptr align 8 {pi}, i64 {sz}, i1 false)");
        let _ = writeln!(out, "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {pi}, ptr align 8 {pj}, i64 {sz}, i1 false)");
        let _ = writeln!(out, "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {pj}, ptr align 8 {tmp}, i64 {sz}, i1 false)");
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {i_slot}, align 8");
        self.emit_br(&cond, out);
        self.start_block(&done, out);
        Ok((Type::Void, String::new()))
    }

    /// `xs.extend(ys)` — appends every element of another list of the same element type.
    fn emit_list_extend_var(
        &mut self,
        arr_name: &str,
        entry: &VarEntry,
        elem_ty: &Type,
        src: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if entry.is_param {
            return Err(Diagnostic::new(
                format!("cannot `extend` borrowed parameter `{arr_name}`"),
                span,
            ));
        }
        let (sty, svec) = self.eval_expr(src, out)?;
        if sty != entry.ty {
            return Err(Diagnostic::new(
                format!(
                    "`extend()` expects `{}`, found `{}`",
                    entry.ty.name(),
                    sty.name()
                ),
                span,
            ));
        }
        let slen = self.next_tmp();
        let _ = writeln!(out, "  {slen} = extractvalue %ArchxVec {svec}, 0");
        let sdata = self.next_tmp();
        let _ = writeln!(out, "  {sdata} = extractvalue %ArchxVec {svec}, 2");
        let sz = self.emit_elem_sizeof(elem_ty, out);
        let i_slot = self.next_slot("ext.i");
        let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
        let cond = self.fresh_label("ext.cond");
        let body = self.fresh_label("ext.body");
        let done = self.fresh_label("ext.done");
        self.emit_br(&cond, out);
        self.start_block(&cond, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {slen}");
        self.emit_cond_br(&more, &body, &done, out);
        self.start_block(&body, out);
        let off = self.next_tmp();
        let _ = writeln!(out, "  {off} = mul nuw nsw i64 {i}, {sz}");
        let ep = self.next_tmp();
        let _ = writeln!(out, "  {ep} = getelementptr inbounds i8, ptr {sdata}, i64 {off}");
        let loaded = self.emit_elem_load(elem_ty, &ep, out);
        let owned = if self.type_needs_drop(elem_ty) {
            self.emit_clone_value(elem_ty, &loaded, out)
        } else {
            loaded
        };
        let _ = entry;
        let VarStorage::Slot(slot_ptr) = entry.storage.clone() else {
            return Err(Diagnostic::new("internal error: extend slot missing", span));
        };
        self.emit_list_push_raw(arr_name, &slot_ptr, elem_ty, &owned, out)?;
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {i_slot}, align 8");
        self.emit_br(&cond, out);
        self.start_block(&done, out);
        Ok((Type::Void, String::new()))
    }

    /// `xs.insert(i, v)` — Python clamps the index to `[0, len]` and shifts the tail right.
    fn emit_list_insert_var(
        &mut self,
        arr_name: &str,
        entry: &VarEntry,
        elem_ty: &Type,
        idx: &Expr,
        value: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if entry.is_param {
            return Err(Diagnostic::new(
                format!("cannot `insert` into borrowed parameter `{arr_name}`"),
                span,
            ));
        }
        let (ity, ival) = self.eval_expr(idx, out)?;
        if ity != Type::Int {
            return Err(Diagnostic::new(
                format!("`insert()` index must be `int`, found `{}`", ity.name()),
                span,
            ));
        }
        // Grow first, then shift: `push` is the only grower, so append a copy and move it.
        let VarStorage::Slot(slot_ptr) = entry.storage.clone() else {
            return Err(Diagnostic::new(
                format!("internal error: inserted-into list `{arr_name}` lacked a slot"),
                span,
            ));
        };
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");

        // Clamp: negative indexes count from the end, then clamp to [0, len].
        let neg = self.next_tmp();
        let _ = writeln!(out, "  {neg} = icmp slt i64 {ival}, 0");
        let shifted_i = self.next_tmp();
        let _ = writeln!(out, "  {shifted_i} = add nsw i64 {ival}, {len}");
        let from_end = self.next_tmp();
        let _ = writeln!(out, "  {from_end} = select i1 {neg}, i64 {shifted_i}, i64 {ival}");
        let too_low = self.next_tmp();
        let _ = writeln!(out, "  {too_low} = icmp slt i64 {from_end}, 0");
        let lo_ok = self.next_tmp();
        let _ = writeln!(out, "  {lo_ok} = select i1 {too_low}, i64 0, i64 {from_end}");
        let too_high = self.next_tmp();
        let _ = writeln!(out, "  {too_high} = icmp sgt i64 {lo_ok}, {len}");
        let pos = self.next_tmp();
        let _ = writeln!(out, "  {pos} = select i1 {too_high}, i64 {len}, i64 {lo_ok}");

        let (vty, vval) = self.eval_expr_typed(value, Some(elem_ty), out)?;
        let owned = if vty == *elem_ty {
            if self.type_needs_drop(elem_ty) {
                if self.claim_stmt_temp(&vval) {
                    vval
                } else {
                    self.emit_clone_value(elem_ty, &vval, out)
                }
            } else {
                vval
            }
        } else {
            return Err(Diagnostic::new(
                format!(
                    "`insert()` value must be `{}`, found `{}`",
                    elem_ty.name(),
                    vty.name()
                ),
                span,
            ));
        };
        self.emit_list_push_raw(arr_name, &slot_ptr, elem_ty, &owned, out)?;

        // Now shift [pos, len) one slot right and store the value at `pos`.
        let entry2 = self
            .lookup_var(arr_name)
            .cloned()
            .ok_or_else(|| Diagnostic::new(format!("undefined variable `{arr_name}`"), span))?;
        let VarStorage::Slot(slot2) = entry2.storage else {
            return Err(Diagnostic::new("internal error: insert slot vanished", span));
        };
        let vec2 = self.next_tmp();
        let _ = writeln!(out, "  {vec2} = load %ArchxVec, ptr {slot2}, align 8");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec2}, 2");
        let sz = self.emit_elem_sizeof(elem_ty, out);
        let j_slot = self.next_slot("ins.j");
        let _ = writeln!(self.allocas, "  {j_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 {len}, ptr {j_slot}, align 8");
        let cond = self.fresh_label("iins.cond");
        let body = self.fresh_label("iins.body");
        let done = self.fresh_label("iins.done");
        self.emit_br(&cond, out);
        self.start_block(&cond, out);
        let j = self.next_tmp();
        let _ = writeln!(out, "  {j} = load i64, ptr {j_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp sgt i64 {j}, {pos}");
        self.emit_cond_br(&more, &body, &done, out);
        self.start_block(&body, out);
        let dst_off = self.next_tmp();
        let _ = writeln!(out, "  {dst_off} = mul nuw nsw i64 {j}, {sz}");
        let src_i = self.next_tmp();
        let _ = writeln!(out, "  {src_i} = sub nsw i64 {j}, 1");
        let src_off = self.next_tmp();
        let _ = writeln!(out, "  {src_off} = mul nuw nsw i64 {src_i}, {sz}");
        let dp = self.next_tmp();
        let _ = writeln!(out, "  {dp} = getelementptr inbounds i8, ptr {data}, i64 {dst_off}");
        let sp = self.next_tmp();
        let _ = writeln!(out, "  {sp} = getelementptr inbounds i8, ptr {data}, i64 {src_off}");
        self.used_memcpy = true;
        let _ = writeln!(out, "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {dp}, ptr align 8 {sp}, i64 {sz}, i1 false)");
        let nj = self.next_tmp();
        let _ = writeln!(out, "  {nj} = sub nsw i64 {j}, 1");
        let _ = writeln!(out, "  store i64 {nj}, ptr {j_slot}, align 8");
        self.emit_br(&cond, out);
        self.start_block(&done, out);
        let dst_off2 = self.next_tmp();
        let _ = writeln!(out, "  {dst_off2} = mul nuw nsw i64 {pos}, {sz}");
        let store_p = self.next_tmp();
        let _ = writeln!(out, "  {store_p} = getelementptr inbounds i8, ptr {data}, i64 {dst_off2}");
        self.emit_elem_store(elem_ty, &owned, &store_p, out);
        Ok((Type::Void, String::new()))
    }

    /// `xs.remove(v)` — drops the first equal element and shifts the tail left.
    fn emit_list_remove_var(
        &mut self,
        arr_name: &str,
        entry: &VarEntry,
        elem_ty: &Type,
        value: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if entry.is_param {
            return Err(Diagnostic::new(
                format!("cannot `remove` from borrowed parameter `{arr_name}`"),
                span,
            ));
        }
        if !matches!(elem_ty, Type::Int | Type::Float | Type::Bool | Type::Str) {
            return Err(Diagnostic::new(
                format!("`remove()` is only supported for scalar element lists, found `{}`", elem_ty.name()),
                span,
            ));
        }
        let VarStorage::Slot(slot_ptr) = entry.storage.clone() else {
            return Err(Diagnostic::new("internal error: remove slot missing", span));
        };
        let (vty, vval) = self.eval_expr_typed(value, Some(elem_ty), out)?;
        if vty != *elem_ty {
            return Err(Diagnostic::new(
                format!("`remove()` value must be `{}`, found `{}`", elem_ty.name(), vty.name()),
                span,
            ));
        }
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");
        let sz = self.emit_elem_sizeof(elem_ty, out);

        let i_slot = self.next_slot("rem.i");
        let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
        let found_slot = self.next_slot("rem.found");
        let _ = writeln!(self.allocas, "  {found_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 -1, ptr {found_slot}, align 8");

        let cond = self.fresh_label("rem.cond");
        let body = self.fresh_label("rem.body");
        let after = self.fresh_label("rem.after");
        self.emit_br(&cond, out);
        self.start_block(&cond, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len}");
        self.emit_cond_br(&more, &body, &after, out);
        self.start_block(&body, out);
        let off = self.next_tmp();
        let _ = writeln!(out, "  {off} = mul nuw nsw i64 {i}, {sz}");
        let ep = self.next_tmp();
        let _ = writeln!(out, "  {ep} = getelementptr inbounds i8, ptr {data}, i64 {off}");
        let cur = self.emit_elem_load(elem_ty, &ep, out);
        let eq = self.emit_equality(elem_ty, &cur, elem_ty, &vval, span, out)?;
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {i_slot}, align 8");
        let hit = self.fresh_label("rem.hit");
        let miss = self.fresh_label("rem.miss");
        self.emit_cond_br(&eq, &hit, &miss, out);
        self.start_block(&hit, out);
        let _ = writeln!(out, "  store i64 {i}, ptr {found_slot}, align 8");
        self.emit_br(&after, out);
        self.start_block(&miss, out);
        self.emit_br(&cond, out);
        self.start_block(&after, out);

        let found = self.next_tmp();
        let _ = writeln!(out, "  {found} = load i64, ptr {found_slot}, align 8");
        let none = self.next_tmp();
        let _ = writeln!(out, "  {none} = icmp slt i64 {found}, 0");
        let fail_lbl = self.fresh_label("rem.fail");
        let ok_lbl = self.fresh_label("rem.ok");
        self.emit_cond_br(&none, &fail_lbl, &ok_lbl, out);
        self.start_block(&fail_lbl, out);
        // `list.remove(x)` on a missing value is a ValueError in Python.
        self.used_value_missing_fail = true;
        let _ = writeln!(out, "  call void @archx_value_missing_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;
        self.start_block(&ok_lbl, out);

        // Shift [found + 1, len) left by one slot, then shrink the length.
        let k_slot = self.next_slot("rem.k");
        let _ = writeln!(self.allocas, "  {k_slot} = alloca i64, align 8");
        let k0 = self.next_tmp();
        let _ = writeln!(out, "  {k0} = add nsw i64 {found}, 1");
        let _ = writeln!(out, "  store i64 {k0}, ptr {k_slot}, align 8");
        let scond = self.fresh_label("rem.scond");
        let sbody = self.fresh_label("rem.sbody");
        let sdone = self.fresh_label("rem.sdone");
        self.emit_br(&scond, out);
        self.start_block(&scond, out);
        let k = self.next_tmp();
        let _ = writeln!(out, "  {k} = load i64, ptr {k_slot}, align 8");
        let kmore = self.next_tmp();
        let _ = writeln!(out, "  {kmore} = icmp slt i64 {k}, {len}");
        self.emit_cond_br(&kmore, &sbody, &sdone, out);
        self.start_block(&sbody, out);
        // Compact leftwards: `data[k - 1] = data[k]` for k in (found, len).
        let km1 = self.next_tmp();
        let _ = writeln!(out, "  {km1} = sub nsw i64 {k}, 1");
        let doff = self.next_tmp();
        let _ = writeln!(out, "  {doff} = mul nuw nsw i64 {km1}, {sz}");
        let soff = self.next_tmp();
        let _ = writeln!(out, "  {soff} = mul nuw nsw i64 {k}, {sz}");
        let dp = self.next_tmp();
        let _ = writeln!(out, "  {dp} = getelementptr inbounds i8, ptr {data}, i64 {doff}");
        let sp = self.next_tmp();
        let _ = writeln!(out, "  {sp} = getelementptr inbounds i8, ptr {data}, i64 {soff}");
        self.used_memcpy = true;
        let _ = writeln!(out, "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {dp}, ptr align 8 {sp}, i64 {sz}, i1 false)");
        let nk = self.next_tmp();
        let _ = writeln!(out, "  {nk} = add nuw nsw i64 {k}, 1");
        let _ = writeln!(out, "  store i64 {nk}, ptr {k_slot}, align 8");
        self.emit_br(&scond, out);
        self.start_block(&sdone, out);

        let nlen = self.next_tmp();
        let _ = writeln!(out, "  {nlen} = sub nsw i64 {len}, 1");
        let cap = self.next_tmp();
        let _ = writeln!(out, "  {cap} = extractvalue %ArchxVec {vec}, 1");
        let nvec = self.build_vec_val(&nlen, &cap, &data, out);
        let _ = writeln!(out, "  store %ArchxVec {nvec}, ptr {slot_ptr}, align 8");
        Ok((Type::Void, String::new()))
    }

    /// `xs.index(v)` / `xs.count(v)` — one pass over a scalar element list.
    fn emit_list_scan_var(
        &mut self,
        arr_name: &str,
        entry: &VarEntry,
        elem_ty: &Type,
        value: &Expr,
        span: Span,
        out: &mut String,
        want_index: bool,
    ) -> Result<String> {
        if !matches!(elem_ty, Type::Int | Type::Float | Type::Bool | Type::Str) {
            return Err(Diagnostic::new(
                format!(
                    "`{}()` is only supported for scalar element lists, found `{}`",
                    if want_index { "index" } else { "count" },
                    elem_ty.name()
                ),
                span,
            ));
        }
        let VarStorage::Slot(slot_ptr) = entry.storage.clone() else {
            return Err(Diagnostic::new("internal error: scan slot missing", span));
        };
        let (vty, vval) = self.eval_expr_typed(value, Some(elem_ty), out)?;
        if vty != *elem_ty {
            return Err(Diagnostic::new(
                format!("value must be `{}`, found `{}`", elem_ty.name(), vty.name()),
                span,
            ));
        }
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");
        let sz = self.emit_elem_sizeof(elem_ty, out);
        let acc_slot = self.next_slot("scan.acc");
        let _ = writeln!(self.allocas, "  {acc_slot} = alloca i64, align 8");
        let init = if want_index { "-1" } else { "0" };
        let _ = writeln!(out, "  store i64 {init}, ptr {acc_slot}, align 8");
        let i_slot = self.next_slot("scan.i");
        let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
        let cond = self.fresh_label("scan.cond");
        let body = self.fresh_label("scan.body");
        let done = self.fresh_label("scan.done");
        self.emit_br(&cond, out);
        self.start_block(&cond, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len}");
        self.emit_cond_br(&more, &body, &done, out);
        self.start_block(&body, out);
        let off = self.next_tmp();
        let _ = writeln!(out, "  {off} = mul nuw nsw i64 {i}, {sz}");
        let ep = self.next_tmp();
        let _ = writeln!(out, "  {ep} = getelementptr inbounds i8, ptr {data}, i64 {off}");
        let cur = self.emit_elem_load(elem_ty, &ep, out);
        let eq = self.emit_equality(elem_ty, &cur, elem_ty, &vval, span, out)?;
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {i_slot}, align 8");
        let hit = self.fresh_label("scan.hit");
        let miss = self.fresh_label("scan.miss");
        let after = self.fresh_label("scan.after");
        self.emit_cond_br(&eq, &hit, &miss, out);
        self.start_block(&hit, out);
        if want_index {
            let _ = writeln!(out, "  store i64 {i}, ptr {acc_slot}, align 8");
            self.emit_br(&done, out);
        } else {
            let c = self.next_tmp();
            let _ = writeln!(out, "  {c} = load i64, ptr {acc_slot}, align 8");
            let c1 = self.next_tmp();
            let _ = writeln!(out, "  {c1} = add nuw nsw i64 {c}, 1");
            let _ = writeln!(out, "  store i64 {c1}, ptr {acc_slot}, align 8");
            self.emit_br(&after, out);
            self.start_block(&after, out);
            self.emit_br(&cond, out);
        }
        self.start_block(&miss, out);
        self.emit_br(&cond, out);
        self.start_block(&done, out);
        let acc = self.next_tmp();
        let _ = writeln!(out, "  {acc} = load i64, ptr {acc_slot}, align 8");
        Ok(acc)
    }

    // ---------------- Python String Methods ----------------------------------

    /// `"{}-{}".format(a, b)` — expand a literal template into `str` pieces and values.
    ///
    /// Supports `{}` (auto-numbered), `{N}` (indexed), `{N:spec}` (format spec, same rules as an
    /// f-string), `{{`/`}}` escapes, and `{name}` for a keyword-free named form (rejected, since
    /// `str.format` keyword arguments would need dict support).
    pub(super) fn gen_str_format(
        &mut self,
        template: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let mut acc: Option<String> = None;
        let mut next_auto = 0usize;
        let mut literal = String::new();
        let chars: Vec<char> = template.chars().collect();
        let mut i = 0usize;

        let mut push_lit = |lit: &str, cg: &mut Self, acc: &mut Option<String>, out: &mut String| {
            if lit.is_empty() {
                return;
            }
            let lit_expr = Expr {
                kind: ExprKind::Str(lit.to_string()),
                span,
            };
            let seg = cg.eval_expr(&lit_expr, out).map(|(_, v)| v).unwrap_or_default();
            *acc = Some(match acc.take() {
                None => seg,
                Some(prev) => cg.emit_str_concat_call(&prev, &seg, out),
            });
        };

        while i < chars.len() {
            let c = chars[i];
            if c == '{' {
                if chars.get(i + 1) == Some(&'{') {
                    literal.push('{');
                    i += 2;
                    continue;
                }
                // Collect the field text up to the closing brace.
                let mut field = String::new();
                i += 1;
                while i < chars.len() && chars[i] != '}' {
                    field.push(chars[i]);
                    i += 1;
                }
                if i >= chars.len() {
                    return Err(Diagnostic::new("unterminated `{` in `str.format` template", span));
                }
                i += 1; // consume `}`
                let (index_part, spec_part) = match field.find(':') {
                    Some(k) => (field[..k].to_string(), Some(field[k + 1..].to_string())),
                    None => (field.clone(), None),
                };
                let idx = if index_part.is_empty() {
                    let n = next_auto;
                    next_auto += 1;
                    n
                } else {
                    next_auto += 1;
                    index_part.parse::<usize>().map_err(|_| {
                        Diagnostic::new(
                            format!("`str.format` field `{{{field}}}` must be `{{}}`, `{{N}}` or `{{N:spec}}`"),
                            span,
                        )
                    })?
                };
                if idx >= args.len() {
                    return Err(Diagnostic::new(
                        format!(
                            "`str.format` field {idx} has no matching argument ({} given)",
                            args.len()
                        ),
                        span,
                    ));
                }
                push_lit(&literal, self, &mut acc, out);
                literal.clear();
                let (ty, val) = self.eval_expr(&args[idx], out)?;
                let seg = match spec_part {
                    Some(spec) if !spec.is_empty() => {
                        self.emit_value_to_str_spec(&ty, &val, &spec, span, out)?
                    }
                    _ => self.emit_value_to_str(&ty, &val, span, out)?,
                };
                acc = Some(match acc.take() {
                    None => seg,
                    Some(prev) => self.emit_str_concat_call(&prev, &seg, out),
                });
                continue;
            }
            if c == '}' {
                if chars.get(i + 1) == Some(&'}') {
                    literal.push('}');
                    i += 2;
                    continue;
                }
                return Err(Diagnostic::new("single `}` in `str.format` template", span));
            }
            literal.push(c);
            i += 1;
        }
        push_lit(&literal, self, &mut acc, out);

        self.used_str_type = true;
        // Allocate the result so its ownership is unambiguous.
        let raw = acc.unwrap_or_else(|| "{ i64 0, i64 0 }".to_string());
        let reg = self.active_region_arg();
        let res = self.next_tmp();
        let _ = writeln!(
            out,
            "  {res} = call fastcc %ArchxStr @archx_str_concat(%ArchxStr {{ i64 0, i64 0 }}, %ArchxStr {raw}, ptr {reg})"
        );
        self.used_str_concat = true;
        self.stmt_temps.push(TempDrop {
            val: res.clone(),
            ty: Type::Str,
        });
        Ok((Type::Str, res))
    }

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
            "join" => {
                if args.len() != 1 {
                    return Err(Diagnostic::new(
                        "`str.join()` takes exactly 1 argument: `sep.join(list_of_str)`",
                        span,
                    ));
                }
                // An empty literal carries no element type; `join` fixes it to `str`.
                let expected_join = Type::Array(Box::new(Type::Str));
                let (aty, avec) =
                    self.eval_expr_typed(&args[0], Some(&expected_join), out)?;
                let Type::Array(elem) = &aty else {
                    return Err(Diagnostic::new(
                        format!("`str.join()` expects a `list[str]`, found `{}`", aty.name()),
                        args[0].span,
                    ));
                };
                if **elem != Type::Str {
                    return Err(Diagnostic::new(
                        format!("`str.join()` expects a `list[str]`, found `{}`", aty.name()),
                        args[0].span,
                    ));
                }
                self.used_str_concat = true;
                self.used_str_drop = true;
                let acc_slot = self.next_slot("join.acc");
                let _ = writeln!(self.allocas, "  {acc_slot} = alloca %ArchxStr, align 8");
                // Start from the empty string so the first concatenation has a real operand.
                let _ = writeln!(out, "  store %ArchxStr {{ i64 0, i64 0 }}, ptr {acc_slot}, align 8");
                let len = self.next_tmp();
                let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {avec}, 0");
                let data = self.next_tmp();
                let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {avec}, 2");
                let i_slot = self.next_slot("join.i");
                let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
                let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
                let cond = self.fresh_label("join.cond");
                let body = self.fresh_label("join.body");
                let sep_l = self.fresh_label("join.sep");
                let elem_l = self.fresh_label("join.elem");
                let both = self.fresh_label("join.both");
                let incr = self.fresh_label("join.incr");
                let done = self.fresh_label("join.done");
                self.emit_br(&cond, out);

                self.start_block(&cond, out);
                let i = self.next_tmp();
                let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
                let more = self.next_tmp();
                let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len}");
                self.emit_cond_br(&more, &body, &done, out);

                self.start_block(&body, out);
                let ep = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {ep} = getelementptr inbounds %ArchxStr, ptr {data}, i64 {i}"
                );
                let cur = self.next_tmp();
                let _ = writeln!(out, "  {cur} = load %ArchxStr, ptr {ep}, align 8");
                let first = self.next_tmp();
                let _ = writeln!(out, "  {first} = icmp eq i64 {i}, 0");
                self.emit_cond_br(&first, &elem_l, &sep_l, out);

                // `non-first`: append the separator to the accumulator first.
                self.start_block(&sep_l, out);
                let acc_sep = self.next_tmp();
                let _ = writeln!(out, "  {acc_sep} = load %ArchxStr, ptr {acc_slot}, align 8");
                let with_sep = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {with_sep} = call fastcc %ArchxStr @archx_str_concat(%ArchxStr {acc_sep}, %ArchxStr {s_val}, ptr null)"
                );
                let _ = writeln!(out, "  call fastcc void @archx_str_drop(%ArchxStr {acc_sep})");
                let _ = writeln!(out, "  store %ArchxStr {with_sep}, ptr {acc_slot}, align 8");
                self.emit_br(&both, out);
                self.start_block(&elem_l, out);
                self.emit_br(&both, out);

                self.start_block(&both, out);
                let acc2 = self.next_tmp();
                let _ = writeln!(out, "  {acc2} = load %ArchxStr, ptr {acc_slot}, align 8");
                let joined = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {joined} = call fastcc %ArchxStr @archx_str_concat(%ArchxStr {acc2}, %ArchxStr {cur}, ptr null)"
                );
                let _ = writeln!(out, "  call fastcc void @archx_str_drop(%ArchxStr {acc2})");
                let _ = writeln!(out, "  store %ArchxStr {joined}, ptr {acc_slot}, align 8");
                self.emit_br(&incr, out);

                self.start_block(&incr, out);
                let ni = self.next_tmp();
                let _ = writeln!(out, "  {ni} = add nuw nsw i64 {i}, 1");
                let _ = writeln!(out, "  store i64 {ni}, ptr {i_slot}, align 8");
                self.emit_br(&cond, out);

                self.start_block(&done, out);
                let res = self.next_tmp();
                let _ = writeln!(out, "  {res} = load %ArchxStr, ptr {acc_slot}, align 8");
                self.stmt_temps.push(TempDrop {
                    val: res.clone(),
                    ty: Type::Str,
                });
                Ok((Type::Str, res))
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
