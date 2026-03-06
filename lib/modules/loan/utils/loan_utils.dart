import 'package:flutter/material.dart';

class LoanUtils {
  static Color getLoanTypeColor(String loanType) {
    // Generate a consistent "random" color based on the loan type string
    final hash = loanType.toLowerCase().hashCode;
    final random = hash.abs();
    
    // Generate RGB values with good saturation and brightness
    final hue = (random % 360).toDouble();
    final saturation = 0.6 + ((random >> 8) % 30) / 100; // 0.6-0.9
    final lightness = 0.45 + ((random >> 16) % 20) / 100; // 0.45-0.65
    
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  static IconData getLoanTypeIcon(String loanType) {
    switch (loanType.toLowerCase()) {
      case 'personal':
        return Icons.person;
      case 'home':
        return Icons.home;
      case 'car':
        return Icons.directions_car;
      case 'education':
        return Icons.school;
      case 'business':
        return Icons.business;
      case 'gold':
        return Icons.account_balance_wallet;
      default:
        return Icons.account_balance;
    }
  }
}
