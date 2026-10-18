#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native
export BIN
# ===== 1) تشخيص: أين الـmatch الشامل فعلاً =====
echo "===== LOCATE TypeTag::Empty ====="
grep -rn 'TypeTag::Empty' src/ | head -10
echo "===== CONTEXT ====="
F=$(grep -rln 'ASTNode::Empty => TypeTag::Empty' src/ | head -1)
echo "FILE=$F"
if [ -n "$F" ]; then
  L=$(grep -n 'ASTNode::Empty => TypeTag::Empty' "$F" | head -1 | cut -d: -f1)
  sed -n "$((L-2)),$((L+6))p" "$F"
fi
# ===== 2) رقعة type_inference الصحيحة (في الملف الذي يُعثر فيه) =====
python3 <<'PYEOF'
import sys, subprocess
NL = chr(10)
out = subprocess.run(['grep','-rln','ASTNode::Empty => TypeTag::Empty','src/'],
                     capture_output=True, text=True)
path = out.stdout.strip().splitlines()[0] if out.stdout.strip() else ''
if not path:
    sys.exit('CANNOT LOCATE match file')
print('MATCH FILE:', path)
with open(path, encoding='utf-8') as f:
    lines = f.readlines()
if any('ASTNode::If' in ln and 'TypeTag' in ln for ln in lines):
    print('SKIP (already applied):', path)
else:
    idx = None
    for i, ln in enumerate(lines):
        if 'ASTNode::Empty => TypeTag::Empty' in ln:
            idx = i
            break
    if idx is None:
        sys.exit('NEEDLE NOT FOUND in ' + path)
    indent = lines[idx][:len(lines[idx]) - len(lines[idx].lstrip())]
    lines.insert(idx + 1, indent + 'ASTNode::If { .. } => TypeTag::Empty,' + NL)
    lines.insert(idx + 2, indent + 'ASTNode::Return { .. } => TypeTag::Empty,' + NL)
    with open(path, 'w', encoding='utf-8') as f:
        f.writelines(lines)
    print('PATCHED:', path, 'at line', idx + 1)
# ===== parser + lowering (idempotent) =====
def patch_once(path, anchor, insertion, after=True):
    with open(path, encoding='utf-8') as f: s = f.read()
    marker = insertion.strip().splitlines()[0]
    if marker in s:
        print('SKIP (already applied):', path)
        return
    if s.count(anchor) != 1: sys.exit('ANCHOR FAIL in ' + path + ': count=' + str(s.count(anchor)))
    new = s.replace(anchor, anchor + insertion if after else insertion + anchor, 1)
    with open(path, 'w', encoding='utf-8') as f: f.write(new)
    print('PATCHED:', path)
patch_once('src/parser/src/lib.rs', '''            TokenKind::Print => {
''', '''            TokenKind::IfKeyword => {
                self.bump();
                let cond = self.parse_expr(arena)?;
                self.expect(TokenKind::Colon)?;
                let then_body = self.parse_stmt(arena)?;
                Ok(arena.allocate(ASTNode::If { cond, then_body })?)
            }
            TokenKind::ReturnKeyword => {
                self.bump();
                let value = self.parse_expr(arena)?;
                Ok(arena.allocate(ASTNode::Return { value })?)
            }
''', after=False)
patch_once('src/nir/src/lowering.rs', '''            ASTNode::Str(idx) => {
''', '''            ASTNode::Return { value } => {
                let v = self.lower_node(*value);
                if let Some(v) = v {
                    self.func.add_instruction(self.current_block,
                        NIRInstruction::Return { value: Some(v) });
                }
                None
            }
            ASTNode::If { cond, then_body } => {
                let c = self.lower_node(*cond);
                if let Some(c) = c {
                    let then_bb = self.func.fresh_block();
                    let else_bb = self.func.fresh_block();
                    let end_bb = self.func.fresh_block();
                    self.func.add_instruction(self.current_block,
                        NIRInstruction::CondBranch { cond: c, then_bb, else_bb });
                    self.current_block = then_bb;
                    self.lower_node(*then_body);
                    self.func.add_instruction(self.current_block,
                        NIRInstruction::Branch { target: end_bb });
                    self.current_block = else_bb;
                    self.func.add_instruction(self.current_block,
                        NIRInstruction::Branch { target: end_bb });
                    self.current_block = end_bb;
                }
                None
            }
''', after=False)
print('ALL PATCHES OK')
PYEOF
# ===== 3) بناء =====
set -e
CARGO_TARGET_DIR=/tmp/m2-target cargo build --release --manifest-path tools/malc-native/Cargo.toml
echo "BUILD_EXIT=$?"
# ===== 4) البوابة الميكانيكية =====
cat > /tmp/t5.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
cat > /tmp/t5_bad.mal <<'EOF'
إذا
EOF
set +e
$BIN /tmp/t5.mal -o /tmp/t5; COMPILE_EXIT=$?
/tmp/t5; T5_EXIT=$?
H1=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
$BIN /tmp/t5.mal -o /tmp/t5 && /tmp/t5; H2=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
$BIN /tmp/t5.mal -o /tmp/t5 && /tmp/t5; H3=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
$BIN /tmp/t5_bad.mal -o /tmp/t5_bad 2>&1; NEG_EXIT=$?
set -e
echo "COMPILE=$COMPILE_EXIT T5=$T5_EXIT NEG=$NEG_EXIT"
echo "H1=$H1"; echo "H2=$H2"; echo "H3=$H3"
if [ "$COMPILE_EXIT" -eq 0 ] && [ "$T5_EXIT" -eq 0 ] && [ "$NEG_EXIT" -ne 0 ] && [ -n "$H1" ] && [ "$H1" = "$H2" ] && [ "$H2" = "$H3" ]; then
  git add src/lexer/src/lib.rs src/parser/src/lib.rs src/arena/src/lib.rs src/nir/src/lowering.rs
  git diff --cached --stat
  git commit -m 'feat(lexer+parser+nir): إذا/أعد — gate t5
PROVEN_FOR_SCOPE: t5 (﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾ → exit 0), negative fail-closed, determinism x3'
  echo "T5_GATE_CLOSED=1"
else
  echo "ABORT: t5 not proven"
  exit 1
fi
# ===== 5) منع الانحدار: C2 + D =====
$BIN tests/gates/print_string_gate_c2.mal -o /tmp/pr && /tmp/pr; echo "C2=$?"
$BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fib && /tmp/fib; echo "D=$?"
git log --oneline -4
git status --short
