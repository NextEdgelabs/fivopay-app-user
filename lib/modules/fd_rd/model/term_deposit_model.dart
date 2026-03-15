import 'package:janseva/modules/fd_rd/model/deposit_product_model.dart';

class DepositAccountModel {
  final String id;
  final String? depositId;
  final String? transactionId;
  final String? userId;
  final CustomerId? customerId;
  final String? depositType;
  final String? transactionType;
  final double? depositAmount;
  final double? fees;
  final double? netAmount;
  final double? interestRate;
  final BranchModel? branchId;
  final DepositProduct? productId;
  final String? productIdStr;
  final String status;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? razorpayOrderId;
  final String? description;
  final double? currentBalance;
  final double? balanceBefore;
  final double? balanceAfter;
  final double? totalDeposits;
  final double? totalWithdrawals;
  final double? interestEarned;
  final String? accountNumber;
  final bool? autoRenewal;
  final bool? isRefundable;
  final bool? isReversible;
  final int? retryCount;
  final String? ipAddress;
  final String? userAgent;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  DepositAccountModel({
    required this.id,
    this.depositId,
    this.transactionId,
    this.userId,
    this.customerId,
    this.depositType,
    this.transactionType,
    this.depositAmount,
    this.fees,
    this.netAmount,
    this.interestRate,
    this.branchId,
    this.productId,
    this.productIdStr,
    required this.status,
    this.paymentMethod,
    this.paymentStatus,
    this.razorpayOrderId,
    this.description,
    this.currentBalance,
    this.balanceBefore,
    this.balanceAfter,
    this.totalDeposits,
    this.totalWithdrawals,
    this.interestEarned,
    this.accountNumber,
    this.autoRenewal,
    this.isRefundable,
    this.isReversible,
    this.retryCount,
    this.ipAddress,
    this.userAgent,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  DepositAccountModel copyWith({
    String? id,
    String? depositId,
    String? transactionId,
    String? userId,
    CustomerId? customerId,
    String? depositType,
    String? transactionType,
    double? depositAmount,
    double? fees,
    double? netAmount,
    double? interestRate,
    BranchModel? branchId,
    DepositProduct? productId,
    String? productIdStr,
    String? status,
    String? paymentMethod,
    String? paymentStatus,
    String? razorpayOrderId,
    String? description,
    double? currentBalance,
    double? balanceBefore,
    double? balanceAfter,
    double? totalDeposits,
    double? totalWithdrawals,
    double? interestEarned,
    String? accountNumber,
    bool? autoRenewal,
    bool? isRefundable,
    bool? isReversible,
    int? retryCount,
    String? ipAddress,
    String? userAgent,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) => DepositAccountModel(
    id: id ?? this.id,
    depositId: depositId ?? this.depositId,
    transactionId: transactionId ?? this.transactionId,
    userId: userId ?? this.userId,
    customerId: customerId ?? this.customerId,
    depositType: depositType ?? this.depositType,
    transactionType: transactionType ?? this.transactionType,
    depositAmount: depositAmount ?? this.depositAmount,
    fees: fees ?? this.fees,
    netAmount: netAmount ?? this.netAmount,
    interestRate: interestRate ?? this.interestRate,
    branchId: branchId ?? this.branchId,
    productId: productId ?? this.productId,
    productIdStr: productIdStr ?? this.productIdStr,
    status: status ?? this.status,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    razorpayOrderId: razorpayOrderId ?? this.razorpayOrderId,
    description: description ?? this.description,
    currentBalance: currentBalance ?? this.currentBalance,
    balanceBefore: balanceBefore ?? this.balanceBefore,
    balanceAfter: balanceAfter ?? this.balanceAfter,
    totalDeposits: totalDeposits ?? this.totalDeposits,
    totalWithdrawals: totalWithdrawals ?? this.totalWithdrawals,
    interestEarned: interestEarned ?? this.interestEarned,
    accountNumber: accountNumber ?? this.accountNumber,
    autoRenewal: autoRenewal ?? this.autoRenewal,
    isRefundable: isRefundable ?? this.isRefundable,
    isReversible: isReversible ?? this.isReversible,
    retryCount: retryCount ?? this.retryCount,
    ipAddress: ipAddress ?? this.ipAddress,
    userAgent: userAgent ?? this.userAgent,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
  );

  factory DepositAccountModel.fromJson(Map<String, dynamic> json) =>
      DepositAccountModel(
        id: json["_id"],
        depositId: json["depositId"],
        transactionId: json["transactionId"],
        userId: json["userId"],
        customerId: json["customerId"] == null
            ? null
            : json["customerId"] is String 
                ? null 
                : CustomerId.fromJson(json["customerId"]),
        depositType: json["depositType"],
        transactionType: json["transactionType"],
        depositAmount: (json["depositAmount"] as num?)?.toDouble() ?? (json["amount"] as num?)?.toDouble(),
        fees: (json["fees"] as num?)?.toDouble(),
        netAmount: (json["netAmount"] as num?)?.toDouble(),
        interestRate: (json["interestRate"] as num?)?.toDouble(),
        branchId: json["branchId"] == null
            ? null
            : BranchModel.fromJson(json["branchId"]),
        productId: json["productId"] == null
            ? null
            : json["productId"] is String 
                ? null 
                : DepositProduct.fromJson(json["productId"]),
        productIdStr: json["productId"] is String ? json["productId"] : null,
        status: json["status"] ?? 'N/A',
        paymentMethod: json["paymentMethod"],
        paymentStatus: json["paymentStatus"],
        razorpayOrderId: json["razorpayOrderId"],
        description: json["description"],
        currentBalance: (json["currentBalance"] as num?)?.toDouble() ?? 0.0,
        balanceBefore: (json["balanceBefore"] as num?)?.toDouble(),
        balanceAfter: (json["balanceAfter"] as num?)?.toDouble(),
        totalDeposits: (json["totalDeposits"] as num?)?.toDouble() ?? 0.0,
        totalWithdrawals: (json["totalWithdrawals"] as num?)?.toDouble() ?? 0.0,
        interestEarned: (json["interestEarned"] as num?)?.toDouble() ?? 0.0,
        accountNumber: json["accountNumber"],
        autoRenewal: json["autoRenewal"],
        isRefundable: json["isRefundable"],
        isReversible: json["isReversible"],
        retryCount: json["retryCount"],
        ipAddress: json["ipAddress"],
        userAgent: json["userAgent"],
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
    "transactionId": transactionId,
    "userId": userId,
    "customerId": customerId?.toJson(),
    "depositType": depositType,
    "transactionType": transactionType,
    "depositAmount": depositAmount,
    "fees": fees,
    "netAmount": netAmount,
    "interestRate": interestRate,
    "branchId": branchId?.toJson(),
    "productId": productId?.toJson() ?? productIdStr,
    "status": status,
    "paymentMethod": paymentMethod,
    "paymentStatus": paymentStatus,
    "razorpayOrderId": razorpayOrderId,
    "description": description,
    "currentBalance": currentBalance,
    "balanceBefore": balanceBefore,
    "balanceAfter": balanceAfter,
    "totalDeposits": totalDeposits,
    "totalWithdrawals": totalWithdrawals,
    "interestEarned": interestEarned,
    "accountNumber": accountNumber,
    "autoRenewal": autoRenewal,
    "isRefundable": isRefundable,
    "isReversible": isReversible,
    "retryCount": retryCount,
    "ipAddress": ipAddress,
    "userAgent": userAgent,
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
