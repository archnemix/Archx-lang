//! `archx explain-perf`: what each expression costs, and what to write instead (AX-018).
//!
//! Archx has five representation tiers, and which one an expression lands in decides its speed more
//! than any backend pass does:
//!
//! | Tier | Representation | Cost per operation |
//! |---|---|---|
//! | static | unboxed `i64` / `f64` / `bool` / fixed `[T]` | one instruction, vectorizable |
//! | iterator | closed-form range / induction variable | folded away entirely |
//! | any | boxed `%ArchxAny` tag + payload | tag dispatch on every read |
//! | heap | per-value `malloc`/`free`, region-backed or not | allocator or bump call |
//! | unwind | value that crosses a `region:` boundary | promotion copy on exit |
//!
//! The point of the command is **actionable** output: a note names the construct, the tier it forces,
//! why, and the exact replacement to write. A finding without a fix is noise, so every detector below
//! either produces a concrete rewrite or does not fire.
//!
//! The analysis is deliberately syntactic. A dynamic variable is one that is *syntactically* able to
//! hold more than one type — that is exactly the condition the backend's `AdaptiveHints` uses to choose
//! `%ArchxAny`, so the note and the codegen agree by construction rather than by a shared heuristic
//! that can drift.
//!
//! Safety never enters the trade: a note never suggests removing a bounds check, an overflow check, or
//! an ownership rule. Every fix-it here changes *representation*, which is free in this language, not
//! *checking*.

use std::collections::{BTreeMap, HashSet};
use std::fmt::Write as _;

use crate::ast::*;

/// The representation tier an expression lands in.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Tier {
    /// Closed-form or unboxed: folded, hoisted, or vectorized by LLVM.
    Static,
    /// An induction variable or constant-trip-count range: no per-iteration work at all.
    Iterator,
    /// Boxed `%ArchxAny`: a tag check on every read.
    Any,
    /// Allocated per value (`malloc`/`free`, or a region bump).
    Heap,
    /// Crosses a `region:` boundary, so it must be promoted to the heap on exit.
    Unwind,
}

impl Tier {
    /// The word printed in the report. Stable, because users grep for it.
    pub fn label(self) -> &'static str {
        match self {
            Tier::Static => "static",
            Tier::Iterator => "iterator",
            Tier::Any => "any",
            Tier::Heap => "heap",
            Tier::Unwind => "unwind",
        }
    }

    /// Cost ordering used by `--min-tier`: static < iterator < any < heap < unwind.
    fn rank(self) -> u8 {
        match self {
            Tier::Static => 0,
            Tier::Iterator => 1,
            Tier::Any => 2,
            Tier::Heap => 3,
            Tier::Unwind => 4,
        }
    }

    /// Parses a `--min-tier=` value.
    pub fn parse(name: &str) -> Option<Self> {
        match name {
            "static" => Some(Tier::Static),
            "iterator" => Some(Tier::Iterator),
            "any" => Some(Tier::Any),
            "heap" => Some(Tier::Heap),
            "unwind" => Some(Tier::Unwind),
            _ => None,
        }
    }
}

/// One actionable note: what the code does, what tier that forces, and what to write instead.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Note {
    pub line: usize,
    pub col: usize,
    pub tier: Tier,
    /// The construct as it appears, short enough to scan.
    pub construct: String,
    /// Why it costs what it costs.
    pub why: String,
    /// The rewrite, in the native dialect. Always concrete.
    pub fix: String,
}

impl Note {
    /// Renders one note in the same shape as a compiler diagnostic, so editors can reuse their parser.
    pub fn render(&self) -> String {
        format!(
            "note[perf-{}]: {}\n  --> {}:{}\n   = why: {}\n   = fix: {}\n",
            self.tier.label(),
            self.construct,
            self.line,
            self.col,
            self.why,
            self.fix
        )
    }
}

/// Everything the annotator found, in source order.
#[derive(Debug, Default)]
pub struct Report {
    pub notes: Vec<Note>,
    /// How many expressions were classified into each tier, for the summary line.
    pub counts: BTreeMap<&'static str, usize>,
}

impl Report {
    fn count(&mut self, tier: Tier) {
        *self.counts.entry(tier.label()).or_insert(0) += 1;
    }

    /// Notes at or above `min`, for `--min-tier`.
    pub fn filtered(&self, min: Option<Tier>) -> Vec<&Note> {
        let floor = min.map(|tier| tier.rank()).unwrap_or(0);
        self.notes
            .iter()
            .filter(|note| note.tier.rank() >= floor)
            .collect()
    }

