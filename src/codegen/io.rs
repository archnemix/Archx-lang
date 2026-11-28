//! Pythonic I/O & formatting lowering: `print(*args, sep=..., end=...)`, `input([prompt])`,
//! `str(x)` conversion, and `f"..."` string interpolation.

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::expr::pack_sso_str_words;
use super::*;

impl Codegen {
    pub(super) fn gen_builtin_print(
        &mut self,
        args: &[Expr],
        sep_expr: Option<&Expr>,
        end_expr: Option<&Expr>,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        // Fast path: 1 argument with default `sep` and `end`
        if args.len() == 1 && sep_expr.is_none() && end_expr.is_none() {
            if let ExprKind::Str(lit) = &args[0].kind {
                if !lit.as_bytes().contains(&0) {
                    let sym = self.strings.intern(lit);
                    let reg = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr {sym})"
                    );
                    return Ok((Type::Void, reg));
                }
            }

            let (ty, val) = self.eval_expr(&args[0], out)?;
            match ty {
                Type::Str => {
                    self.used_str_print = true;
                    let _ = writeln!(
                        out,
                        "  call fastcc void @archx_str_print(%ArchxStr {val}, i1 true)"
                    );
                    return Ok((Type::Void, String::new()));
                }
                Type::Int => {
                    let reg = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 {val})"
                    );
                    return Ok((Type::Void, reg));
                }
                Type::Float => {
                    self.used_print_float = true;
                    let _ = writeln!(
                        out,
                        "  call fastcc void @archx_print_float(double {val}, i1 true)"
                    );
                    return Ok((Type::Void, String::new()));
                }
                Type::Bool => {
                    let selected = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {selected} = select i1 {val}, ptr @.str.true, ptr @.str.false"
                    );
                    let reg = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr {selected})"
                    );
                    return Ok((Type::Void, reg));
                }
                Type::Void => {
                    self.used_print_inline = true;
                    let reg = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr @.str.none)"
                    );
                    return Ok((Type::Void, reg));
                }
                Type::Array(elem_ty) => {
                    self.emit_print_array(&elem_ty, &val, true, span, out)?;
                    return Ok((Type::Void, String::new()));
                }
                Type::Dict(k_ty, v_ty) => {
                    self.emit_print_dict_or_set(&k_ty, Some(&v_ty), &val, true, span, out)?;
                    return Ok((Type::Void, String::new()));
                }
                Type::Set(elem_ty) => {
                    self.emit_print_dict_or_set(&elem_ty, None, &val, true, span, out)?;
                    return Ok((Type::Void, String::new()));
                }
                Type::Any => {
                    self.mark_runtime_type(&Type::Any);
                    self.used_any_rt = true;
                    let _ = writeln!(
                        out,
                        "  call fastcc void @archx_any_print(%ArchxAny {val}, i1 true)"
                    );
                    return Ok((Type::Void, String::new()));
                }
                Type::Tuple(_) | Type::Optional(_) | Type::Enum(_) => {
                    self.emit_print_composite_v8(&ty, &val, true, span, out)?;
                    return Ok((Type::Void, String::new()));
                }
                Type::Struct(sname) => {
                    return Err(Diagnostic::new(
                        format!(
                            "`print` does not format class/struct `{sname}` automatically; print its fields or an f-string"
                        ),
                        span,
                    ));
                }
                Type::GenericInst { .. } => {
                    return Err(Diagnostic::new(
                        format!(
                            "`print` does not format generic `{}` automatically; print its fields or an f-string",
                            ty.name()
                        ),
                        span,
                    ));
                }
            }
        }

        // General Python `print(*args, sep=..., end=...)`:
        let mut evaluated = Vec::with_capacity(args.len());
        for a in args {
            evaluated.push((a.span, self.eval_expr(a, out)?));
        }

        let sep_val = if let Some(se) = sep_expr {
            let (sty, sv) = self.eval_expr(se, out)?;
            if sty != Type::Str {
                return Err(Diagnostic::new(
                    format!("`sep` must be `str`, found `{}`", sty.name()),
                    se.span,
                ));
            }
            Some(sv)
        } else {
            None
        };

        let end_val = if let Some(ee) = end_expr {
            let (ety, ev) = self.eval_expr(ee, out)?;
            if ety != Type::Str {
                return Err(Diagnostic::new(
                    format!("`end` must be `str`, found `{}`", ety.name()),
                    ee.span,
                ));
            }
            Some(ev)
        } else {
            None
        };

        for (i, (aspan, (ty, val))) in evaluated.iter().enumerate() {
            if i > 0 {
                if let Some(sv) = &sep_val {
                    self.used_str_print = true;
                    let _ = writeln!(
                        out,
                        "  call fastcc void @archx_str_print(%ArchxStr {sv}, i1 false)"
                    );
                } else {
                    self.used_str_print = true;
                    let pc = self.next_tmp();
                    let _ = writeln!(out, "  {pc} = call i32 @putchar(i32 32)");
                }
            }
            self.emit_print_inline_val(ty, val, false, *aspan, out)?;
        }

        if let Some(ev) = &end_val {
            self.used_str_print = true;
            let _ = writeln!(
                out,
                "  call fastcc void @archx_str_print(%ArchxStr {ev}, i1 false)"
            );
        } else {
            self.used_str_print = true;
            let nl = self.next_tmp();
            let _ = writeln!(out, "  {nl} = call i32 @putchar(i32 10)");
        }

        Ok((Type::Void, String::new()))
    }

    /// Prints one value with no separators.
    ///
    /// `in_container` selects the element rendering: a compat module must use `repr()` inside a list,
    /// tuple, dict or set (`['a']`), but the bare spelling at the top level (`print('a')` → `a`). The
    /// two are not the same function in CPython either — `print` calls `str`, a container calls `repr`.
    pub(super) fn emit_print_inline_val(
        &mut self,
        ty: &Type,
        val: &str,
        in_container: bool,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        self.used_print_inline = true;
        match ty {
            Type::Str => {
                if in_container && self.dialect.container_repr() {
                    self.used_str_print = true;
                    let _ = writeln!(
                        out,
                        "  call fastcc void @archx_str_print_repr(%ArchxStr {val})"
                    );
                } else {
                    self.used_str_print = true;
                    let _ = writeln!(
                        out,
                        "  call fastcc void @archx_str_print(%ArchxStr {val}, i1 false)"
                    );
                }
            }
            Type::Int => {
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 {val})"
                );
            }
            Type::Float => {
                self.used_print_float = true;
                let _ = writeln!(
                    out,
                    "  call fastcc void @archx_print_float(double {val}, i1 false)"
                );
            }
            Type::Bool => {
                let sel = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {sel} = select i1 {val}, ptr @.str.true, ptr @.str.false"
                );
                let r = self.next_tmp();
                // `True`/`False` are keywords in Python, never quoted, so this stays the plain format.
                let _ = writeln!(
                    out,
                    "  {r} = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr {sel})"
                );
            }
            Type::Void => {
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr @.str.none)"
                );
            }
            Type::Array(elem_ty) => {
                self.emit_print_array(elem_ty, val, false, span, out)?;
            }
            Type::Dict(k_ty, v_ty) => {
                self.emit_print_dict_or_set(k_ty, Some(v_ty), val, false, span, out)?;
            }
            Type::Set(elem_ty) => {
                self.emit_print_dict_or_set(elem_ty, None, val, false, span, out)?;
            }
            Type::Any => {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let _ = writeln!(
                    out,
                    "  call fastcc void @archx_any_print(%ArchxAny {val}, i1 false)"
                );
            }
            Type::Tuple(_) | Type::Optional(_) | Type::Enum(_) => {
                self.emit_print_composite_v8(ty, val, false, span, out)?;
            }
            Type::Struct(sname) => {
                return Err(Diagnostic::new(
                    format!(
                        "`print` does not format class/struct `{sname}` automatically; print its fields or an f-string"
                    ),
                    span,
                ));
            }
            Type::GenericInst { .. } => {
                return Err(Diagnostic::new(
                    format!(
                        "`print` does not format generic `{}` automatically; print its fields or an f-string",
                        ty.name()
                    ),
                    span,
                ));
            }
        }
        Ok(())
    }

    fn emit_print_array(
        &mut self,
        elem_ty: &Type,
        val: &str,
        newline: bool,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if matches!(elem_ty, Type::Struct(_) | Type::GenericInst { .. }) {
            return Err(Diagnostic::new(
                "`print` does not format lists of structs automatically; print fields in a loop",
                span,
            ));
        }
        self.used_array_print = true;
        self.used_print_inline = true;
        let open = self.next_tmp();
        let _ = writeln!(out, "  {open} = call i32 (ptr, ...) @printf(ptr @.fmt.lbrack)");

        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {val}, 0");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {val}, 2");

        let idx_slot = self.next_slot("print.idx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

        let cond_lbl = self.fresh_label("print.cond");
        let body_lbl = self.fresh_label("print.body");
        let sep_lbl = self.fresh_label("print.sep");
        let elem_lbl = self.fresh_label("print.elem");
        let end_lbl = self.fresh_label("print.end");

        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let pi = self.next_tmp();
        let _ = writeln!(out, "  {pi} = load i64, ptr {idx_slot}, align 8");
        let pcmp = self.next_tmp();
        let _ = writeln!(out, "  {pcmp} = icmp slt i64 {pi}, {len}");
        self.emit_cond_br(&pcmp, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let gt0 = self.next_tmp();
        let _ = writeln!(out, "  {gt0} = icmp sgt i64 {pi}, 0");
        self.emit_cond_br(&gt0, &sep_lbl, &elem_lbl, out);

        self.start_block(&sep_lbl, out);
        let sc = self.next_tmp();
        let _ = writeln!(out, "  {sc} = call i32 (ptr, ...) @printf(ptr @.fmt.sep)");
        self.emit_br(&elem_lbl, out);

        self.start_block(&elem_lbl, out);
        let mem_ty = elem_mem_ir_type(elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data}, i64 {pi}"
        );
        let elem_val = self.emit_elem_load(elem_ty, &ep, out);
        self.emit_print_inline_val(elem_ty, &elem_val, true, span, out)?;
        let pnext = self.next_tmp();
        let _ = writeln!(out, "  {pnext} = add nsw i64 {pi}, 1");
        let _ = writeln!(out, "  store i64 {pnext}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        let close = self.next_tmp();
        let close_fmt = if newline {
            "@.fmt.rbrack"
        } else {
            "@.fmt.rbrack.inline"
        };
        let _ = writeln!(out, "  {close} = call i32 (ptr, ...) @printf(ptr {close_fmt})");
        Ok(())
    }

    fn emit_print_dict_or_set(
        &mut self,
        k_ty: &Type,
        v_ty: Option<&Type>,
        d_val: &str,
        newline: bool,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if let Some(Type::Struct(sname)) = v_ty {
            return Err(Diagnostic::new(
                format!("`print` does not format dict values of struct `{sname}` automatically"),
                span,
            ));
        }
        if matches!(v_ty, Some(Type::GenericInst { .. })) {
            return Err(Diagnostic::new(
                "`print` does not format dict values of a generic class automatically",
                span,
            ));
        }
        self.used_array_print = true;
        self.used_print_inline = true;
        self.used_dict_type = true;

        let open = self.next_tmp();
        let _ = writeln!(out, "  {open} = call i32 (ptr, ...) @printf(ptr @.fmt.lbrace)");
        let len = self.emit_dict_len(d_val, out);
        let non_empty = self.next_tmp();
        let _ = writeln!(out, "  {non_empty} = icmp sgt i64 {len}, 0");

        let init_lbl = self.fresh_label("pdict.init");
        let cond_lbl = self.fresh_label("pdict.cond");
        let body_lbl = self.fresh_label("pdict.body");
        let sep_lbl = self.fresh_label("pdict.sep");
        let item_lbl = self.fresh_label("pdict.item");
        let end_lbl = self.fresh_label("pdict.end");
        self.emit_cond_br(&non_empty, &init_lbl, &end_lbl, out);

        let idx_slot = self.next_slot("pdict.idx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");

        self.start_block(&init_lbl, out);
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&cond_lbl, out);
        let pi = self.next_tmp();
        let _ = writeln!(out, "  {pi} = load i64, ptr {idx_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {pi}, {len}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let gt0 = self.next_tmp();
        let _ = writeln!(out, "  {gt0} = icmp sgt i64 {pi}, 0");
        self.emit_cond_br(&gt0, &sep_lbl, &item_lbl, out);

        self.start_block(&sep_lbl, out);
        let sc = self.next_tmp();
        let _ = writeln!(out, "  {sc} = call i32 (ptr, ...) @printf(ptr @.fmt.sep)");
        self.emit_br(&item_lbl, out);

        self.start_block(&item_lbl, out);
        let raw = self.next_tmp();
        let _ = writeln!(out, "  {raw} = and i64 {d_val}, -4");
        let hdr = self.next_tmp();
        let _ = writeln!(out, "  {hdr} = inttoptr i64 {raw} to ptr");
        let kg = self.next_tmp();
        let _ = writeln!(
            out,
            "  {kg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 5"
        );
        let kp = self.next_tmp();
        let _ = writeln!(out, "  {kp} = load ptr, ptr {kg}, align 8");
        let kstore = Self::dict_key_storage_ir(k_ty);
        let kep = self.next_tmp();
        let _ = writeln!(out, "  {kep} = getelementptr inbounds {kstore}, ptr {kp}, i64 {pi}");
        let kv = self.emit_load_dict_key(k_ty, &kep, out);
        self.emit_print_inline_val(k_ty, &kv, true, span, out)?;

        if let Some(vt) = v_ty {
            let col = self.next_tmp();
            let _ = writeln!(out, "  {col} = call i32 (ptr, ...) @printf(ptr @.fmt.colon)");
            let vg = self.next_tmp();
            let _ = writeln!(
                out,
                "  {vg} = getelementptr inbounds %ArchxDictHdr, ptr {hdr}, i32 0, i32 6"
            );
            let vp = self.next_tmp();
            let _ = writeln!(out, "  {vp} = load ptr, ptr {vg}, align 8");
            let vmem = elem_mem_ir_type(vt);
            let vep = self.next_tmp();
            let _ = writeln!(out, "  {vep} = getelementptr inbounds {vmem}, ptr {vp}, i64 {pi}");
            let vv = self.emit_elem_load(vt, &vep, out);
            self.emit_print_inline_val(vt, &vv, true, span, out)?;
        }

        let pnext = self.next_tmp();
        let _ = writeln!(out, "  {pnext} = add nuw nsw i64 {pi}, 1");
        let _ = writeln!(out, "  store i64 {pnext}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        let cl = self.next_tmp();
        let _ = writeln!(out, "  {cl} = call i32 (ptr, ...) @printf(ptr @.fmt.rbrace)");
        if newline {
            let nl = self.next_tmp();
            let _ = writeln!(out, "  {nl} = call i32 (ptr, ...) @printf(ptr @.fmt.nl)");
        }
        Ok(())
    }

    // ---------------- `input([prompt])` --------------------------------------

    pub(super) fn gen_builtin_input(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() > 1 {
            return Err(Diagnostic::new(
                "`input()` takes at most 1 argument (`input([prompt])`)",
                span,
            ));
        }
        self.used_input = true;
        let reg_arg = self.active_region_arg();
        let res = self.next_tmp();
        if args.len() == 1 {
            self.used_str_print = true;
            let (pty, pval) = self.eval_expr(&args[0], out)?;
            if pty != Type::Str {
                return Err(Diagnostic::new(
                    format!("`input()` prompt must be `str`, found `{}`", pty.name()),
                    args[0].span,
                ));
            }
            let _ = writeln!(
                out,
                "  {res} = call fastcc %ArchxStr @archx_input(%ArchxStr {pval}, i1 true, ptr {reg_arg})"
            );
        } else {
            let _ = writeln!(
                out,
                "  {res} = call fastcc %ArchxStr @archx_input(%ArchxStr zeroinitializer, i1 false, ptr {reg_arg})"
            );
        }
        self.stmt_temps.push(TempDrop {
            val: res.clone(),
            ty: Type::Str,
        });
        Ok((Type::Str, res))
    }

    // ---------------- `str(x)` & `f"..."` ------------------------------------

    pub(super) fn gen_conv_str(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.used_str_type = true;
        if args.is_empty() {
            return Ok((Type::Str, "{ i64 0, i64 0 }".to_string()));
        }
        if args.len() != 1 {
            return Err(Diagnostic::new("`str()` takes at most 1 argument", span));
        }
        let (ty, val) = self.eval_expr(&args[0], out)?;
        let s = self.emit_value_to_str(&ty, &val, args[0].span, out)?;
        Ok((Type::Str, s))
    }

    /// `f"{x:spec}"` — implement the common Python format specifications.
    ///
    /// Supported: `[[fill]align][0][width][.precision][type]` where `type` is one of
    /// `f F e E g G d x X o b %` and `align` is one of `< > ^`. Anything else is rejected with a
    /// clear error rather than silently ignored.
    pub(super) fn emit_value_to_str_spec(
        &mut self,
        ty: &Type,
        val: &str,
        spec: &str,
        span: Span,
        out: &mut String,
    ) -> Result<String> {
        let (fill, align, width, prec, kind) = parse_format_spec(spec)
            .ok_or_else(|| Diagnostic::new(format!("unsupported format spec `{{:{spec}}}`"), span))?;

        let is_int_ty = *ty == Type::Int;
        let is_float_ty = *ty == Type::Float;
        let is_str_ty = *ty == Type::Str;

        // --- build the number body through sprintf so rounding matches C's `%f` (== Python) ---
        let mut body: String = match kind {
            Some('d') if is_int_ty => {
                self.used_str_from_int = true;
                let reg = self.active_region_arg();
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc %ArchxStr @archx_str_from_int(i64 {val}, ptr {reg})"
                );
                r
            }
            Some('x') | Some('X') | Some('o') | Some('b') if is_int_ty => {
                // Format specs use the *unprefixed* form (`{255:x}` is `ff`, not `0xff`).
                self.used_int_to_base_raw = true;
                let reg = self.active_region_arg();
                let base = if kind == Some('o') {
                    8
                } else if kind == Some('b') {
                    2
                } else {
                    16
                };
                let upper = matches!(kind, Some('X'));
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc %ArchxStr @archx_int_to_base_raw(i64 {val}, i32 {base}, i1 {upper}, ptr {reg})"
                );
                r
            }
            Some('f') | Some('F') | Some('e') | Some('E') | Some('g') | Some('G') | Some('%')
                if is_float_ty || is_int_ty =>
            {
                let dval = if is_int_ty {
                    let d = self.next_tmp();
                    let _ = writeln!(out, "  {d} = sitofp i64 {val} to double");
                    d
                } else {
                    val.to_string()
                };
                let precision = prec.unwrap_or(6);
                self.used_sprintf_fmt = true;
                let reg = self.active_region_arg();
                let dval = if kind == Some('%') {
                    // `{x:.1%}` multiplies by 100 and appends a percent sign.
                    let scaled = self.next_tmp();
                    let _ = writeln!(out, "  {scaled} = fmul double {dval}, 1.0e2");
                    scaled
                } else {
                    dval
                };
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc %ArchxStr @archx_str_from_float_fmt(double {dval}, ptr @.fmt.spec.{kindid}, i64 {precision}, ptr {reg})",
                    kindid = fmt_label_id(kind.unwrap())
                );
                if kind == Some('%') {
                    self.used_str_percent_suffix = true;
                    let lit = self.next_tmp();
                    let _ = writeln!(out, "  {lit} = call fastcc %ArchxStr @archx_str_percent_suffix(ptr {reg})");
                    let joined = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {joined} = call fastcc %ArchxStr @archx_str_concat(%ArchxStr {r}, %ArchxStr {lit}, ptr null)"
                    );
                    joined
                } else {
                    r
                }
            }
            None if is_float_ty => {
                self.used_str_from_float = true;
                let reg = self.active_region_arg();
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc %ArchxStr @archx_str_from_float(double {val}, ptr {reg})"
                );
                r
            }
            None if is_int_ty => {
                self.used_str_from_int = true;
                let reg = self.active_region_arg();
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc %ArchxStr @archx_str_from_int(i64 {val}, ptr {reg})"
                );
                r
            }
            None if is_str_ty => val.to_string(),
            _ => {
                // Fall back to the unspecialised conversion (`bool`, `None`, nested types).
                return self.emit_value_to_str(ty, val, span, out);
            }
        };
        self.stmt_temps.push(TempDrop {
            val: body.clone(),
            ty: Type::Str,
        });

        // Truncate for strings: `{s:.3}` keeps at most three characters.
        if is_str_ty {
            if let Some(p) = prec {
                self.used_slice_rt = true;
                let reg = self.active_region_arg();
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc %ArchxStr @archx_str_slice(%ArchxStr {body}, i64 0, i1 true, i64 {p}, i1 true, i64 1, ptr {reg})"
                );
                body = r;
            }
        }

        let Some(width) = width else {
            return Ok(body);
        };

        // --- padding ---
        if width == 0 {
            return Ok(body);
        }
        self.used_str_pad = true;
        let (fillb, left_align) = match align {
            Some('<') => (fill, true),
            Some('>') => (fill, false),
            Some('^') => (fill, false), // centred is approximated as right-aligned
            _ => match ty {
                Type::Int | Type::Float => (fill, false),
                _ => (fill, true),
            },
        };
        let align_code = if left_align { 0 } else { 1 };
        let reg = self.active_region_arg();
        let r = self.next_tmp();
        let _ = writeln!(
            out,
            "  {r} = call fastcc %ArchxStr @archx_str_pad(%ArchxStr {body}, i64 {width}, i8 {fillb}, i64 {align_code}, ptr {reg})"
        );
        Ok(r)
    }

    pub(super) fn emit_value_to_str(
        &mut self,
        ty: &Type,
        val: &str,
        span: Span,
        out: &mut String,
    ) -> Result<String> {
        self.used_str_type = true;
        match ty {
            Type::Str => Ok(val.to_string()),
            Type::Int => {
                self.used_str_from_int = true;
                let reg_arg = self.active_region_arg();
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc %ArchxStr @archx_str_from_int(i64 {val}, ptr {reg_arg})"
                );
                self.stmt_temps.push(TempDrop {
                    val: r.clone(),
                    ty: Type::Str,
                });
                Ok(r)
            }
            Type::Float => {
                self.used_str_from_float = true;
                let reg_arg = self.active_region_arg();
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc %ArchxStr @archx_str_from_float(double {val}, ptr {reg_arg})"
                );
                self.stmt_temps.push(TempDrop {
                    val: r.clone(),
                    ty: Type::Str,
                });
                Ok(r)
            }
            Type::Bool => {
                let (tw0, tw1) = pack_sso_str_words(b"true");
                let (fw0, fw1) = pack_sso_str_words(b"false");
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = select i1 {val}, %ArchxStr {{ i64 {tw0}, i64 {tw1} }}, %ArchxStr {{ i64 {fw0}, i64 {fw1} }}"
                );
                Ok(r)
            }
            Type::Void => {
                let (nw0, nw1) = pack_sso_str_words(b"None");
                Ok(format!("{{ i64 {nw0}, i64 {nw1} }}"))
            }
            Type::Optional(inner) => {
                let opt_ir = ir_type(ty);
                let has = self.next_tmp();
                let _ = writeln!(out, "  {has} = extractvalue {opt_ir} {val}, 0");
                let res_slot = self.next_slot("stropt.res");
                let _ = writeln!(self.allocas, "  {res_slot} = alloca %ArchxStr, align 8");
                let (nw0, nw1) = pack_sso_str_words(b"None");
                let _ = writeln!(
                    out,
                    "  store %ArchxStr {{ i64 {nw0}, i64 {nw1} }}, ptr {res_slot}, align 8"
                );
                let some_lbl = self.fresh_label("stropt.some");
                let done_lbl = self.fresh_label("stropt.done");
                self.emit_cond_br(&has, &some_lbl, &done_lbl, out);

                self.start_block(&some_lbl, out);
                let iv = self.next_tmp();
                let _ = writeln!(out, "  {iv} = extractvalue {opt_ir} {val}, 1");
                let inner_s = self.emit_value_to_str(inner, &iv, span, out)?;
                let owned_s = if self.claim_stmt_temp(&inner_s) {
                    inner_s
                } else {
                    self.emit_clone_value(&Type::Str, &inner_s, out)
                };
                let _ = writeln!(out, "  store %ArchxStr {owned_s}, ptr {res_slot}, align 8");
                self.emit_br(&done_lbl, out);

                self.start_block(&done_lbl, out);
                let r = self.next_tmp();
                let _ = writeln!(out, "  {r} = load %ArchxStr, ptr {res_slot}, align 8");
                self.stmt_temps.push(TempDrop {
                    val: r.clone(),
                    ty: Type::Str,
                });
                Ok(r)
            }
            Type::Tuple(items) => {
                let (lp0, lp1) = pack_sso_str_words(b"(");
                let mut acc = format!("{{ i64 {lp0}, i64 {lp1} }}");
                let tup_ir = ir_type(ty);
                for (i, item_ty) in items.iter().enumerate() {
                    if i > 0 {
                        let (sp0, sp1) = pack_sso_str_words(b", ");
                        let sep = format!("{{ i64 {sp0}, i64 {sp1} }}");
                        acc = self.emit_str_concat_call(&acc, &sep, out);
                    }
                    let fv = self.next_tmp();
                    let _ = writeln!(out, "  {fv} = extractvalue {tup_ir} {val}, {i}");
                    let es = self.emit_value_to_str(item_ty, &fv, span, out)?;
                    acc = self.emit_str_concat_call(&acc, &es, out);
                }
                let close_bytes: &[u8] = if items.len() == 1 { b",)" } else { b")" };
                let (rp0, rp1) = pack_sso_str_words(close_bytes);
                let rp = format!("{{ i64 {rp0}, i64 {rp1} }}");
                Ok(self.emit_str_concat_call(&acc, &rp, out))
            }
            Type::Any => {
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let reg_arg = self.active_region_arg();
                let r = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc %ArchxStr @archx_any_to_str(%ArchxAny {val}, ptr {reg_arg})"
                );
                self.stmt_temps.push(TempDrop {
                    val: r.clone(),
                    ty: Type::Str,
                });
                Ok(r)
            }
            other => Err(Diagnostic::new(
                format!("cannot convert `{}` to `str`", other.name()),
                span,
            )),
        }
    }

    pub(super) fn gen_fstring(
        &mut self,
        parts: &[FStrPart],
        out: &mut String,
    ) -> Result<(Type, String)> {
        self.used_str_type = true;
        if parts.is_empty() {
            return Ok((Type::Str, "{ i64 0, i64 0 }".to_string()));
        }

        let mut acc: Option<String> = None;
        for part in parts {
            let seg = match part {
                FStrPart::Lit(lit) => {
                    let lit_expr = Expr {
                        kind: ExprKind::Str(lit.clone()),
                        span: Span::new(1, 1),
                    };
                    self.eval_expr(&lit_expr, out)?.1
                }
                FStrPart::Expr(expr) => {
                    let (ty, val) = self.eval_expr(expr, out)?;
                    self.emit_value_to_str(&ty, &val, expr.span, out)?
                }
                FStrPart::Spec { expr, spec } => {
                    let (ty, val) = self.eval_expr(expr, out)?;
                    self.emit_value_to_str_spec(&ty, &val, spec, expr.span, out)?
                }
            };
            acc = Some(match acc {
                None => seg,
                Some(prev) => self.emit_str_concat_call(&prev, &seg, out),
            });
        }
        Ok((Type::Str, acc.unwrap()))
    }
}

