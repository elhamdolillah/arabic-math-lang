#!/usr/bin/env bash
set -euo pipefail
cd /root/ilm-al-kitab/MAL
# ضع التوكن الجديد هنا (استبدل TOKEN_JDID قبل الإرسال):
NEW_TOKEN="TOKEN_JDID"
git remote set-url origin "https://elhamdolillah:${NEW_TOKEN}@github.com/elhamdolillah/arabic-math-lang.git"
# تحقق أن التوكن القديم لم يعد موجوداً:
if git remote -v | grep -q 'ghp_0gIgx'; then
  echo 'FAIL: التوكن القديم ما زال موجوداً'
  exit 1
fi
echo 'REMOTE UPDATED: token قديم اختفى، جديد مكانها'
# تحقق أن التوكن يعمل (fetch آمن):
git fetch origin 2>&1 | head -3
echo "FETCH_EXIT=$?"
echo "===== جاهز لـmission22 ====="
