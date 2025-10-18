import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/loan_provider.dart';
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

    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
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
                // LoanCategoryDisplayCard(loanCategory: loanCategory),
                LoanProductDisplayCard(),
                const SizedBox(height: 24),

                // Show any validation errors from provider
                if (loanProvider.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loanProvider.errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

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

                    // Use selected product constraints if available
                    final selectedProduct = loanProvider.selectedProduct;
                    if (selectedProduct != null) {
                      if (amount < selectedProduct.minAmount) {
                        return 'Minimum amount is ${selectedProduct.minAmount}';
                      }
                      if (amount > selectedProduct.maxAmount) {
                        return 'Maximum amount is ${selectedProduct.maxAmount}';
                      }
                    } else {
                      // Fallback to loan category constraints
                      if (amount < loanCategory.minLoanAmount) {
                        return 'Minimum amount is ${loanCategory.formattedMinAmount}';
                      }
                      if (amount > loanCategory.maxLoanAmount) {
                        return 'Maximum amount is ${loanCategory.formattedMaxAmount}';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    onLoanAmountChanged(value);
                    loanProvider.updateApplicationData('loanAmount', value);
                  },
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

                    // Use selected product constraints if available
                    final selectedProduct = loanProvider.selectedProduct;
                    if (selectedProduct != null) {
                      if (tenure < selectedProduct.minTenureMonths) {
                        return 'Minimum tenure is ${selectedProduct.minTenureMonths} months';
                      }
                      if (tenure > selectedProduct.maxTenureMonths) {
                        return 'Maximum tenure is ${selectedProduct.maxTenureMonths} months';
                      }
                    } else {
                      // Fallback to loan category constraints
                      if (tenure < loanCategory.minTenureMonths) {
                        return 'Minimum tenure is ${loanCategory.minTenureMonths} months';
                      }
                      if (tenure > loanCategory.maxTenureMonths) {
                        return 'Maximum tenure is ${loanCategory.maxTenureMonths} months';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    loanProvider.updateApplicationData('tenure', value);
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
                    if (value.trim().length < 10) {
                      return 'Please provide more details about loan purpose';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    loanProvider.updateApplicationData('purpose', value);
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
      },
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
