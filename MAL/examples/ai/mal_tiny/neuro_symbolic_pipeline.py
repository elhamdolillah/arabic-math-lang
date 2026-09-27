#!/usr/bin/env python3
"""
الطريقتان 1 و 2: التغذية (Feature-Level) وخط الأنابيب (Pipeline)
"""
print("="*70)
print("🧠 المرحلة 1 و 2: التغذية وخط الأنابيب (Python Layer)")
print("="*70)
# الطريقة 1: التغذية (Feature-Level Integration)
# MHLJ لا يغير أوزانه، بل يُدرّب ليُخرج "الميزة النحوية" كجزء من تنبؤه
def mhlj_predict_features(user_input: str) -> dict:
    return {
        "intent": "WRITE_FILE",
        "preposition": "في",
        "noun": user_input.split()[-1],
        "predicted_case": "Majrur" if "ِ" in user_input else "Marfu" # استخراج الميزة النحوية
    }
# الطريقة 2: خط الأنابيب (Pipeline Gatekeeper)
# طبقة حماية ترفض تمرير الطلب إذا انتهك القواعد الحتمية
def pipeline_gatekeeper(mhlj_output: dict) -> bool:
    rule = "jar_majrur"
    if rule == "jar_majrur" and mhlj_output["predicted_case"] != "Majrur":
        print(f"   🛑 [Pipeline BLOCKED]: '{mhlj_output['noun']}' بعد '{mhlj_output['preposition']}' يجب أن يكون مجروراً، لكنه جاء {mhlj_output['predicted_case']}.")
        return False
    print(f"   ✅ [Pipeline PASSED]: التركيب النحوي سليم. جاري تمرير الطلب لـ MAL...")
    return True
print("\n--- سيناريو أ: مدخل صحيح ('اكتب في الملفِ') ---")
out_a = mhlj_predict_features("اكتب في الملفِ")
print(f"   📤 مخرج MHLJ (مع التغذية): {out_a}")
pipeline_gatekeeper(out_a)
print("\n--- سيناريو ب: مدخل خاطئ/هلوسة ('اكتب في الملفُ') ---")
out_b = mhlj_predict_features("اكتب في الملفُ")
print(f"   📤 مخرج MHLJ (مع التغذية): {out_b}")
pipeline_gatekeeper(out_b)
