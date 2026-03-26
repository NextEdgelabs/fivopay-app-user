//create params
class DepositParams {
  final double amount;
  final String description;
  DepositParams({required this.amount, required this.description});
  Map<String, dynamic> toJson() => {
    'amount': amount,
    'description': description,
  };

}

class SharePurchaseParams {
  final String customerId;
  final String? agentId;
  final String transactionType;
  final int quantity;
  final int pricePerShare;
  final String? notes;
  // final String? photoproofUrl;
  final String transactionReference;

  SharePurchaseParams({
    required this.customerId,
    this.agentId,
    this.transactionType = "purchase",
    required this.quantity,
    required this.pricePerShare,
    this.notes,
    // this.photoproofUrl,
     this.transactionReference = "internal",
  });
  Map<String, dynamic> toJson() => {
    'customerId': customerId,
    'agentId': agentId,
    'transactionType': transactionType,
    'quantity': quantity,
    'pricePerShare': pricePerShare,
    'notes': notes,
    // 'photoproofUrl': photoproofUrl,
    'transactionReference': transactionReference,
  };
}