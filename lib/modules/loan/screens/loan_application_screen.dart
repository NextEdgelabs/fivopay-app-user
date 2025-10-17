import 'package:flutter/material.dart';
import 'package:janseva/providers/user_provider.dart';
import 'package:janseva/routes/arguments.dart';
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
  final int _totalSteps = 4;

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

  // Form data
  String _selectedEmploymentType = 'Salaried';
  String _selectedEducation = 'Graduate';
  bool _hasExistingLoans = false;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    // Set the selected loan category in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = context.read<UserProvider>().currentUser;
      context.read<LoanProvider>().setSelectedLoanCategory(widget.args.loan);
      if (user != null) {
        _fullNameController.text = user.name ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = user.phoneNumber;
        _panController.text = user.panNumber ?? '';
        _aadharController.text = user.aadharNumber ?? '';
      }
    });
  }

  @override
  void dispose() {
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
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Application'),
        backgroundColor: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          LoanApplicationProgressIndicator(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
            primaryColor: LoanUtils.getLoanTypeColor(widget.args.loan.loanType),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                LoanApplicationLoanDetailsWidget(
                  loanCategory: widget.args.loan,
                  formKey: _formKey,
                  loanAmountController: _loanAmountController,
                  tenureController: _tenureController,
                  purposeController: _purposeController,
                  onLoanAmountChanged: _updateLoanAmount,
                ),
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
                ),
              ],
            ),
          ),
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
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _loanAmountController.text.isNotEmpty &&
            _tenureController.text.isNotEmpty &&
            _purposeController.text.isNotEmpty;
      case 1:
        return _fullNameController.text.isNotEmpty &&
            _emailController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _panController.text.isNotEmpty &&
            _aadharController.text.isNotEmpty &&
            _addressController.text.isNotEmpty &&
            _cityController.text.isNotEmpty &&
            _pincodeController.text.isNotEmpty;
      case 2:
        return _monthlyIncomeController.text.isNotEmpty &&
            _employerNameController.text.isNotEmpty &&
            _workExperienceController.text.isNotEmpty;
      default:
        return true;
    }
  }

  void _updateLoanAmount(String value) {
    // Update loan amount and recalculate EMI
    context.read<LoanProvider>().updateApplicationData('loanAmount', value);
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
      Navigator.of(context).pop(); // Close dialog
      Navigator.of(context).pop(); // Go back to previous screen
    });
  }
}
