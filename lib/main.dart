import 'package:flutter/material.dart';
import 'package:janseva/modules/loan/providers/loan_provider_v2.dart';
import 'package:janseva/modules/wallet_module/provider/wallet_provider.dart';
import 'package:janseva/providers/share_provider.dart';
import 'package:janseva/routes/route_service.dart';
import 'package:provider/provider.dart';
import 'modules/auth/provider/auth_provider.dart';
import 'modules/loan/providers/loan_provider.dart';
import 'providers/user_provider.dart';
import 'providers/referral_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';

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
        ChangeNotifierProvider(create: (_) => LoanProviderV2()),
        ChangeNotifierProvider(create: (_) => ShareProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        // routes: {'/': (context) => const SplashScreen()},
        onGenerateRoute: generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
