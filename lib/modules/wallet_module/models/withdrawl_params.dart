class WithdrawalParams {
  final double amount;
  final String mode;

  // Bank transfer fields
  final String? accountNumber;
  final String? ifsc;
  final String? bankAccountName;

  // UPI transfer fields
  final String? vpa;

  WithdrawalParams({
    required this.amount,
    required this.mode,
    this.accountNumber,
    this.ifsc,
    this.bankAccountName,
    this.vpa,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'amount': amount, 'mode': mode};

    if (mode == 'UPI') {
      if (vpa != null) data['vpa'] = vpa;
    } else {
      if (accountNumber != null) data['accountNumber'] = accountNumber;
      if (ifsc != null) data['ifsc'] = ifsc;
      if (bankAccountName != null) data['bankAccountName'] = bankAccountName;
    }

    return data;
  }
}
