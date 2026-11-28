# Archx optimization strategy

Archx has one performance goal: **whatever the user writes, the compiler should turn it into highly optimized native code** — not "simple" code that merely works, and not unsafe code that relies on undefined behavior.

That does **not** mean hand-optimizing every expression in the frontend. It means designing the language's data layouts and emitting invariants that LLVM's `-O2` pass pipeline (`IPSCCP → Inliner → SROA → InstCombine → IndVarSimplify → LoopVectorize`) can prove and vectorize directly — including structural transformations like **AoS-to-SoA planarization** and **scoped region bump allocation** that C and Rust cannot perform automatically on standard `struct[]` / `Vec<T>` code.

## Reproducibility is a precondition for optimization

A performance gate is only meaningful if the same source produces the same artifact: otherwise a
"2% win" may just be a different symbol order, a different temp path, or a different hash seed. Archx
therefore treats reproducibility as part of the optimization contract, enforced by
`ci/reproducibility.sh` on every run:

| Source of nondeterminism | Where it was | Fix |
|---|---|---|
| `HashMap` iteration order for monomorphized `Func`/`StructDef` and lifted closures | `src/codegen/generics.rs` (`inst_funcs`, `inst_structs`, `closures`) | `BTreeMap`, so definitions are emitted in canonical order |
| The temporary `.ll` filename (PID + counter) leaking into the object's `.file` symbol | `src/main.rs` → clang | the IR now carries `source_filename = "<real source name>"`, so the binary no longer embeds a sandbox path |

The gate compiles every benchmark and example **twice**, requires byte-identical IR *and* byte-identical
linked binaries, checks a third run in a fresh process with a different hash seed, and requires stdout
**and stderr** to match between the two builds. It runs on the release build in CI next to the IR
verifier, so a change that trades determinism for speed is rejected automatically rather than argued
about.

## The four layers

| Layer | Who owns it | What it does | Examples in Archx |
|---|---|---|---|
| 1. Language design | **Archx** | Semantics & memory layouts that make optimization legal and profitable | value `struct`s (enabling transparent SoA), `region:` bump arenas + escape checking, 16 B prefix-SSO `str`, checked overflow (`nsw` when bounded) |
| 2. Frontend IR | **Archx** | Emit clean, alias-free, alignment-annotated IR | `VarStorage::Imm` direct SSA, `define internal`, `noalias align 16`, loop range versioning, constant-divisor fast path |
| 3. LLVM middle-end | LLVM | Inlining, SROA, GVN, LICM, loop unrolling, SIMD vectorization | `clang -O2` (`<2 x i64>` / AVX2 auto-vectorization, closed-form Gauss sums) |
| 4. Backend / runtime | LLVM + **Archx** | Instruction selection, 64 KB slab reuse, hybrid RAII teardown | `@archx_region_alloc` 2-instruction fast bump, root-slab cursor rewind, tag-bit `str` drop elision |

## Milestone 5 + Safety Lowering: Concrete `-O2` LLVM IR Proofs

Every optimization below is verified in CI against the saved `-O2` LLVM IR dumps (`ci/out/bench_arrays.opt.ll`, `ci/out/bench_composite.opt.ll`, and `ci/out/bench_composite_c.opt.ll`) and checked for memory safety under `clang -fsanitize=address,leak` (`ci/logs/asan_lsan.log`):

### 1. Transparent AoS-to-SoA Planarization (`[Struct]` → `align 16` per-field planes)

In C (`struct Body *`) and Rust (`Vec<Body>`), a 100,000-element array of 6-field `Body { x, y, z, vx, vy, vz }` structs is laid out as **Array-of-Structs (AoS)** (`48 B` stride). When a loop updates `x += vx; y -= vy`, every 64-byte cache line pulls in 16 bytes of unused `z, vz` data (33% cache bandwidth wasted), and `clang -O2` (`ci/out/bench_composite_c.opt.ll`) has to stride by 48 bytes and execute *both* `add <2 x i64>` and `sub <2 x i64>` followed by `shufflevector` (`blendpd`) to merge adjacent fields.

In Archx (`try_emit_transparent_soa` in `src/codegen.rs`), when a local `[Struct]` binding has a fixed length (never `push`/`pop`/rebound/escaped as AoS) and all fields are scalars (`int` / `bool`), Archx lowers it transparently into **separate `noalias align 16` per-field planes**:

