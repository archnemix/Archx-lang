#!/usr/bin/env bash
# Builds and times all five benchmark suites (primes, arrays, composite, nbody_float, dict_bench)
# across C, Rust, and Archx (both Static/Specialized Tier-1 and Dynamic %ArchxAny Tier-2):
#
#   1. Scalar loops (benchmarks/primes.*): arithmetic reduction + trial-division primes
#   2. Array loops & bounds checking (benchmarks/arrays*)
#   3. Structs (SoA vs AoS), Regions & Prefix-SSO Strings (benchmarks/composite.*)
#   4. Floating-Point N-Body & OOP Methods in 1:1 Pythonic Syntax (benchmarks/nbody_float.*)
#   5. Planar SIMD Dict vs C AoS vs Rust HashMap + Adaptive Static vs Dynamic (benchmarks/dict_*)
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

echo "== building composite Milestone 5 benchmark (composite) =="
clang -O2 -o "$TMP/comp_c" benchmarks/composite.c || exit 1
rustc -O -o "$TMP/comp_rs" benchmarks/composite.rs || exit 1
./target/release/archx benchmarks/composite.archx.lang -o "$TMP/comp_ax" || exit 1

echo "== building Pythonic floating-point N-body benchmark (nbody_float) =="
clang -O2 -o "$TMP/nbody_c" benchmarks/nbody_float.c -lm || exit 1
rustc -O -o "$TMP/nbody_rs" benchmarks/nbody_float.rs || exit 1
./target/release/archx benchmarks/nbody_float.archx.lang -o "$TMP/nbody_ax" || exit 1

echo "== building Planar SIMD dict + Adaptive Static vs Dynamic benchmark (dict_bench) =="
clang -O2 -o "$TMP/dict_c" benchmarks/dict_bench.c || exit 1
rustc -O -o "$TMP/dict_rs" benchmarks/dict_bench.rs || exit 1
./target/release/archx benchmarks/dict_bench.archx.lang -o "$TMP/dict_ax" || exit 1
./target/release/archx benchmarks/dict_dynamic.archx.lang -o "$TMP/dict_ax_dyn" || exit 1

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

echo
echo "== verifying composite outputs match =="
"$TMP/comp_c"  > "$TMP/out_cc" || exit 1
"$TMP/comp_rs" > "$TMP/out_cr" || exit 1
"$TMP/comp_ax" > "$TMP/out_ca" || exit 1
cat "$TMP/out_cc"
if ! cmp -s "$TMP/out_cc" "$TMP/out_cr" || ! cmp -s "$TMP/out_cc" "$TMP/out_ca"; then
  echo "MISMATCH in composite benchmark"
  echo "--- c ---";     cat "$TMP/out_cc"
  echo "--- rust ---";  cat "$TMP/out_cr"
  echo "--- archx ---"; cat "$TMP/out_ca"
  exit 1
fi

echo
echo "== verifying nbody_float outputs match =="
"$TMP/nbody_c"  > "$TMP/out_nc" || exit 1
"$TMP/nbody_rs" > "$TMP/out_nr" || exit 1
"$TMP/nbody_ax" > "$TMP/out_na" || exit 1
cat "$TMP/out_nc"
if ! cmp -s "$TMP/out_nc" "$TMP/out_nr" || ! cmp -s "$TMP/out_nc" "$TMP/out_na"; then
  echo "MISMATCH in nbody_float benchmark"
  echo "--- c ---";     cat "$TMP/out_nc"
  echo "--- rust ---";  cat "$TMP/out_nr"
  echo "--- archx ---"; cat "$TMP/out_na"
  exit 1
fi

echo
echo "== verifying dict_bench outputs match (C, Rust, Archx Static, Archx Dynamic) =="
"$TMP/dict_c"      > "$TMP/out_dc"  || exit 1
"$TMP/dict_rs"     > "$TMP/out_dr"  || exit 1
"$TMP/dict_ax"     > "$TMP/out_da"  || exit 1
"$TMP/dict_ax_dyn" > "$TMP/out_dad" || exit 1
cat "$TMP/out_dc"
if ! cmp -s "$TMP/out_dc" "$TMP/out_dr" \
   || ! cmp -s "$TMP/out_dc" "$TMP/out_da" \
   || ! cmp -s "$TMP/out_dc" "$TMP/out_dad"; then
  echo "MISMATCH in dict_bench benchmark"
  echo "--- c ---";             cat "$TMP/out_dc"
  echo "--- rust ---";          cat "$TMP/out_dr"
  echo "--- archx static ---";  cat "$TMP/out_da"
  echo "--- archx dynamic ---"; cat "$TMP/out_dad"
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

echo "== timing composite benchmark: best of $RUNS runs (ms) =="
read -r CC_BEST  CC_MEAN  <<<"$(time_ms "$TMP/comp_c")"
read -r CR_BEST  CR_MEAN  <<<"$(time_ms "$TMP/comp_rs")"
read -r CA_BEST  CA_MEAN  <<<"$(time_ms "$TMP/comp_ax")"

echo "== timing nbody_float benchmark: best of $RUNS runs (ms) =="
read -r NC_BEST  NC_MEAN  <<<"$(time_ms "$TMP/nbody_c")"
read -r NR_BEST  NR_MEAN  <<<"$(time_ms "$TMP/nbody_rs")"
read -r NA_BEST  NA_MEAN  <<<"$(time_ms "$TMP/nbody_ax")"

