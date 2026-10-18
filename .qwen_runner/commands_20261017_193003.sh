#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
echo "===== 1) تصنيف الأخطاء ====="
grep -E '^error' /tmp/fix_build11.log | sort | uniq -c | sort -rn | head -10
echo "===== 2) أول 4 أخطاء بتفاصيلها ====="
grep -n -A10 '^error' /tmp/fix_build11.log | head -70
echo "===== 3) آخر 10 أسطر ====="
tail -10 /tmp/fix_build11.log
echo "===== END: أرسل النتيجة ====="
