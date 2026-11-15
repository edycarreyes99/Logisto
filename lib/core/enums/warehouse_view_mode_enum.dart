/// Strongly-typed view perspective for warehouse management (stock inventory vs movement kardex).
enum WarehouseViewModeEnum {
  stock(storageKey: 'stock'),
  kardex(storageKey: 'kardex');

  final String storageKey;

  const WarehouseViewModeEnum({required this.storageKey});

  /// Resolves [WarehouseViewModeEnum] safely from [storageKey] with fallback to [stock].
  static WarehouseViewModeEnum fromStorageKey(String? key) {
    return WarehouseViewModeEnum.values.firstWhere(
      (e) => e.storageKey == key,
      orElse: () => WarehouseViewModeEnum.stock,
    );
  }
}
