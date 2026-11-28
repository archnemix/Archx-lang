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


---

## Round 13 — v1.0 Backlog, Phase P0: Leaks, Trapping `int`, and the Dialect Directive

### 1. AX-001 — Memory Leaks (`src/codegen/{comprehensions,loops}.rs`, `ci/leakcheck.c`)

The audit attributed the leak to "a vec in `user_main`". That was wrong. Reproducing with an
allocator-wrapping harness and `addr2line` on the backtrace showed the leaks were in *three*
unrelated places, all in the collection pipeline:

1. **Comprehension growth.** `eval_list_comp` reserved the probed length as `cap`, but `push`
   grows when `len >= cap`. An unfiltered comprehension over `range(n)` therefore grew exactly
   once — on its *last* element — allocating a fresh block, copying into it, and dropping the
   pre-sized block. Fix: reserve `capacity + 1` so the common case stays on the single
   pre-sized allocation.
2. **`min`/`max` over a generator.** The sequence was materialized and then handed to
   `claim_stmt_temp`, which removes the temporary's drop *without freeing it*. The buffer is now
   released explicitly.
3. **For-each loop variable.** Python rebinds the loop variable in the *enclosing* scope, so the
   slot outlives one iteration. Every iteration stored a fresh clone over the previous value
   without dropping it, leaking one element buffer per iteration. The slot is now zero-initialized
   once and the previous binding is dropped before the new clone is stored.

**Why a new leak gate.** ASan's runtime does not link against Archx IR in this sandbox
(`__asan_unregister_elf_globals`), and a check that silently cannot run is worse than no check.
`ci/leakcheck.c` wraps the allocator and exits non-zero if any block is live at exit; a test feeds
it a deliberately leaky C program and asserts it *fails*, so the gate cannot rot into a no-op.

### 2. AX-002 — Silent Integer Wrapping (`src/codegen/expr.rs`, `runtime.rs`)

`int` wrapped silently: `MAX + 1` printed `-9223372036854775808` and exited 0. Native `int` is now
a trapping `i64` (`llvm.{sadd,ssub,smul}.with.overflow.i64` + a cold `@archx_int_overflow_fail`).

**Constant folding had to change too.** The folder used `wrapping_add`/`wrapping_mul`, so a literal
expression like `MAX * 2` was folded at compile time and the runtime check could *never* fire. It
now uses `checked_*` and leaves an overflowing fold unfolded, so the emitted check traps.

**The rejected speed-up.** Deferring the check to the end of a basic block (one `br` per region
instead of per operation) measures faster, and it was briefly implemented. Measurement killed it:
`print(MAX + 1)` printed the wrapped value *and then* panicked. A trapping language must never
expose the wrapped value, so immediate checks were restored. The honest cost is ~12 % on
`benchmarks/composite` (24 → 27 ms), where the program's own dataflow is a chain of live field
accumulations; `nbody_float`, `dict_bench`, `full_tour_pythonic` and `pipelines` are unchanged.
The correct recovery is a range proof on provably-safe arithmetic, reusing the
`loop_bounds`/`proven_bound` machinery that already powers bounds-check elision — that needs a
proof object on the IR, so it is tracked rather than guessed at.

Two implementation traps worth remembering: the deferred form leaked pending state across
function and helper-body boundaries (the helpers save/restore `next_tmp`/`next_label` but not new
fields), which produced `br i1 %t155` in a *different function*. Any new codegen-wide mutable
field must be added to those save/restore points or reset per function body.

### 3. AX-013 — The Dialect Directive (`src/dialect.rs`, `src/main.rs`)

The blocking discovery: **the lexer discards comments**, so the required
`# archx: dialect=…` first line was unrepresentable — there was no place to read it from. The
directive is therefore resolved from the source text by a dedicated module *before* lexing, which
is the only correct place: it is a property of the file, not of the token stream.

Design decisions:

* `DialectSpec { dialect, version, source }` lives on `ast::Program`, so later passes read the
  contract instead of inferring it. `source` records whether the `--dialect` flag overrode the
  module, so a diagnostic can explain which rule applied.
* `DialectRules` is a plain table (`arbitrary_precision_int`, `trapping_int_overflow`,
  `unicode_code_points`, `python_modulo`, `bit_identical_floats`). Passes consult the table rather
  than testing syntax, which is what stops a compat-only feature from changing native behaviour.
