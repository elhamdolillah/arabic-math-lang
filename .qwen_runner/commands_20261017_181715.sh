#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
echo "===== 1) جميع أخطاء البناء ====="
grep -E '^error' /tmp/fix_build.log | head -20
echo "===== 2) أول 3 أخطاء بتفاصيلها ====="
grep -n -A10 '^error' /tmp/fix_build.log | head -60
echo "===== 3) آخر 15 سطراً ====="
tail -15 /tmp/fix_build.log
echo "===== END: أرسل النتيجة ====="
