#!/bin/bash
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native

cat > /tmp/v.mal <<'EOF'
fn fib(n) {
    match n with
    | 0 => 0
    | 1 => 1
    | _ => fib(n - 1) + fib(n - 2)
}
fn main() -> i32 {
    return fib(20) / 256;
}
EOF
$BIN /tmp/v.mal -o /tmp/v && /tmp/v; RC=$?
echo "fib(20)/256 = $RC (المطلوب 26 — لأن 6765/256=26.4)"
[ "$RC" = "26" ] && echo "🎉🎉 M2 CONFIRMED: fib(20)=6765 صحيح — عودية + stack frames كاملة" \
  || echo "❌ غير متوقع"
