//! Dialect selection for a source module: the `# archx: dialect=…, version=…` directive parser and
//! the `DialectSpec` that every later pass reads instead of guessing from syntax.
//!
//! Archx has two contracts, and a program must say which one it wants:
//!
//! * **compat** — byte-identical stdout to CPython 3.12+.
//! * **native** — documented Archx semantics (trapping `i64`, UTF-8 bytes, IEEE `frem`, static
//!   dispatch).
//!
//! The distinction cannot be inferred: `1 << 64` is `0` in native and `18446744073709551616` in
//! compat, and the same source text is legal in both. So the dialect is an explicit, checked,
//! per-module decision, declared on the first line of the file. A module without a directive is a
//! compile error (`E0100`), because silently picking one produces a program whose behaviour depends
//! on a compiler default.
//!
//! The file extension is only a hint for editor tooling — it never selects the dialect.

use crate::diag::{Diagnostic, Span};

/// Which contract a module is compiled against.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub enum Dialect {
    /// Byte-identical stdout to CPython 3.12+.
    Compat,
    /// Documented Archx semantics; divergences from Python are explicit and legal.
    #[default]
    Native,
}

impl Dialect {
    pub fn name(self) -> &'static str {
        match self {
            Dialect::Compat => "compat",
            Dialect::Native => "native",
        }
    }

    pub fn parse(text: &str) -> Option<Self> {
        match text {
            "compat" => Some(Dialect::Compat),
            "native" => Some(Dialect::Native),
            _ => None,
        }
    }
}

/// What the directive said. Carried on `ast::Program` so later passes never re-derive it.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct DialectSpec {
    pub dialect: Dialect,
    /// Directive schema version. Bumped when a directive keyword changes meaning, so an older
    /// compiler rejects a newer module instead of silently misreading it.
    pub version: u32,
    /// How the dialect was chosen, so a diagnostic can explain the precedence that applied.
    pub source: DialectSource,
}

/// Where the effective dialect came from.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum DialectSource {
    /// Read from the module's own first line.
    Directive,
    /// Overridden by `--dialect` on the command line.
    Cli,
}

/// The schema version this compiler understands.
pub const DIRECTIVE_VERSION: u32 = 1;

/// Prefix that marks a first line as an Archx directive.
const PREFIX: &str = "#";
const SIGIL: &str = "archx:";

/// Parse the module's dialect directive from the first line of `source`.
///
/// Returns `Ok(None)` when the first line is not a directive at all (the caller turns that into
/// `E0100`), and an error when it looks like a directive but is malformed — the distinction matters
/// because "you forgot the header" and "your header is wrong" need different fixes.
pub fn parse_directive(source: &str) -> Result<Option<DialectSpec>, Diagnostic> {
    let first = source.lines().next().unwrap_or("").trim_end();
    let trimmed = first.trim_start();
    if !trimmed.starts_with('#') {
        return Ok(None);
    }
    // A `# archx:` line is ours by definition; anything else is a normal comment.
    if !trimmed.starts_with(PREFIX) || !trimmed[1..].trim_start().starts_with(SIGIL) {
        return Ok(None);
    }
    // Accept `#archx:` as well as `# archx:` — the space after `#` is conventional, not semantic.
    let body = trimmed[1..]
        .trim_start()
        .strip_prefix(SIGIL)
        .expect("the check above guarantees the sigil follows the `#`");
    let mut dialect: Option<Dialect> = None;
    let mut version: Option<u32> = None;

    for field in body.split(',') {
        let field = field.trim();
        if field.is_empty() {
            continue;
        }
        let Some((key, value)) = field.split_once('=') else {
            return Err(Diagnostic::new(
                format!(
                    "E0101: malformed directive field `{field}` (expected `key=value`)"
                ),
                Span::new(1, 1),
            ));
        };
        let key = key.trim();
        let value = value.trim();
        match key {
            "dialect" => {
                dialect = Some(Dialect::parse(value).ok_or_else(|| {
                    Diagnostic::new(
                        format!(
                            "E0101: unknown dialect `{value}` (expected `compat` or `native`)"
                        ),
                        Span::new(1, 1),
                    )
                })?);
            }
            "version" => {
                version = Some(value.parse::<u32>().map_err(|_| {
                    Diagnostic::new(
                        format!("E0101: version is not a number: `{value}`"),
                        Span::new(1, 1),
                    )
                })?);
            }
            other => {
                return Err(Diagnostic::new(
                    format!(
                        "E0101: unknown directive key `{other}` (expected `dialect` and `version`)"
                    ),
                    Span::new(1, 1),
                ));
            }
        }
    }

    let dialect = dialect.ok_or_else(|| {
        Diagnostic::new(
            "E0101: the directive is missing `dialect=` (expected `compat` or `native`)",
            Span::new(1, 1),
        )
    })?;
    let version = version.ok_or_else(|| {
        Diagnostic::new(
            "E0101: the directive is missing `version=` (expected `version=1`)",
            Span::new(1, 1),
        )
    })?;
    if version != DIRECTIVE_VERSION {
        return Err(Diagnostic::new(
            format!(
                "E0101: this compiler understands directive version {DIRECTIVE_VERSION}, \
                 but the module declares version {version}"
            ),
            Span::new(1, 1),
        ));
    }

    Ok(Some(DialectSpec {
        dialect,
        version,
        source: DialectSource::Directive,
    }))
}

/// The error for a module that has no directive. Kept here so the wording and the code live with
/// the rest of the dialect rules.
pub fn missing_directive() -> Diagnostic {
    Diagnostic::new(
        "E0100: this module does not declare its dialect; add \
         `# archx: dialect=compat, version=1` or `# archx: dialect=native, version=1` as the first line",
        Span::new(1, 1),
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_both_dialects() {
        let c = parse_directive("# archx: dialect=compat, version=1\nprint(1)\n")
            .unwrap()
            .unwrap();
        assert_eq!(c.dialect, Dialect::Compat);
        assert_eq!(c.version, 1);

        let n = parse_directive("# archx: dialect=native, version=1\n").unwrap().unwrap();
        assert_eq!(n.dialect, Dialect::Native);
    }

    #[test]
    fn field_order_and_spacing_do_not_matter() {
        let d = parse_directive("#archx:version=1,dialect=native\n").unwrap().unwrap();
        assert_eq!(d.dialect, Dialect::Native);
    }

    #[test]
    fn ordinary_comments_are_not_directives() {
        assert!(parse_directive("# just a comment\n").unwrap().is_none());
        assert!(parse_directive("def main():\n").unwrap().is_none());
    }

    #[test]
    fn malformed_directives_are_errors() {
        // Missing dialect, missing version, unknown dialect, unknown key, bad version.
        assert!(parse_directive("# archx: version=1\n").is_err());
        assert!(parse_directive("# archx: dialect=native\n").is_err());
        assert!(parse_directive("# archx: dialect=python, version=1\n").is_err());
        assert!(parse_directive("# archx: dialect=native, version=1, turbo=on\n").is_err());
        assert!(parse_directive("# archx: dialect=native, version=9\n").is_err());
    }
}
