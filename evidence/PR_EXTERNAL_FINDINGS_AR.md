# ملاحظات خارجية مرتبطة بإنشاء Pull Request

## مراجع GitHub

[1] GitHub Status checks: https://docs.github.com/en/pull-requests/reference/status-checks

الخلاصة الموثقة: الفحوص المطلوبة على فرع محمي يجب أن تنجح قبل دمج Pull Request. كما أن GitHub Actions تنشئ Checks وليس commit statuses.

[2] GitHub About protected branches: https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches

الخلاصة الموثقة: يجب أن تكون أسماء وظائف الفحص فريدة عند استعمالها كـ required checks لتجنب النتائج الملتبسة. ويمكن تفعيل required status checks ومنع تجاوز المتطلبات.

[3] GitHub Managing a branch protection rule: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule

الخلاصة الموثقة: إنشاء القاعدة يتم باختيار نمط الفرع، تفعيل Pull Request، تفعيل required status checks، ثم اختيار الفحص من القائمة.

## نتيجة CI الأولى

فشل تشغيل Alpine الأول لأن `apk add` كان داخل حاوية شُغلت مع `--network none`. لم يكن ذلك فشل MAL، بل تعارضاً بين تثبيت الاعتمادات وعزل شبكة وقت التنفيذ.

## الإصلاح

نُقلت عملية تثبيت `bash` و`coreutils` و`git` إلى Dockerfile أثناء بناء الصورة، وثُبّتت صورة الأساس `python:3.12-alpine3.20` ببصمة SHA-256، ثم بقي تشغيل التدقيق نفسه مع `--network none`.
