import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/loan_application.dart';
import '../providers/user_provider.dart';
import '../providers/loan_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../components/components.dart';
import '../widgets/pan_verification_widget.dart';
import '../widgets/aadhaar_verification_widget.dart';
import '../widgets/relative_selector_widget.dart';
import '../widgets/address_form_widget.dart';
import '../widgets/verification_status_card.dart';

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;
  String _selectedLoanType = 'personal';
  int _selectedTenure = 12;
  double _profitRate = 12.0; // Annual profit rate
  double _monthlyInstallment = 0;

  @override
  void initState() {
    super.initState();
    _calculateInstallment();

    // Initialize loan provider with current user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      final loanProvider = context.read<LoanProvider>();
      if (userProvider.currentUser != null) {
        loanProvider.initializeWithUser(userProvider.currentUser!);
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _calculateInstallment() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final tenure = _selectedTenure;

    if (amount > 0 && tenure > 0) {
      // Ethical banking calculation (no interest, profit sharing)
      final annualProfit = amount * (_profitRate / 100);
      final totalProfit = annualProfit * (tenure / 12);
      final totalAmount = amount + totalProfit;
      final monthlyInstallment = totalAmount / tenure;

      setState(() {
        _monthlyInstallment = monthlyInstallment;
      });

      // Update loan provider
      final loanProvider = context.read<LoanProvider>();
      loanProvider.setLoanDetails(
        loanType: _selectedLoanType,
        amount: amount,
        purpose: _purposeController.text,
        tenure: tenure,
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _canProceedToNextStep() {
    final loanProvider = context.read<LoanProvider>();

    switch (_currentStep) {
      case 0: // Personal info and verification
        if (loanProvider.applicantType == 'relative') {
          return loanProvider.selectedRelation != null &&
              loanProvider.relativeName != null &&
              loanProvider.relativeName!.isNotEmpty;
        }
        return true;
      case 1: // Document verification
        return loanProvider.isPANVerified && loanProvider.isAadhaarVerified;
      case 2: // Address details
        return loanProvider.isAadhaarVerified;
      case 3: // Loan details
        return _amountController.text.isNotEmpty &&
            _purposeController.text.isNotEmpty &&
            (double.tryParse(_amountController.text) ?? 0) >= 5000;
      default:
        return false;
    }
  }

  Future<void> _submitLoanApplication() async {
    if (!_formKey.currentState!.validate()) return;

    final loanProvider = context.read<LoanProvider>();
    final userProvider = context.read<UserProvider>();

    setState(() => _isLoading = true);
    String? errorMsg;

    try {
      final loanApplication = await loanProvider.submitLoanApplication();
      final currentUser = userProvider.currentUser;

      if (currentUser != null) {
        final List<LoanApplication> updatedLoans = [
          ...(currentUser.loanApplications ?? []),
          loanApplication,
        ];
        final updatedUser = currentUser.copyWith(
          loanApplications: updatedLoans,
          totalLoans:
              (currentUser.totalLoans ?? 0) + loanApplication.requestedAmount,
        );

        await userProvider.updateUser(updatedUser);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Loan application submitted successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
        // Pop after showing snackbar
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      errorMsg = e.toString();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        if (errorMsg != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit loan application: $errorMsg'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Application'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 0) {
              _previousStep();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            StepHeader(
              title: _currentStep == 0
                  ? 'Personal Info'
                  : _currentStep == 1
                  ? 'Verification'
                  : _currentStep == 2
                  ? 'Address'
                  : 'Loan Details',
              currentStep: _currentStep + 1,
              totalSteps: 4,
            ),

            // Page content
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildPersonalInfoStep(),
                    _buildVerificationStep(),
                    _buildAddressStep(),
                    _buildLoanDetailsStep(),
                  ],
                ),
              ),
            ),

            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: CustomButton(
                        onPressed: _previousStep,
                        text: 'Previous',
                        variant: ButtonVariant.outlined,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingM),
                  ],
                  Expanded(
                    child: Consumer<LoanProvider>(
                      builder: (context, loanProvider, child) {
                        if (_currentStep == 3) {
                          return CustomButton(
                            onPressed: _isLoading
                                ? null
                                : _submitLoanApplication,
                            text: _isLoading
                                ? 'Submitting...'
                                : 'Submit Application',
                            isLoading: _isLoading,
                          );
                        }
                        return CustomButton(
                          onPressed: _canProceedToNextStep() ? _nextStep : null,
                          text: 'Next',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step 1: Personal Information',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSizes.paddingL),

              if (loanProvider.applicantType == 'self') ...[
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 24,
                          ),
                          const SizedBox(width: AppSizes.paddingS),
                          Text(
                            'Auto-populated Information',
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      Text(
                        'Your personal information will be automatically populated from your profile. You can proceed to the next step.',
                        style: AppTextStyles.body2,
                      ),
                      const SizedBox(height: AppSizes.paddingL),
                      if (loanProvider.currentUser != null) ...[
                        _buildInfoRow(
                          'Name',
                          loanProvider.currentUser!.name ?? 'Not provided',
                        ),
                        _buildInfoRow(
                          'Phone',
                          loanProvider.currentUser!.phoneNumber,
                        ),
                        _buildInfoRow(
                          'Email',
                          loanProvider.currentUser!.email ?? 'Not provided',
                        ),
                      ],
                    ],
                  ),
                ),
              ] else ...[
                const RelativeSelectorWidget(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildVerificationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 2: Document Verification', style: AppTextStyles.heading2),
          const SizedBox(height: AppSizes.paddingL),

          const VerificationStatusCard(),
          const SizedBox(height: AppSizes.paddingL),

          const PANVerificationWidget(),
          const SizedBox(height: AppSizes.paddingL),

          const AadhaarVerificationWidget(),
        ],
      ),
    );
  }

  Widget _buildAddressStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 3: Address Verification', style: AppTextStyles.heading2),
          const SizedBox(height: AppSizes.paddingL),

          const AddressFormWidget(),
        ],
      ),
    );
  }

  Widget _buildLoanDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Step 4: Loan Details', style: AppTextStyles.heading2),
          const SizedBox(height: AppSizes.paddingL),

          // Loan Type Selection
          FormSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Loan Type', style: AppTextStyles.heading3),
                const SizedBox(height: AppSizes.paddingM),
                Wrap(
                  spacing: AppSizes.paddingM,
                  runSpacing: AppSizes.paddingS,
                  children: [
                    ChoiceChip(
                      label: const Text('Personal'),
                      selected: _selectedLoanType == 'personal',
                      onSelected: (selected) {
                        if (!selected) return;
                        setState(() => _selectedLoanType = 'personal');
                        _calculateInstallment();
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Business'),
                      selected: _selectedLoanType == 'business',
                      onSelected: (selected) {
                        if (!selected) return;
                        setState(() => _selectedLoanType = 'business');
                        _calculateInstallment();
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Education'),
                      selected: _selectedLoanType == 'education',
                      onSelected: (selected) {
                        if (!selected) return;
                        setState(() => _selectedLoanType = 'education');
                        _calculateInstallment();
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Housing'),
                      selected: _selectedLoanType == 'housing',
                      onSelected: (selected) {
                        if (!selected) return;
                        setState(() => _selectedLoanType = 'housing');
                        _calculateInstallment();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.paddingL),

          // Amount and Purpose
          FormSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Loan Details', style: AppTextStyles.heading3),
                const SizedBox(height: AppSizes.paddingM),

                CustomTextField(
                  controller: _amountController,
                  labelText: 'Loan Amount (₹)',
                  hintText: 'Enter loan amount',
                  prefixIcon: Icons.currency_rupee,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _calculateInstallment(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter loan amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    if (amount < 5000) {
                      return 'Minimum loan amount is ₹5,000';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSizes.paddingM),

                CustomTextField(
                  controller: _purposeController,
                  labelText: 'Purpose',
                  hintText: 'Enter loan purpose',
                  prefixIcon: Icons.description,
                  onChanged: (value) => _calculateInstallment(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter loan purpose';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.paddingL),

          // Tenure Selection
          FormSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Tenure', style: AppTextStyles.heading3),
                const SizedBox(height: AppSizes.paddingM),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment<int>(value: 12, label: Text('12m')),
                    ButtonSegment<int>(value: 24, label: Text('24m')),
                    ButtonSegment<int>(value: 36, label: Text('36m')),
                    ButtonSegment<int>(value: 48, label: Text('48m')),
                    ButtonSegment<int>(value: 60, label: Text('60m')),
                  ],
                  selected: {_selectedTenure},
                  showSelectedIcon: false,
                  onSelectionChanged: (selection) {
                    final int newValue = selection.first;
                    setState(() => _selectedTenure = newValue);
                    _calculateInstallment();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSizes.paddingL),

          // Calculation Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Loan Summary', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSizes.paddingM),
                  _buildSummaryRow(
                    'Loan Amount',
                    '₹${_amountController.text.isEmpty ? '0' : _amountController.text}',
                  ),
                  _buildSummaryRow('Tenure', '$_selectedTenure months'),
                  _buildSummaryRow('Annual Profit Rate', '${_profitRate}%'),
                  const Divider(height: 32),
                  _buildSummaryRow(
                    'Monthly Installment',
                    '₹${_monthlyInstallment.toStringAsFixed(2)}',
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.body2)),
        ],
      ),
    );
  }

  // Removed legacy loan type card implementation (replaced by ChoiceChip)

  // Removed legacy tenure card implementation (replaced by SegmentedButton)

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body1.copyWith(
              color: Colors.white,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(
              color: Colors.white,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
