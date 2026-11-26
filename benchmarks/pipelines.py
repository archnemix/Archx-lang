# Suite 7 (Python 3 reference & 1:1 Pythonic Archx source):
# Comprehension and generator pipelines, `zip`, `sorted` with and without `key=`.
#
# The point of this suite is that no intermediate container is built by hand: every stage is
# a comprehension, a generator expression inside a fold (`sum`/`min`/`max`/`any`/`all`), or a
# `sorted(...)` call, exactly as a Python programmer would write it. The Archx edition of this
# file is byte-for-byte identical, and its compiler lowers each stage to inline IR (a fused
# loop, a single pre-sized allocation, and an inline merge sort) instead of allocating a
# Python-style container per stage.


def sweep(n: int) -> int:
    acc = 0
    for i in range(n):
        acc += (i * 7919) % 10007
    return acc


def pipeline_a(n: int) -> int:
    data = [i for i in range(n)]
    squares = [x * x for x in data]
    evens = [x for x in squares if x % 2 == 0]
    total = 0
    for v in evens:
        total += v
    return total + len(data) + len(squares) + len(evens)


def pipeline_b(n: int) -> int:
    scaled = [x * 3 for x in range(n)]
    picked = [x for x in scaled if x % 5 != 0]
    ordered = sorted(picked)
    rev = sorted(picked, reverse=True)
    chk = 0
    for i in range(16):
        chk += ordered[i] + rev[i]
    return chk + len(picked)


def pipeline_c(n: int) -> int:
    a = [i for i in range(n)]
    b = [n - i for i in range(n)]
    zsum = 0
    for x, y in zip(a, b):
        zsum += x * y
    pairs = [(x, y) for x, y in zip(a, b) if (x + y) % 7 == 0]
    psum = 0
    for x, y in pairs:
        psum += x - y
    return zsum + psum + len(pairs)


def pipeline_d(n: int) -> int:
    raw = [(i * 37) % 1000 for i in range(n)]
    by_mod = sorted(raw, key=lambda v: v % 13)
    by_neg = sorted(raw, key=lambda v: -v)
    by_diff = sorted(raw, key=lambda v: (v % 10) * 1000 + (v % 3))
    chk = 0
    for i in range(8):
        chk += by_mod[i] + by_neg[i] + by_diff[i]
    # Fold the whole reordered buffer back in, so the *entire* permutation is observed and the
    # benchmark cannot be satisfied by a partial sort.
    for v in by_neg:
        chk += v % 7
    return chk + len(raw)


def pipeline_e(n: int) -> int:
    total = sum(x * x for x in range(n))
    evens = sum(x for x in range(n) if x % 2 == 0)
    mx = max(x * 3 for x in range(n))
    mn = min(x * 2 + 1 for x in range(n))
    has_big = any(x > n for x in range(n))
    all_pos = all(x >= 0 for x in range(n))
    flag = 0
    if has_big:
        flag += 1
    if all_pos:
        flag += 2
    return total + evens + mx + mn + flag


def pipeline_f(n: int) -> int:
    words = ["w" * (i % 5) for i in range(n)]
    lens = [len(w) for w in words]
    lsum = 0
    for l in lens:
        lsum += l
    ordered = sorted(words)
    bylen = sorted(words, key=lambda w: len(w))
    chk = 0
    for i in range(12):
        chk += len(ordered[i]) + len(bylen[i])
    for w in bylen:
        chk += len(w) * 2
    return lsum + chk


def pipeline_g(n: int) -> int:
    grid = [[r * c for c in range(16)] for r in range(n)]
    chk = 0
    for row in grid:
        for v in row:
            chk += v
    flat = sorted([v for row in grid for v in row])
    for i in range(16):
        chk += flat[i]
    for v in flat:
        chk += v % 11
    return chk


def pipeline_h(n: int) -> int:
    counts = {}
    for i in range(n):
        k = i % 512
        counts[k] = counts.get(k, 0) + (i % 9)
    keys = sorted(counts.keys())
    chk = 0
    for i in range(16):
        chk += keys[i]
    for _k, v in counts.items():
        chk += v
    return chk


def main():
    n = 20000
    acc = 0
    acc += sweep(n)
    acc += pipeline_a(n)
    acc += pipeline_b(n)
    acc += pipeline_c(n)
    acc += pipeline_d(n)
    acc += pipeline_e(n)
    acc += pipeline_f(n)
    acc += pipeline_g(320)
    acc += pipeline_h(n)
    print(acc)


if __name__ == "__main__":
    main()
