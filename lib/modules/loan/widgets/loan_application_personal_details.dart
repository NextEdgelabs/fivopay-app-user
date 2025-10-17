import 'package:flutter/material.dart';
import '../models/models.dart';
import 'loan_application_input_fields.dart';
import 'loan_application_section_header.dart';

class LoanApplicationPersonalDetailsWidget extends StatelessWidget {
  final LoanCategory loanCategory;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController panController;
  final TextEditingController aadharController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController pincodeController;

  const LoanApplicationPersonalDetailsWidget({
    Key? key,
    required this.loanCategory,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.panController,
    required this.aadharController,
    required this.addressController,
    required this.cityController,
    required this.pincodeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getLoanTypeColor(loanCategory.loanType);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoanApplicationSectionHeader(
            title: 'Personal Information',
            color: primaryColor,
          ),
          const SizedBox(height: 16),

          LoanApplicationInputField(
            controller: fullNameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            focusColor: primaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          LoanApplicationInputField(
            controller: emailController,
            label: 'Email Address',
            hint: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            focusColor: primaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          LoanApplicationInputField(
            controller: phoneController,
            label: 'Phone Number',
            hint: 'Enter your phone number',
            keyboardType: TextInputType.phone,
            focusColor: primaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length != 10) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          LoanApplicationInputField(
            controller: panController,
            label: 'PAN Number',
            hint: 'Enter your PAN number',
            focusColor: primaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your PAN number';
              }
              if (!RegExp(
                r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
              ).hasMatch(value.toUpperCase())) {
                return 'Please enter a valid PAN number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          LoanApplicationInputField(
            controller: aadharController,
            label: 'Aadhar Number',
            hint: 'Enter your Aadhar number',
            keyboardType: TextInputType.number,
            focusColor: primaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Aadhar number';
              }
              if (value.length != 12) {
                return 'Please enter a valid 12-digit Aadhar number';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          LoanApplicationSectionHeader(
            title: 'Address Details',
            color: primaryColor,
          ),
          const SizedBox(height: 16),

          LoanApplicationInputField(
            controller: addressController,
            label: 'Address',
            hint: 'Enter your complete address',
            maxLines: 2,
            focusColor: primaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: LoanApplicationInputField(
                  controller: cityController,
                  label: 'City',
                  hint: 'Enter your city',
                  focusColor: primaryColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: LoanApplicationInputField(
                  controller: pincodeController,
                  label: 'Pincode',
                  hint: 'Pincode',
                  keyboardType: TextInputType.number,
                  focusColor: primaryColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pincode';
                    }
                    if (value.length != 6) {
                      return 'Invalid pincode';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getLoanTypeColor(String loanType) {
    switch (loanType.toLowerCase()) {
      case 'personal':
        return Colors.blue;
      case 'home':
        return Colors.green;
      case 'car':
        return Colors.orange;
      case 'education':
        return Colors.purple;
      case 'business':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
