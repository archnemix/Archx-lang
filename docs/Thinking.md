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

---

## Round 8 — Milestone 7: Planar `<16 x i8>` SIMD `dict` / `set`, Slicing & Two-Tier Adaptive Typing (`v0.7.0`)

- **Planar SIMD SwissTable (`%ArchxDictHdr`)**: Combined `<16 x i8>` SIMD `h2` control-byte probing + single-probe `upsert` (`first_avail` slot tracking) + dense insertion-ordered `keys[]`/`vals[]` planes + inline Prefix-SSO string hashing/equality (`@archx_hash_str`, `@archx_str_eq`), beating both `-O2` C and Rust `std::collections::HashMap` on Suite 5 (`dict_bench`).
- **Smart Two-Tier Adaptive Engine (`analyze_adaptive_types`)**: Keeps homogeneous Pythonic variables and usage-inferred `{}`/`[]` containers in zero-tag Tier-1 types while promoting heterogeneous containers and rebound variables to unboxed 24-byte `%ArchxAny`.

---

## Round 9 — Milestone 8: Zero-Heap Tuples, `T | None` Optionals, Algebraic `enum`s, Exhaustive `match`/`case`, `python3` Benchmarks & 5-Way Comparison (`v0.8.0`)

### 1. Architectural Choices
- **Zero-Heap Value Layouts Across Tuples, `T | None`, and `enum`**:
  - `(T1, T2, ...)` lowers directly to unboxed `{ IR(T1), IR(T2), ... }` LLVM aggregates (`SROA`-friendly in registers).
  - `T | None` lowers to `{ i1, IR(T) }` with flow-sensitive narrowing (`detect_optional_narrowing`) across `if x is not None:`, early-exit `if x is None: return/break/continue`, and ternary `then_expr if x is not None else else_expr`.
  - `enum Name` lowers to stack-inline `%ArchxEnum_Name = type { i64, [W x i64] }` with variant-dispatched recursive RAII drop/clone/region-promotion so heap/region strings and collections inside enum variants have zero leaks.
- **Contextual Soft Keywords (`enum`, `match`, `case`) & Python `def __init__` Inference**:
  - Parsing `enum`, `match`, and `case` contextually preserves 100% backward compatibility with variables named `match` or `case`, while `infer_fields_from_init` + constructor `__init__` dispatch allow standard Python classes (`full_tour.py`) to compile byte-for-byte unchanged (`cmp -s full_tour.py full_tour_pythonic.archx.lang`).

### 2. Bugs Caught & Resolved During CI Verification
1. **Exhaustive `enum` / `T | None` `match` Fallthrough Reachability (`src/codegen/pattern_match.rs`)**:
   - *Root cause*: `gen_match` checked `is_irrefutable_pattern(&case.pattern, &subj_ty)` only on the final `case` arm individually; for `enum Shape` where the final arm was `case Shape.Empty:`, `any_reached_end` was conservatively marked `true` even though `check_enum_exhaustiveness` had already proven all variants covered and every arm returned.
   - *Fix*: Added `is_match_exhaustive(&subj_ty, cases)` covering `Type::Enum`, `Type::Optional` (`None` + irrefutable `Some`), `Type::Bool` (`True` + `False`), and unguarded wildcard/bind arms so exhaustive returning `match` blocks emit `unreachable` at `%match.end` and set `self.terminated = true`.
2. **Expected-Type Specialization for Empty `set()` / `dict()` / `list()` / `tuple()` Calls (`src/codegen/expr.rs`, `analysis.rs`)**:
   - *Root cause*: In `full_tour.py`, `seen = set()` followed by `seen.add(idx)` caused `analysis.rs` to infer `seen: set[int]`, while `ExprKind::Call { name: "set", args: [] }` fell through to `gen_call` returning `set[any]`.
   - *Fix*: Routed unshadowed zero-arg `set()`/`dict()`/`list()`/`tuple()` calls in `eval_expr_with_expected` through `eval_set_lit` / `eval_dict_lit` / `eval_array_lit` / `eval_tuple_lit` with `expected`.
3. **Tuple Destructuring in Systems `let` Bindings (`src/parser.rs`)**:
   - *Root cause*: `full_tour_speed.archx.lang` used `let dict_score, rev_banner = ...`, whereas `parse_let` previously expected a single identifier before `:` or `=`.
   - *Fix*: Extended `TokenKind::Let` parsing to support both `let a, b = expr` and `let (a, b) = expr` via `StmtKind::TupleAssign`. All 37 unit + 23 CLI e2e tests on Linux/macOS/Windows, 11/11 ASan+LSan checks (`0` leaks), and all 6 `Python 3` / `C` / `Rust` / `Archx` benchmark suites passed cleanly (`13 ms` 1:1 Pythonic & `12 ms` Speed vs `298 ms` Python 3.14).

