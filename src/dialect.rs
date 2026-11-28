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
use crate::dialect_rules::ForDialect as _;

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

    /// The words `print` uses for a `bool`: `repr()` in compat, and the systems spelling in native.
    ///
    /// The answer comes from [`dialect_rules`](crate::dialect_rules), which is the only place a
    /// compat/native difference is decided (AX-016); this helper is just the shape `print` wants.
    pub fn bool_words(self) -> (&'static str, &'static str) {
        match self.rule(crate::dialect_rules::Rule::BoolRepr) {
            crate::dialect_rules::RuleValue::PythonWords => ("True", "False"),
            _ => ("true", "false"),
        }
    }

    /// Whether a container's elements are printed with `repr()` (quoting strings) or as raw values.
    pub fn container_repr(self) -> bool {
        matches!(
            self.rule(crate::dialect_rules::Rule::ContainerRepr),
            crate::dialect_rules::RuleValue::Repr
        )
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

    let spec = DialectSpec {
        dialect,
        version,
        source: DialectSource::Directive,
    };

    // A second directive is an error, not something to ignore. The first line selects the contract;
    // a later one is almost always a copy-paste leftover, and honouring the first while silently
    // dropping the second would compile a module against a contract that appears nowhere in the
    // decided output. If the two agree it is still worth removing, so it is reported either way —
    // `E0100` covers "no directive", `E0101` covers "the directive is not usable".
    for (index, line) in source.lines().enumerate().skip(1) {
        let line = line.trim_start();
        if line.starts_with(PREFIX) && line[1..].trim_start().starts_with(SIGIL) {
            return Err(Diagnostic::new(
                format!(
                    "E0101: a second dialect directive on line {} (the first line already declares \
                     `dialect={}`, `version={}`); keep exactly one",
                    index + 1,
                    spec.dialect.name(),
                    spec.version
                ),
                Span::new(index + 1, 1),
            ));
        }
    }

    Ok(Some(spec))
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

/// The same error with a suggested line, chosen from the source itself.
///
/// A fix-it is only worth showing when it is *right*: if the module already uses a `struct`, `region:`
/// or `pub fn`, `native` is the only dialect that can compile it, so the suggestion is not a guess. A
/// module with no such marker gets no suggestion — a wrong fix-it is worse than none, because users
/// paste it.
pub fn missing_directive_for(source: &str) -> Diagnostic {
    let native_only = ["struct ", "region:", "with region", "pub fn ", "enum "]
        .iter()
        .any(|marker| source.contains(marker));
    if !native_only {
        return missing_directive();
    }
    Diagnostic::new(
        "E0100: this module does not declare its dialect. It uses constructs that only the `native` \
         contract provides, so insert this as the first line:\n         \
         `# archx: dialect=native, version=1`",
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
    fn a_second_directive_is_rejected() {
        // Conflicting: the classic copy-paste, and the case that must never be silently resolved.
        let err = parse_directive(
            "# archx: dialect=native, version=1\n# archx: dialect=compat, version=1\nprint(1)\n",
        )
        .unwrap_err();
        assert_eq!(err.code, Some(crate::error_codes::Code::MalformedDirective));
        assert!(err.message.contains("second dialect directive"), "{}", err.message);
        assert_eq!((err.span.line, err.span.col), (2, 1));

        // Agreeing: still an error, because the leftover line is worth deleting and because a rule
        // that only fires on disagreement would let stale headers survive until they diverge.
        assert!(parse_directive(
            "# archx: dialect=native, version=1\n# archx: dialect=native, version=1\n",
        )
        .is_err());

        // A plain comment further down is not a directive ...
        assert!(parse_directive(
            "# archx: dialect=native, version=1\n# just a note\nprint(1)\n",
        )
        .unwrap()
        .is_some());
        // ... but a line carrying the sigil is, even if it is prose: `# archx:` is reserved, so the
        // only safe reading is that someone meant to write a directive and got it wrong.
        assert!(parse_directive(
            "# archx: dialect=native, version=1\n# archx: this is a note\nprint(1)\n",
        )
        .is_err());
    }

    #[test]
    fn the_fix_it_is_only_offered_when_it_is_provably_right() {
        // `struct` is native-only, so there is exactly one valid directive.
        let native = missing_directive_for("struct P:\n    x: int\n");
        assert!(native.message.contains("dialect=native, version=1"));
        assert!(native.message.contains("only the `native` contract"));

        // `region:` and `enum` are native-only too.
        for marker in ["region:\n", "enum E:\n", "pub fn f()", "with region r:\n"] {
            let d = missing_directive_for(&format!("{marker}\nprint(1)\n"));
            assert!(
                d.message.contains("dialect=native, version=1"),
                "{marker} should suggest native"
            );
        }

        // Plain Python-compatible code could be either dialect, so no line is suggested.
        let plain = missing_directive_for("print(1)\n");
        assert!(!plain.message.contains("only the `native` contract"));
        assert!(plain.message.contains("dialect=compat"));
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