echo "== timing dict_bench benchmark: best of $RUNS runs (ms) =="
read -r DC_BEST  DC_MEAN  <<<"$(time_ms "$TMP/dict_c")"
read -r DR_BEST  DR_MEAN  <<<"$(time_ms "$TMP/dict_rs")"
read -r DA_BEST  DA_MEAN  <<<"$(time_ms "$TMP/dict_ax")"
read -r DAD_BEST DAD_MEAN <<<"$(time_ms "$TMP/dict_ax_dyn")"

read -r PC_KB  PC_SKB  <<<"$(measure_sizes "$TMP/primes_c")"
read -r PR_KB  PR_SKB  <<<"$(measure_sizes "$TMP/primes_rs")"
read -r PA_KB  PA_SKB  <<<"$(measure_sizes "$TMP/primes_ax")"

read -r ACR_KB ACR_SKB <<<"$(measure_sizes "$TMP/arrays_c_raw")"
read -r ACC_KB ACC_SKB <<<"$(measure_sizes "$TMP/arrays_c_chk")"
read -r AR_KB  AR_SKB  <<<"$(measure_sizes "$TMP/arrays_rs")"
read -r AA_KB  AA_SKB  <<<"$(measure_sizes "$TMP/arrays_ax")"

read -r CC_KB  CC_SKB  <<<"$(measure_sizes "$TMP/comp_c")"
read -r CR_KB  CR_SKB  <<<"$(measure_sizes "$TMP/comp_rs")"
read -r CA_KB  CA_SKB  <<<"$(measure_sizes "$TMP/comp_ax")"

read -r NC_KB  NC_SKB  <<<"$(measure_sizes "$TMP/nbody_c")"
read -r NR_KB  NR_SKB  <<<"$(measure_sizes "$TMP/nbody_rs")"
read -r NA_KB  NA_SKB  <<<"$(measure_sizes "$TMP/nbody_ax")"

read -r DC_KB  DC_SKB  <<<"$(measure_sizes "$TMP/dict_c")"
read -r DR_KB  DR_SKB  <<<"$(measure_sizes "$TMP/dict_rs")"
read -r DA_KB  DA_SKB  <<<"$(measure_sizes "$TMP/dict_ax")"
read -r DAD_KB DAD_SKB <<<"$(measure_sizes "$TMP/dict_ax_dyn")"

REPORT=$(cat <<EOF
Archx vs C vs Rust -- head-to-head benchmarks (v0.7.0)
======================================================

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

3. Structs (SoA vs AoS), Regions & Prefix-SSO Strings (benchmarks/composite.*)
------------------------------------------------------------------------------
  - 100,000 6-field Body structs (48B) x 120 timesteps (full + step-8 update)
  - 40,000 rounds of variable-length scratch buffer + short/long string concat/eq
  Output: $(paste -sd ', ' "$TMP/out_cc")

  Language                       Best ms (mean)   Raw KB   Stripped KB
  C      (AoS + malloc/strcmp -O2)   ${CC_BEST} (${CC_MEAN})        ${CC_KB}          ${CC_SKB}
  Rust   (Vec<Body> + String -O)     ${CR_BEST} (${CR_MEAN})      ${CR_KB}         ${CR_SKB}
  Archx  (SoA + region + SSO -O2)    ${CA_BEST} (${CA_MEAN})        ${CA_KB}          ${CA_SKB}

4. Floating-Point N-Body & OOP Methods in 1:1 Pythonic Syntax (benchmarks/nbody_float.*)
----------------------------------------------------------------------------------------
  - 100,000 7-field f64 Body objects (56B) x 60 central-field integration steps + .kinetic()
  - 64-body all-pairs gravitational N-body x 2,000 steps (sqrt + f64 reductions)
  Output: $(paste -sd ', ' "$TMP/out_nc")

  Language                       Best ms (mean)   Raw KB   Stripped KB
  C      (AoS Body* -O2 -lm)         ${NC_BEST} (${NC_MEAN})        ${NC_KB}          ${NC_SKB}
  Rust   (Vec<Body> -O)              ${NR_BEST} (${NR_MEAN})      ${NR_KB}         ${NR_SKB}
  Archx  (Pythonic class + SoA -O2)  ${NA_BEST} (${NA_MEAN})        ${NA_KB}          ${NA_SKB}

5. Planar SIMD Dict & Smart Adaptive Typing (benchmarks/dict_bench.* & dict_dynamic.*)
--------------------------------------------------------------------------------------
  - 120 rounds x 1,024-key str->i64 frequency counts (8,192 updates + 2,048 lookups + items)
  - 32,768-key i64->i64 SwissTable + 8,192 .pop() tombstones + 8,192 inserts + 40 .items() scans
  Output: $(paste -sd ', ' "$TMP/out_dc")

  Language                                 Best ms (mean)   Raw KB   Stripped KB
  C             (AoS open-addressing -O2)      ${DC_BEST} (${DC_MEAN})        ${DC_KB}          ${DC_SKB}
  Rust          (std::HashMap -O)              ${DR_BEST} (${DR_MEAN})      ${DR_KB}         ${DR_SKB}
  Archx Static  (Planar SIMD + region -O2)     ${DA_BEST} (${DA_MEAN})        ${DA_KB}          ${DA_SKB}
  Archx Dynamic (%ArchxAny dict[any,any] -O2)  ${DAD_BEST} (${DAD_MEAN})        ${DAD_KB}          ${DAD_SKB}
EOF
)

echo
echo "$REPORT"
mkdir -p "$(dirname "$OUT")"
echo "$REPORT" > "$OUT"
echo
echo "written to ${OUT#$ROOT/}"
