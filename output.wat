(module
  ;; اللغة العربية الرياضية → WASM
  ;; المرحلة 51

  ;; استيراد دوال البيئة
  (import "env" "print_i64" (func $print_i64 (param i64)))
  (import "env" "print_string" (func $print_string (param i32)))

  ;; الذاكرة الخطية
  (memory (export "memory") 1)

  ;; الدالة الرئيسية
  (func $main (export "main")
    (local $l0 i64)

    ;; الجسم
    i64.const 5
    local.set 0
    local.get 0
    i64.const 3
    i64.add
    call $print_i64
  )

  ;; جذر تربيعي (خوارزمية نيوتن)
  (func $sqrt_i64 (param $n i64) (result i64)
    (local $x i64)
    (local $prev i64)
    ;; x = n / 2
    local.get $n
    i64.const 2
    i64.div_s
    local.set $x
    ;; حلقة نيوتن
    block
      loop
        local.get $x
        local.set $prev
        ;; x = (x + n/x) / 2
        local.get $x
        local.get $n
        local.get $x
        i64.div_s
        i64.add
        i64.const 2
        i64.div_s
        local.set $x
        ;; إذا x >= prev، توقف
        local.get $x
        local.get $prev
        i64.ge_s
        br_if 1
        br 0
      end
    end
    local.get $x
  )

  ;; قيمة مطلقة
  (func $abs_i64 (param $n i64) (result i64)
    local.get $n
    i64.const 0
    i64.lt_s
    if (result i64)
      i64.const 0
      local.get $n
      i64.sub
    else
      local.get $n
    end
  )

  ;; نقطة البداية
  (start $main)
)