<!-- Chronological engineering reasoning log: design trade-offs, bugs encountered, root causes, and exact fixes. -->

# Engineering Thinking Log

Updated after each round of work per `docs/Rules.md`.

---

## Round 1–4 — Foundations, Loops, and LLVM-Direct Array Lowering (`v0.1.0` – `v0.4.0`)

- **Why textual LLVM IR + `clang -O2` instead of `inkwell` / `llvm-sys`**:
  - Zero native C++ build-script dependencies (`llvm-config` version mismatches disappear), zero external crates, instant compiler builds, and human-readable `--emit-ir` output.
- **Problem**: Early `[T]` array loops ran slower than raw C because per-element bounds checks created multi-exit loops that blocked LLVM's `LoopVectorize`, and untargeted LLVM IR defaulted 64-bit loads/stores to `align 4`.
- **Root cause & fix**:
  1. Added explicit `align 8` / `align 1` on all loads/stores and `noalias align 16` on `@malloc`/`@calloc`.
  2. Enforced `0 <= count <= 2^47` at allocation in a single unsigned `icmp ugt`, eliminating negative lengths and `count * sizeof(T)` wrap simultaneously.
  3. Implemented **Range-Guarded `for` Loop Versioning** (check `end <= arr.len` once in preheader → single-exit `for.fast`) and **Monotonic Strided `while` Versioning** (Sieve inner loop lowered to the exact 5-instruction loop as raw unchecked C while keeping 0 UB).

---

## Round 5 — Milestone 5 (`struct` SoA, `region:`, 16B Prefix-SSO `str`) & Safety Hardening (`v0.5.0`)

### 1. Beating C and Rust on Struct + Arena + String Workloads without UB
- **Design**:
  - **Transparent AoS-to-SoA**: C and Rust store `Body { x, y, z, vx, vy, vz }` (`48 B`) interleaved (AoS), wasting 33% of every cache line when updating only `x, y, vx, vy` and requiring SIMD `shufflevector` blends. Because Archx has value semantics and no raw interior pointers, `try_emit_transparent_soa` lowers non-escaping fixed-length scalar `[Struct]` locals into separate `align 16` planes per field.
  - **16-byte German/Umbra Prefix-SSO `str`**: `{ len:u32 | prefix4:[u8;4], inline8_or_tagged_ptr:i64 }` stores `<= 12 B` strings completely in 2 registers and tags `> 12 B` pointers in low 2 bits (`00` static, `01` heap, `10` region).
  - **Scoped `region:` 64 KB bump arenas**: Bump pointer allocation inside cached 64 KB slabs with compile-time escape rejection (`check_region_escape_target`) and automatic heap promotion on `return`.

### 2. Problems Encountered & Exact Solutions
1. **Debug test-thread stack overflow on pathological `not not ...` nesting**:
   - *Problem*: Rust `#[test]` worker threads use a 2 MB stack in debug mode; 512 recursive parser frames overflowed before hitting the depth guard.
   - *Solution*: Rewrote `Parser::parse_unary` (`not` and `-` chains) iteratively with a `Vec<(UnOp, Span)>` stack and set `MAX_NESTING = 128` in both parser and codegen.
2. **Keyword collision with `step` (`func step(...)`)**:
   - *Problem*: Making `step` a global lexer keyword broke user functions and variables named `step` (`tests/cli.rs::out_of_bounds_panics_cleanly`).
   - *Solution*: Kept `step` as a normal `TokenKind::Ident("step")` in the lexer and matched it contextually inside `Parser::parse_stmt` only immediately after `for <var> in <start>..<end>`.
3. **ASan + LSan 512-byte leak in `examples/structs_regions.archx.lang`**:
   - *Problem*: Inside `region:`, `ArrayRepeat` skipped pushing onto `stmt_temps`. When `StmtKind::Let` subsequently called `claim_stmt_temp(&val)`, it returned `false`, misleading `Let` into thinking the rvalue was an existing variable that needed `@archx_vec_clone_i` — allocating an unowned 512 B heap copy!
   - *Solution*: Unconditionally registered fresh rvalues (`ArrayLit`, `ArrayRepeat`, `emit_str_concat_call`) in `stmt_temps` even inside `region:` (dropping an unclaimed region `%ArchxVec` is a safe no-op because region buffers are not registered as heap `owned_buffers`, while `claim_stmt_temp` now returns `true` and avoids the spurious heap clone). Verified `0 leaks, 0 invalid accesses` across all 3 targets under ASan + LSan.
4. **Inlining `@archx_str_concat` + Fast Root-Slab Cursor Rewind (`ci/out/bench_composite.opt.ll`)**:
   - *Problem*: Inspecting `bench_composite.opt.ll` showed `@archx_region_alloc` (65 lines) bloated `@archx_str_concat` past LLVM's inline threshold, and restoring `saved_cur = null` on outermost `region:` exit forced round `1..39,999` through `check_reuse`.
   - *Solution*: Split multi-slab fallback into `noinline` `@archx_region_alloc_fallback` (shrinking `alwaysinline` `@archx_region_alloc` to 14 lines), marked `@archx_str_concat` `alwaysinline` with explicit `and i64 %rp_i, -4 | 2`, and added `@archx_region_rewind_root` (`cur = head + 16`). LLVM folded `"id_" + s_rhs` (`9 B`) into pure register ops, dead-eliminated `@archx_str_drop`, and promoted `cur`/`end` into loop `phi` registers — bringing `composite` down to **`14 ms` vs C `16 ms` and Rust `18 ms`**.

---

## Round 6 — Codebase Modularization, Multi-OS Compatibility & Project Governance (`v0.5.0`)

- **Problem 1 — Monolithic `src/codegen.rs` (6,398 lines)**:
  - Violated single-responsibility modularity rule before starting Milestone 6.
  - *Solution*: Split `src/codegen.rs` cleanly into 10 focused submodules under `src/codegen/` (`mod.rs`, `stmt.rs`, `loops.rs`, `expr.rs`, `calls.rs`, `ownership.rs`, `memory.rs`, `runtime.rs`, `analysis.rs`, `tests.rs`), each 127–1,133 lines with concise header comments.
- **Problem 2 — Cross-OS (`Linux`, `macOS`, `Windows`) portability gaps**:
  - `archx file.archx.lang --run` with default output `"file"` invoked `Command::new("file")`, which searches `PATH` instead of `./file` on Unix.
  - On Windows (`x86_64-pc-windows-msvc`), compiling raw `.ll` calling `@printf` via `clang` requires `-llegacy_stdio_definitions` because MSVC's UCRT defines `printf` inline in `<stdio.h>`, and executables use `.exe` + CRLF stdout.
  - *Solution*: Prepend `./` for bare relative `--run` outputs, detect `windows-msvc` target in `src/main.rs` to pass `-llegacy_stdio_definitions` (plus `C:\Program Files\LLVM\bin\clang.exe` discovery), normalize `.exe` and CRLF in `tests/cli.rs`, and configure `.github/workflows/ci.yml` across `ubuntu-latest`, `macos-latest`, and `windows-latest` (3 concurrent runners <= 5 cap) with versioned test logs in `ci/test-history/v0.5.0/`.
