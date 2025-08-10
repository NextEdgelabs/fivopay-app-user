import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import '../utils/constants.dart';
import 'custom_text_field.dart';

class RelativeSelectorWidget extends StatefulWidget {
  const RelativeSelectorWidget({super.key});

  @override
  State<RelativeSelectorWidget> createState() => _RelativeSelectorWidgetState();
}

class _RelativeSelectorWidgetState extends State<RelativeSelectorWidget> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  final List<Map<String, String>> _immediateRelations = [
    {'value': 'father', 'label': 'Father'},
    {'value': 'mother', 'label': 'Mother'},
    {'value': 'spouse', 'label': 'Spouse'},
    {'value': 'son', 'label': 'Son'},
    {'value': 'daughter', 'label': 'Daughter'},
    {'value': 'brother', 'label': 'Brother'},
    {'value': 'sister', 'label': 'Sister'},
  ];

  @override
  void initState() {
    super.initState();
    final loanProvider = context.read<LoanProvider>();
    if (loanProvider.relativeName != null) {
      _nameController.text = loanProvider.relativeName!;
    }
    if (loanProvider.relativePhone != null) {
      _phoneController.text = loanProvider.relativePhone!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateRelativeDetails() {
    final loanProvider = context.read<LoanProvider>();
    loanProvider.setRelativeDetails(
      relation: loanProvider.selectedRelation,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, loanProvider, child) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusXL),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Text(
                    'Relative Information',
                    style: AppTextStyles.heading3,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
              Text(
                'You can only apply for loans on behalf of immediate family members',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.paddingL),
              
              // Relationship dropdown
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonFormField<String>(
                  value: loanProvider.selectedRelation,
                  decoration: InputDecoration(
                    labelText: 'Relationship',
                    prefixIcon: Icon(
                      Icons.family_restroom,
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingL,
                      vertical: AppSizes.paddingM,
                    ),
                  ),
                  hint: const Text('Select relationship'),
                  items: _immediateRelations.map((relation) {
                    return DropdownMenuItem<String>(
                      value: relation['value'],
                      child: Text(relation['label']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    loanProvider.setRelativeDetails(
                      relation: value,
                      name: _nameController.text.trim(),
                      phone: _phoneController.text.trim(),
                    );
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select relationship';
                    }
                    return null;
                  },
                ),
              ),
              
              const SizedBox(height: AppSizes.paddingL),
              
              // Name field
              CustomTextField(
                controller: _nameController,
                labelText: 'Relative\'s Full Name',
                hintText: 'Enter full name as per documents',
                prefixIcon: Icons.person,
                onChanged: (_) => _updateRelativeDetails(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter relative\'s name';
                  }
                  if (value.trim().split(' ').length < 2) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppSizes.paddingL),
              
              // Phone field
              CustomTextField(
                controller: _phoneController,
                labelText: 'Relative\'s Phone Number',
                hintText: 'Enter 10-digit mobile number',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: (_) => _updateRelativeDetails(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.length != 10) {
                    return 'Please enter valid 10-digit number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppSizes.paddingL),
              
              // Info card
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  border: Border.all(
                    color: AppColors.info.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: AppSizes.paddingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Important',
                            style: AppTextStyles.body2.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingXS),
                          Text(
                            'The relative must provide their PAN and Aadhaar for verification. They will receive OTP on their registered mobile number.',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}