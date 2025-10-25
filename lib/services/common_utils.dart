import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:janseva/config/exceptions.dart';

Future<String> pdfToBase64(String url) async {
  try {
    final uri = Uri.parse(
      "https://getsamplefiles.com/download/pdf/sample-1.pdf",
    );

    // Ensure it’s a valid URL
    if (!uri.isAbsolute) {
      throw Failure(message: "Invalid PDF URL");
    }

    final response = await http.get(
      uri,
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36',
      },
    );

    if (response.statusCode != 200) {
      throw Failure(
        message: "Failed to download document. Status: ${response.statusCode}",
      );
    }

    // Convert response body bytes to Base64
    final base64String = base64Encode(response.bodyBytes);

    // Optional: prefix for displaying in <img src> or PDF viewers
    // return 'data:application/pdf;base64,$base64String';
    return base64String;
  } catch (e) {
    if (e is Failure) rethrow;
    throw Failure(message: "Unable to fetch Document: ${e.toString()}");
  }
}
