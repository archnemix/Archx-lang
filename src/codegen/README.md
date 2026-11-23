<!-- Directory overview for `src/codegen/`: modular LLVM IR lowering, static analyses, SoA/Region/SSO lowering, and RAII ownership. -->

# `src/codegen/` — LLVM IR Code Generator

Lowers `ast::Program` into textual LLVM IR tailored for `clang -O2`, split into single-responsibility submodules:

- `mod.rs` — `lower(&Program)` entry point, struct cycle/layout resolution, `Codegen` state, function frames, and IR formatting helpers.
- `analysis.rs` — Pure AST static analyses (SoA escape checking, monotonic `while` stride verification, mutation/return sets, constant folding).
- `stmt.rs` — Statement dispatch, `let`, `region:` watermarks, transparent AoS-to-SoA allocation, and variable/index/field assignments.
- `loops.rs` — `while`, `for i in a..b`, `for i in a..b step k`, and `for x in arr` lowering with range-guarded loop versioning.
- `expr.rs` — Literals, indexing, struct fields, checked `i64` arithmetic, short-circuit booleans, and 16-byte prefix-SSO strings.
- `calls.rs` — User `fastcc` calls, positional struct constructors, and builtins (`print`, `len`, `push`, `pop`).
- `ownership.rs` — Statement-temporary claiming/flushing, recursive RAII drops, deep value cloning, and `region:` return promotion.
- `memory.rs` — Checked `align 16` heap helpers (`2^47` size cap), element fill/load/store helpers, and bounds-check elision analyses.
- `runtime.rs` — On-demand LLVM IR runtime helpers (`@archx_region_*`, `@archx_str_*`, cold panic handlers) and `libc`/intrinsic declarations.
- `tests.rs` — Codegen unit tests.
