import 'package:flutter/material.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../../../utils/constants.dart';

class MembershipProgressCard extends StatelessWidget {
  final int currentShares;
  final int targetShares;
  final String title;
  final String subtitle;

  const MembershipProgressCard({
    super.key,
    required this.currentShares,
    required this.targetShares,
    this.title = 'Become a Member',
    this.subtitle = 'Buy shares worth ₹ 1000',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.dW,
      padding: EdgeInsets.all(AppSizes.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.gradientOne, context.colors.gradientTwo],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        boxShadow: [
          BoxShadow(
            color: context.colors.gradientTwo.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
                child: Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: AppSizes.iconSizeL,
                ),
              ),
              SizedBox(width: AppSizes.paddingL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingXL),
          // Progress container
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Progress',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: AppSizes.paddingS),
                Text(
                  '$currentShares/$targetShares Shares',
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
