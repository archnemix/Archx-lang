# archx: dialect=compat, version=1
# conformance: xfail internal error: `list.index`/`list.count` reject a list that has no storage slot
xs = [1, 2, 2, 3]
print(xs.index(2), xs.count(2), xs.count(9))
