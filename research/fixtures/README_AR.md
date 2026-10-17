# Research Fixtures

هذه fixtures تركيبية وثابتة لا تمثل compiler حقيقياً ولا تنفذ محتوى مصدرياً. تستخدم لاختبار عقد المقارنة والبصمات فقط.

```text
stage1 = compiler-stage-1-fixture
stage2 = compiler-stage-2-fixture
stage3 = compiler-stage-2-fixture
binary_a = deterministic-binary-fixture-v1
binary_b = deterministic-binary-fixture-v1
fuzz seeds = 0, 1, 2, 3
```

التطابق هنا يثبت صحة harness فقط، ولا يثبت bootstrap أو سلامة binary أو اكتمال fuzzing.
