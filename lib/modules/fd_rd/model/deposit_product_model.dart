import 'deposit_category_model.dart';

// Deposit Product Status Enum
enum DepositProductStatus {
  active,
  inactive;

  String get value {
    switch (this) {
      case DepositProductStatus.active:
        return 'active';
      case DepositProductStatus.inactive:
        return 'inactive';
    }
  }

  static DepositProductStatus fromString(String status) {
    switch (status) {
      case 'active':
        return DepositProductStatus.active;
      case 'inactive':
        return DepositProductStatus.inactive;
      default:
        return DepositProductStatus.active;
    }
  }
}

// Deposit Product Type Enum
enum DepositProductType {
  savings, // Savings account
  current, // Current account
  fd, // Fixed Deposit
  rd; // Recurring Deposit

  String get value {
    switch (this) {
      case DepositProductType.savings:
        return 'savings';
      case DepositProductType.current:
        return 'current';
      case DepositProductType.fd:
        return 'fd';
      case DepositProductType.rd:
        return 'rd';
    }
  }

  static DepositProductType fromString(String type) {
    switch (type) {
      case 'savings':
        return DepositProductType.savings;
      case 'current':
        return DepositProductType.current;
      case 'fd':
        return DepositProductType.fd;
      case 'rd':
        return DepositProductType.rd;
      default:
        return DepositProductType.fd;
    }
  }

  // Display name for UI
  String get displayName {
    switch (this) {
      case DepositProductType.savings:
        return 'Savings Account';
      case DepositProductType.current:
        return 'Current Account';
      case DepositProductType.fd:
        return 'Fixed Deposit';
      case DepositProductType.rd:
        return 'Recurring Deposit';
    }
  }
}

// Deposit Product Model
class DepositProduct {
  final String id;
  final String productName;
  final DepositCategory category;
  final DepositProductType productType;
  final String description;
  final String organisation;
  final double minAmount;
  final double maxAmount;
  final double defaultInterestRate;
  final DepositProductStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? v;
  final int minTenureMonths;
  final int maxTenureMonths;

  DepositProduct({
    required this.id,
    required this.productName,
    required this.category,
    required this.productType,
    required this.description,
    required this.organisation,
    required this.minAmount,
    required this.maxAmount,
    required this.defaultInterestRate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.v,
    required this.minTenureMonths,
    required this.maxTenureMonths,
  });

  // From JSON
  factory DepositProduct.fromJson(Map<String, dynamic> json) {
    return DepositProduct(
      id: json['_id'] ?? '',
      productName: json['productName'] ?? '',
      category: DepositCategory.fromJson(json['category'] ?? {}),
      productType: DepositProductType.fromString(json['productType'] ?? ''),
      description: json['description'] ?? '',
      organisation: json['organisation'] ?? '',
      minAmount: (json['minAmount'] ?? 0).toDouble(),
      maxAmount: (json['maxAmount'] ?? 0).toDouble(),
      defaultInterestRate: (json['defaultInterestRate'] ?? 0).toDouble(),
      status: DepositProductStatus.fromString(json['status'] ?? 'active'),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      v: json['__v'],
      minTenureMonths: json['minTenureMonths'] ?? 12,
      maxTenureMonths: json['maxTenureMonths'] ?? 12,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productName': productName,
      'category': category.toJson(),
      'productType': productType.value,
      'description': description,
      'organisation': organisation,
      'minAmount': minAmount,
      'maxAmount': maxAmount,
      'defaultInterestRate': defaultInterestRate,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  // Copy with
  DepositProduct copyWith({
    String? id,
    String? productName,
    DepositCategory? category,
    DepositProductType? productType,
    String? description,
    String? organisation,
    double? minAmount,
    double? maxAmount,
    double? defaultInterestRate,
    DepositProductStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    int? minTenureMonths,
    int? maxTenureMonths,
  }) {
    return DepositProduct(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      productType: productType ?? this.productType,
      description: description ?? this.description,
      organisation: organisation ?? this.organisation,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      defaultInterestRate: defaultInterestRate ?? this.defaultInterestRate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      minTenureMonths: minTenureMonths ?? this.minTenureMonths,
      maxTenureMonths: maxTenureMonths ?? this.maxTenureMonths,
    );
  }
}
