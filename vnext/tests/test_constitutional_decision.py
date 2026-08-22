from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from constitutional_decision import AbstentionRequired, decide


def main() -> None:
    assert decide({"domain_satisfied": True, "error_acceptable": True})["mode"] == "DETERMINISTIC"
    assert decide({"bounds_guaranteed": True})["mode"] == "INTERVAL"
    assert decide({"data_sufficient": True, "calibrated": True})["mode"] == "PROBABILISTIC"
    assert decide({"hypothesis_only": True})["mode"] == "AI_HYPOTHESIS"
    try:
        decide({})
    except AbstentionRequired:
        pass
    else:
        raise AssertionError("يجب أن يكون الامتناع هو الحالة الافتراضية")
    print("VNEXT_RULES_1_4=PASS")
    print("VNEXT_RULE_5_ABSTENTION=PASS")
    print("VNEXT_CONSTITUTIONAL_DECISION=PASS")


if __name__ == "__main__":
    main()
