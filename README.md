# Archx

**Archx** is a compiled systems & application programming language with one goal: **1:1 readable like Python, as fast as (or faster than) C**.

Archx compiles Pythonic source code directly to **LLVM IR** (`clang -O2`), using the exact same optimizer and code generator as C, Rust, Swift, Zig, and Julia — with **zero garbage collector**, **zero external Rust crate dependencies**, and **14–34 KB** stripped native binaries.

> **Status (`v0.8.0` — Milestone 8)**:
> - **1:1 Pythonic syntax, algebraic types, pattern matching & collections**: `def`, `class` (`def __init__(self, ...):` + `self` methods), **zero-heap tuples & multiple returns** (`(a, b, c)` / `tuple[T1, T2]`, `lo, hi, total = analyze(xs)`, `a, b = b, a`, `for k, v in pairs:`), **unboxed `T | None` optionals & flow-sensitive narrowing** (`if x is not None:` / `if x is None: return` / `x + 1 if x is not None else -1`), **algebraic `enum` sum types & exhaustive Pythonic `match`/`case`** (`|`, `if` guards, tuple & variant destructuring), **Planar `<16 x i8>` SIMD `dict` & `set`**, **Pythonic slicing & negative indexing** (`xs[a:b:step]`, `s[::-1]`, `xs[-1]`), **Smart Two-Tier Adaptive Typing (`any`)**, top-level scripts & `if __name__ == "__main__":`, `float` (`f64`), `range`, `enumerate`, `f"..."`, `print(*args, sep=..., end=...)`, `input([prompt])`, `//`, `**`, `assert`, `pass`, and `with region:`.
> - **Systems-grade performance & zero-UB safety**: **14.6×–70.5× faster than Python 3.14**, matching or **beating `-O2` C and `-O` Rust** across Suites 3, 4, 5, and 6 (`ci/out/benchmarks.txt`) — including compiling **unchanged Python 3.10+ code (`examples/comparison/full_tour.py` == `full_tour_pythonic.archx.lang`, byte-for-byte identical!)** to run **22.9× faster than Python 3** (`13 ms` vs `298 ms`, tying `rustc -O` `13 ms`!), with `0` leaks verified across **11 suites under ASan + LSan** and **60 automated tests** green on **Linux, macOS, and Windows**.
>
> **New here?** Read [`docs/USAGE.md`](docs/USAGE.md) for the complete user guide, [`examples/comparison/`](examples/comparison/) for the 5-way `Python 3` / `Archx Pythonic` / `Archx Speed` / `C` / `Rust` showcase, and [`docs/Roadmap.md`](docs/Roadmap.md) for the roadmap.

## Install & Usage

You need **Rust** `1.75+` and **clang** `15+`:

```sh
cargo build --release

./target/release/archx examples/enums_matching.archx.lang --run                  # compile and run
./target/release/archx examples/comparison/full_tour_pythonic.archx.lang --run   # run 1:1 Python file natively!
./target/release/archx examples/comparison/full_tour_speed.archx.lang --emit-ir  # inspect LLVM IR
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

`benchmarks/run.sh` runs all **six suites** across `python3` (`Python 3.14.4`), `clang 21.1.8 -O2`, `rustc 1.100.0 -O`, and `archx v0.8.0 -O2`, verifying byte-identical stdout via `cmp` (`ci/out/benchmarks.txt`):

| Suite | Implementation | Best ms (mean) | vs Python 3 | Stripped KB |
|---|---|---:|---:|---:|
| **1. Scalar (`primes`)** | Python 3 (`python3`) | 1,420 ms (1,421) | 1.0× | n/a |
| | C (`clang -O2`) | **97 ms** (97) | **14.6×** | **14 KB** |
| | Rust (`rustc -O`) | **97 ms** (97) | **14.6×** | 330 KB |
| | **Archx (`archx -O2`)** | **97 ms** (97) | **14.6×** | **14 KB** |
| **2. Arrays (`arrays`)** | Python 3 (`python3`) | 2,475 ms (2,488) | 1.0× | n/a |
| | C raw / checked (`clang -O2`) | **75 ms** (75–76) | **33.0×** | **14 KB** |
| | Rust (safe `Vec` `-O`) | **75 ms** (75) | **33.0×** | 331 KB |
| | **Archx (safe `list[T]` `-O2`)** | **76 ms** (76) | **32.6×** | **14 KB** |
| **3. Composite (`composite`)** | Python 3 (`python3`) | 648 ms (651) | 1.0× | n/a |
| | C (`AoS + malloc/strcmp -O2`) | 32 ms (32) | 20.2× | **14 KB** |
| | Rust (`Vec<Body> + String -O`) | 34 ms (34) | 19.1× | 332 KB |
| | **Archx (`SoA + region + SSO -O2`)** | **25 ms** (25) | **25.9×** | **14 KB** |
| **4. Pythonic Float N-Body (`nbody_float`)** | Python 3 (`python3`) | 2,538 ms (2,570) | 1.0× | n/a |
| | C (`AoS Body* -O2 -lm`) | 41 ms (41) | 61.9× | **14 KB** |
| | Rust (`Vec<Body> -O`) | 41 ms (41) | 61.9× | 332 KB |
| | **Archx (`Pythonic class + SoA -O2`)** | **36 ms** (36) | **70.5×** | **14 KB** |
| **5. Planar SIMD Dict (`dict_bench`)** | Python 3 (built-in C `dict`) | 172 ms (173) | 1.0× | n/a |
| | C (`AoS open-addressing -O2`) | 51 ms (51) | 3.4× | **14 KB** |
| | Rust (`std::HashMap` `-O`) | 37 ms (37) | 4.6× | 354 KB |
| | **Archx Static (`Planar SIMD + region`)** | **36 ms** (36) | **4.8×** | **22 KB** |
| | Archx Dynamic (`%ArchxAny dict[any]`) | 58 ms (58) | 3.0× | **22 KB** |
| **6. 5-Way Full-Feature Tour (`full_tour`)** | Python 3 (`full_tour.py`) | 298 ms (299) | 1.0× | n/a |
| | **Archx Pythonic (`1:1 == full_tour.py`)** | **13 ms** (13) | **22.9×** | **34 KB** |
| | **Archx Speed (`SoA + region + enum`)** | **12 ms** (12) | **24.8×** | **34 KB** |
| | Rust (`full_tour.rs` `rustc -O`) | **13 ms** (13) | **22.9×** | 359 KB |
| | Clang C (`full_tour.c -O2 -lm`) | **9 ms** (9) | **33.1×** | **14 KB** |

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
