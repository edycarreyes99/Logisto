/// Strongly-typed lifecycle status of a commercial purchase order.
enum PurchaseOrderStatusEnum {
  draft(storageKey: 'draft'),
  ordered(storageKey: 'ordered'),
  received(storageKey: 'received'),
  cancelled(storageKey: 'cancelled');

  final String storageKey;

  const PurchaseOrderStatusEnum({required this.storageKey});

  /// Resolves [PurchaseOrderStatusEnum] safely from [storageKey] with fallback to [draft].
  static PurchaseOrderStatusEnum fromStorageKey(String? key) {
    return PurchaseOrderStatusEnum.values.firstWhere(
      (e) => e.storageKey == key,
      orElse: () => PurchaseOrderStatusEnum.draft,
    );
  }
}
