<!-- Six-suite Python 3 vs C vs Rust vs Archx benchmark harness documentation and latest CI results. -->

# Benchmarks (`Python 3` vs `C` vs `Rust` vs `Archx`)

Six suites across **Python 3 (`python3`)**, **Clang C (`clang -O2`)**, **Rust (`rustc -O`)**, **Archx 1:1 Pythonic (`archx -O2`)**, and **Archx Speed (`archx -O2`)**. Every benchmark verifies byte-identical stdout via `cmp -s` before timing and reports best-of-N latency (mean in parentheses), speedup vs `python3`, and raw/stripped binary sizes.

## The six suites

1. **Scalar loops (`primes.{py,c,rs,archx.lang}`)** — `sum_squares(20_000_000)` + trial-division `count_primes(400_000)` (`75517`, `33860`).
2. **Array loops & bounds checking (`arrays.py`, `arrays_raw.c`, `arrays_checked.c`, `arrays.rs`, `arrays.archx.lang`)** — 60 rounds of 1M-element vector math + Sieve below 5M (`57243166`, `348513`).
3. **Structs (SoA vs AoS), Regions & Prefix-SSO Strings (`composite.{py,c,rs,archx.lang}`)** — 100,000 6-field `Body` structs (`48 B`) × 120 timesteps + 40,000 rounds of arena scratch buffers and SSO/heap strings (`14248875`, `421461999`).
4. **Pythonic Floating-Point N-Body & OOP Methods (`nbody_float.{py,c,rs,archx.lang}`)** — 100,000 7-field `f64` `Body` objects (`56 B`) × 60 central-field integration steps + `.kinetic()` method reduction + 64-body all-pairs gravitational N-body × 2,000 steps (`11232960`, `3595406`). Written in **100% 1:1 Pythonic Archx syntax**.
5. **Planar SIMD Dict & Smart Adaptive Typing (`dict_bench.{py,c,rs,archx.lang}`, `dict_dynamic.archx.lang`)** — 120 rounds × 1,024-key `str -> i64` frequency counts (`8,192` single-probe updates + `2,048` lookups + `.items()` reductions) + 32,768-key `i64 -> i64` hash table with `8,192` `.pop()` tombstones, `8,192` new inserts, and 40 `.items()` scans (`12163680`, `27629691796536`).
6. **5-Way Full-Feature Comparison Tour (`examples/comparison/full_tour.*`)** — Exercises Milestones 1–8 end-to-end (`Body` N-body physics, Planar SIMD `dict`/`set`, string & list slicing, adaptive variable rebinding, multiple-return tuples, `T | None` narrowing, and 200,000-event `match`/`case` dispatch with `|` & `if` guards). Enforces `cmp -s full_tour.py full_tour_pythonic.archx.lang` so `full_tour_pythonic.archx.lang` is guaranteed **byte-for-byte identical** to `full_tour.py`.

## Running

```sh
bash benchmarks/run.sh         # best of 5 compiled runs, best of 3 Python 3 runs
bash benchmarks/run.sh 7 3     # best of 7 compiled runs, best of 3 Python 3 runs (used in CI)
```

## Latest CI Measurement (`ci/out/benchmarks.txt`, `Python 3.14.4` / `clang 21.1.8` / `rustc 1.100.0`)

