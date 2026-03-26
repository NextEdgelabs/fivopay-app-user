import 'package:flutter/material.dart';
import '../../utils/app_color_extension.dart';
import '../../utils/constants.dart';

class NotificationEmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const NotificationEmptyState({Key? key, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding2XL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingXL),
              decoration: BoxDecoration(
                color: context.appColors.brandColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 64,
                color: context.appColors.brandColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              'No notifications yet',
              style: AppTextStyles.heading2.copyWith(
                color: context.appColors.heading,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              'When you have important updates, alerts, or messages, they will appear here.',
              style: AppTextStyles.body1.copyWith(
                color: context.appColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: AppSizes.paddingXL),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh, size: AppSizes.iconSizeS),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appColors.buttonColorLight,
                  foregroundColor: context.appColors.brandColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingL,
                    vertical: AppSizes.paddingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
