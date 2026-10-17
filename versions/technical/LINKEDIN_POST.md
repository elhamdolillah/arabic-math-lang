# 🚀 I Built a Complete Arabic Programming Language from Scratch

After 38 development stages, I'm proud to announce the release of the **Arabic Mathematical Language (AML)** — a Turing-complete programming language with Arabic syntax that compiles to native x86_64 binaries.

## The Vision

Can Arabic — one of the world's most expressive languages — be a programming language? Not just translated keywords, but a complete language with its own:
- ✅ Syntax and semantics
- ✅ Type system
- ✅ Compiler
- ✅ Runtime model
- ✅ Memory safety guarantees

## Technical Highlights

**🔒 Linear Type System**
- Move semantics prevent use-after-free
- Compile-time memory safety
- No garbage collection overhead
- Inspired by Rust, simplified

**⚡ Arena Allocator**
- Single 256KB arena per program
- O(1) allocation
- Zero memory leaks by construction
- Impossible to create dangling pointers

**🎯 AOT Compilation**
- Compiles to x86_64 Assembly
- No libc dependency
- Tiny binaries (Hello World = 500 bytes)
- Native performance

**🧮 Mathematical Syntax**
- `≔` assignment, `μ` loops, `λ` lambdas
- `⟨⟩` lists, `⊕` concatenation
- Arabic identifiers
- Right-to-left support

## Example: Factorial in Arabic

```arabic
ن ≔ 5
نتيجة ≔ 1
ع ≔ 1
μ ع <= ن : ﴿
    نتيجة ≔ نتيجة · ع
    ⋄ ع ≔ ع + 1
﴾
⎕ نتيجة    # Output: 120
```

## Performance Comparison

| Language | Binary Size | Runtime |
|----------|-------------|---------|
| **AML** | **500 B** | Native |
| C | 16 KB | Native |
| Rust | 300 KB | Native |
| Go | 2 MB | Native |
| Python | 10 MB | Interpreted |

## Why This Matters

1. **Linguistic Inclusion**: 400M Arabic speakers now have a native programming language
2. **Memory Safety**: Proven safe without runtime overhead
3. **Educational Value**: Complete book teaching compiler construction
4. **Research Contribution**: Proves natural languages can be programming languages

## Project Stats

- 📝 1,000 lines of Python (complete compiler)
- 🎓 13 working examples
- 📚 5-chapter tutorial book
- 🔧 38 development stages
- ✅ 250+ successful tests

## Try It Yourself

```bash
git clone https://github.com/elhamdolillah/arabic-math-lang
cd arabic-math-lang
sudo apt install python3 nasm binutils
python3 math_complete.py examples/hello.ar
nasm -f elf64 examples/hello.asm -o examples/hello.o
ld examples/hello.o -o examples/hello
./examples/hello
```

## What's Next

- 🔜 Parallel programming (threads, channels)
- 🔜 Foreign Function Interface (C/Rust interop)
- 🔜 WebAssembly compilation target
- 🔜 VS Code extension

## Call for Contributors

I'm looking for contributors in:
- Compiler development
- Documentation and translations
- Testing and bug reports
- Research collaborations

## Links

- 📦 **GitHub**: https://github.com/elhamdolillah/arabic-math-lang
- 📖 **Documentation**: See README
- 💬 **Discussions**: GitHub Discussions

---

**﴿وقل رب زدني علماً﴾** — "And say: My Lord, increase me in knowledge"

#Programming #Compiler #Arabic #OpenSource #Rust #SystemsProgramming #LanguageDesign #MemorySafety #LinearTypes #x86 #AOT #SoftwareEngineering