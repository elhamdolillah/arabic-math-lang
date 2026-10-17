#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) تنظيف أي مخلفات worktree سابقة ====="
git worktree list
git worktree prune
rm -rf /tmp/reconcile_ws
echo "CLEANED"
echo "===== 2) إنشاء worktree detached ====="
git worktree add --detach /tmp/reconcile_ws main
echo "ADD_EXIT=$?"
if [ ! -d /tmp/reconcile_ws ]; then
  echo "ABORT: worktree فشل مرة أخرى — أرسل النتيجة"
  exit 1
fi
cd /tmp/reconcile_ws
echo "WORKTREE OK: $(pwd)"
echo "===== 3) محاكاة الدمج ====="
set +e
git merge --allow-unrelated-histories --no-commit origin/main > /tmp/merge_sim.log 2>&1
SIM=$?
set -e
echo "SIM=$SIM"
if [ "$SIM" -ne 0 ]; then
  echo "===== تعارضات الملفات الأربعة ====="
  for f in .gitignore CHANGELOG.md CONSTITUTION.md ROADMAP.md; do
    echo "════════ $f ════════"
    grep -n -A25 '^<<<<<<<' "$f" | head -70
    echo ""
  done
else
  echo "الدمج نجح بلا تعارضات!"
fi
echo "════ END: عرض فقط — لا حل بعد ════"
