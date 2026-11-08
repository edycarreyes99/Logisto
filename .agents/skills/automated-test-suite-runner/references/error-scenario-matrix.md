# Enterprise Defensive Error Scenario Testing Matrix

> Standard: Zero Untested Failure Modes across Flutter Multiplatform Applications  
> Rule Association: [../../../rules/rule-test-coverage-enforcement.md](../../../rules/rule-test-coverage-enforcement.md)  
> Scope: Unit, Widget, and Integration Test Engineering  

---

## 1. Overview & Objective

To satisfy `RULE-QUAL-001`, testing happy paths alone is strictly prohibited. Every layer of the application must be verified against negative inputs, boundary conditions, platform degradation, and asynchronous error flows. This matrix provides the mandatory defensive test cases that every module must implement.

---

## 2. Layer-by-Layer Mandatory Error Scenarios

### 2.1. Domain Layer (Models & Services)

| Module Type | Failure Scenario | Expected Behavior | Assertion Pattern |
| :--- | :--- | :--- | :--- |
| **Domain Model** | Missing or null JSON properties | Factory constructor falls back to sensible defaults or throws `FormatException` | `expect(model.title, isEmpty)` |
| **Domain Model** | Unknown enum key in JSON | Safe fallback via `fromStorageKey` or `fromCode` | `expect(model.status, ItemStatusEnum.draft)` |
| **Domain Service** | Empty or whitespace string parameter | Method rejects input immediately without invoking repository | `expect(() => service.save(' '), throwsA(isA<ArgumentError>()))` |
| **Domain Service** | Numeric value below minimum bound (e.g. negative value) | Method throws `ArgumentError` with descriptive message | `expect(() => service.save(item), throwsA(isA<ArgumentError>()))` |
| **Domain Service** | Repository throws database exception | Exception propagates or transforms into Domain error without crashing process | `expect(() => service.fetch(), throwsA(isA<DomainException>()))` |

### 2.2. Core Layer (Validators & Formatters)

| Component | Failure Scenario | Expected Behavior | Assertion Pattern |
| :--- | :--- | :--- | :--- |
| **BaseValidator** | Empty string on required field | Emits `ValidationErrorEnum.empty` | `expect(validator.validate(''), ValidationErrorEnum.empty)` |
| **TextFieldValidator** | String shorter than `minLength` | Emits `ValidationErrorEnum.tooShort` | `expect(validator.validate('ab'), ValidationErrorEnum.tooShort)` |
| **TextFieldValidator** | String exceeding `maxLength` | Emits `ValidationErrorEnum.tooLong` | `expect(validator.validate('a'*100), ValidationErrorEnum.tooLong)` |
| **TextFieldValidator** | Regex pattern mismatch | Emits `ValidationErrorEnum.invalidPattern` | `expect(validator.validate('bad!'), ValidationErrorEnum.invalidPattern)` |
| **Formatters** | Malformed numerical strings | Safe fallback to 0.0 or unchanged input without `FormatException` crash | `expect(formatter.format('xyz'), equals('0.00'))` |

### 2.3. Data Layer (DTOs, Repositories & Preferences)

| Component | Failure Scenario | Expected Behavior | Assertion Pattern |
| :--- | :--- | :--- | :--- |
| **Firestore DTO** | DocumentSnapshot data is null | Constructor defaults all primitives and gracefully handles null timestamp | `expect(dto.title, equals(''))` |
| **Firestore Repository** | Network timeout or Firestore unavailable | Query falls back to local cache or throws specific timeout exception | `expect(() => repo.getById('id'), throwsA(isA<TimeoutException>()))` |
| **Firestore Repository** | Security rules permission denied | Repository handles permission error and emits meaningful failure | `expect(() => repo.save(item), throwsA(isA<FirebaseException>()))` |
| **Preference Wrapper** | Corrupted or missing storage value | Getter returns non-null default Enum or empty string | `expect(prefs.getLanguage(), equals(LanguageEnum.en))` |

### 2.4. Presentation Layer (Providers & Widgets)

| Component | Failure Scenario | Expected Behavior | Assertion Pattern |
| :--- | :--- | :--- | :--- |
| **Catalog Provider** | Stream emits error event | Sets status to `FeatureStatusEnum.error` and updates `errorMessage` | `expect(provider.status, FeatureStatusEnum.error)` |
| **Form Provider** | Submission with invalid fields | Blocks submission, marks invalid fields, and triggers localized notification | `expect(provider.isValid, isFalse)` |
| **Short Widget** | Zero items in dataset | Renders dedicated localized `[ProjectPrefix]EmptyState` widget | `expect(find.byType(AppEmptyState), findsOneWidget)` |
| **Short Widget** | Error status emitted | Displays user-facing retry button and localized error banner | `expect(find.text('Retry'), findsOneWidget)` |
| **AppButton** | Rapid duplicate tap | Debounce guard prevents duplicate async invocations | `verify(() => service.submit()).called(1)` |

---

## 3. Defensive Invariant Assertions Checklist

- [ ] Every constructor with validation logic has an accompanying negative test.
- [ ] Every async method has tests verifying timeout and exception paths.
- [ ] Every stream has tests verifying error emission and stream cancellation.
- [ ] Every widget test asserts on loading, error, and empty states.
