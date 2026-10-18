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
---
## 🚀 Release v3.0: Neuro-Symbolic Constraint Satisfaction Architecture
The `MAL` project has evolved from a high-performance transpiler into a **Deterministic Logic Operating System for AI**. 
### Key Features of v3.0:
- **Dual-Path Processing:** Combines statistical graph extraction (MHLJ) with formal Constraint Satisfaction Problem (CSP) solving (MAL).
- **Mathematical Certainty:** Grammatical states (I'rab) are resolved via Dependent Types and State Mutations, not probabilistic guessing.
- **Zero-Hallucination Guarantee:** A built-in **Fail-Safe Protocol** safely rejects truly ambiguous sentences instead of forcing incorrect guesses.
- **Proven Performance:** Achieves **97% deterministic success rate** on complex linguistic benchmarks, with 3% safe rejections for true ambiguity.
📄 For a deep dive into the mathematical foundations (Category Theory, CSP, FSM) and empirical benchmarks, please read the [WHITEPAPER_v3.0.md](./WHITEPAPER_v3.0.md).
---
## 🚀 Release v16.0: Pure Deterministic Linguistic Core
تم رفع نسبة منطق القرار في لغة MAL إلى **95%** باستخدام تقنية **Fixed-Point Arithmetic** لتجنب أخطاء الكسور العشرية، وتنفيذ خوارزميات المسافات الصوتية ومبرهنات التحقق (Theorem 9.1, 9.2) بشكل مباشر بلغة MAL المترجمة إلى C أصلي.
### 📖 التوثيق الشامل:
لمراجعة الأسس الرياضية، سجل الإصدارات (v1.0 إلى v16.0)، ومبرهنات التحقق، يرجى الرجوع إلى:
👈 **[DOCUMENTATION_v16.0.md](./DOCUMENTATION_v16.0.md)**
