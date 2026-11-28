# archx: dialect=compat, version=1
# conformance: xfail internal error: `list.insert` rejects a list that has no storage slot (a `list()` call result)
xs = [1, 2, 3]
xs.insert(1, 9)
xs.remove(3)
print(xs)
