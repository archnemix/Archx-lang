# archx: dialect=compat, version=1
# conformance: xfail file I/O is not implemented
open('/tmp/archx_probe.txt', 'w')
print('written')
