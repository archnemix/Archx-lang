# Archx

**Archx** is a compiled systems & application programming language with one goal: **1:1 readable like Python, as fast as (or faster than) C**.

Archx compiles Pythonic source code directly to **LLVM IR** (`clang -O2`), using the exact same optimizer and code generator as C, Rust, Swift, Zig, and Julia — with **zero garbage collector**, **zero external Rust crate dependencies**, and **14 KB** stripped native binaries.

> **Status (`v0.7.0` — Milestone 7)**:
> - **1:1 Pythonic syntax, collections & console I/O**: `def`, `class` + `self` methods (`b.kinetic()`, `c.inc()`), **Planar SIMD `dict` & `set`** (`{k: v}`, `{a, b}`, `dict()`, `set()`, `.get`, `.pop`, `.keys`, `.values`, `.items`, `.add`, `.remove`, `.discard`, `for k, v in d.items():`), **Pythonic slicing & negative indexing** (`xs[a:b:step]`, `xs[::-1]`, `xs[-1]`, `s[::-1]`, `s[-1]`), **Smart Two-Tier Adaptive Typing (`any`)** (mixed containers `{"data": ["Archx", 18, "legal"], "age": 18}`, dynamic variable rebinding `name = "Abdullah"` → `name = 18`, untyped `def describe(val):`, `is` / `is not None`, `type(x)`), top-level scripts & `if __name__ == "__main__":`, `float` (`f64`), `list[T]`, `range(...)`, `enumerate(...)`, `f"..."`, `print(*args, sep=..., end=...)`, `input([prompt])`, `//`, `**`, `a if c else b`, `in` / `not in`, `assert`, `pass`, and `with region:`.
> - **Systems-grade performance & zero-UB safety**: **Planar `<16 x i8>` SIMD SwissTable `dict`/`set`** (beating both `-O2` C and Rust `std::collections::HashMap`!), **Transparent AoS-to-SoA SIMD planarization** for `[Class]`/`[Struct]` arrays, **2-tier static specialization + 24-byte unboxed `%ArchxAny`**, 64 KB scoped `region:` bump arenas with compile-time escape checking + `return` heap promotion, 16-byte German/Umbra **prefix-SSO `str`**, checked `i64` overflow & division, bounds-check elision, and deterministic recursive RAII (`0` leaks verified under **ASan + LSan** across **Linux, macOS, and Windows**).
>
> **New here?** Read [`docs/USAGE.md`](docs/USAGE.md) for the complete user guide and [`docs/Roadmap.md`](docs/Roadmap.md) for the project roadmap.

## Install & Usage

You need **Rust** `1.75+` and **clang** `15+`:

```sh
cargo build --release

./target/release/archx examples/collections_dynamic.archx.lang --run  # compile and run
./target/release/archx examples/pythonic.archx.lang --emit-ir         # inspect LLVM IR
./target/release/archx examples/pythonic.archx.lang -o app            # native executable
```

## 1:1 Pythonic Syntax Compiling to Native SIMD & Adaptive Typing

```python
# Tier 1: Statically specialized to zero-tag Planar `<16 x i8>` SIMD `dict[str, int]`!
with region:
    counts = {}
    for w in "archx simd archx planar archx".split():
        counts[w] = counts.get(w, 0) + 1
    for k, v in counts.items():
        print(f"{k}={v}", end=" ")
    print()

# Tier 2: Mixed containers & dynamic rebinding automatically promote to 24B `%ArchxAny`!
hello = {"data": ["Archx", 18, "legal"], "age": 18}
hello["data"].append("fast")
hello["age"] += 3
print(hello["data"][0], hello["data"][-1], hello["age"])

name = "Abdullah"
name = 18
print(name + 4, type(name))
```

## Benchmarks (`C` vs `Rust` vs `Archx`)

