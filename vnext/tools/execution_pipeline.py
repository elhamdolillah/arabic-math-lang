#!/usr/bin/env python3
"""مسار UORI المتكامل: مورد -> حدود Kernel -> Runtime."""
from __future__ import annotations

from typing import Any

from kernel_gateway import prepare_syscalls
from resource_contract import admit
from runtime_dispatch import dispatch


def execute(packet: dict[str, Any], capability: str, previous_hash: str) -> dict[str, Any]:
    admission = admit(packet)
    boundary = prepare_syscalls(packet, capability)
    runtime = dispatch(packet, previous_hash)
    return {
        "admission": admission,
        "boundary": boundary,
        "runtime": runtime,
        "evidence_mode": "DETERMINISTIC",
        "formal_status": "UNPROVEN",
        "hardware_status": "NOT_ASSERTED",
    }
