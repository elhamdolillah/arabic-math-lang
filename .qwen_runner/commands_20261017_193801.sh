#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) ملفات البوابات الموجودة ====="
ls tests/gates/ 2>/dev/null | head -15
echo "===== 2) محتوى بوابات C2 وD ====="
cat tests/gates/print_string_gate_c2.mal 2>/dev/null
echo "---"
cat tests/gates/fib_ar_gate_d.mal 2>/dev/null | head -10
echo "===== 3) هل هناك بوابة ternary في الفرع؟ ====="
ls tests/gates/ 2>/dev/null | grep -i 'tern|m12|cond'
grep -rn '؟' tests/gates/ 2>/dev/null | head -5
echo "===== 4) كيف يعالج parser الـternary؟ ====="
grep -n 'Question|ternary|Ternary' src/parser/src/lib.rs | head -10
echo "===== 5) تشغيل C2 وD بالمسار الصحيح ====="
BIN=/tmp/fix_build12/release/malc-native
$BIN tests/gates/print_string_gate_c2.mal -o /tmp/prv && /tmp/prv; echo "C2_EXIT=$?"
$BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fibv && /tmp/fibv; echo "D_EXIT=$?"
echo "===== END: أرسل النتيجة ====="
