import 'package:flutter/material.dart';
import '../services/common_utils.dart';
import '../utils/constants.dart';
import 'gradient_text.dart';

enum ButtonVariant { filled, outlined }

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final IconData? icon;
  final ButtonVariant variant;
  final bool useGradientText;
  final bool useGradientBorder;
  final Gradient? gradientBorder;
  final Color? disabledColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.icon,
    this.variant = ButtonVariant.filled,
    this.useGradientText = false,
    this.useGradientBorder = false,
    this.gradientBorder,
    this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    final isOutlined = variant == ButtonVariant.outlined;
    final primaryColor = backgroundColor ?? AppColors.primary;

    // If outlined variant with gradient border
    if (isOutlined && useGradientBorder) {
      return Container(
        height: height ?? AppSizes.buttonHeight,
        decoration: BoxDecoration(
          gradient: gradientBorder ?? brandlinearGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
        child: Container(
          margin: const EdgeInsets.all(2), // Border width
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusM - 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(AppSizes.radiusM - 1),
              child: Center(child: _buildButtonContent()),
            ),
          ),
        ),
      );
    }

    return Container(
      height: height ?? AppSizes.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        // Minimal shadow for subtle depth (only for filled buttons)
        // boxShadow: isOutlined
        //     ? null
        //     : [
        //         BoxShadow(
        //           color: AppColors.shadow,
        //           blurRadius: 8,
        //           offset: const Offset(0, 2),
        //         ),
        //       ],
      ),
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor ?? primaryColor,
                side: BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              ),
              child: _buildButtonContent(),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: textColor ?? Colors.white,
                disabledBackgroundColor: disabledColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              ),
              child: _buildButtonContent(),
            ),
    );
  }

  Widget _buildButtonContent() {
    final isOutlined = variant == ButtonVariant.outlined;
    final primaryColor = backgroundColor ?? AppColors.primary;

    return isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? primaryColor : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: isOutlined
                      ? (textColor ?? primaryColor)
                      : (textColor ?? Colors.white),
                ),
                const SizedBox(width: AppSizes.paddingS),
              ],
              useGradientText
                  ? GradientText(
                      text,
                      style: AppTextStyles.button.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      gradient: brandlinearGradient,
                    )
                  : Text(
                      text,
                      style: AppTextStyles.button.copyWith(
                        color: isOutlined
                            ? (textColor ?? primaryColor)
                            : (textColor ?? Colors.white),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ],
          );
  }
}
