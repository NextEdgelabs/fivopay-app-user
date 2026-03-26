import 'package:flutter/material.dart';
import '../utils/loan_utils.dart';

class LoanApplicationTermsAndConditions extends StatelessWidget {
  final String termsAndConditions;
  final bool agreeToTerms;
  final ValueChanged<bool?> onChanged;
  final String loanType;

  const LoanApplicationTermsAndConditions({
    Key? key,
    required this.termsAndConditions,
    required this.agreeToTerms,
    required this.onChanged,
    required this.loanType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              termsAndConditions,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: agreeToTerms,
              onChanged: onChanged,
              title: Text(
                'I agree to the terms and conditions',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: LoanUtils.getLoanTypeColor(loanType),
            ),
          ],
        ),
      ),
    );
  }
}
