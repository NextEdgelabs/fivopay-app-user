import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:janseva/main.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../../../utils/constants.dart';
import '../../../widgets/gradient_icon.dart';

class ShareInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String pricePerShare;
  final String yourShares;

  const ShareInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.pricePerShare,
    required this.yourShares,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.dW,
      padding: EdgeInsets.all(AppSizes.paddingXL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: context.colors.brandColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
                child: GradientIcon(
                  icon: Iconsax.graph,
                  size: AppSizes.iconSizeL,
                  gradientColors: [
                    context.colors.gradientOne,
                    context.colors.gradientTwo,
                  ],
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
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingXL),
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.currency_rupee,
                  label: 'Price per share',
                  value: pricePerShare,
                ),
              ),
              SizedBox(width: AppSizes.paddingL),
              Expanded(
                child: _buildStatItem(
                  icon: Iconsax.chart_21,
                  label: 'Your share',
                  value: yourShares,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientIcon(
          icon: icon,
          size: AppSizes.paddingXL,
          gradientColors: [
            bContext.colors.gradientOne,
            bContext.colors.gradientTwo,
          ],
        ),
        SizedBox(height: AppSizes.paddingXS),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.heading3.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
