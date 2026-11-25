<!-- Directory overview for `tests/`: end-to-end integration test suites exercising the compiled `archx` binary. -->

# `tests/` — Integration Tests

End-to-end integration tests invoked by `cargo test` across Linux, macOS, and Windows:

- `cli.rs` — Compiles and executes Archx programs via `CARGO_BIN_EXE_archx`, verifying Milestones 1–8 (`--emit-ir`, `--run`, functions, conditionals, loops, arrays, SoA structs, `region:` arenas, 16B prefix-SSO strings, 1:1 Pythonic classes/methods/I/O, Planar SIMD `dict`/`set` & slicing, Smart Two-Tier `%ArchxAny` adaptive typing, tuples, `T | None` optionals, algebraic `enum`s, `match`/`case`, byte-identical `full_tour.py` == `full_tour_pythonic.archx.lang` vs `full_tour_speed.archx.lang`, extension/clobber CLI guards, and exit-`101` runtime safety panics).
