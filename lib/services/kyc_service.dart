import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:janseva/main.dart';
import 'package:janseva/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../config/api_config.dart';

/// Service for KYC verification using Sandbox API
class KycService {
  int retryycount = 0;
  /// Verify PAN card with name and date of birth
  /// 
  /// API Response Format:
  /// ```json
  /// {
  ///   "code": 200,
  ///   "timestamp": 1760504569212,
  ///   "data": {
  ///     "@entity": "in.co.sandbox.kyc.pan_verification.response",
  ///     "pan": "ANVPY9553G",
  ///     "status": "valid",
  ///     "remarks": null,
  ///     "name_as_per_pan_match": true,
  ///     "date_of_birth_match": true,
  ///     "category": "individual",
  ///     "aadhaar_seeding_status": "y"
  ///   },
  ///   "transaction_id": "609a142a-42d6-489e-9499-be795f0c1fa7"
  /// }
  /// ```
  Future<PanVerificationResponse> verifyPan({
    required String panNumber,
    required String name,
    String? dateOfBirth,
    String consent = 'Y',
    String reason = 'For KYC verification purpose',
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.panVerifyPath}');
      
      // Build request body according to Sandbox API specs
      final body = {
        '@entity': 'in.co.sandbox.kyc.pan_verification.request',
        'pan': panNumber.toUpperCase(),
        'name_as_per_pan': name,
        'consent': consent,
        'reason': reason,
      };
      
      // Add optional date of birth if provided
      if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
        body['date_of_birth'] = dateOfBirth;
      }

      print('🔍 [KYC] PAN Verification Request:');
      print('URL: $url');
      print('Headers: ${ApiConfig.headers}');
      print('Body: ${jsonEncode(body)}');

      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      print('📡 [KYC] PAN Verification Response:');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return PanVerificationResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw KycApiException(
          message: errorBody['message'] ?? 'PAN verification failed',
          statusCode: response.statusCode,
          errorDetails: errorBody,
        );
      }
    } catch (e) {
      if (e is KycApiException) rethrow;
      throw KycApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
        errorDetails: {'error': e.toString()},
      );
    }
  }

  /// Verify Aadhaar card
  Future<Map<String, dynamic>> verifyAadhaar({
    required String aadhaarNumber,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.aadhaarVerifyPath}');
      
      final body = {
        'aadhaar': aadhaarNumber,
      };

      final response = await http.post(
        url,
        headers: {
          
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorBody = jsonDecode(response.body);
        throw KycApiException(
          message: errorBody['message'] ?? 'Aadhaar verification failed',
          statusCode: response.statusCode,
          errorDetails: errorBody,
        );
      }
    } catch (e) {
      if (e is KycApiException) rethrow;
      throw KycApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
        errorDetails: {'error': e.toString()},
      );
    }
  }

  /// Request OTP for Aadhaar verification
  /// 
  /// 
  /// Step 0: Get Access Token
  /// 
