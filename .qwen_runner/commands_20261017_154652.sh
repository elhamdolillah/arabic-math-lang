#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /tmp/reconcile_ws 2>/dev/null || { echo "الـworktree اختفى"; exit 1; }
echo "===== 1) أخطاء البناء ====="
grep -E '^error' /tmp/reconcile_build2.log | head -15
echo "----- أول خطأ بتفاصيله -----"
grep -n -A10 '^error' /tmp/reconcile_build2.log | head -50
echo "===== 2) هل Cargo.toml تغيّر عن Hermes؟ ====="
git diff main HEAD --stat -- MAL/Cargo.toml MAL/tools/ MAL/Cargo.lock 2>/dev/null | head -20
echo "----- فرق MAL/Cargo.toml -----"
git diff main HEAD -- MAL/Cargo.toml | head -60
echo "===== 3) بنية workspace الحالية ====="
head -30 MAL/Cargo.toml
echo "----- members -----"
grep -A10 'members' MAL/Cargo.toml | head -15
echo "===== 4) هل tools/malc-native موجود؟ ====="
ls MAL/tools/malc-native/ 2>/dev/null | head -10
ls MAL/tools/ 2>/dev/null | head -10
echo "===== END: أرسل النتيجة ====="
