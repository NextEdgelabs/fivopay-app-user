import 'package:flutter/material.dart';
import 'package:janseva/modules/loan/providers/loan_provider.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../utils/loan_utils.dart';

class LoanCategoryDisplayCard extends StatelessWidget {
  final LoanCategory loanCategory;

  const LoanCategoryDisplayCard({Key? key, required this.loanCategory})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LoanUtils.getLoanTypeIcon(loanCategory.loanType),
                  color: LoanUtils.getLoanTypeColor(loanCategory.loanType),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    loanCategory.categoryName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              loanCategory.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            buildDetailRow(
              context,
              'Interest Rate',
              loanCategory.formattedInterestRate,
            ),
            buildDetailRow(
              context,
              'Amount Range',
              loanCategory.loanAmountRange,
            ),
            buildDetailRow(
              context,
              'Tenure Range',
              loanCategory.formattedTenure,
            ),
          ],
        ),
      ),
    );
  }
}

class LoanProductDisplayCard extends StatelessWidget {
  const LoanProductDisplayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, provider, _) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LoanUtils.getLoanTypeIcon(
                        provider.selectedLoanCategory?.loanType ?? "LOAN",
                      ),
                      color: LoanUtils.getLoanTypeColor(
                        provider.selectedLoanCategory!.loanType,
                      ),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        provider.selectedProduct?.name ??
                            provider.selectedLoanCategory!.categoryName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  provider.selectedProduct!.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                buildDetailRow(
                  context,
                  'Interest Rate',
                  provider.selectedProduct!.formattedInterestRate,
                ),
                buildDetailRow(
                  context,
                  'Amount Range',
                  provider.selectedProduct!.formattedAmountRange,
                ),
                buildDetailRow(
                  context,
                  'Tenure Range',
                  provider.selectedProduct!.formattedTenureRange,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget buildDetailRow(BuildContext context, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
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
