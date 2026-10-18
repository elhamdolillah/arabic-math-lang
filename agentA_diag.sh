#!/bin/bash
cd /root/ilm-al-kitab/MAL

echo "════ 1) خطأ المحاولة الأولى (if + return) ════"
cat > /tmp/fib1.mal <<'EOF'
fn fib(n) {
    if (n <= 1) {
        return n;
    }
    return fib(n - 1) + fib(n - 2);
}
fn main() -> i32 {
    return fib(10);
}
EOF
/tmp/m2-target/release/malc-native /tmp/fib1.mal -o /tmp/fib1 2>&1 | head -5

echo ""
echo "════ 2) رموز المقارنة في lexer ════"
grep -nE '"<"|"<="|">"|">="|≤|≥|Lt|Le|Gt|Ge' src/lexer/src/lib.rs | head -15

echo ""
echo "════ 3) parse_comparison كاملة ════"
sed -n '/fn parse_comparison/,/^    }/p' src/parser/src/lib.rs | head -45

echo ""
echo "════ 4) رموز Op في parser (أي رموز تقبلها المقارنة) ════"
grep -nE "TokenKind::(Lt|Le|Gt|Ge|Less|Greater)" src/parser/src/lib.rs | head -10
