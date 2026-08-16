"""
المرحلة 48: Macros (ميتابرمجة)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

المصدر: Lisp, Rust (macro_rules!), Nim, Julia

الفكرة:
ماكرو = دالة تعمل على AST في وقت التجميع
توسع الكود قبل التجميع الفعلي

الصيغة:
ماكرو اسم(معاملات) : ﴿
    ⋄ تعبير_التوسيع
﴾

مثال:
ماكرو assert(شرط، رسالة) : ﴿
    ⋄ شرط ؟ لاشيء : فشل(رسالة)
﴾

التوسيع:
assert(س > 0، "س يجب أن يكون موجباً")
→ س > 0 ؟ لاشيء : فشل("س يجب أن يكون موجباً")

﴿وقل رب زدني علماً﴾
"""

from typing import Dict, List, Tuple, Optional, Set
from dataclasses import dataclass, field
import copy


@dataclass
class MacroDefinition:
    """تعريف ماكرو"""
    name: str                    # اسم الماكرو
    params: List[str]            # المعاملات
    body: Tuple                  # جسم الماكرو (AST)
    hygiene: bool = True         # هل الماكرو صحي (hygienic)؟


class MacroExpander:
    """
    موسّع الماكرو

    يعمل في وقت التجميع (compile-time)
    يحول AST إلى AST آخر

    المصدر: Lisp (1958), Rust macro_rules! (2012)
    """

    def __init__(self):
        self.macros: Dict[str, MacroDefinition] = {}
        self.expansion_count = 0
        self.max_expansions = 100  # منع التوسع اللانهائي

    def define(self, name: str, params: List[str], body: Tuple):
        """تعريف ماكرو جديد"""
        self.macros[name] = MacroDefinition(
            name=name,
            params=params,
            body=body
        )

    def expand(self, expr: Tuple) -> Tuple:
        """
        توسيع تعبير

        إذا كان التعبير استدعاء ماكرو → وسّعه
        وإلا → أرجعه كما هو
        """
        if self.expansion_count > self.max_expansions:
            raise Exception("تجاوز حد التوسع الأقصى (ماكرو عودي؟)")

        if not isinstance(expr, tuple):
            return expr

        # هل هذا استدعاء ماكرو؟
        if expr[0] == 'استدعاء' and expr[1] in self.macros:
            macro_name = expr[1]
            args = expr[2]

            self.expansion_count += 1

            # توسيع الماكرو
            expanded = self._expand_macro(macro_name, args)

            # توسيع عودي (الماكرو قد يحتوي على ماكرو آخر)
            return self.expand(expanded)

        # توسيع المعاملات عودي
        if expr[0] == 'ثنائية':
            left = self.expand(expr[2])
            right = self.expand(expr[3])
            return ('ثنائية', expr[1], left, right)

        if expr[0] == 'استدعاء':
            args = [self.expand(arg) for arg in expr[2]]
            return ('استدعاء', expr[1], args)

        if expr[0] == 'أسند':
            return ('أسند', expr[1], self.expand(expr[2]))

        if expr[0] == 'اطبع':
            return ('اطبع', self.expand(expr[1]))

        return expr

    def _expand_macro(self, name: str, args: List[Tuple]) -> Tuple:
        """توسيع ماكرو محدد"""
        macro = self.macros[name]

        # ربط المعاملات بالقيم
        bindings = {}
        for param, arg in zip(macro.params, args):
            bindings[param] = arg

        # استبدال المعاملات في الجسم
        return self._substitute(macro.body, bindings)

    def _substitute(self, expr: Tuple, bindings: Dict[str, Tuple]) -> Tuple:
        """استبدال المعاملات في تعبير"""
        if not isinstance(expr, tuple):
            return expr

        if expr[0] == 'متغير':
            var_name = expr[1]
            if var_name in bindings:
                return bindings[var_name]
            return expr

        if expr[0] == 'ثنائية':
            left = self._substitute(expr[2], bindings)
            right = self._substitute(expr[3], bindings)
            return ('ثنائية', expr[1], left, right)

        if expr[0] == 'استدعاء':
            args = [self._substitute(arg, bindings) for arg in expr[2]]
            return ('استدعاء', expr[1], args)

        if expr[0] == 'سالب':
            return ('سالب', self._substitute(expr[1], bindings))

        if expr[0] == 'شرطي':
            cond = self._substitute(expr[1], bindings)
            then = self._substitute(expr[2], bindings)
            else_ = self._substitute(expr[3], bindings)
            return ('شرطي', cond, then, else_)

        if expr[0] == 'قائمة':
            elements = [self._substitute(e, bindings) for e in expr[1]]
            return ('قائمة', elements)

        return expr


