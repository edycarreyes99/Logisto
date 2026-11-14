import 'package:flutter_test/flutter_test.dart';
import 'package:logisto/core/enums/validation_error_enum.dart';
import 'package:logisto/core/validators/text_field_validator.dart';

void main() {
  group('TextFieldValidator Tests', () {
    test('validates required empty input', () {
      final validator = TextFieldValidator(required: true);
      expect(validator.validate(''), ValidationErrorEnum.empty);
      expect(validator.validate('   '), ValidationErrorEnum.empty);
      expect(validator.validate('hello'), ValidationErrorEnum.none);
      validator.dispose();
    });

    test('validates optional empty input', () {
      final validator = TextFieldValidator(required: false);
      expect(validator.validate(''), ValidationErrorEnum.none);
      expect(validator.validate('   '), ValidationErrorEnum.none);
      validator.dispose();
    });

    test('validates minimum and maximum length constraints', () {
      final validator = TextFieldValidator(minLength: 3, maxLength: 8);
      expect(validator.validate('ab'), ValidationErrorEnum.tooShort);
      expect(validator.validate('abc'), ValidationErrorEnum.none);
      expect(validator.validate('12345678'), ValidationErrorEnum.none);
      expect(validator.validate('123456789'), ValidationErrorEnum.tooLong);
      validator.dispose();
    });

    test('validates regular expression pattern', () {
      final validator = TextFieldValidator(pattern: RegExp(r'^[a-zA-Z0-9]+$'));
      expect(validator.validate('abc123'), ValidationErrorEnum.none);
      expect(validator.validate('abc 123'), ValidationErrorEnum.invalidPattern);
      expect(validator.validate('abc@def'), ValidationErrorEnum.invalidPattern);
      validator.dispose();
    });

    test('updates controller and fires reactive listeners', () {
      final validator = TextFieldValidator(required: true, minLength: 4);
      int listenerCalls = 0;
      validator.addListener(() => listenerCalls++);

      validator.controller.text = 'abc';
      validator.validateField();

      expect(listenerCalls, 1);
      expect(validator.isValid, isFalse);
      expect(validator.errorType, ValidationErrorEnum.tooShort);
      expect(validator.getFallbackErrorMessage(), contains('min 4'));

      validator.controller.text = 'abcd';
      validator.clearIfValid();
      expect(listenerCalls, 2);
      expect(validator.isValid, isTrue);
      expect(validator.getFallbackErrorMessage(), isNull);

      validator.reset();
      expect(validator.controller.text, isEmpty);
      expect(validator.isValid, isTrue);

      validator.dispose();
    });
  });
}
