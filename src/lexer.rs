use crate::diag::{Diagnostic, Result, Span};
use crate::token::{Token, TokenKind};

/// An indentation-aware lexer, in the style of Python.
///
/// Layout rules:
/// - Blocks are opened by indenting and closed by dedenting.
/// - Blank lines and comment-only lines do not affect indentation.
/// - A tab counts as advancing to the next multiple of 4 columns.
/// - Newlines inside parentheses are ignored, so calls can span lines.
pub struct Lexer<'a> {
    src: &'a [u8],
    pos: usize,
    line: usize,
    col: usize,
    indent_stack: Vec<usize>,
    at_line_start: bool,
    bracket_depth: usize,
}

impl<'a> Lexer<'a> {
    pub fn new(src: &'a str) -> Self {
        Self {
            src: src.as_bytes(),
            pos: 0,
            line: 1,
            col: 1,
            indent_stack: vec![0],
            at_line_start: true,
            bracket_depth: 0,
        }
    }

    pub fn tokenize(mut self) -> Result<Vec<Token>> {
        let mut tokens: Vec<Token> = Vec::new();

        loop {
            if self.at_line_start && self.bracket_depth == 0 {
                self.measure_and_emit_indent(&mut tokens)?;
                if self.at_line_start {
                    // The line was blank or a comment; look at the next line.
                    continue;
                }
            }

            self.skip_spaces();

            let Some(c) = self.peek() else {
                break;
            };

            let span = self.span();

            match c {
                b'\n' | b'\r' => {
                    self.bump();
                    if c == b'\r' && self.peek() == Some(b'\n') {
                        self.bump();
                    }
                    if self.bracket_depth == 0 {
                        tokens.push(Token::new(TokenKind::Newline, span));
                        self.at_line_start = true;
                    }
                }
                b'#' => self.skip_comment(),
                b'(' => {
                    self.bracket_depth += 1;
                    self.bump();
                    tokens.push(Token::new(TokenKind::LParen, span));
                }
                b')' => {
                    self.bracket_depth = self.bracket_depth.saturating_sub(1);
                    self.bump();
                    tokens.push(Token::new(TokenKind::RParen, span));
                }
                b'[' => {
                    self.bracket_depth += 1;
                    self.bump();
                    tokens.push(Token::new(TokenKind::LBracket, span));
                }
                b']' => {
                    self.bracket_depth = self.bracket_depth.saturating_sub(1);
                    self.bump();
                    tokens.push(Token::new(TokenKind::RBracket, span));
                }
                b';' => {
                    self.bump();
                    tokens.push(Token::new(TokenKind::Semicolon, span));
                }
                b',' => {
                    self.bump();
                    tokens.push(Token::new(TokenKind::Comma, span));
                }
                b'+' => {
                    self.bump();
                    if self.peek() == Some(b'=') {
                        self.bump();
                        tokens.push(Token::new(TokenKind::PlusEq, span));
                    } else {
                        tokens.push(Token::new(TokenKind::Plus, span));
                    }
                }
                b'-' => {
                    self.bump();
                    if self.peek() == Some(b'>') {
                        self.bump();
                        tokens.push(Token::new(TokenKind::Arrow, span));
                    } else if self.peek() == Some(b'=') {
                        self.bump();
                        tokens.push(Token::new(TokenKind::MinusEq, span));
                    } else {
                        tokens.push(Token::new(TokenKind::Minus, span));
                    }
                }
                b'*' => {
                    self.bump();
                    if self.peek() == Some(b'=') {
                        self.bump();
                        tokens.push(Token::new(TokenKind::StarEq, span));
                    } else {
                        tokens.push(Token::new(TokenKind::Star, span));
                    }
                }
                b'/' => {
                    self.bump();
                    if self.peek() == Some(b'=') {
                        self.bump();
                        tokens.push(Token::new(TokenKind::SlashEq, span));
                    } else {
                        tokens.push(Token::new(TokenKind::Slash, span));
                    }
                }
                b'%' => {
                    self.bump();
                    if self.peek() == Some(b'=') {
                        self.bump();
                        tokens.push(Token::new(TokenKind::PercentEq, span));
                    } else {
                        tokens.push(Token::new(TokenKind::Percent, span));
                    }
                }
                b'=' => {
                    self.bump();
                    if self.peek() == Some(b'=') {
                        self.bump();
                        tokens.push(Token::new(TokenKind::EqEq, span));
                    } else {
                        tokens.push(Token::new(TokenKind::Eq, span));
                    }
                }
                b'!' => {
                    self.bump();
                    if self.peek() == Some(b'=') {
                        self.bump();
                        tokens.push(Token::new(TokenKind::NotEq, span));
                    } else {
                        return Err(Diagnostic::new(
                            "unexpected character `!` (use `not` for logical negation)",
                            span,
                        ));
                    }
                }
                b'<' => {
                    self.bump();
                    if self.peek() == Some(b'=') {
                        self.bump();
                        tokens.push(Token::new(TokenKind::Le, span));
                    } else {
                        tokens.push(Token::new(TokenKind::Lt, span));
                    }
                }
                b'>' => {
                    self.bump();
                    if self.peek() == Some(b'=') {
                        self.bump();
                        tokens.push(Token::new(TokenKind::Ge, span));
                    } else {
                        tokens.push(Token::new(TokenKind::Gt, span));
                    }
                }
                b'.' => {
                    self.bump();
                    if self.peek() == Some(b'.') {
                        self.bump();
                        tokens.push(Token::new(TokenKind::DotDot, span));
                    } else {
                        return Err(Diagnostic::new(
                            "unexpected character `.` (use `..` for a range)",
                            span,
                        ));
                    }
                }
                b':' => {
                    self.bump();
                    tokens.push(Token::new(TokenKind::Colon, span));
                }
                b'"' | b'\'' => {
                    let value = self.lex_string(c)?;
                    tokens.push(Token::new(TokenKind::Str(value), span));
                }
                b'0'..=b'9' => {
                    let value = self.lex_number()?;
                    tokens.push(Token::new(TokenKind::Int(value), span));
                }
                c if is_ident_start(c) => {
                    let kind = self.lex_ident();
                    tokens.push(Token::new(kind, span));
                }
                _ => {
                    let ch = self.next_char();
                    return Err(Diagnostic::new(
                        format!("unexpected character `{ch}`"),
                        span,
                    ));
                }
            }
        }

        // Terminate the last logical line if the file does not end with a newline.
        let last_is_newline = tokens
            .last()
            .map(|token| token.kind == TokenKind::Newline)
            .unwrap_or(false);
        if !self.at_line_start && !last_is_newline {
            tokens.push(Token::new(TokenKind::Newline, self.span()));
        }

        // Close every open block at end of file.
        while self.indent_stack.len() > 1 {
            self.indent_stack.pop();
            tokens.push(Token::new(TokenKind::Dedent, self.span()));
        }

        tokens.push(Token::new(TokenKind::Eof, self.span()));
        Ok(tokens)
    }

