# archx: dialect=compat, version=1
# conformance: xfail `reversed()` is not implemented
xs = [1, 2, 3]
xs.reverse()
print(xs, list(reversed([1, 2, 3])))
