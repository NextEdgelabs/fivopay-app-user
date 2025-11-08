import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/user_provider.dart';
import '../providers/referral_provider.dart';
import '../utils/constants.dart';
import '../components/components.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;
    final referralProvider = Provider.of<ReferralProvider>(context);
    final referralCode = "app.janseva/${user?.memberId}";

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.inviteFriends)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Referral Code Card
              FormSectionCard(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusL),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    Text(
                      AppStrings.referralCode,
                      style: AppTextStyles.heading3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.paddingS),
                    Text(
                      'Share your referral code with friends and earn rewards!',
                      style: AppTextStyles.body2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.paddingL),

                    // Referral Code Display
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              referralCode,
                              style: AppTextStyles.heading3.copyWith(
                                color: AppColors.primary,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: referralCode),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Referral code copied to clipboard',
                                  ),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy),
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              // Share Options
              Text('Share via', style: AppTextStyles.heading3),
              const SizedBox(height: AppSizes.paddingM),

              Row(
                children: [
                  Expanded(
                    child: _buildShareOption(
                      'WhatsApp',
                      Icons.chat,
                      AppColors.success,
                      () => _shareViaWhatsApp(referralCode),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: _buildShareOption(
                      'SMS',
                      Icons.sms,
                      AppColors.info,
                      () => _shareViaSMS(referralCode),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: _buildShareOption(
                      'More',
                      Icons.more_horiz,
                      AppColors.textSecondary,
                      () => _shareMore(referralCode),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.paddingL),

              // Referral Rewards
              FormSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          color: AppColors.secondary,
                          size: AppSizes.iconSizeM,
                        ),
                        const SizedBox(width: AppSizes.paddingS),
                        Text(
                          AppStrings.referralRewards,
                          style: AppTextStyles.heading3,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    _buildRewardItem(
                      'For You',
                      '₹100 bonus on each successful referral',
                      Icons.person,
                      AppColors.primary,
                    ),
                    const SizedBox(height: AppSizes.paddingS),
                    _buildRewardItem(
                      'For Friend',
                      '₹50 welcome bonus on joining',
                      Icons.person_add,
                      AppColors.secondary,
                    ),
                    const SizedBox(height: AppSizes.paddingS),
                    _buildRewardItem(
                      'Extra Benefits',
                      'Priority support and exclusive offers',
                      Icons.star,
                      AppColors.warning,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              // Referral Statistics
              FormSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Referrals', style: AppTextStyles.heading3),
                    const SizedBox(height: AppSizes.paddingM),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Referrals',
                            '${user?.referredUsers?.length ?? 0}',
                            Icons.people,
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSizes.paddingM),
                        Expanded(
                          child: _buildStatCard(
                            'Total Earnings',
                            '₹${(user?.referredUsers?.length ?? 0) * 100}',
                            Icons.account_balance_wallet,
                            AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              // Referred Users List
              if (user?.referredUsers != null &&
                  user!.referredUsers!.isNotEmpty) ...[
                Text('Referred Users', style: AppTextStyles.heading3),
                const SizedBox(height: AppSizes.paddingM),
                FormSectionCard(
                  child: Column(
                    children: user.referredUsers!.map((userId) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text(
                            userId.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text('User $userId'),
                        subtitle: Text('Joined via your referral'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingS,
                            vertical: AppSizes.paddingXS,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusS,
                            ),
                          ),
                          child: Text(
                            '₹100',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareOption(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              children: [
                Icon(icon, color: color, size: AppSizes.iconSizeL),
                const SizedBox(height: AppSizes.paddingS),
                Text(
                  title,
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewardItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: AppSizes.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(description, style: AppTextStyles.body2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSizes.iconSizeM),
          const SizedBox(height: AppSizes.paddingS),
          Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
          Text(
            title,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _shareViaWhatsApp(String referralCode) {
    // Placeholder for integration
    // TODO: Implement WhatsApp sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('WhatsApp sharing will be implemented'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _shareViaSMS(String referralCode) {
    // Placeholder for integration
    // TODO: Implement SMS sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('SMS sharing will be implemented'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _shareMore(String referralCode) {
    // Placeholder for integration
    // TODO: Implement general sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('General sharing will be implemented'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
