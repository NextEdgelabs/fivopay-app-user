// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/loan_provider.dart';
// import '../utils/constants.dart';
// import 'custom_text_field.dart';

// class AddressFormWidget extends StatefulWidget {
//   const AddressFormWidget({super.key});

//   @override
//   State<AddressFormWidget> createState() => _AddressFormWidgetState();
// }

// class _AddressFormWidgetState extends State<AddressFormWidget> {
//   final _currentAddressController = TextEditingController();
//   bool _isSameAsAadhaar = true;

//   @override
//   void initState() {
//     super.initState();
//     final loanProvider = context.read<LoanProvider>();
//     _isSameAsAadhaar = loanProvider.isCurrentAddressSameAsAadhaar;
    
//     if (loanProvider.currentAddress != null && !_isSameAsAadhaar) {
//       _currentAddressController.text = loanProvider.currentAddress!;
//     }
//   }

//   @override
//   void dispose() {
//     _currentAddressController.dispose();
//     super.dispose();
//   }

//   void _updateAddressDetails() {
//     final loanProvider = context.read<LoanProvider>();
//     loanProvider.setAddressDetails(
//       currentAddress: _isSameAsAadhaar ? null : _currentAddressController.text.trim(),
//       isSameAsAadhaar: _isSameAsAadhaar,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LoanProvider>(
//       builder: (context, loanProvider, child) {
//         final aadhaarAddress = loanProvider.aadhaarAddress;
//         final isAadhaarVerified = loanProvider.isAadhaarVerified;

//         return Container(
//           padding: const EdgeInsets.all(AppSizes.paddingL),
//           decoration: BoxDecoration(
//             color: AppColors.cardBackground,
//             borderRadius: BorderRadius.circular(AppSizes.radiusXL),
//             border: Border.all(color: AppColors.border),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     Icons.location_on,
//                     color: AppColors.primary,
//                     size: 24,
//                   ),
//                   const SizedBox(width: AppSizes.paddingS),
//                   Text(
//                     'Address Information',
//                     style: AppTextStyles.heading3,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: AppSizes.paddingL),
              
//               // Aadhaar address display
//               if (isAadhaarVerified && aadhaarAddress != null) ...[
//                 Container(
//                   padding: const EdgeInsets.all(AppSizes.paddingM),
//                   decoration: BoxDecoration(
//                     color: AppColors.surface,
//                     borderRadius: BorderRadius.circular(AppSizes.radiusM),
//                     border: Border.all(color: AppColors.border),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.verified_user,
//                             color: AppColors.success,
//                             size: 20,
//                           ),
//                           const SizedBox(width: AppSizes.paddingS),
//                           Text(
//                             'Aadhaar Address',
//                             style: AppTextStyles.body2.copyWith(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: AppSizes.paddingS),
//                       Text(
//                         aadhaarAddress,
//                         style: AppTextStyles.body2.copyWith(
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: AppSizes.paddingL),
                
//                 // Same as Aadhaar checkbox
//                 Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.surface,
//                     borderRadius: BorderRadius.circular(AppSizes.radiusM),
//                     border: Border.all(
//                       color: _isSameAsAadhaar ? AppColors.primary : AppColors.border,
//                     ),
//                   ),
//                   child: CheckboxListTile(
//                     title: Text(
//                       'Current address is same as Aadhaar address',
//                       style: AppTextStyles.body1,
//                     ),
//                     value: _isSameAsAadhaar,
//                     onChanged: (value) {
//                       setState(() {
//                         _isSameAsAadhaar = value ?? true;
//                         if (_isSameAsAadhaar) {
//                           _currentAddressController.clear();
//                         }
//                         _updateAddressDetails();
//                       });
//                     },
//                     activeColor: AppColors.primary,
//                     controlAffinity: ListTileControlAffinity.leading,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: AppSizes.paddingM,
//                     ),
//                   ),
//                 ),
//               ] else if (!isAadhaarVerified) ...[
//                 // Show message to complete Aadhaar verification first
//                 Container(
//                   padding: const EdgeInsets.all(AppSizes.paddingM),
//                   decoration: BoxDecoration(
//                     color: AppColors.warning.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(AppSizes.radiusM),
//                     border: Border.all(
//                       color: AppColors.warning.withOpacity(0.3),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.warning_amber_rounded,
//                         color: AppColors.warning,
//                         size: 20,
//                       ),
//                       const SizedBox(width: AppSizes.paddingM),
//                       Expanded(
//                         child: Text(
//                           'Please complete Aadhaar verification to proceed with address details',
//                           style: AppTextStyles.body2.copyWith(
//                             color: AppColors.warning,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
              
//               // Current address input
//               if (isAadhaarVerified && !_isSameAsAadhaar) ...[
//                 const SizedBox(height: AppSizes.paddingL),
//                 CustomTextField(
//                   controller: _currentAddressController,
//                   labelText: 'Current Address',
//                   hintText: 'Enter your current residential address',
//                   prefixIcon: Icons.home,
//                   maxLines: 3,
//                   onChanged: (_) => _updateAddressDetails(),
//                   validator: (value) {
//                     if (!_isSameAsAadhaar && (value == null || value.isEmpty)) {
//                       return 'Please enter your current address';
//                     }
//                     return null;
//                   },
//                 ),
//               ],
              
//               // Info message
//               if (isAadhaarVerified) ...[
//                 const SizedBox(height: AppSizes.paddingL),
//                 Container(
//                   padding: const EdgeInsets.all(AppSizes.paddingM),
//                   decoration: BoxDecoration(
//                     color: AppColors.info.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(AppSizes.radiusM),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(
//                         Icons.info_outline,
//                         color: AppColors.info,
//                         size: 20,
//                       ),
//                       const SizedBox(width: AppSizes.paddingM),
//                       Expanded(
//                         child: Text(
//                           'Your address will be verified during the loan approval process',
//                           style: AppTextStyles.caption.copyWith(
//                             color: AppColors.textSecondary,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }
// }