    /// Measures the indentation at the start of a logical line and emits
    /// INDENT/DEDENT tokens as needed. Blank and comment-only lines are
    /// consumed without producing tokens or changing the indent stack.
    fn measure_and_emit_indent(&mut self, tokens: &mut Vec<Token>) -> Result<()> {
        let mut indent = 0usize;

        loop {
            match self.peek() {
                Some(b' ') => {
                    indent += 1;
                    self.bump();
                }
                Some(b'\t') => {
                    indent += 4 - (indent % 4);
                    self.bump();
                }
                _ => break,
            }
        }

        match self.peek() {
            None => {
                self.at_line_start = false;
                return Ok(());
            }
            Some(b'\n') | Some(b'\r') => {
                self.skip_line();
                return Ok(());
            }
            Some(b'#') => {
                self.skip_line();
                return Ok(());
            }
            _ => {}
        }

        let span = self.span();
        let top = *self.indent_stack.last().unwrap();

        if indent > top {
            self.indent_stack.push(indent);
            tokens.push(Token::new(TokenKind::Indent, span));
        } else if indent < top {
            while *self.indent_stack.last().unwrap() > indent {
                self.indent_stack.pop();
                tokens.push(Token::new(TokenKind::Dedent, span));
            }
            if *self.indent_stack.last().unwrap() != indent {
                return Err(Diagnostic::new(
                    "unindent does not match any outer indentation level",
                    span,
                ));
            }
        }

        self.at_line_start = false;
        Ok(())
    }

    fn skip_line(&mut self) {
        while let Some(c) = self.peek() {
            self.bump();
            if c == b'\n' {
                break;
            }
        }
    }

