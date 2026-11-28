# archx: dialect=compat, version=1
# conformance: xfail nested `def` is not implemented
def outer(x):
    def inner(y):
        return x + y
    return inner(10)

print(outer(5))
