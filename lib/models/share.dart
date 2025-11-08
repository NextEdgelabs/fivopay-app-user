class Share {
  final String id;
  final String name;
  final double pricePerShare;
  final String description;
  final DateTime lastUpdated;

  Share({
    required this.id,
    required this.name,
    required this.pricePerShare,
    required this.description,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pricePerShare': pricePerShare,
      'description': description,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory Share.fromJson(Map<String, dynamic> json) {
    return Share(
      id: json['id'],
      name: json['name'],
      pricePerShare: json['pricePerShare'].toDouble(),
      description: json['description'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}


class SharePurchase {
    final String? id;
    final String? customerId;
    final String? agentId;
    final String? transactionType;
    final int? quantity;
    final double? pricePerShare;
    final double? totalAmount;
    final String? status;
    final String? razorpayOrderId;
    final String? paymentMethod;
    final String? paymentStatus;
    final String? transactionId;
    final bool? isDeleted;
    final bool? isActive;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;
    final DateTime? completedAt;
    final String? razorpayPaymentId;

    SharePurchase({
        required this.id,
        required this.customerId,
        this.agentId,
         this.transactionType = "sharePurchase",
        this.quantity,
        this.pricePerShare,
        this.totalAmount,
        required this.status,
        this.razorpayOrderId,
        this.paymentMethod,
        this.paymentStatus,
        this.transactionId,
        this.isDeleted,
        this.isActive,
        required  this.createdAt,
         required this.updatedAt,
        this.v,
        this.completedAt,
        this.razorpayPaymentId,
    });

    SharePurchase copyWith({
        String? id,
        String? customerId,
        String? agentId,
        String? transactionType,
        int? quantity,
        double? pricePerShare,
        double? totalAmount,
        String? status,
        String? razorpayOrderId,
        String? paymentMethod,
        String? paymentStatus,
        String? transactionId,
        bool? isDeleted,
        bool? isActive,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? v,
        DateTime? completedAt,
        String? razorpayPaymentId,
    }) => 
        SharePurchase(
            id: id ?? this.id,
            customerId: customerId ?? this.customerId,
            agentId: agentId ?? this.agentId,
            transactionType: transactionType ?? this.transactionType,
            quantity: quantity ?? this.quantity,
            pricePerShare: pricePerShare ?? this.pricePerShare,
            totalAmount: totalAmount ?? this.totalAmount,
            status: status ?? this.status,
            razorpayOrderId: razorpayOrderId ?? this.razorpayOrderId,
            paymentMethod: paymentMethod ?? this.paymentMethod,
            paymentStatus: paymentStatus ?? this.paymentStatus,
            transactionId: transactionId ?? this.transactionId,
            isDeleted: isDeleted ?? this.isDeleted,
            isActive: isActive ?? this.isActive,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            v: v ?? this.v,
            completedAt: completedAt ?? this.completedAt,
            razorpayPaymentId: razorpayPaymentId ?? this.razorpayPaymentId,
        );

    factory SharePurchase.fromJson(Map<String, dynamic> json) => SharePurchase(
        id: json["_id"],
        customerId: json["customerId"],
        agentId: json["agentId"],
        transactionType: json["transactionType"],
        quantity: json["quantity"],
        pricePerShare:( json["pricePerShare"] as num).toDouble(),
        totalAmount: (json["totalAmount"] as num).toDouble(),
        status: json["status"],
        razorpayOrderId: json["razorpayOrderId"],
        paymentMethod: json["paymentMethod"],
        paymentStatus: json["paymentStatus"],
        transactionId: json["transactionId"],
        isDeleted: json["isDeleted"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null ? DateTime.now() : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? DateTime.now() : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        completedAt: json["completedAt"] == null ? null : DateTime.parse(json["completedAt"]),
        razorpayPaymentId: json["razorpayPaymentId"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "customerId": customerId,
        "agentId": agentId,
        "transactionType": transactionType,
        "quantity": quantity,
        "pricePerShare": pricePerShare,
        "totalAmount": totalAmount,
        "status": status,
        "razorpayOrderId": razorpayOrderId,
        "paymentMethod": paymentMethod,
        "paymentStatus": paymentStatus,
        "transactionId": transactionId,
        "isDeleted": isDeleted,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "completedAt": completedAt?.toIso8601String(),
        "razorpayPaymentId": razorpayPaymentId,
    };
}
