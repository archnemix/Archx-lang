# archx: dialect=compat, version=1
class Box:
    def __init__(self, v):
        self.v = v

b = Box(5)
print(b.v)
