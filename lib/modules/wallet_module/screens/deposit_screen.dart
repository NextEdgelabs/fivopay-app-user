import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../../../utils/constants.dart';
import '../provider/wallet_provider.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  bool _submitted = false;
  String? _lastPaymentStatus;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _checkPaymentStatus(WalletProvider wallet) {
    // Check if payment status changed
    if (wallet.paymentStatus != null &&
        wallet.paymentStatus != _lastPaymentStatus) {
      _lastPaymentStatus = wallet.paymentStatus;

      if (wallet.paymentStatus == 'success') {
        _showPaymentSuccess();
      } else if (wallet.paymentStatus == 'failed') {
        _showPaymentFailed(wallet.error ?? 'Payment failed');
      }
    }
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _submitted = false;
      });
      return;
    }

    final amount =
        double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
    final walletProvider = context.read<WalletProvider>();

    // Clear previous payment status
    walletProvider.clearPaymentStatus();

    await walletProvider.addMoney(amount: amount);

    setState(() {
      _submitted = false;
    });
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        ),
        title: Row(
          children: [
            Icon(
              Iconsax.tick_circle,
              color: AppColors.success,
              size: AppSizes.iconSizeL,
            ),
            SizedBox(width: AppSizes.paddingS),
            Text('Payment Success', style: AppTextStyles.heading3),
          ],
        ),
        content: Text(
          'Your payment was successful! Amount has been added to your wallet.',
          style: AppTextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<WalletProvider>().clearPaymentStatus();
              Navigator.of(context).pop(); // Close dialog
              pushAndRemoveUntil(NamedRoutes.dashboard);
              // Navigator.of(context).pop(); // Pop deposit screen
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colors.brandColor,
            ),
            child: Text(
              'OK',
              style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentFailed(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        ),
        title: Row(
          children: [
            Icon(
              Iconsax.close_circle,
              color: AppColors.error,
              size: AppSizes.iconSizeL,
            ),
            SizedBox(width: AppSizes.paddingS),
            Text('Payment Failed', style: AppTextStyles.heading3),
          ],
        ),
        content: Text(message, style: AppTextStyles.body1),
        actions: [
          TextButton(
            onPressed: () {
              context.read<WalletProvider>().clearPaymentStatus();
              Navigator.of(context).pop(); // Close dialog
              // Navigator.of(context).pop(); // Pop deposit screen
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(
              'OK',
              style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String? _amountValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter amount';
    final parsed = double.tryParse(value.replaceAll(',', ''));
    if (parsed == null) return 'Enter a valid number';
    if (parsed <= 0) return 'Amount must be greater than zero';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: context.colors.brandColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Money',
          style: AppTextStyles.heading2.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<WalletProvider>(
          builder: (context, wallet, child) {
            // Check payment status on each rebuild
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _checkPaymentStatus(wallet);
            });

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.all(AppSizes.paddingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Balance Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppSizes.paddingL),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                context.colors.gradientOne,
                                context.colors.gradientTwo,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusXL,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: context.colors.brandColor.withAlpha(76),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(AppSizes.paddingS),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(51),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusM,
                                      ),
                                    ),
                                    child: Icon(
                                      Iconsax.wallet_2,
                                      color: Colors.white,
                                      size: AppSizes.iconSizeM,
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.paddingM),
                                  Text(
                                    'Current Balance',
                                    style: AppTextStyles.body1.copyWith(
                                      color: Colors.white.withAlpha(230),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSizes.paddingM),
                              Text(
                                '₹${wallet.balance.toStringAsFixed(2)}',
                                style: AppTextStyles.heading1.copyWith(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingXL),

                        // Amount Input Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppSizes.paddingL),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusXL,
                            ),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowLight,
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter Amount',
                                style: AppTextStyles.heading3,
                              ),
                              SizedBox(height: AppSizes.paddingM),
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: _amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  style: AppTextStyles.body1,
                                  decoration: InputDecoration(
                                    labelText: 'Amount',
                                    labelStyle: AppTextStyles.body2,
                                    prefixText: '₹ ',
                                    prefixStyle: AppTextStyles.body1.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    prefixIcon: Icon(
                                      Iconsax.money,
                                      color: AppColors.textSecondary,
                                      size: AppSizes.iconSizeM,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusL,
                                      ),
                                      borderSide: const BorderSide(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusL,
                                      ),
                                      borderSide: const BorderSide(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusL,
                                      ),
                                      borderSide: BorderSide(
                                        color: context.colors.brandColor,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusL,
                                      ),
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: AppColors.surface,
                                  ),
                                  validator: _amountValidator,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingL),

                        // Error Message
                        if (wallet.error != null)
                          Container(
                            padding: EdgeInsets.all(AppSizes.paddingM),
                            decoration: BoxDecoration(
                              color: AppColors.error.withAlpha(26),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusL,
                              ),
                              border: Border.all(
                                color: AppColors.error.withAlpha(51),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.info_circle,
                                  color: AppColors.error,
                                  size: AppSizes.iconSizeM,
                                ),
                                SizedBox(width: AppSizes.paddingS),
                                Expanded(
                                  child: Text(
                                    wallet.error!,
                                    style: AppTextStyles.body2.copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Iconsax.close_circle,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () {
                                    wallet.clearError();
                                  },
                                ),
                              ],
                            ),
                          ),
                        if (wallet.error != null)
                          SizedBox(height: AppSizes.paddingL),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(AppSizes.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeight,
                    child: ElevatedButton(
                      onPressed: wallet.isProcessing || _submitted
                          ? null
                          : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.brandColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.textLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                        ),
                        elevation: 0,
                      ),
                      child: wallet.isProcessing || _submitted
                          ? SizedBox(
                              height: AppSizes.iconSizeM,
                              width: AppSizes.iconSizeM,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text('Add Money', style: AppTextStyles.button),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    // Add Money Button - Fixed at bottom
  }
}
