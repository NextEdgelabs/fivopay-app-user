import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String baseUrl =
      'https://api.janseva.com'; // Replace with actual API URL
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // Send OTP to phone number
  static Future<bool> sendOtp(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phoneNumber': phoneNumber}),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phoneNumber': phoneNumber, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final userData = data['user'];

        // Save token and user data
        await _saveToken(token);
        await _saveUserData(userData);

        return {
          'success': true,
          'user': User.fromJson(userData),
          'token': token,
        };
      }
      return {'success': false, 'message': 'Invalid OTP'};
    } catch (e) {
      print('Error verifying OTP: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  // Register new user
  static Future<Map<String, dynamic>> registerUser(
    Map<String, dynamic> userData,
  ) async {
    try {
      // For now, use mock registration since we don't have a real API
      // In production, this would make an API call
      await Future.delayed(const Duration(seconds: 2));

      // Create a mock user with the provided data
      final mockUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        phoneNumber: userData['phoneNumber'] ?? '',
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        dateOfBirth: userData['dateOfBirth'] ?? '',
        gender: userData['gender'] ?? '',
        address: userData['address'] ?? '',
        city: userData['city'] ?? '',
        state: userData['state'] ?? '',
        pincode: userData['pincode'] ?? '',
        nomineeName: userData['nomineeName'] ?? '',
        nomineeRelation: userData['nomineeRelation'] ?? '',
        nomineePhone: userData['nomineePhone'] ?? '',
        isMember: userData['isMember'] ?? false,
        accountNumber:
            'JS${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        memberSince: DateTime.now().year.toString(),
        kycStatus: 'pending',
        kycType: 'pending',
        referralCode:
            'JANSEVA${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      );

      // Save user data locally
      await _saveUserData(mockUser.toJson());

      // Save a token to indicate user is logged in
      await _saveToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');

      return {'success': true, 'user': mockUser};
    } catch (e) {
      print('Error registering user: $e');
      return {'success': false, 'message': 'Registration failed'};
    }
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(userKey);
      if (userData != null) {
        return User.fromJson(json.decode(userData));
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final token = await _getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      await prefs.remove(userKey);
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> userData,
  ) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveUserData(data['user']);
        return {'success': true, 'user': User.fromJson(data['user'])};
      }
      return {'success': false, 'message': 'Update failed'};
    } catch (e) {
      print('Error updating profile: $e');
      return {'success': false, 'message': 'Network error'};
    }
  }

  // Update user data after KYC
  static Future<bool> updateUserAfterKyc(User user) async {
    try {
      await _saveUserData(user.toJson());
      return true;
    } catch (e) {
      print('Error updating user after KYC: $e');
      return false;
    }
  }

  // Helper methods
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, json.encode(userData));
  }

  // Mock methods for development (remove in production)
  static Future<bool> sendOtpMock(String phoneNumber) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  static Future<Map<String, dynamic>> verifyOtpMock(
    String phoneNumber,
    String otp,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock OTP verification (use '123456' for testing)
    if (otp == '123456') {
      // Check if user exists (for demo, we'll create a new user each time)
      // In production, this would check against a database
      final existingUser = await getCurrentUser();

      User mockUser;
      if (existingUser != null && existingUser.phoneNumber == phoneNumber) {
        // User exists, return existing user
        mockUser = existingUser;
      } else {
        // Create new user
        mockUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          phoneNumber: phoneNumber,
          name: 'New User',
          isMember: false,
          accountNumber:
              'JS${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
          memberSince: DateTime.now().year.toString(),
          kycStatus: 'pending',
          kycType: 'pending',
          referralCode:
              'JANSEVA${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        );
      }

      // Save user data and token locally
      await _saveUserData(mockUser.toJson());
      await _saveToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');

      return {
        'success': true,
        'user': mockUser,
        'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        'isNewUser':
            existingUser == null || existingUser.phoneNumber != phoneNumber,
      };
    }

    return {'success': false, 'message': 'Invalid OTP'};
  }
}
