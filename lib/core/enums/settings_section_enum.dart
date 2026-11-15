/// Strongly-typed sections for enterprise configuration and settings.
enum SettingsSectionEnum {
  organization(storageKey: 'org'),
  appearance(storageKey: 'appearance'),
  rbac(storageKey: 'rbac'),
  printers(storageKey: 'printers');

  final String storageKey;

  const SettingsSectionEnum({required this.storageKey});

  /// Resolves [SettingsSectionEnum] safely from [storageKey] with fallback to [organization].
  static SettingsSectionEnum fromStorageKey(String? key) {
    return SettingsSectionEnum.values.firstWhere(
      (e) => e.storageKey == key,
      orElse: () => SettingsSectionEnum.organization,
    );
  }
}
