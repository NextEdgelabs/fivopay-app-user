class LoanCategory {
  final String id;
  final String categoryName;
  final String description;
  final String loanType;
  final double minLoanAmount;
  final double maxLoanAmount;
  final double interestRate;
  final int minTenureMonths;
  final int maxTenureMonths;
  final String status;
  final EligibilityCriteria eligibilityCriteria;
  final ProcessingFee processingFee;
  final PrepaymentCharges prepaymentCharges;
  final LatePaymentCharges latePaymentCharges;
  final List<String> features;
  final String termsAndConditions;
  final DateTime createdAt;
  final DateTime updatedAt;

  LoanCategory({
    required this.id,
    required this.categoryName,
    required this.description,
    required this.loanType,
    required this.minLoanAmount,
    required this.maxLoanAmount,
    required this.interestRate,
    required this.minTenureMonths,
    required this.maxTenureMonths,
    required this.status,
    required this.eligibilityCriteria,
    required this.processingFee,
    required this.prepaymentCharges,
    required this.latePaymentCharges,
    required this.features,
    required this.termsAndConditions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoanCategory.fromJson(Map<String, dynamic> json) {
    return LoanCategory(
      id: json['_id'] ?? '',
      categoryName: json['categoryName'] ?? '',
      description: json['description'] ?? '',
      loanType: json['loanType'] ?? '',
      minLoanAmount: json['minLoanAmount'] != null
          ? (json['minLoanAmount'] as num).toDouble()
          : 0,
      maxLoanAmount: json['maxLoanAmount'] != null
          ? (json['maxLoanAmount'] as num).toDouble()
          : 0,
      interestRate: (json['interestRate'] ?? 0).toDouble(),
      minTenureMonths: json['minTenureMonths'] ?? 0,
      maxTenureMonths: json['maxTenureMonths'] ?? 0,
      status: json['status'] ?? '',
      eligibilityCriteria: EligibilityCriteria.fromJson(
        json['eligibilityCriteria'] ?? {},
      ),
      processingFee: ProcessingFee.fromJson(json['processingFee'] ?? {}),
      prepaymentCharges: PrepaymentCharges.fromJson(
        json['prepaymentCharges'] ?? {},
      ),
      latePaymentCharges: LatePaymentCharges.fromJson(
        json['latePaymentCharges'] ?? {},
      ),
      features: List<String>.from(json['features'] ?? []),
      termsAndConditions: json['termsAndConditions'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryName': categoryName,
      'description': description,
      'loanType': loanType,
      'minLoanAmount': minLoanAmount,
      'maxLoanAmount': maxLoanAmount,
      'interestRate': interestRate,
      'minTenureMonths': minTenureMonths,
      'maxTenureMonths': maxTenureMonths,
      'status': status,
      'eligibilityCriteria': eligibilityCriteria.toJson(),
      'processingFee': processingFee.toJson(),
      'prepaymentCharges': prepaymentCharges.toJson(),
      'latePaymentCharges': latePaymentCharges.toJson(),
      'features': features,
      'termsAndConditions': termsAndConditions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper getters for formatted values
  String get formattedMinAmount =>
      '₹${minLoanAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  String get formattedMaxAmount =>
      '₹${maxLoanAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  String get formattedInterestRate => '$interestRate% p.a.';
  String get formattedTenure => '$minTenureMonths-$maxTenureMonths months';
  String get loanAmountRange => '$formattedMinAmount - $formattedMaxAmount';
}

class EligibilityCriteria {
  final int minAge;
  final int maxAge;
  final int minIncome;
  final List<String> requiredDocuments;
  final int creditScoreMin;

  EligibilityCriteria({
    required this.minAge,
    required this.maxAge,
    required this.minIncome,
    required this.requiredDocuments,
    required this.creditScoreMin,
  });

  factory EligibilityCriteria.fromJson(Map<String, dynamic> json) {
    return EligibilityCriteria(
      minAge: json['minAge'] ?? 0,
      maxAge: json['maxAge'] ?? 0,
      minIncome: json['minIncome'] ?? 0,
      requiredDocuments: List<String>.from(json['requiredDocuments'] ?? []),
      creditScoreMin: json['creditScoreMin'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minAge': minAge,
      'maxAge': maxAge,
      'minIncome': minIncome,
      'requiredDocuments': requiredDocuments,
      'creditScoreMin': creditScoreMin,
    };
  }

  String get formattedAgeRange => '$minAge-$maxAge years';
  String get formattedMinIncome => minIncome > 0
      ? '₹${minIncome.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
      : 'No minimum income';
  String get formattedCreditScore => 'Min. $creditScoreMin';
}

class ProcessingFee {
  final String type;
  final dynamic value;

  ProcessingFee({required this.type, required this.value});

  factory ProcessingFee.fromJson(Map<String, dynamic> json) {
    return ProcessingFee(type: json['type'] ?? '', value: json['value'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'value': value};
  }

  String get formattedFee {
    if (type == 'percentage') {
      return '$value%';
    } else if (type == 'fixed') {
      return value == 0
          ? 'No fee'
          : '₹${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    }
    return '$value';
  }
}

class PrepaymentCharges {
  final String type;
  final dynamic value;

  PrepaymentCharges({required this.type, required this.value});

  factory PrepaymentCharges.fromJson(Map<String, dynamic> json) {
    return PrepaymentCharges(
      type: json['type'] ?? '',
      value: json['value'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'value': value};
  }

  String get formattedCharges {
    if (type == 'percentage') {
      return value == 0 ? 'No charges' : '$value%';
    } else if (type == 'fixed') {
      return value == 0
          ? 'No charges'
          : '₹${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    }
    return '$value';
  }
}

class LatePaymentCharges {
  final String type;
  final dynamic value;

  LatePaymentCharges({required this.type, required this.value});

  factory LatePaymentCharges.fromJson(Map<String, dynamic> json) {
    return LatePaymentCharges(
      type: json['type'] ?? '',
      value: json['value'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'value': value};
  }

  String get formattedCharges {
    if (type == 'percentage') {
      return '$value%';
    } else if (type == 'fixed') {
      return '₹${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    }
    return '$value';
  }
}
