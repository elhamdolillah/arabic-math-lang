#!/bin/bash
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native

echo "════ 1) ماذا تطبع hello.mal؟ (نكتشف آلية الطباعة) ════"
cat examples/hello.mal
echo "--- تشغيل: ---"
$BIN examples/hello.mal -o /tmp/h && /tmp/h
echo ""

echo "════ 2) هل الثلاثية ؟: مدعومة؟ ════"
cat > /tmp/t1.mal <<'EOF'
fn main() {
    x ≔ 5
    y ≔ x < 10 ؟ 7 : 3
    print_int(y)
}
EOF
if $BIN /tmp/t1.mal -o /tmp/t1 2>/tmp/t1.err && /tmp/t1; then
  echo "✅ TERNARY WORKS"
else
  echo "❌ TERNARY FAILS:"; cat /tmp/t1.err
fi
echo ""

echo "════ 3) هل match مدعوم؟ ════"
cat > /tmp/t2.mal <<'EOF'
fn main() {
    x ≔ 5
    print_int(match x { 5 ⇒ 1, _ ⇒ 0 })
}
EOF
if $BIN /tmp/t2.mal -o /tmp/t2 2>/tmp/t2.err && /tmp/t2; then
  echo "✅ MATCH WORKS"
else
  echo "❌ MATCH FAILS:"; cat /tmp/t2.err
fi
echo ""

echo "════ 4) هل while مدعوم؟ ════"
cat > /tmp/t3.mal <<'EOF'
fn main() {
    i ≔ 0
    while (i < 3) {
        i ≔ i + 1
    }
    print_int(i)
}
EOF
if $BIN /tmp/t3.mal -o /tmp/t3 2>/tmp/t3.err && /tmp/t3; then
  echo "✅ WHILE WORKS"
else
  echo "❌ WHILE FAILS:"; cat /tmp/t3.err
fi
