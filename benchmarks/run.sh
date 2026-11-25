#!/usr/bin/env bash
# Builds and times all six benchmark suites across Python 3 (`python3`), Clang C (`-O2`),
# Rust (`rustc -O`), Archx 1:1 Pythonic (`-O2`), and Archx Speed/Systems (`-O2`):
#
#   1. Scalar loops (benchmarks/primes.*)
#   2. Array loops & bounds checking (benchmarks/arrays*)
#   3. Structs (SoA vs AoS), Regions & Prefix-SSO Strings (benchmarks/composite.*)
#   4. Floating-Point N-Body & OOP Methods in 1:1 Pythonic Syntax (benchmarks/nbody_float.*)
#   5. Planar SIMD Dict vs Python dict vs C AoS vs Rust HashMap + Adaptive Static/Dynamic (benchmarks/dict_*)
#   6. 5-Way Full-Feature Tour (examples/comparison/full_tour.*: Python 3 vs Archx 1:1 Pythonic vs Archx Speed vs C vs Rust)
#
# Usage: bash benchmarks/run.sh [native_runs] [python_runs]

set -u

RUNS="${1:-7}"
PY_RUNS="${2:-3}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/ci/out/benchmarks.txt"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cd "$ROOT" || exit 1

if ! command -v python3 >/dev/null 2>&1; then
  echo "error: python3 is required to run head-to-head benchmarks" >&2
  exit 1
fi

echo "== verifying 1:1 source identity of full_tour.py and full_tour_pythonic.archx.lang =="
if ! cmp -s examples/comparison/full_tour.py examples/comparison/full_tour_pythonic.archx.lang; then
  echo "MISMATCH: full_tour.py and full_tour_pythonic.archx.lang must be byte-for-byte identical!"
  exit 1
fi

echo "== building Archx compiler (release) =="
cargo build --release >/dev/null 2>&1 || { echo "archx build failed"; exit 1; }

echo "== building Suite 1: scalar benchmark (primes) =="
clang -O2 -o "$TMP/primes_c" benchmarks/primes.c || exit 1
rustc -O -o "$TMP/primes_rs" benchmarks/primes.rs || exit 1
./target/release/archx benchmarks/primes.archx.lang -o "$TMP/primes_ax" || exit 1

echo "== building Suite 2: array benchmark (arrays) =="
clang -O2 -o "$TMP/arrays_c_raw" benchmarks/arrays_raw.c || exit 1
clang -O2 -o "$TMP/arrays_c_chk" benchmarks/arrays_checked.c || exit 1
rustc -O -o "$TMP/arrays_rs" benchmarks/arrays.rs || exit 1
./target/release/archx benchmarks/arrays.archx.lang -o "$TMP/arrays_ax" || exit 1

echo "== building Suite 3: composite Milestone 5 benchmark (composite) =="
clang -O2 -o "$TMP/comp_c" benchmarks/composite.c || exit 1
rustc -O -o "$TMP/comp_rs" benchmarks/composite.rs || exit 1
./target/release/archx benchmarks/composite.archx.lang -o "$TMP/comp_ax" || exit 1

echo "== building Suite 4: Pythonic floating-point N-body benchmark (nbody_float) =="
clang -O2 -o "$TMP/nbody_c" benchmarks/nbody_float.c -lm || exit 1
rustc -O -o "$TMP/nbody_rs" benchmarks/nbody_float.rs || exit 1
./target/release/archx benchmarks/nbody_float.archx.lang -o "$TMP/nbody_ax" || exit 1

echo "== building Suite 5: Planar SIMD dict + Adaptive Static vs Dynamic (dict_bench) =="
clang -O2 -o "$TMP/dict_c" benchmarks/dict_bench.c || exit 1
rustc -O -o "$TMP/dict_rs" benchmarks/dict_bench.rs || exit 1
./target/release/archx benchmarks/dict_bench.archx.lang -o "$TMP/dict_ax" || exit 1
./target/release/archx benchmarks/dict_dynamic.archx.lang -o "$TMP/dict_ax_dyn" || exit 1

