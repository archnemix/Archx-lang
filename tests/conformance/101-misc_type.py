# archx: dialect=compat, version=1
# conformance: xfail `type(x)` prints the Archx type name (`int`), not CPython's `<class 'int'>`
print(type(1), type(1.0), type('s'), type([]), type({}), type(True))
