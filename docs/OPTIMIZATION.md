# Archx optimization strategy

Archx has one performance goal: **whatever the user writes, the compiler should turn it into highly optimized native code** — not "simple" code that merely works.

That does **not** mean hand-optimizing every expression in the frontend. It means designing the language and emitting IR so LLVM's mature optimizer can do the heavy lifting, then adding targeted custom passes where LLVM cannot help.

## The four layers

| Layer | Who owns it | What it does | Examples |
|---|---|---|---|
| 1. Language design | **Archx** | Semantics that make optimization legal and profitable | value semantics, defined overflow, no hidden allocations, monomorphized generics, explicit aliasing |
| 2. Frontend IR | **Archx** | Emit clean, optimizer-friendly IR | entry-block allocas, string interning, constant folding, no redundant loads |
| 3. LLVM middle-end | LLVM | Inlining, SROA, GVN, LICM, loop unrolling, vectorization | `clang -O2` / `-O3` |
| 4. Backend / runtime | LLVM + **Archx** | Instruction selection, register allocation, allocators, GC/arena runtime | custom allocator, bounds-check elision |

## How memory & IR optimization work today (LLVM-direct lowering)

Rather than assuming C's undefined-behavior model or copying standard `Vec` lowering, Archx analyzes how `clang -O2` (`IPSCCP → Inliner → SROA → InstCombine → IndVarSimplify → LoopVectorize`) transforms IR and emits invariants LLVM can exploit directly while staying **100% memory- and overflow-safe**:

- **`define internal` linkage on `@archx_*` functions** — unlocks LLVM's interprocedural constant propagation (`IPSCCP`), dead-argument elimination, and single-callsite inlining across the module.
- **Direct SSA (`VarStorage::Imm`) for ALL immutable bindings — including `[T]` arrays** — variables and arrays that are never reassigned or resized (`push`/`pop`) never touch an `alloca` slot; their heap pointers register directly as SSA `DropTarget::DataPtr` values for scope-exit `@free`.
- **Explicit natural alignment (`align 8` / `align 1`) + `noalias align 16` allocators** — prevents LLVM's untargeted `LLParser` fallback (`i64:32:64`) from stamping `align 4` onto 64-bit scalar and SIMD loads/stores, enabling `align 16` vector instructions.
- **Single-instruction `2^47` allocation invariant (`icmp ugt i64 %count, 140737488355328`)** — rejects negative lengths *and* prevents `count * sizeof(T)` integer wrap in one compare, while giving LLVM a `[0, 2^47]` range with `65,535×` headroom below `i64::MAX`.
- **Range-Guarded Loop Versioning on multi-array `for` loops** — when `for i in 0..len(dst):` also indexes `a[i]` and `b[i]`, Archx checks `(end <= a.len) && (end <= b.len)` **once** in the preheader and branches to a zero-check, single-exit `for.fast` loop so `LoopVectorize` always vectorizes (and `SimplifyCFG` deletes the cold fallback loop completely whenever lengths match after inlining).
- **Monotonic Stride Versioning on `while idx < bound:` loops** — checks `(idx >= 0) && (bound <= 2^47) && (1 <= step <= 2^47)` once before entering `while.fast`, mathematically proving `0 <= idx < bound` across every `idx += step` iteration with **zero** signed-overflow UB and **zero** in-loop bounds checks (producing the exact same 5-instruction Sieve inner loop as raw unchecked C in `ci/out/bench_arrays.opt.ll`).
- **Deterministic scope-exit RAII `@free`** — non-escaping local 1D arrays free deterministically on block fallthrough, `return`, `break`, and `continue` with zero GC pauses.

**Before optimization** (`--emit-ir`):

```llvm
%t2 = mul i64 6, 7
%var.answer.3 = alloca i64
store i64 %t2, ptr %var.answer.3
%t4 = load i64, ptr %var.answer.3
%t5 = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 %t4)
```

**After `clang -O2`** (saved by CI as `ci/out/hello.opt.ll`):

```llvm
%call = call i32 (ptr, ...) @printf(ptr @.fmt.int, i64 42)
```

The multiply, alloca, store, and load all disappear. Loops optimize the same way: in `ci/out/loops.opt.ll`, LLVM recognizes the induction variable in `sum_to(n)` (`for i in 1..n + 1: total = total + i`) and collapses the entire loop into closed-form arithmetic with zero runtime iterations — and folds `sum_to(10)` in `main` straight to `printf("%lld\n", 55)`. The compiler turned "simple" code into "highly optimized" code — that is the model.

## Research: what the fastest approaches do, and what we can improve

| Area | Fastest approach | Why it is fast | Problem it has | Archx's answer |
|---|---|---|---|---|
| Raw compute | C, Rust, Zig, C++ (AOT, LLVM/GCC, no GC) | Direct memory access, no runtime checks, vectorization | C has undefined behavior and memory bugs; Rust has borrow-checker friction | Defined semantics + ownership without a GC |
| Allocation | Arena / bump allocators | O(1) pointer bump, cache-friendly, no per-object metadata | Lifetime management; not general-purpose | Scoped arenas for temporaries + ownership for long-lived data |
| Strings | C++/Rust small-string optimization; interning | Avoid heap allocations for small strings; fast equality | Complexity; immutability | Immutable strings + interning + SSO |
| Arrays | Contiguous arrays (C/Rust/Zig) | Cache locality, SIMD-friendly | Bounds checks can cost | Bounds-check elision when provable |
| Concurrency | Rust/C++ (no GC, data-race freedom) | No GC pauses | Complexity | Safe concurrency, no GC by default |
| Compile speed | Zig, Go, Jai | Incremental compilation, simple frontends | Rust builds slowly | Fast frontend; incremental compilation later |
| Startup / binary size | Zig, C, Rust | No VM, no GC runtime | — | No runtime |
| GC | Go, Java, C# | Productivity | Pauses, memory overhead, cache misses | No GC by default; opt-in runtime later |