echo "== building Suite 6: 5-Way Full-Feature Tour (examples/comparison/full_tour.*) =="
clang -O2 -o "$TMP/tour_c" examples/comparison/full_tour.c -lm || exit 1
rustc -O -o "$TMP/tour_rs" examples/comparison/full_tour.rs || exit 1
./target/release/archx examples/comparison/full_tour_pythonic.archx.lang -o "$TMP/tour_ax_py" || exit 1
./target/release/archx examples/comparison/full_tour_speed.archx.lang -o "$TMP/tour_ax_spd" || exit 1

echo
echo "== verifying Suite 1 (primes) outputs match (Python 3, C, Rust, Archx) =="
python3 benchmarks/primes.py > "$TMP/out_ppy" || exit 1
"$TMP/primes_c"  > "$TMP/out_pc" || exit 1
"$TMP/primes_rs" > "$TMP/out_pr" || exit 1
"$TMP/primes_ax" > "$TMP/out_pa" || exit 1
cat "$TMP/out_pc"
if ! cmp -s "$TMP/out_pc" "$TMP/out_ppy" \
   || ! cmp -s "$TMP/out_pc" "$TMP/out_pr" \
   || ! cmp -s "$TMP/out_pc" "$TMP/out_pa"; then
  echo "MISMATCH in primes benchmark"
  echo "--- python3 ---"; cat "$TMP/out_ppy"
  echo "--- c ---";       cat "$TMP/out_pc"
  echo "--- rust ---";    cat "$TMP/out_pr"
  echo "--- archx ---";   cat "$TMP/out_pa"
  exit 1
fi

echo
echo "== verifying Suite 2 (arrays) outputs match (Python 3, C raw, C checked, Rust, Archx) =="
python3 benchmarks/arrays.py > "$TMP/out_apy" || exit 1
"$TMP/arrays_c_raw" > "$TMP/out_acr" || exit 1
"$TMP/arrays_c_chk" > "$TMP/out_acc" || exit 1
"$TMP/arrays_rs"    > "$TMP/out_ar"  || exit 1
"$TMP/arrays_ax"    > "$TMP/out_aa"  || exit 1
cat "$TMP/out_acr"
if ! cmp -s "$TMP/out_acr" "$TMP/out_apy" \
   || ! cmp -s "$TMP/out_acr" "$TMP/out_acc" \
   || ! cmp -s "$TMP/out_acr" "$TMP/out_ar" \
   || ! cmp -s "$TMP/out_acr" "$TMP/out_aa"; then
  echo "MISMATCH in arrays benchmark"
  echo "--- python3 ---";     cat "$TMP/out_apy"
  echo "--- c (raw) ---";     cat "$TMP/out_acr"
  echo "--- c (checked) ---"; cat "$TMP/out_acc"
  echo "--- rust ---";        cat "$TMP/out_ar"
  echo "--- archx ---";       cat "$TMP/out_aa"
  exit 1
fi

echo
echo "== verifying Suite 3 (composite) outputs match (Python 3, C, Rust, Archx) =="
python3 benchmarks/composite.py > "$TMP/out_cpy" || exit 1
"$TMP/comp_c"  > "$TMP/out_cc" || exit 1
"$TMP/comp_rs" > "$TMP/out_cr" || exit 1
"$TMP/comp_ax" > "$TMP/out_ca" || exit 1
cat "$TMP/out_cc"
if ! cmp -s "$TMP/out_cc" "$TMP/out_cpy" \
   || ! cmp -s "$TMP/out_cc" "$TMP/out_cr" \
   || ! cmp -s "$TMP/out_cc" "$TMP/out_ca"; then
  echo "MISMATCH in composite benchmark"
  echo "--- python3 ---"; cat "$TMP/out_cpy"
  echo "--- c ---";       cat "$TMP/out_cc"
  echo "--- rust ---";    cat "$TMP/out_cr"
  echo "--- archx ---";   cat "$TMP/out_ca"
  exit 1
fi

