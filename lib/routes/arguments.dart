import 'package:janseva/modules/loan/models/models.dart';

class CreateProfileArguments {
  final String phoneNumber;

  CreateProfileArguments({required this.phoneNumber});
}

class LoanDetailScreenArguments {
  final LoanCategory loan;

  LoanDetailScreenArguments({required this.loan});
}
