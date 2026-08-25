# تقرير مرحلة Grammar Freeze وMAL-DIR v0.1

**الحالة:** `PARTIAL / FROZEN_PENDING_GATE_COMPARATOR`  
**النطاق:** parser/lexer وAST canonical وprototype لـMAL-DIR، دون تنفيذ المصدر أو backend.

## النتيجة التنفيذية

شُغّل corpus `MAL_GRAMMAR_FREEZE_CORPUS_v0.1.json` المكوّن من 12 حالة ضد parser الفعلي الموجود في:

`/home/ubuntu/uori-mediator-kit/.wheel_inspect/tools/uori_frontend.py`

نجحت 6 حالات في التحليل النحوي، ورفض parser 6 حالات بتشخيصات حتمية. حُفظت AST وDiagnostics في JSON canonical، وأُعيد الاختبار ثلاث مرات مع تطابق byte-for-byte. لم تُنفّذ أي قيمة `source_ref`، ولم تُشغّل أي backend أو مصدر غير موثوق.

| الفئة | العدد | نتيجة parser |
|---|---:|---|
| valid | 5 | 5 `PASS` |
| invalid | 3 | 3 `ERROR` |
| boundary | 3 | 1 `PASS` و2 `ERROR` |
| security | 1 | 1 `ERROR` |
| الإجمالي | 12 | 6 `PASS` و6 `ERROR` |

## تفسير الحالات الحدّية

حالة `boundary_real_arithmetic` نجحت نحوياً، لكنها بقيت `ABSTAIN` على مستوى العقد لأن وجود literal حقيقي لا يثبت عقد IEEE-754 حتمية. أما unary operator وreserved word as identifier فقد رُفضتا نحويًا، وهو متوافق مع حدود v0.1 التي لا تثبت unary operators وتمنع الكلمات المحجوزة كمعرفات. حالة `security_source_ref` لم تصل إلى تنفيذ؛ parser رفضها، وharness سجّل `source_ref_executed=false` صراحة.

## MAL-DIR v0.1

أُنشئت المواصفة `protocol/MAL_DIR_SPEC_v0.1_AR.md` والوحدة `extensions/mal_dir.py`. يقوم builder بتحويل AST إلى عقد canonical من دون pointers، ويُسند NodeIDs متصلة تبدأ من 1 بترتيب pre-order. أُخفضت الحالات الست التي أنتجت AST إلى MAL-DIR بنجاح، وتطابق الناتج byte-for-byte بين تشغيلين.

MAL-DIR ليس إعلانًا عن اكتمال compiler؛ فهو تمثيل بنيوي فقط. لا يثبت name resolution أو type checking أو SSA أو register allocation أو linking أو machine code. تبقى هذه المسارات `RESEARCH`.

## الأدلة

| الدليل | الغرض |
|---|---|
| `evidence/MAL_GRAMMAR_CORPUS_PARSER.stdout` | AST وDiagnostics canonical لجميع الحالات |
| `evidence/tests/MAL_GRAMMAR_CORPUS_RUN1.stdout` إلى `RUN3.stdout` | stdout الخام للتكرار الثلاثي |
| `evidence/tests/MAL_GRAMMAR_CORPUS_REPRO.sha256` | بصمات corpus parser |
| `evidence/MAL_DIR_CORPUS.stdout` | MAL-DIR canonical للحالات القابلة للتحليل |
| `evidence/MAL_DIR_CORPUS_RUN1.json` و`RUN2.json` | مدخلات المقارنة الحرفية |
| `evidence/MAL_DIR_CORPUS.sha256` | بصمات MAL-DIR وstdout |
| `tests/run_mal_grammar_corpus.py` | harness parser-only |
| `tests/run_mal_dir_corpus.py` | اختبار builder الحتمي |

## قرار التجميد

لا يجوز تغيير حالة Grammar إلى `FROZEN` بعد هذا التشغيل وحده. شرط `FROZEN` يحتاج أيضًا comparator يربط `expected_error` و`expected_status` بقرار Admission Gate الثلاثي، ويتحقق من أن كل حالة valid مقبولة، وكل حالة invalid مرفوضة أو ممتنعة، وكل boundary مصنفة صراحة. الموجود حاليًا يثبت parser repeatability وAST capture وno-execution، لكنه لا يثبت وحده قرار البوابة الكامل.

**القرار:** `GRAMMAR_FREEZE=ABSTAIN_PENDING_GATE_COMPARATOR`.  
**القرار الخاص بـMAL-DIR:** `MAL_DIR=RESEARCH_IMPLEMENTED_PROTOTYPE`.  
**BASELINE:** العمل محصور في فرع adoption مستقل. تحقق Git المحلي أثبت أن adoption repo نظيف بعد commit `df60873`، لكن كائن commit `f56b8bd` غير موجود في adoption repo ولا في `/home/ubuntu/uori-mediator-kit`؛ لذلك لا أقدّم ادعاء diff قابلًا للتحقق عن baseline، وتبقى مصادقة baseline الخارجية مطلوبة عند توفر مستودع/كائن المرجع.
