<!-- Concise version-by-version changelog tracking features added, changed, and hardened across Archx releases. -->

# Changelog

## `v0.9.1` — Pythonic Call & Loop Semantics
- **Added**:
  - **Default parameters**: `def greet(name: str, punct: str = "!")` — omitted trailing arguments are filled from their declared defaults at the call site, for positional, keyword, and (monomorphized) generic calls alike.
  - **Keyword arguments for user functions**: `rect(h=3, w=4)` matches keywords against declared parameter names, diagnoses unknown/duplicate keywords, and combines with defaults (`greet(loud=true, name="hey")`).
  - **`for ... else`**: the `else` body runs only when the loop finished without `break` (`for i in 0..n:` and `for x in xs:`), so `for i in range(n): if hit: break` … `else: return None` works as in Python. The completion flag is only materialized when the body can actually break.
  - **Function-scoped loop variables**: `range`, list, `str`, `enumerate`, `dict.items` and `zip` loop variables live at function scope and keep the last value the body saw — `for j in range(2): pass` then `print(j)` prints `1`, and nested loops no longer hide the inner variable.
  - **`map` / `filter`**: `map(f, xs)`, `filter(p, xs)`, inline `lambda`s and soft builtins (`map(str, xs)`) lower to pre-sized comprehension loops; named functions become direct `fastcc` calls and lambdas are inlined, so no function values, boxes, or per-element indirect calls remain.
  - **Keyless tuple sorting**: `sorted(pairs)` / `sorted(tuples, reverse=True)` compare tuples lexicographically component-by-component with LLVM-padding-correct offsets.
- **Fixed**: the `archx_any_binop` runtime helper dispatched bitwise/shift opcodes behind an unreachable guard and gave `%` a `phi` predecessor it did not have, so clang rejected whole programs using `%ArchxAny` arithmetic (`pipelines`, `full_tour`). Also corrected two stale CLI expectations (list `reverse`/`insert`/`remove` order and triple-quoted `len`) that had never run because `clang` was missing from the test PATH.

## `v0.8.0` — Milestone 8: Zero-Heap Tuples, `T | None` Optionals, Algebraic `enum`s, Exhaustive `match`/`case`, `python3` Benchmarks & 5-Way Comparison Showcase (Current)
- **Added**:
  - **Zero-Heap Value Tuples & Unpacking**: `(T1, T2, ...)` and `tuple[T1, T2, ...]` compiled directly to unboxed LLVM register/stack aggregates (`{ T1, T2, ... }`), bare tuple returns (`return lo, hi, total`), Python & systems tuple unpacking (`a, b = expr`, `let a, b = expr`, `(a, b) = expr`, `a, b = b, a` swap, `for k, v in pairs:`), constant positive/negative indexing (`t[0]`, `t[-1]`), `==`/`!=`/`<`/`<=`/`>`/`>=`, `len(t)`, `bool(t)`, and `print`/`str`/`f"{t}"`.
  - **Unboxed `T | None` Optionals & Flow-Sensitive Narrowing**: Stack/register `{ i1, T }` optionals with zero heap boxing, implicit `T` and `None` coercions on assignment/call/return (including implicit `None` fallthrough in `-> T | None` functions), and flow-sensitive type narrowing in `if x is not None:`, early-exit `if x is None: return/break/continue`, and conditional expressions (`x + 1 if x is not None else -1`).
  - **Algebraic `enum` Sum Types & Pythonic `match` / `case`**: Unit and payload-carrying `enum`s (`%ArchxEnum_Name = type { i64, [W x i64] }`) with recursive RAII drop/clone and `with region:` return heap promotion; `match subject:` / `case ...:` supporting literals, bindings, `_`, nested tuple & `Enum.Variant(...)` destructuring, transparent `T | None` unwrapping, `|` OR-patterns, `if` guards, and compile-time `enum` exhaustiveness checking.
  - **Python `def __init__(self, ...):` Constructors & Empty Factory Specialization**: Automatic class field inference and constructor lowering for `def __init__(self, ...):`, plus expected-type specialization for zero-arg `set()` / `dict()` / `list()` / `tuple()` calls.
  - **6-Suite `Python 3` / `C` / `Rust` / `Archx` Benchmarks & 5-Way Comparison (`examples/comparison/`)**: Added `.py` reference benchmarks across all suites (`14.6×`–`70.5×` faster than `Python 3.14.4`!) and `examples/comparison/full_tour.{py,c,rs}` + byte-identical `full_tour_pythonic.archx.lang` (`13 ms` vs `298 ms` Python 3 = **22.9× faster**, tying `rustc -O` `13 ms`) + `full_tour_speed.archx.lang` (`12 ms` = **24.8× faster**), verified with `0` leaks across 11 ASan+LSan targets and 37 unit + 23 CLI tests green on Linux, macOS, and Windows (`ci/test-history/v0.8.0/`).

