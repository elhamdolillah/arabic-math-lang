cat > /root/ilm-al-kitab/duck.ai <<'SCRIPT'
#!/bin/bash
cd /root/ilm-al-kitab
echo "=== 1) أين يُعرَّف ASTNode؟ ==="
grep -rn "enum ASTNode" MAL/src/ | head -5
echo ""
echo "=== 2) محتوى الـ enum كاملاً ==="
F=$(grep -rln "enum ASTNode" MAL/src/types/src/ | head -1)
L=$(grep -n "enum ASTNode" $F | head -1 | cut -d: -f1)
sed -n "${L},$((L+60))p" $F
echo ""
echo "=== 3) كيف يتعامل NIR مع السلاسل Str ==="
grep -n "Str" MAL/src/nir/src/lowering.rs | head -10
grep -n "Str" MAL/src/nir/src/lib.rs | head -10
SCRIPT
bash /root/ilm-al-kitab/duck.ai 2>&1 | tee /tmp/duck.log
