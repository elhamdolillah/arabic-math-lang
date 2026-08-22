/* خريطة توثيقية فقط لعقد UORI v0.1.
 * لا تُستعمل قبل تحديد منصة العتاد ومدخل boot وخريطة الذاكرة الفعلية.
 */
ENTRY(_start)

SECTIONS
{
  . = 0x00100000;
  .text : ALIGN(16) { *(.text.entry) *(.text .text.*) }
  .rodata : ALIGN(16) { *(.rodata .rodata.*) }
  .data : ALIGN(16) { *(.data .data.*) }
  .bss : ALIGN(16) { *(COMMON) *(.bss .bss.*) }
}
