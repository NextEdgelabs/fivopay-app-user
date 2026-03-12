// Payment Method Enum
enum PaymentMethod {
  razorpay,
  bankTransfer,
  upi,
  card,
  wallet,
  agentPickup,
  branchDeposit;

  String get value {
    switch (this) {
      case PaymentMethod.razorpay:
        return 'razorpay';
      case PaymentMethod.bankTransfer:
        return 'bank_transfer';
      case PaymentMethod.upi:
        return 'upi';
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.wallet:
        return 'wallet';
      case PaymentMethod.agentPickup:
        return 'agent_pickup';
      case PaymentMethod.branchDeposit:
        return 'branch_deposit';
    }
  }

  static PaymentMethod fromString(String method) {
    switch (method) {
      case 'razorpay':
        return PaymentMethod.razorpay;
      case 'bank_transfer':
        return PaymentMethod.bankTransfer;
      case 'upi':
        return PaymentMethod.upi;
      case 'card':
        return PaymentMethod.card;
      case 'wallet':
        return PaymentMethod.wallet;
      case 'agent_pickup':
        return PaymentMethod.agentPickup;
      case 'branch_deposit':
        return PaymentMethod.branchDeposit;
      default:
        return PaymentMethod.bankTransfer;
    }
  }

  String get displayName {
    switch (this) {
      case PaymentMethod.razorpay:
        return 'Razorpay';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.wallet:
        return 'Wallet';
      case PaymentMethod.agentPickup:
        return 'Agent Pickup';
      case PaymentMethod.branchDeposit:
        return 'Branch Deposit';
    }
  }
}

// Deposit Account Status Enum
enum DepositStatus {
  active,
  matured,
  closed,
  prematureClosed,
  suspended;

  String get value {
    switch (this) {
      case DepositStatus.active:
        return 'active';
      case DepositStatus.matured:
        return 'matured';
      case DepositStatus.closed:
        return 'closed';
      case DepositStatus.prematureClosed:
        return 'premature_closed';
      case DepositStatus.suspended:
        return 'suspended';
    }
  }

  static DepositStatus fromString(String status) {
    switch (status) {
      case 'active':
        return DepositStatus.active;
      case 'matured':
        return DepositStatus.matured;
      case 'closed':
        return DepositStatus.closed;
      case 'premature_closed':
        return DepositStatus.prematureClosed;
      case 'suspended':
        return DepositStatus.suspended;
      default:
        return DepositStatus.active;
    }
  }

  String get displayName {
    switch (this) {
      case DepositStatus.active:
        return 'Active';
      case DepositStatus.matured:
        return 'Matured';
      case DepositStatus.closed:
        return 'Closed';
      case DepositStatus.prematureClosed:
        return 'Premature Closed';
      case DepositStatus.suspended:
        return 'Suspended';
    }
  }
}

// Interest Payout Frequency Enum
enum InterestPayoutFrequency {
  monthly,
  quarterly,
  halfYearly,
  yearly,
  onMaturity;

  String get value {
    switch (this) {
      case InterestPayoutFrequency.monthly:
        return 'monthly';
      case InterestPayoutFrequency.quarterly:
        return 'quarterly';
      case InterestPayoutFrequency.halfYearly:
        return 'half_yearly';
      case InterestPayoutFrequency.yearly:
        return 'yearly';
      case InterestPayoutFrequency.onMaturity:
        return 'on_maturity';
    }
  }

  static InterestPayoutFrequency fromString(String frequency) {
    switch (frequency) {
      case 'monthly':
        return InterestPayoutFrequency.monthly;
      case 'quarterly':
        return InterestPayoutFrequency.quarterly;
      case 'half_yearly':
        return InterestPayoutFrequency.halfYearly;
      case 'yearly':
        return InterestPayoutFrequency.yearly;
      case 'on_maturity':
        return InterestPayoutFrequency.onMaturity;
      default:
        return InterestPayoutFrequency.onMaturity;
    }
  }

  String get displayName {
    switch (this) {
      case InterestPayoutFrequency.monthly:
        return 'Monthly';
      case InterestPayoutFrequency.quarterly:
        return 'Quarterly';
      case InterestPayoutFrequency.halfYearly:
        return 'Half-Yearly';
      case InterestPayoutFrequency.yearly:
        return 'Yearly';
      case InterestPayoutFrequency.onMaturity:
        return 'On Maturity';
    }
  }
}

// Maturity Action Enum
enum MaturityAction {
  autoRenew,
  creditToAccount,
  manualInstruction;

  String get value {
    switch (this) {
      case MaturityAction.autoRenew:
        return 'auto_renew';
      case MaturityAction.creditToAccount:
        return 'credit_to_account';
      case MaturityAction.manualInstruction:
        return 'manual_instruction';
    }
  }

  static MaturityAction fromString(String action) {
    switch (action) {
      case 'auto_renew':
        return MaturityAction.autoRenew;
      case 'credit_to_account':
        return MaturityAction.creditToAccount;
      case 'manual_instruction':
        return MaturityAction.manualInstruction;
      default:
        return MaturityAction.creditToAccount;
    }
  }

  String get displayName {
    switch (this) {
      case MaturityAction.autoRenew:
        return 'Auto Renew';
      case MaturityAction.creditToAccount:
        return 'Credit to Account';
      case MaturityAction.manualInstruction:
        return 'Manual Instruction';
    }
  }
}

// Deposit Tenure Period Enum
enum DepositTenure {
  threeMonths,
  sixMonths,
  nineMonths,
  oneYear,
  eighteenMonths,
  twoYears,
  threeYears,
  fiveYears,
  tenYears;

