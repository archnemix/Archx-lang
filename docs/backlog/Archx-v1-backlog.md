# Archx v1.0 — complete implementation backlog

**Target repo:** https://github.com/archnemix/Archx-lang/tree/arena/888b3ea8-archx-lang
**Baseline audited:** commit `bc56716` (v0.9.1 claimed, 100 commits, ~36k lines Rust)
**Companion file:** `archx-backlog.csv` — same items as a trackable checklist (`done` column).
**Date:** 2026-11-26

---

## 0. How to use this document

Every item is a work order with: **Build** (what to implement), **Files** (where it goes), **Acceptance** (the test that proves it), **Depends**, **Effort** (S ≤1 day, M ≤1 week, L ≤1 month, XL >1 month), **Risk**.

Phases are ordered by dependency. Do not start P3 before P0–P1 are green, because adding features on top of unchecked overflow, leaks and an ambiguous two-syntax frontend will multiply bugs.

**North-star definition of done:** a developer who did not write the compiler can check out an Archx project, `archx build` a 20-module program that reads files, handles recoverable errors, uses third-party packages, runs its own test suite under a debugger, and ships a signed release binary — with CPython-identical output in compat dialect and C-class speed in native dialect.

**Sequencing:** `P0 → P1 → P2 → (P3 ∥ P4) → P5 → P6 → P7 → P8`.

---

## 1. The two-dialect problem (design decision that must be made first)

Right now one compiler understands two overlapping syntaxes: Pythonic (`def`, `class`, `range`, implicit binding, `with region:`) and classic Archx (`func`, `let`, `struct`, `a..b`, `step`). They are distinguished by ad-hoc parser heuristics. That is the root cause of both the "1:1 Python" marketing problem and unpredictable performance. Fix it by making dialect an **explicit, checked, per-module decision**.

### 1.1 Declared dialect (no guessing)

```python
# archx: dialect=compat, version=1      # CPython-compatible subset
# archx: dialect=native, version=1      # speed/memory-explicit subset
```

