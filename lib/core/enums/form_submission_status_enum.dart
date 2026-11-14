/// Strongly-typed lifecycle status for reactive form submission.
enum FormSubmissionStatusEnum {
  /// Idle state prior to user submission.
  idle(storageKey: 'idle'),

  /// Submission in progress.
  submitting(storageKey: 'submitting'),

  /// Submission succeeded.
  success(storageKey: 'success'),

  /// Submission failed with validation or server error.
  error(storageKey: 'error');

  /// Storage key for database or state persistence.
  final String storageKey;

  const FormSubmissionStatusEnum({required this.storageKey});

  /// Resolves [FormSubmissionStatusEnum] from [storageKey] with fallback to [idle].
  static FormSubmissionStatusEnum fromStorageKey(String? key) {
    return FormSubmissionStatusEnum.values.firstWhere(
      (element) => element.storageKey == key,
      orElse: () => FormSubmissionStatusEnum.idle,
    );
  }
}
