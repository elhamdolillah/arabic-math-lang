#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) REMOTE ====="
git remote -v
echo "===== 2) FETCH (آمن — لا يعدل شيئاً) ====="
git fetch --all 2>&1 | head -10
echo "===== 3) الفروع المحلية vs البعيدة ====="
git branch -vv
echo "===== 4) commits محلية غير مرفوعة ====="
for b in main master feat/fib-gate-d feat/print-string-gate-c2 fix/c2-greeting-spelling fix/c2-greeting-spelling-2 feat/if-return-gate-t5; do
  if git rev-parse --verify "$b" >/dev/null 2>&1; then
    UP=$(git rev-parse --abbrev-ref "$b@{upstream}" 2>/dev/null || echo "NO-UPSTREAM")
    echo "--- $b (upstream: $UP) ---"
    if [ "$UP" != "NO-UPSTREAM" ]; then
      git log --oneline "$UP..$b" | head -10
    else
      git log --oneline -5 "$b"
    fi
  fi
done
echo "===== 5) هل main/master يحتوي بواباتنا؟ ====="
for b in main master; do
  if git rev-parse --verify "$b" >/dev/null 2>&1; then
    echo "--- $b ---"
    git log --oneline -5 "$b"
    echo "يحتوي 5e95427a؟ $(git merge-base --is-ancestor 5e95427a "$b" 2>/dev/null && echo YES || echo NO)"
    echo "يحتوي 6e0a7c7c؟ $(git merge-base --is-ancestor 6e0a7c7c "$b" 2>/dev/null && echo YES || echo NO)"
    echo "يحتوي 14b8a5b6؟ $(git merge-base --is-ancestor 14b8a5b6 "$b" 2>/dev/null && echo YES || echo NO)"
  fi
done
echo "===== 6) حالة العمل غير الملتزم ====="
git status --short | head -15