  int get months {
    switch (this) {
      case DepositTenure.threeMonths:
        return 3;
      case DepositTenure.sixMonths:
        return 6;
      case DepositTenure.nineMonths:
        return 9;
      case DepositTenure.oneYear:
        return 12;
      case DepositTenure.eighteenMonths:
        return 18;
      case DepositTenure.twoYears:
        return 24;
      case DepositTenure.threeYears:
        return 36;
      case DepositTenure.fiveYears:
        return 60;
      case DepositTenure.tenYears:
        return 120;
    }
  }

  String get value {
    switch (this) {
      case DepositTenure.threeMonths:
        return '3_months';
      case DepositTenure.sixMonths:
        return '6_months';
      case DepositTenure.nineMonths:
        return '9_months';
      case DepositTenure.oneYear:
        return '1_year';
      case DepositTenure.eighteenMonths:
        return '18_months';
      case DepositTenure.twoYears:
        return '2_years';
      case DepositTenure.threeYears:
        return '3_years';
      case DepositTenure.fiveYears:
        return '5_years';
      case DepositTenure.tenYears:
        return '10_years';
    }
  }

  static DepositTenure fromMonths(int months) {
    switch (months) {
      case 3:
        return DepositTenure.threeMonths;
      case 6:
        return DepositTenure.sixMonths;
      case 9:
        return DepositTenure.nineMonths;
      case 12:
        return DepositTenure.oneYear;
      case 18:
        return DepositTenure.eighteenMonths;
      case 24:
        return DepositTenure.twoYears;
      case 36:
        return DepositTenure.threeYears;
      case 60:
        return DepositTenure.fiveYears;
      case 120:
        return DepositTenure.tenYears;
      default:
        return DepositTenure.oneYear;
    }
  }

  String get displayName {
    switch (this) {
      case DepositTenure.threeMonths:
        return '3 Months';
      case DepositTenure.sixMonths:
        return '6 Months';
      case DepositTenure.nineMonths:
        return '9 Months';
      case DepositTenure.oneYear:
        return '1 Year';
      case DepositTenure.eighteenMonths:
        return '18 Months';
      case DepositTenure.twoYears:
        return '2 Years';
      case DepositTenure.threeYears:
        return '3 Years';
      case DepositTenure.fiveYears:
        return '5 Years';
      case DepositTenure.tenYears:
        return '10 Years';
    }
  }
}

// Nominee Relationship Enum
enum NomineeRelation {
  spouse,
  father,
  mother,
  son,
  daughter,
  brother,
  sister,
  other;

  String get value {
    switch (this) {
      case NomineeRelation.spouse:
        return 'spouse';
      case NomineeRelation.father:
        return 'father';
      case NomineeRelation.mother:
        return 'mother';
      case NomineeRelation.son:
        return 'son';
      case NomineeRelation.daughter:
        return 'daughter';
      case NomineeRelation.brother:
        return 'brother';
      case NomineeRelation.sister:
        return 'sister';
      case NomineeRelation.other:
        return 'other';
    }
  }

  static NomineeRelation fromString(String relation) {
    switch (relation) {
      case 'spouse':
        return NomineeRelation.spouse;
      case 'father':
        return NomineeRelation.father;
      case 'mother':
        return NomineeRelation.mother;
      case 'son':
        return NomineeRelation.son;
      case 'daughter':
        return NomineeRelation.daughter;
      case 'brother':
        return NomineeRelation.brother;
      case 'sister':
        return NomineeRelation.sister;
      case 'other':
        return NomineeRelation.other;
      default:
        return NomineeRelation.other;
    }
  }

  String get displayName {
    switch (this) {
      case NomineeRelation.spouse:
        return 'Spouse';
      case NomineeRelation.father:
        return 'Father';
      case NomineeRelation.mother:
        return 'Mother';
      case NomineeRelation.son:
        return 'Son';
      case NomineeRelation.daughter:
        return 'Daughter';
      case NomineeRelation.brother:
        return 'Brother';
      case NomineeRelation.sister:
        return 'Sister';
      case NomineeRelation.other:
        return 'Other';
    }
  }
}

// Transaction Type for Deposits
enum DepositTransactionType {
  opening,
  installment,
  interestCredit,
  withdrawal,
  closure,
  prematureClosure;

  String get value {
    switch (this) {
      case DepositTransactionType.opening:
        return 'opening';
      case DepositTransactionType.installment:
        return 'installment';
      case DepositTransactionType.interestCredit:
        return 'interest_credit';
      case DepositTransactionType.withdrawal:
        return 'withdrawal';
      case DepositTransactionType.closure:
        return 'closure';
      case DepositTransactionType.prematureClosure:
        return 'premature_closure';
    }
  }

  static DepositTransactionType fromString(String type) {
    switch (type) {
      case 'opening':
        return DepositTransactionType.opening;
      case 'installment':
        return DepositTransactionType.installment;
      case 'interest_credit':
        return DepositTransactionType.interestCredit;
      case 'withdrawal':
        return DepositTransactionType.withdrawal;
      case 'closure':
        return DepositTransactionType.closure;
      case 'premature_closure':
        return DepositTransactionType.prematureClosure;
      default:
        return DepositTransactionType.opening;
    }
  }

  String get displayName {
    switch (this) {
      case DepositTransactionType.opening:
        return 'Opening';
      case DepositTransactionType.installment:
        return 'Installment';
      case DepositTransactionType.interestCredit:
        return 'Interest Credit';
      case DepositTransactionType.withdrawal:
        return 'Withdrawal';
      case DepositTransactionType.closure:
        return 'Closure';
      case DepositTransactionType.prematureClosure:
        return 'Premature Closure';
    }
  }
}
