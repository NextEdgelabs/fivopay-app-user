import 'package:flutter/material.dart';
import '../models/models.dart';
import 'loan_application_input_fields.dart';
import 'loan_application_section_header.dart';

class LoanApplicationGoldWeightWidget extends StatelessWidget {
  final LoanCategory loanCategory;
  final TextEditingController goldWeightController;

  const LoanApplicationGoldWeightWidget({
    Key? key,
    required this.loanCategory,
    required this.goldWeightController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getLoanTypeColor(loanCategory.loanType);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoanApplicationSectionHeader(
            title: 'Gold Details',
            color: primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Please provide the weight of the gold that will be pledged as collateral.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          LoanApplicationInputField(
            label: 'Gold Weight',
            hint: 'Enter weight in grams',
            controller: goldWeightController,
            keyboardType: TextInputType.number,
            focusColor: primaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter gold weight';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              if (double.parse(value) <= 0) {
                return 'Weight must be greater than 0';
              }
              return null;
            },
            suffix: 'g',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'The gold weight will be verified and valued during the final approval process.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getLoanTypeColor(String loanType) {
    switch (loanType.toLowerCase()) {
      case 'gold':
        return const Color(0xFFEA580C); // Orange
      case 'personal':
        return const Color(0xFF7C3AED); // Purple
      case 'home':
        return const Color(0xFF1E3A8A); // Navy
      case 'auto':
        return const Color(0xFF0891B2); // Cyan
      case 'business':
        return const Color(0xFF059669); // Green
      default:
        return const Color(0xFF475569); // Slate
    }
  }
}
