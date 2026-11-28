//! Stable diagnostic codes: every error this compiler emits has a code, and the code owns its
//! explanation.
//!
//! A code is a promise to the outside world. A message can be improved at any time — better wording,
//! a suggested fix, a span that points more precisely — but the code must keep meaning the same
//! thing, because it is what scripts, editors and users grep for. So the code list here is the
//! authority, and `archx explain E0301` renders the entry from this same table: documentation cannot
//! drift from behaviour because there is only one copy.
//!
//! The ranges are deliberate:
//!
//! | Range | Area | Raised by |
//! |---|---|---|
//! | `E0xxx` | usage / driver | `src/main.rs` (bad flags, bad paths, no `clang`) |
//! | `E01xx` | dialect contract | `src/dialect.rs` |
//! | `E02xx` | lexing | `src/lexer.rs` |
//! | `E03xx` | parsing / syntax | `src/parser.rs` |
//! | `E04xx` | types & calls | the type checker and call lowering |
//! | `E05xx` | names / modules | resolution of variables, functions, types |
//! | `E06xx` | collections | list/dict/set/tuple operations |
//! | `E07xx` | control flow | loops, `break`/`continue` placement, `match` |
//! | `E08xx` | dialect semantics | a construct exists in the other contract only |
//! | `E09xx` | internal | a compiler invariant broke — always a bug, never the user's fault |
//!
//! `E09xx` is special: those diagnostics mean Archx has a defect. They are reported as such in the
//! message and in machine-readable output, and they are never used to reject a program the compiler
//! merely does not understand yet.

/// A stable error code and everything known about it.
///
/// Every variant is one code. `as_str` is the wire form (`"E0301"`), `summary` is the one-line title
/// `archx explain` shows, and `detail` is the explanation.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Code {
    // ---- E0xxx: usage and driver ------------------------------------------------------------
    /// `E0001`: a flag the compiler does not understand.
    UnknownOption,
    /// `E0002`: a flag that needs a value did not get one.
    MissingOptionValue,
    /// `E0003`: the input file is missing or unreadable.
    UnreadableInput,
    /// `E0004`: more than one input file was given.
    MultipleInputs,
    /// `E0005`: `-o` would overwrite the source file.
    OutputWouldClobberSource,
    /// `E0006`: a transient file could not be created or written.
    TemporaryFileFailed,
    /// `E0007`: `clang` is missing, failed, or could not be executed.
    ToolchainFailed,

    // ---- E01xx: the dialect contract --------------------------------------------------------
    /// `E0100`: the module has no `# archx: dialect=…` directive.
    MissingDirective,
    /// `E0101`: the directive is malformed or names an unsupported value.
    MalformedDirective,

    // ---- E02xx: lexing ----------------------------------------------------------------------
    /// `E0201`: a string or f-string literal is not terminated.
    UnterminatedLiteral,
    /// `E0202`: a numeric literal does not parse.
    InvalidNumber,
    /// `E0203`: characters the lexer cannot form a token from.
    InvalidCharacter,
    /// `E0204`: an f-string placeholder or format spec is malformed.
    MalformedFormat,

    // ---- E03xx: parsing ---------------------------------------------------------------------
    /// `E0301`: a token appeared where the grammar did not allow it.
    UnexpectedToken,
    /// `E0302`: a block that the grammar requires to contain a statement is empty.
    EmptyBlock,
    /// `E0303`: indentation does not match any enclosing block.
    BadIndentation,
    /// `E0304`: a construct is used outside the context that permits it.
    MisplacedStatement,

    // ---- E04xx: types and calls -------------------------------------------------------------
    /// `E0401`: an operator was applied to types it is not defined for.
    OperatorTypeMismatch,
    /// `E0402`: a value of the wrong type was used where a specific type is required.
    TypeMismatch,
    /// `E0403`: a call's arguments do not match the signature.
    BadCallArguments,
    /// `E0404`: a value is used at a type that is not known or not valid there.
    InvalidType,
    /// `E0405`: a conversion between two types is not defined.
    InvalidConversion,

    // ---- E05xx: names -----------------------------------------------------------------------
    /// `E0501`: a variable is read before it is defined.
    UndefinedVariable,
    /// `E0502`: a function is called but never defined.
    UndefinedFunction,
    /// `E0503`: a type name is not declared.
    UnknownType,
    /// `E0504`: a member is not present on a value.
    UnknownMember,
    /// `E0505`: a name is defined twice.
    DuplicateDefinition,
    /// `E0506`: a builtin or type name is being shadowed.
    ReservedName,

    // ---- E06xx: collections -----------------------------------------------------------------
    /// `E0601`: an index or length is out of the range the operation allows.
    IndexOutOfRange,
    /// `E0602`: a collection operation is applied to a value that does not support it.
    UnsupportedCollectionOp,
    /// `E0603`: literal elements disagree about their type.
    HeterogeneousLiteral,

    // ---- E07xx: control flow ----------------------------------------------------------------
    /// `E0701`: `break`/`continue` outside a loop.
    LoopControlOutsideLoop,
    /// `E0702`: a function that must return a value has a path that does not.
    MissingReturn,
    /// `E0703`: a `match` has no arm that can apply.
    NonExhaustiveMatch,
    /// `E0704`: a loop range is malformed (zero step, mismatched bounds).
    BadRange,

    // ---- E08xx: dialect semantics -----------------------------------------------------------
    /// `E0801`: the construct exists in the other dialect only, or lowers differently per dialect.
    DialectSpecific,

    // ---- E09xx: internal --------------------------------------------------------------------
    /// `E0901`: a compiler invariant was violated. Always an Archx bug.
    InternalInvariant,
}

