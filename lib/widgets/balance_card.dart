import 'package:flutter/material.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:janseva/widgets/gradient_button.dart';
import '../utils/constants.dart';
import 'custom_button.dart';

class BalanceCard extends StatelessWidget {
  final String title;
  final String amountText;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;
  final String primaryText;
  final String secondaryText;

  const BalanceCard({
    super.key,
    required this.title,
    required this.amountText,
    required this.onPrimary,
    required this.onSecondary,
    this.primaryText = 'Deposit',
    this.secondaryText = 'Withdraw',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      decoration: BoxDecoration(
        // Sky blue gradient from dark to light
        // gradient: LinearGradient(
        //   colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        color: context.colors.specialCard,

        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        // Subtle shadow for depth
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.primary.withOpacity(0.2),
        //     blurRadius: 16,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.all(8),
          //       decoration: BoxDecoration(
          //         color: Colors.white.withOpacity(0.2),
          //         borderRadius: BorderRadius.circular(AppSizes.radiusM),
          //       ),
          //       child: const Icon(
          //         Icons.account_balance_wallet,
          //         color: Colors.white,
          //         size: 22,
          //       ),
          //     ),
          //     const SizedBox(width: AppSizes.paddingM),

          //   ],
          // ),
          Text(
            title,
            style: AppTextStyles.body1.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            amountText,
            style: AppTextStyles.heading1.copyWith(
              color: context.colors.text,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  onTap: onPrimary,
                  text: primaryText,
                  showIcon: false,

                  // backgroundColor: context.colors.brandColor,
                  // textColor: context.colors.textLight,
                  height: 46,
                ),
              ),
              const SizedBox(width: AppSizes.paddingL),
              Expanded(
                child: CustomButton(
                  onPressed: onSecondary,
                  text: secondaryText,
                  backgroundColor: context.colors.bgColors,
                  // textColor: context.colors.brandColor,
                  height: 46,
                  useGradientText: true,
                  // variant: ButtonVariant.outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
