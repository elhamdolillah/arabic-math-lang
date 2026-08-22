#!/usr/bin/env python3
"""بوابة Kernel مرجعية بين ABI وواجهة syscall الآمنة في UORI."""
from __future__ import annotations

import hashlib
import json
from typing import Any

from abi_contract import ABIError, verify_abi


ALLOWED_SYSCALLS = frozenset({"SYS_PRINT_UTF8"})


class KernelBoundaryError(ABIError):
    """رفض عبور حدود النواة عند نقص الدليل أو الصلاحية."""


def _hash(value: object) -> str:
    raw = json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(raw).hexdigest()


def prepare_syscalls(packet: dict[str, Any], capability: str) -> dict[str, Any]:
    """تحضير syscalls فقط؛ لا ينفذ امتيازات النواة فعلياً."""
    try:
        verify_abi(packet)
    except ABIError as error:
        raise KernelBoundaryError(str(error)) from error
    if capability != "uori.print.v1":
        raise KernelBoundaryError("امتناع: capability غير معروفة")
    calls = []
    for index, operation in enumerate(packet["operations"]):
        if operation["opcode"] not in ALLOWED_SYSCALLS:
            raise KernelBoundaryError("امتناع: syscall غير مسموح")
        calls.append({"sequence": index, "syscall": operation["opcode"], "argument": operation["argument"]})
    body = {"capability": capability, "calls": calls, "source_packet_hash": packet["content_hash"]}
    return {**body, "boundary_hash": _hash(body), "evidence_mode": "DETERMINISTIC", "kernel_execution": False}
