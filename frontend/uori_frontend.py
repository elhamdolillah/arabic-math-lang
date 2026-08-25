#!/usr/bin/env python3
"""الواجهة الأمامية العربية الرياضية: Lexer + Parser + AST حتمية."""
from __future__ import annotations

from dataclasses import asdict, dataclass, field
import json
import re
from pathlib import Path
from typing import Any

أنواع = {"عدد_صحيح", "عدد_حقيقي", "منطقي", "نص", "بايت", "فراغ"}
كلمات = {"بنية", "إذا", "وإلا", "لكل", "أرجع", "ثابت", "صحيح", "خطأ", "منطقي"} | أنواع

@dataclass(frozen=True)
class رمز:
    النوع: str
    القيمة: str
    السطر: int
    العمود: int

@dataclass(frozen=True)
class عقدة:
    النوع: str

@dataclass(frozen=True)
class برنامج(عقدة):
    عناصر: list[عقدة] = field(default_factory=list)
    def __init__(self, عناصر: list[عقدة]): object.__setattr__(self, "النوع", "برنامج"); object.__setattr__(self, "عناصر", عناصر)

@dataclass(frozen=True)
class نوع(عقدة):
    الاسم: str
    def __init__(self, الاسم: str): object.__setattr__(self, "النوع", "نوع"); object.__setattr__(self, "الاسم", الاسم)

@dataclass(frozen=True)
class عدد(عقدة):
    القيمة: str
    حقيقي: bool
    def __init__(self, القيمة: str, حقيقي: bool): object.__setattr__(self, "النوع", "عدد"); object.__setattr__(self, "القيمة", القيمة); object.__setattr__(self, "حقيقي", حقيقي)

@dataclass(frozen=True)
class نص(عقدة):
    القيمة: str
    def __init__(self, القيمة: str): object.__setattr__(self, "النوع", "نص"); object.__setattr__(self, "القيمة", القيمة)

@dataclass(frozen=True)
class اسم(عقدة):
    القيمة: str
    def __init__(self, القيمة: str): object.__setattr__(self, "النوع", "اسم"); object.__setattr__(self, "القيمة", القيمة)

@dataclass(frozen=True)
class منطقي(عقدة):
    القيمة: bool
    def __init__(self, القيمة: bool): object.__setattr__(self, "النوع", "منطقي"); object.__setattr__(self, "القيمة", القيمة)

@dataclass(frozen=True)
class ثنائي(عقدة):
    عامل: str
    أ: عقدة
    ب: عقدة
    def __init__(self, عامل: str, أ: عقدة, ب: عقدة): object.__setattr__(self, "النوع", "ثنائي"); object.__setattr__(self, "عامل", عامل); object.__setattr__(self, "أ", أ); object.__setattr__(self, "ب", ب)

@dataclass(frozen=True)
class استدعاء(عقدة):
    اسم_الدالة: str
    معاملات: list[عقدة]
    def __init__(self, اسم_الدالة: str, معاملات: list[عقدة]): object.__setattr__(self, "النوع", "استدعاء"); object.__setattr__(self, "اسم_الدالة", اسم_الدالة); object.__setattr__(self, "معاملات", معاملات)

@dataclass(frozen=True)
class تصريح(عقدة):
    الاسم: str
    النوع_المعلن: نوع
    قيمة: عقدة | None
    ثابت: bool = False
    def __init__(self, الاسم: str, النوع_المعلن: نوع, قيمة: عقدة | None, ثابت: bool = False): object.__setattr__(self, "النوع", "تصريح"); object.__setattr__(self, "الاسم", الاسم); object.__setattr__(self, "النوع_المعلن", النوع_المعلن); object.__setattr__(self, "قيمة", قيمة); object.__setattr__(self, "ثابت", ثابت)

