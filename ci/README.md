# CI output

- `logs/` — build and test logs from GitHub Actions.
- `out/` — generated LLVM IR and program output.

The workflow writes here and commits the result back to the branch, so the
output is readable without downloading Actions artifacts.

Touch `ci/trigger` and push to force a run manually.
