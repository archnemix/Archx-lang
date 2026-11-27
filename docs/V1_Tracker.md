# Archx v1.0 — Work Order Tracker

Status of the v1.0 backlog (`AX-001`…`AX-128`, phases P0–P8).

**Ordering is mandatory:** `P0 → P1 → P2 → (P3 ∥ P4) → P5 → P6 → P7 → P8`.
P3 must not start before P0 and P1 are green.

Legend: `[x]` complete and verified · `[~]` in progress · `[ ]` not started · `[?]` **wording not recovered — needs the source document** · `[!]` blocked

> **Provenance note.** The full text of `AX-003`…`AX-128` is not in this checkout. The rows marked
> `[?]` record only what the design decisions and scope guards in the backlog's §1 and §3 pin down
> (module split, `DialectRules`, IR builder, tooling names, optimization menu). They are **not**
> verbatim acceptance criteria and must not be treated as complete requirements. Rows marked `[x]`
> or `[~]` are backed by measured evidence in this repository.

---

## P0 — Correctness of the shipped compiler (gates everything else)

| # | Work order | Status | Evidence / notes |
|---|---|---|---|
| AX-001 | Zero memory leaks (comprehension, generator-fold, loop-variable buffers) | `[x]` | 3 independent sites closed (`c840f9a`). `ci/leakcheck.c` added as an independent gate that provably fails on a leak. 20/20 example+benchmark programs report 0 live blocks; 4 did not before. |
| AX-002 | Silent `int` wraparound | `[x]` | `e55ea1d`. Trapping `i64` via `llvm.{sadd,ssub,smul}.with.overflow`; folding uses `checked_*`. `MAX+1` panics (exit 101) instead of printing a wrapped value. |
| AX-003 | Single-source the version number | `[~]` | **Already single-sourced**: `src/main.rs` uses `env!("CARGO_PKG_VERSION")`, so `-V`/`--help` track `Cargo.toml` with no second literal. Remaining scope (docs that hardcode `0.9.0`) needs the original acceptance criteria before I edit prose. |
| AX-013 | Dialect must be an explicit, checked, per-module decision | `[~]` | **Directive layer landed** (`src/dialect.rs`): `# archx: dialect=compat\|native, version=1` on line 1, `E0100` when absent, `E0101` when malformed or unsupported, `DialectSpec` on `ast::Program`, a `DialectRules` table, and `--dialect` that overrides a present directive but cannot substitute for a missing one. All 20 sources plus the test harness now declare a dialect, and the 1:1 `cmp` invariant survives as "identical below the directive". **Remaining:** `NodeOrigin { dialect, span }` on every stmt/expr, and routing the compat/native behavioural differences through `DialectRules`. |
| AX-004 | `[?]` Needs source document | `[?]` | — |
| AX-005 | Add a `LICENSE` file | `[x]` | `LICENSE` added (MIT, matching `Cargo.toml`'s declared `license = "MIT"`, which had no file behind it). |
| AX-006…AX-012 | `[?]` Needs source document | `[?]` | — |

### Open item carried from AX-002

The trapping check costs ~12 % on `benchmarks/composite` (24 → 27 ms). `nbody_float`,
`dict_bench`, `full_tour_pythonic`, `pipelines` are unchanged. Batching the check to the
end of a basic block recovers the cost but **makes the wrapped value observable before the
panic**, so it was rejected. Correct recovery = a range proof on provably-safe arithmetic
(the existing `loop_bounds` / `proven_bound` machinery already powers bounds-check elision),
with a proof object attached to the IR. Not guessed at.

---

## P1 — `[?]` Needs source document

`AX-013`…`[?]`

**AX-013 is the load-bearing item of the whole backlog and is well-specified**, so it is
planned here in full even though its number sits above AX-012:

* `# archx: dialect=compat|native, version=1` must be the first line of every module.
* A missing directive is a compile error (`E0100`). The file extension is a hint only.
* `--dialect` on the CLI overrides the directive.
* `Dialect` is carried on `ast::Program`; every stmt/expr carries `NodeOrigin { dialect, span }`.
* One `DialectRules` table is consumed by lexer, parser, sema, and codegen — no per-pass
  heuristics.
* **compat** = byte-identical stdout to CPython 3.12+ (arbitrary-precision `int`, Unicode code
  points, Python `%`/truthiness/`repr`, first-class `range`/`zip`, `try/except`, `*args`/`yield`,
  classes + inheritance).
* **native** = documented Archx semantics (trapping `i64`, UTF-8 bytes, IEEE `frem`, static
  dispatch, `struct`, `Result[T,E]` + `?`).
* Rule: compat features must never leak cost into native code. CI gate: adding a compat feature
  may not regress native benchmarks by more than 1 %.

---

## P2 — `[?]` Needs source document

---

## P3 ∥ P4 — `[?]` Needs source document

Modularity target stated in the backlog (§3): the 12-crate workspace —
`archx-syntax`, `archx-ast`, `archx-parser`, `archx-hir`, `archx-sema`, `archx-dialect`,
`archx-ir`, `archx-codegen`, `archx-mono`, `archx-runtime`, `archx-link`, `archx-driver`,
`archx-lsp`, `archx-cli` — plus `stdlib/`.

---

## P5 — `[?]` Needs source document

Named tooling from the backlog: the typed IR builder replacing string-concatenated LLVM IR,
with `llvm-as` + `opt -passes=verify` on every emitted module in CI.

---

## P6 — `[?]` Needs source document

Named tooling: `archx check --against-python`, `archx explain-perf`, `archx migrate --to=native`,
`archx fmt`.

---

## P7 — `[?]` Needs source document

Optimization menu: IR attributes, explicit `opt` pipeline, ThinLTO/full LTO, PGO/AutoFDO/CSSPGO,
BOLT, hardened release profile, guarded specialization with deopt.

---

## P8 — `[?]` Needs source document

---

## Scope guards (binding, verbatim intent)

* No GC, no VM, no `eval`/`exec` in the native dialect, no monkey-patching.
* No JIT/REPL before modules + error handling.
* No global fast-math (`-Ofast` would break bit-identical floats; `-ffp-contract=off` is pinned).
* No silent auto-detect fast paths: every specialization needs a guard + deopt or a compile-time
  proof.
* Optimization must never remove a safety check without a proof object attached to the IR.
* Sanitizer / hardening checks are not to be weakened.
* No compiler-team-authored benchmark as sole performance evidence; every perf claim needs a
  third-party program and an A/B gate.

---

## Verification baseline (re-measure after every work order)

| Check | Result |
|---|---|
| `cargo build --release` | clean, 13 pre-existing build warnings |
| **CI (run 45999706770)** | **all 4 jobs green** — Linux `build-and-test`, macOS + Windows `cross-platform-test`, records |
| ASan+LSan (`ci/logs/asan_lsan.log`) | **11/11 CLEAN** (0 leaks, 0 invalid accesses) — the audit's `pipeline_tour` leak is gone |
| `cargo test --release` | 42 unit + 38 CLI = **80 pass, 0 fail** |
| Leak gate (11 CI targets + `pipelines`) | **0 live blocks** — Linux only, see the coverage note |
| `benchmarks/pipelines.archx.lang` vs CPython 3.12 | byte-identical: `5333140919445` |
| Trapping arithmetic | `MAX+1`, `MAX*2`, `MAX-(0-1)` all panic, exit 101 |
| Audit baseline | 73/94 = 78 % (control 6/6, fn 6/10, ops 10/10, num 7/7, str 17/17, coll 18/18, err 0/5, mod 0/8, misc 9/13) |

---

## Leak-coverage note (scope, not a gap being hidden)

Both leak checks are **Linux-only**, by the limits of the tooling rather than by choice:

* ASan/LSan does not link against Archx IR on this toolchain.
* The `--wrap` harness needs GNU ld or lld. macOS `ld64` rejects the flags outright; Windows'
  MSVC `link.exe` accepts them from the driver but performs no wrapping, leaving unresolved
  `__real_malloc` (LNK1120).

So "zero leaks" is a Linux result. macOS and Windows are covered for *correctness* by the full test
suite in `cross-platform-test`, not for leak-freedom. Anything that needs to change this has to bring
a per-platform leak mechanism (e.g. `leaks(1)` on macOS, `_CrtMemCheckpoint` on Windows).

---

## Environment note

The sandbox arrives with no Rust and no C compiler, and `/tmp` **and the workspace** are wiped
between sessions (recover committed work with `git fetch` + `git reset --mixed origin/…`).
`.work/env.sh` rebuilds the toolchain under `.work/` (Rust 1.97.0 from the bundled pip packages,
zig as the `clang` shim). Source it before any `cargo` command.