@dataclass(frozen=True)
class إرجاع(عقدة):
    قيمة: عقدة | None
    def __init__(self, قيمة: عقدة | None): object.__setattr__(self, "النوع", "إرجاع"); object.__setattr__(self, "قيمة", قيمة)

@dataclass(frozen=True)
class كتلة(عقدة):
    أوامر: list[عقدة]
    def __init__(self, أوامر: list[عقدة]): object.__setattr__(self, "النوع", "كتلة"); object.__setattr__(self, "أوامر", أوامر)

@dataclass(frozen=True)
class شرط(عقدة):
    اختبار: عقدة
    عند_الصحيح: كتلة
    عند_الخطأ: كتلة | None
    def __init__(self, اختبار: عقدة, عند_الصحيح: كتلة, عند_الخطأ: كتلة | None): object.__setattr__(self, "النوع", "شرط"); object.__setattr__(self, "اختبار", اختبار); object.__setattr__(self, "عند_الصحيح", عند_الصحيح); object.__setattr__(self, "عند_الخطأ", عند_الخطأ)

@dataclass(frozen=True)
class تكرار(عقدة):
    تهيئة: عقدة | None
    اختبار: عقدة | None
    تحديث: عقدة | None
    جسم: كتلة
    def __init__(self, تهيئة: عقدة | None, اختبار: عقدة | None, تحديث: عقدة | None, جسم: كتلة): object.__setattr__(self, "النوع", "تكرار"); object.__setattr__(self, "تهيئة", تهيئة); object.__setattr__(self, "اختبار", اختبار); object.__setattr__(self, "تحديث", تحديث); object.__setattr__(self, "جسم", جسم)

@dataclass(frozen=True)
class دالة(عقدة):
    الاسم: str
    معاملات: list[تصريح]
    الناتج: نوع
    الجسم: كتلة
    def __init__(self, الاسم: str, معاملات: list[تصريح], الناتج: نوع, الجسم: كتلة): object.__setattr__(self, "النوع", "دالة"); object.__setattr__(self, "الاسم", الاسم); object.__setattr__(self, "معاملات", معاملات); object.__setattr__(self, "الناتج", الناتج); object.__setattr__(self, "الجسم", الجسم)

@dataclass(frozen=True)
class بنية(عقدة):
    الاسم: str
    حقول: list[تصريح]
    def __init__(self, الاسم: str, حقول: list[تصريح]): object.__setattr__(self, "النوع", "بنية"); object.__setattr__(self, "الاسم", الاسم); object.__setattr__(self, "حقول", حقول)

class خطأ_لغوي(ValueError): pass

نمط_التوكن = re.compile(r'(?P<فراغ>[ \t\r]+)|(?P<تعليق>//[^\n]*)|(?P<سطر>\n)|(?P<حقيقي>\d+\.\d+)|(?P<عدد>\d+)|(?P<نص>"(?:\\.|[^"\\])*")|(?P<معرف>[A-Za-z_\u0621-\u063A\u0641-\u064A\u0671-\u06D3][A-Za-z0-9_\u0621-\u063A\u0641-\u064A\u0671-\u06D3]*)|(?P<عامل>==|!=|<=|>=|&&|\|\||[+\-*/%=<>!])|(?P<رمز>[{}()\[\],;؛،:])')

class محلل_معجمي:
    def حلل(self, نص: str) -> list[رمز]:
        النتيجة: list[رمز] = []; موضع = 0; سطر = 1; عمود = 1
        while موضع < len(نص):
            مطابقة = نمط_التوكن.match(نص, موضع)
            if not مطابقة: raise خطأ_لغوي(f"رمز غير معروف عند السطر {سطر} العمود {عمود}: {نص[موضع]!r}")
            نوع_المطابقة = مطابقة.lastgroup; قيمة = مطابقة.group(); بداية = (سطر, عمود)
            if نوع_المطابقة == "سطر": سطر += 1; عمود = 1
            else: عمود += len(قيمة)
            موضع = مطابقة.end()
            if نوع_المطابقة in {"فراغ", "تعليق", "سطر"}: continue
            if نوع_المطابقة == "رمز": قيمة = {"؛": ";", "،": ","}.get(قيمة, قيمة)
            if نوع_المطابقة == "معرف" and قيمة in كلمات: نوع_المطابقة = "كلمة"
            النتيجة.append(رمز(نوع_المطابقة, قيمة, بداية[0], بداية[1]))
        النتيجة.append(رمز("نهاية", "", سطر, عمود)); return النتيجة

