import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/share_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class BuySharesScreen extends StatefulWidget {
  const BuySharesScreen({super.key});

  @override
  State<BuySharesScreen> createState() => _BuySharesScreenState();
}

class _BuySharesScreenState extends State<BuySharesScreen> {
  final _formKey = GlobalKey<FormState>();
  // final _amountController = TextEditingController();
  final _quantityController = TextEditingController();
  
  bool _buyByAmount = false; // true for amount, false for quantity
  int _calculatedShares = 0;
  double _calculatedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    // _amountController.addListener(_onAmountChanged);
    _quantityController.addListener(_onQuantityChanged);
    
    // Initialize share provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
  
    });
  }

  @override
  void dispose() {
    // _amountController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // void _onAmountChanged() {
  //   if (_buyByAmount && _amountController.text.isNotEmpty) {
  //     // final amount = double.tryParse(_amountController.text) ?? 0.0;
  //     final shareProvider = context.read<ShareProvider>();
  //     setState(() {
  //       _calculatedShares = shareProvider.calculateSharesFromAmount(amount);
  //       _calculatedAmount = amount;
  //     });
  //   }
  // }

  void _onQuantityChanged() {
    if (!_buyByAmount && _quantityController.text.isNotEmpty) {
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final shareProvider = context.read<ShareProvider>();
      setState(() {
        _calculatedAmount = shareProvider.calculateAmountFromShares(quantity);
        _calculatedShares = quantity;
      });
    }
  }

  void _switchBuyMode(bool byAmount) {
    setState(() {
      // _buyByAmount = byAmount;
      // _amountController.clear();
      _quantityController.clear();
      _calculatedShares = 0;
      _calculatedAmount = 0.0;
    });
  }

  Future<void> _buyShares() async {
    if (!_formKey.currentState!.validate()) return;

    final shareProvider = context.read<ShareProvider>();
    final userProvider = context.read<UserProvider>();
    bool success = false;

    if (_buyByAmount) {
      // final amount = double.parse(_amountController.text);
      // success = await shareProvider.buySharesByAmount(amount);
    } else {
      final quantity = int.parse(_quantityController.text);
      success = await shareProvider.buySharesByQuantity(quantity, userProvider.currentUser!.id);
    }

    if (success && mounted) {
      // Check if user now qualifies for membership
      if (shareProvider.qualifiesForMembership() && 
          userProvider.currentUser?.isMember != true) {
        // Update user to member
        final updatedUser = userProvider.currentUser!.copyWith(isMember: true);
        await userProvider.updateUser(updatedUser);
        
        // Show congratulations dialog
        _showCongratulationsDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully purchased $_calculatedShares share(s)!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(shareProvider.error ?? 'Purchase failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXL),
            Text(
              'Congratulations!',
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'You are now a JanSeva Member!',
              style: AppTextStyles.body1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              'Thank you for purchasing shares and becoming a valued member of our cooperative.',
              style: AppTextStyles.body2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingXL),
            CustomButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close buy shares screen
              },
              text: 'Continue',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Shares'),
        elevation: 0,
      ),
      body: Consumer2<ShareProvider, UserProvider>(
        builder: (context, shareProvider, userProvider, child) {
          final user = userProvider.currentUser;
          final isMember = user?.isMember ?? false;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Membership Banner
                  if (!isMember) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingXL),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF0EA5E9),
                            Color(0xFF0284C7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppSizes.paddingM),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                                ),
                                child: const Icon(
                                  Icons.workspace_premium,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: AppSizes.paddingL),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Become a Member',
                                      style: AppTextStyles.heading3.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Buy shares worth ₹1,000',
                                      style: AppTextStyles.body2.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.paddingL),
                          Container(
                            padding: const EdgeInsets.all(AppSizes.paddingM),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(AppSizes.radiusL),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Your Progress',
                                        style: AppTextStyles.caption.copyWith(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(height: AppSizes.paddingS),
                                      Text(
                                        '${shareProvider.totalSharesOwned}/${ShareProvider.SHARES_FOR_MEMBERSHIP} shares',
                                        style: AppTextStyles.heading3.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (shareProvider.sharesNeededForMembership > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.paddingM,
                                      vertical: AppSizes.paddingS,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                                    ),
                                    child: Text(
                                      '${shareProvider.sharesNeededForMembership} more',
                                      style: AppTextStyles.body2.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingM),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.radiusM),
                            child: LinearProgressIndicator(
                              value: shareProvider.totalSharesOwned / 
                                     ShareProvider.SHARES_FOR_MEMBERSHIP,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.sectionSpacing),
                  ],

                  // Share Information Card
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingXL),
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
                            Container(
                              padding: const EdgeInsets.all(AppSizes.paddingM),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                              ),
                              child: const Icon(
                                Icons.pie_chart,
                                color: AppColors.primary,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: AppSizes.paddingL),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shareProvider.availableShare.name,
                                    style: AppTextStyles.heading3,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    shareProvider.availableShare.description,
                                    style: AppTextStyles.body2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.paddingXL),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                'Price per Share',
                                shareProvider.formatCurrency(ShareProvider.SHARE_PRICE.toDouble()),
                                Icons.attach_money,
                              ),
                            ),
                            const SizedBox(width: AppSizes.paddingL),
                            Expanded(
                              child: _buildInfoItem(
                                'Your Shares',
                                '${shareProvider.totalSharesOwned}',
                                Icons.bar_chart,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.sectionSpacing),

                  // Buy Mode Toggle
                  Text(
                    'Purchase Method',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                    ),
                    child: Row(
                      children: [
                        // Expanded(
                        //   child: GestureDetector(
                        //     onTap: () => _switchBuyMode(true),
                        //     child: Container(
                        //       padding: const EdgeInsets.symmetric(
                        //         vertical: AppSizes.paddingL,
                        //       ),
                        //       decoration: BoxDecoration(
                        //         color: _buyByAmount
                        //             ? AppColors.primary
                        //             : Colors.transparent,
                        //         borderRadius: BorderRadius.circular(AppSizes.radiusL),
                        //       ),
                        //       child: Column(
                        //         children: [
                        //           Icon(
                        //             Icons.currency_rupee,
                        //             color: _buyByAmount
                        //                 ? Colors.white
                        //                 : AppColors.textSecondary,
                        //           ),
                        //           const SizedBox(height: AppSizes.paddingS),
                        //           Text(
                        //             'By Amount',
                        //             style: AppTextStyles.body2.copyWith(
                        //               color: _buyByAmount
                        //                   ? Colors.white
                        //                   : AppColors.textSecondary,
                        //               fontWeight: _buyByAmount
                        //                   ? FontWeight.w600
                        //                   : FontWeight.normal,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _switchBuyMode(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.paddingL,
                              ),
                              decoration: BoxDecoration(
                                color: !_buyByAmount
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(AppSizes.radiusL),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.numbers,
                                    color: !_buyByAmount
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(height: AppSizes.paddingS),
                                  Text(
                                    'By Quantity',
                                    style: AppTextStyles.body2.copyWith(
                                      color: !_buyByAmount
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                      fontWeight: !_buyByAmount
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingXL),

                  // Input Field
                  // if (_buyByAmount) ...[
                  //   Text(
                  //     'Enter Amount',
                  //     style: AppTextStyles.body1.copyWith(
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  //   const SizedBox(height: AppSizes.paddingM),
                  //   CustomTextField(
                  //     controller: _amountController,
                  //     labelText: 'Amount',
                  //     hintText: '₹0.00',
                  //     keyboardType: TextInputType.number,
                  //     inputFormatters: [
                  //       FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  //     ],
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Please enter an amount';
                  //       }
                  //       final amount = double.tryParse(value);
                  //       if (amount == null || amount <= 0) {
                  //         return 'Please enter a valid amount';
                  //       }
                  //       if (amount < ShareProvider.SHARE_PRICE) {
                  //         return 'Minimum amount is ₹${ShareProvider.SHARE_PRICE.toStringAsFixed(0)}';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                 
                  // ] else ...[
                    Text(
                      'Enter Quantity',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    CustomTextField(
                      controller: _quantityController,
                      labelText: 'Number of Shares',
                      hintText: '0',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        final quantity = int.tryParse(value);
                        if (quantity == null || quantity <= 0) {
                          return 'Please enter a valid quantity';
                        }
                        return null;
                      },
                    ),
                  

                  // Calculation Display
                  if (_calculatedShares > 0 || _calculatedAmount > 0) ...[
                    const SizedBox(height: AppSizes.paddingXL),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingL),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusL),
                        border: Border.all(
                          color: AppColors.info.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Number of Shares:',
                                style: AppTextStyles.body1,
                              ),
                              Text(
                                '$_calculatedShares',
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.paddingS),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount:',
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                shareProvider.formatCurrency(_calculatedAmount),
                                style: AppTextStyles.heading3.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSizes.padding2XL),

                  // Buy Button
                  CustomButton(
                    onPressed: shareProvider.isLoading
                        ? null
                        : _buyShares,
                    text: shareProvider.isLoading
                        ? 'Processing...'
                        : 'Buy Shares',
                    isLoading: shareProvider.isLoading,
                  ),

                  const SizedBox(height: AppSizes.paddingL),

                  // Quick Buy Options
                  if (!isMember) ...[
                    const Divider(),
                    const SizedBox(height: AppSizes.paddingL),
                    Text(
                      'Quick Options',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    Wrap(
                      spacing: AppSizes.paddingM,
                      runSpacing: AppSizes.paddingM,
                      children: [
                        if (shareProvider.sharesNeededForMembership > 0)
                          _buildQuickBuyChip(
                            'Complete Membership',
                            shareProvider.sharesNeededForMembership,
                            shareProvider.amountNeededForMembership,
                          ),
                        _buildQuickBuyChip('Buy 5 Shares', 5, 500.0),
                        _buildQuickBuyChip('Buy 10 Shares', 10, 1000.0),
                      ],
                    ),
                  ],

                  const SizedBox(height: AppSizes.paddingXL),

                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingL),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.3),
                      ),
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
                              'About Shares',
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        Text(
                          '• Each share costs ₹${ShareProvider.SHARE_PRICE.toStringAsFixed(0)}\n'
                          '• Members get exclusive benefits and voting rights\n'
                          '• Shares represent ownership in the cooperative',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Purchase History
                  if (shareProvider.purchases.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.sectionSpacing),
                    Text(
                      'Recent Purchases',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    ...shareProvider.getPurchaseHistory(limit: 3).map(
                          (purchase) => Container(
                            margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
                            padding: const EdgeInsets.all(AppSizes.paddingL),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(AppSizes.radiusL),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSizes.paddingS),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                                  ),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: AppColors.success,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.paddingM),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${purchase.quantity} Shares',
                                        style: AppTextStyles.body1.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        _formatDate(purchase.createdAt!),
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  shareProvider.formatCurrency(purchase.totalAmount!),
                                  style: AppTextStyles.body1.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            label,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickBuyChip(String label, int shares, double amount) {
    return ActionChip(
      label: Text(label),
      avatar: const Icon(Icons.flash_on, size: 18),
      onPressed: () {
        setState(() {
          _buyByAmount = false;
          _quantityController.text = shares.toString();
          _calculatedShares = shares;
          _calculatedAmount = amount;
        });
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
