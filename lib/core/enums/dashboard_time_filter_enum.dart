/// Strongly-typed time interval filter for KPI analytics and reporting.
enum DashboardTimeFilterEnum {
  today(storageKey: 'today'),
  week(storageKey: 'week'),
  month(storageKey: 'month');

  final String storageKey;

  const DashboardTimeFilterEnum({required this.storageKey});

  /// Resolves [DashboardTimeFilterEnum] safely from [storageKey] with fallback to [today].
  static DashboardTimeFilterEnum fromStorageKey(String? key) {
    return DashboardTimeFilterEnum.values.firstWhere(
      (e) => e.storageKey == key,
      orElse: () => DashboardTimeFilterEnum.today,
    );
  }
}