    /// A one-line summary: how many expressions were seen at each tier.
    pub fn summary(&self) -> String {
        let mut parts = Vec::new();
        for tier in [
            Tier::Static,
            Tier::Iterator,
            Tier::Any,
            Tier::Heap,
            Tier::Unwind,
        ] {
            if let Some(count) = self.counts.get(tier.label()) {
                parts.push(format!("{count} {}", tier.label()));
            }
        }
        if parts.is_empty() {
            return "no expressions classified".to_string();
        }
        format!(
            "{} expression(s) classified: {}",
            self.counts.values().sum::<usize>(),
            parts.join(", ")
        )
    }
}

/// Collects every variable that is *syntactically* able to change type, plus every variable the
/// backend will therefore box. Mirrors the `AdaptiveHints` criterion: a second binding or an
/// assignment of a different literal type, or an initial `None`.
fn dynamic_vars(stmts: &[Stmt], out: &mut HashSet<String>) {
    fn visit(stmts: &[Stmt], out: &mut HashSet<String>) {
        for stmt in stmts {
            match &stmt.kind {
                StmtKind::Let { name, value, .. } => {
                    if matches!(value.kind, ExprKind::NoneLit) {
                        out.insert(name.clone());
                    }
                }
                StmtKind::Assign {
                    target: AssignTarget::Var(name),
                    value,
                    ..
                } => {
                    if matches!(value.kind, ExprKind::NoneLit) {
                        out.insert(name.clone());
                    }
                }
                StmtKind::If {
                    then_body,
                    else_body,
                    ..
                } => {
                    visit(then_body, out);
                    if let Some(body) = else_body {
                        visit(body, out);
                    }
                }
                StmtKind::While { body, .. }
                | StmtKind::For { body, .. }
                | StmtKind::ForEach { body, .. }
                | StmtKind::ForEnumerate { body, .. }
                | StmtKind::ForDictItems { body, .. } => visit(body, out),
                _ => {}
            }
        }
    }
    visit(stmts, out);
}

/// Collects every name bound to a heap-backed container literal, so `if xs:` can be recognised as a
/// length check rather than a plain `bool` test.
fn collection_vars(stmts: &[Stmt], out: &mut HashSet<String>) {
    fn visit(stmts: &[Stmt], out: &mut HashSet<String>) {
        for stmt in stmts {
            match &stmt.kind {
                StmtKind::Let { name, value, .. } => {
                    if is_container(value) {
                        out.insert(name.clone());
                    }
                }
                StmtKind::Assign {
                    target: AssignTarget::Var(name),
                    value,
                    ..
                } => {
                    if is_container(value) {
                        out.insert(name.clone());
                    }
                }
                StmtKind::If {
                    then_body,
                    else_body,
                    ..
                } => {
                    visit(then_body, out);
                    if let Some(body) = else_body {
                        visit(body, out);
                    }
                }
                StmtKind::While { body, .. }
                | StmtKind::For { body, .. }
                | StmtKind::ForEach { body, .. }
                | StmtKind::ForEnumerate { body, .. }
                | StmtKind::ForDictItems { body, .. }
                | StmtKind::ForZip { body, .. }
                | StmtKind::ForTupleUnpack { body, .. } => visit(body, out),
                StmtKind::Match { cases, .. } => {
                    for case in cases {
                        visit(&case.body, out);
                    }
                }
                _ => {}
            }
        }
    }
    visit(stmts, out);
}

/// True when the expression produces a heap-backed value whose truthiness is a length check.
fn is_container(expr: &Expr) -> bool {
    matches!(
        &expr.kind,
        ExprKind::ArrayLit(_)
            | ExprKind::ArrayRepeat { .. }
            | ExprKind::DictLit(_)
            | ExprKind::SetLit(_)
            | ExprKind::ListComp { .. }
            | ExprKind::DictComp { .. }
            | ExprKind::SetComp { .. }
            | ExprKind::GenExpr { .. }
    ) || matches!(&expr.kind, ExprKind::Call { name, .. } if name == "list" || name == "set" || name == "dict")
}

/// True when the literal is a bare value the backend can keep unboxed in a fixed container.
fn literal_type(expr: &Expr) -> Option<&'static str> {
    match &expr.kind {
        ExprKind::Int(_) => Some("int"),
        ExprKind::Float(_) => Some("float"),
        ExprKind::Bool(_) => Some("bool"),
        ExprKind::Str(_) | ExprKind::FString(_) => Some("str"),
        _ => None,
    }
}

