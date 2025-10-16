import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SfService {
  static String adharKey = "aadhaarDetails";
  static String panKey = "panDetails";
  static String bankKey = "bankDetails";
  static String profileKey = "profileDetails";
  static String userKey = "userDetails";



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
    return prefs.getString(key) != null ? jsonDecode(prefs.getString(key)!) : null;
  }
}