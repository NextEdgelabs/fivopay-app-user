import 'package:flutter/material.dart';
import 'package:janseva/services/kyc_service.dart';
import 'package:janseva/services/storage_service.dart';
import '../models/user.dart';
import '../modules/fd_rd/model/branch_model.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isEditing = false;
  String? _accessToken;
  List<BranchModel> _organizationBranches = [];
  BranchModel? _selectedBranch;
  bool _isBranchLoadingMore = false;
  bool _hasMoreBranches = true;
  int _branchCurrentPage = 0;
  int _branchLimit = 20;
  String? _branchCityFilter;
  String? _branchStateFilter;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEditing => _isEditing;
  bool get isMember => _currentUser?.isMember ?? false;
  String? get accessToken => _accessToken;
  List<BranchModel> get organizationBranches => _organizationBranches;
  BranchModel? get selectedBranch => _selectedBranch;
  bool get isBranchLoadingMore => _isBranchLoadingMore;
  bool get hasMoreBranches => _hasMoreBranches;

  // Initialize user data - called automatically by ProxyProvider
  Future<void> initializeUser() async {
    // Prevent multiple simultaneous initializations
    if (_isLoading) return;

    _setLoading(true);
    try {
      // final user = await AuthService.getCurrentUser();
      // if (user != null) {
      //   _currentUser = user;
      // }
      final accessToken = await SfService.getString(SfService.accesstoken);
      _accessToken = accessToken;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load user data');
    } finally {
      _setLoading(false);
    }

    return;
  }

  Future<void> fetchOrganizationBranches({
    int page = 1,
    int limit = 20,
    String? city,
    String? state,
    bool refresh = true,
  }) async {
    final bool isFirstPage = refresh || page <= 1;

    if (isFirstPage) {
      if (_isLoading) return;
      _setLoading(true);
      _clearError();
      _branchCurrentPage = 0;
      _branchLimit = limit;
      _branchCityFilter = city;
      _branchStateFilter = state;
      _hasMoreBranches = true;
      _organizationBranches = [];
    } else {
      if (_isBranchLoadingMore || !_hasMoreBranches) return;
      _isBranchLoadingMore = true;
      _branchLimit = limit;
      _branchCityFilter = city ?? _branchCityFilter;
      _branchStateFilter = state ?? _branchStateFilter;
      notifyListeners();
    }

    try {
      final branchResponse = await AuthService.getBranches(
        page: page,
        limit: limit,
        city: city ?? _branchCityFilter,
        state: state ?? _branchStateFilter,
      );

      if (isFirstPage) {
        _organizationBranches = branchResponse.branches;
      } else {
        _organizationBranches = [
          ..._organizationBranches,
          ...branchResponse.branches,
        ];
      }

      _branchCurrentPage = page;

      if (branchResponse.hasNextPage != null) {
        _hasMoreBranches = branchResponse.hasNextPage!;
      } else if (branchResponse.totalPages != null) {
        _hasMoreBranches = page < branchResponse.totalPages!;
      } else {
        _hasMoreBranches = branchResponse.branches.length >= limit;
      }

      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch branches: ${e.toString()}');
    } finally {
      if (isFirstPage) {
        _setLoading(false);
      } else {
        _isBranchLoadingMore = false;
        notifyListeners();
      }
    }
  }

  Future<void> refreshOrganizationBranches({String? city, String? state}) {
    return fetchOrganizationBranches(
      page: 1,
      limit: _branchLimit,
      city: city ?? _branchCityFilter,
      state: state ?? _branchStateFilter,
      refresh: true,
    );
  }

  Future<void> fetchMoreOrganizationBranches() {
    return fetchOrganizationBranches(
      page: _branchCurrentPage + 1,
      limit: _branchLimit,
      city: _branchCityFilter,
      state: _branchStateFilter,
      refresh: false,
    );
  }

  void selectBranch(BranchModel branch) {
    _selectedBranch = branch;
    notifyListeners();
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
    // Address? addressdata,
    String? dateOfBirth,
    String? gender,
    String? aadharNumber,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        aadharNumber: aadhaarNumber,
        dateOfBirth: dateOfBirth ?? _currentUser!.dateOfBirth,
        gender: gender ?? _currentUser!.gender,
        address:
            "${aadhaarData?.address?.house} ${aadhaarData?.address?.street} ${aadhaarData?.address?.district}",
        pincode: aadhaarData?.address?.pincode?.toString(),
        state: aadhaarData?.address?.state,

        // district: aadhaarData?.address?.district,
        city: aadhaarData?.address?.district,
        aadhaarVerificationStatus: true,
      );
      if (aadhaarData != null) {
        AuthService.saveAadharDetails(
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
