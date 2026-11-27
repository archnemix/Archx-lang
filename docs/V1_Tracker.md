# Archx v1.0 — Work Order Tracker

Status of the ~128-work-order v1.0 backlog (`AX-001`…`AX-128`, phases P0–P8).
Ordering is mandatory: **P0 → P1 → P2 → (P3 ∥ P4) → P5 → P6 → P7 → P8**.
P3 must not start before P0 and P1 are green.

Legend: `[x]` complete and verified · `[~]` in progress · `[ ]` not started · `[!]` blocked

---

## P0 — Correctness of the shipped compiler (gating everything)

| # | Work order | Status | Evidence / notes |
|---|---|---|---|
| AX-001 | Zero memory leaks: comprehension, generator-fold and loop-variable buffers | `[x]` | 3 distinct leak sites closed (`c840f9a`). `ci/leakcheck.c` added as an independent CI gate. 20/20 example+benchmark programs report 0 live blocks (4 did not before). Negative test proves the gate can still fail. |
| AX-002 | Silent `int` wraparound | `[x]` | `e55ea1d`. `int` is a trapping `i64` via `llvm.{sadd,ssub,smul}.with.overflow`; constant folding uses `checked_*`. `MAX+1` now panics (exit 101) instead of printing `-9223372036854775808`. |
| AX-013 | Ambiguous dialect (parser heuristics) | `[ ]` | Not started. Requires the `# archx: dialect=…, version=…` directive, `E0100`, `Dialect` on `ast::Program`, `NodeOrigin` on every node, one `DialectRules` table. |

### Known open item on AX-002

The trapping check costs ~12 % on `benchmarks/composite` (24 ms → 27 ms);
`nbody_float`, `dict_bench`, `full_tour_pythonic` and `pipelines` are
unchanged. Batching the check to the end of a basic block recovers the cost but
**makes the wrapped value observable** before the panic, so it was rejected.
The correct recovery is a range proof on provably-safe arithmetic (the existing
`loop_bounds` / `proven_bound` machinery already powers bounds-check elision),
which needs a proof object attached to the IR. Tracked as follow-on work, not
silently accepted.

---

## Remaining P0 items (from the backlog)

| # | Work order | Status |
|---|---|---|
| AX-003 | Single-source the version number (currently `Cargo.toml` 0.9.0 only) | `[ ]` |
| AX-005 | Add a `LICENSE` file (none exists) | `[ ]` |
| AX-004…AX-012 | Remaining P0 work orders | `[ ]` |

---

## Verification baseline (re-measure after every work order)

| Check | Result |
|---|---|
| `cargo build --release` | clean, 13 pre-existing warnings |
| `cargo test --release` | 37 unit + 36 CLI = **73 pass, 0 fail** |
| Leak gate (11 CI targets + `pipelines`) | **0 live blocks** |
| `benchmarks/pipelines.archx.lang` vs CPython 3.12 | byte-identical: `5333140919445` |
| Trapping arithmetic | `MAX+1`, `MAX*2`, `MAX-(0-1)` all panic with exit 101 |
| Audit baseline | 73/94 = 78 % (control 6/6, fn 6/10, ops 10/10, num 7/7, str 17/17, coll 18/18, err 0/5, mod 0/8, misc 9/13) |

---

## Environment note

The sandbox arrives with no Rust and no C compiler, and `/tmp` is wiped between
sessions. `.work/env.sh` rebuilds the whole toolchain under the workspace-
persisted `.work/` directory (Rust 1.97.0 from the bundled pip packages, zig as
the `clang` shim). Source `.work/env.sh` before any `cargo` command.
