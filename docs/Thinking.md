<!-- Chronological engineering reasoning log: design trade-offs, bugs encountered, root causes, and exact fixes. -->

# Engineering Thinking Log

Updated after each round of work per `docs/Rules.md`.

---

## Rounds 1–6 — Foundations through Multi-OS Modularization (`v0.1.0` – `v0.5.0`)

- **LLVM-direct IR + `clang -O2`**: Zero external crates, `align 16` allocations, `2^47` size invariant, range-guarded `for` versioning, and monotonic strided `while` bounds-check elision.
- **Milestone 5 (`v0.5.0`)**: Transparent AoS-to-SoA planarization, 16-byte German/Umbra prefix-SSO `str`, scoped 64 KB `region:` arenas with root cursor rewind & `return` heap promotion, recursive RAII drops (`0` ASan+LSan leaks), modularized `src/codegen/`, and 3-OS (`Linux`, `macOS`, `Windows`) CI.

---

## Round 7 — Milestone 6: 1:1 Pythonic Syntax, Console I/O, `float`, `class` Methods & Suite 4 (`v0.6.0`)

### 1. Architectural Choices for Zero-Overhead Pythonic Semantics
- **Implicit Python variable declaration (`x = expr`) without sacrificing SSA registers**:
  - `analysis::collect_mutated_vars` runs a two-state (`seen` vs `mutated`) pass: the *first* `AssignTarget::Var(x)` in a function is recognized as variable introduction, and `x` is only marked `mutated` if reassigned later or inside a loop (`loop_depth > 0`) before first outer sight. Thus single-assignment Python variables (`dt = 0.01`, `fi = float(i + 1)`) compile directly to pure SSA values (`VarStorage::Imm`) with zero stack `alloca`s!
- **LEGB Soft Built-ins (`sum`, `min`, `max`, `abs`, `sqrt`, `ord`, `chr`)**:
  - Reserving `sum` as a hard keyword would break user functions named `def sum(xs: list[int]):`. Instead, user `self.funcs` is checked *first*, falling back to built-in intrinsics only when unshadowed — matching Python's LEGB rule.
- **Dual-ABI `self` Methods + Transparent `float` SoA**:
  - Read-only `class` methods (`def kinetic(self) -> float:`) take `%ArchxStruct_Body` by value in registers, allowing `bodies[i].kinetic()` on a SoA array to assemble fields directly from the `align 16` `double*` planes and inline into `<2 x double>` SIMD (`ci/out/bench_nbody_float.opt.ll`). Mutating methods (`def inc(self, ...):`) pass `ptr %arg.self` with `is_param: true` for zero-copy in-place field updates.
- **Portable ISO C89 Runtime (`Windows MSVC` + `Linux` + `macOS`)**:
  - Windows UCRT defines `snprintf` inline in `<stdio.h>`; `@archx_fmt_float_buf` uses `@sprintf` (`%.15g`, max 24 chars into `[64 x i8]`) and appends `.0` when no `.`/`e`/`n`/`i` is present so `print(2.0)` outputs `2.0` just like Python. `@archx_input` uses `@fflush(ptr null)` + `@getchar()` with a 64B stack fast path and heap growth for arbitrary line lengths.

### 2. Bugs Caught During Implementation & CI Verification
1. **`%ArchxStr` SSO Length Extraction in `for ch in s:` (`src/codegen/loops.rs`)**:
   - *Root cause*: Initially masked `w0` with `lshr i64 %w0, 2` thinking the 2-bit storage tag lived in `w0`; in Archx's German/Umbra SSO layout, `w0` stores unshifted `len: u32 | (prefix4 << 32)` while the 2-bit tag (`0` static, `1` heap, `2` region) lives in `w1 & 3` when `len > 12`.
   - *Fix*: Used `and i64 %w0, 4294967295` for `len` and `and i64 %w1, -4` for long string pointer extraction across `loops.rs` and `runtime_py.rs`.
2. **Negative & Dynamic `range(start, stop, step)` Loop Condition (`src/codegen/loops.rs`)**:
   - *Root cause*: Rust's `dead_code` warning on `StepDir::Dynamic(String)` immediately flagged that `gen_for`'s `cond_label` still emitted `icmp slt` unconditionally instead of branching on `StepDir::{PosConst, NegConst, Dynamic(is_pos)}`.
   - *Fix*: Matched `StepDir` in `cond_label` (`PosConst => slt`, `NegConst => sgt`, `Dynamic(is_pos) => select i1 %is_pos, %lt, %gt`).
3. **Missing Incoming Edge in `@archx_str_split_sep` PHI Node (`src/codegen/runtime_py.rs`)**:
   - *Root cause*: In `@archx_str_split_sep`, `%start = phi i64 [ 0, %init ], [ %next_start, %pushed ]` omitted the self-edge `[ %start, %no_hit ]` when advancing `%cur` by 1 byte on non-matching characters.
   - *Fix*: Added `[ %start, %no_hit ]` to `%start`. All 32 unit tests + 18 CLI integration tests, ASan+LSan across 5 targets, and all 4 C/Rust/Archx benchmark suites passed across Linux, macOS, and Windows.
