# archx: dialect=compat, version=1
# conformance: xfail `global` is not implemented
count = 0

def bump():
    global count
    count += 1

bump()
bump()
print(count)
