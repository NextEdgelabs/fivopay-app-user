import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:janseva/main.dart';
import 'package:janseva/models/loan_application.dart';
import 'package:janseva/providers/user_provider.dart';
import 'package:janseva/services/kyc_service.dart';
import 'package:provider/provider.dart';
import '../models/loan_application_response.dart';
import '../models/models.dart';
import '../services/loan_service.dart';

class LoanProvider extends ChangeNotifier {
  // State management for loan categories
  LoanCategoriesResponse? _loanCategoriesResponse;
  bool _isLoading = false;
  bool _isApplying = false;
  String? _errorMessage;
  List<LoanCategory> _favoriteLoans = [];
  List<LoanApplicationData> _myLoanApplications = [];

  // Application state
  Map<String, dynamic> _applicationData = {};
  LoanCategory? _selectedLoanCategory;

  // Loan product management
  List<LoanProduct> _availableProducts = [];
  LoanProduct? _selectedProduct;
  AadhaarData? _aadhaarDetails;
  String? _relativeName;
  String? _relativePhone;
  String? _relativePAN;
  String? _relativeAadhaar;
  bool _isAadhaarVerified = false;
  bool _isPanVerified = false;
  String? _panVerificationDate;
  String? _aadhaarVerificationDate;
  bool _isVerifyingPAN = false;
  bool _shouldValidateForms = false;
  bool loadingproducts = false;
  String? _currentAddress;
  String? _aadhaarAddress;
  bool _isCurrentAddressSameAsAadhaar = true;

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
  List<LoanProduct> get availableProducts => _availableProducts;
  LoanProduct? get selectedProduct => _selectedProduct;
  bool get shouldValidateForms => _shouldValidateForms;
  bool get hasMoreData => _hasMoreData;
  int get currentPage => _currentPage;
  bool get isAadhaarVerified => _isAadhaarVerified;
  bool get isPanVerified => _isPanVerified;
  AadhaarData? get aadhaarDetails => _aadhaarDetails;
  String? get relativeName => _relativeName;
  String? get relativePhone => _relativePhone;
  String? get relativePAN => _relativePAN;
  String? get relativeAadhaar => _relativeAadhaar;
  String? get panVerificationDate => _panVerificationDate;
  String? get aadhaarVerificationDate => _aadhaarVerificationDate;
  bool get isVerifyingPAN => _isVerifyingPAN;
  String? get currentAddress => _currentAddress;
  String? get aadhaarAddress => _aadhaarAddress;
  List<LoanApplicationData> get myLoanApplications => _myLoanApplications;
  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Set selected loan category for application
  void setSelectedLoanCategory(LoanCategory category) {
    _selectedLoanCategory = category;
    getLoanProducts(category.id);
    notifyListeners();
  }