Future<void> getAccessToken() async {
    try {
      final provider = bContext.read<AuthProvider>();
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.authenticate}');
    final header = {
      'x-api-key': "key_live_c018d67e91bc4761b35d212fce69e17d" ,
      'x-api-secret': 'secret_live_82d7c6010efe4764b12fd616211a9d7a',
      'x-api-version': provider.apiversion ?? "2.0",
  // 'Content-Type': 'application/json',
    };
      final response = await http.post(
        url,
        headers: header,
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        var token =jsonResponse['access_token'];
        bContext.read<AuthProvider>().updateAccessToken(token);
      } else {
        final errorBody = jsonDecode(response.body);
        throw KycApiException(
          message: errorBody['message'] ?? 'Failed to get access token',
          statusCode: response.statusCode,
          errorDetails: errorBody,
        );
      }
    } catch (e) {
      if (e is KycApiException) rethrow;
      throw KycApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
        errorDetails: {'error': e.toString()},
      );
    }
  }
  /// Step 1: Send OTP to Aadhaar registered mobile number
  /// 
  /// 
  Future<AadhaarOtpResponse> requestAadhaarOtp({
    required String aadhaarNumber,
    String consent = 'Y',
    String reason = 'For KYC verification purpose',
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.aadhaarOtpPath}');
      
      final body = {
        '@entity': 'in.co.sandbox.kyc.aadhaar.okyc.otp.request',
        'aadhaar_number': aadhaarNumber,
        'consent': consent,
        'reason': reason,
      };

      print('🔍 [KYC] Aadhaar OTP Request:');
      print('URL: $url');
      print('Body: ${jsonEncode(body)}');
      // ApiConfig.headers['Authorization'] = accesstoken;
      log(ApiConfig.headers.toString());
      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      print('📡 [KYC] Aadhaar OTP Response:');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return AadhaarOtpResponse.fromJson(jsonResponse);
      } 
      else if (response.statusCode == 403) {
        if (retryycount < 5){
          retryycount++;
          await getAccessToken();
          return requestAadhaarOtp(aadhaarNumber: aadhaarNumber);
        }else {
          final errorBody = jsonDecode(response.body);
        throw KycApiException(
          message: errorBody['message'] ?? 'Aadhaar OTP request failed',
          statusCode: response.statusCode,
          errorDetails: errorBody,
        );
        }


      }
      
      else {
        final errorBody = jsonDecode(response.body);
        throw KycApiException(
          message: errorBody['message'] ?? 'Aadhaar OTP request failed',
          statusCode: response.statusCode,
          errorDetails: errorBody,
        );
      }
    } catch (e) {
      if (e is KycApiException) rethrow;
      throw KycApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
        errorDetails: {'error': e.toString()},
      );
    }
  }

  /// Verify Aadhaar with OTP
  /// 
  /// Step 2: Verify OTP and get Aadhaar details
  
  
  Future<AadhaarVerificationResponse> verifyAadhaarOtp({
    required String referenceId,
    required String otp,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.aadhaarVerifyPath}');
      
      final body = {
        '@entity': 'in.co.sandbox.kyc.aadhaar.okyc.request',
        'reference_id': referenceId,
        'otp': otp,
      };

      print('🔍 [KYC] Aadhaar OTP Verification:');
      print('URL: $url');
      print('Body: ${jsonEncode(body)}');

      final response = await http.post(
        url,
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      );

      print('📡 [KYC] Aadhaar Verification Response:');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return AadhaarVerificationResponse.fromJson(jsonResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw KycApiException(
          message: errorBody['message'] ?? 'Aadhaar verification failed',
          statusCode: response.statusCode,
          errorDetails: errorBody,
        );
      }
    } catch (e) {
      if (e is KycApiException) rethrow;
      throw KycApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
        errorDetails: {'error': e.toString()},
      );
    }
  }
}

/// PAN Verification Response Model
class PanVerificationResponse {
  final int code;
  final int timestamp;
  final PanData data;
  final String transactionId;

  PanVerificationResponse({
    required this.code,
    required this.timestamp,
    required this.data,
    required this.transactionId,
  });

  factory PanVerificationResponse.fromJson(Map<String, dynamic> json) {
    return PanVerificationResponse(
      code: json['code'] as int,
      timestamp: json['timestamp'] as int,
      data: PanData.fromJson(json['data'] as Map<String, dynamic>),
      transactionId: json['transaction_id'] as String,
    );
  }

  bool get isSuccess => code == 200 && data.status == 'valid';
  bool get isValid => data.status == 'valid';
  bool get isInvalid => data.status == 'invalid';
}

/// PAN Data Model
class PanData {
  final String entity;
  final String pan;
  final String status; // "valid" or "invalid"
  final String? remarks;
  final bool nameMatch;
  final bool dobMatch;
  final String category;
  final String aadhaarSeedingStatus;

  PanData({
    required this.entity,
    required this.pan,
    required this.status,
    this.remarks,
    required this.nameMatch,
    required this.dobMatch,
    required this.category,
    required this.aadhaarSeedingStatus,
  });