    fn skip_comment(&mut self) {
        while let Some(c) = self.peek() {
            if c == b'\n' {
                break;
            }
            self.bump();
        }
    }

    fn skip_spaces(&mut self) {
        while let Some(c) = self.peek() {
            if c == b' ' || c == b'\t' || c == b'\r' {
                self.bump();
            } else {
                break;
            }
        }
    }

    fn lex_ident(&mut self) -> TokenKind {
        let start = self.pos;
        while let Some(c) = self.peek() {
            if is_ident_continue(c) {
                self.bump();
            } else {
                break;
            }
        }
        let text = std::str::from_utf8(&self.src[start..self.pos]).unwrap_or("");
        match text {
            "func" => TokenKind::Func,
            "let" => TokenKind::Let,
            "return" => TokenKind::Return,
            "if" => TokenKind::If,
            "elif" => TokenKind::Elif,
            "else" => TokenKind::Else,
            "while" => TokenKind::While,
            "for" => TokenKind::For,
            "in" => TokenKind::In,
            "break" => TokenKind::Break,
            "continue" => TokenKind::Continue,
            "and" => TokenKind::And,
            "or" => TokenKind::Or,
            "not" => TokenKind::Not,
            "true" => TokenKind::Bool(true),
            "false" => TokenKind::Bool(false),
            _ => TokenKind::Ident(text.to_string()),
        }
    }

    fn lex_number(&mut self) -> Result<i64> {
        let start = self.pos;
        while let Some(c) = self.peek() {
            if c.is_ascii_digit() {
                self.bump();
            } else {
                break;
            }
        }
        let text = std::str::from_utf8(&self.src[start..self.pos]).unwrap_or("");

        if let Some(c) = self.peek() {
            if is_ident_start(c) {
                return Err(Diagnostic::new(
                    format!("invalid number literal `{text}`"),
                    Span::new(self.line, self.col),
                ));
            }
        }

        text.parse::<i64>().map_err(|_| {
            Diagnostic::new(
                format!("integer literal `{text}` is too large"),
                Span::new(self.line, self.col),
            )
        })
    }

    fn lex_string(&mut self, quote: u8) -> Result<String> {
        let start_span = self.span();
        self.bump(); // opening quote

        let mut value = String::new();
        loop {
            let Some(c) = self.peek() else {
                return Err(Diagnostic::new("unterminated string literal", start_span));
            };

            if c == b'\n' {
                return Err(Diagnostic::new(
                    "unterminated string literal (newline inside string)",
                    start_span,
                ));
            }

            if c == quote {
                self.bump();
                return Ok(value);
            }

            if c == b'\\' {
                self.bump();
                let Some(esc) = self.peek() else {
                    return Err(Diagnostic::new("unterminated string literal", start_span));
                };
                self.bump();
                match esc {
                    b'n' => value.push('\n'),
                    b't' => value.push('\t'),
                    b'r' => value.push('\r'),
                    b'\\' => value.push('\\'),
                    b'\'' => value.push('\''),
                    b'"' => value.push('"'),
                    b'0' => value.push('\0'),
                    _ => {
                        return Err(Diagnostic::new(
                            format!("unknown escape sequence `\\{}`", esc as char),
                            self.span(),
                        ));
                    }
                }
            } else {
                let ch = self.next_char();
                value.push(ch);
            }
        }
    }

    fn next_char(&mut self) -> char {
        let rest = std::str::from_utf8(&self.src[self.pos..]).unwrap();
        let ch = rest.chars().next().unwrap();
        for _ in 0..ch.len_utf8() {
            self.bump();
        }
        ch
    }

    fn peek(&self) -> Option<u8> {
        self.src.get(self.pos).copied()
    }

    fn bump(&mut self) -> Option<u8> {
        let c = self.src.get(self.pos).copied()?;
        self.pos += 1;
        if c == b'\n' {
            self.line += 1;
            self.col = 1;
        } else {
            self.col += 1;
        }
        Some(c)
    }

    fn span(&self) -> Span {
        Span::new(self.line, self.col)
    }
}

fn is_ident_start(c: u8) -> bool {
    c.is_ascii_alphabetic() || c == b'_'
}

fn is_ident_continue(c: u8) -> bool {
    c.is_ascii_alphanumeric() || c == b'_'
}

#[cfg(test)]
mod tests {
    use super::*;

