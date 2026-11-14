/// Strongly-typed classification for physical warehouse inventory kardex movements.
enum MovementTypeEnum {
  /// Inbound receipt of goods from supplier purchase order.
  purchaseReceipt(storageKey: 'purchase_receipt'),

  /// Automatic deduction triggered by confirmed sales invoice.
  salesDeduction(storageKey: 'sales_deduction'),

  /// Inter-warehouse transfer (e.g. Central to Bar).
  internalTransfer(storageKey: 'internal_transfer'),

  /// Shrinkage, breakage, expiration, or waste adjustment.
  wasteAdjustment(storageKey: 'waste_adjustment'),

  /// Initial inventory physical count reconciliation.
  initialCount(storageKey: 'initial_count');

  /// Storage key for database persistence.
  final String storageKey;

  const MovementTypeEnum({required this.storageKey});

  /// Resolves [MovementTypeEnum] from [storageKey] with fallback to [salesDeduction].
  static MovementTypeEnum fromStorageKey(String? key) {
    return MovementTypeEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => MovementTypeEnum.salesDeduction,
    );
  }
}
