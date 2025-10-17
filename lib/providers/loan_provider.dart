import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/loan_application.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/loan_service.dart';
import '../services/kyc_service.dart';
import '../utils/secure_storage.dart';

class LoanProvider extends ChangeNotifier {
  final LoanService _loanService = LoanService();
  final SecureStorage _secureStorage = SecureStorage();

  // Form state
  String _applicantType = 'self';
  String? _selectedRelation;
  String? _relativeName;
  String? _relativePhone;
  String? _relativePAN;
  String? _relativeAadhaar;

  // Verification state
  bool _isPANVerified = false;
  bool _isAadhaarVerified = false;
  String? _panVerificationDate;
  String? _aadhaarVerificationDate;
  Map<String, dynamic>? _aadhaarDetails;

  // Address state
  String? _currentAddress;
  String? _aadhaarAddress;
  bool _isCurrentAddressSameAsAadhaar = true;

  // Loan details
  String _loanType = 'personal';
  double _requestedAmount = 0;
  String _purpose = '';
  int _tenureMonths = 12;
  double _profitRate = 12.0;
  double _monthlyInstallment = 0;

  // Loading states
  bool _isVerifyingPAN = false;
  bool _isVerifyingAadhaar = false;
  bool _isSubmitting = false;

  // Current user reference
  User? _currentUser;

  // Getters
  String get applicantType => _applicantType;
  String? get selectedRelation => _selectedRelation;
  String? get relativeName => _relativeName;
  String? get relativePhone => _relativePhone;
  String? get relativePAN => _relativePAN;
  String? get relativeAadhaar => _relativeAadhaar;
  bool get isPANVerified => _isPANVerified;
  bool get isAadhaarVerified => _isAadhaarVerified;
  String? get panVerificationDate => _panVerificationDate;
  String? get aadhaarVerificationDate => _aadhaarVerificationDate;
  Map<String, dynamic>? get aadhaarDetails => _aadhaarDetails;
  String? get currentAddress => _currentAddress;
  String? get aadhaarAddress => _aadhaarAddress;
  bool get isCurrentAddressSameAsAadhaar => _isCurrentAddressSameAsAadhaar;
  String get loanType => _loanType;
  double get requestedAmount => _requestedAmount;
  String get purpose => _purpose;
  int get tenureMonths => _tenureMonths;
  double get profitRate => _profitRate;
  double get monthlyInstallment => _monthlyInstallment;
  bool get isVerifyingPAN => _isVerifyingPAN;
  bool get isVerifyingAadhaar => _isVerifyingAadhaar;
  bool get isSubmitting => _isSubmitting;
  User? get currentUser => _currentUser;

  // Initialize with current user
  void initializeWithUser(User user) {
    _currentUser = user;
    if (_applicantType == 'self') {
      _populateUserDetails();
    }
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    _applicantType = 'self';
    _selectedRelation = null;
    _relativeName = null;
    _relativePhone = null;
    _relativePAN = null;
    _relativeAadhaar = null;
    _isPANVerified = false;
    _isAadhaarVerified = false;
    _panVerificationDate = null;
    _aadhaarVerificationDate = null;
    _aadhaarDetails = null;
    _currentAddress = null;
    _aadhaarAddress = null;
    _isCurrentAddressSameAsAadhaar = true;
    _loanType = 'personal';
    _requestedAmount = 0;
    _purpose = '';
    _tenureMonths = 12;
    _monthlyInstallment = 0;
    notifyListeners();
  }

  // Set applicant type
  void setApplicantType(String type) {
    _applicantType = type;
    if (type == 'self') {
      _populateUserDetails();
      _selectedRelation = null;
      _relativeName = null;
      _relativePhone = null;
    } else {
      // Clear all fields for relative application
      _selectedRelation = null;
      _relativeName = null;
      _relativePhone = null;
      _relativePAN = null;
      _relativeAadhaar = null;
      _isPANVerified = false;
      _isAadhaarVerified = false;
      _panVerificationDate = null;
      _aadhaarVerificationDate = null;
      _aadhaarDetails = null;
      _aadhaarAddress = null;
    }
    notifyListeners();
  }

