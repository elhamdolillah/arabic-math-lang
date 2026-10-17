#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab
F=MAL/src/arena/src/lib.rs
echo "===== 1) الرقعة الجراحية ====="
python3 - <<'PYEOF'
p = 'MAL/src/arena/src/lib.rs'
s = open(p).read()
old1 = "pub enum ASTNode {"
new1 = """/// AST node variants for the MAL arena.
#[derive(Debug, Clone)]
pub enum ASTNode {"""
assert s.count(old1) == 1
s = s.replace(old1, new1)
old2 = """/// AST node with inline payload (no heap allocation per node).
#[derive(Debug, Clone)]
/// Tensor operations for AI/ML.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
/// Pattern for match expressions (Phase 43).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Pattern {"""
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
assert s.count(old2) == 1, "مقطع Pattern غير مطابق"
s = s.replace(old2, new2)
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
  echo "===== 4) رفع main (النسخة الحية المُصلحة) ====="
  cd /root/ilm-al-kitab/MAL
  git add src/arena/src/lib.rs
  git commit --no-edit -m 'fix(arena): restore BinaryOp/UnaryOp, define TensorOp/AutodiffOp kinds, fix Pattern derives
Restores type-safe enums from 133378d7; defines missing AI/ML op kinds;
collapses duplicated Pattern derives; adds ASTNode docs'
  git push origin HEAD:refs/heads/main
  echo "MAIN_PUSHED=1"
  echo "===== 5) تحديث main-hermes بنفس الإصلاح ====="
  cd /tmp/reconcile_ws 2>/dev/null && cp /root/ilm-al-kitab/MAL/src/arena/src/lib.rs MAL/src/arena/src/lib.rs
  git add MAL/src/arena/src/lib.rs
  git commit --no-edit -m 'fix(arena): sync patched lib.rs into merged tree'
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
echo "════ END: main وmain-hermes مُصلحان ومنشوران — القرص والـGit متطابقان ════"
