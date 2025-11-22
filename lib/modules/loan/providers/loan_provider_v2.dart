import 'package:flutter/material.dart';
import 'package:janseva/modules/loan/models/loan_application_response.dart';
import 'package:janseva/modules/loan/screens/components/adhaar_verify.dart';
import 'package:janseva/modules/loan/services/esign_service.dart';
import 'package:janseva/services/common_utils.dart';
import 'package:janseva/services/kyc_service.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../providers/user_provider.dart';
import '../models/eStamp/esign_params.dart';
import '../models/loan_product.dart';
import '../services/loan_service.dart';

class LoanProviderV2 extends ChangeNotifier {
  //Common variables
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = '';
  String get error => _error;

  //Loan Products
  List<LoanProduct> _loanProducts = [];
  List<LoanProduct> get loanProducts => _loanProducts;
  LoanProduct? _selectedLoanProduct;
  LoanProduct? get selectedLoanProduct => _selectedLoanProduct;
  bool hasmoreLoanProducts = true;
  int _page = 1;
  Future<void> getLoanProducts({bool isRefresh = false}) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Reset pagination if refreshing
      if (isRefresh) {
        _page = 1;
        _loanProducts = [];
      }

      final response = await LoanServices.getAllLoanProducts(page: _page);
      if (response != null) {
        // Append new products to existing list for pagination
        if (isRefresh) {
          _loanProducts = response.loanproducts;
        } else {
          _loanProducts = [..._loanProducts, ...response.loanproducts];
        }

        hasmoreLoanProducts = response.pagination?.hasNext ?? false;
        _page = response.pagination?.nextPage ?? _page + 1;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Select Loan Product
  void selectLoanProduct(LoanProduct product) {
    _selectedLoanProduct = product;
    notifyListeners();
  }

  //get LOan Steps
  int _currentLoanStep = 1;
  int get currentLoanStep => _currentLoanStep;
  int loanApplicationSteps() {
    //TODO INMPELMENT LOAN WISE
    return 5;
  }

  void nextLoanStep() {
    if (_currentLoanStep >= loanApplicationSteps()) {
      return;
    }
    _currentLoanStep++;
    notifyListeners();
  }

  void previousLoanStep() {
    if (_currentLoanStep <= 1) {
      return;
    }
    _currentLoanStep--;
    notifyListeners();
  }

  List<Widget> loanApplicationScreens() {
    return [AdhaarVerifyScreen()];
  }

  //Apply Loan
  bool _isApplyLoanLoading = false;
  bool get isApplyLoanLoading => _isApplyLoanLoading;

  Future<void> applyLoan() async {
    try {
      _isApplyLoanLoading = true;
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      _isApplyLoanLoading = false;
      notifyListeners();
    }
  }

  //Loan Application tracking + Updating
  List<LoanApplicationData> _loanApplicationData = [];
  List<LoanApplicationData> get loanApplicationData => _loanApplicationData;

  Future<void> getmmyLoanApplications() async {
    var user = bContext.read<UserProvider>().currentUser;
    try {
      _isLoading = true;
      notifyListeners();
      final response = await LoanServices.getMyLoans(user!.id);
      if (response != null) {
        _loanApplicationData = response.loanApplications;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearLoanApplicationData() {
    _loanApplicationData = [];
    notifyListeners();
  }

  void removeLoanApplicationData(LoanApplicationData data) {
    _loanApplicationData = _loanApplicationData
        .where((element) => element.id != data.id)
        .toList();
    notifyListeners();
  }

  void updateLoanApplicationData(LoanApplicationData data) {
    final index = _loanApplicationData.indexWhere(
      (element) => element.id == data.id,
    );

    if (index == -1) {
      // Item doesn't exist, add it
      _loanApplicationData = [..._loanApplicationData, data];
    } else {
      // Item exists, update it
      _loanApplicationData = _loanApplicationData
          .map((element) => element.id == data.id ? data : element)
          .toList();
    }
    notifyListeners();
  }

  // ESIGN LOAN DOCUMENTS
  bool _isEsignLoading = false;
  bool get isEsignLoading => _isEsignLoading;
  String? _esignurl;
  String? get esignurl => _esignurl;
  String _esignError = '';
  String get esignError => _esignError;
  Future<void> esignLoanDocuments({
    required String loanId,
    Signer? signer,
    required String url,
    String? estampId,
  }) async {
    try {
      _isEsignLoading = true;
      notifyListeners();
      var document = await pdfToBase64(url);
      var reqdata = esignRequest(loanId);

      var res = await EsignService.signDocument(
        reqdata.copyWith(
          signers: signer != null ? [signer] : reqdata.signers,
          document: DocumentModel(name: 'loan_document.pdf', data: document),
          estampId: estampId,
        ),
        loanId,
      );
      if (res != null) {
        _esignurl = res.requests.first.signingUrl;
        notifyListeners();
      }
    } catch (e) {
      _esignError = e.toString();
      notifyListeners();
    } finally {
      _isEsignLoading = false;
      notifyListeners();
    }
  }

  //adhaar Component
  String? _transacrtionId;
  bool _isAdhaarLoading = false;
  AadhaarVerificationResponse? _aadhaarVerificationstatus;
  bool get isAdhaarLoading => _isAdhaarLoading;
  AadhaarVerificationResponse? get aadhaarVerificationstatus =>
      _aadhaarVerificationstatus;

  Future<void> sendAdhaarOtp(
    String aadhaarNumber,
    String userId,
    String reason,
  ) async {
    try {
      _transacrtionId = null;
      _error = '';
      _isAdhaarLoading = true;
      notifyListeners();

      var res = await KycService.requestAadhaarOtp(
        userId: userId,
        reason: reason,
        aadhaarNumber: aadhaarNumber,
      );

      if (!res.isSuccess) {
        _error = res.message;
      } else {
        _transacrtionId = res.transactionId;
      }
    } on KycApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = "Something went wrong";
    } finally {
      _isAdhaarLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyAdhaar(String otp, String userId) async {
    try {
      _error = '';
      _isAdhaarLoading = true;
      notifyListeners();

      var res = await KycService.verifyAadhaarOtp(
        otp: otp,
        transactionId: _transacrtionId!,
        userId: userId,
      );

      if (!res.isSuccess) {
        _error = "OTP verification failed";
      } else {
        _aadhaarVerificationstatus = res;
        _transacrtionId = null;
      }
    } on KycApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = "Something went wrong";
    } finally {
      _isAdhaarLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearAdhaarVerification() async {
    _aadhaarVerificationstatus = null;
    _transacrtionId = null;
    notifyListeners();
  }

  //Pan Component

  PanVerificationResponse? _panVerificationstatus;
  PanVerificationResponse? get panVerificationstatus => _panVerificationstatus;

  Future<void> verifyPan(
    String panNumber,
    String name,
    String userId, {
    String? dob,
  }) async {
    try {
      _error = '';
      _isLoading = true;
      notifyListeners();

      var res = await KycService.verifyPan(
        name: name,
        dateOfBirth: dob,
        panNumber: panNumber,
        userId: userId,
      );

      if (!res.isSuccess) {
        _error = "Pan verification failed";
      } else {
        _panVerificationstatus = res;
      }
    } on KycApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = "Something went wrong";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearPanVerification() async {
    _panVerificationstatus = null;
    notifyListeners();
  }

  //Document Upload Component
  List<DocumentModel> _documentPaths = [];
  List<DocumentModel> get documentPaths => _documentPaths;

  void addDocument(DocumentModel document) {
    _documentPaths = [..._documentPaths, document];
    notifyListeners();
  }

  void removeDocument(DocumentModel document) {
    _documentPaths = _documentPaths
        .where((element) => element != document)
        .toList();
    notifyListeners();
  }

  void clearDocuments() {
    _documentPaths = [];
    notifyListeners();
  }

  void clearApplicationData() {
    _selectedLoanProduct = null;
    _documentPaths = [];
    _panVerificationstatus = null;
    _aadhaarVerificationstatus = null;
    _transacrtionId = null;

    notifyListeners();
  }

  //Application Details
}
