#!/usr/bin/env python3
"""توليد عقود نتيجة UORI؛ لا يستبدل مراجعة Coq أو التحقق العتادي."""
import json
import sys
from pathlib import Path


ALLOWED_PROOF_LEVELS = {"A", "B", "C", "D", "E"}
EVIDENCE_MODES = {
    "حتمي": ("كافٍ", "DETERMINISTIC"),
    "فتري": ("كافٍ", "INTERVAL"),
    "احتمالي": ("كافٍ", "PROBABILISTIC"),
    "توليدي": ("مقترح", "AI-HYPOTHESIS"),
    "امتناع": ("غير_كافٍ", "INSUFFICIENT-EVIDENCE"),
}


def _evidence_policy(spec: dict, rounding: dict, verification: dict, evidence: dict) -> tuple[str, str, str, str | None]:
    """تحديد نمط النتيجة؛ الغياب الصريح للدليل يؤدي إلى الامتناع الآمن."""
    mode = _first(spec, "نمط_الاستدلال", default=evidence.get("نمط_الاستدلال"))
    explicit_state = _first(spec, "حالة_الدليل", default=evidence.get("حالة_الدليل"))
    explicit_label = _first(spec, "وسم_الدليل", default=evidence.get("وسم_الدليل"))
    refusal_reason = _first(spec, "سبب_الامتناع", default=evidence.get("سبب_الامتناع"))

    if mode is None:
        mode = "امتناع"
        refusal_reason = refusal_reason or "لم يُصرّح بدليل كافٍ يبرر نتيجة حتمية أو فترية أو احتمالية"
    if mode not in EVIDENCE_MODES:
        raise ValueError(f"نمط استدلال غير معروف: {mode}")

    state, label = EVIDENCE_MODES[mode]
    if explicit_state is not None and explicit_state != state:
        raise ValueError(f"حالة الدليل لا توافق النمط {mode}: {explicit_state} != {state}")
    if explicit_label is not None and explicit_label != label:
        raise ValueError(f"وسم الدليل لا يوافق النمط {mode}: {explicit_label} != {label}")
    if mode == "حتمي" and rounding.get("حد_الخطأ", 16) > 16:
        raise ValueError("لا يجوز اعتماد النمط الحتمي مع حد خطأ أكبر من 16")
    if mode == "امتناع" and not refusal_reason:
        raise ValueError("يجب تسجيل سبب الامتناع")
    return mode, state, label, refusal_reason


def _first(spec: dict, *keys, default=None):
    for key in keys:
        value = spec.get(key)
        if value is not None:
            return value
    return default


def _contract(spec: dict) -> dict:
    semantics = spec.get("الدلالة", {})
    representation_block = spec.get("التمثيل", {})
    evidence = spec.get("عقد_الأدلة", {})
    evidence_block = spec.get("الأدلة", {})
    verification = spec.get("التحقق", {})
    implementation_block = spec.get("التنفيذ_الحالي", {})
    rounding = spec.get("التقريب", {})

    identifier = _first(spec, "المعرّف", "الاسم_التقني", default="غير_معرّف")
    arabic_name = _first(spec, "الاسم_العربي", "الاسم", default="دالة_مجهولة")
    equation = _first(spec, "المعادلة", default=semantics.get("المعادلة", "مطلوب"))
    domain = _first(spec, "المجال", default=semantics.get("الأساس", "مطلوب"))
    if isinstance(domain, dict):
        domain = domain.get("النوع", "مطلوب")

    representation = _first(spec, "التمثيل_الثابت", default=None)
    if representation is None:
        representation = representation_block if representation_block else "مطلوب"
    if isinstance(representation, dict):
        representation = dict(representation)
        representation.setdefault("خارجي", "مطلوب")
        representation.setdefault("داخلي", "مطلوب")
        representation.setdefault("الفيض", "مطلوب")
    else:
        representation = {"خارجي": representation, "داخلي": "مطلوب", "الفيض": "مطلوب"}

    implementation = _first(spec, "التنفيذ", default=None)
    if implementation is None:
        implementation = implementation_block.get("المسار", "مطلوب")

    oracle = _first(spec, "oracle", default=None)
    if oracle is None:
        oracle = evidence_block.get("oracle") or verification.get("oracle")

    proof = _first(spec, "Coq", default=None)
    if proof is None:
        proof = evidence_block.get("coq") or evidence_block.get("Coq") or verification.get("البرهان")

    error_bound = _first(spec, "حد_الخطأ", default=rounding.get("حد_الخطأ", 16))
    proof_level = evidence.get("قوة_الدليل_الافتراضية", "E")
    if proof_level not in ALLOWED_PROOF_LEVELS:
        proof_level = "E"

    allowed = _first(spec, "الاستخدام_المسموح", default=None)
    forbidden = _first(spec, "الاستخدام_الممنوع", default=None)
    usage = spec.get("الاستخدامات", {})
    if allowed is None:
        allowed = usage.get("مسموح", ["تحليل بحثي"])
    if forbidden is None:
        forbidden = usage.get("ممنوع", ["تشخيص آلي", "وصف علاج", "قرار سريري نهائي"])

    evidence_mode, evidence_state, evidence_label, refusal_reason = _evidence_policy(
        spec, rounding, verification, evidence
    )

    contract = {
        "معرّف_النتيجة": "TEMPLATE-" + str(identifier),
        "القيمة": None,
        "الوحدة": "وحدة_الناتج",
        "الدالة": f"{arabic_name}@1",
        "المعادلة": equation,
        "المجال": domain,
        "التمثيل": representation,
        "التقريب": {
            "السياسة": rounding.get("السياسة", rounding.get("الطريقة", "الأقرب بعد الإسقاط")),
            "حد_الخطأ": error_bound,
        },
        "التحقق": {
            "اختبار_العتاد": _first(spec, "حالة_العتاد", default=evidence_block.get("hardware", "مطلوب")),
            "oracle": oracle or "مطلوب",
            "Coq": proof or "مطلوب",
            "التنفيذ": implementation or "مطلوب",
            "ربط_Assembly": evidence_block.get("assembly_relation", "مراجعة مطلوبة"),
        },
        "provenance": {"المصدر": "مطلوب", "التحويلات": []},
        "قوة_الدليل": proof_level,
        "نمط_الاستدلال": evidence_mode,
        "حالة_الدليل": evidence_state,
        "وسم_الدليل": evidence_label,
        "الاستخدام_المسموح": allowed,
        "الاستخدام_الممنوع": forbidden,
    }
    if refusal_reason is not None:
        contract["سبب_الامتناع"] = refusal_reason
    return contract


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

