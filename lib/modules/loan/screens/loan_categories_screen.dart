import 'package:flutter/material.dart';
import 'package:janseva/modules/loan/utils/loan_utils.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/loan_provider.dart';

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
      appBar: AppBar(
        title: const Text('Loan Categories'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<LoanProvider>().fetchLoanCategories(refresh: true);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
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
            padding: const EdgeInsets.all(16),
            itemCount:
                loanProvider.loanCategories.length +
                (loanProvider.hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == loanProvider.loanCategories.length) {
                // Load more indicator
                if (loanProvider.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
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
    final loanColor = LoanUtils.getLoanTypeColor(category.loanType);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            loanColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: loanColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: loanColor.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToLoanDetail(category),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with loan type and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            loanColor,
                            loanColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: loanColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LoanUtils.getLoanTypeIcon(category.loanType),
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            category.loanType.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => loanProvider.toggleFavorite(category),
                          icon: Icon(
                            loanProvider.isFavorite(category)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: loanProvider.isFavorite(category)
                                ? Colors.red
                                : Colors.grey,
                            size: 22,
                          ),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: category.status == 'active'
                                ? Colors.green
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: (category.status == 'active'
                                        ? Colors.green
                                        : Colors.grey)
                                    .withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            category.status.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: loanColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: loanColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Category name and description
                Text(
                  category.categoryName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  category.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Key details
                _buildDetailRow('Amount Range', category.loanAmountRange),
                _buildDetailRow('Interest Rate', category.formattedInterestRate),
                _buildDetailRow('Tenure', category.formattedTenure),
                _buildDetailRow(
                  'Processing Fee',
                  category.processingFee.formattedFee,
                ),
                _buildDetailRow(
                  'Min Credit Score',
                  category.eligibilityCriteria.formattedCreditScore,
                ),

                const SizedBox(height: 16),

                // Features
                if (category.features.isNotEmpty) ...[
                  Text(
                    'Features:',
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        category.features
                            .take(3) // Show only first 3 features
                            .map(
                              (feature) => Chip(
                                label: Text(
                                  feature,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: loanColor.withOpacity(0.1),
                                side: BorderSide(
                                  color: loanColor.withOpacity(0.3),
                                ),
                              ),
                            )
                            .toList()
                          ..addAll(
                            category.features.length > 3
                                ? [
                                    Chip(
                                      label: Text(
                                        '+${category.features.length - 3} more',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: Colors.grey[200],
                                    ),
                                  ]
                                : [],
                          ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _navigateToLoanDetail(category),
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: loanColor,
                          side: BorderSide(
                            color: loanColor,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToLoanApplication(category),
                        icon: const Icon(Icons.send, size: 16),
                        label: const Text('Apply Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: loanColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 3,
                          shadowColor: loanColor.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
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
