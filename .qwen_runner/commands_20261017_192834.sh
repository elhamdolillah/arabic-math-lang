#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== 1) مواءمة ذراع If في nir ====="
python3 - <<'PYEOF'
import sys
p = 'src/nir/src/lowering.rs'
s = open(p).read()
NL = chr(10)
# 1) تبسيط النمط
old1 = "ASTNode::If { cond, then_body, else_body } => {"
new1 = "ASTNode::If { cond, then_body } => {"
assert s.count(old1) == 1, "destructure marker"
s = s.replace(old1, new1)
# 2) else_bb يصبح end_bb مباشرة (لا else)
old2 = "let else_bb = self.func.fresh_block();"
assert s.count(old2) == 1, "else_bb marker"
s = s.replace(old2, "")
old3 = "NIRInstruction::CondBranch { cond: c, then_bb, else_bb });"
new3 = "NIRInstruction::CondBranch { cond: c, then_bb, else_bb: end_bb });"
assert s.count(old3) == 1, "condbranch marker"
s = s.replace(old3, new3)
# 3) حذف كتلة else بالكامل
L = []
L.append("                self.current_block = else_bb;")
L.append("                if else_body.0 != u32::MAX && else_body.0 != 0 {")
L.append("                    if let Some(v) = self.lower_node(*else_body) {")
L.append("                        self.func.add_instruction(self.current_block,")
L.append("                            NIRInstruction::Move { value: v, result });")
L.append("                    }")
L.append("                }")
old4 = NL.join(L)
assert old4 in s, "else block marker"
s = s.replace(old4 + NL, "")
open(p, 'w').write(s)
print("IF_ARM_ALIGNED=1")
PYEOF
echo "===== 2) بناء نظيف ====="
rm -rf /tmp/fix_build11
CARGO_TARGET_DIR=/tmp/fix_build11 cargo build --release --manifest-path /root/ilm-al-kitab/MAL/tools/malc-native/Cargo.toml > /tmp/fix_build11.log 2>&1
echo "BUILD_RC=0"
tail -2 /tmp/fix_build11.log
echo "===== 3) المسبار الخماسي ====="
BIN=/tmp/fix_build11/release/malc-native
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
  echo "===== 4) رفع main ====="
  git add -A
  git commit --no-edit -m 'fix(nir): align If lowering with arena (no else_body) — false falls through to end'
  git push origin HEAD:refs/heads/main
  echo "MAIN_PUSHED=1"
else
  echo "ABORT: المسبار لم يكتمل — لا push"
  exit 1
fi
git log --oneline -5
echo "════ END: main = الشجرة الحية المثبتة ════"
