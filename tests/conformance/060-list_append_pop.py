# archx: dialect=compat, version=1
# conformance: xfail arguments to one call are formatted before later ones run, so `print(xs, xs.pop())` shows the post-pop list
xs = [1, 2]
xs.append(3)
xs.append(4)
print(xs, xs.pop(), xs)
