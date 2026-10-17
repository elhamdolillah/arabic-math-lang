# -*- coding: utf-8 -*-
# المسار: test_phase48.py
"""
اختبارات المرحلة 48: Macros — 10 اختبارات
"""

import sys, subprocess, os

def تشغيل_اختبار(name, source, expected):
    # إعادة تعيين registry بين الاختبارات
    try:
        from phase48_macros import _macro_registry, إعادة_عداد_التوسعات
        _macro_registry.clear()
        إعادة_عداد_التوسعات()
    except: pass
    
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
            return False, f"NASM: {r.stderr.decode()[:80]}"
        
        r = subprocess.run(['ld', f'{name}.o', '-o', name],
                          capture_output=True, timeout=10)
        if r.returncode != 0:
            return False, f"ld: {r.stderr.decode()[:80]}"
        
        r = subprocess.run([f'./{name}'], capture_output=True, text=True, timeout=5)
        out = r.stdout.strip()
        
        if out == expected:
            return True, out
        return False, f"expected '{expected}', got '{out}'"
    except Exception as e:
        return False, str(e)[:100]
    finally:
        for ext in ['.asm', '.o', '']:
            path = name + ext
            if ext == '' and os.path.exists(path) and not path.endswith('.py'):
                try: os.remove(path)
                except: pass
            elif ext != '' and os.path.exists(path):
                try: os.remove(path)
                except: pass

الاختبارات = [
    # 1. ماكرو assert بسيط
    ("t48_assert",
     'ماكرو تأكد(شرط، رسالة) : ﴿ (شرط) ؟ 1 : فشل(رسالة) ﴾\n' +
     'ن ≔ تأكد(42 > 0، "خطأ")\n' +
     '⎕ طابق ن : ﴿ نجاح(ق) ⇒ نص(ق) ⋄ فشل(س) ⇒ س ﴾',
     "1"),
    
    # 2. ماكرو بمعاملات متعددة
    ("t48_multi_arg",
     'ماكرو جمع3(أ، ب، ج) : ﴿ أ + ب + ج ﴾\n' +
     '⎕ نص(جمع3(10، 20، 30))',
     "60"),
    
    # 3. ماكرو يستدعي ماكرو آخر (nesting)
    ("t48_nested",
     'ماكرو ضاعف(ن) : ﴿ ن · 2 ﴾\n' +
     'ماكرو رباعي(ن) : ﴿ ضاعف(ضاعف(ن)) ﴾\n' +
     '⎕ نص(رباعي(5))',
     "20"),
    
    # 4. ماكرو مع ADTs
    ("t48_with_adt",
     'نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ﴾\n' +
     'ماكرو دائرة_وهمية(ق) : ﴿ دائرة(ق · 1) ﴾\n' +
     'ش ≔ دائرة_وهمية(5)\n' +
     '⎕ طابق ش : ﴿ دائرة(ن) ⇒ نص(3 · ن · ن) ⋄ _ ⇒ "خطأ" ﴾',
     "75"),
    
    # 5. ماكرو مع Result
    ("t48_with_result",
     'ماكرو اقسم_آمن(أ، ب) : ﴿ طابق ب : ﴿ 0 ⇒ فشل("صفر") ⋄ س ⇒ نجاح(أ ÷ س) ﴾ ﴾\n' +
     'ن ≔ اقسم_آمن(100، 5)\n' +
     '⎕ طابق ن : ﴿ نجاح(ق) ⇒ نص(ق) ⋄ فشل(س) ⇒ س ﴾',
     "20"),
    
    # 6. Hygiene: المتغيرات الداخلية لا تتصادم
    ("t48_hygiene",
     'ماكرو تبديل(أ، ب) : ﴿ ﴿ مؤقت ≔ أ ⋄ أ ≔ ب ⋄ ب ≔ مؤقت ﴾ ﴾\n' +
     'س ≔ 5\n' +
     'ص ≔ 10\n' +
     '⎕ نص(س + ص)',
     "15"),
    
    # 7. ماكرو مع Pattern Matching
    ("t48_with_pattern",
     'ماكرو مضروب_ماكرو(ن) : ﴿ طابق ن : ﴿ 0 ⇒ 1 ⋄ س ⇒ س · مضروب_ماكرو(س - 1) ﴾ ﴾\n' +
     '⎕ نص(مضروب_ماكرو(5))',
     "120"),
    
    # 8. ماكرو ينتج قيمة معقدة
    ("t48_complex_body",
     'ماكرو حساب(س) : ﴿ ﴿ م ≔ س · س ⋄ م + 10 ﴾ ﴾\n' +
     '⎕ نص(حساب(7))',
     "59"),
    
    # 9. توافق عكسي: كود بدون ماكروز يعمل كالمعتاد
    ("t48_compat_basic",
     'مضروب ≡ λن. طابق ن : ﴿ 0 ⇒ 1 ⋄ س ⇒ س · مضروب(س - 1) ﴾\n' +
     '⎕ نص(مضروب(6))',
     "720"),
    
    # 10. توافق عكسي: ADTs + Traits بدون ماكروز
    ("t48_compat_full",
     'نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ﴾\n' +
     'مساحة ≡ λش. طابق ش : ﴿ دائرة(ن) ⇒ 3 · ن · ن ⋄ مستطيل(ع، ا) ⇒ ع · ا ﴾\n' +
     '⎕ نص(مساحة(دائرة(5))) ⊕ " " ⊕ نص(مساحة(مستطيل(3، 4)))',
     "75 12"),
]

if __name__ == "__main__":
    ناجح = 0
    إجمالي = len(الاختبارات)
    
    print("═" * 60)
    print("  اختبارات المرحلة 48: Macros")
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
