import 'package:flutter/material.dart';
import 'package:janseva/main.dart';
import 'package:janseva/modules/buyShares/screens/buysharesScreen.dart';
import 'package:janseva/modules/loan/screens/components/adhaar_verify.dart';
import 'package:janseva/modules/loan/screens/loan_categories_screen.dart';
import 'package:janseva/modules/wallet_module/provider/wallet_provider.dart';
import 'package:janseva/routes/arguments.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:janseva/modules/wallet_module/screens/withdraw_screen.dart';
import 'package:janseva/services/tts_service.dart';
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
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          _buildTransactionsTab(),
          _buildApplicationsTab(),
          _buildReferralTab(),
          // _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        height: 70, // More spacious
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
          // NavigationDestination(
          //   icon: Icon(Icons.person_outline, size: 24),
          //   selectedIcon: Icon(Icons.person, size: 24),
          //   label: 'Profile',
          // ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    // final user = Provider.of<UserProvider>(context).currentUser;
    final transactionProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await TTSService.speak("जनसेवा वॉलेट में,    500 रुपये.  मिले");
          // .then((e)async{
          //   await TTSService.stop();
          // });

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AdhaarVerifyScreen(
          //     args: AadharVerifyArguments(stepNumber: 1),
          //   )),
          // );
        },
      ),
      appBar: AppBar(
        title: Text(
          AppStrings.dashboard,
          style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   iconSize: 26,
        //   onPressed: () {
        //     // TODO: Implement menu
        //   },
        // ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.notifications_outlined),
          //   iconSize: 26,
          //   onPressed: () {
          //     // TODO: Implement notifications
          //   },
          // ),
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
                        // Navigate to membership registration screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BuySharesScreen(),
                          ),
                        );
                      },
                      showCloseButton: true,
                      onClose: () {
                        // User can dismiss the banner temporarily
                        setState(() {
                          // You could store a preference here to not show again for a while
                        });
                      },
                    ),

                  // Welcome Card
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingXL),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusL,
                      ), // Reduced for minimalism
                      border: Border.all(color: AppColors.border),
                      // Minimal shadow
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                // Sky blue gradient
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryDark,
                                    AppColors.primaryLight,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusL,
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: AppSizes.paddingL),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello ${user?.name ?? 'Member'}',
                                    style: AppTextStyles.heading3,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Welcome back!',
                                    style: AppTextStyles.body2.copyWith(
                                      color: AppColors.textSecondary,
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
                              child: _buildInfoCard(
                                'Account Number',
                                user?.memberId ?? 'JS001234567',
                                Icons.account_balance,
                              ),
                            ),
                            const SizedBox(width: AppSizes.paddingL),
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

                  const SizedBox(height: AppSizes.sectionSpacing),

                  // Balance Card (Priority - Show first)
                  BalanceCard(
                    title: AppStrings.balance,
                    amountText: transactionProvider.balanceDisplay,
                    onPrimary: () => push(NamedRoutes.depositScreen),

                    // _showDepositDialog(context, transactionProvider),
                    onSecondary: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WithdrawScreen(),
                      ),
                    ),
                    // _showWithdrawDialog(context, transactionProvider),
                  ),

                  const SizedBox(height: AppSizes.sectionSpacing),

                  // Membership Status
                  SectionHeader(
                    title: 'Membership Status',
                    subtitle: 'Your account information',
                  ),
                  const SizedBox(height: AppSizes.paddingL),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.verified_user,
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
                          icon: Icons.person,
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

                  // Quick Actions (Priority - Show before savings)
                  SectionHeader(
                    title: 'Quick Actions',
                    subtitle: 'Access your services',
                  ),
                  const SizedBox(height: AppSizes.paddingL),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSizes.cardSpacing,
                    mainAxisSpacing: AppSizes.cardSpacing,
                    childAspectRatio: 1.1, // Less square, more spacious
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
                        title: 'Shares',
                        icon: Icons.auto_graph_sharp,
                        color: AppColors.success,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BuySharesScreen(),
                            ),
                          );
                          // TODO: Implement support
                        },
                      ),
                      ActionTile(
                        title: 'Loan',
                        icon: Icons.credit_card,
                        color: AppColors.info,
                        onTap: () {
                          push(NamedRoutes.loanCategoryScreen);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const LoanApplicationScreen(),
                          //   ),
                          // );
                        },
                      ),
                      // ActionTile(
                      //   title: 'Loan V2',
                      //   icon: Icons.credit_card,
                      //   color: AppColors.info,
                      //   onTap: () {
                      //     push(NamedRoutes.loanProductScreen);
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //     builder: (context) => const LoanApplicationScreen(),
                      //     //   ),
                      //     // );
                      //   },
                      // ),
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
              );
            },
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
    WalletProvider transactionProvider,
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
                await transactionProvider.addMoney(amount: amount);
                // if (success && mounted) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(
                //         'Successfully deposited ₹${amount.toStringAsFixed(2)}',
                //       ),
                //       backgroundColor: AppColors.success,
                //     ),
                //   );
                // } else if (mounted) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(
                //         transactionProvider.error ?? 'Deposit failed',
                //       ),
                //       backgroundColor: AppColors.error,
                //     ),
                //   );
                // }
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
    WalletProvider transactionProvider,
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
                final success = await transactionProvider.withdrawMoney(
                  amount: amount,
                );
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
