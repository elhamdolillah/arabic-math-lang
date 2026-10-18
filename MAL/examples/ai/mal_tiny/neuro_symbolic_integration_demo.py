#!/usr/bin/env python3
print("="*70)
print("🧠 عرض دمج MHLJ Fusion Head مع MAL (Neuro-Symbolic Integration)")
print("="*70)
print("\n1️⃣ الطريقة الأولى: التغذية (Feature-Level Integration)")
print("   MHLJ يُخرج 'الميزة النحوية' كجزء من تنبؤه دون تغيير أوزانه.")
mhlj_output = {"intent": "WRITE", "prep": "في", "noun": "الملفِ", "case": "Majrur"}
print(f"   📤 مخرج MHLJ المخصب: {mhlj_output}")
print("\n2️⃣ الطريقة الثانية: خط الأنابيب (Pipeline Gatekeeper)")
print("   طبقة حماية ترفض المخرجات المخالفة للنحو.")
def pipeline_check(noun_case):
    if noun_case != "Majrur":
        print(f"   🛑 BLOCKED: انتهاك نحوي. تم منع توليد qtxt.")
        return False
    print(f"   ✅ PASSED: التركيب سليم. جاري توليد qtxt...")
    return True
print("   --- سيناريو أ (صحيح): ---")
pipeline_check("Majrur")
print("   --- سيناريو ب (خاطئ/هلوسة): ---")
pipeline_check("Marfu")
