#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native
export BIN
$BIN --help >/dev/null 2>&1; echo "BIN_CHECK=$?"
python3 <<'PYEOF'
import sys
def rep(path, old, new, label):
    with open(path, encoding='utf-8') as f: s = f.read()
    if new in s:
        print('SKIP:', label); return
    if s.count(old) != 1:
        sys.exit('FAIL [' + label + '] count=' + str(s.count(old)))
    with open(path, 'w', encoding='utf-8') as f:
        f.write(s.replace(old, new, 1))
    print('OK:', label)
# 1) استيراد Pattern في lowering
rep('src/nir/src/lowering.rs',
'''use mal_arena::{ASTNode, NodeID, BinaryOp, UnaryOp, Arena};''',
'''use mal_arena::{ASTNode, NodeID, BinaryOp, UnaryOp, Arena, Pattern};''',
'M1-import')
# 2) If يصبح بـelse_body
rep('src/arena/src/lib.rs',
'''    /// Conditional: إذا cond : body
    If {
        /// Condition expression.
        cond: NodeID,
        /// Body executed when condition is true.
        then_body: NodeID,
    },''',
'''    /// Conditional: إذا cond : body وإلا other
    If {
        /// Condition expression.
        cond: NodeID,
        /// Body executed when condition is true.
        then_body: NodeID,
        /// Body executed when condition is false (INVALID = none).
        else_body: NodeID,
    },''',
'M2-if-else')
# 3) parser: if يمرر else فارغ
rep('src/parser/src/lib.rs',
'''                let then_body = self.parse_stmt(arena)?;
                Ok(arena.allocate(ASTNode::If { cond, then_body })?)''',
'''                let then_body = self.parse_stmt(arena)?;
                Ok(arena.allocate(ASTNode::If { cond, then_body, else_body: NodeID::INVALID })?)''',
'M3-parser-if')
# 4) parser: ثلاثي ؟:
rep('src/parser/src/lib.rs',
'''    fn parse_expr(&mut self, arena: &mut Arena) -> Result<NodeID, ParserError> {
        self.parse_logical_or(arena)
    }''',
'''    fn parse_expr(&mut self, arena: &mut Arena) -> Result<NodeID, ParserError> {
        let cond = self.parse_logical_or(arena)?;
        if self.peek().map_or(false, |t| t.kind == TokenKind::Question) {
            self.bump();
            let then_v = self.parse_expr(arena)?;
            self.expect(TokenKind::Colon)?;
            let else_v = self.parse_expr(arena)?;
            return Ok(arena.allocate(ASTNode::If {
                cond,
                then_body: then_v,
                else_body: else_v,
            })?);
        }
        Ok(cond)
    }''',
'M4-ternary')
# 5) lowering: استبدال If القديم بنسخة تدعم else + إضافة Match
rep('src/nir/src/lowering.rs',
'''            ASTNode::If { cond, then_body } => {
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
            }''',
'''            ASTNode::If { cond, then_body, else_body } => {
                let c = match self.lower_node(*cond) {
                    Some(v) => v,
                    None => return None,
                };
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
                if else_body.0 != u32::MAX && else_body.0 != 0 {
                    self.lower_node(*else_body);
                }
                self.func.add_instruction(self.current_block,
                    NIRInstruction::Branch { target: end_bb });
                self.current_block = end_bb;
                None
            }
            ASTNode::Match { scrutinee, arms } => {
                let scr = match self.lower_node(*scrutinee) {
                    Some(v) => v,
                    None => return None,
                };
                let end_bb = self.func.fresh_block();
                let result = self.func.fresh_value(NIRValue::Undef);
                let mut lit_arms: Vec<(i64, NodeID)> = Vec::new();
                let mut default_body: Option<NodeID> = None;
                let mut cur = *arms;
                loop {
                    if cur.0 == u32::MAX { break; }
                    match self.arena.get(cur) {
                        Ok(ASTNode::List { head, tail }) => {
                            if let Ok(ASTNode::MatchArm { pattern, body }) = self.arena.get(*head) {
                                match pattern {
                                    Pattern::Literal(v) => lit_arms.push((*v, *body)),
                                    _ => default_body = Some(*body),
                                }
                            }
                            cur = *tail;
                        }
                        Ok(ASTNode::MatchArm { pattern, body }) => {
                            match pattern {
                                Pattern::Literal(v) => lit_arms.push((*v, *body)),
                                _ => default_body = Some(*body),
                            }
                            break;
                        }
                        _ => break,
                    }
                }
                let n = lit_arms.len();
                let mut cond_bbs = Vec::new();
                for _ in 0..n {
                    cond_bbs.push(self.func.fresh_block());
                }
                let default_bb = self.func.fresh_block();
                let mut chain_bb = self.current_block;
                for (i, (lit, _)) in lit_arms.iter().enumerate() {
                    let litv = self.func.fresh_value(NIRValue::IntConst(*lit));
                    let cond = self.func.fresh_value(NIRValue::Undef);
                    self.func.add_instruction(chain_bb,
                        NIRInstruction::BinOp {
                            op: NIROp::Eq, lhs: scr, rhs: litv, result: cond,
                        });
                    let else_bb = if i + 1 < n { cond_bbs[i + 1] } else { default_bb };
                    self.func.add_instruction(chain_bb,
                        NIRInstruction::CondBranch { cond, then_bb: cond_bbs[i], else_bb });
                    chain_bb = else_bb;
                }
                for (i, (_, body)) in lit_arms.iter().enumerate() {
                    self.current_block = cond_bbs[i];
                    if let Some(v) = self.lower_node(*body) {
                        self.func.add_instruction(self.current_block,
                            NIRInstruction::Move { value: v, result });
                    }
                    self.func.add_instruction(self.current_block,
                        NIRInstruction::Branch { target: end_bb });
                }
                self.current_block = default_bb;
                if let Some(db) = default_body {
                    if let Some(v) = self.lower_node(db) {
                        self.func.add_instruction(self.current_block,
                            NIRInstruction::Move { value: v, result });
                    }
                }
                self.func.add_instruction(self.current_block,
                    NIRInstruction::Branch { target: end_bb });
                self.current_block = end_bb;
                Some(result)
            }''',
'M5-match')
print('ALL PATCHES OK')
PYEOF
CARGO_TARGET_DIR=/tmp/m2-target cargo build --release --manifest-path tools/malc-native/Cargo.toml
echo "BUILD_EXIT=$?"
cat > /tmp/m11.mal <<'EOF'
match 5 with
| 5 => 9
| _ => 0
EOF
cat > /tmp/m12.mal <<'EOF'
﴿ س ≔ 5 ⋄ س < 10 ؟ 7 : 3 ﴾
EOF
cat > /tmp/t5.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
set +e
$BIN /tmp/m11.mal -o /tmp/m11 && /tmp/m11; M11=$?
$BIN /tmp/m12.mal -o /tmp/m12 && /tmp/m12; M12=$?
$BIN /tmp/t5.mal -o /tmp/t5v && /tmp/t5v; T5=$?
$BIN tests/gates/print_string_gate_c2.mal -o /tmp/pr && /tmp/pr; C2=$?
$BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fib && /tmp/fib; D=$?
set -e
echo "M11=$M11 (متوقع 9) M12=$M12 (متوقع 7) T5=$T5 (متوقع 0) C2=$C2 D=$D"
if [ "$M11" = "9" ] && [ "$M12" = "7" ] && [ "$T5" = "0" ] && [ "$C2" = "0" ]; then
  git add src/arena/src/lib.rs src/parser/src/lib.rs src/nir/src/lowering.rs
  git diff --cached --stat
  git commit -m 'feat(nir+parser): match value + ternary ؟: — M11/M12
PROVEN_FOR_SCOPE: match arm value (9), ternary (7), t5 regression (0), C2 (0)'
  echo "M11_M12_CLOSED=1"
else
  echo "ABORT: not proven"
  exit 1
fi
git log --oneline -3
