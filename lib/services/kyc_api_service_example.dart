// /// Example usage of the KycApiService
// ///
// /// This file shows how to use the clean, improved KYC API service
// /// to perform PAN and Aadhaar verification operations.

// import 'package:flutter/material.dart';
// import '../services/kyc_api_service.dart';

// class KycApiUsageExample {
//   /// Example: Verify PAN with name
//   static Future<void> verifyPanExample() async {
//     try {
//       final response = await KycApiService.verifyPan(
//         panNumber: 'ANVPY9553G',
//         name: 'John Doe',
//         dateOfBirth: '01/01/1990', // Optional
//       );

//       if (response.isSuccess) {
//         print('✅ PAN verified successfully');
//         print('Name Match: ${response.data.nameMatch}');
//         print('DOB Match: ${response.data.dobMatch}');
//         print('Category: ${response.data.category}');
//         print('Aadhaar Seeded: ${response.data.isAadhaarSeeded}');
//       } else {
//         print('❌ PAN verification failed: ${response.data.statusMessage}');
//       }
//     } on KycApiException catch (e) {
//       print('❌ KYC API Error: ${e.message}');
//       print('Status Code: ${e.statusCode}');

//       if (e.isAuthError) {
//         print('Authentication issue - token may be expired');
//       } else if (e.isNetworkError) {
//         print('Network connectivity issue');
//       } else if (e.isServerError) {
//         print('Server error - try again later');
//       }
//     } catch (e) {
//       print('❌ Unexpected error: $e');
//     }
//   }

//   /// Example: Complete Aadhaar verification flow
//   static Future<void> aadhaarVerificationExample() async {
//     try {
//       // Step 1: Request OTP
//       print('📱 Requesting Aadhaar OTP...');
//       final otpResponse = await KycApiService.requestAadhaarOtp(
//         aadhaarNumber: '123456789012',
//       );

//       if (otpResponse.isSuccess) {
//         print('✅ OTP sent successfully');
//         print('Reference ID: ${otpResponse.referenceId}');

//         // Step 2: Verify OTP (In real app, get OTP from user input)
//         print('🔐 Verifying OTP...');
//         final verificationResponse = await KycApiService.verifyAadhaarOtp(
//           referenceId: otpResponse.referenceId,
//           otp: '123456', // User-entered OTP
//         );

//         if (verificationResponse.isSuccess &&
//             verificationResponse.data != null) {
//           final aadhaarData = verificationResponse.data!;
//           print('✅ Aadhaar verified successfully');
//           print('Name: ${aadhaarData.name}');
//           print('DOB: ${aadhaarData.dateOfBirth}');
//           print('Gender: ${aadhaarData.gender}');
//           print('Address: ${aadhaarData.address}');
//         } else {
//           print('❌ Aadhaar verification failed');
//         }
//       } else {
//         print('❌ Failed to send OTP');
//       }
//     } on KycApiException catch (e) {
//       print('❌ KYC API Error: ${e.message}');
//     } catch (e) {
//       print('❌ Unexpected error: $e');
//     }
//   }

//   /// Example: Check service health
//   static Future<void> checkServiceExample() async {
//     print('🏥 Checking KYC service health...');
//     final isHealthy = await KycApiService.checkServiceHealth();

//     if (isHealthy) {
//       print('✅ KYC service is healthy');
//     } else {
//       print('❌ KYC service is unavailable');
//     }
//   }

//   /// Example: Widget showing how to use in a Flutter screen
//   static Widget buildKycVerificationWidget() {
//     return Scaffold(
//       appBar: AppBar(title: Text('KYC Verification')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () => verifyPanExample(),
//               child: Text('Verify PAN'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => aadhaarVerificationExample(),
//               child: Text('Verify Aadhaar'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => checkServiceExample(),
//               child: Text('Check Service Health'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Helper class for handling KYC operations in UI
// class KycVerificationHelper {
//   /// Show loading dialog during API calls
//   static void showLoadingDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         content: Row(
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(width: 16),
//             Text(message),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Hide loading dialog
//   static void hideLoadingDialog(BuildContext context) {
//     Navigator.of(context).pop();
//   }

//   /// Show error dialog
//   static void showErrorDialog(
//     BuildContext context,
//     String title,
//     String message,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Show success dialog
//   static void showSuccessDialog(
//     BuildContext context,
//     String title,
//     String message,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.green),
//             SizedBox(width: 8),
//             Text(title),
//           ],
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Perform PAN verification with UI feedback
//   static Future<PanVerificationResponse?> verifyPanWithUi({
//     required BuildContext context,
//     required String panNumber,
//     required String name,
//     String? dateOfBirth,
//   }) async {
//     showLoadingDialog(context, 'Verifying PAN...');

//     try {
//       final response = await KycApiService.verifyPan(
//         panNumber: panNumber,
//         name: name,
//         dateOfBirth: dateOfBirth,
//       );

//       hideLoadingDialog(context);

//       if (response.isSuccess) {
//         showSuccessDialog(
//           context,
//           'PAN Verified',
//           'PAN ${panNumber} has been successfully verified for ${name}.',
//         );
//         return response;
//       } else {
//         showErrorDialog(
//           context,
//           'PAN Verification Failed',
//           response.data.statusMessage,
//         );
//         return null;
//       }
//     } on KycApiException catch (e) {
//       hideLoadingDialog(context);
//       showErrorDialog(context, 'Verification Error', e.message);
//       return null;
//     } catch (e) {
//       hideLoadingDialog(context);
//       showErrorDialog(
//         context,
//         'Unexpected Error',
//         'An unexpected error occurred. Please try again.',
//       );
//       return null;
//     }
//   }

//   /// Perform Aadhaar OTP request with UI feedback
//   static Future<AadhaarOtpResponse?> requestAadhaarOtpWithUi({
//     required BuildContext context,
//     required String aadhaarNumber,
//   }) async {
//     showLoadingDialog(context, 'Requesting OTP...');

//     try {
//       final response = await KycApiService.requestAadhaarOtp(
//         aadhaarNumber: aadhaarNumber,
//       );

//       hideLoadingDialog(context);

//       if (response.isSuccess) {
//         showSuccessDialog(
//           context,
//           'OTP Sent',
//           'OTP has been sent to your registered mobile number.',
//         );
//         return response;
//       } else {
//         showErrorDialog(
//           context,
//           'OTP Request Failed',
//           'Failed to send OTP. Please check your Aadhaar number.',
//         );
//         return null;
//       }
//     } on KycApiException catch (e) {
//       hideLoadingDialog(context);
//       showErrorDialog(context, 'OTP Request Error', e.message);
//       return null;
//     } catch (e) {
//       hideLoadingDialog(context);
//       showErrorDialog(
//         context,
//         'Unexpected Error',
//         'An unexpected error occurred. Please try again.',
//       );
//       return null;
//     }
//   }
// }
