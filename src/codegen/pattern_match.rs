//! Milestone 8 (`v0.8.0`): Pythonic `match` / `case` structural pattern matching,
//! `|` OR-patterns, `if` guards, transparent `T | None` unwrapping, and compile-time
//! algebraic `enum` exhaustiveness verification.

use std::collections::HashSet;
use std::fmt::Write as _;

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};

use super::*;

impl Codegen {
    pub(super) fn gen_match(
        &mut self,
        subject: &Expr,
        cases: &[MatchCase],
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        let (subj_ty, raw_subj) = self.eval_expr(subject, out)?;
        if subj_ty == Type::Void {
            return Err(Diagnostic::new(
                "cannot `match` on a `void` expression",
                subject.span,
            ));
        }

        // Compile-time exhaustiveness check for algebraic `enum`s:
        self.check_enum_exhaustiveness(&subj_ty, cases, span)?;

        self.push_scope();
        let subj_ir = ir_type(&subj_ty);
        let subj_align = ir_align(&subj_ty);
        let subj_slot = self.next_slot("match.subj");
        let _ = writeln!(self.allocas, "  {subj_slot} = alloca {subj_ir}, align {subj_align}");
        let owned_subj = if self.type_needs_drop(&subj_ty) {
            let v = if self.claim_stmt_temp(&raw_subj) {
                raw_subj
            } else {
                self.emit_clone_value(&subj_ty, &raw_subj, out)
            };
            self.scopes
                .last_mut()
                .unwrap()
                .owned_buffers
                .push(DropTarget::TypedSlot {
                    ptr: subj_slot.clone(),
                    ty: subj_ty.clone(),
                });
            v
        } else {
            raw_subj
        };
        let _ = writeln!(
            out,
            "  store {subj_ir} {owned_subj}, ptr {subj_slot}, align {subj_align}"
        );
        self.flush_stmt_temps(out);

        let match_end_lbl = self.fresh_label("match.end");
        let mut any_reached_end = false;
        let mut none_matched_unguarded = false;

        for (ci, case) in cases.iter().enumerate() {
            let next_case_lbl = if ci + 1 < cases.len() {
                self.fresh_label("match.next")
            } else {
                match_end_lbl.clone()
            };

            let subj_val = self.next_tmp();
            let _ = writeln!(
                out,
                "  {subj_val} = load {subj_ir}, ptr {subj_slot}, align {subj_align}"
            );

            let mut pending_binds: Vec<(String, Type, String)> = Vec::new();
            self.emit_pattern_test(
                &case.pattern,
                &subj_ty,
                &subj_val,
                none_matched_unguarded,
                &next_case_lbl,
                &mut pending_binds,
                case.span,
                out,
            )?;

            if case.guard.is_none() && pattern_matches_none(&case.pattern) {
                none_matched_unguarded = true;
            }

            // Pattern succeeded! Push case scope and bind captured variables.
            self.push_scope();
            for (bname, bty, bslot) in pending_binds {
                let b_ir = ir_type(&bty);
                let b_align = ir_align(&bty);
                let loaded = self.next_tmp();
                let _ = writeln!(out, "  {loaded} = load {b_ir}, ptr {bslot}, align {b_align}");
                let is_mut = self.mutated_vars.contains(&bname);
                let needs_drop = self.type_needs_drop(&bty);
                let init_v = if needs_drop {
                    self.emit_clone_value(&bty, &loaded, out)
                } else {
                    loaded
                };
                let storage = if !is_mut && !needs_drop {
                    VarStorage::Imm(init_v)
                } else {
                    let vptr = self.next_slot(&format!("pat.{bname}"));
                    let _ = writeln!(self.allocas, "  {vptr} = alloca {b_ir}, align {b_align}");
                    let _ = writeln!(out, "  store {b_ir} {init_v}, ptr {vptr}, align {b_align}");
                    if needs_drop {
                        self.scopes
                            .last_mut()
                            .unwrap()
                            .owned_buffers
                            .push(DropTarget::TypedSlot {
                                ptr: vptr.clone(),
                                ty: bty.clone(),
                            });
                    }
                    VarStorage::Slot(vptr)
                };
                self.scopes.last_mut().unwrap().vars.insert(
                    bname,
                    VarEntry {
                        ty: bty,
                        storage,
                        is_param: false,
                        region_depth: self.region_stack.len(),
                    },
                );
            }

            if let Some(guard_expr) = &case.guard {
                let gcond = self.eval_cond_bool(guard_expr, "match guard", out)?;
                self.flush_stmt_temps(out);
                let body_lbl = self.fresh_label("match.body");
                let gfail_lbl = self.fresh_label("match.gfail");
                self.emit_cond_br(&gcond, &body_lbl, &gfail_lbl, out);

                self.start_block(&gfail_lbl, out);
                let guard_drops = self.scopes.last().unwrap().owned_buffers.clone();
                self.emit_drops_for_targets(&guard_drops, None, out);
                self.emit_br(&next_case_lbl, out);

                self.start_block(&body_lbl, out);
            }

            self.gen_block(&case.body, out)?;
            self.pop_scope_with_drops(out);
            if !self.terminated {
                any_reached_end = true;
                self.emit_br(&match_end_lbl, out);
            }

            if ci + 1 < cases.len() {
                self.start_block(&next_case_lbl, out);
            } else if !is_irrefutable_pattern(&case.pattern, &subj_ty) || case.guard.is_some() {
                any_reached_end = true;
            }
        }

        self.start_block(&match_end_lbl, out);
        if !any_reached_end {
            let _ = self.scopes.pop();
            let _ = writeln!(out, "  unreachable");
            self.terminated = true;
        } else {
            self.pop_scope_with_drops(out);
        }
        Ok(())
    }