/// Walks the program once, classifying expressions and emitting a note for each costly shape.
struct Walker<'a> {
    dynamic: HashSet<String>,
    /// Names bound to a heap-backed container, so `if name:` can be priced as a length load.
    collections: HashSet<String>,
    report: Report,
    source: &'a str,
}

impl<'a> Walker<'a> {
    fn line_text(&self, line: usize) -> &str {
        self.source
            .lines()
            .nth(line.saturating_sub(1))
            .unwrap_or("")
    }

    fn note(&mut self, expr: &Expr, tier: Tier, construct: &str, why: &str, fix: &str) {
        self.report.count(tier);
        self.report.notes.push(Note {
            line: expr.span.line,
            col: expr.span.col,
            tier,
            construct: construct.to_string(),
            why: why.to_string(),
            fix: fix.to_string(),
        });
    }

    /// Classifies one expression, emitting a note when the construct has a cheap rewrite.
    fn expr(&mut self, expr: &Expr) {
        match &expr.kind {
            // `[1, 'a']` — a mixed literal cannot stay an unboxed `[int]` or `[str]`, so every element
            // becomes a boxed tag+payload and every read pays a tag check.
            ExprKind::ArrayLit(items) => {
                let kinds: Vec<Option<&'static str>> = items.iter().map(literal_type).collect();
                let distinct: HashSet<&'static str> = kinds.iter().flatten().copied().collect();
                if distinct.len() > 1 {
                    let mut seen = Vec::new();
                    for kind in &kinds {
                        if let Some(kind) = kind {
                            if !seen.contains(kind) {
                                seen.push(*kind);
                            }
                        }
                    }
                    let construct = self.line_text(expr.span.line).trim().to_string();
                    self.note(
                        expr,
                        Tier::Any,
                        &format!("`{construct}` — mixed element types {}", seen.join(" + ")),
                        "a list literal with two element types cannot be `[int]` or `[str]`; it becomes \
                         `[any]`, so every read is a tag check and every element is boxed",
                        "keep one element type per list (`xs: [str]` with `['a', 'b']`), or hold the two \
                         shapes in a tuple (`(1, 'a')`) if the position — not the type — is what \
                         distinguishes them",
                    );
                } else {
                    self.report.count(if items.is_empty() {
                        Tier::Any
                    } else {
                        Tier::Static
                    });
                }
                for item in items {
                    self.expr(item);
                }
            }
            // `list(range(3))` — the range is already a closed-form sequence; materializing it allocates
            // a buffer and copies, and the loop that follows could have iterated the range itself.
            ExprKind::Call { name, args } => {
                if name == "list" {
                    if let Some(inner) = args.first() {
                        let derives_range =
                            matches!(&inner.kind, ExprKind::Call { name, .. } if name == "range");
                        if derives_range {
                            self.note(
                                expr,
                                Tier::Heap,
                                "`list(range(n))` — materializes a closed-form range",
                                "`range` is already an iterator with no storage; `list(...)` allocates \
                                 a buffer of n elements and copies every index into it, only for \
                                 `for x in xs:` to read them straight back",
                                "iterate the range directly (`for i in range(n):`) or bind it once and \
                                 index it; if random access to the indices is genuinely needed, use a \
                                 typed array literal so LLVM keeps it in registers",
                            );
                            for arg in args {
                                self.expr(arg);
                            }
                            return;
                        }
                    }
                }
                for arg in args {
                    self.expr(arg);
                }
            }
            ExprKind::CallExpr { callee, args } => {
                self.expr(callee);
                for arg in args {
                    self.expr(arg);
                }
            }
            ExprKind::CallKw { pos_args, .. }
            | ExprKind::CallGeneric { pos_args, .. } => {
                for arg in pos_args {
                    self.expr(arg);
                }
            }
            // `2 ** 100` — an exponent whose magnitude cannot fit in `i64`, so the multiplication chain
            // is emitted with overflow checks that can only ever trap (*or*, for a float base, an
            // `llvm.pow` call that LLVM will not const-fold at `-O2`).
            ExprKind::Binary { op, lhs, rhs } if matches!(op, BinOp::Pow) => {
                let overflow = match (&lhs.kind, &rhs.kind) {
                    (ExprKind::Int(base), ExprKind::Int(exp)) if *exp >= 0 => {
                        let mut value: i128 = 1;
                        let mut overflows = false;
                        for _ in 0..*exp {
                            value *= i128::from(*base);
                            if value > i128::from(i64::MAX) || value < i128::from(i64::MIN) {
                                overflows = true;
                                break;
                            }
                        }
                        Some(overflows)
                    }
                    _ => None,
                };
                match overflow {
                    Some(true) => {
                        let construct = self.line_text(expr.span.line).trim().to_string();
                        self.note(
                            expr,
                            Tier::Static,
                            &format!("`{construct}` — the result cannot fit in `i64`"),
                            "both dialects check integer overflow, so this power is a chain of \
                             multiplications whose result is provably out of range: it either traps at \
                             run time or (with a `float` seed) becomes an `llvm.pow` call that cannot be \
                             constant-folded",
                            "if the value is meant to be exact, keep it under 2^63 with an explicit \
                             checked step (`if n > 20: ...` before `2 ** n`); if it is meant to be \
                             approximate, make one operand a float (`2.0 ** 100`) so the intent is \
                             visible and the code uses `f64` instead of trapping",
                        );
                    }
                    Some(false) => self.report.count(Tier::Static),
                    None => {
                        // A dynamic exponent cannot be folded; that is the only case worth nothing.
                        self.report.count(Tier::Any);
                    }
                }
                self.expr(lhs);
                self.expr(rhs);
            }
            // A boxed variable read: every use is a tag dispatch.
            ExprKind::Var(name) if self.dynamic.contains(name) => {
                self.note(
                    expr,
                    Tier::Any,
                    &format!("`{name}` holds more than one type over its lifetime"),
                    "a binding that changes type between statements cannot be unboxed; it becomes \
                     `%ArchxAny`, so each read branches on its tag",
                    &format!(
                        "use one type per binding (`{name}` as `int` or as `str`, with a second name for \
                         the other), or declare it `any` and read it once into a typed local before a hot \
                         loop"
                    ),
                );
                self.report.count(Tier::Any);
            }
            // `if xs:` on a collection literal — truthiness of a heap value needs its length.
            ExprKind::Var(name) => {
                let _ = name;
                self.report.count(Tier::Static);
            }
            _ => {
                self.report.count(Tier::Static);
                self.children(expr);
            }
        }
    }

