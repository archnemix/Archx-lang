//! Source span tracking and compiler diagnostic error types.
//!
//! Every diagnostic carries a stable [`Code`](crate::error_codes::Code) as well as a span and a
//! message, so errors can be filtered, explained and machine-read without matching on English text.

use std::fmt;

use crate::error_codes::Code;

/// A position in the source text (1-based line and column).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Span {
    pub line: usize,
    pub col: usize,
}

impl Span {
    pub fn new(line: usize, col: usize) -> Self {
        Self { line, col }
    }
}

#[derive(Debug, Clone)]
pub struct Diagnostic {
    pub message: String,
    pub span: Span,
    /// The stable code for this diagnostic. Every error has one; `None` only appears for a
    /// `Diagnostic` built before the code was attached, which the test suite forbids.
    pub code: Option<Code>,
}

impl Diagnostic {
    /// A diagnostic whose message already begins with its code (`"E0100: …"`), or whose code is
    /// derived from the message by `diagnose::classify`.
    ///
    /// The `E0xxx:` prefix is stripped: the structured `code` field carries it, and `render_error`
    /// prints `error[E0402]: …`, so keeping it would show the code twice. A message that starts with
    /// something code-shaped but is not a known code is left untouched.
    pub fn new(message: impl Into<String>, span: Span) -> Self {
        let message = message.into();
        let code = crate::diagnose::classify(&message);
        let message = match message.split_once(": ") {
            Some((head, rest)) if code.is_some() && head == code.map(|c| c.as_str()).unwrap_or("") => {
                rest.to_string()
            }
            _ => message,
        };
        Self {
            message,
            span,
            code,
        }
    }

    /// The code as wire text, or `"E0901"` for a diagnostic that lost its code on the way out.
    pub fn code_str(&self) -> &'static str {
        self.code.unwrap_or(Code::InternalInvariant).as_str()
    }
}

impl fmt::Display for Diagnostic {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}:{}: {}",
            self.span.line, self.span.col, self.message
        )
    }
}

impl std::error::Error for Diagnostic {}

pub type Result<T> = std::result::Result<T, Diagnostic>;
