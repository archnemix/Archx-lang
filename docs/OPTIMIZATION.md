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

## How memory works today (milestone 2)

Every local variable is a stack slot:

```llvm
entry:
  %var.answer.3 = alloca i64
  store i64 %t2, ptr %var.answer.3
  %t4 = load i64, ptr %var.answer.3
```

This is deliberately simple and correct. It also optimizes well: LLVM's `mem2reg` and SROA passes promote entry-block allocas to SSA registers at `-O2`, so the final machine code usually has no stack traffic for locals.

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

The multiply, alloca, store, and load all disappear. The compiler turned "simple" code into "highly optimized" code — that is the model.

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

## What we can optimize now

1. **Entry-block allocas** — done. Every `alloca` is hoisted into the entry block, which is what `mem2reg`/SROA wants.
2. **String interning** — done. Identical string literals share one global.
3. **Short-circuit `and`/`or`** — done with basic blocks and a stack slot; LLVM promotes the slot.
4. **Constant folding in the frontend** — next. `6 * 7` becomes `42` before IR is emitted, shrinking the IR and compile time.
5. **Immutable `let` → direct SSA value** — next. A `let` that is never reassigned does not need an alloca at all.
6. **Attributes** — add `noalias`, `nocapture`, `readonly`, `nonnull`, `willreturn`, `nounwind`, `mustprogress` where legal. These unlock LLVM optimizations.
7. **Avoid redundant loads/stores** — LLVM's GVN already removes many, but the frontend can avoid emitting them in the first place.
8. **`-O3` opt-in** — keep `-O2` as the default, add `--release-fast` later.
9. **LTO** — `-flto` for cross-function inlining once multi-file programs exist.
10. **Custom passes** — bounds-check elision, devirtualization, allocation sinking, escape analysis. These need language knowledge LLVM does not have.

## What we add later (with milestones)

- **Loops** → LLVM loop unrolling, vectorization, LICM, strength reduction.
- **Arrays** → contiguous layout, bounds-check elision, `noalias` slices.
- **Structs** → value semantics, SoA/AoS layout control, scalar replacement of aggregates.
- **Generics** → monomorphization (zero-cost abstraction), then inlining.
- **Ownership/RAII** → deterministic destruction with no runtime cost.
- **Arenas** → scoped bump allocation for temporaries.
- **String SSO** → small strings stored inline instead of on the heap.
- **PGO/LTO** → profile-guided optimization and link-time optimization.

## Benchmarking plan

Optimization claims must be measured, not guessed. The plan:

1. Add a `benchmarks/` directory with small, focused programs (arithmetic, loops, strings, allocation, function calls).
2. Compile the same algorithms in C (clang) and Rust, and compare wall-clock time.
3. Record results in `ci/out/benchmarks.txt` on every CI run.
4. Only keep an optimization if it wins on the benchmark suite.
5. Watch compile time too — a fast compiler is part of the developer experience.

## Principles

- **Emit clean IR; let LLVM do the heavy lifting.** Do not hand-roll passes that already exist.
- **Design semantics for optimization.** Value semantics, no hidden allocations, and explicit aliasing are worth more than micro-optimizations.
- **Measure everything.** `-O3` is not automatically faster; arenas are not automatically better; inline hints are not automatically wins.
- **Optimize for the common case, not the benchmark.** Real programs have branches, allocations, and I/O.
- **Never trade correctness for speed.** Defined overflow and safety checks stay; the compiler proves them away when it can.
