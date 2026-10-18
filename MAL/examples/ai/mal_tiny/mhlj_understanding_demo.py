#!/usr/bin/env python3
import json
print("🧠 المرحلة 1: محاكاة فهم MHLJ للغة العربية")
print("-" * 50)
sentence_1 = "إنّ المشروعَ ناجحٌ"
print(f"المدخل 1: '{sentence_1}'")
mhlj_output_1 = {
    "rule": "inna",
    "word1": "المشروعَ",
    "case1": "Mansub",
    "word2": "ناجحٌ",
    "case2": "Marfu"
}
print(f"مخرج MHLJ (الميزات المستخرجة): {json.dumps(mhlj_output_1, ensure_ascii=False)}\n")
sentence_2 = "اذهب إلى المدرسةُ"
print(f"المدخل 2: '{sentence_2}'")
mhlj_output_2 = {
    "rule": "jar_majrur",
    "word1": "إلى",
    "case1": "Majrur",
    "word2": "المدرسةُ",
    "case2": "Marfu"
}
print(f"مخرج MHLJ (الميزات المستخرجة): {json.dumps(mhlj_output_2, ensure_ascii=False)}\n")
with open("mhlj_out_1.json", "w", encoding="utf-8") as f:
    json.dump(mhlj_output_1, f)
with open("mhlj_out_2.json", "w", encoding="utf-8") as f:
    json.dump(mhlj_output_2, f)
print("✅ تم حفظ مخرجات 'الفهم' في ملفات JSON.")
