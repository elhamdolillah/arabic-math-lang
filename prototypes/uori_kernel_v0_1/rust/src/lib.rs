#![no_std]

//! عقد UORI ABI v0.1.
//! هذا الملف لا يدّعي أنه bootloader أو bare-metal kernel مكتمل؛ إنه حدّ ثابت
//! يمكن للمترجم الحالي توليد استدعاءات إليه بعد تثبيت منصة الهدف.

#[repr(u32)]
#[derive(Clone, Copy, PartialEq, Eq)]
pub enum UoriStatus {
    Accepted = 0,
    Rejected = 1,
    Abstain = 2,
    InvalidArgument = 3,
    PermissionDenied = 4,
    ResourceExhausted = 5,
}

#[repr(u32)]
#[derive(Clone, Copy, PartialEq, Eq)]
pub enum UoriCall {
    DeviceWrite = 1,
    DeviceRead = 2,
    SubmitIntent = 3,
    ExecuteVerified = 4,
    EvidenceHash = 5,
}

#[repr(C)]
#[derive(Clone, Copy)]
pub struct UoriBuffer {
    pub ptr: *const u8,
    pub len: usize,
}

#[repr(C)]
#[derive(Clone, Copy)]
pub struct UoriCallFrame {
    pub call: UoriCall,
    pub capability: u32,
    pub input: UoriBuffer,
    pub output: UoriBuffer,
    pub fuel: u64,
}

#[repr(C)]
#[derive(Clone, Copy)]
pub struct UoriReturn {
    pub status: UoriStatus,
    pub value: i64,
    pub evidence_prefix: [u8; 8],
}

impl UoriBuffer {
    pub const fn empty() -> Self {
        Self { ptr: core::ptr::null(), len: 0 }
    }
}

/// نقطة ABI ثابتة رمزية. التنفيذ الحقيقي يجب أن يضيف فحص العنوان والقدرة
/// وحدود الذاكرة قبل أي لمس للذاكرة أو الأجهزة.
#[no_mangle]
pub extern "C" fn uori_syscall(frame: *const UoriCallFrame) -> UoriReturn {
    if frame.is_null() {
        return UoriReturn { status: UoriStatus::InvalidArgument, value: 0, evidence_prefix: [0; 8] };
    }
    // لا نقرأ الإطار في النموذج الأولي: لا توجد منصة تنفيذ/ذاكرة موثقة بعد.
    UoriReturn { status: UoriStatus::Abstain, value: 0, evidence_prefix: [0; 8] }
}
