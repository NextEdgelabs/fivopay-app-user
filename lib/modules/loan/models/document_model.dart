import 'dart:io';

enum DocumentType { pdf, img, other }



class LoanDocumentModel {
  final String documentType;
  final String documentName;
  final String documentUrl;
  final File? file;
  final DocumentStatus? status;
  final DateTime? uploadedAt;
  final DateTime? verifiedAt;
  final String? rejectedReason;

  LoanDocumentModel({
    required this.documentType,
    required this.documentName,
    required this.documentUrl,
    this.file,
    this.status,
    this.uploadedAt,
    this.verifiedAt,
    this.rejectedReason,
  });

  factory LoanDocumentModel.fromJson(Map<String, dynamic> json) => LoanDocumentModel(
        documentType: json["documentType"],
        documentName: json["documentName"],
        documentUrl: json["documentUrl"],
        status: documentStatusFromJson(json["status"]),
        uploadedAt: json["uploadedAt"] == null
            ? null
            : DateTime.parse(json["uploadedAt"]),
        verifiedAt: json["verifiedAt"] == null
            ? null
            : DateTime.parse(json["verifiedAt"]),
        rejectedReason: json["rejectedReason"],
      );

  Map<String, dynamic> toJson() => {
        "documentType": documentType,
        "documentName": documentName,
        "documentUrl": documentUrl,
      };
      // make copy method
      LoanDocumentModel copyWith({
        String? documentType,
        String? documentName,
        String? documentUrl,
        File? file,
        DocumentStatus? status,
        DateTime? uploadedAt,
        DateTime? verifiedAt,
        String? rejectedReason,
      }) {
        return LoanDocumentModel(
          documentType: documentType ?? this.documentType,
          documentName: documentName ?? this.documentName,
          documentUrl: documentUrl ?? this.documentUrl,
          file: file ?? this.file,
          status: status ?? this.status,
          uploadedAt: uploadedAt ?? this.uploadedAt,
          verifiedAt: verifiedAt ?? this.verifiedAt,
          rejectedReason: rejectedReason ?? this.rejectedReason,
        );
      }
}

enum DocumentStatus { pending, approved, rejected }

// Enum helpers
DocumentStatus documentStatusFromJson(String str) =>
    DocumentStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == str.toLowerCase(),
      orElse: () => DocumentStatus.pending,
    );

String documentStatusToJson(DocumentStatus status) => status.name;
