/// Strongly-typed lifecycle status for open accounts and bar tabs.
enum AccountStatusEnum {
  /// Tab is active, receiving new items and timer increments.
  open(storageKey: 'open'),

  /// Tab is frozen for invoice settlement.
  billing(storageKey: 'billing'),

  /// Tab has been fully settled and paid.
  closed(storageKey: 'closed'),

  /// Tab was voided by supervisor authority.
  voided(storageKey: 'voided');

  /// Storage key for database persistence.
  final String storageKey;

  const AccountStatusEnum({required this.storageKey});

  /// Resolves [AccountStatusEnum] from [storageKey] with fallback to [open].
  static AccountStatusEnum fromStorageKey(String? key) {
    return AccountStatusEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => AccountStatusEnum.open,
    );
  }
}
