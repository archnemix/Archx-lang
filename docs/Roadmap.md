<!-- Ordered milestone roadmap for Archx: completed Milestones 1–7 and detailed next logical steps (Milestones 8–10). -->

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
- [x] **Pythonic loops & expressions**: `range(stop)` / `range(start, stop)` / `range(start, stop, step)` (positive, negative, and dynamic steps), zero-allocation `for i, x in enumerate(xs, start):`, `for ch in s:`, `a if cond else b`, `in` / `not in`, `[v] * n`, `s * n`, `xs + ys`
- [x] **Pythonic console I/O, `f"..."` & methods**: `print(*args, sep=..., end=...)`, cross-platform `input([prompt])`, `f"..."` string interpolation, `int()`/`float()`/`str()`/`bool()`, LEGB soft built-ins (`abs`, `min`, `max`, `sum`, `sqrt`, `ord`, `chr`), list methods (`.append`, `.pop`, `.clear`), and SSO-aware string methods
- [x] **Suite 4 (`nbody_float`) benchmark**: Pythonic Archx beats both `-O2` C and `-O` Rust with `0` ASan+LSan leaks across Linux, macOS, and Windows

### Milestone 7 (`v0.7.0`) — Planar SIMD `dict` / `set`, Slicing, Negative Indexing & Smart Adaptive Typing (`any`) [DONE]
- [x] **Planar `<16 x i8>` SIMD SwissTable `dict[K, V]` & `set[T]`**: 16-wide SIMD control-byte probing + single-probe `upsert` + dense insertion-ordered planar `keys[]`/`vals[]` + inline Prefix-SSO string hashing/equality + backward-shift `.pop()` compaction + `with region:` arena allocation & `return` heap promotion (`{k: v}`, `{a, b}`, `dict()`, `set()`, `k in d`, `.get`, `.pop`, `.keys`, `.values`, `.items`, `.add`, `.remove`, `.discard`, `.clear`, `for k, v in d.items():`)
- [x] **Pythonic Slicing & Negative Indexing**: `xs[a:b:step]`, `xs[::-1]`, `xs[-1] = v`, `s[a:b:step]`, `s[::-1]`, `s[-1]`
- [x] **Smart Two-Tier Adaptive Type Engine (`%ArchxAny`)**: Tier-1 zero-tag static specialization (including usage-based inference of `{}` and `[]`) + Tier-2 24-byte stack-register `%ArchxAny` promotion for mixed containers (`{"data": ["Archx", 18, "legal"], "age": 18}`), dynamic variable rebinding (`name = "Abdullah"` → `name = 18`), untyped functions (`def f(x):`), `is` / `is not None`, and `type(x)`
- [x] **Suite 5 (`dict_bench` & `dict_dynamic`) benchmark**: Archx Static (`48 ms`, `22 KB` stripped) beats both `-O2` C (`61 ms`) and Rust `std::collections::HashMap` (`52 ms`, `354 KB` stripped), with `0` ASan+LSan leaks across 8 targets and 34 unit + 21 CLI e2e tests green on Linux, macOS, and Windows

---

## Next Logical Steps (Ordered Implementation Plan)

### Milestone 8 (`v0.8.0`) — Algebraic `enum`s, Tuples, Optional `T | None`, and Exhaustive `match` **[NEXT STEP]**
- [ ] Tuple literals & multiple return unpacking (`a, b = pair()`).
- [ ] Python `match subject: case ...:` pattern matching + payload-carrying `enum`s and unboxed static `T | None` optionals.

### Milestone 9 (`v0.9.0`) — Monomorphized Generics & Closures / Comprehensions
- [ ] List comprehensions (`[x * 2 for x in xs if x > 0]` pre-sized in a single allocation!) and monomorphized generic functions/classes (`def first[T](xs: list[T]) -> T:`).

### Milestone 10 (`v1.0.0`) — Multi-File Modules (`import`) & Standard Library (`sys`, `os`, `fs`, `math`)
- [ ] `import mod` / `from mod import fn` whole-program resolver + file I/O (`open` / `read_text` / `write_text`), CLI `sys.argv`, and `time.monotonic_ns()`.