- Loops touching only `x, y, vx, vy` (`vector.body42` in `ci/out/bench_composite.opt.ll`) unroll 4-wide (`8` bodies/iter) into pure contiguous `align 16` `<2 x i64>` streaming `load` / `add` / `sub` / `store` instructions — **100% cache-line utilization** and **zero `shufflevector` shuffles**, never touching the `z` or `vz` planes at all.
- The strided partial update `for j in 0..n step 8:` touches *only* the `z` and `vz` planes with zero bounds-check branches.
- `for b in bodies:` synthesizes `%Struct` directly from the planes at index `%idx` with zero copies and zero bounds checks.

### 2. Scoped `region:` 64 KB Bump Arenas + Root Cursor Rewind

Inside `region:`, array literals, `[val; n]` repeat buffers, and long string concatenations allocate from a lazy per-function `%ArchxRegion { cur, end, head, tail }` arena backed by 16-byte-aligned 64 KB slabs:

- `@archx_region_alloc` (`alwaysinline`) is a **14-instruction inline bump check** (`end - cur >= aligned → cur += aligned`), keeping multi-slab reuse/growth out-of-line in `@archx_region_alloc_fallback` (`noinline`).
- Exiting an outermost `region:` calls `@archx_region_rewind_root` (`alwaysinline`), rewinding `cur = head + 16, end = head + 16 + cap, tail = head` without freeing the cached 64 KB slab until function exit.
- In `ci/out/bench_composite.opt.ll` (`arena_and_strings`), LLVM promotes `cur` and `end` into loop-carried `phi` registers across all **40,000 iterations**: `@malloc(65552)` runs **once** on iteration 0, and all remaining 39,999 iterations allocate both `[0; sz]` and 26-byte strings in **2 pointer instructions** (`0` `malloc`/`free` calls vs C's `240,000` `calloc`/`malloc`/`free` calls).
- Compile-time **escape analysis** (`expr_may_be_region_backed`) rejects storing region values into outer variables, while `return expr` from inside `region:` invokes `@archx_str_promote` / `@archx_vec_promote_*` before freeing all slabs at function exit.

### 3. 16-Byte German/Umbra Prefix-SSO Strings (`%ArchxStr = type { i64, i64 }`)

Every `str` value is a 16-byte two-register pair (`16 B` vs Rust `String`'s `24 B`):

- **Word 0 (`i64`)**: low 32 bits = byte `len`; high 32 bits = first 4 bytes (`prefix4`, zero-padded).
- **Word 1 (`i64`)**:
  - If `len <= 12` (**inline SSO**): bytes `4..12` stored directly in Word 1 (`0` heap allocations, `0` pointer dereferences).
  - If `len > 12`: `ptr_aligned_4 | tag`, where low 2 bits encode `00 = STATIC (.rodata)`, `01 = HEAP (malloc, align 16)`, `10 = REGION (align 16)`.
- Because `@archx_str_concat` and `@archx_str_drop` are `alwaysinline` and region pointers mask `and i64 %rp_i, -4 | 2`, LLVM's `SROA` + `InstCombine` + `knownBits`:
  1. Constant-folds `"id_" + s_rhs` (`3 + 6 = 9 <= 12` bytes) and `s1 == "id_alpha0"` in `ci/out/bench_composite.opt.ll` completely into **register bitops and `icmp eq`** with **zero memory allocations and zero `@archx_str_drop` instructions**.
  2. Rejects mismatched long strings in **one `icmp eq i64` on `(len | prefix4<<32)`** before touching memory, and fast-paths identical pointers before calling `bcmp` on suffix bytes `4..len`.

### 4. Bounds-Safe & Overflow-Safe Loops Without C UB

- **Checked arithmetic with bounded induction `nsw`**: `+`, `-`, `*` emit `@llvm.sadd/ssub/smul.with.overflow.i64` (panicking deterministically on `i64` overflow), while induction updates proven bounded by `0..n` emit `add nuw nsw` directly.
- **Constant-divisor safe `/` and `%`**: compile-time non-zero positive divisors (`% 1000`, `% 1000000007`) bypass runtime zero and `i64::MIN / -1` branch guards, lowering to a single `srem`/`sdiv` instruction.
- **Range-Guarded `for` Versioning + Strided `for .. step k` + Monotonic `while` Versioning**: checks array bounds once in the preheader and emits single-exit check-free inner loops so LLVM's `LoopVectorize` emits `<2 x i64>` SIMD vector bodies (`ci/out/bench_arrays.opt.ll`).

### 5. Planar `<16 x i8>` SIMD SwissTable `dict` / `set` + Two-Tier Adaptive Typing (`v0.7.0`)

- **Planar SIMD SwissTable (`%ArchxDictHdr`)**: Combines 16-wide `<16 x i8>` SIMD control-byte probing (`icmp eq <16 x i8> %grp, %h2_vec` + `@llvm.cttz.i32`) with dense insertion-ordered planar `keys[]` and `vals[]` arrays (`idx_base[]` maps sparse SIMD slots to dense `0..len` indices). `@archx_dict_find_h_*` records the first available `0x80`/`0xFE` slot during lookup so `@archx_dict_upsert_*` commits new insertions with **zero second probe and zero second hash**.
- **Register-Only Prefix-SSO String Keys**: Because `@archx_hash_str` and `@archx_str_eq` are `alwaysinline` over `%ArchxStr { w0, w1 }`, string keys `<= 12` bytes (`"tok_42"`) hash and compare 100% in two 64-bit CPU registers with **zero pointer dereferences**, while keys `> 12` bytes reject hash collisions in one 64-bit `(prefix4 << 32) | len` register compare.
- **Two-Tier Adaptive Type Engine (`analyze_adaptive_types`)**: Infers specialized zero-tag types for homogeneous Python variables and empty `{}` / `[]` / `set()` / `dict()` calls from usage, and promotes only genuinely heterogeneous containers or rebound variables to unboxed 24-byte `%ArchxAny { i64 tag, i64 w1, i64 w2 }` (where even `%ArchxStr` sits inline in `w1, w2` without an extra heap box).

### 6. Zero-Heap Tuples, Unboxed `T | None` Optionals & Stack Algebraic `enum`s (`v0.8.0`)

- **Register-Promoted Value Tuples (`{ T1, T2, ... }`)**: Unlike Python `tuple` (a heap-allocated `PyTupleObject` + refcounted `PyObject*` elements), Archx tuples compile directly to unboxed LLVM aggregates (`insertvalue` / `extractvalue`), enabling LLVM's `SROA` to keep multiple-return values (`return lo, hi, total`), `a, b = b, a` swaps, and `(kind, a, b)` `match` subjects 100% in CPU registers (`ci/out/bench_full_tour.opt.ll`).
- **Stack-Inline `T | None` (`{ i1, T }`) + Flow-Sensitive Narrowing**: `int | None` lowers to `{ i1, i64 }` in registers with zero heap boxing; `if hit is not None:` and `hit + 1 if hit is not None else -1` extract `hit` once into a plain `i64` register across the guarded branch.
- **Stack Algebraic `enum`s (`%ArchxEnum_Name = type { i64, [W x i64] }`) + Exhaustive `match`**: Sum types store an `i64` discriminant plus `W` inline 8-byte words (`[2 x i64]` for `Event`), and compiler-verified exhaustive `match` lowers to branch-eliminated tag comparisons (`unreachable` fallthrough) so LLVM turns variant dispatch into tight jump tables or `select` chains (`16 ms` in `full_tour_speed` vs `19 ms` `rustc -O` and `464 ms` `Python 3`).

## Measured 6-Suite CI Results (`ci/out/benchmarks.txt`)

Measured with `benchmarks/run.sh` (`Python 3.11.2`, `clang -O2 -ffp-contract=off`, `rustc -O`, `archx v0.9.0 -O2`, identical stdout verified via `cmp`); see `ci/out/benchmarks.txt`:

| Suite | Python 3 (`python3`) | C (`clang -O2`) | Rust (`rustc -O`) | **Archx (`archx -O2`)** | vs Python 3 | Stripped Binary (Archx / C / Rust) |
|---|---:|---:|---:|---:|---:|---:|
| **1. Scalar (`primes`)** | 41 ms | 116 ms | 117 ms | 117 ms | 0.4× | **5 KB** / 5 KB / 335 KB |
| **2. Arrays (`arrays`)** | 5,279 ms | 89 ms | 88 ms | **91 ms** | **58.0×** | **6 KB** / 6 KB / 336 KB |
| **3. Composite (`composite`)** | 1,416 ms | 64 ms | 40 ms | **27 ms** | **52.4×** | **9 KB** / 8 KB / 337 KB |
| **4. Pythonic Float N-Body (`nbody_float`)** | 3,562 ms | 57 ms | 57 ms | **51 ms** | **69.8×** | **10 KB** / 8 KB / 337 KB |
| **5. Planar SIMD Dict (`dict_bench`)** | 274 ms | 67 ms | 47 ms | **46 ms** (`87 ms` `%ArchxAny`) | **6.0×** (`3.1×`) | **16 KB** / 8 KB / 358 KB |
| **6. 5-Way Full Tour (`full_tour`)** | 464 ms | 25 ms | 19 ms | **16 ms** Speed / **18 ms** 1:1 Pythonic | **29.0× / 25.8×** | **36 KB** / 12 KB / 381 KB |
| **7. Comprehensions & Inline Sorting (`pipelines`)** | 41 ms | 10 ms | 9 ms | **10 ms** 1:1 Pythonic | **4.1×** | **31 KB** / 11 KB / 405 KB |

Across **Suites 3, 4, and 5**, **Archx beats Python 3 by `6.0×`–`69.8×` AND beats both `-O2` C and `-O` Rust**; on **Suite 6**, unchanged Python 3.10+ source (`full_tour_pythonic.archx.lang`, byte-for-byte identical to `full_tour.py`) beats `clang -O2` (`18 ms` vs `25 ms`, `25.8×` faster than Python 3) while `full_tour_speed.archx.lang` runs in `16 ms` (`29.0×` faster than Python 3); on **Suite 7** the 1:1 Archx edition matches `clang -O2` exactly (`10 ms`, `4.1×` faster than Python 3, within 11% of `rustc -O`), with **0 bytes leaked** across all 11 targets under LeakSanitizer (`ci/logs/asan_lsan.log`).

## What we have implemented so far

1. **Entry-block allocas for mutable locals + direct SSA (`VarStorage::Imm`) for immutable scalars, `str`, `struct`, and `[T]`** — done.
2. **`define internal` module-private linkage on `@archx_*` functions** — done (unlocking `IPSCCP`, dead-arg elimination, and cross-function constant propagation).
3. **Checked integer overflow & safe division/modulo with constant-divisor guard elision** — done.
4. **Explicit natural alignment (`align 8` / `align 1`) + `noalias align 16` allocators + `2^47` single-compare allocation guard** — done.
5. **Compile-time bounds-check elision + Range-Guarded `for` Versioning + `for .. step k` + `for x in arr` + Monotonic `while` Versioning** — done.
6. **Value `struct`s + Transparent AoS-to-SoA planarization for local `[Struct]` arrays** — done.
7. **Scoped `region:` 64 KB bump arenas + root-slab fast cursor rewind + escape analysis + `return` heap promotion** — done.
8. **16-byte German/Umbra prefix-SSO `str` (`+`, `==`, `!=`, `len`, embedded-NUL safe)** — done.
9. **Recursive deterministic RAII ownership across nested `[T]`, `struct`, and `str` (verified by ASan + LSan in CI)** — done.

## What we can optimize next

1. **Whole-program / cross-function SoA parameter passing** — extend transparent SoA planarization across `internal` helper functions that accept `[Struct]` parameters without escaping them.
2. **`StringBuilder` / multi-operand `a + b + c` fusion** — fuse chained `s1 + s2 + s3` concatenations into a single length-summed allocation + `memcpy` sequence.
3. **`-O3` and `-flto` CLI flags (`--release-fast`)** — keep `-O2` as the fast-compile default and expose `-O3 -march=native -flto` when requested.
4. **Monomorphized generics** — zero-cost generic structs and functions lowered before LLVM inlining.

## Principles

- **Emit clean IR; let LLVM do the heavy lifting.** Do not hand-roll passes that already exist in `-O2`.
- **Win on data layout, not undefined behavior.** SoA planarization, 16-byte prefix-SSO strings, and 64 KB region slab reuse beat C *because* they move fewer cache lines and skip `malloc`/`free`, while keeping 100% bounds and overflow safety.
- **Measure everything in CI.** Keep `-O2` IR dumps (`ci/out/*.opt.ll`), ASan+LSan logs (`ci/logs/asan_lsan.log`), and C/Rust wall-clock timings (`ci/out/benchmarks.txt`) committed on every push.
