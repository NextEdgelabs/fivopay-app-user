import 'dart:async';
import 'package:biometric_authorization/biometric_authorization.dart';
import 'package:biometric_authorization/biometric_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _biometricSetupKey = 'biometric_setup_done';

  final BiometricAuthorization _biometricAuth = BiometricAuthorization();

  /// Check if biometric is available on device
  Future<bool> isBiometricAvailable() async {
    try {
      return await _biometricAuth.isBiometricAvailable();
    } catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Check if biometric is enrolled (user has set up fingerprint/face)
  Future<bool> isBiometricEnrolled() async {
    try {
      return await _biometricAuth.isBiometricEnrolled();
    } catch (e) {
      print('Error checking biometric enrollment: $e');
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometricTypes() async {
    try {
      return await _biometricAuth.getAvailableBiometricTypes();
    } catch (e) {
      print('Error getting biometric types: $e');
      return [];
    }
  }

  /// Authenticate user with biometrics
  Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
    String title = 'Biometric Authentication',
    String confirmText = 'Authenticate',
    String? cancelText = 'Cancel',
  }) async {
    try {
      // Check if biometric is available and enrolled
      final isAvailable = await isBiometricAvailable();
      final isEnrolled = await isBiometricEnrolled();

      if (!isAvailable || !isEnrolled) {
        print('Biometric not available or not enrolled');
        return false;
      }

      // Get available biometric types
      final biometricTypes = await getAvailableBiometricTypes();
      if (biometricTypes.isEmpty ||
          biometricTypes.first == BiometricType.none) {
        print('No biometric types available');
        return false;
      }

      // Authenticate with the first available biometric type
      final result = await _biometricAuth.authenticate(
        biometricType: biometricTypes.first,
        reason: reason,
        title: title,
        confirmText: confirmText,
        cancelText: cancelText,
        useCustomUI: false,
        useDialogUI: false,
      );

      return result;
    } catch (e) {
      print('Biometric auth error: $e');
      return false;
    }
  }

  /// Check if user has enabled biometric authentication in app settings
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  /// Enable biometric authentication in app settings
  Future<void> enableBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, true);
    await prefs.setBool(_biometricSetupKey, true);
  }

  /// Disable biometric authentication in app settings
  Future<void> disableBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, false);
  }

  /// Check if user has completed biometric setup flow
  Future<bool> hasCompletedSetup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricSetupKey) ?? false;
  }

  /// Mark biometric setup as skipped (user chose not to enable)
  Future<void> skipBiometricSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricSetupKey, true);
    await prefs.setBool(_biometricEnabledKey, false);
  }

  /// Reset biometric setup (for testing or logout)
  Future<void> resetBiometricSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_biometricEnabledKey);
    await prefs.remove(_biometricSetupKey);
  }
}
