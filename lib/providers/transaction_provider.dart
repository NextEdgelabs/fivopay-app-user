import 'package:flutter/material.dart';
import '../models/user.dart';

class Transaction {
  final String id;
  final String type; // 'deposit', 'withdraw', 'transfer', 'bonus'
  final double amount;
  final String description;
  final DateTime timestamp;
  final String status; // 'pending', 'completed', 'failed'

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
    );
  }
}

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  double _currentBalance = 0.0;
  bool _isLoading = false;
  String? _error;
  bool _isProcessing = false;

  List<Transaction> get transactions => _transactions;
  double get currentBalance => _currentBalance;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isProcessing => _isProcessing;

  // Initialize with user data
  void initialize(User user) {
    _currentBalance = user.balance ?? 0.0;
    _loadMockTransactions();
    notifyListeners();
  }

  // Deposit money
  Future<bool> deposit(double amount) async {
    if (amount <= 0) {
      _setError('Invalid amount');
      return false;
    }

    _setProcessing(true);
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      _currentBalance += amount;
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'deposit',
        amount: amount,
        description: 'Cash deposit',
        timestamp: DateTime.now(),
        status: 'completed',
      );

      _transactions.insert(0, transaction);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Deposit failed');
      return false;
    } finally {
      _setProcessing(false);
    }
  }

  // Withdraw money
  Future<bool> withdraw(double amount) async {
    if (amount <= 0) {
      _setError('Invalid amount');
      return false;
    }

    if (amount > _currentBalance) {
      _setError('Insufficient balance');
      return false;
    }

    _setProcessing(true);
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      _currentBalance -= amount;
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'withdraw',
        amount: amount,
        description: 'Cash withdrawal',
        timestamp: DateTime.now(),
        status: 'completed',
      );

      _transactions.insert(0, transaction);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Withdrawal failed');
      return false;
    } finally {
      _setProcessing(false);
    }
  }

  // Transfer money
  Future<bool> transfer(String recipientAccount, double amount) async {
    if (amount <= 0) {
      _setError('Invalid amount');
      return false;
    }

    if (amount > _currentBalance) {
      _setError('Insufficient balance');
      return false;
    }

    _setProcessing(true);
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      _currentBalance -= amount;
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'transfer',
        amount: amount,
        description: 'Transfer to $recipientAccount',
        timestamp: DateTime.now(),
        status: 'completed',
      );

      _transactions.insert(0, transaction);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Transfer failed');
      return false;
    } finally {
      _setProcessing(false);
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

    _currentBalance += amount;
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  // Get transaction statistics
  Map<String, dynamic> getTransactionStats() {
    final totalDeposits = _transactions
        .where((t) => t.type == 'deposit')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalWithdrawals = _transactions
        .where((t) => t.type == 'withdraw')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalTransfers = _transactions
        .where((t) => t.type == 'transfer')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalBonuses = _transactions
        .where((t) => t.type == 'bonus')
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

  // Clear transaction data
  void clearTransactionData() {
    _transactions.clear();
    _currentBalance = 0.0;
    _clearError();
    notifyListeners();
  }

  // Load mock transactions for demo
  void _loadMockTransactions() {
    _transactions = [
      Transaction(
        id: '1',
        type: 'deposit',
        amount: 5000.0,
        description: 'Initial deposit',
        timestamp: DateTime.now().subtract(const Duration(days: 30)),
        status: 'completed',
      ),
      Transaction(
        id: '2',
        type: 'bonus',
        amount: 100.0,
        description: 'Referral bonus',
        timestamp: DateTime.now().subtract(const Duration(days: 25)),
        status: 'completed',
      ),
      Transaction(
        id: '3',
        type: 'withdraw',
        amount: 1000.0,
        description: 'ATM withdrawal',
        timestamp: DateTime.now().subtract(const Duration(days: 20)),
        status: 'completed',
      ),
      Transaction(
        id: '4',
        type: 'transfer',
        amount: 500.0,
        description: 'Transfer to JS123456',
        timestamp: DateTime.now().subtract(const Duration(days: 15)),
        status: 'completed',
      ),
      Transaction(
        id: '5',
        type: 'deposit',
        amount: 2000.0,
        description: 'Salary deposit',
        timestamp: DateTime.now().subtract(const Duration(days: 10)),
        status: 'completed',
      ),
    ];
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setProcessing(bool processing) {
    _isProcessing = processing;
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
