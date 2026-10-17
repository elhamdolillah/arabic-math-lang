#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab
echo "===== 1) الرقعة بـregex ====="
python3 - <<'PYEOF'
import re, sys
p = 'MAL/src/arena/src/lib.rs'
s = open(p).read()
old1 = "pub enum ASTNode {"
new1 = "/// AST node variants for the MAL arena.
#[derive(Debug, Clone)]
pub enum ASTNode {"
assert s.count(old1) == 1, "ASTNode marker"
s = s.replace(old1, new1)
pat = re.compile(r"/// AST node with inline payload.*?pub enum Pattern {", re.DOTALL)
matches = pat.findall(s)
if len(matches) != 1:
    i = s.find('/// AST node with inline payload')
    print("REGION_START=", i)
    print(s[i-200:i+600] if i != -1 else "MARKER NOT FOUND")
    sys.exit(f"Pattern block matches={len(matches)}")
new2 = """/// Binary operators (type-safe, no magic numbers).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum BinaryOp {
    Add, Sub, Mul, Div, Mod, Pow, Concat,
    Lt, Gt, Le, Ge, Eq, Neq,
    And, Or,
    Assign,
}
/// Unary operator (type-safe, no magic numbers).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum UnaryOp {
    Neg, Not,
}
/// Tensor operation kinds (AI/ML).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TensorOpKind {
    MatMul, Add, Mul, Relu,
}
/// Automatic differentiation operation kinds.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum AutodiffOpKind {
    Grad, Value,
}
/// Pattern for match expressions (Phase 43).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Pattern {"""
s = pat.sub(new2, s, count=1)
open(p, 'w').write(s)
print("PATCH_APPLIED=1")
PYEOF
echo "===== 2) بناء نظيف ====="
rm -rf /tmp/fix_build
CARGO_TARGET_DIR=/tmp/fix_build cargo build --release \
  --manifest-path /root/ilm-al-kitab/MAL/tools/malc-native/Cargo.toml \
  > /tmp/fix_build.log 2>&1
echo "BUILD_RC=0"
tail -2 /tmp/fix_build.log
echo "===== 3) المسبار الخماسي ====="
BIN=/tmp/fix_build/release/malc-native
printf '﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
' > /tmp/final.mal
$BIN /tmp/final.mal -o /tmp/final && /tmp/final; T5=$?
$BIN /tmp/m11.mal -o /tmp/m11v && /tmp/m11v; M11=$?
printf '﴿ س ≔ 5 ⋄ س < 10 ؟ 7 : 3 ﴾
' > /tmp/m12v.mal
$BIN /tmp/m12v.mal -o /tmp/m12v && /tmp/m12v; M12=$?
$BIN MAL/tests/gates/print_string_gate_c2.mal -o /tmp/prv && /tmp/prv; C2=$?
$BIN MAL/tests/gates/fib_ar_gate_d.mal -o /tmp/fibv && /tmp/fibv; D=$?
echo "T5=$T5 (0) M11=$M11 (9) M12=$M12 (7) C2=$C2 (0) D=$D (55)"
if [ "$T5" = "0" ] && [ "$M11" = "9" ] && [ "$M12" = "7" ] && [ "$C2" = "0" ]; then
  echo "===== 4) رفع main ====="
  cd /root/ilm-al-kitab/MAL
  git add src/arena/src/lib.rs
  git commit --no-edit -m 'fix(arena): restore BinaryOp/UnaryOp, define TensorOp/AutodiffOp kinds, fix Pattern derives'
  git push origin HEAD:refs/heads/main
  echo "MAIN_PUSHED=1"
  echo "===== 5) تحديث main-hermes ====="
  if [ -d /tmp/reconcile_ws ]; then
    cd /tmp/reconcile_ws
    cp /root/ilm-al-kitab/MAL/src/arena/src/lib.rs MAL/src/arena/src/lib.rs
    git add MAL/src/arena/src/lib.rs
    git commit --no-edit -m 'fix(arena): sync patched lib.rs into merged tree'
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
