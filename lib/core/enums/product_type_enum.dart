/// Strongly-typed inventory product categorization and composition model.
enum ProductTypeEnum {
  /// Standard stocked unit bought and resold directly.
  standard(storageKey: 'standard'),

  /// Pre-packaged bundle/pack composed of multiple standard items.
  pack(storageKey: 'pack'),

  /// Kitchen or bar recipe created from raw insumos (Bill of Materials).
  recipeBom(storageKey: 'recipe_bom'),

  /// Intangible service item (e.g. table rental fee).
  service(storageKey: 'service');

  /// Storage key for database persistence.
  final String storageKey;

  const ProductTypeEnum({required this.storageKey});

  /// Resolves [ProductTypeEnum] from [storageKey] with fallback to [standard].
  static ProductTypeEnum fromStorageKey(String? key) {
    return ProductTypeEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => ProductTypeEnum.standard,
    );
  }
}
