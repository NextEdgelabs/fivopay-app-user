import 'package:flutter/material.dart';
import '../models/models.dart';
import 'loan_application_input_fields.dart';
import 'loan_application_section_header.dart';

class LoanApplicationEmploymentDetailsWidget extends StatelessWidget {
  final LoanCategory loanCategory;
  final String selectedEmploymentType;
  final ValueChanged<String?> onEmploymentTypeChanged;
  final TextEditingController monthlyIncomeController;
  final TextEditingController employerNameController;
  final TextEditingController workExperienceController;
  final String selectedEducation;
  final ValueChanged<String?> onEducationChanged;
  final bool hasExistingLoans;
  final ValueChanged<bool?> onExistingLoansChanged;

  const LoanApplicationEmploymentDetailsWidget({
    Key? key,
    required this.loanCategory,
    required this.selectedEmploymentType,
    required this.onEmploymentTypeChanged,
    required this.monthlyIncomeController,
    required this.employerNameController,
    required this.workExperienceController,
    required this.selectedEducation,
    required this.onEducationChanged,
    required this.hasExistingLoans,
    required this.onExistingLoansChanged,
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
            title: 'Employment Information',
            color: primaryColor,
          ),
          const SizedBox(height: 16),

          // Employment type
          LoanApplicationDropdownField(
            label: 'Employment Type',
            value: selectedEmploymentType,
            items: [
              'Salaried',
              'Self-Employed',
              'Business Owner',
              'Professional',
            ],
            onChanged: onEmploymentTypeChanged,
            focusColor: primaryColor,
          ),
          const SizedBox(height: 16),

          LoanApplicationInputField(
            controller: monthlyIncomeController,
            label: 'Monthly Income',
            hint: 'Enter your monthly income',
            prefix: '₹',
            keyboardType: TextInputType.number,
            focusColor: primaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your monthly income';
              }
              final income = double.tryParse(value.replaceAll(',', ''));
              if (income == null) {
                return 'Please enter a valid income';
              }
              if (income < loanCategory.eligibilityCriteria.minIncome) {
                return 'Minimum income required is ${loanCategory.eligibilityCriteria.formattedMinIncome}';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          LoanApplicationInputField(
            controller: employerNameController,
            label: 'Employer/Company Name',
            hint: 'Enter your employer or company name',
            focusColor: primaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter employer/company name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          LoanApplicationInputField(
            controller: workExperienceController,
            label: 'Work Experience (Years)',
            hint: 'Enter your work experience',
            suffix: 'years',
            keyboardType: TextInputType.number,
            focusColor: primaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your work experience';
              }
              final experience = double.tryParse(value);
              if (experience == null || experience < 0) {
                return 'Please enter valid work experience';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Education
          LoanApplicationDropdownField(
            label: 'Education',
            value: selectedEducation,
            items: ['Graduate', 'Post Graduate', 'Diploma', 'HSC', 'Others'],
            onChanged: onEducationChanged,
            focusColor: primaryColor,
          ),
          const SizedBox(height: 24),

          LoanApplicationSectionHeader(
            title: 'Additional Information',
            color: primaryColor,
          ),
          const SizedBox(height: 16),

          // Existing loans
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Do you have any existing loans?',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Yes'),
                          value: true,
                          groupValue: hasExistingLoans,
                          onChanged: onExistingLoansChanged,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('No'),
                          value: false,
                          groupValue: hasExistingLoans,
                          onChanged: onExistingLoansChanged,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
