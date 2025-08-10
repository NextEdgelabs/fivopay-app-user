import 'fixed_deposit.dart';
import 'loan_application.dart';

class User {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? nomineeName;
  final String? nomineeRelation;
  final String? nomineePhone;
  final String? accountNumber;
  final double? balance;
  final String? memberSince;
  final String? referralCode;
  final String? referredBy;
  final List<String>? referredUsers;
  final bool isMember;
  final bool isActive;

  // KYC Fields
  final String? kycStatus; // pending, in_progress, completed, rejected
  final String? kycType; // digital, video
  final String? panNumber;
  final String? aadharNumber;
  final String? kycDocuments; // JSON string of uploaded documents
  final DateTime? kycCompletedAt;

  // Ethical Banking Fields
  final List<FixedDeposit>? fixedDeposits;
  final List<LoanApplication>? loanApplications;
  final double? totalDeposits;
  final double? totalLoans;

  User({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.nomineeName,
    this.nomineeRelation,
    this.nomineePhone,
    this.accountNumber,
    this.balance,
    this.memberSince,
    this.referralCode,
    this.referredBy,
    this.referredUsers,
    this.isMember = false,
    this.isActive = true,
    this.kycStatus,
    this.kycType,
    this.panNumber,
    this.aadharNumber,
    this.kycDocuments,
    this.kycCompletedAt,
    this.fixedDeposits,
    this.loanApplications,
    this.totalDeposits,
    this.totalLoans,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      name: json['name'],
      email: json['email'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      nomineeName: json['nomineeName'],
      nomineeRelation: json['nomineeRelation'],
      nomineePhone: json['nomineePhone'],
      accountNumber: json['accountNumber'],
      balance: json['balance']?.toDouble(),
      memberSince: json['memberSince'],
      referralCode: json['referralCode'],
      referredBy: json['referredBy'],
      referredUsers: json['referredUsers'] != null
          ? List<String>.from(json['referredUsers'])
          : null,
      isMember: json['isMember'] ?? false,
      isActive: json['isActive'] ?? true,
      kycStatus: json['kycStatus'],
      kycType: json['kycType'],
      panNumber: json['panNumber'],
      aadharNumber: json['aadharNumber'],
      kycDocuments: json['kycDocuments'],
      kycCompletedAt: json['kycCompletedAt'] != null
          ? DateTime.parse(json['kycCompletedAt'])
          : null,
      fixedDeposits: json['fixedDeposits'] != null
          ? (json['fixedDeposits'] as List)
                .map((fd) => FixedDeposit.fromJson(fd))
                .toList()
          : null,
      loanApplications: json['loanApplications'] != null
          ? (json['loanApplications'] as List)
                .map((la) => LoanApplication.fromJson(la))
                .toList()
          : null,
      totalDeposits: json['totalDeposits']?.toDouble(),
      totalLoans: json['totalLoans']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'nomineeName': nomineeName,
      'nomineeRelation': nomineeRelation,
      'nomineePhone': nomineePhone,
      'accountNumber': accountNumber,
      'balance': balance,
      'memberSince': memberSince,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'referredUsers': referredUsers,
      'isMember': isMember,
      'isActive': isActive,
      'kycStatus': kycStatus,
      'kycType': kycType,
      'panNumber': panNumber,
      'aadharNumber': aadharNumber,
      'kycDocuments': kycDocuments,
      'kycCompletedAt': kycCompletedAt?.toIso8601String(),
      'fixedDeposits': fixedDeposits?.map((fd) => fd.toJson()).toList(),
      'loanApplications': loanApplications?.map((la) => la.toJson()).toList(),
      'totalDeposits': totalDeposits,
      'totalLoans': totalLoans,
    };
  }

  User copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? email,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? pincode,
    String? nomineeName,
    String? nomineeRelation,
    String? nomineePhone,
    String? accountNumber,
    double? balance,
    String? memberSince,
    String? referralCode,
    String? referredBy,
    List<String>? referredUsers,
    bool? isMember,
    bool? isActive,
    String? kycStatus,
    String? kycType,
    String? panNumber,
    String? aadharNumber,
    String? kycDocuments,
    DateTime? kycCompletedAt,
    List<FixedDeposit>? fixedDeposits,
    List<LoanApplication>? loanApplications,
    double? totalDeposits,
    double? totalLoans,
  }) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      nomineeName: nomineeName ?? this.nomineeName,
      nomineeRelation: nomineeRelation ?? this.nomineeRelation,
      nomineePhone: nomineePhone ?? this.nomineePhone,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      memberSince: memberSince ?? this.memberSince,
      referralCode: referralCode ?? this.referralCode,
      referredBy: referredBy ?? this.referredBy,
      referredUsers: referredUsers ?? this.referredUsers,
      isMember: isMember ?? this.isMember,
      isActive: isActive ?? this.isActive,
      kycStatus: kycStatus ?? this.kycStatus,
      kycType: kycType ?? this.kycType,
      panNumber: panNumber ?? this.panNumber,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      kycDocuments: kycDocuments ?? this.kycDocuments,
      kycCompletedAt: kycCompletedAt ?? this.kycCompletedAt,
      fixedDeposits: fixedDeposits ?? this.fixedDeposits,
      loanApplications: loanApplications ?? this.loanApplications,
      totalDeposits: totalDeposits ?? this.totalDeposits,
      totalLoans: totalLoans ?? this.totalLoans,
    );
  }
}
