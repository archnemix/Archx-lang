//! Bounded-depth recursive-descent parser turning token streams into the Archx AST.
//! Supports 1:1 Python syntax (`def`, `class`, `range`, `enumerate`, `f"..."`, `with region:`,
//! type-optional assignments, `//`, `**`, `in`, ternary `a if c else b`, top-level scripts)
//! alongside classic Archx syntax (`func`, `struct`, `let`, `a..b step k`, `[val; n]`).

use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};
use crate::token::{Token, TokenKind};

const MAX_NESTING: usize = 128;

pub struct Parser {
    tokens: Vec<Token>,
    pos: usize,
    depth: usize,
}

impl Parser {
    pub fn new(tokens: Vec<Token>) -> Self {
        Self {
            tokens,
            pos: 0,
            depth: 0,
        }
    }

    pub fn parse_program(&mut self) -> Result<Program> {
        let mut structs = Vec::new();
        let mut enums = Vec::new();
        let mut funcs = Vec::new();
        let mut top_stmts = Vec::new();
        let mut consts: Vec<GlobalConst> = Vec::new();
        let mut module_entries: Vec<ModuleEntry> = Vec::new();
        self.skip_newlines();

        while !self.check(&TokenKind::Eof) {
            if self.check(&TokenKind::Struct) {
                structs.push(self.parse_struct()?);
            } else if matches!(&self.peek().kind, TokenKind::Ident(k) if k == "enum")
                && matches!(&self.peek_at(1).kind, TokenKind::Ident(_))
                && self.peek_at(2).kind == TokenKind::Colon
            {
                enums.push(self.parse_enum()?);
            } else if self.check(&TokenKind::Func) {
                funcs.push(self.parse_func()?);
            } else {
                let mut stmt = self.parse_stmt()?;
                // Strip `global` declarations now that they are collected per function.
                if let StmtKind::Global { .. } = stmt.kind {
                    stmt.kind = StmtKind::Pass;
                }
                let binding = script_binding_kind(&stmt);
                match binding {
                    Some((name, ty, value, span)) => {
                        module_entries.push(ModuleEntry::Const(GlobalConst {
                            name,
                            ty,
                            value,
                            span,
                        }));
                    }
                    None => module_entries.push(ModuleEntry::Stmt(stmt)),
                }
            }
            self.skip_newlines();
        }

        // A module-level literal becomes a compile-time constant when it can be evaluated in
        // place: it appears before the first script statement, nothing later rebinds the name, and
        // it has no second literal declaration. Everything else keeps its in-order runtime value
        // as part of the script `main` (module statements and their bindings share source order).
        for (idx, entry) in module_entries.iter().enumerate() {
            let ModuleEntry::Const(c) = entry else { continue };
            let before_first_stmt = module_entries[..idx]
                .iter()
                .all(|e| matches!(e, ModuleEntry::Const(_)));
            let rebound_later = module_entries[idx + 1..].iter().any(|e| match e {
                ModuleEntry::Const(o) => o.name == c.name,
                ModuleEntry::Stmt(st) => stmt_binds_name(st, &c.name),
            });
            // A constant lambda initializer is a first-class value, not a literal the module can
            // fold, so it stays part of the script and its captures resolve as before.
            let is_lambda = matches!(c.value.kind, ExprKind::Lambda { .. });
            if before_first_stmt && !rebound_later && !is_lambda {
                consts.push(c.clone());
            }
        }

        // Script statements keep their source order. A folded constant is removed; a binding that
        // had to keep its in-order runtime value is re-materialized as a statement, and only the
        // *first* binding of a name introduces it (later ones are plain assignments).
        let mut bound = std::collections::HashSet::new();
        for e in module_entries {
            match e {
                ModuleEntry::Stmt(st) => {
                    if let StmtKind::Let { name, .. }
                    | StmtKind::Assign {
                        target: AssignTarget::Var(name),
                        ..
                    } = &st.kind
                    {
                        bound.insert(name.clone());
                    }
                    top_stmts.push(st);
                }
                ModuleEntry::Const(c) => {
                    if consts.iter().any(|f| f.name == c.name) {
                        continue;
                    }
                    let span = c.span;
                    let kind = if bound.insert(c.name.clone()) {
                        StmtKind::Let {
                            name: c.name,
                            ty: c.ty,
                            value: c.value,
                        }
                    } else {
                        StmtKind::Assign {
                            target: AssignTarget::Var(c.name),
                            op: None,
                            value: c.value,
                        }
                    };
                    top_stmts.push(Stmt { kind, span });
                }
            }
        }

        if !top_stmts.is_empty() {
            let script_span = top_stmts[0].span;
            if funcs.iter().any(|f| f.name == "main") {
                for f in &mut funcs {
                    if f.name == "main" {
                        f.name = "__archx_user_main".to_string();
                    }
                    rewrite_main_calls_in_stmts(&mut f.body);
                }
                for s in &mut structs {
                    for m in &mut s.methods {
                        rewrite_main_calls_in_stmts(&mut m.body);
                    }
                }
                rewrite_main_calls_in_stmts(&mut top_stmts);
            }
            funcs.push(Func {
                name: "main".to_string(),
                type_params: Vec::new(),
                params: Vec::new(),
                ret: None,
                body: top_stmts,
                globals: Vec::new(),
                span: script_span,
            });
        }

        Ok(Program {
            // The driver fills this in after parsing (it owns the CLI override and the file name);
            // the parser has no view of either.
            dialect: crate::dialect::DialectSpec {
                dialect: crate::dialect::Dialect::Native,
                version: crate::dialect::DIRECTIVE_VERSION,
                source: crate::dialect::DialectSource::Directive,
            },
            structs,
            enums,
            funcs,
            consts,
        })
    }

