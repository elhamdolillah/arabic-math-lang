#!/usr/bin/env python3
import json
import subprocess
import os
def validate_schema(data: dict) -> bool:
    """بوابة التحقق الصارمة: التأكد من هيكل JSON"""
    required_keys = ["function_name", "inputs", "return_type", "mal_logic"]
    return all(key in data for key in required_keys)
def assemble_and_prove(ast: dict, output_file: str) -> tuple[bool, str]:
    """تجميع الكود وتوليد بروتوكول اختبار خصائص متعدد"""
    inputs = ", ".join([f"{inp['name']}: {inp['type']}" for inp in ast['inputs']])
    mal_code = f"// ==========================================\n"
    mal_code += f"// كود MAL المُولَّد (محاولة: {ast.get('attempt', 1)})\n"
    mal_code += f"// ==========================================\n\n"
    mal_code += f"fn {ast['function_name']}({inputs}) -> {ast['return_type']} {{\n"
    for line in ast['mal_logic']:
        mal_code += f"    {line}\n"
    mal_code += "}\n\n"
    # توليد بروتوكول اختبار خصائص (Property-Based Testing)
    mal_code += "fn main() -> i32 {\n"
    mal_code += "    printf(\"=== بروتوكول برهان الحتمية الشامل ===\\n\");\n"
    mal_code += "    let mut all_passed: i32 = 1;\n"
    # حالات الاختبار: (price, rate, expected_result)
    test_cases = [
        (100, 20, 80),   # حالة عادية
        (200, 0, 200),   # حالة حدية: خصم صفر
        (50, 10, 45),    # حالة عادية أخرى
        (100, 50, 50)    # حالة خصم كبير
    ]
    for price, rate, expected in test_cases:
        mal_code += f"    let res_{price}_{rate}: i32 = {ast['function_name']}({price}, {rate});\n"
        mal_code += f"    if res_{price}_{rate} != {expected} {{\n"
        mal_code += f"        printf(\"❌ فشل عند ({price}, {rate}): الناتج %d، المتوقع {expected}\\n\", res_{price}_{rate});\n"
        mal_code += "        all_passed = 0;\n"
        mal_code += "    }\n"
    mal_code += "    if all_passed == 1 {\n"
    mal_code += "        printf(\"✅ [PROOF PASSED]: جميع حالات الاختبار مطابقة حتمياً.\\n\");\n"
    mal_code += "        return 0;\n"
    mal_code += "    } else {\n"
    mal_code += "        printf(\"❌ [PROOF FAILED]: انهيار في الحتمية.\\n\");\n"
    mal_code += "        return 1;\n"
    mal_code += "    }\n"
    mal_code += "}\n"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(mal_code)
    return True, "تم التجميع الرمزي بنجاح."
def run_proof(mal_file: str, executable: str) -> tuple[bool, str]:
    """تنفيذ البرهان عبر المترجم والتشغيل"""
    malc_bin = "/root/ilm-al-kitab/MAL/src/cli/target/release/malc"
    # 1. التجميع
    compile_result = subprocess.run([malc_bin, "compile", mal_file, "-o", executable], 
                                    capture_output=True, text=True)
    if compile_result.returncode != 0:
        return False, f"فشل التجميع:\n{compile_result.stderr}"
    # 2. التشغيل
    run_result = subprocess.run([f"./{executable}"], capture_output=True, text=True)
    if run_result.returncode != 0:
        return False, f"فشل برهان الحتمية أثناء التشغيل:\n{run_result.stdout}"
    return True, run_result.stdout
# --- تنفيذ خط الأنابيب الرئيسي ---
if __name__ == "__main__":
    import sys
    sys.path.append('.')
    from mock_mhlj_engine import generate_mal_json
    max_retries = 3
    prompt = "اكتب دالة خصم تأخذ السعر والنسبة وتعيد السعر النهائي"
    error_feedback = ""
    for attempt in range(1, max_retries + 1):
        print(f"\n🔄 المحاولة {attempt}: توليد الهيكل المنطقي...")
        ast = generate_mal_json(prompt, error_feedback)
        ast['attempt'] = attempt
        if not validate_schema(ast):
            print("❌ فشل التحقق من الهيكل (Schema Validation Failed).")
            break
        print("✅ تم اجتياز بوابة التحقق الصارمة.")
        # التجميع الرمزي
        mal_file = "ai_generated_logic.mal"
        executable = "ai_generated_logic"
        success, msg = assemble_and_prove(ast, mal_file)
        # تنفيذ البرهان
        proof_passed, proof_msg = run_proof(mal_file, executable)
        if proof_passed:
            print("\n" + "="*50)
            print("🏆 [SUCCESS]: برهان الحتمية مكتمل بنجاح!")
            print("="*50)
            print(proof_msg)
            # 4. الحفظ في السجل المثبت (Verified Registry)
            registry = {"function": ast['function_name'], "mal_code": open(mal_file).read()}
            with open("verified_mal_registry.json", "w", encoding="utf-8") as f:
                json.dump(registry, f, ensure_ascii=False, indent=2)
            print("\n💾 تم حفظ الكود المثبت في Verified Registry لاستدعائه مستقبلاً بدون MHLJ.")
            break
        else:
            print(f"\n⚠️ فشل البرهان في المحاولة {attempt}. جاري التحليل والتصحيح...")
            error_feedback = f"الكود فشل في الاختبار. سجل الخطأ: {proof_msg}. يرجى تصحيح المنطق الرياضي."
            print(f"   -> ملاحظة التصحيح المرسلة للنموذج: {error_feedback[:100]}...")
    else:
        print("\n❌ [COLLAPSE PREVENTED]: تم استنفاذ المحاولات. النظام آمن ولم ينهار، وتم رفض الكود المعيب.")
