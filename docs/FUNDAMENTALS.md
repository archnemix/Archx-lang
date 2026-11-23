# Archx Fundamentals

Archx is built around a simple premise: **you should not have to choose between code a human enjoys reading and code a CPU enjoys executing.**

Most languages pick a side early and spend the next twenty years trying to bolt the other side on. Dynamic languages start friendly and later add JITs, type hints, C extensions, and native bundlers. Systems languages start close to the metal and accumulate punctuation, undefined-behavior footguns, or lifetime ceremony that every line of ordinary logic has to pay for.

This document sets down the five fundamentals guiding Archx:

1. **What is broken in existing languages** — the specific trade-offs Archx refuses to inherit.
2. **Memory** — how scalars, value `struct`s, SoA planes, 16-byte prefix-SSO strings, RAII containers, and `region:` bump arenas work together without a garbage collector or `'a` lifetime annotations.
3. **Binary size & speed** — why an Archx executable is **14 KB stripped** while matching or beating C and Rust across scalar, array, and composite struct/arena/string workloads.
4. **Readability** — concrete syntax choices that keep code scannable.
5. **Straightforwardness & safety** — checked arithmetic, bounds safety, zero implicit conversions, and inspectable `--emit-ir` output.

---

## 1. The problem with current languages

Every mainstream language solves a real problem well, and each leaves a specific tax on the programmer or the machine:

| Language | What it gets right | The tax you pay |
|---|---|---|
| **Python** | Clean indentation, minimal ceremony, immediately readable | Every `int` is a heap-allocated PyObject; interpreter dispatch + refcounting make tight loops 30–100× slower than native code; shipping a program means shipping a runtime |
| **C / C++** | Zero forced runtime, tiny binaries, full hardware reach | **Undefined behavior** (signed overflow, buffer overruns, use-after-free, uninitialized reads), manual `malloc`/`free` leaks, AoS cache waste unless rewritten by hand |
| **Rust** | Memory safety without a GC, C-tier speed, strong tooling | Heavy syntactic density (`&'a mut`, turbofish, `Box<dyn ...>`), borrow-checker friction on arenas/graphs, slow builds, 330 KB–4.4 MB binaries even for tiny programs |
| **Go** | Fast builds, simple mental model, easy deployment | Mandatory garbage collector (latency tail + ~2× live-heap headroom), hidden heap escapes across interfaces/closures, ~2 MB minimum binary for the runtime |
| **Zig** | Explicit control, tiny binaries, no hidden allocations | C-family low-level ceremony everywhere — ideal for writing kernels and allocators, noisier than necessary for everyday algorithmic and systems application code |

Archx sits in the gap between **Python's surface** and **C/Zig's compiled output**, while giving the compiler higher-level structural freedom than C pointers allow:

- **Surface**: 4-space indentation blocks, words instead of symbol soup (`and`, `or`, `not`, `in`, `step`, `region`), local type inference, zero semicolons.
- **Underneath**: ahead-of-time compilation to LLVM IR, unboxed SSA values, transparent AoS-to-SoA struct array planarization, 64 KB bump arenas, 16-byte prefix-SSO strings, deterministic RAII, zero garbage collector, and a **14 KB** stripped binary linked straight against system `libc`.

---

## 2. Memory

### Why memory layout is the whole game

On a modern CPU, arithmetic is nearly free and **moving cache lines + calling general-purpose allocators is expensive**:

| Where the value lives | Typical access cost | How Archx puts data there |
|---|---|---|
| CPU register | ~0–1 cycle | Immutable `int`, `bool`, `struct` values, and `<= 12 B` SSO `str` values in LLVM SSA |
| L1 cache / stack frame | ~3–5 cycles | Mutable local slots promoted by `mem2reg`/`SROA`, inline struct fields |
| Contiguous 16B-aligned SoA planes / 64 KB `region:` slab | ~4–30 cycles (hardware prefetcher + SIMD) | Local `[Struct]` planarized per field; temporary buffers/strings bump-allocated in `region:` |
| General heap (`malloc`/`calloc`) | ~40–250 cycles + allocator metadata | Long-lived growable `[T]` arrays and `> 12 B` heap-owned strings, freed deterministically via RAII |

### How Archx memory works today (Milestone 5)

1. **Direct SSA (`VarStorage::Imm`) + entry-block `alloca`s.**
   Immutable parameters and `let` bindings (`int`, `bool`, `str`, `struct`, and fixed `[T]`) stay directly in LLVM SSA registers with zero stack traffic. Mutable bindings use entry-block `alloca` slots that LLVM's `mem2reg` / `SROA` passes promote into registers at `-O2`.

2. **Value `struct`s + Transparent AoS-to-SoA Planarization.**
   A `struct Body` is an unboxed value type — never implicitly heap-boxed behind an object pointer. Better still, because Archx does not expose raw C interior pointers (`&bodies[i].x`), when you allocate a local fixed-length `[Body]` array (`let bodies = [Body(...); n]`), the compiler transparently stores each field in its own contiguous 16-byte-aligned plane (`x[]`, `y[]`, `z[]`, `vx[]`, `vy[]`, `vz[]`). Loops that touch 4 of 6 fields load **zero** wasted bytes per cache line and vectorize cleanly without gather/blend overhead.

