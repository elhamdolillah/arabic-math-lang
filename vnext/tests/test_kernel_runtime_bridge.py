from __future__ import annotations
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from kernel_runtime_bridge import execute


def main() -> None:
    result = execute(({"op": "print", "value": "اختبار التكامل", "line": 1},))
    assert result["status"] == "PASS"
    assert result["kernel"]["kernel_execution"] is False
    assert result["runtime"]["result"]["output"] == "اختبار التكامل\n"
    assert result["audit"]["verification"]["valid"] is True
    assert result["decision"]["decision"]["mode"] == "INTERVAL"
    assert result["evidence"]["verification"]["valid"] is True
    assert result["evidence"]["verification"]["length"] == 5
    print("VNEXT_KERNEL_RUNTIME_BRIDGE=PASS")
    print("VNEXT_INTEGRATED_EVIDENCE=PASS")


if __name__ == "__main__":
    main()
