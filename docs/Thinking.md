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

**AX-003 — the stale numbers were not just stale, they were flattering.** Regenerating the README
table from `ci/out/benchmarks.txt` exposed three separate misstatements that no test could catch
because nothing compared prose to an artifact:

* the quoted range `4.1×–69.8×` covered only the suites where Archx wins; Suite 1 (`primes`) is
  **0.3×**, slower than CPython, and the old text simply did not mention it. The range is now over
  Suites 2–7 with a different denominator (`4.0×` is `pipelines`, not `dict`), and the losing suite is
  named in the same sentence;
* `full_tour` was described as "beating `clang -O2` `25 ms` and `rustc -O` `19 ms`" — the very CI
  report the sentence cites has C at **12 ms** and Rust at **17 ms**, i.e. Archx ties Rust and loses
  to C. The sentence now states the comparison without claiming a win;
* the test count (`68`) was four tests behind, and the version was `0.9.0` in `Cargo.toml`,
  `benchmarks/run.sh` and the report header while the docs claimed `v0.9.1`.

The fix is structural rather than textual: `tools/sync_readme_benchmarks.py` owns the table *and* the
two claim sentences, `tools/check_test_count.py` owns the count, and CI runs both with `--check`.
Both gates were watched failing (an injected `999 ms` row, and a mismatched count) before being
trusted. A prose number is only as good as the check that recomputes it.

**AX-009 — "it compiles" was never the same claim as "it verifies".** The two v0.9.1 bugs (a `%` helper
whose `phi` lacked a predecessor, the `%ArchxAny` binop dispatch) were ill-formed IR that `clang`
reported only when a program walked into that helper. `ci/verify_ir.sh` now feeds every example, every
benchmark and a targeted corpus of nine programs to clang's IR parser/verifier and names the file that
emitted a bad module. Two constraints shaped it: `llvm-as`/`opt` are not on either image, and `-x ir`
is not a language clang accepts, so the gate relies on the `.ll` extension and `clang -c`.

The corpus has exactly one copy — `src/codegen/tests.rs::RUNTIME_CORPUS` — which the unit test lowers
(so a feature that cannot even produce IR fails the Rust suite) and writes to `ci/out/runtime-corpus/`
for the shell gate to verify (so a feature that produces *wrong* IR fails here). A duplicate list in
the shell script would have been two definitions of "every runtime feature" that could drift apart.
The gate was watched failing on a planted `%nonexistent_label` phi before being wired into CI.

---

## Round 13 — AX-002: the trapping contract had three more holes, found by writing the test first

The work order asks for a *differential* test: every overflowing operation must trap. Writing it
turned up two defects that the existing `MAX + 1` / `MAX * 2` checks could not catch, because they
were on different code paths than the ones already covered:

1. **`abs(i64::MIN)` printed `-9223372036854775808`.** The naive lowering was `select (val < 0)
   (0 - val) val`, and `0 - i64::MIN` wraps to itself, so the "absolute value" came back negative —
   the precise failure mode the trapping contract exists to prevent: a plausible wrong answer with no
   signal. Negation now goes through `llvm.ssub.with.overflow` and traps. The constant folder agrees.
2. **`2 ** 63` printed `-9223372036854775808`.** Integer `**` was lowered as an unchecked binary
   exponentiation loop with plain `mul`. Both multiplies now use `llvm.smul.with.overflow`.

Fixing (2) surfaced the interesting part: a *conservative* check here is wrong, not merely slow.
`2 ** 40` squares the base past the top bit in the final iteration and never reads it, and
`(2 ** 40) ** 2` overflows only in a squaring step whose result is dead. So the flags are gated on
whether the value is used at all — the product is checked only when the current exponent bit is 1,
the squared base only when another iteration follows (`e2 != 0`). With that gating, `2 ** 40`,
`2 ** 62`, `(-2) ** 63` (= `i64::MIN`, representable) and `1 ** 100` all answer correctly, while
`2 ** 63`, `(2 ** 40) ** 2` and `3 ** 40` trap. Both directions are asserted in
`tests/cli.rs::overflowing_integer_operations_trap_instead_of_wrapping`, because a check that fires on
a representable result is just as much a bug.

