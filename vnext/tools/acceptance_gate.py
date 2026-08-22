"""بوابة قبول UORI: قرار دستوري + تحقق عددي + أثر حتمي."""
from __future__ import annotations

import sys
from pathlib import Path
from typing import Any

sys.path.insert(0, str(Path(__file__).resolve().parent))

from constitutional_decision import AbstentionRequired, decide
from evidence_chain import make_record, verify_records


def accept(evidence: dict[str, Any], result: str) -> dict[str, Any]:
    decision = decide(evidence)
    records = []
    previous = "0" * 64
    for step, value in enumerate((decision["mode"], result)):
        record = make_record(step, decision["mode"], value, previous)
        records.append(record)
        previous = record["hash"]
    verification = verify_records(records)
    return {"decision": decision, "evidence": records, "verification": verification}


def abstain(evidence: dict[str, Any], result: str) -> dict[str, Any]:
    try:
        accept(evidence, result)
    except AbstentionRequired as error:
        return {"status": "ABSTAIN", "reason": str(error)}
    raise AssertionError("كان يجب تطبيق الامتناع")
