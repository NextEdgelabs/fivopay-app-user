import 'package:flutter/material.dart';
import '../models/models.dart';
import 'loan_application_input_fields.dart';
import 'loan_application_section_header.dart';
import 'loan_category_display_card.dart';
import 'loan_application_emi_calculator_card.dart';

class LoanApplicationLoanDetailsWidget extends StatelessWidget {
  final LoanCategory loanCategory;
  final GlobalKey<FormState> formKey;
  final TextEditingController loanAmountController;
  final TextEditingController tenureController;
  final TextEditingController purposeController;
  final void Function(String) onLoanAmountChanged;

  const LoanApplicationLoanDetailsWidget({
    Key? key,
    required this.loanCategory,
    required this.formKey,
    required this.loanAmountController,
    required this.tenureController,
    required this.purposeController,
    required this.onLoanAmountChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getLoanTypeColor(loanCategory.loanType);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoanApplicationSectionHeader(
              title: 'Loan Information',
              color: primaryColor,
            ),
            const SizedBox(height: 16),

            // Loan category card
            LoanCategoryDisplayCard(loanCategory: loanCategory),
            const SizedBox(height: 24),

            // Loan amount
            LoanApplicationInputField(
              controller: loanAmountController,
              label: 'Loan Amount',
              hint: 'Enter desired loan amount',
              prefix: '₹',
              keyboardType: TextInputType.number,
              focusColor: primaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter loan amount';
                }
                final amount = double.tryParse(value.replaceAll(',', ''));
                if (amount == null) {
                  return 'Please enter a valid amount';
                }
                if (amount < loanCategory.minLoanAmount) {
                  return 'Minimum amount is ${loanCategory.formattedMinAmount}';
                }
                if (amount > loanCategory.maxLoanAmount) {
                  return 'Maximum amount is ${loanCategory.formattedMaxAmount}';
                }
                return null;
              },
              onChanged: onLoanAmountChanged,
            ),
            const SizedBox(height: 16),

            // Tenure
            LoanApplicationInputField(
              controller: tenureController,
              label: 'Loan Tenure (Months)',
              hint: 'Enter loan tenure',
              suffix: 'months',
              keyboardType: TextInputType.number,
              focusColor: primaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter loan tenure';
                }
                final tenure = int.tryParse(value);
                if (tenure == null) {
                  return 'Please enter a valid tenure';
                }
                if (tenure < loanCategory.minTenureMonths) {
                  return 'Minimum tenure is ${loanCategory.minTenureMonths} months';
                }
                if (tenure > loanCategory.maxTenureMonths) {
                  return 'Maximum tenure is ${loanCategory.maxTenureMonths} months';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Purpose
            LoanApplicationInputField(
              controller: purposeController,
              label: 'Purpose of Loan',
              hint: 'Describe the purpose of this loan',
              maxLines: 3,
              focusColor: primaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the purpose of loan';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // EMI Calculator card
            LoanApplicationEMICalculatorCard(
              loanCategory: loanCategory,
              loanAmountController: loanAmountController,
              tenureController: tenureController,
            ),
          ],
        ),
      ),
    );
  }

  Color _getLoanTypeColor(String loanType) {
    switch (loanType.toLowerCase()) {
      case 'personal':
        return Colors.blue;
      case 'home':
        return Colors.green;
      case 'car':
        return Colors.orange;
      case 'education':
        return Colors.purple;
      case 'business':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
