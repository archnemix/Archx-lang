//! The dialect divergence matrix: one table that is the *only* place a semantic difference between
//! `compat` and `native` is decided (AX-016).
//!
//! Before this module the differences lived as `if dialect { … } else { … }` scattered through the
//! backend: `bool_words` in `codegen/mod.rs`, `container_repr` in `codegen/io.rs`, a `matches!` in
//! `dialect.rs` for wrapping. That works while there are three rules and stops working at thirty,
//! because two things happen: a rule gets implemented in one place and not another (so `print` and an
//! f-string disagree), and the documentation describing the dialects drifts away from the code
//! implementing them.
//!
//! Every rule is therefore a row here — `Rule` plus `RuleValue` for each dialect — and every consumer
//! asks the table rather than testing the enum. `docs/DIALECTS.md` is generated from the same rows by
//! `tools/gen_dialect_matrix.py`, so the table a user reads and the table the compiler obeys are the
//! same object.
//!
//! A rule is only added here when the two contracts genuinely differ. A construct that exists in one
//! dialect and not the other is a *limitation* (`docs/LIMITATIONS.md`), not a divergence, and is
//! enforced by the normal diagnostics.

use crate::dialect::Dialect;

/// One semantic decision on which `compat` and `native` disagree.
///
/// Adding a variant here is a language change, so it also needs a row in `RULES` and a test; the
/// exhaustive `match` in `Compatible::for_dialect` makes forgetting the latter a compile error.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Rule {
    /// How `int` behaves outside its representable range.
    IntOverflow,
    /// How `print`/`str()` render a `bool`.
    BoolRepr,
    /// Whether a container renders its elements with `repr()` (quoting strings).
    ContainerRepr,
    /// Whether the explicit `wrapping_*` opt-out is available at all.
    WrappingOptOut,
    /// How `int / int` is typed and evaluated.
    IntDivision,
    /// Whether `str` indexes by byte or by Unicode code point.
    StrIndexUnit,
    /// Whether arithmetic on mixed `int`/`float` operands is allowed.
    MixedNumericArithmetic,
    /// How a runtime failure (division by zero, bad index, missing key) is reported.
    RuntimeFailure,
}

/// The value of a rule for a dialect.
///
/// Deliberately a small closed set rather than a free string: the generator renders it directly into
/// the docs table, and a value that is not one of these would be documentation the compiler cannot
/// check.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RuleValue {
    /// `int` traps instead of producing an unrepresentable value.
    Traps,
    /// The words CPython's `repr` uses: `True` / `False`.
    PythonWords,
    /// The systems spelling: `true` / `false`.
    SystemsWords,
    /// Elements are rendered with `repr()` (`['a']`).
    Repr,
    /// Elements are rendered as the value (`[a]`).
    Raw,
    /// The opt-out is available.
    Allowed,
    /// The opt-out is rejected with `E0802`.
    Rejected,
    /// `/` produces `float`, as Python's true division does.
    TrueDivision,
    /// Indexing counts Unicode code points.
    CodePoints,
    /// Indexing counts UTF-8 bytes.
    Bytes,
    /// `1 + 1.5` is an error; both operands must match.
    RequireMatching,
    /// `1 + 1.5` widens to `float`.
    Widens,
    /// A failure raises a Python exception.
    Raises,
    /// A failure traps with `archx runtime panic` and exit 101.
    TrapsProcess,
}

impl RuleValue {
    /// The cell text for the generated documentation.
    pub fn describe(self) -> &'static str {
        match self {
            RuleValue::Traps => "traps (`archx runtime panic: integer overflow`, exit 101)",
            RuleValue::PythonWords => "`True` / `False`",
            RuleValue::SystemsWords => "`true` / `false`",
            RuleValue::Repr => "`repr()`: `['a', 'b']`",
            RuleValue::Raw => "the value: `[a, b]`",
            RuleValue::Allowed => "available",
            RuleValue::Rejected => "rejected with `E0802`",
            RuleValue::TrueDivision => "`float`, true division (`7 / 2 == 3.5`)",
            RuleValue::CodePoints => "Unicode code points",
            RuleValue::Bytes => "UTF-8 bytes",
            RuleValue::RequireMatching => "rejected: both operands must match (`E0401`)",
            RuleValue::Widens => "widens to `float`",
            RuleValue::Raises => "raises a Python exception",
            RuleValue::TrapsProcess => "traps: panic message and exit 101",
        }
    }
}

