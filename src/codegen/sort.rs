//! Milestone 9 (`v0.9.0`) — inline monomorphized sorting: `sorted(xs, key=..., reverse=...)`
//! and `xs.sort(key=..., reverse=...)`.
//!
//! Everything is emitted as **inline IR**: no comparator callbacks, no boxing, no dynamic
//! dispatch, no intermediate list of Python objects.
//!
//! The single engine is a **stable bottom-up merge sort**, which for this workload beats the
//! classic quicksort choice on every axis that matters here:
//!
//! * `O(N log N)` compares *and* moves with **no quadratic worst case** (a keyless quicksort
//!   on adversarial input degrades to `O(N^2)`; the `introsort` fix adds a heapsort fallback
//!   and a recursion depth guard — all of which disappear here).
//! * **No recursion**, so no shadow stack and no depth-dependent stack blow-up.
//! * **Stable by construction** — equal keys never cross, so no tie-break bookkeeping is
//!   needed for keyless sorts; keyed sorts carry an explicit `orig_idx` field.
//! * Runs of 16 are insertion-sorted first, so short inputs take a single linear pass and
//!   the merge stage then works on already-sorted runs (branch-predictable, cache-friendly).
//!
//! **Keyed** sorts use a **planar Schwartzian transform**: one contiguous array of
//! `{ key, orig_idx }` records, filled with exactly `N` key evaluations (the key expression is
//! inlined into the fill loop, with the lambda parameter bound to the loaded element), sorted,
//! then applied back to the payload as a raw byte gather. Payload elements are *moved*, never
//! cloned, so owned values (`str`, `list`, `dict`) keep exactly one owner.
//!
//! `reverse=True` inverts only the **key** comparison; `orig_idx` still ascends, so sorting is
//! stable for `reverse=True` too — matching Python's `sorted` / `list.sort` exactly.

use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

/// Size of the insertion-sorted runs the first pass produces.
const RUN_LEN: i64 = 16;

#[derive(Clone, Copy, PartialEq, Eq)]
enum KeyKind {
    Int,
    Float,
    Bool,
    Str,
}

impl KeyKind {
    fn size(self) -> i64 {
        match self {
            KeyKind::Str => 16,
            KeyKind::Bool => 1,
            _ => 8,
        }
    }

    fn ir(self) -> &'static str {
        match self {
            KeyKind::Str => "%ArchxStr",
            KeyKind::Float => "double",
            KeyKind::Bool => "i8",
            KeyKind::Int => "i64",
        }
    }
}

/// An inlineable `key=` callable: the parameter name plus the key expression.
#[derive(Clone, Debug)]
pub(super) struct LambdaSpec {
    pub param: String,
    pub body: Expr,
}

impl LambdaSpec {
    pub(super) fn from_expr(expr: &Expr) -> Result<Self> {
        match &expr.kind {
            ExprKind::Lambda { params, body } => {
                if params.len() != 1 {
                    return Err(Diagnostic::new(
                        "`key=` lambdas take exactly 1 parameter (e.g. `key=lambda x: -x`)",
                        expr.span,
                    ));
                }
                Ok(LambdaSpec {
                    param: params[0].name.clone(),
                    body: (**body).clone(),
                })
            }
            _ => Err(Diagnostic::new(
                "`key=` must be a `lambda` (e.g. `key=lambda x: -x`)",
                expr.span,
            )),
        }
    }
}

/// Static description of one merge-sort invocation.
struct SortCfg {
    /// Base pointer of the array being sorted **in place**.
    base: String,
    len: String,
    /// Bytes per record (element size for keyless, record size for keyed).
    stride: i64,
    /// Byte offset of the sort key inside a record.
    key_off: i64,
    kind: KeyKind,
    /// For keyed sorts: byte offset of the `orig_idx` stability field.
    idx_off: Option<i64>,
    reverse: bool,
}

impl Codegen {
    // ---------------- Public entry points ----------------------------------

    /// `sorted(xs, key=..., reverse=...)` → a fresh sorted list.
    pub(super) fn gen_sorted(
        &mut self,
        pos_args: &[Expr],
        kw_args: &[(String, Expr, Span)],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if pos_args.len() != 1 {
            return Err(Diagnostic::new(
                "`sorted(...)` takes exactly 1 positional argument: `sorted(list, key=..., reverse=...)`",
                span,
            ));
        }
        let (src_ty, src_vec) = self.eval_expr(&pos_args[0], out)?;
        let Type::Array(elem_ty) = src_ty.clone() else {
            return Err(Diagnostic::new(
                format!("`sorted(...)` expects a list, found `{}`", src_ty.name()),
                pos_args[0].span,
            ));
        };
        let (key, reverse) = parse_sort_kwargs(kw_args, "sorted")?;
        let copy = self.emit_vec_shallow_copy(&elem_ty, &src_vec, out);
        self.sort_list(&elem_ty, &copy, key, reverse, pos_args[0].span, out)?;
        self.stmt_temps.push(TempDrop {
            val: copy.clone(),
            ty: src_ty.clone(),
        });
        Ok((src_ty, copy))
    }

