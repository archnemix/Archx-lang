# archx: dialect=compat, version=1
# conformance: xfail `key=` accepts only a `lambda`, not a named function such as `len`
print(sorted(['bb', 'a', 'ccc'], key=len), sorted([3, 1, 2], key=lambda v: -v))
