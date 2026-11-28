# archx: dialect=compat, version=1
def greet(name, punct='!'):
    return name + punct

print(greet('ada'), greet('ada', '?'))