**On "is there more optimization to get?"** — I measured instead of assuming. `-O3`, `-O3` with a
larger unrolling threshold, `-march=native` and `-ffast-math` were all built from the same `.ll` and
timed on four suites (`docs/OPTIMIZATION_AB.md`). Every delta was inside noise except a 2% change on
an 8.5 ms program, and all variants produced byte-identical stdout. So the default stays `-O2`, close
overflow/bounds-checked code being exactly where one wants the fewest new transformations, and the
level became an explicit, validated `-O <0|1|2|3|s>` flag instead of a hard-coded argument. `-ffast-math`
is refused on principle (it breaks the CPython-identical float contract), and `-march=native` on
portability (the artifact would depend on the build host). I also verified at both `-O2` and `-O3`
that an out-of-bounds read and a loop overflow still trap, i.e. the optimizer is not deleting checks.

---

## Round 14 — AX-007/AX-008: a conformance harness that immediately paid for itself

The valuable design decision was that **one file is both programs**. Each probe starts with
`# archx: dialect=compat, version=1`, which Python reads as a comment, so `python3 probe.py` and
`archx probe.archx.lang` run the *same bytes*. Hand-writing a `.py` and an `.archx.lang` pair would
have let the two drift, and a drift is indistinguishable from a conformance bug.

The harness found two real contract violations within minutes of existing:

1. compat printed `true`/`false`; CPython prints `True`/`False`. The `bool` words now come from
   `Dialect::bool_words`.
2. compat printed `[a, b]` for a `list[str]`; CPython prints `['a', 'b']`, because a container renders
   its elements with `repr()` while `print` renders them with `str()`. Fixing this properly needed a
   new `in_container` parameter on `emit_print_inline_val` — the first attempt made *every* string
   print quoted (`'archx'`), which the probes caught immediately. That distinction (`print('a')` vs
   `print(['a'])`) only exists because the harness compares real CPython output.

**xfail with a mandatory reason, and xpass fails too.** A probe that does not reproduce CPython carries
`# conformance: xfail <reason>`; the reason is required, and `docs/LIMITATIONS.md` is *generated* from
those markers. A gap that gets fixed turns into an "unexpected pass" and fails CI until the marker is
deleted, so the limitations document cannot rot in either direction. This is the only way I could see
to keep a known-limitations list honest: it is derived from measurement, not from memory.

Result: 104 probes, 64 reproducing CPython exactly, 40 documented gaps, 0 undocumented divergences.
Two of those gaps are internal compiler errors (`list.insert`/`list.index` on a list with no storage
slot) and are recorded as such rather than dressed up as "not implemented".

**Portability bug the harness exposed in itself.** `tests/conformance.rs` first derived the compiler
path from `current_exe()`, assuming `target/<profile>/deps`. On the CI runner Cargo placed the test
binary under `target/debug/build/archx/<hash>/out/`, so the harness looked for a compiler that was
never there. The fix is `env!("CARGO_BIN_EXE_archx")`, which is Cargo's own answer to "where is the
binary this crate builds" and is correct on every profile, OS and layout. Worth recording because the
mistake is invisible locally and only a different runner surfaces it.

**Toolchain currency.** The sandbox's Rust index offers exactly one version, 1.97.0, and that is what
is installed; the C toolchain is clang 22.1.8 (via zig). CI tracks `dtolnay/rust-toolchain@stable`, so
the runners are at least as new. The optimization A/B in `docs/OPTIMIZATION_AB.md` was therefore taken
on current LLVM, and the `-O2` default is a measurement from this toolchain rather than a habit carried
over from an older one.

---

## Round 15 — AX-012: reproducibility as a safety property, not a nicety

I expected AX-012 to be paperwork (pin a version, hash a file). Running the check first turned up two
real defects, and both were *silent*:

1. **`HashMap` order reached the output.** `expand_generics_and_lambdas` collected monomorphized
   functions, structs and lifted closures in `HashMap`s and appended them with `into_values()`, so the
   order of `define` blocks in the module changed between runs. LLVM's backend assigns symbol numbering
   and lays out code in input order, so the *binaries* differed too — not just the text. Switching the
   three maps to `BTreeMap` fixed it in one line each; the maps are drained once, so it costs nothing.