impl Code {
    /// The wire form, e.g. `"E0301"`.
    pub fn as_str(self) -> &'static str {
        match self {
            Code::UnknownOption => "E0001",
            Code::MissingOptionValue => "E0002",
            Code::UnreadableInput => "E0003",
            Code::MultipleInputs => "E0004",
            Code::OutputWouldClobberSource => "E0005",
            Code::TemporaryFileFailed => "E0006",
            Code::ToolchainFailed => "E0007",
            Code::MissingDirective => "E0100",
            Code::MalformedDirective => "E0101",
            Code::UnterminatedLiteral => "E0201",
            Code::InvalidNumber => "E0202",
            Code::InvalidCharacter => "E0203",
            Code::MalformedFormat => "E0204",
            Code::UnexpectedToken => "E0301",
            Code::EmptyBlock => "E0302",
            Code::BadIndentation => "E0303",
            Code::MisplacedStatement => "E0304",
            Code::OperatorTypeMismatch => "E0401",
            Code::TypeMismatch => "E0402",
            Code::BadCallArguments => "E0403",
            Code::InvalidType => "E0404",
            Code::InvalidConversion => "E0405",
            Code::UndefinedVariable => "E0501",
            Code::UndefinedFunction => "E0502",
            Code::UnknownType => "E0503",
            Code::UnknownMember => "E0504",
            Code::DuplicateDefinition => "E0505",
            Code::ReservedName => "E0506",
            Code::IndexOutOfRange => "E0601",
            Code::UnsupportedCollectionOp => "E0602",
            Code::HeterogeneousLiteral => "E0603",
            Code::LoopControlOutsideLoop => "E0701",
            Code::MissingReturn => "E0702",
            Code::NonExhaustiveMatch => "E0703",
            Code::BadRange => "E0704",
            Code::DialectSpecific => "E0801",
            Code::InternalInvariant => "E0901",
        }
    }

    /// The one-line title shown by `archx explain` and in `--message-format=json`.
    pub fn summary(self) -> &'static str {
        match self {
            Code::UnknownOption => "unknown command-line option",
            Code::MissingOptionValue => "missing value for an option",
            Code::UnreadableInput => "input file cannot be read",
            Code::MultipleInputs => "more than one input file",
            Code::OutputWouldClobberSource => "output path would overwrite the source",
            Code::TemporaryFileFailed => "cannot create a temporary file",
            Code::ToolchainFailed => "the C toolchain is missing or failed",
            Code::MissingDirective => "the module does not declare its dialect",
            Code::MalformedDirective => "the dialect directive is malformed",
            Code::UnterminatedLiteral => "unterminated string literal",
            Code::InvalidNumber => "invalid numeric literal",
            Code::InvalidCharacter => "invalid character",
            Code::MalformedFormat => "malformed f-string or format spec",
            Code::UnexpectedToken => "unexpected token",
            Code::EmptyBlock => "empty block",
            Code::BadIndentation => "inconsistent indentation",
            Code::MisplacedStatement => "statement in the wrong place",
            Code::OperatorTypeMismatch => "operator does not accept these types",
            Code::TypeMismatch => "type mismatch",
            Code::BadCallArguments => "wrong number or kind of arguments",
            Code::InvalidType => "invalid type",
            Code::InvalidConversion => "invalid conversion",
            Code::UndefinedVariable => "undefined variable",
            Code::UndefinedFunction => "undefined function",
            Code::UnknownType => "unknown type",
            Code::UnknownMember => "unknown member",
            Code::DuplicateDefinition => "duplicate definition",
            Code::ReservedName => "reserved name",
            Code::IndexOutOfRange => "index out of range",
            Code::UnsupportedCollectionOp => "unsupported collection operation",
            Code::HeterogeneousLiteral => "mixed element types in a literal",
            Code::LoopControlOutsideLoop => "loop control outside a loop",
            Code::MissingReturn => "missing return",
            Code::NonExhaustiveMatch => "non-exhaustive match",
            Code::BadRange => "invalid range",
            Code::DialectSpecific => "construct not available in this dialect",
            Code::InternalInvariant => "internal compiler error",
        }
    }

    /// The full explanation `archx explain <code>` prints.
    pub fn detail(self) -> &'static str {
        match self {
            Code::UnknownOption => {
                "The driver did not recognise a command-line argument. Note that `archx` takes a single \
                 input file: an option after the file is still an option, so a stray word is reported \
                 here. Run `archx --help` for the accepted flags."
            }
            Code::MissingOptionValue => {
                "An option that requires a value was the last argument, or was followed by another \
                 option. Every value-taking option (`-o`, `-O`, `--dialect`) accepts both the joined \
                 form (`-O\") and the separated form (`-O 2`)."
            }
            Code::UnreadableInput => {
                "The source file could not be opened. This covers a missing path, a directory, and a \
                 file the process may not read. Archx compiles exactly one module per invocation."
            }
            Code::MultipleInputs => {
                "Archx compiles one module per invocation. Module graphs and `import` are a later \
                 work order; until then, split a program into one file."
            }
            Code::OutputWouldClobberSource => {
                "`-o` named the input file itself (or a path resolving to it), which would destroy the \
                 source. Choose a different output path."
            }
            Code::TemporaryFileFailed => {
                "Archx hands clang a temporary `.ll` file. Creating it failed — usually `TMPDIR` points \
                 somewhere unwritable, or the disk is full."
            }
            Code::ToolchainFailed => {
                "Archx emits LLVM IR and asks `clang` to produce the executable. Either no `clang` was \
                 found on `PATH` (set `ARCHX_CC=/path/to/clang` to choose one), or it ran and \
                 rejected the IR, which is a compiler bug rather than a problem with your program."
            }
            Code::MissingDirective => {
                "Every module must declare which contract it is compiled against, on its first line: \
                 `# archx: dialect=compat, version=1` or `# archx: dialect=native, version=1`. The two \
                 dialects differ in observable behaviour (`int` overflow, string indexing, \
                 `repr`), so guessing would make the output depend on a compiler default."
            }
            Code::MalformedDirective => {
                "The first line starts with `# archx:` but is not a valid directive. It must be two \
                 comma-separated `key=value` fields: `dialect` (`compat` or `native`) and `version` \
                 (currently `1`). The message names the offending field."
            }
            Code::UnterminatedLiteral => {
                "A string or f-string literal reached the end of the file (or of its line) without a \
                 closing quote. Multi-line strings must use the triple-quoted form."
            }
            Code::InvalidNumber => {
                "A numeric literal could not be parsed, or does not fit the type it is assigned to. \
                 `int` is a 64-bit integer: a decimal literal outside `i64` range is rejected here \
                 rather than silently wrapped (see `docs/LIMITATIONS.md`)."
            }
            Code::InvalidCharacter => {
                "The lexer found a character that cannot begin any token — commonly a Unicode \
                 punctuation mark copied from a document, or a smart quote instead of `\"`."
            }
            Code::MalformedFormat => {
                "An f-string placeholder or a `%` format spec is not valid: an unknown conversion, an \
                 unsupported width/precision, or a dangling `{`/`}`. In a `compat` module these must \
                 match CPython."
            }
            Code::UnexpectedToken => {
                "The parser reached a token the grammar does not allow at that point. Archx follows \
                 Python's statement grammar with 4-space indentation and no semicolons, so a missing \
                 `:` or a mis-indented line usually surfaces here."
            }
            Code::EmptyBlock => {
                "A function, method, class, loop or branch body is empty. Archx requires at least one \
                 statement; write `pass` if the block is intentionally empty."
            }
            Code::BadIndentation => {
                "Indentation does not line up with any enclosing block. Blocks indent by 4 spaces per \
                 level, and tabs in leading indentation are rejected: mixing tabs and spaces makes the \
                 block structure ambiguous."
            }
            Code::MisplacedStatement => {
                "A statement appeared where the grammar does not permit it — for example `break` \
                 outside a loop, or a `return` outside a function."
            }
            Code::OperatorTypeMismatch => {
                "An operator was applied to operands whose types do not define it. Archx is statically \
                 typed: `+` is `int`+`int`, `float`+`float` or `str`+`str` (no implicit `int`/`float` \
                 mixing, and no `bool`/`int` arithmetic)."
            }
            Code::TypeMismatch => {
                "A value was used at a type it does not have: assigning a `str` to an `int` variable, \
                 passing the wrong type, or a branch whose arms disagree. The message names both the \
                 expected and the found type."
            }
            Code::BadCallArguments => {
                "A call supplied the wrong number or kind of arguments for the function or builtin. \
                 Keyword arguments are supported where the callee names its parameters."
            }
            Code::InvalidType => {
                "A type annotation is not valid in that position — an unknown type, a `void` \
                 parameter, an unsized value where a sized one is required, or a generic used without \
                 its arguments."
            }
            Code::InvalidConversion => {
                "A conversion between two types is not defined. Archx has explicit `int(...)`, \
                 `float(...)` and `str(...)` conversions; there are no implicit numeric coercions."
            }
            Code::UndefinedVariable => {
                "A name was read before any binding for it exists in scope. Inside a function, a name \
                 assigned only later in the body is still undefined at the point of use, exactly as in \
                 Python."
            }
            Code::UndefinedFunction => {
                "A function was called but never defined, and it is not a builtin. Check the spelling, \
                 or define it before `main`."
            }
            Code::UnknownType => {
                "A type name does not refer to a declared `struct`, `class`, `enum`, or builtin type. \
                 Types are declared in the same module and must appear before use; a generic type \
                 also needs its arguments (`Box[int]`, not `Box`), and a type parameter is only \
                 visible inside the declaration that introduces it."
            }
            Code::UnknownMember => {
                "A field or method was accessed on a value whose type does not have it. The message \
                 lists what that type does support."
            }
            Code::DuplicateDefinition => {
                "The same name was defined twice in one scope: two functions or two parameters with the \
                 same name, or a field repeated in a `struct`."
            }
            Code::ReservedName => {
                "A builtin function or builtin type name is being redefined. Builtins are resolved \
                 before user definitions, so redefining one would be invisible."
            }
            Code::IndexOutOfRange => {
                "An index or length is outside what the operation allows. A negative index is checked \
                 at run time and traps rather than reading out of bounds; a literal index that is \
                 provably out of range is rejected here at compile time."
            }
            Code::UnsupportedCollectionOp => {
                "The operation is not defined for that collection type — for example a mutating method \
                 on a value bound with `let`, or an operation on a fixed-size array that would change \
                 its length."
            }
            Code::HeterogeneousLiteral => {
                "Elements of a list, dict or set literal disagree about their type. Archx containers \
                 are homogeneous; use a documented union such as `T | None` or an `enum` when the \
                 elements genuinely differ."
            }
            Code::LoopControlOutsideLoop => {
                "`break` or `continue` appeared outside any loop body. They may only appear inside \
                 `while`, `for`, or `for…else`."
            }
            Code::MissingReturn => {
                "A function declared to return a value has a path that reaches the end without \
                 returning. Every reachable path must `return`."
            }
            Code::NonExhaustiveMatch => {
                "A `match` has no arm that can apply to the scrutinee's type. Add the missing \
                 variants, or a wildcard `case _:` arm."
            }
            Code::BadRange => {
                "A loop range is malformed: a non-integer bound, mismatched bound types, or a step of \
                 zero. A zero step is rejected because the loop would never terminate."
            }
            Code::DialectSpecific => {
                "The construct belongs to the other dialect, or means something different in each. \
                 Archx refuses to pick silently: change the module's directive (or pass `--dialect`) \
                 if the other contract is what you want. See `docs/LIMITATIONS.md` for what each \
                 dialect provides."
            }
            Code::InternalInvariant => {
                "A compiler invariant was violated. This is an Archx bug, not a mistake in your \
                 program: the message names the invariant. Please report it with the source that \
                 triggered it."
            }
        }
    }

    /// Whether this code means the compiler itself is at fault.
    pub fn is_internal(self) -> bool {
        matches!(self, Code::InternalInvariant)
    }

    /// Every code, in numeric order, for `archx explain` with no argument and for the docs generator.
    pub fn all() -> &'static [Code] {
        &[
            Code::UnknownOption,
            Code::MissingOptionValue,
            Code::UnreadableInput,
            Code::MultipleInputs,
            Code::OutputWouldClobberSource,
            Code::TemporaryFileFailed,
            Code::ToolchainFailed,
            Code::MissingDirective,
            Code::MalformedDirective,
            Code::UnterminatedLiteral,
            Code::InvalidNumber,
            Code::InvalidCharacter,
            Code::MalformedFormat,
            Code::UnexpectedToken,
            Code::EmptyBlock,
            Code::BadIndentation,
            Code::MisplacedStatement,
            Code::OperatorTypeMismatch,
            Code::TypeMismatch,
            Code::BadCallArguments,
            Code::InvalidType,
            Code::InvalidConversion,
            Code::UndefinedVariable,
            Code::UndefinedFunction,
            Code::UnknownType,
            Code::UnknownMember,
            Code::DuplicateDefinition,
            Code::ReservedName,
            Code::IndexOutOfRange,
            Code::UnsupportedCollectionOp,
            Code::HeterogeneousLiteral,
            Code::LoopControlOutsideLoop,
            Code::MissingReturn,
            Code::NonExhaustiveMatch,
            Code::BadRange,
            Code::DialectSpecific,
            Code::InternalInvariant,
        ]
    }

    /// Looks a code up by its wire form, accepting either case (`e0301` == `E0301`).
    pub fn parse(text: &str) -> Option<Code> {
        let wanted = text.trim().to_ascii_uppercase();
        Code::all()
            .iter()
            .copied()
            .find(|code| code.as_str() == wanted)
    }
}

