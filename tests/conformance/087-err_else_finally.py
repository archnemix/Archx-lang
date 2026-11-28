# archx: dialect=compat, version=1
# conformance: xfail try/except/else/finally is not implemented
try:
    pass
except Exception:
    pass
else:
    print('ok')
finally:
    print('done')
