# archx: dialect=compat, version=1
d = {}
d['x'] = 1
d['x'] += 1
print(d['x'], d.get('x'), d.get('y', 0))
