import 'package:flutter/material.dart';
import '../utils/loan_utils.dart';

class LoanApplicationReviewCard extends StatelessWidget {
  final String title;
  final List<MapEntry<String, String>> reviewItems;
  final String loanType;

  const LoanApplicationReviewCard({
    Key? key,
    required this.title,
    required this.reviewItems,
    required this.loanType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: LoanUtils.getLoanTypeColor(loanType),
              ),
            ),
            const SizedBox(height: 12),
            ...reviewItems
                .map((item) => _buildReviewRow(context, item.key, item.value))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
