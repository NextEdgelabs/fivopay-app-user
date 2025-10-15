import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import '../providers/user_provider.dart';
import '../services/kyc_service.dart';
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
  final _kycService = KycService();
  
  bool _showOTPField = false;
  bool _isRequestingOtp = false;
  bool _isVerifying = false;
  String? _errorMessage;
  String? _referenceId;

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

  Future<void> _requestOtp() async {
    final aadhaar = _aadhaarController.text.trim();
    
    if (!_isValidAadhaar(aadhaar)) {
      setState(() {
        _errorMessage = 'Please enter a valid 12-digit Aadhaar number';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isRequestingOtp = true;
    });

    try {
      final response = await _kycService.requestAadhaarOtp(
        aadhaarNumber: aadhaar,
      );

      setState(() {
        _referenceId = response.referenceId;
        _showOTPField = true;
        _isRequestingOtp = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent to registered mobile number ✓'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isRequestingOtp = false;
        _errorMessage = e.toString().replaceAll('KycApiException: ', '');
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: $_errorMessage'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
          ),
        );
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

    if (_referenceId == null) {
      setState(() {
        _errorMessage = 'Reference ID not found. Please request OTP again.';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isVerifying = true;
    });

    try {
      final response = await _kycService.verifyAadhaarOtp(
        referenceId: _referenceId!,
        otp: otp,
      );

      setState(() {
        _isVerifying = false;
      });

      if (response.isSuccess && response.isValid) {
        // Update loan provider with verified Aadhaar
        final loanProvider = context.read<LoanProvider>();
        await loanProvider.setAadhaarVerified(
          _aadhaarController.text.trim(),
          response,
        );
        
        // Update user profile with Aadhaar details
        if (response.data != null) {
          final userProvider = context.read<UserProvider>();
          userProvider.updateFromAadhaarVerification(
            name: response.data!.name ?? '',
            aadhaarNumber: _aadhaarController.text.trim(),
            dateOfBirth: response.data!.dateOfBirth,
            gender: response.data!.gender,
            address: response.data!.address,
          );
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aadhaar verified successfully! ✓'),
              backgroundColor: AppColors.success,
            ),
          );
          
          setState(() {
            _showOTPField = false;
            _otpController.clear();
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Aadhaar verification failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _errorMessage = e.toString().replaceAll('KycApiException: ', '');
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: $_errorMessage'),
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
        final isVerified = loanProvider.isAadhaarVerified;
        final aadhaarDetails = loanProvider.aadhaarDetails;

        return Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusL), // Reduced for minimalism
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
                  enabled: !_showOTPField && !_isRequestingOtp,
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
                  CustomTextField(
                    controller: _otpController,
                    labelText: 'Enter OTP',
                    hintText: '6-digit OTP',
                    prefixIcon: Icons.lock,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    enabled: !_isVerifying,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP';
                      }
                      if (value.length != 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                  ),
                ],
                
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
                
                if (!_showOTPField)
                  CustomButton(
                    onPressed: _isRequestingOtp ? null : _requestOtp,
                    text: _isRequestingOtp ? 'Sending OTP...' : 'Send OTP',
                    isLoading: _isRequestingOtp,
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: _isVerifying ? null : _verifyOTP,
                          text: _isVerifying ? 'Verifying...' : 'Verify OTP',
                          isLoading: _isVerifying,
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      TextButton(
                        onPressed: _isVerifying
                            ? null
                            : () {
                                setState(() {
                                  _showOTPField = false;
                                  _otpController.clear();
                                  _errorMessage = null;
                                  _referenceId = null;
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