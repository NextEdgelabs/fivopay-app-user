import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFB7185); // rose-400
  static const Color primaryLight = Color(0xFFFDA4AF); // rose-300
  static const Color primaryDark = Color(0xFFF43F5E); // rose-500

  // Secondary Colors (soft indigo)
  static const Color secondary = Color(0xFF818CF8); // indigo-400
  static const Color secondaryLight = Color(0xFFA5B4FC); // indigo-300

  // Background Colors
  static const Color background = Color(0xFFFFF7F9); // very light rose
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Border Colors
  static const Color border = Color(0xFFF2E8EC); // soft rose border
  static const Color borderLight = Color(0xFFFFEEF2); // lighter rose

  // Shadow Colors (soft subtle shadows)
  static const Color shadow = Color(0x14000000);
  static const Color shadowLight = Color(0x0A000000);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
    fontFamily: 'Poppins',
  );

  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'Poppins',
  );
}

class AppSizes {
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 12.0;
  static const double paddingL = 16.0;
  static const double paddingXL = 24.0;

  static const double radiusS = 6.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;

  static const double iconSizeS = 14.0;
  static const double iconSizeM = 20.0;
  static const double iconSizeL = 24.0;

  static const double buttonHeight = 48.0;
  static const double inputHeight = 48.0;
}

class AppStrings {
  // App Info
  static const String appName = 'JanSeva';
  static const String appTagline = 'Cooperative Credit Society';

  // Auth
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle = 'Sign in to your account';
  static const String phoneNumberHint = 'Enter phone number';
  static const String otpTitle = 'Verify OTP';
  static const String otpSubtitle = 'Enter the 6-digit code sent to your phone';
  static const String resendOtp = 'Resend OTP';
  static const String verifyOtp = 'Verify OTP';

  // Registration
  static const String createAccount = 'Create Account';
  static const String becomeMember = 'Become a Member';
  static const String personalInfo = 'Personal Information';
  static const String addressInfo = 'Address Information';
  static const String nomineeInfo = 'Nominee Information';

  // Dashboard
  static const String dashboard = 'Dashboard';
  static const String balance = 'Balance';
  static const String accountNumber = 'Account Number';
  static const String memberSince = 'Member Since';

  // Referral
  static const String inviteFriends = 'Invite Friends';
  static const String referralCode = 'Referral Code';
  static const String shareApp = 'Share App';
  static const String referralRewards = 'Referral Rewards';

  // Common
  static const String next = 'Next';
  static const String back = 'Back';
  static const String submit = 'Submit';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String confirm = 'Confirm';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String retry = 'Retry';
}