/// `[[fill]align][0][width][.precision][type]` -> decomposed parts.
fn parse_format_spec(spec: &str) -> Option<(u8, Option<char>, Option<i64>, Option<i64>, Option<char>)> {
    let bytes = spec.as_bytes();
    let mut i = 0usize;
    let mut fill = b' ';
    let mut align: Option<char> = None;
    // `fill+align` is a two-character prefix; `align` alone is one character.
    if bytes.len() >= 2 && matches!(bytes[1] as char, '<' | '>' | '^') {
        fill = bytes[0];
        align = Some(bytes[1] as char);
        i = 2;
    } else if !bytes.is_empty() && matches!(bytes[0] as char, '<' | '>' | '^') {
        align = Some(bytes[0] as char);
        i = 1;
    } else if !bytes.is_empty() && bytes[0] == b'0' {
        fill = b'0';
        align = Some('>');
        i = 1;
    }
    let start = i;
    while i < bytes.len() && bytes[i].is_ascii_digit() {
        i += 1;
    }
    let width = if i > start {
        spec[start..i].parse::<i64>().ok()
    } else {
        None
    };
    let mut prec = None;
    if i < bytes.len() && bytes[i] == b'.' {
        i += 1;
        let pstart = i;
        while i < bytes.len() && bytes[i].is_ascii_digit() {
            i += 1;
        }
        if i == pstart {
            return None;
        }
        prec = spec[pstart..i].parse::<i64>().ok();
    }
    let kind = if i < bytes.len() {
        let c = spec[i..].chars().next()?;
        if !matches!(c, 'f' | 'F' | 'e' | 'E' | 'g' | 'G' | 'd' | 'x' | 'X' | 'o' | 'b' | '%' | 's')
        {
            return None;
        }
        if spec[i..].chars().count() != 1 {
            return None;
        }
        Some(c)
    } else {
        None
    };
    Some((fill, align, width, prec, kind))
}

fn fmt_label_id(kind: char) -> &'static str {
    match kind {
        'f' => "f",
        'F' => "F",
        'e' => "e",
        'E' => "E",
        'g' => "g",
        'G' => "G",
        _ => "pct",
    }
}
