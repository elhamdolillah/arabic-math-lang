"""واجهة UORI الأولية: إدخال -> سجل طلب -> قبول -> خطة تنفيذ.

هذه الطبقة لا تنفذ كوداً ولا تستدعي الشبكة أو النظام؛ إنها حدّ واجهة فقط.
"""
from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass


@dataclass(frozen=True)
class UiRequest:
    text: str
    locale: str = "ar"


def submit(request: UiRequest) -> dict[str, object]:
    if not isinstance(request.text, str) or not request.text.strip():
        return {"status": "ABSTAIN", "reason": "الطلب النصي فارغ"}
    if request.locale != "ar":
        return {"status": "ABSTAIN", "reason": "اللغة غير المعتمدة في هذه الطبقة"}
    payload = {"locale": request.locale, "text": " ".join(request.text.split())}
    encoded = json.dumps(payload, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode()
    return {
        "status": "ADMITTED_FOR_ANALYSIS",
        "request_hash": hashlib.sha256(encoded).hexdigest(),
        "next": "LOOKUP_THEN_AUTHORIZE",
        "execution": False,
        "external_side_effects": False,
    }
