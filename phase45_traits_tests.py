# -*- coding: utf-8 -*-
"""اختبارات المرحلة 45: السمات (Traits / Typeclasses)"""
import sys, subprocess, os
sys.path.insert(0, '.')
from math_complete import *

passed = 0
failed = 0

def run(name, source, expected, desc=""):
    global passed, failed
    print(f"\n  [{name}] {desc}")
    try:
        ر = حلل_رموز(source)
        ب = حلل_برنامج(ر)
        asm = compile_program(ب)
        with open(f'{name}.asm', 'w') as f: f.write(asm)
        r = subprocess.run(['nasm','-f','elf64',f'{name}.asm','-o',f'{name}.o'],
                          capture_output=True)
        if r.returncode != 0:
            print(f"    [FAIL] NASM: {r.stderr[:200].decode() if r.stderr else ''}")
            failed += 1
            return
        r = subprocess.run(['ld',f'{name}.o','-o',name], capture_output=True)
        if r.returncode != 0:
            print(f"    [FAIL] ld: {r.stderr[:200].decode() if r.stderr else ''}")
            failed += 1
            return
        r = subprocess.run([f'./{name}'], capture_output=True, text=True, timeout=10)
        out = r.stdout.strip()
        if out == expected:
            print(f"    [PASS] Output: {out}")
            passed += 1
        else:
            print(f"    [FAIL] Expected: '{expected}'")
            print(f"           Got:      '{out}'")
            failed += 1
    except Exception as e:
        print(f"    [FAIL] {e}")
        import traceback; traceback.print_exc()
        failed += 1

print("="*60)
print("  PHASE 45: Traits / Typeclasses")
print("="*60)

# Test 1: Basic trait + impl
run("t45_basic",
    '''سمة قابلة_للطباعة(ن) : ﴿ اطبع_ذاتي : 0 ﴾
نوع نقطة : ﴿ نقطة(س، ص) ﴾
تطبيق قابلة_للطباعة على نقطة : ﴿
    اطبع_ذاتي(ن) ≔ "نقطة"
﴾
ن ≔ نقطة(3، 4)
⎕ اطبع_ذاتي(ن)''',
    "نقطة", "سمة أساسية + تطبيق")

# Test 2: Trait with ADT + pattern matching
run("t45_adt_match",
    '''سمة مساحة(ن) : ﴿ احسب : 0 ﴾
نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ﴾
تطبيق مساحة على شكل : ﴿
    احسب(ش) ≔ طابق ش : ﴿ دائرة(ن) ⇒ 3 · ن · ن ⋄ مستطيل(ع، ا) ⇒ ع · ا ﴾
﴾
⎕ نص(احسب(دائرة(5)))''',
    "75", "سمة + ADT + تطابق")

# Test 3: Multiple impls of same trait
run("t45_multi_impl",
    '''سمة قيمة(ن) : ﴿ احصل : 0 ﴾
نوع نوع_أ : ﴿ أ(ق) ﴾
نوع نوع_ب : ﴿ ب(ق) ﴾
تطبيق قيمة على نوع_أ : ﴿ احصل(س) ≔ س[0] · 2 ﴾
تطبيق قيمة على نوع_ب : ﴿ احصل(س) ≔ س[0] · 3 ﴾
⎕ نص(احصل(أ(10)))
⎕ نص(احصل(ب(10)))''',
    "20\n30", "تطبيقان مختلفان لنفس السمة")

# Test 4: Multiple traits on same type
run("t45_multi_traits",
    '''سمة مساحة(ن) : ﴿ احسب : 0 ﴾
سمة محيط(ن) : ﴿ احسب_محيط : 0 ﴾
نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ﴾
تطبيق مساحة على شكل : ﴿
    احسب(ش) ≔ طابق ش : ﴿ دائرة(ن) ⇒ 3 · ن · ن ⋄ مستطيل(ع، ا) ⇒ ع · ا ﴾
﴾
تطبيق محيط على شكل : ﴿
    احسب_محيط(ش) ≔ طابق ش : ﴿ دائرة(ن) ⇒ 6 · ن ⋄ مستطيل(ع، ا) ⇒ 2 · (ع + ا) ﴾
﴾
⎕ نص(احسب(دائرة(5)))
⎕ نص(احسب_محيط(دائرة(5)))''',
    "75\n30", "سمتان على نفس النوع")

# Test 5: Generic function using trait
run("t45_generic",
    '''سمة قيمة(ن) : ﴿ احصل : 0 ﴾
نوع صندوق : ﴿ صندوق(ق) ﴾
تطبيق قيمة على صندوق : ﴿ احصل(س) ≔ س[0] ﴾
ضاعف ≡ λس. احصل(س) · 2
⎕ نص(ضاعف(صندوق(21)))''',
    "42", "دالة عامة تستخدم سمة")

# Test 6: Nested trait calls
run("t45_nested",
    '''سمة قيمة(ن) : ﴿ احصل : 0 ﴾
نوع زوج : ﴿ زوج(أ، ب) ﴾
تطبيق قيمة على زوج : ﴿
    احصل(س) ≔ س[0] + س[1]
﴾
⎕ نص(احصل(زوج(10، 20)))''',
    "30", "استدعاء سمة يعيد قيمة")

# Test 7: Trait with complex body
run("t45_complex_body",
    '''سمة مجموع(ن) : ﴿ احسب_مجموع : 0 ﴾
نوع ثلاثي : ﴿ ثلاثي(أ، ب، ج) ﴾
تطبيق مجموع على ثلاثي : ﴿
    احسب_مجموع(س) ≔ س[0] + س[1] + س[2]
﴾
⎕ نص(احسب_مجموع(ثلاثي(10، 20، 30)))''',
    "60", "جسم معقد للسمة")

# Test 8: Backward compatibility
run("t45_compat",
    '''نوع شكل : ﴿ دائرة(ن) ⋄ مستطيل(ع، ا) ﴾
مساحة ≡ λش. طابق ش : ﴿ دائرة(ن) ⇒ 3 · ن · ن ⋄ مستطيل(ع، ا) ⇒ ع · ا ﴾
⎕ نص(مساحة(دائرة(5)))''',
    "75", "توافق عكسي: ADTs بدون سمات")

# Test 9: Previous phases still work
run("t45_prev_phases",
    '''مضروب ≡ λن. طابق ن : ﴿ 0 ⇒ 1 ⋄ س ⇒ س · مضروب(س - 1) ﴾
ق ≔ ⟨10، 20، 30، 40، 50⟩
⎕ نص(مضروب(5))
⎕ نص(ق[2])''',
    "120\n30", "توافق عكسي: Phase 43 + 44")

# Summary
print("\n" + "="*60)
total = passed + failed
print(f"  RESULTS: {passed}/{total} passed")
if failed == 0:
    print("  🎉 ALL PHASE 45 TESTS PASSED!")
else:
    print(f"  ❌ {failed} tests failed")
print("="*60)
