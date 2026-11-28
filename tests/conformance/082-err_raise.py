# archx: dialect=compat, version=1
# conformance: xfail raise is not implemented
def f():
    raise ValueError('boom')

f()
