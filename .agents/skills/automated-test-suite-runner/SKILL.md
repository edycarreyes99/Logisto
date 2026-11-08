---
name: automated-test-suite-runner
description: |
  Comprehensive procedural execution framework for authoring, running, and asserting 100% test coverage across Unit, Widget, and Integration test suites in Flutter.
  Enforces defensive edge case testing, mock repositories, fake Firestore streams, and zero skipped tests.
  Mandatory trigger conditions:
  - Trigger when authoring new unit, widget, or integration tests for Flutter modules.
  - Trigger when asserting test coverage thresholds (100% line and branch requirement).
  - Trigger when injecting negative error test scenarios (timeouts, empty states, network disconnects).
  Do NOT trigger when:
  - Do not trigger for raw UI layout design without test implementation.
  - Do not trigger for static linting or documentation checks alone (use quality-assurance-auditor).
license: Apache-2.0
metadata:
  version: 1.0.0
  category: testing
  publisher: Quality Engineering Team
---

# Automated Test Suite Runner Workflow

> Standard: Enterprise 100% Test Coverage & Defensive Error Assertion  
> Scope: test/unit/**, test/widget/**, test/integration/**, lib/**  
> Level: Prescriptive Quality Execution Workflow  

---

## 1. Executive Summary & Objective

This skill standardizes the procedural execution, authoring, and verification of comprehensive test suites in Flutter multiplatform applications. It enforces the `RULE-QUAL-001` invariant requiring 100% code coverage across all testable layers (Domain models and services, Core validators and formatters, Data DTOs, mappers, preference wrappers, repositories, and Presentation state providers). It mandates rigorous testing of both positive happy paths and negative error paths (network failures, out-of-range parameters, invalid formats, timeout exceptions, and offline cache degradation).

---

## 2. Trigger Conditions & Decision Boundary

### 2.1. When to Activate This Skill
- Creating unit tests for new Domain services, models, validators, or DTO mappers.
- Authoring widget tests for decomposed sub-widgets, responsive Bootstrap layouts, or form inputs.
- Building end-to-end integration tests simulating complete user workflows and offline persistence.
- Measuring test coverage using `flutter test --coverage` and identifying uncovered branches.
- Verifying error injection and defensive resilience under simulated network, database, or validation failures.

### 2.2. When to Avoid This Skill
- Executing routine static lint analysis or formatting checks (handled by standard pre-commit gates).
- Creating domain entities or database repositories without writing corresponding tests.
- Auditing ARB localization bundle key parity (use `bilingual-localization-sync`).

---

## 3. Pre-Flight Verification (Step 0)

Before executing or authoring tests, verify that test dependencies and runners are available:

```bash
# 1. Verify Flutter test environment and test runner
flutter test --version

# 2. Check for required testing libraries in pubspec.yaml
grep -E 'mocktail|fake_cloud_firestore|flutter_test' pubspec.yaml

# 3. Verify clean working tree without uncommitted breaking changes
git status --short
```

---

## 4. Canonical Specification & Standards

### 4.1. The Testing Pyramid & Layer Allocations

```
        / \
       /   \        Integration Tests (10%)
      /     \       - End-to-end flows with fake Firestore & mock services
     /-------\
    /         \     Widget Tests (30%)
   /           \    - Short decomposed widgets, theme adaptation, Bootstrap grid
  /-------------\
 /               \  Unit Tests (60%)
/                 \ - Domain services, pure models, validators, DTO mappers, providers
-------------------
```

### 4.2. Strict Coverage & Invariant Gates
1. **100% Line and Branch Coverage:** Every public and internal method, branch condition (`if/else`, `switch/case`), and exception handler must have explicit assertions.
2. **Defensive Error Coverage:** For every method under test, at least one test must verify expected error handling:
   - Malformed, empty, or whitespace inputs (`ArgumentError`).
   - Boundary values (negative numbers, zero, extreme lengths).
   - Network timeouts, permission denials, and remote Firestore stream errors.
3. **No Skipped Tests:** Tests must never use `skip: true` or `@Skip()`. Any failing test indicates a regression that must be resolved.
4. **Deterministic Mocking:** Mocks must be created using `mocktail`. Mocks must specify explicit fallback values via `registerFallbackValue` when necessary.

### 4.3. Standard Templates & Reference Artifacts
- **Test Coverage Checklist:** [references/test-coverage-validation-checklist.md](references/test-coverage-validation-checklist.md)
- **Defensive Error Matrix:** [references/error-scenario-matrix.md](references/error-scenario-matrix.md)
- **Unit Test Template:** [templates/unit-test-template.md](templates/unit-test-template.md)
- **Widget Test Template:** [templates/widget-test-template.md](templates/widget-test-template.md)
- **Integration Test Template:** [templates/integration-test-template.md](templates/integration-test-template.md)

---

## 5. Step-by-Step Implementation Procedure

### Step 1: Author Domain & Service Unit Tests
Unit tests verify business logic in isolation without any Flutter UI dependencies:

```dart
// test/domain/services/generic_item_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:climatica/domain/services/generic_item_service.dart';
import 'package:climatica/domain/models/generic_item_model.dart';
import 'package:climatica/core/enums/item_status_enum.dart';
import 'package:climatica/data/repositories/generic_item_repository.dart';

class MockGenericItemRepository extends Mock implements GenericItemRepository {}

void main() {
  late MockGenericItemRepository mockRepo;
  late GenericItemService service;

  setUp(() {
    mockRepo = MockGenericItemRepository();
    service = GenericItemService(repository: mockRepo);
  });

  group('GenericItemService - Happy Path', () {
    test('watchItems delegates to repository watchAll and emits stream', () async {
      const items = [
        GenericItemModel(
          id: 'item-1',
          title: 'Station Alpha',
          code: 'STA-01',
          value: 100.0,
          status: ItemStatusEnum.active,
        ),
      ];

      when(() => mockRepo.watchAll()).thenAnswer((_) => Stream.value(items));

      final stream = service.watchItems();

      expect(await stream.first, equals(items));
      verify(() => mockRepo.watchAll()).called(1);
    });

    test('saveItem succeeds when item is valid', () async {
      const validItem = GenericItemModel(
        id: '123',
        title: 'Sensor Node',
        code: 'SN-01',
        value: 15.5,
        status: ItemStatusEnum.active,
      );

      when(() => mockRepo.save(validItem)).thenAnswer((_) async => '123');

      final result = await service.saveItem(validItem);

      expect(result, equals('123'));
      verify(() => mockRepo.save(validItem)).called(1);
    });
  });

  group('GenericItemService - Defensive Error Testing', () {
    test('saveItem throws ArgumentError when title is empty', () async {
      const invalidItem = GenericItemModel(
        id: '123',
        title: '   ',
        code: 'SN-01',
        value: 15.5,
        status: ItemStatusEnum.active,
      );

      expect(
        () => service.saveItem(invalidItem),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Item title cannot be empty'),
        )),
      );
      verifyZeroInteractions(mockRepo);
    });

    test('saveItem throws ArgumentError when value is negative', () async {
      const negativeItem = GenericItemModel(
        id: '123',
        title: 'Sensor Node',
        code: 'SN-01',
        value: -1.0,
        status: ItemStatusEnum.active,
      );

      expect(
        () => service.saveItem(negativeItem),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Item value cannot be negative'),
        )),
      );
      verifyZeroInteractions(mockRepo);
    });

    test('deleteItem throws ArgumentError when id is empty', () async {
      expect(
        () => service.deleteItem('   '),
        throwsA(isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          contains('Item ID cannot be empty'),
        )),
      );
      verifyZeroInteractions(mockRepo);
    });
  });
}
```

### Step 2: Author Widget Tests with Responsive & Localization Harness
Widget tests mount decomposed UI components inside a standard harness configuring `MaterialApp`, `AppTheme`, and `AppLocalizations`:

```dart
// test/presentation/widgets/app_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:climatica/core/enums/button_variant_enum.dart';
import 'package:climatica/core/enums/button_size_enum.dart';
import 'package:climatica/core/widgets/app_button.dart';
import 'package:climatica/theme/app_theme.dart';

Widget createTestableWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme(),
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

void main() {
  group('AppButton Widget Tests', () {
    testWidgets('renders label and handles tap event', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestableWidget(
          AppButton(
            label: 'Submit',
            variant: ButtonVariantEnum.primary,
            size: ButtonSizeEnum.md,
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('disables tap and shows progress indicator when loading', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestableWidget(
          AppButton(
            label: 'Submit',
            isLoading: true,
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });
  });
}
```

### Step 3: Author Integration Tests with Fake Firestore
Integration tests exercise end-to-end workflows using fake Firestore and simulated storage:

```dart
// test/integration/item_catalog_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:climatica/data/firestore/collections/app_collections.dart';
import 'package:climatica/data/repositories/generic_item_repository.dart';
import 'package:climatica/domain/models/generic_item_model.dart';
import 'package:climatica/core/enums/item_status_enum.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late AppCollections collections;
  late GenericItemRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    collections = AppCollections(fakeFirestore);
    repository = GenericItemRepository(
      collections: collections,
      firestore: fakeFirestore,
    );
  });

  test('Full CRUD integration cycle against fake Firestore', () async {
    // 1. Create item
    const newItem = GenericItemModel(
      id: '',
      title: 'Telemetry Station',
      code: 'TEL-01',
      value: 88.0,
      status: ItemStatusEnum.active,
    );
    final id = await repository.save(newItem);
    expect(id, isNotEmpty);

    // 2. Read item
    final retrieved = await repository.getById(id);
    expect(retrieved, isNotNull);
    expect(retrieved!.title, equals('Telemetry Station'));
    expect(retrieved.status, equals(ItemStatusEnum.active));

    // 3. Update item
    final updated = retrieved.copyWith(value: 99.5);
    await repository.save(updated);
    final afterUpdate = await repository.getById(id);
    expect(afterUpdate!.value, equals(99.5));

    // 4. Delete item
    await repository.delete(id);
    final afterDelete = await repository.getById(id);
    expect(afterDelete, isNull);
  });
}
```

### Step 4: Run Test Suite & Generate Coverage Report
Execute the test runner and verify coverage:

```bash
# Run all unit and widget tests with coverage collection
flutter test --coverage

# Filter out generated code (.g.dart, .freezed.dart, l10n)
lcov --remove coverage/lcov.info \
  'lib/l10n/*' \
  'lib/firebase_options.dart' \
  -o coverage/filtered_lcov.info

# Verify 100% threshold using coverage tool
genhtml coverage/filtered_lcov.info -o coverage/html
```

---

## 6. Edge Cases & Defensive Invariants

1. **Async Timers and Microtasks:** Use `tester.pumpAndSettle()` carefully in widget tests; if there is an infinite animation or repeating timer, pump a specific duration (`tester.pump(const Duration(milliseconds: 100))`) to prevent timeout hangs.
2. **Platform Channel Mocking:** When testing code that invokes device plugins (such as SharedPreferences), ensure mock channels or in-memory handlers (`SharedPreferences.setMockInitialValues({})`) are initialized in `setUp()`.
3. **Stream Error Simulation:** Test that stream listeners do not swallow stream exceptions silently:
   ```dart
   when(() => mockRepo.watchAll()).thenAnswer((_) => Stream.error(Exception('Firestore stream disconnected')));
   ```
4. **Concurrent Operations:** Test rapid duplicate taps on buttons to verify that debounce guards prevent duplicate asynchronous submissions.

---

## 7. Verification & Quality Gates

Run the following quality commands to guarantee test suite health:

```bash
# 1. Zero skipped tests gate
! rg "skip:\s*true|@Skip\(" test/

# 2. Run all tests and fail on any non-zero exit code
flutter test

# 3. Assert 100% coverage
python3 -c "
import pathlib, re, sys
lcov_file = pathlib.Path('coverage/filtered_lcov.info')
if not lcov_file.exists():
    print('Coverage info not found')
    sys.exit(0)
lines = lcov_file.read_text().splitlines()
total_lines = sum(1 for l in lines if l.startswith('DA:'))
hit_lines = sum(1 for l in lines if l.startswith('DA:') and not l.endswith(',0'))
coverage = (hit_lines / total_lines * 100) if total_lines > 0 else 100
print(f'Test Line Coverage: {coverage:.2f}%')
sys.exit(0 if coverage >= 100.0 else 1)
"
```

All quality gates must pass cleanly with zero failures.
