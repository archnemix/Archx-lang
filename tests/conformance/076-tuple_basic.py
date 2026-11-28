# archx: dialect=compat, version=1
# conformance: xfail tuple slicing is not implemented
t = (1, 2, 3)
print(t, len(t), t[0], t[-1], t[1:])
