//! واجهة ABI منطقية آمنة تعتمد على مقاطع عددية ثابتة مسبقاً.
//!
//! لا تستقبل هذه الواجهة مؤشرات أو أطوالاً، ولا تنشئ حالة عامة أو ذاكرة
//! ديناميكية. يختار المستهلك مقطعاً من جدول ثابت، ثم يطلب عملية محددة عليه.

pub const ABI_VERSION: u32 = 1;
pub const SEGMENT_COUNT: u32 = 4;
pub const MAX_SEGMENT_ITEMS: u32 = 8;

const SEGMENT_0: [u64; 8] = [0, 1, 1, 2, 3, 5, 8, 13];
const SEGMENT_1: [u64; 8] = [1, 2, 3, 4, 5, 6, 7, 8];
const SEGMENT_2: [u64; 8] = [2, 4, 6, 8, 10, 12, 14, 16];
const SEGMENT_3: [u64; 8] = [64, 32, 16, 8, 4, 2, 1, 0];

pub const OP_SUM: u32 = 1;
pub const OP_COUNT: u32 = 2;
pub const OP_WEIGHTED_SUM: u32 = 3;
pub const OP_CAPACITY_CHECK: u32 = 4;

pub const STATUS_OK: u32 = 0;
pub const STATUS_UNKNOWN_SEGMENT: u32 = 1;
pub const STATUS_UNKNOWN_OPERATION: u32 = 2;
pub const STATUS_OVERFLOW: u32 = 3;
pub const STATUS_CAPACITY_REJECTED: u32 = 4;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct AbiResult {
    pub status: u32,
    pub value: u64,
}

fn segment(segment_id: u32) -> Option<&'static [u64; 8]> {
    match segment_id {
        0 => Some(&SEGMENT_0),
        1 => Some(&SEGMENT_1),
        2 => Some(&SEGMENT_2),
        3 => Some(&SEGMENT_3),
        _ => None,
    }
}

/// نسخة العقد المنطقي.
pub extern "C" fn mal_safe_abi_version() -> u32 { ABI_VERSION }

/// عدد المقاطع الثابتة المتاحة.
pub extern "C" fn mal_safe_segment_count() -> u32 { SEGMENT_COUNT }

/// يعيد قيمة موضعية من مقطع ثابت، أو `u64::MAX` عند الامتناع.
pub extern "C" fn mal_safe_segment_value(segment_id: u32, index: u32) -> u64 {
    match segment(segment_id).and_then(|values| values.get(index as usize)) {
        Some(value) => *value,
        None => u64::MAX,
    }
}

/// ينفذ عملية على مقطع ثابت ويرد بحالة ونتيجة في زوج عددي.
pub extern "C" fn mal_safe_eval_segment(segment_id: u32, operation: u32) -> AbiResult {
    let values = match segment(segment_id) {
        Some(values) => values,
        None => return AbiResult { status: STATUS_UNKNOWN_SEGMENT, value: 0 },
    };
    match operation {
        OP_SUM => values.iter().try_fold(0_u64, |sum, value| sum.checked_add(*value))
            .map_or(AbiResult { status: STATUS_OVERFLOW, value: 0 }, |value| AbiResult { status: STATUS_OK, value }),
        OP_COUNT => AbiResult { status: STATUS_OK, value: values.len() as u64 },
        OP_WEIGHTED_SUM => values.iter().enumerate().try_fold(0_u64, |sum, (index, value)|
            sum.checked_add(value.checked_mul(index as u64 + 1)?))
            .map_or(AbiResult { status: STATUS_OVERFLOW, value: 0 }, |value| AbiResult { status: STATUS_OK, value }),
        OP_CAPACITY_CHECK => if values.len() as u32 <= MAX_SEGMENT_ITEMS {
            AbiResult { status: STATUS_OK, value: values.len() as u64 }
        } else {
            AbiResult { status: STATUS_CAPACITY_REJECTED, value: 0 }
        },
        _ => AbiResult { status: STATUS_UNKNOWN_OPERATION, value: 0 },
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn fixed_segments_are_deterministic() {
        assert_eq!(mal_safe_abi_version(), 1);
        assert_eq!(mal_safe_segment_count(), 4);
        assert_eq!(mal_safe_segment_value(0, 7), 13);
        assert_eq!(mal_safe_segment_value(9, 0), u64::MAX);
        assert_eq!(mal_safe_eval_segment(0, OP_SUM), AbiResult { status: STATUS_OK, value: 33 });
        assert_eq!(mal_safe_eval_segment(0, OP_COUNT), AbiResult { status: STATUS_OK, value: 8 });
        assert_eq!(mal_safe_eval_segment(0, OP_WEIGHTED_SUM), AbiResult { status: STATUS_OK, value: 218 });
        assert_eq!(mal_safe_eval_segment(0, 999), AbiResult { status: STATUS_UNKNOWN_OPERATION, value: 0 });
        assert_eq!(mal_safe_eval_segment(9, OP_SUM), AbiResult { status: STATUS_UNKNOWN_SEGMENT, value: 0 });
    }
}

