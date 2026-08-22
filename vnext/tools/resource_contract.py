#!/usr/bin/env python3
"""حدود موارد حتمية لمسار ABI قبل التنفيذ."""
from __future__ import annotations

from typing import Any

from abi_contract import ABIError, verify_abi

MAX_OPERATIONS = 1024
MAX_ARGUMENT_BYTES = 4096


class ResourceAbstention(ABIError):
    """امتناع بسبب تجاوز مورد أو غياب دليل كافٍ."""


def admit(packet: dict[str, Any]) -> dict[str, int | str]:
    try:
        verify_abi(packet)
    except ABIError as error:
        raise ResourceAbstention(str(error)) from error
    operations = packet["operations"]
    if len(operations) > MAX_OPERATIONS:
        raise ResourceAbstention("امتناع: تجاوز عدد العمليات الحد المسموح")
    total_bytes = sum(len(str(item["argument"]).encode("utf-8")) for item in operations)
    if total_bytes > MAX_ARGUMENT_BYTES:
        raise ResourceAbstention("امتناع: تجاوز حجم الوسائط الحد المسموح")
    return {
        "status": "admitted",
        "operations": len(operations),
        "argument_bytes": total_bytes,
        "evidence_mode": "DETERMINISTIC",
    }
