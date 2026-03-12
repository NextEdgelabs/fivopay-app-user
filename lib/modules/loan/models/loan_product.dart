import 'dart:convert';

import 'loan_category.dart';
export 'loan_product.dart';

class LoanProduct {
  String id;
  String name;
  String description;
  String productType;
  LoanCategory? loanCategory;
  double minAmount;
  double maxAmount;
  double interestRate;
  int minTenureMonths;
  int maxTenureMonths;
  String repaymentFrequency;
  String status;
  EligibilityCriteria? eligibilityCriteria;
  LatePaymentCharges? processingFee;
  LatePaymentCharges? prepaymentCharges;
  LatePaymentCharges? latePaymentCharges;
  List<String>? features;
  List<String>? benefits;
  String? termsAndConditions;
  List<String>? documentsRequired;
  ApplicationProcess? applicationProcess;
  List<PromotionalOffer>? promotionalOffers;
  DateTime? createdAt;
  DateTime? updatedAt;
  int v;

  LoanProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.productType,
    required this.minAmount,
    required this.maxAmount,
    required this.interestRate,
    required this.minTenureMonths,
    required this.maxTenureMonths,
    required this.repaymentFrequency,
    required this.status,
    required this.eligibilityCriteria,
    required this.processingFee,
    required this.prepaymentCharges,
    required this.latePaymentCharges,
    required this.features,
    required this.benefits,
    required this.termsAndConditions,
    required this.documentsRequired,
    required this.applicationProcess,
    required this.promotionalOffers,
    required this.createdAt,
    required this.updatedAt,
    required this.loanCategory,
    required this.v,
  });

  // Formatted getters
  String get formattedMinAmount {
    if (minAmount >= 10000000) {
      return '₹${(minAmount / 10000000).toStringAsFixed(1)}Cr';
    } else if (minAmount >= 100000) {
      return '₹${(minAmount / 100000).toStringAsFixed(1)}L';
    } else if (minAmount >= 1000) {
      return '₹${(minAmount / 1000).toStringAsFixed(0)}K';
    } else {
      return '₹$minAmount';
    }
  }

  String get formattedMaxAmount {
    if (maxAmount >= 10000000) {
      return '₹${(maxAmount / 10000000).toStringAsFixed(1)}Cr';
    } else if (maxAmount >= 100000) {
      return '₹${(maxAmount / 100000).toStringAsFixed(1)}L';
    } else if (maxAmount >= 1000) {
      return '₹${(maxAmount / 1000).toStringAsFixed(0)}K';
    } else {
      return '₹$maxAmount';
    }
  }

  String get formattedAmountRange {
    return '$formattedMinAmount - $formattedMaxAmount';
  }

  String get formattedTenureRange {
    if (minTenureMonths == maxTenureMonths) {
      return '${minTenureMonths} month${minTenureMonths > 1 ? 's' : ''}';
    }

    String minTenure = minTenureMonths >= 12
        ? '${(minTenureMonths / 12).floor()} year${(minTenureMonths / 12).floor() > 1 ? 's' : ''}'
        : '$minTenureMonths month${minTenureMonths > 1 ? 's' : ''}';

    String maxTenure = maxTenureMonths >= 12
        ? '${(maxTenureMonths / 12).floor()} year${(maxTenureMonths / 12).floor() > 1 ? 's' : ''}'
        : '$maxTenureMonths month${maxTenureMonths > 1 ? 's' : ''}';

    return '$minTenure - $maxTenure';
  }

  String get formattedInterestRate {
    return '${interestRate.toStringAsFixed(2)}% p.a.';
  }

  String get formattedRepaymentFrequency {
    switch (repaymentFrequency.toLowerCase()) {
      case 'monthly':
        return 'Monthly';
      case 'quarterly':
        return 'Quarterly';
      case 'yearly':
      case 'annual':
        return 'Annually';
      case 'weekly':
        return 'Weekly';
      default:
        return repaymentFrequency;
    }
  }

  LoanProduct copyWith({
    String? id,
    String? name,
    String? description,
    String? productType,
    double? minAmount,
    double? maxAmount,
    double? interestRate,
    int? minTenureMonths,
    int? maxTenureMonths,
    String? repaymentFrequency,
    String? status,
    EligibilityCriteria? eligibilityCriteria,
    LatePaymentCharges? processingFee,
    LatePaymentCharges? prepaymentCharges,
    LatePaymentCharges? latePaymentCharges,
    List<String>? features,
    List<String>? benefits,
    String? termsAndConditions,
    List<String>? documentsRequired,
    ApplicationProcess? applicationProcess,
    List<PromotionalOffer>? promotionalOffers,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    LoanCategory? loanCategory,
  }) => LoanProduct(
    loanCategory: loanCategory ?? this.loanCategory,
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    productType: productType ?? this.productType,
    minAmount: minAmount ?? this.minAmount,
    maxAmount: maxAmount ?? this.maxAmount,
    interestRate: interestRate ?? this.interestRate,
    minTenureMonths: minTenureMonths ?? this.minTenureMonths,
    maxTenureMonths: maxTenureMonths ?? this.maxTenureMonths,
    repaymentFrequency: repaymentFrequency ?? this.repaymentFrequency,
    status: status ?? this.status,
    eligibilityCriteria: eligibilityCriteria ?? this.eligibilityCriteria,
    processingFee: processingFee ?? this.processingFee,
    prepaymentCharges: prepaymentCharges ?? this.prepaymentCharges,
    latePaymentCharges: latePaymentCharges ?? this.latePaymentCharges,
    features: features ?? this.features,
    benefits: benefits ?? this.benefits,
    termsAndConditions: termsAndConditions ?? this.termsAndConditions,
    documentsRequired: documentsRequired ?? this.documentsRequired,
    applicationProcess: applicationProcess ?? this.applicationProcess,
    promotionalOffers: promotionalOffers ?? this.promotionalOffers,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory LoanProduct.fromRawJson(String str) =>
      LoanProduct.fromJson(json.decode(str));

  factory LoanProduct.fromJson(Map<String, dynamic> json) => LoanProduct(
    id: json["_id"] ?? '',
    name: json["productName"] ?? '',
    description: json["description"] ?? '',
    productType: json["productType"] ?? '',
    minAmount: json["minLoanAmount"] != null
        ? (json["minLoanAmount"] as num).toDouble()
        : 0,
    maxAmount: json["maxLoanAmount"] != null
        ? (json["maxLoanAmount"] as num).toDouble()
        : 0,
    interestRate: json["interestRate"]?.toDouble() ?? 0.0,
    minTenureMonths: json["minTenureMonths"] ?? 0,
    maxTenureMonths: json["maxTenureMonths"] ?? 0,
    repaymentFrequency: json["repaymentFrequency"] ?? '',
    status: json["status"] ?? '',
    loanCategory: json["category"] is String
        ? null
        : json["category"] != null
        ? LoanCategory.fromJson(json["category"])
        : LoanCategory.fromJson({}),
    eligibilityCriteria: json["eligibilityCriteria"] != null
        ? EligibilityCriteria.fromJson(json["eligibilityCriteria"])
        : EligibilityCriteria.fromJson({}),
    processingFee: LatePaymentCharges.fromJson(json["processingFee"] ?? {}),
    prepaymentCharges: LatePaymentCharges.fromJson(
      json["prepaymentCharges"] ?? {},
    ),
    latePaymentCharges: LatePaymentCharges.fromJson(
      json["latePaymentCharges"] ?? {},
    ),
    features: json["features"] != null
        ? List<String>.from(json["features"].map((x) => x))
        : [],
    benefits: json["benefits"] != null
        ? List<String>.from(json["benefits"].map((x) => x))
        : [],
    termsAndConditions: json["termsAndConditions"] ?? '',
    documentsRequired: json["documentsRequired"] != null
        ? List<String>.from(json["documentsRequired"].map((x) => x))
        : [],
    applicationProcess: ApplicationProcess.fromJson(
      json["applicationProcess"] ?? {},
    ),
    promotionalOffers: json["promotionalOffers"] != null
        ? List<PromotionalOffer>.from(
            json["promotionalOffers"].map((x) => PromotionalOffer.fromJson(x)),
          )
        : [],
    createdAt: json["createdAt"] == null
        ? DateTime.now()
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? DateTime.now()
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"] ?? 0,
  );
}