    fn parse_enum(&mut self) -> Result<EnumDef> {
        let span = self.peek().span;
        self.bump(); // `enum`
        let name = self.expect_ident("an enum name")?;
        self.expect(TokenKind::Colon, "`:`")?;
        self.expect(TokenKind::Newline, "a newline after enum header")?;
        self.expect(TokenKind::Indent, "an indented enum body")?;

        let mut variants = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::Dedent) || self.check(&TokenKind::Eof) {
                break;
            }
            if self.check(&TokenKind::Pass) {
                self.bump();
                self.expect(TokenKind::Newline, "a newline after `pass`")?;
                continue;
            }
            let vspan = self.peek().span;
            let vname = self.expect_ident("an enum variant name")?;
            let mut fields = Vec::new();
            if self.check(&TokenKind::LParen) {
                self.bump();
                while !self.check(&TokenKind::RParen) {
                    let fty = if matches!(&self.peek().kind, TokenKind::Ident(_))
                        && self.peek_at(1).kind == TokenKind::Colon
                    {
                        self.bump(); // field label
                        self.bump(); // `:`
                        self.parse_type()?
                    } else {
                        self.parse_type()?
                    };
                    if fty == Type::Void {
                        return Err(Diagnostic::new(
                            "enum variant payload field cannot have type `None` / `void`",
                            vspan,
                        ));
                    }
                    fields.push(fty);
                    if self.check(&TokenKind::Comma) {
                        self.bump();
                    } else {
                        break;
                    }
                }
                self.expect(TokenKind::RParen, "`)`")?;
            }
            self.expect(TokenKind::Newline, "a newline after enum variant")?;
            variants.push(EnumVariant {
                name: vname,
                fields,
                span: vspan,
            });
        }

        self.expect(TokenKind::Dedent, "the end of the enum body")?;
        if variants.is_empty() {
            return Err(Diagnostic::new("enum must have at least one variant", span));
        }
        Ok(EnumDef {
            name,
            variants,
            span,
        })
    }

    fn parse_type_params(&mut self) -> Result<Vec<String>> {
        if !self.check(&TokenKind::LBracket) {
            return Ok(Vec::new());
        }
        let span = self.peek().span;
        self.bump(); // `[`
        let mut params = Vec::new();
        while !self.check(&TokenKind::RBracket) {
            let tp = self.expect_ident("a type parameter name")?;
            if params.contains(&tp) {
                return Err(Diagnostic::new(
                    format!("duplicate type parameter `{tp}`"),
                    span,
                ));
            }
            // Optional PEP 695 bound: `def f[T: int](...)` or `def f[T: (int, float)](...)`
            if self.check(&TokenKind::Colon) {
                self.bump();
                if self.check(&TokenKind::LParen) {
                    self.bump();
                    while !self.check(&TokenKind::RParen) {
                        let _ = self.parse_type()?;
                        if self.check(&TokenKind::Comma) {
                            self.bump();
                        } else {
                            break;
                        }
                    }
                    self.expect(TokenKind::RParen, "`)`")?;
                } else {
                    let _ = self.parse_type()?;
                }
            }
            params.push(tp);
            if self.check(&TokenKind::Comma) {
                self.bump();
            } else {
                break;
            }
        }
        self.expect(TokenKind::RBracket, "`]` after type parameters")?;
        if params.is_empty() {
            return Err(Diagnostic::new(
                "type parameter list `[...]` cannot be empty",
                span,
            ));
        }
        Ok(params)
    }

    fn parse_struct(&mut self) -> Result<StructDef> {
        let span = self.peek().span;
        self.expect(TokenKind::Struct, "`class` or `struct`")?;
        let name = self.expect_ident("a class/struct name")?;
        let type_params = self.parse_type_params()?;
        self.expect(TokenKind::Colon, "`:`")?;
        self.expect(TokenKind::Newline, "a newline after class/struct header")?;
        self.expect(TokenKind::Indent, "an indented class/struct body")?;

        let mut fields = Vec::new();
        let mut methods = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::Dedent) || self.check(&TokenKind::Eof) {
                break;
            }
            if self.check(&TokenKind::Pass) {
                self.bump();
                self.expect(TokenKind::Newline, "a newline after `pass`")?;
                continue;
            }
            if self.check(&TokenKind::Func) {
                methods.push(self.parse_method(&name)?);
                continue;
            }
            let field_name = self.expect_ident("a field name or `def` method")?;
            self.expect(TokenKind::Colon, "`:`")?;
            let ty = self.parse_type()?;
            self.expect(TokenKind::Newline, "a newline after field declaration")?;
            fields.push(Param {
                name: field_name,
                ty,
                default: None,
            });
        }

        self.expect(TokenKind::Dedent, "the end of the class/struct body")?;
        if fields.is_empty() {
            if let Some(init_m) = methods.iter().find(|m| m.name == "__init__") {
                fields = infer_fields_from_init(init_m);
            }
        }
        if fields.is_empty() {
            return Err(Diagnostic::new(
                "class/struct must have at least one field",
                span,
            ));
        }

        Ok(StructDef {
            name,
            type_params,
            fields,
            methods,
            span,
        })
    }

    fn parse_method(&mut self, struct_name: &str) -> Result<Func> {
        let span = self.peek().span;
        self.expect(TokenKind::Func, "`def`")?;
        let name = self.expect_ident("a method name")?;
        let type_params = self.parse_type_params()?;
        self.expect(TokenKind::LParen, "`(`")?;

        let mut params = Vec::new();
        if self.check(&TokenKind::RParen) {
            return Err(Diagnostic::new(
                format!("method `{name}` on `{struct_name}` must take `self` as its first parameter"),
                span,
            ));
        }

        let first_name = self.expect_ident("`self`")?;
        if first_name != "self" {
            return Err(Diagnostic::new(
                format!("method `{name}` on `{struct_name}` must name its first parameter `self`"),
                span,
            ));
        }
        let self_ty = if self.check(&TokenKind::Colon) {
            self.bump();
            let t = self.parse_type()?;
            let valid_self = t == Type::Struct(struct_name.to_string())
                || matches!(&t, Type::GenericInst { name: gn, .. } if gn == struct_name);
            if !valid_self {
                return Err(Diagnostic::new(
                    format!("`self` in `{struct_name}.{name}` must have type `{struct_name}`"),
                    span,
                ));
            }
            Type::Struct(struct_name.to_string())
        } else {
            Type::Struct(struct_name.to_string())
        };
        params.push(Param {
            name: "self".to_string(),
            ty: self_ty,
            default: None,
        });

        while self.check(&TokenKind::Comma) {
            self.bump();
            if self.check(&TokenKind::RParen) {
                break;
            }
            let param_name = self.expect_ident("a parameter name")?;
            let ty = if self.check(&TokenKind::Colon) {
                self.bump();
                self.parse_type()?
            } else {
                Type::Any
            };
            // `param: T = default`
            let default = if self.check(&TokenKind::Eq) {
                self.bump();
                Some(self.parse_expr()?)
            } else {
                None
            };
            params.push(Param {
                name: param_name,
                ty,
                default,
            });
        }

        self.expect(TokenKind::RParen, "`)`")?;

        let explicit_arrow = self.check(&TokenKind::Arrow);
        let mut ret = if explicit_arrow {
            self.bump();
            Some(self.parse_type()?)
        } else {
            None
        };

        self.expect(TokenKind::Colon, "`:`")?;
        self.expect(TokenKind::Newline, "a newline after method signature")?;
        self.expect(TokenKind::Indent, "an indented method body")?;
        let body = self.parse_block_body()?;
        self.expect(TokenKind::Dedent, "the end of the method body")?;
        if body.is_empty() {
            return Err(Diagnostic::new("method body cannot be empty", span));
        }
        if !explicit_arrow && stmts_have_value_return(&body) {
            ret = Some(Type::Any);
        }

        let globals = collect_global_decls(&body);
        Ok(Func {
            name,
            type_params,
            params,
            ret,
            body,
            globals,
            span,
        })
    }

    fn parse_func(&mut self) -> Result<Func> {
        let span = self.peek().span;

        self.expect(TokenKind::Func, "`def` or `func`")?;
        let name = self.expect_ident("a function name")?;
        let type_params = self.parse_type_params()?;
        self.expect(TokenKind::LParen, "`(`")?;

        let mut params = Vec::new();
        if !self.check(&TokenKind::RParen) {
            loop {
                if self.check(&TokenKind::RParen) {
                    break;
                }
                let param_name = self.expect_ident("a parameter name")?;
                let ty = if self.check(&TokenKind::Colon) {
                    self.bump();
                    self.parse_type()?
                } else {
                    Type::Any
                };
                // `def f(a: int, b: int = 3)` — an optional trailing default.
                let default = if self.check(&TokenKind::Eq) {
                    self.bump();
                    Some(self.parse_expr()?)
                } else {
                    None
                };
                params.push(Param {
                    name: param_name,
                    ty,
                    default,
                });

                if self.check(&TokenKind::Comma) {
                    self.bump();
                } else {
                    break;
                }
            }
        }

        self.expect(TokenKind::RParen, "`)`")?;

        let explicit_arrow = self.check(&TokenKind::Arrow);
        let mut ret = if explicit_arrow {
            self.bump();
            Some(self.parse_type()?)
        } else {
            None
        };

        self.expect(TokenKind::Colon, "`:`")?;
        self.expect(
            TokenKind::Newline,
            "a newline after the function signature",
        )?;
        self.expect(TokenKind::Indent, "an indented function body")?;

        let body = self.parse_block_body()?;
        self.expect(TokenKind::Dedent, "the end of the function body")?;

        if body.is_empty() {
            return Err(Diagnostic::new("function body cannot be empty", span));
        }
        if !explicit_arrow && name != "main" && stmts_have_value_return(&body) {
            ret = Some(Type::Any);
        }

        let globals = collect_global_decls(&body);
        Ok(Func {
            name,
            type_params,
            params,
            ret,
            body,
            globals,
            span,
        })
    }

    fn parse_type(&mut self) -> Result<Type> {
        self.enter_depth()?;
        let res = self.parse_type_union();
        self.depth -= 1;
        res
    }

    fn parse_type_union(&mut self) -> Result<Type> {
        let mut ty = self.parse_type_inner()?;
        while self.check(&TokenKind::Pipe) {
            self.bump();
            let rhs = self.parse_type_inner()?;
            ty = match (ty, rhs) {
                (Type::Void, other) | (other, Type::Void) => match other {
                    Type::Void => Type::Void,
                    Type::Optional(inner) => Type::Optional(inner),
                    Type::Any => Type::Any,
                    concrete => Type::Optional(Box::new(concrete)),
                },
                (a, b) if a == b => a,
                _ => Type::Any,
            };
        }
        Ok(ty)
    }

    fn parse_type_inner(&mut self) -> Result<Type> {
        let token = self.peek().clone();
        match &token.kind {
            TokenKind::LParen => {
                self.bump();
                if self.check(&TokenKind::RParen) {
                    self.bump();
                    return Ok(Type::Tuple(Vec::new()));
                }
                let first = self.parse_type()?;
                if self.check(&TokenKind::Comma) {
                    self.bump();
                    let mut elems = vec![first];
                    while !self.check(&TokenKind::RParen) {
                        elems.push(self.parse_type()?);
                        if self.check(&TokenKind::Comma) {
                            self.bump();
                        } else {
                            break;
                        }
                    }
                    self.expect(TokenKind::RParen, "`)`")?;
                    Ok(Type::Tuple(elems))
                } else {
                    self.expect(TokenKind::RParen, "`)`")?;
                    Ok(first)
                }
            }
            TokenKind::LBracket => {
                self.bump();
                let elem = self.parse_type()?;
                if elem == Type::Void {
                    return Err(Diagnostic::new(
                        "array elements cannot have type `void` / `None`",
                        token.span,
                    ));
                }
                self.expect(TokenKind::RBracket, "`]`")?;
                Ok(Type::Array(Box::new(elem)))
            }
            TokenKind::NoneLit => {
                self.bump();
                Ok(Type::Void)
            }
            TokenKind::Ident(name) if name == "tuple" => {
                self.bump();
                if self.check(&TokenKind::LBracket) {
                    self.bump();
                    let mut elems = Vec::new();
                    if !self.check(&TokenKind::RBracket) {
                        loop {
                            let t = self.parse_type()?;
                            if t == Type::Void {
                                return Err(Diagnostic::new(
                                    "tuple element cannot have type `void` / `None`",
                                    token.span,
                                ));
                            }
                            elems.push(t);
                            if self.check(&TokenKind::Comma) {
                                self.bump();
                                if self.check(&TokenKind::RBracket) {
                                    break;
                                }
                            } else {
                                break;
                            }
                        }
                    }
                    self.expect(TokenKind::RBracket, "`]`")?;
                    Ok(Type::Tuple(elems))
                } else {
                    Ok(Type::Any)
                }
            }
            TokenKind::Ident(name) if name == "Optional" => {
                self.bump();
                self.expect(TokenKind::LBracket, "`[` after `Optional`")?;
                let inner = self.parse_type()?;
                self.expect(TokenKind::RBracket, "`]`")?;
                if inner == Type::Void || inner == Type::Any {
                    Ok(inner)
                } else {
                    Ok(Type::Optional(Box::new(inner)))
                }
            }
            TokenKind::Ident(name) if name == "list" => {
                self.bump();
                if self.check(&TokenKind::LBracket) {
                    self.bump();
                    let elem = self.parse_type()?;
                    if elem == Type::Void {
                        return Err(Diagnostic::new(
                            "list elements cannot have type `void` / `None`",
                            token.span,
                        ));
                    }
                    self.expect(TokenKind::RBracket, "`]`")?;
                    Ok(Type::Array(Box::new(elem)))
                } else {
                    Ok(Type::Array(Box::new(Type::Any)))
                }
            }
            TokenKind::Ident(name) if name == "dict" => {
                self.bump();
                if self.check(&TokenKind::LBracket) {
                    self.bump();
                    let k = self.parse_type()?;
                    self.expect(TokenKind::Comma, "`,` between dict key and value types")?;
                    let v = self.parse_type()?;
                    if k == Type::Void || v == Type::Void {
                        return Err(Diagnostic::new(
                            "dict key/value types cannot be `void` / `None`",
                            token.span,
                        ));
                    }
                    self.expect(TokenKind::RBracket, "`]`")?;
                    Ok(Type::Dict(Box::new(k), Box::new(v)))
                } else {
                    Ok(Type::Dict(Box::new(Type::Any), Box::new(Type::Any)))
                }
            }
            TokenKind::Ident(name) if name == "set" => {
                self.bump();
                if self.check(&TokenKind::LBracket) {
                    self.bump();
                    let elem = self.parse_type()?;
                    if elem == Type::Void {
                        return Err(Diagnostic::new(
                            "set elements cannot have type `void` / `None`",
                            token.span,
                        ));
                    }
                    self.expect(TokenKind::RBracket, "`]`")?;
                    Ok(Type::Set(Box::new(elem)))
                } else {
                    Ok(Type::Set(Box::new(Type::Any)))
                }
            }
            TokenKind::Ident(name) if name == "any" || name == "Any" => {
                self.bump();
                Ok(Type::Any)
            }
            TokenKind::Ident(name) if name == "int" => {
                self.bump();
                Ok(Type::Int)
            }
            TokenKind::Ident(name) if name == "float" => {
                self.bump();
                Ok(Type::Float)
            }
            TokenKind::Ident(name) if name == "bool" => {
                self.bump();
                Ok(Type::Bool)
            }
            TokenKind::Ident(name) if name == "string" || name == "str" => {
                self.bump();
                Ok(Type::Str)
            }
            TokenKind::Ident(name) if name == "void" => {
                self.bump();
                Ok(Type::Void)
            }
            TokenKind::Ident(name) if name == "Callable" => {
                self.bump();
                if self.check(&TokenKind::LBracket) {
                    self.bump();
                    if self.check(&TokenKind::LBracket) {
                        self.bump();
                        while !self.check(&TokenKind::RBracket) {
                            let _ = self.parse_type()?;
                            if self.check(&TokenKind::Comma) {
                                self.bump();
                            } else {
                                break;
                            }
                        }
                        self.expect(TokenKind::RBracket, "`]`")?;
                    } else {
                        let _ = self.parse_type()?;
                    }
                    self.expect(TokenKind::Comma, "`,` in `Callable[[...], Ret]`")?;
                    let _ = self.parse_type()?;
                    self.expect(TokenKind::RBracket, "`]`")?;
                }
                Ok(Type::Any)
            }
            TokenKind::Ident(name) => {
                let sname = name.clone();
                self.bump();
                if self.check(&TokenKind::LBracket) {
                    self.bump();
                    let mut args = Vec::new();
                    while !self.check(&TokenKind::RBracket) {
                        args.push(self.parse_type()?);
                        if self.check(&TokenKind::Comma) {
                            self.bump();
                        } else {
                            break;
                        }
                    }
                    self.expect(TokenKind::RBracket, "`]`")?;
                    if args.is_empty() {
                        return Err(Diagnostic::new(
                            format!("generic type `{sname}[...]` requires at least one type argument"),
                            token.span,
                        ));
                    }
                    Ok(Type::GenericInst { name: sname, args })
                } else {
                    Ok(Type::Struct(sname))
                }
            }
            _ => Err(Diagnostic::new(
                "expected a type (`int`, `float`, `bool`, `str`, `None`, `list[T]`, `[T]`, or class/struct name)",
                token.span,
            )),
        }
    }

    fn parse_stmt(&mut self) -> Result<Stmt> {
        let span = self.peek().span;

        // A bare string expression is a Python docstring / no-op statement: parse it, then drop
        // it. (`"..."` on its own line has no runtime effect in Python.)
        if matches!(self.peek().kind, TokenKind::Str(_)) {
            let expr = self.parse_expr()?;
            self.expect(TokenKind::Newline, "a newline after the string literal")?;
            return Ok(Stmt {
                kind: StmtKind::Pass,
                span: expr.span,
            });
        }

        if self.check(&TokenKind::Pass) {
            self.bump();
            self.expect(TokenKind::Newline, "a newline after `pass`")?;
            return Ok(Stmt {
                kind: StmtKind::Pass,
                span,
            });
        }

        if self.check(&TokenKind::Assert) {
            self.bump();
            let cond = self.parse_expr()?;
            let msg = if self.check(&TokenKind::Comma) {
                self.bump();
                Some(self.parse_expr()?)
            } else {
                None
            };
            self.expect(TokenKind::Newline, "a newline after `assert`")?;
            return Ok(Stmt {
                kind: StmtKind::Assert { cond, msg },
                span,
            });
        }

        if self.check(&TokenKind::Global) {
            self.bump();
            let mut names = vec![self.expect_ident("a variable name")?];
            while self.check(&TokenKind::Comma) {
                self.bump();
                names.push(self.expect_ident("a variable name")?);
            }
            self.expect(TokenKind::Newline, "a newline after `global`")?;
            return Ok(Stmt {
                kind: StmtKind::Global { names },
                span,
            });
        }

        if self.check(&TokenKind::Del) {
            self.bump();
            let name = self.expect_ident("a variable name")?;
            self.expect(TokenKind::Newline, "a newline after `del`")?;
            return Ok(Stmt {
                kind: StmtKind::Del { name },
                span,
            });
        }

        if self.check(&TokenKind::Let) {
            self.bump();
            if self.check(&TokenKind::LParen) {
                self.bump();
                let mut targets = vec![self.expect_ident("a variable name")?];
                self.expect(TokenKind::Comma, "`,` in tuple `let` destructuring")?;
                while !self.check(&TokenKind::RParen) {
                    targets.push(self.expect_ident("a variable name")?);
                    if !self.check(&TokenKind::Comma) {
                        break;
                    }
                    self.bump();
                }
                self.expect(TokenKind::RParen, "`)`")?;
                self.expect(TokenKind::Eq, "`=`")?;
                let value = self.parse_tuple_or_expr()?;
                self.expect(TokenKind::Newline, "a newline after the statement")?;
                return Ok(Stmt {
                    kind: StmtKind::TupleAssign { targets, value },
                    span,
                });
            }
            let name = self.expect_ident("a variable name")?;
            if self.check(&TokenKind::Comma) {
                let mut targets = vec![name];
                while self.check(&TokenKind::Comma) {
                    self.bump();
                    if self.check(&TokenKind::Eq) {
                        break;
                    }
                    targets.push(self.expect_ident("a variable name")?);
                }
                self.expect(TokenKind::Eq, "`=`")?;
                let value = self.parse_tuple_or_expr()?;
                self.expect(TokenKind::Newline, "a newline after the statement")?;
                return Ok(Stmt {
                    kind: StmtKind::TupleAssign { targets, value },
                    span,
                });
            }
            let ty = if self.check(&TokenKind::Colon) {
                self.bump();
                Some(self.parse_type()?)
            } else {
                None
            };
            self.expect(TokenKind::Eq, "`=`")?;
            let value = self.parse_tuple_or_expr()?;
            self.expect(TokenKind::Newline, "a newline after the statement")?;
            return Ok(Stmt {
                kind: StmtKind::Let { name, ty, value },
                span,
            });
        }

        // Python PEP 526 annotated variable declaration: `x: int = 0` / `xs: list[int] = []`
        if matches!(&self.peek().kind, TokenKind::Ident(_)) && self.peek_at(1).kind == TokenKind::Colon {
            let name = self.expect_ident("a variable name")?;
            self.bump(); // `:`
            let ty = self.parse_type()?;
            self.expect(TokenKind::Eq, "`=` after type annotation")?;
            let value = self.parse_tuple_or_expr()?;
            self.expect(TokenKind::Newline, "a newline after the statement")?;
            return Ok(Stmt {
                kind: StmtKind::Let {
                    name,
                    ty: Some(ty),
                    value,
                },
                span,
            });
        }

        if self.check(&TokenKind::Return) {
            self.bump();
            let value = if self.check(&TokenKind::Newline) {
                None
            } else if self.check(&TokenKind::NoneLit) && self.peek_at(1).kind == TokenKind::Newline {
                self.bump();
                None
            } else {
                Some(self.parse_tuple_or_expr()?)
            };
            self.expect(TokenKind::Newline, "a newline after the statement")?;
            return Ok(Stmt {
                kind: StmtKind::Return(value),
                span,
            });
        }

        // Python 3.10+ soft keyword `match <subject>:`
        if matches!(&self.peek().kind, TokenKind::Ident(k) if k == "match") {
            let saved = self.pos;
            self.bump();
            let is_match_header = if let Ok(subj) = self.parse_tuple_or_expr() {
                if self.check(&TokenKind::Colon) && self.peek_at(1).kind == TokenKind::Newline {
                    Some(subj)
                } else {
                    None
                }
            } else {
                None
            };
            if let Some(subject) = is_match_header {
                return self.parse_match_tail(span, subject);
            }
            self.pos = saved;
        }

        if self.check(&TokenKind::If) {
            self.bump();
            return self.parse_if_tail(span, "if");
        }

        if self.check(&TokenKind::While) {
            self.bump();
            let cond = self.parse_expr()?;
            self.expect(TokenKind::Colon, "`:`")?;
            self.expect(
                TokenKind::Newline,
                "a newline after the `while` condition",
            )?;
            self.expect(TokenKind::Indent, "an indented `while` body")?;
            let body = self.parse_block_body()?;
            self.expect(TokenKind::Dedent, "the end of the `while` body")?;
            if body.is_empty() {
                return Err(Diagnostic::new("`while` body cannot be empty", span));
            }
            return Ok(Stmt {
                kind: StmtKind::While { cond, body },
                span,
            });
        }

        if self.check(&TokenKind::For) {
            self.bump();
            let mut loop_vars = Vec::new();
            if self.check(&TokenKind::LParen) {
                self.bump();
                loop_vars.push(self.expect_ident("a loop variable name")?);
                while self.check(&TokenKind::Comma) {
                    self.bump();
                    if self.check(&TokenKind::RParen) {
                        break;
                    }
                    loop_vars.push(self.expect_ident("a loop variable name")?);
                }
                self.expect(TokenKind::RParen, "`)`")?;
            } else {
                loop_vars.push(self.expect_ident("a loop variable name")?);
                while self.check(&TokenKind::Comma) {
                    self.bump();
                    if self.check(&TokenKind::In) {
                        break;
                    }
                    loop_vars.push(self.expect_ident("a loop variable name")?);
                }
            }

            if loop_vars.len() >= 2 {
                self.expect(TokenKind::In, "`in`")?;
                let iter_expr = self.parse_expr()?;
                self.expect(TokenKind::Colon, "`:`")?;
                self.expect(TokenKind::Newline, "a newline after the `for` header")?;
                self.expect(TokenKind::Indent, "an indented `for` body")?;
                let body = self.parse_block_body()?;
                self.expect(TokenKind::Dedent, "the end of the `for` body")?;
                if body.is_empty() {
                    return Err(Diagnostic::new("`for` body cannot be empty", span));
                }
                if let ExprKind::Call { ref name, ref args } = iter_expr.kind {
                    if name == "zip" {
                        if args.len() != loop_vars.len() {
                            return Err(Diagnostic::new(
                                format!(
                                    "`zip(...)` supplies {} iterables, but `for` unpacks {} variables",
                                    args.len(),
                                    loop_vars.len()
                                ),
                                iter_expr.span,
                            ));
                        }
                        let ExprKind::Call { args, .. } = iter_expr.kind else {
                            unreachable!()
                        };
                        return Ok(Stmt {
                            kind: StmtKind::ForZip {
                                vars: loop_vars,
                                iters: args,
                                body,
                            },
                            span,
                        });
                    }
                }
                if loop_vars.len() == 2 {
                    let elem_var = loop_vars.pop().unwrap();
                    let var = loop_vars.pop().unwrap();
                    return match iter_expr.kind {
                        ExprKind::Call { name, mut args } if name == "enumerate" => {
                            if args.is_empty() || args.len() > 2 {
                                return Err(Diagnostic::new(
                                    "`enumerate()` expects 1 or 2 arguments (`enumerate(seq[, start])`)",
                                    iter_expr.span,
                                ));
                            }
                            let start = if args.len() == 2 {
                                Some(args.remove(1))
                            } else {
                                None
                            };
                            let iter = args.remove(0);
                            Ok(Stmt {
                                kind: StmtKind::ForEnumerate {
                                    idx_var: var,
                                    elem_var,
                                    iter,
                                    start,
                                    body,
                                },
                                span,
                            })
                        }
                        ExprKind::MethodCall {
                            target,
                            method,
                            args,
                        } if method == "items" && args.is_empty() => Ok(Stmt {
                            kind: StmtKind::ForDictItems {
                                key_var: var,
                                val_var: elem_var,
                                dict: *target,
                                body,
                            },
                            span,
                        }),
                        other => Ok(Stmt {
                            kind: StmtKind::ForDictItems {
                                key_var: var,
                                val_var: elem_var,
                                dict: Expr {
                                    kind: other,
                                    span: iter_expr.span,
                                },
                                body,
                            },
                            span,
                        }),
                    };
                }
                return Ok(Stmt {
                    kind: StmtKind::ForTupleUnpack {
                        vars: loop_vars,
                        iter: iter_expr,
                        body,
                    },
                    span,
                });
            }

            let var = loop_vars.pop().unwrap();

            self.expect(TokenKind::In, "`in`")?;
            let first = self.parse_expr()?;
            if self.check(&TokenKind::DotDot) {
                self.bump();
                let end = self.parse_expr()?;
                let step = if matches!(&self.peek().kind, TokenKind::Ident(k) if k == "step") {
                    self.bump();
                    Some(self.parse_expr()?)
                } else {
                    None
                };
                self.expect(TokenKind::Colon, "`:`")?;
                self.expect(TokenKind::Newline, "a newline after the `for` header")?;
                self.expect(TokenKind::Indent, "an indented `for` body")?;
                let body = self.parse_block_body()?;
                self.expect(TokenKind::Dedent, "the end of the `for` body")?;
                if body.is_empty() {
                    return Err(Diagnostic::new("`for` body cannot be empty", span));
                }
                return self.maybe_parse_loop_else(Stmt {
                    kind: StmtKind::For {
                        var,
                        start: first,
                        end,
                        step,
                        body,
                        else_body: None,
                    },
                    span,
                });
            }

            if matches!(&first.kind, ExprKind::Call { name, .. } if name == "range") {
                let rspan = first.span;
                let args = match first.kind {
                    ExprKind::Call { args, .. } => args,
                    _ => unreachable!(),
                };
                let (start, end, step) = match args.len() {
                    1 => {
                        let mut it = args.into_iter();
                        (
                            Expr {
                                kind: ExprKind::Int(0),
                                span: rspan,
                            },
                            it.next().unwrap(),
                            None,
                        )
                    }
                    2 => {
                        let mut it = args.into_iter();
                        (it.next().unwrap(), it.next().unwrap(), None)
                    }
                    3 => {
                        let mut it = args.into_iter();
                        (
                            it.next().unwrap(),
                            it.next().unwrap(),
                            Some(it.next().unwrap()),
                        )
                    }
                    _ => {
                        return Err(Diagnostic::new(
                            "`range()` expects 1, 2, or 3 arguments",
                            rspan,
                        ));
                    }
                };
                self.expect(TokenKind::Colon, "`:`")?;
                self.expect(TokenKind::Newline, "a newline after the `for` header")?;
                self.expect(TokenKind::Indent, "an indented `for` body")?;
                let body = self.parse_block_body()?;
                self.expect(TokenKind::Dedent, "the end of the `for` body")?;
                if body.is_empty() {
                    return Err(Diagnostic::new("`for` body cannot be empty", span));
                }
                return self.maybe_parse_loop_else(Stmt {
                    kind: StmtKind::For {
                        var,
                        start,
                        end,
                        step,
                        body,
                        else_body: None,
                    },
                    span,
                });
            }

            self.expect(TokenKind::Colon, "`:`")?;
            self.expect(TokenKind::Newline, "a newline after the `for` header")?;
            self.expect(TokenKind::Indent, "an indented `for` body")?;
            let body = self.parse_block_body()?;
            self.expect(TokenKind::Dedent, "the end of the `for` body")?;
            if body.is_empty() {
                return Err(Diagnostic::new("`for` body cannot be empty", span));
            }
            return self.maybe_parse_loop_else(Stmt {
                kind: StmtKind::ForEach {
                    var,
                    iter: first,
                    body,
                    else_body: None,
                },
                span,
            });
        }

        if self.check(&TokenKind::With) {
            self.bump();
            self.expect(TokenKind::Region, "`region` after `with`")?;
            self.expect(TokenKind::Colon, "`:`")?;
            self.expect(TokenKind::Newline, "a newline after `with region:`")?;
            self.expect(TokenKind::Indent, "an indented `with region` body")?;
            let body = self.parse_block_body()?;
            self.expect(TokenKind::Dedent, "the end of the `with region` body")?;
            if body.is_empty() {
                return Err(Diagnostic::new("`with region` body cannot be empty", span));
            }
            return Ok(Stmt {
                kind: StmtKind::Region { body },
                span,
            });
        }

        if self.check(&TokenKind::Region) {
            self.bump();
            self.expect(TokenKind::Colon, "`:`")?;
            self.expect(TokenKind::Newline, "a newline after `region:`")?;
            self.expect(TokenKind::Indent, "an indented `region` body")?;
            let body = self.parse_block_body()?;
            self.expect(TokenKind::Dedent, "the end of the `region` body")?;
            if body.is_empty() {
                return Err(Diagnostic::new("`region` body cannot be empty", span));
            }
            return Ok(Stmt {
                kind: StmtKind::Region { body },
                span,
            });
        }

        if self.check(&TokenKind::Break) {
            self.bump();
            self.expect(TokenKind::Newline, "a newline after `break`")?;
            return Ok(Stmt {
                kind: StmtKind::Break,
                span,
            });
        }

        if self.check(&TokenKind::Continue) {
            self.bump();
            self.expect(TokenKind::Newline, "a newline after `continue`")?;
            return Ok(Stmt {
                kind: StmtKind::Continue,
                span,
            });
        }

        let lhs = self.parse_expr()?;

        // Bare comma-separated tuple unpacking: `a, b = expr` / `x, y = y, x`
        if self.check(&TokenKind::Comma) {
            let ExprKind::Var(first_var) = lhs.kind else {
                return Err(Diagnostic::new(
                    "tuple unpacking targets must be variable names",
                    lhs.span,
                ));
            };
            let mut targets = vec![first_var];
            while self.check(&TokenKind::Comma) {
                self.bump();
                targets.push(self.expect_ident("a variable name in tuple unpacking")?);
            }
            self.expect(TokenKind::Eq, "`=` after tuple unpacking targets")?;
            let value = self.parse_tuple_or_expr()?;
            self.expect(TokenKind::Newline, "a newline after tuple assignment")?;
            return Ok(Stmt {
                kind: StmtKind::TupleAssign { targets, value },
                span,
            });
        }

        let assign_op = match &self.peek().kind {
            TokenKind::Eq => Some(None),
            TokenKind::PlusEq => Some(Some(BinOp::Add)),
            TokenKind::MinusEq => Some(Some(BinOp::Sub)),
            TokenKind::StarEq => Some(Some(BinOp::Mul)),
            TokenKind::StarStarEq => Some(Some(BinOp::Pow)),
            TokenKind::SlashEq => Some(Some(BinOp::Div)),
            TokenKind::SlashSlashEq => Some(Some(BinOp::FloorDiv)),
            TokenKind::PercentEq => Some(Some(BinOp::Mod)),
            _ => None,
        };

        if let Some(op) = assign_op {
            let eq_span = self.peek().span;
            self.bump();
            if op.is_none() {
                if let ExprKind::TupleLit(items) = &lhs.kind {
                    if !items.is_empty() {
                        let mut targets = Vec::with_capacity(items.len());
                        for item in items {
                            if let ExprKind::Var(v) = &item.kind {
                                targets.push(v.clone());
                            } else {
                                return Err(Diagnostic::new(
                                    "tuple unpacking targets must be variable names",
                                    item.span,
                                ));
                            }
                        }
                        let value = self.parse_tuple_or_expr()?;
                        self.expect(TokenKind::Newline, "a newline after tuple assignment")?;
                        return Ok(Stmt {
                            kind: StmtKind::TupleAssign { targets, value },
                            span,
                        });
                    }
                }
            }
            let target = match lhs.kind {
                ExprKind::Var(name) => AssignTarget::Var(name),
                ExprKind::Index { target, index } => AssignTarget::Index { target, index },
                ExprKind::Field { target, field } => AssignTarget::Field { target, field },
                _ => {
                    return Err(Diagnostic::new(
                        "left-hand side of assignment must be a variable, field, or array element",
                        eq_span,
                    ));
                }
            };
            let value = if op.is_none() {
                self.parse_tuple_or_expr()?
            } else {
                self.parse_expr()?
            };
            self.expect(TokenKind::Newline, "a newline after the assignment")?;
            return Ok(Stmt {
                kind: StmtKind::Assign { target, op, value },
                span,
            });
        }

        self.expect(TokenKind::Newline, "a newline after the statement")?;
        Ok(Stmt {
            kind: StmtKind::Expr(lhs),
            span,
        })
    }

    fn parse_tuple_or_expr(&mut self) -> Result<Expr> {
        let first = self.parse_expr()?;
        if !self.check(&TokenKind::Comma) {
            return Ok(first);
        }
        let span = first.span;
        let mut elems = vec![first];
        while self.check(&TokenKind::Comma) {
            self.bump();
            if self.check(&TokenKind::Newline)
                || self.check(&TokenKind::Colon)
                || self.check(&TokenKind::Eof)
            {
                break;
            }
            elems.push(self.parse_expr()?);
        }
        Ok(Expr {
            kind: ExprKind::TupleLit(elems),
            span,
        })
    }

    fn parse_match_tail(&mut self, span: Span, subject: Expr) -> Result<Stmt> {
        self.enter_depth()?;
        let res = self.parse_match_tail_inner(span, subject);
        self.depth -= 1;
        res
    }

    fn parse_match_tail_inner(&mut self, span: Span, subject: Expr) -> Result<Stmt> {
        self.expect(TokenKind::Colon, "`:` after `match` subject")?;
        self.expect(TokenKind::Newline, "a newline after `match` header")?;
        self.expect(TokenKind::Indent, "an indented `match` body")?;

        let mut cases = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::Dedent) || self.check(&TokenKind::Eof) {
                break;
            }
            let cspan = self.peek().span;
            if !matches!(&self.peek().kind, TokenKind::Ident(k) if k == "case") {
                return Err(Diagnostic::new(
                    format!("expected `case` arm inside `match`, found {}", self.peek().kind.describe()),
                    cspan,
                ));
            }
            self.bump(); // `case`
            let pattern = self.parse_pattern()?;
            let guard = if self.check(&TokenKind::If) {
                self.bump();
                Some(self.parse_expr()?)
            } else {
                None
            };
            self.expect(TokenKind::Colon, "`:` after `case` pattern")?;
            self.expect(TokenKind::Newline, "a newline after `case` header")?;
            self.expect(TokenKind::Indent, "an indented `case` body")?;
            let body = self.parse_block_body()?;
            self.expect(TokenKind::Dedent, "the end of the `case` body")?;
            if body.is_empty() {
                return Err(Diagnostic::new("`case` body cannot be empty", cspan));
            }
            cases.push(MatchCase {
                pattern,
                guard,
                body,
                span: cspan,
            });
        }

        self.expect(TokenKind::Dedent, "the end of the `match` body")?;
        if cases.is_empty() {
            return Err(Diagnostic::new("`match` must have at least one `case` arm", span));
        }
        Ok(Stmt {
            kind: StmtKind::Match { subject, cases },
            span,
        })
    }

    fn parse_pattern(&mut self) -> Result<Pattern> {
        self.enter_depth()?;
        let res = self.parse_or_pattern();
        self.depth -= 1;
        res
    }

    fn parse_or_pattern(&mut self) -> Result<Pattern> {
        let first = self.parse_single_pattern()?;
        if !self.check(&TokenKind::Pipe) {
            return Ok(first);
        }
        let span = self.peek().span;
        let mut alts = vec![first];
        while self.check(&TokenKind::Pipe) {
            self.bump();
            alts.push(self.parse_single_pattern()?);
        }
        Ok(Pattern::Or(alts, span))
    }

    fn parse_single_pattern(&mut self) -> Result<Pattern> {
        let tok = self.peek().clone();
        let span = tok.span;
        match tok.kind {
            TokenKind::NoneLit => {
                self.bump();
                Ok(Pattern::NonePat(span))
            }
            TokenKind::Bool(b) => {
                self.bump();
                Ok(Pattern::Bool(b, span))
            }
            TokenKind::Int(n) => {
                self.bump();
                Ok(Pattern::Int(n, span))
            }
            TokenKind::Float(x) => {
                self.bump();
                Ok(Pattern::Float(x, span))
            }
            TokenKind::Minus => {
                self.bump();
                match self.peek().kind {
                    TokenKind::Int(n) => {
                        self.bump();
                        Ok(Pattern::Int(n.wrapping_neg(), span))
                    }
                    TokenKind::Float(x) => {
                        self.bump();
                        Ok(Pattern::Float(-x, span))
                    }
                    _ => Err(Diagnostic::new(
                        "expected numeric literal after `-` in pattern",
                        span,
                    )),
                }
            }
            TokenKind::Str(s) => {
                self.bump();
                Ok(Pattern::Str(s, span))
            }
            TokenKind::LParen | TokenKind::LBracket => {
                let close = if tok.kind == TokenKind::LParen {
                    TokenKind::RParen
                } else {
                    TokenKind::RBracket
                };
                let close_desc = if tok.kind == TokenKind::LParen { "`)`" } else { "`]`" };
                self.bump();
                if self.check(&close) {
                    self.bump();
                    return Ok(Pattern::Tuple(Vec::new(), span));
                }
                let first = self.parse_pattern()?;
                if tok.kind == TokenKind::LParen && !self.check(&TokenKind::Comma) {
                    self.expect(close, close_desc)?;
                    return Ok(first);
                }
                let mut elems = vec![first];
                while self.check(&TokenKind::Comma) {
                    self.bump();
                    if self.check(&close) {
                        break;
                    }
                    elems.push(self.parse_pattern()?);
                }
                self.expect(close, close_desc)?;
                Ok(Pattern::Tuple(elems, span))
            }
            TokenKind::Ident(name) if name == "_" => {
                self.bump();
                Ok(Pattern::Wildcard(span))
            }
            TokenKind::Ident(name) => {
                self.bump();
                if self.check(&TokenKind::Dot) {
                    self.bump();
                    let variant = self.expect_ident("an enum variant name after `.`")?;
                    let mut args = Vec::new();
                    if self.check(&TokenKind::LParen) {
                        self.bump();
                        while !self.check(&TokenKind::RParen) {
                            args.push(self.parse_pattern()?);
                            if self.check(&TokenKind::Comma) {
                                self.bump();
                            } else {
                                break;
                            }
                        }
                        self.expect(TokenKind::RParen, "`)`")?;
                    }
                    Ok(Pattern::EnumVariant {
                        enum_name: name,
                        variant,
                        args,
                        span,
                    })
                } else {
                    Ok(Pattern::Bind(name, span))
                }
            }
            _ => Err(Diagnostic::new(
                format!("expected a match pattern, found {}", tok.kind.describe()),
                span,
            )),
        }
    }

    fn parse_if_tail(&mut self, span: Span, keyword: &str) -> Result<Stmt> {
        self.enter_depth()?;
        let res = self.parse_if_tail_inner(span, keyword);
        self.depth -= 1;
        res
    }

    fn parse_if_tail_inner(&mut self, span: Span, keyword: &str) -> Result<Stmt> {
        let cond = self.parse_expr()?;
        self.expect(TokenKind::Colon, "`:`")?;
        self.expect(
            TokenKind::Newline,
            &format!("a newline after the `{keyword}` condition"),
        )?;
        self.expect(
            TokenKind::Indent,
            &format!("an indented `{keyword}` body"),
        )?;

        let then_body = self.parse_block_body()?;
        self.expect(
            TokenKind::Dedent,
            &format!("the end of the `{keyword}` body"),
        )?;

        if then_body.is_empty() {
            return Err(Diagnostic::new(
                format!("`{keyword}` body cannot be empty"),
                span,
            ));
        }

        let else_body = if self.check(&TokenKind::Elif) {
            let elif_span = self.peek().span;
            self.bump();
            Some(vec![self.parse_if_tail(elif_span, "elif")?])
        } else if self.check(&TokenKind::Else) {
            let else_span = self.peek().span;
            self.bump();
            self.expect(TokenKind::Colon, "`:`")?;
            self.expect(TokenKind::Newline, "a newline after `else:`")?;
            self.expect(TokenKind::Indent, "an indented `else` body")?;

            let body = self.parse_block_body()?;
            self.expect(TokenKind::Dedent, "the end of the `else` body")?;

            if body.is_empty() {
                return Err(Diagnostic::new("`else` body cannot be empty", else_span));
            }
            Some(body)
        } else {
            None
        };

        Ok(Stmt {
            kind: StmtKind::If {
                cond,
                then_body,
                else_body,
            },
            span,
        })
    }

    /// `for ...: <body> else: <else_body>` — wraps the loop so codegen can run the `else` only
    /// when the loop left through normal completion (Python's `for/else`).
    /// Parses the optional `else:` block of a `for` loop and attaches it to the loop itself,
    /// so the loop stays a loop for every later pass (scope, returns, mutation analysis).
    fn maybe_parse_loop_else(&mut self, mut loop_stmt: Stmt) -> Result<Stmt> {
        self.skip_newlines();
        if !matches!(&self.peek().kind, TokenKind::Else) {
            return Ok(loop_stmt);
        }
        let span = self.peek().span;
        self.bump();
        self.expect(TokenKind::Colon, "`:` after `else`")?;
        self.expect(TokenKind::Newline, "a newline after `else:`")?;
        self.expect(TokenKind::Indent, "an indented `else` body")?;
        let else_body = self.parse_block_body()?;
        self.expect(TokenKind::Dedent, "the end of the `else` body")?;
        if else_body.is_empty() {
            return Err(Diagnostic::new("`else` body cannot be empty", span));
        }
        match &mut loop_stmt.kind {
            StmtKind::For { else_body: slot, .. } | StmtKind::ForEach { else_body: slot, .. } => {
                *slot = Some(else_body)
            }
            _ => {
                return Err(Diagnostic::new(
                    "`else` is only supported on `for` loops",
                    span,
                ))
            }
        }
        Ok(loop_stmt)
    }

    fn parse_block_body(&mut self) -> Result<Vec<Stmt>> {
        self.enter_depth()?;
        let mut body = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::Dedent) || self.check(&TokenKind::Eof) {
                break;
            }
            match self.parse_stmt() {
                Ok(s) => body.push(s),
                Err(e) => {
                    self.depth -= 1;
                    return Err(e);
                }
            }
        }
        self.depth -= 1;
        Ok(body)
    }

    fn parse_expr(&mut self) -> Result<Expr> {
        self.enter_depth()?;
        let res = self.parse_if_expr();
        self.depth -= 1;
        res
    }

    // Python inline conditional (`then_expr if cond else else_expr`) and `lambda`
    fn parse_if_expr(&mut self) -> Result<Expr> {
        if self.check(&TokenKind::Lambda) {
            return self.parse_lambda();
        }
        let then_expr = self.parse_or()?;
        if self.check(&TokenKind::If) {
            let span = self.peek().span;
            self.bump();
            let cond = self.parse_or()?;
            self.expect(TokenKind::Else, "`else` in conditional expression")?;
            let else_expr = self.parse_expr()?;
            return Ok(Expr {
                kind: ExprKind::IfExpr {
                    then_expr: Box::new(then_expr),
                    cond: Box::new(cond),
                    else_expr: Box::new(else_expr),
                },
                span,
            });
        }
        Ok(then_expr)
    }

    fn parse_lambda(&mut self) -> Result<Expr> {
        let span = self.peek().span;
        self.expect(TokenKind::Lambda, "`lambda`")?;
        let mut params = Vec::new();
        // Archx Speed optional typed params: `lambda (x: int, y: int): x + y`
        if self.check(&TokenKind::LParen) {
            self.bump();
            while !self.check(&TokenKind::RParen) {
                let pname = self.expect_ident("lambda parameter name")?;
                let ty = if self.check(&TokenKind::Colon) {
                    self.bump();
                    self.parse_type()?
                } else {
                    Type::Any
                };
                params.push(Param {
                    name: pname,
                    ty,
                    default: None,
                });
                if self.check(&TokenKind::Comma) {
                    self.bump();
                } else {
                    break;
                }
            }
            self.expect(TokenKind::RParen, "`)`")?;
            if self.check(&TokenKind::Arrow) {
                self.bump();
                let _ = self.parse_type()?;
            }
        } else if !self.check(&TokenKind::Colon) {
            // Standard 1:1 Python lambda: `lambda x, y: x + y`
            loop {
                if self.check(&TokenKind::Colon) {
                    break;
                }
                let pname = self.expect_ident("lambda parameter name")?;
                params.push(Param {
                    name: pname,
                    ty: Type::Any,
                    default: None,
                });
                if self.check(&TokenKind::Comma) {
                    self.bump();
                } else {
                    break;
                }
            }
        }
        self.expect(TokenKind::Colon, "`:` after lambda parameters")?;
        let body = self.parse_expr()?;
        Ok(Expr {
            kind: ExprKind::Lambda {
                params,
                body: Box::new(body),
            },
            span,
        })
    }

    fn parse_comp_clauses(&mut self) -> Result<Vec<CompClause>> {
        let mut clauses = Vec::new();
        while self.check(&TokenKind::For) {
            let span = self.peek().span;
            self.bump(); // `for`
            let mut vars = Vec::new();
            if self.check(&TokenKind::LParen) {
                self.bump();
                vars.push(self.expect_ident("comprehension target variable")?);
                while self.check(&TokenKind::Comma) {
                    self.bump();
                    if self.check(&TokenKind::RParen) {
                        break;
                    }
                    vars.push(self.expect_ident("comprehension target variable")?);
                }
                self.expect(TokenKind::RParen, "`)`")?;
            } else {
                vars.push(self.expect_ident("comprehension target variable")?);
                while self.check(&TokenKind::Comma) {
                    self.bump();
                    if self.check(&TokenKind::In) {
                        break;
                    }
                    vars.push(self.expect_ident("comprehension target variable")?);
                }
            }
            self.expect(TokenKind::In, "`in` in comprehension")?;
            // PEP 709 grammar: iterable and filter condition are `disjunction` (`parse_or`),
            // NOT `parse_expr`, so `if cond` is parsed as the comprehension filter clause!
            let iter = self.parse_or()?;
            let mut conds = Vec::new();
            while self.check(&TokenKind::If) {
                self.bump();
                conds.push(self.parse_or()?);
            }
            clauses.push(CompClause {
                vars,
                iter,
                conds,
                span,
            });
        }
        Ok(clauses)
    }

    /// Speculatively parse `[T1, T2, ...]` only when immediately followed by `(`.
    fn try_parse_explicit_type_args(&mut self) -> Option<Vec<Type>> {
        if !self.check(&TokenKind::LBracket) {
            return None;
        }
        let saved_pos = self.pos;
        let saved_depth = self.depth;
        self.bump(); // `[`
        let mut targs = Vec::new();
        loop {
            if self.check(&TokenKind::RBracket) {
                break;
            }
            match self.parse_type() {
                Ok(t) => targs.push(t),
                Err(_) => {
                    self.pos = saved_pos;
                    self.depth = saved_depth;
                    return None;
                }
            }
            if self.check(&TokenKind::Comma) {
                self.bump();
            } else {
                break;
            }
        }
        if !targs.is_empty() && self.check(&TokenKind::RBracket) {
            self.bump(); // `]`
            if self.check(&TokenKind::LParen) {
                return Some(targs);
            }
        }
        self.pos = saved_pos;
        self.depth = saved_depth;
        None
    }

    fn enter_depth(&mut self) -> Result<()> {
        self.depth += 1;
        if self.depth > MAX_NESTING {
            self.depth -= 1;
            return Err(self.error(format!("maximum nesting depth ({MAX_NESTING}) exceeded")));
        }
        Ok(())
    }

    fn parse_or(&mut self) -> Result<Expr> {
        let mut lhs = self.parse_and()?;

        loop {
            if self.check(&TokenKind::Or) {
                let span = self.peek().span;
                self.bump();
                let rhs = self.parse_and()?;
                lhs = Expr {
                    kind: ExprKind::Binary {
                        op: BinOp::Or,
                        lhs: Box::new(lhs),
                        rhs: Box::new(rhs),
                    },
                    span,
                };
            } else {
                break;
            }
        }

        Ok(lhs)
    }

    fn parse_and(&mut self) -> Result<Expr> {
        let mut lhs = self.parse_not()?;

        loop {
            if self.check(&TokenKind::And) {
                let span = self.peek().span;
                self.bump();
                let rhs = self.parse_not()?;
                lhs = Expr {
                    kind: ExprKind::Binary {
                        op: BinOp::And,
                        lhs: Box::new(lhs),
                        rhs: Box::new(rhs),
                    },
                    span,
                };
            } else {
                break;
            }
        }

        Ok(lhs)
    }

    fn parse_not(&mut self) -> Result<Expr> {
        let mut spans = Vec::new();
        while self.check(&TokenKind::Not) && self.peek_at(1).kind != TokenKind::In {
            if self.depth + spans.len() >= MAX_NESTING {
                return Err(self.error(format!("maximum nesting depth ({MAX_NESTING}) exceeded")));
            }
            spans.push(self.peek().span);
            self.bump();
        }
        let mut expr = self.parse_comparison()?;
        for span in spans.into_iter().rev() {
            expr = Expr {
                kind: ExprKind::Unary {
                    op: UnOp::Not,
                    expr: Box::new(expr),
                },
                span,
            };
        }
        Ok(expr)
    }

    fn parse_comparison(&mut self) -> Result<Expr> {
        let mut lhs = self.parse_bitor()?;

        // Whether `lhs` is already one comparison (and therefore can be extended into a chain).
        let mut first_seen = false;

        loop {
            let span = self.peek().span;
            let op = match &self.peek().kind {
                TokenKind::EqEq => {
                    self.bump();
                    BinOp::Eq
                }
                TokenKind::NotEq => {
                    self.bump();
                    BinOp::Ne
                }
                TokenKind::Lt => {
                    self.bump();
                    BinOp::Lt
                }
                TokenKind::Gt => {
                    self.bump();
                    BinOp::Gt
                }
                TokenKind::Le => {
                    self.bump();
                    BinOp::Le
                }
                TokenKind::Ge => {
                    self.bump();
                    BinOp::Ge
                }
                TokenKind::In => {
                    self.bump();
                    BinOp::In
                }
                TokenKind::Not if self.peek_at(1).kind == TokenKind::In => {
                    self.bump();
                    self.bump();
                    BinOp::NotIn
                }
                TokenKind::Ident(s) if s == "is" && self.peek_at(1).kind == TokenKind::Not => {
                    self.bump();
                    self.bump();
                    BinOp::Ne
                }
                TokenKind::Ident(s) if s == "is" => {
                    self.bump();
                    BinOp::Eq
                }
                _ => break,
            };
            let rhs = self.parse_bitor()?;
            // A *single* comparison stays a plain `Binary` node — `if x is not None:` narrowing
            // and the optional-comparison rules key off that shape. Only a genuine chain
            // (`a < b < c`) becomes a `CompareChain`.
            // Only a *previous comparison* can start a chain; a `Binary` node from an arithmetic
            // operator (`i % 2`) must not be mistaken for one.
            match lhs.kind {
                ExprKind::CompareChain(mut operands) => {
                    // The previous tail's operator was a placeholder; this link supplies it.
                    if let Some(last) = operands.last_mut() {
                        last.1 = op;
                    }
                    operands.push((Box::new(rhs), BinOp::Eq));
                    lhs = Expr {
                        kind: ExprKind::CompareChain(operands),
                        span: lhs.span,
                    };
                }
                ExprKind::Binary {
                    op: first_op,
                    lhs: first_lhs,
                    rhs: first_rhs,
                } if first_seen => {
                    lhs = Expr {
                        kind: ExprKind::CompareChain(vec![
                            (first_lhs, first_op),
                            (first_rhs, op),
                            (Box::new(rhs), BinOp::Eq),
                        ]),
                        span: lhs.span,
                    };
                }
                _ => {
                    lhs = Expr {
                        kind: ExprKind::Binary {
                            op,
                            lhs: Box::new(lhs),
                            rhs: Box::new(rhs),
                        },
                        span,
                    };
                    first_seen = true;
                }
            }
        }

        Ok(lhs)
    }

    // Python precedence, loosest to tightest:
    //   or < and < not < comparison < | < ^ < & < << >> < + - < * / // % < unary < **
    fn parse_bitor(&mut self) -> Result<Expr> {
        self.parse_bit_level(Self::parse_bitxor, &[(TokenKind::Pipe, BinOp::BitOr)])
    }

    fn parse_bitxor(&mut self) -> Result<Expr> {
        self.parse_bit_level(Self::parse_bitand, &[(TokenKind::Caret, BinOp::BitXor)])
    }

    fn parse_bitand(&mut self) -> Result<Expr> {
        self.parse_bit_level(Self::parse_shift, &[(TokenKind::Amp, BinOp::BitAnd)])
    }

    fn parse_shift(&mut self) -> Result<Expr> {
        self.parse_bit_level(
            Self::parse_additive,
            &[(TokenKind::Shl, BinOp::Shl), (TokenKind::Shr, BinOp::Shr)],
        )
    }

    /// One left-associative bitwise precedence level.
    fn parse_bit_level(
        &mut self,
        next: fn(&mut Self) -> Result<Expr>,
        ops: &[(TokenKind, BinOp)],
    ) -> Result<Expr> {
        let mut lhs = next(self)?;
        loop {
            let mut matched = None;
            for (tok, op) in ops {
                if self.peek().kind == *tok {
                    matched = Some(*op);
                    break;
                }
            }
            let Some(op) = matched else { break };
            let span = self.peek().span;
            self.bump();
            let rhs = next(self)?;
            lhs = Expr {
                kind: ExprKind::Binary {
                    op,
                    lhs: Box::new(lhs),
                    rhs: Box::new(rhs),
                },
                span,
            };
        }
        Ok(lhs)
    }

    fn parse_additive(&mut self) -> Result<Expr> {
        let mut lhs = self.parse_multiplicative()?;

        loop {
            let op = match &self.peek().kind {
                TokenKind::Plus => BinOp::Add,
                TokenKind::Minus => BinOp::Sub,
                _ => break,
            };
            let span = self.peek().span;
            self.bump();
            let rhs = self.parse_multiplicative()?;
            lhs = Expr {
                kind: ExprKind::Binary {
                    op,
                    lhs: Box::new(lhs),
                    rhs: Box::new(rhs),
                },
                span,
            };
        }

        Ok(lhs)
    }

    fn parse_multiplicative(&mut self) -> Result<Expr> {
        let mut lhs = self.parse_unary()?;

        loop {
            let op = match &self.peek().kind {
                TokenKind::Star => BinOp::Mul,
                TokenKind::Slash => BinOp::Div,
                TokenKind::SlashSlash => BinOp::FloorDiv,
                TokenKind::Percent => BinOp::Mod,
                _ => break,
            };
            let span = self.peek().span;
            self.bump();
            let rhs = self.parse_unary()?;

            // `"..." % values` is printf-style formatting, not a numeric modulus.
            if op == BinOp::Mod {
                if let ExprKind::Str(template) = &lhs.kind {
                    lhs = Expr {
                        kind: ExprKind::PercentFormat {
                            template: template.clone(),
                            args: Box::new(rhs),
                        },
                        span,
                    };
                    continue;
                }
            }

            // Python list repetition `[val] * n` or `n * [val]` -> zero-overhead `ArrayRepeat`
            if op == BinOp::Mul {
                if matches!(&lhs.kind, ExprKind::ArrayLit(es) if es.len() == 1) {
                    let elem = match lhs.kind {
                        ExprKind::ArrayLit(mut es) => es.remove(0),
                        _ => unreachable!(),
                    };
                    lhs = Expr {
                        kind: ExprKind::ArrayRepeat {
                            value: Box::new(elem),
                            count: Box::new(rhs),
                        },
                        span,
                    };
                    continue;
                }
                if matches!(&rhs.kind, ExprKind::ArrayLit(es) if es.len() == 1) {
                    let elem = match rhs.kind {
                        ExprKind::ArrayLit(mut es) => es.remove(0),
                        _ => unreachable!(),
                    };
                    lhs = Expr {
                        kind: ExprKind::ArrayRepeat {
                            value: Box::new(elem),
                            count: Box::new(lhs),
                        },
                        span,
                    };
                    continue;
                }
            }

            lhs = Expr {
                kind: ExprKind::Binary {
                    op,
                    lhs: Box::new(lhs),
                    rhs: Box::new(rhs),
                },
                span,
            };
        }

        Ok(lhs)
    }

    fn parse_unary(&mut self) -> Result<Expr> {
        let mut ops = Vec::new();
        while self.check(&TokenKind::Minus) || self.check(&TokenKind::Plus) {
            if self.depth + ops.len() >= MAX_NESTING {
                return Err(self.error(format!("maximum nesting depth ({MAX_NESTING}) exceeded")));
            }
            let is_neg = self.check(&TokenKind::Minus);
            let span = self.peek().span;
            self.bump();
            if is_neg {
                ops.push(span);
            }
        }
        // `~x` (bitwise complement) sits at the same level as unary `-`.
        if self.check(&TokenKind::Tilde) {
            let span = self.peek().span;
            self.bump();
            let inner = self.parse_unary()?;
            return Ok(Expr {
                kind: ExprKind::Unary {
                    op: UnOp::BitNot,
                    expr: Box::new(inner),
                },
                span,
            });
        }
        let mut expr = self.parse_power()?;
        for span in ops.into_iter().rev() {
            expr = Expr {
                kind: ExprKind::Unary {
                    op: UnOp::Neg,
                    expr: Box::new(expr),
                },
                span,
            };
        }
        Ok(expr)
    }

    // Python `**` binds tighter than unary `-` and is right-associative (`-2 ** 2 == -4`)
    fn parse_power(&mut self) -> Result<Expr> {
        let base = self.parse_postfix()?;
        if self.check(&TokenKind::StarStar) {
            let span = self.peek().span;
            self.bump();
            self.enter_depth()?;
            let exp_res = self.parse_unary();
            self.depth -= 1;
            let exp = exp_res?;
            return Ok(Expr {
                kind: ExprKind::Binary {
                    op: BinOp::Pow,
                    lhs: Box::new(base),
                    rhs: Box::new(exp),
                },
                span,
            });
        }
        Ok(base)
    }

    fn parse_postfix(&mut self) -> Result<Expr> {
        let mut expr = self.parse_primary()?;
        loop {
            if self.check(&TokenKind::LBracket) {
                let span = self.peek().span;
                self.bump();
                if self.check(&TokenKind::Colon) {
                    self.bump();
                    let stop = if !self.check(&TokenKind::Colon) && !self.check(&TokenKind::RBracket)
                    {
                        Some(Box::new(self.parse_expr()?))
                    } else {
                        None
                    };
                    let step = if self.check(&TokenKind::Colon) {
                        self.bump();
                        if !self.check(&TokenKind::RBracket) {
                            Some(Box::new(self.parse_expr()?))
                        } else {
                            None
                        }
                    } else {
                        None
                    };
                    self.expect(TokenKind::RBracket, "`]`")?;
                    expr = Expr {
                        kind: ExprKind::Slice {
                            target: Box::new(expr),
                            start: None,
                            stop,
                            step,
                        },
                        span,
                    };
                } else {
                    let first = self.parse_expr()?;
                    if self.check(&TokenKind::Colon) {
                        self.bump();
                        let stop =
                            if !self.check(&TokenKind::Colon) && !self.check(&TokenKind::RBracket) {
                                Some(Box::new(self.parse_expr()?))
                            } else {
                                None
                            };
                        let step = if self.check(&TokenKind::Colon) {
                            self.bump();
                            if !self.check(&TokenKind::RBracket) {
                                Some(Box::new(self.parse_expr()?))
                            } else {
                                None
                            }
                        } else {
                            None
                        };
                        self.expect(TokenKind::RBracket, "`]`")?;
                        expr = Expr {
                            kind: ExprKind::Slice {
                                target: Box::new(expr),
                                start: Some(Box::new(first)),
                                stop,
                                step,
                            },
                            span,
                        };
                    } else {
                        self.expect(TokenKind::RBracket, "`]`")?;
                        expr = Expr {
                            kind: ExprKind::Index {
                                target: Box::new(expr),
                                index: Box::new(first),
                            },
                            span,
                        };
                    }
                }
            } else if self.check(&TokenKind::Dot) {
                let span = self.peek().span;
                self.bump();
                let member = self.expect_ident("a field or method name after `.`")?;
                if self.check(&TokenKind::LParen) {
                    self.bump();
                    let mut pos_args = Vec::new();
                    let mut kw_args = Vec::new();
                    if !self.check(&TokenKind::RParen) {
                        loop {
                            if self.check(&TokenKind::RParen) {
                                break;
                            }
                            if matches!(&self.peek().kind, TokenKind::Ident(_))
                                && self.peek_at(1).kind == TokenKind::Eq
                            {
                                let kw_span = self.peek().span;
                                let kw = self.expect_ident("keyword argument name")?;
                                self.bump(); // `=`
                                let val = self.parse_expr()?;
                                kw_args.push((kw, val, kw_span));
                            } else {
                                if !kw_args.is_empty() {
                                    return Err(Diagnostic::new(
                                        "positional argument cannot follow keyword argument",
                                        self.peek().span,
                                    ));
                                }
                                let first_arg = self.parse_expr()?;
                                if pos_args.is_empty()
                                    && kw_args.is_empty()
                                    && self.check(&TokenKind::For)
                                {
                                    let arg_span = first_arg.span;
                                    let clauses = self.parse_comp_clauses()?;
                                    pos_args.push(Expr {
                                        kind: ExprKind::GenExpr {
                                            elt: Box::new(first_arg),
                                            clauses,
                                        },
                                        span: arg_span,
                                    });
                                    break;
                                }
                                pos_args.push(first_arg);
                            }
                            if self.check(&TokenKind::Comma) {
                                self.bump();
                            } else {
                                break;
                            }
                        }
                    }
                    self.expect(TokenKind::RParen, "`)`")?;
                    expr = if kw_args.is_empty() {
                        Expr {
                            kind: ExprKind::MethodCall {
                                target: Box::new(expr),
                                method: member,
                                args: pos_args,
                            },
                            span,
                        }
                    } else {
                        Expr {
                            kind: ExprKind::MethodCallKw {
                                target: Box::new(expr),
                                method: member,
                                pos_args,
                                kw_args,
                            },
                            span,
                        }
                    };
                } else {
                    expr = Expr {
                        kind: ExprKind::Field {
                            target: Box::new(expr),
                            field: member,
                        },
                        span,
                    };
                }
            } else if self.check(&TokenKind::LParen) {
                let span = self.peek().span;
                self.bump();
                let mut args = Vec::new();
                if !self.check(&TokenKind::RParen) {
                    loop {
                        if self.check(&TokenKind::RParen) {
                            break;
                        }
                        args.push(self.parse_expr()?);
                        if self.check(&TokenKind::Comma) {
                            self.bump();
                        } else {
                            break;
                        }
                    }
                }
                self.expect(TokenKind::RParen, "`)`")?;
                expr = Expr {
                    kind: ExprKind::CallExpr {
                        callee: Box::new(expr),
                        args,
                    },
                    span,
                };
            } else {
                break;
            }
        }
        Ok(expr)
    }

    fn parse_primary(&mut self) -> Result<Expr> {
        let token = self.peek().clone();
        let span = token.span;

        match token.kind {
            TokenKind::Int(n) => {
                self.bump();
                Ok(Expr {
                    kind: ExprKind::Int(n),
                    span,
                })
            }
            TokenKind::Float(x) => {
                self.bump();
                Ok(Expr {
                    kind: ExprKind::Float(x),
                    span,
                })
            }
            TokenKind::Bool(value) => {
                self.bump();
                Ok(Expr {
                    kind: ExprKind::Bool(value),
                    span,
                })
            }
            TokenKind::NoneLit => {
                self.bump();
                Ok(Expr {
                    kind: ExprKind::NoneLit,
                    span,
                })
            }
            TokenKind::Str(s) => {
                self.bump();
                Ok(Expr {
                    kind: ExprKind::Str(s),
                    span,
                })
            }
            TokenKind::FStr(raw_parts) => {
                self.bump();
                let mut parts = Vec::with_capacity(raw_parts.len());
                for (is_expr, text) in raw_parts {
                    if !is_expr {
                        parts.push(FStrPart::Lit(text));
                    } else {
                        let (body, spec) = match text.find('\u{1}') {
                            Some(i) => (text[..i].to_string(), Some(text[i + 1..].to_string())),
                            None => (text.clone(), None),
                        };
                        let text = body;
                        let sub_tokens = crate::lexer::Lexer::new(&text).tokenize().map_err(|d| {
                            Diagnostic::new(format!("in f-string: {}", d.message), span)
                        })?;
                        let mut sub = Parser::new(sub_tokens);
                        sub.depth = self.depth;
                        let expr = sub.parse_expr().map_err(|d| {
                            Diagnostic::new(format!("in f-string: {}", d.message), span)
                        })?;
                        sub.skip_newlines();
                        if !sub.check(&TokenKind::Eof) {
                            return Err(Diagnostic::new(
                                format!(
                                    "unexpected token {} inside f-string expression",
                                    sub.peek().kind.describe()
                                ),
                                span,
                            ));
                        }
                        match spec {
                            Some(spec) if !spec.is_empty() => {
                                parts.push(FStrPart::Spec { expr, spec })
                            }
                            _ => parts.push(FStrPart::Expr(expr)),
                        }
                    }
                }
                Ok(Expr {
                    kind: ExprKind::FString(parts),
                    span,
                })
            }
            TokenKind::Ident(name) => {
                self.bump();
                let explicit_targs = self.try_parse_explicit_type_args();
                if self.check(&TokenKind::LParen) {
                    self.bump();
                    let mut pos_args = Vec::new();
                    let mut kw_args = Vec::new();
                    if !self.check(&TokenKind::RParen) {
                        loop {
                            if self.check(&TokenKind::RParen) {
                                break;
                            }
                            if matches!(&self.peek().kind, TokenKind::Ident(_))
                                && self.peek_at(1).kind == TokenKind::Eq
                            {
                                let kw_span = self.peek().span;
                                let kw = self.expect_ident("keyword argument name")?;
                                self.bump(); // `=`
                                let val = self.parse_expr()?;
                                kw_args.push((kw, val, kw_span));
                            } else {
                                if !kw_args.is_empty() {
                                    return Err(Diagnostic::new(
                                        "positional argument cannot follow keyword argument",
                                        self.peek().span,
                                    ));
                                }
                                let first_arg = self.parse_expr()?;
                                if pos_args.is_empty()
                                    && kw_args.is_empty()
                                    && self.check(&TokenKind::For)
                                {
                                    let arg_span = first_arg.span;
                                    let clauses = self.parse_comp_clauses()?;
                                    pos_args.push(Expr {
                                        kind: ExprKind::GenExpr {
                                            elt: Box::new(first_arg),
                                            clauses,
                                        },
                                        span: arg_span,
                                    });
                                    break;
                                }
                                pos_args.push(first_arg);
                            }
                            if self.check(&TokenKind::Comma) {
                                self.bump();
                            } else {
                                break;
                            }
                        }
                    }
                    self.expect(TokenKind::RParen, "`)`")?;
                    if let Some(type_args) = explicit_targs {
                        Ok(Expr {
                            kind: ExprKind::CallGeneric {
                                name,
                                type_args,
                                pos_args,
                                kw_args,
                            },
                            span,
                        })
                    } else if kw_args.is_empty() {
                        Ok(Expr {
                            kind: ExprKind::Call {
                                name,
                                args: pos_args,
                            },
                            span,
                        })
                    } else {
                        Ok(Expr {
                            kind: ExprKind::CallKw {
                                name,
                                pos_args,
                                kw_args,
                            },
                            span,
                        })
                    }
                } else if name == "__name__" {
                    Ok(Expr {
                        kind: ExprKind::Str("__main__".to_string()),
                        span,
                    })
                } else {
                    Ok(Expr {
                        kind: ExprKind::Var(name),
                        span,
                    })
                }
            }
            TokenKind::LBracket => {
                self.bump();
                if self.check(&TokenKind::RBracket) {
                    self.bump();
                    return Ok(Expr {
                        kind: ExprKind::ArrayLit(Vec::new()),
                        span,
                    });
                }
                let first = self.parse_expr()?;
                if self.check(&TokenKind::For) {
                    let clauses = self.parse_comp_clauses()?;
                    self.expect(TokenKind::RBracket, "`]`")?;
                    return Ok(Expr {
                        kind: ExprKind::ListComp {
                            elt: Box::new(first),
                            clauses,
                        },
                        span,
                    });
                }
                if self.check(&TokenKind::Semicolon) {
                    self.bump();
                    let count = self.parse_expr()?;
                    self.expect(TokenKind::RBracket, "`]`")?;
                    return Ok(Expr {
                        kind: ExprKind::ArrayRepeat {
                            value: Box::new(first),
                            count: Box::new(count),
                        },
                        span,
                    });
                }
                let mut elems = vec![first];
                while self.check(&TokenKind::Comma) {
                    self.bump();
                    if self.check(&TokenKind::RBracket) {
                        break;
                    }
                    elems.push(self.parse_expr()?);
                }
                self.expect(TokenKind::RBracket, "`]`")?;
                Ok(Expr {
                    kind: ExprKind::ArrayLit(elems),
                    span,
                })
            }
            TokenKind::LBrace => {
                self.bump();
                if self.check(&TokenKind::RBrace) {
                    self.bump();
                    return Ok(Expr {
                        kind: ExprKind::DictLit(Vec::new()),
                        span,
                    });
                }
                let first = self.parse_expr()?;
                if self.check(&TokenKind::Colon) {
                    self.bump();
                    let first_val = self.parse_expr()?;
                    if self.check(&TokenKind::For) {
                        let clauses = self.parse_comp_clauses()?;
                        self.expect(TokenKind::RBrace, "`}`")?;
                        return Ok(Expr {
                            kind: ExprKind::DictComp {
                                key: Box::new(first),
                                val: Box::new(first_val),
                                clauses,
                            },
                            span,
                        });
                    }
                    let mut pairs = vec![(first, first_val)];
                    while self.check(&TokenKind::Comma) {
                        self.bump();
                        if self.check(&TokenKind::RBrace) {
                            break;
                        }
                        let k = self.parse_expr()?;
                        if !self.check(&TokenKind::Colon) {
                            return Err(Diagnostic::new(
                                "expected `:` after dictionary key (mixing `k: v` and bare values in `{...}` is invalid)",
                                self.peek().span,
                            ));
                        }
                        self.bump();
                        let v = self.parse_expr()?;
                        pairs.push((k, v));
                    }
                    self.expect(TokenKind::RBrace, "`}`")?;
                    Ok(Expr {
                        kind: ExprKind::DictLit(pairs),
                        span,
                    })
                } else {
                    if self.check(&TokenKind::For) {
                        let clauses = self.parse_comp_clauses()?;
                        self.expect(TokenKind::RBrace, "`}`")?;
                        return Ok(Expr {
                            kind: ExprKind::SetComp {
                                elt: Box::new(first),
                                clauses,
                            },
                            span,
                        });
                    }
                    let mut elems = vec![first];
                    while self.check(&TokenKind::Comma) {
                        self.bump();
                        if self.check(&TokenKind::RBrace) {
                            break;
                        }
                        let e = self.parse_expr()?;
                        if self.check(&TokenKind::Colon) {
                            return Err(Diagnostic::new(
                                "unexpected `:` inside set literal `{...}`",
                                self.peek().span,
                            ));
                        }
                        elems.push(e);
                    }
                    self.expect(TokenKind::RBrace, "`}`")?;
                    Ok(Expr {
                        kind: ExprKind::SetLit(elems),
                        span,
                    })
                }
            }
            TokenKind::LParen => {
                self.bump();
                if self.check(&TokenKind::RParen) {
                    self.bump();
                    return Ok(Expr {
                        kind: ExprKind::TupleLit(Vec::new()),
                        span,
                    });
                }
                let first = self.parse_expr()?;
                if self.check(&TokenKind::For) {
                    let clauses = self.parse_comp_clauses()?;
                    self.expect(TokenKind::RParen, "`)`")?;
                    return Ok(Expr {
                        kind: ExprKind::GenExpr {
                            elt: Box::new(first),
                            clauses,
                        },
                        span,
                    });
                }
                if self.check(&TokenKind::Comma) {
                    self.bump();
                    let mut elems = vec![first];
                    while !self.check(&TokenKind::RParen) {
                        elems.push(self.parse_expr()?);
                        if self.check(&TokenKind::Comma) {
                            self.bump();
                        } else {
                            break;
                        }
                    }
                    self.expect(TokenKind::RParen, "`)`")?;
                    Ok(Expr {
                        kind: ExprKind::TupleLit(elems),
                        span,
                    })
                } else {
                    self.expect(TokenKind::RParen, "`)`")?;
                    Ok(first)
                }
            }
            _ => Err(Diagnostic::new(
                format!("expected an expression, found {}", token.kind.describe()),
                span,
            )),
        }
    }

    fn expect(&mut self, kind: TokenKind, what: &str) -> Result<Token> {
        if self.check(&kind) {
            return Ok(self.bump());
        }
        // Python allows `;` as a simple-statement terminator (`a = 1; b = 2`), so a required
        // newline is satisfied by a semicolon followed by one. The following newline is left in
        // place, which collapses the extra blank statement harmlessly.
        if kind == TokenKind::Newline && self.check(&TokenKind::Semicolon) {
            return Ok(self.bump());
        }
        {
            Err(self.error(format!(
                "expected {what}, found {}",
                self.peek().kind.describe()
            )))
        }
    }

    fn expect_ident(&mut self, what: &str) -> Result<String> {
        let token = self.peek().clone();
        match token.kind {
            TokenKind::Ident(name) => {
                self.bump();
                Ok(name)
            }
            _ => Err(self.error(format!(
                "expected {what}, found {}",
                token.kind.describe()
            ))),
        }
    }

    fn check(&self, kind: &TokenKind) -> bool {
        &self.peek().kind == kind
    }

    fn bump(&mut self) -> Token {
        let token = self.tokens[self.pos].clone();
        if self.pos + 1 < self.tokens.len() {
            self.pos += 1;
        }
        token
    }

    fn peek(&self) -> &Token {
        &self.tokens[self.pos]
    }

    fn peek_at(&self, offset: usize) -> &Token {
        let idx = (self.pos + offset).min(self.tokens.len() - 1);
        &self.tokens[idx]
    }

    fn error(&self, message: impl Into<String>) -> Diagnostic {
        Diagnostic::new(message, self.peek().span)
    }

    fn skip_newlines(&mut self) {
        while self.check(&TokenKind::Newline) {
            self.bump();
        }
    }
}

