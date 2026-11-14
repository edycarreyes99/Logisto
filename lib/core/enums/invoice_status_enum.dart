/// Strongly-typed settlement status for commercial sales invoices.
enum InvoiceStatusEnum {
  /// Invoice is fully liquidated and paid in full.
  paid(storageKey: 'paid'),

  /// Partial tender received, with remainder carried over to customer credit line.
  partiallyPaidCredit(storageKey: 'partially_paid_credit'),

  /// Invalidate or annulled invoice.
  cancelled(storageKey: 'cancelled');

  /// Storage key for database persistence.
  final String storageKey;

  const InvoiceStatusEnum({required this.storageKey});

  /// Resolves [InvoiceStatusEnum] from [storageKey] with fallback to [paid].
  static InvoiceStatusEnum fromStorageKey(String? key) {
    return InvoiceStatusEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => InvoiceStatusEnum.paid,
    );
  }
}
