class BranchModel {
  final String? id;
  final String? branchName;
  final String? branchCode;
  final String? branchType;
  final String? organisation;
  final String? addressLine1;
  final String? addressLine2;
  final String? state;
  final String? city;
  final String? postalCode;
  final String? landmark;
  final String? managerName;
  final String? managerPhone;
  final String? phone;
  final String? email;
  final DateTime? openingDate;
  final Map<String, dynamic>? workingHours;
  final List<String>? services;
  final String? status;
  final bool? isDeleted;
  final bool? isActive;
  final String? description;
  final int? totalEmployees;
  final int? totalCustomers;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  BranchModel({
    this.id,
    this.branchName,
    this.branchCode,
    this.branchType,
    this.organisation,
    this.addressLine1,
    this.addressLine2,
    this.state,
    this.city,
    this.postalCode,
    this.landmark,
    this.managerName,
    this.managerPhone,
    this.phone,
    this.email,
    this.openingDate,
    this.workingHours,
    this.services,
    this.status,
    this.isDeleted,
    this.isActive,
    this.description,
    this.totalEmployees,
    this.totalCustomers,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  BranchModel copyWith({
    String? id,
    String? branchName,
    String? branchCode,
    String? branchType,
    String? organisation,
    String? addressLine1,
    String? addressLine2,
    String? state,
    String? city,
    String? postalCode,
    String? landmark,
    String? managerName,
    String? managerPhone,
    String? phone,
    String? email,
    DateTime? openingDate,
    Map<String, dynamic>? workingHours,
    List<String>? services,
    String? status,
    bool? isDeleted,
    bool? isActive,
    String? description,
    int? totalEmployees,
    int? totalCustomers,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => BranchModel(
    id: id ?? this.id,
    branchName: branchName ?? this.branchName,
    branchCode: branchCode ?? this.branchCode,
    branchType: branchType ?? this.branchType,
    organisation: organisation ?? this.organisation,
    addressLine1: addressLine1 ?? this.addressLine1,
    addressLine2: addressLine2 ?? this.addressLine2,
    state: state ?? this.state,
    city: city ?? this.city,
    postalCode: postalCode ?? this.postalCode,
    landmark: landmark ?? this.landmark,
    managerName: managerName ?? this.managerName,
    managerPhone: managerPhone ?? this.managerPhone,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    openingDate: openingDate ?? this.openingDate,
    workingHours: workingHours ?? this.workingHours,
    services: services ?? this.services,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    isActive: isActive ?? this.isActive,
    description: description ?? this.description,
    totalEmployees: totalEmployees ?? this.totalEmployees,
    totalCustomers: totalCustomers ?? this.totalCustomers,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    id: json["_id"]?.toString(),
    branchName: json["branchName"]?.toString(),
    branchCode: json["branchCode"]?.toString(),
    branchType: json["branchType"]?.toString(),
    organisation: json["organisation"]?.toString(),
    addressLine1: json["addressLine1"]?.toString(),
    addressLine2: json["addressLine2"]?.toString(),
    state: json["state"]?.toString(),
    city: json["city"]?.toString(),
    postalCode: json["postalCode"]?.toString(),
    landmark: json["landmark"]?.toString(),
    managerName: json["managerName"]?.toString(),
    managerPhone: json["managerPhone"]?.toString(),
    phone: json["phone"]?.toString(),
    email: json["email"]?.toString(),
    openingDate: _parseDate(json["openingDate"]),
    workingHours: json["workingHours"] is Map
        ? Map<String, dynamic>.from(json["workingHours"] as Map)
        : null,
    services: json["services"] is List
        ? (json["services"] as List)
              .map((e) => e?.toString() ?? "")
              .where((e) => e.isNotEmpty)
              .toList()
        : null,
    status: json["status"]?.toString(),
    isDeleted: json["isDeleted"] is bool ? json["isDeleted"] as bool : null,
    isActive: json["isActive"] is bool ? json["isActive"] as bool : null,
    description: json["description"]?.toString(),
    totalEmployees: _parseInt(json["totalEmployees"]),
    totalCustomers: _parseInt(json["totalCustomers"]),
    createdAt: _parseDate(json["createdAt"]),
    updatedAt: _parseDate(json["updatedAt"]),
    v: _parseInt(json["__v"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "branchName": branchName,
    "branchCode": branchCode,
    "branchType": branchType,
    "organisation": organisation,
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "state": state,
    "city": city,
    "postalCode": postalCode,
    "landmark": landmark,
    "managerName": managerName,
    "managerPhone": managerPhone,
    "phone": phone,
    "email": email,
    "openingDate": openingDate?.toIso8601String(),
    "workingHours": workingHours,
    "services": services,
    "status": status,
    "isDeleted": isDeleted,
    "isActive": isActive,
    "description": description,
    "totalEmployees": totalEmployees,
    "totalCustomers": totalCustomers,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
