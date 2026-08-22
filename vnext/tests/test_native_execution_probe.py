from __future__ import annotations
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from native_execution_probe import collect


def main() -> None:
    result = collect()
    assert result["runtime_status"] == "PASS"
    assert result["native_proof"] is False
    assert result["evidence_mode"] == "DETERMINISTIC"
    assert len(result["probe_hash"]) == 64
    assert len(result["runtime_output_sha256"]) == 64
    print("VNEXT_NATIVE_PROBE_EXECUTION=PASS")
    print("VNEXT_NATIVE_PROOF_NOT_OVERCLAIMED=PASS")


if __name__ == "__main__":
    main()
