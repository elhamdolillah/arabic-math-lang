#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native
export BIN
# --- 1) اطبع السياق الحقيقي حول TypeTag::Empty ---
echo "===== CONTEXT: TypeTag::Empty ====="
grep -n 'TypeTag::Empty' src/nir/src/type_inference.rs
L=$(grep -n 'TypeTag::Empty' src/nir/src/type_inference.rs | head -1 | cut -d: -f1)
sed -n "$((L-2)),$((L+5))p" src/nir/src/type_inference.rs
# --- 2) رقعة مرنة: بحث بالاحتواء الجزئي ---
python3 <<'PYEOF'
import sys
NL = chr(10)
path = 'src/nir/src/type_inference.rs'
with open(path, encoding='utf-8') as f:
    lines = f.readlines()
if any('ASTNode::If' in ln and 'TypeTag' in ln for ln in lines):
    print('SKIP (already applied)')
    sys.exit(0)
idx = None
for i, ln in enumerate(lines):
    if 'TypeTag::Empty' in ln and 'ASTNode::Empty' in ln:
        idx = i
        break
if idx is None:
    for i, ln in enumerate(lines):
        if 'TypeTag::Empty' in ln:
            idx = i
            break
if idx is None:
    sys.exit('CANNOT LOCATE TypeTag::Empty')
indent = lines[idx][:len(lines[idx]) - len(lines[idx].lstrip())]
ins1 = indent + 'ASTNode::If { .. } => TypeTag::Empty,' + NL
ins2 = indent + 'ASTNode::Return { .. } => TypeTag::Empty,' + NL
lines.insert(idx + 1, ins1)
lines.insert(idx + 2, ins2)
with open(path, 'w', encoding='utf-8') as f:
    f.writelines(lines)
print('PATCHED type_inference at line', idx + 1)
PYEOF
# --- 3) parser + lowering (idempotent) ---
python3 <<'PYEOF'
import sys
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
# --- 4) بناء + بوابة ---
CARGO_TARGET_DIR=/tmp/m2-target cargo build --release --manifest-path tools/malc-native/Cargo.toml
echo "BUILD_EXIT=$?"
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
  git add src/lexer/src/lib.rs src/parser/src/lib.rs src/arena/src/lib.rs src/nir/src/lowering.rs src/nir/src/type_inference.rs
  git diff --cached --stat
  git commit -m 'feat(lexer+parser+nir): إذا/أعد — gate t5
PROVEN_FOR_SCOPE: t5 (﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾ → exit 0), negative fail-closed, determinism x3'
  echo "T5_GATE_CLOSED=1"
else
  echo "ABORT: t5 not proven"
  exit 1
fi
$BIN tests/gates/print_string_gate_c2.mal -o /tmp/pr && /tmp/pr; echo "C2=$?"
$BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fib && /tmp/fib; echo "D=$?"
git log --oneline -4
git status --short
