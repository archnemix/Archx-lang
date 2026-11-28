# archx: dialect=compat, version=1
# conformance: xfail `any`/`all` are not implemented
print(sum([1, 2, 3]), any([0, 1]), all([1, 1]), all([1, 0]), sum(range(5)))
