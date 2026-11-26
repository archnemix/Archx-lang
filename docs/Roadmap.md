<!-- Ordered milestone roadmap for Archx: completed Milestones 1–8 and detailed next logical steps (Milestones 9–10). -->

# Archx Roadmap

Each milestone must be **100% implemented, leak-checked, and tested across Linux, macOS, and Windows** before advancing to the next milestone.

---

## Completed Milestones

### Milestone 1 (`v0.1.0`) — Core Frontend & Native LLVM Backend [DONE]
- [x] Indentation-aware lexer (`4` spaces, `#` comments, single/double-quoted strings, spans)
- [x] Recursive-descent parser (`func`, `let`, `return`, `+ - * / %`, calls, `print`)
- [x] Textual LLVM IR backend + `clang -O2` driver (`14 KB` stripped binaries)

### Milestone 2 (`v0.2.0`) — Booleans & Control Flow [DONE]
- [x] `bool` (`true`, `false`), `if` / `else`, `== != < > <= >=`, short-circuit `and` / `or` / `not`

### Milestone 3 (`v0.3.0`) — Loops & Scalar Benchmarks [DONE]
- [x] `while cond:`, `for i in a..b:`, `break`, `continue`, SSA `VarStorage::Imm`, Suite 1 (`primes`)

### Milestone 4 (`v0.4.0`) — Safe Arrays & Bounds-Check Elision [DONE]
- [x] `[T]` arrays, `elif`, compound assignments, range-guarded `for` & strided `while` elision, Suite 2 (`arrays`)

### Milestone 5 (`v0.5.0`) — Structs (SoA), Regions, Prefix-SSO Strings & Modular Hardening [DONE]
- [x] Checked `i64` overflow & division, value `struct`s + transparent AoS-to-SoA planarization
- [x] Scoped `region:` 64 KB bump arenas + escape checker + `return` heap promotion
- [x] 16-byte German/Umbra prefix-SSO `str`, `for x in arr:`, `step`, recursive RAII, ASan+LSan, Suite 3 (`composite`), 3-OS CI

### Milestone 6 (`v0.6.0`) — 1:1 Pythonic Syntax, Console I/O (`print` / `input` / `f"..."`), `float`, and `class` Methods [DONE]
- [x] **1:1 Pythonic syntax**: `def`, `class`, `self` methods (mutating pointer receiver & read-only value receiver), top-level scripts + `if __name__ == "__main__":`, implicit first-assignment variable binding without `let`, `True`/`False`/`None`, `list[T]`, `with region:`, `pass`, `assert`
- [x] **`float` (`f64` / LLVM `double`)**: literals (`3.14`, `1e-5`, `_` separators), `+ - * / // **`, comparisons, `[0.0] * n` zero-page `calloc`, saturating `int(x)` (`@llvm.fptosi.sat.i64.f64`), and transparent `double*` SoA SIMD planes
- [x] **Pythonic loops & expressions**: `range(...)`, `for i, x in enumerate(xs, start):`, `for ch in s:`, `a if cond else b`, `in` / `not in`, `[v] * n`, `s * n`, `xs + ys`
- [x] **Pythonic console I/O, `f"..."` & methods**: `print(*args, sep=..., end=...)`, `input([prompt])`, `f"..."`, `int()`/`float()`/`str()`/`bool()`, LEGB soft built-ins, list/string methods, and Suite 4 (`nbody_float`)

### Milestone 7 (`v0.7.0`) — Planar SIMD `dict` / `set`, Slicing, Negative Indexing & Smart Adaptive Typing (`any`) [DONE]
- [x] **Planar `<16 x i8>` SIMD SwissTable `dict[K, V]` & `set[T]`**: 16-wide SIMD control-byte probing + single-probe `upsert` + dense insertion-ordered planar `keys[]`/`vals[]` + inline Prefix-SSO string hashing/equality + backward-shift `.pop()` compaction + `with region:` arena allocation & `return` heap promotion
- [x] **Pythonic Slicing & Negative Indexing**: `xs[a:b:step]`, `xs[::-1]`, `xs[-1] = v`, `s[a:b:step]`, `s[::-1]`, `s[-1]`
- [x] **Smart Two-Tier Adaptive Type Engine (`%ArchxAny`)**: Tier-1 zero-tag static specialization + Tier-2 24-byte stack-register `%ArchxAny` promotion, and Suite 5 (`dict_bench` & `dict_dynamic`)

