//! Function calls, keyword-argument calls (`print(sep=..., end=...)`, `Point(x=1, y=2)`),
//! Python type conversions (`int`, `float`, `str`, `bool`), soft math/sequence builtins
//! (`abs`, `min`, `max`, `sum`, `sqrt`, `ord`, `chr`), and core `len`/`push`/`pop`.

use std::collections::HashSet;
use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

impl Codegen {
    pub(super) fn gen_call(
        &mut self,
        name: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        // v0.9.0 — zero-allocation generator folds (`sum`/`any`/`all`/`len`/`min`/`max` over a
        // `GenExpr`) and inline `zip(...)` materialization, before any normal dispatch.
        if !self.sigs.contains_key(name) {
            if let Some(v) = self.try_gen_reduction(name, args, span, out)? {
                return Ok(v);
            }
            if name == "zip" {
                return self.eval_zip_value(args, None, span, out);
            }
            if name == "sorted" {
                return self.gen_sorted(args, &[], span, out);
            }
        }
        match name {
            "print" => return self.gen_builtin_print(args, None, None, span, out),
            "input" => return self.gen_builtin_input(args, span, out),
            "len" => return self.gen_builtin_len(args, span, out),
            "push" => return self.gen_builtin_push(args, span, out),
            "pop" => return self.gen_builtin_pop(args, span, out),
            "int" => return self.gen_conv_int(args, span, out),
            "float" => return self.gen_conv_float(args, span, out),
            "str" | "string" => return self.gen_conv_str(args, span, out),
            "bool" => return self.gen_conv_bool(args, span, out),
            _ => {}
        }

        if let Some(fields) = self.structs.get(name).cloned() {
            if let Some(init_sig) = self
                .methods
                .get(&(name.to_string(), "__init__".to_string()))
                .cloned()
            {
                if args.len() != init_sig.params.len() {
                    return Err(Diagnostic::new(
                        format!(
                            "`{name}.__init__` expects {} argument(s), found {}",
                            init_sig.params.len(),
                            args.len()
                        ),
                        span,
                    ));
                }
                let mut arg_vals = Vec::with_capacity(args.len());
                for (i, arg) in args.iter().enumerate() {
                    let pty = &init_sig.params[i];
                    if *pty == Type::Any {
                        arg_vals.push((Type::Any, self.eval_expr_as_any(arg, out)?));
                    } else {
                        let (aty, raw_v) = self.eval_expr_typed(arg, Some(pty), out)?;
                        let fv = if aty == *pty {
                            raw_v
                        } else if aty == Type::Any {
                            self.emit_unbox_any(pty, &raw_v, arg.span, out)?
                        } else {
                            return Err(Diagnostic::new(
                                format!(
                                    "argument {} of `{name}` expects `{}`, found `{}`",
                                    i + 1,
                                    pty.name(),
                                    aty.name()
                                ),
                                arg.span,
                            ));
                        };
                        arg_vals.push((pty.clone(), fv));
                    }
                }
                let s_ir = format!("%ArchxStruct_{name}");
                let cslot = self.next_slot(&format!("init.{name}"));
                let _ = writeln!(self.allocas, "  {cslot} = alloca {s_ir}, align 8");
                let _ = writeln!(out, "  store {s_ir} zeroinitializer, ptr {cslot}, align 8");
                let mut call = format!("  call fastcc void {}(ptr {cslot}", init_sig.ir_name);
                for (pty, val) in &arg_vals {
                    let _ = write!(call, ", {} {}", ir_type(pty), val);
                }
                call.push_str(")\n");
                out.push_str(&call);
                let loaded = self.next_tmp();
                let _ = writeln!(out, "  {loaded} = load {s_ir}, ptr {cslot}, align 8");
                let sty = Type::Struct(name.to_string());
                if self.type_needs_drop(&sty) {
                    self.stmt_temps.push(TempDrop {
                        val: loaded.clone(),
                        ty: sty.clone(),
                    });
                }
                return Ok((sty, loaded));
            }

            if args.len() != fields.len() {
                return Err(Diagnostic::new(
                    format!(
                        "struct `{name}` expects {} field{}, but {} {} supplied",
                        fields.len(),
                        if fields.len() == 1 { "" } else { "s" },
                        args.len(),
                        if args.len() == 1 { "was" } else { "were" }
                    ),
                    span,
                ));
            }
            let mut agg = "poison".to_string();
            for (i, arg) in args.iter().enumerate() {
                let fty = &fields[i].ty;
                let (aty, raw_val) = self.eval_expr_typed(arg, Some(fty), out)?;
                if aty != *fty {
                    return Err(Diagnostic::new(
                        format!(
                            "field `{}` of `{name}` expects `{}`, found `{}`",
                            fields[i].name,
                            fty.name(),
                            aty.name()
                        ),
                        arg.span,
                    ));
                }
                let fval = if self.type_needs_drop(fty) {
                    if self.claim_stmt_temp(&raw_val) {
                        raw_val
                    } else {
                        self.emit_clone_value(fty, &raw_val, out)
                    }
                } else {
                    raw_val
                };
                let next_agg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {next_agg} = insertvalue %ArchxStruct_{name} {agg}, {} {fval}, {i}",
                    ir_type(fty)
                );
                agg = next_agg;
            }
            let sty = Type::Struct(name.to_string());
            if self.type_needs_drop(&sty) {
                self.stmt_temps.push(TempDrop {
                    val: agg.clone(),
                    ty: sty.clone(),
                });
            }
            return Ok((sty, agg));
        }

        if name == "main" {
            return Err(Diagnostic::new("`main` cannot be called directly", span));
        }

        if let Some(sig) = self.sigs.get(name).cloned() {
            return self.emit_user_fn_call(name, &sig, args, span, out);
        }

        // Python soft builtins (shadowable by user `def`):
        match name {
            "abs" => return self.gen_builtin_abs(args, span, out),
            "divmod" => return self.gen_builtin_divmod(args, span, out),
            "round" => return self.gen_builtin_round(args, span, out),
            "hex" => return self.gen_builtin_base_str(args, 16, span, out),
            "oct" => return self.gen_builtin_base_str(args, 8, span, out),
            "bin" => return self.gen_builtin_base_str(args, 2, span, out),
            "min" => return self.gen_builtin_minmax(args, true, span, out),
            "max" => return self.gen_builtin_minmax(args, false, span, out),
            "sum" => return self.gen_builtin_sum(args, span, out),
            "sqrt" => return self.gen_builtin_sqrt(args, span, out),
            "ord" => return self.gen_builtin_ord(args, span, out),
            "chr" => return self.gen_builtin_chr(args, span, out),
            "type" => return self.gen_builtin_type(args, span, out),
            "isinstance" => return self.gen_builtin_isinstance(args, span, out),
            "dict" => return self.gen_builtin_dict_ctor(args, span, out),
            "set" => return self.gen_builtin_set_ctor(args, span, out),
            "list" => return self.gen_builtin_list_ctor(args, span, out),
            "wrapping_add" | "wrapping_sub" | "wrapping_mul" => {
                return self.gen_builtin_wrapping(name, args, span, out)
            }
            "map" | "filter" => return self.eval_map_filter(name, args, span, out),
            _ => {}
        }

