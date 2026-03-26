// Deposit Category Status Enum
enum DepositCategoryStatus {
  active,
  inactive;

  String get value {
    switch (this) {
      case DepositCategoryStatus.active:
        return 'active';
      case DepositCategoryStatus.inactive:
        return 'inactive';
    }
  }

  static DepositCategoryStatus fromString(String status) {
    switch (status) {
      case 'active':
        return DepositCategoryStatus.active;
      case 'inactive':
        return DepositCategoryStatus.inactive;
      default:
        return DepositCategoryStatus.active;
    }
  }
}

// Deposit Category Type Enum
enum DepositCategoryType {
  demandDeposit, // Savings / Current
  termDeposit; // FD / RD

  String get value {
    switch (this) {
      case DepositCategoryType.demandDeposit:
        return 'demand_deposit';
      case DepositCategoryType.termDeposit:
        return 'term_deposit';
    }
  }

  static DepositCategoryType fromString(String type) {
    switch (type) {
      case 'demand_deposit':
        return DepositCategoryType.demandDeposit;
      case 'term_deposit':
        return DepositCategoryType.termDeposit;
      default:
        return DepositCategoryType.termDeposit;
    }
  }
}

// Deposit Category Model
class DepositCategory {
  final String id;
  final String categoryName;
  final DepositCategoryType categoryType;
  final String description;
  final DepositCategoryStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? v;

  DepositCategory({
    required this.id,
    required this.categoryName,
    required this.categoryType,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.v,
  });

  // From JSON
  factory DepositCategory.fromJson(Map<String, dynamic> json) {
    return DepositCategory(
      id: json['_id'] ?? '',
      categoryName: json['categoryName'] ?? '',
      categoryType: DepositCategoryType.fromString(json['categoryType'] ?? ''),
      description: json['description'] ?? '',
      status: DepositCategoryStatus.fromString(json['status'] ?? 'active'),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      v: json['__v'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryName': categoryName,
      'categoryType': categoryType.value,
      'description': description,
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  // Copy with
  DepositCategory copyWith({
    String? id,
    String? categoryName,
    DepositCategoryType? categoryType,
    String? description,
    DepositCategoryStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return DepositCategory(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      categoryType: categoryType ?? this.categoryType,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}
