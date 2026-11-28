# archx: dialect=compat, version=1
# conformance: xfail `str.isalpha`/`isdigit` are not implemented
print('abc'.isalpha(), '123'.isdigit(), 'a1'.isalpha(), ''.isdigit())
