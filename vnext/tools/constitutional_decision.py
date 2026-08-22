#!/usr/bin/env python3
"""مقيّم قرار حتمي لقواعد UORI الدستورية الخمس."""
from __future__ import annotations

from typing import Any


class AbstentionRequired(ValueError):
    """يمثل القاعدة الخامسة: الامتناع عند غياب الدليل الكافي."""


def decide(evidence: dict[str, Any]) -> dict[str, Any]:
    """يعيد المسار المسموح فقط وفق حقائق صريحة قابلة للتدقيق."""
    if evidence.get("domain_satisfied") is True and evidence.get("error_acceptable") is True:
        return {"mode": "DETERMINISTIC", "rule": 1, "reason": "المجال مستوفٍ وحد الخطأ مقبول"}
    if evidence.get("bounds_guaranteed") is True:
        return {"mode": "INTERVAL", "rule": 2, "reason": "الحدود مضمونة"}
    if evidence.get("data_sufficient") is True and evidence.get("calibrated") is True:
        return {"mode": "PROBABILISTIC", "rule": 3, "reason": "البيانات كافية والمعايرة مثبتة"}
    if evidence.get("hypothesis_only") is True:
        return {"mode": "AI_HYPOTHESIS", "rule": 4, "reason": "اقتراح فرضية أو شرح لا إثبات"}
    raise AbstentionRequired("امتناع: لا يوجد دليل كافٍ وفق القاعدة الخامسة")
