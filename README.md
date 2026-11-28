# Archx

**Archx** is a compiled systems & application programming language with one goal: **1:1 readable like Python, as fast as (or faster than) C**.

Archx compiles Pythonic source code directly to **LLVM IR** (`clang -O2`), using the exact same optimizer and code generator as C, Rust, Swift, Zig, and Julia — with **zero garbage collector**, **zero external Rust crate dependencies**, and **14–34 KB** stripped native binaries.

> **Status (`v0.9.1` — Milestone 9.1)**:
> - **Comprehensions, generator folds, PEP 695 generics, zero-heap `lambda` & inline sorting** (new in `v0.9.0`): **list/set/dict comprehensions & nested comprehensions** (`[x * x for x in range(n) if x % 2 == 0]`, `[[r * c for c in range(k)] for r in range(n)]`) lowered to a fused loop with **one pre-sized allocation** and `memcpy`-cheap compaction, **generator reductions with no container at all** (`sum`/`min`/`max`/`any`/`all`/`len` over `(... for ... if ...)`), **PEP 695 monomorphized generics** (`def f[T](...)`, `class Box[T]`, implicit *and* explicit instantiation — `f(3)` or `f[int](3)`), **zero-heap `lambda`** bound to a name or inlined as `key=`, **`zip(...)`** as both a fused loop header and a materialized `list[tuple[...]]`, and **inline monomorphized `sorted`/`list.sort`** (stable bottom-up merge sort, `key=` inlined with a planar Schwartzian transform, `reverse=True` still stable) — no comparator callbacks, no boxing, no closure objects.
> - **Pythonic call & loop semantics** (new in `v0.9.1`): **default parameters** (`def greet(name: str, punct: str = "!")`), **keyword arguments on user functions** (`rect(h=3, w=4)`), **`for ... else`** (the `else` body runs only when the loop finished without `break`), **function-scoped loop variables** exactly like CPython (`for j in range(2): pass` then `print(j)` prints `1`, including nested loops and `for c in "ab"`), **`map`/`filter`** with named functions, soft builtins and inline `lambda`s (lowered to pre-sized loops, never to function values), and **keyless tuple sorting** (`sorted(pairs)` compares tuples lexicographically).
> - **1:1 Pythonic syntax, algebraic types, pattern matching & collections**: `def`, `class` (`def __init__(self, ...):` + `self` methods), **zero-heap tuples & multiple returns** (`(a, b, c)` / `tuple[T1, T2]`, `lo, hi, total = analyze(xs)`, `a, b = b, a`, `for k, v in pairs:`), **unboxed `T | None` optionals & flow-sensitive narrowing** (`if x is not None:` / `if x is None: return` / `x + 1 if x is not None else -1`), **algebraic `enum` sum types & exhaustive Pythonic `match`/`case`** (`|`, `if` guards, tuple & variant destructuring), **Planar `<16 x i8>` SIMD `dict` & `set`**, **Pythonic slicing & negative indexing** (`xs[a:b:step]`, `s[::-1]`, `xs[-1]`), **Smart Two-Tier Adaptive Typing (`any`)**, top-level scripts & `if __name__ == "__main__":`, `float` (`f64`), `range`, `enumerate`, `f"..."`, `print(*args, sep=..., end=...)`, `input([prompt])`, `//`, `**`, `assert`, `pass`, and `with region:`.
> - **Systems-grade performance & zero-UB safety**: **4.0×–71.2× faster than Python 3** on Suites 2–7, matching `-O2` C on Suites 3, 4, 5, 6 and 7 and `-O` Rust on 3, 4 and 5, beating both on Suite 3 (`ci/out/benchmarks.txt`; Suite 1 `primes` is Python-favourable by design and Archx is slower there) — including compiling **unchanged Python 3.10+ code (`examples/comparison/full_tour.py` == `full_tour_pythonic.archx.lang`, byte-for-byte identical!)** to run **22.4× faster than Python 3** (`17 ms` vs `381 ms`, against `clang -O2` `12 ms` and `rustc -O` `17 ms`), with `0` leaks verified across **11 targets under ASan + LSan** and **79 automated tests** (41 unit + 38 CLI) green on **Linux, macOS, and Windows**.
>
> **New here?** Read [`docs/USAGE.md`](docs/USAGE.md) for the complete user guide, [`examples/comparison/`](examples/comparison/) for the 5-way `Python 3` / `Archx Pythonic` / `Archx Speed` / `C` / `Rust` showcase, and [`docs/Roadmap.md`](docs/Roadmap.md) for the roadmap.

