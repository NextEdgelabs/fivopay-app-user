import 'package:flutter/material.dart';
import 'package:janseva/modules/loan/utils/loan_utils.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:provider/provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../models/models.dart';
import '../providers/loan_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/app_color_extension.dart';

class LoanCategoriesScreen extends StatefulWidget {
  const LoanCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<LoanCategoriesScreen> createState() => _LoanCategoriesScreenState();
}

class _LoanCategoriesScreenState extends State<LoanCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoanProvider>().fetchLoanCategories(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Loan Categories'),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         context.read<LoanProvider>().fetchLoanCategories(refresh: true);
      //       },
      //       icon: const Icon(Icons.refresh),
      //     ),
      //   ],
      // ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        if (loanProvider.isLoading && loanProvider.loanCategories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (loanProvider.errorMessage != null &&
            loanProvider.loanCategories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  loanProvider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    loanProvider.fetchLoanCategories(refresh: true);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (loanProvider.loanCategories.isEmpty) {
          return const Center(child: Text('No loan categories available'));
        }

        return RefreshIndicator(
          onRefresh: () => loanProvider.fetchLoanCategories(refresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            itemCount:
                loanProvider.loanCategories.length +
                (loanProvider.hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == loanProvider.loanCategories.length) {
                // Load more indicator
                if (loanProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // Load more data
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    loanProvider.fetchLoanCategories();
                  });
                  return const SizedBox.shrink();
                }
              }

              final category = loanProvider.loanCategories[index];
              return _buildLoanCategoryCard(category, loanProvider);
            },
          ),
        );
      },
    );
  }

  Widget _buildLoanCategoryCard(
    LoanCategory category,
    LoanProvider loanProvider,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: InkWell(
        onTap: () => _navigateToLoanDetail(category),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
            color: context.appColors.specialCard,
            border: Border.all(color: context.appColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: context.appColors.shadowWithOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Icon + Favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingS),
                    decoration: BoxDecoration(
                      color: context.appColors.brandColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                    child: Icon(
                      LoanUtils.getLoanTypeIcon(category.loanType),
                      color: context.appColors.brandColor,
                      size: AppSizes.iconSizeL,
                    ),
                  ),
                  IconButton(
                    onPressed: () => loanProvider.toggleFavorite(category),
                    icon: Icon(
                      loanProvider.isFavorite(category)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: loanProvider.isFavorite(category)
                          ? context.appColors.alert2
                          : context.appColors.textSecondary,
                      size: AppSizes.iconSizeM,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              // Category Name
              Text(
                category.categoryName,
                style: AppTextStyles.heading3.copyWith(
                  color: context.appColors.heading,
                  fontSize: 16, // slightly smaller for grid
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.paddingM),
              // Interest Rate
              Text(
                '${context.read<AuthProvider>().isEthicalBanking ? "Rate" : "Interest Rate"}: ${category.formattedInterestRate}',
                style: AppTextStyles.caption.copyWith(
                  color: context.appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              // Amount Range
              Text(
                category.loanAmountRange,
                style: AppTextStyles.body2.copyWith(
                  color: context.appColors.brandColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.paddingS),

              // Apply Now Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _navigateToLoanApplication(category),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appColors.brandColor,
                    foregroundColor: context.appColors.buttonLabelText,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: const Size(
                      double.infinity,
                      44,
                    ), // standard button for list
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                  ),
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLoanDetail(LoanCategory category) {
    push(
      NamedRoutes.loanDetailScreen,
      arguments: LoanDetailScreenArguments(loan: category),
    );
  }

  void _navigateToLoanApplication(LoanCategory category) {
    push(
      NamedRoutes.loanApplicationForm,
      arguments: LoanDetailScreenArguments(loan: category),
    );
  }
}
