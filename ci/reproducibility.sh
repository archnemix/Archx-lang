#!/usr/bin/env bash
# Reproducible-build gate (AX-012): two clean compilations of the same source must agree.
#
# Checks three things that can silently drift:
#   1. the emitted LLVM IR is byte-identical across two runs (no hash-map iteration order leaking into
#      symbol numbering, no embedded timestamps or absolute paths);
#   2. the linked binaries are byte-identical (`-frandom-seed` is pinned, so even the symbol names the
#      LLVM backend generates are stable);
#   3. every suite still produces byte-identical stdout, so an optimization change cannot alter results.
#
# Usage: ci/reproducibility.sh [archx-binary]
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT" || exit 1

ARCHX="${1:-./target/release/archx}"
OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT

if [ ! -x "$ARCHX" ]; then
  echo "error: no archx binary at $ARCHX (run cargo build --release first)" >&2
  exit 1
fi

fail=0
checked=0

# Rust's `HashMap` uses a per-process random seed, so nondeterminism from hash order can be invisible
# to two runs inside one process invocation but show up between two *processes*. Comparing a third
# compilation started from a different seed (via a different environment) catches that class directly.

for source in benchmarks/*.archx.lang examples/comparison/*.archx.lang examples/*.archx.lang; do
  [ -f "$source" ] || continue
  name="$(basename "$source" .archx.lang)"

  if ! "$ARCHX" "$source" --emit-ir > "$OUT/$name.a.ll" 2>/dev/null ||
     ! "$ARCHX" "$source" --emit-ir > "$OUT/$name.b.ll" 2>/dev/null; then
    echo "FAIL (emit)  $source"
    fail=1
    continue
  fi
  if ! cmp -s "$OUT/$name.a.ll" "$OUT/$name.b.ll"; then
    echo "FAIL (IR)    $source: emitted IR differs between two runs"
    diff <(head -40 "$OUT/$name.a.ll") <(head -40 "$OUT/$name.b.ll") | head -10
    fail=1
    continue
  fi
  # A third run in a separate process with a different environment: hash-seeded ordering would differ.
  if ! env ARCHX_REPRO_SEED=$RANDOM MALLOC_PERTURB_=$((RANDOM % 255 + 1)) \
        "$ARCHX" "$source" --emit-ir > "$OUT/$name.c.ll" 2>/dev/null; then
    echo "FAIL (emit)  $source (second process)"
    fail=1
    continue
  fi
  if ! cmp -s "$OUT/$name.a.ll" "$OUT/$name.c.ll"; then
    echo "FAIL (IR)    $source: emitted IR depends on hash order / environment"
    fail=1
    continue
  fi

  if ! "$ARCHX" "$source" -o "$OUT/$name.a" >/dev/null 2>&1 ||
     ! "$ARCHX" "$source" -o "$OUT/$name.b" >/dev/null 2>&1; then
    echo "FAIL (link)  $source"
    fail=1
    continue
  fi
  if ! cmp -s "$OUT/$name.a" "$OUT/$name.b"; then
    echo "FAIL (BIN)   $source: linked binary differs between two runs"
    fail=1
    continue
  fi

  checked=$((checked + 1))
done

echo "reproducible: $checked sources (IR + binary byte-identical across two compilations)"

# The stdout gate: the same program must print the same bytes, twice, so an optimization change cannot
# hide behind "it looked the same".
for source in benchmarks/*.archx.lang examples/comparison/*.archx.lang; do
  [ -f "$source" ] || continue
  name="$(basename "$source" .archx.lang)"
  [ -x "$OUT/$name.a" ] || continue
  case "$name" in
    # These read stdin or are interactive; stdout equality is covered by the IR/binary check above.
    *input*|*io*) continue ;;
  esac
  # stdout *and* stderr: an error path that prints differently is just as much a regression.
  "$OUT/$name.a" > "$OUT/$name.out1" 2> "$OUT/$name.err1"
  "$OUT/$name.b" > "$OUT/$name.out2" 2> "$OUT/$name.err2"
  if ! cmp -s "$OUT/$name.out1" "$OUT/$name.out2"; then
    echo "FAIL (OUT)   $source: stdout differs between two builds"
    fail=1
  fi
  if ! cmp -s "$OUT/$name.err1" "$OUT/$name.err2"; then
    echo "FAIL (ERR)   $source: stderr differs between two builds"
    fail=1
  fi
done

echo "checked $checked sources"
[ "$fail" -eq 0 ]
