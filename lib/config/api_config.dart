import 'package:janseva/main.dart';
import 'package:janseva/modules/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

/// API Configuration for Sandbox KYC Integration
class ApiConfig {
  // KYC Base URL
  static const String baseUrl = 'https://api.sandbox.co.in';
  static const String domain = 'http://192.168.1.89:5000/api/v1';
  // API Endpoints

  //Login
  static const String loginPath = '/user/send-otp';
  static const String verifyOtpPath = '/user/verify-otp';
  static const String resendOtpPath = '/user/resend-otp';
  //User-details
  static const String createProfile = '/user/create-profile';
  static const String saveAdhar = '/user/save-aadhar';
  static const String savePan = '/user/save-pan-card-details';
  static const String getMemberId = '/user/get-member-id';
  //KYC
  static const String panVerifyPath = '/kyc/pan/verify';
  static const String aadhaarOtpPath = '/kyc/aadhaar/okyc/otp';
  static const String aadhaarVerifyPath = '/kyc/aadhaar/okyc/otp/verify';
  static const String authenticate = '/authenticate';
  static const String submitLoanApplication = '/loan/create-loan';

  //loan
  static const String getLoancategories =
      '/loan-category/get-all-loan-categories';
  static const String getLoanProducts =
      '/loan-product/get-loan-products-by-category';

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
