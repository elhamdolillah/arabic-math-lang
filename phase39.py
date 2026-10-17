# -*- coding: utf-8 -*-
"""
المرحلة 39: التوازي الفعلي (خيوط حقيقية عبر clone syscall)
خيوط Linux حقيقية بلا libc — كل خيط له مكدس مستقل mmap ويُنفَّذ بالتزامن الفعلي
"""
import sys, subprocess, time
sys.path.insert(0, '.')
from math_complete import *

print("=" * 60)
print("المرحلة 39: التوازي الفعلي عبر clone syscall")
print("=" * 60)

tests = []
passed = 0; failed = 0

def run(name, source, expected):
    global passed, failed
    try:
        ر = حلل_رموز(source)
        ب = حلل_برنامج(ر)
        asm = compile_program(ب)
        with open(f'{name}.asm', 'w') as f: f.write(asm)
        subprocess.run(['nasm', '-f', 'elf64', f'{name}.asm', '-o', f'{name}.o'],
                       check=True, capture_output=True)
        subprocess.run(['ld', f'{name}.o', '-o', name], check=True, capture_output=True)
        t0 = time.time()
        r = subprocess.run([f'./{name}'], capture_output=True, text=True, timeout=10)
        t1 = time.time()
        out = r.stdout.strip()
        if out == expected:
            print(f"  ✅ ({name}): {out}")
            passed += 1
        else:
            print(f"  ❌ ({name}): متوقع '{expected}'، فعلي '{out}'")
            failed += 1
            with open(f'{name}_fail.asm', 'w') as f: f.write(asm)
    except Exception as e:
        print(f"  ❌ ({name}): خطأ: {e}")
        failed += 1

print("\n🧪 1) توازي أساسي:")
مضاعفة1 = "مضاعفة ≡ λن. ن · 2\n⎕ نص(توازي(مضاعفة، 21))"
run('th1', مضاعفة1, '42')

print("\n🧪 2) عمل حلقي داخل خيط:")
حلقي = "جامع ≡ λن. ﴿ م ≔ 0 ⋄ ع ≔ 1 ⋄ μ ع < ن + 1 : ﴿ م ≔ م + ع ⋄ ع ≔ ع + 1 ﴾ ⋄ م ﴾\n⎕ نص(توازي(جامع، 1000))"
run('th2', حلقي, '500500')

print("\n🧪 3) أربعة خيوط متزامنة:")
خيوط = "مربع ≡ λن. ن · ن\nأ ≔ توازي(مربع، 3)\nب ≔ توازي(مربع، 4)\nج ≔ توازي(مربع، 5)\nد ≔ توازي(مربع، 6)\nم ≔ أ + ب + ج + د\n⎕ نص(م)"
run('th3', خيوط, '86')

print("\n🧪 4) خيوط بوظائف مختلفة:")
مختلف = "م1 ≡ λن. ن · 2\nم2 ≡ λن. ن + 10\nم3 ≡ λن. ن · ن\nن1 ≔ توازي(م1، 21)\nن2 ≔ توازي(م2، 12)\nن3 ≔ توازي(م3، 5)\nم ≔ ن1 · 100 + ن2 · 10 + ن3\n⎕ نص(م)"
run('th4', مختلف, '4445')

print("\n🧪 5) فيبوناتشي في خيط:")
فيبو = "فيب ≡ λن. (ن < 1) ؟ ن : فيب(ن - 1) + فيب(ن - 2)\n⎕ نص(توازي(فيب، 15))"
run('th5', فيبو, '610')

print("\n🧪 6) خيط + ملف:")
ملفي = "مربع ≡ λن. ن · ن\nر ≔ توازي(مربع، 7)\nم ≔ فتح(\"parallel_result.txt\")\nاكتب_ملف(م، نص(ر))\nاختم(م)\n⎕ نص(ر)"
run('th6', ملفي, '49')

print("\n📂 التحقق من parallel_result.txt:")
try:
    with open('parallel_result.txt', 'r') as f:
        م = f.read().strip()
    if م == '49':
        print(f"  ✅ محتوى الملف: {م}")
        passed += 1
    else:
        print(f"  ❌ محتوى الملف: '{م}'، متوقع '49'")
        failed += 1
except Exception as e:
    print(f"  ❌ قراءة الملف: {e}")
    failed += 1

print("\n" + "=" * 60)
if failed == 0:
    print(f"🎉 المرحلة 39 نجحت! ({passed}/{passed + failed})")
    print("التوازي الفعلي عبر clone syscall يعمل!")
else:
    print(f"❌ نجح {passed} وفشل {failed}")
    sys.exit(1)