    fn kinds(src: &str) -> Vec<TokenKind> {
        Lexer::new(src)
            .tokenize()
            .unwrap()
            .into_iter()
            .map(|token| token.kind)
            .collect()
    }

    #[test]
    fn indents_and_dedents() {
        let k = kinds("func main():\n    print(\"hi\")\n");
        assert_eq!(k[0], TokenKind::Func);
        assert_eq!(k[1], TokenKind::Ident("main".into()));
        assert_eq!(k[2], TokenKind::LParen);
        assert_eq!(k[3], TokenKind::RParen);
        assert_eq!(k[4], TokenKind::Colon);
        assert_eq!(k[5], TokenKind::Newline);
        assert_eq!(k[6], TokenKind::Indent);
        assert_eq!(k[7], TokenKind::Ident("print".into()));
        assert_eq!(k[8], TokenKind::LParen);
        assert_eq!(k[9], TokenKind::Str("hi".into()));
        assert_eq!(k[10], TokenKind::RParen);
        assert_eq!(k[11], TokenKind::Newline);
        assert_eq!(k[12], TokenKind::Dedent);
        assert_eq!(k[13], TokenKind::Eof);
    }

    #[test]
    fn strings_with_both_quote_styles() {
        let k = kinds("print('a')\nprint(\"b\")\n");
        assert!(k.iter().any(|t| *t == TokenKind::Str("a".into())));
        assert!(k.iter().any(|t| *t == TokenKind::Str("b".into())));
    }

    #[test]
    fn comments_and_blank_lines_are_ignored() {
        let k = kinds("# top\n\nfunc main():\n    # inner\n    print(\"x\")\n");
        assert_eq!(k[0], TokenKind::Func);
        assert_eq!(k.iter().filter(|t| **t == TokenKind::Indent).count(), 1);
    }

    #[test]
    fn rejects_bad_unindent() {
        let result = Lexer::new("func main():\n        print(\"a\")\n    print(\"b\")\n").tokenize();
        assert!(result.is_err());
    }

    #[test]
    fn comparison_and_boolean_tokens() {
        let k = kinds("if a <= b and not c:\n    print(true)\n");
        assert_eq!(k[0], TokenKind::If);
        assert_eq!(k[1], TokenKind::Ident("a".into()));
        assert_eq!(k[2], TokenKind::Le);
        assert_eq!(k[3], TokenKind::Ident("b".into()));
        assert_eq!(k[4], TokenKind::And);
        assert_eq!(k[5], TokenKind::Not);
        assert_eq!(k[6], TokenKind::Ident("c".into()));
        assert!(k.iter().any(|t| *t == TokenKind::Bool(true)));
    }

    #[test]
    fn equality_operators() {
        let k = kinds("a == b\n");
        assert_eq!(k[0], TokenKind::Ident("a".into()));
        assert_eq!(k[1], TokenKind::EqEq);
        assert_eq!(k[2], TokenKind::Ident("b".into()));

        let k = kinds("a != b\n");
        assert_eq!(k[1], TokenKind::NotEq);
    }

    #[test]
    fn loop_tokens() {
        let k = kinds("for i in 0..10:\n    while i < 5:\n        i = i + 1\n        break\n    continue\n");
        assert_eq!(k[0], TokenKind::For);
        assert_eq!(k[1], TokenKind::Ident("i".into()));
        assert_eq!(k[2], TokenKind::In);
        assert_eq!(k[3], TokenKind::Int(0));
        assert_eq!(k[4], TokenKind::DotDot);
        assert_eq!(k[5], TokenKind::Int(10));
        assert!(k.iter().any(|t| *t == TokenKind::While));
        assert!(k.iter().any(|t| *t == TokenKind::Break));
        assert!(k.iter().any(|t| *t == TokenKind::Continue));
    }

    #[test]
    fn array_elif_and_compound_assign_tokens() {
        let k = kinds("let a = [0; 10]\nif x == 1:\n    a[0] += 2\nelif x == 2:\n    a[1] -= 3\n");
        assert!(k.iter().any(|t| *t == TokenKind::LBracket));
        assert!(k.iter().any(|t| *t == TokenKind::Semicolon));
        assert!(k.iter().any(|t| *t == TokenKind::RBracket));
        assert!(k.iter().any(|t| *t == TokenKind::PlusEq));
        assert!(k.iter().any(|t| *t == TokenKind::Elif));
        assert!(k.iter().any(|t| *t == TokenKind::MinusEq));
    }
}
