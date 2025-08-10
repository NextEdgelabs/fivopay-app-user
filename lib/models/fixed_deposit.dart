class FixedDeposit {
  final String id;
  final String accountNumber;
  final double amount;
  final int tenureMonths;
  final double profitRate; // Annual profit rate
  final DateTime startDate;
  final DateTime maturityDate;
  final String status; // active, matured, withdrawn
  final double expectedProfit;
  final double totalAmount; // amount + profit
  final String? notes;
  final String depositMethod; // cash_collection, online, branch
  final String? collectionAddress; // For cash collection
  final DateTime? collectionDate; // For cash collection
  final String? branchName; // For branch deposit
  final String? transactionId; // For online deposit

  FixedDeposit({
    required this.id,
    required this.accountNumber,
    required this.amount,
    required this.tenureMonths,
    required this.profitRate,
    required this.startDate,
    required this.maturityDate,
    required this.status,
    required this.expectedProfit,
    required this.totalAmount,
    this.notes,
    required this.depositMethod,
    this.collectionAddress,
    this.collectionDate,
    this.branchName,
    this.transactionId,
  });

  factory FixedDeposit.fromJson(Map<String, dynamic> json) {
    return FixedDeposit(
      id: json['id'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      tenureMonths: json['tenureMonths'] ?? 0,
      profitRate: (json['profitRate'] ?? 0).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      maturityDate: DateTime.parse(json['maturityDate']),
      status: json['status'] ?? 'active',
      expectedProfit: (json['expectedProfit'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      notes: json['notes'],
      depositMethod: json['depositMethod'] ?? 'online',
      collectionAddress: json['collectionAddress'],
      collectionDate: json['collectionDate'] != null 
          ? DateTime.parse(json['collectionDate']) 
          : null,
      branchName: json['branchName'],
      transactionId: json['transactionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNumber': accountNumber,
      'amount': amount,
      'tenureMonths': tenureMonths,
      'profitRate': profitRate,
      'startDate': startDate.toIso8601String(),
      'maturityDate': maturityDate.toIso8601String(),
      'status': status,
      'expectedProfit': expectedProfit,
      'totalAmount': totalAmount,
      'notes': notes,
      'depositMethod': depositMethod,
      'collectionAddress': collectionAddress,
      'collectionDate': collectionDate?.toIso8601String(),
      'branchName': branchName,
      'transactionId': transactionId,
    };
  }

  FixedDeposit copyWith({
    String? id,
    String? accountNumber,
    double? amount,
    int? tenureMonths,
    double? profitRate,
    DateTime? startDate,
    DateTime? maturityDate,
    String? status,
    double? expectedProfit,
    double? totalAmount,
    String? notes,
    String? depositMethod,
    String? collectionAddress,
    DateTime? collectionDate,
    String? branchName,
    String? transactionId,
  }) {
    return FixedDeposit(
      id: id ?? this.id,
      accountNumber: accountNumber ?? this.accountNumber,
      amount: amount ?? this.amount,
      tenureMonths: tenureMonths ?? this.tenureMonths,
      profitRate: profitRate ?? this.profitRate,
      startDate: startDate ?? this.startDate,
      maturityDate: maturityDate ?? this.maturityDate,
      status: status ?? this.status,
      expectedProfit: expectedProfit ?? this.expectedProfit,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
      depositMethod: depositMethod ?? this.depositMethod,
      collectionAddress: collectionAddress ?? this.collectionAddress,
      collectionDate: collectionDate ?? this.collectionDate,
      branchName: branchName ?? this.branchName,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}
