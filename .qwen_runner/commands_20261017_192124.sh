#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
echo "===== 1) تصنيف الأخطاء ====="
grep -E '^error' /tmp/fix_build10.log | sort | uniq -c | sort -rn | head -10
echo "===== 2) أول 4 أخطاء بتفاصيلها ====="
grep -n -A10 '^error' /tmp/fix_build10.log | head -70
echo "===== 3) آخر 10 أسطر ====="
tail -10 /tmp/fix_build10.log
echo "===== 4) هل شجرة src مطابقة للفرع الآن؟ ====="
cd /root/ilm-al-kitab/MAL
git diff feat/if-return-gate-t5 HEAD --stat -- src/ | head -10
echo "(فارغ = مطابقة)"
echo "===== 5) حالة الملفات غير المتتبعة/المعدلة ====="
git status --short | head -15
echo "===== END: أرسل النتيجة ====="
