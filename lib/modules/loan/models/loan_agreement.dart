import 'dart:convert';

class LoanAgreementModel {
  String? id;
  String? documentName;
  String? document;
  bool? estampRequired;

  // int txnExpiryMin;

  String? esignType;

  DateTime? createdAt;
  DateTime? updatedAt;

  String? estampId;

  LoanAgreementModel({
    required this.id,
    required this.documentName,
    required this.document,
    required this.estampRequired,

    // required this.txnExpiryMin,
    required this.esignType,

    required this.createdAt,
    required this.updatedAt,

    required this.estampId,
  });

  factory LoanAgreementModel.fromRawJson(String str) =>
      LoanAgreementModel.fromJson(json.decode(str));

  factory LoanAgreementModel.fromJson(Map<String, dynamic> json) =>
      LoanAgreementModel(
        id: json["_id"] ,
        documentName: json["documentName"],
        document: json["document"],
        estampRequired: json["estampRequired"],

        // txnExpiryMin: json["txnExpiryMin"],
        esignType: json["esignType"],

        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),

        estampId: json["estampId"],
      );
}
