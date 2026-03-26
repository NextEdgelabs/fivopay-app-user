class RazorpayOrder {
  final int amount;
  final int amountDue;
  final int amountPaid;
  final int attempts;
  final int createdAt;
  final String currency;
  final String entity;
  final String id;
  final RazorpayOrderNotes notes;
  final String? offerId;
  final String receipt;
  final String status;
  final String? razorpayKeyId;

  RazorpayOrder({
    required this.amount,
    required this.amountDue,
    required this.amountPaid,
    required this.attempts,
    required this.createdAt,
    required this.currency,
    required this.entity,
    required this.id,
    required this.notes,
    this.offerId,
    required this.receipt,
    required this.status,
    this.razorpayKeyId,
  });

  factory RazorpayOrder.fromJson(
    Map<String, dynamic> json, {
    String? razorpayKeyId,
  }) {
    return RazorpayOrder(
      amount: json['amount'] ?? 0,
      amountDue: json['amount_due'] ?? 0,
      amountPaid: json['amount_paid'] ?? 0,
      attempts: json['attempts'] ?? 0,
      createdAt: json['created_at'] ?? 0,
      currency: json['currency'] ?? 'INR',
      entity: json['entity'] ?? 'order',
      id: json['id'] ?? '',
      notes: RazorpayOrderNotes.fromJson(json['notes'] ?? {}),
      offerId: json['offer_id'],
      receipt: json['receipt'] ?? '',
      status: json['status'] ?? 'created',
      razorpayKeyId: json['razorpay_key_id'] ?? razorpayKeyId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'amount_due': amountDue,
      'amount_paid': amountPaid,
      'attempts': attempts,
      'created_at': createdAt,
      'currency': currency,
      'entity': entity,
      'id': id,
      'notes': notes.toJson(),
      'offer_id': offerId,
      'receipt': receipt,
      'status': status,
    };
  }

  // Helper methods
  double get amountInRupees => amount / 100.0;
  double get amountDueInRupees => amountDue / 100.0;
  double get amountPaidInRupees => amountPaid / 100.0;

  DateTime get createdAtDateTime =>
      DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);

  bool get isCreated => status.toLowerCase() == 'created';
  bool get isPaid => status.toLowerCase() == 'paid';
  bool get isAttempted => attempts > 0;

  @override
  String toString() {
    return 'RazorpayOrder(id: $id, amount: ₹${amountInRupees.toStringAsFixed(2)}, status: $status)';
  }
}

class RazorpayOrderNotes {
  final String memberId;
  final String orderId;

  RazorpayOrderNotes({required this.memberId, required this.orderId});

  factory RazorpayOrderNotes.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderNotes(
      memberId: json['member_id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'member_id': memberId, 'order_id': orderId};
  }

  @override
  String toString() {
    return 'RazorpayOrderNotes(memberId: $memberId, orderId: $orderId)';
  }
}
