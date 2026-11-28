//! Hybrid deterministic RAII ownership: statement temporary tracking, recursive drops,
//! deep value cloning, and `region:` return heap promotion.

use std::fmt::Write as _;

use crate::ast::*;

use super::*;

impl Codegen {
    // ---------------- Ownership, Drop, Clone & Heap Promotion ----------------

    pub(super) fn type_needs_drop(&self, ty: &Type) -> bool {
        match ty {
            Type::Int | Type::Float | Type::Bool | Type::Void => false,
            Type::Str | Type::Any | Type::Array(_) | Type::Dict(_, _) | Type::Set(_) => true,
            Type::Optional(inner) => self.type_needs_drop(inner),
            Type::Tuple(items) => items.iter().any(|t| self.type_needs_drop(t)),
            Type::Struct(name) => self
                .structs
                .get(name)
                .map_or(false, |fs| fs.iter().any(|f| self.type_needs_drop(&f.ty))),
            Type::Enum(name) => self.enums.get(name).map_or(false, |info| {
                info.variants
                    .iter()
                    .any(|(_, fs, _)| fs.iter().any(|t| self.type_needs_drop(t)))
            }),
            // Monomorphized before codegen; a surviving instantiation is treated as owning.
            Type::GenericInst { .. } => true,
        }
    }

    pub(super) fn claim_stmt_temp(&mut self, val: &str) -> bool {

        if let Some(pos) = self.stmt_temps.iter().rposition(|t| t.val == val) {
            self.stmt_temps.remove(pos);
            true
        } else {
            false
        }
    }

    pub(super) fn flush_stmt_temps(&mut self, out: &mut String) {
        self.flush_stmt_temps_from(0, out);
    }

    pub(super) fn flush_stmt_temps_from(&mut self, mark: usize, out: &mut String) {
        if self.terminated || self.stmt_temps.len() <= mark {
            self.stmt_temps.truncate(mark);
            return;
        }
        let drained: Vec<TempDrop> = self.stmt_temps.drain(mark..).collect();
        for td in drained.into_iter().rev() {
            self.emit_drop_value(&td.ty, &td.val, out);
        }
    }

