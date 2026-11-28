# archx: dialect=compat, version=1
# conformance: xfail `sorted()` accepts only lists, not sets
print(sorted({1, 2} | {2, 3}), sorted({1, 2} & {2, 3}), sorted({1, 2} - {2}))
