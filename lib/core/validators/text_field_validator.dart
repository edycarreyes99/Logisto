import '../enums/validation_error_enum.dart';
import 'base_validator.dart';

/// Concrete reactive validator for text input fields with configurable constraints.
class TextFieldValidator extends BaseValidator<String> {
  /// Minimum character length required (trimmed).
  final int? minLength;

  /// Maximum character length allowed (trimmed).
  final int? maxLength;

  /// Optional regular expression pattern to validate against.
  final RegExp? pattern;

  /// Whether empty input is treated as an error.
  final bool required;

  TextFieldValidator({
    this.minLength,
    this.maxLength,
    this.pattern,
    this.required = true,
  });

  @override
  ValidationErrorEnum validate(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return required ? ValidationErrorEnum.empty : ValidationErrorEnum.none;
    }
    if (minLength != null && trimmed.length < minLength!) {
      return ValidationErrorEnum.tooShort;
    }
    if (maxLength != null && trimmed.length > maxLength!) {
      return ValidationErrorEnum.tooLong;
    }
    if (pattern != null && !pattern!.hasMatch(trimmed)) {
      return ValidationErrorEnum.invalidPattern;
    }
    return ValidationErrorEnum.none;
  }

  /// Returns a human-readable fallback message in English when localization is not available.
  String? getFallbackErrorMessage() {
    if (isValid) return null;
    if (customErrorMessage != null) return customErrorMessage;
    return switch (errorType) {
      ValidationErrorEnum.none => null,
      ValidationErrorEnum.empty => 'This field is required.',
      ValidationErrorEnum.tooShort =>
        'Input is too short (min $minLength characters).',
      ValidationErrorEnum.tooLong =>
        'Input is too long (max $maxLength characters).',
      ValidationErrorEnum.invalidPattern => 'Input format is invalid.',
      ValidationErrorEnum.invalidNumber =>
        'Please enter a valid numeric value.',
      ValidationErrorEnum.outOfRange => 'Value is out of acceptable range.',
      ValidationErrorEnum.weakPasswordPolicy =>
        'Password must contain at least 6 characters, 1 number, 1 uppercase letter, and 1 special character.',
    };
  }
}

/// Specialized reactive validator for email address format.
class EmailValidator extends TextFieldValidator {
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&' "'" r'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
  );

  EmailValidator({super.required = true})
      : super(pattern: emailRegex);
}

/// Specialized reactive validator for secure password policy:
/// Minimum 6 characters, at least 1 number, at least 1 uppercase letter, at least 1 special character.
class PasswordPolicyValidator extends BaseValidator<String> {
  static final RegExp _hasNumber = RegExp(r'[0-9]');
  static final RegExp _hasUppercase = RegExp(r'[A-Z]');
  static final RegExp _hasSpecialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-=+]');

  @override
  ValidationErrorEnum validate(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return ValidationErrorEnum.empty;
    }
    if (trimmed.length < 6) {
      return ValidationErrorEnum.tooShort;
    }
    if (!_hasNumber.hasMatch(trimmed) ||
        !_hasUppercase.hasMatch(trimmed) ||
        !_hasSpecialChar.hasMatch(trimmed)) {
      return ValidationErrorEnum.weakPasswordPolicy;
    }
    return ValidationErrorEnum.none;
  }
}
