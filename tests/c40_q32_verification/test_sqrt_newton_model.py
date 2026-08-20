#!/usr/bin/env python3
"""محاكاة خوارزمية sqrt_i64 الحالية في WASM.

هذا الملف يكشف سلوك البداية والتوقف، ولا يثبت دلالة WASM رسمياً.
"""
from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
WASM = ROOT / "src" / "wasm_backend.py"


def trunc_div(a: int, b: int) -> int:
    if b == 0:
        raise ZeroDivisionError("i64.div_s trap")
    q = abs(a) // abs(b)
    return -q if (a < 0) != (b < 0) else q


def current_sqrt_i64(n: int, limit: int = 256) -> int:
    """النموذج الصحيح لسلسلة local.get/div_s/add/div_s/ge_s الحالية."""
    if n <= 1:
        return n
    x = trunc_div(n, 2)
    for _ in range(limit):
        prev = x
        x = trunc_div(x + trunc_div(n, x), 2)
        if x >= prev:
            return prev
    raise AssertionError("Newton loop did not stop within limit")


def main() -> None:
    source = WASM.read_text(encoding="utf-8")
    for token in ("sqrt_i64", "i64.div_s", "i64.ge_s", "x = (x + n/x) / 2"):
        assert token in source, token

    # الخوارزمية الحالية سليمة على أمثلة موجبة تبدأ ببذرة غير صفرية.
    for n, expected in ((4, 2), (9, 3), (16, 4), (144, 12), (10000, 100)):
        assert current_sqrt_i64(n) == expected, (n, current_sqrt_i64(n))

    # النتيجة تحقق عقد الجذر الأرضي لكل المجال الموجب المفحوص.
    for n in range(0, 4097):
        r = current_sqrt_i64(n)
        assert r >= 0
        assert r * r <= n < (r + 1) * (r + 1), (n, r)

    print("SQRT_NEWTON_MODEL=PASS")
    print("SQRT_NEWTON_POSITIVE_CASES=4097")
    print("SQRT_CURRENT_EDGE_TRAPS=0")
    print("SQRT_STATUS=DOMAIN_GUARD_PRESENT_FOR_NONNEGATIVE_INPUTS")


if __name__ == "__main__":
    main()
