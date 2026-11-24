<!-- Concise version-by-version changelog tracking features added, changed, and hardened across Archx releases. -->

# Changelog

## `v0.7.0` — Milestone 7: Planar SIMD `dict` / `set`, Slicing, Negative Indexing & Smart Adaptive Typing (`any`) (Current)
- **Added**:
  - **Planar `<16 x i8>` SIMD SwissTable `dict[K, V]` & `set[T]`**: 16-wide SIMD control-byte probing (`0x80` empty, `0xFE` deleted, `0..127` `h2` fingerprint) paired with dense insertion-ordered planar `keys[]` and `vals[]` arrays, single-probe `@archx_dict_find_h_*` / `@archx_dict_upsert_*`, inline register Prefix-SSO `@archx_hash_str` & `@archx_str_eq`, backward-shift `.pop()` compaction preserving insertion order, `{k: v}` / `{a, b}` literals, `dict()` / `set()` / `list()`, `d[k]`, `d[k] += v`, `k in d` / `k not in d`, `.get()`, `.pop()`, `.keys()`, `.values()`, `.items()`, `.add()`, `.remove()`, `.discard()`, `.clear()`, `for k in d:`, `for k, v in d.items():`, `for x in s:`, and full `with region:` arena allocation + `return` heap promotion.
  - **Pythonic Slicing & Negative Indexing**: `xs[-1]`, `xs[-1] = v`, `s[-1]`, `xs[start:stop:step]` (contiguous `memcpy` fast path for POD `step == 1`), and `s[start:stop:step]` (`s[::-1]`, `@archx_slice_bounds`).
  - **Smart Two-Tier Adaptive Type Engine & 24-Byte `%ArchxAny`**: Whole-function `analyze_adaptive_types` pass that keeps homogeneous Pythonic code in Tier-1 zero-tag static types (inferring unannotated `{}` and `[]` from usage!) and automatically promotes heterogeneous containers (`{"data": ["Archx", 18, "legal"], "age": 18}`), rebound variables (`name = "Abdullah"` → `name = 18` → `name = None`), and untyped parameters/returns (`def f(x):`) to unboxed 24-byte `%ArchxAny` (`{ i64 tag, i64 w1, i64 w2 }`), with borrowed in-place nested container mutation (`d[k].append(...)`), `is` / `is not`, and `type(x)`.
  - **Suite 5 (`benchmarks/dict_bench.*` & `dict_dynamic.archx.lang`) & `examples/collections_dynamic.archx.lang`**: Archx Static (`48 ms`, `22 KB` stripped) beats both `-O2` C (`61 ms`) and Rust `std::collections::HashMap` (`52 ms`, `354 KB` stripped), while Archx Dynamic (`%ArchxAny`) runs in `87 ms`; `0` leaks verified across 8 targets under ASan + LSan and 34 unit + 21 CLI tests green on Linux, macOS, and Windows (`ci/test-history/v0.7.0/`).

## `v0.6.0` — Milestone 6: 1:1 Pythonic Syntax, Console I/O, `float`, `class` Methods & Suite 4 Benchmark
- **Added**:
  - **1:1 Pythonic syntax**: `def`, `class`, `self` methods (`def method(self, ...):` with automatic pointer receiver for mutating methods and unboxed value receiver for read-only methods), keyword constructor calls (`Body(x=1.0, y=2.0)`), top-level script execution without `def main():`, `if __name__ == "__main__":`, Pythonic implicit variable declaration without `let` (`x = 1`, `xs: list[int] = []`), `True`/`False`/`None`, `list[T]`, `with region:`, `pass`, and `assert cond[, msg]`.
  - **64-bit IEEE-754 `float` (`double`)**: literals (`3.14`, `1e-5`, `_` numeric separators), `+ - * / // **`, comparisons, `[0.0] * n` zero-page `calloc`, saturating `int(x)` (`@llvm.fptosi.sat.i64.f64`), and transparent `double*` SoA SIMD planarization.
  - **Pythonic console I/O & `f"..."`**: `print(*args, sep=" ", end="\n")` (`2.0` Python float formatting, `None`, multi-arg), cross-platform `input([prompt])` (`stdin` line reader handling `\n`, `\r\n`, and `EOF`), and `f"..."` string interpolation (`{{`/`}}` escapes + arbitrary expressions).
  - **Pythonic loops, operators & built-ins**: `range(stop)`, `range(start, stop)`, `range(start, stop, step)` (positive, negative, and dynamic steps), zero-allocation `for i, v in enumerate(xs[, start]):`, `for ch in s:`, Python floor division `//` & `//=`, power `**`, inline `a if c else b`, `in` / `not in`, `[v] * n`, `s * n`, `xs + ys`, `int()`/`float()`/`str()`/`bool()`, and LEGB soft built-ins (`abs`, `min`, `max`, `sum`, `sqrt`, `ord`, `chr`).
  - **List & string methods**: `.append()`, `.pop()`, `.clear()`, `s[idx]`, `.strip()`, `.upper()`, `.lower()`, `.startswith()`, `.endswith()`, `.find()`, `.replace()`, and `.split([sep])`.
  - **Suite 4 (`benchmarks/nbody_float.*`) & `examples/pythonic.archx.lang`**: Pythonic Archx (`52 ms`) beats both `-O2` C (`56 ms`) and `-O` Rust (`56 ms`), verified `0` leaks under ASan + LSan and green across Linux, macOS, and Windows (`ci/test-history/v0.6.0/`).

## `v0.5.0` — Milestone 5 + Safety Hardening & Multi-OS Modularization
- **Added**: Value `struct`s + transparent AoS-to-SoA planarization, scoped `region:` 64 KB bump arenas + escape checker + `return` heap promotion, 16-byte German/Umbra prefix-SSO `str`, `for x in arr:`, `step`, recursive RAII, ASan+LSan CI, Suite 3 (`composite`), modular `src/codegen/`, and 3-OS CI (`ci/test-history/v0.5.0/`).

## `v0.4.0` — Milestone 4: Safe Arrays & Bounds-Check Elision
- **Added**: `[T]` arrays, `elif`, compound assignments, range-guarded `for` & strided `while` elision, and Suite 2 (`arrays`).

## `v0.3.0` — Milestone 3: Loops & Scalar Benchmarks
- **Added**: `while`, `for i in a..b:`, `break`, `continue`, SSA `VarStorage::Imm`, and Suite 1 (`primes`).

## `v0.2.0` — Milestone 2: Booleans & Conditionals
- **Added**: `bool`, `if` / `else`, comparisons, and short-circuit `and`, `or`, `not`.

## `v0.1.0` — Milestone 1: Core Compiler
- **Added**: Indentation-aware lexer, recursive-descent parser, `func`, `let`, `return`, `print`, textual LLVM IR backend, and `clang -O2` driver (`14 KB` stripped).