2. **The temp filename was in the shipped binary.** clang names the object's file symbol after the file
   it was handed, and Archx hands it `$TMP/archx-<pid>-<n>.ll`. Every executable therefore carried a
   different string, and a sandbox path. The fix is `source_filename` in the IR — which also means
   `--emit-ir` now says which source it came from, so the module is self-describing.

Neither bug is a security hole, but both violate the property I want to be able to state: *the artifact
is a function of the source text*. Without that, no speed measurement is trustworthy — you cannot tell
a 2% win from a 2% reshuffle. That is why the gate compares **binaries**, not just IR, and why it also
runs one compilation in a separate process with a different hash seed: same-process comparisons cannot
see a per-process seed.

`MALLOC_PERTURB_` and the extra seed run are cheap, and they close the class of bug rather than the two
instances I happened to find.

## Round 16 — AX-002 truth: is `-O2` still the right default on LLVM 22?

The user asked to use the latest LLVM optimisations and to check which toolchain is actually in use, so
I re-measured rather than trusting the earlier table. Environment: **rustc 1.97.0** (the only version the
index offers here) and **clang 22.1.8**. `docs/OPTIMIZATION_AB.md` re-run:| suite | `-O2` best | `-O3` best | delta |
|---|---:|---:|---:|
| composite | 27.8 ms | 28.4 ms | +2.2% (worse) |
| nbody_float | 48.2 ms | 47.5 ms | −1.4% |
| pipelines | 8.7 ms | 8.6 ms | −1.1% |

Nothing repeatable, so `-O2` stays. I also measured `-fno-math-errno`, a flag that is *contract-safe*
(it asserts nobody reads `errno` after a math call, which is true of every Archx program) rather than a
relaxation like `-ffast-math`. Result: −0.2%, −2.6%, 0.0%, −0.4% across four suites — all inside the
spread. Not adopted. The discipline I want here is that a flag earns its place with a measurement, not
with a plausible argument; the numbers are in `docs/OPTIMIZATION_AB.md` so the next person does not
have to re-litigate it.

The genuinely useful conclusion from this round is that **the remaining performance work is not in
compiler flags** — it is in the IR Archx emits and in the checks it can prove away. Flags moved nothing;
removing a bounds check from a hot loop would. That is where the next optimization work should look.

---

## Round 17 — AX-011: codes that are a closed set, not a string prefix

The acceptance criterion is "every diagnostic has a code". The obvious implementation is to visit all
465 `Diagnostic::new(...)` sites and write the code into each message. I did not do that, for two
reasons:

1. **It makes the taxonomy everybody's business.** Every future `Err(...)` re-decides which code
   applies, and nothing notices when two sites disagree. The mapping belongs in one place.
2. **It conflates "the code" with "the text".** If the code lives inside the message string, then
   rewording a message changes the code, which is the one thing a code must not do.

So `src/diagnose.rs` holds a single ordered table: message fragment → code, specific rules before
general ones (`internal error … slot` before anything mentioning `expects`). `Diagnostic::new`
classifies. The message stays the precise, human-facing description; the code becomes a small closed
set (37 codes) that tooling can switch on.

The catch with a hand-written table is drift, and the answer is a test that reads the compiler's own
source: `tests/error_codes.rs` extracts every diagnostic literal (handling multi-line strings, `r#"…"#`,
and `format!` templates) and fails if any does not classify. It passes on all 464 literals today, and
adding an uncoded diagnostic now turns CI red. That test is the difference between "we coded the errors
once" and "no error can ship uncoded".

Two smaller decisions worth recording:

* **`E09xx` means "we broke".** Internal invariants get their own range and an `internal: true` flag in
  JSON, so a report is never ambiguous about whose fault it is. That flag matters because the alternative
  — reporting a compiler bug as a type error — sends users debugging code that is correct.
* **The output is rustc-shaped.** `error[E0402]: …` with a span and a caret. I chose that over inventing
  a format because every editor and CI log parser already understands it, and because it makes the code
  the most prominent token on the line, which is the whole point of having codes.

