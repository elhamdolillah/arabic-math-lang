#!/bin/bash
cd /root/ilm-al-kitab/MAL

echo "════ 1) هل lowering يعالج Match أصلاً؟ ════"
grep -n "Match" src/nir/src/lowering.rs | head -10

echo ""
echo "════ 2) بنية Pattern (لأنواع الأنماط) ════"
grep -rn "enum Pattern" src/parser/src/ | head -3
L=$(grep -rn "pub enum Pattern" src/parser/src/ | head -1 | cut -d: -f2)
F=$(grep -rln "pub enum Pattern" src/parser/src/)
sed -n "${L},$((L+20))p" "$F"

echo ""
echo "════ 3) parse_pattern (كيف تُستخرج الأنماط) ════"
sed -n '/fn parse_pattern/,/^    }/p' src/parser/src/lib.rs

echo ""
echo "════ 4) Match في AST ════"
grep -n -A 5 "Match {" src/arena/src/lib.rs | head -15
grep -n -A 4 "MatchArm" src/arena/src/lib.rs | head -10

echo ""
echo "════ 5) codegen: CondBranch وBranch (هل جاهزان؟) ════"
grep -n -A 8 "CondBranch {" src/native/src/lib.rs | head -20
grep -n -A 3 "NIRInstruction::Branch" src/native/src/lib.rs | head -8
