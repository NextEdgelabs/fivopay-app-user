import 'package:flutter/material.dart';
import '../services/kyc_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

/// Screen to display PAN verification results and confirmation
class PanConfirmationScreen extends StatelessWidget {
  final PanVerificationResponse verificationResponse;
  final String enteredName;
  final VoidCallback onConfirm;
  final VoidCallback onRetry;

  const PanConfirmationScreen({
    super.key,
    required this.verificationResponse,
    required this.enteredName,
    required this.onConfirm,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final panData = verificationResponse.data;
    final isSuccess =
        verificationResponse.data.nameMatch &&
        verificationResponse.data.dobMatch;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PAN Verification Result'),
        elevation: 0,
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: isSuccess
                        ? AppColors.success.withOpacity(0.12)
                        : AppColors.error.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    size: 60,
                    color: isSuccess ? AppColors.success : AppColors.error,
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.paddingXL),

              // Status Message
              Text(
                isSuccess ? panData.statusMessage : 'PAN verification failed.',
                style: AppTextStyles.heading2.copyWith(
                  color: isSuccess ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.paddingS),

              if (panData.remarks != null)
                Text(
                  panData.remarks!,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: AppSizes.sectionSpacing),

              // Verification Details Card
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingXL),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                  border: Border.all(
                    color: isSuccess
                        ? AppColors.success.withOpacity(0.3)
                        : AppColors.error.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Verification Details', style: AppTextStyles.heading3),
                    const SizedBox(height: AppSizes.paddingL),

                    // PAN Number
                    _buildDetailRow(
                      icon: Icons.credit_card,
                      label: 'PAN Number',
                      value: panData.pan,
                      iconColor: AppColors.primary,
                    ),

                    const Divider(height: AppSizes.paddingXL),

                    // Status
                    _buildDetailRow(
                      icon: panData.status == 'valid'
                          ? Icons.check_circle
                          : Icons.cancel,
                      label: 'Status',
                      value: panData.status.toUpperCase(),
                      iconColor: panData.status == 'valid'
                          ? AppColors.success
                          : AppColors.error,
                      valueColor: panData.status == 'valid'
                          ? AppColors.success
                          : AppColors.error,
                    ),

                    const Divider(height: AppSizes.paddingXL),

                    // Name Verification
                    _buildDetailRow(
                      icon: panData.nameMatch
                          ? Icons.check_circle
                          : Icons.cancel,
                      label: 'Name Match',
                      value: panData.nameMatch ? 'Verified' : 'Not Matched',
                      iconColor: panData.nameMatch
                          ? AppColors.success
                          : AppColors.warning,
                      valueColor: panData.nameMatch
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                    const Divider(height: AppSizes.paddingXL),
                    _buildDetailRow(
                      icon: panData.dobMatch
                          ? Icons.check_circle
                          : Icons.cancel,
                      label: 'Dob Match',
                      value: panData.dobMatch ? 'Verified' : 'Not Matched',
                      iconColor: panData.dobMatch
                          ? AppColors.success
                          : AppColors.warning,
                      valueColor: panData.dobMatch
                          ? AppColors.success
                          : AppColors.warning,
                    ),

                    const Divider(height: AppSizes.paddingXL),

                    // Category
                    _buildDetailRow(
                      icon: Icons.person,
                      label: 'Category',
                      value: panData.category.toUpperCase(),
                      iconColor: AppColors.info,
                    ),

                    const Divider(height: AppSizes.paddingXL),

                    // Aadhaar Seeding Status
                    _buildDetailRow(
                      icon: panData.isAadhaarSeeded
                          ? Icons.link
                          : Icons.link_off,
                      label: 'Aadhaar Seeding',
                      value: panData.isAadhaarSeeded ? 'Linked' : 'Not Linked',
                      iconColor: panData.isAadhaarSeeded
                          ? AppColors.success
                          : AppColors.textSecondary,
                      valueColor: panData.isAadhaarSeeded
                          ? AppColors.success
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              // Transaction ID
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction ID',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingXS),
                    Text(
                      verificationResponse.transactionId,
                      style: AppTextStyles.body2.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.sectionSpacing),

              // Information Note
              if (isSuccess)
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    border: Border.all(color: AppColors.info.withOpacity(0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: AppColors.info, size: 20),
                      const SizedBox(width: AppSizes.paddingM),
                      Expanded(
                        child: Text(
                          'Your PAN details have been verified successfully. Please confirm to proceed with the loan application.',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: AppSizes.sectionSpacing),

              // Action Buttons
              if (isSuccess) ...[
                CustomButton(
                  onPressed: onConfirm,
                  text: 'Confirm & Continue',
                  icon: Icons.check,
                ),
                const SizedBox(height: AppSizes.paddingL),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ] else ...[
                CustomButton(
                  onPressed: onRetry,
                  text: 'Try Again',
                  icon: Icons.refresh,
                  backgroundColor: AppColors.error,
                ),
                const SizedBox(height: AppSizes.paddingL),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: AppSizes.paddingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
