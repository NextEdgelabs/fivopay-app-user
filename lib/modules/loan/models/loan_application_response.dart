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
        success: json["success"],
        loanApplications: List<LoanApplicationData>.from(
          json["result"]['loans'].map((x) => LoanApplicationData.fromJson(x)),
        ),
      );
}

class LoanApplicationData {
  String id;
  User userId;
  LoanCategory category;
  LoanProduct product;
  LoanAgreementModel? agreement;
  int amount;
  List<dynamic> documents;
  String approvalStatus;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  LoanApplicationData({
    required this.id,
    required this.userId,
    required this.category,
    required this.product,
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
        id: json["_id"],
        userId: User.fromJson(json["userId"]),
        category: LoanCategory.fromJson(json["category"]),
        product: LoanProduct.fromJson(json["product"]),
        amount: json["amount"],
        documents: List<dynamic>.from(json["documents"].map((x) => x)),
        approvalStatus: json["approvalStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        agreement: json["loanAgreement"] != null
            ? LoanAgreementModel.fromJson(json["loanAgreement"])
            : null,
        v: json["__v"],
      );
}
