import 'package:flutter/material.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../../../utils/constants.dart';

class PurchaseMethodButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isloading;
  final EdgeInsetsGeometry? padding;

  const PurchaseMethodButton({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.padding,
    this.isloading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.dW,
        padding:
            padding ??
            EdgeInsets.symmetric(
              vertical: AppSizes.paddingM,
              horizontal: AppSizes.paddingL,
            ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    context.colors.gradientOne,
                    context.colors.gradientTwo,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
            width: 1,
          ),
        ),
        child: isloading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                      size: AppSizes.iconSizeM,
                    ),
                    SizedBox(height: AppSizes.paddingS),
                  ],

                  Text(
                    label,
                    style: AppTextStyles.body1.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
