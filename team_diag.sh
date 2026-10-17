#!/bin/bash
cd /root/ilm-al-kitab/MAL

echo "════ Agent-C2: تشخيص printf/Str ════"
echo "--- Str في lowering ---"
grep -n "ASTNode::Str" src/nir/src/lowering.rs | head -5
echo "--- print_str في codegen ---"
grep -n -A 10 '"print_str"' src/native/src/lib.rs | head -15
echo "--- كيف يُخزَّن StrConst عند الاستدعاء ---"
grep -n "StrConst" src/nir/src/lowering.rs | head -5

echo ""
echo "════ Agent-D: تشخيص إذا/وإلا ════"
echo "--- موقع جدول الكلمات المفتاحية ---"
grep -n '"fn" | "FN"|"let"|=> TokenKind::Fn' src/lexer/src/lib.rs | head -5
grep -n '"when"' src/lexer/src/lib.rs
echo "--- بداية parse_stmt ---"
L=$(grep -n "fn parse_stmt" src/parser/src/lib.rs | head -1 | cut -d: -f1)
sed -n "${L},$((L+25))p" src/parser/src/lib.rs
echo "--- هل يوجد If/Else في TokenKind؟ ---"
grep -nE "If|Else" src/lexer/src/lib.rs | head -5
