import 'package:flutter/material.dart';
import 'package:janseva/utils/theme_extension.dart';
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
        color: context.colors.brandColor,

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingS),
                decoration: BoxDecoration(
                  color: context.colors.specialCard.withAlpha(50),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: context.colors.specialCard,
                  size: AppSizes.iconSizeL,
                ),
              ),
              const SizedBox(width: AppSizes.paddingS),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading3.copyWith(
                      color: context.colors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    amountText,
                    style: AppTextStyles.heading3.copyWith(
                      color: context.colors.textLight,
                      // fontSize: 32,
                      // fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: onPrimary,
                  text: primaryText,
                  backgroundColor: context.colors.specialCard,
                  textColor: context.colors.brandColor,
                  height: 46,
                ),
              ),
              const SizedBox(width: AppSizes.paddingL),
              Expanded(
                child: CustomButton(
                  onPressed: onSecondary,
                  text: secondaryText,
                  backgroundColor: context.colors.specialCard.withAlpha(120),
                  textColor: context.colors.specialCard,
                  height: 46,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
