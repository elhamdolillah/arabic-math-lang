cd /home/ubuntu/uori-mal-pr && SOURCE_DATE_EPOCH=0 python3 audit_measure_ratio.py . > evidence/STAGE7_CORRECTIVE_RATIO_EXACT.stdout

# الأمر يحفظ stdout الكامل للأداة الحالية بدقة round(..., 8)؛ لا يستخدم مخرجاً تاريخياً أو قيمة يدوية.
WARNING: يجب تشغيل هذا الأمر من بيئة موثوقة مع مراجعة الشجرة قبل اعتماد النتيجة.
العقود: SOURCE_DATE_EPOCH=0؛ الجذر المحتسب هو /home/ubuntu/uori-mal-pr؛ المخرج هو evidence/STAGE7_CORRECTIVE_RATIO_EXACT.stdout.
الترقية التلقائية ممنوعة، ولا تمثل النتيجة إذناً بالدمج.
