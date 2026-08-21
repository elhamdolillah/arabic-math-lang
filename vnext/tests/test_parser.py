#!/usr/bin/env python3
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parents[1] / "tools"))
from parser import ParseError, lower, parse


GOOD = '''# تعليق
⎕ "السلام عليكم"
⎕ "مرحبا بالعالم"
'''


def main() -> None:
    program = parse(GOOD)
    assert len(program.statements) == 2
    lowered = lower(program)
    assert lowered[0] == {"op": "print", "value": "السلام عليكم", "line": 2}
    assert lowered[1]["value"] == "مرحبا بالعالم"

    for bad in ('س ≔ 1', '⎕ مرحبا', '⎕ "غير مغلق'):
        try:
            parse(bad)
        except ParseError:
            pass
        else:
            raise AssertionError(f"تم قبول صياغة غير صالحة: {bad!r}")
    print("VNEXT_PARSER=PASS")
    print("VNEXT_AST=PASS")
    print("VNEXT_NEGATIVE_CASES=3/3")


if __name__ == "__main__":
    main()
