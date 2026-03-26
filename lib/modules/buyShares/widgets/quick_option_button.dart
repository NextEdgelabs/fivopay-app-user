import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:janseva/widgets/gradient_icon.dart';
import '../../../utils/constants.dart';

class QuickOptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const QuickOptionButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingL,
          horizontal: AppSizes.paddingM,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GradientIcon(
              icon: Iconsax.flash_1,
              size: AppSizes.iconSizeL,
              gradientColors: [
                context.colors.gradientOne,
                context.colors.gradientTwo,
              ],
            ),
            // Icon(Icons.bolt, color: const Color(0xFF7C3AED), size: 20),
            SizedBox(width: AppSizes.paddingXS),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,

                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
