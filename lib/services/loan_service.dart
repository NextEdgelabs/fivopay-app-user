import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/loan_application.dart';

// class LoanService {
//   static const String baseUrl = 'https://api.example.com';
  
//   Future<Map<String, dynamic>> submitLoanApplication({
//     required String token,
//     required LoanApplication loanApplication,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/loans/apply'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(loanApplication.toJson()),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Failed to submit loan application');
//       }
//     } catch (e) {
//       if (e.toString().contains('SocketException') ||
//           e.toString().contains('Connection refused')) {
//         return {
//           'success': true,
//           'message': 'Loan application submitted successfully',
//           'applicationId': loanApplication.id,
//         };
//       }
//       throw Exception('Error submitting loan application: $e');
//     }
//   }

//   Future<Map<String, dynamic>> verifyPAN({
//     required String token,
//     required String panNumber,
//     required String name,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/verify/pan'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'panNumber': panNumber,
//           'name': name,
//         }),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'PAN verification failed');
//       }
//     } catch (e) {
//       if (e.toString().contains('SocketException') ||
//           e.toString().contains('Connection refused')) {
//         return {
//           'success': true,
//           'message': 'PAN verified successfully',
//           'otpSent': true,
//         };
//       }
//       throw Exception('Error verifying PAN: $e');
//     }
//   }

//   Future<Map<String, dynamic>> verifyPANOTP({
//     required String token,
//     required String panNumber,
//     required String otp,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/verify/pan/otp'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'panNumber': panNumber,
//           'otp': otp,
//         }),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'PAN OTP verification failed');
//       }
//     } catch (e) {
//       if (e.toString().contains('SocketException') ||
//           e.toString().contains('Connection refused')) {
//         if (otp == '123456') {
//           return {
//             'success': true,
//             'message': 'PAN verified successfully',
//             'verified': true,
//           };
//         } else {
//           throw Exception('Invalid OTP');
//         }
//       }
//       throw Exception('Error verifying PAN OTP: $e');
//     }
//   }

//   Future<Map<String, dynamic>> verifyAadhaar({
//     required String token,
//     required String aadhaarNumber,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/verify/aadhaar'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'aadhaarNumber': aadhaarNumber,
//         }),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Aadhaar verification failed');
//       }
//     } catch (e) {
//       if (e.toString().contains('SocketException') ||
//           e.toString().contains('Connection refused')) {
//         return {
//           'success': true,
//           'message': 'OTP sent to registered mobile number',
//           'otpSent': true,
//           'maskedPhone': '******1234',
//         };
//       }
//       throw Exception('Error verifying Aadhaar: $e');
//     }
//   }

//   Future<Map<String, dynamic>> verifyAadhaarOTP({
//     required String token,
//     required String aadhaarNumber,
//     required String otp,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/verify/aadhaar/otp'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'aadhaarNumber': aadhaarNumber,
//           'otp': otp,
//         }),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Aadhaar OTP verification failed');
//       }
//     } catch (e) {
//       if (e.toString().contains('SocketException') ||
//           e.toString().contains('Connection refused')) {
//         if (otp == '123456') {
//           return {
//             'success': true,
//             'message': 'Aadhaar verified successfully',
//             'verified': true,
//             'details': {
//               'name': 'John Doe',
//               'address': '123 Main St, City, State 123456',
//               'dob': '01/01/1990',
//             },
//           };
//         } else {
//           throw Exception('Invalid OTP');
//         }
//       }
//       throw Exception('Error verifying Aadhaar OTP: $e');
//     }
//   }

//   Future<List<Map<String, dynamic>>> getLoanHistory({
//     required String token,
//     required String accountNumber,
//   }) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/api/loans/history/$accountNumber'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return List<Map<String, dynamic>>.from(data['loans'] ?? []);
//       } else {
//         throw Exception('Failed to fetch loan history');
//       }
//     } catch (e) {
//       if (e.toString().contains('SocketException') ||
//           e.toString().contains('Connection refused')) {
//         return [];
//       }
//       throw Exception('Error fetching loan history: $e');
//     }
//   }
// }