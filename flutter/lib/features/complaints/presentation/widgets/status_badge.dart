import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// دورة حياة الشكوى الموحّدة (3 مراحل مؤكدة من الـFigma — القسم 3.5/3.8).
/// Enum مش String علشان نمنع typos وحالات غير صالحة (invalid states) —
/// المطابقة مع slug الـbackend بتتم في data layer الخاص بكل feature
/// (Mapper)، مش هنا.
enum ComplaintStatus { received, inReview, resolved }

/// بادج لوني صلد لحالة الشكوى — **بعد مراجعة الـFigma الحقيقية (24 أغسطس
/// 2026)، تصحيح جوهري عن النسخة القديمة**: الشكل الحقيقي في Complaints List
/// خلفية لونية صلدة + نص أبيض (مش soft-tint زي ما كان مفترض قبل كده)، والألوان
/// نفسها مختلفة تمامًا: "قيد المعالجة" برتقالي #F77F00 (كان مفترض أصفر/برتقالي
/// تقريبي)، "تم الحل" كحلي #002960 (**كان مفترض أخضر — غلط تمامًا**).
///
/// [Requires Confirmation] "تم الاستلام" (received) مفيش مثال Chip حقيقي
/// ليها ظاهر في العينة اللي روجعت (3 كروت بس، ولا واحدة "تم الاستلام") —
/// اللون تحت [AppColors.statusReceivedChip] لسه placeholder رمادي لحد ما
/// نلاقي مثال فعلي أو تأكيد.
///
/// النص المعروض بارامتر مستقل (`label`) لحد ما يترتبط بـARB الفعلي مع
/// الـfeature اللي بتستخدمه — لاحظي: الـFigma نفسه استخدم صياغتين مختلفتين
/// لنفس حالة "قيد المراجعة/قيد المعالجة" في شاشتين مختلفتين (راجعي تقرير
/// الجلسة) — الصياغة النهائية للـARB لسه [Requires Confirmation].
class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, required this.label, super.key});

  final ComplaintStatus status;
  final String label;

  Color get _backgroundColor => switch (status) {
        ComplaintStatus.received => AppColors.statusReceivedChip,
        ComplaintStatus.inReview => AppColors.statusInProgressChip,
        ComplaintStatus.resolved => AppColors.statusResolvedChip,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05) — مطابق للـFigma
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Text(label, style: AppTypography.statusChipLabel),
    );
  }
}

/// شريط تقدّم أفقي (stepper) لحالة الشكوى — الشكل الثاني اللي ظهر في
/// الـFigma لنفس مفهوم الحالة، مستخدم في صفحة تفاصيل الشكوى (Complaint
/// Details) بدل الـchip المستخدم في القائمة. **مختلف بصريًا عن [StatusBadge]
/// عمدًا** — الـFigma نفسه استخدم شكلين مختلفين لنفس المفهوم في شاشتين
/// مختلفتين، فمفيش داعي نخترع widget واحد يغطي الاتنين بالقسر.
///
/// الشكل الحقيقي: خط اتصال رمادي + جزء ذهبي ممتلئ للمراحل اللي وصلنا لها،
/// و3 دوائر (وصلنا لها = ذهبي، لسه = رمادي) — بدون ألوان مختلفة لكل حالة
/// بعينها (على عكس [StatusBadge]).
class ComplaintStatusStepper extends StatelessWidget {
  const ComplaintStatusStepper({
    required this.currentStatus,
    required this.receivedLabel,
    required this.inReviewLabel,
    required this.resolvedLabel,
    super.key,
  });

  final ComplaintStatus currentStatus;
  final String receivedLabel;
  final String inReviewLabel;
  final String resolvedLabel;

  int get _reachedStepCount => switch (currentStatus) {
        ComplaintStatus.received => 1,
        ComplaintStatus.inReview => 2,
        ComplaintStatus.resolved => 3,
      };

  @override
  Widget build(BuildContext context) {
    final labels = [receivedLabel, inReviewLabel, resolvedLabel];

    return Column(
      children: [
        Row(
          children: List.generate(3, (index) {
            final isReached = index < _reachedStepCount;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(left: index == 0 ? 0 : AppSpacing.xs),
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: isReached
                      ? AppColors.statusStepReached
                      : AppColors.statusStepPending,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (index) {
            final isReached = index < _reachedStepCount;
            return Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isReached
                        ? AppColors.statusStepReached
                        : AppColors.statusStepPending,
                    border: Border.all(
                      color: AppColors.statusStepBorder,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  labels[index],
                  style: AppTypography.stepLabel.copyWith(
                    color: isReached
                        ? AppColors.headerBackground
                        : AppColors.textSecondaryGrey,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
