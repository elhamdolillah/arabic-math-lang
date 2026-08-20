#!/usr/bin/env python3
"""اختبار عقد جذر Q32.32؛ ليس إثباتاً لدلالة WASM أو CPU."""
from __future__ import annotations

import math
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SCALE = 1 << 32
COQ = ROOT / "formal" / "C40_Q32_Sqrt_Semantic_Link.v"


def check_model(x: int) -> None:
    assert x >= 0
    n = x * SCALE
    r = math.isqrt(n)
    assert r * r <= n < (r + 1) * (r + 1)
    assert r >= 0


def main() -> None:
    assert COQ.exists()
    source = COQ.read_text(encoding="utf-8")
    for symbol in (
        "sqrt_model_bounds",
        "sqrt_model_nonnegative",
        "sqrt_step_ok_unique",
        "low_level_sqrt_step_refines_model",
    ):
        assert symbol in source, symbol

    cases = [0, 1, 2, 3, 4, 16, 144, SCALE, 2 * SCALE, (1 << 31) * SCALE]
    for x in cases:
        check_model(x)
    for x in range(0, 4097):
        check_model(x)

    print("SQRT_SEMANTIC_MODEL=PASS")
    print("SQRT_SEMANTIC_CASES=4107")
    print("SQRT_LOW_LEVEL_STATUS=ASSUMPTION_EXPLICIT")


if __name__ == "__main__":
    main()
