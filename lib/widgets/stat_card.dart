import 'package:flutter/material.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../utils/constants.dart';

class StatCard extends StatelessWidget {
  final String icon;
  final String? label;
  final String value;
  final Color? color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    this.label,
    required this.value,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: context.colors.specialCard,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          // border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Icon(icon, color: AppColors.textLight, size: AppSizes.iconSizeS),
            if (label != null) ...[
              const SizedBox(height: AppSizes.paddingS),
              Text(label!, style: AppTextStyles.caption),
              // const SizedBox(height:),
            ],

            Padding(
              padding: const EdgeInsets.only(top: AppSizes.paddingS),
              child: Text(
                value,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingXS),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                "assets/icons/$icon.png",
                fit: BoxFit.contain,
                width: 0.15 * AppSizes.dW,
                height: 0.15 * AppSizes.dW,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
