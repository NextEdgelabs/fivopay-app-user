import 'package:flutter/material.dart';
import 'package:janseva/providers/user_provider.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/loan_provider.dart';
import '../widgets/widgets.dart';
import '../utils/loan_utils.dart';

class LoanApplicationScreen extends StatefulWidget {
  final LoanDetailScreenArguments args;

  const LoanApplicationScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;

  // Form controllers
  final _loanAmountController = TextEditingController();
  final _tenureController = TextEditingController();
  final _purposeController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _panController = TextEditingController();
  final _aadharController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();
  final _employerNameController = TextEditingController();
  final _workExperienceController = TextEditingController();
  final _goldWeightController = TextEditingController();

  // Form data
  String _selectedEmploymentType = 'Salaried';
  String _selectedEducation = 'Graduate';
  bool _hasExistingLoans = false;
  bool _agreeToTerms = false;

  // Getter to calculate total steps dynamically based on loan type
  int get _totalSteps =>
      widget.args.loan.loanType.toLowerCase() == 'gold' ? 6 : 5;

  @override
  void initState() {
    super.initState();
    // Set the selected loan category in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = context.read<UserProvider>().currentUser;
      final loanProvider = context.read<LoanProvider>();

      loanProvider.setSelectedLoanCategory(widget.args.loan);

      if (user != null) {
        _fullNameController.text = user.name ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = user.phoneNumber;
        _panController.text = user.panNumber ?? '';
        _aadharController.text = user.aadharNumber ?? '';

        // Update provider with user data
        loanProvider.updateApplicationData('fullName', user.name ?? '');
        loanProvider.updateApplicationData('email', user.email ?? '');
        loanProvider.updateApplicationData('phone', user.phoneNumber);
        loanProvider.updateApplicationData('pan', user.panNumber ?? '');
        loanProvider.updateApplicationData('aadhar', user.aadharNumber ?? '');
      }
    });
  }

  @override
  void dispose() {
    // Dispose controllers
    _loanAmountController.dispose();
    _tenureController.dispose();
    _purposeController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _panController.dispose();
    _aadharController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _monthlyIncomeController.dispose();
    _employerNameController.dispose();
    _workExperienceController.dispose();
    _goldWeightController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          // Clear loan provider data when back button is pressed
          context.read<LoanProvider>().clearApplicationData();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Loan Application',
            style: TextStyle(color: context.colors.bgColors),
          ),
          backgroundColor: LoanUtils.getLoanTypeColor(
            widget.args.loan.loanType,
          ),
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Clear loan provider data when back button in app bar is pressed
              context.read<LoanProvider>().clearApplicationData();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics:
              const NeverScrollableScrollPhysics(), // Disable swipe, use buttons only
          onPageChanged: (index) {
            setState(() {
              _currentStep = index;
            });
          },
          children: [
            _buildFullyScrollablePage(
              LoanApplicationProductSelectionWidget(
                loanCategory: widget.args.loan,
              ),
            ),
            _buildFullyScrollablePage(
              LoanApplicationLoanDetailsWidget(
                loanCategory: widget.args.loan,
                formKey: _formKey,
                loanAmountController: _loanAmountController,
                tenureController: _tenureController,
                purposeController: _purposeController,
                onLoanAmountChanged: _updateLoanAmount,
              ),
            ),
            _buildFullyScrollablePage(
              LoanApplicationPersonalDetailsWidget(
                loanCategory: widget.args.loan,
                fullNameController: _fullNameController,
                emailController: _emailController,
                phoneController: _phoneController,
                panController: _panController,
                aadharController: _aadharController,
                addressController: _addressController,
                cityController: _cityController,
                pincodeController: _pincodeController,
              ),
            ),
            _buildFullyScrollablePage(
              LoanApplicationEmploymentDetailsWidget(
                loanCategory: widget.args.loan,
                selectedEmploymentType: _selectedEmploymentType,
                onEmploymentTypeChanged: (value) {
                  setState(() {
                    _selectedEmploymentType = value!;
                  });
                },
                monthlyIncomeController: _monthlyIncomeController,
                employerNameController: _employerNameController,
                workExperienceController: _workExperienceController,
                selectedEducation: _selectedEducation,
                onEducationChanged: (value) {
                  setState(() {
                    _selectedEducation = value!;
                  });
                },
                hasExistingLoans: _hasExistingLoans,
                onExistingLoansChanged: (value) {
                  setState(() {
                    _hasExistingLoans = value!;
                  });
                },
              ),
            ),
            if (widget.args.loan.loanType.toLowerCase() == 'gold')
              _buildFullyScrollablePage(
                LoanApplicationGoldWeightWidget(
                  loanCategory: widget.args.loan,
                  goldWeightController: _goldWeightController,
                ),
              ),
            _buildFullyScrollablePage(
              LoanApplicationReviewWidget(
                loanCategory: widget.args.loan,
                loanAmountController: _loanAmountController,
                tenureController: _tenureController,
                purposeController: _purposeController,
                fullNameController: _fullNameController,
                emailController: _emailController,
                phoneController: _phoneController,
                panController: _panController,
                addressController: _addressController,
                cityController: _cityController,
                selectedEmploymentType: _selectedEmploymentType,
                monthlyIncomeController: _monthlyIncomeController,
                employerNameController: _employerNameController,
                workExperienceController: _workExperienceController,
                selectedEducation: _selectedEducation,
                agreeToTerms: _agreeToTerms,
                onTermsChanged: (value) {
                  setState(() {
                    _agreeToTerms = value!;
                  });
                },
                onSubmit: _submitApplication,
                goldWeightController:
                    widget.args.loan.loanType.toLowerCase() == 'gold'
                    ? _goldWeightController
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullyScrollablePage(Widget contentWidget) {
    return SingleChildScrollView(
      child: Column(
        children: [
          LoanApplicationProgressIndicator(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            primaryColor: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
          ),
          contentWidget,
          LoanApplicationNavigationButtons(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            onPrevious: _currentStep > 0 ? _previousStep : null,
            onNext: _currentStep < _totalSteps - 1 ? _nextStep : null,
            primaryColor: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      // Update provider with current step data before moving to next step
      _updateProviderData();

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateProviderData() {
    final loanProvider = context.read<LoanProvider>();

    switch (_currentStep) {
      case 0: // Product Selection - No additional data needed, already handled in widget
        break;
      case 1: // Loan Details
        loanProvider.updateApplicationData(
          'loanAmount',
          _loanAmountController.text,
        );
        loanProvider.updateApplicationData('tenure', _tenureController.text);
        loanProvider.updateApplicationData('purpose', _purposeController.text);
        break;
      case 2: // Personal Details
        loanProvider.updateApplicationData(
          'fullName',
          _fullNameController.text,
        );
        loanProvider.updateApplicationData('email', _emailController.text);
        loanProvider.updateApplicationData('phone', _phoneController.text);
        loanProvider.updateApplicationData('pan', _panController.text);
        loanProvider.updateApplicationData('aadhar', _aadharController.text);
        loanProvider.updateApplicationData('address', _addressController.text);
        loanProvider.updateApplicationData('city', _cityController.text);
        loanProvider.updateApplicationData('pincode', _pincodeController.text);
        break;
      case 3: // Employment Details
        loanProvider.updateApplicationData(
          'employmentType',
          _selectedEmploymentType,
        );
        loanProvider.updateApplicationData(
          'monthlyIncome',
          _monthlyIncomeController.text,
        );
        loanProvider.updateApplicationData(
          'employerName',
          _employerNameController.text,
        );
        loanProvider.updateApplicationData(
          'workExperience',
          _workExperienceController.text,
        );
        loanProvider.updateApplicationData('education', _selectedEducation);
        loanProvider.updateApplicationData(
          'hasExistingLoans',
          _hasExistingLoans,
        );
        break;
    }
  }

  void _previousStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateCurrentStep() {
    // Update provider data before validation
    _updateProviderData();

    final loanProvider = context.read<LoanProvider>();

    // Trigger form validation for widgets that have forms
    if (_currentStep == 2 || _currentStep == 3) {
      loanProvider.triggerFormValidation();
      // Give a brief moment for widgets to process the validation trigger
      Future.delayed(const Duration(milliseconds: 50), () {
        loanProvider.clearFormValidation();
      });
    }

    // Validate form fields based on current step
    switch (_currentStep) {
      case 1: // Loan Details step
        if (!_formKey.currentState!.validate()) {
          return false;
        }
        break;
      case 2: // Personal Details step - handled by widget's internal form validation
      case 3: // Employment Details step - handled by widget's internal form validation
        // These steps have their own Form widgets with validators
        // The provider validation below will catch any validation errors
        break;
      case 4: // Gold Weight step (for gold loans)
        if (widget.args.loan.loanType.toLowerCase() == 'gold') {
          if (_goldWeightController.text.isEmpty) {
            _showValidationErrors(['Please enter gold weight']);
            return false;
          }
          if (double.tryParse(_goldWeightController.text) == null) {
            _showValidationErrors(['Please enter a valid number']);
            return false;
          }
          if (double.parse(_goldWeightController.text) <= 0) {
            _showValidationErrors(['Weight must be greater than 0']);
            return false;
          }
        }
        break;
    }

    // Validate using provider logic (this covers all steps including product selection)
    final validationErrors = loanProvider.getStepValidationErrors(_currentStep);

    if (validationErrors.isNotEmpty) {
      _showValidationErrors(validationErrors);
      return false;
    }

    return true;
  }

  void _showValidationErrors(List<String> errors) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Validation Error',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please fix the following issues to continue:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              ...errors
                  .map(
                    (error) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              error,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateLoanAmount(String value) {
    // Update loan amount and recalculate EMI
    final loanProvider = context.read<LoanProvider>();
    loanProvider.updateApplicationData('loanAmount', value);

    // Trigger EMI recalculation if tenure is also available
    if (_tenureController.text.isNotEmpty) {
      final amount = double.tryParse(value.replaceAll(',', ''));
      final tenure = int.tryParse(_tenureController.text);

      if (amount != null && tenure != null) {
        final emiData = loanProvider.calculateEMI(
          principal: amount,
          annualRate: widget.args.loan.interestRate,
          tenureMonths: tenure,
        );
        loanProvider.updateApplicationData('emiDetails', emiData);
      }
    }
  }

  void _submitApplication() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Collect all application data
    final applicationData = {
      'loanCategoryId': widget.args.loan.id,
      'loanAmount': _loanAmountController.text,
      'tenure': _tenureController.text,
      'purpose': _purposeController.text,
      'fullName': _fullNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'pan': _panController.text,
      'aadhar': _aadharController.text,
      'address': _addressController.text,
      'city': _cityController.text,
      'pincode': _pincodeController.text,
      'employmentType': _selectedEmploymentType,
      'monthlyIncome': _monthlyIncomeController.text,
      'employerName': _employerNameController.text,
      'workExperience': _workExperienceController.text,
      'education': _selectedEducation,
      'hasExistingLoans': _hasExistingLoans,
    };

    // Update application data in provider
    context.read<LoanProvider>().setApplicationData(applicationData);

    // Submit application
    final success = await context.read<LoanProvider>().submitLoanApplication();

    if (success) {
      // Show success dialog
      _showSuccessDialog();
    } else {
      // Show error message
      final errorMessage =
          context.read<LoanProvider>().errorMessage ??
          'Failed to submit application';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccessDialog() {
    LoanApplicationSuccessDialog.show(context, widget.args.loan.loanType, () {
      // Clear loan provider data after successful submission
      context.read<LoanProvider>().clearApplicationData();
      Navigator.of(context).pop(); // Close dialog
      Navigator.of(context).pop(); // Go back to previous screen
    });
  }
}
