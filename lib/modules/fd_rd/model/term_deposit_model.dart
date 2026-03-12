import 'package:janseva/modules/fd_rd/model/deposit_product_model.dart';

class DepositAccountModel {
  final String id;
  final String? depositId;
  final CustomerId? customerId;
  final String? depositType;
  final double? depositAmount;
  final double? interestRate;
  final BranchModel? branchId;
  final DepositProduct? productId;
  final String status;
  final double? currentBalance;
  final double? totalDeposits;
  final double? totalWithdrawals;
  final double? interestEarned;
  final String? accountNumber;
  final bool? autoRenewal;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  DepositAccountModel({
    required this.id,
    this.depositId,
    this.customerId,
    this.depositType,
    this.depositAmount,
    this.interestRate,
    this.branchId,
    this.productId,
    required this.status,
    this.currentBalance,
    this.totalDeposits,
    this.totalWithdrawals,
    this.interestEarned,
    this.accountNumber,
    this.autoRenewal,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  DepositAccountModel copyWith({
    String? id,
    String? depositId,
    CustomerId? customerId,
    String? depositType,
    double? depositAmount,
    double? interestRate,
    BranchModel? branchId,
    DepositProduct? productId,
    String? status,
    double? currentBalance,
    double? totalDeposits,
    double? totalWithdrawals,
    double? interestEarned,
    String? accountNumber,
    bool? autoRenewal,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => DepositAccountModel(
    id: id ?? this.id,
    depositId: depositId ?? this.depositId,
    customerId: customerId ?? this.customerId,
    depositType: depositType ?? this.depositType,
    depositAmount: depositAmount ?? this.depositAmount,
    interestRate: interestRate ?? this.interestRate,
    branchId: branchId ?? this.branchId,
    productId: productId ?? this.productId,
    status: status ?? this.status,
    currentBalance: currentBalance ?? this.currentBalance,
    totalDeposits: totalDeposits ?? this.totalDeposits,
    totalWithdrawals: totalWithdrawals ?? this.totalWithdrawals,
    interestEarned: interestEarned ?? this.interestEarned,
    accountNumber: accountNumber ?? this.accountNumber,
    autoRenewal: autoRenewal ?? this.autoRenewal,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory DepositAccountModel.fromJson(Map<String, dynamic> json) =>
      DepositAccountModel(
        id: json["_id"],
        depositId: json["depositId"],
        customerId: json["customerId"] == null
            ? null
            : CustomerId.fromJson(json["customerId"]),
        depositType: json["depositType"],
        depositAmount: (json["depositAmount"] as num?)?.toDouble(),
        interestRate: (json["interestRate"] as num?)?.toDouble(),
        branchId: json["branchId"] == null
            ? null
            : BranchModel.fromJson(json["branchId"]),
        productId: json["productId"] == null
            ? null
            : DepositProduct.fromJson(json["productId"]),
        status: json["status"] ?? 'N/A',
        currentBalance: (json["currentBalance"] as num?)?.toDouble() ?? 0.0,
        totalDeposits: (json["totalDeposits"] as num?)?.toDouble() ?? 0.0,
        totalWithdrawals: (json["totalWithdrawals"] as num?)?.toDouble() ?? 0.0,
        interestEarned: (json["interestEarned"] as num?)?.toDouble() ?? 0.0,
        accountNumber: json["accountNumber"],
        autoRenewal: json["autoRenewal"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "depositId": depositId,
    "customerId": customerId?.toJson(),
    "depositType": depositType,
    "depositAmount": depositAmount,
    "interestRate": interestRate,
    "branchId": branchId?.toJson(),
    "productId": productId?.toJson(),
    "status": status,
    "currentBalance": currentBalance,
    "totalDeposits": totalDeposits,
    "totalWithdrawals": totalWithdrawals,
    "interestEarned": interestEarned,
    "accountNumber": accountNumber,
    "autoRenewal": autoRenewal,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
  };
}

class BranchModel {
  final String? id;
  final String? branchName;
  final String? branchCode;

  BranchModel({this.id, this.branchName, this.branchCode});

  BranchModel copyWith({String? id, String? branchName, String? branchCode}) =>
      BranchModel(
        id: id ?? this.id,
        branchName: branchName ?? this.branchName,
        branchCode: branchCode ?? this.branchCode,
      );

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    id: json["_id"],
    branchName: json["branchName"],
    branchCode: json["branchCode"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "branchName": branchName,
    "branchCode": branchCode,
  };
}

class CustomerId {
  final String? id;
  final String? memberId;
  final String? fullName;
  final String? email;
  final String? phone;

  CustomerId({this.id, this.memberId, this.fullName, this.email, this.phone});

  CustomerId copyWith({
    String? id,
    String? memberId,
    String? fullName,
    String? email,
    String? phone,
  }) => CustomerId(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    phone: phone ?? this.phone,
  );

  factory CustomerId.fromJson(Map<String, dynamic> json) => CustomerId(
    id: json["_id"],
    memberId: json["memberId"],
    fullName: json["fullName"],
    email: json["email"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "memberId": memberId,
    "fullName": fullName,
    "email": email,
    "phone": phone,
  };
}
