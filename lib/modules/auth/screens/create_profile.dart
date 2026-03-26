import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:janseva/modules/auth/models/create_profile_params.dart';
import 'package:janseva/modules/fd_rd/model/branch_model.dart';
import 'package:janseva/providers/user_provider.dart';
import 'package:janseva/screens/kyc_screen.dart';
import 'package:janseva/screens/select_branch_screen.dart';
import 'package:janseva/utils/constants.dart';
import 'package:janseva/widgets/custom_button.dart';
import 'package:janseva/widgets/custom_text_field.dart';

import '../../../components/components.dart';
import '../../../utils/theme_extension.dart';
import '../provider/auth_provider.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedBranchId;
  bool _isLoading = false;
  bool _hasTriedSubmit = false;
  String? _localError;

  bool get _hasSelectedBranch =>
      _selectedBranchId != null && _selectedBranchId!.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final userProvider = context.read<UserProvider>();

      authProvider.clearError();

      final currentUser = authProvider.currentUser;
      if (currentUser != null) {
        _phoneController.text = currentUser.phoneNumber;
      }

      _selectedBranchId = userProvider.selectedBranch?.id;
      if (mounted) {
        setState(() {});
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

  Future<void> _openBranchSelection() async {
    FocusScope.of(context).unfocus();

    final selected = await Navigator.of(context).push<BranchModel>(
      MaterialPageRoute(builder: (_) => const SelectUserBranch()),
    );

    if (!mounted || selected == null) return;

    context.read<UserProvider>().selectBranch(selected);
    setState(() {
      _selectedBranchId = selected.id;
      _localError = null;
    });
  }

  Future<void> _createProfile() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();
    final messenger = ScaffoldMessenger.maybeOf(context);
    final navigator = Navigator.of(context);

    setState(() {
      _hasTriedSubmit = true;
      _localError = null;
    });

    authProvider.clearError();

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid || !_hasSelectedBranch) {
      if (!_hasSelectedBranch) {
        messenger?.showSnackBar(
          const SnackBar(
            content: Text('Please select your branch to continue.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final params = CreateProfileParams(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        branchId: _selectedBranchId,
      );

      await authProvider.createProfile(params);

      if (!mounted) return;

      if (authProvider.error != null && authProvider.error!.trim().isNotEmpty) {
        setState(() => _localError = authProvider.error);
        messenger?.showSnackBar(
          SnackBar(
            content: Text(authProvider.error!),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (authProvider.currentUser == null) {
        setState(() {
          _localError =
              'We could not verify your profile response. Please try again.';
        });
        return;
      }

      await userProvider.updateUser(authProvider.currentUser!);

      if (!mounted) return;

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const KycScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _localError = 'Something went wrong. Please try again.');
      messenger?.showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgColors,
      appBar: AppBar(
        title: const Text('Create Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Consumer2<AuthProvider, UserProvider>(
          builder: (context, authProvider, userProvider, _) {
            final selectedBranch = userProvider.selectedBranch;
            final globalError = _localError ?? authProvider.error;
            final showBranchError = _hasTriedSubmit && !_hasSelectedBranch;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // _buildHeaderCard(context),
                    const SizedBox(height: AppSizes.paddingL),
                    if (globalError != null &&
                        globalError.trim().isNotEmpty) ...[
                      _buildErrorBanner(globalError),
                      const SizedBox(height: AppSizes.paddingL),
                    ],
                    FormSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Details',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: AppSizes.paddingL),
                          CustomTextField(
                            controller: _nameController,
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            prefixIcon: Icons.person_outline,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (_) {
                              if (_localError != null) {
                                setState(() => _localError = null);
                              }
                            },
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
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Email Address',
                            hintText: 'Enter your email address',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (_) {
                              if (_localError != null) {
                                setState(() => _localError = null);
                              }
                            },
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
                          CustomTextField(
                            controller: _phoneController,
                            labelText: 'Phone Number',
                            hintText: 'Phone number',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            enabled: false,
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Phone number is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                    FormSectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Branch Selection',
                            style: AppTextStyles.heading3,
                          ),
                          const SizedBox(height: AppSizes.paddingM),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSizes.paddingM),
                            decoration: BoxDecoration(
                              color: context.colors.cardBackground,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusM,
                              ),
                              border: Border.all(
                                color: showBranchError
                                    ? AppColors.error
                                    : AppColors.primary.withOpacity(0.2),
                                width: showBranchError ? 1.3 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_balance_outlined,
                                      color: showBranchError
                                          ? AppColors.error
                                          : AppColors.primary,
                                      size: AppSizes.iconSizeS,
                                    ),
                                    const SizedBox(width: AppSizes.paddingS),
                                    Expanded(
                                      child: Text(
                                        selectedBranch == null
                                            ? 'No branch selected yet'
                                            : 'Selected Branch: ${selectedBranch.branchName ?? '-'}',
                                        style: AppTextStyles.body2.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (selectedBranch != null) ...[
                                  const SizedBox(height: AppSizes.paddingXS),
                                  Text(
                                    'Code: ${selectedBranch.branchCode ?? '-'}',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                                const SizedBox(height: AppSizes.paddingS),
                                OutlinedButton.icon(
                                  onPressed: _openBranchSelection,
                                  icon: Icon(
                                    selectedBranch == null
                                        ? Icons.add_location_alt_outlined
                                        : Icons.swap_horiz,
                                  ),
                                  label: Text(
                                    selectedBranch == null
                                        ? 'Select Branch'
                                        : 'Change Branch',
                                  ),
                                ),
                                if (showBranchError) ...[
                                  const SizedBox(height: AppSizes.paddingXS),
                                  Text(
                                    'Branch selection is required.',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                    CustomButton(
                      onPressed: (_isLoading || authProvider.isLoading)
                          ? null
                          : _createProfile,
                      text: (_isLoading || authProvider.isLoading)
                          ? 'Creating Profile...'
                          : 'Create Profile',
                      isLoading: _isLoading || authProvider.isLoading,
                    ),
                    const SizedBox(height: AppSizes.paddingL),
                    _buildInfoBanner(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget _buildHeaderCard(BuildContext context) {
  //   return FormSectionCard(
  //     child: Column(
  //       children: [
  //         Container(
  //           width: 64,
  //           height: 64,
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               colors: [AppColors.primaryDark, AppColors.primaryLight],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             ),
  //             borderRadius: BorderRadius.circular(AppSizes.radiusL),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: AppColors.shadow,
  //                 blurRadius: 12,
  //                 offset: const Offset(0, 4),
  //               ),
  //             ],
  //           ),
  //           child: const Icon(Icons.person_add, color: Colors.white, size: 30),
  //         ),
  //         const SizedBox(height: AppSizes.paddingM),
  //         Text(
  //           'Complete Your Profile',
  //           style: AppTextStyles.heading2,
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: AppSizes.paddingXS),
  //         Text(
  //           'Fill your details and choose a branch to continue to KYC.',
  //           style: AppTextStyles.body2,
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: AppSizes.paddingM),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             _buildStepChip('Profile', true),
  //             const SizedBox(width: AppSizes.paddingS),
  //             _buildStepChip('KYC', false),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildStepChip(String label, bool active) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: AppSizes.paddingM,
  //       vertical: AppSizes.paddingXS,
  //     ),
  //     decoration: BoxDecoration(
  //       color: active ? AppColors.primary.withOpacity(0.12) : AppColors.surface,
  //       borderRadius: BorderRadius.circular(AppSizes.radiusL),
  //       border: Border.all(
  //         color: active ? AppColors.primary.withOpacity(0.4) : AppColors.border,
  //       ),
  //     ),
  //     child: Text(
  //       label,
  //       style: AppTextStyles.caption.copyWith(
  //         color: active ? AppColors.primary : AppColors.textSecondary,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.error.withOpacity(0.35)),
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
              message,
              style: AppTextStyles.body2.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
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
                'Next Step',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            'After profile creation, you will continue to KYC verification.',
            style: AppTextStyles.caption.copyWith(color: AppColors.info),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