    /// Recurses into sub-expressions so nested constructs are not missed.
    fn children(&mut self, expr: &Expr) {
        match &expr.kind {
            ExprKind::Binary { lhs, rhs, .. } => {
                self.expr(lhs);
                self.expr(rhs);
            }
            ExprKind::CompareChain(operands) => {
                for (operand, _) in operands {
                    self.expr(operand);
                }
            }
            ExprKind::Unary { expr, .. } => self.expr(expr),
            ExprKind::Index { target, index } => {
                self.expr(target);
                self.expr(index);
            }
            ExprKind::Field { target, .. } => self.expr(target),
            ExprKind::MethodCall { target, args, .. } => {
                self.expr(target);
                for arg in args {
                    self.expr(arg);
                }
            }
            ExprKind::MethodCallKw {
                target,
                pos_args,
                kw_args,
                ..
            } => {
                self.expr(target);
                for arg in pos_args {
                    self.expr(arg);
                }
                for (_, value, _) in kw_args {
                    self.expr(value);
                }
            }
            ExprKind::PercentFormat { args, .. } => self.expr(args),
            ExprKind::IfExpr {
                then_expr,
                cond,
                else_expr,
            } => {
                self.expr(then_expr);
                self.expr(cond);
                self.expr(else_expr);
            }
            ExprKind::TupleLit(items) | ExprKind::SetLit(items) => {
                for item in items {
                    self.expr(item);
                }
            }
            ExprKind::FString(parts) => {
                for part in parts {
                    if let FStrPart::Expr(expr) = part {
                        self.expr(expr);
                    }
                }
            }
            _ => {}
        }
    }

    fn stmts(&mut self, stmts: &[Stmt]) {
        for stmt in stmts {
            self.stmt(stmt);
        }
    }