`docs/ERROR_CODES.md` is generated from `archx --explain`, with a drift gate, for the same reason the
benchmark table and the limitations list are generated: a document that restates behaviour will
eventually describe a compiler that no longer exists.

---

## Round 18 — AX-002: the audit that matters is "is this claim true?", not "does it pass?"

AX-002's remaining item was an opt-out (`wrapping_*`), which is the pleasant half: hashing, PRNGs and
checksums genuinely mean modular arithmetic and previously had no legal way to say so. The
implementation is small, and three decisions make it an opt-out rather than a hole in the guarantee:
native-only (a `compat` module promises arbitrary-precision `int`, where wrapping is simply a wrong
answer, so it is `E0802` there rather than a silent yes), recorded in the module flags so the artifact
admits what it did, and *local* — only the operations you wrap can wrap.

The unpleasant half was the acceptance clause I had been treating as already satisfied: **"no `add nsw`
without a proof"**. I re-read every `nsw` in the backend to check it against that sentence rather than
against the tests, and that found three defects, two of which no test could have caught because
undefined behaviour is invisible until an optimiser decides to use it:

1. `int / int` computed `|x|` by negating to choose between the fast and corrected float paths.
   `sub nsw i64 0, x` is **poison** when `x == i64::MIN` — so LLVM may conclude the branch that reads
   it is unreachable and delete the correction term for exactly the operand most in need of it. The
   output was correct on this LLVM release, which is precisely why a test would not have found it.
   Replaced with a total sign-split comparison that never forms a negation.
2. `hex`/`oct`/`bin` did the same unconditional negating on a user value; now a plain `sub`, whose bit
   pattern *is* the unsigned magnitude the digit loop consumes.
3. Removing the `nuw nsw` from the list-copy and search counters was free: those counters are bounded
   by a length that was already checked, so the attributes bought nothing and only added claims.

Verifying (2) surfaced a genuine, user-visible bug that had been shipping: the digit loop selected a
letter when the **base** was 16 instead of when the **digit** was ≥ 10, so `hex(1)` printed `0xX` and
`hex(16)` printed `0xXW`. Every small value that was not already a letter came out wrong. The
conformance harness had not caught it because every probe value I happened to write (`255`, `4095`,
`0xff`) was already in the letters-adjacent range — a reminder that a differential harness only tests
the values you think to write. The corpus now starts at zero and includes `i64::MIN`/`MAX`, negatives,
and the `:x`/`:X`/`:o`/`:b` format specs.

The lesson I want to keep: **an audit has to be phrased as a question about the artifact, not about the
test suite.** "Do the tests pass?" would have passed. "Is every claim in this IR true?" found three
bugs, one of them visible to users.

## Round 19 — AX-016: a table is only useful if something is forced through it

The tempting version of this work order is to write `DialectRules` as a struct full of fields, have
codegen read the fields, and declare victory. I did something narrower and, I think, more useful:
treat the matrix as **data** (`ROWS`) and make `value(rule, dialect)` the only accessor, then
*hierarchically reduce* the existing checks to reads of it. `Dialect::bool_words`, `container_repr` and
the `wrapping_*` gate are now one line each, and no backend code compares the dialect enum any more.

The part I want to record is the honesty problem I hit. My first pass listed eight rules and marked all
eight `enforced`. Four of them were not: `str` indexes by byte today, `1 + 1.5` is rejected rather than
widened, `7 / 2` is `3.5`, and a runtime failure traps instead of raising. None of that is a secret —
it is in `LIMITATIONS.md` — but a *matrix* that says `enforced` on those rows would be a new lie, and a
generated document cannot be corrected by editing it. So the row carries its own status, the docs print
`planned`, and a test asserts the specific rows that must remain `planned` cannot silently flip.

That also settled the "shared rule" question. `int overflow` and `int division` have the *same* value in
both contracts, so they are not divergences — but they are the two questions a reader actually asks
("does `int` overflow under compat?"). Keeping them with a test that asserts their values still coincide
means a future divergence is a one-cell change, and it keeps `6 of 8 rules differ` a generated number
rather than a claim.

`render_matrix` iterates `all()` and `is_enforced()` rather than the raw rows, which is the detail that
keeps the printed order and the table from drifting apart — and it is what makes both functions used,
so `deny(dead_code)` cannot be satisfied by an unused helper.

