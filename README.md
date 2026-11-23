# Archx

**Archx** is a small programming language with one goal: **readable like Python, fast like C**.

Archx compiles to **LLVM IR**, so it uses the same optimizer and backends as C, Rust, Swift, Zig, and Julia. One frontend, every architecture LLVM supports: x86-64, ARM64, RISC-V, WASM, and more.

> Status: milestone 5 — value `struct`s with **transparent AoS-to-SoA planarization** for `[Struct]` arrays, scoped `region:` bump arenas with compile-time escape checking + `return` heap promotion, 16-byte German/Umbra **prefix-SSO `string`s** (`str` / `string`, `+`, `==`, `!=`, `len`, embedded-NUL safe), `for x in arr:` foreach iteration, strided `for i in a..b step k:` loops, hybrid RAII zero-leak ownership, checked integer arithmetic (`sadd`/`ssub`/`smul.with.overflow`, safe `/` & `%`), arrays (`[T]`, `[a, b]`, `[val; n]`, `push`, `pop`), `if`/`elif`/`else`, `while`, `break`/`continue`, functions, and `print`.
>
> Verified leak- and UB-free under **AddressSanitizer + LeakSanitizer** in CI, and benchmarked head-to-head against C and Rust across 3 suites — see [Benchmarks](#benchmarks).

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
archx examples/hello.archx.lang -o build/app # choose the output path
```

## Syntax

```archx
struct Body:
    x: int
    y: int
    vx: int
    vy: int

func step_world(n: int) -> int:
    # Local [Body] transparently planarizes into 4 contiguous 16B-aligned SoA planes
    let bodies = [Body(x: 1, y: 2, vx: 3, vy: -1); n]
    for i in 0..len(bodies):
        bodies[i].x += bodies[i].vx
        bodies[i].y += bodies[i].vy

    let sum = 0
    for b in bodies:
        sum += b.x + b.y
    return sum

func build_tag(id: str) -> str:
    region:
        let scratch = [0; 64]
        for k in 0..len(scratch) step 4:
            scratch[k] = k * 3
        let msg = "node_" + id
        if msg == "node_alpha":
            return msg + "_primary"   # promoted cleanly out of region on return
        return msg

func main():
    print(step_world(1000))
    print(build_tag("alpha"))
```

Language summary:

- Blocks are indentation-based (4 spaces per level; tabs before code are rejected with a diagnostic).
- No semicolons at the end of statements (`;` is only used in `[value; count]` repeat arrays).
- `#` starts a comment.
- Scalar types:
  - `int` — 64-bit signed integer with **checked overflow** (`+`, `-`, `*`, unary `-`, `/`, `%` panic cleanly instead of C signed-overflow UB; proven non-overflowing loop math compiles with `nsw`/`nuw`).
  - `bool` — `true` / `false` (`and`, `or`, `not` with short-circuiting; no implicit truthiness).
  - `str` (or `string`) — 16-byte immutable UTF-8 **German/Umbra prefix-SSO** value (`<= 12` bytes stored inline in two 64-bit registers with zero heap work; `> 12` bytes store a 4-byte inline prefix + tagged static/heap/region pointer for O(1) prefix-rejected equality; supports `+`, `==`, `!=`, `len(s)`, and embedded NUL bytes).
- Value `struct`s:
  - Declared with `struct Name:` and indented `field: Type` lines (supporting nested structs, `[T]`, and `str` fields; cyclic definitions are rejected cleanly).
  - Constructed with `Name(field: expr, ...)`, accessed/mutated via `s.field` and `arr[i].field += expr`, compared with `==` / `!=`, and printed with `print(s)`.
  - **Transparent AoS-to-SoA planarization**: local fixed-length `[Struct]` arrays of scalar structs automatically lower to separate 16-byte-aligned per-field planes so loops touching a subset of fields stream at 100% cache-line utilization and auto-vectorize without gather/scatter instructions.
- Scoped `region:` arenas:
  - `region:` activates a 64 KB bump-allocated slab arena (O(1) pointer bump, nested watermark save/restore, and root-slab cursor rewind across loop iterations).
  - Compile-time **escape analysis** rejects assigning region-allocated arrays/structs into outer variables (`error: cannot assign region-allocated value to outer variable '...'`), while `return expr` from inside `region:` automatically deep-promotes any region-backed buffers to heap ownership before rewinding the region.
- Arrays (`[T]`):
  - Literals `[1, 2, 3]`, empty `let xs: [int] = []`, or sized `[val; count]` (deep-cloning owning elements when needed).
  - Builtins: `len(arr)`, `push(arr, val)`, `pop(arr)`, `print(arr)`.
  - Bounds-safe indexing `arr[i]` and `arr[i] = v`, with compile-time bounds-check elision on proven loops.
- Loops:
  - `for i in a..b:` (half-open `[a, b)`, bounds evaluated once).
  - `for i in a..b step k:` (strided range with compile-time step > 0 verification and bounds elision).
  - `for x in arr:` (bounds-check-free element iteration over arrays and SoA planes).
  - `while cond:`, `break`, and `continue` (running deterministic RAII drops and region unwinds across intermediate scopes).
- Files use `.archx.lang`, `.archx.lg`, `.ax.lang`, or `.ax.lg` (CLI rejects unknown extensions and refuses to clobber source files with `-o`).

## Why `main`?

It is not about speed. Python is interpreted, so the interpreter can start executing top-level statements anywhere. A compiled binary is raw machine code: the operating system loader needs **one exact entry address** to jump to. That address is `main`. It is a linking convention, not a performance feature.

## Memory & Hybrid Zero-Leak Ownership

Archx runs with **zero garbage collector** and **zero lifetime annotations**:

- **Immutable bindings (`int`, `bool`, `str`, `struct`, `[T]`)** — live directly in **LLVM SSA values** (`VarStorage::Imm`) with zero `alloca` stack traffic.
- **16-byte German/Umbra `str`** — `{ len: u32 | prefix4: [u8; 4], payload_or_tagged_ptr: u64 }` fits in two CPU registers (`16 B` vs Rust `String`'s `24 B`). Strings up to 12 bytes never touch an allocator; longer strings tag bit `0..1` as `STATIC (00)`, `HEAP (01)`, or `REGION (10)` so `drop` frees only heap-owned buffers.
- **Deterministic recursive RAII** — owning variables (`[T]`, `str`, nested `[Struct]`, `[[int]]`), overwritten assignments, and unclaimed statement temporaries free deterministically on scope exit, `return`, `break`, and `continue`.
- **Scoped `region:` bump arenas** — temporary batch allocations inside loops bump a single pointer in a reused 64 KB slab with **zero per-iteration `malloc`/`free` calls**.
- **ASan + LSan verified in CI** — every push compiles and runs `arrays`, `structs_regions`, and `composite` under `clang -fsanitize=address,leak` (`0` bytes leaked, `0` invalid accesses in `ci/logs/asan_lsan.log`).

See [`docs/FUNDAMENTALS.md`](docs/FUNDAMENTALS.md) for the language design fundamentals and [`docs/OPTIMIZATION.md`](docs/OPTIMIZATION.md) for the LLVM IR architecture and `-O2` proof points.

## Benchmarks

`benchmarks/` compares **C, Rust, and Archx** across **three suites** (compiled at `-O2` / `rustc -O`, timed best-of-7 in CI, with stdout verified byte-for-byte via `cmp`):

1. **Scalar loops (`benchmarks/primes.*`)** — 20M iterations of `(total + i*i) % 1_000_007` + trial-division prime counting below 400,000.
2. **Array loops & bounds checking (`benchmarks/arrays*`)** — 60 rounds of 1,000,000-element vector math (`dst[i] = a[i]*3 + b[i] + r`) + Sieve of Eratosthenes below 5,000,000.
3. **Structs (SoA vs AoS), Regions & Prefix-SSO Strings (`benchmarks/composite.*`)** — 100,000 6-field `Body` structs (48 B) × 120 timesteps (full + `step 8` partial-field update + `foreach` reduction) + 40,000 rounds of variable-length scratch buffers and short/long string concatenation & equality.

```sh
bash benchmarks/run.sh
```

Latest GitHub Actions run (`ci/out/benchmarks.txt`, best of 7 on `clang 21.1.8` / `rustc 1.100.0`):

| Suite | Implementation | Best of 7 (mean) | Binary (raw) | Binary (stripped) |
|---|---|---:|---:|---:|
| **1. Scalar (`primes`)** | C (`clang -O2`) | **134 ms** (134 ms) | 16 KB | **14 KB** |
| | Rust (`rustc -O`) | **134 ms** (134 ms) | 4,388 KB | **330 KB** |
| | Archx (`archx -O2`) | **134 ms** (134 ms) | 16 KB | **14 KB** |
| **2. Arrays (`arrays`)** | C raw ptr (unchecked `-O2`) | **62 ms** (63 ms) | 16 KB | **14 KB** |
| | C checked (slice struct `-O2`) | **58 ms** (60 ms) | 16 KB | **14 KB** |
| | Rust (safe `Vec` `-O`) | **64 ms** (72 ms) | 4,389 KB | **331 KB** |
| | Archx (safe `[T]` `-O2`) | **63 ms** (64 ms) | 16 KB | **14 KB** |
| **3. Composite (`composite`)** | C (`AoS + malloc/strcmp -O2`) | **21 ms** (21 ms) | 16 KB | **14 KB** |
| | Rust (`Vec<Body> + String -O`) | **23 ms** (23 ms) | 4,390 KB | **332 KB** |
| | **Archx (`SoA + region + SSO -O2`)** | **18 ms** (18 ms) | 16 KB | **14 KB** |

On Suite 3 (`composite`), **Archx beats both C (`18 ms` vs `21 ms`, 14% faster) and Rust (`18 ms` vs `23 ms`, 22% faster)** while remaining 100% bounds-, overflow-, and memory-safe in a **14 KB** stripped binary (**23.7× smaller** than stripped Rust and **274× smaller** unstripped):

- **Transparent SoA vs C/Rust AoS**: C's `struct Body` strides by 48 bytes (wasting 33% of every cache line on untouched `z, vz` fields and emitting `shufflevector` blends), whereas Archx's 6 `align 16` planes stream `<2 x i64>` SIMD `add`/`sub` instructions at 100% cache-line utilization (`ci/out/bench_composite.opt.ll` vs `ci/out/bench_composite_c.opt.ll`).
- **64 KB `region:` slab reuse vs per-round `malloc`/`free`**: Archx allocates its 64 KB region slab **once** on round 0 and rewinds the bump cursor in registers for all 39,999 remaining rounds, vs C's 240,000 `calloc`/`malloc`/`free` calls.
- **16 B prefix-SSO strings**: `"id_" + s_rhs` (`9 B <= 12 B`) and `s1 == "id_alpha0"` constant-fold completely into CPU registers with zero allocations and zero `drop` instructions.

See [`benchmarks/README.md`](benchmarks/README.md) and [`docs/OPTIMIZATION.md`](docs/OPTIMIZATION.md) for the full `-O2` LLVM IR breakdown.

## Architecture

```
.archx.lang source
    │
    ▼
lexer (4-space indentation, contextual tokens, spans)
    │
    ▼
parser → AST (iterative unary + bounded nesting depth)
    │
    ▼
type/escape checks + LLVM-direct codegen → LLVM IR (text)
    │
    ▼
clang -O2 → native executable (14 KB stripped)
```

The frontend is written in Rust with **zero external crates**. LLVM IR is emitted as text (`--emit-ir`), and clang handles target optimization and native linking.

## Development

```sh
cargo test
cargo run -- examples/structs_regions.archx.lang --emit-ir
```

### CI

GitHub Actions builds and runs unit + CLI tests, compiles all examples, verifies **0 leaks / 0 invalid accesses** under AddressSanitizer + LeakSanitizer (`ci/logs/asan_lsan.log`), saves unoptimized & `-O2` LLVM IR (`ci/out/*.opt.ll`), and runs the 3-suite C/Rust/Archx benchmark (`ci/out/benchmarks.txt`).

## Roadmap

- [x] Lexer with indentation, comments, single/double-quoted strings, contextual keywords
- [x] Parser for functions, `let`, `return`, arithmetic, calls, bounded recursion
- [x] `if` / `elif` / `else`, comparisons, short-circuit `and` / `or` / `not`
- [x] `while`, `for i in a..b`, `for i in a..b step k`, `for x in arr`, `break` / `continue`
- [x] Checked overflow/division arithmetic & CLI hardening
- [x] Arrays, indexing, compile-time bounds-check elision
- [x] Value `struct`s + transparent AoS-to-SoA planarization
- [x] Scoped `region:` bump arenas + escape checker + return promotion
- [x] 16-byte German/Umbra prefix-SSO `str` (`+`, `==`, `!=`, `len`)
- [x] Deterministic recursive RAII ownership (ASan + LSan verified)
- [x] 3-suite benchmarks against C and Rust
- [ ] Methods and traits / interfaces
- [ ] Generics (monomorphized)
- [ ] String interpolation
- [ ] Modules and a standard library

## License

MIT
