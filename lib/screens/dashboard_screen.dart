import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/action_tile.dart';
import '../widgets/balance_card.dart';
import '../widgets/sparkline_chart.dart';
import 'referral_screen.dart';
import 'profile_screen.dart';
import 'loan_application_screen.dart';
import 'fixed_deposit_screen.dart';
import 'transactions_screen.dart';
import 'applications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          _buildTransactionsTab(),
          _buildApplicationsTab(),
          _buildReferralTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: 'Applications',
          ),
          NavigationDestination(
            icon: Icon(Icons.share_outlined),
            selectedIcon: Icon(Icons.share),
            label: 'Referral',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final user = Provider.of<UserProvider>(context).currentUser;
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello ${user?.name ?? 'Member'}',
                                style: AppTextStyles.heading3,
                              ),
                              const SizedBox(height: 2),
                              Text('Welcome back!', style: AppTextStyles.body2),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'Account Number',
                            user?.accountNumber ?? 'JS001234567',
                            Icons.account_balance,
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingM),
                        Expanded(
                          child: _buildInfoCard(
                            'Member Since',
                            user?.memberSince ?? 'Jan 2024',
                            Icons.calendar_today,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              // Membership Status
              SectionHeader(title: 'Membership Status'),
              const SizedBox(height: AppSizes.paddingM),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.verified_user,
                      label: 'KYC Status',
                      value: user?.kycStatus == 'completed'
                          ? 'Completed'
                          : 'Pending',
                      color: user?.kycStatus == 'completed'
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: StatCard(
                      icon: Icons.person,
                      label: 'Member Type',
                      value: user?.isMember == true ? 'Active Member' : 'Guest',
                      color: user?.isMember == true
                          ? AppColors.primary
                          : AppColors.textLight,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.paddingL),

              // Balance Card
              BalanceCard(
                title: AppStrings.balance,
                amountText:
                    '₹${transactionProvider.currentBalance.toStringAsFixed(2)}',
                onPrimary: () =>
                    _showDepositDialog(context, transactionProvider),
                onSecondary: () =>
                    _showWithdrawDialog(context, transactionProvider),
              ),

              const SizedBox(height: AppSizes.paddingL),

              // Savings trend (sparkline)
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(title: 'Savings'),
                    const SizedBox(height: AppSizes.paddingM),
                    SparklineChart(
                      values: const [20, 24, 30, 28, 35, 40, 38, 45],
                      lineColor: Theme.of(context).colorScheme.primary,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.15),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              // Quick Actions
              SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: AppSizes.paddingM),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.paddingM,
                mainAxisSpacing: AppSizes.paddingM,
                children: [
                  ActionTile(
                    title: 'Fixed Deposit',
                    icon: Icons.account_balance,
                    color: AppColors.secondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FixedDepositScreen(),
                        ),
                      );
                    },
                  ),
                  ActionTile(
                    title: 'Pay Bills',
                    icon: Icons.receipt,
                    color: AppColors.warning,
                    onTap: () {
                      // TODO: Implement bill payment
                    },
                  ),
                  ActionTile(
                    title: 'Loan',
                    icon: Icons.credit_card,
                    color: AppColors.info,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoanApplicationScreen(),
                        ),
                      );
                    },
                  ),
                  ActionTile(
                    title: 'Support',
                    icon: Icons.support_agent,
                    color: AppColors.error,
                    onTap: () {
                      // TODO: Implement support
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textLight, size: AppSizes.iconSizeS),
          const SizedBox(height: AppSizes.paddingS),
          Text(title, style: AppTextStyles.caption),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Removed legacy status/action card builders in favor of reusable widgets

  Widget _buildTransactionsTab() {
    return const TransactionsScreen();
  }

  Widget _buildApplicationsTab() {
    return const ApplicationsScreen();
  }

  Widget _buildReferralTab() {
    return const ReferralScreen();
  }

  Widget _buildProfileTab() {
    return const ProfileScreen();
  }

  // Deposit Dialog
  void _showDepositDialog(
    BuildContext context,
    TransactionProvider transactionProvider,
  ) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deposit Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: amountController,
              labelText: 'Amount',
              hintText: 'Enter amount to deposit',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.account_balance_wallet,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                Navigator.pop(context);
                final success = await transactionProvider.deposit(amount);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Successfully deposited ₹${amount.toStringAsFixed(2)}',
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        transactionProvider.error ?? 'Deposit failed',
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            text: 'Deposit',
          ),
        ],
      ),
    );
  }

  // Withdraw Dialog
  void _showWithdrawDialog(
    BuildContext context,
    TransactionProvider transactionProvider,
  ) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: amountController,
              labelText: 'Amount',
              hintText: 'Enter amount to withdraw',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.account_balance_wallet,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                Navigator.pop(context);
                final success = await transactionProvider.withdraw(amount);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Successfully withdrew ₹${amount.toStringAsFixed(2)}',
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        transactionProvider.error ?? 'Withdrawal failed',
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            text: 'Withdraw',
          ),
        ],
      ),
    );
  }
}
