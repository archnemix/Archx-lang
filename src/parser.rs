use crate::ast::*;
use crate::diag::{Diagnostic, Result};
use crate::token::{Token, TokenKind};

/// Recursive-descent parser.
///
/// Grammar (milestone 1):
///
/// ```text
/// program     := func_def*
/// func_def    := "func" IDENT "(" params? ")" ("->" type)? ":" NEWLINE INDENT stmt+ DEDENT
/// params      := param ("," param)*
/// param       := IDENT ":" type
/// type        := "int" | "string" | "void"
/// stmt        := "let" IDENT "=" expr NEWLINE
///              | "return" expr? NEWLINE
///              | expr NEWLINE
/// expr        := additive
/// additive    := multiplicative (("+" | "-") multiplicative)*
/// multiplicative := unary (("*" | "/") unary)*
/// unary       := "-" unary | primary
/// primary     := INT | STRING | IDENT | IDENT "(" args? ")" | "(" expr ")"
/// args        := expr ("," expr)*
/// ```
pub struct Parser {
    tokens: Vec<Token>,
    pos: usize,
}

impl Parser {
    pub fn new(tokens: Vec<Token>) -> Self {
        Self { tokens, pos: 0 }
    }

    pub fn parse_program(&mut self) -> Result<Program> {
        let mut funcs = Vec::new();
        self.skip_newlines();

        while !self.check(&TokenKind::Eof) {
            funcs.push(self.parse_func()?);
            self.skip_newlines();
        }

        Ok(Program { funcs })
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

        let mut body = Vec::new();
        loop {
            self.skip_newlines();
            if self.check(&TokenKind::Dedent) || self.check(&TokenKind::Eof) {
                break;
            }
            body.push(self.parse_stmt()?);
        }

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
        let token = self.peek().clone();
        match &token.kind {
            TokenKind::Ident(name) if name == "int" => {
                self.bump();
                Ok(Type::Int)
            }
            TokenKind::Ident(name) if name == "string" => {
                self.bump();
                Ok(Type::Str)
            }
            TokenKind::Ident(name) if name == "void" => {
                self.bump();
                Ok(Type::Void)
            }
            _ => Err(Diagnostic::new(
                "expected a type (`int`, `string`, or `void`)",
                token.span,
            )),
        }
    }

    fn parse_stmt(&mut self) -> Result<Stmt> {
        let span = self.peek().span;

        if self.check(&TokenKind::Let) {
            self.bump();
            let name = self.expect_ident("a variable name")?;
            self.expect(TokenKind::Eq, "`=`")?;
            let value = self.parse_expr()?;
            self.expect(TokenKind::Newline, "a newline after the statement")?;
            return Ok(Stmt {
                kind: StmtKind::Let { name, value },
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

        let value = self.parse_expr()?;
        self.expect(TokenKind::Newline, "a newline after the statement")?;
        Ok(Stmt {
            kind: StmtKind::Expr(value),
            span,
        })
    }

    fn parse_expr(&mut self) -> Result<Expr> {
        self.parse_additive()
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
        if self.check(&TokenKind::Minus) {
            let span = self.peek().span;
            self.bump();
            let expr = self.parse_unary()?;
            return Ok(Expr {
                kind: ExprKind::Unary {
                    op: UnOp::Neg,
                    expr: Box::new(expr),
                },
                span,
            });
        }

        self.parse_primary()
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
    fn rejects_missing_colon() {
        let tokens = Lexer::new("func main()\n    print(\"x\")\n").tokenize().unwrap();
        assert!(Parser::new(tokens).parse_program().is_err());
    }
}
