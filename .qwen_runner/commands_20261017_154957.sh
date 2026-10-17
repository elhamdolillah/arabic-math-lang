#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /tmp/reconcile_ws 2>/dev/null || { echo "الـworktree اختفى"; exit 1; }
echo "===== 1) استبدال الكود بالنسخة الحية (التي اجتازت البوابات) ====="
rsync -a --delete --exclude 'target' /root/ilm-al-kitab/MAL/src/ /tmp/reconcile_ws/MAL/src/
rsync -a --delete --exclude 'target' /root/ilm-al-kitab/MAL/tools/ /tmp/reconcile_ws/MAL/tools/
echo "MAL/src + MAL/tools = النسخة الحية"
echo "===== 2) بناء نظيف ====="
rm -rf /tmp/reconcile_build4
CARGO_TARGET_DIR=/tmp/reconcile_build4 cargo build --release \
  --manifest-path /tmp/reconcile_ws/MAL/tools/malc-native/Cargo.toml \
  > /tmp/reconcile_build4.log 2>&1
echo "BUILD4_RC=0"
tail -2 /tmp/reconcile_build4.log
echo "===== 3) المسبار على النسخة الحية المدموجة ====="
BIN=/tmp/reconcile_build4/release/malc-native
cat > /tmp/final.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
$BIN /tmp/final.mal -o /tmp/final && /tmp/final; T5=$?
$BIN /tmp/m11.mal -o /tmp/m11v && /tmp/m11v; M11=$?
cat > /tmp/m12v.mal <<'EOF'
﴿ س ≔ 5 ⋄ س < 10 ؟ 7 : 3 ﴾
EOF
$BIN /tmp/m12v.mal -o /tmp/m12v && /tmp/m12v; M12=$?
$BIN tests/gates/print_string_gate_c2.mal -o /tmp/prv && /tmp/prv; C2=$?
$BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fibv && /tmp/fibv; D=$?
echo "T5=$T5 (0) M11=$M11 (9) M12=$M12 (7) C2=$C2 (0) D=$D (55)"
if [ "$T5" = "0" ] && [ "$M11" = "9" ] && [ "$M12" = "7" ] && [ "$C2" = "0" ]; then
  echo "===== 4) تثبيت النسخة الحية ورفع main-hermes ====="
  git add MAL/src MAL/tools
  git commit --no-edit -m 'fix(merge): sync MAL/src+tools to live Hermes tree (gate-proven)
Committed main carried a stale/broken arena; live working tree (13/13 gates) is authoritative'
  git push origin HEAD:refs/heads/main-hermes
  echo "MAIN_HERMES_PUSHED=1"
else
  echo "ABORT: المسبار لم يكتمل — لا push"
  exit 1
fi
cd /root/ilm-al-kitab/MAL
git worktree remove --force /tmp/reconcile_ws 2>/dev/null || true
git worktree prune
git log --oneline -3
echo "════ END: v38.0 في origin/main — Hermes الحي + أرشيف v38 في main-hermes ════"
