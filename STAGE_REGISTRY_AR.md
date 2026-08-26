# سجل مراحل UORI وMAL

## مرجع الحوكمة

هذا السجل يعمل تحت القيود التالية:

```text
AUTO_PROMOTION=DENY
FAIL_CLOSED=ACTIVE
BASELINE_FREEZE=ACTIVE
UNSAFE_CODE=PROHIBITED
DYNAMIC_HEAP_ALLOCATION=PROHIBITED
```

لا يرفع هذا السجل أي حكم محدود النطاق إلى إثبات شامل للنواة أو للغة MAL كاملة أو لتكافؤ Python/Rust.

## الحالة المرحلية

| المرحلة أو المكوّن | التصنيف | نطاق الحكم | الأدلة | القيود المفتوحة |
|---|---|---|---|---|
| `mal_runner` Rust التشخيصي | `PROVEN_FOR_SCOPE` | قبول وتحليل Corpus ذي النطاق الموثق في Stage 7، مع مخرجات canonical قابلة للتكرار | `evidence/STAGE7_CORRECTIVE_CARGO_TEST.stdout`، `evidence/STAGE7_CORRECTIVE_UNSAFE_SCAN.stdout`، `evidence/STAGE7_CORRECTIVE_DIFFERENTIAL.stdout` | لا يثبت اكتمال Parser العام أو سيادة MAL المطلقة |
| Corpus Stage 7 التصحيحي | `PROVEN_FOR_SCOPE` | 179 حالة ضمن 64 ملفاً تصحيحياً، وفق manifest والتشغيل التفاضلي الموثق | `corpus/stage7_correction_64_files/MANIFEST.tsv`، `evidence/STAGE7_CORRECTIVE_CORPUS_VERIFY.stdout`، `evidence/STAGE7_CORRECTIVE_DIFFERENTIAL.stdout` | الحكم محصور في الحالات الفعلية الموجودة في Corpus ولا يمتد إلى مدخلات غير مختبرة |
| الحتمية والتشغيل الثلاثي | `PROVEN_FOR_SCOPE` | تطابق مخرجات JSON الثلاثية، مع حفظ البصمات التشغيلية في أدلة Stage 7 | `evidence/STAGE7_CORRECTIVE_TRIPLE_HASHES.stdout`، `evidence/STAGE7_CORRECTIVE_TRIPLE_JSON_HASHES.stdout` | لا يثبت التكافؤ الدلالي مع نموذج مرجعي غير متوفر |
| تكافؤ Python/Rust على Corpus Parser | `RESEARCH` / `ABSTAIN` | لم يثبت بسبب غياب واجهة Python Lexer/Parser مكافئة تقرأ `.ar` وتصدر مخطط نتائج مماثلاً | `/tmp/PYTHON_RUST_COMPARISON_REPORT_AR.md`، بصمة التقرير: `ce851f5281814c29c820306e3292503019c02d47c6d88c3b37ef7c8966ed4f9f` | يلزم نموذج Python Parser مستقل بعقد إدخال وإخراج موحدين؛ لا يجوز تحويل نموذج Arena/Ownership إلى Parser بالاستنتاج |

## أساس تصنيف Stage 7

يُعتمد التصنيف `PROVEN_FOR_SCOPE` للمشغل وCorpus الموسع بمعنى مقيد: الدليل يثبت الحتمية وقبول الحالات التي شُغّلت فعلياً داخل نطاق Corpus Stage 7 المحفوظ، ولا يثبت اكتمال اللغة أو توافقاً بين تطبيقين مختلفين. يشمل نطاق الدليل بناء Rust واختباراته، فحص منع الشفرة غير الآمنة، التشغيل التفاضلي، والتشغيل الثلاثي مع البصمات المحفوظة.

> `PROVEN_FOR_SCOPE` ليس `PROVEN` مطلقاً، ولا يساوي ترقية تلقائية، ولا يغيّر خط الأساس المجمد.

## تفسير امتناع Python

الملفان المستعادان `extensions/mal_ownership_arena.py` و`tests/run_mal_ownership_arena.py` يقدمان نموذجاً لعمليات `Arena` والملكية والاستعارة والنقل والتحرير، واختباراً داخلياً لهذه العمليات. لا يقدمان واجهة CLI لمسار `.ar` أو مجلد Corpus، ولا Lexer أو Parser Python مكافئاً، ولا مخطط إخراج يقابل سجل `mal_runner`. وعليه بقي الحكم على التكافؤ `RESEARCH`، ومع نقص واجهة قابلة للتشغيل يكون قرار التنفيذ المقارن `ABSTAIN` وفق بروتوكول Fail-Closed.

## حالة الدمج

```text
STAGE7_REGISTRY_CLASSIFICATION=PROVEN_FOR_SCOPE
PYTHON_RUST_EQUIVALENCE=RESEARCH_OR_ABSTAIN
BASELINE_MODIFIED=NO
AUTO_PROMOTION=DENY
FAIL_CLOSED=ACTIVE
```

هذا الملف يسجل الحكم المحدود فقط. أي دمج لفرع Stage 7 أو تحديث لسلسلة أدلة مستقلة هو إجراء إداري منفصل، ولا يُستنتج من إنشاء هذا السجل وحده.

_المؤلف: Manus AI_
