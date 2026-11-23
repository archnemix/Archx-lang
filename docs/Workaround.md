<!-- Documented workarounds for sandbox environment restrictions and GitHub Actions log/output retrieval. -->

# Sandbox & CI Workarounds

## 1. GitHub Actions Repo-Committed Logs & Outputs Workaround

- **Constraint**: Coding agent sandboxes have restricted outbound network access (`github.com`, `api.github.com`, `crates/pypi/npm`) and cannot stream Azure Blob logs (`gh run view --log-failed` fails with `EOF` against `results-receiver.actions.githubusercontent.com`) or lack local `clang` / `cargo` installations.
- **Workaround (`.github/workflows/ci.yml`)**:
  1. CI runs `build-and-test` (`ubuntu-latest`) and `cross-platform-test` (`macos-latest`, `windows-latest` — **3 total concurrent runners**, within the `<= 5` runner budget).
  2. A final `save-ci-records` job (`if: always()`) collects outputs from all 3 OS runners and commits them directly back into the branch under:
     - `ci/logs/` — latest build, test, toolchain, example, ASan+LSan, and benchmark logs.
     - `ci/out/` — generated `.ll`, `-O2` `.opt.ll` IR dumps, example outputs, and `benchmarks.txt`.
     - `ci/test-history/v<VERSION>/` — `linux-test.log`, `macos-test.log`, and `windows-test.log` (automatically pruned to retain at most the **3 latest versions**: previous 2 + current).
  3. After watching a run (`gh run watch <RUN_ID>`), run `git pull --rebase origin <branch>` and inspect `ci/logs/*`, `ci/out/*`, and `ci/test-history/*` directly with `read_file`.
  4. Touching `ci/trigger` forces a CI run even when no source paths changed.

## 2. Windows MSVC Raw LLVM IR `@printf` Linking

- **Constraint**: On Windows (`x86_64-pc-windows-msvc`), Microsoft's UCRT defines `printf` as an inline C header wrapper around `__stdio_common_vfprintf`, so passing raw `.ll` calling `@printf` directly to `clang` fails with `unresolved external symbol printf` unless `legacy_stdio_definitions.lib` is linked.
- **Workaround (`src/main.rs`)**: When `cfg!(windows)` and `clang --version` reports a `windows-msvc` target, `archx` automatically appends `-llegacy_stdio_definitions` to the `clang` invocation and checks `C:\Program Files\LLVM\bin\clang.exe` if `clang` is not yet on `PATH`.
