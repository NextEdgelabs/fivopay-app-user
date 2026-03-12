import 'package:flutter/material.dart';
import 'package:janseva/modules/auth/screens/create_profile.dart';
import 'package:janseva/modules/auth/screens/login_screen.dart';
import 'package:janseva/modules/loan/screens/esign/esign_flow.dart';
import 'package:janseva/modules/loan/screens/loan_application_screen.dart';
import 'package:janseva/modules/loan/screens/loan_categories_screen.dart';
import 'package:janseva/modules/loan/screens/loan_product_screen.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/routes.dart';
import 'package:janseva/screens/dashboard_screen.dart';
import 'package:janseva/screens/kyc_screen.dart';
import 'package:janseva/screens/transactions_screen.dart';

import '../modules/fd_rd/screens/select_depositType_home_screen.dart';
import '../modules/fd_rd/screens/online_deposit_screen.dart';
import '../modules/fd_rd/screens/branch_deposit_screen.dart';
import '../modules/fd_rd/screens/collect_from_home_screen.dart';
import '../modules/loan/screens/loan_application_screen_v2.dart';
import '../modules/loan/screens/loan_detail_screen.dart';
import '../modules/wallet_module/screens/deposit_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/deposit_detail_screen.dart';
import '../screens/loan_application_detail_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/terms_of_service_screen.dart';
import '../screens/support_screen.dart';

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
    case NamedRoutes.loanProductScreen:
      return _getPageRoute(LoanProductScreen());
    case NamedRoutes.loanApplicationForm:
      return _getPageRoute(
        LoanApplicationScreen(
          args: settings.arguments as LoanDetailScreenArguments,
        ),
      );
    case NamedRoutes.signAgreement:
      return _getPageRoute(
        EsignLoanScreen(args: settings.arguments as EsignLoanArguments),
      );
    case NamedRoutes.depositScreen:
      return _getPageRoute(DepositScreen());
    case NamedRoutes.loanApplicationScreenv2:
      return _getPageRoute(
        LoanApplicationScreenv2(
          args: settings.arguments as LoanApplicationScreenV2Arguments,
        ),
      );
    case NamedRoutes.transactionHistory:
      return _getPageRoute(
        TransactionsScreen(
          // args: settings.arguments as LoanApplicationScreenV2Arguments,
        ),
      );
    // case NamedRoutes.fixedDepositScreen:
    //   return _getPageRoute(FixedDepositScreen());

    case NamedRoutes.selectDepositTypeHomeScreen:
      return _getPageRoute(SelectDepositTypeHomeScreen());
    case NamedRoutes.onlineDepositScreen:
      final args = settings.arguments as Map<String, dynamic>;
      return _getPageRoute(
        OnlineDepositScreen(
          category: args['category'],
          product: args['product'],
          amount: args['amount'],
          fdName: args['fdName'],
        ),
      );
    // case NamedRoutes.branchDepositScreen:
    //   final args = settings.arguments as Map<String, dynamic>;
    //   return _getPageRoute(
    //     BranchDepositScreen(
    //       category: args['category'],
    //       product: args['product'],
    //       amount: args['amount'],
    //       fdName: args['fdName'],
    //     ),
    //   );
    case NamedRoutes.collectFromHomeScreen:
      final args = settings.arguments as Map<String, dynamic>;
      return _getPageRoute(
        CollectFromHomeScreen(
          category: args['category'],
          product: args['product'],
          amount: args['amount'],
          fdName: args['fdName'],
        ),
      );
    case NamedRoutes.depositDetailScreen:
      final args = settings.arguments as DepositDetailScreenArguments;
      return _getPageRoute(DepositDetailScreen(deposit: args.deposit));
    case NamedRoutes.loanApplicationDetailScreen:
      final args = settings.arguments as LoanApplicationDetailScreenArguments;
      return _getPageRoute(LoanApplicationDetailScreen(loan: args.loan));
    case NamedRoutes.privacyPolicy:
      return _getPageRoute(PrivacyPolicyScreen());
    case NamedRoutes.termsOfService:
      return _getPageRoute(TermsOfServiceScreen());
    case NamedRoutes.support:
      return _getPageRoute(SupportScreen());
    default:
      return _getPageRoute(SplashScreen());
  }
}

PageRoute _getPageRoute(Widget screen) {
  return MaterialPageRoute(builder: (context) => screen);
}
