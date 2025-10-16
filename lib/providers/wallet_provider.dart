import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class Transaction {
  final String id;
  final String type; // 'deposit', 'withdraw', 'transfer', 'bonus'
  final double amount;
  final String description;
  final DateTime timestamp;
  final String status; // 'pending', 'completed', 'failed'
  final String? referenceNumber;
  final String? fromAccount;
  final String? toAccount;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.status,
    this.referenceNumber,
    this.fromAccount,
    this.toAccount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'referenceNumber': referenceNumber,
      'fromAccount': fromAccount,
      'toAccount': toAccount,
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
      referenceNumber: json['referenceNumber'],
      fromAccount: json['fromAccount'],
      toAccount: json['toAccount'],
    );
  }
}

class WalletProvider with ChangeNotifier {
  double _balance = 5000.0;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;
  User? _currentUser;
  bool _isProcessing = false;

  // Getters
  double get balance => _balance;
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _currentUser;
  bool get isProcessing => _isProcessing;

  // Transaction type getters
  List<Transaction> get deposits => _transactions
      .where((t) => t.type == 'deposit')
      .toList();

  List<Transaction> get withdrawals => _transactions
      .where((t) => t.type == 'withdraw')
      .toList();

  List<Transaction> get transfers => _transactions
      .where((t) => t.type == 'transfer')
      .toList();

  List<Transaction> get bonuses => _transactions
      .where((t) => t.type == 'bonus')
      .toList();

  List<Transaction> get recentTransactions => _transactions
      .take(10)
      .toList();

  // Initialize wallet with user data
  Future<void> initializeWallet(User user) async {
    _currentUser = user;
    _balance = user.balance ?? 5000.0;
    await _loadTransactionHistory();
    await _loadBalanceFromStorage();
    notifyListeners();
  }

  // Load balance from storage
  Future<void> _loadBalanceFromStorage() async {
    try {
      final savedBalance = await SfService.getString('wallet_balance_${_currentUser?.id}');
      if (savedBalance != null) {
        _balance = double.tryParse(savedBalance) ?? _balance;
      }
    } catch (e) {
      _error = 'Failed to load balance: $e';
    }
  }

  // Load transaction history from storage
  Future<void> _loadTransactionHistory() async {
    try {
      final transactionData = await SfService.getJson('wallet_transactions_${_currentUser?.id}');
      if (transactionData != null) {
        final List<dynamic> transactionList = transactionData['transactions'] ?? [];
        _transactions = transactionList
            .map((json) => Transaction.fromJson(json))
            .toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      } else {
        // Load mock data for demo if no saved data
        _loadMockTransactions();
      }
    } catch (e) {
      _error = 'Failed to load transaction history: $e';
      // Load mock data as fallback
      _loadMockTransactions();
    }
  }

  // Save transaction history to storage
  Future<void> _saveTransactionHistory() async {
    try {
      final transactionData = {
        'transactions': _transactions.map((t) => t.toJson()).toList(),
      };
      await SfService.saveJson('wallet_transactions_${_currentUser?.id}', transactionData);
    } catch (e) {
      _error = 'Failed to save transaction history: $e';
    }
  }

  // Save balance to storage
  Future<void> _saveBalanceToStorage() async {
    try {
      await SfService.saveString('wallet_balance_${_currentUser?.id}', _balance.toString());
    } catch (e) {
      _error = 'Failed to save balance: $e';
    }
  }

  // Add money to wallet (deposit)
  Future<bool> addMoney({
    required double amount,
    String description = 'Wallet top-up',
    String? referenceNumber,
  }) async {
    if (amount <= 0) {
      _error = 'Amount must be greater than zero';
      notifyListeners();
      return false;
    }

    _setProcessing(true);
    _clearError();

    try {
      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Create completed transaction
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'deposit',
        amount: amount,
        description: description,
        timestamp: DateTime.now(),
        status: 'completed',
        referenceNumber: referenceNumber,
      );

      // Update balance and add transaction
      _balance += amount;
      _transactions.insert(0, transaction);

      // Save to storage
      await _saveBalanceToStorage();
      await _saveTransactionHistory();

      _setProcessing(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add money: $e';
      _setProcessing(false);
      notifyListeners();
      return false;
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

      // Save to storage
      await _saveBalanceToStorage();
      await _saveTransactionHistory();

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

      // Save to storage
      await _saveBalanceToStorage();
      await _saveTransactionHistory();

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
    
    // Save to storage
    _saveBalanceToStorage();
    _saveTransactionHistory();
    
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
  List<Transaction> getTransactionsByDateRange(DateTime startDate, DateTime endDate) {
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
        toAccount: 'JS123456',
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

  // Refresh wallet data
  Future<void> refreshWallet() async {
    if (_currentUser != null) {
      await initializeWallet(_currentUser!);
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
