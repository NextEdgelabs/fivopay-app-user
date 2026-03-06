import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:janseva/utils/theme_extension.dart';

import '../providers/user_provider.dart';
import '../providers/referral_provider.dart';
import '../utils/constants.dart';

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
    final referralCode = "app.janseva/${user?.memberId ?? 'JNS1234567890'}";

    return Scaffold(
      backgroundColor: context.colors.bgColors,
      appBar: AppBar(
        title: Text(
          'Invite Friends',
          style: AppTextStyles.heading2.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8B5CF6), // Matches the purple in image title
          ),
        ),
        backgroundColor: context.colors.bgColors,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Referral Code Card
              _buildReferralCodeCard(context, referralCode),

              const SizedBox(height: AppSizes.sectionSpacing),

              // 2. Transactions History (Share Via row)
              Text(
                'Transactions History',
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              Row(
                children: [
                  Expanded(
                    child: _buildShareSquare(
                      context,
                      'Whatsapp',
                      Icons
                          .chat, // Can improve with font_awesome flutter if available, fallback to chat
                      const Color(0xFF22C55E),
                      () => _shareViaWhatsApp(referralCode),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: _buildShareSquare(
                      context,
                      'SMS',
                      Icons.sms_outlined,
                      const Color(0xFF8B5CF6),
                      () => _shareViaSMS(referralCode),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: _buildShareSquare(
                      context,
                      'More',
                      Icons.more_horiz,
                      const Color(0xFF6B7280),
                      () => _shareMore(referralCode),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.sectionSpacing),

              // 3. Referral Rewards List
              Text(
                'Referral Rewards',
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildRewardRowItem(
                      context,
                      title: 'For You',
                      subtitle: '₹100 bonus on each successful referral',
                      icon: Icons.person,
                      iconColor: const Color(0xFF6366F1),
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                    _buildRewardRowItem(
                      context,
                      title: 'For Friend',
                      subtitle: '₹50 welcome bonus on joining',
                      icon: Icons.person_add_alt_1,
                      iconColor: const Color(0xFF6366F1),
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                    _buildRewardRowItem(
                      context,
                      title: 'Extra Benefits',
                      subtitle: 'Priority support and exclusive offers',
                      icon: Icons.star,
                      iconColor: const Color(0xFFF59E0B),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.sectionSpacing),

              // 4. Your Referrals Stats
              Text(
                'Your Referrals',
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.paddingM),
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildReferralStatSquare(
                        context,
                        icon: Icons.person,
                        value: '${user?.referredUsers?.length ?? 0}',
                        label: 'Total Referrals',
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingM),
                    Expanded(
                      child: _buildReferralStatSquare(
                        context,
                        icon: Icons.person_add_alt_1,
                        value: '₹ ${(user?.referredUsers?.length ?? 0) * 100}',
                        label: 'Total Earnings',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Extra padding for bottom bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReferralCodeCard(BuildContext context, String referralCode) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Referral Code',
                      style: AppTextStyles.heading3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.heading,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Share your referral code with friends and earn rewards',
                      style: AppTextStyles.body2.copyWith(
                        color: context.colors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingL),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              border: Border.all(color: context.colors.border.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    referralCode,
                    style: AppTextStyles.body1.copyWith(
                      color: context.colors.text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: referralCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Referral code copied to clipboard'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Icon(
                    Icons.copy,
                    color: context.colors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareSquare(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingL),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: AppSizes.paddingM),
            Text(
              title,
              style: AppTextStyles.body2.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.heading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardRowItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          child: Icon(icon, color: iconColor, size: 24),
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
                  color: context.colors.heading,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.body2.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReferralStatSquare(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingL),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Light grayish-blue from image
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: const Color(0xFF6366F1).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 28),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.heading,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _shareViaWhatsApp(String referralCode) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('WhatsApp sharing will be implemented')),
    );
  }

  void _shareViaSMS(String referralCode) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('SMS sharing will be implemented')),
    );
  }

  void _shareMore(String referralCode) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('General sharing will be implemented')),
    );
  }
}
