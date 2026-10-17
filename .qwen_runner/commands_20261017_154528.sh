#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /tmp/reconcile_ws 2>/dev/null || { echo "الـworktree اختفى — أعد mission28b"; exit 1; }
echo "===== 1) استعادة كود المترجم من Hermes (ours) ====="
git checkout main -- MAL/src
echo "MAL/src = Hermes compiler"
echo "===== 2) بناء بعد الإصلاح ====="
CARGO_TARGET_DIR=/tmp/reconcile_build cargo build --release \
  --manifest-path /tmp/reconcile_ws/MAL/tools/malc-native/Cargo.toml \
  > /tmp/reconcile_build2.log 2>&1
BUILD_RC=$?
echo "BUILD_RC=$BUILD_RC"
tail -3 /tmp/reconcile_build2.log
[ "$BUILD_RC" -ne 0 ] && { echo "ABORT: ما زال يفشل — أرسل /tmp/reconcile_build2.log"; exit 1; }
echo "===== 3) اختبارات ====="
CARGO_TARGET_DIR=/tmp/reconcile_build cargo test --release \
  --manifest-path /tmp/reconcile_ws/MAL/tools/malc-native/Cargo.toml \
  > /tmp/reconcile_test2.log 2>&1
TEST_RC=$?
echo "TEST_RC=$TEST_RC"
tail -5 /tmp/reconcile_test2.log
echo "===== 4) المسبار على الناتج المدموج ====="
BIN=/tmp/reconcile_build/release/malc-native
cat > /tmp/final.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
set +e
$BIN /tmp/final.mal -o /tmp/final && /tmp/final; T5=$?
$BIN /tmp/m11.mal -o /tmp/m11v 2>/dev/null && /tmp/m11v; M11=$?
cat > /tmp/m12v.mal <<'EOF'
﴿ س ≔ 5 ⋄ س < 10 ؟ 7 : 3 ﴾
EOF
$BIN /tmp/m12v.mal -o /tmp/m12v && /tmp/m12v; M12=$?
$BIN tests/gates/print_string_gate_c2.mal -o /tmp/prv && /tmp/prv; C2=$?
$BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fibv && /tmp/fibv; D=$?
set -e
echo "T5=$T5 (0) M11=$M11 (9) M12=$M12 (7) C2=$C2 (0) D=$D (55)"
if [ "$T5" = "0" ] && [ "$M11" = "9" ] && [ "$M12" = "7" ] && [ "$C2" = "0" ]; then
  echo "===== 5) تثبيت الإصلاح ورفع main-hermes ====="
  git add MAL/src
  git commit --no-edit -m 'fix(merge): MAL/src = Hermes compiler (semantic conflict resolution)
v38 compiler code preserved in origin/main; merged tree uses live Hermes compiler'
  git push origin HEAD:refs/heads/main-hermes
  echo "MAIN_HERMES_PUSHED=1"
else
  echo "ABORT: المسبار لم يكتمل على الدمج — لا push"
  exit 1
fi
cd /root/ilm-al-kitab/MAL
git worktree remove --force /tmp/reconcile_ws 2>/dev/null || true
git worktree prune
git log --oneline -3
echo "════ END: v38.0 سليم في origin/main — Hermes+v38 docs منشور في main-hermes ════"
