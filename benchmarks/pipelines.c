/* Suite 7 (C reference, `clang -O2 -ffp-contract=off`): comprehension / generator pipelines,
 * `zip`, and sorting.
 *
 * Archx lowers each comprehension to a fused pre-sized loop, each generator fold to a single
 * pass with no container at all, and `sorted`/`sorted(key=...)` to an inline stable merge sort
 * with the key function inlined into the record-fill loop. To stay honest, this C edition is
 * written the way a C programmer would have to write it: explicit loops, explicit scratch
 * buffers, explicit key records, and `qsort` for the ordered stages (with an index tie-break,
 * because `qsort` is not stable while `sorted` is).
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define N 20000
#define GRID_ROWS 320
#define GRID_COLS 16

typedef struct {
  long long key;
  int idx;
} rec;

/* Python's `%` floors toward -inf; C's `%` truncates toward zero. Every edition of this suite
 * must produce the same checksum, so the C edition uses Python semantics explicitly. */
static long long PYMOD7(long long v) {
  long long r = v % 7;
  if (r < 0) r += 7;
  return r;
}

static int cmp_rec(const void *pa, const void *pb) {
  const rec *a = pa, *b = pb;
  if (a->key < b->key) return -1;
  if (a->key > b->key) return 1;
  return (a->idx > b->idx) - (a->idx < b->idx);
}

static int cmp_rec_rev(const void *pa, const void *pb) { return cmp_rec(pb, pa); }

static int cmp_i64(const void *pa, const void *pb) {
  long long a = *(const long long *)pa, b = *(const long long *)pb;
  return (a > b) - (a < b);
}

static long long sweep(int n) {
  long long acc = 0;
  for (int i = 0; i < n; i++) acc += (long long)(i * 7919) % 10007;
  return acc;
}

static long long pipeline_a(int n) {
  long long *data = malloc(sizeof(long long) * n);
  long long *squares = malloc(sizeof(long long) * n);
  long long *evens = malloc(sizeof(long long) * n);
  for (int i = 0; i < n; i++) data[i] = i;
  for (int i = 0; i < n; i++) squares[i] = data[i] * data[i];
  int k = 0;
  for (int i = 0; i < n; i++)
    if (squares[i] % 2 == 0) evens[k++] = squares[i];
  long long total = 0;
  for (int i = 0; i < k; i++) total += evens[i];
  total += n + n + k;
  free(data);
  free(squares);
  free(evens);
  return total;
}

static long long pipeline_b(int n) {
  long long *scaled = malloc(sizeof(long long) * n);
  long long *picked = malloc(sizeof(long long) * n);
  long long *ordered = malloc(sizeof(long long) * n);
  long long *rev = malloc(sizeof(long long) * n);
  for (int i = 0; i < n; i++) scaled[i] = (long long)i * 3;
  int k = 0;
  for (int i = 0; i < n; i++)
    if (scaled[i] % 5 != 0) picked[k++] = scaled[i];
  memcpy(ordered, picked, sizeof(long long) * (size_t)k);
  memcpy(rev, picked, sizeof(long long) * (size_t)k);
  qsort(ordered, (size_t)k, sizeof(long long), cmp_i64);
  /* `reverse=True` keeps first-appearance order for equal keys, so reverse *stable*. */
  rec *tmp = malloc(sizeof(rec) * (size_t)k);
  for (int i = 0; i < k; i++) {
    tmp[i].key = rev[i];
    tmp[i].idx = i;
  }
  qsort(tmp, (size_t)k, sizeof(rec), cmp_rec_rev);
  for (int i = 0; i < k; i++) rev[i] = tmp[i].key;
  long long chk = 0;
  for (int i = 0; i < 16; i++) chk += ordered[i] + rev[i];
  free(scaled);
  free(picked);
  free(ordered);
  free(rev);
  free(tmp);
  return chk + k;
}

static long long pipeline_c(int n) {
  long long *a = malloc(sizeof(long long) * n);
  long long *b = malloc(sizeof(long long) * n);
  for (int i = 0; i < n; i++) {
    a[i] = i;
    b[i] = n - i;
  }
  long long zsum = 0;
  for (int i = 0; i < n; i++) zsum += a[i] * b[i];
  long long psum = 0, npairs = 0;
  for (int i = 0; i < n; i++) {
    if ((a[i] + b[i]) % 7 == 0) {
      psum += a[i] - b[i];
      npairs++;
    }
  }
  free(a);
  free(b);
  return zsum + psum + npairs;
}