class محلل_نحوي:
    def __init__(self, الرموز: list[رمز]): self.الرموز = الرموز; self.الموضع = 0
    def الحالي(self) -> رمز: return self.الرموز[self.الموضع]
    def تطابق(self, قيمة: str) -> bool:
        if self.الحالي().القيمة == قيمة: self.الموضع += 1; return True
        return False
    def إلزام(self, قيمة: str) -> رمز:
        if not self.تطابق(قيمة): raise خطأ_لغوي(f"متوقع {قيمة!r} عند السطر {self.الحالي().السطر}، ووجد {self.الحالي().القيمة!r}")
        return self.الرموز[self.الموضع - 1]
    def معرف(self) -> str:
        الرمز = self.الحالي()
        if الرمز.النوع != "معرف": raise خطأ_لغوي(f"متوقع معرف عند السطر {الرمز.السطر}")
        self.الموضع += 1; return الرمز.القيمة
    def نوع_بيان(self) -> نوع:
        الاسم_النوع = self.الحالي().القيمة
        if الاسم_النوع not in أنواع: raise خطأ_لغوي(f"نوع غير مدعوم: {الاسم_النوع}")
        self.الموضع += 1; return نوع(الاسم_النوع)
    def حلل_البرنامج(self) -> برنامج:
        عناصر = []
        while self.الحالي().النوع != "نهاية": عناصر.append(self.حلل_عنصر())
        return برنامج(عناصر)
    def حلل_عنصر(self) -> عقدة:
        if self.تطابق("بنية"):
            الاسم_البنية = self.معرف(); self.إلزام("{"); حقول = []
            while not self.تطابق("}"):
                حقول.append(self.حلل_تصريح(إلزام_فاصلة=True))
            self.تطابق(";"); return بنية(الاسم_البنية, حقول)
        بداية = self.الموضع; ثابت = self.تطابق("ثابت")
        if self.الحالي().القيمة in أنواع:
            نوع_الناتج = self.نوع_بيان(); الاسم_الدالة = self.معرف()
            if self.تطابق("("):
                معاملات = []
                if not self.تطابق(")"):
                    while True:
                        معاملات.append(self.حلل_تصريح(إلزام_فاصلة=False))
                        if self.تطابق(")"): break
                        self.إلزام(",")
                الجسم = self.حلل_كتلة(); return دالة(الاسم_الدالة, معاملات, نوع_الناتج, الجسم)
            self.الموضع = بداية
        if ثابت: self.الموضع = بداية
        return self.حلل_تصريح(إلزام_فاصلة=True)
    def حلل_تصريح(self, إلزام_فاصلة: bool) -> تصريح:
        ثابت = self.تطابق("ثابت"); نوع_المعلن = self.نوع_بيان(); الاسم = self.معرف(); قيمة = None
        if self.تطابق("="): قيمة = self.حلل_تعبير()
        if إلزام_فاصلة: self.إلزام(";")
        return تصريح(الاسم, نوع_المعلن, قيمة, ثابت)
    def حلل_كتلة(self) -> كتلة:
        self.إلزام("{"); أوامر = []
        while not self.تطابق("}"): أوامر.append(self.حلل_أمر())
        return كتلة(أوامر)
    def حلل_أمر(self) -> عقدة:
        if self.الحالي().القيمة in أنواع or self.الحالي().القيمة == "ثابت": return self.حلل_تصريح(True)
        if self.تطابق("أرجع"):
            قيمة = None if self.تطابق(";") else self.حلل_تعبير(); self.إلزام(";"); return إرجاع(قيمة)
        if self.تطابق("إذا"):
            self.إلزام("("); اختبار = self.حلل_تعبير(); self.إلزام(")"); صحيح = self.حلل_كتلة(); خطأ = self.حلل_كتلة() if self.تطابق("وإلا") else None; return شرط(اختبار, صحيح, خطأ)
        if self.تطابق("لكل"):
            self.إلزام("("); تهيئة = None if self.تطابق(";") else self.حلل_تصريح(True)
            اختبار = None if self.تطابق(";") else self.حلل_تعبير(); self.إلزام(";")
            تحديث = None if self.الحالي().القيمة == ")" else self.حلل_تعبير(); self.إلزام(")"); return تكرار(تهيئة, اختبار, تحديث, self.حلل_كتلة())
        قيمة = self.حلل_تعبير(); self.إلزام(";"); return قيمة
    def حلل_تعبير(self, مستوى: int = 0) -> عقدة:
        أولوية = {"=": 0, "||": 1, "&&": 2, "==": 3, "!=": 3, "<": 4, ">": 4, "<=": 4, ">=": 4, "+": 5, "-": 5, "*": 6, "/": 6, "%": 6}
        يسار = self.حلل_أولي()
        while self.الحالي().القيمة in أولوية and أولوية[self.الحالي().القيمة] >= مستوى:
            عامل = self.الحالي().القيمة; رتبة = أولوية[عامل]; self.الموضع += 1; يمين = self.حلل_تعبير(رتبة if عامل == "=" else رتبة + 1); يسار = ثنائي(عامل, يسار, يمين)
        return يسار
    def حلل_أولي(self) -> عقدة:
        الرمز = self.الحالي()
        if self.تطابق("("): قيمة = self.حلل_تعبير(); self.إلزام(")"); return قيمة
        if الرمز.النوع == "عدد" or الرمز.النوع == "حقيقي": self.الموضع += 1; return عدد(الرمز.القيمة, الرمز.النوع == "حقيقي")
        if الرمز.النوع == "نص": self.الموضع += 1; return نص(bytes(الرمز.القيمة[1:-1], "utf-8").decode("unicode_escape"))
        if self.تطابق("صحيح"): return منطقي(True)
        if self.تطابق("خطأ"): return منطقي(False)
        الاسم = self.معرف()
        if self.تطابق("("):
            معاملات = []
            if not self.تطابق(")"):
                while True:
                    معاملات.append(self.حلل_تعبير())
                    if self.تطابق(")"): break
                    self.إلزام(",")
            return استدعاء(الاسم, معاملات)
        return اسم(الاسم)

def إلى_قاموس(العقدة: Any) -> Any:
    if hasattr(العقدة, "__dataclass_fields__"):
        return {مفتاح: إلى_قاموس(قيمة) for مفتاح, قيمة in asdict(العقدة).items()}
    if isinstance(العقدة, list): return [إلى_قاموس(قيمة) for قيمة in العقدة]
    return العقدة

def ترجمة_AST(النص: str) -> برنامج: return محلل_نحوي(محلل_معجمي().حلل(النص)).حلل_البرنامج()

def رئيسي() -> None:
    import argparse
    محلل = argparse.ArgumentParser(); محلل.add_argument("المصدر", type=Path); محلل.add_argument("--ast", type=Path, required=True)
    حجج = محلل.parse_args(); شجرة = ترجمة_AST(حجج.المصدر.read_text(encoding="utf-8")); حجج.ast.write_text(json.dumps(إلى_قاموس(شجرة), ensure_ascii=False, indent=2) + "\n", encoding="utf-8"); print("UORI_LEXER_PARSER=PASS"); print(f"AST={حجج.ast}")

if __name__ == "__main__": رئيسي()
