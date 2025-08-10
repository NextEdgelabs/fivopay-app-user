import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/referral_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../components/components.dart';
import 'kyc_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'dateOfBirth': _dateOfBirthController.text.trim(),
      'gender': _genderController.text.trim(),
      'address': _addressController.text.trim(),
      'city': _cityController.text.trim(),
      'state': _stateController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'isMember': true,
    };

    final success = await authProvider.registerUser(userData);

    setState(() => _isLoading = false);

    if (success && mounted) {
      final user = authProvider.currentUser;
      if (user != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final referralProvider = Provider.of<ReferralProvider>(
          context,
          listen: false,
        );
        final transactionProvider = Provider.of<TransactionProvider>(
          context,
          listen: false,
        );
        userProvider.updateUserFromAuth(user);
        referralProvider.initializeReferral(user);
        transactionProvider.initialize(user);
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const KycScreen()),
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Registration failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createAccount),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator (modern)
            StepHeader(
              title: _getStepTitle(_currentStep),
              currentStep: _currentStep + 1,
              totalSteps: 3,
            ),

            // Step Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
              ),
              child: Text(
                _getStepTitle(_currentStep),
                style: AppTextStyles.heading2,
              ),
            ),

            const SizedBox(height: AppSizes.paddingL),

            // Form Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [_buildPersonalInfoStep(), _buildAddressStep()],
              ),
            ),

            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingL),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Text(AppStrings.back),
                      ),
                    ),
                  if (_currentStep > 0)
                    const SizedBox(width: AppSizes.paddingM),
                  Expanded(
                    child: CustomButton(
                      onPressed: _isLoading
                          ? null
                          : (_currentStep == 2
                                ? _submitRegistration
                                : _nextStep),
                      text: _isLoading
                          ? AppStrings.loading
                          : (_currentStep == 2
                                ? AppStrings.submit
                                : AppStrings.next),
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return AppStrings.personalInfo;
      case 1:
        return AppStrings.addressInfo;
      case 2:
        return AppStrings.nomineeInfo;
      default:
        return '';
    }
  }

  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.paddingM),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email Address',
              hintText: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.paddingM),
            CustomTextField(
              controller: _dateOfBirthController,
              labelText: 'Date of Birth',
              hintText: 'DD/MM/YYYY',
              prefixIcon: Icons.calendar_today,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(
                    const Duration(days: 6570),
                  ), // 18 years ago
                  firstDate: DateTime.now().subtract(
                    const Duration(days: 36500),
                  ), // 100 years ago
                  lastDate: DateTime.now().subtract(
                    const Duration(days: 6570),
                  ), // 18 years ago
                );
                if (date != null) {
                  _dateOfBirthController.text =
                      '${date.day}/${date.month}/${date.year}';
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your date of birth';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.paddingM),
            CustomTextField(
              controller: _genderController,
              labelText: 'Gender',
              hintText: 'Select your gender',
              prefixIcon: Icons.person_outline,
              readOnly: true,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                  ),
                  builder: (context) {
                    String temp = _genderController.text;
                    return StatefulBuilder(
                      builder: (context, setSheet) {
                        return Padding(
                          padding: const EdgeInsets.all(AppSizes.paddingL),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Gender',
                                style: AppTextStyles.heading3,
                              ),
                              const SizedBox(height: AppSizes.paddingM),
                              Wrap(
                                spacing: AppSizes.paddingM,
                                runSpacing: AppSizes.paddingS,
                                children: ['Male', 'Female', 'Other'].map((g) {
                                  final selected = temp == g;
                                  return ChoiceChip(
                                    label: Text(g),
                                    selected: selected,
                                    onSelected: (_) {
                                      setSheet(() => temp = g);
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: AppSizes.paddingL),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.paddingM),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _genderController.text = temp;
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Select'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your gender';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Column(
        children: [
          CustomTextField(
            controller: _addressController,
            labelText: 'Address',
            hintText: 'Enter your complete address',
            prefixIcon: Icons.home,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.paddingM),
          CustomTextField(
            controller: _cityController,
            labelText: 'City',
            hintText: 'Enter your city',
            prefixIcon: Icons.location_city,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.paddingM),
          CustomTextField(
            controller: _stateController,
            labelText: 'State',
            hintText: 'Enter your state',
            prefixIcon: Icons.map,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your state';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.paddingM),
          CustomTextField(
            controller: _pincodeController,
            labelText: 'Pincode',
            hintText: 'Enter your pincode',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.pin_drop,
            maxLength: 6,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your pincode';
              }
              if (value.length != 6) {
                return 'Please enter a valid 6-digit pincode';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
