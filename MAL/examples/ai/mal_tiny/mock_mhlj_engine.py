#!/usr/bin/env python3
import json
# محاكاة لسجل المحاولات لمحاكاة "التعلم من الخطأ"
attempt_count = 0
def generate_mal_json(prompt: str, error_feedback: str = "") -> dict:
    global attempt_count
    attempt_count += 1
    if attempt_count == 1 and not error_feedback:
        # المحاولة الأولى: خطأ متعمد في المنطق (استخدام + بدلاً من *) لمحاكاة الهلوسة
        return {
            "function_name": "calculate_discount",
            "inputs": [{"name": "price", "type": "i32"}, {"name": "rate", "type": "i32"}],
            "return_type": "i32",
            "mal_logic": [
                "let mut final_price: i32 = price;",
                "if rate > 0 {",
                "    let discount: i32 = (price + rate) / 100;", # <-- خطأ متعمد
                "    final_price = price - discount;",
                "}",
                "return final_price;"
            ]
        }
    else:
        # المحاولة الثانية (بعد تلقي ملاحظة الخطأ): المنطق الصحيح
        return {
            "function_name": "calculate_discount",
            "inputs": [{"name": "price", "type": "i32"}, {"name": "rate", "type": "i32"}],
            "return_type": "i32",
            "mal_logic": [
                "let mut final_price: i32 = price;",
                "if rate > 0 {",
                "    let discount: i32 = (price * rate) / 100;", # <-- تم التصحيح
                "    final_price = price - discount;",
                "}",
                "return final_price;"
            ]
        }
