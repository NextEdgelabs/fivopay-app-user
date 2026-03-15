import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:janseva/main.dart';
import 'package:janseva/modules/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

/// Base API service class that handles all HTTP requests
class ApiService {
  static const Duration _defaultTimeout = Duration(seconds: 30);

  /// Make HTTP request with proper error handling
  static Future<Map<String, dynamic>> request({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic> body = const {},
    String? accessToken,
    Duration timeout = _defaultTimeout,
  }) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = timeout;

      late HttpClientRequest request;

      if (bContext.read<AuthProvider>().currentUser != null &&
          accessToken == null) {
        accessToken = bContext.read<AuthProvider>().appAccessToken;
      }

      switch (method.toUpperCase()) {
        case 'POST':
          request = await client.postUrl(Uri.parse(url));
          break;
        case 'PUT':
          request = await client.putUrl(Uri.parse(url));
          break;
        case 'DELETE':
          request = await client.deleteUrl(Uri.parse(url));
          break;
        case 'GET':
        default:
          request = await client.getUrl(Uri.parse(url));
          break;
      }
      if (headers != null) {
        headers.forEach((key, value) {
          request.headers.set(key, value);
        });
      }
      // Set headers
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.headers.set("appId", appId); // Default appId header

      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers.set(
          HttpHeaders.authorizationHeader,
          "Bearer $accessToken",
        );
      }

      // request.headers.set("AppId", "69aaae77dea6cdb5da391b6d");

      // Add body for non-GET requests
      if (method.toUpperCase() != 'GET' && body.isNotEmpty) {
        request.write(json.encode(body));
      }

      final response = await request.close();
      final responseData = await response.transform(utf8.decoder).join();

      client.close();

      return json.decode(responseData);
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  /// Upload files with form data
  static Future<Map<String, dynamic>> uploadFiles({
    required String method,
    required String url,
    required Map<String, String> fields,
    required Map<String, String> files,
    String? accessToken,
  }) async {
    try {
      var request = http.MultipartRequest(method.toUpperCase(), Uri.parse(url));

      // Set headers
      request.headers['appId'] = appId; // Default appId header

      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }

      // Add fields
      request.fields.addAll(fields);

      // Add files
      for (var entry in files.entries) {
        request.files.add(
          http.MultipartFile.fromBytes(
            entry.key,
            File(entry.value).readAsBytesSync(),
            filename: entry.value.split("/").last,
          ),
        );
      }

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      return json.decode(responseString);
    } catch (e) {
      throw ApiException('File upload error: ${e.toString()}');
    }
  }

  /// GET request helper
  static Future<Map<String, dynamic>> get(
    String url, {
    String? accessToken,
    Map<String, dynamic>? headers,
  }) async {
    return request(
      method: 'GET',
      url: url,
      accessToken: accessToken,
      headers: headers,
    );
  }

  /// POST request helper
  static Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic> body = const {},
    String? accessToken,
    Map<String, dynamic>? headers,
  }) async {
    return request(
      method: 'POST',
      url: url,
      body: body,
      accessToken: accessToken,
      headers: headers,
    );
  }

  /// PUT request helper
  static Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic> body = const {},
    String? accessToken,
  }) async {
    return request(
      method: 'PUT',
      url: url,
      body: body,
      accessToken: accessToken,
    );
  }

  /// DELETE request helper
  static Future<Map<String, dynamic>> delete(
    String url, {
    String? accessToken,
  }) async {
    return request(method: 'DELETE', url: url, accessToken: accessToken);
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
