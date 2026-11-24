<!-- Directory overview for `docs/`: user guides, language design fundamentals, optimization proofs, and engineering tracking docs. -->

# `docs/` — Documentation Index

All user-facing guides, architectural specifications, and engineering tracking files for Archx live here.

## User & Language Documentation
- [`USAGE.md`](USAGE.md) — **Start here**: complete guide to everything built so far and how to use every CLI option and language construct.
- [`FUNDAMENTALS.md`](FUNDAMENTALS.md) — Core language philosophy, memory model, binary size, readability, and safety principles.
- [`OPTIMIZATION.md`](OPTIMIZATION.md) — Four-layer optimization strategy and `-O2` LLVM IR proofs (`SoA`, `region:`, `16B SSO`, bounds elision).

## Architecture & Roadmap
- [`Architecture.md`](Architecture.md) — End-to-end compiler pipeline, runtime ABI layouts, and `src/` module map.
- [`Roadmap.md`](Roadmap.md) — Completed Milestones 1–7 and ordered next steps (Milestones 8–10).
- [`Technical.md`](Technical.md) — Tech stack and file-by-file inputs, outputs, and responsibilities.
- [`Logic.md`](Logic.md) — Call-chain and execution flow map across CLI, lexer, parser, and codegen.

## Governance, History & Machine-Readable Indexes
- [`Rules.md`](Rules.md) — Standing engineering, modularity, testing, and CI rules.
- [`Thinking.md`](Thinking.md) — Chronological engineering decision and bug-resolution log.
- [`Changelog.md`](Changelog.md) — Version-by-version release history (`v0.1.0` – `v0.7.0`).
- [`Change.md`](Change.md) — Log of user-requested additions and roadmap updates.
- [`Workaround.md`](Workaround.md) — Documented CI/sandbox and cross-OS linker workarounds.
- [`Secrets.md`](Secrets.md) — Repository secrets registry.
- [`Files_Info.json`](Files_Info.json) — Structured JSON manifest of repository files, inputs, and outputs.
- [`Research.json`](Research.json) — Indexed external research summaries and reference URLs.
