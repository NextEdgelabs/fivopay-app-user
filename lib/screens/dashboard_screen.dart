import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:janseva/main.dart';
import 'package:janseva/modules/buyShares/screens/buysharesScreen.dart';
import 'package:janseva/modules/loan/screens/loan_product_screen.dart';
import 'package:janseva/modules/wallet_module/provider/wallet_provider.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:janseva/modules/wallet_module/screens/withdraw_screen.dart';
import 'package:janseva/screens/fixed_deposit_screen.dart';
import 'package:janseva/utils/app_color_extension.dart';
import 'package:janseva/utils/theme_extension.dart';

import 'package:provider/provider.dart';
import '../modules/loan/screens/loan_categories_screen.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';

import '../widgets/balance_card.dart';
import '../widgets/user_info_card.dart';
import '../widgets/small_stat_card.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/custom_bottom_nav_bar.dart';

import 'referral_screen.dart';
import 'profile_screen.dart';
import 'transactions_screen.dart';
import 'applications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  int _currentIndex = 0;
  int _topTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController?.forward();

    WidgetsBinding.instance.addPostFrameCallback((e) {
      Provider.of<WalletProvider>(
        context,
        listen: false,
      ).loadWalletBalance(context.read<UserProvider>().currentUser!.id);
      Provider.of<WalletProvider>(
        context,
        listen: false,
      ).fetchUserTransactions();
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgColors,
      body: Consumer<UserProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                  child: _getScreen(_currentIndex),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
            _animationController?.reset();
            _animationController?.forward();
          }
        },
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return Container(key: const ValueKey(0), child: _buildHomeTab());
      case 1: // Analytics
        return Container(key: const ValueKey(1), child: ApplicationsScreen());
      case 2: // FAB (Add)
        return Container(
          key: const ValueKey(2),
          child: _buildApplicationsTab(),
        );
      case 3: // Cards
        return Container(key: const ValueKey(3), child: _buildReferralTab());
      case 4: // Profile
        return Container(key: const ValueKey(4), child: const ProfileScreen());
      default:
        return Container(key: const ValueKey(0), child: _buildHomeTab());
    }
  }

  Widget _getTopTabContent(WalletProvider transactionProvider) {
    switch (_topTabIndex) {
      case 0:
        return _buildBankTab(transactionProvider);
      case 1:
        return SizedBox.shrink();
      case 2:
        return BuySharesScreen();
      case 3:
        return LoanCategoriesScreen();
      default:
        return _buildBankTab(transactionProvider);
    }
  }

  Widget _buildBankTab(WalletProvider transactionProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Consumer2<UserProvider, WalletProvider>(
          builder: (context, provider, walletProvider, child) {
            var user = provider.currentUser;
            var transactions = walletProvider.transactions;
            bool isKycCompleted =
                user?.kycStatus?.toLowerCase() == 'completed' ||
                user?.kycStatus?.toLowerCase() == 'verified';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Card
                BalanceCard(
                  title: 'TOTAL BALANCE',
                  amountText:
                      '₹ ${transactionProvider.balanceDisplay.replaceAll('₹', '').trim()}',
                  onPrimary: () => push(NamedRoutes.depositScreen),
                  onSecondary: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WithdrawScreen(),
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.sectionSpacing),

                // User Info Card
                UserInfoCard(
                  name: user?.name ?? 'Sham Kapoor',
                  accountNumber: user?.memberId ?? 'JNS1234567890',
                  memberSince: user?.memberSince ?? '20 Jan, 2025',
                  isPro: true,
                ),

                const SizedBox(height: AppSizes.paddingM),

                // Two small stat cards row
                Row(
                  children: [
                    Expanded(
                      child: SmallStatCard(
                        iconPath: "shield",
                        icon: Icons.verified_user_outlined,
                        label: 'KYC STATUS',
                        value: isKycCompleted ? 'Completed' : 'Pending',
                        iconColor: context.colors.textSecondary,
                        valueColor: isKycCompleted
                            ? Colors.green
                            : Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingM),
                    Expanded(
                      child: SmallStatCard(
                        iconPath: "profile",
                        icon: Icons.person_outline,
                        label: 'MEMBER TYPE',
                        value: user?.isMember == true ? 'Active' : 'Guest',
                        iconColor: context.colors.textSecondary,
                        valueColor: context.colors.text,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.sectionSpacing),

                // Recent Transactions Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: AppTextStyles.heading2.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        push(NamedRoutes.transactionHistory);
                      },
                      child: Text(
                        'See All',
                        style: AppTextStyles.body1.copyWith(
                          color: context.colors.brandColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                transactions.isEmpty
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.all(AppSizes.paddingL),
                          padding: const EdgeInsets.all(AppSizes.paddingL),
                          child: const Text('No transactions'),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: transactions.length > 5
                            ? 5
                            : transactions.length,
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
                        },
                      ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFixedDepositTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: 80,
              color: context.colors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              'Fixed Deposit',
              style: AppTextStyles.heading1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Fixed Deposit feature coming soon',
              style: AppTextStyles.body1.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayBillsTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: context.colors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: AppSizes.paddingL),
            Text(
              'Pay Bills',
              style: AppTextStyles.heading1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              'Bill payment feature coming soon',
              style: AppTextStyles.body1.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabItem(int index, String title, {VoidCallback? onTap}) {
    final isSelected = _topTabIndex == index;
    return GestureDetector(
      onTap:
          onTap ??
          () {
            setState(() {
              _topTabIndex = index;
            });
          },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingL,
              vertical: AppSizes.paddingS,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? context.colors.brandColor
                    : context.colors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          if (isSelected)
            Container(
              height: 3,
              width: 50,
              decoration: BoxDecoration(
                color: context.colors.brandColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final transactionProvider = Provider.of<WalletProvider>(bContext);

    return Scaffold(
      backgroundColor: context.colors.bgColors,
      appBar: AppBar(
        title: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.brandColor,
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(AppSizes.paddingXS),
                child: Icon(
                  Iconsax.user_octagon,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
            // CircleAvatar(
            //         backgroundColor: contet,
            //         radius: 18,
            //         child: Icon(Iconsax.user_octagon, color: Colors.white),
            //       ),
            const SizedBox(width: AppSizes.paddingM),
            Text(
              'FIVOPAY',
              style: AppTextStyles.heading2.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.brandColor,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: context.colors.bgColors,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSizes.paddingM),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_none,
              color: context.colors.textSecondary,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Tabs
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.colors.border.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTopTabItem(0, 'Bank'),
                    _buildTopTabItem(
                      1,
                      'Fixed Deposit',
                      onTap: () {
                        push(NamedRoutes.selectDepositTypeHomeScreen);
                      },
                    ),
                    _buildTopTabItem(2, 'Buy Shares'),
                    _buildTopTabItem(3, "Apply Loan"),
                  ],
                ),
              ),
            ),

            // Top Tab Content
            Expanded(child: _getTopTabContent(transactionProvider)),
          ],
        ),
      ),
    );
  }
}

Widget _buildApplicationsTab() {
  return const ApplicationsScreen();
}

Widget _buildReferralTab() {
  return const ReferralScreen();
}
