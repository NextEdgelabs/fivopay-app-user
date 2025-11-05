  import 'package:flutter/material.dart';
import 'package:janseva/routes/navigator.dart';

import '../../../../../utils/constants.dart';
import '../../../../../widgets/custom_button.dart';
import '../../../providers/loan_provider_v2.dart';

Widget buildAadhaarVerificationResult(LoanProviderV2 provider , VoidCallback resetForm) {
    final response = provider.aadhaarVerificationstatus!;
    final data = response.data;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success Header
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingXL),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusXL),
              border: Border.all(
                color: AppColors.success.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 64,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingL),
                Text(
                  'Verification Successful!',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingS),
                Text(
                  'Your Aadhaar has been verified successfully',
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.sectionSpacing),

          // User Details Card
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingXL),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusXL),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aadhaar Details',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: AppSizes.paddingL),
                
                if (data?.name != null) ...[
                  buildAadharDetailRow('Name', data!.name!),
                  const SizedBox(height: AppSizes.paddingM),
                ],
                
                if (data?.fullAddress != null) ...[
                  buildAadharDetailRow('Aadhaar Number',maskAadhaar(data!.fullAddress!)),
                  const SizedBox(height: AppSizes.paddingM),
                ],
                
                if (data?.dateOfBirth != null) ...[
                  buildAadharDetailRow('Date of Birth', data!.dateOfBirth!),
                  const SizedBox(height: AppSizes.paddingM),
                ],
                
                if (data?.gender != null) ...[
                  buildAadharDetailRow('Gender', data!.gender!),
                  const SizedBox(height: AppSizes.paddingM),
                ],
                
                if (data?.address != null) ...[
                  buildAadharDetailRow('Address', data!.fullAddress!),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSizes.padding2XL),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingL),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                    ),
                  ),
                  child: const Text('Verify Another'),
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: CustomButton(
                  onPressed: () {
                   pop();
                  },
                  text: 'Continue',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAadharDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String maskAadhaar(String aadhaar) {
    
    if (aadhaar.length < 12) return aadhaar;
    return 'XXXX XXXX ${aadhaar.substring(8)}';
  }