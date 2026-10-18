#!/bin/bash
BIN=/tmp/m2-target/release/malc-native

echo "════ اختبار 1: return مباشر ════"
cat > /tmp/x1.mal <<'EOF'
fn main() -> i32 {
    return 5;
}
EOF
$BIN /tmp/x1.mal -o /tmp/x1 2>/tmp/x1.err && /tmp/x1; echo "exit=$? (متوقع 5)"

echo ""
echo "════ اختبار 2: استدعاء دالة مستخدم ════"
cat > /tmp/x2.mal <<'EOF'
fn seven() {
    return 7;
}
fn main() -> i32 {
    return seven();
}
EOF
$BIN /tmp/x2.mal -o /tmp/x2 2>/tmp/x2.err && /tmp/x2; echo "exit=$? (متوقع 7)"

echo ""
echo "════ اختبار 3: match يعيد قيمة ════"
cat > /tmp/x3.mal <<'EOF'
fn main() -> i32 {
    return match 5 with
    | 5 => 9
    | _ => 0;
}
EOF
$BIN /tmp/x3.mal -o /tmp/x3 2>/tmp/x3.err && /tmp/x3; echo "exit=$? (متوقع 9)"

echo ""
echo "════ اختبار 4: match مع استدعاء عودي ════"
cat > /tmp/x4.mal <<'EOF'
fn fib(n) {
    match n with
    | 0 => 0
    | 1 => 1
    | _ => fib(n - 1) + fib(n - 2)
}
fn main() -> i32 {
    return fib(10);
}
EOF
$BIN /tmp/x4.mal -o /tmp/x4 2>/tmp/x4.err && /tmp/x4; echo "exit=$? (متوقع 55)"
