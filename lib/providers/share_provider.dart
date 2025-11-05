import 'dart:async';
import 'package:flutter/material.dart';
import 'package:janseva/modules/wallet_module/models/deposit_params.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/share.dart';
import '../models/user.dart';
import '../modules/auth/provider/auth_provider.dart' show AuthProvider;
import '../modules/wallet_module/provider/razorpay_service.dart';
import '../services/storage_service.dart';

class ShareProvider with ChangeNotifier {
  // Constants
  static const int SHARE_PRICE = 100;
  static const int SHARES_FOR_MEMBERSHIP = 10;
  static const double MEMBERSHIP_AMOUNT =
      1000.0; // SHARE_PRICE * SHARES_FOR_MEMBERSHIP

  // Available share (dummy data)
  final Share _availableShare = Share(
    id: 'SHARE001',
    name: 'JanSeva Cooperative Share',
    pricePerShare: SHARE_PRICE.toDouble(),
    description: 'Become a member by purchasing cooperative shares',
    lastUpdated: DateTime.now(),
  );

  List<SharePurchase> _purchases = [];
  bool _isLoading = false;
  String? _error;
  User? _currentUser;
  late RazorpayService _razorpayService;
  void _initializeRazorpay() {
    _razorpayService = RazorpayService();
    _razorpayService.initialize();
  }

  // Getters
  Share get availableShare => _availableShare;
  List<SharePurchase> get purchases => List.unmodifiable(_purchases);
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalSharesOwned => _purchases
      .where((p) => p.status == 'completed')
      .fold(0, (sum, p) => sum + p.quantity);

  double get totalInvestment => _purchases
      .where((p) => p.status == 'completed')
      .fold(0.0, (sum, p) => sum + p.totalAmount);

  bool get hasMinimumShares => totalSharesOwned >= SHARES_FOR_MEMBERSHIP;
  int get sharesNeededForMembership => SHARES_FOR_MEMBERSHIP - totalSharesOwned;
  double get amountNeededForMembership => sharesNeededForMembership > 0
      ? sharesNeededForMembership * SHARE_PRICE.toDouble()
      : 0.0;

  ShareProvider() {
    _initializeRazorpay();
  }

  // Initialize with user
  Future<void> initialize(User user) async {
    _currentUser = user;
    await _loadPurchases();
    notifyListeners();
  }

  // Load purchases from storage
  Future<void> _loadPurchases() async {
    try {
      final userId = _currentUser?.id;
      if (userId != null) {
        final data = await SfService.getJson('share_purchases_$userId');
        if (data != null) {
          final List<dynamic> purchaseList = data['purchases'] ?? [];
          _purchases =
              purchaseList.map((json) => SharePurchase.fromJson(json)).toList()
                ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
        }
      }
    } catch (e) {
      _error = 'Failed to load purchases: $e';
    }
  }

  // Save purchases to storage
  Future<void> _savePurchases() async {
    try {
      final userId = _currentUser?.id;
      if (userId != null) {
        final data = {'purchases': _purchases.map((p) => p.toJson()).toList()};
        await SfService.saveJson('share_purchases_$userId', data);
      }
    } catch (e) {
      _error = 'Failed to save purchases: $e';
    }
  }

  // Calculate shares from amount
  int calculateSharesFromAmount(double amount) {
    return (amount / SHARE_PRICE).floor();
  }

  // Calculate amount from shares
  double calculateAmountFromShares(int shares) {
    return shares * SHARE_PRICE.toDouble();
  }

  // Buy shares by quantity
  Future<bool> buySharesByQuantity(int quantity, String userId) async {
    if (quantity <= 0) {
      _error = 'Please enter a valid quantity';
      notifyListeners();
      return false;
    }

    final totalAmount = calculateAmountFromShares(quantity);
    return await _processPurchase(quantity, totalAmount, userId);
  }