echo
echo "== verifying Suite 4 (nbody_float) outputs match (Python 3, C, Rust, Archx) =="
python3 benchmarks/nbody_float.py > "$TMP/out_npy" || exit 1
"$TMP/nbody_c"  > "$TMP/out_nc" || exit 1
"$TMP/nbody_rs" > "$TMP/out_nr" || exit 1
"$TMP/nbody_ax" > "$TMP/out_na" || exit 1
cat "$TMP/out_nc"
if ! cmp -s "$TMP/out_nc" "$TMP/out_npy" \
   || ! cmp -s "$TMP/out_nc" "$TMP/out_nr" \
   || ! cmp -s "$TMP/out_nc" "$TMP/out_na"; then
  echo "MISMATCH in nbody_float benchmark"
  echo "--- python3 ---"; cat "$TMP/out_npy"
  echo "--- c ---";       cat "$TMP/out_nc"
  echo "--- rust ---";    cat "$TMP/out_nr"
  echo "--- archx ---";   cat "$TMP/out_na"
  exit 1
fi

echo
echo "== verifying Suite 5 (dict_bench) outputs match (Python 3, C, Rust, Archx Static, Archx Dynamic) =="
python3 benchmarks/dict_bench.py > "$TMP/out_dpy" || exit 1
"$TMP/dict_c"      > "$TMP/out_dc"  || exit 1
"$TMP/dict_rs"     > "$TMP/out_dr"  || exit 1
"$TMP/dict_ax"     > "$TMP/out_da"  || exit 1
"$TMP/dict_ax_dyn" > "$TMP/out_dad" || exit 1
cat "$TMP/out_dc"
if ! cmp -s "$TMP/out_dc" "$TMP/out_dpy" \
   || ! cmp -s "$TMP/out_dc" "$TMP/out_dr" \
   || ! cmp -s "$TMP/out_dc" "$TMP/out_da" \
   || ! cmp -s "$TMP/out_dc" "$TMP/out_dad"; then
  echo "MISMATCH in dict_bench benchmark"
  echo "--- python3 ---";       cat "$TMP/out_dpy"
  echo "--- c ---";             cat "$TMP/out_dc"
  echo "--- rust ---";          cat "$TMP/out_dr"
  echo "--- archx static ---";  cat "$TMP/out_da"
  echo "--- archx dynamic ---"; cat "$TMP/out_dad"
  exit 1
fi

echo
echo "== verifying Suite 6 (full_tour 5-way showcase) outputs match =="
python3 examples/comparison/full_tour.py > "$TMP/out_tpy" || exit 1
"$TMP/tour_ax_py"  > "$TMP/out_tap" || exit 1
"$TMP/tour_ax_spd" > "$TMP/out_tas" || exit 1
"$TMP/tour_c"      > "$TMP/out_tc"  || exit 1
"$TMP/tour_rs"     > "$TMP/out_tr"  || exit 1
cat "$TMP/out_tc"
if ! cmp -s "$TMP/out_tc" "$TMP/out_tpy" \
   || ! cmp -s "$TMP/out_tc" "$TMP/out_tap" \
   || ! cmp -s "$TMP/out_tc" "$TMP/out_tas" \
   || ! cmp -s "$TMP/out_tc" "$TMP/out_tr"; then
  echo "MISMATCH in Suite 6 (full_tour 5-way comparison)"
  echo "--- python3 ---";          cat "$TMP/out_tpy"
  echo "--- archx (pythonic) ---"; cat "$TMP/out_tap"
  echo "--- archx (speed) ---";    cat "$TMP/out_tas"
  echo "--- c ---";                cat "$TMP/out_tc"
  echo "--- rust ---";             cat "$TMP/out_tr"
  exit 1
fi
echo "all implementations across all 6 suites agree!"

time_ms() {
  local bin="$1" count="${2:-$RUNS}" i start end ms
  local best=999999999 sum=0
  for ((i = 0; i < count; i++)); do
    start=$(date +%s%N)
    "$bin" > /dev/null
    end=$(date +%s%N)
    ms=$(((end - start) / 1000000))
    ((ms < best)) && best=$ms
    sum=$((sum + ms))
  done
  echo "$best $((sum / count))"
}

time_py_ms() {
  local script="$1" count="${2:-$PY_RUNS}" i start end ms
  local best=999999999 sum=0
  for ((i = 0; i < count; i++)); do
    start=$(date +%s%N)
    python3 "$script" > /dev/null
    end=$(date +%s%N)
    ms=$(((end - start) / 1000000))
    ((ms < best)) && best=$ms
    sum=$((sum + ms))
  done
  echo "$best $((sum / count))"
}

