# archx: dialect=compat, version=1
class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def sum(self):
        return self.x + self.y

p = Point(1, 2)
print(p.sum(), p.x, p.y)