    fn stmt(&mut self, stmt: &Stmt) {
        match &stmt.kind {
            StmtKind::Let { value, .. } => self.expr(value),
            StmtKind::Assign { target, value, .. } => {
                if let AssignTarget::Index { index, .. } = target {
                    self.expr(index);
                }
                self.expr(value);
            }
            StmtKind::Return(Some(expr)) | StmtKind::Expr(expr) => self.expr(expr),
            StmtKind::Return(None) => {}
            StmtKind::If {
                cond,
                then_body,
                else_body,
            } => {
                self.truthiness(cond);
                self.stmts(then_body);
                if let Some(body) = else_body {
                    self.stmts(body);
                }
            }
            StmtKind::While { cond, body } => {
                self.truthiness(cond);
                self.stmts(body);
            }
            StmtKind::For { body, .. } => {
                // `for i in start..end` compiles to an induction variable: no per-iteration storage.
                self.report.count(Tier::Iterator);
                self.stmts(body);
            }
            StmtKind::ForEach { iter, body, .. } => {
                self.expr(iter);
                self.stmts(body);
            }
            StmtKind::ForEnumerate { iter, body, .. } => {
                self.expr(iter);
                self.stmts(body);
            }
            StmtKind::ForDictItems { dict, body, .. } => {
                self.expr(dict);
                self.stmts(body);
            }
            StmtKind::ForZip { iters, body, .. } => {
                for iter in iters {
                    self.expr(iter);
                }
                self.stmts(body);
            }
            StmtKind::ForTupleUnpack { iter, body, .. } => {
                self.expr(iter);
                self.stmts(body);
            }
            StmtKind::TupleAssign { value, .. } => self.expr(value),
            StmtKind::Match { subject, cases } => {
                self.expr(subject);
                for case in cases {
                    self.stmts(&case.body);
                }
            }
            _ => {}
        }
    }

    /// `if xs:` — a condition whose truth depends on a collection's length is not a comparison, so the
    /// backend must load the length (and, for a boxed value, dispatch on the tag) where `xs != []` or
    /// `len(xs) != 0` would be a compare against a known-zero constant.
    fn truthiness(&mut self, cond: &Expr) {
        if let ExprKind::Var(name) = &cond.kind {
            if self.collections.contains(name) {
                // `if xs:` — the only shape the acceptance criteria name explicitly, and the one people
                // write most: it is a length load, and for a boxed binding a tag check as well.
                self.note(
                    cond,
                    Tier::Heap,
                    &format!("`if {name}:` — truthiness of a collection"),
                    "a bare collection in a condition is resolved by loading its length and comparing \
                     against zero on every evaluation; nothing about it can be hoisted or folded, and a \
                     boxed binding adds a tag dispatch on top",
                    &format!(
                        "compare against the emptiness you mean: `if len({name}) != 0:` is the same \
                         check with a statically known comparison, and hoisting it out of a loop \
                         (`n = len({name})` before the loop) lets LLVM keep the length in a register"
                    ),
                );
                return;
            }
            if self.dynamic.contains(name) {
                self.note(
                    cond,
                    Tier::Any,
                    &format!("`if {name}:` — truthiness of a possibly-boxed value"),
                    "a binding that changes type cannot be unboxed; it becomes `%ArchxAny`, so the \
                     condition is a tag dispatch before the value can be tested",
                    &format!(
                        "give the binding one type (`{name}` as `bool`, or as the collection it holds) so \
                         the condition becomes a register test"
                    ),
                );
                return;
            }
            self.report.count(Tier::Static);
            return;
        }
        self.report.count(Tier::Static);
        self.expr(cond);
    }
}

/// Annotates a whole program.
pub fn analyze(program: &Program, source: &str) -> Report {
    // Each function is analysed with its own locals: a name that is dynamic in one function says nothing
    // about the same name in another, and one shared set would over-report.
    let mut walker = Walker {
        dynamic: HashSet::new(),
        collections: HashSet::new(),
        report: Report::default(),
        source,
    };
    for func in &program.funcs {
        walker.dynamic.clear();
        walker.collections.clear();
        dynamic_vars(&func.body, &mut walker.dynamic);
        collection_vars(&func.body, &mut walker.collections);
        walker.stmts(&func.body);
    }
    let mut report = walker.report;
    // Deterministic order: by line, then column, then tier. The backend emits definitions in canonical
    // order for reproducibility (AX-012) and a report that reshuffles between runs would break the same
    // rule for its own output.
    report
        .notes
        .sort_by_key(|note| (note.line, note.col, note.tier.label()));
    report
}

/// Renders the whole report, notes first and the summary last.
pub fn render(report: &Report, min: Option<Tier>) -> String {
    let mut out = String::new();
    for note in report.filtered(min) {
        out.push_str(&note.render());
    }
    let _ = writeln!(out, "{}", report.summary());
    out
}

#[cfg(test)]
mod tests {
    use super::*;

