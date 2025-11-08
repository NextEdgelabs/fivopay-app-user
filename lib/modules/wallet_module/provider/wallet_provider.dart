import 'package:flutter/material.dart';
import 'package:janseva/config/exceptions.dart';
import 'package:janseva/main.dart';
import 'package:janseva/modules/auth/provider/auth_provider.dart';
import 'package:janseva/modules/wallet_module/models/deposit_params.dart';
import 'package:janseva/modules/wallet_module/provider/razorpay_service.dart';
import 'package:janseva/modules/wallet_module/provider/service/wallet_servoce.dart';
import 'package:janseva/providers/user_provider.dart';
import 'package:janseva/services/api_service.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../services/storage_service.dart';
import '../models/transaction_model.dart';

class WalletProvider with ChangeNotifier {
  double _balance = 0.0;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;
  User? _currentUser;
  bool _isProcessing = false;
  String? _paymentStatus; // 'success', 'failed', or null
  late RazorpayService _razorpayService;

  // Getters
  double get balance => _balance;
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _currentUser;
  bool get isProcessing => _isProcessing;
  String? get paymentStatus => _paymentStatus;

  UserProvider? userProvider;

  // Transaction type getters
  List<Transaction> get deposits =>
      _transactions.where((t) => t.type == 'deposit').toList();

  List<Transaction> get withdrawals =>
      _transactions.where((t) => t.type == 'withdraw').toList();

  List<Transaction> get transfers =>
      _transactions.where((t) => t.type == 'transfer').toList();

  List<Transaction> get bonuses =>
      _transactions.where((t) => t.type == 'bonus').toList();

  List<Transaction> get recentTransactions => _transactions.take(10).toList();
  void _initializeRazorpay() {
    _razorpayService = RazorpayService();
    _razorpayService.initialize();
  }

  // WalletProvider() {
  //   _initializeRazorpay();
  // }
  WalletProvider() {
  _initializeRazorpay();
// loadWalletBalance();
  }
  
  // Update user provider dependency
  void updateUserProvider(UserProvider provider) {
    userProvider = provider;
    _currentUser = provider.currentUser;
    notifyListeners();
  }
  
  // Initialize wallet with user data


Future<void> loadWalletBalance(String userId ) async {
  var authToken = bContext.read<AuthProvider>().appAccessToken ?? '';
  _balance = await WalletService.getWalletBalance(authToken , userId);
  notifyListeners();
}

  // Add money to wallet (deposit)
  Future<void> addMoney({
    required double amount,
    String description = 'Wallet top-up',
    String? referenceNumber,
  }) async {
    if (amount <= 0) {
      _error = 'Amount must be greater than zero';
      notifyListeners();
      // return false;
      return;
    }
    _setProcessing(true);
    _clearError();
    _paymentStatus = null;
    try {
      // Simulate payment processing delay
      var res = await RazorpayService.createDepositOrder(
        DepositParams(amount: amount, description: description),
        bContext.read<AuthProvider>().appAccessToken ?? '',
      );
      RazorpayService.openCheckoutWithModel(
        razorpayOrder: res.order,
        onPaymentSuccess: ((e) {
          final transaction = Transaction(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: 'deposit',
            amount: amount,
            description: description,
            timestamp: DateTime.now(),
            status: 'completed',
            referenceNumber: referenceNumber,
          );
          _balance += amount;
          _transactions.insert(0, transaction);
          _paymentStatus = 'success';
          _setProcessing(false);
          notifyListeners();
        }),

        onPaymentError: ((e) {
          _error = e.message ?? 'Payment failed';
          _paymentStatus = 'failed';
          _setProcessing(false);
          notifyListeners();
        }),
      );
      // _balance += amount;
      // _transactions.insert(0, transaction);

      // Save to storage
      // await _saveBalanceToStorage();
      // await _saveTransactionHistory();

      // _setProcessing(false);
      // notifyListeners();
      // return true;
    } on RazorpayException {
      _error = 'Payment failed';
    } catch (e) {
      _error = 'Failed to add money: $e';
      _setProcessing(false);
      notifyListeners();
    } finally {
      _setProcessing(false);
      notifyListeners();
    }
  }