    fn check_enum_exhaustiveness(
        &self,
        subj_ty: &Type,
        cases: &[MatchCase],
        span: Span,
    ) -> Result<()> {
        let Type::Enum(ename) = subj_ty else {
            return Ok(());
        };
        let info = &self.enums[ename];
        let mut covered: HashSet<String> = HashSet::new();
        for case in cases {
            if case.guard.is_some() {
                continue;
            }
            if mark_enum_coverage(&case.pattern, ename, &info.variants, &mut covered) {
                return Ok(());
            }
        }
        let missing: Vec<&str> = info
            .variants
            .iter()
            .filter(|(vn, _, _)| !covered.contains(vn))
            .map(|(vn, _, _)| vn.as_str())
            .collect();
        if !missing.is_empty() {
            return Err(Diagnostic::new(
                format!(
                    "non-exhaustive `match` on enum `{ename}`: missing variant(s) {}",
                    missing
                        .iter()
                        .map(|v| format!("`{ename}.{v}`"))
                        .collect::<Vec<_>>()
                        .join(", ")
                ),
                span,
            ));
        }
        Ok(())
    }

    #[allow(clippy::too_many_arguments)]
    fn emit_pattern_test(
        &mut self,
        pat: &Pattern,
        val_ty: &Type,
        val: &str,
        none_already_matched: bool,
        fail_lbl: &str,
        binds: &mut Vec<(String, Type, String)>,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        if let Type::Optional(inner) = val_ty {
            let should_unwrap = match pat {
                Pattern::Wildcard(_) | Pattern::NonePat(_) => false,
                Pattern::Bind(_, _) => none_already_matched,
                Pattern::Or(alts, _) => alts.iter().all(|a| !matches!(a, Pattern::NonePat(_))),
                _ => true,
            };
            if should_unwrap {
                let opt_ir = ir_type(val_ty);
                let has = self.next_tmp();
                let _ = writeln!(out, "  {has} = extractvalue {opt_ir} {val}, 0");
                let some_lbl = self.fresh_label("pat.opt.some");
                self.emit_cond_br(&has, &some_lbl, fail_lbl, out);
                self.start_block(&some_lbl, out);
                let iv = self.next_tmp();
                let _ = writeln!(out, "  {iv} = extractvalue {opt_ir} {val}, 1");
                return self.emit_pattern_test(pat, inner, &iv, false, fail_lbl, binds, span, out);
            }
        }

        match pat {
            Pattern::Wildcard(_) => Ok(()),

            Pattern::Bind(name, _) => {
                let b_ir = ir_type(val_ty);
                let b_align = ir_align(val_ty);
                let slot = self.find_or_create_bind_slot(name, val_ty, binds);
                let _ = writeln!(out, "  store {b_ir} {val}, ptr {slot}, align {b_align}");
                Ok(())
            }

            Pattern::NonePat(_) => match val_ty {
                Type::Optional(_) => {
                    let opt_ir = ir_type(val_ty);
                    let has = self.next_tmp();
                    let _ = writeln!(out, "  {has} = extractvalue {opt_ir} {val}, 0");
                    let ok_lbl = self.fresh_label("pat.none.ok");
                    self.emit_cond_br(&has, fail_lbl, &ok_lbl, out);
                    self.start_block(&ok_lbl, out);
                    Ok(())
                }
                Type::Any => {
                    let tag = self.next_tmp();
                    let _ = writeln!(out, "  {tag} = extractvalue %ArchxAny {val}, 0");
                    let eq = self.next_tmp();
                    let _ = writeln!(out, "  {eq} = icmp eq i64 {tag}, 0");
                    let ok_lbl = self.fresh_label("pat.anone.ok");
                    self.emit_cond_br(&eq, &ok_lbl, fail_lbl, out);
                    self.start_block(&ok_lbl, out);
                    Ok(())
                }
                _ => {
                    self.emit_br(fail_lbl, out);
                    let dead = self.fresh_label("pat.none.dead");
                    self.start_block(&dead, out);
                    Ok(())
                }
            },

            Pattern::Int(i, _) => {
                let cond = match val_ty {
                    Type::Int => {
                        let c = self.next_tmp();
                        let _ = writeln!(out, "  {c} = icmp eq i64 {val}, {i}");
                        c
                    }
                    Type::Float => {
                        let c = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {c} = fcmp oeq double {val}, {}",
                            format_llvm_double(*i as f64)
                        );
                        c
                    }
                    Type::Any => {
                        self.used_any_rt = true;
                        let lit = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {lit} = insertvalue %ArchxAny {{ i64 2, i64 0, i64 0 }}, i64 {i}, 1"
                        );
                        let c = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {c} = call fastcc i1 @archx_any_eq(%ArchxAny {val}, %ArchxAny {lit})"
                        );
                        c
                    }
                    _ => "false".to_string(),
                };
                let ok_lbl = self.fresh_label("pat.int.ok");
                self.emit_cond_br(&cond, &ok_lbl, fail_lbl, out);
                self.start_block(&ok_lbl, out);
                Ok(())
            }

            Pattern::Float(f, _) => {
                let fhex = format_llvm_double(*f);
                let cond = match val_ty {
                    Type::Float => {
                        let c = self.next_tmp();
                        let _ = writeln!(out, "  {c} = fcmp oeq double {val}, {fhex}");
                        c
                    }
                    Type::Any => {
                        self.used_any_rt = true;
                        let bits = (*f).to_bits() as i64;
                        let lit = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {lit} = insertvalue %ArchxAny {{ i64 3, i64 0, i64 0 }}, i64 {bits}, 1"
                        );
                        let c = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {c} = call fastcc i1 @archx_any_eq(%ArchxAny {val}, %ArchxAny {lit})"
                        );
                        c
                    }
                    _ => "false".to_string(),
                };
                let ok_lbl = self.fresh_label("pat.flt.ok");
                self.emit_cond_br(&cond, &ok_lbl, fail_lbl, out);
                self.start_block(&ok_lbl, out);
                Ok(())
            }

            Pattern::Bool(b, _) => {
                let cond = match val_ty {
                    Type::Bool => {
                        let c = self.next_tmp();
                        let _ = writeln!(out, "  {c} = icmp eq i1 {val}, {b}");
                        c
                    }
                    Type::Any => {
                        let tag = self.next_tmp();
                        let _ = writeln!(out, "  {tag} = extractvalue %ArchxAny {val}, 0");
                        let w1 = self.next_tmp();
                        let _ = writeln!(out, "  {w1} = extractvalue %ArchxAny {val}, 1");
                        let is_b = self.next_tmp();
                        let _ = writeln!(out, "  {is_b} = icmp eq i64 {tag}, 1");
                        let exp = if *b { 1 } else { 0 };
                        let eq_b = self.next_tmp();
                        let _ = writeln!(out, "  {eq_b} = icmp eq i64 {w1}, {exp}");
                        let c = self.next_tmp();
                        let _ = writeln!(out, "  {c} = and i1 {is_b}, {eq_b}");
                        c
                    }
                    _ => "false".to_string(),
                };
                let ok_lbl = self.fresh_label("pat.bool.ok");
                self.emit_cond_br(&cond, &ok_lbl, fail_lbl, out);
                self.start_block(&ok_lbl, out);
                Ok(())
            }

            Pattern::Str(s, pspan) => {
                let (_, slit) = self.eval_expr(
                    &Expr {
                        kind: ExprKind::Str(s.clone()),
                        span: *pspan,
                    },
                    out,
                )?;
                let cond = match val_ty {
                    Type::Str => {
                        self.used_str_eq = true;
                        let c = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {c} = call fastcc i1 @archx_str_eq(%ArchxStr {val}, %ArchxStr {slit})"
                        );
                        c
                    }
                    Type::Any => {
                        self.used_any_rt = true;
                        let boxed = self.emit_box_any_owned(&Type::Str, &slit, *pspan, out)?;
                        let c = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {c} = call fastcc i1 @archx_any_eq(%ArchxAny {val}, %ArchxAny {boxed})"
                        );
                        c
                    }
                    _ => "false".to_string(),
                };
                let ok_lbl = self.fresh_label("pat.str.ok");
                self.emit_cond_br(&cond, &ok_lbl, fail_lbl, out);
                self.start_block(&ok_lbl, out);
                Ok(())
            }

            Pattern::Tuple(subpats, pspan) => match val_ty {
                Type::Tuple(items) => {
                    if items.len() != subpats.len() {
                        self.emit_br(fail_lbl, out);
                        let dead = self.fresh_label("pat.tup.dead");
                        self.start_block(&dead, out);
                        return Ok(());
                    }
                    let tup_ir = ir_type(val_ty);
                    for (i, (sp, ity)) in subpats.iter().zip(items.iter()).enumerate() {
                        let fv = self.next_tmp();
                        let _ = writeln!(out, "  {fv} = extractvalue {tup_ir} {val}, {i}");
                        self.emit_pattern_test(sp, ity, &fv, false, fail_lbl, binds, *pspan, out)?;
                    }
                    Ok(())
                }
                Type::Array(elem_ty) => {
                    let len = self.next_tmp();
                    let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {val}, 0");
                    let ok = self.next_tmp();
                    let _ = writeln!(out, "  {ok} = icmp eq i64 {len}, {}", subpats.len());
                    let ok_lbl = self.fresh_label("pat.seq.ok");
                    self.emit_cond_br(&ok, &ok_lbl, fail_lbl, out);
                    self.start_block(&ok_lbl, out);
                    let data = self.next_tmp();
                    let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {val}, 2");
                    let mem_ty = elem_mem_ir_type(elem_ty);
                    for (i, sp) in subpats.iter().enumerate() {
                        let ep = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data}, i64 {i}"
                        );
                        let ev = self.emit_elem_load(elem_ty, &ep, out);
                        self.emit_pattern_test(sp, elem_ty, &ev, false, fail_lbl, binds, *pspan, out)?;
                    }
                    Ok(())
                }
                _ => Err(Diagnostic::new(
                    format!(
                        "cannot match tuple/sequence pattern against `{}`",
                        val_ty.name()
                    ),
                    *pspan,
                )),
            },

            Pattern::EnumVariant {
                enum_name,
                variant,
                args,
                span: pspan,
            } => {
                let Type::Enum(actual_ename) = val_ty else {
                    return Err(Diagnostic::new(
                        format!(
                            "cannot match enum pattern `{enum_name}.{variant}` against `{}`",
                            val_ty.name()
                        ),
                        *pspan,
                    ));
                };
                if actual_ename != enum_name {
                    return Err(Diagnostic::new(
                        format!(
                            "pattern `{enum_name}.{variant}` does not match enum `{actual_ename}`"
                        ),
                        *pspan,
                    ));
                }
                let info = self.enums[enum_name].clone();
                let (vidx, (_, fields, offsets)) = info
                    .variants
                    .iter()
                    .enumerate()
                    .find(|(_, (vn, _, _))| vn == variant)
                    .ok_or_else(|| {
                        Diagnostic::new(
                            format!("enum `{enum_name}` has no variant `{variant}`"),
                            *pspan,
                        )
                    })?;
                if args.len() != fields.len() {
                    return Err(Diagnostic::new(
                        format!(
                            "pattern `{enum_name}.{variant}` expects {} field(s), found {}",
                            fields.len(),
                            args.len()
                        ),
                        *pspan,
                    ));
                }
                let enum_ir = format!("%ArchxEnum_{enum_name}");
                let tag = self.next_tmp();
                let _ = writeln!(out, "  {tag} = extractvalue {enum_ir} {val}, 0");
                let ok = self.next_tmp();
                let _ = writeln!(out, "  {ok} = icmp eq i64 {tag}, {vidx}");
                let ok_lbl = self.fresh_label("pat.enum.ok");
                self.emit_cond_br(&ok, &ok_lbl, fail_lbl, out);
                self.start_block(&ok_lbl, out);

                if !fields.is_empty() {
                    let eslot = self.next_slot("pat.enum");
                    let _ = writeln!(self.allocas, "  {eslot} = alloca {enum_ir}, align 8");
                    let _ = writeln!(out, "  store {enum_ir} {val}, ptr {eslot}, align 8");
                    for ((sp, fty), woff) in args.iter().zip(fields.iter()).zip(offsets.iter()) {
                        let fp = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {fp} = getelementptr inbounds {enum_ir}, ptr {eslot}, i32 0, i32 1, i64 {woff}"
                        );
                        let fv = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {fv} = load {}, ptr {fp}, align {}",
                            ir_type(fty),
                            ir_align(fty)
                        );
                        self.emit_pattern_test(sp, fty, &fv, false, fail_lbl, binds, *pspan, out)?;
                    }
                }
                Ok(())
            }

            Pattern::Or(alts, pspan) => {
                let first_names = pattern_bound_names(&alts[0]);
                for alt in &alts[1..] {
                    if pattern_bound_names(alt) != first_names {
                        return Err(Diagnostic::new(
                            "alternatives in an `|` pattern must bind the exact same variable names",
                            *pspan,
                        ));
                    }
                }
                let or_ok_lbl = self.fresh_label("pat.or.ok");
                for (ai, alt) in alts.iter().enumerate() {
                    let next_alt_lbl = if ai + 1 < alts.len() {
                        self.fresh_label("pat.or.next")
                    } else {
                        fail_lbl.to_string()
                    };
                    self.emit_pattern_test(
                        alt,
                        val_ty,
                        val,
                        none_already_matched,
                        &next_alt_lbl,
                        binds,
                        *pspan,
                        out,
                    )?;
                    self.emit_br(&or_ok_lbl, out);
                    if ai + 1 < alts.len() {
                        self.start_block(&next_alt_lbl, out);
                    }
                }
                self.start_block(&or_ok_lbl, out);
                Ok(())
            }
        }
    }

    fn find_or_create_bind_slot(
        &mut self,
        name: &str,
        ty: &Type,
        binds: &mut Vec<(String, Type, String)>,
    ) -> String {
        for (bn, bt, slot) in binds.iter() {
            if bn == name && bt == ty {
                return slot.clone();
            }
        }
        let slot = self.next_slot(&format!("pbind.{name}"));
        let _ = writeln!(
            self.allocas,
            "  {slot} = alloca {}, align {}",
            ir_type(ty),
            ir_align(ty)
        );
        binds.push((name.to_string(), ty.clone(), slot.clone()));
        slot
    }
}

