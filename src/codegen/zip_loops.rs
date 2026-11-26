//! Milestone 9 (`v0.9.0`) — `zip(...)`, fused `for a, b in zip(...)`, and generalized
//! tuple unpacking in `for` headers (`for a, b in pairs`, `for i, x in enumerate(xs, 1)`).
//!
//! `zip` is an **index-zipped walk**: every source is evaluated exactly once, then the loop
//! body reads `src_k[i]` from each source in parallel. Nothing is materialized, no tuple is
//! ever constructed, and the nest is a single counter-driven loop that LLVM can unroll and
//! vectorize. `zip` used as a *value* (`list(zip(a, b))`, `dict(zip(ks, vs))`) materializes
//! `list[tuple[...]]` once with a pre-sized buffer, so appends never reallocate.

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

/// One evaluated zip source: element type, whole value SSA, data pointer, and length.
struct ZipSrc {
    elem_ty: Type,
    value: String,
    data: String,
    len: String,
}

impl Codegen {

    /// Evaluates one zip source, extracting data pointer and length.
    fn eval_zip_source(&mut self, expr: &Expr, out: &mut String) -> Result<ZipSrc> {
        let (ty, value) = self.eval_expr(expr, out)?;
        match ty {
            Type::Array(elem) => {
                let data = self.next_tmp();
                let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {value}, 2");
                let len = self.next_tmp();
                let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {value}, 0");
                Ok(ZipSrc {
                    elem_ty: *elem,
                    value,
                    data,
                    len,
                })
            }
            Type::Str => {
                let w0 = self.next_tmp();
                let _ = writeln!(out, "  {w0} = extractvalue %ArchxStr {value}, 0");
                let len = self.next_tmp();
                let _ = writeln!(out, "  {len} = and i64 {w0}, 4294967295");
                let data = self.next_tmp();
                let _ = writeln!(out, "  {data} = extractvalue %ArchxStr {value}, 1");
                Ok(ZipSrc {
                    elem_ty: Type::Str,
                    value,
                    data,
                    len,
                })
            }
            other => Err(Diagnostic::new(
                format!(
                    "`zip(...)` requires lists or strings, found `{}`",
                    other.name()
                ),
                expr.span,
            )),
        }
    }

    /// Reads element `idx` of a zip source, yielding the unboxed value.
    fn load_zip_element(&mut self, src: &ZipSrc, idx: &str, out: &mut String) -> String {
        if src.elem_ty == Type::Str {
            self.used_str_byte_at = true;
            let ch = self.next_tmp();
            let _ = writeln!(
                out,
                "  {ch} = call fastcc %ArchxStr @archx_str_byte_at(%ArchxStr {}, i64 {idx})",
                src.value
            );
            ch
        } else {
            let mem = elem_mem_ir_type(&src.elem_ty);
            let ep = self.next_tmp();
            let _ = writeln!(
                out,
                "  {ep} = getelementptr inbounds {mem}, ptr {}, i64 {idx}",
                src.data
            );
            self.emit_elem_load(&src.elem_ty, &ep, out)
        }
    }

    fn zip_len(sources: &[ZipSrc]) -> String {
        sources[0].len.clone()
    }

    fn min_len(&mut self, sources: &[ZipSrc], out: &mut String) -> String {
        let mut len_val = Self::zip_len(sources);
        let others: Vec<String> = sources.iter().skip(1).map(|s| s.len.clone()).collect();
        for l in others {
            let c = self.next_tmp();
            let _ = writeln!(out, "  {c} = icmp slt i64 {l}, {len_val}");
            let m = self.next_tmp();
            let _ = writeln!(out, "  {m} = select i1 {c}, i64 {l}, i64 {len_val}");
            len_val = m;
        }
        len_val
    }

