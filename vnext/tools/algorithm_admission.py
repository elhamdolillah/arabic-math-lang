"""بوابة قبول مرشحي الخوارزميات وفق أولوية UORI الدستورية."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Mapping


class AdmissionAbstention(ValueError):
    """امتناع عند غياب مرشح مستوفٍ للدليل."""


@dataclass(frozen=True)
class Candidate:
    identity: str
    mode: str
    evidence: Mapping[str, Any]
    artifact_hash: str | None = None


_RANK = {"DETERMINISTIC": 0, "INTERVAL": 1, "PROBABILISTIC": 2}


def _eligible(candidate: Candidate) -> bool:
    e = candidate.evidence
    if candidate.mode == "DETERMINISTIC":
        return all(e.get(k) is True for k in (
            "domain_satisfied", "error_acceptable", "identity_verified",
            "tests_passed", "static_check_passed", "reproducible_build",
            "isolation_ready",
        )) and bool(candidate.artifact_hash)
    if candidate.mode == "INTERVAL":
        return all(e.get(k) is True for k in (
            "bounds_guaranteed", "identity_verified", "tests_passed",
            "static_check_passed", "isolation_ready",
        )) and bool(candidate.artifact_hash)
    if candidate.mode == "PROBABILISTIC":
        return all(e.get(k) is True for k in (
            "data_sufficient", "calibrated", "identity_verified",
            "tests_passed", "isolation_ready",
        )) and bool(candidate.artifact_hash)
    return False


def select(candidates: list[Candidate]) -> dict[str, Any]:
    """يختار أعلى رتبة مستوفية، ويسجل فشل البدائل الأعلى."""
    if not candidates:
        raise AdmissionAbstention("امتناع: قائمة المرشحين فارغة")
    ordered = sorted(candidates, key=lambda c: (_RANK.get(c.mode, 99), c.identity))
    rejected: list[dict[str, str]] = []
    for candidate in ordered:
        if candidate.mode not in _RANK:
            rejected.append({"identity": candidate.identity, "reason": "نمط غير معروف"})
            continue
        if _eligible(candidate):
            return {
                "status": "ACCEPTED",
                "candidate": candidate.identity,
                "mode": candidate.mode,
                "rejected_before_selection": rejected,
                "reason": f"أعلى رتبة مستوفية: {candidate.mode}",
            }
        rejected.append({"identity": candidate.identity, "reason": "شروط القبول غير مستوفاة"})
    raise AdmissionAbstention(f"امتناع: لا يوجد مرشح مستوفٍ؛ الرفض={rejected}")
