import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:janseva/main.dart';
import 'package:janseva/modules/buyShares/screens/buysharesScreen.dart';
import 'package:janseva/modules/loan/screens/components/adhaar_verify.dart';
import 'package:janseva/modules/loan/screens/loan_categories_screen.dart';
import 'package:janseva/modules/wallet_module/provider/wallet_provider.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:janseva/modules/wallet_module/screens/withdraw_screen.dart';
import 'package:janseva/utils/theme_extension.dart';

import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/constants.dart';

import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/action_tile.dart';
import '../widgets/balance_card.dart';
import '../widgets/sparkline_chart.dart';
import '../widgets/membership_banner.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((e) {
      Provider.of<WalletProvider>(
        context,
        listen: false,
      ).loadWalletBalance(context.read<UserProvider>().currentUser!.id);
    });
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 212, 212, 212),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          _buildTransactionsTab(),
          _buildApplicationsTab(),
          _buildReferralTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        height: 70,
        elevation: 0,
        backgroundColor: AppColors.cardBackground,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: 24),
            selectedIcon: Icon(Icons.home, size: 24),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined, size: 24),
            selectedIcon: Icon(Icons.receipt_long, size: 24),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined, size: 24),
            selectedIcon: Icon(Icons.description, size: 24),
            label: 'Application',
          ),
          NavigationDestination(
            icon: Icon(Icons.share_outlined, size: 24),
            selectedIcon: Icon(Icons.share, size: 24),
            label: 'Refer',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final transactionProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 212, 212, 212),
      appBar: AppBar(
        title: Text(
          'FIVOPAY',
          style: AppTextStyles.heading2.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        elevation: 0,
        backgroundColor: context.colors.bgColors,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        actions: [
          const SizedBox(width: AppSizes.paddingS),
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final user = userProvider.currentUser;
              final userName = user?.name ?? '';
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: AppSizes.paddingM),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary,
                    child: userName.isNotEmpty
                        ? Text(
                            userName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingL,
            vertical: AppSizes.paddingM,
          ),
          child: Consumer<UserProvider>(
            builder: (context, provider, child) {
              var user = provider.currentUser;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Membership Banner (for non-members only)
                  if (user?.isMember != true)
                    MembershipBanner(
                      onBecomeMember: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BuySharesScreen(),
                          ),
                        );
                      },
                      showCloseButton: true,
                      onClose: () {
                        setState(() {});
                      },
                    ),

                  // User Info Card
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  context.colors.gradientOne,
                                  context.colors.gradientTwo,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusL,
                              ),
                            ),
                            child: Center(
                              child:
                                  user?.name != null && user!.name!.isNotEmpty
                                  ? Text(
                                      user.name![0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingS),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Wellcome Back !',
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),

                                Text(
                                  user?.name ?? 'Member',
                                  style: AppTextStyles.heading3.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingXL),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              icon: "bank",
                              label: 'Account Number',
                              value: user?.memberId ?? 'N/A',
                            ),

                            // _buildInfoCard(
                            //   ,
                            //   ,
                            //   "bank",
                            // ),
                          ),
                          const SizedBox(width: AppSizes.paddingL),
                          Expanded(
                            child: StatCard(
                              label: 'Member Since',
                              value: user?.memberSince ?? '20 Jan, 2025',
                              icon: "calender",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.sectionSpacing),

                  // Balance Card
                  BalanceCard(
                    title: AppStrings.balance,
                    amountText: transactionProvider.balanceDisplay,
                    onPrimary: () => push(NamedRoutes.depositScreen),
                    onSecondary: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WithdrawScreen(),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.sectionSpacing),

                  // Account Information Section
                  SectionHeader(
                    title: 'Your Account Information',
                    subtitle: '',
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: "shield",
                          label: 'KYC Status',
                          value:
                              user?.kycStatus?.toLowerCase() == 'completed' ||
                                  user?.kycStatus?.toLowerCase() == 'verified'
                              ? 'Completed'
                              : 'Pending',
                          color:
                              user?.kycStatus?.toLowerCase() == 'completed' ||
                                  user?.kycStatus?.toLowerCase() == 'verified'
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: AppSizes.cardSpacing),
                      Expanded(
                        child: StatCard(
                          icon: "profile",
                          label: 'Member Type',
                          value: user?.isMember == true ? 'Active' : 'Guest',
                          color: user?.isMember == true
                              ? AppColors.primary
                              : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.sectionSpacing),

                  // Quick Actions
                  SectionHeader(title: 'Quick Actions', subtitle: ''),
                  const SizedBox(height: AppSizes.paddingL),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSizes.cardSpacing,
                    mainAxisSpacing: AppSizes.cardSpacing,
                    childAspectRatio: 1.1,
                    children: [
                      StatCard(
                        label: 'Fixed Deposit',
                        icon: "fd",
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
                      StatCard(
                        label: 'Pay Bills',
                        icon: "pay",
                        color: AppColors.warning,
                        onTap: () {
                          // TODO: Implement bill payment
                        },
                      ),
                      StatCard(
                        label: 'Shares',
                        icon: "share",
                        color: AppColors.success,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BuySharesScreen(),
                            ),
                          );
                        },
                      ),
                      StatCard(
                        label: 'Loan',
                        icon: "loan",
                        color: AppColors.info,
                        onTap: () {
                          push(NamedRoutes.loanCategoryScreen);
                        },
                      ),
                      StatCard(
                        label: 'Support',
                        icon: "support",
                        color: AppColors.error,
                        onTap: () {
                          // TODO: Implement support
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, String icon) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: context.colors.specialCard,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        // border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon(icon, color: AppColors.textLight, size: AppSizes.iconSizeS),
          const SizedBox(height: AppSizes.paddingS),
          Text(title, style: AppTextStyles.caption),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "assets/icons/$icon.png",
              fit: BoxFit.contain,
              width: 0.18 * AppSizes.dW,
              height: 0.18 * AppSizes.dW,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return const TransactionsScreen();
  }

  Widget _buildApplicationsTab() {
    return const ApplicationsScreen();
  }

  Widget _buildReferralTab() {
    return const ReferralScreen();
  }
}
