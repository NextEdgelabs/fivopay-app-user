import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/loan_service.dart';

class LoanProvider extends ChangeNotifier {
  // State management for loan categories
  LoanCategoriesResponse? _loanCategoriesResponse;
  bool _isLoading = false;
  bool _isApplying = false;
  String? _errorMessage;
  List<LoanCategory> _favoriteLoans = [];

  // Application state
  Map<String, dynamic> _applicationData = {};
  LoanCategory? _selectedLoanCategory;

  // Pagination
  int _currentPage = 1;
  int _limit = 10;
  bool _hasMoreData = true;

  // Getters
  LoanCategoriesResponse? get loanCategoriesResponse => _loanCategoriesResponse;
  bool get isLoading => _isLoading;
  bool get isApplying => _isApplying;
  String? get errorMessage => _errorMessage;
  List<LoanCategory> get favoriteLoans => _favoriteLoans;
  List<LoanCategory> get loanCategories =>
      _loanCategoriesResponse?.result.loanCategories ?? [];
  List<String> get availableLoanTypes =>
      _loanCategoriesResponse?.result.availableLoanTypes ?? [];
  Map<String, dynamic> get applicationData => _applicationData;
  LoanCategory? get selectedLoanCategory => _selectedLoanCategory;
  bool get hasMoreData => _hasMoreData;
  int get currentPage => _currentPage;

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Set selected loan category for application
  void setSelectedLoanCategory(LoanCategory category) {
    _selectedLoanCategory = category;
    notifyListeners();
  }

  // Fetch loan categories
  Future<void> fetchLoanCategories({
    bool refresh = false,
    String? loanType,
    String? status = 'active',
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _loanCategoriesResponse = null;
    }

    if (_isLoading || !_hasMoreData) return;

    _setLoading(true);
    _clearError();

    try {
      final response = await LoanServices.getLoanCategories(
        page: _currentPage,
        limit: _limit,
        loanType: loanType,
        status: status,
      );

      if (response != null) {
        if (_currentPage == 1) {
          _loanCategoriesResponse = response;
        } else {
          // Append to existing data for pagination
          final existingCategories =
              _loanCategoriesResponse?.result.loanCategories ?? [];
          final newCategories = response.result.loanCategories;

          _loanCategoriesResponse = LoanCategoriesResponse(
            success: response.success,
            result: LoanCategoriesResult(
              loanCategories: [...existingCategories, ...newCategories],
              pagination: response.result.pagination,
            ),
          );
        }

        // Check if there's more data
        _hasMoreData = response.result.pagination.hasNext;
        if (_hasMoreData) {
          _currentPage++;
        }
      } else {
        _setError('Failed to fetch loan categories');
      }
    } catch (e) {
      _setError('Error fetching loan categories: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Get loan categories by type
  Future<List<LoanCategory>?> getLoanCategoriesByType(String loanType) async {
    try {
      return await LoanServices.getLoanCategoriesByType(loanType);
    } catch (e) {
      _setError('Error fetching loan categories by type: ${e.toString()}');
      return null;
    }
  }

  // Get available loan types
  Future<List<String>?> getAvailableLoanTypes() async {
    try {
      return await LoanServices.getAvailableLoanTypes();
    } catch (e) {
      _setError('Error fetching loan types: ${e.toString()}');
      return null;
    }
  }

  // Get loan category by ID
  LoanCategory? getLoanCategoryById(String categoryId) {
    try {
      return loanCategories.firstWhere((category) => category.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  // Favorites management
  void toggleFavorite(LoanCategory category) {
    final index = _favoriteLoans.indexWhere((loan) => loan.id == category.id);
    if (index != -1) {
      _favoriteLoans.removeAt(index);
    } else {
      _favoriteLoans.add(category);
    }
    notifyListeners();
  }

  bool isFavorite(LoanCategory category) {
    return _favoriteLoans.any((loan) => loan.id == category.id);
  }

  // Application data management
  void updateApplicationData(String key, dynamic value) {
    _applicationData[key] = value;
    notifyListeners();
  }

  void setApplicationData(Map<String, dynamic> data) {
    _applicationData = Map<String, dynamic>.from(data);
    notifyListeners();
  }

  void clearApplicationData() {
    _applicationData.clear();
    _selectedLoanCategory = null;
    notifyListeners();
  }

  // Submit loan application
  Future<bool> submitLoanApplication() async {
    if (_selectedLoanCategory == null) {
      _setError('No loan category selected');
      return false;
    }

    _setApplying(true);
    _clearError();

    try {
      // Simulate API call for loan application
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically call your API service
      // final result = await LoanServices.submitApplication(_applicationData);

      // For now, simulate success
      clearApplicationData();
      return true;
    } catch (e) {
      _setError('Failed to submit loan application: ${e.toString()}');
      return false;
    } finally {
      _setApplying(false);
    }
  }

  // EMI Calculator
  Map<String, double> calculateEMI({
    required double principal,
    required double annualRate,
    required int tenureMonths,
  }) {
    try {
      final monthlyRate = annualRate / (12 * 100);
      final numerator =
          principal * monthlyRate * math.pow((1 + monthlyRate), tenureMonths);
      final denominator = math.pow((1 + monthlyRate), tenureMonths) - 1;
      final emi = numerator / denominator;

      final totalAmount = emi * tenureMonths;
      final totalInterest = totalAmount - principal;

      return {
        'emi': emi,
        'totalAmount': totalAmount,
        'totalInterest': totalInterest,
        'principal': principal,
      };
    } catch (e) {
      return {
        'emi': 0.0,
        'totalAmount': 0.0,
        'totalInterest': 0.0,
        'principal': 0.0,
      };
    }
  }

  // Filter loans by criteria
  List<LoanCategory> filterLoans({
    String? loanType,
    double? minAmount,
    double? maxAmount,
    double? maxInterestRate,
    int? maxTenure,
  }) {
    return loanCategories.where((loan) {
      bool matches = true;

      if (loanType != null && loanType.isNotEmpty) {
        matches =
            matches && loan.loanType.toLowerCase() == loanType.toLowerCase();
      }

      if (minAmount != null) {
        matches = matches && loan.maxLoanAmount >= minAmount;
      }

      if (maxAmount != null) {
        matches = matches && loan.minLoanAmount <= maxAmount;
      }

      if (maxInterestRate != null) {
        matches = matches && loan.interestRate <= maxInterestRate;
      }

      if (maxTenure != null) {
        matches = matches && loan.minTenureMonths <= maxTenure;
      }

      return matches;
    }).toList();
  }

  // Search loans
  List<LoanCategory> searchLoans(String query) {
    if (query.isEmpty) return loanCategories;

    final lowercaseQuery = query.toLowerCase();
    return loanCategories.where((loan) {
      return loan.categoryName.toLowerCase().contains(lowercaseQuery) ||
          loan.description.toLowerCase().contains(lowercaseQuery) ||
          loan.loanType.toLowerCase().contains(lowercaseQuery) ||
          loan.features.any(
            (feature) => feature.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setApplying(bool applying) {
    _isApplying = applying;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Reset provider state
  void reset() {
    _loanCategoriesResponse = null;
    _isLoading = false;
    _isApplying = false;
    _errorMessage = null;
    _applicationData.clear();
    _selectedLoanCategory = null;
    _currentPage = 1;
    _hasMoreData = true;
    notifyListeners();
  }
}
