# Benchmarks

Three suites, three languages, one optimizer (`LLVM`). Every benchmark compiles at
opt-level 2 (`clang -O2`, `rustc -O`, and `archx` → `clang -O2`), verifies that
every implementation prints the **exact same stdout** via `cmp`, and reports the
best of N runs (with the mean in parentheses) plus raw and stripped binary sizes.

## The three suites

### 1. Scalar loops (`primes.c`, `primes.rs`, `primes.archx.lang`)

| # | Workload | What it exercises | Expected output |
|---|----------|-------------------|-----------------|
| 1 | `sum_squares(20_000_000)` — `(total + i*i) % 1_000_007` | tight scalar loop: checked multiply/add (`nsw` elided), constant `srem` | `75517` |
| 2 | `count_primes(400_000)` — trial division | nested loop, data-dependent branch, early `break` | `33860` |

### 2. Array loops & bounds checking (`arrays_raw.c`, `arrays_checked.c`, `arrays.rs`, `arrays.archx.lang`)

| # | Workload | What it exercises | Expected output |
|---|----------|-------------------|-----------------|
| 1 | `vec_kernel(1_000_000, 60)` — 60M `dst[i] = a[i]*3 + b[i] + r` | heap allocation, range-guarded bounds-check elision, SIMD auto-vectorization | `57243166` |
| 2 | `sieve_count(5_000_000)` — Sieve of Eratosthenes | 5 MB `[bool]` byte buffer, `memset`, monotonic strided `while` indexing | `348513` |

### 3. Structs (SoA vs AoS), Regions & Prefix-SSO Strings (`composite.c`, `composite.rs`, `composite.archx.lang`)

| # | Workload | What it exercises | Expected output |
|---|----------|-------------------|-----------------|
| 1 | `particle_sim(100_000, 120)` — 6-field `Body` (`48 B`) full + `step 8` partial update + `foreach` reduction | transparent AoS-to-SoA planarization vs C/Rust `48 B` AoS `struct Body`, strided `step 8`, `for b in bodies:` | `14248875` |
| 2 | `arena_and_strings(40_000)` — variable-length `[0; sz]` scratch buffer + `9 B` short & `26 B` long string concat/equality | 64 KB `region:` slab reuse vs `malloc`/`free`, 16 B German/Umbra prefix-SSO `str` vs `malloc`/`strcmp` & Rust `String` | `421461999` |

## Running it

```sh
bash benchmarks/run.sh          # best of 5 runs
bash benchmarks/run.sh 7        # best of 7 (used in CI)
```

Results go to stdout and to `ci/out/benchmarks.txt`, alongside the optimized
LLVM IR dumps (`ci/out/bench_arrays.opt.ll`, `ci/out/bench_arrays_c_raw.opt.ll`,
`ci/out/bench_composite.opt.ll`, and `ci/out/bench_composite_c.opt.ll`).

## Latest CI measurement (`ci/out/benchmarks.txt`)

Measured on GitHub Actions (`x86_64-pc-linux-gnu`, `clang 21.1.8`, `rustc 1.100.0`):

### Suite 1 — Scalar loops (`primes`)

| Language | Build | Best of 7 (mean) | Binary (raw) | Binary (stripped) |
|----------|-------|-----------------:|-------------:|------------------:|
| C | `clang -O2` | **134 ms** (134 ms) | 16 KB | **14 KB** |
| Rust | `rustc -O` | **134 ms** (134 ms) | 4,388 KB | **330 KB** |
| Archx | `archx -O2` | **134 ms** (134 ms) | 16 KB | **14 KB** |

### Suite 2 — Array loops & bounds checking (`arrays`)

| Implementation | Safety | Best of 7 (mean) | Binary (raw) | Binary (stripped) |
|----------------|--------|:----------------:|-------------:|------------------:|
| C raw ptr (`clang -O2`) | unchecked (UB on OOB/overflow) | **62 ms** (63 ms) | 16 KB | **14 KB** |
| C checked (`clang -O2`) | slice struct | **58 ms** (60 ms) | 16 KB | **14 KB** |
| Rust (`rustc -O`) | safe `Vec<T>` | **64 ms** (72 ms) | 4,389 KB | **331 KB** |
| Archx (`archx -O2`) | safe `[T]` (0 UB) | **63 ms** (64 ms) | 16 KB | **14 KB** |

### Suite 3 — Structs, Regions & Prefix-SSO Strings (`composite`)

| Implementation | Memory & String Model | Best of 7 (mean) | Binary (raw) | Binary (stripped) |
|----------------|-----------------------|:----------------:|-------------:|------------------:|
| C (`clang -O2`) | 48B AoS `struct Body` + `calloc`/`malloc`/`strcmp` | **21 ms** (21 ms) | 16 KB | **14 KB** |
| Rust (`rustc -O`) | `Vec<Body>` + `Vec<i64>` + `String` | **23 ms** (23 ms) | 4,390 KB | **332 KB** |
| **Archx (`archx -O2`)** | **Transparent SoA + 64 KB `region:` + 16 B prefix-SSO `str`** | **18 ms** (18 ms) | 16 KB | **14 KB** |

## Why Archx beats C and Rust on Suite 3 (`ci/out/bench_composite.opt.ll` vs `ci/out/bench_composite_c.opt.ll`)

1. **100% cache-line utilization via transparent AoS-to-SoA (`vector.body42`)**:
   C's `struct Body` (`48 B`) loads `z` and `vz` on every cache line even in the
   timestep loop that only updates `x, y, vx, vy`, forcing `48 B`-strided loads
   and `shufflevector` (`blendpd`) blends. Archx lowers `let bodies = [Body(...); n]`
   into 6 separate `align 16` planes and unrolls 4-wide (`<2 x i64>`) touching
   only the active planes.
2. **Single-slab 64 KB `region:` reuse across 40,000 rounds (`fast.i.i`)**:
   `@archx_region_rewind_root` rewinds `cur` to `head + 16` on each iteration and
   LLVM promotes `cur`/`end` into loop-carried `phi` registers: `@malloc(65552)`
   executes **once** on round 0, and rounds `1..39,999` allocate both the scratch
   slice and 26-byte string in 2 pointer arithmetic instructions (`0` `malloc`/`free`
   calls vs C's 240,000 allocator calls).
3. **Register-folded 16 B prefix-SSO strings (`div.ok.13.i`)**:
   `"id_" + s_rhs` (`9 B <= 12 B`) and `s1 == "id_alpha0"` inline and fold into
   pure register bitops and `icmp eq` with zero allocations and zero `drop` instructions.
