# archx: dialect=compat, version=1
# conformance: xfail `str.title` is not implemented
s = 'Hello World'
print(s.lower(), s.upper(), s.title(), s.strip())