- File extension is a hint only: `.py` / `.archx.lang` → `compat`, `.ax` / `.ax.lang` → `native`; a missing directive is a **compile error**, not a guess. `--dialect=compat|native` overrides for tooling.
- Add `Dialect` to `ast::Program` and a `NodeOrigin { dialect, span }` on every statement/expression. Codegen reads the tag; it never infers dialect from syntax shape.
- Allow one explicit per-function override: `def f(...)` in compat, `fn f(...)` in native (Mojo's `def`/`fn` split is the precedent: `def` is dynamic/Python-friendly, `fn` requires types, declares locals, and is statically dispatched [5](https://www.modular.com/blog/an-easy-introduction-to-mojo-for-python-programmers); `fn` in Mojo also requires explicit error declarations and gives fixed-layout structs static dispatch [4](https://www.infoworld.com/article/2338548/a-first-look-at-the-mojo-language.html), [1](https://routerlab.ch/en/blog/mojo-modular-analysis)). Generate a dual-ABI wrapper `pub fn` for cross-dialect calls, exactly like Cython's `cpdef`, which emits a C-fast function plus a Python-callable wrapper [1](https://cythoncython.readthedocs.io/en/latest/src/quickstart/cythonize.html), [5](https://cython-docs2.readthedocs.io/en/latest/src/quickstart/cythonize.html).
- Module-level granularity, not per-expression: Cinder's Static Python uses module-level opt-in and compiles the whole module statically, reporting ~20% average speedup with shallow types and ~70% with fine-tuned types, with 3.7% production CPU efficiency gain at Instagram [2](https://arxiv.org/pdf/2206.13831). Staged, opt-in strictness is a proven model.

### 1.2 Compatibility contract vs speed contract

| Aspect | `compat` dialect (Python-like) | `native` dialect (speed) |
|---|---|---|
| Guarantee | Byte-identical stdout to CPython 3.12+ for every program the compiler accepts | Documented Archx semantics; divergences are legal and explicit |
| `int` | arbitrary precision (bigint with small-int fast path) | `i64` **trapping** on overflow, plus explicit `i32/u64/i128` and `wrapping_add` intrinsics |
| `str` | Unicode code points; `len('میں') == 3`, indexing returns a character | UTF-8 bytes; `str.bytes`, `str.chars()` view; `len()` = bytes |
| `%` on floats | Python floor-mod (`-7.0 % 3.0 == 2.0`) | IEEE `frem` (documented), with `math.fmod` vs `math.floor_mod` explicit |
| `bool` printing / repr | `True`, `['a', 'b']`, `{'a': 1}` | `true`, `[a, b]`, `{a: 1}` (or opt-in `repr()`) |
| truthiness | `if xs:`, `if 0:` allowed (Python rules) | `if` requires `bool`; explicit `len(xs) > 0` |
| iteration | `range`, `enumerate`, `zip` are first-class iterables (`list(range(3))` works) | `for i in a..b` counted loops, `for x in slice(xs)` fused, no iterator objects |
| objects | `class` with `__dict__`-like dynamism subset, inheritance, dunders | `struct` fixed layout, SoA, static dispatch, no inheritance |
| memory | owned values + GC-free RAII (same as now) | explicit `with region:`, `borrow`, `move`, `@noalias` |
| errors | `try/except/finally/raise` with Python exception hierarchy | `Result[T, E]` + `?`, or trapping `panic` |
| functions | first-class, closures, `*args`/`**kwargs`, generators | `fn`, monomorphized, no indirect calls unless `Fn[...]` declared |
| forbidden | `any` promotion that changes observable output, unchecked wrap, silent bigint truncation | implicit boxing, `any`, truthiness, dynamic dispatch |

**Rule: never let `compat` features leak cost into `native` code.** The `any` runtime, bigint fallback, Unicode tables, iterator protocol and Python repr helpers must be emitted only when the module's dialect/builtin usage requires them (extend the existing `used_*` flags). Add a CI gate: adding any compat frontend feature may not regress native-dialect benchmarks by >1%.

### 1.3 Where Python-like syntax actually costs performance

| Python construct | Hidden cost | Native equivalent |
|---|---|---|
| untyped variable / mixed container | 24-byte `%ArchxAny` tag + runtime type branch per op | `let x: i64`, `list[i64]`, monomorphized |
| `if xs:` / `and`/`or` on non-bool | truthiness protocol + branches | `if len(xs) > 0` / `if a and b` on `bool` |
| `for x in range(n)` | iterator object or materialized list | `for i in 0..n` counted loop |
| `list(range(n))` | heap container | pre-sized `[0; n]` + `i` loop |
| `sorted(xs, key=lambda...)` | closure/boxing in naive impl | inlined planar Schwartzian sort (already implemented — keep it native-only) |
| `print(f"...")` with dynamic specs | formatting interpreter | compile-time format lowering |
| arbitrary-precision `int` | limb allocation, overflow path | `i64` + trapping checks |
| `str` as code points | UTF-8 decoding per index | byte slices + `memchr` |
| `class` attribute access | hash lookup / dynamic dispatch | struct field offset |
| `try/except` | unwind tables, landing pads | `Result` + `?` |
| `**kwargs`, `*args`, `yield` | heap arg tuple / state machine | fixed arity / explicit generator struct |

Cython demonstrates the magnitude: untyped `.pyx` code is only 10–30% faster than CPython, while `cdef`-typed loops reach 10–100× because per-operation `PyObject` boxing disappears [2](https://algomaster.io/learn/python/cython-basics), [1](https://cythoncython.readthedocs.io/en/latest/src/quickstart/cythonize.html). Cython also exposes opt-out directives (`@cython.boundscheck(False)`, `@cython.wraparound(False)`) for the last few percent [3](https://pythonz2h.com/chapter_08_high_performance_python/series_04_cython_and_native_extensions/cython_typing) — Archx needs the same explicit, auditable switches rather than silent semantics changes. Guarded specialization with deoptimization is the runtime analogue: CPython's PEP 659 quickens hot monomorphic opcodes and reverts on guard failure [3](https://latest2all.com/tutorial/advanced-condition-variable-spurious-wakeups-and-osr-core-mechanism.html), and Cinder's JIT inliner relies on guards falling back to the interpreter when the callee changes [5](https://engineering.fb.com/2022/05/02/open-source/cinder-jits-instagram/).

### 1.4 Dialect tooling to build

- `archx check --dialect=compat --against-python=python3.12`: compile, run CPython on the same source, `cmp` stdout; report the first divergent construct with a span. All 94 of the project's own probes plus the 123 probe suite from the audit must live in-repo.
- `archx explain-perf file.ax`: annotate each expression with its tier (static / any / heap / unwind) and emit `warning[perf]: implicit any promotion here; use let x: i64 (native dialect)`.
- `archx migrate --to=native`: rewrite `def`→`fn`, insert `let`, `range(n)` loops→`a..b`, list literals→typed arrays, and refuse (with a report) anything untranslatable such as `eval` or monkey-patching.
- `archx fmt` must preserve the directive and never rewrite a compat program into native-only syntax.

---

## 2. Research-backed optimization menu (out of the box)

These are the LLVM-level levers worth wiring into the driver, in addition to the existing SoA/SSO/SwissTable/comprehension work.

**IR facts & attributes.** Emit `noalias`, `align`, `nonnull`, `dereferenceable`, `nounwind`, `readonly`/`writeonly`/`memory(...)`, `willreturn`, `mustprogress`, `cold`/`hot`, `alwaysinline`, plus `!tbaa` for typed planes, `!alias.scope`/`!noalias` for disjoint buffers, `!range` on indices/lengths, `llvm.assume` for proven invariants, `llvm.expect`/`!prof branch_weights` on hot branches, and unique self-referential `!llvm.loop` nodes with `vectorize.enable`, `vectorize.width`, `interleave.count`, `unroll.count` — all documented in the LLVM LangRef [1](https://llvm.org/docs/LangRef.html). Fast-math flags (`nnan`, `ninf`, `nsz`, `arcp`, `contract`, `reassoc`, `afn`) are hints that enable otherwise-unsafe FP transforms [1](https://llvm.org/docs/LangRef.html) — they must be **opt-in** (`@archx.fast_math`) and forbidden in compat dialect, since the repo already pins `-ffp-contract=off` for bit-identical floats.

**Pass pipeline.** Baseline stays `clang -O2`; add an explicit `opt` pipeline for release: `inlining → loop-rotate → LICM → indvars → instcombine → mem2reg/SROA → GVN → loop-unroll → loop-vectorize → SLP-vectorizer → cleanup (LICM/GVN/instcombine)`. Pass order matters (inlining before vectorization; SROA again after unrolling; LICM/GVN again after vectorization) [3](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-llvm-code-generation-for-data-analytics.html), [1](https://www.reddit.com/r/Compilers/comments/1hqmd7x/recommended_llvm_passes/). For affine loop nests, optional Polly: `-mllvm -polly -mllvm -polly-vectorizer=stripmine`, ideally positioned before the vectorizer [4](https://polly.llvm.org/docs/UsingPollyWithClang.html), [2](https://media.readthedocs.org/pdf/polly-/latest/polly-.pdf).

**LTO.** ThinLTO by default for multi-module releases (`-flto=thin`), full LTO opt-in, `-fvisibility=hidden` + internal linkage + section GC. ThinLTO keeps build times tolerable while full LTO produces faster but much more resource-hungry code, and LTO also enables Clang's forward-edge CFI [2](https://lpc.events/event/7/contributions/798/attachments/661/1214/LTO_PGO_and_AutoFDO_-_Plumbers_2020_-_Tolvanen_Wendling_Desaulniers.pdf), [9](https://c.wsmoses.com/presentations/LLVM%20performance%20tutorial.pdf).

**PGO.** Add `archx build --pgo=generate|use|auto`: `-fprofile-generate` → run training workload → `llvm-profdata merge` → `-fprofile-use`. Add sample-based AutoFDO (no separate instrumented build) and context-sensitive CSSPGO, which delivered an extra 1–5% over AutoFDO on Meta production workloads with near-zero profiling overhead [3](https://htyu.github.io/paper/Revamping_Sampling_based_PGO_with_Context_sensitivity_and_Pseudo_instrumentation_preprint.pdf), [1](https://llvm.org/docs/AdvancedBuilds.html).

**BOLT.** Post-link layout optimization on top of PGO+LTO (`-Wl,-q` to keep relocations, `llvm-bolt --instrument`, `-reorder-blocks=ext-tsp -reorder-functions=hfsort+ -split-functions`). BOLT gave up to 7% on top of FDO+LTO for datacenter workloads and up to 20.4% for compilers [4](https://jnamaral.github.io/CDOL/papers/PanchenkoCGO19.pdf); a worked PGO+BOLT pipeline showed ~1.5× over baseline SQLite [6](https://fzakaria.com/2026/05/23/leaving-performance-on-the-table). Meta's published stack is ThinLTO + CSSPGO + BOLT, where CSSPGO and BOLT profiles are collected separately [5](https://cdck-file-uploads-us1.s3.dualstack.us-west-2.amazonaws.com/flex021/uploads/llvm/original/3X/2/f/2f9111df68d87d7574693613dd545e6da6d57511.pdf).

**Safety-preserving speed.** Hardened release profile: UBSan integer checks with `-fsanitize=integer -fsanitize-minimal-runtime -fno-sanitize-recover` (documented ~1% cost, used in production on Android) [1](https://airbus-seclab.github.io/c-compiler-security/clang_compilation.html), `-fstack-protector-strong`, `-D_FORTIFY_SOURCE=2`, `-fcf-protection=full`, PIE [5](https://best.openssf.org/Compiler-Hardening-Guides/Compiler-Options-Hardening-Guide-for-C-and-C++.html). Debug/hardened matrix: ASan+LSan, UBSan, MSan, HWASan on AArch64, TSan, CFI, safe-stack/shadow-call-stack [3](https://hivebook.wiki/wiki/llvm-22-compiler-infrastructure-clang-lld-mlir-sanitizers-bolt), [1](https://airbus-seclab.github.io/c-compiler-security/clang_compilation.html). **Optimization must never remove a safety check without a proof object attached to the IR.**

**Specialization & tiering.** Guarded fast paths for `%ArchxAny` with deopt to the generic path, monomorphic inline caches for method calls, escape-analysis-driven stack promotion, allocation elision for region-only values, homogeneous-container unboxing, small-size specializations, `memcpy`/`memmove` fast paths, branchless compaction, prefetch in the SwissTable probe, slab reuse for regions. CPython's quickening/deopt and Cinder's guard-based inliner are the reference designs [3](https://latest2all.com/tutorial/advanced-condition-variable-spurious-wakeups-and-osr-core-mechanism.html), [5](https://engineering.fb.com/2022/05/02/open-source/cinder-jits-instagram/).

**CPU targeting.** `-march=native`/`-mtune`, target-feature flags, function multiversioning with IFUNC, aarch64/x86_64 code paths, and `-mllvm` tuning knobs exposed as `@archx.target(...)`.

---

## 3. Internal compiler modularity target

Split the current single-crate monolith (`src/*.rs` + 24 files in `src/codegen/`) into a workspace with hard API boundaries, following rust-analyzer's documented pattern of a `hir` façade as an API boundary and `ItemTree`-style summaries that stay stable when function bodies change [4](https://git.jeffas.net/rust-analyzer/files/docs/dev/architecture.md.html). For IDE/incremental work, use a query-based (salsa-style) database that memoizes derived results and invalidates only what changed [1](https://rust-analyzer.github.io//blog/2020/07/20/three-architectures-for-responsive-ide.html).

```text
crates/
  archx-syntax/     tokens, spans, lexer, dialect directive, tree-sitter grammar
  archx-ast/        untyped AST + NodeOrigin(dialect, span)
  archx-parser/     two frontends -> one AST
  archx-hir/        name resolution, typed HIR, DefMap, ItemTree
  archx-sema/       type check, borrow/escape, overflow proof, optional narrowing
  archx-dialect/    compat-conformance rules, perf explainer, migrator
  archx-ir/         typed IR builder (Module/Function/Block/Value ids), verifier
  archx-codegen/    expr/stmt/loops/calls/collections/... one file per concern
  archx-mono/       generics, lambda lifting, cross-module specialization
  archx-runtime/    LLVM IR runtime helpers generated from one registry
  archx-link/       clang/lld/lto/pgo/bolt driver, object cache
  archx-driver/     CLI, project manifest, module graph, incremental queries
  archx-lsp/        IDE façade (queries reuse archx-hir/archx-sema)
  archx-cli/        thin binary
stdlib/             sys, fs, io, math, time, string, collections, json, test
```

Replace string-concatenated LLVM IR with a typed builder; run `llvm-as` + `opt -passes=verify` on every emitted module in CI. Make `Codegen` a small context (`TypeRegistry`, `RuntimeRegistry`, `FnCtx`, `DropInserter`, `Monomorphizer`) instead of the 1,408-line `mod.rs` god object.

---

## 4. What NOT to build (scope guards)

- No garbage collector, no VM, no `eval`/`exec` in native dialect, no monkey-patching, no full CPython compatibility in native dialect.
- No JIT/REPL before modules + error handling exist; a JIT on a single-file compiler is wasted work.
- No `-Ofast`/global fast-math by default; it would break the compat contract and the bit-identical float guarantee.
- No "auto-detect fast path" heuristics that silently change semantics. Any specialization must have a guard + deopt or a compile-time proof.
- No new benchmark authored by the compiler team as the only evidence; every perf claim needs a third-party program and an A/B gate.

---

## 5. The work orders

### P0 — Trust the current build (do this first)

#### AX-001 — Fix the two 16 KB ASan/LSan leaks
- **Phase:** P0 · **Area:** Runtime · **Priority:** P0
- **Build:** Locate the two `malloc` sites in `archx_fn___archx_user_main` of `full_tour_pythonic`/`full_tour_speed` (32,000 bytes in 2 allocations), identify the owning temp/container, and insert the missing recursive drop on all exits (fallthrough, `return`, `break`, `continue`).
- **Files:** `src/codegen/ownership.rs`, `src/codegen/stmt.rs`, `tests/cli.rs`, `ci/logs/asan_lsan.log`
- **Acceptance:** All 11 ASan+LSan targets print `CLEAN`; committed CI log contains 11 `CLEAN` lines and 0 `ERROR`.
- **Depends:** — · **Effort:** M · **Risk:** med

#### AX-002 — Make integer overflow actually trap on every path
- **Phase:** P0 · **Area:** Codegen · **Priority:** P0
- **Build:** `2**63`, `i64::MAX + 1`, `3037000500*3037000500` currently wrap silently; audit `expr.rs`/`analysis.rs` const-folding and `VarStorage::Imm` paths, emit `@llvm.s{add,sub,mul}.with.overflow.i64` + panic uniformly; add explicit `wrapping_*` intrinsics for native dialect.
- **Files:** `src/codegen/expr.rs`, `src/codegen/analysis.rs`, `src/codegen/runtime.rs`, `tests/cli.rs`
- **Acceptance:** differential test asserts every overflowing op traps with `archx runtime panic: integer overflow`, including constants and literals; no `add nsw` without a proof.
- **Depends:** AX-001 · **Effort:** M · **Risk:** high

#### AX-003 — Reconcile versions, docs, and numbers
- **Phase:** P0 · **Area:** Docs · **Priority:** P0
- **Build:** Single source of truth `VERSION` consumed by `Cargo.toml`, CLI `--version`, README, all docs; regenerate the README benchmark table from `ci/out/benchmarks.txt`; correct test count (69 = 37 unit + 32 CLI); remove "(Current)" from v0.8.0 changelog.
- **Files:** `Cargo.toml`, `README.md`, `docs/*.md`, `docs/Files_Info.json`, `src/main.rs`
- **Acceptance:** a CI script diffs README numbers against `ci/out/benchmarks.txt` and fails on drift.
- **Depends:** — · **Effort:** S · **Risk:** low

#### AX-004 — Zero compiler warnings, gate them in CI
- **Phase:** P0 · **Area:** Build · **Priority:** P0
- **Build:** Resolve all 12 warnings (unused vars, `unused_mut`, dead `ForElse` variant, dead helpers); add `-D warnings` to CI and `#[deny(dead_code)]` on the AST.
- **Files:** `src/ast.rs`, `src/codegen/*.rs`, `.github/workflows/ci.yml`
- **Acceptance:** `cargo clippy -- -D warnings` clean on all 3 OS.
- **Depends:** — · **Effort:** S · **Risk:** low

#### AX-005 — Remove committed binaries and add LICENSE
- **Phase:** P0 · **Area:** Repo · **Priority:** P0
- **Build:** Delete `bw` and `call_and_loop_semantics` ELF files; add `LICENSE` (MIT); extend `.gitignore`; add a CI check rejecting binaries in the tree.
- **Files:** `bw`, `call_and_loop_semantics`, `LICENSE`, `.gitignore`, `.github/workflows/ci.yml`
- **Acceptance:** `find . -type f -exec file {} +` shows no ELF/Mach-O/PE outside `target/`.
- **Depends:** — · **Effort:** S · **Risk:** low

#### AX-006 — Merge the 99-commit branch into `main` and tag
- **Phase:** P0 · **Area:** Repo · **Priority:** P0
- **Build:** `main` currently has 1 commit with a README; fast-forward/merge `arena/888b3ea8-archx-lang`, set default branch, tag `v0.9.1`.
- **Files:** GitHub settings, `README.md`
- **Acceptance:** plain `git clone` yields the compiler, `cargo build --release` works, `archx --version` prints the tag.
- **Depends:** AX-003, AX-005 · **Effort:** S · **Risk:** low

#### AX-007 — Add a differential conformance harness
- **Phase:** P0 · **Area:** Tests · **Priority:** P0
- **Build:** `tests/conformance/` with 94+ small programs; runner compiles with archx and runs `python3` on the same file, compares stdout byte-for-byte for compat dialect; record expected-divergence markers for native dialect.
- **Files:** `tests/conformance/*`, `tests/cli.rs`, `Makefile`
- **Acceptance:** `cargo test --test conformance` reports pass/fail counts and publishes `conformance.md`; the 123 audit probes are included.
- **Depends:** AX-001 · **Effort:** M · **Risk:** med

#### AX-008 — Publish the actual known-limitations list
- **Phase:** P0 · **Area:** Docs · **Priority:** P0
- **Build:** `docs/LIMITATIONS.md` enumerating every unsupported construct and every CPython divergence found by AX-007; README must link it.
- **Files:** `docs/LIMITATIONS.md`, `README.md`
- **Acceptance:** every probe failure maps to a documented limitation or a tracking issue.
- **Depends:** AX-007 · **Effort:** S · **Risk:** low

#### AX-009 — Fix the `%ArchxAny` and sort IR verifier gate
- **Phase:** P0 · **Area:** Codegen · **Priority:** P0
- **Build:** Run `llvm-as` + `opt -passes=verify` on every emitted `.ll` in CI; add a unit test that emits IR for all `used_*` runtime combinations (the v0.9.1 `%` phi bug shows why).
- **Files:** `src/codegen/runtime_hash_any.rs`, `src/codegen/sort.rs`, `src/codegen/tests.rs`, `.github/workflows/ci.yml`
- **Acceptance:** all `ci/out/*.ll` and all example `--emit-ir` outputs verify with `llvm-as`.
- **Depends:** — · **Effort:** S · **Risk:** low

#### AX-010 — Fix stale `ForElse` AST variant and unused helpers
- **Phase:** P0 · **Area:** Frontend · **Priority:** P1
- **Build:** `StmtKind::ForElse` is never constructed; either implement it as the canonical `for...else` node (unifying `For`/`ForEach` else bodies) or remove it.
- **Files:** `src/ast.rs`, `src/parser.rs`, `src/codegen/loops.rs`
- **Acceptance:** one AST representation for `for...else`; all existing loop tests still pass.
- **Depends:** AX-004 · **Effort:** M · **Risk:** med

#### AX-011 — Full diagnostic codes and machine-readable output
- **Phase:** P0 · **Area:** Diagnostics · **Priority:** P1
- **Build:** Add stable error codes (E0001…), `--message-format=json`/SARIF, and `archx explain E0123`.
- **Files:** `src/diag.rs`, `src/main.rs`, `docs/USAGE.md`
- **Acceptance:** every diagnostic has a code, a span, and a `--explain` entry; JSON output parses in CI.
- **Depends:** — · **Effort:** M · **Risk:** low

#### AX-012 — Reproducible builds and byte-identity gate
- **Phase:** P0 · **Area:** Build · **Priority:** P1
- **Build:** Pin clang version in CI, record toolchain in `ci/out/toolchain.txt`, hash inputs, and gate every optimization PR on byte-identical stdout across all 7 suites.
- **Files:** `.github/workflows/ci.yml`, `benchmarks/run.sh`, `ci/README.md`
- **Acceptance:** two clean builds produce identical binaries; any output diff fails CI.
- **Depends:** AX-003 · **Effort:** M · **Risk:** low

### P1 — Make the two syntaxes explicit

#### AX-013 — Add `Dialect` + `NodeOrigin` to the AST
- **Phase:** P1 · **Area:** Frontend · **Priority:** P0
- **Build:** `enum Dialect { Compat, Native }` on `Program`; `NodeOrigin { dialect, span }` on every `Stmt`/`Expr`; parser tags nodes instead of codegen guessing.
- **Files:** `src/ast.rs`, `src/parser.rs`, `src/token.rs`
- **Acceptance:** `archx --emit-ir` output carries a module flag `!archx.dialect`; AST snapshot tests show tags.
- **Depends:** AX-010 · **Effort:** L · **Risk:** med

#### AX-014 — Parse the dialect directive and CLI override
- **Phase:** P1 · **Area:** Frontend · **Priority:** P0
- **Build:** Accept `# archx: dialect=compat|native, version=1` as the first line; `--dialect` flag; missing/ambiguous directive is `E0100`; extension is a hint only.
- **Files:** `src/lexer.rs`, `src/main.rs`, `docs/USAGE.md`
- **Acceptance:** same source compiled with each dialect produces distinct IR flags; missing directive errors with a fix-it.
- **Depends:** AX-013 · **Effort:** S · **Risk:** low

#### AX-015 — `def` vs `fn` split with dual-ABI `pub fn`
- **Phase:** P1 · **Area:** Frontend · **Priority:** P0
- **Build:** `def` = compat (Python call semantics, truthiness, bigint), `fn` = native (typed, explicit locals, static dispatch); `pub fn` generates a fast native symbol plus a compat wrapper (Cython `cpdef` model [1](https://cythoncython.readthedocs.io/en/latest/src/quickstart/cythonize.html)).
- **Files:** `src/parser.rs`, `src/codegen/calls.rs`, `src/codegen/mod.rs`, `tests/cli.rs`
- **Acceptance:** a compat module calls a `pub fn` from a native module and matches CPython output; native benchmark shows no wrapper cost on internal calls.
- **Depends:** AX-013 · **Effort:** L · **Risk:** high

#### AX-016 — Freeze the semantic divergence matrix in code
- **Phase:** P1 · **Area:** Sema · **Priority:** P0
- **Build:** One `DialectRules` table (int, str, `%`, repr, truthiness, iteration, classes, errors, functions, memory) consumed by lexer/parser/sema/codegen; no per-file `if dialect` scattered around.
- **Files:** `src/dialect_rules.rs`, `src/codegen/*.rs`, `docs/DIALECTS.md`
- **Acceptance:** changing a rule in one place updates both dialects' behavior and the docs table is generated from it.
- **Depends:** AX-013 · **Effort:** M · **Risk:** med

#### AX-017 — `archx check --against-python` compat gate
- **Phase:** P1 · **Area:** Tooling · **Priority:** P0
- **Build:** Compile, run CPython 3.12 on the same file, `cmp` stdout; report first divergence with span and dialect rule name.
- **Files:** `src/main.rs`, `tests/conformance/`, `.github/workflows/ci.yml`
- **Acceptance:** `full_tour.py`, `pipelines.py` and all 94 probes pass; CI fails on any diff.
- **Depends:** AX-007, AX-016 · **Effort:** M · **Risk:** low

#### AX-018 — `archx explain-perf` cost annotator
- **Phase:** P1 · **Area:** Tooling · **Priority:** P1
- **Build:** Annotate each expression with tier (static / any / heap / unwind / iterator) and emit warnings with native-dialect fix-its.
- **Files:** `src/codegen/analysis.rs`, `src/main.rs`, `docs/OPTIMIZATION.md`
- **Acceptance:** `if xs:`, `[1,'a']`, `list(range(3))`, `2**100` each produce a specific, actionable warning.
- **Depends:** AX-013 · **Effort:** M · **Risk:** low

#### AX-019 — `archx migrate --to=native` source rewriter
- **Phase:** P1 · **Area:** Tooling · **Priority:** P2
- **Build:** Rewrite `def`→`fn`, implicit bindings→`let x: T`, `range` loops→`a..b`, mixed literals→typed; emit a refusal report for untranslatable constructs.
- **Files:** `src/ast.rs`, `src/main.rs`, `tests/cli.rs`
- **Acceptance:** migrated `full_tour.py` compiles and matches the hand-written speed edition's output.
- **Depends:** AX-015 · **Effort:** L · **Risk:** med

#### AX-020 — Dialect-isolated runtime emission
- **Phase:** P1 · **Area:** Codegen · **Priority:** P0
- **Build:** `any`/bigint/Unicode/repr/iterator/exception runtime helpers are emitted only if the module's dialect and used builtins require them; extend `used_*` registry.
- **Files:** `src/codegen/runtime.rs`, `src/codegen/runtime_py.rs`, `src/codegen/any.rs`, `src/codegen/mod.rs`
- **Acceptance:** a native "hello" binary contains no `ArchxAny` symbols; stripped size does not grow when compat features are added to the compiler.
- **Depends:** AX-013 · **Effort:** M · **Risk:** med

#### AX-021 — Native-dialect no-regression perf gate
- **Phase:** P1 · **Area:** CI · **Priority:** P0
- **Build:** Benchmark native dialect on suites 1–7 with A/B against the previous commit; fail on >1% regression.
- **Files:** `.github/workflows/ci.yml`, `benchmarks/run.sh`, `ci/out/benchmarks.txt`
- **Acceptance:** adding a compat-only feature cannot regress native numbers.
- **Depends:** AX-020 · **Effort:** M · **Risk:** low

#### AX-022 — `boundscheck`/`wraparound`-style explicit opt-outs
- **Phase:** P1 · **Area:** Sema · **Priority:** P1
- **Build:** `@archx.boundscheck(False)`, `@archx.negative_index(False)`, `@archx.overflow(assume)` per function/block, with a required `unsafe`-style marker and a proof obligation; mirrors Cython directives [3](https://pythonz2h.com/chapter_08_high_performance_python/series_04_cython_and_native_extensions/cython_typing).
- **Files:** `src/parser.rs`, `src/codegen/memory.rs`, `docs/DIALECTS.md`
- **Acceptance:** opt-out removes the check in emitted IR and is recorded in a manifest; compat dialect rejects it.
- **Depends:** AX-016 · **Effort:** M · **Risk:** high

#### AX-023 — Guarded specialization with deopt for `any`
- **Phase:** P1 · **Area:** Codegen · **Priority:** P2
- **Build:** Emit a monomorphic fast path with a type guard and a branch to the generic `%ArchxAny` path; guard failure deopts instead of miscompiling (PEP 659/Cinder model [3](https://latest2all.com/tutorial/advanced-condition-variable-spurious-wakeups-and-osr-core-mechanism.html), [5](https://engineering.fb.com/2022/05/02/open-source/cinder-jits-instagram/)).
- **Files:** `src/codegen/any.rs`, `src/codegen/expr.rs`, `src/codegen/analysis.rs`
- **Acceptance:** homogeneous loop runs at static speed; heterogeneous input produces identical output via the generic path; fuzz differential test finds no mismatch.
- **Depends:** AX-020 · **Effort:** L · **Risk:** high

#### AX-024 — Dialect-aware f-strings, `print`, and repr
- **Phase:** P1 · **Area:** Codegen · **Priority:** P1
- **Build:** Compat dialect prints `True`, quoted strings in containers, Unicode code points; native prints its documented compact form. One formatting entry point, two rule sets.
- **Files:** `src/codegen/io.rs`, `src/dialect_rules.rs`, `tests/conformance/`
- **Acceptance:** `print(True)`, `print(['a','b'])`, `print({'a':1})` match CPython in compat; native output documented and stable.
- **Depends:** AX-016 · **Effort:** M · **Risk:** med

#### AX-025 — Compat `range`/`enumerate`/`zip` as first-class iterables
- **Phase:** P1 · **Area:** Frontend · **Priority:** P1
- **Build:** `list(range(3))`, `sum(range(5))`, `zip(...)` materialization must work in compat dialect; native keeps fused loops only.
- **Files:** `src/parser.rs`, `src/codegen/calls.rs`, `src/codegen/zip_loops.rs`, `tests/conformance/`
- **Acceptance:** `print(list(range(5,0,-1)))` matches CPython; native `for i in 0..n` IR unchanged.
- **Depends:** AX-016 · **Effort:** M · **Risk:** med

#### AX-026 — Compat `while...else`, `del`, `global`, slice assignment
- **Phase:** P1 · **Area:** Frontend · **Priority:** P1
- **Build:** Implement the remaining small Python statements that the audit found missing; native dialect may reject them.
- **Files:** `src/ast.rs`, `src/parser.rs`, `src/codegen/stmt.rs`, `src/codegen/collections.rs`
- **Acceptance:** 8 new conformance programs match CPython.
- **Depends:** AX-013 · **Effort:** M · **Risk:** med

#### AX-027 — Compat bigint with small-int fast path
- **Phase:** P1 · **Area:** Runtime · **Priority:** P1
- **Build:** `2**100` must print 31 digits; use i64 fast path + limb fallback with `OverflowError`-equivalent diagnostic on narrowing (Cython converts Python bigints to C types and raises on overflow [1](https://cythoncython.readthedocs.io/en/latest/src/quickstart/cythonize.html)).
- **Files:** `runtime/bigint.ll.h`, `src/codegen/expr.rs`, `src/codegen/any.rs`, `tests/conformance/`
- **Acceptance:** `2**100`, `10**40`, mixed bigint/list ops match CPython; native `i64` path benchmarks unchanged.
- **Depends:** AX-002 · **Effort:** L · **Risk:** high

#### AX-028 — Compat Unicode string semantics
- **Phase:** P1 · **Area:** Runtime · **Priority:** P1
- **Build:** Keep UTF-8 byte storage but make `len`, indexing, slicing, `str.upper`, `in` operate on code points in compat; expose byte views in native.
- **Files:** `src/codegen/runtime_py.rs`, `src/codegen/io.rs`, `src/codegen/methods.rs`
- **Acceptance:** `len('میں') == 3`, `'میں'[0] == 'م'`, `s[::-1]` match CPython.
- **Depends:** AX-016 · **Effort:** L · **Risk:** high

### P2 — Multi-file programs and the build system

#### AX-029 — `archx.toml` project manifest
- **Phase:** P2 · **Area:** Build · **Priority:** P0
- **Build:** `[package] name/version/dialect/opt/targets`, `[dependencies]`, `[profile]`; `archx build` reads it instead of a single file path.
- **Files:** `src/main.rs`, `crates/archx-driver/src/manifest.rs`, `docs/USAGE.md`
- **Acceptance:** `archx build` in a project root compiles all modules; invalid manifest yields E02xx diagnostics.
- **Depends:** AX-014 · **Effort:** M · **Risk:** low

#### AX-030 — Module graph + import resolver
- **Phase:** P2 · **Area:** Frontend · **Priority:** P0
- **Build:** `import mod`, `from mod import fn`, `as` aliases, `__init__.ax` packages, deterministic topological order, cycle detection with a span chain.
- **Files:** `crates/archx-hir/src/resolve.rs`, `src/parser.rs`, `src/ast.rs`
- **Acceptance:** 30-module project resolves; import cycle errors with full path; duplicate symbol diagnosed.
- **Depends:** AX-029 · **Effort:** L · **Risk:** med

#### AX-031 — Visibility and symbol mangling
- **Phase:** P2 · **Area:** Frontend · **Priority:** P0
- **Build:** `pub` exports, private-by-default, `archx::module::fn` mangling, stable ABI names.
- **Files:** `crates/archx-hir/src/resolve.rs`, `src/codegen/mod.rs`
- **Acceptance:** private symbol is unreachable from another module; `nm` shows mangled stable names.
- **Depends:** AX-030 · **Effort:** M · **Risk:** low

#### AX-032 — Module interface files (`.axi`)
- **Phase:** P2 · **Area:** Build · **Priority:** P0
- **Build:** Serialize exported signatures, struct/enum layouts, generic templates and dialect into a hash-stamped interface file; consumers compile against it.
- **Files:** `crates/archx-driver/src/interface.rs`, `crates/archx-hir/src/lib.rs`
- **Acceptance:** editing a function body does not invalidate dependents' interfaces.
- **Depends:** AX-030 · **Effort:** L · **Risk:** med

#### AX-033 — Separate compilation to object files
- **Phase:** P2 · **Area:** Backend · **Priority:** P0
- **Build:** Emit one `.ll`/`.bc` per module → `clang -c` → `.o` → link with `lld`; keep a whole-program `--mono` mode.
- **Files:** `src/main.rs`, `crates/archx-link/src/lib.rs`, `Makefile`
- **Acceptance:** 30-module project produces 30 objects; touching one file recompiles only one object.
- **Depends:** AX-032 · **Effort:** L · **Risk:** high

#### AX-034 — Cross-module monomorphization
- **Phase:** P2 · **Area:** Codegen · **Priority:** P1
- **Build:** Propagate generic instantiations and lifted lambdas across module boundaries; deduplicate specializations by type-key hash.
- **Files:** `src/codegen/generics.rs`, `crates/archx-mono/src/lib.rs`
- **Acceptance:** `Box[int]` defined in module A and used in B links and runs; only one specialization emitted.
- **Depends:** AX-033 · **Effort:** L · **Risk:** high

#### AX-035 — ThinLTO / full LTO link modes
- **Phase:** P2 · **Area:** Backend · **Priority:** P1
- **Build:** `--lto=thin|full|off`; emit bitcode, invoke `lld` with LTO, `-fvisibility=hidden`, internal linkage (ThinLTO is the build-time/perf tradeoff, full LTO is faster but memory-hungry [2](https://lpc.events/event/7/contributions/798/attachments/661/1214/LTO_PGO_and_AutoFDO_-_Plumbers_2020_-_Tolvanen_Wendling_Desaulniers.pdf)).
- **Files:** `crates/archx-link/src/lib.rs`, `src/main.rs`
- **Acceptance:** cross-module inlining appears in `.opt.ll`; benchmark A/B recorded.
- **Depends:** AX-033 · **Effort:** M · **Risk:** med

#### AX-036 — Incremental query-based rebuilds
- **Phase:** P2 · **Area:** Build · **Priority:** P1
- **Build:** Content-hash inputs, memoized queries (`parse(file)`, `resolve(module)`, `typecheck(fn)`, `codegen(module)`), invalidate only changed dependents; `archx build --watch` (salsa/query model [1](https://rust-analyzer.github.io//blog/2020/07/20/three-architectures-for-responsive-ide.html)).
- **Files:** `crates/archx-driver/src/db.rs`, `crates/archx-hir/src/lib.rs`
- **Acceptance:** editing a function body rebuilds one module in <10% of full build time; measured in CI.
- **Depends:** AX-032 · **Effort:** XL · **Risk:** high

#### AX-037 — Standard library: `std.sys`
- **Phase:** P2 · **Area:** Stdlib · **Priority:** P0
- **Build:** `argv`, `exit(code)`, `getenv`/`setenv`, `platform`, `args` parsing.
- **Files:** `stdlib/sys.ax`, `src/codegen/runtime.rs`
- **Acceptance:** `archx run app.ax --one two` prints the same argv as a C program.
- **Depends:** AX-029 · **Effort:** S · **Risk:** low

#### AX-038 — Standard library: `std.fs` and file I/O
- **Phase:** P2 · **Area:** Stdlib · **Priority:** P0
- **Build:** `open/read/write/close`, `read_text`, `write_text`, `exists`, `list_dir`, paths, `with open(...) as f`.
- **Files:** `stdlib/fs.ax`, `src/codegen/runtime.rs`, `tests/cli.rs`
- **Acceptance:** program writes a file, reads it back, compares bytes with CPython.
- **Depends:** AX-029, AX-064 · **Effort:** M · **Risk:** med

#### AX-039 — Standard library: `std.math`
- **Phase:** P2 · **Area:** Stdlib · **Priority:** P1
- **Build:** `sqrt/cbrt/pow/floor/ceil/fmod/floor_mod/sin/cos/log/exp`, `pi`, `inf/nan` handling, `fsum`.
- **Files:** `stdlib/math.ax`, `src/codegen/calls.rs`
- **Acceptance:** 20 numeric cases match CPython `math` bit-for-bit under `-ffp-contract=off`.
- **Depends:** AX-029 · **Effort:** M · **Risk:** med

#### AX-040 — Standard library: `std.time`
- **Phase:** P2 · **Area:** Stdlib · **Priority:** P1
- **Build:** `monotonic_ns`, `time_ns`, `sleep`, `perf_counter`, formatting.
- **Files:** `stdlib/time.ax`, `src/codegen/runtime.rs`
- **Acceptance:** cross-platform (3 OS) timing test with tolerances.
- **Depends:** AX-029 · **Effort:** S · **Risk:** low

#### AX-041 — Standard library: `std.io`
- **Phase:** P2 · **Area:** Stdlib · **Priority:** P1
- **Build:** stdin/stdout/stderr streams, buffered writes, `read_line`, `print(file=...)`.
- **Files:** `stdlib/io.ax`, `src/codegen/io.rs`
- **Acceptance:** piped 1 MB input round-trips byte-identically.
- **Depends:** AX-029 · **Effort:** M · **Risk:** low

#### AX-042 — Standard library: `std.collections` / `std.string` / `std.json`
- **Phase:** P2 · **Area:** Stdlib · **Priority:** P2
- **Build:** `deque`, `heapq`, `bisect`, `itertools`-style helpers; `str` Unicode helpers; a small JSON parser/serializer written in Archx itself.
- **Files:** `stdlib/collections.ax`, `stdlib/string.ax`, `stdlib/json.ax`
- **Acceptance:** JSON round-trip matches Python `json` on a fixture corpus.
- **Depends:** AX-030, AX-028 · **Effort:** L · **Risk:** med

#### AX-043 — Package manager and lockfile
- **Phase:** P2 · **Area:** Build · **Priority:** P2
- **Build:** `archx add pkg@^1.2`, `archx.lock` with hashes, vendored `vendor/`, offline build, semver resolution.
- **Files:** `crates/archx-driver/src/registry.rs`, `docs/USAGE.md`
- **Acceptance:** clean machine builds a project from lockfile with no network.
- **Depends:** AX-029 · **Effort:** L · **Risk:** med

#### AX-044 — C FFI declarations
- **Phase:** P2 · **Area:** Backend · **Priority:** P1
- **Build:** `extern "C" fn puts(s: cstr) -> i32`, opaque `ptr`, `unsafe` markers, ownership annotations, `-l` link flags from manifest.
- **Files:** `src/parser.rs`, `src/codegen/calls.rs`, `crates/archx-link/src/lib.rs`
- **Acceptance:** Archx calls libc `puts` and a compiled C function with a struct argument; ASan clean.
- **Depends:** AX-033 · **Effort:** M · **Risk:** high

#### AX-045 — Static/shared library outputs
- **Phase:** P2 · **Area:** Backend · **Priority:** P2
- **Build:** `--crate-type=lib|staticlib|cdylib|bin`, exported symbol map, `.axlib` archive with interfaces.
- **Files:** `crates/archx-link/src/lib.rs`, `src/main.rs`
- **Acceptance:** an Archx static library is linked by a C program and vice versa.
- **Depends:** AX-033, AX-044 · **Effort:** L · **Risk:** med

#### AX-046 — Cross-compilation and target triples
- **Phase:** P2 · **Area:** Backend · **Priority:** P2
- **Build:** `--target x86_64-linux|aarch64-linux|x86_64-windows|arm64-macos`, sysroot handling, `archx target list`.
- **Files:** `crates/archx-link/src/lib.rs`, `.github/workflows/ci.yml`
- **Acceptance:** CI builds (or cross-compiles + verifies) binaries for all 4 triples.
- **Depends:** AX-033 · **Effort:** L · **Risk:** high

### P3 — Language features that are missing

#### AX-047 — `try`/`except`/`finally`/`raise` (compat dialect)
- **Phase:** P3 · **Area:** Language · **Priority:** P0
- **Build:** Exception hierarchy, `raise`, `except T as e`, `finally`, LLVM `landingpad`/`resume` or a setjmp-based unwind with RAII drops at every cleanup point; stack traces with source spans.
- **Files:** `src/ast.rs`, `src/parser.rs`, `src/codegen/stmt.rs`, `src/codegen/ownership.rs`
- **Acceptance:** 12 programs match CPython exception output; `finally` runs on `break`/`continue`/`return`; ASan clean on unwind.
- **Depends:** AX-001 · **Effort:** XL · **Risk:** high

#### AX-048 — `Result[T,E]` + `?` (native dialect)
- **Phase:** P3 · **Area:** Language · **Priority:** P0
- **Build:** Unboxed `{ i1, T/E }` result, `?` early-return sugar, `err` construction, no unwind tables.
- **Files:** `src/ast.rs`, `src/codegen/tuples_enums.rs`, `src/codegen/expr.rs`
- **Acceptance:** file-not-found is recoverable in a native program; no panic, no leak.
- **Depends:** AX-016 · **Effort:** L · **Risk:** med

#### AX-049 — First-class function values and `Fn[...]` type
- **Phase:** P3 · **Area:** Language · **Priority:** P0
- **Build:** `Type::Fn(params, ret)`, function pointers + capture environments, indirect calls, `f = sq; f(4)`, passing functions as arguments.
- **Files:** `src/ast.rs`, `src/codegen/calls.rs`, `src/codegen/ownership.rs`
- **Acceptance:** `apply(lambda x: x+1, 4)` and higher-order `map` with a function value match CPython.
- **Depends:** AX-047 · **Effort:** L · **Risk:** high

#### AX-050 — Real closures and nested `def`
- **Phase:** P3 · **Area:** Language · **Priority:** P1
- **Build:** Nested function definitions, lexical capture by value/borrow, lifetime analysis, region/heap promotion; lift to `fastcc` functions with leading capture args (extend current lambda lifting).
- **Files:** `src/parser.rs`, `src/codegen/generics.rs`, `src/codegen/ownership.rs`
- **Acceptance:** `def outer(x): def inner(): return x+1; return inner()` works; captured strings don't leak or dangle.
- **Depends:** AX-049 · **Effort:** L · **Risk:** high

#### AX-051 — `yield` generators and `yield from`
- **Phase:** P3 · **Area:** Language · **Priority:** P1
- **Build:** Lower generator functions to explicit state-machine structs, resume/done protocol, integration with `for` and `sum`/`list`.
- **Files:** `src/ast.rs`, `src/parser.rs`, `src/codegen/loops.rs`, `src/codegen/mod.rs`
- **Acceptance:** 6 generator programs match CPython including nested `yield from`.
- **Depends:** AX-049 · **Effort:** XL · **Risk:** high

#### AX-052 — Class inheritance and interfaces
- **Phase:** P3 · **Area:** Language · **Priority:** P1
- **Build:** `class B(A)`, `super()`, vtables for virtual methods, `trait`/`protocol` declarations, static dispatch where provable.
- **Files:** `src/parser.rs`, `src/codegen/mod.rs`, `src/codegen/methods.rs`
- **Acceptance:** polymorphism test matches CPython; native `struct` path unaffected.
- **Depends:** AX-049 · **Effort:** L · **Risk:** high

#### AX-053 — Dunder methods and operator overloading
- **Phase:** P3 · **Area:** Language · **Priority:** P1
- **Build:** `__iter__`, `__next__`, `__getitem__`, `__len__`, `__eq__`, `__str__`, `__add__`, `__enter__`/`__exit__`; user-defined iteration and indexing.
- **Files:** `src/codegen/methods.rs`, `src/codegen/loops.rs`, `src/codegen/expr.rs`
- **Acceptance:** a custom sequence works with `for`, `len`, `xs[i]`, `str()`, `repr()`.
- **Depends:** AX-052 · **Effort:** L · **Risk:** med

#### AX-054 — `*args`, `**kwargs`, `*` unpacking
- **Phase:** P3 · **Area:** Language · **Priority:** P1
- **Build:** Variadic parameter lowering, keyword dict, `f(*xs, **d)`, call-site arity checking.
- **Files:** `src/parser.rs`, `src/codegen/calls.rs`
- **Acceptance:** 10 call-shape programs match CPython including defaults + keywords.
- **Depends:** AX-049 · **Effort:** M · **Risk:** med

#### AX-055 — General `with` context managers
- **Phase:** P3 · **Area:** Language · **Priority:** P1
- **Build:** `with expr as x:` lowering to `__enter__`/`__exit__` with guaranteed cleanup on all exits; keep `with region:` as a native special case.
- **Files:** `src/parser.rs`, `src/codegen/stmt.rs`, `src/codegen/ownership.rs`
- **Acceptance:** file and lock context managers release resources even on exceptions.
- **Depends:** AX-047, AX-053 · **Effort:** M · **Risk:** med

#### AX-056 — `nonlocal`, `del`, and full assignment targets
- **Phase:** P3 · **Area:** Language · **Priority:** P2
- **Build:** `nonlocal` rebinding, `del xs[i]`, `del d[k]`, slice assignment, chained assignment, starred unpacking.
- **Files:** `src/parser.rs`, `src/codegen/stmt.rs`, `src/codegen/collections.rs`
- **Acceptance:** 12 programs match CPython; ASan clean after deletions.
- **Depends:** AX-026 · **Effort:** M · **Risk:** med

#### AX-057 — Decorators
- **Phase:** P3 · **Area:** Language · **Priority:** P2
- **Build:** `@decorator` on functions/classes, applied at compile time where possible (also the home for `@archx.*` optimization and dialect annotations).
- **Files:** `src/lexer.rs`, `src/parser.rs`, `src/codegen/mod.rs`
- **Acceptance:** memoize/static/deprecated decorators work; `@archx.boundscheck(False)` from AX-022 parses.
- **Depends:** AX-049 · **Effort:** M · **Risk:** med

#### AX-058 — Pattern matching completeness
- **Phase:** P3 · **Area:** Language · **Priority:** P2
- **Build:** Sequence/mapping/class/`as` patterns, guards with bindings, exhaustiveness for bool/int ranges/optionals, unreachable-case warnings.
- **Files:** `src/parser.rs`, `src/codegen/pattern_match.rs`
- **Acceptance:** PEP 634 conformance subset matches CPython; exhaustiveness diagnostics have codes.
- **Depends:** AX-052 · **Effort:** M · **Risk:** med

#### AX-059 — Union types, traits, generic constraints
- **Phase:** P3 · **Area:** Types · **Priority:** P2
- **Build:** `A | B` beyond `T | None`, `trait` bounds on `[T]`, literal types, `NewType`, variance annotations.
- **Files:** `src/ast.rs`, `src/parser.rs`, `src/codegen/generics.rs`, `crates/archx-sema/src/lib.rs`
- **Acceptance:** constrained generic rejects bad instantiation with a clear diagnostic.
- **Depends:** AX-052 · **Effort:** L · **Risk:** med

#### AX-060 — `any` tier-2 hardening
- **Phase:** P3 · **Area:** Types · **Priority:** P1
- **Build:** Dynamic type errors with source spans (not generic panic), `isinstance` for user types, `type(x)` name, safe `any` arithmetic for all opcode combinations (the v0.9.1 `%` bug class).
- **Files:** `src/codegen/any.rs`, `src/codegen/runtime_hash_any.rs`
- **Acceptance:** fuzz 10k random `any` expressions against CPython with identical results/errors.
- **Depends:** AX-023 · **Effort:** L · **Risk:** med

#### AX-061 — `async`/`await` and concurrency primitives
- **Phase:** P3 · **Area:** Language · **Priority:** P3
- **Build:** Coroutine lowering, event loop, `thread`, `Mutex`, `Channel`, atomics; race-safety story in the spec.
- **Files:** `src/ast.rs`, `src/parser.rs`, `stdlib/concurrency.ax`, `crates/archx-runtime/src/lib.rs`
- **Acceptance:** producer/consumer channel test; TSan clean.
- **Depends:** AX-051 · **Effort:** XL · **Risk:** high

#### AX-062 — Move/borrow annotations and cycle handling
- **Phase:** P3 · **Area:** Memory · **Priority:** P2
- **Build:** `borrow`, `move`, `owned` parameter modes (Mojo's `read/inout/owned` model [5](https://www.modular.com/blog/an-easy-introduction-to-mojo-for-python-programmers)), weak references or explicit graph ownership to avoid leaks in cyclic structures.
- **Files:** `src/parser.rs`, `src/codegen/ownership.rs`, `docs/Architecture.md`
- **Acceptance:** cyclic graph program is leak-free under ASan; borrow checker rejects use-after-move.
- **Depends:** AX-001 · **Effort:** XL · **Risk:** high

#### AX-063 — `comptime` / macros (optional)
- **Phase:** P3 · **Area:** Language · **Priority:** P3
- **Build:** Compile-time evaluation, hygienic macros, templated code generation; keep out of native dialect initially.
- **Files:** `crates/archx-sema/src/comptime.rs`, `src/parser.rs`
- **Acceptance:** `comptime` constant folding removes loops from IR; hygiene test.
- **Depends:** AX-059 · **Effort:** XL · **Risk:** high

#### AX-064 — Error codes for I/O (supporting AX-038/048)
- **Phase:** P3 · **Area:** Stdlib · **Priority:** P1
- **Build:** `IoError` enum, `errno` mapping, `Result` returns from all stdlib I/O.
- **Files:** `stdlib/fs.ax`, `stdlib/io.ax`, `src/codegen/runtime.rs`
- **Acceptance:** missing file returns `Err(NotFound)` instead of aborting.
- **Depends:** AX-048 · **Effort:** S · **Risk:** low

#### AX-065 — `repr`/`str` protocol for user types
- **Phase:** P3 · **Area:** Language · **Priority:** P2
- **Build:** Auto-generated `repr`/`str` for structs/enums in compat dialect; custom overrides via dunders.
- **Files:** `src/codegen/io.rs`, `src/codegen/mod.rs`
- **Acceptance:** `print([Point(1,2)])` matches CPython representation rules.
- **Depends:** AX-053 · **Effort:** M · **Risk:** med

#### AX-066 — Chained/negative/keyword semantics pass
- **Phase:** P3 · **Area:** Frontend · **Priority:** P1
- **Build:** Fix every remaining CPython divergence from the audit: `-7.0 % 3.0`, `round` banker's rounding, f-string `=` debug spec, nested f-string expressions, `set.pop`, `dict` deletion order, `sort` stability with tuples.
- **Files:** `src/codegen/expr.rs`, `src/codegen/io.rs`, `src/codegen/collections.rs`, `tests/conformance/`
- **Acceptance:** all 123 audit probes pass in compat dialect (or are documented native-only).
- **Depends:** AX-007 · **Effort:** L · **Risk:** med

#### AX-067 — `if __name__` / entry-point model for multi-file
- **Phase:** P3 · **Area:** Frontend · **Priority:** P1
- **Build:** Define module init semantics, `main()` selection, `__name__` per module, `archx run module`.
- **Files:** `src/parser.rs`, `crates/archx-driver/src/lib.rs`
- **Acceptance:** imported module does not execute its `__main__` block.
- **Depends:** AX-030 · **Effort:** S · **Risk:** low

#### AX-068 — Constant evaluation and compile-time proofs registry
- **Phase:** P3 · **Area:** Sema · **Priority:** P1
- **Build:** One `Proof` enum (range, nonnull, disjoint, no-overflow, aligned, noalias, loop-bound) attached to IR values; every elided check cites a proof; `archx explain-perf` prints them.
- **Files:** `crates/archx-sema/src/proofs.rs`, `src/codegen/memory.rs`, `src/codegen/expr.rs`
- **Acceptance:** no `nsw`/`nuw`/elided bounds check exists without a recorded proof; audit script enforces it.
- **Depends:** AX-002, AX-013 · **Effort:** L · **Risk:** high

#### AX-069 — Integer/float semantic spec and tests
- **Phase:** P3 · **Area:** Spec · **Priority:** P1
- **Build:** Document and test division, modulo, `**`, `int()`, `float()`, NaN/Inf, `-0.0`, overflow, rounding per dialect.
- **Files:** `docs/SPEC.md`, `tests/conformance/numbers.ax`
- **Acceptance:** 60 numeric edge cases match CPython in compat; documented deterministic results in native.
- **Depends:** AX-002, AX-027 · **Effort:** M · **Risk:** med

#### AX-070 — `match` exhaustiveness for non-enum types
- **Phase:** P3 · **Area:** Sema · **Priority:** P2
- **Build:** Extend exhaustiveness to bool/optional/tuple/literal/range subjects; warn on redundant arms.
- **Files:** `src/codegen/pattern_match.rs`, `crates/archx-sema/src/lib.rs`
- **Acceptance:** missing-case compile error with code; no runtime fallthrough abort.
- **Depends:** AX-058 · **Effort:** M · **Risk:** low

### P4 — Compiler-internal modularity (clean, readable multi-file architecture)

#### AX-071 — Cargo workspace split
- **Phase:** P4 · **Area:** Architecture · **Priority:** P1
- **Build:** Create the 12 crates from §3 with explicit `pub` API boundaries; move files without behavior change; one `cargo test` for all.
- **Files:** `Cargo.toml` (workspace), `crates/*/Cargo.toml`, `src/*`
- **Acceptance:** all 69 existing tests pass unchanged; no crate depends on another's internals.
- **Depends:** AX-004 · **Effort:** L · **Risk:** med

#### AX-072 — Typed IR builder replacing string concatenation
- **Phase:** P4 · **Area:** Architecture · **Priority:** P0
- **Build:** `IrModule`/`IrFn`/`BlockId`/`ValueId` builder with typed operands; emit verified textual IR at the end; eliminate hand-written `format!("  %{} = ...")` across codegen.
- **Files:** `crates/archx-ir/src/lib.rs`, `src/codegen/*.rs`
- **Acceptance:** `llvm-as` verifies every emitted module; phi-predecessor bugs like the v0.9.1 one become impossible by construction.
- **Depends:** AX-009, AX-071 · **Effort:** XL · **Risk:** high

#### AX-073 — HIR + name resolution layer
- **Phase:** P4 · **Area:** Architecture · **Priority:** P1
- **Build:** Typed HIR with `DefMap`/`ItemTree` summaries stable across body edits (rust-analyzer's invariant [4](https://git.jeffas.net/rust-analyzer/files/docs/dev/architecture.md.html)); move type inference out of codegen.
- **Files:** `crates/archx-hir/src/lib.rs`, `crates/archx-sema/src/lib.rs`
- **Acceptance:** `archx check` works without emitting any IR; type errors have HIR spans.
- **Depends:** AX-071 · **Effort:** XL · **Risk:** high

#### AX-074 — Explicit pass manager
- **Phase:** P4 · **Area:** Architecture · **Priority:** P1
- **Build:** Ordered passes: lex → parse → resolve → typecheck → borrow/escape → proofs → monomorphize → drop insertion → IR → verify → optimize → link; each pass independently unit-testable with golden files.
- **Files:** `crates/archx-driver/src/passes.rs`, `crates/*/src/lib.rs`
- **Acceptance:** `--dump-pass=<name>` snapshot tests for all 12 passes.
- **Depends:** AX-073 · **Effort:** L · **Risk:** med

#### AX-075 — Break up the `Codegen` god object
- **Phase:** P4 · **Area:** Architecture · **Priority:** P1
- **Build:** Split `mod.rs` state into `CodegenCtx`, `FnCtx`, `TypeRegistry`, `RuntimeRegistry`, `Monomorphizer`, `DropInserter`; each codegen file owns one concern and is <800 lines.
- **Files:** `src/codegen/mod.rs`, `src/codegen/*.rs`
- **Acceptance:** no file >800 lines; `cargo clippy` clean; IR byte-identical to pre-refactor.
- **Depends:** AX-071 · **Effort:** L · **Risk:** med

#### AX-076 — Unified runtime registry
- **Phase:** P4 · **Area:** Architecture · **Priority:** P2
- **Build:** Replace scattered `used_*` booleans with a registry that declares each helper once with its dialect requirements, dependencies and IR body, and emits only reachable helpers in topological order.
- **Files:** `src/codegen/runtime.rs`, `src/codegen/runtime_py.rs`, `src/codegen/runtime_hash_any.rs`
- **Acceptance:** adding a helper requires one registration; no duplicate declarations in IR.
- **Depends:** AX-072 · **Effort:** M · **Risk:** med

#### AX-077 — Golden IR + property/fuzz testing
- **Phase:** P4 · **Area:** Tests · **Priority:** P1
- **Build:** Golden `.ll` snapshots per feature, parser fuzzing with random token streams, differential fuzzing of expressions vs CPython.
- **Files:** `tests/ir_golden/`, `tests/fuzz.rs`, `.github/workflows/ci.yml`
- **Acceptance:** 10k fuzz cases with no compiler panic; golden diffs reviewed.
- **Depends:** AX-072 · **Effort:** L · **Risk:** low

#### AX-078 — rustdoc, architecture invariants, rustfmt/clippy/coverage
- **Phase:** P4 · **Area:** Architecture · **Priority:** P2
- **Build:** Document each crate's single responsibility and invariants; enforce `cargo fmt --check`, clippy, `cargo llvm-cov` in CI.
- **Files:** `crates/*/src/lib.rs`, `docs/Architecture.md`, `.github/workflows/ci.yml`
- **Acceptance:** CI green with coverage ≥70% on frontend/sema.
- **Depends:** AX-071 · **Effort:** M · **Risk:** low

#### AX-079 — Compile-time benchmark and memory budget
- **Phase:** P4 · **Area:** Tests · **Priority:** P2
- **Build:** Track compile seconds and peak RSS for a 100k-line project; fail on >10% regression.
- **Files:** `benchmarks/compile_time.sh`, `ci/out/compile_time.txt`
- **Acceptance:** dashboard shows per-commit trend.
- **Depends:** AX-036 · **Effort:** S · **Risk:** low

#### AX-080 — Diagnostic JSON/SARIF output (finish AX-011)
- **Phase:** P4 · **Area:** Tooling · **Priority:** P2
- **Build:** Emit SARIF for GitHub annotations; all passes report through `DiagnosticSink`.
- **Files:** `src/diag.rs`, `crates/*/src/lib.rs`, `.github/workflows/ci.yml`
- **Acceptance:** CI shows inline annotations on PR diffs.
- **Depends:** AX-011, AX-071 · **Effort:** M · **Risk:** low

#### AX-081 — Stable public compiler API (`libarchx`)
- **Phase:** P4 · **Area:** Architecture · **Priority:** P2
- **Build:** `archx::compile(source) -> CompileResult` facade for LSP, REPL, third-party tools; semver-documented.
- **Files:** `crates/archx-driver/src/lib.rs`, `docs/API.md`
- **Acceptance:** an external crate compiles a string and reports diagnostics without invoking the CLI.
- **Depends:** AX-071 · **Effort:** M · **Risk:** low

#### AX-082 — Remove all hardcoded magic with a single constants module
- **Phase:** P4 · **Area:** Architecture · **Priority:** P3
- **Build:** Centralize `2^47` bound, 64 KB slabs, 12-byte SSO, `<16 x i8>` width, 64-byte dict header, ABI tags into one module with docs.
- **Files:** `crates/archx-runtime/src/abi.rs`, `src/codegen/*.rs`
- **Acceptance:** grep finds no duplicated numeric ABI constants.
- **Depends:** AX-076 · **Effort:** S · **Risk:** low

### P5 — Optimizations out of the box

#### AX-083 — IR attribute emission pass
- **Phase:** P5 · **Area:** Optimize · **Priority:** P0
- **Build:** Emit `noalias`, `align`, `nonnull`, `dereferenceable`, `nounwind`, `readonly`/`writeonly`, `willreturn`, `mustprogress`, `cold`, `hot`, `alwaysinline` on functions/args/returns per LangRef semantics [1](https://llvm.org/docs/LangRef.html).
- **Files:** `crates/archx-ir/src/attrs.rs`, `src/codegen/mod.rs`, `src/codegen/runtime.rs`
- **Acceptance:** `ci/out/*.opt.ll` shows the attributes; differential output unchanged; benchmark A/B ≥0%.
- **Depends:** AX-072 · **Effort:** M · **Risk:** med

#### AX-084 — TBAA, alias.scope, !range, llvm.assume
- **Phase:** P5 · **Area:** Optimize · **Priority:** P1
- **Build:** Attach `!tbaa` per typed plane, `!alias.scope`/`!noalias` for disjoint SoA buffers, `!range` on lengths/indices, `llvm.assume` on proven invariants and `llvm.expect`/`!prof` on hot branches [1](https://llvm.org/docs/LangRef.html).
- **Files:** `crates/archx-ir/src/metadata.rs`, `src/codegen/memory.rs`, `src/codegen/loops.rs`
- **Acceptance:** vectorizer eliminates redundant loads in arrays/composite suites; ASan clean.
- **Depends:** AX-068, AX-083 · **Effort:** L · **Risk:** high

#### AX-085 — Unique `!llvm.loop` metadata per loop
- **Phase:** P5 · **Area:** Optimize · **Priority:** P0
- **Build:** Self-referential loop IDs, `mustprogress`, `vectorize.enable/width`, `interleave.count`, `unroll.count` from loop shape; fix the fused comprehension loops to emit distinct nodes [1](https://llvm.org/docs/LangRef.html).
- **Files:** `src/codegen/loops.rs`, `src/codegen/comprehensions.rs`, `crates/archx-ir/src/metadata.rs`
- **Acceptance:** `opt -passes=loop-vectorize -debug-pass-manager` confirms vectorization on suites 2/4/7.
- **Depends:** AX-072 · **Effort:** M · **Risk:** med

#### AX-086 — Explicit `opt` release pipeline
- **Phase:** P5 · **Area:** Optimize · **Priority:** P1
- **Build:** `--opt-pipeline=default|aggressive` with the pass order from §2; inlining before vectorization, SROA after unroll, LICM/GVN after vectorize [3](https://www.intel.com/content/www/us/en/developer/articles/technical/optimizing-llvm-code-generation-for-data-analytics.html), [1](https://www.reddit.com/r/Compilers/comments/1hqmd7x/recommended_llvm_passes/).
- **Files:** `crates/archx-link/src/pipeline.rs`, `src/main.rs`
- **Acceptance:** byte-identical outputs across all 7 suites; measured speedup recorded.
- **Depends:** AX-085 · **Effort:** L · **Risk:** med

#### AX-087 — Optional Polly for affine loop nests
- **Phase:** P5 · **Area:** Optimize · **Priority:** P3
- **Build:** `--polly` flag with `-mllvm -polly -polly-vectorizer=stripmine`, canonicalization before Polly [4](https://polly.llvm.org/docs/UsingPollyWithClang.html), [2](https://media.readthedocs.org/pdf/polly-/latest/polly-.pdf).
- **Files:** `crates/archx-link/src/pipeline.rs`
- **Acceptance:** nbody/composite A/B; keep only if ≥3% gain with identical output.
- **Depends:** AX-086 · **Effort:** M · **Risk:** med

#### AX-088 — Opt-in fast-math with dialect guard
- **Phase:** P5 · **Area:** Optimize · **Priority:** P2
- **Build:** `@archx.fast_math` → `nnan/ninf/nsz/arcp/contract/reassoc/afn` flags; rejected in compat dialect; never applied globally [1](https://llvm.org/docs/LangRef.html).
- **Files:** `src/dialect_rules.rs`, `src/codegen/expr.rs`, `docs/DIALECTS.md`
- **Acceptance:** compat output stays byte-identical; native nbody shows measured gain.
- **Depends:** AX-016 · **Effort:** M · **Risk:** high

#### AX-089 — CPU targeting and multiversioning
- **Phase:** P5 · **Area:** Optimize · **Priority:** P2
- **Build:** `-march=native`, `-mtune`, `@archx.target("avx2")`, IFUNC-based clones, `-mcpu` for aarch64.
- **Files:** `crates/archx-link/src/lib.rs`, `src/codegen/mod.rs`
- **Acceptance:** AVX2 binary runs on AVX2 host, baseline binary runs everywhere; no illegal instruction.
- **Depends:** AX-035 · **Effort:** L · **Risk:** med

#### AX-090 — PGO pipeline (instrumented)
- **Phase:** P5 · **Area:** Optimize · **Priority:** P1
- **Build:** `archx build --pgo=generate` → training run → `llvm-profdata merge` → `--pgo=use`; profiles stored per benchmark [1](https://llvm.org/docs/AdvancedBuilds.html), [9](https://c.wsmoses.com/presentations/LLVM%20performance%20tutorial.pdf).
- **Files:** `crates/archx-link/src/pgo.rs`, `benchmarks/run.sh`, `docs/OPTIMIZATION.md`
- **Acceptance:** ≥5% gain on full_tour with byte-identical output; CI records the profile.
- **Depends:** AX-035 · **Effort:** L · **Risk:** med

#### AX-091 — AutoFDO / CSSPGO sampling profiles
- **Phase:** P5 · **Area:** Optimize · **Priority:** P2
- **Build:** `perf`→`llvm-profgen`→sample profile path; context-sensitive option (CSSPGO adds 1–5% over AutoFDO on production workloads [3](https://htyu.github.io/paper/Revamping_Sampling_based_PGO_with_Context_sensitivity_and_Pseudo_instrumentation_preprint.pdf)).
- **Files:** `crates/archx-link/src/pgo.rs`, `ci/out/profiles/`
- **Acceptance:** AutoFDO build beats uninstrumented PGO-less build; stale-profile handling documented [5](https://cdck-file-uploads-us1.s3.dualstack.us-west-2.amazonaws.com/flex021/uploads/llvm/original/3X/2/f/2f9111df68d87d7574693613dd545e6da6d57511.pdf).
- **Depends:** AX-090 · **Effort:** L · **Risk:** high

#### AX-092 — BOLT post-link optimization
- **Phase:** P5 · **Area:** Optimize · **Priority:** P2
- **Build:** Preserve relocations (`-Wl,-q`), instrument, train, `llvm-bolt -reorder-blocks=ext-tsp -reorder-functions=hfsort+ -split-functions` [6](https://fzakaria.com/2026/05/23/leaving-performance-on-the-table); up to 7% on top of FDO+LTO reported for datacenter workloads [4](https://jnamaral.github.io/CDOL/papers/PanchenkoCGO19.pdf).
- **Files:** `crates/archx-link/src/bolt.rs`, `.github/workflows/ci.yml`
- **Acceptance:** A/B gate keeps only ≥2% gains with byte-identical output; ICF disabled unless proven safe.
- **Depends:** AX-090 · **Effort:** L · **Risk:** med

#### AX-093 — Hot/cold splitting and branch weights
- **Phase:** P5 · **Area:** Optimize · **Priority:** P2
- **Build:** Mark panic/assert/overflow paths `cold` + `!prof` weights; outline slow generic `any` paths; put hot loops in one section.
- **Files:** `src/codegen/runtime.rs`, `src/codegen/any.rs`, `crates/archx-ir/src/metadata.rs`
- **Acceptance:** instruction-cache profile improves; no output change.
- **Depends:** AX-083 · **Effort:** M · **Risk:** low

#### AX-094 — Escape-analysis-driven stack/region promotion
- **Phase:** P5 · **Area:** Optimize · **Priority:** P1
- **Build:** Promote non-escaping lists/strings/tuples/enums to stack or region; elide malloc/free entirely; handle `return` promotion with a proof.
- **Files:** `crates/archx-sema/src/escape.rs`, `src/codegen/ownership.rs`, `src/codegen/memory.rs`
- **Acceptance:** `composite` suite shows fewer `malloc` calls in IR; ASan 11/11 clean.
- **Depends:** AX-068 · **Effort:** L · **Risk:** high

#### AX-095 — Monomorphic inline caches / adaptive re-specialization
- **Phase:** P5 · **Area:** Optimize · **Priority:** P2
- **Build:** Guard + deopt at call sites and dynamic ops; counters to re-specialize after N failures; guard model from CPython PEP 659 and Cinder [3](https://latest2all.com/tutorial/advanced-condition-variable-spurious-wakeups-and-osr-core-mechanism.html), [5](https://engineering.fb.com/2022/05/02/open-source/cinder-jits-instagram/).
- **Files:** `src/codegen/any.rs`, `src/codegen/calls.rs`, `crates/archx-runtime/src/lib.rs`
- **Acceptance:** polymorphic benchmark stays correct; monomorphic benchmark within 5% of static code.
- **Depends:** AX-023 · **Effort:** XL · **Risk:** high

#### AX-096 — Allocation and container micro-optimizations
- **Phase:** P5 · **Area:** Optimize · **Priority:** P1
- **Build:** Region slab reuse/pooling, `memcpy`/`memmove` fast paths, branchless filter compaction (already), small-size specializations for dict/list/set, prefetch in SwissTable probe, zero-page `calloc` for float arrays, move-not-clone for owned payloads.
- **Files:** `src/codegen/memory.rs`, `src/codegen/collections.rs`, `src/codegen/comprehensions.rs`
- **Acceptance:** suite 3/5 improves ≥5% with identical output and no ASan regressions.
- **Depends:** AX-094 · **Effort:** L · **Risk:** med

#### AX-097 — Hardened release profile (near-zero-cost safety)
- **Phase:** P5 · **Area:** Safety · **Priority:** P1
- **Build:** UBSan integer with minimal runtime + trap-on-error (~1% cost [1](https://airbus-seclab.github.io/c-compiler-security/clang_compilation.html)), `-fstack-protector-strong`, `-D_FORTIFY_SOURCE=2`, `-fcf-protection=full`, PIE, `-fvisibility=hidden` [5](https://best.openssf.org/Compiler-Hardening-Guides/Compiler-Options-Hardening-Guide-for-C-and-C++.html).
- **Files:** `crates/archx-link/src/lib.rs`, `.github/workflows/ci.yml`
- **Acceptance:** hardened build passes all suites with <3% slowdown; overflow now traps (AX-002).
- **Depends:** AX-002 · **Effort:** M · **Risk:** low

#### AX-098 — Sanitizer matrix beyond ASan/LSan
- **Phase:** P5 · **Area:** Safety · **Priority:** P1
- **Build:** UBSan, MSan, TSan, HWASan (AArch64), CFI, safe-stack/shadow-call-stack profiles [3](https://hivebook.wiki/wiki/llvm-22-compiler-infrastructure-clang-lld-mlir-sanitizers-bolt), [1](https://airbus-seclab.github.io/c-compiler-security/clang_compilation.html).
- **Files:** `.github/workflows/ci.yml`, `ci/logs/`
- **Acceptance:** each sanitizer runs the 11 targets and publishes a log; 0 findings.
- **Depends:** AX-001 · **Effort:** M · **Risk:** med

#### AX-099 — Continuous perf dashboard and 1% regression gate
- **Phase:** P5 · **Area:** CI · **Priority:** P0
- **Build:** Per-commit benchmark table (7 suites × 4 languages), binary size, compile time, conformance %, sanitizer status; PR gate on any regression.
- **Files:** `.github/workflows/ci.yml`, `ci/out/dashboard.md`, `benchmarks/run.sh`
- **Acceptance:** every PR comment shows deltas; regressions block merge.
- **Depends:** AX-021, AX-077 · **Effort:** M · **Risk:** low

#### AX-100 — Proof-carrying optimization audit
- **Phase:** P5 · **Area:** Safety · **Priority:** P1
- **Build:** Script that scans emitted IR for `nsw`/`nuw`/`inbounds`/elided checks and requires a matching `Proof` record (AX-068); fail CI otherwise. Directly targets the sort `inbounds` poison bug class.
- **Files:** `tools/audit_proofs.py`, `crates/archx-sema/src/proofs.rs`
- **Acceptance:** v0.9.0 sort bug reproducer is rejected by the audit; all current IR passes.
- **Depends:** AX-068, AX-072 · **Effort:** M · **Risk:** med

### P6 — Tooling and developer experience

#### AX-101 — `archx build` / `run` / `test` / `clean` command set
- **Phase:** P6 · **Area:** Tooling · **Priority:** P1
- **Build:** Replace the single-file CLI with project commands and profiles `debug|release|hardened|pgo|bolt`.
- **Files:** `crates/archx-cli/src/main.rs`, `docs/USAGE.md`
- **Acceptance:** `archx build && archx test && archx run` works in a 20-module project.
- **Depends:** AX-029 · **Effort:** M · **Risk:** low

#### AX-102 — Formatter `archx fmt`
- **Phase:** P6 · **Area:** Tooling · **Priority:** P1
- **Build:** Idempotent, dialect-preserving, 4-space canonical style; `--check` in CI.
- **Files:** `crates/archx-cli/src/fmt.rs`, `tests/fmt/`
- **Acceptance:** `fmt(fmt(x)) == fmt(x)` on the whole repo; compat files remain valid CPython.
- **Depends:** AX-013 · **Effort:** M · **Risk:** low

#### AX-103 — Linter `archx lint`
- **Phase:** P6 · **Area:** Tooling · **Priority:** P2
- **Build:** Unused vars, shadowing, `any` promotions, missing `pub`, dialect mixing, unchecked unsafe, perf hints from AX-018.
- **Files:** `crates/archx-lsp/src/lint.rs`, `crates/archx-cli/src/main.rs`
- **Acceptance:** lint findings have codes and fix-its; zero warnings on the stdlib.
- **Depends:** AX-018 · **Effort:** M · **Risk:** low

#### AX-104 — LSP server
- **Phase:** P6 · **Area:** Tooling · **Priority:** P2
- **Build:** Completion, go-to-def, hover types, rename, diagnostics, cross-module; reuse query DB (salsa-style incrementality [1](https://rust-analyzer.github.io//blog/2020/07/20/three-architectures-for-responsive-ide.html)).
- **Files:** `crates/archx-lsp/src/lib.rs`, `editors/vscode/`
- **Acceptance:** 10 LSP integration tests; editor extension loads.
- **Depends:** AX-036, AX-081 · **Effort:** XL · **Risk:** med

#### AX-105 — DWARF debug info and debugger support
- **Phase:** P6 · **Area:** Tooling · **Priority:** P1
- **Build:** Emit `!dbg`/DI metadata, source maps, line tables, variable locations; `archx build --debug`; lldb/gdb breakpoints on Archx lines.
- **Files:** `crates/archx-ir/src/debug.rs`, `src/codegen/mod.rs`, `tests/cli.rs`
- **Acceptance:** `lldb` stops at line N and prints an Archx local; panic backtraces show source lines.
- **Depends:** AX-072 · **Effort:** L · **Risk:** med

#### AX-106 — Archx test framework and coverage
- **Phase:** P6 · **Area:** Tooling · **Priority:** P2
- **Build:** `test fn`, `assert`, `archx test` runner, per-module test discovery, source coverage.
- **Files:** `stdlib/test.ax`, `crates/archx-driver/src/test.rs`
- **Acceptance:** stdlib tests run with `archx test`; coverage report generated.
- **Depends:** AX-030 · **Effort:** M · **Risk:** low

#### AX-107 — REPL / ORC JIT (after modules)
- **Phase:** P6 · **Area:** Tooling · **Priority:** P3
- **Build:** `archx repl` with incremental compilation via LLVM ORC, compat dialect default.
- **Files:** `crates/archx-cli/src/repl.rs`, `crates/archx-link/src/jit.rs`
- **Acceptance:** expressions, imports, and function definitions persist across REPL lines.
- **Depends:** AX-030, AX-081 · **Effort:** XL · **Risk:** high

#### AX-108 — `archx doc` generator
- **Phase:** P6 · **Area:** Tooling · **Priority:** P3
- **Build:** Doc comments → HTML with signatures, examples, cross-links.
- **Files:** `crates/archx-cli/src/doc.rs`, `docs/`
- **Acceptance:** stdlib docs build and publish as a static site (inline assets for preview).
- **Depends:** AX-030 · **Effort:** M · **Risk:** low

#### AX-109 — tree-sitter grammar + editor syntax files
- **Phase:** P6 · **Area:** Tooling · **Priority:** P3
- **Build:** Grammar covering both dialects; highlight/indent/fold for VS Code, Vim, JetBrains.
- **Files:** `editors/tree-sitter-archx/`, `editors/*`
- **Acceptance:** grammar parses all examples with zero errors.
- **Depends:** AX-013 · **Effort:** M · **Risk:** low

#### AX-110 — Build cache and offline mode
- **Phase:** P6 · **Area:** Build · **Priority:** P2
- **Build:** Content-addressed cache for objects/interfaces/IR, `--offline`, `archx cache gc`.
- **Files:** `crates/archx-driver/src/cache.rs`
- **Acceptance:** second clean build of a warm cache is >5× faster; offline build works.
- **Depends:** AX-036 · **Effort:** M · **Risk:** low

#### AX-111 — `archx explain` documentation for every diagnostic
- **Phase:** P6 · **Area:** Tooling · **Priority:** P2
- **Build:** Generate docs from diagnostic codes; `archx explain E0100` prints cause + fix + dialect note.
- **Files:** `src/diag.rs`, `docs/errors/`
- **Acceptance:** 100% diagnostic code coverage in docs.
- **Depends:** AX-011 · **Effort:** S · **Risk:** low

#### AX-112 — `archx doctor` environment checker
- **Phase:** P6 · **Area:** Tooling · **Priority:** P3
- **Build:** Detect clang/lld/BOLT/perf versions, target support, PATH issues (the repo already has `find_clang` heuristics to generalize).
- **Files:** `crates/archx-cli/src/doctor.rs`, `src/main.rs`
- **Acceptance:** clean report on all 3 OS; actionable message when a tool is missing.
- **Depends:** AX-090 · **Effort:** S · **Risk:** low

### P7 — Specification, semantics, conformance

#### AX-113 — Formal grammar (EBNF) for both dialects
- **Phase:** P7 · **Area:** Spec · **Priority:** P0
- **Build:** `docs/GRAMMAR.md` generated from the parser, with dialect annotations per production.
- **Files:** `docs/GRAMMAR.md`, `src/parser.rs`, `tools/grammar_gen.py`
- **Acceptance:** grammar parses every example; diff between doc and parser fails CI.
- **Depends:** AX-013 · **Effort:** M · **Risk:** low

#### AX-114 — Language reference / semantics spec
- **Phase:** P7 · **Area:** Spec · **Priority:** P0
- **Build:** `docs/SPEC.md`: evaluation order, type system, ownership/RAII, ABI layouts, dialect rules, integer/float semantics, memory model, error model, UB list.
- **Files:** `docs/SPEC.md`, `docs/Architecture.md`, `docs/FUNDAMENTALS.md`
- **Acceptance:** every implementation divergence from CPython is either specified or a tracked bug.
- **Depends:** AX-069 · **Effort:** L · **Risk:** low

#### AX-115 — CPython conformance suite on 3 Python versions
- **Phase:** P7 · **Area:** Tests · **Priority:** P0
- **Build:** Run the 94+ probes against CPython 3.11/3.12/3.13 in CI; publish a conformance percentage.
- **Files:** `tests/conformance/`, `.github/workflows/ci.yml`
- **Acceptance:** compat dialect ≥95% pass on all versions; failures documented with codes.
- **Depends:** AX-007, AX-066 · **Effort:** M · **Risk:** med

#### AX-116 — Versioning, stability and deprecation policy
- **Phase:** P7 · **Area:** Spec · **Priority:** P1
- **Build:** Semver policy, supported dialect versions, deprecation windows, migration guides.
- **Files:** `docs/STABILITY.md`, `docs/Changelog.md`, `README.md`
- **Acceptance:** every breaking change has a migration note and a version bump.
- **Depends:** AX-006 · **Effort:** S · **Risk:** low

#### AX-117 — Security model and unsafe boundary
- **Phase:** P7 · **Area:** Spec · **Priority:** P1
- **Build:** Document what `unsafe`/FFI/`boundscheck(False)` may break, sanitizer expectations, threat model.
- **Files:** `docs/SECURITY.md`, `docs/DIALECTS.md`
- **Acceptance:** every unsafe construct requires an explicit marker and is linted.
- **Depends:** AX-022, AX-044 · **Effort:** M · **Risk:** low

#### AX-118 — RFC process and issue templates
- **Phase:** P7 · **Area:** Governance · **Priority:** P2
- **Build:** `rfcs/0000-template.md`, issue/bug/feature templates, decision log.
- **Files:** `rfcs/`, `.github/ISSUE_TEMPLATE/`, `docs/Rules.md`
- **Acceptance:** first RFC for the dialect spec is merged before v1.0.
- **Depends:** AX-114 · **Effort:** S · **Risk:** low

#### AX-119 — Third-party program validation
- **Phase:** P7 · **Area:** Tests · **Priority:** P0
- **Build:** Compile 5 real programs written by someone other than the compiler author (CLI tool, JSON parser, small game, data pipeline, web-ish server) and fix everything that breaks.
- **Files:** `examples/third_party/`, `ci/out/`
- **Acceptance:** all 5 build, pass their own tests, and are ASan-clean.
- **Depends:** AX-030, AX-047, AX-038 · **Effort:** XL · **Risk:** high

#### AX-120 — Definition-of-done v1.0 checklist
- **Phase:** P7 · **Area:** Governance · **Priority:** P1
- **Build:** Encode the north-star from §0 as a CI-checked checklist (modules, errors, stdlib, spec, tests, release, third-party programs).
- **Files:** `docs/V1_CHECKLIST.md`, `.github/workflows/ci.yml`
- **Acceptance:** all boxes ticked before tagging `v1.0.0`.
- **Depends:** AX-119 · **Effort:** S · **Risk:** low

### P8 — Distribution and ecosystem

#### AX-121 — Release artifacts for 3 OS + 2 architectures
- **Phase:** P8 · **Area:** Release · **Priority:** P1
- **Build:** GitHub Releases with stripped binaries, checksums, signatures, SBOM.
- **Files:** `.github/workflows/release.yml`, `ci/out/`
- **Acceptance:** fresh machine downloads and runs `archx --version`.
- **Depends:** AX-006, AX-046 · **Effort:** M · **Risk:** low

#### AX-122 — Installers and toolchain manager
- **Phase:** P8 · **Area:** Release · **Priority:** P2
- **Build:** curl installer, Homebrew, Scoop, apt repo; `archxup` for pinned toolchains.
- **Files:** `packaging/`, `docs/USAGE.md`
- **Acceptance:** install + `archx build examples/hello.archx.lang` on all 3 OS.
- **Depends:** AX-121 · **Effort:** L · **Risk:** med

#### AX-123 — Expanded CI matrix
- **Phase:** P8 · **Area:** CI · **Priority:** P1
- **Build:** clang 15–22, x86_64/aarch64, debug/release/hardened/sanitizer, 3 OS, conformance on 3 Pythons.
- **Files:** `.github/workflows/ci.yml`, `ci/test-history/`
- **Acceptance:** matrix green; logs committed; retention policy documented.
- **Depends:** AX-098, AX-115 · **Effort:** L · **Risk:** med

#### AX-124 — Tutorials, cookbook, migration guide
- **Phase:** P8 · **Area:** Docs · **Priority:** P2
- **Build:** Getting started, "Python → Archx compat", "compat → native for speed", stdlib recipes, performance guide.
- **Files:** `docs/tutorials/`, `README.md`
- **Acceptance:** a new reader completes a 15-minute tutorial without hitting an undocumented error.
- **Depends:** AX-114, AX-019 · **Effort:** M · **Risk:** low

#### AX-125 — Community and governance basics
- **Phase:** P8 · **Area:** Governance · **Priority:** P2
- **Build:** CONTRIBUTING, CODE_OF_CONDUCT, labels, issue triage, release notes automation.
- **Files:** `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `.github/`
- **Acceptance:** external PR merged and released.
- **Depends:** AX-118 · **Effort:** S · **Risk:** low

#### AX-126 — Public benchmark methodology document
- **Phase:** P8 · **Area:** Docs · **Priority:** P1
- **Build:** Document how numbers are measured (iterations, warmup, `-ffp-contract=off`, CPU pinning, variance), and label self-authored vs third-party benchmarks.
- **Files:** `benchmarks/README.md`, `docs/OPTIMIZATION.md`, `ci/out/benchmarks.txt`
- **Acceptance:** README table is auto-generated from the raw log; no stale numbers.
- **Depends:** AX-003, AX-099 · **Effort:** M · **Risk:** low

#### AX-127 — Website / docs publishing
- **Phase:** P8 · **Area:** Docs · **Priority:** P3
- **Build:** Static site with spec, grammar, dialect guide, benchmark dashboard, stdlib API.
- **Files:** `site/`, `.github/workflows/docs.yml`
- **Acceptance:** site builds offline with inline assets and no CDN dependency.
- **Depends:** AX-108, AX-126 · **Effort:** M · **Risk:** low

#### AX-128 — Post-v1.0 research track (explicitly deferred)
- **Phase:** P8 · **Area:** Research · **Priority:** P3
- **Build:** Evaluate MLIR dialect, GC-free actor runtime, eBPF/WASM backends, AOT-specializing JIT, hardware MTE, and formal verification of the RAII/region escape rules — only after v1.0 ships.
- **Files:** `rfcs/`, `docs/Research.json`
- **Acceptance:** each idea has an RFC with measurements; none lands without an A/B gate.
- **Depends:** AX-120 · **Effort:** XL · **Risk:** high

---

## 6. Effort summary

| Phase | Items | Rough effort | Unlocks |
|---|---|---:|---|
| P0 Truth & hygiene | 12 | 2–3 weeks | trustworthy baseline |
| P1 Dialect system | 16 | 1–2 months | honest compat claim + predictable speed |
| P2 Modules/build/stdlib | 18 | 2–3 months | real multi-file programs |
| P3 Language features | 24 | 4–6 months | arbitrary Python-ish code |
| P4 Compiler architecture | 12 | 2–3 months | maintainability, LSP, incrementality |
| P5 Optimizations | 18 | 2–4 months | measurable speed + safety |
| P6 Tooling | 12 | 2–3 months | developer experience |
| P7 Spec/conformance | 8 | 1–2 months | credibility |
| P8 Distribution | 8 | 1 month | users |

**Total: ~128 work orders.** If only three things get done, do **AX-001, AX-002, AX-013** — leaks, silent integer wrap, and ambiguous dialect are the three things that make the current build untrustworthy as a language.

---

## 7. "If a programmer implements all this, is it a real language?"

**Technically: yes.** The §0 definition-of-done is exactly that bar: someone who did not write the compiler can depend on it. But three caveats matter.

### 7.1 You do not need all 128 items — the v1.0 minimum cut is 50

A language does not become real by feature count. C, Lua and Python 1.0 were real languages with fewer features than Archx has *today*. What is missing is **dependability**, not syntax. The items that actually flip the status are:

| Phase | Minimum-cut IDs | Count |
|---|---|---:|
| P0 trust | AX-001 … AX-012 | 12 |
| P1 dialects | AX-013, 014, 015, 016, 017, 020, 021, 027, 028 | 9 |
| P2 modules | AX-029, 030, 031, 032, 033, 037, 038, 041 | 8 |
| P3 language core | AX-047, 048, 049, 050, 064, 066 | 6 |
| P4 architecture | AX-071, 072, 075 | 3 |
| P5 safety gates | AX-097, 098, 099 | 3 |
| P6 tooling | AX-101, 106 | 2 |
| P7 spec / proof | AX-113, 114, 115, 119, 120 | 5 |
| P8 distribution | AX-121, 126 | 2 |
| **v1.0 cut** | | **50** |

Everything else (~78 items) is v1.1+ polish: PGO/BOLT/Polly, LSP, REPL, formatter, package manager, async, macros, aarch64 cross-builds, website, community governance. Those make it *pleasant and popular*; they do not make it *a language*.

### 7.2 The three "ifs"

1. **Implemented ≠ validated.** Every item has an Acceptance test for a reason. If AX-017 (CPython byte-identity gate), AX-115 (conformance on 3 Python versions), AX-098 (sanitizer matrix) and AX-119 (third-party programs) are skipped, you still have a research compiler with a longer feature list. AX-119 is the single most important item in the whole document: the first program written by someone who did not write the compiler is the moment it stops being a prototype.
2. **Order matters more than completeness.** Adding exceptions, closures and FFI on top of the two leaks and silent overflow (AX-001/002) would produce a language that is *less* trustworthy than today. P0 → P1 → P2 must stay green the entire time; the conformance, sanitizer and 1% perf gates are not optional CI decoration.
3. **"Real" is partly social, not just technical.** A stable spec, a release you can download, semver/backwards-compatibility guarantees, and someone else depending on it are what make a language real. AX-114, AX-116, AX-121 and AX-125 are the items that address that. No checklist can manufacture users — but it can remove every reason they would leave.

### 7.3 The real risk is scope, not difficulty

The hardest single item is not PGO or BOLT; it is **keeping two dialects with different integer, string, truthiness, error and object semantics consistent inside one compiler** (AX-016 + AX-017). If that contract is enforced, implementing the 50-item cut yields a small, fast, memory-safe language with a genuinely useful niche: "Python-shaped source that compiles to C-class binaries, with an explicit escape hatch to native semantics." If it is not enforced, more features just mean more ways to be silently wrong — which is exactly the failure mode the original audit found (`2**100` → `0`, `len('میں')` → `6`, `print(True)` → `true`).

**Freeze the semantics at v1.0.** A small language with a spec, a conformance suite and third-party users is a real language. A large language with 128 implemented features and no stability guarantee is still a playground.

**Rough effort:** the 50-item cut is ~6–9 months for a small full-time team; all 128 items are ~18–24 months with overlapping work, and several of the deferred items (AX-036, AX-047, AX-051, AX-072, AX-095, AX-107) are XL/high-risk research-grade tasks.
