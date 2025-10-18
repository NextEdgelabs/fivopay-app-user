import 'package:flutter/material.dart';
import 'package:janseva/modules/loan/widgets/aadhaar_verification_widget.dart';
import 'package:janseva/widgets/pan_verification_widget.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/loan_provider.dart';
import 'loan_application_input_fields.dart';
import 'loan_application_section_header.dart';

class LoanApplicationPersonalDetailsWidget extends StatefulWidget {
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
  State<LoanApplicationPersonalDetailsWidget> createState() =>
      _LoanApplicationPersonalDetailsWidgetState();
}

class _LoanApplicationPersonalDetailsWidgetState
    extends State<LoanApplicationPersonalDetailsWidget> {
  final _personalFormKey = GlobalKey<FormState>();
  bool _useSameAsAadhaar = false;

  void _toggleAddressSource(bool? value) {
    setState(() {
      _useSameAsAadhaar = value ?? false;
      if (_useSameAsAadhaar) {
        _fillAddressFromAadhaar();
      } else {
        _clearAddressFields();
      }
    });
  }

  void _fillAddressFromAadhaar() {
    final loanProvider = context.read<LoanProvider>();
    final aadhaarDetails = loanProvider.aadhaarDetails;

    if (aadhaarDetails != null && aadhaarDetails['address'] != null) {
      final address = aadhaarDetails['address'] as String;
      // Parse address and fill fields
      widget.addressController.text = address;

      // Update provider data for validation
      loanProvider.updateApplicationData('address', address);

      // Try to extract city and pincode from address if possible
      final addressParts = address.split(',');
      if (addressParts.length >= 2) {
        // Try to find pincode (6 digits)
        final pincodeRegex = RegExp(r'\b\d{6}\b');
        final pincodeMatch = pincodeRegex.firstMatch(address);
        if (pincodeMatch != null) {
          final pincode = pincodeMatch.group(0) ?? '';
          widget.pincodeController.text = pincode;
          // Update provider data for validation
          loanProvider.updateApplicationData('pincode', pincode);
        }

        // Extract city (usually before pincode or last meaningful part)
        for (int i = addressParts.length - 1; i >= 0; i--) {
          final part = addressParts[i].trim();
          if (part.isNotEmpty && !RegExp(r'^\d+$').hasMatch(part)) {
            widget.cityController.text = part;
            // Update provider data for validation
            loanProvider.updateApplicationData('city', part);
            break;
          }
        }
      }
    }
  }

  void _clearAddressFields() {
    widget.addressController.clear();
    widget.cityController.clear();
    widget.pincodeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getLoanTypeColor(widget.loanCategory.loanType);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Consumer<LoanProvider>(
        builder: (context, loanProvider, child) {
          // Trigger form validation if requested
          if (loanProvider.shouldValidateForms) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _personalFormKey.currentState?.validate();
            });
          }

          return Form(
            key: _personalFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoanApplicationSectionHeader(
                  title: 'Personal Information',
                  color: primaryColor,
                ),
                const SizedBox(height: 16),

                // Show any validation errors from provider
                if (loanProvider.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loanProvider.errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Verification Status Summary
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.verified_user,
                            color: primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Verification Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildVerificationStatusItem(
                        'PAN Verification',
                        loanProvider.isPanVerified,
                      ),
                      _buildVerificationStatusItem(
                        'Aadhaar Verification',
                        loanProvider.isAadhaarVerified,
                      ),
                    ],
                  ),
                ),

                LoanApplicationInputField(
                  controller: widget.fullNameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  focusColor: primaryColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (value.trim().length < 2) {
                      return 'Please enter a valid full name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final loanProvider = context.read<LoanProvider>();
                    loanProvider.updateApplicationData('fullName', value);
                  },
                ),
                const SizedBox(height: 16),

                LoanApplicationInputField(
                  controller: widget.emailController,
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
                  onChanged: (value) {
                    final loanProvider = context.read<LoanProvider>();
                    loanProvider.updateApplicationData('email', value);
                  },
                ),
                const SizedBox(height: 16),

                LoanApplicationInputField(
                  controller: widget.phoneController,
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
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Phone number should contain only digits';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final loanProvider = context.read<LoanProvider>();
                    loanProvider.updateApplicationData('phone', value);
                  },
                ),
                const SizedBox(height: 16),
                const PANVerificationWidget(),
                // LoanApplicationInputField(
                //   controller: panController,
                //   label: 'PAN Number',
                //   hint: 'Enter your PAN number',
                //   focusColor: primaryColor,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter your PAN number';
                //     }
                //     if (!RegExp(
                //       r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                //     ).hasMatch(value.toUpperCase())) {
                //       return 'Please enter a valid PAN number';
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: 16),

                // LoanApplicationInputField(
                //   controller: aadharController,
                //   label: 'Aadhar Number',
                //   hint: 'Enter your Aadhar number',
                //   keyboardType: TextInputType.number,
                //   focusColor: primaryColor,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter your Aadhar number';
                //     }
                //     if (value.length != 12) {
                //       return 'Please enter a valid 12-digit Aadhar number';
                //     }
                //     return null;
                //   },
                // ),
                const AadhaarVerificationWidget(),
                const SizedBox(height: 24),

                LoanApplicationSectionHeader(
                  title: 'Address Details',
                  color: primaryColor,
                ),
                const SizedBox(height: 16),

                // Radio button for address auto-fill
                Consumer<LoanProvider>(
                  builder: (context, loanProvider, child) {
                    final isAadhaarVerified = loanProvider.isAadhaarVerified;

                    if (isAadhaarVerified) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _useSameAsAadhaar,
                              onChanged: (value) => _toggleAddressSource(value),
                              activeColor: primaryColor,
                              checkColor: Colors.white,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _toggleAddressSource(!_useSameAsAadhaar),
                                child: Text(
                                  'Use same address as in Aadhaar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            ),
                            if (_useSameAsAadhaar)
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                LoanApplicationInputField(
                  controller: widget.addressController,
                  label: 'Address',
                  hint: 'Enter your complete address',
                  maxLines: 2,
                  focusColor: primaryColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    if (value.trim().length < 10) {
                      return 'Please enter a complete address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final loanProvider = context.read<LoanProvider>();
                    loanProvider.updateApplicationData('address', value);
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: LoanApplicationInputField(
                        controller: widget.cityController,
                        label: 'City',
                        hint: 'Enter your city',
                        focusColor: primaryColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your city';
                          }
                          if (value.trim().length < 2) {
                            return 'Please enter a valid city name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          final loanProvider = context.read<LoanProvider>();
                          loanProvider.updateApplicationData('city', value);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: LoanApplicationInputField(
                        controller: widget.pincodeController,
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
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Pincode should contain only digits';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          final loanProvider = context.read<LoanProvider>();
                          loanProvider.updateApplicationData('pincode', value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerificationStatusItem(String label, bool isVerified) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isVerified ? Icons.check_circle : Icons.pending,
            color: isVerified ? Colors.green : Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isVerified
                    ? Colors.green.shade700
                    : Colors.orange.shade700,
                fontWeight: isVerified ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            isVerified ? 'Verified' : 'Pending',
            style: TextStyle(
              fontSize: 12,
              color: isVerified
                  ? Colors.green.shade600
                  : Colors.orange.shade600,
              fontWeight: FontWeight.w500,
            ),
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

  bool validateForm() {
    return _personalFormKey.currentState?.validate() ?? false;
  }
}
