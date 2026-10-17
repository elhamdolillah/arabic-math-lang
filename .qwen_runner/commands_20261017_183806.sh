#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab
echo "===== 1) رقعة الاستعارة ====="
python3 - <<'PYEOF'
import sys
p = 'MAL/src/parser/src/lib.rs'
s = open(p).read()
NL = chr(10)
DQ = chr(34)
start = "let ident_tok = self.peek().ok_or(ParserError::UnexpectedEof)?;"
i = s.find(start)
assert i != -1, "start marker not found"
endm = "self.bump();"
j = s.find(endm, i)
assert j != -1, "bump not found"
j += len(endm)
L = []
L.append("let (ident_kind, ident_start, ident_line, ident_col) = {")
L.append("    let t = self.peek().ok_or(ParserError::UnexpectedEof)?;")
L.append("    (t.kind, t.start, t.line, t.col)")
L.append("};")
L.append("if ident_kind != TokenKind::Ident {")
L.append("    return Err(ParserError::Expected {")
L.append("        expected: " + DQ + "identifier" + DQ + ",")
L.append("        found: format!(" + DQ + "{:?}" + DQ + ", ident_kind),")
L.append("        line: ident_line,")
L.append("        col: ident_col,")
L.append("    });")
L.append("}")
L.append("self.bump();")
s = s[:i] + NL.join(L) + s[j:]
old_use = "ASTNode::Ident(ident_tok.start as u32)"
assert s.count(old_use) == 1, "ident use marker"
s = s.replace(old_use, "ASTNode::Ident(ident_start as u32)")
open(p, 'w').write(s)
print("BORROW_PATCH_APPLIED=1")
PYEOF
echo "===== 2) بناء نظيف ====="
rm -rf /tmp/fix_build7
CARGO_TARGET_DIR=/tmp/fix_build7 cargo build --release --manifest-path /root/ilm-al-kitab/MAL/tools/malc-native/Cargo.toml > /tmp/fix_build7.log 2>&1
echo "BUILD_RC=0"
tail -2 /tmp/fix_build7.log
echo "===== 3) المسبار الخماسي ====="
BIN=/tmp/fix_build7/release/malc-native
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
  git add src/parser/src/lib.rs src/parser/Cargo.toml src/arena/src/lib.rs src/lexer/src/lib.rs
  git commit --no-edit -m 'fix(parser): resolve borrow conflict in let-parsing; add mal_types dep; restore op enums'
  git push origin HEAD:refs/heads/main
  echo "MAIN_PUSHED=1"
  echo "===== 5) تحديث main-hermes ====="
  if [ -d /tmp/reconcile_ws ]; then
    cd /tmp/reconcile_ws
    cp /root/ilm-al-kitab/MAL/src/parser/src/lib.rs MAL/src/parser/src/lib.rs
    cp /root/ilm-al-kitab/MAL/src/parser/Cargo.toml MAL/src/parser/Cargo.toml
    cp /root/ilm-al-kitab/MAL/src/arena/src/lib.rs MAL/src/arena/src/lib.rs
    cp /root/ilm-al-kitab/MAL/src/lexer/src/lib.rs MAL/src/lexer/src/lib.rs
    git add MAL/src/parser MAL/src/arena/src/lib.rs MAL/src/lexer/src/lib.rs
    git commit --no-edit -m 'fix(parser+arena+lexer): sync patched sources into merged tree'
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
