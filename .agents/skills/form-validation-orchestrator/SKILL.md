---
name: form-validation-orchestrator
description: |
  Procedural guide for constructing reactive form validation engines using BaseValidator and GenericFormProvider.
  Binds form input controllers to strongly-typed error enums, localized messages, and submission workflows.
  Mandatory trigger conditions:
  - Trigger when creating or refactoring forms, inputs, and validation logic in Flutter.
  - Trigger when binding TextFieldValidator controllers to AppTextField widgets.
  Do NOT trigger when:
  - Do not trigger for read-only catalog views without interactive input fields.
  - Do not trigger for raw database schema design without presentation forms.
license: Apache-2.0
metadata:
  version: 1.0.0
  category: presentation
  publisher: Architecture Standards Team
---

# Form Validation Orchestrator

> Standard: Reactive Form Architecture & Type-Safe Validation  
> Scope: lib/core/validators/, lib/presentation/[feature]/  
> Level: Prescriptive Workflow  

---

## 1. Executive Summary & Objective

This skill standardizes the implementation of reactive, robust form validation across Flutter applications. It decouples form validation logic from UI widgets by leveraging `BaseValidator<T>`, `TextFieldValidator`, and `GenericFormProvider`. It binds input controllers to strongly-typed `ValidationErrorEnum` states, eliminates hardcoded validation error messages through localized builders, and orchestrates asynchronous form submission workflows.

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Creating new user data entry forms (e.g., station registration, telemetry thresholds, account profile).
- Adding complex field validation rules (e.g., regex patterns, min/max length, required flags).
- Managing form submission lifecycles (submitting, success, error toasts).

### 2.2. When to Avoid This Skill
- Building static, read-only dashboard charts or catalog lists.
- Configuring backend database connections or Firestore security rules.
- Writing unit tests for pure domain models without form interaction.

---

## 3. Pre-Flight Verification (Step 0)

Ensure core validation enums and base classes exist:

```bash
# Verify validation error enum and validator directory
ls lib/core/enums/validation_error_enum.dart
ls lib/core/validators/
```

Confirm `ValidationErrorEnum` includes:
- `none`
- `empty`
- `tooShort`
- `tooLong`
- `invalidPattern`

---

## 4. Canonical Specification & Standards

### 4.1. File Structure
```
lib/core/
├── enums/
│   └── validation_error_enum.dart       # strongly-typed validation error enum
└── validators/
    ├── base_validator.dart              # Abstract reactive validator with controller
    └── text_field_validator.dart        # Concrete validator with length, pattern, required constraints

lib/presentation/[feature]/
└── [feature]_form_provider.dart         # Form state manager coordinating multiple validators
```

### 4.2. Invariant Rules
- Validation errors MUST NOT be hardcoded string literals; they MUST evaluate `ValidationErrorEnum` and resolve via `AppLocalizations`.
- Each validator MUST clean up its own `TextEditingController` when disposed.
- Form providers MUST validate all fields before initiating asynchronous save calls.

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Implement BaseValidator Abstraction
Create `lib/core/validators/base_validator.dart`:

```dart
import 'package:flutter/material.dart';
import '../enums/validation_error_enum.dart';

/// Abstract reactive validator binding a TextEditingController to form validation logic.
abstract class BaseValidator<T> extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  ValidationErrorEnum errorType = ValidationErrorEnum.none;
  String? customErrorMessage;

  bool get isValid => errorType == ValidationErrorEnum.none;

  ValidationErrorEnum validate(T value);

  void validateField() {
    errorType = validate(controller.text as T);
    notifyListeners();
  }

  void clearIfValid() {
    final result = validate(controller.text as T);
    if (result == ValidationErrorEnum.none) {
      errorType = ValidationErrorEnum.none;
      customErrorMessage = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

### Step 2: Implement TextFieldValidator
Create `lib/core/validators/text_field_validator.dart`:

```dart
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../enums/validation_error_enum.dart';
import 'base_validator.dart';

