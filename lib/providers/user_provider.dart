import 'package:flutter/material.dart';
import 'package:janseva/services/kyc_service.dart';
import 'package:janseva/services/storage_service.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isEditing = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEditing => _isEditing;
  bool get isMember => _currentUser?.isMember ?? false;

  // Initialize user data
  Future<void> initializeUser() async {
    _setLoading(true);
    try {
      final user = await AuthService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
      }
    } catch (e) {
      _setError('Failed to load user data');
    } finally {
      _setLoading(false);
    }
  }

  // // Update user profile
  // Future<bool> updateProfile(Map<String, dynamic> userData) async {
  //   _setLoading(true);
  //   _clearError();

  //   try {
  //     final result = await AuthService.updateProfile(userData);

  //     if (result['success']) {
  //       _currentUser = result['user'];
  //       notifyListeners();
  //       return true;
  //     } else {
  //       _setError(result['message'] ?? 'Update failed');
  //       return false;
  //     }
  //   } catch (e) {
  //     _setError('Network error');
  //     return false;
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  // // Update user data from auth
  // void updateUserFromAuth(User user) {
  //   _currentUser = user;
  //   notifyListeners();
  // }

  // Update user data
  Future<bool> updateUser(User user) async {
    _setLoading(true);
    _clearError();

    try {
      // For now, just update locally
      // In production, this would make an API call
      _currentUser = user;
      await SfService.saveJson(SfService.userKey, user.toJson());
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update user');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Set editing mode
  void setEditing(bool editing) {
    _isEditing = editing;
    notifyListeners();
  }

  // Update balance (for demo purposes)
  void updateBalance(double newBalance) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(balance: newBalance);
      notifyListeners();
    }
  }

  // Add referral
  void addReferral(String referredUserId) {
    if (_currentUser != null) {
      final currentReferrals = _currentUser!.referredUsers ?? [];
      final updatedReferrals = [...currentReferrals, referredUserId];
      _currentUser = _currentUser!.copyWith(referredUsers: updatedReferrals);
      notifyListeners();
    }
  }

  // Update user profile from Aadhaar verification
  void updateFromAadhaarVerification({
    required String name,
    required String aadhaarNumber,
    AadhaarData? aadhaarData,
    String? dateOfBirth,
    String? gender,
    String? address,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        aadharNumber: aadhaarNumber,
        dateOfBirth: dateOfBirth ?? _currentUser!.dateOfBirth,
        gender: gender ?? _currentUser!.gender,
        address: address ?? _currentUser!.address,
      );
      if (aadhaarData != null) {
        var res = AuthService.saveAadharDetails(
          aadhaarNumber,
          aadhaarData,
          _currentUser!.id,
        );
      }
      notifyListeners();
    }
  }

  // Update user profile from PAN verification
  void updateFromPanVerification({required String panNumber, String? name}) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        panNumber: panNumber,
        name: name ?? _currentUser!.name,
      );
      notifyListeners();
    }
  }

  // Clear user data
  void clearUser() {
    _currentUser = null;
    _isEditing = false;
    _clearError();
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
