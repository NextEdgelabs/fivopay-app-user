import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/bank_account.dart';
import '../providers/wallet_provider.dart';
import '../providers/user_provider.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  // Bank form controllers
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _ifscController = TextEditingController();
  
  List<BankAccount> _bankAccounts = [];
  BankAccount? _selectedBank;
  bool _isLoading = false;
  bool _showAddBankForm = false;
  String _selectedAccountType = 'savings';
  double _withdrawalFee = 0.0;
  double _totalDeduction = 0.0;

  @override
  void initState() {
    super.initState();
    _loadBankAccounts();
    _amountController.addListener(_calculateFees);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  Future<void> _loadBankAccounts() async {
    try {
      final userProvider = context.read<UserProvider>();
      final userId = userProvider.currentUser?.id;
      if (userId != null) {
        final bankData = await SfService.getJson('bank_accounts_$userId');
        if (bankData != null) {
          final List<dynamic> bankList = bankData['accounts'] ?? [];
          setState(() {
            _bankAccounts = bankList
                .map((json) => BankAccount.fromJson(json))
                .toList();
            
            // Select default bank if available
            _selectedBank = _bankAccounts.where((bank) => bank.isDefault).isNotEmpty
                ? _bankAccounts.firstWhere((bank) => bank.isDefault)
                : (_bankAccounts.isNotEmpty ? _bankAccounts.first : null);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bank accounts: $e')),
      );
    }
  }

  Future<void> _saveBankAccounts() async {
    try {
      final userProvider = context.read<UserProvider>();
      final userId = userProvider.currentUser?.id;
      if (userId != null) {
        final bankData = {
          'accounts': _bankAccounts.map((bank) => bank.toJson()).toList(),
        };
        await SfService.saveJson('bank_accounts_$userId', bankData);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save bank accounts: $e')),
      );
    }
  }

  void _calculateFees() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      // Calculate withdrawal fee (example: 0.5% or minimum ₹5, max ₹50)
      _withdrawalFee = amount * 0.005;
      if (_withdrawalFee < 5.0) _withdrawalFee = 5.0;
      if (_withdrawalFee > 50.0) _withdrawalFee = 50.0;
      if (amount == 0) _withdrawalFee = 0.0;
      
      // _totalDeduction = amount + _withdrawalFee;
      setState(() {
        _totalDeduction = amount + _withdrawalFee;
      });
    });
  }

  Future<void> _addBankAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final newBank = BankAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bankName: _bankNameController.text.trim(),
      accountNumber: _accountNumberController.text.trim(),
      accountHolderName: _accountHolderController.text.trim(),
      ifscCode: _ifscController.text.trim().toUpperCase(),
      accountType: _selectedAccountType,
      isDefault: _bankAccounts.isEmpty,
      addedAt: DateTime.now(),
    );

    setState(() {
      _bankAccounts.add(newBank);
      _selectedBank = newBank;
      _showAddBankForm = false;
    });

    await _saveBankAccounts();

    // Clear form
    _bankNameController.clear();
    _accountNumberController.clear();
    _accountHolderController.clear();
    _ifscController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bank account added successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _withdrawMoney() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bank account')),
      );
      return;
    }

    final walletProvider = context.read<WalletProvider>();

    if (!walletProvider.canWithdraw(_totalDeduction)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insufficient balance. Required: ${walletProvider.formatCurrency(_totalDeduction)}'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await walletProvider.withdrawMoney(
        amount: _totalDeduction,
        description: 'Withdrawal to ${_selectedBank!.bankName} (${_selectedBank!.maskedAccountNumber})',
        toAccount: _selectedBank!.accountNumber,
        referenceNumber: 'WTH${DateTime.now().millisecondsSinceEpoch}',
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Withdrawal request submitted successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(walletProvider.error ?? 'Withdrawal failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Money'),
        elevation: 0,
      ),
      body: Consumer<WalletProvider>(
        builder: (context, walletProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.paddingL),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Balance',
                          style: AppTextStyles.body2.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingS),
                        Text(
                          walletProvider.balanceDisplay,
                          style: AppTextStyles.heading1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingXL),

                  // Amount Section
                  Text(
                    'Withdrawal Amount',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  
                  CustomTextField(
                    controller: _amountController,
                    labelText: 'Enter Amount',
                    hintText: '₹0.00',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Please enter valid amount';
                      }
                      if (amount < 100) {
                        return 'Minimum withdrawal amount is ₹100';
                      }
                      if (amount > 50000) {
                        return 'Maximum withdrawal amount is ₹50,000';
                      }
                      return null;
                    },
                  ),

                  if (_withdrawalFee > 0) ...[
                    const SizedBox(height: AppSizes.paddingM),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusL),
                        border: Border.all(color: AppColors.info.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Withdrawal Amount:', style: AppTextStyles.body2),
                              Text(walletProvider.formatCurrency(double.parse(_amountController.text))),
                            ],
                          ),
                          const SizedBox(height: AppSizes.paddingS),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Processing Fee:', style: AppTextStyles.body2),
                              Text(walletProvider.formatCurrency(_withdrawalFee)),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Deduction:', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
                              Text(
                                walletProvider.formatCurrency(_totalDeduction),
                                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSizes.paddingXL),

                  // Bank Selection Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Bank Account',
                        style: AppTextStyles.heading3,
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _showAddBankForm = !_showAddBankForm;
                          });
                        },
                        icon: Icon(_showAddBankForm ? Icons.close : Icons.add),
                        label: Text(_showAddBankForm ? 'Cancel' : 'Add Bank'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingM),

                  // Add Bank Form
                  if (_showAddBankForm) ...[
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
                          Text(
                            'Add New Bank Account',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: AppSizes.paddingL),

                          CustomTextField(
                            controller: _bankNameController,
                            labelText: 'Bank Name',
                            hintText: 'e.g., State Bank of India',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter bank name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSizes.paddingM),

                          CustomTextField(
                            controller: _accountHolderController,
                            labelText: 'Account Holder Name',
                            hintText: 'As per bank records',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter account holder name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSizes.paddingM),

                          CustomTextField(
                            controller: _accountNumberController,
                            labelText: 'Account Number',
                            hintText: 'Enter account number',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter account number';
                              }
                              if (value.length < 9 || value.length > 18) {
                                return 'Invalid account number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSizes.paddingM),

                          CustomTextField(
                            controller: _ifscController,
                            labelText: 'IFSC Code',
                            hintText: 'e.g., SBIN0001234',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                              LengthLimitingTextInputFormatter(11),
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter IFSC code';
                              }
                              if (value.length != 11) {
                                return 'IFSC code must be 11 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSizes.paddingM),

                          // Account Type Selection
                          Text(
                            'Account Type',
                            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: AppSizes.paddingS),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Savings'),
                                  value: 'savings',
                                  groupValue: _selectedAccountType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAccountType = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Current'),
                                  value: 'current',
                                  groupValue: _selectedAccountType,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAccountType = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSizes.paddingL),
                          CustomButton(
                            onPressed: _addBankAccount,
                            text: 'Add Bank Account',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                  ],

                  // Bank Accounts List
                  if (_bankAccounts.isNotEmpty) ...[
                    ...(_bankAccounts.map((bank) => Container(
                      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
                      child: RadioListTile<BankAccount>(
                        value: bank,
                        groupValue: _selectedBank,
                        onChanged: (value) {
                          setState(() {
                            _selectedBank = value;
                          });
                        },
                        title: Text(
                          bank.bankName,
                          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${bank.accountHolderName}'),
                            Text('${bank.maskedAccountNumber} • ${bank.accountType.toUpperCase()}'),
                            Text('IFSC: ${bank.ifscCode}'),
                          ],
                        ),
                        secondary: bank.isDefault
                            ? const Icon(Icons.star, color: AppColors.warning)
                            : null,
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding: const EdgeInsets.all(AppSizes.paddingM),
                        tileColor: _selectedBank == bank
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.cardBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                          side: BorderSide(
                            color: _selectedBank == bank
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                      ),
                    ))),
                  ] else if (!_showAddBankForm) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingXL),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.account_balance,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: AppSizes.paddingM),
                          Text(
                            'No Bank Accounts Added',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: AppSizes.paddingS),
                          Text(
                            'Add a bank account to withdraw money',
                            style: AppTextStyles.body2,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSizes.paddingL),
                          CustomButton(
                            onPressed: () {
                              setState(() {
                                _showAddBankForm = true;
                              });
                            },
                            text: 'Add Bank Account',
                            variant: ButtonVariant.outlined,
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSizes.paddingXL),

                  // Optional Note
                  CustomTextField(
                    controller: _noteController,
                    labelText: 'Note (Optional)',
                    hintText: 'Add a note for this withdrawal',
                    maxLines: 3,
                  ),

                  const SizedBox(height: AppSizes.padding2XL),

                  // Withdraw Button
                  CustomButton(
                    onPressed: _isLoading || _selectedBank == null || _amountController.text.isEmpty
                        ? null
                        : _withdrawMoney,
                    text: _isLoading ? 'Processing...' : 'Withdraw Money',
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: AppSizes.paddingL),

                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingL),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                      border: Border.all(color: AppColors.info.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.info,
                              size: 20,
                            ),
                            const SizedBox(width: AppSizes.paddingS),
                            Text(
                              'Withdrawal Information',
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        Text(
                          '• Withdrawals are processed within 1-2 business days\n'
                          '• Minimum withdrawal: ₹100\n'
                          '• Maximum withdrawal: ₹50,000 per day\n'
                          '• Processing fee applies for all withdrawals\n'
                          '• Ensure bank details are correct before submitting',
                          style: AppTextStyles.body2.copyWith(color: AppColors.info),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}