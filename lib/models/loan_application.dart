// class LoanApplication {
//   final String id;
//   final String accountNumber;
//   final String loanType; // personal, business, education, housing
//   final double requestedAmount;
//   final int tenureMonths;
//   final String purpose;
//   final String status; // pending, approved, rejected, disbursed
//   final DateTime applicationDate;
//   final DateTime? approvalDate;
//   final DateTime? disbursementDate;
//   final double? approvedAmount;
//   final double? profitRate; // Annual profit rate
//   final double? monthlyInstallment;
//   final String? rejectionReason;
//   final List<String>? documents; // List of uploaded document URLs
//   final String? notes;

//   // Applicant type - self or relative
//   final String applicantType; // 'self' or 'relative'

//   // Relative details (if applicant is relative)
//   final String? relativeName;
//   final String? relativeRelation; // immediate family only
//   final String? relativePAN;
//   final String? relativeAadhaar;
//   final String? relativePhone;

//   // Verification details
//   final bool isPANVerified;
//   final bool isAadhaarVerified;
//   final String? panVerificationDate;
//   final String? aadhaarVerificationDate;

//   // Address details
//   final String? currentAddress;
//   final String? aadhaarAddress;
//   final bool isCurrentAddressSameAsAadhaar;

//   LoanApplication({
//     required this.id,
//     required this.accountNumber,
//     required this.loanType,
//     required this.requestedAmount,
//     required this.tenureMonths,
//     required this.purpose,
//     required this.status,
//     required this.applicationDate,
//     this.approvalDate,
//     this.disbursementDate,
//     this.approvedAmount,
//     this.profitRate,
//     this.monthlyInstallment,
//     this.rejectionReason,
//     this.documents,
//     this.notes,
//     this.applicantType = 'self',
//     this.relativeName,
//     this.relativeRelation,
//     this.relativePAN,
//     this.relativeAadhaar,
//     this.relativePhone,
//     this.isPANVerified = false,
//     this.isAadhaarVerified = false,
//     this.panVerificationDate,
//     this.aadhaarVerificationDate,
//     this.currentAddress,
//     this.aadhaarAddress,
//     this.isCurrentAddressSameAsAadhaar = true,
//   });

//   factory LoanApplication.fromJson(Map<String, dynamic> json) {
//     return LoanApplication(
//       id: json['id'] ?? '',
//       accountNumber: json['accountNumber'] ?? '',
//       loanType: json['loanType'] ?? '',
//       requestedAmount: (json['requestedAmount'] ?? 0).toDouble(),
//       tenureMonths: json['tenureMonths'] ?? 0,
//       purpose: json['purpose'] ?? '',
//       status: json['status'] ?? 'pending',
//       applicationDate: DateTime.parse(json['applicationDate']),
//       approvalDate: json['approvalDate'] != null
//           ? DateTime.parse(json['approvalDate'])
//           : null,
//       disbursementDate: json['disbursementDate'] != null
//           ? DateTime.parse(json['disbursementDate'])
//           : null,
//       approvedAmount: json['approvedAmount']?.toDouble(),
//       profitRate: json['profitRate']?.toDouble(),
//       monthlyInstallment: json['monthlyInstallment']?.toDouble(),
//       rejectionReason: json['rejectionReason'],
//       documents: json['documents'] != null
//           ? List<String>.from(json['documents'])
//           : null,
//       notes: json['notes'],
//       applicantType: json['applicantType'] ?? 'self',
//       relativeName: json['relativeName'],
//       relativeRelation: json['relativeRelation'],
//       relativePAN: json['relativePAN'],
//       relativeAadhaar: json['relativeAadhaar'],
//       relativePhone: json['relativePhone'],
//       isPANVerified: json['isPANVerified'] ?? false,
//       isAadhaarVerified: json['isAadhaarVerified'] ?? false,
//       panVerificationDate: json['panVerificationDate'],
//       aadhaarVerificationDate: json['aadhaarVerificationDate'],
//       currentAddress: json['currentAddress'],
//       aadhaarAddress: json['aadhaarAddress'],
//       isCurrentAddressSameAsAadhaar:
//           json['isCurrentAddressSameAsAadhaar'] ?? true,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'accountNumber': accountNumber,
//       'loanType': loanType,
//       'requestedAmount': requestedAmount,
//       'tenureMonths': tenureMonths,
//       'purpose': purpose,
//       'status': status,
//       'applicationDate': applicationDate.toIso8601String(),
//       'approvalDate': approvalDate?.toIso8601String(),
//       'disbursementDate': disbursementDate?.toIso8601String(),
//       'approvedAmount': approvedAmount,
//       'profitRate': profitRate,
//       'monthlyInstallment': monthlyInstallment,
//       'rejectionReason': rejectionReason,
//       'documents': documents,
//       'notes': notes,
//       'applicantType': applicantType,
//       'relativeName': relativeName,
//       'relativeRelation': relativeRelation,
//       'relativePAN': relativePAN,
//       'relativeAadhaar': relativeAadhaar,
//       'relativePhone': relativePhone,
//       'isPANVerified': isPANVerified,
//       'isAadhaarVerified': isAadhaarVerified,
//       'panVerificationDate': panVerificationDate,
//       'aadhaarVerificationDate': aadhaarVerificationDate,
//       'currentAddress': currentAddress,
//       'aadhaarAddress': aadhaarAddress,
//       'isCurrentAddressSameAsAadhaar': isCurrentAddressSameAsAadhaar,
//     };
//   }