  factory PanData.fromJson(Map<String, dynamic> json) {
    return PanData(
      entity: json['@entity'] as String,
      pan: json['pan'] as String,
      status: json['status'] as String,
      remarks: json['remarks'] as String?,
      nameMatch: json['name_as_per_pan_match'] as bool? ?? false,
      dobMatch: json['date_of_birth_match'] as bool? ?? false,
      category: json['category'] as String,
      aadhaarSeedingStatus: json['aadhaar_seeding_status'] as String,
    );
  }

  bool get isAadhaarSeeded => aadhaarSeedingStatus == 'y';
  bool get isIndividual => category == 'individual';
  
  String get statusMessage {
    if (status == 'valid') {
      return 'PAN verified successfully';
    } else if (remarks != null) {
      return remarks!;
    } else {
      return 'PAN verification failed';
    }
  }

  //tojson
  Map<String, dynamic> toJson() {
    return {
      '@entity': entity,
      'pan': pan,
      'status': status,
      'remarks': remarks,
      'name_as_per_pan_match': nameMatch,
      'date_of_birth_match': dobMatch,
      'category': category,
      'aadhaar_seeding_status': aadhaarSeedingStatus,
    };
  }
}

/// Custom Exception for KYC API Errors
class KycApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic> errorDetails;

  KycApiException({
    required this.message,
    required this.statusCode,
    required this.errorDetails,
  });

  @override
  String toString() => message;
}

/// Aadhaar OTP Response Model
class AadhaarOtpResponse {
  final int code;
  final int timestamp;
  final String referenceId;
  final String message;

  AadhaarOtpResponse({
    required this.code,
    required this.timestamp,
    required this.referenceId,
    required this.message,
  });

  factory AadhaarOtpResponse.fromJson(Map<String, dynamic> json) {
    return AadhaarOtpResponse(
      code: json['code'] ?? 0,
      timestamp: json['timestamp'] ?? 0,
      referenceId: json['reference_id'] ?? (json['data']?['reference_id']as int).toString() ?? '',
      message: json['message'] ?? 'OTP sent successfully',
    );
  }

  bool get isSuccess => code == 200;
}

/// Aadhaar Verification Response Model
class AadhaarVerificationResponse {
  final int code;
  final int timestamp;
  final AadhaarData? data;
  final String transactionId;

  AadhaarVerificationResponse({
    required this.code,
    required this.timestamp,
    this.data,
    required this.transactionId,
  });

  factory AadhaarVerificationResponse.fromJson(Map<String, dynamic> json) {
    return AadhaarVerificationResponse(
      code: json['code'] ?? 0,
      timestamp: json['timestamp'] ?? 0,
      data: json['data'] != null ? AadhaarData.fromJson(json['data']) : null,
      transactionId: json['transaction_id'] ?? '',
    );
  }

  bool get isSuccess => code == 200 && data != null;
  bool get isValid => data?.status.toLowerCase() == 'valid';
}

/// Aadhaar Data Model
class AadhaarData {
  final String aadhaarNumber;
  final String status;
  final String? name;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? photo;
  final String? careOf;
  final String? splitAddress;

  AadhaarData({
    required this.aadhaarNumber,
    required this.status,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.photo,
    this.careOf,
    this.splitAddress,
  });

  factory AadhaarData.fromJson(Map<String, dynamic> json) {
    return AadhaarData(
      aadhaarNumber: json['aadhaar_number'] ?? '',
      status: json['status'] ?? 'invalid',
      name: json['name'],
      dateOfBirth: json['date_of_birth'] ?? json['dob'],
      gender: json['gender'],
      address: json['full_address'] ?? "",  //json['address']?['full_address'] ?? json['address']
      photo: json['photo_link'],
      careOf: json['care_of'],
      splitAddress: json['split_address'] != null 
          ? jsonEncode(json['split_address']) 
          : null,
    );
  }
}
