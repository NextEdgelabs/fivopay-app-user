import 'package:flutter/material.dart';
import 'package:janseva/services/biometric_service.dart';
import 'package:janseva/utils/constants.dart';
import 'package:janseva/widgets/custom_button.dart';

class BiometricSetupScreen extends StatefulWidget {
  final VoidCallback onSetupComplete;

  const BiometricSetupScreen({super.key, required this.onSetupComplete});

  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  final BiometricService _biometricService = BiometricService();
  bool _isLoading = false;

  Future<void> _enableBiometric() async {
    setState(() => _isLoading = true);

    try {
      // Authenticate to test if biometric works
      final authenticated = await _biometricService.authenticate(
        reason: 'Verify your identity to enable biometric login',
      );

      if (authenticated) {
        await _biometricService.enableBiometric();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication enabled successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onSetupComplete();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication failed'),
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
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _skipSetup() async {
    await _biometricService.skipBiometricSetup();
    widget.onSetupComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Setup'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Biometric Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.fingerprint,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSizes.paddingXL),

              // Title
              Text(
                'Secure Your Account',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingM),

              // Description
              Text(
                'Enable biometric authentication for quick and secure access to your account',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.paddingL),

              // Benefits List
              _BenefitItem(
                icon: Icons.speed,
                title: 'Quick Access',
                description: 'Login instantly with your fingerprint or face',
              ),
              const SizedBox(height: AppSizes.paddingM),
              _BenefitItem(
                icon: Icons.security,
                title: 'Enhanced Security',
                description: 'Your biometric data stays on your device',
              ),
              const SizedBox(height: AppSizes.paddingM),
              _BenefitItem(
                icon: Icons.lock,
                title: 'Privacy Protected',
                description: 'No passwords to remember or type',
              ),

              const Spacer(),

              // Enable Button
              CustomButton(
                onPressed: _isLoading ? null : _enableBiometric,
                text: 'Enable Biometric Login',
                isLoading: _isLoading,
              ),

              const SizedBox(height: AppSizes.paddingM),

              // Skip Button
              TextButton(
                onPressed: _isLoading ? null : _skipSetup,
                child: Text(
                  'Skip for now',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.paddingL),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
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
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