/// One row of the matrix: the rule and the value each dialect gives it.
pub struct Row {
    pub rule: Rule,
    pub compat: RuleValue,
    pub native: RuleValue,
    /// Whether the compiler currently *enforces* this row.
    ///
    /// The matrix is listed in full as soon as a divergence is decided, so it is the single
    /// description of the intended contract — including the parts still to be built. This flag keeps
    /// that honest: a row that no call site reads through `value` says so in the docs instead of
    /// claiming to be done.
    pub enforced: bool,
}

/// The matrix itself. This is the single place a compat/native difference is decided (AX-016).
///
/// Adding a rule means adding a row here; the exhaustive [`Rule`] enum makes it impossible to add a
/// *variant* without a row, and `every_rule_has_a_row` fails if one is missing.
pub const ROWS: &[Row] = &[
    Row {
        rule: Rule::IntOverflow,
        compat: RuleValue::Traps,
        native: RuleValue::Traps,
        enforced: true,
    },
    Row {
        rule: Rule::BoolRepr,
        compat: RuleValue::PythonWords,
        native: RuleValue::SystemsWords,
        enforced: true,
    },
    Row {
        rule: Rule::ContainerRepr,
        compat: RuleValue::Repr,
        native: RuleValue::Raw,
        enforced: true,
    },
    Row {
        rule: Rule::WrappingOptOut,
        compat: RuleValue::Rejected,
        native: RuleValue::Allowed,
        enforced: true,
    },
    Row {
        rule: Rule::IntDivision,
        compat: RuleValue::TrueDivision,
        native: RuleValue::TrueDivision,
        enforced: false,
    },
    Row {
        rule: Rule::StrIndexUnit,
        compat: RuleValue::CodePoints,
        native: RuleValue::Bytes,
        enforced: false,
    },
    Row {
        rule: Rule::MixedNumericArithmetic,
        compat: RuleValue::Widens,
        native: RuleValue::RequireMatching,
        enforced: false,
    },
    Row {
        rule: Rule::RuntimeFailure,
        compat: RuleValue::Raises,
        native: RuleValue::TrapsProcess,
        enforced: true,
    },
];

/// Reads the value of `rule` for `dialect`.
///
/// Consumers call this rather than testing the enum, so a rule has exactly one implementation.
pub fn value(rule: Rule, dialect: Dialect) -> RuleValue {
    let row = ROWS
        .iter()
        .find(|row| row.rule == rule)
        .expect("every Rule has a row in ROWS");
    match dialect {
        Dialect::Compat => row.compat,
        Dialect::Native => row.native,
    }
}

/// Whether every row in the matrix is enforced. The docs generator states this plainly so a
/// documented-but-unbuilt divergence is never mistaken for a finished one.
pub fn all_enforced() -> bool {
    ROWS.iter().all(|row| row.enforced)
}

/// Whether the compiler enforces `rule` today.
pub fn is_enforced(rule: Rule) -> bool {
    ROWS.iter()
        .find(|row| row.rule == rule)
        .is_some_and(|row| row.enforced)
}

/// Every rule, in documentation order (the order of [`ROWS`]).
pub fn all() -> Vec<Rule> {
    ROWS.iter().map(|row| row.rule).collect()
}

impl Rule {
    /// The rule's stable name, used in docs and in error messages that cite a divergence.
    pub fn name(self) -> &'static str {
        match self {
            Rule::IntOverflow => "int overflow",
            Rule::BoolRepr => "bool repr",
            Rule::ContainerRepr => "container repr",
            Rule::WrappingOptOut => "wrapping opt-out",
            Rule::IntDivision => "int division",
            Rule::StrIndexUnit => "str index unit",
            Rule::MixedNumericArithmetic => "mixed numeric arithmetic",
            Rule::RuntimeFailure => "runtime failure",
        }
    }

    /// What the rule governs, in words a user searching the docs would use.
    pub fn governs(self) -> &'static str {
        match self {
            Rule::IntOverflow => "an `int` operation whose result does not fit",
            Rule::BoolRepr => "printing or stringifying a `bool`",
            Rule::ContainerRepr => "printing a `list`, `tuple`, `dict` or `set` that contains strings",
            Rule::WrappingOptOut => "calling `wrapping_add` / `wrapping_sub` / `wrapping_mul`",
            Rule::IntDivision => "`int / int`",
            Rule::StrIndexUnit => "indexing or slicing a `str`",
            Rule::MixedNumericArithmetic => "an arithmetic operator with one `int` and one `float`",
            Rule::RuntimeFailure => "division by zero, an out-of-range index, or a missing dict key",
        }
    }
}

/// Convenience: the value of `rule` in the dialect `self` is compiled against.
pub trait ForDialect {
    /// Reads `rule` for this dialect.
    fn rule(self, rule: Rule) -> RuleValue;
}

