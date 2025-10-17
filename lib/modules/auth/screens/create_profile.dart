import 'package:flutter/material.dart';
import 'package:janseva/modules/auth/models/create_profile_params.dart';
import 'package:janseva/routes/navigator.dart';
import 'package:janseva/routes/routes.dart';
import 'package:provider/provider.dart';
import '../../../routes/arguments.dart';
import '../provider/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../components/components.dart';
import '../../../screens/kyc_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  // final CreateProfileArguments args;

  // const CreateProfileScreen({super.key, required this.args});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill phone number from previous screen and make it non-editable
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.currentUser != null) {
        _phoneController.text = authProvider.currentUser!.phoneNumber;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      var params = CreateProfileParams(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      // Update profile in auth provider
      await authProvider.createProfile(params);

      if (!mounted) return;

      if (authProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error!),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // Check if profile creation was successful
      if (authProvider.currentUser != null &&
          !authProvider.currentUser!.isNew) {
        // Update user provider with new profile
        userProvider.updateUser(authProvider.currentUser!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate to dashboard for existing users
        pushAndRemoveUntil(NamedRoutes.dashboard);
      } else {
        // Navigate to KYC for new users
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const KycScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSizes.paddingXL),

                    // Error Message
                    if (provider.error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(AppSizes.paddingM),
                        margin: const EdgeInsets.only(
                          bottom: AppSizes.paddingL,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusM),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: AppSizes.iconSizeS,
                            ),
                            const SizedBox(width: AppSizes.paddingS),
                            Expanded(
                              child: Text(
                                provider.error!,
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Header Section
                    FormSectionCard(
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
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
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow,
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person_add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingM),
                          Text(
                            'Complete Your Profile',
                            style: AppTextStyles.heading2,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSizes.paddingS),
                          Text(
                            'Please provide your basic information to continue',
                            style: AppTextStyles.body2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSizes.paddingXL),

                    // Profile Form
                    FormSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: AppSizes.paddingL),

                          // Full Name Field
                          CustomTextField(
                            controller: _nameController,
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            prefixIcon: Icons.person_outline,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              if (value.trim().length < 2) {
                                return 'Name must be at least 2 characters';
                              }
                              if (!RegExp(
                                r'^[a-zA-Z\s]+$',
                              ).hasMatch(value.trim())) {
                                return 'Name can only contain letters and spaces';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppSizes.paddingM),

                          // Email Field
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Email Address',
                            hintText: 'Enter your email address',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email address';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value.trim())) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppSizes.paddingM),

                          // Phone Number Field (Non-editable)
                          CustomTextField(
                            controller: _phoneController,
                            labelText: 'Phone Number',
                            hintText: 'Phone number',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            enabled: false, // Make it non-editable
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Phone number is required';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppSizes.paddingL),

                          // Create Profile Button
                          CustomButton(
                            onPressed: (_isLoading || provider.isLoading)
                                ? null
                                : _createProfile,
                            text: (_isLoading || provider.isLoading)
                                ? 'Creating Profile...'
                                : 'Create Profile',
                            isLoading: _isLoading || provider.isLoading,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSizes.paddingL),

                    // Info Card
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusM),
                        border: Border.all(
                          color: AppColors.info.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.info,
                                size: AppSizes.iconSizeS,
                              ),
                              const SizedBox(width: AppSizes.paddingS),
                              Text(
                                'Next Steps',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.paddingS),
                          Text(
                            'After creating your profile, you\'ll need to complete KYC verification to access all features.',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.info,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
