<!-- Directory overview for `examples/`: runnable Archx showcase programs verified on every CI push. -->

# `examples/` — Runnable Archx Examples

Small, focused programs demonstrating each milestone's language features (all compiled, executed, leak-checked under ASan + LSan, and dumped as `.ll` / `-O2` `.opt.ll` in CI):

- `hello.archx.lang` — Minimal `main`, strings, and arithmetic.
- `functions.archx.lang` — Typed functions and recursion (`fib`).
- `if.archx.lang` — `if`/`else`, booleans, and short-circuit `and`/`or`/`not`.
- `loops.archx.lang` — `for i in a..b`, `while`, `break`, `continue`, and nested loops.
- `arrays.archx.lang` — `[T]` literals, `[val; n]`, `len`/`push`/`pop`, `elif`, compound assignments, and 2D arrays.
- `structs_regions.archx.lang` — Value `struct`s, transparent AoS-to-SoA `[Body]` simulation, `step` & `foreach` loops, 16B prefix-SSO strings, and `region:` arenas with return promotion.
- `pythonic.archx.lang` — 1:1 Pythonic syntax (`class`, `def`, `self` methods, top-level script mode, `float`, `list[float]`, `range` with negative step, `enumerate`, `f"..."`, `print(..., sep=...)`, `.strip().split()`, and `with region:`).
- `collections_dynamic.archx.lang` — Planar `<16 x i8>` SIMD `dict` & `set`, Pythonic list/string slicing & negative indexing, and Smart Two-Tier `%ArchxAny` dynamic typing (`v0.7.0`).
- `enums_matching.archx.lang` — Zero-heap tuples & unpacking, `T | None` optionals & flow-sensitive narrowing, algebraic `enum` sum types with heap/region payloads, and compiler-verified exhaustive `match`/`case` (`v0.8.0`).
- [`comparison/`](comparison/README.md) — **5-Way Full-Feature Comparison Showcase** (`full_tour.py`, byte-identical `full_tour_pythonic.archx.lang`, `full_tour_speed.archx.lang`, `full_tour.c`, and `full_tour.rs`).
