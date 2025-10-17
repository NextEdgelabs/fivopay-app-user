import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:janseva/config/api_config.dart';
import 'package:janseva/main.dart';
import 'package:janseva/modules/auth/models/create_profile_params.dart';
import 'package:janseva/providers/user_provider.dart';
import 'package:janseva/services/api_service.dart';
import 'package:janseva/services/kyc_service.dart';
import 'package:janseva/services/storage_service.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  String? accessToken;
  String? apiKey;
  String? kycaccessToken;
  String? apiversion;

  AuthProvider() {
    initKyc();
  }

  Future<void> initKyc() async {
    //use api here
    apiKey = await SfService.getString(SfService.apikey);
    kycaccessToken = await SfService.getString(SfService.kycAccessToken);
    apiversion = await SfService.getString(SfService.apiversion);
  }

  // Initialize auth state
  Future<void> initialize() async {
    _setLoading(true);
    try {
      final user = await AuthService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
      }
    } catch (e) {
      _setError('Failed to initialize auth state');
    } finally {
      _setLoading(false);
    }
  }

  void updateKycAccessToken(String token) async {
    kycaccessToken = token;
    await SfService.saveString(SfService.kycAccessToken, token);
    notifyListeners();
  }

  void updateAccessToken(String token) async {
    accessToken = token;
    await SfService.saveString(SfService.accesstoken, token);
    notifyListeners();
  }

  // Send OTP
  Future<bool> sendOtp(String phoneNumber) async {
    _setLoading(true);
    _clearError();

    try {
      // Use mock method for development
      final success = await AuthService.sendOtp(phoneNumber);
      if (success) {
        return true;
      } else {
        _setError('Failed to send OTP');
        return false;
      }
    } catch (e) {
      _setError('Network error');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    _setLoading(true);
    _clearError();

    try {
      // Use mock method for development
      final result = await AuthService.verifyOtp(phoneNumber, otp);
      // final result = await AuthService.verifyOtpMock(phoneNumber, otp);

      if (result['success']) {
        //TEMP INIT
        await SfService.saveString(SfService.apikey, ApiConfig.apiKey);
        await SfService.saveString(
          SfService.kycAccessToken,
          ApiConfig.apiToken,
        );
        await SfService.saveString(SfService.apiversion, "2.0");

        if (result["result"]['user'] == null) {
          _currentUser = User(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            phoneNumber: phoneNumber,
            isNew: true,
          );
        } else {
          _currentUser = User.fromJson(result["result"]['user']);
          bContext.read<UserProvider>().updateUser(_currentUser!);
        }

        // isLoggedIn = true;
        await initKyc();

        notifyListeners();
        return result;
      } else {
        _setError(result['message'] ?? 'Verification failed');
        return {'success': false, 'message': result['message']};
      }
    } catch (e) {
      _setError('Network error');
      return {'success': false, 'message': 'Network error'};
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  //create profile
  createProfile(CreateProfileParams params) async {
    try {
      var res = await AuthService.createprofile(params);
      if (res != null) {
        _currentUser = res;
        notifyListeners();
      }
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Failed to create profile');
    }
  }

  savePand(PanData pan) async {
    try {
      var res = await AuthService.savePanDetails(pan, currentUser!.id);

      if (res != null) {
        // _currentUser = res;
        notifyListeners();
      }
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Failed to create profile');
    }
  }
  //mock provvider

  // Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      await AuthService.logout();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Logout failed');
    } finally {
      _setLoading(false);
    }
  }

  // Update current user
  void updateCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
