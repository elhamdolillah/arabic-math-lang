from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from abi_contract import lower_to_abi
from execution_pipeline import execute


def main() -> None:
    packet = lower_to_abi(({"op": "print", "value": "UORI 300", "line": 1},))
    report = execute(packet, "uori.print.v1", "0" * 64)
    assert report["admission"]["status"] == "admitted"
    assert report["boundary"]["kernel_execution"] is False
    assert report["runtime"]["result"]["output"] == "UORI 300\n"
    assert report["evidence_mode"] == "DETERMINISTIC"
    assert report["formal_status"] == "UNPROVEN"
    assert report["hardware_status"] == "NOT_ASSERTED"
    print("VNEXT_PIPELINE_ADMISSION=PASS")
    print("VNEXT_PIPELINE_BOUNDARY=PASS")
    print("VNEXT_PIPELINE_RUNTIME=PASS")
    print("VNEXT_PIPELINE_STATUS_SEPARATION=PASS")


if __name__ == "__main__":
    main()