  // Populate user details for self application
  void _populateUserDetails() {
    if (_currentUser != null) {
      _currentAddress = _currentUser!.address;
      // Only populate PAN and Aadhaar for self applications
      if (_applicantType == 'self') {
        if (_currentUser!.panNumber != null) {
          _relativePAN = _currentUser!.panNumber;
        }
        if (_currentUser!.aadharNumber != null) {
          _relativeAadhaar = _currentUser!.aadharNumber;
        }
      }
    }
  }

  // Set relative details
  void setRelativeDetails({String? relation, String? name, String? phone}) {
    _selectedRelation = relation;
    _relativeName = name;
    _relativePhone = phone;
    notifyListeners();
  }

  // Set loan details
  void setLoanDetails({
    String? loanType,
    double? amount,
    String? purpose,
    int? tenure,
  }) {
    if (loanType != null) _loanType = loanType;
    if (amount != null) _requestedAmount = amount;
    if (purpose != null) _purpose = purpose;
    if (tenure != null) _tenureMonths = tenure;
    _calculateInstallment();
    notifyListeners();
  }

  // Calculate monthly installment
  void _calculateInstallment() {
    if (_requestedAmount > 0 && _tenureMonths > 0) {
      final annualProfit = _requestedAmount * (_profitRate / 100);
      final totalProfit = annualProfit * (_tenureMonths / 12);
      final totalAmount = _requestedAmount + totalProfit;
      _monthlyInstallment = totalAmount / _tenureMonths;
    }
  }

