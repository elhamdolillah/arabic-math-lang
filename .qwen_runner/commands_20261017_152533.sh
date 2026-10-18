#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
git worktree add --detach /tmp/reconcile_ws main 2>&1 | head -1
cd /tmp/reconcile_ws
set +e
git merge --allow-unrelated-histories --no-commit origin/main > /dev/null 2>&1
set -e
for f in .gitignore CHANGELOG.md CONSTITUTION.md ROADMAP.md; do
  echo "════════ $f ════════"
  grep -n -A20 '^<<<<<<<' "$f" | head -60
  echo ""
done
echo "════ END: لا حل بعد — نراجع السياسات أولاً ════"