//   LoanApplication copyWith({
//     String? id,
//     String? accountNumber,
//     String? loanType,
//     double? requestedAmount,
//     int? tenureMonths,
//     String? purpose,
//     String? status,
//     DateTime? applicationDate,
//     DateTime? approvalDate,
//     DateTime? disbursementDate,
//     double? approvedAmount,
//     double? profitRate,
//     double? monthlyInstallment,
//     String? rejectionReason,
//     List<String>? documents,
//     String? notes,
//     String? applicantType,
//     String? relativeName,
//     String? relativeRelation,
//     String? relativePAN,
//     String? relativeAadhaar,
//     String? relativePhone,
//     bool? isPANVerified,
//     bool? isAadhaarVerified,
//     String? panVerificationDate,
//     String? aadhaarVerificationDate,
//     String? currentAddress,
//     String? aadhaarAddress,
//     bool? isCurrentAddressSameAsAadhaar,
//   }) {
//     return LoanApplication(
//       id: id ?? this.id,
//       accountNumber: accountNumber ?? this.accountNumber,
//       loanType: loanType ?? this.loanType,
//       requestedAmount: requestedAmount ?? this.requestedAmount,
//       tenureMonths: tenureMonths ?? this.tenureMonths,
//       purpose: purpose ?? this.purpose,
//       status: status ?? this.status,
//       applicationDate: applicationDate ?? this.applicationDate,
//       approvalDate: approvalDate ?? this.approvalDate,
//       disbursementDate: disbursementDate ?? this.disbursementDate,
//       approvedAmount: approvedAmount ?? this.approvedAmount,
//       profitRate: profitRate ?? this.profitRate,
//       monthlyInstallment: monthlyInstallment ?? this.monthlyInstallment,
//       rejectionReason: rejectionReason ?? this.rejectionReason,
//       documents: documents ?? this.documents,
//       notes: notes ?? this.notes,
//       applicantType: applicantType ?? this.applicantType,
//       relativeName: relativeName ?? this.relativeName,
//       relativeRelation: relativeRelation ?? this.relativeRelation,
//       relativePAN: relativePAN ?? this.relativePAN,
//       relativeAadhaar: relativeAadhaar ?? this.relativeAadhaar,
//       relativePhone: relativePhone ?? this.relativePhone,
//       isPANVerified: isPANVerified ?? this.isPANVerified,
//       isAadhaarVerified: isAadhaarVerified ?? this.isAadhaarVerified,
//       panVerificationDate: panVerificationDate ?? this.panVerificationDate,
//       aadhaarVerificationDate:
//           aadhaarVerificationDate ?? this.aadhaarVerificationDate,
//       currentAddress: currentAddress ?? this.currentAddress,
//       aadhaarAddress: aadhaarAddress ?? this.aadhaarAddress,
//       isCurrentAddressSameAsAadhaar:
//           isCurrentAddressSameAsAadhaar ?? this.isCurrentAddressSameAsAadhaar,
//     );
//   }
// }
