import 'package:flutter/material.dart';
import 'package:janseva/modules/wallet_module/models/transaction_model.dart';
import 'package:janseva/modules/wallet_module/provider/wallet_provider.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:janseva/widgets/transaction_list_item.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../services/common_utils.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart';
import '../widgets/section_header.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'all';
  final _filters = const {
    'all': 'All',
    'deposit': 'Deposits',
    'withdraw': 'Withdrawals',
    'transfer': 'Transfers',
    'bonus': 'Bonuses',
  };

  Future<void> _refreshTransactions() async {
    final provider = Provider.of<WalletProvider>(context, listen: false);
    await provider.fetchUserTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WalletProvider>(context);
    final stats = provider.getTransactionStats();

    List<Transaction> transactions = _selectedFilter == 'all'
        ? provider.transactions
        : provider.getTransactionsByType(_selectedFilter);

    return Scaffold(
      backgroundColor: context.colors.bgColors,
      appBar: AppBar(title: const Text('Transactions')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'Summary'),
                  const SizedBox(height: AppSizes.paddingM),
                  _buildSummaryCard(stats, provider.balanceDisplay),
                ],
              ),
            ),
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
              ),
              child: Row(
                children: _filters.entries.map((e) {
                  final selected = _selectedFilter == e.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSizes.paddingS),
                    child: ChoiceChip(
                      label: Text(e.value),
                      selected: selected,
                      onSelected: (_) {
                        setState(() => _selectedFilter = e.key);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            // Transaction List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshTransactions,
                child: transactions.isEmpty
                    ? ListView(
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.all(AppSizes.paddingL),
                              padding: const EdgeInsets.all(AppSizes.paddingL),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusL,
                                ),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Text('No transactions'),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingL,
                          vertical: AppSizes.paddingM,
                        ),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final t = transactions[index];
                          return TransactionListItem(
                            name: t.description,
                            timestamp: t.timestamp,
                            amountText: t.amount.toStringAsFixed(2),
                            isNegative: t.type == 'withdraw',
                            showIcon: false,
                            status: t.status,
                          );

                          //  _buildTransactionCard(
                          //   type: t.type,
                          //   amount: t.amount,
                          //   description: t.description,
                          //   timestamp: t.timestamp,
                          // );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildSummaryCard(Map<String, dynamic> stats, String balance) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text('Current Balance', style: AppTextStyles.body2),
          const SizedBox(height: AppSizes.paddingXS),
          // ignore: unnecessary_brace_in_string_interps
          Text(balance, style: AppTextStyles.heading2),
          const Divider(height: AppSizes.paddingL * 2),
          Wrap(
            spacing: AppSizes.paddingL,
            runSpacing: AppSizes.paddingS,
            alignment: WrapAlignment.center,
            children: [
              _statItem('Deposits', stats['totalDeposits']),
              _statItem('Withdrawals', stats['totalWithdrawals']),
              _statItem('Transfers', stats['totalTransfers']),
              _statItem('Bonuses', stats['totalBonuses']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard({
    required String type,
    required double amount,
    required String description,
    required DateTime timestamp,
  }) {
    final bool isDebit = type == 'withdraw' || type == 'transfer';
    final Color accent = isDebit ? AppColors.error : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Center(child: iconForType(type)),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(AppDate.format(timestamp), style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Text(
            '${isDebit ? '-' : '+'}₹${amount.toStringAsFixed(2)}',
            style: AppTextStyles.body1.copyWith(
              color: accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String title, double value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('₹${value.toStringAsFixed(0)}', style: AppTextStyles.heading3),
        Text(title, style: AppTextStyles.caption),
      ],
    );
  }
}
