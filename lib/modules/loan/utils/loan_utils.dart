import 'package:flutter/material.dart';

class LoanUtils {
  static Color getLoanTypeColor(String loanType) {
    switch (loanType.toLowerCase()) {
      case 'personal':
        return Colors.blue;
      case 'home':
        return Colors.green;
      case 'car':
        return Colors.orange;
      case 'education':
        return Colors.purple;
      case 'business':
        return Colors.teal;
      default:
        return Colors.grey;
    }
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
      default:
        return Icons.account_balance;
    }
  }
}
