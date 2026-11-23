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
                Type::Struct(sname) => {
                    return Err(Diagnostic::new(
                        format!(
                            "`print` does not format class/struct `{sname}` automatically; print its fields or an f-string"
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
            self.emit_print_inline_val(ty, val, *aspan, out)?;
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

    fn emit_print_inline_val(
        &mut self,
        ty: &Type,
        val: &str,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        self.used_print_inline = true;
        match ty {
            Type::Str => {
                self.used_str_print = true;
                let _ = writeln!(
                    out,
                    "  call fastcc void @archx_str_print(%ArchxStr {val}, i1 false)"
                );
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
            Type::Struct(sname) => {
                return Err(Diagnostic::new(
                    format!(
                        "`print` does not format class/struct `{sname}` automatically; print its fields or an f-string"
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
        if !matches!(elem_ty, Type::Int | Type::Float | Type::Bool | Type::Str) {
            return Err(Diagnostic::new(
                "`print` supports 1D lists (`list[int]`, `list[float]`, `list[bool]`, `list[str]`); print elements in a loop for structs or nested lists",
                span,
            ));
        }
        self.used_array_print = true;
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
        match elem_ty {
            Type::Int => {
                let pc = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {pc} = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 {elem_val})"
                );
            }
            Type::Float => {
                self.used_print_float = true;
                let _ = writeln!(
                    out,
                    "  call fastcc void @archx_print_float(double {elem_val}, i1 false)"
                );
            }
            Type::Str => {
                self.used_str_print = true;
                let _ = writeln!(
                    out,
                    "  call fastcc void @archx_str_print(%ArchxStr {elem_val}, i1 false)"
                );
            }
            Type::Bool => {
                let sel = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {sel} = select i1 {elem_val}, ptr @.str.true, ptr @.str.false"
                );
                let pc = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {pc} = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr {sel})"
                );
            }
            _ => unreachable!(),
        }
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
            };
            acc = Some(match acc {
                None => seg,
                Some(prev) => self.emit_str_concat_call(&prev, &seg, out),
            });
        }
        Ok((Type::Str, acc.unwrap()))
    }
}
