<!-- Ordered milestone roadmap for Archx: completed Milestones 1–6 and detailed next logical steps (Milestones 7–10). -->

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
- [x] **Pythonic console I/O, `f"..."` & methods**: `print(*args, sep=..., end=...)`, cross-platform `input([prompt])`, `f"..."` string interpolation, `int()`/`float()`/`str()`/`bool()`, LEGB soft built-ins (`abs`, `min`, `max`, `sum`, `sqrt`, `ord`, `chr`), list methods (`.append`, `.pop`, `.clear`), and SSO-aware string methods (`.strip`, `.upper`, `.lower`, `.startswith`, `.endswith`, `.find`, `.replace`, `.split`)
- [x] **Suite 4 (`nbody_float`) benchmark**: Pythonic Archx (`52 ms`) beats both `-O2` C (`56 ms`) and `-O` Rust (`56 ms`) with `0` ASan+LSan leaks across Linux, macOS, and Windows

---

## Next Logical Steps (Ordered Implementation Plan)

### Milestone 7 (`v0.7.0`) — Dictionaries (`dict[K, V]`), Sets (`set[T]`), Slices (`xs[a:b]`), and Negative Indexing **[NEXT STEP]**
- [ ] Open-addressed SwissTable / Robin Hood `dict[K, V]` (`{k: v}`, `d[k]`, `k in d`, `.get()`, `.items()`) and `set[T]` compatible with RAII and `with region:`.
- [ ] Pythonic slicing `xs[a:b]`, `xs[:b]`, `xs[a:]`, `s[a:b]` and negative indexing `xs[-1]`, `s[-1]`.
- [ ] Tuple literals & multiple return unpacking (`a, b = pair()`).

### Milestone 8 (`v0.8.0`) — Algebraic `enum`s, Optional `T | None`, and Exhaustive `match`
- [ ] Python `match subject: case ...:` pattern matching + payload-carrying `enum`s and unboxed `T | None` optionals.

### Milestone 9 (`v0.9.0`) — Monomorphized Generics & Closures / Comprehensions
- [ ] List comprehensions (`[x * 2 for x in xs if x > 0]` pre-sized in a single allocation!) and monomorphized generic functions/classes (`def first[T](xs: list[T]) -> T:`).

### Milestone 10 (`v1.0.0`) — Multi-File Modules (`import`) & Standard Library (`sys`, `os`, `fs`, `math`)
- [ ] `import mod` / `from mod import fn` whole-program resolver + file I/O (`open` / `read_text` / `write_text`), CLI `sys.argv`, and `time.monotonic_ns()`.
