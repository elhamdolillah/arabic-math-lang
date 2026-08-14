# -*- coding: utf-8 -*-
# المسار: test_phase50.py
"""
اختبارات المرحلة 50: Self-hosting — 8 اختبارات
"""

import sys, subprocess, os

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

def تجميع_ملف_ar(مسار):
    """تجميع ملف .ar خارجي بالمحرك الحالي"""
    try:
        with open(مسار, 'r', encoding='utf-8') as f:
            source = f.read()
        
        from math_complete import حلل_رموز, حلل_برنامج, compile_program
        ر = حلل_رموز(source)
        ب = حلل_برنامج(ر)
        asm = compile_program(ب)
        
        name = مسار.replace('.ar', '')
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
        
        return True, name
    except Exception as e:
        return False, str(e)[:100]

الاختبارات = [
    # 1. توافق عكسي: المحرك لا يزال يعمل
    ("t50_compat_engine",
     "⎕ نص(42 + 8)",
     "50"),
    
    # 2. Pattern Matching لا يزال يعمل
    ("t50_compat_pattern",
     "مضروب ≡ λن. طابق ن : ﴿ 0 ⇒ 1 ⋄ س ⇒ س · مضروب(س - 1) ﴾\n⎕ نص(مضروب(5))",
     "120"),
    
    # 3. ADTs لا تزال تعمل
    ("t50_compat_adt",
     "نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ﴾\n" +
     "مساحة ≡ λش. طابق ش : ﴿ دائرة(ن) ⇒ 3 · ن · ن ⋄ مستطيل(ع، ا) ⇒ ع · ا ﴾\n" +
     "⎕ نص(مساحة(دائرة(5)))",
     "75"),
    
    # 4. Traits لا تزال تعمل
    ("t50_compat_traits",
     "سمة قيمة(ن) : ﴿ احصل : 0 ﴾\n" +
     "نوع صندوق : ﴿ صندوق(ق) ﴾\n" +
     "تطبيق قيمة على صندوق : ﴿ احصل(س) ≔ س[0] ﴾\n" +
     "⎕ نص(احصل(صندوق(21)))",
     "21"),
    
    # 5. Result/Option لا يزال يعمل
    ("t50_compat_result",
     "اقسم ≡ λ(أ، ب). طابق ب : ﴿ 0 ⇒ فشل(\"صفر\") ⋄ س ⇒ نجاح(أ ÷ س) ﴾\n" +
     "ن ≔ اقسم(100، 4)\n" +
     "⎕ طابق ن : ﴿ نجاح(ق) ⇒ نص(ق) ⋄ فشل(س) ⇒ س ﴾",
     "25"),
    
    # 6. القنوات لا تزال تعمل
    ("t50_compat_channels",
     "ق ≔ قناة()\nأرسل(ق، 77)\nر ≔ استقبل(ق)\n⎕ نص(ر)",
     "77"),
    
    # 7. التوازي لا يزال يعمل
    ("t50_compat_parallel",
     "ضاعف ≡ λن. ن · 2\n⎕ نص(توازي(ضاعف، 25))",
     "50"),
    
    # 8. تجميع ملف selfhost.ar
    ("t50_selfhost_compile",
     None,  # اختبار خاص
     "5"),  # المتوقع: معرف س + ≔ + 42 + + + 10 = 5 رموز (إصلاح رمّز ليلحق كل الرموز)
]

if __name__ == "__main__":
    ناجح = 0
    إجمالي = len(الاختبارات)
    
    print("═" * 60)
    print("  اختبارات المرحلة 50: Self-hosting")
    print("═" * 60)
    
    for name, source, expected in الاختبارات:
        if source is None:
            # اختبار خاص: تجميع ملف خارجي
            if os.path.exists('phase50_selfhost.ar'):
                success, result = تجميع_ملف_ar('phase50_selfhost.ar')
                if success:
                    # تشغيل الثنائي الناتج
                    try:
                        r = subprocess.run([f'./phase50_selfhost'], 
                                          capture_output=True, text=True, timeout=5)
                        out = r.stdout.strip()
                        if out == expected:
                            print(f"  ✅ {name}: {out}")
                            ناجح += 1
                        else:
                            print(f"  ❌ {name}: expected '{expected}', got '{out}'")
                    except Exception as e:
                        print(f"  ❌ {name}: {e}")
                else:
                    print(f"  ❌ {name}: {result}")
            else:
                print(f"  ⚠️ {name}: phase50_selfhost.ar غير موجود")
        else:
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
