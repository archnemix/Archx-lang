#!/usr/bin/env bash
# Verifies that the IR Archx emits is well-formed LLVM, not just text that happens to compile (AX-009).
#
# Two failures motivated this gate, both in v0.9.1: a `%` helper referenced a `phi` predecessor it did
# not have, and the `%ArchxAny` binop helper dispatched through an unreachable guard. `clang` reported
# both as opaque "invalid IR" only when a program happened to exercise that path, and only on the
# runner that built it. Here every example, every benchmark and the targeted runtime corpus are fed to
# a real LLVM frontend, so a malformed function is caught by the file that emits it.
#
# Usage: ci/verify_ir.sh [compiler]
#   compiler defaults to ./target/release/archx.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT" || exit 1

ARCHX="${1:-./target/release/archx}"
CC="${CC:-clang}"
OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

if [ ! -x "$ARCHX" ]; then
  echo "error: no archx binary at $ARCHX (run cargo build --release first)" >&2
  exit 1
fi
if ! command -v "$CC" >/dev/null 2>&1; then
  echo "error: no C compiler named $CC on PATH" >&2
  exit 1
fi

# The `.ll` extension is what makes the driver treat the file as LLVM IR (`-x ir` is not a language
# clang accepts), so this is a parse + verify run, not a "does it link" run. The object goes to
# /dev/null: linking is covered by the example and benchmark steps in ci.yml.
fail=0
checked=0
verify() {
  local source="$1"
  local name="$2"
  local ll="$OUT/$name.ll"
  if ! "$ARCHX" "$source" --emit-ir > "$ll" 2> "$OUT/$name.err"; then
    echo "FAIL (emit)  $source"
    sed 's/^/    /' "$OUT/$name.err"
    fail=1
    return
  fi
  if ! "$CC" -Wno-override-module -c -o /dev/null "$ll" 2> "$OUT/$name.verify.err"; then
    echo "FAIL (verify) $source"
    sed 's/^/    /' "$OUT/$name.verify.err" | head -20
    fail=1
    return
  fi
  checked=$((checked + 1))
}

echo "== verifying emitted IR for every example, benchmark and runtime corpus =="
for source in examples/*.archx.lang examples/comparison/*.archx.lang benchmarks/*.archx.lang; do
  [ -f "$source" ] || continue
  verify "$source" "$(basename "$source" .archx.lang)"
done

# The targeted corpus (one program per runtime subsystem) is defined in `src/codegen/tests.rs` and
# written here by the unit test `every_runtime_feature_lowers_to_ir`, so there is exactly one copy of
# it and both the test and this gate run over the same sources.
for ll in ci/out/runtime-corpus/*.ll; do
  [ -f "$ll" ] || continue
  if ! "$CC" -Wno-override-module -c -o /dev/null "$ll" 2> "$OUT/$(basename "$ll").err"; then
    echo "FAIL (verify) $ll"
    sed 's/^/    /' "$OUT/$(basename "$ll").err" | head -20
    fail=1
    continue
  fi
  checked=$((checked + 1))
done

echo "verified $checked modules, $fail failures"
[ "$fail" -eq 0 ]
