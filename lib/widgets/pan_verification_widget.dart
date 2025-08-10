import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
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
  final _otpController = TextEditingController();
  bool _showOTPField = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final loanProvider = context.read<LoanProvider>();
    if (loanProvider.relativePAN != null) {
      _panController.text = loanProvider.relativePAN!;
    }
  }

  @override
  void dispose() {
    _panController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  bool _isValidPAN(String pan) {
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return panRegex.hasMatch(pan);
  }

  Future<void> _verifyPAN() async {
    final pan = _panController.text.trim().toUpperCase();
    
    if (!_isValidPAN(pan)) {
      setState(() {
        _errorMessage = 'Please enter a valid PAN number';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    try {
      final loanProvider = context.read<LoanProvider>();
      await loanProvider.verifyPAN(pan);
      
      setState(() {
        _showOTPField = true;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();
    
    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a valid 6-digit OTP';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    try {
      final loanProvider = context.read<LoanProvider>();
      await loanProvider.verifyPANOTP(otp);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PAN verified successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        
        setState(() {
          _showOTPField = false;
          _otpController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        final isVerified = loanProvider.isPANVerified;
        final isVerifying = loanProvider.isVerifyingPAN;

        return Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
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
                  Text(
                    'PAN Verification',
                    style: AppTextStyles.heading3,
                  ),
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
              
              if (!isVerified || _showOTPField) ...[
                CustomTextField(
                  controller: _panController,
                  labelText: 'PAN Number',
                  hintText: 'Enter PAN number',
                  prefixIcon: Icons.credit_card,
                  textCapitalization: TextCapitalization.characters,
                  enabled: !_showOTPField && !isVerifying,
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
                
                if (_showOTPField) ...[
                  const SizedBox(height: AppSizes.paddingM),
                  CustomTextField(
                    controller: _otpController,
                    labelText: 'Enter OTP',
                    hintText: '6-digit OTP',
                    prefixIcon: Icons.lock,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    enabled: !isVerifying,
                  ),
                ],
                
                if (_errorMessage != null) ...[
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    _errorMessage!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
                
                const SizedBox(height: AppSizes.paddingM),
                
                if (!_showOTPField)
                  CustomButton(
                    onPressed: isVerifying ? null : _verifyPAN,
                    text: isVerifying ? 'Verifying...' : 'Verify PAN',
                    isLoading: isVerifying,
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: isVerifying ? null : _verifyOTP,
                          text: isVerifying ? 'Verifying...' : 'Verify OTP',
                          isLoading: isVerifying,
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      TextButton(
                        onPressed: isVerifying
                            ? null
                            : () {
                                setState(() {
                                  _showOTPField = false;
                                  _otpController.clear();
                                  _errorMessage = null;
                                });
                              },
                        child: const Text('Cancel'),
                      ),
                    ],
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