fn pattern_bound_names(pat: &Pattern) -> HashSet<String> {
    let mut s = HashSet::new();
    collect_pnames(pat, &mut s);
    s
}

fn collect_pnames(pat: &Pattern, out: &mut HashSet<String>) {
    match pat {
        Pattern::Bind(n, _) => {
            out.insert(n.clone());
        }
        Pattern::Tuple(ps, _) | Pattern::Or(ps, _) => {
            for p in ps {
                collect_pnames(p, out);
            }
        }
        Pattern::EnumVariant { args, .. } => {
            for a in args {
                collect_pnames(a, out);
            }
        }
        _ => {}
    }
}

fn pattern_matches_none(pat: &Pattern) -> bool {
    match pat {
        Pattern::NonePat(_) | Pattern::Wildcard(_) | Pattern::Bind(_, _) => true,
        Pattern::Or(alts, _) => alts.iter().any(pattern_matches_none),
        _ => false,
    }
}

fn is_irrefutable_pattern(pat: &Pattern, subj_ty: &Type) -> bool {
    match pat {
        Pattern::Wildcard(_) | Pattern::Bind(_, _) => true,
        Pattern::Tuple(ps, _) => match subj_ty {
            Type::Tuple(items) => {
                items.len() == ps.len()
                    && ps
                        .iter()
                        .zip(items.iter())
                        .all(|(p, t)| is_irrefutable_pattern(p, t))
            }
            _ => false,
        },
        Pattern::Or(alts, _) => alts.iter().any(|a| is_irrefutable_pattern(a, subj_ty)),
        _ => false,
    }
}

fn mark_enum_coverage(
    pat: &Pattern,
    ename: &str,
    variants: &[(String, Vec<Type>, Vec<usize>)],
    covered: &mut HashSet<String>,
) -> bool {
    match pat {
        Pattern::Wildcard(_) | Pattern::Bind(_, _) => true,
        Pattern::EnumVariant {
            enum_name,
            variant,
            args,
            ..
        } if enum_name == ename => {
            if let Some((_, ftypes, _)) = variants.iter().find(|(vn, _, _)| vn == variant) {
                if args.len() == ftypes.len()
                    && args
                        .iter()
                        .zip(ftypes.iter())
                        .all(|(a, ft)| is_irrefutable_pattern(a, ft))
                {
                    covered.insert(variant.clone());
                }
            }
            covered.len() == variants.len()
        }
        Pattern::Or(alts, _) => {
            for a in alts {
                if mark_enum_coverage(a, ename, variants, covered) {
                    return true;
                }
            }
            covered.len() == variants.len()
        }
        _ => false,
    }
}
