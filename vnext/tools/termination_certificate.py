"""تحقق حتمي من شهادات ترتيب العودية.

هذه الطبقة تتحقق من شهادة مقدمة؛ لا تدّعي تركيب برهان عام لكل برنامج.
"""
from __future__ import annotations
import hashlib
import json
from dataclasses import dataclass
from typing import Any

@dataclass(frozen=True)
class CertificateResult:
    accepted: bool
    reason: str
    fingerprint: str


def _canonical(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"))


def _less(new: Any, old: Any, kind: str) -> bool:
    if kind == "natural":
        return isinstance(new, int) and isinstance(old, int) and 0 <= new < old
    if kind == "lexicographic":
        return isinstance(new, list) and isinstance(old, list) and tuple(new) < tuple(old)
    if kind == "multiset":
        if not isinstance(new, list) or not isinstance(old, list):
            return False
        return sorted(new) < sorted(old)
    return False


def verify_certificate(certificate: dict[str, Any]) -> CertificateResult:
    raw = _canonical(certificate)
    fingerprint = hashlib.sha256(raw.encode("utf-8")).hexdigest()
    kind = certificate.get("kind")
    transitions = certificate.get("transitions")
    if kind not in {"natural", "lexicographic", "multiset"}:
        return CertificateResult(False, "unsupported_ranking_kind", fingerprint)
    if not isinstance(transitions, list) or not transitions:
        return CertificateResult(False, "missing_transitions", fingerprint)
    for transition in transitions:
        if not isinstance(transition, dict):
            return CertificateResult(False, "malformed_transition", fingerprint)
        if not _less(transition.get("new"), transition.get("old"), kind):
            return CertificateResult(False, "ranking_not_decreasing", fingerprint)
    return CertificateResult(True, "ranking_decreases_on_all_edges", fingerprint)
