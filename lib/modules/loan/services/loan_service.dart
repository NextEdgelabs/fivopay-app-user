import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:janseva/modules/loan/models/loan_product_response.dart';
import 'package:janseva/services/api_service.dart';
import '../../../config/api_config.dart';
import '../models/loan_application_response.dart';
import '../models/loan_categories_response.dart';
import '../models/loan_category.dart';

class LoanServices {
  // Get all loan categories with pagination
  static Future<LoanCategoriesResponse?> getLoanCategories({
    int page = 1,
    int limit = 10,
    String? loanType,
    String? status = 'active',
  }) async {
    try {
      // Build query parameters
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (loanType != null && loanType.isNotEmpty) {
        queryParams['loanType'] = loanType;
      }

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      // Build URL with query parameters
      final uri = Uri.parse(
        '${ApiConfig.domain}${ApiConfig.getLoancategories}',
      ).replace(queryParameters: queryParams);

      // Make HTTP GET request
      var res = await ApiService.get(uri.toString());
      if (res['success']) {
        return LoanCategoriesResponse.fromJson(res);
      } else {
        return null;
      }
    } catch (e) {
      print('Exception in getLoanCategories: $e');
      return null;
    }
  }

  static Future<LoanProductResponse?> getLoanProductByCategory({
    int page = 1,
    int limit = 10,
    String? categoryId,
    // String? status = 'active',
  }) async {
    try {
      // Build URL with query parameters
      final uri = '${ApiConfig.domain}${ApiConfig.getLoanProducts}/$categoryId';

      // Make HTTP GET request
      var res = await ApiService.get(uri.toString());
      if (res['success']) {
        return LoanProductResponse.fromJson(res);
      } else {
        return null;
      }
    } catch (e) {
      print('Exception in getLoanCategories: $e');
      return null;
    }
  }

  static Future<dynamic> submmitLoanApplicattion(
    CreateLoanparams params,
  ) async {
    try {
      String url = '${ApiConfig.domain}${ApiConfig.submitLoanApplication}';
      var res = await ApiService.post(url, body: params.toJson());
      log('Loan Application Response: $res');
      return res;
    } catch (e) {
      print('Exception in submmitLoanApplicattion: $e');
    }
  }

  static Future<LoanApplicationResponse?> getMyLoans(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Build URL with query parameters
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'userId': userId,
      };
      // if (loanType != null && loanType.isNotEmpty) {
      //   queryParams['loanType'] = loanType;
      // }

      // if (status != null && status.isNotEmpty) {
      //   queryParams['status'] = status;
      // }
      final uri = Uri.parse(
        '${ApiConfig.domain}${ApiConfig.getAllLoanApplication}',
      ).replace(queryParameters: queryParams);

      // Make HTTP GET request
      var res = await ApiService.get(uri.toString());
      if (res['success']) {
        return LoanApplicationResponse.fromJson(res);
      } else {
        return null;
      }
    } catch (e) {
      print('Exception in getingMyLoans: $e');
      return null;
    }
  }

  // Legacy method for backward compatibility
  static Future<dynamic> getLoanTypes() async {
    return await getLoanCategories();
  }
}

class CreateLoanparams {
  final String categoryId;
  final String userId;
  final String productId;
  final String amount;

  CreateLoanparams({
    required this.categoryId,
    required this.userId,
    required this.productId,
    required this.amount,
  });
  Map<String, dynamic> toJson() {
    return {
      'category': categoryId,
      'userId': userId,
      'product': productId,
      'amount': amount,
    };
  }
}
