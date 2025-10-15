import 'package:flutter/material.dart';
import '../utils/constants.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final isOutlined = variant == ButtonVariant.outlined;
    final primaryColor = backgroundColor ?? AppColors.primary;
    
    return Container(
      height: height ?? AppSizes.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        // Minimal shadow for subtle depth (only for filled buttons)
        boxShadow: isOutlined ? null : [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
              Text(
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