        Err(Diagnostic::new(format!("undefined function `{name}`"), span))
    }

    pub(super) fn gen_call_kw(
        &mut self,
        name: &str,
        pos_args: &[Expr],
        kw_args: &[(String, Expr, Span)],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if name == "print" {
            let mut sep_expr: Option<&Expr> = None;
            let mut end_expr: Option<&Expr> = None;
            for (kw, val, kw_span) in kw_args {
                match kw.as_str() {
                    "sep" => {
                        if sep_expr.is_some() {
                            return Err(Diagnostic::new(
                                "duplicate keyword argument `sep` in `print()`",
                                *kw_span,
                            ));
                        }
                        sep_expr = Some(val);
                    }
                    "end" => {
                        if end_expr.is_some() {
                            return Err(Diagnostic::new(
                                "duplicate keyword argument `end` in `print()`",
                                *kw_span,
                            ));
                        }
                        end_expr = Some(val);
                    }
                    other => {
                        return Err(Diagnostic::new(
                            format!("`print()` got an unexpected keyword argument `{other}`"),
                            *kw_span,
                        ));
                    }
                }
            }
            return self.gen_builtin_print(pos_args, sep_expr, end_expr, span, out);
        }

        if let Some(fields) = self.structs.get(name).cloned() {
            let total_supplied = pos_args.len() + kw_args.len();
            if total_supplied != fields.len() {
                return Err(Diagnostic::new(
                    format!(
                        "class/struct `{name}` expects {} field{}, but {} {} supplied",
                        fields.len(),
                        if fields.len() == 1 { "" } else { "s" },
                        total_supplied,
                        if total_supplied == 1 { "was" } else { "were" }
                    ),
                    span,
                ));
            }
            let mut evaluated: Vec<Option<String>> = vec![None; fields.len()];
            for (i, arg) in pos_args.iter().enumerate() {
                let fty = &fields[i].ty;
                let (aty, raw_val) = self.eval_expr_typed(arg, Some(fty), out)?;
                if aty != *fty {
                    return Err(Diagnostic::new(
                        format!(
                            "field `{}` of `{name}` expects `{}`, found `{}`",
                            fields[i].name,
                            fty.name(),
                            aty.name()
                        ),
                        arg.span,
                    ));
                }
                let fval = if self.type_needs_drop(fty) {
                    if self.claim_stmt_temp(&raw_val) {
                        raw_val
                    } else {
                        self.emit_clone_value(fty, &raw_val, out)
                    }
                } else {
                    raw_val
                };
                evaluated[i] = Some(fval);
            }

            let mut seen_kw = HashSet::new();
            for (kw, val_expr, kw_span) in kw_args {
                if !seen_kw.insert(kw.as_str()) {
                    return Err(Diagnostic::new(
                        format!("duplicate keyword argument `{kw}` for `{name}`"),
                        *kw_span,
                    ));
                }
                let Some(fidx) = fields.iter().position(|f| f.name == *kw) else {
                    return Err(Diagnostic::new(
                        format!("`{name}` has no field `{kw}`"),
                        *kw_span,
                    ));
                };
                if evaluated[fidx].is_some() {
                    return Err(Diagnostic::new(
                        format!("`{name}` got multiple values for field `{kw}`"),
                        *kw_span,
                    ));
                }
                let fty = &fields[fidx].ty;
                let (aty, raw_val) = self.eval_expr_typed(val_expr, Some(fty), out)?;
                if aty != *fty {
                    return Err(Diagnostic::new(
                        format!(
                            "field `{kw}` of `{name}` expects `{}`, found `{}`",
                            fty.name(),
                            aty.name()
                        ),
                        val_expr.span,
                    ));
                }
                let fval = if self.type_needs_drop(fty) {
                    if self.claim_stmt_temp(&raw_val) {
                        raw_val
                    } else {
                        self.emit_clone_value(fty, &raw_val, out)
                    }
                } else {
                    raw_val
                };
                evaluated[fidx] = Some(fval);
            }

            let mut agg = "poison".to_string();
            for (i, f) in fields.iter().enumerate() {
                let fval = evaluated[i].as_ref().unwrap();
                let next_agg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {next_agg} = insertvalue %ArchxStruct_{name} {agg}, {} {fval}, {i}",
                    ir_type(&f.ty)
                );
                agg = next_agg;
            }
            let sty = Type::Struct(name.to_string());
            if self.type_needs_drop(&sty) {
                self.stmt_temps.push(TempDrop {
                    val: agg.clone(),
                    ty: sty.clone(),
                });
            }
            return Ok((sty, agg));
        }

        // v0.9.0 — inline monomorphized `sorted(list, key=..., reverse=...)`.
        if !self.sigs.contains_key(name) && name == "sorted" {
            return self.gen_sorted(pos_args, kw_args, span, out);
        }

        // User functions: match keywords to declared parameter names, then fill any remaining
        // slots from `def f(a: int, b: int = 3)` defaults (Python's call semantics).
        if let Some(sig) = self.sigs.get(name).cloned() {
            if kw_args.is_empty() {
                return self.emit_user_fn_call(name, &sig, pos_args, span, out);
            }
            let mut slots: Vec<Option<Expr>> = vec![None; sig.params.len()];
            if pos_args.len() > sig.params.len() {
                return Err(Diagnostic::new(
                    format!(
                        "function `{name}` expects {} argument(s), but {} were supplied",
                        sig.params.len(),
                        pos_args.len()
                    ),
                    span,
                ));
            }
            for (i, arg) in pos_args.iter().enumerate() {
                slots[i] = Some(arg.clone());
            }
            for (kw, val, kw_span) in kw_args {
                let Some(idx) = sig.param_names.iter().position(|p| p == kw) else {
                    return Err(Diagnostic::new(
                        format!("function `{name}` has no parameter named `{kw}`"),
                        *kw_span,
                    ));
                };
                if slots[idx].is_some() {
                    return Err(Diagnostic::new(
                        format!("function `{name}` got multiple values for parameter `{kw}`"),
                        *kw_span,
                    ));
                }
                slots[idx] = Some(val.clone());
            }
            let mut ordered = Vec::with_capacity(sig.params.len());
            for (i, slot) in slots.into_iter().enumerate() {
                match slot.or_else(|| sig.defaults[i].clone()) {
                    Some(e) => ordered.push(e),
                    None => {
                        return Err(Diagnostic::new(
                            format!(
                                "function `{name}` is missing a value for parameter `{}`",
                                sig.param_names[i]
                            ),
                            span,
                        ))
                    }
                }
            }
            return self.emit_user_fn_call(name, &sig, &ordered, span, out);
        }

        Err(Diagnostic::new(
            format!("keyword arguments are supported on `print()` and class/struct constructors, not `{name}()`"),
            span,
        ))
    }

    fn emit_user_fn_call(
        &mut self,
        name: &str,
        sig: &FuncSig,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        // Fill omitted trailing arguments from their declared defaults (`def f(a, b=3)`).
        let mut padded: Vec<Expr> = args.to_vec();
        if padded.len() < sig.params.len() {
            for d in &sig.defaults[padded.len()..] {
                match d {
                    Some(d) => padded.push(d.clone()),
                    None => {
                        return Err(Diagnostic::new(
                            format!(
                                "function `{name}` expects {} argument{}, but {} {} supplied",
                                sig.params.len(),
                                if sig.params.len() == 1 { "" } else { "s" },
                                args.len(),
                                if args.len() == 1 { "was" } else { "were" }
                            ),
                            span,
                        ))
                    }
                }
            }
        }
        let args: &[Expr] = &padded;
        if args.len() != sig.params.len() {
            return Err(Diagnostic::new(
                format!(
                    "function `{name}` expects {} argument{}, but {} {} supplied",
                    sig.params.len(),
                    if sig.params.len() == 1 { "" } else { "s" },
                    args.len(),
                    if args.len() == 1 { "was" } else { "were" }
                ),
                span,
            ));
        }

        let mut arg_vals = Vec::new();
        for (i, arg) in args.iter().enumerate() {
            if sig.params[i] == Type::Any {
                let aval = self.eval_expr_as_any(arg, out)?;
                arg_vals.push((Type::Any, aval));
                continue;
            }
            let (ty, val) = self.eval_expr_typed(arg, Some(&sig.params[i]), out)?;
            let final_val = if ty == sig.params[i] {
                val
            } else if ty == Type::Any {
                self.emit_unbox_any(&sig.params[i], &val, arg.span, out)?
            } else {
                return Err(Diagnostic::new(
                    format!(
                        "argument {} of `{name}` expects `{}`, found `{}`",
                        i + 1,
                        sig.params[i].name(),
                        ty.name()
                    ),
                    arg.span,
                ));
            };
            arg_vals.push((sig.params[i].clone(), final_val));
        }

        if sig.ret.is_none() {
            let mut call = format!("  call fastcc void {}(", mangle(name));
            for (i, (ty, val)) in arg_vals.iter().enumerate() {
                if i > 0 {
                    call.push_str(", ");
                }
                let _ = write!(call, "{} {}", ir_type(ty), val);
            }
            call.push_str(")\n");
            out.push_str(&call);
            return Ok((Type::Void, String::new()));
        }

        let reg = self.next_tmp();
        let ret_ir = ir_ret_type(sig.ret.as_ref());
        let mut call = format!("  {reg} = call fastcc {ret_ir} {}(", mangle(name));
        for (i, (ty, val)) in arg_vals.iter().enumerate() {
            if i > 0 {
                call.push_str(", ");
            }
            let _ = write!(call, "{} {}", ir_type(ty), val);
        }
        call.push_str(")\n");
        out.push_str(&call);

        match &sig.ret {
            Some(ty) => {
                if self.type_needs_drop(ty) {
                    self.stmt_temps.push(TempDrop {
                        val: reg.clone(),
                        ty: ty.clone(),
                    });
                }
                Ok((ty.clone(), reg))
            }
            None => Ok((Type::Void, String::new())),
        }
    }

    // ---------------- Python Type Conversions & Soft Builtins ----------------

    fn gen_conv_int(&mut self, args: &[Expr], span: Span, out: &mut String) -> Result<(Type, String)> {
        if args.is_empty() {
            return Ok((Type::Int, "0".to_string()));
        }
        if args.len() != 1 {
            return Err(Diagnostic::new("`int()` takes at most 1 argument", span));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        match ty {
            Type::Int => Ok((Type::Int, val)),
            Type::Float => {
                self.used_fptosi_sat = true;
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = call i64 @llvm.fptosi.sat.i64.f64(double {val})");
                Ok((Type::Int, r))
            }
            Type::Bool => {
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = zext i1 {val} to i64");
                Ok((Type::Int, r))
            }
            Type::Str => {
                self.used_int_from_str = true;
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = call fastcc i64 @archx_int_from_str(%ArchxStr {val})");
                Ok((Type::Int, r))
            }
            Type::Any => {
                let u = self.emit_unbox_any(&Type::Int, &val, args[0].span, out)?;
                Ok((Type::Int, u))
            }
            other => Err(Diagnostic::new(
                format!("`int()` cannot convert `{}`", other.name()),
                args[0].span,
            )),
        }
    }

    fn gen_conv_float(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.is_empty() {
            return Ok((Type::Float, format_llvm_double(0.0)));
        }
        if args.len() != 1 {
            return Err(Diagnostic::new("`float()` takes at most 1 argument", span));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        match ty {
            Type::Float => Ok((Type::Float, val)),
            Type::Int => {
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = sitofp i64 {val} to double");
                Ok((Type::Float, r))
            }
            Type::Bool => {
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = uitofp i1 {val} to double");
                Ok((Type::Float, r))
            }
            Type::Str => {
                self.used_float_from_str = true;
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc double @archx_float_from_str(%ArchxStr {val})"
                );
                Ok((Type::Float, r))
            }
            Type::Any => {
                let u = self.emit_unbox_any(&Type::Float, &val, args[0].span, out)?;
                Ok((Type::Float, u))
            }
            other => Err(Diagnostic::new(
                format!("`float()` cannot convert `{}`", other.name()),
                args[0].span,
            )),
        }
    }

    fn gen_conv_bool(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.is_empty() {
            return Ok((Type::Bool, "false".to_string()));
        }
        if args.len() != 1 {
            return Err(Diagnostic::new("`bool()` takes at most 1 argument", span));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        match ty {
            Type::Bool => Ok((Type::Bool, val)),
            Type::Void => Ok((Type::Bool, "false".to_string())),
            Type::Int => {
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = icmp ne i64 {val}, 0");
                Ok((Type::Bool, r))
            }
            Type::Float => {
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = fcmp une double {val}, 0x0000000000000000");
                Ok((Type::Bool, r))
            }
            Type::Str => {
                let w0 = self.next_tmp();
                let _ = writeln!(out, "  {w0} = extractvalue %ArchxStr {val}, 0");
                let l = self.next_tmp();
                let _ = writeln!(out, "  {l} = and i64 {w0}, 4294967295");
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = icmp ne i64 {l}, 0");
                Ok((Type::Bool, r))
            }
            Type::Array(_) => {
                let l = self.next_tmp();
                let _ = writeln!(out, "  {l} = extractvalue %ArchxVec {val}, 0");
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = icmp sgt i64 {l}, 0");
                Ok((Type::Bool, r))
            }
            Type::Tuple(items) => Ok((Type::Bool, (!items.is_empty()).to_string())),
            Type::Dict(_, _) | Type::Set(_) => {
                let l = self.emit_dict_len(&val, out);
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = icmp sgt i64 {l}, 0");
                Ok((Type::Bool, r))
            }
            Type::Any => {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = call fastcc i1 @archx_any_truthy(%ArchxAny {val})");
                Ok((Type::Bool, r))
            }
            other => Err(Diagnostic::new(
                format!("`bool()` cannot convert `{}`", other.name()),
                args[0].span,
            )),
        }
    }

    /// `round(x)` / `round(x, ndigits)`. Python rounds half to even; this shifts by a
    /// sign-aware half, floors, then undoes the shift, which is exact for the common cases.
    fn gen_builtin_round(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.is_empty() || args.len() > 2 {
            return Err(Diagnostic::new(
                "`round()` takes 1 or 2 arguments: `round(x)` or `round(x, ndigits)`",
                span,
            ));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        let ndigits: Option<i64> = if args.len() == 2 {
            match self.eval_expr(&args[1], out)? {
                (Type::Int, v) => v.parse::<i64>().ok(),
                (t, _) => {
                    return Err(Diagnostic::new(
                        format!("`round()` ndigits must be `int`, found `{}`", t.name()),
                        args[1].span,
                    ))
                }
            }
        } else {
            None
        };
        match ty {
            Type::Int => match ndigits {
                None => Ok((Type::Int, val)),
                Some(d) if d >= 0 => Ok((Type::Int, val)),
                _ => {
                    let f = self.next_tmp();
                    let _ = writeln!(out, "  {f} = sitofp i64 {val} to double");
                    let r = self.emit_round_digits(&f, ndigits, out);
                    let back = self.next_tmp();
                    let _ = writeln!(out, "  {back} = fptosi double {r} to i64");
                    Ok((Type::Int, back))
                }
            },
            Type::Float => {
                let r = self.emit_round_digits(&val, ndigits, out);
                if ndigits.is_none() {
                    let back = self.next_tmp();
                    let _ = writeln!(out, "  {back} = fptosi double {r} to i64");
                    Ok((Type::Int, back))
                } else {
                    Ok((Type::Float, r))
                }
            }
            other => Err(Diagnostic::new(
                format!("`round()` expects `int` or `float`, found `{}`", other.name()),
                args[0].span,
            )),
        }
    }

    /// Round-half-away-from-zero at `ndigits` decimal places (then `floor` corrects the scale).
    fn emit_round_digits(&mut self, x: &str, ndigits: Option<i64>, out: &mut String) -> String {
        let scale = match ndigits {
            None => "1.0".to_string(),
            Some(d) => {
                let e = self.next_tmp();
                let _ = writeln!(out, "  {e} = sitofp i64 {d} to double");
                self.used_pow_f64 = true;
                let p = self.next_tmp();
                let _ = writeln!(out, "  {p} = call double @llvm.pow.f64(double 1.0e1, double {e})");
                p
            }
        };
        let scaled = self.next_tmp();
        let _ = writeln!(out, "  {scaled} = fmul double {x}, {scale}");
        // `llvm.rint.f64` is round-half-to-even in the default FP environment, which is exactly
        // CPython's `round()` tie rule (`round(2.5) == 2`, `round(3.5) == 4`, `round(-2.5) == -2`).
        self.used_rint_f64 = true;
        let rounded = self.next_tmp();
        let _ = writeln!(out, "  {rounded} = call double @llvm.rint.f64(double {scaled})");
        let back = self.next_tmp();
        let _ = writeln!(out, "  {back} = fdiv double {rounded}, {scale}");
        back
    }

    /// `hex(n)`, `oct(n)`, `bin(n)` — Python's prefixed two's-complement representation.
    fn gen_builtin_base_str(
        &mut self,
        args: &[Expr],
        base: u32,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let name = match base {
            16 => "hex",
            8 => "oct",
            _ => "bin",
        };
        if args.len() != 1 {
            return Err(Diagnostic::new(
                format!("`{name}()` takes exactly 1 argument"),
                span,
            ));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        if ty != Type::Int {
            return Err(Diagnostic::new(
                format!("`{name}()` expects an `int`, found `{}`", ty.name()),
                args[0].span,
            ));
        }
        self.used_int_to_base_str = true;
        let reg_arg = self.active_region_arg();
        let r = self.next_tmp();
        let _ = writeln!(
            out,
            "  {r} = call fastcc %ArchxStr @archx_int_to_base_str(i64 {val}, i32 {base}, ptr {reg_arg})"
        );
        self.stmt_temps.push(TempDrop {
            val: r.clone(),
            ty: Type::Str,
        });
        Ok((Type::Str, r))
    }

    /// `divmod(a, b)` — Python's floored quotient/remainder pair.
    fn gen_builtin_divmod(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 2 {
            return Err(Diagnostic::new("`divmod()` takes exactly 2 arguments", span));
        }
        let (aty, av) = self.eval_expr(&args[0], out)?;
        let (bty, bv) = self.eval_expr(&args[1], out)?;
        if aty != Type::Int || bty != Type::Int {
            return Err(Diagnostic::new(
                format!(
                    "`divmod()` expects two `int`s, found `{}` and `{}`",
                    aty.name(),
                    bty.name()
                ),
                span,
            ));
        }
        // Reuse the operator implementations so the semantics stay in exactly one place.
        let qv = self.emit_int_arith(BinOp::FloorDiv, &av, &bv, out);
        self.used_vec_type = true;
        let tuple_ty = Type::Tuple(vec![Type::Int, Type::Int]);
        self.mark_runtime_type(&tuple_ty);
        let rv = self.emit_int_arith(BinOp::Mod, &av, &bv, out);
        let tir = ir_type(&tuple_ty);
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = insertvalue {tir} undef, i64 {qv}, 0");
        let full = self.next_tmp();
        let _ = writeln!(out, "  {full} = insertvalue {tir} {raw}, i64 {rv}, 1");
        Ok((tuple_ty, full))
    }

    fn gen_builtin_abs(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new("`abs()` takes exactly 1 argument", span));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        match ty {
            Type::Int => {
                // `abs(i64::MIN)` has no representable result, and the naive `0 - val` wraps to
                // itself, so it would return a *negative* number (AX-002: a trapping language must
                // never answer with the wrong value). The negation goes through the checked
                // intrinsic, so the one input that cannot be represented raises instead.
                self.used_int_overflow_fail = true;
                let pair = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {pair} = call {{ i64, i1 }} @llvm.ssub.with.overflow.i64(i64 0, i64 {val})"
                );
                let sub = self.next_tmp();
                let _ = writeln!(out, "  {sub} = extractvalue {{ i64, i1 }} {pair}, 0");
                let ovf = self.next_tmp();
                let _ = writeln!(out, "  {ovf} = extractvalue {{ i64, i1 }} {pair}, 1");
                let neg = self.next_tmp();
                let _ = writeln!(out, "  {neg} = icmp slt i64 {val}, 0");
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = select i1 {neg}, i64 {sub}, i64 {val}");
                let bad_lbl = self.fresh_label("abs.overflow");
                let ok_lbl = self.fresh_label("abs.ok");
                self.emit_cond_br(&ovf, &bad_lbl, &ok_lbl, out);
                self.start_block(&bad_lbl, out);
                let _ = writeln!(out, "  call void @archx_int_overflow_fail()");
                let _ = writeln!(out, "  unreachable");
                self.terminated = true;
                self.start_block(&ok_lbl, out);
                Ok((Type::Int, r))
            }
            Type::Float => {
                self.used_fabs_f64 = true;
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = call double @llvm.fabs.f64(double {val})");
                Ok((Type::Float, r))
            }
            other => Err(Diagnostic::new(
                format!("`abs()` expects `int` or `float`, found `{}`", other.name()),
                args[0].span,
            )),
        }
    }

    fn gen_builtin_sqrt(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new("`sqrt()` takes exactly 1 argument", span));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        let fval = match ty {
            Type::Float => val,
            Type::Int => {
                let c = self.next_tmp();
                let _ = writeln!(out, "  {c} = sitofp i64 {val} to double");
                c
            }
            other => {
                return Err(Diagnostic::new(
                    format!("`sqrt()` expects `float` or `int`, found `{}`", other.name()),
                    args[0].span,
                ));
            }
        };
        self.used_sqrt_f64 = true;
        let r = self.next_tmp();
        let _ = writeln!(out, "  {r} = call double @llvm.sqrt.f64(double {fval})");
        Ok((Type::Float, r))
    }

    fn gen_builtin_minmax(
        &mut self,
        args: &[Expr],
        is_min: bool,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let fn_name = if is_min { "min" } else { "max" };
        if args.is_empty() {
            return Err(Diagnostic::new(
                format!("`{fn_name}()` expects at least 1 argument"),
                span,
            ));
        }
        if args.len() == 1 {
            let (ty, vec_val) = self.eval_expr(&args[0], out)?;
            let Type::Array(elem_ty) = ty else {
                return Err(Diagnostic::new(
                    format!(
                        "single-argument `{fn_name}(seq)` requires `list[int]` or `list[float]`"
                    ),
                    args[0].span,
                ));
            };
            if !matches!(*elem_ty, Type::Int | Type::Float) {
                return Err(Diagnostic::new(
                    format!(
                        "`{fn_name}()` requires `int` or `float` elements, found `{}`",
                        elem_ty.name()
                    ),
                    args[0].span,
                ));
            }
            self.used_pop_empty_fail = true;
            let len_v = self.next_tmp();
            let _ = writeln!(out, "  {len_v} = extractvalue %ArchxVec {vec_val}, 0");
            let empty = self.next_tmp();
            let _ = writeln!(out, "  {empty} = icmp sle i64 {len_v}, 0");
            let bad_lbl = self.fresh_label("mm.empty");
            let ok_lbl = self.fresh_label("mm.ok");
            self.emit_cond_br(&empty, &bad_lbl, &ok_lbl, out);
            self.start_block(&bad_lbl, out);
            let _ = writeln!(out, "  call void @archx_pop_empty_fail()");
            let _ = writeln!(out, "  unreachable");
            self.terminated = true;

            self.start_block(&ok_lbl, out);
            let data_p = self.next_tmp();
            let _ = writeln!(out, "  {data_p} = extractvalue %ArchxVec {vec_val}, 2");
            let ty_ir = ir_type(&elem_ty);
            let first = self.next_tmp();
            let _ = writeln!(out, "  {first} = load {ty_ir}, ptr {data_p}, align 8");
            let aslot = self.next_slot("mm.acc");
            let islot = self.next_slot("mm.idx");
            let _ = writeln!(self.allocas, "  {aslot} = alloca {ty_ir}, align 8");
            let _ = writeln!(self.allocas, "  {islot} = alloca i64, align 8");
            let _ = writeln!(out, "  store {ty_ir} {first}, ptr {aslot}, align 8");
            let _ = writeln!(out, "  store i64 1, ptr {islot}, align 8");

            let cl = self.fresh_label("mm.cond");
            let bl = self.fresh_label("mm.body");
            let el = self.fresh_label("mm.end");
            self.emit_br(&cl, out);
            self.start_block(&cl, out);
            let ci = self.next_tmp();
            let _ = writeln!(out, "  {ci} = load i64, ptr {islot}, align 8");
            let mc = self.next_tmp();
            let _ = writeln!(out, "  {mc} = icmp slt i64 {ci}, {len_v}");
            self.emit_cond_br(&mc, &bl, &el, out);

            self.start_block(&bl, out);
            let ep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {ep} = getelementptr inbounds {ty_ir}, ptr {data_p}, i64 {ci}"
            );
            let cur = self.next_tmp();
            let _ = writeln!(out, "  {cur} = load {ty_ir}, ptr {ep}, align 8");
            let prev = self.next_tmp();
            let _ = writeln!(out, "  {prev} = load {ty_ir}, ptr {aslot}, align 8");
            let take = self.next_tmp();
            if *elem_ty == Type::Int {
                let pred = if is_min { "slt" } else { "sgt" };
                let _ = writeln!(out, "  {take} = icmp {pred} i64 {cur}, {prev}");
            } else {
                let pred = if is_min { "olt" } else { "ogt" };
                let _ = writeln!(out, "  {take} = fcmp {pred} double {cur}, {prev}");
            }
            let sel = self.next_tmp();
            let _ = writeln!(
                out,
                "  {sel} = select i1 {take}, {ty_ir} {cur}, {ty_ir} {prev}"
            );
            let _ = writeln!(out, "  store {ty_ir} {sel}, ptr {aslot}, align 8");
            let ni = self.next_tmp();
            let _ = writeln!(out, "  {ni} = add nuw nsw i64 {ci}, 1");
            let _ = writeln!(out, "  store i64 {ni}, ptr {islot}, align 8");
            self.emit_br(&cl, out);

            self.start_block(&el, out);
            let res = self.next_tmp();
            let _ = writeln!(out, "  {res} = load {ty_ir}, ptr {aslot}, align 8");
            return Ok((*elem_ty, res));
        }

        let (first_ty, mut acc) = self.eval_expr(&args[0], out)?;
        if !matches!(first_ty, Type::Int | Type::Float) {
            return Err(Diagnostic::new(
                format!(
                    "`{fn_name}()` expects `int` or `float`, found `{}`",
                    first_ty.name()
                ),
                args[0].span,
            ));
        }
        let ty_ir = ir_type(&first_ty);
        for arg in &args[1..] {
            let (ty, v) = self.eval_expr(arg, out)?;
            if ty != first_ty {
                return Err(Diagnostic::new(
                    format!(
                        "`{fn_name}()` arguments must have matching types (`{}` vs `{}`)",
                        first_ty.name(),
                        ty.name()
                    ),
                    arg.span,
                ));
            }
            let take = self.next_tmp();
            if first_ty == Type::Int {
                let pred = if is_min { "slt" } else { "sgt" };
                let _ = writeln!(out, "  {take} = icmp {pred} i64 {v}, {acc}");
            } else {
                let pred = if is_min { "olt" } else { "ogt" };
                let _ = writeln!(out, "  {take} = fcmp {pred} double {v}, {acc}");
            }
            let next_acc = self.next_tmp();
            let _ = writeln!(
                out,
                "  {next_acc} = select i1 {take}, {ty_ir} {v}, {ty_ir} {acc}"
            );
            acc = next_acc;
        }
        Ok((first_ty, acc))
    }

    fn gen_builtin_sum(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.is_empty() || args.len() > 2 {
            return Err(Diagnostic::new(
                "`sum()` expects 1 or 2 arguments (`sum(seq[, start])`)",
                span,
            ));
        }
        let (seq_ty, vec_val) = self.eval_expr(&args[0], out)?;
        let Type::Array(elem_ty) = seq_ty else {
            return Err(Diagnostic::new(
                format!(
                    "`sum()` expects `list[int]` or `list[float]`, found `{}`",
                    seq_ty.name()
                ),
                args[0].span,
            ));
        };
        if !matches!(*elem_ty, Type::Int | Type::Float) {
            return Err(Diagnostic::new(
                format!(
                    "`sum()` requires `int` or `float` elements, found `{}`",
                    elem_ty.name()
                ),
                args[0].span,
            ));
        }
        let init_val = if args.len() == 2 {
            let (sty, sv) = self.eval_expr(&args[1], out)?;
            if sty != *elem_ty {
                return Err(Diagnostic::new(
                    format!(
                        "`sum()` start value must match element type `{}`, found `{}`",
                        elem_ty.name(),
                        sty.name()
                    ),
                    args[1].span,
                ));
            }
            sv
        } else if *elem_ty == Type::Int {
            "0".to_string()
        } else {
            format_llvm_double(0.0)
        };

        let len_v = self.next_tmp();
        let _ = writeln!(out, "  {len_v} = extractvalue %ArchxVec {vec_val}, 0");
        let data_p = self.next_tmp();
        let _ = writeln!(out, "  {data_p} = extractvalue %ArchxVec {vec_val}, 2");
        let ty_ir = ir_type(&elem_ty);
        let aslot = self.next_slot("sum.acc");
        let islot = self.next_slot("sum.idx");
        let _ = writeln!(self.allocas, "  {aslot} = alloca {ty_ir}, align 8");
        let _ = writeln!(self.allocas, "  {islot} = alloca i64, align 8");
        let _ = writeln!(out, "  store {ty_ir} {init_val}, ptr {aslot}, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {islot}, align 8");

        let cl = self.fresh_label("sum.cond");
        let bl = self.fresh_label("sum.body");
        let el = self.fresh_label("sum.end");
        self.emit_br(&cl, out);
        self.start_block(&cl, out);
        let ci = self.next_tmp();
        let _ = writeln!(out, "  {ci} = load i64, ptr {islot}, align 8");
        let mc = self.next_tmp();
        let _ = writeln!(out, "  {mc} = icmp slt i64 {ci}, {len_v}");
        self.emit_cond_br(&mc, &bl, &el, out);

        self.start_block(&bl, out);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {ty_ir}, ptr {data_p}, i64 {ci}"
        );
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load {ty_ir}, ptr {ep}, align 8");
        let prev = self.next_tmp();
        let _ = writeln!(out, "  {prev} = load {ty_ir}, ptr {aslot}, align 8");
        let nxt = self.next_tmp();
        if *elem_ty == Type::Int {
            let _ = writeln!(out, "  {nxt} = add i64 {prev}, {cur}");
        } else {
            let _ = writeln!(out, "  {nxt} = fadd double {prev}, {cur}");
        }
        let _ = writeln!(out, "  store {ty_ir} {nxt}, ptr {aslot}, align 8");
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nuw nsw i64 {ci}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {islot}, align 8");
        self.emit_br(&cl, out);

        self.start_block(&el, out);
        let res = self.next_tmp();
        let _ = writeln!(out, "  {res} = load {ty_ir}, ptr {aslot}, align 8");
        Ok((*elem_ty, res))
    }

    /// `wrapping_add/sub/mul(a, b)` — explicit modular `i64` arithmetic (AX-002).
    ///
    /// The default contract is that `int` traps rather than wrapping, because a wrapped value is a
    /// *wrong answer* with no signal. That contract is right for almost every program, but it leaves
    /// none for the programs that genuinely mean modular arithmetic: hashing, PRNGs, checksums,
    /// bit-mixing. Those programs previously had no legal way to say so, so they either avoided the
    /// language or reached for a different bit width.
    ///
    /// This is the way to say so. It is deliberately explicit and deliberately loud:
    ///
    /// * **native dialect only.** A compat module promises CPython's arbitrary-precision `int`, where
    ///   `2**63` is `9223372036854775808`; wrapping to a negative number would be a wrong answer in
    ///   that contract, so the name is rejected there with an explanation rather than quietly doing
    ///   something the module never agreed to.
    /// * **the artifact records it.** Emitting `wrapping_add` sets `archx.wrapping` in the module
    ///   flags, so a binary that depends on modular arithmetic is identifiable without the source.
    ///
    /// Two constant operands are folded with `wrapping_*` at compile time, so `wrapping_add(MAX, 1)`
    /// is a literal and costs nothing.
    fn gen_builtin_wrapping(
        &mut self,
        name: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        // The table decides (AX-016); this is not a special case local to the builtin.
        if !matches!(
            crate::dialect_rules::value(
                crate::dialect_rules::Rule::WrappingOptOut,
                self.dialect
            ),
            crate::dialect_rules::RuleValue::Allowed
        ) {
            return Err(Diagnostic::new(
                format!(
                    "`{name}()` is native-only: a `compat` module promises CPython's arbitrary-precision \
                     `int`, where wrapping would be a wrong answer. Change the directive to \
                     `dialect=native`, or keep the trapping arithmetic"
                ),
                span,
            ));
        }
        if args.len() != 2 {
            return Err(Diagnostic::new(
                format!("`{name}()` takes exactly 2 arguments"),
                span,
            ));
        }
        let (lt, lv) = self.eval_expr(&args[0], out)?;
        let (rt, rv) = self.eval_expr(&args[1], out)?;
        for (ty, expr, which) in [(&lt, &args[0], "first"), (&rt, &args[1], "second")] {
            if *ty != Type::Int {
                return Err(Diagnostic::new(
                    format!("`{name}()` {which} argument must be `int`, found `{}`", ty.name()),
                    expr.span,
                ));
            }
        }

        // Set before folding: the flag records that the *source* opted out, and a fold that removes
        // the instruction entirely must not erase that fact from the artifact.
        self.used_wrapping = true;
        let folded = match (lv.parse::<i64>(), rv.parse::<i64>()) {
            (Ok(a), Ok(b)) => Some(match name {
                "wrapping_add" => a.wrapping_add(b),
                "wrapping_sub" => a.wrapping_sub(b),
                _ => a.wrapping_mul(b),
            }),
            _ => None,
        };
        if let Some(value) = folded {
            return Ok((Type::Int, value.to_string()));
        }

        // The plain instruction is exactly LLVM's modular arithmetic; no `nsw`/`nuw` attribute may
        // appear, since either would let the backend assume the wrap cannot happen.
        let instr = match name {
            "wrapping_add" => "add",
            "wrapping_sub" => "sub",
            _ => "mul",
        };
        let dst = self.next_tmp();
        let _ = writeln!(out, "  {dst} = {instr} i64 {lv}, {rv}");
        Ok((Type::Int, dst))
    }

    fn gen_builtin_ord(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new("`ord()` takes exactly 1 argument", span));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        if ty != Type::Str {
            return Err(Diagnostic::new(
                format!("`ord()` expects a 1-character `str`, found `{}`", ty.name()),
                args[0].span,
            ));
        }
        self.used_parse_fail = true;
        let w0 = self.next_tmp();
        let _ = writeln!(out, "  {w0} = extractvalue %ArchxStr {val}, 0");
        let l = self.next_tmp();
        let _ = writeln!(out, "  {l} = and i64 {w0}, 4294967295");
        let ok = self.next_tmp();
        let _ = writeln!(out, "  {ok} = icmp eq i64 {l}, 1");
        let ok_lbl = self.fresh_label("ord.ok");
        let bad_lbl = self.fresh_label("ord.bad");
        self.emit_cond_br(&ok, &ok_lbl, &bad_lbl, out);
        self.start_block(&bad_lbl, out);
        let _ = writeln!(out, "  call void @archx_parse_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;
        self.start_block(&ok_lbl, out);
        let sh = self.next_tmp();
        let _ = writeln!(out, "  {sh} = lshr i64 {w0}, 32");
        let ch = self.next_tmp();
        let _ = writeln!(out, "  {ch} = and i64 {sh}, 255");
        Ok((Type::Int, ch))
    }

    fn gen_builtin_chr(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new("`chr()` takes exactly 1 argument", span));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        if ty != Type::Int {
            return Err(Diagnostic::new(
                format!("`chr()` expects `int`, found `{}`", ty.name()),
                args[0].span,
            ));
        }
        self.used_str_type = true;
        self.used_parse_fail = true;
        let bad = self.next_tmp();
        let _ = writeln!(out, "  {bad} = icmp ugt i64 {val}, 255");
        let bad_lbl = self.fresh_label("chr.bad");
        let ok_lbl = self.fresh_label("chr.ok");
        self.emit_cond_br(&bad, &bad_lbl, &ok_lbl, out);
        self.start_block(&bad_lbl, out);
        let _ = writeln!(out, "  call void @archx_parse_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;
        self.start_block(&ok_lbl, out);
        let sh = self.next_tmp();
        let _ = writeln!(out, "  {sh} = shl nuw i64 {val}, 32");
        let w0 = self.next_tmp();
        let _ = writeln!(out, "  {w0} = or i64 {sh}, 1");
        let s0 = self.next_tmp();
        let _ = writeln!(out, "  {s0} = insertvalue %ArchxStr poison, i64 {w0}, 0");
        let s1 = self.next_tmp();
        let _ = writeln!(out, "  {s1} = insertvalue %ArchxStr {s0}, i64 0, 1");
        Ok((Type::Str, s1))
    }

    // ---------------- Core `len` / `push` / `pop` ----------------------------

    pub(super) fn gen_builtin_len(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new("`len` takes exactly one argument", span));
        }

        if let ExprKind::Str(lit) = &args[0].kind {
            return Ok((Type::Int, (lit.len() as i64).to_string()));
        }

        if let ExprKind::Var(name) = &args[0].kind {
            if let Some(&KnownLen::Const(c)) = self.lookup_known_len(name) {
                if let Some(entry) = self.lookup_var(name) {
                    if entry.ty.is_array() {
                        return Ok((Type::Int, c.to_string()));
                    }
                }
            }
            if let Some(entry) = self.lookup_var(name).cloned() {
                if let VarStorage::Soa { len_val, .. } = entry.storage {
                    return Ok((Type::Int, len_val));
                }
            }
        }

        let (ty, val) = self.eval_expr(&args[0], out)?;
        match ty {
            Type::Array(_) => {
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = extractvalue %ArchxVec {val}, 0");
                Ok((Type::Int, reg))
            }
            Type::Str => {
                let w0 = self.next_tmp();
                let _ = writeln!(out, "  {w0} = extractvalue %ArchxStr {val}, 0");
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = and i64 {w0}, 4294967295");
                Ok((Type::Int, reg))
            }
            Type::Dict(_, _) | Type::Set(_) => {
                let reg = self.emit_dict_len(&val, out);
                Ok((Type::Int, reg))
            }
            Type::Tuple(items) => Ok((Type::Int, (items.len() as i64).to_string())),
            Type::Any => {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = call fastcc i64 @archx_any_len(%ArchxAny {val})");
                Ok((Type::Int, reg))
            }
            other => Err(Diagnostic::new(
                format!(
                    "`len` expects a `list`, `tuple`, `dict`, `set`, or `str`, found `{}`",
                    other.name()
                ),
                args[0].span,
            )),
        }
    }

    pub(super) fn gen_builtin_push(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 2 {
            return Err(Diagnostic::new(
                "`push` takes exactly 2 arguments: `push(array, value)`",
                span,
            ));
        }
        self.emit_list_push_var(&args[0], &args[1], "push", span, out)
    }

    pub(super) fn emit_list_push_var(
        &mut self,
        target_expr: &Expr,
        val_expr: &Expr,
        op_name: &str,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let ExprKind::Var(arr_name) = &target_expr.kind else {
            return Err(Diagnostic::new(
                format!("target of `{op_name}` must be a list variable"),
                target_expr.span,
            ));
        };

        let entry = self.lookup_var(arr_name).cloned().ok_or_else(|| {
            Diagnostic::new(format!("undefined variable `{arr_name}`"), target_expr.span)
        })?;
        if entry.is_param {
            return Err(Diagnostic::new(
                format!(
                    "cannot `{op_name}` onto borrowed parameter `{arr_name}`; assign to a local list first"
                ),
                target_expr.span,
            ));
        }
        let Type::Array(elem_ty) = entry.ty.clone() else {
            return Err(Diagnostic::new(
                format!("`{op_name}` expects a `list`, found `{}`", entry.ty.name()),
                target_expr.span,
            ));
        };
        self.check_region_escape_target(arr_name, &elem_ty, span)?;

        let VarStorage::Slot(slot_ptr) = entry.storage else {
            return Err(Diagnostic::new(
                format!("internal error: pushed list `{arr_name}` lacked a slot"),
                span,
            ));
        };

        let val = self.eval_owned_for_slot(&elem_ty, val_expr, out)?;
        self.emit_list_push_raw(&slot_ptr, &elem_ty, &val, out)?;
        Ok((Type::Void, String::new()))
    }

    /// Append an already-evaluated, already-owned value to `arr_name`'s buffer.
    /// Shared by `append`/`push`, `extend`, and `insert`.
    pub(super) fn emit_list_push_raw(
        &mut self,
        slot_ptr: &str,
        elem_ty: &Type,
        val: &str,
        out: &mut String,
    ) -> Result<()> {
        let val = val.to_string();
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
        let cap = self.next_tmp();
        let _ = writeln!(out, "  {cap} = extractvalue %ArchxVec {vec}, 1");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");

        let is_reg = self.next_tmp();
        let _ = writeln!(out, "  {is_reg} = icmp slt i64 {cap}, 0");
        let neg_cap = self.next_tmp();
        let _ = writeln!(out, "  {neg_cap} = sub nsw i64 0, {cap}");
        let eff_cap = self.next_tmp();
        let _ = writeln!(
            out,
            "  {eff_cap} = select i1 {is_reg}, i64 {neg_cap}, i64 {cap}"
        );

        let full = self.next_tmp();
        let _ = writeln!(out, "  {full} = icmp sge i64 {len}, {eff_cap}");
        let grow_lbl = self.fresh_label("push.grow");
        let store_lbl = self.fresh_label("push.store");
        self.emit_cond_br(&full, &grow_lbl, &store_lbl, out);

        self.start_block(&grow_lbl, out);
        let lim = self.next_tmp();
        let _ = writeln!(out, "  {lim} = icmp sge i64 {len}, {MAX_ARRAY_LEN}");
        self.used_oom_fail = true;
        let oom_lbl = self.fresh_label("push.oom");
        let calc_lbl = self.fresh_label("push.calc");
        self.emit_cond_br(&lim, &oom_lbl, &calc_lbl, out);

        self.start_block(&oom_lbl, out);
        let _ = writeln!(out, "  call void @archx_oom_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&calc_lbl, out);
        let zero_cap = self.next_tmp();
        let _ = writeln!(out, "  {zero_cap} = icmp eq i64 {eff_cap}, 0");
        let doubled = self.next_tmp();
        let _ = writeln!(out, "  {doubled} = shl i64 {eff_cap}, 1");
        let cand_cap = self.next_tmp();
        let _ = writeln!(
            out,
            "  {cand_cap} = select i1 {zero_cap}, i64 4, i64 {doubled}"
        );
        let over_max = self.next_tmp();
        let _ = writeln!(out, "  {over_max} = icmp sgt i64 {cand_cap}, {MAX_ARRAY_LEN}");
        let new_cap = self.next_tmp();
        let _ = writeln!(
            out,
            "  {new_cap} = select i1 {over_max}, i64 {MAX_ARRAY_LEN}, i64 {cand_cap}"
        );

        let elem_sz_val = self.emit_elem_sizeof(&elem_ty, out);
        let bytes = self.emit_elem_bytes_val_mul(&new_cap, &elem_sz_val, out);

        let was_reg_lbl = self.fresh_label("push.grow.from_reg");
        let was_heap_lbl = self.fresh_label("push.grow.from_heap");
        self.emit_cond_br(&is_reg, &was_reg_lbl, &was_heap_lbl, out);

        self.start_block(&was_reg_lbl, out);
        let old_bytes = self.emit_elem_bytes_val_mul(&len, &elem_sz_val, out);
        let (reg_new_ptr, reg_new_cap) =
            if !self.region_stack.is_empty() && !self.type_needs_drop(&elem_ty) {
                let rslot = self.func_region_slot.clone().unwrap();
                let rp = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {rp} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
                );
                let nc = self.next_tmp();
                let _ = writeln!(out, "  {nc} = sub nsw i64 0, {new_cap}");
                (rp, nc)
            } else {
                let hp = self.emit_checked_malloc(&bytes, out);
                (hp, new_cap.clone())
            };
        self.used_memcpy = true;
        let has_old = self.next_tmp();
        let _ = writeln!(out, "  {has_old} = icmp sgt i64 {old_bytes}, 0");
        let cp_lbl = self.fresh_label("push.reg.copy");
        let cp_done_lbl = self.fresh_label("push.reg.copied");
        self.emit_cond_br(&has_old, &cp_lbl, &cp_done_lbl, out);
        self.start_block(&cp_lbl, out);
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {reg_new_ptr}, ptr align 8 {data}, i64 {old_bytes}, i1 false)"
        );
        self.emit_br(&cp_done_lbl, out);
        self.start_block(&cp_done_lbl, out);
        let gvec_reg = self.build_vec_val(&len, &reg_new_cap, &reg_new_ptr, out);
        let _ = writeln!(out, "  store %ArchxVec {gvec_reg}, ptr {slot_ptr}, align 8");
        self.emit_br(&store_lbl, out);

        self.start_block(&was_heap_lbl, out);
        let grown_ptr = self.emit_checked_realloc(&data, &bytes, out);
        let gvec_heap = self.build_vec_val(&len, &new_cap, &grown_ptr, out);
        let _ = writeln!(out, "  store %ArchxVec {gvec_heap}, ptr {slot_ptr}, align 8");
        self.emit_br(&store_lbl, out);

        self.start_block(&store_lbl, out);
        let vec2 = self.next_tmp();
        let _ = writeln!(out, "  {vec2} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let data2 = self.next_tmp();
        let _ = writeln!(out, "  {data2} = extractvalue %ArchxVec {vec2}, 2");
        let mem_ty = elem_mem_ir_type(&elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data2}, i64 {len}"
        );
        self.emit_elem_store(&elem_ty, &val, &ep, out);
        let next_len = self.next_tmp();
        let _ = writeln!(out, "  {next_len} = add nsw i64 {len}, 1");
        let vec3 = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vec3} = insertvalue %ArchxVec {vec2}, i64 {next_len}, 0"
        );
        let _ = writeln!(out, "  store %ArchxVec {vec3}, ptr {slot_ptr}, align 8");
        Ok(())
    }

    pub(super) fn gen_builtin_pop(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new(
                "`pop` takes exactly 1 argument: `pop(array)`",
                span,
            ));
        }
        self.emit_list_pop_var(&args[0], "pop", span, out)
    }

    pub(super) fn emit_list_pop_var(
        &mut self,
        target_expr: &Expr,
        op_name: &str,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let ExprKind::Var(arr_name) = &target_expr.kind else {
            return Err(Diagnostic::new(
                format!("target of `{op_name}` must be a list variable"),
                target_expr.span,
            ));
        };

        let entry = self.lookup_var(arr_name).cloned().ok_or_else(|| {
            Diagnostic::new(format!("undefined variable `{arr_name}`"), target_expr.span)
        })?;
        if entry.is_param {
            return Err(Diagnostic::new(
                format!(
                    "cannot `{op_name}` from borrowed parameter `{arr_name}`; assign to a local list first"
                ),
                target_expr.span,
            ));
        }
        let Type::Array(elem_ty) = entry.ty else {
            return Err(Diagnostic::new(
                format!("`{op_name}` expects a `list`, found `{}`", entry.ty.name()),
                target_expr.span,
            ));
        };
        let VarStorage::Slot(slot_ptr) = entry.storage else {
            return Err(Diagnostic::new(
                format!("internal error: popped list `{arr_name}` lacked a slot"),
                span,
            ));
        };

        self.used_pop_empty_fail = true;
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}, align 8");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
        let empty = self.next_tmp();
        let _ = writeln!(out, "  {empty} = icmp sle i64 {len}, 0");
        let ok_lbl = self.fresh_label("pop.ok");
        let fail_lbl = self.fresh_label("pop.empty");
        self.emit_cond_br(&empty, &fail_lbl, &ok_lbl, out);

        self.start_block(&fail_lbl, out);
        let _ = writeln!(out, "  call void @archx_pop_empty_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        let next_len = self.next_tmp();
        let _ = writeln!(out, "  {next_len} = sub nsw i64 {len}, 1");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");
        let mem_ty = elem_mem_ir_type(&elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data}, i64 {next_len}"
        );
        let elem = self.emit_elem_load(&elem_ty, &ep, out);
        let vec2 = self.next_tmp();
        let _ = writeln!(
            out,
            "  {vec2} = insertvalue %ArchxVec {vec}, i64 {next_len}, 0"
        );
        let _ = writeln!(out, "  store %ArchxVec {vec2}, ptr {slot_ptr}, align 8");

        if self.type_needs_drop(&elem_ty) {
            self.stmt_temps.push(TempDrop {
                val: elem.clone(),
                ty: (*elem_ty).clone(),
            });
        }
        Ok((*elem_ty, elem))
    }

    fn gen_builtin_dict_ctor(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.is_empty() {
            return self.eval_dict_lit(&[], None, span, out);
        }
        if args.len() == 1 {
            let (ty, val) = self.eval_expr(&args[0], out)?;
            if let Type::Dict(_, _) = &ty {
                let c = if self.claim_stmt_temp(&val) {
                    val
                } else {
                    self.emit_clone_value(&ty, &val, out)
                };
                self.stmt_temps.push(TempDrop {
                    val: c.clone(),
                    ty: ty.clone(),
                });
                return Ok((ty, c));
            }
        }
        Err(Diagnostic::new(
            "`dict()` expects 0 arguments or an existing `dict`",
            span,
        ))
    }

    fn gen_builtin_set_ctor(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.is_empty() {
            let s = self.emit_new_empty_dict_or_set(&Type::Any, None, out);
            let res_ty = Type::Set(Box::new(Type::Any));
            self.stmt_temps.push(TempDrop {
                val: s.clone(),
                ty: res_ty.clone(),
            });
            return Ok((res_ty, s));
        }
        if args.len() != 1 {
            return Err(Diagnostic::new(
                format!("`set()` expects at most 1 argument, found {}", args.len()),
                span,
            ));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        match ty {
            Type::Set(_) => {
                let c = if self.claim_stmt_temp(&val) {
                    val
                } else {
                    self.emit_clone_value(&ty, &val, out)
                };
                self.stmt_temps.push(TempDrop {
                    val: c.clone(),
                    ty: ty.clone(),
                });
                Ok((ty, c))
            }
            Type::Array(elem_ty) => {
                if !elem_ty.is_hashable_key() {
                    return Err(Diagnostic::new(
                        format!("`set()` elements of type `{}` are not hashable", elem_ty.name()),
                        args[0].span,
                    ));
                }
                let s = self.emit_new_empty_dict_or_set(&elem_ty, None, out);
                let fam = Self::dict_family_suffix(&elem_ty);
                let kstore = Self::dict_key_storage_ir(&elem_ty);
                let len = self.next_tmp();
                let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {val}, 0");
                let data = self.next_tmp();
                let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {val}, 2");
                let i_slot = self.next_slot("setctor.i");
                let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
                let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
                let cond_lbl = self.fresh_label("setctor.cond");
                let body_lbl = self.fresh_label("setctor.body");
                let done_lbl = self.fresh_label("setctor.done");
                self.emit_br(&cond_lbl, out);

                self.start_block(&cond_lbl, out);
                let i = self.next_tmp();
                let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
                let more = self.next_tmp();
                let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len}");
                self.emit_cond_br(&more, &body_lbl, &done_lbl, out);

                self.start_block(&body_lbl, out);
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let ep = self.next_tmp();
                let _ = writeln!(out, "  {ep} = getelementptr inbounds {mem_ty}, ptr {data}, i64 {i}");
                let ev = self.emit_elem_load(&elem_ty, &ep, out);
                let karg = if *elem_ty == Type::Bool {
                    let z = self.next_tmp();
                    let _ = writeln!(out, "  {z} = zext i1 {ev} to i64");
                    z
                } else {
                    ev
                };
                let up = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {up} = call fastcc {{ i64, i1 }} @archx_dict_upsert_{fam}(i64 {s}, {kstore} {karg})"
                );
                let inext = self.next_tmp();
                let _ = writeln!(out, "  {inext} = add nuw nsw i64 {i}, 1");
                let _ = writeln!(out, "  store i64 {inext}, ptr {i_slot}, align 8");
                self.emit_br(&cond_lbl, out);

                self.start_block(&done_lbl, out);
                let res_ty = Type::Set(elem_ty);
                self.stmt_temps.push(TempDrop {
                    val: s.clone(),
                    ty: res_ty.clone(),
                });
                Ok((res_ty, s))
            }
            other => Err(Diagnostic::new(
                format!("`set()` expects a `list` or `set`, found `{}`", other.name()),
                args[0].span,
            )),
        }
    }

    fn gen_builtin_list_ctor(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.is_empty() {
            return self.eval_array_lit(&[], None, span, out);
        }
        if args.len() == 1 {
            let (ty, val) = self.eval_expr(&args[0], out)?;
            match ty {
                Type::Array(_) => {
                    let c = if self.claim_stmt_temp(&val) {
                        val
                    } else {
                        self.emit_clone_value(&ty, &val, out)
                    };
                    self.stmt_temps.push(TempDrop {
                        val: c.clone(),
                        ty: ty.clone(),
                    });
                    return Ok((ty, c));
                }
                Type::Set(elem_ty) | Type::Dict(elem_ty, _) => {
                    return self.gen_dict_method(&elem_ty, &Type::Int, &val, "keys", &[], span, out);
                }
                _ => {}
            }
        }
        Err(Diagnostic::new(
            "`list()` expects 0 arguments or a `list`/`set`/`dict`",
            span,
        ))
    }
}
