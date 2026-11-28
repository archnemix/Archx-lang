# archx: dialect=compat, version=1
# conformance: xfail `list * int` repetition is not implemented
print([1, 2] + [3], [0] * 3, [1, 2] * 2)
