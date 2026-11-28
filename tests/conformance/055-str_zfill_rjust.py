# archx: dialect=compat, version=1
# conformance: xfail `str.zfill`/`ljust`/`rjust` are not implemented
print('7'.zfill(3), 'ab'.rjust(5, '.'), 'ab'.ljust(4, '-'))