  // Verify PAN
  Future<void> verifyPAN(String pan) async {
    _isVerifyingPAN = true;
    _relativePAN = pan;
    notifyListeners();

    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('Not authenticated');

      final name = _applicantType == 'self'
          ? _currentUser?.name ?? ''
          : _relativeName ?? '';

      final result = await _loanService.verifyPAN(
        token: token,
        panNumber: pan,
        name: name,
      );

      if (result['success'] == true) {
        // OTP sent successfully
        notifyListeners();
      }
    } catch (e) {
      throw Exception('PAN verification failed: $e');
    } finally {
      _isVerifyingPAN = false;
      notifyListeners();
    }
  }

  // Verify PAN OTP
  Future<void> verifyPANOTP(String otp) async {
    _isVerifyingPAN = true;
    notifyListeners();

    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('Not authenticated');

      final result = await _loanService.verifyPANOTP(
        token: token,
        panNumber: _relativePAN ?? '',
        otp: otp,
      );

      if (result['verified'] == true) {
        _isPANVerified = true;
        _panVerificationDate = DateTime.now().toIso8601String();
      }
    } catch (e) {
      throw Exception('PAN OTP verification failed: $e');
    } finally {
      _isVerifyingPAN = false;
      notifyListeners();
    }
  }

  // Set PAN as verified with API response
  Future<void> setPANVerified(String pan, dynamic verificationResponse) async {
    _relativePAN = pan;
    _isPANVerified = true;
    _panVerificationDate = DateTime.now().toIso8601String();

    // Store verification transaction ID if available
    if (verificationResponse != null &&
        verificationResponse.transactionId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'pan_verification_txn',
        verificationResponse.transactionId,
      );
    }

    notifyListeners();
  }

  // Set Aadhaar as verified with API response
  Future<void> setAadhaarVerified(
    String aadhaar,
    dynamic verificationResponse,
  ) async {
    _relativeAadhaar = aadhaar;
    _isAadhaarVerified = true;
    _aadhaarVerificationDate = DateTime.now().toIso8601String();

    // Store Aadhaar details from API response
    if (verificationResponse != null && verificationResponse.data != null) {
      _aadhaarDetails = {
        'name': verificationResponse.data.name,
        'dob': verificationResponse.data.dateOfBirth,
        'gender': verificationResponse.data.gender,
        'address': verificationResponse.data.address,
      };

      // Store verification transaction ID if available
      if (verificationResponse.transactionId != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'aadhaar_verification_txn',
          verificationResponse.transactionId,
        );
      }
    }

    notifyListeners();
  }

  // Verify Aadhaar
  Future<void> verifyAadhaar(String aadhaar) async {
    _isVerifyingAadhaar = true;
    _relativeAadhaar = aadhaar;
    notifyListeners();

    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('Not authenticated');

      final result = await _loanService.verifyAadhaar(
        token: token,
        aadhaarNumber: aadhaar,
      );

      if (result['success'] == true) {
        // OTP sent successfully
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Aadhaar verification failed: $e');
    } finally {
      _isVerifyingAadhaar = false;
      notifyListeners();
    }
  }

  // Verify Aadhaar OTP
  Future<void> verifyAadhaarOTP(String otp) async {
    _isVerifyingAadhaar = true;
    notifyListeners();

    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('Not authenticated');

      final result = await _loanService.verifyAadhaarOTP(
        token: token,
        aadhaarNumber: _relativeAadhaar ?? '',
        otp: otp,
      );

      if (result['verified'] == true) {
        _isAadhaarVerified = true;
        _aadhaarVerificationDate = DateTime.now().toIso8601String();
        _aadhaarDetails = result['details'];
        _aadhaarAddress = result['details']?['address'];

        // If current address is same as aadhaar, update it
        if (_isCurrentAddressSameAsAadhaar) {
          _currentAddress = _aadhaarAddress;
        }
      }
    } catch (e) {
      throw Exception('Aadhaar OTP verification failed: $e');
    } finally {
      _isVerifyingAadhaar = false;
      notifyListeners();
    }
  }

  // Set address details
  void setAddressDetails({String? currentAddress, bool? isSameAsAadhaar}) {
    if (currentAddress != null) _currentAddress = currentAddress;
    if (isSameAsAadhaar != null) {
      _isCurrentAddressSameAsAadhaar = isSameAsAadhaar;
      if (isSameAsAadhaar && _aadhaarAddress != null) {
        _currentAddress = _aadhaarAddress;
      }
    }
    notifyListeners();
  }

  // Submit loan application
  Future<LoanApplication> submitLoanApplication() async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final token = await _secureStorage.getToken();
      if (token == null) throw Exception('Not authenticated');

      // Validate required fields
      if (!_isPANVerified || !_isAadhaarVerified) {
        throw Exception('Please complete PAN and Aadhaar verification');
      }

      if (_requestedAmount <= 0 || _purpose.isEmpty) {
        throw Exception('Please enter valid loan details');
      }

      // Create loan application
      final loanApplication = LoanApplication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        accountNumber: _currentUser?.accountNumber ?? '',
        loanType: _loanType,
        requestedAmount: _requestedAmount,
        tenureMonths: _tenureMonths,
        purpose: _purpose,
        status: 'pending',
        applicationDate: DateTime.now(),
        profitRate: _profitRate,
        monthlyInstallment: _monthlyInstallment,
        applicantType: _applicantType,
        relativeName: _applicantType == 'relative' ? _relativeName : null,
        relativeRelation: _applicantType == 'relative'
            ? _selectedRelation
            : null,
        relativePAN: _relativePAN,
        relativeAadhaar: _relativeAadhaar,
        relativePhone: _applicantType == 'relative' ? _relativePhone : null,
        isPANVerified: _isPANVerified,
        isAadhaarVerified: _isAadhaarVerified,
        panVerificationDate: _panVerificationDate,
        aadhaarVerificationDate: _aadhaarVerificationDate,
        currentAddress: _currentAddress,
        aadhaarAddress: _aadhaarAddress,
        isCurrentAddressSameAsAadhaar: _isCurrentAddressSameAsAadhaar,
      );

      // Submit to API
      await _loanService.submitLoanApplication(
        token: token,
        loanApplication: loanApplication,
      );

      return loanApplication;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
