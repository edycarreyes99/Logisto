import 'package:flutter/widgets.dart';
import '../enums/validation_error_enum.dart';

/// Abstract reactive validator binding a [TextEditingController] to strongly-typed validation logic.
abstract class BaseValidator<T> extends ChangeNotifier {
  /// Internal text editing controller for input binding.
  final TextEditingController controller = TextEditingController();

  /// Current validation error state.
  ValidationErrorEnum errorType = ValidationErrorEnum.none;

  /// Optional custom localized message overriding the standard error text.
  String? customErrorMessage;

  /// Returns true when current input passes all validation constraints.
  bool get isValid => errorType == ValidationErrorEnum.none;

  /// Validates the provided [value] against concrete validation rules.
  ValidationErrorEnum validate(T value);

  /// Parses the raw string from [controller.text] into type [T].
  /// Subclasses may override this to parse numbers, dates, or other non-String types.
  @protected
  T parseValue(String text) => text as T;

  /// Validates the current text in [controller] and notifies listeners of state changes.
  void validateField() {
    errorType = validate(parseValue(controller.text));
    notifyListeners();
  }

  /// Clears any error if the current value is now valid.
  void clearIfValid() {
    final result = validate(parseValue(controller.text));
    if (result == ValidationErrorEnum.none) {
      errorType = ValidationErrorEnum.none;
      customErrorMessage = null;
      notifyListeners();
    }
  }

  /// Resets the validator to initial clean state.
  void reset() {
    controller.clear();
    errorType = ValidationErrorEnum.none;
    customErrorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
