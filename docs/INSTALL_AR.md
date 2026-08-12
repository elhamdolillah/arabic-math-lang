# 📥 دليل التثبيت المفصل

## المتطلبات الأساسية

### نظام التشغيل
- ✅ Linux x86_64 (Ubuntu 22.04+, Debian 11+, Fedora 38+)
- ⚠️ Windows (عبر WSL2)
- ⚠️ macOS (Intel فقط، لا يدعم Apple Silicon حالياً)

### الأدوات المطلوبة
```text
- Python 3.6+
- NASM 2.14+
- GNU ld (binutils)
- Git 2.30+
```

---

## التثبيت على Ubuntu/Debian

### 1. تحديث النظام
```bash
sudo apt update
sudo apt upgrade -y
```

### 2. تثبيت الأدوات
```bash
sudo apt install -y python3 python3-pip nasm binutils git
```

### 3. التحقق من التثبيت
```bash
python3 --version    # Python 3.10+
nasm --version       # NASM 2.15+
ld --version         # GNU ld 2.38+
git --version        # git 2.34+
```

### 4. استنساخ المستودع
```bash
git clone https://github.com/elhamdolillah/arabic-math-lang.git
cd arabic-math-lang
```

### 5. اختبار التثبيت
```bash
# تشغيل مثال بسيط
python3 math_complete.py examples/hello.ar
nasm -f elf64 examples/hello.asm -o examples/hello.o
ld examples/hello.o -o examples/hello
./examples/hello
```

**المخرج المتوقع:**
```
السلام عليكم ورحمة الله وبركاته
Hello from Arabic Mathematical Language!
مرحبا بالعالم
```

---

## التثبيت على Fedora/RHEL

```bash
sudo dnf install -y python3 nasm binutils git
git clone https://github.com/elhamdolillah/arabic-math-lang.git
cd arabic-math-lang
```

---

## التثبيت على Arch Linux

```bash
sudo pacman -S python nasm binutils git
git clone https://github.com/elhamdolillah/arabic-math-lang.git
cd arabic-math-lang
```

---

## التثبيت على Windows (WSL2)

### 1. تثبيت WSL2
```powershell
# في PowerShell كمسؤول
wsl --install
```

### 2. تثبيت Ubuntu من Microsoft Store

### 3. اتباع خطوات Ubuntu أعلاه

---

## التثبيت على macOS (Intel)

```bash
# تثبيت Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# تثبيت الأدوات
brew install python nasm git

# استنساخ المستودع
git clone https://github.com/elhamdolillah/arabic-math-lang.git
cd arabic-math-lang
```

⚠️ **ملاحظة:** macOS يستخدم تنسيق Mach-O بدلاً من ELF، لذا قد تحتاج لتعديلات.

---

## حل المشاكل الشائعة

### المشكلة 1: `nasm: command not found`
```bash
# Ubuntu/Debian
sudo apt install nasm

# Fedora
sudo dnf install nasm
```

### المشكلة 2: `python3: command not found`
```bash
# Ubuntu/Debian
sudo apt install python3

# استخدم python بدلاً من python3
python math_complete.py examples/hello.ar
```

### المشكلة 3: خطأ في التجميع
```text
examples/hello.asm:52: error: symbol `minus_str' not defined
```

**الحل:** تأكد من استخدام الإصدار الأحدث من `math_complete.py`

### المشكلة 4: `Permission denied` عند التشغيل
```bash
chmod +x examples/hello
./examples/hello
```

---

## التحديث إلى أحدث إصدار

```bash
cd arabic-math-lang
git pull origin main
```

---

## التثبيت كحزمة (قريباً)

### Ubuntu/Debian (مخطط)
```bash
sudo add-apt-repository ppa:arabic-math-lang/stable
sudo apt update
sudo apt install arabic-math-lang
```

### pip (مخطط)
```bash
pip install arabic-math-lang
```

---

## التحقق من النجاح

```bash
# تشغيل جميع الأمثلة
cd examples
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

إذا نجحت جميع الأمثلة، فالتثبيت مكتمل! 🎉

---

## طلب المساعدة

- 🐛 [الإبلاغ عن مشكلة](https://github.com/elhamdolillah/arabic-math-lang/issues)
- 💬 [المناقشات](https://github.com/elhamdolillah/arabic-math-lang/discussions)

**﴿وقل رب زدني علماً﴾**