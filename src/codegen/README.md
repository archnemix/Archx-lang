<!-- Directory overview for `src/codegen/`: modular LLVM IR lowering, Adaptive 2-Tier Engine, Planar SIMD dict/set, Pythonic I/O & methods, SoA/Region/SSO lowering, and RAII ownership. -->

# `src/codegen/` — LLVM IR Code Generator

Lowers `ast::Program` into textual LLVM IR tailored for `clang -O2`, split into 16 single-responsibility submodules:

- `mod.rs` — `lower(&Program)` entry point, struct/method layout & receiver resolution, untyped parameter/return defaulting (`Type::Any`), `Codegen` state, function frames, and IR formatting helpers.
- `analysis.rs` — Pure AST static analyses: **Smart Two-Tier Adaptive Type Engine** (`analyze_adaptive_types` specializing `{}`/`[]`/typed variables to zero-tag static types and promoting heterogeneous containers & rebound variables to `%ArchxAny`), SoA escape checking, monotonic `while` stride verification, and constant folding.
- `any.rs` — Unboxed 24-byte `%ArchxAny` (`{ i64 tag, i64 w1, i64 w2 }`) boxing/unboxing, runtime type guards, dynamic unary/binary/comparison/`is`/`in` dispatch, dynamic indexing, and dynamic calls.
- `collections.rs` — Planar `<16 x i8>` SIMD SwissTable `dict[K, V]` & `set[T]` lowering (literals, indexing, compound `d[k] += v`, `.get`, `.pop` backward-shift compaction, `.keys`/`.values`/`.items`, `.add`/`.remove`/`.discard`/`.clear`, per-type clone/drop helpers) plus Pythonic list/string slicing (`xs[a:b:step]`) and negative indexing (`xs[-1]`).
- `stmt.rs` — Statement dispatch, Pythonic implicit first-assignment binding & adaptive rebinding, `let`, `with region:` / `region:`, transparent AoS-to-SoA (`int`/`bool`/`float`) setup, `assert`, `pass`, and assignments (including nested dynamic container assignments).
- `loops.rs` — `while`, `for i in range(...)` / `a..b` (positive, negative, and dynamic steps), `for x in arr`, `for ch in s`, `for k in d`, `for k, v in d.items()` (dense `0..len` plane scan), `for x in set`, `for x in any_val`, and zero-allocation `for idx, x in enumerate(xs, start)`.
- `expr.rs` — Literals (`int`, `float`, `bool`, `None`, `str`, `[...]`, `{k: v}`, `{a, b}`), indexing & slicing, fields, checked `i64` & IEEE-754 `f64` math (`//`, `**`), `is` / `is not`, inline `a if c else b`, `in` / `not in`, `[v] * n`, `s * n`, `list + list`, and 16B SSO strings.
- `calls.rs` — User `fastcc` calls (with automatic `%ArchxAny` boundary boxing/unboxing), positional & keyword constructors (`Point(x=1, y=2)`), `dict()`/`set()`/`list()`/`type()`, conversions (`int`, `float`, `str`, `bool`), and LEGB soft built-ins (`abs`, `min`, `max`, `sum`, `sqrt`, `ord`, `chr`, `len`, `push`, `pop`).
- `io.rs` — Pythonic `print(*args, sep=..., end=...)` (supporting `dict`, `set`, `list`, `any`, `class`, `None`), `input([prompt])`, `str(x)` formatting, and `f"..."` string interpolation.
- `methods.rs` — `class`/`struct` method lowering, in-place borrowed mutation on nested `dict[K, any]` elements (`d[k].append(...)`), `dict`/`set`/`list`/`any` methods, and SSO-aware string methods.
- `ownership.rs` — Statement-temporary claiming/flushing, recursive RAII drops, deep value cloning (`str`, `list`, `dict`, `set`, `any`, `struct` — promoting region strings to heap on clone), and `region:` return heap promotion.
- `memory.rs` — Checked `align 16` heap helpers (`2^47` size cap), element fill/load/store helpers (`double` zero-page `calloc`), and bounds-check elision analyses.
- `runtime.rs` — Core on-demand LLVM IR runtime helpers (`@archx_region_*`, `@archx_str_*`, panic handlers) and `libc`/intrinsic declarations.
- `runtime_py.rs` — On-demand Pythonic LLVM IR runtime helpers (`@archx_input`, `@archx_fmt_float_buf`, `@archx_int_from_str`, `@archx_float_from_str`, `@archx_str_from_slice`, string methods, and assertion/step/exponent panics).
- `runtime_hash_any.rs` — On-demand Planar `<16 x i8>` SIMD SwissTable runtime (`@archx_dict_new`, `@archx_dict_grow`, single-probe `@archx_dict_find_h_*` / `@archx_dict_upsert_*`, inline Prefix-SSO `@archx_hash_str`), `@archx_slice_bounds`, `@archx_str_slice`, and `%ArchxAny` dynamic runtime helpers.
- `tests.rs` — Codegen unit tests (including Tier-1 static `dict` specialization and Tier-2 `%ArchxAny` promotion).
