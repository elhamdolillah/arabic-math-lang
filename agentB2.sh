#!/bin/bash
cd /root/ilm-al-kitab/MAL

echo "════ 1) كيف يُعالج when في parser؟ ════"
grep -n "When" src/parser/src/lib.rs | head -10
L=$(grep -n "TokenKind::When" src/parser/src/lib.rs | head -1 | cut -d: -f1)
[ -n "$L" ] && sed -n "$((L-5)),$((L+30))p" src/parser/src/lib.rs

echo ""
echo "════ 2) parse_match كاملة (الصيغة الفعلية) ════"
sed -n '/fn parse_match/,/^    }/p' src/parser/src/lib.rs | head -25

echo ""
echo "════ 3) أمثلة تستخدم when أو match ════"
grep -rln "when|match" examples/ 2>/dev/null | head -5
grep -rn "when|⇒|match" examples/*.mal 2>/dev/null | head -15

echo ""
echo "════ 4) تجربة when كشرط ════"
cat > /tmp/t4.mal <<'EOF'
fn main() -> i32 {
    x ≔ 5;
    when (x < 10) {
        return 7;
    }
    return 3;
}
EOF
/tmp/m2-target/release/malc-native /tmp/t4.mal -o /tmp/t4 2>&1 | head -3
