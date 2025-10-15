import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Sky Blue - Main Theme)
  static const Color primary = Color(0xFF0EA5E9); // sky-500 (vibrant sky blue)
  static const Color primaryLight = Color(0xFF38BDF8); // sky-400 (light sky blue)
  static const Color primaryDark = Color(0xFF0284C7); // sky-600 (deep sky blue)

  // Secondary Colors (Lighter Sky Blue for accents)
  static const Color secondary = Color(0xFF7DD3FC); // sky-300 (soft light blue)
  static const Color secondaryLight = Color(0xFFBAE6FD); // sky-200 (very light blue)
  static const Color secondaryDark = Color(0xFF38BDF8); // sky-400 (medium blue)

  // Background Colors (Clean & Minimal)
  static const Color background = Color(0xFFFFFFFF); // pure white
  static const Color surface = Color(0xFFF9FAFB); // very light gray (gray-50)
  static const Color cardBackground = Color(0xFFFFFFFF); // white cards

  // Text Colors (High Contrast)
  static const Color textPrimary = Color(0xFF111827); // gray-900 (almost black)
  static const Color textSecondary = Color(0xFF6B7280); // gray-500 (medium gray)
  static const Color textLight = Color(0xFF9CA3AF); // gray-400 (light gray)

  // Status Colors
  static const Color success = Color(0xFF10B981); // green-500
  static const Color successLight = Color(0xFF34D399); // green-400
  static const Color warning = Color(0xFFF59E0B); // amber-500
  static const Color error = Color(0xFFEF4444); // red-500
  static const Color info = Color(0xFF0EA5E9); // sky-500 (matches primary)

  // Border Colors (Subtle & Clean)
  static const Color border = Color(0xFFE5E7EB); // gray-200 (light gray border)
  static const Color borderLight = Color(0xFFF3F4F6); // gray-100 (very light border)

  // Shadow Colors (Minimal & Subtle)
  static const Color shadow = Color(0x0D000000); // rgba(0, 0, 0, 0.05)
  static const Color shadowLight = Color(0x05000000); // rgba(0, 0, 0, 0.02)
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
  // Spacing (Generous spacing for breathable UI)
  static const double paddingXS = 6.0; // Increased from 4
  static const double paddingS = 10.0; // Increased from 8
  static const double paddingM = 16.0; // Increased from 12
  static const double paddingL = 20.0; // Increased from 16
  static const double paddingXL = 28.0; // Increased from 24
  static const double padding2XL = 36.0; // Increased from 32

  // Border Radius (Smoother, more modern)
  static const double radiusS = 6.0; // Increased from 4
  static const double radiusM = 10.0; // Increased from 6
  static const double radiusL = 14.0; // Increased from 8
  static const double radiusXL = 18.0; // Increased from 12

  // Icon Sizes (Better visual hierarchy)
  static const double iconSizeS = 18.0; // Increased from 16
  static const double iconSizeM = 22.0; // Increased from 20
  static const double iconSizeL = 26.0; // Increased from 24
  static const double iconSizeXL = 32.0; // Increased from 28

  // Component Heights (More comfortable touch targets)
  static const double buttonHeight = 52.0; // Increased from 48
  static const double inputHeight = 52.0; // Increased from 48
  
  // Card spacing
  static const double cardSpacing = 16.0; // Consistent card gaps
  static const double sectionSpacing = 24.0; // Space between sections
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
