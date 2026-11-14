/// Strongly-typed business unit commercial specialty discriminator.
enum BusinessTypeEnum {
  /// Billiard hall or pool room with timed table stations.
  billiard(storageKey: 'billiard'),

  /// Retail commercial store.
  retail(storageKey: 'retail'),

  /// Pharmacy with batch numbers and expiration tracking.
  pharmacy(storageKey: 'pharmacy'),

  /// Restaurant, bar, or kitchen venue.
  restaurant(storageKey: 'restaurant'),

  /// General commercial enterprise.
  general(storageKey: 'general');

  /// Storage key for database persistence.
  final String storageKey;

  const BusinessTypeEnum({required this.storageKey});

  /// Resolves [BusinessTypeEnum] from [storageKey] safely with fallback to [general].
  static BusinessTypeEnum fromStorageKey(String? key) {
    return BusinessTypeEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => BusinessTypeEnum.general,
    );
  }
}
