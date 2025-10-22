import 'package:flutter/material.dart';
import 'package:janseva/modules/auth/screens/login_screen.dart';
import 'package:janseva/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/auth/provider/auth_provider.dart';
import '../providers/referral_provider.dart';
import '../providers/user_provider.dart';
import '../modules/wallet_module/provider/wallet_provider.dart';
import 'dashboard_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('onboarding_seen') ?? false;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final referralProvider = Provider.of<ReferralProvider>(
      context,
      listen: false,
    );
    final transactionProvider = Provider.of<WalletProvider>(
      context,
      listen: false,
    );

    // Use microtask to avoid setState during build
    await Future.microtask(() async {
      await authProvider.initialize();
    });

    if (mounted) {
      await Future.delayed(const Duration(seconds: 2));

      if (!hasSeenOnboarding) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
        return;
      }

      if (authProvider.isLoggedIn) {
        // Initialize other providers with user data
        final user = authProvider.currentUser;
        if (user != null) {
          userProvider.updateUser(user);
          referralProvider.initializeReferral(user);
          // transactionProvider.initializeWallet(user);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXL),

            // App Name
            Text(
              AppStrings.appName,
              style: AppTextStyles.heading1.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(AppStrings.appTagline, style: AppTextStyles.body2),
            const SizedBox(height: AppSizes.paddingXL * 2),

            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