## Install & Usage

You need **Rust** `1.75+` and **clang** `15+`:

```sh
cargo build --release

./target/release/archx examples/enums_matching.archx.lang --run                  # compile and run
./target/release/archx examples/comparison/full_tour_pythonic.archx.lang --run   # run 1:1 Python file natively!
./target/release/archx examples/comparison/full_tour_speed.archx.lang --emit-ir  # inspect LLVM IR
./target/release/archx examples/comprehensions_and_sorting.archx.lang --run       # v0.9.0 tour
./target/release/archx examples/pythonic.archx.lang -o app                       # native executable
```

## 1:1 Python Syntax + Algebraic `enum`s, Tuples, `T | None` & `match`

```python
enum Event:
    Circle(float)
    Rect(float, float)
    Idle

def stats_and_hit(xs: list[int], limit: int) -> ((int, int), int | None):
    lo, hi = xs[0], xs[0]
    found: int | None = None
    for i, x in enumerate(xs):
        if x < lo:
            lo = x
        if x > hi:
            hi = x
        if found is None and x >= limit:
            found = i
    return (lo, hi), found

def eval_event(ev: Event) -> float:
    match ev:                                   # compiler-verified exhaustive!
        case Event.Circle(r) if r > 10.0:
            return 3.14159 * r * r
        case Event.Circle(r):
            return 2.0 * 3.14159 * r
        case Event.Rect(w, h):
            return w * h
        case Event.Idle:
            return 0.0

(lo, hi), idx = stats_and_hit([12, 5, 42, 19], 20)
if idx is not None:                             # flow-sensitive narrowing: `idx` is `int`!
    print(f"range={lo}..{hi} hit={idx} area={eval_event(Event.Rect(4.0, 5.0))}")
```

## Benchmarks (`Python 3` vs `C` vs `Rust` vs `Archx`)

`benchmarks/run.sh` runs all **seven suites** across `python3`, `clang -O2 -ffp-contract=off`, `rustc -O`, and `archx -O2`, verifying byte-identical stdout via `cmp`. The table below is generated from the committed CI report by `python3 tools/sync_readme_benchmarks.py`, and CI fails if it drifts (`ci/out/benchmarks.txt`):

