from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from acceptance_gate import accept, abstain


def main() -> None:
    accepted = accept({"bounds_guaranteed": True}, "interval-result")
    assert accepted["decision"]["mode"] == "INTERVAL"
    assert accepted["verification"]["valid"] is True
    refused = abstain({}, "unknown-result")
    assert refused["status"] == "ABSTAIN"
    print("VNEXT_ACCEPTANCE_INTERVAL=PASS")
    print("VNEXT_ACCEPTANCE_ABSTENTION=PASS")


if __name__ == "__main__":
    main()
