import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import '../utils/constants.dart';

class VerificationStatusCard extends StatelessWidget {
  const VerificationStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        final isPANVerified = loanProvider.isPANVerified;
        final isAadhaarVerified = loanProvider.isAadhaarVerified;
        final allVerified = isPANVerified && isAadhaarVerified;

        return Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
            border: Border.all(
              color: allVerified ? AppColors.success : AppColors.border,
              width: allVerified ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    allVerified ? Icons.verified : Icons.security,
                    color: allVerified ? AppColors.success : AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Text(
                    'Verification Status',
                    style: AppTextStyles.heading3,
                  ),
                  const Spacer(),
                  if (allVerified)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM,
                        vertical: AppSizes.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusL),
                      ),
                      child: Text(
                        'Complete',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingL),
              
              // PAN verification status
              _buildVerificationItem(
                icon: Icons.credit_card,
                title: 'PAN Verification',
                isVerified: isPANVerified,
                maskedValue: isPANVerified 
                    ? _maskPAN(loanProvider.relativePAN ?? '')
                    : null,
                verificationDate: loanProvider.panVerificationDate,
              ),
              
              const SizedBox(height: AppSizes.paddingM),
              
              // Aadhaar verification status
              _buildVerificationItem(
                icon: Icons.fingerprint,
                title: 'Aadhaar Verification',
                isVerified: isAadhaarVerified,
                maskedValue: isAadhaarVerified 
                    ? _maskAadhaar(loanProvider.relativeAadhaar ?? '')
                    : null,
                verificationDate: loanProvider.aadhaarVerificationDate,
              ),
              
              const SizedBox(height: AppSizes.paddingL),
              
              // Overall progress
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: allVerified 
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                child: Row(
                  children: [
                    Icon(
                      allVerified ? Icons.check_circle : Icons.info,
                      color: allVerified ? AppColors.success : AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: AppSizes.paddingM),
                    Expanded(
                      child: Text(
                        allVerified
                            ? 'All verifications completed. You can now proceed with loan application.'
                            : 'Please complete all verifications before proceeding.',
                        style: AppTextStyles.body2.copyWith(
                          color: allVerified ? AppColors.success : AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVerificationItem({
    required IconData icon,
    required String title,
    required bool isVerified,
    String? maskedValue,
    String? verificationDate,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: isVerified 
            ? AppColors.success.withOpacity(0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: isVerified ? AppColors.success : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isVerified ? AppColors.success : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXS),
                if (isVerified && maskedValue != null) ...[
                  Text(
                    maskedValue,
                    style: AppTextStyles.body2,
                  ),
                  if (verificationDate != null) ...[
                    const SizedBox(height: AppSizes.paddingXS),
                    Text(
                      'Verified on ${_formatDate(verificationDate)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ] else ...[
                  Text(
                    'Not verified',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            isVerified ? Icons.check_circle : Icons.pending,
            color: isVerified ? AppColors.success : AppColors.warning,
            size: 24,
          ),
        ],
      ),
    );
  }

  String _maskPAN(String pan) {
    if (pan.length != 10) return pan;
    return '${pan.substring(0, 2)}****${pan.substring(8)}';
  }

  String _maskAadhaar(String aadhaar) {
    if (aadhaar.length != 12) return aadhaar;
    return 'XXXX XXXX ${aadhaar.substring(8)}';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}