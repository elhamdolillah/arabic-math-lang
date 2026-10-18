#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) المسبار الرباعي المثبت ====="
BIN=/tmp/fix_build12/release/malc-native
set +e
cat > /tmp/final.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
$BIN /tmp/final.mal -o /tmp/final && /tmp/final
T5=$?
$BIN /tmp/m11.mal -o /tmp/m11v && /tmp/m11v
M11=$?
$BIN tests/gates/print_string_gate_c2.mal -o /tmp/prv && /tmp/prv
C2=$?
$BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fibv && /tmp/fibv
D=$?
set -e
echo "T5=$T5 (0) M11=$M11 (9) C2=$C2 (0) D=$D (55)"
if [ "$T5" = "0" ] && [ "$M11" = "9" ] && [ "$C2" = "0" ] && [ "$D" = "55" ]; then
  echo "===== 2) رفع main ====="
  git add -A
  git commit --no-edit -m 'fix(cli): pass NIR function as slice; complete live compiler integration
Proven gates: t5(0), match(9), C2(0), D(55)'
  git push origin HEAD:refs/heads/main
  echo "MAIN_PUSHED=1"
  git log --oneline -5
  echo "════ END: main = الشجرة الحية المثبتة (t5+M11+C2+D) ════"
else
  echo "ABORT: البوابات لم تكتمل — لا push"
  exit 1
fi
