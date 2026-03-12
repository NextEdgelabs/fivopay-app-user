import 'dart:developer';
import 'package:janseva/config/api_config.dart';
import 'package:janseva/config/exceptions.dart';
import 'package:janseva/modules/fd_rd/model/deposit_category_model.dart';
import 'package:janseva/modules/fd_rd/model/deposit_enum.dart';
import 'package:janseva/modules/fd_rd/model/deposit_product_model.dart';
import 'package:janseva/modules/fd_rd/model/pagination_model.dart';
import 'package:janseva/modules/fd_rd/model/pickup_address_model.dart';
import 'package:janseva/modules/fd_rd/model/term_deposit_model.dart';
import 'package:janseva/modules/wallet_module/models/deposit_response.dart';
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

  static Future<DepositResponse> createTermDeposit({
    required String productId,
    required double amount,
    required String description,
    required PaymentMethod paymentMethod,
    PickupAddress? pickupAddress,
    DateTime? preferredDate,

    // required int tenure,
  }) async {
    try {
      String url = '${ApiConfig.domain}${ApiConfig.createTermDeposit}';
      var res = await ApiService.post(
        url,
        body: {
          'productId': productId,
          'amount': amount,
          'description': description,
          'paymentMethod': paymentMethod.value,
          'pickupAddress': pickupAddress?.toJson(),
          'preferredDate': preferredDate?.toIso8601String(),
        },
      );
      if (res['success'] == true) {
        log(res.toString());
        return DepositResponse.fromJson(res['data']);
      } else {
        throw Failure(
          message: res['message'] ?? 'Failed to create term deposit.',
        );
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(message: 'Failed to create term deposit.');
    }
  }

  static Future<PaginatedResponse<DepositAccountModel>> getUserTermDeposits(
    String userId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      String url =
          '${ApiConfig.domain}${ApiConfig.getAllDeposits}?customerId=$userId&page=$page&limit=$limit';
      var res = await ApiService.get(url);
      if (res['success'] == true) {
        log(res.toString());
        final List<dynamic> data = res['result']['depositAccounts'];
        final pagination = res['result']['pagination'];

        final deposits = data
            .map((e) => DepositAccountModel.fromJson(e))
            .toList();
        final paginationModel = PaginationModel.fromJson(pagination ?? {});

        return PaginatedResponse(data: deposits, pagination: paginationModel);
      } else {
        throw Failure(
          message: res['message'] ?? 'Failed to fetch term deposits.',
        );
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(message: 'Failed to fetch term deposits.');
    }
  }
}
