<!-- Directory overview for `ci/`: repo-persisted CI logs, LLVM IR outputs, benchmarks, and versioned multi-OS test records. -->

# `ci/` — Persisted CI Outputs & Test History

Auto-updated by `.github/workflows/ci.yml` so build logs, optimized LLVM IR, ASan/LSan verification, C/Rust/Archx benchmarks, and multi-OS test results can be inspected directly in Git:

- `logs/` — Latest Linux toolchain, build, unit/CLI test, example, ASan+LSan, and benchmark logs.
- `out/` — Latest generated `.ll`, `-O2` `.opt.ll` IR dumps, example outputs, and `benchmarks.txt`.
- `test-history/` — Per-version test logs across Linux, macOS, and Windows (pruned automatically to retain at most the latest 3 versions).
- `trigger` — Touch this file to trigger a CI run without code changes.
