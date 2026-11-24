<!-- Five-suite C vs Rust vs Archx benchmark harness documentation and latest CI results. -->

# Benchmarks (`C` vs `Rust` vs `Archx`)

Five suites, three languages, one optimizer (`LLVM`). Every benchmark compiles at opt-level 2 (`clang -O2`, `rustc -O`, and `archx` → `clang -O2`), verifies byte-identical stdout via `cmp -s`, and reports best-of-N latency (mean in parentheses) plus raw and stripped binary sizes.

## The five suites

1. **Scalar loops (`primes.c`, `primes.rs`, `primes.archx.lang`)** — `sum_squares(20_000_000)` + trial-division `count_primes(400_000)` (`75517`, `33860`).
2. **Array loops & bounds checking (`arrays_raw.c`, `arrays_checked.c`, `arrays.rs`, `arrays.archx.lang`)** — 60 rounds of 1M-element vector math + Sieve below 5M (`57243166`, `348513`).
3. **Structs (SoA vs AoS), Regions & Prefix-SSO Strings (`composite.c`, `composite.rs`, `composite.archx.lang`)** — 100,000 6-field `Body` structs (`48 B`) × 120 timesteps + 40,000 rounds of arena scratch buffers and SSO/heap strings (`14248875`, `421461999`).
4. **Pythonic Floating-Point N-Body & OOP Methods (`nbody_float.c`, `nbody_float.rs`, `nbody_float.archx.lang`)** — 100,000 7-field `f64` `Body` objects (`56 B`) × 60 central-field integration steps + `.kinetic()` method reduction + 64-body all-pairs gravitational N-body × 2,000 steps (`11232960`, `3595406`). Written in **100% 1:1 Pythonic Archx syntax**.
5. **Planar SIMD Dict & Smart Adaptive Typing (`dict_bench.c`, `dict_bench.rs`, `dict_bench.archx.lang`, `dict_dynamic.archx.lang`)** — 120 rounds × 1,024-key `str -> i64` frequency counts (`8,192` single-probe updates + `2,048` lookups + `.items()` reductions) + 32,768-key `i64 -> i64` hash table with `8,192` `.pop()` tombstones, `8,192` new inserts, and 40 `.items()` scans (`12163680`, `27629691796536`). Compares `-O2` C open-addressing, Rust `std::collections::HashMap` (`hashbrown` SwissTable), Archx Tier-1 Static (`Planar <16 x i8> SIMD + Prefix-SSO + region:`), and Archx Tier-2 Dynamic (`%ArchxAny` `dict[any, any]`).

## Running

```sh
bash benchmarks/run.sh       # best of 5 runs
bash benchmarks/run.sh 7     # best of 7 runs (used in CI)
```

## Latest CI Measurement (`ci/out/benchmarks.txt`, `clang 21.1.8` / `rustc 1.100.0`)

| Suite | Implementation | Best of 7 (mean) | Raw KB | Stripped KB |
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
| | Rust (`std::HashMap` `-O`) | **52 ms** (52 ms) | 4,424 KB | **354 KB** |
| | **Archx Static (`Planar SIMD + region -O2`)** | **48 ms** (48 ms) | 24 KB | **22 KB** |
| | Archx Dynamic (`%ArchxAny dict[any,any] -O2`) | **87 ms** (87 ms) | 24 KB | **22 KB** |

## Why Pythonic Archx Beats Both `-O2` C and `-O` Rust on Suites 2–5

- **Suite 5 (`ci/out/bench_dict.opt.ll`)**: Archx combines **16-wide `<16 x i8>` SIMD SwissTable control-byte probing** (recording the first available slot during lookup so `upsert` never double-probes or double-hashes), **inline 16-byte Prefix-SSO string keys** (hashing and comparing `<= 12`-byte keys like `"tok_42"` purely in CPU registers with zero pointer dereferences and rejecting mismatched long keys in one 64-bit `(prefix4 << 32) | len` compare), **dense planar insertion-ordered `keys[]` and `vals[]` arrays** (turning `for k, v in tab.items():` into a branchless contiguous `0..len` scan with zero empty-bucket skipping and backward-shift `.pop()` compaction), and **`with region:` 64 KB slab reuse**.
- **Suite 4 (`ci/out/bench_nbody_float.opt.ll`)**: `[Body(0.0, ...)] * n` transparently lowers the 7-field `56 B` class into 7 `align 16` `double*` SoA planes, allowing LLVM (`vector.body83`) to issue aligned `<2 x double>` SIMD loads/stores and inline `bodies[i].kinetic()` with zero bounds checks.
- **Suite 3 (`ci/out/bench_composite.opt.ll`)**: Transparent SoA planes + single-slab 64 KB `region:` cursor rewind + register-folded 16B prefix-SSO strings eliminate cache-line waste and 240,000 allocator calls.
