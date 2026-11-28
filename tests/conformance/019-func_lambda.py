# archx: dialect=compat, version=1
f = lambda x: x * 3
print(f(4), sorted([3, 1, 2], key=lambda v: -v))
