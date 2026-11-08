/// Strongly-typed state status enum for catalog and feature views.
enum FeatureStatusEnum {
  /// Idle state prior to initialization.
  idle,

  /// Asynchronous data retrieval in progress.
  loading,

  /// Data stream loaded and active.
  loaded,

  /// Operation completed successfully.
  success,

  /// Operational error encountered.
  error;

  /// Whether asynchronous retrieval is actively executing.
  bool get isLoading => this == FeatureStatusEnum.loading;

  /// Whether data has completed loading.
  bool get isLoaded => this == FeatureStatusEnum.loaded;

  /// Whether an operational error occurred.
  bool get isError => this == FeatureStatusEnum.error;
}
