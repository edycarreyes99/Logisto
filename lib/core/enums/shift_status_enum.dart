/// Strongly-typed operational status for cashier shifts.
enum ShiftStatusEnum {
  /// Shift is currently open and accepting transactions.
  open(storageKey: 'open'),

  /// Shift has undergone blind drop and is closed.
  closed(storageKey: 'closed');

  /// Storage key for database persistence.
  final String storageKey;

  const ShiftStatusEnum({required this.storageKey});

  /// Resolves [ShiftStatusEnum] from [storageKey] with fallback to [open].
  static ShiftStatusEnum fromStorageKey(String? key) {
    return ShiftStatusEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => ShiftStatusEnum.open,
    );
  }
}

/// Strongly-typed reconciliation outcome for cash register blind drops.
enum ShiftDiscrepancyEnum {
  /// Physical count matches mathematical expected balance exactly.
  balanced(storageKey: 'balanced'),

  /// Cash count is less than expected (shortage/faltante).
  shortage(storageKey: 'shortage'),

  /// Cash count is greater than expected (surplus/sobrante).
  surplus(storageKey: 'surplus');

  /// Storage key for database persistence.
  final String storageKey;

  const ShiftDiscrepancyEnum({required this.storageKey});

  /// Resolves [ShiftDiscrepancyEnum] from [storageKey] with fallback to [balanced].
  static ShiftDiscrepancyEnum fromStorageKey(String? key) {
    return ShiftDiscrepancyEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => ShiftDiscrepancyEnum.balanced,
    );
  }
}
