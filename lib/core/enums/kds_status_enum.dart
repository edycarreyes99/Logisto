/// Strongly-typed production lifecycle status for kitchen and bar display orders.
enum KdsStatusEnum {
  /// Order line newly received, waiting for preparation.
  pending(storageKey: 'pending'),

  /// Order is actively being prepared by cook or bartender.
  preparing(storageKey: 'preparing'),

  /// Order is cooked/poured and ready for server pickup.
  ready(storageKey: 'ready'),

  /// Order has been delivered to table/customer.
  served(storageKey: 'served'),

  /// Order line item cancelled.
  cancelled(storageKey: 'cancelled');

  /// Storage key for database persistence.
  final String storageKey;

  const KdsStatusEnum({required this.storageKey});

  /// Resolves [KdsStatusEnum] from [storageKey] with fallback to [pending].
  static KdsStatusEnum fromStorageKey(String? key) {
    return KdsStatusEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => KdsStatusEnum.pending,
    );
  }
}
