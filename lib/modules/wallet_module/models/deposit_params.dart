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