    /// Binds a loop variable to a value, allocating a slot only when it is needed.
    fn bind_loop_var(&mut self, name: &str, ty: Type, val: &str, rdepth: usize, out: &mut String) {
        let needs_slot = self.mutated_vars.contains(name) || self.type_needs_drop(&ty);
        let storage = if needs_slot {
            let owned = if self.type_needs_drop(&ty) {
                self.emit_clone_value(&ty, val, out)
            } else {
                val.to_string()
            };
            let slot = self.next_slot(&format!("var.{name}"));
            let ty_ir = ir_type(&ty);
            let align = ir_align(&ty);
            let _ = writeln!(self.allocas, "  {slot} = alloca {ty_ir}, align {align}");
            let _ = writeln!(out, "  store {ty_ir} {owned}, ptr {slot}, align {align}");
            if self.type_needs_drop(&ty) {
                self.scopes
                    .last_mut()
                    .unwrap()
                    .owned_buffers
                    .push(DropTarget::TypedSlot {
                        ptr: slot.clone(),
                        ty: ty.clone(),
                    });
            }
            VarStorage::Slot(slot)
        } else {
            VarStorage::Imm(val.to_string())
        };
        // Zip loop variables are function-scoped, like every other Python loop variable.
        self.scopes[0].vars.insert(
            name.to_string(),
            VarEntry {
                ty,
                storage,
                is_param: false,
                region_depth: rdepth,
            },
        );
    }

    // ---------------- `for a, b, ... in <iterable>` -------------------------

    pub(super) fn gen_for_tuple_unpack(
        &mut self,
        vars: &[String],
        iter: &Expr,
        body: &[Stmt],
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        // `for a, b in zip(...)`: peel directly into the fused zip loop.
        if let ExprKind::Call { name, args } = &iter.kind {
            if name == "zip" {
                if args.len() != vars.len() {
                    return Err(Diagnostic::new(
                        format!(
                            "`zip(...)` supplies {} iterable(s) but the `for` header unpacks {} variable(s)",
                            args.len(),
                            vars.len()
                        ),
                        iter.span,
                    ));
                }
                return self.gen_for_zip(vars, args, body, span, out);
            }
            if name == "enumerate" && args.len() == 2 && vars.len() == 2 {
                return self.gen_for_enumerate_pair(vars, args, body, span, out);
            }
        }
        // `for k, v in d.items()`: reuse the dict-items walker.
        if let ExprKind::MethodCall {
            target,
            method,
            args,
        } = &iter.kind
        {
            if method == "items" && args.is_empty() && vars.len() == 2 {
                return self.gen_for_dict_items(&vars[0], &vars[1], target, body, span, out);
            }
        }

        // Generic element unpacking: iterate a list of tuples and destructure each element.
        let (iter_ty, iter_val) = self.eval_expr(iter, out)?;
        let Type::Array(elem_ty) = iter_ty else {
            return Err(Diagnostic::new(
                format!(
                    "`for ... in` with {} targets expects a list of tuples, found `{}`",
                    vars.len(),
                    iter_ty.name()
                ),
                iter.span,
            ));
        };
        let Type::Tuple(items) = *elem_ty else {
            return Err(Diagnostic::new(
                format!(
                    "`for ... in` with {} targets expects a list of tuples, found elements of type `{}`",
                    vars.len(),
                    elem_ty.name()
                ),
                iter.span,
            ));
        };
        if items.len() != vars.len() {
            return Err(Diagnostic::new(
                format!(
                    "loop unpacks {} variable(s) but tuples have {} element(s)",
                    vars.len(),
                    items.len()
                ),
                iter.span,
            ));
        }

        let tup_ty = Type::Tuple(items.clone());
        let tup_ir = ir_type(&tup_ty);
        let hold_outer = self.claim_stmt_temp(&iter_val);
        self.flush_stmt_temps(out);
        if hold_outer {
            self.push_scope();
            let hslot = self.next_slot("unpack.iter");
            let _ = writeln!(self.allocas, "  {hslot} = alloca %ArchxVec, align 8");
            let _ = writeln!(out, "  store %ArchxVec {iter_val}, ptr {hslot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: hslot,
                    ty: Type::Array(Box::new(tup_ty.clone())),
                });
        }

