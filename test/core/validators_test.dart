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

  group('EmailValidator & PasswordPolicyValidator Tests', () {
    test('EmailValidator validates RFC-compliant emails correctly', () {
      final validator = EmailValidator();

      expect(validator.validate(''), equals(ValidationErrorEnum.empty));
      expect(validator.validate('notanemail'), equals(ValidationErrorEnum.invalidPattern));
      expect(validator.validate('test@'), equals(ValidationErrorEnum.invalidPattern));
      expect(validator.validate('@domain.com'), equals(ValidationErrorEnum.invalidPattern));
      expect(validator.validate('admin@logisto.io'), equals(ValidationErrorEnum.none));
      expect(validator.validate('user.name+tag@example.com'), equals(ValidationErrorEnum.none));
    });

    test('PasswordPolicyValidator enforces 6 chars, uppercase, number, and special char', () {
      final validator = PasswordPolicyValidator();

      expect(validator.validate(''), equals(ValidationErrorEnum.empty));
      expect(validator.validate('12345'), equals(ValidationErrorEnum.tooShort));
      // Missing uppercase and special char
      expect(validator.validate('abcdef123'), equals(ValidationErrorEnum.weakPasswordPolicy));
      // Missing number and special char
      expect(validator.validate('Abcdefgh'), equals(ValidationErrorEnum.weakPasswordPolicy));
      // Missing special char
      expect(validator.validate('Abcdef123'), equals(ValidationErrorEnum.weakPasswordPolicy));
      // Missing number
      expect(validator.validate('Abcdef!@#'), equals(ValidationErrorEnum.weakPasswordPolicy));
      // Compliant: >=6 chars, uppercase, number, special char
      expect(validator.validate('Secret123!'), equals(ValidationErrorEnum.none));
      expect(validator.validate('P@ssw0rd'), equals(ValidationErrorEnum.none));
    });
  });
}
