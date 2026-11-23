<!-- Directory overview for `tests/`: end-to-end integration test suites exercising the compiled `archx` binary. -->

# `tests/` — Integration Tests

End-to-end integration tests invoked by `cargo test` across Linux, macOS, and Windows:

- `cli.rs` — Compiles and executes Archx programs via `CARGO_BIN_EXE_archx`, verifying Milestones 1–5 (`--emit-ir`, `--run`, functions, conditionals, loops, arrays, SoA structs, `region:` arenas, 16B prefix-SSO strings, extension/clobber CLI guards, and exit-`101` runtime safety panics).
