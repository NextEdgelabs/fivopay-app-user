import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/loan_provider.dart';
import '../utils/loan_utils.dart';

class LoanApplicationEMICalculatorCard extends StatelessWidget {
  final LoanCategory loanCategory;
  final TextEditingController loanAmountController;
  final TextEditingController tenureController;

  const LoanApplicationEMICalculatorCard({
    Key? key,
    required this.loanCategory,
    required this.loanAmountController,
    required this.tenureController,
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
            Row(
              children: [
                Icon(
                  Icons.calculate,
                  color: LoanUtils.getLoanTypeColor(loanCategory.loanType),
                ),
                const SizedBox(width: 8),
                Text(
                  'EMI Calculator',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<LoanProvider>(
              builder: (context, loanProvider, child) {
                if (loanAmountController.text.isNotEmpty &&
                    tenureController.text.isNotEmpty) {
                  final amount =
                      double.tryParse(
                        loanAmountController.text.replaceAll(',', ''),
                      ) ??
                      0;
                  final tenure = int.tryParse(tenureController.text) ?? 0;

                  if (amount > 0 && tenure > 0) {
                    final emiData = loanProvider.calculateEMI(
                      principal: amount,
                      annualRate: loanCategory.interestRate,
                      tenureMonths: tenure,
                    );

                    return Column(
                      children: [
                        _buildDetailRow(
                          context,
                          'Monthly EMI',
                          '₹${emiData['emi']!.toStringAsFixed(0)}',
                        ),
                        _buildDetailRow(
                          context,
                          'Total Amount',
                          '₹${emiData['totalAmount']!.toStringAsFixed(0)}',
                        ),
                        _buildDetailRow(
                          context,
                          'Total Interest',
                          '₹${emiData['totalInterest']!.toStringAsFixed(0)}',
                        ),
                      ],
                    );
                  }
                }

                return Text(
                  'Enter loan amount and tenure to calculate EMI',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
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
}
