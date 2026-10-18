#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) أين نحن الآن؟ ====="
git branch --show-current
git log --oneline -3
echo "===== 2) هل الـstash محفوظ؟ ====="
git stash list
echo "===== 3) حالة العمل ====="
git status --short | head -12
echo "===== 4) هل main.rs ما زال يحمل parse_with_fns؟ ====="
grep -n 'parse_with_fns' tools/malc-native/src/main.rs | head -3
echo "===== 5) هل تاريخا main منفصلان فعلاً؟ ====="
git merge-base main origin/main 2>&1 || true
echo "--- أول commit في main المحلي ---"
git log --oneline main | tail -3
echo "--- أول commit في origin/main ---"
git log --oneline origin/main | tail -3
echo "===== 6) مقارنة المحتوى الفعلي (لا التاريخ) ====="
git diff --stat main origin/main | tail -5
echo "===== END: تشخيص فقط — لا دمج، لا push، لا حذف ====="
