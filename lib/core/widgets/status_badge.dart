import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// دورة حياة الشكوى الموحّدة (3 مراحل مؤكدة من الـFigma — القسم 3.5/3.8).
/// Enum مش String علشان نمنع typos وحالات غير صالحة (invalid states) —
/// المطابقة مع slug الـbackend بتتم في data layer الخاص بكل feature
/// (Mapper)، مش هنا.
enum ComplaintStatus { received, inReview, resolved }

/// بادج بصري موحّد لحالة الشكوى — بيتستخدم في Complaints List، Complaint
/// Details، وTrending card في Home. النص المعروض هنا placeholder مؤقت لحد ما
/// يترتبط بـARB الفعلي مع الـfeature اللي بتستخدمه (النصوص الحقيقية:
/// "تم الاستلام"/"قيد المراجعة"/"تم الحل" مؤكدة من الـFigma).
class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, required this.label, super.key});

  final ComplaintStatus status;
  final String label;

  Color get _color => switch (status) {
        ComplaintStatus.received => AppColors.statusReceived,
        ComplaintStatus.inReview => AppColors.statusInReview,
        ComplaintStatus.resolved => AppColors.statusResolved,
      };

  Color get _backgroundColor => switch (status) {
        ComplaintStatus.received => AppColors.statusReceivedBg,
        ComplaintStatus.inReview => AppColors.statusInReviewBg,
        ComplaintStatus.resolved => AppColors.statusResolvedBg,
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
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