  void getLoanProducts(String categoryId) async {
    try {
      loadingproducts = true;
      _availableProducts = [];
      final response = await LoanServices.getLoanProductByCategory(
        categoryId: categoryId,
      );
      if (response != null) {
        _availableProducts = response.loanproducts;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching loan products: $e');
    } finally {
      loadingproducts = false;
      notifyListeners();
    }
  }

  // Select a loan product
  void selectLoanProduct(LoanProduct product) {
    _selectedProduct = product;

    // Update application data with selected product details
    updateApplicationData('selectedProduct', product.id);
    updateApplicationData('selectedProductName', product.name);
    updateApplicationData('selectedProductRate', product.interestRate);
    updateApplicationData('selectedProductMinAmount', product.minAmount);
    updateApplicationData('selectedProductMaxAmount', product.maxAmount);
    updateApplicationData('selectedProductMinTenure', product.minTenureMonths);
    updateApplicationData('selectedProductMaxTenure', product.maxTenureMonths);

    notifyListeners();
  }

  // Get loan product by ID
  LoanProduct? getLoanProductById(String productId) {
    try {
      return _availableProducts.firstWhere(
        (product) => product.id == productId,
      );
    } catch (e) {
      return null;
    }
  }

  // Get current product constraints
  Map<String, dynamic> getCurrentProductConstraints() {
    if (_selectedProduct != null) {
      return {
        'minAmount': _selectedProduct!.minAmount,
        'maxAmount': _selectedProduct!.maxAmount,
        'minTenure': _selectedProduct!.minTenureMonths,
        'maxTenure': _selectedProduct!.maxTenureMonths,
        'interestRate': _selectedProduct!.interestRate,
      };
    } else if (_selectedLoanCategory != null) {
      // Fallback to category constraints
      return {
        'minAmount': _selectedLoanCategory!.minLoanAmount,
        'maxAmount': _selectedLoanCategory!.maxLoanAmount,
        'minTenure': _selectedLoanCategory!.minTenureMonths,
        'maxTenure': _selectedLoanCategory!.maxTenureMonths,
        'interestRate': _selectedLoanCategory!.interestRate,
      };
    }
    return {};
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
    _selectedProduct = null;
    _availableProducts.clear();
    // Clear verification status when clearing application data
    _isAadhaarVerified = false;
    _isPanVerified = false;
    _panVerificationDate = null;
    _aadhaarVerificationDate = null;
    _aadhaarDetails = null;
    _relativeName = null;
    _relativePhone = null;
    _relativePAN = null;
    _relativeAadhaar = null;
    _isVerifyingPAN = false;
    // Clear any error messages
    _errorMessage = null;
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
      var params = CreateLoanparams(
        categoryId: selectedLoanCategory!.id,
        userId: bContext.read<UserProvider>().currentUser!.id,
        productId: selectedProduct!.id,
        amount: _applicationData['loanAmount'],
      );
      var res = await LoanServices.submmitLoanApplicattion(params);

      if(res['success'] == true){
        clearApplicationData();
        return true;
      }
      else {
        _setError(res['result']);
        return false;
      }


      // Here you would typically call your API service
      // final result = await LoanServices.submitApplication(_applicationData);

      // For now, simulate success
      // clearApplicationData();
      // return true;
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

  // Set Aadhaar as verified with API response
  Future<void> setAadhaarVerified(
    String aadhaar,
    AadhaarVerificationResponse verificationResponse,
  ) async {
    _relativeAadhaar = aadhaar;
    _isAadhaarVerified = true;
    _aadhaarVerificationDate = DateTime.now().toIso8601String();

    // Store Aadhaar details from API response
    if (verificationResponse.data != null) {
      _aadhaarDetails = verificationResponse.data;

      // Store verification transaction ID if available
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString(
      //   'aadhaar_verification_txn',
      //   verificationResponse.transactionId,
      // );
    }

    notifyListeners();
  }

  //   // Set PAN as verified with API response
  Future<void> setPANVerified(
    String pan,
    PanVerificationResponse verificationResponse,
  ) async {
    _relativePAN = pan;
    _isPanVerified = true;
    _panVerificationDate = DateTime.now().toIso8601String();

    // Store verification transaction ID if available
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString(
    //   'pan_verification_txn',
    //   verificationResponse.transactionId,
    // );

    notifyListeners();
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
    _selectedProduct = null;
    _availableProducts.clear();
    _currentPage = 1;
    _hasMoreData = true;
    notifyListeners();
  }

  // Validation methods
  List<String> validateLoanDetails() {
    List<String> errors = [];

    // Check if a product is selected first
    final selectedProduct = _applicationData['selectedProduct'];
    if (selectedProduct == null || selectedProduct.toString().trim().isEmpty) {
      errors.add('Please select a loan product first');
      return errors;
    }

    // Get selected product constraints
    final productMinAmount =
        _applicationData['selectedProductMinAmount'] as double?;
    final productMaxAmount =
        _applicationData['selectedProductMaxAmount'] as double?;
    final productMinTenure =
        _applicationData['selectedProductMinTenure'] as int?;
    final productMaxTenure =
        _applicationData['selectedProductMaxTenure'] as int?;

    if (productMinAmount == null ||
        productMaxAmount == null ||
        productMinTenure == null ||
        productMaxTenure == null) {
      errors.add('Product constraints not found. Please reselect the product.');
      return errors;
    }

    final loanAmount = _applicationData['loanAmount'];
    if (loanAmount == null || loanAmount.toString().isEmpty) {
      errors.add('Please enter loan amount');
    } else {
      final amount = double.tryParse(loanAmount.toString().replaceAll(',', ''));
      if (amount == null) {
        errors.add('Please enter a valid loan amount');
      } else {
        if (amount < productMinAmount) {
          errors.add(
            'Minimum loan amount is ₹${productMinAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          );
        }
        if (amount > productMaxAmount) {
          errors.add(
            'Maximum loan amount is ₹${productMaxAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          );
        }
      }
    }

    final tenure = _applicationData['tenure'];
    if (tenure == null || tenure.toString().isEmpty) {
      errors.add('Please enter loan tenure');
    } else {
      final tenureMonths = int.tryParse(tenure.toString());
      if (tenureMonths == null) {
        errors.add('Please enter a valid tenure');
      } else {
        if (tenureMonths < productMinTenure) {
          errors.add('Minimum tenure is $productMinTenure months');
        }
        if (tenureMonths > productMaxTenure) {
          errors.add('Maximum tenure is $productMaxTenure months');
        }
      }
    }

    final purpose = _applicationData['purpose'];
    if (purpose == null || purpose.toString().trim().isEmpty) {
      errors.add('Please enter the purpose of loan');
    } else if (purpose.toString().trim().length < 10) {
      errors.add('Please provide more details about loan purpose');
    }

    return errors;
  }

  List<String> validatePersonalDetails() {
    List<String> errors = [];

    final fullName = _applicationData['fullName'];
    if (fullName == null || fullName.toString().trim().isEmpty) {
      errors.add('Please enter your full name');
    } else if (fullName.toString().trim().length < 2) {
      errors.add('Please enter a valid full name');
    }

    final email = _applicationData['email'];
    if (email == null || email.toString().isEmpty) {
      errors.add('Please enter your email address');
    } else if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email.toString())) {
      errors.add('Please enter a valid email address');
    }

    final phone = _applicationData['phone'];
    if (phone == null || phone.toString().isEmpty) {
      errors.add('Please enter your phone number');
    } else if (phone.toString().length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phone.toString())) {
      errors.add('Please enter a valid 10-digit phone number');
    }

    if (!_isPanVerified) {
      errors.add('Please verify your PAN number');
    }

    if (!_isAadhaarVerified) {
      errors.add('Please verify your Aadhaar number');
    }

    final address = _applicationData['address'];
    if (address == null || address.toString().trim().isEmpty) {
      errors.add('Please enter your address');
    } else if (address.toString().trim().length < 10) {
      errors.add('Please enter a complete address');
    }

    final city = _applicationData['city'];
    if (city == null || city.toString().trim().isEmpty) {
      errors.add('Please enter your city');
    } else if (city.toString().trim().length < 2) {
      errors.add('Please enter a valid city name');
    }

    final pincode = _applicationData['pincode'];
    if (pincode == null || pincode.toString().isEmpty) {
      errors.add('Please enter your pincode');
    } else if (pincode.toString().length != 6 ||
        !RegExp(r'^[0-9]+$').hasMatch(pincode.toString())) {
      errors.add('Please enter a valid 6-digit pincode');
    }

    return errors;
  }

  List<String> validateEmploymentDetails() {
    List<String> errors = [];

    if (_selectedLoanCategory == null) {
      errors.add('No loan category selected');
      return errors;
    }

    final monthlyIncome = _applicationData['monthlyIncome'];
    if (monthlyIncome == null || monthlyIncome.toString().isEmpty) {
      errors.add('Please enter your monthly income');
    } else {
      final income = double.tryParse(
        monthlyIncome.toString().replaceAll(',', ''),
      );
      if (income == null) {
        errors.add('Please enter a valid monthly income');
      } else if (income <
          _selectedLoanCategory!.eligibilityCriteria.minIncome) {
        errors.add(
          'Minimum income required is ${_selectedLoanCategory!.eligibilityCriteria.formattedMinIncome}',
        );
      }
    }

    final employerName = _applicationData['employerName'];
    if (employerName == null || employerName.toString().trim().isEmpty) {
      errors.add('Please enter your employer/company name');
    } else if (employerName.toString().trim().length < 2) {
      errors.add('Please enter a valid employer name');
    }

    final workExperience = _applicationData['workExperience'];
    if (workExperience == null || workExperience.toString().isEmpty) {
      errors.add('Please enter your work experience');
    } else {
      final experience = double.tryParse(workExperience.toString());
      if (experience == null || experience < 0) {
        errors.add('Please enter valid work experience');
      } else if (experience > 50) {
        errors.add('Please enter a realistic work experience');
      }
    }

    return errors;
  }

  bool isStepValid(int step) {
    switch (step) {
      case 0:
        return selectedProduct != null;
      case 1:
        return validateLoanDetails().isEmpty;
      case 2:
        return validatePersonalDetails().isEmpty;
      case 3:
        return validateEmploymentDetails().isEmpty;
      default:
        return true;
    }
  }

  List<String> validateProductSelection() {
    List<String> errors = [];

    final selectedProduct = _applicationData['selectedProduct'];
    if (selectedProduct == null || selectedProduct.toString().trim().isEmpty) {
      errors.add('Please select a loan product');
    }

    return errors;
  }

  Future<void> getmmyLoanApplications() async {
    var user = bContext.read<UserProvider>().currentUser;
    try {
      _isLoading = true;
      notifyListeners();
      final response = await LoanServices.getMyLoans(user!.id);
      if (response != null) {
        _myLoanApplications = response.loanApplications;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> getStepValidationErrors(int step) {
    switch (step) {
      case 0:
        return validateProductSelection();
      case 1:
        return validateLoanDetails();
      case 2:
        return validatePersonalDetails();
      case 3:
        return validateEmploymentDetails();
      default:
        return [];
    }
  }

  void triggerFormValidation() {
    _shouldValidateForms = true;
    notifyListeners();
  }

  void clearFormValidation() {
    _shouldValidateForms = false;
    notifyListeners();
  }
}
