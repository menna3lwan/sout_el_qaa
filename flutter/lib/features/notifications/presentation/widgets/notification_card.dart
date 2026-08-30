import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/widgets/bidi_aware_text.dart';
import '../../domain/entities/app_notification.dart';

/// The icon+pastel-badge mapping reuses the existing "notification badge" color tokens
/// (app_colors.dart) per notification type.
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    required this.notification,
    required this.onTap,
    super.key,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  static const _iconByType = <NotificationType, IconData>{
    NotificationType.statusUpdate: Icons.autorenew,
    NotificationType.newComment: Icons.chat_bubble_outline,
    NotificationType.reaction: Icons.favorite_outline,
    NotificationType.general: Icons.campaign_outlined,
  };

  static const _badgeColorByType = <NotificationType, Color>{
    NotificationType.statusUpdate: AppColors.notificationBadgeGreen,
    NotificationType.newComment: AppColors.notificationBadgeBlue,
    NotificationType.reaction: AppColors.notificationBadgeYellow,
    NotificationType.general: AppColors.notificationBadgeGreenAlt,
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.surfaceWhite
              : AppColors.glassOverlayNotificationCard,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: notification.isRead
                ? AppColors.cardBorder
                : AppColors.notificationCardAccent.withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _badgeColorByType[notification.type],
                shape: BoxShape.circle,
              ),
              child: Icon(
                _iconByType[notification.type],
                size: 20,
                color: AppColors.textPrimaryDark,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BidiAwareText(
                    notification.title,
                    style: AppTypography.notificationCardTitle.copyWith(
                      fontWeight: notification.isRead
                          ? FontWeight.w400
                          : FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormatter.relative(
                      notification.createdAt,
                      l10n: context.l10n,
                    ),
                    style: AppTypography.metaText.copyWith(
                      color: AppColors.notificationTimestampText,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.notificationUnreadDot,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
