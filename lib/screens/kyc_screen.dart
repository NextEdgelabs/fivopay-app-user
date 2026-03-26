import 'package:flutter/material.dart';
import 'package:janseva/modules/wallet_module/provider/wallet_provider.dart';
import 'package:janseva/services/storage_service.dart';
import 'package:provider/provider.dart';
import '../modules/auth/provider/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/referral_provider.dart';
import '../services/kyc_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../components/components.dart';
import 'pan_confirmation_screen.dart';
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
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _aadharController = TextEditingController();
  final _otpController = TextEditingController();
  final _referralController = TextEditingController();
  final _kycService = KycService();
  bool _isLoading = false;
  bool _isPanVerifying = false;
  bool _isPanVerified = false;
  bool _isAadhaarRequestingOtp = false;
  bool _isAadhaarVerifying = false;
  bool _isAadhaarVerified = false;
  bool _showAadhaarOtpField = false;
  String? _aadhaarReferenceId;
  final String _selectedKycType = 'digital'; // Only digital KYC available
  PanVerificationResponse? _panVerificationResponse;
  String? userId;
  // Reserved for future selfie capture step
  // bool _photoUploaded = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill name from user profile
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.currentUser?.name != null) {
      _nameController.text = userProvider.currentUser!.name!;
      userId = userProvider.currentUser!.id;
    }

    // Listen to Aadhaar controller changes
    _aadharController.addListener(_onAadhaarChanged);
  }

  void _onAadhaarChanged() {
    final aadhaar = _aadharController.text.trim();
    setState(() {
      // Show send OTP button when 12 digits are entered and not already verified
      if (aadhaar.length == 12 && !_isAadhaarVerified) {
        // Valid 12-digit Aadhaar entered
      } else {
        // Invalid or incomplete Aadhaar
        _showAadhaarOtpField = false;
        _otpController.clear();
        _aadhaarReferenceId = null;
      }
    });
  }

  bool _isValidAadhaar(String aadhaar) {
    final aadhaarRegex = RegExp(r'^[0-9]{12}$');
    return aadhaarRegex.hasMatch(aadhaar);
  }

  @override
  void dispose() {
    _panController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _aadharController.dispose();
    _otpController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  Future<void> _verifyPAN() async {
    final pan = _panController.text.trim().toUpperCase();
    final name = _nameController.text.trim();
    final dob = _dobController.text.trim();

    if (pan.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-character PAN number'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter name as per PAN'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (dob.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter date of birth'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isPanVerifying = true);

    try {
      final response = await KycService.verifyPan(
        panNumber: pan,
        name: name,
        dateOfBirth: dob,
        userId: userId!,
      );

      setState(() {
        _panVerificationResponse = response;
        _isPanVerifying = false;
      });
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
      //response.isSuccess && response.data.status == 'valid'
      if (result == true) {
        // Save PAN data locally and to server
        await SfService.saveJson(SfService.panKey, response.data.toJson());

        // Call save PAN API
        try {
          await context.read<AuthProvider>().savePand(response.data);

          setState(() {
            _isPanVerified = true;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'PAN Verified Successfully!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Name Match: ${response.data.nameMatch ? "✓" : "✗"} | DOB Match: ${response.data.dobMatch ? "✓" : "✗"}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        } catch (saveError) {
          // Even if save API fails, we still consider PAN verified locally
          setState(() {
            _isPanVerified = true;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'PAN verified but failed to save to server. You can continue with KYC.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        }
      } else {
        // PAN verification failed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'PAN Verification Failed',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          response.data.statusMessage,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isPanVerifying = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Verification failed: ${e.toString().replaceAll('KycApiException: ', '')}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _requestAadhaarOtp() async {
    final aadhaar = _aadharController.text.trim();

    if (aadhaar.length != 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 12-digit Aadhaar number'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isAadhaarRequestingOtp = true);

    try {
      final response = await KycService.requestAadhaarOtp(
        userId: context.read<UserProvider>().currentUser!.id,

        aadhaarNumber: aadhaar,
        reason: "Loan Kyc Verification",
      );

      setState(() {
        _aadhaarReferenceId = response.transactionId;
        _showAadhaarOtpField = true;
        _isAadhaarRequestingOtp = false;
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
      setState(() => _isAadhaarRequestingOtp = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send OTP: ${e.toString().replaceAll('KycApiException: ', '')}',
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _verifyAadhaarOtp() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit OTP'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_aadhaarReferenceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reference ID not found. Please request OTP again.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isAadhaarVerifying = true);

    try {
      final response = await KycService.verifyAadhaarOtp(
        userId: context.read<UserProvider>().currentUser!.id,
        transactionId: _aadhaarReferenceId!,
        otp: otp,
        aadhaarNumber: _aadharController.text.trim(),
        updateData: true,
      );

      if (response.isSuccess && response.isValid) {
        setState(() {
          _isAadhaarVerified = true;
          _isAadhaarVerifying = false;
          _showAadhaarOtpField = false;
        });

        // Update user profile with Aadhaar details
        if (response.data != null) {
          final userProvider = context.read<UserProvider>();
          userProvider.updateFromAadhaarVerification(
            aadhaarData: response.data!,
            name: response.data!.name ?? _nameController.text.trim(),
            aadhaarNumber: _aadharController.text.trim(),
            dateOfBirth: response.data!.dateOfBirth,
            gender: response.data!.gender,
            
            // address: response.data!.fullAddress,
          );

          // Update form fields with verified data
          if (response.data!.name != null && _nameController.text.isEmpty) {
            setState(() {
              _nameController.text = response.data!.name!;
            });
          }

          if (response.data!.dateOfBirth != null &&
              _dobController.text.isEmpty) {
            setState(() {
              _dobController.text = response.data!.dateOfBirth!;
            });
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aadhaar verified successfully! ✓'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        setState(() => _isAadhaarVerifying = false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aadhaar verification failed. Please try again.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isAadhaarVerifying = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Verification failed: ${e.toString().replaceAll('KycApiException: ', '')}',
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _submitKyc() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if both PAN and Aadhaar are verified
    if (!_isPanVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify your PAN first'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_isAadhaarVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify your Aadhaar first'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Update user with KYC information
      final updatedUser = userProvider.currentUser?.copyWith(
        // kycStatus: 'completed',
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
        final transactionProvider = Provider.of<WalletProvider>(
          context,
          listen: false,
        );
        referralProvider.initializeReferral(updatedUser);
        // transactionProvider.initializeWallet(updatedUser);

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
                // Digital KYC Info Banner
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primaryLight.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSizes.paddingM),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                        ),
                        child: Icon(
                          Icons.verified_user,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: AppSizes.paddingL),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Digital KYC Verification',
                              style: AppTextStyles.heading3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppSizes.paddingXS),
                            Text(
                              'Complete your KYC with quick document verification',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
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
                      Row(
                        children: [
                          Text(
                            'Document Details',
                            style: AppTextStyles.heading3,
                          ),
                          const Spacer(),
                          if (_isPanVerified)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.paddingM,
                                vertical: AppSizes.paddingXS,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusL,
                                ),
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
                                    'PAN Verified',
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
                      const SizedBox(height: AppSizes.paddingM),

                      CustomTextField(
                        controller: _panController,
                        labelText: 'PAN Number',
                        hintText: 'e.g., ABCDE1234F',
                        prefixIcon: Icons.credit_card,
                        textCapitalization: TextCapitalization.characters,
                        enabled: !_isPanVerified,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter PAN number';
                          }
                          if (value.length != 10) {
                            return 'PAN number must be 10 characters';
                          }
                          if (!_isPanVerified) {
                            return 'Please verify PAN before submitting';
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
                        enabled: !_isPanVerified,
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
                        enabled: !_isPanVerified,
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

                      const SizedBox(height: AppSizes.paddingM),

                      if (!_isPanVerified)
                        CustomButton(
                          onPressed: _isPanVerifying ? null : _verifyPAN,
                          text: _isPanVerifying
                              ? 'Verifying with API...'
                              : 'Verify PAN',
                          isLoading: _isPanVerifying,
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(AppSizes.paddingM),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                            border: Border.all(
                              color: AppColors.success.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.verified,
                                color: AppColors.success,
                                size: 20,
                              ),
                              const SizedBox(width: AppSizes.paddingS),
                              Expanded(
                                child: Text(
                                  'PAN verified successfully',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: AppSizes.paddingM),

                      CustomTextField(
                        controller: _aadharController,
                        labelText: 'Aadhar Number',
                        hintText: 'Enter 12-digit Aadhar number',
                        prefixIcon: Icons.verified_user,
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        enabled: !_isAadhaarVerified,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Aadhar number';
                          }
                          if (!_isValidAadhaar(value)) {
                            return 'Invalid Aadhar format';
                          }
                          if (!_isAadhaarVerified) {
                            return 'Please verify Aadhar before submitting';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.paddingM),

                      // Show Send OTP button when valid Aadhaar is entered and not verified
                      if (_aadharController.text.trim().length == 12 &&
                          !_isAadhaarVerified &&
                          !_showAadhaarOtpField)
                        CustomButton(
                          onPressed: _isAadhaarRequestingOtp
                              ? null
                              : _requestAadhaarOtp,
                          text: _isAadhaarRequestingOtp
                              ? 'Sending OTP...'
                              : 'Send OTP',
                          isLoading: _isAadhaarRequestingOtp,
                        ),

                      // Show OTP field when OTP has been requested
                      if (_showAadhaarOtpField) ...[
                        CustomTextField(
                          controller: _otpController,
                          labelText: 'Enter OTP',
                          hintText: '6-digit OTP',
                          prefixIcon: Icons.lock,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          enabled: !_isAadhaarVerifying,
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

                        const SizedBox(height: AppSizes.paddingM),

                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                onPressed: _isAadhaarVerifying
                                    ? null
                                    : _verifyAadhaarOtp,
                                text: _isAadhaarVerifying
                                    ? 'Verifying...'
                                    : 'Verify OTP',
                                isLoading: _isAadhaarVerifying,
                              ),
                            ),
                            const SizedBox(width: AppSizes.paddingM),
                            TextButton(
                              onPressed: _isAadhaarVerifying
                                  ? null
                                  : () {
                                      setState(() {
                                        _showAadhaarOtpField = false;
                                        _otpController.clear();
                                        _aadhaarReferenceId = null;
                                      });
                                    },
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      ],

                      // Show verification success message when verified
                      if (_isAadhaarVerified)
                        Container(
                          padding: const EdgeInsets.all(AppSizes.paddingM),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                            border: Border.all(
                              color: AppColors.success.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.verified,
                                color: AppColors.success,
                                size: 20,
                              ),
                              const SizedBox(width: AppSizes.paddingS),
                              Expanded(
                                child: Text(
                                  'Aadhaar verified successfully',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
}
