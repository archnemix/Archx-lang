# archx: dialect=compat, version=1
# conformance: xfail compat division by zero traps instead of raising ZeroDivisionError
print(1 / 0)
