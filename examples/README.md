<!-- Directory overview for `examples/`: runnable Archx showcase programs verified on every CI push. -->

# `examples/` — Runnable Archx Examples

Small, focused programs demonstrating each milestone's language features (all compiled, executed, and dumped as `.ll` / `-O2` `.opt.ll` in CI):

- `hello.archx.lang` — Minimal `main`, strings, and arithmetic.
- `functions.archx.lang` — Typed functions and recursion (`fib`).
- `if.archx.lang` — `if`/`else`, booleans, and short-circuit `and`/`or`/`not`.
- `loops.archx.lang` — `for i in a..b`, `while`, `break`, `continue`, and nested loops.
- `arrays.archx.lang` — `[T]` literals, `[val; n]`, `len`/`push`/`pop`, `elif`, compound assignments, and 2D arrays.
- `structs_regions.archx.lang` — Value `struct`s, transparent AoS-to-SoA `[Body]` simulation, `step` & `foreach` loops, 16B prefix-SSO strings, and `region:` arenas with return promotion.
