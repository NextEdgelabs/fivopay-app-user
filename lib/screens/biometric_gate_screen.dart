import 'package:flutter/material.dart';
import 'package:janseva/services/biometric_service.dart';
import 'package:janseva/utils/constants.dart';
import 'package:janseva/widgets/custom_button.dart';

class BiometricGateScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;
  final VoidCallback? onSkip;

  const BiometricGateScreen({
    super.key,
    required this.onAuthenticated,
    this.onSkip,
  });

  @override
  State<BiometricGateScreen> createState() => _BiometricGateScreenState();
}

class _BiometricGateScreenState extends State<BiometricGateScreen> {
  final BiometricService _biometricService = BiometricService();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    // Auto-trigger biometric authentication on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticateWithBiometric();
    });
  }

  Future<void> _authenticateWithBiometric() async {
    if (_isAuthenticating) return;

    setState(() => _isAuthenticating = true);

    try {
      final authenticated = await _biometricService.authenticate(
        reason: 'Authenticate to access your account',
      );

      if (authenticated) {
        widget.onAuthenticated();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: AppSizes.paddingXL),

              // App Name
              Text(
                AppStrings.appName,
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSizes.paddingXL * 2),

              // Biometric Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.fingerprint,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSizes.paddingL),

              // Instruction Text
              Text(
                'Use Biometric to Login',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingS),
              Text(
                'Touch the fingerprint sensor or use face recognition',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingXL),

              // Retry Button
              if (!_isAuthenticating)
                CustomButton(
                  onPressed: _authenticateWithBiometric,
                  text: 'Try Again',
                  icon: Icons.fingerprint,
                ),

              if (_isAuthenticating) const CircularProgressIndicator(),

              const SizedBox(height: AppSizes.paddingL),

              // Alternative Login Option
              if (widget.onSkip != null)
                TextButton(
                  onPressed: widget.onSkip,
                  child: Text(
                    'Use password instead',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
