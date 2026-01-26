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
import '../widgets/balance_card.dart';
import '../widgets/membership_banner.dart';
import 'referral_screen.dart';
import 'profile_screen.dart';
import 'fixed_deposit_screen.dart';
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
  // Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
    //   CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    // );
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

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: _buildCustomNavigationBar(),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return Container(key: const ValueKey(0), child: _buildHomeTab());
      case 1:
        return Container(key: const ValueKey(1), child: TransactionsScreen());
      case 2:
        return Container(
          key: const ValueKey(2),
          child: _buildApplicationsTab(),
        );
      case 3:
        return Container(key: const ValueKey(3), child: _buildReferralTab());
      default:
        return Container(key: const ValueKey(0), child: _buildHomeTab());
    }
  }

  Widget _buildCustomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.bgColors,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(
                1,
                Icons.receipt_long_outlined,
                Icons.receipt_long,
                'History',
              ),
              _buildNavItem(
                2,
                Icons.description_outlined,
                Icons.description,
                'Application',
              ),
              _buildNavItem(3, Icons.share_outlined, Icons.share, 'Refer'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData selectedIcon,
    String label,
  ) {
    final bool isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
            _animationController?.reset();
            _animationController?.forward();
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected
                    ? bContext.colors.famerStrokeOrange
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSelected ? selectedIcon : icon,
                size: 22,
                color: isSelected
                    ? context.colors.brandColor
                    : AppColors.textLight,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? context.colors.brandColor
                    : AppColors.textLight,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  //             ),
  //             child: Icon(
  //               isSelected ? selectedIcon : icon,
  //               size: 24,
  //               color: isSelected ? AppColors.primary : AppColors.textLight,
  //             ),
  //           ),
  //           const SizedBox(height: 4),
  //           AnimatedDefaultTextStyle(
  //             duration: const Duration(milliseconds: 200),
  //             style: TextStyle(
  //               fontSize: 11,
  //               fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
  //               color: isSelected ? AppColors.primary : AppColors.textLight,
  //             ),
  //             child: Text(label),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  // );
}

Widget _buildHomeTab() {
  final transactionProvider = Provider.of<WalletProvider>(bContext);

  return Scaffold(
    // backgroundColor: Color.fromARGB(255, 212, 212, 212),
    appBar: AppBar(
      title: Text(
        'FIVOPAY',
        style: AppTextStyles.heading2.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      elevation: 0,
      backgroundColor: bContext.colors.bgColors,
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

                  // backgroundColor: AppColors.primary,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/icons/avatars.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  // userName.isNotEmpty
                  //     ? Text(
                  //         userName[0].toUpperCase(),
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 16,
                  //         ),
                  //       )
                  //     : const Icon(
                  //         Icons.person,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ),
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
                      // setState(() {});
                    },
                  ),

                // User Info Card
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Container(
                        //   width: 56,
                        //   height: 56,
                        //   decoration: BoxDecoration(
                        //     gradient: LinearGradient(
                        //       colors: [
                        //         context.colors.gradientOne,
                        //         context.colors.gradientTwo,
                        //       ],
                        //       begin: Alignment.topLeft,
                        //       end: Alignment.bottomRight,
                        //     ),
                        //     borderRadius: BorderRadius.circular(
                        //       AppSizes.radiusL,
                        //     ),
                        //   ),
                        //   child: Center(
                        //     child:
                        //         user?.name != null && user!.name!.isNotEmpty
                        //         ? Text(
                        //             user.name![0].toUpperCase(),
                        //             style: const TextStyle(
                        //               color: Colors.white,
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 24,
                        //             ),
                        //           )
                        //         : const Icon(
                        //             Icons.person,
                        //             color: Colors.white,
                        //             size: 32,
                        //           ),
                        //   ),
                        // ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.radiusL),
                          child: Image.asset(
                            "assets/icons/avatars.jpg",
                            fit: BoxFit.cover,
                            width: 56,
                            height: 56,
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
                SectionHeader(title: 'Your Account Information', subtitle: ''),
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
                      value: 'Fixed Deposit',
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
                      value: 'Pay Bills',
                      icon: "pay",
                      color: AppColors.warning,
                      onTap: () {
                        // TODO: Implement bill payment
                      },
                    ),
                    StatCard(
                      value: 'Shares',
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
                      value: 'Loan',
                      icon: "loan",
                      color: AppColors.info,
                      onTap: () {
                        push(NamedRoutes.loanCategoryScreen);
                      },
                    ),
                    StatCard(
                      value: 'Support',
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
      color: bContext.colors.specialCard,
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

// Widget _buildTransactionsTab() {
//   return const;
// }

Widget _buildApplicationsTab() {
  return const ApplicationsScreen();
}

Widget _buildReferralTab() {
  return const ReferralScreen();
}
