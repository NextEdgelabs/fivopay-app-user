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

  AadharVerifyArguments({required this.stepNumber});
}
