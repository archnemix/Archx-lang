# Optimization A/B record: `-O2` (default) vs `-O3` / `-march=native` / `-ffast-math`

Measurements taken in the development sandbox (zig cc / clang 22.1.8, x86_64 Linux), 5–7 timed runs
per binary, best wall-clock. Produced while closing AX-002 and answering "is there more optimization
to get?" — the answer is recorded here rather than assumed in either direction.

## Result

| suite | `-O2` | `-O3` | `-O3 -mllvm -unroll-threshold=600` | `-O2 -march=native` | `-O2 -ffast-math` |
|---|---:|---:|---:|---:|---:|
| `composite` | 26.9 ms | 27.1 ms | 26.7 ms | 28.2 ms | 27.6 ms |
| `nbody_float` | 46.8 ms | 46.8 ms | 47.0 ms | 50.1 ms | 47.8 ms |
| `full_tour_pythonic` | 17.2 ms | 17.2 ms | — | — | 17.1 ms |
| `pipelines` | 8.7 ms | 8.5 ms | 8.5 ms | 8.7 ms | 8.5 ms |

* Every variant produced **byte-identical stdout** on all four suites.
* Every delta is inside run-to-run noise (±3%) on this machine except `pipelines` at `-O3`/`-O3u`,
  which is a 2% improvement on an 8.5 ms program — not a repeatable win.
* `-ffast-math` is **rejected on principle**, not on measurement: it permits reassociation and the
  assumption of no NaN/Inf, which would break the byte-identical-to-CPython contract no matter how
  fast it were. It is listed here only to show it was considered and measured, and that even its
  (nonexistent) upside would not justify the contract it breaks.
* `-march=native` is **rejected on portability**: it makes the artifact depend on the build host's
  CPU, so a binary produced in CI can fault on a user's machine.

## Why the compiler still passes `-O2`

`-O3` enables the same safety-relevant passes as `-O2` (LICM, inlining, GVN) plus more aggressive
unrolling and vectorisation. Since the measured gain is ~0 on these seven suites, the default stays at
`-O2`: fewer new transformations in play over code that contains `llvm.s*.with.overflow` and bounds
checks, i.e. a smaller surface where an aggressive pass could elide something it should not.

This is a statement about *these* suites, not a proof for every program. `archx -O <0|1|2|3|s>` exists
so a user (and a future benchmark gate) can select a level explicitly, and
`tests/cli.rs::optimisation_levels_are_selectable_and_behaviour_preserving` asserts that every level
produces identical stdout on a mixed int/float/list program.

## Re-measurement on the current toolchain (Rust 1.97.0, clang 22.1.8)

Because the default level is pinned by measurement, it has to be re-checked when the toolchain moves.
Re-run on the toolchain in this environment (best of 9 runs, and the median, so noise is visible):

| suite | `-O2` best | `-O2` median | `-O3` best | `-O3` median |
|---|---:|---:|---:|---:|
| `composite` | 27.8 ms | 29.2 ms | 28.4 ms | 29.2 ms |
| `nbody_float` | 48.2 ms | 50.0 ms | 47.5 ms | 48.4 ms |
| `pipelines` | 8.7 ms | 8.9 ms | 8.6 ms | 8.8 ms |

`-O3` is ahead by 1.4% on `nbody_float` and 1.1% on `pipelines`, behind by 2.2% on `composite`, and the
two levels are indistinguishable at the median. The conclusion is unchanged: no repeatable win, so the
default stays at `-O2`, where fewer aggressive passes are in play over code containing
`llvm.s*.with.overflow` and bounds checks.

One further flag was measured because it is **contract-safe** rather than merely fast: `-fno-math-errno`
tells LLVM that no observer reads `errno` after a math call. That is true for every Archx program — the
runtime has no `errno` API, and a compat module cannot import libm — so it is a legitimate permission
rather than a relaxation of the float contract (unlike `-ffast-math`, which changes results).

| suite | `-O2` | `-O2 -fno-math-errno` | delta |
|---|---:|---:|---:|
| `nbody_float` | 47.6 ms | 47.5 ms | −0.2% |
| `composite` | 30.3 ms | 29.5 ms | −2.6% |
| `pipelines` | 8.9 ms | 8.9 ms | 0.0% |
| `primes` | 128.6 ms | 128.1 ms | −0.4% |

All four deltas are inside run-to-run spread, so the flag is **not** adopted: an extra flag in the
driver is a permanent compatibility surface, and it should be paid for by a measured win. The
measurement is recorded so the decision does not have to be repeated from scratch.

## Safety checks verified to survive both levels

Programs written specifically to exercise the checks at `-O2` and `-O3` (both printed the panic and
exited 101 at both levels, so no check was removed by the optimizer):

* out-of-bounds index (`xs[7]` on a 4-element list) — `archx runtime panic: index 7 out of bounds`;
* arithmetic overflow inside a loop (`acc + 2^62`, three times) — `archx runtime panic: integer overflow`.

## Not attempted, and why

* `-polly` / polyhedral loop transforms: not shipped in this toolchain, and the loops here are
  already vectorised where profitable (see `ci/out/*.opt.ll`).
* LTO/PGO: single-module programs with no link-time boundary to exploit; PGO would also make builds
  non-reproducible unless the profile is committed, which conflicts with AX-012's byte-identity gate.
* Post-link `--gc-sections`/`strip`: already reflected in the reported "Stripped KB" column.
