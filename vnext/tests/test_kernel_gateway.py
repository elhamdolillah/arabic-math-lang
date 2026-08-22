from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "vnext" / "tools"))

from abi_contract import lower_to_abi, sha256_hex
from kernel_gateway import KernelBoundaryError, prepare_syscalls


def main() -> None:
    packet = lower_to_abi(({"op": "print", "value": "نواة UORI", "line": 1},))
    prepared = prepare_syscalls(packet, "uori.print.v1")
    assert prepared["calls"][0]["syscall"] == "SYS_PRINT_UTF8"
    assert prepared["kernel_execution"] is False
    assert len(prepared["boundary_hash"]) == 64
    try:
        prepare_syscalls(packet, "uori.unknown.v1")
    except KernelBoundaryError:
        pass
    else:
        raise AssertionError("يجب رفض capability غير المعروفة")
    invalid = dict(packet)
    invalid["operations"] = [{"opcode": "SYS_MMAP", "argument": "x", "line": 1}]
    invalid["content_hash"] = sha256_hex({"abi_version": invalid["abi_version"], "operations": invalid["operations"]})
    try:
        prepare_syscalls(invalid, "uori.print.v1")
    except KernelBoundaryError:
        pass
    else:
        raise AssertionError("يجب رفض syscall غير المسموح")
    print("VNEXT_KERNEL_GATEWAY=PASS")
    print("VNEXT_CAPABILITY_BOUNDARY=PASS")
    print("VNEXT_SYSCALL_ABSTENTION=PASS")


if __name__ == "__main__":
    main()
