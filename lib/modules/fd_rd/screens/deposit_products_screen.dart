import 'package:flutter/material.dart';
import 'package:janseva/modules/fd_rd/deposit_provider.dart';
import 'package:janseva/modules/fd_rd/model/deposit_category_model.dart';
import 'package:janseva/routes/routes.dart';
import 'package:janseva/utils/app_size.dart';
import 'package:janseva/utils/constants.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:janseva/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

import '../model/deposit_product_model.dart';

class DepositProductsScreen extends StatefulWidget {
  final DepositCategory category;

  const DepositProductsScreen({Key? key, required this.category})
    : super(key: key);

  @override
  State<DepositProductsScreen> createState() => _DepositProductsScreenState();
}

class _DepositProductsScreenState extends State<DepositProductsScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _fdNameController = TextEditingController();
  DepositProduct? _selectedProduct;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepositProvider>().fetchProducts(widget.category.id);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _fdNameController.dispose();
    super.dispose();
  }

  // Calculate Maturity and Interest
  Map<String, double> _calculateReturns(DepositProduct product, double amount) {
    double interestRate = product.defaultInterestRate;
    int tenureMonths = product.lockInPeriodMonths;
    // Simple Interest for example
    double interestEarned = (amount * interestRate * (tenureMonths / 12)) / 100;
    double maturityAmount = amount + interestEarned;
    return {'interestEarned': interestEarned, 'maturityAmount': maturityAmount};
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (b, a) {
        context.read<DepositProvider>().clearError();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              context.read<DepositProvider>().clearError();
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: context.colors.text,
              size: 24.dw,
            ),
          ),
          title: Text('Book ${widget.category.categoryName}'),
        ),
        body: Consumer<DepositProvider>(
          builder: (context, provider, child) {
            if (provider.isProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 48.0.dw,
                    ),
                    SizedBox(height: 16.0.dh),
                    Text(
                      provider.errorMessage!,
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.0.dh),
                    ElevatedButton(
                      onPressed: () {
                        provider.fetchProducts(widget.category.id);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.products.isEmpty) {
              return const Center(child: Text('No deposit products found.'));
            }

            return RefreshIndicator(
              onRefresh: () => provider.fetchProducts(widget.category.id),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopCard(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingL.dw,
                        vertical: AppSizes.paddingM.dh,
                      ),
                      child: Text(
                        'Select Tenure',
                        style: AppTextStyles.heading3.copyWith(fontSize: 16.dw),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.products.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(
                          context,
                          provider.products[index],
                        );
                      },
                    ),
                    SizedBox(height: 80.dh), // padding for bottom button
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.paddingL.dw),
            child: GradientButton(
              onTap: _selectedProduct != null
                  ? () {
                      final amount =
                          double.tryParse(_amountController.text) ?? 0;
                      if (amount <
                          (_selectedProduct!.minAmount > 0
                              ? _selectedProduct!.minAmount
                              : 5000)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Amount must be at least ₹${_selectedProduct!.minAmount > 0 ? _selectedProduct!.minAmount : 5000}',
                            ),
                          ),
                        );
                        return;
                      }
                      _showDepositMethodModal(context);
                    }
                  : null,
              text: 'Proceed',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    return Container(
      margin: EdgeInsets.all(AppSizes.paddingL.dw),
      padding: EdgeInsets.all(AppSizes.paddingL.dw),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Enter amount',
            style: AppTextStyles.body2.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: 8.dh),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IntrinsicWidth(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: 24.dw,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    prefixText: '₹ ',
                    prefixStyle: AppTextStyles.heading2.copyWith(
                      fontSize: 24.dw,
                      fontWeight: FontWeight.bold,
                      color: context.colors.text,
                    ),
                    hintText: '25,000',
                    hintStyle: AppTextStyles.heading2.copyWith(
                      fontSize: 24.dw,
                      fontWeight: FontWeight.bold,
                      color: context.colors.disableButtonText,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onChanged: (val) {
                    setState(() {
                      //AMOUNT SHOULD BE IN RANGE OF MIN AND MAX
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8.dh),
          Text(
            '*Must be at least ₹ ${_selectedProduct?.minAmount != null && _selectedProduct!.minAmount > 0 ? _selectedProduct!.minAmount.toStringAsFixed(0) : '5,000'}',
            style: AppTextStyles.caption.copyWith(color: context.colors.alert2),
          ),
          SizedBox(height: 24.dh),
          Container(
            decoration: BoxDecoration(
              color: context.colors.bgColors, // light background
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              border: Border.all(color: AppColors.borderLight),
            ),
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingM.dw),
            child: TextField(
              controller: _fdNameController,
              decoration: InputDecoration(
                hintText: 'Enter FD Name...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(vertical: 14.dh),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, DepositProduct product) {
    bool isSelected = _selectedProduct?.id == product.id;
    double amount = double.tryParse(_amountController.text) ?? 0;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProduct = product;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSizes.paddingL.dw,
          vertical: AppSizes.paddingS.dh,
        ),
        padding: EdgeInsets.all(AppSizes.paddingL.dw),
        decoration: BoxDecoration(
          color: context.colors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(
            color: isSelected
                ? context.colors.gradientTwo
                : context.colors.textLight,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: context.colors.gradientTwo.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${product.lockInPeriodMonths} Months',
                  style: AppTextStyles.heading3.copyWith(fontSize: 14.dw),
                ),
                Row(
                  children: [
                    Text(
                      '${product.defaultInterestRate.toStringAsFixed(2)}% p.a',
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: 14.dw,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 16.dw),
                    Container(
                      width: 20.dw,
                      height: 20.dw,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? context.colors.gradientTwo
                              : context.colors.textLight,
                          width: isSelected ? 0 : 1.5,
                        ),
                        color: isSelected
                            ? context.colors.gradientTwo
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? Icon(Icons.check, size: 14.dw, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
            if (isSelected && amount > 0) ...[
              SizedBox(height: 16.dh),
              Divider(color: AppColors.borderLight),
              SizedBox(height: 12.dh),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maturity Amount',
                        style: AppTextStyles.caption.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4.dh),
                      Text(
                        '₹ ${(_calculateReturns(product, amount)['maturityAmount']!).toStringAsFixed(0)}',
                        style: AppTextStyles.heading3.copyWith(fontSize: 14.dw),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Intrest Earned',
                        style: AppTextStyles.caption.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4.dh),
                      Text(
                        '₹ ${(_calculateReturns(product, amount)['interestEarned']!).toStringAsFixed(0)}',
                        style: AppTextStyles.heading3.copyWith(
                          fontSize: 14.dw,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDepositMethodModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.colors.cardBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSizes.radiusXL),
            topRight: Radius.circular(AppSizes.radiusXL),
          ),
        ),
        padding: EdgeInsets.all(AppSizes.paddingXL.dw),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.dw,
                  height: 4.dh,
                  decoration: BoxDecoration(
                    color: context.colors.textLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 24.dh),
              Text(
                'Select Deposit Method',
                style: AppTextStyles.heading2.copyWith(fontSize: 20.dw),
              ),
              SizedBox(height: 8.dh),
              Text(
                'Choose how you would like to make your deposit',
                style: AppTextStyles.body2.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(height: 24.dh),

              // Online Deposit Option
              _buildMethodOption(
                context: context,
                icon: Icons.account_balance,
                title: 'Online Deposit',
                subtitle: 'Transfer money instantly via online banking',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    NamedRoutes.onlineDepositScreen,
                    arguments: {
                      'category': widget.category,
                      'product': _selectedProduct,
                      'amount': double.tryParse(_amountController.text) ?? 0,
                      'fdName': _fdNameController.text,
                    },
                  );
                },
              ),
              SizedBox(height: 12.dh),

              // Branch Deposit Option
              _buildMethodOption(
                context: context,
                icon: Icons.location_on,
                title: 'Branch Deposit',
                subtitle: 'Visit our branch and deposit in person',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    NamedRoutes.branchDepositScreen,
                    arguments: {
                      'category': widget.category,
                      'product': _selectedProduct,
                      'amount': double.tryParse(_amountController.text) ?? 0,
                      'fdName': _fdNameController.text,
                    },
                  );
                },
              ),
              SizedBox(height: 12.dh),

              // Collect from Home Option
              _buildMethodOption(
                context: context,
                icon: Icons.home,
                title: 'Collect from Home',
                subtitle: 'Our representative will collect cash from your home',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    NamedRoutes.collectFromHomeScreen,
                    arguments: {
                      'category': widget.category,
                      'product': _selectedProduct,
                      'amount': double.tryParse(_amountController.text) ?? 0,
                      'fdName': _fdNameController.text,
                    },
                  );
                },
              ),
              SizedBox(height: 16.dh),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingL.dw),
        decoration: BoxDecoration(
          color: context.colors.bgColors,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(color: context.colors.border, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.paddingM.dw),
              decoration: BoxDecoration(
                color: context.colors.brandColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: context.colors.brandColor, size: 24.dw),
            ),
            SizedBox(width: AppSizes.paddingM.dw),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading3.copyWith(fontSize: 16.dw),
                  ),
                  SizedBox(height: 4.dh),
                  Text(
                    subtitle,
                    style: AppTextStyles.body2.copyWith(
                      color: context.colors.textSecondary,
                      fontSize: 12.dw,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.colors.textLight,
              size: 24.dw,
            ),
          ],
        ),
      ),
    );
  }
}
