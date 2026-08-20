(*
  UORI — C40 Semantic Link Draft

  هذا الملف يعرّف آلة مجردة صغيرة تقابل حالة حلقة square-and-multiply.
  يثبت ثوابت ما قبل الحلقة وبعض خواص الانتقال المجرد.
  لا يثبت بعد أن تعليمات NASM الفعلية تحقق step_asm؛ تلك علاقة ربط
  مستقلة يجب إثباتها أو تفريغها إلى تحقق عتادي/مترجم موثق.
*)
From Coq Require Import ZArith Lia.

Open Scope Z_scope.

Definition q32_scale : Z := 4294967296.
Definition q32_min : Z := -2147483648 * q32_scale.
Definition q32_max : Z :=  2147483647 * q32_scale + (q32_scale - 1).

Definition in_q32 (x : Z) : Prop := q32_min <= x <= q32_max.
Definition in_exp (n : Z) : Prop := 0 <= n <= 31.

Record pow_state := {
  st_result : Z;
  st_factor : Z;
  st_exp : Z
}.

Definition initial_state (a n : Z) : pow_state :=
  {| st_result := q32_scale; st_factor := a; st_exp := n |}.

(* إسقاط ضرب Q32.32 مجرد: r هو الناتج، و e خطأ الإسقاط بوحدات Q32.32. *)
Definition qmul_with_error (x y r e : Z) : Prop :=
  2 * q32_scale * r = 2 * x * y + 2 * q32_scale * e.

Definition valid_projection_error (e : Z) : Prop := -16 <= e <= 16.

Definition state_safe (s : pow_state) : Prop :=
  in_q32 (st_result s) /\ in_q32 (st_factor s) /\ in_exp (st_exp s).

Definition bit_one (n : Z) : Prop := exists k : Z, n = 2 * k + 1.

(* انتقال مجرد يطابق ترتيباً تعليمياً: تطبيق العامل عند البت 1،
   ثم إزاحة الأس وتربيع العامل ما دام بقيت بتات. *)
