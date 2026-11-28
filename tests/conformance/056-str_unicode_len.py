# archx: dialect=compat, version=1
# conformance: xfail compat strings are byte-indexed, not code-point
s = 'héllo'
print(len(s), s[1], s.upper())
