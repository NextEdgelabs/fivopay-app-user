import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/loan_provider.dart';
import 'loan_application_input_fields.dart';
import 'loan_application_section_header.dart';

class LoanApplicationEmploymentDetailsWidget extends StatefulWidget {
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
  State<LoanApplicationEmploymentDetailsWidget> createState() =>
      _LoanApplicationEmploymentDetailsWidgetState();
}

class _LoanApplicationEmploymentDetailsWidgetState
    extends State<LoanApplicationEmploymentDetailsWidget> {
  final _employmentFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getLoanTypeColor(widget.loanCategory.loanType);

    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        // Trigger form validation if requested
        if (loanProvider.shouldValidateForms) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _employmentFormKey.currentState?.validate();
          });
        }

        return Form(
          key: _employmentFormKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoanApplicationSectionHeader(
                  title: 'Employment Information',
                  color: primaryColor,
                ),
                const SizedBox(height: 16),

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

                // Employment type
                LoanApplicationDropdownField(
                  label: 'Employment Type',
                  value: widget.selectedEmploymentType,
                  items: [
                    'Salaried',
                    'Self-Employed',
                    'Business Owner',
                    'Professional',
                  ],
                  onChanged: (value) {
                    widget.onEmploymentTypeChanged(value);
                    loanProvider.updateApplicationData('employmentType', value);
                  },
                  focusColor: primaryColor,
                ),
                const SizedBox(height: 16),

                LoanApplicationInputField(
                  controller: widget.monthlyIncomeController,
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
                    if (income <
                        widget.loanCategory.eligibilityCriteria.minIncome) {
                      return 'Minimum income required is ${widget.loanCategory.eligibilityCriteria.formattedMinIncome}';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    loanProvider.updateApplicationData('monthlyIncome', value);
                  },
                ),
                const SizedBox(height: 16),

                LoanApplicationInputField(
                  controller: widget.employerNameController,
                  label: 'Employer/Company Name',
                  hint: 'Enter your employer or company name',
                  focusColor: primaryColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter employer/company name';
                    }
                    if (value.trim().length < 2) {
                      return 'Please enter a valid employer name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    loanProvider.updateApplicationData('employerName', value);
                  },
                ),
                const SizedBox(height: 16),

                LoanApplicationInputField(
                  controller: widget.workExperienceController,
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
                    if (experience > 50) {
                      return 'Please enter a realistic work experience';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    loanProvider.updateApplicationData('workExperience', value);
                  },
                ),
                const SizedBox(height: 16),

                // Education
                LoanApplicationDropdownField(
                  label: 'Education',
                  value: widget.selectedEducation,
                  items: [
                    'Graduate',
                    'Post Graduate',
                    'Diploma',
                    'HSC',
                    'Others',
                  ],
                  onChanged: (value) {
                    widget.onEducationChanged(value);
                    loanProvider.updateApplicationData('education', value);
                  },
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
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<bool>(
                                title: const Text('Yes'),
                                value: true,
                                groupValue: widget.hasExistingLoans,
                                onChanged: (value) {
                                  widget.onExistingLoansChanged(value);
                                  loanProvider.updateApplicationData(
                                    'hasExistingLoans',
                                    value,
                                  );
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<bool>(
                                title: const Text('No'),
                                value: false,
                                groupValue: widget.hasExistingLoans,
                                onChanged: (value) {
                                  widget.onExistingLoansChanged(value);
                                  loanProvider.updateApplicationData(
                                    'hasExistingLoans',
                                    value,
                                  );
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Additional eligibility check display
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Eligibility Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildEligibilityItem(
                        'Minimum Income',
                        '₹${widget.loanCategory.eligibilityCriteria.formattedMinIncome}',
                        _checkIncomeEligibility(loanProvider),
                      ),
                      _buildEligibilityItem(
                        'Age Range',
                        '${widget.loanCategory.eligibilityCriteria.minAge}-${widget.loanCategory.eligibilityCriteria.maxAge} years',
                        true, // We're not collecting age in this form
                      ),
                      _buildEligibilityItem(
                        'Minimum Credit Score',
                        '${widget.loanCategory.eligibilityCriteria.creditScoreMin}',
                        true, // We're not checking credit score in this form
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _checkIncomeEligibility(LoanProvider loanProvider) {
    final incomeStr = loanProvider.applicationData['monthlyIncome'];
    if (incomeStr == null || incomeStr.isEmpty) return false;

    final income = double.tryParse(incomeStr.toString().replaceAll(',', ''));
    if (income == null) return false;

    return income >= widget.loanCategory.eligibilityCriteria.minIncome;
  }

  Widget _buildEligibilityItem(String label, String requirement, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isMet ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label: $requirement',
              style: TextStyle(
                fontSize: 14,
                color: isMet ? Colors.green.shade700 : Colors.grey.shade600,
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

  bool validateForm() {
    return _employmentFormKey.currentState?.validate() ?? false;
  }
}
