#!/usr/bin/env python3
"""توليد عقود نتيجة UORI؛ لا يستبدل مراجعة Coq أو التحقق العتادي."""
import json
import sys
from pathlib import Path


def _contract(spec: dict) -> dict:
    evidence = spec.get("عقد_الأدلة", {})
    verification = spec.get("التحقق", {})
    proof = spec.get("Coq") or verification.get("البرهان")
    oracle = spec.get("oracle") or verification.get("oracle")
    implementation = spec.get("التنفيذ", "مطلوب")
    rounding = spec.get("التقريب", {})
    error_bound = spec.get("حد_الخطأ", rounding.get("حد_الخطأ", 16))
    representation = spec.get("التمثيل", spec.get("التمثيل_الثابت", "مطلوب"))
    domain = spec.get("المجال", "مطلوب")
    if isinstance(domain, dict):
        domain = domain.get("النوع", "مطلوب")
    return {
        "معرّف_النتيجة": "TEMPLATE-" + spec["المعرّف"],
        "القيمة": None,
        "الوحدة": "وحدة_الناتج",
        "الدالة": f'{spec["الاسم_العربي"]}@1',
        "المعادلة": spec["المعادلة"],
        "المجال": domain,
        "التمثيل": representation,
        "التقريب": {"السياسة": rounding.get("السياسة", "الأقرب بعد الإسقاط"), "حد_الخطأ": error_bound},
        "التحقق": {
            "اختبار_العتاد": spec.get("حالة_العتاد", "مطلوب"),
            "oracle": oracle,
            "Coq": proof,
            "التنفيذ": implementation,
            "ربط_Assembly": "مراجعة مطلوبة",
        },
        "provenance": {"المصدر": "مطلوب", "التحويلات": []},
        "قوة_الدليل": evidence.get("قوة_الدليل_الافتراضية", "E") if evidence.get("قوة_الدليل_الافتراضية") in {"A", "B", "C", "D", "E"} else "E",
        "الاستخدام_المسموح": evidence.get("الاستخدام_المسموح", ["تحليل بحثي"]),
        "الاستخدام_الممنوع": evidence.get("الاستخدام_الممنوع", ["تشخيص آلي", "وصف علاج", "قرار سريري نهائي"]),
    }


def load_specs(path: Path) -> list[dict]:
    data = json.loads(path.read_text(encoding="utf-8"))
    return data["الدوال"] if "الدوال" in data else [data]


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("الاستخدام: generate_result_contract.py specs/functions/catalog.json")
    specs = load_specs(Path(sys.argv[1]))
    output = [_contract(spec) for spec in specs]
    print(json.dumps(output[0] if len(output) == 1 else output, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
