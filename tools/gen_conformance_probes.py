#!/usr/bin/env python3
"""Writes the conformance probes in `tests/conformance/` (AX-007).

Each probe is a single `.py` file that is *also* legal Archx source: line 1 is the dialect directive,
which Python reads as an ordinary comment. That is what makes the check meaningful — the same bytes
are executed by `python3` and compiled by `archx`, so a divergence cannot come from two hand-written
programs drifting apart.

A probe may carry `# conformance: xfail <reason>` on its second line when Archx does not (yet)
reproduce CPython. The reason is required: an xfail without a reason is an undocumented failure, and
`docs/LIMITATIONS.md` must be able to say why each gap exists.

Run this only when adding or editing probes; the files themselves are committed.
"""

import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "tests" / "conformance"
DIRECTIVE = "# archx: dialect=compat, version=1"

# (slug, source-below-the-directive, xfail reason or None)
PROBES: list[tuple[str, str, str | None]] = [
    # --- 1. control flow -------------------------------------------------
    ("if_elif_else", "x = 7\nif x > 10:\n    print('big')\nelif x > 5:\n    print('mid')\nelse:\n    print('small')\n", None),
    ("while_countdown", "n = 5\nwhile n > 0:\n    print(n)\n    n -= 1\n", None),
    ("for_range", "for i in range(4):\n    print(i)\n", None),
    ("for_range_step", "for i in range(10, 0, -3):\n    print(i)\n", None),
    ("for_else_no_break", "for i in range(3):\n    print(i)\nelse:\n    print('done')\n", None),
    ("for_else_break", "for i in range(5):\n    if i == 2:\n        break\n    print(i)\nelse:\n    print('never')\n", None),
    ("nested_loops_break", "for i in range(3):\n    for j in range(3):\n        if j == 1:\n            break\n        print(i, j)\n", None),
    ("continue_skip", "for i in range(6):\n    if i % 2 == 0:\n        continue\n    print(i)\n", None),
    ("pass_and_truthiness", "if 0:\n    pass\nprint(bool(0), bool(1), bool(''), bool('a'), bool([]), bool([0]))\n", "`if` requires `bool`; Python truthiness (`if 0:`, `bool([])`) is not implemented"),
    ("ternary", "x = 3\nprint('yes' if x > 2 else 'no', 'no' if x > 5 else 'yes')\n", None),
    # --- 2. functions ----------------------------------------------------
    ("func_basic", "def add(a, b):\n    return a + b\n\nprint(add(2, 3))\n", None),
    ("func_defaults", "def greet(name, punct='!'):\n    return name + punct\n\nprint(greet('ada'), greet('ada', '?'))\n", None),
    ("func_kwargs", "def rect(w, h):\n    return w * h\n\nprint(rect(h=3, w=4), rect(2, 5))\n", None),
    ("func_recursion", "def fib(n):\n    if n < 2:\n        return n\n    return fib(n - 1) + fib(n - 2)\n\nprint(fib(10))\n", None),
    ("func_closure_scope", "def outer(x):\n    def inner(y):\n        return x + y\n    return inner(10)\n\nprint(outer(5))\n", "nested `def` is not implemented"),
    ("func_multiple_return", "def stats(xs):\n    lo = min(xs)\n    hi = max(xs)\n    return lo, hi\n\nlo, hi = stats([3, 9, 1])\nprint(lo, hi)\n", "`min(seq)`/`max(seq)` accept only `list[int]`/`list[float]`, not a general iterable"),
    ("func_varargs", "def total(*args):\n    s = 0\n    for a in args:\n        s += a\n    return s\n\nprint(total(1, 2, 3))\n", "*args is not implemented"),
    ("func_kwargs_star", "def show(**kw):\n    return len(kw)\n\nprint(show(a=1, b=2))\n", "**kwargs is not implemented"),
    ("func_lambda", "f = lambda x: x * 3\nprint(f(4), sorted([3, 1, 2], key=lambda v: -v))\n", None),
    ("func_global", "count = 0\n\ndef bump():\n    global count\n    count += 1\n\nbump()\nbump()\nprint(count)\n", "`global` is not implemented"),
    # --- 3. operators ----------------------------------------------------
    ("ops_arithmetic", "a = 17\nb = 5\nprint(a + b, a - b, a * b, a / b, a // b, a % b, a ** 2)\n", None),
    ("ops_floordiv_negative", "print(-7 // 2, -7 % 2, 7 // -2, 7 % -2)\n", None),
    ("ops_true_division", "print(7 / 2, 6 / 2, -1 / 4)\n", None),
    ("ops_bitwise", "print(12 & 10, 12 | 10, 12 ^ 10, ~12, 1 << 5, 64 >> 3)\n", None),
    ("ops_comparison", "print(1 < 2, 2 <= 2, 3 > 4, 3 >= 3, 1 == 1, 1 != 1)\n", None),
    ("ops_logical", "print(True and False, True or False, not True)\n", None),
    ("ops_chained", "x = 5\nprint(1 < x < 10, 1 < x < 3)\n", None),
    ("ops_augmented", "x = 10\nx += 5\nx -= 3\nx *= 2\nx //= 4\nprint(x)\n", None),
    ("ops_in", "print(2 in [1, 2, 3], 5 in [1, 2, 3], 'bc' in 'abcd', 'z' in 'abcd')\n", None),
    ("ops_precedence", "print(2 + 3 * 4, (2 + 3) * 4, 2 ** 3 ** 2)\n", None),
    # --- 4. numbers ------------------------------------------------------
    ("num_int_repr", "print(0, -0, 42, -42, 1000000)\n", None),
    ("num_float_repr", "print(1.5, -0.25, 2.0, 0.1 + 0.2)\n", None),
    ("num_float_ops", "print(1.0 / 3.0, 2.0 ** 0.5, abs(-2.5), round(2.567, 2))\n", None),
    ("num_int_float_mix", "print(1 + 2.5, 3 * 1.5, 7 / 2, int(2.9), float(3))\n", None),
    ("num_bases", "print(int('ff', 16), int('101', 2), hex(255), oct(8), bin(5))\n", "`int(x, base)` and `hex`/`oct`/`bin` are not implemented"),
    ("num_minmax", "print(min(3, 1, 2), max(3, 1, 2), min([4, 2]), max([4, 2]), min(2.5, 1.5))\n", None),
    ("num_abs_sign", "print(abs(-7), abs(7), abs(-0.5), -(-3))\n", None),
    ("num_division_edges", "print(0 / 5, 5 // 1, 0 % 3, 2 ** 0)\n", None),
    ("num_bool_is_int", "print(True + 1, False + 1, isinstance(True, int), int(True), int(False))\n", "`bool` is not a subtype of `int` (`True + 1` is rejected)"),
    ("num_large", "print(2 ** 40, 10 ** 12, -(2 ** 40))\n", None),
    # --- 5. strings ------------------------------------------------------
    ("str_basic", "s = 'archx'\nprint(s, len(s), s[0], s[-1], s[1:3])\n", None),
    ("str_concat_repeat", "print('ab' + 'cd', 'ab' * 3, 'x' + str(1))\n", None),
    ("str_methods", "s = 'Hello World'\nprint(s.lower(), s.upper(), s.title(), s.strip())\n", "`str.title` is not implemented"),
    ("str_split_join", "print('a,b,c'.split(','), '-'.join(['x', 'y']), ' a b '.split())\n", None),
    ("str_replace_find", "s = 'banana'\nprint(s.replace('a', 'o'), s.find('na'), s.count('a'))\n", "`str.count` is not implemented"),
    ("str_startswith", "s = 'archx.lang'\nprint(s.startswith('archx'), s.endswith('.lang'), s.startswith('llvm'))\n", None),
    ("str_format_basic", "print('{} and {}'.format('a', 'b'), '{}-{}'.format(1, 2))\n", None),
    ("str_fstring", "name = 'ada'\nn = 3\nprint(f'{name} has {n} items')\n", None),
    ("str_fstring_expr", "w = 4\nh = 5\nprint(f'area={w * h} ratio={w / h}')\n", None),
    ("str_iteration", "for ch in 'abc':\n    print(ch)\n", None),
    ("str_compare", "print('a' < 'b', 'ab' == 'ab', 'Z' < 'a', 'abc' != 'abd')\n", None),
    ("str_escape", "print('tab\\there', 'newline\\nhere', 'quote\\\"q', 'back\\\\slash')\n", None),
    ("str_reverse_slice", "s = 'abcdef'\nprint(s[::-1], s[::2], s[-3:], s[:-2])\n", None),
    ("str_strip_chars", "print('xxhixx'.strip('x'), ' hi '.lstrip(), ' hi '.rstrip())\n", "`str.strip(chars)` with an argument is not implemented"),
    ("str_zfill_rjust", "print('7'.zfill(3), 'ab'.rjust(5, '.'), 'ab'.ljust(4, '-'))\n", "`str.zfill`/`ljust`/`rjust` are not implemented"),
    ("str_unicode_len", "s = 'héllo'\nprint(len(s), s[1], s.upper())\n", "compat strings are byte-indexed, not code-point"),
    ("str_isalpha", "print('abc'.isalpha(), '123'.isdigit(), 'a1'.isalpha(), ''.isdigit())\n", "`str.isalpha`/`isdigit` are not implemented"),
    # --- 6. collections --------------------------------------------------
    ("list_build_index", "xs = [10, 20, 30]\nprint(xs, len(xs), xs[0], xs[-1], xs[1])\n", None),
    ("list_append_pop", "xs = [1, 2]\nxs.append(3)\nxs.append(4)\nprint(xs, xs.pop(), xs)\n", "arguments to one call are formatted before later ones run, so `print(xs, xs.pop())` shows the post-pop list"),
    ("list_insert_remove", "xs = [1, 2, 3]\nxs.insert(1, 9)\nxs.remove(3)\nprint(xs)\n", "internal error: `list.insert` rejects a list that has no storage slot (a `list()` call result)"),
    ("list_slice_assign", "xs = [1, 2, 3, 4, 5]\nprint(xs[1:3], xs[:2], xs[3:], xs[::2])\nxs[0] = 9\nprint(xs)\n", None),
    ("list_sort", "xs = [3, 1, 2]\nxs.sort()\nprint(xs, sorted([5, 2, 9]), sorted([5, 2, 9], reverse=True))\n", None),
    ("list_reverse", "xs = [1, 2, 3]\nxs.reverse()\nprint(xs, list(reversed([1, 2, 3])))\n", "`reversed()` is not implemented"),
    ("list_concat_repeat", "print([1, 2] + [3], [0] * 3, [1, 2] * 2)\n", "`list * int` repetition is not implemented"),
    ("list_index_count", "xs = [1, 2, 2, 3]\nprint(xs.index(2), xs.count(2), xs.count(9))\n", "internal error: `list.index`/`list.count` reject a list that has no storage slot"),
    ("list_nested", "m = [[1, 2], [3, 4]]\nprint(m, m[1][0], len(m))\n", None),
    ("list_comprehension", "print([x * x for x in range(5)])\nprint([x for x in range(10) if x % 3 == 0])\n", None),
    ("list_comprehension_nested", "print([[r * c for c in range(3)] for r in range(2)])\n", None),
    ("dict_basic", "d = {'a': 1, 'b': 2}\nprint(d['a'], len(d), 'b' in d, 'z' in d)\n", None),
    ("dict_get_set", "d = {}\nd['x'] = 1\nd['x'] += 1\nprint(d['x'], d.get('x'), d.get('y', 0))\n", None),
    ("dict_keys_values", "d = {'a': 1, 'b': 2}\nprint(sorted(d.keys()), sorted(d.values()))\n", None),
    ("dict_items", "d = {'a': 1, 'b': 2}\nfor k, v in sorted(d.items()):\n    print(k, v)\n", "`dict.items()` is not implemented (only `get`, `pop`, `keys`, `values`, `clear`)"),
    ("dict_delete", "d = {'a': 1, 'b': 2}\ndel d['a']\nprint(len(d), 'a' in d)\n", "`del d[k]` is not implemented; `del` only accepts a variable name"),
    ("set_basic", "s = {1, 2, 3}\ns.add(4)\nprint(len(s), 2 in s, 9 in s)\n", None),
    ("set_ops", "print(sorted({1, 2} | {2, 3}), sorted({1, 2} & {2, 3}), sorted({1, 2} - {2}))\n", "`sorted()` accepts only lists, not sets"),
    ("tuple_basic", "t = (1, 2, 3)\nprint(t, len(t), t[0], t[-1], t[1:])\n", "tuple slicing is not implemented"),
    ("tuple_unpack", "a, b = 1, 2\na, b = b, a\nprint(a, b)\n", None),
    ("sorted_key", "print(sorted(['bb', 'a', 'ccc'], key=len), sorted([3, 1, 2], key=lambda v: -v))\n", "`key=` accepts only a `lambda`, not a named function such as `len`"),
    ("sum_any_all", "print(sum([1, 2, 3]), any([0, 1]), all([1, 1]), all([1, 0]), sum(range(5)))\n", "`any`/`all` are not implemented"),
    ("enumerate_zip", "for i, v in enumerate(['a', 'b']):\n    print(i, v)\nfor x, y in zip([1, 2], [3, 4]):\n    print(x, y)\n", None),
    # --- 7. errors -------------------------------------------------------
    ("err_try_except", "try:\n    print(1)\nexcept ValueError:\n    print('err')\n", "try/except is not implemented"),
    ("err_raise", "def f():\n    raise ValueError('boom')\n\nf()\n", "raise is not implemented"),
    ("err_zero_division", "print(1 / 0)\n", "compat division by zero traps instead of raising ZeroDivisionError"),
    ("err_index_error", "xs = [1]\nprint(xs[5])\n", "compat index errors trap instead of raising IndexError"),
    ("err_key_error", "d = {}\nprint(d['missing'])\n", "compat missing keys trap instead of raising KeyError"),
    ("err_else_finally", "try:\n    pass\nexcept Exception:\n    pass\nelse:\n    print('ok')\nfinally:\n    print('done')\n", "try/except/else/finally is not implemented"),
    # --- 8. modules ------------------------------------------------------
    ("mod_import_math", "import math\nprint(math.floor(2.7), math.ceil(2.1))\n", "import is not implemented"),
    ("mod_from_import", "from math import sqrt\nprint(sqrt(9.0))\n", "import is not implemented"),
    ("mod_sys_argv", "import sys\nprint(len(sys.argv) > 0)\n", "import is not implemented"),
    ("mod_open_file", "open('/tmp/archx_probe.txt', 'w')\nprint('written')\n", "file I/O is not implemented"),
    ("mod_main_guard", "def main():\n    print('ran')\n\nif __name__ == '__main__':\n    main()\n", None),
    ("mod_os_path", "import os\nprint(os.path.sep == '/' or True)\n", "import is not implemented"),
    ("mod_json", "import json\nprint(json.dumps({'a': 1}))\n", "import is not implemented"),
    ("mod_datetime", "import datetime\nprint(datetime.date(2020, 1, 1).year)\n", "import is not implemented"),
    # --- 9. classes & misc -----------------------------------------------
    ("class_basic", "class Point:\n    def __init__(self, x, y):\n        self.x = x\n        self.y = y\n\n    def sum(self):\n        return self.x + self.y\n\np = Point(1, 2)\nprint(p.sum(), p.x, p.y)\n", None),
    ("class_str_repr", "class Box:\n    def __init__(self, v):\n        self.v = v\n\nb = Box(5)\nprint(b.v)\n", None),
    ("misc_print_sep_end", "print(1, 2, 3, sep='-', end='!')\nprint()\n", None),
    ("misc_print_float_fmt", "print(1.0, 100.0, 0.5, 1e10)\n", None),
    ("misc_str_int_conv", "print(int('42'), str(42), float('1.5'), int('7') + 1)\n", None),
    ("misc_assert", "assert 1 == 1\nprint('after assert')\n", None),
    ("misc_type", "print(type(1), type(1.0), type('s'), type([]), type({}), type(True))\n", "`type(x)` prints the Archx type name (`int`), not CPython's `<class 'int'>`"),
    ("misc_isinstance", "print(isinstance(1, int), isinstance('s', str), isinstance(1.0, float))\n", None),
    ("misc_idiom_fizzbuzz", "for i in range(1, 16):\n    if i % 15 == 0:\n        print('FizzBuzz')\n    elif i % 3 == 0:\n        print('Fizz')\n    elif i % 5 == 0:\n        print('Buzz')\n    else:\n        print(i)\n", None),
    ("misc_idiom_wordcount", "text = 'a b a c b a'\ncounts = {}\nfor w in text.split():\n    counts[w] = counts.get(w, 0) + 1\nfor k in sorted(counts):\n    print(k, counts[k])\n", "`sorted()` accepts only lists, not a dict's keys"),
]


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for stale in OUT.glob("*.py"):
        stale.unlink()
    for index, (slug, body, xfail) in enumerate(PROBES, start=1):
        name = f"{index:03d}-{slug}.py"
        text = f"{DIRECTIVE}\n"
        if xfail:
            text += f"# conformance: xfail {xfail}\n"
        if not re.match(r"^#", body):
            text += body
        (OUT / name).write_text(text)
    print(f"wrote {len(PROBES)} probes to {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