### Milestone 8 (`v0.8.0`) — Algebraic `enum`s, Zero-Heap Tuples, `T | None` Optionals, Exhaustive `match`/`case`, `python3` Benchmarks & 5-Way Comparison Showcase [DONE]
- [x] **Zero-heap value tuples & multiple returns**: `(T1, T2, ...)` / `tuple[T1, T2, ...]`, bare return packing (`return lo, hi, total`), unpacking (`a, b = pair()`, `let a, b = ...`, `a, b = b, a` swap, `for k, v in pairs:`), constant positive/negative indexing (`t[0]`, `t[-1]`), lexicographic comparisons, `len(t)`, and `print` / `f"{t}"`
- [x] **Unboxed `T | None` optionals & flow-sensitive narrowing**: `{ i1, T }` stack/register optionals, automatic `T` / `None` coercions, and flow-sensitive narrowing across `if x is not None:`, early-exit `if x is None: return`, and inline `x + 1 if x is not None else -1`
- [x] **Algebraic `enum` sum types & exhaustive Pythonic `match` / `case`**: unit & payload-carrying `enum`s (`%ArchxEnum_Name = type { i64, [W x i64] }`) with recursive RAII & `with region:` promotion, `match`/`case` with literals, bindings, `_`, tuple & `Enum.Variant(...)` destructuring, `|` OR-patterns, `if` guards, and compile-time `enum` exhaustiveness verification, plus Python `def __init__(self, ...):` field inference & constructor dispatch
- [x] **6-Suite `python3` / `C` / `Rust` / `Archx` Benchmarks & 5-Way Comparison Showcase (`examples/comparison/`)**: `full_tour.py` == `full_tour_pythonic.archx.lang` (`13 ms` vs `298 ms` Python 3.14 = **22.9× faster**, tying `rustc -O` `13 ms`!) + `full_tour_speed.archx.lang` (`12 ms` = **24.8× faster**), `0` ASan+LSan leaks across 11 targets, and 37 unit + 23 CLI e2e tests green across Linux, macOS, and Windows

