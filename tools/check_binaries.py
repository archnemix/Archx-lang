#!/usr/bin/env python3
"""Fail if a compiled binary is tracked in the repository (AX-005).

The tree once carried six executables (`bw`, `call_and_loop_semantics`, `d1`, `full_tour_pythonic`,
`hello`, `pipelines`) because local build output was committed by accident. Detection is by magic
number of the *tracked* blobs, so it works on any host: `file(1)` is not installed everywhere, and
an extension check would miss exactly the nameless binary that caused the problem.
"""

import subprocess
import sys

# ELF, Mach-O (both byte orders and 64-bit), universal/fat Mach-O, PE/COFF.
MAGICS = {
    b"\x7fELF": "ELF",
    b"\xfe\xed\xfa\xce": "Mach-O",
    b"\xce\xfa\xed\xfe": "Mach-O",
    b"\xfe\xed\xfa\xcf": "Mach-O",
    b"\xcf\xfa\xed\xfe": "Mach-O",
    b"\xca\xfe\xba\xbe": "Mach-O universal",
    b"MZ": "PE",
}


def tracked_files() -> list[str]:
    out = subprocess.run(
        ["git", "ls-files", "-z"], capture_output=True, check=True
    ).stdout
    return [name for name in out.decode().split("\0") if name]


def main() -> int:
    offenders = []
    for name in tracked_files():
        try:
            with open(name, "rb") as handle:
                head = handle.read(4)
        except (OSError, UnicodeError):
            continue
        for magic, kind in MAGICS.items():
            if head.startswith(magic):
                offenders.append(f"{name} ({kind})")
                break

    if offenders:
        print("tracked binaries are not allowed:", file=sys.stderr)
        for offender in offenders:
            print(f"  {offender}", file=sys.stderr)
        print("remove them and add the name to .gitignore", file=sys.stderr)
        return 1
    print(f"no tracked binaries ({len(tracked_files())} files scanned)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
