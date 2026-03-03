/// API Configuration for Sandbox KYC Integration
class ApiConfig {
  // KYC Base URL
  // static const String baseUrl = 'https://api.sandbox.co.in';
  // static const String domain = 'https://api.fivopay.nextlabsonline.com';

  // static const String domain = 'http://192.168.1.75:4000';
  static const String domain = 'http://34.100.148.226:4000';

  static const String razorpayKeyId = 'rzp_test_SBwik9QIBrqeIE';

  //Estamp+Esign
  static const String eStampBaseUrl = 'https://test.zoop.one/contract/estamp';
  static const String eSignBaseUrl = 'https://test.zoop.plus/contract/esign';

  //estam+sign Endpoints

  static const String eSignDocumnent = '/v5/init';
  static const String allocateEstamps = '/v2/estamps/allocate';
  static const String consumeEstamp = '/v2/estamps/consume';
  static const String getEstamps = '/v2/init';
  static const String getorderDEtails = '/v2/fetch/request';
  // API Endpoints

  static const String signDocument = '/api/v1/esign/signDocument';

  //Login
  static const String loginPath = '/api/v1/user/send-otp';
  static const String verifyOtpPath = '/api/v1/user/verify-otp';
  static const String resendOtpPath = '/api/v1/user/resend-otp';
  //User-details
  static const String createProfile = '/api/v1/user/create-profile';
  static const String saveAdhar = '/api/v1/user/save-aadhar';
  static const String savePan = '/api/v1/user/save-pan-card-details';
  static const String getMemberId = '/api/v1/user/get-member-id';
  //KYC
  static const String panVerifyPath = '/api/v1/app-config/pan-verification';
  static const String aadhaarOtpPath =
      '/api/v1/app-config/send-aadhar-verification-otp';
  static const String aadhaarVerifyPath =
      '/api/v1/app-config/verify-aadhar-verification-otp';
  static const String submitLoanApplication = '/api/v1/loan/create-loan';
  static const String getAllLoanApplication = '/api/v1/loan/get-all-loans';

  //Wallet
  static const String createDeposit = '/api/v1/deposit/create-deposit';
  static const String getWalletBalance = '/api/v1/deposit/get-user-balance';

  //customers
  static const String getAllCustomers = '/api/v1/customer/get-all-customers';

  //loan
  static const String getLoancategories =
      '/api/v1/loan-category/get-all-loan-categories';
  static const String getLoanProducts =
      '/api/v1/loan-product/get-loan-products-by-category';
  static const String getAllLoanProducts =
      '/api/v1/loan-product/get-all-loan-products';
  static const String getLoanApplication = '/api/v1/loan/get-all-loans';

  //Shares
  static const String createShareTransaction =
      '/api/v1/share-transaction/record-transaction';

  //upload
  static const String uploadFile =
      '/api/v1/file-upload/get-multiple-signed-urls';
  // Headers

