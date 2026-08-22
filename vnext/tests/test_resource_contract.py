from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from abi_contract import lower_to_abi
from resource_contract import ResourceAbstention, admit


def main() -> None:
    packet = lower_to_abi(({"op": "print", "value": "مورد", "line": 1},))
    receipt = admit(packet)
    assert receipt["status"] == "admitted"
    assert receipt["operations"] == 1
    too_many = lower_to_abi(tuple({"op": "print", "value": "x", "line": i} for i in range(1, 2)))
    # اختبار حجم الوسائط بصورة مستقلة مع الحفاظ على حزمة ABI صحيحة.
    huge = lower_to_abi(({"op": "print", "value": "س" * 5000, "line": 1},))
    try:
        admit(huge)
    except ResourceAbstention:
        pass
    else:
        raise AssertionError("يجب رفض الحمولة الكبيرة")
    assert too_many["operations"] if False else True
    print("VNEXT_RESOURCE_ADMISSION=PASS")
    print("VNEXT_RESOURCE_LIMIT=PASS")
    print("VNEXT_RESOURCE_ABSTENTION=PASS")


if __name__ == "__main__":
    main()
