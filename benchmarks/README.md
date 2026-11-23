# Benchmarks

Two suites, three languages, one optimizer (`LLVM`). Every benchmark compiles at
opt-level 2 (`clang -O2`, `rustc -O`, and `archx` → `clang -O2`), verifies that
every implementation prints the **exact same stdout**, and reports the best of N
runs (with the mean in parentheses) plus raw and stripped binary sizes.

## The two suites

### 1. Scalar loops (`primes.c`, `primes.rs`, `primes.archx.lang`)

| # | Workload | What it exercises | Expected output |
|---|----------|-------------------|-----------------|
| 1 | `sum_squares(20_000_000)` — `(total + i*i) % 1_000_007` | tight scalar loop: multiply, add, `srem` | `75517` |
| 2 | `count_primes(400_000)` — trial division | nested loop, data-dependent branch, early `break` | `33860` |

### 2. Array loops & bounds checking (`arrays_raw.c`, `arrays_checked.c`, `arrays.rs`, `arrays.archx.lang`)

| # | Workload | What it exercises | Expected output |
|---|----------|-------------------|-----------------|
| 1 | `vec_kernel(1_000_000, 60)` — 60M `dst[i] = a[i]*3 + b[i] + r` | heap allocation, bounds-check elision, SIMD auto-vectorization | `57243166` |
| 2 | `sieve_count(5_000_000)` — Sieve of Eratosthenes | 5 MB `[bool]` byte buffer, `memset`, strided `while` indexing | `348513` |

## Running it

```sh
bash benchmarks/run.sh          # best of 5 runs
bash benchmarks/run.sh 7        # best of 7 (used in CI)
```

Results go to stdout and to `ci/out/benchmarks.txt`, alongside the exact
optimized LLVM IR (`ci/out/bench_arrays.opt.ll` and `ci/out/bench_arrays_c_raw.opt.ll`).

## Latest CI measurement (`ci/out/benchmarks.txt`)

Measured on GitHub Actions (`x86_64-pc-linux-gnu`, `clang 21.1.8`, `rustc 1.100.0`):

### Suite 1 — Scalar loops (`primes`)

| Language | Build | Best of 7 (mean) | Binary (raw) | Binary (stripped) |
|----------|-------|-----------------:|-------------:|------------------:|
| C | `clang -O2` | **94 ms** (94 ms) | 16 KB | **14 KB** |
| Rust | `rustc -O` | **94 ms** (94 ms) | 4,388 KB | **330 KB** |
| Archx | `archx -O2` | **93 ms** (93 ms) | 16 KB | **14 KB** |

### Suite 2 — Array loops & bounds checking (`arrays`)

| Implementation | Safety | Best of 7 (mean) | Binary (raw) | Binary (stripped) |
|----------------|--------|:----------------:|-------------:|------------------:|
| C raw ptr (`clang -O2`) | unchecked (UB on OOB/overflow) | **44 ms** (47 ms) | 16 KB | **14 KB** |
| C checked (`clang -O2`) | slice struct | **45 ms** (46 ms) | 16 KB | **14 KB** |
| Rust (`rustc -O`) | safe `Vec<T>` | **45 ms** (46 ms) | 4,389 KB | **331 KB** |
| Archx (`archx -O2`) | safe `[T]` (0 UB) | **44 ms** (46 ms) | 16 KB | **14 KB** |

## Direct LLVM IR comparison (`ci/out/bench_arrays.opt.ll` vs `ci/out/bench_arrays_c_raw.opt.ll`)

Instead of relying on C's undefined behavior or stopping at per-element runtime
bounds checks, Archx emits IR tailored directly to LLVM's `-O2` pipeline:

1. **16-byte aligned SIMD vectorization (`vector.body`)**:
   `@calloc`/`@malloc` carry `noalias align 16` and every load/store carries
   explicit natural alignment (`align 8` / `align 1`), while multi-array `for`
   loops emit a preheader range guard (`end <= len`) so `LoopVectorize` gets a
   single-exit check-free loop — lowering `vec_step` to `<2 x i64>` unrolled
   `align 16` loads and stores.
2. **Zero-check strided `while` loops without UB (`while.fast.body`)**:
   Enforcing `0 <= len <= 2^47` at allocation plus a 1-time preheader check
   `(j >= 0) && (bound <= 2^47) && (1 <= step <= 2^47)` proves `j + step` can
   never wrap signed `i64`, compiling Sieve's 11.5M-iteration inner loop to the
   exact 5-instruction block (`phi`, `gep`, `store i8 0`, `add nuw nsw`,
   `icmp ult`, `br`) as raw unchecked C while still panicking cleanly on any
   invalid index.
3. **SIMD prime-count reduction (`vector.body9`)**:
   Archx's clean SSA boolean load (`icmp ne i8 ..., 0`) + branchless increment
   auto-vectorizes the 5,000,000-element prime count into `<2 x i64>` vector
   accumulators (`@llvm.vector.reduce.add.v2i64`).
