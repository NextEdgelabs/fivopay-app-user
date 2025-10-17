// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import 'package:janseva/main.dart';
// import 'package:janseva/modules/auth/provider/auth_provider.dart';
// import 'package:janseva/services/storage_service.dart';
// import 'package:provider/provider.dart';
// import '../config/api_config.dart';

// /// Enhanced KYC API Service with improved error handling and token management
// class KycApiService {
//   static const Duration _defaultTimeout = Duration(seconds: 30);
//   static const int _maxRetryAttempts = 3;
//   static bool _isRefreshingToken = false;

//   /// Get current headers with fresh access token
//   static Map<String, String> _getCurrentHeaders() {
//     final provider = bContext.read<AuthProvider>();
//     return {
//       'Authorization': 'Bearer ${provider.kycaccessToken ?? ""}',
//       'x-api-key':
//           provider.apiKey ?? "key_live_c018d67e91bc4761b35d212fce69e17d",
//       'x-api-version': provider.apiversion ?? "2.0",
//       'Content-Type': 'application/json',
//     };
//   }

//   /// Make HTTP request with automatic token refresh and retry logic
//   static Future<Map<String, dynamic>> _makeRequest({
//     required String method,
//     required String url,
//     Map<String, dynamic>? body,
//     Duration timeout = _defaultTimeout,
//     int retryCount = 0,
//   }) async {
//     try {
//       final uri = Uri.parse(url);
//       final headers = _getCurrentHeaders();

//       log('🔍 [KYC API] ${method.toUpperCase()} Request:');
//       log('URL: $url');
//       log('Headers: $headers');
//       if (body != null) log('Body: ${jsonEncode(body)}');

//       late http.Response response;

//       switch (method.toUpperCase()) {
//         case 'POST':
//           response = await http
//               .post(
//                 uri,
//                 headers: headers,
//                 body: body != null ? jsonEncode(body) : null,
//               )
//               .timeout(timeout);
//           break;
//         case 'GET':
//           response = await http.get(uri, headers: headers).timeout(timeout);
//           break;
//         case 'PUT':
//           response = await http
//               .put(
//                 uri,
//                 headers: headers,
//                 body: body != null ? jsonEncode(body) : null,
//               )
//               .timeout(timeout);
//           break;
//         case 'DELETE':
//           response = await http.delete(uri, headers: headers).timeout(timeout);
//           break;
//         default:
//           throw KycApiException(
//             message: 'Unsupported HTTP method: $method',
//             statusCode: 0,
//             errorDetails: {},
//           );
//       }

//       log('📡 [KYC API] Response:');
//       log('Status Code: ${response.statusCode}');
//       log('Response Body: ${response.body}');

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         return json.decode(response.body);
//       } else if ((response.statusCode == 401 || response.statusCode == 403) &&
//           retryCount < _maxRetryAttempts) {
//         // Token expired, refresh and retry
//         await _refreshAccessToken();
//         return _makeRequest(
//           method: method,
//           url: url,
//           body: body,
//           timeout: timeout,
//           retryCount: retryCount + 1,
//         );
//       } else {
//         final errorBody = response.body.isNotEmpty
//             ? json.decode(response.body)
//             : {'message': 'Unknown error'};
//         throw KycApiException(
//           message: errorBody['message'] ?? 'API request failed',
//           statusCode: response.statusCode,
//           errorDetails: errorBody,
//         );
//       }
//     } catch (e) {
//       if (e is KycApiException) rethrow;
//       throw KycApiException(
//         message: 'Network error: ${e.toString()}',
//         statusCode: 0,
//         errorDetails: {'error': e.toString()},
//       );
//     }
//   }

//   /// Refresh access token with thread safety
//   static Future<void> _refreshAccessToken() async {
//     if (_isRefreshingToken) {
//       // Wait for ongoing refresh to complete
//       while (_isRefreshingToken) {
//         await Future.delayed(const Duration(milliseconds: 100));
//       }
//       return;
//     }

//     _isRefreshingToken = true;
//     try {
//       await _getAccessToken();
//     } finally {
//       _isRefreshingToken = false;
//     }
//   }

//   /// Get access token from authentication endpoint
//   static Future<void> _getAccessToken() async {
//     try {
//       final provider = bContext.read<AuthProvider>();
//       final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.authenticate}');
//       final headers = {
//         'x-api-key':
//             provider.apiKey ?? "key_live_c018d67e91bc4761b35d212fce69e17d",
//         'x-api-secret': 'secret_live_82d7c6010efe4764b12fd616211a9d7a',
//         'x-api-version': provider.apiversion ?? "2.0",
//         'Content-Type': 'application/json',
//       };