  // static const String apiToken ='eyJ0eXAiOiJKV1MiLCJhbGciOiJSU0FTU0FfUFNTX1NIQV81MTIiLCJraWQiOiIwYzYwMGUzMS01MDAwLTRkYTItYjM3YS01ODdkYTA0ZTk4NTEifQ.eyJyZWZyZXNoX3Rva2VuIjoiZXlKMGVYQWlPaUpLVjFNaUxDSmhiR2NpT2lKU1UwRlRVMEZmVUZOVFgxTklRVjgxTVRJaUxDSnJhV1FpT2lJd1l6WXdNR1V6TVMwMU1EQXdMVFJrWVRJdFlqTTNZUzAxT0Rka1lUQTBaVGs0TlRFaWZRLmV5SnpkV0lpT2lKclpYbGZiR2wyWlY4NE1EVmtZVE0yTlRWaU4ySTBZVGMyT1dZME9EVmxZMlZpTURFd00yVTROaUlzSW1Gd2FWOXJaWGtpT2lKclpYbGZiR2wyWlY4NE1EVmtZVE0yTlRWaU4ySTBZVGMyT1dZME9EVmxZMlZpTURFd00yVTROaUlzSW5kdmNtdHpjR0ZqWlY5cFpDSTZJbVJsWkRBMU0yRTJMVGhtTmpFdE5HTmhNeTA1WkRReExUWXpZbU5pTWpNd09ERTVOU0lzSW1GMVpDSTZJa0ZRU1NJc0ltbHVkR1Z1ZENJNklsSkZSbEpGVTBoZlZFOUxSVTRpTENKcGMzTWlPaUp3Y205a01TMWhjR2t1YzJGdVpHSnZlQzVqYnk1cGJpSXNJbVY0Y0NJNk1UYzVNemN3TWpjNU1Td2lhV0YwSWpveE56WXlNVFkyTnpreGZRLk1HRVN0dzhyU1A4N04xRmxYRUg3aDlaVGtUR05odklQV2hVMUM4cVVuYllkelFTR2VnTEM1MmVMbkVLNjUteVJnakdVUDZzVmYwWTNtYURmQTJDTVQ5STZUNk5peUlHZmxPZ0ljenl6M1lzTHFRX3hXWU1wRVFtOUt0MnlsaFMwd3hiQkphRXVBd0E2dDNHbUVMU0pLaS0xZG1XTktnSmdhM1BybmRBQmRDeEJqdHVfanA4XzRxY2l6cGF4WVVybXo0U1A1RDM3UnRsX05panA3NXJTdnc4NFN1OHp2bE9hU1FQZmcybnRuREFXVmMySDByZWp2dS1PX0xKVklOd01wOHJTajVzNmdDMjhmR3VrSDFxYkJqS0VoN1pVZUtQSUJGSTBzX0RrMFplZkZ5OGV5S3FRMC11S092U3lxQ01aV1plWVpaVzdNcHEtNEFzcWVPWjBYQSIsIndvcmtzcGFjZV9pZCI6ImRlZDA1M2E2LThmNjEtNGNhMy05ZDQxLTYzYmNiMjMwODE5NSIsInN1YiI6ImtleV9saXZlXzgwNWRhMzY1NWI3YjRhNzY5ZjQ4NWVjZWIwMTAzZTg2IiwiYXBpX2tleSI6ImtleV9saXZlXzgwNWRhMzY1NWI3YjRhNzY5ZjQ4NWVjZWIwMTAzZTg2IiwiYXVkIjoiQVBJIiwiaW50ZW50IjoiQUNDRVNTX1RPS0VOIiwiaXNzIjoicHJvZDEtYXBpLnNhbmRib3guY28uaW4iLCJpYXQiOjE3NjIxNjY3OTEsImV4cCI6MTc2MjI1MzE5MX0.BvkD0Wnz4xOlKmNkUtqM9SvvFiO6ZQZXGeFE-ilNlyeq7lfqCZPc1p1G20TNWAyVCTYvsw7UUsc4y1ImbmMRbPNrfwBbBtl--0c5PAO-Ui31zxsoNN8pHYHK98SNGdHWH-2105z_3CREwAFOxYxFdyCPuunQB8DIvQ79_K0XtfCCCw99h6ZKEZaoKqXvetkzRBgHvfKLaG3kIBr2yaGl5wXaeU41o014Jh2ALqtPCthV-QwB6GP9xRg9crxBCNAfBbyXZq-l59itnb2iOrr2ztk7mQsn7D8W0Rpl9SftNUxEOC1XAxi-F4WlE-1_xhUrR5pB6_xCesyuNqkpZQ0JHw';static const String apiKey = 'key_live_805da3655b7b4a769f485eceb0103e86';
  // static const String workspaceId = '216e5ea2-85c6-4f0b-b9ef-557c3ff73daf';

  // static Map<String, String> get headers => {
  //   'Authorization': bContext.read<AuthProvider>().kycaccessToken ?? apiToken,
  //   'x-api-key': apiKey,
  //   'x-api-version': '2.0',
  //   'Content-Type': 'application/json',
  // };
}
