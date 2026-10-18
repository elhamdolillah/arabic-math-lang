cat > /root/t5_mission.txt <<'MISSION_EOF'
أنت وكيل برمجي داخل VPS على المسار /root/ilm-al-kitab/MAL.
مهمتك: تنفيذ بوابة t5 (if/return) في مترجم MAL من البداية للنهاية، ذاتياً.
[  أنت وكيل برمجي داخل VPS على المسار /root/ilm-al-kitab/MAL.
مهمتك: تنفيذ بوابة t5 (if/return) في مترجم MAL من البداية للنهاية، ذاتياً.
السياق المثبت من الجولات السابقة:
- C2 مُغلق: tests/gates/print_string_gate_c2.mal يطبع «مرحباً MAL» exit=0 حتمية ×3.
- الفرع الحالي: feat/if-return-gate-t5، HEAD = 83878ccb.
- يوجد تعديلات غير ملتزمة في src/lexer/src/lib.rs (Semicolon + {} ككتل) وtools/malc-native/src/main.rs (parse_with_fns) — احتفظ بها، لا تراجعها.
- المترجم: /tmp/m2-target/release/malc-native — يعمل.
- الصياغة المعتمدة: ﴿ إذا شرط : ﴿ أعد قيمة ﴾ ﴾
- NIR فيه CondBranch وBranch وReturn جاهزة، وnative يولّدها (سطر 210 تقريباً).
- lexer يطابق الكلمات المفتاحية في فرع الـidentifier عبر match text.
- parser: parse_stmt عند السطر 578، يتعامل مع Print/Ident/LBlock.
- lowering: lower_node مع match على ASTNode، وList يُخفَّض كتسلسل.
- type_inference.rs فيه match شامل على ASTNode → TypeTag.
خطواتك الإلزامية بالترتيب:
1. اقرأ بنفسك (لا تعتمد على هذا الوصف وحده):
   - src/lexer/src/lib.rs: مسار الكلمات المفتاحية وTokenKind.
   - src/arena/src/lib.rs: ASTNode enum وTypeTag.
   - src/parser/src/lib.rs: parse_stmt وparse_program.
   - src/nir/src/lowering.rs: lower_node وlower.
   - src/nir/src/type_inference.rs: الـmatch الشامل.
   - src/native/src/lib.rs: CondBranch وemit blocks.
2. صمّم وأكتب رقعة Rust كاملة تضيف:
   a) lexer: TokenKind::IfKeyword وTokenKind::ReturnKeyword
      + مطابقة "إذا" و"أعد" في فرع الكلمات المفتاحية.
   b) arena: ASTNode::If { cond, then_body } و ASTNode::Return { value }
      + أضف arms لهما في كل match شامل على ASTNode (خاصة type_inference).
   c) parser: في parse_stmt، فرعا IfKeyword وReturnKeyword
      (IfKeyword: cond = parse_expr، expect Colon، then_body = parse_stmt).
   d) lowering: 
      - Return → NIRInstruction::Return { value } ثم None.
      - If → CondBranch + then_bb/else_bb/end_bb + Branch، ثم current_block = end_bb، وأعد None.
   e) لا تعدّل native إلا إذا اكتشفت نقصاً فعلياً — CondBranch موجود أصلاً.
3. طبّق الرقعة (تعديل مباشر أو python chr-safe)، ثم:
   CARGO_TARGET_DIR=/tmp/m2-target cargo build --release --manifest-path tools/malc-native/Cargo.toml
   إن فشل البناء: اقرأ الخطأ كاملاً وأصلح رقعتك. أقصى 3 محاولات.
   إن فشلت الثلاث: توقف وأبلغ بالأخطاء كاملة، دون commit.
4. اكتب الاختبارات:
   printf '%s
' '﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾' > /tmp/t5.mal
   printf '%s
' 'إذا' > /tmp/t5_bad.mal
5. البوابة الميكانيكية (لا تتجاوزها):
   set +e
   $BIN /tmp/t5.mal -o /tmp/t5; COMPILE_EXIT=$?
   /tmp/t5; T5_EXIT=$?
   H1=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
   $BIN /tmp/t5.mal -o /tmp/t5 && /tmp/t5; H2=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
   $BIN /tmp/t5.mal -o /tmp/t5 && /tmp/t5; H3=$(sha256sum /tmp/t5 2>/dev/null | cut -d' ' -f1)
   $BIN /tmp/t5_bad.mal -o /tmp/t5_bad 2>&1; NEG_EXIT=$?
   set -e
   إذا لم يتحقق الشرط كله:
   [ COMPILE_EXIT=0 && T5_EXIT=0 && NEG_EXIT≠0 && H1=H2=H3 ]
   → لا تنفّذ git commit إطلاقاً. أصلح رقعتك وأعد الاختبار (بحد 3 محاولات).
   إن فشلت الثلاث: أبلغ بالتفاصيل كاملة وexit 1.
6. عند النجاح فقط:
   git add src/lexer/src/lib.rs src/parser/src/lib.rs src/arena/src/lib.rs \
           src/nir/src/lowering.rs src/nir/src/type_inference.rs
   git diff --cached --stat
   git commit -m 'feat(lexer+parser+nir): إذا/أعد — gate t5
PROVEN_FOR_SCOPE: t5 (﴿ إذا 1 : ﴿ أعد 0 ﴾ ﴾ → exit 0), negative fail-closed, determinism x3'
7. أعد تشغيل بوابتي C2 وD للتأكد من عدم الانحدار:
   $BIN tests/gates/print_string_gate_c2.mal -o /tmp/pr && /tmp/pr; echo "C2=$?"
   $BIN tests/gates/fib_ar_gate_d.mal -o /tmp/fib && /tmp/fib; echo "D=$?"
8. تقرير نهائي واحد يذكر:
   - الصياغة المعتمدة والرموز المضافة.
   - الملفات المعدلة وعدد الأسطر.
   - نتائج البناء والاختبارات (أكواد الخروج والبصمات).
   - هاش الـcommit.
   - نتيجة C2 وD بعد التغيير.
قواعد صارمة:
- لا تكتب PROVEN_FOR_SCOPE إلا بعد رؤية النتائج الفعلية بنفسك.
- لا تستخدم git add -A أو git add . — أضف الملفات بالاسم.
- لا تدفع إلى remote ولا تدمج في main.
- لا تعدّل تاريخ Git ولا تحذف ملفات متتبعة.
- إن ظهر تعارض لا يمكن حسمه من الكود، أو 3 فشل متتالٍ، توقف وأبلغ. دد]
MISSION_EOF
