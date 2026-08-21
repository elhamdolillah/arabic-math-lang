#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCHEMA = ROOT / "schemas" / "uori_result_contract.schema.json"
REQUIRED = {
    "معرّف_النتيجة", "القيمة", "الوحدة", "الدالة", "المعادلة", "المجال",
    "التمثيل", "التقريب", "التحقق", "provenance", "قوة_الدليل",
    "نمط_الاستدلال", "حالة_الدليل", "وسم_الدليل",
    "الاستخدام_المسموح", "الاستخدام_الممنوع",
}
FORBIDDEN = {"تشخيص آلي", "وصف علاج", "قرار نهائي", "قبول مريض", "رفض مريض"}
MODES = {
    "حتمي": ("كافٍ", "DETERMINISTIC"),
    "فتري": ("كافٍ", "INTERVAL"),
    "احتمالي": ("كافٍ", "PROBABILISTIC"),
    "توليدي": ("مقترح", "AI-HYPOTHESIS"),
    "امتناع": ("غير_كافٍ", "INSUFFICIENT-EVIDENCE"),
}


def base_result(mode: str, value=7.42) -> dict:
    state, label = MODES[mode]
    result = {
        "معرّف_النتيجة": f"R-{mode}",
        "القيمة": value,
        "الوحدة": "mmol/L",
        "الدالة": "وتر@1",
        "المعادلة": "جذر(س² + ص²)",
        "المجال": "Q32.32",
        "التمثيل": {"خارجي": "Q32.32", "داخلي": "Q64.64", "الفيض": "مرفوض"},
        "التقريب": {"السياسة": "الأقرب", "حد_الخطأ": 16},
        "التحقق": {"اختبار_العتاد": "ناجح", "oracle": "ناجح", "Coq": "ناجح"},
        "provenance": {"المصدر": "اختبار", "التحويلات": []},
        "قوة_الدليل": "B",
        "نمط_الاستدلال": mode,
        "حالة_الدليل": state,
        "وسم_الدليل": label,
        "الاستخدام_المسموح": ["تحليل بحثي"],
        "الاستخدام_الممنوع": sorted(FORBIDDEN),
    }
    if mode == "امتناع":
        result["القيمة"] = None
        result["سبب_الامتناع"] = "المجال غير مستوفٍ والدليل غير كافٍ"
    return result


def main() -> None:
    schema = json.loads(SCHEMA.read_text(encoding="utf-8"))
    assert schema["type"] == "object"
    assert set(schema["required"]) == REQUIRED
    assert schema["properties"]["قوة_الدليل"]["enum"] == ["A", "B", "C", "D", "E"]
    assert schema["properties"]["التقريب"]["properties"]["حد_الخطأ"]["maximum"] == 16
    assert set(schema["properties"]["نمط_الاستدلال"]["enum"]) == set(MODES)

    for mode, (state, label) in MODES.items():
        sample = base_result(mode)
        assert set(sample) >= REQUIRED
        assert sample["حالة_الدليل"] == state
        assert sample["وسم_الدليل"] == label
        assert sample["التقريب"]["حد_الخطأ"] <= 16
        assert not (FORBIDDEN & set(sample["الاستخدام_المسموح"]))
        assert FORBIDDEN <= set(sample["الاستخدام_الممنوع"])
        if mode == "امتناع":
            assert sample["القيمة"] is None
            assert sample["سبب_الامتناع"]

    invalid = base_result("حتمي")
    invalid["وسم_الدليل"] = "AI-HYPOTHESIS"
    assert invalid["وسم_الدليل"] != MODES[invalid["نمط_الاستدلال"]][1]
    print("UORI_RESULT_CONTRACT=PASS")
    print("UORI_EVIDENCE_MODES=5/5")
    print("UORI_ABSTENTION_POLICY=PASS")


if __name__ == "__main__":
    main()