| Suite | Implementation | Best ms (mean) | vs Python 3 | Stripped KB |
|---|---|---:|---:|---:|
| **1. Scalar (`primes`)** | Python 3 (`python3`) | **40 ms (40)** | 1.0× | n/a |
|  | C (`clang -O2`) | 124 ms (124) | 0.3× | 14 KB |
|  | Rust (`rustc -O`) | 124 ms (124) | 0.3× | 330 KB |
|  | **Archx (`archx -O2`)** | 142 ms (142) | **0.3×** | **14 KB** |
| **2. Arrays (`arrays`)** | Python 3 (`python3`) | 3,191 ms (3,201) | 1.0× | n/a |
|  | C raw / checked (`clang -O2`) | **81 ms (82)** | 39.4× | 14 KB |
|  | C checked, slice struct (`clang -O2`) | **81 ms (81)** | 39.4× | 14 KB |
|  | Rust (safe `Vec` `-O`) | 84 ms (85) | 38.0× | 331 KB |
|  | **Archx (safe `list[T]` `-O2`)** | 87 ms (89) | **36.7×** | **14 KB** |
| **3. Composite (`composite`)** | Python 3 (`python3`) | 821 ms (821) | 1.0× | n/a |
|  | C (`AoS + malloc/strcmp -O2`) | 38 ms (38) | 21.6× | 14 KB |
|  | Rust (`Vec<Body> + String -O`) | 41 ms (41) | 20.0× | 332 KB |
|  | **Archx (`SoA + region + SSO -O2`)** | **27 ms (28)** | **30.4×** | **14 KB** |
| **4. Pythonic Float N-Body (`nbody_float`)** | Python 3 (`python3`) | 3,204 ms (3,208) | 1.0× | n/a |
|  | C (`AoS Body* -O2 -lm`) | 51 ms (51) | 62.8× | 14 KB |
|  | Rust (`Vec<Body> -O`) | 51 ms (51) | 62.8× | 332 KB |
|  | **Archx (`Pythonic class + SoA -O2`)** | **45 ms (45)** | **71.2×** | **14 KB** |
| **5. Planar SIMD Dict (`dict_bench`)** | Python 3 (built-in C `dict`) | 219 ms (219) | 1.0× | n/a |
|  | C (`AoS open-addressing -O2`) | 65 ms (65) | 3.4× | 14 KB |
|  | Rust (`std::HashMap` `-O`) | 47 ms (47) | 4.7× | 354 KB |
|  | **Archx Static (`Planar SIMD + region`)** | **46 ms (47)** | **4.8×** | **22 KB** |
|  | **Archx Dynamic (`%ArchxAny dict[any]`)** | 74 ms (74) | **3.0×** | **22 KB** |
| **6. 5-Way Full-Feature Tour (`full_tour`)** | Python 3 (`full_tour.py`) | 381 ms (383) | 1.0× | n/a |
|  | **Archx Pythonic (`1:1 == full_tour.py`)** | 17 ms (17) | **22.4×** | **42 KB** |
|  | **Archx Speed (`SoA + region + enum`)** | 16 ms (16) | **23.8×** | **38 KB** |
|  | Clang C (`full_tour.c -O2 -lm`) | **12 ms (12)** | 31.8× | 18 KB |
|  | Rust (`full_tour.rs` `rustc -O`) | 17 ms (17) | 22.4× | 377 KB |
| **7. Comprehensions, Generators, `zip` & Inline Sorting (`pipelines`)** | Python 3 (`pipelines.py`) | 40 ms (40) | 1.0× | n/a |
|  | **Archx Pythonic (`1:1 == pipelines.py`)** | **10 ms (10)** | **4.0×** | **38 KB** |
|  | Clang C (`pipelines.c -O2`) | 11 ms (11) | 3.6× | 18 KB |
|  | Rust (`pipelines.rs` `rustc -O`) | **10 ms (10)** | 4.0× | 400 KB |

See [`examples/comparison/`](examples/comparison/), [`benchmarks/README.md`](benchmarks/README.md), and [`docs/OPTIMIZATION.md`](docs/OPTIMIZATION.md) for the side-by-side code and `-O2` LLVM IR proofs.

## Architecture

```text
.archx.lang source (1:1 Python syntax + optional SoA / region: / enum speedups)
    │
    ▼  src/lexer.rs + src/parser.rs
ast::Program (classes/__init__, enums, functions, match/case, tuples, synthesized main)
    │
    ▼  src/codegen/ (Adaptive 2-Tier Engine, Tuples/T|None/Enums, Planar SIMD dict/set, SoA, region:, SSO, RAII)
LLVM IR (textual .ll)
    │
    ▼  clang -O2 (-lm on Unix, -llegacy_stdio_definitions on Windows MSVC)
Native Executable (Linux ELF, macOS Mach-O, Windows PE .exe — 14–34 KB stripped)
```

## License

MIT