        let len_val = self.next_tmp();
        let _ = writeln!(out, "  {len_val} = extractvalue %ArchxVec {iter_val}, 0");
        let data_ptr = self.next_tmp();
        let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {iter_val}, 2");
        let idx_slot = self.next_slot("unpack.idx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

        let cond_lbl = self.fresh_label("unpack.cond");
        let body_lbl = self.fresh_label("unpack.body");
        let step_lbl = self.fresh_label("unpack.step");
        let end_lbl = self.fresh_label("unpack.end");
        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {idx_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len_val}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let tp = self.next_tmp();
        let _ = writeln!(
            out,
            "  {tp} = getelementptr inbounds {tup_ir}, ptr {data_ptr}, i64 {i}"
        );
        let tval = self.next_tmp();
        let _ = writeln!(out, "  {tval} = load {tup_ir}, ptr {tp}, align 8");

        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        for (vi, (vname, vty)) in vars.iter().zip(items.iter()).enumerate() {
            let fv = self.next_tmp();
            let _ = writeln!(out, "  {fv} = extractvalue {tup_ir} {tval}, {vi}");
            self.bind_loop_var(vname, vty.clone(), &fv, outer_rdepth, out);
        }
        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_lbl.clone(),
            continue_label: step_lbl.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_lbl, out);
        }

        self.start_block(&step_lbl, out);
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        if hold_outer {
            self.pop_scope_with_drops(out);
        }
        Ok(())
    }

    // ---------------- Fused `zip` loop --------------------------------------

    pub(super) fn gen_for_zip(
        &mut self,
        vars: &[String],
        iters: &[Expr],
        body: &[Stmt],
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        let mut sources: Vec<ZipSrc> = Vec::with_capacity(iters.len());
        for it in iters {
            sources.push(self.eval_zip_source(it, out)?);
        }
        // Any temporary produced while evaluating the sources must outlive the loop.
        let mut held: Vec<(String, Type)> = Vec::new();
        for (it, src) in iters.iter().zip(sources.iter()) {
            if self.claim_stmt_temp(&src.value) {
                held.push((src.value.clone(), self.infer_ty(it).unwrap_or(Type::Any)));
            }
        }
        for (val, ty) in &held {
            let slot = self.next_slot("zip.src");
            let ty_ir = ir_type(ty);
            let _ = writeln!(self.allocas, "  {slot} = alloca {ty_ir}, align 8");
            let _ = writeln!(out, "  store {ty_ir} {val}, ptr {slot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: slot,
                    ty: ty.clone(),
                });
        }
        self.flush_stmt_temps(out);

        let len_val = self.min_len(&sources, out);
        let idx_slot = self.next_slot("zip.idx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");

        let cond_lbl = self.fresh_label("zip.cond");
        let body_lbl = self.fresh_label("zip.body");
        let step_lbl = self.fresh_label("zip.step");
        let end_lbl = self.fresh_label("zip.end");
        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {idx_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len_val}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        for (vname, src) in vars.iter().zip(sources.iter()) {
            let val = self.load_zip_element(src, &i, out);
            self.bind_loop_var(vname, src.elem_ty.clone(), &val, outer_rdepth, out);
        }
        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_lbl.clone(),
            continue_label: step_lbl.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_lbl, out);
        }

        self.start_block(&step_lbl, out);
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        let _ = span;
        Ok(())
    }

    /// `for idx, elem in enumerate(xs, start)` — fused index/element walk.
    fn gen_for_enumerate_pair(
        &mut self,
        vars: &[String],
        args: &[Expr],
        body: &[Stmt],
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        let (ty, val) = self.eval_expr(&args[0], out)?;
        let Type::Array(elem_ty) = ty.clone() else {
            return Err(Diagnostic::new(
                "`enumerate(...)` requires a list",
                args[0].span,
            ));
        };
        let (_, start_val) = self.eval_expr(&args[1], out)?;
        let hold_outer = self.claim_stmt_temp(&val);
        self.flush_stmt_temps(out);
        if hold_outer {
            self.push_scope();
            let hslot = self.next_slot("enum.iter");
            let _ = writeln!(self.allocas, "  {hslot} = alloca %ArchxVec, align 8");
            let _ = writeln!(out, "  store %ArchxVec {val}, ptr {hslot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: hslot,
                    ty: ty.clone(),
                });
        }
        let len_val = self.next_tmp();
        let _ = writeln!(out, "  {len_val} = extractvalue %ArchxVec {val}, 0");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {val}, 2");
        let idx_slot = self.next_slot("enum.idx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");
        let cur_slot = self.next_slot("enum.cur");
        let _ = writeln!(self.allocas, "  {cur_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 {start_val}, ptr {cur_slot}, align 8");

        let cond_lbl = self.fresh_label("enum.cond");
        let body_lbl = self.fresh_label("enum.body");
        let step_lbl = self.fresh_label("enum.step");
        let end_lbl = self.fresh_label("enum.end");
        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {idx_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len_val}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load i64, ptr {cur_slot}, align 8");
        let mem = elem_mem_ir_type(&elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(out, "  {ep} = getelementptr inbounds {mem}, ptr {data}, i64 {i}");
        let raw = self.emit_elem_load(&elem_ty, &ep, out);

        let outer_depth = self.scopes.len();
        let outer_rdepth = self.region_stack.len();
        self.push_scope();
        self.bind_loop_var(&vars[0], Type::Int, &cur, outer_rdepth, out);
        self.bind_loop_var(&vars[1], (*elem_ty).clone(), &raw, outer_rdepth, out);
        self.loop_stack.push(LoopLabels {
            break_flag: self.pending_break_flag.take(),
            break_label: end_lbl.clone(),
            continue_label: step_lbl.clone(),
            scope_depth: outer_depth,
            region_depth: outer_rdepth,
        });
        self.gen_block(body, out)?;
        self.loop_stack.pop();
        self.pop_scope_with_drops(out);
        if !self.terminated {
            self.emit_br(&step_lbl, out);
        }

        self.start_block(&step_lbl, out);
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {idx_slot}, align 8");
        let nc = self.next_tmp();
        let _ = writeln!(out, "  {nc} = add nsw i64 {cur}, 1");
        let _ = writeln!(out, "  store i64 {nc}, ptr {cur_slot}, align 8");
        self.emit_br(&cond_lbl, out);

        self.start_block(&end_lbl, out);
        if hold_outer {
            self.pop_scope_with_drops(out);
        }
        let _ = span;
        Ok(())
    }

    // ---------------- `zip(...)` as a value ---------------------------------

    /// Materializes `zip(a, b, ...)` as `list[tuple[...]]` in one pre-sized buffer.
    pub(super) fn eval_zip_value(
        &mut self,
        args: &[Expr],
        expected: Option<&Type>,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.is_empty() {
            return Err(Diagnostic::new("`zip()` requires at least 1 argument", span));
        }
        let mut sources: Vec<ZipSrc> = Vec::with_capacity(args.len());
        for a in args {
            sources.push(self.eval_zip_source(a, out)?);
        }
        let mut held: Vec<(String, Type)> = Vec::new();
        for (a, src) in args.iter().zip(sources.iter()) {
            if self.claim_stmt_temp(&src.value) {
                held.push((src.value.clone(), self.infer_ty(a).unwrap_or(Type::Any)));
            }
        }
        for (val, ty) in &held {
            let slot = self.next_slot("zipv.src");
            let ty_ir = ir_type(ty);
            let _ = writeln!(self.allocas, "  {slot} = alloca {ty_ir}, align 8");
            let _ = writeln!(out, "  store {ty_ir} {val}, ptr {slot}, align 8");
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: slot,
                    ty: ty.clone(),
                });
        }
        self.flush_stmt_temps(out);

        let elems: Vec<Type> = sources.iter().map(|s| s.elem_ty.clone()).collect();
        let elem_ty = match expected {
            Some(Type::Array(inner)) => match inner.as_ref() {
                Type::Tuple(ts) if ts.len() == args.len() => Type::Tuple(ts.clone()),
                _ => Type::Tuple(elems),
            },
            _ => Type::Tuple(elems),
        };
        let arr_ty = Type::Array(Box::new(elem_ty.clone()));
        let len_val = self.min_len(&sources, out);

        let out_slot = self.next_slot("zipv.out");
        let _ = writeln!(self.allocas, "  {out_slot} = alloca %ArchxVec, align 8");
        let _ = writeln!(
            out,
            "  store %ArchxVec zeroinitializer, ptr {out_slot}, align 8"
        );
        let elem_sz = self.emit_elem_sizeof(&elem_ty, out);
        let bytes = self.emit_elem_bytes_val_mul(&len_val, &elem_sz, out);
        let (data, cap) = if !self.region_stack.is_empty() && !self.type_needs_drop(&elem_ty) {
            let rslot = self.func_region_slot.clone().unwrap();
            let p = self.next_tmp();
            let _ = writeln!(
                out,
                "  {p} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
            );
            let nc = self.next_tmp();
            let _ = writeln!(out, "  {nc} = sub nsw i64 0, {len_val}");
            (p, nc)
        } else {
            (self.emit_checked_malloc(&bytes, out), len_val.clone())
        };
        let v0 = self.build_vec_val("0", &cap, &data, out);
        let _ = writeln!(out, "  store %ArchxVec {v0}, ptr {out_slot}, align 8");

        let tup_ir = ir_type(&elem_ty);
        let tup_elems: Vec<Type> = match &elem_ty {
            Type::Tuple(ts) => ts.clone(),
            _ => vec![Type::Any; sources.len()],
        };
        let mem = elem_mem_ir_type(&elem_ty);

        let idx_slot = self.next_slot("zipv.idx");
        let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {idx_slot}, align 8");
        let cond_lbl = self.fresh_label("zipv.cond");
        let body_lbl = self.fresh_label("zipv.body");
        let step_lbl = self.fresh_label("zipv.step");
        let end_lbl = self.fresh_label("zipv.end");
        self.emit_br(&cond_lbl, out);
        self.start_block(&cond_lbl, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {idx_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len_val}");
        self.emit_cond_br(&more, &body_lbl, &end_lbl, out);

        self.start_block(&body_lbl, out);
        let mut agg = "poison".to_string();
        for (ti, (src, out_ty)) in sources.iter().zip(tup_elems.iter()).enumerate() {
            let v = self.load_zip_element(src, &i, out);
            let next_agg = self.next_tmp();
            let _ = writeln!(
                out,
                "  {next_agg} = insertvalue {tup_ir} {agg}, {} {v}, {ti}",
                ir_type(out_ty)
            );
            agg = next_agg;
        }
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {out_slot}, align 8");
        let data0 = self.next_tmp();
        let _ = writeln!(out, "  {data0} = extractvalue %ArchxVec {vec}, 2");
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem}, ptr {data0}, i64 {i}"
        );
        self.emit_elem_store(&elem_ty, &agg, &ep, out);
        self.emit_br(&step_lbl, out);

        self.start_block(&step_lbl, out);
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nuw nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {idx_slot}, align 8");
        self.emit_br(&cond_lbl, out);
        self.start_block(&end_lbl, out);

        let res = self.next_tmp();
        let _ = writeln!(out, "  {res} = load %ArchxVec, ptr {out_slot}, align 8");
        let filled = self.next_tmp();
        let _ = writeln!(out, "  {filled} = insertvalue %ArchxVec {res}, i64 {len_val}, 0");
        self.stmt_temps.push(TempDrop {
            val: filled.clone(),
            ty: arr_ty.clone(),
        });
        Ok((arr_ty, filled))
    }
}
