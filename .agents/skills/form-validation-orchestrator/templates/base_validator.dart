import 'package:flutter/material.dart';

/// Error enum representation for form inputs.
enum ValidationErrorEnum {
  none,
  empty,
  tooShort,
  tooLong,
  invalidPattern;
}

/// Abstract reactive validator binding a TextEditingController to form validation logic.
abstract class BaseValidator<T> extends ChangeNotifier {
  /// The text editing controller bound to the input widget.
  final TextEditingController controller = TextEditingController();

  /// Current validation error enum state.
  ValidationErrorEnum errorType = ValidationErrorEnum.none;

  /// Optional custom localized error message override.
  String? customErrorMessage;

  /// Indicates whether the current input passes validation.
  bool get isValid => errorType == ValidationErrorEnum.none;

  /// Validates the provided value according to concrete rules.
  ///
  /// - [value]: Value to validate.
  /// Returns a [ValidationErrorEnum] reflecting the result.
  ValidationErrorEnum validate(T value);

  /// Executes validation against the current controller text and notifies listeners.
  void validateField() {
    errorType = validate(controller.text as T);
    notifyListeners();
  }

  /// Clears active errors if the current controller text passes validation.
  void clearIfValid() {
    final result = validate(controller.text as T);
    if (result == ValidationErrorEnum.none) {
      errorType = ValidationErrorEnum.none;
      customErrorMessage = null;
      notifyListeners();
    }
  }

  @override
  /// Releases controllers, subscriptions, and active listeners.
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
