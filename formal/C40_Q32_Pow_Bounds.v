(*
  UORI — C40 Q32.32 Power Bounds

  هذا الملف يثبت نموذجاً رياضياً محافظاً لقوة ذات أس صحيح غير سالب.
  لا يثبت هذا الملف أن Assembly الحالي يطابق النموذج؛ علاقة Assembly
  تحتاج لمّة ربط مستقلة واختباراً على الثنائي المولد.
*)
From Coq Require Import ZArith Lia List.
Import ListNotations.

Open Scope Z_scope.

Definition q32_scale : Z := 4294967296.
Definition q32_min : Z := -2147483648 * q32_scale.
Definition q32_max : Z :=  2147483647 * q32_scale + (q32_scale - 1).

Definition in_q32 (x : Z) : Prop := q32_min <= x <= q32_max.

(* الأس في هذه المواصفة عدد طبيعي، لا قيمة Q32.32 كسرية. *)
Fixpoint pow_integer (a : Z) (n : nat) : Z :=
  match n with
  | O => 1
  | S k => a * pow_integer a k
  end.

(* كل إسقاط لضرب Q32.32 يضيف خطأً صحيحاً محدوداً في نموذجنا. *)
Definition projection_error (d : Z) : Prop := -16 <= d <= 16.

Fixpoint sum_errors (ds : list Z) : Z :=
  match ds with
  | [] => 0
  | d :: tl => d + sum_errors tl
  end.

Lemma sum_errors_bound :
  forall ds,
    Forall projection_error ds ->
    -16 * Z.of_nat (length ds) <= sum_errors ds <=
     16 * Z.of_nat (length ds).
Proof.
  induction ds as [| d tl IH].
  - intros H. simpl. lia.
  - intros H. inversion H as [| ? ? Hd Htl].
    simpl. specialize (IH Htl). unfold projection_error in Hd. lia.
Qed.

(* نموذج نتيجة قوة بعد n خطوات، مع قائمة أخطاء الإسقاط المسجلة. *)
Definition pow_model (a : Z) (n : nat) (ds : list Z) : Z :=
  pow_integer a n + sum_errors ds.

Lemma pow_model_error_bound :
  forall a n ds,
    length ds = n ->
    Forall projection_error ds ->
    -16 * Z.of_nat n <= pow_model a n ds - pow_integer a n <=
     16 * Z.of_nat n.
Proof.
  intros a n ds Hlen Hsafe.
  unfold pow_model.
  pose proof (sum_errors_bound ds Hsafe) as Hbound.
  rewrite Hlen in Hbound.
  assert (Hid : pow_integer a n + sum_errors ds - pow_integer a n = sum_errors ds) by ring.
  rewrite Hid.
  exact Hbound.
Qed.

(* صيغة عامة لسلامة الإرجاع إذا كان الناتج الدقيق بعيداً عن حدي التمثيل
   بمقدار هامش الخطأ. *)
Lemma bounded_error_preserves_q32 :
  forall exact err bound,
    0 <= bound ->
    -bound <= err <= bound ->
    q32_min + bound <= exact <= q32_max - bound ->
    in_q32 (exact + err).
Proof.
  intros exact err bound Hbound Herr Hmargin.
  unfold in_q32.
  lia.
Qed.

(* النتيجة المتخصصة لقائمة إسقاطات حدها 16 لكل خطوة. *)
Theorem pow_model_no_overflow_under_margin :
  forall a n ds,
    length ds = n ->
    Forall projection_error ds ->
    q32_min + 16 * Z.of_nat n <= pow_integer a n <=
    q32_max - 16 * Z.of_nat n ->
    in_q32 (pow_model a n ds).
Proof.
  intros a n ds Hlen Hsafe Hmargin.
  apply (bounded_error_preserves_q32
           (pow_integer a n)
           (sum_errors ds)
           (16 * Z.of_nat n)).
  - lia.
  - pose proof (sum_errors_bound ds Hsafe) as Hbound.
    rewrite Hlen in Hbound.
    lia.
  - exact Hmargin.
Qed.

(* توثيق لحدود الادعاء: هذه فرضية ربط، وليست برهاناً مستنتجاً من النموذج. *)
Parameter assembly_pow_refines_model : Prop.

Theorem model_does_not_claim_assembly_refinement :
  assembly_pow_refines_model -> assembly_pow_refines_model.
Proof.
  intro H. exact H.
Qed.

Print Assumptions sum_errors_bound.
Print Assumptions pow_model_error_bound.
Print Assumptions pow_model_no_overflow_under_margin.
