use crate::ast::{
    AssignTarget, BinOp, Expr, ExprKind, Func, Program, Stmt, StmtKind, Type, UnOp,
};
use crate::diag::{Diagnostic, Result, Span};
use std::collections::{HashMap, HashSet};
use std::fmt::Write as _;

const BUILTINS: [&str; 4] = ["print", "len", "push", "pop"];

/// Lowers an Archx program to textual LLVM IR.
///
/// The IR is then compiled by clang (LLVM's compiler driver), which runs the
/// optimizer and emits a native object file. Using text IR keeps the build
/// dependency-free and makes the output inspectable with `--emit-ir`.
///
/// Memory & optimization model (milestone 4):
/// - Immutable scalar parameters and `let` bindings lower directly to SSA
///   values with zero `alloca`/`store`/`load` traffic.
/// - Mutated locals use entry-block `alloca` slots promoted to SSA by `mem2reg`.
/// - Constant integer arithmetic is folded in the frontend.
/// - `for i in a..b:` emits `add nsw i64` when `i` is not reassigned, giving
///   LLVM exact trip counts without C's signed-overflow undefined behavior.
/// - `[T]` arrays are `{ i64 len, i64 cap, ptr data }` (`%ArchxVec`) with
///   1-instruction unsigned bounds checks (`icmp ult`), compile-time
///   bounds-check elision when `0 <= idx < len` is proven, and automatic
///   scope-exit `free` for non-escaping local scalar arrays.
pub fn lower(program: &Program) -> Result<String> {
    let mut sigs = HashMap::new();
    let mut any_sig_uses_vec = false;

    for func in &program.funcs {
        if BUILTINS.contains(&func.name.as_str()) {
            return Err(Diagnostic::new(
                format!("`{}` is a builtin and cannot be redefined", func.name),
                func.span,
            ));
        }

        if sigs.contains_key(&func.name) {
            return Err(Diagnostic::new(
                format!("function `{}` is defined more than once", func.name),
                func.span,
            ));
        }

        let mut seen_params = HashSet::new();
        for param in &func.params {
            if param.ty == Type::Void {
                return Err(Diagnostic::new(
                    "a parameter cannot have type `void`",
                    func.span,
                ));
            }
            if param.ty.is_array() {
                any_sig_uses_vec = true;
            }
            if !seen_params.insert(param.name.as_str()) {
                return Err(Diagnostic::new(
                    format!("duplicate parameter `{}`", param.name),
                    func.span,
                ));
            }
        }

        let ret = match &func.ret {
            Some(Type::Void) | None => None,
            Some(ty) => {
                if ty.is_array() {
                    any_sig_uses_vec = true;
                }
                Some(ty.clone())
            }
        };

        if func.name == "main" {
            if !func.params.is_empty() {
                return Err(Diagnostic::new("`main` cannot take parameters", func.span));
            }
            if let Some(ty) = &ret {
                if *ty != Type::Int {
                    return Err(Diagnostic::new(
                        "`main` must return `int` or nothing",
                        func.span,
                    ));
                }
            }
        }

        sigs.insert(
            func.name.clone(),
            FuncSig {
                params: func.params.iter().map(|p| p.ty.clone()).collect(),
                ret,
            },
        );
    }

    if !sigs.contains_key("main") {
        return Err(Diagnostic::new("no `main` function found", Span::new(1, 1)));
    }

    let mut codegen = Codegen {
        strings: StringTable::new(),
        sigs,
        scopes: Vec::new(),
        mutated_vars: HashSet::new(),
        loop_stack: Vec::new(),
        loop_bounds: Vec::new(),
        break_count: 0,
        tmp: 0,
        label_counter: 0,
        terminated: false,
        current_ret: None,
        is_main: false,
        allocas: String::new(),
        used_vec_type: any_sig_uses_vec,
        used_strlen: false,
        used_strcmp: false,
        used_malloc: false,
        used_calloc: false,
        used_realloc: false,
        used_free: false,
        used_array_print: false,
        used_bounds_fail: false,
        used_neg_len_fail: false,
        used_empty_pop_fail: false,
    };

    let mut bodies = String::new();
    for func in &program.funcs {
        codegen.gen_func(func, &mut bodies)?;
    }

    let mut out = String::new();
    out.push_str("; Archx module\n");
    if codegen.used_vec_type {
        out.push_str("%ArchxVec = type { i64, i64, ptr }\n\n");
    }

    out.push_str("declare i32 @printf(ptr, ...)\n");
    if codegen.used_strlen {
        out.push_str("declare i64 @strlen(ptr)\n");
    }
    if codegen.used_strcmp {
        out.push_str("declare i32 @strcmp(ptr, ptr)\n");
    }
    if codegen.used_malloc {
        out.push_str("declare noalias ptr @malloc(i64)\n");
    }
    if codegen.used_calloc {
        out.push_str("declare noalias ptr @calloc(i64, i64)\n");
    }
    if codegen.used_realloc {
        out.push_str("declare ptr @realloc(ptr, i64)\n");
    }
    if codegen.used_free {
        out.push_str("declare void @free(ptr)\n");
    }
    if codegen.used_bounds_fail || codegen.used_neg_len_fail || codegen.used_empty_pop_fail {
        out.push_str("declare void @exit(i32) noreturn nounwind\n");
    }
    out.push('\n');

    emit_cstr_global(&mut out, "@.fmt.str", "%s\n");
    emit_cstr_global(&mut out, "@.fmt.int", "%lld\n");
    emit_cstr_global(&mut out, "@.str.true", "true");
    emit_cstr_global(&mut out, "@.str.false", "false");

    if codegen.used_array_print {
        emit_cstr_global(&mut out, "@.fmt.lbrack", "[");
        emit_cstr_global(&mut out, "@.fmt.sep", ", ");
        emit_cstr_global(&mut out, "@.fmt.rbrack", "]\n");
        emit_cstr_global(&mut out, "@.fmt.int.elem", "%lld");
        emit_cstr_global(&mut out, "@.fmt.str.elem", "%s");
    }
    if codegen.used_bounds_fail {
        emit_cstr_global(
            &mut out,
            "@.fmt.oob",
            "archx panic: index %lld out of bounds for length %lld\n",
        );
    }
    if codegen.used_neg_len_fail {
        emit_cstr_global(
            &mut out,
            "@.fmt.neglen",
            "archx panic: negative array length %lld\n",
        );
    }
    if codegen.used_empty_pop_fail {
        emit_cstr_global(
            &mut out,
            "@.fmt.emptypop",
            "archx panic: pop from empty array\n",
        );
    }

    for (i, value) in codegen.strings.values.iter().enumerate() {
        emit_cstr_global(&mut out, &format!("@.str.{i}"), value);
    }

    out.push('\n');

    if codegen.used_bounds_fail {
        out.push_str(
            "define private void @archx_bounds_fail(i64 %idx, i64 %len) cold noreturn nounwind {\n\
             entry:\n\
             \x20 %0 = call i32 (ptr, ...) @printf(ptr @.fmt.oob, i64 %idx, i64 %len)\n\
             \x20 call void @exit(i32 101)\n\
             \x20 unreachable\n\
             }\n\n",
        );
    }
    if codegen.used_neg_len_fail {
        out.push_str(
            "define private void @archx_neg_len_fail(i64 %len) cold noreturn nounwind {\n\
             entry:\n\
             \x20 %0 = call i32 (ptr, ...) @printf(ptr @.fmt.neglen, i64 %len)\n\
             \x20 call void @exit(i32 101)\n\
             \x20 unreachable\n\
             }\n\n",
        );
    }
    if codegen.used_empty_pop_fail {
        out.push_str(
            "define private void @archx_empty_pop_fail() cold noreturn nounwind {\n\
             entry:\n\
             \x20 %0 = call i32 (ptr, ...) @printf(ptr @.fmt.emptypop)\n\
             \x20 call void @exit(i32 101)\n\
             \x20 unreachable\n\
             }\n\n",
        );
    }

    out.push_str(&bodies);
    Ok(out)
}

#[derive(Clone)]
struct FuncSig {
    params: Vec<Type>,
    ret: Option<Type>,
}

#[derive(Clone)]
enum VarStorage {
    Imm(String),
    Slot(String),
}

#[derive(Clone)]
struct VarEntry {
    ty: Type,
    storage: VarStorage,
    is_param: bool,
}

#[derive(Clone, Debug, PartialEq, Eq)]
enum KnownLen {
    Const(i64),
    Var(String),
}

struct Scope {
    vars: HashMap<String, VarEntry>,
    known_lens: HashMap<String, KnownLen>,
    owned_buffers: Vec<String>,
}

impl Scope {
    fn new() -> Self {
        Self {
            vars: HashMap::new(),
            known_lens: HashMap::new(),
            owned_buffers: Vec::new(),
        }
    }
}

struct LoopLabels {
    break_label: String,
    continue_label: String,
    /// Depth of `scopes` outside the loop body; `break`/`continue` drops
    /// `scopes[scope_depth..]`.
    scope_depth: usize,
}

#[derive(Clone, Debug)]
struct InductionBound {
    var: String,
    upper: UpperBound,
}

#[derive(Clone, Debug)]
enum UpperBound {
    Const(i64),
    Var(String),
    LenOf(String),
}

struct StringTable {
    values: Vec<String>,
    index: HashMap<String, usize>,
}

impl StringTable {
    fn new() -> Self {
        Self {
            values: Vec::new(),
            index: HashMap::new(),
        }
    }

    fn intern(&mut self, value: &str) -> String {
        if let Some(&i) = self.index.get(value) {
            return format!("@.str.{i}");
        }
        let i = self.values.len();
        self.values.push(value.to_string());
        self.index.insert(value.to_string(), i);
        format!("@.str.{i}")
    }
}

struct Codegen {
    strings: StringTable,
    sigs: HashMap<String, FuncSig>,
    scopes: Vec<Scope>,
    mutated_vars: HashSet<String>,
    loop_stack: Vec<LoopLabels>,
    loop_bounds: Vec<InductionBound>,
    break_count: usize,
    tmp: usize,
    label_counter: usize,
    terminated: bool,
    current_ret: Option<Type>,
    is_main: bool,
    allocas: String,
    used_vec_type: bool,
    used_strlen: bool,
    used_strcmp: bool,
    used_malloc: bool,
    used_calloc: bool,
    used_realloc: bool,
    used_free: bool,
    used_array_print: bool,
    used_bounds_fail: bool,
    used_neg_len_fail: bool,
    used_empty_pop_fail: bool,
}

