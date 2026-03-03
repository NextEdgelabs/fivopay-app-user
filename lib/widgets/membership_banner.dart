import 'package:flutter/material.dart';

import 'package:janseva/utils/theme_extension.dart';
import '../services/common_utils.dart';
import '../utils/constants.dart';
import 'gradient_button.dart';

class MembershipBanner extends StatelessWidget {
  final VoidCallback onBecomeMember;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const MembershipBanner({
    super.key,
    required this.onBecomeMember,
    this.showCloseButton = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sectionSpacing),
      padding: const EdgeInsets.all(AppSizes.paddingXL),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        color: context.colors.specialCard,
        boxShadow: [
          // BoxShadow(
          //   color: AppColors.primary.withOpacity(0.3),
          //   blurRadius: 16,
          //   offset: const Offset(0, 6),
          // ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingS,
                  vertical: AppSizes.paddingS,
                ),
                decoration: BoxDecoration(
                  color: context.colors.famerStrokeOrange,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
                child: Image.asset(
                  'assets/icons/becomemember.png',
                  width: 32,
                  height: 32,
                ),
              ),
              InkWell(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.paddingXS),
                  decoration: BoxDecoration(
                    // color: context.colors.border,
                    border: Border.all(color: context.colors.border),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                  ),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              // const SizedBox(width: AppSizes.paddingL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Become a Member',
                      style: AppTextStyles.heading2.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Unlock exclusive benefits',
                      style: AppTextStyles.body2.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingXL),

          // CTA Button
          GradientButton(
            onTap: onBecomeMember,
            text: 'Join Now',
            height: 50,
            width: double.infinity,
          ),
       
        ],
      ),
    );
  }

  Widget _buildBenefit(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: AppSizes.paddingM),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body2.copyWith(
              color: Colors.white.withOpacity(0.95),
            ),
          ),
        ),
      ],
    );
  }
}

// Compact version for smaller spaces
class CompactMembershipBanner extends StatelessWidget {
  final VoidCallback onBecomeMember;

  const CompactMembershipBanner({super.key, required this.onBecomeMember});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingL),
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingS),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Become a Member',
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Get exclusive benefits',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onBecomeMember,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
              ),
              elevation: 0,
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
