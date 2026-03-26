import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../providers/share_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../widgets/membership_progress_card.dart';
import '../widgets/share_info_card.dart';
import '../widgets/purchase_method_button.dart';
import '../widgets/quick_option_button.dart';
import '../widgets/info_section.dart';

class BuySharesScreen extends StatefulWidget {
  const BuySharesScreen({super.key});

  @override
  State<BuySharesScreen> createState() => _BuySharesScreenState();
}

class _BuySharesScreenState extends State<BuySharesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();

  bool _buyByAmount = false;
  int _calculatedShares = 0;
  double _calculatedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(_onQuantityChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

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
      // Not implemented
    } else {
      final quantity = int.parse(_quantityController.text);
      success = await shareProvider.buySharesByQuantity(
        quantity,
        userProvider.currentUser!.id,
      );
    }

    if (success && mounted) {
      if (shareProvider.qualifiesForMembership() &&
          userProvider.currentUser?.isMember != true) {
        final updatedUser = userProvider.currentUser!.copyWith(isMember: true);
        await userProvider.updateUser(updatedUser);
        _showCongratulationsDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully purchased $_calculatedShares share(s)!',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        // Navigator.pop(context);
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
                Navigator.pop(context);
                // Navigator.pop(context);
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
      // backgroundColor: context.co,
      // appBar: AppBar(
      //   title: const Text(
      //     'Buy Shares',
      //     style: TextStyle(
      //       color: AppColors.textPrimary,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: AppColors.textPrimary),
      // ),
      body: Consumer2<ShareProvider, UserProvider>(
        builder: (context, shareProvider, userProvider, child) {
          final user = userProvider.currentUser;
          final isMember = user?.isMember ?? false;

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.paddingL),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Membership Progress Card
                  if (!isMember)
                    MembershipProgressCard(
                      currentShares: shareProvider.totalSharesOwned,
                      targetShares: ShareProvider.SHARES_FOR_MEMBERSHIP,
                    ),

                  SizedBox(height: AppSizes.paddingXL),

                  // Share Information Card
                  ShareInfoCard(
                    title: shareProvider.availableShare.name,
                    description: shareProvider.availableShare.description,
                    pricePerShare:
                        '₹ ${ShareProvider.SHARE_PRICE.toStringAsFixed(0)}',
                    yourShares: '${shareProvider.totalSharesOwned}',
                  ),

                  // SizedBox(height: AppSizes.paddingXL),

                  // // Purchase Method Section
                  // Text(
                  //   'Purchase Method',
                  //   style: AppTextStyles.heading3.copyWith(
                  //     fontWeight: FontWeight.w600,
                  //     fontSize: 16,
                  //   ),
                  // ),
                  // SizedBox(height: AppSizes.paddingL),

                  // PurchaseMethodButton(
                  //   label: 'By Quantity',
                  //   icon: Iconsax.hashtag,
                  //   isSelected: true,
                  //   onTap: () {},
                  // ),
                  SizedBox(height: AppSizes.paddingXL),

                  // Enter Quantity Section
                  Text(
                    'Enter Quantity',
                    style: AppTextStyles.heading3.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: AppSizes.paddingL),

                  CustomTextField(
                    controller: _quantityController,
                    labelText: 'Number of shares',
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

                  SizedBox(height: AppSizes.paddingXL),

                  // Buy Shares Button
                  PurchaseMethodButton(
                    isloading: shareProvider.isLoading,
                    label: 'Buy Shares',
                    // icon: Iconsax.hashtag,
                    isSelected: true,
                    onTap: _buyShares,
                  ),

                  // SizedBox(
                  //   width: AppSizes.dW,
                  //   height: AppSizes.buttonHeight,
                  //   child: ElevatedButton(
                  //     onPressed: shareProvider.isLoading ? null : _buyShares,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFF7C3AED),
                  //       foregroundColor: Colors.white,
                  //       elevation: 0,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(
                  //           AppSizes.radiusXL,
                  //         ),
                  //       ),
                  //       padding: EdgeInsets.symmetric(
                  //         vertical: AppSizes.paddingL,
                  //       ),
                  //     ),
                  //     child: shareProvider.isLoading
                  //         ? const SizedBox(
                  //             height: 20,
                  //             width: 20,
                  //             child: CircularProgressIndicator(
                  //               strokeWidth: 2,
                  //               valueColor: AlwaysStoppedAnimation<Color>(
                  //                 Colors.white,
                  //               ),
                  //             ),
                  //           )
                  //         : Text(
                  //             'Buy Shares',
                  //             style: AppTextStyles.button.copyWith(
                  //               fontSize: 16,
                  //             ),
                  //           ),
                  //   ),
                  // ),
                  SizedBox(height: AppSizes.paddingXL),

                  // Quick Options Section
                  if (!isMember) ...[
                    Text(
                      'Quick Options',
                      style: AppTextStyles.heading3.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: AppSizes.paddingL),
                    Row(
                      children: [
                        Expanded(
                          child: QuickOptionButton(
                            label: 'Buy 5 shares',
                            onTap: () {
                              setState(() {
                                _buyByAmount = false;
                                _quantityController.text = '5';
                                _calculatedShares = 5;
                                _calculatedAmount = 500.0;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: AppSizes.paddingM),
                        Expanded(
                          child: QuickOptionButton(
                            label: 'Buy 10 shares',
                            onTap: () {
                              setState(() {
                                _buyByAmount = false;
                                _quantityController.text = '10';
                                _calculatedShares = 10;
                                _calculatedAmount = 1000.0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.paddingXL),
                  ],

                  // Info Section
                  InfoSection(
                    points: [
                      'Each share cost ₹ ${ShareProvider.SHARE_PRICE.toStringAsFixed(0)}',
                      'Members get exclusive benefits and voting rights',
                      'Shares represent ownership in the cooperative',
                    ],
                  ),

                  SizedBox(height: AppSizes.paddingXL),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
