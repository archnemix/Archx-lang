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
