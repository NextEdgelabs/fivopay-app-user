import 'package:flutter/material.dart';
import 'package:janseva/modules/loan/providers/loan_provider.dart';
import 'package:provider/provider.dart';
import '../../auth/provider/auth_provider.dart';
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
              context.read<AuthProvider>().isEthicalBanking
                  ? 'Profit Rate'
                  : 'Interest Rate',
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
  final LoanProduct product;
  const LoanProductDisplayCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  LoanUtils.getLoanTypeIcon(
                    product.loanCategory?.loanType ?? "LOAN",
                  ),
                  color: LoanUtils.getLoanTypeColor(
                    product.loanCategory?.loanType ?? "LOAN",
                  ),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product.description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            buildDetailRow(
              context,
              context.read<AuthProvider>().isEthicalBanking
                  ? 'Profit Rate'
                  : 'Interest Rate',
              product.formattedInterestRate,
            ),
            buildDetailRow(
              context,
              'Amount Range',
              product.formattedAmountRange,
            ),
            buildDetailRow(
              context,
              'Tenure Range',
              product.formattedTenureRange,
            ),
          ],
        ),
      ),
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
