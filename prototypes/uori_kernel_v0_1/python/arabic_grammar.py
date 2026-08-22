"""مدقق بنيوي محدود لأمثلة UORI العربية؛ لا يقيّم المصدر ولا ينفذه."""
from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import re


class GrammarSpecError(ValueError):
    pass


@dataclass(frozen=True)
class GrammarSummary:
    algorithms: int
    conditions: int
    bounded_loops: int
    functions: int
    returns: int


def validate_arabic_grammar(path: str | Path) -> GrammarSummary:
    lines = [line.strip() for line in Path(path).read_text(encoding="utf-8").splitlines()]
    lines = [line for line in lines if line and not line.startswith("#")]
    text = "\n".join(lines)
    algorithms = len(re.findall(r"^خوارزمية\s+[^\n]+->", text, re.MULTILINE))
    functions = len(re.findall(r"^دالة\s+[^\n]+->", text, re.MULTILINE))
    conditions = len(re.findall(r"^(?:إذا|وإلا إذا|وإلا)\s+", text, re.MULTILINE))
    bounded_loops = len(re.findall(r"^لكل\s+.+\s+من\s+.+\s+إلى\s+.+", text, re.MULTILINE))
    returns = len(re.findall(r"(?:^أعد|فأعد)\s+", text, re.MULTILINE))
    algorithm_names = re.findall(r"^خوارزمية\s+([^(:\s]+)", text, re.MULTILINE)
    function_names = re.findall(r"^دالة\s+([^(:\s]+)", text, re.MULTILINE)
    if len(set(algorithm_names)) != len(algorithm_names):
        raise GrammarSpecError("اسم خوارزمية مكرر")
    if len(set(function_names)) != len(function_names):
        raise GrammarSpecError("اسم دالة مكرر")
    if algorithms != 2 or functions != 1:
        raise GrammarSpecError("عدد تعريفات الخوارزميات أو الدوال غير مطابق للمثال المعتمد")
    if conditions != 3 or bounded_loops != 1 or returns != 5:
        raise GrammarSpecError("بنية الشرط أو الحلقة أو الإرجاع غير مكتملة")
    if bounded_loops and "شرط_الإنهاء:" not in text:
        raise GrammarSpecError("الحلقة المحدودة بلا عقد إنهاء صريح")
    if any(token in text for token in ("exec(", "eval(", "subprocess", "os.system")):
        raise GrammarSpecError("مصدر يحتوي مسار تنفيذ ديناميكياً محظوراً")
    return GrammarSummary(algorithms, conditions, bounded_loops, functions, returns)
