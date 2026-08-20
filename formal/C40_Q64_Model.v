From Coq Require Import ZArith Lia.

Open Scope Z_scope.

(** تمثيل Q64.64: العدد الصحيح يحمل قيمة حقيقية مقسومة على 2^64. *)
Definition q64_scale : Z := 18446744073709551616.
Definition q64 : Set := Z.
Definition q64_value (n : q64) : Z := n.

(** حاصل ضرب صحيح غير سالب مع إسقاط Q64.64.
    البرهان الكامل لخطأ التقريب سيضاف بعد تثبيت سياسة التقريب الموقعة. *)
Definition q64_mul_floor (a b : q64) : q64 := (a * b) / q64_scale.

Lemma q64_scale_pos : 0 < q64_scale.
Proof. unfold q64_scale; lia. Qed.

Lemma q64_value_identity : forall n : q64, q64_value n = n.
Proof. intro n; reflexivity. Qed.

Lemma q64_mul_floor_exact : forall a b : q64,
  0 <= a -> 0 <= b -> Z.divide q64_scale (a * b) ->
  q64_mul_floor a b * q64_scale = a * b.
Proof.
  intros a b Ha Hb Hdiv.
  unfold q64_mul_floor.
  destruct Hdiv as [c Hc].
  rewrite Hc.
  rewrite (Z.div_mul c q64_scale).
  - reflexivity.
  - intro Hzero.
    pose proof q64_scale_pos as Hpos.
    lia.
Qed.

Lemma q64_mul_floor_nonnegative : forall a b : q64,
  0 <= a -> 0 <= b -> 0 <= q64_mul_floor a b.
Proof.
  intros a b Ha Hb.
  unfold q64_mul_floor.
  apply Z.div_pos.
  - nia.
  - exact q64_scale_pos.
Qed.

(** التحويل الدقيق من Q32.32 إلى Q64.64. *)
Definition q32_to_q64 (x : Z) : q64 := x * 2^32.

Lemma q32_to_q64_scale : forall x : Z,
  q32_to_q64 x = x * 4294967296.
Proof. intro x; unfold q32_to_q64; reflexivity. Qed.

(** عقد نطاق أولي للمدخل؛ لا يثبت أُس بعد، بل يحدد مجال البرهان. *)
Definition in_domain (x_q32 : Z) : Prop :=
  (-2147483648 * 10 <= x_q32) /\
  (x_q32 <= 2147483648 * 10).

Lemma zero_in_domain : in_domain 0.
Proof. unfold in_domain; lia. Qed.

(** كل نتائج هذا الملف قابلة للبناء في Coq 8.18. لا توجد Admitted أو Axiom. *)
Print Assumptions q64_mul_floor_exact.
Print Assumptions q64_mul_floor_nonnegative.
Print Assumptions q32_to_q64_scale.