impl std::fmt::Display for Code {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(self.as_str())
    }
}

/// The `archx explain` text for one code, or for the whole list when `code` is `None`.
pub fn explain(code: Option<Code>) -> String {
    match code {
        Some(code) => format!(
            "{code}: {}\n\n{}\n",
            code.summary(),
            wrap(code.detail(), 96)
        ),
        None => {
            let mut out = String::from("Error codes\n\n");
            out.push_str("Run `archx explain <CODE>` for the full explanation of one code.\n\n");
            let mut last_group = None;
            for code in Code::all() {
                let group = code.group();
                if last_group != Some(group) {
                    out.push_str(&format!("\n{group}\n"));
                    last_group = Some(group);
                }
                out.push_str(&format!("  {code}  {}\n", code.summary()));
            }
            out.push('\n');
            out
        }
    }
}

impl Code {
    /// The area heading the code belongs to, used by `archx explain` and the generated docs.
    pub fn group(self) -> &'static str {
        match self.as_str().as_bytes()[1] {
            b'0' if self.as_str().as_bytes()[2] == b'0' => "Driver (E00xx)",
            b'0' => "Dialect contract (E01xx)",
            b'2' => "Lexing (E02xx)",
            b'3' => "Parsing (E03xx)",
            b'4' => "Types and calls (E04xx)",
            b'5' => "Names (E05xx)",
            b'6' => "Collections (E06xx)",
            b'7' => "Control flow (E07xx)",
            b'8' => "Dialect semantics (E08xx)",
            _ => "Internal (E09xx)",
        }
    }
}

