#!/usr/bin/env python3
"""تحقق مستقل من عقد نتيجة UORI؛ يرفض البنية أو الدليل غير المتسق."""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCHEMA_PATH = ROOT / "schemas" / "uori_result_contract.schema.json"
REQUIRED = {
    "معرّف_النتيجة", "القيمة", "الوحدة", "الدالة", "المعادلة", "المجال",
    "التمثيل", "التقريب", "التحقق", "provenance", "قوة_الدليل",
    "نمط_الاستدلال", "حالة_الدليل", "وسم_الدليل",
    "الاستخدام_المسموح", "الاستخدام_الممنوع",
}
MODES = {
    "حتمي": ("كافٍ", "DETERMINISTIC"),
    "فتري": ("كافٍ", "INTERVAL"),
    "احتمالي": ("كافٍ", "PROBABILISTIC"),
    "توليدي": (None, "AI-HYPOTHESIS"),
    "امتناع": ("غير_كافٍ", "INSUFFICIENT-EVIDENCE"),
}
FORBIDDEN = {"تشخيص آلي", "وصف علاج", "قرار سريري نهائي"}


def fail(message: str) -> None:
    raise ValueError(message)


def validate(contract: dict) -> None:
    if not isinstance(contract, dict):
        fail("يجب أن يكون العقد كائناً JSON")
    missing = REQUIRED - contract.keys()
    if missing:
        fail(f"حقول إلزامية مفقودة: {sorted(missing)}")
    schema_keys = {
        "معرّف_النتيجة", "القيمة", "الوحدة", "الدالة", "المعادلة", "المجال",
        "التمثيل", "التقريب", "التحقق", "provenance", "قوة_الدليل",
        "نمط_الاستدلال", "حالة_الدليل", "وسم_الدليل", "سبب_الامتناع",
        "الاستخدام_المسموح", "الاستخدام_الممنوع",
    }
    extras = set(contract) - schema_keys
    if extras:
        fail(f"حقول غير معروفة: {sorted(extras)}")
    for key in ("معرّف_النتيجة", "الوحدة", "الدالة", "المعادلة", "المجال"):
        if not isinstance(contract[key], str) or not contract[key]:
            fail(f"الحقل {key} يجب أن يكون نصاً غير فارغ")
    for key in ("الاستخدام_المسموح", "الاستخدام_الممنوع"):
        if not isinstance(contract[key], list) or not all(isinstance(x, str) for x in contract[key]):
            fail(f"الحقل {key} يجب أن يكون قائمة نصوص")
    if not isinstance(contract["التمثيل"], dict) or not {"خارجي", "داخلي", "الفيض"} <= contract["التمثيل"].keys():
        fail("التمثيل لا يستوفي الحقول المطلوبة")
    if not isinstance(contract["التقريب"], dict):
        fail("التقريب يجب أن يكون كائناً")
    error = contract["التقريب"].get("حد_الخطأ")
    if not isinstance(error, int) or not 0 <= error <= 16:
        fail("حد الخطأ يجب أن يكون عدداً صحيحاً بين 0 و16")
    if not isinstance(contract["التحقق"], dict) or not {"اختبار_العتاد", "oracle", "Coq"} <= contract["التحقق"].keys():
        fail("التحقق لا يستوفي الحقول المطلوبة")
    if not isinstance(contract["provenance"], dict) or not {"المصدر", "التحويلات"} <= contract["provenance"].keys():
        fail("provenance لا يستوفي الحقول المطلوبة")
    if contract["قوة_الدليل"] not in {"A", "B", "C", "D", "E"}:
        fail("قوة الدليل غير صالحة")

    mode = contract["نمط_الاستدلال"]
    if mode not in MODES:
        fail("نمط الاستدلال غير صالح")
    state, label = MODES[mode]
    if mode == "توليدي":
        if contract["حالة_الدليل"] not in {"غير_كافٍ", "مقترح"}:
            fail("النمط التوليدي يتطلب حالة مقترح أو غير كافٍ")
    elif contract["حالة_الدليل"] != state:
        fail(f"حالة الدليل لا توافق النمط {mode}")
    if contract["وسم_الدليل"] != label:
        fail(f"وسم الدليل لا يوافق النمط {mode}")
    if mode == "امتناع":
        if not isinstance(contract.get("سبب_الامتناع"), str) or not contract["سبب_الامتناع"]:
            fail("سبب الامتناع إلزامي")
        if contract["القيمة"] is not None:
            fail("قيمة الامتناع يجب أن تكون null")
    if FORBIDDEN & set(contract["الاستخدام_المسموح"]):
        fail("الاستخدام المسموح يتضمن غرضاً محظوراً")
    if not FORBIDDEN <= set(contract["الاستخدام_الممنوع"]):
        fail("قائمة الاستخدام الممنوع لا تغطي القيود الطبية المطلوبة")


def main() -> int:
    if len(sys.argv) != 2:
        print("الاستخدام: validate_result_contract.py contract.json", file=sys.stderr)
        return 2
    try:
        contract = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
        json.loads(SCHEMA_PATH.read_text(encoding="utf-8"))
        validate(contract)
    except (OSError, json.JSONDecodeError, ValueError) as exc:
        print(f"UORI_RESULT_CONTRACT=REJECTED: {exc}", file=sys.stderr)
        return 1
    print("UORI_RESULT_CONTRACT=VALID")
    print(f"UORI_EVIDENCE_MODE={contract['نمط_الاستدلال']}")
    print(f"UORI_EVIDENCE_LABEL={contract['وسم_الدليل']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