class ApplicationProcess {
  List<String> steps;
  String estimatedTime;
  List<String> requiredDocuments;

  ApplicationProcess({
    required this.steps,
    required this.estimatedTime,
    required this.requiredDocuments,
  });

  ApplicationProcess copyWith({
    List<String>? steps,
    String? estimatedTime,
    List<String>? requiredDocuments,
  }) => ApplicationProcess(
    steps: steps ?? this.steps,
    estimatedTime: estimatedTime ?? this.estimatedTime,
    requiredDocuments: requiredDocuments ?? this.requiredDocuments,
  );

  factory ApplicationProcess.fromRawJson(String str) =>
      ApplicationProcess.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApplicationProcess.fromJson(Map<String, dynamic> json) =>
      ApplicationProcess(
        steps: json["steps"] == null
            ? []
            : List<String>.from(json["steps"].map((x) => x)),
        estimatedTime: json["estimatedTime"] ?? '',
        requiredDocuments: json["requiredDocuments"] == null
            ? []
            : List<String>.from(json["requiredDocuments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "steps": List<dynamic>.from(steps.map((x) => x)),
    "estimatedTime": estimatedTime,
    "requiredDocuments": List<dynamic>.from(requiredDocuments.map((x) => x)),
  };
}

class PromotionalOffer {
  String title;
  String description;
  DateTime validFrom;
  DateTime validTo;
  double discountPercentage;

  PromotionalOffer({
    required this.title,
    required this.description,
    required this.validFrom,
    required this.validTo,
    required this.discountPercentage,
  });

  PromotionalOffer copyWith({
    String? title,
    String? description,
    DateTime? validFrom,
    DateTime? validTo,
    double? discountPercentage,
  }) => PromotionalOffer(
    title: title ?? this.title,
    description: description ?? this.description,
    validFrom: validFrom ?? this.validFrom,
    validTo: validTo ?? this.validTo,
    discountPercentage: discountPercentage ?? this.discountPercentage,
  );

  factory PromotionalOffer.fromRawJson(String str) =>
      PromotionalOffer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PromotionalOffer.fromJson(Map<String, dynamic> json) =>
      PromotionalOffer(
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        validFrom: json["validFrom"] == null
            ? DateTime.now()
            : DateTime.parse(json["validFrom"]),
        validTo: json["validTo"] == null
            ? DateTime.now()
            : DateTime.parse(json["validTo"]),
        discountPercentage: (json["discountPercentage"] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "validFrom": validFrom.toIso8601String(),
    "validTo": validTo.toIso8601String(),
    "discountPercentage": discountPercentage,
  };
}