impl Codegen {
    fn gen_func(&mut self, func: &Func, out: &mut String) -> Result<()> {
        self.scopes = vec![Scope::new()];
        self.mutated_vars.clear();
        collect_mutated_vars(&func.body, &mut self.mutated_vars);
        self.loop_stack.clear();
        self.loop_bounds.clear();
        self.break_count = 0;
        self.tmp = 0;
        self.label_counter = 0;
        self.terminated = false;
        self.is_main = func.name == "main";
        self.allocas.clear();

        let ir_ret = if self.is_main {
            "i32"
        } else {
            ir_ret_type(func.ret.as_ref())
        };

        self.current_ret = if self.is_main {
            Some(Type::Int)
        } else {
            match &func.ret {
                Some(Type::Void) => None,
                other => other.clone(),
            }
        };

        let mut header = String::new();
        let _ = write!(header, "define {} {}(", ir_ret, mangle(&func.name));
        for (i, param) in func.params.iter().enumerate() {
            if i > 0 {
                header.push_str(", ");
            }
            let _ = write!(header, "{} %param.{}", ir_type(&param.ty), param.name);
        }
        header.push_str(") nounwind");

        let mut body = String::new();
        for param in &func.params {
            let storage = if self.mutated_vars.contains(&param.name) {
                let ty = ir_type(&param.ty);
                let ptr = format!("%param.{}.addr", param.name);
                let _ = writeln!(self.allocas, "  {ptr} = alloca {ty}");
                let _ = writeln!(body, "  store {ty} %param.{}, ptr {ptr}", param.name);
                VarStorage::Slot(ptr)
            } else {
                VarStorage::Imm(format!("%param.{}", param.name))
            };

            self.scopes[0].vars.insert(
                param.name.clone(),
                VarEntry {
                    ty: param.ty.clone(),
                    storage,
                    is_param: true,
                },
            );
        }

        self.gen_block(&func.body, &mut body)?;

        if !self.terminated {
            if self.is_main {
                self.emit_all_scope_drops(&mut body);
                body.push_str("  ret i32 0\n");
            } else if self.current_ret.is_none() {
                self.emit_all_scope_drops(&mut body);
                body.push_str("  ret void\n");
            } else {
                return Err(Diagnostic::new(
                    format!(
                        "function `{}` must return a value on every path",
                        func.name
                    ),
                    func.span,
                ));
            }
        }

        out.push_str(&header);
        out.push_str(" {\nentry:\n");
        out.push_str(&self.allocas);
        out.push_str(&body);
        out.push_str("}\n\n");
        Ok(())
    }

    fn gen_block(&mut self, stmts: &[Stmt], out: &mut String) -> Result<()> {
        for (idx, stmt) in stmts.iter().enumerate() {
            self.gen_stmt(stmt, &stmts[idx + 1..], out)?;
        }
        Ok(())
    }

