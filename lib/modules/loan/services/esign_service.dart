import 'package:janseva/config/api_config.dart';
import 'package:janseva/config/exceptions.dart';
import 'package:janseva/modules/loan/models/eStamp/esign_params.dart';
import 'package:janseva/modules/loan/models/eStamp/esign_response.dart';
import 'package:janseva/services/api_service.dart';

class EsignService {
  static var headers = {
    "api-key": "TSG1V81-5K6MXYK-JRH2FE3-A4JNV5R",
    "app-id": "68e7dd5ce8e915e7ced9e36b",
  };
  static Future<EsignResponse> signDocument(EsignRequest request) async {
    try {
      var url = '${ApiConfig.eSignBaseUrl}${ApiConfig.eSignDocumnent}';
      var res = await ApiService.post(
        url,
        body: request.toJson(),
        headers: headers,
      );
      if (res['success'] == true) {
        return EsignResponse.fromJson(res);
      } else {
        throw Failure(message: "Unable to sign document");
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: "Unable to sign document");
    }
  }
}
