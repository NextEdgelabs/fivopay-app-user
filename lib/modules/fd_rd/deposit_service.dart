import 'dart:developer';
import 'package:janseva/config/api_config.dart';
import 'package:janseva/config/exceptions.dart';
import 'package:janseva/modules/fd_rd/model/deposit_category_model.dart';
import 'package:janseva/modules/fd_rd/model/deposit_product_model.dart';
import 'package:janseva/services/api_service.dart';

class DepositService {
  static Future<List<DepositCategory>> getDepositCategories({
    String? type,
  }) async {
    try {
      String url = '${ApiConfig.domain}${ApiConfig.getDepostCategoryByType}';
      if (type != null && type.isNotEmpty) {
        url += '/$type';
      }

      var res = await ApiService.get(url);
      if (res['success'] == true) {
        log(res.toString());
        final List<dynamic> data = res['result']['depositCategories'];
        return data.map((e) => DepositCategory.fromJson(e)).toList();
      } else {
        throw Failure(
          message: res['message'] ?? 'Failed to fetch deposit categories.',
        );
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(message: 'Failed to fetch deposit categories.');
    }
  }

  static Future<List<DepositProduct>> getDepositProducts({
    required String type,
  }) async {
    try {
      String url = '${ApiConfig.domain}${ApiConfig.getFdProducts}/$type';
      var res = await ApiService.get(url);
      if (res['success'] == true) {
        log(res.toString());
        final List<dynamic> products = res['result']['depositProducts'];
        return products.map((e) => DepositProduct.fromJson(e)).toList();
      } else {
        throw Failure(
          message: res['message'] ?? 'Failed to fetch deposit products.',
        );
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(message: 'Failed to fetch deposit products.');
    }
  }
}