    fn gen_stmt(&mut self, stmt: &Stmt, rest_in_block: &[Stmt], out: &mut String) -> Result<()> {
        if self.terminated {
            let dead = self.fresh_label("dead");
            self.start_block(&dead, out);
        }

        match &stmt.kind {
            StmtKind::Let {
                name,
                ty: declared_ty,
                value,
            } => {
                if self.lookup_var(name).is_some() {
                    return Err(Diagnostic::new(
                        format!("variable `{name}` is already defined in this scope"),
                        stmt.span,
                    ));
                }

                if let Some(t) = declared_ty {
                    if *t == Type::Void {
                        return Err(Diagnostic::new(
                            "cannot declare a variable of type `void`",
                            stmt.span,
                        ));
                    }
                    if t.is_array() {
                        self.used_vec_type = true;
                    }
                }

                let (ty, val) = self.eval_expr_typed(value, declared_ty.as_ref(), out)?;
                if ty == Type::Void {
                    return Err(Diagnostic::new(
                        "cannot store a `void` value in a variable",
                        stmt.span,
                    ));
                }
                if let Some(expected) = declared_ty {
                    if *expected != ty {
                        return Err(Diagnostic::new(
                            format!(
                                "type mismatch in `let {name}`: expected `{}`, found `{}`",
                                expected.name(),
                                ty.name()
                            ),
                            stmt.span,
                        ));
                    }
                }

                let is_mutated = self.mutated_vars.contains(name);

                // Record compile-time array length facts when neither the
                // array binding nor its size variable is mutated.
                if !is_mutated && ty.is_array() {
                    if let Some(known) = self.infer_known_array_len(value) {
                        self.scopes
                            .last_mut()
                            .unwrap()
                            .known_lens
                            .insert(name.clone(), known);
                    }
                }

                // Scalars that are never reassigned stay in SSA directly;
                // mutated variables and arrays live in entry-block allocas.
                let storage = if !is_mutated && !ty.is_array() {
                    VarStorage::Imm(val)
                } else {
                    let ptr = self.next_slot(&format!("var.{name}"));
                    let ty_ir = ir_type(&ty);
                    let _ = writeln!(self.allocas, "  {ptr} = alloca {ty_ir}");
                    let _ = writeln!(out, "  store {ty_ir} {val}, ptr {ptr}");

                    // Deterministic scope-exit RAII cleanup for non-escaping
                    // 1D scalar-element arrays allocated right here.
                    if let Type::Array(elem) = &ty {
                        let is_fresh_alloc = matches!(
                            &value.kind,
                            ExprKind::ArrayLit(_) | ExprKind::ArrayRepeat { .. }
                        );
                        if is_fresh_alloc
                            && !elem.is_array()
                            && !is_mutated_binding_assigned(rest_in_block, name)
                            && !var_escapes_in_stmts(rest_in_block, name, &self.sigs)
                        {
                            self.scopes
                                .last_mut()
                                .unwrap()
                                .owned_buffers
                                .push(ptr.clone());
                        }
                    }

                    VarStorage::Slot(ptr)
                };

                self.scopes.last_mut().unwrap().vars.insert(
                    name.clone(),
                    VarEntry {
                        ty,
                        storage,
                        is_param: false,
                    },
                );
                Ok(())
            }

            StmtKind::Return(value) => {
                if let Some(expr) = value {
                    let expected_hint = self.current_ret.clone();
                    let (ty, val) = self.eval_expr_typed(expr, expected_hint.as_ref(), out)?;

                    if self.is_main {
                        if ty != Type::Int {
                            return Err(Diagnostic::new(
                                "`main` must return an `int`",
                                stmt.span,
                            ));
                        }
                        self.emit_all_scope_drops(out);
                        let truncated = self.next_tmp();
                        let _ = writeln!(out, "  {truncated} = trunc i64 {val} to i32");
                        let _ = writeln!(out, "  ret i32 {truncated}");
                        self.terminated = true;
                        return Ok(());
                    }

                    match self.current_ret.clone() {
                        Some(expected) if expected == ty => {
                            self.emit_all_scope_drops(out);
                            let _ = writeln!(out, "  ret {} {}", ir_type(&ty), val);
                        }
                        Some(expected) => {
                            return Err(Diagnostic::new(
                                format!(
                                    "`return` type mismatch: expected `{}`, found `{}`",
                                    expected.name(),
                                    ty.name()
                                ),
                                stmt.span,
                            ));
                        }
                        None => {
                            return Err(Diagnostic::new(
                                "this function does not return a value",
                                stmt.span,
                            ));
                        }
                    }
                } else if self.is_main {
                    self.emit_all_scope_drops(out);
                    out.push_str("  ret i32 0\n");
                } else {
                    match self.current_ret {
                        Some(_) => {
                            return Err(Diagnostic::new(
                                "this function must return a value",
                                stmt.span,
                            ));
                        }
                        None => {
                            self.emit_all_scope_drops(out);
                            out.push_str("  ret void\n");
                        }
                    }
                }

                self.terminated = true;
                Ok(())
            }

            StmtKind::Expr(expr) => {
                self.eval_expr(expr, out)?;
                Ok(())
            }

            StmtKind::Assign { target, op, value } => {
                self.gen_assign(target, *op, value, stmt.span, out)
            }

            StmtKind::While { cond, body } => {
                let cond_label = self.fresh_label("while.cond");
                let body_label = self.fresh_label("while.body");
                let end_label = self.fresh_label("while.end");

                self.emit_br(&cond_label, out);

                self.start_block(&cond_label, out);
                let (cond_ty, cond_val) = self.eval_expr(cond, out)?;
                if cond_ty != Type::Bool {
                    return Err(Diagnostic::new(
                        "`while` condition must be a `bool`",
                        cond.span,
                    ));
                }
                self.emit_cond_br(&cond_val, &body_label, &end_label, out);

                self.start_block(&body_label, out);
                let outer_depth = self.scopes.len();
                self.push_scope();
                let breaks_before = self.break_count;
                self.loop_stack.push(LoopLabels {
                    break_label: end_label.clone(),
                    continue_label: cond_label.clone(),
                    scope_depth: outer_depth,
                });
                self.gen_block(body, out)?;
                self.loop_stack.pop();
                self.pop_scope_with_drops(out);
                if !self.terminated {
                    self.emit_br(&cond_label, out);
                }

                let always_true = matches!(&cond.kind, ExprKind::Bool(true));
                let had_break = self.break_count > breaks_before;

                self.start_block(&end_label, out);
                if always_true && !had_break {
                    let _ = writeln!(out, "  unreachable");
                    self.terminated = true;
                }
                Ok(())
            }

            StmtKind::For {
                var,
                start,
                end,
                body,
            } => {
                let (start_ty, start_val) = self.eval_expr(start, out)?;
                if start_ty != Type::Int {
                    return Err(Diagnostic::new("`for` start must be an `int`", start.span));
                }
                let (end_ty, end_val) = self.eval_expr(end, out)?;
                if end_ty != Type::Int {
                    return Err(Diagnostic::new("`for` end must be an `int`", end.span));
                }

                if self.lookup_var(var).is_some() {
                    return Err(Diagnostic::new(
                        format!("loop variable `{var}` is already defined"),
                        stmt.span,
                    ));
                }

                let iv_reassigned = stmts_assign_var(body, var);
                let proven_bound = if !iv_reassigned {
                    self.derive_for_bound(var, start, end, body)
                } else {
                    None
                };

                let slot = self.next_slot(&format!("for.{var}"));
                let _ = writeln!(self.allocas, "  {slot} = alloca i64");
                let _ = writeln!(out, "  store i64 {start_val}, ptr {slot}");

                let cond_label = self.fresh_label("for.cond");
                let body_label = self.fresh_label("for.body");
                let step_label = self.fresh_label("for.step");
                let end_label = self.fresh_label("for.end");

                self.emit_br(&cond_label, out);

                self.start_block(&cond_label, out);
                let i = self.next_tmp();
                let _ = writeln!(out, "  {i} = load i64, ptr {slot}");
                let cmp = self.next_tmp();
                let _ = writeln!(out, "  {cmp} = icmp slt i64 {i}, {end_val}");
                self.emit_cond_br(&cmp, &body_label, &end_label, out);

                self.start_block(&body_label, out);
                let outer_depth = self.scopes.len();
                self.push_scope();
                self.scopes.last_mut().unwrap().vars.insert(
                    var.clone(),
                    VarEntry {
                        ty: Type::Int,
                        storage: VarStorage::Slot(slot.clone()),
                        is_param: false,
                    },
                );
                if let Some(bound) = &proven_bound {
                    self.loop_bounds.push(bound.clone());
                }
                self.loop_stack.push(LoopLabels {
                    break_label: end_label.clone(),
                    continue_label: step_label.clone(),
                    scope_depth: outer_depth,
                });
                self.gen_block(body, out)?;
                self.loop_stack.pop();
                if proven_bound.is_some() {
                    self.loop_bounds.pop();
                }
                self.pop_scope_with_drops(out);
                if !self.terminated {
                    self.emit_br(&step_label, out);
                }

                self.start_block(&step_label, out);
                let i2 = self.next_tmp();
                let _ = writeln!(out, "  {i2} = load i64, ptr {slot}");
                let next = self.next_tmp();
                // Whenever `var` is not mutated in the body, `i2 < end <= i64::MAX`
                // guarantees `i2 + 1` cannot signed-overflow, unlocking exact
                // LLVM ScalarEvolution trip counts and SIMD vectorization.
                if !iv_reassigned {
                    let _ = writeln!(out, "  {next} = add nsw i64 {i2}, 1");
                } else {
                    let _ = writeln!(out, "  {next} = add i64 {i2}, 1");
                }
                let _ = writeln!(out, "  store i64 {next}, ptr {slot}");
                self.emit_br(&cond_label, out);

                self.start_block(&end_label, out);
                Ok(())
            }

            StmtKind::Break => {
                let (label, depth) = self
                    .loop_stack
                    .last()
                    .map(|labels| (labels.break_label.clone(), labels.scope_depth))
                    .ok_or_else(|| {
                        Diagnostic::new("`break` is only allowed inside a loop", stmt.span)
                    })?;
                self.emit_drops_from_depth(depth, out);
                self.break_count += 1;
                self.emit_br(&label, out);
                Ok(())
            }

            StmtKind::Continue => {
                let (label, depth) = self
                    .loop_stack
                    .last()
                    .map(|labels| (labels.continue_label.clone(), labels.scope_depth))
                    .ok_or_else(|| {
                        Diagnostic::new("`continue` is only allowed inside a loop", stmt.span)
                    })?;
                self.emit_drops_from_depth(depth, out);
                self.emit_br(&label, out);
                Ok(())
            }

            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                let (cond_ty, cond_val) = self.eval_expr(cond, out)?;
                if cond_ty != Type::Bool {
                    return Err(Diagnostic::new(
                        "`if` condition must be a `bool`",
                        cond.span,
                    ));
                }

                let then_label = self.fresh_label("if.then");
                let else_label = self.fresh_label("if.else");
                let merge_label = self.fresh_label("if.merge");

                self.emit_cond_br(&cond_val, &then_label, &else_label, out);

                self.start_block(&then_label, out);
                self.push_scope();
                self.gen_block(then_body, out)?;
                self.pop_scope_with_drops(out);
                let then_terminated = self.terminated;
                if !then_terminated {
                    self.emit_br(&merge_label, out);
                }

                self.start_block(&else_label, out);
                if let Some(body) = else_body {
                    self.push_scope();
                    self.gen_block(body, out)?;
                    self.pop_scope_with_drops(out);
                }
                let else_terminated = self.terminated;
                if !else_terminated {
                    self.emit_br(&merge_label, out);
                }

                self.start_block(&merge_label, out);
                if then_terminated && else_terminated {
                    let _ = writeln!(out, "  unreachable");
                    self.terminated = true;
                }
                Ok(())
            }
        }
    }

    fn gen_assign(
        &mut self,
        target: &AssignTarget,
        op: Option<BinOp>,
        value: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<()> {
        match target {
            AssignTarget::Var(name) => {
                let entry = self.lookup_var(name).cloned().ok_or_else(|| {
                    Diagnostic::new(format!("undefined variable `{name}`"), span)
                })?;
                let ptr = match &entry.storage {
                    VarStorage::Slot(p) => p.clone(),
                    VarStorage::Imm(_) => {
                        return Err(Diagnostic::new(
                            format!("internal error: mutated variable `{name}` lacked a slot"),
                            span,
                        ));
                    }
                };

                if let Some(bin_op) = op {
                    if entry.ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires an `int` target, found `{}`",
                                bin_op.symbol(),
                                entry.ty.name()
                            ),
                            span,
                        ));
                    }
                    let old_val = self.next_tmp();
                    let _ = writeln!(out, "  {old_val} = load i64, ptr {ptr}");
                    let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
                    if rhs_ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires an `int` right-hand side, found `{}`",
                                bin_op.symbol(),
                                rhs_ty.name()
                            ),
                            value.span,
                        ));
                    }
                    let new_val = self.emit_int_arith(bin_op, &old_val, &rhs_val, out);
                    let _ = writeln!(out, "  store i64 {new_val}, ptr {ptr}");
                } else {
                    let (val_ty, val) = self.eval_expr_typed(value, Some(&entry.ty), out)?;
                    if val_ty != entry.ty {
                        return Err(Diagnostic::new(
                            format!(
                                "cannot assign `{}` to variable `{}` of type `{}`",
                                val_ty.name(),
                                name,
                                entry.ty.name()
                            ),
                            span,
                        ));
                    }
                    let _ = writeln!(out, "  store {} {}, ptr {}", ir_type(&entry.ty), val, ptr);
                }
                Ok(())
            }

            AssignTarget::Index {
                target: arr_expr,
                index: idx_expr,
            } => {
                let (arr_ty, vec_val) = self.eval_expr(arr_expr, out)?;
                let Type::Array(elem_ty) = arr_ty else {
                    return Err(Diagnostic::new(
                        format!("cannot index into value of type `{}`", arr_ty.name()),
                        arr_expr.span,
                    ));
                };
                let (idx_ty, idx_val) = self.eval_expr(idx_expr, out)?;
                if idx_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!("array index must be `int`, found `{}`", idx_ty.name()),
                        idx_expr.span,
                    ));
                }

                self.emit_bounds_check_if_needed(arr_expr, idx_expr, &vec_val, &idx_val, out)?;

                let data_ptr = self.next_tmp();
                let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {vec_val}, 2");
                let elem_ptr = self.next_tmp();
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let _ = writeln!(
                    out,
                    "  {elem_ptr} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {idx_val}"
                );

                if let Some(bin_op) = op {
                    if *elem_ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires `int` elements, found `{}`",
                                bin_op.symbol(),
                                elem_ty.name()
                            ),
                            span,
                        ));
                    }
                    let old_val = self.next_tmp();
                    let _ = writeln!(out, "  {old_val} = load i64, ptr {elem_ptr}");
                    let (rhs_ty, rhs_val) = self.eval_expr(value, out)?;
                    if rhs_ty != Type::Int {
                        return Err(Diagnostic::new(
                            format!(
                                "operator `{}=` requires an `int` right-hand side, found `{}`",
                                bin_op.symbol(),
                                rhs_ty.name()
                            ),
                            value.span,
                        ));
                    }
                    let new_val = self.emit_int_arith(bin_op, &old_val, &rhs_val, out);
                    let _ = writeln!(out, "  store i64 {new_val}, ptr {elem_ptr}");
                } else {
                    let (rhs_ty, rhs_val) = self.eval_expr_typed(value, Some(&elem_ty), out)?;
                    if rhs_ty != *elem_ty {
                        return Err(Diagnostic::new(
                            format!(
                                "cannot assign `{}` to element of `[{}]`",
                                rhs_ty.name(),
                                elem_ty.name()
                            ),
                            value.span,
                        ));
                    }
                    self.emit_elem_store(&elem_ty, &rhs_val, &elem_ptr, out);
                }

                Ok(())
            }
        }
    }

    fn eval_expr(&mut self, expr: &Expr, out: &mut String) -> Result<(Type, String)> {
        self.eval_expr_typed(expr, None, out)
    }

    fn eval_expr_typed(
        &mut self,
        expr: &Expr,
        expected: Option<&Type>,
        out: &mut String,
    ) -> Result<(Type, String)> {
        match &expr.kind {
            ExprKind::Int(value) => Ok((Type::Int, value.to_string())),

            ExprKind::Bool(value) => Ok((Type::Bool, value.to_string())),

            ExprKind::Str(value) => {
                let label = self.strings.intern(value);
                Ok((Type::Str, label))
            }

            ExprKind::Var(name) => {
                let entry = self.lookup_var(name).cloned().ok_or_else(|| {
                    Diagnostic::new(format!("undefined variable `{name}`"), expr.span)
                })?;
                match entry.storage {
                    VarStorage::Imm(val) => Ok((entry.ty, val)),
                    VarStorage::Slot(ptr) => {
                        let reg = self.next_tmp();
                        let _ = writeln!(out, "  {reg} = load {}, ptr {ptr}", ir_type(&entry.ty));
                        Ok((entry.ty, reg))
                    }
                }
            }

            ExprKind::ArrayLit(elems) => {
                self.used_vec_type = true;
                if elems.is_empty() {
                    let Some(Type::Array(elem_ty)) = expected else {
                        return Err(Diagnostic::new(
                            "cannot infer element type of empty array `[]`; add a type annotation like `let xs: [int] = []`",
                            expr.span,
                        ));
                    };
                    let vec = self.build_vec_val("0", "0", "null", out);
                    return Ok((Type::Array(elem_ty.clone()), vec));
                }

                let elem_hint = match expected {
                    Some(Type::Array(inner)) => Some(inner.as_ref()),
                    _ => None,
                };

                let (first_ty, first_val) = self.eval_expr_typed(&elems[0], elem_hint, out)?;
                if first_ty == Type::Void {
                    return Err(Diagnostic::new(
                        "array elements cannot have type `void`",
                        elems[0].span,
                    ));
                }

                let mut vals = vec![first_val];
                for item in &elems[1..] {
                    let (ty, val) = self.eval_expr_typed(item, Some(&first_ty), out)?;
                    if ty != first_ty {
                        return Err(Diagnostic::new(
                            format!(
                                "array element type mismatch: expected `{}`, found `{}`",
                                first_ty.name(),
                                ty.name()
                            ),
                            item.span,
                        ));
                    }
                    vals.push(val);
                }

                let count = vals.len() as i64;
                let bytes = count * elem_byte_size(&first_ty);
                self.used_malloc = true;
                let data_ptr = self.next_tmp();
                let _ = writeln!(out, "  {data_ptr} = call noalias ptr @malloc(i64 {bytes})");

                let mem_ty = elem_mem_ir_type(&first_ty);
                for (i, val) in vals.iter().enumerate() {
                    let ep = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {ep} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {i}"
                    );
                    self.emit_elem_store(&first_ty, val, &ep, out);
                }

                let count_str = count.to_string();
                let vec = self.build_vec_val(&count_str, &count_str, &data_ptr, out);
                Ok((Type::Array(Box::new(first_ty)), vec))
            }

            ExprKind::ArrayRepeat { value, count } => {
                self.used_vec_type = true;
                let elem_hint = match expected {
                    Some(Type::Array(inner)) => Some(inner.as_ref()),
                    _ => None,
                };
                let (elem_ty, init_val) = self.eval_expr_typed(value, elem_hint, out)?;
                if elem_ty == Type::Void {
                    return Err(Diagnostic::new(
                        "array elements cannot have type `void`",
                        value.span,
                    ));
                }
                let (count_ty, count_val) = self.eval_expr(count, out)?;
                if count_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "array repeat count must be `int`, found `{}`",
                            count_ty.name()
                        ),
                        count.span,
                    ));
                }

                match eval_const_int(count) {
                    Some(n) if n < 0 => {
                        return Err(Diagnostic::new(
                            format!("array repeat count cannot be negative (`{n}`)"),
                            count.span,
                        ));
                    }
                    Some(_) => {}
                    None => {
                        self.used_neg_len_fail = true;
                        let is_neg = self.next_tmp();
                        let neg_label = self.fresh_label("arr.neg");
                        let ok_label = self.fresh_label("arr.ok");
                        let _ = writeln!(out, "  {is_neg} = icmp slt i64 {count_val}, 0");
                        self.emit_cond_br(&is_neg, &neg_label, &ok_label, out);
                        self.start_block(&neg_label, out);
                        let _ = writeln!(out, "  call void @archx_neg_len_fail(i64 {count_val})");
                        let _ = writeln!(out, "  unreachable");
                        self.terminated = true;
                        self.start_block(&ok_label, out);
                    }
                }

                let elem_size = elem_byte_size(&elem_ty);
                let is_zero_fill = (elem_ty == Type::Int && init_val == "0")
                    || (elem_ty == Type::Bool && init_val == "false");

                let data_ptr = if is_zero_fill {
                    self.used_calloc = true;
                    let ptr_reg = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {ptr_reg} = call noalias ptr @calloc(i64 {count_val}, i64 {elem_size})"
                    );
                    ptr_reg
                } else {
                    self.used_malloc = true;
                    let bytes = if let Ok(c) = count_val.parse::<i64>() {
                        (c * elem_size).to_string()
                    } else {
                        let b = self.next_tmp();
                        let _ = writeln!(out, "  {b} = mul i64 {count_val}, {elem_size}");
                        b
                    };
                    let ptr_reg = self.next_tmp();
                    let _ = writeln!(out, "  {ptr_reg} = call noalias ptr @malloc(i64 {bytes})");

                    let idx_slot = self.next_slot("arr.fill");
                    let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64");
                    let _ = writeln!(out, "  store i64 0, ptr {idx_slot}");

                    let cond_label = self.fresh_label("arr.fill.cond");
                    let body_label = self.fresh_label("arr.fill.body");
                    let end_label = self.fresh_label("arr.fill.end");

                    self.emit_br(&cond_label, out);
                    self.start_block(&cond_label, out);
                    let fi = self.next_tmp();
                    let _ = writeln!(out, "  {fi} = load i64, ptr {idx_slot}");
                    let fcmp = self.next_tmp();
                    let _ = writeln!(out, "  {fcmp} = icmp slt i64 {fi}, {count_val}");
                    self.emit_cond_br(&fcmp, &body_label, &end_label, out);

                    self.start_block(&body_label, out);
                    let fep = self.next_tmp();
                    let mem_ty = elem_mem_ir_type(&elem_ty);
                    let _ = writeln!(
                        out,
                        "  {fep} = getelementptr inbounds {mem_ty}, ptr {ptr_reg}, i64 {fi}"
                    );
                    self.emit_elem_store(&elem_ty, &init_val, &fep, out);
                    let fnext = self.next_tmp();
                    let _ = writeln!(out, "  {fnext} = add nsw i64 {fi}, 1");
                    let _ = writeln!(out, "  store i64 {fnext}, ptr {idx_slot}");
                    self.emit_br(&cond_label, out);

                    self.start_block(&end_label, out);
                    ptr_reg
                };

                let vec = self.build_vec_val(&count_val, &count_val, &data_ptr, out);
                Ok((Type::Array(Box::new(elem_ty)), vec))
            }

            ExprKind::Index { target, index } => {
                let (arr_ty, vec_val) = self.eval_expr(target, out)?;
                let Type::Array(elem_ty) = arr_ty else {
                    return Err(Diagnostic::new(
                        format!("cannot index into value of type `{}`", arr_ty.name()),
                        target.span,
                    ));
                };
                let (idx_ty, idx_val) = self.eval_expr(index, out)?;
                if idx_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!("array index must be `int`, found `{}`", idx_ty.name()),
                        index.span,
                    ));
                }

                self.emit_bounds_check_if_needed(target, index, &vec_val, &idx_val, out)?;

                let data_ptr = self.next_tmp();
                let _ = writeln!(out, "  {data_ptr} = extractvalue %ArchxVec {vec_val}, 2");
                let elem_ptr = self.next_tmp();
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let _ = writeln!(
                    out,
                    "  {elem_ptr} = getelementptr inbounds {mem_ty}, ptr {data_ptr}, i64 {idx_val}"
                );
                let loaded = self.emit_elem_load(&elem_ty, &elem_ptr, out);
                Ok((*elem_ty, loaded))
            }

            ExprKind::Unary { op, expr: inner } => {
                let (ty, val) = self.eval_expr(inner, out)?;
                match op {
                    UnOp::Neg => {
                        if ty != Type::Int {
                            return Err(Diagnostic::new(
                                "unary `-` requires an `int` operand",
                                expr.span,
                            ));
                        }
                        let reg = self.next_tmp();
                        let _ = writeln!(out, "  {reg} = sub i64 0, {val}");
                        Ok((Type::Int, reg))
                    }
                    UnOp::Not => {
                        if ty != Type::Bool {
                            return Err(Diagnostic::new(
                                "`not` requires a `bool` operand",
                                expr.span,
                            ));
                        }
                        let reg = self.next_tmp();
                        let _ = writeln!(out, "  {reg} = xor i1 {val}, true");
                        Ok((Type::Bool, reg))
                    }
                }
            }

            ExprKind::Binary { op, lhs, rhs } => self.gen_binary(*op, lhs, rhs, expr.span, out),

            ExprKind::Call { name, args } => self.gen_call(name, args, expr.span, out),
        }
    }

    fn gen_binary(
        &mut self,
        op: BinOp,
        lhs: &Expr,
        rhs: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        match op {
            BinOp::And | BinOp::Or => return self.gen_short_circuit(op, lhs, rhs, span, out),
            _ => {}
        }

        let (lhs_ty, lhs_val) = self.eval_expr(lhs, out)?;
        let (rhs_ty, rhs_val) = self.eval_expr(rhs, out)?;

        match op {
            BinOp::Add | BinOp::Sub | BinOp::Mul | BinOp::Div | BinOp::Mod => {
                if lhs_ty != Type::Int || rhs_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}` requires `int` operands, found `{}` and `{}`",
                            op.symbol(),
                            lhs_ty.name(),
                            rhs_ty.name()
                        ),
                        span,
                    ));
                }

                let val = self.emit_int_arith(op, &lhs_val, &rhs_val, out);
                Ok((Type::Int, val))
            }

            BinOp::Eq | BinOp::Ne => {
                if lhs_ty == Type::Str && rhs_ty == Type::Str {
                    self.used_strcmp = true;
                    let cmp_call = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {cmp_call} = call i32 @strcmp(ptr {lhs_val}, ptr {rhs_val})"
                    );
                    let reg = self.next_tmp();
                    let pred = if op == BinOp::Eq { "eq" } else { "ne" };
                    let _ = writeln!(out, "  {reg} = icmp {pred} i32 {cmp_call}, 0");
                    return Ok((Type::Bool, reg));
                }

                if lhs_ty != rhs_ty || (lhs_ty != Type::Int && lhs_ty != Type::Bool) {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}` requires two `int`, `bool`, or `string` operands, found `{}` and `{}`",
                            op.symbol(),
                            lhs_ty.name(),
                            rhs_ty.name()
                        ),
                        span,
                    ));
                }

                let reg = self.next_tmp();
                let pred = if op == BinOp::Eq { "eq" } else { "ne" };
                let ty_ir = if lhs_ty == Type::Bool { "i1" } else { "i64" };
                let _ = writeln!(out, "  {reg} = icmp {pred} {ty_ir} {lhs_val}, {rhs_val}");
                Ok((Type::Bool, reg))
            }

            BinOp::Lt | BinOp::Gt | BinOp::Le | BinOp::Ge => {
                if lhs_ty != Type::Int || rhs_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}` requires `int` operands, found `{}` and `{}`",
                            op.symbol(),
                            lhs_ty.name(),
                            rhs_ty.name()
                        ),
                        span,
                    ));
                }

                let reg = self.next_tmp();
                let pred = match op {
                    BinOp::Lt => "slt",
                    BinOp::Gt => "sgt",
                    BinOp::Le => "sle",
                    BinOp::Ge => "sge",
                    _ => unreachable!(),
                };
                let _ = writeln!(out, "  {reg} = icmp {pred} i64 {lhs_val}, {rhs_val}");
                Ok((Type::Bool, reg))
            }

            BinOp::And | BinOp::Or => unreachable!("handled above"),
        }
    }

    fn emit_int_arith(&mut self, op: BinOp, lhs_val: &str, rhs_val: &str, out: &mut String) -> String {
        if let (Ok(a), Ok(b)) = (lhs_val.parse::<i64>(), rhs_val.parse::<i64>()) {
            let folded = match op {
                BinOp::Add => Some(a.wrapping_add(b)),
                BinOp::Sub => Some(a.wrapping_sub(b)),
                BinOp::Mul => Some(a.wrapping_mul(b)),
                BinOp::Div if b != 0 && !(a == i64::MIN && b == -1) => Some(a / b),
                BinOp::Mod if b != 0 && !(a == i64::MIN && b == -1) => Some(a % b),
                _ => None,
            };
            if let Some(res) = folded {
                return res.to_string();
            }
        }

        let reg = self.next_tmp();
        let instr = match op {
            BinOp::Add => "add",
            BinOp::Sub => "sub",
            BinOp::Mul => "mul",
            BinOp::Div => "sdiv",
            BinOp::Mod => "srem",
            _ => unreachable!(),
        };
        let _ = writeln!(out, "  {reg} = {instr} i64 {lhs_val}, {rhs_val}");
        reg
    }

    fn gen_short_circuit(
        &mut self,
        op: BinOp,
        lhs: &Expr,
        rhs: &Expr,
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        let (lhs_ty, lhs_val) = self.eval_expr(lhs, out)?;
        if lhs_ty != Type::Bool {
            return Err(Diagnostic::new(
                format!(
                    "operator `{}` requires `bool` operands, found `{}`",
                    op.symbol(),
                    lhs_ty.name()
                ),
                span,
            ));
        }

        let slot = self.next_slot("bool.result");
        let _ = writeln!(self.allocas, "  {slot} = alloca i1");

        let initial = if op == BinOp::And { "false" } else { "true" };
        let _ = writeln!(out, "  store i1 {initial}, ptr {slot}");

        let rhs_label = self.fresh_label("bool.rhs");
        let merge_label = self.fresh_label("bool.merge");

        if op == BinOp::And {
            self.emit_cond_br(&lhs_val, &rhs_label, &merge_label, out);
        } else {
            self.emit_cond_br(&lhs_val, &merge_label, &rhs_label, out);
        }

        self.start_block(&rhs_label, out);
        let (rhs_ty, rhs_val) = self.eval_expr(rhs, out)?;
        if rhs_ty != Type::Bool {
            return Err(Diagnostic::new(
                format!(
                    "operator `{}` requires `bool` operands, found `{}`",
                    op.symbol(),
                    rhs_ty.name()
                ),
                rhs.span,
            ));
        }
        let _ = writeln!(out, "  store i1 {rhs_val}, ptr {slot}");
        self.emit_br(&merge_label, out);

        self.start_block(&merge_label, out);
        let result = self.next_tmp();
        let _ = writeln!(out, "  {result} = load i1, ptr {slot}");
        Ok((Type::Bool, result))
    }

    fn gen_call(
        &mut self,
        name: &str,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if name == "print" {
            return self.gen_builtin_print(args, span, out);
        }
        if name == "len" {
            return self.gen_builtin_len(args, span, out);
        }
        if name == "push" {
            return self.gen_builtin_push(args, span, out);
        }
        if name == "pop" {
            return self.gen_builtin_pop(args, span, out);
        }

        if name == "main" {
            return Err(Diagnostic::new("`main` cannot be called directly", span));
        }

        let sig = self
            .sigs
            .get(name)
            .cloned()
            .ok_or_else(|| Diagnostic::new(format!("undefined function `{name}`"), span))?;

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
            let (ty, val) = self.eval_expr_typed(arg, Some(&sig.params[i]), out)?;
            if ty != sig.params[i] {
                return Err(Diagnostic::new(
                    format!(
                        "argument {} of `{name}` expects `{}`, found `{}`",
                        i + 1,
                        sig.params[i].name(),
                        ty.name()
                    ),
                    arg.span,
                ));
            }
            arg_vals.push((ty, val));
        }

        if sig.ret.is_none() {
            let mut call = format!("  call void {}(", mangle(name));
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
        let mut call = format!("  {reg} = call {ret_ir} {}(", mangle(name));
        for (i, (ty, val)) in arg_vals.iter().enumerate() {
            if i > 0 {
                call.push_str(", ");
            }
            let _ = write!(call, "{} {}", ir_type(ty), val);
        }
        call.push_str(")\n");
        out.push_str(&call);

        match sig.ret {
            Some(ty) => Ok((ty, reg)),
            None => Ok((Type::Void, String::new())),
        }
    }

    fn gen_builtin_print(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new("`print` takes exactly one argument", span));
        }

        let (ty, val) = self.eval_expr(&args[0], out)?;
        match ty {
            Type::Str => {
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr {val})"
                );
                Ok((Type::Void, reg))
            }
            Type::Int => {
                let reg = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 {val})"
                );
                Ok((Type::Void, reg))
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
                Ok((Type::Void, reg))
            }
            Type::Array(elem_ty) => {
                if elem_ty.is_array() {
                    return Err(Diagnostic::new(
                        "`print` supports 1D arrays (`[int]`, `[bool]`, `[string]`); print rows in a loop for nested arrays",
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
                let _ = writeln!(self.allocas, "  {idx_slot} = alloca i64");
                let _ = writeln!(out, "  store i64 0, ptr {idx_slot}");

                let cond_lbl = self.fresh_label("print.cond");
                let body_lbl = self.fresh_label("print.body");
                let sep_lbl = self.fresh_label("print.sep");
                let elem_lbl = self.fresh_label("print.elem");
                let end_lbl = self.fresh_label("print.end");

                self.emit_br(&cond_lbl, out);
                self.start_block(&cond_lbl, out);
                let pi = self.next_tmp();
                let _ = writeln!(out, "  {pi} = load i64, ptr {idx_slot}");
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
                let mem_ty = elem_mem_ir_type(&elem_ty);
                let ep = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {ep} = getelementptr inbounds {mem_ty}, ptr {data}, i64 {pi}"
                );
                let elem_val = self.emit_elem_load(&elem_ty, &ep, out);
                match *elem_ty {
                    Type::Int => {
                        let pc = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {pc} = call i32 (ptr, ...) @printf(ptr @.fmt.int.elem, i64 {elem_val})"
                        );
                    }
                    Type::Str => {
                        let pc = self.next_tmp();
                        let _ = writeln!(
                            out,
                            "  {pc} = call i32 (ptr, ...) @printf(ptr @.fmt.str.elem, ptr {elem_val})"
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
                let _ = writeln!(out, "  store i64 {pnext}, ptr {idx_slot}");
                self.emit_br(&cond_lbl, out);

                self.start_block(&end_lbl, out);
                let close = self.next_tmp();
                let _ = writeln!(
                    out,
                    "  {close} = call i32 (ptr, ...) @printf(ptr @.fmt.rbrack)"
                );
                Ok((Type::Void, close))
            }
            Type::Void => Err(Diagnostic::new("`print` cannot print `void`", span)),
        }
    }

    fn gen_builtin_len(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new("`len` takes exactly one argument", span));
        }

        // If `len(xs)` is called on an array with a compile-time constant length,
        // fold straight to that integer without emitting instructions.
        if let ExprKind::Var(name) = &args[0].kind {
            if let Some(KnownLen::Const(c)) = self.lookup_known_len(name) {
                if let Some(entry) = self.lookup_var(name) {
                    if entry.ty.is_array() {
                        return Ok((Type::Int, c.to_string()));
                    }
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
                if let ExprKind::Str(lit) = &args[0].kind {
                    return Ok((Type::Int, (lit.len() as i64).to_string()));
                }
                self.used_strlen = true;
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = call i64 @strlen(ptr {val})");
                Ok((Type::Int, reg))
            }
            other => Err(Diagnostic::new(
                format!(
                    "`len` expects an array or `string`, found `{}`",
                    other.name()
                ),
                args[0].span,
            )),
        }
    }

    fn gen_builtin_push(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 2 {
            return Err(Diagnostic::new(
                "`push` takes two arguments: `push(array, value)`",
                span,
            ));
        }

        let ExprKind::Var(arr_name) = &args[0].kind else {
            return Err(Diagnostic::new(
                "first argument to `push` must be an array variable",
                args[0].span,
            ));
        };

        let entry = self.lookup_var(arr_name).cloned().ok_or_else(|| {
            Diagnostic::new(format!("undefined variable `{arr_name}`"), args[0].span)
        })?;

        if entry.is_param {
            return Err(Diagnostic::new(
                format!(
                    "cannot `push` onto array parameter `{arr_name}` (parameters have fixed length)"
                ),
                args[0].span,
            ));
        }

        let Type::Array(elem_ty) = entry.ty else {
            return Err(Diagnostic::new(
                format!(
                    "first argument to `push` must be an array, found `{}`",
                    entry.ty.name()
                ),
                args[0].span,
            ));
        };

        let VarStorage::Slot(slot_ptr) = entry.storage else {
            return Err(Diagnostic::new(
                format!("internal error: pushed array `{arr_name}` lacked a slot"),
                span,
            ));
        };

        let (val_ty, val_reg) = self.eval_expr_typed(&args[1], Some(&elem_ty), out)?;
        if val_ty != *elem_ty {
            return Err(Diagnostic::new(
                format!(
                    "`push` element type mismatch: array has `[{}]`, found `{}`",
                    elem_ty.name(),
                    val_ty.name()
                ),
                args[1].span,
            ));
        }

        self.used_vec_type = true;
        self.used_realloc = true;

        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
        let cap = self.next_tmp();
        let _ = writeln!(out, "  {cap} = extractvalue %ArchxVec {vec}, 1");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");

        let full = self.next_tmp();
        let _ = writeln!(out, "  {full} = icmp eq i64 {len}, {cap}");
        let grow_lbl = self.fresh_label("push.grow");
        let write_lbl = self.fresh_label("push.write");
        self.emit_cond_br(&full, &grow_lbl, &write_lbl, out);

        self.start_block(&grow_lbl, out);
        let is_zero = self.next_tmp();
        let _ = writeln!(out, "  {is_zero} = icmp eq i64 {cap}, 0");
        let doubled = self.next_tmp();
        let _ = writeln!(out, "  {doubled} = mul i64 {cap}, 2");
        let new_cap = self.next_tmp();
        let _ = writeln!(out, "  {new_cap} = select i1 {is_zero}, i64 4, i64 {doubled}");
        let bytes = self.next_tmp();
        let elem_size = elem_byte_size(&elem_ty);
        let _ = writeln!(out, "  {bytes} = mul i64 {new_cap}, {elem_size}");
        let new_data = self.next_tmp();
        let _ = writeln!(out, "  {new_data} = call ptr @realloc(ptr {data}, i64 {bytes})");
        let grown = self.build_vec_val(&len, &new_cap, &new_data, out);
        let _ = writeln!(out, "  store %ArchxVec {grown}, ptr {slot_ptr}");
        self.emit_br(&write_lbl, out);

        self.start_block(&write_lbl, out);
        let vec2 = self.next_tmp();
        let _ = writeln!(out, "  {vec2} = load %ArchxVec, ptr {slot_ptr}");
        let cur_len = self.next_tmp();
        let _ = writeln!(out, "  {cur_len} = extractvalue %ArchxVec {vec2}, 0");
        let cur_cap = self.next_tmp();
        let _ = writeln!(out, "  {cur_cap} = extractvalue %ArchxVec {vec2}, 1");
        let cur_data = self.next_tmp();
        let _ = writeln!(out, "  {cur_data} = extractvalue %ArchxVec {vec2}, 2");

        let mem_ty = elem_mem_ir_type(&elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {cur_data}, i64 {cur_len}"
        );
        self.emit_elem_store(&elem_ty, &val_reg, &ep, out);

        let next_len = self.next_tmp();
        let _ = writeln!(out, "  {next_len} = add nsw i64 {cur_len}, 1");
        let updated = self.build_vec_val(&next_len, &cur_cap, &cur_data, out);
        let _ = writeln!(out, "  store %ArchxVec {updated}, ptr {slot_ptr}");

        Ok((Type::Void, String::new()))
    }

    fn gen_builtin_pop(
        &mut self,
        args: &[Expr],
        span: Span,
        out: &mut String,
    ) -> Result<(Type, String)> {
        if args.len() != 1 {
            return Err(Diagnostic::new(
                "`pop` takes exactly one argument: `pop(array)`",
                span,
            ));
        }

        let ExprKind::Var(arr_name) = &args[0].kind else {
            return Err(Diagnostic::new(
                "argument to `pop` must be an array variable",
                args[0].span,
            ));
        };

        let entry = self.lookup_var(arr_name).cloned().ok_or_else(|| {
            Diagnostic::new(format!("undefined variable `{arr_name}`"), args[0].span)
        })?;

        if entry.is_param {
            return Err(Diagnostic::new(
                format!(
                    "cannot `pop` from array parameter `{arr_name}` (parameters have fixed length)"
                ),
                args[0].span,
            ));
        }

        let Type::Array(elem_ty) = entry.ty else {
            return Err(Diagnostic::new(
                format!(
                    "argument to `pop` must be an array, found `{}`",
                    entry.ty.name()
                ),
                args[0].span,
            ));
        };

        let VarStorage::Slot(slot_ptr) = entry.storage else {
            return Err(Diagnostic::new(
                format!("internal error: popped array `{arr_name}` lacked a slot"),
                span,
            ));
        };

        self.used_vec_type = true;
        self.used_empty_pop_fail = true;

        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}");
        let len = self.next_tmp();
        let _ = writeln!(out, "  {len} = extractvalue %ArchxVec {vec}, 0");
        let cap = self.next_tmp();
        let _ = writeln!(out, "  {cap} = extractvalue %ArchxVec {vec}, 1");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");

        let is_empty = self.next_tmp();
        let empty_lbl = self.fresh_label("pop.empty");
        let ok_lbl = self.fresh_label("pop.ok");
        let _ = writeln!(out, "  {is_empty} = icmp eq i64 {len}, 0");
        self.emit_cond_br(&is_empty, &empty_lbl, &ok_lbl, out);

        self.start_block(&empty_lbl, out);
        let _ = writeln!(out, "  call void @archx_empty_pop_fail()");
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        let new_len = self.next_tmp();
        let _ = writeln!(out, "  {new_len} = sub nsw i64 {len}, 1");
        let updated = self.build_vec_val(&new_len, &cap, &data, out);
        let _ = writeln!(out, "  store %ArchxVec {updated}, ptr {slot_ptr}");

        let mem_ty = elem_mem_ir_type(&elem_ty);
        let ep = self.next_tmp();
        let _ = writeln!(
            out,
            "  {ep} = getelementptr inbounds {mem_ty}, ptr {data}, i64 {new_len}"
        );
        let res = self.emit_elem_load(&elem_ty, &ep, out);
        Ok((*elem_ty, res))
    }

    // ---------------- Bounds-check analysis & emission -----------------------

    fn infer_known_array_len(&self, value: &Expr) -> Option<KnownLen> {
        match &value.kind {
            ExprKind::ArrayLit(elems) => Some(KnownLen::Const(elems.len() as i64)),
            ExprKind::ArrayRepeat { count, .. } => {
                if let Some(c) = eval_const_int(count) {
                    if c >= 0 {
                        return Some(KnownLen::Const(c));
                    }
                }
                if let ExprKind::Var(n) = &count.kind {
                    if !self.mutated_vars.contains(n) {
                        return Some(KnownLen::Var(n.clone()));
                    }
                }
                None
            }
            _ => None,
        }
    }

    fn derive_for_bound(
        &self,
        var: &str,
        start: &Expr,
        end: &Expr,
        body: &[Stmt],
    ) -> Option<InductionBound> {
        let s = eval_const_int(start)?;
        if s < 0 {
            return None;
        }

        if let Some(limit) = eval_const_int(end) {
            if limit >= 0 {
                return Some(InductionBound {
                    var: var.to_string(),
                    upper: UpperBound::Const(limit),
                });
            }
        }

        if let ExprKind::Var(n) = &end.kind {
            if !self.mutated_vars.contains(n) && !stmts_assign_var(body, n) {
                return Some(InductionBound {
                    var: var.to_string(),
                    upper: UpperBound::Var(n.clone()),
                });
            }
        }

        if let ExprKind::Call { name, args } = &end.kind {
            if name == "len" && args.len() == 1 {
                if let ExprKind::Var(arr_name) = &args[0].kind {
                    if !stmts_mutate_array_len(body, arr_name) {
                        return Some(InductionBound {
                            var: var.to_string(),
                            upper: UpperBound::LenOf(arr_name.clone()),
                        });
                    }
                }
            }
        }

        None
    }

    fn is_bounds_proven_safe(&self, target: &Expr, index: &Expr) -> bool {
        let ExprKind::Var(arr_name) = &target.kind else {
            return false;
        };

        if let Some(idx) = eval_const_int(index) {
            if idx >= 0 {
                if let Some(KnownLen::Const(len)) = self.lookup_known_len(arr_name) {
                    if idx < len {
                        return true;
                    }
                }
            }
        }

        if let ExprKind::Var(iv) = &index.kind {
            for bound in self.loop_bounds.iter().rev() {
                if bound.var == *iv {
                    match &bound.upper {
                        UpperBound::LenOf(bound_arr) if bound_arr == arr_name => return true,
                        UpperBound::Var(bound_n) => {
                            if let Some(KnownLen::Var(arr_n)) = self.lookup_known_len(arr_name) {
                                if arr_n == bound_n {
                                    return true;
                                }
                            }
                        }
                        UpperBound::Const(limit) => {
                            if let Some(KnownLen::Const(len)) = self.lookup_known_len(arr_name) {
                                if *limit <= len {
                                    return true;
                                }
                            }
                        }
                        _ => {}
                    }
                }
            }
        }

        false
    }

    fn emit_bounds_check_if_needed(
        &mut self,
        target: &Expr,
        index: &Expr,
        vec_val: &str,
        idx_val: &str,
        out: &mut String,
    ) -> Result<()> {
        if let Some(idx) = eval_const_int(index) {
            if idx < 0 {
                return Err(Diagnostic::new(
                    format!("array index cannot be negative (`{idx}`)"),
                    index.span,
                ));
            }
            if let ExprKind::Var(arr_name) = &target.kind {
                if let Some(KnownLen::Const(len)) = self.lookup_known_len(arr_name) {
                    if idx >= len {
                        return Err(Diagnostic::new(
                            format!("index {idx} is out of bounds for array of length {len}"),
                            index.span,
                        ));
                    }
                }
            }
        }

        if self.is_bounds_proven_safe(target, index) {
            return Ok(());
        }

        // Single unsigned compare checks both `idx >= 0` and `idx < len`.
        self.used_bounds_fail = true;
        let len_val = self.next_tmp();
        let _ = writeln!(out, "  {len_val} = extractvalue %ArchxVec {vec_val}, 0");
        let ok = self.next_tmp();
        let _ = writeln!(out, "  {ok} = icmp ult i64 {idx_val}, {len_val}");

        let ok_lbl = self.fresh_label("idx.ok");
        let oob_lbl = self.fresh_label("idx.oob");
        self.emit_cond_br(&ok, &ok_lbl, &oob_lbl, out);

        self.start_block(&oob_lbl, out);
        let _ = writeln!(
            out,
            "  call void @archx_bounds_fail(i64 {idx_val}, i64 {len_val})"
        );
        let _ = writeln!(out, "  unreachable");
        self.terminated = true;

        self.start_block(&ok_lbl, out);
        Ok(())
    }

    // ---------------- Array & RAII helpers -----------------------------------

    fn build_vec_val(&mut self, len: &str, cap: &str, data: &str, out: &mut String) -> String {
        let v0 = self.next_tmp();
        let _ = writeln!(out, "  {v0} = insertvalue %ArchxVec undef, i64 {len}, 0");
        let v1 = self.next_tmp();
        let _ = writeln!(out, "  {v1} = insertvalue %ArchxVec {v0}, i64 {cap}, 1");
        let v2 = self.next_tmp();
        let _ = writeln!(out, "  {v2} = insertvalue %ArchxVec {v1}, ptr {data}, 2");
        v2
    }

    fn emit_elem_store(&mut self, elem_ty: &Type, val: &str, elem_ptr: &str, out: &mut String) {
        if *elem_ty == Type::Bool {
            let b = self.next_tmp();
            let _ = writeln!(out, "  {b} = zext i1 {val} to i8");
            let _ = writeln!(out, "  store i8 {b}, ptr {elem_ptr}");
        } else {
            let mem_ty = elem_mem_ir_type(elem_ty);
            let _ = writeln!(out, "  store {mem_ty} {val}, ptr {elem_ptr}");
        }
    }

    fn emit_elem_load(&mut self, elem_ty: &Type, elem_ptr: &str, out: &mut String) -> String {
        if *elem_ty == Type::Bool {
            let raw = self.next_tmp();
            let _ = writeln!(out, "  {raw} = load i8, ptr {elem_ptr}");
            let b = self.next_tmp();
            let _ = writeln!(out, "  {b} = icmp ne i8 {raw}, 0");
            b
        } else {
            let mem_ty = elem_mem_ir_type(elem_ty);
            let reg = self.next_tmp();
            let _ = writeln!(out, "  {reg} = load {mem_ty}, ptr {elem_ptr}");
            reg
        }
    }

    fn emit_free_vec_slot(&mut self, slot_ptr: &str, out: &mut String) {
        self.used_free = true;
        let vec = self.next_tmp();
        let _ = writeln!(out, "  {vec} = load %ArchxVec, ptr {slot_ptr}");
        let data = self.next_tmp();
        let _ = writeln!(out, "  {data} = extractvalue %ArchxVec {vec}, 2");
        let _ = writeln!(out, "  call void @free(ptr {data})");
    }

    fn emit_drops_from_depth(&mut self, from_depth: usize, out: &mut String) {
        let slots: Vec<String> = self.scopes[from_depth..]
            .iter()
            .rev()
            .flat_map(|scope| scope.owned_buffers.iter().rev().cloned())
            .collect();
        for slot in slots {
            self.emit_free_vec_slot(&slot, out);
        }
    }

    fn emit_all_scope_drops(&mut self, out: &mut String) {
        self.emit_drops_from_depth(0, out);
    }

    fn push_scope(&mut self) {
        self.scopes.push(Scope::new());
    }

    fn pop_scope_with_drops(&mut self, out: &mut String) {
        if self.scopes.len() > 1 {
            if !self.terminated {
                let slots: Vec<String> = self
                    .scopes
                    .last()
                    .unwrap()
                    .owned_buffers
                    .iter()
                    .rev()
                    .cloned()
                    .collect();
                for slot in slots {
                    self.emit_free_vec_slot(&slot, out);
                }
            }
            self.scopes.pop();
        }
    }

    fn lookup_var(&self, name: &str) -> Option<&VarEntry> {
        self.scopes.iter().rev().find_map(|scope| scope.vars.get(name))
    }

    fn lookup_known_len(&self, name: &str) -> Option<&KnownLen> {
        self.scopes
            .iter()
            .rev()
            .find_map(|scope| scope.known_lens.get(name))
    }

    fn next_tmp(&mut self) -> String {
        let reg = format!("%t{}", self.tmp);
        self.tmp += 1;
        reg
    }

    fn next_slot(&mut self, prefix: &str) -> String {
        let name = format!("%{prefix}.{}", self.tmp);
        self.tmp += 1;
        name
    }

    fn fresh_label(&mut self, prefix: &str) -> String {
        let label = format!("{prefix}.{}", self.label_counter);
        self.label_counter += 1;
        label
    }

    fn start_block(&mut self, label: &str, out: &mut String) {
        let _ = writeln!(out, "\n{label}:");
        self.terminated = false;
    }

    fn emit_br(&mut self, label: &str, out: &mut String) {
        let _ = writeln!(out, "  br label %{label}");
        self.terminated = true;
    }

    fn emit_cond_br(&mut self, cond: &str, then_label: &str, else_label: &str, out: &mut String) {
        let _ = writeln!(
            out,
            "  br i1 {cond}, label %{then_label}, label %{else_label}"
        );
        self.terminated = true;
    }
}

// ---------------- Static analysis helpers -----------------------------------

fn eval_const_int(expr: &Expr) -> Option<i64> {
    match &expr.kind {
        ExprKind::Int(n) => Some(*n),
        ExprKind::Unary {
            op: UnOp::Neg,
            expr: inner,
        } => eval_const_int(inner).map(|v| v.wrapping_neg()),
        ExprKind::Binary { op, lhs, rhs } => {
            let a = eval_const_int(lhs)?;
            let b = eval_const_int(rhs)?;
            match op {
                BinOp::Add => Some(a.wrapping_add(b)),
                BinOp::Sub => Some(a.wrapping_sub(b)),
                BinOp::Mul => Some(a.wrapping_mul(b)),
                BinOp::Div if b != 0 && !(a == i64::MIN && b == -1) => Some(a / b),
                BinOp::Mod if b != 0 && !(a == i64::MIN && b == -1) => Some(a % b),
                _ => None,
            }
        }
        _ => None,
    }
}

fn collect_mutated_vars(stmts: &[Stmt], out: &mut HashSet<String>) {
    for stmt in stmts {
        match &stmt.kind {
            StmtKind::Let { value, .. } => collect_mutated_in_expr(value, out),
            StmtKind::Assign { target, value, .. } => {
                match target {
                    AssignTarget::Var(name) => {
                        out.insert(name.clone());
                    }
                    AssignTarget::Index { target: t, index } => {
                        collect_mutated_in_expr(t, out);
                        collect_mutated_in_expr(index, out);
                    }
                }
                collect_mutated_in_expr(value, out);
            }
            StmtKind::Return(Some(e)) | StmtKind::Expr(e) => collect_mutated_in_expr(e, out),
            StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => {}
            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                collect_mutated_in_expr(cond, out);
                collect_mutated_vars(then_body, out);
                if let Some(eb) = else_body {
                    collect_mutated_vars(eb, out);
                }
            }
            StmtKind::While { cond, body } => {
                collect_mutated_in_expr(cond, out);
                collect_mutated_vars(body, out);
            }
            StmtKind::For {
                var,
                start,
                end,
                body,
            } => {
                out.insert(var.clone());
                collect_mutated_in_expr(start, out);
                collect_mutated_in_expr(end, out);
                collect_mutated_vars(body, out);
            }
        }
    }
}

fn collect_mutated_in_expr(expr: &Expr, out: &mut HashSet<String>) {
    match &expr.kind {
        ExprKind::Call { name, args } => {
            if (name == "push" || name == "pop") && !args.is_empty() {
                if let ExprKind::Var(arr_name) = &args[0].kind {
                    out.insert(arr_name.clone());
                }
            }
            for arg in args {
                collect_mutated_in_expr(arg, out);
            }
        }
        ExprKind::ArrayLit(elems) => {
            for elem in elems {
                collect_mutated_in_expr(elem, out);
            }
        }
        ExprKind::ArrayRepeat { value, count } => {
            collect_mutated_in_expr(value, out);
            collect_mutated_in_expr(count, out);
        }
        ExprKind::Index { target, index } => {
            collect_mutated_in_expr(target, out);
            collect_mutated_in_expr(index, out);
        }
        ExprKind::Binary { lhs, rhs, .. } => {
            collect_mutated_in_expr(lhs, out);
            collect_mutated_in_expr(rhs, out);
        }
        ExprKind::Unary { expr: inner, .. } => collect_mutated_in_expr(inner, out),
        ExprKind::Int(_) | ExprKind::Bool(_) | ExprKind::Str(_) | ExprKind::Var(_) => {}
    }
}

fn stmts_assign_var(stmts: &[Stmt], target_name: &str) -> bool {
    for stmt in stmts {
        match &stmt.kind {
            StmtKind::Assign {
                target: AssignTarget::Var(name),
                ..
            } if name == target_name => return true,
            StmtKind::If {
                then_body,
                else_body,
                ..
            } => {
                if stmts_assign_var(then_body, target_name) {
                    return true;
                }
                if let Some(eb) = else_body {
                    if stmts_assign_var(eb, target_name) {
                        return true;
                    }
                }
            }
            StmtKind::While { body, .. } | StmtKind::For { body, .. } => {
                if stmts_assign_var(body, target_name) {
                    return true;
                }
            }
            _ => {}
        }
    }
    false
}

fn is_mutated_binding_assigned(stmts: &[Stmt], target_name: &str) -> bool {
    stmts_assign_var(stmts, target_name)
}

fn stmts_mutate_array_len(stmts: &[Stmt], arr_name: &str) -> bool {
    let mut mutated = HashSet::new();
    collect_mutated_vars(stmts, &mut mutated);
    mutated.contains(arr_name)
}

fn var_escapes_in_stmts(
    stmts: &[Stmt],
    var_name: &str,
    sigs: &HashMap<String, FuncSig>,
) -> bool {
    for stmt in stmts {
        match &stmt.kind {
            StmtKind::Let { value, .. } => {
                if expr_escapes_var(value, var_name, sigs) {
                    return true;
                }
            }
            StmtKind::Assign { target, value, .. } => {
                match target {
                    AssignTarget::Var(name) => {
                        if name == var_name {
                            return true;
                        }
                    }
                    AssignTarget::Index { target: t, index } => {
                        let direct_self = matches!(&t.kind, ExprKind::Var(v) if v == var_name);
                        if !direct_self && expr_escapes_var(t, var_name, sigs) {
                            return true;
                        }
                        if expr_escapes_var(index, var_name, sigs) {
                            return true;
                        }
                    }
                }
                if expr_escapes_var(value, var_name, sigs) {
                    return true;
                }
            }
            StmtKind::Return(Some(e)) | StmtKind::Expr(e) => {
                if expr_escapes_var(e, var_name, sigs) {
                    return true;
                }
            }
            StmtKind::Return(None) | StmtKind::Break | StmtKind::Continue => {}
            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                if expr_escapes_var(cond, var_name, sigs)
                    || var_escapes_in_stmts(then_body, var_name, sigs)
                {
                    return true;
                }
                if let Some(eb) = else_body {
                    if var_escapes_in_stmts(eb, var_name, sigs) {
                        return true;
                    }
                }
            }
            StmtKind::While { cond, body } => {
                if expr_escapes_var(cond, var_name, sigs)
                    || var_escapes_in_stmts(body, var_name, sigs)
                {
                    return true;
                }
            }
            StmtKind::For {
                start, end, body, ..
            } => {
                if expr_escapes_var(start, var_name, sigs)
                    || expr_escapes_var(end, var_name, sigs)
                    || var_escapes_in_stmts(body, var_name, sigs)
                {
                    return true;
                }
            }
        }
    }
    false
}

fn expr_escapes_var(expr: &Expr, var_name: &str, sigs: &HashMap<String, FuncSig>) -> bool {
    match &expr.kind {
        ExprKind::Var(v) => v == var_name,
        ExprKind::Index { target, index } => {
            let direct_self = matches!(&target.kind, ExprKind::Var(v) if v == var_name);
            (!direct_self && expr_escapes_var(target, var_name, sigs))
                || expr_escapes_var(index, var_name, sigs)
        }
        ExprKind::Call { name, args } => {
            if (name == "len" || name == "pop" || name == "print") && args.len() == 1 {
                if matches!(&args[0].kind, ExprKind::Var(v) if v == var_name) {
                    return false;
                }
            }
            if name == "push" && args.len() == 2 {
                if matches!(&args[0].kind, ExprKind::Var(v) if v == var_name) {
                    return expr_escapes_var(&args[1], var_name, sigs);
                }
            }
            if let Some(sig) = sigs.get(name) {
                let returns_array = sig.ret.as_ref().map_or(false, |t| t.is_array());
                let takes_nested_array = sig.params.iter().any(|t| {
                    matches!(t, Type::Array(inner) if inner.is_array())
                });
                if !returns_array && !takes_nested_array {
                    return args.iter().any(|arg| {
                        if matches!(&arg.kind, ExprKind::Var(v) if v == var_name) {
                            false
                        } else {
                            expr_escapes_var(arg, var_name, sigs)
                        }
                    });
                }
            }
            args.iter().any(|arg| expr_escapes_var(arg, var_name, sigs))
        }
        ExprKind::ArrayLit(elems) => elems
            .iter()
            .any(|elem| expr_escapes_var(elem, var_name, sigs)),
        ExprKind::ArrayRepeat { value, count } => {
            expr_escapes_var(value, var_name, sigs) || expr_escapes_var(count, var_name, sigs)
        }
        ExprKind::Binary { lhs, rhs, .. } => {
            expr_escapes_var(lhs, var_name, sigs) || expr_escapes_var(rhs, var_name, sigs)
        }
        ExprKind::Unary { expr: inner, .. } => expr_escapes_var(inner, var_name, sigs),
        ExprKind::Int(_) | ExprKind::Bool(_) | ExprKind::Str(_) => false,
    }
}

// ---------------- Formatting & LLVM type helpers ----------------------------

fn mangle(name: &str) -> String {
    if name == "main" {
        "@main".to_string()
    } else {
        format!("@archx_{name}")
    }
}

fn ir_type(ty: &Type) -> &'static str {
    match ty {
        Type::Int => "i64",
        Type::Bool => "i1",
        Type::Str => "ptr",
        Type::Array(_) => "%ArchxVec",
        Type::Void => "void",
    }
}

fn ir_ret_type(ty: Option<&Type>) -> &'static str {
    match ty {
        Some(Type::Int) => "i64",
        Some(Type::Bool) => "i1",
        Some(Type::Str) => "ptr",
        Some(Type::Array(_)) => "%ArchxVec",
        Some(Type::Void) | None => "void",
    }
}

fn elem_mem_ir_type(ty: &Type) -> &'static str {
    match ty {
        Type::Int => "i64",
        Type::Bool => "i8",
        Type::Str => "ptr",
        Type::Array(_) => "%ArchxVec",
        Type::Void => unreachable!("array of void is rejected earlier"),
    }
}

fn elem_byte_size(ty: &Type) -> i64 {
    match ty {
        Type::Int => 8,
        Type::Bool => 1,
        Type::Str => 8,
        Type::Array(_) => 24,
        Type::Void => unreachable!("array of void is rejected earlier"),
    }
}

fn emit_cstr_global(out: &mut String, name: &str, value: &str) {
    let escaped = llvm_bytes(value);
    let len = value.len() + 1;
    let _ = writeln!(
        out,
        "{name} = private unnamed_addr constant [{len} x i8] c\"{escaped}\\00\""
    );
}

fn llvm_bytes(value: &str) -> String {
    let mut out = String::new();
    for byte in value.bytes() {
        match byte {
            b'\\' => out.push_str("\\\\"),
            b'"' => out.push_str("\\22"),
            0x20..=0x7E => out.push(byte as char),
            _ => {
                let _ = write!(out, "\\{byte:02X}");
            }
        }
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::lexer::Lexer;
    use crate::parser::Parser;

    fn ir(src: &str) -> String {
        let tokens = Lexer::new(src).tokenize().unwrap();
        let program = Parser::new(tokens).parse_program().unwrap();
        lower(&program).unwrap()
    }

    fn lower_err(src: &str) -> String {
        let tokens = Lexer::new(src).tokenize().unwrap();
        let program = Parser::new(tokens).parse_program().unwrap();
        lower(&program).unwrap_err().message
    }

    #[test]
    fn hello_world_ir() {
        let out = ir("func main():\n    print(\"Hello, Archx!\")\n");
        assert!(out.contains("define i32 @main()"));
        assert!(out.contains("@printf"));
        assert!(out.contains("Hello, Archx!"));
    }

    #[test]
    fn function_call_ir() {
        let out = ir(
            "func add(a: int, b: int) -> int:\n    return a + b\n\nfunc main():\n    print(add(1, 2))\n",
        );
        assert!(out.contains("define i64 @archx_add(i64 %param.a, i64 %param.b)"));
        assert!(out.contains("call i64 @archx_add"));
    }

    #[test]
    fn immutable_let_and_const_folding_skip_alloca_and_mul() {
        let out = ir("func main():\n    let x = 6 * 7\n    print(x)\n");
        assert!(!out.contains("mul i64"));
        assert!(!out.contains("alloca i64"));
        assert!(out.contains("i64 42"));
    }

    #[test]
    fn if_else_ir() {
        let out = ir(
            "func main():\n    if 1 < 2:\n        print(\"yes\")\n    else:\n        print(\"no\")\n",
        );
        assert!(out.contains("icmp slt i64 1, 2"));
        assert!(out.contains("br i1"));
        assert!(out.contains("if.then"));
        assert!(out.contains("if.else"));
        assert!(out.contains("if.merge"));
    }

    #[test]
    fn short_circuit_ir() {
        let out = ir("func main():\n    let b = true and false\n    print(b)\n");
        assert!(out.contains("alloca i1"));
        assert!(out.contains("store i1 false"));
        assert!(out.contains("br i1"));
        assert!(out.contains("load i1"));
    }

    #[test]
    fn while_loop_ir() {
        let out = ir("func main():\n    let n = 0\n    while n < 5:\n        n = n + 1\n    print(n)\n");
        assert!(out.contains("while.cond"));
        assert!(out.contains("while.body"));
        assert!(out.contains("icmp slt"));
        assert!(out.contains("br label %while.cond"));
    }

    #[test]
    fn for_loop_ir() {
        let out = ir(
            "func main():\n    let total = 0\n    for i in 1..101:\n        total = total + i\n    print(total)\n",
        );
        assert!(out.contains("for.cond"));
        assert!(out.contains("for.step"));
        assert!(out.contains("icmp slt"));
        assert!(out.contains("add i64"));
        assert!(out.contains("add nsw i64"));
    }

    #[test]
    fn break_continue_ir() {
        let out = ir(
            "func main():\n    for i in 0..10:\n        if i == 3:\n            continue\n        if i == 7:\n            break\n",
        );
        assert!(out.contains("br label %for.step"));
        assert!(out.contains("br label %for.end"));
    }

    #[test]
    fn infinite_loop_does_not_demand_a_return() {
        let out = ir(
            "func spin() -> int:\n    while true:\n        print(1)\n\nfunc main():\n    print(1)\n",
        );
        assert!(out.contains("define i64 @archx_spin()"));
        assert!(out.contains("while.end"));
        assert!(out.contains("unreachable"));
    }

    #[test]
    fn both_branches_return_ir() {
        let out = ir(
            "func sign(n: int) -> int:\n    if n > 0:\n        return 1\n    else:\n        return -1\n\nfunc main():\n    print(sign(5))\n",
        );
        assert!(out.contains("ret i64 1"));
        assert!(out.contains("sub i64 0, 1"));
        assert!(out.contains("unreachable"));
    }

    #[test]
    fn bounds_checks_elided_for_proven_range_and_sized_arrays() {
        let out = ir(
            "\
func sum_slice(xs: [int]) -> int:
    let total = 0
    for i in 0..len(xs):
        total += xs[i]
    return total

func combine(n: int) -> int:
    let a = [1; n]
    let b = [0; n]
    for i in 0..n:
        b[i] = a[i] * 3
    return sum_slice(b)

func main():
    let lit = [10, 20, 30]
    print(lit[2] + combine(16))
",
        );
        // Every single array access above (`xs[i]`, `b[i]`, `a[i]`, `lit[2]`)
        // is proven in-bounds at compile time, so no bounds-check helper is emitted!
        assert!(!out.contains("@archx_bounds_fail"));
        // `[0; n]` uses zero-page `@calloc` instead of a manual fill loop:
        assert!(out.contains("@calloc"));
        // Non-escaping local arrays are freed deterministically on scope exit:
        assert!(out.contains("call void @free"));
    }

    #[test]
    fn dynamic_index_emits_single_unsigned_bounds_check() {
        let out = ir(
            "func get_at(xs: [int], k: int) -> int:\n    return xs[k]\n\nfunc main():\n    print(get_at([5, 6, 7], 1))\n",
        );
        assert!(out.contains("icmp ult i64"));
        assert!(out.contains("@archx_bounds_fail"));
    }

    #[test]
    fn rejects_compile_time_out_of_bounds_and_negative_index() {
        let err1 = lower_err("func main():\n    let a = [1, 2, 3]\n    print(a[3])\n");
        assert!(err1.contains("out of bounds"));

        let err2 = lower_err("func main():\n    let a = [1, 2, 3]\n    print(a[-1])\n");
        assert!(err2.contains("negative"));
    }

    #[test]
    fn rejects_non_bool_if_condition() {
        let tokens = Lexer::new("func main():\n    if 1:\n        print(\"x\")\n")
            .tokenize()
            .unwrap();
        let program = Parser::new(tokens).parse_program().unwrap();
        assert!(lower(&program).is_err());
    }

    #[test]
    fn rejects_undefined_variable() {
        let tokens = Lexer::new("func main():\n    print(x)\n").tokenize().unwrap();
        let program = Parser::new(tokens).parse_program().unwrap();
        assert!(lower(&program).is_err());
    }
}
