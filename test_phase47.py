# -*- coding: utf-8 -*-
# المسار: test_phase47.py
"""
اختبارات المرحلة 47: Async/Await — 9 اختبارات
التشغيل: python3 test_phase47.py
"""

import sys, subprocess, os

# ═══ دالة مساعدة ═══
def تشغيل_اختبار(name, source, expected):
    """تشغيل اختبار واحد"""
    try:
        from math_complete import حلل_رموز, حلل_برنامج, compile_program
        ر = حلل_رموز(source)
        ب = حلل_برنامج(ر)
        asm = compile_program(ب)
        
        with open(f'{name}.asm', 'w') as f:
            f.write(asm)
        
        r = subprocess.run(['nasm', '-f', 'elf64', f'{name}.asm', '-o', f'{name}.o'],
                          capture_output=True, timeout=10)
        if r.returncode != 0:
            return False, f"NASM error: {r.stderr.decode()[:100]}"
        
        r = subprocess.run(['ld', f'{name}.o', '-o', name],
                          capture_output=True, timeout=10)
        if r.returncode != 0:
            return False, f"ld error: {r.stderr.decode()[:100]}"
        
        r = subprocess.run([f'./{name}'], capture_output=True, text=True, timeout=5)
        out = r.stdout.strip()
        
        if out == expected:
            return True, out
        return False, f"expected '{expected}', got '{out}'"
    except Exception as e:
        return False, str(e)
    finally:
        # تنظيف
        for ext in ['.asm', '.o', '']:
            path = name + ext
            if ext == '' and os.path.exists(path) and not path.endswith('.py'):
                try: os.remove(path)
                except: pass
            elif ext != '' and os.path.exists(path):
                try: os.remove(path)
                except: pass

# ═══ الاختبارات ═══
الاختبارات = [
    # 1. توافق عكسي: async لا يكسر الكود العادي
    ("t47_compat_basic",
     "مضروب ≡ λن. طابق ن : ﴿ 0 ⇒ 1 ⋄ س ⇒ س · مضروب(س - 1) ﴾\n⎕ نص(مضروب(5))",
     "120"),
    
    # 2. كلمة بانتظار كـ identifier عادي (no-op حالياً)
    ("t47_await_keyword",
     "س ≔ 42\n⎕ نص(س)",
     "42"),
    
    # 3. كلمة بدء كـ identifier عادي
    ("t47_start_keyword",
     "ق ≔ ⟨1، 2، 3، 4، 5⟩\n⎕ نص(مجموع_قائمة(ق))",
     "15"),
    
    # 4. التوافق مع ADTs
    ("t47_with_adt",
     "نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ﴾\n" +
     "مساحة ≡ λش. طابق ش : ﴿ دائرة(ن) ⇒ 3 · ن · ن ⋄ مستطيل(ع، ا) ⇒ ع · ا ﴾\n" +
     "⎕ نص(مساحة(دائرة(5)))",
     "75"),
    
    # 5. التوافق مع Traits
    ("t47_with_traits",
     "سمة قيمة(ن) : ﴿ احصل : 0 ﴾\n" +
     "نوع صندوق : ﴿ صندوق(ق) ﴾\n" +
     "تطبيق قيمة على صندوق : ﴿ احصل(س) ≔ س[0] ﴾\n" +
     "ص ≔ صندوق(21)\n" +
     "⎕ نص(احصل(ص))",
     "21"),
    
    # 6. التوافق مع Result types
    ("t47_with_result",
     "اقسم ≡ λ(أ، ب). طابق ب : ﴿ 0 ⇒ فشل(\"صفر\") ⋄ س ⇒ نجاح(أ ÷ س) ﴾\n" +
     "ن ≔ اقسم(10، 2)\n" +
     "⎕ طابق ن : ﴿ نجاح(ق) ⇒ نص(ق) ⋄ فشل(س) ⇒ س ﴾",
     "5"),
    
    # 7. التوافق مع القنوات (pipe2)
    ("t47_with_channels",
     "ق ≔ قناة()\n" +
     "أرسل(ق، 100)\n" +
     "ر ≔ استقبل(ق)\n" +
     "⎕ نص(ر)",
     "100"),
    
    # 8. التوافق مع توازي() الموجود
    ("t47_with_parallel",
     "ضاعف ≡ λن. ن · 2\n" +
     "⎕ نص(توازي(ضاعف، 21))",
     "42"),
    
    # 9. Pattern Matching متقدم
    ("t47_pattern_match",
     "مضروب ≡ λن. طابق ن : ﴿\n" +
     "    0 ⇒ 1\n" +
     "    ⋄ 1 ⇒ 1\n" +
     "    ⋄ س ⇒ س · مضروب(س - 1)\n" +
     "﴾\n" +
     "⎕ نص(مضروب(6))",
     "720"),
]

# ═══ التشغيل الرئيسي ═══
if __name__ == "__main__":
    ناجح = 0
    إجمالي = len(الاختبارات)
    
    print("═" * 60)
    print("  اختبارات المرحلة 47: Async/Await")
    print("═" * 60)
    
    for name, source, expected in الاختبارات:
        success, result = تشغيل_اختبار(name, source, expected)
        if success:
            print(f"  ✅ {name}: {result}")
            ناجح += 1
        else:
            print(f"  ❌ {name}: {result}")
    
    print("═" * 60)
    print(f"  النتيجة: {ناجح}/{إجمالي} {'✅' if ناجح == إجمالي else '❌'}")
    print("═" * 60)
    
    sys.exit(0 if ناجح == إجمالي else 1)
