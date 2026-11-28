# archx: dialect=compat, version=1
# conformance: xfail compat missing keys trap instead of raising KeyError
d = {}
print(d['missing'])
