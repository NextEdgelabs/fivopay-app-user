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
  final String id;
  final String shareId;
  final int quantity;
  final double pricePerShare;
  final double totalAmount;
  final DateTime purchaseDate;
  final String status; // 'pending', 'completed', 'failed'

  SharePurchase({
    required this.id,
    required this.shareId,
    required this.quantity,
    required this.pricePerShare,
    required this.totalAmount,
    required this.purchaseDate,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shareId': shareId,
      'quantity': quantity,
      'pricePerShare': pricePerShare,
      'totalAmount': totalAmount,
      'purchaseDate': purchaseDate.toIso8601String(),
      'status': status,
    };
  }

  factory SharePurchase.fromJson(Map<String, dynamic> json) {
    return SharePurchase(
      id: json['id'],
      shareId: json['shareId'],
      quantity: json['quantity'],
      pricePerShare: json['pricePerShare'].toDouble(),
      totalAmount: json['totalAmount'].toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate']),
      status: json['status'],
    );
  }
}
