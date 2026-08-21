from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from hardware_probe import classify


def main() -> None:
    virtual = classify("x86_64", "kvm", "avx2")
    assert virtual["execution_class"] == "VIRTUALIZED"
    assert virtual["hardware_proof"] is False
    native = classify("x86_64", "", "sse2")
    assert native["execution_class"] == "NATIVE_CANDIDATE"
    unknown = classify("mips", "", "")
    assert unknown["execution_class"] == "INSUFFICIENT-EVIDENCE"
    print("VNEXT_HARDWARE_CLASSIFICATION=PASS")
    print("VNEXT_HARDWARE_ABSTENTION=PASS")
    print("VNEXT_NO_HARDWARE_OVERCLAIM=PASS")


if __name__ == "__main__":
    main()
