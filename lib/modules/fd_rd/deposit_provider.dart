import 'package:flutter/material.dart';
import 'package:janseva/modules/fd_rd/deposit_service.dart';
import 'package:janseva/modules/fd_rd/model/deposit_category_model.dart';
import 'package:janseva/modules/fd_rd/model/deposit_product_model.dart';
import 'package:janseva/modules/fd_rd/model/pagination_model.dart';
import 'package:janseva/modules/fd_rd/model/pickup_address_model.dart';
import 'package:janseva/modules/fd_rd/model/term_deposit_model.dart';
import 'package:janseva/services/common_utils.dart';

import '../../config/exceptions.dart';
import '../wallet_module/models/deposit_response.dart';
import 'model/deposit_enum.dart';

class DepositProvider extends ChangeNotifier {
  List<DepositCategory> _categories = [];
  List<DepositCategory> get categories => _categories;

  final List<DepositAccountModel> _myTermDeposits = [];

  List<DepositAccountModel> get myTermDeposits => _myTermDeposits;

  PaginationModel? _depositsPagination;
  PaginationModel? get depositsPagination => _depositsPagination;

  bool _isLoadingDeposits = false;
  bool get isLoadingDeposits => _isLoadingDeposits;

  bool _isLoadingMoreDeposits = false;
  bool get isLoadingMoreDeposits => _isLoadingMoreDeposits;
  List<DepositProduct> _products = [];
  List<DepositProduct> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProductsLoading = false;
  bool get isProductsLoading => _isProductsLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchCategories({String? type}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await DepositService.getDepositCategories(type: type);
      _categories = res;
    } catch (e) {
      if (e is Failure) {
        _errorMessage = e.message;
        return;
      }
      _errorMessage = 'An error occurred while fetching deposit categories.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProducts(String type) async {
    _isProductsLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await DepositService.getDepositProducts(type: type);
      _products = res;
    } catch (e) {
      if (e is Failure) {
        _errorMessage = e.message;
        return;
      }
      _errorMessage = 'An error occurred while fetching deposit products.';
    } finally {
      _isProductsLoading = false;
      notifyListeners();
    }
  }



  Future<DepositResponse?> createTermDeposit({
    required String productId,
    required double amount,
    required String description,
    required PaymentMethod paymentMethod,
    PickupAddress? pickupAddress,
    DateTime? preferredDate,
  }) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await DepositService.createTermDeposit(
        productId: productId,
        amount: amount,
        description: description,
        paymentMethod: paymentMethod,
        pickupAddress: pickupAddress,
        preferredDate: preferredDate,
      );
      return res;
    } catch (e) {
      if (e is Failure) {
        // _errorMessage = e.message;
        showSnackbar(e.message);

        notifyListeners();
        return null;
      }
      // _errorMessage = 'An error occurred while creating term deposit.';
      showSnackbar('An error occurred while creating term deposit.');
      notifyListeners();
      return null;
    }
  }

  // Fetch user's term deposits with pagination
  Future<void> fetchUserTermDeposits(
    String userId, {
    int page = 1,
    int limit = 10,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      _isLoadingMoreDeposits = true;
    } else {
      _isLoadingDeposits = true;
      _myTermDeposits.clear();
    }
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DepositService.getUserTermDeposits(
        userId,
        page: page,
        limit: limit,
      );

      if (loadMore) {
        _myTermDeposits.addAll(response.data);
      } else {
        _myTermDeposits.clear();
        _myTermDeposits.addAll(response.data);
      }

      _depositsPagination = response.pagination;
    } catch (e) {
      if (e is Failure) {
        _errorMessage = e.message;
        showSnackbar(e.message);
      } else {
        _errorMessage = 'An error occurred while fetching deposits.';
        showSnackbar('An error occurred while fetching deposits.');
      }
    } finally {
      _isLoadingDeposits = false;
      _isLoadingMoreDeposits = false;
      notifyListeners();
    }
  }

  // Load more deposits (next page)
  Future<void> loadMoreDeposits(String userId) async {
    if (_depositsPagination == null || !_depositsPagination!.hasNextPage) {
      return;
    }

    if (_isLoadingMoreDeposits) {
      return; // Prevent multiple simultaneous load more requests
    }

    final nextPage = _depositsPagination!.currentPage + 1;
    await fetchUserTermDeposits(
      userId,
      page: nextPage,
      limit: _depositsPagination!.itemsPerPage,
      loadMore: true,
    );
  }

  // Refresh deposits (reload from page 1)
  Future<void> refreshDeposits(String userId, {int limit = 10}) async {
    await fetchUserTermDeposits(userId, page: 1, limit: limit, loadMore: false);
  }

  // Check if there are more deposits to load
  bool get hasMoreDeposits {
    return _depositsPagination?.hasNextPage ?? false;
  }

  // Get current page number
  int get currentDepositPage {
    return _depositsPagination?.currentPage ?? 1;
  }

  // Get total number of deposits
  int get totalDeposits {
    return _depositsPagination?.totalItems ?? 0;
  }
}
