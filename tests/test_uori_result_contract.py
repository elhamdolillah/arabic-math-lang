#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCHEMA = ROOT / "schemas" / "uori_result_contract.schema.json"

REQUIRED = {
    "معرّف_النتيجة", "القيمة", "الوحدة", "الدالة", "المعادلة", "المجال",
    "التمثيل", "التقريب", "التحقق", "provenance", "قوة_الدليل",
    "الاستخدام_المسموح", "الاستخدام_الممنوع",
}
FORBIDDEN = {"تشخيص آلي", "وصف علاج", "قرار نهائي", "قبول مريض", "رفض مريض"}


def main() -> None:
    schema = json.loads(SCHEMA.read_text(encoding="utf-8"))
    assert schema["type"] == "object"
    assert set(schema["required"]) == REQUIRED
    assert schema["properties"]["قوة_الدليل"]["enum"] == ["A", "B", "C", "D", "E"]
    assert schema["properties"]["التقريب"]["properties"]["حد_الخطأ"]["minimum"] == 0

    sample = {
        "معرّف_النتيجة": "R-test-1",
        "القيمة": 7.42,
        "الوحدة": "mmol/L",
        "الدالة": "وتر@1",
        "المعادلة": "جذر(س² + ص²)",
        "المجال": "Q32.32",
        "التمثيل": {"خارجي": "Q32.32", "داخلي": "Q64.64", "الفيض": "مرفوض"},
        "التقريب": {"السياسة": "الأقرب", "حد_الخطأ": 16},
        "التحقق": {"اختبار_العتاد": "ناجح", "oracle": "ناجح", "Coq": "ناجح"},
        "provenance": {"المصدر": "اختبار", "التحويلات": []},
        "قوة_الدليل": "B",
        "الاستخدام_المسموح": ["تحليل بحثي"],
        "الاستخدام_الممنوع": sorted(FORBIDDEN),
    }
    assert not (FORBIDDEN & set(sample["الاستخدام_المسموح"]))
    assert FORBIDDEN <= set(sample["الاستخدام_الممنوع"])
    assert sample["التقريب"]["حد_الخطأ"] <= 16
    print("UORI_RESULT_CONTRACT=PASS")


if __name__ == "__main__":
    main()
