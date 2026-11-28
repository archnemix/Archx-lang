# archx: dialect=compat, version=1
# conformance: xfail `str.strip(chars)` with an argument is not implemented
print('xxhixx'.strip('x'), ' hi '.lstrip(), ' hi '.rstrip())