  // Buy shares by amount
  // Future<bool> buySharesByAmount(double amount) async {
  //   if (amount < SHARE_PRICE) {
  //     _error = 'Minimum amount is ₹${SHARE_PRICE.toStringAsFixed(0)}';
  //     notifyListeners();
  //     return false;
  //   }

  //   final quantity = calculateSharesFromAmount(amount);
  //   if (quantity <= 0) {
  //     _error = 'Invalid amount';
  //     notifyListeners();
  //     return false;
  //   }

  //   final totalAmount = calculateAmountFromShares(quantity);
  //   return await _processPurchase(quantity, totalAmount);
  // }

  // Process the purchase
  Future<bool> _processPurchase(int quantity, double totalAmount, String userId) async {
    _setLoading(true);
    _clearError();

    try {
      // Create a completer to wait for payment result
      final Completer<bool> paymentCompleter = Completer<bool>();

      // Create deposit order
      var res = await RazorpayService.createSharePurchaseOrder(
        SharePurchaseParams(quantity : quantity, pricePerShare: SHARE_PRICE, customerId: userId),
        bContext.read<AuthProvider>().appAccessToken ?? '',
      );

      // Open Razorpay checkout
      RazorpayService.openCheckoutWithModel(
        razorpayOrder: res.razorpayOrder,
        onPaymentSuccess: (e) async {
          try {
            final purchase = SharePurchase(
              id: 'PUR${DateTime.now().millisecondsSinceEpoch}',
              shareId: _availableShare.id,
              quantity: quantity,
              pricePerShare: SHARE_PRICE.toDouble(),
              totalAmount: totalAmount,
              purchaseDate: DateTime.now(),
              status: 'completed',
            );

            _purchases.insert(0, purchase);
            await _savePurchases();
            
            _setLoading(false);
            
            // Complete with success
            if (!paymentCompleter.isCompleted) {
              paymentCompleter.complete(true);
            }
          } catch (e) {
            _error = 'Failed to save purchase: $e';
            _setLoading(false);
            
            // Complete with failure
            if (!paymentCompleter.isCompleted) {
              paymentCompleter.complete(false);
            }
          }
        },
        onPaymentError: (r) {
          _error = "Payment failed: ${r.error ?? 'Unknown error'}";
          _setLoading(false);
          
          // Complete with failure
          if (!paymentCompleter.isCompleted) {
            paymentCompleter.complete(false);
          }
        },
      );

      // Wait for payment to complete
      return await paymentCompleter.future;
      
    } catch (e) {
      _error = 'Purchase failed: $e';
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }


  // Get purchase history
  List<SharePurchase> getPurchaseHistory({int? limit}) {
    if (limit != null) {
      return _purchases.take(limit).toList();
    }
    return _purchases;
  }

  // Get purchase statistics
  Map<String, dynamic> getStatistics() {
    final completedPurchases = _purchases
        .where((p) => p.status == 'completed')
        .toList();

    return {
      'totalPurchases': completedPurchases.length,
      'totalShares': totalSharesOwned,
      'totalInvestment': totalInvestment,
      'averagePurchaseAmount': completedPurchases.isNotEmpty
          ? totalInvestment / completedPurchases.length
          : 0.0,
      'hasMinimumShares': hasMinimumShares,
      'sharesNeeded': sharesNeededForMembership,
      'amountNeeded': amountNeededForMembership,
    };
  }

  // Check if user qualifies for membership
  bool qualifiesForMembership() {
    return hasMinimumShares;
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    if (_currentUser != null) {
      await initialize(_currentUser!);
    }
  }

  // Clear all data
  Future<void> clear() async {
    _purchases.clear();
    _currentUser = null;
    _error = null;
    _isLoading = false;

    try {
      final userId = _currentUser?.id;
      if (userId != null) {
        await SfService.remove('share_purchases_$userId');
      }
    } catch (e) {
      // Handle silently
    }

    notifyListeners();
  }

  // Format currency
  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
}
