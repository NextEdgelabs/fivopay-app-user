import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modules/loan/providers/loan_provider.dart';

import '../providers/user_provider.dart';
import '../services/kyc_service.dart';
import '../screens/pan_confirmation_screen.dart';
import '../utils/constants.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';

class PANVerificationWidget extends StatefulWidget {
  const PANVerificationWidget({super.key});

  @override
  State<PANVerificationWidget> createState() => _PANVerificationWidgetState();
}

class _PANVerificationWidgetState extends State<PANVerificationWidget> {
  final _panController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _kycService = KycService();
  bool _isVerifying = false;

  String? _errorMessage;
  String? userId;
  PanVerificationResponse? _verificationResponse;

  @override
  void initState() {
    super.initState();
    // final loanProvider = context.read<LoanProvider>();
    final user = context.read<UserProvider>().currentUser;
    if (user != null) {
       userId = user.id;
      _panController.text = user.panNumber ?? '';
      _nameController.text = user.name ?? '';
    }
  }

  @override
  void dispose() {
    _panController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  bool _isValidPAN(String pan) {
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return panRegex.hasMatch(pan);
  }

  Future<void> _verifyPAN() async {
    final pan = _panController.text.trim().toUpperCase();
    final name = _nameController.text.trim();
    final dob = _dobController.text.trim();

    if (!_isValidPAN(pan)) {
      setState(() {
        _errorMessage = 'Please enter a valid PAN number';
      });
      return;
    }

    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter name as per PAN';
      });
      return;
    }

    if (dob.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter date of birth';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isVerifying = true;
    });

    try {
      // Call real Sandbox API for PAN verification
      final response = await KycService.verifyPan(
        panNumber: pan,
        name: name,
        dateOfBirth: dob,
        userId: userId!,
      );

      setState(() {
        _verificationResponse = response;
        _isVerifying = false;
      });

      if (mounted) {
        // Navigate to confirmation screen
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => PanConfirmationScreen(
              verificationResponse: response,
              enteredName: name,
              onConfirm: () {
                Navigator.pop(context, true);
              },
              onRetry: () {
                Navigator.pop(context, false);
              },
            ),
          ),
        );

        if (result == true && response.isSuccess) {
          // Update loan provider with verified PAN
          final loanProvider = context.read<LoanProvider>();
          await loanProvider.setPANVerified(pan, response);

          // Update user profile with PAN details
          final userProvider = context.read<UserProvider>();
          userProvider.updateFromPanVerification(
            panNumber: pan,
            name: _nameController.text.trim(),
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PAN verified successfully! ✓'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _errorMessage = e.toString().replaceAll('KycApiException: ', '');
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${_errorMessage}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        final isVerified = loanProvider.isPanVerified;
        // final isVerifying = loanProvider.isVerifyingPAN;

        return Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(
              AppSizes.radiusL,
            ), // Reduced for minimalism
            border: Border.all(
              color: isVerified ? AppColors.success : AppColors.border,
              width: isVerified ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    color: isVerified ? AppColors.success : AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Text('PAN Verification', style: AppTextStyles.heading3),
                  const Spacer(),
                  if (isVerified)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM,
                        vertical: AppSizes.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusL),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 16,
                          ),
                          const SizedBox(width: AppSizes.paddingXS),
                          Text(
                            'Verified',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingL),

              if (!isVerified) ...[
                CustomTextField(
                  controller: _panController,
                  labelText: 'PAN Number',
                  hintText: 'e.g., ABCDE1234F',
                  prefixIcon: Icons.credit_card,
                  textCapitalization: TextCapitalization.characters,
                  enabled: !_isVerifying,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter PAN number';
                    }
                    if (!_isValidPAN(value.toUpperCase())) {
                      return 'Invalid PAN format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.paddingM),

                CustomTextField(
                  controller: _nameController,
                  labelText: 'Name as per PAN',
                  hintText: 'Enter full name',
                  prefixIcon: Icons.person_outline,
                  textCapitalization: TextCapitalization.words,
                  enabled: !_isVerifying,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name as per PAN';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.paddingM),

                CustomTextField(
                  controller: _dobController,
                  labelText: 'Date of Birth',
                  hintText: 'DD/MM/YYYY',
                  prefixIcon: Icons.calendar_today,
                  enabled: !_isVerifying,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter date of birth';
                    }
                    return null;
                  },
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(1990),
                      firstDate: DateTime(1940),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      _dobController.text =
                          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                    }
                  },
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: AppSizes.paddingS),
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: AppSizes.paddingS),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: AppSizes.paddingL),

                CustomButton(
                  onPressed: _isVerifying ? null : _verifyPAN,
                  text: _isVerifying
                      ? 'Verifying with Sandbox API...'
                      : 'Verify PAN',
                  isLoading: _isVerifying,
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PAN: ${_maskPAN(loanProvider.relativePAN ?? '')}',
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSizes.paddingXS),
                            Text(
                              'Verified on ${_formatDate(loanProvider.panVerificationDate)}',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _maskPAN(String pan) {
    if (pan.length != 10) return pan;
    return '${pan.substring(0, 2)}****${pan.substring(8)}';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
