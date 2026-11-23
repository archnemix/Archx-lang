<!-- Concise version-by-version changelog tracking features added, changed, and hardened across Archx releases. -->

# Changelog

## `v0.6.0` — Milestone 6: 1:1 Pythonic Syntax, Console I/O, `float`, `class` Methods & Suite 4 Benchmark (Current)
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
