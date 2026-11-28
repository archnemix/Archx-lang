# archx: dialect=compat, version=1
# conformance: xfail `del d[k]` is not implemented; `del` only accepts a variable name
d = {'a': 1, 'b': 2}
del d['a']
print(len(d), 'a' in d)
