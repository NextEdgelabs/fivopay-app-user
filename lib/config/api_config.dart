import 'package:janseva/main.dart';
import 'package:janseva/modules/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

/// API Configuration for Sandbox KYC Integration
class ApiConfig {
  // KYC Base URL
  static const String baseUrl = 'https://api.sandbox.co.in';
  static const String domain = 'https://api.fivopay.nextlabsonline.com';

  static const String razorpayKeyId = 'rzp_test_jbbgzqb7j4eUF2';

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
  static const String panVerifyPath = '/api/v1/kyc/pan/verify';
  static const String aadhaarOtpPath = '/api/v1/kyc/aadhaar/okyc/otp';
  static const String aadhaarVerifyPath = '/api/v1/kyc/aadhaar/okyc/otp/verify';
  static const String authenticate = '/api/v1/authenticate';
  static const String submitLoanApplication = '/api/v1/loan/create-loan';
  static const String getAllLoanApplication = '/api/v1/loan/get-all-loans';

  //Wallet
  static const String createDeposit = '/api/v1/deposit/create-deposit';

  //loan
  static const String getLoancategories =
      '/api/v1/loan-category/get-all-loan-categories';
  static const String getLoanProducts =
      '/api/v1/loan-product/get-loan-products-by-category';
  static const String getAllLoanProducts =
      '/api/v1/loan-product/get-all-loan-products';
  static const String getLoanApplication = '/api/v1/loan/get-all-loans';

  // Headers

  static const String apiToken =
      'eyJ0eXAiOiJKV1MiLCJhbGciOiJSU0FTU0FfUFNTX1NIQV81MTIiLCJraWQiOiIwYzYwMGUzMS01MDAwLTRkYTItYjM3YS01ODdkYTA0ZTk4NTEifQ.eyJyZWZyZXNoX3Rva2VuIjoiZXlKMGVYQWlPaUpLVjFNaUxDSmhiR2NpT2lKU1UwRlRVMEZmVUZOVFgxTklRVjgxTVRJaUxDSnJhV1FpT2lJd1l6WXdNR1V6TVMwMU1EQXdMVFJrWVRJdFlqTTNZUzAxT0Rka1lUQTBaVGs0TlRFaWZRLmV5SnpkV0lpT2lKclpYbGZiR2wyWlY5ak1ERTRaRFkzWlRreFltTTBOell4WWpNMVpESXhNbVpqWlRZNVpURTNaQ0lzSW1Gd2FWOXJaWGtpT2lKclpYbGZiR2wyWlY5ak1ERTRaRFkzWlRreFltTTBOell4WWpNMVpESXhNbVpqWlRZNVpURTNaQ0lzSW5kdmNtdHpjR0ZqWlY5cFpDSTZJakl4Tm1VMVpXRXlMVGcxWXpZdE5HWXdZaTFpT1dWbUxUVTFOMk16Wm1ZM00yUmhaaUlzSW1GMVpDSTZJa0ZRU1NJc0ltbHVkR1Z1ZENJNklsSkZSbEpGVTBoZlZFOUxSVTRpTENKcGMzTWlPaUp3Y205a01TMWhjR2t1YzJGdVpHSnZlQzVqYnk1cGJpSXNJbVY0Y0NJNk1UYzVNakEwTWpVM01Dd2lhV0YwSWpveE56WXdOVEEyTlRjd2ZRLmFvaW8yLWtKcU5sV3REMjlhUElEMGM0cVcxNFJKZ2RIZjVBMUI4WHNvSHJyTjRlZUNyUjNFbmpyNTZFS0hBT0xyMWw4eHRodHZyb1l0TEItVURIc0k2VU5ZLTRERDdGLUlCVEozRlJjUXBtVDVyUG1SVmpDSkZBazVuY0pnUGpiaTNMYTRINC03SE5fTlN6YURUZWlOMG9sVW9mNmx6TVljNU1pMDhReFhDM3BkQnlabnhDalZNMGFwRDdvdFV5aDJHSm5nelZqYU1iOU0zOUFGMWVSTlZHNFhwUzF2ZHlLdVF0bnVtOUI2TElyWHBhTXZWa3ZRREZ5Mll2dkZSU041QWwxRVZ4WHJMTDllUUdmbnFFcWE1VDBFa1lSazNmRzVkMkpFTXdKUVh0NDdlWTNOajFTbTgxZ09yZ3hhSXlhSU9wWG9KUklTbU9YREZBc204T3N1ZyIsIndvcmtzcGFjZV9pZCI6IjIxNmU1ZWEyLTg1YzYtNGYwYi1iOWVmLTU1N2MzZmY3M2RhZiIsInN1YiI6ImtleV9saXZlX2MwMThkNjdlOTFiYzQ3NjFiMzVkMjEyZmNlNjllMTdkIiwiYXBpX2tleSI6ImtleV9saXZlX2MwMThkNjdlOTFiYzQ3NjFiMzVkMjEyZmNlNjllMTdkIiwiYXVkIjoiQVBJIiwiaW50ZW50IjoiQUNDRVNTX1RPS0VOIiwiaXNzIjoicHJvZDEtYXBpLnNhbmRib3guY28uaW4iLCJpYXQiOjE3NjA1MDY1NzAsImV4cCI6MTc2MDU5Mjk3MH0.vTE5O1lPOy3xkwZgBicgI6iYo2A-WkkRydSVshR3ZyF3neA7-TZHwoIv4UhY9v04SpHb79FllziSwhdygR_QzBG7zjzYtyXH8gfrQBQJ468AJg0Oy721uNb6woX-m8pPsuenZKgQy7-BeCyLl9vXvp7spE94TjzL491T6j-k1H9PwLef7ky1IKgCygjlI4JgzXgGd08-NjgkZgFAnnvguC634PPqDKAPk2cgLkzubUZcQOidXRjUx2HfGQ_KK-ZBS1NVssCM40rzECUc3-HMtwKn656tCf0WsI8_gOToJHPzzkidjCbbZYBEu2HLAI0wm-Dk2xAAaq2Ru9cUNyGyKg';
  static const String apiKey = 'key_live_c018d67e91bc4761b35d212fce69e17d';
  static const String workspaceId = '216e5ea2-85c6-4f0b-b9ef-557c3ff73daf';

  static Map<String, String> get headers => {
    'Authorization': bContext.read<AuthProvider>().accessToken ?? apiToken,
    'x-api-key': apiKey,
    'x-api-version': '2.0',
    'Content-Type': 'application/json',
  };
}
