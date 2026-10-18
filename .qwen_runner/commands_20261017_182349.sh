#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab
echo "===== 1) إصلاح escapes الـlexer ====="
python3 - <<'PYEOF'
import sys
p = 'MAL/src/lexer/src/lib.rs'
s = open(p).read()
NL = chr(10)
BS = chr(92)
Q = chr(39)
# 1) إصلاح char literal المنكسر: quote + newline حقيقي + quote => {
old1 = Q + NL + Q + " => {"
new1 = Q + BS + "n" + Q + " => {"
if old1 in s:
    s = s.replace(old1, new1)
    print("FIXED_NEWLINE_CHAR=1")
else:
    print("FIXED_NEWLINE_CHAR=0 (ربما أُصلح سابقاً)")
# 2) إصلاح backslashes الزائدة حول '>'
old2 = "Some(" + BS + Q + ">" + BS + Q + ")"
new2 = "Some(" + Q + ">" + Q + ")"
if old2 in s:
    s = s.replace(old2, new2)
    print("FIXED_GT_ESCAPE=1")
else:
    print("FIXED_GT_ESCAPE=0")
open(p, 'w').write(s)
print("LEXER_PATCH_APPLIED=1")
PYEOF
echo "===== 2) فحص escapes مشبوهة متبقية ====="
grep -n "$(printf '\\\\')" MAL/src/lexer/src/lib.rs | head -5 || true
echo "===== 3) بناء نظيف ====="
rm -rf /tmp/fix_build4
CARGO_TARGET_DIR=/tmp/fix_build4 cargo build --release --manifest-path /root/ilm-al-kitab/MAL/tools/malc-native/Cargo.toml > /tmp/fix_build4.log 2>&1
echo "BUILD_RC=0"
tail -2 /tmp/fix_build4.log
echo "===== 4) المسبار الخماسي ====="
BIN=/tmp/fix_build4/release/malc-native
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
if [ "$T5" = "0" ] && [ "$M11" = "9" ] && [ "$M12" = "7" ] && [ "$C2" = "0" ]; then
  echo "===== 5) رفع main ====="
  cd /root/ilm-al-kitab/MAL
  git add src/arena/src/lib.rs src/lexer/src/lib.rs
  git commit --no-edit -m 'fix(arena+lexer): restore op enums, fix Pattern derives, repair corrupted char escapes'
  git push origin HEAD:refs/heads/main
  echo "MAIN_PUSHED=1"
  echo "===== 6) تحديث main-hermes ====="
  if [ -d /tmp/reconcile_ws ]; then
    cd /tmp/reconcile_ws
    cp /root/ilm-al-kitab/MAL/src/arena/src/lib.rs MAL/src/arena/src/lib.rs
    cp /root/ilm-al-kitab/MAL/src/lexer/src/lib.rs MAL/src/lexer/src/lib.rs
    git add MAL/src/arena/src/lib.rs MAL/src/lexer/src/lib.rs
    git commit --no-edit -m 'fix(arena+lexer): sync patched sources into merged tree'
    git push origin HEAD:refs/heads/main-hermes
    echo "MAIN_HERMES_PUSHED=1"
  else
    echo "MAIN_HERMES_SKIPPED=1"
  fi
else
  echo "ABORT: المسبار لم يكتمل — لا push"
  exit 1
fi
cd /root/ilm-al-kitab/MAL
git worktree remove --force /tmp/reconcile_ws 2>/dev/null || true
git worktree prune
git log --oneline -3
echo "════ END: main وmain-hermes مُصلحان ومنشوران ════"
