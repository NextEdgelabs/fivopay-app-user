import 'package:flutter/material.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../utils/constants.dart';

class TransactionListItem extends StatelessWidget {
  final String name;
  final String timestamp;
  final String amountText;
  final bool isNegative;
  final bool? showIcon;

  const TransactionListItem({
    super.key,
    required this.name,
    required this.timestamp,
    required this.amountText,
    required this.isNegative,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
      child: Row(
        children: [
          if (showIcon == true) ...[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.colors.specialCardTwo,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: context.colors.textSecondary),
            ),
            const SizedBox(width: AppSizes.paddingM),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  timestamp,
                  style: AppTextStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amountText,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.bold,
              color: isNegative ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
