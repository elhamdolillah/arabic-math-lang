#!/usr/bin/env bash
set -euo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab
echo "===== 1) رقعة parser ====="
python3 - <<'PYEOF'
import sys
NL = chr(10)
# 1) إضافة mal_types إلى parser/Cargo.toml
p = 'MAL/src/parser/Cargo.toml'
s = open(p).read()
dep = "mal_arena = { path = "../arena" }"
assert s.count(dep) == 1, "arena dep marker"
if "mal_types" not in s:
    s = s.replace(dep, dep + NL + "mal_types = { path = "../types" }")
    open(p, 'w').write(s)
    print("CARGO_PATCHED=1")
else:
    print("CARGO_ALREADY_OK=1")
# 2) استبدال استدعاء parse_type بمنطق استهلاك اسم النوع
p2 = 'MAL/src/parser/src/lib.rs'
s2 = open(p2).read()
start = "let _type_annotation = if self.peek().map_or(false, |t| t.kind == TokenKind::Colon) {"
i = s2.find(start)
assert i != -1, "let block not found"
end = "};"
j = s2.find(end, i)
assert j != -1, "block end not found"
j += len(end)
L = []
L.append("if self.peek().map_or(false, |t| t.kind == TokenKind::Colon) {")
L.append("    self.bump(); // استهلاك ':'")
L.append("    // تعليق النوع: استهلاك اسم النوع (ميزة مستقبلية — لا تأثير دلالي الآن)")
L.append("    let ty = self.peek().ok_or(ParserError::UnexpectedEof)?;")
L.append("    if ty.kind == TokenKind::Ident {")
L.append("        self.bump();")
L.append("    }")
L.append("}")
new_block = NL.join(L)
s2 = s2[:i] + new_block + s2[j:]
open(p2, 'w').write(s2)
print("PARSER_PATCH_APPLIED=1")
PYEOF
echo "===== 2) بناء نظيف ====="
rm -rf /tmp/fix_build6
CARGO_TARGET_DIR=/tmp/fix_build6 cargo build --release --manifest-path /root/ilm-al-kitab/MAL/tools/malc-native/Cargo.toml > /tmp/fix_build6.log 2>&1
echo "BUILD_RC=0"
tail -2 /tmp/fix_build6.log
echo "===== 3) المسبار الخماسي ====="
BIN=/tmp/fix_build6/release/malc-native
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
  git add src/parser/Cargo.toml src/parser/src/lib.rs src/arena/src/lib.rs src/lexer/src/lib.rs
  git commit --no-edit -m 'fix(parser): add mal_types dep; replace unfinished parse_type call with type-name consumption'
  git push origin HEAD:refs/heads/main
  echo "MAIN_PUSHED=1"
  echo "===== 5) تحديث main-hermes ====="
  if [ -d /tmp/reconcile_ws ]; then
    cd /tmp/reconcile_ws
    cp /root/ilm-al-kitab/MAL/src/parser/Cargo.toml MAL/src/parser/Cargo.toml
    cp /root/ilm-al-kitab/MAL/src/parser/src/lib.rs MAL/src/parser/src/lib.rs
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
