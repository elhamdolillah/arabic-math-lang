#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 0) تأكيد أن الـremote بلا token في URL ====="
git remote -v | grep -c 'ghp_' && echo 'STOP: remote ما زال يحمل token — حدّثه أولاً' && exit 1
echo "REMOTE CLEAN"
echo "===== 1) رفع main المحلي كفرع جديد (لا يمس origin/main) ====="
git push origin main:refs/heads/main-hermes
echo "MAIN_HERMES_PUSHED=1"
echo "===== 2) رفع سلسلة البوابات كفرع مدمج ====="
git checkout feat/if-return-gate-t5
git push origin feat/if-return-gate-t5:refs/heads/gates-c2-d-t5
echo "GATES_PUSHED=1"
echo "===== 3) التحقق ====="
git ls-remote --heads origin | grep -E 'main-hermes|gates-c2-d-t5|main'
echo "===== END: origin/main لم يُلمس ====="
