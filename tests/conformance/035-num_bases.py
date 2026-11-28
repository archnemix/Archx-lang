# archx: dialect=compat, version=1
# conformance: xfail `int(x, base)` is not implemented
print(int('ff', 16), int('101', 2))
