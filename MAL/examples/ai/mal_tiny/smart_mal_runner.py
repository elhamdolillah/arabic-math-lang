#!/usr/bin/env python3
"""
المشغل الذكي لنظام MAL:
يعطي الأولوية المطلقة للكود المثبت (Verified Registry) لضمان السرعة 100% والحتمية.
يفشل بأمان (Fail-Safe) ولا ينهار أبداً.
"""
import json
import os
import subprocess
import sys
# استيراد الدوال من ملفاتها الصحيحة
sys.path.append('.')
from mock_mhlj_engine import generate_mal_json
from self_healing_pipeline import validate_schema, assemble_and_prove, run_proof
REGISTRY_FILE = "verified_mal_registry.json"
MALC_BIN = "/root/ilm-al-kitab/MAL/src/cli/target/release/malc"
def execute_verified_code(function_name: str, mal_code: str) -> bool:
    """تجميع وتشغيل كود MAL مثبت مسبقاً بأقصى سرعة"""
    print(f"⚡ [FAST PATH]: تم العثور على '{function_name}' في السجل المثبت. تخطي MHLJ...")
    temp_file = "temp_verified.mal"
    executable = "temp_verified_exec"
    with open(temp_file, 'w', encoding='utf-8') as f:
        f.write(mal_code)
    # التجميع
    compile_res = subprocess.run([MALC_BIN, "compile", temp_file, "-o", executable], capture_output=True, text=True)
    if compile_res.returncode != 0:
        print("❌ [CRITICAL]: فشل تجميع كود مثبت سابقاً! (هذا لا يجب أن يحدث)")
        return False
    # التشغيل
    run_res = subprocess.run([f"./{executable}"], capture_output=True, text=True)
    print(run_res.stdout)
    # تنظيف مؤقت
    if os.path.exists(temp_file):
        os.remove(temp_file)
    if os.path.exists(executable):
        os.remove(executable)
    return run_res.returncode == 0
def handle_new_request(prompt: str) -> bool:
    """معالجة طلب جديد عبر خط الأنابيب الذاتي الشفاء"""
    print(f"🧠 [SLOW PATH]: لم يتم العثور على '{prompt}' في السجل. جاري استدعاء MHLJ والبرهان...")
    max_retries = 3
    error_feedback = ""
    for attempt in range(1, max_retries + 1):
        ast = generate_mal_json(prompt, error_feedback)
        ast['attempt'] = attempt
        if not validate_schema(ast):
            print("❌ فشل التحقق من الهيكل.")
            return False
        mal_file = "ai_generated_logic.mal"
        executable = "ai_generated_logic"
        assemble_and_prove(ast, mal_file)
        proof_passed, proof_msg = run_proof(mal_file, executable)
        if proof_passed:
            print("✅ [SUCCESS]: تم إثبات الكود الجديد وحفظه في السجل.")
            # الحفظ في السجل
            try:
                with open(REGISTRY_FILE, 'r', encoding='utf-8') as f:
                    registry = json.load(f)
            except FileNotFoundError:
                registry = {}
            registry[ast['function_name']] = {"mal_code": open(mal_file).read()}
            with open(REGISTRY_FILE, 'w', encoding='utf-8') as f:
                json.dump(registry, f, ensure_ascii=False, indent=2)
            print(proof_msg)
            return True
        else:
            error_feedback = f"فشل البرهان: {proof_msg}. صحح المنطق."
    print("❌ [COLLAPSE PREVENTED]: استنفاد المحاولات. تم رفض الطلب بأمان.")
    return False
def main():
    print("=== نظام MAL الذكي الموحد (Unified Smart Runner) ===\n")
    # محاكاة طلب المستخدم
    request = "calculate_discount"
    # 1. التحقق من السجل المثبت أولاً
    if os.path.exists(REGISTRY_FILE):
        with open(REGISTRY_FILE, 'r', encoding='utf-8') as f:
            registry = json.load(f)
        if request in registry:
            success = execute_verified_code(request, registry[request]['mal_code'])
            if success:
                print("\n🏆 تم التنفيذ بنجاح عبر المسار السريع (100% MAL, 0% MHLJ).")
                return
    # 2. إذا لم يكن موجوداً، استدعاء خط الأنابيب الذاتي الشفاء
    success = handle_new_request(request)
    if success:
        print("\n🏆 تم التنفيذ بنجاح بعد البرهان والإضافة للسجل.")
if __name__ == "__main__":
    main()
