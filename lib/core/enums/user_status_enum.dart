/// Strongly-typed employment/access status of a corporate user profile.
enum UserStatusEnum {
  active(storageKey: 'active'),
  inactive(storageKey: 'inactive'),
  suspended(storageKey: 'suspended');

  final String storageKey;

  const UserStatusEnum({required this.storageKey});

  /// Resolves [UserStatusEnum] safely from [storageKey] with fallback to [active].
  static UserStatusEnum fromStorageKey(String? key) {
    return UserStatusEnum.values.firstWhere(
      (e) => e.storageKey == key,
      orElse: () => UserStatusEnum.active,
    );
  }
}
