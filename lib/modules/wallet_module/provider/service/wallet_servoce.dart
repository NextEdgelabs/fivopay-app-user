import 'dart:developer';
import 'package:janseva/config/api_config.dart';
import 'package:janseva/services/api_service.dart';

class WalletService {
  static Future<double> getWalletBalance(String authToken , String userId) async {
    try {
      var res = await ApiService.get(
        "${ApiConfig.domain}${ApiConfig.getWalletBalance}?userId=$userId",
        accessToken: authToken,
      );
      if(res['success'] == true) {
        log(res.toString());
        var balance = (res['data']['currentBalance']as num).toDouble();
        return balance;
      }else {
        return 0.0;
      }
   
    } catch (e) {
      return 0.0;
    }
  }
  // static Future<dynamic> getWalletTransaction(){

  // }
}
