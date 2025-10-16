import 'package:flutter/material.dart';
import 'package:janseva/providers/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/referral_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/loan_provider.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext get bContext => navigatorKey.currentContext!;
void main() {
  runApp(const JanSevaApp());
}

class JanSevaApp extends StatelessWidget {
  const JanSevaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ReferralProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

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
          userProvider.updateUserFromAuth(user);
          referralProvider.initializeReferral(user);
          transactionProvider.initializeWallet(user);
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
