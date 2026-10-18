#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /tmp/reconcile_ws 2>/dev/null || { echo "الـworktree اختفى — أعد mission28b"; exit 1; }
echo "===== 1) حالة الدمج ====="
git log --oneline -2
git status --short | head -5
echo "===== 2) أخطاء البناء كاملة ====="
grep -E '^error' /tmp/reconcile_build.log | head -20
echo "----- تفاصيل أول 3 أخطاء -----"
grep -n -A8 '^error' /tmp/reconcile_build.log | head -80
echo "===== 3) هل هناك تعارض ملفات Rust؟ ====="
grep -rn '<<<<<<<' --include='*.rs' . | head -10
echo "===== 4) بنية الشجرة المدموجة ====="
ls MAL/ 2>/dev/null | head -10
ls src/ 2>/dev/null | head -10
echo "===== END: تشخيص فقط — أرسل النتيجة ====="
