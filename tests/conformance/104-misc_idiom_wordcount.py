# archx: dialect=compat, version=1
# conformance: xfail `sorted()` accepts only lists, not a dict's keys
text = 'a b a c b a'
counts = {}
for w in text.split():
    counts[w] = counts.get(w, 0) + 1
for k in sorted(counts):
    print(k, counts[k])
