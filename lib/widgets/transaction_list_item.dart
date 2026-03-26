import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:janseva/utils/theme_extension.dart';
import '../utils/constants.dart';

class TransactionListItem extends StatelessWidget {
  final String name;
  final DateTime timestamp;
  final String amountText;
  final bool isNegative;
  final bool? showIcon;
  final String? status;

  const TransactionListItem({
    super.key,
    required this.name,
    required this.timestamp,
    required this.amountText,
    required this.isNegative,
    this.showIcon = true,
    this.status,
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
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      _formatDateTime(timestamp),
                      style: AppTextStyles.caption.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (status?.toLowerCase() == 'pending') ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getStatusColor(status!).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getStatusText(status!),
                    style: AppTextStyles.caption.copyWith(
                      color: _getStatusColor(status!),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              Text(
                amountText,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.bold,

                  color: status?.toLowerCase() == 'pending'
                      ? context.colors.alert3
                      : isNegative
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
      case 'approved':
        return Colors.green;
      case 'pending':
      case 'processing':
        return Colors.orange;
      case 'failed':
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    // Capitalize first letter and return
    return status.isNotEmpty
        ? status[0].toUpperCase() + status.substring(1).toLowerCase()
        : status;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateToCheck == today) {
      // Today: Show "Today, 2:30 PM"
      return 'Today, ${DateFormat('h:mm a').format(dateTime)}';
    } else if (dateToCheck == yesterday) {
      // Yesterday: Show "Yesterday, 2:30 PM"
      return 'Yesterday, ${DateFormat('h:mm a').format(dateTime)}';
    } else if (now.difference(dateTime).inDays < 7) {
      // Within last week: Show "Mon, 2:30 PM"
      return DateFormat('EEE, h:mm a').format(dateTime);
    } else if (dateTime.year == now.year) {
      // Same year: Show "Jan 15, 2:30 PM"
      return DateFormat('MMM d, h:mm a').format(dateTime);
    } else {
      // Different year: Show "Jan 15, 2024"
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }
}
