import 'package:flutter/material.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../utils/constants.dart';

class UserInfoCard extends StatelessWidget {
  final String name;
  final String accountNumber;
  final String memberSince;
  final bool isPro;

  const UserInfoCard({
    super.key,
    required this.name,
    required this.accountNumber,
    required this.memberSince,
    this.isPro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: context.colors.specialCard,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Hello, $name',
                  style: AppTextStyles.heading2.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // if (isPro)
              //   Container(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: AppSizes.paddingS,
              //       vertical: 4,
              //     ),
              //     decoration: BoxDecoration(
              //       color: context.colors.brandColor.withOpacity(0.1),
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: Text(
              //       'PRO',
              //       style: TextStyle(
              //         color: context.colors.brandColor,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 12,
              //       ),
              //     ),
              //   ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 16,
                color: context.colors.textSecondary,
              ),
              const SizedBox(width: AppSizes.paddingS),
              Text(
                'A/C: $accountNumber',
                style: AppTextStyles.body1.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: context.colors.textSecondary,
              ),
              const SizedBox(width: AppSizes.paddingS),
              Text(
                'Member Since $memberSince',
                style: AppTextStyles.body1.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
