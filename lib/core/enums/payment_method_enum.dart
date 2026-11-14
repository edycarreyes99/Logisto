/// Strongly-typed tender and settlement methods for POS transactions.
enum PaymentMethodEnum {
  /// Physical cash currency notes and coins.
  cash(storageKey: 'cash'),

  /// Debit or credit electronic payment card voucher.
  card(storageKey: 'card'),

  /// Transferred directly to customer credit line receivable.
  customerCredit(storageKey: 'customer_credit'),

  /// Direct bank deposit or wire transfer.
  bankTransfer(storageKey: 'bank_transfer'),

  /// Split combination across multiple tender types.
  mixed(storageKey: 'mixed');

  /// Storage key for database persistence.
  final String storageKey;

  const PaymentMethodEnum({required this.storageKey});

  /// Resolves [PaymentMethodEnum] from [storageKey] with fallback to [cash].
  static PaymentMethodEnum fromStorageKey(String? key) {
    return PaymentMethodEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => PaymentMethodEnum.cash,
    );
  }
}
