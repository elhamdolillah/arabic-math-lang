#!/bin/bash
cd /root/ilm-al-kitab/MAL
BIN=/tmp/m2-target/release/malc-native

cat > /tmp/fibn.mal <<'EOF'
fn fib(n) {
    match n with
    | 0 => 0
    | 1 => 1
    | _ => fib(n - 1) + fib(n - 2)
}
fn main() -> i32 {
    return fib(N);
}
EOF

echo "n | ناتج | متوقع | الحكم"
echo "--|------|-------|------"
for N in 2 3 4 5 6 7 8 9 10 11 12 15 20; do
  sed "s/fib(N)/fib($N)/" /tmp/fibn.mal > /tmp/fibt.mal
  if $BIN /tmp/fibt.mal -o /tmp/fibt 2>/dev/null; then
    /tmp/fibt; RC=$?
  else
    RC="PARSE_ERR"
  fi
  EXP=$(awk -v n=$N 'BEGIN{a=0;b=1;for(i=1;i<n;i++){t=a+b;a=b;b=t} print b}')
  if [ "$RC" = "$EXP" ]; then J="✅"; else J="❌"; fi
  echo "$N | $RC | $EXP | $J"
done
