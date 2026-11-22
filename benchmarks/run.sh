#!/usr/bin/env bash
# Builds and times the same workload in C, Rust and Archx.
#
#   bash benchmarks/run.sh [runs]
#
# Results go to stdout and to ci/out/benchmarks.txt. Times are the *best* of
# N runs (the most stable estimator on a noisy shared machine), with the mean
# alongside so you can see how much the machine jittered.
#
# All three are built with -O2 so the comparison is about the language
# front-end, not about someone getting a fancier optimisation level.

set -u

RUNS="${1:-5}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/ci/out/benchmarks.txt"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cd "$ROOT" || exit 1

# ---------------------------------------------------------------- build ------
echo "== building =="
clang -O2 -o "$TMP/c" benchmarks/primes.c || exit 1
rustc -O2 -o "$TMP/rust" benchmarks/primes.rs || exit 1
cargo build --release >/dev/null 2>&1 || { echo "archx build failed"; exit 1; }
./target/release/archx benchmarks/primes.archx.lang -o "$TMP/archx" || exit 1

# ------------------------------------------------------------- correctness ---
echo
echo "== results (must match) =="
"$TMP/c" > "$TMP/out_c" || exit 1
"$TMP/rust" > "$TMP/out_rust" || exit 1
"$TMP/archx" > "$TMP/out_archx" || exit 1
cat "$TMP/out_c"
if ! cmp -s "$TMP/out_c" "$TMP/out_rust" || ! cmp -s "$TMP/out_c" "$TMP/out_archx"; then
  echo "MISMATCH between implementations"
  echo "--- c ---";      cat "$TMP/out_c"
  echo "--- rust ---";   cat "$TMP/out_rust"
  echo "--- archx ---";  cat "$TMP/out_archx"
  exit 1
fi
echo "all three agree"

# ---------------------------------------------------------------- timing -----
# best and mean, in milliseconds
time_ms() {
  local bin="$1" i start end ms
  local best=999999999 sum=0
  for ((i = 0; i < RUNS; i++)); do
    start=$(date +%s%N)
    "$bin" > /dev/null
    end=$(date +%s%N)
    ms=$(((end - start) / 1000000))
    ((ms < best)) && best=$ms
    sum=$((sum + ms))
  done
  echo "$best $((sum / RUNS))"
}

echo
echo "== timing: best of $RUNS runs (ms) =="
read -r C_BEST C_MEAN <<<"$(time_ms "$TMP/c")"
read -r R_BEST R_MEAN <<<"$(time_ms "$TMP/rust")"
read -r A_BEST A_MEAN <<<"$(time_ms "$TMP/archx")"

size_kb() { stat -c %s "$1" | awk '{printf "%.0f", $1/1024}'; }
strip -o "$TMP/c.stripped" "$TMP/c" 2>/dev/null || cp "$TMP/c" "$TMP/c.stripped"
strip -o "$TMP/rust.stripped" "$TMP/rust" 2>/dev/null || cp "$TMP/rust" "$TMP/rust.stripped"
strip -o "$TMP/archx.stripped" "$TMP/archx" 2>/dev/null || cp "$TMP/archx" "$TMP/archx.stripped"

C_KB=$(size_kb "$TMP/c"); R_KB=$(size_kb "$TMP/rust"); A_KB=$(size_kb "$TMP/archx")
C_SKB=$(size_kb "$TMP/c.stripped"); R_SKB=$(size_kb "$TMP/rust.stripped"); A_SKB=$(size_kb "$TMP/archx.stripped")

# ---------------------------------------------------------------- report ------
REPORT=$(cat <<EOF
Archx vs C vs Rust -- loop benchmark
====================================

Workload (benchmarks/primes.*):
  1. sum of squares 0..20,000,000, mod 1,000,007   (tight arithmetic loop)
  2. count primes below 400,000 by trial division   (nested loop, branch, break)

Toolchain
---------
$(clang --version | head -1)
$(rustc --version)
archx (this repo, cargo build --release)
optimisation: -O2 for all three

Output (identical in all three)
-------------------------------
$(sed 's/^/  /' "$TMP/out_c")

Time in milliseconds (best of $RUNS runs, mean in parentheses)
--------------------------------------------------------------
  C      (clang -O2)   ${C_BEST}  (${C_MEAN})
  Rust   (rustc -O2)   ${R_BEST}  (${R_MEAN})
  Archx  (archx -O2)   ${A_BEST}  (${A_MEAN})

Binary size (KB)
----------------
                 raw   stripped
  C              ${C_KB}      ${C_SKB}
  Rust           ${R_KB}      ${R_SKB}
  Archx          ${A_KB}      ${A_SKB}
EOF
)

echo "$REPORT"
mkdir -p "$(dirname "$OUT")"
echo "$REPORT" > "$OUT"
echo
echo "written to ${OUT#$ROOT/}"
