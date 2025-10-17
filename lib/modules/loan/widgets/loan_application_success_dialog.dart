import 'package:flutter/material.dart';
import '../utils/loan_utils.dart';

class LoanApplicationSuccessDialog extends StatelessWidget {
  final String loanType;
  final VoidCallback onOkPressed;

  const LoanApplicationSuccessDialog({
    Key? key,
    required this.loanType,
    required this.onOkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
      title: const Text('Application Submitted!'),
      content: const Text(
        'Your loan application has been submitted successfully. You will receive updates on your registered email and phone number.',
      ),
      actions: [
        ElevatedButton(
          onPressed: onOkPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: LoanUtils.getLoanTypeColor(loanType),
            foregroundColor: Colors.white,
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }

  static void show(
    BuildContext context,
    String loanType,
    VoidCallback onOkPressed,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoanApplicationSuccessDialog(
        loanType: loanType,
        onOkPressed: onOkPressed,
      ),
    );
  }
}
