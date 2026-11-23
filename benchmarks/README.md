<!-- Four-suite C vs Rust vs Archx benchmark harness documentation and latest CI results. -->

# Benchmarks (`C` vs `Rust` vs `Archx`)

Four suites, three languages, one optimizer (`LLVM`). Every benchmark compiles at opt-level 2 (`clang -O2`, `rustc -O`, and `archx` → `clang -O2`), verifies byte-identical stdout via `cmp -s`, and reports best-of-N latency (mean in parentheses) plus raw and stripped binary sizes.

## The four suites

1. **Scalar loops (`primes.c`, `primes.rs`, `primes.archx.lang`)** — `sum_squares(20_000_000)` + trial-division `count_primes(400_000)` (`75517`, `33860`).
2. **Array loops & bounds checking (`arrays_raw.c`, `arrays_checked.c`, `arrays.rs`, `arrays.archx.lang`)** — 60 rounds of 1M-element vector math + Sieve below 5M (`57243166`, `348513`).
3. **Structs (SoA vs AoS), Regions & Prefix-SSO Strings (`composite.c`, `composite.rs`, `composite.archx.lang`)** — 100,000 6-field `Body` structs (`48 B`) × 120 timesteps + 40,000 rounds of arena scratch buffers and SSO/heap strings (`14248875`, `421461999`).
4. **Pythonic Floating-Point N-Body & OOP Methods (`nbody_float.c`, `nbody_float.rs`, `nbody_float.archx.lang`)** — 100,000 7-field `f64` `Body` objects (`56 B`) × 60 central-field integration steps + `.kinetic()` method reduction + 64-body all-pairs gravitational N-body × 2,000 steps (`11232960`, `3595406`). Written in **100% 1:1 Pythonic Archx syntax** (`class Body:`, `def kinetic(self):`, `bodies = [Body(...)] * n`, `for i in range(n):`).

## Running

```sh
bash benchmarks/run.sh       # best of 5 runs
bash benchmarks/run.sh 7     # best of 7 runs (used in CI)
```

## Latest CI Measurement (`ci/out/benchmarks.txt`, `clang 21.1.8` / `rustc 1.100.0`)

| Suite | Implementation | Best of 7 (mean) | Raw KB | Stripped KB |
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

## Why Pythonic Archx Beats Both `-O2` C and `-O` Rust on Suites 3 & 4

- **Suite 4 (`ci/out/bench_nbody_float.opt.ll`)**: `[Body(0.0, ...)] * n` transparently lowers the 7-field `56 B` class into 7 `align 16` `double*` SoA planes, allowing LLVM (`vector.body83`) to issue aligned `<2 x double>` SIMD loads/stores across `x, y, z, vx, vy, vz, mass` and inline `bodies[i].kinetic()` with zero bounds checks, whereas C (`Body*`) and Rust (`Vec<Body>`) stride across 56-byte AoS records.
- **Suite 3 (`ci/out/bench_composite.opt.ll`)**: Transparent SoA planes + single-slab 64 KB `region:` cursor rewind + register-folded 16B prefix-SSO strings eliminate cache-line waste and 240,000 allocator calls.
