"""بوابة قبول WAT قبل التشغيل في بيئة عزل.

لا تنفذ WAT ولا تحوله إلى WASM؛ وظيفتها الفحص والقبول أو الامتناع فقط.
"""
from __future__ import annotations

import hashlib
import re
from dataclasses import dataclass


class WasmAdmissionError(ValueError):
    pass


@dataclass(frozen=True)
class WasmAdmission:
    accepted: bool
    fingerprint: str
    imports: tuple[str, ...]
    reason: str


_ALLOWED_IMPORTS = {"print_i64", "print_string"}
_IMPORT_RE = re.compile(r'\(import\s+"env"\s+"([A-Za-z0-9_]+)"')
_FORBIDDEN = ("memory.grow", "memory.copy", "table.grow", "call_indirect", "shared")


def admit_wat(wat: str, *, max_bytes: int = 256_000, max_imports: int = 8) -> WasmAdmission:
    if not isinstance(wat, str) or not wat.strip():
        raise WasmAdmissionError("ناتج WAT فارغ")
    raw = wat.encode("utf-8")
    digest = hashlib.sha256(raw).hexdigest()
    if len(raw) > max_bytes:
        return WasmAdmission(False, digest, (), "الحجم يتجاوز الحد")
    if not wat.lstrip().startswith("(module"):
        return WasmAdmission(False, digest, (), "الجذر ليس module")
    imports = tuple(_IMPORT_RE.findall(wat))
    if len(imports) > max_imports:
        return WasmAdmission(False, digest, imports, "عدد الاستيرادات يتجاوز الحد")
    unknown = sorted(set(imports) - _ALLOWED_IMPORTS)
    if unknown:
        return WasmAdmission(False, digest, imports, "استيراد غير مسموح: " + ",".join(unknown))
    for token in _FORBIDDEN:
        if token in wat:
            return WasmAdmission(False, digest, imports, "تعليمة غير معزولة: " + token)
    return WasmAdmission(True, digest, imports, "مقبول للفحص التنفيذي اللاحق")
