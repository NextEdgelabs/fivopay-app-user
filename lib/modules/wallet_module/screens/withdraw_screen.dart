import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:janseva/modules/buyShares/widgets/info_section.dart';
import 'package:janseva/utils/theme_extension.dart';

import 'package:provider/provider.dart';
import '../models/withdrawl_params.dart';
import '../provider/wallet_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  // Mode Selection
  String _withdrawalMode = 'Bank Transfer'; // 'Bank Transfer' or 'UPI'
  String _bankTransferType = 'IMPS'; // 'IMPS', 'NEFT', 'RTGS'

  // Bank form controllers
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _ifscController = TextEditingController();

  // UPI form controller
  final _upiController = TextEditingController();

  bool _isLoading = false;
  double _withdrawalFee = 0.0;
  double _totalDeduction = 0.0;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_calculateFees);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    _ifscController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  void _calculateFees() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      // Calculate withdrawal fee (example: 0.5% or minimum ₹5, max ₹50)
      _withdrawalFee = amount * 0.005;
      if (_withdrawalFee < 5.0) _withdrawalFee = 5.0;
      if (_withdrawalFee > 50.0) _withdrawalFee = 50.0;
      if (amount == 0) _withdrawalFee = 0.0;

      _totalDeduction = amount + _withdrawalFee;
    });
  }

  Future<void> _withdrawMoney() async {
    if (!_formKey.currentState!.validate()) return;

    final walletProvider = context.read<WalletProvider>();

    if (!walletProvider.canWithdraw(_totalDeduction)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Insufficient balance. Required: ${walletProvider.formatCurrency(_totalDeduction)}',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final String mode = _withdrawalMode == 'UPI' ? 'UPI' : _bankTransferType;
      final params = WithdrawalParams(
        amount: double.parse(_amountController.text),
        mode: mode,
        vpa: _withdrawalMode == 'UPI' ? _upiController.text.trim() : null,
        accountNumber: _withdrawalMode == 'Bank Transfer'
            ? _accountNumberController.text.trim()
            : null,
        ifsc: _withdrawalMode == 'Bank Transfer'
            ? _ifscController.text.trim().toUpperCase()
            : null,
        bankAccountName: _withdrawalMode == 'Bank Transfer'
            ? _accountHolderController.text.trim()
            : null,
      );

      final success = await walletProvider.withdrawMoney(params);

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
      appBar: AppBar(title: const Text('Withdraw Money'), elevation: 0),
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
                      gradient: LinearGradient(
                        colors: [
                          context.colors.gradientOne,
                          context.colors.gradientTwo,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
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
                  Text('Withdrawal Amount', style: AppTextStyles.body1),
                  const SizedBox(height: AppSizes.paddingM),

                  CustomTextField(
                    controller: _amountController,
                    labelText: 'Enter Amount',
                    hintText: '₹0.00',
                    keyboardType: TextInputType.number,

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
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
                        color: context.colors.brandColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                        border: Border.all(
                          color: context.colors.gradientOne.withOpacity(0.6),
                          width: 1,
                        ),

                        // color: context.colors.gradientTwo.withOpacity(0.1),
                        // gradient: LinearGradient(
                        //   colors: [
                        //     // context.colors.gradientOne.withOpacity(0.1),

                        //   ],
                        //   begin: Alignment.topLeft,
                        //   end: Alignment.bottomRight,
                        // ),
                        // color: AppColors.info.withOpacity(0.1),
                        // borderRadius: BorderRadius.circular(AppSizes.radiusL),
                        // border: Border.all(
                        //   color: context.colors.gradientOne.withOpacity(0.3),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Withdrawal Amount:',
                                style: AppTextStyles.body2.copyWith(
                                  color: context.colors.brandColor,
                                ),
                              ),
                              Text(
                                walletProvider.formatCurrency(
                                  double.parse(_amountController.text),
                                ),
                                style: AppTextStyles.body2.copyWith(
                                  color: context.colors.brandColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.paddingXS),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Processing Fee:',
                                style: AppTextStyles.body2.copyWith(
                                  color: context.colors.brandColor,
                                ),
                              ),
                              Text(
                                walletProvider.formatCurrency(_withdrawalFee),
                                style: AppTextStyles.body2.copyWith(
                                  color: context.colors.brandColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.paddingXS),
                          Divider(
                            height: 2,
                            color: context.colors.brandColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: AppSizes.paddingXS),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Deduction:',
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.brandColor,
                                ),
                              ),
                              Text(
                                walletProvider.formatCurrency(_totalDeduction),
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.brandColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSizes.paddingXL),

                  // Mode Selection
                  Text('Withdrawal Mode', style: AppTextStyles.body1),
                  const SizedBox(height: AppSizes.paddingM),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text(
                            'Bank Transfer',
                            style: AppTextStyles.body2,
                          ),
                          value: 'Bank Transfer',
                          groupValue: _withdrawalMode,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              _withdrawalMode = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('UPI', style: AppTextStyles.body2),
                          value: 'UPI',
                          groupValue: _withdrawalMode,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (value) {
                            setState(() {
                              _withdrawalMode = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.paddingM),

                  if (_withdrawalMode == 'UPI') ...[
                    CustomTextField(
                      controller: _upiController,
                      labelText: 'UPI ID / VPA',
                      hintText: 'e.g., username@upi',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter UPI ID';
                        }
                        if (!value.contains('@')) {
                          return 'Invalid UPI ID format';
                        }
                        return null;
                      },
                    ),
                  ] else ...[
                    // Bank Transfer Fields
                    CustomTextField(
                      controller: _accountNumberController,
                      labelText: 'Account Number',
                      hintText: 'Enter account number',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter account number';
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
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-z0-9]'),
                        ),
                        LengthLimitingTextInputFormatter(11),
                        UpperCaseTextFormatter(),
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

                    // Transfer Type (IMPS / NEFT / RTGS)
                    Text('Transfer Type', style: AppTextStyles.body1),
                    const SizedBox(height: AppSizes.paddingS),
                    Wrap(
                      spacing: AppSizes.paddingS,
                      children: ['IMPS', 'NEFT', 'RTGS'].map((type) {
                        final isSelected = _bankTransferType == type;
                        return ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _bankTransferType = type;
                              });
                            }
                          },
                          selectedColor: context.colors.brandColor.withOpacity(
                            0.2,
                          ),
                          labelStyle: AppTextStyles.body2.copyWith(
                            color: isSelected
                                ? context.colors.brandColor
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        );
                      }).toList(),
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
                    onPressed: _isLoading || _amountController.text.isEmpty
                        ? null
                        : _withdrawMoney,
                    text: _isLoading ? 'Processing...' : 'Withdraw Money',
                    isLoading: _isLoading,
                    backgroundColor: context.colors.gradientTwo,
                    disabledColor: context.colors.gradientTwo.withOpacity(0.5),
                  ),

                  const SizedBox(height: AppSizes.paddingL),

                  // Info Card
                  InfoSection(
                    title: 'Withdrawal Information',
                    points: [
                      'Withdrawals are processed within 1-2 business days',

                      'Minimum withdrawal: ₹100'
                          'Maximum withdrawal: ₹50,000 per day'
                          'Processing fee applies for all withdrawals'
                          'Ensure bank details are correct before submitting',
                    ],
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