### Milestone 9 (`v0.9.0`) — Comprehensions, Generator Reductions, PEP 695 Generics, Zero-Heap Lambdas, `zip` & Inline Sorting [DONE]
- [x] **Comprehensions (`src/codegen/comprehensions.rs`)**: list / set / dict comprehensions, tuple targets, multiple `for` clauses and multiple `if` filters (`[(x, y) for x in range(n) for y in range(n) if ...]`), nested comprehensions (`[[r * c for c in range(k)] for r in range(n)]`), and `range(...)` iterables — each lowered to a synthesized `Stmt` loop nest over a single **pre-sized** buffer, so an unfiltered map never reallocates (filters only shrink).
- [x] **Generator reductions with no container**: `sum`/`min`/`max`/`any`/`all`/`len` over `(... for ... if ...)` fold in one pass with the element expression evaluated exactly once (`min`/`max` are a branch-free `select` scan; `any`/`all` short-circuit out of the loop).
- [x] **PEP 695 monomorphized generics (`src/codegen/generics.rs`)**: `def f[T](...)`, `class Box[T]`, stack-allocated zero-heap `lambda` closures (captures become leading `fastcc` arguments), plus **implicit instantiation** — `add(3, 4)` resolves `T = int` from the argument types, while `add[int](7, 8)` stays available as the explicit form.
- [x] **`zip(...)` (`src/codegen/zip_loops.rs`)**: a fused index-zipped loop header (`for a, b in zip(xs, ys)`), tuple unpacking (`for k, v in pairs`), `enumerate(x, start)`, `dict.items()`, and `zip(...)` materialized as `list[tuple[...]]` in one pre-sized buffer.
- [x] **Inline monomorphized sorting (`src/codegen/sort.rs`)**: `sorted(xs)`, `sorted(xs, reverse=True)`, `sorted(xs, key=lambda ...)` and `xs.sort(...)` compile to an inline stable bottom-up merge sort — `O(N log N)` compares and moves with no quadratic worst case, no recursion, and no heapsort fallback; `key=` is inlined into the record-fill loop with a planar `{ key, orig_idx }` Schwartzian transform (exactly `N` key evaluations) whose permutation is applied back as a raw byte gather, so owned payloads are *moved* rather than cloned and `reverse=True` stays stable.
- [x] **Suite 7 `benchmarks/pipelines.{py,c,rs,archx.lang}`** (`pipelines.py` == `pipelines.archx.lang`, byte-for-byte identical) + a v0.9.0 stage in every `examples/comparison/full_tour.*` edition (`18 ms` 1:1 Pythonic Archx & `16 ms` Speed Archx vs `464 ms` Python 3, `25 ms` clang C, `19 ms` Rust), `0` ASan+LSan leaks, and 37 unit + 27 CLI e2e tests green across Linux, macOS, and Windows.
- [x] **Bit-identical floating point**: `archx` now passes `-ffp-contract=off` to `clang`, because clang >= 18 contracts `a*b+c` into `fma` **even at `-O2`**, which silently changes the last bits of every `float` result versus Python / Rust / the interpreter semantics Archx promises.

### Milestone 9.1 (`v0.9.1`) — Pythonic Call & Loop Semantics [DONE]
- [x] **Default parameters**: `def f(a: int, b: int = 3)` binds the declared default at the call site for every omitted trailing argument (including through keyword calls and generic instantiations).
- [x] **Keyword arguments for user functions**: `f(b=2)`, `f(h=3, w=4)` — keywords are matched against the declared parameter names, duplicates and unknown names are diagnosed, and defaults fill whatever is still missing.
- [x] **`for ... else`**: the `else` body runs only when the loop finished without `break`, for both `for i in 0..n:` and `for x in iterable:` forms (the flag is only materialized when the body can `break`), so `for ...: ... else: return ...` simplifies search loops without a sentinel variable.
- [x] **Python loop-variable scope**: loop variables (`range`, list, `str`, `enumerate`, `dict.items`, `zip`) are bound at *function* scope and keep the last value the body saw, exactly like CPython — nested loops no longer lose the inner variable, and `for j in range(2): pass` then `print(j)` prints `1`.
- [x] **`map` / `filter`**: `map(f, xs)`, `filter(p, xs)`, inline `lambda`s, and soft builtins (`map(str, xs)`) lower to pre-sized comprehension loops — a named function becomes a direct `fastcc` call and a lambda is inlined, so no function values, boxes, or per-element calls survive.
- [x] **Keyless tuple sorting**: `sorted(pairs)` and `sorted(tuples, reverse=True)` compare tuples lexicographically component by component, with LLVM-padding-correct field offsets.
- [x] Fixed the `archx_any_binop` runtime IR: bitwise/shift opcodes were unreachable behind the division guard and `%` fed a `phi` it was not a predecessor of, which clang rejected for whole programs using `%ArchxAny` arithmetic.

---

## Next Logical Steps (Ordered Implementation Plan)

### Milestone 10 (`v1.0.0`) — Multi-File Modules (`import`) & Standard Library (`sys`, `os`, `fs`, `math`, `time`)
- [ ] `import mod` / `from mod import fn` whole-program resolver + file I/O (`open` / `read_text` / `write_text`), CLI `sys.argv`, and `time.monotonic_ns()`.
- [ ] `try` / `except` / `finally` / `raise` (panic-style unwinding through the region/RAII drop machinery), `del`, `global`, `yield` generators, `class` inheritance, `*args` / `**kwargs`, nested `def` and first-class function values.
