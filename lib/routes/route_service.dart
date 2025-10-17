import 'package:flutter/material.dart';
import 'package:janseva/modules/auth/screens/create_profile.dart';
import 'package:janseva/modules/auth/screens/login_screen.dart';
import 'package:janseva/modules/loan/screens/loan_application_screen.dart';
import 'package:janseva/modules/loan/screens/loan_categories_screen.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/routes.dart';
import 'package:janseva/screens/dashboard_screen.dart';
import 'package:janseva/screens/kyc_screen.dart';

import '../modules/loan/screens/loan_detail_screen.dart';
import '../screens/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return _getPageRoute(SplashScreen());
    case '/splash':
      return _getPageRoute(SplashScreen());
    case NamedRoutes.dashboard:
      return _getPageRoute(DashboardScreen());
    case NamedRoutes.login:
      return _getPageRoute(LoginScreen());
    case NamedRoutes.register:
      return _getPageRoute(CreateProfileScreen());
    case NamedRoutes.kycScreen:
      return _getPageRoute(KycScreen());
    case NamedRoutes.loanCategoryScreen:
      return _getPageRoute(LoanCategoriesScreen());
    case NamedRoutes.loanDetailScreen:
      return _getPageRoute(
        LoanDetailScreen(args: settings.arguments as LoanDetailScreenArguments),
      );
    case NamedRoutes.loanApplicationForm:
      return _getPageRoute(
        LoanApplicationScreen(args: settings.arguments as LoanDetailScreenArguments),
      );
    default:
      return _getPageRoute(SplashScreen());
  }
}

PageRoute _getPageRoute(Widget screen) {
  return MaterialPageRoute(builder: (context) => screen);
}