### What the benchmarks say

- C, C++, Rust, and Zig are typically within a few percent of each other on compute-heavy tasks; the ordering changes per workload. Zig won primes and strings in one benchLANG run, while C was fastest overall ([benchLANG summary](https://www.devpebble.com/blog/fastest-programming-language/)).
- Arena allocators can be roughly 8–10× faster than `malloc`/`free` for allocation-heavy workloads, because allocation is a pointer bump and deallocation is a single reset ([arena benchmark](https://github.com/Sakar195/arena-allocator), [arena write-up](https://andreleite.com/posts/2025/nstl/virtual-memory-arena-allocator/)).
- `-O2` is the usual release sweet spot. `-O3` adds aggressive vectorization, unrolling, and inlining, but can be slower on branch-heavy code because of instruction-cache pressure; LTO is needed for cross-translation-unit optimization ([C++ optimization guide](https://www.abhik.ai/concepts/language-internals/optimization), [compiler optimization landscape](https://awesome-embedded-learning-studio.github.io/Tutorial_AwesomeModernCPP/en/vol6-performance/ch04-tuning-by-bottleneck/04-04-inline-devirt-compiler)).

## What we have implemented so far

1. **Entry-block allocas for mutable locals** — done.
2. **String interning + compile-time `len("...")`** — done.
3. **Short-circuit `and`/`or`** — done.
4. **Constant folding in the frontend** — done (`6 * 7` folds to `42` before IR is emitted).
5. **Immutable `let`, parameters, and immutable `[T]` arrays → direct SSA** — done (no `alloca`/`store`/`load` for bindings that are never reassigned or resized).
6. **`define internal` module-private linkage on `@archx_*` functions** — done (enabling `IPSCCP`, dead-arg elimination, and aggressive inlining).
7. **Explicit natural alignment (`align 8` / `align 1`) + `noalias align 16` allocators + `2^47` overflow-safe allocation guard** — done.
8. **Compile-time bounds-check elision + Range-Guarded `for` Loop Versioning + Monotonic Strided `while` Loop Versioning** — done (proven in `ci/out/bench_arrays.opt.ll`, matching raw unchecked C instruction-for-instruction on both SIMD `vec_step` and Sieve's inner loop while remaining 100% memory-safe).
9. **Deterministic scope-exit RAII `free` for non-escaping local arrays** — done.

## What we can optimize next

1. **First-class strided range syntax (`for j in a..b step k`)** — ergonomic sugar over the already-elided monotonic strided loop lowering.
2. **`readonly` unpacked slice parameter ABI** — unpack non-mutated `%ArchxVec` parameters to `(i64 %len, ptr readonly %data)` for large non-inlined functions.
3. **`-O3` and `-flto` CLI flags (`--release-fast`)** — keep `-O2` as default, expose `-O3` + LTO when requested.
4. **Scoped bump arenas (`with arena:`)** — O(1) allocation and bulk reset for temporary graphs/strings/arrays.

## What we add later (with milestones)

- **Loops** — done (`while`, `for i in a..b`, `break`, `continue`) → LLVM loop unrolling, closed-form induction elimination, LICM, strength reduction, vectorization.
- **Arrays** — done (`[T]`, `[0; n]`, `len`/`push`/`pop`, contiguous layout, compile-time bounds-check elision, automatic scope-exit `free`).
- **Structs** → value semantics, SoA/AoS layout control, scalar replacement of aggregates.
- **Generics** → monomorphization (zero-cost abstraction), then inlining.
- **Ownership/RAII** → deterministic destruction with no runtime cost.
- **Arenas** → scoped bump allocation for temporaries.
- **String SSO** → small strings stored inline instead of on the heap.
- **PGO/LTO** → profile-guided optimization and link-time optimization.

## Benchmarking

Optimization claims must be measured, not guessed:

1. `benchmarks/` holds identical workloads across two suites: scalar loops (`primes.*` in C, Rust, Archx) and array/sieve workloads (`arrays_raw.c`, `arrays_checked.c`, `arrays.rs`, `arrays.archx.lang`).
2. CI runs `bash benchmarks/run.sh 7` on every push, verifies identical stdout across every implementation, dumps `ci/out/bench_arrays.opt.ll` vs `ci/out/bench_arrays_c_raw.opt.ll`, and records wall-clock ms and binary sizes in `ci/out/benchmarks.txt` (**93 ms** Archx vs **94 ms** C/Rust on scalar; **44 ms** Archx vs **44 ms** unchecked C and **45 ms** Rust on arrays; **14 KB** stripped for Archx and C vs **331 KB** for Rust).
3. As arrays, strings, structs, and arenas land, matching benchmarks get added to `benchmarks/`.
4. Only keep a frontend or pass optimization if it wins on the suite without hurting compile speed.

## Principles

- **Emit clean IR; let LLVM do the heavy lifting.** Do not hand-roll passes that already exist.
- **Design semantics for optimization.** Value semantics, no hidden allocations, and explicit aliasing are worth more than micro-optimizations.
- **Measure everything.** `-O3` is not automatically faster; arenas are not automatically better; inline hints are not automatically wins.
- **Optimize for the common case, not the benchmark.** Real programs have branches, allocations, and I/O.
- **Never trade correctness for speed.** Defined overflow and safety checks stay; the compiler proves them away when it can.
