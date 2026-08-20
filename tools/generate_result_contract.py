#!/usr/bin/env python3
"""توليد عقد نتيجة UORI من مواصفة دالة؛ لا يستبدل مراجعة Coq أو التحقق العتادي."""
import json
import sys
from pathlib import Path


def generate(spec_path: Path) -> dict:
    spec = json.loads(spec_path.read_text(encoding="utf-8"))
    return {
        "معرّف_النتيجة": "TEMPLATE-" + spec["المعرّف"],
        "القيمة": None,
        "الوحدة": "وحدة_الناتج",
        "الدالة": f'{spec["الاسم_العربي"]}@1',
        "المعادلة": spec["المعادلة"],
        "المجال": spec["المجال"]["النوع"],
        "التمثيل": spec["التمثيل"],
        "التقريب": spec["التقريب"],
        "التحقق": {
            "اختبار_العتاد": "مطلوب",
            "oracle": spec["التحقق"]["oracle"],
            "Coq": spec["التحقق"]["البرهان"],
            "ربط_Assembly": "مراجعة مطلوبة",
        },
        "provenance": {"المصدر": "مطلوب", "التحويلات": []},
        "قوة_الدليل": spec["عقد_الأدلة"]["قوة_الدليل_الافتراضية"] if spec["عقد_الأدلة"]["قوة_الدليل_الافتراضية"] in {"A", "B", "C", "D", "E"} else "E",
        "الاستخدام_المسموح": spec["عقد_الأدلة"]["الاستخدام_المسموح"],
        "الاستخدام_الممنوع": spec["عقد_الأدلة"]["الاستخدام_الممنوع"],
    }


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("الاستخدام: generate_result_contract.py specs/functions/watar.json")
    result = generate(Path(sys.argv[1]))
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
