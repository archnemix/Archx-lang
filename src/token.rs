use crate::diag::Span;

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum TokenKind {
    // Keywords
    Func,
    Let,
    Return,
    If,
    Else,
    And,
    Or,
    Not,

    // Literals
    Ident(String),
    Int(i64),
    Str(String),
    Bool(bool),

    // Punctuation
    Colon,
    Arrow,
    LParen,
    RParen,
    Comma,
    Plus,
    Minus,
    Star,
    Slash,
    Eq,
    EqEq,
    NotEq,
    Lt,
    Gt,
    Le,
    Ge,

    // Layout
    Newline,
    Indent,
    Dedent,
    Eof,
}

impl TokenKind {
    pub fn describe(&self) -> String {
        match self {
            TokenKind::Func => "`func`".to_string(),
            TokenKind::Let => "`let`".to_string(),
            TokenKind::Return => "`return`".to_string(),
            TokenKind::If => "`if`".to_string(),
            TokenKind::Else => "`else`".to_string(),
            TokenKind::And => "`and`".to_string(),
            TokenKind::Or => "`or`".to_string(),
            TokenKind::Not => "`not`".to_string(),
            TokenKind::Ident(name) => format!("identifier `{name}`"),
            TokenKind::Int(n) => format!("integer `{n}`"),
            TokenKind::Str(_) => "string literal".to_string(),
            TokenKind::Bool(value) => format!("boolean `{value}`"),
            TokenKind::Colon => "`:`".to_string(),
            TokenKind::Arrow => "`->`".to_string(),
            TokenKind::LParen => "`(`".to_string(),
            TokenKind::RParen => "`)`".to_string(),
            TokenKind::Comma => "`,`".to_string(),
            TokenKind::Plus => "`+`".to_string(),
            TokenKind::Minus => "`-`".to_string(),
            TokenKind::Star => "`*`".to_string(),
            TokenKind::Slash => "`/`".to_string(),
            TokenKind::Eq => "`=`".to_string(),
            TokenKind::EqEq => "`==`".to_string(),
            TokenKind::NotEq => "`!=`".to_string(),
            TokenKind::Lt => "`<`".to_string(),
            TokenKind::Gt => "`>`".to_string(),
            TokenKind::Le => "`<=`".to_string(),
            TokenKind::Ge => "`>=`".to_string(),
            TokenKind::Newline => "a newline".to_string(),
            TokenKind::Indent => "an indent".to_string(),
            TokenKind::Dedent => "a dedent".to_string(),
            TokenKind::Eof => "end of file".to_string(),
        }
    }
}

#[derive(Debug, Clone)]
pub struct Token {
    pub kind: TokenKind,
    pub span: Span,
}

impl Token {
    pub fn new(kind: TokenKind, span: Span) -> Self {
        Self { kind, span }
    }
}
