import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../domain/entities/complaint.dart';

/// Severity -> flavored display label/icon/color for the Complaint Details severity pill — a
/// distinct display concept from [ComplaintSeverity]'s plain labels, which the Create Complaint
/// severity picker and review step keep unchanged.
String severityFlavorLabel(BuildContext context, ComplaintSeverity severity) =>
    switch (severity) {
      ComplaintSeverity.high => context.l10n.severityFlavorHigh,
      ComplaintSeverity.medium => context.l10n.severityFlavorMedium,
      ComplaintSeverity.low => context.l10n.severityFlavorLow,
    };

IconData severityFlavorIcon(ComplaintSeverity severity) => switch (severity) {
      ComplaintSeverity.high => Icons.local_fire_department,
      ComplaintSeverity.medium => Icons.report_problem_outlined,
      ComplaintSeverity.low => Icons.info_outline,
    };

/// The severity pill's soft-tint (background, border, text) triple — distinct from the solid
/// [AppColors.urgentBadgeAltDetailPage] "عاجل" badge above the title, which is a separate signal (see
/// that token's own doc comment).
({Color background, Color border, Color text}) severityFlavorPillColors(
  ComplaintSeverity severity,
) =>
    switch (severity) {
      ComplaintSeverity.high => (
          background: AppColors.severityHighPillBackground,
          border: AppColors.severityHighPillBorder,
          text: AppColors.severityHighPillText,
        ),
      ComplaintSeverity.medium => (
          background: AppColors.severityMediumPillBackground,
          border: AppColors.severityMediumPillBorder,
          text: AppColors.severityMediumPillText,
        ),
      ComplaintSeverity.low => (
          background: AppColors.severityLowPillBackground,
          border: AppColors.severityLowPillBorder,
          text: AppColors.severityLowPillText,
        ),
    };
