class BankAccount {
  final String id;
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final String ifscCode;
  final String accountType;
  final bool isDefault;
  final DateTime addedAt;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.ifscCode,
    required this.accountType,
    this.isDefault = false,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolderName': accountHolderName,
      'ifscCode': ifscCode,
      'accountType': accountType,
      'isDefault': isDefault,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      accountHolderName: json['accountHolderName'],
      ifscCode: json['ifscCode'],
      accountType: json['accountType'],
      isDefault: json['isDefault'] ?? false,
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  BankAccount copyWith({
    String? id,
    String? bankName,
    String? accountNumber,
    String? accountHolderName,
    String? ifscCode,
    String? accountType,
    bool? isDefault,
    DateTime? addedAt,
  }) {
    return BankAccount(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      ifscCode: ifscCode ?? this.ifscCode,
      accountType: accountType ?? this.accountType,
      isDefault: isDefault ?? this.isDefault,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // Mask account number for display
  String get maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    return '*' * (accountNumber.length - 4) + accountNumber.substring(accountNumber.length - 4);
  }
}