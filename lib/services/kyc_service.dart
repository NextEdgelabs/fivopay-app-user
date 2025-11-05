import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:janseva/main.dart';
import 'package:janseva/modules/auth/provider/auth_provider.dart';
import 'package:janseva/services/api_service.dart';
import 'package:provider/provider.dart';
import '../config/api_config.dart';

/// Service for KYC verification using Sandbox API
class KycService {

  static Future<PanVerificationResponse> verifyPan({
    required String panNumber,
    required String name,
    required String userId,
    String? dateOfBirth,
    String? token,
    String consent = 'Y',
    String reason = 'For KYC verification purpose',
  }) async {
    try {
      final url = '${ApiConfig.domain}${ApiConfig.panVerifyPath}';
  final body = {
        'date_of_birth' : dateOfBirth ,   
         'userId' : userId ,
        'pan': panNumber.toUpperCase(),
        'name_as_per_pan': name,
        'consent': consent,
        'reason': reason,
      };
      var response = await ApiService.post(url, body: body);
     
     

     
      if (response['success'] == true) {
        final jsonResponse = response['data']['verificationData'];
        return PanVerificationResponse.fromJson(jsonResponse , response['success'] == true ? 200 : 0);
      } else {
        
        throw KycApiException(
          message: response['message'] ?? 'PAN verification failed',
          statusCode: 400,
          errorDetails: response,
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


  static Future<AadhaarOtpResponse> requestAadhaarOtp({
    required String aadhaarNumber,
    required String userId,

   required  String reason ,
  }) async {
    try {
      final url = '${ApiConfig.domain}${ApiConfig.aadhaarOtpPath}';
      final body = {
        "aadharNumber": aadhaarNumber,
        "userId": userId,
        "reason": reason,
      };

      final response = await ApiService.post(url, body: body);
      if(response['success'] == true){
        return AadhaarOtpResponse.fromJson(response['data'] , response['success'] == true ? 200 : 0);
      }else{
        throw KycApiException(
          message: response['message'] ?? 'Aadhaar OTP request failed',
          statusCode: 0,
          errorDetails: response,
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

  static Future<AadhaarVerificationResponse> verifyAadhaarOtp({
    required String transactionId,
    required String otp,
    required String userId,
  }) async {
    try {
      final url =
        '${ApiConfig.domain}${ApiConfig.aadhaarVerifyPath}'
      ;

      final body = {
        'userId': userId,
        'transactionId': transactionId,
        'otp': otp,
      };

      // print('🔍 [KYC] Aadhaar OTP Verification:');
      // print('URL: $url');
      // print('Body: ${jsonEncode(body)}');

      // final response = await http.post(
      //   url,
      //   headers: ApiConfig.headers,
      //   body: jsonEncode(body),
      // );
      final response = await ApiService.post(url, body: body);


      if (response['success'] == true) {
        return AadhaarVerificationResponse.fromJson(response['data']);
      } else {
       
        throw KycApiException(
          message: response['message'] ?? 'Aadhaar verification failed',
          statusCode: 0,
          errorDetails: response,
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

  factory PanVerificationResponse.fromJson(Map<String, dynamic> json , int staus) {
    return PanVerificationResponse(
      code: json['code'] ?? staus ,
      timestamp: json['timestamp'] ?? 0,
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
  final String transactionId;
  // final int timestamp;
  final String referenceId;
  final String message;

  AadhaarOtpResponse({
    required this.code,
    required this.transactionId,
    // required this.timestamp,
    required this.referenceId,
    required this.message,
  });

  factory AadhaarOtpResponse.fromJson(Map<String, dynamic> json , int staus ) {
    return AadhaarOtpResponse(
      transactionId: json['transactionId'] ?? '',
      code: json['code'] ?? staus ?? 0,
      // timestamp: json['timestamp'] ?? 0,
      referenceId:
          json['reference_id'] ??
          
          '',
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
  bool get isValid => data?.status?.toLowerCase() == 'valid';
}

class AadhaarData {
    final String? entity;
    final int? referenceId;
    final String? status;
    final String? message;
    final String? careOf;
    final String? fullAddress;
    final String? dateOfBirth;
    final String? emailHash;
    final String? gender;
    final String? name;
    final Address? address;
    final int? yearOfBirth;
    final String? mobileHash;
    final String? photo;
    final String? shareCode;

    AadhaarData({
        this.entity,
        this.referenceId,
        this.status,
        this.message,
        this.careOf,
        this.fullAddress,
        this.dateOfBirth,
        this.emailHash,
        this.gender,
        this.name,
        this.address,
        this.yearOfBirth,
        this.mobileHash,
        this.photo,
        this.shareCode,
    });

    AadhaarData copyWith({
        String? entity,
        int? referenceId,
        String? status,
        String? message,
        String? careOf,
        String? fullAddress,
        String? dateOfBirth,
        String? emailHash,
        String? gender,
        String? name,
        Address? address,
        int? yearOfBirth,
        String? mobileHash,
        String? photo,
        String? shareCode,
    }) => 
        AadhaarData(
            entity: entity ?? this.entity,
            referenceId: referenceId ?? this.referenceId,
            status: status ?? this.status,
            message: message ?? this.message,
            careOf: careOf ?? this.careOf,
            fullAddress: fullAddress ?? this.fullAddress,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            emailHash: emailHash ?? this.emailHash,
            gender: gender ?? this.gender,
            name: name ?? this.name,
            address: address ?? this.address,
            yearOfBirth: yearOfBirth ?? this.yearOfBirth,
            mobileHash: mobileHash ?? this.mobileHash,
            photo: photo ?? this.photo,
            shareCode: shareCode ?? this.shareCode,
        );

    factory AadhaarData.fromJson(Map<String, dynamic> json) => AadhaarData(
        entity: json["@entity"],
        referenceId: json["reference_id"],
        status: json["status"],
        message: json["message"],
        careOf: json["care_of"],
        fullAddress: json["full_address"],
        dateOfBirth: json["date_of_birth"],
        emailHash: json["email_hash"],
        gender: json["gender"],
        name: json["name"],
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        yearOfBirth: json["year_of_birth"],
        mobileHash: json["mobile_hash"],
        photo: json["photo"],
        shareCode: json["share_code"],
    );

    Map<String, dynamic> toJson() => {
        "@entity": entity,
        "reference_id": referenceId,
        "status": status,
        "message": message,
        "care_of": careOf,
        "full_address": fullAddress,
        "date_of_birth": dateOfBirth,
        "email_hash": emailHash,
        "gender": gender,
        "name": name,
        "address": address?.toJson(),
        "year_of_birth": yearOfBirth,
        "mobile_hash": mobileHash,
        "photo": photo,
        "share_code": shareCode,
    };
}

class Address {
    final String? entity;
    final String? country;
    final String? district;
    final String? house;
    final String? landmark;
    final int? pincode;
    final String? postOffice;
    final String? state;
    final String? street;
    final String? subdistrict;
    final String? vtc;

    Address({
        this.entity,
        this.country,
        this.district,
        this.house,
        this.landmark,
        this.pincode,
        this.postOffice,
        this.state,
        this.street,
        this.subdistrict,
        this.vtc,
    });

    Address copyWith({
        String? entity,
        String? country,
        String? district,
        String? house,
        String? landmark,
        int? pincode,
        String? postOffice,
        String? state,
        String? street,
        String? subdistrict,
        String? vtc,
    }) => 
        Address(
            entity: entity ?? this.entity,
            country: country ?? this.country,
            district: district ?? this.district,
            house: house ?? this.house,
            landmark: landmark ?? this.landmark,
            pincode: pincode ?? this.pincode,
            postOffice: postOffice ?? this.postOffice,
            state: state ?? this.state,
            street: street ?? this.street,
            subdistrict: subdistrict ?? this.subdistrict,
            vtc: vtc ?? this.vtc,
        );

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        entity: json["@entity"],
        country: json["country"],
        district: json["district"],
        house: json["house"],
        landmark: json["landmark"],
        pincode: json["pincode"],
        postOffice: json["post_office"],
        state: json["state"],
        street: json["street"],
        subdistrict: json["subdistrict"],
        vtc: json["vtc"],
    );

    Map<String, dynamic> toJson() => {
        "@entity": entity,
        "country": country,
        "district": district,
        "house": house,
        "landmark": landmark,
        "pincode": pincode,
        "post_office": postOffice,
        "state": state,
        "street": street,
        "subdistrict": subdistrict,
        "vtc": vtc,
    };
}






