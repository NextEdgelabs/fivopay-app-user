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

  factory LoanApplicationResponse.fromJson(
    Map<String, dynamic> json,
  ) => LoanApplicationResponse(
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
  EsignStaus? esignStatus;
  String? signingUrl;
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
    this.esignStatus,
    this.signingUrl,
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
    EsignStaus? esignStatus,
    String? signingUrl,
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
    esignStatus: esignStatus ?? this.esignStatus,
    signingUrl: signingUrl ?? this.signingUrl,
  );

  factory LoanApplicationData.fromJson(Map<String, dynamic> json) =>
      LoanApplicationData(
        id: json["_id"] ?? '',
        userId: json["userId"] != null ? User.fromJson(json["userId"]) : null,
        category: json["category"] != null
            ? LoanCategory.fromJson(json["category"])
            : null,
        product: json["product"] != null
            ? LoanProduct.fromJson(json["product"])
            : null,
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
        agreement:
            json["loanAgreement"] != null &&
                json["loanAgreement"] is Map<String, dynamic>
            ? LoanAgreementModel.fromJson(json["loanAgreement"])
            : null,
        v: json["__v"] ?? 0,
        esignStatus: json["esignStatus"] != null
            ? EsignStaus.fromJson(json["esignStatus"])
            : null,
        signingUrl: json["signingUrl"],
      );
}

// To parse this JSON data, do
//
//     final esignStaus = esignStausFromJson(jsonString);

class EsignStaus {
  String id;
  Result? result;

  EsignStaus({required this.id, this.result});

  factory EsignStaus.fromJson(Map<String, dynamic> json) => EsignStaus(
    id: json["_id"],
    result: json["result"] != null ? Result.fromJson(json["result"]) : null,
  );

  Map<String, dynamic> toJson() => {"_id": id, "result": result?.toJson()};
}

class Result {
  Document? document;
  ESigner? signer;
  String? authMode;
  String? id;

  Result({this.document, this.signer, this.authMode, this.id});

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    document: json["document"] != null
        ? Document.fromJson(json["document"])
        : null,
    signer: json["signer"] != null ? ESigner.fromJson(json["signer"]) : null,
    authMode: json["auth_mode"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "document": document?.toJson(),
    "signer": signer?.toJson(),
    "auth_mode": authMode,
    "_id": id,
  };
}

class Document {
  String info;
  DateTime signedAt;
  List<Sign> sign;
  String signedUrl;
  String issuedBy;
  String id;

  Document({
    required this.info,
    required this.signedAt,
    required this.sign,
    required this.signedUrl,
    required this.issuedBy,
    required this.id,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    info: json["info"],
    signedAt: DateTime.parse(json["signed_at"]),
    sign: List<Sign>.from(json["sign"].map((x) => Sign.fromJson(x))),
    signedUrl: json["signed_url"],
    issuedBy: json["issued_by"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "info": info,
    "signed_at": signedAt.toIso8601String(),
    "sign": List<dynamic>.from(sign.map((x) => x.toJson())),
    "signed_url": signedUrl,
    "issued_by": issuedBy,
    "_id": id,
  };
}

class Sign {
  int xCoord;
  int yCoord;
  int pageNum;
  String id;

  Sign({
    required this.xCoord,
    required this.yCoord,
    required this.pageNum,
    required this.id,
  });

  factory Sign.fromJson(Map<String, dynamic> json) => Sign(
    xCoord: json["x_coord"],
    yCoord: json["y_coord"],
    pageNum: json["page_num"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "x_coord": xCoord,
    "y_coord": yCoord,
    "page_num": pageNum,
    "_id": id,
  };
}

class ESigner {
  String city;
  String postalCode;
  String stateOrProvince;
  String fetchedName;
  String email;
  String givenName;
  double nameMatchScore;
  String id;
  List<dynamic> cordinates;

  ESigner({
    required this.city,
    required this.postalCode,
    required this.stateOrProvince,
    required this.fetchedName,
    required this.email,
    required this.givenName,
    required this.nameMatchScore,
    required this.id,
    required this.cordinates,
  });

  factory ESigner.fromJson(Map<String, dynamic> json) => ESigner(
    city: json["city"] ?? '',
    postalCode: json["postal_code"] ?? '',
    stateOrProvince: json["state_or_province"] ?? '',
    fetchedName: json["fetched_name"] ?? '',
    email: json["email"] ?? '',
    givenName: json["given_name"] ?? '',
    nameMatchScore: (json["name_match_score"] ?? 0.0 as num).toDouble(),
    id: json["_id"],
    cordinates: List<dynamic>.from(json["cordinates"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "postal_code": postalCode,
    "state_or_province": stateOrProvince,
    "fetched_name": fetchedName,
    "email": email,
    "given_name": givenName,
    "name_match_score": nameMatchScore,
    "_id": id,
    "cordinates": List<dynamic>.from(cordinates.map((x) => x)),
  };
}
