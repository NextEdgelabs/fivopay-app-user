import 'package:flutter/material.dart';
import 'package:janseva/modules/auth/provider/auth_provider.dart';
import 'package:janseva/modules/loan/widgets/aadhaar_verification_widget.dart';
import 'package:janseva/providers/user_provider.dart';
import 'package:janseva/utils/theme_extension.dart';
import 'package:janseva/widgets/pan_verification_widget.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/loan_provider.dart';
import 'loan_application_input_fields.dart';
import 'loan_application_section_header.dart';
import 'address_proof_upload_widget.dart';
import '../../../utils/file_picker_helper.dart';

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

  @override
  void initState() {
    context.read<LoanProvider>().setPanAndAadhaarStatus();
    widget.aadharController.text =
        context.read<UserProvider>().currentUser?.aadharNumber ?? '';
    widget.panController.text =
        context.read<UserProvider>().currentUser?.panNumber ?? '';

    // TODO: implement initState
    super.initState();
  }

  void _fillAddressFromAadhaar() {
    final loanProvider = context.read<LoanProvider>();
    final userProvider = context.read<UserProvider>();
    final aadhaarDetails = loanProvider.aadhaarDetails;

    if (aadhaarDetails != null) {
      final address = aadhaarDetails.fullAddress as String;
      // Parse address and fill fields
      widget.addressController.text = address;

      // Update provider data for validation
      loanProvider.updateApplicationData('address', address);

      if (aadhaarDetails.address?.pincode != null) {
        widget.pincodeController.text = aadhaarDetails.address!.pincode
            .toString();
        loanProvider.updateApplicationData(
          'pincode',
          aadhaarDetails.address!.pincode.toString(),
        );
      }
      if (aadhaarDetails.address?.district != null) {
        widget.cityController.text = aadhaarDetails.address!.district
            .toString();
        loanProvider.updateApplicationData(
          'city',
          aadhaarDetails.address!.district.toString(),
        );
      }

      // // Try to extract city and pincode from address if possible
      // final addressParts = address.split(',');
      // if (addressParts.length >= 2) {
      //   // Try to find pincode (6 digits)
      //   final pincodeRegex = RegExp(r'\b\d{6}\b');
      //   final pincodeMatch = pincodeRegex.firstMatch(address);
      //   if (pincodeMatch != null) {
      //     final pincode = pincodeMatch.group(0) ?? '';
      //     widget.pincodeController.text = pincode;
      //     // Update provider data for validation
      //     loanProvider.updateApplicationData('pincode', pincode);
      //   }

      //   // Extract city (usually before pincode or last meaningful part)
      //   for (int i = addressParts.length - 1; i >= 0; i--) {
      //     final part = addressParts[i].trim();
      //     if (part.isNotEmpty && !RegExp(r'^\d+$').hasMatch(part)) {
      //       widget.cityController.text = part;
      //       // Update provider data for validation
      //       loanProvider.updateApplicationData('city', part);
      //       break;
      //     }
      //   }
      // }
    } else if (userProvider.currentUser?.address != null &&
        userProvider.currentUser!.address!.isNotEmpty) {
      final user = userProvider.currentUser!;
      widget.addressController.text = user.address!;
      loanProvider.updateApplicationData('address', user.address!);
      if (user.pincode != null && user.pincode!.isNotEmpty) {
        widget.pincodeController.text = user.pincode!;
        loanProvider.updateApplicationData('pincode', user.pincode!);
      }
      if (user.city != null && user.city!.isNotEmpty) {
        widget.cityController.text = user.city!;
        loanProvider.updateApplicationData('city', user.city!);
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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer2<LoanProvider, UserProvider>(
        builder: (context, loanProvider, userProvider, child) {
          bool isAadhaarVerified =
              loanProvider.isAadhaarVerified ||
              (userProvider.currentUser?.aadhaarVerificationStatus == true &&
                  userProvider.currentUser?.aadharNumber != null &&
                  userProvider.currentUser!.aadharNumber!.isNotEmpty);
          bool isPanVerified =
              loanProvider.isPanVerified ||
              (userProvider.currentUser?.panVerificationStatus == true &&
                  userProvider.currentUser?.panNumber != null &&
                  userProvider.currentUser!.panNumber!.isNotEmpty);
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
                        loanProvider.isPanVerified || isPanVerified,
                      ),
                      _buildVerificationStatusItem(
                        'Aadhaar Verification',
                        loanProvider.isAadhaarVerified || isAadhaarVerified,
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
                (isPanVerified)
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'PAN number linked to your account is verified',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const PANVerificationWidget(),
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
                (isAadhaarVerified)
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Aadhaar number linked to your account is verified',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : AadhaarVerificationWidget(
                        reason:
                            "Loan Application (${loanProvider.selectedProduct?.description})",
                      ),
                const SizedBox(height: 24),

                LoanApplicationSectionHeader(
                  title: 'Address Details',
                  color: primaryColor,
                ),
                const SizedBox(height: 16),

                // Radio button for address auto-fill
                Consumer<LoanProvider>(
                  builder: (context, loanProvider, child) {
                    final isAadhaarVerifiedl = loanProvider.isAadhaarVerified;

                    if (isAadhaarVerifiedl || isAadhaarVerified) {
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
                const SizedBox(height: 24),

                // Address Proof Upload Section
                AddressProofUploadWidget(
                  primaryColor: primaryColor,
                  onPickFile: (proofType) async {
                    try {
                      // Pick file using helper
                      final file = await FilePickerHelper.pickDocument(
                        context: context,
                        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                      );

                      if (file == null) {
                        // User cancelled
                        return;
                      }

                      // Validate file size (max 5MB)
                      final isValidSize =
                          await FilePickerHelper.validateFileSize(
                            file,
                            5 * 1024 * 1024,
                          );

                      if (!isValidSize) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('File size must be less than 5MB'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        return;
                      }

                      // Validate file type

                      final isValidType = FilePickerHelper.isValidFileType(
                        file,
                        ['pdf', 'jpg', 'jpeg', 'png'],
                      );

                      if (!isValidType) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Invalid file type. Please select PDF, JPG, or PNG',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        return;
                      }

                      // Upload to provider
                      final loanProvider = context.read<LoanProvider>();
                      await loanProvider.selectLoanDocuments(
                        file,
                        'address_proof_$proofType',
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Address proof ($proofType) uploaded successfully!',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to upload: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
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
        return context.colors.brandColor;
    }
  }

  bool validateForm() {
    return _personalFormKey.currentState?.validate() ?? false;
  }
}