class StandardMacros:
    """
    الماكروهات القياسية

    هذه الماكروهات موجودة في كل اللغات:
    - assert (Python, Rust, C, Java)
    - debug (Rust, Go)
    - repeat (Lisp, Julia)
    - let (Lisp, Rust, Haskell)
    """

    @staticmethod
    def register(expander: MacroExpander):
        """تسجيل الماكروهات القياسية"""

        # ماكرو assert
        # assert(شرط، رسالة) → شرط ؟ لاشيء : فشل(رسالة)
        expander.define(
            name="assert",
            params=["شرط", "رسالة"],
            body=('شرطي',
                  ('متغير', 'شرط'),
                  ('عدد', 1),  # لاشيء
                  ('استدعاء', 'فشل', [('متغير', 'رسالة')]))
        )

        # ماكرو debug
        # debug(تعبير) → ⎕ "DEBUG: " ⊕ نص(تعبير)
        expander.define(
            name="debug",
            params=["تعبير"],
            body=('اطبع',
                  ('ثنائية', '⊕',
                   ('نص', 'DEBUG: '),
                   ('استدعاء', 'نص', [('متغير', 'تعبير')])))
        )

        # ماكرو max
        # max(أ، ب) → أ > ب ؟ أ : ب
        expander.define(
            name="max",
            params=["أ", "ب"],
            body=('شرطي',
                  ('مقارنة', '>', ('متغير', 'أ'), ('متغير', 'ب')),
                  ('متغير', 'أ'),
                  ('متغير', 'ب'))
        )

        # ماكرو min
        # min(أ، ب) → أ < ب ؟ أ : ب
        expander.define(
            name="min",
            params=["أ", "ب"],
            body=('شرطي',
                  ('مقارنة', '<', ('متغير', 'أ'), ('متغير', 'ب')),
                  ('متغير', 'أ'),
                  ('متغير', 'ب'))
        )

        # ماكرو swap
        # swap(أ، ب) → ﴿ مؤقت ≔ أ ⋄ أ ≔ ب ⋄ ب ≔ مؤقت ﴾
        expander.define(
            name="swap",
            params=["أ", "ب"],
            body=('كتلة',
                  [('أسند', '_مؤقت', ('متغير', 'أ')),
                   ('أسند', 'أ', ('متغير', 'ب')),
                   ('أسند', 'ب', ('متغير', '_مؤقت'))],
                  None)
        )


def demo_macros():
    """مثال على الماكروهات"""

    print("=" * 60)
    print("🔧 المرحلة 48: Macros")
    print("=" * 60)

    expander = MacroExpander()
    StandardMacros.register(expander)

    # مثال 1: assert
    print("\n📋 مثال 1: assert(س > 0، 'خطأ')")
    expr = ('استدعاء', 'assert', [
        ('مقارنة', '>', ('متغير', 'س'), ('عدد', 0)),
        ('نص', 'خطأ')
    ])
    expanded = expander.expand(expr)
    print(f"  قبل: assert(س > 0، 'خطأ')")
    print(f"  بعد: {expanded}")

    # مثال 2: max
    print("\n📋 مثال 2: max(أ، ب)")
    expr = ('استدعاء', 'max', [
        ('متغير', 'أ'),
        ('متغير', 'ب')
    ])
    expanded = expander.expand(expr)
    print(f"  قبل: max(أ، ب)")
    print(f"  بعد: {expanded}")

    # مثال 3: debug
    print("\n📋 مثال 3: debug(س + ص)")
    expr = ('استدعاء', 'debug', [
        ('ثنائية', '+', ('متغير', 'س'), ('متغير', 'ص'))
    ])
    expanded = expander.expand(expr)
    print(f"  قبل: debug(س + ص)")
    print(f"  بعد: {expanded}")

    print(f"\n  عدد التوسيعات: {expander.expansion_count}")
    print("=" * 60)


if __name__ == '__main__':
    demo_macros()
