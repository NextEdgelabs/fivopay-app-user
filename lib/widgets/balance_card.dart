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
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryLight, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: AppSizes.paddingS),
              Text(
                title,
                style: AppTextStyles.body2.copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            amountText,
            style: AppTextStyles.heading2.copyWith(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: onPrimary,
                  text: primaryText,
                  backgroundColor: Colors.white,
                  textColor: AppColors.primary,
                  height: 40,
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: CustomButton(
                  onPressed: onSecondary,
                  text: secondaryText,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  textColor: Colors.white,
                  height: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
