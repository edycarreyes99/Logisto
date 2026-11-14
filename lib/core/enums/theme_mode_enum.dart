/// Strongly-typed theme modes for user interface presentation.
enum ThemeModeEnum {
  /// Light mode with Bootstrap light palette.
  light(storageKey: 'light'),

  /// Dark mode with Bootstrap dark palette.
  dark(storageKey: 'dark'),

  /// Follows host operating system system brightness setting.
  system(storageKey: 'system');

  /// Storage key for database persistence.
  final String storageKey;

  const ThemeModeEnum({required this.storageKey});

  /// Resolves [ThemeModeEnum] from [storageKey] with fallback to [light] (blanco).
  static ThemeModeEnum fromStorageKey(String? key) {
    return ThemeModeEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => ThemeModeEnum.light,
    );
  }
}
