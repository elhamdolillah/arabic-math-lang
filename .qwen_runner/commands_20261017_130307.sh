#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab
echo "===== 1) محتوى السكربتات المجهولة ====="
for f in agentA_diag.sh agentB2.sh agentB3.sh agentB4.sh agentB5.sh agentB_fib.sh agentC_diag.sh agentC_patch.py autodrive.sh autodrive2.sh autodrive3.sh team_diag.sh team_launch.py team_launch2.py verify_m2.sh m2_test.sh fix_m2.py fix_m2_iso.py apply_m2.py apply_m2_iso.py; do
  if [ -f "$f" ]; then
    echo "----- FILE: $f ($(wc -l < "$f") lines) -----"
    head -40 "$f"
    echo ""
  fi
done
echo "===== 2) الملفات الغريبة بأسماء كود مكسور ====="
for f in "To" "TokenKind::LBlock," "TokenKind::RBlock,; assert old in s; s=s.replace(old,new,1); open(p,'w',encoding='utf-8').write(s); print('PATCHED OK')" "TokenKind::RBlock,; new=old+" "tatus --short"; do
  if [ -f "$f" ]; then
    echo "----- FILE: $f -----"
    head -10 "$f"
    echo ""
  fi
done
echo "===== 3) من أضاف commits Neuro-Symbolic إلى main؟ ====="
for h in 84b1c6eb a5bded2c adda47f0 3f246346 0180196b; do
  echo "----- COMMIT $h -----"
  git show --format=fuller --stat --no-patch "$h" 2>/dev/null | head -15
done
echo "===== 4) هل main يُبنى أصلاً؟ (فحص فقط، في target منفصل) ====="
cd /root/ilm-al-kitab/MAL
git stash list | head -5
git status --short | head -8
CARGO_TARGET_DIR=/tmp/main-build-check cargo build --release --manifest-path tools/malc-native/Cargo.toml 2>&1 | tail -5
echo "MAIN_BUILD_EXIT=$?"
echo "===== 5) علاقة main بفروع البوابات ====="
git merge-base main feat/if-return-gate-t5 2>/dev/null && echo "COMMON-ANCESTOR-FOUND" || echo "NO-COMMON-ANCESTOR"
git log --oneline main..feat/if-return-gate-t5 | head -10
echo "===== 6) ما الذي تغيّر في main.rs غير الملتزم؟ ====="
cd /root/ilm-al-kitab/MAL
git diff --stat tools/malc-native/src/main.rs
git diff tools/malc-native/src/main.rs | head -60
echo "===== END: لا دمج، لا push، لا stash — انتظار التحليل ====="
