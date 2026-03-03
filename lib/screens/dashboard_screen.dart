import 'package:flutter/material.dart';
import 'package:janseva/main.dart';
import 'package:janseva/modules/wallet_module/provider/wallet_provider.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:janseva/modules/wallet_module/screens/withdraw_screen.dart';
import 'package:janseva/utils/theme_extension.dart';

import 'package:provider/provider.dart';
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
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
        return Container(key: const ValueKey(1), child: TransactionsScreen());
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

  Widget _buildTopTabItem(int index, String title) {
    final isSelected = _topTabIndex == index;
    return GestureDetector(
      onTap: () {
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
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/icons/avatars.jpg"),
            ),
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
        child: SingleChildScrollView(
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
                child: Row(
                  children: [
                    _buildTopTabItem(0, 'Bank'),
                    _buildTopTabItem(1, 'Fixed Deposit'),
                    _buildTopTabItem(2, 'Pay Bills'),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingL),
                child: Consumer<UserProvider>(
                  builder: (context, provider, child) {
                    var user = provider.currentUser;

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
                              '₹ ${transactionProvider.balanceDisplay.replaceAll('₹', '').trim()}', // Format to match UI
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
                          isPro: true, // Example, could be user.isMember
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
                                // isKycCompleted
                                //     ? Colors.green
                                //     : Colors.orange,
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
                                value: user?.isMember == true
                                    ? 'Active'
                                    : 'Guest',
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
                                setState(() {
                                  _currentIndex = 1; // Go to 'History'
                                });
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

                        // Recent Transactions List
                        // Note: Mocking data based on image UI, ideally you'd pull this from a Provider
                        TransactionListItem(
                          name: 'Sitaramjwarhari',
                          timestamp: 'Today, 02:30 PM',
                          amountText: '-₹ 250.00',
                          isNegative: true,
                        ),
                        TransactionListItem(
                          name: 'Meghashyam',
                          timestamp: 'Yesterday, 11:15 AM',
                          amountText: '-₹ 120.00',
                          isNegative: true,
                        ),
                        TransactionListItem(
                          name: 'Anirudh',
                          timestamp: '22 Jan, 09:45 PM',
                          amountText: '-₹ 500.00',
                          isNegative: true,
                        ),
                        TransactionListItem(
                          name: 'Lakshmi',
                          timestamp: '20 Jan, 04:20 PM',
                          amountText: '-₹ 130.00',
                          isNegative: true,
                        ),
                        // Added extra spacing at the bottom so content isn't hidden under FAB
                        const SizedBox(height: 80),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
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