`benchmarks/run.sh` compiles all **five suites** at `-O2` / `rustc -O`, verifies byte-identical stdout via `cmp`, and times best-of-7 in CI (`ci/out/benchmarks.txt`, `clang 21.1.8` / `rustc 1.100.0`):

| Suite | Implementation | Best of 7 (mean) | Binary (raw) | Binary (stripped) |
|---|---|---:|---:|---:|
| **1. Scalar (`primes`)** | C (`clang -O2`) | **119 ms** (119 ms) | 16 KB | **14 KB** |
| | Rust (`rustc -O`) | **119 ms** (119 ms) | 4,388 KB | **330 KB** |
| | Archx (`archx -O2`) | **119 ms** (119 ms) | 16 KB | **14 KB** |
| **2. Arrays (`arrays`)** | C raw ptr (unchecked `-O2`) | **59 ms** (63 ms) | 16 KB | **14 KB** |
| | C checked (slice struct `-O2`) | **57 ms** (58 ms) | 16 KB | **14 KB** |
| | Rust (safe `Vec` `-O`) | **61 ms** (61 ms) | 4,389 KB | **331 KB** |
| | **Archx (safe `list[T]` `-O2`)** | **56 ms** (57 ms) | 16 KB | **14 KB** |
| **3. Composite (`composite`)** | C (`AoS + malloc/strcmp -O2`) | **22 ms** (22 ms) | 16 KB | **14 KB** |
| | Rust (`Vec<Body> + String -O`) | **25 ms** (25 ms) | 4,390 KB | **332 KB** |
| | **Archx (`SoA + region + SSO -O2`)** | **18 ms** (18 ms) | 16 KB | **14 KB** |
| **4. Pythonic Float N-Body (`nbody_float`)** | C (`AoS Body* -O2 -lm`) | **67 ms** (68 ms) | 16 KB | **14 KB** |
| | Rust (`Vec<Body> -O`) | **67 ms** (67 ms) | 4,390 KB | **332 KB** |
| | **Archx (`Pythonic class + SoA -O2`)** | **62 ms** (62 ms) | 16 KB | **14 KB** |
| **5. Planar SIMD Dict & Adaptive Typing (`dict_bench`)** | C (`AoS open-addressing -O2`) | **61 ms** (62 ms) | 16 KB | **14 KB** |
| | Rust (`std::HashMap` SwissTable `-O`) | **52 ms** (52 ms) | 4,424 KB | **354 KB** |
| | **Archx Static (`Planar SIMD + region -O2`)** | **48 ms** (48 ms) | 24 KB | **22 KB** |
| | Archx Dynamic (`%ArchxAny dict[any,any] -O2`) | **87 ms** (87 ms) | 24 KB | **22 KB** |

Across **Suites 2, 3, 4, and 5**, **Pythonic Archx beats both `-O2` C and `-O` Rust** — including beating Rust's `hashbrown` SwissTable (`48 ms` vs `52 ms` Rust / `61 ms` C) at **1/16th the stripped binary size (`22 KB` vs `354 KB`)**, while full dynamic `%ArchxAny` mode runs in `87 ms` (`< 1.8×` static C/Rust). See [`benchmarks/README.md`](benchmarks/README.md) and [`docs/OPTIMIZATION.md`](docs/OPTIMIZATION.md) for the `-O2` LLVM IR proofs.

## Architecture

```text
.archx.lang source (1:1 Pythonic syntax — static specialization + dynamic %ArchxAny)
    │
    ▼  src/lexer.rs + src/parser.rs
ast::Program (classes/methods, functions, dicts/sets/slices, synthesized script main)
    │
    ▼  src/codegen/ (Adaptive 2-Tier Engine, Planar SIMD dict/set, SoA, region:, 16B SSO, RAII)
LLVM IR (textual .ll)
    │
    ▼  clang -O2 (-lm on Unix, -llegacy_stdio_definitions on Windows MSVC)
Native Executable (Linux ELF, macOS Mach-O, Windows PE .exe — 14–22 KB stripped)
```

## License

MIT
