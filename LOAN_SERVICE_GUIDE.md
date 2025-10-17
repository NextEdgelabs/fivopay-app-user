# Loan Categories Service - Usage Guide

This document explains how to use the newly created loan categories service and models.

## Overview

The loan service provides methods to fetch and manage loan categories from the API. It includes comprehensive models for handling loan data with proper serialization and helper methods.

## File Structure

```
lib/modules/loan/
├── models/
│   ├── loan_category.dart          # Main loan category model
│   ├── pagination.dart             # Pagination model
│   ├── loan_categories_response.dart # API response wrapper
│   └── models.dart                 # Export file for all models
├── services/
│   └── loan_service.dart          # Loan API service
└── widgets/
    └── loan_categories_demo.dart   # Demo widget showing usage
```

## Models

### LoanCategory
Main model representing a loan category with all details:
- Basic info: id, name, description, type
- Financial details: amount range, interest rate, tenure
- Fees: processing, prepayment, late payment charges
- Eligibility criteria and required documents
- Features and terms & conditions

**Helper Properties:**
- `formattedMinAmount` / `formattedMaxAmount`: Formatted currency strings
- `formattedInterestRate`: Interest rate with % symbol
- `formattedTenure`: Tenure range in months
- `loanAmountRange`: Complete amount range string

### EligibilityCriteria
Contains loan eligibility requirements:
- Age range (min/max)
- Minimum income requirement
- Required documents list
- Minimum credit score

**Helper Properties:**
- `formattedAgeRange`: Age range string
- `formattedMinIncome`: Formatted income with currency
- `formattedCreditScore`: Credit score with "Min." prefix

### Fee Models (ProcessingFee, PrepaymentCharges, LatePaymentCharges)
Handle different fee structures:
- Support both percentage and fixed amount fees
- Automatic formatting based on fee type
- Helper property `formattedFee`/`formattedCharges` for display

## Service Methods

### Basic Usage

```dart
import '../modules/loan/services/loan_service.dart';
import '../modules/loan/models/models.dart';

// Get all loan categories
final response = await LoanServices.getLoanCategories();
if (response != null && response.success) {
  final categories = response.result.loanCategories;
  // Use categories...
}
```

### Available Methods

1. **getLoanCategories()** - Get all loan categories with optional filters
```dart
// Get all active loan categories (default)
final response = await LoanServices.getLoanCategories();

// Get specific loan type
final response = await LoanServices.getLoanCategories(
  loanType: 'personal',
  page: 1,
  limit: 10,
);

// Get with custom status
final response = await LoanServices.getLoanCategories(
  status: 'active',
  page: 2,
  limit: 5,
);
```

2. **getLoanCategoriesByType()** - Get categories filtered by loan type
```dart
final personalLoans = await LoanServices.getLoanCategoriesByType('personal');
```

3. **getAvailableLoanTypes()** - Get list of all available loan types
```dart
final loanTypes = await LoanServices.getAvailableLoanTypes();
// Returns: ['personal', 'home', 'car', 'education', 'business']
```

4. **getLoanCategoryById()** - Get specific loan category by ID
```dart
final category = await LoanServices.getLoanCategoryById('68f226bc18c2fea5c456fe82');
```

## Error Handling

All service methods return nullable types and handle errors gracefully:

```dart
try {
  final response = await LoanServices.getLoanCategories();
  if (response != null && response.success) {
    // Success case
    final categories = response.result.loanCategories;
  } else {
    // API returned error or null
    print('Failed to fetch loan categories');
  }
} catch (e) {
  // Network or parsing error
  print('Error: $e');
}
```

## Response Structure

The API response matches this structure:
```json
{
  "success": true,
  "result": {
    "loanCategories": [...],
    "pagination": {
      "currentPage": 1,
      "totalPages": 1,
      "totalItems": 5,
      "itemsPerPage": 10
    }
  }
}
```

## Helper Methods

The response model includes useful helper methods:

```dart
final response = await LoanServices.getLoanCategories();
if (response != null) {
  final result = response.result;
  
  // Get categories by type
  final personalLoans = result.getLoanCategoriesByType('personal');
  
  // Get all available loan types
  final types = result.availableLoanTypes;
  
  // Get only active categories
  final activeCategories = result.activeLoanCategories;
}
```

## UI Integration Example

See `loan_categories_demo.dart` for a complete Flutter widget that:
- Fetches loan categories on load
- Displays them in a user-friendly card layout
- Handles loading and error states
- Supports pull-to-refresh
- Shows all loan details with proper formatting

## API Configuration

The service uses the API configuration from `config/api_config.dart`:
- Base URL: `ApiConfig.domain`
- Endpoint: `/loan/categories`
- Headers: Includes authorization and API key

## Next Steps

1. **Provider Integration**: Create a provider class to manage loan categories state
2. **Caching**: Add local caching for better performance
3. **Search & Filter**: Add search and advanced filtering capabilities
4. **Error UI**: Create reusable error handling widgets
5. **Offline Support**: Add offline data storage and sync

## Example Provider Implementation

```dart
class LoanCategoriesProvider extends ChangeNotifier {
  List<LoanCategory> _categories = [];
  bool _isLoading = false;
  String? _error;
  
  List<LoanCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await LoanServices.getLoanCategories();
      if (response != null && response.success) {
        _categories = response.result.loanCategories;
      } else {
        _error = 'Failed to load loan categories';
      }
    } catch (e) {
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }
}
```

This implementation provides a robust foundation for handling loan categories in your Flutter application!