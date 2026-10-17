#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 0) حارس: تأكد أن التوكن القديم المكشوف لم يعد موجوداً ====="
if git remote -v | grep -q 'ghp_0gIgx'; then
  echo 'STOP: التوكن القديم ما زال في الـremote'
  exit 1
fi
echo 'REMOTE CLEAN — التوكن القديم اختفى'
echo "===== 1) رفع main المحلي كفرع جديد main-hermes ====="
git checkout main
git push origin main:refs/heads/main-hermes
echo "MAIN_HERMES_PUSHED=1"
echo "===== 2) رفع سلسلة البوابات كفرع gates-c2-d-t5 ====="
git checkout feat/if-return-gate-t5
git push origin feat/if-return-gate-t5:refs/heads/gates-c2-d-t5
echo "GATES_PUSHED=1"
echo "===== 3) التحقق النهائي من الفروع على GitHub ====="
git ls-remote --heads origin | grep -E 'main-hermes|gates-c2-d-t5|refs/heads/main'
echo "===== 4) حالة المترجم بعد كل شيء ====="
BIN=/tmp/m2-target/release/malc-native
cat > /tmp/final_check.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
set +e
$BIN /tmp/final_check.mal -o /tmp/final_check && /tmp/final_check; T5=$?
$BIN tests/gates/print_string_gate_c2.mal -o /tmp/pr && /tmp/pr; C2=$?
$BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fib && /tmp/fib; D=$?
set -e
echo "T5=$T5 (0) C2=$C2 (0) D=$D (55)"
echo "===== END: origin/main لم يُلمس — كل شيء محفوظ ====="