    fn analyze_source(source: &str) -> Report {
        let tokens = crate::lexer::Lexer::new(source).tokenize().expect("lexes");
        let mut program = crate::parser::Parser::new(tokens)
            .parse_program()
            .expect("parses");
        program.dialect = crate::dialect::DialectSpec {
            dialect: crate::dialect::Dialect::Native,
            version: 1,
            source: crate::dialect::DialectSource::Cli,
        };
        analyze(&program, source)
    }

    #[test]
    fn the_four_named_constructs_each_get_a_specific_actionable_note() {
        let source = "# archx: dialect=native, version=1\n\n\n\
             def show(i: int) -> int:\n\
             \x20   xs = [1, 'a']\n\
             \x20   if xs:\n\
             \x20       print(xs)\n\
             \x20   ys = list(range(3))\n\
             \x20   print(ys)\n\
             \x20   print(2 ** 100)\n\
             \x20   return 0\n";
        let report = analyze_source(source);
        let rendered = render(&report, None);

        // Each construct is named, priced, explained, and given a rewrite. A note that only says
        // "this is slow" would be noise, so the test insists on all four parts.
        for (construct, tier, fix_fragment) in [
            ("mixed element types", "any", "keep one element type per list"),
            ("`if xs:`", "heap", "if len(xs) != 0:"),
            ("`list(range(n))`", "heap", "for i in range(n):"),
            ("the result cannot fit in `i64`", "static", "2.0 ** 100"),
        ] {
            let note = report
                .notes
                .iter()
                .find(|note| note.construct.contains(construct))
                .unwrap_or_else(|| panic!("no note for `{construct}`:\n{rendered}"));
            assert_eq!(note.tier.label(), tier, "tier of `{construct}`");
            assert!(
                note.fix.contains(fix_fragment),
                "fix for `{construct}` should mention `{fix_fragment}`: {}",
                note.fix
            );
            assert!(!note.why.is_empty(), "`{construct}` needs a reason");
        }
    }

    #[test]
    fn a_clean_program_produces_no_notes() {
        // The report must be quiet when the code is already static: a tool that always warns is a tool
        // people learn to ignore.
        let source = "# archx: dialect=native, version=1\n\n\n\
             def total(n: int) -> int:\n\
             \x20   acc = 0\n\
             \x20   for i in range(n):\n\
             \x20       acc += i\n\
             \x20   return acc\n";
        let report = analyze_source(source);
        assert!(report.notes.is_empty(), "{}", render(&report, None));
        assert!(report.summary().contains("iterator"), "{}", report.summary());
    }

    #[test]
    fn no_fix_ever_trades_a_safety_check_for_speed() {
        // The standing rule: optimisation may never weaken a guarantee. Every fix-it is about
        // representation, so none of them may suggest removing a bounds, overflow, or ownership check.
        let forbidden = [
            "unchecked",
            "no_bounds",
            "disable",
            "skip the check",
            "turn off",
            "unsafe",
        ];
        let source = "# archx: dialect=native, version=1\n\n\n\
             def show(i: int) -> int:\n\
             \x20   xs = [1, 'a']\n\
             \x20   if xs:\n\
             \x20       print(xs)\n\
             \x20   ys = list(range(3))\n\
             \x20   print(ys)\n\
             \x20   print(2 ** 100)\n\
             \x20   return 0\n";
        let report = analyze_source(source);
        assert!(!report.notes.is_empty());
        for note in &report.notes {
            let text = format!("{} {} {}", note.construct, note.why, note.fix).to_lowercase();
            for word in forbidden {
                assert!(
                    !text.contains(word),
                    "fix-it for `{}` mentions `{word}`: {}",
                    note.construct,
                    note.fix
                );
            }
        }
    }

    #[test]
    fn min_tier_filters_by_cost_and_notes_are_deterministic() {
        let source = "# archx: dialect=native, version=1\n\n\n\
             def show(i: int) -> int:\n\
             \x20   xs = [1, 'a']\n\
             \x20   if xs:\n\
             \x20       print(xs)\n\
             \x20   return 0\n";
        let report = analyze_source(source);
        assert_eq!(report.filtered(None).len(), report.notes.len());
        assert!(report.filtered(Some(Tier::Heap)).len() < report.notes.len());
        assert!(report.filtered(Some(Tier::Unwind)).is_empty());

        // Running twice must produce identical text, or a diff-based workflow sees phantom changes.
        assert_eq!(render(&report, None), render(&analyze_source(source), None));
    }
}
