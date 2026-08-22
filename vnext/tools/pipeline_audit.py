"""تدقيق ترتيب مراحل مسار التنفيذ داخل سلسلة دليل حتمية."""
from __future__ import annotations

from evidence_chain import make_record, verify_records


EXPECTED = ("resource", "kernel", "runtime")


def audit(stage_results: dict) -> dict:
    if tuple(stage_results) != EXPECTED:
        raise ValueError("ترتيب مراحل المسار غير صحيح")
    records = []
    previous = "0" * 64
    for index, stage in enumerate(EXPECTED):
        value = stage_results[stage]
        if not isinstance(value, dict):
            raise ValueError(f"نتيجة مرحلة غير صالحة: {stage}")
        mode = value.get("evidence_mode", "DETERMINISTIC")
        result = value.get("status", value.get("result", "present"))
        record = make_record(index, mode, f"{stage}:{result}", previous)
        records.append(record)
        previous = record["hash"]
    return {"stages": list(EXPECTED), "chain": records, "verification": verify_records(records)}