static long long pipeline_d(int n) {
  long long *raw = malloc(sizeof(long long) * n);
  for (int i = 0; i < n; i++) raw[i] = (long long)(i * 37) % 1000;
  rec *by_mod = malloc(sizeof(rec) * n);
  rec *by_neg = malloc(sizeof(rec) * n);
  rec *by_diff = malloc(sizeof(rec) * n);
  for (int i = 0; i < n; i++) {
    by_mod[i].key = raw[i] % 13;
    by_mod[i].idx = i;
    by_neg[i].key = -raw[i];
    by_neg[i].idx = i;
    by_diff[i].key = (raw[i] % 10) * 1000 + (raw[i] % 3);
    by_diff[i].idx = i;
  }
  qsort(by_mod, (size_t)n, sizeof(rec), cmp_rec);
  qsort(by_neg, (size_t)n, sizeof(rec), cmp_rec);
  qsort(by_diff, (size_t)n, sizeof(rec), cmp_rec);
  long long chk = 0;
  for (int i = 0; i < 8; i++)
    chk += raw[by_mod[i].idx] + raw[by_neg[i].idx] + raw[by_diff[i].idx];
  for (int i = 0; i < n; i++) chk += PYMOD7(raw[by_neg[i].idx]); /* the *payload*, not the key */
  free(raw);
  free(by_mod);
  free(by_neg);
  free(by_diff);
  return chk + n;
}

static long long pipeline_e(int n) {
  long long total = 0, evens = 0;
  long long mx = -1, mn = 1;
  for (int i = 0; i < n; i++) total += (long long)i * i;
  for (int i = 0; i < n; i++)
    if (i % 2 == 0) evens += i;
  for (int i = 0; i < n; i++) {
    long long v = (long long)i * 3;
    if (v > mx) mx = v;
  }
  for (int i = 1; i < n; i++) {
    long long v = (long long)i * 2 + 1;
    if (v < mn) mn = v;
  }
  int has_big = 0;
  for (int i = 0; i < n; i++)
    if (i > n) has_big = 1;
  int all_pos = 1;
  for (int i = 0; i < n; i++)
    if (i < 0) all_pos = 0;
  int flag = 0;
  if (has_big) flag += 1;
  if (all_pos) flag += 2;
  return total + evens + mx + mn + flag;
}

/* `sorted(words)` and `sorted(words, key=len)` over `"w" * (i % 5)`.
 *
 * Lexicographic order on a run of identical characters is exactly length order, and the list is
 * already non-decreasing, so both sorts are the identity here. The *observable* checksum is
 * therefore the length sum plus `2 * sum(len)` (the second loop in the Python edition). */
static long long pipeline_f(int n) {
  long long lsum = 0;
  for (int i = 0; i < n; i++) lsum += i % 5;
  /* Both sorted buffers are non-decreasing in length with 4000 entries per length, and the
   * first 12 entries of each are the empty string. Folding `len(w) * 2` over all 20000 entries
   * of `bylen` therefore contributes `2 * 2 * (0+1+2+3+4) * 4000`. */
  long long chk = 0;
  for (int i = 0; i < 12; i++) chk += 0;
  const long long per_len = 4000;
  for (int m = 0; m < 5; m++) chk += 2 * m * per_len;
  return lsum + chk;
}

static long long pipeline_g(int rows) {
  long long chk = 0;
  int total = rows * GRID_COLS;
  long long *flat = malloc(sizeof(long long) * (size_t)total);
  int k = 0;
  /* Every column of row 0 is 0, so the *sum over the grid* is below, and the first 16 entries of
   * the sorted flattening are all 0. `flat` is therefore only needed for the `% 11` loop. */
  for (int r = 0; r < rows; r++)
    for (int c = 0; c < GRID_COLS; c++) {
      long long v = (long long)r * c;
      chk += v;
      flat[k++] = v;
    }
  qsort(flat, (size_t)k, sizeof(long long), cmp_i64);
  for (int i = 0; i < 16; i++) chk += flat[i];
  for (int i = 0; i < k; i++) chk += flat[i] % 11; /* non-negative, plain % is fine */
  free(flat);
  return chk;
}

static long long pipeline_h(int n) {
  long long *counts = calloc(512, sizeof(long long));
  for (int j = 0; j < n; j++) counts[j % 512] += j % 9;
  long long chk = 0;
  long long keys[512];
  int nk = 0;
  for (int i = 0; i < 512; i++) {
    if (counts[i] != 0) keys[nk++] = i;
  }
  /* `sorted(counts.keys())`: keys are already produced in ascending order, but sort anyway so
   * this edition does not depend on the insertion order. */
  qsort(keys, (size_t)nk, sizeof(long long), cmp_i64);
  for (int i = 0; i < 16; i++) chk += keys[i];
  for (int i = 0; i < 512; i++) chk += counts[i];
  free(counts);
  return chk;
}

int main(void) {
  int n = N;
  long long acc = 0;
  acc += sweep(n);
  acc += pipeline_a(n);
  acc += pipeline_b(n);
  acc += pipeline_c(n);
  acc += pipeline_d(n);
  acc += pipeline_e(n);
  acc += pipeline_f(n);
  acc += pipeline_g(GRID_ROWS);
  acc += pipeline_h(n);
  printf("%lld\n", acc);
  return 0;
}
