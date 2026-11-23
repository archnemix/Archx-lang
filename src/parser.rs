use crate::ast::*;
use crate::diag::{Diagnostic, Result, Span};
use crate::token::{Token, TokenKind};

const MAX_NESTING: usize = 128;

/// Recursive-descent parser (milestone 5: structs, regions, strided/foreach loops).
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
        self.skip_newlines();

        while !self.check(&TokenKind::Eof) {
            if self.check(&TokenKind::Struct) {
                structs.push(self.parse_struct()?);
            } else {
                funcs.push(self.parse_func()?);
            }
            self.skip_newlines();
        }

        Ok(Program { structs, funcs })
    }

    fn parse_struct(&mut self) -> Result<StructDef> {
        let span = self.peek().span;
        self.expect(TokenKind::Struct, "`struct`")?;
        let name = self.expect_ident("a struct name")?;
        self.expect(TokenKind::Colon, "`:`")?;
        self.expect(TokenKind::Newline, "a newline after `struct` header")?;
        self.expect(TokenKind::Indent, "an indented struct body")?;

        let mut fields = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::Dedent) || self.check(&TokenKind::Eof) {
                break;
            }
            let field_name = self.expect_ident("a field name")?;
            self.expect(TokenKind::Colon, "`:`")?;
            let ty = self.parse_type()?;
            self.expect(TokenKind::Newline, "a newline after field declaration")?;
            fields.push(Param {
                name: field_name,
                ty,
            });
        }

        self.expect(TokenKind::Dedent, "the end of the struct body")?;
        if fields.is_empty() {
            return Err(Diagnostic::new("struct must have at least one field", span));
        }

        Ok(StructDef { name, fields, span })
    }

    fn parse_func(&mut self) -> Result<Func> {
        let span = self.peek().span;

        self.expect(TokenKind::Func, "`func`")?;
        let name = self.expect_ident("a function name")?;
        self.expect(TokenKind::LParen, "`(`")?;

        let mut params = Vec::new();
        if !self.check(&TokenKind::RParen) {
            loop {
                let param_name = self.expect_ident("a parameter name")?;
                self.expect(TokenKind::Colon, "`:`")?;
                let ty = self.parse_type()?;
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

        let ret = if self.check(&TokenKind::Arrow) {
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
                        "array elements cannot have type `void`",
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
            TokenKind::Ident(name) if name == "bool" => {
                self.bump();
                Ok(Type::Bool)
            }
            TokenKind::Ident(name) if name == "string" => {
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
                "expected a type (`int`, `bool`, `string`, `void`, `[T]`, or struct name)",
                token.span,
            )),
        }
    }

    fn parse_stmt(&mut self) -> Result<Stmt> {
        let span = self.peek().span;

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

        if self.check(&TokenKind::Return) {
            self.bump();
            let value = if self.check(&TokenKind::Newline) {
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
            } else {
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
            TokenKind::SlashEq => Some(Some(BinOp::Div)),
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
        let res = self.parse_or();
        self.depth -= 1;
        res
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
        while self.check(&TokenKind::Not) {
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
            let op = match &self.peek().kind {
                TokenKind::EqEq => BinOp::Eq,
                TokenKind::NotEq => BinOp::Ne,
                TokenKind::Lt => BinOp::Lt,
                TokenKind::Gt => BinOp::Gt,
                TokenKind::Le => BinOp::Le,
                TokenKind::Ge => BinOp::Ge,
                _ => break,
            };
            let span = self.peek().span;
            self.bump();
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
                TokenKind::Percent => BinOp::Mod,
                _ => break,
            };
            let span = self.peek().span;
            self.bump();
            let rhs = self.parse_unary()?;
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
        let mut spans = Vec::new();
        while self.check(&TokenKind::Minus) {
            if self.depth + spans.len() >= MAX_NESTING {
                return Err(self.error(format!("maximum nesting depth ({MAX_NESTING}) exceeded")));
            }
            spans.push(self.peek().span);
            self.bump();
        }
        let mut expr = self.parse_postfix()?;
        for span in spans.into_iter().rev() {
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

    fn parse_postfix(&mut self) -> Result<Expr> {
        let mut expr = self.parse_primary()?;
        loop {
            if self.check(&TokenKind::LBracket) {
                let span = self.peek().span;
                self.bump();
                let index = self.parse_expr()?;
                self.expect(TokenKind::RBracket, "`]`")?;
                expr = Expr {
                    kind: ExprKind::Index {
                        target: Box::new(expr),
                        index: Box::new(index),
                    },
                    span,
                };
            } else if self.check(&TokenKind::Dot) {
                let span = self.peek().span;
                self.bump();
                let field = self.expect_ident("a field name after `.`")?;
                expr = Expr {
                    kind: ExprKind::Field {
                        target: Box::new(expr),
                        field,
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
            TokenKind::Bool(value) => {
                self.bump();
                Ok(Expr {
                    kind: ExprKind::Bool(value),
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
            TokenKind::Ident(name) => {
                self.bump();
                if self.check(&TokenKind::LParen) {
                    self.bump();
                    let mut args = Vec::new();
                    if !self.check(&TokenKind::RParen) {
                        loop {
                            args.push(self.parse_expr()?);
                            if self.check(&TokenKind::Comma) {
                                self.bump();
                            } else {
                                break;
                            }
                        }
                    }
                    self.expect(TokenKind::RParen, "`)`")?;
                    Ok(Expr {
                        kind: ExprKind::Call { name, args },
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

    fn error(&self, message: impl Into<String>) -> Diagnostic {
        Diagnostic::new(message, self.peek().span)
    }

    fn skip_newlines(&mut self) {
        while self.check(&TokenKind::Newline) {
            self.bump();
        }
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
            "func sum(xs: [int]) -> int:\n    let total = 0\n    for i in 0..len(xs):
        total += xs[i]\n    return total\n\nfunc main():\n    let empty: [int] = []\n    let buf = [0; 8]\n    buf[0] = 10\n    buf[0] += 5\n    print(sum([1, 2, 3,]))\n",
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