speedup_str() {
  local py_ms="$1" nat_ms="$2"
  awk -v p="$py_ms" -v n="$nat_ms" 'BEGIN { if (n <= 0) n = 1; printf "%.1fx", p / n }'
}

size_kb() { stat -c %s "$1" | awk '{printf "%.0f", $1/1024}'; }

measure_sizes() {
  local bin="$1"
  strip -o "${bin}.stripped" "$bin" 2>/dev/null || cp "$bin" "${bin}.stripped"
  echo "$(size_kb "$bin") $(size_kb "${bin}.stripped")"
}

echo
echo "== timing Suite 1 (primes): Python best of $PY_RUNS, native best of $RUNS (ms) =="
read -r PPY_BEST PPY_MEAN <<<"$(time_py_ms benchmarks/primes.py)"
read -r PC_BEST  PC_MEAN  <<<"$(time_ms "$TMP/primes_c")"
read -r PR_BEST  PR_MEAN  <<<"$(time_ms "$TMP/primes_rs")"
read -r PA_BEST  PA_MEAN  <<<"$(time_ms "$TMP/primes_ax")"

echo "== timing Suite 2 (arrays): Python best of $PY_RUNS, native best of $RUNS (ms) =="
read -r APY_BEST APY_MEAN <<<"$(time_py_ms benchmarks/arrays.py)"
read -r ACR_BEST ACR_MEAN <<<"$(time_ms "$TMP/arrays_c_raw")"
read -r ACC_BEST ACC_MEAN <<<"$(time_ms "$TMP/arrays_c_chk")"
read -r AR_BEST  AR_MEAN  <<<"$(time_ms "$TMP/arrays_rs")"
read -r AA_BEST  AA_MEAN  <<<"$(time_ms "$TMP/arrays_ax")"

echo "== timing Suite 3 (composite): Python best of $PY_RUNS, native best of $RUNS (ms) =="
read -r CPY_BEST CPY_MEAN <<<"$(time_py_ms benchmarks/composite.py)"
read -r CC_BEST  CC_MEAN  <<<"$(time_ms "$TMP/comp_c")"
read -r CR_BEST  CR_MEAN  <<<"$(time_ms "$TMP/comp_rs")"
read -r CA_BEST  CA_MEAN  <<<"$(time_ms "$TMP/comp_ax")"

echo "== timing Suite 4 (nbody_float): Python best of $PY_RUNS, native best of $RUNS (ms) =="
read -r NPY_BEST NPY_MEAN <<<"$(time_py_ms benchmarks/nbody_float.py)"
read -r NC_BEST  NC_MEAN  <<<"$(time_ms "$TMP/nbody_c")"
read -r NR_BEST  NR_MEAN  <<<"$(time_ms "$TMP/nbody_rs")"
read -r NA_BEST  NA_MEAN  <<<"$(time_ms "$TMP/nbody_ax")"

echo "== timing Suite 5 (dict_bench): Python best of $PY_RUNS, native best of $RUNS (ms) =="
read -r DPY_BEST DPY_MEAN <<<"$(time_py_ms benchmarks/dict_bench.py)"
read -r DC_BEST  DC_MEAN  <<<"$(time_ms "$TMP/dict_c")"
read -r DR_BEST  DR_MEAN  <<<"$(time_ms "$TMP/dict_rs")"
read -r DA_BEST  DA_MEAN  <<<"$(time_ms "$TMP/dict_ax")"
read -r DAD_BEST DAD_MEAN <<<"$(time_ms "$TMP/dict_ax_dyn")"

echo "== timing Suite 6 (5-Way Full-Feature Tour): Python best of $PY_RUNS, native best of $RUNS (ms) =="
read -r TPY_BEST TPY_MEAN <<<"$(time_py_ms examples/comparison/full_tour.py)"
read -r TAP_BEST TAP_MEAN <<<"$(time_ms "$TMP/tour_ax_py")"
read -r TAS_BEST TAS_MEAN <<<"$(time_ms "$TMP/tour_ax_spd")"
read -r TC_BEST  TC_MEAN  <<<"$(time_ms "$TMP/tour_c")"
read -r TR_BEST  TR_MEAN  <<<"$(time_ms "$TMP/tour_rs")"

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

