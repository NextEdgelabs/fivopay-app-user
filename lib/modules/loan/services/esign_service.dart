// import 'package:janseva/config/api_config.dart';
// import 'package:janseva/config/exceptions.dart';
// import 'package:janseva/modules/loan/models/eStamp/esign_params.dart';
// import 'package:janseva/modules/loan/models/eStamp/esign_response.dart';
// import 'package:janseva/services/api_service.dart';

// class EsignService {
//   // static var headers = {
//   //   "api-key": "JDJP5YV-K4P423W-PC46R5A-S0R8DDC",
//   //   "app-id": "68e7dd5ce8e915e7ced9e36b",
//   // };
//   // static Future<EsignResponse> signDocument(
//   //   EsignRequest request,
//   //   String loanId,
//   // ) async {
//   //   try {
//   //     var url = '${ApiConfig.eSignBaseUrl}${ApiConfig.eSignDocumnent}';
//   //     var res = await ApiService.post(
//   //       url,
//   //       body: request.toJson(loanId),
//   //       headers: headers,
//   //     );
//   //     if (res['success'] == true) {
//   //       return EsignResponse.fromJson(res);
//   //     } else {
//   //       throw Failure(message: "Unable to sign document");
//   //     }
//   //   } on Failure {
//   //     rethrow;
//   //   } catch (e) {
//   //     throw Failure(message: "Unable to sign document");
//   //   }
//   // }

// }