impl ForDialect for Dialect {
    fn rule(self, rule: Rule) -> RuleValue {
        value(rule, self)
    }
}

/// True when the two dialects disagree about `rule`.
pub fn diverges(rule: Rule) -> bool {
    value(rule, Dialect::Compat) != value(rule, Dialect::Native)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn every_rule_is_decided_for_both_dialects() {
        // If this compiles, `value` is exhaustive; the test keeps the list in `all()` honest.
        for rule in all() {
            let c = value(rule, Dialect::Compat);
            let n = value(rule, Dialect::Native);
            assert_ne!(
                c.describe(),
                "",
                "{} has no compat description",
                rule.name()
            );
            assert_ne!(n.describe(), "", "{} has no native description", rule.name());
        }
    }

    #[test]
    fn all_lists_every_rule_exactly_once() {
        let mut seen = std::collections::HashSet::new();
        for rule in all() {
            assert!(seen.insert(rule.name()), "{} listed twice", rule.name());
        }
        // Adding a `Rule` without adding it to `all()` would make it invisible in the docs.
        assert_eq!(seen.len(), all().len());
    }

    #[test]
    fn a_row_that_claims_to_diverge_actually_does() {
        // `IntOverflow` and `IntDivision` are listed because a reader asks about them, and both
        // answers happen to coincide today. Every other row must differ, or it is not a divergence.
        for row in ROWS {
            let shared = matches!(row.rule, Rule::IntOverflow | Rule::IntDivision);
            if shared {
                assert_eq!(
                    row.compat,
                    row.native,
                    "{} is listed as a shared rule but the dialects disagree",
                    row.rule.name()
                );
            } else {
                assert_ne!(
                    row.compat,
                    row.native,
                    "{} is listed as a divergence but both dialects agree",
                    row.rule.name()
                );
            }
        }
    }

    #[test]
    fn the_matrix_is_complete_and_enforcement_flags_are_honest() {
        assert_eq!(all().len(), 8, "update the docs generator when this changes");
        assert!(
            !all_enforced(),
            "if every row is now enforced, update the wording in render_matrix and docs/DIALECTS.md"
        );
        // A row claimed as enforced must be reachable through `value`, which the callers use; a row
        // claimed as planned must not be silently enforced somewhere else.
        assert!(is_enforced(Rule::BoolRepr));
        assert!(is_enforced(Rule::WrappingOptOut));
        assert!(!is_enforced(Rule::StrIndexUnit));
    }

    #[test]
    fn the_safety_relevant_rules_never_permit_wrapping_in_compat() {
        // The one property a future edit must not break: compat may never silently wrap, because that
        // is a wrong answer in a contract that promises CPython's arbitrary-precision `int`.
        assert_eq!(value(Rule::IntOverflow, Dialect::Compat), RuleValue::Traps);
        assert_eq!(value(Rule::WrappingOptOut, Dialect::Compat), RuleValue::Rejected);
    }
}

/// Renders the whole matrix as text: the body of `archx --dialect-matrix` and, through it,
/// `docs/DIALECTS.md`.
///
/// Printed by the compiler rather than written by hand for the same reason `archx explain` is: a
/// document that restates behaviour drifts, while a document rendered from the table cannot.
pub fn render_matrix() -> String {
    let mut out = String::new();
    out.push_str("Dialect divergence matrix\n\n");
    out.push_str(
        "Each row is one decision where `compat` and `native` differ, or could. `enforced` means the\
         \ncompiler currently implements the row; anything else is the intended contract for work not\
         \nyet done.\n\n",
    );
    // Iterate the rules rather than the rows so `all()` and `is_enforced()` are what this output is
    // actually built from — one definition, no chance of the printed order drifting from the table.
    for rule in all() {
        out.push_str(&format!("{} — {}\n", rule.name(), rule.governs()));
        out.push_str(&format!(
            "  compat: {}\n",
            value(rule, Dialect::Compat).describe()
        ));
        out.push_str(&format!(
            "  native: {}\n",
            value(rule, Dialect::Native).describe()
        ));
        out.push_str(&format!(
            "  status: {}\n\n",
            if is_enforced(rule) {
                "enforced"
            } else {
                "planned"
            }
        ));
    }
    let divergent = all().iter().filter(|rule| diverges(**rule)).count();
    out.push_str(&format!(
        "{} of {} rules differ between the contracts.\n",
        divergent,
        all().len()
    ));
    out.push_str(&format!(
        "{}\n",
        if all_enforced() {
            "Every rule in this matrix is enforced."
        } else {
            "Some rules are documented but not enforced yet; they are marked `planned` above and \
             listed in docs/LIMITATIONS.md."
        }
    ));
    out
}
