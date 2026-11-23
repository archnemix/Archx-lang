<!-- Directory overview for `ci/test-history/`: versioned Linux, macOS, and Windows test logs (retaining latest 3 versions). -->

# `ci/test-history/` — Versioned Cross-OS Test Results

Stores `linux-test.log`, `macos-test.log`, and `windows-test.log` grouped by compiler version (`v<CARGO_PKG_VERSION>/`), automatically pruned in CI to retain at most the previous 2 versions plus the current version.