* `E0100` = no directive; `E0101` = malformed or unsupported directive. Keeping them distinct
  matters because "you forgot the header" and "your header is wrong" need different fixes.
* `--dialect` overrides a *present* directive but cannot substitute for a missing one, so no
  program can be compiled against a contract it never declared.

**The 1:1 invariant had to be preserved, not sacrificed.** `full_tour.py` and
`full_tour_pythonic.archx.lang` were byte-identical, and both `benchmarks/run.sh` and a CLI test
asserted it with `cmp`. Rather than drop the check, the comparison is now
"identical *below* the directive line", and the header itself is verified separately. A stray edit
anywhere in the body still fails.

**Test-harness decision.** Inline test sources are wrapped by `with_native_directive`, so each test
states the contract it is written against instead of relying on a default. Sources that already
carry a directive are passed through, which is how a test opts into `compat`. The blanket rewrite
initially over-matched two non-Archx files (a generated `.ll` and the C sources of the leak
harness); both were caught by the suite and reverted.

---

## Round 12 — AX-004 & AX-010: Zero Warnings, One `for…else` Node, and the Dialect Flag in the IR

**AX-010 — one AST node for `for…else`.** `StmtKind::ForElse` was never constructed: `For`,
`ForEach`, `ForEnumerate`, `ForDictItems`, `ForZip` and `ForTupleUnpack` each already carry
`else_body: Option<Vec<Stmt>>`. Keeping the variant meant nine match arms (analysis, generics, the
parser's call-rewriting and value-return walks, statement lowering) described a node no parser could
produce — a second representation of the same syntax that no test could ever cover. It was removed
rather than populated: making it canonical would have meant moving every `else_body` off the loop
nodes, a large refactor whose only product is the same IR.

**A line-oriented regex cannot delete a Rust match arm.** The first attempt ran a pattern over four
files and stripped only the header line of each multi-line arm, leaving orphaned bodies
(`error: unexpected closing delimiter`). `git checkout --` restored the files and each arm was then
removed by exact-block replacement. `codegen/mod.rs` also needed a real fix rather than a deletion:
its or-pattern ended in `StmtKind::Region { body } => find_global_assigns(...)`, so removing the last
alternative left the pattern without a `=>`.

**AX-004 — 15 warnings to 0, gated.** Dead helpers (`emit_pack_dict_key`, `clauses_carry`,
`param_as_expr`, `declare_loop_var_in_outer_scope`, `forget_drop_target`) were deleted, not
`#[allow]`ed; parameters no callee ever read (`arr_name` in `emit_list_push_raw`/`emit_list_scan_var`,
`span` in four loop helpers) were removed from the signatures so a future caller cannot pass a value
that is silently ignored. The gate is `RUSTFLAGS="-D warnings" cargo build --all-targets` on Linux
**and** both cross-platform runners, because a warning that only appears under a different target is
exactly the class of defect a single-OS gate misses.

The last three warnings were `src/dialect.rs`'s `Dialect::name` and `DialectRules`, and they were a
signal, not noise: AX-013's acceptance says the IR must carry `!archx.dialect`, which nothing emitted.
Two of the three are now consumed for real — `name()` spells the flag and `DialectRules` was removed
because nothing read it (AX-016 replaces it with the table that passes actually consult). The flag is
`llvm.module.flags` metadata with behaviour bit `1` (`Error`), so linking a compat object against a
native one fails instead of choosing one `int` definition silently; a named node `!archx.dialect =
!{"native"}` was rejected by the LLVM verifier (`expected integer`) — module flags are the only
metadata form a frontend may use for a module-level property.

**AX-005 — the binary problem was three times the reported size.** The work order named two tracked
executables; scanning every tracked blob for ELF/Mach-O/PE magic found **six**: `bw`,
`call_and_loop_semantics`, and four bare build outputs (`d1`, `full_tour_pythonic`, `hello`,
`pipelines`) that `benchmarks/run.sh` produces. A name-based check (the obvious implementation) would
have removed the two named files and left four loaded executables in history. `file(1)` is not
installed in this sandbox either, so the gate became `tools/check_binaries.py`, which reads the first
four bytes of each `git ls-files` entry. It was proven to fail on a planted ELF before being wired
into CI — a gate nobody has watched fail is not a gate.