    pub(super) fn emit_drop_value(&mut self, ty: &Type, val: &str, out: &mut String) {
        if !self.type_needs_drop(ty) {
            return;
        }
        match ty {
            Type::Str => {
                if val.starts_with("{ i64 ") {
                    return;
                }
                self.used_str_drop = true;
                let _ = writeln!(out, "  call fastcc void @archx_str_drop(%ArchxStr {val})");
            }
            Type::Any => {
                if val == "zeroinitializer" {
                    return;
                }
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let _ = writeln!(out, "  call fastcc void @archx_any_drop(%ArchxAny {val})");
            }
            Type::Dict(k, v) => {
                let fn_sym = self.ensure_dict_drop_helper(k, Some(v));
                let _ = writeln!(out, "  call fastcc void {fn_sym}(i64 {val})");
            }
            Type::Set(inner) => {
                let fn_sym = self.ensure_dict_drop_helper(inner, None);
                let _ = writeln!(out, "  call fastcc void {fn_sym}(i64 {val})");
            }
            Type::Array(elem_ty) => {
                if !self.type_needs_drop(elem_ty) {
                    self.used_free = true;
                    let cap = self.next_tmp();
                    let _ = writeln!(out, "  {cap} = extractvalue %ArchxVec {val}, 1");
                    let heap = self.next_tmp();
                    let _ = writeln!(out, "  {heap} = icmp sgt i64 {cap}, 0");
                    let do_lbl = self.fresh_label("drop.vec.free");
                    let done_lbl = self.fresh_label("drop.vec.done");
                    self.emit_cond_br(&heap, &do_lbl, &done_lbl, out);
                    self.start_block(&do_lbl, out);
                    let dp = self.next_tmp();
                    let _ = writeln!(out, "  {dp} = extractvalue %ArchxVec {val}, 2");
                    let _ = writeln!(out, "  call void @free(ptr {dp})");
                    self.emit_br(&done_lbl, out);
                    self.start_block(&done_lbl, out);
                } else {
                    let fn_sym = self.ensure_vec_drop_helper(elem_ty);
                    let _ = writeln!(out, "  call fastcc void {fn_sym}(%ArchxVec {val})");
                }
            }
            Type::Struct(sname) => {
                let fields = self.structs[sname].clone();
                for (i, f) in fields.iter().enumerate() {
                    if self.type_needs_drop(&f.ty) {
                        let fv = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {fv} = extractvalue %ArchxStruct_{sname} {val}, {i}"
                        );
                        self.emit_drop_value(&f.ty, &fv, out);
                    }
                }
            }
            Type::Tuple(items) => {
                let tup_ir = ir_type(ty);
                for (i, t) in items.iter().enumerate() {
                    if self.type_needs_drop(t) {
                        let fv = self.next_tmp();
                        let _ = writeln!(out, "  {fv} = extractvalue {tup_ir} {val}, {i}");
                        self.emit_drop_value(t, &fv, out);
                    }
                }
            }
            Type::Optional(inner) => {
                if val == "zeroinitializer" {
                    return;
                }
                let opt_ir = ir_type(ty);
                let has = self.next_tmp();
                let _ = writeln!(out, "  {has} = extractvalue {opt_ir} {val}, 0");
                let some_lbl = self.fresh_label("drop.opt.some");
                let done_lbl = self.fresh_label("drop.opt.done");
                self.emit_cond_br(&has, &some_lbl, &done_lbl, out);
                self.start_block(&some_lbl, out);
                let iv = self.next_tmp();
                let _ = writeln!(out, "  {iv} = extractvalue {opt_ir} {val}, 1");
                self.emit_drop_value(inner, &iv, out);
                self.emit_br(&done_lbl, out);
                self.start_block(&done_lbl, out);
            }
            Type::Enum(ename) => {
                let fn_sym = self.ensure_enum_drop_helper(ename);
                let _ = writeln!(out, "  call fastcc void {fn_sym}(%ArchxEnum_{ename} {val})");
            }
            _ => {}
        }
    }

    pub(super) fn emit_clone_value(&mut self, ty: &Type, val: &str, out: &mut String) -> String {
        if !self.type_needs_drop(ty) {
            return val.to_string();
        }
        match ty {
            Type::Str => {
                if val.starts_with("{ i64 ") {
                    return val.to_string();
                }
                self.used_str_clone = true;
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxStr @archx_str_clone(%ArchxStr {val})"
                );
                res
            }
            Type::Any => {
                if val == "zeroinitializer" {
                    return val.to_string();
                }
                self.mark_runtime_type(&Type::Any);
                self.used_any_rt = true;
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxAny @archx_any_clone(%ArchxAny {val})"
                );
                res
            }
            Type::Dict(k, v) => {
                let fn_sym = self.ensure_dict_clone_helper(k, Some(v));
                let res = self.next_tmp();
                let _ = writeln!(out, "  {res} = call fastcc i64 {fn_sym}(i64 {val})");
                res
            }
            Type::Set(inner) => {
                let fn_sym = self.ensure_dict_clone_helper(inner, None);
                let res = self.next_tmp();
                let _ = writeln!(out, "  {res} = call fastcc i64 {fn_sym}(i64 {val})");
                res
            }
            Type::Array(elem_ty) => {
                let fn_sym = self.ensure_vec_clone_helper(elem_ty);
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxVec {fn_sym}(%ArchxVec {val})"
                );
                res
            }
            Type::Struct(sname) => {
                let fields = self.structs[sname].clone();
                let mut agg = val.to_string();
                for (i, f) in fields.iter().enumerate() {
                    if self.type_needs_drop(&f.ty) {
                        let fv = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {fv} = extractvalue %ArchxStruct_{sname} {val}, {i}"
                        );
                        let cv = self.emit_clone_value(&f.ty, &fv, out);
                        let next_agg = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {next_agg} = insertvalue %ArchxStruct_{sname} {agg}, {} {cv}, {i}",
                            ir_type(&f.ty)
                        );
                        agg = next_agg;
                    }
                }
                agg
            }
            Type::Tuple(items) => {
                let tup_ir = ir_type(ty);
                let mut agg = val.to_string();
                for (i, t) in items.iter().enumerate() {
                    if self.type_needs_drop(t) {
                        let fv = self.next_tmp();
                        let _ = writeln!(out, "  {fv} = extractvalue {tup_ir} {val}, {i}");
                        let cv = self.emit_clone_value(t, &fv, out);
                        let next_agg = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {next_agg} = insertvalue {tup_ir} {agg}, {} {cv}, {i}",
                            ir_type(t)
                        );
                        agg = next_agg;
                    }
                }
                agg
            }
            Type::Optional(inner) => {
                if val == "zeroinitializer" {
                    return val.to_string();
                }
                let opt_ir = ir_type(ty);
                let inner_ir = ir_type(inner);
                let has = self.next_tmp();
                let _ = writeln!(out, "  {has} = extractvalue {opt_ir} {val}, 0");
                let some_lbl = self.fresh_label("clone.opt.some");
                let some_end_lbl = self.fresh_label("clone.opt.some.end");
                let none_lbl = self.fresh_label("clone.opt.none");
                let done_lbl = self.fresh_label("clone.opt.done");
                self.emit_cond_br(&has, &some_lbl, &none_lbl, out);

                self.start_block(&none_lbl, out);
                self.emit_br(&done_lbl, out);

                self.start_block(&some_lbl, out);
                let iv = self.next_tmp();
                let _ = writeln!(out, "  {iv} = extractvalue {opt_ir} {val}, 1");
                let cv = self.emit_clone_value(inner, &iv, out);
                let s0 = self.next_tmp();
                let _ = writeln!(out, "  {s0} = insertvalue {opt_ir} undef, i1 1, 0");
                let s1 = self.next_tmp();
                let _ = writeln!(out, "  {s1} = insertvalue {opt_ir} {s0}, {inner_ir} {cv}, 1");
                self.emit_br(&some_end_lbl, out);

                self.start_block(&some_end_lbl, out);
                self.emit_br(&done_lbl, out);

                self.start_block(&done_lbl, out);
                let phi = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {phi} = phi {opt_ir} [ zeroinitializer, %{none_lbl} ], [ {s1}, %{some_end_lbl} ]"
                );
                phi
            }
            Type::Enum(ename) => {
                let fn_sym = self.ensure_enum_clone_helper(ename);
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxEnum_{ename} {fn_sym}(%ArchxEnum_{ename} {val})"
                );
                res
            }
            _ => val.to_string(),
        }
    }

    pub(super) fn emit_promote_to_heap(&mut self, ty: &Type, val: &str, out: &mut String) -> String {
        if !self.type_needs_drop(ty) {
            return val.to_string();
        }
        match ty {
            Type::Str => {
                if val.starts_with("{ i64 ") {
                    return val.to_string();
                }
                self.used_str_promote = true;
                let res = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {res} = call fastcc %ArchxStr @archx_str_promote(%ArchxStr {val})"
                );
                res
            }
            Type::Any | Type::Dict(_, _) | Type::Set(_) | Type::Optional(_) | Type::Enum(_) => {
                let cloned = self.emit_clone_value(ty, val, out);
                self.emit_drop_value(ty, val, out);
                cloned
            }
            Type::Array(elem_ty) => {
                if !self.type_needs_drop(elem_ty) {
                    let cap = self.next_tmp();
                    let _ = writeln!(out, "  {cap} = extractvalue %ArchxVec {val}, 1");
                    let is_reg = self.next_tmp();
                    let _ = writeln!(out, "  {is_reg} = icmp slt i64 {cap}, 0");
                    let clone_lbl = self.fresh_label("prom.vec.clone");
                    let done_lbl = self.fresh_label("prom.vec.done");
                    let orig_lbl = self.fresh_label("prom.vec.orig");
                    self.emit_cond_br(&is_reg, &clone_lbl, &orig_lbl, out);

                    self.start_block(&orig_lbl, out);
                    self.emit_br(&done_lbl, out);

                    self.start_block(&clone_lbl, out);
                    let cloned = self.emit_clone_value(ty, val, out);
                    self.emit_br(&done_lbl, out);

                    self.start_block(&done_lbl, out);
                    let phi = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {phi} = phi %ArchxVec [ {val}, %{orig_lbl} ], [ {cloned}, %{clone_lbl} ]"
                    );
                    phi
                } else {
                    let cloned = self.emit_clone_value(ty, val, out);
                    self.emit_drop_value(ty, val, out);
                    cloned
                }
            }
            Type::Struct(sname) => {
                let fields = self.structs[sname].clone();
                let mut agg = val.to_string();
                for (i, f) in fields.iter().enumerate() {
                    if self.type_needs_drop(&f.ty) {
                        let fv = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {fv} = extractvalue %ArchxStruct_{sname} {val}, {i}"
                        );
                        let pv = self.emit_promote_to_heap(&f.ty, &fv, out);
                        let next_agg = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {next_agg} = insertvalue %ArchxStruct_{sname} {agg}, {} {pv}, {i}",
                            ir_type(&f.ty)
                        );
                        agg = next_agg;
                    }
                }
                agg
            }
            Type::Tuple(items) => {
                let tup_ir = ir_type(ty);
                let mut agg = val.to_string();
                for (i, t) in items.iter().enumerate() {
                    if self.type_needs_drop(t) {
                        let fv = self.next_tmp();
                        let _ = writeln!(out, "  {fv} = extractvalue {tup_ir} {val}, {i}");
                        let pv = self.emit_promote_to_heap(t, &fv, out);
                        let next_agg = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {next_agg} = insertvalue {tup_ir} {agg}, {} {pv}, {i}",
                            ir_type(t)
                        );
                        agg = next_agg;
                    }
                }
                agg
            }
            _ => val.to_string(),
        }
    }

    pub(super) fn ensure_vec_drop_helper(&mut self, elem_ty: &Type) -> String {
        let key = type_mangle_key(elem_ty);
        let sym = format!("@archx_vec_drop_{key}");
        if self.emitted_vec_drops.contains(&key) {
            return sym;
        }
        self.emitted_vec_drops.insert(key);
        self.used_vec_type = true;
        self.used_free = true;

        let saved_tmp = self.next_tmp;
        let saved_lbl = self.next_label;
        let saved_term = self.terminated;
        self.next_tmp = 0;
        self.next_label = 0;
        self.terminated = false;

        let mut h = String::new();
        let _ = writeln!(h, "define private fastcc void {sym}(%ArchxVec %v) nounwind {{");
        let _ = writeln!(h, "entry:");
        let _ = writeln!(h, "  %len = extractvalue %ArchxVec %v, 0");
        let _ = writeln!(h, "  %cap = extractvalue %ArchxVec %v, 1");
        let _ = writeln!(h, "  %data = extractvalue %ArchxVec %v, 2");
        let _ = writeln!(h, "  %has_elems = icmp sgt i64 %len, 0");
        let _ = writeln!(h, "  br i1 %has_elems, label %loop.pre, label %check.free");
        let _ = writeln!(h, "loop.pre:");
        let _ = writeln!(h, "  br label %loop");
        let _ = writeln!(h, "loop:");
        let _ = writeln!(h, "  %i = phi i64 [ 0, %loop.pre ], [ %inext, %loop.latch ]");
        let mem_ty = elem_mem_ir_type(elem_ty);
        let _ = writeln!(h, "  %ep = getelementptr inbounds {mem_ty}, ptr %data, i64 %i");
        let ev = self.emit_elem_load(elem_ty, "%ep", &mut h);
        self.emit_drop_value(elem_ty, &ev, &mut h);
        let _ = writeln!(h, "  br label %loop.latch");
        let _ = writeln!(h, "loop.latch:");
        let _ = writeln!(h, "  %inext = add nuw nsw i64 %i, 1");
        let _ = writeln!(h, "  %more = icmp slt i64 %inext, %len");
        let _ = writeln!(h, "  br i1 %more, label %loop, label %check.free");
        let _ = writeln!(h, "check.free:");
        let _ = writeln!(h, "  %is_heap = icmp sgt i64 %cap, 0");
        let _ = writeln!(h, "  br i1 %is_heap, label %do.free, label %done");
        let _ = writeln!(h, "do.free:");
        let _ = writeln!(h, "  call void @free(ptr %data)");
        let _ = writeln!(h, "  br label %done");
        let _ = writeln!(h, "done:");
        let _ = writeln!(h, "  ret void");
        let _ = writeln!(h, "}}\n");

        self.extra_helpers.push_str(&h);
        self.next_tmp = saved_tmp;
        self.next_label = saved_lbl;
        self.terminated = saved_term;
        sym
    }

    pub(super) fn ensure_vec_clone_helper(&mut self, elem_ty: &Type) -> String {
        let key = type_mangle_key(elem_ty);
        let sym = format!("@archx_vec_clone_{key}");
        if self.emitted_vec_clones.contains(&key) {
            return sym;
        }
        self.emitted_vec_clones.insert(key);
        self.used_vec_type = true;
        self.used_malloc = true;
        self.used_oom_fail = true;

        let saved_tmp = self.next_tmp;
        let saved_lbl = self.next_label;
        let saved_term = self.terminated;
        self.next_tmp = 0;
        self.next_label = 0;
        self.terminated = false;

        let mut h = String::new();
        let _ = writeln!(h, "define private fastcc %ArchxVec {sym}(%ArchxVec %v) {{");
        let _ = writeln!(h, "entry:");
        let _ = writeln!(h, "  %len = extractvalue %ArchxVec %v, 0");
        let _ = writeln!(h, "  %src = extractvalue %ArchxVec %v, 2");
        let _ = writeln!(h, "  %empty = icmp sle i64 %len, 0");
        let _ = writeln!(h, "  br i1 %empty, label %ret.empty, label %alloc");
        let _ = writeln!(h, "ret.empty:");
        let _ = writeln!(h, "  ret %ArchxVec zeroinitializer");
        let _ = writeln!(h, "alloc:");
        let esz = self.emit_elem_sizeof(elem_ty, &mut h);
        let bytes = self.emit_elem_bytes_val_mul("%len", &esz, &mut h);
        let dst = self.emit_checked_malloc(&bytes, &mut h);
        if !self.type_needs_drop(elem_ty) {
            self.used_memcpy = true;
            let _ = writeln!(
                h,
                "  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 {dst}, ptr nonnull align 1 %src, i64 {bytes}, i1 false)"
            );
            let _ = writeln!(h, "  br label %finish");
        } else {
            let mem_ty = elem_mem_ir_type(elem_ty);
            let _ = writeln!(h, "  br label %loop.pre");
            let _ = writeln!(h, "loop.pre:");
            let _ = writeln!(h, "  br label %loop");
            let _ = writeln!(h, "loop:");
            let _ = writeln!(h, "  %i = phi i64 [ 0, %loop.pre ], [ %inext, %loop.latch ]");
            let _ = writeln!(h, "  %sp = getelementptr inbounds {mem_ty}, ptr %src, i64 %i");
            let _ = writeln!(h, "  %dp = getelementptr inbounds {mem_ty}, ptr {dst}, i64 %i");
            let sv = self.emit_elem_load(elem_ty, "%sp", &mut h);
            let cv = self.emit_clone_value(elem_ty, &sv, &mut h);
            self.emit_elem_store(elem_ty, &cv, "%dp", &mut h);
            let _ = writeln!(h, "  br label %loop.latch");
            let _ = writeln!(h, "loop.latch:");
            let _ = writeln!(h, "  %inext = add nuw nsw i64 %i, 1");
            let _ = writeln!(h, "  %more = icmp slt i64 %inext, %len");
            let _ = writeln!(h, "  br i1 %more, label %loop, label %finish");
        }
        let _ = writeln!(h, "finish:");
        let out_vec = self.build_vec_val("%len", "%len", &dst, &mut h);
        let _ = writeln!(h, "  ret %ArchxVec {out_vec}");
        let _ = writeln!(h, "}}\n");

        self.extra_helpers.push_str(&h);
        self.next_tmp = saved_tmp;
        self.next_label = saved_lbl;
        self.terminated = saved_term;
        sym
    }


    // ---------------- Scopes, RAII Drops & SSA Helpers -----------------------

    pub(super) fn push_scope(&mut self) {
        self.scopes.push(Scope::default());
    }

    pub(super) fn pop_scope_with_drops(&mut self, out: &mut String) {
        let scope = self.scopes.pop().expect("scope stack underflow");
        if !self.terminated {
            self.emit_drops_for_targets(&scope.owned_buffers, None, out);
        }
    }

    pub(super) fn emit_drops_down_to(&mut self, target_depth: usize, skip_slot: Option<&str>, out: &mut String) {
        let mut all_targets = Vec::new();
        for scope in self.scopes[target_depth..].iter().rev() {
            for t in scope.owned_buffers.iter().rev() {
                all_targets.push(t.clone());
            }
        }
        self.emit_drops_for_targets(&all_targets, skip_slot, out);
    }

    pub(super) fn emit_drops_for_targets(
        &mut self,
        targets: &[DropTarget],
        skip_slot: Option<&str>,
        out: &mut String,
    ) {
        for target in targets {
            match target {
                DropTarget::DataPtr(data_ptr) => {
                    self.used_free = true;
                    let _ = writeln!(out, "  call void @free(ptr {data_ptr})");
                }
                DropTarget::TypedSlot { ptr, ty } => {
                    if skip_slot == Some(ptr.as_str()) {
                        continue;
                    }
                    let val = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {val} = load {}, ptr {ptr}, align {}",
                        ir_type(ty),
                        ir_align(ty)
                    );
                    self.emit_drop_value(ty, &val, out);
                }
            }
        }
    }

}
