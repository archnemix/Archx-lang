# Archx

**Archx** is a compiled systems & application programming language with one goal: **1:1 readable like Python, as fast as (or faster than) C**.

Archx compiles Pythonic source code directly to **LLVM IR** (`clang -O2`), using the exact same optimizer and code generator as C, Rust, Swift, Zig, and Julia — with **zero garbage collector**, **zero external Rust crate dependencies**, and **14 KB** stripped native binaries.

> **Status (`v0.6.0` — Milestone 6)**:
> - **1:1 Pythonic syntax & console I/O**: `def`, `class` + `self` methods (`b.kinetic()`, `c.inc()`), top-level scripts & `if __name__ == "__main__":`, variable binding without `let`, `float` (`f64`), `list[T]`, `[val] * n`, `range(start, stop, step)` (positive & negative steps), `enumerate(xs, start)`, `for ch in s:`, `f"..."` string interpolation, `print(*args, sep=..., end=...)`, `input([prompt])`, `//`, `**`, inline `a if c else b`, `in` / `not in`, `.append`/`.pop`/`.clear`, `.strip`/`.split`/`.replace`/`.find`/`.upper`/`.lower`/`.startswith`/`.endswith`, `int`/`float`/`str`/`bool`/`abs`/`min`/`max`/`sum`/`sqrt`/`ord`/`chr`, `assert`, `pass`, and `with region:`.
> - **Systems-grade performance & zero-UB safety**: **Transparent AoS-to-SoA SIMD planarization** for `[Class]`/`[Struct]` arrays, 64 KB scoped `region:` bump arenas with compile-time escape checking + `return` heap promotion, 16-byte German/Umbra **prefix-SSO `str`**, checked `i64` overflow & division, bounds-check elision, and deterministic recursive RAII (`0` leaks verified under **ASan + LSan** across **Linux, macOS, and Windows**).
>
> **New here?** Read [`docs/USAGE.md`](docs/USAGE.md) for the complete user guide and [`docs/Roadmap.md`](docs/Roadmap.md) for the project roadmap.

## Install & Usage

You need **Rust** `1.75+` and **clang** `15+`:

```sh
cargo build --release

./target/release/archx examples/pythonic.archx.lang --run      # compile and run
./target/release/archx examples/pythonic.archx.lang --emit-ir  # inspect LLVM IR
./target/release/archx examples/pythonic.archx.lang -o app     # native executable
```

## 1:1 Pythonic Syntax Compiling to Native SIMD

```python
class Body:
    x: float
    y: float
    vx: float
    vy: float
    mass: float

    def kinetic(self) -> float:
        return 0.5 * self.mass * (self.vx * self.vx + self.vy * self.vy)

def simulate(n: int, steps: int) -> float:
    # Automatically splits into 5 contiguous 16B-aligned `double*` SIMD SoA planes!
    bodies = [Body(0.0, 0.0, 1.5, -0.5, 2.0)] * n
    dt = 0.01
    for _ in range(steps):
        for i in range(n):
            bodies[i].x += bodies[i].vx * dt
            bodies[i].y += bodies[i].vy * dt

    energy = 0.0
    for i in range(n):
        energy += bodies[i].kinetic()
    return energy

if __name__ == "__main__":
    total = simulate(100_000, 60)
    with region:
        words = "  pythonic syntax native speed  ".strip().split()
        print(f"{words[0].upper()} -> energy={total}", end="\n")
```

## Benchmarks (`C` vs `Rust` vs `Archx`)

`benchmarks/run.sh` compiles all **four suites** at `-O2` / `rustc -O`, verifies byte-identical stdout via `cmp`, and times best-of-7 in CI (`ci/out/benchmarks.txt`, `clang 21.1.8` / `rustc 1.100.0`):

| Suite | Implementation | Best of 7 (mean) | Binary (raw) | Binary (stripped) |
|---|---|---:|---:|---:|
| **1. Scalar (`primes`)** | C (`clang -O2`) | **104 ms** (104 ms) | 16 KB | **14 KB** |
| | Rust (`rustc -O`) | **104 ms** (104 ms) | 4,388 KB | **330 KB** |
| | Archx (`archx -O2`) | **104 ms** (104 ms) | 16 KB | **14 KB** |
| **2. Arrays (`arrays`)** | C raw ptr (unchecked `-O2`) | **50 ms** (50 ms) | 16 KB | **14 KB** |
| | C checked (slice struct `-O2`) | **49 ms** (49 ms) | 16 KB | **14 KB** |
| | Rust (safe `Vec` `-O`) | **54 ms** (54 ms) | 4,389 KB | **331 KB** |
| | Archx (safe `list[T]` `-O2`) | **50 ms** (51 ms) | 16 KB | **14 KB** |
| **3. Composite (`composite`)** | C (`AoS + malloc/strcmp -O2`) | **16 ms** (16 ms) | 16 KB | **14 KB** |
| | Rust (`Vec<Body> + String -O`) | **19 ms** (19 ms) | 4,390 KB | **332 KB** |
| | **Archx (`SoA + region + SSO -O2`)** | **14 ms** (14 ms) | 16 KB | **14 KB** |
| **4. Pythonic Float N-Body (`nbody_float`)** | C (`AoS Body* -O2 -lm`) | **56 ms** (56 ms) | 16 KB | **14 KB** |
| | Rust (`Vec<Body> -O`) | **56 ms** (56 ms) | 4,390 KB | **332 KB** |
| | **Archx (`Pythonic class + SoA -O2`)** | **52 ms** (52 ms) | 16 KB | **14 KB** |

On **Suite 3 (`composite`, `14 ms` vs `16 ms` C / `19 ms` Rust)** and **Suite 4 (`nbody_float`, `52 ms` vs `56 ms` C / `56 ms` Rust)**, **Pythonic Archx beats both `-O2` C and `-O` Rust** while remaining 100% memory- and bounds-safe in a **14 KB** stripped executable (**23.7× smaller** than stripped Rust). See [`benchmarks/README.md`](benchmarks/README.md) and [`docs/OPTIMIZATION.md`](docs/OPTIMIZATION.md) for the `-O2` LLVM IR proofs.

## Architecture

```text
.archx.lang source (1:1 Pythonic syntax or classic Archx syntax)
    │
    ▼  src/lexer.rs + src/parser.rs
ast::Program (classes/methods, functions, synthesized script main)
    │
    ▼  src/codegen/ (SoA planarization, region escape check, SSO strings, RAII, bounds elision)
LLVM IR (textual .ll)
    │
    ▼  clang -O2 (-lm on Unix, -llegacy_stdio_definitions on Windows MSVC)
Native Executable (Linux ELF, macOS Mach-O, Windows PE .exe — ~14 KB stripped)
```

## License

MIT
