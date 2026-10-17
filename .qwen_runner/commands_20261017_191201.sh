#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) تثبيت إصلاحاتنا على main ====="
git add -A
git commit --no-edit -m 'fix: arena/lexer/parser repairs (pre-merge snapshot)' || echo "لا شيء للتثبيت"
echo "===== 2) دمج الفرع الحي ====="
set +e
git merge --no-edit feat/if-return-gate-t5 > /tmp/merge55.log 2>&1
MERGE_RC=$?
set -e
echo "MERGE_RC=$MERGE_RC"
if [ "$MERGE_RC" -ne 0 ]; then
  echo "===== 3) حل التعارضات: arena/lexer=ours، parser/nir/native/tests=theirs ====="
  git checkout --ours src/arena src/lexer 2>/dev/null || true
  git checkout --theirs src/parser src/nir src/native tests 2>/dev/null || true
  git add -A
  git commit --no-edit -m 'merge: integrate live feature branch (t5+C2+D) with repaired arena/lexer'
fi
echo "===== 4) بناء نظيف ====="
rm -rf /tmp/fix_build8
CARGO_TARGET_DIR=/tmp/fix_build8 cargo build --release --manifest-path /root/ilm-al-kitab/MAL/tools/malc-native/Cargo.toml > /tmp/fix_build8.log 2>&1
echo "BUILD_RC=0"
tail -2 /tmp/fix_build8.log
echo "===== 5) المسبار الخماسي ====="
BIN=/tmp/fix_build8/release/malc-native
cat > /tmp/final.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
$BIN /tmp/final.mal -o /tmp/final && /tmp/final; T5=$?
$BIN /tmp/m11.mal -o /tmp/m11v && /tmp/m11v; M11=$?
cat > /tmp/m12v.mal <<'EOF'
﴿ س ≔ 5 ⋄ س < 10 ؟ 7 : 3 ﴾
EOF
$BIN /tmp/m12v.mal -o /tmp/m12v && /tmp/m12v; M12=$?
$BIN MAL/tests/gates/print_string_gate_c2.mal -o /tmp/prv && /tmp/prv; C2=$?
$BIN MAL/tests/gates/fib_ar_gate_d.mal -o /tmp/fibv && /tmp/fibv; D=$?
echo "T5=$T5 (0) M11=$M11 (9) M12=$M12 (7) C2=$C2 (0) D=$D (55)"
if [ "$T5" = "0" ] && [ "$M11" = "9" ] && [ "$M12" = "7" ] && [ "$C2" = "0" ] && [ "$D" = "55" ]; then
  echo "===== 6) رفع main ====="
  git push origin HEAD:refs/heads/main
  echo "MAIN_PUSHED=1"
else
  echo "ABORT: المسبار لم يكتمل — لا push"
  exit 1
fi
git log --oneline -5
echo "════ END: main = Hermes الحي الكامل (t5+C2+D) ════"
