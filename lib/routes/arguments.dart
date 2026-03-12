import 'package:flutter/widgets.dart';
import 'package:janseva/modules/loan/models/loan_application_response.dart';
import 'package:janseva/modules/loan/models/models.dart';

class CreateProfileArguments {
  final String phoneNumber;

  CreateProfileArguments({required this.phoneNumber});
}

class LoanDetailScreenArguments {
  final LoanCategory loan;

  LoanDetailScreenArguments({required this.loan});
}

class EsignLoanArguments {
  final LoanApplicationData loan;

  EsignLoanArguments({required this.loan});
}

class AadharVerifyArguments {
  final int stepNumber;
  final Color themeColor;

  AadharVerifyArguments({required this.stepNumber, required this.themeColor});
}

class LoanApplicationScreenV2Arguments {
  final LoanProduct loan;
  LoanApplicationScreenV2Arguments({required this.loan});
}

class DepositDetailScreenArguments {
  final dynamic deposit;

  DepositDetailScreenArguments({required this.deposit});
}

class LoanApplicationDetailScreenArguments {
  final LoanApplicationData loan;

  LoanApplicationDetailScreenArguments({required this.loan});
}
