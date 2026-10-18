#!/usr/bin/env bash
set -uo pipefail
export GIT_PAGER=cat PAGER=cat
# ===== 1) كتابة الـprompt في ملف =====
cat > /root/t5_mission.txt <<'MISSION_EOF'
أنت وكيل برمجي داخل VPS على المسار /root/ilm-al-kitab/MAL.
مهمتك: تنفيذ بوابة t5 (if/return) في مترجم MAL من البداية للنهاية، ذاتياً.
السياق المثبت:
- C2 مُغلق: tests/gates/print_string_gate_c2.mal يطبع «مرحباً MAL» exit=0 حتمية ×3.
- الفرع: feat/if-return-gate-t5، HEAD = 83878ccb.
- تعديلات غير ملتزمة في src/lexer/src/lib.rs وtools/malc-native/src/main.rs — احتفظ بها.
- المترجم: /tmp/m2-target/release/malc-native
- الصياغة المعتمدة: ﴿ إذا شرط : ﴿ أعد قيمة ﴾ ﴾
- NIR فيه CondBranch وBranch وReturn جاهزة.
- lexer يطابق الكلمات المفتاحية في فرع match text.
- parser: parse_stmt عند السطر 578.
- type_inference.rs فيه match شامل على ASTNode → TypeTag.
خطواتك:
1. اقرأ بنفسك: src/lexer/src/lib.rs، src/arena/src/lib.rs، src/parser/src/lib.rs، src/nir/src/lowering.rs، src/nir/src/type_inference.rs، src/native/src/lib.rs
2. اكتب رقعة Rust تضيف:
   - lexer: IfKeyword وReturnKeyword + مطابقة "إذا" و"أعد"
   - arena: ASTNode::If { cond, then_body } و ASTNode::Return { value } + arms في كل match شامل
   - parser: فرعا IfKeyword وReturnKeyword في parse_stmt
   - lowering: Return → NIRInstruction::Return؛ If → CondBranch + كتل + Branch
3. طبّق الرقعة ثم:
   CARGO_TARGET_DIR=/tmp/m2-target cargo build --release --manifest-path tools/malc-native/Cargo.toml
   إن فشل: أصلح، بحد 3 محاولات.
4. الاختبارات:
   printf '%s
' '﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾' > /tmp/t5.mal
   printf '%s
' 'إذا' > /tmp/t5_bad.mal
5. البوابة (لا تتجاوزها):
   BIN=/tmp/m2-target/release/malc-native
   $BIN /tmp/t5.mal -o /tmp/t5; COMPILE_EXIT=$?
   /tmp/t5; T5_EXIT=$?
   H1=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
   $BIN /tmp/t5.mal -o /tmp/t5 && /tmp/t5; H2=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
   $BIN /tmp/t5.mal -o /tmp/t5 && /tmp/t5; H3=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
   $BIN /tmp/t5_bad.mal -o /tmp/t5_bad 2>&1; NEG_EXIT=$?
   الشرط: COMPILE=0 و T5=0 و NEG≠0 و H1=H2=H3
   إن لم يتحقق: لا commit. أصلح وأعد، بحد 3 محاولات.
6. عند النجاح فقط:
   git add src/lexer/src/lib.rs src/parser/src/lib.rs src/arena/src/lib.rs src/nir/src/lowering.rs src/nir/src/type_inference.rs
   git commit -m 'feat(lexer+parser+nir): إذا/أعد — gate t5
PROVEN_FOR_SCOPE: t5 (positive exit=0, negative fail-closed, determinism x3)'
7. أعد تشغيل C2 وD:
   $BIN tests/gates/print_string_gate_c2.mal -o /tmp/pr && /tmp/pr; echo "C2=$?"
   $BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fib && /tmp/fib; echo "D=$?"
8. تقرير نهائي: الصياغة، الملفات المعدلة، أكواد الخروج، البصمات، هاش الـcommit، نتيجة C2 وD.
قواعد صارمة:
- لا تكتب PROVEN_FOR_SCOPE إلا بعد رؤية النتائج بنفسك.
- لا git add -A ولا git add .
- لا push ولا merge إلى main.
- لا تعديل تاريخ Git ولا حذف ملفات متتبعة.
- 3 فشل متتالٍ أو تعارض غير قابل للحسم → توقف وأبلغ.
MISSION_EOF
echo "PROMPT_SAVED: $(wc -l < /root/t5_mission.txt) lines"
# ===== 2) اكتشاف duck.ai =====
echo "===== DUCK DISCOVERY ====="
ls -la /root/ilm-al-kitab/duck.ai /root/ilm-al-kitab/MAL/duck.ai 2>/dev/null
file /root/ilm-al-kitab/duck.ai 2>/dev/null
head -30 /root/ilm-al-kitab/duck.ai 2>/dev/null
echo "===== WHICH DUCK ====="
which duck duckai duck-ai 2>/dev/null
command -v duck 2>/dev/null
echo "===== DUCK HELP ====="
duck --help 2>&1 | head -20
duckai --help 2>&1 | head -10
# ===== 3) إن كان duck أمراً حقيقياً → مرّر له الـprompt =====
if command -v duck >/dev/null 2>&1; then
  echo "===== DUCK FOUND: feeding mission ====="
  cd /root/ilm-al-kitab/MAL
  duck -p "$(cat /root/t5_mission.txt)" 2>&1 | tee /root/duck_feedback.txt
  echo "DUCK_EXIT=$?"
elif [ -f /root/ilm-al-kitab/duck.ai ] && [ -x /root/ilm-al-kitab/duck.ai ]; then
  echo "===== duck.ai is executable file — running it ====="
  cd /root/ilm-al-kitab/MAL
  /root/ilm-al-kitab/duck.ai "$(cat /root/t5_mission.txt)" 2>&1 | tee /root/duck_feedback.txt
  echo "DUCK_EXIT=$?"
else
  echo "===== DUCK NOT A CLI ====="
  echo "duck.ai موجود كملف لكنه ليس أمراً قابلاً للتنفيذ."
  echo "المحتوى أعلاه يوضح ما هو — أرسل النتيجة للوكيل ليحدد طريقة الاستدعاء."
fi
# ===== 4) feedback عن حالة المهمة بغض النظر =====
echo "===== MISSION STATUS ====="
cd /root/ilm-al-kitab/MAL
git log --oneline -3
git status --short | head -10
BIN=/tmp/m2-target/release/malc-native
if [ -f /tmp/t5.mal ]; then
  set +e
  $BIN /tmp/t5.mal -o /tmp/t5v 2>&1; echo "T5_COMPILE=$?"
  set -e
fi
echo "===== END ====="
