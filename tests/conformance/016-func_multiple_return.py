# archx: dialect=compat, version=1
# conformance: xfail `min(seq)`/`max(seq)` accept only `list[int]`/`list[float]`, not a general iterable
def stats(xs):
    lo = min(xs)
    hi = max(xs)
    return lo, hi

lo, hi = stats([3, 9, 1])
print(lo, hi)
