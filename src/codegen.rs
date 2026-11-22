use crate::ast::{BinOp, Expr, ExprKind, Func, Program, Stmt, StmtKind, Type};
use crate::diag::{Diagnostic, Result, Span};
use std::collections::{HashMap, HashSet};
use std::fmt::Write as _;

/// Lowers an Archx program to textual LLVM IR.
///
/// The IR is then compiled by clang (LLVM's compiler driver), which runs the
/// optimizer and emits a native object file. Using text IR keeps the build
/// dependency-free and makes the output inspectable with `--emit-ir`.
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
        vars: HashMap::new(),
        tmp: 0,
        terminated: false,
        current_ret: None,
        is_main: false,
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
    vars: HashMap<String, (Type, String)>,
    tmp: usize,
    terminated: bool,
    current_ret: Option<Type>,
    is_main: bool,
}

impl Codegen {
    fn gen_func(&mut self, func: &Func, out: &mut String) -> Result<()> {
        self.vars.clear();
        self.terminated = false;
        self.is_main = func.name == "main";

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

        let _ = write!(out, "define {} {}(", ir_ret, mangle(&func.name));
        for (i, param) in func.params.iter().enumerate() {
            if i > 0 {
                out.push_str(", ");
            }
            let _ = write!(out, "{} %param.{}", ir_type(&param.ty), param.name);
        }
        out.push_str(") {\n");
        out.push_str("entry:\n");

        // Spill parameters to stack slots so every variable is handled the
        // same way. LLVM's optimizer promotes these back to registers.
        for param in &func.params {
            let ty = ir_type(&param.ty);
            let ptr = format!("%param.{}.addr", param.name);
            let _ = writeln!(out, "  {ptr} = alloca {ty}");
            let _ = writeln!(out, "  store {ty} %param.{}, ptr {ptr}", param.name);
            self.vars
                .insert(param.name.clone(), (param.ty.clone(), ptr));
        }

        for stmt in &func.body {
            self.gen_stmt(stmt, out)?;
        }

        if !self.terminated {
            if self.is_main {
                out.push_str("  ret i32 0\n");
            } else if self.current_ret.is_none() {
                out.push_str("  ret void\n");
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

        out.push_str("}\n\n");
        Ok(())
    }

    fn gen_stmt(&mut self, stmt: &Stmt, out: &mut String) -> Result<()> {
        match &stmt.kind {
            StmtKind::Let { name, value } => {
                if self.vars.contains_key(name) {
                    return Err(Diagnostic::new(
                        format!("variable `{name}` is already defined in this function"),
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

                let ptr = format!("%var.{}.{}", name, self.tmp);
                self.tmp += 1;
                let ty_ir = ir_type(&ty);
                let _ = writeln!(out, "  {ptr} = alloca {ty_ir}");
                let _ = writeln!(out, "  store {ty_ir} {val}, ptr {ptr}");
                self.vars.insert(name.clone(), (ty, ptr));
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
        }
    }

    fn eval_expr(&mut self, expr: &Expr, out: &mut String) -> Result<(Type, String)> {
        match &expr.kind {
            ExprKind::Int(value) => Ok((Type::Int, value.to_string())),

            ExprKind::Str(value) => {
                let label = self.strings.intern(value);
                Ok((Type::Str, label))
            }

            ExprKind::Var(name) => {
                let (ty, ptr) = self.vars.get(name).cloned().ok_or_else(|| {
                    Diagnostic::new(format!("undefined variable `{name}`"), expr.span)
                })?;
                let reg = self.next_tmp();
                let _ = writeln!(out, "  {reg} = load {}, ptr {ptr}", ir_type(&ty));
                Ok((ty, reg))
            }

            ExprKind::Unary { op: _, expr: inner } => {
                let (ty, val) = self.eval_expr(inner, out)?;
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

            ExprKind::Binary { op, lhs, rhs } => {
                let (lhs_ty, lhs_val) = self.eval_expr(lhs, out)?;
                let (rhs_ty, rhs_val) = self.eval_expr(rhs, out)?;

                if lhs_ty != Type::Int || rhs_ty != Type::Int {
                    return Err(Diagnostic::new(
                        format!(
                            "operator `{}` requires `int` operands, found `{}` and `{}`",
                            op.symbol(),
                            lhs_ty.name(),
                            rhs_ty.name()
                        ),
                        expr.span,
                    ));
                }

                let reg = self.next_tmp();
                let instr = match op {
                    BinOp::Add => "add",
                    BinOp::Sub => "sub",
                    BinOp::Mul => "mul",
                    BinOp::Div => "sdiv",
                };
                let _ = writeln!(out, "  {reg} = {instr} i64 {lhs_val}, {rhs_val}");
                Ok((Type::Int, reg))
            }

            ExprKind::Call { name, args } => self.gen_call(name, args, expr.span, out),
        }
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

    fn next_tmp(&mut self) -> String {
        let reg = format!("%t{}", self.tmp);
        self.tmp += 1;
        reg
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
        Type::Str => "ptr",
        Type::Void => "void",
    }
}

fn ir_ret_type(ty: Option<&Type>) -> &'static str {
    match ty {
        Some(Type::Int) => "i64",
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
    fn rejects_undefined_variable() {
        let tokens = Lexer::new("func main():\n    print(x)\n").tokenize().unwrap();
        let program = Parser::new(tokens).parse_program().unwrap();
        assert!(lower(&program).is_err());
    }
}
