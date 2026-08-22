"""مدقق مواصفة UORI ABI العربية؛ يقرأ العقد ولا ينفذها."""
from __future__ import annotations

from pathlib import Path


class AbiSpecError(ValueError):
    pass


def validate_abi(path: str | Path) -> dict[str, int]:
    lines = [line.strip() for line in Path(path).read_text(encoding="utf-8").splitlines()]
    lines = [line for line in lines if line and not line.startswith("#")]
    calls = [line for line in lines if line.startswith("نداء:")]
    required_calls = {"نداء: ابدأ_النواة", "نداء: نفذ_خوارزمية", "نداء: اكتب_جهاز"}
    if set(calls) != required_calls:
        raise AbiSpecError("نداءات ABI المطلوبة ناقصة أو مكررة")
    required = {
        "الإصدار: 1", "التمثيل: little_endian", "وصول_النظام: غير_ممنوح",
        "وصول_الشبكة: غير_ممنوح", "حد_الذاكرة: 4096", "حد_الوقود: 1024",
    }
    if not required.issubset(lines):
        raise AbiSpecError("عقد ABI الأساسي غير مكتمل")
    if any(token in "\n".join(lines) for token in ("exec(", "eval(", "subprocess", "os.system")):
        raise AbiSpecError("مسار تنفيذ ديناميكي محظور في مواصفة ABI")
    return {"calls": len(calls), "lines": len(lines)}
