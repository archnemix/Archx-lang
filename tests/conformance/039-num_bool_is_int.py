# archx: dialect=compat, version=1
# conformance: xfail `bool` is not a subtype of `int` (`True + 1` is rejected)
print(True + 1, False + 1, isinstance(True, int), int(True), int(False))
