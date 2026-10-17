export GIT_PAGER=cat PAGER=cat
cd /root/ilm-al-kitab/MAL || exit 1
# --- 0) تحديد مسار المترجم الفعلي وإصلاح BIN ---
ls -la /tmp/m2-target/release/malc-native 2>/dev/null
BIN=/tmp/m2-target/release/malc-native
export BIN
$BIN --help 2>&1 | head -3; echo "BIN_CHECK=$?"
# إذا BIN_CHECK != 0: ابحث عن الثنائي:
find /tmp/m2-target/release -maxdepth 1 -type f -executable 2>/dev/null
# --- 1) نقل commit C2 من فرع t5 إلى فرعه الصحيح ---
# الـcommit 83878ccb (ملف C2) على t5 بالخطأ — انقله:
git checkout fix/c2-greeting-spelling-2
git cherry-pick 83878ccb
# ثم أزل الـcommit من t5 (mixed reset يحفظ تعديلات lexer/main.rs في working tree):
git checkout feat/if-return-gate-t5
git reset HEAD~1
git log --oneline -3
# المتوقع: t5 HEAD = 384755f7، وc2 branch يحتوي 83878ccb (أو نسخته cherry-picked)
# --- 2) C2: اختبر الآن بـBIN الصحيح ---
cp tests/gates/print_string_gate_c2.mal /tmp/pr.mal
$BIN /tmp/pr.mal -o /tmp/pr; echo "COMPILE_EXIT=$?"
/tmp/pr; echo "C2_EXIT=$?"
for i in 1 2 3; do
  $BIN /tmp/pr.mal -o /tmp/pr && /tmp/pr; echo "EXIT=$?"; sha256sum /tmp/pr
done
# شرط نجاح C2: الخرج "مرحباً MAL" وC2_EXIT=0 وبصمات متطابقة ×3
# --- 3) t5: أكمل قراءة البنية قبل الرقعة ---
# اقرأ نقطة دخول parser وكيف تُبنى العبارات المتتالية:
grep -n 'pub fn parse' src/parser/src/lib.rs
sed -n '380,460p' src/parser/src/lib.rs
# اقرأ ASTNode المتاح:
grep -n 'pub enum ASTNode' -A 40 src/arena/src/lib.rs 2>/dev/null || grep -rn 'pub enum ASTNode' src/ | head -3
# اقرأ lowering: كيف تُخفض العبارات المتتالية والكتل:
sed -n '1,120p' src/nir/src/lowering.rs
# اقرأ native: كيف يولّد CondBranch فعلياً:
sed -n '190,280p' src/native/src/lib.rs
# --- 4) t5: صمّم الرقعة بناءً على 3 — لا تخمّن ---
# المطلوب:
# a) lexer: إضافة IfKeyword وReturnKeyword (كلمات عربية أو رموز حسب هوية MAL)
# b) parser: parse_stmt يتعرف على if/return ويبني ASTNode::If / ASTNode::Return
# c) arena: إضافة ASTNode::If { cond, then_body, else_body } و ASTNode::Return { value }
# d) lowering: If → CondBranch + كتل NIR؛ Return → NIRInstruction::Return
# e) native: CondBranch موجود أصلاً (سطر 210) — تأكد فقط من التدفق
# طبّق الرقعة chr-safe، ثم:
CARGO_TARGET_DIR=/tmp/m2-target cargo build --release --manifest-path tools/malc-native/Cargo.toml
echo "BUILD_EXIT=$?"
# إذا BUILD_EXIT != 0: أصلح. 3 محاولات فاشلة = توقف وأبلغ.
# --- 5) t5: اكتب الاختبار بصياغة MAL الحقيقية المكتشفة في الخطوة 3 ---
# مثال مرجعي فقط — عدّله حسب النحو الفعلي:
cat > /tmp/t5.mal <<'EOF'
# الصياغة الفعلية تُكتب هنا بعد قراءة parser وlowering
EOF
$BIN /tmp/t5.mal -o /tmp/t5; echo "COMPILE_EXIT=$?"
# إذا COMPILE_EXIT != 0: أصلح الرقعة أو الاختبار. لا تكمل.
/tmp/t5; echo "T5_EXIT=$?"
# شرط النجاح: T5_EXIT=0
# --- 6) t5: حتمية x3 ---
for i in 1 2 3; do
  $BIN /tmp/t5.mal -o /tmp/t5 && /tmp/t5; echo "EXIT=$?"; sha256sum /tmp/t5
done
# شرط: البصمات الثلاث متطابقة
# --- 7) t5: اختبار سلبي ---
cat > /tmp/t5_bad.mal <<'EOF'
# مدخل غير صالح مؤكد — يُكتب بعد قراءة parser
EOF
$BIN /tmp/t5_bad.mal -o /tmp/t5_bad; echo "NEG_EXIT=$?"
# المتوقع: NEG_EXIT != 0
# --- 8) t5: commit فقط بعد نجاح 5 و6 و7 ---
git diff --check
git add src/lexer/src/lib.rs src/parser/src/lib.rs \
        src/arena/src/lib.rs src/nir/src/lib.rs src/nir/src/lowering.rs \
        src/native/src/lib.rs tools/malc-native/src/main.rs
git diff --cached --stat
git commit -m 'feat(parser+native): if/return — gate t5
PROVEN_FOR_SCOPE: t5 (positive exit=0, negative fail-closed, determinism x3)'
# --- 9) تقرير نهائي ---
git log --oneline -6
git status --short