    /// `xs.sort(key=..., reverse=...)` → sorts the list in place, evaluates to `None`.
    pub(super) fn gen_list_sort(
        &mut self,
        target: &Expr,
        pos_args: &[Expr],
        kw_args: &[(String, Expr, Span)],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if !pos_args.is_empty() {
            return Err(Diagnostic::new(
                "`list.sort()` takes no positional arguments; use `key=` / `reverse=`",
                span,
            ));
        }
        let ExprKind::Var(name) = &target.kind else {
            return Err(Diagnostic::new(
                "`list.sort()` must be called on a list variable",
                target.span,
            ));
        };
        let entry = self.lookup_var(name).cloned().ok_or_else(|| {
            Diagnostic::new(format!("undefined variable `{name}`"), target.span)
        })?;
        if entry.is_param {
            return Err(Diagnostic::new(
                format!(
                    "cannot sort borrowed parameter `{name}` in place; assign it to a local list first"
                ),
                target.span,
            ));
        }
        let Type::Array(elem_ty) = entry.ty.clone() else {
            return Err(Diagnostic::new(
                format!("`sort()` expects a `list`, found `{}`", entry.ty.name()),
                target.span,
            ));
        };
        let VarStorage::Slot(slot) = entry.storage else {
            return Err(Diagnostic::new(
                format!("internal error: sorted list `{name}` has no storage slot"),
                span,
            ));
        };
        let (key, reverse) = parse_sort_kwargs(kw_args, "sort")?;
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot}, align 8");
        self.sort_list(&elem_ty, &vec, key, reverse, span, out)?;
        Ok((Type::Void, String::new()))
    }

    /// Shallow list copy: `memcpy` for drop-free elements, element clone otherwise.
    fn emit_vec_shallow_copy(&mut self, elem_ty: &Type, vec_val: &str, out: &mut String) -> String {
        if self.type_needs_drop(elem_ty) {
            let helper = self.ensure_vec_clone_helper(elem_ty);
            let r = self.next_tmp();
            let _ = writeln!(
                out,
                "  {r} = call fastcc %ArchxVec {helper}(%ArchxVec {vec_val})"
            );
            return r;
        }
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec_val}, 0");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec_val}, 2");
        let elem_sz = self.emit_elem_sizeof(elem_ty, out);
        let bytes = self.emit_elem_bytes_val_mul(&len, &elem_sz, out);
        let (dst, cap) = if !self.region_stack.is_empty() {
            let rslot = self.func_region_slot.clone().unwrap();
            let p = self.next_tmp();
            let _ = writeln!(
                out,
                "  {p} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
            );
            let nc = self.next_tmp();
            let _ = writeln!(out, "  {nc} = sub nsw i64 0, {len}");
            (p, nc)
        } else {
            (self.emit_checked_malloc(&bytes, out), len.clone())
        };
        self.used_memcpy = true;
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 16 {dst}, ptr align 8 {data}, i64 {bytes}, i1 false)"
        );
        self.build_vec_val(&len, &cap, &dst, out)
    }

    // ---------------- Driver ------------------------------------------------

    fn sort_list(
        &mut self,
        elem_ty: &Type,
        vec_val: &str,
        key: Option<LambdaSpec>,
        reverse: bool,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec_val}, 0");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec_val}, 2");
        let tiny = self.next_tmp();
        let _ = writeln!(out, "  {tiny} = icmp slt i64 {len}, 2");
        let work = self.fresh_label("sort.work");
        let done = self.fresh_label("sort.done");
        self.emit_cond_br(&tiny, &done, &work, out);
        self.start_block(&work, out);

        match key {
            None => {
                let kind = keyless_kind(elem_ty, span)?;
                // A keyless sort shuffles *raw bytes*, so the stride is the exact element
                // size (1 for `bool`, which compares as `i8`).
                let stride = if kind == KeyKind::Bool { 1 } else { self.elem_stride(elem_ty, out) };
                let cfg = SortCfg {
                    base: data,
                    len,
                    stride,
                    key_off: 0,
                    kind,
                    idx_off: None,
                    reverse,
                };
                self.emit_merge_sort(&cfg, out);
            }
            Some(spec) => {
                self.emit_keyed_sort(elem_ty, &data, &len, reverse, &spec, span, out)?;
            }
        }

        self.emit_br(&done, out);
        self.start_block(&done, out);
        Ok(())
    }

    fn elem_stride(&mut self, elem_ty: &Type, out: &mut String) -> i64 {
        match elem_ty {
            Type::Int | Type::Float | Type::Dict(_, _) | Type::Set(_) => 8,
            Type::Bool => 1,
            Type::Str => 16,
            Type::Array(_) | Type::Any => 24,
            other => {
                let sz = self.emit_elem_sizeof(other, out);
                sz.parse::<i64>().unwrap_or(8)
            }
        }
    }

    // ---------------- Keyed: planar Schwartzian transform -------------------

    #[allow(clippy::too_many_arguments)]
    fn emit_keyed_sort(
        &mut self,
        elem_ty: &Type,
        data: &str,
        len: &str,
        reverse: bool,
        spec: &LambdaSpec,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        // 1. Key type: probe the key expression against the first element.
        let elem_ir = ir_type(elem_ty);
        let probe = self.next_tmp();
        let _ = writeln!(out, "  {probe} = load {elem_ir}, ptr {data}, align 8");
        let saved = self.lookup_var(&spec.param).cloned();
        self.bind_probe(&spec.param, elem_ty.clone(), probe);
        let key_ty = self.infer_ty(&spec.body).unwrap_or(Type::Any);
        self.restore_probe(&spec.param, saved.clone());
        let kind = match key_ty {
            Type::Int => KeyKind::Int,
            Type::Float => KeyKind::Float,
            Type::Bool => KeyKind::Bool,
            Type::Str => KeyKind::Str,
            other => {
                return Err(Diagnostic::new(
                    format!(
                        "sort `key=` must return `int`, `float`, `bool`, or `str`, found `{}`",
                        other.name()
                    ),
                    span,
                ))
            }
        };

        // 2. Contiguous `{ key, orig_idx }` records (packed, 8-byte aligned).
        let key_bytes = kind.size();
        let idx_off = if key_bytes == 1 { 1 } else { key_bytes };
        let rec_bytes = idx_off + 8;
        let rec_total = self.emit_int_mul(len, &rec_bytes.to_string(), out);
        let use_region = !self.region_stack.is_empty();
        let scratch = if use_region {
            let rslot = self.func_region_slot.clone().unwrap();
            let p = self.next_tmp();
            let _ = writeln!(
                out,
                "  {p} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {rec_total})"
            );
            p
        } else {
            self.emit_checked_malloc(&rec_total, out)
        };

        // 3. Fill: exactly N key evaluations, key expression inlined into the loop.
        let i_slot = self.next_slot("sort.fill.i");
        let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {i_slot}, align 8");
        let fill_cond = self.fresh_label("sort.fill");
        let fill_body = self.fresh_label("sort.fill.body");
        let fill_end = self.fresh_label("sort.fill.end");
        self.emit_br(&fill_cond, out);
        self.start_block(&fill_cond, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {i}, {len}");
        self.emit_cond_br(&more, &fill_body, &fill_end, out);

        self.start_block(&fill_body, out);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {elem_ir}, ptr {data}, i64 {i}"
        );
        let elem_val = self.emit_elem_load(elem_ty, &ep, out);
        // Bind the lambda parameter to the loaded element by *reference* (no clone).
        self.bind_probe(&spec.param, elem_ty.clone(), elem_val);
        let key_val = self.eval_key_expr(&spec.body, kind, out)?;
        self.restore_probe(&spec.param, saved.clone());

        let pad = self.next_tmp();
        let _ = writeln!(out, "  {pad} = mul nuw nsw i64 {i}, {rec_bytes}");
        let recptr = self.next_tmp();
        let _ = writeln!(
            out,
            "  {recptr} = getelementptr inbounds i8, ptr {scratch}, i64 {pad}"
        );
        let kptr = self.next_tmp();
        let _ = writeln!(out, "  {kptr} = getelementptr inbounds i8, ptr {recptr}, i64 0");
        let _ = writeln!(out, "  store {} {key_val}, ptr {kptr}, align 8", kind.ir());
        let iptr = self.next_tmp();
        let _ = writeln!(
            out,
            "  {iptr} = getelementptr inbounds i8, ptr {recptr}, i64 {idx_off}"
        );
        let _ = writeln!(out, "  store i64 {i}, ptr {iptr}, align 8");
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {i_slot}, align 8");
        self.emit_br(&fill_cond, out);
        self.start_block(&fill_end, out);

        // 4. Sort the records by (key, orig_idx).
        let cfg = SortCfg {
            base: scratch.clone(),
            len: len.to_string(),
            stride: rec_bytes,
            key_off: 0,
            kind,
            idx_off: Some(idx_off),
            reverse,
        };
        self.emit_merge_sort(&cfg, out);

        // 5. Apply the permutation as a raw byte gather (payloads are moved, not cloned).
        let elem_bytes = self.elem_stride(elem_ty, out);
        let total = self.emit_int_mul(len, &elem_bytes.to_string(), out);
        let tmp = if use_region {
            let rslot = self.func_region_slot.clone().unwrap();
            let p = self.next_tmp();
            let _ = writeln!(
                out,
                "  {p} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {total})"
            );
            p
        } else {
            self.emit_checked_malloc(&total, out)
        };
        self.used_memcpy = true;
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 16 {tmp}, ptr align 8 {data}, i64 {total}, i1 false)"
        );

        let g_slot = self.next_slot("sort.gather.i");
        let _ = writeln!(self.allocas, "  {g_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {g_slot}, align 8");
        let g_cond = self.fresh_label("sort.gather");
        let g_body = self.fresh_label("sort.gather.body");
        let g_end = self.fresh_label("sort.gather.end");
        self.emit_br(&g_cond, out);
        self.start_block(&g_cond, out);
        let gi = self.next_tmp();
        let _ = writeln!(out, "  {gi} = load i64, ptr {g_slot}, align 8");
        let gmore = self.next_tmp();
        let _ = writeln!(out, "  {gmore} = icmp slt i64 {gi}, {len}");
        self.emit_cond_br(&gmore, &g_body, &g_end, out);

        self.start_block(&g_body, out);
        let rpad = self.next_tmp();
        let _ = writeln!(out, "  {rpad} = mul nuw nsw i64 {gi}, {rec_bytes}");
        let rptr = self.next_tmp();
        let _ = writeln!(
            out,
            "  {rptr} = getelementptr inbounds i8, ptr {scratch}, i64 {rpad}"
        );
        let optr = self.next_tmp();
        let _ = writeln!(
            out,
            "  {optr} = getelementptr inbounds i8, ptr {rptr}, i64 {idx_off}"
        );
        let orig = self.next_tmp();
        let _ = writeln!(out, "  {orig} = load i64, ptr {optr}, align 8");
        let spad = self.next_tmp();
        let _ = writeln!(out, "  {spad} = mul nuw nsw i64 {orig}, {elem_bytes}");
        let sptr = self.next_tmp();
        let _ = writeln!(
            out,
            "  {sptr} = getelementptr inbounds i8, ptr {tmp}, i64 {spad}"
        );
        let dslot = self.next_tmp();
        let _ = writeln!(out, "  {dslot} = mul nuw nsw i64 {gi}, {elem_bytes}");
        let dptr = self.next_tmp();
        let _ = writeln!(
            out,
            "  {dptr} = getelementptr inbounds i8, ptr {data}, i64 {dslot}"
        );
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {dptr}, ptr align 16 {sptr}, i64 {elem_bytes}, i1 false)"
        );
        let gni = self.next_tmp();
        let _ = writeln!(out, "  {gni} = add nsw i64 {gi}, 1");
        let _ = writeln!(out, "  store i64 {gni}, ptr {g_slot}, align 8");
        self.emit_br(&g_cond, out);
        self.start_block(&g_end, out);

        if !use_region {
            self.used_free = true;
            let _ = writeln!(out, "  call void @free(ptr {tmp})");
            let _ = writeln!(out, "  call void @free(ptr {scratch})");
        }
        Ok(())
    }

    fn bind_probe(&mut self, name: &str, ty: Type, val: String) {
        let depth = self.region_stack.len();
        self.scopes.last_mut().unwrap().vars.insert(
            name.to_string(),
            VarEntry {
                ty,
                storage: VarStorage::Imm(val),
                is_param: true,
                region_depth: depth,
            },
        );
    }

    fn restore_probe(&mut self, name: &str, prev: Option<VarEntry>) {
        match prev {
            Some(e) => {
                self.scopes.last_mut().unwrap().vars.insert(name.to_string(), e);
            }
            None => {
                self.scopes.last_mut().unwrap().vars.remove(name);
            }
        }
    }

    fn eval_key_expr(&mut self, expr: &Expr, kind: KeyKind, out: &mut String) -> Result<String> {
        let (ty, val) = self.eval_expr(expr, out)?;
        Ok(match (kind, &ty) {
            (KeyKind::Bool, Type::Bool) => {
                let z = self.next_tmp();
                let _ = writeln!(out, "  {z} = zext i1 {val} to i64");
                z
            }
            (KeyKind::Int, Type::Int) | (KeyKind::Float, Type::Float) | (KeyKind::Str, Type::Str) => {
                val
            }
            (KeyKind::Int, Type::Float) => {
                let c = self.next_tmp();
                let _ = writeln!(out, "  {c} = fptosi double {val} to i64");
                c
            }
            (KeyKind::Float, Type::Int) => {
                let c = self.next_tmp();
                let _ = writeln!(out, "  {c} = sitofp i64 {val} to double");
                c
            }
            _ => {
                return Err(Diagnostic::new(
                    format!(
                        "sort `key=` returns `{}` but the key record holds `{}`",
                        ty.name(),
                        kind.ir()
                    ),
                    expr.span,
                ))
            }
        })
    }

    fn emit_int_mul(&mut self, a: &str, b: &str, out: &mut String) -> String {
        let r = self.next_tmp();
        let _ = writeln!(out, "  {r} = mul nuw nsw i64 {a}, {b}");
        r
    }

    // ---------------- The merge sort ---------------------------------------

    /// Stable bottom-up merge sort over `cfg.base`, in place, using one scratch buffer.
    fn emit_merge_sort(&mut self, cfg: &SortCfg, out: &mut String) {
        let bytes = self.emit_int_mul(&cfg.len, &cfg.stride.to_string(), out);
        let use_region = !self.region_stack.is_empty();
        let scratch = if use_region {
            let rslot = self.func_region_slot.clone().unwrap();
            let p = self.next_tmp();
            let _ = writeln!(
                out,
                "  {p} = call fastcc nonnull align 16 ptr @archx_region_alloc(ptr {rslot}, i64 {bytes})"
            );
            p
        } else {
            self.emit_checked_malloc(&bytes, out)
        };
        self.used_memcpy = true;
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 16 {scratch}, ptr align 8 {}, i64 {bytes}, i1 false)",
            cfg.base
        );

        // Pass 0: insertion-sort runs of `RUN_LEN` inside `scratch`.
        self.emit_run_sort(cfg, &scratch, out);

        // Pass 0 wrote into `scratch`, and scratch is now run-sorted. The merge loop below
        // starts by copying `src -> dst`, so it must treat `scratch` as `src` and
        // `base` as `dst` (i.e. the "flip" state starts as "scratch holds the data").
        // This also makes short inputs (a single run, `len <= RUN_LEN`) correct with no
        // merge pass at all.

        // Passes 1..: merge runs, ping-ponging between `scratch` and `base`.
        let width_slot = self.next_slot("sort.width");
        let _ = writeln!(self.allocas, "  {width_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 {RUN_LEN}, ptr {width_slot}, align 8");
        let flip_slot = self.next_slot("sort.flip");
        let _ = writeln!(self.allocas, "  {flip_slot} = alloca i1, align 1");
        let _ = writeln!(out, "  store i1 true, ptr {flip_slot}, align 1");

        let cond = self.fresh_label("sort.pass");
        let body = self.fresh_label("sort.pass.body");
        let after = self.fresh_label("sort.pass.after");
        let restore = self.fresh_label("sort.restore");
        let finish = self.fresh_label("sort.finish");
        self.emit_br(&cond, out);
        self.start_block(&cond, out);
        let width = self.next_tmp();
        let _ = writeln!(out, "  {width} = load i64, ptr {width_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {width}, {}", cfg.len);
        self.emit_cond_br(&more, &body, &after, out);

        self.start_block(&body, out);
        let flipped = self.next_tmp();
        let _ = writeln!(out, "  {flipped} = load i1, ptr {flip_slot}, align 1");
        let src = self.next_tmp();
        let _ = writeln!(
            out,
            "  {src} = select i1 {flipped}, ptr {scratch}, ptr {}",
            cfg.base
        );
        let dst = self.next_tmp();
        let _ = writeln!(
            out,
            "  {dst} = select i1 {flipped}, ptr {}, ptr {scratch}",
            cfg.base
        );

        let lo_slot = self.next_slot("sort.lo");
        let _ = writeln!(self.allocas, "  {lo_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {lo_slot}, align 8");
        let run_cond = self.fresh_label("sort.run");
        let run_body = self.fresh_label("sort.run.body");
        let run_next = self.fresh_label("sort.run.next");
        let run_done = self.fresh_label("sort.run.done");
        self.emit_br(&run_cond, out);
        self.start_block(&run_cond, out);
        let lo = self.next_tmp();
        let _ = writeln!(out, "  {lo} = load i64, ptr {lo_slot}, align 8");
        let in_range = self.next_tmp();
        let _ = writeln!(out, "  {in_range} = icmp slt i64 {lo}, {}", cfg.len);
        self.emit_cond_br(&in_range, &run_body, &run_done, out);

        self.start_block(&run_body, out);
        let mid_raw = self.next_tmp();
        let _ = writeln!(out, "  {mid_raw} = add nsw i64 {lo}, {width}");
        let mid_over = self.next_tmp();
        let _ = writeln!(out, "  {mid_over} = icmp sgt i64 {mid_raw}, {}", cfg.len);
        let mid = self.next_tmp();
        let _ = writeln!(
            out,
            "  {mid} = select i1 {mid_over}, i64 {}, i64 {mid_raw}",
            cfg.len
        );
        let hi_raw = self.next_tmp();
        let _ = writeln!(out, "  {hi_raw} = add nsw i64 {mid_raw}, {width}");
        let hi_over = self.next_tmp();
        let _ = writeln!(out, "  {hi_over} = icmp sgt i64 {hi_raw}, {}", cfg.len);
        let hi = self.next_tmp();
        let _ = writeln!(
            out,
            "  {hi} = select i1 {hi_over}, i64 {}, i64 {hi_raw}",
            cfg.len
        );
        self.emit_merge_into(cfg, &src, &dst, &lo, &mid, &hi, out);
        self.emit_br(&run_next, out);

        self.start_block(&run_next, out);
        let lo2 = self.next_tmp();
        let _ = writeln!(out, "  {lo2} = load i64, ptr {lo_slot}, align 8");
        let step = self.next_tmp();
        let _ = writeln!(out, "  {step} = shl nuw nsw i64 {width}, 1");
        let lo_next = self.next_tmp();
        let _ = writeln!(out, "  {lo_next} = add nsw i64 {lo2}, {step}");
        let _ = writeln!(out, "  store i64 {lo_next}, ptr {lo_slot}, align 8");
        self.emit_br(&run_cond, out);

        self.start_block(&run_done, out);
        let inv = self.next_tmp();
        let _ = writeln!(out, "  {inv} = xor i1 {flipped}, true");
        let _ = writeln!(out, "  store i1 {inv}, ptr {flip_slot}, align 1");
        let doubled = self.next_tmp();
        let _ = writeln!(out, "  {doubled} = shl nuw nsw i64 {width}, 1");
        let _ = writeln!(out, "  store i64 {doubled}, ptr {width_slot}, align 8");
        self.emit_br(&cond, out);

        // Results live in `scratch` iff an odd number of passes flipped them there.
        self.start_block(&after, out);
        let flipped_end = self.next_tmp();
        let _ = writeln!(out, "  {flipped_end} = load i1, ptr {flip_slot}, align 1");
        self.emit_cond_br(&flipped_end, &restore, &finish, out);
        self.start_block(&restore, out);
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {}, ptr align 16 {scratch}, i64 {bytes}, i1 false)",
            cfg.base
        );
        self.emit_br(&finish, out);
        self.start_block(&finish, out);
        if !use_region {
            self.used_free = true;
            let _ = writeln!(out, "  call void @free(ptr {scratch})");
        }
    }

    /// Insertion-sorts runs of `RUN_LEN` records in place inside `buf`.
    fn emit_run_sort(&mut self, cfg: &SortCfg, buf: &str, out: &mut String) {
        let run_slot = self.next_slot("sort.ins.run");
        let _ = writeln!(self.allocas, "  {run_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 0, ptr {run_slot}, align 8");
        let outer = self.fresh_label("sort.ins.outer");
        let outer_body = self.fresh_label("sort.ins.outer.body");
        let outer_done = self.fresh_label("sort.ins.outer.done");
        self.emit_br(&outer, out);
        self.start_block(&outer, out);
        let run = self.next_tmp();
        let _ = writeln!(out, "  {run} = load i64, ptr {run_slot}, align 8");
        let more = self.next_tmp();
        let _ = writeln!(out, "  {more} = icmp slt i64 {run}, {}", cfg.len);
        self.emit_cond_br(&more, &outer_body, &outer_done, out);

        self.start_block(&outer_body, out);
        let end_raw = self.next_tmp();
        let _ = writeln!(out, "  {end_raw} = add nsw i64 {run}, {RUN_LEN}");
        let over = self.next_tmp();
        let _ = writeln!(out, "  {over} = icmp sgt i64 {end_raw}, {}", cfg.len);
        let run_end = self.next_tmp();
        let _ = writeln!(
            out,
            "  {run_end} = select i1 {over}, i64 {}, i64 {end_raw}",
            cfg.len
        );

        let i_slot = self.next_slot("sort.ins.i");
        let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
        let start1 = self.next_tmp();
        let _ = writeln!(out, "  {start1} = add nsw i64 {run}, 1");
        let _ = writeln!(out, "  store i64 {start1}, ptr {i_slot}, align 8");
        let icond = self.fresh_label("sort.ins.cond");
        let ibody = self.fresh_label("sort.ins.body");
        let inext = self.fresh_label("sort.ins.next");
        self.emit_br(&icond, out);
        self.start_block(&icond, out);
        let cur = self.next_tmp();
        let _ = writeln!(out, "  {cur} = load i64, ptr {i_slot}, align 8");
        let inside = self.next_tmp();
        let _ = writeln!(out, "  {inside} = icmp slt i64 {cur}, {run_end}");
        self.emit_cond_br(&inside, &ibody, &inext, out);

        self.start_block(&ibody, out);
        // One 16-byte stack scratch holds the record being inserted: shifting *roots* by
        // `memcpy` on overlapping ranges would clobber data, so every shift moves the stack
        // copy instead and writes the copy out once when the slot is found.
        let hold_slot = self.scratch_16();
        let curptr = self.record_ptr(cfg, buf, &cur, out);
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {hold_slot}, ptr align 8 {curptr}, i64 {}, i1 false)",
            cfg.stride
        );
        let j_slot = self.next_slot("sort.ins.j");
        let _ = writeln!(self.allocas, "  {j_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 {cur}, ptr {j_slot}, align 8");
        let down = self.fresh_label("sort.ins.down");
        let check = self.fresh_label("sort.ins.check");
        let shift = self.fresh_label("sort.ins.shift");
        let place = self.fresh_label("sort.ins.place");
        let tail = self.fresh_label("sort.ins.tail");
        self.emit_br(&down, out);

        self.start_block(&down, out);
        let j = self.next_tmp();
        let _ = writeln!(out, "  {j} = load i64, ptr {j_slot}, align 8");
        // `j - 1` is only a valid element once `j > run`, so the scan-end test must short-circuit
        // *before* the record is addressed: an `inbounds` gep past the start of the run is poison
        // even when its result is never loaded, and LLVM is free to (and does) exploit that.
        let at_start = self.next_tmp();
        let _ = writeln!(out, "  {at_start} = icmp sle i64 {j}, {run}");
        self.emit_cond_br(&at_start, &place, &check, out);

        self.start_block(&check, out);
        let jm1 = self.next_tmp();
        let _ = writeln!(out, "  {jm1} = sub nsw i64 {j}, 1");
        let prev_ptr = self.record_ptr(cfg, buf, &jm1, out);
        let hold_key = self.load_key_field(cfg, &hold_slot, cfg.key_off, out);
        let prev_key = self.load_key_field(cfg, &prev_ptr, cfg.key_off, out);
        // Does the held record belong before `prev`?
        let before = self.key_before(cfg, &hold_key, &hold_slot, &prev_key, &prev_ptr, out);
        let inv = self.next_tmp();
        let _ = writeln!(out, "  {inv} = xor i1 {before}, true");
        self.emit_cond_br(&inv, &place, &shift, out);

        self.start_block(&shift, out);
        let dst_ptr = self.record_ptr(cfg, buf, &j, out);
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {dst_ptr}, ptr align 8 {prev_ptr}, i64 {}, i1 false)",
            cfg.stride
        );
        let _ = writeln!(out, "  store i64 {jm1}, ptr {j_slot}, align 8");
        self.emit_br(&down, out);

        self.start_block(&place, out);
        let jf = self.next_tmp();
        let _ = writeln!(out, "  {jf} = load i64, ptr {j_slot}, align 8");
        let wptr = self.record_ptr(cfg, buf, &jf, out);
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {wptr}, ptr align 8 {hold_slot}, i64 {}, i1 false)",
            cfg.stride
        );
        self.emit_br(&tail, out);

        self.start_block(&tail, out);
        // Advance to the next element of this run (`i` was clobbered by the inner scan).
        let cur_after = self.next_tmp();
        let _ = writeln!(out, "  {cur_after} = load i64, ptr {i_slot}, align 8");
        let next_i = self.next_tmp();
        let _ = writeln!(out, "  {next_i} = add nsw i64 {cur_after}, 1");
        let _ = writeln!(out, "  store i64 {next_i}, ptr {i_slot}, align 8");
        self.emit_br(&icond, out);

        self.start_block(&inext, out);
        let _ = writeln!(out, "  store i64 {run_end}, ptr {run_slot}, align 8");
        self.emit_br(&outer, out);
        self.start_block(&outer_done, out);
    }

    /// Merges `src[lo..mid)` and `src[mid..hi)` into `dst[lo..hi)`.
    #[allow(clippy::too_many_arguments)]
    fn emit_merge_into(
        &mut self,
        cfg: &SortCfg,
        src: &str,
        dst: &str,
        lo: &str,
        mid: &str,
        hi: &str,
        out: &mut String,
    ) {
        let i_slot = self.next_slot("sort.m.i");
        let j_slot = self.next_slot("sort.m.j");
        let k_slot = self.next_slot("sort.m.k");
        let _ = writeln!(self.allocas, "  {i_slot} = alloca i64, align 8");
        let _ = writeln!(self.allocas, "  {j_slot} = alloca i64, align 8");
        let _ = writeln!(self.allocas, "  {k_slot} = alloca i64, align 8");
        let _ = writeln!(out, "  store i64 {lo}, ptr {i_slot}, align 8");
        let _ = writeln!(out, "  store i64 {mid}, ptr {j_slot}, align 8");
        let _ = writeln!(out, "  store i64 {lo}, ptr {k_slot}, align 8");

        let head = self.fresh_label("sort.m.head");
        let cmp_lbl = self.fresh_label("sort.m.cmp");
        let take_r = self.fresh_label("sort.m.r");
        let take_l = self.fresh_label("sort.m.l");
        let store = self.fresh_label("sort.m.store");
        let drain = self.fresh_label("sort.m.drain");
        let take_r2 = self.fresh_label("sort.m.r2");
        let take_l2 = self.fresh_label("sort.m.l2");
        let end = self.fresh_label("sort.m.end");
        self.emit_br(&head, out);

        self.start_block(&head, out);
        let i = self.next_tmp();
        let _ = writeln!(out, "  {i} = load i64, ptr {i_slot}, align 8");
        let j = self.next_tmp();
        let _ = writeln!(out, "  {j} = load i64, ptr {j_slot}, align 8");
        let k = self.next_tmp();
        let _ = writeln!(out, "  {k} = load i64, ptr {k_slot}, align 8");
        let k_done = self.next_tmp();
        let _ = writeln!(out, "  {k_done} = icmp sge i64 {k}, {hi}");
        let l_done = self.next_tmp();
        let _ = writeln!(out, "  {l_done} = icmp sge i64 {i}, {mid}");
        let r_done = self.next_tmp();
        let _ = writeln!(out, "  {r_done} = icmp sge i64 {j}, {hi}");
        let stop1 = self.next_tmp();
        let _ = writeln!(out, "  {stop1} = or i1 {k_done}, {l_done}");
        let stop = self.next_tmp();
        let _ = writeln!(out, "  {stop} = or i1 {stop1}, {r_done}");
        self.emit_cond_br(&stop, &drain, &cmp_lbl, out);

        self.start_block(&cmp_lbl, out);
        let lp = self.record_ptr(cfg, src, &i, out);
        let lkey = self.load_key_field(cfg, &lp, cfg.key_off, out);
        let rp = self.record_ptr(cfg, src, &j, out);
        let rkey = self.load_key_field(cfg, &rp, cfg.key_off, out);
        // Stable merge: take the right side only when it is strictly *before* the left.
        let right_first = self.key_before(cfg, &rkey, &rp, &lkey, &lp, out);
        self.emit_cond_br(&right_first, &take_r, &take_l, out);

        self.start_block(&take_l, out);
        let lp2 = self.record_ptr(cfg, src, &i, out);
        let dp = self.record_ptr(cfg, dst, &k, out);
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {dp}, ptr align 8 {lp2}, i64 {}, i1 false)",
            cfg.stride
        );
        let ni = self.next_tmp();
        let _ = writeln!(out, "  {ni} = add nsw i64 {i}, 1");
        let _ = writeln!(out, "  store i64 {ni}, ptr {i_slot}, align 8");
        self.emit_br(&store, out);

        self.start_block(&take_r, out);
        let rp2 = self.record_ptr(cfg, src, &j, out);
        let dp2 = self.record_ptr(cfg, dst, &k, out);
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {dp2}, ptr align 8 {rp2}, i64 {}, i1 false)",
            cfg.stride
        );
        let nj = self.next_tmp();
        let _ = writeln!(out, "  {nj} = add nsw i64 {j}, 1");
        let _ = writeln!(out, "  store i64 {nj}, ptr {j_slot}, align 8");
        self.emit_br(&store, out);

        // Drain whichever side still has records left.
        self.start_block(&drain, out);
        let left_left = self.next_tmp();
        let _ = writeln!(out, "  {left_left} = xor i1 {l_done}, true");
        let right_left = self.next_tmp();
        let _ = writeln!(out, "  {right_left} = xor i1 {r_done}, true");
        let both = self.next_tmp();
        let _ = writeln!(out, "  {both} = and i1 {left_left}, {right_left}");
        let cmp2 = self.fresh_label("sort.m.cmp2");
        let end2 = self.fresh_label("sort.m.end2");
        self.emit_cond_br(&both, &cmp2, &end2, out);

        self.start_block(&cmp2, out);
        let i2 = self.next_tmp();
        let _ = writeln!(out, "  {i2} = load i64, ptr {i_slot}, align 8");
        let j2 = self.next_tmp();
        let _ = writeln!(out, "  {j2} = load i64, ptr {j_slot}, align 8");
        let lp3 = self.record_ptr(cfg, src, &i2, out);
        let lkey2 = self.load_key_field(cfg, &lp3, cfg.key_off, out);
        let rp3 = self.record_ptr(cfg, src, &j2, out);
        let rkey2 = self.load_key_field(cfg, &rp3, cfg.key_off, out);
        let rf = self.key_before(cfg, &rkey2, &rp3, &lkey2, &lp3, out);
        self.emit_cond_br(&rf, &take_r2, &take_l2, out);

        self.start_block(&take_l2, out);
        let dp3 = self.record_ptr(cfg, dst, &k, out);
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {dp3}, ptr align 8 {lp3}, i64 {}, i1 false)",
            cfg.stride
        );
        let ni2 = self.next_tmp();
        let _ = writeln!(out, "  {ni2} = add nsw i64 {i2}, 1");
        let _ = writeln!(out, "  store i64 {ni2}, ptr {i_slot}, align 8");
        self.emit_br(&store, out);

        self.start_block(&take_r2, out);
        let dp4 = self.record_ptr(cfg, dst, &k, out);
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {dp4}, ptr align 8 {rp3}, i64 {}, i1 false)",
            cfg.stride
        );
        let nj2 = self.next_tmp();
        let _ = writeln!(out, "  {nj2} = add nsw i64 {j2}, 1");
        let _ = writeln!(out, "  store i64 {nj2}, ptr {j_slot}, align 8");
        self.emit_br(&store, out);

        self.start_block(&store, out);
        let nk = self.next_tmp();
        let _ = writeln!(out, "  {nk} = add nsw i64 {k}, 1");
        let _ = writeln!(out, "  store i64 {nk}, ptr {k_slot}, align 8");
        self.emit_br(&head, out);

        self.start_block(&end2, out);
        // Copy the remaining tail of the non-empty half in one memcpy.
        let tail_src_l = self.fresh_label("sort.m.tail.l");
        let tail_src_r = self.fresh_label("sort.m.tail.r");
        let tail_end = self.fresh_label("sort.m.tail.end");
        self.emit_cond_br(&left_left, &tail_src_l, &tail_src_r, out);
        self.start_block(&tail_src_l, out);
        let cnt_l = self.next_tmp();
        let _ = writeln!(out, "  {cnt_l} = sub nsw i64 {mid}, {i}");
        let sp = self.record_ptr(cfg, src, &i, out);
        let dpl = self.record_ptr(cfg, dst, &k, out);
        self.emit_memcpy_bytes(&dpl, &sp, &cnt_l, cfg.stride, out);
        self.emit_br(&tail_end, out);
        self.start_block(&tail_src_r, out);
        let cnt_r = self.next_tmp();
        let _ = writeln!(out, "  {cnt_r} = sub nsw i64 {hi}, {j}");
        let sp2 = self.record_ptr(cfg, src, &j, out);
        let dpr = self.record_ptr(cfg, dst, &k, out);
        self.emit_memcpy_bytes(&dpr, &sp2, &cnt_r, cfg.stride, out);
        self.emit_br(&tail_end, out);
        self.start_block(&tail_end, out);
        self.emit_br(&end, out);
        self.start_block(&end, out);
    }

    /// `memcpy(dst, src, count * stride)` guarded on `count > 0`.
    fn emit_memcpy_bytes(
        &mut self,
        dst: &str,
        src: &str,
        count: &str,
        stride: i64,
        out: &mut String,
    ) {
        let n = self.next_tmp();
        let _ = writeln!(out, "  {n} = mul nuw nsw i64 {count}, {stride}");
        let positive = self.next_tmp();
        let _ = writeln!(out, "  {positive} = icmp sgt i64 {n}, 0");
        let do_lbl = self.fresh_label("sort.cpy");
        let done_lbl = self.fresh_label("sort.cpy.done");
        self.emit_cond_br(&positive, &do_lbl, &done_lbl, out);
        self.start_block(&do_lbl, out);
        self.used_memcpy = true;
        let _ = writeln!(
            out,
            "  call void @llvm.memcpy.p0.p0.i64(ptr align 8 {dst}, ptr align 8 {src}, i64 {n}, i1 false)"
        );
        self.emit_br(&done_lbl, out);
        self.start_block(&done_lbl, out);
    }

    // ---------------- Record helpers ---------------------------------------

    /// Lazily allocates a single 16-byte stack scratch slot (`%ArchxStr`-sized and
    /// 8-byte aligned), reused by every record move in the function.
    fn scratch_16(&mut self) -> String {
        if let Some(s) = &self.sort_tmp_slot {
            return s.clone();
        }
        let slot = self.next_slot("sort.tmp");
        let _ = writeln!(self.allocas, "  {slot} = alloca [16 x i8], align 8");
        self.sort_tmp_slot = Some(slot.clone());
        slot
    }

    fn record_ptr(&mut self, cfg: &SortCfg, buf: &str, idx: &str, out: &mut String) -> String {
        let off = self.next_tmp();
        let _ = writeln!(out, "  {off} = mul nuw nsw i64 {idx}, {}", cfg.stride);
        let p = self.next_tmp();
        let _ = writeln!(out, "  {p} = getelementptr inbounds i8, ptr {buf}, i64 {off}");
        p
    }

    fn load_key_field(
        &mut self,
        cfg: &SortCfg,
        rec: &str,
        off: i64,
        out: &mut String,
    ) -> String {
        let p = self.next_tmp();
        let _ = writeln!(out, "  {p} = getelementptr inbounds i8, ptr {rec}, i64 {off}");
        let v = self.next_tmp();
        let _ = writeln!(out, "  {v} = load {}, ptr {p}, align 8", cfg.kind.ir());
        v
    }


    fn load_i64_field(&mut self, rec: &str, off: i64, out: &mut String) -> String {
        let p = self.next_tmp();
        let _ = writeln!(out, "  {p} = getelementptr inbounds i8, ptr {rec}, i64 {off}");
        let v = self.next_tmp();
        let _ = writeln!(out, "  {v} = load i64, ptr {p}, align 8");
        v
    }

    /// Branch-free "record `a` must be placed strictly before record `b`".
    ///
    /// Keyless sorts compare only the key. Keyed sorts add the `orig_idx` tie-break: on equal
    /// keys the lower source index wins, so the sort stays **stable** even with
    /// `reverse=True` (only the key ordering is inverted, never the source order).
    #[allow(clippy::too_many_arguments)]
    fn key_before(
        &mut self,
        cfg: &SortCfg,
        a_key: &str,
        a_rec: &str,
        b_key: &str,
        b_rec: &str,
        out: &mut String,
    ) -> String {
        let asc = !cfg.reverse;
        let strict = self.emit_less(cfg.kind, a_key, b_key, asc, out);
        let Some(idx_off) = cfg.idx_off else {
            return strict;
        };
        let eq = self.emit_eq(cfg.kind, a_key, b_key, out);
        let a_idx = self.load_i64_field(a_rec, idx_off, out);
        let b_idx = self.load_i64_field(b_rec, idx_off, out);
        let lower = self.next_tmp();
        let _ = writeln!(out, "  {lower} = icmp slt i64 {a_idx}, {b_idx}");
        let tie = self.next_tmp();
        let _ = writeln!(out, "  {tie} = and i1 {eq}, {lower}");
        let r = self.next_tmp();
        let _ = writeln!(out, "  {r} = or i1 {strict}, {tie}");
        r
    }

    fn emit_eq(&mut self, kind: KeyKind, a: &str, b: &str, out: &mut String) -> String {
        let r = self.next_tmp();
        match kind {
            KeyKind::Float => {
                let _ = writeln!(out, "  {r} = fcmp oeq double {a}, {b}");
            }
            KeyKind::Str => {
                self.used_str_eq = true;
                let _ = writeln!(
                    out,
                    "  {r} = call fastcc i1 @archx_str_eq(%ArchxStr {a}, %ArchxStr {b})"
                );
            }
            KeyKind::Int => {
                let _ = writeln!(out, "  {r} = icmp eq i64 {a}, {b}");
            }
            KeyKind::Bool => {
                let _ = writeln!(out, "  {r} = icmp eq i8 {a}, {b}");
            }
        }
        r
    }

    fn emit_less(&mut self, kind: KeyKind, a: &str, b: &str, asc: bool, out: &mut String) -> String {
        let r = self.next_tmp();
        match kind {
            KeyKind::Float => {
                let pred = if asc { "olt" } else { "ogt" };
                let _ = writeln!(out, "  {r} = fcmp {pred} double {a}, {b}");
            }
            KeyKind::Str => {
                self.used_str_cmp = true;
                let c = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {c} = call fastcc i32 @archx_str_cmp(%ArchxStr {a}, %ArchxStr {b})"
                );
                let pred = if asc { "slt" } else { "sgt" };
                let _ = writeln!(out, "  {r} = icmp {pred} i32 {c}, 0");
            }
            KeyKind::Int => {
                let pred = if asc { "slt" } else { "sgt" };
                let _ = writeln!(out, "  {r} = icmp {pred} i64 {a}, {b}");
            }
            KeyKind::Bool => {
                let au = self.next_tmp();
                let _ = writeln!(out, "  {au} = zext i8 {a} to i64");
                let bu = self.next_tmp();
                let _ = writeln!(out, "  {bu} = zext i8 {b} to i64");
                let pred = if asc { "slt" } else { "sgt" };
                let _ = writeln!(out, "  {r} = icmp {pred} i64 {au}, {bu}");
            }
        }
        r
    }
}

