(*
  UORI — طبقة دلالات حسابية لتعليمات مسار «قوة».

  يثبت هذا الملف خواصاً مغلقة للنموذج الحسابي المجرد فقط:
  - تفكيك القسمة والباقي عند الإسقاط Q32.32؛
  - الحالة الصفرية للإزاحة الحسابية المجردة؛
  - شرط قبول امتداد الإشارة للنصف العالي.

  لا يدّعي هذا الملف أن NASM imul/shrd/sar يحقق هذه التعريفات.
  ذلك الربط يحتاج نموذجاً مستقلاً لتشفير السجلات والتنفيذ الموقّع.
*)
From Coq Require Import ZArith Lia.

Open Scope Z_scope.

Definition q32_scale_i : Z := 2 ^ 32.
Definition word64_scale : Z := 2 ^ 64.

Definition q32_project_i (p : Z) : Z := p / q32_scale_i.
Definition q32_remainder_i (p : Z) : Z := p mod q32_scale_i.

Definition sar_model (x : Z) (shift : nat) : Z := x / (2 ^ (Z.of_nat shift)).

Definition shrd_model (low high : Z) (shift : nat) : Z :=
  low / (2 ^ (Z.of_nat shift)) + high * (2 ^ (64 - Z.of_nat shift)).

Definition sign_extended_high (low high : Z) : Prop :=
  (high = 0 /\ 0 <= low) \/ (high = -1 /\ low < 0).

Lemma q32_scale_positive : 0 < q32_scale_i.
Proof.
  unfold q32_scale_i.
  change ((0 : Z) < 4294967296).
  lia.
Qed.

Lemma q32_projection_decomposition_i :
  forall p,
    p = q32_scale_i * q32_project_i p + q32_remainder_i p.
Proof.
  intros p.
  unfold q32_project_i, q32_remainder_i, q32_scale_i.
  pose proof (Z.div_mod p (2 ^ 32)) as H.
  nia.
Qed.

Lemma q32_remainder_i_nonnegative :
  forall p, 0 <= q32_remainder_i p.
Proof.
  intros p.
  unfold q32_remainder_i, q32_scale_i.
  pose proof (Z.mod_pos_bound p (2 ^ 32)) as H.
  lia.
Qed.

Lemma q32_remainder_i_below_scale :
  forall p, q32_remainder_i p < q32_scale_i.
Proof.
  intros p.
  unfold q32_remainder_i, q32_scale_i.
  pose proof (Z.mod_pos_bound p (2 ^ 32)) as H.
  lia.
Qed.

Lemma sar_model_zero : forall x, sar_model x 0 = x.
Proof.
  intros x.
  unfold sar_model.
  cbn.
  rewrite Z.div_1_r.
  reflexivity.
Qed.

Lemma shrd_model_is_explicit :
  forall low high shift,
    shrd_model low high shift =
      low / (2 ^ (Z.of_nat shift)) + high * (2 ^ (64 - Z.of_nat shift)).
Proof.
  intros; reflexivity.
Qed.

Lemma sign_extended_high_nonzero_cases :
  forall low high,
    sign_extended_high low high -> high = 0 \/ high = -1.
Proof.
  intros low high H.
  destruct H as [[H _] | [H _]]; auto.
Qed.

Lemma sign_extended_high_accepts_nonnegative :
  forall low, 0 <= low -> sign_extended_high low 0.
Proof.
  intros; left; split; lia.
Qed.

Lemma sign_extended_high_accepts_negative :
  forall low, low < 0 -> sign_extended_high low (-1).
Proof.
  intros; right; split; lia.
Qed.

Print Assumptions q32_projection_decomposition_i.
Print Assumptions q32_remainder_i_nonnegative.
Print Assumptions q32_remainder_i_below_scale.
Print Assumptions sar_model_zero.
Print Assumptions sign_extended_high_nonzero_cases.
Print Assumptions sign_extended_high_accepts_nonnegative.
Print Assumptions sign_extended_high_accepts_negative.
