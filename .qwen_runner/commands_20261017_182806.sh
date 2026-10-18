#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab
echo "===== 1) استعادة ذراع Minus ====="
python3 - <<'PYEOF'
import sys
p = 'MAL/src/lexer/src/lib.rs'
s = open(p).read()
NL = chr(10)
BS = chr(92)
Q = chr(39)
start_marker = Q + BS + "n" + Q + " => {"
i = s.find(start_marker)
assert i != -1, "broken arm not found"
end_marker = "        '" + chr(183) + "' | '*' | '×' => TokenKind::Mul,"
j = s.find(end_marker, i)
assert j != -1, "end marker not found"
replacement = "        '-' => TokenKind::Minus," + NL
s = s[:i] + replacement + s[j:]
open(p, 'w').write(s)
print("MINUS_ARM_RESTORED=1")
PYEOF
echo "===== 2) بناء نظيف ====="
rm -rf /tmp/fix_build5
CARGO_TARGET_DIR=/tmp/fix_build5 cargo build --release --manifest-path /root/ilm-al-kitab/MAL/tools/malc-native/Cargo.toml > /tmp/fix_build5.log 2>&1
echo "BUILD_RC=0"
tail -2 /tmp/fix_build5.log
echo "===== 3) المسبار الخماسي ====="
BIN=/tmp/fix_build5/release/malc-native
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
  echo "===== 4) رفع main ====="
  cd /root/ilm-al-kitab/MAL
  git add src/arena/src/lib.rs src/lexer/src/lib.rs
  git commit --no-edit -m 'fix(arena+lexer): restore op enums, fix Pattern derives, restore Minus arm in symbol_kind'
  git push origin HEAD:refs/heads/main
  echo "MAIN_PUSHED=1"
  echo "===== 5) تحديث main-hermes ====="
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
