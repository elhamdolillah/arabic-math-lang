from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))

from vnext.tools.abi_contract import ABIError, chain_step, lower_to_abi, verify_abi


def main() -> None:
    ast = ({"op": "print", "value": "مرحبا UORI", "line": 1},)
    packet = lower_to_abi(ast)
    verify_abi(packet)
    assert packet["abi_version"] == "uori-abi-v1"
    assert packet["evidence_mode"] == "DETERMINISTIC"
    step = chain_step("0" * 64, packet)
    assert len(step["chain_hash"]) == 64
    tampered = dict(packet)
    tampered["operations"] = [{"opcode": "SYS_EXIT", "argument": "x", "line": 1}]
    try:
        verify_abi(tampered)
    except ABIError:
        pass
    else:
        raise AssertionError("يجب الامتناع عن opcode غير مدعوم")
    print("VNEXT_ABI_LOWERING=PASS")
    print("VNEXT_ABI_HASH=PASS")
    print("VNEXT_ABI_CHAIN=PASS")
    print("VNEXT_ABI_ABSTENTION=PASS")


if __name__ == "__main__":
    main()
