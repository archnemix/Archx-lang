<!-- Standing engineering, repository-structure, testing, and CI rules for every agent and contributor working on Archx. -->

# Project Engineering Rules

Every engineer and AI agent working on Archx must read `docs/Rules.md` before planning or modifying code and follow every rule below.

---

## 1. Repository Structure & File Hygiene

1. **Senior Rust engineering standard**: Write idiomatic, modular, warning-free Rust with zero unnecessary external dependencies and zero comment bloat ("AI slop"). Comment *why* non-obvious invariants hold, not *what* obvious lines do.
2. **Single-responsibility files of manageable size**:
   - Every file must contain *only* the code belonging to its single clear responsibility.
   - No monolithic multi-thousand-line files: split subsystems cleanly into focused submodules (~150–1,100 lines each) so adding or modifying a feature touches only its owning module.
3. **Top-of-file purpose comment**:
   - Every source, script, config, and doc file must start with a concise 1–3 line comment stating its exact purpose.
4. **Clean, separated folders with per-folder `README.md`**:
   - Every directory must hold only files belonging to that directory's responsibility — no stray scratch artifacts.
   - Every directory must contain a concise `README.md` describing what lives inside it.

---

## 2. Required Project & Engineering Documents (`docs/` & `internals/`)

Keep these documents synchronized with the codebase after each milestone or structural change:

| File | Responsibility |
|---|---|
| `docs/Rules.md` | This standing ruleset; read before every change. |
| `docs/USAGE.md` | User-facing guide to everything built so far and how to use it. |
| `docs/Roadmap.md` | Ordered implementation roadmap; each step must be 100% complete and tested before starting the next. |
| `docs/Architecture.md` | Overall product plan, compiler pipeline, data layouts, and design boundaries. |
| `docs/Thinking.md` | Engineering decision & problem-solving log (why choices were made, bugs encountered, root causes, and exact fixes). Updated after every round of work. |
| `docs/Changelog.md` | Concise version-by-version record of added/changed/fixed features. |
| `docs/Change.md` | Log of new user requests/ideas and how they update `Roadmap.md`. |
| `docs/Technical.md` | Technical breakdown of stack, modules, inputs, outputs, and invariants. |
| `docs/Logic.md` | End-to-end call-chain and control-flow map so bugs can be traced immediately. |
| `docs/Files_Info.json` | Machine-readable index of every file's path, inputs, outputs, and responsibility for fast lookup without re-reading the entire codebase. |
| `docs/Research.json` | Keyed summary + URLs of external technical research and library/LLVM references. |
| `docs/Workaround.md` | Documented workarounds for sandbox/network/CI constraints. |
| `docs/Secrets.md` | Exact names and descriptions of any required GitHub repository secrets. |
| `internals/skills/*.md` | Non-public engineering playbooks/skills for recurring compiler tasks. |

---

## 3. Sequential Completion & Zero Assumptions

1. **Finish and verify before advancing**: Never start a new feature while an existing feature is partial or has failing tests/leaks.
2. **Verify APIs & versions before coding**: Check current Rust/LLVM behavior before writing code and record external findings in `docs/Research.json`.
3. **Never guess**: If a requirement is genuinely ambiguous, ask; if a performance claim is empirical, benchmark it head-to-head in CI (`benchmarks/run.sh`) and verify the `-O2` LLVM IR (`ci/out/*.opt.ll`).

---

## 4. Testing & Cross-Platform Compatibility

1. **Focused, high-signal tests**:
   - **Unit tests (`src/**/tests.rs` / `#[cfg(test)]`)**: Validate individual module behavior (lexer tokens/indentation, parser AST/errors, codegen IR invariants).
   - **Integration tests (`tests/cli.rs`)**: Validate end-to-end multi-module compilation, execution, diagnostics, and runtime panic safety whenever integrated components change.
2. **Three-OS CI verification**:
   - Run tests across **Linux (`ubuntu-latest`), macOS (`macos-latest`), and Windows (`windows-latest`)**.
   - Keep concurrent GitHub Actions runners **at or below 5** at all times.
3. **Repo-committed CI logs & versioned test history**:
   - Because sandbox environments cannot download external GitHub Actions artifact zips or private log streams directly, CI commits logs (`ci/logs/`), IR/benchmark outputs (`ci/out/`), and versioned per-OS test results (`ci/test-history/v<VERSION>/`) directly into the repository.
   - Retain at most the **last 2 versions plus the current version** inside `ci/test-history/` so the repo stays lean.
