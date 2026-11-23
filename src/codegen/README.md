<!-- Directory overview for `src/codegen/`: modular LLVM IR lowering, static analyses, Pythonic I/O & methods, SoA/Region/SSO lowering, and RAII ownership. -->

# `src/codegen/` — LLVM IR Code Generator

Lowers `ast::Program` into textual LLVM IR tailored for `clang -O2`, split into 13 single-responsibility submodules:

- `mod.rs` — `lower(&Program)` entry point, struct/method layout & receiver resolution, `Codegen` state, function frames, and IR formatting helpers.
- `analysis.rs` — Pure AST static analyses (SoA escape checking, monotonic `while` stride verification, Pythonic first-binding vs mutation/return sets, constant folding).
- `stmt.rs` — Statement dispatch, Pythonic implicit first-assignment binding, `let`, `with region:` / `region:`, transparent AoS-to-SoA (`int`/`bool`/`float`) setup, `assert`, `pass`, and assignments.
- `loops.rs` — `while`, `for i in range(...)` / `a..b` (positive, negative, and dynamic steps), `for x in arr`, `for ch in s`, and zero-allocation `for idx, x in enumerate(xs, start)` lowering.
- `expr.rs` — Literals (`int`, `float`, `bool`, `None`, `str`), indexing (`list[i]`, `s[i]`), fields, checked `i64` & IEEE-754 `f64` math (`//`, `**`), inline `a if c else b`, `in` / `not in`, `[v] * n`, `s * n`, `list + list`, and 16B SSO strings.
- `calls.rs` — User `fastcc` calls, positional & keyword constructors (`Point(x=1, y=2)`), type conversions (`int`, `float`, `str`, `bool`), and LEGB soft built-ins (`abs`, `min`, `max`, `sum`, `sqrt`, `ord`, `chr`, `len`, `push`, `pop`).
- `io.rs` — Pythonic `print(*args, sep=..., end=...)`, `input([prompt])`, `str(x)` formatting, and `f"..."` string interpolation.
- `methods.rs` — `class`/`struct` method lowering (`self` by pointer when mutating, by value when read-only), list methods (`.append`, `.pop`, `.clear`), and SSO-aware string methods (`.strip`, `.upper`, `.lower`, `.startswith`, `.endswith`, `.find`, `.replace`, `.split`).
- `ownership.rs` — Statement-temporary claiming/flushing, recursive RAII drops, deep value cloning, and `region:` return heap promotion.
- `memory.rs` — Checked `align 16` heap helpers (`2^47` size cap), element fill/load/store helpers (`double` zero-page `calloc`), and bounds-check elision analyses.
- `runtime.rs` — Core on-demand LLVM IR runtime helpers (`@archx_region_*`, `@archx_str_*`, panic handlers) and `libc`/intrinsic declarations.
- `runtime_py.rs` — On-demand Pythonic LLVM IR runtime helpers (`@archx_input`, `@archx_fmt_float_buf`, `@archx_int_from_str`, `@archx_float_from_str`, `@archx_str_from_slice`, string methods, and assertion/step/exponent panics).
- `tests.rs` — Codegen unit tests.