Definition result_step (s s' : pow_state) (e : Z) : Prop :=
  st_exp s > 0 /\
  bit_one (st_exp s) /\
  qmul_with_error (st_result s) (st_factor s)
    (st_result s') e /\
  st_factor s' = st_factor s /\
  st_exp s' = st_exp s.

Definition square_step (s s' : pow_state) (e : Z) : Prop :=
  st_exp s > 0 /\
  qmul_with_error (st_factor s) (st_factor s)
    (st_factor s') e /\
  st_result s' = st_result s /\
  st_exp s' = st_exp s / 2.

Lemma initial_state_exp_invariant :
  forall a n, in_exp n -> st_exp (initial_state a n) = n.
Proof. intros; reflexivity. Qed.

Lemma initial_state_result_is_one :
  forall a n, st_result (initial_state a n) = q32_scale.
Proof. intros; reflexivity. Qed.

Lemma exponent_check_sound :
  forall n, 0 <= n <= 31 -> in_exp n.
Proof. intros; unfold in_exp; lia. Qed.

Lemma exponent_shift_preserves_nonneg :
  forall n, 0 <= n -> 0 <= n / 2.
Proof. intros; apply Z.div_pos; lia. Qed.

Lemma exponent_shift_decreases_for_positive :
  forall n, 1 <= n -> n / 2 < n.
Proof. intros; apply Z.div_lt; lia.
Qed.

Lemma exponent_shift_preserves_range :
  forall n, in_exp n -> in_exp (n / 2).
Proof.
  intros n H. unfold in_exp in *. split.
  - apply exponent_shift_preserves_nonneg; lia.
  - apply Z.div_le_upper_bound; lia.
Qed.

Lemma initial_state_safe :
  forall a n, in_q32 a -> in_exp n -> state_safe (initial_state a n).
Proof.
  intros a n Ha Hn. unfold state_safe, initial_state.
  split.
  - change (-9223372036854775808 <= 4294967296 <= 9223372036854775807).
    split; lia.
  - split; assumption.
Qed.

Lemma qmul_with_error_unique_result :
  forall x y r1 r2 e,
    qmul_with_error x y r1 e ->
    qmul_with_error x y r2 e ->
    r1 = r2.
Proof.
  intros x y r1 r2 e H1 H2.
  unfold qmul_with_error, q32_scale in *.
  nia.
Qed.

Lemma qmul_zero_error_exact :
  forall x y r,
    qmul_with_error x y r 0 ->
    2 * q32_scale * r = 2 * x * y.
Proof. intros; unfold qmul_with_error, q32_scale in *; nia. Qed.

(* إسقاط signed-128 بصيغة حسابية مجردة. لا يعتمد هذا التعريف على
   تعليمات المعالج؛ وهو العقد الرياضي الذي يجب أن يطابقه مسار Assembly. *)
Definition q32_project (p : Z) : Z := p / q32_scale.
Definition q32_remainder (p : Z) : Z := p mod q32_scale.

Lemma q32_projection_decomposition :
  forall p,
    p = q32_scale * q32_project p + q32_remainder p.
Proof.
  intros p. unfold q32_project, q32_remainder, q32_scale.
  pose proof (Z.div_mod p 4294967296) as H.
  nia.
Qed.

Lemma q32_remainder_nonnegative :
  forall p, 0 <= q32_remainder p.
Proof.
  intros p. unfold q32_remainder, q32_scale.
  pose proof (Z.mod_pos_bound p 4294967296) as H.
  lia.
Qed.

Lemma q32_remainder_below_scale :
  forall p, q32_remainder p < q32_scale.
Proof.
  intros p. unfold q32_remainder, q32_scale.
  pose proof (Z.mod_pos_bound p 4294967296) as H.
  lia.
Qed.

Lemma q32_projection_exact_when_divisible :
  forall p r,
    p = q32_scale * r -> q32_project p = r.
Proof.
  intros p r Hp. unfold q32_project, q32_scale.
  rewrite Hp. rewrite Z.mul_comm.
  apply Z_div_mult. lia.
Qed.

(* مقابلة مجردة مع سجلات التنفيذ. ترتيب الإسقاط يحفظ معنى كل سجل؛
   هذه لمّة تعريفية وليست برهاناً على تعليمات CPU. *)
Definition asm_view (s : pow_state) (rax r8 r9 rcx : Z) : Prop :=
  rax = st_result s /\ r8 = st_result s /\
  r9 = st_factor s /\ rcx = st_exp s.

Lemma asm_view_unique :
  forall s rax r8 r9 rcx rax' r8' r9' rcx',
    asm_view s rax r8 r9 rcx ->
    asm_view s rax' r8' r9' rcx' ->
    rax = rax' /\ r8 = r8' /\ r9 = r9' /\ rcx = rcx'.
Proof.
  intros s rax r8 r9 rcx rax' r8' r9' rcx' H H'.
  unfold asm_view in *. destruct H as [Hrax [Hr8 [Hr9 Hrcx]]].
  destruct H' as [Hrax' [Hr8' [Hr9' Hrcx']]].
  subst; auto.
Qed.

(* واجهات اللمم الثلاث. هذه تعريفات للعقود المطلوبة، وليست نتائج مستنتجة
   من Coq الحالي؛ إثباتها يتطلب نموذجاً لتعليمات NASM أو تحققاً عتادياً موثقاً. *)
Definition asm_result_transition (s s' : pow_state)
    (rax rdx r8 r9 rcx : Z) (e : Z) : Prop :=
  asm_view s rax r8 r9 rcx /\
  result_step s s' e /\
  rax = st_result s' /\ r8 = st_result s'.

Definition asm_square_transition (s s' : pow_state)
    (rax rdx r8 r9 rcx : Z) (e : Z) : Prop :=
  asm_view s rax r8 r9 rcx /\
  square_step s s' e /\
  rax = st_factor s' /\ r9 = st_factor s'.

Definition asm_reject_condition (s : pow_state) (rax rcx : Z) : Prop :=
  (st_exp s < 0 \/ 31 < st_exp s \/
   (st_result s = 0 /\ st_exp s = 0)) /\
  rax = st_result s /\ rcx = st_exp s.

Parameter step_asm_refines_result :
  forall s s' rax rdx r8 r9 rcx e,
    asm_result_transition s s' rax rdx r8 r9 rcx e.
Parameter step_asm_refines_square :
  forall s s' rax rdx r8 r9 rcx e,
    asm_square_transition s s' rax rdx r8 r9 rcx e.
Parameter reject_paths_sound :
  forall s rax rcx, asm_reject_condition s rax rcx -> True.

Theorem semantic_link_contracts_assumed :
  (forall s s' rax rdx r8 r9 rcx e,
      asm_result_transition s s' rax rdx r8 r9 rcx e) /\
  (forall s s' rax rdx r8 r9 rcx e,
      asm_square_transition s s' rax rdx r8 r9 rcx e) /\
  (forall s rax rcx, asm_reject_condition s rax rcx -> True) ->
  (forall s s' rax rdx r8 r9 rcx e,
      asm_result_transition s s' rax rdx r8 r9 rcx e) /\
  (forall s s' rax rdx r8 r9 rcx e,
      asm_square_transition s s' rax rdx r8 r9 rcx e) /\
  (forall s rax rcx, asm_reject_condition s rax rcx -> True).
Proof. intros H; exact H. Qed.

Print Assumptions asm_view_unique.
Print Assumptions semantic_link_contracts_assumed.
