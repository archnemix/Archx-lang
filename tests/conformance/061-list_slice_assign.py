# archx: dialect=compat, version=1
xs = [1, 2, 3, 4, 5]
print(xs[1:3], xs[:2], xs[3:], xs[::2])
xs[0] = 9
print(xs)
