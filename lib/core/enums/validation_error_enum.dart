/// Strongly-typed validation error categorization for input forms.
enum ValidationErrorEnum {
  /// Input is valid without errors.
  none(storageKey: 'none'),

  /// Field is required but empty.
  empty(storageKey: 'empty'),

  /// Input string length is below minimum required characters.
  tooShort(storageKey: 'too_short'),

  /// Input string length exceeds maximum allowable characters.
  tooLong(storageKey: 'too_long'),

  /// Input does not match the required regex pattern (e.g. email, phone).
  invalidPattern(storageKey: 'invalid_pattern'),

  /// Input could not be parsed as a valid numeric value.
  invalidNumber(storageKey: 'invalid_number'),

  /// Numeric input falls outside acceptable range boundary.
  outOfRange(storageKey: 'out_of_range'),

  /// Password does not satisfy security policy (uppercase, number, special char).
  weakPasswordPolicy(storageKey: 'weak_password_policy');

  /// Storage key for database persistence.
  final String storageKey;

  const ValidationErrorEnum({required this.storageKey});

  /// Resolves [ValidationErrorEnum] from [storageKey] with fallback to [none].
  static ValidationErrorEnum fromStorageKey(String? key) {
    return ValidationErrorEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => ValidationErrorEnum.none,
    );
  }
}
