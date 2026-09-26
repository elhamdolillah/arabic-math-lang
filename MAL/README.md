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
