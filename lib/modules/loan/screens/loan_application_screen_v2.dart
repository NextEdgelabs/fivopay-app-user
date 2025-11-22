import 'package:flutter/material.dart';
import 'package:janseva/modules/loan/providers/loan_provider_v2.dart';
import 'package:janseva/modules/loan/screens/components/adhaar_verify.dart';
import 'package:janseva/modules/loan/widgets/loan_application_progress_indicator.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../routes/arguments.dart';
import '../utils/loan_utils.dart';
import '../widgets/loan_application_navigation_buttons.dart';

class LoanApplicationScreenv2 extends StatefulWidget {
  final LoanApplicationScreenV2Arguments args;
  const LoanApplicationScreenv2({super.key, required this.args});

  @override
  State<LoanApplicationScreenv2> createState() =>
      _LoanApplicationScreenv2State();
}

class _LoanApplicationScreenv2State extends State<LoanApplicationScreenv2> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
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

  String _selectedEmploymentType = 'Salaried';
  String _selectedEducation = 'Graduate';
  bool _hasExistingLoans = false;
  bool _agreeToTerms = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoanProviderV2>().selectLoanProduct(widget.args.loan);
      var user = context.read<UserProvider>().currentUser;

      if (user != null) {
        _fullNameController.text = user.name ?? '';
        _emailController.text = user.email ?? '';
        _phoneController.text = user.phoneNumber;
        _panController.text = user.panNumber ?? '';
        _aadharController.text = user.aadharNumber ?? '';
      }
    });

    super.initState();
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
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (_pageController.hasClients && _pageController.page != 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (didPop) {
          context.read<LoanProviderV2>().clearApplicationData();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Loan Application'),
          backgroundColor: LoanUtils.getLoanTypeColor(
            widget.args.loan.loanCategory?.loanType ?? "LOAN",
          ),
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Clear loan provider data when back button in app bar is pressed
              context.read<LoanProviderV2>().clearApplicationData();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Consumer<LoanProviderV2>(
          builder: (context, loanProvider, child) {
            return PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: loanProvider.loanApplicationScreens().map(
                  (screen) => buildFullyScrollablePage(screen, loanProvider),
               ).toList(),
            );
          },
        ),
      ),
    );
  }
  Widget buildFullyScrollablePage(Widget contentWidget, LoanProviderV2 loanProvider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          LoanApplicationProgressIndicator(
            currentStep: loanProvider.currentLoanStep,
            totalSteps: loanProvider.loanApplicationSteps(),
            primaryColor: LoanUtils.getLoanTypeColor(
              widget.args.loan.loanCategory?.loanType ?? "LOAN",
            ),
          ),
          contentWidget,
          LoanApplicationNavigationButtons(
            currentStep: loanProvider.currentLoanStep,
            totalSteps: loanProvider.loanApplicationSteps(),
            onPrevious: loanProvider.previousLoanStep,
            onNext: loanProvider.nextLoanStep,
            primaryColor: LoanUtils.getLoanTypeColor(
              widget.args.loan.loanCategory?.loanType ?? "LOAN",
            ),
          ),
        ],
      ),
    );
  }
}
