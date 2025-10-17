import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janseva/services/api_service.dart';
import '../../../config/api_config.dart';
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
      final response = await http.get(uri, headers: ApiConfig.headers);
      if (res['success']) {
        return LoanCategoriesResponse.fromJson(res);
      } else {
        print('Error fetching loan categories: ${response.statusCode}');
        print('Error response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception in getLoanCategories: $e');
      return null;
    }
  }

  /// Get loan categories by specific type
  static Future<List<LoanCategory>?> getLoanCategoriesByType(
    String loanType,
  ) async {
    try {
      final response = await getLoanCategories(loanType: loanType);
      return response?.result.loanCategories;
    } catch (e) {
      print('Exception in getLoanCategoriesByType: $e');
      return null;
    }
  }

  /// Get all available loan types
  static Future<List<String>?> getAvailableLoanTypes() async {
    try {
      final response = await getLoanCategories();
      return response?.result.availableLoanTypes;
    } catch (e) {
      print('Exception in getAvailableLoanTypes: $e');
      return null;
    }
  }

  /// Get loan category by ID
  static Future<LoanCategory?> getLoanCategoryById(String categoryId) async {
    try {
      final response = await getLoanCategories();
      if (response?.result.loanCategories != null) {
        return response!.result.loanCategories.firstWhere(
          (category) => category.id == categoryId,
        );
      }
      return null;
    } catch (e) {
      print('Exception in getLoanCategoryById: $e');
      return null;
    }
  }

  // Legacy method for backward compatibility
  static Future<dynamic> getLoanTypes() async {
    return await getLoanCategories();
  }
}
