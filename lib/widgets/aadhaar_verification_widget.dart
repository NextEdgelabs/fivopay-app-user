import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import '../utils/constants.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';

class AadhaarVerificationWidget extends StatefulWidget {
  const AadhaarVerificationWidget({super.key});

  @override
  State<AadhaarVerificationWidget> createState() => _AadhaarVerificationWidgetState();
}

class _AadhaarVerificationWidgetState extends State<AadhaarVerificationWidget> {
  final _aadhaarController = TextEditingController();
  final _otpController = TextEditingController();
  bool _showOTPField = false;
  String? _errorMessage;
  String? _maskedPhone;

  @override
  void initState() {
    super.initState();
    final loanProvider = context.read<LoanProvider>();
    if (loanProvider.relativeAadhaar != null) {
      _aadhaarController.text = loanProvider.relativeAadhaar!;
    }
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  bool _isValidAadhaar(String aadhaar) {
    final aadhaarRegex = RegExp(r'^[0-9]{12}$');
    return aadhaarRegex.hasMatch(aadhaar);
  }

  Future<void> _verifyAadhaar() async {
    final aadhaar = _aadhaarController.text.trim();
    
    if (!_isValidAadhaar(aadhaar)) {
      setState(() {
        _errorMessage = 'Please enter a valid 12-digit Aadhaar number';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    try {
      final loanProvider = context.read<LoanProvider>();
      await loanProvider.verifyAadhaar(aadhaar);
      
      setState(() {
        _showOTPField = true;
        _maskedPhone = '******1234'; // This would come from the API response
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent to $_maskedPhone'),
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
      await loanProvider.verifyAadhaarOTP(otp);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aadhaar verified successfully'),
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
        final isVerified = loanProvider.isAadhaarVerified;
        final isVerifying = loanProvider.isVerifyingAadhaar;
        final aadhaarDetails = loanProvider.aadhaarDetails;

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
                    Icons.fingerprint,
                    color: isVerified ? AppColors.success : AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Text(
                    'Aadhaar Verification',
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
                  controller: _aadhaarController,
                  labelText: 'Aadhaar Number',
                  hintText: 'Enter 12-digit Aadhaar number',
                  prefixIcon: Icons.fingerprint,
                  keyboardType: TextInputType.number,
                  enabled: !_showOTPField && !isVerifying,
                  maxLength: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Aadhaar number';
                    }
                    if (!_isValidAadhaar(value)) {
                      return 'Invalid Aadhaar format';
                    }
                    return null;
                  },
                ),
                
                if (_showOTPField) ...[
                  const SizedBox(height: AppSizes.paddingM),
                  if (_maskedPhone != null)
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                            size: 20,
                          ),
                          const SizedBox(width: AppSizes.paddingM),
                          Text(
                            'OTP sent to $_maskedPhone',
                            style: AppTextStyles.body2,
                          ),
                        ],
                      ),
                    ),
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
                    onPressed: isVerifying ? null : _verifyAadhaar,
                    text: isVerifying ? 'Verifying...' : 'Verify Aadhaar',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                  'Aadhaar: ${_maskAadhaar(loanProvider.relativeAadhaar ?? '')}',
                                  style: AppTextStyles.body1.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.paddingXS),
                                Text(
                                  'Verified on ${_formatDate(loanProvider.aadhaarVerificationDate)}',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (aadhaarDetails != null) ...[
                        const SizedBox(height: AppSizes.paddingM),
                        const Divider(),
                        const SizedBox(height: AppSizes.paddingM),
                        _buildDetailRow('Name', aadhaarDetails['name'] ?? ''),
                        const SizedBox(height: AppSizes.paddingS),
                        _buildDetailRow('DOB', aadhaarDetails['dob'] ?? ''),
                        const SizedBox(height: AppSizes.paddingS),
                        _buildDetailRow('Address', aadhaarDetails['address'] ?? ''),
                      ],
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.body2,
          ),
        ),
      ],
    );
  }

  String _maskAadhaar(String aadhaar) {
    if (aadhaar.length != 12) return aadhaar;
    return 'XXXX XXXX ${aadhaar.substring(8)}';
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