//       log('🔐 [KYC API] Getting access token...');

//       final response = await http.post(url, headers: headers);

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         final token = jsonResponse['access_token'];

//         if (token != null) {
//           // Save to storage for persistence
//           await SfService.saveString(SfService.kycAccessToken, token);
//           // Update provider to notify listeners
//           provider.updateKycAccessToken(token);

//           log('✅ [KYC API] Access token refreshed successfully');
//         } else {
//           throw KycApiException(
//             message: 'No access token in response',
//             statusCode: response.statusCode,
//             errorDetails: jsonResponse,
//           );
//         }
//       } else {
//         final errorBody = response.body.isNotEmpty
//             ? jsonDecode(response.body)
//             : {'message': 'Unknown error'};
//         throw KycApiException(
//           message: errorBody['message'] ?? 'Failed to get access token',
//           statusCode: response.statusCode,
//           errorDetails: errorBody,
//         );
//       }
//     } catch (e) {
//       if (e is KycApiException) rethrow;
//       throw KycApiException(
//         message: 'Token refresh failed: ${e.toString()}',
//         statusCode: 0,
//         errorDetails: {'error': e.toString()},
//       );
//     }
//   }

//   /// Verify PAN card with name and optional date of birth
//   ///
//   /// API Response Format:
//   /// ```json
//   /// {
//   ///   "code": 200,
//   ///   "timestamp": 1760504569212,
//   ///   "data": {
//   ///     "@entity": "in.co.sandbox.kyc.pan_verification.response",
//   ///     "pan": "ANVPY9553G",
//   ///     "status": "valid",
//   ///     "remarks": null,
//   ///     "name_as_per_pan_match": true,
//   ///     "date_of_birth_match": true,
//   ///     "category": "individual",
//   ///     "aadhaar_seeding_status": "y"
//   ///   },
//   ///   "transaction_id": "609a142a-42d6-489e-9499-be795f0c1fa7"
//   /// }
//   /// ```
//   static Future<PanVerificationResponse> verifyPan({
//     required String panNumber,
//     required String name,
//     String? dateOfBirth,
//     String consent = 'Y',
//     String reason = 'For KYC verification purpose',
//   }) async {
//     final body = {
//       '@entity': 'in.co.sandbox.kyc.pan_verification.request',
//       'pan': panNumber.toUpperCase().trim(),
//       'name_as_per_pan': name.trim(),
//       'consent': consent,
//       'reason': reason,
//     };

//     // Add optional date of birth if provided
//     if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
//       body['date_of_birth'] = dateOfBirth;
//     }

//     final response = await _makeRequest(
//       method: 'POST',
//       url: '${ApiConfig.baseUrl}${ApiConfig.panVerifyPath}',
//       body: body,
//     );

//     return PanVerificationResponse.fromJson(response);
//   }

//   /// Request OTP for Aadhaar verification
//   ///
//   /// Step 1: Send OTP to Aadhaar registered mobile number
//   ///
//   /// API Response Format:
//   /// ```json
//   /// {
//   ///   "code": 200,
//   ///   "timestamp": 1760504569212,
//   ///   "data": {
//   ///     "reference_id": 123456789
//   ///   },
//   ///   "message": "OTP sent successfully"
//   /// }
//   /// ```
//   static Future<AadhaarOtpResponse> requestAadhaarOtp({
//     required String aadhaarNumber,
//     String consent = 'Y',
//     String reason = 'For KYC verification purpose',
//   }) async {
//     final body = {
//       '@entity': 'in.co.sandbox.kyc.aadhaar.okyc.otp.request',
//       'aadhaar_number': aadhaarNumber.trim(),
//       'consent': consent,
//       'reason': reason,
//     };

//     final response = await _makeRequest(
//       method: 'POST',
//       url: '${ApiConfig.baseUrl}${ApiConfig.aadhaarOtpPath}',
//       body: body,
//     );

//     return AadhaarOtpResponse.fromJson(response);
//   }

//   /// Verify Aadhaar with OTP
//   ///
//   /// Step 2: Verify OTP and get Aadhaar details
//   ///
//   /// API Response Format:
//   /// ```json
//   /// {
//   ///   "code": 200,
//   ///   "timestamp": 1760504569212,
//   ///   "data": {
//   ///     "@entity": "in.co.sandbox.kyc.aadhaar.okyc.response",
//   ///     "aadhaar_number": "xxxxxxxxxxxx1234",
//   ///     "status": "valid",
//   ///     "name": "John Doe",
//   ///     "date_of_birth": "01/01/1990",
//   ///     "gender": "M",
//   ///     "full_address": "123 Main St, City, State, 123456"
//   ///   },
//   ///   "transaction_id": "609a142a-42d6-489e-9499-be795f0c1fa7"
//   /// }
//   /// ```
//   static Future<AadhaarVerificationResponse> verifyAadhaarOtp({
//     required String referenceId,
//     required String otp,
//   }) async {
//     final body = {
//       '@entity': 'in.co.sandbox.kyc.aadhaar.okyc.request',
//       'reference_id': referenceId,
//       'otp': otp.trim(),
//     };

