import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../modules/auth/provider/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../modules/auth/screens/login_screen.dart';
import '../widgets/section_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user != null) {
      _nameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneNumber;
      _addressController.text = user.address ?? '';
    }
  }

  Future<void> _updateProfile() async {
    // setState(() => _isLoading = true);

    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final userData = {
    //   'name': _nameController.text.trim(),
    //   'email': _emailController.text.trim(),
    //   'address': _addressController.text.trim(),
    // };

    // // final success = await userProvider.updateProfile(userData);

    // setState(() => _isLoading = false);

    // if (success && mounted) {
    //   setState(() => _isEditing = false);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Profile updated successfully'),
    //       backgroundColor: AppColors.success,
    //     ),
    //   );
    // } else if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(userProvider.error ?? 'Failed to update profile'),
    //       backgroundColor: AppColors.error,
    //     ),
    //   );
    // }
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() => _isEditing = true);
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingL),
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
                  children: [
                    Container(
                      width: 100,
                      height: 100,
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
                        borderRadius: BorderRadius.circular(50),
                        // Minimal shadow
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingM),
                    Text(user?.name ?? 'Member', style: AppTextStyles.heading2),
                    Text(user?.phoneNumber ?? '', style: AppTextStyles.body2),
                    if (user?.isMember == true) ...[
                      const SizedBox(height: AppSizes.paddingS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingM,
                          vertical: AppSizes.paddingXS,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusS),
                          border: Border.all(
                            color: AppColors.success.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'Active Member',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              // Account Information
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
                    const SectionHeader(title: 'Account Information'),
                    const SizedBox(height: AppSizes.paddingM),

                    if (_isEditing) ...[
                      CustomTextField(
                        controller: _nameController,
                        labelText: 'Full Name',
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      CustomTextField(
                        controller: _addressController,
                        labelText: 'Address',
                        prefixIcon: Icons.home,
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSizes.paddingL),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() => _isEditing = false);
                                _loadUserData();
                              },
                              child: Text(AppStrings.cancel),
                            ),
                          ),
                          const SizedBox(width: AppSizes.paddingM),
                          Expanded(
                            child: CustomButton(
                              onPressed: _isLoading ? null : _updateProfile,
                              text: _isLoading
                                  ? AppStrings.loading
                                  : AppStrings.save,
                              isLoading: _isLoading,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      _buildInfoRow('Full Name', user?.name ?? 'Not provided'),
                      _buildInfoRow('Email', user?.email ?? 'Not provided'),
                      _buildInfoRow('Phone', user?.phoneNumber ?? ''),
                      _buildInfoRow('Address', user?.address ?? 'Not provided'),
                      _buildInfoRow('City', user?.city ?? 'Not provided'),
                      _buildInfoRow('State', user?.state ?? 'Not provided'),
                      _buildInfoRow('Pincode', user?.pincode ?? 'Not provided'),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.paddingL),

              // Membership Information
              if (user?.isMember == true) ...[
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
                      const SectionHeader(title: 'Membership Details'),
                      const SizedBox(height: AppSizes.paddingM),
                      _buildInfoRow(
                        'Account Number',
                        user?.accountNumber ?? '',
                      ),
                      _buildInfoRow('Member Since', user?.memberSince ?? ''),
                      _buildInfoRow(
                        'Balance',
                        '₹${user?.balance?.toStringAsFixed(2) ?? '0.00'}',
                      ),
                      _buildInfoRow('Referral Code', user?.referralCode ?? ''),
                      if (user?.referredBy != null)
                        _buildInfoRow('Referred By', user!.referredBy!),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.paddingL),
              ],

              // Nominee Information
              if (user?.nomineeName != null) ...[
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
                      const SectionHeader(title: 'Nominee Information'),
                      const SizedBox(height: AppSizes.paddingM),
                      _buildInfoRow('Nominee Name', user?.nomineeName ?? ''),
                      _buildInfoRow(
                        'Relationship',
                        user?.nomineeRelation ?? '',
                      ),
                      _buildInfoRow('Nominee Phone', user?.nomineePhone ?? ''),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.paddingL),
              ],

              // Actions
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
                    const SectionHeader(title: 'Actions'),
                    const SizedBox(height: AppSizes.paddingM),
                    _buildActionTile('Change Password', Icons.lock, () {
                      // TODO: Implement change password
                    }),
                    _buildActionTile('Privacy Policy', Icons.privacy_tip, () {
                      // TODO: Implement privacy policy
                    }),
                    _buildActionTile('Terms of Service', Icons.description, () {
                      // TODO: Implement terms of service
                    }),
                    _buildActionTile('Support', Icons.support_agent, () {
                      // TODO: Implement support
                    }),
                    _buildActionTile(
                      'Logout',
                      Icons.logout,
                      _logout,
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.textSecondary,
        size: AppSizes.iconSizeM,
      ),
      title: Text(
        title,
        style: AppTextStyles.body1.copyWith(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textLight,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
