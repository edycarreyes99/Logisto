/// Strongly-typed state status enum for catalog, dashboard, and feature views.
enum FeatureStatusEnum {
  /// Idle state prior to initialization.
  idle(storageKey: 'idle'),

  /// Asynchronous data retrieval in progress.
  loading(storageKey: 'loading'),

  /// Data stream loaded and active.
  loaded(storageKey: 'loaded'),

  /// Failure state with error message.
  error(storageKey: 'error');

  /// Storage key for database or state persistence.
  final String storageKey;

  const FeatureStatusEnum({required this.storageKey});

  /// Resolves [FeatureStatusEnum] from [storageKey] with fallback to [idle].
  static FeatureStatusEnum fromStorageKey(String? key) {
    return FeatureStatusEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => FeatureStatusEnum.idle,
    );
  }
}
