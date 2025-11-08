import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:janseva/config/api_config.dart';
import 'package:janseva/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SfService {
  static String adharKey = "aadhaarDetails";
  static String panKey = "panDetails";
  static String bankKey = "bankDetails";
  static String profileKey = "profileDetails";
  static String userKey = "userDetails";
  static String apikey = "apiKey";
  static String accesstoken = "accessToken";
  static String refreshToken = "refreshToken";
  static String apiversion = "apiVersion";
  static String kycAccessToken = "kycAccessToken";

  static Future<bool> saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  //save json
  static Future<bool> saveJson(String key, Map<String, dynamic> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, jsonEncode(value));
  }

  static Future<Map<String, dynamic>?> getJson(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) != null
        ? jsonDecode(prefs.getString(key)!)
        : null;
  }
}
class S3Service{
   static Future<List<String>> getMultipleSignedUrls(List<File> files) async {
    List<String> uploadedPresignedUrls = [];

    try {
      final url = '${ApiConfig.domain}${ApiConfig.uploadFile}';
      List<Map<String, String>> fileData = files.map((file) {
        String contentType;
        if (file.path.endsWith('.png') ||
            file.path.endsWith('.jpg') ||
            file.path.endsWith('.jpeg')) {
          contentType = 'image/jpeg';
        } else if (file.path.endsWith('.pdf')) {
          contentType = 'application/pdf';
        } else {
          contentType = 'video/mp4';
        }

        return {
          "fileName": file.path.split('/').last,
          "contentType": contentType,
        };
      }).toList();

      final response = await ApiService.post( url, body :{"files": fileData});
     

      if (response['success']) {
        List<dynamic> resultList = response['result'];

        for (int i = 0; i < files.length; i++) {
          String signedUrl = resultList[i]['signedUrl'];

          String? uploadedUrl =
              await _uploadFileToPresignedUrl(files[i], signedUrl);
          if (uploadedUrl != null) {
            uploadedPresignedUrls.add(uploadedUrl);
          }
        }
      }

      // notifyListeners();
      return uploadedPresignedUrls;
    } catch (error) {
      print("Error getting signed URLs: $error");
      return [];
    }
  }

 static _uploadFileToPresignedUrl(File file, String presignedUrl) async {
    try {
      List<int> fileBytes = await file.readAsBytes();

      // Determine the content type based on file extension
      String contentType;
      if (file.path.endsWith('.png') ||
          file.path.endsWith('.jpg') ||
          file.path.endsWith('.jpeg')) {
        contentType = 'image';
      } else if (file.path.endsWith('.pdf')) {
        contentType = 'pdf';
      } else {
        contentType = 'video';
      }

      final response = await http.put(
        Uri.parse(presignedUrl),
        body: fileBytes,
        headers: {
          'Content-Type': contentType,
          'Content-Length': fileBytes.length.toString(),
        },
      );

      if (response.statusCode == 200) {
        return presignedUrl.split('?').first;
      } else {
        print("Failed to upload file. Status Code: ${response.statusCode}");
        print("Response: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Error uploading file: $error");
      return null;
    }
  }

}