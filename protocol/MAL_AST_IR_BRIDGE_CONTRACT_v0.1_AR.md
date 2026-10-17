# عقد جسر AST إلى سجل IR وSidecar v0.1

## المجال

يحدد هذا العقد العلاقة الحتمية بين `AST NodeID`، وسجل IR، ورمز ABI، وملف sidecar المرتبط بالبصمات.

## قاعدة المطابقة

لكل عقدة AST معتمدة إدخال واحد في سجل IR، ولكل إدخال IR رمز ABI واحد. تكون العلاقة canonical بالترتيب `(AST_NodeID، IR_Ordinal، ABI_Symbol)`، ويُرفض أي تكرار أو فجوة أو رجوع في الترتيب.

## sidecar

يحتوي sidecar على الإصدار، وبصمة عقد AST، وبصمة سجل IR، وبصمة ABI، وعدد الإدخالات، وحالة التنفيذ. تُطبع الحقول بترتيب ثابت وبترميز UTF-8 canonical. لا يجوز إدراج مسار محلي أو وقت أو معرف بيئي.

## الامتناع

إذا غابت بصمة، أو لم تتطابق العملية مع ABI، أو خرج NodeID أو الرتبة عن الحدود، تعاد `ABSTAIN` ولا يُنشأ sidecar صالح للاعتماد. لا يُستنتج نجاح التنفيذ من سلامة البنية.

## التصنيف

الحالة `POLICY / RESEARCH` حتى تشغيل مشغل MAL موثوق وإثبات المقارنة التنفيذية. يظل `AUTO_PROMOTION=DENY` ولا يُعدّل baseline.

```text
RAW_POINTERS=DENY
DYNAMIC_ALLOCATION=DENY
NON_CANONICAL_ORDER=ABSTAIN
MISSING_FINGERPRINT=ABSTAIN
ABI_MISMATCH=ABSTAIN
SOURCE_EXECUTION=NOT_PERFORMED
AUTO_PROMOTION=DENY
```
