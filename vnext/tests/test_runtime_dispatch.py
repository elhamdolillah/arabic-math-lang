from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from abi_contract import lower_to_abi
from runtime_dispatch import RuntimeAbstention, dispatch


def main() -> None:
    packet = lower_to_abi(({"op": "print", "value": "اختبار العتاد", "line": 1},))
    result = dispatch(packet, "1" * 64)
    assert result["result"]["status"] == "success"
    assert result["result"]["mode"] == "DETERMINISTIC"
    assert result["result"]["output"] == "اختبار العتاد\n"
    assert len(result["evidence_chain"]["chain_hash"]) == 64
    invalid = dict(packet)
    invalid["operations"] = [{"opcode": "KERNEL_WRITE", "argument": "x", "line": 1}]
    from abi_contract import sha256_hex
    invalid["content_hash"] = sha256_hex({"abi_version": invalid["abi_version"], "operations": invalid["operations"]})
    try:
        dispatch(invalid, "1" * 64)
    except RuntimeAbstention:
        pass
    else:
        raise AssertionError("يجب الامتناع عن العملية غير المدعومة")
    print("VNEXT_RUNTIME_DISPATCH=PASS")
    print("VNEXT_RUNTIME_OUTPUT=PASS")
    print("VNEXT_RUNTIME_ABSTENTION=PASS")


if __name__ == "__main__":
    main()
