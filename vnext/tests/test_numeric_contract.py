from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from numeric_contract import NumericAbstention, SCALE, add_q32, interval_add, interval_mul


def main() -> None:
    assert add_q32(1, 2) == 3
    assert interval_add((1, 2), (3, 4)) == (4, 6)
    one = SCALE
    assert interval_mul((one, one), (one, one)) == (one, one)
    try:
        interval_add((2, 1), (0, 1))
    except NumericAbstention:
        pass
    else:
        raise AssertionError("يجب رفض الفترية غير المرتبة")
    try:
        add_q32((1 << 63) - 1, 1)
    except NumericAbstention:
        pass
    else:
        raise AssertionError("يجب رفض تجاوز Q32.32")
    print("VNEXT_Q32_ADD=PASS")
    print("VNEXT_INTERVAL_BOUNDS=PASS")
    print("VNEXT_NUMERIC_ABSTENTION=PASS")


if __name__ == "__main__":
    main()
