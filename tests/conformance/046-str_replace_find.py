# archx: dialect=compat, version=1
# conformance: xfail `str.count` is not implemented
s = 'banana'
print(s.replace('a', 'o'), s.find('na'), s.count('a'))
