import 'package:flutter/material.dart';
import '../models/models.dart';
import 'loan_application_section_header.dart';
import 'loan_application_review_card.dart';
import 'loan_application_terms_conditions.dart';
import 'loan_application_submit_button.dart';

class LoanApplicationReviewWidget extends StatelessWidget {
  final LoanCategory loanCategory;
  final TextEditingController loanAmountController;
  final TextEditingController tenureController;
  final TextEditingController purposeController;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController panController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final String selectedEmploymentType;
  final TextEditingController monthlyIncomeController;
  final TextEditingController employerNameController;
  final TextEditingController workExperienceController;
  final String selectedEducation;
  final bool agreeToTerms;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onSubmit;

  const LoanApplicationReviewWidget({
    Key? key,
    required this.loanCategory,
    required this.loanAmountController,
    required this.tenureController,
    required this.purposeController,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.panController,
    required this.addressController,
    required this.cityController,
    required this.selectedEmploymentType,
    required this.monthlyIncomeController,
    required this.employerNameController,
    required this.workExperienceController,
    required this.selectedEducation,
    required this.agreeToTerms,
    required this.onTermsChanged,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getLoanTypeColor(loanCategory.loanType);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoanApplicationSectionHeader(
            title: 'Review Your Application',
            color: primaryColor,
          ),
          const SizedBox(height: 16),

          // Loan details review
          LoanApplicationReviewCard(
            title: 'Loan Details',
            reviewItems: [
              MapEntry('Loan Type', loanCategory.categoryName),
              MapEntry('Amount', '₹${loanAmountController.text}'),
              MapEntry('Tenure', '${tenureController.text} months'),
              MapEntry('Purpose', purposeController.text),
            ],
            loanType: loanCategory.loanType,
          ),
          const SizedBox(height: 16),

          // Personal details review
          LoanApplicationReviewCard(
            title: 'Personal Details',
            reviewItems: [
              MapEntry('Name', fullNameController.text),
              MapEntry('Email', emailController.text),
              MapEntry('Phone', phoneController.text),
              MapEntry('PAN', panController.text),
              MapEntry('Address', addressController.text),
              MapEntry('City', cityController.text),
            ],
            loanType: loanCategory.loanType,
          ),
          const SizedBox(height: 16),

          // Employment details review
          LoanApplicationReviewCard(
            title: 'Employment Details',
            reviewItems: [
              MapEntry('Employment Type', selectedEmploymentType),
              MapEntry('Monthly Income', '₹${monthlyIncomeController.text}'),
              MapEntry('Employer', employerNameController.text),
              MapEntry('Experience', '${workExperienceController.text} years'),
              MapEntry('Education', selectedEducation),
            ],
            loanType: loanCategory.loanType,
          ),
          const SizedBox(height: 24),

          // Terms and conditions
          LoanApplicationTermsAndConditions(
            termsAndConditions: loanCategory.termsAndConditions,
            agreeToTerms: agreeToTerms,
            onChanged: onTermsChanged,
            loanType: loanCategory.loanType,
          ),
          const SizedBox(height: 24),

          // Submit button
          LoanApplicationSubmitButton(
            agreeToTerms: agreeToTerms,
            onSubmit: onSubmit,
            loanType: loanCategory.loanType,
          ),
        ],
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
