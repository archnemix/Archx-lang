# archx: dialect=compat, version=1
# conformance: xfail *args is not implemented
def total(*args):
    s = 0
    for a in args:
        s += a
    return s

print(total(1, 2, 3))
