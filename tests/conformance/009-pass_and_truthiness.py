# archx: dialect=compat, version=1
# conformance: xfail `if` requires `bool`; Python truthiness (`if 0:`, `bool([])`) is not implemented
if 0:
    pass
print(bool(0), bool(1), bool(''), bool('a'), bool([]), bool([0]))
