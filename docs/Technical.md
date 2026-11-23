<!-- Technical reference of the Archx stack, module inputs/outputs, and internal invariants. -->

# Technical Reference

## 1. Technology Stack
- **Implementation language**: Rust (`edition = "2021"`, `0` external crates in `Cargo.toml`).
- **Backend / Optimizer**: Textual LLVM IR lowered via `clang -O2` (`clang 15+`; tested on `clang 21` in CI).
- **Target OSes**: Linux (`ELF` + `glibc`), macOS (`Mach-O` + `libSystem`), Windows (`PE .exe` + `UCRT` / `legacy_stdio_definitions`).

---

## 2. File-by-File Inputs, Outputs & Responsibilities

| File | Input | Output | Responsibility |
|---|---|---|---|
| `src/main.rs` | CLI `args: &[String]`, `.archx.lang` file | Native executable, `--emit-ir` stdout, or process exit code | CLI flag parsing, extension/clobber validation, temp `.ll` file management, `clang` invocation, `--run` execution. |
| `src/diag.rs` | `line`, `col`, error message | `Span`, `Diagnostic`, `Result<T>` | Source location tracking and structured error reporting. |
| `src/token.rs` | `Span`, token discriminant | `Token`, `TokenKind`, `describe()` | Lexical token vocabulary and diagnostic formatting. |
| `src/lexer.rs` | `&str` UTF-8 source | `Result<Vec<Token>>` | 4-space `Indent`/`Dedent` tracking, `#` comment skipping, string escape decoding, number/identifier scanning. |
| `src/ast.rs` | `Span`, parsed nodes | `Program`, `StructDef`, `Func`, `Stmt`, `Expr`, `Type` | Typed syntax tree definitions shared between parser and codegen. |
| `src/parser.rs` | `Vec<Token>` | `Result<Program>` | Bounded-depth (`MAX_NESTING = 128`) recursive-descent + iterative-unary parsing, contextual `step`, `string`/`str` types. |
| `src/codegen/mod.rs` | `&Program` | `Result<String>` (LLVM IR module) | Struct cycle detection & topological sort, `Codegen` state, function frames, SSA/label counters, IR formatting helpers. |
| `src/codegen/analysis.rs` | `&[Stmt]`, `&Expr` | Escape booleans, `HashSet<String>`, `Option<i64>` | Pure AST analyses: SoA escape detection, monotonic `while` stride checking, mutation/return sets, constant folding. |
| `src/codegen/stmt.rs` | `&Stmt`, `&[Stmt]` | Appended LLVM IR instructions | `let`, `if`/`elif`/`else`, `return`, `break`/`continue`, `region:` watermarks, transparent SoA setup, assignments. |
| `src/codegen/loops.rs` | Loop AST nodes | Versioned/elided LLVM IR loop blocks | `while`, `for i in a..b`, `for i in a..b step k`, and `for x in arr` lowering. |
| `src/codegen/expr.rs` | `&Expr`, expected `Option<&Type>` | `Result<(Type, String)>` SSA value | Literals, variables, indexing, struct fields, checked `i64` ops, short-circuit `and`/`or`, 16B prefix-SSO strings. |
| `src/codegen/calls.rs` | Call name & `&[Expr]` | `Result<(Type, String)>` | User `fastcc` calls, positional struct construction, and `print` / `len` / `push` / `pop` builtins. |
| `src/codegen/ownership.rs` | `Type`, SSA value / `Scope` | RAII drop/clone/promote IR | `stmt_temps` tracking, recursive `@archx_vec_drop_*` / `@archx_str_drop`, deep clones, `region:` return promotion. |
| `src/codegen/memory.rs` | Element `Type`, count/index SSA | Checked `ptr` / elided bounds IR | `2^47` size checks, `align 16` `malloc`/`calloc`/`realloc`, fill loops, induction & array bounds-check elision. |
| `src/codegen/runtime.rs` | `used_*` feature flags on `Codegen` | Private LLVM IR helper definitions & `declare`s | Emits only referenced runtime helpers (`@archx_region_*`, `@archx_str_*`, panic handlers, `libc` declarations). |
| `src/codegen/tests.rs` | Inline Archx snippets | Unit test assertions | Verifies IR generation, bounds elision, SoA lowering, SSO strings, and region escape errors. |
| `tests/cli.rs` | Fresh `archx` binary + Archx programs | Native process stdout / exit codes | Cross-platform end-to-end integration tests across Milestones 1–5 and runtime safety panics. |
