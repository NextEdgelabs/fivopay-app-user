import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:janseva/modules/fd_rd/model/term_deposit_model.dart';
import 'package:janseva/utils/constants.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:provider/provider.dart';

import '../modules/auth/provider/auth_provider.dart';

class DepositDetailScreen extends StatelessWidget {
  final DepositAccountModel deposit;

  const DepositDetailScreen({super.key, required this.deposit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgColors,
      appBar: AppBar(
        title: const Text('Deposit Details'),
        elevation: 0,
        backgroundColor: context.colors.brandColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            _buildStatusBanner(context),

            const SizedBox(height: AppSizes.paddingL),

            // Amount Card
            _buildAmountCard(context),

            const SizedBox(height: AppSizes.paddingL),

            // Account Details
            _buildSectionCard(
              context,
              title: 'Account Details',
              icon: Icons.account_balance_wallet,
              children: [
                _buildDetailRow(
                  context,
                  'Account Number',
                  deposit.accountNumber ?? deposit.depositId ?? 'N/A',
                  icon: Icons.tag,
                ),
                _buildDivider(context),
                _buildDetailRow(
                  context,
                  'Deposit Type',
                  deposit.depositType ?? 'N/A',
                  icon: Icons.category,
                ),
                _buildDivider(context),
                _buildDetailRow(
                  context,
                  'Product',
                  deposit.productId?.productName ?? 'N/A',
                  icon: Icons.inventory_2,
                ),
                _buildDivider(context),
                _buildDetailRow(
                  context,
                  'Created On',
                  deposit.createdAt != null
                      ? _formatDate(deposit.createdAt!)
                      : 'N/A',
                  icon: Icons.calendar_today,
                ),
              ],
            ),

            const SizedBox(height: AppSizes.paddingM),

            // Financial Details
            _buildSectionCard(
              context,
              title: 'Financial Details',
              icon: Icons.attach_money,
              children: [
                _buildDetailRow(
                  context,
                  'Deposit Amount',
                  '₹${(deposit.depositAmount ?? 0).toStringAsFixed(2)}',
                  icon: Icons.account_balance,
                  valueColor: context.colors.brandColor,
                  isBold: true,
                ),
                _buildDivider(context),
                _buildDetailRow(
                  context,
                  'Current Balance',
                  '₹${(deposit.currentBalance ?? 0).toStringAsFixed(2)}',
                  icon: Icons.account_balance_wallet,
                  valueColor: context.colors.alert1,
                  isBold: true,
                ),
                _buildDivider(context),
                _buildDetailRow(
                  context,
                  context.read<AuthProvider>().isEthicalBanking
                      ? 'Profit Rate'
                      : 'Interest Rate',
                  '${(deposit.interestRate ?? 0).toStringAsFixed(2)}% p.a.',
                  icon: Icons.percent,
                ),
                _buildDivider(context),
                _buildDetailRow(
                  context,
                  'Interest Earned',
                  '₹${(deposit.interestEarned ?? 0).toStringAsFixed(2)}',
                  icon: Icons.trending_up,
                  valueColor: context.colors.alert1,
                ),
                _buildDivider(context),
                _buildDetailRow(
                  context,
                  'Total Deposits',
                  '₹${(deposit.totalDeposits ?? 0).toStringAsFixed(2)}',
                  icon: Icons.add_circle_outline,
                ),
                _buildDivider(context),
                _buildDetailRow(
                  context,
                  'Total Withdrawals',
                  '₹${(deposit.totalWithdrawals ?? 0).toStringAsFixed(2)}',
                  icon: Icons.remove_circle_outline,
                  valueColor: AppColors.error,
                ),
              ],
            ),

            const SizedBox(height: AppSizes.paddingM),

            // Tenure & Maturity
            if (deposit.productId?.lockInPeriodMonths != null) ...[
              _buildSectionCard(
                context,
                title: 'Tenure Information',
                icon: Icons.schedule,
                children: [
                  _buildDetailRow(
                    context,
                    'Lock-in Period',
                    '${deposit.productId!.lockInPeriodMonths} months',
                    icon: Icons.lock_clock,
                  ),
                  _buildDivider(context),
                  _buildDetailRow(
                    context,
                    'Auto Renewal',
                    deposit.autoRenewal == true ? 'Enabled' : 'Disabled',
                    icon: Icons.autorenew,
                    valueColor: deposit.autoRenewal == true
                        ? context.colors.alert1
                        : context.colors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
            ],

            // Branch Details
            if (deposit.branchId != null) ...[
              _buildSectionCard(
                context,
                title: 'Branch Information',
                icon: Icons.business,
                children: [
                  _buildDetailRow(
                    context,
                    'Branch Name',
                    deposit.branchId!.branchName ?? 'N/A',
                    icon: Icons.store,
                  ),
                  if (deposit.branchId!.branchCode != null) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'Branch Code',
                      deposit.branchId!.branchCode!,
                      icon: Icons.code,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
            ],

            // Customer Details
            if (deposit.customerId != null) ...[
              _buildSectionCard(
                context,
                title: 'Customer Information',
                icon: Icons.person,
                children: [
                  _buildDetailRow(
                    context,
                    'Name',
                    deposit.customerId!.fullName ?? 'N/A',
                    icon: Icons.person_outline,
                  ),
                  if (deposit.customerId!.memberId != null) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'Member ID',
                      deposit.customerId!.memberId!,
                      icon: Icons.badge,
                    ),
                  ],
                  if (deposit.customerId!.phone != null) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'Phone',
                      deposit.customerId!.phone!,
                      icon: Icons.phone,
                    ),
                  ],
                  if (deposit.customerId!.email != null) ...[
                    _buildDivider(context),
                    _buildDetailRow(
                      context,
                      'Email',
                      deposit.customerId!.email!,
                      icon: Icons.email,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
            ],

            const SizedBox(height: AppSizes.paddingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner(BuildContext context) {
    final statusColor = _getStatusColor(deposit.status);
    final statusText = _getStatusText(deposit.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: statusColor.withOpacity(0.3), width: 2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(
              _getStatusIcon(deposit.status),
              color: statusColor,
              size: AppSizes.iconSizeL,
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: AppTextStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  statusText,
                  style: AppTextStyles.heading3.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      padding: const EdgeInsets.all(AppSizes.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.gradientOne,
            context.colors.gradientTwo.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        boxShadow: [
          BoxShadow(
            color: context.colors.brandColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Current Balance',
            style: AppTextStyles.body2.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            '₹${(deposit.currentBalance ?? 0).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingL,
              vertical: AppSizes.paddingS,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusL),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.trending_up, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${context.read<AuthProvider>().isEthicalBanking ? 'Profit:' : 'Interest:'} ₹${(deposit.interestEarned ?? 0).toStringAsFixed(2)}',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
      decoration: BoxDecoration(
        color: context.colors.bgColors,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.brandColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.iconSizeM,
                    color: context.colors.brandColor,
                  ),
                ),
                const SizedBox(width: AppSizes.paddingM),
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
          Container(height: 1, color: context.colors.border),
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: AppSizes.iconSizeS,
            color: context.colors.textSecondary,
          ),
          const SizedBox(width: AppSizes.paddingS),
        ],
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppSizes.paddingM),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.body1.copyWith(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: valueColor ?? context.colors.text,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingM),
      height: 1,
      color: context.colors.border,
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'matured':
        return AppColors.info;
      case 'closed':
      case 'suspended':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    return status.isNotEmpty
        ? status[0].toUpperCase() + status.substring(1).toLowerCase()
        : status;
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'matured':
        return Icons.event_available;
      case 'closed':
        return Icons.cancel;
      case 'suspended':
        return Icons.block;
      default:
        return Icons.info;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }
}
