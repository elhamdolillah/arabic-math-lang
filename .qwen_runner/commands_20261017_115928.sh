#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native
export BIN
$BIN --help >/dev/null 2>&1; echo "BIN_CHECK=$?"
python3 <<'PYEOF'
import sys
def patch(path, anchor, insertion, after=True):
    with open(path, encoding='utf-8') as f: s = f.read()
    marker = insertion.strip().splitlines()[0]
    if marker in s:
        print('SKIP (already applied):', path)
        return
    if s.count(anchor) != 1: sys.exit('ANCHOR FAIL in ' + path + ': count=' + str(s.count(anchor)))
    new = s.replace(anchor, anchor + insertion if after else insertion + anchor, 1)
    with open(path, 'w', encoding='utf-8') as f: f.write(new)
    print('PATCHED:', path)
patch('src/lexer/src/lib.rs', '''    /// semicolon
    Semicolon,
''', '''    /// `إذا` conditional keyword.
    IfKeyword,
    /// `أعد` return keyword.
    ReturnKeyword,
''')
patch('src/lexer/src/lib.rs', '''                    "match" => TokenKind::MatchKeyword,
''', '''                    "إذا" => TokenKind::IfKeyword,
                    "أعد" => TokenKind::ReturnKeyword,
''', after=False)
patch('src/arena/src/lib.rs', '''    /// Lambda: λ(params). body.
    Lambda {
        /// Parameters (as List of Ident nodes).
        params: NodeID,
        /// Body expression.
        body: NodeID,
    },
''', '''    /// Conditional: إذا cond : body
    If {
        /// Condition expression.
        cond: NodeID,
        /// Body executed when condition is true.
        then_body: NodeID,
    },
    /// Early return: أعد value
    Return {
        /// Returned value.
        value: NodeID,
    },
''')
patch('src/nir/src/type_inference.rs', '''            ASTNode::Empty => TypeTag::Empty,
''', '''            ASTNode::If { .. } => TypeTag::Empty,
            ASTNode::Return { .. } => TypeTag::Empty,
''')
patch('src/parser/src/lib.rs', '''            TokenKind::Print => {
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
patch('src/nir/src/lowering.rs', '''            ASTNode::Str(idx) => {
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
CARGO_TARGET_DIR=/tmp/m2-target cargo build --release --manifest-path tools/malc-native/Cargo.toml
echo "BUILD_EXIT=$?"
printf '%s
' '﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾' > /tmp/t5.mal
printf '%s
' 'إذا' > /tmp/t5_bad.mal
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
