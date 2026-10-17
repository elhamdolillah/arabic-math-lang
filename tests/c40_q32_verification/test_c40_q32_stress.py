"""اختبارات إجهاد حتمية إضافية لـ C40 على Q32.32.

لا تعدّل النواة. تستخدم نفس مسار lexer/parser/compiler/linker الموجود في
 test_c40_reproduction.py، وتفصل بين فرق Q32.32 المطلق والموقّع والنسبي.
القيم الموجبة لا تتجاوز مجال خرج int64 الآمن تقريبًا.
"""
from __future__ import annotations

import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parent
if not (ROOT / "math_complete.py").is_file():
    ROOT = Path(__file__).resolve().parents[2]
LIB = ROOT
LEXICON = ROOT / "lexicon"
for مسار in (LIB, LEXICON):
    if str(مسار) not in sys.path:
        sys.path.insert(0, str(مسار))

import math_complete as النواة  # noqa: E402

مقياس = 1 << 32
حد_الخطأ = 16


@dataclass(frozen=True)
class حالة:
    اسم: str
    دخل_ثابت: int

    @property
    def دخل_حقيقي(self) -> float:
        return self.دخل_ثابت / مقياس

    def مرجع_خام(self, مراجع: dict[int, int]) -> int:
        return مراجع[self.دخل_ثابت]


def ابن_وشغّل(المصدر: str, مجلد: Path, اسم: str) -> tuple[str, str, int]:
    الرموز = النواة.حلل_رموز(المصدر)
    البرنامج = النواة.حلل_برنامج(الرموز)
    asm = النواة.compile_program(البرنامج)
    ملف_asm = مجلد / f"{اسم}.asm"
    ملف_obj = مجلد / f"{اسم}.o"
    ملف_تنفيذي = مجلد / اسم
    ملف_asm.write_text(asm, encoding="utf-8")
    subprocess.run(["nasm", "-f", "elf64", str(ملف_asm), "-o", str(ملف_obj)], check=True, capture_output=True, text=True)
    subprocess.run(["ld", str(ملف_obj), "-o", str(ملف_تنفيذي)], check=True, capture_output=True, text=True)
    نتيجة = subprocess.run([str(ملف_تنفيذي)], check=False, capture_output=True, text=True, timeout=5)
    return نتيجة.stdout.strip(), نتيجة.stderr.strip(), نتيجة.returncode


def أنشئ_الحالات() -> list[حالة]:
    # حدود آمنة: e^21.4 * 2^32 يبقى تحت int64، و-21.4 يختبر الذيل الصغير.
    قيم = [
        ("صفر", 0),
        ("أصغر_موجب", 1),
        ("أكبر_سالب_قريب", -1),
        ("حول_الصفر_موجب", 2),
        ("حول_الصفر_سالب", -2),
        ("قرب_واحد_موجب", مقياس - 1),
        ("قرب_واحد_سالب", -مقياس + 1),
        ("واحد_موجب", مقياس),
        ("واحد_سالب", -مقياس),
        ("نصف_موجب", مقياس // 2),
        ("نصف_سالب", -(مقياس // 2)),
        ("ربع_موجب", مقياس // 4),
        ("ربع_سالب", -(مقياس // 4)),
        ("أربعة_موجب", 4 * مقياس),
        ("أربعة_سالب", -4 * مقياس),
        ("ثمانية_موجب", 8 * مقياس),
        ("ثمانية_سالب", -8 * مقياس),
        ("ستة_عشر_موجب", 16 * مقياس),
        ("ستة_عشر_سالب", -16 * مقياس),
        ("حد_موجب_آمن", round(21.4 * مقياس)),
        ("حد_سالب_آمن", round(-21.4 * مقياس)),
    ]
    return [حالة(اسم, قيمة) for اسم, قيمة in قيم]


def رئيسي() -> int:
    الحالات = أنشئ_الحالات()
    ناجحون = 0
    فاشلون = 0
    فروق: list[int] = []
    نسب: list[float] = []
    print("اختبار إجهاد C40 على Q32.32")
    print(f"عدد الحالات: {len(الحالات)}، المقياس: {مقياس}، حد الخطأ: {حد_الخطأ}")
    with tempfile.TemporaryDirectory(prefix="uori_c40_stress_", dir=ROOT) as مجلد_خام:
        مجلد = Path(مجلد_خام)
        مصدر_مرجع = ROOT / "tests" / "c40_q32_verification" / "ref_exp_q64.c"
        ملف_مرجع = مجلد / "ref_exp_q64"
        subprocess.run(["cc", "-std=c11", "-O2", str(مصدر_مرجع), "-lm", "-o", str(ملف_مرجع)], check=True, capture_output=True, text=True)
        قيم_المرجع = subprocess.run([str(ملف_مرجع), *(str(حالة.دخل_ثابت) for حالة in الحالات)], check=True, capture_output=True, text=True).stdout.splitlines()
        مراجع = {حالة.دخل_ثابت: int(قيمة) for حالة, قيمة in zip(الحالات, قيم_المرجع, strict=True)}
        for الحالة in الحالات:
            المصدر = f"⎕ أُس({الحالة.دخل_ثابت})\n"
            try:
                stdout, stderr, code = ابن_وشغّل(المصدر, مجلد, "stress_" + الحالة.اسم)
                فعلي = int(stdout)
                مرجع = الحالة.مرجع_خام(مراجع)
                فرق = فعلي - مرجع
                نسبة = abs(فرق) / max(1, abs(مرجع))
                فروق.append(فرق)
                نسب.append(نسبة)
                ناجح = code == 0 and abs(فرق) <= حد_الخطأ
                if ناجح:
                    ناجحون += 1
                else:
                    فاشلون += 1
                علامة = "✅" if ناجح else "❌"
                print(
                    f"{علامة} {الحالة.اسم}: دخل_Q32={الحالة.دخل_ثابت}, "
                    f"دخل={الحالة.دخل_حقيقي:.15g}, مرجع_Q32={مرجع}, "
                    f"فعلي_Q32={فعلي}, فرق={فرق}, "
                    f"فرق_مطلق={abs(فرق)}, فرق_نسبي={نسبة:.3e}, code={code}"
                )
                if stderr:
                    print(f"  stderr={stderr!r}")
            except Exception as خطأ:
                فاشلون += 1
                print(f"❌ {الحالة.اسم}: فشل البناء أو التنفيذ: {خطأ}")

    if فروق:
        print(f"أقصى_فرق_مطلق={max(map(abs, فروق))}")
        print(f"أقصى_فرق_موقّع={max(فروق)}")
        print(f"أدنى_فرق_موقّع={min(فروق)}")
        print(f"أقصى_فرق_نسبي={max(نسب):.3e}")
    print(f"النتيجة: ناجح={ناجحون} فاشل={فاشلون} المجموع={len(الحالات)}")
    return 0 if فاشلون == 0 else 1


if __name__ == "__main__":
    raise SystemExit(رئيسي())
