import 'package:janseva/modules/loan/models/loan_agreement.dart';
import 'package:janseva/modules/loan/models/models.dart';
import '../../../models/user.dart';

class LoanApplicationResponse {
  final bool success;
  final List<LoanApplicationData> loanApplications;
  
  LoanApplicationResponse({
    required this.success,
    required this.loanApplications,
  });
  
  factory LoanApplicationResponse.fromJson(Map<String, dynamic> json) =>
      LoanApplicationResponse(
        success: json["success"] ?? false,
        loanApplications: json["result"] != null && json["result"]['loans'] != null
            ? List<LoanApplicationData>.from(
                json["result"]['loans'].map((x) => LoanApplicationData.fromJson(x)),
              )
            : [],
      );
}

class LoanApplicationData {
  String id;
  User? userId;
  LoanCategory? category;
  LoanProduct? product;
  LoanAgreementModel? agreement;
  int amount;
  List<dynamic> documents;
  String approvalStatus;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  LoanApplicationData({
    required this.id,
    this.userId,
    this.category,
    this.product,
    required this.amount,
    required this.documents,
    required this.approvalStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.agreement,
  });

  LoanApplicationData copyWith({
    String? id,
    User? userId,
    LoanCategory? category,
    LoanProduct? product,
    int? amount,
    List<dynamic>? documents,
    String? approvalStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    LoanAgreementModel? agreement,
  }) => LoanApplicationData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    category: category ?? this.category,
    product: product ?? this.product,
    amount: amount ?? this.amount,
    documents: documents ?? this.documents,
    approvalStatus: approvalStatus ?? this.approvalStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    v: v ?? this.v,
    agreement: agreement ?? this.agreement,
  );

  factory LoanApplicationData.fromJson(Map<String, dynamic> json) =>
      LoanApplicationData(
        id: json["_id"] ?? '',
        userId: json["userId"] != null ? User.fromJson(json["userId"]) : null,
        category: json["category"] != null ? LoanCategory.fromJson(json["category"]) : null,
        product: json["product"] != null ? LoanProduct.fromJson(json["product"]) : null,
        amount: json["amount"] ?? 0,
        documents: json["documents"] != null 
            ? List<dynamic>.from(json["documents"].map((x) => x))
            : [],
        approvalStatus: json["approvalStatus"] ?? '',
        createdAt: json["createdAt"] != null 
            ? DateTime.parse(json["createdAt"]) 
            : DateTime.now(),
        updatedAt: json["updatedAt"] != null 
            ? DateTime.parse(json["updatedAt"]) 
            : DateTime.now(),
        agreement: json["loanAgreement"] != null
            ? LoanAgreementModel.fromJson(json["loanAgreement"])
            : null,
        v: json["__v"] ?? 0,
      );
}
