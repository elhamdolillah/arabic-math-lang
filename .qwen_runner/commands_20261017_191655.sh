#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) اعتماد arena الفرع الحي ====="
git checkout feat/if-return-gate-t5 -- src/arena/src/lib.rs
echo "ARENA_FROM_BRANCH=1"
echo "===== 2) تحقق سريع من المحتوى ====="
grep -c 'pub enum BinaryOp' src/arena/src/lib.rs
grep -c 'If {' src/arena/src/lib.rs
grep -c 'Return {' src/arena/src/lib.rs
grep -c 'enum Pattern' src/arena/src/lib.rs
echo "===== 3) بناء نظيف ====="
rm -rf /tmp/fix_build9
CARGO_TARGET_DIR=/tmp/fix_build9 cargo build --release --manifest-path /root/ilm-al-kitab/MAL/tools/malc-native/Cargo.toml > /tmp/fix_build9.log 2>&1
echo "BUILD_RC=0"
tail -2 /tmp/fix_build9.log
echo "===== 4) المسبار الخماسي ====="
BIN=/tmp/fix_build9/release/malc-native
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
  echo "===== 5) رفع main ====="
  git add src/arena/src/lib.rs
  git commit --no-edit -m 'merge: adopt branch arena (If/Return variants) completing live integration'
  git push origin HEAD:refs/heads/main
  echo "MAIN_PUSHED=1"
else
  echo "ABORT: المسبار لم يكتمل — لا push"
  exit 1
fi
git log --oneline -5
echo "════ END: main = Hermes الحي الكامل ════"
