from __future__ import annotations
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from replay_validator import replay


def main() -> None:
    result = replay(({"op": "print", "value": "إعادة حتمية", "line": 1},))
    assert result["status"] == "REPLAY_PASS"
    assert result["runs"] == 2
    assert len(result["replay_hash"]) == 64
    assert result["evidence_mode"] == "DETERMINISTIC"
    print("VNEXT_REPLAY_DETERMINISM=PASS")
    print("VNEXT_REPLAY_BOUNDARY=PASS")


if __name__ == "__main__":
    main()
