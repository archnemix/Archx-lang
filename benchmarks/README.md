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
bash benchmarks/run.sh 20       # best of 20, less noise
```

Results go to stdout and to `ci/out/benchmarks.txt`, committed back by CI on
every push.

## Latest CI measurement (`ci/out/benchmarks.txt`)

Measured on GitHub Actions (`x86_64-pc-linux-gnu`, `clang 21.1.8`, `rustc 1.100.0`):

### Suite 1 — Scalar loops (`primes`)

| Language | Build | Best of 5 (mean) | Binary (raw) | Binary (stripped) |
|----------|-------|-----------------:|-------------:|------------------:|
| C | `clang -O2` | **124 ms** (124 ms) | 16 KB | **14 KB** |
| Rust | `rustc -O` | **124 ms** (124 ms) | 4,388 KB | **330 KB** |
| Archx | `archx -O2` | **124 ms** (126 ms) | 16 KB | **14 KB** |

### Suite 2 — Array loops & bounds checking (`arrays`)

| Implementation | Safety | Best of 5 (mean) | Binary (raw) | Binary (stripped) |
|----------------|--------|:----------------:|-------------:|------------------:|
| C raw ptr (`clang -O2`) | unchecked | **86 ms** (87 ms) | 16 KB | **14 KB** |
| C checked (`clang -O2`) | slice struct | **86 ms** (86 ms) | 16 KB | **14 KB** |
| Rust (`rustc -O`) | safe `Vec<T>` | **89 ms** (89 ms) | 4,389 KB | **331 KB** |
| Archx (`archx -O2`) | safe `[T]` | **89 ms** (89 ms) | 16 KB | **14 KB** |

## How to read the numbers (and why `89 ms` vs `86 ms` happens)

1. **Scalar loops (`124 ms / 124 ms / 124 ms`)**: C already has zero runtime
   checks on scalar registers, so all three lower to identical SSA loops.
2. **Counted `for` array loops (`vec_step`, `dot`)**: Archx's compile-time
   bounds-check prover eliminates `dst[i]`, `a[i]`, and `b[i]` checks in
   `for i in 0..n:` over `[0; n]` arrays (and LLVM hoists cross-slice checks
   like `b[i]` in `dot` to a single preheader branch before entering SIMD
   `vector.body` — see `ci/out/arrays.opt.ll`).
3. **Strided `while` array loops (`while j < limit: is_prime[j] = false; j += p`)**:
   Both **Rust (`89 ms`)** and **Archx (`89 ms`)** define integer `j += p` with
   two's-complement wrap rather than C's signed-overflow undefined behavior.
   Because `j + p` could theoretically wrap negative if `limit` were near
   `i64::MAX` while still satisfying signed `j < limit`, LLVM keeps **one**
   `icmp ult i64 %j, %limit` instruction inside `while.body` in both Rust and
   Archx — accounting for the entire ~3 ms difference vs C (`86 ms`). Adding
   first-class strided ranges (`for j in p*p..limit step p:`) will let Archx
   prove `0 <= j < limit` there too without giving up defined arithmetic.