fn keyless_kind(elem_ty: &Type, span: Span) -> Result<KeyKind> {
    Ok(match elem_ty {
        Type::Int => KeyKind::Int,
        Type::Float => KeyKind::Float,
        Type::Bool => KeyKind::Bool,
        Type::Str => KeyKind::Str,
        other => {
            return Err(Diagnostic::new(
                format!(
                    "cannot sort `{}` elements without `key=`; pass `key=lambda ...`",
                    other.name()
                ),
                span,
            ))
        }
    })
}

pub(super) fn parse_sort_kwargs(
    kw_args: &[(String, Expr, Span)],
    who: &str,
) -> Result<(Option<LambdaSpec>, bool)> {
    let mut key: Option<LambdaSpec> = None;
    let mut reverse = false;
    for (name, val, kw_span) in kw_args {
        match name.as_str() {
            "key" => {
                if key.is_some() {
                    return Err(Diagnostic::new(
                        format!("duplicate keyword argument `key` in `{who}()`"),
                        *kw_span,
                    ));
                }
                if matches!(val.kind, ExprKind::NoneLit) {
                    continue;
                }
                key = Some(LambdaSpec::from_expr(val)?);
            }
            "reverse" => match &val.kind {
                ExprKind::Bool(b) => reverse = *b,
                _ => {
                    return Err(Diagnostic::new(
                        format!("`reverse=` in `{who}()` must be a literal `True` or `False`"),
                        *kw_span,
                    ))
                }
            },
            other => {
                return Err(Diagnostic::new(
                    format!("`{who}()` got an unexpected keyword argument `{other}`"),
                    *kw_span,
                ))
            }
        }
    }
    Ok((key, reverse))
}
