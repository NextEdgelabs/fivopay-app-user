import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:janseva/modules/loan/providers/loan_provider_v2.dart';
import 'package:janseva/modules/loan/utils/loan_utils.dart';
import 'package:janseva/providers/user_provider.dart';
import 'package:janseva/utils/constants.dart';
import 'package:janseva/widgets/custom_button.dart';
import 'package:janseva/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import 'widgets/aadhar_widgets.dart';

class AdhaarVerifyScreen extends StatefulWidget {
  // final AadharVerifyArguments args;

  const AdhaarVerifyScreen({super.key});

  @override
  State<AdhaarVerifyScreen> createState() => _AdhaarVerifyScreenState();
}

class _AdhaarVerifyScreenState extends State<AdhaarVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _aadhaarNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  

  bool _otpSent = false;

  @override
  void dispose() {
    _aadhaarNumberController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<LoanProviderV2>();
    final aadhaarNumber = _aadhaarNumberController.text.trim();
    final userId = context.read<UserProvider>().currentUser!.id;
    await provider.sendAdhaarOtp(aadhaarNumber ,userId, "KYC Component" ); // TODO chaange reason

    if (mounted) {
      if (provider.error.isEmpty) {
        setState(() {
          _otpSent = true;
        });
        _showSuccessSnackbar('OTP sent to your registered mobile number');
      } else {
        _showErrorSnackbar(provider.error);
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().isEmpty) {
      _showErrorSnackbar('Please enter OTP');
      return;
    }

    final provider = context.read<LoanProviderV2>();
    final otp = _otpController.text.trim();
 final userId = context.read<UserProvider>().currentUser!.id;
    await provider.verifyAdhaar(otp, userId);

    if (mounted) {
      if (provider.error.isEmpty && provider.aadhaarVerificationstatus != null) {
        final response = provider.aadhaarVerificationstatus!;
        if (response.isSuccess && response.isValid) {
          _showSuccessSnackbar('Aadhaar verified successfully!');
          // Navigate to results screen after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                // Trigger rebuild to show results
              });
            }
          });
        } else {
          _showErrorSnackbar('Aadhaar verification failed. Please try again.');
        }
      } else {
        _showErrorSnackbar(provider.error.isNotEmpty 
          ? provider.error 
          : 'Verification failed. Please try again.');
      }
    }
  }

  void _resetForm() {
    setState(() {
      _otpSent = false;
      _aadhaarNumberController.clear();
      _otpController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProviderV2>(
       builder: (context, provider, child) {
         Color themecolor = LoanUtils.getLoanTypeColor(provider.selectedLoanProduct?.loanCategory?.loanType ?? "LOAN");
         // Show verification result if available
         if (provider.aadhaarVerificationstatus != null &&
             provider.aadhaarVerificationstatus!.isSuccess &&
             provider.aadhaarVerificationstatus!.isValid) {
           return buildAadhaarVerificationResult(provider , _resetForm);
         }
    
         // Show OTP input or Aadhaar input
         return Padding(
           padding: const EdgeInsets.all(AppSizes.paddingL),
           child: Form(
             key: _formKey,
             child: Column(
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 // Header
                 Container(
                   padding: const EdgeInsets.all(AppSizes.paddingXL),
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                       colors: [
                         themecolor,
                         themecolor.withOpacity(0.8),
                       ],
                       begin: Alignment.topLeft,
                       end: Alignment.bottomRight,
                     ),
                     borderRadius: BorderRadius.circular(AppSizes.radiusXL),
                   ),
                 child: Row(
                   children: [
                     Container(
                       padding: const EdgeInsets.all(AppSizes.paddingM),
                       decoration: BoxDecoration(
                         color: Colors.white.withOpacity(0.2),
                         borderRadius: BorderRadius.circular(AppSizes.radiusL),
                       ),
                       child: const Icon(
                         Icons.verified_user,
                         color: Colors.white,
                         size: 32,
                       ),
                     ),
                     const SizedBox(width: AppSizes.paddingL),
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             _otpSent ? 'Verify OTP' : 'Verify Aadhaar',
                             style: AppTextStyles.heading3.copyWith(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           const SizedBox(height: 4),
                           Text(
                             _otpSent
                                 ? 'Enter the OTP sent to your mobile'
                                 : 'Enter your 12-digit Aadhaar number',
                             style: AppTextStyles.body2.copyWith(
                               color: Colors.white.withOpacity(0.9),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
         
               const SizedBox(height: AppSizes.sectionSpacing),
         
               if (!_otpSent) ...[
                 // Aadhaar Number Input
                 Text(
                   'Aadhaar Number',
                   style: AppTextStyles.body1.copyWith(
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                 const SizedBox(height: AppSizes.paddingM),
                 CustomTextField(
                   controller: _aadhaarNumberController,
                   labelText: 'Aadhaar Number',
                   hintText: 'Enter 12-digit Aadhaar number',
                   keyboardType: TextInputType.number,
                   maxLength: 12,
                   inputFormatters: [
                     FilteringTextInputFormatter.digitsOnly,
                   ],
                   validator: (value) {
                     if (value == null || value.isEmpty) {
                       return 'Please enter Aadhaar number';
                     }
                     if (value.length != 12) {
                       return 'Aadhaar number must be 12 digits';
                     }
                     return null;
                   },
                 ),
         
                 const SizedBox(height: AppSizes.paddingXL),
         
                 // Info Card
                 Container(
                   padding: const EdgeInsets.all(AppSizes.paddingL),
                   decoration: BoxDecoration(
                     color: AppColors.info.withOpacity(0.1),
                     borderRadius: BorderRadius.circular(AppSizes.radiusL),
                     border: Border.all(
                       color: AppColors.info.withOpacity(0.3),
                     ),
                   ),
                   child: Row(
                     children: [
                       Icon(
                         Icons.info_outline,
                         color: AppColors.info,
                         size: 20,
                       ),
                       const SizedBox(width: AppSizes.paddingM),
                       Expanded(
                         child: Text(
                           'An OTP will be sent to your registered mobile number',
                           style: AppTextStyles.body2.copyWith(
                             color: AppColors.info,
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
         
                 const SizedBox(height: AppSizes.padding2XL),
         
                 // Send OTP Button
                 CustomButton(
                   onPressed: provider.isAdhaarLoading ? null : _sendOtp,
                   text: provider.isAdhaarLoading ? 'Sending OTP...' : 'Send OTP',
                   isLoading: provider.isAdhaarLoading,
                   backgroundColor: themecolor,
                 ),
               ] else ...[
                 // OTP Input
                 Text(
                   'Enter OTP',
                   style: AppTextStyles.body1.copyWith(
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                 const SizedBox(height: AppSizes.paddingM),
                 CustomTextField(
                   controller: _otpController,
                   labelText: 'OTP',
                   hintText: 'Enter 6-digit OTP',
                   keyboardType: TextInputType.number,
                   maxLength: 6,
                   inputFormatters: [
                     FilteringTextInputFormatter.digitsOnly,
                   ],
                 ),
         
                 const SizedBox(height: AppSizes.paddingL),
         
                 // Resend OTP
                 Align(
                   alignment: Alignment.centerRight,
                   child: TextButton(
                     onPressed: provider.isAdhaarLoading ? null : _sendOtp,
                     child: Text(
                       'Resend OTP',
                       style: AppTextStyles.body2.copyWith(
                         color: themecolor,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                   ),
                 ),
         
                 const SizedBox(height: AppSizes.paddingXL),
         
                 // Verify Button
                 CustomButton(
                   onPressed: provider.isAdhaarLoading ? null : _verifyOtp,
                   text: provider.isAdhaarLoading ? 'Verifying...' : 'Verify OTP',
                   isLoading: provider.isAdhaarLoading,
                   backgroundColor: themecolor,
                 ),
         
                 const SizedBox(height: AppSizes.paddingL),
         
                 // Change Number
                 Align(
                   alignment: Alignment.center,
                   child: TextButton.icon(
                     onPressed: provider.isAdhaarLoading ? null : _resetForm,
                     icon: Icon(Icons.edit, color: themecolor),
                     label: Text(
                       'Change Aadhaar Number',
                       style: TextStyle(color: themecolor),
                     ),
                   ),
                 ),
               ],
             ],
           ),
         ),
         );
       },
     );
  }

}
