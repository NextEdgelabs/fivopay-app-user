import 'package:flutter/material.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../utils/constants.dart';

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;
  final double? iconSize;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.iconSize,
    this.textStyle,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusM),
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppSizes.paddingS),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.colors.specialCard,
          borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusM),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? context.colors.heading,
              size: iconSize ?? 24,
            ),
            SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Text(
                label,
                style: textStyle ?? AppTextStyles.heading3,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
