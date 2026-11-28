# archx: dialect=compat, version=1
# conformance: xfail try/except is not implemented
try:
    print(1)
except ValueError:
    print('err')
