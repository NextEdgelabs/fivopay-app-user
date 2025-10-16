import 'package:flutter/material.dart';
import 'package:janseva/services/storage_service.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

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

  // Send OTP
  Future<bool> sendOtp(String phoneNumber) async {
    _setLoading(true);
    _clearError();

    try {
      // Use mock method for development
      final success = await AuthService.sendOtpMock(phoneNumber);
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
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    _setLoading(true);
    _clearError();

    try {
      // Use mock method for development
      final result = await AuthService.verifyOtpMock(phoneNumber, otp);

      if (result['success']) {
        _currentUser = result['user'];
        // SfService.saveJson(SfService.userKey, result['user']);
        notifyListeners();
        return true;
      } else {
        _setError(result['message'] ?? 'Verification failed');
        return false;
      }
    } catch (e) {
      _setError('Network error');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP and get user info
  Future<Map<String, dynamic>> verifyOtpWithUserInfo(
    String phoneNumber,
    String otp,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      // Use mock method for development
      final result = await AuthService.verifyOtpMock(phoneNumber, otp);

      if (result['success']) {
        _currentUser = result['user'];
        notifyListeners();
        return {
          'success': true,
          'user': result['user'],
          'isNewUser': result['isNewUser'] ?? false,
        };
      } else {
        _setError(result['message'] ?? 'Verification failed');
        return {'success': false, 'message': result['message']};
      }
    } catch (e) {
      _setError('Network error');
      return {'success': false, 'message': 'Network error'};
    } finally {
      _setLoading(false);
    }
  }

  // Register user
  Future<bool> registerUser(Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await AuthService.registerUser(userData);

      if (result['success']) {
        _currentUser = result['user'];
        notifyListeners();
        return true;
      } else {
        _setError(result['message'] ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      _setError('Network error');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update profile
  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await AuthService.updateProfile(userData);

      if (result['success']) {
        _currentUser = result['user'];
        notifyListeners();
        return true;
      } else {
        _setError(result['message'] ?? 'Update failed');
        return false;
      }
    } catch (e) {
      _setError('Network error');
      return false;
    } finally {
      _setLoading(false);
    }
  }

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
