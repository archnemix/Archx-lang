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
        let mut funcs = Vec::new();
        let mut top_stmts = Vec::new();
        self.skip_newlines();

        while !self.check(&TokenKind::Eof) {
            if self.check(&TokenKind::Struct) {
                structs.push(self.parse_struct()?);
            } else if self.check(&TokenKind::Func) {
                funcs.push(self.parse_func()?);
            } else {
                top_stmts.push(self.parse_stmt()?);
            }
            self.skip_newlines();
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
                params: Vec::new(),
                ret: None,
                body: top_stmts,
                span: script_span,
            });
        }

        Ok(Program { structs, funcs })
    }

    fn parse_struct(&mut self) -> Result<StructDef> {
        let span = self.peek().span;
        self.expect(TokenKind::Struct, "`class` or `struct`")?;
        let name = self.expect_ident("a class/struct name")?;
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
            });
        }

        self.expect(TokenKind::Dedent, "the end of the class/struct body")?;
        if fields.is_empty() {
            return Err(Diagnostic::new(
                "class/struct must have at least one field",
                span,
            ));
        }

        Ok(StructDef {
            name,
            fields,
            methods,
            span,
        })
    }

    fn parse_method(&mut self, struct_name: &str) -> Result<Func> {
        let span = self.peek().span;
        self.expect(TokenKind::Func, "`def`")?;
        let name = self.expect_ident("a method name")?;
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
            if t != Type::Struct(struct_name.to_string()) {
                return Err(Diagnostic::new(
                    format!("`self` in `{struct_name}.{name}` must have type `{struct_name}`"),
                    span,
                ));
            }
            t
        } else {
            Type::Struct(struct_name.to_string())
        };
        params.push(Param {
            name: "self".to_string(),
            ty: self_ty,
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
            params.push(Param {
                name: param_name,
                ty,
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

        Ok(Func {
            name,
            params,
            ret,
            body,
            span,
        })
    }

    fn parse_func(&mut self) -> Result<Func> {
        let span = self.peek().span;

        self.expect(TokenKind::Func, "`def` or `func`")?;
        let name = self.expect_ident("a function name")?;
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
                params.push(Param {
                    name: param_name,
                    ty,
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

        Ok(Func {
            name,
            params,
            ret,
            body,
            span,
        })
    }

    fn parse_type(&mut self) -> Result<Type> {
        self.enter_depth()?;
        let res = self.parse_type_inner();
        self.depth -= 1;
        res
    }

    fn parse_type_inner(&mut self) -> Result<Type> {
        let token = self.peek().clone();
        match &token.kind {
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
            TokenKind::Ident(name) if name == "list" && self.peek_at(1).kind == TokenKind::LBracket => {
                self.bump();
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
            TokenKind::Ident(name) => {
                let sname = name.clone();
                self.bump();
                Ok(Type::Struct(sname))
            }
            _ => Err(Diagnostic::new(
                "expected a type (`int`, `float`, `bool`, `str`, `None`, `list[T]`, `[T]`, or class/struct name)",
                token.span,
            )),
        }
    }

    fn parse_stmt(&mut self) -> Result<Stmt> {
        let span = self.peek().span;

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

        if self.check(&TokenKind::Let) {
            self.bump();
            let name = self.expect_ident("a variable name")?;
            let ty = if self.check(&TokenKind::Colon) {
                self.bump();
                Some(self.parse_type()?)
            } else {
                None
            };
            self.expect(TokenKind::Eq, "`=`")?;
            let value = self.parse_expr()?;
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
            let value = self.parse_expr()?;
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
                Some(self.parse_expr()?)
            };
            self.expect(TokenKind::Newline, "a newline after the statement")?;
            return Ok(Stmt {
                kind: StmtKind::Return(value),
                span,
            });
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
            let var = self.expect_ident("a loop variable name")?;
            if self.check(&TokenKind::Comma) {
                self.bump();
                let elem_var = self.expect_ident("a second loop variable name")?;
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
                return Ok(Stmt {
                    kind: StmtKind::For {
                        var,
                        start: first,
                        end,
                        step,
                        body,
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
                return Ok(Stmt {
                    kind: StmtKind::For {
                        var,
                        start,
                        end,
                        step,
                        body,
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
            return Ok(Stmt {
                kind: StmtKind::ForEach {
                    var,
                    iter: first,
                    body,
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
            let value = self.parse_expr()?;
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

    // Python inline conditional: `then_expr if cond else else_expr`
    fn parse_if_expr(&mut self) -> Result<Expr> {
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
        let mut lhs = self.parse_additive()?;

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
                _ => break,
            };
            let rhs = self.parse_additive()?;
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
                        kind: ExprKind::MethodCall {
                            target: Box::new(expr),
                            method: member,
                            args,
                        },
                        span,
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
                        parts.push(FStrPart::Expr(expr));
                    }
                }
                Ok(Expr {
                    kind: ExprKind::FString(parts),
                    span,
                })
            }
            TokenKind::Ident(name) => {
                self.bump();
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
                                pos_args.push(self.parse_expr()?);
                            }
                            if self.check(&TokenKind::Comma) {
                                self.bump();
                            } else {
                                break;
                            }
                        }
                    }
                    self.expect(TokenKind::RParen, "`)`")?;
                    if kw_args.is_empty() {
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
                let expr = self.parse_expr()?;
                self.expect(TokenKind::RParen, "`)`")?;
                Ok(expr)
            }
            _ => Err(Diagnostic::new(
                format!("expected an expression, found {}", token.kind.describe()),
                span,
            )),
        }
    }

    fn expect(&mut self, kind: TokenKind, what: &str) -> Result<Token> {
        if self.check(&kind) {
            Ok(self.bump())
        } else {
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
                ..
            } => {
                rewrite_main_calls_in_expr(start);
                rewrite_main_calls_in_expr(end);
                if let Some(se) = step {
                    rewrite_main_calls_in_expr(se);
                }
                rewrite_main_calls_in_stmts(body);
            }
            StmtKind::ForEach { iter, body, .. } => {
                rewrite_main_calls_in_expr(iter);
                rewrite_main_calls_in_stmts(body);
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
            StmtKind::While { body, .. }
            | StmtKind::For { body, .. }
            | StmtKind::ForEach { body, .. }
            | StmtKind::ForEnumerate { body, .. }
            | StmtKind::ForDictItems { body, .. }
            | StmtKind::Region { body } => {
                if stmts_have_value_return(body) {
                    return true;
                }
            }
            _ => {}
        }
    }
    false
}

fn rewrite_main_calls_in_expr(expr: &mut Expr) {
    match &mut expr.kind {
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
        ExprKind::MethodCall { target, args, .. } => {
            rewrite_main_calls_in_expr(target);
            for a in args {
                rewrite_main_calls_in_expr(a);
            }
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
        ExprKind::ArrayLit(es) | ExprKind::SetLit(es) => {
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
}
