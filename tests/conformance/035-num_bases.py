# archx: dialect=compat, version=1
# conformance: xfail `int(x, base)` and `hex`/`oct`/`bin` are not implemented
print(int('ff', 16), int('101', 2), hex(255), oct(8), bin(5))