fn rewrite_main_calls_in_stmts(stmts: &mut [Stmt]) {
    for s in stmts {
        match &mut s.kind {
            StmtKind::ForElse { body, else_body } => {
                rewrite_main_calls_in_stmts(body);
                rewrite_main_calls_in_stmts(else_body);
            }
            StmtKind::Let { value, .. } => rewrite_main_calls_in_expr(value),
            StmtKind::Assign { target, value, .. } => {
                match target {
                    AssignTarget::Var(_) => {}
                    AssignTarget::Index { target, index } => {
                        rewrite_main_calls_in_expr(target);
                        rewrite_main_calls_in_expr(index);
                    }
                    AssignTarget::Field { target, .. } => rewrite_main_calls_in_expr(target),
                }
                rewrite_main_calls_in_expr(value);
            }
            StmtKind::Return(Some(e)) | StmtKind::Expr(e) => rewrite_main_calls_in_expr(e),
            StmtKind::Del { .. } | StmtKind::Global { .. } => {}
            StmtKind::Assert { cond, msg } => {
                rewrite_main_calls_in_expr(cond);
                if let Some(m) = msg {
                    rewrite_main_calls_in_expr(m);
                }
            }
            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                rewrite_main_calls_in_expr(cond);
                rewrite_main_calls_in_stmts(then_body);
                if let Some(eb) = else_body {
                    rewrite_main_calls_in_stmts(eb);
                }
            }
            StmtKind::While { cond, body } => {
                rewrite_main_calls_in_expr(cond);
                rewrite_main_calls_in_stmts(body);
            }
            StmtKind::For {
                start,
                end,
                step,
                body,
                else_body,
                ..
            } => {
                rewrite_main_calls_in_expr(start);
                rewrite_main_calls_in_expr(end);
                if let Some(se) = step {
                    rewrite_main_calls_in_expr(se);
                }
                rewrite_main_calls_in_stmts(body);
                if let Some(e) = else_body {
                    rewrite_main_calls_in_stmts(e);
                }
            }
            StmtKind::ForEach {
                iter,
                body,
                else_body,
                ..
            } => {
                rewrite_main_calls_in_expr(iter);
                rewrite_main_calls_in_stmts(body);
                if let Some(e) = else_body {
                    rewrite_main_calls_in_stmts(e);
                }
            }
            StmtKind::ForEnumerate {
                iter, start, body, ..
            } => {
                rewrite_main_calls_in_expr(iter);
                if let Some(st) = start {
                    rewrite_main_calls_in_expr(st);
                }
                rewrite_main_calls_in_stmts(body);
            }
            StmtKind::ForDictItems { dict, body, .. } => {
                rewrite_main_calls_in_expr(dict);
                rewrite_main_calls_in_stmts(body);
            }
            StmtKind::ForZip { iters, body, .. } => {
                for it in iters {
                    rewrite_main_calls_in_expr(it);
                }
                rewrite_main_calls_in_stmts(body);
            }
            StmtKind::ForTupleUnpack { iter, body, .. } => {
                rewrite_main_calls_in_expr(iter);
                rewrite_main_calls_in_stmts(body);
            }
            StmtKind::TupleAssign { value, .. } => rewrite_main_calls_in_expr(value),
            StmtKind::Match { subject, cases } => {
                rewrite_main_calls_in_expr(subject);
                for c in cases {
                    if let Some(g) = &mut c.guard {
                        rewrite_main_calls_in_expr(g);
                    }
                    rewrite_main_calls_in_stmts(&mut c.body);
                }
            }
            StmtKind::Region { body } => rewrite_main_calls_in_stmts(body),
            StmtKind::Return(None) | StmtKind::Pass | StmtKind::Break | StmtKind::Continue => {}
        }
    }
}

