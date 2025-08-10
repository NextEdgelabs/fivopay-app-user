import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/referral_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../components/components.dart';
import 'waiting_for_approval_screen.dart';
import '../services/auth_service.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final _formKey = GlobalKey<FormState>();
  final _panController = TextEditingController();
  final _aadharController = TextEditingController();
  final _referralController = TextEditingController();
  bool _isLoading = false;
  String _selectedKycType = 'digital'; // digital or video
  bool _panUploaded = false;
  bool _aadharUploaded = false;
  // Reserved for future selfie capture step
  // bool _photoUploaded = false;

  @override
  void dispose() {
    _panController.dispose();
    _aadharController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  Future<void> _submitKyc() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Update user with KYC information
      final updatedUser = userProvider.currentUser?.copyWith(
        kycStatus: 'completed',
        kycType: _selectedKycType,
        panNumber: _panController.text.trim(),
        aadharNumber: _aadharController.text.trim(),
        kycCompletedAt: DateTime.now(),
        isMember: true, // User becomes a member after KYC
      );

      if (updatedUser != null) {
        await userProvider.updateUser(updatedUser);

        // Update AuthProvider as well
        authProvider.updateCurrentUser(updatedUser);

        // Save updated user data to SharedPreferences
        await AuthService.updateUserAfterKyc(updatedUser);

        final referralCodeInput = _referralController.text.trim();
        final referralProvider = Provider.of<ReferralProvider>(
          context,
          listen: false,
        );
        final transactionProvider = Provider.of<TransactionProvider>(
          context,
          listen: false,
        );
        referralProvider.initializeReferral(updatedUser);
        transactionProvider.initialize(updatedUser);

        if (referralCodeInput.isNotEmpty) {
          await referralProvider.redeemReferral(
            code: referralCodeInput,
            newUser: updatedUser,
            transactionProvider: transactionProvider,
          );
        }

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const WaitingForApprovalScreen(),
            ),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('KYC submission failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadDocument(String documentType) async {
    // Simulate document upload
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      switch (documentType) {
        case 'pan':
          _panUploaded = true;
          break;
        case 'aadhar':
          _aadharUploaded = true;
          break;
        case 'photo':
          // Placeholder: if selfie step is enabled later
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$documentType document uploaded successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Verification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // KYC Type Selection
                FormSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Choose KYC Type', style: AppTextStyles.heading3),
                      const SizedBox(height: AppSizes.paddingM),
                      Row(
                        children: [
                          Expanded(
                            child: _buildKycTypeCard(
                              'Digital KYC',
                              'Quick verification with documents',
                              Icons.phone_android,
                              'digital',
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingM),
                          Expanded(
                            child: _buildKycTypeCard(
                              'Video KYC',
                              'Face-to-face verification',
                              Icons.videocam,
                              'video',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Document Upload Section
                FormSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Upload Documents', style: AppTextStyles.heading3),
                      const SizedBox(height: AppSizes.paddingM),

                      // PAN Card
                      _buildDocumentUploadCard(
                        'PAN Card',
                        'Upload your PAN card',
                        Icons.credit_card,
                        _panUploaded,
                        () => _uploadDocument('pan'),
                      ),

                      const SizedBox(height: AppSizes.paddingM),

                      // Aadhar Card
                      _buildDocumentUploadCard(
                        'Aadhar Card',
                        'Upload your Aadhar card',
                        Icons.verified_user,
                        _aadharUploaded,
                        () => _uploadDocument('aadhar'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Document Details
                FormSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Document Details', style: AppTextStyles.heading3),
                      const SizedBox(height: AppSizes.paddingM),

                      CustomTextField(
                        controller: _panController,
                        labelText: 'PAN Number',
                        hintText: 'Enter PAN number',
                        prefixIcon: Icons.credit_card,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter PAN number';
                          }
                          if (value.length != 10) {
                            return 'PAN number must be 10 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.paddingM),

                      CustomTextField(
                        controller: _aadharController,
                        labelText: 'Aadhar Number',
                        hintText: 'Enter Aadhar number',
                        prefixIcon: Icons.verified_user,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Aadhar number';
                          }
                          if (value.length != 12) {
                            return 'Aadhar number must be 12 digits';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.paddingM),

                      CustomTextField(
                        controller: _referralController,
                        labelText: 'Referral Code (optional)',
                        hintText: 'Enter referral code',
                        prefixIcon: Icons.card_giftcard,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Submit Button
                CustomButton(
                  onPressed: _isLoading ? null : _submitKyc,
                  text: _isLoading ? 'Processing...' : 'Submit KYC',
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKycTypeCard(
    String title,
    String subtitle,
    IconData icon,
    String type,
  ) {
    final isSelected = _selectedKycType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedKycType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textLight,
              size: 32,
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              title,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXS),
            Text(
              subtitle,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentUploadCard(
    String title,
    String subtitle,
    IconData icon,
    bool isUploaded,
    VoidCallback onTap,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: isUploaded
            ? AppColors.success.withOpacity(0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: isUploaded ? AppColors.success : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isUploaded ? AppColors.success : AppColors.textLight,
            size: 24,
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
                    color: isUploaded
                        ? AppColors.success
                        : AppColors.textPrimary,
                  ),
                ),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          if (isUploaded)
            const Icon(Icons.check_circle, color: AppColors.success, size: 24)
          else
            IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.upload),
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }
}
