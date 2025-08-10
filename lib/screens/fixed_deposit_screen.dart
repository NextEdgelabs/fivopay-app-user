import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fixed_deposit.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class FixedDepositScreen extends StatefulWidget {
  const FixedDepositScreen({super.key});

  @override
  State<FixedDepositScreen> createState() => _FixedDepositScreenState();
}

class _FixedDepositScreenState extends State<FixedDepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _tenureController = TextEditingController();
  final _addressController = TextEditingController();
  final _branchController = TextEditingController();
  bool _isLoading = false;
  int _selectedTenure = 12; // Default 12 months
  double _profitRate = 7.5; // Default 7.5% annual rate
  double _expectedProfit = 0;
  double _totalAmount = 0;
  String _selectedDepositMethod = 'online'; // online, cash_collection, branch
  DateTime? _selectedCollectionDate;

  @override
  void initState() {
    super.initState();
    _calculateProfit();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _tenureController.dispose();
    _addressController.dispose();
    _branchController.dispose();
    super.dispose();
  }

  void _calculateProfit() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final tenure = _selectedTenure;

    // Ethical banking profit calculation (no interest, profit sharing)
    final annualProfit = amount * (_profitRate / 100);
    final tenureProfit = annualProfit * (tenure / 12);

    setState(() {
      _expectedProfit = tenureProfit;
      _totalAmount = amount + tenureProfit;
    });
  }

  Future<void> _createFixedDeposit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid amount'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // Validate collection date for cash collection
    if (_selectedDepositMethod == 'cash_collection' &&
        _selectedCollectionDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a collection date'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    String? errorMsg;

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;

      if (currentUser != null) {
        final newFd = FixedDeposit(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          accountNumber: currentUser.accountNumber ?? '',
          amount: amount,
          tenureMonths: _selectedTenure,
          profitRate: _profitRate,
          startDate: DateTime.now(),
          maturityDate: DateTime.now().add(
            Duration(days: _selectedTenure * 30),
          ),
          status: 'active',
          expectedProfit: _expectedProfit,
          totalAmount: _totalAmount,
          notes: 'Fixed Deposit',
          depositMethod: _selectedDepositMethod,
          collectionAddress: _selectedDepositMethod == 'cash_collection'
              ? _addressController.text.trim()
              : null,
          collectionDate: _selectedDepositMethod == 'cash_collection'
              ? _selectedCollectionDate
              : null,
          branchName: _selectedDepositMethod == 'branch'
              ? _branchController.text.trim()
              : null,
        );

        final List<FixedDeposit> updatedFds = [
          ...(currentUser.fixedDeposits ?? []),
          newFd,
        ];

        final updatedUser = currentUser.copyWith(
          fixedDeposits: updatedFds,
          totalDeposits: (currentUser.totalDeposits ?? 0) + amount,
        );

        await userProvider.updateUser(updatedUser);

        if (mounted) {
          // Show success dialog with FD details
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.success,
                      size: 64,
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                    Text(
                      'FD Created Successfully!',
                      style: AppTextStyles.heading2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            'Amount',
                            '₹${amount.toStringAsFixed(2)}',
                          ),
                          _buildSummaryRow('Tenure', '$_selectedTenure months'),
                          _buildSummaryRow(
                            'Expected Return',
                            '₹${_expectedProfit.toStringAsFixed(2)}',
                          ),
                          _buildSummaryRow(
                            'Deposit Method',
                            _selectedDepositMethod == 'online'
                                ? 'Online Transfer'
                                : _selectedDepositMethod == 'cash_collection'
                                ? 'Cash Collection'
                                : 'Branch Deposit',
                          ),
                          if (_selectedDepositMethod == 'cash_collection' &&
                              _selectedCollectionDate != null)
                            _buildSummaryRow(
                              'Collection Date',
                              '${_selectedCollectionDate!.day}/${_selectedCollectionDate!.month}/${_selectedCollectionDate!.year}',
                            ),
                          if (_selectedDepositMethod == 'branch' &&
                              _branchController.text.isNotEmpty)
                            _buildSummaryRow('Branch', _branchController.text),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                    if (_selectedDepositMethod == 'online')
                      Text(
                        'Please transfer the amount to the bank account details sent to your registered mobile number.',
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
                      ),
                    if (_selectedDepositMethod == 'cash_collection')
                      Text(
                        'Our agent will visit your address on the scheduled date for cash collection.',
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
                      ),
                    if (_selectedDepositMethod == 'branch')
                      Text(
                        'Please visit the branch with your ID proof to complete the deposit.',
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back to previous screen
                    },
                    child: Text(
                      'Done',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      errorMsg = e.toString();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        if (errorMsg != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create Fixed Deposit: $errorMsg'),
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
        title: const Text('Fixed Deposit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Card
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: AppSizes.paddingS),
                          Text('Fixed Deposit', style: AppTextStyles.heading3),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      Text(
                        'This fixed deposit uses profit sharing. No interest, only profit distribution.',
                        style: AppTextStyles.body2,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Amount Input
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Deposit Amount', style: AppTextStyles.heading3),
                      const SizedBox(height: AppSizes.paddingM),
                      CustomTextField(
                        controller: _amountController,
                        labelText: 'Amount (₹)',
                        hintText: 'Enter amount',
                        prefixIcon: Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _calculateProfit(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount';
                          }
                          if (amount < 1000) {
                            return 'Minimum amount is ₹1,000';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Tenure Selection
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Tenure', style: AppTextStyles.heading3),
                      const SizedBox(height: AppSizes.paddingM),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment<int>(value: 6, label: Text('6m')),
                          ButtonSegment<int>(value: 12, label: Text('12m')),
                          ButtonSegment<int>(value: 24, label: Text('24m')),
                          ButtonSegment<int>(value: 36, label: Text('36m')),
                          ButtonSegment<int>(value: 60, label: Text('60m')),
                        ],
                        selected: {_selectedTenure},
                        showSelectedIcon: false,
                        onSelectionChanged: (selection) {
                          final int newValue = selection.first;
                          setState(() => _selectedTenure = newValue);
                          _calculateProfit();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Deposit Method Selection
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Deposit Method', style: AppTextStyles.heading3),
                      const SizedBox(height: AppSizes.paddingM),

                      // Online Deposit Option
                      _buildDepositMethodCard(
                        'Online Deposit',
                        'Transfer money directly from your bank',
                        Icons.phone_android,
                        'online',
                      ),
                      const SizedBox(height: AppSizes.paddingM),

                      // Cash Collection Option
                      _buildDepositMethodCard(
                        'Cash Collection',
                        'Our agent will collect cash from your location',
                        Icons.directions_car,
                        'cash_collection',
                      ),
                      const SizedBox(height: AppSizes.paddingM),

                      // Branch Deposit Option
                      _buildDepositMethodCard(
                        'Branch Deposit',
                        'Visit our branch to deposit in person',
                        Icons.store,
                        'branch',
                      ),

                      // Additional fields based on selection
                      if (_selectedDepositMethod == 'cash_collection') ...[
                        const SizedBox(height: AppSizes.paddingL),
                        CustomTextField(
                          controller: _addressController,
                          labelText: 'Collection Address',
                          hintText:
                              'Enter complete address for cash collection',
                          prefixIcon: Icons.location_on,
                          maxLines: 2,
                          validator: (value) {
                            if (_selectedDepositMethod == 'cash_collection' &&
                                (value == null || value.isEmpty)) {
                              return 'Please enter collection address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().add(
                                const Duration(days: 1),
                              ),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 7),
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedCollectionDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(AppSizes.paddingM),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusM,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: AppColors.textLight,
                                ),
                                const SizedBox(width: AppSizes.paddingM),
                                Text(
                                  _selectedCollectionDate == null
                                      ? 'Select Collection Date'
                                      : 'Collection Date: ${_selectedCollectionDate!.day}/${_selectedCollectionDate!.month}/${_selectedCollectionDate!.year}',
                                  style: AppTextStyles.body1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      if (_selectedDepositMethod == 'branch') ...[
                        const SizedBox(height: AppSizes.paddingL),
                        CustomTextField(
                          controller: _branchController,
                          labelText: 'Preferred Branch',
                          hintText: 'Enter branch name or location',
                          prefixIcon: Icons.store,
                          validator: (value) {
                            if (_selectedDepositMethod == 'branch' &&
                                (value == null || value.isEmpty)) {
                              return 'Please enter branch name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Profit Calculation
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.success, AppColors.successLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profit Calculation',
                        style: AppTextStyles.heading3.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      _buildCalculationRow(
                        'Principal Amount',
                        '₹${_amountController.text.isEmpty ? '0' : _amountController.text}',
                      ),
                      _buildCalculationRow('Tenure', '$_selectedTenure months'),
                      _buildCalculationRow(
                        'Annual Profit Rate',
                        '${_profitRate}%',
                      ),
                      const Divider(color: Colors.white54, height: 32),
                      _buildCalculationRow(
                        'Expected Profit',
                        '₹${_expectedProfit.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                      _buildCalculationRow(
                        'Total Amount',
                        '₹${_totalAmount.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.paddingL),

                // Create Button
                CustomButton(
                  onPressed: _isLoading ? null : _createFixedDeposit,
                  text: _isLoading ? 'Creating...' : 'Create Fixed Deposit',
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Removed legacy tenure card in favor of SegmentedButton

  Widget _buildDepositMethodCard(
    String title,
    String subtitle,
    IconData icon,
    String method,
  ) {
    final isSelected = _selectedDepositMethod == method;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDepositMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textLight,
              size: 24,
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(
            value,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationRow(
    String label,
    String value, {
    bool isBold = false,
  }) {
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
