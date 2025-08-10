import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user.dart';
import '../providers/transaction_provider.dart';

class ReferralProvider extends ChangeNotifier {
  String? _referralCode;
  List<String> _referredUsers = [];
  int _totalEarnings = 0;
  bool _isLoading = false;
  String? _error;
  bool _isSharing = false;

  String? get referralCode => _referralCode;
  List<String> get referredUsers => _referredUsers;
  int get totalEarnings => _totalEarnings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSharing => _isSharing;
  int get totalReferrals => _referredUsers.length;

  // Initialize referral data
  void initializeReferral(User user) {
    _referralCode = user.referralCode ?? 'JANSEVA${user.id}';
    _referredUsers = user.referredUsers ?? [];
    _totalEarnings = _referredUsers.length * 100; // ₹100 per referral
    notifyListeners();
  }

  // Copy referral code to clipboard
  Future<bool> copyReferralCode() async {
    if (_referralCode == null) return false;

    try {
      await Clipboard.setData(ClipboardData(text: _referralCode!));
      return true;
    } catch (e) {
      _setError('Failed to copy referral code');
      return false;
    }
  }

  // Share via WhatsApp
  Future<bool> shareViaWhatsApp() async {
    _setSharing(true);
    try {
      final message = _buildShareMessage();
      // TODO: Implement WhatsApp sharing
      await Future.delayed(const Duration(seconds: 1)); // Simulate sharing
      return true;
    } catch (e) {
      _setError('Failed to share via WhatsApp');
      return false;
    } finally {
      _setSharing(false);
    }
  }

  // Share via SMS
  Future<bool> shareViaSMS() async {
    _setSharing(true);
    try {
      final message = _buildShareMessage();
      // TODO: Implement SMS sharing
      await Future.delayed(const Duration(seconds: 1)); // Simulate sharing
      return true;
    } catch (e) {
      _setError('Failed to share via SMS');
      return false;
    } finally {
      _setSharing(false);
    }
  }

  // Share via general sharing
  Future<bool> shareGeneral() async {
    _setSharing(true);
    try {
      final message = _buildShareMessage();
      // TODO: Implement general sharing
      await Future.delayed(const Duration(seconds: 1)); // Simulate sharing
      return true;
    } catch (e) {
      _setError('Failed to share');
      return false;
    } finally {
      _setSharing(false);
    }
  }

  // Add new referral
  void addReferral(String referredUserId) {
    if (!_referredUsers.contains(referredUserId)) {
      _referredUsers.add(referredUserId);
      _totalEarnings = _referredUsers.length * 100;
      notifyListeners();
    }
  }

  // Get referral statistics
  Map<String, dynamic> getReferralStats() {
    return {
      'totalReferrals': _referredUsers.length,
      'totalEarnings': _totalEarnings,
      'referralCode': _referralCode,
      'referredUsers': _referredUsers,
    };
  }

  // Get referral rewards info
  List<Map<String, dynamic>> getRewardsInfo() {
    return [
      {
        'title': 'For You',
        'description': '₹100 bonus on each successful referral',
        'icon': 'person',
        'color': 'primary',
      },
      {
        'title': 'For Friend',
        'description': '₹50 welcome bonus on joining',
        'icon': 'person_add',
        'color': 'secondary',
      },
      {
        'title': 'Extra Benefits',
        'description': 'Priority support and exclusive offers',
        'icon': 'star',
        'color': 'warning',
      },
    ];
  }

  // Clear referral data
  void clearReferralData() {
    _referralCode = null;
    _referredUsers.clear();
    _totalEarnings = 0;
    _clearError();
    notifyListeners();
  }

  // Helper methods
  String _buildShareMessage() {
    return 'Join JanSeva Cooperative Credit Society using my referral code: $_referralCode\n\nGet ₹50 welcome bonus and enjoy exclusive benefits!';
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSharing(bool sharing) {
    _isSharing = sharing;
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

  // Redeem referral code
  Future<bool> redeemReferral({
    required String code,
    required User newUser,
    required TransactionProvider transactionProvider,
  }) async {
    if (code.isEmpty) {
      _setError('Invalid referral code');
      return false;
    }

    // Prevent self refer
    if (code == newUser.referralCode) {
      _setError('You cannot use your own referral code');
      return false;
    }

    // For demo, assume code is valid and belongs to some existing user
    try {
      // New user bonus ₹50
      transactionProvider.addReferralBonus(
        amount: 50.0,
        description: 'Welcome referral bonus',
      );

      // In real app, we would look up referrer user and credit bonus to them.
      // For mock, simply add to internal list
      newUser.referredBy;

      // Mark referredBy
      // This function cannot modify immutable newUser object here; caller should handle update.
      return true;
    } catch (e) {
      _setError('Failed to redeem code');
      return false;
    }
  }
}
