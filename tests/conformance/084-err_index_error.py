# archx: dialect=compat, version=1
# conformance: xfail compat index errors trap instead of raising IndexError
xs = [1]
print(xs[5])