/// Wraps prose to `width` columns on spaces, so long explanations stay readable in a terminal.
fn wrap(text: &str, width: usize) -> String {
    let mut out = String::new();
    let mut line = String::new();
    for word in text.split_whitespace() {
        if line.is_empty() {
            line.push_str(word);
        } else if line.len() + 1 + word.len() <= width {
            line.push(' ');
            line.push_str(word);
        } else {
            out.push_str(&line);
            out.push('\n');
            line.clear();
            line.push_str(word);
        }
    }
    if !line.is_empty() {
        out.push_str(&line);
        out.push('\n');
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::HashSet;

    #[test]
    fn codes_are_unique_and_well_formed() {
        let mut seen = HashSet::new();
        for code in Code::all() {
            let text = code.as_str();
            assert_eq!(text.len(), 5, "{text} must be `E` plus four digits");
            assert!(text.starts_with('E'), "{text} must start with E");
            assert!(
                text[1..].chars().all(|c| c.is_ascii_digit()),
                "{text} must be digits after E"
            );
            assert!(seen.insert(text), "{text} is declared twice");
            assert!(!code.summary().is_empty(), "{text} has no summary");
            assert!(
                code.detail().len() > 40,
                "{text} needs a real explanation, not a placeholder"
            );
            // A code in the internal range must say so, and nothing else may.
            assert_eq!(
                code.is_internal(),
                text.starts_with("E09"),
                "{text}: internal range and `is_internal` disagree"
            );
        }
    }

    #[test]
    fn codes_round_trip_through_parse() {
        for code in Code::all() {
            assert_eq!(Code::parse(code.as_str()), Some(*code));
            assert_eq!(Code::parse(&code.as_str().to_lowercase()), Some(*code));
        }
        assert_eq!(Code::parse("E9999"), None);
        assert_eq!(Code::parse("not a code"), None);
    }

    #[test]
    fn every_code_has_an_explain_entry() {
        for code in Code::all() {
            let text = explain(Some(*code));
            assert!(text.starts_with(code.as_str()), "{text}");
            assert!(text.contains(code.summary()), "{text}");
        }
        let overview = explain(None);
        for code in Code::all() {
            assert!(overview.contains(code.as_str()), "overview is missing {code}");
        }
    }

    #[test]
    fn explain_wraps_long_lines() {
        for code in Code::all() {
            for line in explain(Some(*code)).lines() {
                assert!(line.chars().count() <= 96, "unwrapped line: {line}");
            }
        }
    }
}