/// Concrete reactive validator for text input fields with configurable constraints.
class TextFieldValidator extends BaseValidator<String> {
  final int? minLength;
  final int? maxLength;
  final RegExp? pattern;
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

  String? getErrorMessage(BuildContext context) {
    if (isValid) return null;
    final l10n = AppLocalizations.of(context)!;
    if (customErrorMessage != null) return customErrorMessage;
    return switch (errorType) {
      ValidationErrorEnum.none => null,
      ValidationErrorEnum.empty => l10n.fieldRequiredError,
      ValidationErrorEnum.tooShort => l10n.fieldTooShortError,
      ValidationErrorEnum.tooLong => l10n.fieldTooLongError,
      ValidationErrorEnum.invalidPattern => l10n.fieldInvalidPatternError,
    };
  }
}
```

### Step 3: Implement Feature Form Provider
Create `lib/presentation/stations/station_form_provider.dart`:

```dart
import 'package:flutter/foundation.dart';
import '../../core/enums/form_submission_status_enum.dart';
import '../../core/validators/text_field_validator.dart';
import '../../domain/models/station_model.dart';
import '../../domain/services/station_service.dart';

/// Form state manager managing station creation and editing.
class StationFormProvider extends ChangeNotifier {
  final StationService _service;

  final TextFieldValidator nameValidator = TextFieldValidator(minLength: 3, required: true);
  final TextFieldValidator locationValidator = TextFieldValidator(required: true);

  FormSubmissionStatusEnum _status = FormSubmissionStatusEnum.idle;
  String? _errorMessage;

  StationFormProvider({required StationService service}) : _service = service;

  FormSubmissionStatusEnum get status => _status;
  String? get errorMessage => _errorMessage;

  bool validateAll() {
    nameValidator.validateField();
    locationValidator.validateField();
    return nameValidator.isValid && locationValidator.isValid;
  }

  Future<bool> submit() async {
    if (!validateAll()) return false;

    _status = FormSubmissionStatusEnum.submitting;
    notifyListeners();

    try {
      final model = StationModel(
        id: '',
        name: nameValidator.controller.text.trim(),
        temperature: 0.0,
        status: ItemStatusEnum.active,
      );
      await _service.saveStation(model);
      _status = FormSubmissionStatusEnum.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = FormSubmissionStatusEnum.error;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    nameValidator.controller.clear();
    locationValidator.controller.clear();
    _status = FormSubmissionStatusEnum.idle;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameValidator.dispose();
    locationValidator.dispose();
    super.dispose();
  }
}
```

---

## 6. Edge Cases & Defensive Invariants

| Edge Case | Failure Mode | Defensive Mitigation Protocol |
| :--- | :--- | :--- |
| User taps submit repeatedly | Multiple duplicate save requests sent | Check `status == FormSubmissionStatusEnum.submitting` and immediately ignore additional taps. |
| Form submitted with whitespace only | Database stores empty names | Ensure `.trim()` is executed in both validator and DTO mappings. |
| Screen disposed during asynchronous save | Memory leak or disposed controller crash | Call `dispose()` on all child validators inside the form provider's own `dispose()` method. |

---

## 7. Verification & Quality Gates

Run checks to confirm form validation logic is decoupled from hardcoded strings:

```bash
# Verify no hardcoded string literals inside validator definitions
rg --glob 'lib/core/validators/**' 'return ["'\''][A-Za-z ]+["'\'']'
```

Checklist (see full [references/form-validation-checklist.md](references/form-validation-checklist.md)):
- [ ] `BaseValidator` manages `TextEditingController` and cleans it up on dispose.
- [ ] Error states use `ValidationErrorEnum`.
- [ ] Error messages resolve via `AppLocalizations`.
- [ ] Form submission guards against duplicate concurrent submissions.
- [ ] 100% English code and documentation comments.
