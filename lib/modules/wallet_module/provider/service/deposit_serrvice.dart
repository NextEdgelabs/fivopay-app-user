import '../../../../config/api_config.dart';
import '../../../../services/api_service.dart';

class DepositService {
  static Future<void> fetchloanProducts() async {
    try {
      var res = await ApiService.get(
        "${ApiConfig.domain}${ApiConfig.getFdProducts}",
      );
    } catch (e) {}
  }
}