//     final response = await _makeRequest(
//       method: 'POST',
//       url: '${ApiConfig.baseUrl}${ApiConfig.aadhaarVerifyPath}',
//       body: body,
//     );

//     return AadhaarVerificationResponse.fromJson(response);
//   }

//   /// Generic Aadhaar verification (if needed for legacy support)
//   static Future<Map<String, dynamic>> verifyAadhaar({
//     required String aadhaarNumber,
//   }) async {
//     final body = {'aadhaar': aadhaarNumber.trim()};

//     return await _makeRequest(
//       method: 'POST',
//       url: '${ApiConfig.baseUrl}${ApiConfig.aadhaarVerifyPath}',
//       body: body,
//     );
//   }

//   /// Utility method to check if service is available
//   static Future<bool> checkServiceHealth() async {
//     try {
//       await _makeRequest(
//         method: 'GET',
//         url: '${ApiConfig.baseUrl}/health',
//         timeout: const Duration(seconds: 10),
//       );
//       return true;
//     } catch (e) {
//       log('❌ [KYC API] Service health check failed: $e');
//       return false;
//     }
//   }
// }

// /// PAN Verification Response Model
// class PanVerificationResponse {
//   final int code;
//   final int timestamp;
//   final PanData data;
//   final String transactionId;

//   PanVerificationResponse({
//     required this.code,
//     required this.timestamp,
//     required this.data,
//     required this.transactionId,
//   });

//   factory PanVerificationResponse.fromJson(Map<String, dynamic> json) {
//     return PanVerificationResponse(
//       code: json['code'] as int,
//       timestamp: json['timestamp'] as int,
//       data: PanData.fromJson(json['data'] as Map<String, dynamic>),
//       transactionId: json['transaction_id'] as String,
//     );
//   }

//   bool get isSuccess => code == 200 && data.status == 'valid';
//   bool get isValid => data.status == 'valid';
//   bool get isInvalid => data.status == 'invalid';

//   Map<String, dynamic> toJson() {
//     return {
//       'code': code,
//       'timestamp': timestamp,
//       'data': data.toJson(),
//       'transaction_id': transactionId,
//     };
//   }
// }

// /// PAN Data Model
// class PanData {
//   final String entity;
//   final String pan;
//   final String status; // "valid" or "invalid"
//   final String? remarks;
//   final bool nameMatch;
//   final bool dobMatch;
//   final String category;
//   final String aadhaarSeedingStatus;

//   PanData({
//     required this.entity,
//     required this.pan,
//     required this.status,
//     this.remarks,
//     required this.nameMatch,
//     required this.dobMatch,
//     required this.category,
//     required this.aadhaarSeedingStatus,
//   });

//   factory PanData.fromJson(Map<String, dynamic> json) {
//     return PanData(
//       entity: json['@entity'] as String,
//       pan: json['pan'] as String,
//       status: json['status'] as String,
//       remarks: json['remarks'] as String?,
//       nameMatch: json['name_as_per_pan_match'] as bool? ?? false,
//       dobMatch: json['date_of_birth_match'] as bool? ?? false,
//       category: json['category'] as String,
//       aadhaarSeedingStatus: json['aadhaar_seeding_status'] as String,
//     );
//   }

//   bool get isAadhaarSeeded => aadhaarSeedingStatus.toLowerCase() == 'y';
//   bool get isIndividual => category.toLowerCase() == 'individual';

//   String get statusMessage {
//     if (status == 'valid') {
//       return 'PAN verified successfully';
//     } else if (remarks != null && remarks!.isNotEmpty) {
//       return remarks!;
//     } else {
//       return 'PAN verification failed';
//     }
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '@entity': entity,
//       'pan': pan,
//       'status': status,
//       'remarks': remarks,
//       'name_as_per_pan_match': nameMatch,
//       'date_of_birth_match': dobMatch,
//       'category': category,
//       'aadhaar_seeding_status': aadhaarSeedingStatus,
//     };
//   }
// }

// /// Aadhaar OTP Response Model
// class AadhaarOtpResponse {
//   final int code;
//   final int timestamp;
//   final String referenceId;
//   final String message;

