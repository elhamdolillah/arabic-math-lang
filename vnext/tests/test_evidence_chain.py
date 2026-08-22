from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from evidence_chain import EvidenceChainError, make_record, verify_records


def main() -> None:
    first = make_record(0, "DETERMINISTIC", "قبول", "0" * 64)
    second = make_record(1, "INSUFFICIENT-EVIDENCE", "امتناع", first["hash"])
    assert verify_records([first, second])["length"] == 2

    tampered = [dict(first), dict(second)]
    tampered[1]["result"] = "قبول"
    try:
        verify_records(tampered)
    except EvidenceChainError:
        pass
    else:
        raise AssertionError("يجب رفض السجل المعدل")

    reordered = [second, first]
    try:
        verify_records(reordered)
    except EvidenceChainError:
        pass
    else:
        raise AssertionError("يجب رفض إعادة الترتيب")

    print("VNEXT_EVIDENCE_CHAIN=PASS")
    print("VNEXT_EVIDENCE_TAMPER_REJECTION=PASS")
    print("VNEXT_EVIDENCE_ORDER_REJECTION=PASS")


if __name__ == "__main__":
    main()
