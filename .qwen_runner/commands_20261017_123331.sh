#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native
export BIN
# ===== 1) تنظيف تكرار lexer =====
python3 <<'PYEOF'
import sys
path = 'src/lexer/src/lib.rs'
with open(path, encoding='utf-8') as f:
    lines = f.readlines()
# أ) إزالة تكرار كتلة الـenum (احتفظ بأول ظهور)
block = ['    /// `إذا` conditional keyword.
', '    IfKeyword,
',
         '    /// `أعد` return keyword.
', '    ReturnKeyword,
']
seen = False
out = []
i = 0
while i < len(lines):
    if lines[i:i+4] == block:
        if seen:
            i += 4
            continue
        seen = True
    out.append(lines[i])
    i += 1
lines = out
# ب) إزالة تكرار ذراعي الكلمات المفتاحية
arms = ['                    "إذا" => TokenKind::IfKeyword,
',
        '                    "أعد" => TokenKind::ReturnKeyword,
']
seen = False
out = []
i = 0
while i < len(lines):
    if lines[i:i+2] == arms:
        if seen:
            i += 2
            continue
        seen = True
    out.append(lines[i])
    i += 1
lines = out
with open(path, 'w', encoding='utf-8') as f:
    f.writelines(lines)
print('LEXER DEDUPED')
PYEOF
# ===== 2) بناء — إن ظهر E0004 نطبع سياق الـmatch بدقة =====
set +e
CARGO_TARGET_DIR=/tmp/m2-target cargo build --release --manifest-path tools/malc-native/Cargo.toml 2>&1 | tee /tmp/build.log
BUILD_EXIT=$?
set -e
echo "BUILD_EXIT=$BUILD_EXIT"
if [ "$BUILD_EXIT" -ne 0 ]; then
  echo "===== E0004 DIAGNOSIS ====="
  grep -n 'match self' src/lexer/src/lib.rs
  grep -n -A6 'match self' src/lexer/src/lib.rs | head -60
  echo "===== ABORT: أرسل هذا المخرج للوكيل لإغلاق الـmatch ====="
  exit 1
fi
# ===== 3) البوابة الميكانيكية =====
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
# ===== 4) منع الانحدار =====
$BIN tests/gates/print_string_gate_c2.mal -o /tmp/pr && /tmp/pr; echo "C2=$?"
$BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fib && /tmp/fib; echo "D=$?"
git log --oneline -4
git status --short