fn stmts_have_value_return(stmts: &[Stmt]) -> bool {
    for s in stmts {
        match &s.kind {
            StmtKind::Return(Some(_)) => return true,
            StmtKind::If {
                then_body,
                else_body,
                ..
            } => {
                if stmts_have_value_return(then_body) {
                    return true;
                }
                if let Some(eb) = else_body {
                    if stmts_have_value_return(eb) {
                        return true;
                    }
                }
            }
            StmtKind::Match { cases, .. } => {
                for c in cases {
                    if stmts_have_value_return(&c.body) {
                        return true;
                    }
                }
            }
            StmtKind::While { body, .. }
            | StmtKind::ForEnumerate { body, .. }
            | StmtKind::ForDictItems { body, .. }
            | StmtKind::ForZip { body, .. }
            | StmtKind::ForTupleUnpack { body, .. }
            | StmtKind::Region { body } => {
                if stmts_have_value_return(body) {
                    return true;
                }
            }
            StmtKind::ForElse { body, else_body } => {
                if stmts_have_value_return(body) || stmts_have_value_return(else_body) {
                    return true;
                }
            }
            StmtKind::For {
                body, else_body, ..
            }
            | StmtKind::ForEach {
                body, else_body, ..
            } => {
                if stmts_have_value_return(body) {
                    return true;
                }
                if let Some(e) = else_body {
                    if stmts_have_value_return(e) {
                        return true;
                    }
                }
            }
            _ => {}
        }
    }
    false
}

