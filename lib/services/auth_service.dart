import 'dart:developer';
import 'package:janseva/config/api_config.dart';
import 'package:janseva/config/exceptions.dart';
import 'package:janseva/modules/auth/models/create_profile_params.dart';
import 'package:janseva/services/kyc_service.dart';
import 'package:janseva/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../modules/auth/provider/auth_provider.dart';
import '../modules/fd_rd/model/branch_model.dart';
import 'api_service.dart';

class BranchesResponse {
  final List<BranchModel> branches;
  final int? page;
  final int? limit;
  final int? totalPages;
  final int? totalCount;
  final bool? hasNextPage;

  const BranchesResponse({
    required this.branches,
    this.page,
    this.limit,
    this.totalPages,
    this.totalCount,
    this.hasNextPage,
  });

  factory BranchesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    final rawBranches = data['branches'];
    final branches = rawBranches is List
        ? rawBranches
              .map((e) => BranchModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
        : <BranchModel>[];

    final pagination = data['pagination'] is Map<String, dynamic>
        ? data['pagination'] as Map<String, dynamic>
        : data['meta'] is Map<String, dynamic>
        ? data['meta'] as Map<String, dynamic>
        : <String, dynamic>{};

    final page = _toInt(pagination['page'] ?? data['page']);
    final limit = _toInt(pagination['limit'] ?? data['limit']);
    final totalPages = _toInt(
      pagination['totalPages'] ?? pagination['pages'] ?? data['totalPages'],
    );
    final totalCount = _toInt(
      pagination['total'] ?? pagination['totalCount'] ?? data['total'],
    );

    bool? hasNextPage;
    final hasNextRaw = pagination['hasNextPage'] ?? pagination['hasNext'];
    if (hasNextRaw is bool) {
      hasNextPage = hasNextRaw;
    } else if (pagination['nextPage'] != null) {
      hasNextPage = true;
    } else if (page != null && totalPages != null) {
      hasNextPage = page < totalPages;
    }

    return BranchesResponse(
      branches: branches,
      page: page,
      limit: limit,
      totalPages: totalPages,
      totalCount: totalCount,
      hasNextPage: hasNextPage,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

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
        // log(res['result']['accessToken']);
        await _saveToken(res['result']['accessToken']);
        return res;
      } else {
        throw Failure(message: res['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      if (e is Failure) {
        throw e;
      } else {
        print('Error verifying OTP: $e');
        throw Failure(message: 'Network error');
      }
     
    }
  }

  static Future<Map<String, dynamic>?> createprofile(
    CreateProfileParams userdata,
  ) async {
    try {
      var res = await ApiService.post(
        '${ApiConfig.domain}${ApiConfig.createProfile}',
        body: userdata.toJson(),
      );
      log(res.toString());
      var user = User.fromJson(res['result']);

      user.copyWith(isNew: false);
      return {'user': user, 'appAccessToken': res['accessToken']};
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
          'aadharDetails': aadharData.toJson(),
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
      String userId = userData?['id'] ?? '';
      if (userData != null && userId.isNotEmpty) {
        var res = await ApiService.get(
          '${ApiConfig.domain}/api/v1/user/get-user-by-id/$userId',
        );
        if (res['success'] == true) {
          var user = User.fromJson(res['data']);
          _saveUserData(user.toJson());
          return user;
        }
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

  static Future<BranchesResponse> getBranches({
    String? city,
    String? state,
    int? page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': (page ?? 1).toString(),
        'limit': limit.toString(),
        'status': 'Active',
        'organisation': appId,
      };

      if (city != null && city.trim().isNotEmpty) {
        queryParameters['city'] = city.trim();
      }

      if (state != null && state.trim().isNotEmpty) {
        queryParameters['state'] = state.trim();
      }

      final url = Uri.parse(
        '${ApiConfig.domain}${ApiConfig.getBranches}',
      ).replace(queryParameters: queryParameters).toString();

      var response = await ApiService.get(url);
      if (response['success'] == true) {
        return BranchesResponse.fromJson(response);
      } else {
        throw Failure(message: 'Failed to fetch branches');
      }
    } catch (e) {
      if (e is Failure) {
        throw e;
      } else {
        throw ApiException('Network error: ${e.toString()}');
      }
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
  static Future<void> _saveToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SfService.accesstoken, token ?? '');
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SfService.accesstoken);
  }

  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    await SfService.saveJson(SfService.userKey, userData);
  }
}
