import 'package:flutter/material.dart';
import 'package:janseva/modules/fd_rd/deposit_service.dart';
import 'package:janseva/modules/fd_rd/model/deposit_category_model.dart';
import 'package:janseva/modules/fd_rd/model/deposit_product_model.dart';

import '../../config/exceptions.dart';

class DepositProvider extends ChangeNotifier {
  List<DepositCategory> _categories = [];
  List<DepositCategory> get categories => _categories;

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
}
