class Transaction {
  final String id;
  final String type; // 'deposit', 'withdraw', 'transfer', 'bonus'
  final double amount;
  final String description;
  final DateTime timestamp;
  final String status; // 'pending', 'completed', 'failed'
  final String? referenceNumber;
  final String? fromAccount;
  final String? toAccount;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.status,
    this.referenceNumber,
    this.fromAccount,
    this.toAccount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'referenceNumber': referenceNumber,
      'fromAccount': fromAccount,
      'toAccount': toAccount,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']).toLocal(),
      status: json['status'],
      referenceNumber: json['referenceNumber'],
      fromAccount: json['fromAccount'],
      toAccount: json['toAccount'],
    );
  }
}
