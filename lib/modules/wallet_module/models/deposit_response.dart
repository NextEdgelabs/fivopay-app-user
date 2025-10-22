import 'package:janseva/modules/wallet_module/models/razorpay_order.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

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
        razorpayOrderId: json["razorpayOrderId"],
        razorpayKeyId: json["razorpayKeyId"],
        order: RazorpayOrder.fromJson(json["order"]),
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
