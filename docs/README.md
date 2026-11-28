<!-- Directory overview for `docs/`: user guides, language design fundamentals, optimization proofs, and engineering tracking docs. -->

# `docs/` — Documentation Index

All user-facing guides, architectural specifications, and engineering tracking files for Archx live here.

## User & Language Documentation
- [`DIALECTS.md`](DIALECTS.md) — the compat/native divergence matrix, generated from the table the compiler obeys.
- [`ERROR_CODES.md`](ERROR_CODES.md) — every diagnostic code, generated from the compiler (`archx explain`).
- [`LIMITATIONS.md`](LIMITATIONS.md) — the measured list of what is not supported yet, generated from the conformance probes.
- [`USAGE.md`](USAGE.md) — **Start here**: complete guide to everything built so far (`v0.8.0`) and how to use every CLI option and language construct.
- [`FUNDAMENTALS.md`](FUNDAMENTALS.md) — Core language philosophy, memory model, binary size, readability, and safety principles.
- [`OPTIMIZATION.md`](OPTIMIZATION.md) — Optimization strategy, `-O2` LLVM IR proofs (`SoA`, `region:`, `16B SSO`, Planar SIMD `dict`/`set`, zero-heap tuples/`T | None`/`enum`), and 7-suite `Python 3` / `C` / `Rust` / `Archx` CI timings.

## Architecture & Roadmap
- [`Architecture.md`](Architecture.md) — End-to-end compiler pipeline, runtime ABI layouts, and `src/` module map (`v0.8.0`).
- [`Roadmap.md`](Roadmap.md) — Completed Milestones 1–8 and ordered next steps (Milestones 9–10).
- [`Technical.md`](Technical.md) — Tech stack and file-by-file inputs, outputs, and responsibilities (`v0.8.0`).
- [`Logic.md`](Logic.md) — Call-chain and execution flow map across CLI, lexer, parser, and codegen (`v0.8.0`).

## Governance, History & Machine-Readable Indexes
- [`Rules.md`](Rules.md) — Standing engineering, modularity, testing, and CI rules.
- [`Thinking.md`](Thinking.md) — Chronological engineering decision and bug-resolution log.
- [`Changelog.md`](Changelog.md) — Version-by-version release history (`v0.1.0` – `v0.8.0`).
- [`Change.md`](Change.md) — Log of user-requested additions and roadmap updates.
- [`Workaround.md`](Workaround.md) — Documented CI/sandbox and cross-OS linker workarounds.
- [`Secrets.md`](Secrets.md) — Repository secrets registry.
- [`Files_Info.json`](Files_Info.json) — Structured JSON manifest of repository files, inputs, and outputs.
- [`Research.json`](Research.json) — Indexed external research summaries and reference URLs.
