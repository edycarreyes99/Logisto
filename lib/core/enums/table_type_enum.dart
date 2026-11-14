/// Strongly-typed billiard table game discipline or tier.
enum TableTypeEnum {
  /// Standard pocket pool table.
  pool(storageKey: 'pool'),

  /// Carambola (3-cushion / pocketless) table.
  carambola(storageKey: 'carambola'),

  /// Snooker regulation table.
  snooker(storageKey: 'snooker'),

  /// VIP exclusive private salon station.
  vip(storageKey: 'vip');

  /// Storage key for database persistence.
  final String storageKey;

  const TableTypeEnum({required this.storageKey});

  /// Resolves [TableTypeEnum] from [storageKey] with fallback to [pool].
  static TableTypeEnum fromStorageKey(String? key) {
    return TableTypeEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => TableTypeEnum.pool,
    );
  }
}
