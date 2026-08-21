#!/usr/bin/env python3
"""منفذ Runtime مرجعي حتمي لحزمة UORI ABI v1."""
from __future__ import annotations

from typing import Any

from abi_contract import ABIError, chain_step, verify_abi


class RuntimeAbstention(ABIError):
    """امتناع صريح عندما لا تكفي الأدلة أو لا تدعم النواة العملية."""


def dispatch(packet: dict[str, Any], previous_hash: str) -> dict[str, Any]:
    try:
        verify_abi(packet)
    except ABIError as error:
        raise RuntimeAbstention(str(error)) from error
    output: list[str] = []
    for operation in packet["operations"]:
        if operation["opcode"] != "SYS_PRINT_UTF8":
            raise RuntimeAbstention("امتناع: العملية غير مدعومة في Runtime v1")
        output.append(operation["argument"])
    result = {
        "status": "success",
        "mode": "DETERMINISTIC",
        "output": "\n".join(output) + ("\n" if output else ""),
        "operations_executed": len(output),
    }
    return {"result": result, "evidence_chain": chain_step(previous_hash, packet)}