| Suite | Implementation | Best ms (mean) | vs Python 3 | Raw KB | Stripped KB |
|---|---|---:|---:|---:|---:|
| **1. Scalar (`primes`)** | Python 3 (`python3`) | 1,420 ms (1,421) | 1.0× | n/a | n/a |
| | C (`clang -O2`) | **97 ms** (97) | **14.6×** | 16 KB | **14 KB** |
| | Rust (`rustc -O`) | **97 ms** (97) | **14.6×** | 4,388 KB | 330 KB |
| | **Archx (`archx -O2`)** | **97 ms** (97) | **14.6×** | 16 KB | **14 KB** |
| **2. Arrays (`arrays`)** | Python 3 (`python3`) | 2,475 ms (2,488) | 1.0× | n/a | n/a |
| | C raw ptr (unchecked `-O2`) | **75 ms** (76) | **33.0×** | 16 KB | **14 KB** |
| | C checked (slice struct `-O2`) | **75 ms** (75) | **33.0×** | 16 KB | **14 KB** |
| | Rust (safe `Vec` `-O`) | **75 ms** (75) | **33.0×** | 4,389 KB | 331 KB |
| | **Archx (safe `list[T]` `-O2`)** | **76 ms** (76) | **32.6×** | 16 KB | **14 KB** |
| **3. Composite (`composite`)** | Python 3 (`python3`) | 648 ms (651) | 1.0× | n/a | n/a |
| | C (`AoS + malloc/strcmp -O2`) | 32 ms (32) | 20.2× | 16 KB | **14 KB** |
| | Rust (`Vec<Body> + String -O`) | 34 ms (34) | 19.1× | 4,390 KB | 332 KB |
| | **Archx (`SoA + region + SSO -O2`)** | **25 ms** (25) | **25.9×** | 16 KB | **14 KB** |
| **4. Pythonic Float N-Body (`nbody_float`)** | Python 3 (`python3`) | 2,538 ms (2,570) | 1.0× | n/a | n/a |
| | C (`AoS Body* -O2 -lm`) | 41 ms (41) | 61.9× | 16 KB | **14 KB** |
| | Rust (`Vec<Body> -O`) | 41 ms (41) | 61.9× | 4,390 KB | 332 KB |
| | **Archx (`Pythonic class + SoA -O2`)** | **36 ms** (36) | **70.5×** | 16 KB | **14 KB** |
| **5. Planar SIMD Dict (`dict_bench`)** | Python 3 (built-in C `dict`) | 172 ms (173) | 1.0× | n/a | n/a |
| | C (`AoS open-addressing -O2`) | 51 ms (51) | 3.4× | 16 KB | **14 KB** |
| | Rust (`std::HashMap` `-O`) | 37 ms (37) | 4.6× | 4,424 KB | 354 KB |
| | **Archx Static (`Planar SIMD + region`)** | **36 ms** (36) | **4.8×** | 24 KB | **22 KB** |
| | Archx Dynamic (`%ArchxAny dict[any,any]`) | 58 ms (58) | 3.0× | 24 KB | **22 KB** |
| **6. 5-Way Full-Feature Tour (`full_tour`)** | Python 3 (`full_tour.py`) | 298 ms (299) | 1.0× | n/a | n/a |
| | **Archx Pythonic (`1:1 == full_tour.py`)** | **13 ms** (13) | **22.9×** | 36 KB | **34 KB** |
| | **Archx Speed (`SoA + region + enum`)** | **12 ms** (12) | **24.8×** | 36 KB | **34 KB** |
| | Rust (`full_tour.rs` `rustc -O`) | **13 ms** (13) | **22.9×** | 4,430 KB | 359 KB |
| | Clang C (`full_tour.c -O2 -lm`) | **9 ms** (9) | **33.1×** | 16 KB | **14 KB** |

## Why Archx Delivers `14.6×`–`70.5×` Over Python 3 and Beats C & Rust on Data-Intensive Suites

- **Suite 6 (`ci/out/bench_full_tour.opt.ll`)**: Unchanged Python 3.10+ source (`full_tour_pythonic.archx.lang`) compiles its `Body` class, `dict[str, int]`, `set[int]`, `(int, int, int)` tuple returns, `int | None` narrowing, and 200,000-event `match`/`case` dispatch directly into unboxed LLVM SSA registers and Planar SIMD tables (`13 ms`, tying `rustc -O` `13 ms` and `22.9×` faster than `Python 3.14.4`), while `full_tour_speed.archx.lang` adds `[Body(...); n]` SoA planarization, `with region:` arena reuse, and stack `enum Event` (`12 ms`, `24.8×` faster than Python 3).
- **Suite 5 (`ci/out/bench_dict.opt.ll`)**: 16-wide `<16 x i8>` SIMD SwissTable probing + single-probe `upsert` + inline 16B Prefix-SSO string keys + dense planar `0..len` `.items()` arrays beat Python's C-implemented `dict` by **4.8×** (`36 ms` vs `172 ms`), `-O2` C by **29%** (`36 ms` vs `51 ms`), and Rust `std::HashMap` (`36 ms` vs `37 ms`).
- **Suites 3 & 4 (`ci/out/bench_composite.opt.ll`, `ci/out/bench_nbody_float.opt.ll`)**: Transparent `align 16` per-field SoA SIMD planes + 64 KB `region:` slab cursor rewind + 16B prefix-SSO strings beat Python 3 by **25.9×** and **70.5×** and outperform AoS C and Rust by **12%–26%**.
