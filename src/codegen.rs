use crate::ast::{BinOp, Expr, ExprKind, Func, Program, Stmt, StmtKind, Type, UnOp};
use crate::diag::{Diagnostic, Result, Span};
use std::collections::{HashMap, HashSet};
use std::fmt::Write as _;

/// Lowers an Archx program to textual LLVM IR.
///
/// The IR is then compiled by clang (LLVM's compiler driver), which runs the
/// optimizer and emits a native object file. Using text IR keeps the build
/// dependency-free and makes the output inspectable with `--emit-ir`.
///
/// Memory model (milestone 2): every local variable is a stack slot created
/// with `alloca` in the function's entry block. Loads and stores are emitted
/// explicitly; LLVM's `mem2reg`/SROA passes promote them to SSA registers at
/// `-O2`, so the final machine code usually has no stack traffic for locals.
pub fn lower(program: &Program) -> Result<String> {
    let mut sigs = HashMap::new();

    for func in &program.funcs {
        if func.name == "print" {
            return Err(Diagnostic::new(
                "`print` is a builtin and cannot be redefined",
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
            if !seen_params.insert(param.name.as_str()) {
                return Err(Diagnostic::new(
                    format!("duplicate parameter `{}`", param.name),
                    func.span,
                ));
            }
        }

        let ret = match &func.ret {
            Some(Type::Void) | None => None,
            Some(ty) => Some(ty.clone()),
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
        loop_stack: Vec::new(),
        break_count: 0,
        tmp: 0,
        label_counter: 0,
        terminated: false,
        current_ret: None,
        is_main: false,
        allocas: String::new(),
    };

    let mut bodies = String::new();
    for func in &program.funcs {
        codegen.gen_func(func, &mut bodies)?;
    }

    let mut out = String::new();
    out.push_str("; Archx module\n");
    out.push_str("declare i32 @printf(ptr, ...)\n\n");
    out.push_str("@.fmt.str = private unnamed_addr constant [4 x i8] c\"%s\\0A\\00\"\n");
    out.push_str("@.fmt.int = private unnamed_addr constant [6 x i8] c\"%lld\\0A\\00\"\n");
    out.push_str("@.str.true = private unnamed_addr constant [5 x i8] c\"true\\00\"\n");
    out.push_str("@.str.false = private unnamed_addr constant [6 x i8] c\"false\\00\"\n");

    for (i, value) in codegen.strings.values.iter().enumerate() {
        let escaped = llvm_bytes(value);
        let len = value.len() + 1;
        let _ = writeln!(
            out,
            "@.str.{i} = private unnamed_addr constant [{len} x i8] c\"{escaped}\\00\""
        );
    }

    out.push('\n');
    out.push_str(&bodies);
    Ok(out)
}

#[derive(Clone)]
struct FuncSig {
    params: Vec<Type>,
    ret: Option<Type>,
}

struct LoopLabels {
    break_label: String,
    continue_label: String,
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
    /// Lexical scopes; the last element is the innermost block.
    scopes: Vec<HashMap<String, (Type, String)>>,
    /// Innermost-first stack of active loops, for `break`/`continue`.
    loop_stack: Vec<LoopLabels>,
    /// Total number of `break`s emitted so far; used to tell whether a loop's
    /// exit block is reachable when its condition is literally `true`.
    break_count: usize,
    tmp: usize,
    label_counter: usize,
    terminated: bool,
    current_ret: Option<Type>,
    is_main: bool,
    /// All `alloca` instructions, hoisted into the entry block.
    allocas: String,
}

impl Codegen {
    fn gen_func(&mut self, func: &Func, out: &mut String) -> Result<()> {
        self.scopes = vec![HashMap::new()];
        self.loop_stack.clear();
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
        header.push(')');

        // Parameter spill slots live in the entry block.
        for param in &func.params {
            let ty = ir_type(&param.ty);
            let ptr = format!("%param.{}.addr", param.name);
            let _ = writeln!(self.allocas, "  {ptr} = alloca {ty}");
            self.scopes[0].insert(param.name.clone(), (param.ty.clone(), ptr));
        }

        let mut body = String::new();
        for param in &func.params {
            let ty = ir_type(&param.ty);
            let ptr = format!("%param.{}.addr", param.name);
            let _ = writeln!(body, "  store {ty} %param.{}, ptr {ptr}", param.name);
        }

        for stmt in &func.body {
            self.gen_stmt(stmt, &mut body)?;
        }

        if !self.terminated {
            if self.is_main {
                body.push_str("  ret i32 0\n");
            } else if self.current_ret.is_none() {
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

    fn gen_stmt(&mut self, stmt: &Stmt, out: &mut String) -> Result<()> {
        // If the previous statement terminated this block, any code after it
        // is unreachable. Put it in a fresh (unreachable) block so the IR stays
        // valid instead of silently dropping it.
        if self.terminated {
            let dead = self.fresh_label("dead");
            self.start_block(&dead, out);
        }

        match &stmt.kind {
            StmtKind::Let { name, value } => {
                if self.lookup_var(name).is_some() {
                    return Err(Diagnostic::new(
                        format!("variable `{name}` is already defined in this scope"),
                        stmt.span,
                    ));
                }

                let (ty, val) = self.eval_expr(value, out)?;
                if ty == Type::Void {
                    return Err(Diagnostic::new(
                        "cannot store a `void` value in a variable",
                        stmt.span,
                    ));
                }

                let ptr = self.next_slot(&format!("var.{name}"));
                let ty_ir = ir_type(&ty);
                let _ = writeln!(self.allocas, "  {ptr} = alloca {ty_ir}");
                let _ = writeln!(out, "  store {ty_ir} {val}, ptr {ptr}");
                self.scopes
                    .last_mut()
                    .unwrap()
                    .insert(name.clone(), (ty, ptr));
                Ok(())
            }

            StmtKind::Return(value) => {
                if let Some(expr) = value {
                    let (ty, val) = self.eval_expr(expr, out)?;

                    if self.is_main {
                        if ty != Type::Int {
                            return Err(Diagnostic::new(
                                "`main` must return an `int`",
                                stmt.span,
                            ));
                        }
                        let truncated = self.next_tmp();
                        let _ = writeln!(out, "  {truncated} = trunc i64 {val} to i32");
                        let _ = writeln!(out, "  ret i32 {truncated}");
                        self.terminated = true;
                        return Ok(());
                    }

                    match self.current_ret.clone() {
                        Some(expected) if expected == ty => {
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
                    out.push_str("  ret i32 0\n");
                } else {
                    match self.current_ret {
                        Some(_) => {
                            return Err(Diagnostic::new(
                                "this function must return a value",
                                stmt.span,
                            ));
                        }
                        None => out.push_str("  ret void\n"),
                    }
                }

                self.terminated = true;
                Ok(())
            }

            StmtKind::Expr(expr) => {
                self.eval_expr(expr, out)?;
                Ok(())
            }

            StmtKind::Assign { name, value } => {
                let (ty, ptr) = self.lookup_var(name).cloned().ok_or_else(|| {
                    Diagnostic::new(format!("undefined variable `{name}`"), stmt.span)
                })?;
                let (val_ty, val) = self.eval_expr(value, out)?;
                if val_ty != ty {
                    return Err(Diagnostic::new(
                        format!(
                            "cannot assign `{}` to variable `{}` of type `{}`",
                            val_ty.name(),
                            name,
                            ty.name()
                        ),
                        stmt.span,
                    ));
                }
                let _ = writeln!(out, "  store {} {}, ptr {}", ir_type(&ty), val, ptr);
                Ok(())
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
                self.push_scope();
                let breaks_before = self.break_count;
                self.loop_stack.push(LoopLabels {
                    break_label: end_label.clone(),
                    continue_label: cond_label.clone(),
                });
                for stmt in body {
                    self.gen_stmt(stmt, out)?;
                }
                self.loop_stack.pop();
                self.pop_scope();
                if !self.terminated {
                    self.emit_br(&cond_label, out);
                }

                // `while true:` with no `break` never falls through, so the
                // code after it is unreachable (keeps return-path checking
                // honest instead of demanding a dead `return`).
                let always_true = matches!(&cond.kind, ExprKind::Bool(true));
                let had_break = self.break_count > breaks_before;

                self.start_block(&end_label, out);
                if always_true && !had_break {
                    // Nothing can reach this block, but LLVM still requires
                    // every block to end in a terminator.
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
                self.push_scope();
                self.scopes
                    .last_mut()
                    .unwrap()
                    .insert(var.clone(), (Type::Int, slot.clone()));
                self.loop_stack.push(LoopLabels {
                    break_label: end_label.clone(),
                    continue_label: step_label.clone(),
                });
                for stmt in body {
                    self.gen_stmt(stmt, out)?;
                }
                self.loop_stack.pop();
                self.pop_scope();
                if !self.terminated {
                    self.emit_br(&step_label, out);
                }

                self.start_block(&step_label, out);
                let i2 = self.next_tmp();
                let _ = writeln!(out, "  {i2} = load i64, ptr {slot}");
                let next = self.next_tmp();
                let _ = writeln!(out, "  {next} = add i64 {i2}, 1");
                let _ = writeln!(out, "  store i64 {next}, ptr {slot}");
                self.emit_br(&cond_label, out);

                self.start_block(&end_label, out);
                Ok(())
            }

            StmtKind::Break => {
                let label = self
                    .loop_stack
                    .last()
                    .map(|labels| labels.break_label.clone())
                    .ok_or_else(|| {
                        Diagnostic::new("`break` is only allowed inside a loop", stmt.span)
                    })?;
                self.break_count += 1;
                self.emit_br(&label, out);
                Ok(())
            }

            StmtKind::Continue => {
                let label = self
                    .loop_stack
                    .last()
                    .map(|labels| labels.continue_label.clone())
                    .ok_or_else(|| {
                        Diagnostic::new("`continue` is only allowed inside a loop", stmt.span)
                    })?;
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
                for stmt in then_body {
                    self.gen_stmt(stmt, out)?;
                }
                self.pop_scope();
                let then_terminated = self.terminated;
                if !then_terminated {
                    self.emit_br(&merge_label, out);
                }

                self.start_block(&else_label, out);
                if let Some(body) = else_body {
                    self.push_scope();
                    for stmt in body {
                        self.gen_stmt(stmt, out)?;
                    }
                    self.pop_scope();
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

    fn eval_expr(&mut self, expr: &Expr, out: &mut String) -> Result<(Type, String)> {
        match &expr.kind {
            ExprKind::Int(value) => Ok((Type::Int, value.to_string())),

            ExprKind::Bool(value) => Ok((Type::Bool, value.to_string())),

            ExprKind::Str(value) => {
                let label = self.strings.intern(value);
                Ok((Type::Str, label))
            }

            ExprKind::Var(name) => {
                let (ty, ptr) = self
                    .lookup_var(name)
                    .cloned()
                    .ok_or_else(|| Diagnostic::new(format!("undefined variable `{name}`"), expr.span))?;
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = load {}, ptr {ptr}", ir_type(&ty));
                Ok((ty, reg))
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
                Ok((Type::Int, reg))
            }

            BinOp::Eq | BinOp::Ne => {
                if lhs_ty != rhs_ty || (lhs_ty != Type::Int && lhs_ty != Type::Bool) {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}` requires two `int` or two `bool` operands, found `{}` and `{}`",
                            op.symbol(),
                            lhs_ty.name(),
                            rhs_ty.name()
                        ),
                        span,
                    ));
                }

                let reg = self.next_tmp();
                let pred = match op {
                    BinOp::Eq => "eq",
                    BinOp::Ne => "ne",
                    _ => unreachable!(),
                };
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

    /// Short-circuit `and`/`or`, implemented with basic blocks and a stack
    /// slot so no phi nodes are needed. LLVM promotes the slot to a register.
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
                format!("operator `{}` requires `bool` operands, found `{}`", op.symbol(), lhs_ty.name()),
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
                format!("operator `{}` requires `bool` operands, found `{}`", op.symbol(), rhs_ty.name()),
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
            if args.len() != 1 {
                return Err(Diagnostic::new(
                    "`print` takes exactly one argument",
                    span,
                ));
            }

            let (ty, val) = self.eval_expr(&args[0], out)?;
            let reg = self.next_tmp();

            match ty {
                Type::Str => {
                    let _ = writeln!(
                        out,
                        "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr {val})"
                    );
                }
                Type::Int => {
                    let _ = writeln!(
                        out,
                        "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 {val})"
                    );
                }
                Type::Bool => {
                    let selected = self.next_tmp();
                    let _ = writeln!(
                        out,
                        "  {selected} = select i1 {val}, ptr @.str.true, ptr @.str.false"
                    );
                    let _ = writeln!(
                        out,
                        "  {reg} = call i32 (ptr, ...) @printf(ptr @.fmt.str, ptr {selected})"
                    );
                }
                Type::Void => {
                    return Err(Diagnostic::new("`print` cannot print `void`", span));
                }
            }

            return Ok((Type::Void, reg));
        }

        if name == "main" {
            return Err(Diagnostic::new("`main` cannot be called directly", span));
        }

        let sig = self.sigs.get(name).cloned().ok_or_else(|| {
            Diagnostic::new(format!("undefined function `{name}`"), span)
        })?;

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
            let (ty, val) = self.eval_expr(arg, out)?;
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

    fn push_scope(&mut self) {
        self.scopes.push(HashMap::new());
    }

    fn pop_scope(&mut self) {
        if self.scopes.len() > 1 {
            self.scopes.pop();
        }
    }

    fn lookup_var(&self, name: &str) -> Option<&(Type, String)> {
        self.scopes.iter().rev().find_map(|scope| scope.get(name))
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
        Type::Void => "void",
    }
}

fn ir_ret_type(ty: Option<&Type>) -> &'static str {
    match ty {
        Some(Type::Int) => "i64",
        Some(Type::Bool) => "i1",
        Some(Type::Str) => "ptr",
        Some(Type::Void) | None => "void",
    }
}

/// Encodes a string as the contents of an LLVM `c"..."` constant.
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
        // `while true:` with no `break` never falls through, so a function that
        // promises an `int` is still exhaustive.
        let out = ir("func spin() -> int:\n    while true:\n        print(1)\n");
        assert!(out.contains("unreachable"));
        assert!(out.contains("while.end"));
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
