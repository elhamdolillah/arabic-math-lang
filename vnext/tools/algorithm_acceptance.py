"""بوابة قبول الخوارزمية وفق دستور UORI.

التصويت عامل ترجيح اجتماعي، وليس بديلاً عن فحص السلامة أو التفويض.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable
import hashlib
import json


class AcceptanceAbstention(ValueError):
    """امتناع عند نقص الدليل أو تعارض شروط القبول."""


@dataclass(frozen=True)
class SafetyReport:
    static_check_passed: bool
    termination_proven: bool
    resource_limits_defined: bool
    isolation_ready: bool
    hardware_damage_risk: bool
    confidential_data_exfiltration: bool


@dataclass(frozen=True)
class Vote:
    voter_id: str
    positive: bool


def _votes(votes: Iterable[Vote]) -> tuple[int, int, int, str]:
    unique: dict[str, bool] = {}
    for vote in votes:
        if not vote.voter_id or vote.voter_id in unique:
            continue
        unique[vote.voter_id] = vote.positive
    positive = sum(unique.values())
    negative = len(unique) - positive
    canonical = json.dumps(sorted(unique.items()), ensure_ascii=False, separators=(",", ":")).encode("utf-8")
    digest = hashlib.sha256(canonical).hexdigest()
    return positive, negative, len(unique), digest


def evaluate(safety: SafetyReport, votes: Iterable[Vote], *, minimum_votes: int = 3) -> dict[str, object]:
    """تقييم حتمي: حواجز السلامة أولاً، ثم أغلبية الأصوات الفريدة."""
    positive, negative, total, vote_hash = _votes(votes)
    if safety.hardware_damage_risk:
        return {"status": "REJECTED", "reason": "خطر ضرر العتاد", "positive": positive, "negative": negative, "vote_hash": vote_hash}
    if safety.confidential_data_exfiltration:
        return {"status": "REJECTED", "reason": "خطر تسريب معلومات سرية", "positive": positive, "negative": negative, "vote_hash": vote_hash}
    mandatory = {
        "static_check_passed": safety.static_check_passed,
        "termination_proven": safety.termination_proven,
        "resource_limits_defined": safety.resource_limits_defined,
        "isolation_ready": safety.isolation_ready,
    }
    missing = [name for name, passed in mandatory.items() if not passed]
    if missing:
        return {"status": "ABSTAIN", "reason": "دليل السلامة ناقص", "missing": missing, "positive": positive, "negative": negative, "vote_hash": vote_hash}
    if total < minimum_votes:
        return {"status": "ABSTAIN", "reason": "عدد الأصوات غير كافٍ", "positive": positive, "negative": negative, "total": total, "vote_hash": vote_hash}
    if positive <= negative:
        return {"status": "REJECTED", "reason": "الأغلبية ليست إيجابية", "positive": positive, "negative": negative, "total": total, "vote_hash": vote_hash}
    return {"status": "ACCEPTED_FOR_ADMISSION", "reason": "سلامة مستوفاة وأغلبية إيجابية", "positive": positive, "negative": negative, "total": total, "vote_hash": vote_hash}
