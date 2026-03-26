import 'package:flutter/material.dart';
import 'package:janseva/modules/fd_rd/deposit_provider.dart';
import 'package:janseva/modules/fd_rd/model/deposit_category_model.dart';
import 'package:janseva/modules/fd_rd/screens/deposit_products_screen.dart';
import 'package:janseva/utils/app_color.dart';
import 'package:janseva/utils/app_size.dart';
import 'package:janseva/utils/theme.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants.dart';

class SelectDepositTypeHomeScreen extends StatefulWidget {
  const SelectDepositTypeHomeScreen({Key? key}) : super(key: key);

  @override
  State<SelectDepositTypeHomeScreen> createState() =>
      _SelectDepositTypeHomeScreenState();
}

class _SelectDepositTypeHomeScreenState
    extends State<SelectDepositTypeHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepositProvider>().fetchCategories(type: "term_deposit");
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (b, a) {
        context.read<DepositProvider>().clearError();
      },
      child: Scaffold(
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
          title: const Text('Select Deposit Type'),
        ),
        body: Consumer<DepositProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // if (provider.errorMessage != null) {
            //   return Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(
            //           Icons.error_outline,
            //           color: context.colors.alert2,
            //           size: 48.0.dw,
            //         ),
            //         SizedBox(height: 16.0.dh),
            //         Text(
            //           provider.errorMessage!,
            //           style: AppTextStyles.body1.copyWith(
            //             color: context.colors.alert2,
            //           ),
            //           textAlign: TextAlign.center,
            //         ),
            //         SizedBox(height: 16.0.dh),
            //         ElevatedButton(
            //           onPressed: () {
            //             provider.fetchCategories();
            //           },
            //           child: const Text('Retry'),
            //         ),
            //       ],
            //     ),
            //   );
            // }

            if (provider.categories.isEmpty) {
              return const Center(child: Text('No deposit categories found.'));
            }

            return RefreshIndicator(
              onRefresh: () => provider.fetchCategories(),
              child: ListView.separated(
                padding: EdgeInsets.all(AppSizes.paddingL.dw),
                itemCount: provider.categories.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: AppSizes.paddingM.dh),
                itemBuilder: (context, index) {
                  final category = provider.categories[index];
                  return _buildCategoryCard(context, category);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, DepositCategory category) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DepositProductsScreen(category: category),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppSizes.radiusL),
      child: Container(
        padding: EdgeInsets.all(AppSizes.paddingL.dw),
        decoration: BoxDecoration(
          color: context.colors.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
              child: Icon(
                _getIconForCategory(category.categoryType),
                color: context.colors.brandColor,
                size: 24.dw,
              ),
            ),
            SizedBox(width: AppSizes.paddingM.dw),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.categoryName,
                    style: AppTextStyles.heading3.copyWith(fontSize: 16.dw),
                  ),
                  SizedBox(height: 4.dh),
                  Text(
                    category.description,
                    style: AppTextStyles.body2.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

  IconData _getIconForCategory(DepositCategoryType type) {
    switch (type) {
      case DepositCategoryType.demandDeposit:
        return Icons.account_balance_wallet;
      case DepositCategoryType.termDeposit:
        return Icons.savings;
    }
  }
}
