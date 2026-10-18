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
rep('src/nir/src/lowering.rs',
'''                self.current_block = then_bb;
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
            }''',
'''                let result = self.func.fresh_value(NIRValue::Undef);
                self.current_block = then_bb;
                if let Some(v) = self.lower_node(*then_body) {
                    self.func.add_instruction(self.current_block,
                        NIRInstruction::Move { value: v, result });
                }
                self.func.add_instruction(self.current_block,
                    NIRInstruction::Branch { target: end_bb });
                self.current_block = else_bb;
                if else_body.0 != u32::MAX && else_body.0 != 0 {
                    if let Some(v) = self.lower_node(*else_body) {
                        self.func.add_instruction(self.current_block,
                            NIRInstruction::Move { value: v, result });
                    }
                }
                self.func.add_instruction(self.current_block,
                    NIRInstruction::Branch { target: end_bb });
                self.current_block = end_bb;
                Some(result)
            }''',
'M6-if-value')
print('ALL PATCHES OK')
PYEOF
CARGO_TARGET_DIR=/tmp/m2-target cargo build --release --manifest-path tools/malc-native/Cargo.toml
echo "BUILD_EXIT=$?"
cat > /tmp/m12.mal <<'EOF'
﴿ س ≔ 5 ⋄ س < 10 ؟ 7 : 3 ﴾
EOF
cat > /tmp/m11.mal <<'EOF'
match 5 with
| 5 => 9
| _ => 0
EOF
cat > /tmp/t5.mal <<'EOF'
﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾
EOF
cat > /tmp/m7.mal <<'EOF'
﴿ إذا 0 : ﴿ أعد 0 ﴾ ﴾ ⋄ 1
EOF
set +e
$BIN /tmp/m12.mal -o /tmp/m12 && /tmp/m12; M12=$?
$BIN /tmp/m11.mal -o /tmp/m11 && /tmp/m11; M11=$?
$BIN /tmp/t5.mal -o /tmp/t5v && /tmp/t5v; T5=$?
$BIN /tmp/m7.mal -o /tmp/m7 && /tmp/m7; M7=$?
$BIN tests/gates/print_string_gate_c2.mal -o /tmp/pr && /tmp/pr; C2=$?
$BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fib && /tmp/fib; D=$?
set -e
echo "M12=$M12 (7) M11=$M11 (9) T5=$T5 (0) M7=$M7 (1) C2=$C2 (0) D=$D (55)"
if [ "$M12" = "7" ] && [ "$M11" = "9" ] && [ "$T5" = "0" ] && [ "$M7" = "1" ] && [ "$C2" = "0" ]; then
  git add src/nir/src/lowering.rs
  git diff --cached --stat
  git commit -m 'feat(nir): إذا كتعبير — قيمة الفرع المتخذ (M12 ternary=7)
PROVEN_FOR_SCOPE: ternary (7), match (9), t5 (0), if-false-fallthrough (1), C2 (0)'
  echo "M12_CLOSED=1"
else
  echo "ABORT: not proven"
  exit 1
fi
git log --oneline -3