## Round 20 — AX-017: a gate that cannot be green by doing nothing

The work order asks for `archx check --against-python` and says CI must fail on any diff. Written
naively, three of those words are traps, and each one produces a gate that passes without checking
anything:

1. **"all 94 probes pass"** — but 40 of the probes are *documented* gaps marked `xfail`. A gate that
   demands every probe match is red forever and gets deleted within a week. So the check reads the same
   `# conformance: xfail <reason>` marker the harness reads, and — the part that matters — a marker that
   *starts* matching is a **failure** (`stale xfail`), because the only thing worse than an unfixed gap
   is a list of gaps that lies about itself.
2. **"compare with CPython"** — but a compat module *traps* where CPython raises; that is the documented
   `runtime failure` row. Comparing exit codes or stderr would make the tool unusable on the programs
   people actually write, so only stdout is judged, and the exit code is still printed so nothing is
   hidden. Judging less is what makes judging reliably possible.
3. **"CI fails on any diff"** — a runner without `python3`, or a file that is not Python at all (a native
   module with `with region:`), must not look like agreement. Exit 2, and `<skipped/>` in the JUnit
   report, so "nothing ran" and "everything agreed" are distinguishable by a machine.

The interesting design question was *where the reference answer comes from*. I could have shelled out
to the harness, but then the tool would only work inside this repository. Instead the compiler reads the
file itself: the fact that a probe is one file for both languages is the whole trick, so the gate is a
first-class feature rather than a test fixture.

Two details I want to keep. **The attributed rule is a hint, and it is narrow on purpose**: `attribute`
has to match a concrete shape (`True`→`true`, quotes added inside a container, a trapped overflow, a
truncated quotient) before it names anything. A mismatch that fits no shape is reported as a conformance
bug, because a wrong explanation is worse than none — the user stops looking. And **the compiler under
test is `current_exe()`**, so the gate can never verify a different build than the one invoked.

Finally the numbers: the gate over `tests/conformance` reports *exactly* what the harness reports —
65 matched, 40 xfail, 0 diverged, 0 failed to compile. Two independent implementations of the same
question agreeing is the point; if they ever disagree, one of them is broken and now we hear about it.

## Round 21 — AX-018: a cost note without a rewrite is noise

The work order asks for tier annotation with fix-its, and names four constructs that must produce a
*specific, actionable* warning. "Actionable" is where this kind of tool normally dies: the temptation is
to emit `warning: this expression is slow` for everything dynamic, at which point nobody reads the
output. So each detector here is one concrete shape with one concrete rewrite, and if there is no
rewrite there is no note.

That rule produced the interesting decisions:

* **`if xs:` is not "slow because collections are slow"** — it is a *length load per evaluation*. The
  fix is `if len(xs) != 0:`, and the better fix is to hoist `len` out of the loop. Naming the actual
  operation is what makes the note teach something.
* **`[1, 'a']` is not a type error** — both contracts accept it. It costs a tag check on every read
  because it cannot be `[int]`. The honest fix is "one type per list", and the note has to say *why* a
  tuple is the alternative (position, not type, distinguishes the elements).
* **`2 ** 100` is a `static`-tier note, not a `heap` one.** This surprised me: the expensive thing is not
  allocation, it is that the result is provably out of `i64`, so the emitted chain either traps or (with
  a float seed) becomes an unfolded `llvm.pow`. Same tier as a plain `+`, entirely different problem.
  The tier is about representation; the note is about the specific trap.

I also wrote a test that no fix-it may contain "unchecked", "unsafe", "disable", or "skip the check".
The user's standing rule is that optimisation never trades a safety guarantee, and a *documented*
suggestion to do so is worse than a silent one — so the rule is enforced mechanically rather than by my
memory. Every fix here changes representation, which costs nothing in this language, instead of
changing checking, which costs everything.

Two smaller things worth keeping: the `dynamic` and `collection` sets come from the same syntactic
criterion the backend uses to pick `%ArchxAny`, so the report cannot disagree with what codegen does;
and the analysis runs the front end only, so `explain-perf` works on a file that does not build yet —
which is exactly when you want to know what it is going to cost.

