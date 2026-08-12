# 🚀 دليل البدء السريع
## Quick Start Guide

> ابدأ استخدام اللغة العربية الرياضية في 5 دقائق!

---

## الخطوة 1: التثبيت

### المتطلبات
```bash
# Linux (Ubuntu/Debian)
sudo apt update
sudo apt install python3 nasm binutils git
```

### التحقق
```bash
python3 --version    # Python 3.6+
nasm --version       # NASM 2.14+
```

### استنساخ المستودع
```bash
git clone https://github.com/elhamdolillah/arabic-math-lang.git
cd arabic-math-lang
```

---

## الخطوة 2: أول برنامج

### إنشاء الملف
```bash
nano hello.ar
```

### الكود
```arabic
⎕ "السلام عليكم"
```

### التجميع
```bash
python3 math_complete.py hello.ar
nasm -f elf64 hello.asm -o hello.o
ld hello.o -o hello
```

### التشغيل
```bash
./hello
```

### المخرج
```
السلام عليكم
```

---

## الخطوة 3: تجربة الأمثلة

```bash
cd examples

# تجربة كل مثال
for file in *.ar; do
    echo "=== $file ==="
    base="${file%.ar}"
    python3 ../math_complete.py "$file"
    nasm -f elf64 "$base.asm" -o "$base.o"
    ld "$base.o" -o "$base"
    "./$base"
    echo ""
done
```

---

## الخطوة 4: كتابة برنامجك الأول

### آلة حاسبة بسيطة
```arabic
س ≔ 42
ص ≔ 17
مجموع ≔ س + ص
⎕ "المجموع: " ⊕ نص(مجموع)
```

### قائمة وتكرار
```arabic
أعداد ≔ ⟨1, 2, 3, 4, 5⟩
مجموع ≔ 0
∀ ع ∈ أعداد : ﴿
    مجموع ≔ مجموع + ع
﴾
⎕ "المجموع: " ⊕ نص(مجموع)
```

---

## الرموز الأساسية

| الرمز | المعنى | مثال |
|-------|--------|------|
| `⎕` | طباعة | `⎕ "مرحبا"` |
| `≔` | إسناد | `س ≔ 5` |
| `⊕` | دمج نصوص | `"أ" ⊕ "ب"` |
| `+ - · ÷` | عمليات | `5 + 3` |
| `؟ :` | شرط ثلاثي | `س > 0 ؟ 1 : 0` |
| `⟨⟩` | قائمة | `⟨1, 2, 3⟩` |
| `μ` | حلقة while | `μ س < 10 : ﴿...﴾` |
| `∀` | حلقة for | `∀ ع ∈ ق : ﴿...﴾` |
| `λ` | دالة | `λس. س · س` |

---

## الخطوات التالية

1. 📖 اقرأ [SYNTAX_REFERENCE.md](../SYNTAX_REFERENCE.md)
2. 🎓 تابع [EXAMPLES_GUIDE.md](../EXAMPLES_GUIDE.md)
3. 📚 ابدأ [الكتاب](../book/01-introduction.md)
4. 🤝 انضم للمجتمع

---

## المساعدة

- 💬 [GitHub Discussions](https://github.com/elhamdolillah/arabic-math-lang/discussions)
- 🐛 [الإبلاغ عن مشكلة](https://github.com/elhamdolillah/arabic-math-lang/issues)

---

**﴿وقل رب زدني علماً﴾**