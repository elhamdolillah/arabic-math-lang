"""محلل مقيد لمواصفات سجل UORI العربية الرياضية.

لا يستعمل eval أو exec أو استيراداً ديناميكياً. يقرأ حقولاً معروفة فقط،
ويُصدر بيانات وصفية لا تعليمات تنفيذية.
"""
from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path


class RegistrySpecError(ValueError):
    pass


@dataclass(frozen=True)
class ArabicAlgorithmSpec:
    name: str
    algorithm_id: str
    operation: str
    version: int
    input_types: tuple[str, ...]
    output_type: str
    determinism: str
    termination: str
    fuel: int


_ALLOWED_FIELDS = {
    "العملية", "الإصدار", "المدخل", "المخرج", "التصنيف", "الإنهاء", "الوقود"
}


def load_arabic_specs(path: str | Path) -> tuple[ArabicAlgorithmSpec, ...]:
    records: list[dict[str, str]] = []
    current: dict[str, str] | None = None
    for line_number, raw in enumerate(Path(path).read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("خوارزمية ") and ":" in line:
            if current is not None:
                records.append(current)
            label, algorithm_id = line[len("خوارزمية "):].split(":", 1)
            current = {"الاسم": label.strip(), "المعرف": algorithm_id.strip(), "السطر": str(line_number)}
            continue
        if current is None or ":" not in line:
            raise RegistrySpecError(f"سطر غير متوقع: {line_number}")
        field, value = (part.strip() for part in line.split(":", 1))
        if field not in _ALLOWED_FIELDS or field in current:
            raise RegistrySpecError(f"حقل غير مسموح أو مكرر: {line_number}")
        current[field] = value
    if current is not None:
        records.append(current)

    specs: list[ArabicAlgorithmSpec] = []
    for record in records:
        required = {"الاسم", "المعرف", "العملية", "الإصدار", "المدخل", "المخرج", "التصنيف", "الإنهاء", "الوقود"}
        actual_fields = set(record) - {"السطر"}
        if actual_fields - required or required - actual_fields:
            raise RegistrySpecError(f"حقول ناقصة في السطر {record.get('السطر')}")
        try:
            version = int(record["الإصدار"])
            fuel = int(record["الوقود"])
        except ValueError as exc:
            raise RegistrySpecError("الإصدار والوقود يجب أن يكونا عددين صحيحين") from exc
        inputs = tuple(item.strip() for item in record["المدخل"].split("،"))
        if not record["المعرف"].startswith("uori.") or version <= 0 or fuel <= 0:
            raise RegistrySpecError("هوية أو إصدار أو وقود غير صالح")
        if record["التصنيف"] != "حتمي" or record["الإنهاء"] != "مثبت":
            raise RegistrySpecError("المواصفة غير حتمية أو بلا إنهاء مثبت")
        specs.append(ArabicAlgorithmSpec(
            record["الاسم"], record["المعرف"], record["العملية"], version,
            inputs, record["المخرج"], record["التصنيف"], record["الإنهاء"], fuel,
        ))
    if not specs:
        raise RegistrySpecError("السجل العربي فارغ")
    return tuple(specs)
