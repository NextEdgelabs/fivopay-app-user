import 'package:flutter/material.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../services/common_utils.dart';
import '../utils/constants.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final double? width;
  final double? height;
  final IconData? icon;
  final double? iconSize;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final Color? textColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final bool showIcon;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.text,
    this.width,
    this.height = 50,
    this.icon = Icons.arrow_forward,
    this.iconSize = 20,
    this.gradient,
    this.borderRadius,
    this.textStyle,
    this.textColor,
    this.iconColor,
    this.padding,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusL),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? brandlinearGradient,
          borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.radiusL),
        ),
        width: width ?? double.infinity,
        height: height,
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: width == null ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Text(
              text,
              style:
                  textStyle ??
                  AppTextStyles.button.copyWith(
                    color: textColor ?? context.colors.buttonLabelText,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (showIcon && icon != null) ...[
              const SizedBox(width: AppSizes.paddingS),
              Icon(
                icon,
                size: iconSize,
                color: iconColor ?? textColor ?? context.colors.buttonLabelText,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
