# تقرير تحويل Qwen وMAL

<<<<<<< HEAD
- آخر تحديث UTC: 2026-10-17T19:12:01Z
=======
- آخر تحديث UTC: 2026-10-17T08:26:36Z
>>>>>>> feat/if-return-gate-t5
- الحالة: **WAITING_SAFE_CONVERSION**
- السبب: Qwen conversion is gated at P2_QWEN_ARCHITECTURE_REQUIRED/MMAP_PASS_OFFSETS_EXTRACTED; no verified source-to-MAL queue is present
- مراقب Qwen: **RESTARTED**

## الحماية

- حد الإيقاف: 95% استخدام أو أقل من 1GB حر.
- لا يعمل التحويل بالتوازي مع compiler/build/training.
- لا يحذف السكريبت أي نموذج أو compiler أو baseline.
- لا يُحذف المصدر إلا بعد compile + test + parity وتسجيل القياسات.

## القياسات

| العنصر | الحجم بالبايت |
|---|---:|
| Qwen GGUF المحمي | 0 |
| ملفات MAL | 54253 |
| SmolLM2 baseline binary | 46600 |

## حالة المسار

- مرحلة Qwen: P2_QWEN_ARCHITECTURE_REQUIRED
- الحالة: MMAP_PASS_OFFSETS_EXTRACTED
- queue التحويل: 11 / 11 عناصر معالجة؛ موثقة compile: 10؛ تحتاج مسارًا يدويًا: 1؛ التالي: none.
- كل عنصر يحفظ نتيجة compile والحجم قبل/بعد، ولا يغيّر ملفات الإنتاج.
- السبب: ملف GGUF أوزان ثنائية، وليس source code؛ تحويله إلى MAL يحتاج loader/محوّلًا مثبت parity.
- GAP4 هو المرحلة التالية، ولم يُنفذ تلقائيًا لحماية baseline.

## سجل التشغيل

راجع: /srv/mal/auto/conversion_supervisor.log و /srv/mal/auto/qwen7b_gap_fixes.log.