read -r TAP_KB TAP_SKB <<<"$(measure_sizes "$TMP/tour_ax_py")"
read -r TAS_KB TAS_SKB <<<"$(measure_sizes "$TMP/tour_ax_spd")"
read -r TC_KB  TC_SKB  <<<"$(measure_sizes "$TMP/tour_c")"
read -r TR_KB  TR_SKB  <<<"$(measure_sizes "$TMP/tour_rs")"

REPORT=$(cat <<EOF
Archx vs Python 3 vs C vs Rust -- head-to-head benchmarks (v0.8.0)
==================================================================

Toolchain
---------
$(python3 --version)
$(clang --version | head -1)
$(rustc --version)
archx v0.8.0 (this repo, cargo build --release)
optimisation: python3 (CPython), clang -O2 for C, rustc -O (= opt-level 2) for Rust, clang -O2 for Archx

1. Scalar loops (benchmarks/primes.*)
-------------------------------------
  - sum of squares 0..20,000,000 mod 1,000,007 + trial-division primes below 400,000
  Output: $(paste -sd ', ' "$TMP/out_pc")

  Language                     Best ms (mean)   vs Python 3   Raw KB   Stripped KB
  Python 3  (python3)              ${PPY_BEST} (${PPY_MEAN})        1.0x          n/a         n/a
  C         (clang -O2)            ${PC_BEST} (${PC_MEAN})        $(speedup_str "$PPY_BEST" "$PC_BEST")          ${PC_KB}          ${PC_SKB}
  Rust      (rustc -O)             ${PR_BEST} (${PR_MEAN})        $(speedup_str "$PPY_BEST" "$PR_BEST")        ${PR_KB}         ${PR_SKB}
  Archx     (archx -O2)            ${PA_BEST} (${PA_MEAN})        $(speedup_str "$PPY_BEST" "$PA_BEST")          ${PA_KB}          ${PA_SKB}

2. Array loops & bounds checking (benchmarks/arrays*)
-----------------------------------------------------
  - 60 rounds of 1,000,000-element vector math + Sieve of Eratosthenes below 5,000,000
  Output: $(paste -sd ', ' "$TMP/out_acr")

  Language                       Best ms (mean)   vs Python 3   Raw KB   Stripped KB
  Python 3    (python3)              ${APY_BEST} (${APY_MEAN})        1.0x          n/a         n/a
  C raw ptr   (unchecked -O2)        ${ACR_BEST} (${ACR_MEAN})        $(speedup_str "$APY_BEST" "$ACR_BEST")          ${ACR_KB}          ${ACR_SKB}
  C checked   (slice struct -O2)     ${ACC_BEST} (${ACC_MEAN})        $(speedup_str "$APY_BEST" "$ACC_BEST")          ${ACC_KB}          ${ACC_SKB}
  Rust        (safe Vec -O)          ${AR_BEST} (${AR_MEAN})        $(speedup_str "$APY_BEST" "$AR_BEST")        ${AR_KB}         ${AR_SKB}
  Archx       (safe [T] -O2)         ${AA_BEST} (${AA_MEAN})        $(speedup_str "$APY_BEST" "$AA_BEST")          ${AA_KB}          ${AA_SKB}

3. Structs (SoA vs AoS), Regions & Prefix-SSO Strings (benchmarks/composite.*)
------------------------------------------------------------------------------
  - 100,000 6-field Body structs x 120 timesteps + 40,000 rounds of arena/string ops
  Output: $(paste -sd ', ' "$TMP/out_cc")

  Language                       Best ms (mean)   vs Python 3   Raw KB   Stripped KB
  Python 3  (python3)              ${CPY_BEST} (${CPY_MEAN})        1.0x          n/a         n/a
  C         (AoS + malloc -O2)     ${CC_BEST} (${CC_MEAN})        $(speedup_str "$CPY_BEST" "$CC_BEST")          ${CC_KB}          ${CC_SKB}
  Rust      (Vec<Body> + String)   ${CR_BEST} (${CR_MEAN})        $(speedup_str "$CPY_BEST" "$CR_BEST")        ${CR_KB}         ${CR_SKB}
  Archx     (SoA + region + SSO)   ${CA_BEST} (${CA_MEAN})        $(speedup_str "$CPY_BEST" "$CA_BEST")          ${CA_KB}          ${CA_SKB}

4. Floating-Point N-Body & OOP Methods in 1:1 Pythonic Syntax (benchmarks/nbody_float.*)
----------------------------------------------------------------------------------------
  - 100,000 7-field f64 Body objects x 60 central-field steps + 64-body all-pairs N-body x 2,000 steps
  Output: $(paste -sd ', ' "$TMP/out_nc")

  Language                       Best ms (mean)   vs Python 3   Raw KB   Stripped KB
  Python 3  (python3)              ${NPY_BEST} (${NPY_MEAN})        1.0x          n/a         n/a
  C         (AoS Body* -O2 -lm)    ${NC_BEST} (${NC_MEAN})        $(speedup_str "$NPY_BEST" "$NC_BEST")          ${NC_KB}          ${NC_SKB}
  Rust      (Vec<Body> -O)         ${NR_BEST} (${NR_MEAN})        $(speedup_str "$NPY_BEST" "$NR_BEST")        ${NR_KB}         ${NR_SKB}
  Archx     (Pythonic class + SoA) ${NA_BEST} (${NA_MEAN})        $(speedup_str "$NPY_BEST" "$NA_BEST")          ${NA_KB}          ${NA_SKB}

5. Planar SIMD Dict & Smart Adaptive Typing (benchmarks/dict_bench.* & dict_dynamic.*)
--------------------------------------------------------------------------------------
  - 120 rounds x 1,024-key str->i64 counts + 32,768-key i64->i64 churn & 40-pass iteration
  Output: $(paste -sd ', ' "$TMP/out_dc")

  Language                            Best ms (mean)   vs Python 3   Raw KB   Stripped KB
  Python 3       (python3 built-in dict)  ${DPY_BEST} (${DPY_MEAN})        1.0x          n/a         n/a
  C              (AoS open-addressing)    ${DC_BEST} (${DC_MEAN})        $(speedup_str "$DPY_BEST" "$DC_BEST")          ${DC_KB}          ${DC_SKB}
  Rust           (std::HashMap -O)        ${DR_BEST} (${DR_MEAN})        $(speedup_str "$DPY_BEST" "$DR_BEST")        ${DR_KB}         ${DR_SKB}
  Archx Static   (Planar SIMD + region)   ${DA_BEST} (${DA_MEAN})        $(speedup_str "$DPY_BEST" "$DA_BEST")          ${DA_KB}          ${DA_SKB}
  Archx Dynamic  (%ArchxAny dict[any])    ${DAD_BEST} (${DAD_MEAN})        $(speedup_str "$DPY_BEST" "$DAD_BEST")          ${DAD_KB}          ${DAD_SKB}

6. 5-Way Full-Feature Tour (examples/comparison/full_tour.* -- v0.1.0 through v0.8.0)
-------------------------------------------------------------------------------------
  - N-body physics + Planar SIMD dict/set + slicing + tuples + T | None + enum/match-case
  Output: $(paste -sd ' | ' "$TMP/out_tc")

  Language                                 Best ms (mean)   vs Python 3   Raw KB   Stripped KB
  Python 3          (full_tour.py)             ${TPY_BEST} (${TPY_MEAN})        1.0x          n/a         n/a
  Archx Pythonic    (1:1 == full_tour.py -O2)  ${TAP_BEST} (${TAP_MEAN})        $(speedup_str "$TPY_BEST" "$TAP_BEST")          ${TAP_KB}          ${TAP_SKB}
  Archx Speed       (SoA + region + enum -O2)  ${TAS_BEST} (${TAS_MEAN})        $(speedup_str "$TPY_BEST" "$TAS_BEST")          ${TAS_KB}          ${TAS_SKB}
  Clang C           (full_tour.c -O2 -lm)      ${TC_BEST} (${TC_MEAN})        $(speedup_str "$TPY_BEST" "$TC_BEST")          ${TC_KB}          ${TC_SKB}
  Rust              (full_tour.rs rustc -O)    ${TR_BEST} (${TR_MEAN})        $(speedup_str "$TPY_BEST" "$TR_BEST")        ${TR_KB}         ${TR_SKB}
EOF
)

mkdir -p "$(dirname "$OUT")"
printf '%s\n' "$REPORT" | tee "$OUT"
echo
echo "saved -> $OUT"
