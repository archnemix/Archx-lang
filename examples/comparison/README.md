<!-- Overview and verified CI timings for `examples/comparison/`: 5-way Python 3 / Archx Pythonic / Archx Speed / C / Rust full-feature tour. -->

# 5-Way Full-Feature Comparison Showcase (`examples/comparison/`)

This folder provides **five side-by-side implementations** of the exact same end-to-end workload exercising every Archx milestone (`v0.1.0`–`v0.8.0`), verified in CI (`benchmarks/run.sh`) for byte-identical output and wall-clock runtime:

| # | File | Language / Mode | Best ms (CI) | vs Python 3 | Stripped KB | Highlights |
|---|---|---|---:|---:|---:|---|
| 1 | `full_tour.py` | **Python 3 (`python3` 3.14.4)** | 298 ms | 1.0× | n/a | Reference CPython 3.10+ implementation |
| 2 | `full_tour_pythonic.archx.lang` | **Archx (1:1 Pythonic)** | **13 ms** | **22.9×** | **34 KB** | **Byte-for-byte identical** to `full_tour.py` (`cmp -s` exits `0`), compiled ahead-of-time via `archx -O2` |
| 3 | `full_tour_speed.archx.lang` | **Archx (Speed / Systems)** | **12 ms** | **24.8×** | **34 KB** | `[Body(...); n]` 5-plane SIMD SoA, `with region:` bump-arena Planar `<16 x i8>` SIMD `dict`/`set`, stack-inline `enum Event` + exhaustive `match` |
| 4 | `full_tour.c` | **Clang C (`clang -O2 -lm`)** | **9 ms** | **33.1×** | **14 KB** | AoS `Body*`, open-addressing hash table, tagged union `Event` + `switch` |
| 5 | `full_tour.rs` | **Rust (`rustc -O`)** | **13 ms** | **22.9×** | 359 KB | `Vec<Body>`, `std::collections::HashMap`/`HashSet`, `(i64, i64, i64)`, `Option<i64>`, algebraic `enum Event` + `match` |

## Expected Deterministic Output (All 5 Editions)

```text
sim=7684989
dict_slice=2307705,nohtyp_smetsys_xhcra
tuple_opt=8,104,3543,10099,empty
match_dispatch=33780000
```

## Running All 5 Together

```bash
bash benchmarks/run.sh
```
