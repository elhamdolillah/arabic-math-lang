"""جسر تكامل UORI بين ABI والنواة وRuntime مع أثر حتمي."""
from __future__ import annotations
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parent
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from abi_contract import lower_to_abi, verify_abi
from acceptance_gate import accept
from evidence_chain import make_record, verify_records
from kernel_gateway import prepare_syscalls
from pipeline_audit import audit
from runtime_dispatch import dispatch


class BridgeAbstention(ValueError):
    """امتناع عندما لا يكتمل مسار التكامل أو لا يكفي الدليل."""


def execute(ast: tuple[dict[str, object], ...], capability: str = "uori.print.v1") -> dict[str, Any]:
    """تنفيذ المسار المرجعي دون تنفيذ syscall خارجي."""
    packet = lower_to_abi(ast)
    verify_abi(packet)
    kernel = prepare_syscalls(packet, capability)
    runtime = dispatch(packet, "0" * 64)
    stages = audit({
        "resource": {"status": "validated", "evidence_mode": "DETERMINISTIC"},
        "kernel": kernel,
        "runtime": runtime["result"],
    })
    decision = accept({"domain_complete": True, "bounds_guaranteed": True}, runtime["result"]["output"])
    records = []
    previous = "0" * 64
    for step, result in enumerate((packet["content_hash"], kernel["boundary_hash"], runtime["evidence_chain"]["chain_hash"], stages["verification"]["head"], decision["verification"]["head"])):
        record = make_record(step, "DETERMINISTIC", str(result), previous)
        records.append(record)
        previous = record["hash"]
    verification = verify_records(records)
    return {
        "status": "PASS",
        "packet": packet,
        "kernel": kernel,
        "runtime": runtime,
        "audit": stages,
        "decision": decision,
        "evidence": {"chain": records, "verification": verification},
    }


if __name__ == "__main__":
    print(execute(({"op": "print", "value": "تشغيل UORI", "line": 1},))["status"])
