class KycApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic> errorDetails;

  KycApiException({
    required this.message,
    required this.statusCode,
    required this.errorDetails,
  });

  @override
  String toString() => message;
}

class Failure implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errorDetails;

  Failure({required this.message, this.statusCode, this.errorDetails});

  @override
  String toString() => message;
}

class RazorpayException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errorDetails;

  RazorpayException({
    required this.message,
    this.statusCode,
    this.errorDetails,
  });

  @override
  String toString() => message;
}
