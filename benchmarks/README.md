# Benchmarks

One workload, three languages, one optimizer. The point is not to prove Archx
beats anybody — it is to show **why** Archx is in the same speed class as C and
Rust, with numbers you can reproduce yourself.

## The workload

`primes.c`, `primes.rs`, `primes.archx.lang` contain the same two loops, written
as plainly as possible in each language. No SIMD intrinsics, no `unsafe`, no
clever tricks — whatever happens, the compiler has to do it on its own.

| # | Workload | What it exercises |
|---|----------|-------------------|
| 1 | `sum_squares(20_000_000)` — `total = (total + i*i) % 1_000_007` | a tight arithmetic loop: multiply, add, divide |
| 2 | `count_primes(400_000)` — trial division | a nested loop with a data-dependent branch and an early `break` |

Both print their results. **The run fails if C, Rust and Archx disagree** — the
benchmark is also a correctness test.

Expected output on every platform:

```
75517
33860
```

## Running it

```sh
bash benchmarks/run.sh          # best of 5 runs
bash benchmarks/run.sh 20       # best of 20, less noise, slower
```

All three are built at optimisation level 2 (`clang -O2`, `rustc -O`, and
Archx's own `clang -O2`) and timed the same way: the binary is run N times, the
**best** time is reported (the most stable estimator on a shared machine), with
the mean in parentheses so jitter is visible.

Results go to stdout and to `ci/out/benchmarks.txt`. CI runs this on every push
and commits the table back to the repo, so the history of the numbers is in git.

## How to read the result

The three programs compile to **the same LLVM IR**, so they should land within
measurement noise of each other. If they do, that is the whole argument for
Archx's design in one table:

> Archx does not need its own optimizer to be fast. It needs to emit IR that
> LLVM's optimizer can understand.

Where the languages *do* differ, and why:

| Axis | C | Rust | Archx |
|------|---|------|-------|
| Optimizer | LLVM (`clang -O2`) | LLVM (`rustc -O`) | LLVM (`clang -O2`) |
| Loop IR | `icmp slt` + `br` | `icmp slt` + `br` | `icmp slt` + `br` |
| Binary size | smallest | largest (static runtime, panic machinery) | smallest |
| Build time | fastest | slowest | fast (text IR → one clang call) |

Binary size is measured twice: as linked, and after `strip`. The gap between
Rust and the other two is the Rust runtime being linked in statically — it buys
panic messages and backtraces, not speed. That is the trade-off Archx is
designed around: pay for what you use.

## What this does *not* prove

- It says nothing about I/O, allocation, strings or generics — Archx does not
  have those yet. Benchmarks will be added as the features are.
- Two loops on one machine is a smoke test, not a benchmark suite. Treat the
  numbers as a sanity check, not a verdict.
- `-O2` everywhere is deliberate. If you want to see what `-O3` or LTO adds,
  change one flag and re-run: the interesting question is whether Archx's IR
  gives LLVM the same opportunities the other front-ends do. (In Rust, `-O2`
  is spelled `-O` or `-C opt-level=2`.)
