import 'package:flutter/material.dart';
import 'base_validator.dart';

/// Concrete reactive validator for text input fields with configurable constraints.
class TextFieldValidator extends BaseValidator<String> {
  /// Minimum character length required.
  final int? minLength;

  /// Maximum character length permitted.
  final int? maxLength;

  /// Regular expression pattern to validate against.
  final RegExp? pattern;

  /// Whether non-empty content is strictly required.
  final bool required;

  /// Creates a [TextFieldValidator] instance.
  TextFieldValidator({
    this.minLength,
    this.maxLength,
    this.pattern,
    this.required = true,
  });

  @override
  /// Evaluates input text against constraints.
  ValidationErrorEnum validate(String value) {
    final trimmed = value.trim();

    if (required && trimmed.isEmpty) {
      return ValidationErrorEnum.empty;
    }

    if (!required && trimmed.isEmpty) {
      return ValidationErrorEnum.none;
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
}
