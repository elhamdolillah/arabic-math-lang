"""قراءة عقد خطة التنفيذ العربية إلى بيانات ثابتة فقط."""
from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path


class PlanSpecError(ValueError):
    pass


@dataclass(frozen=True)
class ArabicPlanSpec:
    identity: str
    determinism: str
    capability: str
    minimum_memory: int
    minimum_fuel: int
    evidence: str
    failure: str
    source_execution: str


_FIELDS = {
    "خطة_التنفيذ", "التصنيف", "القدرة", "الذاكرة_الدنيا", "الوقود_الأدنى",
    "الدليل_المطلوب", "عند_الفشل", "لا_تنفيذ_مباشر_للمصدر",
}


def load_plan_spec(path: str | Path) -> ArabicPlanSpec:
    values: dict[str, str] = {}
    for line_number, raw in enumerate(Path(path).read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if ":" not in line:
            raise PlanSpecError(f"سطر غير صالح: {line_number}")
        key, value = (part.strip() for part in line.split(":", 1))
        if key not in _FIELDS or key in values:
            raise PlanSpecError(f"حقل غير مسموح أو مكرر: {line_number}")
        values[key] = value
    if set(values) != _FIELDS:
        raise PlanSpecError("مواصفة خطة التنفيذ ناقصة")
    try:
        memory = int(values["الذاكرة_الدنيا"])
        fuel = int(values["الوقود_الأدنى"])
    except ValueError as exc:
        raise PlanSpecError("حدود الموارد يجب أن تكون أعداداً صحيحة") from exc
    if values["التصنيف"] != "حتمي" or values["لا_تنفيذ_مباشر_للمصدر"] != "صحيح":
        raise PlanSpecError("الخطة لا تحقق شرط الحتمية أو فصل المصدر عن التنفيذ")
    if memory <= 0 or fuel <= 0:
        raise PlanSpecError("حدود الموارد غير موجبة")
    return ArabicPlanSpec(
        identity=values["خطة_التنفيذ"],
        determinism=values["التصنيف"],
        capability=values["القدرة"],
        minimum_memory=memory,
        minimum_fuel=fuel,
        evidence=values["الدليل_المطلوب"],
        failure=values["عند_الفشل"],
        source_execution=values["لا_تنفيذ_مباشر_للمصدر"],
    )
