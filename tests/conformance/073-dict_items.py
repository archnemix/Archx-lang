# archx: dialect=compat, version=1
# conformance: xfail `dict.items()` is not implemented (only `get`, `pop`, `keys`, `values`, `clear`)
d = {'a': 1, 'b': 2}
for k, v in sorted(d.items()):
    print(k, v)