3. **16-Byte German/Umbra Prefix-SSO Strings (`str`).**
   Every string is a 16-byte `{ len_and_prefix4: i64, inline8_or_tagged_ptr: i64 }` value in two registers:
   - Strings up to **12 bytes** live 100% inline inside those 16 bytes — concatenating `"id_" + tag` (`9 B`) never touches memory or `free`.
   - Strings longer than 12 bytes keep their **first 4 bytes inline** alongside a 2-bit pointer ownership tag (`STATIC = 00`, `HEAP = 01`, `REGION = 10`), so most `!=` checks finish in a single 64-bit register compare without dereferencing the pointer at all.

4. **Hybrid Ownership: Deterministic RAII + Scoped `region:` Arenas.**
   - **Long-lived owners (`[T]`, `str`, nested `[Struct]`)** follow single-owner value semantics and emit deterministic recursive cleanup on scope fallthrough, overwrite, `return`, `break`, and `continue`.
   - **Batch/request temporaries (`region:`)** bump a single pointer inside a cached 64 KB slab (2 instructions per allocation) and rewind in O(1) at the end of the `region:` block. Compile-time **escape analysis** prevents dangling region references in outer variables, while `return expr` from inside a `region:` automatically promotes escaping buffers to heap ownership before tearing down the region.
   - **Verified leak-free**: CI compiles and runs Archx suites under **AddressSanitizer + LeakSanitizer** (`0` leaks, `0` invalid accesses in `ci/logs/asan_lsan.log`).

---

## 3. Binary size & speed

Small binaries mean instant startup, minimal instruction-cache footprint, tiny container images, and zero hidden runtime threads.

### Measured numbers (`ci/out/benchmarks.txt`)

Across all three CI benchmark suites (`x86_64-pc-linux-gnu`, `clang 21.1.8 -O2`, `rustc 1.100.0 -O`, best of 7 runs):

| Suite | C (`clang -O2`) | Rust (`rustc -O`) | **Archx (`archx -O2`)** | Archx Stripped (vs Rust) |
|---|---:|---:|---:|---:|
| **1. Scalar (`primes`)** | **134 ms** | **134 ms** | **134 ms** | **14 KB** (vs 330 KB) |
| **2. Arrays (`arrays`)** | **58–62 ms** | **64 ms** | **63 ms** | **14 KB** (vs 331 KB) |
| **3. Composite (`composite`)** | **21 ms** | **23 ms** | **18 ms** | **14 KB** (vs 332 KB) |

On Suite 3 (`100,000` 6-field `Body` structs × 120 timesteps + `40,000` scratch-buffer & string rounds), **Archx finishes in `18 ms` — beating both C (`21 ms`) and Rust (`23 ms`)** — while producing a **14 KB** stripped executable (**23.7× smaller** than stripped Rust and **274× smaller** than unstripped Rust's 4,390 KB).

### Why is Archx 14 KB?

- **Rust** statically links `libstd` (panic formatters, DWARF stack-unwinding tables, symbol demangling, thread-local runtime init).
- **Go** embeds its goroutine scheduler and concurrent garbage collector (~2 MB floor).
- **Archx** emits only the functions and runtime helpers your program actually uses (dead-stripped via `private`/`internal` LLVM linkage) and links straight against the system `libc` already mapped in every OS process.

---

## 4. Readability

Readability is treated as an engineering constraint, not an aesthetic preference:

1. **Indentation *is* block structure.**
   4-space indentation is the single source of truth — no `{ }` mismatches and no closing-brace ladders.

2. **Words where symbols blur together.**
   `if x > 0 and not done:` reads at natural speed. Archx uses `and`, `or`, `not`, `in`, `step`, `region`, `struct`, `func` as clear keywords while keeping arithmetic and comparison operators crisp.

3. **Explicit at boundaries, inferred inside.**
   Function and struct signatures always state types (`func simulate(n: int) -> int:`), while local variables infer cleanly (`let bodies = [Body(...); n]`).

4. **Expressive, safe loops.**
   - `for i in 0..n:` — half-open range, bounds evaluated once.
   - `for i in 0..n step 8:` — strided range with positive-step enforcement and bounds-check elision.
   - `for b in bodies:` — direct element iteration with zero bounds checks.
   - `while cond:` — condition-driven loop.

---

## 5. Straightforwardness & safety

"Straightforward" means **local reasoning always works** and **bugs fail loudly instead of corrupting memory**:

- **Zero C signed-overflow or division UB**: `int` `+`, `-`, `*`, unary `-`, `/`, and `%` check for `i64` overflow, division by zero, and `i64::MIN / -1` (eliding checks automatically when loop bounds or constant divisors prove safety).
- **Zero out-of-bounds memory corruption**: every `arr[i]` is bounds-safe, with checks proven away at compile time on canonical `for` / `step` / `foreach` / monotonic `while` loops.
- **No implicit conversions or "truthiness"**: `if`, `while`, `and`, `or`, `not` require `bool`; `x = expr` requires an existing `let` binding of the exact type.
- **Inspectable compilation (`--emit-ir`)**: at any moment you can run `archx file.archx.lang --emit-ir` (or inspect `ci/out/*.opt.ll`) to see the exact LLVM IR your code lowers to.

**You write the straightforward code; the compiler writes the clever machine code.**
