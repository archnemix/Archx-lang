<!-- Technical reference of the Archx stack, module inputs/outputs, and internal invariants. -->

# Technical Reference (`v0.6.0`)

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
| `src/token.rs` | `Span`, token discriminant | `Token`, `TokenKind`, `FStrPart` | Lexical token vocabulary (`Float`, `FStr`, `SlashSlash`, `StarStar`, `Assert`, `Pass`, `With`, `NoneLit`, etc.). |
| `src/lexer.rs` | `&str` UTF-8 source | `Result<Vec<Token>>` | 4-space `Indent`/`Dedent`, `f"..."` interpolation lexer, float/exponent/`_` numbers, Python keywords. |
| `src/ast.rs` | `Span`, parsed nodes | `Program`, `StructDef`, `Func`, `Stmt`, `Expr`, `Type` | Typed AST definitions shared between parser and codegen (`CallArg`, `MethodCall`, `Ternary`, `ForEnumerate`, etc.). |
| `src/parser.rs` | `Vec<Token>` | `Result<Program>` | Bounded-depth (`MAX_NESTING = 128`) parser for 1:1 Python (`def`, `class`, `range`, `enumerate`, script `main`) & classic syntax. |
| `src/codegen/mod.rs` | `&Program` | `Result<String>` (LLVM IR) | Struct/method signature & receiver layout, `Codegen` state, function frames, and runtime flag finalization. |
| `src/codegen/analysis.rs` | `&[Stmt]`, `&Expr` | Escape/mutation sets, `Option<i64>` | Pure AST analyses: SoA escape checking, monotonic `while` stride checking, Pythonic first-binding vs mutation sets, const folding. |
| `src/codegen/stmt.rs` | `&Stmt`, `&[Stmt]` | Appended LLVM IR | Pythonic implicit variable intro, `let`, `with region:`, `int`/`bool`/`float` SoA setup, `assert`, `pass`, and assignments. |
| `src/codegen/loops.rs` | Loop AST nodes | Versioned/elided LLVM IR | `while`, `range`/`a..b` (pos/neg/dynamic steps), `for x in arr`, `for ch in s`, and `for i, x in enumerate(xs, start)`. |
| `src/codegen/expr.rs` | `&Expr`, `Option<&Type>` | `Result<(Type, String)>` | Literals, indexing (`arr[i]`, `s[i]`), fields, `int` & `float` math (`//`, `**`), ternary, `in`/`not in`, `[v]*n`, `s*n`, SSO strings. |
| `src/codegen/calls.rs` | Call name & `&[CallArg]` | `Result<(Type, String)>` | User `fastcc` calls, positional/keyword constructors, `int`/`float`/`str`/`bool` casts, and LEGB soft built-ins. |
| `src/codegen/io.rs` | I/O & `f"..."` nodes | `Result<(Type, String)>` | `print(*args, sep=..., end=...)`, `input([prompt])`, `str(x)`, and `f"..."` lowering. |
| `src/codegen/methods.rs` | `Func` / receiver + method | `Result<(Type, String)>` | `class` `self` methods (by-ptr mutating / by-val read-only), list `.append`/`.pop`/`.clear`, and SSO string methods. |
| `src/codegen/ownership.rs` | `Type`, SSA value / `Scope` | RAII drop/clone/promote IR | `stmt_temps` tracking, recursive drops, deep clones, and `region:` return heap promotion. |
| `src/codegen/memory.rs` | Element `Type`, count/index | Checked `ptr` / bounds IR | `2^47` size checks, `align 16` `malloc`/`calloc`/`realloc`, `double` zero-page `calloc`, and bounds-check elision proofs. |
| `src/codegen/runtime.rs` | `used_*` flags | Private LLVM IR helpers | Core `@archx_region_*`, `@archx_str_*`, panic handlers, and core `libc`/intrinsic declarations. |
| `src/codegen/runtime_py.rs` | `used_*` Pythonic flags | Private LLVM IR helpers | `@archx_input`, `@archx_fmt_float_buf`, `@archx_str_from_slice`, `int`/`float` parsers, string methods, and panic helpers. |
| `src/codegen/tests.rs` | Inline Archx snippets | Unit test assertions | Verifies IR generation, Pythonic SoA + `range` bounds elision, SSO strings, and region escape errors. |
| `tests/cli.rs` | Fresh `archx` binary | Native stdout / exit codes | Cross-platform end-to-end integration tests (including piped `stdin` `input()`) across Linux, macOS, and Windows. |
