<!-- Directory overview for `src/`: the Archx compiler frontend, CLI driver, and LLVM IR codegen modules. -->

# `src/` — Compiler Source

Contains the Rust implementation of the `archx` compiler (`0` external crate dependencies):

- `main.rs` — CLI argument parser, extension/clobber validation, temp `.ll` management, `clang` invocation, and `--run` execution.
- `diag.rs` — 1-based `Span` and `Diagnostic` error types.
- `token.rs` — `Token` and `TokenKind` definitions (including `Pipe` `|`, `FStrPart`, `Float`, `SlashSlash`, `StarStar`, `Is`, `With`, `Assert`, `Pass`, `NoneLit`).
- `lexer.rs` — 4-space indentation-aware lexical scanner and lexer unit tests.
- `ast.rs` — AST data structures (`Program`, `StructDef`, `EnumDef`, `Func`, `Stmt`, `Pattern`, `Expr`, `Type`).
- `parser.rs` — Bounded-depth recursive-descent + iterative-unary parser (`def`, `class` + `__init__`, `enum`, `match`/`case`, tuples, `T | None`, and classic Archx syntax) + parser unit tests.
- `codegen/` — 18-module LLVM IR code generator (see [`codegen/README.md`](codegen/README.md)).