## `v0.7.0` — Milestone 7: Planar SIMD `dict` / `set`, Slicing, Negative Indexing & Smart Adaptive Typing (`any`)
- **Added**:
  - **Planar `<16 x i8>` SIMD SwissTable `dict[K, V]` & `set[T]`**: 16-wide SIMD control-byte probing paired with dense insertion-ordered planar `keys[]` and `vals[]` arrays, single-probe `@archx_dict_find_h_*` / `@archx_dict_upsert_*`, inline register Prefix-SSO `@archx_hash_str` & `@archx_str_eq`, backward-shift `.pop()` compaction, and `with region:` arena allocation + `return` heap promotion.
  - **Pythonic Slicing & Negative Indexing**: `xs[-1]`, `xs[-1] = v`, `s[-1]`, `xs[start:stop:step]`, and `s[start:stop:step]` (`s[::-1]`).
  - **Smart Two-Tier Adaptive Type Engine & 24-Byte `%ArchxAny`**: Whole-function `analyze_adaptive_types` pass + unboxed 24-byte `%ArchxAny` (`{ i64 tag, i64 w1, i64 w2 }`), `is` / `is not`, `type(x)`, and Suite 5 (`dict_bench.*` & `dict_dynamic.archx.lang`).

## `v0.6.0` — Milestone 6: 1:1 Pythonic Syntax, Console I/O, `float`, `class` Methods & Suite 4 Benchmark
- **Added**: 1:1 Pythonic syntax (`def`, `class`, `self` methods, script mode, `float`, `range`, `enumerate`, `f"..."`, `print(sep, end)`, `input()`, `//`, `**`, `a if c else b`, `in`/`not in`, list & string methods, LEGB soft built-ins) and Suite 4 (`nbody_float.*`).

## `v0.5.0` — Milestone 5 + Safety Hardening & Multi-OS Modularization
- **Added**: Value `struct`s + transparent AoS-to-SoA planarization, scoped `region:` 64 KB bump arenas + escape checker + `return` heap promotion, 16-byte German/Umbra prefix-SSO `str`, recursive RAII, ASan+LSan CI, Suite 3 (`composite`), modular `src/codegen/`, and 3-OS CI.

## `v0.4.0` — Milestone 4: Safe Arrays & Bounds-Check Elision
- **Added**: `[T]` arrays, `elif`, compound assignments, range-guarded `for` & strided `while` elision, and Suite 2 (`arrays`).

## `v0.3.0` — Milestone 3: Loops & Scalar Benchmarks
- **Added**: `while`, `for i in a..b:`, `break`, `continue`, SSA `VarStorage::Imm`, and Suite 1 (`primes`).

## `v0.2.0` — Milestone 2: Booleans & Conditionals
- **Added**: `bool`, `if` / `else`, comparisons, and short-circuit `and`, `or`, `not`.

## `v0.1.0` — Milestone 1: Core Compiler
- **Added**: Indentation-aware lexer, recursive-descent parser, `func`, `let`, `return`, `print`, textual LLVM IR backend, and `clang -O2` driver (`14 KB` stripped).