fn rewrite_main_calls_in_expr(expr: &mut Expr) {
    match &mut expr.kind {
        ExprKind::CompareChain(operands) => {
            for (e, _) in operands {
                rewrite_main_calls_in_expr(e);
            }
        }
        ExprKind::PercentFormat { args, .. } => rewrite_main_calls_in_expr(args),
        ExprKind::Call { name, args } => {
            if name == "main" {
                *name = "__archx_user_main".to_string();
            }
            for a in args {
                rewrite_main_calls_in_expr(a);
            }
        }
        ExprKind::CallKw {
            name,
            pos_args,
            kw_args,
        } => {
            if name == "main" {
                *name = "__archx_user_main".to_string();
            }
            for a in pos_args {
                rewrite_main_calls_in_expr(a);
            }
            for (_, v, _) in kw_args {
                rewrite_main_calls_in_expr(v);
            }
        }
        ExprKind::CallGeneric {
            name,
            pos_args,
            kw_args,
            ..
        } => {
            if name == "main" {
                *name = "__archx_user_main".to_string();
            }
            for a in pos_args {
                rewrite_main_calls_in_expr(a);
            }
            for (_, v, _) in kw_args {
                rewrite_main_calls_in_expr(v);
            }
        }
        ExprKind::CallExpr { callee, args } => {
            rewrite_main_calls_in_expr(callee);
            for a in args {
                rewrite_main_calls_in_expr(a);
            }
        }
        ExprKind::MethodCall { target, args, .. } => {
            rewrite_main_calls_in_expr(target);
            for a in args {
                rewrite_main_calls_in_expr(a);
            }
        }
        ExprKind::MethodCallKw {
            target,
            pos_args,
            kw_args,
            ..
        } => {
            rewrite_main_calls_in_expr(target);
            for a in pos_args {
                rewrite_main_calls_in_expr(a);
            }
            for (_, v, _) in kw_args {
                rewrite_main_calls_in_expr(v);
            }
        }
        ExprKind::ListComp { elt, clauses }
        | ExprKind::SetComp { elt, clauses }
        | ExprKind::GenExpr { elt, clauses } => {
            rewrite_main_calls_in_expr(elt);
            for cl in clauses {
                rewrite_main_calls_in_expr(&mut cl.iter);
                for c in &mut cl.conds {
                    rewrite_main_calls_in_expr(c);
                }
            }
        }
        ExprKind::DictComp { key, val, clauses } => {
            rewrite_main_calls_in_expr(key);
            rewrite_main_calls_in_expr(val);
            for cl in clauses {
                rewrite_main_calls_in_expr(&mut cl.iter);
                for c in &mut cl.conds {
                    rewrite_main_calls_in_expr(c);
                }
            }
        }
        ExprKind::Lambda { body, .. } => {
            rewrite_main_calls_in_expr(body);
        }
        ExprKind::FString(parts) => {
            for p in parts {
                if let FStrPart::Expr(e) = p {
                    rewrite_main_calls_in_expr(e);
                }
            }
        }
        ExprKind::IfExpr {
            then_expr,
            cond,
            else_expr,
        } => {
            rewrite_main_calls_in_expr(then_expr);
            rewrite_main_calls_in_expr(cond);
            rewrite_main_calls_in_expr(else_expr);
        }
        ExprKind::ArrayLit(es) | ExprKind::SetLit(es) | ExprKind::TupleLit(es) => {
            for e in es {
                rewrite_main_calls_in_expr(e);
            }
        }
        ExprKind::DictLit(pairs) => {
            for (k, v) in pairs {
                rewrite_main_calls_in_expr(k);
                rewrite_main_calls_in_expr(v);
            }
        }
        ExprKind::ArrayRepeat { value, count } => {
            rewrite_main_calls_in_expr(value);
            rewrite_main_calls_in_expr(count);
        }
        ExprKind::Index { target, index } => {
            rewrite_main_calls_in_expr(target);
            rewrite_main_calls_in_expr(index);
        }
        ExprKind::Slice {
            target,
            start,
            stop,
            step,
        } => {
            rewrite_main_calls_in_expr(target);
            if let Some(s) = start {
                rewrite_main_calls_in_expr(s);
            }
            if let Some(e) = stop {
                rewrite_main_calls_in_expr(e);
            }
            if let Some(st) = step {
                rewrite_main_calls_in_expr(st);
            }
        }
        ExprKind::Field { target, .. } | ExprKind::Unary { expr: target, .. } => {
            rewrite_main_calls_in_expr(target)
        }
        ExprKind::Binary { lhs, rhs, .. } => {
            rewrite_main_calls_in_expr(lhs);
            rewrite_main_calls_in_expr(rhs);
        }
        ExprKind::Int(_)
        | ExprKind::Float(_)
        | ExprKind::Bool(_)
        | ExprKind::NoneLit
        | ExprKind::Str(_)
        | ExprKind::Var(_) => {}
    }
}

