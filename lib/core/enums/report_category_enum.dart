/// Strongly-typed business intelligence report categories for analytical consolidation.
enum ReportCategoryEnum {
  sales(storageKey: 'sales'),
  inventory(storageKey: 'inventory'),
  cash(storageKey: 'cash'),
  credit(storageKey: 'credit'),
  billiards(storageKey: 'billiards');

  final String storageKey;

  const ReportCategoryEnum({required this.storageKey});

  /// Resolves [ReportCategoryEnum] safely from [storageKey] with fallback to [sales].
  static ReportCategoryEnum fromStorageKey(String? key) {
    return ReportCategoryEnum.values.firstWhere(
      (e) => e.storageKey == key,
      orElse: () => ReportCategoryEnum.sales,
    );
  }
}
