from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from pipeline_audit import audit


def main() -> None:
    result = audit({
        "resource": {"status": "admitted"},
        "kernel": {"status": "prepared"},
        "runtime": {"status": "success"},
    })
    assert result["verification"]["valid"] is True
    assert result["verification"]["length"] == 3
    try:
        audit({
            "kernel": {"status": "prepared"},
            "resource": {"status": "admitted"},
            "runtime": {"status": "success"},
        })
    except ValueError:
        pass
    else:
        raise AssertionError("يجب رفض ترتيب المراحل غير الصحيح")
    print("VNEXT_PIPELINE_AUDIT=PASS")
    print("VNEXT_PIPELINE_ORDER_REJECTION=PASS")


if __name__ == "__main__":
    main()
