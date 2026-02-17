import 'dart:async';
import 'package:flutter/material.dart';
import 'package:janseva/modules/wallet_module/provider/wallet_provider.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:janseva/screens/registration_screen.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../provider/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/referral_provider.dart';
import '../../../providers/transaction_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_button.dart';
import '../../../components/components.dart';
import '../../../screens/dashboard_screen.dart';
import '../../../screens/kyc_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResendLoading = false;
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    _resendTimer = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    setState(() => _isResendLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.sendOtp(widget.phoneNumber);

    setState(() => _isResendLoading = false);

    if (success && mounted) {
      setState(() => _resendTimer = 30);
      _startResendTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Failed to send OTP'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter 6-digit OTP'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    var res = await authProvider.verifyOtp(
      widget.phoneNumber,
      _otpController.text,
    );

    setState(() => _isLoading = false);
    if (res['success'] != true) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Failed to verify OTP'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (!mounted) return;

    if (authProvider.currentUser != null) {
      if (authProvider.currentUser!.isNew) {
        pushReplacement(NamedRoutes.register);
      } else if (authProvider.currentUser!.kycStatus?.toLowerCase() ==
          'pending') {
        push(NamedRoutes.kycScreen);
      } else {
        pushAndRemoveUntil(NamedRoutes.dashboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSizes.paddingXL),

                  // Error Message
                  if (provider.error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      margin: const EdgeInsets.only(bottom: AppSizes.paddingL),
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
                            size: AppSizes.iconSizeS,
                          ),
                          const SizedBox(width: AppSizes.paddingS),
                          Expanded(
                            child: Text(
                              provider.error!,
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Header
                  FormSectionCard(
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            // Sky blue gradient
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryDark,
                                AppColors.primaryLight,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusL,
                            ),
                            // Minimal shadow for subtle depth
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        Text(
                          AppStrings.otpTitle,
                          style: AppTextStyles.heading2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSizes.paddingS),
                        Text(
                          AppStrings.otpSubtitle,
                          style: AppTextStyles.body2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        Text(
                          widget.phoneNumber,
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingXL),

                  // OTP Input
                  FormSectionCard(
                    child: Column(
                      children: [
                        PinCodeTextField(
                          appContext: context,
                          length: 6,
                          controller: _otpController,
                          onChanged: (value) {},
                          onCompleted: (value) => _verifyOtp(),
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                            fieldHeight: 56,
                            fieldWidth: 45,
                            activeFillColor: AppColors.primary,
                            activeColor: AppColors.primary,
                            selectedColor: AppColors.primary,
                            inactiveColor: AppColors.border,
                            inactiveFillColor: AppColors.surface,
                            selectedFillColor: AppColors.primary.withOpacity(
                              0.1,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          enableActiveFill: true,
                          animationType: AnimationType.fade,
                        ),

                        const SizedBox(height: AppSizes.paddingL),

                        // Verify Button
                        CustomButton(
                          onPressed: (_isLoading || provider.isLoading)
                              ? null
                              : _verifyOtp,
                          text: (_isLoading || provider.isLoading)
                              ? AppStrings.loading
                              : AppStrings.verifyOtp,
                          isLoading: _isLoading || provider.isLoading,
                        ),

                        const SizedBox(height: AppSizes.paddingM),

                        // Resend OTP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: AppTextStyles.body2,
                            ),
                            if (_resendTimer > 0)
                              Text(
                                'Resend in $_resendTimer seconds',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.textLight,
                                ),
                              )
                            else
                              TextButton(
                                onPressed: _isResendLoading ? null : _resendOtp,
                                child: _isResendLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.primary,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        AppStrings.resendOtp,
                                        style: AppTextStyles.body1.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingL),

                  // Test Info
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.info,
                              size: AppSizes.iconSizeS,
                            ),
                            const SizedBox(width: AppSizes.paddingS),
                            Text(
                              'Test Mode',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.info,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.paddingS),
                        Text(
                          'Use OTP: 123456',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.info,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
