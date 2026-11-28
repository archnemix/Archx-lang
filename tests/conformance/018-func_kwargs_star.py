# archx: dialect=compat, version=1
# conformance: xfail **kwargs is not implemented
def show(**kw):
    return len(kw)

print(show(a=1, b=2))
