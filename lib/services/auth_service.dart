import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:janseva/config/api_config.dart';
import 'package:janseva/modules/auth/models/create_profile_params.dart';
import 'package:janseva/services/kyc_service.dart';
import 'package:janseva/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  // Send OTP to phone number
  static Future<bool> sendOtp(String phoneNumber) async {
    try {
      String url = '${ApiConfig.domain}${ApiConfig.loginPath}';
      final res = await ApiService.post(url, body: {'mobileNo': phoneNumber});
      log(res.toString());
      if (res['success'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    try {
      var res = await ApiService.post(
        '${ApiConfig.domain}${ApiConfig.verifyOtpPath}',
        body: {'mobileNo': phoneNumber, 'otp': otp},
      );
      if (res['success'] == true) {
        print("_______________________________________");
        log(res.toString());
        log(res['result']['accessToken']);
        await _saveToken(res['result']['accessToken']);
      }
      return res;
    } catch (e) {
      print('Error verifying OTP: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  static Future<User?> createprofile(CreateProfileParams userdata) async {
    try {
      var res = await ApiService.post(
        '${ApiConfig.domain}${ApiConfig.createProfile}',
        body: userdata.toJson(),
      );
      log(res.toString());
      var user = User.fromJson(res['result']);

      user.copyWith(isNew: false);
      return user;
    } catch (e) {
      throw ApiException('Error creating profile');
    }
  }

  static Future<bool?> savePanDetails(PanData pandata, String id) async {
    try {
      var res = await ApiService.post(
        '${ApiConfig.domain}${ApiConfig.savePan}',
        body: {
          'id': id,
          'panNumber': pandata.pan,
          'panDetails': pandata.toJson(),
        },
      );
      log(res.toString());
      return null;
    } catch (e) {
      throw ApiException('Error getting profile');
    }
  }

  static Future<bool?> saveAadharDetails(
    String aadharNumber,
    AadhaarData aadharData,
    String id,
  ) async {
    try {
      var res = await ApiService.post(
        '${ApiConfig.domain}${ApiConfig.saveAdhar}',
        body: {
          'id': id,
          'aadharNumber': aadharNumber,
          'address': aadharData.address,
          'aadharDetails': aadharData.jsonData,
        },
      );
      log(res.toString());
      return null;
    } catch (e) {
      return false;
    }
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    try {
      var userData = await SfService.getJson(SfService.userKey);
      if (userData != null) {
        return User.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final token = await _getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      await SfService.clear();
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // // Update user profile
  // static Future<Map<String, dynamic>> updateProfile(
  //   Map<String, dynamic> userData,
  // ) async {
  //   try {
  //     final token = await _getToken();
  //     final response = await http.put(
  //       Uri.parse('$baseUrl/user/profile'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: json.encode(userData),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       await _saveUserData(data['user']);
  //       return {'success': true, 'user': User.fromJson(data['user'])};
  //     }
  //     return {'success': false, 'message': 'Update failed'};
  //   } catch (e) {
  //     print('Error updating profile: $e');
  //     return {'success': false, 'message': 'Network error'};
  //   }
  // }

  // Update user data after KYC
  static Future<bool> updateUserAfterKyc(User user) async {
    try {
      await _saveUserData(user.toJson());
      return true;
    } catch (e) {
      print('Error updating user after KYC: $e');
      return false;
    }
  }

  // Helper methods
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SfService.accesstoken, token);
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SfService.accesstoken);
  }

  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    await SfService.saveJson(SfService.userKey, userData);
  }
}
