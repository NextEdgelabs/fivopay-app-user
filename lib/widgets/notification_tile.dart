import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/notification_model.dart';
import '../../utils/app_color_extension.dart';
import '../../utils/constants.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine styles based on notification type and read status
    final iconData = _getIconForType(notification.type);
    final typeColor = _getColorForType(context, notification.type);
    final backgroundColor = notification.isRead
        ? context.appColors.cardBackground
        : typeColor.withOpacity(0.05);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: context.appColors.border.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingS),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: typeColor, size: AppSizes.iconSizeM),
            ),
            const SizedBox(width: AppSizes.paddingM),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                            color: context.appColors.heading,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingS),
                      Text(
                        _formatTimeElapsed(notification.createdAt),
                        style: AppTextStyles.caption.copyWith(
                          color: context.appColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingXS),
                  Text(
                    notification.message,
                    style: AppTextStyles.body2.copyWith(
                      color: notification.isRead
                          ? context.appColors.textSecondary
                          : context.appColors.text,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Unread Indicator dot
            if (!notification.isRead) ...[
              const SizedBox(width: AppSizes.paddingS),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: AppSizes.paddingS),
                decoration: BoxDecoration(
                  color: context.appColors.brandColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return Icons.check_circle_outline;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'error':
        return Icons.error_outline;
      case 'info':
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForType(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'success':
        return context.appColors.alert1;
      case 'warning':
        return context.appColors.alert3;
      case 'error':
        return context.appColors.alert2;
      case 'info':
      default:
        return context.appColors.brandColor;
    }
  }

  String _formatTimeElapsed(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      if (difference.inMinutes == 0) return 'Just now';
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}
