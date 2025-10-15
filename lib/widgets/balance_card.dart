import 'package:flutter/material.dart';
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
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        // Subtle shadow for depth
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingL),
          Text(
            amountText,
            style: AppTextStyles.heading1.copyWith(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXL),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: onPrimary,
                  text: primaryText,
                  backgroundColor: Colors.white,
                  textColor: AppColors.primary,
                  height: 46,
                ),
              ),
              const SizedBox(width: AppSizes.paddingL),
              Expanded(
                child: CustomButton(
                  onPressed: onSecondary,
                  text: secondaryText,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  textColor: Colors.white,
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
