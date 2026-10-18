#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL
echo "===== M11: لماذا match يرجع 0؟ ====="
grep -n -A25 'ASTNode::Match' src/nir/src/lowering.rs | head -50
echo "===== M12: أين يُعالج Question ؟ ====="
grep -n 'Question' src/lexer/src/lib.rs src/parser/src/lib.rs | head -10
echo "===== END ====="