fn infer_fields_from_init(init_fn: &Func) -> Vec<Param> {
    let mut fields: Vec<Param> = Vec::new();
    for stmt in &init_fn.body {
        if let StmtKind::Assign {
            target: AssignTarget::Field { target, field },
            op: None,
            value,
        } = &stmt.kind
        {
            if matches!(&target.kind, ExprKind::Var(v) if v == "self")
                && !fields.iter().any(|f| f.name == *field)
            {
                let ty = match &value.kind {
                    ExprKind::Var(pname) => init_fn
                        .params
                        .iter()
                        .find(|p| p.name == *pname)
                        .map(|p| p.ty.clone())
                        .unwrap_or(Type::Any),
                    ExprKind::Int(_) => Type::Int,
                    ExprKind::Float(_) => Type::Float,
                    ExprKind::Bool(_) => Type::Bool,
                    ExprKind::Str(_) | ExprKind::FString(_) => Type::Str,
                    _ => Type::Any,
                };
                fields.push(Param {
                    name: field.clone(),
                    ty,
                    default: None,
                });
            }
        }
    }
    fields
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::lexer::Lexer;

    fn parse(src: &str) -> Program {
        let tokens = Lexer::new(src).tokenize().unwrap();
        Parser::new(tokens).parse_program().unwrap()
    }

    #[test]
    fn parses_main_and_print() {
        let program = parse("func main():\n    print(\"hello\")\n");
        assert_eq!(program.funcs.len(), 1);
        assert_eq!(program.funcs[0].name, "main");
        assert_eq!(program.funcs[0].body.len(), 1);
    }

    #[test]
    fn parses_let_and_arithmetic() {
        let program = parse("func main():\n    let x = 1 + 2 * 3\n    print(x)\n");
        assert_eq!(program.funcs[0].body.len(), 2);
    }

    #[test]
    fn parses_functions_with_params() {
        let program = parse("func add(a: int, b: int) -> int:\n    return a + b\n");
        assert_eq!(program.funcs[0].params.len(), 2);
        assert!(program.funcs[0].ret.is_some());
    }

    #[test]
    fn parses_if_else() {
        let program = parse(
            "func main():\n    let x = 1\n    if x > 0:\n        print(\"yes\")\n    else:\n        print(\"no\")\n",
        );
        assert_eq!(program.funcs[0].body.len(), 2);
    }

    #[test]
    fn parses_elif_chain() {
        let program = parse(
            "func main():\n    let x = 2\n    if x == 1:\n        print(1)\n    elif x == 2:\n        print(2)\n    else:\n        print(3)\n",
        );
        assert_eq!(program.funcs[0].body.len(), 2);
    }

    #[test]
    fn parses_booleans_and_comparisons() {
        let program = parse("func main():\n    let b = 1 < 2 and not false\n    print(b)\n");
        assert_eq!(program.funcs[0].body.len(), 2);
    }

    #[test]
    fn parses_while_and_assignment() {
        let program = parse(
            "func main():\n    let n = 0\n    while n < 5:\n        n = n + 1\n    print(n)\n",
        );
        assert_eq!(program.funcs[0].body.len(), 3);
    }

    #[test]
    fn parses_for_and_break_continue() {
        let program = parse(
            "func main():\n    for i in 0..10:\n        if i == 3:\n            continue\n        if i == 7:\n            break\n        print(i)\n",
        );
        assert_eq!(program.funcs[0].body.len(), 1);
    }

    #[test]
    fn parses_arrays_indexing_and_compound_assign() {
        let program = parse(
            "func sum(xs: [int]) -> int:\n    let total = 0\n    for i in 0..len(xs):\n        total += xs[i]\n    return total\n\nfunc main():\n    let empty: [int] = []\n    let buf = [0; 8]\n    buf[0] = 10\n    buf[0] += 5\n    print(sum([1, 2, 3,]))\n",
        );
        assert_eq!(program.funcs.len(), 2);
        assert_eq!(program.funcs[0].params[0].ty, Type::Array(Box::new(Type::Int)));
    }

    #[test]
    fn parses_structs_regions_step_and_foreach() {
        let program = parse(
            "struct Point:\n    x: int\n    y: int\n\nfunc main():\n    region:\n        let pts = [Point(1, 2); 4]\n        pts[0].x += 5\n        for i in 0..4 step 2:\n            print(pts[i].x)\n        for p in pts:\n            print(p.y)\n",
        );
        assert_eq!(program.structs.len(), 1);
        assert_eq!(program.structs[0].fields.len(), 2);
        assert_eq!(program.funcs.len(), 1);
    }

    #[test]
    fn parses_pythonic_def_class_range_enumerate_fstring_and_script() {
        let program = parse(
            "\
class Vec2:
    x: float
    y: float

    def mag_sq(self) -> float:
        return self.x ** 2.0 + self.y ** 2.0

def scale(xs: list[int], k: int) -> None:
    for i, v in enumerate(xs):
        xs[i] = v * k

nums = [1] * 1_000
for i in range(0, len(nums), 2):
    nums[i] = i // 2
print(f\"count={len(nums)}\", end=\"\\n\")
",
        );
        assert_eq!(program.structs.len(), 1);
        assert_eq!(program.structs[0].methods.len(), 1);
        assert_eq!(program.funcs.len(), 2);
        assert_eq!(program.funcs[1].name, "main");
    }

    #[test]
    fn rejects_deeply_nested_unary_without_stack_overflow() {
        let mut src = String::from("func main():\n    let x = ");
        for _ in 0..300 {
            src.push('-');
        }
        src.push_str("1\n");
        let tokens = Lexer::new(&src).tokenize().unwrap();
        assert!(Parser::new(tokens).parse_program().is_err());
    }

    #[test]
    fn rejects_invalid_assignment_target() {
        let tokens = Lexer::new("func main():\n    1 + 2 = 3\n")
            .tokenize()
            .unwrap();
        assert!(Parser::new(tokens).parse_program().is_err());
    }

    #[test]
    fn rejects_missing_colon() {
        let tokens = Lexer::new("func main()\n    print(\"x\")\n").tokenize().unwrap();
        assert!(Parser::new(tokens).parse_program().is_err());
    }

    #[test]
    fn parses_enums_tuples_optionals_match_and_init_class() {
        let program = parse(
            "\
enum Event:
    Add(int, int)
    Reset

class Body:
    def __init__(self, x: float, mass: float):
        self.x = x
        self.mass = mass

def run(ev: Event) -> (int, int) | None:
    match ev:
        case Event.Add(a, b) if a >= 0:
            return a, b
        case Event.Add(_, _) | Event.Reset:
            return None
",
        );
        assert_eq!(program.enums.len(), 1);
        assert_eq!(program.enums[0].variants.len(), 2);
        assert_eq!(program.structs.len(), 1);
        assert_eq!(program.structs[0].fields.len(), 2);
        assert_eq!(program.funcs.len(), 1);
    }
}


/// One module-level entry in source order: a foldable constant or an ordinary script statement.
enum ModuleEntry {
    Const(GlobalConst),
    Stmt(Stmt),
}

/// Collects `global name` declarations so codegen can resolve those names to module-level
/// constants. The declaration itself is a no-op statement (see `StmtKind::Global`).
/// Parses a module-level literal binding (``NAME = 10``) into a constant so it does not run as part
/// of the script `main`. Module statements and their bindings keep their source order, so a name is
/// only constant-folded once nothing later depends on the in-order value.
fn script_binding_kind(stmt: &Stmt) -> Option<(String, Option<Type>, Expr, Span)> {
    fn is_literal(e: &Expr) -> bool {
        matches!(
            e.kind,
            ExprKind::Int(_)
                | ExprKind::Float(_)
                | ExprKind::Bool(_)
                | ExprKind::Str(_)
                | ExprKind::NoneLit
        )
    }
    match &stmt.kind {
        StmtKind::Let { name, ty, value } if is_literal(value) => {
            Some((name.clone(), ty.clone(), value.clone(), stmt.span))
        }
        StmtKind::Assign {
            target: AssignTarget::Var(name),
            op: None,
            value,
        } if is_literal(value) => Some((name.clone(), None, value.clone(), stmt.span)),
        _ => None,
    }
}

/// Conservative "could this statement bind `name`" check used to decide whether a module-level
/// literal can be constant-folded.
fn stmt_binds_name(stmt: &Stmt, name: &str) -> bool {
    match &stmt.kind {
        StmtKind::Let { name: n, .. } | StmtKind::Del { name: n } => n == name,
        StmtKind::Assign { target, .. } => matches!(target, AssignTarget::Var(n) if n == name),
        StmtKind::TupleAssign { targets, .. } => targets.iter().any(|t| t == name),
        StmtKind::Global { names } => names.iter().any(|n| n == name),
        StmtKind::If {
            then_body,
            else_body,
            ..
        } => {
            then_body.iter().any(|s| stmt_binds_name(s, name))
                || else_body
                    .as_ref()
                    .map_or(false, |b| b.iter().any(|s| stmt_binds_name(s, name)))
        }
        StmtKind::While { body, .. }
        | StmtKind::For { body, .. }
        | StmtKind::ForEach { body, .. }
        | StmtKind::ForEnumerate { body, .. }
        | StmtKind::ForDictItems { body, .. }
        | StmtKind::ForZip { body, .. }
        | StmtKind::ForTupleUnpack { body, .. }
        | StmtKind::Region { body } => body.iter().any(|s| stmt_binds_name(s, name)),
        StmtKind::Match { cases, .. } => cases
            .iter()
            .any(|c| c.body.iter().any(|s| stmt_binds_name(s, name))),
        _ => false,
    }
}

fn collect_global_decls(stmts: &[Stmt]) -> Vec<String> {
    let mut out = Vec::new();
    for s in stmts {
        match &s.kind {
            StmtKind::Global { names } => {
                for n in names {
                    if !out.contains(n) {
                        out.push(n.clone());
                    }
                }
            }
            StmtKind::If {
                then_body,
                else_body,
                ..
            } => {
                out.extend(collect_global_decls(then_body));
                if let Some(eb) = else_body {
                    out.extend(collect_global_decls(eb));
                }
            }
            StmtKind::While { body, .. }
            | StmtKind::For { body, .. }
            | StmtKind::ForEach { body, .. }
            | StmtKind::ForEnumerate { body, .. }
            | StmtKind::ForDictItems { body, .. }
            | StmtKind::ForZip { body, .. }
            | StmtKind::ForTupleUnpack { body, .. }
            | StmtKind::Region { body } => out.extend(collect_global_decls(body)),
            _ => {}
        }
    }
    out
}
