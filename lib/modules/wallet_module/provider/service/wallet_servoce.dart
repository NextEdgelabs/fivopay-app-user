import 'dart:developer';
import 'package:janseva/config/api_config.dart';
import 'package:janseva/config/exceptions.dart';
import 'package:janseva/services/api_service.dart';

import '../../models/transaction_model.dart';
import '../../models/withdrawl_params.dart';

class WalletService {
  static Future<double> getWalletBalance(
    String authToken,
    String userId,
  ) async {
    try {
      var res = await ApiService.get(
        "${ApiConfig.domain}${ApiConfig.getWalletBalance}?userId=$userId",
        accessToken: authToken,
      );
      if (res['success'] == true) {
        log(res.toString());
        var balance = (res['data']['currentBalance'] as num).toDouble();
        return balance;
      } else {
        return 0.0;
      }
    } catch (e) {
      return 0.0;
    }
  }
  // static Future<dynamic> getWalletTransaction(){

  // }

  static Future<List<Transaction>> getTransactions(
    String authToken,
    String userId,
  ) async {
    try {
      var res = await ApiService.get(
        "${ApiConfig.domain}${ApiConfig.getWalletTransactions}?userId=$userId",
        accessToken: authToken,
      );
      if (res['success'] == true) {
        var transactions =
            (res['data']['transactions'] as List<dynamic>?)
                ?.map((json) => Transaction.fromJson(json))
                .toList() ??
            [];
        return transactions;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<String> createWithdrawal({
    required WithdrawalParams params,
  }) async {
    try {
      var res = await ApiService.post(
        "${ApiConfig.domain}${ApiConfig.createWithdrawal}",
        body: params.toJson(),
      );
      if (res['success'] == true) {
        return res['result']['transactionId'];
      } else {
        throw Failure(message: res['message'] ?? 'Withdrawal failed');
      }
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw Failure(message: 'Network error');
      }
    }
  }
}
