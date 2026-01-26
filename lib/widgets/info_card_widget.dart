import 'package:flutter/material.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../utils/constants.dart';

class InfoCardWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final Color? labelColor;
  final Color? valueColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double? iconSize;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const InfoCardWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.labelColor,
    this.valueColor,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.iconSize,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingM,
            vertical: AppSizes.paddingL,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colors.bgColors,
        borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? AppColors.textPrimary,
            size: iconSize ?? AppSizes.iconSizeL,
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      labelStyle ??
                      AppTextStyles.heading3.copyWith(
                        color: labelColor ?? AppColors.textSecondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  value,
                  style:
                      valueStyle ??
                      AppTextStyles.heading3.copyWith(
                        color: valueColor ?? AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
