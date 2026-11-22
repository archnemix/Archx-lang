#!/usr/bin/env bash
# Builds and times two benchmark suites across C, Rust, and Archx:
#
#   1. Scalar loops (benchmarks/primes.*): arithmetic reduction + trial-division primes
#   2. Array loops & bounds checking (benchmarks/arrays*):
#        - C (raw ptr)      : unchecked `long *` / `bool *`
#        - C (checked)      : `IntVec`/`BoolVec` slice struct with `0 <= i < len` checks
#        - Rust (Vec<T>)    : safe `Vec<i64>` / `Vec<bool>`
#        - Archx ([T])      : safe `[int]` / `[bool]` with compile-time bounds-check elision
#
# Usage: bash benchmarks/run.sh [runs]

set -u

RUNS="${1:-5}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/ci/out/benchmarks.txt"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cd "$ROOT" || exit 1

echo "== building scalar benchmark (primes) =="
clang -O2 -o "$TMP/primes_c" benchmarks/primes.c || exit 1
rustc -O -o "$TMP/primes_rs" benchmarks/primes.rs || exit 1
cargo build --release >/dev/null 2>&1 || { echo "archx build failed"; exit 1; }
./target/release/archx benchmarks/primes.archx.lang -o "$TMP/primes_ax" || exit 1

echo "== building array benchmark (arrays) =="
clang -O2 -o "$TMP/arrays_c_raw" benchmarks/arrays_raw.c || exit 1
clang -O2 -o "$TMP/arrays_c_chk" benchmarks/arrays_checked.c || exit 1
rustc -O -o "$TMP/arrays_rs" benchmarks/arrays.rs || exit 1
./target/release/archx benchmarks/arrays.archx.lang -o "$TMP/arrays_ax" || exit 1

echo
echo "== verifying scalar outputs match =="
"$TMP/primes_c"  > "$TMP/out_pc" || exit 1
"$TMP/primes_rs" > "$TMP/out_pr" || exit 1
"$TMP/primes_ax" > "$TMP/out_pa" || exit 1
cat "$TMP/out_pc"
if ! cmp -s "$TMP/out_pc" "$TMP/out_pr" || ! cmp -s "$TMP/out_pc" "$TMP/out_pa"; then
  echo "MISMATCH in primes benchmark"
  echo "--- c ---";     cat "$TMP/out_pc"
  echo "--- rust ---";  cat "$TMP/out_pr"
  echo "--- archx ---"; cat "$TMP/out_pa"
  exit 1
fi

echo
echo "== verifying array outputs match =="
"$TMP/arrays_c_raw" > "$TMP/out_acr" || exit 1
"$TMP/arrays_c_chk" > "$TMP/out_acc" || exit 1
"$TMP/arrays_rs"    > "$TMP/out_ar"  || exit 1
"$TMP/arrays_ax"    > "$TMP/out_aa"  || exit 1
cat "$TMP/out_acr"
if ! cmp -s "$TMP/out_acr" "$TMP/out_acc" \
   || ! cmp -s "$TMP/out_acr" "$TMP/out_ar" \
   || ! cmp -s "$TMP/out_acr" "$TMP/out_aa"; then
  echo "MISMATCH in arrays benchmark"
  echo "--- c (raw) ---";     cat "$TMP/out_acr"
  echo "--- c (checked) ---"; cat "$TMP/out_acc"
  echo "--- rust ---";        cat "$TMP/out_ar"
  echo "--- archx ---";       cat "$TMP/out_aa"
  exit 1
fi
echo "all implementations agree"

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

size_kb() { stat -c %s "$1" | awk '{printf "%.0f", $1/1024}'; }

measure_sizes() {
  local bin="$1"
  strip -o "${bin}.stripped" "$bin" 2>/dev/null || cp "$bin" "${bin}.stripped"
  echo "$(size_kb "$bin") $(size_kb "${bin}.stripped")"
}

echo
echo "== timing scalar benchmark: best of $RUNS runs (ms) =="
read -r PC_BEST PC_MEAN <<<"$(time_ms "$TMP/primes_c")"
read -r PR_BEST PR_MEAN <<<"$(time_ms "$TMP/primes_rs")"
read -r PA_BEST PA_MEAN <<<"$(time_ms "$TMP/primes_ax")"

echo "== timing array benchmark: best of $RUNS runs (ms) =="
read -r ACR_BEST ACR_MEAN <<<"$(time_ms "$TMP/arrays_c_raw")"
read -r ACC_BEST ACC_MEAN <<<"$(time_ms "$TMP/arrays_c_chk")"
read -r AR_BEST  AR_MEAN  <<<"$(time_ms "$TMP/arrays_rs")"
read -r AA_BEST  AA_MEAN  <<<"$(time_ms "$TMP/arrays_ax")"

read -r PC_KB  PC_SKB  <<<"$(measure_sizes "$TMP/primes_c")"
read -r PR_KB  PR_SKB  <<<"$(measure_sizes "$TMP/primes_rs")"
read -r PA_KB  PA_SKB  <<<"$(measure_sizes "$TMP/primes_ax")"

read -r ACR_KB ACR_SKB <<<"$(measure_sizes "$TMP/arrays_c_raw")"
read -r ACC_KB ACC_SKB <<<"$(measure_sizes "$TMP/arrays_c_chk")"
read -r AR_KB  AR_SKB  <<<"$(measure_sizes "$TMP/arrays_rs")"
read -r AA_KB  AA_SKB  <<<"$(measure_sizes "$TMP/arrays_ax")"

REPORT=$(cat <<EOF
Archx vs C vs Rust -- loop & array benchmarks
=============================================

Toolchain
---------
$(clang --version | head -1)
$(rustc --version)
archx (this repo, cargo build --release)
optimisation: -O2 for C, rustc -O (= opt-level 2) for Rust, clang -O2 for Archx

1. Scalar loops (benchmarks/primes.*)
-------------------------------------
  - sum of squares 0..20,000,000 mod 1,000,007
  - count primes below 400,000 by trial division
  Output: $(paste -sd ', ' "$TMP/out_pc")

  Language               Best ms (mean)   Raw KB   Stripped KB
  C      (clang -O2)         ${PC_BEST} (${PC_MEAN})        ${PC_KB}          ${PC_SKB}
  Rust   (rustc -O)          ${PR_BEST} (${PR_MEAN})      ${PR_KB}         ${PR_SKB}
  Archx  (archx -O2)         ${PA_BEST} (${PA_MEAN})        ${PA_KB}          ${PA_SKB}

2. Array loops & bounds checking (benchmarks/arrays*)
-----------------------------------------------------
  - 60 rounds of 1,000,000-element vector math: dst[i] = a[i]*3 + b[i] + r
  - Sieve of Eratosthenes below 5,000,000
  Output: $(paste -sd ', ' "$TMP/out_acr")

  Language                       Best ms (mean)   Raw KB   Stripped KB
  C raw ptr   (unchecked -O2)        ${ACR_BEST} (${ACR_MEAN})        ${ACR_KB}          ${ACR_SKB}
  C checked   (slice struct -O2)     ${ACC_BEST} (${ACC_MEAN})        ${ACC_KB}          ${ACC_SKB}
  Rust        (safe Vec -O)          ${AR_BEST} (${AR_MEAN})      ${AR_KB}         ${AR_SKB}
  Archx       (safe [T] -O2)         ${AA_BEST} (${AA_MEAN})        ${AA_KB}          ${AA_SKB}
EOF
)

echo
echo "$REPORT"
mkdir -p "$(dirname "$OUT")"
echo "$REPORT" > "$OUT"
echo
echo "written to ${OUT#$ROOT/}"
