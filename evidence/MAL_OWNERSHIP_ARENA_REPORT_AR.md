# تقرير نموذج Ownership/Arena وDeterministic Tiers

## الحالة

هذا النموذج أولي ساكن مصنف `RESEARCH`. لا ينفذ مصدر MAL، ولا يعرض عناوين ذاكرة، ولا يستخدم raw pointers. المخطط المرئي يوضح المسار من parser إلى MAL-DIR ثم DIR Validator وOwnership/Arena Validator، وبعد النجاح إلى Deterministic Planner وTier-0، ثم إلى Admission Gate وTier-1 الاختياري.

## نطاق الاختبار

شغّل الاختبار `tests/run_mal_ownership_arena.py` مرتين مستقلتين. شمل الاختبار منع صيغة المؤشر `*` و`->`، منع `eval`، رفض نوع pointer، القراءة عبر Handle، shared borrow، exclusive borrow، النقل أثناء الاستعارة، stale generation، تجاوز عمر Arena، والتحرير بعد انتهاء الاستعارة.

## النتيجة

```text
OWNERSHIP_ARENA=PASS
REPLAY_STDOUT_IDENTICAL=YES
RAW_POINTERS=FORBIDDEN
CASES=10
EXECUTION=NOT_PERFORMED
NETWORK=DISABLED_BY_CONTRACT
```

تطابقت مخرجات التشغيلين حرفياً. مجموع الحالات العشر لا يمثل تغطية كاملة لنظام الملكية؛ بل يثبت فقط invariants النموذج الأولي المحددة في هذا الملف.

## قواعد النموذج

كل مرجع هو `Handle(arena_id, slot_id, generation, type_name)`. يرفض validator اختلاف Arena أو النوع أو generation، ويمنع use-after-move أو use-after-release. لا يسمح بالـexclusive borrow مع أي borrow قائم، ولا يسمح بالنقل أو التحرير أثناء وجود borrow. ترتيب slots متسلسل بدءاً من 1، وإعادة التخصيص ليست جزءاً من هذا النموذج.

## حدود الإثبات

نجاح الاختبار لا يثبت تكامل الملكية مع parser أو MAL-DIR أو SSA أو backend، ولا يثبت أماناً كاملاً للذاكرة في C أو WASM. ما زالت grammar الجديدة للملكية، وownership typing، وcross-arena transfer، وruntime ABI، وTier-1 native JIT ضمن `RESEARCH`. قبل اعتمادها يجب إضافة EBNF وAST/MAL-DIR version جديد وcorpus مستقل ودمجها في CI.

## الأدلة

- `MAL_DETERMINISTIC_TIERS_OWNERSHIP.mmd`: مصدر المخطط الحتمي.
- `MAL_DETERMINISTIC_TIERS_OWNERSHIP.png`: الرسم المرئي المصيّر.
- `MAL_OWNERSHIP_ARENA.stdout`: الخرج canonical.
- `MAL_OWNERSHIP_ARENA_RUN1.stdout` و`MAL_OWNERSHIP_ARENA_RUN2.stdout`: إثبات replay.
- `MAL_OWNERSHIP_ARENA.sha256`: بصمات المصدر والاختبار والخرج والمخطط.
- `MAL_OWNERSHIP_ARENA_VERIFY.stdout`: خلاصة التحقق.

لا تتضمن هذه المرحلة أي تنفيذ لمصدر MAL أو JIT native أو صفحات executable.
