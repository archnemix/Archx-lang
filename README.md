# Archx

**Archx** is a small programming language with one goal: **readable like Python, fast like C**.

Archx compiles to **LLVM IR**, so it uses the same optimizer and backends as C, Rust, Swift, Zig, and Julia. One frontend, every architecture LLVM supports: x86-64, ARM64, RISC-V, WASM, and more.

> Status: milestone 4 — arrays (`[T]`, `[a, b, c]`, `[val; count]`, `len`,
> `push`, `pop`), indexing with compile-time bounds-check elision, `elif`,
> compound assignment (`+=`, `-=`, `*=`, `/=`, `%=`), `while` / `for` loops,
> `break` / `continue`, booleans, short-circuit `and`/`or`/`not`, functions,
> `let`/`return`, and `print`.
>
> Benchmarked against C and Rust on both scalar and array loops — see [Benchmarks](#benchmarks).

## Why LLVM?

Hand-written assembly is architecture-specific: x86-64 assembly is useless on ARM64 or RISC-V, so you would rewrite the backend for every target. Emitting **LLVM IR** instead means one frontend and LLVM handles optimization and code generation everywhere. That is how Clang, Rust, Swift, Zig, and Julia reach C-class performance.

QBE is a lighter alternative with faster compiles, but its optimizer is far less mature than LLVM's. Archx uses LLVM and keeps the door open for a second backend behind the same IR interface.

## Install

You need:

- **Rust** 1.75+ — <https://rustup.rs>
- **clang** 15+ — Archx emits LLVM IR and uses clang as the LLVM compiler driver.

```sh
cargo build --release
```

The compiler binary is `target/release/archx`.

## Usage

```sh
archx examples/hello.archx.lang              # compile to ./examples/hello
archx examples/hello.archx.lang --run        # compile and run
archx examples/hello.archx.lang --emit-ir    # print the generated LLVM IR
archx examples/hello.archx.lang -o hello     # choose the output name
```

## Syntax

```archx
func dot(a: [int], b: [int]) -> int:
    let total = 0
    for i in 0..len(a):
        total += a[i] * b[i]
    return total

func grade(score: int) -> string:
    if score >= 90:
        return "A"
    elif score >= 80:
        return "B"
    else:
        return "C"

func main():
    let nums = [10, 20, 30, 40]
    nums[1] += 5
    print(nums)
    print(dot(nums, [1, 2, 3, 4]))

    let stack: [int] = []
    for i in 1..4:
        push(stack, i * 10)
    print(pop(stack))
    print(grade(85))
```

Rules so far:

- Blocks are indentation-based (4 spaces per level; a tab counts as 4 columns).
- No semicolons at the end of statements (`;` is only used in `[value; count]` repeat arrays).
- `#` starts a comment.
- Strings use `'single'` or `"double"` quotes; `==`, `!=`, and `len(s)` work on strings.
- Scalar types: `int` (64-bit signed), `bool` (`true`/`false`), `string` (immutable UTF-8).
- Array types: `[T]` (for example `[int]`, `[bool]`, `[string]`, `[[int]]`).
  - Literals: `[1, 2, 3]`, empty `let xs: [int] = []`, or sized/filled `[0; n]` / `[true; limit]`.
  - Builtins: `len(arr)`, `push(arr, value)`, `pop(arr)`, and `print(arr)`.
  - Indexing `arr[i]` and `arr[i] = v` are memory-safe: out-of-bounds accesses panic cleanly, and bounds checks are **elided at compile time** when `0 <= i < len(arr)` is proven (such as `for i in 0..len(arr):`).
- Arithmetic: `+`, `-`, `*`, `/`, `%`. Compound assignment: `+=`, `-=`, `*=`, `/=`, `%=`.
- Comparisons: `==`, `!=`, `<`, `>`, `<=`, `>=`.
- Logical operators: `and`, `or`, `not` — `and`/`or` short-circuit.
- Conditionals: `if cond:`, `elif cond:`, `else:`.
- `while cond:` repeats while `cond` is true.
- `for i in a..b:` counts `a, a+1, … b-1` — the end is **exclusive**, like Rust's `a..b`. Both bounds are evaluated once, up front.
- `break` leaves the innermost loop; `continue` starts its next iteration.
- `let name = value` (or `let name: Type = value`) declares a variable; `name = value` assigns to an existing variable.
- `print(...)` prints `int`, `bool`, `string`, or 1D arrays.
- `func main():` is the executable entry point.
- Files use a double extension: `.archx.lang`, `.archx.lg`, `.ax.lang`, or `.ax.lg`.

## Why `main`?

It is not about speed. Python is interpreted, so the interpreter can start executing top-level statements anywhere. A compiled binary is raw machine code: the operating system loader needs **one exact entry address** to jump to. That address is `main`. It is a linking convention, not a performance feature.

## How memory works today

- **Immutable scalars (`int`, `bool`, `string`)** — parameters and `let` bindings that are never reassigned stay directly in **LLVM SSA registers** with zero stack allocations.
- **Mutable locals** — use entry-block stack slots (`alloca`), promoted to CPU registers by LLVM's `mem2reg`/SROA passes at `-O2`.
- **Strings** — interned global UTF-8 constants in `.rodata`.
- **Arrays (`[T]`)** — contiguous heap buffers represented by a 24-byte `{ len, cap, data }` value (`%ArchxVec`), with `@calloc` zero-page allocation for `[0; n]` / `[false; n]`, 1-byte-per-element `[bool]` storage, and **automatic deterministic scope-exit `free`** for non-escaping local arrays (no GC pauses).

See [`docs/FUNDAMENTALS.md`](docs/FUNDAMENTALS.md) for the language design fundamentals (why existing languages fall short, memory model, binary size, readability, and straightforwardness) and [`docs/OPTIMIZATION.md`](docs/OPTIMIZATION.md) for the before/after IR and optimization strategy.

## Optimization

Archx optimizes at four layers:

1. **Language design** — value semantics, no hidden allocations, monomorphized generics (later), defined overflow, no UB-driven surprises.
2. **Frontend** — clean IR, entry-block allocas, string interning, constant folding (next), no unnecessary loads.
3. **LLVM middle-end** — `-O2` by default (SROA, GVN, inlining, loop unrolling, vectorization).
4. **Backend/runtime** — instruction selection, register allocation, and later custom allocators/arenas.

`-O3`, LTO, PGO, and custom passes are available later once there is a benchmark suite to measure them. See `docs/OPTIMIZATION.md`.

## Benchmarks

`benchmarks/` compares **C, Rust, and Archx** across two suites (compiled at `-O2` / `rustc -O`, timed best-of-5, with stdout verified identical via `cmp`):

1. **Scalar loops (`benchmarks/primes.*`)** — 20M iterations of `(total + i*i) % 1_000_007` + trial-division prime counting below 400,000.
2. **Array loops & bounds checking (`benchmarks/arrays*`)** — 60 rounds of 1,000,000-element vector math (`dst[i] = a[i]*3 + b[i] + r`) + Sieve of Eratosthenes below 5,000,000.

```sh
bash benchmarks/run.sh
```

Latest GitHub Actions run (`ci/out/benchmarks.txt`, best of 7):

| Suite | Implementation | Best of 7 (mean) | Binary (raw) | Binary (stripped) |
|---|---|---:|---:|---:|
| **Scalar (`primes`)** | C (`clang -O2`) | **94 ms** (94 ms) | 16 KB | **14 KB** |
| | Rust (`rustc -O`) | **94 ms** (94 ms) | 4,388 KB | **330 KB** |
| | Archx (`archx -O2`) | **93 ms** (93 ms) | 16 KB | **14 KB** |
| **Arrays (`arrays`)** | C raw ptr (unchecked `-O2`) | **44 ms** (47 ms) | 16 KB | **14 KB** |
| | C checked (slice struct `-O2`) | **45 ms** (46 ms) | 16 KB | **14 KB** |
| | Rust (safe `Vec` `-O`) | **45 ms** (46 ms) | 4,389 KB | **331 KB** |
| | Archx (safe `[T]` `-O2`) | **44 ms** (46 ms) | 16 KB | **14 KB** |

By analyzing LLVM's pass pipeline directly (range-guarded loop versioning, monotonic strided `while` versioning, `2^47` allocation invariants, direct SSA for immutable arrays, `internal` linkage, and `align 16` allocators), Archx matches **even raw unchecked C (`44 ms`)** while remaining 100% bounds- and overflow-safe in a **14 KB** stripped binary. See [`benchmarks/README.md`](benchmarks/README.md) and [`docs/OPTIMIZATION.md`](docs/OPTIMIZATION.md) for the IR breakdown.

## Architecture

```
.archx.lang source
    │
    ▼
lexer (indentation-aware)
    │
    ▼
parser → AST
    │
    ▼
type checks + codegen → LLVM IR (text)
    │
    ▼
clang -O2 → native executable
```

The frontend is written in Rust with **zero external crates**. LLVM IR is emitted as text, so you can inspect it with `--emit-ir`, and clang handles optimization and code generation.

## Development

```sh
cargo test
cargo run -- examples/hello.archx.lang --emit-ir
```

### CI

GitHub Actions builds and tests on every push, and saves its logs and generated IR in `ci/logs/` and `ci/out/`. The optimized IR (`*.opt.ll`) is saved too, so you can see what `-O2` does to the code, and the C/Rust/Archx benchmark table is saved to `ci/out/benchmarks.txt`. To force a run, touch `ci/trigger` and push.

## Roadmap

- [x] Lexer with indentation, comments, single/double-quoted strings
- [x] Parser for functions, `let`, `return`, arithmetic, calls
- [x] `if` / `else`, comparisons, short-circuit `and` / `or` / `not`
- [x] LLVM IR codegen + clang linking
- [x] `while` / `for` loops, `break` / `continue`, assignment
- [x] Benchmarks against C and Rust
- [x] Arrays, indexing, bounds-check elision, `elif`, compound assignment
- [ ] Strided `for i in a..b step k` loops & `for x in arr` iteration
- [ ] Structs and methods
- [ ] Generics (monomorphized)
- [ ] Full ownership / RAII & scoped arenas
- [ ] String interpolation
- [ ] Modules and a standard library

## License

MIT
