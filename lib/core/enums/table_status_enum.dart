/// Strongly-typed operational status for billiard rental stations.
enum TableStatusEnum {
  /// Table is free and ready for rental.
  available(storageKey: 'available'),

  /// Table is actively occupied with ongoing timer.
  occupied(storageKey: 'occupied'),

  /// Game timer is temporarily paused.
  paused(storageKey: 'paused'),

  /// Game has stopped and is transferred to billing or payment checkout.
  billing(storageKey: 'billing');

  /// Storage key for database persistence.
  final String storageKey;

  const TableStatusEnum({required this.storageKey});

  /// Resolves [TableStatusEnum] from [storageKey] with fallback to [available].
  static TableStatusEnum fromStorageKey(String? key) {
    return TableStatusEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => TableStatusEnum.available,
    );
  }
}
