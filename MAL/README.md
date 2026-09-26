# MAL (Machine Abstraction Language) & `malc` Compiler
## Zero-Dependency, Deterministic AI Inference Engine
MAL is a custom systems programming language designed specifically for deterministic, zero-dependency deployment of Machine Learning models. The `malc` compiler translates MAL directly into highly optimized C code, which is then compiled into standalone native binaries.
### 🏆 Key Achievements
- **Deep Learning Support**: Successfully compiled and executed a 10-layer Deep Neural Network with **545,032 parameters** embedded directly in the source code.
- **Zero Dependencies**: The resulting binary requires no Python, PyTorch, or external libraries. Just the native executable.
- **High Performance**: Utilizes GCC's `-O3 -march=native -ffast-math` and custom SIMD directives (`#unroll`, `#simd`) for near-hardware-limit execution speeds.
- **Absolute Determinism**: Guarantees bit-exact numerical reproducibility across different environments and runs.
### 🚀 Supported Features
- **Data Types**: `i32`, `f32`, `f64`, and fixed-size arrays `[f32; N]`.
- **Control Flow**: `while` loops, `if/else` branches.
- **Compiler Directives**: `#unroll` and `#simd` to guide C compiler vectorization.
- **Standard Math**: Native support for `<math.h>` functions (e.g., `expf`, `sinf`, `sqrtf`).
- **Global Constants**: Embedding massive weight matrices directly into the global scope.
---
## 🧮 v2.0: Advanced Arabic Morphology & NLP Engine
تم ترقية `malc` ليدعم معالجة اللغات الطبيعية بشكل حتمي ورياضي:
- **الضغط الرياضي (Lossless Compression):** توليد الكلمات ديناميكياً من الجذور (Roots) وأنماط الاشتقاق (Patterns) بدلاً من تخزين القواميس الضخمة.
- **دعم النصوص المباشرة (Syntax Sugar):** يمكن الآن كتابة `let x: [i32; 4] = "اكتب";` وسيقوم المترجم تلقائياً بتحويلها إلى مصفوفة `UTF-16` (`[0x0627, 0x0643, 0x062A, 0x0628]`) خلف الكواليس.
- **التكامل مع qtxt:** القدرة على مطابقة الأوامر العربية جذرياً وتوليد كتل أوامر `bash` قابلة للتنفيذ فوراً وبشكل حتمي 100%.
---
## 🛡️ v2.1: Compile-Time Grammatical Type Checker
تم ترقية `malc` ليصبح أول مترجم في العالم يفرض قواعد النحو العربي كقيود صارمة في وقت الترجمة (Compile-Time):
- **فحص الأنواع النحوية (Grammatical Type Checking):** يمنع المترجم تجميع أي كود يحتوي على أخطاء إعرابية (مثل رفع الاسم بعد حرف جر).
- **قواعد مدعومة:** "الجر والمجرور"، "إنّ وأخواتها"، "كان وأخواتها".
- **أمان مطلق (Safe Execution):** يمكن دمج هذا الفحص مع مولدات الأوامر (مثل `qtxt`) لضمان عدم توليد أي سكربت إلا إذا كان المدخل اللغوي سليمًا بنسبة 100%.