  // Withdraw money from wallet
  Future<bool> withdrawMoney({
    required double amount,
    String description = 'Cash withdrawal',
    String? toAccount,
    String? referenceNumber,
  }) async {
    if (amount <= 0) {
      _error = 'Amount must be greater than zero';
      notifyListeners();
      return false;
    }

    if (amount > _balance) {
      _error = 'Insufficient balance';
      notifyListeners();
      return false;
    }

    _setProcessing(true);
    _clearError();

    try {
      // Simulate withdrawal processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Create completed transaction
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'withdraw',
        amount: amount,
        description: description,
        timestamp: DateTime.now(),
        status: 'completed',
        referenceNumber: referenceNumber,
        toAccount: toAccount,
      );

      // Update balance and add transaction
      _balance -= amount;
      _transactions.insert(0, transaction);

      // // Save to storage
      // await _saveBalanceToStorage();
      // await _saveTransactionHistory();

      _setProcessing(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to withdraw money: $e';
      _setProcessing(false);
      notifyListeners();
      return false;
    }
  }

  // Transfer money to another user
  Future<bool> transferMoney({
    required double amount,
    required String recipientAccount,
    String? description,
    String? referenceNumber,
  }) async {
    if (amount <= 0) {
      _error = 'Amount must be greater than zero';
      notifyListeners();
      return false;
    }

    if (amount > _balance) {
      _error = 'Insufficient balance';
      notifyListeners();
      return false;
    }

    _setProcessing(true);
    _clearError();

    try {
      // Simulate transfer processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Create completed transaction
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'transfer',
        amount: amount,
        description: description ?? 'Transfer to $recipientAccount',
        timestamp: DateTime.now(),
        status: 'completed',
        referenceNumber: referenceNumber,
        fromAccount: _currentUser?.id,
        toAccount: recipientAccount,
      );

      // Update balance and add transaction
      _balance -= amount;
      _transactions.insert(0, transaction);

      // // Save to storage
      // await _saveBalanceToStorage();
      // await _saveTransactionHistory();

      _setProcessing(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to transfer money: $e';
      _setProcessing(false);
      notifyListeners();
      return false;
    }
  }

  // Add referral bonus
  void addReferralBonus({
    double amount = 100.0,
    String description = 'Referral bonus',
  }) {
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'bonus',
      amount: amount,
      description: description,
      timestamp: DateTime.now(),
      status: 'completed',
    );

    _balance += amount;
    _transactions.insert(0, transaction);

    // // Save to storage
    // _saveBalanceToStorage();
    // _saveTransactionHistory();

    notifyListeners();
  }

  // Get transaction statistics
  Map<String, dynamic> getTransactionStats() {
    final totalDeposits = _transactions
        .where((t) => t.type == 'deposit' && t.status == 'completed')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalWithdrawals = _transactions
        .where((t) => t.type == 'withdraw' && t.status == 'completed')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalTransfers = _transactions
        .where((t) => t.type == 'transfer' && t.status == 'completed')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalBonuses = _transactions
        .where((t) => t.type == 'bonus' && t.status == 'completed')
        .fold(0.0, (sum, t) => sum + t.amount);

    return {
      'totalDeposits': totalDeposits,
      'totalWithdrawals': totalWithdrawals,
      'totalTransfers': totalTransfers,
      'totalBonuses': totalBonuses,
      'totalTransactions': _transactions.length,
    };
  }

  // Get recent transactions
  List<Transaction> getRecentTransactions({int limit = 10}) {
    return _transactions.take(limit).toList();
  }

  // Get transactions by type
  List<Transaction> getTransactionsByType(String type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  // Get transactions by date range
  List<Transaction> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _transactions.where((t) {
      return t.timestamp.isAfter(startDate) && t.timestamp.isBefore(endDate);
    }).toList();
  }

  // Get transaction by ID
  Transaction? getTransactionById(String id) {
    try {
      return _transactions.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refresh wallet data
  Future<void> refreshWallet() async {
    if (_currentUser != null) {
      // await initializeWallet(_currentUser!);
    }
  }

  // Clear all wallet data
  Future<void> clearWalletData() async {
    _balance = 0.0;
    _transactions.clear();
    _currentUser = null;
    _error = null;
    _isLoading = false;
    _isProcessing = false;

    try {
      await SfService.remove('wallet_transactions_${_currentUser?.id}');
      await SfService.remove('wallet_balance_${_currentUser?.id}');
    } catch (e) {
      // Handle error silently
    }

    notifyListeners();
  }

  // Helper methods
  void _setProcessing(bool processing) {
    _isProcessing = processing;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void clearPaymentStatus() {
    _paymentStatus = null;
    notifyListeners();
  }

  // Utility methods
  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  bool isValidAmount(double amount) {
    return amount > 0 && amount <= 1000000; // Max 10 lakhs
  }

  bool canWithdraw(double amount) {
    return amount > 0 && amount <= _balance;
  }

  bool canTransfer(double amount) {
    return amount > 0 && amount <= _balance;
  }

  String get balanceDisplay => formatCurrency(_balance);
}