//   AadhaarOtpResponse({
//     required this.code,
//     required this.timestamp,
//     required this.referenceId,
//     required this.message,
//   });

//   factory AadhaarOtpResponse.fromJson(Map<String, dynamic> json) {
//     String refId = '';

//     // Handle different response formats
//     if (json['reference_id'] != null) {
//       refId = json['reference_id'].toString();
//     } else if (json['data'] != null && json['data']['reference_id'] != null) {
//       refId = json['data']['reference_id'].toString();
//     }

//     return AadhaarOtpResponse(
//       code: json['code'] ?? 0,
//       timestamp: json['timestamp'] ?? 0,
//       referenceId: refId,
//       message: json['message'] ?? 'OTP sent successfully',
//     );
//   }

//   bool get isSuccess => code == 200;

//   Map<String, dynamic> toJson() {
//     return {
//       'code': code,
//       'timestamp': timestamp,
//       'reference_id': referenceId,
//       'message': message,
//     };
//   }
// }

// /// Aadhaar Verification Response Model
// class AadhaarVerificationResponse {
//   final int code;
//   final int timestamp;
//   final AadhaarData? data;
//   final String transactionId;

//   AadhaarVerificationResponse({
//     required this.code,
//     required this.timestamp,
//     this.data,
//     required this.transactionId,
//   });

//   factory AadhaarVerificationResponse.fromJson(Map<String, dynamic> json) {
//     return AadhaarVerificationResponse(
//       code: json['code'] ?? 0,
//       timestamp: json['timestamp'] ?? 0,
//       data: json['data'] != null ? AadhaarData.fromJson(json['data']) : null,
//       transactionId: json['transaction_id'] ?? '',
//     );
//   }

//   bool get isSuccess => code == 200 && data != null;
//   bool get isValid => data?.status.toLowerCase() == 'valid';

//   Map<String, dynamic> toJson() {
//     return {
//       'code': code,
//       'timestamp': timestamp,
//       'data': data?.toJson(),
//       'transaction_id': transactionId,
//     };
//   }
// }

// /// Aadhaar Data Model
// class AadhaarData {
//   final String aadhaarNumber;
//   final String status;
//   final String? name;
//   final String? dateOfBirth;
//   final String? gender;
//   final String? address;
//   final String? photo;
//   final String? careOf;
//   final String? splitAddress;

//   AadhaarData({
//     required this.aadhaarNumber,
//     required this.status,
//     this.name,
//     this.dateOfBirth,
//     this.gender,
//     this.address,
//     this.photo,
//     this.careOf,
//     this.splitAddress,
//   });

//   factory AadhaarData.fromJson(Map<String, dynamic> json) {
//     return AadhaarData(
//       aadhaarNumber: json['aadhaar_number'] ?? '',
//       status: json['status'] ?? 'invalid',
//       name: json['name'],
//       dateOfBirth: json['date_of_birth'] ?? json['dob'],
//       gender: json['gender'],
//       address: json['full_address'] ?? json['address'] ?? '',
//       photo: json['photo_link'],
//       careOf: json['care_of'],
//       splitAddress: json['split_address'] != null
//           ? jsonEncode(json['split_address'])
//           : null,
//     );
//   }

//   bool get isValid => status.toLowerCase() == 'valid';
//   bool get isMale =>
//       gender?.toLowerCase() == 'm' || gender?.toLowerCase() == 'male';
//   bool get isFemale =>
//       gender?.toLowerCase() == 'f' || gender?.toLowerCase() == 'female';

//   Map<String, dynamic> toJson() {
//     return {
//       'aadhaar_number': aadhaarNumber,
//       'status': status,
//       'name': name,
//       'date_of_birth': dateOfBirth,
//       'gender': gender,
//       'full_address': address,
//       'photo_link': photo,
//       'care_of': careOf,
//       'split_address': splitAddress != null ? jsonDecode(splitAddress!) : null,
//     };
//   }
// }

// /// Custom Exception for KYC API Errors
// class KycApiException implements Exception {
//   final String message;
//   final int statusCode;
//   final Map<String, dynamic> errorDetails;

//   KycApiException({
//     required this.message,
//     required this.statusCode,
//     required this.errorDetails,
//   });

//   @override
//   String toString() => 'KycApiException: $message (Status: $statusCode)';

//   bool get isNetworkError => statusCode == 0;
//   bool get isAuthError => statusCode == 401 || statusCode == 403;
//   bool get isServerError => statusCode >= 500;
//   bool get isClientError => statusCode >= 400 && statusCode < 500;

//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'status_code': statusCode,
//       'error_details': errorDetails,
//     };
//   }
// }
