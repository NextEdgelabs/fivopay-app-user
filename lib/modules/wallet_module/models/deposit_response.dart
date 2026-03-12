import 'package:janseva/modules/wallet_module/models/razorpay_order.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class SharePurchaseResponse {
  final String customerId;
  final String transactionType;
  final int quantity;
  final int pricePerShare;
  final int totalAmount;
  final String status;
  final String razorpayOrderId;
  final String paymentMethod;
  final String paymentStatus;
  final String transactionId;
  final String id;
  final String razorpayKeyId;
  final RazorpayOrder razorpayOrder;

  SharePurchaseResponse({
    required this.customerId,
    required this.transactionType,
    required this.quantity,
    required this.pricePerShare,
    required this.totalAmount,
    required this.status,
    required this.razorpayOrderId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.transactionId,
    required this.id,
    required this.razorpayKeyId,
    required this.razorpayOrder,
  });

  SharePurchaseResponse copyWith({
    String? customerId,
    String? transactionType,
    int? quantity,
    int? pricePerShare,
    int? totalAmount,
    String? status,
    String? razorpayOrderId,
    String? paymentMethod,
    String? paymentStatus,
    String? transactionId,
    String? id,
    String? razorpayKeyId,
    RazorpayOrder? razorpayOrder,
  }) => SharePurchaseResponse(
    customerId: customerId ?? this.customerId,
    transactionType: transactionType ?? this.transactionType,
    quantity: quantity ?? this.quantity,
    pricePerShare: pricePerShare ?? this.pricePerShare,
    totalAmount: totalAmount ?? this.totalAmount,
    status: status ?? this.status,
    razorpayOrderId: razorpayOrderId ?? this.razorpayOrderId,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    transactionId: transactionId ?? this.transactionId,
    id: id ?? this.id,
    razorpayKeyId: razorpayKeyId ?? this.razorpayKeyId,
    razorpayOrder: razorpayOrder ?? this.razorpayOrder,
  );

  factory SharePurchaseResponse.fromJson(Map<String, dynamic> json) =>
      SharePurchaseResponse(
        customerId: json["customerId"],
        transactionType: json["transactionType"],
        quantity: json["quantity"],
        pricePerShare: json["pricePerShare"],
        totalAmount: json["totalAmount"],
        status: json["status"],
        razorpayOrderId: json["razorpayOrderId"],
        paymentMethod: json["paymentMethod"],
        paymentStatus: json["paymentStatus"],
        transactionId: json["transactionId"],
        id: json["_id"],
        razorpayKeyId: json["razorpayKeyId"],
        razorpayOrder: RazorpayOrder.fromJson(json["razorpayOrder"]),
      );

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "transactionType": transactionType,
    "quantity": quantity,
    "pricePerShare": pricePerShare,
    "totalAmount": totalAmount,
    "status": status,
    "razorpayOrderId": razorpayOrderId,
    "paymentMethod": paymentMethod,
    "paymentStatus": paymentStatus,
    "transactionId": transactionId,
    "_id": id,
    "razorpayKeyId": razorpayKeyId,
    "razorpayOrder": razorpayOrder.toJson(),
  };
}

class DepositResponse {
  String transactionId;
  double amount;
  double fees;
  double netAmount;
  String razorpayOrderId;
  String razorpayKeyId;
  RazorpayOrder order;

  DepositResponse({
    required this.transactionId,
    required this.amount,
    required this.fees,
    required this.netAmount,
    required this.razorpayOrderId,
    required this.razorpayKeyId,
    required this.order,
  });

  DepositResponse copyWith({
    String? transactionId,
    double? amount,
    double? fees,
    double? netAmount,
    String? razorpayOrderId,
    String? razorpayKeyId,
    RazorpayOrder? order,
  }) => DepositResponse(
    transactionId: transactionId ?? this.transactionId,
    amount: amount ?? this.amount,
    fees: fees ?? this.fees,
    netAmount: netAmount ?? this.netAmount,
    razorpayOrderId: razorpayOrderId ?? this.razorpayOrderId,
    razorpayKeyId: razorpayKeyId ?? this.razorpayKeyId,
    order: order ?? this.order,
  );

  factory DepositResponse.fromRawJson(String str) =>
      DepositResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DepositResponse.fromJson(Map<String, dynamic> json) =>
      DepositResponse(
        transactionId: json["transactionId"],
        amount: (json["amount"] as num).toDouble(),
        fees: (json["fees"] as num).toDouble(),
        netAmount: (json["netAmount"] as num).toDouble(),
        razorpayOrderId: json["razorpayOrderId"] ?? "",
        razorpayKeyId: json["razorpayKeyId"] ?? "",
        order: RazorpayOrder.fromJson(json["order"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
    "amount": amount,
    "fees": fees,
    "netAmount": netAmount,
    "razorpayOrderId": razorpayOrderId,
    "razorpayKeyId": razorpayKeyId,
    "order": order.toJson(),
  };
}
