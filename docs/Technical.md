<!-- Technical reference of the Archx stack, module inputs/outputs, and internal invariants. -->

# Technical Reference (`v0.8.0`)

## 1. Technology Stack
- **Implementation language**: Rust (`edition = "2021"`, `0` external crates in `Cargo.toml`).
- **Backend / Optimizer**: Textual LLVM IR lowered via `clang -O2` (`clang 15+`; verified on `clang 20` / `21` in CI).
- **Target OSes**: Linux (`ELF` + `glibc` + `-lm`), macOS (`Mach-O` + `libSystem`), Windows (`PE .exe` + `UCRT` / `-llegacy_stdio_definitions`).

---

## 2. File-by-File Inputs, Outputs & Responsibilities

| File | Input | Output | Responsibility |
|---|---|---|---|
| `src/main.rs` | CLI `args: &[String]`, `.archx.lang` file | Native executable, `--emit-ir` stdout, or exit code | CLI flag parsing, extension/clobber validation, temp `.ll` file management, `clang` invocation (`-lm` / MSVC), `--run`. |
| `src/diag.rs` | `line`, `col`, error message | `Span`, `Diagnostic`, `Result<T>` | 1-based source location tracking and structured error reporting. |
| `src/token.rs` | `Span`, token discriminant | `Token`, `TokenKind`, `FStrPart` | Lexical token vocabulary (`Pipe`, `Float`, `FStr`, `SlashSlash`, `StarStar`, `Is`, `Assert`, `Pass`, `With`, `NoneLit`, etc.). |
| `src/lexer.rs` | `&str` UTF-8 source | `Result<Vec<Token>>` | 4-space `Indent`/`Dedent`, `f"..."` interpolation lexer, float/exponent/`_` numbers, `|`, Python keywords. |
| `src/ast.rs` | `Span`, parsed nodes | `Program`, `StructDef`, `EnumDef`, `Func`, `Stmt`, `Pattern`, `Expr`, `Type` | Typed AST definitions shared between parser and codegen (`TupleAssign`, `Match`, `TupleLit`, `Optional`, `Enum`, etc.). |
| `src/parser.rs` | `Vec<Token>` | `Result<Program>` | Bounded-depth (`MAX_NESTING = 128`) parser for 1:1 Python (`def`, `class` + `__init__`, `enum`, `match`/`case`, tuples, `T \| None`, script `main`) & classic syntax. |
| `src/codegen/mod.rs` | `&Program` | `Result<String>` (LLVM IR) | `enum`/`struct`/method signature & receiver layout (`__init__`), `Codegen` state, function frames, and runtime flag finalization. |
| `src/codegen/analysis.rs` | `&[Stmt]`, `&Expr` | `AdaptiveHints`, escape/mutation sets | Two-tier adaptive specialization vs `%ArchxAny` promotion, SoA escape checking, monotonic `while` stride checking, const folding. |
| `src/codegen/tuples_enums.rs` | Tuple / `T \| None` / `EnumDef` AST | Aggregate/tagged LLVM IR | Zero-heap value tuples, `{ i1, T }` optionals + flow-sensitive narrowing, stack `enum` sum types, tuple unpacking, and composite RAII/region promotion. |
| `src/codegen/pattern_match.rs` | `subject: &Expr`, `&[MatchCase]` | Decision-DAG LLVM IR | `match` / `case` structural pattern matching (`\|`, `if` guards, destructuring, `T \| None` unwrapping, compile-time `enum` exhaustiveness). |
| `src/codegen/any.rs` | `Type`, `%ArchxAny` | Boxed/unboxed/dispatched IR | 24-byte `%ArchxAny` boxing/unboxing, runtime type guards, dynamic ops, indexing, and calls. |
| `src/codegen/collections.rs` | `dict`/`set`/slice AST | Planar SIMD & slice IR | Planar `<16 x i8>` SIMD `dict[K, V]` & `set[T]`, per-type drop/clone helpers, Pythonic slicing, and negative indexing. |
| `src/codegen/stmt.rs` | `&Stmt`, `&[Stmt]` | Appended LLVM IR | Pythonic implicit variable intro & adaptive rebinding, `let`, `with region:`, `int`/`bool`/`float` SoA setup, `assert`, `pass`, and assignments. |
| `src/codegen/loops.rs` | Loop AST nodes | Versioned/elided LLVM IR | `while`, `range`/`a..b` (pos/neg/dynamic steps), `for x in arr`, `for a, b in pairs`, `for k, v in d.items()`, `for ch in s`, and `enumerate`. |
| `src/codegen/expr.rs` | `&Expr`, `Option<&Type>` | `Result<(Type, String)>` | Literals, indexing, fields & `Enum.Variant`, `int` & `float` math (`//`, `**`), ternary (with `T \| None` narrowing), `in`/`not in`, SSO strings. |
| `src/codegen/calls.rs` | Call name & `&[CallArg]` | `Result<(Type, String)>` | User `fastcc` calls, `__init__` & positional/keyword constructors, `int`/`float`/`str`/`bool` casts, and LEGB soft built-ins. |
| `src/codegen/io.rs` | I/O & `f"..."` nodes | `Result<(Type, String)>` | `print(*args, sep=..., end=...)` (tuples, `T \| None`, `enum`, `dict`, `set`, `list`, `any`, `class`), `input([prompt])`, `str(x)`, and `f"..."`. |
| `src/codegen/methods.rs` | `Func` / receiver + method | `Result<(Type, String)>` | `class` `self` methods (by-ptr mutating / by-val read-only), `dict`/`set`/`list`/`any` methods, and SSO string methods. |
| `src/codegen/ownership.rs` | `Type`, SSA value / `Scope` | RAII drop/clone/promote IR | `stmt_temps` tracking, recursive drops, deep clones, and `region:` return heap promotion across all scalar and composite types. |
| `src/codegen/memory.rs` | Element `Type`, count/index | Checked `ptr` / bounds IR | `2^47` size checks, `align 16` `malloc`/`calloc`/`realloc`, `double` zero-page `calloc`, and bounds-check elision proofs. |
| `src/codegen/runtime.rs` | `used_*` flags | Private LLVM IR helpers | Core `@archx_region_*`, `@archx_str_*`, panic handlers, and core `libc`/intrinsic declarations. |
| `src/codegen/runtime_py.rs` | `used_*` Pythonic flags | Private LLVM IR helpers | `@archx_input`, `@archx_fmt_float_buf`, `@archx_str_from_slice`, `int`/`float` parsers, string methods, and panic helpers. |
| `src/codegen/runtime_hash_any.rs` | `used_dict_*` / `used_any_rt` | Private LLVM IR helpers | Planar `<16 x i8>` SIMD SwissTable runtime, `@archx_slice_bounds`, `@archx_str_slice`, and `%ArchxAny` dynamic runtime helpers. |
| `src/codegen/tests.rs` | Inline Archx snippets | Unit test assertions | Verifies IR generation, tuples/`T \| None`/`enum`/`match` zero-overhead lowering, exhaustiveness diagnostics, adaptive typing, SoA, and SSO. |
| `tests/cli.rs` | Fresh `archx` binary | Native stdout / exit codes | Cross-platform e2e integration tests (including 5-way `full_tour` byte-identity & output parity) across Linux, macOS, and Windows. |
