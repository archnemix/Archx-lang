<!-- Internal engineering skill: systematic workflow for inspecting -O2 LLVM IR and eliminating codegen bottlenecks safely. -->

# Skill: LLVM-Direct Optimization Without Undefined Behavior

Use this checklist whenever adding a new Archx feature or investigating why a benchmark lags behind C or Rust.

## 1. Capture Both Sides' `-O2` LLVM IR
1. Emit Archx IR and run `clang -O2 -S -emit-llvm` (committed automatically in `ci/out/bench_*.opt.ll`).
2. Emit the C reference IR (`clang -O2 -S -emit-llvm benchmarks/<suite>.c -o ci/out/bench_<suite>_c.opt.ll`).
3. Compare the innermost hot loop basic blocks (`vector.body*`, `for.body*`, `while.fast.body*`).

## 2. Check the Five Classic LLVM `-O2` Blockers
1. **Multi-exit loops block `LoopVectorize`**:
   - Per-element panic branches inside a loop body prevent vectorization.
   - *Fix*: Emit a 1-time preheader range guard (`end <= arr.len`) branching to a single-exit `for.fast` loop and keeping per-element checks only in the cold fallback loop.
2. **Missing alignment / aliasing metadata**:
   - Without a target datalayout, LLVM's `LLParser` defaults `i64` alignment to `4` bytes.
   - *Fix*: Always annotate `align 8` (or `align 1` for `i8`) on `load`/`store` and `noalias align 16` on heap/region allocator returns.
3. **Helper bloat above LLVM's `225` inline threshold**:
   - Inlining a 60-line slow path (`check_reuse` / `alloc_slow`) into a hot helper (`@archx_str_concat`) prevents LLVM from inlining the hot helper at call sites where lengths are compile-time constants.
   - *Fix*: Keep the `alwaysinline` fast path under ~15 instructions and split cold slab-growth/reuse paths into `noinline` `fastcc` helpers.
4. **Lost `knownBits` across pointer-to-int conversions**:
   - After inlining, a `ptr` loaded from a struct slot may lose function-return `align 16` metadata, preventing `InstCombine` from proving `(ptr | 2) & 1 == 0` in `@archx_str_drop`.
   - *Fix*: Explicitly mask `%rp_a = and i64 %rp_i, -4` before tagging `| 2` so `InstCombine` constant-folds `@archx_str_drop` to zero instructions.
5. **Unnecessary `alloca` slots on immutable aggregates**:
   - Bind unmutated scalars, `str`, `struct`, and fixed `[T]` directly as `VarStorage::Imm` SSA values; register heap buffers directly in `Scope::owned_buffers`.

## 3. Verify Zero Leaks & Zero Invalid Accesses
Every optimization touching pointers, arenas, or drops **must** pass `clang -O1 -g -fsanitize=address,leak` in CI (`ci/logs/asan_lsan.log`) before keeping it.

## 4. `v0.9.0` Addenda: Sorting, Comprehensions & Floating Point

1. **Never reuse an SSA buffer as both the stable-sort source and destination.**
   - A bottom-up merge pass that writes `dst[i]` while reading `src[j]` (`i <= j`) corrupts the
     not-yet-read tail. Ping-pong two buffers guarded by an `i1` slot, and one final
     `llvm.memcpy` when the result lands in the scratch buffer.
2. **Short-circuit before you address.** An `inbounds` `getelementptr` that lands outside the
   object is *poison even if the result is never loaded*, so hoisting `base[j - 1]` (or any
   `x[i - 1]`) above the `i > 0` test is a miscompile waiting to happen - `-O1`/`-O2` folded the
   poisoned insertion-sort function into `free(): invalid pointer`. Emit the bounds/sentinel test
   as its own block that branches around the load; never compute the address speculatively.
3. **Shift records through a stack scratch, not through the array.**
   - Insertion-sorting `base[j] = base[j-1]` with `llvm.memcpy` on *overlapping* ranges is
     `poison`. Copy the record being inserted into a single 16-byte `alloca` once, shift by
     copying *from* that slot, then store it when the position is found.
4. **Key records must be packed, not padded.** A `{ i64, i64 }` LLVM struct is 16 B; a
   `{ i8, i64 }` bool-key record is also 16 B, so a `{ bool, i64 }` key+index pair silently
   doubles the scratch traffic. Emit raw `i8` pointer arithmetic with an explicit layout
   (`key_off`, `idx_off`, `stride`) so the stable index sits at byte 1.
5. **A `reverse=True` sort is not a reversed sort.** Python keeps first-appearance order for
   equal keys. Invert only the *key* comparison and keep `orig_idx` ascending, which makes the
   predicate branch-free (`or (icmp slt a b) (and (icmp eq a b) (icmp slt ia ib))`) with no
   `phi` and no control flow.
6. **Clang >= 18 contracts `a*b+c` into `fma` by default at `-O2`.** That changes the last bits
   of every `float` result relative to Python, Rust, and interpreter semantics, breaking
   byte-identical benchmark comparisons (`benchmarks/nbody_float.c`). Pass
   `-ffp-contract=off` from the driver *and* from `benchmarks/run.sh` — contract only where the
   source uses an explicit `fma`.
7. **Match Python's `%` when comparing against a C reference.** C truncates toward zero,
   Python floors toward `-inf` (`-426 % 7 == 1`, `-426 % 7 == -6` in C). Every cross-language
   benchmark checksum that folds a possibly-negative remainder needs an explicit floor.

